/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <format>
#include <mutex>
#include <set>
#include <shared_mutex>
#include <tuple>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/state.hpp"
#include "./shared.h"

namespace {

constexpr float HDR_SCENE_COLOR_TAG = 1.f;
float hide_ui = 0.f;
float force_anisotropic_filtering = 1.f;

bool OnDrawActivateRenderTargetHotSwap(reshade::api::command_list* cmd_list) {
  auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);
  bool changed = false;
  for (auto rtv : rtvs) {
    changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv) || changed;
  }
  if (changed) {
    renodx::mods::swapchain::FlushDescriptors(cmd_list);
    renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0});
  }
  return true;
}

bool OnSceneColorDraw(reshade::api::command_list* cmd_list) {
  const auto& targets = renodx::utils::swapchain::GetRenderTargets(cmd_list);
  if (!targets.empty()) {
    reshade::api::resource scene = {0u};
    renodx::utils::resource::GetResourceViewInfo(targets[0], [&](const renodx::utils::resource::ResourceViewInfo& info) {
      scene = info.original_resource;
    });
    if (scene.handle != 0u) {
      renodx::utils::resource::UpdateResourceInfo(scene, [](renodx::utils::resource::ResourceInfo* info) {
        info->resource_tag = HDR_SCENE_COLOR_TAG;
      });
    }
  }
  return OnDrawActivateRenderTargetHotSwap(cmd_list);
}

void EnableSceneColorCopyClone(reshade::api::resource source, reshade::api::resource destination) {
  using namespace reshade::api;
  resource_desc source_desc = {};
  bool is_scene = false;
  renodx::utils::resource::GetResourceInfo(source, [&](const renodx::utils::resource::ResourceInfo& info) {
    source_desc = info.desc;
    is_scene = info.resource_tag == HDR_SCENE_COLOR_TAG && info.clone_enabled
               && source_desc.type == resource_type::texture_2d
               && info.clone_desc.texture.format == format::r16g16b16a16_float;
  });
  if (!is_scene) return;

  bool is_scene_copy = false;
  renodx::utils::resource::GetResourceInfo(destination, [&](const renodx::utils::resource::ResourceInfo& info) {
    const auto& desc = info.desc;
    is_scene_copy = !info.is_swap_chain && !info.clone_enabled && info.clone_target != nullptr
                    && desc.type == resource_type::texture_2d
                    && info.clone_target->new_format == format::r16g16b16a16_float
                    && renodx::utils::resource::AreCopyFormatsCompatible(source_desc.texture.format, desc.texture.format)
                    && desc.texture.width == source_desc.texture.width
                    && desc.texture.height == source_desc.texture.height
                    && desc.texture.levels == source_desc.texture.levels
                    && desc.texture.depth_or_layers == source_desc.texture.depth_or_layers
                    && desc.texture.samples == source_desc.texture.samples
                    && (desc.usage & resource_usage::shader_resource) != resource_usage::undefined;
  });
  if (is_scene_copy) {
    // The shared copy hook can now redirect the copy between matching float textures.
    renodx::utils::resource::upgrade::GetResourceClone(destination, {.activate = true});
  }
}

bool OnCopyResource(reshade::api::command_list*, reshade::api::resource source, reshade::api::resource destination) {
  EnableSceneColorCopyClone(source, destination);
  return false;
}

bool OnCopyTextureRegion(reshade::api::command_list*,
                         reshade::api::resource source,
                         uint32_t source_subresource,
                         const reshade::api::subresource_box*,
                         reshade::api::resource destination,
                         uint32_t destination_subresource,
                         const reshade::api::subresource_box*,
                         reshade::api::filter_mode) {
  if (source_subresource == 0u && destination_subresource == 0u) {
    EnableSceneColorCopyClone(source, destination);
  }
  return false;
}

#define UpgradeRTVActivateShader(value) {value, {.crc32 = value, .on_draw = OnDrawActivateRenderTargetHotSwap}}

bool OnUIDraw(reshade::api::command_list* cmd_list) {
  if (hide_ui != 0.f) return false;
  return OnDrawActivateRenderTargetHotSwap(cmd_list);
}

// Adapted scene luminance (texel 0,0 of a 2x1 typeless target), read by the bloom composite as t1.
reshade::api::resource adapted_luminance_resource = {0u};
reshade::api::resource_view adapted_luminance_srv = {0u};

bool OnDrawAdaptedLuminance(reshade::api::command_list* cmd_list) {
  const auto& rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);
  if (rtvs.empty()) return true;
  reshade::api::resource luminance = {0u};
  renodx::utils::resource::GetResourceViewInfo(rtvs[0], [&](const renodx::utils::resource::ResourceViewInfo& view_info) {
    renodx::utils::resource::GetResourceInfo(view_info.original_resource, [&](const renodx::utils::resource::ResourceInfo& info) {
      const auto& desc = info.desc;
      if (desc.type == reshade::api::resource_type::texture_2d && desc.texture.width == 2u && desc.texture.height == 1u
          && desc.texture.format == reshade::api::format::r32g32b32a32_typeless) {
        luminance = view_info.original_resource;
      }
    });
  });
  if (luminance.handle == 0u || luminance.handle == adapted_luminance_resource.handle) return true;

  auto* device = cmd_list->get_device();
  if (adapted_luminance_srv.handle != 0u) device->destroy_resource_view(adapted_luminance_srv);
  adapted_luminance_srv = {0u};
  adapted_luminance_resource = luminance;
  device->create_resource_view(luminance, reshade::api::resource_usage::shader_resource,
                               reshade::api::resource_view_desc(reshade::api::format::r32g32b32a32_float), &adapted_luminance_srv);
  return true;
}

void OnDestroyAdaptedLuminance(reshade::api::device* device, reshade::api::resource resource) {
  if (resource.handle == 0u || resource.handle != adapted_luminance_resource.handle) return;
  if (adapted_luminance_srv.handle != 0u) device->destroy_resource_view(adapted_luminance_srv);
  adapted_luminance_srv = {0u};
  adapted_luminance_resource = {0u};
}

ShaderInjectData shader_injection = {.fx_bloom = 1.f, .fx_bloom_haze = 0.5f};

renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0x00000000),
    {0x9B0FFAEA, {.crc32 = 0x9B0FFAEA, .code = __0x9B0FFAEA, .on_draw = OnSceneColorDraw}},
    CustomShaderEntry(0x52056D48),
    CustomShaderEntry(0xA34F96B7),
    CustomShaderEntry(0xABCF725C),
    {0x603902B6, {.crc32 = 0x603902B6, .on_draw = OnDrawAdaptedLuminance}},
    // Menu encode: its target may be a pooled gameplay scene target, so drop the HDR scene tag.
    {0x561A891D,
     {
         .crc32 = 0x561A891D,
         .on_draw = [](reshade::api::command_list* cmd_list) {
           const auto& targets = renodx::utils::swapchain::GetRenderTargets(cmd_list);
           if (!targets.empty()) {
             renodx::utils::resource::GetResourceViewInfo(targets[0], [](const renodx::utils::resource::ResourceViewInfo& view_info) {
               renodx::utils::resource::UpdateResourceInfo(view_info.original_resource, [](renodx::utils::resource::ResourceInfo* info) {
                 info->resource_tag = 0.f;
               });
             });
           }
           return OnDrawActivateRenderTargetHotSwap(cmd_list);
         },
     }},
    {0x4F5BFBCA, {.crc32 = 0x4F5BFBCA, .code = __0x4F5BFBCA, .on_draw = OnSceneColorDraw}},
    // FXAA (used when TAA is off). Only follow the HDR scene: menus feed it from 0x561A891D and keep their SDR path.
    {0x615A736C,
     {
         .crc32 = 0x615A736C,
         .on_draw = [](reshade::api::command_list* cmd_list) {
           const auto input = renodx::utils::state::GetBoundResourceView(
               cmd_list, reshade::api::shader_stage::pixel,
               reshade::api::descriptor_type::shader_resource_view, 0u);
           bool is_scene = false;
           renodx::utils::resource::GetResourceViewInfo(input, [&](const renodx::utils::resource::ResourceViewInfo& view_info) {
             renodx::utils::resource::GetResourceInfo(view_info.original_resource, [&](const renodx::utils::resource::ResourceInfo& info) {
               is_scene = info.resource_tag == HDR_SCENE_COLOR_TAG;
             });
           });
           return is_scene ? OnSceneColorDraw(cmd_list) : true;
         },
     }},
    {0x64D80996,
     {
         .crc32 = 0x64D80996,
         .code = __0x64D80996,
         .on_draw = [](reshade::api::command_list* cmd_list) {
           // The HDR bloom target keeps its original R11G11B10 format; other targets get the composite scale.
           shader_injection.bloom_composite = 0.f;
           shader_injection.bloom_luminance_valid = 0.f;
           shader_injection.bloom_target_level = 0.f;
           const auto& rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);
           if (rtvs.empty()) return true;
           renodx::utils::resource::GetResourceViewInfo(rtvs[0], [](const renodx::utils::resource::ResourceViewInfo& view_info) {
             renodx::utils::resource::GetResourceInfo(view_info.original_resource, [](const renodx::utils::resource::ResourceInfo& info) {
               shader_injection.bloom_composite = (info.desc.texture.format != reshade::api::format::r11g11b10_float) ? 1.f : 0.f;
             });
           });
           if (shader_injection.bloom_composite == 0.f) {
             shader_injection.bloom_target_level = static_cast<float>(cmd_list->get_device()->get_resource_view_desc(rtvs[0]).texture.first_level);
           }
           if (shader_injection.bloom_composite != 0.f && adapted_luminance_srv.handle != 0u) {
             cmd_list->push_descriptors(
                 reshade::api::shader_stage::pixel, {0u}, 0u,
                 {
                     .binding = 1u,
                     .count = 1u,
                     .type = reshade::api::descriptor_type::shader_resource_view,
                     .descriptors = &adapted_luminance_srv,
                 });
             shader_injection.bloom_luminance_valid = 1.f;
           }
           return true;
         },
         .on_drawn = [](reshade::api::command_list* cmd_list) {
           if (shader_injection.bloom_luminance_valid == 0.f) return;
           const reshade::api::resource_view null_view = {0u};
           cmd_list->push_descriptors(
               reshade::api::shader_stage::pixel, {0u}, 0u,
               {
                   .binding = 1u,
                   .count = 1u,
                   .type = reshade::api::descriptor_type::shader_resource_view,
                   .descriptors = &null_view,
               });
         },
     }},
    UpgradeRTVActivateShader(0xBCC5FDDF),
    {0x2D75AA3E,
     {
         .crc32 = 0x2D75AA3E,
         .code = __0x2D75AA3E,
         .on_draw = [](reshade::api::command_list* cmd_list) {
           const auto output = renodx::utils::state::GetBoundResourceView(
               cmd_list, reshade::api::shader_stage::compute,
               reshade::api::descriptor_type::unordered_access_view, 0u);
           if (!renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), output)) return true;

           // FSR has already bound this UAV for the current dispatch.
           const auto clone = renodx::mods::swapchain::GetResourceViewClone(output);
           if (clone.handle != 0u) {
             cmd_list->push_descriptors(
                 reshade::api::shader_stage::compute, {0u}, 0u,
                 {
                     .binding = 0u,
                     .count = 1u,
                     .type = reshade::api::descriptor_type::unordered_access_view,
                     .descriptors = &clone,
                 });
           }
           return true;
         },
     }},
    CustomShaderEntry(0x1647456A),
    {0x206A75B8, {.crc32 = 0x206A75B8, .code = __0x206A75B8, .on_draw = OnSceneColorDraw}},
    UpgradeRTVActivateShader(0xB2662150),
    UpgradeRTVActivateShader(0x41E7813C),
    {0x45485E16, {.crc32 = 0x45485E16, .code = __0x45485E16, .on_draw = OnUIDraw}},
    {0xBBCF2D91, {.crc32 = 0xBBCF2D91, .code = __0xBBCF2D91, .on_draw = OnUIDraw}},
    {0xD644D2E2, {.crc32 = 0xD644D2E2, .code = __0xD644D2E2, .on_draw = OnUIDraw}},
    // CustomSwapchainShader(0x00000000),
    // BypassShaderEntry(0x00000000),
    // __ALL_CUSTOM_SHADERS
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "HideUI",
        .binding = &hide_ui,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "Hide UI",
        .section = "Effects",
        .tooltip = "Hides the game's SurfRide UI, including its background layers.",
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 65.f,
        .label = "Highlight Saturation",
        .section = "Tone Mapping",
        .tooltip = "Source color kept in highlights near peak. Lower = whiter, hotter highlights.",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxChromaticAberration",
        .binding = &shader_injection.chromatic_aberration,
        .default_value = 100.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .tooltip = "Scales the game's contextual RGB separation. 100% uses the game's strength.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.fx_bloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 200.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloomThreshold",
        .binding = &shader_injection.fx_bloom_threshold,
        .default_value = 0.f,
        .label = "Bloom Threshold",
        .section = "Effects",
        .tooltip = "Removes low-level bloom haze, relative to auto exposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloomHaze",
        .binding = &shader_injection.fx_bloom_haze,
        .default_value = 50.f,
        .label = "Bloom Haze",
        .section = "Effects",
        .tooltip = "Fades the widest bloom levels that veil the whole screen and raise blacks. Lower = less haze; local glow stays.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxRCAS",
        .binding = &shader_injection.custom_rcas,
        .default_value = 50.f,
        .label = "RCAS Sharpening",
        .section = "Effects",
        .tooltip = "Controls Lilium's HDR RCAS before HUD compositing.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ForceAnisotropicFiltering",
        .binding = &force_anisotropic_filtering,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Anisotropic Filtering",
        .section = "Effects",
        .tooltip = "Forces 16x anisotropic filtering on material textures. Requires game restart.",
        .labels = {"Game Default", "16x"},
    },
};

std::shared_mutex sampler_log_mutex;
std::set<std::tuple<reshade::api::filter_mode, reshade::api::texture_address_mode, reshade::api::texture_address_mode,
                    reshade::api::texture_address_mode, float, float, reshade::api::compare_op>>
    logged_sampler_descs;

bool OnCreateSampler(reshade::api::device*, reshade::api::sampler_desc& desc) {
  if (force_anisotropic_filtering == 0.f) {
    return false;
  }

  const bool is_linear_or_anisotropic = desc.filter == reshade::api::filter_mode::min_mag_mip_linear ||
                                        desc.filter == reshade::api::filter_mode::anisotropic;
  const bool has_wrap_address = desc.address_u == reshade::api::texture_address_mode::wrap ||
                                desc.address_v == reshade::api::texture_address_mode::wrap;
  const bool should_override = is_linear_or_anisotropic && has_wrap_address;

  bool is_new_desc = false;
  {
    std::lock_guard<std::shared_mutex> lock(sampler_log_mutex);
    is_new_desc = logged_sampler_descs
                      .emplace(desc.filter, desc.address_u, desc.address_v, desc.address_w, desc.mip_lod_bias,
                               desc.max_anisotropy, desc.compare_op)
                      .second;
  }
  if (is_new_desc) {
    reshade::log::message(
        reshade::log::level::info,
        std::format("Sampler filter=0x{:X} address=({},{},{}) mip_lod_bias={} max_anisotropy={} compare_op={} overridden={}",
                    static_cast<uint32_t>(desc.filter), static_cast<uint32_t>(desc.address_u),
                    static_cast<uint32_t>(desc.address_v), static_cast<uint32_t>(desc.address_w), desc.mip_lod_bias,
                    desc.max_anisotropy, static_cast<uint32_t>(desc.compare_op), should_override)
            .c_str());
  }

  if (should_override) {
    desc.filter = reshade::api::filter_mode::anisotropic;
    desc.max_anisotropy = 16.f;
  }
  return should_override;
}

void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
  auto* device = queue->get_device();
  if (device->get_api() == reshade::api::device_api::opengl) {
    shader_injection.custom_flip_uv_y = 1.f;
  }
}

bool initialized = false;
bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[0]->default_value = roundf(peak.value());
    settings[0]->can_reset = true;
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Sonic X Shadow Generations";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
            {
                reshade::api::device_api::d3d12,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
                },
            },
        };

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainForceBorderless",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Force Borderless",
              .section = "Display Output",
              .tooltip = "Forces fullscreen to be borderless for proper HDR",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::force_borderless = (current == 1.f); },
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::force_borderless = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainPreventFullscreen",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Prevent Fullscreen",
              .section = "Display Output",
              .tooltip = "Prevent exclusive fullscreen for proper HDR",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        renodx::mods::swapchain::SetUseHDR10(true);
        renodx::mods::swapchain::use_resize_buffer = false;

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxy",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Use Display Proxy",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool use_device_proxy = setting->GetValue() == 1.f;
          renodx::mods::swapchain::use_device_proxy = use_device_proxy;
          renodx::mods::swapchain::set_color_space = !use_device_proxy;
          if (use_device_proxy) {
            reshade::register_event<reshade::addon_event::present>(OnPresent);
          } else {
            shader_injection.custom_flip_uv_y = 0.f;
          }
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxyBaseWaitIdle",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Base Wait Idle",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool use_device_proxy =
              renodx::mods::swapchain::device_proxy_wait_idle_source = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxyProxyWaitIdle",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Proxy Wait Idle",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool use_device_proxy =
              renodx::mods::swapchain::device_proxy_wait_idle_destination = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        for (const auto old_format : {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r10g10b10a2_unorm}) {
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = old_format,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .ignore_size = false,
              .use_resource_view_cloning = true,
              .use_resource_view_hot_swap = true,
              .aspect_ratio = static_cast<float>((old_format == reshade::api::format::r8g8b8a8_typeless)
                                                     ? renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER
                                                     : renodx::mods::swapchain::SwapChainUpgradeTarget::ANY),
          });
        }

        reshade::register_event<reshade::addon_event::copy_resource>(OnCopyResource);
        reshade::register_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
        reshade::register_event<reshade::addon_event::create_sampler>(OnCreateSampler);
        reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyAdaptedLuminance);
        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(OnDestroyAdaptedLuminance);
      reshade::unregister_event<reshade::addon_event::create_sampler>(OnCreateSampler);
      reshade::unregister_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
      reshade::unregister_event<reshade::addon_event::copy_resource>(OnCopyResource);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::use_presets = false;
  renodx::utils::settings::Use(fdw_reason, &settings);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
