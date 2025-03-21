#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Mar 20 19:55:35 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (RENODX_TONE_MAP_TYPE == 0) {
    r0.yw = float2(0.125, 0.375);
    r1.xyzw = t0.Sample(s0_s, v1.xy).zxyw;
    r0.xz = r1.yz;
    r2.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
    r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
    r2.xyz = float3(0, 1, 0) * r2.xyz;
    r0.xyz = r0.xyz * float3(1, 0, 0) + r2.xyz;
    o0.w = r1.w;
    r1.y = 0.625;
    r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
    r0.xyz = r1.xyz * float3(0, 0, 1) + r0.xyz;
    r0.w = dot(r0.xyz, float3(0.219999999, 0.707000017, 0.0710000023));
    r0.xyz = r0.xyz + -r0.www;
    o0.xyz = cb0[2].xxx * r0.xyz + r0.www;

    o0 = saturate(o0);
    return;
  }

  float4 sampled_color = t0.Sample(s0_s, v1.xy).rgba;
  o0.a = sampled_color.a;

  float3 gamma_color = sampled_color.rgb;

  float3 untonemapped = renodx::color::srgb::Decode(gamma_color.rgb);

  float3 neutral_sdr = renodx::tonemap::renodrt::NeutralSDR(untonemapped);

  
  gamma_color = renodx::color::srgb::Encode(neutral_sdr);

  gamma_color.r = t1.Sample(s1_s, float2(gamma_color.r, 0.125)).r;
  gamma_color.g = t1.Sample(s1_s, float2(gamma_color.g, 0.375)).g;
  gamma_color.b = t1.Sample(s1_s, float2(gamma_color.b, 0.625)).b;
  float luma = dot(gamma_color, float3(0.219999999, 0.707000017, 0.0710000023));
  gamma_color.rgb = lerp(luma, gamma_color.rgb, cb0[2].x);

  float3 graded_color = renodx::color::srgb::Decode(gamma_color);

  float3 tonemapped = renodx::draw::ToneMapPass(untonemapped, graded_color, neutral_sdr);
  o0.rgb = renodx::draw::RenderIntermediatePass(tonemapped);
  return;
}
