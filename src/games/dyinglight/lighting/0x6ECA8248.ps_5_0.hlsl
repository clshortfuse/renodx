#include "./lighting.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  2 02:44:52 2025
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerComparisonState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[10];
}

cbuffer cb0 : register(b0) {
  float4 cb0[2];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float4 v3: TEXCOORD2,
    float4 v4: TEXCOORD3,
    float4 v5: TEXCOORD4,
    float4 v6: TEXCOORD5,
    float4 v7: TEXCOORD6,
    out float3 o0: SV_TARGET0,
    out float3 o1: SV_TARGET1) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * cb2[7].xy + cb2[7].zw;
  r0.z = t2.SampleLevel(s3_s, r0.xy, 0).x;
  r0.zw = r0.zz * cb2[8].xy + cb2[8].zw;
  r0.z = r0.z / -r0.w;
  r1.xy = v0.xy * cb2[9].xy + cb2[9].zw;
  r1.xy = r1.xy * abs(r0.zz);
  r1.z = -abs(r0.z);
  r1.w = 1;
  r2.x = dot(r1.xyzw, v4.xyzw);
  r2.y = dot(r1.xyzw, v5.xyzw);
  r3.x = dot(r1.xyzw, v7.xyzw);
  r3.y = 0.5;
  r0.z = t3.SampleLevel(s0_s, r3.xy, 0).w;
  r0.z = r0.z * r0.z;
  r0.z = r0.z * r0.z;
  r3.yz = r2.xy / r3.xx;
  r3.yz = r3.yz * float2(0.5, 0.5) + float2(0.5, 0.5);
  r3.yzw = t3.SampleLevel(s0_s, r3.yz, 0).xyz;
  r4.xyzw = t0.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r4.xyzw = r4.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r0.w = dot(r4.xyz, r4.xyz);
  r0.w = rsqrt(r0.w);
  r4.xyz = r4.xyz * r0.www;
  r5.xyz = v2.xyz + -r1.xyz;
  r0.w = dot(r5.xyz, r5.xyz);
  r0.w = rsqrt(r0.w);
  r6.xyz = r5.xyz * r0.www;
  r7.w = dot(r6.xyz, r4.xyz);
  r2.w = saturate(r7.w);
  r5.w = cmp(r4.w < 0);
  r2.w = r5.w ? r7.w : r2.w;
  r5.w = abs(r2.w) * r0.z;
  r5.w = min(1, r5.w);
  r5.w = saturate(dot(r3.yzw, r5.www));
  r5.w = cmp(0 < r5.w);
  if (r5.w != 0) {
    r2.z = dot(r1.xyzw, v6.xyzw);
    r3.yzw = v3.xyz * r3.yzw;
    r3.yzw = r3.yzw * r0.zzz;
    r2.xyz = r2.xyz / r3.xxx;
    r2.xy = r2.xy * v1.xy + v1.zw;
    r0.z = cmp(r2.w < 0);
    r8.xyz = r0.zzz ? -r4.xyz : r4.xyz;
    r9.x = dot(r8.xyz, v4.xyz);
    r9.y = dot(r8.xyz, v5.xyz);
    r9.z = dot(r8.xyz, v6.xyz);
    r0.z = dot(r9.xyz, r9.xyz);
    r0.z = rsqrt(r0.z);
    r8.xyz = r9.xyz * r0.zzz;
    r0.z = dot(cb0[0].xy, cb0[0].xy);
    r9.x = sqrt(r0.z);
    r0.z = 262140 * abs(r3.x);
    r9.z = 2.82842708 / r0.z;
    r9.y = -r9.x;
    r2.xyz = r8.xyz * r9.xyz + r2.xyz;
    r8.xyzw = cb0[0].xyxy * float4(-0.5, -0.5, 0.5, -0.5) + r2.xyxy;
    r0.z = cb0[1].x * r2.z + cb0[1].y;
    r1.w = t4.SampleCmpLevelZero(s4_s, r8.xy, r0.z).x;
    r1.w = cb0[1].x * r1.w + cb0[1].y;
    r2.z = t4.SampleCmpLevelZero(s4_s, r8.zw, r0.z).x;
    r2.z = cb0[1].x * r2.z + cb0[1].y;
    r2.z = 0.25 * r2.z;
    r1.w = r1.w * 0.25 + r2.z;
    r8.xyzw = cb0[0].xyxy * float4(0.5, 0.5, -0.5, 0.5) + r2.xyxy;
    r2.x = t4.SampleCmpLevelZero(s4_s, r8.xy, r0.z).x;
    r2.x = cb0[1].x * r2.x + cb0[1].y;
    r1.w = r2.x * 0.25 + r1.w;
    r0.z = t4.SampleCmpLevelZero(s4_s, r8.zw, r0.z).x;
    r0.z = cb0[1].x * r0.z + cb0[1].y;
    r0.z = saturate(r0.z * 0.25 + r1.w);
    r1.w = r0.z * -2 + 3;
    r0.z = r0.z * r0.z;
    r0.z = r1.w * r0.z;
    r2.xyz = r3.yzw * r0.zzz;
    r3.xyzw = t1.SampleLevel(s2_s, r0.xy, 0).xyzw;
    r0.x = r3.w * r3.w;
    r0.y = dot(-r1.xyz, -r1.xyz);
    r0.y = rsqrt(r0.y);
    r1.xyz = -r1.xyz * r0.yyy;
    r7.z = saturate(dot(r4.xyz, r1.xyz));
    r0.yzw = r5.xyz * r0.www + r1.xyz;
    r1.x = dot(r0.yzw, r0.yzw);
    r1.x = rsqrt(r1.x);
    r0.yzw = r1.xxx * r0.yzw;
    r7.x = dot(r4.xyz, r0.yzw);
    r7.y = dot(r6.xyz, r0.yzw);
    r1.xyzw = max(float4(0.00999999978, 0.00999999978, 0.00999999978, 0.00999999978), r7.xyzw);
    r0.y = -8.65616989 * r1.y;
    r0.y = exp2(r0.y);
    r4.xyz = float3(1, 1, 1) + -r3.xyz;
    r0.yzw = saturate(r4.xyz * r0.yyy + r3.xyz);
    r1.y = cmp(-1 >= r4.w);
    r0.yzw = r1.yyy ? float3(0, 0, 0) : r0.yzw;
    r3.x = r0.x * 0.997500002 + 0.00249999994;
    r3.y = r3.x * r3.x;
    r1.x = r1.x * r1.x;
    r3.z = r3.x * r3.x + -1;
    r1.x = r1.x * r3.z + 1;
    r1.x = r1.x * r1.x;
    r1.x = 4 * r1.x;
    r3.xz = r3.xx * float2(0.797884583, -0.797884583) + float2(0, 1);
    r1.zw = r1.zw * r3.zz + r3.xx;
    r1.z = r1.z * r1.w;
    r1.x = r1.x * r1.z;
    r1.x = r3.y / r1.x;
    r1.xzw = r1.xxx * r0.yzw;
    r3.x = cmp(0 < r2.w);
    r0.yzw = r3.xxx ? r0.yzw : 0;
    r1.xzw = ApplyCustomClampSpecular(r1.xzw * r2.www);
    o0.xyz = r1.xzw * r2.xyz;
    r1.x = saturate(r2.w * 0.5 + 0.5);
    r1.x = r1.x * r1.x;
    r1.z = sqrt(abs(r2.w));
    r1.z = r1.z + -abs(r2.w);
    r0.x = r0.x * r1.z + abs(r2.w);
    r0.x = r1.y ? r1.x : r0.x;
    r0.xyz = -r0.yzw * r0.xxx + r0.xxx;
    o1.xyz = r0.xyz * r2.xyz;
  } else {
    o0.xyz = float3(0, 0, 0);
    o1.xyz = float3(0, 0, 0);
  }
  return;
}
