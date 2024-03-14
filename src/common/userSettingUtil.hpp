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
    std::vector<const char*> labels = {};
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

  typedef std::vector<UserSetting*> UserSettings;
  UserSettings* _userSettings = nullptr;

  bool useRenoDXHelper = false;

  static UserSetting* findUserSetting(const char* key) {
    for (auto setting : *_userSettings) {
      if (strcmp(setting->key, key) == 0) {
        return setting;
      }
    }
    return nullptr;
  }

  static bool updateUserSetting(const char* key, float value) {
    auto setting = findUserSetting(key);
    if (setting == nullptr) return false;
    setting->set(value)->write();
    return true;
  }

  static void load_settings(
    reshade::api::effect_runtime* runtime = nullptr,
    const char* section = "renodx-preset1"
  ) {
    for (auto setting : *_userSettings) {
      switch (setting->valueType) {
        default:
        case UserSettingValueType::floating:
          if (!reshade::get_config_value(runtime, section, setting->key, setting->value)) {
            setting->value = setting->defaultValue;
          }
          break;
        case UserSettingValueType::boolean:
        case UserSettingValueType::integer:
          if (!reshade::get_config_value(runtime, section, setting->key, setting->valueAsInt)) {
            setting->valueAsInt = static_cast<int>(setting->defaultValue);
          }
          break;
      }
      setting->write();
    }
  }

  static void save_settings(reshade::api::effect_runtime* runtime, const char* section = "renodx-preset1") {
    for (auto setting : *_userSettings) {
      switch (setting->valueType) {
        default:
        case UserSettingValueType::floating:
          reshade::set_config_value(runtime, section, setting->key, setting->value);
          break;
        case UserSettingValueType::integer:
        case UserSettingValueType::boolean:
          reshade::set_config_value(runtime, section, setting->key, setting->valueAsInt);
          break;
      }
    }
  }

  static void updateRenoDXHelper(reshade::api::effect_runtime* runtime, float toneMapUINits = 0) {
    auto technique = runtime->find_technique("RenoDXHelper.addonfx", "RenoDXHelper");

    if (!technique.handle) return;

    if (!useRenoDXHelper) {
      runtime->set_technique_state(technique, false);
      return;
    }
    auto variable = runtime->find_uniform_variable("RenoDXHelper.addonfx", "RENODX_UI_NITS");
    if (!variable.handle) return;
    runtime->set_technique_state(technique, true);
    if (toneMapUINits <= 0.f) {
      auto setting = findUserSetting("toneMapUINits");
      if (setting) {
        toneMapUINits = setting->value;
      } else {
        return;
      }
    }
    runtime->set_uniform_value_float(variable, toneMapUINits);
  }

  static void on_reshade_begin_effects(
    reshade::api::effect_runtime* runtime,
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    reshade::api::resource_view rtv_srgb
  ) {
    // run once
    updateRenoDXHelper(runtime);
    reshade::unregister_event<reshade::addon_event::reshade_begin_effects>(on_reshade_begin_effects);
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
      updateRenoDXHelper(runtime);
    }

    bool anyChange = false;
    std::string lastSection = "";
    for (auto setting : *_userSettings) {
      if (lastSection.compare(setting->section) != 0) {
        ImGui::SeparatorText(setting->section);
        lastSection.assign(setting->section);
      }
      bool isDisabled = presetIndex == 0
                     || (setting->isEnabled != nullptr
                         && !setting->isEnabled());
      if (isDisabled) {
        ImGui::BeginDisabled();
      }
      bool changed = false;
      switch (setting->valueType) {
        case UserSettingValueType::floating:
          changed |= ImGui::SliderFloat(
            setting->label,
            &setting->value,
            setting->min,
            setting->max,
            setting->format
          );
          break;
        case UserSettingValueType::integer:
          changed |= ImGui::SliderInt(
            setting->label,
            &setting->valueAsInt,
            setting->min,
            setting->labels.size() ? setting->labels.size() - 1 : setting->min,
            setting->labels.size() ? setting->labels.at(setting->valueAsInt) : setting->format,
            ImGuiSliderFlags_NoInput
          );
          break;
        case UserSettingValueType::boolean:
          changed |= ImGui::SliderInt(
            setting->label,
            &setting->valueAsInt,
            0,
            1,
            setting->labels.size()
              ? setting->labels.at(setting->valueAsInt)
              : (setting->valueAsInt ? "On" : "Off"),
            ImGuiSliderFlags_NoInput
          );
          break;
      }
      if (strlen(setting->tooltip) != 0) {
        ImGui::SetItemTooltip(setting->tooltip);
      }

      if (changed) {
        setting->write();
        if (useRenoDXHelper && strcmp(setting->key, "toneMapUINits") == 0) {
          updateRenoDXHelper(runtime, setting->value);
        }
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
        reshade::register_event<reshade::addon_event::reshade_begin_effects>(on_reshade_begin_effects);

        break;
      case DLL_PROCESS_DETACH:
        reshade::unregister_overlay("RenoDX", on_register_overlay);
        break;
    }
  }

}  // namespace UserSettingUtil
