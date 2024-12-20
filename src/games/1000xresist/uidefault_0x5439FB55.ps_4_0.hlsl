#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Fri Dec 13 18:10:58 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float4 v2: TEXCOORD0,
    float4 v3: TEXCOORD1,
    float4 v4: TEXCOORD2,
    out float4 o0: SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = cb0[3].xyzw + r0.xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  o0.xyz = r0.xyz * r0.www;
  o0.rgb = UIScale(o0.rgb);
  o0.w = r0.w;
  return;
}
