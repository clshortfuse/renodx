#include ".././common.hlsli"

cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);

float4 BitNorm(float4 value, uint4 bit_and, uint4 bit_or) {
  return asfloat((asuint(value) & bit_and) | bit_or);
}

float SafeRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : 0.f;
}

float SafeRsq(float x) {
  return x > 0.f ? rsqrt(x) : 0.f;
}

float SafePowLog2(float x, float p) {
  float lx = log2(abs(x));
  float v = lx * p;
  return (v == v) ? exp2(v) : 0.f;
}

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    float4 v2 : COLOR0,
    float4 v3 : COLOR1,
    float4 v4 : TEXCOORD9,
    float4 v5 : TEXCOORD0,
    float4 v6 : TEXCOORD1,
    float4 v7 : TEXCOORD2,
    float4 v8 : TEXCOORD3,
    float4 v9 : TEXCOORD4,
    float4 v10 : TEXCOORD5,
    float4 v11 : TEXCOORD6,
    float4 v12 : TEXCOORD7,
    out float4 o0 : SV_TARGET0) {
  float4 r0 = 0.f;
  float4 r1 = 0.f;
  float4 r2 = 0.f;
  float4 r3 = 0.f;
  float4 r4 = 0.f;
  float4 r5 = 0.f;

  // DXBC:
  //   mad r0.xyz, v5.xyxw, float4(1,1,0,-1), float4(0,0,1,-1)
  // so the 3-component payload is:
  //   x = v5.x
  //   y = v5.y
  //   z = 1
  r0.xyz = float3(v5.x, v5.y, 1.f);

  r1.x = dot(r0.xyz, cb4[136].xyz);
  r1.y = dot(r0.xyz, cb4[137].xyz);
  r1 = BitNorm(t0.Sample(s0_s, r1.xy), cb3[44], cb3[45]);

  r1.x = dot(r0.xyz, cb4[139].xyz);
  r1.y = dot(r0.xyz, cb4[140].xyz);
  r0 = BitNorm(t1.Sample(s1_s, r1.xy), cb3[46], cb3[47]);

  r3.x = r0.w - r1.w;
  r2.x = mad(cb4[142].x, r3.x, r1.w);
  r0.x = dot(0.33f.xxx, r0.xyz);
  r3.x = r0.x - r2.x;
  r1.x = mad(cb4[143].x, r3.x, r2.x);

  r0.x = 1.f - r1.x;
  r2.x = 1.f;
  r0.y = r2.x - cb4[144].x;
  r0.x = saturate(r0.x - r0.y);
  r0.y = saturate(r1.x - cb4[145].x);
  r0.z = r1.x * cb4[151].x;
  r1.x = min(r0.y, r0.x);

  r4.x = SafeRsq(dot(v9.xyz, v9.xyz));
  r3.xyz = r4.x * v9.xyz;
  r5.x = SafeRsq(dot(v10.xyz, v10.xyz));
  r4.xyz = r5.x * v10.xyz;

  r0.x = dot(r3.xyz, r4.xyz);
  r1.y = SafePowLog2(abs(r0.x), cb4[148].x);

  r0.x = mad(cb4[149].x, r1.y - 1.f, r2.x);
  r0.y = 1.f - saturate(r0.x);
  r5.y = r0.y - r0.x;
  r1.y = mad(cb4[150].x, r5.y, r0.x);

  r0.x = r0.z * r1.y;
  r0.x *= v2.w;

  r0.yzw = cb4[20].xxy - v6.xxy;
  r0.y = dot(r0.yzw, r0.yzw);
  r0.y = SafeRsq(abs(r0.y));
  r0.y = SafeRcp(r0.y) - cb4[146].x;
  r0.z = SafeRcp(cb4[147].x - cb4[146].x);
  r0.y = saturate(r0.z * r0.y);

  r0.x *= r0.y;
  r0.x *= r1.x;

  r1.x = cb4[151].x;
  r0.y = r1.x * cb4[152].x;
  r0.y *= r1.y;

  o0 = r0.xxxx * r0.yyyy;
}
