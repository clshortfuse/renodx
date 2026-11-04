#pragma once

#pragma comment(lib, "version.lib")

#include <cassert>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <dxgi1_6.h>
#include <iterator>
#include <limits>
#include <memory>
#include <new>
#include <shellapi.h>
#include <utility>
#include <windows.h>
#include <winver.h>
#if WIN32
#include <shlobj.h>
#endif

#include <algorithm>
#include <filesystem>
#include <map>
#include <optional>
#include <ranges>
#include <string>
#include <vector>

namespace renodx::utils::platform {

// A pinned module cannot be unloaded before process exit; do not call this for temporary references.
inline bool PinModule(const void* address) {
  HMODULE module = nullptr;
  return ::GetModuleHandleExW(
             GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_PIN,
             reinterpret_cast<LPCWSTR>(address), &module)
         != FALSE
         && module != nullptr;
}

template <typename T>
struct ProcessAllocator {
  using value_type = T;

  constexpr ProcessAllocator() noexcept = default;

  template <typename U>
  explicit constexpr ProcessAllocator(const ProcessAllocator<U>& other) noexcept {
    (void)other;
  }

  [[nodiscard]] T* allocate(std::size_t count) {  // NOLINT(readability-identifier-naming)
    constexpr std::size_t padding = (alignof(T) > MEMORY_ALLOCATION_ALIGNMENT
                                        ? alignof(T) - 1 + sizeof(void*)
                                        : 0);
    if (count > ((std::numeric_limits<std::size_t>::max)() - padding) / sizeof(T)) {
      throw std::bad_array_new_length();
    }

    auto* storage = static_cast<T*>(::HeapAlloc(::GetProcessHeap(), 0, (count * sizeof(T)) + padding));
    if (storage == nullptr) {
      throw std::bad_alloc();
    }
    if constexpr (alignof(T) > MEMORY_ALLOCATION_ALIGNMENT) {
      // Container nodes can themselves contain over-aligned parallel maps.
      const auto address = reinterpret_cast<std::uintptr_t>(storage) + sizeof(void*);
      const auto aligned_address = (address + alignof(T) - 1) & ~(static_cast<std::uintptr_t>(alignof(T)) - 1);
      reinterpret_cast<void**>(aligned_address)[-1] = storage;
      return reinterpret_cast<T*>(aligned_address);
    }
    return storage;
  }

  void deallocate(T* storage, std::size_t count) noexcept {  // NOLINT(readability-identifier-naming)
    (void)count;
    if (storage == nullptr) return;
    void* allocation = storage;
    if constexpr (alignof(T) > MEMORY_ALLOCATION_ALIGNMENT) {
      allocation = reinterpret_cast<void**>(storage)[-1];
    }
    ::HeapFree(::GetProcessHeap(), 0, allocation);
  }
};

template <typename T, typename U>
inline bool operator==(const ProcessAllocator<T>& left, const ProcessAllocator<U>& right) noexcept {
  (void)left;
  (void)right;
  return true;
}

template <typename T, typename U>
inline bool operator!=(const ProcessAllocator<T>& left, const ProcessAllocator<U>& right) noexcept {
  (void)left;
  (void)right;
  return false;
}

template <typename T, typename... Args>
inline T* CreateSharedObject(Args&&... args) {
  constexpr std::size_t padding = (alignof(T) > MEMORY_ALLOCATION_ALIGNMENT
                                      ? alignof(T) - 1 + sizeof(void*)
                                      : 0);
  static_assert(sizeof(T) <= (std::numeric_limits<std::size_t>::max)() - padding);
  // Keep the original heap pointer until construction succeeds, including on exceptions.
  std::unique_ptr<void, decltype([](void* allocation) {
                    ::HeapFree(::GetProcessHeap(), 0, allocation);
                  })>
      allocation(::HeapAlloc(::GetProcessHeap(), HEAP_ZERO_MEMORY, sizeof(T) + padding));
  auto* storage = static_cast<T*>(allocation.get());
  if (storage == nullptr) {
    ::OutputDebugStringA("RenoDX: shared-object process-heap allocation failed.\n");
  }
  assert(storage != nullptr);
  if (storage == nullptr) return nullptr;

  if constexpr (alignof(T) > MEMORY_ALLOCATION_ALIGNMENT) {
    // HeapAlloc guarantees only 8-byte alignment on x86 (16 on x64).
    const auto address = reinterpret_cast<std::uintptr_t>(storage) + sizeof(void*);
    const auto aligned_address = (address + alignof(T) - 1) & ~(static_cast<std::uintptr_t>(alignof(T)) - 1);
    storage = reinterpret_cast<T*>(aligned_address);
    reinterpret_cast<void**>(storage)[-1] = allocation.get();
  }
  std::construct_at(storage, std::forward<Args>(args)...);
  allocation.release();
  return storage;
}

template <typename T>
inline void DeleteSharedObject(T* object) {
  if (object == nullptr) return;

  void* allocation = object;
  if constexpr (alignof(T) > MEMORY_ALLOCATION_ALIGNMENT) {
    allocation = reinterpret_cast<void**>(object)[-1];
  }
  object->~T();
  ::HeapFree(::GetProcessHeap(), 0, allocation);
}

template <typename T>
struct ProcessSharedSlot {
  T** value = nullptr;
  void* view = nullptr;
  void* handle = nullptr;
};

inline void FormatProcessSharedSlotName(wchar_t* buffer, size_t buffer_count, const wchar_t* kind, const GUID& guid) {
  std::swprintf(
      buffer,
      buffer_count,
      L"Local\\RenoDX.CrossAddon.%lu.%ls.%08lX%04hX%04hX%02X%02X%02X%02X%02X%02X%02X%02X",
      ::GetCurrentProcessId(),
      kind,
      guid.Data1,
      guid.Data2,
      guid.Data3,
      guid.Data4[0],
      guid.Data4[1],
      guid.Data4[2],
      guid.Data4[3],
      guid.Data4[4],
      guid.Data4[5],
      guid.Data4[6],
      guid.Data4[7]);
}

template <typename T>
inline ProcessSharedSlot<T> OpenProcessSharedSlot(const GUID& guid, auto&& initialize) {
  struct SlotStorage {
    T* value = nullptr;
  };

  wchar_t mapping_name[128] = {};
  wchar_t mutex_name[128] = {};
  FormatProcessSharedSlotName(mapping_name, std::size(mapping_name), L"Mapping", guid);
  FormatProcessSharedSlotName(mutex_name, std::size(mutex_name), L"Mutex", guid);

  auto* const mutex_handle = ::CreateMutexW(nullptr, FALSE, mutex_name);
  assert(mutex_handle != nullptr);
  if (mutex_handle == nullptr) return {};

  const auto wait_result = ::WaitForSingleObject(mutex_handle, INFINITE);
  assert(wait_result == WAIT_OBJECT_0 || wait_result == WAIT_ABANDONED);
  if (wait_result != WAIT_OBJECT_0 && wait_result != WAIT_ABANDONED) {
    ::CloseHandle(mutex_handle);
    return {};
  }

  ProcessSharedSlot<T> slot = {};
  slot.handle = ::CreateFileMappingW(
      INVALID_HANDLE_VALUE,
      nullptr,
      PAGE_READWRITE,
      0u,
      sizeof(SlotStorage),
      mapping_name);
  assert(slot.handle != nullptr);
  if (slot.handle != nullptr) {
    auto* view = static_cast<SlotStorage*>(::MapViewOfFile(
        slot.handle,
        FILE_MAP_ALL_ACCESS,
        0u,
        0u,
        sizeof(SlotStorage)));
    assert(view != nullptr);
    if (view != nullptr) {
      slot.view = view;
      slot.value = &view->value;
    } else {
      ::CloseHandle(slot.handle);
      slot.handle = nullptr;
    }
  }

  if (slot.value != nullptr) {
    std::forward<decltype(initialize)>(initialize)(*slot.value);
  }

  ::ReleaseMutex(mutex_handle);
  ::CloseHandle(mutex_handle);
  return slot;
}

static std::vector<DISPLAYCONFIG_PATH_INFO> GetPathInfos() {
  for (LONG result = ERROR_INSUFFICIENT_BUFFER;
       result == ERROR_INSUFFICIENT_BUFFER;) {
    uint32_t path_elements;
    uint32_t mode_elements;
    if (GetDisplayConfigBufferSizes(QDC_ONLY_ACTIVE_PATHS, &path_elements,
                                    &mode_elements)
        != ERROR_SUCCESS) {
      return {};
    }
    std::vector<DISPLAYCONFIG_PATH_INFO> path_infos(path_elements);
    std::vector<DISPLAYCONFIG_MODE_INFO> mode_infos(mode_elements);
    result = QueryDisplayConfig(QDC_ONLY_ACTIVE_PATHS, &path_elements,
                                path_infos.data(), &mode_elements,
                                mode_infos.data(), nullptr);
    if (result == ERROR_SUCCESS) {
      path_infos.resize(path_elements);
      return path_infos;
    }
  }
  return {};
}

static std::optional<DISPLAYCONFIG_PATH_INFO> GetPathInfo(HMONITOR monitor) {
  // Get the monitor name.
  MONITORINFOEX monitor_info = {};
  monitor_info.cbSize = sizeof(monitor_info);
  if (!GetMonitorInfo(monitor, &monitor_info)) return std::nullopt;

  // Look for a path info with a matching name.
  std::vector<DISPLAYCONFIG_PATH_INFO> path_infos = GetPathInfos();
  for (const auto& info : path_infos) {
    DISPLAYCONFIG_SOURCE_DEVICE_NAME device_name = {};
    device_name.header.type = DISPLAYCONFIG_DEVICE_INFO_GET_SOURCE_NAME;
    device_name.header.size = sizeof(device_name);
    device_name.header.adapterId = info.sourceInfo.adapterId;
    device_name.header.id = info.sourceInfo.id;
    if (DisplayConfigGetDeviceInfo(&device_name.header) != ERROR_SUCCESS) continue;
    wchar_t sz_device_wide[32];
    size_t out_size;
    if (mbstowcs_s(&out_size, sz_device_wide, monitor_info.szDevice, 32) != ERROR_SUCCESS) continue;
    if (out_size == 0) continue;
    if (wcscmp(sz_device_wide, device_name.viewGdiDeviceName) != 0) continue;

    return info;
  }
  return std::nullopt;
}

static void Launch(const std::string& location) {
#if WIN32
  ShellExecute(nullptr, "open", location.c_str(), nullptr, nullptr, SW_SHOWNORMAL);
#else
  std::system(location);
#endif
}

template <typename... Args>
static void LaunchURL(Args... args) {
  std::string url = (std::string(args) + ...);
#if WIN32
  SHELLEXECUTEINFO execute_info = {};
  execute_info.cbSize = sizeof(SHELLEXECUTEINFO);
  execute_info.fMask = SEE_MASK_DEFAULT;
  execute_info.lpFile = url.c_str();
  execute_info.lpVerb = "open";
  execute_info.nShow = SW_SHOWNORMAL;
  execute_info.hInstApp = nullptr;

  ShellExecuteEx(&execute_info);
#else
  std::system(url.c_str());
#endif
}

static std::filesystem::path GetCurrentWorkingPath() {
  return std::filesystem::current_path();
}

static std::map<std::string, std::string> GetEnvironmentVariables() {
  std::map<std::string, std::string> env_map;

#ifdef WIN32
  LPWCH env_strings = GetEnvironmentStringsW();
  if (env_strings == nullptr) {
    return env_map;
  }

  LPWCH p = env_strings;
  while (*p != L'\0') {
    std::wstring ws(p);
    size_t pos = ws.find(L'=');
    if (pos != std::wstring::npos) {
      env_map[std::string(ws.begin(), ws.begin() + pos)] = std::string(ws.begin() + pos + 1, ws.end());
    }
    p += ws.length() + 1;
  }

  FreeEnvironmentStringsW(env_strings);
#else
  extern char** environ;
  for (char** env = environ; *env; ++env) {
    std::string entry(*env);
    size_t pos = entry.find('=');
    if (pos != std::string::npos) {
      env_map[entry.substr(0, pos)] = entry.substr(pos + 1);
    }
  }
#endif

  return env_map;
}

static std::filesystem::path GetCurrentProcessPath() {
  TCHAR file_name[MAX_PATH + 1];
  DWORD chars_written = GetModuleFileName(nullptr, file_name, MAX_PATH + 1);
  if (chars_written != 0) {
    return file_name;
  }
  return "";
}

static bool UpdateReadOnlyAttribute(const std::filesystem::path& file_path, bool set_readonly) {
  DWORD attributes = GetFileAttributes(file_path.string().c_str());
  if (attributes == INVALID_FILE_ATTRIBUTES) {
    return false;  // File not found or error retrieving attributes
  }

  if (set_readonly) {
    attributes |= FILE_ATTRIBUTE_READONLY;  // Add read-only attribute
  } else {
    attributes &= ~FILE_ATTRIBUTE_READONLY;  // Remove read-only attribute
  }

  if (!SetFileAttributes(file_path.string().c_str(), attributes)) {
    return false;  // Failed to set attributes
  }

  return true;  // Successfully updated the read-only attribute
}

static std::string GetProductName(const std::filesystem::path& path = GetCurrentProcessPath()) {
  [[maybe_unused]] DWORD dummy{};
  const auto required_buffer_size{
      GetFileVersionInfoSizeExW(
          FILE_VER_GET_NEUTRAL, path.wstring().c_str(), std::addressof(dummy))};
  if (0 == required_buffer_size) {
    return "";
  }
  const auto p_buffer{
      std::make_unique<char[]>(
          static_cast<::std::size_t>(required_buffer_size))};
  const auto get_version_info_result{
      GetFileVersionInfoExW(
          FILE_VER_GET_NEUTRAL, path.wstring().c_str(), DWORD{}, required_buffer_size, reinterpret_cast<void*>(p_buffer.get()))};
  if (FALSE == get_version_info_result) {
    return "";
  }
  LPVOID p_value{};
  UINT value_length{};
  const auto query_result{
      VerQueryValueW(
          reinterpret_cast<void*>(p_buffer.get()),
          L"\\StringFileInfo"
          L"\\040904B0"
          L"\\ProductName",
          std::addressof(p_value), std::addressof(value_length))};
  if (
      (FALSE == query_result)
      or (nullptr == p_value)
      or ((required_buffer_size / sizeof(wchar_t)) < value_length)) {
    return "";
  }

  const std::wstring product_name{static_cast<const wchar_t*>(p_value), static_cast<::std::size_t>(value_length - 1)};  // subtract 1 to exclude the null terminator
  size_t output_size = product_name.length() + 1;                                                                       // +1 for null terminator
  auto output_string = std::make_unique<char[]>(output_size);
  size_t chars_converted = 0;
  auto ret = wcstombs_s(&chars_converted, output_string.get(), output_size, product_name.c_str(), product_name.length());

  // wide-character-string-to-multibyte-string_safe
  if (ret == S_OK && chars_converted > 0) {
    return std::string(output_string.get());
  }
  return "";
}

static bool IsToolWindow(HWND hwnd) {
  LONG_PTR ex_style = GetWindowLongPtr(hwnd, GWL_EXSTYLE);
  return (ex_style & WS_EX_TOOLWINDOW) != 0;
}

static std::string GetWindowClassName(HWND hwnd) {
  char class_name[256];
  if (GetClassName(hwnd, class_name, sizeof(class_name))) {
    return std::string(class_name);
  }
  return "";
}

static bool IsDummyWindow(HWND hwnd) {
  auto lower_case_view = GetWindowClassName(hwnd) | std::views::transform([](auto c) { return std::tolower(c); });
  return !std::ranges::search(lower_case_view, std::string("dummy")).empty();
}

static std::string GetFileVersion(const std::filesystem::path& path) {
  [[maybe_unused]] DWORD dummy{};
  const auto required_buffer_size{
      GetFileVersionInfoSizeExW(
          FILE_VER_GET_NEUTRAL, path.wstring().c_str(), std::addressof(dummy))};
  if (0 == required_buffer_size) {
    return "";
  }

  const auto p_buffer{
      std::make_unique<char[]>(
          static_cast<::std::size_t>(required_buffer_size))};
  const auto get_version_info_result{
      GetFileVersionInfoExW(
          FILE_VER_GET_NEUTRAL, path.wstring().c_str(), DWORD{}, required_buffer_size, reinterpret_cast<void*>(p_buffer.get()))};
  if (FALSE == get_version_info_result) {
    return "";
  }

  LPVOID p_value{};
  UINT value_length{};
  const auto query_result{
      VerQueryValueW(
          reinterpret_cast<void*>(p_buffer.get()),
          L"\\",
          std::addressof(p_value), std::addressof(value_length))};
  if ((FALSE == query_result) || (nullptr == p_value) || (value_length == 0)) {
    return "";
  }

  auto* fixed_file_info = static_cast<VS_FIXEDFILEINFO*>(p_value);

  if (fixed_file_info->dwSignature == 0xfeef04bd) {  // Check valid signature
    // Format version numbers
    std::string version = std::to_string(HIWORD(fixed_file_info->dwFileVersionMS)) + "." + std::to_string(LOWORD(fixed_file_info->dwFileVersionMS)) + "." + std::to_string(HIWORD(fixed_file_info->dwFileVersionLS)) + "." + std::to_string(LOWORD(fixed_file_info->dwFileVersionLS));
    return version;
  }

  return "";  // Invalid file signature
}

static void OpenExplorerToFile(const std::filesystem::path& file_path) {
#if WIN32
  PIDLIST_ABSOLUTE pidl = nullptr;
  HRESULT hr = SHParseDisplayName(file_path.wstring().c_str(), nullptr, &pidl, 0, nullptr);
  if (SUCCEEDED(hr) && (pidl != nullptr)) {
    SHOpenFolderAndSelectItems(pidl, 0, nullptr, 0);
    CoTaskMemFree(pidl);
  }
#else
  std::string command = "xdg-open " + file_path.parent_path().string();
  std::system(command.c_str());
#endif
}

static HMODULE FindModule(const std::string& module_name) {
  const auto* module_char_array = module_name.c_str();

  HMODULE module = GetModuleHandleA(module_char_array);
  if (module != nullptr) return module;

  module = LoadLibraryA(module_char_array);
  if (module != nullptr) return module;

  module = LoadLibraryExA(module_char_array, nullptr, LOAD_LIBRARY_SEARCH_SYSTEM32);

  return module;
}

static bool IsModuleLoaded(const std::string& module_name) {
  const auto module_file = std::filesystem::path(module_name).filename().string();
  if (module_file.empty()) return false;

  HMODULE module = GetModuleHandleA(module_file.c_str());
  return module != nullptr;
}

}  // namespace renodx::utils::platform
