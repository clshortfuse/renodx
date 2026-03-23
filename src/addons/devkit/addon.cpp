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
#include <cassert>
#include <chrono>
#include <cmath>
#include <condition_variable>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <deque>
#include <exception>
#include <filesystem>
#include <format>
#include <initializer_list>
#include <limits>
#include <memory>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <span>
#include <sstream>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <variant>
#include <vector>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../utils/bitwise.hpp"
#include "../../utils/constants.hpp"
#include "../../utils/data.hpp"
#include "../../utils/date.hpp"
#include "../../utils/descriptor.hpp"
#include "../../utils/device.hpp"
#include "../../utils/device_proxy.hpp"
#include "../../utils/format.hpp"
#include "../../utils/icons.hpp"
#include "../../utils/mcp/server.hpp"
#include "../../utils/path.hpp"
#include "../../utils/pipeline_layout.hpp"
#include "../../utils/shader.hpp"
#include "../../utils/shader_compiler_directx.hpp"
#include "../../utils/shader_compiler_watcher.hpp"
#include "../../utils/shader_decompiler_dxc.hpp"
#include "../../utils/shader_dump.hpp"
#include "../../utils/string_view.hpp"
#include "../../utils/swapchain.hpp"
#include "../../utils/trace.hpp"
#include "./formatting.hpp"
#include "./mcp/device_selection.hpp"
#include "./mcp/device_summary.hpp"
#include "./mcp/draw_summary.hpp"
#include "./mcp/live_shaders.hpp"
#include "./mcp/resource_analysis.hpp"
#include "./mcp/resource_clone.hpp"
#include "./mcp/resource_view_summary.hpp"
#include "./mcp/runtime.hpp"
#include "./mcp/shader_inspection.hpp"
#include "./mcp/shader_summary.hpp"
#include "./mcp/snapshot_tools.hpp"
#include "./tools_path.hpp"

namespace {

using json = renodx::utils::mcp::json;
using ToolResult = renodx::utils::mcp::ToolResult;

namespace devkit_resource_analysis = renodx::addons::devkit::mcp::resource_analysis;
namespace devkit_resource_clone = renodx::addons::devkit::mcp::resource_clone;
namespace devkit_resource_view_summary = renodx::addons::devkit::mcp::resource_view_summary;
namespace devkit_device_selection = renodx::addons::devkit::mcp::device_selection;
namespace devkit_device_summary = renodx::addons::devkit::mcp::device_summary;
namespace devkit_draw_summary = renodx::addons::devkit::mcp::draw_summary;
namespace devkit_shader_inspection = renodx::addons::devkit::mcp::shader_inspection;
namespace devkit_shader_summary = renodx::addons::devkit::mcp::shader_summary;
namespace devkit_live_shaders = renodx::addons::devkit::mcp::live_shaders;
namespace devkit_mcp_runtime = renodx::addons::devkit::mcp::runtime;
namespace devkit_snapshot_tools = renodx::addons::devkit::mcp::snapshot_tools;
namespace devkit_tools_path = renodx::addons::devkit::tools_path;

using renodx::addons::devkit::formatting::FormatHandle;
using renodx::addons::devkit::formatting::FormatPointer;
using renodx::addons::devkit::formatting::FormatShaderHash;
using renodx::addons::devkit::formatting::NarrowAscii;
using renodx::addons::devkit::formatting::StreamToString;

void RegisterDevkitMcpTools(renodx::utils::mcp::Server& server);

inline constexpr std::wstring_view DEVKIT_MCP_PIPE_PREFIX = L"renodx-devkit-mcp";

std::atomic<reshade::api::device*> snapshot_device = nullptr;
std::atomic<reshade::api::device*> snapshot_queued_device = nullptr;
std::mutex devkit_mcp_start_mutex;
bool devkit_mcp_start_failed = false;
renodx::utils::mcp::Server devkit_mcp_server({
    .pipe_name = std::format(L"{}-{}", DEVKIT_MCP_PIPE_PREFIX, GetCurrentProcessId()),
    .server_name = "renodx-devkit",
    .server_title = "RenoDX DevKit",
    .server_version = "0.1.0",
});

std::atomic_bool snapshot_trace_with_snapshot = false;
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

void QueueSnapshotCapture(reshade::api::device* device) {
  snapshot_queued_device = device;
  if (snapshot_trace_with_snapshot.load()) {
    renodx::utils::trace::trace_scheduled_device = device;
  }
}
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

struct PendingLiveShaderRequest {
  enum class Operation : std::uint8_t {
    LOAD = 0,
    UNLOAD = 1,
  } operation = Operation::LOAD;
  std::mutex mutex;
  std::condition_variable cv;
  bool started = false;
  bool canceled = false;
  bool completed = false;
  std::optional<ToolResult> result = std::nullopt;
};

struct ResourceViewDetails {
  reshade::api::resource_view resource_view = {0};
  reshade::api::resource_view_desc resource_view_desc;
  reshade::api::resource resource = {0};
  reshade::api::resource_desc resource_desc;
  reshade::api::resource_view clone_view = {0};
  reshade::api::resource_view_desc clone_view_desc;
  reshade::api::resource clone_resource = {0};
  reshade::api::resource_desc clone_resource_desc;
  std::string resource_reflection;
  std::string resource_view_reflection;
  bool is_swapchain = false;
  bool is_rtv_upgraded = false;
  bool is_res_upgraded = false;
  bool is_rtv_cloned = false;
  bool is_res_cloned = false;
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

struct SnapshotResourceUsage {
  int first_snapshot_index = -1;
  bool seen_srv = false;
  bool seen_uav = false;
  bool seen_rtv = false;
};

struct SnapshotRow {
  enum class Kind : std::uint8_t {
    DRAW,
    CONSTANT_BUFFER,
    SHADER,
    SRV,
    SRV_RESOURCE,
    SRV_DIMENSIONS,
    UAV,
    UAV_RESOURCE,
    UAV_DIMENSIONS,
    RTV,
    RTV_RESOURCE,
    RTV_DIMENSIONS,
    RTV_BLEND,
    RTV_WRITE_MASK,
    COPY_SOURCE,
    COPY_DESTINATION,
  } kind = Kind::DRAW;

  std::uint8_t depth = 0;
  int parent_row_index = -1;
  int draw_index = -1;
  int id_seed = 0;
  bool is_tree = false;
  bool default_open = false;
  bool cached_open = false;
  uint32_t slot = 0;
  uint32_t space = 0;
  uint32_t rtv_index = 0;
  uint32_t shader_hash = 0;
  const DrawDetails* draw_details = nullptr;
  const reshade::api::buffer_range* buffer_range = nullptr;
  const PipelineBindDetails* pipeline_bind = nullptr;
  const ResourceViewDetails* resource_view_details = nullptr;
  reshade::api::resource resource = {0u};
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
  details.clone_view = resource_view_info->clone;
  details.clone_view_desc = resource_view_info->clone_desc;
  details.is_rtv_upgraded = resource_view_info->upgraded;
  details.is_rtv_cloned = resource_view_info->clone.handle != 0u;
  auto device_api = device->get_api();

  if (!resource_view_info->destroyed) {
    auto resource_view_reflection = renodx::utils::trace::GetDebugName(device_api, resource_view);
    if (resource_view_reflection.has_value()) {
      details.resource_view_reflection = resource_view_reflection.value();
    }
  }

  if (resource_view_info->resource_info != nullptr) {
    details.resource = resource_view_info->resource_info->resource;
    details.resource_desc = resource_view_info->resource_info->desc;
    details.clone_resource = resource_view_info->resource_info->clone;
    details.clone_resource_desc = resource_view_info->resource_info->clone_desc;
    details.is_res_upgraded = resource_view_info->resource_info->upgraded;
    details.is_res_cloned = resource_view_info->resource_info->clone_enabled;

    if (!resource_view_info->resource_info->destroyed) {
      auto resource_reflection = renodx::utils::trace::GetDebugName(device_api, details.resource);
      if (resource_reflection.has_value()) {
        details.resource_reflection = resource_reflection.value();
      }
    }
    details.is_swapchain = resource_view_info->resource_info->is_swap_chain;
  } else {
    details.is_swapchain = false;
    details.is_res_upgraded = false;
    details.is_res_cloned = false;
  }

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
  std::deque<std::shared_ptr<devkit_resource_analysis::PendingRequest>> pending_resource_analysis_requests;
  std::deque<std::shared_ptr<PendingLiveShaderRequest>> pending_live_shader_requests;

  std::unordered_map<uint32_t, std::set<uint32_t>> shader_draw_indexes;
  std::unordered_map<uint64_t, SnapshotResourceUsage> resource_usage_by_handle;
  std::vector<SnapshotRow> snapshot_rows;
  uint32_t snapshot_row_layout_key = 0u;
  bool snapshot_rows_valid = false;
  std::unordered_map<reshade::api::swapchain*, reshade::api::swapchain_desc> swapchain_descs;
  std::unordered_map<reshade::api::swapchain*, HWND> swapchain_windows;
  reshade::api::swapchain* primary_swapchain = nullptr;
  std::optional<reshade::api::swapchain_desc> primary_swapchain_desc = std::nullopt;
  HWND primary_swapchain_hwnd = nullptr;
  bool primary_swapchain_is_flip = false;
  bool is_d3d9_ex = false;

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

void EnsureShaderDataForShaderDetails(reshade::api::device* device, ShaderDetails* shader_details) {
  if (!shader_details->shader_data.empty()) return;

  reshade::api::pipeline pipeline = {0};

  auto* store = renodx::utils::shader::GetStore();
  store->shader_pipeline_handles.if_contains(
      {device, shader_details->shader_hash},
      [&pipeline](const std::pair<const std::pair<reshade::api::device*, uint32_t>, std::unordered_set<uint64_t>>& pair) {
        if (pair.second.empty()) return;
        auto handle = *pair.second.begin();
        pipeline = {handle};
      });
  if (pipeline.handle == 0u) {
    throw std::runtime_error("Shader data not found.");
  }

  auto shader_data = renodx::utils::shader::GetShaderData(pipeline, shader_details->shader_hash);
  if (!shader_data.has_value()) throw std::runtime_error("Invalid shader selection");
  shader_details->shader_data = shader_data.value();
}

bool ComputeDisassemblyForShaderDetails(reshade::api::device* device, DeviceData* data, ShaderDetails* shader_details) {
  (void)data;
  if (std::holds_alternative<std::nullopt_t>(shader_details->disassembly)) {
    // Never disassembled
    try {
      EnsureShaderDataForShaderDetails(device, shader_details);
      if (renodx::utils::device::IsDirectX(device)) {
        shader_details->disassembly = renodx::utils::shader::compiler::directx::DisassembleShader(shader_details->shader_data);
      } else if (device->get_api() == reshade::api::device_api::opengl) {
        shader_details->disassembly = std::string(
            shader_details->shader_data.data(),
            shader_details->shader_data.data() + shader_details->shader_data.size());
      } else {
        throw std::runtime_error("Unsupported device API.");
      }
    } catch (const std::exception& e) {
      shader_details->disassembly = e;
    }
  }

  return std::holds_alternative<std::string>(shader_details->disassembly);
}

bool ComputeDecompilationForShaderDetails(reshade::api::device* device, DeviceData* data, ShaderDetails* shader_details) {
  (void)data;
  if (std::holds_alternative<std::nullopt_t>(shader_details->decompilation)) {
    try {
      EnsureShaderDataForShaderDetails(device, shader_details);

      if (renodx::utils::device::IsDirectX(device)) {
        auto decompiler = renodx::utils::shader::decompiler::dxc::Decompiler();
        auto disassembly_string = renodx::utils::shader::compiler::directx::DisassembleShader(shader_details->shader_data);
        shader_details->decompilation = decompiler.Decompile(
            disassembly_string,
            {
                .flatten = true,
            });
      } else if (device->get_api() == reshade::api::device_api::opengl) {
        shader_details->decompilation = std::string(
            shader_details->shader_data.data(),
            shader_details->shader_data.data() + shader_details->shader_data.size());
      } else {
        throw std::runtime_error("Unsupported device API.");
      }
    } catch (const std::exception& e) {
      shader_details->decompilation = e;
    }
  }

  return std::holds_alternative<std::string>(shader_details->decompilation);
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
    {"Snapshot", renodx::utils::icons::View(renodx::utils::icons::SEARCH)},
    {"Shaders", renodx::utils::icons::View(renodx::utils::icons::FLOPPY)},
    {"Resources", renodx::utils::icons::View(renodx::utils::icons::FILE_IMAGE)},
    {"Defines", renodx::utils::icons::View(renodx::utils::icons::PLUS)},
    {"Settings", renodx::utils::icons::View(renodx::utils::icons::COG)},
    {"Info", renodx::utils::icons::View(renodx::utils::icons::INFO_CIRCLE)},
};

bool setting_auto_dump = false;
bool setting_live_reload = false;
uint32_t setting_nav_item = 0;
uint32_t setting_device_proxy_output_mode = 2;

enum class DeviceProxyHwndRoute : std::uint8_t {
  SAME_HWND,
  SEPARATE_HWND,
};

enum class DeviceProxyMode : std::uint8_t {
  NONE = 0u,
  CURRENT_WINDOW = 1u,
  NEW_WINDOW = 2u,
};

DeviceProxyMode setting_device_proxy_mode = DeviceProxyMode::NONE;
bool setting_device_proxy_force_dx9_ex = false;
bool setting_device_proxy_force_disable_flip = false;
bool setting_device_proxy_use_custom_shaders = false;
std::vector<std::uint8_t> setting_device_proxy_vertex_shader_blob = {};
std::vector<std::uint8_t> setting_device_proxy_pixel_shader_blob = {};
std::string setting_device_proxy_compile_error = {};
bool g_device_proxy_dx9ex_bootstrap_pending = false;
bool g_device_proxy_disable_flip_bootstrap_pending = false;

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

constexpr const char* DEVICE_PROXY_VERTEX_SHADER_FILENAME = "__devkit_device_proxy_vertex.hlsl";
constexpr const char* DEVICE_PROXY_PIXEL_SHADER_FILENAME = "__devkit_device_proxy_pixel.hlsl";

std::filesystem::path GetEffectiveLiveDirectory(const std::string& live_path) {
  std::filesystem::path directory;
  if (live_path.empty()) {
    directory = renodx::utils::path::GetOutputPath();
    directory /= "live";
  } else {
    directory = live_path;
  }
  return directory.lexically_normal();
}

std::filesystem::path GetDeviceProxyShaderPath(bool vertex) {
  auto file_path = GetEffectiveLiveDirectory(renodx::utils::shader::compiler::watcher::GetLivePath());
  file_path /= vertex ? DEVICE_PROXY_VERTEX_SHADER_FILENAME : DEVICE_PROXY_PIXEL_SHADER_FILENAME;
  return file_path.lexically_normal();
}

bool CompileDeviceProxyShadersFromFiles(std::string* out_error = nullptr) {
  try {
    const auto vertex_path = GetDeviceProxyShaderPath(true);
    const auto pixel_path = GetDeviceProxyShaderPath(false);

    if (!std::filesystem::exists(vertex_path)) {
      throw std::runtime_error(
          std::string("Vertex shader file not found: ")
          + DEVICE_PROXY_VERTEX_SHADER_FILENAME
          + " (expected at "
          + vertex_path.string()
          + ")");
    }
    if (!std::filesystem::exists(pixel_path)) {
      throw std::runtime_error(
          std::string("Pixel shader file not found: ")
          + DEVICE_PROXY_PIXEL_SHADER_FILENAME
          + " (expected at "
          + pixel_path.string()
          + ")");
    }

    auto vertex_blob =
        renodx::utils::shader::compiler::directx::CompileShaderFromFile(vertex_path.c_str(), "vs_5_0");
    auto pixel_blob =
        renodx::utils::shader::compiler::directx::CompileShaderFromFile(pixel_path.c_str(), "ps_5_0");

    if (vertex_blob.empty()) {
      throw std::runtime_error("Vertex shader compilation returned empty bytecode.");
    }
    if (pixel_blob.empty()) {
      throw std::runtime_error("Pixel shader compilation returned empty bytecode.");
    }

    setting_device_proxy_vertex_shader_blob = std::move(vertex_blob);
    setting_device_proxy_pixel_shader_blob = std::move(pixel_blob);
    setting_device_proxy_compile_error.clear();

    std::stringstream s;
    s << "devkit::CompileDeviceProxyShadersFromFiles(success, vs_bytes="
      << setting_device_proxy_vertex_shader_blob.size()
      << ", ps_bytes=" << setting_device_proxy_pixel_shader_blob.size()
      << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    return true;
  } catch (const std::exception& e) {
    setting_device_proxy_compile_error = e.what();
    if (out_error != nullptr) {
      *out_error = setting_device_proxy_compile_error;
    }
    std::stringstream s;
    s << "devkit::CompileDeviceProxyShadersFromFiles(failed: " << setting_device_proxy_compile_error << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }
}

struct DeviceProxyOutputModeConfig {
  reshade::api::format target_format = reshade::api::format::r16g16b16a16_float;
  reshade::api::color_space target_color_space = reshade::api::color_space::extended_srgb_linear;
  reshade::api::format intermediate_format = reshade::api::format::r16g16b16a16_float;
  const char* output_mode_name = "scRGB";
};

[[nodiscard]] DeviceProxyOutputModeConfig ResolveDeviceProxyOutputModeConfig() {
  DeviceProxyOutputModeConfig config = {};
  switch (setting_device_proxy_output_mode) {
    case 0:
      config.target_format = reshade::api::format::r8g8b8a8_unorm;
      config.target_color_space = reshade::api::color_space::srgb_nonlinear;
      config.intermediate_format = reshade::api::format::r8g8b8a8_unorm;
      config.output_mode_name = "sRGB";
      break;
    case 1:
      config.target_format = reshade::api::format::r10g10b10a2_unorm;
      config.target_color_space = reshade::api::color_space::hdr10_st2084;
      config.intermediate_format = reshade::api::format::r16g16b16a16_float;
      config.output_mode_name = "HDR10";
      break;
    default:
      config.target_format = reshade::api::format::r16g16b16a16_float;
      config.target_color_space = reshade::api::color_space::extended_srgb_linear;
      config.intermediate_format = reshade::api::format::r16g16b16a16_float;
      config.output_mode_name = "scRGB";
      break;
  }

  return config;
}

void ApplyDeviceProxySettings() {
  auto mode_config = ResolveDeviceProxyOutputModeConfig();
  reshade::api::format target_format = mode_config.target_format;
  reshade::api::color_space target_color_space = mode_config.target_color_space;
  reshade::api::format intermediate_format = mode_config.intermediate_format;
  const char* output_mode_name = mode_config.output_mode_name;

  renodx::utils::device_proxy::SetTargetFormat(target_format);
  renodx::utils::device_proxy::SetTargetColorSpace(target_color_space);
  renodx::utils::device_proxy::SetIntermediateFormat(intermediate_format);

  std::span<const std::uint8_t> vertex_shader = __swap_chain_proxy_vertex_shader_dx11;
  std::span<const std::uint8_t> pixel_shader = __swap_chain_proxy_pixel_shader_dx11;
  const char* shader_source = "embedded_dx11";
  if (setting_device_proxy_use_custom_shaders) {
    if (!setting_device_proxy_vertex_shader_blob.empty()
        && !setting_device_proxy_pixel_shader_blob.empty()) {
      vertex_shader = std::span<const std::uint8_t>(
          setting_device_proxy_vertex_shader_blob.data(),
          setting_device_proxy_vertex_shader_blob.size());
      pixel_shader = std::span<const std::uint8_t>(
          setting_device_proxy_pixel_shader_blob.data(),
          setting_device_proxy_pixel_shader_blob.size());
      shader_source = "custom_fxc";
    } else {
      shader_source = "embedded_dx11_fallback";
      reshade::log::message(
          reshade::log::level::warning,
          "devkit::ApplyDeviceProxySettings(custom shaders enabled but bytecode is missing, using embedded shaders)");
    }
  }

  renodx::utils::draw::SwapchainProxyPass proxy_settings = {
      .vertex_shader = vertex_shader,
      .pixel_shader = pixel_shader,
      .expected_constant_buffer_index = -1,
      .expected_constant_buffer_space = 0,
      .revert_state = false,
      .use_compatibility_mode = false,
      .proxy_format = target_format,
      .shader_injection = nullptr,
      .shader_injection_size = 0u,
      .auto_device_flush = false,
  };
  renodx::utils::device_proxy::SetProxySettings(proxy_settings);

  std::stringstream s;
  s << "devkit::ApplyDeviceProxySettings(enabled="
    << (renodx::utils::device_proxy::use_device_proxy ? "true" : "false")
    << ", output_mode=" << output_mode_name
    << ", shader_source=" << shader_source
    << ", vs_bytes=" << proxy_settings.vertex_shader.size()
    << ", ps_bytes=" << proxy_settings.pixel_shader.size()
    << ", format=" << target_format
    << ", intermediate=" << intermediate_format
    << ", color_space=" << target_color_space
    << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

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

renodx::utils::resource::ResourceUpgradeInfo devkit_resource_clone_target = {
    .new_format = reshade::api::format::r16g16b16a16_float,
    .use_resource_view_hot_swap = true,
    .usage_set =
        static_cast<uint32_t>(reshade::api::resource_usage::shader_resource
                              | reshade::api::resource_usage::render_target),
    .view_upgrades = renodx::utils::resource::VIEW_UPGRADES_RGBA16F,
    .use_resource_view_cloning_and_upgrade = true,
};

[[nodiscard]] renodx::utils::resource::ResourceInfo* TryGetTrackedResourceInfo(const reshade::api::resource& resource) {
  if (resource.handle == 0u) return nullptr;

  renodx::utils::resource::ResourceInfo* info = nullptr;
  renodx::utils::resource::store->resource_infos.if_contains(
      resource.handle, [&info](auto& pair) {
        info = &pair.second;
      });
  return info;
}

[[nodiscard]] const char* GetResourceCloneToggleBlockedReason(
    reshade::api::device* device,
    const renodx::utils::resource::ResourceInfo* info,
    bool enabling) {
  if (device == nullptr || info == nullptr) return "Resource is no longer tracked.";
  if (info->device != device) return "Resource belongs to a different device.";
  if (info->destroyed) return "Resource was destroyed.";
  if (!enabling) {
    if (info->clone_target != &devkit_resource_clone_target) {
      return "Resource is not managed by devkit clone hotswap.";
    }
    return nullptr;
  }
  if (info->is_clone) return "Resource is already a clone.";
  if (info->desc.type == reshade::api::resource_type::unknown
      || info->desc.type == reshade::api::resource_type::buffer) {
    return "Only texture resources can be clone-hotswapped.";
  }
  if (!renodx::utils::bitwise::HasFlag(info->desc.usage, reshade::api::resource_usage::render_target)) {
    return "Resource does not have render-target usage.";
  }
  if (device->get_api() == reshade::api::device_api::d3d12) {
    return "DX12 per-resource clone hotswap is not supported in devkit yet.";
  }
  if (device->get_api() == reshade::api::device_api::vulkan) {
    return "Vulkan per-resource clone hotswap is not supported in devkit yet.";
  }
  if (enabling
      && info->clone_target != nullptr
      && info->clone_target != &devkit_resource_clone_target) {
    return "Resource already uses a different clone target.";
  }
  return nullptr;
}

[[nodiscard]] bool SetResourceCloneHotSwapState(
    reshade::api::device* device,
    const reshade::api::resource& resource,
    bool enabled) {
  bool found = false;
  bool blocked = false;
  std::string blocked_reason_text = {};
  bool changed = false;
  bool clone_enabled_before = false;
  bool clone_enabled_after = false;
  uint64_t clone_handle_before = 0u;
  uint64_t clone_handle_after = 0u;
  uintptr_t clone_target_before = 0u;
  uintptr_t clone_target_after = 0u;

  renodx::utils::resource::store->resource_infos.if_contains(resource.handle, [&](auto& pair) {
    found = true;
    auto& info = pair.second;
    clone_enabled_before = info.clone_enabled;
    clone_handle_before = info.clone.handle;
    clone_target_before = reinterpret_cast<uintptr_t>(info.clone_target);

    auto* blocked_reason = GetResourceCloneToggleBlockedReason(device, &info, enabled);
    if (blocked_reason != nullptr) {
      blocked = true;
      blocked_reason_text = blocked_reason;
      clone_enabled_after = info.clone_enabled;
      clone_handle_after = info.clone.handle;
      clone_target_after = reinterpret_cast<uintptr_t>(info.clone_target);
      return;
    }

    if (enabled) {
      if (info.clone_target != &devkit_resource_clone_target) {
        info.clone_target = &devkit_resource_clone_target;
        changed = true;
      }
      if (!info.clone_enabled) {
        info.clone_enabled = true;
        changed = true;
      }
    } else {
      if (info.clone_target != &devkit_resource_clone_target) return;
      if (info.clone_enabled) {
        info.clone_enabled = false;
        changed = true;
      }
    }

    clone_enabled_after = info.clone_enabled;
    clone_handle_after = info.clone.handle;
    clone_target_after = reinterpret_cast<uintptr_t>(info.clone_target);
  });

  std::stringstream s;
  s << "devkit::SetResourceCloneHotSwapState(";
  s << "request=" << (enabled ? "enable" : "disable");
  s << ", resource=" << PRINT_PTR(resource.handle);
  s << ", device_api=" << (device == nullptr ? -1 : static_cast<int>(device->get_api()));
  s << ", found=" << (found ? "true" : "false");
  s << ", blocked=" << (blocked ? "true" : "false");
  s << ", changed=" << (changed ? "true" : "false");
  if (found) {
    s << ", clone_target_before=" << PRINT_PTR(clone_target_before);
    s << ", clone_target_after=" << PRINT_PTR(clone_target_after);
    s << ", clone_enabled_before=" << (clone_enabled_before ? "true" : "false");
    s << ", clone_enabled_after=" << (clone_enabled_after ? "true" : "false");
    s << ", clone_handle_before=" << PRINT_PTR(clone_handle_before);
    s << ", clone_handle_after=" << PRINT_PTR(clone_handle_after);
  }
  if (blocked) {
    s << ", reason=\"" << blocked_reason_text << "\"";
  }
  s << ")";

  const auto level = [changed, blocked, found]() {
    if (changed) {
      return reshade::log::level::info;
    }
    if (blocked || !found) {
      return reshade::log::level::warning;
    }
    return reshade::log::level::debug;
  }();
  reshade::log::message(level, s.str().c_str());

  return changed;
}

[[nodiscard]] bool IsDevkitCloneManagedResource(const renodx::utils::resource::ResourceInfo* info) {
  return info != nullptr
         && !info->destroyed
         && !info->is_clone
         && info->clone_target == &devkit_resource_clone_target;
}

std::vector<std::pair<std::string, std::string>> setting_shader_defines;
bool setting_shader_defines_changed = false;
std::shared_mutex pending_created_swapchain_mutex;
std::unordered_map<HWND, reshade::api::swapchain_desc> pending_created_swapchain_descs;
thread_local std::optional<reshade::api::swapchain_desc> pending_created_swapchain_fallback_desc;

[[nodiscard]] bool IsFlipSwapchainPresentMode(uint32_t present_mode) {
  return present_mode == static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL)
         || present_mode == static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD);
}

[[nodiscard]] DeviceProxyMode DeviceProxyModeFromConfig(uint32_t value) {
  switch (value) {
    case 1u:
      return DeviceProxyMode::CURRENT_WINDOW;
    case 2u:
      return DeviceProxyMode::NEW_WINDOW;
    default:
      return DeviceProxyMode::NONE;
  }
}

[[nodiscard]] const char* GetDeviceProxyModeText(DeviceProxyMode mode) {
  switch (mode) {
    case DeviceProxyMode::CURRENT_WINDOW:
      return "Current Window";
    case DeviceProxyMode::NEW_WINDOW:
      return "New Window";
    case DeviceProxyMode::NONE:
    default:
      return "None";
  }
}

[[nodiscard]] bool IsDeviceProxySeparateHwndForced(DeviceData* data) {
  return data != nullptr && data->primary_swapchain_is_flip;
}

[[nodiscard]] DeviceProxyHwndRoute ResolveRequiredDeviceProxyHwndRoute(DeviceData* data) {
  if (IsDeviceProxySeparateHwndForced(data) || setting_device_proxy_mode != DeviceProxyMode::CURRENT_WINDOW) {
    return DeviceProxyHwndRoute::SEPARATE_HWND;
  }
  return DeviceProxyHwndRoute::SAME_HWND;
}

HWND g_device_proxy_output_window = nullptr;
DWORD g_device_proxy_output_window_thread_id = 0;
bool g_device_proxy_output_window_class_registered = false;
bool g_device_proxy_overlay_abort_requested = false;
bool g_device_proxy_reenable_pending = false;
std::optional<DeviceProxyHwndRoute> g_device_proxy_active_hwnd_route = std::nullopt;
constexpr const wchar_t* DEVICE_PROXY_OUTPUT_WINDOW_CLASS_NAME = L"RenoDXDevkitDeviceProxyOutputWindow";

LRESULT CALLBACK DeviceProxyOutputWindowProc(HWND hwnd, UINT message, WPARAM w_param, LPARAM l_param) {
  switch (message) {
    case WM_CLOSE:
      DestroyWindow(hwnd);
      return 0;
    case WM_DESTROY:
      if (hwnd == g_device_proxy_output_window) {
        g_device_proxy_output_window = nullptr;
        g_device_proxy_output_window_thread_id = 0;
      }
      return 0;
    default:
      return DefWindowProcW(hwnd, message, w_param, l_param);
  }
}

void DestroyDeviceProxyOutputWindow() {
  renodx::utils::device_proxy::SetSwapchainHwndOverride(nullptr);
  if (g_device_proxy_output_window != nullptr) {
    if (IsWindow(g_device_proxy_output_window) == FALSE) {
      g_device_proxy_output_window = nullptr;
      g_device_proxy_output_window_thread_id = 0;
    } else {
      const DWORD current_thread_id = GetCurrentThreadId();
      DWORD window_thread_id = GetWindowThreadProcessId(g_device_proxy_output_window, nullptr);
      if (window_thread_id == 0) {
        window_thread_id = g_device_proxy_output_window_thread_id;
      }

      if (window_thread_id == current_thread_id || window_thread_id == 0) {
        if (DestroyWindow(g_device_proxy_output_window) == 0) {
          std::stringstream s;
          s << "devkit::DestroyDeviceProxyOutputWindow(DestroyWindow failed, error=0x"
            << std::hex << static_cast<uint32_t>(GetLastError()) << std::dec << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
        } else {
          g_device_proxy_output_window = nullptr;
          g_device_proxy_output_window_thread_id = 0;
        }
      } else {
        if (PostMessageW(g_device_proxy_output_window, WM_CLOSE, 0, 0) == 0) {
          std::stringstream s;
          s << "devkit::DestroyDeviceProxyOutputWindow(PostMessage WM_CLOSE failed, error=0x"
            << std::hex << static_cast<uint32_t>(GetLastError()) << std::dec << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
        }
      }
    }
  }
}

void PumpDeviceProxyOutputWindowMessages() {
  if (g_device_proxy_output_window == nullptr) return;
  if (IsWindow(g_device_proxy_output_window) == FALSE) {
    g_device_proxy_output_window = nullptr;
    g_device_proxy_output_window_thread_id = 0;
    return;
  }

  DWORD window_thread_id = GetWindowThreadProcessId(g_device_proxy_output_window, nullptr);
  if (window_thread_id == 0) {
    window_thread_id = g_device_proxy_output_window_thread_id;
  }
  if (window_thread_id != 0 && window_thread_id != GetCurrentThreadId()) return;

  MSG msg = {};
  while (PeekMessageW(&msg, g_device_proxy_output_window, 0u, 0u, PM_REMOVE) != 0) {
    TranslateMessage(&msg);
    DispatchMessageW(&msg);
  }
}

[[nodiscard]] bool EnsureDeviceProxyOutputWindow(DeviceData* data) {
  HWND source_hwnd = nullptr;
  uint32_t width = 1280u;
  uint32_t height = 720u;

  if (data != nullptr) {
    source_hwnd = data->primary_swapchain_hwnd;
    if (data->primary_swapchain_desc.has_value()) {
      const auto& desc = data->primary_swapchain_desc.value();
      width = std::max(1u, desc.back_buffer.texture.width);
      height = std::max(1u, desc.back_buffer.texture.height);
    }
  }

  if (source_hwnd != nullptr && (data == nullptr || !data->primary_swapchain_desc.has_value())) {
    RECT source_client_rect = {};
    if (GetClientRect(source_hwnd, &source_client_rect) != 0) {
      const LONG source_width = source_client_rect.right - source_client_rect.left;
      const LONG source_height = source_client_rect.bottom - source_client_rect.top;
      if (source_width > 0) width = static_cast<uint32_t>(source_width);
      if (source_height > 0) height = static_cast<uint32_t>(source_height);
    }
  }

  if (!g_device_proxy_output_window_class_registered) {
    WNDCLASSEXW window_class = {};
    window_class.cbSize = sizeof(window_class);
    window_class.lpfnWndProc = DeviceProxyOutputWindowProc;
    window_class.hInstance = GetModuleHandleW(nullptr);
    window_class.lpszClassName = DEVICE_PROXY_OUTPUT_WINDOW_CLASS_NAME;

    const ATOM class_atom = RegisterClassExW(&window_class);
    if (class_atom == 0u && GetLastError() != ERROR_CLASS_ALREADY_EXISTS) {
      std::stringstream s;
      s << "devkit::EnsureDeviceProxyOutputWindow(RegisterClassExW failed, error=0x";
      s << std::hex << static_cast<uint32_t>(GetLastError()) << std::dec << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
      return false;
    }
    g_device_proxy_output_window_class_registered = true;
  }

  RECT host_rect = {
      100,
      100,
      100 + static_cast<LONG>(width),
      100 + static_cast<LONG>(height),
  };
  if (source_hwnd != nullptr) {
    (void)GetWindowRect(source_hwnd, &host_rect);
  }
  const int left = host_rect.left + 50;
  const int top = host_rect.top + 50;

  if (g_device_proxy_output_window != nullptr && IsWindow(g_device_proxy_output_window) == FALSE) {
    g_device_proxy_output_window = nullptr;
  }

  if (g_device_proxy_output_window == nullptr) {
    g_device_proxy_output_window = CreateWindowExW(
        WS_EX_APPWINDOW,
        DEVICE_PROXY_OUTPUT_WINDOW_CLASS_NAME,
        L"RenoDX Device Proxy Output",
        WS_OVERLAPPEDWINDOW | WS_CLIPCHILDREN | WS_CLIPSIBLINGS,
        left,
        top,
        static_cast<int>(width),
        static_cast<int>(height),
        nullptr,
        nullptr,
        GetModuleHandleW(nullptr),
        nullptr);
    if (g_device_proxy_output_window == nullptr) {
      std::stringstream s;
      s << "devkit::EnsureDeviceProxyOutputWindow(CreateWindowExW failed, error=0x";
      s << std::hex << static_cast<uint32_t>(GetLastError()) << std::dec << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
      return false;
    }
    g_device_proxy_output_window_thread_id = GetWindowThreadProcessId(g_device_proxy_output_window, nullptr);
  }

  SetWindowPos(
      g_device_proxy_output_window,
      HWND_TOP,
      left,
      top,
      static_cast<int>(width),
      static_cast<int>(height),
      SWP_SHOWWINDOW);
  ShowWindow(g_device_proxy_output_window, SW_SHOW);
  UpdateWindow(g_device_proxy_output_window);

  return true;
}

[[nodiscard]] DeviceProxyHwndRoute ResolveEffectiveDeviceProxyHwndRoute(DeviceData* data) {
  const bool is_active =
      renodx::utils::device_proxy::use_device_proxy
      && !renodx::utils::device_proxy::remove_device_proxy;
  if (is_active && g_device_proxy_active_hwnd_route.has_value()) {
    return g_device_proxy_active_hwnd_route.value();
  }
  return ResolveRequiredDeviceProxyHwndRoute(data);
}

[[nodiscard]] bool PrepareDeviceProxyActivation(DeviceData* data) {
  const auto route = ResolveRequiredDeviceProxyHwndRoute(data);
  renodx::utils::device_proxy::SetSameHwndNonFlipBootstrap(route == DeviceProxyHwndRoute::SAME_HWND);

  if (route == DeviceProxyHwndRoute::SEPARATE_HWND) {
    if (!EnsureDeviceProxyOutputWindow(data)) {
      renodx::utils::device_proxy::SetSwapchainHwndOverride(nullptr);
      reshade::log::message(
          reshade::log::level::error,
          "devkit::PrepareDeviceProxyActivation(failed: required separate output window could not be created)");
      g_device_proxy_active_hwnd_route.reset();
      return false;
    }
    renodx::utils::device_proxy::SetSwapchainHwndOverride(g_device_proxy_output_window);
  } else {
    DestroyDeviceProxyOutputWindow();
    renodx::utils::device_proxy::SetSwapchainHwndOverride(nullptr);
  }

  g_device_proxy_active_hwnd_route = route;
  return true;
}

[[nodiscard]] bool UpdateDeviceProxyHwndOverride(DeviceData* data) {
  if (!renodx::utils::device_proxy::use_device_proxy
      || renodx::utils::device_proxy::remove_device_proxy) {
    g_device_proxy_active_hwnd_route.reset();
    DestroyDeviceProxyOutputWindow();
    return false;
  }

  const auto route = ResolveEffectiveDeviceProxyHwndRoute(data);
  if (!g_device_proxy_active_hwnd_route.has_value()) {
    g_device_proxy_active_hwnd_route = route;
  }
  renodx::utils::device_proxy::SetSameHwndNonFlipBootstrap(route == DeviceProxyHwndRoute::SAME_HWND);
  if (route == DeviceProxyHwndRoute::SAME_HWND) {
    DestroyDeviceProxyOutputWindow();
    renodx::utils::device_proxy::SetSwapchainHwndOverride(nullptr);
    return true;
  }

  if (!EnsureDeviceProxyOutputWindow(data)) {
    reshade::log::message(
        reshade::log::level::warning,
        "devkit::UpdateDeviceProxyHwndOverride(failed to ensure output window)");
    renodx::utils::device_proxy::SetSwapchainHwndOverride(nullptr);
    return false;
  }

  renodx::utils::device_proxy::SetSwapchainHwndOverride(g_device_proxy_output_window);

  return true;
}

std::shared_mutex device_data_list_mutex;
std::vector<DeviceData*> device_data_list;

[[nodiscard]] DeviceData* GetSelectedDeviceData() {
  std::shared_lock lock(device_data_list_mutex);
  if (device_data_list.empty()) return nullptr;
  const uint32_t index = std::min<uint32_t>(
      device_data_index.load(std::memory_order_relaxed),
      static_cast<uint32_t>(device_data_list.size() - 1u));
  return device_data_list[index];
}

[[nodiscard]] devkit_device_summary::DeviceSummary BuildDeviceSummary(size_t index, DeviceData* device_data, bool is_selected) {
  std::shared_lock device_lock(device_data->mutex);
  auto* device = device_data->device;

  auto summary = devkit_device_summary::DeviceSummary{
      .index = index,
      .is_selected = is_selected,
      .device_handle = FormatPointer(device),
      .api = StreamToString(device->get_api()),
      .is_d3d9_ex = device_data->is_d3d9_ex,
      .tracked_shaders = device_data->shader_details.size(),
      .captured_draws = device_data->draw_details_list.size(),
      .live_pipelines = device_data->live_pipelines.size(),
      .swapchains = device_data->swapchain_descs.size(),
      .snapshot_rows = device_data->snapshot_rows.size(),
      .snapshot_rows_valid = device_data->snapshot_rows_valid,
      .resource_usage_entries = device_data->resource_usage_by_handle.size(),
      .snapshot_queued = snapshot_queued_device == device,
      .snapshot_active = snapshot_device == device,
  };

  if (device_data->primary_swapchain_desc.has_value()) {
    summary.primary_swapchain = devkit_device_summary::PrimarySwapchainSummary(
        *device_data->primary_swapchain_desc,
        device_data->primary_swapchain_is_flip,
        device_data->primary_swapchain_hwnd);
  }

  return summary;
}

[[nodiscard]] std::string ResourceBindTypeToString(ResourceBind::BindType bind_type) {
  switch (bind_type) {
    case ResourceBind::BindType::SRV: return "srv";
    case ResourceBind::BindType::UAV: return "uav";
    case ResourceBind::BindType::CBV: return "cbv";
    default:                          return "unknown";
  }
}

[[nodiscard]] bool IsResourceBindUsedByShader(
    const std::optional<std::vector<ResourceBind>>& resource_binds,
    ResourceBind::BindType bind_type,
    uint32_t slot,
    uint32_t space) {
  if (!resource_binds.has_value()) return false;
  return std::ranges::any_of(*resource_binds, [bind_type, slot, space](const ResourceBind& bind) {
    return bind.type == bind_type && bind.slot == slot && bind.space == space;
  });
}

[[nodiscard]] devkit_shader_summary::TrackedShaderSummary BuildTrackedShaderSummary(
    uint32_t shader_hash,
    const ShaderDetails& shader_details,
    bool include_resource_binds = false) {
  auto summary = devkit_shader_summary::TrackedShaderSummary{
      .hash = FormatShaderHash(shader_hash),
      .hash_value = shader_hash,
      .stage = StreamToString(shader_details.shader_type),
      .source = ShaderDetails::SHADER_SOURCE_NAMES[static_cast<size_t>(shader_details.shader_source)],
      .shader_data_size = shader_details.shader_data.size(),
      .has_addon_shader = !shader_details.addon_shader.empty(),
      .has_disk_shader = shader_details.disk_shader.has_value(),
      .bypass_draw = shader_details.bypass_draw,
      .entrypoint = shader_details.entrypoint,
  };

  if (shader_details.program_version.has_value()) {
    summary.program_version = std::format(
        "{}_{}_{}",
        shader_details.program_version->GetKindAbbr(),
        shader_details.program_version->GetMajor(),
        shader_details.program_version->GetMinor());
  }
  if (shader_details.resource_binds.has_value()) {
    summary.resource_bind_count = shader_details.resource_binds->size();
    if (include_resource_binds) {
      std::vector<devkit_draw_summary::ResourceBindSummary> resource_binds = {};
      resource_binds.reserve(shader_details.resource_binds->size());
      for (const auto& resource_bind : shader_details.resource_binds.value()) {
        resource_binds.push_back(devkit_draw_summary::ResourceBindSummary{
            .type = ResourceBindTypeToString(resource_bind.type),
            .slot = resource_bind.slot,
            .space = resource_bind.space,
        });
      }
      summary.resource_binds = std::move(resource_binds);
    }
  }
  if (shader_details.disk_shader.has_value()) {
    summary.disk_shader = devkit_shader_summary::DiskShaderSummary{
        .path = shader_details.disk_shader->file_path.string(),
        .compilation_ok = shader_details.disk_shader->IsCompilationOK(),
    };
  }

  return summary;
}

[[nodiscard]] devkit_resource_view_summary::ResourceViewSummary BuildResourceViewSummary(
    const ResourceViewDetails& resource_view_details) {
  auto summary = devkit_resource_view_summary::ResourceViewSummary{
      .resource_view_handle = FormatHandle(resource_view_details.resource_view.handle),
      .resource_view_reflection = resource_view_details.resource_view_reflection.empty()
                                      ? std::nullopt
                                      : std::optional<std::string>(resource_view_details.resource_view_reflection),
      .view = devkit_resource_view_summary::ViewSummary(resource_view_details.resource_view_desc),
      .resource_handle = resource_view_details.resource.handle == 0u
                             ? std::nullopt
                             : std::optional<std::string>(FormatHandle(resource_view_details.resource.handle)),
      .resource_reflection = resource_view_details.resource_reflection.empty()
                                 ? std::nullopt
                                 : std::optional<std::string>(resource_view_details.resource_reflection),
      .resource = devkit_resource_view_summary::ResourceSummary(resource_view_details.resource_desc),
      .mod = {
          .is_swapchain = resource_view_details.is_swapchain,
          .is_render_target_upgraded = resource_view_details.is_rtv_upgraded,
          .is_resource_upgraded = resource_view_details.is_res_upgraded,
          .is_render_target_cloned = resource_view_details.is_rtv_cloned,
          .is_resource_cloned = resource_view_details.is_res_cloned,
      },
  };

  if (resource_view_details.clone_view.handle != 0u || resource_view_details.clone_resource.handle != 0u) {
    summary.clone = devkit_resource_view_summary::CloneSummary{
        .resource_view_handle = resource_view_details.clone_view.handle == 0u
                                    ? std::nullopt
                                    : std::optional<std::string>(FormatHandle(resource_view_details.clone_view.handle)),
        .resource_handle = resource_view_details.clone_resource.handle == 0u
                               ? std::nullopt
                               : std::optional<std::string>(FormatHandle(resource_view_details.clone_resource.handle)),
        .view = devkit_resource_view_summary::ViewSummary(resource_view_details.clone_view_desc),
        .resource = devkit_resource_view_summary::ResourceSummary(resource_view_details.clone_resource_desc),
    };
  }

  return summary;
}

[[nodiscard]] devkit_draw_summary::DrawSummary BuildDrawSummary(
    size_t draw_index,
    const DrawDetails& draw_details,
    bool include_details) {
  std::set<uint32_t> shader_hashes;
  for (const auto& pipeline_bind : draw_details.pipeline_binds) {
    shader_hashes.insert(pipeline_bind.shader_hashes.begin(), pipeline_bind.shader_hashes.end());
  }

  auto draw_summary = devkit_draw_summary::DrawSummary{
      .index = draw_index,
      .method = draw_details.DrawMethodString(),
      .timestamp_ms = std::chrono::duration_cast<std::chrono::milliseconds>(draw_details.timestamp.time_since_epoch()).count(),
      .srv_count = draw_details.srv_binds.size(),
      .uav_count = draw_details.uav_binds.size(),
      .constant_count = draw_details.constants.size(),
      .render_target_count = draw_details.render_targets.size(),
      .pipeline_count = draw_details.pipeline_binds.size(),
  };
  draw_summary.shader_hashes.reserve(shader_hashes.size());
  for (auto shader_hash : shader_hashes) {
    draw_summary.shader_hashes.push_back(FormatShaderHash(shader_hash));
  }
  if (draw_details.copy_source.handle != 0u) {
    draw_summary.copy_source_handle = FormatHandle(draw_details.copy_source.handle);
  }
  if (draw_details.copy_destination.handle != 0u) {
    draw_summary.copy_destination_handle = FormatHandle(draw_details.copy_destination.handle);
  }

  if (!include_details) {
    return draw_summary;
  }

  if (draw_details.IsDispatch()) {
    draw_summary.active_shader_stage = StreamToString(reshade::api::pipeline_stage::compute_shader);
  } else if (draw_details.IsDraw()) {
    draw_summary.active_shader_stage = StreamToString(reshade::api::pipeline_stage::pixel_shader);
  }

  std::vector<devkit_draw_summary::SlotResourceBindingSummary> srv_bindings = {};
  srv_bindings.reserve(draw_details.srv_binds.size());
  for (const auto& [slot_space, resource_view_details] : draw_details.srv_binds) {
    const auto slot = slot_space.first;
    const auto space = slot_space.second;
    srv_bindings.push_back(devkit_draw_summary::SlotResourceBindingSummary{
        .slot = slot,
        .space = space,
        .used_by_active_shader =
            IsResourceBindUsedByShader(draw_details.resource_binds, ResourceBind::BindType::SRV, slot, space),
        .resource_view = BuildResourceViewSummary(resource_view_details),
    });
  }

  std::vector<devkit_draw_summary::SlotResourceBindingSummary> uav_bindings = {};
  uav_bindings.reserve(draw_details.uav_binds.size());
  for (const auto& [slot_space, resource_view_details] : draw_details.uav_binds) {
    const auto slot = slot_space.first;
    const auto space = slot_space.second;
    uav_bindings.push_back(devkit_draw_summary::SlotResourceBindingSummary{
        .slot = slot,
        .space = space,
        .used_by_active_shader =
            IsResourceBindUsedByShader(draw_details.resource_binds, ResourceBind::BindType::UAV, slot, space),
        .resource_view = BuildResourceViewSummary(resource_view_details),
    });
  }

  std::vector<devkit_draw_summary::ConstantBufferSummary> constant_buffers = {};
  constant_buffers.reserve(draw_details.constants.size());
  for (const auto& [slot_space, buffer_range] : draw_details.constants) {
    const auto slot = slot_space.first;
    const auto space = slot_space.second;
    if (buffer_range.buffer.handle == 0u) continue;
    constant_buffers.push_back(devkit_draw_summary::ConstantBufferSummary{
        .slot = slot,
        .space = space,
        .buffer_handle = FormatHandle(buffer_range.buffer.handle),
        .offset = buffer_range.offset,
        .size = buffer_range.size == UINT64_MAX ? std::nullopt : std::optional<std::uint64_t>(buffer_range.size),
        .full_range = buffer_range.size == UINT64_MAX,
        .used_by_active_shader =
            IsResourceBindUsedByShader(draw_details.resource_binds, ResourceBind::BindType::CBV, slot, space),
    });
  }

  std::vector<devkit_draw_summary::RenderTargetSummary> render_targets = {};
  render_targets.reserve(draw_details.render_targets.size());
  for (const auto& [rtv_index, resource_view_details] : draw_details.render_targets) {
    render_targets.push_back(devkit_draw_summary::RenderTargetSummary{
        .rtv_index = rtv_index,
        .resource_view = BuildResourceViewSummary(resource_view_details),
        .blend = draw_details.blend_desc.has_value()
                     ? std::optional<devkit_draw_summary::BlendAttachmentSummary>(
                           devkit_draw_summary::BlendAttachmentSummary{
                               .rtv_index = rtv_index,
                               .blend_enable = draw_details.blend_desc->blend_enable[rtv_index],
                               .logic_op_enable = draw_details.blend_desc->logic_op_enable[rtv_index],
                               .source_color_blend_factor =
                                   StreamToString(draw_details.blend_desc->source_color_blend_factor[rtv_index]),
                               .dest_color_blend_factor =
                                   StreamToString(draw_details.blend_desc->dest_color_blend_factor[rtv_index]),
                               .color_blend_op = StreamToString(draw_details.blend_desc->color_blend_op[rtv_index]),
                               .source_alpha_blend_factor =
                                   StreamToString(draw_details.blend_desc->source_alpha_blend_factor[rtv_index]),
                               .dest_alpha_blend_factor =
                                   StreamToString(draw_details.blend_desc->dest_alpha_blend_factor[rtv_index]),
                               .alpha_blend_op = StreamToString(draw_details.blend_desc->alpha_blend_op[rtv_index]),
                               .logic_op = StreamToString(draw_details.blend_desc->logic_op[rtv_index]),
                               .render_target_write_mask =
                                   static_cast<uint32_t>(draw_details.blend_desc->render_target_write_mask[rtv_index]),
                               .render_target_write_mask_hex = std::format(
                                   "0x{:X}",
                                   static_cast<uint32_t>(draw_details.blend_desc->render_target_write_mask[rtv_index])),
                           })
                     : std::nullopt,
    });
  }

  std::vector<devkit_draw_summary::PipelineBindSummary> pipelines = {};
  pipelines.reserve(draw_details.pipeline_binds.size());
  for (const auto& pipeline_bind : draw_details.pipeline_binds) {
    std::vector<std::string> shader_hashes = {};
    shader_hashes.reserve(pipeline_bind.shader_hashes.size());
    for (auto shader_hash : pipeline_bind.shader_hashes) {
      shader_hashes.push_back(FormatShaderHash(shader_hash));
    }
    pipelines.push_back(devkit_draw_summary::PipelineBindSummary{
        .pipeline_handle = FormatHandle(pipeline_bind.pipeline.handle),
        .stage = StreamToString(pipeline_bind.pipeline_stage),
        .shader_hashes = std::move(shader_hashes),
    });
  }

  draw_summary.srv_bindings = std::move(srv_bindings);
  draw_summary.uav_bindings = std::move(uav_bindings);
  draw_summary.constant_buffers = std::move(constant_buffers);
  draw_summary.render_targets = std::move(render_targets);
  draw_summary.pipelines = std::move(pipelines);

  if (draw_details.resource_binds.has_value()) {
    std::vector<devkit_draw_summary::ResourceBindSummary> shader_resource_binds = {};
    shader_resource_binds.reserve(draw_details.resource_binds->size());
    for (const auto& resource_bind : draw_details.resource_binds.value()) {
      shader_resource_binds.push_back(devkit_draw_summary::ResourceBindSummary{
          .type = ResourceBindTypeToString(resource_bind.type),
          .slot = resource_bind.slot,
          .space = resource_bind.space,
      });
    }
    draw_summary.shader_resource_binds = std::move(shader_resource_binds);
  }

  if (draw_details.blend_desc.has_value()) {
    std::vector<devkit_draw_summary::BlendAttachmentSummary> attachments = {};
    attachments.reserve(draw_details.render_targets.size());
    for (const auto& [rtv_index, render_target] : draw_details.render_targets) {
      (void)render_target;
      attachments.push_back(devkit_draw_summary::BlendAttachmentSummary{
          .rtv_index = rtv_index,
          .blend_enable = draw_details.blend_desc->blend_enable[rtv_index],
          .logic_op_enable = draw_details.blend_desc->logic_op_enable[rtv_index],
          .source_color_blend_factor =
              StreamToString(draw_details.blend_desc->source_color_blend_factor[rtv_index]),
          .dest_color_blend_factor = StreamToString(draw_details.blend_desc->dest_color_blend_factor[rtv_index]),
          .color_blend_op = StreamToString(draw_details.blend_desc->color_blend_op[rtv_index]),
          .source_alpha_blend_factor =
              StreamToString(draw_details.blend_desc->source_alpha_blend_factor[rtv_index]),
          .dest_alpha_blend_factor = StreamToString(draw_details.blend_desc->dest_alpha_blend_factor[rtv_index]),
          .alpha_blend_op = StreamToString(draw_details.blend_desc->alpha_blend_op[rtv_index]),
          .logic_op = StreamToString(draw_details.blend_desc->logic_op[rtv_index]),
          .render_target_write_mask = static_cast<uint32_t>(draw_details.blend_desc->render_target_write_mask[rtv_index]),
          .render_target_write_mask_hex = std::format(
              "0x{:X}",
              static_cast<uint32_t>(draw_details.blend_desc->render_target_write_mask[rtv_index])),
      });
    }

    draw_summary.blend_state = devkit_draw_summary::BlendStateSummary{
        .alpha_to_coverage_enable = draw_details.blend_desc->alpha_to_coverage_enable,
        .blend_constant = {
            draw_details.blend_desc->blend_constant[0],
            draw_details.blend_desc->blend_constant[1],
            draw_details.blend_desc->blend_constant[2],
            draw_details.blend_desc->blend_constant[3],
        },
        .attachments = std::move(attachments),
    };
  }

  return draw_summary;
}

[[nodiscard]] auto BuildResolveDeviceIndexCallback() {
  return [](const json& arguments) -> uint32_t {
    std::shared_lock list_lock(device_data_list_mutex);
    const auto device_count = device_data_list.size();
    const auto selected_index = device_count == 0u
                                    ? 0u
                                    : std::min<uint32_t>(
                                          device_data_index.load(std::memory_order_relaxed),
                                          static_cast<uint32_t>(device_count - 1u));
    return devkit_device_selection::ResolveRequestedDeviceIndex(arguments, device_count, selected_index);
  };
}

[[nodiscard]] bool EnqueuePendingResourceAnalysisRequest(
    uint32_t device_index,
    const std::shared_ptr<devkit_resource_analysis::PendingRequest>& request) {
  std::shared_lock list_lock(device_data_list_mutex);
  if (device_index >= device_data_list.size()) {
    return false;
  }
  auto* device_data = device_data_list[device_index];

  std::unique_lock device_lock(device_data->mutex);
  device_data->pending_resource_analysis_requests.push_back(request);
  return true;
}

void CancelPendingResourceAnalysisRequest(
    uint32_t device_index,
    const std::shared_ptr<devkit_resource_analysis::PendingRequest>& request) {
  std::shared_lock list_lock(device_data_list_mutex);
  if (device_index >= device_data_list.size()) {
    return;
  }
  auto* device_data = device_data_list[device_index];

  std::unique_lock device_lock(device_data->mutex);
  std::erase(device_data->pending_resource_analysis_requests, request);
}

[[nodiscard]] bool EnqueuePendingLiveShaderRequest(
    uint32_t device_index,
    const std::shared_ptr<PendingLiveShaderRequest>& request) {
  std::shared_lock list_lock(device_data_list_mutex);
  if (device_index >= device_data_list.size()) {
    return false;
  }
  auto* device_data = device_data_list[device_index];

  std::unique_lock device_lock(device_data->mutex);
  device_data->pending_live_shader_requests.push_back(request);
  return true;
}

void CancelPendingLiveShaderRequest(
    uint32_t device_index,
    const std::shared_ptr<PendingLiveShaderRequest>& request) {
  std::shared_lock list_lock(device_data_list_mutex);
  if (device_index >= device_data_list.size()) {
    return;
  }
  auto* device_data = device_data_list[device_index];

  std::unique_lock device_lock(device_data->mutex);
  std::erase(device_data->pending_live_shader_requests, request);
}

[[nodiscard]] devkit_shader_summary::TrackedShaderSummary BuildTrackedShaderSummaryForDevice(
    uint32_t device_index,
    uint32_t shader_hash) {
  std::shared_lock list_lock(device_data_list_mutex);
  if (device_index >= device_data_list.size()) {
    throw std::runtime_error(std::format("Device #{} is not available.", device_index));
  }
  auto* device_data = device_data_list[device_index];

  std::unique_lock device_lock(device_data->mutex);
  auto iterator = device_data->shader_details.find(shader_hash);
  if (iterator == device_data->shader_details.end()) {
    throw std::runtime_error(std::format("Shader {} is not tracked on device #{}.", FormatShaderHash(shader_hash), device_index));
  }

  auto* shader_details = &iterator->second;
  GetResourceBindsForShaderDetails(device_data->device, device_data, shader_details);
  GetEntryPointForShaderDetails(device_data->device, device_data, shader_details);

  return BuildTrackedShaderSummary(shader_hash, *shader_details, true);
}

[[nodiscard]] devkit_shader_inspection::TextSection BuildMcpShaderDisassemblySection(
    uint32_t device_index,
    uint32_t shader_hash) {
  std::shared_lock list_lock(device_data_list_mutex);
  if (device_index >= device_data_list.size()) {
    return devkit_shader_inspection::TextSection{
        .available = false,
        .error = std::format("Device #{} is not available.", device_index),
    };
  }
  auto* device_data = device_data_list[device_index];

  std::unique_lock device_lock(device_data->mutex);
  auto iterator = device_data->shader_details.find(shader_hash);
  if (iterator == device_data->shader_details.end()) {
    return devkit_shader_inspection::TextSection{
        .available = false,
        .error = std::format("Shader {} is not tracked on device #{}.", FormatShaderHash(shader_hash), device_index),
    };
  }

  auto* shader_details = &iterator->second;
  if (!ComputeDisassemblyForShaderDetails(device_data->device, device_data, shader_details)) {
    if (std::holds_alternative<std::exception>(shader_details->disassembly)) {
      return devkit_shader_inspection::TextSection{
          .available = false,
          .error = std::get<std::exception>(shader_details->disassembly).what(),
      };
    }
    return devkit_shader_inspection::TextSection{
        .available = false,
        .error = "Disassembly is unavailable for this shader.",
    };
  }

  return devkit_shader_inspection::TextSection{
      .available = true,
      .text = std::get<std::string>(shader_details->disassembly),
  };
}

[[nodiscard]] devkit_shader_inspection::TextSection BuildMcpShaderDecompilationSection(
    uint32_t device_index,
    uint32_t shader_hash) {
  std::shared_lock list_lock(device_data_list_mutex);
  if (device_index >= device_data_list.size()) {
    return devkit_shader_inspection::TextSection{
        .available = false,
        .error = std::format("Device #{} is not available.", device_index),
    };
  }
  auto* device_data = device_data_list[device_index];

  std::unique_lock device_lock(device_data->mutex);
  auto iterator = device_data->shader_details.find(shader_hash);
  if (iterator == device_data->shader_details.end()) {
    return devkit_shader_inspection::TextSection{
        .available = false,
        .error = std::format("Shader {} is not tracked on device #{}.", FormatShaderHash(shader_hash), device_index),
    };
  }

  auto* shader_details = &iterator->second;
  if (!ComputeDecompilationForShaderDetails(device_data->device, device_data, shader_details)) {
    if (std::holds_alternative<std::exception>(shader_details->decompilation)) {
      return devkit_shader_inspection::TextSection{
          .available = false,
          .error = std::get<std::exception>(shader_details->decompilation).what(),
      };
    }
    return devkit_shader_inspection::TextSection{
        .available = false,
        .error = "Decompilation is unavailable for this shader.",
    };
  }

  return devkit_shader_inspection::TextSection{
      .available = true,
      .text = std::get<std::string>(shader_details->decompilation),
  };
}

struct LoadedDiskShaderResult {
  uint32_t shader_hash = 0u;
  std::filesystem::path file_path;
  bool removed = false;
  bool compilation_ok = false;
  bool activated = false;
};

std::vector<LoadedDiskShaderResult> LoadDiskShaders(reshade::api::device* device, DeviceData* data, bool activate);

[[nodiscard]] ToolResult BuildLoadLiveShadersResult(
    uint32_t device_index,
    const std::vector<LoadedDiskShaderResult>& results) {
  json shader_results = json::array();
  size_t activated_count = 0u;
  for (const auto& result : results) {
    if (result.activated) {
      activated_count += 1u;
    }
    shader_results.push_back(devkit_draw_summary::LoadedDiskShaderSummary{
        .hash = FormatShaderHash(result.shader_hash),
        .hash_value = result.shader_hash,
        .path = result.file_path.string(),
        .removed = result.removed,
        .compilation_ok = result.compilation_ok,
        .activated = result.activated,
    });
  }

  const auto effective_directory = GetEffectiveLiveDirectory(renodx::utils::shader::compiler::watcher::GetLivePath());
  auto text = results.empty()
                  ? std::format("No live shaders were loaded from '{}'.", effective_directory.string())
                  : std::format(
                        "Loaded {} live shader file(s) from '{}' for device #{} ({} activated).",
                        results.size(),
                        effective_directory.string(),
                        device_index,
                        activated_count);

  return ToolResult{
      .text = std::move(text),
      .structured_content = json{
          {"deviceIndex", device_index},
          {"effectiveDirectory", effective_directory.string()},
          {"loadedCount", results.size()},
          {"activatedCount", activated_count},
          {"shaders", std::move(shader_results)},
      },
  };
}

[[nodiscard]] ToolResult BuildUnloadLiveShadersResult(uint32_t device_index, size_t reset_count) {
  return ToolResult{
      .text = std::format("Removed live shader replacements from device #{}.", device_index),
      .structured_content = json{
          {"deviceIndex", device_index},
          {"resetSourceCount", reset_count},
      },
  };
}

[[nodiscard]] ToolResult DumpTrackedShaderForMcp(
    uint32_t device_index,
    uint32_t shader_hash,
    const std::optional<std::string>& output_path) {
  std::shared_lock list_lock(device_data_list_mutex);
  if (device_index >= device_data_list.size()) {
    const auto error = std::format("Device #{} is not available.", device_index);
    return ToolResult{
        .text = error,
        .structured_content = json{{"error", error}},
        .is_error = true,
    };
  }
  auto* device_data = device_data_list[device_index];

  std::unique_lock device_lock(device_data->mutex);
  auto iterator = device_data->shader_details.find(shader_hash);
  if (iterator == device_data->shader_details.end()) {
    const auto error =
        std::format("Shader {} is not tracked on device #{}.", FormatShaderHash(shader_hash), device_index);
    return ToolResult{
        .text = error,
        .structured_content = json{{"error", error}},
        .is_error = true,
    };
  }

  auto* shader_details = &iterator->second;

  std::filesystem::path dump_path = {};
  try {
    EnsureShaderDataForShaderDetails(device_data->device, shader_details);
    if (output_path.has_value() && !output_path->empty()) {
      dump_path = std::filesystem::path(*output_path).lexically_normal();
      if (dump_path.has_parent_path()) {
        std::filesystem::create_directories(dump_path.parent_path());
      }
      renodx::utils::path::WriteBinaryFile(dump_path, shader_details->shader_data);
    } else {
      dump_path = renodx::utils::shader::dump::GetShaderDumpPath(
          shader_hash,
          shader_details->shader_data,
          shader_details->shader_type,
          "",
          device_data->device->get_api());
      renodx::utils::shader::dump::DumpShader(
          shader_hash,
          shader_details->shader_data,
          shader_details->shader_type,
          "",
          device_data->device->get_api());
    }
  } catch (const std::exception& exception) {
    const auto error = std::string(exception.what());
    return ToolResult{
        .text = error,
        .structured_content = json{{"error", error}},
        .is_error = true,
    };
  }

  json shader_json = BuildTrackedShaderSummary(shader_hash, *shader_details, true);
  shader_json["dumpPath"] = dump_path.string();

  return ToolResult{
      .text = std::format(
          "Dumped shader {} from device #{} to '{}'.",
          FormatShaderHash(shader_hash),
          device_index,
          dump_path.string()),
      .structured_content = json{
          {"deviceIndex", device_index},
          {"shader", std::move(shader_json)},
          {"outputPath", dump_path.string()},
      },
  };
}

[[nodiscard]] ToolResult SetLiveShaderPathForMcp(const std::optional<std::string>& live_path) {
  if (live_path.has_value()) {
    renodx::utils::shader::compiler::watcher::SetLivePath(*live_path);
  }

  const auto configured_path = renodx::utils::shader::compiler::watcher::GetLivePath();
  const auto effective_directory = GetEffectiveLiveDirectory(configured_path);
  std::filesystem::create_directories(effective_directory);

  return ToolResult{
      .text = live_path.has_value()
                  ? std::format("Set the live shader directory to '{}'.", effective_directory.string())
                  : std::format("The live shader directory is '{}'.", effective_directory.string()),
      .structured_content = json{
          {"configuredPath", configured_path},
          {"effectiveDirectory", effective_directory.string()},
      },
  };
}

[[nodiscard]] ToolResult LoadLiveShadersForMcp(uint32_t device_index) {
  {
    std::shared_lock list_lock(device_data_list_mutex);
    if (device_index >= device_data_list.size()) {
      const auto error = std::format("Device #{} is not available.", device_index);
      return ToolResult{
          .text = error,
          .structured_content = json{{"error", error}},
          .is_error = true,
      };
    }
  }

  auto request = std::make_shared<PendingLiveShaderRequest>();
  request->operation = PendingLiveShaderRequest::Operation::LOAD;
  if (!EnqueuePendingLiveShaderRequest(device_index, request)) {
    const auto error = std::format("Device #{} is not available.", device_index);
    return ToolResult{
        .text = error,
        .structured_content = json{{"error", error}},
        .is_error = true,
    };
  }

  {
    std::unique_lock request_lock(request->mutex);
    if (!request->cv.wait_for(request_lock, std::chrono::seconds(15), [&request]() { return request->completed || request->started; })) {
      request->canceled = true;
      request_lock.unlock();
      CancelPendingLiveShaderRequest(device_index, request);
      return ToolResult{
          .text = "Timed out waiting for the next present to process the live shader load request.",
          .structured_content = json{
              {"error", "Timed out waiting for the next present to process the live shader load request."},
          },
          .is_error = true,
      };
    }

    if (!request->completed) {
      request->cv.wait(request_lock, [&request]() { return request->completed; });
    }
  }

  if (!request->result.has_value()) {
    return ToolResult{
        .text = "The live shader load request completed without a result.",
        .structured_content = json{
            {"error", "The live shader load request completed without a result."},
        },
        .is_error = true,
    };
  }

  return request->result.value();
}

[[nodiscard]] ToolResult UnloadLiveShadersForMcp(uint32_t device_index) {
  {
    std::shared_lock list_lock(device_data_list_mutex);
    if (device_index >= device_data_list.size()) {
      const auto error = std::format("Device #{} is not available.", device_index);
      return ToolResult{
          .text = error,
          .structured_content = json{{"error", error}},
          .is_error = true,
      };
    }
  }

  auto request = std::make_shared<PendingLiveShaderRequest>();
  request->operation = PendingLiveShaderRequest::Operation::UNLOAD;
  if (!EnqueuePendingLiveShaderRequest(device_index, request)) {
    const auto error = std::format("Device #{} is not available.", device_index);
    return ToolResult{
        .text = error,
        .structured_content = json{{"error", error}},
        .is_error = true,
    };
  }

  {
    std::unique_lock request_lock(request->mutex);
    if (!request->cv.wait_for(request_lock, std::chrono::seconds(15), [&request]() { return request->completed || request->started; })) {
      request->canceled = true;
      request_lock.unlock();
      CancelPendingLiveShaderRequest(device_index, request);
      return ToolResult{
          .text = "Timed out waiting for the next present to process the live shader unload request.",
          .structured_content = json{
              {"error", "Timed out waiting for the next present to process the live shader unload request."},
          },
          .is_error = true,
      };
    }

    if (!request->completed) {
      request->cv.wait(request_lock, [&request]() { return request->completed; });
    }
  }

  if (!request->result.has_value()) {
    return ToolResult{
        .text = "The live shader unload request completed without a result.",
        .structured_content = json{
            {"error", "The live shader unload request completed without a result."},
        },
        .is_error = true,
    };
  }

  return request->result.value();
}

[[nodiscard]] ToolResult SetResourceCloneForMcp(uint32_t device_index, std::uint64_t resource_handle, bool enabled) {
  std::shared_lock list_lock(device_data_list_mutex);
  if (device_index >= device_data_list.size()) {
    const auto error = std::format("Device #{} is not available.", device_index);
    return ToolResult{
        .text = error,
        .structured_content = json{{"error", error}},
        .is_error = true,
    };
  }
  auto* device_data = device_data_list[device_index];

  const auto resource = reshade::api::resource{resource_handle};
  auto* info = TryGetTrackedResourceInfo(resource);
  if (info == nullptr) {
    const auto error = std::format("Resource {} is not tracked.", FormatHandle(resource_handle));
    return ToolResult{
        .text = error,
        .structured_content = json{{"error", error}},
        .is_error = true,
    };
  }
  if (info->device != device_data->device) {
    const auto error = std::format("Resource {} belongs to a different device.", FormatHandle(resource_handle));
    return ToolResult{
        .text = error,
        .structured_content = json{{"error", error}},
        .is_error = true,
    };
  }

  auto before = devkit_resource_clone::TrackedResourceSummary(*info);
  if (const auto* blocked_reason = GetResourceCloneToggleBlockedReason(device_data->device, info, enabled); blocked_reason != nullptr) {
    return ToolResult{
        .text = blocked_reason,
        .structured_content = json{
            {"deviceIndex", device_index},
            {"requestedEnabled", enabled},
            {"before", before},
        },
        .is_error = true,
    };
  }

  const auto changed = SetResourceCloneHotSwapState(device_data->device, resource, enabled);
  auto* updated_info = TryGetTrackedResourceInfo(resource);
  if (updated_info == nullptr) {
    const auto error = std::format("Resource {} is no longer tracked.", FormatHandle(resource_handle));
    return ToolResult{
        .text = error,
        .structured_content = json{{"error", error}},
        .is_error = true,
    };
  }

  auto after = devkit_resource_clone::TrackedResourceSummary(*updated_info);
  const auto text = std::format(
      "Clone hotswap for resource {} is {} on device #{}.",
      FormatHandle(resource_handle),
      enabled ? "enabled" : "disabled",
      device_index);

  return ToolResult{
      .text = text,
      .structured_content = json{
          {"deviceIndex", device_index},
          {"requestedEnabled", enabled},
          {"changed", changed},
          {"before", before},
          {"after", after},
      },
  };
}

void ProcessPendingLiveShaderRequests(
    const std::deque<std::shared_ptr<PendingLiveShaderRequest>>& requests,
    uint32_t device_index,
    DeviceData* device_data) {
  for (const auto& request : requests) {
    {
      std::scoped_lock request_lock(request->mutex);
      if (request->completed || request->canceled) {
        request->completed = true;
        request->cv.notify_all();
        continue;
      }
      request->started = true;
    }
    request->cv.notify_all();

    ToolResult result = {
        .text = "Unknown live shader request.",
        .structured_content = json{
            {"error", "Unknown live shader request."},
        },
        .is_error = true,
    };

    try {
      switch (request->operation) {
        case PendingLiveShaderRequest::Operation::LOAD: {
          setting_live_reload = false;
          std::vector<LoadedDiskShaderResult> load_results = {};
          {
            std::unique_lock device_lock(device_data->mutex);
            load_results = LoadDiskShaders(device_data->device, device_data, true);
          }
          result = BuildLoadLiveShadersResult(device_index, load_results);
          break;
        }
        case PendingLiveShaderRequest::Operation::UNLOAD: {
          size_t reset_count = 0u;
          {
            std::unique_lock device_lock(device_data->mutex);
            for (auto& [shader_hash, shader_details] : device_data->shader_details) {
              (void)shader_hash;
              if (shader_details.shader_source == ShaderDetails::ShaderSource::DISK_SHADER) {
                shader_details.shader_source = ShaderDetails::ShaderSource::ORIGINAL_SHADER;
                reset_count += 1u;
              }
            }
            renodx::utils::shader::RemoveRuntimeReplacements(device_data->device);
          }
          setting_live_reload = false;
          (void)renodx::utils::shader::compiler::watcher::CompileSync();
          result = BuildUnloadLiveShadersResult(device_index, reset_count);
          break;
        }
        default:
          break;
      }
    } catch (const std::exception& exception) {
      result = ToolResult{
          .text = exception.what(),
          .structured_content = json{
              {"error", exception.what()},
          },
          .is_error = true,
      };
    } catch (...) {
      result = ToolResult{
          .text = "Unhandled live shader request failure.",
          .structured_content = json{
              {"error", "Unhandled live shader request failure."},
          },
          .is_error = true,
      };
    }

    {
      std::scoped_lock request_lock(request->mutex);
      request->result = std::move(result);
      request->completed = true;
    }
    request->cv.notify_all();
  }
}

[[nodiscard]] devkit_snapshot_tools::ToolContext BuildSnapshotToolsContext() {
  return devkit_snapshot_tools::ToolContext{
      .get_device_count = []() {
        std::shared_lock list_lock(device_data_list_mutex);
        return device_data_list.size(); },
      .get_selected_device_index = []() { return device_data_index.load(std::memory_order_relaxed); },
      .set_selected_device_index = [](uint32_t device_index) { device_data_index.store(device_index, std::memory_order_relaxed); },
      .get_pipe_name = []() { return NarrowAscii(devkit_mcp_server.GetPipeName()); },
      .is_connected = []() { return devkit_mcp_server.IsConnected(); },
      .has_active_snapshot = []() { return snapshot_device != nullptr; },
      .has_queued_snapshot = []() { return snapshot_queued_device != nullptr; },
      .is_snapshot_active = [](uint32_t device_index) {
        std::shared_lock list_lock(device_data_list_mutex);
        if (device_index >= device_data_list.size()) return false;
        return snapshot_device == device_data_list[device_index]->device; },
      .is_snapshot_queued = [](uint32_t device_index) {
        std::shared_lock list_lock(device_data_list_mutex);
        if (device_index >= device_data_list.size()) return false;
        return snapshot_queued_device == device_data_list[device_index]->device; },
      .build_device_summary = [](uint32_t device_index, bool is_selected) {
        std::shared_lock list_lock(device_data_list_mutex);
        if (device_index >= device_data_list.size()) {
          throw std::runtime_error(std::format("Device #{} is not available.", device_index));
        }
        return BuildDeviceSummary(device_index, device_data_list[device_index], is_selected); },
      .list_shaders = [](uint32_t device_index, const std::optional<std::string>& stage_filter) {
        std::shared_lock list_lock(device_data_list_mutex);
        if (device_index >= device_data_list.size()) return std::vector<devkit_shader_summary::TrackedShaderSummary>{};
        auto* device_data = device_data_list[device_index];

        std::shared_lock device_lock(device_data->mutex);
        struct ShaderSummaryEntry {
          uint32_t shader_hash = 0u;
          devkit_shader_summary::TrackedShaderSummary payload;
        };

        std::vector<ShaderSummaryEntry> entries = {};
        entries.reserve(device_data->shader_details.size());
        for (const auto& [shader_hash, shader_details] : device_data->shader_details) {
          const auto stage_name = StreamToString(shader_details.shader_type);
          if (stage_filter.has_value() && *stage_filter != stage_name) continue;

          entries.push_back(ShaderSummaryEntry{
              .shader_hash = shader_hash,
              .payload = BuildTrackedShaderSummary(shader_hash, shader_details),
          });
        }

        std::ranges::sort(entries, [](const ShaderSummaryEntry& lhs, const ShaderSummaryEntry& rhs) {
          return lhs.shader_hash < rhs.shader_hash;
        });

        std::vector<devkit_shader_summary::TrackedShaderSummary> result;
        result.reserve(entries.size());
        for (auto& entry : entries) {
          result.push_back(entry.payload);
        }
        return result; },
      .list_draws = [](uint32_t device_index) {
        std::shared_lock list_lock(device_data_list_mutex);
        if (device_index >= device_data_list.size()) return std::vector<devkit_draw_summary::DrawSummary>{};
        auto* device_data = device_data_list[device_index];

        std::shared_lock device_lock(device_data->mutex);
        std::vector<devkit_draw_summary::DrawSummary> draws;
        draws.reserve(device_data->draw_details_list.size());
        for (size_t index = 0; index < device_data->draw_details_list.size(); ++index) {
          draws.push_back(BuildDrawSummary(index, device_data->draw_details_list[index], false));
        }
        return draws; },
      .get_draw = [](uint32_t device_index, uint32_t draw_index) {
        std::shared_lock list_lock(device_data_list_mutex);
        if (device_index >= device_data_list.size()) {
          throw std::runtime_error(std::format("Device #{} is not available.", device_index));
        }
        auto* device_data = device_data_list[device_index];

        std::shared_lock device_lock(device_data->mutex);
        if (draw_index >= device_data->draw_details_list.size()) {
          throw std::runtime_error(std::format("drawIndex {} is out of range.", draw_index));
        }

        return BuildDrawSummary(draw_index, device_data->draw_details_list[draw_index], true); },
      .build_snapshot_summary = [](uint32_t device_index) {
        std::shared_lock list_lock(device_data_list_mutex);
        if (device_index >= device_data_list.size()) {
          throw std::runtime_error(std::format("Device #{} is not available.", device_index));
        }
        auto* device_data = device_data_list[device_index];

        std::shared_lock device_lock(device_data->mutex);
        auto* device = device_data->device;
        return renodx::addons::devkit::mcp::snapshot_summary::SnapshotSummary{
            .device_index = device_index,
            .snapshot_queued = snapshot_queued_device == device,
            .snapshot_active = snapshot_device == device,
            .captured_draws = device_data->draw_details_list.size(),
            .tracked_shaders = device_data->shader_details.size(),
            .resource_usage_entries = device_data->resource_usage_by_handle.size(),
            .shader_usage_entries = device_data->shader_draw_indexes.size(),
            .snapshot_rows = device_data->snapshot_rows.size(),
            .snapshot_rows_valid = device_data->snapshot_rows_valid,
        }; },
      .queue_snapshot = [](uint32_t device_index) {
        std::shared_lock list_lock(device_data_list_mutex);
        if (device_index >= device_data_list.size()) {
          const auto error = std::format("Device #{} is not available.", device_index);
          return ToolResult{
              .text = error,
              .structured_content = json{{"error", error}},
              .is_error = true,
          };
        }
        auto* device_data = device_data_list[device_index];

        auto* device = device_data->device;
        reshade::api::device* active_snapshot_device = snapshot_device;
        if (active_snapshot_device != nullptr && active_snapshot_device != device) {
          return ToolResult{
              .text = "Another device is currently capturing a snapshot.",
              .structured_content = json{
                  {"error", "Another device is currently capturing a snapshot."},
              },
              .is_error = true,
          };
        }
        if (active_snapshot_device == device) {
          return ToolResult{
              .text = std::format("A snapshot capture is already running for device #{}.", device_index),
              .structured_content = json{
                  {"deviceIndex", device_index},
                  {"queued", false},
                  {"active", true},
              },
          };
        }

        reshade::api::device* queued_snapshot_device = snapshot_queued_device;
        if (queued_snapshot_device == device) {
          return ToolResult{
              .text = std::format("A snapshot capture is already queued for device #{}.", device_index),
              .structured_content = json{
                  {"deviceIndex", device_index},
                  {"queued", true},
                  {"active", false},
              },
          };
        }
        if (queued_snapshot_device != nullptr && queued_snapshot_device != device) {
          return ToolResult{
              .text = "Another device already has a queued snapshot request.",
              .structured_content = json{
                  {"error", "Another device already has a queued snapshot request."},
              },
              .is_error = true,
          };
        }

        QueueSnapshotCapture(device);
        return ToolResult{
            .text = snapshot_trace_with_snapshot.load()
                        ? std::format("Queued a snapshot capture and trace for device #{}.", device_index)
                        : std::format("Queued a snapshot capture for device #{}.", device_index),
            .structured_content = json{
                {"deviceIndex", device_index},
                {"queued", true},
                {"active", false},
                {"traceQueued", snapshot_trace_with_snapshot.load()},
            },
        }; },
  };
}

void RegisterDevkitMcpTools(renodx::utils::mcp::Server& server) {
  const devkit_mcp_runtime::RegistrationContext context = {
      .build_snapshot_tools_context = BuildSnapshotToolsContext,
      .build_shader_inspection_tool_context = []() { return devkit_shader_inspection::ToolContext{
                                                         .resolve_device_index = BuildResolveDeviceIndexCallback(),
                                                         .get_shader_summary = BuildTrackedShaderSummaryForDevice,
                                                         .get_disassembly = BuildMcpShaderDisassemblySection,
                                                         .get_decompilation = BuildMcpShaderDecompilationSection,
                                                     }; },
      .build_live_shaders_tool_context = []() { return devkit_live_shaders::ToolContext{
                                                    .resolve_device_index = BuildResolveDeviceIndexCallback(),
                                                    .dump_shader = DumpTrackedShaderForMcp,
                                                    .set_live_shader_path = SetLiveShaderPathForMcp,
                                                    .load_live_shaders = LoadLiveShadersForMcp,
                                                    .unload_live_shaders = UnloadLiveShadersForMcp,
                                                }; },
      .build_analyze_resource_tool_context = []() { return devkit_resource_analysis::ToolContext{
                                                        .resolve_device_index = BuildResolveDeviceIndexCallback(),
                                                        .enqueue_request = EnqueuePendingResourceAnalysisRequest,
                                                        .cancel_request = CancelPendingResourceAnalysisRequest,
                                                    }; },
      .build_resource_clone_tool_context = []() { return devkit_resource_clone::ToolContext{
                                                      .resolve_device_index = BuildResolveDeviceIndexCallback(),
                                                      .set_resource_clone = SetResourceCloneForMcp,
                                                  }; },
      .set_tools_path = devkit_tools_path::SetToolsPath,
  };
  devkit_mcp_runtime::RegisterTools(server, context);
}

void EnsureDevkitMcpServerStarted() {
  if (devkit_mcp_server.IsRunning()) return;

  std::scoped_lock lock(devkit_mcp_start_mutex);
  if (devkit_mcp_server.IsRunning() || devkit_mcp_start_failed) return;

  RegisterDevkitMcpTools(devkit_mcp_server);
  if (devkit_mcp_server.Start()) {
    const auto pipe_name_string = NarrowAscii(devkit_mcp_server.GetPipeName());
    reshade::log::message(
        reshade::log::level::info,
        std::format("devkit::mcp(Listening on {})", pipe_name_string).c_str());
    return;
  }

  devkit_mcp_start_failed = true;
  reshade::log::message(reshade::log::level::warning, "devkit::mcp(Failed to start MCP server)");
}

void OnInitDevice(reshade::api::device* device) {
  if (renodx::utils::device_proxy::is_creating_proxy_device) return;

  auto* device_data = renodx::utils::data::Create<DeviceData>(device);
  std::unique_lock lock(device_data_list_mutex);
  device_data->device = device;
  device_data->is_d3d9_ex = renodx::utils::device::IsD3D9ExDevice(device);
  device_data_list.emplace_back(device_data);

  if (g_device_proxy_dx9ex_bootstrap_pending && device->get_api() == reshade::api::device_api::d3d9) {
    g_device_proxy_dx9ex_bootstrap_pending = false;
    renodx::utils::device_proxy::use_device_proxy = false;
    renodx::utils::device_proxy::remove_device_proxy = false;

    std::stringstream s;
    s << "devkit::OnInitDevice(Force DX9Ex bootstrap "
      << (device_data->is_d3d9_ex ? "succeeded" : "did not upgrade")
      << ", device=" << PRINT_PTR(reinterpret_cast<uintptr_t>(device))
      << ")";
    reshade::log::message(
        device_data->is_d3d9_ex ? reshade::log::level::info : reshade::log::level::warning,
        s.str().c_str());
  }
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
  if (GetSelectedDeviceData() == device_data) {
    DestroyDeviceProxyOutputWindow();
  }
  std::unique_lock list_lock(device_data_list_mutex);
  std::erase(device_data_list, device_data);
  std::unique_lock device_lock(device_data->mutex);
  renodx::utils::data::Delete<DeviceData>(device);
}

#if RESHADE_API_VERSION >= 17
bool OnCreateSwapchain(reshade::api::device_api device_api, reshade::api::swapchain_desc& desc, void* hwnd) {
#else
bool OnCreateSwapchain(reshade::api::swapchain_desc& desc, void* hwnd) {
  reshade::api::device_api device_api = reshade::api::device_api::d3d11;
#endif
  bool changed = false;
  const bool is_proxy_internal_swapchain =
      renodx::utils::device_proxy::is_creating_proxy_device
      || renodx::utils::device_proxy::is_creating_proxy_swapchain;

  if (g_device_proxy_disable_flip_bootstrap_pending
      && renodx::utils::device::IsDirectX(device_api)
      && !is_proxy_internal_swapchain) {
    const auto old_present_mode = desc.present_mode;
    const auto old_present_flags = desc.present_flags;
    switch (desc.present_mode) {
      case static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL):
        desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_SEQUENTIAL);
        break;
      case static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD):
        desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_DISCARD);
        break;
      default:
        break;
    }

    // Non-flip swapchains cannot use ALLOW_TEARING.
    if (!IsFlipSwapchainPresentMode(desc.present_mode)) {
      desc.present_flags &= ~DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING;
    }
    // FRAME_LATENCY_WAITABLE_OBJECT is only valid with FLIP_SEQUENTIAL.
    if (desc.present_mode != static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL)) {
      desc.present_flags &= ~DXGI_SWAP_CHAIN_FLAG_FRAME_LATENCY_WAITABLE_OBJECT;
    }

    if (old_present_mode != desc.present_mode || old_present_flags != desc.present_flags) {
      changed = true;
      std::stringstream s;
      s << "devkit::OnCreateSwapchain(Force Disable Flip applied";
      s << ", api=" << static_cast<uint32_t>(device_api);
      s << ", mode: 0x" << std::hex << old_present_mode << " => 0x" << desc.present_mode << std::dec;
      s << ", flags: 0x" << std::hex << old_present_flags << " => 0x" << desc.present_flags << std::dec;
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }

  if (is_proxy_internal_swapchain) return changed;

  auto* tracked_hwnd = static_cast<HWND>(hwnd);
  {
    const std::unique_lock<std::shared_mutex> lock(pending_created_swapchain_mutex);
    if (tracked_hwnd != nullptr) {
      pending_created_swapchain_descs[tracked_hwnd] = desc;
    } else {
      pending_created_swapchain_fallback_desc = desc;
    }
  }

  return changed;
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain->get_device();
  auto* device_data = renodx::utils::data::Get<DeviceData>(device);
  if (device_data == nullptr) return;

  auto* hwnd = static_cast<HWND>(swapchain->get_hwnd());
  reshade::api::swapchain_desc tracked_desc = {};
  bool used_create_desc = false;
  {
    const std::unique_lock<std::shared_mutex> lock(pending_created_swapchain_mutex);
    if (hwnd != nullptr) {
      if (auto pair = pending_created_swapchain_descs.find(hwnd); pair != pending_created_swapchain_descs.end()) {
        tracked_desc = pair->second;
        pending_created_swapchain_descs.erase(pair);
        used_create_desc = true;
      }
    }
    if (!used_create_desc && pending_created_swapchain_fallback_desc.has_value()) {
      tracked_desc = pending_created_swapchain_fallback_desc.value();
      pending_created_swapchain_fallback_desc.reset();
      used_create_desc = true;
    }
  }

  if (!used_create_desc) {
    tracked_desc.back_buffer = device->get_resource_desc(swapchain->get_current_back_buffer());
    tracked_desc.back_buffer_count = swapchain->get_back_buffer_count();
  }

  const bool is_flip = IsFlipSwapchainPresentMode(tracked_desc.present_mode);
  {
    const std::unique_lock lock(device_data->mutex);
    device_data->swapchain_descs[swapchain] = tracked_desc;
    device_data->swapchain_windows[swapchain] = hwnd;
    if (!resize || device_data->primary_swapchain == nullptr || device_data->primary_swapchain == swapchain) {
      device_data->primary_swapchain = swapchain;
      device_data->primary_swapchain_desc = tracked_desc;
      device_data->primary_swapchain_hwnd = hwnd;
      device_data->primary_swapchain_is_flip = is_flip;
    }
  }

  if (renodx::utils::device_proxy::use_device_proxy
      && !renodx::utils::device_proxy::remove_device_proxy
      && GetSelectedDeviceData() == device_data) {
    (void)UpdateDeviceProxyHwndOverride(device_data);
  }
}

void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain->get_device();
  auto* device_data = renodx::utils::data::Get<DeviceData>(device);
  if (device_data == nullptr) return;

  {
    const std::unique_lock<std::shared_mutex> lock(device_data->mutex);
    device_data->swapchain_descs.erase(swapchain);
    device_data->swapchain_windows.erase(swapchain);
    if (!resize && device_data->primary_swapchain == swapchain) {
      device_data->primary_swapchain = nullptr;
      device_data->primary_swapchain_desc.reset();
      device_data->primary_swapchain_hwnd = nullptr;
      device_data->primary_swapchain_is_flip = false;
    }
  }

  if (renodx::utils::device_proxy::use_device_proxy
      && !renodx::utils::device_proxy::remove_device_proxy
      && GetSelectedDeviceData() == device_data) {
    (void)UpdateDeviceProxyHwndOverride(device_data);
  }
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
            throw std::runtime_error("Failed to get shader data");
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
  reshade::api::device* active_snapshot_device = snapshot_device;
  if (active_snapshot_device == nullptr) return false;

  auto* device = cmd_list->get_device();

  if (device == active_snapshot_device) {
    DrawDetails draw_details = {
        .draw_method = DrawDetails::DrawMethods::COPY,
        .timestamp = std::chrono::system_clock::now(),
        .copy_source = source,
        .copy_destination = dest,
    };

    auto* device_data = renodx::utils::data::Get<DeviceData>(device);
    if (device_data == nullptr) return false;
    std::unique_lock lock(device_data->mutex);
    if (snapshot_trace_with_snapshot) {
      reshade::log::message(reshade::log::level::debug, std::format("Snapshot #{}", device_data->draw_details_list.size()).c_str());
    }
    device_data->draw_details_list.push_back(draw_details);
    device_data->snapshot_rows_valid = false;
  } else {
    reshade::log::message(reshade::log::level::debug, "Foreign Copy.");
  }

  return false;
}

bool OnCopyTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box,
    reshade::api::filter_mode filter) {
  reshade::api::device* active_snapshot_device = snapshot_device;
  if (active_snapshot_device == nullptr) return false;

  auto* device = cmd_list->get_device();

  if (device == active_snapshot_device) {
    DrawDetails draw_details = {
        .draw_method = DrawDetails::DrawMethods::COPY,
        .timestamp = std::chrono::system_clock::now(),
        .copy_source = source,
        .copy_destination = dest,
    };

    auto* device_data = renodx::utils::data::Get<DeviceData>(device);
    if (device_data == nullptr) return false;
    std::unique_lock lock(device_data->mutex);
    if (snapshot_trace_with_snapshot) {
      reshade::log::message(reshade::log::level::debug, std::format("Snapshot #{}", device_data->draw_details_list.size()).c_str());
    }
    device_data->draw_details_list.push_back(draw_details);
    device_data->snapshot_rows_valid = false;
  } else {
    reshade::log::message(reshade::log::level::debug, "Foreign Copy.");
  }

  return false;
}

void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
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

  const renodx::utils::pipeline_layout::PipelineLayoutData* layout_data = nullptr;
  auto populate_layout_data = [&]() {
    if (layout_data != nullptr) return true;
    const auto* local_layout_data = renodx::utils::pipeline_layout::GetPipelineLayoutData(layout);
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
#ifndef NDEBUG
        switch (device->get_api()) {
          case reshade::api::device_api::opengl:
            // sometimes opengl can call glEnd without having drawn anything
            break;
          case reshade::api::device_api::d3d9:
            // Pixel shaders on DX9 don't need Vertex shaders because of FVF
            if (stage_state.stage == reshade::api::pipeline_stage::vertex_shader) continue;
          default:
            // Must have pixel shader
            assert(stage_state.stage == reshade::api::pipeline_stage::pixel_shader);
            break;
        }
#endif
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
        const auto* layout_data = renodx::utils::pipeline_layout::GetPipelineLayoutData(pipeline_shader_details->layout);
        if (layout_data != nullptr) {
          const auto* command_list_state = renodx::utils::state::GetCurrentState(cmd_list);
          if (command_list_state == nullptr) return false;
          const auto& bound_pipeline_layout = draw_method == DrawDetails::DrawMethods::DISPATCH
                                                  ? command_list_state->compute_pipeline_layout
                                                  : command_list_state->graphics_pipeline_layout;
          const auto& bound_descriptor_tables = draw_method == DrawDetails::DrawMethods::DISPATCH
                                                    ? command_list_state->compute_descriptor_tables
                                                    : command_list_state->graphics_descriptor_tables;
          if (bound_pipeline_layout == pipeline_shader_details->layout) {
            const auto& info = *layout_data;
            auto param_count = info.params.size();
            auto* descriptor_data = renodx::utils::data::Get<renodx::utils::descriptor::DeviceData>(device);
            if (descriptor_data == nullptr) return false;

            for (auto param_index = 0; param_index < param_count; ++param_index) {
              if (param_index >= bound_descriptor_tables.size()) continue;

              const auto& param = info.params.at(param_index);
              const auto& table = bound_descriptor_tables[param_index];

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

                // Skip empty and unbounded ranges
                if (range.count == 0u || range.count == UINT32_MAX) continue;

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
                auto heap_pair = descriptor_data->heaps.find(heap.handle);
                if (heap_pair == descriptor_data->heaps.end()) {
                  // Unknown heap?
                  continue;
                }
                const auto& heap_data = heap_pair->second;
                if (base_offset >= heap_data.size()) {
                  // Invalid location (may be oversized bind)
                  continue;
                }
                const auto descriptor_count =
                    std::min<uint32_t>(range.count, static_cast<uint32_t>(heap_data.size() - base_offset));
                if (descriptor_count == 0u) continue;
                auto known_pair = descriptor_data->resource_view_heap_locations.find(heap.handle);
                if (known_pair == descriptor_data->resource_view_heap_locations.end()) continue;
                for (uint32_t k = 0; k < descriptor_count; ++k) {
                  auto offset = base_offset + k;
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

                  bool use_uav = (is_uav || range.type == reshade::api::descriptor_type::unordered_access_view);

                  if (resource_view.handle != 0u) {
                    auto detail_item = GetResourceViewDetails(resource_view, device);
                    if (detail_item.resource.handle != 0u || !renodx::utils::resource::IsResourceViewEmpty(device, resource_view)) {
                      if (use_uav) {
                        draw_details.uav_binds[slot] = detail_item;
                      } else {
                        draw_details.srv_binds[slot] = detail_item;
                      }
                      continue;
                    }
                  }

                  if (use_uav) {
                    draw_details.uav_binds.erase(slot);
                  } else {
                    draw_details.srv_binds.erase(slot);
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
    if (snapshot_trace_with_snapshot) {
      reshade::log::message(reshade::log::level::debug, std::format("Snapshot #{}", device_data->draw_details_list.size()).c_str());
    }
    device_data->draw_details_list.push_back(std::move(draw_details));
    device_data->snapshot_rows_valid = false;
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

std::vector<LoadedDiskShaderResult> LoadDiskShaders(reshade::api::device* device, DeviceData* data, bool activate) {
  std::vector<LoadedDiskShaderResult> results = {};
  if (setting_live_reload) {
    if (!renodx::utils::shader::compiler::watcher::HasChanged()) return results;
  } else {
    renodx::utils::shader::compiler::watcher::CompileSync();
  }
  const auto& custom_shaders = renodx::utils::shader::compiler::watcher::FlushCompiledShaders();
  results.reserve(custom_shaders.size());
  for (const auto& [shader_hash, custom_shader] : custom_shaders) {
    reshade::log::message(reshade::log::level::debug, "new shaders");
    auto* details = data->GetShaderDetails(shader_hash);
    details->disk_shader = custom_shader;

    auto result = LoadedDiskShaderResult{
        .shader_hash = shader_hash,
        .file_path = custom_shader.file_path,
        .removed = custom_shader.removed,
        .compilation_ok = custom_shader.IsCompilationOK(),
        .activated = false,
    };

    if (activate) {
      details->shader_source = ShaderDetails::ShaderSource::DISK_SHADER;
      DeactivateShader(device, shader_hash);

      if (!custom_shader.removed && custom_shader.IsCompilationOK()) {
        const auto& shader_data = details->disk_shader->GetCompilationData();
        ActivateShader(device, shader_hash, shader_data);
        result.activated = true;
      }
    }

    results.push_back(std::move(result));
  }

  return results;
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
      QueueSnapshotCapture(device);
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
      LoadDiskShaders(device, data, true);
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
      renodx::utils::trace::trace_scheduled_device = device;
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

    const float snapshot_row_height = ImGui::GetFrameHeight();
    const uint32_t snapshot_row_layout_key =
        (snapshot_pane_show_vertex_shaders ? 1u << 0u : 0u)
        | (snapshot_pane_show_pixel_shaders ? 1u << 1u : 0u)
        | (snapshot_pane_show_compute_shaders ? 1u << 2u : 0u)
        | (snapshot_pane_filter_resources_by_shader_use ? 1u << 3u : 0u)
        | (snapshot_pane_expand_all_nodes ? 1u << 4u : 0u);

    const auto focus_pending_draw = [&](int draw_index) {
      if (draw_index == pending_draw_index_focus) {
        ImGui::SetItemDefaultFocus();
        ImGui::SetScrollHereY();
        pending_draw_index_focus = -1;
      }
    };

    const auto render_draw_row = [&](const SnapshotRow& row, bool& next_tree_open) {
      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto flags = tree_node_flags;
        if (row.default_open) {
          flags |= ImGuiTreeNodeFlags_DefaultOpen;
        }
        ImGui::PushID(row.id_seed);
        next_tree_open = ImGui::TreeNodeEx("", flags, "%s", row.draw_details->DrawMethodString().c_str());
        focus_pending_draw(row.draw_index);
        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("%03d", row.draw_index);
      }
    };

    const auto render_constant_buffer_row = [&](const SnapshotRow& row) {
      SettingSelection search = {.constant_buffer_handle = row.buffer_range->buffer.handle};
      auto& selection = GetSelection(search);

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                            | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                            | selection.GetTreeNodeFlags();
        ImGui::PushID(row.id_seed);
        ImGui::TreeNodeEx("", bullet_flags, (row.space == 0u) ? "CB%d" : "CB%d,space%d", row.slot, row.space);
        ImGui::PopID();
        if (ImGui::IsItemClicked()) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
        if (ImGui::IsMouseDoubleClicked(ImGuiMouseButton_Left)) {
          selection.is_pinned = true;
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.buffer_range->buffer.handle);
      }

      if ((ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION))) {
        // auto tag = renodx::utils::trace::GetDebugName(device->get_api(), buffer_range.buffer.handle);
        // if (tag.has_value()) {
        //   ImGui::TextUnformatted(tag->c_str());
        // }
      }
    };

    const auto render_shader_row = [&](const SnapshotRow& row) {
      auto* shader_details = data->GetShaderDetails(row.shader_hash);
      auto* pipeline_details_ptr = renodx::utils::shader::GetPipelineShaderDetails(row.pipeline_bind->pipeline);
      if (pipeline_details_ptr != nullptr) {
        auto& pipeline_details = *pipeline_details_ptr;

        if (!pipeline_details.tag.has_value()) {
          pipeline_details.tag = "";
          if (data->live_pipelines.contains(row.pipeline_bind->pipeline.handle)) {
            auto result = renodx::utils::trace::GetDebugName(device->get_api(), row.pipeline_bind->pipeline);
            if (result.has_value()) {
              pipeline_details.tag = result.value();
            }
          }
        }
      }

      SettingSelection search = {.shader_hash = row.shader_hash};
      auto& selection = GetSelection(search);

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::AlignTextToFramePadding();
        ImGui::Text("0x%08X", row.shader_hash);
        auto set_pair = data->shader_draw_indexes.find(row.shader_hash);
        if (set_pair != data->shader_draw_indexes.end()) {
          const auto& set = set_pair->second;
          auto it = set.find(static_cast<uint32_t>(row.draw_index));
          if (it != set.end() && set.size() > 1) {
            const auto& style = ImGui::GetStyle();
            const float text_baseline_offset = style.FramePadding.y;
            int new_index = -1;

            auto prev_it = it;
            const bool has_prev = it != set.begin();
            if (has_prev) {
              --prev_it;
            }

            auto next_it = it;
            ++next_it;
            const bool has_next = next_it != set.end();

            const auto render_nav_button = [&](const char* id, bool disabled, int target_index) {
              ImGui::SameLine(0.0f, style.ItemInnerSpacing.x);
              ImGui::BeginDisabled(disabled);
              const float original_cursor_y = ImGui::GetCursorPosY();
              const float text_line_height = ImGui::GetTextLineHeight();
              const float nav_button_size = text_line_height;
              const ImVec2 nav_button_dimensions(nav_button_size, nav_button_size);
              const float icon_box_size = nav_button_size * 0.5f;
              const float target_icon_size = std::max(1.0f, icon_box_size - 2.0f);
              const float icon_button_padding = std::max(0.0f, (nav_button_size - icon_box_size) * 0.5f);
              const float icon_text_align_y = std::min(1.0f, 0.5f + (2.0f / nav_button_size));
              auto* font = ImGui::GetFont();
              const float current_scaled_font_size = ImGui::GetFontSize();
              const float current_base_font_size = style.FontSizeBase;
              const float target_icon_base_size =
                  (current_scaled_font_size > 0.0f)
                      ? (current_base_font_size * target_icon_size) / current_scaled_font_size
                      : current_base_font_size;
              const float button_cursor_y = original_cursor_y + text_baseline_offset + ((text_line_height - nav_button_size) * 0.5f);
              ImGui::PushFont(font, target_icon_base_size);
              ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(icon_button_padding, icon_button_padding));
              ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, nav_button_size * 0.5f);
              ImGui::PushStyleVar(ImGuiStyleVar_ButtonTextAlign, ImVec2(0.5f, icon_text_align_y));
              ImGui::SetCursorPosY(button_cursor_y);
              const char* label = std::string_view(id) == "##prev"
                                      ? renodx::utils::icons::View(renodx::utils::icons::CHEVRON_LEFT)
                                      : renodx::utils::icons::View(renodx::utils::icons::CHEVRON_RIGHT);
              if (ImGui::Button(label, nav_button_dimensions)) {
                new_index = target_index;
              }
              ImGui::SetCursorPosY(original_cursor_y);
              ImGui::PopStyleVar(3);
              ImGui::PopFont();
              ImGui::EndDisabled();
            };

            ImGui::PushID(row.draw_index);
            render_nav_button("##prev", !has_prev, has_prev ? *prev_it : -1);
            render_nav_button("##next", !has_next, has_next ? *next_it : -1);
            ImGui::PopID();

            if (new_index != -1) {
              pending_draw_index_focus = new_index;
              MakeSelectionCurrent(selection);
            }
          }
        }
      }

      auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                          | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                          | selection.GetTreeNodeFlags();

      // Fallback to subobject
      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        ImGui::PushID(row.id_seed);
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

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        RenderFileAlias(shader_details->disk_shader);
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION)) {
        auto entrypoint = GetEntryPointForShaderDetails(device, data, shader_details);
        if (!entrypoint.empty() && entrypoint != "main") {
          ImGui::TextUnformatted(entrypoint.c_str());
        } else if (pipeline_details_ptr != nullptr && pipeline_details_ptr->tag.has_value() && !pipeline_details_ptr->tag->empty()) {
          ImGui::TextUnformatted(pipeline_details_ptr->tag->c_str());
        }
      }
    };

    const auto render_srv_row = [&](const SnapshotRow& row, bool& next_tree_open) {
      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        ImGui::PushID(row.id_seed);
        next_tree_open = ImGui::TreeNodeEx(
            "",
            tree_node_flags | ImGuiTreeNodeFlags_DefaultOpen,
            (row.space == 0u) ? "T%d" : "T%d,space%d", row.slot, row.space);
        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.resource_view_details->resource_view.handle);
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        std::stringstream s;
        s << row.resource_view_details->resource_view_desc.format;
        if (row.resource_view_details->is_swapchain) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_rtv_upgraded) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 1.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_rtv_cloned) {
          ImGui::TextColored(ImVec4(1.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else {
          ImGui::TextUnformatted(s.str().c_str());
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION)
          && !row.resource_view_details->resource_view_reflection.empty()) {
        ImGui::TextUnformatted(row.resource_view_details->resource_view_reflection.c_str());
      }
    };

    const auto render_srv_resource_row = [&](const SnapshotRow& row) {
      SettingSelection search = {
          .resource_handle = row.resource_view_details->resource.handle,
          .resource_view_handle = row.resource_view_details->resource_view.handle,
      };
      auto& selection = GetSelection(search);

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                            | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                            | selection.GetTreeNodeFlags();
        ImGui::PushID(row.id_seed);
        ImGui::TreeNodeEx("", bullet_flags, "Resource");
        ImGui::PopID();
        if (ImGui::IsItemClicked()) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.resource_view_details->resource.handle);
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        std::stringstream s;

        if (row.resource_view_details->resource_desc.type == reshade::api::resource_type::buffer) {
          s << "Buffer (" << row.resource_view_details->resource_desc.buffer.size << " bytes)";
        } else {
          s << row.resource_view_details->resource_desc.texture.format;
        }
        if (row.resource_view_details->is_swapchain) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_res_upgraded) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 1.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_res_cloned) {
          ImGui::TextColored(ImVec4(1.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else {
          ImGui::TextUnformatted(s.str().c_str());
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION)
          && !row.resource_view_details->resource_reflection.empty()) {
        ImGui::TextUnformatted(row.resource_view_details->resource_reflection.c_str());
      }
    };

    const auto render_srv_dimensions_row = [&](const SnapshotRow& row) {
      SettingSelection search = {
          .resource_handle = row.resource_view_details->resource.handle,
          .resource_view_handle = row.resource_view_details->resource_view.handle,
      };
      auto& selection = GetSelection(search);

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                            | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                            | selection.GetTreeNodeFlags();
        ImGui::PushID(row.id_seed);
        ImGui::TreeNodeEx("", bullet_flags, "Dimensions");
        ImGui::PopID();
        if (ImGui::IsItemClicked()) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.resource_view_details->resource.handle);
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        if (row.resource_view_details->resource_desc.type == reshade::api::resource_type::texture_3d) {
          ImGui::Text("%dx%dx%d", row.resource_view_details->resource_desc.texture.width, row.resource_view_details->resource_desc.texture.height, row.resource_view_details->resource_desc.texture.depth_or_layers);
        } else {
          ImGui::Text("%dx%d", row.resource_view_details->resource_desc.texture.width, row.resource_view_details->resource_desc.texture.height);
        }
      }
    };

    const auto render_uav_row = [&](const SnapshotRow& row, bool& next_tree_open) {
      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        ImGui::PushID(row.id_seed);
        next_tree_open = ImGui::TreeNodeEx(
            "",
            tree_node_flags | ImGuiTreeNodeFlags_DefaultOpen,
            (row.space == 0u) ? "UAV%d" : "UAV%d,space%d", row.slot, row.space);
        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.resource_view_details->resource_view.handle);
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        std::stringstream s;
        s << row.resource_view_details->resource_view_desc.format;
        if (row.resource_view_details->is_swapchain) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_rtv_upgraded) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 1.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_rtv_cloned) {
          ImGui::TextColored(ImVec4(1.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else {
          ImGui::TextUnformatted(s.str().c_str());
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION)
          && !row.resource_view_details->resource_view_reflection.empty()) {
        ImGui::TextUnformatted(row.resource_view_details->resource_view_reflection.c_str());
      }
    };

    const auto render_uav_resource_row = [&](const SnapshotRow& row) {
      SettingSelection search = {.resource_handle = row.resource_view_details->resource.handle};
      auto& selection = GetSelection(search);

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                            | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                            | selection.GetTreeNodeFlags();
        ImGui::PushID(row.id_seed);
        ImGui::TreeNodeEx("", bullet_flags, "Resource");
        ImGui::PopID();
        if (ImGui::IsItemClicked()) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.resource_view_details->resource.handle);
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        std::stringstream s;
        if (row.resource_view_details->resource_desc.type == reshade::api::resource_type::buffer) {
          s << "Buffer (" << row.resource_view_details->resource_desc.buffer.size << " bytes)";
        } else {
          s << row.resource_view_details->resource_desc.texture.format;
        }
        if (row.resource_view_details->is_swapchain) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_res_upgraded) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 1.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_res_cloned) {
          ImGui::TextColored(ImVec4(1.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else {
          ImGui::TextUnformatted(s.str().c_str());
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION)
          && !row.resource_view_details->resource_reflection.empty()) {
        ImGui::TextUnformatted(row.resource_view_details->resource_reflection.c_str());
      }
    };

    const auto render_uav_dimensions_row = [&](const SnapshotRow& row) {
      SettingSelection search = {.resource_handle = row.resource_view_details->resource.handle};
      auto& selection = GetSelection(search);

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                            | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                            | selection.GetTreeNodeFlags();
        ImGui::PushID(row.id_seed);
        ImGui::TreeNodeEx("", bullet_flags, "Dimensions");
        ImGui::PopID();
        if (ImGui::IsItemClicked()) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.resource_view_details->resource.handle);
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        if (row.resource_view_details->resource_desc.type == reshade::api::resource_type::texture_3d) {
          ImGui::Text(
              "%dx%dx%d",
              row.resource_view_details->resource_desc.texture.width,
              row.resource_view_details->resource_desc.texture.height,
              row.resource_view_details->resource_desc.texture.depth_or_layers);
        } else {
          ImGui::Text(
              "%dx%d",
              row.resource_view_details->resource_desc.texture.width,
              row.resource_view_details->resource_desc.texture.height);
        }
      }
    };

    const auto render_rtv_row = [&](const SnapshotRow& row, bool& next_tree_open) {
      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        ImGui::PushID(row.id_seed);
        next_tree_open = ImGui::TreeNodeEx(
            "",
            tree_node_flags | ImGuiTreeNodeFlags_DefaultOpen,
            "RTV%d",
            row.rtv_index);
        ImGui::PopID();
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.resource_view_details->resource_view.handle);
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        std::stringstream s;
        s << row.resource_view_details->resource_view_desc.format;
        if (row.resource_view_details->is_swapchain) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_rtv_upgraded) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 1.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_rtv_cloned) {
          ImGui::TextColored(ImVec4(1.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else {
          ImGui::TextUnformatted(s.str().c_str());
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION)
          && !row.resource_view_details->resource_view_reflection.empty()) {
        ImGui::TextUnformatted(row.resource_view_details->resource_view_reflection.c_str());
      }
    };

    const auto render_rtv_resource_row = [&](const SnapshotRow& row) {
      SettingSelection search = {.resource_handle = row.resource_view_details->resource.handle};
      auto& selection = GetSelection(search);

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                            | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                            | selection.GetTreeNodeFlags();
        ImGui::PushID(row.id_seed);
        ImGui::TreeNodeEx("", bullet_flags, "Resource");
        ImGui::PopID();
        if (ImGui::IsItemClicked()) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.resource_view_details->resource.handle);
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        std::stringstream s;
        if (row.resource_view_details->resource_desc.type == reshade::api::resource_type::buffer) {
          s << "Buffer (" << row.resource_view_details->resource_desc.buffer.size << " bytes)";
        } else {
          s << row.resource_view_details->resource_desc.texture.format;
        }
        if (row.resource_view_details->is_swapchain) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_res_upgraded) {
          ImGui::TextColored(ImVec4(0.f, 1.f, 1.f, 1.f), "%s", s.str().c_str());
        } else if (row.resource_view_details->is_res_cloned) {
          ImGui::TextColored(ImVec4(1.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
        } else {
          ImGui::TextUnformatted(s.str().c_str());
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REFLECTION)
          && !row.resource_view_details->resource_reflection.empty()) {
        ImGui::TextUnformatted(row.resource_view_details->resource_reflection.c_str());
      }
    };

    const auto render_rtv_dimensions_row = [&](const SnapshotRow& row) {
      SettingSelection search = {.resource_handle = row.resource_view_details->resource.handle};
      auto& selection = GetSelection(search);

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                            | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                            | selection.GetTreeNodeFlags();
        ImGui::PushID(row.id_seed);
        ImGui::TreeNodeEx("", bullet_flags, "Dimensions");
        ImGui::PopID();
        if (ImGui::IsItemClicked()) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.resource_view_details->resource.handle);
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        if (row.resource_view_details->resource_desc.type == reshade::api::resource_type::texture_3d) {
          ImGui::Text("%dx%dx%d",
                      row.resource_view_details->resource_desc.texture.width,
                      row.resource_view_details->resource_desc.texture.height,
                      row.resource_view_details->resource_desc.texture.depth_or_layers);
        } else {
          ImGui::Text("%dx%d",
                      row.resource_view_details->resource_desc.texture.width,
                      row.resource_view_details->resource_desc.texture.height);
        }
      }
    };

    const auto render_rtv_blend_row = [&](const SnapshotRow& row) {
      SettingSelection search = {.resource_handle = row.resource_view_details->resource.handle};
      auto& selection = GetSelection(search);

      const auto& blend_desc = row.draw_details->blend_desc.value();

      const auto& alpha_to_coverage_enable = blend_desc.alpha_to_coverage_enable;
      const auto& blend_enable = blend_desc.blend_enable[row.rtv_index];
      const auto& logic_op_enable = blend_desc.logic_op_enable[row.rtv_index];
      const auto& source_color_blend_factor = blend_desc.source_color_blend_factor[row.rtv_index];
      const auto& dest_color_blend_factor = blend_desc.dest_color_blend_factor[row.rtv_index];
      const auto& color_blend_op = blend_desc.color_blend_op[row.rtv_index];
      const auto& source_alpha_blend_factor = blend_desc.source_alpha_blend_factor[row.rtv_index];
      const auto& dest_alpha_blend_factor = blend_desc.dest_alpha_blend_factor[row.rtv_index];
      const auto& alpha_blend_op = blend_desc.alpha_blend_op[row.rtv_index];
      const auto& blend_constant = blend_desc.blend_constant;
      const auto& logic_op = blend_desc.logic_op[row.rtv_index];
      const auto& render_target_write_mask = blend_desc.render_target_write_mask[row.rtv_index];

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                            | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                            | selection.GetTreeNodeFlags();
        ImGui::PushID(row.id_seed);
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

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
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
        if (ImGui::IsItemHovered()) {
          std::stringstream tooltip;
          tooltip << "Matched Label: " << details << "\n";
          tooltip << "BlendEnable: " << (blend_enable ? "true" : "false") << "\n";
          tooltip << "ColorOp: " << color_blend_op << "\n";
          tooltip << "SrcColor: " << source_color_blend_factor << "\n";
          tooltip << "DstColor: " << dest_color_blend_factor << "\n";
          tooltip << "AlphaOp: " << alpha_blend_op << "\n";
          tooltip << "SrcAlpha: " << source_alpha_blend_factor << "\n";
          tooltip << "DstAlpha: " << dest_alpha_blend_factor << "\n";
          tooltip << "WriteMask: 0x" << std::hex << static_cast<uint32_t>(render_target_write_mask) << std::dec << "\n";
          tooltip << "AlphaToCoverage: " << (alpha_to_coverage_enable ? "true" : "false") << "\n";
          tooltip << "LogicOpEnable: " << (logic_op_enable ? "true" : "false") << "\n";
          tooltip << "LogicOp: " << logic_op << "\n";
          tooltip << "BlendConst: ("
                  << blend_constant[0] << ", "
                  << blend_constant[1] << ", "
                  << blend_constant[2] << ", "
                  << blend_constant[3] << ")";
          ImGui::SetItemTooltip("%s", tooltip.str().c_str());
        }
      }
    };

    const auto render_rtv_write_mask_row = [&](const SnapshotRow& row) {
      const auto& blend_desc = row.draw_details->blend_desc.value();
      SettingSelection search = {.resource_handle = row.resource_view_details->resource.handle};
      auto& selection = GetSelection(search);
      const auto& render_target_write_mask = blend_desc.render_target_write_mask[row.rtv_index];

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                            | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                            | selection.GetTreeNodeFlags();
        ImGui::PushID(row.id_seed);
        ImGui::TreeNodeEx("", bullet_flags, "Write Mask");
        ImGui::PopID();
        if (ImGui::IsItemClicked()) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
      }

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
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
    };

    const auto render_copy_source_row = [&](const SnapshotRow& row) {
      SettingSelection search = {.resource_handle = row.resource.handle};
      auto& selection = GetSelection(search);

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                            | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                            | selection.GetTreeNodeFlags();
        ImGui::PushID(row.id_seed);
        ImGui::TreeNodeEx("", bullet_flags, "Source");
        ImGui::PopID();
        if (ImGui::IsItemClicked()) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
      }
      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.resource.handle);
      }
      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        auto* info = renodx::utils::resource::GetResourceInfo(row.resource);
        if (info != nullptr) {
          std::stringstream s;
          if (info->desc.type == reshade::api::resource_type::buffer) {
            s << "Buffer (" << info->desc.buffer.size << " bytes)";
          } else {
            s << info->desc.texture.format;
          }
          if (info->is_swap_chain) {
            ImGui::TextColored(ImVec4(0.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
          } else if (info->upgraded) {
            ImGui::TextColored(ImVec4(0.f, 1.f, 1.f, 1.f), "%s", s.str().c_str());
          } else if (info->clone.handle != 0u) {
            ImGui::TextColored(ImVec4(1.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
          } else {
            ImGui::TextUnformatted(s.str().c_str());
          }
        }
      }
    };

    const auto render_copy_destination_row = [&](const SnapshotRow& row) {
      SettingSelection search = {.resource_handle = row.resource.handle};
      auto& selection = GetSelection(search);

      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_TYPE)) {
        auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf
                            | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                            | selection.GetTreeNodeFlags();
        ImGui::PushID(row.id_seed);
        ImGui::TreeNodeEx("", bullet_flags, "Destination");
        ImGui::PopID();
        if (ImGui::IsItemClicked()) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
      }
      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_REF)) {
        ImGui::Text("0x%016llX", row.resource.handle);
      }
      if (ImGui::TableSetColumnIndex(CAPTURE_PANE_COLUMN_INFO)) {
        auto* info = renodx::utils::resource::GetResourceInfo(row.resource);
        if (info != nullptr) {
          std::stringstream s;
          if (info->desc.type == reshade::api::resource_type::buffer) {
            s << "Buffer (" << info->desc.buffer.size << " bytes)";
          } else {
            s << info->desc.texture.format;
          }
          if (info->is_swap_chain) {
            ImGui::TextColored(ImVec4(0.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
          } else if (info->upgraded) {
            ImGui::TextColored(ImVec4(0.f, 1.f, 1.f, 1.f), "%s", s.str().c_str());
          } else if (info->clone.handle != 0u) {
            ImGui::TextColored(ImVec4(1.f, 1.f, 0.f, 1.f), "%s", s.str().c_str());
          } else {
            ImGui::TextUnformatted(s.str().c_str());
          }
        }
      }
    };

    bool snapshot_layout_dirty = false;
    std::vector<int> collapsed_tree_rows;
    const auto render_capture_pane_rows = [&](int display_start, int display_end) -> int {
      int rendered_row_count = 0;
      std::vector<int> current_tree_stack;
      std::vector<bool> current_tree_stack_manual;

      const auto pop_snapshot_tree = [&](bool manual_push) {
        if (manual_push) {
          ImGui::Unindent();
          ImGui::PopID();
        } else {
          ImGui::TreePop();
        }
      };

      const auto push_snapshot_tree = [&](const SnapshotRow& row) {
        ImGui::PushID(row.id_seed);
        ImGui::Indent();
      };

      const auto get_ancestor_chain = [&](int row_model_index) {
        std::vector<int> chain;
        int parent_row_index = data->snapshot_rows[static_cast<size_t>(row_model_index)].parent_row_index;
        while (parent_row_index >= 0) {
          chain.push_back(parent_row_index);
          parent_row_index = data->snapshot_rows[static_cast<size_t>(parent_row_index)].parent_row_index;
        }
        std::reverse(chain.begin(), chain.end());
        return chain;
      };

      const auto has_collapsed_ancestor = [&](const std::vector<int>& chain) {
        for (const auto ancestor_row_index : chain) {
          if (std::ranges::find(collapsed_tree_rows, ancestor_row_index) != collapsed_tree_rows.end()) {
            return true;
          }
        }
        return false;
      };

      const auto sync_snapshot_tree_stack = [&](const std::vector<int>& target_chain) {
        size_t common_prefix = 0u;
        while (common_prefix < current_tree_stack.size()
               && common_prefix < target_chain.size()
               && current_tree_stack[common_prefix] == target_chain[common_prefix]) {
          ++common_prefix;
        }
        while (current_tree_stack.size() > common_prefix) {
          pop_snapshot_tree(current_tree_stack_manual.back());
          current_tree_stack.pop_back();
          current_tree_stack_manual.pop_back();
        }
        for (size_t i = common_prefix; i < target_chain.size(); ++i) {
          const auto& ancestor_row = data->snapshot_rows[static_cast<size_t>(target_chain[i])];
          push_snapshot_tree(ancestor_row);
          current_tree_stack.push_back(target_chain[i]);
          current_tree_stack_manual.push_back(true);
        }
      };

      for (int row_model_index = display_start; row_model_index < display_end; ++row_model_index) {
        const auto& row = data->snapshot_rows[static_cast<size_t>(row_model_index)];
        const auto ancestor_chain = get_ancestor_chain(row_model_index);
        if (has_collapsed_ancestor(ancestor_chain)) {
          continue;
        }

        sync_snapshot_tree_stack(ancestor_chain);
        ImGui::TableNextRow(ImGuiTableRowFlags_None, snapshot_row_height);
        ++rendered_row_count;

        bool next_tree_open = false;

        switch (row.kind) {
          case SnapshotRow::Kind::DRAW: {
            render_draw_row(row, next_tree_open);
            break;
          }
          case SnapshotRow::Kind::CONSTANT_BUFFER: {
            render_constant_buffer_row(row);
            break;
          }
          case SnapshotRow::Kind::SHADER: {
            render_shader_row(row);
            break;
          }
          case SnapshotRow::Kind::SRV: {
            render_srv_row(row, next_tree_open);
            break;
          }
          case SnapshotRow::Kind::SRV_RESOURCE: {
            render_srv_resource_row(row);
            break;
          }
          case SnapshotRow::Kind::SRV_DIMENSIONS: {
            render_srv_dimensions_row(row);
            break;
          }
          case SnapshotRow::Kind::UAV: {
            render_uav_row(row, next_tree_open);
            break;
          }
          case SnapshotRow::Kind::UAV_RESOURCE: {
            render_uav_resource_row(row);
            break;
          }
          case SnapshotRow::Kind::UAV_DIMENSIONS: {
            render_uav_dimensions_row(row);
            break;
          }
          case SnapshotRow::Kind::RTV: {
            render_rtv_row(row, next_tree_open);
            break;
          }
          case SnapshotRow::Kind::RTV_RESOURCE: {
            render_rtv_resource_row(row);
            break;
          }
          case SnapshotRow::Kind::RTV_DIMENSIONS: {
            render_rtv_dimensions_row(row);
            break;
          }
          case SnapshotRow::Kind::RTV_BLEND: {
            render_rtv_blend_row(row);
            break;
          }

          case SnapshotRow::Kind::RTV_WRITE_MASK: {
            render_rtv_write_mask_row(row);
            break;
          }
          case SnapshotRow::Kind::COPY_SOURCE: {
            render_copy_source_row(row);
            break;
          }
          case SnapshotRow::Kind::COPY_DESTINATION: {
            render_copy_destination_row(row);
            break;
          }
        }

        if (row.is_tree) {
          if (next_tree_open != row.cached_open) {
            snapshot_layout_dirty = true;
            if (!next_tree_open) {
              collapsed_tree_rows.push_back(row_model_index);
            }
          }
          if (next_tree_open) {
            current_tree_stack.push_back(row_model_index);
            current_tree_stack_manual.push_back(false);
          }
        }
      }

      while (!current_tree_stack.empty()) {
        pop_snapshot_tree(current_tree_stack_manual.back());
        current_tree_stack.pop_back();
        current_tree_stack_manual.pop_back();
      }

      return rendered_row_count;
    };
    const auto rebuild_snapshot_rows = [&]() {
      const auto get_tree_node_open_state = [&](int id_seed, bool default_open) {
        ImGui::PushID(id_seed);
        const ImGuiID state_id = ImGui::GetID("");
        ImGui::PopID();
        return ImGui::GetStateStorage()->GetInt(state_id, default_open ? 1 : 0) != 0;
      };

      data->snapshot_rows.clear();
      data->snapshot_rows.reserve(data->draw_details_list.size() * 8u);

      int row_index = 0x2000;
      const auto append_row = [&](SnapshotRow row) {
        data->snapshot_rows.push_back(row);
        return static_cast<int>(data->snapshot_rows.size()) - 1;
      };
      const auto append_shader_rows = [&](const DrawDetails& draw_details, int draw_index, int draw_row_index, int& row_index) {
        for (const auto& pipeline_bind : draw_details.pipeline_binds) {
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

            ++row_index;
            append_row({
                .kind = SnapshotRow::Kind::SHADER,
                .depth = 1,
                .parent_row_index = draw_row_index,
                .draw_index = draw_index,
                .id_seed = row_index,
                .shader_hash = shader_hash,
                .draw_details = &draw_details,
                .pipeline_bind = &pipeline_bind,
            });
          }
        }
      };

      for (int draw_index = 0; draw_index < static_cast<int>(data->draw_details_list.size()); ++draw_index) {
        const auto& draw_details = data->draw_details_list[static_cast<size_t>(draw_index)];
        const bool draw_node_open = get_tree_node_open_state(draw_index, snapshot_pane_expand_all_nodes);
        const int draw_row_index = append_row({
            .kind = SnapshotRow::Kind::DRAW,
            .depth = 0,
            .parent_row_index = -1,
            .draw_index = draw_index,
            .id_seed = draw_index,
            .is_tree = true,
            .default_open = snapshot_pane_expand_all_nodes,
            .cached_open = draw_node_open,
            .draw_details = &draw_details,
        });

        if (draw_node_open) {
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
            append_row({
                .kind = SnapshotRow::Kind::CONSTANT_BUFFER,
                .depth = 1,
                .parent_row_index = draw_row_index,
                .draw_index = draw_index,
                .id_seed = row_index,
                .slot = slot,
                .space = space,
                .draw_details = &draw_details,
                .buffer_range = &buffer_range,
            });
          }

          append_shader_rows(draw_details, draw_index, draw_row_index, row_index);

          for (const auto& [slot_space, resource_view_details] : draw_details.srv_binds) {
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
            const int srv_id_seed = row_index;
            const bool srv_node_open = get_tree_node_open_state(srv_id_seed, true);
            const int srv_row_index = append_row({
                .kind = SnapshotRow::Kind::SRV,
                .depth = 1,
                .parent_row_index = draw_row_index,
                .draw_index = draw_index,
                .id_seed = srv_id_seed,
                .is_tree = true,
                .default_open = true,
                .cached_open = srv_node_open,
                .slot = slot,
                .space = space,
                .draw_details = &draw_details,
                .resource_view_details = &resource_view_details,
            });

            ++row_index;
            if (srv_node_open) {
              append_row({
                  .kind = SnapshotRow::Kind::SRV_RESOURCE,
                  .depth = 2,
                  .parent_row_index = srv_row_index,
                  .draw_index = draw_index,
                  .id_seed = row_index,
                  .draw_details = &draw_details,
                  .resource_view_details = &resource_view_details,
              });

              if (resource_view_details.resource_desc.texture.format != reshade::api::format::unknown) {
                ++row_index;
                append_row({
                    .kind = SnapshotRow::Kind::SRV_DIMENSIONS,
                    .depth = 2,
                    .parent_row_index = srv_row_index,
                    .draw_index = draw_index,
                    .id_seed = row_index,
                    .draw_details = &draw_details,
                    .resource_view_details = &resource_view_details,
                });
              }
            }
          }

          for (const auto& [slot_space, resource_view_details] : draw_details.uav_binds) {
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
            const int uav_id_seed = row_index;
            const bool uav_node_open = get_tree_node_open_state(uav_id_seed, true);
            const int uav_row_index = append_row({
                .kind = SnapshotRow::Kind::UAV,
                .depth = 1,
                .parent_row_index = draw_row_index,
                .draw_index = draw_index,
                .id_seed = uav_id_seed,
                .is_tree = true,
                .default_open = true,
                .cached_open = uav_node_open,
                .slot = slot,
                .space = space,
                .draw_details = &draw_details,
                .resource_view_details = &resource_view_details,
            });

            ++row_index;
            if (uav_node_open) {
              append_row({
                  .kind = SnapshotRow::Kind::UAV_RESOURCE,
                  .depth = 2,
                  .parent_row_index = uav_row_index,
                  .draw_index = draw_index,
                  .id_seed = row_index,
                  .draw_details = &draw_details,
                  .resource_view_details = &resource_view_details,
              });

              if (resource_view_details.resource_desc.texture.format != reshade::api::format::unknown) {
                ++row_index;
                append_row({
                    .kind = SnapshotRow::Kind::UAV_DIMENSIONS,
                    .depth = 2,
                    .parent_row_index = uav_row_index,
                    .draw_index = draw_index,
                    .id_seed = row_index,
                    .draw_details = &draw_details,
                    .resource_view_details = &resource_view_details,
                });
              }
            }
          }
          for (const auto& [rtv_index, render_target] : draw_details.render_targets) {
            ++row_index;
            const int rtv_id_seed = row_index;
            const bool rtv_node_open = get_tree_node_open_state(rtv_id_seed, true);
            const int rtv_row_index = append_row({
                .kind = SnapshotRow::Kind::RTV,
                .depth = 1,
                .parent_row_index = draw_row_index,
                .draw_index = draw_index,
                .id_seed = rtv_id_seed,
                .is_tree = true,
                .default_open = true,
                .cached_open = rtv_node_open,
                .rtv_index = rtv_index,
                .draw_details = &draw_details,
                .resource_view_details = &render_target,
            });

            ++row_index;
            if (rtv_node_open) {
              append_row({
                  .kind = SnapshotRow::Kind::RTV_RESOURCE,
                  .depth = 2,
                  .parent_row_index = rtv_row_index,
                  .draw_index = draw_index,
                  .id_seed = row_index,
                  .rtv_index = rtv_index,
                  .draw_details = &draw_details,
                  .resource_view_details = &render_target,
              });

              if (render_target.resource_desc.texture.format != reshade::api::format::unknown) {
                ++row_index;
                append_row({
                    .kind = SnapshotRow::Kind::RTV_DIMENSIONS,
                    .depth = 2,
                    .parent_row_index = rtv_row_index,
                    .draw_index = draw_index,
                    .id_seed = row_index,
                    .rtv_index = rtv_index,
                    .draw_details = &draw_details,
                    .resource_view_details = &render_target,
                });
              }

              if (draw_details.blend_desc.has_value()) {
                const auto& blend_desc = draw_details.blend_desc.value();
                if (blend_desc.blend_enable[rtv_index]) {
                  ++row_index;
                  append_row({
                      .kind = SnapshotRow::Kind::RTV_BLEND,
                      .depth = 2,
                      .parent_row_index = rtv_row_index,
                      .draw_index = draw_index,
                      .id_seed = row_index,
                      .rtv_index = rtv_index,
                      .draw_details = &draw_details,
                      .resource_view_details = &render_target,
                  });
                }

                if (blend_desc.render_target_write_mask[rtv_index] != 0xF) {
                  ++row_index;
                  append_row({
                      .kind = SnapshotRow::Kind::RTV_WRITE_MASK,
                      .depth = 2,
                      .parent_row_index = rtv_row_index,
                      .draw_index = draw_index,
                      .id_seed = row_index,
                      .rtv_index = rtv_index,
                      .draw_details = &draw_details,
                      .resource_view_details = &render_target,
                  });
                }
              }
            }
          }

          if (draw_details.copy_source.handle != 0u) {
            ++row_index;
            append_row({
                .kind = SnapshotRow::Kind::COPY_SOURCE,
                .depth = 1,
                .parent_row_index = draw_row_index,
                .draw_index = draw_index,
                .id_seed = row_index,
                .draw_details = &draw_details,
                .resource = draw_details.copy_source,
            });
          }

          if (draw_details.copy_destination.handle != 0u) {
            ++row_index;
            append_row({
                .kind = SnapshotRow::Kind::COPY_DESTINATION,
                .depth = 1,
                .parent_row_index = draw_row_index,
                .draw_index = draw_index,
                .id_seed = row_index,
                .draw_details = &draw_details,
                .resource = draw_details.copy_destination,
            });
          }
        }

        ++row_index;
      }

      data->snapshot_row_layout_key = snapshot_row_layout_key;
      data->snapshot_rows_valid = true;
    };
    if (!data->snapshot_rows_valid || data->snapshot_row_layout_key != snapshot_row_layout_key) {
      rebuild_snapshot_rows();
    }
    int rendered_row_count = 0;
    if (pending_draw_index_focus != -1 || data->snapshot_rows.empty()) {
      rendered_row_count = render_capture_pane_rows(
          0,
          static_cast<int>(data->snapshot_rows.size()));
    } else {
      ImGuiListClipper clipper;
      clipper.Begin(static_cast<int>(data->snapshot_rows.size()), snapshot_row_height);
      while (clipper.Step()) {
        rendered_row_count += render_capture_pane_rows(
            clipper.DisplayStart,
            clipper.DisplayEnd);
      }
    }

    if (rendered_row_count == 0 && !data->snapshot_rows.empty()) {
      rendered_row_count = render_capture_pane_rows(
          0,
          static_cast<int>(data->snapshot_rows.size()));
    }

    if (snapshot_layout_dirty) {
      data->snapshot_rows_valid = false;
    }

    ImGui::EndTable();
  }  // namespace
}

// Creates a selectable with the given label that jumps to the specified snapshot index
inline void CreateDrawIndexLink(const std::string& label, int draw_index, const ImVec4* color = nullptr) {
  if (color != nullptr) {
    ImGui::PushStyleColor(ImGuiCol_Text, *color);
  }
  if (ImGui::TextLink(label.c_str())) {
    setting_nav_item = 0;  // Snapshot is the first nav item
    pending_draw_index_focus = draw_index;
  }
  if (color != nullptr) {
    ImGui::PopStyleColor();
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

void RenderResourcesPane(reshade::api::device* device, DeviceData* data) {
  if (device == nullptr) return;
  const std::unordered_map<uint64_t, SnapshotResourceUsage>* usage_by_resource = nullptr;
  if (data != nullptr) {
    usage_by_resource = &data->resource_usage_by_handle;
  }

  const bool api_blocked =
      device->get_api() == reshade::api::device_api::d3d12
      || device->get_api() == reshade::api::device_api::vulkan;
  if (api_blocked) {
    ImGui::TextDisabled("Enable/Disable is blocked for this API (DX12/Vulkan).");
  }

  struct ResourceRow {
    reshade::api::resource resource = {0u};
    reshade::api::resource_desc desc;
    bool enabled = false;
    bool has_clone = false;
    bool is_swapchain = false;
    bool upgraded = false;
    int snapshot_index = -1;
    bool seen_srv = false;
    bool seen_uav = false;
    bool seen_rtv = false;
    bool can_enable = false;
    std::string blocked_reason;
    std::string reflection;
  };

  std::vector<ResourceRow> rows;
  renodx::utils::resource::store->resource_infos.for_each([&](const auto& pair) {
    const auto& info = pair.second;
    if (info.device != device) return;
    if (info.destroyed || info.is_clone) return;
    if (info.desc.type == reshade::api::resource_type::unknown
        || info.desc.type == reshade::api::resource_type::buffer) {
      return;
    }

    const bool managed = IsDevkitCloneManagedResource(&info);
    const bool enabled = managed && info.clone_enabled;
    const bool has_clone = info.clone.handle != 0u;
    const SnapshotResourceUsage* usage = nullptr;
    if (usage_by_resource != nullptr) {
      if (const auto usage_it = usage_by_resource->find(info.resource.handle);
          usage_it != usage_by_resource->end()) {
        usage = &usage_it->second;
      }
    }
    const bool seen_srv = usage != nullptr && usage->seen_srv;
    const bool seen_uav = usage != nullptr && usage->seen_uav;
    const bool seen_rtv = usage != nullptr && usage->seen_rtv;
    const int snapshot_index = usage != nullptr ? usage->first_snapshot_index : -1;
    const bool is_snapshot_resource = seen_srv || seen_uav || seen_rtv;
    const bool is_cloned_resource = has_clone || enabled;

    // Only show resources that are part of the captured snapshot activity,
    // or resources that are currently cloned/clone-enabled.
    if (!is_snapshot_resource && !is_cloned_resource) return;

    ResourceRow row = {
        .resource = info.resource,
        .desc = info.desc,
        .enabled = enabled,
        .has_clone = has_clone,
        .is_swapchain = info.is_swap_chain,
        .upgraded = info.upgraded,
        .snapshot_index = snapshot_index,
        .seen_srv = seen_srv,
        .seen_uav = seen_uav,
        .seen_rtv = seen_rtv,
    };

    if (auto reflection = renodx::utils::trace::GetDebugName(device->get_api(), info.resource);
        reflection.has_value()) {
      row.reflection = reflection.value();
    }

    if (const auto* reason = GetResourceCloneToggleBlockedReason(device, &info, true);
        reason == nullptr) {
      row.can_enable = true;
    } else {
      row.can_enable = false;
      row.blocked_reason = reason;
    }

    rows.push_back(std::move(row));
  });

  std::ranges::sort(rows, [](const auto& lhs, const auto& rhs) {
    const bool lhs_has_snapshot = lhs.snapshot_index >= 0;
    const bool rhs_has_snapshot = rhs.snapshot_index >= 0;
    if (lhs_has_snapshot != rhs_has_snapshot) return lhs_has_snapshot > rhs_has_snapshot;
    if (lhs.snapshot_index != rhs.snapshot_index) return lhs.snapshot_index < rhs.snapshot_index;
    return lhs.resource.handle < rhs.resource.handle;
  });

  const auto active_count = std::ranges::count_if(rows, [](const auto& row) {
    return row.enabled;
  });

  ImGui::Text(
      "Active: %zu  Visible: %zu",
      active_count,
      rows.size());

  if (rows.empty()) {
    ImGui::TextDisabled("No snapshot or cloned resources.");
    return;
  }

  if (!ImGui::BeginTable(
          "##ResourceHotSwapTable",
          7,
          ImGuiTableFlags_BordersInner | ImGuiTableFlags_BordersV | ImGuiTableFlags_BordersOuterH
              | ImGuiTableFlags_Resizable | ImGuiTableFlags_NoBordersInBody | ImGuiTableFlags_ScrollY,
          ImVec2(-4, -4))) {
    return;
  }

  const auto char_width = ImGui::CalcTextSize("0").x;
  ImGui::TableSetupColumn("Resource", ImGuiTableColumnFlags_WidthFixed, char_width * 18.f);
  ImGui::TableSetupColumn("Info", ImGuiTableColumnFlags_WidthFixed, char_width * 18.f);
  ImGui::TableSetupColumn("Dimensions", ImGuiTableColumnFlags_WidthFixed, char_width * 16.f);
  ImGui::TableSetupColumn("Seen", ImGuiTableColumnFlags_WidthFixed, char_width * 10.f);
  ImGui::TableSetupColumn("Snapshot", ImGuiTableColumnFlags_WidthFixed, char_width * 8.f);
  ImGui::TableSetupColumn("Reflection", ImGuiTableColumnFlags_WidthStretch, -1.f);
  ImGui::TableSetupColumn("Actions", ImGuiTableColumnFlags_WidthFixed, char_width * 20.f);
  ImGui::TableSetupScrollFreeze(0, 1);
  ImGui::TableHeadersRow();

  ImGuiListClipper clipper;
  clipper.Begin(static_cast<int>(rows.size()));
  while (clipper.Step()) {
    for (int row_index = clipper.DisplayStart; row_index < clipper.DisplayEnd; ++row_index) {
      const auto& row = rows[static_cast<size_t>(row_index)];
      ImGui::PushID(static_cast<int>(row.resource.handle));
      ImGui::TableNextRow();
      SettingSelection search = {.resource_handle = row.resource.handle};
      auto& selection = GetSelection(search);

      if (ImGui::TableSetColumnIndex(0)) {
        const auto selectable_height = ImGui::GetTextLineHeightWithSpacing() + 2.f;
        ImGui::PushStyleVar(ImGuiStyleVar_SelectableTextAlign, ImVec2(0.f, 0.5f));
        if (ImGui::Selectable(
                std::format("0x{:016X}", row.resource.handle).c_str(),
                selection.is_current,
                ImGuiSelectableFlags_SpanAllColumns | ImGuiSelectableFlags_AllowOverlap,
                ImVec2(0.f, selectable_height))) {
          MakeSelectionCurrent(selection);
          ImGui::SetItemDefaultFocus();
        }
        ImGui::PopStyleVar();
      }
      if (ImGui::TableSetColumnIndex(1)) {
        std::stringstream s;
        s << row.desc.texture.format;
        const ImVec4 swapchain_color = ImVec4(0.f, 1.f, 0.f, 1.f);
        const ImVec4 upgraded_color = ImVec4(0.f, 1.f, 1.f, 1.f);
        const ImVec4 cloned_color = ImVec4(1.f, 1.f, 0.f, 1.f);
        if (row.is_swapchain) {
          ImGui::TextColored(swapchain_color, "%s", s.str().c_str());
        } else if (row.upgraded) {
          ImGui::TextColored(upgraded_color, "%s", s.str().c_str());
        } else if (row.enabled) {
          ImGui::TextColored(cloned_color, "%s", s.str().c_str());
        } else {
          ImGui::TextUnformatted(s.str().c_str());
        }
      }
      if (ImGui::TableSetColumnIndex(2)) {
        if (row.desc.type == reshade::api::resource_type::texture_3d) {
          ImGui::Text("%dx%dx%d",
                      row.desc.texture.width,
                      row.desc.texture.height,
                      row.desc.texture.depth_or_layers);
        } else {
          ImGui::Text("%dx%d", row.desc.texture.width, row.desc.texture.height);
        }
      }
      if (ImGui::TableSetColumnIndex(3)) {
        std::stringstream seen;
        if (row.seen_rtv) seen << "RTV ";
        if (row.seen_srv) seen << "SRV ";
        if (row.seen_uav) seen << "UAV";
        if (seen.str().empty()) {
          ImGui::TextDisabled("-");
        } else {
          ImGui::TextUnformatted(seen.str().c_str());
        }
      }
      if (ImGui::TableSetColumnIndex(4)) {
        if (row.snapshot_index >= 0) {
          const ImVec4 swapchain_color = ImVec4(0.f, 1.f, 0.f, 1.f);
          const ImVec4 upgraded_color = ImVec4(0.f, 1.f, 1.f, 1.f);
          const ImVec4 cloned_color = ImVec4(1.f, 1.f, 0.f, 1.f);
          const ImVec4* link_color = nullptr;
          if (row.is_swapchain) {
            link_color = &swapchain_color;
          } else if (row.upgraded) {
            link_color = &upgraded_color;
          } else if (row.enabled) {
            link_color = &cloned_color;
          }
          CreateDrawIndexLink(std::format("{:03}", row.snapshot_index), row.snapshot_index, link_color);
        } else {
          ImGui::TextDisabled("-");
        }
      }
      if (ImGui::TableSetColumnIndex(5)) {
        if (!row.reflection.empty()) {
          ImGui::TextUnformatted(row.reflection.c_str());
        }
      }
      if (ImGui::TableSetColumnIndex(6)) {
        const bool can_toggle_clone = row.enabled || (!api_blocked && row.can_enable);
        auto color_vec4 = ImGui::GetStyleColorVec4(ImGuiCol_Button);
        if (!row.enabled) {
          color_vec4 = {0.5f, 0.5f, 0.5f, color_vec4.w};
        }
        ImGui::BeginDisabled(!can_toggle_clone);
        ImGui::PushStyleColor(ImGuiCol_Button, color_vec4);
        if (ImGui::Button("Clone")) {
          (void)SetResourceCloneHotSwapState(device, row.resource, !row.enabled);
        }
        ImGui::PopStyleColor();
        ImGui::EndDisabled();
        if (!can_toggle_clone && ImGui::IsItemHovered()) {
          if (api_blocked) {
            ImGui::SetItemTooltip("Enable/Disable is blocked for this API (DX12/Vulkan).");
          } else if (!row.blocked_reason.empty()) {
            ImGui::SetItemTooltip("%s", row.blocked_reason.c_str());
          }
        }
      }

      ImGui::PopID();
    }
  }

  ImGui::EndTable();
}

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

[[nodiscard]] bool BeginSettingsSection(const char* label, bool default_open = true) {
  ImGuiTreeNodeFlags flags = ImGuiTreeNodeFlags_SpanFullWidth;
  if (default_open) {
    flags |= ImGuiTreeNodeFlags_DefaultOpen;
  }

  const bool open = ImGui::TreeNodeEx(label, flags);
  if (open) {
    ImGui::Unindent();
  }
  return open;
}

void EndSettingsSection() {
  ImGui::Indent();
  ImGui::TreePop();
}

struct SettingsDeviceOption {
  uint32_t index = 0u;
  DeviceData* device_data = nullptr;
  std::string label;
};

[[nodiscard]] DeviceData* RenderSettingsPane(
    reshade::api::device* device,
    DeviceData* data,
    const std::vector<SettingsDeviceOption>& device_options,
    uint32_t selected_device_index) {
  DeviceData* pending_selected_device_data = nullptr;
  if (BeginSettingsSection("Snapshot")) {
    DrawSettingBoolCheckbox("Trace With Snapshot", "SnapshotTraceWithSnapshot", &snapshot_trace_with_snapshot);
    DrawSettingBoolCheckbox("Show Vertex Shaders", "SnapshotPaneShowVertexShaders", &snapshot_pane_show_vertex_shaders);
    DrawSettingBoolCheckbox("Show Pixel Shaders", "SnapshotPaneShowPixelShaders", &snapshot_pane_show_pixel_shaders);
    DrawSettingBoolCheckbox("Show Compute Shaders", "SnapshotPaneShowComputeShaders", &snapshot_pane_show_compute_shaders);
    DrawSettingBoolCheckbox("Expand All Nodes", "SnapshotPaneExpandAllNodes", &snapshot_pane_expand_all_nodes);
    DrawSettingBoolCheckbox("Filter Resources by Shader Use", "SnapshotPaneFilterResourcesByShaderUse", &snapshot_pane_filter_resources_by_shader_use);
    DrawSettingBoolCheckbox("Show Blends", "SnapshotPaneShowBlends", &snapshot_pane_show_blends);
    static std::string current_item;
    bool found_current_item = false;
    for (const auto& option : device_options) {
      if (selected_device_index == option.index) {
        current_item = option.label;
        found_current_item = true;
        break;
      }
    }
    if (!found_current_item) {
      current_item.clear();
    }

    if (!current_item.empty() && ImGui::BeginCombo("Select Device", current_item.c_str())) {
      for (const auto& option : device_options) {
        bool is_selected = (current_item == option.label);
        if (ImGui::Selectable(option.label.c_str(), is_selected)) {
          current_item = option.label;
          device_data_index = option.index;
          pending_selected_device_data = option.device_data;
        }
        if (is_selected) {
          ImGui::SetItemDefaultFocus();
        }
      }
      ImGui::EndCombo();
    }

    EndSettingsSection();
  }

  if (BeginSettingsSection("Shaders")) {
    auto tools_path_status = devkit_tools_path::GetStatus();
    char tools_temp[256] = "";
    std::snprintf(tools_temp, sizeof(tools_temp), "%s", tools_path_status.configured_path.string().c_str());

    if (ImGui::InputText("Tools Path", tools_temp, 256)) {
      auto temp_string = devkit_tools_path::TrimTrailingWhitespace(tools_temp);
      renodx::utils::shader::compiler::directx::SetToolsPath(temp_string);
      reshade::set_config_value(nullptr, "renodx-dev", "ToolsPath", temp_string.c_str());
      tools_path_status = devkit_tools_path::GetStatus();
    }

    char temp[256] = "";
    std::snprintf(temp, sizeof(temp), "%s", renodx::utils::shader::compiler::watcher::GetLivePath().c_str());

    if (ImGui::InputText("Live Path", temp, 256)) {
      auto temp_string = devkit_tools_path::TrimTrailingWhitespace(temp);
      renodx::utils::shader::compiler::watcher::SetLivePath(temp_string);
      reshade::set_config_value(nullptr, "renodx-dev", "LivePath", temp_string.c_str());
    }

    DrawSettingBoolCheckbox("Show Vertex Shaders", "ShadersPaneShowVertexShaders", &shaders_pane_show_vertex_shaders);
    DrawSettingBoolCheckbox("Show Pixel Shaders", "ShadersPaneShowPixelShaders", &shaders_pane_show_pixel_shaders);
    DrawSettingBoolCheckbox("Show Compute Shaders", "ShadersPaneShowComputeShaders", &shaders_pane_show_compute_shaders);

    EndSettingsSection();
  }

  if (BeginSettingsSection("Trace")) {
    DrawSettingBoolCheckbox("Trace All", "TraceAll", &renodx::utils::trace::trace_all);
    DrawSettingBoolCheckbox("Trace Pipeline Creation", "TracePipelineCreation", &renodx::utils::trace::trace_pipeline_creation);
    DrawSettingBoolCheckbox("Trace Descriptor Tables", "TraceDescriptorTables", &renodx::utils::descriptor::trace_descriptor_tables);
    DrawSettingBoolCheckbox("Trace Constant Buffers", "TraceConstantBuffers", &renodx::utils::constants::capture_constant_buffers);
    DrawSettingUint32Textbox("Trace Initial Frame Count", "TraceInitialFrameCount", &renodx::utils::trace::trace_initial_frame_count);

    EndSettingsSection();
  }

  if (BeginSettingsSection("Other")) {
    DrawSettingDecimalTextbox("FPS Limit", "FPSLimit", &renodx::utils::swapchain::fps_limit);

    EndSettingsSection();
  }

  if (BeginSettingsSection("Swapchain Proxy")) {
    bool changed = false;
    const bool is_d3d9_device = device != nullptr && device->get_api() == reshade::api::device_api::d3d9;
    const bool is_d3d9_ex = !is_d3d9_device || (data != nullptr && data->is_d3d9_ex);
    const bool dx9_proxy_controls_blocked = is_d3d9_device && !is_d3d9_ex;

    ImGui::SeparatorText("Compatibility");
    {
      bool force_dx9_ex = setting_device_proxy_force_dx9_ex;
      if (ImGui::Checkbox("Force DX9Ex (boot)", &force_dx9_ex)) {
        setting_device_proxy_force_dx9_ex = force_dx9_ex;
        reshade::set_config_value(
            nullptr,
            "renodx-dev",
            "SwapChainDeviceProxyForceDX9Ex",
            setting_device_proxy_force_dx9_ex);
        if (setting_device_proxy_force_dx9_ex) {
          reshade::log::message(
              reshade::log::level::info,
              "devkit::RenderDeviceProxySettings(Force DX9Ex enabled; restart required)");
        }
      }
      bool force_disable_flip = setting_device_proxy_force_disable_flip;
      if (ImGui::Checkbox("Force Disable Flip (boot)", &force_disable_flip)) {
        setting_device_proxy_force_disable_flip = force_disable_flip;
        reshade::set_config_value(
            nullptr,
            "renodx-dev",
            "SwapChainDeviceProxyForceDisableFlip",
            setting_device_proxy_force_disable_flip);
        reshade::log::message(
            reshade::log::level::info,
            setting_device_proxy_force_disable_flip
                ? "devkit::RenderDeviceProxySettings(Force Disable Flip enabled; restart required)"
                : "devkit::RenderDeviceProxySettings(Force Disable Flip disabled; restart required)");
      }
      if (is_d3d9_device) {
        ImGui::Text("D3D9Ex: %s", is_d3d9_ex ? "Yes" : "No");
        if (!is_d3d9_ex) {
          ImGui::TextColored(
              ImVec4(1.f, 0.45f, 0.25f, 1.f),
              "Swapchain Proxy controls are unavailable on D3D9 (non-Ex).");
          ImGui::TextUnformatted("Enable Force DX9Ex and restart the game.");
        }
      }
    }

    if (dx9_proxy_controls_blocked) {
      ImGui::BeginDisabled();
    }
    const auto end_proxy_section = [&]() {
      if (dx9_proxy_controls_blocked) {
        ImGui::EndDisabled();
      }
      EndSettingsSection();
    };

    ImGui::SeparatorText("Mode");
    {
      const bool is_enabled =
          renodx::utils::device_proxy::use_device_proxy
          && !renodx::utils::device_proxy::remove_device_proxy;
      const bool route_forced = IsDeviceProxySeparateHwndForced(data);
      const auto active_route = ResolveEffectiveDeviceProxyHwndRoute(data);
      const bool lock_mode_dropdown =
          is_enabled
          && active_route == DeviceProxyHwndRoute::SAME_HWND;

      DeviceProxyMode ui_mode = DeviceProxyMode::NONE;
      if (is_enabled) {
        ui_mode =
            (active_route == DeviceProxyHwndRoute::SAME_HWND)
                ? DeviceProxyMode::CURRENT_WINDOW
                : DeviceProxyMode::NEW_WINDOW;
      }

      if (lock_mode_dropdown) {
        ImGui::BeginDisabled();
      }

      int mode_index = static_cast<int>(ui_mode);
      if (ImGui::BeginCombo("Proxy Mode", GetDeviceProxyModeText(ui_mode))) {
        if (ImGui::Selectable(
                GetDeviceProxyModeText(DeviceProxyMode::NONE),
                mode_index == static_cast<int>(DeviceProxyMode::NONE))) {
          mode_index = static_cast<int>(DeviceProxyMode::NONE);
        }

        if (route_forced) {
          ImGui::BeginDisabled();
        }
        if (ImGui::Selectable(
                GetDeviceProxyModeText(DeviceProxyMode::CURRENT_WINDOW),
                mode_index == static_cast<int>(DeviceProxyMode::CURRENT_WINDOW))) {
          mode_index = static_cast<int>(DeviceProxyMode::CURRENT_WINDOW);
        }
        if (route_forced && ImGui::IsItemHovered()) {
          ImGui::SetItemTooltip("Unavailable on flip swapchains.");
        }
        if (route_forced) {
          ImGui::EndDisabled();
        }

        if (ImGui::Selectable(
                GetDeviceProxyModeText(DeviceProxyMode::NEW_WINDOW),
                mode_index == static_cast<int>(DeviceProxyMode::NEW_WINDOW))) {
          mode_index = static_cast<int>(DeviceProxyMode::NEW_WINDOW);
        }

        ImGui::EndCombo();
      }

      if (lock_mode_dropdown) {
        if (ImGui::IsItemHovered()) {
          ImGui::SetItemTooltip("Current Window is locked this session.");
        }
        ImGui::EndDisabled();
      }

      const auto selected_mode =
          static_cast<DeviceProxyMode>(std::clamp(mode_index, 0, 2));

      if (selected_mode != ui_mode) {
        setting_device_proxy_mode = selected_mode;
        reshade::set_config_value(
            nullptr,
            "renodx-dev",
            "SwapChainDeviceProxyMode",
            static_cast<uint32_t>(setting_device_proxy_mode));

        if (selected_mode == DeviceProxyMode::NONE) {
          if (is_enabled) {
            renodx::utils::device_proxy::remove_device_proxy = true;
            g_device_proxy_reenable_pending = false;
            g_device_proxy_overlay_abort_requested = true;
            reshade::log::message(
                reshade::log::level::info,
                "devkit::RenderDeviceProxySettings(queued proxy teardown: reason=mode changed to None)");
            end_proxy_section();
            return pending_selected_device_data;
          }
          changed = true;
        } else {
          if (selected_mode == DeviceProxyMode::CURRENT_WINDOW && route_forced) {
            reshade::log::message(
                reshade::log::level::warning,
                "devkit::RenderDeviceProxySettings(rejected Current Window mode: host swapchain is flip)");
            setting_device_proxy_mode = DeviceProxyMode::NEW_WINDOW;
            reshade::set_config_value(
                nullptr,
                "renodx-dev",
                "SwapChainDeviceProxyMode",
                static_cast<uint32_t>(setting_device_proxy_mode));
            changed = true;
            end_proxy_section();
            return pending_selected_device_data;
          }

          if (is_enabled) {
            renodx::utils::device_proxy::remove_device_proxy = true;
            g_device_proxy_reenable_pending = true;
            g_device_proxy_overlay_abort_requested = true;
            std::stringstream s;
            s << "devkit::RenderDeviceProxySettings(queued proxy teardown: reason=mode route change";
            s << ", new_mode=" << GetDeviceProxyModeText(selected_mode);
            s << ", reenable_pending=true)";
            reshade::log::message(reshade::log::level::info, s.str().c_str());
            end_proxy_section();
            return pending_selected_device_data;
          }

          if (renodx::utils::device_proxy::remove_device_proxy) {
            g_device_proxy_reenable_pending = true;
            reshade::log::message(
                reshade::log::level::info,
                "devkit::RenderDeviceProxySettings(enable requested while teardown pending; deferring re-enable)");
            changed = true;
            end_proxy_section();
            return pending_selected_device_data;
          }

          if (!PrepareDeviceProxyActivation(data)) {
            renodx::utils::device_proxy::remove_device_proxy = false;
            renodx::utils::device_proxy::use_device_proxy = false;
            g_device_proxy_reenable_pending = false;
            g_device_proxy_active_hwnd_route.reset();
            changed = true;
            end_proxy_section();
            return pending_selected_device_data;
          }

          if (device != nullptr
              && device->get_api() == reshade::api::device_api::d3d9
              && data != nullptr
              && data->runtime != nullptr) {
            (void)data->runtime->open_overlay(false, reshade::api::input_source::none);
          }

          renodx::utils::device_proxy::remove_device_proxy = false;
          renodx::utils::device_proxy::use_device_proxy = true;
          g_device_proxy_reenable_pending = false;
          changed = true;
        }
      }
    }
    {
      bool wait_idle = renodx::utils::device_proxy::device_proxy_wait_idle_destination;
      if (ImGui::Checkbox("Proxy Wait Idle", &wait_idle)) {
        renodx::utils::device_proxy::device_proxy_wait_idle_destination = wait_idle;
        reshade::set_config_value(nullptr, "renodx-dev", "SwapChainDeviceProxyProxyWaitIdle", wait_idle);
        changed = true;
      }
    }

    ImGui::SeparatorText("Output");
    {
      int index = static_cast<int>(setting_device_proxy_output_mode);
      const char* labels[] = {"sRGB", "HDR10", "scRGB"};
      if (ImGui::Combo("Output Mode", &index, labels, IM_ARRAYSIZE(labels))) {
        const bool was_active =
            renodx::utils::device_proxy::use_device_proxy
            && !renodx::utils::device_proxy::remove_device_proxy;
        setting_device_proxy_output_mode = static_cast<uint32_t>(std::clamp(index, 0, 2));
        reshade::set_config_value(nullptr, "renodx-dev", "SwapChainDeviceProxyOutputMode", setting_device_proxy_output_mode);
        if (was_active) {
          renodx::utils::device_proxy::remove_device_proxy = true;
          g_device_proxy_reenable_pending = true;
          const auto mode = ResolveDeviceProxyOutputModeConfig();
          std::stringstream s;
          s << "devkit::RenderDeviceProxySettings(queued proxy teardown: reason=output mode change";
          s << ", new_mode=" << mode.output_mode_name;
          s << ", reenable_pending=true)";
          reshade::log::message(reshade::log::level::info, s.str().c_str());
        }
        changed = true;
      }
    }

    ImGui::SeparatorText("Shaders");
    {
      bool use_custom = setting_device_proxy_use_custom_shaders;
      if (ImGui::Checkbox("Use Custom FXC Shaders", &use_custom)) {
        setting_device_proxy_use_custom_shaders = use_custom;
        reshade::set_config_value(nullptr, "renodx-dev", "SwapChainDeviceProxyUseCustomShaders", use_custom);
        changed = true;
      }
    }
    {
      ImGui::TextUnformatted("Custom proxy shaders load from Live Path when present:");
      ImGui::BulletText("%s", DEVICE_PROXY_VERTEX_SHADER_FILENAME);
      ImGui::BulletText("%s", DEVICE_PROXY_PIXEL_SHADER_FILENAME);
    }
    if (ImGui::Button("Compile FXC Shaders")) {
      if (CompileDeviceProxyShadersFromFiles() && setting_device_proxy_use_custom_shaders) {
        changed = true;
      }
    }
    ImGui::SameLine();
    if (ImGui::Button("Compile + Apply")) {
      if (CompileDeviceProxyShadersFromFiles()) {
        changed = true;
      }
    }
    if (setting_device_proxy_use_custom_shaders && !setting_device_proxy_compile_error.empty()) {
      ImGui::TextColored(
          ImVec4(1.f, 0.25f, 0.25f, 1.f),
          "Compile Error: %s",
          setting_device_proxy_compile_error.c_str());
    } else if (setting_device_proxy_use_custom_shaders
               && !setting_device_proxy_vertex_shader_blob.empty()
               && !setting_device_proxy_pixel_shader_blob.empty()) {
      ImGui::Text(
          "Custom shader bytecode ready (vs=%zu, ps=%zu)",
          setting_device_proxy_vertex_shader_blob.size(),
          setting_device_proxy_pixel_shader_blob.size());
    } else {
      ImGui::TextUnformatted("Using embedded proxy shaders.");
    }

    if (changed) {
      ApplyDeviceProxySettings();
    }

    end_proxy_section();
  }

  if (g_device_proxy_overlay_abort_requested) return pending_selected_device_data;

  return pending_selected_device_data;
}

void RenderInfoPane(reshade::api::device* device, DeviceData* data) {
  if (BeginSettingsSection("Overview")) {
    if (device != nullptr) {
      ImGui::Text(
          "Device: %p (%d)",
          device,
          static_cast<int>(device->get_api()));
    } else {
      ImGui::TextUnformatted("Device: not selected");
    }

    if (data != nullptr) {
      ImGui::Text("Captured Draws: %zu", data->draw_details_list.size());
      ImGui::Text("Tracked Shaders: %zu", data->shader_details.size());
      ImGui::Text("Tracked Pipelines: %zu", data->live_pipelines.size());
    }

    ImGui::Text("%s", (std::string("Build: ") + __DATE__ + " " + renodx::utils::date::ISO_DATE_TIME).c_str());
    EndSettingsSection();
  }

  if (BeginSettingsSection("MCP")) {
    const auto pipe_name = NarrowAscii(devkit_mcp_server.GetPipeName());
    const reshade::api::device* active_snapshot_device = snapshot_device;
    const reshade::api::device* queued_snapshot_device = snapshot_queued_device;

    ImGui::Text("Server: %s", devkit_mcp_server.IsRunning() ? "Running" : "Stopped");
    ImGui::Text("Client: %s", devkit_mcp_server.IsConnected() ? "Connected" : "Waiting");
    ImGui::Text("Pipe: %s", pipe_name.empty() ? "<unset>" : pipe_name.c_str());
    ImGui::Text("Registered Tools: %zu", devkit_mcp_server.GetToolCount());

    if (device != nullptr) {
      ImGui::Text("Selected Device: %p", device);
    } else {
      ImGui::TextUnformatted("Selected Device: not selected");
    }

    ImGui::Text(
        "Snapshot State: %s%s",
        active_snapshot_device == nullptr ? "Idle" : "Capturing",
        queued_snapshot_device == nullptr ? "" : " (queued)");

    EndSettingsSection();
  }

  if (BeginSettingsSection("Swapchain Proxy")) {
    const bool proxy_enabled =
        renodx::utils::device_proxy::use_device_proxy
        && !renodx::utils::device_proxy::remove_device_proxy;
    const bool proxy_teardown_pending =
        renodx::utils::device_proxy::remove_device_proxy;
    const auto output_mode = ResolveDeviceProxyOutputModeConfig();

    ImGui::Text(
        "State: %s",
        proxy_teardown_pending
            ? "Tearing Down"
            : (proxy_enabled ? "Enabled" : "Disabled"));
    ImGui::Text("Output: %s", output_mode.output_mode_name);

    if (data != nullptr && data->primary_swapchain_desc.has_value()) {
      const auto& primary_desc = data->primary_swapchain_desc.value();
      ImGui::Text(
          "Primary Swapchain: mode=0x%X (%s), size=%ux%u, hwnd=%p",
          primary_desc.present_mode,
          data->primary_swapchain_is_flip ? "flip" : "non-flip/unknown",
          primary_desc.back_buffer.texture.width,
          primary_desc.back_buffer.texture.height,
          data->primary_swapchain_hwnd);
    } else {
      ImGui::TextUnformatted("Primary Swapchain: not tracked yet");
    }

    ImGui::Text(
        "Proxy Device: %s",
        renodx::utils::device_proxy::proxy_device_reshade == nullptr ? "Not created" : "Ready");
    ImGui::Text(
        "Proxy Swapchain: %s",
        renodx::utils::device_proxy::proxy_swap_chain == nullptr ? "Not created" : "Ready");
    ImGui::Text(
        "Proxy HWND Override: %p",
        renodx::utils::device_proxy::GetSwapchainHwndOverride());
    ImGui::Text(
        "Proxy Output Window: %p",
        g_device_proxy_output_window);

    EndSettingsSection();
  }
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
  bool failed = !ComputeDecompilationForShaderDetails(device, data, shader_details);

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

void RenderResourceCloneHotSwapControls(reshade::api::device* device, const reshade::api::resource& resource) {
  auto* info = TryGetTrackedResourceInfo(resource);
  const auto* blocked_enable_reason = GetResourceCloneToggleBlockedReason(device, info, true);
  const bool is_managed = IsDevkitCloneManagedResource(info);
  const bool is_enabled = is_managed && info->clone_enabled;

  if (is_enabled) {
    ImGui::Text("Clone HotSwap: Enabled");
  } else if (is_managed) {
    ImGui::Text("Clone HotSwap: Disabled");
  } else {
    ImGui::Text("Clone HotSwap: Not Enabled");
  }

  if (is_enabled) {
    if (ImGui::Button("Disable Clone HotSwap")) {
      (void)SetResourceCloneHotSwapState(device, resource, false);
    }
  } else {
    ImGui::BeginDisabled(blocked_enable_reason != nullptr);
    if (ImGui::Button("Enable Clone HotSwap")) {
      (void)SetResourceCloneHotSwapState(device, resource, true);
    }
    ImGui::EndDisabled();
  }

  if (blocked_enable_reason != nullptr && !is_enabled) {
    ImGui::TextDisabled("%s", blocked_enable_reason);
  }
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
      RenderResourceCloneHotSwapControls(device, resource);
      ImGui::Separator();
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
    if (reshade::get_config_value(nullptr, "renodx-dev", "ToolsPath", temp, &size)) {
      renodx::utils::shader::compiler::directx::SetToolsPath(devkit_tools_path::TrimTrailingWhitespace(std::string(temp)));
    }
  }
  {
    char temp[256] = "";
    size_t size = 256;
    if (reshade::get_config_value(nullptr, "renodx-dev", "LivePath", temp, &size)) {
      auto temp_string = devkit_tools_path::TrimTrailingWhitespace(std::string(temp));
      renodx::utils::shader::compiler::watcher::SetLivePath(temp_string);
    }
  }

  for (const auto& [key, value] : std::vector<std::pair<const char*, std::atomic_bool*>>({
           {"TraceAll", &renodx::utils::trace::trace_all},
           {"TracePipelineCreation", &renodx::utils::trace::trace_pipeline_creation},
           {"TraceDescriptorTables", &renodx::utils::descriptor::trace_descriptor_tables},
           {"TraceConstantBuffers", &renodx::utils::constants::capture_constant_buffers},
           {"SnapshotTraceWithSnapshot", &snapshot_trace_with_snapshot},
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
  for (const auto& [key, value] : std::vector<std::pair<const char*, bool*>>({
           {"SwapChainDeviceProxyProxyWaitIdle", &renodx::utils::device_proxy::device_proxy_wait_idle_destination},
           {"SwapChainDeviceProxyForceDX9Ex", &setting_device_proxy_force_dx9_ex},
           {"SwapChainDeviceProxyForceDisableFlip", &setting_device_proxy_force_disable_flip},
           {"SwapChainDeviceProxyUseCustomShaders", &setting_device_proxy_use_custom_shaders},
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
  {
    auto temp = static_cast<uint32_t>(setting_device_proxy_mode);
    if (reshade::get_config_value(nullptr, "renodx-dev", "SwapChainDeviceProxyMode", temp)) {
      setting_device_proxy_mode = DeviceProxyModeFromConfig(temp);
    } else {
      bool legacy_use_separate_hwnd = false;
      if (reshade::get_config_value(nullptr, "renodx-dev", "SwapChainDeviceProxyUseSeparateHwnd", legacy_use_separate_hwnd)) {
        setting_device_proxy_mode = legacy_use_separate_hwnd
                                        ? DeviceProxyMode::NEW_WINDOW
                                        : DeviceProxyMode::NONE;
      }
    }
  }
  {
    uint32_t temp = setting_device_proxy_output_mode;
    bool has_mode = reshade::get_config_value(nullptr, "renodx-dev", "SwapChainDeviceProxyOutputMode", temp);
    if (has_mode) {
      setting_device_proxy_output_mode = (temp > 2u) ? 2u : temp;
    } else {
      uint32_t legacy_format = 0u;
      uint32_t legacy_color_space = 0u;
      const bool has_legacy_format =
          reshade::get_config_value(nullptr, "renodx-dev", "SwapChainDeviceProxyTargetFormat", legacy_format);
      const bool has_legacy_color_space =
          reshade::get_config_value(nullptr, "renodx-dev", "SwapChainDeviceProxyTargetColorSpace", legacy_color_space);
      if (has_legacy_format || has_legacy_color_space) {
        if (legacy_format == 1u || legacy_color_space == 1u) {
          setting_device_proxy_output_mode = 1u;  // HDR10
        } else {
          setting_device_proxy_output_mode = 2u;  // scRGB
        }
        reshade::set_config_value(
            nullptr,
            "renodx-dev",
            "SwapChainDeviceProxyOutputMode",
            setting_device_proxy_output_mode);
      }
    }
  }
  if (setting_device_proxy_use_custom_shaders) {
    (void)CompileDeviceProxyShadersFromFiles();
  }
  if (setting_device_proxy_force_dx9_ex) {
    renodx::utils::device_proxy::use_device_proxy = true;
    g_device_proxy_dx9ex_bootstrap_pending = true;
    reshade::log::message(
        reshade::log::level::info,
        "devkit::InitializeUserSettings(Force DX9Ex bootstrap armed for this launch)");
  }
  if (setting_device_proxy_force_disable_flip) {
    g_device_proxy_disable_flip_bootstrap_pending = true;
    reshade::log::message(
        reshade::log::level::info,
        "devkit::InitializeUserSettings(Force Disable Flip bootstrap armed for this launch)");
  }
  ApplyDeviceProxySettings();
}

// @see https://pthom.github.io/imgui_manual_online/manual/imgui_manual.html
void OnRegisterOverlay(reshade::api::effect_runtime* runtime) {
  DeviceData* data = nullptr;
  std::vector<SettingsDeviceOption> device_options = {};
  std::unique_lock<std::shared_mutex> data_lock;
  uint32_t selected_device_index = 0u;
  {
    std::shared_lock list_lock(device_data_list_mutex);
    const auto size = device_data_list.size();
    selected_device_index = size == 0
                                ? 0u
                                : std::min<uint32_t>(
                                      device_data_index.load(std::memory_order_relaxed),
                                      static_cast<uint32_t>(size - 1u));
    device_options.reserve(size);

    for (auto i = 0; i < size; ++i) {
      auto* device_data = device_data_list.at(i);
      if (device_data->device == nullptr) {
        assert(device_data->device != nullptr);
        continue;
      }
      std::stringstream s;
      s << PRINT_PTR(reinterpret_cast<uint64_t>(device_data->device));
      s << " (" << device_data->device->get_api() << ")";
      device_options.push_back(SettingsDeviceOption{
          .index = static_cast<uint32_t>(i),
          .device_data = device_data,
          .label = s.str(),
      });
      if (i == selected_device_index) {
        data = device_data;
      }
    }

    if (data != nullptr) {
      data_lock = std::unique_lock(data->mutex);
    }
  }

  // auto* data = renodx::utils::data::Get<DeviceData>(device);

  // Runtime may be on a separate device
  if (data == nullptr) return;

  auto* device = data->device;

  if (data->runtime == nullptr) {
    data->runtime = runtime;
  }

  static auto setting_side_sheet_width = 96.f;

  const auto x_height = ImGui::CalcTextSize("x").y;

  ImGui::SetNextWindowSizeConstraints(
      {SETTING_NAV_RAIL_SIZE + 128 + 128 + 96,
       (2 * x_height) + (SETTING_NAV_RAIL_SIZE * static_cast<float>(SETTING_NAV_TITLES.size()))},
      {FLT_MAX, FLT_MAX});

  if (ImGui::BeginChild("DevKit", ImVec2(0, 0), ImGuiChildFlags_None, ImGuiWindowFlags_MenuBar)) {
    RenderMenuBar(device, data);

    RenderNavRail(device, data);

    ImGui::SameLine();
    DeviceData* pending_proxy_device_data = nullptr;

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
          RenderResourcesPane(device, data);
          break;
        case 3:
          RenderShaderDefinesPane(device, data);
          break;
        case 4:
          pending_proxy_device_data = RenderSettingsPane(device, data, device_options, selected_device_index);
          break;
        case 5:
          RenderInfoPane(device, data);
          break;
        default:
          break;
      }
    }
    ImGui::EndChild();

    if (g_device_proxy_overlay_abort_requested) {
      g_device_proxy_overlay_abort_requested = false;
      ImGui::EndChild();
      return;
    }

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

    if (pending_proxy_device_data != nullptr
        && renodx::utils::device_proxy::use_device_proxy
        && !renodx::utils::device_proxy::remove_device_proxy) {
      data_lock.unlock();
      std::unique_lock pending_data_lock(pending_proxy_device_data->mutex);
      (void)UpdateDeviceProxyHwndOverride(pending_proxy_device_data);
    }
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
  auto* device = swapchain->get_device();
  DeviceData* data = nullptr;
  const auto get_data = [&]() -> DeviceData* {
    if (data == nullptr) {
      data = renodx::utils::data::Get<DeviceData>(device);
    }
    return data;
  };

  EnsureDevkitMcpServerStarted();
  PumpDeviceProxyOutputWindowMessages();

  if (auto* device_data = get_data(); device_data != nullptr) {
    uint32_t device_index = 0u;
    {
      std::shared_lock list_lock(device_data_list_mutex);
      if (auto iterator = std::find(device_data_list.begin(), device_data_list.end(), device_data);
          iterator != device_data_list.end()) {
        device_index = static_cast<uint32_t>(std::distance(device_data_list.begin(), iterator));
      }
    }
    std::deque<std::shared_ptr<devkit_resource_analysis::PendingRequest>> pending_requests;
    {
      std::unique_lock device_lock(device_data->mutex);
      pending_requests.swap(device_data->pending_resource_analysis_requests);
    }
    devkit_resource_analysis::ProcessPendingRequests(
        pending_requests,
        device_index,
        device_data->device,
        queue,
        devkit_resource_analysis::ProcessingContext{
            .format_handle = [](uint64_t value) { return FormatHandle(value); },
            .format_format = [](reshade::api::format format) { return StreamToString(format); },
            .build_resource_view_summary = [](reshade::api::resource_view resource_view, reshade::api::device* device) { return BuildResourceViewSummary(GetResourceViewDetails(resource_view, device)); },
        });

    std::deque<std::shared_ptr<PendingLiveShaderRequest>> pending_live_shader_requests;
    {
      std::unique_lock device_lock(device_data->mutex);
      pending_live_shader_requests.swap(device_data->pending_live_shader_requests);
    }
    ProcessPendingLiveShaderRequests(
        pending_live_shader_requests,
        device_index,
        device_data);
  }

  const bool has_stale_proxy_ui_state =
      g_device_proxy_active_hwnd_route.has_value()
      || g_device_proxy_output_window != nullptr;
  if (!renodx::utils::device_proxy::use_device_proxy && has_stale_proxy_ui_state) {
    g_device_proxy_active_hwnd_route.reset();
    DestroyDeviceProxyOutputWindow();
  }

  if (setting_shader_defines_changed) {
    renodx::utils::shader::compiler::watcher::SetShaderDefines(setting_shader_defines);
    renodx::utils::shader::compiler::watcher::RequestCompile();
    setting_shader_defines_changed = false;
  }

  if (g_device_proxy_reenable_pending
      && !renodx::utils::device_proxy::remove_device_proxy
      && !renodx::utils::device_proxy::use_device_proxy) {
    if (PrepareDeviceProxyActivation(get_data())) {
      renodx::utils::device_proxy::remove_device_proxy = false;
      renodx::utils::device_proxy::use_device_proxy = true;
    } else {
      reshade::log::message(
          reshade::log::level::error,
          "devkit::OnPresent(failed to re-enable device proxy after output mode change)");
    }
    g_device_proxy_reenable_pending = false;
  }

  if (setting_live_reload) {
    if (!renodx::utils::shader::compiler::watcher::IsEnabled()) {
      renodx::utils::shader::compiler::watcher::Start();
    }
    auto* device_data = get_data();
    if (device_data == nullptr) return;
    std::unique_lock lock(device_data->mutex);
    LoadDiskShaders(device, device_data, true);
  } else {
    if (renodx::utils::shader::compiler::watcher::IsEnabled()) {
      renodx::utils::shader::compiler::watcher::Stop();
    }
  }

  if (setting_auto_dump) {
    renodx::utils::shader::dump::DumpAllPending();
  }

  reshade::api::device* active_snapshot_device = snapshot_device;
  if (active_snapshot_device == nullptr) {
    if (snapshot_queued_device == device) {
      auto* device_data = get_data();
      std::unique_lock lock(device_data->mutex);
      device_data->draw_details_list.clear();
      device_data->resource_usage_by_handle.clear();
      device_data->snapshot_rows.clear();
      device_data->snapshot_row_layout_key = 0u;
      device_data->snapshot_rows_valid = false;
      snapshot_device = device;
      snapshot_queued_device = nullptr;
    }
  } else if (device == active_snapshot_device) {
    snapshot_device = nullptr;
    auto* device_data = get_data();
    std::unique_lock lock(device_data->mutex);
    std::ranges::sort(device_data->draw_details_list, [](const DrawDetails& a, const DrawDetails& b) {
      return a.timestamp < b.timestamp;
    });

    device_data->shader_draw_indexes.clear();
    device_data->resource_usage_by_handle.clear();
    for (auto i = 0; i < device_data->draw_details_list.size(); ++i) {
      const auto& draw_details = device_data->draw_details_list[i];
      const auto update_resource_usage = [&](reshade::api::resource resource, bool SnapshotResourceUsage::* usage_flag) {
        if (resource.handle == 0u) return;
        auto& usage = device_data->resource_usage_by_handle[resource.handle];
        usage.*usage_flag = true;
        if (usage.first_snapshot_index == -1) {
          usage.first_snapshot_index = i;
        }
      };
      for (const auto& pipeline_bind : draw_details.pipeline_binds) {
        for (const auto& shader_hash : pipeline_bind.shader_hashes) {
          device_data->shader_draw_indexes[shader_hash].insert(i);
        }
      }
      for (const auto& [slot_space, resource_view_details] : draw_details.srv_binds) {
        (void)slot_space;
        update_resource_usage(resource_view_details.resource, &SnapshotResourceUsage::seen_srv);
      }
      for (const auto& [slot_space, resource_view_details] : draw_details.uav_binds) {
        (void)slot_space;
        update_resource_usage(resource_view_details.resource, &SnapshotResourceUsage::seen_uav);
      }
      for (const auto& [slot, resource_view_details] : draw_details.render_targets) {
        (void)slot;
        update_resource_usage(resource_view_details.resource, &SnapshotResourceUsage::seen_rtv);
      }
    }
    device_data->snapshot_rows.clear();
    device_data->snapshot_row_layout_key = 0u;
    device_data->snapshot_rows_valid = false;
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
      renodx::utils::state::Use(fdw_reason);
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::shader::dump::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);
      renodx::utils::device_proxy::Use(fdw_reason);

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
      reshade::register_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);

      reshade::register_overlay("RenoDX DevKit", OnRegisterOverlay);

      break;
    case DLL_PROCESS_DETACH:
      devkit_mcp_start_failed = false;
      devkit_mcp_server.Stop();

      renodx::utils::trace::Use(fdw_reason);
      renodx::utils::constants::Use(fdw_reason);
      renodx::utils::descriptor::Use(fdw_reason);
      renodx::utils::state::Use(fdw_reason);
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::shader::dump::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);
      renodx::utils::device_proxy::Use(fdw_reason);

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
      reshade::unregister_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);

      reshade::unregister_overlay("RenoDX DevKit", OnRegisterOverlay);

      break;
  }

  renodx::utils::resource::Use(fdw_reason);

  // ResourceWatcher::Use(fdwReason);

  if (fdw_reason == DLL_PROCESS_DETACH) {
    reshade::unregister_addon(h_module);
  }

  return TRUE;
}
