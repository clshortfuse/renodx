#version 450

// Keep the probe independent from Detroit's image descriptors and push
// constants. It imports only the production tone-map math and writes results
// through a single storage-buffer binding.
#define DETROIT_TONE_MAP_TYPE_AGX         3.f
#define DETROIT_TONE_MAP_TYPE_ACES_FITTED 4.f
#define DETROIT_TONE_MAP_TYPE_LOTTES      5.f
#define DETROIT_TONE_MAP_TYPE_HABLE       6.f
#define DETROIT_TONE_MAP_TYPE_KHRONOS_PBR 7.f
#define DETROIT_TONE_MAP_TYPE_PSYCHOV_22  8.f
#define DETROIT_TONE_MAP_TYPE_DETROIT_DRT 9.f

#include "../../../src/shaders/tonemap.hlsl"
#include "../../../src/games/detroitbecomehuman/tone_mappers.slang"

layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

struct ProbeRecord {
  vec4 input_type;
  vec4 parameters;
  vec4 output_value;
};

layout(set = 0, binding = 0, std430) buffer ProbeBuffer {
  ProbeRecord records[];
} probe_buffer;

void main() {
  const uint index = gl_GlobalInvocationID.x;
  if (index >= uint(probe_buffer.records.length())) {
    return;
  }

  const ProbeRecord record = probe_buffer.records[index];
  const vec3 output_value = detroit::tone_map::Apply(
      record.input_type.rgb,
      record.input_type.a,
      record.parameters.x,
      record.parameters.y,
      1.0f,
      0.0f,
      0.0f);
  probe_buffer.records[index].output_value = vec4(output_value, 1.0f);
}
