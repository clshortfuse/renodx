#version 450
#include "./shared.h"
#include "./macleod_boynton.hlsli"
#include "./shared.slang"

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
luminance;

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_C;

layout(location = 0) in vec4 uv;
layout(location = 1) in vec4 scale;
layout(location = 0) out vec4 out;



void main() {
  vec4 scene = texture(fp_t_tcb_8, uv.xy);
  vec3 lutColor = lut(scene.xyz);
  vec3 hdr = lut(scene.xyz, true);
  if (RENODX_TONE_MAP_TYPE != 0) lutColor = ColourCorrect(hdr, lutColor);
  lutColor = ApplyColorGrade(lutColor);
  lutColor = DisplayMap(lutColor);
  //lutColor = min(lutColor, 1);

  out = vec4(lutColor, scene.w);
  out = renodx::draw::RenderIntermediatePass(out);
  //out = scene;
}

#ifndef LUT_ALTERNATIVE
vec3 lut(vec3 color, bool scaled = false) {
  vec3 bloom = texture(fp_t_tcb_A, uv.xy).xyz * CUSTOM_BLOOM;
  float lutScale = 1;
  vec3 sceneScaled = color * scale.xyz;
  if (scaled) lutScale = renodx::tonemap::neutwo::ComputeMaxChannelScale(sceneScaled);
  sceneScaled *= lutScale;
  precise float lumaSeed = sceneScaled.x * 0.29890000820159912109375;
  float luma = fma(sceneScaled.y, luminance._m0[0].x, lumaSeed);
  luma = fma(sceneScaled.z, luminance._m0[0].y, luma);
  float blend = saturate(luma);
  float invBlend = 1.0 - blend;
  vec3 mixed = sceneScaled + bloom * invBlend;
  vec3 lutCoord = fma(mixed, fp_c3_1._m0[3].x, fp_c3_1._m0[3].y);
  vec3 base = sceneScaled / lutScale + bloom * invBlend;
  if (!scaled) base = saturate(base);
  return lerp(base, texture(fp_t_tcb_C, lutCoord).xyz / lutScale,  LUT_STRENGTH);
}
#else

vec3 lut(vec3 color, bool scaled = false) {
  vec3 bloom = texture(fp_t_tcb_A, uv.xy).xyz; // not actually bloom but whatever
  float lutScale = 1;
  vec3 mixed = bloom * scale.xyz + color * CUSTOM_BLOOM; // yeah no idea why these are swapped around lol
  if (scaled) lutScale = renodx::tonemap::neutwo::ComputeMaxChannelScale(mixed);
  mixed *= lutScale;
  vec2 lutParams = fp_c3_1._m0[3].xy;
  vec3 lutCoord = mixed * lutParams.x + lutParams.y;
  if (!scaled) mixed = saturate(mixed);
  return lerp(mixed, texture(fp_t_tcb_C, lutCoord).xyz, LUT_STRENGTH) / lutScale;
}
#endif