#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[39];
}
cbuffer cb0 : register(b0){
  float4 cb0[18];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  uint v6 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.w = 1;
  r1.x = t0.Sample(s0_s, v5.zw).x;
  r1.x = cb1[26].y * r1.x + cb1[26].x;
  r1.x = 1 / r1.x;
  r1.xyz = v4.xyz * r1.xxx + cb1[38].xyz;
  r1.w = 1;
  r2.x = dot(r1.xyzw, cb1[4].xyzw);
  r2.y = dot(r1.xyzw, cb1[5].xyzw);
  r2.z = dot(r1.xyzw, cb1[7].xyzw);
  r2.xy = r2.xy / r2.zz;
  r3.x = dot(r1.xyzw, cb0[9].xyzw);
  r3.y = dot(r1.xyzw, cb0[10].xyzw);
  r1.x = dot(r1.xyzw, cb0[12].xyzw);
  r1.xy = r3.xy / r1.xx;
  r1.xy = r2.xy + -r1.xy;
  r1.z = 8 * cb0[17].y;
  r1.zw = cb1[37].zw * r1.zz;
  r1.xy = max(r1.xy, -r1.zw);
  r1.xy = min(r1.xy, r1.zw);
  r1.xy = cb0[17].xx * r1.xy;
  r1.z = saturate(0.0166666675 / cb0[17].w);
  r1.xy = r1.xy * r1.zz;
  r1.z = -r1.y;
  r1.w = t2.Sample(s1_s, v5.xy).x;
  r1.w = saturate(r1.w * r1.w);
  r2.x = round(r1.w);
  r2.y = 4 * r2.x;
  r2.x = r2.x * 4 + 1;
  r3.xyzw = cmp(float4(1,2,3,4) < r2.xxxx);
  r2.xz = r1.xz * -r2.yy + v5.xy;
  r2.y = (int)-r2.y;
  r4.xyz = t1.Sample(s2_s, r2.xz).xyz;
  r2.x = t2.Sample(s1_s, r2.xz).x;
  r2.x = r2.x * r2.x;
  r4.rgb = renodx::math::SignPow(r4.rgb, 2.f);
  r4.xyz = r4.xyz * r2.xxx;
  r5.w = r2.x * r1.w + 1;
  r6.xyzw = t1.Sample(s2_s, v5.xy).xyzw;
  r0.rgb = renodx::math::SignPow(r6.rgb, 2.f);
  r5.xyz = r4.xyz * r1.www + r0.xyz;
  r2.x = cmp((int)r2.y < 0);
  r0.xyzw = r2.xxxx ? r5.xyzw : r0.xyzw;
  r2.z = (int)r2.y + (int)-r2.x;
  r4.xyz = (int3)r2.yyy + int3(1,2,3);
  r4.xyz = cmp((int3)r4.xyz < int3(0,0,0));
  r2.y = (int)r2.z;
  r2.yw = r1.xz * r2.yy + v5.xy;
  r5.xyz = t1.Sample(s2_s, r2.yw).xyz;
  r2.y = t2.Sample(s1_s, r2.yw).x;
  r2.y = r2.y * r2.y;
  r5.rgb = renodx::math::SignPow(r5.rgb, 2.f);
  r5.xyz = r5.xyz * r2.yyy;
  r7.w = r2.y * r1.w + r0.w;
  r7.xyz = r5.xyz * r1.www + r0.xyz;
  r2.x = r2.x ? r4.x : 0;
  r0.xyzw = r2.xxxx ? r7.xyzw : r0.xyzw;
  r2.y = (int)r2.z + (int)-r2.x;
  r2.x = r2.x ? r4.y : 0;
  r2.z = r2.x ? r4.z : 0;
  r2.w = (int)r2.y;
  r2.y = (int)r2.y + (int)-r2.x;
  r2.y = (int)r2.y;
  r4.xy = r1.xz * r2.yy + v5.xy;
  r2.yw = r1.xz * r2.ww + v5.xy;
  r4.zw = v5.xy + r1.xz;
  r5.xyz = t1.Sample(s2_s, r2.yw).xyz;
  r1.z = t2.Sample(s1_s, r2.yw).x;
  r1.z = r1.z * r1.z;
  r5.rgb = renodx::math::SignPow(r5.rgb, 2.f);
  r5.xyz = r5.xyz * r1.zzz;
  r7.w = r1.z * r1.w + r0.w;
  r7.xyz = r5.xyz * r1.www + r0.xyz;
  r0.xyzw = r2.xxxx ? r7.xyzw : r0.xyzw;
  r2.xyw = t1.Sample(s2_s, r4.xy).xyz;
  r1.z = t2.Sample(s1_s, r4.xy).x;
  r1.z = r1.z * r1.z;
  r2.rga = renodx::math::SignPow(r2.rga, 2.f);
  r2.xyw = r2.xyw * r1.zzz;
  r5.w = r1.z * r1.w + r0.w;
  r5.xyz = r2.xyw * r1.www + r0.xyz;
  r0.xyzw = r2.zzzz ? r5.xyzw : r0.xyzw;
  r2.xyz = t1.Sample(s2_s, r4.zw).xyz;
  r1.z = t2.Sample(s1_s, r4.zw).x;
  r1.z = r1.z * r1.z;
  r2.rgb = renodx::math::SignPow(r2.rgb, 2.f);
  r2.xyz = r2.xyz * r1.zzz;
  r4.w = r1.z * r1.w + r0.w;
  r4.xyz = r2.xyz * r1.www + r0.xyz;
  r0.xyzw = r3.xxxx ? r4.xyzw : r0.xyzw;
  r2.xyzw = r1.xyxy * float4(2,-2,3,-3) + v5.xyxy;
  r1.xy = r1.xy * float2(4,-4) + v5.xy;
  r4.xyz = t1.Sample(s2_s, r2.xy).xyz;
  r4.rgb = renodx::math::SignPow(r4.rgb, 2.f);
  r1.z = t2.Sample(s1_s, r2.xy).x;
  r1.z = r1.z * r1.z;
  r4.xyz = r1.zzz * r4.xyz;
  r5.w = r1.z * r1.w + r0.w;
  r5.xyz = r4.xyz * r1.www + r0.xyz;
  r0.xyzw = r3.yyyy ? r5.xyzw : r0.xyzw;
  r4.xyz = t1.Sample(s2_s, r2.zw).xyz;
  r1.z = t2.Sample(s1_s, r2.zw).x;
  r1.z = r1.z * r1.z;
  r2.rgb = renodx::math::SignPow(r4.rgb, 2.f);
  r2.xyz = r2.xyz * r1.zzz;
  r4.w = r1.z * r1.w + r0.w;
  r4.xyz = r2.xyz * r1.www + r0.xyz;
  r0.xyzw = r3.zzzz ? r4.xyzw : r0.xyzw;
  r2.xyz = t1.Sample(s2_s, r1.xy).xyz;
  r1.x = t2.Sample(s1_s, r1.xy).x;
  r1.x = r1.x * r1.x;
  r2.rgb = renodx::math::SignPow(r2.rgb, 2.f);
  r2.xyz = r2.xyz * r1.xxx;
  r4.w = r1.x * r1.w + r0.w;
  r4.xyz = r2.xyz * r1.www + r0.xyz;
  r0.xyzw = r3.wwww ? r4.xyzw : r0.xyzw;
  r6.xyz = r0.xyz;
  r0.xyzw = r6.xyzw / r0.wwww;
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  o0.w = r0.w;
  return;
}