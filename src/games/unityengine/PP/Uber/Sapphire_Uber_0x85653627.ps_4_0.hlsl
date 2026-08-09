#include "../../tonemap.hlsl"

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
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

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = cb0[7].xxx * r0.xyz;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[6].xxx + r0.xyz;
  r1.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[8].xxx + r0.xyz;
  r1.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[9].xxx + r0.xyz;
  r1.xyzw = t5.Sample(s5_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[10].xxx + r0.xyz;
  r1.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[11].xxx + r0.xyz;
  r0.w = cb0[7].x + cb0[6].x;
  r0.w = cb0[8].x + r0.w;
  r0.w = cb0[9].x + r0.w;
  r0.w = cb0[10].x + r0.w;
  r0.w = cb0[11].x + r0.w;
  r0.xyz = r0.xyz / r0.www;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.xyz = r0.xyz * cb0[4].zzz * injectedData.fxBloom + r1.xyz;
  r1.w = saturate(r1.w);
  r2.xyz = applyUserTonemapSapphire(r2.xyz);
  r0.xyz = -r2.xyz + r0.xyz;
  r3.xy = saturate(float2(-0.2,-0.5) + cb0[24].xx);
  r0.w = 8 * r3.x;
  r2.w = r3.y + r3.y;
  r2.w = min(1, r2.w);
  r0.w = min(1, r0.w);
  r0.xyz = r0.www * r0.xyz + r2.xyz;
  r0.w = 8 * cb0[24].x;
  r0.w = exp2(r0.w);
  r2.xyz = r0.xyz * r0.www + -r0.xyz;
  r0.xyz = cb0[24].xxx * r2.xyz + r0.xyz;
  if (injectedData.toneMapType == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  r2.xyz = cb0[23].xyz + -r0.xyz;
  r0.xyz = r2.www * r2.xyz + r0.xyz;
  r2.xy = v1.xy * cb0[22].xy + cb0[22].zw;
  r2.xyzw = t7.Sample(s7_s, r2.xy).xyzw;
  r0.w = r2.w * 2 + -1;
  float sign1 = sign(r0.w);
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = sign1 * r0.w;
  r1.xyz = applyDither(r0.xyz, r0.w * (1.0 / 765.0), 1);
  r1.xyz = PostToneMapScale(r1.xyz);
  o0.xyzw = r1.xyzw;
  return;
}