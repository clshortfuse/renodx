/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <cstddef>
#include <cstdint>
#include <include/reshade.hpp>
#include <include/reshade_api_device.hpp>
#include <include/reshade_api_format.hpp>
#include <include/reshade_api_pipeline.hpp>
#include <include/reshade_api_resource.hpp>
#include <initializer_list>
#include <optional>
#include <span>
#include <tuple>
#include <unordered_map>
#include <utility>
#include <vector>

// Local utilities
#include "pipeline.hpp"
#include "resource.hpp"
#include "state.hpp"

namespace renodx::utils::render {

struct ConstantBuffersSlots {
  std::uint8_t slot = 13;
  std::uint8_t space = 0;
};

inline bool operator==(const ConstantBuffersSlots& lhs, const ConstantBuffersSlots& rhs) {
  return lhs.slot == rhs.slot && lhs.space == rhs.space;
}

struct ConstantBuffersSlotsHash {
  std::size_t operator()(const ConstantBuffersSlots& slots) const noexcept {
    return (static_cast<std::size_t>(slots.slot) << 8)
           | static_cast<std::size_t>(slots.space);
  }
};

struct ResourceViewSlots {
  std::vector<reshade::api::resource_view> views;
  std::vector<reshade::api::resource_view> generated_views;
  // Helpers (used to auto populate)
  std::vector<reshade::api::resource_view_desc> view_descs;
  std::vector<renodx::utils::resource::ResourceViewInfo*> view_infos;
  std::vector<reshade::api::resource> resources;
  std::vector<reshade::api::resource_desc> resource_descs;
  std::vector<renodx::utils::resource::ResourceInfo*> resource_infos;
  reshade::api::resource_usage usage = reshade::api::resource_usage::undefined;

  reshade::api::resource_view GenerateResourceView(
      reshade::api::command_list* cmd_list,
      const reshade::api::resource& resource,
      const reshade::api::resource_desc& resource_desc) {
    return GenerateResourceView(
        cmd_list,
        resource,
        resource_desc,
        reshade::api::resource_view_desc(resource_desc.texture.format));
  }

  reshade::api::resource_view GenerateResourceView(
      reshade::api::command_list* cmd_list,
      const reshade::api::resource& resource,
      const reshade::api::resource_desc& resource_desc,
      const reshade::api::resource_view_desc& view_desc) {
    auto* device = cmd_list->get_device();
    if (device == nullptr) return {0};

    reshade::api::resource_view view = {0};
    bool created_resource_view = device->create_resource_view(
        resource,
        usage,
        view_desc,
        &view);

    if (!created_resource_view) {
      assert(created_resource_view != false);
      return {0};
    }

    this->generated_views.push_back(view);

    auto [resource_view_info, inserted] =
        renodx::utils::resource::EmplaceResourceViewInfoOrReuse(
            view,
            {.view = view},
            true);
    assert(resource_view_info != nullptr);
#ifdef DEBUG_LEVEL_2
    if (!inserted) {
      std::stringstream s;
      s << "utils::render::ResourceViewSlots::GenerateResourceView(reused view info, view="
        << PRINT_PTR(view.handle)
        << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
#endif
    resource_view_info->view = view;
    resource_view_info->desc = view_desc;
    resource_view_info->usage = usage;
    resource_view_info->device = device;
    resource_view_info->original_resource = resource;
    resource_view_info->destroyed = false;
    resource_view_info->resource_info = renodx::utils::resource::GetResourceInfo(resource, false);
    if (resource_view_info->resource_info != nullptr) {
      resource_view_info->clone_target = resource_view_info->resource_info->clone_target;
    }

    return view;
  }

  bool Populate(reshade::api::command_list* cmd_list) {
    if (!this->views.empty()) return true;

    // Try via view_infos
    if (!this->view_infos.empty()) {
      assert(this->view_descs.empty());
      this->view_descs.clear();
      for (const auto& view_info : view_infos) {
        assert(!view_info->destroyed);
        this->views.push_back(view_info->view);
        this->view_descs.push_back(view_info->desc);
      }
      return true;
    }

    // Try via resource_infos
    if (!this->resource_infos.empty()) {
      assert(this->resources.empty());
      this->resources.clear();
      for (const auto& res_info : resource_infos) {
        assert(!res_info->destroyed);
        reshade::api::resource_view_desc view_desc(res_info->desc.texture.format);
        if (this->view_descs.size() > this->views.size()) {
          view_desc = this->view_descs[this->views.size()];
        }
        auto view = GenerateResourceView(cmd_list, res_info->resource, res_info->desc, view_desc);
        if (view.handle == 0) {
          assert(view.handle != 0);
          return false;
        }
        this->views.push_back(view);
        this->resources.push_back(res_info->resource);
        this->resource_descs.push_back(res_info->desc);
#ifdef DEBUG_LEVEL_2
        {
          std::stringstream s;
          s << "utils::render::ResourceViewSlots::Populate(view_from_resource_info, view="
            << PRINT_PTR(view.handle)
            << ", resource=" << PRINT_PTR(res_info->resource.handle)
            << ", usage=" << static_cast<uint32_t>(this->usage)
            << ", format=" << view_desc.format
            << ")";
          reshade::log::message(reshade::log::level::info, s.str().c_str());
        }
#endif
      }
    }

    // Try via resources
    if (!this->resources.empty()) {
      for (const auto& resource : this->resources) {
        reshade::api::resource_desc desc = {};
        auto* resource_info = renodx::utils::resource::GetResourceInfo(resource, false);
        if (resource_info != nullptr) {
          desc = resource_info->desc;
        } else {
#ifdef DEBUG_LEVEL_2
          {
            std::stringstream s;
            s << "utils::render::ResourceViewSlots::Populate(resource info missing, resource="
              << PRINT_PTR(resource.handle)
              << ", usage=" << static_cast<uint32_t>(this->usage)
              << ")";
            reshade::log::message(reshade::log::level::debug, s.str().c_str());
          }
#endif
          auto* device = cmd_list->get_device();
          desc = device->get_resource_desc(resource);
        }
        if (desc.type == reshade::api::resource_type::unknown) return false;
        reshade::api::resource_view_desc view_desc(desc.texture.format);
        if (this->view_descs.size() > this->views.size()) {
          view_desc = this->view_descs[this->views.size()];
        }
        auto view = GenerateResourceView(cmd_list, resource, desc, view_desc);
        if (view.handle == 0) {
          assert(view.handle != 0);
          return false;
        }
        this->views.push_back(view);
        this->resource_descs.push_back(desc);
#ifdef DEBUG_LEVEL_2
        {
          std::stringstream s;
          s << "utils::render::ResourceViewSlots::Populate(view_from_resource, view="
            << PRINT_PTR(view.handle)
            << ", resource=" << PRINT_PTR(resource.handle)
            << ", usage=" << static_cast<uint32_t>(this->usage)
            << ", format=" << view_desc.format
            << ")";
          reshade::log::message(reshade::log::level::info, s.str().c_str());
        }
#endif
        if (resource_info != nullptr) {
          this->resource_infos.push_back(resource_info);
        }
      }
    }

    return true;
  }
};

struct RenderTargetSlots : ResourceViewSlots {
  std::vector<reshade::api::render_pass_render_target_desc> render_pass_descs;

  RenderTargetSlots() {
    usage = reshade::api::resource_usage::render_target;
  }

  explicit RenderTargetSlots(std::vector<reshade::api::resource_view> views)
      : ResourceViewSlots(std::move(views)) {
    usage = reshade::api::resource_usage::render_target;
  }
};

struct ShaderResourceSlots : ResourceViewSlots {
  ShaderResourceSlots() {
    usage = reshade::api::resource_usage::shader_resource;
  }

  explicit ShaderResourceSlots(std::vector<reshade::api::resource_view> views)
      : ResourceViewSlots(std::move(views)) {
    usage = reshade::api::resource_usage::shader_resource;
  }
};

struct UnorderedAccessSlots : ResourceViewSlots {
  UnorderedAccessSlots() {
    usage = reshade::api::resource_usage::unordered_access;
  }

  explicit UnorderedAccessSlots(std::vector<reshade::api::resource_view> views)
      : ResourceViewSlots(std::move(views)) {
    usage = reshade::api::resource_usage::unordered_access;
  }
};

class RenderPass {
 public:
  RenderTargetSlots render_target_slots;
  ShaderResourceSlots shader_resource_slots;
  UnorderedAccessSlots unordered_access_slots;

  std::vector<reshade::api::sampler_desc> sampler_descs;
  std::vector<reshade::api::sampler> samplers;
  std::vector<reshade::api::sampler> generated_samplers;

  std::unordered_map<ConstantBuffersSlots, std::span<const float>, ConstantBuffersSlotsHash> push_constants;

  bool auto_generate_descriptor_table_updates{true};
  std::vector<reshade::api::descriptor_table_update> descriptor_table_updates;

  reshade::api::pipeline_layout layout{0};
  bool generated_layout = false;

  reshade::api::pipeline pipeline{0};
  pipeline::PipelineSubobjects pipeline_subobjects{};
  bool auto_generate_render_target_formats{true};
  bool generated_pipeline = false;

  bool auto_generate_viewport{true};
  std::vector<reshade::api::viewport> viewports;
  bool auto_generate_scissors{true};
  std::vector<reshade::api::rect> scissors;

  bool flush_after_render{false};
  bool revert_state_after_render{true};

  std::optional<uint32_t> primary_texture_width;
  std::optional<uint32_t> primary_texture_height;
  std::optional<uint32_t> primary_texture_depth;

  uint32_t dispatch_texture2d_tilesize = 16;
  std::optional<std::tuple<uint32_t, uint32_t, uint32_t>> dispatch_group_counts;

  [[nodiscard]] bool IsComputePass() const {
    return !pipeline_subobjects.compute_shader.empty();
  }

  bool Render(
      reshade::api::command_list* cmd_list,
      reshade::api::command_queue* queue = nullptr) {
    if (cmd_list == nullptr) return false;

    auto* device = cmd_list->get_device();
    if (device == nullptr) return false;

#ifdef DEBUG_LEVEL_2
    reshade::log::message(reshade::log::level::info, "utils::render::RenderPass(DEBUG_LEVEL_2 active)");
#endif

    if (!this->render_target_slots.Populate(cmd_list)) {
#ifdef DEBUG_LEVEL_2
      reshade::log::message(reshade::log::level::warning, "utils::render::RenderPass(RenderTargetSlots::Populate failed)");
#endif
      return false;
    }
    if (!this->shader_resource_slots.Populate(cmd_list)) {
#ifdef DEBUG_LEVEL_2
      reshade::log::message(reshade::log::level::warning, "utils::render::RenderPass(ShaderResourceSlots::Populate failed)");
#endif
      return false;
    }
    if (!this->unordered_access_slots.Populate(cmd_list)) {
#ifdef DEBUG_LEVEL_2
      reshade::log::message(reshade::log::level::warning, "utils::render::RenderPass(UnorderedAccessSlots::Populate failed)");
#endif
      return false;
    }

#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::render::RenderPass(rt_views=" << this->render_target_slots.views.size();
      for (size_t i = 0; i < this->render_target_slots.views.size(); ++i) {
        const auto& view = this->render_target_slots.views[i];
        auto res = device->get_resource_from_view(view);
        auto desc = device->get_resource_view_desc(view);
        s << " [" << i << " view=" << PRINT_PTR(view.handle)
          << " res=" << PRINT_PTR(res.handle)
          << " format=" << desc.format
          << " type=" << desc.type << "]";
      }
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
    {
      std::stringstream s;
      s << "utils::render::RenderPass(srv_views=" << this->shader_resource_slots.views.size();
      for (size_t i = 0; i < this->shader_resource_slots.views.size(); ++i) {
        const auto& view = this->shader_resource_slots.views[i];
        auto res = device->get_resource_from_view(view);
        auto desc = device->get_resource_view_desc(view);
        s << " [" << i << " view=" << PRINT_PTR(view.handle)
          << " res=" << PRINT_PTR(res.handle)
          << " format=" << desc.format
          << " type=" << desc.type << "]";
      }
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
#endif

    // Generate Samplers

    auto sampler_size = samplers.size();
    auto sampler_desc_size = sampler_descs.size();
    if (sampler_size < sampler_desc_size) {
      samplers.resize(sampler_desc_size);
      auto sampler_insert_index = sampler_size;
      while (sampler_insert_index < sampler_desc_size) {
        reshade::api::sampler sampler = {0};
        device->create_sampler(sampler_descs[sampler_insert_index], &sampler);
        samplers[sampler_insert_index] = sampler;
        generated_samplers.push_back(sampler);
        ++sampler_insert_index;
      }
    }

    if (this->auto_generate_descriptor_table_updates) {
      descriptor_table_updates.clear();
      // Samplers
      if (!samplers.empty()) {
        descriptor_table_updates.push_back({
            .table = {},
            .binding = 0,
            .array_offset = 0,
            .count = static_cast<uint32_t>(samplers.size()),
            .type = reshade::api::descriptor_type::sampler,
            .descriptors = samplers.data(),
        });
      }

      // SRVs
      if (!this->shader_resource_slots.views.empty()) {
        descriptor_table_updates.push_back({
            .table = {},
            .binding = 0,
            .array_offset = 0,
            .count = static_cast<uint32_t>(this->shader_resource_slots.views.size()),
            .type = reshade::api::descriptor_type::texture_shader_resource_view,
            .descriptors = this->shader_resource_slots.views.data(),
        });
      }

      // UAVs
      if (!this->unordered_access_slots.views.empty()) {
        descriptor_table_updates.push_back({
            .table = {},
            .binding = 0,
            .array_offset = 0,
            .count = static_cast<uint32_t>(this->unordered_access_slots.views.size()),
            .type = reshade::api::descriptor_type::texture_unordered_access_view,
            .descriptors = this->unordered_access_slots.views.data(),
        });
      }
      this->auto_generate_descriptor_table_updates = false;
    }

#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::render::RenderPass(descriptor_table_updates=" << descriptor_table_updates.size();
      for (size_t i = 0; i < descriptor_table_updates.size(); ++i) {
        const auto& u = descriptor_table_updates[i];
        s << " [" << i << " type=" << u.type << " count=" << u.count << "]";
      }
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
#endif

    // Build pipeline layout if not supplied
    if (this->layout.handle == 0u) {
      std::vector<reshade::api::pipeline_layout_param> layout_params = {};
      // Samplers
      if (!samplers.empty()) {
        reshade::api::pipeline_layout_param param_sampler;
        param_sampler.type = reshade::api::pipeline_layout_param_type::push_descriptors;
        param_sampler.push_descriptors.count = samplers.size();
        param_sampler.push_descriptors.type = reshade::api::descriptor_type::sampler;
        layout_params.push_back(param_sampler);
      }

      if (!this->shader_resource_slots.views.empty()) {
        reshade::api::pipeline_layout_param param_srv;
        param_srv.type = reshade::api::pipeline_layout_param_type::push_descriptors;
        param_srv.push_descriptors.count = this->shader_resource_slots.views.size();
        param_srv.push_descriptors.type = reshade::api::descriptor_type::texture_shader_resource_view;
        layout_params.push_back(param_srv);
      }

      if (!this->unordered_access_slots.views.empty()) {
        reshade::api::pipeline_layout_param param_uav;
        param_uav.type = reshade::api::pipeline_layout_param_type::push_descriptors;
        param_uav.push_descriptors.count = this->unordered_access_slots.views.size();
        param_uav.push_descriptors.type = reshade::api::descriptor_type::texture_unordered_access_view;
        layout_params.push_back(param_uav);
      }

      if (!push_constants.empty()) {
        for (const auto& [slot_space, span] : push_constants) {
          reshade::api::pipeline_layout_param param_push_constants;
          param_push_constants.type = reshade::api::pipeline_layout_param_type::push_constants;
          if (device->get_api() == reshade::api::device_api::d3d12 || device->get_api() == reshade::api::device_api::vulkan) {
            param_push_constants.push_constants.count = span.size();
          } else {
            param_push_constants.push_constants.count = 1;
          }
          param_push_constants.push_constants.dx_register_index = slot_space.slot;
          param_push_constants.push_constants.dx_register_space = slot_space.space;
          layout_params.push_back(param_push_constants);
        }
      }

#ifdef DEBUG_LEVEL_2
      {
        std::stringstream s;
        s << "utils::render::RenderPass(layout_params=" << layout_params.size();
        for (size_t i = 0; i < layout_params.size(); ++i) {
          const auto& p = layout_params[i];
          s << " [" << i << " type=" << p.type;
          if (p.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
            s << " desc_type=" << p.push_descriptors.type
              << " count=" << p.push_descriptors.count;
          } else if (p.type == reshade::api::pipeline_layout_param_type::push_constants) {
            s << " dx_reg=" << p.push_constants.dx_register_index
              << " space=" << p.push_constants.dx_register_space
              << " count=" << p.push_constants.count;
          }
          s << "]";
        }
        s << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
#endif

      bool create_pipeline_layout_result = device->create_pipeline_layout(layout_params.size(), layout_params.data(), &this->layout);
      if (!create_pipeline_layout_result) {
#ifdef DEBUG_LEVEL_2
        reshade::log::message(reshade::log::level::warning, "utils::render::RenderPass(create_pipeline_layout failed)");
#endif
        assert(create_pipeline_layout_result != false);
        return false;
      }
      generated_layout = true;
    }

    if (this->pipeline.handle == 0) {
      if (this->auto_generate_render_target_formats) {
        std::vector<reshade::api::format> rt_formats;
        for (const auto& rtv : this->render_target_slots.views) {
          reshade::api::resource_view_desc res_info_desc;
          auto* res_info = renodx::utils::resource::GetResourceViewInfo(rtv);
          if (res_info == nullptr) {
            assert(false && "Failed to get RTV ResourceViewInfo.");
            res_info_desc = device->get_resource_view_desc(rtv);
          } else {
            res_info_desc = res_info->desc;
          }
          if (res_info_desc.type == reshade::api::resource_view_type::unknown) {
#ifdef DEBUG_LEVEL_2
            {
              std::stringstream s;
              s << "utils::render::RenderPass(RTV ResourceViewInfo has unknown type, rtv=" << PRINT_PTR(rtv.handle) << ")";
              reshade::log::message(reshade::log::level::warning, s.str().c_str());
            }
#endif
            assert(false && "RTV ResourceViewInfo has unknown type.");
            return false;
          }
          rt_formats.push_back(res_info_desc.format);
        }
        pipeline_subobjects.render_target_formats = rt_formats;
        this->auto_generate_render_target_formats = false;
      }
      this->pipeline = renodx::utils::pipeline::CreateRenderPipeline(
          device,
          this->layout,
          this->pipeline_subobjects);
      if (this->pipeline.handle == 0) {
#ifdef DEBUG_LEVEL_2
        reshade::log::message(reshade::log::level::warning, "utils::render::RenderPass(CreateRenderPipeline failed)");
#endif
        assert(this->pipeline.handle != 0);
        return false;
      }
      this->generated_pipeline = true;
    }

    auto render_target_views_size = this->render_target_slots.views.size();
    auto render_pass_render_target_descs_size = this->render_target_slots.render_pass_descs.size();

    if (render_pass_render_target_descs_size < render_target_views_size) {
      this->render_target_slots.render_pass_descs.resize(render_target_views_size);
      auto insert_index = render_pass_render_target_descs_size;
      while (insert_index < render_target_views_size) {
        reshade::api::render_pass_render_target_desc rt_desc{
            .view = {this->render_target_slots.views[insert_index]},
        };
        this->render_target_slots.render_pass_descs[insert_index] = rt_desc;
        ++insert_index;
      }
    }

    std::optional<utils::state::CommandListState> previous_state;
    if (this->revert_state_after_render) {
      auto* current_state = utils::state::GetCurrentState(cmd_list);
      if (current_state != nullptr) {
        previous_state.emplace(*current_state);
      }
    }

    cmd_list->begin_render_pass(
        static_cast<uint32_t>(this->render_target_slots.render_pass_descs.size()),
        this->render_target_slots.render_pass_descs.data(),
        nullptr);

    bool is_compute = this->IsComputePass();
    // TODO(clshortfuse): Allocate/bind descriptor tables instead
    auto descriptor_stage = is_compute
                                ? reshade::api::shader_stage::all_compute
                                : reshade::api::shader_stage::all_graphics;
    auto current_layout_param_index = 0;
    while (current_layout_param_index < descriptor_table_updates.size()) {
#ifdef DEBUG_LEVEL_2
      {
        std::stringstream s;
        const auto& u = descriptor_table_updates[current_layout_param_index];
        s << "utils::render::RenderPass(push_descriptors index=" << current_layout_param_index
          << " type=" << u.type
          << " count=" << u.count << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
#endif
      cmd_list->push_descriptors(
          descriptor_stage,
          this->layout,
          current_layout_param_index,
          descriptor_table_updates[current_layout_param_index]);
      ++current_layout_param_index;
    }

    // Push constants
    for (const auto& [slot_space, span] : push_constants) {
      cmd_list->push_constants(
          descriptor_stage,
          this->layout,
          current_layout_param_index,
          0,
          static_cast<uint32_t>(span.size()),
          span.data());
      ++current_layout_param_index;
    }

    if (!is_compute) {
      // Viewport / scissor configuration
      if (this->auto_generate_viewport && this->viewports.size() != this->render_target_slots.views.size()) {
        this->viewports.clear();
        const auto view_count = this->render_target_slots.views.size();
        for (std::size_t i = 0; i < view_count; ++i) {
          reshade::api::resource_desc desc = {};
          bool has_desc = false;

          if (this->render_target_slots.resource_descs.size() > i) {
            desc = this->render_target_slots.resource_descs[i];
            has_desc = true;
          }

          if (!has_desc && this->render_target_slots.view_infos.size() > i) {
            auto* view_info = this->render_target_slots.view_infos[i];
            if (view_info != nullptr) {
              auto* res_info = renodx::utils::resource::GetResourceInfo(view_info->original_resource, false);
              desc = (res_info != nullptr) ? res_info->desc : device->get_resource_desc(view_info->original_resource);
              has_desc = true;
            }
          }

          if (!has_desc && this->render_target_slots.resources.size() > i) {
            const auto& resource = this->render_target_slots.resources[i];
            auto* res_info = renodx::utils::resource::GetResourceInfo(resource, false);
            desc = (res_info != nullptr) ? res_info->desc : device->get_resource_desc(resource);
            has_desc = true;
          }

          if (!has_desc) {
            const auto& rtv = this->render_target_slots.views[i];
            auto* rtv_info = renodx::utils::resource::GetResourceViewInfo(rtv);
            if (rtv_info != nullptr) {
              auto* rtv_res_info = renodx::utils::resource::GetResourceInfo(rtv_info->original_resource, false);
              desc = (rtv_res_info != nullptr) ? rtv_res_info->desc : device->get_resource_desc(rtv_info->original_resource);
              has_desc = true;
            } else {
              auto resource = device->get_resource_from_view(rtv);
              if (resource.handle == 0) {
#ifdef DEBUG_LEVEL_2
                reshade::log::message(reshade::log::level::warning, "utils::render::RenderPass(get_resource_from_view failed)");
#endif
                assert(false);
                return false;
              }
              desc = device->get_resource_desc(resource);
              has_desc = true;
            }
          }

          if (!has_desc || desc.type == reshade::api::resource_type::unknown) {
#ifdef DEBUG_LEVEL_2
            {
              std::stringstream s;
              s << "utils::render::RenderPass(viewport desc unavailable, rtv=";
              if (this->render_target_slots.views.size() > i) {
                s << PRINT_PTR(this->render_target_slots.views[i].handle);
              } else {
                s << "n/a";
              }
              s << ")";
              reshade::log::message(reshade::log::level::warning, s.str().c_str());
            }
#endif
            assert(false);
            return false;
          }

          reshade::api::viewport vp{
              .x = 0.0f,
              .y = 0.0f,
              .width = static_cast<float>(desc.texture.width),
              .height = static_cast<float>(desc.texture.height),
              .min_depth = 0.0f,
              .max_depth = 1.0f};
          this->viewports.push_back(vp);
        }
      }
      if (this->auto_generate_scissors && this->scissors.size() != this->viewports.size()) {
        this->scissors.clear();
        for (const auto& viewport : this->viewports) {
          reshade::api::rect sc{
              .left = static_cast<int32_t>(viewport.x),
              .top = static_cast<int32_t>(viewport.y),
              .right = static_cast<int32_t>(viewport.x + viewport.width),
              .bottom = static_cast<int32_t>(viewport.y + viewport.height)};
          this->scissors.push_back(sc);
        }
      }

      cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_graphics, this->pipeline);
      cmd_list->bind_viewports(0, this->viewports.size(), this->viewports.data());
      cmd_list->bind_scissor_rects(0, this->scissors.size(), this->scissors.data());
      cmd_list->draw(3, 1, 0, 0);
    } else {
      cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_compute, this->pipeline);
      if (this->dispatch_group_counts.has_value()) {
        const auto& counts = *dispatch_group_counts;
        cmd_list->dispatch(std::get<0>(counts), std::get<1>(counts), std::get<2>(counts));
      } else {
      }
    }

    cmd_list->end_render_pass();

    if (this->flush_after_render) {
      assert(queue != nullptr);
      queue->flush_immediate_command_list();
    }

    // Restore previous state
    if (previous_state.has_value()) {
      previous_state->Apply(cmd_list);
    }
    return true;
  }

  static void DestroyGeneratedViews(reshade::api::command_list* cmd_list,
                                    std::vector<reshade::api::resource_view>* generated_resource_views) {
    auto* device = cmd_list->get_device();
    for (const auto& view : *generated_resource_views) {
      if (view.handle == 0) continue;
      device->destroy_resource_view(view);
      auto* info = renodx::utils::resource::GetResourceViewInfo(view);
      if (info == nullptr) continue;
      info->destroyed = true;
    }
    generated_resource_views->clear();
  }

  static void DestroyGeneratedViews(reshade::api::device* device,
                                    std::vector<reshade::api::resource_view>* generated_resource_views) {
    if (device == nullptr) return;
    for (const auto& view : *generated_resource_views) {
      if (view.handle == 0) continue;
      device->destroy_resource_view(view);
      auto* info = renodx::utils::resource::GetResourceViewInfo(view);
      if (info == nullptr) continue;
      info->destroyed = true;
    }
    generated_resource_views->clear();
  }

  void InvalidateRenderTargets(reshade::api::command_list* cmd_list) {
    DestroyGeneratedViews(cmd_list, &this->render_target_slots.generated_views);
    this->render_target_slots.views.clear();
    this->render_target_slots.view_descs.clear();
    this->render_target_slots.view_infos.clear();
    this->render_target_slots.resources.clear();
    this->render_target_slots.resource_descs.clear();
    this->render_target_slots.resource_infos.clear();
    this->render_target_slots.render_pass_descs.clear();
    this->viewports.clear();
    this->scissors.clear();
  }

  void DestroyAll(reshade::api::command_list* cmd_list) {
    DestroyGeneratedViews(cmd_list, &this->render_target_slots.generated_views);
    DestroyGeneratedViews(cmd_list, &this->shader_resource_slots.generated_views);
    DestroyGeneratedViews(cmd_list, &this->unordered_access_slots.generated_views);

    auto* device = cmd_list->get_device();

    for (const auto& sampler : generated_samplers) {
      if (sampler.handle == 0) continue;
      device->destroy_sampler(sampler);
    }
    generated_samplers.clear();

    if (generated_layout && layout.handle != 0) {
      device->destroy_pipeline_layout(layout);
      layout.handle = 0;
      generated_layout = false;
    }

    if (generated_pipeline && pipeline.handle != 0) {
      device->destroy_pipeline(pipeline);
      pipeline.handle = 0;
      generated_pipeline = false;
    }
  }

  void DestroyAll(reshade::api::device* device) {
    DestroyGeneratedViews(device, &this->render_target_slots.generated_views);
    DestroyGeneratedViews(device, &this->shader_resource_slots.generated_views);
    DestroyGeneratedViews(device, &this->unordered_access_slots.generated_views);

    if (device == nullptr) return;

    for (const auto& sampler : generated_samplers) {
      if (sampler.handle == 0) continue;
      device->destroy_sampler(sampler);
    }
    generated_samplers.clear();

    if (generated_layout && layout.handle != 0) {
      device->destroy_pipeline_layout(layout);
      layout.handle = 0;
      generated_layout = false;
    }

    if (generated_pipeline && pipeline.handle != 0) {
      device->destroy_pipeline(pipeline);
      pipeline.handle = 0;
      generated_pipeline = false;
    }
  }
};

}  // namespace renodx::utils::render
