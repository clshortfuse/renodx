#pragma once

/*
 * Small shared state block for the Alias Isolation runtime.
 *
 * The original ASI creates a private TAA dispatch cbuffer and also tracks a TAA
 * jitter sequence. In the RenoDX port the compute shader derives dimensions
 * from textures, so this file only owns the master enable binding, frame
 * counters, and the same sub-pixel jitter sequence used by the cbuffer patching
 * code.
 */

#include <array>
#include <cmath>
#include <cstdint>

namespace alienisolation::aliasisolation::constant_buffers {

// Per-frame state shared by jitter injection and TAA dispatch. The sample index
// only advances after TAA runs, which prevents the camera from jittering ahead
// when the resolve pass was skipped for missing inputs.
struct FrameState {
  uint32_t taa_sample_index = 0u;
  uint64_t frame_index = 0u;
  bool taa_ran_this_frame = false;
};

inline float enabled = 0.f;
inline float* enabled_binding = &enabled;
inline FrameState frame_state = {};

inline bool IsEnabled() {
  return enabled_binding != nullptr && *enabled_binding > 0.f;
}

// Radical-inverse sample from Alias Isolation's Hammersley jitter sequence.
inline float HammersleySample(uint32_t bits, uint32_t seed) {
  bits = (bits << 16u) | (bits >> 16u);
  bits = ((bits & 0x00ff00ffu) << 8u) | ((bits & 0xff00ff00u) >> 8u);
  bits = ((bits & 0x0f0f0f0fu) << 4u) | ((bits & 0xf0f0f0f0u) >> 4u);
  bits = ((bits & 0x33333333u) << 2u) | ((bits & 0xccccccccu) >> 2u);
  bits = ((bits & 0x55555555u) << 1u) | ((bits & 0xaaaaaaaau) >> 1u);
  bits ^= seed;
  return static_cast<float>(bits) * 2.3283064365386963e-10f;
}

inline std::array<float, 2> CurrentFrameJitter(uint32_t width, uint32_t height) {
  if (frame_state.taa_ran_this_frame || width == 0u || height == 0u) return {0.f, 0.f};

  // Alias Isolation walks a 16-sample pattern in a permuted order. Convert the
  // normalized pattern into projection-space offsets for the current backbuffer.
  const uint32_t sample = (frame_state.taa_sample_index * 7u) % 16u;
  std::array<float, 2> result = {
      (static_cast<float>(sample) + 0.5f) / 16.f,
      HammersleySample(sample, 238308531u),
  };
  result[0] = (result[0] - 0.5f) * 2.f / static_cast<float>(width);
  result[1] = (result[1] - 0.5f) * 2.f / static_cast<float>(height);
  return result;
}

inline void BeginFrame() {
  ++frame_state.frame_index;
  frame_state.taa_ran_this_frame = false;
}

// Called only after the compute resolve and copy-back succeed.
inline void MarkTaaDispatched() {
  frame_state.taa_ran_this_frame = true;
  ++frame_state.taa_sample_index;
}

}  // namespace alienisolation::aliasisolation::constant_buffers
