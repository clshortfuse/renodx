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

#include <bcrypt.h>
#include <shellapi.h>
#include <vulkan/vulkan.h>

// The NGX Vulkan declarations use Vulkan types without including Vulkan.
#include <nvsdk_ngx_vk.h>

#include <algorithm>
#include <array>
#include <cctype>
#include <cstdint>
#include <cwctype>
#include <filesystem>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "../supported_build.hpp"

namespace {

constexpr wchar_t kLayerName[] = L"VK_LAYER_RENODX_detroit_dlss";
constexpr wchar_t kSteamAppId[] = L"1222140";
constexpr wchar_t kNgxProbeArgument[] = L"--ngx-extension-probe";
constexpr char kNgxProbeFileHeader[] = "RENODX_NGX_EXTENSION_CACHE_V1\n";
constexpr DWORD kNgxProbeTimeoutMilliseconds = 30'000u;
constexpr char kProjectId[] = "910b88f3-e60e-4c9d-a959-9a46b3e7dcc3";
constexpr char kEngineVersion[] = "Build12158144";
constexpr char kCachedDeviceExtensionsReadyEnvironment[] =
    "RENODX_DETROIT_NGX_DEVICE_EXTENSIONS_READY";
constexpr char kCachedInstanceExtensionsEnvironment[] =
    "RENODX_DETROIT_NGX_INSTANCE_EXTENSIONS";
constexpr char kCachedDeviceExtensionsEnvironment[] =
    "RENODX_DETROIT_NGX_DEVICE_EXTENSIONS";
constexpr std::array<const wchar_t*, 3u> kDlssCacheEnvironment = {
    L"RENODX_DETROIT_NGX_DEVICE_EXTENSIONS_READY",
    L"RENODX_DETROIT_NGX_INSTANCE_EXTENSIONS",
    L"RENODX_DETROIT_NGX_DEVICE_EXTENSIONS",
};
constexpr std::size_t kMaximumCachedExtensionListBytes = 16u * 1024u;
constexpr std::size_t kMaximumCachedExtensionCount = 64u;
constexpr std::array<std::wstring_view, 4u> kRequiredRuntimeFiles = {
    L"VK_LAYER_RENODX_detroit_dlss.json",
    L"renodx-detroit-dlss-layer.dll",
    L"nvngx_dlss.dll",
    L"renodx-detroitbecomehuman.addon64",
};

namespace supported_build = renodx::games::detroitbecomehuman::supported_build;

void ShowError(const std::wstring& message) {
  MessageBoxW(nullptr, message.c_str(), L"RenoDX Detroit DLSS", MB_OK | MB_ICONERROR);
}

void ShowWarning(const std::wstring& message) {
  MessageBoxW(nullptr, message.c_str(), L"RenoDX Detroit DLSS", MB_OK | MB_ICONWARNING);
}

std::filesystem::path GetModulePath() {
  std::vector<wchar_t> buffer(1024u);
  for (;;) {
    const DWORD length = GetModuleFileNameW(nullptr, buffer.data(), static_cast<DWORD>(buffer.size()));
    if (length == 0u) return {};
    if (length < buffer.size() - 1u) {
      return std::filesystem::path(std::wstring_view(buffer.data(), length));
    }
    buffer.resize(buffer.size() * 2u);
  }
}

std::filesystem::path GetModuleDirectory() {
  const auto module_path = GetModulePath();
  return module_path.empty() ? std::filesystem::path() : module_path.parent_path();
}

bool EqualsIgnoreCase(std::wstring_view left, std::wstring_view right) {
  if (left.size() != right.size()) return false;
  for (std::size_t index = 0u; index < left.size(); ++index) {
    if (std::towlower(left[index]) != std::towlower(right[index])) return false;
  }
  return true;
}

std::wstring GetEnvironmentValue(const wchar_t* name) {
  const DWORD required = GetEnvironmentVariableW(name, nullptr, 0u);
  if (required == 0u) return {};
  std::wstring value(required, L'\0');
  const DWORD written = GetEnvironmentVariableW(name, value.data(), required);
  if (written == 0u || written >= required) return {};
  value.resize(written);
  return value;
}

bool ListContains(std::wstring_view list, std::wstring_view value) {
  std::size_t start = 0u;
  while (start <= list.size()) {
    const std::size_t end = list.find(L';', start);
    const auto item = list.substr(start, end == std::wstring_view::npos ? list.size() - start : end - start);
    if (EqualsIgnoreCase(item, value)) return true;
    if (end == std::wstring_view::npos) break;
    start = end + 1u;
  }
  return false;
}

bool PrependEnvironmentList(const wchar_t* name, const std::wstring& value) {
  std::wstring current = GetEnvironmentValue(name);
  if (ListContains(current, value)) return true;
  std::wstring updated = value;
  if (!current.empty()) {
    updated.push_back(L';');
    updated.append(current);
  }
  return SetEnvironmentVariableW(name, updated.c_str()) != FALSE;
}

bool AppendEnvironmentList(const wchar_t* name, std::wstring_view value) {
  std::wstring current = GetEnvironmentValue(name);
  if (ListContains(current, value)) return true;
  if (!current.empty()) current.push_back(L';');
  current.append(value);
  return SetEnvironmentVariableW(name, current.c_str()) != FALSE;
}

bool RemoveEnvironmentListValue(
    const wchar_t* name,
    std::wstring_view value) {
  const std::wstring current = GetEnvironmentValue(name);
  if (current.empty()) return true;

  std::wstring updated;
  bool removed = false;
  std::size_t start = 0u;
  while (start <= current.size()) {
    const std::size_t end = current.find(L';', start);
    const auto item = std::wstring_view(current).substr(
        start,
        end == std::wstring_view::npos ? current.size() - start
                                       : end - start);
    if (EqualsIgnoreCase(item, value)) {
      removed = true;
    } else if (!item.empty()) {
      if (!updated.empty()) updated.push_back(L';');
      updated.append(item);
    }
    if (end == std::wstring_view::npos) break;
    start = end + 1u;
  }
  if (!removed) return true;
  return SetEnvironmentVariableW(
             name, updated.empty() ? nullptr : updated.c_str())
         != FALSE;
}

bool ClearProcessScopedDlssEnvironment(
    const std::filesystem::path& module_directory) {
  // Remove only this package's layer token and directory. Inherited Vulkan
  // layers and loader filters belong to the user and must survive the Native
  // fallback path unchanged.
  bool success = true;
  success &= RemoveEnvironmentListValue(L"VK_INSTANCE_LAYERS", kLayerName);
  success &= RemoveEnvironmentListValue(
      L"VK_ADD_LAYER_PATH", module_directory.wstring());
  success &= RemoveEnvironmentListValue(
      L"VK_LAYER_PATH", module_directory.wstring());
  for (const wchar_t* const name : kDlssCacheEnvironment) {
    if (SetEnvironmentVariableW(name, nullptr) == FALSE) success = false;
  }
  return success;
}

std::wstring QuoteCommandLineArgument(std::wstring_view argument) {
  if (argument.find_first_of(L" \t\n\v\"") == std::wstring_view::npos) {
    return std::wstring(argument);
  }

  std::wstring quoted(1u, L'\"');
  std::size_t backslashes = 0u;
  for (const wchar_t character : argument) {
    if (character == L'\\') {
      ++backslashes;
      continue;
    }
    if (character == L'\"') {
      quoted.append(backslashes * 2u + 1u, L'\\');
      quoted.push_back(L'\"');
      backslashes = 0u;
      continue;
    }
    quoted.append(backslashes, L'\\');
    backslashes = 0u;
    quoted.push_back(character);
  }
  quoted.append(backslashes * 2u, L'\\');
  quoted.push_back(L'\"');
  return quoted;
}

bool HashFileSha256(const std::filesystem::path& path, std::array<std::uint8_t, 32>* digest) {
  if (digest == nullptr) return false;

  BCRYPT_ALG_HANDLE algorithm = nullptr;
  BCRYPT_HASH_HANDLE hash = nullptr;
  HANDLE file = INVALID_HANDLE_VALUE;
  std::vector<std::uint8_t> hash_object;
  bool success = false;

  do {
    if (BCryptOpenAlgorithmProvider(&algorithm, BCRYPT_SHA256_ALGORITHM, nullptr, 0u) < 0) break;

    DWORD object_size = 0u;
    DWORD copied = 0u;
    if (BCryptGetProperty(
            algorithm,
            BCRYPT_OBJECT_LENGTH,
            reinterpret_cast<PUCHAR>(&object_size),
            sizeof(object_size),
            &copied,
            0u)
        < 0) {
      break;
    }
    hash_object.resize(object_size);
    if (BCryptCreateHash(
            algorithm,
            &hash,
            hash_object.data(),
            static_cast<ULONG>(hash_object.size()),
            nullptr,
            0u,
            0u)
        < 0) {
      break;
    }

    file = CreateFileW(
        path.c_str(),
        GENERIC_READ,
        FILE_SHARE_READ | FILE_SHARE_DELETE,
        nullptr,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,
        nullptr);
    if (file == INVALID_HANDLE_VALUE) break;

    // Keep comfortably below the default 1 MiB Windows thread stack. The
    // previous 1 MiB local array overflowed before the executable gate ran.
    std::array<std::uint8_t, 64u * 1024u> buffer = {};
    for (;;) {
      DWORD bytes_read = 0u;
      if (ReadFile(file, buffer.data(), static_cast<DWORD>(buffer.size()), &bytes_read, nullptr) == FALSE) {
        break;
      }
      if (bytes_read == 0u) {
        success = BCryptFinishHash(
                      hash, digest->data(), static_cast<ULONG>(digest->size()), 0u)
                  >= 0;
        break;
      }
      if (BCryptHashData(hash, buffer.data(), bytes_read, 0u) < 0) break;
    }
  } while (false);

  if (file != INVALID_HANDLE_VALUE) CloseHandle(file);
  if (hash != nullptr) BCryptDestroyHash(hash);
  if (algorithm != nullptr) BCryptCloseAlgorithmProvider(algorithm, 0u);
  return success;
}

bool GetFileSize(const std::filesystem::path& path, std::uint64_t* size) {
  if (size == nullptr) return false;
  const HANDLE file = CreateFileW(
      path.c_str(),
      FILE_READ_ATTRIBUTES,
      FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
      nullptr,
      OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL,
      nullptr);
  if (file == INVALID_HANDLE_VALUE) return false;
  LARGE_INTEGER file_size = {};
  const bool success = GetFileSizeEx(file, &file_size) != FALSE && file_size.QuadPart >= 0;
  CloseHandle(file);
  if (success) *size = static_cast<std::uint64_t>(file_size.QuadPart);
  return success;
}

bool IsRegularFile(const std::filesystem::path& path) {
  const DWORD attributes = GetFileAttributesW(path.c_str());
  return attributes != INVALID_FILE_ATTRIBUTES
         && (attributes & FILE_ATTRIBUTE_DIRECTORY) == 0u;
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
    discovery_info.Identifier.v.ProjectDesc.EngineType =
        NVSDK_NGX_ENGINE_TYPE_CUSTOM;
    discovery_info.Identifier.v.ProjectDesc.EngineVersion = kEngineVersion;
    discovery_info.ApplicationDataPath = data_path.c_str();
    discovery_info.FeatureInfo = &feature_info;
  }
};

struct NgxExtensionCache {
  std::string instance_extensions;
  std::string device_extensions;
};

bool QueryNgxExtensionCache(
    const std::filesystem::path& module_directory,
    NgxExtensionCache* cache) {
  if (cache == nullptr) return false;
  cache->instance_extensions.clear();
  cache->device_extensions.clear();

  // A Vulkan layer cannot safely call the NGX device-requirements helper from
  // inside vkCreateDevice: the helper re-enters the loader. Query once in this
  // isolated probe, then pass only the verified extension names to the game.
  constexpr std::array<const wchar_t*, 4u> kProbeLayerEnvironment = {
      L"VK_LOADER_LAYERS_DISABLE",
      L"VK_INSTANCE_LAYERS",
      L"VK_ADD_LAYER_PATH",
      L"VK_LAYER_PATH",
  };
  std::array<std::wstring, kProbeLayerEnvironment.size()> previous_environment;
  for (std::size_t index = 0u; index < kProbeLayerEnvironment.size(); ++index) {
    previous_environment[index] = GetEnvironmentValue(kProbeLayerEnvironment[index]);
  }
  const auto restore_layer_environment = [&]() {
    for (std::size_t index = 0u; index < kProbeLayerEnvironment.size(); ++index) {
      (void)SetEnvironmentVariableW(
          kProbeLayerEnvironment[index],
          previous_environment[index].empty()
              ? nullptr
              : previous_environment[index].c_str());
    }
  };
  if (SetEnvironmentVariableW(L"VK_LOADER_LAYERS_DISABLE", L"*") == FALSE
      || SetEnvironmentVariableW(L"VK_INSTANCE_LAYERS", nullptr) == FALSE
      || SetEnvironmentVariableW(L"VK_ADD_LAYER_PATH", nullptr) == FALSE
      || SetEnvironmentVariableW(L"VK_LAYER_PATH", nullptr) == FALSE) {
    restore_layer_environment();
    return false;
  }

  NgxDiscovery discovery(module_directory);
  std::uint32_t instance_extension_count = 0u;
  VkExtensionProperties* instance_extensions = nullptr;
  const auto instance_requirements =
      NVSDK_NGX_VULKAN_GetFeatureInstanceExtensionRequirements(
          &discovery.discovery_info,
          &instance_extension_count,
          &instance_extensions);
  if (NVSDK_NGX_FAILED(instance_requirements)
      || (instance_extension_count != 0u && instance_extensions == nullptr)) {
    restore_layer_environment();
    return false;
  }

  std::vector<std::string> instance_extension_storage;
  std::vector<const char*> instance_extension_names;
  instance_extension_storage.reserve(instance_extension_count);
  instance_extension_names.reserve(instance_extension_count);
  for (std::uint32_t index = 0u; index < instance_extension_count; ++index) {
    instance_extension_storage.emplace_back(instance_extensions[index].extensionName);
  }
  for (const auto& extension : instance_extension_storage) {
    instance_extension_names.push_back(extension.c_str());
  }
  std::string serialized_instance_extensions;
  for (const auto& extension : instance_extension_storage) {
    if (extension.empty() || extension.size() >= VK_MAX_EXTENSION_NAME_SIZE
        || extension.find(';') != std::string::npos) {
      restore_layer_environment();
      return false;
    }
    if (!serialized_instance_extensions.empty()) {
      serialized_instance_extensions.push_back(';');
    }
    serialized_instance_extensions.append(extension);
  }

  const VkApplicationInfo application_info = {
      VK_STRUCTURE_TYPE_APPLICATION_INFO,
      nullptr,
      "RenoDX Detroit DLSS Extension Probe",
      1u,
      "Custom",
      1u,
      VK_API_VERSION_1_1,
  };
  const VkInstanceCreateInfo instance_create_info = {
      VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
      nullptr,
      0u,
      &application_info,
      0u,
      nullptr,
      static_cast<std::uint32_t>(instance_extension_names.size()),
      instance_extension_names.empty() ? nullptr : instance_extension_names.data(),
  };
  VkInstance instance = VK_NULL_HANDLE;
  if (vkCreateInstance(&instance_create_info, nullptr, &instance) != VK_SUCCESS) {
    restore_layer_environment();
    return false;
  }

  std::uint32_t physical_device_count = 0u;
  VkResult enumerate_result =
      vkEnumeratePhysicalDevices(instance, &physical_device_count, nullptr);
  std::vector<VkPhysicalDevice> physical_devices(physical_device_count);
  if (enumerate_result == VK_SUCCESS && physical_device_count != 0u) {
    enumerate_result = vkEnumeratePhysicalDevices(
        instance, &physical_device_count, physical_devices.data());
  }
  VkPhysicalDevice physical_device = VK_NULL_HANDLE;
  if (enumerate_result == VK_SUCCESS) {
    for (const auto candidate : physical_devices) {
      VkPhysicalDeviceProperties properties = {};
      vkGetPhysicalDeviceProperties(candidate, &properties);
      if (properties.vendorID == 0x10DEu) {
        physical_device = candidate;
        break;
      }
    }
  }

  bool success = false;
  if (physical_device != VK_NULL_HANDLE) {
    NVSDK_NGX_FeatureRequirement feature_requirements = {};
    const auto feature_result = NVSDK_NGX_VULKAN_GetFeatureRequirements(
        instance,
        physical_device,
        &discovery.discovery_info,
        &feature_requirements);
    std::uint32_t device_extension_count = 0u;
    VkExtensionProperties* device_extensions = nullptr;
    const auto extension_result =
        NVSDK_NGX_VULKAN_GetFeatureDeviceExtensionRequirements(
            instance,
            physical_device,
            &discovery.discovery_info,
            &device_extension_count,
            &device_extensions);
    if (NVSDK_NGX_SUCCEED(feature_result)
        && feature_requirements.FeatureSupported
               == NVSDK_NGX_FeatureSupportResult_Supported
        && NVSDK_NGX_SUCCEED(extension_result)
        && (device_extension_count == 0u || device_extensions != nullptr)) {
      std::uint32_t supported_extension_count = 0u;
      VkResult supported_result = vkEnumerateDeviceExtensionProperties(
          physical_device, nullptr, &supported_extension_count, nullptr);
      std::vector<VkExtensionProperties> supported_extensions(
          supported_extension_count);
      if (supported_result == VK_SUCCESS && supported_extension_count != 0u) {
        supported_result = vkEnumerateDeviceExtensionProperties(
            physical_device,
            nullptr,
            &supported_extension_count,
            supported_extensions.data());
      }
      std::string serialized_extensions;
      success = supported_result == VK_SUCCESS;
      for (std::uint32_t index = 0u;
           success && index < device_extension_count;
           ++index) {
        const std::string_view extension(device_extensions[index].extensionName);
        if (extension.empty() || extension.size() >= VK_MAX_EXTENSION_NAME_SIZE
            || extension.find(';') != std::string_view::npos
            || std::none_of(
                supported_extensions.begin(),
                supported_extensions.end(),
                [extension](const VkExtensionProperties& supported) {
                  return extension == supported.extensionName;
                })) {
          serialized_extensions.clear();
          success = false;
          break;
        }
        if (!serialized_extensions.empty()) serialized_extensions.push_back(';');
        serialized_extensions.append(extension);
      }
      if (success) {
        cache->instance_extensions = std::move(serialized_instance_extensions);
        cache->device_extensions = std::move(serialized_extensions);
      }
    }
  }

  vkDestroyInstance(instance, nullptr);
  restore_layer_environment();
  return success;
}

bool ValidateSerializedExtensions(std::string_view serialized) {
  if (serialized.size() >= kMaximumCachedExtensionListBytes) return false;
  if (serialized.empty()) return true;

  std::size_t count = 0u;
  std::size_t start = 0u;
  while (start <= serialized.size()) {
    const std::size_t end = serialized.find(';', start);
    const std::string_view extension = serialized.substr(
        start,
        end == std::string_view::npos ? serialized.size() - start : end - start);
    if (extension.empty() || extension.size() >= VK_MAX_EXTENSION_NAME_SIZE
        || !extension.starts_with("VK_")) {
      return false;
    }
    for (const unsigned char character : extension) {
      if (std::isalnum(character) == 0 && character != '_') return false;
    }
    if (++count > kMaximumCachedExtensionCount) return false;
    if (end == std::string_view::npos) break;
    start = end + 1u;
  }
  return true;
}

bool WriteNgxProbeFile(
    const std::filesystem::path& path,
    const NgxExtensionCache& cache) {
  std::string payload(kNgxProbeFileHeader);
  payload.append(cache.instance_extensions);
  payload.push_back('\n');
  payload.append(cache.device_extensions);
  payload.push_back('\n');
  if (payload.size() > 2u * kMaximumCachedExtensionListBytes + 128u) return false;

  const HANDLE file = CreateFileW(
      path.c_str(),
      GENERIC_WRITE,
      0u,
      nullptr,
      CREATE_ALWAYS,
      FILE_ATTRIBUTE_TEMPORARY,
      nullptr);
  if (file == INVALID_HANDLE_VALUE) return false;
  DWORD bytes_written = 0u;
  const bool success = WriteFile(
                           file,
                           payload.data(),
                           static_cast<DWORD>(payload.size()),
                           &bytes_written,
                           nullptr)
                           != FALSE
                       && bytes_written == payload.size()
                       && FlushFileBuffers(file) != FALSE;
  CloseHandle(file);
  return success;
}

bool ReadNgxProbeFile(
    const std::filesystem::path& path,
    NgxExtensionCache* cache) {
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

  LARGE_INTEGER file_size = {};
  const std::uint64_t maximum_size =
      2u * kMaximumCachedExtensionListBytes + 128u;
  bool success = GetFileSizeEx(file, &file_size) != FALSE
                 && file_size.QuadPart >= 0
                 && static_cast<std::uint64_t>(file_size.QuadPart) <= maximum_size;
  std::string payload;
  if (success) {
    payload.resize(static_cast<std::size_t>(file_size.QuadPart));
    DWORD bytes_read = 0u;
    success = ReadFile(
                  file,
                  payload.data(),
                  static_cast<DWORD>(payload.size()),
                  &bytes_read,
                  nullptr)
                  != FALSE
              && bytes_read == payload.size();
  }
  CloseHandle(file);
  if (!success || !payload.starts_with(kNgxProbeFileHeader)) return false;

  const std::size_t instance_start = std::char_traits<char>::length(kNgxProbeFileHeader);
  const std::size_t instance_end = payload.find('\n', instance_start);
  if (instance_end == std::string::npos) return false;
  const std::size_t device_start = instance_end + 1u;
  const std::size_t device_end = payload.find('\n', device_start);
  if (device_end == std::string::npos || device_end + 1u != payload.size()) return false;

  NgxExtensionCache parsed;
  parsed.instance_extensions = payload.substr(instance_start, instance_end - instance_start);
  parsed.device_extensions = payload.substr(device_start, device_end - device_start);
  if (!ValidateSerializedExtensions(parsed.instance_extensions)
      || !ValidateSerializedExtensions(parsed.device_extensions)) {
    return false;
  }
  *cache = std::move(parsed);
  return true;
}

bool ApplyNgxExtensionCache(const NgxExtensionCache& cache) {
  (void)SetEnvironmentVariableA(kCachedDeviceExtensionsReadyEnvironment, nullptr);
  (void)SetEnvironmentVariableA(kCachedInstanceExtensionsEnvironment, nullptr);
  (void)SetEnvironmentVariableA(kCachedDeviceExtensionsEnvironment, nullptr);

  const bool success =
      (cache.instance_extensions.empty()
       || SetEnvironmentVariableA(
              kCachedInstanceExtensionsEnvironment,
              cache.instance_extensions.c_str())
              != FALSE)
      && (cache.device_extensions.empty()
          || SetEnvironmentVariableA(
                 kCachedDeviceExtensionsEnvironment,
                 cache.device_extensions.c_str())
                 != FALSE)
      && SetEnvironmentVariableA(kCachedDeviceExtensionsReadyEnvironment, "1") != FALSE;
  if (!success) {
    (void)SetEnvironmentVariableA(kCachedDeviceExtensionsReadyEnvironment, nullptr);
    (void)SetEnvironmentVariableA(kCachedInstanceExtensionsEnvironment, nullptr);
    (void)SetEnvironmentVariableA(kCachedDeviceExtensionsEnvironment, nullptr);
  }
  return success;
}

bool PrepareNgxExtensionCacheIsolated(
    const std::filesystem::path& module_directory) {
  (void)SetEnvironmentVariableA(kCachedDeviceExtensionsReadyEnvironment, nullptr);
  (void)SetEnvironmentVariableA(kCachedInstanceExtensionsEnvironment, nullptr);
  (void)SetEnvironmentVariableA(kCachedDeviceExtensionsEnvironment, nullptr);

  std::array<wchar_t, MAX_PATH + 1u> temporary_directory = {};
  const DWORD temporary_length = GetTempPathW(
      static_cast<DWORD>(temporary_directory.size()), temporary_directory.data());
  if (temporary_length == 0u || temporary_length >= temporary_directory.size()) return false;
  std::array<wchar_t, MAX_PATH + 1u> temporary_file = {};
  if (GetTempFileNameW(
          temporary_directory.data(), L"RDX", 0u, temporary_file.data())
      == 0u) {
    return false;
  }
  const std::filesystem::path result_path(temporary_file.data());

  const std::filesystem::path module_path = GetModulePath();
  std::wstring command_line = QuoteCommandLineArgument(module_path.wstring());
  command_line.push_back(L' ');
  command_line.append(kNgxProbeArgument);
  command_line.push_back(L' ');
  command_line.append(QuoteCommandLineArgument(result_path.wstring()));
  std::vector<wchar_t> mutable_command_line(command_line.begin(), command_line.end());
  mutable_command_line.push_back(L'\0');

  STARTUPINFOW startup_info = {};
  startup_info.cb = sizeof(startup_info);
  PROCESS_INFORMATION process_info = {};
  const std::wstring working_directory = module_directory.wstring();
  bool success = CreateProcessW(
                     module_path.c_str(),
                     mutable_command_line.data(),
                     nullptr,
                     nullptr,
                     FALSE,
                     CREATE_NO_WINDOW,
                     nullptr,
                     working_directory.c_str(),
                     &startup_info,
                     &process_info)
                 != FALSE;
  if (success) {
    CloseHandle(process_info.hThread);
    const DWORD wait_result =
        WaitForSingleObject(process_info.hProcess, kNgxProbeTimeoutMilliseconds);
    if (wait_result == WAIT_TIMEOUT) {
      (void)TerminateProcess(process_info.hProcess, ERROR_TIMEOUT);
      (void)WaitForSingleObject(process_info.hProcess, 5'000u);
    }
    DWORD exit_code = ERROR_GEN_FAILURE;
    success = wait_result == WAIT_OBJECT_0
              && GetExitCodeProcess(process_info.hProcess, &exit_code) != FALSE
              && exit_code == ERROR_SUCCESS;
    CloseHandle(process_info.hProcess);
  }

  NgxExtensionCache cache;
  success = success && ReadNgxProbeFile(result_path, &cache)
            && ApplyNgxExtensionCache(cache);
  (void)DeleteFileW(result_path.c_str());
  return success;
}

}  // namespace

#if !defined(RENODX_DETROIT_LAUNCHER_TESTING)
int WINAPI wWinMain(HINSTANCE, HINSTANCE, PWSTR, int) {
  int argument_count = 0;
  wchar_t** arguments = CommandLineToArgvW(GetCommandLineW(), &argument_count);
  if (arguments == nullptr) {
    ShowError(L"Could not parse the launcher command line.");
    return 2;
  }

  const std::filesystem::path module_directory = GetModuleDirectory();
  if (argument_count == 3
      && EqualsIgnoreCase(arguments[1], kNgxProbeArgument)) {
    SetErrorMode(
        SEM_FAILCRITICALERRORS | SEM_NOGPFAULTERRORBOX | SEM_NOOPENFILEERRORBOX);
    const std::filesystem::path result_path =
        std::filesystem::absolute(arguments[2]);
    NgxExtensionCache cache;
    const bool success = QueryNgxExtensionCache(module_directory, &cache)
                         && WriteNgxProbeFile(result_path, cache);
    LocalFree(arguments);
    return success ? ERROR_SUCCESS : ERROR_GEN_FAILURE;
  }

  const std::filesystem::path supported_executable_name(supported_build::kExecutableName);
  std::filesystem::path executable = module_directory / supported_executable_name;
  int child_argument_start = 1;
  if (argument_count > 1) {
    executable = std::filesystem::absolute(arguments[1]);
    child_argument_start = 2;
  }

  if (!EqualsIgnoreCase(executable.filename().wstring(), supported_executable_name.wstring())) {
    LocalFree(arguments);
    ShowError(L"The launcher only supports DetroitBecomeHuman.exe.");
    return 3;
  }

  std::uint64_t executable_size = 0u;
  if (!GetFileSize(executable, &executable_size)) {
    LocalFree(arguments);
    ShowError(L"Could not read DetroitBecomeHuman.exe for the compatibility check.");
    return 4;
  }

  bool enable_dlss_layer = executable_size == supported_build::kExecutableSize;
  std::wstring unsupported_build_reason;
  if (!enable_dlss_layer) {
    unsupported_build_reason = L"Its file size does not match the supported build.";
  } else {
    std::array<std::uint8_t, 32> digest = {};
    if (!HashFileSha256(executable, &digest)) {
      LocalFree(arguments);
      ShowError(L"Could not read DetroitBecomeHuman.exe for the compatibility check.");
      return 4;
    }
    enable_dlss_layer = supported_build::MatchesExecutableIdentity(executable_size, digest);
    if (!enable_dlss_layer) {
      unsupported_build_reason = L"Its SHA-256 does not match the supported build.";
    }
  }

  if (enable_dlss_layer) {
    std::wstring missing_files;
    for (const std::wstring_view filename : kRequiredRuntimeFiles) {
      if (IsRegularFile(module_directory / filename)) continue;
      if (!missing_files.empty()) missing_files.append(L"\n");
      missing_files.append(L"  - ");
      missing_files.append(filename);
    }
    if (!missing_files.empty()) {
      LocalFree(arguments);
      ShowError(
          L"The local DLSS package is incomplete. Missing files:\n\n" + missing_files
          + L"\n\nThe game was not started and no Vulkan layer was enabled.");
      return 6;
    }

    // Failure is intentionally non-fatal: the layer will see no READY marker,
    // skip NGX extensions and preserve native TAA while diagnostics remain live.
    (void)PrepareNgxExtensionCacheIsolated(module_directory);
  } else if (!ClearProcessScopedDlssEnvironment(module_directory)) {
    LocalFree(arguments);
    ShowError(
        L"The executable is unsupported and the launcher could not remove the local DLSS "
        L"environment.\n\nThe game was not started, so the Vulkan layer cannot be loaded accidentally.");
    return 8;
  }

  // Direct launches otherwise pass through SteamAPI_RestartAppIfNecessary:
  // Steam replaces the child process and drops the process-scoped Vulkan
  // environment. Steam's `%command%` mode already has its launch context and
  // does not need this development/direct-launch hint.
  if (child_argument_start == 1
      && (SetEnvironmentVariableW(L"SteamAppId", kSteamAppId) == FALSE
          || SetEnvironmentVariableW(L"SteamGameId", kSteamAppId) == FALSE)) {
    LocalFree(arguments);
    ShowError(L"Could not prepare the direct-launch Steam application context.");
    return 7;
  }
  if (enable_dlss_layer) {
    const std::wstring layer_directory = module_directory.wstring();
    if (!PrependEnvironmentList(L"VK_ADD_LAYER_PATH", layer_directory)
        || !AppendEnvironmentList(L"VK_INSTANCE_LAYERS", kLayerName)) {
      LocalFree(arguments);
      ShowError(L"Could not prepare the child-process Vulkan layer environment.");
      return 8;
    }
  } else {
    std::wstring warning = L"Unsupported DetroitBecomeHuman.exe.\n\n";
    warning.append(unsupported_build_reason);
    warning.append(
        L"\n\nThis experimental DLSS bootstrap only supports Steam Build 12158144\n"
        L"(SHA-256 ECF52321921387E683904E089082D76B973326FC093AF14E524056715519C1CF).\n\n"
        L"DLSS/DLAA are disabled. The game will now start normally with Native TAA and "
        L"without the local Vulkan layer. The launcher does not register anything globally.");
    ShowWarning(warning);
  }

  std::wstring command_line = QuoteCommandLineArgument(executable.wstring());
  for (int index = child_argument_start; index < argument_count; ++index) {
    command_line.push_back(L' ');
    command_line.append(QuoteCommandLineArgument(arguments[index]));
  }
  LocalFree(arguments);

  STARTUPINFOW startup_info = {};
  startup_info.cb = sizeof(startup_info);
  PROCESS_INFORMATION process_info = {};
  std::vector<wchar_t> mutable_command_line(command_line.begin(), command_line.end());
  mutable_command_line.push_back(L'\0');

  const std::wstring working_directory = executable.parent_path().wstring();
  if (CreateProcessW(
          executable.c_str(),
          mutable_command_line.data(),
          nullptr,
          nullptr,
          FALSE,
          0u,
          nullptr,
          working_directory.c_str(),
          &startup_info,
          &process_info)
      == FALSE) {
    ShowError(
        enable_dlss_layer
            ? L"Could not start DetroitBecomeHuman.exe with the local Vulkan layer."
            : L"Could not start DetroitBecomeHuman.exe in Native TAA fallback mode.");
    return 9;
  }

  CloseHandle(process_info.hThread);
  WaitForSingleObject(process_info.hProcess, INFINITE);
  DWORD exit_code = 0u;
  GetExitCodeProcess(process_info.hProcess, &exit_code);
  CloseHandle(process_info.hProcess);
  return static_cast<int>(exit_code);
}
#endif
