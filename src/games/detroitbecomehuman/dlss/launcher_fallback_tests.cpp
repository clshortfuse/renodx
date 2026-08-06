/*
 * SPDX-License-Identifier: MIT
 */

#define RENODX_DETROIT_LAUNCHER_TESTING 1
#include "launcher.cpp"

#include <iostream>

namespace {

struct EnvironmentSnapshot {
  const wchar_t* name = nullptr;
  bool existed = false;
  std::wstring value;
};

EnvironmentSnapshot CaptureEnvironment(const wchar_t* name) {
  EnvironmentSnapshot snapshot = {.name = name};
  SetLastError(ERROR_SUCCESS);
  const DWORD required = GetEnvironmentVariableW(name, nullptr, 0u);
  snapshot.existed = required != 0u || GetLastError() != ERROR_ENVVAR_NOT_FOUND;
  if (required == 0u) return snapshot;

  snapshot.value.resize(required, L'\0');
  const DWORD written = GetEnvironmentVariableW(name, snapshot.value.data(), required);
  if (written < required) snapshot.value.resize(written);
  return snapshot;
}

void RestoreEnvironment(const EnvironmentSnapshot& snapshot) {
  (void)SetEnvironmentVariableW(
      snapshot.name,
      snapshot.existed ? snapshot.value.c_str() : nullptr);
}

bool IsEnvironmentVariableAbsent(const wchar_t* name) {
  SetLastError(ERROR_SUCCESS);
  return GetEnvironmentVariableW(name, nullptr, 0u) == 0u
         && GetLastError() == ERROR_ENVVAR_NOT_FOUND;
}

}  // namespace

int main() {
  constexpr std::array<const wchar_t*, 9u> environment_names = {
      L"VK_INSTANCE_LAYERS",
      L"VK_ADD_LAYER_PATH",
      L"VK_LAYER_PATH",
      L"VK_LOADER_LAYERS_ENABLE",
      L"VK_LOADER_LAYERS_DISABLE",
      L"VK_LOADER_LAYERS_ALLOW",
      L"RENODX_DETROIT_NGX_DEVICE_EXTENSIONS_READY",
      L"RENODX_DETROIT_NGX_INSTANCE_EXTENSIONS",
      L"RENODX_DETROIT_NGX_DEVICE_EXTENSIONS",
  };
  std::vector<EnvironmentSnapshot> snapshots;
  snapshots.reserve(environment_names.size());
  for (const wchar_t* const name : environment_names) {
    snapshots.push_back(CaptureEnvironment(name));
  }

  const std::filesystem::path local_directory =
      L"C:\\Detroit DLSS Local Package";
  bool seeded =
      SetEnvironmentVariableW(
          L"VK_INSTANCE_LAYERS",
          L"VK_LAYER_OTHER_A;VK_LAYER_RENODX_detroit_dlss;VK_LAYER_OTHER_B")
          != FALSE
      && SetEnvironmentVariableW(
             L"VK_ADD_LAYER_PATH",
             (std::wstring(L"C:\\OtherA;") + local_directory.wstring()
              + L";C:\\OtherB")
                 .c_str())
             != FALSE
      && SetEnvironmentVariableW(
             L"VK_LAYER_PATH",
             (local_directory.wstring() + L";C:\\OtherC").c_str())
             != FALSE;
  for (const wchar_t* const name : kDlssCacheEnvironment) {
    seeded &= SetEnvironmentVariableW(name, L"launcher-fallback-test") != FALSE;
  }
  for (const wchar_t* const name : {
           L"VK_LOADER_LAYERS_ENABLE",
           L"VK_LOADER_LAYERS_DISABLE",
           L"VK_LOADER_LAYERS_ALLOW",
       }) {
    seeded &= SetEnvironmentVariableW(name, L"preserve-user-filter") != FALSE;
  }

  const bool cleared = seeded && ClearProcessScopedDlssEnvironment(local_directory);
  bool fallback_is_scoped = cleared;
  fallback_is_scoped &=
      GetEnvironmentValue(L"VK_INSTANCE_LAYERS")
      == L"VK_LAYER_OTHER_A;VK_LAYER_OTHER_B";
  fallback_is_scoped &=
      GetEnvironmentValue(L"VK_ADD_LAYER_PATH")
      == L"C:\\OtherA;C:\\OtherB";
  fallback_is_scoped &=
      GetEnvironmentValue(L"VK_LAYER_PATH") == L"C:\\OtherC";
  for (const wchar_t* const name : kDlssCacheEnvironment) {
    fallback_is_scoped &= IsEnvironmentVariableAbsent(name);
  }
  for (const wchar_t* const name : {
           L"VK_LOADER_LAYERS_ENABLE",
           L"VK_LOADER_LAYERS_DISABLE",
           L"VK_LOADER_LAYERS_ALLOW",
       }) {
    fallback_is_scoped &=
        GetEnvironmentValue(name) == L"preserve-user-filter";
  }

  for (const auto& snapshot : snapshots) RestoreEnvironment(snapshot);
  if (!fallback_is_scoped) {
    std::wcerr
        << L"Unsupported-build fallback modified unrelated Vulkan environment.\n";
  }
  return fallback_is_scoped ? 0 : 2;
}
