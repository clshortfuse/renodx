#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[0].z * cb0[3].y + cb0[0].y;
  r1.x = cb0[0].x * cb0[1].x + cb0[3].x;
  r1.y = cb0[0].x * cb0[1].y + r0.x;
  r0.xy = v0.xy + -r1.xy;
  r0.z = 0.03125 * cb0[2].x;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r2.xyzw = r1.xyzw;
  r3.xy = v0.xy;
  r0.w = 1;
  int i = 0;
  while (true) {
    if (i >= 32) break;
    r3.xy = -r0.xy * r0.zz + r3.xy;
    r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
    r3.w = t1.Sample(s1_s, r3.xy).w;
    r4.xyzw = r4.xyzw * r3.wwww;
    r4.xyzw = r4.xyzw * r0.wwww;
    r2.xyzw = r4.xyzw * cb0[2].zzzz * injectedData.fxLightRays + r2.xyzw;
    r0.w = cb0[2].y * r0.w;
    i += 1;
  }
  o0.xyzw = cb0[2].wwww * r2.xyzw;
  return;
}