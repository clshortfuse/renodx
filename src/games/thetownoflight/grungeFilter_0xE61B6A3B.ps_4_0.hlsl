#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[7];
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

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;

  // normalize white level to the same range as SDR (theoretically 80 nits)
  r0.rgb = renodx::color::gamma::DecodeSafe(r0.rgb, 2.2f);
  r0.rgb /= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  r0.rgb = renodx::color::gamma::EncodeSafe(r0.rgb, 2.2f);

#if 0  // remove unecessary saturate()
    r0.xyzw = saturate(r0.xyzw);
#endif
  r1.xyz = float3(1, 1, 1) + -r0.xyz;

  r1.xyz = renodx::math::SafePow(r1.xyz, cb0[6].x);  // fix to allow negative scRGB values

  r1.w = exp2(cb0[6].x);
  r1.w = 0.5 * r1.w;
  r1.xyz = -r1.xyz * r1.www + float3(1, 1, 1);

  r2.xyz = renodx::math::SafePow(r0.xyz, cb0[6].x);  // fix to allow negative scRGB values

  r1.xyz = -r2.xyz * r1.www + r1.xyz;
  r2.xyz = r2.xyz * r1.www;
  r0.xyz = cmp(r0.xyz >= float3(0.5, 0.5, 0.5));
  o0.w = r0.w;
  r0.xyz = r0.xyz ? float3(1, 1, 1) : 0;
  o0.xyz = r0.xyz * r1.xyz + r2.xyz;

  o0.rgb = renodx::color::gamma::DecodeSafe(o0.rgb, 2.2f);
  o0.rgb *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  o0.rgb = renodx::color::gamma::EncodeSafe(o0.rgb, 2.2f);

  return;
}
