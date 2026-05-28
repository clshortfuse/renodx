#define USE_LUT 1

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
inLut;

layout(set = 2, binding = 130) uniform sampler3D lutSampler;


layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
luma;

layout(set = 2, binding = 128) uniform sampler2D bloomSampler;
layout(set = 2, binding = 129) uniform sampler2D rawSampler;

#include "./tonemap_common.slang"