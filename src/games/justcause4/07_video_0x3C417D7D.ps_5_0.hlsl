#include "./shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_Position0, float2 v1 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s0_s, v1.xy).x;
  r0.xyz = float3(1.59500003, -0.813000023, 0) * r0.xxx;
  r0.w = t0.Sample(s0_s, v1.xy).x;
  r0.xyz = r0.www * float3(1.16400003, 1.16400003, 1.16400003) + r0.xyz;
  r0.w = t2.Sample(s0_s, v1.xy).x;
  r0.xyz = r0.www * float3(0, -0.391000003, 2.01699996) + r0.xyz;
  o0.xyz = float3(-0.870000005, 0.528999984, -1.08159995) + r0.xyz;
  o0.w = 1;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::srgb::Decode(o0.rgb);
  float videoPeak = injectedData.toneMapPeakNits / (injectedData.toneMapGameNits / 203.f);
  o0.rgb = renodx::tonemap::inverse::bt2446a::BT709(o0.rgb, 100.f, videoPeak);
  o0.rgb *= injectedData.toneMapPeakNits / videoPeak;
  o0.rgb /= 80.f;
  return;
}
