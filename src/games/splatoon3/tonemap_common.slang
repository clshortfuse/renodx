#version 450
#include "./shared.h"
#include "./shared.slang"
#ifndef USE_LUT
#define USE_LUT 0
#endif
#ifndef USE_BLOOM
#define USE_BLOOM 1
#endif

layout(location = 0) in vec4 inUV;
layout(location = 1) in vec4 inBlend;
layout(location = 0) out vec4 out;

void main() {
  vec2 uv = inUV.xy;
  
  vec4 raw = texture(rawSampler, uv);

  float blendWeight = inBlend.w;
  vec3 color = raw.xyz * blendWeight;
#if USE_BLOOM
  vec3 bloom = texture(bloomSampler, uv).xyz;
  color += bloom;
  #endif

  vec3 mapped = Tonemap(color);
  vec3 hdr = Tonemap(color, true);
#if USE_LUT
  mapped = lerp(mapped, lut(mapped), LUT_STRENGTH);
  hdr = lerp(hdr, lut(hdr, true), LUT_STRENGTH);
#endif

  if (RENODX_TONE_MAP_TYPE != 0.f) mapped = ColourCorrect(hdr, mapped);
  mapped = ApplyColorGrade(mapped);
  mapped = DisplayMap(mapped);
  mapped = renodx::draw::RenderIntermediatePass(mapped);
  out = vec4(mapped, raw.w);
}

#if USE_LUT
vec3 lut(vec3 color, bool hdr = false) {
  float scale = renodx::math::Select(hdr, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1.0f);
  color *= scale;
  vec3 lutScaleBias = inLut._m0[3].xyx;
  vec3 lutCoords = color * lutScaleBias.x + lutScaleBias.y;
  return texture(lutSampler, lutCoords).xyz / scale;
}
#endif

vec3 Tonemap(vec3 color, bool extended = false) {
  float scale = renodx::math::Select(extended, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1.0f);
  color *= scale;
  vec3 lumaWeights = vec3(0.29890000820159912109375, luma._m0[0].x, luma._m0[0].y);
  float luma = dot(color, lumaWeights);
  float oneMinusExpLuma = 1.0 - exp2(luma * (-1.44269502162933349609375));
  vec3 oneMinusExpColor = 1.0 - exp2(color * (-1.44269502162933349609375));
  precise float gain = oneMinusExpLuma / luma;
  precise float gainSq = oneMinusExpLuma * oneMinusExpLuma;
  vec3 scaledColor = color * gain;
  vec3 delta = oneMinusExpColor - scaledColor;
  vec3 result = (delta * gainSq + scaledColor) / scale;
  if (!extended) return saturate(result);
  return result;
}

// vec3 Tonemap(vec3 color, bool extended = false) {
//   vec3 lumaWeights = vec3(0.29890000820159912109375, luma._m0[0].x, luma._m0[0].y);
//   float luma = dot(color, lumaWeights);
//   float oneMinusExpLuma = 1.0 - exp2(luma * (-1.44269502162933349609375));
//   vec3 oneMinusExpColor = 1.0 - exp2(color * (-1.44269502162933349609375));
//   precise float gain = oneMinusExpLuma / luma;
//   precise float gainSq = oneMinusExpLuma * oneMinusExpLuma;
//   vec3 scaledColor = color * gain;
//   vec3 delta = oneMinusExpColor - scaledColor;
//   vec3 result = delta * gainSq + scaledColor;
//   if (!extended) return saturate(result);

//   float mappedLuma = dot(result, lumaWeights);
//   float highlightLuma = max(luma - 1.0f, 0.0f);
//   float extendedLuma = mappedLuma + highlightLuma;
//   return result * (extendedLuma / max(mappedLuma, 0.00001f));
// }