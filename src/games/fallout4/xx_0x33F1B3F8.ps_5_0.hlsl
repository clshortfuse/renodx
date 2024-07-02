#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[15];
}

cbuffer cb1 : register(b1) {
  float4 cb1[3];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float4 v1 : TEXCOORD0, float4 v2 : COLOR1, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = cb1[0].xyzw * r0.xyzw;
  r0.x = cb2[13].w * r1.w;
  r2.xyz = cb2[13].xyz * r1.xyz + -r1.xyz;
  r1.xyz = cb1[2].xxx * r2.xyz + r1.xyz;
  r0.y = 1 + -v2.w;
  o0.xyz = r1.xyz * r0.yyy;
  r0.y = cb2[13].w * r1.w + -cb2[14].x;
  r0.y = cmp(r0.y < 0);
  if (r0.y != 0) discard;
  r0.y = cmp(cb2[14].y < 1);
  if (r0.y != 0) {
    r0.y = cb2[14].y + -r0.w;
    r0.y = cmp(r0.y < 0);
    if (r0.y != 0) discard;
  }
  o0.w = r0.x;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::bt709::from::SRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
