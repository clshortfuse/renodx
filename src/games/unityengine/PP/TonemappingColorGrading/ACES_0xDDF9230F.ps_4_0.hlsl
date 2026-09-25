#include "../../common.hlsli"

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
cbuffer cb2 : register(b2){
  float4 cb2[22];
}
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[12];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r1.xyz = Bt709AcesTonemap(r0.xyz, cb0[4].x);
  r3.xyz = handleUserLUT(r1.xyz, t1, s2_s, cb0[8].xyz, 1, true);
  r2.xyz = r3.xyz + -r1.xyz;
  r1.xyz = cb0[8].www * r2.xyz + r1.xyz;
  r1.w = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.xyz = -r1.www * cb0[11].yyy + r1.xyz;
  r1.w = cb0[11].y * r1.w;
  r2.xy = cb0[2].xy + cb0[2].zw;
  r2.zw = -cb0[2].xy + cb0[2].zw;
  r2.xy = r2.xy + -r2.zw;
  r2.xy = v1.xy * r2.xy + r2.zw;
  r3.xyzw = t2.Sample(s0_s, v1.xy).xyzw;
  r2.z = cb1[7].x * r3.x + cb1[7].y;
  r2.z = 1 / r2.z;
  r2.xy = r2.xy * r2.zz;
  r3.xyz = cb2[19].xyz * r2.yyy;
  r2.xyw = cb2[18].xyz * r2.xxx + r3.xyz;
  r3.x = cb1[5].z * r2.z;
  r2.xyw = cb2[20].xyz * r3.xxx + r2.xyw;
  r2.xyw = cb2[21].xyz + r2.xyw;
  r3.xy = r2.xw * cb0[10].xy + cb0[10].zw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.y = r2.y >= cb0[11].x ? 1 : r4.x;
  r2.y = r2.z >= 1 ? 0 : r2.y;
  r0.xyz = r2.yyy * r1.xyz + r1.www;
  r0.xyzw = r2.yyyy * r0.xyzw;
  r1.xy = float2(1,1) + -r3.xy;
  r1.xy = min(r3.xy, r1.xy);
  r1.xy = r1.xy / cb0[10].xy;
  r1.xy = float2(0.1,0.1) * r1.xy;
  r1.x = saturate(min(r1.x, r1.y));
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.xy = float2(0.333333343,0.25) * cb1[0].xx;
  r1.xz = cb1[2].yx * float2(0.0625,0.0625) + -r1.xx;
  r1.yw = cb1[2].yx * float2(0.0625,0.0625) + r1.yy;
  r1.yw = r2.wx * float2(0.0625,0.0625) + r1.yw;
  r1.xz = r2.xw * float2(0.0625,0.0625) + r1.xz;
  r3.xyzw = t4.Sample(s4_s, r1.xz).xyzw;
  r1.x = 5 * r3.x;
  r3.xyzw = t4.Sample(s4_s, r1.yw).xyzw;
  r1.x = r3.x * r1.x;
  r1.y = 3.75 * r1.x;
  r1.x = -r1.x * 3.75 + 1;
  r1.x = r2.y * r1.x + r1.y;
  o0.xyzw = r1.xxxx * r0.xyzw;
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    o0.xyz = GradeAndDisplayMap(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}