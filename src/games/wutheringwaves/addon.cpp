/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/path.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/shader.hpp"
#include "../../utils/shader_dump.hpp"
#include "../../utils/swapchain.hpp"
#include "../../utils/random.hpp"
#include "./shared.h"

namespace {

std::unordered_set<std::uint32_t> drawn_shaders;

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

float current_settings_mode = 0;

// Hotkey state tracking
// Credit: https://github.com/spiwar/renodx/commit/bb4aa4a32f6addaddf3b8ee2d4ee9a9910104da8
bool ui_toggle_key_was_pressed = false;
int ui_toggle_hotkey = 0;
bool hotkey_input_active = false;

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

    constexpr KeyMapping(ImGuiKey key, int code) : imgui_key(key), vk_code(code) {}
  };

  static constexpr auto KEY_MAPPINGS = std::to_array<KeyMapping>({
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
  });

  for (const auto& mapping : KEY_MAPPINGS) {
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
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
        .parse = [](float value) { return value * 3.f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.tone_map_peak_nits,
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
        .binding = &shader_injection.tone_map_game_nits,
        .default_value = 203.f,
        .can_reset = false,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
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
        .tooltip = "Simulates the effect of decoding sRGB as pure gamma that would be seen in SDR.",
        .labels = {"Off", "2.2", "2.4"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "OutputColorSpace",
        .binding = &shader_injection.output_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Color Space",
        .section = "Tone Mapping",
        .tooltip = "The output color space; this applies to both the scene and UI.\nBe aware that Wuthering Waves was mastered for BT.709.",
        .labels = {"BT.709", "DCI-P3", "BT.2020"},
        .is_enabled = []() { return shader_injection.processing_use_scrgb == 0; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "VideoAutoHDR",
        .binding = &shader_injection.tone_map_hdr_video,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Video AutoHDR",
        .section = "Video",
        .tooltip = "Upgrades SDR videos to HDR.",
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapVideoNits",
        .binding = &shader_injection.tone_map_video_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Video Brightness",
        .section = "Video",
        .tooltip = "Sets the peak brightness for video content in nits",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting {
        .key = "UIVisibility",
        .binding = &shader_injection.ui_visibility,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Visibility",
        .section = "UI",
    },
    new renodx::utils::settings::Setting{
        .key = "UIToggleHotkey",
        .value_type = renodx::utils::settings::SettingValueType::CUSTOM,
        .default_value = 0.f,
        .label = "Toggle Hotkey",
        .section = "UI",
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
              "Toggle Hotkey",
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
                reshade::set_config_value(nullptr, renodx::utils::settings::global_name.c_str(), "UIToggleHotkey", ui_toggle_hotkey);
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
        .key = "ToneMapUINits",
        .binding = &shader_injection.tone_map_ui_nits,
        .default_value = 203.f,
        .can_reset = false,
        .label = "UI Brightness",
        .section = "UI",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "UI",
        .tooltip = "Controls the gamma correction applied to the UI and HUD elements.\nEncoding 2-D assets for HDR that were originally intended for sRGB creates a \"washed out\" look without correction.",
        .labels = {"Off", "2.2", "2.4"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting {
        .key = "TextOpacity",
        .binding = &shader_injection.text_opacity,
        .default_value = 100.f,
        .label = "Text Opacity",
        .section = "UI",
        .parse = [](float value) { return value * 0.01f; }
    },
    new renodx::utils::settings::Setting {
        .key = "StatusTextOpacity",
        .binding = &shader_injection.status_text_opacity,
        .default_value = 0.f,
        .label = "Status Text Opacity",
        .section = "UI",
        .tooltip = "Opacity for texts such as location, UUID, and ping",
        .parse = [](float value) { return value * 0.01f; }
    },
    new renodx::utils::settings::Setting {
        .key = "HUDOpacity",
        .binding = &shader_injection.hud_opacity,
        .default_value = 100.f,
        .label = "HUD Opacity",
        .section = "UI",
        .parse = [](float value) { return value * 0.01f; }
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeStrength",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Strength",
        .section = "Scene Grading",
        .tooltip = "Scene grading as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "WuWaTonemapper",
        .binding = &shader_injection.wuwa_tonemapper,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .label = "Game Tone Mapper",
        .section = "Scene Grading",
        .tooltip = "Adjusts the tone mapper used by the game.\nThe provided names are from the game's files.\n\"Kuro\" is the original behavior.",
        .labels = {"None", "Genshin", "Death Stranding", "Kuro"},
        .is_enabled = []() { return current_settings_mode >= 1
                                    && shader_injection.color_grade_strength > 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHueCorrection",
        .binding = &shader_injection.color_grade_hue_correction,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Scene Grading",
        .tooltip = "Corrects per-channel hue shifts from per-channel grading.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1
                                    && shader_injection.color_grade_strength > 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturationCorrection",
        .binding = &shader_injection.color_grade_saturation_correction,
        .default_value = 100.f,
        .label = "Saturation Correction",
        .section = "Scene Grading",
        .tooltip = "Corrects unbalanced saturation from per-channel grading.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1
                                    && shader_injection.color_grade_strength > 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowoutRestoration",
        .binding = &shader_injection.color_grade_blowout_restoration,
        .default_value = 50.f,
        .label = "Blowout Restoration",
        .section = "Scene Grading",
        .tooltip = "Restores color from blowout from per-channel grading.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1
                                    && shader_injection.color_grade_strength > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHueShift",
        .binding = &shader_injection.color_grade_hue_shift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Scene Grading",
        .tooltip = "Modulates between the hues of the uncorrected and corrected saturation.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1
                                    && shader_injection.color_grade_strength > 0
                                    && shader_injection.color_grade_saturation_correction > 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.color_grade_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Custom Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.color_grade_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Custom Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightsVersion",
        .binding = &shader_injection.color_grade_highlights_version,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Highlights Version",
        .section = "Custom Color Grading",
        .tooltip = "Highlights \"v2\" is experimental.",
        .labels = {
            "v1",
            "v2",
            "v3",
        },
        .parse = [](float value) { return value + 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.color_grade_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Custom Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadowsVersion",
        .binding = &shader_injection.color_grade_shadows_version,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Shadows Version",
        .section = "Custom Color Grading",
        .tooltip = "The lack of \"v2\" is intentional.",
        .labels = {
            "v1",
            "v3",
        },
        .parse = [](float value) { return value >= 1.f ? 3.f : 1.f;},
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.color_grade_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Custom Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.color_grade_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Custom Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.color_grade_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Custom Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.wuwa_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Custom Color Grading",
        .tooltip = "Simulates the game's original effect of bright colors being clipped to white.\n100 retains original behavior, 0 disables it completely.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.color_grade_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Custom Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeClip",
        .binding = &shader_injection.reno_drt_white_clip,
        .default_value = 65.f,
        .label = "White Clip",
        .section = "Custom Color Grading",
        .tooltip = "Clip point for white in nits",
        .min = 1.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting {
        .key = "WuWaBloom",
        .binding = &shader_injection.wuwa_bloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Post-Processing",
        .tooltip = "Reduces bloom intensity when applied by the game.\n100 retains original behavior, 0 disables it completely.",
        .parse = [](float value) { return value * 0.01f; }
    },
    new renodx::utils::settings::Setting{
      .key = "HDRSun",
      .binding = &shader_injection.wuwa_hdr_sun,
      .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
      .default_value = 1.f,
      .label = "HDR Sun",
      .section = "Post-Processing",
      .tooltip = "Boosts sun, moon, and glow brightness in the skybox.",
    },
};

enum Preset : uint8_t {
  OFF,
  VANILLA_PLUS,
  HDR_LOOK
};

const std::map<Preset, std::map<std::string, float>> PRESET_VALUES = {
  { OFF,
    { {"ToneMapType", 0.f},
      {"WuWaTonemapper", 3.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"SwapChainGammaCorrection", 0.f},
      {"OutputColorSpace", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"WuWaBloom", 100.f},
      {"WuWaGrain", 100.f}
    }
  },
  { VANILLA_PLUS,
    { {"GammaCorrection", 1.f},
      {"SwapChainGammaCorrection", 2.f},
      {"OutputColorSpace", 0.f},
      {"ColorGradeStrength", 100.f},
      {"WuWaTonemapper", 3.f},
      {"ColorGradeHueCorrection", 0.f},
      {"ColorGradeSaturationCorrection", 100.f},
      {"ColorGradeBlowoutRestoration", 0.f},
      {"ColorGradeHueShift", 100.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 63.f},
      {"ColorGradeHighlightsVersion", 0.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeShadowsVersion", 0.f},
      {"ColorGradeContrast", 51.f},
      {"ColorGradeSaturation", 58.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeClip", 65.f},
      {"WuWaChromaticAberration", 100.f},
      {"WuWaBloom", 60.f}
    }
  },
  { HDR_LOOK,
    { {"GammaCorrection", 1.f},
      {"SwapChainGammaCorrection", 2.f},
      {"OutputColorSpace", 0.f},
      {"ToneMapHueProcessor", 0.f},
      {"ColorGradeStrength", 50.f},
      {"WuWaTonemapper", 3.f},
      {"ColorGradeHueCorrection", 100.f},
      {"ColorGradeSaturationCorrection", 100.f},
      {"ColorGradeBlowoutRestoration", 0.f},
      {"ColorGradeHueShift", 100.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 60.f},
      {"ColorGradeHighlightsVersion", 2.f},
      {"ColorGradeShadows", 75.f},
      {"ColorGradeShadowsVersion", 1.f},
      {"ColorGradeContrast", 60.f},
      {"ColorGradeSaturation", 60.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 50.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeClip", 60.f},
      {"WuWaChromaticAberration", 100.f},
      {"WuWaBloom", 60.f}
    }
  }
};

void ApplyPreset(const Preset& preset) {
  if (!PRESET_VALUES.contains(preset)) {
    return;
  }

  for (const auto& [key, value] : PRESET_VALUES.at(preset)) {
    renodx::utils::settings::UpdateSetting(key, value);
  }
}

void OnPresetVanillaPlus() {
  ApplyPreset(VANILLA_PLUS);
}

void OnPresetHdrLook() {
  ApplyPreset(HDR_LOOK);
}

renodx::utils::settings::Settings info_settings = {
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() { renodx::utils::settings::ResetSettings(); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Vanilla+",
        .section = "Options",
        .group = "button-line-1",
        .tooltip = "A preset that aims to preserve the game's original appearance",
        .on_change = OnPresetVanillaPlus,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Look",
        .section = "Options",
        .group = "button-line-1",
        .tooltip = "A preset that aims to showcase the expected impact of HDR",
        .on_change = OnPresetHdrLook,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "WAXEkFVz");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

void OnPresetOff() {
  ApplyPreset(OFF);
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;

    const auto game = renodx::utils::swapchain::ComputeReferenceWhite(peak.value());
    settings[3]->default_value = game;
    settings[3]->can_reset = true;

    settings[7]->default_value = game;
    settings[7]->can_reset = true;

    fired_on_init_swapchain = true;
  }
}

float g_dump_shaders = 0;

std::unordered_set<uint32_t> g_dumped_shaders = {};

bool OnDrawForLUTDump(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  if (g_dump_shaders == 0) return false;

  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);

  auto* pixel_state = renodx::utils::shader::GetCurrentPixelState(shader_state);

  auto pixel_shader_hash = renodx::utils::shader::GetCurrentPixelShaderHash(pixel_state);
  if (pixel_shader_hash == 0u) return false;

  auto* swapchain_state = renodx::utils::swapchain::GetCurrentState(cmd_list);
  bool found_lut_render_target = false;

  auto* device = cmd_list->get_device();
  for (auto render_target : swapchain_state->current_render_targets) {
    auto resource_tag = renodx::utils::resource::GetResourceTag(render_target);
    if (resource_tag == 1.f) {
      found_lut_render_target = true;
      break;
    }
  }
  if (!found_lut_render_target) return false;

  if (g_dumped_shaders.contains(pixel_shader_hash)) return false;

  reshade::log::message(
      reshade::log::level::debug,
      std::format("Dumping lutbuiler: 0x{:08x}", pixel_shader_hash).c_str());

  g_dumped_shaders.emplace(pixel_shader_hash);

  renodx::utils::path::default_output_folder = "renodx";
  renodx::utils::shader::dump::default_dump_folder = ".";
  bool found = false;
  try {
    auto shader_data = renodx::utils::shader::GetShaderData(pixel_state);
    if (!shader_data.has_value()) {
      std::stringstream s;
      s << "utils::shader::dump(Failed to retreive shader data: ";
      s << PRINT_CRC32(pixel_shader_hash);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      return false;
    }

    auto shader_version = renodx::utils::shader::compiler::directx::DecodeShaderVersion(shader_data.value());
    if (shader_version.GetMajor() == 0) {
      // No shader information found
      return false;
    }

    const std::string& prefix = custom_shaders.contains(pixel_shader_hash) ? "patched_lutbuilder_" : "lutbuilder_";

    renodx::utils::shader::dump::DumpShader(
        pixel_shader_hash,
        shader_data.value(),
        reshade::api::pipeline_subobject_type::pixel_shader,
        prefix);

  } catch (...) {
    std::stringstream s;
    s << "utils::shader::dump(Failed to decode shader data: ";
    s << PRINT_CRC32(pixel_shader_hash);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }

  return false;
}

void AddAdvancedSettings() {
  auto add_setting = [&](auto* setting) {
    renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
    settings.push_back(setting);
  };

  const std::vector<reshade::api::format> upgrade_formats = {
    reshade::api::format::r8g8b8a8_typeless,
    reshade::api::format::r10g10b10a2_unorm
  };

  for (const auto& upgrade_format : upgrade_formats) {
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = upgrade_format,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .usage_include = reshade::api::resource_usage::render_target
      });
  }

  const std::vector<float> letterbox_aspect_ratios = {3840.f / 1620.f, 2880.f / 1216.f};
  // Upgrade letterbox cutscene resources
  for (const float& ratio : letterbox_aspect_ratios) {
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::r8g8b8a8_typeless,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .ignore_size = false,
        .use_resource_view_cloning = true,
        .aspect_ratio = ratio,
    });
  }

  {
    auto* swapchain_setting = new renodx::utils::settings::Setting{
        .key = "Upgrade_SwapChainCompatibility",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swap Chain Compatibility Mode",
        .section = "Resource Upgrades",
        .tooltip = "Enhances support for third-party addons to read the swap chain.",
        .labels = {
            "Off",
            "On",
        },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(swapchain_setting);
    renodx::mods::swapchain::swapchain_proxy_compatibility_mode = swapchain_setting->GetValue() != 0;
  }

  {
    auto* scrgb_setting = new renodx::utils::settings::Setting{
        .key = "Upgrade_UseSCRGB",
        .binding = &shader_injection.processing_use_scrgb,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swap Chain Format",
        .section = "Resource Upgrades",
        .tooltip = "Selects use of HDR10 or scRGB swapchain.",
        .labels = {
            "HDR10",
            "scRGB",
        },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(scrgb_setting);

    shader_injection.processing_use_scrgb = scrgb_setting->GetValue();
    renodx::mods::swapchain::SetUseHDR10(scrgb_setting->GetValue() == 0);
  }

  {
    auto* force_borderless_setting = new renodx::utils::settings::Setting{
        .key = "ForceBorderless",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Force Borderless",
        .section = "Resource Upgrades",
        .tooltip = "Forces fullscreen to be borderless for proper HDR",
        .labels = {
            "Disabled",
            "Enabled",
        },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(force_borderless_setting);

    if (force_borderless_setting->GetValue() == 0) {
      renodx::mods::swapchain::force_borderless = false;
    }
  }

  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "PreventFullscreen",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Prevent Fullscreen",
        .section = "Resource Upgrades",
        .tooltip = "Prevent exclusive fullscreen for proper HDR",
        .labels = {
            "Disabled",
            "Enabled",
        },
        .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);

    renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
  }

  {
    auto* lut_dump_setting = new renodx::utils::settings::Setting{
        .key = "DumpLUTShaders",
        .binding = &g_dump_shaders,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Dump LUT Shaders",
        .section = "Resource Upgrades",
        .tooltip = "Traces and dumps LUT shaders.",
        .labels = {
            "Off",
            "On",
        },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(lut_dump_setting);

    g_dump_shaders = lut_dump_setting->GetValue();
  }

  settings.push_back({new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::TEXT,
      .label = "The application must be restarted for upgrades to take effect.",
      .section = "Resource Upgrades",
      .is_visible = []() { return settings[0]->GetValue() >= 2; },
  }});
}

void OnPresent(reshade::api::command_queue* /*unused*/,
               reshade::api::swapchain* /*unused*/,
               const reshade::api::rect* /*unused*/,
               const reshade::api::rect* /*unused*/,
               uint32_t /*unused*/,
               const reshade::api::rect* /*unused*/) {
  // Check UI toggle hotkey (skip if user is currently setting a new hotkey)
  if (ui_toggle_hotkey != 0 && !hotkey_input_active) {
    bool key_down = (GetAsyncKeyState(ui_toggle_hotkey) & 0x8000) != 0;

    if (key_down && !ui_toggle_key_was_pressed) {
      // Toggle UI
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
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Wuthering Waves";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      // Temporal random seed (per-frame) for temporal dither/grain
      renodx::utils::random::binds.push_back(&shader_injection.custom_random);
      renodx::utils::random::Use(fdw_reason);

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
        return (params.size() < 20);
      };

      if (!initialized) {
        AddAdvancedSettings();

        for (auto* new_setting : info_settings) {
          settings.push_back(new_setting);
        }

        // Load UI toggle hotkey from saved config
        {
          int saved_hotkey = 0;
          if (reshade::get_config_value(nullptr, renodx::utils::settings::global_name.c_str(), "UIToggleHotkey", saved_hotkey)) {
            ui_toggle_hotkey = saved_hotkey;
          }
        }

        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::force_pipeline_cloning = true;

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

        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r10g10b10a2_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .dimensions = {.width = 32, .height = 32, .depth = 32},
            .resource_tag = 1.f,
        });

        initialized = true;
      }

      if (g_dump_shaders != 0.f) {
        renodx::utils::swapchain::Use(fdw_reason);
        renodx::utils::shader::Use(fdw_reason);
        renodx::utils::shader::use_shader_cache = true;
        renodx::utils::resource::Use(fdw_reason);
        reshade::register_event<reshade::addon_event::draw>(OnDrawForLUTDump);
        reshade::log::message(reshade::log::level::info, "DumpLUTShaders enabled.");
      }

      reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    case DLL_PROCESS_DETACH:
      renodx::utils::random::Use(fdw_reason);
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);
      renodx::utils::resource::Use(fdw_reason);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::draw>(OnDrawForLUTDump);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  return TRUE;
}
