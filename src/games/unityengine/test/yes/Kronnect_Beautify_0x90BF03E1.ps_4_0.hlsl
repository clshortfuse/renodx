#include "../../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[27];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if (injectedData.toneMapType == 0.f) {
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(float3(8, 8, 8), r0.xyz);
  }
  r1.xw = float2(0,0);
  r1.yz = cb0[3].yx;
  r2.xyz = v2.xyw + -r1.xyx;
  r2.xyzw = t1.SampleLevel(s1_s, r2.xy, r2.z).xyzw;
  r2.x = cb1[7].x * r2.x + cb1[7].y;
  r2.x = 1 / r2.x;
  r2.yzw = v2.xyw + -r1.zww;
  r3.xyzw = t1.SampleLevel(s1_s, r2.yz, r2.w).xyzw;
  r2.y = cb1[7].x * r3.x + cb1[7].y;
  r2.y = 1 / r2.y;
  r3.xyz = v2.xyw + r1.zww;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, r3.z).xyzw;
  r2.z = cb1[7].x * r3.x + cb1[7].y;
  r2.z = 1 / r2.z;
  r3.xyz = v2.xyw + r1.xyx;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, r3.z).xyzw;
  r2.w = cb1[7].x * r3.x + cb1[7].y;
  r2.w = 1 / r2.w;
  r3.x = max(r2.w, r2.x);
  r3.x = max(r3.x, r2.y);
  r3.x = max(r3.x, r2.z);
  r2.x = min(r2.w, r2.x);
  r2.x = min(r2.x, r2.y);
  r2.x = min(r2.x, r2.z);
  r2.x = r3.x + -r2.x;
  r3.xyzw = v1.xyxy + -r1.xyzw;
  r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r1.xyzw = v1.xyxy + r1.zwxy;
  r5.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.x = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r1.y = dot(r5.xyz, float3(0.298999995,0.587000012,0.114));
  r1.z = dot(r3.xyz, float3(0.298999995,0.587000012,0.114));
  r1.w = dot(r4.xyz, float3(0.298999995,0.587000012,0.114));
  r2.z = max(r1.x, r1.w);
  r2.z = max(r2.z, r1.z);
  r2.z = max(r2.z, r1.y);
  r1.x = min(r1.x, r1.w);
  r1.x = min(r1.x, r1.z);
  r1.x = min(r1.x, r1.y);
  r1.x = -9.99999997e-007 + r1.x;
  r1.y = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r1.z = r1.y * 2 + -r1.x;
  r1.z = r1.z + -r2.z;
  r1.x = r2.z + -r1.x;
  r1.x = saturate(cb0[10].w / r1.x);
  r1.w = -cb0[11].z + r2.y;
  r1.w = cb0[11].w / abs(r1.w);
  r2.z = cmp(1 < r1.w);
  r2.z = r2.z ? 1.000000 : 0;
  r1.w = saturate(cb0[19].z * r1.w);
  r1.w = max(r2.z, r1.w);
  r2.x = 9.99999975e-006 + r2.x;
  r2.x = saturate(cb0[10].y / r2.x);
  r1.x = r1.z * r1.x;
  r1.x = r1.x * r2.x;
  r1.x = cb0[10].x * r1.x;
  r1.x = max(-cb0[10].z, r1.x);
  r1.x = min(cb0[10].z, r1.x);
  r1.x = r1.x * r1.w + 1;
  r2.xzw = r1.xxx * r0.xyz;
  r3.xyzw = t2.Sample(s3_s, v1.xy).wxyz;
  r1.z = cmp(cb0[26].z < cb0[3].z);
  if (r1.z != 0) {
    r4.xyzw = t1.SampleLevel(s1_s, v2.xy, v2.w).xyzw;
    r1.z = cb1[7].z * r4.x + cb1[7].w;
    r1.z = 1 / r1.z;
    r1.w = -cb0[22].x + r1.z;
    r4.x = cmp(r1.z < cb0[22].x);
    r4.x = r4.x ? 1.000000 : 0;
    r1.w = -cb0[23].x * r4.x + abs(r1.w);
    r1.w = cb0[22].y * r1.w;
    r1.w = 0.5 * r1.w;
    r1.z = r1.w / r1.z;
    r1.w = cb0[26].z / cb0[3].z;
    r4.x = r3.x + -r1.z;
    r3.x = r1.w * r4.x + r1.z;
  }
  r3.x = saturate(r3.x);
  r0.xyz = -r0.xyz * r1.xxx + r3.yzw;
  r0.xyz = r3.xxx * r0.xyz + r2.xzw;
  r3.xyzw = t3.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r3.xyz * cb0[17].xxx * injectedData.fxBloom + r0.xyz;
  r1.x = max(r0.y, r0.z);
  r1.x = max(r1.x, r0.x);
  r1.z = min(r0.y, r0.z);
  r1.z = min(r1.z, r0.x);
  r1.x = saturate(r1.x + -r1.z);
  r1.x = 1 + -r1.x;
  r1.x = cb0[8].z * r1.x;
  r1.z = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r2.xzw = -r1.zzz + r0.xyz;
  r1.xzw = r1.xxx * r2.xzw + float3(1,1,1);
  r0.xyz = r1.xzw * r0.xyz;
  r1.xzw = r0.xyz * cb0[13].xyz + -r0.xyz;
  r0.xyz = cb0[13].www * r1.xzw + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[8].yyy + float3(0.5,0.5,0.5);
  r0.xyz = cb0[8].xxx * r0.xyz;
  r3.xy = -cb0[19].xy + w1.xy;
  r3.z = cb0[21].x * r3.y;
  r1.x = dot(r3.xz, r3.xz);
  r1.x = saturate(cb0[20].w * r1.x + cb0[25].z);
  r1.yzw = r1.yyy * cb0[20].xyz + -r0.xyz;
  r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  r1.xy = cb1[6].xy * v1.xy;
  r1.x = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r1.xxx;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.w = cmp(r2.y >= cb0[11].y);
  r1.w = r1.w ? 1.000000 : 0;
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = cb0[11].xxx * r1.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}