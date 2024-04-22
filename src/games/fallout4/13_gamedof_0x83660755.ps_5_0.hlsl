#include "./shared.h"

Texture2D<float4> t2 : register(t2);  // depth

Texture2D<float4> t1 : register(t1);  // blur

Texture2D<float4> t0 : register(t0);  // render

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[4];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t2.Sample(s2_s, v1.xy).x;
  r0.x = 1 + -r0.x;
  r0.y = r0.x * cb2[2].z + cb2[2].y;
  r0.x = cmp(9.99999975e-06 < r0.x);
  r0.y = cb2[2].w / r0.y;
  r0.y = -cb2[0].z + r0.y;
  r0.y = saturate(r0.y / cb2[0].y);
  r0.y = cb2[1].x * r0.y;
  r0.z = cmp(0 != cb2[1].w);
  r0.z = ~(int)r0.z;
  r0.x = (int)r0.z | (int)r0.x;
  r0.x = r0.x ? r0.y : 0;
  r0.yz = cb2[3].zw * v1.xy;
  r1.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  // r1.xyzw = -r2.xyzw + r1.xyzw;
  // o0.xyzw = r0.xxxx * r1.xyzw + r2.xyzw;
  
  // o0.xyzw = r0.xxxx * (r1.xyzw - r2.xyzw) + r2.xyzw;
  o0.xyzw = lerp(r2.xyzw, r1.xyzw, r0.x * injectedData.fxDoF);
  return;
}
