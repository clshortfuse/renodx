#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[16];
}

void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t0.Sample(s0_s, float2(0.5,0.5)).x;
  r0.x = 9.99999975e-06 + r0.x;
  r0.x = cb0[15].z / r0.x;
  r0.x = max(cb0[15].x, r0.x);
  r0.x = min(cb0[15].y, r0.x);
  r0.y = t1.Sample(s1_s, float2(0.5,0.5)).x;
  r0.x = r0.x + -r0.y;
  r0.x = cb0[13].w * r0.x + r0.y;
  r0.x = log2(r0.x);
  //r0.y = cmp(r0.x < 0);
  //r0.z = cmp(cb0[15].w < 0);
  //r0.y = r0.z ? r0.y : 0;
  r0.y = (cb0[15].w < 0) ? (r0.x < 0) : 0;
  r0.z = -cb0[15].w + r0.x;
  r0.w = min(0, r0.z);
  r0.z = max(0, r0.z);
  r0.y = r0.y ? r0.w : r0.x;
  //r0.x = cmp(0 < r0.x);
  //r0.w = cmp(0 < cb0[15].w);
  //r0.x = r0.w ? r0.x : 0;
  r0.x = (cb0[15].w > 0) ? (r0.x > 0) : 0;
  r0.x = r0.x ? r0.z : r0.y;
  //o0.xyzw = lerp(1.f, exp2(r0.xxxx), injectedData.fxAutoExposure);
  o0.xyzw = exp2(lerp(float4(1,1,1,1), r0.xxxx, injectedData.fxAutoExposure));
  return;
}