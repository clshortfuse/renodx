#include "./shared.h" // RenoDX

cbuffer cbBlur : register(b10)
{
  float4 u_param[2] : packoffset(c0);
}

SamplerState s_Source_sampler_s : register(s0);
Texture2D<float4> s_Source_NedSmpignorenametexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  const float4 icb[] = { { -1.000000, -1.000000, 0.062500, 0},
                              { -1.000000, 1.000000, 0.062500, 0},
                              { 1.000000, -1.000000, 0.062500, 0},
                              { 1.000000, 1.000000, 0.062500, 0},
                              { 0, -1.000000, 0.125000, 0},
                              { -1.000000, 0, 0.125000, 0},
                              { 1.000000, 0, 0.125000, 0},
                              { 0, 1.000000, 0.125000, 0},
                              { 0, 0, 0.250000, 0} };
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(0,0,0,0);
  r1.x = 0;
  while (true) {
    r1.y = cmp((int)r1.x >= 9);
    if (r1.y != 0) break;
    r1.yz = icb[r1.x+0].xy * u_param[0].zz;
    r1.yz = r1.yz * u_param[0].xy + v1.xy;
    r1.yz = min(u_param[1].zw, r1.yz);
    r2.xyzw = s_Source_NedSmpignorenametexture.SampleLevel(s_Source_sampler_s, r1.yz, 0).xyzw;
    r2.xyzw = max(float4(0,0,0,0), r2.xyzw);
    r2.xyzw = min(float4(65504,65504,65504,65504), r2.xyzw);
    r0.xyzw = r2.xyzw * icb[r1.x+0].zzzz + r0.xyzw;
    r1.x = (int)r1.x + 1;
  }
  r0.xyzw = u_param[0].wwww * r0.xyzw;
  if (shader_injection.bloom_composite == 0.f) {
    // Upsample source mip is target+1; mip levels 3-5 fade progressively with Bloom Haze.
    r0.xyz *= lerp(1.f, shader_injection.fx_bloom_haze, saturate((shader_injection.bloom_target_level + 1.f - 2.f) / 3.f));
  }
  if (shader_injection.bloom_composite != 0.f) {
    r0.xyz *= shader_injection.fx_bloom;
    r0.w = 0.f;  // Additive blend: keep scene alpha untouched.
  }
  o0.xyzw = min(float4(65504,65504,65504,65504), r0.xyzw);
  return;
}
