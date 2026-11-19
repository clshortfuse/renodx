/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <algorithm>
#include <cctype>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/platform.hpp"
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

// Full-resolution scene copy sampled by the motion blur shader (t4) when the Full-Res setting is on.
reshade::api::resource motion_blur_source_copy = {0u};
reshade::api::resource_view motion_blur_source_copy_srv = {0u};
reshade::api::resource_desc motion_blur_source_copy_desc = {};
float motion_blur_full_res = 1.f;

void OnDestroyMotionBlurSourceCopy(reshade::api::device* device) {
  if (motion_blur_source_copy_srv.handle != 0u) device->destroy_resource_view(motion_blur_source_copy_srv);
  if (motion_blur_source_copy.handle != 0u) device->destroy_resource(motion_blur_source_copy);
  motion_blur_source_copy_srv = {0u};
  motion_blur_source_copy = {0u};
  motion_blur_source_copy_desc = {};
}

ShaderInjectData shader_injection = {
    .fx_bloom = 1.f,
    .fx_bloom_haze = 0.5f,
    .fx_motion_blur = 2.f,
    .fx_motion_blur_samples = 16.f,
    .fx_motion_blur_strength = 1.f,
    .fx_motion_blur_full_res = 0.f,
};

bool ShouldReplaceFog(reshade::api::command_list*) {
  return shader_injection.fx_fog_coverage_reduction > 0.f || shader_injection.fx_fog_light_reduction > 0.f;
}

renodx::mods::shader::CustomShaders sonic_generations_shaders = {
    CustomShaderEntry(0xCB53C7B8),
    CustomShaderEntry(0x4A3AB530),
    CustomShaderEntry(0xBE28D522),
    CustomShaderEntry(0x23D31A08),
    CustomShaderEntry(0x13BB64BB),
    CustomShaderEntry(0xE8E88C62),  // final composite (gameplay): linear bloom add
    CustomShaderEntry(0xD7E59862),  // final composite (menu path): linear bloom add
    CustomShaderEntry(0x2AE7A8E5),  // bloom bright pass: threshold scaled by the Bloom Threshold setting
    CustomShaderEntry(0xC31D7195),  // bloom bright pass (luma-based): threshold scaled by the Bloom Threshold setting
    CustomShaderEntry(0x5F91F19E),  // motion blur: Improved writes the velocity map for the composites
};

renodx::mods::shader::CustomShaders custom_shaders = {
    {0x9B0FFAEA, {.crc32 = 0x9B0FFAEA, .code = __0x9B0FFAEA, .on_draw = OnSceneColorDraw}},
    {0x66D4C51B, {.crc32 = 0x66D4C51B, .code = __0x66D4C51B, .on_draw = OnSceneColorDraw}},
    {0xD757A516, {.crc32 = 0xD757A516, .code = __0xD757A516, .on_draw = OnSceneColorDraw}},
    // Shared tonemap VS: tags the scene for any tonemap PS variant.
    {0x8D7AD5BC, {.crc32 = 0x8D7AD5BC, .on_draw = OnSceneColorDraw}},
    {0x52056D48, {.crc32 = 0x52056D48, .code = __0x52056D48}},
    {0xBE4BB0CF, {.crc32 = 0xBE4BB0CF, .code = __0xBE4BB0CF, .on_replace = ShouldReplaceFog}},
    {0x4D38C3EC, {.crc32 = 0x4D38C3EC, .code = __0x4D38C3EC, .on_replace = ShouldReplaceFog}},
    {0xAA56C63D, {.crc32 = 0xAA56C63D, .code = __0xAA56C63D, .on_replace = ShouldReplaceFog}},
    {0xDD8552DF, {.crc32 = 0xDD8552DF, .code = __0xDD8552DF, .on_replace = ShouldReplaceFog}},
    {0xA34F96B7,
     {
         .crc32 = 0xA34F96B7,
         .code = __0xA34F96B7,
         .on_draw = [](reshade::api::command_list* cmd_list) {
           shader_injection.fx_motion_blur_full_res = 0.f;
           // Motion blur is alpha-blended, so skipping the draw removes it.
           if (shader_injection.fx_motion_blur == 0.f) return false;
           if (shader_injection.fx_motion_blur == 2.f && motion_blur_full_res != 0.f) {
             const auto& rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);
             if (rtvs.empty()) return true;
             auto* device = cmd_list->get_device();
             // The game's RGBA8 target is cloned to float; the clone holds the rendered frame.
             auto source = device->get_resource_from_view(rtvs[0]);
             renodx::utils::resource::GetResourceViewInfo(rtvs[0], [&source](const renodx::utils::resource::ResourceViewInfo& view_info) {
               if (view_info.clone_enabled && view_info.clone_resource.handle != 0u) source = view_info.clone_resource;
             });
             const auto desc = device->get_resource_desc(source);
             const bool is_copy_stale = motion_blur_source_copy.handle == 0u
                                        || desc.texture.width != motion_blur_source_copy_desc.texture.width
                                        || desc.texture.height != motion_blur_source_copy_desc.texture.height
                                        || desc.texture.format != motion_blur_source_copy_desc.texture.format;
             if (is_copy_stale) {
               if (motion_blur_source_copy_srv.handle != 0u) device->destroy_resource_view(motion_blur_source_copy_srv);
               if (motion_blur_source_copy.handle != 0u) device->destroy_resource(motion_blur_source_copy);
               reshade::api::resource_desc copy_desc = {};
               copy_desc.type = reshade::api::resource_type::texture_2d;
               copy_desc.texture = {desc.texture.width, desc.texture.height, 1, 1, desc.texture.format, 1};
               copy_desc.heap = reshade::api::memory_heap::gpu_only;
               copy_desc.usage = reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource;
               copy_desc.flags = reshade::api::resource_flags::none;
               device->create_resource(copy_desc, nullptr, reshade::api::resource_usage::shader_resource, &motion_blur_source_copy);
               device->create_resource_view(
                   motion_blur_source_copy, reshade::api::resource_usage::shader_resource,
                   reshade::api::resource_view_desc(reshade::api::format_to_default_typed(desc.texture.format)),
                   &motion_blur_source_copy_srv);
               motion_blur_source_copy_desc = copy_desc;
             }
             cmd_list->copy_resource(source, motion_blur_source_copy);
             cmd_list->push_descriptors(
                 reshade::api::shader_stage::pixel, {0u}, 0u,
                 {
                     .binding = 4u,
                     .count = 1u,
                     .type = reshade::api::descriptor_type::shader_resource_view,
                     .descriptors = &motion_blur_source_copy_srv,
                 });
             shader_injection.fx_motion_blur_full_res = 1.f;
           }
           return true;
         },
         .on_drawn = [](reshade::api::command_list* cmd_list) {
           if (shader_injection.fx_motion_blur_full_res == 0.f) return;
           const reshade::api::resource_view null_view = {0u};
           cmd_list->push_descriptors(
               reshade::api::shader_stage::pixel, {0u}, 0u,
               {
                   .binding = 4u,
                   .count = 1u,
                   .type = reshade::api::descriptor_type::shader_resource_view,
                   .descriptors = &null_view,
               });
         },
     }},
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
    {0x9C942ECA,
     {
         .crc32 = 0x9C942ECA,
         .code = __0x9C942ECA,
         .on_draw = [](reshade::api::command_list* cmd_list) {
           // Extraction runs before the current frame updates adaptation.
           shader_injection.bloom_luminance_valid = 0.f;
           if (shader_injection.fx_bloom_threshold > 0.f && adapted_luminance_srv.handle != 0u) {
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
    {0x64D80996,
     {
         .crc32 = 0x64D80996,
         .code = __0x64D80996,
         .on_draw = [](reshade::api::command_list* cmd_list) {
           // The HDR bloom target keeps its original R11G11B10 format; other targets get the composite scale.
           shader_injection.bloom_composite = 0.f;
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
           return true;
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
};

// Shadow palette: crimson primary, deeper blood red for secondary sections, ember for effects.
constexpr uint32_t TINT_CRIMSON = 0xE0101A;
constexpr uint32_t TINT_BLOOD = 0xB00C16;
constexpr uint32_t TINT_ASH = 0x8A8A8A;

// Sonic Generations palette: blue primary, deeper blue for secondary sections, small red accent, white for neutral.
constexpr uint32_t TINT_SONIC_BLUE = 0x1E5BFF;
constexpr uint32_t TINT_SONIC_DEEP = 0x0B3A9E;
constexpr uint32_t TINT_SONIC_WHITE = 0xDCE6FF;

namespace settings_ui = renodx::utils::settings;

renodx::utils::settings::Settings settings = {
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::CUSTOM,
        .label = "Shadow Banner",
        .section = "SHADOW",
        .tooltip = "RenoDX HDR for Sonic X Shadow Generations. Peak Brightness is set under Display.",
        .on_draw = []() {
          auto* draw_list = ImGui::GetWindowDrawList();
          const ImVec2 min = ImGui::GetCursorScreenPos();
          const float width = ImGui::GetContentRegionAvail().x;
          const float height = ImGui::GetFrameHeight() * 2.4f;
          const ImVec2 max = {min.x + width, min.y + height};
          draw_list->AddRectFilledMultiColor(min, max, IM_COL32(6, 6, 8, 255), IM_COL32(150, 8, 16, 255),
                                             IM_COL32(224, 16, 26, 255), IM_COL32(12, 6, 8, 255));
          draw_list->AddRectFilled(min, {min.x + 6.f, max.y}, IM_COL32(224, 16, 26, 255));
          draw_list->AddRect(min, max, IM_COL32(224, 16, 26, 255));
          const float title_size = ImGui::GetFontSize() * 1.5f;
          draw_list->AddText(ImGui::GetFont(), title_size, {min.x + 16.f, min.y + 6.f}, IM_COL32(255, 255, 255, 255),
                             "SONIC X SHADOW GENERATIONS");
          draw_list->AddText({min.x + 16.f, min.y + 10.f + title_size}, IM_COL32(255, 120, 120, 255),
                             "RenoDX HDR  //  ULTIMATE LIFE FORM");
          ImGui::Dummy({width, height});
          return false;
        },
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::BUTTON,
        .label = "Reset All To Defaults",
        .section = "SHADOW",
        .tooltip = "Restores every setting to its default value.",
        .tint = TINT_CRIMSON,
        .on_change = []() { settings_ui::ResetSettings(); },
    },

    // Display
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "Output levels for your HDR display.",
        .section = "Display",
        .tint = TINT_CRIMSON,
    },
    new settings_ui::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Display",
        .tooltip = "Sets the value of peak white in nits",
        .tint = TINT_CRIMSON,
        .min = 48.f,
        .max = 4000.f,
    },
    new settings_ui::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Display",
        .tooltip = "Sets the value of 100% white in nits",
        .tint = TINT_CRIMSON,
        .min = 48.f,
        .max = 500.f,
    },
    new settings_ui::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Display",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .tint = TINT_CRIMSON,
        .min = 48.f,
        .max = 500.f,
    },

    // Tone Mapping
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "How scene brightness and color are mapped to HDR.",
        .section = "Tone Mapping",
        .tint = TINT_BLOOD,
    },
    new settings_ui::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = TINT_BLOOD,
    },
    new settings_ui::Setting{
        .key = "ToneMapVanillaHueInfluence",
        .binding = &shader_injection.tone_map_scene_hue_influence,
        .default_value = 100.f,
        .label = "Vanilla Hue Influence",
        .section = "Tone Mapping",
        .tooltip = "Matches the game's SDR hue where it retains color. Fades toward scene hue in washed-out highlights.",
        .tint = TINT_BLOOD,
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return (100.f - value) * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "ToneMapHighlightChromaRollOff",
        .binding = &shader_injection.highlight_chroma_rolloff_offset,
        .default_value = 10.f,
        .label = "Highlight Chroma Roll-off",
        .section = "Tone Mapping",
        .tooltip = "Controls how color rolls off in the brightest highlights.",
        .tint = TINT_BLOOD,
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f - 0.1f; },
    },

    // Color Grading
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "Neutral is the default of each slider.",
        .section = "Color Grading",
        .tint = TINT_CRIMSON,
    },
    new settings_ui::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .tooltip = "Scales overall scene brightness. 1.00 is neutral.",
        .tint = TINT_CRIMSON,
        .max = 2.f,
        .format = "%.2f",
    },
    new settings_ui::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .tooltip = "Adjusts the brightest tones. 50 is neutral.",
        .tint = TINT_CRIMSON,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .tooltip = "Adjusts the darkest tones. 50 is neutral.",
        .tint = TINT_CRIMSON,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .tooltip = "Adjusts tonal contrast. 50 is neutral.",
        .tint = TINT_CRIMSON,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .tooltip = "Adjusts color intensity. 50 is neutral.",
        .tint = TINT_CRIMSON,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },

    // Bloom & Fog
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "Glow and atmosphere.",
        .section = "Bloom & Fog",
        .tint = TINT_CRIMSON,
    },
    new settings_ui::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.fx_bloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Bloom & Fog",
        .tooltip = "Scales bloom intensity. 100% uses the game's strength.",
        .tint = TINT_CRIMSON,
        .max = 200.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxBloomThreshold",
        .binding = &shader_injection.fx_bloom_threshold,
        .default_value = 0.f,
        .label = "Bloom Threshold",
        .section = "Bloom & Fog",
        .tooltip = "Filters dim bloom sources before blur, relative to adapted scene luminance.",
        .tint = TINT_CRIMSON,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.fx_bloom != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "FxBloomHaze",
        .binding = &shader_injection.fx_bloom_haze,
        .default_value = 50.f,
        .label = "Bloom Haze",
        .section = "Bloom & Fog",
        .tooltip = "Fades the widest bloom levels that veil the whole screen and raise blacks. Lower = less haze; local glow stays.",
        .tint = TINT_CRIMSON,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.fx_bloom != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxFogCoverage",
        .binding = &shader_injection.fx_fog_coverage_reduction,
        .default_value = 100.f,
        .label = "Fog Coverage",
        .section = "Bloom & Fog",
        .tooltip = "Controls how much distance and height fog obscures the scene.",
        .tint = TINT_CRIMSON,
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return (100.f - value) * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxFogLight",
        .binding = &shader_injection.fx_fog_light_reduction,
        .default_value = 100.f,
        .label = "Fog Light",
        .section = "Bloom & Fog",
        .tooltip = "Controls the light added by distance and height fog without changing its coverage.",
        .tint = TINT_CRIMSON,
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return (100.f - value) * 0.01f; },
    },

    // Motion Blur
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "Improved replaces the game's blur with a higher quality one.",
        .section = "Motion Blur",
        .tint = TINT_BLOOD,
    },
    new settings_ui::Setting{
        .key = "FxMotionBlur",
        .binding = &shader_injection.fx_motion_blur,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Motion Blur",
        .section = "Motion Blur",
        .tooltip = "Off removes motion blur, Vanilla keeps the game's, Improved uses RenoDX's.",
        .labels = {"Off", "Vanilla", "Improved"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = TINT_BLOOD,
    },
    new settings_ui::Setting{
        .key = "FxMotionBlurStrength",
        .binding = &shader_injection.fx_motion_blur_strength,
        .default_value = 100.f,
        .label = "Strength",
        .section = "Motion Blur",
        .tooltip = "Scales blur length. Requires motion blur to be on.",
        .tint = TINT_BLOOD,
        .max = 200.f,
        .is_enabled = []() { return shader_injection.fx_motion_blur != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxMotionBlurSamples",
        .binding = &shader_injection.fx_motion_blur_samples,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 16.f,
        .label = "Samples",
        .section = "Motion Blur",
        .tooltip = "Blur quality. More samples are smoother but cost performance. Improved mode only.",
        .tint = TINT_BLOOD,
        .min = 4.f,
        .max = 32.f,
        .format = "%d",
        .is_enabled = []() { return shader_injection.fx_motion_blur == 2.f; },
    },
    new settings_ui::Setting{
        .key = "FxMotionBlurFullRes",
        .binding = &motion_blur_full_res,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Full-Res Source",
        .section = "Motion Blur",
        .tooltip = "Samples the full-resolution scene instead of the game's reduced source. Improved mode only.",
        .labels = {"Off", "On"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = TINT_BLOOD,
        .is_enabled = []() { return shader_injection.fx_motion_blur == 2.f; },
    },

    // Lens & Sharpening
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "Lens effects and final image sharpness.",
        .section = "Lens & Sharpening",
        .tint = TINT_CRIMSON,
    },
    new settings_ui::Setting{
        .key = "FxChromaticAberration",
        .binding = &shader_injection.chromatic_aberration,
        .default_value = 100.f,
        .label = "Chromatic Aberration",
        .section = "Lens & Sharpening",
        .tooltip = "Scales the game's contextual RGB separation. 100% uses the game's strength.",
        .tint = TINT_CRIMSON,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxRCAS",
        .binding = &shader_injection.custom_rcas,
        .default_value = 50.f,
        .label = "RCAS Sharpening",
        .section = "Lens & Sharpening",
        .tooltip = "Controls Lilium's HDR RCAS before HUD compositing.",
        .tint = TINT_CRIMSON,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },

    // Interface & Advanced
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "Interface toggles and engine overrides.",
        .section = "Interface & Advanced",
        .tint = TINT_ASH,
    },
    new settings_ui::Setting{
        .key = "HideUI",
        .binding = &hide_ui,
        .value_type = settings_ui::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "Hide UI",
        .section = "Interface & Advanced",
        .tooltip = "Hides the game's SurfRide UI, including its background layers.",
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = TINT_ASH,
    },
    new settings_ui::Setting{
        .key = "ForceAnisotropicFiltering",
        .binding = &force_anisotropic_filtering,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Anisotropic Filtering",
        .section = "Interface & Advanced",
        .tooltip = "Forces 16x anisotropic filtering on material textures. Requires game restart.",
        .labels = {"Game Default", "16x"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = TINT_ASH,
    },

    // Links
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::BUTTON,
        .label = "Buy Ostad a coffee",
        .section = "Links",
        .tint = 0xFF5F5F,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/ostadgaming"); },
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "links",
        .tint = TINT_CRIMSON,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/", "t9v7wx9NTD"); },
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::BUTTON,
        .label = "RenoDX GitHub",
        .section = "Links",
        .group = "links",
        .tint = TINT_BLOOD,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx"); },
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "links",
        .tint = TINT_ASH,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods"); },
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "SONIC X SHADOW GENERATIONS RenoDX mod made by Ostad.",
        .section = "Links",
        .tint = TINT_ASH,
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "RenoDX by Carlos Lopez (clshortfuse) and contributors.",
        .section = "Links",
        .tint = TINT_ASH,
    },
};

// Sonic Generations shows the tone map and color grade subset of `settings`, filled in DllMain.
settings_ui::Settings sonic_generations_settings = {};

bool OnCreateSampler(reshade::api::device*, reshade::api::sampler_desc& desc) {
  if (force_anisotropic_filtering == 0.f) {
    return false;
  }

  const bool is_linear_or_anisotropic = desc.filter == reshade::api::filter_mode::min_mag_mip_linear ||
                                        desc.filter == reshade::api::filter_mode::anisotropic;
  const bool has_wrap_address = desc.address_u == reshade::api::texture_address_mode::wrap ||
                                desc.address_v == reshade::api::texture_address_mode::wrap;
  const bool should_override = is_linear_or_anisotropic && has_wrap_address;

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
bool is_sonic_generations = false;
bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    auto* peak_setting = renodx::utils::settings::FindSetting("ToneMapPeakNits");
    peak_setting->default_value = roundf(peak.value());
    peak_setting->can_reset = true;
  }
}

// Swapchain and Display Output setup shared by both games. Settings it creates are appended to target_settings.
void SetupSwapChain(settings_ui::Settings* target_settings) {
  renodx::mods::swapchain::expected_constant_buffer_index = 9;
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
    target_settings->push_back(setting);
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
    target_settings->push_back(setting);
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
    target_settings->push_back(setting);
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
    renodx::mods::swapchain::device_proxy_wait_idle_source = (setting->GetValue() == 1.f);
    target_settings->push_back(setting);
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
    renodx::mods::swapchain::device_proxy_wait_idle_destination = (setting->GetValue() == 1.f);
    target_settings->push_back(setting);
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Sonic X Shadow Generations";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      {
        auto filename = renodx::utils::platform::GetCurrentProcessPath().filename().string();
        std::transform(filename.begin(), filename.end(), filename.begin(), [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
        if (filename == "sonic_generations.exe") {
          is_sonic_generations = true;
        }
      }

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 9;
      renodx::mods::shader::allow_multiple_push_constants = true;

      if (is_sonic_generations) {
        renodx::utils::settings::global_name = "renodx-sonicgenerations";

        // Only one game runs per process, so the copied Shadow settings can take Sonic tints in place.
        auto copy_shadow_section = [](std::string_view section, uint32_t tint) {
          for (auto* setting : settings) {
            // Vanilla Hue Influence depends on Shadow's Uchimura reference curve, and Sonic has no UI brightness path
            // (graphics white is fixed in shared.h), so both settings are excluded.
            if (setting->section != section || setting->value_type == settings_ui::SettingValueType::TEXT) continue;
            if (setting->key == "ToneMapVanillaHueInfluence" || setting->key == "ToneMapUINits") continue;
            setting->tint = tint;
            if (setting->key == "ToneMapHighlightChromaRollOff") {
              setting->default_value = 0.f;
              setting->value = 0.f;
            }
            sonic_generations_settings.push_back(setting);
          }
        };

        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::CUSTOM,
            .label = "Sonic Banner",
            .section = "SONIC",
            .tooltip = "RenoDX HDR for Sonic Generations. Peak Brightness is set under Display.",
            .on_draw = []() {
              auto* draw_list = ImGui::GetWindowDrawList();
              const ImVec2 min = ImGui::GetCursorScreenPos();
              const float width = ImGui::GetContentRegionAvail().x;
              const float height = ImGui::GetFrameHeight() * 2.4f;
              const ImVec2 max = {min.x + width, min.y + height};
              draw_list->AddRectFilledMultiColor(min, max, IM_COL32(6, 10, 30, 255), IM_COL32(20, 70, 200, 255),
                                                 IM_COL32(30, 91, 255, 255), IM_COL32(8, 12, 36, 255));
              draw_list->AddRectFilled(min, {min.x + 6.f, max.y}, IM_COL32(30, 91, 255, 255));
              draw_list->AddRect(min, max, IM_COL32(30, 91, 255, 255));
              draw_list->AddRectFilled({min.x, max.y - 3.f}, max, IM_COL32(255, 255, 255, 255));
              const float title_size = ImGui::GetFontSize() * 1.5f;
              draw_list->AddText(ImGui::GetFont(), title_size, {min.x + 16.f, min.y + 6.f}, IM_COL32(255, 255, 255, 255),
                                 "SONIC GENERATIONS");
              draw_list->AddText({min.x + 16.f, min.y + 10.f + title_size}, IM_COL32(150, 190, 255, 255),
                                 "RenoDX HDR  //  GOTTA GO FAST");
              ImGui::Dummy({width, height});
              return false;
            },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::BUTTON,
            .label = "Reset All To Defaults",
            .section = "SONIC",
            .tooltip = "Restores every setting to its default value.",
            .tint = TINT_SONIC_BLUE,
            .on_change = []() { settings_ui::ResetSettings(); },
        });

        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::TEXT,
            .label = "Output levels for your HDR display.",
            .section = "Display",
            .tint = TINT_SONIC_BLUE,
        });
        copy_shadow_section("Display", TINT_SONIC_BLUE);

        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::TEXT,
            .label = "How scene brightness and color are mapped to HDR.",
            .section = "Tone Mapping",
            .tint = TINT_SONIC_DEEP,
        });
        copy_shadow_section("Tone Mapping", TINT_SONIC_DEEP);
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGHighlightRollOff",
            .binding = &shader_injection.sg_highlight_rolloff,
            .default_value = 0.f,
            .label = "Highlight Roll-off",
            .section = "Tone Mapping",
            .tooltip = "Compresses brightness just above paper white. 0 keeps the game's linear highlights; 100 rolls them off the most.",
            .tint = TINT_SONIC_DEEP,
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
        });

        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::TEXT,
            .label = "Neutral is the default of each slider.",
            .section = "Color Grading",
            .tint = TINT_SONIC_BLUE,
        });
        copy_shadow_section("Color Grading", TINT_SONIC_BLUE);

        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::TEXT,
            .label = "Glow from the game's bright highlights.",
            .section = "Bloom",
            .tint = TINT_SONIC_BLUE,
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGBloom",
            .binding = &shader_injection.sg_bloom_enabled,
            .value_type = settings_ui::SettingValueType::INTEGER,
            .default_value = 1.f,
            .label = "Bloom",
            .section = "Bloom",
            .tooltip = "Turns the game's bloom on or off.",
            .labels = {"Off", "On"},
            .style = settings_ui::SettingStyle::SEGMENTED,
            .tint = TINT_SONIC_BLUE,
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGBloomStrength",
            .binding = &shader_injection.sg_bloom_strength,
            .default_value = 100.f,
            .label = "Bloom Strength",
            .section = "Bloom",
            .tooltip = "Scales the game's glow strength.",
            .tint = TINT_SONIC_BLUE,
            .max = 200.f,
            .is_enabled = []() { return shader_injection.sg_bloom_enabled != 0.f; },
            .parse = [](float value) { return value * 0.01f; },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGBloomThreshold",
            .binding = &shader_injection.sg_bloom_threshold,
            .default_value = 100.f,
            .label = "Bloom Threshold",
            .section = "Bloom",
            .tooltip = "Scales the game's bright-pass threshold. Lower = more of the scene blooms.",
            .tint = TINT_SONIC_BLUE,
            .min = 25.f,
            .max = 300.f,
            .is_enabled = []() { return shader_injection.sg_bloom_enabled != 0.f; },
            .parse = [](float value) { return value * 0.01f; },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGBloomHDR",
            .binding = &shader_injection.sg_bloom_hdr,
            .default_value = 0.f,
            .label = "HDR Bloom",
            .section = "Bloom",
            .tooltip = "0% keeps vanilla's bloom limit; higher lets very bright sources glow more.",
            .tint = TINT_SONIC_BLUE,
            .max = 100.f,
            .is_enabled = []() { return shader_injection.sg_bloom_enabled != 0.f; },
            .parse = [](float value) { return value * 0.01f; },
        });

        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::TEXT,
            .label = "Improved replaces the game's blur with a higher quality one.",
            .section = "Motion Blur",
            .tint = TINT_SONIC_DEEP,
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGMotionBlur",
            .binding = &shader_injection.sg_motion_blur,
            .value_type = settings_ui::SettingValueType::INTEGER,
            .default_value = 2.f,
            .label = "Motion Blur",
            .section = "Motion Blur",
            .tooltip = "Off removes motion blur, Vanilla keeps the game's, Improved blurs the full-resolution scene with RenoDX's.",
            .labels = {"Off", "Vanilla", "Improved"},
            .style = settings_ui::SettingStyle::SEGMENTED,
            .tint = TINT_SONIC_DEEP,
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGMotionBlurStrength",
            .binding = &shader_injection.sg_motion_blur_strength,
            .default_value = 100.f,
            .label = "Strength",
            .section = "Motion Blur",
            .tooltip = "Scales the blur length. Improved mode only.",
            .tint = TINT_SONIC_DEEP,
            .max = 200.f,
            .is_enabled = []() { return shader_injection.sg_motion_blur == 2.f; },
            .parse = [](float value) { return value * 0.01f; },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGMotionBlurSamples",
            .binding = &shader_injection.sg_motion_blur_samples,
            .value_type = settings_ui::SettingValueType::INTEGER,
            .default_value = 16.f,
            .label = "Samples",
            .section = "Motion Blur",
            .tooltip = "Blur quality. More samples are smoother but cost performance. Improved mode only.",
            .tint = TINT_SONIC_DEEP,
            .min = 8.f,
            .max = 32.f,
            .format = "%d",
            .is_enabled = []() { return shader_injection.sg_motion_blur == 2.f; },
        });

        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::BUTTON,
            .label = "Buy Ostad a coffee",
            .section = "Links",
            .tint = TINT_SONIC_WHITE,
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/ostadgaming"); },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::BUTTON,
            .label = "RenoDX Discord",
            .section = "Links",
            .group = "links",
            .tint = TINT_SONIC_BLUE,
            .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/", "t9v7wx9NTD"); },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::BUTTON,
            .label = "RenoDX GitHub",
            .section = "Links",
            .group = "links",
            .tint = TINT_SONIC_DEEP,
            .on_change = []() { renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx"); },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::BUTTON,
            .label = "More Mods",
            .section = "Links",
            .group = "links",
            .tint = TINT_SONIC_WHITE,
            .on_change = []() { renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods"); },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::TEXT,
            .label = "SONIC X SHADOW GENERATIONS RenoDX mod made by Ostad.",
            .section = "Links",
            .tint = TINT_SONIC_WHITE,
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .value_type = settings_ui::SettingValueType::TEXT,
            .label = "RenoDX by Carlos Lopez (clshortfuse) and contributors.",
            .section = "Links",
            .tint = TINT_SONIC_WHITE,
        });

        SetupSwapChain(&sonic_generations_settings);
        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = false,
            .use_resource_view_cloning = true,
            .aspect_ratio = static_cast<float>(renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER),
        });
        break;
      }

      if (!initialized) {
        SetupSwapChain(&settings);

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
        reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyMotionBlurSourceCopy);
        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      if (is_sonic_generations) {
        reshade::unregister_event<reshade::addon_event::present>(OnPresent);
        reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
        reshade::unregister_addon(h_module);
        break;
      }
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(OnDestroyAdaptedLuminance);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyMotionBlurSourceCopy);
      reshade::unregister_event<reshade::addon_event::create_sampler>(OnCreateSampler);
      reshade::unregister_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
      reshade::unregister_event<reshade::addon_event::copy_resource>(OnCopyResource);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::use_presets = false;
  if (is_sonic_generations) {
    renodx::utils::settings::Use(fdw_reason, &sonic_generations_settings);
    renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
    renodx::mods::shader::Use(fdw_reason, sonic_generations_shaders, &shader_injection);
    return TRUE;
  }
  renodx::utils::settings::Use(fdw_reason, &settings);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
