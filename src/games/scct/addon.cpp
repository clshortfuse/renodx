/*
 * Copyright (C) 2026
 * SPDX-License-Identifier: MIT
 *
 * RenoDX HDR mod for Tom Clancy's Splinter Cell: Chaos Theory (Steam, D3D9, 32-bit).
 *
 * HDR output goes through RenoDX's DX11 device proxy, which gives the back buffer an RGBA16F
 * clone. The composite (0x83A4F799) is replaced so the scene keeps its values above 1.0 and is
 * display-mapped; the HUD draws onto the clone after it and the swap chain pass shows
 * it at UI Brightness. Copies to and from the back buffer are done on its clone (copy redirect),
 * so the vision passes read the real image.
 *
 * Development tools (SCCT_DEV_TOOLS):
 *
 *   F10        trace the next frame (render targets, clears, copies, resolves, draws, present)
 *              to ReShade.log as [scct-trace] lines
 *   F9 / F8    select the next / previous candidate draw and hide it (F8 below 0: probe off)
 *   F7         candidates: blended draws, every draw, or HUD draws only
 *
 * They also log every pixel and vertex shader once as [scct-shader] with its shader model, saved to
 * scct-dumps\0x<hash>.<ps|vs>_<major>_<minor>.cso in the game folder, report what keeps an old D3D9
 * device alive ([scct-leak]), and log the call stack if the add-on aborts ([scct-crash]).
 */

#define ImTextureID ImU64

// Development tools: trace, probe, shader dump, leak report and crash report. On in Debug builds,
// off in Release and RelWithDebInfo (which define NDEBUG); pass -DSCCT_DEV_TOOLS=0/1 to override.
#ifndef SCCT_DEV_TOOLS
#ifdef NDEBUG
#define SCCT_DEV_TOOLS 0
#else
#define SCCT_DEV_TOOLS 1
#endif
#endif

#define RENODX_MODS_SWAPCHAIN_VERSION 2

#include <d3d9.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iterator>
#include <sstream>
#include <string>
#include <vector>

#if SCCT_DEV_TOOLS
#include <csignal>
#include <cstdio>
#include <cstring>
#include <exception>
#include <filesystem>
#include <fstream>
#include <unordered_map>
#endif

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

// Replaced game shaders: the composite (0x83A4F799).
renodx::mods::shader::CustomShaders custom_shaders = {
    __ALL_CUSTOM_SHADERS,
};

ShaderInjectData shader_injection;
float night_vision_hdr = 0.f;

constexpr float TONE_MAP_VANILLA = 0.f;
constexpr float TONE_MAP_RENO_DRT = 3.f;

constexpr float OUTPUT_MODE_SDR = 0.f;
constexpr float OUTPUT_MODE_HDR = 1.f;
constexpr float HDR_FORMAT_HDR10 = 0.f;

// renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_* (src/shaders/draw.hlsl).
constexpr float SWAP_CHAIN_OUTPUT_PRESET_NONE = -1.f;
constexpr float SWAP_CHAIN_OUTPUT_PRESET_SDR = 0.f;
constexpr float SWAP_CHAIN_OUTPUT_PRESET_HDR10 = 1.f;

renodx::utils::settings::Setting* output_mode_setting = nullptr;
renodx::utils::settings::Setting* hdr_format_setting = nullptr;
renodx::utils::settings::Setting* tone_map_type_setting = nullptr;
renodx::utils::settings::Setting* peak_nits_setting = nullptr;
renodx::utils::settings::Setting* game_nits_setting = nullptr;
renodx::utils::settings::Setting* ui_nits_setting = nullptr;
renodx::utils::settings::Setting* gamma_correction_setting = nullptr;

bool IsToneMapped() {
  return shader_injection.tone_map_type > TONE_MAP_VANILLA;
}

bool IsHDR() {
  return output_mode_setting->GetValue() != OUTPUT_MODE_SDR;
}

// Tone Mapper, Peak, Game and UI Brightness and Gamma Correction have no binding: UpdateOutput
// writes them, and overrides them in SDR.
renodx::utils::settings::Settings settings = {
    output_mode_setting = new renodx::utils::settings::Setting{
        .key = "OutputMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = OUTPUT_MODE_HDR,
        .can_reset = false,
        .label = "Output Mode",
        .section = "Display Output",
        .tooltip = "SDR: the game's picture for an SDR display (or HDR off in Windows).\n"
                   "HDR: HDR output in the HDR Format below.\n"
                   "Starts on SDR or HDR to match Windows' HDR setting.",
        .labels = {"SDR", "HDR"},
        .is_global = true,
    },
    hdr_format_setting = new renodx::utils::settings::Setting{
        .key = "HDRFormat",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .can_reset = false,
        .label = "HDR Format",
        .section = "Display Output",
        .tooltip = "HDR10: 10-bit BT.2020 PQ.\n"
                   "scRGB: 16-bit float BT.709, for capture or overlay tools that need it.\n"
                   "Restart the game to apply.",
        .labels = {"HDR10", "scRGB"},
        .is_global = true,
    },
    tone_map_type_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        // Psycho-V: closest to vanilla below paper white and in highlight colour.
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Vanilla: the game's picture, clipped at white as in the original.\n"
                   "None: no highlight roll-off (clips at peak).\n"
                   "RenoDRT: highlights above white are kept and rolled off toward peak.\n"
                   "PsychoV-30: perceptual tone mapper; keeps hue and purity as highlights compress.",
        // Menu index -> type: framework type 2 (ACES) isn't offered.
        .labels = {"Vanilla", "None", "RenoDRT", "PsychoV-30"},
        .is_enabled = &IsHDR,
        .parse = [](float value) {
          if (value >= 3.f) return SCCT_TONE_MAP_TYPE_PSYCHO_V;
          if (value >= 2.f) return TONE_MAP_RENO_DRT;
          return value;
        },
    },
    peak_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .default_value = 1000.f,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = &IsToneMapped,
    },
    game_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHDR,
    },
    ui_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHDR,
    },
    gamma_correction_setting = new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "How the game's SDR image is decoded.\n"
                   "2.2 matches how the game looks on a typical SDR display.",
        .labels = {"sRGB", "2.2"},
        .is_enabled = &IsHDR,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.hue_correction,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Shifts HDR highlights toward the hue vanilla showed.\n"
                   "Vanilla clipped each colour channel at white, so bright lamps and lights turned\n"
                   "whiter. Only colours that went past white are shifted.\n"
                   "0% = keep the computed colour, 100% = vanilla hue.",
        .max = 100.f,
        .is_enabled = &IsToneMapped,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .tooltip = "Brightness of the 3D scene before tone mapping (not the HUD). 1.00 = vanilla.",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = &IsToneMapped,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .tooltip = "Brightness of the bright parts of the scene. 50 = vanilla.",
        .max = 100.f,
        .is_enabled = &IsToneMapped,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .tooltip = "Brightness of the dark parts of the scene. 50 = vanilla.",
        .max = 100.f,
        .is_enabled = &IsToneMapped,
        // 0 = 0, 50 = 1, 100 = SCCT_SHADOWS_MAX instead of 2 (see shared.h).
        .parse = [](float value) {
          if (value <= 50.f) return value * 0.02f;
          return std::lerp(1.f, SCCT_SHADOWS_MAX, (value - 50.f) * 0.02f);
        },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .tooltip = "Contrast of the 3D scene. 50 = vanilla.",
        .max = 100.f,
        .is_enabled = &IsToneMapped,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .tooltip = "Colour saturation of the 3D scene (not the HUD).\n"
                   "0 = greyscale, 50 = vanilla, 100 = twice vanilla.",
        .max = 100.f,
        .is_enabled = &IsToneMapped,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.bloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .tooltip = "Strength of the game's glow.\n"
                   "0 = off, 50 = vanilla, 100 = twice vanilla.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxNightVisionHdr",
        .binding = &night_vision_hdr,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "Night Vision HDR",
        .section = "Effects",
        .tooltip = "Night vision's blown-out areas go past white, raised by the game's own glow,\n"
                   "up to 4x Game Brightness. Off = the game's night vision.",
        .is_enabled = &IsHDR,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- The game's own brightness and gamma options have no effect; use Game Brightness and Gamma Correction.",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset",
        .section = "About",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "F6AUTeWJHM");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "About",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "About",
        .group = "button-line-1",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/", "shortfuse");
        },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", TONE_MAP_VANILLA);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("GammaCorrection", 1.f);
  renodx::utils::settings::UpdateSetting("ToneMapHueCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("FxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("FxNightVisionHdr", 0.f);
}

// Psycho-V settings that put it on vanilla below white (vanilla is the identity there): per Peak /
// Game Brightness ratio, the shadows that match 0.2-10 nits and the highlights that match 50-203
// nits, at Gamma Correction 2.2. Fitted on the GPU with psychotm_test30 on a grey ramp;
// midtones then stay within 0.3-2.6%. Interpolated in log(ratio), clamped at the ends.
struct PsychoMatch {
  float ratio = 1.f;
  float shadows = 1.f;
  float highlights = 1.f;
};
constexpr PsychoMatch PSYCHO_MATCH[] = {
    {.ratio = 1.25f, .shadows = 1.6964f, .highlights = 1.2922f},
    {.ratio = 1.5f, .shadows = 1.6415f, .highlights = 1.2185f},
    {.ratio = 2.f, .shadows = 1.5608f, .highlights = 1.1446f},
    {.ratio = 2.5f, .shadows = 1.5026f, .highlights = 1.1077f},
    {.ratio = 3.f, .shadows = 1.4575f, .highlights = 1.0855f},
    {.ratio = 4.f, .shadows = 1.3908f, .highlights = 1.0603f},
    {.ratio = 5.f, .shadows = 1.3427f, .highlights = 1.0464f},
    {.ratio = 6.f, .shadows = 1.3060f, .highlights = 1.0376f},
    {.ratio = 8.f, .shadows = 1.2526f, .highlights = 1.0271f},
    {.ratio = 10.f, .shadows = 1.2155f, .highlights = 1.0211f},
    {.ratio = 15.f, .shadows = 1.1575f, .highlights = 1.0135f},
    {.ratio = 20.f, .shadows = 1.1238f, .highlights = 1.0098f},
    {.ratio = 30.f, .shadows = 1.0863f, .highlights = 1.0063f},
    {.ratio = 50.f, .shadows = 1.0531f, .highlights = 1.0036f},
};

PsychoMatch PsychoMatchFor(float ratio) {
  const auto* first = std::begin(PSYCHO_MATCH);
  const auto* last = std::end(PSYCHO_MATCH) - 1;
  if (ratio <= first->ratio) return *first;
  if (ratio >= last->ratio) return *last;
  const auto* upper = first + 1;
  while (upper->ratio < ratio) {
    ++upper;
  }
  const auto* lower = upper - 1;
  const float t = std::log(ratio / lower->ratio) / std::log(upper->ratio / lower->ratio);
  return {
      .ratio = ratio,
      .shadows = std::lerp(lower->shadows, upper->shadows, t),
      .highlights = std::lerp(lower->highlights, upper->highlights, t),
  };
}

// Writes what the shaders read from Output Mode, on the HDR Format chosen at startup, and the
// Psycho-V match for the resulting Peak / Game Brightness. Run every game frame, so slider changes,
// presets and Reset all reach the shaders through it.
void UpdateOutput() {
  const bool is_hdr10 = (renodx::mods::swapchain::target_format == reshade::api::format::r10g10b10a2_unorm);
  if (IsHDR()) {
    shader_injection.swap_chain_output_preset = (is_hdr10 ? SWAP_CHAIN_OUTPUT_PRESET_HDR10 : SWAP_CHAIN_OUTPUT_PRESET_NONE);
    shader_injection.tone_map_type = tone_map_type_setting->parse(tone_map_type_setting->GetValue());
    // Peak never below Game Brightness: the tone mappers can't map white to a lower peak.
    shader_injection.peak_white_nits = (std::max)(peak_nits_setting->GetValue(), game_nits_setting->GetValue());
    shader_injection.diffuse_white_nits = game_nits_setting->GetValue();
    shader_injection.graphics_white_nits = ui_nits_setting->GetValue();
    shader_injection.gamma_correction = gamma_correction_setting->GetValue();
  } else {
    // SDR: the Vanilla picture, with white at 1.0 in the sRGB swap chain, or at 80 nits (scRGB 1.0)
    // in the scRGB one, peak at white, and no gamma correction: the display decodes the game's image
    // itself, as in vanilla.
    const float sdr_white_nits = (is_hdr10 ? 1.f : 80.f);
    shader_injection.swap_chain_output_preset = (is_hdr10 ? SWAP_CHAIN_OUTPUT_PRESET_SDR : SWAP_CHAIN_OUTPUT_PRESET_NONE);
    shader_injection.tone_map_type = TONE_MAP_VANILLA;
    shader_injection.peak_white_nits = sdr_white_nits;
    shader_injection.diffuse_white_nits = sdr_white_nits;
    shader_injection.graphics_white_nits = sdr_white_nits;
    shader_injection.gamma_correction = 0.f;
  }

  const PsychoMatch match = PsychoMatchFor(
      shader_injection.peak_white_nits / (std::max)(shader_injection.diffuse_white_nits, 1.f));
  shader_injection.psycho_shadows_match = match.shadows;
  shader_injection.psycho_highlights_match = match.highlights;
}

// The proxy's DXGI swap chain and the colour space last set on it, kept on Output Mode in OnPresent.
reshade::api::swapchain* proxy_swapchain = nullptr;
reshade::api::color_space proxy_color_space = reshade::api::color_space::unknown;

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!renodx::utils::swapchain::IsDXGI(swapchain)) return;
  // A new or resized proxy swap chain starts in the HDR Format's colour space: set it again.
  proxy_color_space = reshade::api::color_space::unknown;
  if (fired_on_init_swapchain) return;

  // Output Mode starts on what Windows shows: SDR when its HDR is off or unsupported. It can still be
  // switched during the session.
  const auto display_info = renodx::utils::swapchain::GetDisplayInfo(swapchain);
  const bool windows_hdr = (display_info.hdr_supported && display_info.hdr_enabled);
  output_mode_setting->Set(windows_hdr ? OUTPUT_MODE_HDR : OUTPUT_MODE_SDR);
  peak_nits_setting->default_value = std::round(display_info.peak_nits);

  fired_on_init_swapchain = true;
}

// The render target the game last bound, kept across presents, for the orphaned clone in OnPresent.
reshade::api::resource_view last_render_target = {0u};

#if SCCT_DEV_TOOLS

// ---------------------------------------------------------------------------
// Development tools: frame trace, draw probe and shader dump (see the file header).
// ---------------------------------------------------------------------------

struct BlendState {
  bool enable = false;
  uint32_t source_factor = static_cast<uint32_t>(reshade::api::blend_factor::one);
  uint32_t dest_factor = static_cast<uint32_t>(reshade::api::blend_factor::zero);
};

BlendState blend_state;

bool trace_active = false;
bool trace_armed = false;
uint64_t game_frame = 0;  // D3D9 presents
uint32_t trace_draw_index = 0;

// Shader hash -> "ps_<major>_<minor>" or "vs_<major>_<minor>", filled the first time a shader is drawn.
std::unordered_map<uint32_t, std::string> shader_versions;

int probe_target = -1;  // candidate to hide, -1 = probe off
// Probe candidates (F7 cycles): blended draws, every draw, or HUD draws only (after the frame's
// boundary draw: the composite or a vision pass's final draw).
enum class ProbeMode : uint8_t {
  BLENDED,
  ALL,
  HUD,
};
constexpr const char* PROBE_MODE_NAMES[] = {"blended draws", "all draws", "HUD draws"};
ProbeMode probe_mode = ProbeMode::BLENDED;
bool after_boundary = false;  // the boundary draw has run in this frame
// The last scene draw of a frame, per view: the composite, or a vision pass's final draw.
constexpr uint32_t BOUNDARY_SHADER_HASHES[] = {0x83A4F799u, 0x4ADA0B05u, 0xC294F957u, 0x7CE55E3Eu};
int candidate_index = 0;
int candidate_count = 0;  // last frame
std::string probe_info;
bool probe_found = false;
int probe_logged_target = -1;
ProbeMode probe_logged_mode = ProbeMode::BLENDED;

void Log(const std::string& message) {
  reshade::log::message(reshade::log::level::info, message.c_str());
}

std::string Describe(reshade::api::device* device, reshade::api::resource resource) {
  std::stringstream s;
  s << "0x" << std::hex << resource.handle << std::dec;
  if (resource.handle == 0u) return s.str();
  const auto desc = device->get_resource_desc(resource);
  s << " " << desc.texture.width << "x" << desc.texture.height << " fmt=" << static_cast<uint32_t>(desc.texture.format);
  renodx::utils::resource::GetResourceInfo(resource, [&](const renodx::utils::resource::ResourceInfo& info) {
    if (info.is_swap_chain) {
      s << " SWAPCHAIN";
    }
    if (info.clone.handle != 0u) {
      s << " clone=0x" << std::hex << info.clone.handle << std::dec << (info.clone_enabled ? "(on)" : "(off)");
    }
  });
  return s.str();
}

std::string DescribeView(reshade::api::device* device, reshade::api::resource_view view) {
  if (view.handle == 0u) return "null";
  std::string description = Describe(device, device->get_resource_from_view(view));
  // A D3D9 render target view is a surface; name the texture it belongs to, if any.
  if (device->get_api() == reshade::api::device_api::d3d9) {
    auto* surface = reinterpret_cast<IDirect3DSurface9*>(view.handle);
    IDirect3DTexture9* texture = nullptr;
    if (SUCCEEDED(surface->GetContainer(__uuidof(IDirect3DTexture9), reinterpret_cast<void**>(&texture))) && texture != nullptr) {
      std::stringstream s;
      s << " surface-of=0x" << std::hex << reinterpret_cast<uintptr_t>(texture) << std::dec;
      description += s.str();
      texture->Release();
    }
  }
  return description;
}

// Shader model of the bound pixel or vertex shader, read from its bytecode. The first time a hash is
// seen, it is logged and its bytecode saved to scct-dumps for disassembly.
std::string ShaderVersion(IDirect3DDevice9* native_device, bool is_vertex_shader, uint32_t shader_hash) {
  if (shader_hash == 0u) return "none";
  if (auto it = shader_versions.find(shader_hash); it != shader_versions.end()) {
    return it->second;
  }
  const char* prefix = (is_vertex_shader ? "vs" : "ps");
  std::vector<uint8_t> bytecode;
  const auto read_bytecode = [&](auto* shader) {
    if (shader == nullptr) return;
    UINT size = 0;
    if (SUCCEEDED(shader->GetFunction(nullptr, &size)) && size >= sizeof(DWORD)) {
      bytecode.resize(size);
      if (FAILED(shader->GetFunction(bytecode.data(), &size))) {
        bytecode.clear();
      }
    }
    shader->Release();
  };
  if (is_vertex_shader) {
    IDirect3DVertexShader9* vertex_shader = nullptr;
    native_device->GetVertexShader(&vertex_shader);
    read_bytecode(vertex_shader);
  } else {
    IDirect3DPixelShader9* pixel_shader = nullptr;
    native_device->GetPixelShader(&pixel_shader);
    read_bytecode(pixel_shader);
  }
  std::string version_name = std::string(prefix) + "_?";
  if (!bytecode.empty()) {
    DWORD version = 0;
    std::memcpy(&version, bytecode.data(), sizeof(version));  // 0xFFFE0000 (vs) or 0xFFFF0000 (ps) | major << 8 | minor
    const auto major = static_cast<unsigned>((version >> 8) & 0xFFu);
    const auto minor = static_cast<unsigned>(version & 0xFFu);
    version_name = std::string(prefix) + "_" + std::to_string(major) + "_" + std::to_string(minor);
    char file_name[64];
    std::snprintf(file_name, sizeof(file_name), "0x%08X.%s_%u_%u.cso", shader_hash, prefix, major, minor);
    std::error_code error;
    std::filesystem::create_directories("scct-dumps", error);
    std::ofstream file(std::filesystem::path("scct-dumps") / file_name, std::ios::binary);
    file.write(reinterpret_cast<const char*>(bytecode.data()), static_cast<std::streamsize>(bytecode.size()));
    std::stringstream s;
    s << "[scct-shader] " << prefix << "=0x" << std::hex << shader_hash << std::dec << " " << version_name
      << " dumped scct-dumps\\" << file_name;
    Log(s.str());
  }
  shader_versions.emplace(shader_hash, version_name);
  return version_name;
}

void OnBindPipelineStates(reshade::api::command_list* cmd_list, uint32_t count,
                          const reshade::api::dynamic_state* states, const uint32_t* values) {
  for (uint32_t i = 0; i < count; ++i) {
    switch (states[i]) {
      case reshade::api::dynamic_state::blend_enable:
        blend_state.enable = (values[i] != 0u);
        break;
      case reshade::api::dynamic_state::source_color_blend_factor:
        blend_state.source_factor = values[i];
        break;
      case reshade::api::dynamic_state::dest_color_blend_factor:
        blend_state.dest_factor = values[i];
        break;
      default:
        break;
    }
  }
}

// Called before every draw. Returns true to hide it (probe selection).
bool OnBeforeDraw(reshade::api::command_list* cmd_list, uint32_t count) {
  auto* device = cmd_list->get_device();
  if (device->get_api() != reshade::api::device_api::d3d9) return false;
  auto* native_device = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
  const uint32_t pixel_shader_hash = renodx::utils::state::GetCurrentShaderHash(
      cmd_list, reshade::api::pipeline_stage::pixel_shader);
  const uint32_t vertex_shader_hash = renodx::utils::state::GetCurrentShaderHash(
      cmd_list, reshade::api::pipeline_stage::vertex_shader);

  auto describe_draw = [&]() {
    std::stringstream s;
    s << "ps=0x" << std::hex << pixel_shader_hash << std::dec << " " << ShaderVersion(native_device, false, pixel_shader_hash)
      << " vs=0x" << std::hex << vertex_shader_hash << std::dec << " " << ShaderVersion(native_device, true, vertex_shader_hash)
      << " count=" << count;
    // Fixed-function vertices (no vertex shader) are described by the FVF code; shader input by the
    // vertex declaration's usages (D3DDECLUSAGE: 0 position, 5 texcoord, 9 positiont, 10 color).
    DWORD fvf = 0;
    native_device->GetFVF(&fvf);
    s << " fvf=0x" << std::hex << fvf << std::dec;
    IDirect3DVertexDeclaration9* declaration = nullptr;
    if (SUCCEEDED(native_device->GetVertexDeclaration(&declaration)) && declaration != nullptr) {
      D3DVERTEXELEMENT9 elements[MAXD3DDECLLENGTH + 1] = {};
      UINT element_count = 0;
      if (SUCCEEDED(declaration->GetDeclaration(elements, &element_count))) {
        s << " decl=";
        for (UINT element = 0; element + 1 < element_count; ++element) {
          s << static_cast<unsigned>(elements[element].Usage) << "." << static_cast<unsigned>(elements[element].UsageIndex)
            << ":t" << static_cast<unsigned>(elements[element].Type) << "@" << elements[element].Offset << " ";
        }
      }
      declaration->Release();
    }
    if (blend_state.enable) {
      s << " blend=on src=" << blend_state.source_factor << " dst=" << blend_state.dest_factor;
    } else {
      s << " blend=off";
    }
    // The textures on stages 0-3: size and D3DFORMAT. A float format here (113 = A16B16G16R16F,
    // 116 = A32B32G32R32F) is the game's HDR buffer being read, usually by the tonemapper.
    for (DWORD stage = 0; stage < 4; ++stage) {
      IDirect3DBaseTexture9* base_texture = nullptr;
      if (FAILED(native_device->GetTexture(stage, &base_texture)) || base_texture == nullptr) continue;
      if (base_texture->GetType() == D3DRTYPE_TEXTURE) {
        D3DSURFACE_DESC desc = {};
        if (SUCCEEDED(static_cast<IDirect3DTexture9*>(base_texture)->GetLevelDesc(0, &desc))) {
          s << " tex" << stage << "=" << desc.Width << "x" << desc.Height << " d3dfmt" << stage << "="
            << static_cast<uint32_t>(desc.Format) << (((desc.Usage & D3DUSAGE_RENDERTARGET) != 0u) ? " rt" : "");
        }
      } else {
        s << " tex" << stage << "=type" << static_cast<uint32_t>(base_texture->GetType());
      }
      base_texture->Release();
    }
    return s.str();
  };

  if (trace_active) {
    Log("[scct-trace] draw " + std::to_string(trace_draw_index++) + " " + describe_draw());
  } else {
    // Logs and dumps shaders seen for the first time.
    ShaderVersion(native_device, false, pixel_shader_hash);
    ShaderVersion(native_device, true, vertex_shader_hash);
  }

  const bool is_hud_draw = after_boundary;
  if (std::ranges::find(BOUNDARY_SHADER_HASHES, pixel_shader_hash) != std::end(BOUNDARY_SHADER_HASHES)) {
    after_boundary = true;
  }

  if (probe_target < 0) return false;
  if (probe_mode == ProbeMode::BLENDED && !blend_state.enable) return false;
  if (probe_mode == ProbeMode::HUD && !is_hud_draw) return false;
  const bool selected = (candidate_index == probe_target);
  ++candidate_index;
  if (!selected) return false;
  probe_info = describe_draw();
  probe_found = true;
  return true;
}

bool OnDraw(reshade::api::command_list* cmd_list, uint32_t vertex_count, uint32_t instance_count, uint32_t first_vertex,
            uint32_t first_instance) {
  return OnBeforeDraw(cmd_list, vertex_count);
}

bool OnDrawIndexed(reshade::api::command_list* cmd_list, uint32_t index_count, uint32_t instance_count, uint32_t first_index,
                   int32_t vertex_offset, uint32_t first_instance) {
  return OnBeforeDraw(cmd_list, index_count);
}

bool OnClearRenderTarget(reshade::api::command_list* cmd_list, reshade::api::resource_view rtv,
                         const float color[4], uint32_t rect_count, const reshade::api::rect* rects) {
  if (trace_active) {
    Log("[scct-trace] clear_rt " + DescribeView(cmd_list->get_device(), rtv));
  }
  return false;
}

bool OnResolve(reshade::api::command_list* cmd_list, reshade::api::resource source, uint32_t source_subresource,
               const reshade::api::subresource_box* source_box, reshade::api::resource dest, uint32_t dest_subresource,
               uint32_t dest_x, uint32_t dest_y, uint32_t dest_z, reshade::api::format format) {
  if (trace_active) {
    auto* device = cmd_list->get_device();
    Log("[scct-trace] resolve " + Describe(device, source) + " -> " + Describe(device, dest));
  }
  return false;
}

// CPU writes (LockRect, UpdateSurface / UpdateTexture). Bink videos lock a screen-size dynamic
// texture each frame. F10 doesn't reach ReShade while a video plays.
void OnMapTextureRegion(reshade::api::device* device, reshade::api::resource resource, uint32_t subresource,
                        const reshade::api::subresource_box* box, reshade::api::map_access access,
                        reshade::api::subresource_data* data) {
  if (trace_active) {
    Log("[scct-trace] map " + Describe(device, resource) + " sub " + std::to_string(subresource) + " access "
        + std::to_string(static_cast<int>(access)));
  }
}

bool OnUpdateTextureRegion(reshade::api::device* device, const reshade::api::subresource_data& data,
                           reshade::api::resource resource, uint32_t subresource, const reshade::api::subresource_box* box) {
  if (trace_active) {
    Log("[scct-trace] update " + Describe(device, resource) + " sub " + std::to_string(subresource));
  }
  return false;
}

void OnReshadePresent(reshade::api::effect_runtime* runtime) {
  // With the proxy, both the game's D3D9 runtime and the DX11 one may get here, and only one of
  // them may: handle the keys once per game frame, whichever runtime comes first.
  static uint64_t keys_frame = ~0ull;
  if (keys_frame == game_frame) return;
  keys_frame = game_frame;
  if (runtime->is_key_pressed(VK_F10) && !trace_active) {
    trace_armed = true;
    Log("[scct-trace] trace armed for next frame");
  }
  if (runtime->is_key_pressed(VK_F9)) {
    probe_target = ((probe_target >= 0 && probe_target + 1 >= candidate_count) ? 0 : (probe_target + 1));
  }
  if (runtime->is_key_pressed(VK_F8) && probe_target >= 0) {
    --probe_target;
  }
  if (runtime->is_key_pressed(VK_F7)) {
    probe_mode = static_cast<ProbeMode>((static_cast<int>(probe_mode) + 1) % 3);
    // Restart at the first candidate; -1 (probe off) stays off.
    probe_target = (std::min)(probe_target, 0);
  }
}

void OnOverlay(reshade::api::effect_runtime* runtime) {
  if (probe_target < 0) return;
  ImGui::SetNextWindowPos(ImVec2(20.f, 400.f), ImGuiCond_Always);
  ImGui::SetNextWindowBgAlpha(0.75f);
  constexpr ImGuiWindowFlags window_flags = ImGuiWindowFlags_NoDecoration | ImGuiWindowFlags_AlwaysAutoResize
                                            | ImGuiWindowFlags_NoInputs | ImGuiWindowFlags_NoSavedSettings
                                            | ImGuiWindowFlags_NoFocusOnAppearing | ImGuiWindowFlags_NoNav;
  if (ImGui::Begin("scct probe", nullptr, window_flags)) {
    ImGui::Text("Probe: draw %d of %d hidden (%s)", probe_target, candidate_count,
                PROBE_MODE_NAMES[static_cast<int>(probe_mode)]);
    ImGui::TextUnformatted(probe_info.c_str());
    ImGui::TextUnformatted("F9 next   F8 previous / off   F7 blended / all / HUD");
  }
  ImGui::End();
}

// Crash report. The game sometimes ends with "This application has requested the Runtime to
// terminate it in an unusual way" (abort or an uncaught C++ exception). Both handlers below belong
// to this add-on's runtime library, so they only fire when the add-on's code is the one that
// aborts; they write the exception and the call stack (module + offset) to ReShade.log first.
void LogCallStack() {
  void* frames[48] = {};
  const USHORT count = CaptureStackBackTrace(1, 48, frames, nullptr);
  for (USHORT i = 0; i < count; ++i) {
    HMODULE module = nullptr;
    char module_name[MAX_PATH] = "?";
    if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                           static_cast<LPCSTR>(frames[i]), &module)
            != FALSE
        && module != nullptr) {
      GetModuleFileNameA(module, module_name, MAX_PATH);
    }
    const auto offset = reinterpret_cast<uintptr_t>(frames[i]) - reinterpret_cast<uintptr_t>(module);
    std::stringstream s;
    s << "[scct-crash]   #" << i << " " << std::filesystem::path(module_name).filename().string()
      << "+0x" << std::hex << offset;
    reshade::log::message(reshade::log::level::error, s.str().c_str());
  }
}

void OnTerminate() {
  std::string what = "(no active exception)";
  if (auto exception = std::current_exception()) {
    try {
      std::rethrow_exception(exception);
    } catch (const std::exception& e) {
      what = std::string("std::exception: ") + e.what();
    } catch (...) {
      what = "non-std exception";
    }
  }
  reshade::log::message(reshade::log::level::error, ("[scct-crash] std::terminate: " + what).c_str());
  LogCallStack();
  std::abort();
}

void OnAbortSignal(int signal) {
  reshade::log::message(reshade::log::level::error, "[scct-crash] abort() called");
  LogCallStack();
}

#endif  // SCCT_DEV_TOOLS

// ---------------------------------------------------------------------------
// Night Vision HDR. Night vision is built from the composite's 8-bit copy and clamped at
// every step, so it stays at or below white. With the toggle on, its image draw (0x4ADA0B05) runs
// with night_vision_hdr_pixel_shader instead, which raises what it clipped (see the shader). That
// is a ps_3_0, which only runs with a vs_3_0, so the draw also gets night_vision_vertex_shader, a
// port of the game's. The game's shaders, c8 and the glows' filters are put back once it has
// drawn: D3D9 state stays set for later draws. With the toggle off, or if the shaders can't be
// created, the game's own shaders draw it.
// ---------------------------------------------------------------------------

constexpr UINT NIGHT_VISION_GLOW_SIZES_REGISTER = 8;
// The glows the shader upsamples; its cubic upsampling is built on bilinear taps.
constexpr DWORD NIGHT_VISION_GLOW_STAGES[] = {1, 2};

struct NightVisionShaders {
  IDirect3DDevice9* device = nullptr;
  IDirect3DVertexShader9* vertex_shader = nullptr;
  IDirect3DPixelShader9* pixel_shader = nullptr;
};
NightVisionShaders night_vision_shaders;

struct NightVisionSavedState {
  bool saved = false;
  IDirect3DVertexShader9* vertex_shader = nullptr;
  IDirect3DPixelShader9* pixel_shader = nullptr;
  float glow_sizes[4] = {};
  DWORD glow_filters[std::size(NIGHT_VISION_GLOW_STAGES)][2] = {};
};
NightVisionSavedState night_vision_saved_state;

void ReleaseNightVisionShaders() {
  if (night_vision_shaders.vertex_shader != nullptr) {
    night_vision_shaders.vertex_shader->Release();
  }
  if (night_vision_shaders.pixel_shader != nullptr) {
    night_vision_shaders.pixel_shader->Release();
  }
  night_vision_shaders = {};
}

bool OnNightVisionImageDraw(reshade::api::command_list* cmd_list) {
  if (night_vision_hdr == 0.f || !IsHDR()) return true;
  auto* native_device = reinterpret_cast<IDirect3DDevice9*>(cmd_list->get_device()->get_native());
  if (night_vision_shaders.device != native_device) {
    ReleaseNightVisionShaders();
    night_vision_shaders.device = native_device;
    const bool created =
        SUCCEEDED(native_device->CreateVertexShader(reinterpret_cast<const DWORD*>(__night_vision_vertex_shader.data()),
                                                    &night_vision_shaders.vertex_shader))
        && SUCCEEDED(native_device->CreatePixelShader(reinterpret_cast<const DWORD*>(__night_vision_hdr_pixel_shader.data()),
                                                      &night_vision_shaders.pixel_shader));
    if (!created) {
      reshade::log::message(reshade::log::level::warning, "[scct] Night Vision HDR: could not create its shaders");
      ReleaseNightVisionShaders();
      // Kept, so creation isn't retried every frame on this device.
      night_vision_shaders.device = native_device;
    }
  }
  if (night_vision_shaders.pixel_shader == nullptr) return true;

  auto& saved = night_vision_saved_state;
  native_device->GetVertexShader(&saved.vertex_shader);
  native_device->GetPixelShader(&saved.pixel_shader);
  native_device->GetPixelShaderConstantF(NIGHT_VISION_GLOW_SIZES_REGISTER, saved.glow_sizes, 1);
  float glow_sizes[4] = {1.f, 1.f, 1.f, 1.f};
  for (size_t index = 0; index < std::size(NIGHT_VISION_GLOW_STAGES); ++index) {
    const DWORD stage = NIGHT_VISION_GLOW_STAGES[index];
    native_device->GetSamplerState(stage, D3DSAMP_MAGFILTER, &saved.glow_filters[index][0]);
    native_device->GetSamplerState(stage, D3DSAMP_MINFILTER, &saved.glow_filters[index][1]);
    native_device->SetSamplerState(stage, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
    native_device->SetSamplerState(stage, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
    IDirect3DBaseTexture9* glow = nullptr;
    if (SUCCEEDED(native_device->GetTexture(stage, &glow)) && glow != nullptr) {
      D3DSURFACE_DESC glow_desc = {};
      if (glow->GetType() == D3DRTYPE_TEXTURE && SUCCEEDED(static_cast<IDirect3DTexture9*>(glow)->GetLevelDesc(0, &glow_desc))) {
        glow_sizes[2 * index] = static_cast<float>(glow_desc.Width);
        glow_sizes[(2 * index) + 1] = static_cast<float>(glow_desc.Height);
      }
      glow->Release();
    }
  }
  native_device->SetPixelShaderConstantF(NIGHT_VISION_GLOW_SIZES_REGISTER, glow_sizes, 1);
  native_device->SetVertexShader(night_vision_shaders.vertex_shader);
  native_device->SetPixelShader(night_vision_shaders.pixel_shader);
  saved.saved = true;
  return true;
}

void OnNightVisionImageDrawn(reshade::api::command_list* cmd_list) {
  auto& saved = night_vision_saved_state;
  if (!saved.saved) return;
  auto* native_device = reinterpret_cast<IDirect3DDevice9*>(cmd_list->get_device()->get_native());
  native_device->SetVertexShader(saved.vertex_shader);
  native_device->SetPixelShader(saved.pixel_shader);
  if (saved.vertex_shader != nullptr) {
    saved.vertex_shader->Release();
  }
  if (saved.pixel_shader != nullptr) {
    saved.pixel_shader->Release();
  }
  native_device->SetPixelShaderConstantF(NIGHT_VISION_GLOW_SIZES_REGISTER, saved.glow_sizes, 1);
  for (size_t index = 0; index < std::size(NIGHT_VISION_GLOW_STAGES); ++index) {
    native_device->SetSamplerState(NIGHT_VISION_GLOW_STAGES[index], D3DSAMP_MAGFILTER, saved.glow_filters[index][0]);
    native_device->SetSamplerState(NIGHT_VISION_GLOW_STAGES[index], D3DSAMP_MINFILTER, saved.glow_filters[index][1]);
  }
  night_vision_saved_state = {};
}

// ---------------------------------------------------------------------------
// Old D3D9 devices. Exiting from gameplay to the main menu, or loading a save, sometimes leaks the
// game's D3D9 device: it is never destroyed, so the proxy stays bound to it and the new device's
// frames never reach the screen (frozen picture). When a D3D9 device starts while an older one is
// still alive, the proxy's own teardown is run for the old one; it binds to the new one at its next
// present. Whatever the old device still holds stays leaked.
// ---------------------------------------------------------------------------

struct TrackedDevice {
  reshade::api::device* device = nullptr;
  IDirect3DDevice9* native = nullptr;
};
std::vector<TrackedDevice> live_d3d9_devices;

void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::d3d9) return;
  for (const auto& old_device : live_d3d9_devices) {
    if (old_device.device == device) continue;
    const bool proxy_bound = (renodx::utils::device_proxy::proxied_device_reshade == old_device.device);
#if SCCT_DEV_TOOLS
    // What is still alive on the old device. Only the device's refcount is peeked: a resource
    // RenoDX still tracks may already be freed.
    old_device.native->AddRef();
    const ULONG native_refcount = old_device.native->Release();
    std::stringstream s;
    s << "[scct-leak] device 0x" << std::hex << reinterpret_cast<uintptr_t>(old_device.device) << std::dec
      << " still alive, native refcount " << native_refcount << ", proxy bound to it: " << (proxy_bound ? "yes" : "no")
      << ", proxy shared pairs: " << renodx::utils::device_proxy::proxy_shared_resources_by_clone.size();
    Log(s.str());
    int alive = 0;
    renodx::utils::resource::ForEachResourceInfo([&](const renodx::utils::resource::ResourceInfo& info) {
      if (info.device != old_device.device || info.destroyed) return;
      if (++alive > 60) return;
      std::stringstream r;
      r << "[scct-leak]   0x" << std::hex << info.resource.handle << std::dec << " type=" << static_cast<uint32_t>(info.desc.type)
        << " " << info.desc.texture.width << "x" << info.desc.texture.height << " fmt=" << static_cast<uint32_t>(info.desc.texture.format)
        << " usage=0x" << std::hex << static_cast<uint32_t>(info.desc.usage) << " heap=" << static_cast<uint32_t>(info.desc.heap) << std::dec
        << (info.is_clone ? " CLONE" : "") << (info.is_swap_chain ? " SWAPCHAIN" : "")
        << (info.shared_handle != nullptr ? " SHARED" : "") << (info.upgraded ? " UPGRADED" : "");
      if (info.clone.handle != 0u) {
        r << " clone=0x" << std::hex << info.clone.handle << std::dec;
      }
      if (info.proxy_resource.handle != 0u) {
        r << " proxy_resource=0x" << std::hex << info.proxy_resource.handle << std::dec;
      }
      Log(r.str());
    });
    Log("[scct-leak]   " + std::to_string(alive) + " tracked resources still alive on it");
    for (const auto& [clone_handle, pair] : renodx::utils::device_proxy::proxy_shared_resources_by_clone) {
      std::stringstream p;
      p << "[scct-leak]   shared pair for clone 0x" << std::hex << clone_handle << ": host 0x"
        << pair.host_shared_resource.handle << " proxy 0x" << pair.proxy_shared_resource.handle << std::dec;
      Log(p.str());
    }
#endif
    if (proxy_bound) {
      reshade::log::message(reshade::log::level::warning, "[scct] old D3D9 device still alive: releasing the proxy from it");
      renodx::utils::device_proxy::OnDestroyDevice(old_device.device);
    }
  }
  std::erase_if(live_d3d9_devices, [device](const TrackedDevice& tracked) { return tracked.device != device; });
  live_d3d9_devices.push_back({
      .device = device,
      .native = reinterpret_cast<IDirect3DDevice9*>(device->get_native()),
  });
}

void OnDestroyDevice(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::d3d9) return;
  last_render_target = {0u};
  if (night_vision_shaders.device == reinterpret_cast<IDirect3DDevice9*>(device->get_native())) {
    ReleaseNightVisionShaders();
  }
  std::erase_if(live_d3d9_devices, [device](const TrackedDevice& tracked) { return tracked.device == device; });
}

// ---------------------------------------------------------------------------
// Copy redirect. With the DX11 proxy, draws to the back buffer go to its RGBA16F clone, but the
// game's StretchRect copies from it (night vision, thermal and EMF copy the finished image to
// process it) would still read the 8-bit original. Copies whose source or destination has an
// active clone are done on the clone.
// ---------------------------------------------------------------------------

bool Copy(reshade::api::command_list* cmd_list,
          reshade::api::resource source, uint32_t source_subresource, const reshade::api::subresource_box* source_box,
          reshade::api::resource dest, uint32_t dest_subresource, const reshade::api::subresource_box* dest_box,
          D3DTEXTUREFILTERTYPE filter) {
  auto* device = cmd_list->get_device();
  if (device->get_api() != reshade::api::device_api::d3d9) return false;

  auto active_clone = [](reshade::api::resource resource) {
    reshade::api::resource clone = {0u};
    if (resource.handle == 0u) return clone;
    renodx::utils::resource::GetResourceInfo(resource, [&](const renodx::utils::resource::ResourceInfo& info) {
      if (info.clone_enabled && info.clone.handle != 0u) {
        clone = info.clone;
      }
    });
    return clone;
  };
  // Returns an AddRef'd surface for a D3D9 surface or texture handle, or nullptr.
  auto get_surface = [](reshade::api::resource resource, uint32_t subresource) -> IDirect3DSurface9* {
    auto* native_resource = reinterpret_cast<IDirect3DResource9*>(resource.handle);
    if (native_resource == nullptr) return nullptr;
    switch (native_resource->GetType()) {
      case D3DRTYPE_SURFACE: {
        auto* surface = static_cast<IDirect3DSurface9*>(native_resource);
        surface->AddRef();
        return surface;
      }
      case D3DRTYPE_TEXTURE: {
        IDirect3DSurface9* surface = nullptr;
        if (FAILED(static_cast<IDirect3DTexture9*>(native_resource)->GetSurfaceLevel(subresource, &surface))) return nullptr;
        return surface;
      }
      default:
        return nullptr;
    }
  };
  auto to_rect = [](const reshade::api::subresource_box& box) {
    return RECT{
        .left = static_cast<LONG>(box.left),
        .top = static_cast<LONG>(box.top),
        .right = static_cast<LONG>(box.right),
        .bottom = static_cast<LONG>(box.bottom),
    };
  };

  const auto source_clone = active_clone(source);
  const auto dest_clone = active_clone(dest);
  if (source_clone.handle == 0u && dest_clone.handle == 0u) return false;

  auto* source_surface = get_surface((source_clone.handle != 0u) ? source_clone : source, source_subresource);
  auto* dest_surface = get_surface((dest_clone.handle != 0u) ? dest_clone : dest, dest_subresource);
  bool handled = false;
  if (source_surface != nullptr && dest_surface != nullptr) {
    const RECT source_rect = ((source_box != nullptr) ? to_rect(*source_box) : RECT{});
    const RECT dest_rect = ((dest_box != nullptr) ? to_rect(*dest_box) : RECT{});
    auto* native_device = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
    handled = SUCCEEDED(native_device->StretchRect(
        source_surface, (source_box != nullptr) ? &source_rect : nullptr,
        dest_surface, (dest_box != nullptr) ? &dest_rect : nullptr,
        filter));
    if (!handled) {
      reshade::log::message(reshade::log::level::warning, "[scct] copy redirect: StretchRect failed");
    }
  }
  if (source_surface != nullptr) {
    source_surface->Release();
  }
  if (dest_surface != nullptr) {
    dest_surface->Release();
  }
  return handled;  // true: the original 8-bit copy is skipped
}

bool OnCopyTextureRegion(reshade::api::command_list* cmd_list, reshade::api::resource source, uint32_t source_subresource,
                         const reshade::api::subresource_box* source_box, reshade::api::resource dest, uint32_t dest_subresource,
                         const reshade::api::subresource_box* dest_box, reshade::api::filter_mode filter) {
#if SCCT_DEV_TOOLS
  if (trace_active) {
    auto* device = cmd_list->get_device();
    Log("[scct-trace] copy " + Describe(device, source) + " -> " + Describe(device, dest));
  }
#endif
  D3DTEXTUREFILTERTYPE d3d_filter = D3DTEXF_NONE;
  switch (filter) {
    case reshade::api::filter_mode::min_mag_mip_point:
      d3d_filter = D3DTEXF_POINT;
      break;
    case reshade::api::filter_mode::min_mag_mip_linear:
    case reshade::api::filter_mode::min_mag_linear_mip_point:
      d3d_filter = D3DTEXF_LINEAR;
      break;
    default:
      break;
  }
  return Copy(cmd_list, source, source_subresource, source_box, dest, dest_subresource, dest_box, d3d_filter);
}

bool OnCopyResource(reshade::api::command_list* cmd_list, reshade::api::resource source, reshade::api::resource dest) {
#if SCCT_DEV_TOOLS
  if (trace_active) {
    auto* device = cmd_list->get_device();
    Log("[scct-trace] copy " + Describe(device, source) + " -> " + Describe(device, dest));
  }
#endif
  return Copy(cmd_list, source, 0, nullptr, dest, 0, nullptr, D3DTEXF_NONE);
}

void OnBindRenderTargets(reshade::api::command_list* cmd_list, uint32_t count,
                         const reshade::api::resource_view* rtvs, reshade::api::resource_view dsv) {
  if (count > 0 && cmd_list->get_device()->get_api() == reshade::api::device_api::d3d9) {
    last_render_target = rtvs[0];
  }
#if SCCT_DEV_TOOLS
  if (!trace_active) return;
  for (uint32_t i = 0; i < count; ++i) {
    Log("[scct-trace] bind_rt[" + std::to_string(i) + "] " + DescribeView(cmd_list->get_device(), rtvs[i]));
  }
#endif
}

void OnPresent(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain, const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect, uint32_t dirty_rect_count, const reshade::api::rect* dirty_rects) {
  auto* device = queue->get_device();
  // The DX11 proxy presents too. Its swap chain's colour space follows Output Mode: HDR10 or sRGB
  // for SDR on an HDR10 swap chain; an scRGB swap chain stays scRGB.
  if (device->get_api() != reshade::api::device_api::d3d9) {
    reshade::api::color_space color_space = reshade::api::color_space::extended_srgb_linear;
    if (renodx::mods::swapchain::target_format == reshade::api::format::r10g10b10a2_unorm) {
      color_space = (IsHDR() ? reshade::api::color_space::hdr10_st2084 : reshade::api::color_space::srgb_nonlinear);
    }
    if (swapchain != proxy_swapchain || color_space != proxy_color_space) {
      renodx::utils::swapchain::ChangeColorSpace(swapchain, color_space);
      proxy_swapchain = swapchain;
      proxy_color_space = color_space;
    }
    return;
  }

  UpdateOutput();

  // Orphaned back buffer clone: the game keeps drawing into the proxy's first clone of
  // the back buffer after the proxy replaced it. The full-size RGBA16F target it last bound, if it
  // is not the current clone, is copied into the current one.
  const auto drawn_view = last_render_target;
  if (drawn_view.handle != 0u) {
    const auto back_buffer = swapchain->get_current_back_buffer();
    reshade::api::resource clone = {0u};
    renodx::utils::resource::GetResourceInfo(back_buffer, [&](const renodx::utils::resource::ResourceInfo& info) {
      if (info.clone_enabled) {
        clone = info.clone;
      }
    });
    const auto drawn = device->get_resource_from_view(drawn_view);
    const auto drawn_desc = device->get_resource_desc(drawn);
    const auto back_buffer_desc = device->get_resource_desc(back_buffer);
    const bool orphaned = clone.handle != 0u && drawn.handle != back_buffer.handle && drawn.handle != clone.handle
                          && drawn_desc.texture.format == reshade::api::format::r16g16b16a16_float
                          && drawn_desc.texture.width == back_buffer_desc.texture.width
                          && drawn_desc.texture.height == back_buffer_desc.texture.height;
    auto* clone_resource = reinterpret_cast<IDirect3DResource9*>(clone.handle);
    // A D3D9 render target view is the surface itself; the clone is a texture.
    IDirect3DSurface9* dest_surface = nullptr;
    if (orphaned && clone_resource->GetType() == D3DRTYPE_TEXTURE) {
      static_cast<IDirect3DTexture9*>(clone_resource)->GetSurfaceLevel(0, &dest_surface);
    }
    if (dest_surface != nullptr) {
      auto* native_device = reinterpret_cast<IDirect3DDevice9*>(device->get_native());
      const bool copied = SUCCEEDED(native_device->StretchRect(
          reinterpret_cast<IDirect3DSurface9*>(drawn_view.handle), nullptr, dest_surface, nullptr, D3DTEXF_NONE));
      dest_surface->Release();
      static bool logged = false;
      if (!logged) {
        std::stringstream s;
        s << "[scct] orphaned back buffer clone 0x" << std::hex << drawn.handle << " -> current clone 0x" << clone.handle
          << std::dec << (copied ? ": copied at present" : ": StretchRect failed");
        reshade::log::message(copied ? reshade::log::level::info : reshade::log::level::warning, s.str().c_str());
        logged = true;
      }
    }
  }

#if SCCT_DEV_TOOLS
  ++game_frame;
  // With every trace: whether the back buffer has its RGBA16F clone (the proxy sets it up at a
  // present after the first, so the first present has none yet).
  if (trace_armed) {
    Log("[scct-trace] back buffer " + Describe(device, swapchain->get_current_back_buffer()));
  }
  if (trace_active) {
    Log("[scct-trace] present (trace end)");
    trace_active = false;
  }
  if (trace_armed) {
    trace_armed = false;
    trace_active = true;
    trace_draw_index = 0;
  }

  candidate_count = candidate_index;
  candidate_index = 0;
  if (!probe_found) {
    probe_info = "(no draw at this index this frame)";
  }
  probe_found = false;
  after_boundary = false;
  if (probe_target >= 0 && (probe_target != probe_logged_target || probe_mode != probe_logged_mode)) {
    Log("[scct-probe] #" + std::to_string(probe_target) + " of " + std::to_string(candidate_count) + " ("
        + PROBE_MODE_NAMES[static_cast<int>(probe_mode)] + ") " + probe_info);
    probe_logged_target = probe_target;
    probe_logged_mode = probe_mode;
  }
#endif
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX Splinter Cell: Chaos Theory";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

#if SCCT_DEV_TOOLS
      std::set_terminate(OnTerminate);
      std::signal(SIGABRT, OnAbortSignal);
#endif

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      // ps_3_0 composite: the injection goes in c50-c53 (see shared.h).
      renodx::mods::shader::constant_buffer_offset = 50 * 4;

      renodx::mods::swapchain::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;
      // The proxy cannot use exclusive fullscreen: borderless window sized to the monitor.
      renodx::mods::swapchain::force_borderless = true;
      renodx::mods::swapchain::prevent_full_screen = false;
      renodx::mods::swapchain::force_screen_tearing = false;
      renodx::mods::swapchain::use_resource_cloning = true;
      // The proxy sets the HDR Format's colour space on its swap chain, and OnPresent keeps it on
      // Output Mode; the game's D3D9 swap chain stays SDR.
      renodx::mods::swapchain::set_color_space = false;
      renodx::mods::swapchain::use_device_proxy = true;

      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader_dx11;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader_dx11;

      // No render target upgrades: the proxy clones the back buffer, the scene buffer is
      // already RGBA16F, and the bloom chain and the scene and vision copies stay 8-bit as in vanilla.

      // Not replaced: hooked only, for Night Vision HDR to swap in its own shaders.
      custom_shaders[0x4ADA0B05u] = {
          .crc32 = 0x4ADA0B05u,
          .on_draw = &OnNightVisionImageDraw,
          .on_drawn = &OnNightVisionImageDrawn,
      };

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargets);
      reshade::register_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
      reshade::register_event<reshade::addon_event::copy_resource>(OnCopyResource);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
#if SCCT_DEV_TOOLS
      reshade::register_event<reshade::addon_event::bind_pipeline_states>(OnBindPipelineStates);
      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTarget);
      reshade::register_event<reshade::addon_event::resolve_texture_region>(OnResolve);
      reshade::register_event<reshade::addon_event::map_texture_region>(OnMapTextureRegion);
      reshade::register_event<reshade::addon_event::update_texture_region>(OnUpdateTextureRegion);
      reshade::register_event<reshade::addon_event::reshade_present>(OnReshadePresent);
      reshade::register_event<reshade::addon_event::reshade_overlay>(OnOverlay);
#endif
      break;
    case DLL_PROCESS_DETACH:
#if SCCT_DEV_TOOLS
      reshade::unregister_event<reshade::addon_event::reshade_overlay>(OnOverlay);
      reshade::unregister_event<reshade::addon_event::reshade_present>(OnReshadePresent);
      reshade::unregister_event<reshade::addon_event::update_texture_region>(OnUpdateTextureRegion);
      reshade::unregister_event<reshade::addon_event::map_texture_region>(OnMapTextureRegion);
      reshade::unregister_event<reshade::addon_event::resolve_texture_region>(OnResolve);
      reshade::unregister_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTarget);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::bind_pipeline_states>(OnBindPipelineStates);
#endif
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_event<reshade::addon_event::copy_resource>(OnCopyResource);
      reshade::unregister_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargets);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    // The proxy's swap chain format is fixed when it is created: apply the saved HDR Format before.
    renodx::mods::swapchain::SetUseHDR10(hdr_format_setting->GetValue() == HDR_FORMAT_HDR10);
    UpdateOutput();
  }
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
