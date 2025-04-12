#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[27];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float4 v2: COLOR1,
    float4 v3: TEXCOORD0,
    float4 v4: TEXCOORD1,
    float4 v5: TEXCOORD2,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = -v2.xyzw + v1.xyzw;
  r1.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r1.xy = saturate(r1.ww * v4.xx + -v4.zy);
  r0.xyzw = r1.xxxx * r0.xyzw + v2.xyzw;
  r0.xyzw = r0.xyzw * r1.yyyy;
  r1.xy = cb0[26].zw + -cb0[26].xy;
  r1.xy = -abs(v5.xy) + r1.xy;
  r1.xy = saturate(v5.zw * r1.xy);
  r1.x = r1.x * r1.y;
  o0.xyzw = r1.xxxx * r0.xyzw;

  o0.rgb = UIScale(o0.rgb);

  return;
}
