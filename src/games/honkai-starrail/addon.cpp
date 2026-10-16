/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <shared_mutex>
#include <unordered_map>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/data.hpp"
#include "../../utils/date.hpp"
#include "../../utils/render.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

float current_settings_mode = 0;

// ReShade effects before UI.
// The uberposts write the scene into an 8-bit (upgraded to float) buffer, UI
// is alpha-blended onto that buffer and a plain blit copies it to the
// swapchain. Effects render right after the uberpost. Frames without an
// uberpost (UI-only screens) skip effects at the final blit instead of
// covering the UI.
constexpr uint32_t FINAL_BLIT_SHADER = 0x20133A8B;

bool effects_handled_this_frame = false;

reshade::api::resource_view GetCloneView(const reshade::api::resource_view& view) {
  if (view.handle == 0u) return view;
  reshade::api::resource_view clone = {0u};
  renodx::utils::resource::GetResourceViewInfo(view, [&clone](const renodx::utils::resource::ResourceViewInfo& info) {
    if (!info.destroyed) clone = info.clone;
  });
  return clone.handle != 0u ? clone : view;
}

reshade::api::resource_view GetCurrentRenderTarget(reshade::api::command_list* cmd_list) {
  auto* cmd_list_data = renodx::utils::data::Get<renodx::utils::swapchain::CommandListData>(cmd_list);
  if (cmd_list_data == nullptr || cmd_list_data->current_render_targets.empty()) return {0u};
  return cmd_list_data->current_render_targets[0];
}

// Effects render on the real back buffer in the output encoding (HDR10 or
// scRGB), so ReShade uses its default effect permutation: HDR-aware effects
// compile and see display-encoded data. The scene is encoded into the back
// buffer in reshade_begin_effects and decoded back into the float scene buffer
// in reshade_finish_effects; ReShade restores the application state afterwards.
// The back buffer is overwritten by the swapchain proxy at present.
struct BackBufferEffects {
  bool active = false;
  reshade::api::resource_view back_buffer_rtv = {0u};
  reshade::api::resource_view scene_rtv = {0u};
  reshade::api::resource scene_resource = {0u};
  reshade::api::resource_view scene_srv = {0u};
  reshade::api::resource back_buffer_copy = {0u};
  reshade::api::resource_desc back_buffer_copy_desc = {};
  reshade::api::resource_view back_buffer_copy_srv = {0u};
  std::unordered_map<uint64_t, reshade::api::resource_view> back_buffer_views;
  renodx::utils::render::RenderPass encode_pass;
  renodx::utils::render::RenderPass decode_pass;
} back_buffer_effects;

// Render target views of the swapchain buffers. Released before the swapchain
// is resized or destroyed.
reshade::api::resource_view GetBackBufferView(reshade::api::device* device, reshade::api::effect_runtime* runtime) {
  const auto back_buffer = runtime->get_current_back_buffer();
  if (back_buffer.handle == 0u) return {0u};
  auto& views = back_buffer_effects.back_buffer_views;
  if (auto it = views.find(back_buffer.handle); it != views.end()) return it->second;
  const auto desc = device->get_resource_desc(back_buffer);
  reshade::api::resource_view view = {0u};
  if (!device->create_resource_view(
          back_buffer,
          reshade::api::resource_usage::render_target,
          reshade::api::resource_view_desc(reshade::api::format_to_default_typed(desc.texture.format, 0)),
          &view)) {
    return {0u};
  }
  views[back_buffer.handle] = view;
  return view;
}

void DestroyBackBufferViews(reshade::api::device* device) {
  for (const auto& [handle, view] : back_buffer_effects.back_buffer_views) {
    device->destroy_resource_view(view);
  }
  back_buffer_effects.back_buffer_views.clear();
}

// A null scene only updates uniforms, but still stops ReShade from rendering
// effects at present on top of the UI.
void RenderEffects(reshade::api::command_list* cmd_list, reshade::api::resource_view scene) {
  effects_handled_this_frame = true;
  auto* device = cmd_list->get_device();
  auto* device_data = renodx::utils::data::Get<renodx::utils::swapchain::DeviceData>(device);
  if (device_data == nullptr) return;

  const std::shared_lock lock(device_data->mutex);
  for (auto* runtime : device_data->effect_runtimes) {
    const auto back_buffer = scene.handle != 0u ? GetBackBufferView(device, runtime) : reshade::api::resource_view{0u};
    back_buffer_effects.back_buffer_rtv = back_buffer;
    back_buffer_effects.scene_rtv = scene;
    back_buffer_effects.active = back_buffer.handle != 0u && scene.handle != 0u;
    runtime->render_effects(cmd_list, back_buffer, back_buffer);
    back_buffer_effects.active = false;
  }
}

bool RenderFullscreenPass(
    reshade::api::command_list* cmd_list,
    renodx::utils::render::RenderPass& pass,
    reshade::api::resource_view target,
    reshade::api::resource_view source) {
  auto* device = cmd_list->get_device();
  const auto desc = device->get_resource_desc(device->get_resource_from_view(target));
  const auto format = reshade::api::format_to_default_typed(desc.texture.format, 0);
  if (pass.pipeline_subobjects.render_target_formats.empty()
      || pass.pipeline_subobjects.render_target_formats[0] != format) {
    pass.DestroyAll(device);
    pass.samplers.clear();
    pass.pipeline_subobjects.render_target_formats = {format};
  }

  pass.render_target_slots.views[0] = target;
  pass.shader_resource_slots.views[0] = source;
  pass.viewports = {{
      .width = static_cast<float>(desc.texture.width),
      .height = static_cast<float>(desc.texture.height),
      .max_depth = 1.f,
  }};
  pass.scissors = {{
      .right = static_cast<int32_t>(desc.texture.width),
      .bottom = static_cast<int32_t>(desc.texture.height),
  }};
  return pass.Render(cmd_list);
}

reshade::api::resource_view GetSceneShaderResource(reshade::api::device* device) {
  const auto resource = device->get_resource_from_view(back_buffer_effects.scene_rtv);
  if (resource != back_buffer_effects.scene_resource) {
    if (back_buffer_effects.scene_srv.handle != 0u) {
      device->destroy_resource_view(back_buffer_effects.scene_srv);
      back_buffer_effects.scene_srv = {0u};
    }
    back_buffer_effects.scene_resource = resource;
    const auto desc = device->get_resource_desc(resource);
    device->create_resource_view(
        resource,
        reshade::api::resource_usage::shader_resource,
        reshade::api::resource_view_desc(reshade::api::format_to_default_typed(desc.texture.format, 0)),
        &back_buffer_effects.scene_srv);
  }
  return back_buffer_effects.scene_srv;
}

reshade::api::resource_view CopyBackBuffer(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list->get_device();
  const auto back_buffer = device->get_resource_from_view(back_buffer_effects.back_buffer_rtv);
  const auto desc = device->get_resource_desc(back_buffer);
  auto& copy_desc = back_buffer_effects.back_buffer_copy_desc;
  if (back_buffer_effects.back_buffer_copy.handle == 0u
      || copy_desc.texture.width != desc.texture.width
      || copy_desc.texture.height != desc.texture.height
      || reshade::api::format_to_typeless(copy_desc.texture.format) != reshade::api::format_to_typeless(desc.texture.format)) {
    if (back_buffer_effects.back_buffer_copy_srv.handle != 0u) {
      device->destroy_resource_view(back_buffer_effects.back_buffer_copy_srv);
      back_buffer_effects.back_buffer_copy_srv = {0u};
    }
    if (back_buffer_effects.back_buffer_copy.handle != 0u) {
      device->destroy_resource(back_buffer_effects.back_buffer_copy);
      back_buffer_effects.back_buffer_copy = {0u};
    }
    copy_desc = reshade::api::resource_desc(
        desc.texture.width, desc.texture.height, 1, 1,
        reshade::api::format_to_typeless(desc.texture.format), 1,
        reshade::api::memory_heap::gpu_only,
        reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource);
    if (!device->create_resource(copy_desc, nullptr, reshade::api::resource_usage::shader_resource, &back_buffer_effects.back_buffer_copy)) {
      return {0u};
    }
    device->create_resource_view(
        back_buffer_effects.back_buffer_copy,
        reshade::api::resource_usage::shader_resource,
        reshade::api::resource_view_desc(reshade::api::format_to_default_typed(desc.texture.format, 0)),
        &back_buffer_effects.back_buffer_copy_srv);
  }
  cmd_list->copy_resource(back_buffer, back_buffer_effects.back_buffer_copy);
  return back_buffer_effects.back_buffer_copy_srv;
}

void OnBeginEffects(
    reshade::api::effect_runtime*,
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view,
    reshade::api::resource_view) {
  if (!back_buffer_effects.active) return;
  const auto scene_srv = GetSceneShaderResource(cmd_list->get_device());
  if (scene_srv.handle == 0u
      || !RenderFullscreenPass(cmd_list, back_buffer_effects.encode_pass, back_buffer_effects.back_buffer_rtv, scene_srv)) {
    // Leave the scene buffer untouched if it could not be encoded
    back_buffer_effects.active = false;
    reshade::log::message(reshade::log::level::warning, "honkai-starrail::OnBeginEffects(scene encode failed)");
  }
}

void OnFinishEffects(
    reshade::api::effect_runtime*,
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view,
    reshade::api::resource_view) {
  if (!back_buffer_effects.active) return;
  const auto copy_srv = CopyBackBuffer(cmd_list);
  if (copy_srv.handle == 0u
      || !RenderFullscreenPass(cmd_list, back_buffer_effects.decode_pass, back_buffer_effects.scene_rtv, copy_srv)) {
    reshade::log::message(reshade::log::level::warning, "honkai-starrail::OnFinishEffects(scene decode failed)");
  }
}

void OnUberpostDrawn(reshade::api::command_list* cmd_list) {
  if (shader_injection.custom_effects_before_ui == 0.f || effects_handled_this_frame) return;
  const auto rtv = GetCurrentRenderTarget(cmd_list);
  if (rtv.handle == 0u) return;
  RenderEffects(cmd_list, GetCloneView(rtv));
}

bool OnFinalBlitDraw(reshade::api::command_list* cmd_list) {
  if (shader_injection.custom_effects_before_ui != 0.f && !effects_handled_this_frame) {
    RenderEffects(cmd_list, {0u});
  }
  return true;
}

void OnPresent(
    reshade::api::command_queue*,
    reshade::api::swapchain*,
    const reshade::api::rect*,
    const reshade::api::rect*,
    uint32_t,
    const reshade::api::rect*) {
  effects_handled_this_frame = false;
}

void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool) {
  DestroyBackBufferViews(swapchain->get_device());
}

void OnDestroyDevice(reshade::api::device* device) {
  DestroyBackBufferViews(device);
  back_buffer_effects.encode_pass.DestroyAll(device);
  back_buffer_effects.decode_pass.DestroyAll(device);
  if (back_buffer_effects.scene_srv.handle != 0u) device->destroy_resource_view(back_buffer_effects.scene_srv);
  if (back_buffer_effects.back_buffer_copy_srv.handle != 0u) device->destroy_resource_view(back_buffer_effects.back_buffer_copy_srv);
  if (back_buffer_effects.back_buffer_copy.handle != 0u) device->destroy_resource(back_buffer_effects.back_buffer_copy);
  back_buffer_effects.scene_srv = {0u};
  back_buffer_effects.scene_resource = {0u};
  back_buffer_effects.back_buffer_copy_srv = {0u};
  back_buffer_effects.back_buffer_copy = {0u};
}

#define UberpostEntry(value)                                                   \
  {                                                                            \
    value, { .crc32 = value, .code = __##value, .on_drawn = &OnUberpostDrawn } \
  }

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x12F5D245),  // LUT builder (tone map)
    UberpostEntry(0x93121324),      // Uberpost: title screen, open world
    UberpostEntry(0x318A9DF6),      // Uberpost: loading screens, title fade out
    UberpostEntry(0xB2079998),      // Uberpost: main menu
    UberpostEntry(0x1AC9F8BC),      // Uberpost: character ultimates
    {
        FINAL_BLIT_SHADER,  // Final blit to the swapchain (not replaced)
        {.crc32 = FINAL_BLIT_SHADER, .on_draw = &OnFinalBlitDraw},
    },
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type. Vanilla keeps the game's SDR tone map.",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
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
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &shader_injection.tone_map_working_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &shader_injection.tone_map_hue_shift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampColorSpace",
        .binding = &shader_injection.tone_map_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Color Space",
        .section = "Tone Mapping",
        .tooltip = "Clamps colors to the selected color space.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampPeak",
        .binding = &shader_injection.tone_map_clamp_peak,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Peak",
        .section = "Tone Mapping",
        .tooltip = "Clamps peak brightness to the selected color space.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Strength of the game's SDR tone curve look applied on top of the RenoDX tone map",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ReShadeBeforeUI",
        .binding = &shader_injection.custom_effects_before_ui,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "ReShade Before UI",
        .section = "Effects",
        .tooltip = "Renders ReShade effects on the game image before the UI is drawn."
                   "\nDisable effect toggler add-ons (REST) groups that do the same.",
        .labels = {"Off", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainCustomColorSpace",
        .binding = &shader_injection.swap_chain_custom_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Custom Color Space",
        .section = "Display Output",
        .tooltip = "Selects output color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 (NTSC-U)."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
                   "\nDefault: US Modern",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "IntermediateDecoding",
        .binding = &shader_injection.intermediate_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Intermediate Encoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .parse = [](float value) {
          if (value == 0) return shader_injection.gamma_correction + 1.f;
          return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainDecoding",
        .binding = &shader_injection.swap_chain_decoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swapchain Decoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .parse = [](float value) {
          if (value == 0) return shader_injection.intermediate_encoding;
          return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Gamma Correction",
        .section = "Display Output",
        .labels = {"None", "2.2", "2.4"},
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainClampColorSpace",
        .binding = &shader_injection.swap_chain_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Clamp Color Space",
        .section = "Display Output",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "Ce9bQHQrSV");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 1000.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("GammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapHueShift", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeScene", 100.f);
  renodx::utils::settings::UpdateSetting("SwapChainCustomColorSpace", 0.f);
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Honkai: Star Rail";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        // The uberposts write the RenoDX intermediate encoding; the final
        // blit copies it to the swapchain clone and the proxy encodes output.
        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::swapchain_proxy_revert_state = true;
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
              .is_visible = []() { return current_settings_mode >= 2; },
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
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 4.f,
              .label = "Encoding",
              .section = "Display Output",
              .tooltip = "Requires a game restart.",
              .labels = {"None", "SRGB", "2.2", "2.4", "HDR10", "scRGB"},
              .on_change_value = [](float previous, float current) {
                bool is_hdr10 = current == 4;
                shader_injection.swap_chain_encoding_color_space = (is_hdr10 ? 1.f : 0.f); },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool is_hdr10 = setting->GetValue() == 4;
          renodx::mods::swapchain::SetUseHDR10(is_hdr10);
          renodx::mods::swapchain::use_resize_buffer = setting->GetValue() < 4;
          shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
          settings.push_back(setting);
        }

        // The uberpost output (and the UI drawn on it) is an 8-bit buffer at
        // the back buffer size, copied to the swapchain by a plain blit.
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
            .aspect_ratio = static_cast<float>(renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER),
            .usage_include = reshade::api::resource_usage::render_target,
        });

        // ReShade Before UI back buffer round trip: encode the float scene
        // buffer into the real back buffer with the output encoding, then
        // decode it back after effects. ReShade restores the application state.
        for (auto* pass : {&back_buffer_effects.encode_pass, &back_buffer_effects.decode_pass}) {
          pass->pipeline_subobjects.vertex_shader = __swap_chain_proxy_vertex_shader_dx11;
          pass->auto_generate_render_target_formats = false;
          pass->auto_generate_viewport = false;
          pass->auto_generate_scissors = false;
          pass->use_render_pass = false;
          pass->revert_state_after_render = false;
          pass->render_target_slots.views = {reshade::api::resource_view{0u}};
          pass->shader_resource_slots.views = {reshade::api::resource_view{0u}};
        }
        // The proxy pixel shader samples t0 and reads settings from slot 13
        back_buffer_effects.encode_pass.pipeline_subobjects.pixel_shader = __swap_chain_proxy_pixel_shader_dx11;
        back_buffer_effects.encode_pass.sampler_descs = {reshade::api::sampler_desc{}};
        back_buffer_effects.encode_pass.push_constants[{13u, 0u}] = std::span<const float>(
            reinterpret_cast<const float*>(&shader_injection),
            sizeof(shader_injection) / sizeof(float));
        back_buffer_effects.decode_pass.push_constants = back_buffer_effects.encode_pass.push_constants;
        back_buffer_effects.decode_pass.pipeline_subobjects.pixel_shader = __effects_decode_pixel_shader_dx11;

        initialized = true;
      }

      reshade::register_event<reshade::addon_event::present>(OnPresent);
      reshade::register_event<reshade::addon_event::reshade_begin_effects>(OnBeginEffects);
      reshade::register_event<reshade::addon_event::reshade_finish_effects>(OnFinishEffects);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::reshade_finish_effects>(OnFinishEffects);
      reshade::unregister_event<reshade::addon_event::reshade_begin_effects>(OnBeginEffects);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
