#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[5];
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
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 255 * v1.w;
  r0.x = round(r0.x);
  r0.w = 0.00392156886 * r0.x;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.xyzw = cb0[3].xyzw + r1.xyzw;
  r0.xyz = v1.xyz;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r1.xy = cb0[4].zw + -cb0[4].xy;
  r1.xy = -abs(v4.xy) + r1.xy;
  r1.xy = saturate(v4.zw * r1.xy);
  r1.x = r1.x * r1.y;
  r1.y = r0.w * r1.x + -0.00100000005;
  r0.w = r1.x * r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  r0.x = cmp(r1.y < 0);
  if (r0.x != 0) discard;

  o0.rgb = UIScale(o0.rgb);
  return;
}
