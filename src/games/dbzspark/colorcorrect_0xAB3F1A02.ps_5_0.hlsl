// ---- Created with 3Dmigoto v1.3.16 on Fri Oct 18 20:09:46 2024
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[4];
}

cbuffer cb0 : register(b0) {
  float4 cb0[39];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_POSITION0,
                out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 hdrColor, sdrColor, vanilla, outputColor;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.xy = cb0[38].zw * r0.xy;
  r0.xy = r0.xy * cb0[5].xy + cb0[4].xy;
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;  // This is in PQ
  hdrColor = r0.rgb;

  hdrColor = renodx::color::pq::Decode(hdrColor);
  sdrColor = renodx::color::srgb::DecodeSafe(hdrColor);

  r0.rgb = sdrColor;
  r1.xyz = cb1[2].xxx + -cb1[2].yzw;
  r1.xyz = r0.xyz * r1.xyz + cb1[2].yzw;

  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r1.xyz = min(float3(100, 100, 100), r1.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r1.xyz * float3(0.5, 0.5, 0.5) + r0.xyz;
  r1.xyz = cb1[3].yzw + -r0.xyz;
  r0.xyz = cb1[3].xxx * r1.xyz + r0.xyz;
  o0.xyz = max(float3(0, 0, 0), r0.xyz);

  vanilla = o0.xyz;
  outputColor = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, vanilla, 1.f);
  outputColor = renodx::color::pq::Encode(outputColor);

  o0.rgb = outputColor;
  o0.w = 0;
  return;
}