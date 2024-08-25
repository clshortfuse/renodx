#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:03 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[8];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float3 v5 : TEXCOORD4,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v3.xz, 0).xyzw;

  float3 inputColor = r0.xyz;

  r0.xyzw = cb0[2].zzzz * r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v3.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[2].yyyy + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v3.xw, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[2].wwww + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v5.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[3].xxxx + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v5.xz, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[3].yyyy + r0.xyzw;
  r1.xyz = r0.xyz * float3(0.996093988,0.996093988,0.996093988) + float3(0.00195299997,0.00195299997,0.00195299997);  // 255/256 + 1/512
  o0.w = r0.w;
  r0.x = r1.z;
  r0.y = cb0[1].w;
  r0.z = t0.SampleLevel(s0_s, r0.xy, 0).z;
  r2.xz = r1.xy;
  r2.yw = cb0[1].ww;
  r0.x = t0.SampleLevel(s0_s, r2.xy, 0).x;
  r0.y = t0.SampleLevel(s0_s, r2.zw, 0).y;
  r1.w = cb0[0].w;
  r2.x = t0.SampleLevel(s0_s, r1.xw, 0).x;
  r2.y = t0.SampleLevel(s0_s, r1.yw, 0).y;
  r2.z = t0.SampleLevel(s0_s, r1.zw, 0).z;
  r0.xyz = -r2.xyz + r0.xyz;
  r0.xyz = cb0[2].xxx * r0.xyz + r2.xyz;
  r1.xyz = t0.SampleLevel(s0_s, v4.xy, 0).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[3].zzz * r1.xyz + r0.xyz;
  r1.xyz = t0.SampleLevel(s0_s, v4.xz, 0).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[3].www * r1.xyz + r0.xyz;
  r1.xyz = t0.SampleLevel(s0_s, v4.xw, 0).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[4].www * r1.xyz + r0.xyz;
  r1.xyz = t0.SampleLevel(s0_s, v1.xy, 0).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[5].www * r1.xyz + r0.xyz;
  r1.xyz = t0.SampleLevel(s0_s, v1.xz, 0).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[6].www * r1.xyz + r0.xyz;
  r1.xyz = t0.SampleLevel(s0_s, v1.xw, 0).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[7].xxx * r1.xyz + r0.xyz;
  r1.xyz = t0.SampleLevel(s0_s, v2.xy, 0).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[7].yyy * r1.xyz + r0.xyz;
  r1.xyz = t0.SampleLevel(s0_s, v2.xz, 0).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[7].zzz * r1.xyz + r0.xyz;
  r1.xyz = t0.SampleLevel(s0_s, v2.xw, 0).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  o0.xyz = cb0[7].www * r1.xyz + r0.xyz;

  o0.xyz = lerp(inputColor, o0.xyz, injectedData.colorGradeLUTStrength);

  return;
}