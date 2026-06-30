/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <include/reshade_api_device.hpp>
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <algorithm>
#include <cstring>
#include <filesystem>
#include <format>
#include <shared_mutex>
#include <span>
#include <string_view>
#include <unordered_set>
#include <vector>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/bitwise.hpp"
#include "../../utils/descriptor.hpp"
#include "../../utils/dlss_hook.hpp"
#include "../../utils/path.hpp"
#include "../../utils/pipeline_layout.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/shader_dump.hpp"
#include "../../utils/state.hpp"
#include "./shared.h"

namespace {
renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;
const std::string build_date = __DATE__;
const std::string build_time = __TIME__;
HMODULE addon_module_handle = nullptr;
bool dlss_hooks_attached = false;
bool dlss_frame_gen_had_early_load_on_boot = false;

std::unordered_set<uint32_t> dumped_tonemapper_shaders = {};

std::filesystem::path GetModulePath(HMODULE h_module) {
  wchar_t path[MAX_PATH] = L"";
  GetModuleFileNameW(h_module, path, ARRAYSIZE(path));
  return path;
}

std::string GetAddonFileName() {
  if (addon_module_handle == nullptr) return {};
  return GetModulePath(addon_module_handle).filename().string();
}

bool EqualsInsensitive(std::string_view lhs, std::string_view rhs) {
  return _stricmp(std::string(lhs).c_str(), std::string(rhs).c_str()) == 0;
}

std::vector<std::string> ReadConfigArray(const char* section, const char* key) {
  size_t value_size = 0;
  if (!reshade::get_config_value(nullptr, section, key, nullptr, &value_size) || value_size == 0) {
    return {};
  }

  std::string raw_value(value_size, '\0');
  if (!reshade::get_config_value(nullptr, section, key, raw_value.data(), &value_size)) {
    return {};
  }

  std::vector<std::string> values;
  for (size_t offset = 0; offset < raw_value.size();) {
    const auto* entry = raw_value.c_str() + offset;
    const size_t entry_size = std::strlen(entry);
    if (entry_size == 0) break;

    values.emplace_back(entry);
    offset += entry_size + 1;
  }

  return values;
}

bool HasLoadFromDllMainEntry() {
  const auto addon_file = GetAddonFileName();
  if (addon_file.empty()) return false;

  return std::ranges::any_of(
      ReadConfigArray("ADDON", "LoadFromDllMain"),
      [&](const auto& value) {
        return EqualsInsensitive(std::filesystem::path(value).filename().string(), addon_file);
      });
}

bool EnsureLoadFromDllMainEntry() {
  const auto addon_file = GetAddonFileName();
  if (addon_file.empty()) return false;

  auto values = ReadConfigArray("ADDON", "LoadFromDllMain");
  for (const auto& value : values) {
    if (EqualsInsensitive(std::filesystem::path(value).filename().string(), addon_file)) {
      return true;
    }
  }

  values.push_back(addon_file);

  std::string serialized;
  for (const auto& value : values) {
    serialized.append(value);
    serialized.push_back('\0');
  }

  reshade::set_config_value(nullptr, "ADDON", "LoadFromDllMain", serialized.c_str(), serialized.size());

  reshade::log::message(
      reshade::log::level::info,
      std::format("Added {} to ADDON.LoadFromDllMain in ReShade.ini. Restart required.", addon_file).c_str());
  return true;
}

void ConfigureDlssHookPaths() {
  auto dlss_path = renodx::utils::settings::ReadGlobalString("DLSSPath");
  auto streamline_path = renodx::utils::settings::ReadGlobalString("StreamlinePath");

  if (dlss_path.empty()) {
    dlss_path = (renodx::utils::path::GetExecutableBasePath() / "nvngx_dlss.dll").string();
  }
  if (streamline_path.empty()) {
    streamline_path = (renodx::utils::path::GetExecutableBasePath() / "sl.interposer.dll").string();
  }

  renodx::utils::dlss_hook::nvngx_dlss_file_path = dlss_path;
  renodx::utils::dlss_hook::streamline_interposer_file_path = streamline_path;

  reshade::log::message(
      reshade::log::level::info,
      std::format("Configured DLSS FG hook paths, DLSSPath: {}, StreamlinePath: {}", dlss_path, streamline_path).c_str());
}

void DetectDlssFrameGenLoadMode(HMODULE h_module) {
  static bool checked_load_mode = false;

  if (checked_load_mode) return;
  checked_load_mode = true;

  const auto module_file = GetModulePath(h_module).filename().string();
  const bool streamline_loaded = renodx::utils::platform::IsModuleLoaded(
      renodx::utils::dlss_hook::streamline_interposer_file_path);
  const bool dlss_loaded = renodx::utils::platform::IsModuleLoaded(
      renodx::utils::dlss_hook::nvngx_dlss_file_path);

  if (HasLoadFromDllMainEntry()) {
    reshade::log::message(
        reshade::log::level::info,
        std::format("{} is listed in ADDON.LoadFromDllMain.", module_file).c_str());
    return;
  }

  std::stringstream s;
  s << module_file << " is not listed in ADDON.LoadFromDllMain";

  if (streamline_loaded || dlss_loaded) {
    s << " and ";

    if (streamline_loaded) {
      s << std::filesystem::path(renodx::utils::dlss_hook::streamline_interposer_file_path).filename().string();
    }

    if (streamline_loaded && dlss_loaded) {
      s << ", ";
    }

    if (dlss_loaded) {
      s << std::filesystem::path(renodx::utils::dlss_hook::nvngx_dlss_file_path).filename().string();
    }

    s << " is already loaded. " << module_file
      << " is not listed in ADDON.LoadFromDllMain, so early DLSS FG hooks may have been missed unless ReShade was loaded through another early path.";
  } else {
    s << ". " << module_file
      << " is not listed in ADDON.LoadFromDllMain. Early DLSS FG hooks may still work if ReShade was loaded through another early path.";
  }

  reshade::log::message(reshade::log::level::warning, s.str().c_str());
}

void OverrideDlssgOptions(const sl::ViewportHandle& viewport_handle, sl::DLSSGOptions& options) {
  (void)viewport_handle;

  if (options.colorBufferFormat == 0u
      && options.hudLessBufferFormat == 0u
      && options.uiBufferFormat == 0u) {
    return;
  }

  if (renodx::mods::swapchain::target_format != reshade::api::format::r10g10b10a2_unorm) {
    return;
  }

  options.colorBufferFormat = DXGI_FORMAT_R10G10B10A2_UNORM;
  options.hudLessBufferFormat = DXGI_FORMAT_R16G16B16A16_FLOAT;
}

void AttachDlssHooks() {
  if (dlss_hooks_attached) return;

  renodx::utils::streamline::v2::override_dlssg_set_options = &OverrideDlssgOptions;
  renodx::utils::dlss_hook::Use(DLL_PROCESS_ATTACH);
  dlss_hooks_attached = true;
}

bool HasTonemapperColorGradingLut(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list->get_device();
  if (device == nullptr) return false;

  auto* command_state = renodx::utils::state::GetCurrentState(cmd_list);
  if (command_state == nullptr) return false;
  if (command_state->graphics_pipeline_layout.handle == 0u) return false;

  auto* descriptor_data = renodx::utils::data::Get<renodx::utils::descriptor::DeviceData>(device);
  if (descriptor_data == nullptr) return false;

  bool found_lut = false;
  renodx::utils::pipeline_layout::GetPipelineLayoutData(command_state->graphics_pipeline_layout, [&](const auto* layout_data) {
    const auto& params = layout_data->params;
    for (uint32_t param_index = 0; param_index < params.size() && !found_lut; ++param_index) {
      if (param_index >= command_state->graphics_descriptor_tables.size()) continue;

      const auto& param = params[param_index];
      const auto& table = command_state->graphics_descriptor_tables[param_index];

      uint32_t range_count = 0u;
      const reshade::api::descriptor_range* ranges = nullptr;
      switch (param.type) {
        case reshade::api::pipeline_layout_param_type::descriptor_table:
          if (table.handle == 0u) continue;
          range_count = param.descriptor_table.count;
          ranges = param.descriptor_table.ranges;
          break;
        case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
          if (table.handle == 0u) continue;
          range_count = param.descriptor_table_with_static_samplers.count;
          ranges = param.descriptor_table_with_static_samplers.ranges;
          break;
        case reshade::api::pipeline_layout_param_type::push_constants:
        case reshade::api::pipeline_layout_param_type::push_descriptors:
        case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
        case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
          continue;
      }

      for (uint32_t range_index = 0; range_index < range_count && !found_lut; ++range_index) {
        const auto& range = ranges[range_index];
        if (range.count == 0u || range.count == UINT32_MAX) continue;
        if (!renodx::utils::bitwise::HasFlag(range.visibility, reshade::api::shader_stage::pixel)) continue;

        switch (range.type) {
          case reshade::api::descriptor_type::shader_resource_view:
          case reshade::api::descriptor_type::sampler_with_resource_view:
            break;
          default:
            continue;
        }

        uint32_t base_offset = 0u;
        reshade::api::descriptor_heap heap = {0u};
        device->get_descriptor_heap_offset(table, range.binding, 0u, &heap, &base_offset);
        if (heap.handle == 0u) continue;

        const std::shared_lock lock(descriptor_data->mutex);
        auto heap_pair = descriptor_data->heaps.find(heap.handle);
        if (heap_pair == descriptor_data->heaps.end()) continue;

        const auto& heap_data = heap_pair->second;
        if (base_offset >= heap_data.size()) continue;

        static constexpr uint32_t MAX_DESCRIPTORS_TO_SCAN = 256u;
        const auto descriptor_count = std::min<uint32_t>(
            {range.count, static_cast<uint32_t>(heap_data.size() - base_offset), MAX_DESCRIPTORS_TO_SCAN});

        for (uint32_t descriptor_index = 0; descriptor_index < descriptor_count; ++descriptor_index) {
          const auto& descriptor = heap_data[base_offset + descriptor_index];
          if (!descriptor.HasResourceView()) continue;
          if (descriptor.resource_view.handle == 0u) continue;

          const auto resource = renodx::utils::resource::GetResourceFromView(device, descriptor.resource_view);
          if (resource.handle == 0u) continue;

          const auto desc = renodx::utils::resource::GetResourceDesc(device, resource);
          if (desc.type != reshade::api::resource_type::texture_3d) continue;
          if (desc.texture.width != 16u || desc.texture.height != 16u || desc.texture.depth_or_layers != 16u) continue;

          found_lut = true;
          break;
        }
      }
    }
  });

  return found_lut;
}

bool DumpTonemapperShader(reshade::api::command_list* cmd_list) {
  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return false;

  auto* pixel_state = renodx::utils::shader::GetCurrentPixelState(shader_state);
  const auto pixel_shader_hash = renodx::utils::shader::GetCurrentPixelShaderHash(pixel_state);
  if (pixel_shader_hash == 0u) return false;
  if (dumped_tonemapper_shaders.contains(pixel_shader_hash)) return false;
  if (!HasTonemapperColorGradingLut(cmd_list)) return false;

  try {
    auto shader_data = renodx::utils::shader::GetShaderData(pixel_state);
    if (!shader_data.has_value()) {
      reshade::log::message(
          reshade::log::level::warning,
          std::format("Darktide tonemapper dump failed: missing shader data for 0x{:08X}", pixel_shader_hash).c_str());
      return false;
    }

    renodx::utils::path::default_output_folder = "renodx";
    renodx::utils::shader::dump::default_dump_folder = "dump";

    const std::string prefix = custom_shaders.contains(pixel_shader_hash) ? "tonemapper_old_" : "tonemapper_new_";
    renodx::utils::shader::dump::DumpShader(
        pixel_shader_hash,
        std::span<uint8_t>(shader_data->data(), shader_data->size()),
        reshade::api::pipeline_subobject_type::pixel_shader,
        prefix,
        cmd_list->get_device()->get_api());

    dumped_tonemapper_shaders.emplace(pixel_shader_hash);

    reshade::log::message(
        reshade::log::level::info,
        std::format("Dumped Darktide tonemapper shader: {}0x{:08X}", prefix, pixel_shader_hash).c_str());
  } catch (...) {
    reshade::log::message(
        reshade::log::level::warning,
        std::format("Darktide tonemapper dump failed: exception for 0x{:08X}", pixel_shader_hash).c_str());
  }

  return false;
}

bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  return DumpTonemapperShader(cmd_list);
}

bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  return DumpTonemapperShader(cmd_list);
}

bool OnDrawOrDispatchIndirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t draw_count,
    uint32_t stride) {
  switch (type) {
    case reshade::api::indirect_command::dispatch:
    case reshade::api::indirect_command::dispatch_mesh:
    case reshade::api::indirect_command::dispatch_rays:
      return false;
    default:
      return DumpTonemapperShader(cmd_list);
  }
}

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &RENODX_TONE_MAP_TYPE,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
        .parse = [](float value) { return value > 0.f ? 3.f : 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &RENODX_PEAK_WHITE_NITS,
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
        .binding = &RENODX_DIFFUSE_WHITE_NITS,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &RENODX_GRAPHICS_WHITE_NITS,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &RENODX_TONE_MAP_EXPOSURE,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &RENODX_TONE_MAP_HIGHLIGHTS,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &RENODX_TONE_MAP_SHADOWS,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &RENODX_TONE_MAP_CONTRAST,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &RENODX_TONE_MAP_SATURATION,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeHighlightSaturation",
    //     .binding = &RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
    //     .default_value = 50.f,
    //     .label = "Highlight Saturation",
    //     .section = "Color Grading",
    //     .tooltip = "Adds or removes highlight color.",
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
    //     .parse = [](float value) { return value * 0.02f; },
    //     .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeBlowout",
    //     .binding = &RENODX_TONE_MAP_BLOWOUT,
    //     .default_value = 0.f,
    //     .label = "Blowout",
    //     .section = "Color Grading",
    //     .tooltip = "Adds highlight desaturation due to overexposure.",
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
    //     .parse = [](float value) { return (value * 0.01f); },
    //     .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeFlare",
    //     .binding = &RENODX_TONE_MAP_FLARE,
    //     .default_value = 0.f,
    //     .label = "Flare",
    //     .section = "Color Grading",
    //     .tooltip = "Flare/Glare Compensation",
    //     .max = 100.f,
    //     .is_enabled = []() { return RENODX_TONE_MAP_TYPE != 0; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    // },
    new renodx::utils::settings::Setting{
        .key = "FxSharpness",
        .binding = &CUSTOM_SHARPNESS,
        .default_value = 50.f,
        .label = "CAS Sharpness",
        .section = "Effects",
        .tooltip = "Controls Lilium's CAS Sharpness",
        .max = 100.f,
        .parse = [](float value) { return value == 0.f ? 0.f : value * -0.002; },
        .is_visible = []() { return settings[0]->GetValue() >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/XUhv", "tR54yc");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Ritsu's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/ritsucecil");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/hdrden");
        },
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::CUSTOM,
    //     .can_reset = false,
    //     .label = "DLSS FG early-load hint",
    //     .section = "Processing",
    //     .tint = 0xFFB84D,
    //     .on_draw = []() {
    //           const auto addon_file = GetAddonFileName();
    //           const bool configured = !dlss_frame_gen_had_early_load_on_boot
    //                                   && HasLoadFromDllMainEntry();

    //           if (configured) {
    //             ImGui::BeginDisabled();
    //           }
    //           if (ImGui::Button(configured
    //                                 ? "DLSS FG Early Load Configured (Restart Required)"
    //                                 : "Enable DLSS FG Early Load")) {
    //             EnsureLoadFromDllMainEntry();
    //           }
    //           if (configured) {
    //             ImGui::EndDisabled();
    //           }
    //           if (ImGui::IsItemHovered()) {
    //             ImGui::SetTooltip("[Addon]\nLoadFromDllMain=%s", addon_file.c_str());
    //           }

    //           return false; },
    //     .is_visible = []() { return !dlss_frame_gen_had_early_load_on_boot; },
    //     .is_sticky = true,
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = " - Upscaling must be used (DLSS/FSR/XeSS)!\n"
                 " - AA at native res causes visual bugs\n"
                 " - XeSS users must update the XeSS dll to the latest version, otherwise game will crash\n",
        .section = "Instructions",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Game mod by Ritsu, RenoDX Framework by ShortFuse.",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Credits to Lilium for CAS!",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "This build was compiled on " + build_date + " at " + build_time + ".",
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!dlss_hooks_attached) {
    AttachDlssHooks();
  }

  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
  }
}

// If you're including dlssfix then make sure it loads first!
void ConfigureDLSSFix() {
  const std::string global_dlss_fix_name = "RENODX-DLSSFIX";
  const std::string dlss_path_key = "DLSSPath";
  const std::string streamline_path_key = "StreamlinePath";

  // const std::string default_dlss_path = R"(..\..\Plugins\DLSS\Binaries\ThirdParty\Win64\nvngx_dlss.dll)";
  // const std::string default_streamline_path = R"(..\..\Plugins\DLSS\Binaries\ThirdParty\Win64\sl.interposer.dll)";

  const std::string dlss_path = R"(..\launcher\nvngx_dlss.dll)";
  const std::string streamline_path = R"(..\launcher\sl.interposer.dll)";

  reshade::set_config_value(nullptr, global_dlss_fix_name.c_str(), dlss_path_key.c_str(), dlss_path.c_str());
  reshade::set_config_value(nullptr, global_dlss_fix_name.c_str(), streamline_path_key.c_str(), streamline_path.c_str());
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX Darktide";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      addon_module_handle = h_module;
      if (!reshade::register_addon(h_module)) return FALSE;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      // Dump tonemappers
      // reshade::register_event<reshade::addon_event::draw>(OnDraw);
      // reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      // reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      // while (IsDebuggerPresent() == 0) Sleep(100);

      renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
        // We only need output shader since it's the only shader using injected data
        auto param_count = params.size();

        if (param_count <= 15) {
          return true;
        }

        return false;
      };

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;

      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_index = 13;

      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      // renodx::mods::swapchain::swap_chain_proxy_format = reshade::api::format::r10g10b10a2_unorm;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
      renodx::mods::swapchain::SetUseHDR10(true);

      // ConfigureDlssHookPaths();
      // dlss_frame_gen_had_early_load_on_boot = HasLoadFromDllMainEntry();
      // DetectDlssFrameGenLoadMode(h_module);
      // // Hooking sl.interposer / nvngx during DllMain can break ReShade DXGI init.
      // // Defer until swapchain creation unless early load is explicitly configured.
      // if (dlss_frame_gen_had_early_load_on_boot) {
      //   AttachDlssHooks();
      // }

      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::utils::descriptor::trace_descriptor_tables = true;
      renodx::utils::shader::use_shader_cache = true;
      // renodx::mods::shader::use_pipeline_layout_cloning = false;

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
      });

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
      });

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r10g10b10a2_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
          .usage_include = reshade::api::resource_usage::render_target,
      });
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      // reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      // reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      // reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      if (dlss_hooks_attached) {
        renodx::utils::streamline::v2::override_dlssg_set_options = nullptr;
        renodx::utils::dlss_hook::Use(DLL_PROCESS_DETACH);
        dlss_hooks_attached = false;
      }
      reshade::unregister_addon(h_module);
      dlss_frame_gen_had_early_load_on_boot = false;
      addon_module_handle = nullptr;
      break;
  }
  renodx::utils::state::Use(fdw_reason);
  renodx::utils::descriptor::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}