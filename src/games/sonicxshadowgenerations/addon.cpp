/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <algorithm>
#include <cctype>
#include <optional>
#include <string_view>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/state.hpp"
#include "./shared.h"
#include "./ui.hpp"

namespace {

constexpr float HDR_SCENE_COLOR_TAG = 1.f;
float force_anisotropic_filtering = 0.f;

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
  if (adapted_luminance_srv.handle != 0u) {
    device->destroy_resource_view(adapted_luminance_srv);
  }
  adapted_luminance_srv = {0u};
  adapted_luminance_resource = luminance;
  device->create_resource_view(luminance, reshade::api::resource_usage::shader_resource,
                               reshade::api::resource_view_desc(reshade::api::format::r32g32b32a32_float), &adapted_luminance_srv);
  return true;
}

void OnDestroyAdaptedLuminance(reshade::api::device* device, reshade::api::resource resource) {
  if (resource.handle == 0u || resource.handle != adapted_luminance_resource.handle) return;
  if (adapted_luminance_srv.handle != 0u) {
    device->destroy_resource_view(adapted_luminance_srv);
  }
  adapted_luminance_srv = {0u};
  adapted_luminance_resource = {0u};
}

// Full-resolution scene copy sampled by the motion blur shader (t4) when the Full-Res setting is on.
reshade::api::resource motion_blur_source_copy = {0u};
reshade::api::resource_view motion_blur_source_copy_srv = {0u};
reshade::api::resource_desc motion_blur_source_copy_desc = {};
float motion_blur_full_res = 1.f;

void OnDestroyMotionBlurSourceCopy(reshade::api::device* device) {
  if (motion_blur_source_copy_srv.handle != 0u) {
    device->destroy_resource_view(motion_blur_source_copy_srv);
  }
  if (motion_blur_source_copy.handle != 0u) {
    device->destroy_resource(motion_blur_source_copy);
  }
  motion_blur_source_copy_srv = {0u};
  motion_blur_source_copy = {0u};
  motion_blur_source_copy_desc = {};
}

ShaderInjectData shader_injection = {};

void UnbindPixelShaderResource(reshade::api::command_list* cmd_list, uint32_t binding) {
  const reshade::api::resource_view null_view = {0u};
  cmd_list->push_descriptors(
      reshade::api::shader_stage::pixel, {0u}, 0u,
      {
          .binding = binding,
          .count = 1u,
          .type = reshade::api::descriptor_type::shader_resource_view,
          .descriptors = &null_view,
      });
}

bool OnMotionBlurDraw(reshade::api::command_list* cmd_list) {
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
      if (view_info.clone_enabled && view_info.clone_resource.handle != 0u) {
        source = view_info.clone_resource;
      }
    });
    const auto desc = device->get_resource_desc(source);
    const bool is_copy_stale = motion_blur_source_copy.handle == 0u
                               || desc.texture.width != motion_blur_source_copy_desc.texture.width
                               || desc.texture.height != motion_blur_source_copy_desc.texture.height
                               || desc.texture.format != motion_blur_source_copy_desc.texture.format;
    if (is_copy_stale) {
      OnDestroyMotionBlurSourceCopy(device);
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
    CustomShaderEntry(0x3CB9BFBB),  // AE metering: center-weighted log average (Custom mode)
    CustomShaderEntry(0xBDF6C074),  // AE eye adaptation: brighter/darker speeds (Custom mode)
};

#define UpgradeRTVActivateShader(value) {value, {.crc32 = value, .on_draw = OnDrawActivateRenderTargetHotSwap}}

renodx::mods::shader::CustomShaders custom_shaders = {
    {0x9B0FFAEA, {.crc32 = 0x9B0FFAEA, .code = __0x9B0FFAEA, .on_draw = OnSceneColorDraw}},
    {0x66D4C51B, {.crc32 = 0x66D4C51B, .code = __0x66D4C51B, .on_draw = OnSceneColorDraw}},
    {0xD757A516, {.crc32 = 0xD757A516, .code = __0xD757A516, .on_draw = OnSceneColorDraw}},
    // Shared tonemap VS: tags the scene for any tonemap PS variant.
    {0x8D7AD5BC, {.crc32 = 0x8D7AD5BC, .on_draw = OnSceneColorDraw}},
    {0x52056D48, {.crc32 = 0x52056D48, .code = __0x52056D48}},
    {0xA34F96B7,
     {
         .crc32 = 0xA34F96B7,
         .code = __0xA34F96B7,
         .on_draw = OnMotionBlurDraw,
         .on_drawn = [](reshade::api::command_list* cmd_list) {
           if (shader_injection.fx_motion_blur_full_res == 0.f) return;
           UnbindPixelShaderResource(cmd_list, 4u);
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
           if (is_scene) return OnSceneColorDraw(cmd_list);
           return true;
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
           UnbindPixelShaderResource(cmd_list, 1u);
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
               shader_injection.bloom_composite = ((info.desc.texture.format != reshade::api::format::r11g11b10_float) ? 1.f : 0.f);
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
    {0x45485E16, {.crc32 = 0x45485E16, .code = __0x45485E16, .on_draw = OnDrawActivateRenderTargetHotSwap}},
    {0xBBCF2D91, {.crc32 = 0xBBCF2D91, .code = __0xBBCF2D91, .on_draw = OnDrawActivateRenderTargetHotSwap}},
    {0xD644D2E2, {.crc32 = 0xD644D2E2, .code = __0xD644D2E2, .on_draw = OnDrawActivateRenderTargetHotSwap}},
};

namespace settings_ui = renodx::utils::settings;

// Panel palette: Shadow by default, switched to Sonic in DllMain.
const sonic_ui::Palette* palette = &sonic_ui::SHADOW;

// Sonic Generations is set in DllMain before the settings are used.
bool is_sonic_generations = false;

// Section titles, in panel order.
constexpr const char* STATUS_SECTION = "Status";
constexpr const char* TONE_MAPPING_SECTION = "Tone Mapping";
constexpr const char* COLOR_GRADING_SECTION = "Color Grading";
constexpr const char* DEPTH_OF_FIELD_SECTION = "Depth of Field";
constexpr const char* BLOOM_SECTION = "Bloom";
constexpr const char* AUTO_EXPOSURE_SECTION = "Auto Exposure";
constexpr const char* MOTION_BLUR_SECTION = "Motion Blur";
constexpr const char* LENS_SHARPENING_SECTION = "Lens & Sharpening";
constexpr const char* TEXTURE_FILTERING_SECTION = "Texture Filtering";
constexpr const char* ABOUT_SECTION = "About";

// Both games use an r10g10b10a2 swapchain, so Output Mode switches between SDR sRGB and HDR10.
// These pointers let HandleOutputModeChange read the user's HDR values back.
settings_ui::Setting* output_mode_setting = nullptr;
settings_ui::Setting* tone_map_peak_nits_setting = nullptr;
settings_ui::Setting* tone_map_game_nits_setting = nullptr;
settings_ui::Setting* tone_map_ui_nits_setting = nullptr;

reshade::api::swapchain* tracked_swapchain = nullptr;
std::optional<reshade::api::color_space> next_color_space = std::nullopt;

void HandleOutputModeChange() {
  if (output_mode_setting->GetValue() == 0.f) {
    next_color_space = reshade::api::color_space::srgb_nonlinear;
    shader_injection.swap_chain_output_preset = 0.f;
    shader_injection.peak_white_nits = 203.f;
    shader_injection.diffuse_white_nits = 203.f;
    shader_injection.graphics_white_nits = 203.f;
    shader_injection.gamma_correction = 0.f;
  } else {
    next_color_space = reshade::api::color_space::hdr10_st2084;
    shader_injection.swap_chain_output_preset = 1.f;
    shader_injection.gamma_correction = 1.f;
    shader_injection.peak_white_nits = tone_map_peak_nits_setting->GetValue();
    shader_injection.diffuse_white_nits = tone_map_game_nits_setting->GetValue();
    shader_injection.graphics_white_nits = tone_map_ui_nits_setting->GetValue();
  }
}

bool IsHDREnabled() { return shader_injection.swap_chain_output_preset == 1.f; }

renodx::utils::settings::Settings settings = {
    // Status
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::CUSTOM,
        .label = "Status",
        .section = STATUS_SECTION,
        .tint = sonic_ui::SHADOW.tint,
        .on_draw = []() {
          struct Item {
            const char* text;
            bool active;
          };
          const float motion_blur = is_sonic_generations ? shader_injection.sg_motion_blur : shader_injection.fx_motion_blur;
          Item motion_blur_item = {"Motion Blur Off", false};
          if (motion_blur == 2.f) {
            motion_blur_item = {"Improved Motion Blur", true};
          } else if (motion_blur == 1.f) {
            motion_blur_item = {"Vanilla Motion Blur", false};
          }

          const bool hdr_on = IsHDREnabled();
          const bool tone_map_on = shader_injection.tone_map_type != 0.f;
          const bool rcas_on = shader_injection.fx_sharpening != 0.f;
          const bool af_on = force_anisotropic_filtering != 0.f;
          const Item shadow_items[] = {
              {hdr_on ? "HDR10" : "SDR", hdr_on},
              {tone_map_on ? "RenoDRT" : "Vanilla", tone_map_on},
              motion_blur_item,
              {rcas_on ? "RCAS" : "Vanilla Sharpen", rcas_on},
              {af_on ? "16x AF" : "Game AF", af_on},
          };
          const bool bloom_on = shader_injection.sg_bloom_enabled != 0.f;
          const bool hdr_bloom_on = shader_injection.sg_bloom_hdr > 0.f;
          const Item sonic_items[] = {
              {hdr_on ? "HDR10" : "SDR", hdr_on},
              {tone_map_on ? "RenoDRT" : "Vanilla", tone_map_on},
              motion_blur_item,
              {bloom_on ? "Bloom" : "Bloom Off", bloom_on},
              {hdr_bloom_on ? "HDR Bloom" : "SDR Bloom", hdr_bloom_on},
          };
          const auto& items = (is_sonic_generations ? sonic_items : shadow_items);

          const float font_size = ImGui::GetFontSize();
          const float dot_radius = font_size * 0.2f;
          const float dot_gap = font_size * 0.4f;
          const float item_gap = font_size * 0.9f;
          const float line_height = ImGui::GetTextLineHeight();
          bool first = true;
          for (const auto& [text, active] : items) {
            if (!first) {
              ImGui::SameLine(0.f, item_gap);
            }
            first = false;
            const ImVec2 origin = ImGui::GetCursorScreenPos();
            ImGui::GetWindowDrawList()->AddCircleFilled(
                {origin.x + dot_radius, origin.y + (line_height * 0.5f)}, dot_radius,
                active ? palette->glow : sonic_ui::WithAlpha(palette->off_white, 0.35f), 12);
            ImGui::Dummy({(dot_radius * 2.f) + dot_gap, line_height});
            ImGui::SameLine(0.f, 0.f);
            ImGui::PushStyleColor(ImGuiCol_Text, active ? palette->off_white : sonic_ui::WithAlpha(palette->off_white, 0.5f));
            ImGui::TextUnformatted(text);
            ImGui::PopStyleColor();
          }
          return false;
        },
        .is_sticky = true,
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = STATUS_SECTION,
        .tooltip = "Restores every setting in this panel to its default value.",
        .tint = sonic_ui::SHADOW.tint,
        .on_change = []() { settings_ui::ResetSettings(); },
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "RenoDX for Sonic X Shadow Generations Made By Ostad Gaming",
        .section = STATUS_SECTION,
        .tint = sonic_ui::SHADOW.tint,
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::CUSTOM,
        .label = "Ko-fi",
        .section = STATUS_SECTION,
        .on_draw = []() {
          constexpr ImU32 kofi_red = IM_COL32(255, 94, 91, 255);
          constexpr ImU32 kofi_red_hover = IM_COL32(255, 120, 117, 255);
          constexpr ImU32 kofi_white = IM_COL32_WHITE;
          constexpr const char* kofi_text = "Buy Ostad a coffee";

          const float height = ImGui::GetFrameHeight() * 1.4f;
          const bool clicked = ImGui::InvisibleButton("##kofi", ImVec2(ImGui::GetContentRegionAvail().x, height));
          const bool hovered = ImGui::IsItemHovered();
          if (hovered) {
            ImGui::SetTooltip("Opens ko-fi.com/ostadgaming");
          }

          const ImVec2 min = ImGui::GetItemRectMin();
          const ImVec2 max = ImGui::GetItemRectMax();
          ImDrawList* draw_list = ImGui::GetWindowDrawList();
          draw_list->AddRectFilled(min, max, hovered ? kofi_red_hover : kofi_red, height * 0.5f);

          // Logo: white cup with a ring handle on the right and a red heart inside the cup.
          const float logo_size = height * 0.5f;
          const float logo_width = logo_size * 1.0f;
          const float logo_gap = logo_size * 0.5f;
          const ImVec2 text_size = ImGui::CalcTextSize(kofi_text);
          const float content_width = logo_width + logo_gap + text_size.x;
          const float logo_x = min.x + ((max.x - min.x) - content_width) * 0.5f;
          const float center_y = (min.y + max.y) * 0.5f;

          const float cup_right = logo_x + logo_size * 0.75f;
          draw_list->AddRectFilled({logo_x, center_y - logo_size * 0.4f}, {cup_right, center_y + logo_size * 0.4f}, kofi_white,
                                   logo_size * 0.12f);
          draw_list->AddCircle({cup_right, center_y}, logo_size * 0.22f, kofi_white, 16, logo_size * 0.1f);
          const float heart_x = logo_x + logo_size * 0.375f;
          const float heart_y = center_y + logo_size * 0.02f;
          draw_list->AddCircleFilled({heart_x - logo_size * 0.09f, heart_y - logo_size * 0.05f}, logo_size * 0.1f, kofi_red, 12);
          draw_list->AddCircleFilled({heart_x + logo_size * 0.09f, heart_y - logo_size * 0.05f}, logo_size * 0.1f, kofi_red, 12);
          draw_list->AddTriangleFilled({heart_x - logo_size * 0.18f, heart_y - logo_size * 0.01f},
                                       {heart_x + logo_size * 0.18f, heart_y - logo_size * 0.01f}, {heart_x, heart_y + logo_size * 0.18f},
                                       kofi_red);

          const ImVec2 text_pos = {logo_x + logo_width + logo_gap, center_y - text_size.y * 0.5f};
          draw_list->AddText(text_pos, kofi_white, kofi_text);

          if (clicked) {
            renodx::utils::platform::LaunchURL("https://ko-fi.com/ostadgaming");
          }
          return false;
        },
    },

    // Tone Mapping
    output_mode_setting = new settings_ui::Setting{
        .key = "OutputMode",
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Output Mode",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "SDR outputs the game's original image. HDR uses HDR10.",
        .labels = {"SDR", "HDR"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = sonic_ui::SHADOW.tint,
        .on_change_value = [](float previous, float current) { HandleOutputModeChange(); },
    },
    new settings_ui::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Vanilla keeps the game's SDR tone mapping. RenoDRT extends it to HDR.",
        .labels = {"Vanilla", "RenoDRT"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = sonic_ui::SHADOW.tint,
        .parse = [](float value) { return value * 3.f; },
    },
    tone_map_peak_nits_setting = new settings_ui::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Sets the value of peak white in nits",
        .tint = sonic_ui::SHADOW.tint,
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = &IsHDREnabled,
    },
    tone_map_game_nits_setting = new settings_ui::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Sets the value of 100% white in nits",
        .tint = sonic_ui::SHADOW.tint,
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHDREnabled,
    },
    tone_map_ui_nits_setting = new settings_ui::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .tint = sonic_ui::SHADOW.tint,
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHDREnabled,
    },
    new settings_ui::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = sonic_ui::SHADOW.tint,
    },
    new settings_ui::Setting{
        .key = "ToneMapVanillaHueInfluence",
        .binding = &shader_injection.tone_map_vanilla_hue_influence,
        .default_value = 100.f,
        .label = "Vanilla Hue Influence",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Matches the game's SDR hue where it retains color. Fades toward scene hue in washed-out highlights.",
        .tint = sonic_ui::SHADOW.tint,
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "ToneMapHighlightChromaRollOff",
        .binding = &shader_injection.tone_map_highlight_chroma_rolloff,
        .default_value = 0.f,
        .label = "Highlight Chroma Roll-off",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Controls how color rolls off in the brightest highlights.",
        .tint = sonic_ui::SHADOW.tint,
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },

    // Color Grading
    new settings_ui::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "Scales overall scene brightness. 1.00 is neutral.",
        .tint = sonic_ui::SHADOW.tint,
        .max = 2.f,
        .format = "%.2f",
    },
    new settings_ui::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "Adjusts the brightest tones. 50 is neutral.",
        .tint = sonic_ui::SHADOW.tint,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "Adjusts the darkest tones. 50 is neutral.",
        .tint = sonic_ui::SHADOW.tint,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "Adjusts tonal contrast. 50 is neutral.",
        .tint = sonic_ui::SHADOW.tint,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "Adjusts color intensity. 50 is neutral.",
        .tint = sonic_ui::SHADOW.tint,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },

    // Bloom, motion blur, lens/sharpening, texture filtering
    new settings_ui::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.fx_bloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = BLOOM_SECTION,
        .tooltip = "Scales bloom intensity. 100% uses the game's strength.",
        .tint = sonic_ui::SHADOW.tint,
        .max = 200.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxBloomThreshold",
        .binding = &shader_injection.fx_bloom_threshold,
        .default_value = 0.f,
        .label = "Bloom Threshold",
        .section = BLOOM_SECTION,
        .tooltip = "Filters dim bloom sources before blur, relative to adapted scene luminance.",
        .tint = sonic_ui::SHADOW.tint,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.fx_bloom != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "FxBloomHaze",
        .binding = &shader_injection.fx_bloom_haze,
        .default_value = 100.f,
        .label = "Bloom Haze",
        .section = BLOOM_SECTION,
        .tooltip = "Fades the widest bloom levels that veil the whole screen and raise blacks. Lower = less haze; local glow stays.",
        .tint = sonic_ui::SHADOW.tint,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.fx_bloom != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxMotionBlur",
        .binding = &shader_injection.fx_motion_blur,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Motion Blur",
        .section = MOTION_BLUR_SECTION,
        .tooltip = "Off removes motion blur, Vanilla keeps the game's, Improved uses RenoDX's.",
        .labels = {"Off", "Vanilla", "Improved"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = sonic_ui::SHADOW.tint,
    },
    new settings_ui::Setting{
        .key = "FxMotionBlurStrength",
        .binding = &shader_injection.fx_motion_blur_strength,
        .default_value = 100.f,
        .label = "Strength",
        .section = MOTION_BLUR_SECTION,
        .tooltip = "Scales blur length. Requires motion blur to be on.",
        .tint = sonic_ui::SHADOW.tint,
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
        .section = MOTION_BLUR_SECTION,
        .tooltip = "Blur quality. More samples are smoother but cost performance. Improved mode only.",
        .tint = sonic_ui::SHADOW.tint,
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
        .section = MOTION_BLUR_SECTION,
        .tooltip = "Samples the full-resolution scene instead of the game's reduced source. Improved mode only.",
        .labels = {"Off", "On"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = sonic_ui::SHADOW.tint,
        .is_enabled = []() { return shader_injection.fx_motion_blur == 2.f; },
    },
    new settings_ui::Setting{
        .key = "FxChromaticAberration",
        .binding = &shader_injection.chromatic_aberration,
        .default_value = 100.f,
        .label = "Chromatic Aberration",
        .section = LENS_SHARPENING_SECTION,
        .tooltip = "Scales the game's contextual RGB separation. 100% uses the game's strength.",
        .tint = sonic_ui::SHADOW.tint,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxSharpening",
        .binding = &shader_injection.fx_sharpening,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Sharpening",
        .section = LENS_SHARPENING_SECTION,
        .tooltip = "Vanilla keeps the game's sharpen. RCAS replaces it with Lilium's HDR RCAS.",
        .labels = {"Vanilla", "RCAS"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = sonic_ui::SHADOW.tint,
    },
    new settings_ui::Setting{
        .key = "FxRCAS",
        .binding = &shader_injection.custom_rcas,
        .default_value = 50.f,
        .label = "RCAS Strength",
        .section = LENS_SHARPENING_SECTION,
        .tooltip = "Controls Lilium's HDR RCAS before HUD compositing.",
        .tint = sonic_ui::SHADOW.tint,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.fx_sharpening != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "ForceAnisotropicFiltering",
        .binding = &force_anisotropic_filtering,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Anisotropic Filtering",
        .section = TEXTURE_FILTERING_SECTION,
        .tooltip = "Forces 16x anisotropic filtering on material textures. Requires game restart.",
        .labels = {"Game Default", "16x"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = sonic_ui::SHADOW.tint,
    },

    // About
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "Unofficial community HDR mod built with RenoDX. Not affiliated with SEGA or Sonic Team.",
        .section = ABOUT_SECTION,
        .tint = sonic_ui::SHADOW.tint,
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "RenoDX by Carlos Lopez (clshortfuse) and contributors.",
        .section = ABOUT_SECTION,
        .tint = sonic_ui::SHADOW.tint,
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = ABOUT_SECTION,
        .tint = sonic_ui::SHADOW.tint,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/", "t9v7wx9NTD"); },
    },
};

// Sonic Generations shows the tone map and color grade subset of `settings`, filled in DllMain.
settings_ui::Settings sonic_generations_settings = {};

// Restores the vanilla look. Keys missing from the active game's list are skipped by UpdateSetting.
void OnPresetOff() {
  settings_ui::UpdateSetting("ToneMapType", 0.f);
  settings_ui::UpdateSetting("ToneMapPeakNits", 203.f);
  settings_ui::UpdateSetting("ToneMapGameNits", 203.f);
  settings_ui::UpdateSetting("ColorGradeExposure", 1.f);
  settings_ui::UpdateSetting("ColorGradeHighlights", 50.f);
  settings_ui::UpdateSetting("ColorGradeShadows", 50.f);
  settings_ui::UpdateSetting("ColorGradeContrast", 50.f);
  settings_ui::UpdateSetting("ColorGradeSaturation", 50.f);
  if (is_sonic_generations) {
    settings_ui::UpdateSetting("SGHighlightRollOff", 0.f);
    settings_ui::UpdateSetting("SGBloom", 1.f);
    settings_ui::UpdateSetting("SGBloomStrength", 100.f);
    settings_ui::UpdateSetting("SGBloomThreshold", 100.f);
    settings_ui::UpdateSetting("SGBloomHDR", 0.f);
    settings_ui::UpdateSetting("SGMotionBlur", 1.f);
    settings_ui::UpdateSetting("SGAutoExposure", 1.f);
    settings_ui::UpdateSetting("SGAEBrighten", 100.f);
    settings_ui::UpdateSetting("SGAEDarken", 100.f);
    settings_ui::UpdateSetting("SGAELimitBrighten", 8.f);
    settings_ui::UpdateSetting("SGAELimitDarken", 8.f);
    settings_ui::UpdateSetting("SGAESpeedBrighter", 100.f);
    settings_ui::UpdateSetting("SGAESpeedDarker", 100.f);
    settings_ui::UpdateSetting("SGAECenterWeight", 0.f);
    settings_ui::UpdateSetting("SGDepthOfField", 100.f);
  } else {
    settings_ui::UpdateSetting("ToneMapUINits", 203.f);
    settings_ui::UpdateSetting("FxBloom", 100.f);
    settings_ui::UpdateSetting("FxBloomThreshold", 0.f);
    settings_ui::UpdateSetting("FxBloomHaze", 100.f);
    settings_ui::UpdateSetting("FxMotionBlur", 1.f);
    settings_ui::UpdateSetting("FxMotionBlurStrength", 100.f);
    settings_ui::UpdateSetting("FxChromaticAberration", 100.f);
    settings_ui::UpdateSetting("FxSharpening", 0.f);
    settings_ui::UpdateSetting("ForceAnisotropicFiltering", 0.f);
  }
}

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

// The swapchain is only known once it presents, so the output mode is applied on the first present.
void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
  auto* device = queue->get_device();
  auto* data = renodx::utils::data::Get<renodx::mods::swapchain::DeviceData>(device);
  if (data == nullptr) return;
  if (tracked_swapchain != swapchain) {
    tracked_swapchain = swapchain;
    HandleOutputModeChange();
  } else if (next_color_space.has_value()) {
    renodx::utils::swapchain::ChangeColorSpace(tracked_swapchain, next_color_space.value());
    next_color_space = std::nullopt;
  }
}

// Swapchain and Display Output setup shared by both games.
void SetupSwapChain() {
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
  };

  renodx::mods::swapchain::force_borderless = false;
  renodx::mods::swapchain::prevent_full_screen = false;
  renodx::mods::swapchain::set_color_space = true;
  renodx::mods::swapchain::SetUseHDR10(true);
  renodx::mods::swapchain::use_resize_buffer = false;
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

      reshade::register_event<reshade::addon_event::present>(OnPresent);
      renodx::utils::settings::on_preset_changed_callbacks.emplace_back(&HandleOutputModeChange);

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 9;
      renodx::mods::shader::allow_multiple_push_constants = true;

      if (is_sonic_generations) {
        renodx::utils::settings::global_name = "renodx-sonicgenerations";
        palette = &sonic_ui::SONIC;
        shader_injection.sg_ui_graphics_white = 1.f;

        // Only one game runs per process, so the copied Shadow settings can take Sonic tints in place.
        auto copy_shadow_section = [](std::string_view section) {
          for (auto* setting : settings) {
            if (setting->section != section) continue;
            // Vanilla Hue Influence depends on Shadow's Uchimura reference curve, so it is excluded.
            // Sonic's UI brightness comes from graphics white in the intermediate/swap chain passes, so ToneMapUINits stays.
            if (setting->key == "ToneMapVanillaHueInfluence") continue;
            setting->tint = sonic_ui::SONIC.tint;
            if (setting->key == "ToneMapHighlightChromaRollOff") {
              setting->default_value = 0.f;
              setting->value = 0.f;
            }
            sonic_generations_settings.push_back(setting);
          }
        };

        copy_shadow_section(STATUS_SECTION);
        copy_shadow_section(TONE_MAPPING_SECTION);
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGHighlightRollOff",
            .binding = &shader_injection.sg_highlight_rolloff,
            .default_value = 0.f,
            .label = "Highlight Roll-off",
            .section = TONE_MAPPING_SECTION,
            .tooltip = "Compresses brightness just above paper white. 0 keeps the game's linear highlights; 100 rolls them off the most.",
            .tint = sonic_ui::SONIC.tint,
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
        });

        copy_shadow_section(COLOR_GRADING_SECTION);

        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGAutoExposure",
            .binding = &shader_injection.sg_auto_exposure,
            .value_type = settings_ui::SettingValueType::INTEGER,
            .default_value = 1.f,
            .label = "Auto Exposure",
            .section = AUTO_EXPOSURE_SECTION,
            .tooltip = "Off locks exposure to a fixed middle-grey reference. Vanilla keeps the game's eye adaptation. Custom enables the options below.",
            .labels = {"Off", "Vanilla", "Custom"},
            .style = settings_ui::SettingStyle::SEGMENTED,
            .tint = sonic_ui::SONIC.tint,
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGAEBrighten",
            .binding = &shader_injection.sg_ae_brighten,
            .default_value = 100.f,
            .label = "Brightening",
            .section = AUTO_EXPOSURE_SECTION,
            .tooltip = "How much auto exposure may brighten dark scenes. 100 = vanilla, 0 = none.",
            .tint = sonic_ui::SONIC.tint,
            .max = 200.f,
            .is_enabled = []() { return shader_injection.sg_auto_exposure == 2.f; },
            .parse = [](float value) { return value * 0.01f; },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGAEDarken",
            .binding = &shader_injection.sg_ae_darken,
            .default_value = 100.f,
            .label = "Darkening",
            .section = AUTO_EXPOSURE_SECTION,
            .tooltip = "How much auto exposure may darken bright scenes. 100 = vanilla, 0 = none.",
            .tint = sonic_ui::SONIC.tint,
            .max = 200.f,
            .is_enabled = []() { return shader_injection.sg_auto_exposure == 2.f; },
            .parse = [](float value) { return value * 0.01f; },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGAELimitBrighten",
            .binding = &shader_injection.sg_ae_limit_brighten,
            .default_value = 8.f,
            .label = "Brighten Limit",
            .section = AUTO_EXPOSURE_SECTION,
            .tooltip = "Most auto exposure may brighten, in stops above the reference.",
            .tint = sonic_ui::SONIC.tint,
            .min = 0.f,
            .max = 8.f,
            .format = "%.1f EV",
            .is_enabled = []() { return shader_injection.sg_auto_exposure == 2.f; },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGAELimitDarken",
            .binding = &shader_injection.sg_ae_limit_darken,
            .default_value = 8.f,
            .label = "Darken Limit",
            .section = AUTO_EXPOSURE_SECTION,
            .tooltip = "Most auto exposure may darken, in stops below the reference.",
            .tint = sonic_ui::SONIC.tint,
            .min = 0.f,
            .max = 8.f,
            .format = "%.1f EV",
            .is_enabled = []() { return shader_injection.sg_auto_exposure == 2.f; },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGAESpeedBrighter",
            .binding = &shader_injection.sg_ae_speed_brighter,
            .default_value = 100.f,
            .label = "Adapt Speed (to bright)",
            .section = AUTO_EXPOSURE_SECTION,
            .tooltip = "Adaptation speed when the scene gets brighter. 100 = vanilla, 0 freezes.",
            .tint = sonic_ui::SONIC.tint,
            .max = 400.f,
            .is_enabled = []() { return shader_injection.sg_auto_exposure == 2.f; },
            .parse = [](float value) { return value * 0.01f; },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGAESpeedDarker",
            .binding = &shader_injection.sg_ae_speed_darker,
            .default_value = 100.f,
            .label = "Adapt Speed (to dark)",
            .section = AUTO_EXPOSURE_SECTION,
            .tooltip = "Adaptation speed when the scene gets darker. 100 = vanilla, 0 freezes.",
            .tint = sonic_ui::SONIC.tint,
            .max = 400.f,
            .is_enabled = []() { return shader_injection.sg_auto_exposure == 2.f; },
            .parse = [](float value) { return value * 0.01f; },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGAECenterWeight",
            .binding = &shader_injection.sg_ae_center_weight,
            .default_value = 0.f,
            .label = "Center Weighting",
            .section = AUTO_EXPOSURE_SECTION,
            .tooltip = "How much the screen center counts more than the edges when metering. 0 = vanilla (flat).",
            .tint = sonic_ui::SONIC.tint,
            .max = 100.f,
            .is_enabled = []() { return shader_injection.sg_auto_exposure == 2.f; },
            .parse = [](float value) { return value * 0.01f; },
        });

        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGBloom",
            .binding = &shader_injection.sg_bloom_enabled,
            .value_type = settings_ui::SettingValueType::INTEGER,
            .default_value = 1.f,
            .label = "Bloom",
            .section = BLOOM_SECTION,
            .tooltip = "Turns the game's bloom on or off.",
            .labels = {"Off", "On"},
            .style = settings_ui::SettingStyle::SEGMENTED,
            .tint = sonic_ui::SONIC.tint,
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGDepthOfField",
            .binding = &shader_injection.sg_dof_strength,
            .default_value = 100.f,
            .label = "Strength",
            .section = DEPTH_OF_FIELD_SECTION,
            .tooltip = "Scales the game's depth of field blur. 0 = off, 100 = vanilla.",
            .tint = sonic_ui::SONIC.tint,
            .max = 200.f,
            .parse = [](float value) { return value * 0.01f; },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGBloomStrength",
            .binding = &shader_injection.sg_bloom_strength,
            .default_value = 100.f,
            .label = "Bloom Strength",
            .section = BLOOM_SECTION,
            .tooltip = "Scales the game's glow strength.",
            .tint = sonic_ui::SONIC.tint,
            .max = 200.f,
            .is_enabled = []() { return shader_injection.sg_bloom_enabled != 0.f; },
            .parse = [](float value) { return value * 0.01f; },
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGBloomThreshold",
            .binding = &shader_injection.sg_bloom_threshold,
            .default_value = 100.f,
            .label = "Bloom Threshold",
            .section = BLOOM_SECTION,
            .tooltip = "Scales the game's bright-pass threshold. Lower = more of the scene blooms.",
            .tint = sonic_ui::SONIC.tint,
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
            .section = BLOOM_SECTION,
            .tooltip = "0% keeps vanilla's bloom limit; higher lets very bright sources glow more.",
            .tint = sonic_ui::SONIC.tint,
            .max = 100.f,
            .is_enabled = []() { return shader_injection.sg_bloom_enabled != 0.f; },
            .parse = [](float value) { return value * 0.01f; },
        });

        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGMotionBlur",
            .binding = &shader_injection.sg_motion_blur,
            .value_type = settings_ui::SettingValueType::INTEGER,
            .default_value = 1.f,
            .label = "Motion Blur",
            .section = MOTION_BLUR_SECTION,
            .tooltip = "Off removes motion blur, Vanilla keeps the game's, Improved blurs the full-resolution scene with RenoDX's.",
            .labels = {"Off", "Vanilla", "Improved"},
            .style = settings_ui::SettingStyle::SEGMENTED,
            .tint = sonic_ui::SONIC.tint,
        });
        sonic_generations_settings.push_back(new settings_ui::Setting{
            .key = "SGMotionBlurStrength",
            .binding = &shader_injection.sg_motion_blur_strength,
            .default_value = 100.f,
            .label = "Strength",
            .section = MOTION_BLUR_SECTION,
            .tooltip = "Scales the blur length. Improved mode only.",
            .tint = sonic_ui::SONIC.tint,
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
            .section = MOTION_BLUR_SECTION,
            .tooltip = "Blur quality. More samples are smoother but cost performance. Improved mode only.",
            .tint = sonic_ui::SONIC.tint,
            .min = 8.f,
            .max = 32.f,
            .format = "%d",
            .is_enabled = []() { return shader_injection.sg_motion_blur == 2.f; },
        });

        copy_shadow_section(ABOUT_SECTION);

        SetupSwapChain();
        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = false,
            .use_resource_view_cloning = true,
            .aspect_ratio = static_cast<float>(renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER),
        });
        break;
      }

      SetupSwapChain();

      for (const auto old_format : {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r10g10b10a2_unorm}) {
        renodx::mods::swapchain::resource_upgrade_infos.push_back({
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

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      if (is_sonic_generations) {
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
      reshade::unregister_addon(h_module);
      break;
  }

  if (is_sonic_generations) {
    renodx::utils::settings::Use(fdw_reason, &sonic_generations_settings, &OnPresetOff);
    renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
    renodx::mods::shader::Use(fdw_reason, sonic_generations_shaders, &shader_injection);
    return TRUE;
  }
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
