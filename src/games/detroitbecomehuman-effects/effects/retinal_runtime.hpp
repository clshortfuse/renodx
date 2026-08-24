/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <mutex>
#include <type_traits>

#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "dof_runtime.hpp"
#include "retinal_math.hpp"

namespace renodx::games::detroitbecomehuman::retinal {

// The caller must populate this only from the exact, reflected b16 storage
// image of Detroit's 0xAC7A8193 DOF composite dispatch. Runtime deliberately
// does not perform process-wide descriptor tracing or infer an arbitrary UAV.
// After a successful Run(), the caller must restore Detroit's native Vulkan
// pipeline, descriptor set, b52 dynamic offset, and 112-byte push payload
// through the capture bridge.
struct CompositeOutputSnapshot {
  reshade::api::resource resource = {0};
  reshade::api::resource_view unordered_access_view = {0};
  std::uint32_t width = 0u;
  std::uint32_t height = 0u;
  std::uint32_t mip_level = 0u;
  std::uint32_t array_layer = 0u;
  bool valid = false;
};

struct RuntimeInput {
  CompositeOutputSnapshot output = {};
  dof::RuntimeMode effective_mode = dof::RuntimeMode::kVanilla;
  Float2 fixation_uv = {0.5f, 0.5f};
  float fixation_blend = 1.f;
  float horizontal_screen_angle_degrees =
      kDefaultHorizontalScreenAngleDegrees;
  float maximum_sigma_pixels = kMaximumSigmaPixels;
};

enum class RunResult : std::uint32_t {
  kDispatched = 0u,
  kNotRetinalMode,
  kMissingCompositeCapture,
  kUnsupportedDevice,
  kInvalidResource,
  kUnsupportedResource,
  kResourceCapacityExceeded,
  kResourceCreationFailed,
  kPipelineCreationFailed,
  kDebugOverlayActive,
  kBypassedZeroEffect,
  kBarrierUnavailable,
  kStateRestoreFailed,
};

class Runtime {
 public:
  Runtime() = default;
  Runtime(const Runtime&) = delete;
  Runtime& operator=(const Runtime&) = delete;

  ~Runtime() = default;

  [[nodiscard]] RunResult Run(
      reshade::api::command_list* command_list,
      const RuntimeInput& input) {
    if (!dof::IsRetinalMode(input.effective_mode)) {
      return RunResult::kNotRetinalMode;
    }
    if (!input.output.valid || input.output.resource.handle == 0u
        || input.output.unordered_access_view.handle == 0u
        || input.output.width == 0u || input.output.height == 0u) {
      return RunResult::kMissingCompositeCapture;
    }
    if (command_list == nullptr) return RunResult::kUnsupportedDevice;
    auto* device = command_list->get_device();
    if (device == nullptr
        || device->get_api() != reshade::api::device_api::vulkan
        || !device->check_capability(
            reshade::api::device_caps::partial_push_descriptor_updates)) {
      return RunResult::kUnsupportedDevice;
    }

    const std::lock_guard lock(mutex_);
    if (owner_device_ != nullptr && owner_device_ != device) {
      return RunResult::kUnsupportedDevice;
    }
    ValidatedOutput validated = {};
    const RunResult validation_result = ValidateOutput(
        device, input.output, &validated);
    if (validation_result != RunResult::kDispatched) {
      return validation_result;
    }
    if (!EnsurePipelines(device)) {
      return RunResult::kPipelineCreationFailed;
    }
    SurfaceResources* surface = nullptr;
    const RunResult surface_result = EnsureSurface(
        device, validated, &surface);
    if (surface_result != RunResult::kDispatched || surface == nullptr) {
      return surface_result;
    }

    const Float2 fixation_uv = SanitizeFixationUv(input.fixation_uv);
    const float screen_angle = SanitizeHorizontalScreenAngle(
        input.horizontal_screen_angle_degrees);
    const float maximum_sigma = std::clamp(
        FiniteOr(input.maximum_sigma_pixels, kMaximumSigmaPixels),
        0.f,
        kMaximumSigmaPixels);
    const float output_width = static_cast<float>(validated.width);
    const float output_height = static_cast<float>(validated.height);
    const float tan_half_horizontal = std::tan(
        screen_angle * kDegreesToRadians * 0.5f);
    const float aspect = output_width / output_height;
    const float tan_half_vertical = tan_half_horizontal / aspect;
    const float vertical_angle = 2.f * std::atan(tan_half_vertical)
                                 * kRadiansToDegrees;
    const FilterConstants constants = {
        .fixation_uv = fixation_uv,
        .inverse_output_size = {
            1.f / output_width,
            1.f / output_height,
        },
        .output_size = {
            output_width,
            output_height,
        },
        .tan_half_horizontal = tan_half_horizontal,
        .tan_half_vertical = tan_half_vertical,
        .horizontal_pixels_per_degree = output_width / screen_angle,
        .vertical_pixels_per_degree = output_height
                                      / std::max(vertical_angle, 1.0e-6f),
        .fixation_blend = SanitizeFixationBlend(input.fixation_blend),
        .maximum_sigma_pixels = maximum_sigma,
        .high_quality = dof::IsHighQualityMode(input.effective_mode) ? 1.f : 0.f,
    };

    // Native composite leaves b16 in GENERAL/UAV state. The horizontal pass
    // samples it into the private full-resolution texture; the vertical pass
    // writes back to the same b16 image and deliberately leaves it in UAV
    // state for Detroit's existing post-composite barrier.
    command_list->barrier(
        validated.resource,
        reshade::api::resource_usage::unordered_access,
        reshade::api::resource_usage::shader_resource);
    command_list->barrier(
        surface->scratch_resource,
        reshade::api::resource_usage::shader_resource,
        reshade::api::resource_usage::unordered_access);

    BindPass(
        command_list,
        horizontal_pipeline_,
        surface->source_srv,
        surface->scratch_uav,
        constants);
    command_list->dispatch(
        (validated.width + 7u) / 8u,
        (validated.height + 7u) / 8u,
        1u);

    command_list->barrier(
        surface->scratch_resource,
        reshade::api::resource_usage::unordered_access,
        reshade::api::resource_usage::shader_resource);
    command_list->barrier(
        validated.resource,
        reshade::api::resource_usage::shader_resource,
        reshade::api::resource_usage::unordered_access);

    BindPass(
        command_list,
        vertical_pipeline_,
        surface->scratch_srv,
        validated.unordered_access_view,
        constants);
    command_list->dispatch(
        (validated.width + 7u) / 8u,
        (validated.height + 7u) / 8u,
        1u);

    return RunResult::kDispatched;
  }

  void OnDestroyResource(
      reshade::api::device* device,
      reshade::api::resource resource) {
    if (device == nullptr || resource.handle == 0u) return;
    const std::lock_guard lock(mutex_);
    if (owner_device_ != device) return;
    for (auto& surface : surfaces_) {
      if (surface.source_resource.handle == resource.handle) {
        DestroySurface(device, &surface);
      }
    }
  }

  void Destroy(reshade::api::device* device) {
    if (device == nullptr) return;
    const std::lock_guard lock(mutex_);
    if (owner_device_ != device) return;
    for (auto& surface : surfaces_) DestroySurface(device, &surface);
    DestroyPipelines(device);
    owner_device_ = nullptr;
  }

 private:
  static constexpr std::size_t kMaximumTrackedOutputs = 4u;

  struct FilterConstants {
    Float2 fixation_uv;
    Float2 inverse_output_size;
    Float2 output_size;
    float tan_half_horizontal;
    float tan_half_vertical;
    float horizontal_pixels_per_degree;
    float vertical_pixels_per_degree;
    float fixation_blend;
    float maximum_sigma_pixels;
    float high_quality;
  };
  static_assert(sizeof(FilterConstants) == 13u * sizeof(float));

  struct ValidatedOutput {
    reshade::api::resource resource = {0};
    reshade::api::resource_view unordered_access_view = {0};
    std::uint32_t width = 0u;
    std::uint32_t height = 0u;
    reshade::api::format resource_format = reshade::api::format::unknown;
    reshade::api::format view_format = reshade::api::format::unknown;
  };

  struct SurfaceResources {
    reshade::api::resource source_resource = {0};
    reshade::api::resource_view source_srv = {0};
    reshade::api::resource scratch_resource = {0};
    reshade::api::resource_view scratch_srv = {0};
    reshade::api::resource_view scratch_uav = {0};
    std::uint32_t width = 0u;
    std::uint32_t height = 0u;
  };

  template <typename Flags>
  [[nodiscard]] static bool HasAllFlags(Flags value, Flags required) noexcept {
    using Underlying = std::underlying_type_t<Flags>;
    return (static_cast<Underlying>(value) & static_cast<Underlying>(required))
           == static_cast<Underlying>(required);
  }

  [[nodiscard]] static bool IsSupportedFormat(
      reshade::api::format resource_format,
      reshade::api::format view_format) noexcept {
    const bool resource_supported =
        resource_format == reshade::api::format::r16g16b16a16_float
        || resource_format == reshade::api::format::r16g16b16a16_typeless;
    return resource_supported
           && view_format == reshade::api::format::r16g16b16a16_float;
  }

  [[nodiscard]] static RunResult ValidateOutput(
      reshade::api::device* device,
      const CompositeOutputSnapshot& snapshot,
      ValidatedOutput* output) {
    if (device == nullptr || output == nullptr) {
      return RunResult::kInvalidResource;
    }
    if (snapshot.mip_level != 0u || snapshot.array_layer != 0u) {
      return RunResult::kUnsupportedResource;
    }
    const reshade::api::resource resource_from_view =
        device->get_resource_from_view(snapshot.unordered_access_view);
    if (resource_from_view.handle == 0u
        || resource_from_view.handle != snapshot.resource.handle) {
      return RunResult::kInvalidResource;
    }

    const reshade::api::resource_desc resource_desc =
        device->get_resource_desc(snapshot.resource);
    const reshade::api::resource_view_desc view_desc =
        device->get_resource_view_desc(snapshot.unordered_access_view);
    if (resource_desc.type != reshade::api::resource_type::texture_2d
        || resource_desc.texture.depth_or_layers != 1u
        || resource_desc.texture.levels != 1u
        || resource_desc.texture.samples != 1u
        || resource_desc.texture.width != snapshot.width
        || resource_desc.texture.height != snapshot.height) {
      return RunResult::kUnsupportedResource;
    }
    const auto required_usage =
        reshade::api::resource_usage::shader_resource
        | reshade::api::resource_usage::unordered_access;
    if (!HasAllFlags(resource_desc.usage, required_usage)) {
      return RunResult::kUnsupportedResource;
    }

    reshade::api::format view_format = view_desc.format;
    if (view_format == reshade::api::format::unknown) {
      view_format = reshade::api::format_to_default_typed(
          resource_desc.texture.format);
    }
    if (!IsSupportedFormat(resource_desc.texture.format, view_format)) {
      return RunResult::kUnsupportedResource;
    }
    *output = {
        .resource = snapshot.resource,
        .unordered_access_view = snapshot.unordered_access_view,
        .width = snapshot.width,
        .height = snapshot.height,
        .resource_format = resource_desc.texture.format,
        .view_format = view_format,
    };
    return RunResult::kDispatched;
  }

  [[nodiscard]] bool EnsurePipelines(reshade::api::device* device) {
    if (owner_device_ != nullptr && owner_device_ != device) return false;
    if (pipeline_layout_.handle != 0u
        && horizontal_pipeline_.handle != 0u
        && vertical_pipeline_.handle != 0u
        && linear_sampler_.handle != 0u) {
      return true;
    }
    owner_device_ = device;
    DestroyPipelines(device);

    // VK_KHR_push_descriptor permits only one push-descriptor set per pipeline
    // layout. A separate layout parameter for sampler/SRV/UAV creates three
    // push sets and makes vkCreatePipelineLayout fail. Describe all three
    // bindings as ranges in a single set instead.
    const std::array<reshade::api::descriptor_range, 3u> ranges = {{
        {
            .binding = 0u,
            .dx_register_index = 0u,
            .dx_register_space = 0u,
            .count = 1u,
            .visibility = reshade::api::shader_stage::compute,
            .array_size = 1u,
            .type = reshade::api::descriptor_type::sampler,
        },
        {
            .binding = 1u,
            .dx_register_index = 1u,
            .dx_register_space = 0u,
            .count = 1u,
            .visibility = reshade::api::shader_stage::compute,
            .array_size = 1u,
            .type =
                reshade::api::descriptor_type::texture_shader_resource_view,
        },
        {
            .binding = 2u,
            .dx_register_index = 2u,
            .dx_register_space = 0u,
            .count = 1u,
            .visibility = reshade::api::shader_stage::compute,
            .array_size = 1u,
            .type = reshade::api::descriptor_type::texture_unordered_access_view,
        },
    }};
    std::array<reshade::api::pipeline_layout_param, 2u> params = {};
    params[0].type =
        reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges;
    params[0].descriptor_table.count =
        static_cast<std::uint32_t>(ranges.size());
    params[0].descriptor_table.ranges = ranges.data();

    params[1].type = reshade::api::pipeline_layout_param_type::push_constants;
    params[1].push_constants.count = sizeof(FilterConstants) / sizeof(float);
    params[1].push_constants.dx_register_index = 0u;
    params[1].push_constants.dx_register_space = 0u;
    params[1].push_constants.visibility = reshade::api::shader_stage::compute;

    if (!device->create_pipeline_layout(
            static_cast<std::uint32_t>(params.size()),
            params.data(),
            &pipeline_layout_)) {
      DestroyPipelines(device);
      owner_device_ = nullptr;
      return false;
    }

    const reshade::api::sampler_desc sampler_desc = {
        .filter = reshade::api::filter_mode::min_mag_mip_linear,
    };
    if (!device->create_sampler(sampler_desc, &linear_sampler_)) {
      DestroyPipelines(device);
      owner_device_ = nullptr;
      return false;
    }
#ifdef DETROIT_EFFECTS_ADDON
    if (!CreatePipeline(
            device,
            __retinal_horizontal.data(),
            __retinal_horizontal.size(),
            &horizontal_pipeline_)
        || !CreatePipeline(
            device,
            __retinal_vertical.data(),
            __retinal_vertical.size(),
            &vertical_pipeline_)) {
      DestroyPipelines(device);
      owner_device_ = nullptr;
      return false;
    }
    return true;
#else
    DestroyPipelines(device);
    owner_device_ = nullptr;
    return false;
#endif
  }

  [[nodiscard]] bool CreatePipeline(
      reshade::api::device* device,
      const void* code,
      std::size_t code_size,
      reshade::api::pipeline* pipeline) const {
    reshade::api::shader_desc shader_desc = {
        .code = code,
        .code_size = code_size,
    };
    const reshade::api::pipeline_subobject subobject = {
        .type = reshade::api::pipeline_subobject_type::compute_shader,
        .count = 1u,
        .data = &shader_desc,
    };
    return device->create_pipeline(
        pipeline_layout_, 1u, &subobject, pipeline);
  }

  [[nodiscard]] RunResult EnsureSurface(
      reshade::api::device* device,
      const ValidatedOutput& output,
      SurfaceResources** result) {
    for (auto& surface : surfaces_) {
      if (surface.source_resource.handle == output.resource.handle) {
        if (surface.width == output.width && surface.height == output.height
            && surface.source_srv.handle != 0u
            && surface.scratch_resource.handle != 0u
            && surface.scratch_srv.handle != 0u
            && surface.scratch_uav.handle != 0u) {
          *result = &surface;
          return RunResult::kDispatched;
        }
        DestroySurface(device, &surface);
        return CreateSurface(device, output, &surface, result);
      }
    }
    for (auto& surface : surfaces_) {
      if (surface.source_resource.handle == 0u) {
        return CreateSurface(device, output, &surface, result);
      }
    }
    return RunResult::kResourceCapacityExceeded;
  }

  [[nodiscard]] static RunResult CreateSurface(
      reshade::api::device* device,
      const ValidatedOutput& output,
      SurfaceResources* surface,
      SurfaceResources** result) {
    if (device == nullptr || surface == nullptr || result == nullptr) {
      return RunResult::kResourceCreationFailed;
    }
    const reshade::api::resource_view_desc view_desc(
        reshade::api::resource_view_type::texture_2d,
        output.view_format,
        0u,
        1u,
        0u,
        1u);
    if (!device->create_resource_view(
            output.resource,
            reshade::api::resource_usage::shader_resource,
            view_desc,
            &surface->source_srv)) {
      *surface = {};
      return RunResult::kResourceCreationFailed;
    }

    reshade::api::resource_desc scratch_desc = {};
    scratch_desc.type = reshade::api::resource_type::texture_2d;
    scratch_desc.texture = {
        output.width,
        output.height,
        1u,
        1u,
        reshade::api::format::r16g16b16a16_float,
        1u,
    };
    scratch_desc.heap = reshade::api::memory_heap::gpu_only;
    scratch_desc.usage = reshade::api::resource_usage::shader_resource
                         | reshade::api::resource_usage::unordered_access;
    scratch_desc.flags = reshade::api::resource_flags::none;
    if (!device->create_resource(
            scratch_desc,
            nullptr,
            reshade::api::resource_usage::shader_resource,
            &surface->scratch_resource)
        || !device->create_resource_view(
            surface->scratch_resource,
            reshade::api::resource_usage::shader_resource,
            view_desc,
            &surface->scratch_srv)
        || !device->create_resource_view(
            surface->scratch_resource,
            reshade::api::resource_usage::unordered_access,
            view_desc,
            &surface->scratch_uav)) {
      DestroySurface(device, surface);
      return RunResult::kResourceCreationFailed;
    }
    surface->source_resource = output.resource;
    surface->width = output.width;
    surface->height = output.height;
    *result = surface;
    return RunResult::kDispatched;
  }

  void BindPass(
      reshade::api::command_list* command_list,
      reshade::api::pipeline pipeline,
      reshade::api::resource_view source,
      reshade::api::resource_view destination,
      const FilterConstants& constants) const {
    const reshade::api::descriptor_table_update sampler_update = {
        .table = {},
        .binding = 0u,
        .array_offset = 0u,
        .count = 1u,
        .type = reshade::api::descriptor_type::sampler,
        .descriptors = &linear_sampler_,
    };
    const reshade::api::descriptor_table_update source_update = {
        .table = {},
        .binding = 1u,
        .array_offset = 0u,
        .count = 1u,
        .type = reshade::api::descriptor_type::texture_shader_resource_view,
        .descriptors = &source,
    };
    const reshade::api::descriptor_table_update destination_update = {
        .table = {},
        .binding = 2u,
        .array_offset = 0u,
        .count = 1u,
        .type = reshade::api::descriptor_type::texture_unordered_access_view,
        .descriptors = &destination,
    };
    command_list->push_descriptors(
        reshade::api::shader_stage::all_compute,
        pipeline_layout_,
        0u,
        sampler_update);
    command_list->push_descriptors(
        reshade::api::shader_stage::all_compute,
        pipeline_layout_,
        0u,
        source_update);
    command_list->push_descriptors(
        reshade::api::shader_stage::all_compute,
        pipeline_layout_,
        0u,
        destination_update);
    command_list->push_constants(
        reshade::api::shader_stage::all_compute,
        pipeline_layout_,
        1u,
        0u,
        sizeof(FilterConstants) / sizeof(float),
        &constants);
    command_list->bind_pipeline(
        reshade::api::pipeline_stage::all_compute, pipeline);
  }

  static void DestroySurface(
      reshade::api::device* device,
      SurfaceResources* surface) {
    if (device == nullptr || surface == nullptr) return;
    if (surface->source_srv.handle != 0u) {
      device->destroy_resource_view(surface->source_srv);
    }
    if (surface->scratch_srv.handle != 0u) {
      device->destroy_resource_view(surface->scratch_srv);
    }
    if (surface->scratch_uav.handle != 0u) {
      device->destroy_resource_view(surface->scratch_uav);
    }
    if (surface->scratch_resource.handle != 0u) {
      device->destroy_resource(surface->scratch_resource);
    }
    *surface = {};
  }

  void DestroyPipelines(reshade::api::device* device) {
    if (device == nullptr) return;
    if (horizontal_pipeline_.handle != 0u) {
      device->destroy_pipeline(horizontal_pipeline_);
    }
    if (vertical_pipeline_.handle != 0u) {
      device->destroy_pipeline(vertical_pipeline_);
    }
    if (linear_sampler_.handle != 0u) {
      device->destroy_sampler(linear_sampler_);
    }
    if (pipeline_layout_.handle != 0u) {
      device->destroy_pipeline_layout(pipeline_layout_);
    }
    horizontal_pipeline_ = {0};
    vertical_pipeline_ = {0};
    linear_sampler_ = {0};
    pipeline_layout_ = {0};
  }

  std::recursive_mutex mutex_;
  reshade::api::device* owner_device_ = nullptr;
  reshade::api::pipeline_layout pipeline_layout_ = {0};
  reshade::api::pipeline horizontal_pipeline_ = {0};
  reshade::api::pipeline vertical_pipeline_ = {0};
  reshade::api::sampler linear_sampler_ = {0};
  std::array<SurfaceResources, kMaximumTrackedOutputs> surfaces_ = {};
};

}  // namespace renodx::games::detroitbecomehuman::retinal
