#include <windows.h>

#include <iostream>

#include "src/mods/swapchain_v2.hpp"

extern "C" __declspec(dllexport) bool ReShadeRegisterAddon(void*, uint32_t) {
  return true;
}

extern "C" __declspec(dllexport) void ReShadeUnregisterAddon(void*) {}

extern "C" __declspec(dllexport) void ReShadeLogMessage(void*, int, const char*) {}

int main() {
  const HINSTANCE instance = GetModuleHandleW(nullptr);
  const wchar_t* class_name = L"RenoDXSwapchainChangeDetection";
  WNDCLASSW window_class = {};
  window_class.lpfnWndProc = DefWindowProcW;
  window_class.hInstance = instance;
  window_class.lpszClassName = class_name;
  if (RegisterClassW(&window_class) == 0u && GetLastError() != ERROR_CLASS_ALREADY_EXISTS) {
    return 2;
  }
  HWND window = CreateWindowExW(
      0,
      class_name,
      L"RenoDX Swapchain Change Detection",
      WS_OVERLAPPEDWINDOW,
      CW_USEDEFAULT,
      CW_USEDEFAULT,
      64,
      64,
      nullptr,
      nullptr,
      instance,
      nullptr);
  if (window == nullptr) return 3;

  namespace swapchain = renodx::mods::swapchain::v2;
  swapchain::ignored_window_class_names.clear();
  swapchain::ignored_device_apis.clear();
  swapchain::target_format = reshade::api::format::r8g8b8a8_unorm;
  swapchain::use_resize_buffer = false;
  swapchain::prevent_full_screen = false;
  swapchain::force_screen_tearing = false;
  swapchain::prevent_multiple_flip_swapchains_per_window = false;

  reshade::api::swapchain_desc desc = {};
  desc.back_buffer.texture.format = reshade::api::format::r8g8b8a8_unorm;
  desc.back_buffer.usage = reshade::api::resource_usage::render_target;
  desc.back_buffer_count = 1u;
  desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD);
  const bool changed = swapchain::OnCreateSwapchain(
      reshade::api::device_api::vulkan,
      desc,
      window);
  const bool passed = desc.back_buffer_count == 2u && changed;

  DestroyWindow(window);
  UnregisterClassW(class_name, instance);
  std::cerr << (passed ? "PASS\n" : "FAIL\n")
            << "back_buffer_count=" << desc.back_buffer_count << '\n'
            << "reported_changed=" << changed << '\n';
  return passed ? 0 : 1;
}