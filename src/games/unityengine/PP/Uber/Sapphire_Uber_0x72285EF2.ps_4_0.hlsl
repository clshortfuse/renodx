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
  float4 cb0[23];
}

// Hand of Fate 2

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = asint(cb0[19].x);
  r0.x = 1 / r0.x;
  r0.yz = float2(-0.5,-0.5) + v1.xy;
  r0.w = dot(r0.yz, r0.yz);
  r0.w = log2(r0.w);
  r0.w = cb0[18].y * r0.w;
  r0.w = exp2(r0.w);
  r1.y = 1;
  r2.xyz = float3(0,0,0);
  r3.xyz = float3(0,0,0);
  r1.w = 0;
  while (true) {
    r2.w = cmp((int)r1.w >= asint(cb0[19].x));
    if (r2.w != 0) break;
    r2.w = (int)r1.w;
    r3.w = r2.w * r0.x;
    r4.x = cmp(0.5 >= r3.w);
    r1.x = r4.x ? 1.000000 : 0;
    r1.z = r4.x ? 0 : 1;
    r2.w = r0.x * r2.w + -0.166666672;
    r2.w = saturate(1.50000012 * r2.w);
    r2.w = r2.w * 2 + -1;
    r4.y = 1 + -abs(r2.w);
    r4.xz = float2(1,1) + -r4.yy;
    r4.xyz = r4.xyz * r1.xyz;
    r4.xyz = log2(r4.xyz);
    r4.xyz = float3(0.454545468,0.454545468,0.454545468) * r4.xyz;
    r4.xyz = exp2(r4.xyz);
    r3.xyz = r4.xyz + r3.xyz;
    r1.x = -cb0[18].x * r3.w;
    r1.x = r1.x * r0.w;
    r1.xz = r0.yz * r1.xx + v1.xy;
    r5.xyzw = t0.Sample(s0_s, r1.xz).xyzw;
    r2.xyz = r4.xyz * r5.xyz + r2.xyz;
    r1.w = (int)r1.w + 1;
  }
  r0.xyz = r2.xyz / r3.xyz;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.w = cb0[5].x + cb0[4].x;
  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r2.xyz = cb0[5].xxx * r2.xyz;
  r1.xyz = r1.xyz * cb0[4].xxx + r2.xyz;
  r0.w = cb0[6].x + r0.w;
  r2.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * cb0[6].xxx + r1.xyz;
  r0.w = cb0[7].x + r0.w;
  r2.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * cb0[7].xxx + r1.xyz;
  r0.w = cb0[8].x + r0.w;
  r2.xyzw = t5.Sample(s5_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * cb0[8].xxx + r1.xyz;
  r0.w = cb0[9].x + r0.w;
  r2.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * cb0[9].xxx + r1.xyz;
  r1.xyz = r1.xyz / r0.www;
  r0.xyz = r1.xyz * cb0[3].xxx * injectedData.fxBloom + r0.xyz;
  /*r1.xyz = r0.xyz * float3(2.50999999,2.50999999,2.50999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r1.xyz = r1.xyz * r0.xyz;
  r2.xyz = r0.xyz * float3(2.43000007,2.43000007,2.43000007) + float3(0.589999974,0.589999974,0.589999974);
  r0.xyz = r0.xyz * r2.xyz + float3(0.140000001,0.140000001,0.140000001);
  r0.xyz = saturate(r1.xyz / r0.xyz);*/
  r0.xyz = applyUserTonemapSapphire(r0.xyz);
  r1.xy = v1.xy * cb0[20].xy + cb0[20].zw;
  r1.xyzw = t7.Sample(s7_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  /*r1.x = cmp(0 < r0.w);
  r1.y = cmp(r0.w < 0);
  r1.x = (int)-r1.x + (int)r1.y;
  r1.x = (int)r1.x;*/
  r1.x = sign(r0.w);
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  //r0.xyz = saturate(r0.www * float3(0.0013071897,0.0013071897,0.0013071897) + r0.xyz);
  r1.xyz = applyDither(r0.xyz, r0.w * (1.0 / 765.0), 1);
  r1.w = 0;
  /*r0.w = 1 / cb0[22].z;
  r1.xyz = log2(r0.xyz);
  r0.xyzw = r1.xyzw * r0.wwww;
  o0.xyzw = exp2(r0.xyzw);*/
  r0.xyzw = renodx::math::SignPow(r1.xyzw, 1.0 / cb0[22].z);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}