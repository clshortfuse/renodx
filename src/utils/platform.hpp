#pragma once

#pragma comment(lib, "version.lib")

#include <dxgi1_6.h>
#include <windows.h>
#include <winver.h>
#include <algorithm>
#include <filesystem>
#include <optional>
#include <ranges>
#include <string>
#include <vector>

namespace renodx::utils::platform {

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
  ShellExecute(nullptr, "open", location.c_str(), nullptr, nullptr, SW_SHOW);
#else
  std::system(location);
#endif
}

static std::filesystem::path GetCurrentProcessPath() {
  TCHAR file_name[MAX_PATH + 1];
  DWORD chars_written = GetModuleFileName(nullptr, file_name, MAX_PATH + 1);
  if (chars_written != 0) {
    return file_name;
  }
  return "";
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

static bool IsDummyWindow(HWND hwnd) {
  char class_name[256];
  if (GetClassName(hwnd, class_name, sizeof(class_name))) {
    auto lower_case_view = std::string(class_name) | std::views::transform([](auto c) { return std::tolower(c); });
    if (!std::ranges::search(lower_case_view, std::string("dummy")).empty()) return true;
  }

  return false;
}

}  // namespace renodx::utils::platform