#include "./lighting.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  2 02:45:59 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[9];
}

cbuffer cb0 : register(b0) {
  float4 cb0[2];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float2 v2: TEXCOORD1,
    out float3 o0: SV_TARGET0,
    out float3 o1: SV_TARGET1) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v2.xy, 0).xyzw;
  r0.xyzw = r0.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r1.x = dot(r0.xyz, r0.xyz);
  r1.x = rsqrt(r1.x);
  r0.xyz = r1.xxx * r0.xyz;
  r1.w = dot(cb0[1].xyz, r0.xyz);
  r2.x = saturate(r1.w);
  r2.y = cmp(r0.w < 0);
  r2.x = r2.y ? r1.w : r2.x;
  r2.y = cmp(0 < abs(r2.x));
  if (r2.y != 0) {
    r2.y = t2.SampleLevel(s2_s, v2.xy, 0).x;
    r2.yz = r2.yy * cb2[8].xy + cb2[8].zw;
    r2.y = r2.y / -r2.z;
    r2.yzw = v1.xyz * abs(r2.yyy);
    r3.x = dot(-r2.yzw, -r2.yzw);
    r3.x = rsqrt(r3.x);
    r3.yzw = r3.xxx * -r2.yzw;
    r1.z = saturate(dot(r0.xyz, r3.yzw));
    r4.xyzw = t1.SampleLevel(s1_s, v2.xy, 0).xyzw;
    r3.y = r4.w * r4.w;
    r2.yzw = -r2.yzw * r3.xxx + cb0[1].xyz;
    r3.x = dot(r2.yzw, r2.yzw);
    r3.x = rsqrt(r3.x);
    r2.yzw = r3.xxx * r2.yzw;
    r1.x = dot(r0.xyz, r2.yzw);
    r1.y = dot(cb0[1].xyz, r2.yzw);
    r1.xyzw = max(float4(0.00999999978, 0.00999999978, 0.00999999978, 0.00999999978), r1.xyzw);
    r0.x = -8.65616989 * r1.y;
    r0.x = exp2(r0.x);
    r2.yzw = float3(1, 1, 1) + -r4.xyz;
    r0.xyz = saturate(r2.yzw * r0.xxx + r4.xyz);
    r0.w = cmp(-1 >= r0.w);
    r0.xyz = r0.www ? float3(0, 0, 0) : r0.xyz;
    r1.y = r3.y * 0.997500002 + 0.00249999994;
    r2.y = r1.y * r1.y;
    r1.x = r1.x * r1.x;
    r2.z = r1.y * r1.y + -1;
    r1.x = r1.x * r2.z + 1;
    r1.x = r1.x * r1.x;
    r1.x = 4 * r1.x;
    r2.zw = r1.yy * float2(0.797884583, -0.797884583) + float2(0, 1);
    r1.yz = r1.zw * r2.ww + r2.zz;
    r1.y = r1.y * r1.z;
    r1.x = r1.x * r1.y;
    r1.x = r2.y / r1.x;
    r1.xyz = r1.xxx * r0.xyz;
    r1.w = cmp(0 < r2.x);
    r0.xyz = r1.www ? r0.xyz : 0;
    r1.xyz = ApplyCustomClampSpecular(r1.xyz * r2.xxx);
    r1.w = saturate(r2.x * 0.5 + 0.5);
    r1.w = r1.w * r1.w;
    r2.y = sqrt(abs(r2.x));
    r2.y = r2.y + -abs(r2.x);
    r2.x = r3.y * r2.y + abs(r2.x);
    r0.w = r0.w ? r1.w : r2.x;
    r0.xyz = -r0.xyz * r0.www + r0.www;
    o0.xyz = cb0[0].xyz * r1.xyz;
    o1.xyz = cb0[0].xyz * r0.xyz;
  } else {
    o0.xyz = float3(0, 0, 0);
    o1.xyz = float3(0, 0, 0);
  }
  return;
}
