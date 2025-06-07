#include "./common.hlsl"

Texture2D<float4> t12 : register(t12);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[2];
}

void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  float4 v2 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0.5,0.5) + v2.xy;
  r0.xy = cb0[0].xy * r0.xy;
  r0.x = t12.Sample(s12_s, r0.xy).x;
  r0.x = r0.x * cb0[0].w + -cb0[0].z;
  r0.x = -v1.y + r0.x;
  r0.x = saturate(0.00833333377 * r0.x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.x = r0.x * r0.x;
  r1.xyzw = t0.Sample(s0_s, v0.zw).xyzw;
  r1.xyzw = cb0[1].wwww * r1.xyzw;
  r2.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.y = 1 + -cb0[1].w;
  r1.xyzw = r0.yyyy * r2.xyzw + r1.xyzw;
  r0.y = v1.x * r1.w;
  o0.xyz = r1.xyz + r1.xyz;
  o0.w = r0.y * r0.x * injectedData.fxFog;
  return;
}