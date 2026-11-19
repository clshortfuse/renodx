/*
 * Derived from the RenoDX generic addon (Copyright (C) 2024 Carlos Lopez).
 * SPDX-License-Identifier: MIT
 */
#define ImTextureID ImU64
#define DEBUG_LEVEL_0
#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include <embed/shaders.h>
#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "shared.h"
#include "shader_sources.hpp"
#include "fixed_function.hpp"
#include "framebuffer.hpp"

namespace {
ShaderInjectData shader_injection = {1000.f, 203.f, 1.f, 1.f, 1.f, 0.f, 0.f, 0.f};
renodx::mods::shader::CustomShaders custom_shaders;
renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "OpenGLPaperWhite", .binding = &shader_injection.paper_white,
        .default_value = 203.f, .label = "Paper White", .section = "OpenGL HDR Output",
        .min = 80.f, .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "OpenGLPeakWhite", .binding = &shader_injection.peak_white,
        .default_value = 1000.f, .label = "Peak Brightness", .section = "OpenGL HDR Output",
        .min = 80.f, .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "OpenGLInputEncoding", .binding = &shader_injection.input_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f, .label = "Scene Encoding", .section = "OpenGL HDR Output",
        .tooltip = "Match the actual scene buffer. This is decoding, not inverse tone mapping.",
        .labels = {"Linear", "sRGB", "Gamma 2.2", "Gamma 2.4"},
    },
};
bool registered = false;
}

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX Generic OpenGL";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "Profile-driven GLSL/ARB replacements and compatibility-profile fixed-function tools";

BOOL APIENTRY DllMain(HMODULE module, DWORD reason, LPVOID) {
  using namespace generic_opengl;
  if (reason == DLL_PROCESS_ATTACH) {
    if (!reshade::register_addon(module)) return FALSE;
    registered = true;
    try {
      LoadProfile();
    } catch (const std::exception& error) {
      Log(std::string("Invalid profile; addon disabled: ") + error.what(), true);
      reshade::unregister_addon(module);
      registered = false;
      return FALSE;
    }
    bool hook_directx = false;
    if (profile.hdr && (!reshade::get_config_value(nullptr, "INSTALL", "HookDirectX", hook_directx) || !hook_directx)) {
      Log("HDR proxy disabled: add [INSTALL] HookDirectX=1 to ReShade.ini, then restart. Shader tools remain active.", true);
      profile.hdr = false;
      profile.default_framebuffer = false;
    }
    if (profile.hdr) {
      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;
      renodx::mods::swapchain::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::use_device_proxy = true;
      renodx::mods::swapchain::set_color_space = false;
      renodx::mods::swapchain::SetUseHDR10();
      renodx::mods::swapchain::swap_chain_proxy_shaders = {
          {reshade::api::device_api::d3d11, {
              .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
              .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
          }},
      };
      if (profile.steam_vulkan_workaround)
        SetEnvironmentVariableW(L"DISABLE_VK_LAYER_VALVE_steam_overlay_1", L"1");
      Log("HDR10 proxy enabled by profile. Verify float scene buffers before judging HDR output.");
    }
  }
  if (!registered || (reason != DLL_PROCESS_ATTACH && reason != DLL_PROCESS_DETACH)) return TRUE;
  if (reason == DLL_PROCESS_DETACH) {
    fixed::Use(reason);
    parameters::Use(reason);
    sources::Use(reason);
    if (profile.hdr) framebuffer::Use(reason);
  }
  if (profile.hdr) {
    renodx::utils::settings::Use(reason, &settings);
    renodx::mods::swapchain::Use(reason, &shader_injection);
    renodx::mods::shader::Use(reason, custom_shaders, &shader_injection);
  }
  if (reason == DLL_PROCESS_ATTACH) {
    parameters::Use(reason);
    sources::Use(reason);
    fixed::prepare_framebuffer = profile.default_framebuffer ? framebuffer::BindScene : nullptr;
    fixed::Use(reason);
    if (profile.hdr) framebuffer::Use(reason);
  } else {
    reshade::unregister_addon(module);
    registered = false;
  }
  return TRUE;
}
