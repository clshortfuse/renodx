#include "./shared.h"
// ---- Created with 3Dmigoto v1.3.16 on Thu Feb  6 16:55:16 2025

cbuffer ParamBuffer : register(b1)
{
  float4 g_Param : packoffset(c0);
}

SamplerState g_Texture0Sampler_s : register(s0);
Texture2D<float4> g_Texture0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(-1,0.666666985);
  r1.zw = float2(0,-0.333332986);
  r2.xyzw = g_Texture0.Sample(g_Texture0Sampler_s, v1.xy).xyzw;

  float3 tonemapped, neutral_sdr = 0.f;

  [branch]
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    tonemapped = r2.rgb;
    tonemapped = renodx::draw::InvertIntermediatePass(tonemapped);
    neutral_sdr = saturate(renodx::tonemap::renodrt::NeutralSDR(tonemapped));
    r2.rgb = renodx::color::srgb::Encode(neutral_sdr);
  }

  r0.xy = r2.zy;
  r1.xy = r0.yx;
  r2.y = cmp(r0.y < r2.z);
  r0.xyzw = r2.yyyy ? r0.xyzw : r1.xyzw;
  r1.x = cmp(r2.x < r0.x);
  r3.xyz = r0.xyw;
  r3.w = r2.x;
  o0.w = r2.w;
  r0.xyw = r3.wyx;
  r0.xyzw = r1.xxxx ? r3.xyzw : r0.xyzw;
  r1.x = min(r0.w, r0.y);
  r1.x = -r1.x + r0.x;
  r1.y = r1.x * 6 + 1.00000001e-10;
  r1.y = rcp(r1.y);
  r0.y = r0.w + -r0.y;
  r0.y = r0.y * r1.y + r0.z;
  r0.x = -r1.x * 0.5 + r0.x;
  r0.y = g_Param.x * 0.00370370364 + abs(r0.y);
  r0.yzw = r0.yyy * float3(6,6,6) + float3(-3,-2,-4);
  r0.yzw = saturate(abs(r0.yzw) * float3(1,-1,-1) + float3(-1,2,2));  
  r0.yzw = float3(-0.5,-0.5,-0.5) + r0.yzw;
  r1.y = r0.x * 2 + -1;
  r0.x = g_Param.z + r0.x;
  r1.y = 1 + -abs(r1.y);
  r1.y = rcp(r1.y);
  r1.x = saturate(r1.x * r1.y);
  r1.x = g_Param.y + r1.x;
  r1.y = r0.x * 2 + -1;
  r1.y = 1 + -abs(r1.y);
  r1.x = r1.y * r1.x;
  o0.xyz = r0.yzw * r1.xxx + r0.xxx;

  [branch]
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    o0.rgb = renodx::color::srgb::Decode(o0.rgb);
    o0.rgb = renodx::tonemap::UpgradeToneMap(tonemapped, neutral_sdr, o0.rgb, 1.f);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  }
  
  return;
}