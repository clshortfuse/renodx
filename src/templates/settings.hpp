#include <exception>
#include <initializer_list>
#include <map>
#include <optional>
#include <unordered_set>
#include <variant>
#include <vector>

#define ImTextureID ImU64

#include <deps/imgui/imgui.h>

#include "../utils/settings.hpp"

namespace renodx::templates::settings {

const std::vector<std::string> LABELS_UNSET = {};

struct SettingConfig {
  std::optional<std::string> key = std::nullopt;
  std::optional<float*> binding = std::nullopt;
  std::optional<renodx::utils::settings::SettingValueType> value_type = std::nullopt;
  std::optional<float> default_value = std::nullopt;
  std::optional<bool> can_reset = std::nullopt;
  std::optional<std::string> label = std::nullopt;
  std::optional<std::string> section = std::nullopt;
  std::optional<std::string> group = std::nullopt;
  std::optional<std::string> tooltip = std::nullopt;
  std::vector<std::string> labels = LABELS_UNSET;
  std::optional<uint32_t> tint;  // HEX notatio = std::nullopt;
  std::optional<float> min = std::nullopt;
  std::optional<float> max = std::nullopt;
  std::optional<std::string> format = std::nullopt;
  std::optional<std::function<bool()>> is_enabled = std::nullopt;
  std::optional<std::function<float(float value)>> parse = std::nullopt;
  std::optional<std::function<void()>> on_change = std::nullopt;
  std::optional<std::function<void(float previous, float current)>> on_change_value = std::nullopt;
  std::optional<std::function<bool()>> on_click = std::nullopt;
  std::optional<std::function<bool()>> on_draw = std::nullopt;
  std::optional<bool> is_global = std::nullopt;
  std::optional<std::function<bool()>> is_visible = std::nullopt;
};

float current_settings_mode = 0.f;

static const SettingConfig VISIBLE_INTERMEDIATE_CONFIG = {
    .is_visible = []() { return current_settings_mode >= 1.f; }};

static const SettingConfig VISIBLE_ADVANCED_CONFIG = {
    .is_visible = []() { return current_settings_mode >= 2.f; }};

static const SettingConfig SETTINGS_MODE_CONFIG = {
    .key = "SettingsMode",
    .binding = &current_settings_mode,
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 0.f,
    .can_reset = false,
    .label = "Settings Mode",
    .labels = {"Simple", "Intermediate", "Advanced"},
    .is_global = true,
};

static const SettingConfig TONE_MAP_TYPE_CONFIG = {
    .key = "ToneMapType",
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 1.f,
    .can_reset = true,
    .label = "Tone Mapper",
    .section = "Tone Mapping",
    .tooltip = "Sets the tone mapper type",
    .labels = {"Vanilla", "RenoDRT"},
    .parse = [](float value) { return value * 3.f; },
    .is_visible = []() { return current_settings_mode >= 1; },
};

static const SettingConfig PEAK_NITS_CONFIG = {
    .key = "ToneMapPeakNits",
    .default_value = 1000.f,
    .can_reset = false,
    .label = "Peak Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the value of peak white in nits",
    .min = 48.f,
    .max = 4000.f,
};

static const SettingConfig GAME_NITS_CONFIG = {
    .key = "ToneMapGameNits",
    .default_value = 203.f,
    .label = "Game Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the value of 100% white in nits",
    .min = 48.f,
    .max = 500.f,
};

static const SettingConfig UI_NITS_CONFIG = {
    .key = "ToneMapUINits",
    .default_value = 203.f,
    .label = "UI Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the brightness of UI and HUD elements in nits",
    .min = 48.f,
    .max = 500.f,
};

static const SettingConfig GAMMA_CORRECTION_CONFIG = {
    .key = "ToneMapGammaCorrection",
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 1.f,
    .label = "Gamma Correction",
    .section = "Tone Mapping",
    .tooltip = "Emulates a display EOTF.",
    .labels = {"Off", "2.2", "BT.1886"},
    .is_visible = []() { return current_settings_mode >= 1; },
};

static const SettingConfig TONE_MAP_SCALING_CONFIG = {
    .key = "ToneMapScaling",
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 0.f,
    .label = "Scaling",
    .section = "Tone Mapping",
    .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
    .labels = {"Luminance", "Per Channel"},
    .is_visible = []() { return current_settings_mode >= 2; },

};

static const SettingConfig TONE_MAP_WORKING_COLOR_SPACE_CONFIG = {
    .key = "ToneMapWorkingColorSpace",
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 0.f,
    .label = "Working Color Space",
    .section = "Tone Mapping",
    .labels = {"BT709", "BT2020", "AP1"},
    .is_visible = []() { return current_settings_mode >= 2; },
};

static const SettingConfig TONE_MAP_HUE_PROCESSOR_CONFIG = {
    .key = "ToneMapHueProcessor",
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 0.f,
    .label = "Hue Processor",
    .section = "Tone Mapping",
    .tooltip = "Selects hue processor",
    .labels = {"OKLab", "ICtCp", "darkTable UCS"},
    .is_visible = []() { return current_settings_mode >= 2; },
};

static const SettingConfig TONE_MAP_HUE_CORRECTION_CONFIG = {
    .key = "ToneMapHueCorrection",
    .default_value = 100.f,
    .label = "Hue Correction",
    .section = "Tone Mapping",
    .tooltip = "Hue retention strength.",
    .min = 0.f,
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; },
    .is_visible = []() { return current_settings_mode >= 1; },
};

static const SettingConfig TONE_MAP_HUE_SHIFT_CONFIG = {
    .key = "ToneMapHueShift",
    .default_value = 50.f,
    .label = "Hue Shift",
    .section = "Tone Mapping",
    .tooltip = "Hue-shift emulation strength.",
    .min = 0.f,
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; },
    .is_visible = []() { return current_settings_mode >= 1; },
};

static const SettingConfig TONE_MAP_CLAMP_COLOR_SPACE_CONFIG = {
    .key = "ToneMapClampColorSpace",
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 0.f,
    .label = "Clamp Color Space",
    .section = "Tone Mapping",
    .tooltip = "Hue-shift emulation strength.",
    .labels = {"None", "BT709", "BT2020", "AP1"},
    .parse = [](float value) { return value - 1.f; },
    .is_visible = []() { return current_settings_mode >= 2; },
};

static const SettingConfig TONE_MAP_CLAMP_PEAK_CONFIG = {
    .key = "ToneMapClampPeak",
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 0.f,
    .label = "Clamp Peak",
    .section = "Tone Mapping",
    .tooltip = "Hue-shift emulation strength.",
    .labels = {"None", "BT709", "BT2020", "AP1"},
    .parse = [](float value) { return value - 1.f; },
    .is_visible = []() { return current_settings_mode >= 2; },
};

static const SettingConfig SCENE_GRADE_STRENGTH_CONFIG = {
    .key = "SceneGradeStrength",
    .default_value = 100.f,
    .label = "Strength",
    .section = "Scene Grading",
    .tooltip = "Scene grading as applied by the game",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; },
    .is_visible = []() { return current_settings_mode >= 2; },
};

static const SettingConfig SCENE_GRADE_HUE_CORRECTION_CONFIG = {
    .key = "SceneGradeHueCorrection",
    .default_value = 100.f,
    .label = "Hue Correction",
    .section = "Scene Grading",
    .tooltip = "Corrects per-channel hue shifts from per-channel grading.",
    .min = 0.f,
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; },
    .is_visible = []() { return current_settings_mode >= 2; },
};

static const SettingConfig SCENE_GRADE_SATURATION_CORRECTION_CONFIG = {
    .key = "SceneGradeSaturationCorrection",
    .default_value = 100.f,
    .label = "Saturation Correction",
    .section = "Scene Grading",
    .tooltip = "Corrects unbalanced saturation from per-channel grading.",
    .min = 0.f,
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; },
    .is_visible = []() { return current_settings_mode >= 2; },
};

static const SettingConfig SCENE_GRADE_BLOWOUT_RESTORATION_CONFIG = {
    .key = "SceneGradeBlowoutRestoration",
    .default_value = 50.f,
    .label = "Blowout Restoration",
    .section = "Scene Grading",
    .tooltip = "Restores color from blowout from per-channel grading.",
    .min = 0.f,
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; },
    .is_visible = []() { return current_settings_mode >= 2; },
};

static const SettingConfig SCENE_GRADE_HUE_SHIFT_CONFIG = {
    .key = "SceneGradeHueShift",
    .default_value = 50.f,
    .label = "Hue Shift",
    .section = "Scene Grading",
    .tooltip = "Selects strength of hue shifts from per-channel grading.",
    .min = 0.f,
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; },
    .is_visible = []() { return current_settings_mode >= 2; },
};

static const SettingConfig COLOR_GRADE_EXPOSURE_CONFIG = {
    .key = "ColorGradeExposure",
    .default_value = 1.f,
    .label = "Exposure",
    .section = "Color Grading",
    .max = 2.f,
    .format = "%.2f",
    .is_visible = []() { return current_settings_mode >= 1; },
};

static const SettingConfig COLOR_GRADE_HIGHLIGHTS_CONFIG = {
    .key = "ColorGradeHighlights",
    .default_value = 50.f,
    .label = "Highlights",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; },
    .is_visible = []() { return current_settings_mode >= 1; },
};

static const SettingConfig COLOR_GRADE_SHADOWS_CONFIG = {
    .key = "ColorGradeShadows",
    .default_value = 50.f,
    .label = "Shadows",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; },
    .is_visible = []() { return current_settings_mode >= 1; },
};
static const SettingConfig COLOR_GRADE_CONTRAST_CONFIG = {
    .key = "ColorGradeContrast",
    .default_value = 50.f,
    .label = "Contrast",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; },
};

static const SettingConfig COLOR_GRADE_SATURATION_CONFIG = {
    .key = "ColorGradeSaturation",
    .default_value = 50.f,
    .label = "Saturation",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; },
};

static const SettingConfig COLOR_GRADE_HIGHLIGHT_SATURATION_CONFIG = {
    .key = "ColorGradeHighlightSaturation",
    .default_value = 50.f,
    .label = "Highlight Saturation",
    .section = "Color Grading",
    .tooltip = "Adds or removes highlight color.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; },
    .is_visible = []() { return current_settings_mode >= 1; },
};

static const SettingConfig COLOR_GRADE_BLOWOUT_CONFIG = {
    .key = "ColorGradeBlowout",
    .default_value = 0.f,
    .label = "Blowout",
    .section = "Color Grading",
    .tooltip = "Controls highlight desaturation due to overexposure.",
    .max = 100.f,
    .parse = [](float value) { return value * 0.01f; },
    .is_visible = []() { return current_settings_mode >= 1; },
};

static const SettingConfig COLOR_GRADE_FLARE_CONFIG = {
    .key = "ColorGradeFlare",
    .default_value = 0.f,
    .label = "Flare",
    .section = "Color Grading",
    .tooltip = "Flare/Glare Compensation",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; },
    .is_visible = []() { return current_settings_mode >= 1; },
};

static const SettingConfig FX_BLOOM_CONFIG = {
    .key = "FxBloom",
    .default_value = 50.f,
    .label = "Bloom",
    .section = "Effects",
    .parse = [](float value) { return value * 0.02f; },
};

static renodx::utils::settings::Setting* CreateSetting(const std::vector<SettingConfig>& configs) {
  auto* new_setting = new renodx::utils::settings::Setting();
  for (const auto& config : configs) {
    if (config.key.has_value()) new_setting->key = config.key.value();
    if (config.binding.has_value()) new_setting->binding = config.binding.value();
    if (config.value_type.has_value()) new_setting->value_type = config.value_type.value();
    if (config.default_value.has_value()) new_setting->default_value = config.default_value.value();
    if (config.can_reset.has_value()) new_setting->can_reset = config.can_reset.value();
    if (config.label.has_value()) new_setting->label = config.label.value();
    if (config.section.has_value()) new_setting->section = config.section.value();
    if (config.group.has_value()) new_setting->group = config.group.value();
    if (config.tooltip.has_value()) new_setting->tooltip = config.tooltip.value();
    if (!config.labels.empty()) new_setting->labels = config.labels;
    if (config.tint.has_value()) new_setting->tint = config.tint.value();
    if (config.min.has_value()) new_setting->min = config.min.value();
    if (config.max.has_value()) new_setting->max = config.max.value();
    if (config.format.has_value()) new_setting->format = config.format.value();
    if (config.is_enabled.has_value()) new_setting->is_enabled = config.is_enabled.value();
    if (config.parse.has_value()) new_setting->parse = config.parse.value();
    if (config.on_change.has_value()) new_setting->on_change = config.on_change.value();
    if (config.on_change_value.has_value()) new_setting->on_change_value = config.on_change_value.value();
    if (config.on_click.has_value()) new_setting->on_click = config.on_click.value();
    if (config.on_draw.has_value()) new_setting->on_draw = config.on_draw.value();
    if (config.is_global.has_value()) new_setting->is_global = config.is_global.value();
    if (config.is_visible.has_value()) new_setting->is_visible = config.is_visible.value();
  }
  return new_setting;
}

static renodx::utils::settings::Setting* CreateSetting(const SettingConfig& config) {
  return CreateSetting(std::vector<SettingConfig>({config}));
}

static std::vector<renodx::utils::settings::Setting*> CreateSettings(const std::vector<std::vector<SettingConfig>>& configs) {
  std::vector<renodx::utils::settings::Setting*> settings;
  for (const auto& config : configs) {
    auto* setting = CreateSetting(config);
    settings.push_back(setting);
  }
  return settings;
}

static std::vector<renodx::utils::settings::Setting*> CreateDefaultSettings(const std::vector<std::pair<std::string, const SettingConfig>>& default_settings) {
  std::vector<renodx::utils::settings::Setting*> settings = {CreateSetting(SETTINGS_MODE_CONFIG)};
  for (const auto& [key, value] : default_settings) {
    if (key == "ToneMapType") {
      settings.push_back(CreateSetting({TONE_MAP_TYPE_CONFIG, value}));
    } else if (key == "ToneMapPeakNits") {
      settings.push_back(CreateSetting({PEAK_NITS_CONFIG, value}));
    } else if (key == "ToneMapGameNits") {
      settings.push_back(CreateSetting({GAME_NITS_CONFIG, value}));
    } else if (key == "ToneMapUINits") {
      settings.push_back(CreateSetting({UI_NITS_CONFIG, value}));
    } else if (key == "ToneMapGammaCorrection") {
      settings.push_back(CreateSetting({GAMMA_CORRECTION_CONFIG, value}));
    } else if (key == "ToneMapScaling") {
      settings.push_back(CreateSetting({TONE_MAP_SCALING_CONFIG, value}));
    } else if (key == "ToneMapWorkingColorSpace") {
      settings.push_back(CreateSetting({TONE_MAP_WORKING_COLOR_SPACE_CONFIG, value}));
    } else if (key == "ToneMapHueProcessor") {
      settings.push_back(CreateSetting({TONE_MAP_HUE_PROCESSOR_CONFIG, value}));
    } else if (key == "ToneMapHueCorrection") {
      settings.push_back(CreateSetting({TONE_MAP_HUE_CORRECTION_CONFIG, value}));
    } else if (key == "ToneMapHueShift") {
      settings.push_back(CreateSetting({TONE_MAP_HUE_SHIFT_CONFIG, value}));
    } else if (key == "ToneMapClampColorSpace") {
      settings.push_back(CreateSetting({TONE_MAP_CLAMP_COLOR_SPACE_CONFIG, value}));
    } else if (key == "ToneMapClampPeak") {
      settings.push_back(CreateSetting({TONE_MAP_CLAMP_PEAK_CONFIG, value}));
    } else if (key == "SceneGradeStrength") {
      settings.push_back(CreateSetting({SCENE_GRADE_STRENGTH_CONFIG, value}));
    } else if (key == "SceneGradeHueCorrection") {
      settings.push_back(CreateSetting({SCENE_GRADE_HUE_CORRECTION_CONFIG, value}));
    } else if (key == "SceneGradeSaturationCorrection") {
      settings.push_back(CreateSetting({SCENE_GRADE_SATURATION_CORRECTION_CONFIG, value}));
    } else if (key == "SceneGradeBlowoutRestoration") {
      settings.push_back(CreateSetting({SCENE_GRADE_BLOWOUT_RESTORATION_CONFIG, value}));
    } else if (key == "SceneGradeHueShift") {
      settings.push_back(CreateSetting({SCENE_GRADE_HUE_SHIFT_CONFIG, value}));
    } else if (key == "ColorGradeExposure") {
      settings.push_back(CreateSetting({COLOR_GRADE_EXPOSURE_CONFIG, value}));
    } else if (key == "ColorGradeHighlights") {
      settings.push_back(CreateSetting({COLOR_GRADE_HIGHLIGHTS_CONFIG, value}));
    } else if (key == "ColorGradeShadows") {
      settings.push_back(CreateSetting({COLOR_GRADE_SHADOWS_CONFIG, value}));
    } else if (key == "ColorGradeContrast") {
      settings.push_back(CreateSetting({COLOR_GRADE_CONTRAST_CONFIG, value}));
    } else if (key == "ColorGradeSaturation") {
      settings.push_back(CreateSetting({COLOR_GRADE_SATURATION_CONFIG, value}));
    } else if (key == "ColorGradeHighlightSaturation") {
      settings.push_back(CreateSetting({COLOR_GRADE_HIGHLIGHT_SATURATION_CONFIG, value}));
    } else if (key == "ColorGradeBlowout") {
      settings.push_back(CreateSetting({COLOR_GRADE_BLOWOUT_CONFIG, value}));
    } else if (key == "ColorGradeFlare") {
      settings.push_back(CreateSetting({COLOR_GRADE_FLARE_CONFIG, value}));
    } else if (key == "FxBloom") {
      settings.push_back(CreateSetting({FX_BLOOM_CONFIG, value}));
    } else {
      throw std::runtime_error("Unknown setting key: " + key);
    }
  }
  return settings;
}

static std::vector<renodx::utils::settings::Setting*> CreateDefaultSettings(const std::vector<std::pair<std::string, float*>>& bindings) {
  std::vector<renodx::utils::settings::Setting*> settings = {CreateSetting(SETTINGS_MODE_CONFIG)};
  for (const auto& [key, binding] : bindings) {
    if (key == "ToneMapType") {
      settings.push_back(CreateSetting({TONE_MAP_TYPE_CONFIG, {.binding = binding}}));
    } else if (key == "ToneMapPeakNits") {
      settings.push_back(CreateSetting({PEAK_NITS_CONFIG, {.binding = binding}}));
    } else if (key == "ToneMapGameNits") {
      settings.push_back(CreateSetting({GAME_NITS_CONFIG, {.binding = binding}}));
    } else if (key == "ToneMapUINits") {
      settings.push_back(CreateSetting({UI_NITS_CONFIG, {.binding = binding}}));
    } else if (key == "ToneMapGammaCorrection") {
      settings.push_back(CreateSetting({GAMMA_CORRECTION_CONFIG, {.binding = binding}}));
    } else if (key == "ToneMapScaling") {
      settings.push_back(CreateSetting({TONE_MAP_SCALING_CONFIG, {.binding = binding}}));
    } else if (key == "ToneMapWorkingColorSpace") {
      settings.push_back(CreateSetting({TONE_MAP_WORKING_COLOR_SPACE_CONFIG, {.binding = binding}}));
    } else if (key == "ToneMapHueProcessor") {
      settings.push_back(CreateSetting({TONE_MAP_HUE_PROCESSOR_CONFIG, {.binding = binding}}));
    } else if (key == "ToneMapHueCorrection") {
      settings.push_back(CreateSetting({TONE_MAP_HUE_CORRECTION_CONFIG, {.binding = binding}}));
    } else if (key == "ToneMapHueShift") {
      settings.push_back(CreateSetting({TONE_MAP_HUE_SHIFT_CONFIG, {.binding = binding}}));
    } else if (key == "ToneMapClampColorSpace") {
      settings.push_back(CreateSetting({TONE_MAP_CLAMP_COLOR_SPACE_CONFIG, {.binding = binding}}));
    } else if (key == "ToneMapClampPeak") {
      settings.push_back(CreateSetting({TONE_MAP_CLAMP_PEAK_CONFIG, {.binding = binding}}));
    } else if (key == "SceneGradeStrength") {
      settings.push_back(CreateSetting({SCENE_GRADE_STRENGTH_CONFIG, {.binding = binding}}));
    } else if (key == "SceneGradeHueCorrection") {
      settings.push_back(CreateSetting({SCENE_GRADE_HUE_CORRECTION_CONFIG, {.binding = binding}}));
    } else if (key == "SceneGradeSaturationCorrection") {
      settings.push_back(CreateSetting({SCENE_GRADE_SATURATION_CORRECTION_CONFIG, {.binding = binding}}));
    } else if (key == "SceneGradeBlowoutRestoration") {
      settings.push_back(CreateSetting({SCENE_GRADE_BLOWOUT_RESTORATION_CONFIG, {.binding = binding}}));
    } else if (key == "SceneGradeHueShift") {
      settings.push_back(CreateSetting({SCENE_GRADE_HUE_SHIFT_CONFIG, {.binding = binding}}));
    } else if (key == "ColorGradeExposure") {
      settings.push_back(CreateSetting({COLOR_GRADE_EXPOSURE_CONFIG, {.binding = binding}}));
    } else if (key == "ColorGradeHighlights") {
      settings.push_back(CreateSetting({COLOR_GRADE_HIGHLIGHTS_CONFIG, {.binding = binding}}));
    } else if (key == "ColorGradeShadows") {
      settings.push_back(CreateSetting({COLOR_GRADE_SHADOWS_CONFIG, {.binding = binding}}));
    } else if (key == "ColorGradeContrast") {
      settings.push_back(CreateSetting({COLOR_GRADE_CONTRAST_CONFIG, {.binding = binding}}));
    } else if (key == "ColorGradeSaturation") {
      settings.push_back(CreateSetting({COLOR_GRADE_SATURATION_CONFIG, {.binding = binding}}));
    } else if (key == "ColorGradeHighlightSaturation") {
      settings.push_back(CreateSetting({COLOR_GRADE_HIGHLIGHT_SATURATION_CONFIG, {.binding = binding}}));
    } else if (key == "ColorGradeBlowout") {
      settings.push_back(CreateSetting({COLOR_GRADE_BLOWOUT_CONFIG, {.binding = binding}}));
    } else if (key == "ColorGradeFlare") {
      settings.push_back(CreateSetting({COLOR_GRADE_FLARE_CONFIG, {.binding = binding}}));
    } else if (key == "FxBloom") {
      settings.push_back(CreateSetting({FX_BLOOM_CONFIG, {.binding = binding}}));
    } else {
      throw std::runtime_error("Unknown setting key: " + key);
    }
  }
  return settings;
}

static std::vector<renodx::utils::settings::Setting*> JoinSettings(const std::vector<std::vector<renodx::utils::settings::Setting*>>& collection) {
  std::vector<renodx::utils::settings::Setting*> settings;
  std::unordered_set<std::string> unique_keys;
  for (const auto& group : collection) {
    for (const auto& setting : group) {
      if (!setting->key.empty()) {
        bool is_unique = unique_keys.insert(setting->key).second;
        if (!is_unique) continue;
      }
      settings.push_back(setting);
    }
  }
  return settings;
}

}  // namespace renodx::templates::settings