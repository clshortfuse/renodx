#include "../../tonemap.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[26];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = log2(r0.x);
  r0.x = 2.5 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = -0.1 + r0.x;
  r0.x = max(0, r0.x);
  r0.y = 0.5 + r0.x;
  r0.y = min(1, r0.y);
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xyz = cb0[7].xxx * r1.xyz;
  r2.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * cb0[6].xxx + r1.xyz;
  r2.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * cb0[8].xxx + r1.xyz;
  r0.z = cb0[7].x + cb0[6].x;
  r0.z = cb0[8].x + r0.z;
  r1.xyz = r1.xyz / r0.zzz;
  r1.xyz = float3(0.75,0.75,0.75) * r1.xyz;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = r1.xyz * cb0[4].zzz * injectedData.fxBloom + r2.xyz;
  r2.w = saturate(r2.w);
  r1.xyz = applyUserTonemapSapphire(r1.xyz);
  r3.xyz = float3(-1,-0,-0) + r1.xyz;
  r0.yzw = r0.yyy * r3.xyz + float3(1,0,0);
  r0.xyz = r0.yzw * r0.xxx + -r1.xyz;
  r0.xyz = cb0[24].zzz * r0.xyz + r1.xyz;
  r1.xy = v1.xy * cb0[22].xy + cb0[22].zw;
  r1.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  float sign1 = sign(r0.w);
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = sign1 * r0.w;
  r2.xyz = applyDither(r0.xyz, r0.w * (1.0 / 765.0), 1);
  r2.xyz = PostToneMapScale(r2.xyz);
  o0.xyzw = r2.xyzw;
  return;
}