#include "../../tonemap.hlsl"

Texture2D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s8_s : register(s8);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[23];
}

// Hand of Fate 2

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = cb0[5].xxx * r0.xyz;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[4].xxx + r0.xyz;
  r1.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[6].xxx + r0.xyz;
  r1.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[7].xxx + r0.xyz;
  r1.xyzw = t5.Sample(s5_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[8].xxx + r0.xyz;
  r1.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[9].xxx + r0.xyz;
  r0.w = cb0[5].x + cb0[4].x;
  r0.w = cb0[6].x + r0.w;
  r0.w = cb0[7].x + r0.w;
  r0.w = cb0[8].x + r0.w;
  r0.w = cb0[9].x + r0.w;
  r0.xyz = r0.xyz / r0.www;
  r1.xyz = log2(r0.xyz);
  r1.xyz = cb0[3].zzz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = cb0[3].yyy * r1.xyz;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = r0.xyz * cb0[3].xxx * injectedData.fxBloom + r2.xyz;
  r3.xyzw = t7.Sample(s7_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * r3.xyz + r0.xyz;
  /*r1.xyz = r0.xyz * float3(2.50999999,2.50999999,2.50999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r1.xyz = r1.xyz * r0.xyz;
  r3.xyz = r0.xyz * float3(2.43000007,2.43000007,2.43000007) + float3(0.589999974,0.589999974,0.589999974);
  r0.xyz = r0.xyz * r3.xyz + float3(0.140000001,0.140000001,0.140000001);
  r0.xyz = saturate(r1.xyz / r0.xyz);*/
  r0.xyz = applyUserTonemapSapphire(r0.xyz);
  /*r1.xyz = cb0[17].zzz * r0.zxy;
  r3.xy = float2(0.5,0.5) * cb0[17].xy;
  r3.yz = r1.yz * cb0[17].xy + r3.xy;
  r0.w = floor(r1.x);
  r3.x = r0.w * cb0[17].y + r3.y;
  r0.w = r0.z * cb0[17].z + -r0.w;
  r1.x = cb0[17].y;
  r1.y = 0;
  r1.xy = r3.xz + r1.xy;
  r3.xyzw = t8.Sample(s8_s, r3.xz).xyzw;
  r1.xyzw = t8.Sample(s8_s, r1.xy).xyzw;
  r1.xyz = r1.xyz + -r3.xyz;
  r1.xyz = r0.www * r1.xyz + r3.xyz;*/
  r1.xyz = handleUserLUT(r0.xyz, t8, s8_s, cb0[17].xyz, 2, true);
  r1.xyz = r1.xyz + -r0.xyz;
  r2.xyz = cb0[17].www * r1.xyz + r0.xyz;
  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = log2(r0.x);
  r0.x = cb0[18].w * r0.x;
  r0.x = exp2(r0.x);
  r0.x = saturate(cb0[18].z + r0.x);
  r0.xyzw = r2.xyzw * r0.xxxx;
  if (injectedData.toneMapType == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  r0.w = saturate(r0.w);
  /*r0.xyzw = log2(r0.xyzw);
  r1.x = 1 / cb0[22].z;
  r0.xyzw = r1.xxxx * r0.xyzw;
  o0.xyzw = exp2(r0.xyzw);*/
  r0.xyzw = renodx::math::SignPow(r0.xyzw, 1.0 / cb0[22].z);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}