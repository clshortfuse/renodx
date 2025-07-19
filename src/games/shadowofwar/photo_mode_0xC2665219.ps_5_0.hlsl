#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Fri Oct 04 16:28:22 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[53];
}

cbuffer cb3 : register(b3) {
  float4 cb3[1];
}

cbuffer cb0 : register(b0) {
  float4 cb0[26];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    uint v3: SV_IsFrontFace0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1.5 + -cb3[0].x;
  r0.x = 1 / r0.x;
  r0.y = cmp(0.5 >= cb3[0].x);
  r0.z = 0.5 + cb3[0].x;
  r0.x = r0.y ? r0.z : r0.x;
  r0.yz = min(cb2[22].zw, v1.zw);
  r0.yzw = t0.Sample(s0_s, r0.yz).xyz;  // main tex

  r0.yzw = (r0.yzw / cb0[25].xxx);  //   r0.yzw = saturate(r0.yzw / cb0[25].xxx);  // clamp photo mode, breaks otherwise
  if (RENODX_TONE_MAP_TYPE == 0.f) r0.yzw = saturate(r0.yzw);

  r1.xyz = -r0.yzw * float3(2, 2, 2) + float3(2, 2, 2);
  r1.xyz = sign(r1.xyz) * pow(abs(r1.xyz), r0.x);
  r1.xyz = float3(2, 2, 2) + -r1.xyz;
  r1.xyz = float3(0.5, 0.5, 0.5) * r1.xyz;
  r2.xyz = r0.yzw + r0.yzw;
  r0.y = dot(r0.yzw, float3(0.300000012, 0.589999974, 0.109999999));
  r0.y = cmp(r0.y < 0.5);

  r0.xzw = sign(r2.xyz) * pow(abs(r2.xyz), r0.x);  //  r0.xzw = pow(r2.xyz, r0.x);

  r0.xzw = float3(0.5, 0.5, 0.5) * r0.xzw;

  r0.xyz = (r0.yyy ? r0.xzw : r1.xyz);  //  r0.xyz = saturate(r0.yyy ? r0.xzw : r1.xyz);
  if (RENODX_TONE_MAP_TYPE == 0.f) r0.rgb = saturate(r0.rgb);

  o0.xyz = cb0[25].xxx * r0.xyz;  // 500 nits paper white
  o0.w = 1;
  return;
}
