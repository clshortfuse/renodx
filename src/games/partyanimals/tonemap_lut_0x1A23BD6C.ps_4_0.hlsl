#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Thu Oct 16 03:12:30 2025
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

cbuffer cb1 : register(b1)
{
  float4 cb1[8];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[21];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xw = float2(0,0);
  r1.yz = cb0[2].yx;
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
  r3.x = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r3.y = max(r2.w, r2.x);
  r3.y = max(r3.y, r2.y);
  r3.y = max(r3.y, r2.z);
  r2.x = min(r2.w, r2.x);
  r2.x = min(r2.x, r2.y);
  r2.x = min(r2.x, r2.z);
  r2.x = r3.y + -r2.x;
  r2.x = 9.99999975e-06 + r2.x;
  r4.xyzw = v1.xyxy + -r1.xyzw;
  r5.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  r4.xyzw = t0.Sample(s0_s, r4.zw).xyzw;
  r1.xyzw = v1.xyxy + r1.zwxy;
  r6.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.x = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r1.y = dot(r6.xyz, float3(0.298999995,0.587000012,0.114));
  r1.z = dot(r4.xyz, float3(0.298999995,0.587000012,0.114));
  r1.w = dot(r5.xyz, float3(0.298999995,0.587000012,0.114));
  r2.z = max(r1.x, r1.w);
  r2.z = max(r2.z, r1.z);
  r2.z = max(r2.z, r1.y);
  r1.x = min(r1.x, r1.w);
  r1.x = min(r1.x, r1.z);
  r1.x = min(r1.x, r1.y);
  r1.x = -9.99999997e-07 + r1.x;
  r1.y = r3.x * 2 + -r1.x;
  r1.y = r1.y + -r2.z;
  r1.x = r2.z + -r1.x;
  r1.x = saturate(cb0[7].w / r1.x);
  r1.z = -cb0[8].z + r2.y;
  r1.z = cb0[8].w / abs(r1.z);
  r1.w = cmp(1 < r1.z);
  r1.w = r1.w ? 1.000000 : 0;
  r1.z = saturate(cb0[15].z * r1.z);
  r1.z = max(r1.w, r1.z);
  r1.w = saturate(cb0[7].y / r2.x);
  r1.x = r1.y * r1.x;
  r1.x = r1.x * r1.w;
  r1.x = cb0[7].x * r1.x;
  r1.x = max(-cb0[7].z, r1.x);
  r1.x = min(cb0[7].z, r1.x);
  r1.x = r1.x * r1.z + 1;
  r1.yzw = r1.xxx * r0.xyz;
  r3.xyzw = t2.Sample(s4_s, v1.xy).wxyz;
  r2.x = cmp(cb0[20].z < cb0[2].z);
  if (r2.x != 0) {
    r4.xyzw = t1.SampleLevel(s1_s, v2.xy, v2.w).xyzw;
    r2.x = cb1[7].z * r4.x + cb1[7].w;
    r2.x = 1 / r2.x;
    r2.z = -cb0[16].x + r2.x;
    r2.w = cmp(r2.x < cb0[16].x);
    r2.w = r2.w ? 1.000000 : 0;
    r2.z = -cb0[17].x * r2.w + abs(r2.z);
    r2.z = cb0[16].y * r2.z;
    r2.z = 0.5 * r2.z;
    r2.x = r2.z / r2.x;
    r2.z = cb0[20].z / cb0[2].z;
    r2.w = r3.x + -r2.x;
    r3.x = r2.z * r2.w + r2.x;
  }
  r3.x = saturate(r3.x);
  r0.xyz = -r0.xyz * r1.xxx + r3.yzw;
  r0.xyz = r3.xxx * r0.xyz + r1.yzw;
  r1.xyzw = t3.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[13].xxx + r0.xyz;
  r0.xyz = cb0[6].xxx * r0.xyz;

  float3 untonemapped = r0.xyz;
  float3 hdr_color = CustomTonemap(untonemapped);
  float3 sdr_color = CustomGradingBegin(hdr_color);
  r0.xyz = sdr_color;

  // r1.xyz = r0.xyz * float3(2.50999999,2.50999999,2.50999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  // r1.xyz = r1.xyz * r0.xyz;
  // r2.xzw = r0.xyz * float3(2.43000007,2.43000007,2.43000007) + float3(0.589999974,0.589999974,0.589999974);
  // r0.xyz = r0.xyz * r2.xzw + float3(0.140000001,0.140000001,0.140000001);
  // r0.xyz = r1.xyz / r0.xyz;

  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.x = -1 + cb0[4].w;
  r1.yzw = min(float3(1,1,1), r0.xyz);
  r2.x = r1.w * r1.x;
  r1.yz = r1.yz * r1.xx + float2(0.5,0.5);
  r3.zw = cb0[4].xy * r1.yz;
  r1.y = floor(r2.x);
  r3.y = r1.y * cb0[4].y + r3.z;
  r3.x = cb0[4].y + r3.y;
  r4.xyzw = t4.Sample(s3_s, r3.yw).xyzw;
  r3.xyzw = t4.Sample(s3_s, r3.xw).xyzw;
  r1.x = r1.w * r1.x + -r1.y;
  r1.yzw = r3.xyz + -r4.xyz;
  r1.xyz = r1.xxx * r1.yzw + r4.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[9].www * r1.xyz + r0.xyz;
  r1.xyz = r0.xyz * float3(0.305306017,0.305306017,0.305306017) + float3(0.682171106,0.682171106,0.682171106);
  r1.xyz = r0.xyz * r1.xyz + float3(0.0125228781,0.0125228781,0.0125228781);
  r2.xzw = r1.xyz * r0.xyz;

  r1.w = max(r2.z, r2.w);
  r1.w = max(r2.x, r1.w);
  r3.x = min(r2.z, r2.w);
  r3.x = min(r3.x, r2.x);
  r1.w = saturate(-r3.x + r1.w);
  r1.w = 1 + -r1.w;
  r1.w = cb0[6].z * r1.w;
  r3.x = dot(r2.xzw, float3(0.298999995,0.587000012,0.114));
  r0.xyz = r0.xyz * r1.xyz + -r3.xxx;
  r0.xyz = r1.www * r0.xyz + float3(1,1,1);
  r0.xyz = r2.xzw * r0.xyz;
  r1.xyz = r0.xyz * cb0[10].xyz + -r0.xyz;
  r0.xyz = cb0[10].www * r1.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[6].yyy + float3(0.5,0.5,0.5);
  r1.xy = cb1[6].xy * v1.xy;
  r1.x = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r1.xxx;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.w = cmp(r2.y >= cb0[8].y);
  r1.w = r1.w ? 1.000000 : 0;
  r1.w = cb0[8].x * r1.w;
  r1.xyz = r1.www * r1.xyz + float3(1,1,1);
  o0.xyz = r1.xyz * r0.xyz;
  o0.w = r0.w;

  float3 graded_color = o0.xyz;
  float3 upgraded_color = CustomGradingEnd(hdr_color, sdr_color, graded_color);
  o0.xyz = upgraded_color;

  o0.rgb = CustomIntermediatePass(o0.rgb);
  return;
}