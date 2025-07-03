#include "./lighting.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  2 02:44:32 2025
TextureCube<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[10];
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
    float4 v8: TEXCOORD7,
    out float3 o0: SV_TARGET0,
    out float3 o1: SV_TARGET1) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7;
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
  r2.x = dot(r1.xyzw, v3.xyzw);
  r2.y = dot(r1.xyzw, v4.xyzw);
  r2.z = dot(r1.xyzw, v5.xyzw);
  r2.xyz = -r2.xyz;
  r0.z = dot(r2.xyz, r2.xyz);
  r0.w = dot(r1.xyzw, v6.xyzw);
  r2.w = dot(r1.xyzw, v7.xyzw);
  r1.w = dot(r1.xyzw, v8.xyzw);
  r0.w = max(r0.z, abs(r0.w));
  r1.w = max(abs(r2.w), abs(r1.w));
  r0.w = max(r1.w, r0.w);
  r0.w = cmp(r0.w < 1);
  if (r0.w != 0) {
    r0.z = 1 + -r0.z;
    r0.z = max(0, r0.z);
    r0.z = r0.z * r0.z;
    r2.xyz = t3.SampleLevel(s0_s, r2.xyz, 0).xyz;
    r3.xyzw = t0.SampleLevel(s1_s, r0.xy, 0).xyzw;
    r3.xyzw = r3.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
    r0.w = dot(r3.xyz, r3.xyz);
    r0.w = rsqrt(r0.w);
    r3.xyz = r3.xyz * r0.www;
    r4.xyz = v1.xyz + -r1.xyz;
    r0.w = dot(r4.xyz, r4.xyz);
    r0.w = rsqrt(r0.w);
    r5.xyz = r4.xyz * r0.www;
    r6.w = dot(r5.xyz, r3.xyz);
    r1.w = saturate(r6.w);
    r2.w = cmp(r3.w < 0);
    r1.w = r2.w ? r6.w : r1.w;
    r2.xyz = v2.xyz * r2.xyz;
    r2.xyz = r2.xyz * r0.zzz;
    r7.xyzw = t1.SampleLevel(s2_s, r0.xy, 0).xyzw;
    r0.x = r7.w * r7.w;
    r0.y = dot(-r1.xyz, -r1.xyz);
    r0.y = rsqrt(r0.y);
    r1.xyz = -r1.xyz * r0.yyy;
    r6.z = saturate(dot(r3.xyz, r1.xyz));
    r0.yzw = r4.xyz * r0.www + r1.xyz;
    r1.x = dot(r0.yzw, r0.yzw);
    r1.x = rsqrt(r1.x);
    r0.yzw = r1.xxx * r0.yzw;
    r6.x = dot(r3.xyz, r0.yzw);
    r6.y = dot(r5.xyz, r0.yzw);
    r4.xyzw = max(float4(0.00999999978, 0.00999999978, 0.00999999978, 0.00999999978), r6.xyzw);
    r0.y = -8.65616989 * r4.y;
    r0.y = exp2(r0.y);
    r1.xyz = float3(1, 1, 1) + -r7.xyz;
    r0.yzw = saturate(r1.xyz * r0.yyy + r7.xyz);
    r1.x = cmp(-1 >= r3.w);
    r0.yzw = r1.xxx ? float3(0, 0, 0) : r0.yzw;
    r1.y = r0.x * 0.997500002 + 0.00249999994;
    r1.z = r1.y * r1.y;
    r2.w = r4.x * r4.x;
    r3.x = r1.y * r1.y + -1;
    r2.w = r2.w * r3.x + 1;
    r2.w = r2.w * r2.w;
    r2.w = 4 * r2.w;
    r3.xy = r1.yy * float2(0.797884583, -0.797884583) + float2(0, 1);
    r3.xy = r4.zw * r3.yy + r3.xx;
    r1.y = r3.x * r3.y;
    r1.y = r2.w * r1.y;
    r1.y = r1.z / r1.y;
    r3.xyz = r1.yyy * r0.yzw;
    r1.y = cmp(0 < r1.w);
    r0.yzw = r1.yyy ? r0.yzw : 0;
    r3.xyz = ApplyCustomClampSpecular(r3.xyz * r1.www);
    o0.xyz = r3.xyz * r2.xyz;
    r1.y = saturate(r1.w * 0.5 + 0.5);
    r1.y = r1.y * r1.y;
    r1.z = sqrt(abs(r1.w));
    r1.z = r1.z + -abs(r1.w);
    r0.x = r0.x * r1.z + abs(r1.w);
    r0.x = r1.x ? r1.y : r0.x;
    r0.xyz = -r0.yzw * r0.xxx + r0.xxx;
    o1.xyz = r0.xyz * r2.xyz;
  } else {
    o0.xyz = float3(0, 0, 0);
    o1.xyz = float3(0, 0, 0);
  }
  return;
}
