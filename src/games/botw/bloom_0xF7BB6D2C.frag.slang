#version 450
#include "./shared.h"

layout(set = 1, binding = 1, std140) uniform ufBlock {
  ivec4 uf_remappedPS[1];
  vec4 uf_fragCoordScale;
}
_80;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 0) out vec4 passPixelColor0;

float mul_nonIEEE(float a, float b) {
  return ((a != 0.0) && (b != 0.0)) ? (a * b) : 0.0;
}

void main() {
  vec4 R0f = vec4(0.0);
  float PV0fx = 0.0;
  float PV0fy = 0.0;
  float PV0fz = 0.0;
  float PV0fw = 0.0;
  float PV1fx = 0.0;
  float PV1fy = 0.0;
  float PV1fz = 0.0;
  float PV1fw = 0.0;
  float PS0f = 0.0;
  float PS1f = 0.0;
  vec4 tempf = vec4(0.0);
  ivec4 ARi = ivec4(0);
  bool predResult = true;
  R0f = passParameterSem0;
  float _61 = R0f.x;
  float _64 = R0f.y;
  vec3 _69 = texture(textureUnitPS0, vec2(_61, _64)).xyz;
  R0f.x = _69.x;
  R0f.y = _69.y;
  R0f.z = _69.z;
  float param = R0f.x;
  float param_1 = intBitsToFloat(_80.uf_remappedPS[0].x);
  R0f.x = mul_nonIEEE(param, param_1);
  float param_2 = R0f.y;
  float param_3 = intBitsToFloat(_80.uf_remappedPS[0].y);
  R0f.y = mul_nonIEEE(param_2, param_3);
  float param_4 = R0f.z;
  float param_5 = intBitsToFloat(_80.uf_remappedPS[0].z);
  R0f.z = mul_nonIEEE(param_4, param_5);
  R0f.w = 1.0;
  passPixelColor0 = vec4(R0f.x, R0f.y, R0f.z, R0f.w) * CUSTOM_BLOOM;
}

