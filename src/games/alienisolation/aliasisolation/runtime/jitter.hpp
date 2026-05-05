#pragma once

/*
 * CPU-side jitter injection for Alien Isolation's camera constant buffers.
 *
 * Alias Isolation modifies the game's mapped D3D11 cbuffers before the post
 * passes consume them. This RenoDX version emulates that by identifying the same
 * buffers through shader/register usage, watching map/unmap callbacks, and
 * patching the data on unmap for fullscreen camera rendering only.
 */

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <limits>
#include <unordered_map>

#include <include/reshade.hpp>

#include "./constant_buffers.hpp"
#include "./descriptor_tracker.hpp"
#include "./logging.hpp"

namespace alienisolation::aliasisolation::jitter {

struct Float4 {
  float x = 0.f;
  float y = 0.f;
  float z = 0.f;
  float w = 0.f;
};

struct Matrix4 {
  float m[4][4] = {};
};

struct Matrix4d {
  double m[4][4] = {};
};

// These layouts mirror Alias Isolation's D3D11 constant-buffer structs. Matrices
// are treated as column-major because that matches GLM's memory/indexing in the
// original mod and the HLSL cbuffers dumped from Alien Isolation.
struct CbDefaultXSC {
  Matrix4 ViewProj;
  Matrix4 ViewMatrix;
  Matrix4 SecondaryProj;
  Matrix4 SecondaryViewProj;
  Matrix4 SecondaryInvViewProj;
  Float4 ConstantColour;
  Float4 Time;
  Float4 CameraPosition;
  Float4 InvProjectionParams;
  Float4 SecondaryInvProjectionParams;
  Float4 ShaderDebugParams;
  Float4 ToneMappingDebugParams;
  Float4 HDR_EncodeScale2;
  Float4 EmissiveSurfaceMultiplier;
  Float4 AlphaLight_OffsetScale;
  Float4 TessellationScaleFactor;
  Float4 FogNearColour;
  Float4 FogFarColour;
  Float4 FogParams;
  Float4 AdvanceEnvironmentShaderDebugParams;
  Float4 SMAA_RTMetrics;
};

struct CbDefaultVSC {
  Matrix4 ProjMatrix;
  Matrix4 TextureTransform;
  Matrix4 InvViewProj;
  Matrix4 PrevViewProj;
  Matrix4 PrevSecViewProj;
};

struct CbDefaultPSC {
  Matrix4 AlphaLight_WorldtoClipMatrix;
  Matrix4 AlphaLight_CliptoWorldMatrix;
  Matrix4 ProjectorMatrix;
  Matrix4 MotionBlurCurrInvViewProjection;
  Matrix4 MotionBlurPrevViewProjection;
  Matrix4 MotionBlurPrevSecViewProjection;
  Matrix4 Spotlight0_Transform;
};

enum class BufferKind {
  Unknown,
  DefaultXSC,
  DefaultVSC,
  DefaultPSC,
};

struct TrackedBuffers {
  reshade::api::resource default_xsc = {0};
  reshade::api::resource default_vsc = {0};
  reshade::api::resource default_psc = {0};
};

struct MappedBuffer {
  BufferKind kind = BufferKind::Unknown;
  uint8_t* data = nullptr;
  uint64_t size = 0u;
};

struct RenderState {
  uint32_t screen_width = 0u;
  uint32_t screen_height = 0u;
  uint32_t rt_width = 0u;
  uint32_t rt_height = 0u;
  reshade::api::resource_view rt_view = {0};
  float viewport_width = 0.f;
  float viewport_height = 0.f;
  bool has_render_target = false;
  bool has_viewport = false;
};

struct MatrixState {
  // Kept without jitter so velocity/shadow fixes can compose their own precise
  // transforms instead of reusing already-jittered game matrices.
  Matrix4 curr_view_matrix = {};
  Matrix4 prev_view_proj_no_jitter = {};
  Matrix4 curr_view_proj_no_jitter = {};
  Matrix4d curr_inv_view_proj_no_jitter = {};
  bool has_curr_view_proj = false;
  bool has_prev_view_proj = false;
};

struct XscCache {
  Matrix4 secondary_proj = {};
  Matrix4 view_proj = {};
  Matrix4 secondary_view_proj = {};
  uint32_t sample_index = std::numeric_limits<uint32_t>::max();
  bool disabled = true;
};

inline TrackedBuffers tracked = {};
inline std::unordered_map<uint64_t, MappedBuffer> mapped_buffers;
inline RenderState render_state = {};
inline MatrixState matrix_state = {};
inline XscCache xsc_cache = {};
inline std::array<uint64_t, 4> last_track_log = [] {
  std::array<uint64_t, 4> result = {};
  result.fill(std::numeric_limits<uint64_t>::max());
  return result;
}();
inline std::array<uint64_t, 4> last_apply_log = [] {
  std::array<uint64_t, 4> result = {};
  result.fill(std::numeric_limits<uint64_t>::max());
  return result;
}();
inline std::array<uint64_t, 4> last_skip_log = [] {
  std::array<uint64_t, 4> result = {};
  result.fill(std::numeric_limits<uint64_t>::max());
  return result;
}();
inline uint64_t last_swapchain_log = std::numeric_limits<uint64_t>::max();

inline const char* BufferKindName(BufferKind kind) {
  switch (kind) {
    case BufferKind::DefaultXSC:
      return "DefaultXSC";
    case BufferKind::DefaultVSC:
      return "DefaultVSC";
    case BufferKind::DefaultPSC:
      return "DefaultPSC";
    default:
      return "Unknown";
  }
}

inline bool LogEvery(uint64_t& last_frame, uint64_t interval = 120u) {
  return logging::ShouldLogFrame(constant_buffers::frame_state.frame_index, last_frame, interval);
}

inline uint64_t& LogSlot(std::array<uint64_t, 4>& slots, BufferKind kind) {
  return slots[static_cast<size_t>(kind)];
}

inline Matrix4 Identity() {
  Matrix4 result = {};
  for (uint32_t i = 0; i < 4u; ++i) result.m[i][i] = 1.f;
  return result;
}

inline Matrix4d IdentityD() {
  Matrix4d result = {};
  for (uint32_t i = 0; i < 4u; ++i) result.m[i][i] = 1.0;
  return result;
}

inline Matrix4 JitterAdd(float x, float y) {
  Matrix4 result = Identity();
  result.m[0][3] = x;
  result.m[1][3] = y;
  return result;
}

inline Matrix4d JitterAddD(double x, double y) {
  Matrix4d result = IdentityD();
  result.m[0][3] = x;
  result.m[1][3] = y;
  return result;
}

inline Matrix4 Multiply(const Matrix4& a, const Matrix4& b) {
  Matrix4 result = {};
  for (uint32_t col = 0; col < 4u; ++col) {
    for (uint32_t row = 0; row < 4u; ++row) {
      float value = 0.f;
      for (uint32_t k = 0; k < 4u; ++k) {
        value += a.m[k][row] * b.m[col][k];
      }
      result.m[col][row] = value;
    }
  }
  return result;
}

inline Matrix4d Multiply(const Matrix4d& a, const Matrix4d& b) {
  Matrix4d result = {};
  for (uint32_t col = 0; col < 4u; ++col) {
    for (uint32_t row = 0; row < 4u; ++row) {
      double value = 0.0;
      for (uint32_t k = 0; k < 4u; ++k) {
        value += a.m[k][row] * b.m[col][k];
      }
      result.m[col][row] = value;
    }
  }
  return result;
}

inline Matrix4d ToDouble(const Matrix4& matrix) {
  Matrix4d result = {};
  for (uint32_t col = 0; col < 4u; ++col) {
    for (uint32_t row = 0; row < 4u; ++row) {
      result.m[col][row] = static_cast<double>(matrix.m[col][row]);
    }
  }
  return result;
}

inline Matrix4 ToFloat(const Matrix4d& matrix) {
  Matrix4 result = {};
  for (uint32_t col = 0; col < 4u; ++col) {
    for (uint32_t row = 0; row < 4u; ++row) {
      result.m[col][row] = static_cast<float>(matrix.m[col][row]);
    }
  }
  return result;
}

inline bool Invert(const Matrix4d& input, Matrix4d& output) {
  double a[4][8] = {};
  for (uint32_t row = 0; row < 4u; ++row) {
    for (uint32_t col = 0; col < 4u; ++col) {
      a[row][col] = input.m[col][row];
    }
    a[row][4u + row] = 1.0;
  }

  for (uint32_t col = 0; col < 4u; ++col) {
    uint32_t pivot = col;
    double best = std::abs(a[col][col]);
    for (uint32_t row = col + 1u; row < 4u; ++row) {
      const double candidate = std::abs(a[row][col]);
      if (candidate > best) {
        best = candidate;
        pivot = row;
      }
    }
    if (best <= 1e-12) return false;
    if (pivot != col) {
      for (uint32_t i = 0; i < 8u; ++i) std::swap(a[pivot][i], a[col][i]);
    }

    const double pivot_value = a[col][col];
    for (uint32_t i = 0; i < 8u; ++i) a[col][i] /= pivot_value;

    for (uint32_t row = 0; row < 4u; ++row) {
      if (row == col) continue;
      const double scale = a[row][col];
      for (uint32_t i = 0; i < 8u; ++i) a[row][i] -= scale * a[col][i];
    }
  }

  output = {};
  for (uint32_t row = 0; row < 4u; ++row) {
    for (uint32_t col = 0; col < 4u; ++col) {
      output.m[col][row] = a[row][4u + col];
    }
  }
  return true;
}

inline bool MatrixEqual(const Matrix4& a, const Matrix4& b) {
  return std::memcmp(&a, &b, sizeof(Matrix4)) == 0;
}

inline bool TopLeft3IsIdentity(const Matrix4& matrix) {
  for (uint32_t col = 0; col < 3u; ++col) {
    for (uint32_t row = 0; row < 3u; ++row) {
      const float expected = col == row ? 1.f : 0.f;
      if (std::abs(matrix.m[col][row] - expected) > 1e-6f) return false;
    }
  }
  return true;
}

inline float Vec3Distance(float ax, float ay, float az, float bx, float by, float bz) {
  const float dx = ax - bx;
  const float dy = ay - by;
  const float dz = az - bz;
  return std::sqrt(dx * dx + dy * dy + dz * dz);
}

inline bool IsFullscreenPass() {
  if (render_state.screen_width == 0u || render_state.screen_height == 0u) return false;
  if (!render_state.has_render_target || !render_state.has_viewport) return false;
  if (render_state.rt_width != render_state.screen_width || render_state.rt_height != render_state.screen_height) return false;

  const float screen_width = static_cast<float>(render_state.screen_width);
  const float screen_height = static_cast<float>(render_state.screen_height);
  return std::abs(render_state.viewport_width - screen_width) < 0.5f
         && std::abs(render_state.viewport_height - screen_height) < 0.5f;
}

inline void TrackBuffer(BufferKind kind, reshade::api::buffer_range range) {
  if (range.buffer.handle == 0u) return;

  reshade::api::resource* target = nullptr;
  switch (kind) {
    case BufferKind::DefaultXSC:
      target = &tracked.default_xsc;
      break;
    case BufferKind::DefaultVSC:
      target = &tracked.default_vsc;
      break;
    case BufferKind::DefaultPSC:
      target = &tracked.default_psc;
      break;
    default:
      return;
  }

  if (target->handle == range.buffer.handle) return;
  *target = range.buffer;

  if (LogEvery(LogSlot(last_track_log, kind), 30u)) {
    logging::Info("tracking ", BufferKindName(kind), " resource=", logging::Hex(range.buffer.handle));
  }
}

inline void CaptureConstantBuffers(
    const descriptor_tracker::CommandListData& data,
    bool is_smaa_vs,
    bool is_rgbm_encode_vs,
    bool is_camera_motion_ps) {
  if (!constant_buffers::IsEnabled()) return;

  // These bindings mirror the original ASI's hard-coded knowledge of the
  // game's passes: SMAA VS exposes DefaultXSC, RGBM VS exposes DefaultVSC, and
  // camera motion PS exposes DefaultPSC.
  if (is_smaa_vs && data.vertex_cb_b0.buffer.handle != 0u) {
    TrackBuffer(BufferKind::DefaultXSC, data.vertex_cb_b0);
  }

  if (is_rgbm_encode_vs && data.vertex_cb_b1.buffer.handle != 0u) {
    TrackBuffer(BufferKind::DefaultVSC, data.vertex_cb_b1);
  }

  if (is_camera_motion_ps && data.pixel_cb_b2.buffer.handle != 0u) {
    TrackBuffer(BufferKind::DefaultPSC, data.pixel_cb_b2);
  }
}

inline BufferKind KindForResource(reshade::api::resource resource) {
  if (resource.handle == 0u) return BufferKind::Unknown;
  if (resource.handle == tracked.default_xsc.handle) return BufferKind::DefaultXSC;
  if (resource.handle == tracked.default_vsc.handle) return BufferKind::DefaultVSC;
  if (resource.handle == tracked.default_psc.handle) return BufferKind::DefaultPSC;
  return BufferKind::Unknown;
}

inline std::array<float, 2> GetFrameJitter() {
  return constant_buffers::CurrentFrameJitter(render_state.screen_width, render_state.screen_height);
}

inline void ApplyDefaultXSC(CbDefaultXSC* xsc) {
  if (xsc == nullptr) return;

  const auto sample_offset = GetFrameJitter();

  // Planar reflections have an identity SecondaryProj. The original mod avoids
  // jittering those paths.
  if (TopLeft3IsIdentity(xsc->SecondaryProj)) return;

  // Do not jitter shadow matrices. Alias Isolation identifies normal camera
  // rendering by reconstructing the camera position from ViewMatrix and
  // comparing it with CameraPosition, which is not updated for shadow views.
  const float tx = -xsc->ViewMatrix.m[0][3];
  const float ty = -xsc->ViewMatrix.m[1][3];
  const float tz = -xsc->ViewMatrix.m[2][3];
  const float view_camera_x = xsc->ViewMatrix.m[0][0] * tx + xsc->ViewMatrix.m[1][0] * ty + xsc->ViewMatrix.m[2][0] * tz;
  const float view_camera_y = xsc->ViewMatrix.m[0][1] * tx + xsc->ViewMatrix.m[1][1] * ty + xsc->ViewMatrix.m[2][1] * tz;
  const float view_camera_z = xsc->ViewMatrix.m[0][2] * tx + xsc->ViewMatrix.m[1][2] * ty + xsc->ViewMatrix.m[2][2] * tz;
  if (Vec3Distance(view_camera_x, view_camera_y, view_camera_z, xsc->CameraPosition.x, xsc->CameraPosition.y, xsc->CameraPosition.z) >= 0.01f) {
    return;
  }

  const bool needs_rebuild = xsc_cache.disabled
                             || !MatrixEqual(matrix_state.curr_view_proj_no_jitter, xsc->ViewProj)
                             || xsc_cache.sample_index != constant_buffers::frame_state.taa_sample_index;

  if (needs_rebuild) {
    // Cache the jittered variants for this frame/sample. The same XSC buffer can
    // be mapped more than once, and recomputing from an already-jittered matrix
    // would accumulate the offset.
    xsc_cache.disabled = false;
    xsc_cache.sample_index = constant_buffers::frame_state.taa_sample_index;

    matrix_state.curr_view_matrix = xsc->ViewMatrix;
    matrix_state.curr_view_proj_no_jitter = xsc->ViewProj;
    matrix_state.has_curr_view_proj = true;
    Invert(ToDouble(matrix_state.curr_view_proj_no_jitter), matrix_state.curr_inv_view_proj_no_jitter);

    const Matrix4 jitter_add = JitterAdd(sample_offset[0], sample_offset[1]);
    xsc_cache.secondary_proj = Multiply(xsc->SecondaryProj, jitter_add);
    xsc_cache.view_proj = Multiply(xsc->ViewProj, jitter_add);
    xsc_cache.secondary_view_proj = Multiply(xsc->SecondaryViewProj, jitter_add);
  }

  xsc->SecondaryProj = xsc_cache.secondary_proj;
  xsc->ViewProj = xsc_cache.view_proj;
  xsc->SecondaryViewProj = xsc_cache.secondary_view_proj;
}

inline void ApplyDefaultVSC(CbDefaultVSC* vsc) {
  if (vsc == nullptr) return;

  const auto sample_offset = GetFrameJitter();
  if (vsc->ProjMatrix.m[0][2] == sample_offset[0] && vsc->ProjMatrix.m[1][2] == sample_offset[1]) return;

  const Matrix4 jitter_add = JitterAdd(sample_offset[0], sample_offset[1]);
  vsc->ProjMatrix = Multiply(vsc->ProjMatrix, jitter_add);
  vsc->PrevViewProj = Multiply(vsc->PrevViewProj, jitter_add);
  vsc->PrevSecViewProj = Multiply(vsc->PrevSecViewProj, jitter_add);
}

inline void ApplyDefaultPSC(CbDefaultPSC* psc) {
  if (psc == nullptr || !matrix_state.has_curr_view_proj || !matrix_state.has_prev_view_proj) return;

  // The velocity shader multiplies these matrices in single precision. Alias
  // Isolation does the multiply on CPU with doubles and leaves the second matrix
  // as identity, which reduces subtle screen shake in the generated velocity
  // vectors. The original ASI is built with GLM_FORCE_CTOR_INIT, so
  // `glm::mat4()` is identity here, not a zero matrix.
  const Matrix4d prev_view_proj = ToDouble(matrix_state.prev_view_proj_no_jitter);
  psc->MotionBlurCurrInvViewProjection = ToFloat(Multiply(matrix_state.curr_inv_view_proj_no_jitter, prev_view_proj));
  psc->MotionBlurPrevViewProjection = Identity();

  const auto sample_offset = GetFrameJitter();
  const Matrix4d jitter_remove = JitterAddD(-static_cast<double>(sample_offset[0]), -static_cast<double>(sample_offset[1]));
  Matrix4d curr_inv = {};
  if (!Invert(ToDouble(matrix_state.curr_view_proj_no_jitter), curr_inv)) return;

  // Removing jitter from shadow projection in double precision avoids flicker
  // from small errors in shadow-map matrix math.
  const Matrix4d shadow_jitter_remove = Multiply(Multiply(ToDouble(matrix_state.curr_view_proj_no_jitter), jitter_remove), curr_inv);
  psc->Spotlight0_Transform = Multiply(ToFloat(shadow_jitter_remove), psc->Spotlight0_Transform);
}

inline bool ApplyMappedBuffer(const MappedBuffer& mapped) {
  if (mapped.data == nullptr) return false;
  if (!constant_buffers::IsEnabled()) return false;
  if (!IsFullscreenPass()) {
    if (LogEvery(LogSlot(last_skip_log, mapped.kind))) {
      logging::Info("skipping ", BufferKindName(mapped.kind), " jitter outside fullscreen pass rt=", render_state.rt_width, "x", render_state.rt_height,
                    " viewport=", render_state.viewport_width, "x", render_state.viewport_height,
                    " screen=", render_state.screen_width, "x", render_state.screen_height);
    }
    return false;
  }

  switch (mapped.kind) {
    case BufferKind::DefaultXSC:
      if (mapped.size >= sizeof(CbDefaultXSC)) {
        ApplyDefaultXSC(reinterpret_cast<CbDefaultXSC*>(mapped.data));
        return true;
      }
      break;
    case BufferKind::DefaultVSC:
      if (mapped.size >= sizeof(CbDefaultVSC)) {
        ApplyDefaultVSC(reinterpret_cast<CbDefaultVSC*>(mapped.data));
        return true;
      }
      break;
    case BufferKind::DefaultPSC:
      if (mapped.size >= sizeof(CbDefaultPSC)) {
        ApplyDefaultPSC(reinterpret_cast<CbDefaultPSC*>(mapped.data));
        return true;
      }
      break;
    default:
      break;
  }

  return false;
}

inline void FinishFrame() {
  if (matrix_state.has_curr_view_proj) {
    matrix_state.prev_view_proj_no_jitter = matrix_state.curr_view_proj_no_jitter;
    matrix_state.has_prev_view_proj = true;
  }
}

inline void Reset() {
  tracked = {};
  mapped_buffers.clear();
  render_state = {};
  matrix_state = {};
  xsc_cache = {};
}

inline void OnInitSwapchain(reshade::api::swapchain* swapchain, bool) {
  if (swapchain == nullptr) return;
  auto* device = swapchain->get_device();
  if (device == nullptr) return;

  const auto back_buffer = swapchain->get_back_buffer(0);
  if (back_buffer.handle == 0u) return;

  const auto desc = device->get_resource_desc(back_buffer);
  render_state.screen_width = desc.texture.width;
  render_state.screen_height = desc.texture.height;

  if (LogEvery(last_swapchain_log, 1u)) {
    logging::Info("jitter screen size ", render_state.screen_width, "x", render_state.screen_height);
  }
}

inline void OnDestroySwapchain(reshade::api::swapchain*, bool) {
  render_state.screen_width = 0u;
  render_state.screen_height = 0u;
  render_state.has_render_target = false;
  render_state.has_viewport = false;
  render_state.rt_view = {0};
}

inline void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view) {
  if (cmd_list == nullptr || count == 0u || rtvs == nullptr || rtvs[0].handle == 0u) {
    render_state.has_render_target = false;
    render_state.rt_view = {0};
    return;
  }

  if (render_state.has_render_target && render_state.rt_view.handle == rtvs[0].handle) return;

  auto* device = cmd_list->get_device();
  if (device == nullptr) return;

  const auto resource = device->get_resource_from_view(rtvs[0]);
  if (resource.handle == 0u) {
    render_state.has_render_target = false;
    render_state.rt_view = {0};
    return;
  }
  const auto desc = device->get_resource_desc(resource);
  render_state.rt_width = desc.texture.width;
  render_state.rt_height = desc.texture.height;
  render_state.rt_view = rtvs[0];
  render_state.has_render_target = true;
}

inline void OnBindViewports(
    reshade::api::command_list*,
    uint32_t first,
    uint32_t count,
    const reshade::api::viewport* viewports) {
  if (viewports == nullptr || count == 0u) {
    render_state.has_viewport = false;
    return;
  }
  if (first != 0u) return;

  render_state.viewport_width = viewports[0].width;
  render_state.viewport_height = viewports[0].height;
  render_state.has_viewport = true;
}

inline void OnMapBufferRegion(
    reshade::api::device* device,
    reshade::api::resource resource,
    uint64_t offset,
    uint64_t size,
    reshade::api::map_access,
    void** mapped_data) {
  if (device == nullptr || mapped_data == nullptr || *mapped_data == nullptr) return;

  const BufferKind kind = KindForResource(resource);
  if (kind == BufferKind::Unknown) return;

  // ReShade reports UINT64_MAX for "map the rest of the buffer" on some paths.
  // Resolve it so the unmap handler can safely bounds-check the expected layout.
  uint64_t resolved_size = size;
  if (resolved_size == UINT64_MAX) {
    const auto desc = device->get_resource_desc(resource);
    resolved_size = desc.buffer.size > offset ? desc.buffer.size - offset : 0u;
  }

  mapped_buffers[resource.handle] = MappedBuffer{
      .kind = kind,
      .data = static_cast<uint8_t*>(*mapped_data) + offset,
      .size = resolved_size,
  };
}

inline void OnUnmapBufferRegion(reshade::api::device*, reshade::api::resource resource) {
  const auto it = mapped_buffers.find(resource.handle);
  if (it == mapped_buffers.end()) return;

  // The game writes the cbuffer while it is mapped; patch after that write but
  // before the GPU consumes the data.
  const BufferKind kind = it->second.kind;
  const bool applied = ApplyMappedBuffer(it->second);
  mapped_buffers.erase(it);

  if (applied && LogEvery(LogSlot(last_apply_log, kind))) {
    const auto sample_offset = GetFrameJitter();
    logging::Info("applied jitter to ", BufferKindName(kind),
                  " frame=", constant_buffers::frame_state.frame_index,
                  " sample=", constant_buffers::frame_state.taa_sample_index,
                  " offset=", sample_offset[0], ",", sample_offset[1],
                  " taa_ran=", logging::Bool(constant_buffers::frame_state.taa_ran_this_frame));
  }
}

}  // namespace alienisolation::aliasisolation::jitter
