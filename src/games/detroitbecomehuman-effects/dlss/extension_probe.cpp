/*
 * SPDX-License-Identifier: MIT
 */

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <Windows.h>

#include <shellapi.h>

#include <vulkan/vulkan.h>

#include <nvsdk_ngx_helpers.h>
#include <nvsdk_ngx_helpers_vk.h>

#include <algorithm>
#include <array>
#include <cstdint>
#include <filesystem>
#include <string>
#include <string_view>
#include <vector>

#include "embedded_bootstrap.hpp"

namespace {

namespace embedded = renodx::games::detroitbecomehuman::dlss::embedded;

constexpr char kProjectId[] = "910b88f3-e60e-4c9d-a959-9a46b3e7dcc3";
constexpr char kEngineVersion[] = "Build12158144";
constexpr wchar_t kProbeExport[] = L"RunDetroitNgxExtensionProbe";
constexpr char kProbeFileHeader[] = "RENODX_NGX_EXTENSION_CACHE_V2\n";
constexpr DWORD kProbeTimeoutMilliseconds = 30'000u;

std::wstring GetModulePath(HMODULE module) {
  std::vector<wchar_t> buffer(1024u);
  for (;;) {
    const DWORD length =
        GetModuleFileNameW(module, buffer.data(), static_cast<DWORD>(buffer.size()));
    if (length == 0u) return {};
    if (length < buffer.size() - 1u) return std::wstring(buffer.data(), length);
    buffer.resize(buffer.size() * 2u);
  }
}

std::wstring QuoteCommandLineArgument(std::wstring_view argument) {
  std::wstring quoted;
  quoted.push_back(L'"');
  std::size_t backslashes = 0u;
  for (const wchar_t character : argument) {
    if (character == L'\\') {
      ++backslashes;
      continue;
    }
    if (character == L'"') {
      quoted.append(backslashes * 2u + 1u, L'\\');
      quoted.push_back(L'"');
      backslashes = 0u;
      continue;
    }
    quoted.append(backslashes, L'\\');
    backslashes = 0u;
    quoted.push_back(character);
  }
  quoted.append(backslashes * 2u, L'\\');
  quoted.push_back(L'"');
  return quoted;
}

bool EqualsInsensitive(std::wstring_view left, std::wstring_view right) {
  return left.size() == right.size()
         && std::equal(left.begin(), left.end(), right.begin(), [](wchar_t a, wchar_t b) {
              return towlower(a) == towlower(b);
            });
}

bool IsBlockedEnvironmentEntry(std::wstring_view entry) {
  if (entry.empty() || entry.front() == L'=') return false;
  const auto separator = entry.find(L'=');
  const auto name = entry.substr(0u, separator);
  constexpr std::array<std::wstring_view, 4u> blocked = {
      L"VK_LOADER_LAYERS_DISABLE",
      L"VK_INSTANCE_LAYERS",
      L"VK_ADD_LAYER_PATH",
      L"VK_LAYER_PATH",
  };
  return std::any_of(blocked.begin(), blocked.end(), [&](std::wstring_view candidate) {
    return EqualsInsensitive(name, candidate);
  });
}

std::vector<wchar_t> BuildProbeEnvironment() {
  std::vector<std::wstring> entries;
  wchar_t* environment = GetEnvironmentStringsW();
  if (environment == nullptr) return {};
  for (const wchar_t* cursor = environment; *cursor != L'\0';) {
    const std::wstring_view entry(cursor);
    if (!IsBlockedEnvironmentEntry(entry)) entries.emplace_back(entry);
    cursor += entry.size() + 1u;
  }
  FreeEnvironmentStringsW(environment);
  entries.emplace_back(L"VK_LOADER_LAYERS_DISABLE=*");
  std::sort(entries.begin(), entries.end(), [](const std::wstring& left, const std::wstring& right) {
    return _wcsicmp(left.c_str(), right.c_str()) < 0;
  });

  std::size_t size = 1u;
  for (const auto& entry : entries) size += entry.size() + 1u;
  std::vector<wchar_t> block;
  block.reserve(size);
  for (const auto& entry : entries) {
    block.insert(block.end(), entry.begin(), entry.end());
    block.push_back(L'\0');
  }
  block.push_back(L'\0');
  return block;
}

struct NgxDiscovery {
  std::wstring feature_path;
  std::wstring data_path;
  const wchar_t* feature_paths[1] = {};
  NVSDK_NGX_FeatureCommonInfo feature_info = {};
  NVSDK_NGX_FeatureDiscoveryInfo discovery_info = {};

  explicit NgxDiscovery(const std::filesystem::path& module_directory)
      : feature_path(module_directory.wstring()), data_path(feature_path) {
    feature_paths[0] = feature_path.c_str();
    feature_info.PathListInfo.Path = feature_paths;
    feature_info.PathListInfo.Length = 1u;
    discovery_info.SDKVersion = NVSDK_NGX_Version_API;
    discovery_info.FeatureID = NVSDK_NGX_Feature_SuperSampling;
    discovery_info.Identifier.IdentifierType =
        NVSDK_NGX_Application_Identifier_Type_Project_Id;
    discovery_info.Identifier.v.ProjectDesc.ProjectId = kProjectId;
    discovery_info.Identifier.v.ProjectDesc.EngineType = NVSDK_NGX_ENGINE_TYPE_CUSTOM;
    discovery_info.Identifier.v.ProjectDesc.EngineVersion = kEngineVersion;
    discovery_info.ApplicationDataPath = data_path.c_str();
    discovery_info.FeatureInfo = &feature_info;
  }
};

bool SerializeExtensions(
    const VkExtensionProperties* properties,
    std::uint32_t count,
    std::string* serialized) {
  if (serialized == nullptr || (count != 0u && properties == nullptr) || count > 64u) {
    return false;
  }
  serialized->clear();
  std::vector<std::string_view> seen;
  for (std::uint32_t index = 0u; index < count; ++index) {
    const std::string_view name(properties[index].extensionName);
    if (name.empty() || name.size() >= VK_MAX_EXTENSION_NAME_SIZE
        || name.find(';') != std::string_view::npos
        || std::find(seen.begin(), seen.end(), name) != seen.end()) {
      return false;
    }
    if (!serialized->empty()) serialized->push_back(';');
    serialized->append(name);
    seen.push_back(name);
  }
  return embedded::IsValidExtensionList(*serialized);
}

bool SupportsInstanceExtensions(const std::vector<std::string>& required) {
  std::uint32_t count = 0u;
  if (vkEnumerateInstanceExtensionProperties(nullptr, &count, nullptr) != VK_SUCCESS) {
    return false;
  }
  std::vector<VkExtensionProperties> supported(count);
  if (count != 0u
      && vkEnumerateInstanceExtensionProperties(nullptr, &count, supported.data())
             != VK_SUCCESS) {
    return false;
  }
  return std::all_of(required.begin(), required.end(), [&](const std::string& name) {
    return std::any_of(supported.begin(), supported.end(), [&](const auto& property) {
      return name == property.extensionName;
    });
  });
}

bool SupportsDeviceExtensions(
    VkPhysicalDevice physical_device,
    const VkExtensionProperties* required,
    std::uint32_t required_count) {
  std::uint32_t count = 0u;
  if (vkEnumerateDeviceExtensionProperties(physical_device, nullptr, &count, nullptr)
      != VK_SUCCESS) {
    return false;
  }
  std::vector<VkExtensionProperties> supported(count);
  if (count != 0u
      && vkEnumerateDeviceExtensionProperties(
             physical_device, nullptr, &count, supported.data())
             != VK_SUCCESS) {
    return false;
  }
  for (std::uint32_t index = 0u; index < required_count; ++index) {
    const std::string_view name(required[index].extensionName);
    if (std::none_of(supported.begin(), supported.end(), [&](const auto& property) {
          return name == property.extensionName;
        })) {
      return false;
    }
  }
  return true;
}

bool QueryExtensions(
    const std::filesystem::path& module_directory,
    embedded::ExtensionCache* cache) {
  if (cache == nullptr) return false;
  NgxDiscovery discovery(module_directory);
  std::uint32_t instance_count = 0u;
  VkExtensionProperties* instance_properties = nullptr;
  if (NVSDK_NGX_FAILED(NVSDK_NGX_VULKAN_GetFeatureInstanceExtensionRequirements(
          &discovery.discovery_info, &instance_count, &instance_properties))
      || (instance_count != 0u && instance_properties == nullptr)) {
    return false;
  }

  std::vector<std::string> instance_storage;
  std::vector<const char*> instance_names;
  instance_storage.reserve(instance_count);
  instance_names.reserve(instance_count);
  for (std::uint32_t index = 0u; index < instance_count; ++index) {
    instance_storage.emplace_back(instance_properties[index].extensionName);
  }
  if (!SupportsInstanceExtensions(instance_storage)) return false;
  for (const auto& name : instance_storage) instance_names.push_back(name.c_str());

  const VkApplicationInfo application_info = {
      VK_STRUCTURE_TYPE_APPLICATION_INFO,
      nullptr,
      "RenoDX Detroit DLSS Extension Probe",
      1u,
      "Custom",
      1u,
      VK_API_VERSION_1_1,
  };
  const VkInstanceCreateInfo create_info = {
      VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
      nullptr,
      0u,
      &application_info,
      0u,
      nullptr,
      static_cast<std::uint32_t>(instance_names.size()),
      instance_names.empty() ? nullptr : instance_names.data(),
  };
  VkInstance instance = VK_NULL_HANDLE;
  if (vkCreateInstance(&create_info, nullptr, &instance) != VK_SUCCESS) return false;

  bool success = false;
  std::uint32_t physical_count = 0u;
  if (vkEnumeratePhysicalDevices(instance, &physical_count, nullptr) == VK_SUCCESS
      && physical_count != 0u) {
    std::vector<VkPhysicalDevice> physical_devices(physical_count);
    if (vkEnumeratePhysicalDevices(instance, &physical_count, physical_devices.data())
        == VK_SUCCESS) {
      for (const VkPhysicalDevice physical_device : physical_devices) {
        VkPhysicalDeviceProperties properties = {};
        vkGetPhysicalDeviceProperties(physical_device, &properties);
        if (properties.vendorID != 0x10DEu) continue;
        NVSDK_NGX_FeatureRequirement requirements = {};
        std::uint32_t device_count = 0u;
        VkExtensionProperties* device_properties = nullptr;
        if (NVSDK_NGX_SUCCEED(NVSDK_NGX_VULKAN_GetFeatureRequirements(
                instance,
                physical_device,
                &discovery.discovery_info,
                &requirements))
            && requirements.FeatureSupported
                   == NVSDK_NGX_FeatureSupportResult_Supported
            && NVSDK_NGX_SUCCEED(
                NVSDK_NGX_VULKAN_GetFeatureDeviceExtensionRequirements(
                    instance,
                    physical_device,
                    &discovery.discovery_info,
                    &device_count,
                    &device_properties))
            && (device_count == 0u || device_properties != nullptr)
            && SupportsDeviceExtensions(physical_device, device_properties, device_count)
            && SerializeExtensions(
                instance_properties, instance_count, &cache->instance_extensions)
            && SerializeExtensions(
                device_properties, device_count, &cache->device_extensions)) {
          success = true;
          break;
        }
      }
    }
  }
  vkDestroyInstance(instance, nullptr);
  if (!success) return false;
  cache->schema_version = embedded::kCacheSchemaVersion;
  cache->ready = true;
  cache->executable_sha256 = std::string(embedded::kSupportedExecutableSha256);
  return embedded::IsValidCache(*cache);
}

bool WriteProbeFile(const std::filesystem::path& path, const embedded::ExtensionCache& cache) {
  std::string payload(kProbeFileHeader);
  payload.append(cache.instance_extensions);
  payload.push_back('\n');
  payload.append(cache.device_extensions);
  payload.push_back('\n');
  const HANDLE file = CreateFileW(
      path.c_str(),
      GENERIC_WRITE,
      0u,
      nullptr,
      CREATE_ALWAYS,
      FILE_ATTRIBUTE_TEMPORARY,
      nullptr);
  if (file == INVALID_HANDLE_VALUE) return false;
  DWORD written = 0u;
  const bool success = payload.size() <= MAXDWORD
                       && WriteFile(
                              file,
                              payload.data(),
                              static_cast<DWORD>(payload.size()),
                              &written,
                              nullptr)
                              != FALSE
                       && written == payload.size() && FlushFileBuffers(file) != FALSE;
  CloseHandle(file);
  return success;
}

bool ReadProbeFile(const std::filesystem::path& path, embedded::ExtensionCache* cache) {
  if (cache == nullptr) return false;
  const HANDLE file = CreateFileW(
      path.c_str(),
      GENERIC_READ,
      FILE_SHARE_READ | FILE_SHARE_DELETE,
      nullptr,
      OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,
      nullptr);
  if (file == INVALID_HANDLE_VALUE) return false;
  LARGE_INTEGER size = {};
  bool success = GetFileSizeEx(file, &size) != FALSE && size.QuadPart >= 0
                 && size.QuadPart <= 2 * 16 * 1024 + 128;
  std::string payload;
  if (success) {
    payload.resize(static_cast<std::size_t>(size.QuadPart));
    DWORD read = 0u;
    success = payload.size() <= MAXDWORD
              && ReadFile(
                     file,
                     payload.data(),
                     static_cast<DWORD>(payload.size()),
                     &read,
                     nullptr)
                     != FALSE
              && read == payload.size();
  }
  CloseHandle(file);
  if (!success || !payload.starts_with(kProbeFileHeader)) return false;
  const std::size_t instance_start = std::char_traits<char>::length(kProbeFileHeader);
  const std::size_t instance_end = payload.find('\n', instance_start);
  if (instance_end == std::string::npos) return false;
  const std::size_t device_start = instance_end + 1u;
  const std::size_t device_end = payload.find('\n', device_start);
  if (device_end == std::string::npos || device_end + 1u != payload.size()) return false;
  embedded::ExtensionCache parsed = {
      .schema_version = embedded::kCacheSchemaVersion,
      .ready = true,
      .executable_sha256 = std::string(embedded::kSupportedExecutableSha256),
      .instance_extensions = payload.substr(instance_start, instance_end - instance_start),
      .device_extensions = payload.substr(device_start, device_end - device_start),
  };
  if (!embedded::IsValidCache(parsed)) return false;
  *cache = std::move(parsed);
  return true;
}

}  // namespace

namespace renodx::games::detroitbecomehuman::dlss::embedded {

bool IsExtensionProbeHost() {
  const std::filesystem::path executable(GetModulePath(nullptr));
  if (!EqualsInsensitive(executable.filename().wstring(), L"rundll32.exe")) return false;
  const wchar_t* command_line = GetCommandLineW();
  return command_line != nullptr && wcsstr(command_line, kProbeExport) != nullptr;
}

bool QueryRequiredExtensionsIsolated(HMODULE addon_module, ExtensionCache* cache) {
  if (addon_module == nullptr || cache == nullptr || !VerifySupportedExecutable()) return false;
  const std::filesystem::path addon_path(GetModulePath(addon_module));
  if (addon_path.empty()) return false;

  std::array<wchar_t, MAX_PATH + 1u> temporary_directory = {};
  const DWORD directory_length = GetTempPathW(
      static_cast<DWORD>(temporary_directory.size()), temporary_directory.data());
  if (directory_length == 0u || directory_length >= temporary_directory.size()) return false;
  std::array<wchar_t, MAX_PATH + 1u> temporary_file = {};
  if (GetTempFileNameW(temporary_directory.data(), L"RDX", 0u, temporary_file.data())
      == 0u) {
    return false;
  }
  const std::filesystem::path result_path(temporary_file.data());

  std::array<wchar_t, MAX_PATH + 1u> system_directory = {};
  const UINT system_length =
      GetSystemDirectoryW(system_directory.data(), static_cast<UINT>(system_directory.size()));
  if (system_length == 0u || system_length >= system_directory.size()) {
    DeleteFileW(result_path.c_str());
    return false;
  }
  const std::filesystem::path rundll_path =
      std::filesystem::path(system_directory.data()) / L"rundll32.exe";
  std::wstring command_line = QuoteCommandLineArgument(rundll_path.wstring());
  command_line.push_back(L' ');
  command_line.append(QuoteCommandLineArgument(addon_path.wstring()));
  command_line.push_back(L',');
  command_line.append(kProbeExport);
  command_line.push_back(L' ');
  command_line.append(QuoteCommandLineArgument(result_path.wstring()));
  std::vector<wchar_t> mutable_command_line(command_line.begin(), command_line.end());
  mutable_command_line.push_back(L'\0');
  auto environment = BuildProbeEnvironment();

  STARTUPINFOW startup_info = {};
  startup_info.cb = sizeof(startup_info);
  PROCESS_INFORMATION process_info = {};
  const std::wstring working_directory = addon_path.parent_path().wstring();
  bool success = !environment.empty()
                 && CreateProcessW(
                        rundll_path.c_str(),
                        mutable_command_line.data(),
                        nullptr,
                        nullptr,
                        FALSE,
                        CREATE_NO_WINDOW | CREATE_UNICODE_ENVIRONMENT,
                        environment.data(),
                        working_directory.c_str(),
                        &startup_info,
                        &process_info)
                        != FALSE;
  if (success) {
    CloseHandle(process_info.hThread);
    const DWORD wait_result = WaitForSingleObject(process_info.hProcess, kProbeTimeoutMilliseconds);
    if (wait_result == WAIT_TIMEOUT) {
      TerminateProcess(process_info.hProcess, ERROR_TIMEOUT);
      WaitForSingleObject(process_info.hProcess, 5'000u);
    }
    DWORD exit_code = ERROR_GEN_FAILURE;
    success = wait_result == WAIT_OBJECT_0
              && GetExitCodeProcess(process_info.hProcess, &exit_code) != FALSE
              && exit_code == ERROR_SUCCESS;
    CloseHandle(process_info.hProcess);
  }
  success = success && ReadProbeFile(result_path, cache);
  DeleteFileW(result_path.c_str());
  if (!success) SetNativeFallback("Isolated NGX extension probe failed");
  return success;
}

}  // namespace renodx::games::detroitbecomehuman::dlss::embedded

extern "C" __declspec(dllexport) void CALLBACK RunDetroitNgxExtensionProbe(
    HWND,
    HINSTANCE,
    LPSTR,
    int) {
  int argument_count = 0;
  wchar_t** arguments = CommandLineToArgvW(GetCommandLineW(), &argument_count);
  DWORD exit_code = ERROR_GEN_FAILURE;
  if (arguments != nullptr && argument_count >= 2) {
    HMODULE module = nullptr;
    if (GetModuleHandleExW(
            GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS
                | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
            reinterpret_cast<LPCWSTR>(&RunDetroitNgxExtensionProbe),
            &module)
        != FALSE) {
      const std::filesystem::path module_path(GetModulePath(module));
      embedded::ExtensionCache cache;
      if (!module_path.empty()
          && QueryExtensions(module_path.parent_path(), &cache)
          && WriteProbeFile(std::filesystem::path(arguments[argument_count - 1]), cache)) {
        exit_code = ERROR_SUCCESS;
      }
    }
  }
  if (arguments != nullptr) LocalFree(arguments);
  ExitProcess(exit_code);
}
