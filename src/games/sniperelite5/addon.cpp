/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <algorithm>
#include <atomic>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <mutex>
#include <shared_mutex>
#include <vector>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/random.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/state.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"
#include "./ui.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xDF4FF2F9),  // ApplyToneMapping
    CustomShaderEntry(0xD38BEC23),  // MLAA_PassOne_PS
    CustomShaderEntry(0x10C4A8CD),  // MLAA_PassTwo_PS
    CustomShaderEntry(0x30244AC4),  // MLAA_PassThree_PS
    CustomShaderEntry(0xF39DA40F),  // ColourCorrection_MainPS
    CustomShaderEntry(0x7DA15B99),  // MotionBlur_BlurPass_MainPS
    CustomShaderEntry(0x647D8259),  // MotionBlur_Apply_MainPS
    CustomShaderEntry(0x3A0FAB9C),  // CAS_Sharpen_Only
    CustomShaderEntry(0xCB58FFA8),  // CAS_Sharpen_Resize
    CustomShaderEntry(0x697FDB1B),  // FSR EASU fp32
    CustomShaderEntry(0xC879648D),  // FSR EASU fp16
    CustomShaderEntry(0xC68557EA),  // FullScreenPass_CopyTextureGamma
    CustomShaderEntry(0xDE0B3DF8),  // lensdirt
    CustomShaderEntry(0xFB6350BC),  // histogram
    CustomShaderEntry(0xD4BA238E),  // adaptluminance
    CustomShaderEntry(0xD9F1BE58),  // depthlinearise (SMAA edge depth source)
    CustomShaderEntry(0xAA8C0D56),  // corona (lamp flare sprite)
    CustomShaderEntry(0x495002B9),  // ReconstructHDRF16FromSDR
    CustomShaderEntry(0x624D485A),  // ReconstructHDRFromSDR
    CustomShaderEntry(0x7E7698AA),  // CopyTextureGamma_SRGB
    CustomShaderEntry(0xF3C25590),  // CopyTextureScaleAndOffset
    CustomShaderEntry(0xA0A3DD16),  // CopyTextureGamma_SRGB_FXAA
    CustomShaderEntry(0x3F8D43ED),  // CopyTextureGamma_SRGB_FXAA
    CustomShaderEntry(0x8269AB7D),  // CopyTextureGamma_SRGB_FXAA
    CustomShaderEntry(0xD4763E26),  // FXAA
    CustomShaderEntry(0xC1517BD2),  // FXAA
    CustomShaderEntry(0x2735B3ED),  // FXAA
    CustomShaderEntry(0x173A825F),  // BokehDownsample
    CustomShaderEntry(0x0E87DB38),  // BokehDownsample
    CustomShaderEntry(0x5F809FB0),  // BokehBlurPass1
    CustomShaderEntry(0x9612E154),  // ColourCorrection (alpha variant)
    CustomShaderEntry(0x39CE219F),  // FishEye
    CustomShaderEntry(0x626B9D5D),  // UI quad (add)
    CustomShaderEntry(0x04709154),  // SSAO_Compute (mipped linear depth): tolerant 4/255 skip flag
    CustomShaderEntry(0x7649B17D),  // SSAO_Compute (raw depth): tolerant 4/255 skip flag
    CustomShaderEntry(0x2465CDA7),  // Photon_PS: tolerant material-ID compares
    CustomShaderEntry(0x9BB7CC50),  // ASL_MainCS: tolerant material-ID compares
    CustomShaderEntry(0xD6ACD32A),  // ExtractSkin_PS: tolerant material-ID compares
    CustomShaderEntry(0xAF71A2A1),  // CombineSkin_PS: tolerant material-ID compares
    CustomShaderEntry(0x054C8638),  // PS_Main (deferred light): tolerant material-ID compares
    CustomShaderEntry(0x3499007D),  // PS_Main (deferred light): tolerant material-ID compares
    CustomShaderEntry(0x52FD3F26),  // PS_Main (deferred light): tolerant material-ID compares
    CustomShaderEntry(0x783A0C7E),  // PS_Main (deferred light): tolerant material-ID compares
    CustomShaderEntry(0x7CD83E5C),  // PS_Main (deferred light): tolerant material-ID compares
    CustomShaderEntry(0xC4E6A572),  // PS_Main (deferred light): tolerant material-ID compares
    CustomShaderEntry(0xF2700156),  // PS_Main (deferred light): tolerant material-ID compares
    CustomShaderEntry(0xF9C2474E),  // PS_Main (deferred light): tolerant material-ID compares
    CustomShaderEntry(0x3093F0E6),  // Photon_PS: tolerant material-ID compares
    CustomShaderEntry(0x8E90E725),  // Photon_PS: tolerant material-ID compares
    CustomShaderEntry(0xC790F6B5),  // Photon_PS: tolerant material-ID compares
    CustomShaderEntry(0xF8DACC96),  // Photon_PS: tolerant material-ID compares
    CustomShaderEntry(0x5D56F461),  // SunlightPS: tolerant material-ID compares
    CustomShaderEntry(0x99A0AA1A),  // SunlightPS: tolerant material-ID compares
    CustomShaderEntry(0xC1B8304C),  // ASL_MainCS: tolerant material-ID compares
    CustomShaderEntry(0xC43C7E87),  // ASL_MainCS: tolerant material-ID compares
};

ShaderInjectData shader_injection;

// Depth edge strength (0..1); forwarded to custom_depth_edges only when the depth copy is valid.
float depth_edges_strength = 0.5f;

// Set when the game's own HDR reconstruction shaders run; never cleared.
std::atomic<bool> game_hdr_in_use = false;

namespace ui = sniperelite5_ui;
namespace settings_ui = renodx::utils::settings;

// Section titles, in panel order.
constexpr const char* STATUS_SECTION = "Status";
constexpr const char* TONE_MAPPING_SECTION = "Tone Mapping";
constexpr const char* COLOR_GRADING_SECTION = "Color Grading";
constexpr const char* EFFECTS_SECTION = "Effects";
constexpr const char* AUTO_EXPOSURE_SECTION = "Auto Exposure";
constexpr const char* ABOUT_SECTION = "About";

settings_ui::Settings settings = {
    // Status
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "RenoDX for Sniper Elite 5 Made By Ostad Gaming",
        .section = STATUS_SECTION,
        .tint = ui::TINT_BRASS,
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "The game's in-game HDR option is on. RenoDX replaces it with its own HDR output, so set the game's HDR option to Off.",
        .section = STATUS_SECTION,
        .tint = ui::TINT_BRASS,
        .is_visible = []() { return game_hdr_in_use.load(); },
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = STATUS_SECTION,
        .tooltip = "Restores every setting in this panel to its default value.",
        .tint = ui::TINT_BRASS,
        .on_change = []() { settings_ui::ResetSettings(); },
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::CUSTOM,
        .label = "Ko-fi",
        .section = STATUS_SECTION,
        .tint = ui::TINT_BRASS,
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
          const float logo_gap = logo_size * 0.5f;
          const ImVec2 text_size = ImGui::CalcTextSize(kofi_text);
          const float content_width = logo_size + logo_gap + text_size.x;
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

          const ImVec2 text_pos = {logo_x + logo_size + logo_gap, center_y - text_size.y * 0.5f};
          draw_list->AddText(text_pos, kofi_white, kofi_text);

          if (clicked) {
            renodx::utils::platform::LaunchURL("https://ko-fi.com/ostadgaming");
          }
          return false;
        },
    },

    // Tone Mapping
    new settings_ui::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Vanilla is the game's original SDR tone map. None skips tone mapping and clips at Peak Brightness. DICE gives the None image with a smooth roll-off into Peak Brightness. Default: DICE.",
        .labels = {"Vanilla", "None", "DICE"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = ui::TINT_BRASS,
        .parse = [](float value) { return value >= 2.f ? 4.f : value; },
    },
    new settings_ui::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "The brightest level your display can show, in nits. Defaults to the peak Windows reports for your display (1000 if unknown).",
        .tint = ui::TINT_BRASS,
        .min = 48.f,
        .max = 4000.f,
        .format = "%.0f nits",
    },
    new settings_ui::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Brightness of 100% (diffuse) white in the scene, in nits. Default: 203, the HDR reference white.",
        .tint = ui::TINT_BRASS,
        .min = 48.f,
        .max = 500.f,
        .format = "%.0f nits",
    },
    new settings_ui::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Brightness of the HUD and menus, in nits. Default: 203, the HDR reference white.",
        .tint = ui::TINT_BRASS,
        .min = 48.f,
        .max = 500.f,
        .format = "%.0f nits",
    },
    new settings_ui::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Emulates the gamma curve of your display. Off keeps the game's sRGB look, 2.2 matches most monitors and TVs, BT.1886 matches calibrated reference displays. Default: 2.2.",
        .labels = {"Off", "2.2", "BT.1886"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = ui::TINT_BRASS,
        .parse = [](float value) {
          // The intermediate and swapchain encodings follow the gamma choice (value + 1 selects sRGB, 2.2 or 2.4).
          shader_injection.intermediate_encoding = value + 1.f;
          shader_injection.swap_chain_decoding = value + 1.f;
          return value;
        },
    },
    new settings_ui::Setting{
        .key = "ToneMapHighlightColour",
        .binding = &shader_injection.custom_highlight_colour,
        .default_value = 50.f,
        .label = "Highlight Color",
        .section = TONE_MAPPING_SECTION,
        .tooltip = "Keeps color in bright highlights instead of fading them to white. 0 matches the vanilla tone map. Default: 50%.",
        .tint = ui::TINT_BRASS,
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f%%",
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
    },

    // Color Grading
    new settings_ui::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "Scales the overall brightness before tone mapping. 1.00 is unchanged.",
        .tint = ui::TINT_BRASS,
        .max = 2.f,
        .format = "%.2fx",
    },
    new settings_ui::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "Adjusts the brightest parts of the image. 50 is unchanged.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "Adjusts the darkest parts of the image. 50 is unchanged.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "Adjusts the difference between dark and bright areas. 50 is unchanged.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "Adjusts color intensity. 50 is unchanged, 0 is black and white.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new settings_ui::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "How much of the game's own scene color grading is kept. 100% is as the game ships it. Default: 100%.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .format = "%.0f%%",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxLUTStrength",
        .binding = &shader_injection.custom_lut_strength,
        .default_value = 100.f,
        .label = "Color Grading LUT",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "Strength of the game's color grading lookup table. 100% is as the game ships it, 0% turns it off. Default: 100%.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxLUTSampling",
        .binding = &shader_injection.custom_lut_tetrahedral,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "LUT Sampling",
        .section = COLOR_GRADING_SECTION,
        .tooltip = "How the game's 16x16x16 grading table is read. Trilinear is the original method; Tetrahedral reduces banding and hue errors. Default: Tetrahedral.",
        .labels = {"Trilinear", "Tetrahedral"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = ui::TINT_BRASS,
    },

    // Effects
    new settings_ui::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.custom_bloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = EFFECTS_SECTION,
        .tooltip = "Strength of the glow around bright lights. 100% is as the game ships it. Default: 100%.",
        .tint = ui::TINT_BRASS,
        .max = 200.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxGodRays",
        .binding = &shader_injection.custom_god_rays,
        .default_value = 100.f,
        .label = "God Rays",
        .section = EFFECTS_SECTION,
        .tooltip = "Strength of light shafts through haze and foliage. 100% is as the game ships it. Default: 100%.",
        .tint = ui::TINT_BRASS,
        .max = 200.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxMotionBlur",
        .binding = &shader_injection.custom_motion_blur,
        .default_value = 100.f,
        .label = "Motion Blur",
        .section = EFFECTS_SECTION,
        .tooltip = "Strength of motion blur. 100% is as the game ships it, 0% turns it off. Default: 100%.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxMotionBlurQuality",
        .binding = &shader_injection.custom_motion_blur_quality,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Motion Blur Quality",
        .section = EFFECTS_SECTION,
        .tooltip = "Vanilla is the game's original blur sampling; High takes more samples for a smoother blur. Default: High.",
        .labels = {"Vanilla", "High"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = ui::TINT_BRASS,
    },
    new settings_ui::Setting{
        .key = "FxLensDirt",
        .binding = &shader_injection.custom_lens_dirt,
        .default_value = 100.f,
        .label = "Lens Dirt",
        .section = EFFECTS_SECTION,
        .tooltip = "Strength of the dirt and smudge overlay on bright lights. 100% is as the game ships it. Default: 100%.",
        .tint = ui::TINT_BRASS,
        .max = 200.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.custom_film_grain,
        .default_value = 0.f,
        .label = "Film Grain",
        .section = EFFECTS_SECTION,
        .tooltip = "Adds film grain. 0% is off, as in the vanilla game. Default: 0%.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxSharpening",
        .binding = &shader_injection.custom_sharpening,
        .default_value = 50.f,
        .label = "Sharpening",
        .section = EFFECTS_SECTION,
        .tooltip = "Strength of the Lilium RCAS sharpening filter. 0% turns sharpening off. Default: 50%.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .format = "%.0f%%",
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxSMAAQuality",
        .binding = &shader_injection.custom_smaa_ultra,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SMAA Quality",
        .section = EFFECTS_SECTION,
        .tooltip = "Ultra uses a lower edge threshold and longer edge searches than the game's High setting. Default: Ultra.",
        .labels = {"High (Game Default)", "Ultra"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = ui::TINT_BRASS,
    },
    new settings_ui::Setting{
        .key = "FxDepthEdges",
        .binding = &depth_edges_strength,
        .default_value = 50.f,
        .label = "SMAA Depth Edge Detection",
        .section = EFFECTS_SECTION,
        .tooltip = "Lowers the edge threshold where scene depth changes, so low-contrast geometry edges get anti-aliased. 0% is off. Default: 50%.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "FxAAHighlightWeight",
        .binding = &shader_injection.custom_aa_highlight_weight,
        .default_value = 100.f,
        .label = "AA Highlight Weighting",
        .section = EFFECTS_SECTION,
        .tooltip = "Pulls anti-aliased edges toward the darker side when one side is brighter than SDR white, so HDR edges stop looking jagged. 0% is the original blending. Default: 100%.",
        .tint = ui::TINT_BRASS,
        .max = 200.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },

    // Auto Exposure
    new settings_ui::Setting{
        .key = "AutoExposureBrighten",
        .binding = &shader_injection.custom_auto_exposure_brighten,
        .default_value = 100.f,
        .label = "Brightening",
        .section = AUTO_EXPOSURE_SECTION,
        .tooltip = "How much the game's auto exposure may brighten dark scenes. 100% is as the game ships it. Default: 100%.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "AutoExposureDarken",
        .binding = &shader_injection.custom_auto_exposure_darken,
        .default_value = 100.f,
        .label = "Darkening",
        .section = AUTO_EXPOSURE_SECTION,
        .tooltip = "How much the game's auto exposure may darken bright scenes. 100% is as the game ships it. Default: 100%.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "AutoExposureMetering",
        .binding = &shader_injection.custom_auto_exposure_metering,
        .value_type = settings_ui::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Metering",
        .section = AUTO_EXPOSURE_SECTION,
        .tooltip = "How scene brightness is measured. Average is the game's original method; Log-Average is less swayed by small bright areas. Default: Log-Average.",
        .labels = {"Average (Vanilla)", "Log-Average"},
        .style = settings_ui::SettingStyle::SEGMENTED,
        .tint = ui::TINT_BRASS,
    },
    new settings_ui::Setting{
        .key = "AutoExposureCentreWeight",
        .binding = &shader_injection.custom_auto_exposure_centre_weight,
        .default_value = 50.f,
        .label = "Center Weight",
        .section = AUTO_EXPOSURE_SECTION,
        .tooltip = "How much the screen center counts more than the edges when measuring brightness. 0% is the game's uniform metering. Default: 50%.",
        .tint = ui::TINT_BRASS,
        .max = 100.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "AutoExposureIgnoreBright",
        .binding = &shader_injection.custom_auto_exposure_ignore_bright,
        .default_value = 5.f,
        .label = "Ignore Brightest",
        .section = AUTO_EXPOSURE_SECTION,
        .tooltip = "Brightest share of the screen left out of metering (sky, sun). 0% is the game's original metering. Default: 5%.",
        .tint = ui::TINT_BRASS,
        .max = 25.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "AutoExposureIgnoreDark",
        .binding = &shader_injection.custom_auto_exposure_ignore_dark,
        .default_value = 0.f,
        .label = "Ignore Darkest",
        .section = AUTO_EXPOSURE_SECTION,
        .tooltip = "Darkest share of the screen left out of metering. 0% is the game's original metering. Default: 0%.",
        .tint = ui::TINT_BRASS,
        .max = 25.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "AutoExposureSpeed",
        .binding = &shader_injection.custom_auto_exposure_speed,
        .default_value = 100.f,
        .label = "Speed",
        .section = AUTO_EXPOSURE_SECTION,
        .tooltip = "How fast exposure adapts. 100% is as the game ships it, 0% freezes exposure. Default: 100%.",
        .tint = ui::TINT_BRASS,
        .max = 300.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
    },
    new settings_ui::Setting{
        .key = "AutoExposureLimitBrighten",
        .binding = &shader_injection.custom_auto_exposure_limit_brighten,
        .default_value = 4.f,
        .label = "Brighten Limit",
        .section = AUTO_EXPOSURE_SECTION,
        .tooltip = "The most the auto exposure may brighten, in stops (EV). Default: 4.0 EV.",
        .tint = ui::TINT_BRASS,
        .max = 4.f,
        .format = "%.1f EV",
    },
    new settings_ui::Setting{
        .key = "AutoExposureLimitDarken",
        .binding = &shader_injection.custom_auto_exposure_limit_darken,
        .default_value = 4.f,
        .label = "Darken Limit",
        .section = AUTO_EXPOSURE_SECTION,
        .tooltip = "The most the auto exposure may darken, in stops (EV). Default: 4.0 EV.",
        .tint = ui::TINT_BRASS,
        .max = 4.f,
        .format = "%.1f EV",
    },

    // About
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "Unofficial community HDR mod built with RenoDX. Not affiliated with Rebellion.",
        .section = ABOUT_SECTION,
        .tint = ui::TINT_BRASS,
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::TEXT,
        .label = "RenoDX by Carlos Lopez (clshortfuse) and contributors.",
        .section = ABOUT_SECTION,
        .tint = ui::TINT_BRASS,
    },
    new settings_ui::Setting{
        .value_type = settings_ui::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = ABOUT_SECTION,
        .tint = ui::TINT_BRASS,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/", "t9v7wx9NTD"); },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("GammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeScene", 100.f);
  renodx::utils::settings::UpdateSetting("FxLensDirt", 100.f);
  renodx::utils::settings::UpdateSetting("FxFilmGrain", 0.f);
  renodx::utils::settings::UpdateSetting("AutoExposureIgnoreDark", 0.f);
  renodx::utils::settings::UpdateSetting("AutoExposureSpeed", 100.f);
  renodx::utils::settings::UpdateSetting("AutoExposureLimitBrighten", 4.f);
  renodx::utils::settings::UpdateSetting("AutoExposureLimitDarken", 4.f);
  renodx::utils::settings::UpdateSetting("AutoExposureBrighten", 100.f);
  renodx::utils::settings::UpdateSetting("AutoExposureDarken", 100.f);
  renodx::utils::settings::UpdateSetting("AutoExposureMetering", 0.f);
  renodx::utils::settings::UpdateSetting("AutoExposureCentreWeight", 0.f);
  renodx::utils::settings::UpdateSetting("AutoExposureIgnoreBright", 0.f);
  renodx::utils::settings::UpdateSetting("FxMotionBlurQuality", 0.f);
  renodx::utils::settings::UpdateSetting("FxBloom", 100.f);
  renodx::utils::settings::UpdateSetting("FxGodRays", 100.f);
  renodx::utils::settings::UpdateSetting("FxMotionBlur", 100.f);
  renodx::utils::settings::UpdateSetting("FxSharpening", 100.f);
  renodx::utils::settings::UpdateSetting("FxLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("FxLUTSampling", 0.f);
  renodx::utils::settings::UpdateSetting("FxSMAAQuality", 0.f);
  renodx::utils::settings::UpdateSetting("FxAAHighlightWeight", 0.f);
  renodx::utils::settings::UpdateSetting("FxDepthEdges", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapHighlightColour", 0.f);
}

int typeless_target_index = -1;
int half_res_srgb_target_index = -1;

bool fired_on_init_swapchain = false;

// Render-resolution targets are matched by back-buffer aspect ratio plus a minimum size that follows the swapchain.
void OnInitSwapchain(reshade::api::swapchain* swapchain, bool /*resize*/) {
  if (!renodx::utils::swapchain::IsDXGI(swapchain)) return;
  const auto back_buffer = swapchain->get_back_buffer(0);
  if (back_buffer.handle == 0u) return;

  // Peak Brightness defaults to the peak Windows reports for the display, detected once on the first DXGI swapchain.
  if (!fired_on_init_swapchain) {
    const auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
    auto* peak_setting = settings_ui::FindSetting("ToneMapPeakNits");
    if (peak.has_value() && peak_setting != nullptr) {
      fired_on_init_swapchain = true;
      const float peak_nits = std::round(peak.value());
      peak_setting->default_value = peak_nits;
      peak_setting->can_reset = true;

      // Presets load before the swapchain exists, so a missing key means the default was never saved.
      float saved_peak_nits = 0.f;
      if (settings_ui::preset_index != 0
          && !reshade::get_config_value(nullptr, settings_ui::GetCurrentPresetName().c_str(), "ToneMapPeakNits", saved_peak_nits)) {
        settings_ui::UpdateSetting("ToneMapPeakNits", peak_nits);
      }
    }
  }

  if (typeless_target_index < 0 || half_res_srgb_target_index < 0) return;

  const auto back_buffer_desc = swapchain->get_device()->get_resource_desc(back_buffer);
  auto& typeless_min = renodx::mods::swapchain::resource_upgrade_infos[typeless_target_index].min_dimensions;
  auto& half_res_min = renodx::mods::swapchain::resource_upgrade_infos[half_res_srgb_target_index].min_dimensions;
  const auto typeless_width = static_cast<int16_t>(back_buffer_desc.texture.width * 0.45f);
  const auto typeless_height = static_cast<int16_t>(back_buffer_desc.texture.height * 0.45f);
  const auto half_res_width = static_cast<int16_t>(back_buffer_desc.texture.width * 0.2f);
  const auto half_res_height = static_cast<int16_t>(back_buffer_desc.texture.height * 0.2f);
  if (typeless_min.width == typeless_width && typeless_min.height == typeless_height && half_res_min.width == half_res_width
      && half_res_min.height == half_res_height) {
    return;
  }
  typeless_min.width = typeless_width;
  typeless_min.height = typeless_height;
  half_res_min.width = half_res_width;
  half_res_min.height = half_res_height;
  // The swapchain mod copies the upgrade infos into the device at init_device; push the new sizes to it.
  renodx::utils::resource::upgrade::SetUpgradeInfos(swapchain->get_device(), renodx::mods::swapchain::resource_upgrade_infos);
}

// SMAA edge depth: the r16g16_float depth pass target is copied each frame into an addon-owned raw buffer (root SRV t0 space50).
constexpr uint32_t DEPTH_CAPTURE_SHADER_HASH = 0xD9F1BE58u;
constexpr uint32_t SMAA_EDGE_SHADER_HASH = 0xD38BEC23u;
constexpr uint32_t DEPTH_EDGES_SRV_REGISTER = 0u;
constexpr uint32_t DEPTH_EDGES_SRV_SPACE = 50u;
constexpr uint64_t DEPTH_EDGES_PLACEHOLDER_BYTES = 256u;
// The edge shader reads the depth copy from byte 2048; the first 2 KiB of the buffer are left unused.
constexpr uint64_t DEPTH_BUFFER_OFFSET = 2048u;
// The depth header sits in the unused bytes before the depth copy.
constexpr uint64_t DEPTH_HEADER_BUFFER_OFFSET = 512u;
constexpr uint64_t DEPTH_HEADER_BYTES = 16u;
constexpr uint32_t DEPTH_CANDIDATE_CAPACITY = 4u;

struct RetiredDepthBuffer {
  reshade::api::resource buffer = {0u};
  reshade::api::resource_view srv = {0u};
};

// A depth pass target seen recently.
struct DepthCandidate {
  reshade::api::resource resource = {0u};
  uint32_t width = 0u;
  uint32_t height = 0u;
};

// Mirrors the 16-byte depth header at DEPTH_HEADER_BUFFER_OFFSET read by the edge shader.
struct DepthHeaderWords {
  uint32_t depth_width;
  uint32_t depth_height;
  uint32_t depth_row_texels;
  uint32_t reserved;
  bool operator==(const DepthHeaderWords&) const = default;
};
static_assert(sizeof(DepthHeaderWords) == DEPTH_HEADER_BYTES);

struct DepthEdgesState {
  std::shared_mutex mutex;
  reshade::api::device* device = nullptr;
  std::vector<DepthCandidate> candidates;
  reshade::api::resource buffer = {0u};
  reshade::api::resource_view srv = {0u};
  uint64_t size_bytes = 0u;
  std::vector<RetiredDepthBuffer> retired;
  // Depth header upload and the words it holds. Immutable once created; superseded uploads are retired.
  reshade::api::resource depth_header_upload = {0u};
  DepthHeaderWords depth_header_words = {};
};
DepthEdgesState depth_edges;

void DestroyDepthBuffer(reshade::api::device* device, reshade::api::resource buffer, reshade::api::resource_view srv) {
  if (srv.handle != 0u) device->destroy_resource_view(srv);
  if (buffer.handle != 0u) device->destroy_resource(buffer);
}

// Superseded buffers are retired, not destroyed: earlier command lists may still reference them. Caller holds depth_edges.mutex.
bool EnsureDepthBufferLocked(reshade::api::device* device, uint64_t size_bytes) {
  if (depth_edges.device != nullptr && depth_edges.device != device) return false;
  if (depth_edges.buffer.handle != 0u && depth_edges.size_bytes >= size_bytes) return true;

  const reshade::api::resource_desc buffer_desc(
      size_bytes,
      reshade::api::memory_heap::gpu_only,
      reshade::api::resource_usage::shader_resource | reshade::api::resource_usage::copy_dest);
  reshade::api::resource new_buffer = {0u};
  if (!device->create_resource(buffer_desc, nullptr, reshade::api::resource_usage::shader_resource, &new_buffer)) {
    return false;
  }
  reshade::api::resource_view new_srv = {0u};
  if (!device->create_resource_view(
          new_buffer,
          reshade::api::resource_usage::shader_resource,
          reshade::api::resource_view_desc(reshade::api::format::r32_typeless, 0u, size_bytes / sizeof(uint32_t)),
          &new_srv)) {
    device->destroy_resource(new_buffer);
    return false;
  }
  if (depth_edges.buffer.handle != 0u) {
    depth_edges.retired.push_back({
        .buffer = depth_edges.buffer,
        .srv = depth_edges.srv,
    });
  }
  depth_edges.device = device;
  depth_edges.buffer = new_buffer;
  depth_edges.srv = new_srv;
  depth_edges.size_bytes = size_bytes;
  return true;
}

// Records the linear depth target of the depth pass as a candidate. Targets that are not r16g16_float are rejected.
bool OnDepthCaptureReplace(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list->get_device();
  const auto rt = device->get_resource_from_view(renodx::utils::state::GetRenderTarget(cmd_list, 0u));
  if (rt.handle == 0u) {
    return true;
  }
  const auto rt_desc = renodx::utils::resource::GetResourceDesc(device, rt);
  if (rt_desc.type != reshade::api::resource_type::texture_2d) {
    return true;
  }
  if (rt_desc.texture.format != reshade::api::format::r16g16_float) {
    return true;
  }

  DepthCandidate captured = {
      .resource = rt,
      .width = rt_desc.texture.width,
      .height = rt_desc.texture.height,
  };
  std::unique_lock lock(depth_edges.mutex);
  auto& candidates = depth_edges.candidates;
  const auto match = std::find_if(candidates.begin(), candidates.end(), [&rt](const DepthCandidate& entry) {
    return entry.resource.handle == rt.handle;
  });
  if (match != candidates.end()) {
    *match = captured;
  } else if (candidates.size() < DEPTH_CANDIDATE_CAPACITY) {
    candidates.push_back(captured);
  } else {
    candidates[0] = captured;  // Full: the first slot is overwritten.
  }
  return true;
}

// Copies the captured depth into the scene buffer and writes the 16-byte depth header. On any failure
// custom_depth_edges stays 0, which disables the depth term in the edge shader. Always returns true so the edge draw
// proceeds.
bool OnDepthEdgesReplace(reshade::api::command_list* cmd_list) {
  shader_injection.custom_depth_edges = 0.f;
  if (depth_edges_strength <= 0.f) {
    return true;
  }

  auto* device = cmd_list->get_device();
  // The copy cannot be recorded inside a render pass; state tracking records the pass depth per command list.
  const auto* snapshot_data = renodx::utils::state::internal::GetTrackedSnapshotData(cmd_list);
  if (snapshot_data != nullptr && snapshot_data->render_pass_depth != 0u) {
    return true;
  }

  const auto rt = device->get_resource_from_view(renodx::utils::state::GetRenderTarget(cmd_list, 0u));
  if (rt.handle == 0u) {
    return true;
  }
  const auto rt_desc = renodx::utils::resource::GetResourceDesc(device, rt);

  // The depth target must be 1/2 or 1/4 of the edge pass target on each axis, within 3 px for odd render sizes; the
  // largest such candidate wins.
  const auto fits_within_tolerance = [](uint32_t depth_size, uint32_t edge_size) {
    const auto close = [edge_size](uint32_t scaled) { return (scaled > edge_size ? scaled - edge_size : edge_size - scaled) <= 3u; };
    return close(depth_size * 2u) || close(depth_size * 4u);
  };
  DepthCandidate candidate = {};
  bool candidate_found = false;
  {
    std::shared_lock lock(depth_edges.mutex);
    for (const auto& entry : depth_edges.candidates) {
      const bool width_fits = fits_within_tolerance(entry.width, rt_desc.texture.width);
      const bool height_fits = fits_within_tolerance(entry.height, rt_desc.texture.height);
      if (!width_fits || !height_fits) continue;
      if (candidate_found && entry.width * entry.height <= candidate.width * candidate.height) continue;
      candidate = entry;
      candidate_found = true;
    }
  }
  if (!candidate_found) {
    return true;
  }

  // Row pitch is 64-texel (256-byte) aligned for copy_texture_to_buffer; depth texels are r16g16 (4 bytes each).
  const uint32_t depth_row_texels = (candidate.width + 63u) & ~63u;
  const uint64_t buffer_size_bytes = DEPTH_BUFFER_OFFSET + static_cast<uint64_t>(depth_row_texels) * 4u * candidate.height;
  reshade::api::resource buffer = {0u};
  reshade::api::resource depth_header_upload = {0u};
  {
    std::unique_lock lock(depth_edges.mutex);
    if (!EnsureDepthBufferLocked(device, buffer_size_bytes)) {
      return true;
    }
    buffer = depth_edges.buffer;
    const DepthHeaderWords header = {
        .depth_width = candidate.width,
        .depth_height = candidate.height,
        .depth_row_texels = depth_row_texels,
    };
    if (depth_edges.depth_header_upload.handle == 0u || !(depth_edges.depth_header_words == header)) {
      if (depth_edges.depth_header_upload.handle != 0u) {
        depth_edges.retired.push_back({.buffer = depth_edges.depth_header_upload});
      }
      depth_edges.depth_header_upload = {0u};
      const reshade::api::resource_desc upload_desc(DEPTH_HEADER_BYTES, reshade::api::memory_heap::cpu_to_gpu, reshade::api::resource_usage::copy_source);
      reshade::api::resource new_upload = {0u};
      if (!device->create_resource(upload_desc, nullptr, reshade::api::resource_usage::copy_source, &new_upload)) {
        return true;
      }
      void* mapped_header = nullptr;
      if (!device->map_buffer_region(new_upload, 0u, DEPTH_HEADER_BYTES, reshade::api::map_access::write_only, &mapped_header)) {
        device->destroy_resource(new_upload);
        return true;
      }
      std::memcpy(mapped_header, &header, sizeof(header));
      device->unmap_buffer_region(new_upload);
      depth_edges.depth_header_upload = new_upload;
      depth_edges.depth_header_words = header;
    }
    depth_header_upload = depth_edges.depth_header_upload;
  }

  // Every use restores the states it changed, so command lists can record in parallel.
  cmd_list->barrier(candidate.resource, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::copy_source);
  cmd_list->barrier(buffer, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::copy_dest);
  cmd_list->copy_texture_to_buffer(
      candidate.resource, 0u, nullptr, buffer, DEPTH_BUFFER_OFFSET, depth_row_texels, candidate.height);
  cmd_list->barrier(candidate.resource, reshade::api::resource_usage::copy_source, reshade::api::resource_usage::shader_resource);
  cmd_list->copy_buffer_region(depth_header_upload, 0u, buffer, DEPTH_HEADER_BUFFER_OFFSET, DEPTH_HEADER_BYTES);
  cmd_list->barrier(buffer, reshade::api::resource_usage::copy_dest, reshade::api::resource_usage::shader_resource);

  shader_injection.custom_depth_edges = depth_edges_strength;
  return true;
}

// Always returns a valid view: a null view makes the framework skip the draw. A placeholder stands in until the first copy.
reshade::api::resource_view GetDepthEdgesView(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list->get_device();
  std::unique_lock lock(depth_edges.mutex);
  if (depth_edges.srv.handle == 0u) {
    EnsureDepthBufferLocked(device, DEPTH_EDGES_PLACEHOLDER_BYTES);
  }
  return depth_edges.srv;
}

void OnPresentDepthEdges(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* /*swapchain*/,
    const reshade::api::rect* /*source_rect*/,
    const reshade::api::rect* /*dest_rect*/,
    uint32_t /*dirty_rect_count*/,
    const reshade::api::rect* /*dirty_rects*/) {
  std::unique_lock lock(depth_edges.mutex);
  auto* device = depth_edges.device;
  if (device == nullptr || depth_edges.retired.empty() || queue->get_device() != device) return;
  queue->wait_idle();
  for (const auto& entry : depth_edges.retired) {
    DestroyDepthBuffer(device, entry.buffer, entry.srv);
  }
  depth_edges.retired.clear();
}

void OnDestroyDepthEdgesResource(reshade::api::device* /*device*/, reshade::api::resource resource) {
  std::unique_lock lock(depth_edges.mutex);
  std::erase_if(depth_edges.candidates, [&resource](const DepthCandidate& entry) {
    return entry.resource.handle == resource.handle;
  });
}

void OnDestroyDepthEdgesDevice(reshade::api::device* device) {
  std::unique_lock lock(depth_edges.mutex);
  if (depth_edges.device != device) return;
  DestroyDepthBuffer(device, depth_edges.buffer, depth_edges.srv);
  DestroyDepthBuffer(device, depth_edges.depth_header_upload, {0u});
  depth_edges.depth_header_upload = {0u};
  depth_edges.depth_header_words = {};
  for (const auto& entry : depth_edges.retired) {
    DestroyDepthBuffer(device, entry.buffer, entry.srv);
  }
  depth_edges.retired.clear();
  depth_edges.device = nullptr;
  depth_edges.candidates.clear();
  depth_edges.buffer = {0u};
  depth_edges.srv = {0u};
  depth_edges.size_bytes = 0u;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Sniper Elite 5";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresentDepthEdges);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyDepthEdgesResource);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDepthEdgesDevice);

      renodx::utils::state::use_render_target_tracking = true;
      custom_shaders.at(DEPTH_CAPTURE_SHADER_HASH).on_replace = OnDepthCaptureReplace;
      for (const uint32_t hash : {0x495002B9u, 0x624D485Au}) {
        custom_shaders.at(hash).on_replace = [](reshade::api::command_list* /*cmd_list*/) {
          game_hdr_in_use = true;
          return true;
        };
      }
      {
        auto& edge_shader = custom_shaders.at(SMAA_EDGE_SHADER_HASH);
        edge_shader.on_replace = OnDepthEdgesReplace;
        edge_shader.views = {{
            .type = reshade::api::descriptor_type::buffer_shader_resource_view,
            .slot = DEPTH_EDGES_SRV_REGISTER,
            .space = DEPTH_EDGES_SRV_SPACE,
            .get_view = GetDepthEdgesView,
        }};
      }
      {
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

        // Display output: HDR10 swapchain, no forced borderless, no fullscreen prevention, no display proxy.
        // Gamma-dependent encodings are set by the Gamma Correction setting's parse.
        shader_injection.intermediate_encoding = 2.f;
        shader_injection.swap_chain_decoding = 2.f;
        shader_injection.swap_chain_gamma_correction = 0.f;
        shader_injection.swap_chain_custom_color_space = 0.f;
        shader_injection.swap_chain_clamp_color_space = 1.f;
        shader_injection.swap_chain_encoding = 4.f;
        shader_injection.swap_chain_encoding_color_space = 1.f;
        renodx::mods::swapchain::force_borderless = false;
        renodx::mods::swapchain::prevent_full_screen = false;
        renodx::mods::swapchain::SetUseHDR10(true);
        renodx::mods::swapchain::use_resize_buffer = false;
        renodx::mods::swapchain::use_device_proxy = false;
        renodx::mods::swapchain::set_color_space = true;
        renodx::mods::swapchain::device_proxy_wait_idle_source = false;
        renodx::mods::swapchain::device_proxy_wait_idle_destination = false;

        // Post-tonemap 8-bit targets matched by back-buffer aspect ratio; min_dimensions are set in OnInitSwapchain.
        typeless_target_index = static_cast<int>(renodx::mods::swapchain::resource_upgrade_infos.size());
        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,  // has to be float instead of typeless
            .use_resource_view_cloning = true,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .aspect_ratio_tolerance = 0.01f,
            .min_dimensions = {.width = INT16_MAX, .height = INT16_MAX},
            .usage_include = reshade::api::resource_usage::render_target,
        });
        half_res_srgb_target_index = static_cast<int>(renodx::mods::swapchain::resource_upgrade_infos.size());
        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
            .new_format = reshade::api::format::r16g16b16a16_float,  // has to be float instead of typeless
            .use_resource_view_cloning = true,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .aspect_ratio_tolerance = 0.01f,
            .min_dimensions = {.width = INT16_MAX, .height = INT16_MAX},
            .usage_include = reshade::api::resource_usage::render_target,
        });
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresentDepthEdges);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(OnDestroyDepthEdgesResource);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDepthEdgesDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::utils::random::Use(fdw_reason, {&shader_injection.custom_random});

  return TRUE;
}
