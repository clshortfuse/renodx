/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <atomic>
#include <cstdlib>
#include <exception>
#include <mutex>
#include <optional>
#include <variant>
#define ImTextureID ImU64

#pragma comment(lib, "dxguid.lib")

#include <d3d11.h>
#include <d3d12.h>
#include <Windows.h>

#include <cstdio>
#include <filesystem>
#include <shared_mutex>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <crc32_hash.hpp>
#include "../utils/descriptor.hpp"
#include "../utils/shader.hpp"
#include "../utils/shader_compiler.hpp"
#include "../utils/shader_compiler_watcher.hpp"
#include "../utils/shader_dump.hpp"
#include "../utils/swapchain.hpp"
#include "../utils/trace.hpp"

#define ICON_FK_REFRESH u8"\uf021"
#define ICON_FK_FLOPPY  u8"\uf0c7"

namespace {

std::atomic_bool is_snapshotting = false;

struct ShaderDetails {
  uint32_t shader_hash;
  std::variant<std::nullopt_t, std::exception, std::string> disassembly = std::nullopt;
  std::optional<renodx::utils::shader::compiler::DxilProgramVersion> program_version = std::nullopt;
  std::optional<renodx::utils::shader::compiler::watcher::CustomShader> custom_shader = std::nullopt;
};

struct ResourceViewDetails {
  reshade::api::resource_view resource_view;
  reshade::api::resource_view_desc resource_view_desc;
  reshade::api::resource resource;
  reshade::api::resource_desc resource_desc;
  std::string resource_tag;
  std::string resource_view_tag;
  bool is_swapchain;
};

struct PipelineBindDetails {
  reshade::api::pipeline pipeline;
  reshade::api::pipeline_stage pipeline_stage;
  std::vector<uint32_t> shader_hashes;
};

struct DrawDetails {
  std::vector<PipelineBindDetails> pipeline_binds;
  enum class DrawMethods {
    PRESENT,
    DRAW,
    DRAW_INDEXED,
    DRAW_INDEXED_OR_INDIRECT,
    DISPATCH
  } draw_method;
  std::vector<ResourceViewDetails> render_targets;

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
  std::unordered_map<uint64_t, ResourceViewDetails> resource_view_details;
  std::vector<CommandListData> command_list_data;

  void StartSnapshot() {
    this->command_list_data.clear();
    is_snapshotting = true;
  }

  static void StopSnapshot() {
    is_snapshotting = false;
  }

  ShaderDetails& GetShaderDetails(uint32_t shader_hash) {
    if (auto pair = shader_details.find(shader_hash);
        pair != shader_details.end()) {
      return pair->second;
    }

    auto [iterator, is_new] = shader_details.emplace(shader_hash, shader_hash);
    return iterator->second;
  }

  ResourceViewDetails& GetResourceViewDetails(reshade::api::resource_view resource_view, reshade::api::device* device) {
    if (auto pair = resource_view_details.find(resource_view.handle);
        pair != resource_view_details.end()) {
      return pair->second;
    }

    ResourceViewDetails details = {
        .resource_view = resource_view,
        .resource_view_desc = device->get_resource_view_desc(resource_view),
        .resource = device->get_resource_from_view(resource_view),
    };
    auto device_api = device->get_api();
    if (device_api == reshade::api::device_api::d3d11) {
      auto resource_view_tag = renodx::utils::trace::GetDebugName(device->get_api(), resource_view);
      if (resource_view_tag.has_value()) {
        details.resource_view_tag = resource_view_tag.value();
      }
    }

    if (details.resource.handle != 0u) {
      details.resource_desc = device->get_resource_desc(details.resource);
      details.is_swapchain = renodx::utils::swapchain::IsBackBuffer(device, details.resource);
      auto resource_tag = renodx::utils::trace::GetDebugName(device->get_api(), details.resource);
      if (resource_tag.has_value()) {
        details.resource_tag = resource_tag.value();
      }
    }

    auto [iterator, is_new] = resource_view_details.emplace(resource_view.handle, details);
    return iterator->second;
  }

  std::shared_mutex mutex;
};

// Settings
std::atomic_bool is_tracing_pipelines = false;

bool setting_auto_dump = false;
bool setting_auto_compile = false;
bool setting_live_reload = false;
bool setting_unique_shaders_only = false;
bool setting_show_vertex_shaders = false;

struct {
  uint32_t row_id = 0;
  uint64_t pipeline_handle = 0;
  uint32_t shader_hash = 0;
  uint64_t resource_handle = 0;

  [[nodiscard]] auto GetTreeNodeFlag(uint32_t row_index) const {
    return row_index == row_id ? ImGuiTreeNodeFlags_Selected : 0;
  }

} setting_row_selection;

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

void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stages,
    reshade::api::pipeline pipeline) {
  if (!is_snapshotting) return;

  auto& data = cmd_list->get_private_data<CommandListData>();
  auto& details = data.GetCurrentDrawDetails();

  PipelineBindDetails bind_details = {
      .pipeline = pipeline,
      .pipeline_stage = stages,
  };
  auto shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  for (auto compatible_stage : renodx::utils::shader::COMPATIBLE_STAGES) {
    if ((stages & compatible_stage) == compatible_stage) {
      auto shader_hash = shader_state.GetCurrentShaderHash(compatible_stage);
      bind_details.shader_hashes.push_back(shader_hash);
    }
  }

  details.pipeline_binds.push_back(bind_details);
}

bool OnDraw(reshade::api::command_list* cmd_list, DrawDetails::DrawMethods draw_method) {
  if (!is_snapshotting) return false;

  auto& command_list_data = cmd_list->get_private_data<CommandListData>();
  auto* device = cmd_list->get_device();
  auto& device_data = device->get_private_data<DeviceData>();

  std::unique_lock lock(device_data.mutex);

  auto& details = command_list_data.GetCurrentDrawDetails();
  details.draw_method = draw_method;
  details.render_targets.clear();
  for (auto render_target : renodx::utils::swapchain::GetRenderTargets(cmd_list)) {
    if (render_target.handle == 0u) continue;
    details.render_targets.push_back(
        device_data.GetResourceViewDetails(render_target, device));
  }

  device_data.command_list_data.push_back(command_list_data);
  command_list_data.draw_details.clear();

  return false;
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

void PerformShaderReload(reshade::api::device* device) {
  if (setting_live_reload) {
    if (!renodx::utils::shader::compiler::watcher::HasChanged()) return;
  } else {
    renodx::utils::shader::compiler::watcher::CompileSync();
  }
  auto new_shaders = renodx::utils::shader::compiler::watcher::FlushCompiledShaders();
  auto& data = device->get_private_data<DeviceData>();
  std::unique_lock lock(data.mutex);
  for (auto& [shader_hash, custom_shader] : new_shaders) {
    renodx::utils::shader::RemoveRuntimeReplacement(shader_hash, device);
    if (!custom_shader.removed && custom_shader.IsCompilationOK()) {
      renodx::utils::shader::AddRuntimeReplacement(shader_hash, custom_shader.GetCompilationData());
    }

    auto& details = data.GetShaderDetails(shader_hash);
    details.custom_shader = custom_shader;
  }
}

// @see https://pthom.github.io/imgui_manual_online/manual/imgui_manual.html
void OnRegisterOverlay(reshade::api::effect_runtime* runtime) {
  auto* device = runtime->get_device();
  auto& data = device->get_private_data<DeviceData>();

  {
    ImGui::PushID("##SnapshotButton");
    if (ImGui::Button("Take Snapshot")) {
      std::unique_lock lock(data.mutex);
      data.StartSnapshot();
    }
    ImGui::PopID();

    ImGui::SameLine();
    ImGui::PushID("##TraceButton");
    if (ImGui::Button("Log Trace")) {
      renodx::utils::trace::trace_scheduled = true;
    }
    ImGui::PopID();
  }

  {
    ImGui::BeginDisabled(setting_auto_dump);
    ImGui::PushID("##DumpShaders");
    if (ImGui::Button(std::format("Dump Shaders ({})", renodx::utils::shader::dump::pending_dump_count.load()).c_str())) {
      renodx::utils::shader::dump::DumpAllPending();
    }
    ImGui::PopID();
    ImGui::EndDisabled();

    ImGui::SameLine();
    ImGui::PushID("##AutoDumpCheckBox");
    if (ImGui::Checkbox("Auto", &setting_auto_dump)) {
      // noop
    }
    ImGui::PopID();
  }

  {
    ImGui::BeginDisabled(setting_live_reload);
    if (ImGui::Button(std::format("Unload Shaders ({})", renodx::utils::shader::runtime_replacement_count.load()).c_str())) {
      renodx::utils::shader::RemoveAllRuntimeReplacements(runtime->get_device());
      renodx::utils::shader::compiler::watcher::CompileSync();
    }
    ImGui::EndDisabled();

    ImGui::SameLine();
    ImGui::BeginDisabled(setting_live_reload);
    if (ImGui::Button(std::format("Load Shaders ({})", renodx::utils::shader::compiler::watcher::custom_shaders_count.load()).c_str())) {
      PerformShaderReload(runtime->get_device());
    }
    ImGui::EndDisabled();

    ImGui::SameLine();
    ImGui::PushID("##LiveReloadCheckBox");
    ImGui::BeginDisabled(setting_live_reload);

    if (ImGui::Checkbox("Auto Compile", &setting_auto_compile)) {
      if (setting_auto_compile) {
        renodx::utils::shader::compiler::watcher::Start();
      } else {
        renodx::utils::shader::compiler::watcher::Stop();
      }
    }
    ImGui::EndDisabled();
    ImGui::PopID();

    ImGui::SameLine();
    ImGui::BeginDisabled(!setting_auto_compile);
    ImGui::PushID("##LiveReloadCheckBox");
    if (ImGui::Checkbox("Live Reload", &setting_live_reload)) {
      // noop
    }
    ImGui::PopID();
    ImGui::EndDisabled();
  }

  bool changed_selected = false;
  if (ImGui::BeginTabBar("##MyTabBar", ImGuiTabBarFlags_None)) {
    std::unique_lock lock(data.mutex);

    ImGui::PushID("##SnapshotTab");
    auto handle_snapshot_tab = ImGui::BeginTabItem("Capture");
    ImGui::PopID();
    if (handle_snapshot_tab) {
      if (ImGui::BeginChild("##SnapshotList", ImVec2(96, 0), ImGuiChildFlags_ResizeX)) {
        static ImGuiTreeNodeFlags tree_node_flags = ImGuiTreeNodeFlags_SpanAllColumns | ImGuiTreeNodeFlags_SpanFullWidth;
        if (ImGui::BeginTable(
                "##SnapshotTree",
                5,
                ImGuiTableFlags_BordersV | ImGuiTableFlags_BordersOuterH | ImGuiTableFlags_Resizable | ImGuiTableFlags_Hideable
                    | ImGuiTableFlags_NoBordersInBody | ImGuiTableFlags_ScrollY,
                ImVec2(-4, -4))) {
          static const float TEXT_BASE_WIDTH = ImGui::CalcTextSize("A").x;
          ImGui::TableSetupColumn("Type", ImGuiTableColumnFlags_NoHide | ImGuiTableColumnFlags_WidthStretch, TEXT_BASE_WIDTH * 24.0f);
          ImGui::TableSetupColumn("Ref", ImGuiTableColumnFlags_None, TEXT_BASE_WIDTH * 16.0f);
          ImGui::TableSetupColumn("Info", ImGuiTableColumnFlags_None, TEXT_BASE_WIDTH * 24.0f);
          ImGui::TableSetupColumn("Tag", ImGuiTableColumnFlags_None, TEXT_BASE_WIDTH * 24.0f);
          ImGui::TableSetupColumn("Index", ImGuiTableColumnFlags_None, TEXT_BASE_WIDTH * 4.0f);
          ImGui::TableSetupScrollFreeze(0, 1);
          ImGui::TableHeadersRow();

          uint32_t row_index = 0x2000;
          int draw_index = 0;
          for (auto& command_list_data : data.command_list_data) {
            for (auto& draw_details : command_list_data.draw_details) {
              ImGui::TableNextRow();
              ImGui::TableNextColumn();
              ImGui::PushID(row_index);
              bool draw_node_open = ImGui::TreeNodeEx("", tree_node_flags | ImGuiTreeNodeFlags_DefaultOpen, "%s", draw_details.DrawMethodString().c_str());
              ImGui::PopID();

              ImGui::TableNextColumn();  // Ref

              ImGui::TableNextColumn();  // Info

              ImGui::TableNextColumn();  // Tag

              ImGui::TableNextColumn();
              ImGui::Text("%03d", draw_index);

              for (const auto& pipeline_bind : draw_details.pipeline_binds) {
                auto pipeline_details = renodx::utils::shader::GetPipelineShaderDetails(device, pipeline_bind.pipeline);
                if (!pipeline_details.has_value()) continue;

                if (!pipeline_details->tag.has_value()) {
                  pipeline_details->tag = "";
                  auto result = renodx::utils::trace::GetDebugName(device->get_api(), pipeline_bind.pipeline);
                  if (result.has_value()) {
                    pipeline_details->tag = result.value();
                  }
                }

                for (const auto& shader_hash : pipeline_bind.shader_hashes) {
                  ++row_index;  // Count rows regardless of tree node state
                  if (draw_node_open) {
                    auto& shader_details = data.GetShaderDetails(shader_hash);

                    ImGui::TableNextRow();
                    ImGui::TableNextColumn();

                    auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                        | setting_row_selection.GetTreeNodeFlag(row_index);

                    ImGui::PushID(row_index);
                    if (shader_hash != 0u && !shader_details.program_version.has_value()) {
                      try {
                        auto shader_data = pipeline_details->GetShaderData(shader_hash);
                        if (!shader_data.has_value()) throw std::exception("Failed to get shader data");
                        shader_details.program_version = renodx::utils::shader::compiler::DecodeShaderVersion(shader_data.value());
                      } catch (const std::exception& e) {
                        reshade::log_message(reshade::log_level::error, e.what());
                      }
                    }
                    // Fallback to subobject
                    if (shader_details.program_version.has_value()) {
                      ImGui::TreeNodeEx("", bullet_flags, "%s_%d_%d",
                                        shader_details.program_version->GetKindAbbr(),
                                        shader_details.program_version->GetMajor(),
                                        shader_details.program_version->GetMinor());
                    } else {
                      std::stringstream s;
                      s << pipeline_bind.pipeline_stage;
                      ImGui::TreeNodeEx("", bullet_flags, "%s", s.str().c_str());
                    }
                    ImGui::PopID();
                    if (ImGui::IsItemClicked()) {
                      setting_row_selection = {
                          .row_id = row_index,
                          .pipeline_handle = pipeline_bind.pipeline.handle,
                          .shader_hash = shader_hash,
                      };

                      ImGui::SetItemDefaultFocus();
                    }

                    ImGui::TableNextColumn();  // Reference
                    ImGui::Text("0x%08X", shader_hash);

                    ImGui::TableNextColumn();  // Name
                    if (shader_details.custom_shader.has_value()) {
                      // Has custom shader file
                      std::string file_alias;
                      if (shader_details.custom_shader->is_hlsl) {
                        static const auto CHARACTERS_TO_REMOVE_FROM_END = std::string("0x12345678.xx_x_x.hlsl").length();
                        auto filename = shader_details.custom_shader->file_path.filename().string();
                        filename.erase(filename.length() - min(CHARACTERS_TO_REMOVE_FROM_END, filename.length()));
                        if (filename.ends_with("_")) {
                          filename.erase(filename.length() - 1);
                        }
                        file_alias.assign(filename);
                      }
                      if (shader_details.custom_shader->IsCompilationOK()) {
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

                    ImGui::TableNextColumn();  // Tag
                    if (!pipeline_details->tag->empty()) {
                      ImGui::TextUnformatted(pipeline_details->tag->c_str());
                    }

                    ImGui::TableNextColumn();  // Index
                    ImGui::Text("%03d", draw_index);
                  }
                }
              }
              int render_target_index = 0;
              for (auto& render_target : draw_details.render_targets) {
                ++row_index;
                bool rtv_node_open = false;
                if (draw_node_open) {
                  ImGui::TableNextRow();
                  ImGui::TableNextColumn();
                  ImGui::PushID(row_index);
                  rtv_node_open = ImGui::TreeNodeEx("", tree_node_flags | ImGuiTreeNodeFlags_DefaultOpen, "RTV%d", render_target_index++);
                  ImGui::PopID();

                  ImGui::TableNextColumn();
                  ImGui::Text("0x%016llX", render_target.resource_view.handle);

                  ImGui::TableNextColumn();
                  std::stringstream s;
                  s << render_target.resource_view_desc.format;
                  if (render_target.is_swapchain) {
                    ImGui::TextColored(ImVec4(0, 255, 0, 255), "%s", s.str().c_str());
                  } else {
                    ImGui::TextUnformatted(s.str().c_str());
                  }

                  ImGui::TableNextColumn();
                  if (!render_target.resource_view_tag.empty()) {
                    ImGui::TextUnformatted(render_target.resource_view_tag.c_str());
                  }

                  ImGui::TableNextColumn();  // Index
                  ImGui::Text("%03d", draw_index);
                }
                ++row_index;
                if (rtv_node_open) {
                  ImGui::TableNextRow();
                  ImGui::TableNextColumn();
                  auto bullet_flags = tree_node_flags | ImGuiTreeNodeFlags_Leaf | ImGuiTreeNodeFlags_Bullet | ImGuiTreeNodeFlags_NoTreePushOnOpen
                                      | setting_row_selection.GetTreeNodeFlag(row_index);
                  ImGui::PushID(row_index);
                  ImGui::TreeNodeEx("", bullet_flags, "Resource");
                  ImGui::PopID();
                  if (ImGui::IsItemClicked()) {
                    setting_row_selection = {
                        .row_id = row_index,
                        .resource_handle = render_target.resource.handle,
                    };
                    ImGui::SetItemDefaultFocus();
                  }

                  ImGui::TableNextColumn();
                  ImGui::Text("0x%016llX", render_target.resource.handle);

                  ImGui::TableNextColumn();
                  std::stringstream s;
                  s << render_target.resource_desc.texture.format;

                  if (render_target.is_swapchain) {
                    ImGui::TextColored(ImVec4(0, 255, 0, 255), "%s", s.str().c_str());
                  } else {
                    ImGui::TextUnformatted(s.str().c_str());
                  }

                  ImGui::TableNextColumn();
                  if (!render_target.resource_tag.empty()) {
                    ImGui::TextUnformatted(render_target.resource_tag.c_str());
                  }

                  ImGui::TableNextColumn();  // Index
                  ImGui::Text("%03d", draw_index);

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

        ImGui::EndChild();
      }  // BeginChild ##DrawList

      ImGui::SameLine();
      if (ImGui::BeginChild("##ShaderDetails", ImVec2(0, 0))) {
        if (ImGui::BeginTabBar("##ShadersCodeTab", ImGuiTabBarFlags_None)) {
          if (ImGui::BeginTabItem("Disassembly")) {
            if (ImGui::BeginChild("DisassemblyCode")) {
              std::string disassembly_string;
              bool failed = false;
              if (setting_row_selection.shader_hash != 0) {
                auto shader_details = data.GetShaderDetails(setting_row_selection.shader_hash);
                if (std::holds_alternative<std::nullopt_t>(shader_details.disassembly)) {
                  // Never disassembled
                  try {
                    auto pipeline_details = renodx::utils::shader::GetPipelineShaderDetails(device, {setting_row_selection.pipeline_handle});
                    if (!pipeline_details.has_value()) throw std::exception("Shader blob not found");
                    auto shader_data = pipeline_details->GetShaderData(setting_row_selection.shader_hash);
                    if (!shader_data.has_value()) throw std::exception("Invalid shader selection");
                    shader_details.disassembly = renodx::utils::shader::compiler::DisassembleShader(shader_data.value());
                  } catch (std::exception& e) {
                    shader_details.disassembly = e;
                  }
                }

                if (std::holds_alternative<std::exception>(shader_details.disassembly)) {
                  disassembly_string.assign(std::get<std::exception>(shader_details.disassembly).what());
                  failed = true;
                } else {
                  disassembly_string.assign(std::get<std::string>(shader_details.disassembly));
                }
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
              ImGui::EndChild();  // DisassemblyCode
            }  // BeginChild DisassemblyCode
            ImGui::EndTabItem();  // Disassembly
          }  // BeginTabItem Disassembly

          ImGui::PushID("##LiveTabItem");
          const bool open_live_tab_item = ImGui::BeginTabItem("Live");
          ImGui::PopID();
          static bool opened_live_tab_item = false;
          if (open_live_tab_item) {
            std::string live_string;
            bool failed = false;
            if (setting_row_selection.shader_hash != 0) {
              auto shader_details = data.GetShaderDetails(setting_row_selection.shader_hash);
              if (shader_details.custom_shader.has_value()) {
                if (!shader_details.custom_shader->IsCompilationOK()) {
                  live_string = shader_details.custom_shader->GetCompilationException().what();
                } else if (shader_details.custom_shader->is_hlsl) {
                  try {
                    live_string = renodx::utils::path::ReadTextFile(shader_details.custom_shader->file_path);
                  } catch (std::exception& e) {
                    live_string = e.what();
                    failed = true;
                  }
                }
              }

              if (ImGui::BeginChild("LiveCode")) {
                if (failed) {
                  ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(192, 0, 0, 255));
                }
                ImGui::InputTextMultiline(
                    "##liveCode",
                    const_cast<char*>(live_string.c_str()),
                    live_string.length(),
                    ImVec2(-4, -4));
                if (failed) {
                  ImGui::PopStyleColor();
                }
                ImGui::EndChild();
              }  // BeginChild LiveCode
            }

            ImGui::EndTabItem();
          }  // open_live_tab_item

          ImGui::EndTabBar();
        }  // BeginTabBar ShadersCodeTab

        ImGui::EndChild();  // ##ShaderDetails
      }  // BeginChild ##ShaderDetails
      ImGui::EndTabItem();
    }  // handle_capture_tab

    ImGui::PushID("##ShaderDefinesTab");
    auto handle_shader_defines_tab = ImGui::BeginTabItem("Shader Defines");
    ImGui::PopID();
    if (handle_shader_defines_tab) {
      if (ImGui::BeginChild("##ShaderDefinesChild", ImVec2(0, 0))) {
        static ImGuiTreeNodeFlags tree_node_flags = ImGuiTreeNodeFlags_SpanAllColumns | ImGuiTreeNodeFlags_SpanFullWidth;
        if (ImGui::BeginTable(
                "##ShaderDefinesTable",
                4,
                ImGuiTableFlags_BordersV | ImGuiTableFlags_BordersOuterH | ImGuiTableFlags_Resizable
                    | ImGuiTableFlags_NoBordersInBody | ImGuiTableFlags_ScrollY,
                ImVec2(-4, -4))) {
          static const float TEXT_BASE_WIDTH = ImGui::CalcTextSize("A").x;
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
          char temp_key[128];
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

        ImGui::EndChild();
      }

      ImGui::EndTabItem();
    }  // handle_shader_defines_tab

    ImGui::EndTabBar();
  }  // BeginTabBar MyTabBar
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  auto* device = swapchain->get_device();
  if (setting_shader_defines_changed) {
    renodx::utils::shader::compiler::watcher::SetShaderDefines(setting_shader_defines);
    if (setting_auto_compile) {
      renodx::utils::shader::compiler::watcher::RequestCompile();
    }
    setting_shader_defines_changed = false;
  }
  if (setting_live_reload) {
    PerformShaderReload(swapchain->get_device());
  }
  if (setting_auto_dump) {
    renodx::utils::shader::dump::DumpAllPending();
  }

  DeviceData::StopSnapshot();
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX DevKit";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX DevKit Module";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::utils::descriptor::Use(fdw_reason);
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::shader::dump::Use(fdw_reason);
      renodx::utils::trace::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);

      renodx::utils::shader::use_replace_async = true;

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      reshade::register_event<reshade::addon_event::dispatch>(OnDispatch);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      reshade::register_overlay("RenoDX (DevKit)", OnRegisterOverlay);

      break;
    case DLL_PROCESS_DETACH:

      renodx::utils::descriptor::Use(fdw_reason);

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
      reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
      reshade::unregister_event<reshade::addon_event::dispatch>(OnDispatch);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);

      reshade::unregister_overlay("RenoDX (DevKit)", OnRegisterOverlay);

      reshade::unregister_addon(h_module);

      break;
  }

  // ResourceWatcher::Use(fdwReason);

  return TRUE;
}
