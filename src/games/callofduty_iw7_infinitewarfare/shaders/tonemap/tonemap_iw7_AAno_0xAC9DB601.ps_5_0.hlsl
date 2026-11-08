// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 17 18:40:48 2025
#include "../common.hlsl"
#include "./drawbinary.hlsl"

Texture3D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb13 : register(b13)
{
  float4 cb13[3];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[7];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0,
  out float o1 : SV_TARGET1)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 colorUntonemapped, colorTonemapped;

  r0.xy = cb2[1].yx + v1.yx;
  r1.xyz = t1.Sample(s1_s, r0.yx).xyz;
  r1.xyz = cb2[6].xxx * r1.xyz;

  r2.xyz = t0.Sample(s0_s, r0.yx).xyz;

  r0.xy = cb2[0].ww * r0.xy;
  r0.xy = frac(r0.xy);
  r0.xy = r0.xy * float2(1024,1024) + float2(-512,-512);
  r1.xyz = cb2[6].yyy * r2.xyz + r1.xyz;

  //colorUntonemapped
  colorUntonemapped = r1.xyz * Tonemap_CalculatePreExposureMultiplier(cb13[0].xyz, cb13[1].xyz, cb13[2].xyz);

  r2.xyz = cmp(r1.xyz < cb13[0].xxx);
  r3.xyzw = r2.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
  r0.zw = r3.xy * r1.xx + r3.zw;
  r3.x = saturate(r0.z / r0.w);
  r4.xyzw = r2.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
  r2.xyzw = r2.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
  r0.zw = r2.xy * r1.zz + r2.zw;
  r1.xy = r4.xy * r1.yy + r4.zw;
  r3.y = saturate(r1.x / r1.y);
  r3.z = saturate(r0.z / r0.w);

  r1.x = saturate(dot(r3.xyz, cb2[3].xyz));
  r1.y = saturate(dot(r3.xyz, cb2[4].xyz));
  r1.z = saturate(dot(r3.xyz, cb2[5].xyz));

  //to sRGB
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  // r1.xyz = log2(r1.xyz);
  // r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r1.xyz = max(float3(0,0,0), r1.xyz);

  r1.xyz = r1.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r1.xyz = t2.SampleLevel(s2_s, r1.xyz, 0).xyz;

  // //tonemap
  // colorTonemapped = r1.xyz;
  // r1.xyz = Tonemap_Do(colorUntonemapped, colorTonemapped, v1.xy, t0);

  //stuff after aa (if was present)
  r0.z = max(r1.x, r1.y);
  r0.z = min(r0.z, r1.z);
  r0.w = min(r1.x, r1.y);
  r0.z = max(r0.w, r0.z);
  r0.w = -0.100000001 + r0.z;
  r0.w = saturate(-10 * r0.w);
  r1.w = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.z = r1.w * r0.w + r0.z;
  r0.z = r0.z * r0.z;
  r0.z = min(1, r0.z);
  r2.xy = float2(0.554549694,0.308517009) * r0.yx;
  r2.xy = frac(r2.xy);
  r0.xy = r0.yx * r2.xy + r0.xy;
  r0.x = r0.x * r0.y;
  r0.x = frac(r0.x);
  r0.x = r0.x * 2 + -1;
  r0.x = r0.z * -r0.x + r0.x;
  r0.x = cb2[2].y * r0.x;
  o0.xyz = r1.xyz * r0.xxx + r1.xyz;

  r0.x = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  o0.w = r0.x;
  o1.x = r0.x;

  o0 = Tonemap_DrawError(o0);

  // //tonemap
  // colorTonemapped = o0.xyz;
  // o0.xyz = Tonemap_Do(colorUntonemapped, colorTonemapped, v1.xy, t0);
  //o0.xyz = DrawBinary(-1, o0.xyz, v1.xy);
  return;
}