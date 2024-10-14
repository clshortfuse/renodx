// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 11 21:13:03 2024
#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[129];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[21];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(1 < cb1[127].y);
  r0.y = 1.77777779 * cb1[127].y;
  r0.y = cb1[127].x / r0.y;
  r0.zw = v0.xy * cb1[128].xy + -cb1[126].xy;
  r1.yz = cb1[127].zw * r0.zw;
  r0.y = r1.y * r0.y;
  r1.x = r0.x ? r0.y : r1.y;
  r0.xy = cmp(r1.xz >= cb0[20].xy);
  r0.zw = cmp(cb0[20].zw >= r1.xz);
  r0.x = r0.z ? r0.x : 0;
  r0.x = r0.y ? r0.x : 0;
  r0.yz = cmp(r1.xz >= cb0[19].xy);
  r1.yw = cmp(cb0[19].zw >= r1.xz);
  r2.xyzw = t1.Sample(s0_s, r1.xz).xyzw;
  r0.y = r0.y ? r1.y : 0;
  r0.xy = r0.wz ? r0.xy : 0;
  r0.y = r1.w ? r0.y : 0;
  r0.x = (int)r0.y | (int)r0.x;
  r0.y = 1 + -r2.w;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r3.xyzw = r1.xyzw * r2.wwww;
  r3.xyzw = r0.yyyy * r3.xyzw + r2.xyzw;
  r0.y = 1 + -r1.w;
  r1.xyzw = r0.yyyy * r2.xyzw + r1.xyzw;
  o0.xyzw = r0.xxxx ? r3.xyzw : r1.xyzw;

  //o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);  // 2.2 gamma correction
  // o0.a = sign(o0.a) * pow(abs(o0.a), 2.2f); // 2.2 gamma on Alpha
  //o0.rgb *= injectedData.toneMapUINits / 80.f;  // Added ui slider
  //o0.rgb = renodx::math::SafePow(o0.rgb, 1 / 2.2);
  return;
}