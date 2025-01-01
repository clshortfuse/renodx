#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

// 3Dmigoto declarations
#define cmp -

// Final shader before UI draws in when user brightness slider, or other post
// process parameter driven by the game, are not neutral.

// Unfortunately this runs after tonemapping because this shader doesn't always
// run, and determining when and when it would not run in earlier passes is
// hard, so the color peak could go beyond the peak display brightness,
// but ultimately it doesn't really matter
void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;

  r1.xyz = cb0[7].xyz;
  r1.w = r0.w;
  r0.xyzw = r0.xyzw * cb0[6].xxxx + -r1.xyzw;
  r0.xyzw = r0.xyzw * cb0[6].yyyy + r1.xyzw;  //  remove unecessary saturate()

  if (injectedData.toneMapType == 0) {
    r0.xyz = saturate(r0.xyz);
  }

#if 0  // Gamma slider (applies in gamma space) (defaults to 1) (fixed to allow negative scRGB values just in case)
  o0.xyzw = float4(renodx::math::SafePow(r0.xyz, cb0[6].zzz), saturate(r0.w));
#else
  o0.rgba = float4(r0.rgb, saturate(r0.a));
#endif

  return;
}
