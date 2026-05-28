#version 450

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
luma;

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
inLut;

layout(set = 2, binding = 128) uniform sampler2D rawSampler;
layout(set = 2, binding = 129) uniform sampler3D lutSampler;

#define USE_LUT 1
#define USE_BLOOM 0
#include "./tonemap_common.slang"