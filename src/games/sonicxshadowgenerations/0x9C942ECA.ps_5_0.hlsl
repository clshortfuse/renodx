#include "./shared.h"

cbuffer cbBlur : register(b10)
{
  float4 u_param[2] : packoffset(c0);
}

SamplerState s_Source_sampler_s : register(s0);
Texture2D<float4> s_Source_NedSmpignorenametexture : register(t0);
Texture2D<float4> adapted_luminance : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  const float4 icb[] = { { -1.000000, -1.000000, 0, 0},
                              { 1.000000, -1.000000, 0, 0},
                              { -1.000000, 1.000000, 0, 0},
                              { 1.000000, 1.000000, 0, 0} };
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(0,0,0,0);
  r1.xy = float2(0,0);
  while (true) {
    r1.z = cmp((int)r1.y >= 4);
    if (r1.z != 0) break;
    r1.zw = icb[r1.y+0].xy * u_param[0].xy + v1.xy;
    r1.zw = min(u_param[1].zw, r1.zw);
    r2.xyzw = s_Source_NedSmpignorenametexture.SampleLevel(s_Source_sampler_s, r1.zw, 0).xyzw;
    r2.xyzw = max(float4(0,0,0,0), r2.xyzw);
    r2.xyzw = min(float4(65504,65504,65504,65504), r2.xyzw);
    r1.z = max(r2.y, r2.z);
    r1.z = max(r2.x, r1.z);
    r1.z = 1 + r1.z;
    r1.z = 1 / r1.z;
    r0.xyzw = r2.xyzw * r1.zzzz + r0.xyzw;
    r1.x = r1.x + r1.z;
    r1.y = (int)r1.y + 1;
  }
  r0.xyzw = r0.xyzw / r1.xxxx;
  r1.xyzw = float4(0,0,0,0);
  r2.xy = float2(0,0);
  while (true) {
    r2.z = cmp((int)r2.y >= 4);
    if (r2.z != 0) break;
    r2.zw = icb[r2.y+0].xy + float2(-1,-1);
    r2.zw = r2.zw * u_param[0].xy + v1.xy;
    r2.zw = min(u_param[1].zw, r2.zw);
    r3.xyzw = s_Source_NedSmpignorenametexture.SampleLevel(s_Source_sampler_s, r2.zw, 0).xyzw;
    r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
    r3.xyzw = min(float4(65504,65504,65504,65504), r3.xyzw);
    r2.z = max(r3.y, r3.z);
    r2.z = max(r3.x, r2.z);
    r2.z = 1 + r2.z;
    r2.z = 1 / r2.z;
    r1.xyzw = r3.xyzw * r2.zzzz + r1.xyzw;
    r2.x = r2.x + r2.z;
    r2.y = (int)r2.y + 1;
  }
  r1.xyzw = r1.xyzw / r2.xxxx;
  r1.xyzw = float4(0.125,0.125,0.125,0.125) * r1.xyzw;
  r0.xyzw = r0.xyzw * float4(0.5,0.5,0.5,0.5) + r1.xyzw;
  r1.xyzw = float4(0,0,0,0);
  r2.xy = float2(0,0);
  while (true) {
    r2.z = cmp((int)r2.y >= 4);
    if (r2.z != 0) break;
    r2.zw = icb[r2.y+0].xy + float2(-1,1);
    r2.zw = r2.zw * u_param[0].xy + v1.xy;
    r2.zw = min(u_param[1].zw, r2.zw);
    r3.xyzw = s_Source_NedSmpignorenametexture.SampleLevel(s_Source_sampler_s, r2.zw, 0).xyzw;
    r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
    r3.xyzw = min(float4(65504,65504,65504,65504), r3.xyzw);
    r2.z = max(r3.y, r3.z);
    r2.z = max(r3.x, r2.z);
    r2.z = 1 + r2.z;
    r2.z = 1 / r2.z;
    r1.xyzw = r3.xyzw * r2.zzzz + r1.xyzw;
    r2.x = r2.x + r2.z;
    r2.y = (int)r2.y + 1;
  }
  r1.xyzw = r1.xyzw / r2.xxxx;
  r0.xyzw = r1.xyzw * float4(0.125,0.125,0.125,0.125) + r0.xyzw;
  r1.xyzw = float4(0,0,0,0);
  r2.xy = float2(0,0);
  while (true) {
    r2.z = cmp((int)r2.y >= 4);
    if (r2.z != 0) break;
    r2.zw = icb[r2.y+0].xy + float2(1,-1);
    r2.zw = r2.zw * u_param[0].xy + v1.xy;
    r2.zw = min(u_param[1].zw, r2.zw);
    r3.xyzw = s_Source_NedSmpignorenametexture.SampleLevel(s_Source_sampler_s, r2.zw, 0).xyzw;
    r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
    r3.xyzw = min(float4(65504,65504,65504,65504), r3.xyzw);
    r2.z = max(r3.y, r3.z);
    r2.z = max(r3.x, r2.z);
    r2.z = 1 + r2.z;
    r2.z = 1 / r2.z;
    r1.xyzw = r3.xyzw * r2.zzzz + r1.xyzw;
    r2.x = r2.x + r2.z;
    r2.y = (int)r2.y + 1;
  }
  r1.xyzw = r1.xyzw / r2.xxxx;
  r0.xyzw = r1.xyzw * float4(0.125,0.125,0.125,0.125) + r0.xyzw;
  r1.xyzw = float4(0,0,0,0);
  r2.xy = float2(0,0);
  while (true) {
    r2.z = cmp((int)r2.y >= 4);
    if (r2.z != 0) break;
    r2.zw = icb[r2.y+0].xy + float2(1,1);
    r2.zw = r2.zw * u_param[0].xy + v1.xy;
    r2.zw = min(u_param[1].zw, r2.zw);
    r3.xyzw = s_Source_NedSmpignorenametexture.SampleLevel(s_Source_sampler_s, r2.zw, 0).xyzw;
    r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
    r3.xyzw = min(float4(65504,65504,65504,65504), r3.xyzw);
    r2.z = max(r3.y, r3.z);
    r2.z = max(r3.x, r2.z);
    r2.z = 1 + r2.z;
    r2.z = 1 / r2.z;
    r1.xyzw = r3.xyzw * r2.zzzz + r1.xyzw;
    r2.x = r2.x + r2.z;
    r2.y = (int)r2.y + 1;
  }
  r1.xyzw = r1.xyzw / r2.xxxx;
  r0.xyzw = r1.xyzw * float4(0.125,0.125,0.125,0.125) + r0.xyzw;
  if (shader_injection.bloom_luminance_valid != 0.f && shader_injection.fx_bloom_threshold > 0.f) {
    // Gate the bloom source before building the mip pyramid.
    float threshold = shader_injection.fx_bloom_threshold * (adapted_luminance.Load(int3(0, 0, 0)).x + 0.001f);
    float knee = 0.5f * threshold;
    float luma = renodx::color::y::from::BT709(r0.rgb);
    float soft_excess = clamp(luma - threshold + knee, 0.f, 2.f * knee);
    soft_excess = soft_excess * soft_excess / (4.f * knee + 1e-5f);
    r0.rgb *= max(soft_excess, luma - threshold) / max(luma, 1e-5f);
  }
  o0.xyzw = min(float4(65504,65504,65504,65504), r0.xyzw);
  return;
}
