#include "./shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);  // post lut

cbuffer cb2 : register(b2) {
  float4 cb2[4];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, float2 w1 : TEXCOORD1, float2 v2 : TEXCOORD2, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0.5, 0.5) + -v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = saturate(r0.x * 1.41421354 + -cb2[2].x);
  r0.x = cb2[2].y * r0.x;
  r1.xy = (int2)w1.xy;
  r1.zw = float2(0, 0);
  r0.y = t2.Load(r1.xyw).x;
  r1.xyzw = t0.Load(r1.xyz).xyzw;
  r0.y = r0.y * 2 + -1;
  r0.y = -r0.y * cb2[3].z + cb2[3].y;
  r0.y = cb2[3].x / r0.y;
  r0.z = -cb2[0].y + r0.y;
  r0.z = max(0, r0.z);
  r0.z = saturate(r0.z / cb2[0].w);
  r0.z = cb2[2].z * r0.z;
  r0.w = cmp(r0.y >= cb2[3].w);
  r0.y = cb2[0].x + -r0.y;
  r0.y = max(0, r0.y);
  r0.y = saturate(r0.y / cb2[0].z);
  r2.x = cmp(cb2[2].w == 1.000000);
  r0.w = r0.w ? r2.x : 0;
  r0.z = r0.w ? 0 : r0.z;
  r0.w = max(r0.z, r0.x);
  r0.x = cmp(0 < r0.x);
  r2.x = cb2[2].z + cb2[2].z;
  r2.y = r2.x * r0.y;
  r0.y = -r2.x * r0.y + r0.z;
  r0.z = max(r2.y, r0.w);
  r0.x = r0.x ? -r0.z : r0.y;
  r0.x = cmp(abs(r0.x) == 0.000000);
  r2.xy = (int2)v2.xy;
  r2.zw = float2(0, 0);
  r2.xyzw = t1.Load(r2.xyz).xyzw;
  r0.y = cmp(r2.w == 0.000000);
  r0.x = (int)r0.y | (int)r0.x;

  // r1 is already linearized and scaled
  r2.xyz *= injectedData.toneMapGameNits / 80.f;

  o0.xyzw = r0.xxxx ? r1.xyzw : r2.xyzw;
  return;
}
