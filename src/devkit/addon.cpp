/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <algorithm>
#include <atomic>
#include <cstdlib>
#include <exception>
#include <filesystem>
#include <initializer_list>
#include <memory>
#include <mutex>
#include <optional>
#include <variant>

#define ImTextureID ImU64

#pragma comment(lib, "dxguid.lib")

#define NOMINMAX

#include <d3d11.h>
#include <d3d12.h>
#include <Windows.h>

#include <cstdio>
#include <shared_mutex>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <crc32_hash.hpp>
#include "../mods/swapchain.hpp"
#include "../utils/bitwise.hpp"
#include "../utils/constants.hpp"
#include "../utils/descriptor.hpp"
#include "../utils/pipeline_layout.hpp"
#include "../utils/shader.hpp"
#include "../utils/shader_compiler_directx.hpp"
#include "../utils/shader_compiler_watcher.hpp"
#include "../utils/shader_decompiler_dxc.hpp"
#include "../utils/shader_dump.hpp"
#include "../utils/swapchain.hpp"
#include "../utils/trace.hpp"

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

std::atomic_bool is_snapshotting = false;

std::atomic_bool snapshot_pane_show_vertex_shaders = true;
std::atomic_bool snapshot_pane_show_pixel_shaders = true;
std::atomic_bool snapshot_pane_show_compute_shaders = true;
std::atomic_bool snapshot_pane_show_blends = true;

std::atomic_bool shaders_pane_show_vertex_shaders = true;
std::atomic_bool shaders_pane_show_pixel_shaders = true;
std::atomic_bool shaders_pane_show_compute_shaders = true;

struct ShaderDetails {
  uint32_t shader_hash;
  std::vector<uint8_t> shader_data;
  std::variant<std::nullopt_t, std::exception, std::string> disassembly = std::nullopt;
  std::variant<std::nullopt_t, std::exception, std::string> decompilation = std::nullopt;
  std::optional<renodx::utils::shader::compiler::directx::DxilProgramVersion> program_version = std::nullopt;
  std::vector<uint8_t> addon_shader;
  std::optional<renodx::utils::shader::compiler::watcher::CustomShader> disk_shader = std::nullopt;
  reshade::api::pipeline_stage shader_type = static_cast<reshade::api::pipeline_stage>(0);
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
    auto* swapchain_mod_data = &device->get_private_data<renodx::mods::swapchain::DeviceData>();
    if (swapchain_mod_data == nullptr) return false;

    if (auto pair = swapchain_mod_data->upgraded_resource_views.find(resource_view.handle);
        pair != swapchain_mod_data->upgraded_resource_views.end() && pair->second.handle != 0u) {
      this->is_rtv_upgraded = true;
    } else {
      this->is_rtv_upgraded = false;
    }

    if (auto pair = swapchain_mod_data->resource_clones.find(resource_view.handle);
        pair != swapchain_mod_data->resource_clones.end() && pair->second.handle != 0u) {
      this->is_rtv_cloned = true;
    } else {
      this->is_rtv_cloned = false;
    }

    if (this->resource.handle == 0u) {
      this->is_res_upgraded = false;
      this->is_res_cloned = false;
    } else {
      if (auto pair = swapchain_mod_data->upgraded_resources.find(this->resource.handle);
          pair != swapchain_mod_data->upgraded_resources.end() && pair->second.handle != 0u) {
        this->is_res_upgraded = true;
      } else {
        this->is_res_upgraded = false;
      }

      if (auto pair = swapchain_mod_data->resource_clones.find(this->resource.handle);
          pair != swapchain_mod_data->resource_clones.end() && pair->second.handle != 0u) {
        this->is_res_cloned = true;
      } else {
        this->is_res_cloned = false;
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
  std::map<std::pair<uint32_t, uint32_t>, ResourceViewDetails> srv_binds;
  std::map<std::pair<uint32_t, uint32_t>, ResourceViewDetails> uav_binds;
  std::map<std::pair<uint32_t, uint32_t>, reshade::api::buffer_range> constants;
  std::vector<PipelineBindDetails> pipeline_binds;
  enum class DrawMethods : std::uint8_t {
    PRESENT,
    DRAW,
    DRAW_INDEXED,
    DRAW_INDEXED_OR_INDIRECT,
    DISPATCH
  } draw_method;
  std::map<uint32_t, ResourceViewDetails> render_targets;

  [[nodiscard]] std::string DrawMethodString() const {
    switch (draw_method) {
      case DrawMethods::PRESENT:                  return "Present";
      case DrawMethods::DRAW:                     return "Draw";
      case DrawMethods::DRAW_INDEXED:             return "DrawIndexed";
      case DrawMethods::DRAW_INDEXED_OR_INDIRECT: return "DrawIndirect";
      case DrawMethods::DISPATCH:                 return "Dispatch";
      default:                                    return "Unknown";
    }
  }
};

struct __declspec(uuid("3224946b-5c5f-478a-8691-83fbb9f88f1b")) CommandListData {
  std::vector<DrawDetails> draw_details;

  DrawDetails& GetCurrentDrawDetails() {
    if (draw_details.empty()) {
      draw_details.push_back({});
    }
    auto& item = draw_details[draw_details.size() - 1];
    return item;
  }
};

struct __declspec(uuid("0190ec1a-2e19-74a6-ad41-4df0d4d8caed")) DeviceData {
  std::unordered_map<uint32_t, ShaderDetails> shader_details;
  std::vector<CommandListData> command_list_data;
  std::unordered_map<uint64_t, std::vector<reshade::api::pipeline_layout_param>> pipeline_layout_params;
  std::unordered_set<uint64_t> live_pipelines;
  std::shared_mutex mutex;

  reshade::api::effect_runtime* runtime = nullptr;

  void StartSnapshot() {
    this->command_list_data.clear();
    is_snapshotting = true;
  }

  static void StopSnapshot() {
    is_snapshotting = false;
  }

  ShaderDetails& GetShaderDetails(uint32_t shader_hash) {
    // assert(shader_hash != 0u);
    if (auto pair = shader_details.find(shader_hash);
        pair != shader_details.end()) {
      return pair->second;
    }

    auto [iterator, is_new] = shader_details.emplace(shader_hash, shader_hash);
    return iterator->second;
  }

  ResourceViewDetails GetResourceViewDetails(reshade::api::resource_view resource_view, reshade::api::device* device) const {
    ResourceViewDetails details = {
        .resource_view = resource_view,
        .resource_view_desc = device->get_resource_view_desc(resource_view),
        // .resource = device->get_resource_from_view(resource_view),
    };

    auto device_api = device->get_api();

    auto resource_view_reflection = renodx::utils::trace::GetDebugName(device_api, resource_view);
    if (resource_view_reflection.has_value()) {
      details.resource_view_reflection = resource_view_reflection.value();
    }

    auto resource = renodx::utils::resource::GetResourceFromView(device, resource_view);
    details.resource = resource;
    if (resource.handle != 0u) {
      details.resource_desc = device->get_resource_desc(details.resource);

      auto resource_reflection = renodx::utils::trace::GetDebugName(device_api, details.resource);
      if (resource_reflection.has_value()) {
        details.resource_reflection = resource_reflection.value();
      }
    }

    details.is_swapchain = renodx::utils::swapchain::IsBackBuffer(device, details.resource);

    details.UpdateSwapchainModState(device);

    return details;
  }
};

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

struct SettingSelection {
  uint32_t shader_hash = 0;
  uint64_t resource_handle = 0;
  uint64_t resource_view_handle = 0;
  uint64_t constant_buffer_handle = 0;
  int shader_view = 0;

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

void OnInitDevice(reshade::api::device* device) {
  auto& data = device->create_private_data<DeviceData>();
}

void OnDestroyDevice(reshade::api::device* device) {
  device->destroy_private_data<DeviceData>();
}

void OnInitCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->create_private_data<CommandListData>();
}

void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<CommandListData>();
}

void OnInitPipelineLayout(
    reshade::api::device* device,
    const uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  std::vector<reshade::api::pipeline_layout_param> cloned_params = {
      params, params + param_count};

  data.pipeline_layout_params[layout.handle] = cloned_params;
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

  auto& data = device->get_private_data<DeviceData>();
  auto& shader_device_data = renodx::utils::shader::GetShaderDeviceData(device);
  std::shared_lock shader_data_lock(shader_device_data.mutex);
  for (const auto& [shader_hash, addon_data] : shader_device_data.runtime_replacements) {
    auto& shader_details = data.GetShaderDetails(shader_hash);
    shader_details.addon_shader = addon_data;
    shader_details.shader_source = ShaderDetails::ShaderSource::ADDON_SHADER;
  }
}

void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  if (pipeline.handle == 0u) return;

  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.live_pipelines.emplace(pipeline.handle);
}

void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  if (pipeline.handle == 0u) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.live_pipelines.erase(pipeline.handle);
}

void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stage,
    reshade::api::pipeline pipeline) {
  if (!is_snapshotting) return;

  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();
  auto& details = cmd_list_data.GetCurrentDrawDetails();

  PipelineBindDetails bind_details = {
      .pipeline = pipeline,
      .pipeline_stage = stage,
  };

  std::vector<uint32_t> added_shaders;
  auto shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  for (auto compatible_stage : renodx::utils::shader::COMPATIBLE_STAGES) {
    if (renodx::utils::bitwise::HasFlag(stage, compatible_stage)) {
      if (pipeline.handle == 0u) {
        bind_details.shader_hashes.push_back(0);
      } else {
        auto shader_hash = shader_state.GetCurrentShaderHash(compatible_stage);
        bind_details.shader_hashes.push_back(shader_hash);
        added_shaders.push_back(shader_hash);
      }
    }
  }
  details.pipeline_binds.push_back(bind_details);

  if (added_shaders.empty()) return;

  auto* device = cmd_list->get_device();

  auto& device_data = device->get_private_data<DeviceData>();
  std::unique_lock lock(device_data.mutex);

  for (const auto shader_hash : added_shaders) {
    if (shader_hash == 0u) continue;
    auto& shader_details = device_data.GetShaderDetails(shader_hash);
    if (static_cast<uint32_t>(shader_details.shader_type) != 0u) continue;
    if (!shader_details.program_version.has_value()) {
      if (shader_details.shader_data.empty()) {
        try {
          auto pipeline_details = renodx::utils::shader::GetPipelineShaderDetails(device, pipeline);
          if (!pipeline_details.has_value()) return;

          auto shader_data = renodx::utils::shader::GetShaderData(device, pipeline, shader_hash);
          if (!shader_data.has_value()) {
            throw std::exception("Failed to get shader data");
          }
          shader_details.shader_data = shader_data.value();
        } catch (const std::exception& e) {
          reshade::log::message(reshade::log::level::error, e.what());
        }
      }
      if (renodx::utils::device::IsDirectX(device)) {
        try {
          shader_details.program_version = renodx::utils::shader::compiler::directx::DecodeShaderVersion(shader_details.shader_data);
        } catch (const std::exception& e) {
          reshade::log::message(reshade::log::level::error, e.what());
        }
      }
    }

    if (shader_details.program_version.has_value()) {
      switch (shader_details.program_version->GetKind()) {
        case D3D11_SHVER_VERTEX_SHADER:
          shader_details.shader_type = reshade::api::pipeline_stage::vertex_shader;
          break;
        case D3D11_SHVER_PIXEL_SHADER:
          shader_details.shader_type = reshade::api::pipeline_stage::pixel_shader;
          break;
        case D3D11_SHVER_COMPUTE_SHADER:
          shader_details.shader_type = reshade::api::pipeline_stage::compute_shader;
          break;
        default:
          break;
      }
    } else {
      switch (stage) {
        case reshade::api::pipeline_stage::vertex_shader:
        case reshade::api::pipeline_stage::pixel_shader:
        case reshade::api::pipeline_stage::compute_shader:
          shader_details.shader_type = stage;
        default:
          break;
      }
    }
  }
}

void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (!is_snapshotting) return;
  auto& data = cmd_list->get_private_data<CommandListData>();
  auto& details = data.GetCurrentDrawDetails();
  auto* device = cmd_list->get_device();
  auto& device_data = device->get_private_data<DeviceData>();
  std::unique_lock lock(device_data.mutex);

  auto log_resource_view = [&](uint32_t index,
                               reshade::api::resource_view view,
                               std::map<std::pair<uint32_t, uint32_t>,
                                        ResourceViewDetails>& destination) {
    auto pair = device_data.pipeline_layout_params.find(layout.handle);
    if (pair == device_data.pipeline_layout_params.end()) {
      reshade::log::message(reshade::log::level::error, "Could not find handle.");
      // add warning
      return;
    }
    auto layout_params = pair->second;
    auto param = layout_params[layout_param];
    uint32_t dx_register_index;
    uint32_t dx_register_space;
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
      auto detail_item = (device_data.GetResourceViewDetails(view, device));
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
        log_resource_view(i, item.view, details.srv_binds);
      } break;
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::shader_resource_view:        {
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        log_resource_view(i, item, details.srv_binds);
        break;
      }
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::unordered_access_view:        {
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        log_resource_view(i, item, details.uav_binds);
        break;
      }
      case reshade::api::descriptor_type::constant_buffer: {
        auto pair = device_data.pipeline_layout_params.find(layout.handle);
        if (pair == device_data.pipeline_layout_params.end()) {
          reshade::log::message(reshade::log::level::error, "Could not find handle.");
          // add warning
          return;
        }
        auto layout_params = pair->second;
        auto param = layout_params[layout_param];
        assert(param.type == reshade::api::pipeline_layout_param_type::push_descriptors);
        assert(param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer);

        uint32_t dx_register_index = param.push_constants.dx_register_index;
        uint32_t dx_register_space = param.push_constants.dx_register_space;
        auto buffer_range = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];

        auto slot = std::pair<uint32_t, uint32_t>(dx_register_index + update.binding + i, dx_register_space);

        details.constants[slot] = buffer_range;

      } break;
      default:
        break;
    }
  }
}

bool OnDraw(reshade::api::command_list* cmd_list, DrawDetails::DrawMethods draw_method) {
  bool bypass_draw = false;

  auto* device = cmd_list->get_device();
  auto& device_data = device->get_private_data<DeviceData>();

  auto& state = renodx::utils::shader::GetCurrentState(cmd_list);

  {
    std::shared_lock lock(device_data.mutex);
    for (auto& [stage, state] : state.stage_state) {
      if (auto pair = device_data.shader_details.find(state.shader_hash);
          pair != device_data.shader_details.end()) {
        auto details = pair->second;
        if (details.bypass_draw) {
          bypass_draw = true;
          break;
        }
      }
    }
  }

  if (is_snapshotting) {
    auto& command_list_data = cmd_list->get_private_data<CommandListData>();
    auto& draw_details = command_list_data.GetCurrentDrawDetails();
    draw_details.draw_method = draw_method;

    std::unique_lock lock(device_data.mutex);

    if (state.pipeline_layout.handle != 0u) {
      auto& layout_data = device->get_private_data<renodx::utils::pipeline_layout::DeviceData>();
      const std::shared_lock layout_lock(layout_data.mutex);
      // Check bound descriptor tables
      auto layout_data_pair = layout_data.pipeline_layout_data.find(state.pipeline_layout.handle);
      assert(layout_data_pair != layout_data.pipeline_layout_data.end());
      //  continue;

      const auto& info = layout_data_pair->second;
      auto param_count = info.params.size();
      auto& descriptor_data = device->get_private_data<renodx::utils::descriptor::DeviceData>();
      for (auto param_index = 0; param_index < param_count; ++param_index) {
        const auto& param = info.params.at(param_index);

        const auto& table = info.tables[param_index];

        if (table.handle == 0u) continue;

        uint32_t descriptor_table_count;
        const reshade::api::descriptor_range* descriptor_table_ranges;
        switch (param.type) {
          case reshade::api::pipeline_layout_param_type::descriptor_table:
            descriptor_table_count = param.descriptor_table.count;
            descriptor_table_ranges = param.descriptor_table.ranges;
            break;
          case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
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
          const std::shared_lock descriptor_lock(descriptor_data.mutex);

          for (uint32_t k = 0; k < range.count; ++k) {
            auto heap_pair = descriptor_data.heaps.find(heap.handle);
            if (heap_pair == descriptor_data.heaps.end()) {
              // Unknown heap?
              continue;
            }
            const auto& heap_data = heap_pair->second;
            auto offset = base_offset + k;
            if (offset >= heap_data.size()) {
              // Invalid location (may be oversized bind)
              continue;
            }
            auto known_pair = descriptor_data.resource_view_heap_locations.find(heap.handle);
            if (known_pair == descriptor_data.resource_view_heap_locations.end()) continue;
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
                auto detail_item = (device_data.GetResourceViewDetails(resource_view, device));
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
                auto detail_item = (device_data.GetResourceViewDetails(resource_view, device));
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

    draw_details.render_targets.clear();

    if (draw_method != DrawDetails::DrawMethods::DISPATCH) {
      uint32_t rtv_index = 0u;
      for (auto render_target : renodx::utils::swapchain::GetRenderTargets(cmd_list)) {
        if (render_target.handle != 0u) {
          draw_details.render_targets[rtv_index] = device_data.GetResourceViewDetails(render_target, device);
        }
        ++rtv_index;
      }
    }

    device_data.command_list_data.push_back(command_list_data);
    command_list_data.draw_details.clear();
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
  return OnDraw(cmd_list, DrawDetails::DrawMethods::DRAW_INDEXED_OR_INDIRECT);
}

void DeactivateShader(reshade::api::device* device, uint32_t shader_hash) {
  renodx::utils::shader::RemoveRuntimeReplacements(device, {shader_hash});
}

void ActivateShader(reshade::api::device* device, uint32_t shader_hash, std::vector<uint8_t>& shader_data) {
  renodx::utils::shader::AddRuntimeReplacement(device, shader_hash, shader_data);
}

void LoadDiskShaders(reshade::api::device* device, DeviceData& data, bool activate = true) {
  if (setting_live_reload) {
    if (!renodx::utils::shader::compiler::watcher::HasChanged()) return;
  } else {
    renodx::utils::shader::compiler::watcher::CompileSync();
  }
  auto new_shaders = renodx::utils::shader::compiler::watcher::FlushCompiledShaders();
  for (auto& [shader_hash, custom_shader] : new_shaders) {
    reshade::log::message(reshade::log::level::debug, "new shaders");
    auto& details = data.GetShaderDetails(shader_hash);
    details.disk_shader = custom_shader;

    if (activate) {
      details.shader_source = ShaderDetails::ShaderSource::DISK_SHADER;
      DeactivateShader(device, shader_hash);

      if (!custom_shader.removed && custom_shader.IsCompilationOK()) {
        auto shader_data = custom_shader.GetCompilationData();
        ActivateShader(device, shader_hash, shader_data);
      }
    }
  }
}

void RenderFileAlias(std::optional<renodx::utils::shader::compiler::watcher::CustomShader>& disk_shader) {
  if (disk_shader.has_value()) {
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
  } else {
    ImGui::TextUnformatted("");
  }
}

void RenderMenuBar(reshade::api::device* device, DeviceData& data) {
  if (ImGui::BeginMenuBar()) {
    ImGui::PushID("##SnapshotButton");
    if (ImGui::MenuItem("Snapshot")) {
      data.StartSnapshot();
      renodx::utils::trace::trace_running = true;
    }
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

void RenderNavRail(reshade::api::device* device, DeviceData& data) {
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

enum CapturePaneColumns {
  CAPTURE_PANE_COLUMN_TYPE,
  CAPTURE_PANE_COLUMN_REF,
  CAPTURE_PANE_COLUMN_INFO,
  CAPTURE_PANE_COLUMN_REFLECTION,
  //
  CAPTURE_PANE_COLUMN_COUNT
};

void RenderCapturePane(reshade::api::device* device, DeviceData& data) {
  static ImGuiTreeNodeFlags tree_node_flags = ImGuiTreeNodeFlags_SpanAllColumns | ImGuiTreeNodeFlags_SpanFullWidth;
  if (ImGui::BeginTable(
          "##SnapshotTree",
          5,
          ImGuiTableFlags_BordersV | ImGuiTableFlags_BordersOuterH | ImGuiTableFlags_Resizable | ImGuiTableFlags_Hideable
              | ImGuiTableFlags_NoBordersInBody | ImGuiTableFlags_ScrollY,
          ImVec2(-4, -4))) {
    ImGui::TableSetupColumn("Type", ImGuiTableColumnFlags_NoHide | ImGuiTableColumnFlags_WidthStretch, 24.0f);
    ImGui::TableSetupColumn("Ref", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthStretch, 16.0f);
    ImGui::TableSetupColumn("Info", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthStretch, 24.0f);
    ImGui::TableSetupColumn("Reflection", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthStretch, 24.0f);
    ImGui::TableSetupScrollFreeze(0, 1);
    ImGui::TableHeadersRow();

    uint32_t row_index = 0x2000;
    int draw_index = 0;
    for (auto& command_list_data : data.command_list_data) {
      for (auto& draw_details : command_list_data.draw_details) {
        ImGui::TableNextRow();
        bool draw_node_open = false;

        if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
          auto flags = tree_node_flags;
          if (device->get_api() != reshade::api::device_api::d3d12) {
            flags |= ImGuiTreeNodeFlags_DefaultOpen;
          }
          ImGui::PushID(row_index);
          draw_node_open = ImGui::TreeNodeEx("", flags, "%s", draw_details.DrawMethodString().c_str());
          ImGui::PopID();
        }

        if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
          ImGui::Text("%03d", draw_index);
        }

        for (const auto& [slot, buffer_range] : draw_details.constants) {
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
              ImGui::TreeNodeEx("", bullet_flags, (slot.second == 0) ? "CB%d" : "CB%d,space%d", slot.first, slot.second);
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
          auto& shader_device_data = renodx::utils::shader::GetShaderDeviceData(device);
          std::unique_lock shader_data_lock(shader_device_data.mutex);
          auto details_pair = shader_device_data.pipeline_shader_details.find(pipeline_bind.pipeline.handle);
          if (details_pair == shader_device_data.pipeline_shader_details.end()) continue;
          auto& pipeline_details = details_pair->second;

          if (!pipeline_details.tag.has_value()) {
            pipeline_details.tag = "";
            if (data.live_pipelines.contains(pipeline_bind.pipeline.handle)) {
              auto result = renodx::utils::trace::GetDebugName(device->get_api(), pipeline_bind.pipeline);
              if (result.has_value()) {
                pipeline_details.tag = result.value();
              }
            }
          }

          for (const auto& shader_hash : pipeline_bind.shader_hashes) {
            auto& shader_details = data.GetShaderDetails(shader_hash);
            switch (shader_details.shader_type) {
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

              auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                                  | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                  | selection.GetTreeNodeFlags();

              // Fallback to subobject
              if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
                ImGui::PushID(row_index);
                if (shader_details.program_version.has_value()) {
                  ImGui::TreeNodeEx("", bullet_flags, "%s_%d_%d",
                                    shader_details.program_version->GetKindAbbr(),
                                    shader_details.program_version->GetMajor(),
                                    shader_details.program_version->GetMinor());
                } else {
                  std::stringstream s;
                  s << shader_details.shader_type;
                  ImGui::TreeNodeEx("", bullet_flags, "%s", s.str().c_str());
                }
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
                ImGui::Text("0x%08X", shader_hash);
              }

              if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
                RenderFileAlias(shader_details.disk_shader);
              }

              if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION))) {
                if (!pipeline_details.tag->empty()) {
                  ImGui::TextUnformatted(pipeline_details.tag->c_str());
                }
              }
            }
          }
        }

        for (auto& [slot, resource_view_details] : draw_details.srv_binds) {
          ++row_index;
          bool srv_node_open = false;
          if (draw_node_open) {
            ImGui::TableNextRow();
            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
              ImGui::PushID(row_index);
              srv_node_open = ImGui::TreeNodeEx(
                  "",
                  tree_node_flags | ImGuiTreeNodeFlags_DefaultOpen,
                  (slot.second == 0) ? "SRV%d" : "SRV%d,space%d", slot.first, slot.second);
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
              s << resource_view_details.resource_desc.texture.format;

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

        for (auto& [slot, resource_view_details] : draw_details.uav_binds) {
          ++row_index;
          bool uav_node_open = false;
          if (draw_node_open) {
            ImGui::TableNextRow();
            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE))) {
              ImGui::PushID(row_index);

              uav_node_open = ImGui::TreeNodeEx(
                  "",
                  tree_node_flags | ImGuiTreeNodeFlags_DefaultOpen,
                  (slot.second == 0) ? "UAV%d" : "UAV%d,space%d", slot.first, slot.second);

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
              s << resource_view_details.resource_desc.texture.format;

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
          if (rtv_node_open) {
            SettingSelection search = {.resource_handle = render_target.resource.handle};
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
              ImGui::Text("0x%016llX", render_target.resource.handle);
            }

            if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO))) {
              std::stringstream s;
              s << render_target.resource_desc.texture.format;

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

            ImGui::TreePop();
          }
        }

        if (draw_node_open) {
          ImGui::TreePop();
        }
        ++row_index;
        ++draw_index;
      }
    }

    ImGui::EndTable();
  }  // BeginTable
}

enum ShaderPaneColumns {
  SHADER_PANE_COLUMN_HASH,
  SHADER_PANE_COLUMN_TYPE,
  SHADER_PANE_COLUMN_ALIAS,
  SHADER_PANE_COLUMN_SOURCE,
  SHADER_PANE_COLUMN_OPTIONS,
  SHADER_PANE_COLUMN_SNAPSHOT,
  //
  SHADER_PANE_COLUMN_COUNT
};

void RenderShadersPane(reshade::api::device* device, DeviceData& data) {
  static ImGuiTreeNodeFlags tree_node_flags = ImGuiTreeNodeFlags_SpanAllColumns | ImGuiTreeNodeFlags_SpanFullWidth;

  if (ImGui::BeginTable(
          "##ShadersPaneTable",
          SHADER_PANE_COLUMN_COUNT,
          ImGuiTableFlags_BordersInner | ImGuiTableFlags_Resizable | ImGuiTableFlags_ScrollY
              | ImGuiTableFlags_Sortable | ImGuiTableFlags_SortMulti | ImGuiTableFlags_Hideable,
          ImVec2(0, 0))) {
    ImGui::TableSetupColumn("Hash", ImGuiTableColumnFlags_NoHide | ImGuiTableColumnFlags_WidthStretch);
    ImGui::TableSetupColumn("Type", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthStretch, 16.0f);
    ImGui::TableSetupColumn("Alias", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthStretch, 16.0f);
    ImGui::TableSetupColumn("Source", ImGuiTableColumnFlags_NoHide);
    ImGui::TableSetupColumn("Options", ImGuiTableColumnFlags_NoHide);
    ImGui::TableSetupColumn("Snapshot", ImGuiTableColumnFlags_None | ImGuiTableColumnFlags_WidthStretch, 16.0f);
    ImGui::TableSetupScrollFreeze(0, 1);
    ImGui::TableHeadersRow();

    int cell_index_id = 0x10000;
    int current_snapshot_index = 0;

    std::unordered_set<uint32_t> drawn_hashes;

    auto draw_row = [&](ShaderDetails& shader_details, int snapshot_index = -1) {
      if (drawn_hashes.contains(shader_details.shader_hash)) return;
      switch (shader_details.shader_type) {
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
      SettingSelection search = {.shader_hash = shader_details.shader_hash};
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
                std::format("0x{:08x}", shader_details.shader_hash).c_str(),
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
        RenderFileAlias(shader_details.disk_shader);
        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(SHADER_PANE_COLUMN_TYPE)) {
        ImGui::PushID(cell_index_id++);
        if (shader_details.program_version.has_value()) {
          ImGui::Text("%s_%d_%d",
                      shader_details.program_version->GetKindAbbr(),
                      shader_details.program_version->GetMajor(),
                      shader_details.program_version->GetMinor());
        } else {
          std::stringstream s;
          s << shader_details.shader_type;
          ImGui::TextUnformatted(s.str().c_str());
        }
        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(SHADER_PANE_COLUMN_SOURCE)) {  // Source
        ImGui::PushID(cell_index_id++);
        ImGui::SetNextItemWidth(ImGui::GetColumnWidth(2));
        if (shader_details.shader_source == ShaderDetails::ShaderSource::ORIGINAL_SHADER
            && shader_details.addon_shader.empty() && !shader_details.disk_shader.has_value()) {
          ImGui::TextDisabled("%s", ShaderDetails::SHADER_SOURCE_NAMES[0]);
        } else {
          if (ImGui::BeginCombo(
                  "",
                  ShaderDetails::SHADER_SOURCE_NAMES[static_cast<int>(shader_details.shader_source)],
                  ImGuiComboFlags_None)) {
            for (int i = 0; i < IM_ARRAYSIZE(ShaderDetails::SHADER_SOURCE_NAMES); ++i) {
              const bool is_selected = (i == static_cast<int>(shader_details.shader_source));

              ImGui::BeginDisabled(
                  (i == 1 && shader_details.addon_shader.empty())
                  || (i == 2 && (!shader_details.disk_shader.has_value() || !shader_details.disk_shader->IsCompilationOK())));
              if (ImGui::Selectable(ShaderDetails::SHADER_SOURCE_NAMES[i], is_selected)) {
                shader_details.shader_source = static_cast<ShaderDetails::ShaderSource>(i);
                DeactivateShader(device, shader_details.shader_hash);
                if (i == 1) {
                  ActivateShader(device, shader_details.shader_hash, shader_details.addon_shader);
                } else if (i == 2) {
                  auto shader_data = shader_details.disk_shader->GetCompilationData();
                  ActivateShader(device, shader_details.shader_hash, shader_data);
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

      if (ImGui::TableSetColumnIndex(SHADER_PANE_COLUMN_OPTIONS)) {  // Options
        ImGui::PushID(cell_index_id++);

        auto color_vec4 = ImGui::GetStyleColorVec4(ImGuiCol_Button);
        if (shader_details.bypass_draw) {
          color_vec4 = {.5, .5, .5, color_vec4.w};
        }
        ImGui::PushStyleColor(ImGuiCol_Button, color_vec4);

        float text_size = std::max({
                              ImGui::CalcTextSize("Draw").x,
                              ImGui::CalcTextSize("Dump").x,
                              ImGui::CalcTextSize("Edit").x,
                          })
                          + (ImGui::GetStyle().FramePadding.x * 2);
        if (ImGui::Button("Draw", {text_size, 0})) {
          shader_details.bypass_draw = !shader_details.bypass_draw;
        }
        ImGui::PopStyleColor();

        ImGui::SameLine();

        if (ImGui::Button("Dump", {text_size, 0})) {
          renodx::utils::shader::dump::DumpShader(shader_details.shader_hash, shader_details.shader_data);
        }

        ImGui::BeginDisabled(!shader_details.disk_shader.has_value());
        ImGui::SameLine();
        if (ImGui::Button("Edit", {text_size, 0})) {
          if (shader_details.disk_shader.has_value()) {
            if (!shader_details.disk_shader->file_path.empty()) {
              ShellExecute(0, "open", shader_details.disk_shader->file_path.string().c_str(), 0, 0, SW_SHOW);
            }
          }
        }
        ImGui::EndDisabled();

        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(SHADER_PANE_COLUMN_SNAPSHOT)) {  // Snapshot
        ImGui::PushID(cell_index_id++);
        if (snapshot_index == -1) {
          ImGui::TextUnformatted("");
        } else {
          ImGui::Text("%03d", snapshot_index);
        }
        ImGui::PopID();
      }
      drawn_hashes.emplace(shader_details.shader_hash);
    };

    for (auto& command_list_data : data.command_list_data) {
      for (auto& draw_details : command_list_data.draw_details) {
        for (const auto& pipeline_bind : draw_details.pipeline_binds) {
          for (const auto& shader_hash : pipeline_bind.shader_hashes) {
            if (shader_hash == 0u) continue;
            auto& shader_details = data.GetShaderDetails(shader_hash);
            draw_row(shader_details, current_snapshot_index);
          }
        }
        current_snapshot_index++;
      }
    }

    for (auto& [shader_hash, shader_details] : data.shader_details) {
      draw_row(shader_details);
    }

    ImGui::EndTable();
  }  // ShadersPaneTable
}

void RenderShaderDefinesPane(reshade::api::device* device, DeviceData& data) {
  static ImGuiTreeNodeFlags tree_node_flags = ImGuiTreeNodeFlags_SpanAllColumns | ImGuiTreeNodeFlags_SpanFullWidth;
  if (ImGui::BeginTable(
          "##ShaderDefinesTable",
          4,
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
void DrawSettingBoolCheckbox(reshade::api::effect_runtime* runtime, const char* label, const char* key, T* value) {
  bool temp = *value;
  ImGui::PushID(key);
  if (ImGui::Checkbox(label, &temp)) {
    *value = temp;
    reshade::set_config_value(runtime, "renodx-dev", key, temp);
  }
  ImGui::PopID();
}

void RenderSettingsPane(reshade::api::device* device, DeviceData& data) {
  {
    ImGui::SeparatorText("Snapshot");

    DrawSettingBoolCheckbox(data.runtime, "Show Vertex Shaders", "SnapshotPaneShowVertexShaders", &snapshot_pane_show_vertex_shaders);
    DrawSettingBoolCheckbox(data.runtime, "Show Pixel Shaders", "SnapshotPaneShowPixelShaders", &snapshot_pane_show_pixel_shaders);
    DrawSettingBoolCheckbox(data.runtime, "Show Compute Shaders", "SnapshotPaneShowComputeShaders", &snapshot_pane_show_compute_shaders);
    DrawSettingBoolCheckbox(data.runtime, "Show Blends", "SnapshotPaneShowBlends", &snapshot_pane_show_blends);
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
      reshade::set_config_value(data.runtime, "renodx-dev", "LivePath", temp_string.c_str());
    }

    DrawSettingBoolCheckbox(data.runtime, "Show Vertex Shaders", "ShadersPaneShowVertexShaders", &shaders_pane_show_vertex_shaders);
    DrawSettingBoolCheckbox(data.runtime, "Show Pixel Shaders", "ShadersPaneShowPixelShaders", &shaders_pane_show_pixel_shaders);
    DrawSettingBoolCheckbox(data.runtime, "Show Compute Shaders", "ShadersPaneShowComputeShaders", &shaders_pane_show_compute_shaders);
  }

  {
    ImGui::SeparatorText("Trace");
    DrawSettingBoolCheckbox(data.runtime, "Trace Pipeline Creation", "TracePipelineCreation", &renodx::utils::trace::trace_pipeline_creation);
    DrawSettingBoolCheckbox(data.runtime, "Trace Descriptor Tables", "TraceDescriptorTables", &renodx::utils::descriptor::trace_descriptor_tables);
  }
}

void RenderShaderViewDisassembly(reshade::api::device* device, DeviceData& data, ShaderDetails& shader_details) {
  std::string disassembly_string;
  bool failed = false;
  if (std::holds_alternative<std::nullopt_t>(shader_details.disassembly)) {
    // Never disassembled
    try {
      if (shader_details.shader_data.empty()) {
        reshade::api::pipeline pipeline = {0};
        {
          // Get pipeline handle
          auto& shader_device_data = renodx::utils::shader::GetShaderDeviceData(device);
          std::shared_lock lock(shader_device_data.mutex);
          auto pair = shader_device_data.shader_pipeline_handles.find(shader_details.shader_hash);
          if (pair == shader_device_data.shader_pipeline_handles.end()) {
            throw std::exception("Shader data not found.");
          }
          auto& pipeline_handles = pair->second;
          if (pipeline_handles.empty()) throw std::exception("Shader data not found.");
          pipeline = {*(pipeline_handles.begin())};
        }

        auto shader_data = renodx::utils::shader::GetShaderData(device, pipeline, shader_details.shader_hash);
        if (!shader_data.has_value()) throw std::exception("Invalid shader selection");
        shader_details.shader_data = shader_data.value();
      }
      if (renodx::utils::device::IsDirectX(device)) {
        shader_details.disassembly = renodx::utils::shader::compiler::directx::DisassembleShader(shader_details.shader_data);
      }
    } catch (std::exception& e) {
      shader_details.disassembly = e;
    }
  }

  if (std::holds_alternative<std::exception>(shader_details.disassembly)) {
    disassembly_string.assign(std::get<std::exception>(shader_details.disassembly).what());
    failed = true;
  } else if (std::holds_alternative<std::string>(shader_details.disassembly)) {
    disassembly_string.assign(std::get<std::string>(shader_details.disassembly));
  }

  if (failed) {
    ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(192, 0, 0, 255));
  }
  ImGui::InputTextMultiline(
      "##disassemblyCode",
      const_cast<char*>(disassembly_string.c_str()),
      disassembly_string.length(),
      ImVec2(-4, -4),
      ImGuiInputTextFlags_ReadOnly);
  if (failed) {
    ImGui::PopStyleColor();
  }
}

void RenderShaderViewLive(reshade::api::device* device, DeviceData& data, ShaderDetails& shader_details) {
  std::string live_string;
  bool failed = false;
  if (shader_details.disk_shader.has_value()) {
    if (!shader_details.disk_shader->IsCompilationOK()) {
      live_string = shader_details.disk_shader->GetCompilationException().what();
    } else if (shader_details.disk_shader->is_hlsl) {
      try {
        live_string = renodx::utils::path::ReadTextFile(shader_details.disk_shader->file_path);
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
      std::format("##shader_view_live_0x{:08x}", shader_details.shader_hash).c_str(),
      const_cast<char*>(live_string.c_str()),
      live_string.length(),
      ImVec2(-4, -4),
      ImGuiInputTextFlags_ReadOnly);
  if (failed) {
    ImGui::PopStyleColor();
  }
}

void RenderShaderViewDecompilation(reshade::api::device* device, DeviceData& data, ShaderDetails& shader_details) {
  std::string decompilation_string;
  bool failed = false;
  if (std::holds_alternative<std::nullopt_t>(shader_details.decompilation)) {
    // Never disassembled
    try {
      if (shader_details.shader_data.empty()) {
        reshade::api::pipeline pipeline = {0};
        {
          // Get pipeline handle
          auto& shader_device_data = renodx::utils::shader::GetShaderDeviceData(device);
          std::shared_lock lock(shader_device_data.mutex);
          auto pair = shader_device_data.shader_pipeline_handles.find(shader_details.shader_hash);
          if (pair == shader_device_data.shader_pipeline_handles.end()) {
            throw std::exception("Shader data not found.");
          }
          auto& pipeline_handles = pair->second;
          if (pipeline_handles.empty()) throw std::exception("Shader data not found.");
          pipeline = {*(pipeline_handles.begin())};
        }

        auto shader_data = renodx::utils::shader::GetShaderData(device, pipeline, shader_details.shader_hash);
        if (!shader_data.has_value()) throw std::exception("Invalid shader selection");
        shader_details.shader_data = shader_data.value();
      }
      if (renodx::utils::device::IsDirectX(device)) {
        auto decompiler = renodx::utils::shader::decompiler::dxc::Decompiler();
        auto disassembly_string = renodx::utils::shader::compiler::directx::DisassembleShader(shader_details.shader_data);
        shader_details.decompilation = decompiler.Decompile(
            disassembly_string,
            {
                .flatten = true,
            });
      }
    } catch (std::exception& e) {
      shader_details.decompilation = e;
    }
  }

  if (std::holds_alternative<std::exception>(shader_details.decompilation)) {
    decompilation_string.assign(std::get<std::exception>(shader_details.decompilation).what());
    failed = true;
  } else if (std::holds_alternative<std::string>(shader_details.decompilation)) {
    decompilation_string.assign(std::get<std::string>(shader_details.decompilation));
  }

  if (failed) {
    ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(192, 0, 0, 255));
  }
  ImGui::InputTextMultiline(
      "##decompilationCode",
      const_cast<char*>(decompilation_string.c_str()),
      decompilation_string.length(),
      ImVec2(-4, -4),
      ImGuiInputTextFlags_ReadOnly);
  if (failed) {
    ImGui::PopStyleColor();
  }
}

// Returns false selection is to be removed
void RenderShaderView(reshade::api::device* device, DeviceData& data, SettingSelection& selection) {
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
      auto& shader_details = data.GetShaderDetails(selection.shader_hash);

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

// Returns false selection is to be removed
void RenderResourceViewView(reshade::api::device* device, DeviceData& data, SettingSelection& selection) {
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
      auto resource_view_details = data.GetResourceViewDetails({selection.resource_view_handle}, device);
      bool is_valid = (resource_view_details.resource_desc.type == reshade::api::resource_type::texture_2d
                       || resource_view_details.resource_desc.type == reshade::api::resource_type::surface);
      if (is_valid) {
        auto available_size = ImGui::GetContentRegionAvail();
        auto output_size = ImVec2(
            resource_view_details.resource_desc.texture.width,
            resource_view_details.resource_desc.texture.height);
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

        ImGui::Image(selection.resource_view_handle, output_size, ImVec2(0, 0), ImVec2(1, 1), ImColor(1.0f, 1.0f, 1.0f), ImColor(0.0f, 0.0f, 0.0f, 0.0f));
      }
    }
    ImGui::EndChild();
    ImGui::EndTabItem();
  }
}

void RenderConstantBufferView(reshade::api::device* device, DeviceData& data, SettingSelection& selection) {
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
      auto details = device->get_resource_desc({selection.constant_buffer_handle});

      if (details.type == reshade::api::resource_type::buffer) {
        auto data = renodx::utils::constants::GetResourceCache(device, {selection.constant_buffer_handle});
        if (data.empty()) {
          data = renodx::utils::constants::GetResourceHistory(device, {selection.constant_buffer_handle});
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
                std::format("##constant_buffer_view_tab_child_table_0x{:08x}", selection.constant_buffer_handle).c_str(),
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
    ImGui::EndChild();
    ImGui::EndTabItem();
  }
}

void InitializeUserSettings(reshade::api::effect_runtime* runtime) {
  {
    char temp[256] = "";
    size_t size = 256;
    if (reshade::get_config_value(runtime, "renodx-dev", "LivePath", temp, &size)) {
      std::string temp_string = std::string(temp);
      auto pos = temp_string.find_last_not_of("\t\n\v\f\r ");
      if (pos != std::string_view::npos) {
        temp_string = {temp_string.data(), temp_string.data() + pos + 1};
      }
      renodx::utils::shader::compiler::watcher::SetLivePath(temp_string);
    }
  }

  for (const auto& [key, value] : std::vector<std::pair<const char*, std::atomic_bool*>>({
           {"TracePipelineCreation", &renodx::utils::trace::trace_pipeline_creation},
           {"TraceDescriptorTables", &renodx::utils::descriptor::trace_descriptor_tables},
           {"SnapshotPaneShowVertexShaders", &snapshot_pane_show_vertex_shaders},
           {"SnapshotPaneShowPixelShaders", &snapshot_pane_show_pixel_shaders},
           {"SnapshotPaneShowComputeShaders", &snapshot_pane_show_compute_shaders},
           {"SnapshotPaneShowBlends", &snapshot_pane_show_blends},
           {"ShadersPaneShowVertexShaders", &shaders_pane_show_vertex_shaders},
           {"ShadersPaneShowPixelShaders", &shaders_pane_show_pixel_shaders},
           {"ShadersPaneShowComputeShaders", &shaders_pane_show_compute_shaders},
       })) {
    bool temp = *value;
    if (reshade::get_config_value(runtime, "renodx-dev", key, temp)) {
      *value = temp;
    }
  }
}

// @see https://pthom.github.io/imgui_manual_online/manual/imgui_manual.html
void OnRegisterOverlay(reshade::api::effect_runtime* runtime) {
  auto* device = runtime->get_device();
  auto& data = device->get_private_data<DeviceData>();

  // Runtime may be on a separate device
  if (std::addressof(data) == nullptr) return;

  std::unique_lock lock(data.mutex);  // Probably not needed
  if (data.runtime == nullptr) {
    data.runtime = runtime;
  }
  static auto setting_window_size = 0;
  static auto setting_side_sheet_width = 0;

  if (ImGui::BeginChild("DevKit", ImVec2(0, 0), ImGuiChildFlags_None, ImGuiWindowFlags_MenuBar)) {
    {
      auto width = ImGui::CalcItemWidth();
      if (setting_window_size != width) {
        setting_window_size = width;
        setting_side_sheet_width = 0;
      }
    }

    RenderMenuBar(device, data);

    RenderNavRail(device, data);

    ImGui::SameLine();
    if (ImGui::BeginChild("##LayoutList", ImVec2(72, 0), ImGuiChildFlags_ResizeX)) {
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

    ImGui::SetNextWindowSizeConstraints({0, 0}, {ImGui::GetContentRegionAvail().x - setting_side_sheet_width, FLT_MAX});
    if (ImGui::BeginChild("##Details", {0, 0}, ImGuiChildFlags_ResizeX)) {
      if (!setting_open_tabs.empty()) {
        if (ImGui::BeginTabBar("##SelectedTabs", ImGuiTabBarFlags_Reorderable | ImGuiTabBarFlags_FittingPolicyScroll)) {
          for (auto& selection : setting_open_tabs) {
            if (selection.shader_hash != 0u) {
              RenderShaderView(device, data, selection);
            } else if (selection.resource_view_handle != 0u) {
              RenderResourceViewView(device, data, selection);
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
    if (ImGui::BeginChild("##SideSheet", {0, 0}, ImGuiChildFlags_AutoResizeX)) {
      auto selection = GetCurrentSelection();
      if (selection.has_value()) {
        if (selection->get().shader_hash != 0u) {
          ImGui::RadioButton("Disassembly", &selection->get().shader_view, 0);
          ImGui::RadioButton("Live Shader", &selection->get().shader_view, 1);
          ImGui::RadioButton("Decompilation", &selection->get().shader_view, 2);
        }
      }

      setting_side_sheet_width = 96;
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

  if (setting_live_reload) {
    if (!renodx::utils::shader::compiler::watcher::IsEnabled()) {
      renodx::utils::shader::compiler::watcher::Start();
    }
    auto* device = swapchain->get_device();
    auto& data = device->get_private_data<DeviceData>();
    std::unique_lock lock(data.mutex);
    LoadDiskShaders(device, data, true);
  } else {
    if (renodx::utils::shader::compiler::watcher::IsEnabled()) {
      renodx::utils::shader::compiler::watcher::Stop();
    }
  }

  if (setting_auto_dump) {
    renodx::utils::shader::dump::DumpAllPending();
  }

  DeviceData::StopSnapshot();
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX DevKit";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX DevKit Module";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      // while (IsDebuggerPresent() == 0) {
      //   Sleep(100);
      // }

      if (!initialized) {
        renodx::utils::shader::use_replace_async = true;
        InitializeUserSettings(nullptr);
        initialized = true;
      }

      renodx::utils::constants::Use(fdw_reason);
      renodx::utils::descriptor::Use(fdw_reason);
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::shader::dump::Use(fdw_reason);
      renodx::utils::trace::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      reshade::register_event<reshade::addon_event::init_pipeline>(OnInitPipelineTrackAddons);
      reshade::register_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);

      reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      reshade::register_event<reshade::addon_event::dispatch>(OnDispatch);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      reshade::register_overlay("RenoDX DevKit", OnRegisterOverlay);

      break;
    case DLL_PROCESS_DETACH:

      renodx::utils::constants::Use(fdw_reason);
      renodx::utils::descriptor::Use(fdw_reason);
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::shader::dump::Use(fdw_reason);
      renodx::utils::trace::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      reshade::unregister_event<reshade::addon_event::init_pipeline>(OnInitPipelineTrackAddons);
      reshade::unregister_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
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
