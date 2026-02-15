/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

// #define DEBUG_LEVEL_0

#include <shared_mutex>
#include <sstream>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/data.hpp"
#include "../../utils/random.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

float current_settings_mode = 0;
float current_render_reshade_before_ui = 0;

bool UsingSwapchainUpgrade() {
  return true;
}

bool UsingSwapchainUtil() {
  return (current_render_reshade_before_ui != 0.f
          || UsingSwapchainUpgrade());
}

// Helper to update resolution-based uniform variables in ReShade effects
void UpdateReshadeResolutionUniforms(reshade::api::effect_runtime* runtime, uint32_t width, uint32_t height) {
  float fwidth = static_cast<float>(width);
  float fheight = static_cast<float>(height);
  
  // Enumerate all uniform variables and update those with resolution-related source annotations
  runtime->enumerate_uniform_variables(nullptr, [fwidth, fheight](reshade::api::effect_runtime* rt, reshade::api::effect_uniform_variable variable) {
    char source[64] = {};
    if (rt->get_annotation_string_from_uniform_variable(variable, "source", source)) {
      // Update BUFFER_WIDTH uniform
      if (std::strcmp(source, "bufwidth") == 0) {
        rt->set_uniform_value_float(variable, fwidth);
      }
      // Update BUFFER_HEIGHT uniform
      else if (std::strcmp(source, "bufheight") == 0) {
        rt->set_uniform_value_float(variable, fheight);
      }
      // Update reciprocal width (1.0 / BUFFER_WIDTH)
      else if (std::strcmp(source, "rcpwidth") == 0 || std::strcmp(source, "bufwidth_rcp") == 0) {
        rt->set_uniform_value_float(variable, 1.0f / fwidth);
      }
      // Update reciprocal height (1.0 / BUFFER_HEIGHT) 
      else if (std::strcmp(source, "rcpheight") == 0 || std::strcmp(source, "bufheight_rcp") == 0) {
        rt->set_uniform_value_float(variable, 1.0f / fheight);
      }
      // Update BUFFER_RCP_WIDTH (alternative naming convention)
      else if (std::strcmp(source, "buffer_rcp_width") == 0) {
        rt->set_uniform_value_float(variable, 1.0f / fwidth);
      }
      // Update BUFFER_RCP_HEIGHT (alternative naming convention)
      else if (std::strcmp(source, "buffer_rcp_height") == 0) {
        rt->set_uniform_value_float(variable, 1.0f / fheight);
      }
      // Update pixel size (float2 with 1/width, 1/height)
      else if (std::strcmp(source, "pixelsize") == 0) {
        float pixel_size[2] = { 1.0f / fwidth, 1.0f / fheight };
        rt->set_uniform_value_float(variable, pixel_size, 2);
      }
      // Update screen size (float2 with width, height)
      else if (std::strcmp(source, "screensize") == 0) {
        float screen_size[2] = { fwidth, fheight };
        rt->set_uniform_value_float(variable, screen_size, 2);
      }
    }
  });
}

// Track the last known RTV resolution to detect resolution changes
static uint32_t last_rtv_width = 0;
static uint32_t last_rtv_height = 0;

// Flag to track if we're currently executing our bypass render
// This prevents ReShade from rendering during normal present while allowing our bypass to work
static bool bypass_render_active = false;

// Deferred Tech Test preset application (avoids crash from UpdateSetting inside on_change_value)
static int pending_tech_test_preset = -1;  // -1 = none, 0 = restore defaults, 1 = apply tech test
static float prev_tech_test_look = -1.f;   // impossible initial value forces first-frame detection

// Callback to disable effects during normal present when bypass is enabled
// This prevents double-rendering (once via bypass, once via normal present)
void OnReshadeBeginEffects(reshade::api::effect_runtime* runtime, 
                           reshade::api::command_list* cmd_list,
                           reshade::api::resource_view rtv, 
                           reshade::api::resource_view rtv_srgb) {
  // Only intercept if bypass is enabled AND we're not currently in bypass render
  // When bypass is disabled (current_render_reshade_before_ui == 0), let ReShade render normally
  if (current_render_reshade_before_ui != 0.f && !bypass_render_active) {
    runtime->set_effects_state(false);
  }
}

// Callback to re-enable effects after present (keeps effects available for bypass)
void OnReshadeFinishEffects(reshade::api::effect_runtime* runtime,
                            reshade::api::command_list* cmd_list,
                            reshade::api::resource_view rtv,
                            reshade::api::resource_view rtv_srgb) {
  // Only re-enable if bypass is enabled AND we disabled them
  if (current_render_reshade_before_ui != 0.f && !bypass_render_active) {
    runtime->set_effects_state(true);
  }
}

bool ExecuteReshadeEffects(reshade::api::command_list* cmd_list) {
  if (current_render_reshade_before_ui == 0.f) return true;
  if (!UsingSwapchainUtil()) return true;

  auto* cmd_list_data = renodx::utils::data::Get<renodx::utils::swapchain::CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return true;
  if (cmd_list_data->current_render_targets.empty()) return true;

  // Get the ORIGINAL RTV from deferred lighting - do NOT use the clone here
  // The clone is at swapchain resolution (e.g., 3840x2160) but we want to render
  // ReShade effects at the pre-upscale resolution
  auto rtv0 = cmd_list_data->current_render_targets[0];
  if (rtv0.handle == 0) return true;
  auto* device = cmd_list->get_device();
  auto* data = renodx::utils::data::Get<renodx::utils::swapchain::DeviceData>(device);
  if (data == nullptr) return true;

  // Get the render target resolution
  auto resource = device->get_resource_from_view(rtv0);
  auto resource_desc = device->get_resource_desc(resource);
  uint32_t rtv_width = resource_desc.texture.width;
  uint32_t rtv_height = resource_desc.texture.height;

  const std::shared_lock lock(data->mutex);
  for (auto* runtime : data->effect_runtimes) {
    if (rtv_width != last_rtv_width || rtv_height != last_rtv_height) {
#ifdef DEBUG_LEVEL_0
      uint32_t swapchain_width = 0, swapchain_height = 0;
      runtime->get_screenshot_width_and_height(&swapchain_width, &swapchain_height);
      
      std::stringstream ss;
      ss << "[Endfield] ExecuteReshadeEffects: Rendering at RTV=" << rtv_width << "x" << rtv_height 
         << " (Swapchain=" << swapchain_width << "x" << swapchain_height << ")";
      reshade::log::message(reshade::log::level::info, ss.str().c_str());
#endif
      
      last_rtv_width = rtv_width;
      last_rtv_height = rtv_height;
    }
    
    UpdateReshadeResolutionUniforms(runtime, rtv_width, rtv_height);
    bypass_render_active = true;
    runtime->set_effects_state(true);
    runtime->render_effects(cmd_list, rtv0, rtv0);
    bypass_render_active = false;
  }

  return true;
}

// Hotkey state tracking
bool ui_toggle_key_was_pressed = false;
int ui_toggle_hotkey = 0;
bool hotkey_input_active = false;

// Heuristic tracking for UID UI
bool is_ping_input_candidate = false;
bool is_ping_drawn = false;
bool is_uid_input_candidate = false;
uint32_t draw_call_vertex_count = 0;  // Track vertex count from draw calls (not draw_indexed)

// on_draw callback for ping/latency bar shader (0xEF07F89A)
// Only used to set is_ping_drawn flag for UID detection - latency bar icon hiding is done in vertex shader
bool OnPingDraw(reshade::api::command_list* cmd_list) {
  if (is_ping_input_candidate) {
    is_ping_drawn = true;
  } else {
    is_ping_drawn = false;
  }
  return true;
}

// on_draw callback for UID text shader (0x6B8E9049)
bool OnUIDDraw(reshade::api::command_list* cmd_list) {
  if (is_uid_input_candidate) {
    if (shader_injection.status_text_opacity < 0.5f) {
      return false; 
    }
  }
  return true;
}

// Helper function to get key name from virtual key code
std::string GetKeyName(int keycode) {
  if (keycode == 0 || keycode >= 256) return "";
  
  static const char* keyboard_keys[256] = {
    "", "Left Mouse", "Right Mouse", "Cancel", "Middle Mouse", "X1 Mouse", "X2 Mouse", "", "Backspace", "Tab", "", "", "Clear", "Enter", "", "",
    "Shift", "Control", "Alt", "Pause", "Caps Lock", "", "", "", "", "", "", "Escape", "", "", "", "",
    "Space", "Page Up", "Page Down", "End", "Home", "Left Arrow", "Up Arrow", "Right Arrow", "Down Arrow", "Select", "", "", "Print Screen", "Insert", "Delete", "Help",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "", "", "", "", "", "",
    "", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
    "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Left Windows", "Right Windows", "Apps", "", "Sleep",
    "Numpad 0", "Numpad 1", "Numpad 2", "Numpad 3", "Numpad 4", "Numpad 5", "Numpad 6", "Numpad 7", "Numpad 8", "Numpad 9", "Numpad *", "Numpad +", "", "Numpad -", "Numpad Decimal", "Numpad /",
    "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15", "F16",
    "F17", "F18", "F19", "F20", "F21", "F22", "F23", "F24", "", "", "", "", "", "", "", "",
    "Num Lock", "Scroll Lock", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
    "Left Shift", "Right Shift", "Left Control", "Right Control", "Left Menu", "Right Menu", "Browser Back", "Browser Forward", "Browser Refresh", "Browser Stop", "Browser Search", "Browser Favorites", "Browser Home", "Volume Mute", "Volume Down", "Volume Up",
    "Next Track", "Previous Track", "Media Stop", "Media Play/Pause", "Mail", "Media Select", "Launch App 1", "Launch App 2", "", "", "OEM ;", "OEM +", "OEM ,", "OEM -", "OEM .", "OEM /",
    "OEM ~", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "", "", "", "", "OEM [", "OEM \\", "OEM ]", "OEM '", "OEM 8",
    "", "", "OEM <", "", "", "", "", "", "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "Attn", "CrSel", "ExSel", "Erase EOF", "Play", "Zoom", "", "PA1", "OEM Clear", ""
  };
  
  return keyboard_keys[keycode];
}

int GetLastKeyPressedImGui() {

  struct KeyMapping {
    ImGuiKey imgui_key;
    int vk_code;
  };
  
  static const KeyMapping kKeyMappings[] = {
    // Function keys
    {ImGuiKey_F1, VK_F1}, {ImGuiKey_F2, VK_F2}, {ImGuiKey_F3, VK_F3}, {ImGuiKey_F4, VK_F4},
    {ImGuiKey_F5, VK_F5}, {ImGuiKey_F6, VK_F6}, {ImGuiKey_F7, VK_F7}, {ImGuiKey_F8, VK_F8},
    {ImGuiKey_F9, VK_F9}, {ImGuiKey_F10, VK_F10}, {ImGuiKey_F11, VK_F11}, {ImGuiKey_F12, VK_F12},
    // Navigation keys
    {ImGuiKey_Insert, VK_INSERT}, {ImGuiKey_Delete, VK_DELETE}, {ImGuiKey_Home, VK_HOME}, {ImGuiKey_End, VK_END},
    {ImGuiKey_PageUp, VK_PRIOR}, {ImGuiKey_PageDown, VK_NEXT},
    // Arrow keys
    {ImGuiKey_LeftArrow, VK_LEFT}, {ImGuiKey_RightArrow, VK_RIGHT}, {ImGuiKey_UpArrow, VK_UP}, {ImGuiKey_DownArrow, VK_DOWN},
    // Special keys
    {ImGuiKey_Backspace, VK_BACK}, {ImGuiKey_Space, VK_SPACE}, {ImGuiKey_Enter, VK_RETURN},
    {ImGuiKey_Escape, VK_ESCAPE}, {ImGuiKey_Tab, VK_TAB},
    {ImGuiKey_Pause, VK_PAUSE}, {ImGuiKey_ScrollLock, VK_SCROLL}, {ImGuiKey_PrintScreen, VK_SNAPSHOT},
    // Numpad
    {ImGuiKey_Keypad0, VK_NUMPAD0}, {ImGuiKey_Keypad1, VK_NUMPAD1}, {ImGuiKey_Keypad2, VK_NUMPAD2},
    {ImGuiKey_Keypad3, VK_NUMPAD3}, {ImGuiKey_Keypad4, VK_NUMPAD4}, {ImGuiKey_Keypad5, VK_NUMPAD5},
    {ImGuiKey_Keypad6, VK_NUMPAD6}, {ImGuiKey_Keypad7, VK_NUMPAD7}, {ImGuiKey_Keypad8, VK_NUMPAD8},
    {ImGuiKey_Keypad9, VK_NUMPAD9}, {ImGuiKey_KeypadDecimal, VK_DECIMAL},
    {ImGuiKey_KeypadDivide, VK_DIVIDE}, {ImGuiKey_KeypadMultiply, VK_MULTIPLY},
    {ImGuiKey_KeypadSubtract, VK_SUBTRACT}, {ImGuiKey_KeypadAdd, VK_ADD}, {ImGuiKey_KeypadEnter, VK_RETURN},
    // Letters
    {ImGuiKey_A, 'A'}, {ImGuiKey_B, 'B'}, {ImGuiKey_C, 'C'}, {ImGuiKey_D, 'D'}, {ImGuiKey_E, 'E'},
    {ImGuiKey_F, 'F'}, {ImGuiKey_G, 'G'}, {ImGuiKey_H, 'H'}, {ImGuiKey_I, 'I'}, {ImGuiKey_J, 'J'},
    {ImGuiKey_K, 'K'}, {ImGuiKey_L, 'L'}, {ImGuiKey_M, 'M'}, {ImGuiKey_N, 'N'}, {ImGuiKey_O, 'O'},
    {ImGuiKey_P, 'P'}, {ImGuiKey_Q, 'Q'}, {ImGuiKey_R, 'R'}, {ImGuiKey_S, 'S'}, {ImGuiKey_T, 'T'},
    {ImGuiKey_U, 'U'}, {ImGuiKey_V, 'V'}, {ImGuiKey_W, 'W'}, {ImGuiKey_X, 'X'}, {ImGuiKey_Y, 'Y'}, {ImGuiKey_Z, 'Z'},
    // Numbers
    {ImGuiKey_0, '0'}, {ImGuiKey_1, '1'}, {ImGuiKey_2, '2'}, {ImGuiKey_3, '3'}, {ImGuiKey_4, '4'},
    {ImGuiKey_5, '5'}, {ImGuiKey_6, '6'}, {ImGuiKey_7, '7'}, {ImGuiKey_8, '8'}, {ImGuiKey_9, '9'},
    // Punctuation
    {ImGuiKey_GraveAccent, VK_OEM_3}, {ImGuiKey_Minus, VK_OEM_MINUS}, {ImGuiKey_Equal, VK_OEM_PLUS},
    {ImGuiKey_LeftBracket, VK_OEM_4}, {ImGuiKey_RightBracket, VK_OEM_6}, {ImGuiKey_Backslash, VK_OEM_5},
    {ImGuiKey_Semicolon, VK_OEM_1}, {ImGuiKey_Apostrophe, VK_OEM_7},
    {ImGuiKey_Comma, VK_OEM_COMMA}, {ImGuiKey_Period, VK_OEM_PERIOD}, {ImGuiKey_Slash, VK_OEM_2},
  };
  
  for (const auto& mapping : kKeyMappings) {
    if (ImGui::IsKeyPressed(mapping.imgui_key, false)) {
      return mapping.vk_code;
    }
  }
  return 0;
}

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
        .default_value = 1.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapMethod",
        .binding = &shader_injection.reno_drt_tone_map_method,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Map Method",
        .section = "Tone Mapping",
        .tooltip = "Selects the RenoDRT curve",
        .labels = {"Reinhard", "Hermite Spline"},
        .parse = [](float value) { return value + 1.f; },
        .is_visible = []() { return false;},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = true,
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
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Scene Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "UI Gamma Correction",
        .section = "Tone Mapping",
        .labels = {"None", "2.2", "2.4"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
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
        .is_visible = []() { return false; },
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
        .is_visible = []() { return false; },
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
        .is_visible = []() { return false; },
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
        .is_visible = []() { return false;},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &shader_injection.tone_map_hue_shift,
        .default_value = 100.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
      .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPerChannelBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 25.f,
        .label = "Per Channel Blowout",
        .section = "Tone Mapping",
        .tooltip = "Per Channel Blowout strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampColorSpace",
        .binding = &shader_injection.tone_map_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Color Space",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampPeak",
        .binding = &shader_injection.tone_map_clamp_peak,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Peak",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
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
        .binding = &shader_injection.tone_map_dechroma,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
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
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "UIOpacityStatusText",
        .binding = &shader_injection.status_text_opacity,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "UID / Latency Text",
        .section = "User Interface & Video",
        .tooltip = "Toggle UID text visibility",
        .labels = {"Hidden", "Visible"},
    },
        new renodx::utils::settings::Setting{
        .key = "UIOpacityPingText",
        .binding = &shader_injection.ping_text_opacity,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Latency Bar",
        .section = "User Interface & Video",
        .tooltip = "Toggle ping text visibility",
        .labels = {"Hidden", "Visible"},
    },
    new renodx::utils::settings::Setting{
        .key = "UIVisibility",
        .binding = &shader_injection.ui_visibility,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "UI Visibility",
        .section = "User Interface & Video",
        .tooltip = "Toggle UI visibility for screenshots (use hotkey for quick toggle)",
        .labels = {"Hidden", "Visible"},
    },
    new renodx::utils::settings::Setting{
        .key = "UIVisibilityHotkey",
        .value_type = renodx::utils::settings::SettingValueType::CUSTOM,
        .default_value = 0.f,
        .label = "UI Toggle Hotkey",
        .section = "User Interface & Video",
        .tooltip = "Click in the field and press any key to set the hotkey, or press Backspace/Delete to clear",
        .on_draw = []() {
          static bool key_was_pressed = false;
          bool changed = false;
          
          // Get current key name for display
          std::string key_name = ui_toggle_hotkey != 0 ? GetKeyName(ui_toggle_hotkey) : "";
          char buf[64] = {0};
          if (!key_name.empty()) {
            size_t copy_len = (key_name.size() < sizeof(buf) - 1) ? key_name.size() : sizeof(buf) - 1;
            memcpy(buf, key_name.c_str(), copy_len);
          }
          
          // Create the input text widget
          ImGui::InputTextWithHint(
              "UI Toggle Hotkey",
              "Click to set keyboard shortcut",
              buf,
              sizeof(buf),
              ImGuiInputTextFlags_ReadOnly | ImGuiInputTextFlags_NoUndoRedo | ImGuiInputTextFlags_NoHorizontalScroll
          );
          
          // Check if widget is active and capture key presses
          if (ImGui::IsItemActive()) {
            hotkey_input_active = true;
            int key_pressed = GetLastKeyPressedImGui();
            
            if (key_pressed != 0 && !key_was_pressed) {
              if (key_pressed == VK_BACK || key_pressed == VK_DELETE) {
                ui_toggle_hotkey = 0;
                changed = true;
              } else if (key_pressed != VK_ESCAPE) {
                ui_toggle_hotkey = key_pressed;
                changed = true;
              }
              
              if (changed) {
                reshade::set_config_value(nullptr, renodx::utils::settings::global_name.c_str(), "UIVisibilityHotkey", ui_toggle_hotkey);
              }
              key_was_pressed = true;
            } else if (key_pressed == 0) {
              key_was_pressed = false;
            }
          } else {
            hotkey_input_active = false;
            key_was_pressed = false;
          }
          
          if (ImGui::IsItemHovered(ImGuiHoveredFlags_ForTooltip)) {
            ImGui::SetTooltip("Click and press any key to set hotkey.\nPress Backspace or Delete to clear.");
          }
          
          return changed;
        },
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "VideoAutoHDR",
        .binding = &shader_injection.tone_map_hdr_video,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Video AutoHDR",
        .section = "User Interface & Video",
        .tooltip = "Upgrades SDR videos to HDR.",
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapVideoNits",
        .binding = &shader_injection.tone_map_video_nits,
        .default_value = 500.f,
        .can_reset = true,
        .label = "Video Brightness",
        .section = "User Interface & Video",
        .tooltip = "Sets the peak brightness for video content in nits",
        .min = 48.f,
        .max = 1000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "fxRCASSharpening",
        .binding = &shader_injection.fx_rcas_sharpening,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "FSR RCAS Sharpening",
        .section = "Effects",
        .tooltip = "Enable Robust Contrast Adaptive Sharpening."
                   "\nProvides better image clarity.",
        .labels = {"Off", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "fxRCASAmount",
        .binding = &shader_injection.fx_rcas_amount,
        .default_value = 50.f,
        .label = "RCAS Sharpening Amount",
        .section = "Effects",
        .tooltip = "Adjusts RCAS sharpening strength.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.fx_rcas_sharpening >= 1.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting({
            .key = "FxGrainStrength",
            .binding = &shader_injection.custom_grain_strength,
            .default_value = 0.f,
            .label = "Perceptual Grain Strength",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        }),
    new renodx::utils::settings::Setting{
        .key = "VignetteStrength",
        .binding = &shader_injection.vignette_strength,
        .default_value = 50.f,
        .label = "Vignette Strength",
        .section = "Effects",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ChromaticAberrationStrength",
        .binding = &shader_injection.chromatic_aberration_strength,
        .default_value = 50.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .tooltip = "Controls the intensity of chromatic aberration effect.",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "BloomStrength",
        .binding = &shader_injection.bloom_strength,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 50.f,
        .can_reset = true,
        .label = "Bloom Strength",
        .section = "Effects",
        .tooltip = "Adjusts the intensity of bloom effects.",
        .min = 0.f,
        .max = 100.f,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::CUSTOM,
        .label = std::string("Reshade shader bypass, applies on_drawn after game's deferred lighting pass. Only properly works with DLAA/TAAU 100 scaling atm"),
        .on_draw = []() {
          ImGui::SetWindowFontScale(2.0f);
          ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 0.0f, 1.0f));
          ImGui::TextWrapped("Reshade shader bypass, applies on_drawn after game's deferred lighting pass. Only properly works with DLAA/TAAU 100 scaling atm");
          ImGui::PopStyleColor();
          ImGui::SetWindowFontScale(1.0f);
          return false;
        },
    },
        new renodx::utils::settings::Setting{
        .key = "RenderReshadeBeforeUI",
        .binding = &current_render_reshade_before_ui,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "ReShade Before UI",
        .section = "Effects",
        .tooltip = "Executes ReShade effects before UI is drawn.",
        .labels = {"Off", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "DisableGameAO",
        .binding = &shader_injection.disable_game_ao,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Disable Game GTAO",
        .section = "Effects",
        .tooltip = "Disables the game's built-in GTAO (Ground Truth Ambient Occlusion).\nUseful when using ReShade-based AO instead.",
        .labels = {"Off", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "AORadius",
        .binding = &shader_injection.ao_radius,
        .default_value = 4.f,
        .label = "AO Radius",
        .section = "Ambient Occlusion",
        .tooltip = "World-space sampling radius. Larger values detect occlusion from more distant geometry.",
        .max = 16.f,
        .format = "%.1f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AORadiusScale",
        .binding = &shader_injection.ao_radius_scale,
        .default_value = 1.f,
        .label = "AO Radius Scale",
        .section = "Ambient Occlusion",
        .tooltip = "Multiplier on the effective radius. Fine-tune the reach of the AO sampling.",
        .max = 5.f,
        .format = "%.2f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AOFalloffRange",
        .binding = &shader_injection.ao_falloff_range,
        .default_value = 1.f,
        .label = "AO Falloff Range",
        .section = "Ambient Occlusion",
        .tooltip = "Fraction of radius used for distance falloff (0-1). Lower = sharper falloff.",
        .max = 1.f,
        .format = "%.2f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AODistributionPower",
        .binding = &shader_injection.ao_distribution_power,
        .default_value = 2.f,
        .label = "AO Distribution Power",
        .section = "Ambient Occlusion",
        .tooltip = "Controls how sample distances are distributed. Higher = samples pushed further out.",
        .max = 5.f,
        .format = "%.2f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AOThinOccluder",
        .binding = &shader_injection.ao_thin_occluder,
        .default_value = 2.f,
        .label = "AO Thin Occluder",
        .section = "Ambient Occlusion",
        .tooltip = "Thin occluder compensation factor. Higher = more AO contribution from thin objects.",
        .max = 8.f,
        .format = "%.1f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AOGamma",
        .binding = &shader_injection.ao_gamma,
        .default_value = 2.2f,
        .label = "AO Intensity (Gamma)",
        .section = "Ambient Occlusion",
        .tooltip = "Power curve applied to the final AO. Higher = darker/stronger occlusion.",
        .max = 5.f,
        .format = "%.2f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AOTemporalFrame",
        .binding = &shader_injection.ao_temporal_frame,
        .default_value = 64.f,
        .label = "AO Temporal Frame",
        .section = "Ambient Occlusion",
        .tooltip = "Temporal frame count for jitter rotation cycling. Higher = more noise variation frames.",
        .max = 128.f,
        .format = "%.0f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AOMipBias",
        .binding = &shader_injection.ao_mip_bias,
        .default_value = 4.f,
        .label = "AO Mip Bias",
        .section = "Ambient Occlusion",
        .tooltip = "Mip level bias for depth sampling. Higher = coarser/smoother depth reads.",
        .max = 8.f,
        .format = "%.1f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AODirectionCount",
        .binding = &shader_injection.ao_direction_count,
        .default_value = 6.f,
        .label = "AO Direction Count",
        .section = "Ambient Occlusion",
        .tooltip = "Number of directional slices for horizon search. More = higher quality, higher cost.",
        .min = 1.f,
        .max = 12.f,
        .format = "%.0f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AOStepCount",
        .binding = &shader_injection.ao_step_count,
        .default_value = 6.f,
        .label = "AO Step Count",
        .section = "Ambient Occlusion",
        .tooltip = "Number of sample steps per direction. More = better horizon accuracy, higher cost.",
        .min = 1.f,
        .max = 12.f,
        .format = "%.0f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AONormalAttenuation",
        .binding = &shader_injection.ao_normal_attenuation,
        .default_value = 0.05f,
        .label = "AO Normal Attenuation",
        .section = "Ambient Occlusion",
        .tooltip = "Blends between surface normal and view direction for the visibility integral.",
        .max = 1.f,
        .format = "%.3f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AOThickness",
        .binding = &shader_injection.ao_thickness,
        .default_value = 0.5f,
        .label = "AO Thickness",
        .section = "Ambient Occlusion",
        .tooltip = "Assumed thickness of occluders. Controls min-sample distance and bitmask backface offset.",
        .max = 5.f,
        .format = "%.2f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AODenoiserBlurBeta",
        .binding = &shader_injection.ao_denoiser_blur_beta,
        .default_value = 0.f,
        .label = "AO Denoiser Blur",
        .section = "Ambient Occlusion",
        .tooltip = "Bilateral blur edge sensitivity. Higher = more blur, less edge preservation.",
        .max = 3.f,
        .format = "%.2f",
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AODebugView",
        .binding = &shader_injection.ao_debug_view,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "AO Debug View",
        .section = "Ambient Occlusion",
        .tooltip = "Switches between normal scene rendering and AO-only debug visualization.",
        .labels = {"Off", "AO Only"},
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "AOBitmask",
        .binding = &shader_injection.ao_bitmask,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "AO Visibility Bitmask",
        .section = "Ambient Occlusion",
        .tooltip = "Enables XeGTAO visibility bitmask method. Replaces the default horizon-based integration with a bitmask-based approach for improved multi-layer occlusion.",
        .labels = {"Off", "On"},
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset AO Settings to Defaults",
        .section = "Ambient Occlusion",
        .on_change = []() {
          renodx::utils::settings::UpdateSetting("AORadius", 4.f);
          renodx::utils::settings::UpdateSetting("AORadiusScale", 1.f);
          renodx::utils::settings::UpdateSetting("AOFalloffRange", 1.f);
          renodx::utils::settings::UpdateSetting("AODistributionPower", 2.f);
          renodx::utils::settings::UpdateSetting("AOThinOccluder", 2.f);
          renodx::utils::settings::UpdateSetting("AOGamma", 2.2f);
          renodx::utils::settings::UpdateSetting("AOTemporalFrame", 64.f);
          renodx::utils::settings::UpdateSetting("AOMipBias", 4.f);
          renodx::utils::settings::UpdateSetting("AODirectionCount", 6.f);
          renodx::utils::settings::UpdateSetting("AOStepCount", 6.f);
          renodx::utils::settings::UpdateSetting("AONormalAttenuation", 0.05f);
          renodx::utils::settings::UpdateSetting("AOThickness", 0.5f);
          renodx::utils::settings::UpdateSetting("AODenoiserBlurBeta", 0.f);
          renodx::utils::settings::UpdateSetting("AODebugView", 0.f);
          renodx::utils::settings::UpdateSetting("AOBitmask", 1.f);
        },
    },
    new renodx::utils::settings::Setting{
        .key = "HDRSun",
        .binding = &shader_injection.sun_intensity,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "HDR Sun",
        .section = "Rendering Improvements",
        .tooltip = "Reworks the sun to be more HDR-like",
        .labels = {"Off", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "Godrays",
        .binding = &shader_injection.godrays_intensity,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Godrays",
        .section = "Rendering Improvements",
        .tooltip = "Controls godray intensity",
        .labels = {"Off", "Vanilla", "2x", "3x"},
    },
    new renodx::utils::settings::Setting{
        .key = "SHADOW_HARDENING",
        .binding = &shader_injection.shadow_hardening,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Improved Shadows",
        .section = "Rendering Improvements",
        .tooltip = "Toggle improved shadow occlusion for objects and foliage",
        .labels = {"Off", "On"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "FogModification",
        .binding = &shader_injection.fog_modification,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue-Preserving Fog",
        .section = "Rendering Improvements",
        .tooltip = "Toggles alternative hue-preserving fog",
        .labels = {"Original", "Alt"},
    },
    new renodx::utils::settings::Setting{
        .key = "MetallicIBLIntensity",
        .binding = &shader_injection.metallic_ibl_intensity,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Metallic IBL Intensity",
        .section = "Rendering Improvements",
        .tooltip = "Controls image-based lighting intensity on metallic surfaces",
        .labels = {"Vanilla", "Alt"},
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "CubemapAmbientLink",
        .binding = &shader_injection.cubemap_ambient_link,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Cubemap Ambient Link",
        .section = "Rendering Improvements",
        .tooltip = "Modulates cubemap reflections by ambient luminance",
        .labels = {"Off", "On"},
    },
    new renodx::utils::settings::Setting{
        .key = "GlassTransparency",
        .binding = &shader_injection.glass_transparency,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Glass Transparency",
        .section = "Rendering Improvements",
        .tooltip = "Improves glass rendering to look more transparent and less cloudy/glowing",
        .labels = {"Vanilla", "Improved"},
    },
    new renodx::utils::settings::Setting{
        .key = "ImprovedSSR",
        .binding = &shader_injection.improved_ssr,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SSR Quality",
        .section = "Rendering Improvements",
        .tooltip = "Controls the game's SSR denoiser behavior.\n"
                   "Vanilla: Original denoiser.\n"
                   "Improved: Sharper reflections on smooth surfaces (metals, glass)\n"
                   "  while retaining proper diffusion on rough surfaces (wood, stone).\n"
                   "  Temporal smoothing is preserved to minimize firefly artifacts.",
        .labels = {"Vanilla", "Improved"},
    },
    new renodx::utils::settings::Setting{
        .key = "ImprovedGTAO",
        .binding = &shader_injection.improved_gtao,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "GTAO + Visibility Bitmask + Deferred AO Modulation",
        .section = "Rendering Improvements",
        .tooltip = "Improves vanilla GTAO with visibility bitmask and AO modulation on direct lights (spotlights, point lights).",
        .labels = {"Original", "Improved"},
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
                   "\nDefault: US CRT",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainEncoding",
        .binding = &shader_injection.swap_chain_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 4.f,
        .label = "Encoding",
        .section = "Display Output",
        .labels = {"None", "SRGB", "2.2", "2.4", "HDR10", "scRGB"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .on_change_value = [](float previous, float current) {
          bool is_hdr10 = current == 4;
          shader_injection.swap_chain_encoding_color_space = (is_hdr10 ? 1.f : 0.f);
        },
        .is_global = true,
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) {
            if (value == 0) return shader_injection.gamma_correction + 1.f;
            return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainDecoding",
        .binding = &shader_injection.swap_chain_decoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swapchain Decoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) {
            if (value == 0) return shader_injection.intermediate_encoding;
            return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainClampColorSpace",
        .binding = &shader_injection.swap_chain_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Clamp Color Space",
        .section = "Display Output",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "TechTestLook",
        .binding = &shader_injection.tech_test_look,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Tech Test Look",
        .section = "Alternative Grading",
        .tooltip = "Activates visual adjustments to match the 2024 tech test aesthetic",
        .labels = {"Off", "On"},
        .on_change_value = [](float previous, float current) {
          if (current >= 1.f) pending_tech_test_preset = 1;
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/", "clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- Addon maintained by Spiwar & Forge.",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- Made for Arknights: Endfield 1.0",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Special thanks to both Musa & Miru for helping with the addon"),
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Many thanks to ShortFuse for RenoDX"),
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- This build was compiled on " + build_date + " at " + build_time + ".",
        .section = "About",
    },
};

void OnPresetOff() {
     renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
     renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
     renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
     renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
     renodx::utils::settings::UpdateSetting("ToneMapGammaCorrection", 1.f);
     renodx::utils::settings::UpdateSetting("GammaCorrection", 1.f);
     renodx::utils::settings::UpdateSetting("SwapChainGammaCorrection", 1.f);
     renodx::utils::settings::UpdateSetting("HDRSun", 0.f);
     renodx::utils::settings::UpdateSetting("Godrays", 1.f);
     renodx::utils::settings::UpdateSetting("SHADOW_HARDENING", 0.f);
     renodx::utils::settings::UpdateSetting("FogModification", 0.f);
     renodx::utils::settings::UpdateSetting("CubemapAmbientLink", 0.f);
     renodx::utils::settings::UpdateSetting("GlassTransparency", 0.f);
     renodx::utils::settings::UpdateSetting("ImprovedSSR", 0.f);
     renodx::utils::settings::UpdateSetting("ImprovedGTAO", 0.f);
     renodx::utils::settings::UpdateSetting("TechTestLook", 0.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);
}

// OnDraw handler to track vertex count from draw calls
bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  draw_call_vertex_count = vertex_count;
  return false; 
}

// OnDrawIndexed event handler for heuristic-based ping/UID detection
bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  // Constants for ping/latency bar detection
  constexpr uint32_t PING_INDEX_COUNT = 18;
  constexpr uint32_t PING_FIRST_INDEX = 0;
  constexpr int32_t PING_VERTEX_OFFSET = 0;

  // Detect ping/latency bar
  // This distinguishes it from menu backgrounds that also have 18 indices but have a preceding draw
  is_ping_input_candidate = (index_count == PING_INDEX_COUNT) &&
                            (first_index == PING_FIRST_INDEX) &&
                            (vertex_offset == PING_VERTEX_OFFSET) &&
                            (draw_call_vertex_count == 0);

  // Constants for UID text detection
  constexpr uint32_t UID_FIRST_INDEX = 18;
  constexpr uint32_t UID_MIN_INDEX_COUNT = 100;
  constexpr int32_t UID_VERTEX_OFFSET = 12;

  // Detect UID text: drawn right after ping with specific parameters
  // Use is_ping_drawn (set by OnPingDraw) since ping shader draws before UID shader
  is_uid_input_candidate = (first_index == UID_FIRST_INDEX) &&
                           (index_count > UID_MIN_INDEX_COUNT) &&
                           (vertex_offset == UID_VERTEX_OFFSET) &&
                           is_ping_drawn;

  // Reset vertex count after processing
  draw_call_vertex_count = 0;

  return false; 
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

  // Compute UI aspect ratio from swapchain for dynamic latency bar detection
  auto bb = device->get_resource_desc(swapchain->get_current_back_buffer());
  if (bb.type != reshade::api::resource_type::unknown) {
    shader_injection.ui_aspect_ratio = static_cast<float>(bb.texture.height) / static_cast<float>(bb.texture.width);
  }

  // Reset heuristic tracking flags for ping/UID detection
  is_ping_input_candidate = false;
  is_uid_input_candidate = false;
  is_ping_drawn = false;
  draw_call_vertex_count = 0;

  // Detect Tech Test state changes from preset loads, game startup, or manual toggle
  float current_tech_test = shader_injection.tech_test_look;
  if (current_tech_test != prev_tech_test_look) {
    if (current_tech_test >= 1.f) pending_tech_test_preset = 1;
    prev_tech_test_look = current_tech_test;
  }

  // Apply deferred Tech Test preset (safe context, outside settings callback)
  if (pending_tech_test_preset == 1) {
    renodx::utils::settings::UpdateSetting("GammaCorrection", 2.f);
    renodx::utils::settings::UpdateSetting("SwapChainGammaCorrection", 2.f);
    renodx::utils::settings::UpdateSetting("ToneMapPerChannelBlowout", 75.f);
    renodx::utils::settings::UpdateSetting("ColorGradeExposure", 0.65f);
    renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 51.f);
    renodx::utils::settings::UpdateSetting("ColorGradeShadows", 80.f);
    renodx::utils::settings::UpdateSetting("ColorGradeContrast", 55.f);
    renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 35.f);
    renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 100.f);
    renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 30.f);
    pending_tech_test_preset = -1;
  }

  // Check UI visibility hotkey (skip if user is currently setting a new hotkey)
  if (ui_toggle_hotkey != 0 && !hotkey_input_active) {
    bool key_down = (GetAsyncKeyState(ui_toggle_hotkey) & 0x8000) != 0;
    if (key_down && !ui_toggle_key_was_pressed) {
      // Toggle UI visibility
      shader_injection.ui_visibility = (shader_injection.ui_visibility == 0.f) ? 1.f : 0.f;
      // Update the setting value to keep UI in sync
      renodx::utils::settings::UpdateSetting("UIVisibility", shader_injection.ui_visibility);
    }
    ui_toggle_key_was_pressed = key_down;
  }
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Arknights: Endfield";

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
              .default_value = 1.f,
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
              .default_value = 1.f,
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

        // Initialize SwapChainEncoding-related settings
        {
          float encoding_value = 4.f;  // default
          reshade::get_config_value(nullptr, renodx::utils::settings::global_name.c_str(), "SwapChainEncoding", encoding_value);
          bool is_hdr10 = encoding_value == 4;
          renodx::mods::swapchain::SetUseHDR10(is_hdr10);
          renodx::mods::swapchain::use_resize_buffer = encoding_value < 4;
          shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
        }

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
          if (!use_device_proxy) {
            shader_injection.custom_flip_uv_y = 0.f;
          }
          reshade::register_event<reshade::addon_event::present>(OnPresent);
          // Register callbacks to ALWAYS disable ReShade during normal present
          // This ensures ReShade only ever renders at internal resolution via bypass
          reshade::register_event<reshade::addon_event::reshade_begin_effects>(OnReshadeBeginEffects);
          reshade::register_event<reshade::addon_event::reshade_finish_effects>(OnReshadeFinishEffects);
          settings.push_back(setting);
        }

        // Load UI visibility hotkey from saved config
        {
          int saved_hotkey = 0;
          if (reshade::get_config_value(nullptr, renodx::utils::settings::global_name.c_str(), "UIVisibilityHotkey", saved_hotkey)) {
            ui_toggle_hotkey = saved_hotkey;
          }
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


        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::r8g8b8a8_typeless,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .ignore_size = false,
        //.use_resource_view_cloning = true,
        .aspect_ratio = static_cast<float>(renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER),
        .aspect_ratio_tolerance = 0.02f,
        .usage_include = reshade::api::resource_usage::render_target,
        });
        // Need aspect ratio upgrade or grass will be broken
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = false,
            //.use_resource_view_cloning = true,
            .aspect_ratio = static_cast<float>(renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER),
            .aspect_ratio_tolerance = 0.02f,
            .usage_include = reshade::api::resource_usage::render_target,
        });
        /*
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r10g10b10a2_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = false,
            //.use_resource_view_cloning = true,
            .aspect_ratio = static_cast<float>(renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER),
            .aspect_ratio_tolerance = 0.02f,
            .usage_include = reshade::api::resource_usage::render_target,
        });
        */
        const uint32_t target_crcs[] = {
        // Enviroment deferred (doesnt apply to grass/foliage)
        /* 
          0xD88CD7C9u,
          0x1E8A471Eu,
          0x8BA3C806u,
          0x7010AF4Bu,
          0x0E84DFD1u,
          0x99725481u,
          0xA4113DE8u,
          0xD5B102A4u,
        };
        */    
 
      // grass/foliage deferred (grass, plants, trees will be included in AO)
        
        0x37837806u,
        0xD3FA93FCu,
        0x620A40FDu,
        0xE322C21Du,
        0xB094C87Eu,
        0xF901F0ECu,
        0x518D3855u,
        0xBD99F0C4u,
        };  

      // Uberpost
        /*  
        0x00C16AFBu,
        0x039C28DAu,
        0x086097D2u,
        0x09270FDAu,
        0x0E520F06u,
        0x10076711u,
        0x21241B7Au,
        0x51359B4Du,
        0x53875523u,
        0x53D50BD5u,
        0x57737D9Fu,
        0x5FC0BD3Cu,
        0x6166487Au,
        0x61908D50u,
        0x64CEB255u,
        0x6A76C719u,
        0x86420EBCu,
        0x9790A50Cu,
        0x9AA3FC1Fu,
        0xA6501734u,
        0xA6E6ABE6u,
        0xA8213A68u,
        0xAFDCA263u,
        0xAFECA8F4u,
        0xBCD91195u,
        0xD5BC74ACu,
        0xE0058043u,
        0xF8FA587Fu,
        */


        for (uint32_t crc : target_crcs) {
          // Ensure an entry exists for the shader hash even if we don't have compiled HLSL
          auto it = custom_shaders.find(crc);
          if (it == custom_shaders.end()) {
            renodx::mods::shader::CustomShader cs{};
            cs.crc32 = crc;
            cs.on_drawn = ExecuteReshadeEffects;
            custom_shaders.emplace(crc, std::move(cs));
          } else {
            it->second.on_drawn = ExecuteReshadeEffects;
          }
        }

        // Add on_draw callbacks for ping/UID shaders (heuristic-based detection)
        // Ping/latency bar shader: 0xEF07F89A
        {
          auto it = custom_shaders.find(0xEF07F89Au);
          if (it != custom_shaders.end()) {
            it->second.on_draw = OnPingDraw;
          }
        }
        // UID text shader: 0x6B8E9049
        {
          auto it = custom_shaders.find(0x6B8E9049u);
          if (it != custom_shaders.end()) {
            it->second.on_draw = OnUIDDraw;
          }
        }

        // Register draw and draw_indexed events for heuristic ping/UID detection
        reshade::register_event<reshade::addon_event::draw>(OnDraw);
        reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_event<reshade::addon_event::reshade_begin_effects>(OnReshadeBeginEffects);
      reshade::unregister_event<reshade::addon_event::reshade_finish_effects>(OnReshadeFinishEffects);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::utils::random::binds.push_back(&shader_injection.custom_random);
  renodx::utils::random::Use(fdw_reason);

  return TRUE;
}
