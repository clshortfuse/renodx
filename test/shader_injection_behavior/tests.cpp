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
    std::cerr << "usage: shader_injection_behavior_tests <mode> <app> <addon> <reshade-dir>\n";
    return 2;
  }

  const std::string mode = argv[1];
  if (mode != "root-signature" && mode != "descriptor-ownership") {
    std::cerr << "unknown test mode: " << mode << '\n';
    return 2;
  }

  const fs::path app_source = fs::absolute(argv[2]);
  const fs::path addon_source = fs::absolute(argv[3]);
  const fs::path reshade_dir = fs::absolute(argv[4]);
  const fs::path runtime = fs::temp_directory_path()
                           / ("renodx_shader_injection_" + std::to_string(GetCurrentProcessId()));
  std::error_code error;
  fs::remove_all(runtime, error);
  error.clear();
  fs::create_directories(runtime, error);
  if (error) {
    std::cerr << "failed to create runtime: " << error.message() << '\n';
    return 3;
  }

  const fs::path app = runtime / "shader_injection_behavior_app.exe";
  const fs::path addon = runtime / addon_source.filename();
  if (!Copy(app_source, app)
      || !Copy(addon_source, addon)
      || !Copy(reshade_dir / "ReShade64.dll", runtime / "dxgi.dll")) {
    std::cerr << "failed to stage D3D12 root-signature test\n";
    return 3;
  }

  const fs::path result_path = runtime / "result.txt";
  SetEnvironmentVariableW(L"RENODX_ROOT_SIGNATURE_RESULT", result_path.c_str());
  SetEnvironmentVariableA("RENODX_SHADER_INJECTION_TEST_MODE", mode.c_str());

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
    std::cerr << "failed to start D3D12 root-signature test\n";
    return 4;
  }
  const DWORD wait_result = WaitForSingleObject(process_info.hProcess, 45000);
  DWORD exit_code = 1u;
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
                            || log.find("RenoDX D3D12 Root Signature Test") != std::string::npos;
  const bool passed = wait_result == WAIT_OBJECT_0
                      && exit_code == 0u
                      && result.starts_with("PASS\n")
                      && reshade_loaded
                      && addon_loaded;

  std::cout << "runtime=" << runtime << '\n'
            << result;
  if (!passed) {
    std::cerr << "wait_result=" << wait_result << " app_exit=" << exit_code
              << "\nReShade.log:\n"
              << log << '\n';
  }
  return passed ? 0 : 1;
}