// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:44:56 2025
#include "../common.hlsl"
#include "./drawbinary.hlsl"

Texture3D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb13 : register(b13)
{
  float4 cb13[3];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[4];
}

// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0,
  out float o1 : SV_TARGET1)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 colorUntonemapped, colorTonemapped;

  r0.xy = cb2[0].xy + v1.xy;
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;

  //colorUntonemapped
  colorUntonemapped = r0.xyz * Tonemap_CalculatePreExposureMultiplier(cb13[0].xyz, cb13[1].xyz, cb13[2].xyz);

  r1.xyz = cmp(r0.xyz < cb13[0].xxx);
  r2.xyzw = r1.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
  r0.xw = r2.xy * r0.xx + r2.zw;
  r2.x = saturate(r0.x / r0.w);
  r3.xyzw = r1.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
  r1.xyzw = r1.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
  r0.xz = r1.xy * r0.zz + r1.zw;
  r0.yw = r3.xy * r0.yy + r3.zw;
  r2.yz = saturate(r0.yx / r0.wz);

  r0.x = saturate(dot(r2.xyz, cb2[1].xyz));
  r0.y = saturate(dot(r2.xyz, cb2[2].xyz));
  r0.z = saturate(dot(r2.xyz, cb2[3].xyz));

  //to sRGB
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  // r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r0.xyz = max(float3(0,0,0), r0.xyz);

  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyz = t1.SampleLevel(s1_s, r0.xyz, 0).xyz;

  o0.xyz = r0.xyz;
  r0.x = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  o0.w = r0.x;
  o1.x = r0.x;

  //tonemap
  colorTonemapped = o0.xyz;
  o0.xyz = Tonemap_Do(colorUntonemapped, colorTonemapped, v1.xy, t0);
  //o0.xyz = DrawBinary(6, o0.xyz, v1.xy);
  return;
}