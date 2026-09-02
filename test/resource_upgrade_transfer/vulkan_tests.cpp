#include <windows.h>

#include <filesystem>
#include <fstream>
#include <iostream>
#include <iterator>
#include <string>

namespace fs = std::filesystem;

namespace {

std::string Read(const fs::path& path) {
  std::ifstream input(path, std::ios::binary);
  return std::string(std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>());
}

bool Copy(const fs::path& source, const fs::path& destination) {
  std::error_code error;
  fs::copy_file(source, destination, fs::copy_options::overwrite_existing, error);
  return !error;
}

}  // namespace

int main(int argc, char** argv) {
  if (argc != 5) {
    std::cerr << "usage: resource_upgrade_transfer_vulkan_tests <format> <app> <addon> <reshade-dir>\n";
    return 2;
  }

  std::string format = argv[1];
  const bool enable_addon = !format.starts_with("baseline-");
  if (!enable_addon) format.erase(0u, 9u);
  const bool inspect_upgraded = format.starts_with("inspect-");
  if (inspect_upgraded) format.erase(0u, 8u);
  const bool preserve_copy_usage = format.starts_with("preserve-");
  if (preserve_copy_usage) format.erase(0u, 9u);
  const bool direct_upgrade = format.starts_with("direct-");
  if (direct_upgrade) format.erase(0u, 7u);
  const bool limited_usage = format.starts_with("limited-");
  if (limited_usage) format.erase(0u, 8u);
  const fs::path app_source = fs::absolute(argv[2]);
  const fs::path addon_source = fs::absolute(argv[3]);
  const fs::path reshade_dir = fs::absolute(argv[4]);
  const fs::path runtime = fs::temp_directory_path()
                           / ("renodx_resource_upgrade_transfer_vulkan_" + format + "_"
                              + std::to_string(GetCurrentProcessId()));
  std::error_code error;
  fs::remove_all(runtime, error);
  error.clear();
  fs::create_directories(runtime, error);
  if (error) {
    std::cerr << "failed to create Vulkan runtime: " << error.message() << '\n';
    return 3;
  }

  const fs::path app = runtime / "resource_upgrade_transfer_vulkan_app.exe";
  const fs::path addon = runtime / addon_source.filename();
  if (!Copy(app_source, app)
      || (enable_addon && !Copy(addon_source, addon))
      || !Copy(reshade_dir / "ReShade64.dll", runtime / "ReShade64.dll")) {
    std::cerr << "failed to stage Vulkan app, addon, or ReShade layer\n";
    return 3;
  }

  std::ofstream manifest(runtime / "ReShade64.json", std::ios::binary | std::ios::trunc);
  manifest << R"({
  "file_format_version": "1.0.0",
  "layer": {
    "name": "VK_LAYER_renodx_test_reshade",
    "type": "GLOBAL",
    "library_path": ".\\ReShade64.dll",
    "api_version": "1.3.268",
    "implementation_version": "1",
    "description": "RenoDX test ReShade Vulkan layer",
    "device_extensions": [
      {
        "name": "VK_EXT_tooling_info",
        "spec_version": "1",
        "entrypoints": ["vkGetPhysicalDeviceToolPropertiesEXT"]
      }
    ]
  }
})";
  manifest.close();

  const fs::path result_path = runtime / "result.txt";
  SetEnvironmentVariableW(L"RENODX_TRANSFER_RESULT", result_path.c_str());
  SetEnvironmentVariableA("RENODX_TRANSFER_FORMAT", format.c_str());
  SetEnvironmentVariableW(L"VK_LAYER_PATH", runtime.c_str());
  SetEnvironmentVariableW(L"VK_INSTANCE_LAYERS", L"VK_LAYER_renodx_test_reshade");
  SetEnvironmentVariableW(L"DISABLE_VK_LAYER_reshade_1", L"1");
  SetEnvironmentVariableW(L"RESHADE_DISABLE_LOADING_CHECK", L"1");
  SetEnvironmentVariableW(L"RENODX_TRANSFER_INSPECT_UPGRADED", inspect_upgraded ? L"1" : nullptr);
  SetEnvironmentVariableW(L"RENODX_TRANSFER_PRESERVE_COPY_USAGE", preserve_copy_usage ? L"1" : nullptr);
  SetEnvironmentVariableW(L"RENODX_TRANSFER_DIRECT_UPGRADE", direct_upgrade ? L"1" : nullptr);
  SetEnvironmentVariableW(L"RENODX_TRANSFER_LIMITED_USAGE", limited_usage ? L"1" : nullptr);

  STARTUPINFOW startup_info = {};
  startup_info.cb = sizeof(startup_info);
  PROCESS_INFORMATION process_info = {};
  std::wstring command_line = L"\"" + app.wstring() + L"\"";
  if (!CreateProcessW(
          nullptr,
          command_line.data(),
          nullptr,
          nullptr,
          FALSE,
          0,
          nullptr,
          runtime.c_str(),
          &startup_info,
          &process_info)) {
    std::cerr << "failed to start Vulkan transfer app\n";
    return 4;
  }
  const DWORD wait_result = WaitForSingleObject(process_info.hProcess, 45000);
  DWORD exit_code = 1u;
  if (wait_result == WAIT_OBJECT_0) {
    GetExitCodeProcess(process_info.hProcess, &exit_code);
  } else {
    TerminateProcess(process_info.hProcess, 5u);
  }
  CloseHandle(process_info.hThread);
  CloseHandle(process_info.hProcess);

  const std::string result = Read(result_path);
  const std::string log = Read(runtime / "ReShade.log");
  const bool reshade_loaded = log.find("Initializing crosire's ReShade") != std::string::npos
                              || log.find("Initialized.") != std::string::npos;
  const bool addon_loaded = log.find(addon.filename().string()) != std::string::npos
                            || log.find("RenoDX Resource Upgrade Transfer Test") != std::string::npos;
  const bool bridge_created = log.find("created old-format transfer bridge") != std::string::npos;
  const bool bridge_expected = enable_addon
                               && (direct_upgrade || (limited_usage && preserve_copy_usage));
  const bool passed = wait_result == WAIT_OBJECT_0
                      && exit_code == 0u
                      && result.starts_with("PASS\n")
                      && reshade_loaded
                      && addon_loaded == enable_addon
                      && bridge_created == bridge_expected;
  std::cout << "runtime=" << runtime << '\n'
            << result;
  if (!passed) {
    std::cerr << "wait_result=" << wait_result << " app_exit=" << exit_code
              << " reshade_loaded=" << reshade_loaded
              << " addon_loaded=" << addon_loaded
              << " bridge_created=" << bridge_created
              << " bridge_expected=" << bridge_expected
              << "\nReShade.log:\n"
              << log << '\n';
  }
  return passed ? 0 : 1;
}