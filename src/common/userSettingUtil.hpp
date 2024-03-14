#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H
#define ImTextureID ImU64

#include <map>
#include <string>
#include <vector>

#include "../../external/reshade/deps/imgui/imgui.h"
#include "../../external/reshade/include/reshade.hpp"

namespace UserSettingUtil {

  static int presetIndex = 1;
  static const char* presetStrings[] = {
    "Off",
    "Preset #1",
    "Preset #2",
    "Preset #3",
  };

  static void (*_onPresetOff)();

  enum class UserSettingValueType : uint32_t {
    floating = 0,
    integer = 1,
    boolean = 2
  };

  struct UserSetting {
    const char* key;
    float* binding;
    UserSettingValueType valueType = UserSettingValueType::floating;
    float defaultValue = 0.f;
    const char* label = key;
    const char* section = "";
    char const* tooltip = "";
    std::vector<char*> labels = {};
    float min = 0.f;
    float max = 100.f;
    char const* format = "%.f";
    bool (*isEnabled)() = [] {
      return true;
    };

    float (*parse)(float value) = [](float value) {
      return value;
    };

    UserSetting* write() {
      switch (this->valueType) {
        default:
        case UserSettingValueType::floating:
          *this->binding = this->parse(this->value);
          break;
        case UserSettingValueType::integer:
          *this->binding = this->parse(static_cast<float>(this->valueAsInt));
          break;
        case UserSettingValueType::boolean:
          *this->binding = this->parse(this->valueAsInt) ? 1.f : 0.f;
          break;
      }
      return this;
    }

    float value = defaultValue;
    int valueAsInt = static_cast<int>(defaultValue);

    UserSetting* set(float value) {
      this->value = value;
      this->valueAsInt = (int)value;
      return this;
    }
  };

  typedef std::map<const char*, UserSetting*> UserSettings;
  UserSettings* _userSettings = nullptr;

  static void load_settings(
    reshade::api::effect_runtime* runtime = nullptr,
    const char* section = "renodx-preset1"
  ) {
    UserSettings settings = *_userSettings;
    for (auto pair : settings) {
      auto key = pair.first;
      auto userSetting = pair.second;
      switch (userSetting->valueType) {
        default:
        case UserSettingValueType::floating:
          if (!reshade::get_config_value(runtime, section, key, userSetting->value)) {
            userSetting->value = userSetting->defaultValue;
          }
          break;
        case UserSettingValueType::integer:
          if (!reshade::get_config_value(runtime, section, key, userSetting->valueAsInt)) {
            userSetting->valueAsInt = static_cast<int>(userSetting->defaultValue);
          }
          break;
        case UserSettingValueType::boolean:
          if (!reshade::get_config_value(runtime, section, key, userSetting->valueAsInt)) {
            userSetting->valueAsInt = userSetting->defaultValue ? 1.f : 0.f;
          }
          break;
      }
      userSetting->write();
    }
  }

  static void save_settings(reshade::api::effect_runtime* runtime, char* section = "renodx-preset1") {
    UserSettings settings = *_userSettings;
    for (auto pair : settings) {
      auto key = pair.first;
      auto userSetting = pair.second;
      switch (userSetting->valueType) {
        default:
        case UserSettingValueType::floating:
          reshade::set_config_value(runtime, section, key, userSetting->value);
          break;
        case UserSettingValueType::integer:
          reshade::set_config_value(runtime, section, key, userSetting->valueAsInt);
        case UserSettingValueType::boolean:
          reshade::set_config_value(runtime, section, key, userSetting->valueAsInt);
          break;
      }
    }
  }

  // Runs first
  static void on_register_overlay(reshade::api::effect_runtime* runtime) {
    bool changedPreset = ImGui::SliderInt(
      "Preset",
      &presetIndex,
      0,
      (sizeof(presetStrings) / sizeof(char*)) - 1,
      presetStrings[presetIndex],
      ImGuiSliderFlags_NoInput
    );

    if (changedPreset) {
      switch (presetIndex) {
        case 0:
          if (_onPresetOff != nullptr) {
            _onPresetOff();
          }
          break;
        case 1:
          load_settings(runtime);
          break;
        case 2:
          load_settings(runtime, "renodx-preset2");
          break;
        case 3:
          load_settings(runtime, "renodx-preset3");
          break;
      }
    }

    bool anyChange = false;
    std::string lastSection = "";
    UserSettings settings = *_userSettings;
    for (auto pair : settings) {
      auto key = pair.first;
      auto userSetting = pair.second;

      if (lastSection.compare(userSetting->section) != 0) {
        ImGui::SeparatorText(userSetting->section);
        lastSection.assign(userSetting->section);
      }
      bool isDisabled = presetIndex == 0
                     || (userSetting->isEnabled != nullptr
                         && !userSetting->isEnabled());
      if (isDisabled) {
        ImGui::BeginDisabled();
      }
      bool changed = false;
      switch (userSetting->valueType) {
        case UserSettingValueType::floating:
          changed |= ImGui::SliderFloat(
            userSetting->label,
            &userSetting->value,
            userSetting->min,
            userSetting->max,
            userSetting->format
          );
          break;
        case UserSettingValueType::integer:
          changed |= ImGui::SliderInt(
            userSetting->label,
            &userSetting->valueAsInt,
            userSetting->min,
            userSetting->labels.size() ? userSetting->labels.size() - 1 : userSetting->min,
            userSetting->labels.size() ? userSetting->labels.at(userSetting->valueAsInt) : userSetting->format,
            ImGuiSliderFlags_NoInput
          );
          break;
        case UserSettingValueType::boolean:
          changed |= ImGui::SliderInt(
            userSetting->label,
            &userSetting->valueAsInt,
            0,
            1,
            userSetting->labels.size()
              ? userSetting->labels.at(userSetting->valueAsInt)
              : (userSetting->valueAsInt ? "On" : "Off"),
            ImGuiSliderFlags_NoInput
          );
          break;
      }
      if (strlen(userSetting->tooltip) != 0) {
        ImGui::SetItemTooltip(userSetting->tooltip);
      }
      if (changed) {
        userSetting->write();
        anyChange = true;
      }
      if (isDisabled) {
        ImGui::EndDisabled();
      }
    }
    if (!changedPreset && anyChange) {
      switch (presetIndex) {
        case 1:
          save_settings(runtime, "renodx-preset1");
          break;
        case 2:
          save_settings(runtime, "renodx-preset2");
          break;
        case 3:
          save_settings(runtime, "renodx-preset3");
          break;
      }
    }
  }

  static void use(DWORD fdwReason, UserSettings* userSettings, void (*onPresetOff)() = nullptr) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        _userSettings = userSettings;
        _onPresetOff = onPresetOff;
        load_settings();
        reshade::register_overlay("RenoDX", on_register_overlay);

        break;
      case DLL_PROCESS_DETACH:
        reshade::unregister_overlay("RenoDX", on_register_overlay);
        break;
    }
  }

}  // namespace UserSettingUtil
