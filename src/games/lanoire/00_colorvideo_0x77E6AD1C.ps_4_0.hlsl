#include "../../common/color.hlsl"
#include "../../common/tonemap.hlsl"
#include "./shared.h"

cbuffer dx11_constants : register(b0) {
  float4 consta : packoffset(c0);
  float4 focus : packoffset(c1);
}

SamplerState tex0_s : register(s0);
SamplerState tex1_s : register(s1);
SamplerState tex2_s : register(s2);
Texture2D<float4> tex0_t : register(t0);
Texture2D<float4> tex1_t : register(t1);
Texture2D<float4> tex2_t : register(t2);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_Position0, float2 v1 : TEXCOORD0, out float4 o0 : SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex2_t.Sample(tex2_s, v1.xy).xyzw;
  r0.xyz = float3(0, -0.391448975, 2.01782227) * r0.www;
  r1.xyzw = tex1_t.Sample(tex1_s, v1.xy).xyzw;
  r0.xyz = r1.www * float3(1.59579468, -0.813476563, 0) + r0.xyz;
  r1.xyzw = tex0_t.Sample(tex0_s, v1.xy).xyzw;
  r0.xyz = r1.www * float3(1.16412354, 1.16412354, 1.16412354) + r0.xyz;
  r0.xyz = float3(-0.87065506, 0.529705048, -1.08166885) + r0.xyz;
  r0.w = 1;
  o0.xyzw = consta.xyzw * r0.xyzw;

  o0 = saturate(o0);
  o0 = injectedData.toneMapGammaCorrection ? pow(o0, 2.2f) : linearFromSRGBA(o0);
  float videoPeak = injectedData.toneMapPeakNits / (injectedData.toneMapGameNits / 203.f);
  o0.rgb = bt2446a_inverse_tonemapping_bt709(o0.rgb, 100.f, videoPeak);
  o0.rgb *= injectedData.toneMapPeakNits / videoPeak;
  o0.rgb /= 80.f;
  return;
}
