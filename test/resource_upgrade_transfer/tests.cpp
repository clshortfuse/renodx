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
    std::cerr << "usage: resource_upgrade_transfer_tests <format> <app> <addon> <reshade-dir>\n";
    return 2;
  }

  const std::string format = argv[1];
  const fs::path helper_source = fs::absolute(argv[2]);
  const fs::path addon_source = fs::absolute(argv[3]);
  const fs::path reshade_dir = fs::absolute(argv[4]);
  const fs::path runtime = fs::temp_directory_path()
                           / ("renodx_resource_upgrade_transfer_" + format + "_"
                              + std::to_string(GetCurrentProcessId()));
  std::error_code error;
  fs::remove_all(runtime, error);
  error.clear();
  fs::create_directories(runtime, error);
  if (error) {
    std::cerr << "failed to create runtime: " << error.message() << '\n';
    return 3;
  }

  const fs::path helper = runtime / "resource_upgrade_transfer_app.exe";
  const fs::path addon = runtime / addon_source.filename();
  if (!Copy(helper_source, helper) || !Copy(addon_source, addon)) {
    std::cerr << "failed to stage helper or addon in " << runtime << '\n';
    return 3;
  }

  if (!Copy(reshade_dir / "ReShade64.dll", runtime / "dxgi.dll")) {
    std::cerr << "failed to stage DXGI ReShade proxy\n";
    return 3;
  }

  const fs::path result_path = runtime / "result.txt";
  SetEnvironmentVariableW(L"RENODX_TRANSFER_RESULT", result_path.c_str());
  SetEnvironmentVariableA("RENODX_TRANSFER_FORMAT", format.c_str());

  STARTUPINFOW startup_info = {};
  startup_info.cb = sizeof(startup_info);
  PROCESS_INFORMATION process_info = {};
  std::wstring command_line = L"\"" + helper.wstring() + L"\"";
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
    std::cerr << "failed to start helper in " << runtime << '\n';
    return 4;
  }
  const DWORD wait_result = WaitForSingleObject(process_info.hProcess, 45000);
  DWORD exit_code = 1;
  if (wait_result == WAIT_OBJECT_0) {
    GetExitCodeProcess(process_info.hProcess, &exit_code);
  } else {
    TerminateProcess(process_info.hProcess, 5);
  }
  CloseHandle(process_info.hThread);
  CloseHandle(process_info.hProcess);

  const std::string result = Read(result_path);
  const std::string log = Read(runtime / "ReShade.log");
  const bool reshade_loaded = log.find("Initializing crosire's ReShade") != std::string::npos
                              || log.find("Initialized.") != std::string::npos;
  const bool addon_loaded = log.find(addon.filename().string()) != std::string::npos
                            || log.find("RenoDX Resource Upgrade Transfer Test") != std::string::npos;
  const bool passed = wait_result == WAIT_OBJECT_0
                      && exit_code == 0
                      && result.starts_with("PASS\n")
                      && reshade_loaded
                      && addon_loaded;
  std::cout << "runtime=" << runtime << '\n'
            << result;
  if (!reshade_loaded) std::cerr << "ReShade initialization was not found in ReShade.log\n";
  if (!addon_loaded) std::cerr << "test addon was not found in ReShade.log\n";
  if (!passed) {
    std::cerr << "wait_result=" << wait_result << " helper_exit=" << exit_code
              << "\nReShade.log:\n"
              << log << '\n';
  }
  return passed ? 0 : 1;
}