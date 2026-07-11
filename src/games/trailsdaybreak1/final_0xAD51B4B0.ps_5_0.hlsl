// ---- Created with 3Dmigoto v1.3.16 on Mon Oct 21 22:42:43 2024
// Final shader, but no UI -- just untonemapped game
// Game does 2.3 gamma by default

#include "./shared.h"
#include "./tonemapper.hlsl"

cbuffer Constants : register(b0) {
  float gamma : packoffset(c0);
  uint hdr_enabled : packoffset(c0.y);
  float hdr_peak_brightness : packoffset(c0.z);
}

SamplerState smpl_s : register(s0);
Texture2D<float4> tex : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_Position0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = tex.SampleLevel(smpl_s, v1.xy, 0).xyz;  // Sample game, already in gamma space

  r0.rgb = injectedData.gamma ? renodx::math::PowSafe(r0.rgb, 2.3f) : renodx::math::PowSafe(r0.rgb, 2.2f);  // The game does 2.3 gamma default

  r0.rgb = applyUserTonemap(r0.rgb);  // Send our color to tonemapper.hlsl to get processed!

  if (injectedData.ColorGradeColorSpace == 1.f) {
    r0.rgb = renodx::color::bt709::from::BT709D93(r0.rgb);
  }

  r0.rgb *= injectedData.toneMapGameNits / 80.f;  // paper white

  o0.rgb = r0.rgb;
  o0.w = 1;
  return;
}
