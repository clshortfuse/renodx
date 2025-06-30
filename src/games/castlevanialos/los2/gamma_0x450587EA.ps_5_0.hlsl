#include "../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb4 : register(b4){
  float4 cb4[236];
}
cbuffer cb3 : register(b3){
  float4 cb3[77];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD8,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float4 v4 : TEXCOORD9,
  float4 v5 : TEXCOORD0,
  float4 v6 : TEXCOORD1,
  float4 v7 : TEXCOORD2,
  float4 v8 : TEXCOORD3,
  float4 v9 : TEXCOORD4,
  float4 v10 : TEXCOORD5,
  float4 v11 : TEXCOORD6,
  float4 v12 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v6.xy).xyzw;

  float3 untonemapped = r0.rgb;

  r1.xyzw = cb4[8].xxxx * r0.xyzw;
  r0.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
  r1.xyzw = r0.xyzw * cb4[8].zzzz + -r1.xyzw;
  r0.xyzw = t0.Sample(s0_s, v6.zw).xyzw;
  r1.xyzw = r0.xyzw * -cb4[8].xxxx + r1.xyzw;
  r0.xyzw = t0.Sample(s0_s, v7.xy).xyzw;
  r1.xyzw = r0.xyzw * -cb4[8].yyyy + r1.xyzw;
  r0.xyzw = t0.Sample(s0_s, v7.zw).xyzw;
  r0.xyzw = r0.zxyw * -cb4[8].yyyy + r1.zxyw;
  r1.x = r0.y;
  r1.y = cb4[9].x;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  o0.x = r1.x;
  r0.y = cb4[9].x;
  r1.xyzw = t1.Sample(s1_s, r0.zy).xyzw;
  o0.y = r1.y;
  o0.w = r0.w;
  r0.y = cb4[9].x;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  o0.z = r0.z;

  o0.rgb = untonemapped;
  if (RENODX_TONE_MAP_TYPE == 0)
  {
    o0.rgb = saturate(untonemapped);
  }
  return;
}