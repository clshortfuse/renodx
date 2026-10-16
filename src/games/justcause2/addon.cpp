/*
 * Copyright (C) 2026 RenoDX contributors
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64
#define DEBUG_LEVEL_0
#define RENODX_MODS_SWAPCHAIN_VERSION 2

#include <d3d10_1.h>
#include <atomic>
#include <optional>
#include <sstream>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

#pragma comment(lib, "d3d10.lib")

namespace {

constexpr float OUTPUT_PRESET_SDR = 0.f;
constexpr float OUTPUT_PRESET_HDR10 = 1.f;

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection = {
    .peak_white_nits = 1000.f,
    .diffuse_white_nits = 203.f,
    .graphics_white_nits = 203.f,
    .output_mode = 0.f,
    .tone_map_type = 1.f,
    .exposure = 1.f,
    .saturation = 1.f,
    .contrast = 1.f,
    .swap_chain_output_preset = OUTPUT_PRESET_SDR,
    .resource_upgrade = 1.f,
};
static_assert(sizeof(ShaderInjectData) % 16 == 0);

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "OutputMode",
        .binding = &shader_injection.output_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Display Output",
        .section = "Just Cause 2",
        .tooltip = "HDR10 is experimental. SDR is the default for comparison and validation.",
        .labels = {"SDR", "HDR10 (experimental)"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Scene Range",
        .section = "Just Cause 2",
        .tooltip = "Preserves the final scene composite before its SDR output clamp. The float scene targets and resolve aliases are experimental.",
        .labels = {"Vanilla", "Extended"},
    },
    new renodx::utils::settings::Setting{
        .key = "PeakWhiteNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .label = "Peak Brightness",
        .section = "HDR Brightness",
        .tooltip = "Display peak brightness in nits.",
        .min = 80.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.output_mode == 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "DiffuseWhiteNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "HDR Brightness",
        .tooltip = "Scene reference white in nits.",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.output_mode == 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "GraphicsWhiteNits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "HDR Brightness",
        .tooltip = "Reference white for composed HUD, menus and video. These paths still require visual validation.",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.output_mode == 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "Exposure",
        .binding = &shader_injection.exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Scene Adjustments",
        .tooltip = "Scene exposure multiplier; 1.0 preserves the original exposure.",
        .min = 0.1f,
        .max = 4.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.output_mode == 1.f && shader_injection.tone_map_type == 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "Saturation",
        .binding = &shader_injection.saturation,
        .default_value = 1.f,
        .label = "Saturation",
        .section = "Scene Adjustments",
        .min = 0.f,
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.output_mode == 1.f && shader_injection.tone_map_type == 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "Contrast",
        .binding = &shader_injection.contrast,
        .default_value = 1.f,
        .label = "Contrast",
        .section = "Scene Adjustments",
        .min = 0.5f,
        .max = 1.5f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.output_mode == 1.f && shader_injection.tone_map_type == 1.f; },
    },
};

struct __declspec(uuid("6ef67aaf-b6c3-4a66-833c-815a9f2ee511")) DeviceData {
  ID3D10StateBlock* state_block = nullptr;
  std::atomic<uint32_t> resource_log_count = 0;
  std::atomic<uint32_t> resolve_log_count = 0;
};

struct __declspec(uuid("f219d155-fd34-4992-8a68-6a4cfe99ecfa")) SwapchainData {
  std::optional<reshade::api::color_space> current_color_space;
};

// Bounded diagnostics for the scene-copy chain while the HDR path is experimental.
void LogResourceState(reshade::api::device* device, const char* event, reshade::api::resource resource) {
  const auto desc = device->get_resource_desc(resource);
  std::stringstream message;
  message << "Just Cause 2: " << event << " resource=" << PRINT_PTR(resource.handle)
          << " format=" << desc.texture.format
          << " size=" << desc.texture.width << "x" << desc.texture.height
          << " samples=" << desc.texture.samples
          << " usage=0x" << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
  const bool tracked = renodx::utils::resource::GetResourceInfo(resource, [&](const renodx::utils::resource::ResourceInfo& info) {
    message << " tracked_format=" << info.desc.texture.format
            << " swapchain=" << info.is_swap_chain
            << " clone_enabled=" << info.clone_enabled
            << " clone=" << PRINT_PTR(info.clone.handle)
            << " clone_format=" << info.clone_desc.texture.format
            << " clone_target=" << (info.clone_target != nullptr ? info.clone_target->new_format : reshade::api::format::unknown);
  });
  message << " tracked=" << tracked;
  reshade::log::message(reshade::log::level::info, message.str().c_str());
}

void OnInitResource(reshade::api::device* device,
                    const reshade::api::resource_desc& desc,
                    const reshade::api::subresource_data* initial_data,
                    reshade::api::resource_usage initial_state,
                    reshade::api::resource resource) {
  if (device->get_api() != reshade::api::device_api::d3d10) return;
  if (desc.type != reshade::api::resource_type::texture_2d) return;
  if (desc.texture.format != reshade::api::format::r8g8b8a8_typeless
      && desc.texture.format != reshade::api::format::r8g8b8a8_unorm
      && desc.texture.format != reshade::api::format::r10g10b10a2_unorm
      && desc.texture.format != reshade::api::format::r16g16b16a16_float) return;
  if (!renodx::utils::bitwise::HasAnyFlag(desc.usage, reshade::api::resource_usage::render_target)) return;
  if (desc.texture.width < 128 || desc.texture.height < 64) return;
  auto* data = device->get_private_data<DeviceData>();
  if (data == nullptr || data->resource_log_count.fetch_add(1, std::memory_order_relaxed) >= 96) return;
  LogResourceState(device, "init_resource", resource);
}

bool OnResolveTextureRegion(reshade::api::command_list* cmd_list,
                            reshade::api::resource source,
                            uint32_t source_subresource,
                            const reshade::api::subresource_box* source_box,
                            reshade::api::resource dest,
                            uint32_t dest_subresource,
                            uint32_t dest_x,
                            uint32_t dest_y,
                            uint32_t dest_z,
                            reshade::api::format format) {
  auto* device = cmd_list->get_device();
  if (device->get_api() != reshade::api::device_api::d3d10) return false;
  auto* data = device->get_private_data<DeviceData>();
  if (data == nullptr || data->resolve_log_count.fetch_add(1, std::memory_order_relaxed) >= 32) return false;
  std::stringstream message;
  message << "Just Cause 2: resolve requested_format=" << format;
  reshade::log::message(reshade::log::level::info, message.str().c_str());
  LogResourceState(device, "resolve_source", source);
  LogResourceState(device, "resolve_destination", dest);
  return false;
}

void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::d3d10) return;
  auto* data = device->create_private_data<DeviceData>();
  D3D10_STATE_BLOCK_MASK mask = {};
  D3D10StateBlockMaskEnableAll(&mask);
  if (FAILED(D3D10CreateStateBlock(reinterpret_cast<ID3D10Device*>(device->get_native()), &mask, &data->state_block))) {
    reshade::log::message(reshade::log::level::error, "Just Cause 2: failed to create the D3D10 state block; display proxy disabled.");
  }
}

void OnDestroyDevice(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::d3d10) return;
  auto* data = device->get_private_data<DeviceData>();
  if (data == nullptr) return;
  if (data->state_block != nullptr) data->state_block->Release();
  device->destroy_private_data<DeviceData>();
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (swapchain->get_device()->get_api() != reshade::api::device_api::d3d10) return;
  swapchain->create_private_data<SwapchainData>();
}

void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (swapchain->get_device()->get_api() != reshade::api::device_api::d3d10) return;
  swapchain->destroy_private_data<SwapchainData>();
}

void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
  if (queue == nullptr || swapchain == nullptr) return;
  auto* device = swapchain->get_device();
  if (device->get_api() != reshade::api::device_api::d3d10) return;
  if (!renodx::mods::swapchain::IsUpgraded(swapchain)) return;
  auto* data = device->get_private_data<DeviceData>();
  auto* swapchain_data = swapchain->get_private_data<SwapchainData>();
  if (data == nullptr || data->state_block == nullptr || swapchain_data == nullptr) return;

  const auto desired_color_space = shader_injection.output_mode == 1.f
                                       ? reshade::api::color_space::hdr10_st2084
                                       : reshade::api::color_space::srgb_nonlinear;
  if (swapchain_data->current_color_space != desired_color_space
      && renodx::utils::swapchain::ChangeColorSpace(swapchain, desired_color_space)) {
    swapchain_data->current_color_space = desired_color_space;
    reshade::log::message(reshade::log::level::info,
                          desired_color_space == reshade::api::color_space::hdr10_st2084
                              ? "Just Cause 2: display output HDR10 (PQ/BT.2020)"
                              : "Just Cause 2: display output SDR (sRGB)");
  }
  // Keep encoding matched to the last successful DXGI change; retry failures next frame.
  shader_injection.swap_chain_output_preset =
      swapchain_data->current_color_space == reshade::api::color_space::hdr10_st2084
          ? OUTPUT_PRESET_HDR10
          : OUTPUT_PRESET_SDR;

  // Generic ReShade state tracking does not capture every D3D10 binding.
  if (FAILED(data->state_block->Capture())) {
    data->state_block->ReleaseAllDeviceObjects();
    return;
  }
  renodx::mods::swapchain::v2::OnPresent(queue, swapchain, source_rect, dest_rect, dirty_rect_count, dirty_rects);
  data->state_block->Apply();
  // Captured backbuffer references must not survive until a later ResizeBuffers call.
  data->state_block->ReleaseAllDeviceObjects();
}

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"OutputMode", 0.f},
      {"ToneMapType", 0.f},
      {"PeakWhiteNits", 1000.f},
      {"DiffuseWhiteNits", 203.f},
      {"GraphicsWhiteNits", 203.f},
      {"Exposure", 1.f},
      {"Saturation", 1.f},
      {"Contrast", 1.f},
  });
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX Just Cause 2";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "Just Cause 2 HDR10 development addon (Direct3D 10.1, experimental)";

BOOL APIENTRY DllMain(HMODULE module, DWORD reason, LPVOID reserved) {
  switch (reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(module)) return FALSE;

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::expected_constant_buffer_space = 0;
      renodx::mods::swapchain::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_space = 0;
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::use_auto_cloning = false;
      renodx::mods::swapchain::SetUseHDR10(true);
      renodx::mods::swapchain::target_color_space = reshade::api::color_space::srgb_nonlinear;
      renodx::mods::swapchain::force_screen_tearing = false;
      renodx::mods::swapchain::prevent_full_screen = true;
      renodx::mods::swapchain::force_borderless = true;
      renodx::mods::swapchain::swapchain_proxy_revert_state = true;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
      renodx::mods::swapchain::ignored_device_apis = {
          reshade::api::device_api::d3d9,
          reshade::api::device_api::d3d11,
          reshade::api::device_api::d3d12,
          reshade::api::device_api::opengl,
          reshade::api::device_api::vulkan,
      };
      renodx::mods::swapchain::swap_chain_proxy_shaders = {
          {reshade::api::device_api::d3d10,
           {.vertex_shader = __swap_chain_proxy_vertex_shader,
            .pixel_shader = __swap_chain_proxy_pixel_shader}},
      };
      // Backbuffer copies and the MSAA scene resolve use both TYPELESS and UNORM.
      // The observed endpoints all have render-target usage; sampled-only textures stay native.
      reshade::register_event<reshade::addon_event::resolve_texture_region>(OnResolveTextureRegion);
      for (const auto format : {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r8g8b8a8_unorm}) {
        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = format,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
            .dimensions = {.width = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER,
                           .height = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER},
            .usage_include = reshade::api::resource_usage::render_target,
        });
      }
      renodx::utils::settings::Use(reason, &settings, &OnPresetOff);
      renodx::mods::swapchain::Use(reason, &shader_injection);
      renodx::mods::shader::Use(reason, custom_shaders, &shader_injection);
      reshade::unregister_event<reshade::addon_event::present>(renodx::mods::swapchain::v2::OnPresent);
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::unregister_event<reshade::addon_event::resolve_texture_region>(OnResolveTextureRegion);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      renodx::mods::shader::Use(reason, custom_shaders, &shader_injection);
      renodx::mods::swapchain::Use(reason, &shader_injection);
      renodx::utils::settings::Use(reason, &settings, &OnPresetOff);
      reshade::unregister_addon(module);
      break;
  }
  return TRUE;
}
