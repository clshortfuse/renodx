/*
 * Copyright (C) 2024 Ersh
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include <array>
#include <unordered_map>
#include <utility>
#include <vector>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/draw.hpp"
#include "../../utils/log.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"
#include "./swapchain_facade.hpp"

ShaderInjectData shader_injection;

static bool track_next_copy = false;

bool saturate_on_replace(reshade::api::command_list* cmd_list) {
  track_next_copy = true;
  return true;
}

bool copy_on_replace(reshade::api::command_list* cmd_list) {
  if (track_next_copy) {
    ++shader_injection.copyTracker;
  }
  return true;
}

namespace {

renodx::utils::settings::Setting* output_mode_setting = nullptr;
renodx::utils::settings::Setting* output_encoding_setting = nullptr;
float active_output_mode = 0.f;

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x27EBC404),
    CustomShaderEntry(0x1F264D17), //new LUT permutation, added with 7.2
    CustomShaderEntryCallback(0xF8F57F0A, &saturate_on_replace),
    CustomShaderEntry(0x85E777EF),
    CustomShaderEntry(0xFE5B6B3E),  // BloomPass1 vs
    // CustomShaderEntry(0xBF06786C), // BloomPass1 ps
    CustomShaderEntry(0x9B242D09),  // BloomPass2 vs
    // CustomShaderEntry(0x5E42F039), // BloomPass2 ps
    CustomShaderEntry(0xCDC56365),                            // Vignette
    CustomShaderEntryCallback(0x6CFFD968, &copy_on_replace),  // Copy
    CustomShaderEntryCallback(0xB0CE42B9, &copy_on_replace),  // Copy
    CustomShaderEntry(0xF6E81A1B)};                           // FullscreenGammaCorrection

renodx::utils::settings::Settings settings = {
    output_mode_setting = new renodx::utils::settings::Setting{
        .key = "outputMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Presentation Output",
        .section = "Tone Mapping",
        .tooltip = "Selects the presentation format used after restarting the game.",
        .labels = {"scRGB (FP16)", "HDR10 (10-bit PQ)"},
        .parse = [](float value) { return value >= 0.5f ? 1.f : 0.f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Restart the game to apply the presentation output change.",
        .section = "Tone Mapping",
        .tint = 0xFF5F5F,
        .is_visible = []() { return output_mode_setting->GetValue() != active_output_mode; },
        .is_sticky = true,
    },
    output_encoding_setting = new renodx::utils::settings::Setting{
        .key = "outputEncoding",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "HDR10 Output Encoding",
        .section = "Tone Mapping",
        .tooltip = "Switches the HDR10 presentation live, without recreating the swapchain.\n"
                   "SDR encodes gamma 2.2 BT.709 and tone maps to SDR white; peak, game and UI brightness apply to HDR10 only.",
        .labels = {"HDR10 (PQ)", "SDR (Gamma 2.2)"},
        .parse = [](float value) { return value >= 0.5f ? 1.f : 0.f; },
        .is_visible = []() { return active_output_mode >= 0.5f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "DICE"},
        .parse = [](float value) { return std::fmin(std::fmax(value, 0.f), 2.f); },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.toneMapType > 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "diceShoulderStart",
        .binding = &shader_injection.diceShoulderStart,
        .default_value = 0.33f,
        .label = "DICE Shoulder Start",
        .section = "Tone Mapping",
        .tooltip = "Determines where the highlights curve (shoulder) starts in the DICE tonemapper.",
        .max = 1.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 10.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.toneMapType > 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 55.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType > 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType > 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 55.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType > 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 55.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType > 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 55.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType > 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "hueCorrectionStrength",
        .binding = &shader_injection.hueCorrectionStrength,
        .default_value = 50.f,
        .label = "Hue Correction",
        .section = "Color Grading",
        .tooltip = "Controls the strength of the hue correction.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType > 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "gamutExpansion",
        .binding = &shader_injection.gamutExpansion,
        .default_value = 20.f,
        .label = "Gamut Expansion",
        .section = "Color Grading",
        .tooltip = "Generates HDR colors (BT.2020) from bright saturated SDR (BT.709) ones.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType > 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "blackFloorOffset",
        .binding = &shader_injection.blackFloorOffset,
        .default_value = -0.02f,
        .label = "Black Floor Offset",
        .section = "Miscellaneous",
        .tooltip = "An offset to apply to the black floor value in the LUT shader. \nThe final value will not go negative so you can set this to the minimum value to ensure the black floor is never raised.\nUnfortunately, the parameter is often used to raise the overall brightness in darker scenes, so you might end up darkening the game too much at times.\nThe game often uses around 0.02 to slightly raise the brightness, so something like -0.02 is a rather safe conservative value to use.",
        .min = -0.1f,
        .max = 0.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "bloomRadiusMult",
        .binding = &shader_injection.bloomRadiusMult,
        .default_value = 1.f,
        .label = "Bloom Radius Multiplier",
        .section = "Miscellaneous",
        .tooltip = "Controls the radius of the game's bloom.",
        .max = 1.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "vignetteStrength",
        .binding = &shader_injection.vignetteStrength,
        .default_value = 100.f,
        .label = "Vignette Strength",
        .section = "Miscellaneous",
        .tooltip = "Controls the vignette strength, if enabled in the game options.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "RenoDX by ShortFuse. FFXIV mod by Ersh with a lot of help from Pumbo.",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/Z7kXxw5VDR");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Ersh's Ko-Fi",
        .section = "About",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/ershin");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Pumbo's Ko-Fi",
        .section = "About",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://buymeacoffee.com/realfiloppi");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "About",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse");
        },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("hueCorrectionStrength", 0.f);
  renodx::utils::settings::UpdateSetting("gamutExpansion", 0.f);
  renodx::utils::settings::UpdateSetting("blackFloorOffset", 0.f);
  renodx::utils::settings::UpdateSetting("vignetteStrength", 100.f);
  renodx::utils::settings::UpdateSetting("bloomRadiusMult", 1.f);
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Final Fantasy XIV Online";

namespace {

struct __declspec(uuid("24BD7DC3-34CC-4493-9018-9A28D9D2CBE3")) DeviceData {
  reshade::api::effect_runtime* main_runtime = nullptr;
  std::atomic_bool rendered_effects = false;
  reshade::api::pipeline final_pipeline = {};
  reshade::api::pipeline_layout final_layout = {};
};

struct __declspec(uuid("B53B33CF-967D-4E93-AD0F-79BFF3E9E984")) PresentationData {
  // Publish a custom callback only after all preparation succeeds, before exposing custom buffers.
  decltype(&renodx::mods::swapchain::OnPresent) present = nullptr;
  bool logged_present = false;
  // Custom route: in-place gamma-to-scRGB pass per logical back buffer, run before ReShade effects/GUI.
  std::unordered_map<uint64_t, renodx::utils::draw::SwapchainProxyPass> composition_passes;
  uint32_t composition_reports = 0;
  // Custom route: borrowed facade (the ReShade swapchain owns it for this data's lifetime),
  // the encoding whose composition settings are live, and a setting value the facade
  // rejected, which is not retried until the setting changes.
  renodx::games::ffxiv::swapchain_facade::ForwardingSwapchain* facade = nullptr;
  renodx::games::ffxiv::swapchain_facade::OutputEncoding frame_encoding =
      renodx::games::ffxiv::swapchain_facade::OutputEncoding::HDR10_PQ;
  float rejected_encoding_setting = -1.f;
  std::vector<reshade::api::resource_view> swapchain_rtvs;
  reshade::api::resource final_texture = {};
  reshade::api::resource_view final_texture_view = {};
  reshade::api::sampler final_texture_sampler = {};
};

constexpr reshade::api::pipeline_layout PIPELINE_LAYOUT{0};

void OnInitDevice(reshade::api::device* device) {
  auto* data = device->create_private_data<DeviceData>();

  // create pipeline
  {
    std::vector<reshade::api::pipeline_subobject> subobjects;

    reshade::api::shader_desc vs_desc = {};
    vs_desc.code = __final_vertex_shader.data();
    vs_desc.code_size = __final_vertex_shader.size();
    subobjects.push_back({reshade::api::pipeline_subobject_type::vertex_shader, 1, &vs_desc});

    reshade::api::shader_desc ps_desc = {};
    ps_desc.code = __final_pixel_shader.data();
    ps_desc.code_size = __final_pixel_shader.size();
    subobjects.push_back({reshade::api::pipeline_subobject_type::pixel_shader, 1, &ps_desc});

    reshade::api::format format = reshade::api::format::r16g16b16a16_float;
    subobjects.push_back({reshade::api::pipeline_subobject_type::render_target_formats, 1, &format});

    uint32_t num_vertices = 3;
    subobjects.push_back({reshade::api::pipeline_subobject_type::max_vertex_count, 1, &num_vertices});

    auto topology = reshade::api::primitive_topology::triangle_list;
    subobjects.push_back({reshade::api::pipeline_subobject_type::primitive_topology, 1, &topology});

    reshade::api::blend_desc blend_state = {};
    subobjects.push_back({reshade::api::pipeline_subobject_type::blend_state, 1, &blend_state});

    reshade::api::rasterizer_desc rasterizer_state = {};
    rasterizer_state.cull_mode = reshade::api::cull_mode::none;
    subobjects.push_back({reshade::api::pipeline_subobject_type::rasterizer_state, 1, &rasterizer_state});

    reshade::api::depth_stencil_desc depth_stencil_state = {};
    depth_stencil_state.depth_enable = false;
    depth_stencil_state.depth_write_mask = false;
    depth_stencil_state.depth_func = reshade::api::compare_op::always;
    depth_stencil_state.stencil_enable = false;
    depth_stencil_state.front_stencil_read_mask = 0xFF;
    depth_stencil_state.front_stencil_write_mask = 0xFF;
    depth_stencil_state.front_stencil_func = depth_stencil_state.back_stencil_func;
    depth_stencil_state.front_stencil_fail_op = depth_stencil_state.back_stencil_fail_op;
    depth_stencil_state.front_stencil_depth_fail_op = depth_stencil_state.back_stencil_depth_fail_op;
    depth_stencil_state.front_stencil_pass_op = depth_stencil_state.back_stencil_pass_op;
    depth_stencil_state.back_stencil_read_mask = 0xFF;
    depth_stencil_state.back_stencil_write_mask = 0xFF;
    depth_stencil_state.back_stencil_func = reshade::api::compare_op::always;
    depth_stencil_state.back_stencil_fail_op = reshade::api::stencil_op::keep;
    depth_stencil_state.back_stencil_depth_fail_op = reshade::api::stencil_op::keep;
    depth_stencil_state.back_stencil_pass_op = reshade::api::stencil_op::keep;

    subobjects.push_back({reshade::api::pipeline_subobject_type::depth_stencil_state, 1, &depth_stencil_state});

    device->create_pipeline(PIPELINE_LAYOUT, static_cast<uint32_t>(subobjects.size()), subobjects.data(), &data->final_pipeline);
  }

  // create layout
  {
    reshade::api::pipeline_layout_param new_params;
    new_params.type = reshade::api::pipeline_layout_param_type::push_constants;
    new_params.push_constants.count = 1;
    new_params.push_constants.dx_register_index = 13;
    new_params.push_constants.visibility = reshade::api::shader_stage::vertex | reshade::api::shader_stage::pixel | reshade::api::shader_stage::compute;
    device->create_pipeline_layout(1, &new_params, &data->final_layout);
  }
}

void OnDestroyDevice(reshade::api::device* device) {
  auto* data = device->get_private_data<DeviceData>();

  device->destroy_pipeline(data->final_pipeline);
  device->destroy_pipeline_layout(data->final_layout);

  device->destroy_private_data<DeviceData>();
}

// FP16 view upgrade/snapshot target for logical back buffers, independent of upstream
// device data. Resource infos keep this pointer; the facade hook pins the module.
renodx::utils::resource::ResourceUpgradeInfo composition_view_info = {
    .new_format = reshade::api::format::r16g16b16a16_float,
    .usage_set = static_cast<uint32_t>(reshade::api::resource_usage::shader_resource | reshade::api::resource_usage::render_target),
    .use_resource_view_cloning_and_upgrade = true,
};

// A facade whose composition is not ready presents nothing from the addon: upstream
// encoding would be PQ-encoded again by the facade.
void OnPresentDisabled(reshade::api::command_queue*, reshade::api::swapchain*, const reshade::api::rect*,
                       const reshade::api::rect*, uint32_t, const reshade::api::rect*) {}

// SDR reuses the upstream tone mapper with peak, game and UI white at 80 nits, so
// highlights roll off to SDR white at scRGB 1.0. HDR10 restores the user's values.
// Re-applied every frame because the settings UI writes these bindings directly.
void ApplyCompositionSettings(renodx::games::ffxiv::swapchain_facade::OutputEncoding encoding) {
  const std::array<std::pair<const char*, float*>, 3> brightness = {{
      {"toneMapPeakNits", &shader_injection.toneMapPeakNits},
      {"toneMapGameNits", &shader_injection.toneMapGameNits},
      {"toneMapUINits", &shader_injection.toneMapUINits},
  }};
  for (const auto& [key, binding] : brightness) {
    if (encoding == renodx::games::ffxiv::swapchain_facade::OutputEncoding::SDR_GAMMA22) {
      *binding = 80.f;
    } else {
      renodx::utils::settings::FindSetting(key)->Write();
    }
  }
}

// Converts the game's gamma-domain FP16 frame (with Dalamud composited) to linear
// scRGB in place, so ReShade effects/GUI see scRGB. The facade encodes it at Present
// with the encoding this frame was composed for.
void OnPresentComposition(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain,
                          const reshade::api::rect*, const reshade::api::rect*, uint32_t, const reshade::api::rect*) {
  auto* data = swapchain->get_private_data<PresentationData>();
  data->facade->SetFrameEncoding(data->frame_encoding);
  const auto buffer = swapchain->get_current_back_buffer();
  const auto pass = data->composition_passes.find(buffer.handle);
  const bool submitted = (pass != data->composition_passes.end() && pass->second.Render(swapchain, queue));
  if (++data->composition_reports <= 4 || (!submitted && data->composition_reports <= 16)) {
    renodx::utils::log::i("[FFXIV Presentation] COMPOSE swapchain=", swapchain,
                          " buffer=", reinterpret_cast<void*>(buffer.handle), " pass=", pass != data->composition_passes.end(),
                          " submitted=", submitted, " gamma_to_scRGB=1 before_effects=1");
  }
}

void OnInitPresentation(reshade::api::swapchain* swapchain, bool resize) {
  auto* data = swapchain->create_private_data<PresentationData>();
  auto* device = swapchain->get_device();
  if (active_output_mode >= 0.5f) {
    // The route follows the facade, never upstream data: upstream presentation on a
    // facade would be PQ-encoded twice, so an unready facade gets no presentation pass.
    const auto facade = renodx::games::ffxiv::swapchain_facade::Find(swapchain);
    if (facade == nullptr) {
      data->present = &renodx::mods::swapchain::OnPresent;
      renodx::utils::log::i("[FFXIV Presentation] INIT swapchain=", swapchain, " route=upstream_hdr10 custom_ready=0 facade=0 resize=", resize);
      return;
    }
    if (!facade->IsCompositionReady()) {
      data->present = &OnPresentDisabled;
      renodx::utils::log::i("[FFXIV Presentation] INIT swapchain=", swapchain, " route=none custom_ready=0",
                            " facade=", facade.Get(), " facade_ready=0 resize=", resize);
      return;
    }

    for (uint32_t index = 0; index < swapchain->get_back_buffer_count(); ++index) {
      const auto buffer = swapchain->get_back_buffer(index);
      std::vector<uint64_t> views;
      renodx::utils::resource::UpdateResourceInfo(buffer, [&](renodx::utils::resource::ResourceInfo* info) {
        // Application bindings stay on the logical buffer (FP16 views, no clone redirect);
        // the clone is only the present-time snapshot read by the composition pass.
        info->clone_target = &composition_view_info;
        info->clone_enabled = false;
        info->clone_can_deactivate = false;
        info->upgrade_target = &composition_view_info;
        views.assign(info->resource_view_handles.begin(), info->resource_view_handles.end());
      });
      renodx::utils::resource::upgrade::UpdateResourceViewsCloneState(views, false, false, &composition_view_info);
      data->composition_passes.try_emplace(buffer.handle, renodx::utils::draw::SwapchainProxyPass{
                                                              .vertex_shader = __final_vertex_shader,
                                                              .pixel_shader = __final_scrgb_pixel_shader,
                                                              .expected_constant_buffer_index = renodx::mods::swapchain::expected_constant_buffer_index,
                                                              .revert_state = renodx::mods::swapchain::swapchain_proxy_revert_state,
                                                              .use_compatibility_mode = true,
                                                              .proxy_format = reshade::api::format::r16g16b16a16_float,
                                                              .shader_injection = reinterpret_cast<const float*>(&shader_injection),
                                                              .shader_injection_size = sizeof(shader_injection) / sizeof(uint32_t),
                                                          });
    }
    // Composition resumes with the encoding the facade kept across resize.
    data->facade = facade.Get();
    data->frame_encoding = facade->AppliedEncoding();
    ApplyCompositionSettings(data->frame_encoding);
    // Publish the custom route last, after every logical buffer is configured.
    data->present = &OnPresentComposition;
    renodx::utils::log::i("[FFXIV Presentation] INIT swapchain=", swapchain, " route=custom custom_ready=1",
                          " facade=", facade.Get(), " passes=", data->composition_passes.size(),
                          " encoding=", renodx::games::ffxiv::swapchain_facade::EncodingName(data->frame_encoding),
                          " resize=", resize);
    return;
  }

  renodx::utils::log::i("[FFXIV Presentation] INIT swapchain=", swapchain, " route=upstream_scrgb custom_ready=0 resize=", resize);

  for (int i = 0; i < swapchain->get_back_buffer_count(); ++i) {
    auto back_buffer_resource = swapchain->get_back_buffer(i);
    auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);
    auto desc = reshade::api::resource_view_desc(reshade::api::resource_view_type::texture_2d, reshade::api::format_to_default_typed(back_buffer_desc.texture.format), 0, 1, 0, 1);
    device->create_resource_view(back_buffer_resource, reshade::api::resource_usage::render_target, desc, &data->swapchain_rtvs.emplace_back());
  }

  // create copy target
  {
    auto back_buffer_resource = swapchain->get_back_buffer(0);
    auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);
    reshade::api::resource_desc desc = {};
    desc.type = reshade::api::resource_type::texture_2d;
    desc.texture = {
        back_buffer_desc.texture.width,
        back_buffer_desc.texture.height,
        1,
        1,
        reshade::api::format_to_typeless(back_buffer_desc.texture.format),
        1,
    };
    desc.heap = reshade::api::memory_heap::gpu_only;
    desc.usage = reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource;
    desc.flags = reshade::api::resource_flags::none;
    device->create_resource(desc, nullptr, reshade::api::resource_usage::shader_resource, &data->final_texture);
    device->create_resource_view(data->final_texture, reshade::api::resource_usage::shader_resource, reshade::api::resource_view_desc(reshade::api::format_to_default_typed(desc.texture.format)), &data->final_texture_view);
    device->create_sampler({}, &data->final_texture_sampler);
  }
}

void OnDestroyPresentation(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain->get_device();
  auto* data = swapchain->get_private_data<PresentationData>();
  if (active_output_mode >= 0.5f) {
    if (data->facade != nullptr) {
      // Do not leak SDR composition values into a successor that takes another route;
      // a custom-route successor reapplies its own encoding at init.
      ApplyCompositionSettings(renodx::games::ffxiv::swapchain_facade::OutputEncoding::HDR10_PQ);
    }
    for (auto& [buffer, pass] : data->composition_passes) {
      pass.Destroy(device);
    }
    if (!data->composition_passes.empty()) {
      renodx::utils::log::i("[FFXIV Presentation] DESTROY swapchain=", swapchain,
                            " passes=", data->composition_passes.size(), " resize=", resize);
    }
    swapchain->destroy_private_data<PresentationData>();
    return;
  }

  for (const auto& rtv : data->swapchain_rtvs) {
    device->destroy_resource_view(rtv);
  }

  data->swapchain_rtvs.clear();

  device->destroy_sampler(data->final_texture_sampler);
  device->destroy_resource_view(data->final_texture_view);
  device->destroy_resource(data->final_texture);
  swapchain->destroy_private_data<PresentationData>();
}

// more or less the same as what reshade does to render its techniques
void OnPresent(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain, const reshade::api::rect* source_rect, const reshade::api::rect* dest_rect, uint32_t dirty_rect_count, const reshade::api::rect* dirty_rects) {
  auto device = queue->get_device();
  auto cmd_list = queue->get_immediate_command_list();

  auto* device_data = device->get_private_data<DeviceData>();
  auto* data = swapchain->get_private_data<PresentationData>();

  auto back_buffer_resource = swapchain->get_current_back_buffer();
  auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);

  // copy backbuffer
  {
    const reshade::api::resource resources[2] = {back_buffer_resource, data->final_texture};
    const reshade::api::resource_usage state_old[2] = {reshade::api::resource_usage::render_target, reshade::api::resource_usage::shader_resource};
    const reshade::api::resource_usage state_new[2] = {reshade::api::resource_usage::copy_source, reshade::api::resource_usage::copy_dest};

    cmd_list->barrier(2, resources, state_old, state_new);
    cmd_list->copy_texture_region(back_buffer_resource, 0, nullptr, data->final_texture, 0, nullptr);
    cmd_list->barrier(2, resources, state_new, state_old);
  }

  cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_graphics, device_data->final_pipeline);

  cmd_list->barrier(back_buffer_resource, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::render_target);

  reshade::api::render_pass_render_target_desc render_target = {};
  render_target.view = data->swapchain_rtvs.at(swapchain->get_current_back_buffer_index());
  cmd_list->begin_render_pass(1, &render_target, nullptr);

  cmd_list->push_descriptors(reshade::api::shader_stage::all_graphics, PIPELINE_LAYOUT, 0, reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::texture_shader_resource_view, &data->final_texture_view});
  cmd_list->push_descriptors(reshade::api::shader_stage::all_graphics, PIPELINE_LAYOUT, 0, reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::sampler, &data->final_texture_sampler});

  // push the renodx settings
  cmd_list->push_constants(reshade::api::shader_stage::all_graphics, device_data->final_layout, 0, 0, sizeof(shader_injection) / 4, &shader_injection);

  const reshade::api::viewport viewport = {
      0.0f, 0.0f,
      static_cast<float>(back_buffer_desc.texture.width),
      static_cast<float>(back_buffer_desc.texture.height),
      0.0f, 1.0f};
  cmd_list->bind_viewports(0, 1, &viewport);

  cmd_list->draw(3, 1, 0, 0);
  cmd_list->end_render_pass();

  cmd_list->barrier(back_buffer_resource, reshade::api::resource_usage::render_target, reshade::api::resource_usage::shader_resource);
}

void OnPresentStateReset(reshade::api::command_queue*, reshade::api::swapchain*, const reshade::api::rect*, const reshade::api::rect*, uint32_t, const reshade::api::rect*) {
  track_next_copy = false;
  shader_injection.copyTracker = 0;
}

void OnPresentRouted(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain,
                     const reshade::api::rect* source_rect, const reshade::api::rect* dest_rect,
                     uint32_t dirty_rect_count, const reshade::api::rect* dirty_rects) {
  auto* data = swapchain->get_private_data<PresentationData>();
  auto present = (active_output_mode >= 0.5f ? &renodx::mods::swapchain::OnPresent : &OnPresent);
  if (data != nullptr && data->present != nullptr) {
    present = data->present;
  } else if (active_output_mode >= 0.5f && renodx::games::ffxiv::swapchain_facade::Find(swapchain) != nullptr) {
    // No published route for a facade: never fall back to upstream encoding.
    present = &OnPresentDisabled;
  }
  if (data != nullptr && !data->logged_present) {
    data->logged_present = true;
    const char* route = "custom";
    if (present == &renodx::mods::swapchain::OnPresent) {
      route = "upstream_hdr10";
    } else if (present == &OnPresent) {
      route = "upstream_scrgb";
    } else if (present == &OnPresentDisabled) {
      route = "none";
    }
    renodx::utils::log::i("[FFXIV Presentation] PRESENT swapchain=", swapchain, " route=", route);
  }
  present(queue, swapchain, source_rect, dest_rect, dirty_rect_count, dirty_rects);
}

// Runs after ReShade's overlay (which may change settings) and before the facade
// Present of this frame. Chooses the encoding the next frame is composed for; the
// facade applies it at that frame's Present, keeping composition and encoding paired.
void OnEncodingPresent(reshade::api::effect_runtime* runtime) {
  namespace facade_api = renodx::games::ffxiv::swapchain_facade;
  auto* data = runtime->get_private_data<PresentationData>();
  if (data == nullptr || data->facade == nullptr) return;

  const float setting_value = output_encoding_setting->GetValue();
  if (data->facade->TakeSwitchFailure()) {
    // Revert composition to the encoding the facade still presents; retry only after the setting changes.
    data->frame_encoding = data->facade->AppliedEncoding();
    data->rejected_encoding_setting = setting_value;
    renodx::utils::log::i("[FFXIV Presentation] ENCODING_REVERT swapchain=", runtime,
                          " to=", facade_api::EncodingName(data->frame_encoding), " reason=switch_failed");
  }
  if (setting_value != data->rejected_encoding_setting) {
    data->rejected_encoding_setting = -1.f;
    const auto requested = (setting_value >= 0.5f ? facade_api::OutputEncoding::SDR_GAMMA22
                                                  : facade_api::OutputEncoding::HDR10_PQ);
    if (requested != data->frame_encoding) {
      if (data->facade->SupportsEncoding(requested)) {
        renodx::utils::log::i("[FFXIV Presentation] ENCODING_REQUEST swapchain=", runtime,
                              " from=", facade_api::EncodingName(data->frame_encoding),
                              " to=", facade_api::EncodingName(requested));
        data->frame_encoding = requested;
      } else {
        data->rejected_encoding_setting = setting_value;
        renodx::utils::log::i("[FFXIV Presentation] ENCODING_REJECTED swapchain=", runtime,
                              " to=", facade_api::EncodingName(requested), " reason=color_space_unsupported");
      }
    }
  }
  ApplyCompositionSettings(data->frame_encoding);
}

}  // namespace

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
      if (!reshade::register_addon(h_module)) {
        return FALSE;
      }

      renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

      active_output_mode = output_mode_setting->GetValue();
      const bool use_hdr10 = active_output_mode >= 0.5f;
      shader_injection.swapChainOutputPreset = use_hdr10 ? 1.f : 2.f;

      renodx::mods::swapchain::SetUseHDR10(use_hdr10);
      if (use_hdr10) {
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __final_vertex_shader;
        renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __final_pixel_shader;
      }
      renodx::mods::swapchain::Use(fdw_reason, use_hdr10 ? &shader_injection : nullptr);
      if (use_hdr10) {
        reshade::unregister_event<reshade::addon_event::present>(renodx::mods::swapchain::OnPresent);
        reshade::register_event<reshade::addon_event::present>(OnPresentRouted);
        reshade::register_event<reshade::addon_event::reshade_present>(OnEncodingPresent);
        renodx::games::ffxiv::swapchain_facade::Use(fdw_reason);
      }
      renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });

      //Only needed if Gamma Correction is active?????? (GammaCorrection != 50)
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });

      if (!use_hdr10) {
        reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
        reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
        reshade::register_event<reshade::addon_event::present>(OnPresentRouted);
      }
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitPresentation);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroyPresentation);
      reshade::register_event<reshade::addon_event::present>(OnPresentStateReset);

      break;
    }
    case DLL_PROCESS_DETACH:
      if (active_output_mode >= 0.5f) {
        reshade::unregister_event<reshade::addon_event::reshade_present>(OnEncodingPresent);
        renodx::games::ffxiv::swapchain_facade::Use(fdw_reason);
      } else {
        reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
        reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      }
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitPresentation);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroyPresentation);
      reshade::unregister_event<reshade::addon_event::present>(OnPresentRouted);
      reshade::unregister_event<reshade::addon_event::present>(OnPresentStateReset);

      reshade::unregister_addon(h_module);
      break;
    default:
      break;
  }

  return TRUE;
}
