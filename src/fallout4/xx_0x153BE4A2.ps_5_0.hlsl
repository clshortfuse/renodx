#include "../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[15];
}

cbuffer cb1 : register(b1) {
  float4 cb1[3];
}

cbuffer cb0 : register(b0) {
  float4 cb0[2];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
              float4 v1 : TEXCOORD0,
                          float4 v2 : TEXCOORD4,
                                      float4 v3 : COLOR0,
                                                  float4 v4 : COLOR1,
                                                              float3 v5 : TEXCOORD1,
                                                                          out float4 o0 : SV_Target0
) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = log2(v3.xyzw);
  r0.xyzw = float4(2.20000005, 2.20000005, 2.20000005, 2.20000005) * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyzw = cb1[0].xyzw * r0.xyzw;
  r0.xyzw = r0.xyzw * r1.xyzw;
  r1.xyz = cb2[13].xyz * r0.xyz + -r0.xyz;
  r0.xyz = cb1[2].xxx * r1.xyz + r0.xyz;
  r1.xyz = v4.xyz + -r0.xyz;
  r0.xyz = v4.www * r1.xyz + r0.xyz;
  r0.w = cb2[13].w * r0.w + -cb2[14].x;
  r0.w = cmp(r0.w < 0);
  if (r0.w != 0) discard;
  r0.w = cmp(cb0[1].y == 0.000000);
  if (r0.w != 0) {
    r2.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
    r2.xyzw = log2(r2.xyzw);
    r2.xyzw = float4(2.20000005, 2.20000005, 2.20000005, 2.20000005) * r2.xyzw;
    r2.xyzw = exp2(r2.xyzw);
  } else {
    r2.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
  }
  r2.xyz = r2.xyz * cb0[1].www + r0.xyz;
  r0.x = cmp(cb0[1].x != 0.000000);
  r3.xyzw = cb1[0].wwww * r2.xyzw;
  r0.xyzw = r0.xxxx ? r3.xyzw : r2.xyzw;
  o0.w = cb0[1].z * r0.w;
  r0.w = cmp(cb2[14].y < 1);
  if (r0.w != 0) {
    r0.w = cb2[14].y + -r1.w;
    r0.w = cmp(r0.w < 0);
    if (r0.w != 0) discard;
  }
  o0.xyz = r0.xyz;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
