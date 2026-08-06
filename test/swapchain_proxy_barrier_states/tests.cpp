#include <windows.h>

#include <filesystem>
#include <fstream>
#include <iostream>
#include <iterator>
#include <optional>
#include <string>

namespace fs = std::filesystem;

namespace {

std::string Read(const fs::path& path) {
  std::ifstream input(path, std::ios::binary);
  return std::string(
      std::istreambuf_iterator<char>(input),
      std::istreambuf_iterator<char>());
}

bool Write(const fs::path& path, const std::string& value) {
  std::ofstream output(path, std::ios::binary);
  output << value;
  return output.good();
}

bool Copy(const fs::path& source, const fs::path& destination) {
  std::error_code error;
  fs::copy_file(source, destination, fs::copy_options::overwrite_existing, error);
  return !error;
}

struct EnvironmentVariable {
  std::wstring name;
  std::optional<std::wstring> previous_value;

  EnvironmentVariable(const wchar_t* variable_name, const std::wstring& value)
      : name(variable_name) {
    const DWORD required = GetEnvironmentVariableW(name.c_str(), nullptr, 0u);
    if (required != 0u) {
      std::wstring old_value(required, L'\0');
      const DWORD written = GetEnvironmentVariableW(
          name.c_str(), old_value.data(), required);
      if (written != 0u) {
        old_value.resize(written);
        previous_value = std::move(old_value);
      }
    }
    SetEnvironmentVariableW(name.c_str(), value.c_str());
  }

  ~EnvironmentVariable() {
    SetEnvironmentVariableW(
        name.c_str(),
        previous_value.has_value() ? previous_value->c_str() : nullptr);
  }

  EnvironmentVariable(const EnvironmentVariable&) = delete;
  EnvironmentVariable& operator=(const EnvironmentVariable&) = delete;
};

}  // namespace

int main(int argc, char** argv) {
  if (argc != 8) {
    std::cerr
        << "usage: swapchain_proxy_barrier_states_tests <vkcube> <addon>"
           " <vertex-spv> <pixel-spv> <reshade-dir> <reshade-manifest>"
           " <vulkan-layer-dir>\n";
    return 2;
  }

  const fs::path app_source = fs::absolute(argv[1]);
  const fs::path addon_source = fs::absolute(argv[2]);
  const fs::path vertex_shader_source = fs::absolute(argv[3]);
  const fs::path pixel_shader_source = fs::absolute(argv[4]);
  const fs::path reshade_dir = fs::absolute(argv[5]);
  const fs::path reshade_manifest_source = fs::absolute(argv[6]);
  const fs::path vulkan_layer_dir = fs::absolute(argv[7]);
  const fs::path runtime = fs::temp_directory_path()
                           / ("renodx_swapchain_proxy_vulkan_"
                              + std::to_string(GetCurrentProcessId()));
  std::error_code error;
  fs::remove_all(runtime, error);
  error.clear();
  fs::create_directories(runtime, error);
  if (error) {
    std::cerr << "failed to create runtime: " << error.message() << '\n';
    return 3;
  }

  const fs::path app = runtime / "renodx_vulkan_swapchain_app.exe";
  const fs::path addon = runtime / addon_source.filename();
  if (!Copy(app_source, app)
      || !Copy(addon_source, addon)
      || !Copy(vertex_shader_source, runtime / "swap_chain_proxy_vertex_shader.spv")
      || !Copy(pixel_shader_source, runtime / "swap_chain_proxy_pixel_shader.spv")
      || !Copy(reshade_dir / "ReShade64.dll", runtime / "ReShade64.dll")) {
    std::cerr << "failed to stage runtime in " << runtime << '\n';
    return 3;
  }

  std::string manifest = Read(reshade_manifest_source);
  const std::string original_layer_name = "VK_LAYER_reshade";
  const std::string test_layer_name = "VK_LAYER_renodx_test_reshade";
  for (size_t offset = manifest.find(original_layer_name);
       offset != std::string::npos;
       offset = manifest.find(original_layer_name, offset + test_layer_name.size())) {
    manifest.replace(offset, original_layer_name.size(), test_layer_name);
  }
  if (!Write(runtime / "ReShadeTest64.json", manifest)
      || !Write(
          runtime / "vk_layer_settings.txt",
          "khronos_validation.debug_action = VK_DBG_LAYER_ACTION_LOG_MSG\n"
          "khronos_validation.log_filename = validation.log\n"
          "khronos_validation.report_flags = error\n"
          "khronos_validation.enable_message_limit = true\n"
          "khronos_validation.duplicate_message_limit = 20\n"
          "khronos_validation.message_id_filter = "
          "VUID-vkGetPrivateData-objectHandle-09498\n")) {
    std::cerr << "failed to write Vulkan layer configuration\n";
    return 3;
  }

  const std::wstring layer_path = runtime.wstring() + L";" + vulkan_layer_dir.wstring();
  EnvironmentVariable vk_layer_path(L"VK_LAYER_PATH", layer_path);
  EnvironmentVariable vk_instance_layers(
      L"VK_INSTANCE_LAYERS",
      L"VK_LAYER_renodx_test_reshade;VK_LAYER_KHRONOS_validation");
  EnvironmentVariable vk_layer_settings_path(
      L"VK_LAYER_SETTINGS_PATH", runtime.wstring());
  EnvironmentVariable disable_global_reshade(
      L"DISABLE_VK_LAYER_reshade_1", L"1");
  EnvironmentVariable disable_loading_check(
      L"RESHADE_DISABLE_LOADING_CHECK", L"1");

  STARTUPINFOW startup_info = {};
  startup_info.cb = sizeof(startup_info);
  PROCESS_INFORMATION process_info = {};
  std::wstring command_line = L"\"" + app.wstring()
                              +
                              L"\" --c 12 --suppress_popups"
                              L" --width 64 --height 64";
  if (CreateProcessW(
          nullptr,
          command_line.data(),
          nullptr,
          nullptr,
          FALSE,
          0,
          nullptr,
          runtime.c_str(),
          &startup_info,
          &process_info)
      == FALSE) {
    std::cerr << "failed to start Vulkan helper in " << runtime << '\n';
    return 4;
  }

  const DWORD wait_result = WaitForSingleObject(process_info.hProcess, 45000u);
  DWORD exit_code = 1u;
  if (wait_result == WAIT_OBJECT_0) {
    GetExitCodeProcess(process_info.hProcess, &exit_code);
  } else {
    TerminateProcess(process_info.hProcess, 5u);
  }
  CloseHandle(process_info.hThread);
  CloseHandle(process_info.hProcess);

  const std::string log = Read(runtime / "ReShade.log");
  const fs::path validation_log = runtime / "validation.log";
  const std::string validation = Read(validation_log);
  const bool reshade_loaded =
      log.find("Initializing crosire's ReShade") != std::string::npos
      && log.find("Redirecting vkCreateSwapchainKHR") != std::string::npos;
  const bool validation_loaded = fs::exists(validation_log);
  const bool addon_loaded =
      log.find(addon.filename().string()) != std::string::npos
      || log.find("RenoDX Vulkan Swapchain Proxy Barrier Test")
             != std::string::npos;
  const bool proxy_ran =
      log.find("Vulkan swapchain proxy compatibility pass ran.")
      != std::string::npos;
  const bool validation_failed =
      validation.find("Validation Error") != std::string::npos;
  const bool passed = wait_result == WAIT_OBJECT_0
                      && exit_code == 0u
                      && reshade_loaded
                      && validation_loaded
                      && addon_loaded
                      && proxy_ran
                      && !validation_failed;

  std::cout << "runtime=" << runtime << '\n'
            << "helper_exit=" << exit_code << '\n'
            << "reshade_loaded=" << reshade_loaded << '\n'
            << "validation_loaded=" << validation_loaded << '\n'
            << "addon_loaded=" << addon_loaded << '\n'
            << "proxy_ran=" << proxy_ran << '\n'
            << "validation_errors=" << validation_failed << '\n';
  if (!passed) {
    std::cerr << "wait_result=" << wait_result << "\nvalidation.log:\n"
              << validation << "\nReShade.log:\n"
              << log << '\n';
  }
  return passed ? 0 : 1;
}