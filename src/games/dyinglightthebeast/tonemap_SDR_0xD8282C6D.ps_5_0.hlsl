// ---- Created with 3Dmigoto v1.4.1 on Fri Sep 19 14:29:52 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (uint2)v0.xy;
  r0.zw = float2(0, 0);
  r0.xyzw = t0.Load(r0.xyz).xyzw;
  r1.x = t1.Load(float4(0, 0, 0, 0)).x;
  r0.xyz = r1.xxx * r0.xyz;
  o0.w = r0.w;
  r0.w = dot(float3(0.212500006, 0.715399981, 0.0720999986), r0.xyz);
  r1.xy = r0.ww * cb0[0].xy + cb0[0].zw;
  r0.w = r1.x / r1.y;
  o0.xyz = r0.xyz * r0.www;
  return;
}
