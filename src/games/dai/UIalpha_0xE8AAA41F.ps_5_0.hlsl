#include "./common.hlsl"

cbuffer _Globals : register(b0) {
  float2 invPixelSize : packoffset(c0);
  float4x4 mvp : packoffset(c1);
  float4 texgen0 : packoffset(c5);
  float4 texgen1 : packoffset(c6);
  float4 texgen2 : packoffset(c7);
  float4 texgen3 : packoffset(c8);
  float4 g_color : packoffset(c9);
  float4 cxmul : packoffset(c10);
  float4 cxadd : packoffset(c11);
  float4 filterTexScale : packoffset(c12);
  float4 filterOffset : packoffset(c13);
  float4 filterShadowColor : packoffset(c14);
  float4 filterShadowTexScale : packoffset(c15);
  float4 aaCircleData : packoffset(c16);
  float4 aaLinePlane0 : packoffset(c17);
  float4 aaLinePlane1 : packoffset(c18);
  float4 aaLinePlane2 : packoffset(c19);
  float4 aaLinePlane3 : packoffset(c20);
  float4 distanceFieldParams0 : packoffset(c21);
  float4 distanceFieldParams1 : packoffset(c22);
  float4 distanceFieldParams2 : packoffset(c23);
  float4 cctvDistortParams0 : packoffset(c24);
  float4 cctvDistortParams1 : packoffset(c25);
  float4 kinectTrackingParams : packoffset(c26);
  float4 combatAreaSecondColor : packoffset(c27);
  float4 combatAreaParams : packoffset(c28);
  float4 postProcessDistortParams0 : packoffset(c29);
  float4 postProcessDistortParams1 : packoffset(c30);
}
SamplerState mainTextureSampler_s : register(s0);
Texture2D<float4> mainTexture : register(t0);

void main(
    float4 v0: SV_Position0,
    float4 v1: COLOR0,
    float4 v2: COLOR1,
    float2 v3: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = mainTexture.Sample(mainTextureSampler_s, v3.xy).xyzw;
  r0.xyzw = -v1.xyzw + r0.xyzw;
  r0.xyzw = v2.zzzz * r0.xyzw + v1.xyzw;
  r0.xyzw = r0.xyzw * cxmul.xyzw + cxadd.xyzw;
  o0.w = v2.w * r0.w;
  o0.xyz = r0.xyz;
  o0.a = max(0, o0.a);
  return;
}
