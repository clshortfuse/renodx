#pragma once

#define ImTextureID ImU64

#include <functional>
#include <optional>
#include <string>
#include <vector>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "./mutex.hpp"

#define ICON_FK_UNDO u8"\uf0e2"

namespace renodx::utils::settings {

extern "C" __declspec(dllexport) const char* const NAME;

static bool use_presets = true;
static std::string overlay_title = NAME;
static std::string global_name = "renodx";
static int preset_index = 1;
static std::vector<std::string> preset_strings = {
    "Off",
    "Preset #1",
    "Preset #2",
    "Preset #3",
};

static std::vector<std::function<void()>> on_preset_off_callbacks;
static std::vector<std::function<void()>> on_preset_changed_callbacks;

static ImVec4 ImVec4FromHex(uint32_t hex) {
  return {
      static_cast<float>((hex >> (8 * 2)) & 0xFF) / 255.f,
      static_cast<float>((hex >> (8 * 1)) & 0xFF) / 255.f,
      static_cast<float>((hex >> (8 * 0)) & 0xFF) / 255.f,
      1.f,
  };
};

enum class SettingValueType : uint8_t {
  FLOAT = 0,
  INTEGER = 1,
  BOOLEAN = 2,
  BUTTON = 3,
  LABEL = 4,
  BULLET = 5,
  TEXT = 6,
  TEXT_NOWRAP = 7,
  CUSTOM = 8,
};

struct Setting {
  std::string key;
  float* binding = nullptr;
  SettingValueType value_type = SettingValueType::FLOAT;
  float default_value = 0.f;
  bool can_reset = true;
  std::string label = key;
  std::string section;
  std::string group;
  std::string tooltip;
  std::vector<std::string> labels;
  std::optional<uint32_t> tint;  // HEX notation
  float min = 0.f;
  float max = 100.f;
  std::string format = "%.0f";

  std::function<bool()> is_enabled = [] {
    return true;
  };

  std::function<float(float value)> parse = [](float value) {
    return value;
  };

  std::function<void()> on_change = [] {};

  std::function<void(float previous, float current)> on_change_value = [](float previous, float current) {};

  // Return true to save settings
  std::function<bool()> on_click = [] { return true; };

  // Return true if value is changed
  std::function<bool()> on_draw = [] { return false; };

  bool is_global = false;

  std::function<bool()> is_visible = [] {
    return true;
  };

  bool is_sticky = false;

  float value = default_value;
  int value_as_int = static_cast<int>(default_value);

  [[nodiscard]]
  float GetMax() const {
    switch (this->value_type) {
      case SettingValueType::BOOLEAN:
        return 1.f;
      case SettingValueType::INTEGER:
        return this->labels.empty()
                   ? this->max
                   : (this->labels.size() - 1);
      case SettingValueType::FLOAT:
      default:
        return this->max;
    }
  }

  [[nodiscard]]
  float GetValue() const {
    switch (this->value_type) {
      default:
      case SettingValueType::FLOAT:
        return this->value;
        break;
      case SettingValueType::INTEGER:
        return static_cast<float>(this->value_as_int);
        break;
      case SettingValueType::BOOLEAN:
        return ((this->value_as_int == 0) ? 0.f : 1.f);
        break;
    }
  }

  Setting* Set(float value) {
    this->value = value;
    this->value_as_int = static_cast<int>(value);
    return this;
  }

  Setting* Write() {
    if (this->binding != nullptr) {
      *this->binding = this->parse(this->GetValue());
    }
    return this;
  }
};

using Settings = std::vector<Setting*>;
static Settings* settings = nullptr;

#define RENODX_JOIN_MACRO(x, y) x##y

#define AddDebugSetting(injection, name)                  \
  new renodx::utils::settings::Setting {                  \
    .key = "debug" #name,                                 \
    .binding = &RENODX_JOIN_MACRO(injection.debug, name), \
    .default_value = 1.f,                                 \
    .label = "Debug" #name,                               \
    .section = "Debug",                                   \
    .max = 2.f,                                           \
    .format = "%.2f",                                     \
  }

static Setting* FindSetting(const std::string& key) {
  for (auto* setting : *settings) {
    if (setting->key == key) {
      return setting;
    }
  }
  return nullptr;
}

static bool UpdateSetting(const std::string& key, float value) {
  auto* setting = FindSetting(key);
  if (setting == nullptr) return false;
  const std::unique_lock lock(renodx::utils::mutex::global_mutex);
  setting->Set(value)->Write();
  return true;
}

static void ResetSettings(bool reset_global = false) {
  const std::unique_lock lock(renodx::utils::mutex::global_mutex);
  for (auto* setting : *settings) {
    if (setting->key.empty()) continue;
    if (setting->is_global && !reset_global) continue;
    if (!setting->can_reset) continue;
    setting->Set(setting->default_value)->Write();
  }
}

static bool UpdateSettings(const std::vector<std::pair<std::string, float>>& pairs) {
  bool missing_key = false;
  const std::unique_lock lock(renodx::utils::mutex::global_mutex);
  for (const auto& [key, value] : pairs) {
    auto* setting = FindSetting(key);
    if (setting == nullptr) {
      missing_key = true;
    } else {
      setting->Set(value)->Write();
    }
  }
  return !missing_key;
}

static void LoadSetting(const std::string& section, Setting* setting) {
  switch (setting->value_type) {
    case SettingValueType::FLOAT:
      if (!reshade::get_config_value(nullptr, section.c_str(), setting->key.c_str(), setting->value)) {
        setting->value = setting->default_value;
      }
      if (setting->value > setting->GetMax()) {
        setting->value = setting->GetMax();
      } else if (setting->value < setting->min) {
        setting->value = setting->min;
      }
      break;
    case SettingValueType::BOOLEAN:
    case SettingValueType::INTEGER:
      if (!reshade::get_config_value(nullptr, section.c_str(), setting->key.c_str(), setting->value_as_int)) {
        setting->value_as_int = static_cast<int>(setting->default_value);
      }
      if (setting->value_as_int > setting->GetMax()) {
        setting->value_as_int = setting->GetMax();
      } else if (setting->value_as_int < static_cast<int>(setting->min)) {
        setting->value_as_int = static_cast<int>(setting->min);
      }
      break;
    default:
      break;
  }
}

static void LoadSettings(const std::string& section) {
  for (auto* setting : *settings) {
    if (setting->is_global) continue;
    LoadSetting(section, setting);
    const std::unique_lock lock(renodx::utils::mutex::global_mutex);
    setting->Write();
  }
}

static void LoadGlobalSettings() {
  for (auto* setting : *settings) {
    switch (setting->value_type) {
      if (!setting->is_global) continue;
      case SettingValueType::FLOAT:
        if (!reshade::get_config_value(nullptr, global_name.c_str(), setting->key.c_str(), setting->value)) {
          setting->value = setting->default_value;
        }
        if (setting->value > setting->GetMax()) {
          setting->value = setting->GetMax();
        } else if (setting->value < setting->min) {
          setting->value = setting->min;
        }
        break;
      case SettingValueType::BOOLEAN:
      case SettingValueType::INTEGER:
        if (!reshade::get_config_value(nullptr, global_name.c_str(), setting->key.c_str(), setting->value_as_int)) {
          setting->value_as_int = static_cast<int>(setting->default_value);
        }
        if (setting->value_as_int > setting->GetMax()) {
          setting->value_as_int = setting->GetMax();
        } else if (setting->value_as_int < static_cast<int>(setting->min)) {
          setting->value_as_int = static_cast<int>(setting->min);
        }
        break;
      default:
        break;
    }
    setting->Write();
  }
}

static std::string GetCurrentPresetName() {
  switch (preset_index) {
    case 1:
      return global_name + "-preset1";
      break;
    case 2:
      return global_name + "-preset2";
      break;
    case 3:
      return global_name + "-preset3";
      break;
  }
  return "";
}

static void SaveSettings(const std::string& section = GetCurrentPresetName()) {
  for (auto* setting : *settings) {
    if (setting->key.empty()) continue;
    if (setting->is_global) continue;
    switch (setting->value_type) {
      case SettingValueType::FLOAT:
        reshade::set_config_value(nullptr, section.c_str(), setting->key.c_str(), setting->value);
        break;
      case SettingValueType::INTEGER:
      case SettingValueType::BOOLEAN:
        reshade::set_config_value(nullptr, section.c_str(), setting->key.c_str(), setting->value_as_int);
        break;
      default:
        break;
    }
  }
}

static void SaveGlobalSettings() {
  for (auto* setting : *settings) {
    if (setting->key.empty()) continue;
    if (!setting->is_global) continue;
    switch (setting->value_type) {
      case SettingValueType::FLOAT:
        reshade::set_config_value(nullptr, global_name.c_str(), setting->key.c_str(), setting->value);
        break;
      case SettingValueType::INTEGER:
      case SettingValueType::BOOLEAN:
        reshade::set_config_value(nullptr, global_name.c_str(), setting->key.c_str(), setting->value_as_int);
        break;
      default:
        break;
    }
  }
}

static std::string ReadGlobalString(const std::string& key) {
  char temp[256] = "";
  size_t size = 256;
  if (reshade::get_config_value(nullptr, global_name.c_str(), key.c_str(), temp, &size)) {
    std::string temp_string = std::string(temp);
    auto pos = temp_string.find_last_not_of("\t\n\v\f\r ");
    if (pos != std::string_view::npos) {
      temp_string = {temp_string.data(), temp_string.data() + pos + 1};
    }
    return temp_string;
  }
  return "";
}

static void WriteGlobalString(const std::string& key, const std::string& value) {
  reshade::set_config_value(nullptr, global_name.c_str(), key.c_str(), value.c_str());
}

// Runs first
// https://pthom.github.io/imgui_manual_online/manual/imgui_manual.html
static void OnRegisterOverlay(reshade::api::effect_runtime* runtime) {
  bool changed_preset = false;
  bool has_drawn_presets = !use_presets;

  auto draw_presets = [&]() {
    if (use_presets) {
      changed_preset = ImGui::SliderInt(
          "Preset",
          &preset_index,
          0,
          preset_strings.size() - 1,
          preset_strings[preset_index].c_str(),
          ImGuiSliderFlags_NoInput);
    }

    if (changed_preset) {
      switch (preset_index) {
        case 0:
          for (auto& callback : on_preset_off_callbacks) {
            callback();
          }
          break;
        case 1:
          LoadSettings(global_name + "-preset1");
          break;
        case 2:
          LoadSettings(global_name + "-preset2");
          break;
        case 3:
          LoadSettings(global_name + "-preset3");
          break;
      }
      for (auto& callback : on_preset_changed_callbacks) {
        callback();
      }
    }
    has_drawn_presets = true;
  };

  bool any_change = false;
  std::string last_section;
  std::string last_group;
  bool open_section = true;
  bool open_node = false;
  bool has_indent = false;
  for (auto* setting : *settings) {
    if (setting->is_visible != nullptr && !setting->is_visible()) continue;

    if (!setting->is_sticky) {
      if (!has_drawn_presets) {
        draw_presets();
      }
    }

    int styles_pushed = 0;
    if (setting->tint.has_value()) {
      auto target_rgb = ImVec4FromHex(setting->tint.value());
      float target_hsv[3] = {};
      ImGui::ColorConvertRGBtoHSV(target_rgb.x, target_rgb.y, target_rgb.z, target_hsv[0], target_hsv[1], target_hsv[2]);

      static const auto COMMON_STYLES =
          {
              ImGuiCol_FrameBg,
              ImGuiCol_FrameBgHovered,
              ImGuiCol_FrameBgActive,
              ImGuiCol_SliderGrab,
              ImGuiCol_SliderGrabActive,
              ImGuiCol_Button,
              ImGuiCol_ButtonActive,
              ImGuiCol_ButtonHovered,
              ImGuiCol_TextSelectedBg,
              ImGuiCol_Header,
              ImGuiCol_HeaderHovered,
              ImGuiCol_HeaderActive,
          };

      static const auto TEXT_STYLES = {
          ImGuiCol_Text,
          ImGuiCol_TextDisabled,
      };
      if (setting->value_type == SettingValueType::TEXT
          || setting->value_type == SettingValueType::TEXT_NOWRAP) {
        for (const auto style : TEXT_STYLES) {
          auto style_rgb = ImGui::GetStyleColorVec4(style);
          style_rgb.x = target_rgb.x;
          style_rgb.y = target_rgb.y;
          style_rgb.z = target_rgb.z;
          ImGui::PushStyleColor(style, style_rgb);
        }
        styles_pushed = TEXT_STYLES.size();
      } else {
        for (const auto style : COMMON_STYLES) {
          auto style_rgb = ImGui::GetStyleColorVec4(style);
          float style_hsv[3] = {};
          ImGui::ColorConvertRGBtoHSV(style_rgb.x, style_rgb.y, style_rgb.z, style_hsv[0], style_hsv[1], style_hsv[2]);

          ImGui::ColorConvertHSVtoRGB(target_hsv[0], style_hsv[1], style_hsv[2], style_rgb.x, style_rgb.y, style_rgb.z);
          ImGui::PushStyleColor(style, style_rgb);
        }
        styles_pushed = COMMON_STYLES.size();
      }
    }

    if (last_section != setting->section) {
      last_section.assign(setting->section);

      if (open_node) {
        // TreePop will call unindent
        ImGui::Indent();
        ImGui::TreePop();
      }
      open_node = ImGui::TreeNodeEx(
          setting->section.c_str(),
          ImGuiTreeNodeFlags_DefaultOpen | ImGuiTreeNodeFlags_SpanFullWidth);
      if (open_node) {
        ImGui::Unindent();
      }

      open_section = open_node;
    }

    if (open_section) {
      if (!last_group.empty() && !setting->group.empty() && last_group == setting->group) {
        ImGui::SameLine();
      }

      last_group = setting->group;

      const bool is_disabled = preset_index == 0
                               || (setting->is_enabled != nullptr
                                   && !setting->is_enabled());
      if (is_disabled) {
        ImGui::BeginDisabled();
      }
      bool changed = false;
      float previous_value = setting->GetValue();
      ImGui::PushID(("##Key" + (setting->key.empty() ? setting->label : setting->key)).c_str());
      switch (setting->value_type) {
        case SettingValueType::FLOAT:
          changed |= ImGui::SliderFloat(
              setting->label.c_str(),
              &setting->value,
              setting->min,
              setting->max,
              setting->format.c_str());
          break;
        case SettingValueType::INTEGER:
          changed |= ImGui::SliderInt(
              setting->label.c_str(),
              &setting->value_as_int,
              setting->min,
              setting->GetMax(),
              setting->labels.empty()
                  ? setting->format.c_str()
                  : setting->labels.at(setting->value_as_int).c_str(),
              ImGuiSliderFlags_NoInput);
          break;
        case SettingValueType::BOOLEAN:
          changed |= ImGui::SliderInt(
              setting->label.c_str(),
              &setting->value_as_int,
              0,
              1,
              setting->labels.empty()
                  ? ((setting->value_as_int == 0) ? "Off" : "On")  // NOLINT(readability-avoid-nested-conditional-operator)
                  : setting->labels.at(setting->value_as_int).c_str(),
              ImGuiSliderFlags_NoInput);
          break;
        case SettingValueType::BUTTON:
          if (ImGui::Button(setting->label.c_str())) {
            changed = setting->on_click();
          }
          break;
        case SettingValueType::LABEL:
          ImGui::LabelText(setting->label.c_str(), "%s", setting->labels[0].c_str());
          break;
        case SettingValueType::BULLET:
          ImGui::BulletText(setting->label.c_str(), "");
          break;
        case SettingValueType::TEXT:
          ImGui::TextWrapped("%s", setting->label.c_str());
          break;
        case SettingValueType::TEXT_NOWRAP:
          ImGui::Text(setting->label.c_str(), "");
          break;
        case SettingValueType::CUSTOM:
          changed |= setting->on_draw();
          break;
      }
      ImGui::PopID();
      if (changed) {
        setting->on_change();
      }
      if (!setting->tooltip.empty()) {
        ImGui::SetItemTooltip("%s", setting->tooltip.c_str());
      }

      if (preset_index != 0
          && setting->can_reset
          && setting->value_type < SettingValueType::BUTTON) {
        ImGui::SameLine();
        const bool is_using_default = (setting->GetValue() == setting->default_value);
        ImGui::BeginDisabled(is_using_default);
        if (is_using_default) {
          ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(ImColor::HSV(0, 0, 0.6f)));
          ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(ImColor::HSV(0, 0, 0.7f)));
          ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImVec4(ImColor::HSV(0, 0, 0.8f)));
        }
        auto* font = ImGui::GetFont();
        auto old_scale = font->Scale;
        auto previous_font_size = ImGui::GetFontSize();
        font->Scale *= 0.75f;
        ImGui::PushFont(font);
        auto current_font_size = ImGui::GetFontSize();

        ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, current_font_size * 2);

        ImVec2 cursor_pos = ImGui::GetCursorPos();
        cursor_pos.y += (previous_font_size / 2.f) - (current_font_size / 2.f);
        ImGui::SetCursorPos(cursor_pos);

        ImGui::PushID(("##Reset" + setting->label).c_str());
        if (ImGui::Button(reinterpret_cast<const char*>(ICON_FK_UNDO))) {
          setting->Set(setting->default_value);
          changed = true;
        }
        ImGui::PopID();

        if (is_using_default) {
          ImGui::PopStyleColor(3);
        }
        font->Scale = old_scale;
        ImGui::PopFont();
        ImGui::PopStyleVar();
        ImGui::EndDisabled();
      }

      if (changed) {
        const std::unique_lock lock(renodx::utils::mutex::global_mutex);
        setting->Write();
        any_change = true;
        setting->on_change_value(previous_value, setting->GetValue());
      }
      if (is_disabled) {
        ImGui::EndDisabled();
      }
    }
    ImGui::PopStyleColor(styles_pushed);
  }
  if (open_node) {
    ImGui::Indent();
    ImGui::TreePop();
  }

  if (!has_drawn_presets) {
    draw_presets();
  }
  if (!changed_preset && any_change) {
    switch (preset_index) {
      case 1:
        SaveSettings(global_name + "-preset1");
        break;
      case 2:
        SaveSettings(global_name + "-preset2");
        break;
      case 3:
        SaveSettings(global_name + "-preset3");
        break;
    }
    SaveGlobalSettings();
  }
}

static bool attached = false;

static void Use(DWORD fdw_reason, Settings* new_settings, void (*new_on_preset_off)() = nullptr) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;

      settings = new_settings;
      if (new_on_preset_off != nullptr) {
        on_preset_off_callbacks.emplace_back(new_on_preset_off);
      }
      LoadGlobalSettings();
      LoadSettings(global_name + "-preset1");
      reshade::register_overlay(overlay_title.c_str(), OnRegisterOverlay);

      break;
    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
      reshade::unregister_overlay(overlay_title.c_str(), OnRegisterOverlay);
      break;
  }
}

}  // namespace renodx::utils::settings
