#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[2];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -asint(cb2[1].x);
  r1.y = 0;
  r2.xyzw = float4(0, 0, 0, 0);
  r0.y = r0.x;
  while (true) {
    r0.z = cmp(asint(cb2[1].x) < (int)r0.y);
    if (r0.z != 0) break;
    r0.z = (int)r0.y;
    r1.x = cb2[0].z * r0.z;
    r0.zw = v1.xy + r1.xy;
    r3.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
    r1.xzw = saturate(-cb2[0].yyy + r3.xyz);
    r0.z = r1.x + r1.z;
    r0.z = r0.z + r1.w;
    r0.z = cmp(0 < r0.z);
    r0.w = dot(r3.xyzw, r3.xyzw);
    r0.w = rsqrt(r0.w);
    r3.xyzw = r3.xyzw * r0.wwww;
    r3.xyzw = r0.zzzz ? r3.xyzw : 0;
    r2.xyzw = r3.xyzw + r2.xyzw;
    r0.y = (int)r0.y + 1;
  }
  o0.xyzw = cb2[0].xxxx * r2.xyzw;

  o0.rgb *= injectedData.fxBloom;
  return;
}
