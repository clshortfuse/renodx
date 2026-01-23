/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#include <d3d11.h>
#include <d3d12.h>
#include <Windows.h>

#include <algorithm>
#include <atomic>
#include <cstdio>
#include <cstdlib>
#include <exception>
#include <filesystem>
#include <format>
#include <initializer_list>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <span>
#include <sstream>
#include <string>
#include <unordered_map>
#include <variant>
#include <vector>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <crc32_hash.hpp>
#include "../../mods/swapchain.hpp"
#include "../../utils/bitwise.hpp"
#include "../../utils/constants.hpp"
#include "../../utils/data.hpp"
#include "../../utils/date.hpp"
#include "../../utils/descriptor.hpp"
#include "../../utils/format.hpp"
#include "../../utils/pipeline_layout.hpp"
#include "../../utils/shader.hpp"
#include "../../utils/shader_compiler_directx.hpp"
#include "../../utils/shader_compiler_watcher.hpp"
#include "../../utils/shader_decompiler_dxc.hpp"
#include "../../utils/shader_dump.hpp"
#include "../../utils/string_view.hpp"
#include "../../utils/swapchain.hpp"
#include "../../utils/trace.hpp"

#define ICON_FK_CANCEL      reinterpret_cast<const char*>(u8"\uf00d")
#define ICON_FK_FILE        reinterpret_cast<const char*>(u8"\uf016")
#define ICON_FK_FILE_CODE   reinterpret_cast<const char*>(u8"\uf1c9")
#define ICON_FK_FILE_IMAGE  reinterpret_cast<const char*>(u8"\uf1c5")
#define ICON_FK_FLOPPY      reinterpret_cast<const char*>(u8"\uf0c7")
#define ICON_FK_FOLDER      reinterpret_cast<const char*>(u8"\uf114")
#define ICON_FK_FOLDER_OPEN reinterpret_cast<const char*>(u8"\uf115")
#define ICON_FK_MINUS       reinterpret_cast<const char*>(u8"\uf068")
#define ICON_FK_OK          reinterpret_cast<const char*>(u8"\uf00c")
#define ICON_FK_PENCIL      reinterpret_cast<const char*>(u8"\uf040")
#define ICON_FK_PLUS        reinterpret_cast<const char*>(u8"\uf067")
#define ICON_FK_REFRESH     reinterpret_cast<const char*>(u8"\uf021")
#define ICON_FK_SEARCH      reinterpret_cast<const char*>(u8"\uf002")
#define ICON_FK_UNDO        reinterpret_cast<const char*>(u8"\uf0e2")
#define ICON_FK_WARNING     reinterpret_cast<const char*>(u8"\uf071")

namespace {

reshade::api::device* snapshot_device = nullptr;
reshade::api::device* snapshot_queued_device = nullptr;

std::atomic_bool snapshot_pane_show_vertex_shaders = false;
std::atomic_bool snapshot_pane_show_pixel_shaders = true;
std::atomic_bool snapshot_pane_show_compute_shaders = true;
std::atomic_bool snapshot_pane_show_blends = true;
std::atomic_bool snapshot_pane_expand_all_nodes = true;
std::atomic_bool snapshot_pane_filter_resources_by_shader_use = true;
std::atomic_bool shaders_pane_show_vertex_shaders = false;
std::atomic_bool shaders_pane_show_pixel_shaders = true;
std::atomic_bool shaders_pane_show_compute_shaders = true;

uint32_t skip_draw_count = 0;
std::atomic_uint32_t device_data_index = 0;

struct ResourceBind {
  enum class BindType : std::uint8_t {
    SRV = 0,
    UAV = 1,
    CBV = 2,
  } type = BindType::SRV;
  uint32_t slot = 0;
  uint32_t space = 0;
};

struct ShaderDetails {
  uint32_t shader_hash;
  std::vector<uint8_t> shader_data;
  std::variant<std::nullopt_t, std::exception, std::string> disassembly = std::nullopt;
  std::variant<std::nullopt_t, std::exception, std::string> decompilation = std::nullopt;
  std::optional<renodx::utils::shader::compiler::directx::DxilProgramVersion> program_version = std::nullopt;
  std::span<const uint8_t> addon_shader;
  std::optional<renodx::utils::shader::compiler::watcher::CustomShader> disk_shader = std::nullopt;
  reshade::api::pipeline_stage shader_type = static_cast<reshade::api::pipeline_stage>(0);
  std::optional<std::vector<ResourceBind>> resource_binds = std::nullopt;
  std::string entrypoint;

  bool bypass_draw = false;

  enum class ShaderSource : std::uint8_t {
    ORIGINAL_SHADER = 0,
    ADDON_SHADER = 1,
    DISK_SHADER = 2,
  } shader_source = ShaderSource::ORIGINAL_SHADER;

  constexpr static const char* SHADER_SOURCE_NAMES[] = {
      "Original",
      "Add-on",
      "File",
  };
};

struct ResourceViewDetails {
  reshade::api::resource_view resource_view = {0};
  reshade::api::resource_view_desc resource_view_desc;
  reshade::api::resource resource = {0};
  reshade::api::resource_desc resource_desc;
  std::string resource_reflection;
  std::string resource_view_reflection;
  bool is_swapchain = false;
  bool is_rtv_upgraded = false;
  bool is_res_upgraded = false;
  bool is_rtv_cloned = false;
  bool is_res_cloned = false;

  bool UpdateSwapchainModState(reshade::api::device* device) {
    auto* swapchain_mod_data = renodx::utils::data::Get<renodx::mods::swapchain::DeviceData>(device);
    if (swapchain_mod_data == nullptr) return false;

    auto* resource_view_info_pointer = renodx::utils::resource::GetResourceViewInfo(resource_view);
    if (resource_view_info_pointer == nullptr) {
      this->is_rtv_upgraded = false;
      this->is_res_upgraded = false;
      this->is_rtv_cloned = false;
      this->is_rtv_cloned = false;

    } else {
      auto resource_view_info = *resource_view_info_pointer;

      this->is_rtv_upgraded = resource_view_info.upgraded;
      this->is_rtv_cloned = resource_view_info.clone.handle != 0u;

      if (resource_view_info.resource_info != nullptr) {
        this->is_res_upgraded = resource_view_info.resource_info->upgraded;
        this->is_rtv_cloned = resource_view_info.resource_info->clone_enabled;
      } else {
        this->is_res_upgraded = false;
        this->is_rtv_cloned = false;
      }
    }

    return true;
  }
};

struct PipelineBindDetails {
  reshade::api::pipeline pipeline;
  reshade::api::pipeline_stage pipeline_stage;
  std::vector<uint32_t> shader_hashes;
};

struct DrawDetails {
  enum class DrawMethods : std::uint8_t {
    PRESENT,
    DRAW,
    DRAW_INDEXED,
    DISPATCH,
    COPY
  } draw_method;

  std::chrono::time_point<std::chrono::system_clock> timestamp;
  std::map<std::pair<uint32_t, uint32_t>, ResourceViewDetails> srv_binds;
  std::map<std::pair<uint32_t, uint32_t>, ResourceViewDetails> uav_binds;
  std::map<std::pair<uint32_t, uint32_t>, reshade::api::buffer_range> constants;
  std::map<uint32_t, ResourceViewDetails> render_targets;
  std::vector<PipelineBindDetails> pipeline_binds;
  std::optional<reshade::api::blend_desc> blend_desc = std::nullopt;
  std::optional<reshade::api::rasterizer_desc> rasterizer_desc = std::nullopt;
  std::optional<std::vector<ResourceBind>> resource_binds = std::nullopt;

  reshade::api::resource copy_source = {0u};
  reshade::api::resource copy_destination = {0u};

  [[nodiscard]] bool IsDraw() const {
    switch (draw_method) {
      case DrawMethods::DRAW:         return true;
      case DrawMethods::DRAW_INDEXED: return true;
      default:                        return false;
    }
  };

  [[nodiscard]] bool IsDispatch() const {
    return draw_method == DrawMethods::DISPATCH;
  };

  [[nodiscard]] std::string DrawMethodString() const {
    switch (draw_method) {
      case DrawMethods::PRESENT:      return "Present";
      case DrawMethods::DRAW:         return "Draw";
      case DrawMethods::DRAW_INDEXED: return "DrawIndexed";
      case DrawMethods::DISPATCH:     return "Dispatch";
      case DrawMethods::COPY:         return "Copy";
      default:                        return "Unknown";
    }
  }
};

struct __declspec(uuid("3224946b-5c5f-478a-8691-83fbb9f88f1b")) CommandListData {
  // State
  std::map<std::pair<uint32_t, uint32_t>, ResourceViewDetails> pixel_srv_binds;
  std::map<std::pair<uint32_t, uint32_t>, ResourceViewDetails> pixel_uav_binds;
  std::map<std::pair<uint32_t, uint32_t>, ResourceViewDetails> compute_srv_binds;
  std::map<std::pair<uint32_t, uint32_t>, ResourceViewDetails> compute_uav_binds;
  std::map<std::pair<uint32_t, uint32_t>, reshade::api::buffer_range> constants;
  std::map<uint32_t, ResourceViewDetails> render_targets;
  std::optional<reshade::api::blend_desc> blend_desc = std::nullopt;
  std::optional<reshade::api::rasterizer_desc> rasterizer_desc = std::nullopt;

  // std::vector<PipelineBindDetails> pipeline_binds;
};

ResourceViewDetails GetResourceViewDetails(reshade::api::resource_view resource_view, reshade::api::device* device) {
  auto* resource_view_info = renodx::utils::resource::GetResourceViewInfo(resource_view);

  ResourceViewDetails details = {
      .resource_view = resource_view,
      // .resource_view_desc = device->get_resource_view_desc(resource_view),
      // .resource = device->get_resource_from_view(resource_view),
  };
  if (resource_view_info == nullptr) return details;

  details.resource_view_desc = resource_view_info->desc;
  auto device_api = device->get_api();

  auto resource_view_reflection = renodx::utils::trace::GetDebugName(device_api, resource_view);
  if (resource_view_reflection.has_value()) {
    details.resource_view_reflection = resource_view_reflection.value();
  }

  if (resource_view_info->resource_info != nullptr) {
    details.resource = resource_view_info->resource_info->resource;
    details.resource_desc = resource_view_info->resource_info->desc;

    if (!resource_view_info->resource_info->destroyed) {
      auto resource_reflection = renodx::utils::trace::GetDebugName(device_api, details.resource);
      if (resource_reflection.has_value()) {
        details.resource_reflection = resource_reflection.value();
      }
    }
    details.is_swapchain = renodx::utils::swapchain::IsBackBuffer(details.resource);
  } else {
    details.is_swapchain = false;
  }

  details.UpdateSwapchainModState(device);

  return details;
}

struct __declspec(uuid("0190ec1a-2e19-74a6-ad41-4df0d4d8caed")) DeviceData {
  reshade::api::device* device;
  std::unordered_map<uint32_t, ShaderDetails> shader_details;
  // std::vector<CommandListData> command_list_data;
  std::vector<DrawDetails> draw_details_list;
  std::unordered_set<uint64_t> live_pipelines;
  std::unordered_map<uint64_t, std::unordered_map<reshade::api::format, reshade::api::resource_view>> preview_srvs;
  std::shared_mutex mutex;
  std::unordered_map<uint64_t, reshade::api::blend_desc> pipeline_blends;

  reshade::api::effect_runtime* runtime = nullptr;

  std::unordered_map<uint32_t, std::set<uint32_t>> shader_draw_indexes;

  ShaderDetails* GetShaderDetails(uint32_t shader_hash) {
    // assert(shader_hash != 0u);
    if (auto pair = shader_details.find(shader_hash);
        pair != shader_details.end()) {
      return &pair->second;
    }

    auto [iterator, is_new] = shader_details.emplace(shader_hash, shader_hash);
    return &iterator->second;
  }
};

bool ComputeDisassemblyForShaderDetails(reshade::api::device* device, DeviceData* data, ShaderDetails* shader_details) {
  if (std::holds_alternative<std::nullopt_t>(shader_details->disassembly)) {
    // Never disassembled
    try {
      if (shader_details->shader_data.empty()) {
        reshade::api::pipeline pipeline = {0};

        // Get pipeline handle
        auto* store = renodx::utils::shader::GetStore();
        store->shader_pipeline_handles.if_contains(
            {device, shader_details->shader_hash},
            [&pipeline](const std::pair<const std::pair<reshade::api::device*, uint32_t>, std::unordered_set<uint64_t>>& pair) {
              if (pair.second.empty()) return;
              auto handle = *pair.second.begin();
              pipeline = {handle};
            });
        if (pipeline.handle == 0u) {
          throw std::exception("Shader data not found.");
        }

        auto shader_data = renodx::utils::shader::GetShaderData(pipeline, shader_details->shader_hash);
        if (!shader_data.has_value()) throw std::exception("Invalid shader selection");
        shader_details->shader_data = shader_data.value();
      }
      if (renodx::utils::device::IsDirectX(device)) {
        shader_details->disassembly = renodx::utils::shader::compiler::directx::DisassembleShader(shader_details->shader_data);
      } else if (device->get_api() == reshade::api::device_api::opengl) {
        shader_details->disassembly = std::string(
            shader_details->shader_data.data(),
            shader_details->shader_data.data() + shader_details->shader_data.size());
      } else {
        throw std::exception("Unsupported device API.");
      }
    } catch (std::exception& e) {
      shader_details->disassembly = e;
    }
  }

  return std::holds_alternative<std::string>(shader_details->disassembly);
}

std::optional<std::vector<ResourceBind>> GetResourceBindsForShaderDetails(
    reshade::api::device* device, DeviceData* data, ShaderDetails* shader_details) {
  if (shader_details->resource_binds.has_value()) {
    return shader_details->resource_binds;
  }

  bool ok = ComputeDisassemblyForShaderDetails(device, data, shader_details);
  if (!ok) {
    return shader_details->resource_binds;
  }

  // Read texture declarations from SM5 disassembly
  if (shader_details->program_version.has_value()) {
    shader_details->resource_binds = std::vector<ResourceBind>();

    if (shader_details->program_version->GetMajor() <= 3) {
      auto disassembly = std::get<std::string>(shader_details->disassembly);
      auto source_lines = StringViewSplitAll(disassembly, '\n');

      for (auto line : source_lines) {
        static const auto REGEX = std::regex(R"(^.*texldl?\s+[^,]+,\s*[^,]+,\s*s(\d+)$)");
        auto [slot] = StringViewMatch<1>(line, REGEX);
        if (slot.empty()) continue;
        ResourceBind resource_bind = {};
        FromStringView(slot, resource_bind.slot);
        shader_details->resource_binds->push_back(resource_bind);
      }
    } else if (shader_details->program_version->GetMajor() <= 5) {
      auto disassembly = std::get<std::string>(shader_details->disassembly);
      auto source_lines = StringViewSplitAll(disassembly, '\n');

      for (auto line : source_lines) {
        static const auto REGEX = std::regex(R"(^.*dcl_(?:resource_\S+|uav_\S+|constantbuffer) (?:\([^)]+\) )?(T|t|U|u|cb|CB)(\d+)(?:\.x?y?z?w?)?(?:\[[^[]+\])?(?:, \d+)?(?:, space=(\d+))?.*$)");
        auto [type, slot, space] = StringViewMatch<3>(line, REGEX);
        if (type.empty()) continue;
        assert(!slot.empty());
        ResourceBind resource_bind = {};
        if (type == "T" || type == "t") {
          resource_bind.type = ResourceBind::BindType::SRV;
        } else if (type == "U" || type == "u") {
          resource_bind.type = ResourceBind::BindType::UAV;
        } else if (type == "cb" || type == "CB") {
          resource_bind.type = ResourceBind::BindType::CBV;
        } else {
          assert(false);
          continue;
        }
        FromStringView(slot, resource_bind.slot);
        if (!space.empty()) {
          FromStringView(space, resource_bind.space);
        }
        shader_details->resource_binds->push_back(resource_bind);
      }
    } else {
      auto disassembly = std::get<std::string>(shader_details->disassembly);
      auto source_lines = StringViewSplitAll(disassembly, '\n');
      shader_details->resource_binds = std::vector<ResourceBind>();
      std::map<std::string_view, std::vector<std::string_view>> metadata_map;

      for (auto line : source_lines) {
        if (!line.starts_with("!")) continue;
        static auto regex = std::regex{R"(^(\S+) = !\{(.*)\}$)"};
        static auto values_regex = std::regex(R"(\s*([^,"]+(("[^"]*")[^,]*|)),?)");

        auto [variable_name, values_packed] = StringViewMatch<2>(line, regex);
        auto values = StringViewSplitAll(values_packed, values_regex, 1);
        auto len = values.size();
        for (int i = 0; i < len; ++i) {
          values[i] = StringViewTrim(values[i]);
        }
        metadata_map[variable_name] = values;
      }

      auto resource_list_metadata = metadata_map["!dx.resources"];

      if (!resource_list_metadata.empty()) {
        auto resource_list_reference = resource_list_metadata[0];
        auto resource_list_key = resource_list_reference;
        auto resource_list = metadata_map[resource_list_key];

        auto srv_list_key = resource_list[0];
        auto uav_list_key = resource_list[1];
        auto cbv_list_key = resource_list[2];
        // auto sampler_list_key = resource_list[3];

        if (srv_list_key != "null") {
          auto srv_list = metadata_map[srv_list_key];
          for (const auto srv_key : srv_list) {
            auto metadata = metadata_map[srv_key];
            ResourceBind resource_bind = {
                .type = ResourceBind::BindType::SRV,
            };

            FromStringView(
                renodx::utils::shader::decompiler::dxc::Metadata::ParseKeyValue(metadata[3])[1],
                resource_bind.space);
            FromStringView(
                renodx::utils::shader::decompiler::dxc::Metadata::ParseKeyValue(metadata[4])[1],
                resource_bind.slot);
            shader_details->resource_binds->push_back(resource_bind);
          }
        }

        if (uav_list_key != "null") {
          auto uav_list = metadata_map[uav_list_key];
          for (const auto uav_key : uav_list) {
            auto metadata = metadata_map[uav_key];
            ResourceBind resource_bind = {
                .type = ResourceBind::BindType::UAV,
            };

            FromStringView(renodx::utils::shader::decompiler::dxc::Metadata::ParseKeyValue(metadata[3])[1], resource_bind.space);
            FromStringView(renodx::utils::shader::decompiler::dxc::Metadata::ParseKeyValue(metadata[4])[1], resource_bind.slot);
            shader_details->resource_binds->push_back(resource_bind);
          }
        }

        if (cbv_list_key != "null") {
          auto cbv_list = metadata_map[cbv_list_key];
          for (const auto cbv_key : cbv_list) {
            auto metadata = metadata_map[cbv_key];
            ResourceBind resource_bind = {
                .type = ResourceBind::BindType::CBV,
            };

            FromStringView(renodx::utils::shader::decompiler::dxc::Metadata::ParseKeyValue(metadata[3])[1], resource_bind.space);
            FromStringView(renodx::utils::shader::decompiler::dxc::Metadata::ParseKeyValue(metadata[4])[1], resource_bind.slot);
            shader_details->resource_binds->push_back(resource_bind);
          }
        }
      }
    }
  }
  return shader_details->resource_binds;
}

std::string GetEntryPointForShaderDetails(reshade::api::device* device, DeviceData* data, ShaderDetails* shader_details) {
  if (!shader_details->entrypoint.empty()) {
    return shader_details->entrypoint;
  }

  bool ok = ComputeDisassemblyForShaderDetails(device, data, shader_details);
  if (!ok) {
    return shader_details->entrypoint;
  }

  if (shader_details->program_version.has_value()) {
    if (shader_details->program_version->GetMajor() <= 5) return "main";

    auto disassembly = std::get<std::string>(shader_details->disassembly);
    auto source_lines = StringViewSplitAll(disassembly, '\n');
    std::map<std::string_view, std::vector<std::string_view>> metadata_map;

    for (auto line : source_lines) {
      if (!line.starts_with("!")) continue;
      static auto regex = std::regex{R"(^(\S+) = !\{(.*)\}$)"};
      static auto values_regex = std::regex(R"(\s*([^,"]+(("[^"]*")[^,]*|)),?)");

      auto [variable_name, values_packed] = StringViewMatch<2>(line, regex);
      auto values = StringViewSplitAll(values_packed, values_regex, 1);
      auto len = values.size();
      for (int i = 0; i < len; ++i) {
        values[i] = StringViewTrim(values[i]);
      }
      metadata_map[variable_name] = values;
    }

    if (auto pair = metadata_map.find("!dx.entryPoints");
        pair != metadata_map.end() && !pair->second.empty()) {
      auto entry_points_reference = pair->second.at(0);
      auto entry_points_key = entry_points_reference;
      auto entry_points = metadata_map[entry_points_key];

      auto name = entry_points[1];
      static auto regex = std::regex{R"(^!\"?([^"]*)\"?$)"};
      auto [parsed_name] = StringViewMatch<1>(name, regex);
      if (!parsed_name.empty()) {
        shader_details->entrypoint = parsed_name;
      } else {
        shader_details->entrypoint = "main";
      }
    }
  }
  return shader_details->entrypoint;
}

// Settings
std::atomic_bool is_tracing_pipelines = false;

const uint32_t SETTING_NAV_RAIL_SIZE = 48;
const std::vector<std::pair<const char*, const char*>> SETTING_NAV_TITLES = {
    {"Snapshot", ICON_FK_SEARCH},
    {"Shaders", ICON_FK_FLOPPY},
    {"Defines", ICON_FK_PLUS},
    {"Settings", ICON_FK_PENCIL},
};

bool setting_auto_dump = false;
bool setting_live_reload = false;
uint32_t setting_nav_item = 0;

int pending_draw_index_focus = -1;

struct SettingSelection {
  uint32_t shader_hash = 0;
  uint64_t resource_handle = 0;
  uint64_t resource_view_handle = 0;
  uint64_t constant_buffer_handle = 0;
  int shader_view = 0;
  int resource_view = 0;
  int constant_view = 0;

  bool is_pinned = false;
  bool is_current = false;
  bool is_alive = true;

  [[nodiscard]] auto GetTreeNodeFlags() const {
    return is_current ? ImGuiTreeNodeFlags_Selected : 0;
  }

  [[nodiscard]] auto GetTabItemFlags() const {
    return is_current ? ImGuiTabItemFlags_SetSelected : 0;
  }
};

std::vector<SettingSelection> setting_open_tabs;

void MakeSelectionCurrent(SettingSelection selection) {
  bool marked_current = false;
  for (auto& item : setting_open_tabs) {
    if (selection.shader_hash != 0u) {
      marked_current |=
          item.is_current =
              (item.shader_hash == selection.shader_hash);
    } else if (selection.resource_handle != 0u) {
      marked_current |=
          item.is_current =
              (item.resource_handle == selection.resource_handle);
    } else if (selection.constant_buffer_handle != 0u) {
      marked_current |=
          item.is_current =
              (item.constant_buffer_handle == selection.constant_buffer_handle);
    } else if (selection.resource_view_handle != 0u) {
      marked_current |=
          item.is_current =
              (item.resource_view_handle == selection.resource_view_handle);
    }
  }
  if (marked_current) return;
  for (auto& item : setting_open_tabs) {
    if (item.is_pinned) continue;

    if (
        (selection.shader_hash != 0u && item.shader_hash != 0u)
        || (selection.resource_handle != 0u && item.resource_handle != 0u)
        || (selection.resource_view_handle != 0u && item.resource_view_handle != 0u)
        || (selection.constant_buffer_handle != 0u && item.constant_buffer_handle != 0u)) {
      item.shader_hash = selection.shader_hash;
      item.resource_handle = selection.resource_handle;
      item.resource_view_handle = selection.resource_view_handle;
      item.constant_buffer_handle = selection.constant_buffer_handle;
      item.is_current = true;
      return;
    }
  }
  selection.is_current = true;
  setting_open_tabs.push_back(selection);
}

SettingSelection& GetSelection(SettingSelection& selection) {
  for (auto& item : setting_open_tabs) {
    if (std::ranges::any_of(std::vector<std::pair<uint64_t, uint64_t>>({
                                {item.shader_hash, selection.shader_hash},
                                {item.resource_handle, selection.resource_handle},
                                {item.constant_buffer_handle, selection.constant_buffer_handle},
                                {item.resource_view_handle, selection.resource_view_handle},
                            }),
                            [](auto& pair) {
                              return (pair.second != 0u) && (pair.first == pair.second);
                            })) {
      return item;
    }
  }
  return selection;
}

std::optional<std::reference_wrapper<SettingSelection>> GetCurrentSelection() {
  for (auto& item : setting_open_tabs) {
    if (item.is_current) return item;
  }
  return std::nullopt;
}

void RemoveSelection(SettingSelection& selection) {
  auto iterator = setting_open_tabs.begin();
  while (iterator != setting_open_tabs.end()) {
    if (std::ranges::any_of(std::vector<std::pair<uint64_t, uint64_t>>({
                                {iterator->shader_hash, selection.shader_hash},
                                {iterator->resource_handle, selection.resource_handle},
                                {iterator->constant_buffer_handle, selection.constant_buffer_handle},
                                {iterator->resource_view_handle, selection.resource_view_handle},
                            }),
                            [](auto& pair) {
                              return (pair.second != 0u) && (pair.first == pair.second);
                            })) {
      setting_open_tabs.erase(iterator);
      return;
    }

    ++iterator;
  }
}

void RemoveDeadSelections() {
  auto len = setting_open_tabs.size();
  for (int i = len - 1; i >= 0; --i) {
    if (!setting_open_tabs[i].is_alive) {
      setting_open_tabs.erase(setting_open_tabs.begin() + i);
    }
  }
}

std::vector<std::pair<std::string, std::string>> setting_shader_defines;
bool setting_shader_defines_changed = false;

std::shared_mutex device_data_list_mutex;
std::vector<DeviceData*> device_data_list;

void OnInitDevice(reshade::api::device* device) {
  auto* device_data = renodx::utils::data::Create<DeviceData>(device);
  std::unique_lock lock(device_data_list_mutex);
  device_data->device = device;
  device_data_list.emplace_back(device_data);
}

void OnDestroyDevice(reshade::api::device* device) {
  if (snapshot_device == device) {
    snapshot_device = nullptr;
  }
  if (snapshot_queued_device == device) {
    snapshot_queued_device = nullptr;
  }
  auto* device_data = renodx::utils::data::Get<DeviceData>(device);
  if (device_data == nullptr) return;
  std::unique_lock lock(device_data_list_mutex);
  std::erase(device_data_list, device_data);
  renodx::utils::data::Delete<DeviceData>(device);
}

void OnInitCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Delete<CommandListData>(cmd_list);
}

void OnResetCommandList(reshade::api::command_list* cmd_list) {
  auto* data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (data == nullptr) return;
  renodx::utils::data::Delete<CommandListData>(cmd_list);
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

bool has_fired_on_init_pipeline_track_addons = false;
void OnInitPipelineTrackAddons(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  if (has_fired_on_init_pipeline_track_addons) return;
  has_fired_on_init_pipeline_track_addons = true;

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  auto* store = renodx::utils::shader::GetStore();
  // std::shared_lock shader_data_lock(shader_device_data->mutex);
  store->runtime_replacements.for_each(
      [&](const std::pair<const std::pair<reshade::api::device*, uint32_t>, std::span<const uint8_t>>& pair) {
        const auto& [pair_device, shader_hash] = pair.first;
        if (pair_device != device) return;
        auto* shader_details = data->GetShaderDetails(shader_hash);
        shader_details->addon_shader = pair.second;
        shader_details->shader_source = ShaderDetails::ShaderSource::ADDON_SHADER;
      });
}

void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  if (pipeline.handle == 0u) return;
  if (layout.handle == 0u) return;

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  data->live_pipelines.emplace(pipeline.handle);

  for (const auto& subobject : std::span<const reshade::api::pipeline_subobject>(subobjects, subobject_count)) {
    if (subobject.type == reshade::api::pipeline_subobject_type::blend_state) {
      const auto* blend_desc = reinterpret_cast<const reshade::api::blend_desc*>(subobject.data);
      data->pipeline_blends[pipeline.handle] = *blend_desc;
    }
  }
}

void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  if (pipeline.handle == 0u) return;
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  data->live_pipelines.erase(pipeline.handle);
  data->pipeline_blends.erase(pipeline.handle);
}

void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stage,
    reshade::api::pipeline pipeline) {
  if (cmd_list->get_device() != snapshot_device) return;

  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return;
  // auto& details = cmd_list_data->GetCurrentDrawDetails();

  // PipelineBindDetails bind_details = {
  //     .pipeline = pipeline,
  //     .pipeline_stage = stage,
  // };

  auto* device = cmd_list->get_device();

  auto* device_data = renodx::utils::data::Get<DeviceData>(device);
  if (device_data == nullptr) return;

  std::unique_lock lock(device_data->mutex);

  std::set<uint32_t> added_shaders;
  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  for (auto compatible_stage : renodx::utils::shader::COMPATIBLE_STAGES) {
    if (!renodx::utils::bitwise::HasFlag(stage, compatible_stage)) continue;

    if (pipeline.handle == 0u) continue;

    auto shader_hash = GetCurrentShaderHash(shader_state, compatible_stage);
    if (shader_hash == 0u) continue;

    auto [it, inserted] = added_shaders.emplace(shader_hash);
    if (!inserted) continue;

    auto* shader_details = device_data->GetShaderDetails(shader_hash);
    if (static_cast<uint32_t>(shader_details->shader_type) != 0u) continue;
    if (!shader_details->program_version.has_value()) {
      if (shader_details->shader_data.empty()) {
        try {
          auto* pipeline_details = renodx::utils::shader::GetPipelineShaderDetails(pipeline);
          if (pipeline_details == nullptr) return;

          auto shader_data = renodx::utils::shader::GetShaderData(pipeline, shader_hash);
          if (!shader_data.has_value()) {
            throw std::exception("Failed to get shader data");
          }
          shader_details->shader_data = shader_data.value();
        } catch (const std::exception& e) {
          reshade::log::message(reshade::log::level::error, e.what());
        }
      }
      if (renodx::utils::device::IsDirectX(device)) {
        try {
          shader_details->program_version = renodx::utils::shader::compiler::directx::DecodeShaderVersion(shader_details->shader_data);
        } catch (const std::exception& e) {
          reshade::log::message(reshade::log::level::error, e.what());
        }
      } else if (device->get_api() == reshade::api::device_api::opengl) {
        // noop
      }
    }

    if (shader_details->program_version.has_value()) {
      switch (shader_details->program_version->GetKind()) {
        case D3D11_SHVER_VERTEX_SHADER:
          shader_details->shader_type = reshade::api::pipeline_stage::vertex_shader;
          break;
        case D3D11_SHVER_PIXEL_SHADER:
          shader_details->shader_type = reshade::api::pipeline_stage::pixel_shader;
          break;
        case D3D11_SHVER_COMPUTE_SHADER:
          shader_details->shader_type = reshade::api::pipeline_stage::compute_shader;
          break;
        default:
          break;
      }
    } else {
      shader_details->shader_type = compatible_stage;
    }
  }

  auto pair = device_data->pipeline_blends.find(pipeline.handle);
  if (pair != device_data->pipeline_blends.end()) {
    auto& blend_desc = pair->second;
    cmd_list_data->blend_desc = blend_desc;
  }
}

bool OnCopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {
  if (snapshot_device == nullptr) return false;

  auto* device = cmd_list->get_device();

  if (device == snapshot_device) {
    DrawDetails draw_details = {
        .draw_method = DrawDetails::DrawMethods::COPY,
        .timestamp = std::chrono::system_clock::now(),
        .copy_source = source,
        .copy_destination = dest,
    };

    auto* device_data = renodx::utils::data::Get<DeviceData>(device);
    if (device_data == nullptr) return false;
    std::unique_lock lock(device_data->mutex);
    reshade::log::message(reshade::log::level::debug, std::format("Snapshot #{}", device_data->draw_details_list.size()).c_str());
    device_data->draw_details_list.push_back(draw_details);
  } else {
    reshade::log::message(reshade::log::level::debug, "Foreign Copy.");
  }

  return false;
}

static bool OnCopyTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box,
    reshade::api::filter_mode filter) {
  if (snapshot_device == nullptr) return false;

  auto* device = cmd_list->get_device();

  if (device == snapshot_device) {
    DrawDetails draw_details = {
        .draw_method = DrawDetails::DrawMethods::COPY,
        .timestamp = std::chrono::system_clock::now(),
        .copy_source = source,
        .copy_destination = dest,
    };

    auto* device_data = renodx::utils::data::Get<DeviceData>(device);
    if (device_data == nullptr) return false;
    std::unique_lock lock(device_data->mutex);
    reshade::log::message(reshade::log::level::debug, std::format("Snapshot #{}", device_data->draw_details_list.size()).c_str());
    device_data->draw_details_list.push_back(draw_details);
  } else {
    reshade::log::message(reshade::log::level::debug, "Foreign Copy.");
  }

  return false;
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  auto pair = data->preview_srvs.find(resource.handle);
  if (pair == data->preview_srvs.end()) return;
  auto srvs = pair->second;
  for (const auto& [format, srv] : srvs) {
    if (srv.handle != 0u) {
      device->destroy_resource_view(srv);
    }
  }
  data->preview_srvs.erase(pair);
}

void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (cmd_list->get_device() != snapshot_device) return;
  auto* data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (data == nullptr) return;

  auto* device = cmd_list->get_device();

  renodx::utils::pipeline_layout::PipelineLayoutData* layout_data = nullptr;
  auto populate_layout_data = [&]() {
    if (layout_data != nullptr) return true;
    auto* local_layout_data = renodx::utils::pipeline_layout::GetPipelineLayoutData(layout);
    if (local_layout_data == nullptr) {
      reshade::log::message(reshade::log::level::error, "Could not find handle.");
      return false;
    }
    layout_data = local_layout_data;
    return true;
  };

  auto log_resource_view = [&](uint32_t index,
                               reshade::api::resource_view view,
                               std::map<std::pair<uint32_t, uint32_t>,
                                        ResourceViewDetails>& destination) {
    if (!populate_layout_data()) return;

    auto layout_params = layout_data->params;
    const auto& param = layout_params[layout_param];
    uint32_t dx_register_index = 0;
    uint32_t dx_register_space = 0;
    switch (param.type) {
      case reshade::api::pipeline_layout_param_type::descriptor_table: {
        if (param.descriptor_table.count != 1) {
          reshade::log::message(reshade::log::level::error, "Wrong count.");
          // add warning
          return;
        }
        dx_register_index = param.descriptor_table.ranges[0].dx_register_index;
        dx_register_space = param.descriptor_table.ranges[0].dx_register_space;
        break;
      }
      case reshade::api::pipeline_layout_param_type::push_descriptors:
        dx_register_index = param.push_descriptors.dx_register_index;
        dx_register_space = param.push_descriptors.dx_register_space;
        break;
      default:
        reshade::log::message(reshade::log::level::error, "Not descriptor table.");
        return;
    }

    auto slot = std::pair<uint32_t, uint32_t>(dx_register_index + update.binding + index, dx_register_space);

    if (view.handle == 0u) {
      destination.erase(slot);
    } else {
      auto detail_item = GetResourceViewDetails(view, device);
      if (detail_item.resource_desc.type == reshade::api::resource_type::unknown) {
        bool unknown_type = true;
        // destination.erase(slot);
      }
      destination[slot] = detail_item;
    }
  };

  for (uint32_t i = 0; i < update.count; i++) {
    switch (update.type) {
      case reshade::api::descriptor_type::sampler:
        break;
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i];
        if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) {
          log_resource_view(i, item.view, data->pixel_srv_binds);
        } else if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::compute)) {
          log_resource_view(i, item.view, data->compute_srv_binds);
        }
      } break;
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::shader_resource_view:        {
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) {
          log_resource_view(i, item, data->pixel_srv_binds);
        } else if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::compute)) {
          log_resource_view(i, item, data->compute_srv_binds);
        }
        break;
      }
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::unordered_access_view:        {
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) {
          log_resource_view(i, item, data->pixel_uav_binds);
        } else if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::compute)) {
          log_resource_view(i, item, data->compute_uav_binds);
        }

        break;
      }
      case reshade::api::descriptor_type::constant_buffer: {
        if (!populate_layout_data()) return;
        auto layout_params = layout_data->params;
        auto param = layout_params[layout_param];
        if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
          assert(param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer);

          uint32_t pair_a = 0;
          uint32_t pair_b = 0;
          switch (device->get_api()) {
            case reshade::api::device_api::d3d9:
            case reshade::api::device_api::d3d10:
            case reshade::api::device_api::d3d11:
            case reshade::api::device_api::d3d12:
              pair_a = param.push_constants.dx_register_index + update.binding + i;
              pair_b = param.push_constants.dx_register_space;
              break;

            case reshade::api::device_api::opengl:
              break;

            case reshade::api::device_api::vulkan:
              pair_a = update.binding;
              pair_b = update.array_offset + i;
              break;
            default:
              assert(false);
          }
          auto buffer_range = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
          auto slot = std::pair<uint32_t, uint32_t>(pair_a, pair_b);
          data->constants[slot] = buffer_range;
        } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges) {
          uint32_t pair_a = 0;
          uint32_t pair_b = 0;

          switch (device->get_api()) {
            case reshade::api::device_api::d3d9:
            case reshade::api::device_api::d3d10:
            case reshade::api::device_api::d3d11:
            case reshade::api::device_api::d3d12:
              assert(false);
              break;
            case reshade::api::device_api::opengl:
              break;

            case reshade::api::device_api::vulkan:
              assert(param.descriptor_table.count > update.binding);
              assert(param.descriptor_table.ranges[update.binding].binding == update.binding);
              pair_a = update.binding;
              pair_b = update.array_offset + i;
              break;
            default:
              assert(false);
          }
          auto buffer_range = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
          auto slot = std::pair<uint32_t, uint32_t>(pair_a, pair_b);
          data->constants[slot] = buffer_range;

        } else {
          assert(false);
        }

      } break;
      default:
        break;
    }
  }
}

bool OnDraw(reshade::api::command_list* cmd_list, DrawDetails::DrawMethods draw_method) {
  bool bypass_draw = false;

  auto* device = cmd_list->get_device();

  auto* device_data = renodx::utils::data::Get<DeviceData>(device);
  if (device_data == nullptr) return false;

  if (device == snapshot_device) {
    auto* state = renodx::utils::shader::GetCurrentState(cmd_list);

    auto* command_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
    if (command_list_data == nullptr) return false;
    DrawDetails draw_details = {};
    draw_details.timestamp = std::chrono::system_clock::now();
    draw_details.draw_method = draw_method;
    draw_details.constants = command_list_data->constants;
    // draw_details.pipeline_binds = command_list_data->pipeline_binds;
    if (draw_method == DrawDetails::DrawMethods::DISPATCH) {
      draw_details.srv_binds = command_list_data->compute_srv_binds;
      draw_details.uav_binds = command_list_data->compute_uav_binds;
    } else {
      draw_details.srv_binds = command_list_data->pixel_srv_binds;
      draw_details.uav_binds = command_list_data->pixel_uav_binds;
    }
    draw_details.render_targets = command_list_data->render_targets;
    draw_details.blend_desc = command_list_data->blend_desc;

    std::unique_lock lock(device_data->mutex);

    std::set<reshade::api::pipeline> added_pipelines;
    for (auto stage_state : state->stage_states) {
      if (draw_method == DrawDetails::DrawMethods::DISPATCH) {
        if (stage_state.stage != reshade::api::pipeline_stage::compute_shader) continue;
      } else {
        if (stage_state.stage == reshade::api::pipeline_stage::compute_shader) continue;
      }

      if (stage_state.pipeline.handle == 0u) {
        // sometimes opengl can call glEnd without having drawn anything
        // Vertex shaders don't need pixel shaders
        assert(stage_state.pipeline.handle != 0u
               || device->get_api() == reshade::api::device_api::opengl
               || stage_state.stage == reshade::api::pipeline_stage::pixel_shader);
        continue;
      }

      renodx::utils::shader::PopulateStageState(&stage_state);
      auto shader_hash = renodx::utils::shader::GetCurrentShaderHash(&stage_state);

      ShaderDetails* shader_details = nullptr;

      if (skip_draw_count != 0) {
        if (auto pair = device_data->shader_details.find(shader_hash);
            pair != device_data->shader_details.end()) {
          shader_details = &pair->second;
          if (shader_details->bypass_draw) {
            bypass_draw = true;
          }
        }
      }

      auto pipeline_details = PipelineBindDetails{
          .pipeline = stage_state.pipeline,
          .pipeline_stage = stage_state.stage,
      };
      if (stage_state.pipeline_details != nullptr) {
        pipeline_details.shader_hashes = {
            stage_state.pipeline_details->shader_hashes.begin(),
            stage_state.pipeline_details->shader_hashes.end()};
      }

      if ((draw_method == DrawDetails::DrawMethods::DISPATCH && stage_state.stage == reshade::api::pipeline_stage::compute_shader)
          || (draw_details.draw_method != DrawDetails::DrawMethods::DISPATCH && stage_state.stage == reshade::api::pipeline_stage::pixel_shader)) {
        if (shader_details == nullptr) {
          shader_details = device_data->GetShaderDetails(shader_hash);
        }
        if (shader_details != nullptr) {
          if (!shader_details->resource_binds.has_value()) {
            GetResourceBindsForShaderDetails(device, device_data, shader_details);
          }
          draw_details.resource_binds = shader_details->resource_binds;
        }
      }

      if (!added_pipelines.contains(pipeline_details.pipeline)) {
        added_pipelines.emplace(pipeline_details.pipeline);
        draw_details.pipeline_binds.push_back(pipeline_details);
      }
    }

    if (state->last_pipeline != 0u) {
      auto* pipeline_shader_details = renodx::utils::shader::GetPipelineShaderDetails(state->last_pipeline);
      if (pipeline_shader_details != nullptr) {
        auto* layout_data = renodx::utils::pipeline_layout::GetPipelineLayoutData(pipeline_shader_details->layout);
        if (layout_data != nullptr) {
          const auto& info = *layout_data;
          auto param_count = info.params.size();
          auto* descriptor_data = renodx::utils::data::Get<renodx::utils::descriptor::DeviceData>(device);
          if (descriptor_data == nullptr) return false;
          for (auto param_index = 0; param_index < param_count; ++param_index) {
            const auto& param = info.params.at(param_index);
            const auto& table = info.tables[param_index];

            uint32_t descriptor_table_count;
            const reshade::api::descriptor_range* descriptor_table_ranges;
            switch (param.type) {
              case reshade::api::pipeline_layout_param_type::descriptor_table:
                if (table.handle == 0u) continue;
                descriptor_table_count = param.descriptor_table.count;
                descriptor_table_ranges = param.descriptor_table.ranges;
                break;
              case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
                if (table.handle == 0u) continue;
                descriptor_table_count = param.descriptor_table_with_static_samplers.count;
                descriptor_table_ranges = param.descriptor_table_with_static_samplers.ranges;
                break;

              case reshade::api::pipeline_layout_param_type::push_constants:
              case reshade::api::pipeline_layout_param_type::push_descriptors:
              case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
              case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
                continue;
            }

            for (uint32_t j = 0; j < descriptor_table_count; ++j) {
              const auto& range = descriptor_table_ranges[j];

              // Skip unbounded ranges
              if (range.count == UINT32_MAX) continue;

              switch (range.type) {
                case reshade::api::descriptor_type::shader_resource_view:
                case reshade::api::descriptor_type::sampler_with_resource_view:
                case reshade::api::descriptor_type::buffer_shader_resource_view:
                case reshade::api::descriptor_type::unordered_access_view:
                  break;
                default:
                  continue;
              }

              if (draw_method == DrawDetails::DrawMethods::DISPATCH
                  && !renodx::utils::bitwise::HasFlag(range.visibility, reshade::api::shader_stage::compute)) {
                continue;
              }
              if (!renodx::utils::bitwise::HasFlag(range.visibility, reshade::api::shader_stage::pixel)) {
                continue;
              }

              uint32_t base_offset = 0;
              reshade::api::descriptor_heap heap = {0};
              device->get_descriptor_heap_offset(table, range.binding, 0, &heap, &base_offset);
              const std::shared_lock descriptor_lock(descriptor_data->mutex);

              for (uint32_t k = 0; k < range.count; ++k) {
                auto heap_pair = descriptor_data->heaps.find(heap.handle);
                if (heap_pair == descriptor_data->heaps.end()) {
                  // Unknown heap?
                  continue;
                }
                const auto& heap_data = heap_pair->second;
                auto offset = base_offset + k;
                if (offset >= heap_data.size()) {
                  // Invalid location (may be oversized bind)
                  continue;
                }
                auto known_pair = descriptor_data->resource_view_heap_locations.find(heap.handle);
                if (known_pair == descriptor_data->resource_view_heap_locations.end()) continue;
                auto& known = known_pair->second;
                if (!known.contains(offset)) {
                  // Unknown Resource View
                  continue;
                }

                const auto& [descriptor_type, descriptor_data] = heap_data[offset];
                reshade::api::resource_view resource_view = {0};
                bool is_uav = false;
                switch (descriptor_type) {
                  case reshade::api::descriptor_type::sampler_with_resource_view:
                    resource_view = std::get<reshade::api::sampler_with_resource_view>(descriptor_data).view;
                    break;
                  case reshade::api::descriptor_type::buffer_unordered_access_view:
                  case reshade::api::descriptor_type::texture_unordered_access_view:
                    is_uav = true;
                    // fallthrough
                  case reshade::api::descriptor_type::buffer_shader_resource_view:
                  case reshade::api::descriptor_type::texture_shader_resource_view:
                    resource_view = std::get<reshade::api::resource_view>(descriptor_data);
                    break;
                  case reshade::api::descriptor_type::constant_buffer:
                  case reshade::api::descriptor_type::shader_storage_buffer:
                  case reshade::api::descriptor_type::acceleration_structure:
                    break;
                  default:
                    break;
                }

                auto slot = std::pair<uint32_t, uint32_t>(range.dx_register_index + k, range.dx_register_space);

                if (is_uav || range.type == reshade::api::descriptor_type::unordered_access_view) {
                  if (resource_view.handle == 0u) {
                    draw_details.uav_binds.erase(slot);
                  } else {
                    auto detail_item = GetResourceViewDetails(resource_view, device);
                    if (detail_item.resource.handle == 0u && renodx::utils::resource::IsResourceViewEmpty(device, resource_view)) {
                      draw_details.uav_binds.erase(slot);
                    } else {
                      draw_details.uav_binds[slot] = detail_item;
                    }
                  }
                } else {
                  if (resource_view.handle == 0u) {
                    draw_details.srv_binds.erase(slot);
                  } else {
                    auto detail_item = GetResourceViewDetails(resource_view, device);
                    if (detail_item.resource.handle == 0u && renodx::utils::resource::IsResourceViewEmpty(device, resource_view)) {
                      draw_details.srv_binds.erase(slot);
                    } else {
                      draw_details.srv_binds[slot] = detail_item;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    draw_details.render_targets.clear();

    if (draw_method != DrawDetails::DrawMethods::DISPATCH) {
      uint32_t rtv_index = 0u;
      for (auto render_target : renodx::utils::swapchain::GetRenderTargets(cmd_list)) {
        if (render_target.handle != 0u) {
          draw_details.render_targets[rtv_index] = GetResourceViewDetails(render_target, device);
        }
        ++rtv_index;
      }
      if (draw_details.render_targets.empty()) {
        reshade::log::message(reshade::log::level::warning, "Draw with no RTVs");
      }
    }

    // device_data->command_list_data.push_back(*command_list_data);
    reshade::log::message(reshade::log::level::debug, std::format("Snapshot #{}", device_data->draw_details_list.size()).c_str());
    device_data->draw_details_list.push_back(draw_details);
    // command_list_data->draw_details.clear();
  } else if (snapshot_device != nullptr) {
    reshade::log::message(reshade::log::level::debug, "Foreign Draw.");
  } else if (skip_draw_count != 0) {
    auto* state = renodx::utils::shader::GetCurrentState(cmd_list);
    std::shared_lock lock(device_data->mutex);
    for (auto& stage_state : state->stage_states) {
      if (draw_method == DrawDetails::DrawMethods::DISPATCH) {
        if (stage_state.stage != reshade::api::pipeline_stage::compute_shader) continue;
      } else {
        if (stage_state.stage == reshade::api::pipeline_stage::compute_shader) continue;
      }

      renodx::utils::shader::PopulateStageState(&stage_state);
      auto shader_hash = renodx::utils::shader::GetCurrentShaderHash(&stage_state);

      if (auto pair = device_data->shader_details.find(shader_hash);
          pair != device_data->shader_details.end()) {
        auto* shader_details = &pair->second;
        if (shader_details->bypass_draw) {
          bypass_draw = true;
        }
      }
    }
  }

  return bypass_draw;
}

bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  return OnDraw(cmd_list, DrawDetails::DrawMethods::DRAW);
}

bool OnDispatch(reshade::api::command_list* cmd_list, uint32_t group_count_x, uint32_t group_count_y, uint32_t group_count_z) {
  return OnDraw(cmd_list, DrawDetails::DrawMethods::DISPATCH);
}

bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  return OnDraw(cmd_list, DrawDetails::DrawMethods::DRAW_INDEXED);
}

bool OnDrawOrDispatchIndirect(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource buffer,
    uint64_t offset,
    uint32_t draw_count,
    uint32_t stride) {
  bool is_dispatch = false;
  switch (type) {
    case reshade::api::indirect_command::unknown: {
      {
        auto* cmd_list_data = renodx::utils::shader::GetCurrentState(cmd_list);
        auto shader_hash = renodx::utils::shader::GetCurrentComputeShaderHash(cmd_list_data);
        is_dispatch = (shader_hash != 0u);
      }
      break;
    }
    case reshade::api::indirect_command::dispatch:
    case reshade::api::indirect_command::dispatch_mesh:
    case reshade::api::indirect_command::dispatch_rays:
      is_dispatch = true;
      break;
    default:
      break;
  }

  return OnDraw(cmd_list, is_dispatch ? DrawDetails::DrawMethods::DISPATCH
                                      : DrawDetails::DrawMethods::DRAW_INDEXED);
}

void DeactivateShader(reshade::api::device* device, uint32_t shader_hash) {
  renodx::utils::shader::RemoveRuntimeReplacements(device, {shader_hash});
}

void ActivateShader(reshade::api::device* device, uint32_t shader_hash, std::span<const uint8_t> shader_data) {
  renodx::utils::shader::AddRuntimeReplacement(device, shader_hash, shader_data);
}

void LoadDiskShaders(reshade::api::device* device, DeviceData* data, bool activate = true) {
  if (setting_live_reload) {
    if (!renodx::utils::shader::compiler::watcher::HasChanged()) return;
  } else {
    renodx::utils::shader::compiler::watcher::CompileSync();
  }
  const auto& custom_shaders = renodx::utils::shader::compiler::watcher::FlushCompiledShaders();
  for (const auto& [shader_hash, custom_shader] : custom_shaders) {
    reshade::log::message(reshade::log::level::debug, "new shaders");
    auto* details = data->GetShaderDetails(shader_hash);
    details->disk_shader = custom_shader;

    if (activate) {
      details->shader_source = ShaderDetails::ShaderSource::DISK_SHADER;
      DeactivateShader(device, shader_hash);

      if (!custom_shader.removed && custom_shader.IsCompilationOK()) {
        const auto& shader_data = details->disk_shader->GetCompilationData();
        ActivateShader(device, shader_hash, shader_data);
      }
    }
  }
}

bool RenderFileAlias(std::optional<renodx::utils::shader::compiler::watcher::CustomShader>& disk_shader) {
  if (!disk_shader.has_value()) return false;
  // Has custom shader file
  std::string file_alias = disk_shader->GetFileAlias();
  if (disk_shader->IsCompilationOK()) {
    if (file_alias.empty()) {
      ImGui::TextColored(ImVec4(0, 255, 0, 128), "Custom");
    } else {
      ImGui::TextColored(ImVec4(0, 255, 0, 255), "%s", file_alias.c_str());
    }
  } else {
    if (file_alias.empty()) {
      ImGui::TextColored(ImVec4(255, 0, 0, 128), "Custom");
    } else {
      ImGui::TextColored(ImVec4(255, 0, 0, 255), "%s", file_alias.c_str());
    }
  }
  return true;
}

void RenderMenuBar(reshade::api::device* device, DeviceData* data) {
  if (ImGui::BeginMenuBar()) {
    ImGui::PushID("##SnapshotButton");
    ImGui::BeginDisabled(snapshot_device != nullptr);
    if (ImGui::MenuItem("Snapshot")) {
      snapshot_queued_device = device;
      renodx::utils::trace::trace_scheduled = true;
    }
    ImGui::EndDisabled();
    ImGui::PopID();

    ImGui::PushID("##menu_shaders_auto_dump");
    ImGui::MenuItem("Auto Dump", "", &setting_auto_dump);
    ImGui::PopID();

    ImGui::PushID("##menu_shaders_dump");
    if (ImGui::MenuItem(std::format("Dump Shaders ({})", renodx::utils::shader::dump::pending_dump_count.load()).c_str(), "", false, !setting_auto_dump)) {
      renodx::utils::shader::dump::DumpAllPending();
    }
    ImGui::PopID();

    ImGui::PushID("##menu_shaders_auto_load");
    ImGui::MenuItem("Live Shaders", "", &setting_live_reload);
    ImGui::PopID();

    ImGui::PushID("##menu_shaders_load");
    if (ImGui::MenuItem(std::format("Load Shaders ({})", renodx::utils::shader::compiler::watcher::custom_shaders_count.load()).c_str())) {
      setting_live_reload = false;
      LoadDiskShaders(device, data);
    }
    ImGui::PopID();

    ImGui::PushID("##menu_shaders_auto_load");
    if (ImGui::MenuItem(std::format("Unload Shaders", renodx::utils::shader::runtime_replacement_count.load()).c_str())) {
      setting_live_reload = false;
      renodx::utils::shader::RemoveRuntimeReplacements(device);
      renodx::utils::shader::compiler::watcher::CompileSync();
    }
    ImGui::PopID();

    ImGui::PushID("##TraceButton");
    if (ImGui::MenuItem("Trace")) {
      renodx::utils::trace::trace_scheduled = true;
    }
    ImGui::PopID();

    ImGui::EndMenuBar();
  }
}

void RenderNavRail(reshade::api::device* device, DeviceData* data) {
  if (ImGui::BeginChild("##NavRail", ImVec2(SETTING_NAV_RAIL_SIZE, 0))) {
    for (auto i = 0; i < SETTING_NAV_TITLES.size(); ++i) {
      auto* font = ImGui::GetFont();
      auto old_scale = font->Scale;
      auto previous_font_size = ImGui::GetFontSize();
      font->Scale *= SETTING_NAV_RAIL_SIZE / previous_font_size;
      ImGui::PushFont(font);
      auto current_font_size = ImGui::GetFontSize();

      bool selected = setting_nav_item == i;
      if (!selected) {
        ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0, 0, 0, 0));
      }
      ImGui::PushID(std::format("##nav_rail_{}", i).c_str());
      if (ImGui::Button(
              SETTING_NAV_TITLES[i].second,
              ImVec2(SETTING_NAV_RAIL_SIZE, SETTING_NAV_RAIL_SIZE))) {
        setting_nav_item = i;
      }
      ImGui::PopID();
      if (!selected) {
        ImGui::PopStyleColor();
      }

      font->Scale = old_scale;
      ImGui::PopFont();

      ImGui::SetItemTooltip("%s", SETTING_NAV_TITLES[i].first);
    }
  }
  ImGui::EndChild();
}

enum CapturePaneColumns : uint8_t {
  CAPTURE_PANE_COLUMN_TYPE,
  CAPTURE_PANE_COLUMN_REF,
  CAPTURE_PANE_COLUMN_INFO,
  CAPTURE_PANE_COLUMN_REFLECTION,
  //
  CAPTURE_PANE_COLUMN_COUNT
};

void RenderCapturePane(reshade::api::device* device, DeviceData* data) {
  static ImGuiTreeNodeFlags tree_node_flags = ImGuiTreeNodeFlags_SpanAllColumns | ImGuiTreeNodeFlags_SpanFullWidth;
  if (ImGui::BeginTable(
          "##SnapshotTree",
          CAPTURE_PANE_COLUMN_COUNT,
          ImGuiTableFlags_BordersV | ImGuiTableFlags_BordersOuterH | ImGuiTableFlags_Resizable | ImGuiTableFlags_Hideable
              | ImGuiTableFlags_NoBordersInBody | ImGuiTableFlags_ScrollY,
          ImVec2(-4, -4))) {
    const auto char_width = ImGui::CalcTextSize("0").x;
    ImGui::TableSetupColumn("Type", ImGuiTableColumnFlags_NoHide | ImGuiTableColumnFlags_WidthFixed, char_width * 16.0f);
    ImGui::TableSetupColumn("Ref", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthFixed, char_width * 18.0f);
    ImGui::TableSetupColumn("Info", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthFixed, char_width * 24.0f);
    ImGui::TableSetupColumn("Reflection", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthStretch, -1.f);
    ImGui::TableSetupScrollFreeze(0, 1);
    ImGui::TableHeadersRow();

    int row_index = 0x2000;
    int draw_index = 0;
    for (auto& draw_details : data->draw_details_list) {
      ImGui::TableNextRow();
      bool draw_node_open = false;

      if (draw_index == pending_draw_index_focus) {
        ImGui::SetItemDefaultFocus();
        ImGui::SetScrollHereY();
        pending_draw_index_focus = -1;
      }

      if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
        auto flags = tree_node_flags;
        if (snapshot_pane_expand_all_nodes) {
          flags |= ImGuiTreeNodeFlags_DefaultOpen;
        }
        ImGui::PushID(row_index);
        draw_node_open = ImGui::TreeNodeEx("", flags, "%s", draw_details.DrawMethodString().c_str());
        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("%03d", draw_index);
      }

      for (const auto& [slot_space, buffer_range] : draw_details.constants) {
        const auto& slot = slot_space.first;
        const auto& space = slot_space.second;
        if (buffer_range.buffer.handle == 0u) continue;
        if (snapshot_pane_filter_resources_by_shader_use && draw_details.resource_binds.has_value()) {
          if (std::ranges::none_of(*draw_details.resource_binds, [&slot, &space](const ResourceBind& bind) {
                return bind.type == ResourceBind::BindType::CBV && bind.slot == slot && bind.space == space;
              })) {
            continue;
          }
        }
        ++row_index;

        if (draw_node_open) {
          ImGui::TableNextRow();

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
            SettingSelection search = {.constant_buffer_handle = buffer_range.buffer.handle};
            auto& selection = GetSelection(search);
            auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                | selection.GetTreeNodeFlags();

            ImGui::PushID(row_index);
            ImGui::TreeNodeEx("", bullet_flags, (space == 0) ? "CB%d" : "CB%d,space%d", slot, space);
            ImGui::PopID();
            if (ImGui::IsItemClicked()) {
              MakeSelectionCurrent(selection);
              ImGui::SetItemDefaultFocus();
            }
            if (ImGui::IsMouseDoubleClicked(ImGuiMouseButton_Left)) {
              selection.is_pinned = true;
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
            ImGui::Text("0x%016llX", buffer_range.buffer.handle);
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION))) {
            // auto tag = renodx::utils::trace::GetDebugName(device->get_api(), buffer_range.buffer.handle);
            // if (tag.has_value()) {
            //   ImGui::TextUnformatted(tag->c_str());
            // }
          }
        }
      }

      for (const auto& pipeline_bind : draw_details.pipeline_binds) {
        auto* pipeline_details_ptr = renodx::utils::shader::GetPipelineShaderDetails(pipeline_bind.pipeline);
        if (pipeline_details_ptr == nullptr) continue;

        auto& pipeline_details = *pipeline_details_ptr;

        if (!pipeline_details.tag.has_value()) {
          pipeline_details.tag = "";
          if (data->live_pipelines.contains(pipeline_bind.pipeline.handle)) {
            auto result = renodx::utils::trace::GetDebugName(device->get_api(), pipeline_bind.pipeline);
            if (result.has_value()) {
              pipeline_details.tag = result.value();
            }
          }
        }

        for (const auto& shader_hash : pipeline_bind.shader_hashes) {
          auto* shader_details = data->GetShaderDetails(shader_hash);
          switch (shader_details->shader_type) {
            case reshade::api::pipeline_stage::vertex_shader:
              if (!snapshot_pane_show_vertex_shaders) continue;
              break;
            case reshade::api::pipeline_stage::pixel_shader:
              if (!snapshot_pane_show_pixel_shaders) continue;
              break;
            case reshade::api::pipeline_stage::compute_shader:
              if (!snapshot_pane_show_compute_shaders) continue;
              break;
            default:
              break;
          }

          // Start drawing shader row
          ++row_index;  // Count rows regardless of tree node state
          if (draw_node_open) {
            ImGui::TableNextRow();

            SettingSelection search = {.shader_hash = shader_hash};
            auto& selection = GetSelection(search);

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
              ImGui::Text("0x%08X", shader_hash);

              const auto& set = data->shader_draw_indexes[shader_hash];
              auto it = set.find(draw_index);
              assert(it != set.end() && "Shader draw index not found");

              if (set.size() > 1) {
                ImGui::SameLine();
                ImGui::BeginDisabled(it == set.begin());
                ImGui::PushID(draw_index + 10000);
                int new_index = -1;
                if (ImGui::SmallButton("<")) {
                  new_index = *(--it);
                }
                ImGui::PopID();
                ImGui::EndDisabled();

                ImGui::SameLine();
                ImGui::BeginDisabled(std::next(it) == set.end());
                ImGui::PushID(draw_index + 20000);
                if (ImGui::SmallButton(">")) {
                  new_index = *(++it);
                }
                ImGui::PopID();
                ImGui::EndDisabled();

                if (new_index != -1) {
                  pending_draw_index_focus = new_index;
                  // Mark shader as selection as well
                  MakeSelectionCurrent(selection);
                }
              }
            }

            auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                | selection.GetTreeNodeFlags();

            // Fallback to subobject
            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
              ImGui::PushID(row_index);
              if (shader_details->program_version.has_value()) {
                ImGui::TreeNodeEx("", bullet_flags, "%s_%d_%d",
                                  shader_details->program_version->GetKindAbbr(),
                                  shader_details->program_version->GetMajor(),
                                  shader_details->program_version->GetMinor());
              } else {
                std::stringstream s;
                s << shader_details->shader_type;
                ImGui::TreeNodeEx("", bullet_flags, "%s", s.str().c_str());
              }
              ImGui::PopID();
              if (pending_draw_index_focus == -1) {
                if (ImGui::IsItemClicked()) {
                  MakeSelectionCurrent(selection);
                  ImGui::SetItemDefaultFocus();
                }
                if (ImGui::IsMouseDoubleClicked(ImGuiMouseButton_Left)) {
                  selection.is_pinned = true;
                }
              }
            }

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
              RenderFileAlias(shader_details->disk_shader);
            }

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION))) {
              auto entrypoint = GetEntryPointForShaderDetails(device, data, shader_details);
              if (!entrypoint.empty() && entrypoint != "main") {
                ImGui::TextUnformatted(entrypoint.c_str());
              } else if (!pipeline_details.tag->empty()) {
                ImGui::TextUnformatted(pipeline_details.tag->c_str());
              }
            }
          }
        }
      }

      for (auto& [slot_space, resource_view_details] : draw_details.srv_binds) {
        const auto& slot = slot_space.first;
        const auto& space = slot_space.second;
        if (snapshot_pane_filter_resources_by_shader_use && draw_details.resource_binds.has_value()) {
          if (std::ranges::none_of(*draw_details.resource_binds, [&slot, &space](const ResourceBind& bind) {
                return bind.type == ResourceBind::BindType::SRV && bind.slot == slot && bind.space == space;
              })) {
            continue;
          }
        }
        ++row_index;
        bool srv_node_open = false;
        if (draw_node_open) {
          ImGui::TableNextRow();
          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
            ImGui::PushID(row_index);
            srv_node_open = ImGui::TreeNodeEx(
                "",
                tree_node_flags | ImGuiTreeNodeFlags_DefaultOpen,
                (space == 0) ? "T%d" : "T%d,space%d", slot, space);
            ImGui::PopID();
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
            ImGui::Text("0x%016llX", resource_view_details.resource_view.handle);
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
            std::stringstream s;
            s << resource_view_details.resource_view_desc.format;
            if (resource_view_details.is_swapchain) {
              ImGui::TextColored(ImVec4(0, 255, 0, 255), "%s", s.str().c_str());
            } else if (resource_view_details.is_rtv_upgraded) {
              ImGui::TextColored(ImVec4(0, 255, 255, 255), "%s", s.str().c_str());
            } else if (resource_view_details.is_rtv_cloned) {
              ImGui::TextColored(ImVec4(255, 255, 0, 255), "%s", s.str().c_str());
            } else {
              ImGui::TextUnformatted(s.str().c_str());
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION))) {
            if (!resource_view_details.resource_view_reflection.empty()) {
              ImGui::TextUnformatted(resource_view_details.resource_view_reflection.c_str());
            }
          }
        }

        ++row_index;
        if (srv_node_open) {
          SettingSelection search = {
              .resource_handle = resource_view_details.resource.handle,
              .resource_view_handle = resource_view_details.resource_view.handle,
          };
          auto& selection = GetSelection(search);

          ImGui::TableNextRow();
          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
            auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                | selection.GetTreeNodeFlags();
            ImGui::PushID(row_index);
            ImGui::TreeNodeEx("", bullet_flags, "Resource");
            ImGui::PopID();

            if (ImGui::IsItemClicked()) {
              MakeSelectionCurrent(selection);
              ImGui::SetItemDefaultFocus();
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
            ImGui::Text("0x%016llX", resource_view_details.resource.handle);
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
            std::stringstream s;

            if (resource_view_details.resource_desc.type == reshade::api::resource_type::buffer) {
              s << "Buffer (" << resource_view_details.resource_desc.buffer.size << " bytes)";
            } else {
              s << resource_view_details.resource_desc.texture.format;
            }

            if (resource_view_details.is_swapchain) {
              ImGui::TextColored(ImVec4(0, 255, 0, 255), "%s", s.str().c_str());
            } else if (resource_view_details.is_res_upgraded) {
              ImGui::TextColored(ImVec4(0, 255, 255, 255), "%s", s.str().c_str());
            } else if (resource_view_details.is_res_cloned) {
              ImGui::TextColored(ImVec4(255, 255, 0, 255), "%s", s.str().c_str());
            } else {
              ImGui::TextUnformatted(s.str().c_str());
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION))) {
            if (!resource_view_details.resource_reflection.empty()) {
              ImGui::TextUnformatted(resource_view_details.resource_reflection.c_str());
            }
          }

          if (resource_view_details.resource_desc.texture.format != reshade::api::format::unknown) {
            row_index++;
            ImGui::TableNextRow();

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
              auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                  | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                  | selection.GetTreeNodeFlags();
              ImGui::PushID(row_index);
              ImGui::TreeNodeEx("", bullet_flags, "Dimensions");
              ImGui::PopID();
              if (ImGui::IsItemClicked()) {
                MakeSelectionCurrent(selection);
                ImGui::SetItemDefaultFocus();
              }
            }

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
              ImGui::Text("0x%016llX", resource_view_details.resource.handle);
            }

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
              if (resource_view_details.resource_desc.type == reshade::api::resource_type::texture_3d) {
                ImGui::Text("%dx%dx%d", resource_view_details.resource_desc.texture.width, resource_view_details.resource_desc.texture.height, resource_view_details.resource_desc.texture.depth_or_layers);
              } else {
                ImGui::Text("%dx%d", resource_view_details.resource_desc.texture.width, resource_view_details.resource_desc.texture.height);
              }
            }
          }

          ImGui::TreePop();
        }
      }

      for (auto& [slot_space, resource_view_details] : draw_details.uav_binds) {
        const auto& slot = slot_space.first;
        const auto& space = slot_space.second;

        if (snapshot_pane_filter_resources_by_shader_use && draw_details.resource_binds.has_value()) {
          if (std::ranges::none_of(*draw_details.resource_binds, [&slot, &space](const ResourceBind& bind) {
                return bind.type == ResourceBind::BindType::UAV && bind.slot == slot && bind.space == space;
              })) {
            continue;
          }
        }

        ++row_index;
        bool uav_node_open = false;
        if (draw_node_open) {
          ImGui::TableNextRow();
          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
            ImGui::PushID(row_index);

            uav_node_open = ImGui::TreeNodeEx(
                "",
                tree_node_flags | ImGuiTreeNodeFlags_DefaultOpen,
                (space == 0) ? "UAV%d" : "UAV%d,space%d", slot, space);

            ImGui::PopID();
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
            ImGui::Text("0x%016llX", resource_view_details.resource_view.handle);
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
            std::stringstream s;
            s << resource_view_details.resource_view_desc.format;
            if (resource_view_details.is_swapchain) {
              ImGui::TextColored(ImVec4(0, 255, 0, 255), "%s", s.str().c_str());
            } else if (resource_view_details.is_rtv_upgraded) {
              ImGui::TextColored(ImVec4(0, 255, 255, 255), "%s", s.str().c_str());
            } else if (resource_view_details.is_rtv_cloned) {
              ImGui::TextColored(ImVec4(255, 255, 0, 255), "%s", s.str().c_str());
            } else {
              ImGui::TextUnformatted(s.str().c_str());
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION))) {
            if (!resource_view_details.resource_view_reflection.empty()) {
              ImGui::TextUnformatted(resource_view_details.resource_view_reflection.c_str());
            }
          }
        }
        ++row_index;
        if (uav_node_open) {
          SettingSelection search = {.resource_handle = resource_view_details.resource.handle};
          auto& selection = GetSelection(search);

          ImGui::TableNextRow();
          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
            auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                | selection.GetTreeNodeFlags();
            ImGui::PushID(row_index);
            ImGui::TreeNodeEx("", bullet_flags, "Resource");
            ImGui::PopID();
            if (ImGui::IsItemClicked()) {
              MakeSelectionCurrent(selection);
              ImGui::SetItemDefaultFocus();
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
            ImGui::Text("0x%016llX", resource_view_details.resource.handle);
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
            std::stringstream s;
            if (resource_view_details.resource_desc.type == reshade::api::resource_type::buffer) {
              s << "Buffer (" << resource_view_details.resource_desc.buffer.size << " bytes)";
            } else {
              s << resource_view_details.resource_desc.texture.format;
            }

            if (resource_view_details.is_swapchain) {
              ImGui::TextColored(ImVec4(0, 255, 0, 255), "%s", s.str().c_str());
            } else if (resource_view_details.is_res_upgraded) {
              ImGui::TextColored(ImVec4(0, 255, 255, 255), "%s", s.str().c_str());
            } else if (resource_view_details.is_res_cloned) {
              ImGui::TextColored(ImVec4(255, 255, 0, 255), "%s", s.str().c_str());
            } else {
              ImGui::TextUnformatted(s.str().c_str());
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION))) {
            if (!resource_view_details.resource_reflection.empty()) {
              ImGui::TextUnformatted(resource_view_details.resource_reflection.c_str());
            }
          }

          if (resource_view_details.resource_desc.texture.format != reshade::api::format::unknown) {
            row_index++;
            ImGui::TableNextRow();

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
              auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                  | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                  | selection.GetTreeNodeFlags();
              ImGui::PushID(row_index);
              ImGui::TreeNodeEx("", bullet_flags, "Dimensions");
              ImGui::PopID();
              if (ImGui::IsItemClicked()) {
                MakeSelectionCurrent(selection);
                ImGui::SetItemDefaultFocus();
              }
            }

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
              ImGui::Text("0x%016llX", resource_view_details.resource.handle);
            }

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
              if (resource_view_details.resource_desc.type == reshade::api::resource_type::texture_3d) {
                ImGui::Text("%dx%dx%d", resource_view_details.resource_desc.texture.width, resource_view_details.resource_desc.texture.height, resource_view_details.resource_desc.texture.depth_or_layers);
              } else {
                ImGui::Text("%dx%d", resource_view_details.resource_desc.texture.width, resource_view_details.resource_desc.texture.height);
              }
            }
          }

          ImGui::TreePop();
        }
      }

      for (auto& [rtv_index, render_target] : draw_details.render_targets) {
        ++row_index;
        bool rtv_node_open = false;
        if (draw_node_open) {
          ImGui::TableNextRow();
          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
            ImGui::PushID(row_index);
            rtv_node_open = ImGui::TreeNodeEx("", tree_node_flags | ImGuiTreeNodeFlags_DefaultOpen, "RTV%d", rtv_index);
            ImGui::PopID();
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
            ImGui::Text("0x%016llX", render_target.resource_view.handle);
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
            std::stringstream s;
            s << render_target.resource_view_desc.format;
            if (render_target.is_swapchain) {
              ImGui::TextColored(ImVec4(0, 255, 0, 255), "%s", s.str().c_str());
            } else if (render_target.is_rtv_upgraded) {
              ImGui::TextColored(ImVec4(0, 255, 255, 255), "%s", s.str().c_str());
            } else if (render_target.is_rtv_cloned) {
              ImGui::TextColored(ImVec4(255, 255, 0, 255), "%s", s.str().c_str());
            } else {
              ImGui::TextUnformatted(s.str().c_str());
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION))) {
            if (!render_target.resource_view_reflection.empty()) {
              ImGui::TextUnformatted(render_target.resource_view_reflection.c_str());
            }
          }
        }

        ++row_index;
        SettingSelection search = {.resource_handle = render_target.resource.handle};
        auto& selection = GetSelection(search);
        if (rtv_node_open) {
          ImGui::TableNextRow();
          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
            auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                | selection.GetTreeNodeFlags();
            ImGui::PushID(row_index);
            ImGui::TreeNodeEx("", bullet_flags, "Resource");
            ImGui::PopID();
            if (ImGui::IsItemClicked()) {
              MakeSelectionCurrent(selection);
              ImGui::SetItemDefaultFocus();
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
            ImGui::Text("0x%016llX", render_target.resource.handle);
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
            std::stringstream s;
            if (render_target.resource_desc.type == reshade::api::resource_type::buffer) {
              s << "Buffer (" << render_target.resource_desc.buffer.size << " bytes)";
            } else {
              s << render_target.resource_desc.texture.format;
            }

            if (render_target.is_swapchain) {
              ImGui::TextColored(ImVec4(0, 255, 0, 255), "%s", s.str().c_str());
            } else if (render_target.is_res_upgraded) {
              ImGui::TextColored(ImVec4(0, 255, 255, 255), "%s", s.str().c_str());
            } else if (render_target.is_res_cloned) {
              ImGui::TextColored(ImVec4(255, 255, 0, 255), "%s", s.str().c_str());
            } else {
              ImGui::TextUnformatted(s.str().c_str());
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION))) {
            if (!render_target.resource_reflection.empty()) {
              ImGui::TextUnformatted(render_target.resource_reflection.c_str());
            }
          }
        }

        if (render_target.resource_desc.texture.format != reshade::api::format::unknown) {
          row_index++;
          if (rtv_node_open) {
            ImGui::TableNextRow();
            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
              auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                  | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                  | selection.GetTreeNodeFlags();
              ImGui::PushID(row_index);
              ImGui::TreeNodeEx("", bullet_flags, "Dimensions");
              ImGui::PopID();
              if (ImGui::IsItemClicked()) {
                MakeSelectionCurrent(selection);
                ImGui::SetItemDefaultFocus();
              }
            }

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
              ImGui::Text("0x%016llX", render_target.resource.handle);
            }

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
              if (render_target.resource_desc.type == reshade::api::resource_type::texture_3d) {
                ImGui::Text("%dx%dx%d",
                            render_target.resource_desc.texture.width,
                            render_target.resource_desc.texture.height,
                            render_target.resource_desc.texture.depth_or_layers);
              } else {
                ImGui::Text("%dx%d",
                            render_target.resource_desc.texture.width,
                            render_target.resource_desc.texture.height);
              }
            }
          }
        }

        if (draw_details.blend_desc.has_value()) {
          auto& blend_desc = draw_details.blend_desc.value();

          const auto& alpha_to_coverage_enable = blend_desc.alpha_to_coverage_enable;
          const auto& blend_enable = blend_desc.blend_enable[rtv_index];
          const auto& logic_op_enable = blend_desc.logic_op_enable[rtv_index];
          const auto& source_color_blend_factor = blend_desc.source_color_blend_factor[rtv_index];
          const auto& dest_color_blend_factor = blend_desc.dest_color_blend_factor[rtv_index];
          const auto& color_blend_op = blend_desc.color_blend_op[rtv_index];
          const auto& source_alpha_blend_factor = blend_desc.source_alpha_blend_factor[rtv_index];
          const auto& dest_alpha_blend_factor = blend_desc.dest_alpha_blend_factor[rtv_index];
          const auto& alpha_blend_op = blend_desc.alpha_blend_op[rtv_index];
          const auto& blend_constant = blend_desc.blend_constant;
          const auto& logic_op = blend_desc.logic_op[rtv_index];
          const auto& render_target_write_mask = blend_desc.render_target_write_mask[rtv_index];

          if (blend_enable) {
            ++row_index;
            if (rtv_node_open) {
              ImGui::TableNextRow();
              if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
                auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                    | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                    | selection.GetTreeNodeFlags();
                ImGui::PushID(row_index);
                ImGui::TreeNodeEx("", bullet_flags, "Blend");
                ImGui::PopID();
                if (ImGui::IsItemClicked()) {
                  MakeSelectionCurrent(selection);
                  ImGui::SetItemDefaultFocus();
                }
              }

              static const std::vector<std::pair<std::string, reshade::api::blend_desc>> KNOWN_BLENDS = {
                  // Porter-Duff Modes: https://graphics.pixar.com/library/Compositing/paper.pdf
                  // https://developer.android.com/reference/android/graphics/PorterDuff.Mode
                  {"CLEAR", reshade::api::blend_desc{
                                .source_color_blend_factor = {reshade::api::blend_factor::zero},
                                .dest_color_blend_factor = {reshade::api::blend_factor::zero},
                                .source_alpha_blend_factor = {reshade::api::blend_factor::zero},
                                .dest_alpha_blend_factor = {reshade::api::blend_factor::zero},
                            }},
                  {"SRC", reshade::api::blend_desc{
                              .source_color_blend_factor = {reshade::api::blend_factor::one},
                              .dest_color_blend_factor = {reshade::api::blend_factor::zero},
                              .source_alpha_blend_factor = {reshade::api::blend_factor::one},
                              .dest_alpha_blend_factor = {reshade::api::blend_factor::zero},
                          }},
                  {"DST", reshade::api::blend_desc{
                              .source_color_blend_factor = {reshade::api::blend_factor::zero},
                              .dest_color_blend_factor = {reshade::api::blend_factor::one},
                              .source_alpha_blend_factor = {reshade::api::blend_factor::zero},
                              .dest_alpha_blend_factor = {reshade::api::blend_factor::one},
                          }},
                  {"SRC_OVER", reshade::api::blend_desc{
                                   .source_color_blend_factor = {reshade::api::blend_factor::one},
                                   .dest_color_blend_factor = {reshade::api::blend_factor::one_minus_source_alpha},
                                   .source_alpha_blend_factor = {reshade::api::blend_factor::one},
                                   .dest_alpha_blend_factor = {reshade::api::blend_factor::one_minus_source_alpha},
                               }},
                  {"DST_OVER", reshade::api::blend_desc{
                                   .source_color_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                                   .dest_color_blend_factor = {reshade::api::blend_factor::one},
                                   .source_alpha_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                                   .dest_alpha_blend_factor = {reshade::api::blend_factor::one},
                               }},
                  {"SRC_IN", reshade::api::blend_desc{
                                 .source_color_blend_factor = {reshade::api::blend_factor::dest_alpha},
                                 .dest_color_blend_factor = {reshade::api::blend_factor::zero},
                                 .source_alpha_blend_factor = {reshade::api::blend_factor::dest_alpha},
                                 .dest_alpha_blend_factor = {reshade::api::blend_factor::zero},
                             }},
                  {"DEST_IN", reshade::api::blend_desc{
                                  .source_color_blend_factor = {reshade::api::blend_factor::zero},
                                  .dest_color_blend_factor = {reshade::api::blend_factor::source_alpha},
                                  .source_alpha_blend_factor = {reshade::api::blend_factor::zero},
                                  .dest_alpha_blend_factor = {reshade::api::blend_factor::source_alpha},
                              }},
                  {"SRC_OUT", reshade::api::blend_desc{
                                  .source_color_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                                  .dest_color_blend_factor = {reshade::api::blend_factor::zero},
                                  .source_alpha_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                                  .dest_alpha_blend_factor = {reshade::api::blend_factor::zero},
                              }},
                  {"DEST_OUT", reshade::api::blend_desc{
                                   .source_color_blend_factor = {reshade::api::blend_factor::zero},
                                   .dest_color_blend_factor = {reshade::api::blend_factor::one_minus_source_alpha},
                                   .source_alpha_blend_factor = {reshade::api::blend_factor::zero},
                                   .dest_alpha_blend_factor = {reshade::api::blend_factor::one_minus_source_alpha},
                               }},
                  {"SRC_ATOP", reshade::api::blend_desc{
                                   .source_color_blend_factor = {reshade::api::blend_factor::dest_alpha},
                                   .dest_color_blend_factor = {reshade::api::blend_factor::one_minus_source_alpha},
                                   .source_alpha_blend_factor = {reshade::api::blend_factor::dest_alpha},
                                   .dest_alpha_blend_factor = {reshade::api::blend_factor::one_minus_source_alpha},
                               }},

                  {"SRC_ATOP", reshade::api::blend_desc{
                                   .source_color_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                                   .dest_color_blend_factor = {reshade::api::blend_factor::source_alpha},
                                   .source_alpha_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                                   .dest_alpha_blend_factor = {reshade::api::blend_factor::source_alpha},
                               }},

                  {"DST_ATOP", reshade::api::blend_desc{
                                   .source_color_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                                   .dest_color_blend_factor = {reshade::api::blend_factor::source_alpha},
                                   .source_alpha_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                                   .dest_alpha_blend_factor = {reshade::api::blend_factor::source_alpha},
                               }},

                  {"XOR", reshade::api::blend_desc{
                              .source_color_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                              .dest_color_blend_factor = {reshade::api::blend_factor::one_minus_source_alpha},
                              .source_alpha_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                              .dest_alpha_blend_factor = {reshade::api::blend_factor::one_minus_source_alpha},
                          }},

                  {"PLUS", reshade::api::blend_desc{
                               .source_color_blend_factor = {reshade::api::blend_factor::one},
                               .dest_color_blend_factor = {reshade::api::blend_factor::one},
                               .source_alpha_blend_factor = {reshade::api::blend_factor::one},
                               .dest_alpha_blend_factor = {reshade::api::blend_factor::one},
                           }},
                  // Alternate
                  {"SRC_ATOP", reshade::api::blend_desc{
                                   .source_color_blend_factor = {reshade::api::blend_factor::dest_alpha},
                                   .dest_color_blend_factor = {reshade::api::blend_factor::one_minus_source_alpha},
                                   .source_alpha_blend_factor = {reshade::api::blend_factor::zero},
                                   .dest_alpha_blend_factor = {reshade::api::blend_factor::one},
                               }},

                  // Alternate
                  {"DST_ATOP", reshade::api::blend_desc{
                                   .source_color_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                                   .dest_color_blend_factor = {reshade::api::blend_factor::source_alpha},
                                   .source_alpha_blend_factor = {reshade::api::blend_factor::one},
                                   .dest_alpha_blend_factor = {reshade::api::blend_factor::zero},
                               }},

                  // Custom
                  {"SRC_ADD", reshade::api::blend_desc{
                                  .source_color_blend_factor = {reshade::api::blend_factor::one},
                                  .dest_color_blend_factor = {reshade::api::blend_factor::one},
                                  .source_alpha_blend_factor = {reshade::api::blend_factor::one},
                                  .dest_alpha_blend_factor = {reshade::api::blend_factor::zero},
                              }},
                  {"SRC_ADD_SAT", reshade::api::blend_desc{
                                      .source_color_blend_factor = {reshade::api::blend_factor::one},
                                      .dest_color_blend_factor = {reshade::api::blend_factor::one},
                                      .source_alpha_blend_factor = {reshade::api::blend_factor::source_alpha_saturate},
                                      .dest_alpha_blend_factor = {reshade::api::blend_factor::zero},
                                  }},
                  {"DEST_ADD", reshade::api::blend_desc{
                                   .source_color_blend_factor = {reshade::api::blend_factor::one},
                                   .dest_color_blend_factor = {reshade::api::blend_factor::one},
                                   .source_alpha_blend_factor = {reshade::api::blend_factor::zero},
                                   .dest_alpha_blend_factor = {reshade::api::blend_factor::one},
                               }},
                  {"SRC_ADD_SAT", reshade::api::blend_desc{
                                      .source_color_blend_factor = {reshade::api::blend_factor::one},
                                      .dest_color_blend_factor = {reshade::api::blend_factor::one},
                                      .source_alpha_blend_factor = {reshade::api::blend_factor::source_alpha_saturate},
                                      .dest_alpha_blend_factor = {reshade::api::blend_factor::zero},
                                  }},
                  {"MULTIPLY", reshade::api::blend_desc{
                                   .source_color_blend_factor = {reshade::api::blend_factor::dest_color},
                                   .dest_color_blend_factor = {reshade::api::blend_factor::zero},
                                   .source_alpha_blend_factor = {reshade::api::blend_factor::dest_alpha},
                                   .dest_alpha_blend_factor = {reshade::api::blend_factor::zero},
                               }},

                  {"MULTIPLY", reshade::api::blend_desc{
                                   .source_color_blend_factor = {reshade::api::blend_factor::zero},
                                   .dest_color_blend_factor = {reshade::api::blend_factor::source_color},
                                   .source_alpha_blend_factor = {reshade::api::blend_factor::zero},
                                   .dest_alpha_blend_factor = {reshade::api::blend_factor::dest_alpha},
                               }},

                  {"SCREEN", reshade::api::blend_desc{
                                 .source_color_blend_factor = {reshade::api::blend_factor::one},
                                 .dest_color_blend_factor = {reshade::api::blend_factor::one_minus_source_color},
                                 .source_alpha_blend_factor = {reshade::api::blend_factor::one},
                                 .dest_alpha_blend_factor = {reshade::api::blend_factor::one_minus_dest_alpha},
                             }},

              };

              if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
                std::string details = "Unknown";
                for (const auto& [name, known_blend] : KNOWN_BLENDS) {
                  if (known_blend.color_blend_op[0] == color_blend_op
                      && known_blend.alpha_blend_op[0] == alpha_blend_op
                      && known_blend.source_color_blend_factor[0] == source_color_blend_factor
                      && known_blend.dest_color_blend_factor[0] == dest_color_blend_factor
                      && known_blend.source_alpha_blend_factor[0] == source_alpha_blend_factor
                      && known_blend.dest_alpha_blend_factor[0] == dest_alpha_blend_factor) {
                    details = name;
                    break;
                  }
                }

                // Unknown?
                // (sc * 0) + (1 - sc)* dc = dc - sc * dc;
                // (sa * 0) + (1 - sa)* da = d - s * d;

                if (alpha_to_coverage_enable) {
                  details += " | Alpha to Coverage";
                }
                if (logic_op_enable) {
                  details += " | Logic Op";
                }
                ImGui::TextUnformatted(details.c_str());
              }
            }
          }

          if (render_target_write_mask != 0xF) {
            // Add row for render target write mask
            ++row_index;
            if (rtv_node_open) {
              ImGui::TableNextRow();
              if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
                auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                    | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                    | selection.GetTreeNodeFlags();
                ImGui::PushID(row_index);
                ImGui::TreeNodeEx("", bullet_flags, "Write Mask");
                ImGui::PopID();
                if (ImGui::IsItemClicked()) {
                  MakeSelectionCurrent(selection);
                  ImGui::SetItemDefaultFocus();
                }
              }

              if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
                std::string details;
                if ((render_target_write_mask & 0x1) != 0) {
                  details += "R";
                }
                if ((render_target_write_mask & 0x2) != 0) {
                  details += "G";
                }
                if ((render_target_write_mask & 0x4) != 0) {
                  details += "B";
                }
                if ((render_target_write_mask & 0x8) != 0) {
                  details += "A";
                }

                if (details.empty()) {
                  details = "(none)";
                }

                ImGui::TextUnformatted(details.c_str());
              }
            }
          }
        }

        if (rtv_node_open) {
          ImGui::TreePop();
        }
      }

      if (draw_details.copy_source.handle != 0u) {
        ++row_index;
        bool res_node_open = false;
        if (draw_node_open) {
          ImGui::TableNextRow();
          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
            SettingSelection search = {.resource_handle = draw_details.copy_source.handle};
            auto& selection = GetSelection(search);
            auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                | selection.GetTreeNodeFlags();

            ImGui::PushID(row_index);
            ImGui::TreeNodeEx("", bullet_flags, "Source");
            ImGui::PopID();
            if (ImGui::IsItemClicked()) {
              MakeSelectionCurrent(selection);
              ImGui::SetItemDefaultFocus();
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
            ImGui::Text("0x%016llX", draw_details.copy_source.handle);
          }

          auto* info = renodx::utils::resource::GetResourceInfo(draw_details.copy_source);
          if (info != nullptr) {
            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
              std::stringstream s;
              if (info->desc.type == reshade::api::resource_type::buffer) {
                s << "Buffer (" << info->desc.buffer.size << " bytes)";
              } else {
                s << info->desc.texture.format;
              }

              if (info->is_swap_chain) {
                ImGui::TextColored(ImVec4(0, 255, 0, 255), "%s", s.str().c_str());
              } else if (info->upgraded) {
                ImGui::TextColored(ImVec4(0, 255, 255, 255), "%s", s.str().c_str());
              } else if (info->clone.handle != 0u) {
                ImGui::TextColored(ImVec4(255, 255, 0, 255), "%s", s.str().c_str());
              } else {
                ImGui::TextUnformatted(s.str().c_str());
              }
            }
          }
        }
      }

      if (draw_details.copy_destination.handle != 0u) {
        ++row_index;
        bool res_node_open = false;
        if (draw_node_open) {
          ImGui::TableNextRow();
          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
            SettingSelection search = {.resource_handle = draw_details.copy_destination.handle};
            auto& selection = GetSelection(search);
            auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                | selection.GetTreeNodeFlags();

            ImGui::PushID(row_index);
            ImGui::TreeNodeEx("", bullet_flags, "Destination");
            ImGui::PopID();
            if (ImGui::IsItemClicked()) {
              MakeSelectionCurrent(selection);
              ImGui::SetItemDefaultFocus();
            }
          }

          if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF))) {
            ImGui::Text("0x%016llX", draw_details.copy_destination.handle);
          }

          auto* info = renodx::utils::resource::GetResourceInfo(draw_details.copy_destination);
          if (info != nullptr) {
            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
              std::stringstream s;
              if (info->desc.type == reshade::api::resource_type::buffer) {
                s << "Buffer (" << info->desc.buffer.size << " bytes)";
              } else {
                s << info->desc.texture.format;
              }
              if (info->is_swap_chain) {
                ImGui::TextColored(ImVec4(0, 255, 0, 255), "%s", s.str().c_str());
              } else if (info->upgraded) {
                ImGui::TextColored(ImVec4(0, 255, 255, 255), "%s", s.str().c_str());
              } else if (info->clone.handle != 0u) {
                ImGui::TextColored(ImVec4(255, 255, 0, 255), "%s", s.str().c_str());
              } else {
                ImGui::TextUnformatted(s.str().c_str());
              }
            }
          }
        }
      }

      if (draw_node_open) {
        ImGui::TreePop();
      }
      ++row_index;
      ++draw_index;
    }

    ImGui::EndTable();
  }  // namespace
}

// Creates a selectable with the given label that jumps to the specified snapshot index
inline void CreateDrawIndexLink(const std::string& label, int draw_index) {
  if (ImGui::TextLink(label.c_str())) {
    setting_nav_item = 0;  // Snapshot is the first nav item
    pending_draw_index_focus = draw_index;
  }
}

enum ShaderPaneColumns : uint8_t {
  SHADER_PANE_COLUMN_HASH,
  SHADER_PANE_COLUMN_TYPE,
  SHADER_PANE_COLUMN_ALIAS,
  SHADER_PANE_COLUMN_SOURCE,
  SHADER_PANE_COLUMN_SNAPSHOT,
  SHADER_PANE_COLUMN_OPTIONS,
  //
  SHADER_PANE_COLUMN_COUNT
};

void RenderShadersPane(reshade::api::device* device, DeviceData* data) {
  static ImGuiTreeNodeFlags tree_node_flags = ImGuiTreeNodeFlags_SpanAllColumns | ImGuiTreeNodeFlags_SpanFullWidth;

  if (ImGui::BeginTable(
          "##ShadersPaneTable",
          SHADER_PANE_COLUMN_COUNT,
          ImGuiTableFlags_BordersInner | ImGuiTableFlags_Resizable | ImGuiTableFlags_ScrollY
              | ImGuiTableFlags_Sortable | ImGuiTableFlags_SortMulti | ImGuiTableFlags_Hideable,
          ImVec2(0, 0))) {
    const auto char_width = ImGui::CalcTextSize("0").x;
    ImGui::TableSetupColumn("Hash", ImGuiTableColumnFlags_NoHide | ImGuiTableColumnFlags_WidthFixed, char_width * 10.f);
    ImGui::TableSetupColumn("Type", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthFixed, char_width * 6.0f);
    ImGui::TableSetupColumn("Alias", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthStretch, -1.f);
    ImGui::TableSetupColumn("Source", ImGuiTableColumnFlags_NoHide | ImGuiTableColumnFlags_WidthFixed, (char_width * 8.f) + 20.f);
    ImGui::TableSetupColumn("Snapshot", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthFixed, char_width * 3.f);
    ImGui::TableSetupColumn("Options", ImGuiTableColumnFlags_NoHide | ImGuiTableColumnFlags_WidthFixed, 2.f * ((char_width * 4.f) + (ImGui::GetStyle().FramePadding.x * 2) + 8.f));
    ImGui::TableSetupScrollFreeze(0, 1);
    ImGui::TableHeadersRow();

    int cell_index_id = 0x10000;
    int current_snapshot_index = 0;

    std::unordered_set<uint32_t> drawn_hashes;

    auto draw_row = [&](ShaderDetails* shader_details, int snapshot_index = -1) {
      if (drawn_hashes.contains(shader_details->shader_hash)) return;
      switch (shader_details->shader_type) {
        case reshade::api::pipeline_stage::vertex_shader:
          if (!shaders_pane_show_vertex_shaders) return;
          break;
        case reshade::api::pipeline_stage::pixel_shader:
          if (!shaders_pane_show_pixel_shaders) return;
          break;
        case reshade::api::pipeline_stage::compute_shader:
          if (!shaders_pane_show_compute_shaders) return;
          break;
        default:
          break;
      }
      SettingSelection search = {.shader_hash = shader_details->shader_hash};
      auto& selection = GetSelection(search);

      // Undocumented ImGui Combo height
      const auto combo_height = ImGui::GetTextLineHeightWithSpacing();
      ImGui::TableNextRow(ImGuiTableRowFlags_None, combo_height);
      if (ImGui::TableSetColumnIndex(SHADER_PANE_COLUMN_HASH)) {
        ImGui::PushID(cell_index_id++);

        // ImGui full size (0,0) applies to text not row
        // ImGui borders are always present, just transparent
        const auto row_border_size = 1;
        const auto selectable_height = combo_height + (2 * row_border_size);

        ImGui::PushStyleVar(ImGuiStyleVar_SelectableTextAlign, ImVec2(0, 0.5f));
        if (ImGui::Selectable(
                std::format("0x{:08x}", shader_details->shader_hash).c_str(),
                selection.is_current,
                ImGuiSelectableFlags_SpanAllColumns | ImGuiSelectableFlags_AllowOverlap,
                ImVec2(0, selectable_height))) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
        ImGui::PopStyleVar();
        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(SHADER_PANE_COLUMN_ALIAS)) {
        ImGui::PushID(cell_index_id++);
        ImGui::AlignTextToFramePadding();
        if (!RenderFileAlias(shader_details->disk_shader)) {
          auto entrypoint = GetEntryPointForShaderDetails(device, data, shader_details);
          if (!entrypoint.empty() && entrypoint != "main") {
            ImGui::TextUnformatted(entrypoint.c_str());
          }
        }
        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(SHADER_PANE_COLUMN_TYPE)) {
        ImGui::PushID(cell_index_id++);
        if (shader_details->program_version.has_value()) {
          ImGui::Text("%s_%d_%d",
                      shader_details->program_version->GetKindAbbr(),
                      shader_details->program_version->GetMajor(),
                      shader_details->program_version->GetMinor());
        } else {
          bool drawn = false;
          switch (device->get_api()) {
            case reshade::api::device_api::opengl:
            case reshade::api::device_api::vulkan:
              switch (shader_details->shader_type) {
                case reshade::api::pipeline_stage::pixel_shader:
                  ImGui::Text("frag");
                  drawn = true;
                  break;
                case reshade::api::pipeline_stage::vertex_shader:
                  ImGui::Text("vert");
                  drawn = true;
                  break;
                case reshade::api::pipeline_stage::compute_shader:
                  ImGui::Text("comp");
                  drawn = true;
                  break;
                default:
                  break;
              }
              break;
            default:
              break;
          }
          if (!drawn) {
            std::stringstream s;
            s << shader_details->shader_type;
            ImGui::TextUnformatted(s.str().c_str());
          }
        }
        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(SHADER_PANE_COLUMN_SOURCE)) {  // Source
        ImGui::PushID(cell_index_id++);
        ImGui::SetNextItemWidth(ImGui::GetColumnWidth(2));
        if (shader_details->shader_source == ShaderDetails::ShaderSource::ORIGINAL_SHADER
            && shader_details->addon_shader.empty() && !shader_details->disk_shader.has_value()) {
          ImGui::TextDisabled("%s", ShaderDetails::SHADER_SOURCE_NAMES[0]);
        } else {
          if (ImGui::BeginCombo(
                  "",
                  ShaderDetails::SHADER_SOURCE_NAMES[static_cast<int>(shader_details->shader_source)],
                  ImGuiComboFlags_None)) {
            for (int i = 0; i < IM_ARRAYSIZE(ShaderDetails::SHADER_SOURCE_NAMES); ++i) {
              const bool is_selected = (i == static_cast<int>(shader_details->shader_source));

              ImGui::BeginDisabled(
                  (i == 1 && shader_details->addon_shader.empty())
                  || (i == 2 && (!shader_details->disk_shader.has_value() || !shader_details->disk_shader->IsCompilationOK())));
              if (ImGui::Selectable(ShaderDetails::SHADER_SOURCE_NAMES[i], is_selected)) {
                shader_details->shader_source = static_cast<ShaderDetails::ShaderSource>(i);
                DeactivateShader(device, shader_details->shader_hash);
                if (i == 1) {
                  ActivateShader(device, shader_details->shader_hash, shader_details->addon_shader);
                } else if (i == 2) {
                  const auto& shader_data = shader_details->disk_shader->GetCompilationData();
                  ActivateShader(device, shader_details->shader_hash, shader_data);
                }
              }
              if (is_selected) {
                ImGui::SetItemDefaultFocus();
              }
              ImGui::EndDisabled();
            }
            ImGui::EndCombo();
          };
        }

        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(SHADER_PANE_COLUMN_SNAPSHOT)) {  // Snapshot
        ImGui::PushID(cell_index_id++);
        if (snapshot_index != -1) {
          CreateDrawIndexLink(std::format("{:03}", snapshot_index), snapshot_index);
        }
        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(SHADER_PANE_COLUMN_OPTIONS)) {  // Options
        ImGui::PushID(cell_index_id++);

        auto color_vec4 = ImGui::GetStyleColorVec4(ImGuiCol_Button);
        if (shader_details->bypass_draw) {
          color_vec4 = {.5, .5, .5, color_vec4.w};
        }
        ImGui::PushStyleColor(ImGuiCol_Button, color_vec4);

        float text_size = std::max({
                              ImGui::CalcTextSize("Draw").x,
                              ImGui::CalcTextSize("More").x,
                          })
                          + (ImGui::GetStyle().FramePadding.x * 2);
        if (ImGui::Button("Draw", {text_size, 0})) {
          shader_details->bypass_draw = !shader_details->bypass_draw;
          skip_draw_count += shader_details->bypass_draw ? +1 : -1;
        }
        ImGui::PopStyleColor();

        ImGui::SameLine();

        if (ImGui::Button("More", {text_size, 0})) {
          ImGui::OpenPopup("###ShaderDetailsPopup");
        }
        if (ImGui::BeginPopup("###ShaderDetailsPopup")) {
          if (ImGui::Selectable("Copy Hash")) {
            ImGui::SetClipboardText(std::format("0x{:08X}", shader_details->shader_hash).c_str());
          }

          if (ImGui::Selectable("Dump Binary")) {
            renodx::utils::shader::dump::DumpShader(
                shader_details->shader_hash,
                shader_details->shader_data,
                shader_details->shader_type,
                "",
                device->get_api());
          }

          if (ImGui::Selectable("Locate Binary")) {
            auto dump_path = renodx::utils::shader::dump::GetShaderDumpPath(
                shader_details->shader_hash,
                shader_details->shader_data,
                shader_details->shader_type,
                "",
                device->get_api());
            renodx::utils::platform::OpenExplorerToFile(dump_path);
          }

          ImGui::BeginDisabled(!shader_details->disk_shader.has_value() || shader_details->disk_shader->file_path.empty());
          if (ImGui::Selectable("Edit Source")) {
            ShellExecute(nullptr, "open", shader_details->disk_shader->file_path.string().c_str(), nullptr, nullptr, SW_SHOW);
          }
          if (ImGui::Selectable("Locate Source")) {
            renodx::utils::platform::OpenExplorerToFile(shader_details->disk_shader->file_path);
          }
          ImGui::EndDisabled();

          ImGui::EndPopup();
        }

        ImGui::PopID();
      }
      drawn_hashes.emplace(shader_details->shader_hash);
    };

    for (auto& draw_details : data->draw_details_list) {
      for (const auto& pipeline_bind : draw_details.pipeline_binds) {
        for (const auto& shader_hash : pipeline_bind.shader_hashes) {
          if (shader_hash == 0u) continue;
          auto* shader_details = data->GetShaderDetails(shader_hash);
          draw_row(shader_details, current_snapshot_index);
        }
      }
      current_snapshot_index++;
    }

    for (auto& [shader_hash, shader_details] : data->shader_details) {
      draw_row(&shader_details);
    }

    ImGui::EndTable();
  }  // ShadersPaneTable
}

enum TexturePaneColumns : uint8_t {
  TEXTURE_PANE_COLUMN_HASH,
  TEXTURE_PANE_COLUMN_TYPE,
  TEXTURE_PANE_COLUMN_ALIAS,
  TEXTURE_PANE_COLUMN_SOURCE,
  TEXTURE_PANE_COLUMN_SNAPSHOT,
  TEXTURE_PANE_COLUMN_OPTIONS,
  //
  TEXTURE_PANE_COLUMN_COUNT
};

void RenderShaderDefinesPane(reshade::api::device* device, DeviceData* data) {
  static ImGuiTreeNodeFlags tree_node_flags = ImGuiTreeNodeFlags_SpanAllColumns | ImGuiTreeNodeFlags_SpanFullWidth;
  if (ImGui::BeginTable(
          "##ShaderDefinesTable",
          3,
          ImGuiTableFlags_BordersInner | ImGuiTableFlags_BordersV | ImGuiTableFlags_BordersOuterH
              | ImGuiTableFlags_Resizable
              | ImGuiTableFlags_NoBordersInBody | ImGuiTableFlags_ScrollY,
          ImVec2(-4, -4))) {
    ImGui::TableSetupColumn("Key", ImGuiTableColumnFlags_NoHide);
    ImGui::TableSetupColumn("Value", ImGuiTableColumnFlags_NoHide);
    ImGui::TableSetupColumn("Options", ImGuiTableColumnFlags_NoHide);
    ImGui::TableSetupScrollFreeze(0, 1);
    ImGui::TableHeadersRow();

    int row_index = 0;
    int cell_index_id = 0x8000;
    static std::vector<size_t> shader_define_remove_indexes;

    for (auto& [key, value] : setting_shader_defines) {
      ImGui::TableNextRow();
      ImGui::TableNextColumn();
      ImGui::PushID(cell_index_id++);
      char temp_key[128] = "";
      key.copy(temp_key, 128);
      ImGui::SetNextItemWidth(-FLT_MIN);
      if (ImGui::InputText("", temp_key, 128, ImGuiInputTextFlags_CharsNoBlank)) {
        key.assign(temp_key);
        setting_shader_defines_changed = true;
      }
      ImGui::PopID();

      ImGui::TableNextColumn();
      ImGui::PushID(cell_index_id++);
      char temp_value[128] = "";
      value.copy(temp_value, 128);
      ImGui::SetNextItemWidth(-FLT_MIN);
      if (ImGui::InputText("", temp_value, 128, ImGuiInputTextFlags_CharsNoBlank)) {
        value.assign(temp_value);
        setting_shader_defines_changed = true;
      }
      ImGui::PopID();

      ImGui::TableNextColumn();
      ImGui::PushID(cell_index_id++);
      if (ImGui::Button("Remove")) {
        setting_shader_defines_changed = true;
        shader_define_remove_indexes.push_back(row_index);
      }
      ImGui::PopID();
      row_index++;
    }
    while (shader_define_remove_indexes.size() != 0) {
      auto remove_index = shader_define_remove_indexes.rbegin()[0];
      setting_shader_defines.erase(setting_shader_defines.begin() + remove_index);
      shader_define_remove_indexes.pop_back();
    }

    ImGui::TableNextRow();
    ImGui::BeginDisabled();
    ImGui::TableNextColumn();
    ImGui::PushID(cell_index_id++);
    ImGui::SetNextItemWidth(-FLT_MIN);
    char temp_key[128] = "";
    ImGui::InputText("", temp_key, 128, ImGuiInputTextFlags_CharsNoBlank);
    ImGui::PopID();

    ImGui::TableNextColumn();
    ImGui::PushID(cell_index_id++);
    char temp_value[128] = "";
    ImGui::SetNextItemWidth(-FLT_MIN);
    ImGui::InputText("", temp_value, 128, ImGuiInputTextFlags_CharsNoBlank);
    ImGui::PopID();
    ImGui::EndDisabled();

    ImGui::TableNextColumn();
    ImGui::PushID(cell_index_id++);
    if (ImGui::Button("Add")) {
      setting_shader_defines.emplace_back();
    }
    ImGui::PopID();

    ImGui::EndTable();
  }  // ShaderDefinesTable
}

template <typename T = bool>
void DrawSettingBoolCheckbox(const char* label, const char* key, T* value) {
  bool temp = *value;
  ImGui::PushID(key);
  if (ImGui::Checkbox(label, &temp)) {
    *value = temp;
    reshade::set_config_value(nullptr, "renodx-dev", key, temp);
  }
  ImGui::PopID();
}

template <typename T = uint32_t>
void DrawSettingUint32Textbox(const char* label, const char* key, T* value) {
  char temp[32] = "";
  uint32_t temp_value = *value;
  std::format("{}", temp_value).copy(temp, 32);

  ImGui::PushID(key);
  if (ImGui::InputText(label, temp, 32, ImGuiInputTextFlags_CharsDecimal)) {
    std::string temp_string = temp;
    auto pos = temp_string.find_last_not_of("\t\n\v\f\r ");
    if (pos != std::string_view::npos) {
      temp_string = {temp_string.data(), temp_string.data() + pos + 1};
    }

    if (temp_string.empty()) {
      temp_value = 0;
    } else {
      std::from_chars(temp_string.data(), temp_string.data() + temp_string.size(), temp_value);
    }
    *value = temp_value;
    reshade::set_config_value(nullptr, "renodx-dev", key, temp_value);
  }
  ImGui::PopID();
}

template <typename T = float>
void DrawSettingDecimalTextbox(const char* label, const char* key, T* value) {
  char temp[32] = "";
  T temp_value = *value;
  std::format("{}", temp_value).copy(temp, 32);

  ImGui::PushID(key);
  if (ImGui::InputText(label, temp, 32, ImGuiInputTextFlags_CharsDecimal)) {
    std::string temp_string = temp;
    auto pos = temp_string.find_last_not_of("\t\n\v\f\r ");
    if (pos != std::string_view::npos) {
      temp_string = {temp_string.data(), temp_string.data() + pos + 1};
    }

    if (temp_string.empty()) {
      temp_value = 0;
    } else {
      std::from_chars(temp_string.data(), temp_string.data() + temp_string.size(), temp_value);
    }
    *value = temp_value;
    reshade::set_config_value(nullptr, "renodx-dev", key, temp_value);
  }
  ImGui::PopID();
}

void RenderSettingsPane(reshade::api::device* device, DeviceData* data) {
  {
    ImGui::SeparatorText("Snapshot");

    DrawSettingBoolCheckbox("Show Vertex Shaders", "SnapshotPaneShowVertexShaders", &snapshot_pane_show_vertex_shaders);
    DrawSettingBoolCheckbox("Show Pixel Shaders", "SnapshotPaneShowPixelShaders", &snapshot_pane_show_pixel_shaders);
    DrawSettingBoolCheckbox("Show Compute Shaders", "SnapshotPaneShowComputeShaders", &snapshot_pane_show_compute_shaders);
    DrawSettingBoolCheckbox("Expand All Nodes", "SnapshotPaneExpandAllNodes", &snapshot_pane_expand_all_nodes);
    DrawSettingBoolCheckbox("Filter Resources by Shader Use", "SnapshotPaneFilterResourcesByShaderUse", &snapshot_pane_filter_resources_by_shader_use);
    DrawSettingBoolCheckbox("Show Blends", "SnapshotPaneShowBlends", &snapshot_pane_show_blends);
    std::shared_lock lock(device_data_list_mutex);
    static std::string current_item;
    auto size = device_data_list.size();
    std::vector<std::string> items(size);
    for (int i = 0; i < size; ++i) {
      auto* device_data = device_data_list[i];
      if (device_data->device == nullptr) {
        assert(device_data->device != nullptr);
        continue;
      }
      std::stringstream s;
      s << PRINT_PTR(reinterpret_cast<uint64_t>(device_data->device));
      s << " (" << device_data->device->get_api() << ")";
      auto name = s.str();
      items[i] = name;
      if (device_data_index == i) {
        current_item.assign(name);
      }
    }

    if (!current_item.empty() && ImGui::BeginCombo("Select Device", current_item.c_str())) {
      for (int n = 0; n < items.size(); n++) {
        bool is_selected = (current_item == items[n]);
        if (ImGui::Selectable(items[n].c_str(), is_selected)) {
          current_item = items[n];
          device_data_index = n;
        }
        if (is_selected) {
          ImGui::SetItemDefaultFocus();
        }
      }
      ImGui::EndCombo();
    }
  }

  {
    ImGui::SeparatorText("Shaders");
    char temp[256] = "";
    renodx::utils::shader::compiler::watcher::GetLivePath().copy(temp, 256);

    if (ImGui::InputText("Live Path", temp, 256)) {
      std::string temp_string = temp;
      auto pos = temp_string.find_last_not_of("\t\n\v\f\r ");
      if (pos != std::string_view::npos) {
        temp_string = {temp_string.data(), temp_string.data() + pos + 1};
      }

      renodx::utils::shader::compiler::watcher::SetLivePath(temp_string);
      reshade::set_config_value(nullptr, "renodx-dev", "LivePath", temp_string.c_str());
    }

    DrawSettingBoolCheckbox("Show Vertex Shaders", "ShadersPaneShowVertexShaders", &shaders_pane_show_vertex_shaders);
    DrawSettingBoolCheckbox("Show Pixel Shaders", "ShadersPaneShowPixelShaders", &shaders_pane_show_pixel_shaders);
    DrawSettingBoolCheckbox("Show Compute Shaders", "ShadersPaneShowComputeShaders", &shaders_pane_show_compute_shaders);
  }

  {
    ImGui::SeparatorText("Trace");
    DrawSettingBoolCheckbox("Trace All", "TraceAll", &renodx::utils::trace::trace_all);
    DrawSettingBoolCheckbox("Trace Pipeline Creation", "TracePipelineCreation", &renodx::utils::trace::trace_pipeline_creation);
    DrawSettingBoolCheckbox("Trace Descriptor Tables", "TraceDescriptorTables", &renodx::utils::descriptor::trace_descriptor_tables);
    DrawSettingBoolCheckbox("Trace Constant Buffers", "TraceConstantBuffers", &renodx::utils::constants::capture_constant_buffers);
    DrawSettingUint32Textbox("Trace Initial Frame Count", "TraceInitialFrameCount", &renodx::utils::trace::trace_initial_frame_count);
  }

  {
    ImGui::SeparatorText("Other");
    DrawSettingDecimalTextbox("FPS Limit", "FPSLimit", &renodx::utils::swapchain::fps_limit);
  }

  ImGui::Text("%s", (std::string("Build: ") + __DATE__ + " " + renodx::utils::date::ISO_DATE_TIME).c_str());
}

void RenderShaderViewDisassembly(reshade::api::device* device, DeviceData* data, ShaderDetails* shader_details) {
  std::string disassembly_string;
  bool ok = ComputeDisassemblyForShaderDetails(device, data, shader_details);

  if (ok) {
    disassembly_string.assign(std::get<std::string>(shader_details->disassembly));
  } else {
    disassembly_string.assign(std::get<std::exception>(shader_details->disassembly).what());
    ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(192, 0, 0, 255));
  }

  ImGui::InputTextMultiline(
      "##disassemblyCode",
      const_cast<char*>(disassembly_string.c_str()),
      disassembly_string.length(),
      ImVec2(-4, -4),
      ImGuiInputTextFlags_ReadOnly);
  if (!ok) {
    ImGui::PopStyleColor();
  }
}

void RenderShaderViewLive(reshade::api::device* device, DeviceData* data, ShaderDetails* shader_details) {
  std::string live_string;
  bool failed = false;
  if (shader_details->disk_shader.has_value()) {
    if (!shader_details->disk_shader->IsCompilationOK()) {
      live_string = shader_details->disk_shader->GetCompilationException().what();
    } else if (shader_details->disk_shader->is_hlsl || shader_details->disk_shader->is_glsl) {
      try {
        live_string = renodx::utils::path::ReadTextFile(shader_details->disk_shader->file_path);
      } catch (std::exception& e) {
        live_string = e.what();
        failed = true;
      }
    }
  }
  if (failed) {
    ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(192, 0, 0, 255));
  }
  ImGui::InputTextMultiline(
      std::format("##shader_view_live_0x{:08x}", shader_details->shader_hash).c_str(),
      const_cast<char*>(live_string.c_str()),
      live_string.length() + 1,
      ImVec2(-4, -4),
      ImGuiInputTextFlags_ReadOnly);
  if (failed) {
    ImGui::PopStyleColor();
  }
}

void RenderShaderViewDecompilation(reshade::api::device* device, DeviceData* data, ShaderDetails* shader_details) {
  std::string decompilation_string;
  bool failed = false;
  if (std::holds_alternative<std::nullopt_t>(shader_details->decompilation)) {
    // Never disassembled
    try {
      if (shader_details->shader_data.empty()) {
        reshade::api::pipeline pipeline = {0};
        {
          // Get pipeline handle
          auto* store = renodx::utils::shader::GetStore();
          store->shader_pipeline_handles.if_contains(
              {device, shader_details->shader_hash},
              [&pipeline](const std::pair<const std::pair<reshade::api::device*, uint32_t>, std::unordered_set<uint64_t>>& pair) {
                if (pair.second.empty()) return;
                auto handle = *pair.second.begin();
                pipeline = {handle};
              });

          if (pipeline.handle == 0u) {
            throw std::exception("Shader data not found.");
          }
        }

        auto shader_data = renodx::utils::shader::GetShaderData(pipeline, shader_details->shader_hash);
        if (!shader_data.has_value()) throw std::exception("Invalid shader selection");
        shader_details->shader_data = shader_data.value();
      }
      if (renodx::utils::device::IsDirectX(device)) {
        auto decompiler = renodx::utils::shader::decompiler::dxc::Decompiler();
        auto disassembly_string = renodx::utils::shader::compiler::directx::DisassembleShader(shader_details->shader_data);
        shader_details->decompilation = decompiler.Decompile(
            disassembly_string,
            {
                .flatten = true,
            });
      } else if (device->get_api() == reshade::api::device_api::opengl) {
        shader_details->disassembly = std::string(
            shader_details->shader_data.data(),
            shader_details->shader_data.data() + shader_details->shader_data.size());
      }
    } catch (std::exception& e) {
      shader_details->decompilation = e;
    }
  }

  if (std::holds_alternative<std::exception>(shader_details->decompilation)) {
    decompilation_string.assign(std::get<std::exception>(shader_details->decompilation).what());
    failed = true;
  } else if (std::holds_alternative<std::string>(shader_details->decompilation)) {
    decompilation_string.assign(std::get<std::string>(shader_details->decompilation));
  }

  if (failed) {
    ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(192, 0, 0, 255));
  }
  ImGui::InputTextMultiline(
      "##decompilationCode",
      const_cast<char*>(decompilation_string.c_str()),
      decompilation_string.length() + 1,
      ImVec2(-4, -4),
      ImGuiInputTextFlags_ReadOnly);
  if (failed) {
    ImGui::PopStyleColor();
  }
}

// Returns false selection is to be removed
void RenderShaderView(reshade::api::device* device, DeviceData* data, SettingSelection& selection) {
  ImGui::PushID(std::format("##shader_view_tab_0x{:08x}", selection.shader_hash).c_str());
  auto style = ImGui::GetStyleColorVec4(ImGuiCol_Text);
  if (!selection.is_pinned) {
    style.w *= 0.5f;
  } else if (selection.is_current) {
  }
  ImGui::PushStyleColor(ImGuiCol_Text, style);
  bool open = ImGui::BeginTabItem(
      std::format("0x{:08x}", selection.shader_hash).c_str(),
      &selection.is_alive,
      selection.GetTabItemFlags());

  ImGui::PopStyleColor();
  ImGui::PopID();

  if (ImGui::IsItemClicked()) {
    MakeSelectionCurrent(selection);
  }
  if (ImGui::IsMouseDoubleClicked(ImGuiMouseButton_Left)) {
    selection.is_pinned = true;
  }

  if (open) {
    if (ImGui::BeginChild(
            std::format("##shader_view_tab_child_0x{:08x}", selection.shader_hash).c_str(),
            ImVec2(0, 0))) {
      auto* shader_details = data->GetShaderDetails(selection.shader_hash);

      switch (selection.shader_view) {
        case 0:
          RenderShaderViewDisassembly(device, data, shader_details);
          break;
        case 1:
          RenderShaderViewLive(device, data, shader_details);
          break;
        case 2:
          RenderShaderViewDecompilation(device, data, shader_details);
        default:
          break;
      }
    }
    ImGui::EndChild();
    ImGui::EndTabItem();
  }
}
void RenderResourceViewHistory(reshade::api::device* device, DeviceData* data, reshade::api::resource resource) {
  auto current_snapshot_index = 0;
  for (auto& draw_details : data->draw_details_list) {
    for (auto& [slot_space, resource_view_details] : draw_details.srv_binds) {
      const auto& slot = slot_space.first;
      const auto& space = slot_space.second;
      if (resource_view_details.resource.handle != resource.handle) continue;
      if (draw_details.resource_binds.has_value()) {
        if (std::ranges::none_of(*draw_details.resource_binds, [&slot, &space](const ResourceBind& bind) {
              return bind.type == ResourceBind::BindType::SRV && bind.slot == slot && bind.space == space;
            })) {
          continue;
        }
      }
      if (space == 0) {
        CreateDrawIndexLink(
            std::format("Snapshot {:03d}", current_snapshot_index),
            current_snapshot_index);
        ImGui::SameLine();
        ImGui::Text(": T%d", slot);
      } else {
        CreateDrawIndexLink(
            std::format("Snapshot {:03d}", current_snapshot_index),
            current_snapshot_index);
        ImGui::SameLine();
        ImGui::Text(": T%d,space%d", slot, space);
      }
    }
    for (const auto& [slot_space, resource_view_details] : draw_details.uav_binds) {
      const auto& slot = slot_space.first;
      const auto& space = slot_space.second;
      if (resource_view_details.resource.handle != resource.handle) continue;
      if (draw_details.resource_binds.has_value()) {
        if (std::ranges::none_of(*draw_details.resource_binds, [&slot, &space](const ResourceBind& bind) {
              return bind.type == ResourceBind::BindType::UAV && bind.slot == slot && bind.space == space;
            })) {
          continue;
        }
      }
      if (space == 0) {
        CreateDrawIndexLink(
            std::format("Snapshot {:03d}", current_snapshot_index),
            current_snapshot_index);
        ImGui::SameLine();
        ImGui::Text(": U%d", slot);
      } else {
        CreateDrawIndexLink(
            std::format("Snapshot {:03d}", current_snapshot_index, slot, space),
            current_snapshot_index);
        ImGui::SameLine();
        ImGui::Text(": U%d,space%d", slot, space);
      }
    }
    for (const auto& [slot, resource_view_details] : draw_details.render_targets) {
      if (resource_view_details.resource.handle != resource.handle) continue;
      CreateDrawIndexLink(
          std::format("Snapshot {:03d}", current_snapshot_index, slot),
          current_snapshot_index);
      ImGui::SameLine();
      ImGui::Text(": RTV%d", slot);
    }
    if (draw_details.copy_source == resource.handle) {
      CreateDrawIndexLink(
          std::format("Snapshot {:03d}", current_snapshot_index),
          current_snapshot_index);
      ImGui::SameLine();
      ImGui::Text(": Copy Source");
    }
    if (draw_details.copy_destination == resource.handle) {
      CreateDrawIndexLink(
          std::format("Snapshot {:03d}", current_snapshot_index),
          current_snapshot_index);
      ImGui::SameLine();
      ImGui::Text(": Copy Destination");
    }

    current_snapshot_index++;
  }
}

void RenderResourceViewPreview(reshade::api::device* device, DeviceData* data, reshade::api::resource resource) {
  auto* info = renodx::utils::resource::GetResourceInfo(resource);
  if (info == nullptr) return;
  if (info->destroyed) return;
  if (info->desc.type == reshade::api::resource_type::buffer) return;

  if (info->clone.handle != 0) {
    RenderResourceViewPreview(device, data, info->clone);
    return;
  }

  reshade::api::format format = reshade::api::format_to_default_typed(info->desc.texture.format);
  switch (info->desc.texture.format) {
    case reshade::api::format::b10g10r10a2_typeless:
      format = reshade::api::format::b10g10r10a2_unorm;
      break;
    case reshade::api::format::r8g8b8a8_typeless:
      format = reshade::api::format::r8g8b8a8_unorm;
      break;
    case reshade::api::format::r16g16b16a16_typeless:
      format = reshade::api::format::r16g16b16a16_float;
      break;
    default:
      break;
  }
  if (format == reshade::api::format::unknown) {
    return;
  }
  bool is_valid = (info->desc.type == reshade::api::resource_type::texture_2d
                   || info->desc.type == reshade::api::resource_type::surface);
  if (!is_valid) return;

  auto srvs = data->preview_srvs[info->resource.handle];

  reshade::api::resource_view srv = {0};
  auto pair = srvs.find(format);
  if (pair == srvs.end()) {
    device->create_resource_view(
        info->resource,
        reshade::api::resource_usage::shader_resource,
        reshade::api::resource_view_desc(format),
        &srv);
    if (srv.handle != 0) {
      srvs[format] = srv;
    } else {
      assert(false);
      return;
    }
  } else {
    if (info->destroyed) {
      device->destroy_resource_view(srv);
      srvs.erase(pair);
      return;
    }
    srv = pair->second;
  }

  auto available_size = ImGui::GetContentRegionAvail();
  auto output_size = ImVec2(
      static_cast<float>(info->desc.texture.width),
      static_cast<float>(info->desc.texture.height));
  auto x_overage = output_size.x - available_size.x;
  auto y_overage = output_size.y - available_size.y;
  auto scale = 1.f;
  if (x_overage > y_overage) {
    if (x_overage > 0) {
      scale = available_size.x / output_size.x;
    }
  } else if (y_overage > 0) {
    scale = available_size.y / output_size.y;
  }

  output_size.x *= scale;
  output_size.y *= scale;

  ImGui::Image(srv.handle, output_size, ImVec2(0, 0), ImVec2(1, 1));
}

// Returns false selection is to be removed
void RenderResourceView(reshade::api::device* device, DeviceData* data, SettingSelection& selection) {
  ImGui::PushID(std::format("##resource_view_view_tab_0x{:08x}", selection.resource_view_handle).c_str());
  auto style = ImGui::GetStyleColorVec4(ImGuiCol_Text);
  if (!selection.is_pinned) {
    style.w *= 0.5f;
  } else if (selection.is_current) {
  }
  ImGui::PushStyleColor(ImGuiCol_Text, style);
  bool open = ImGui::BeginTabItem(
      std::format("0x{:08x}", selection.resource_handle).c_str(),
      &selection.is_alive,
      selection.GetTabItemFlags());

  ImGui::PopStyleColor();
  ImGui::PopID();

  if (ImGui::IsItemClicked()) {
    MakeSelectionCurrent(selection);
  }
  if (ImGui::IsMouseDoubleClicked(ImGuiMouseButton_Left)) {
    selection.is_pinned = true;
  }

  if (open) {
    if (ImGui::BeginChild(
            std::format("##resource_view_tab_child_0x{:08x}", selection.resource_handle).c_str(),
            ImVec2(0, 0))) {
      reshade::api::resource resource = {selection.resource_handle};
      switch (selection.resource_view) {
        case 0:
          RenderResourceViewHistory(device, data, resource);
          break;
        case 1:
          RenderResourceViewPreview(device, data, resource);
        default:
          break;
      }
    }
    ImGui::EndChild();
    ImGui::EndTabItem();
  }
}

void RenderConstantBufferViewPreview(reshade::api::device* device, DeviceData* data, uint64_t constant_buffer_handle) {
  auto details = device->get_resource_desc({constant_buffer_handle});

  if (details.type == reshade::api::resource_type::buffer) {
    auto data = renodx::utils::constants::GetResourceCache(device, {constant_buffer_handle});
    if (data.empty()) {
      data = renodx::utils::constants::GetResourceHistory(device, {constant_buffer_handle});
    }

    auto len = data.size() / sizeof(float);
    std::span<float> float_view = {
        reinterpret_cast<float*>(data.data()),
        reinterpret_cast<float*>(data.data()) + len};
    std::span<uint32_t> uint32_view = {
        reinterpret_cast<uint32_t*>(data.data()),
        reinterpret_cast<uint32_t*>(data.data()) + len};
    std::span<int32_t> int32_view = {
        reinterpret_cast<int32_t*>(data.data()),
        reinterpret_cast<int32_t*>(data.data()) + len};

    if (ImGui::BeginTable(
            std::format("##constant_buffer_view_tab_child_table_0x{:08x}", constant_buffer_handle).c_str(),
            5,
            ImGuiTableFlags_BordersInner | ImGuiTableFlags_BordersV | ImGuiTableFlags_BordersOuterH
                | ImGuiTableFlags_Resizable
                | ImGuiTableFlags_NoBordersInBody | ImGuiTableFlags_ScrollY,
            ImVec2(-4, -4))) {
      ImGui::TableSetupColumn("Position", ImGuiTableColumnFlags_NoHide);
      ImGui::TableSetupColumn("float", ImGuiTableColumnFlags_NoHide);
      ImGui::TableSetupColumn("uint32", ImGuiTableColumnFlags_NoHide);
      ImGui::TableSetupColumn("int32", ImGuiTableColumnFlags_NoHide);
      ImGui::TableSetupColumn("Offset", ImGuiTableColumnFlags_NoHide);
      ImGui::TableSetupScrollFreeze(0, 1);
      ImGui::TableHeadersRow();

      int row_index = 0;
      int cell_index_id = 0x6000;

      for (auto i = 0; i < len; ++i) {
        ImGui::TableNextRow();

        if (ImGui::TableNextColumn()) {
          ImGui::PushID(cell_index_id++);
          ImGui::TextUnformatted(std::format("[{}].{}", i / 4u, "xyzw"[i % 4]).c_str());
          ImGui::PopID();
        }

        if (ImGui::TableNextColumn()) {
          ImGui::TextUnformatted(std::format("{}", float_view[i]).c_str());
          ImGui::PushID(cell_index_id++);
          ImGui::PopID();
        }

        if (ImGui::TableNextColumn()) {
          ImGui::TextUnformatted(std::format("{}", uint32_view[i]).c_str());
          ImGui::PushID(cell_index_id++);
          ImGui::PopID();
        }

        if (ImGui::TableNextColumn()) {
          ImGui::PushID(cell_index_id++);
          ImGui::TextUnformatted(std::format("{}", int32_view[i]).c_str());
          ImGui::PopID();
        }

        if (ImGui::TableNextColumn()) {
          ImGui::PushID(cell_index_id++);
          ImGui::TextUnformatted(std::format("{}", i).c_str());
          ImGui::PopID();
        }

        row_index++;
      }

      ImGui::EndTable();
    }
  }
}

void RenderConstantBufferViewHistory(reshade::api::device* device, DeviceData* data, uint64_t constant_buffer_handle) {
  auto current_snapshot_index = 0;
  for (auto& draw_details : data->draw_details_list) {
    for (const auto& [slot_space, buffer_range] : draw_details.constants) {
      const auto& slot = slot_space.first;
      const auto& space = slot_space.second;
      if (buffer_range.buffer.handle != constant_buffer_handle) continue;
      if (draw_details.resource_binds.has_value()) {
        if (std::ranges::none_of(*draw_details.resource_binds, [&slot, &space](const ResourceBind& bind) {
              return bind.type == ResourceBind::BindType::CBV && bind.slot == slot && bind.space == space;
            })) {
          continue;
        }
      }
      if (space == 0) {
        ImGui::Text("Snapshot %03d: C%d", current_snapshot_index, slot);
      } else {
        ImGui::Text("Snapshot %03d: C%d,space%d", current_snapshot_index, slot, space);
      }
    }
    if (draw_details.copy_source == constant_buffer_handle) {
      ImGui::Text("Snapshot %03d: Copy Source", current_snapshot_index);
    }
    if (draw_details.copy_destination == constant_buffer_handle) {
      ImGui::Text("Snapshot %03d: Copy Destination", current_snapshot_index);
    }
    current_snapshot_index++;
  }
}

void RenderConstantBufferView(reshade::api::device* device, DeviceData* data, SettingSelection& selection) {
  ImGui::PushID(std::format("##constant_buffer_view_tab_0x{:08x}", selection.constant_buffer_handle).c_str());
  auto style = ImGui::GetStyleColorVec4(ImGuiCol_Text);
  if (!selection.is_pinned) {
    style.w *= 0.5f;
  } else if (selection.is_current) {
  }
  ImGui::PushStyleColor(ImGuiCol_Text, style);
  bool open = ImGui::BeginTabItem(
      std::format("0x{:08x}", selection.constant_buffer_handle).c_str(),
      &selection.is_alive,
      selection.GetTabItemFlags());

  ImGui::PopStyleColor();
  ImGui::PopID();

  if (ImGui::IsItemClicked()) {
    MakeSelectionCurrent(selection);
  }
  if (ImGui::IsMouseDoubleClicked(ImGuiMouseButton_Left)) {
    selection.is_pinned = true;
  }

  if (open) {
    if (ImGui::BeginChild(
            std::format("##constant_buffer_view_tab_child_0x{:08x}", selection.constant_buffer_handle).c_str(),
            ImVec2(0, 0))) {
      switch (selection.constant_view) {
        case 0:
          RenderConstantBufferViewHistory(device, data, selection.constant_buffer_handle);
          break;
        case 1:
          RenderConstantBufferViewPreview(device, data, selection.constant_buffer_handle);
        default:
          break;
      }
    }
    ImGui::EndChild();
    ImGui::EndTabItem();
  }
}

void InitializeUserSettings() {
  {
    char temp[256] = "";
    size_t size = 256;
    if (reshade::get_config_value(nullptr, "renodx-dev", "LivePath", temp, &size)) {
      std::string temp_string = std::string(temp);
      auto pos = temp_string.find_last_not_of("\t\n\v\f\r ");
      if (pos != std::string_view::npos) {
        temp_string = {temp_string.data(), temp_string.data() + pos + 1};
      }
      renodx::utils::shader::compiler::watcher::SetLivePath(temp_string);
    }
  }

  for (const auto& [key, value] : std::vector<std::pair<const char*, std::atomic_bool*>>({
           {"TraceAll", &renodx::utils::trace::trace_all},
           {"TracePipelineCreation", &renodx::utils::trace::trace_pipeline_creation},
           {"TraceDescriptorTables", &renodx::utils::descriptor::trace_descriptor_tables},
           {"TraceConstantBuffers", &renodx::utils::constants::capture_constant_buffers},
           {"SnapshotPaneShowVertexShaders", &snapshot_pane_show_vertex_shaders},
           {"SnapshotPaneShowPixelShaders", &snapshot_pane_show_pixel_shaders},
           {"SnapshotPaneShowComputeShaders", &snapshot_pane_show_compute_shaders},
           {"SnapshotPaneShowBlends", &snapshot_pane_show_blends},
           {"SnapshotPaneExpandAllNodes", &snapshot_pane_expand_all_nodes},
           {"SnapshotPaneFilterResourcesByShaderUse", &snapshot_pane_filter_resources_by_shader_use},
           {"ShadersPaneShowVertexShaders", &shaders_pane_show_vertex_shaders},
           {"ShadersPaneShowPixelShaders", &shaders_pane_show_pixel_shaders},
           {"ShadersPaneShowComputeShaders", &shaders_pane_show_compute_shaders},
       })) {
    bool temp = *value;
    if (reshade::get_config_value(nullptr, "renodx-dev", key, temp)) {
      *value = temp;
    }
  }
  for (const auto& [key, value] : std::vector<std::pair<const char*, std::atomic_uint32_t*>>({
           {"TraceInitialFrameCount", &renodx::utils::trace::trace_initial_frame_count},
       })) {
    uint32_t temp = *value;
    if (reshade::get_config_value(nullptr, "renodx-dev", key, temp)) {
      *value = temp;
    }
  }
}

// @see https://pthom.github.io/imgui_manual_online/manual/imgui_manual.html
void OnRegisterOverlay(reshade::api::effect_runtime* runtime) {
  DeviceData* data = nullptr;
  {
    std::shared_lock lock(device_data_list_mutex);
    uint32_t index = device_data_index;
    auto size = device_data_list.size();

    for (auto i = 0; i < size; ++i) {
      data = device_data_list.at(i);
      if (data->device == nullptr) {
        assert(data->device != nullptr);
        continue;
      }
      if (i == index) break;
    }
  }

  // auto* data = renodx::utils::data::Get<DeviceData>(device);

  // Runtime may be on a separate device
  if (data == nullptr) return;

  auto* device = data->device;

  std::unique_lock lock(data->mutex);  // Probably not needed
  if (data->runtime == nullptr) {
    data->runtime = runtime;
  }

  static auto setting_side_sheet_width = 96.f;

  const auto x_height = ImGui::CalcTextSize("x").y;

  ImGui::SetNextWindowSizeConstraints({SETTING_NAV_RAIL_SIZE + 128 + 128 + 96, (2 * x_height) + (SETTING_NAV_RAIL_SIZE * 4.f)}, {FLT_MAX, FLT_MAX});

  if (ImGui::BeginChild("DevKit", ImVec2(0, 0), ImGuiChildFlags_None, ImGuiWindowFlags_MenuBar)) {
    RenderMenuBar(device, data);

    RenderNavRail(device, data);

    ImGui::SameLine();

    auto size_remaining = ImGui::GetContentRegionAvail().x;

    ImGui::SetNextWindowSizeConstraints({128.f, 0}, {size_remaining - 8 - 128 - setting_side_sheet_width, FLT_MAX});
    if (ImGui::BeginChild("##LayoutList", ImVec2(0, 0), ImGuiChildFlags_ResizeX)) {
      switch (setting_nav_item) {
        case 0:
          RenderCapturePane(device, data);
          break;
        case 1:
          RenderShadersPane(device, data);
          break;
        case 2:
          RenderShaderDefinesPane(device, data);
          break;
        case 3:
          RenderSettingsPane(device, data);
          break;
        default:
          break;
      }
    }
    ImGui::EndChild();

    ImGui::SameLine();

    size_remaining = ImGui::GetContentRegionAvail().x;
    ImGui::SetNextWindowSizeConstraints({size_remaining - 4 - setting_side_sheet_width, 0}, {size_remaining - 96, FLT_MAX});
    if (ImGui::BeginChild("##Details", {0, 0}, ImGuiChildFlags_ResizeX)) {
      if (!setting_open_tabs.empty()) {
        if (ImGui::BeginTabBar("##SelectedTabs", ImGuiTabBarFlags_Reorderable | ImGuiTabBarFlags_FittingPolicyScroll)) {
          for (auto& selection : setting_open_tabs) {
            if (selection.shader_hash != 0u) {
              RenderShaderView(device, data, selection);
            } else if (selection.resource_handle != 0u) {
              RenderResourceView(device, data, selection);
            } else if (selection.constant_buffer_handle != 0u) {
              RenderConstantBufferView(device, data, selection);
            }
          }
          RemoveDeadSelections();
          ImGui::EndTabBar();
        }
      }
    }
    ImGui::EndChild();
    ImGui::SameLine();

    size_remaining = ImGui::GetContentRegionAvail().x;
    ImGui::SetNextWindowSizeConstraints({96, 0}, {FLT_MAX, FLT_MAX});
    if (ImGui::BeginChild("##SideSheet", {0, 0}, ImGuiChildFlags_AutoResizeX)) {
      auto selection = GetCurrentSelection();
      if (selection.has_value()) {
        if (selection->get().shader_hash != 0u) {
          ImGui::RadioButton("Disassembly", &selection->get().shader_view, 0);
          ImGui::RadioButton("Live Shader", &selection->get().shader_view, 1);
          ImGui::RadioButton("Decompilation", &selection->get().shader_view, 2);
        } else if (selection->get().resource_handle != 0u) {
          ImGui::RadioButton("History", &selection->get().resource_view, 0);
          ImGui::RadioButton("Preview", &selection->get().resource_view, 1);
        } else if (selection->get().constant_buffer_handle != 0u) {
          ImGui::RadioButton("History", &selection->get().constant_view, 0);
          ImGui::RadioButton("Preview", &selection->get().constant_view, 1);
        }
      }
      setting_side_sheet_width = ImGui::CalcItemWidth();
    }
    ImGui::EndChild();
  }
  ImGui::EndChild();
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  if (setting_shader_defines_changed) {
    renodx::utils::shader::compiler::watcher::SetShaderDefines(setting_shader_defines);
    renodx::utils::shader::compiler::watcher::RequestCompile();
    setting_shader_defines_changed = false;
  }

  auto* device = swapchain->get_device();
  DeviceData* data = nullptr;
  if (setting_live_reload) {
    if (!renodx::utils::shader::compiler::watcher::IsEnabled()) {
      renodx::utils::shader::compiler::watcher::Start();
    }
    data = renodx::utils::data::Get<DeviceData>(device);
    if (data == nullptr) return;
    std::unique_lock lock(data->mutex);
    LoadDiskShaders(device, data, true);
  } else {
    if (renodx::utils::shader::compiler::watcher::IsEnabled()) {
      renodx::utils::shader::compiler::watcher::Stop();
    }
  }

  if (setting_auto_dump) {
    renodx::utils::shader::dump::DumpAllPending();
  }

  if (snapshot_device == nullptr) {
    if (snapshot_queued_device == device) {
      if (data == nullptr) {
        data = renodx::utils::data::Get<DeviceData>(device);
      }
      data->draw_details_list.clear();
      snapshot_device = device;
      snapshot_queued_device = nullptr;
    }
  } else if (device == snapshot_device) {
    snapshot_device = nullptr;
    if (data == nullptr) {
      data = renodx::utils::data::Get<DeviceData>(device);
    }
    std::unique_lock lock(data->mutex);
    std::ranges::sort(data->draw_details_list, [](const DrawDetails& a, const DrawDetails& b) {
      return a.timestamp < b.timestamp;
    });

    data->shader_draw_indexes.clear();
    for (auto i = 0; i < data->draw_details_list.size(); ++i) {
      const auto& draw_details = data->draw_details_list[i];
      for (const auto& pipeline_bind : draw_details.pipeline_binds) {
        for (const auto& shader_hash : pipeline_bind.shader_hashes) {
          data->shader_draw_indexes[shader_hash].insert(i);
        }
      }
    }
  }
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX DevKit";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX DevKit Module";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      // while (IsDebuggerPresent() == 0) Sleep(100);

      if (!initialized) {
        renodx::utils::shader::use_replace_async = true;
        InitializeUserSettings();
        initialized = true;
      }

      renodx::utils::trace::Use(fdw_reason);
      renodx::utils::constants::Use(fdw_reason);
      renodx::utils::descriptor::Use(fdw_reason);
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::shader::dump::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);

      renodx::utils::shader::use_shader_cache = true;

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::register_event<reshade::addon_event::init_pipeline>(OnInitPipelineTrackAddons);
      reshade::register_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);
      reshade::register_event<reshade::addon_event::copy_resource>(OnCopyResource);
      reshade::register_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);

      reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      reshade::register_event<reshade::addon_event::dispatch>(OnDispatch);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      reshade::register_overlay("RenoDX DevKit", OnRegisterOverlay);

      break;
    case DLL_PROCESS_DETACH:

      renodx::utils::trace::Use(fdw_reason);
      renodx::utils::constants::Use(fdw_reason);
      renodx::utils::descriptor::Use(fdw_reason);
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::shader::dump::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::init_pipeline>(OnInitPipelineTrackAddons);
      reshade::unregister_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::unregister_event<reshade::addon_event::copy_resource>(OnCopyResource);
      reshade::unregister_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
      reshade::unregister_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      reshade::unregister_event<reshade::addon_event::dispatch>(OnDispatch);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);

      reshade::unregister_overlay("RenoDX DevKit", OnRegisterOverlay);

      reshade::unregister_addon(h_module);

      break;
  }

  renodx::utils::resource::Use(fdw_reason);

  // ResourceWatcher::Use(fdwReason);

  return TRUE;
}
