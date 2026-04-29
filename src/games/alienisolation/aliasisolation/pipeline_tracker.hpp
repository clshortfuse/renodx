#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <span>
#include <unordered_map>

#include <include/reshade.hpp>

#include "../../../utils/bitwise.hpp"
#include "./logging.hpp"
#include "./shader_ids.hpp"

namespace alienisolation::aliasisolation::pipeline_tracker {

struct PipelineShaders {
  ShaderId vertex = ShaderId::Unknown;
  ShaderId pixel = ShaderId::Unknown;
  ShaderId compute = ShaderId::Unknown;
};

struct BoundShaders {
  ShaderId vertex = ShaderId::Unknown;
  ShaderId pixel = ShaderId::Unknown;
  ShaderId compute = ShaderId::Unknown;
};

inline std::unordered_map<uint64_t, PipelineShaders> pipelines;
inline std::array<bool, static_cast<size_t>(ShaderId::Count)> logged_shaders = {};

inline bool HasTrackedShader(const PipelineShaders& shaders) {
  return shaders.vertex != ShaderId::Unknown || shaders.pixel != ShaderId::Unknown || shaders.compute != ShaderId::Unknown;
}

inline void LogShaderDetection(ShaderId id, const char* stage, reshade::api::pipeline pipeline) {
  if (id == ShaderId::Unknown) return;

  const auto index = static_cast<size_t>(id);
  if (index >= logged_shaders.size() || logged_shaders[index]) return;

  logged_shaders[index] = true;
  logging::Info("detected ", stage, " shader ", ShaderIdName(id), " pipeline=", logging::Hex(pipeline.handle));
}

inline void OnInitPipeline(
    reshade::api::device*,
    reshade::api::pipeline_layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  PipelineShaders shaders = {};

  for (uint32_t i = 0; i < subobject_count; ++i) {
    const auto& subobject = subobjects[i];
    switch (subobject.type) {
      case reshade::api::pipeline_subobject_type::vertex_shader:
      case reshade::api::pipeline_subobject_type::pixel_shader:
      case reshade::api::pipeline_subobject_type::compute_shader: {
        const auto* shader_descs = static_cast<const reshade::api::shader_desc*>(subobject.data);
        if (shader_descs == nullptr) break;
        for (uint32_t j = 0; j < subobject.count; ++j) {
          const auto& desc = shader_descs[j];
          if (desc.code == nullptr || desc.code_size == 0u) continue;
          const auto bytes = std::span<const uint8_t>(static_cast<const uint8_t*>(desc.code), desc.code_size);
          if (subobject.type == reshade::api::pipeline_subobject_type::vertex_shader) {
            const ShaderId id = IdentifyVertexShader(bytes);
            if (id != ShaderId::Unknown) {
              shaders.vertex = id;
              LogShaderDetection(id, "vertex", pipeline);
            }
          } else if (subobject.type == reshade::api::pipeline_subobject_type::pixel_shader) {
            const ShaderId id = IdentifyPixelShader(bytes);
            if (id != ShaderId::Unknown) {
              shaders.pixel = id;
              LogShaderDetection(id, "pixel", pipeline);
            }
          }
        }
        break;
      }
      default:
        break;
    }
  }

  if (HasTrackedShader(shaders)) {
    pipelines[pipeline.handle] = shaders;
  }
}

inline void OnDestroyPipeline(reshade::api::device*, reshade::api::pipeline pipeline) {
  pipelines.erase(pipeline.handle);
}

inline void BindPipeline(BoundShaders& bound, reshade::api::pipeline_stage stages, reshade::api::pipeline pipeline) {
  auto it = pipelines.find(pipeline.handle);
  const PipelineShaders shaders = (it != pipelines.end()) ? it->second : PipelineShaders{};

  if (stages == reshade::api::pipeline_stage::all) {
    bound = {};
  }

  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::pipeline_stage::all_graphics)
      || renodx::utils::bitwise::HasFlag(stages, reshade::api::pipeline_stage::vertex_shader)) {
    bound.vertex = shaders.vertex;
  }
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::pipeline_stage::all_graphics)
      || renodx::utils::bitwise::HasFlag(stages, reshade::api::pipeline_stage::pixel_shader)) {
    bound.pixel = shaders.pixel;
  }
  if (renodx::utils::bitwise::HasFlag(stages, reshade::api::pipeline_stage::all_compute)
      || renodx::utils::bitwise::HasFlag(stages, reshade::api::pipeline_stage::compute_shader)) {
    bound.compute = shaders.compute;
  }
}

}  // namespace alienisolation::aliasisolation::pipeline_tracker
