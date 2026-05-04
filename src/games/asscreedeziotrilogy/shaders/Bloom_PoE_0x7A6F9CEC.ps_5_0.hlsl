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
    bool v13 : SV_IsFrontFace,
    out float4 o0 : SV_TARGET0) {
  float4 r0 = 0.f;
  float4 r1 = 0.f;
  float4 r2 = 0.f;
  float4 r3 = 0.f;
  float4 r4 = 0.f;
  float4 r5 = 0.f;

  r0.xyz = cb4[20].xyz - v6.xyz;
  r0.x = dot(r0.xyz, r0.xyz);
  r1.y = SafeRsq(abs(r0.x));
  r0.x = SafeRcp(r1.y) - cb4[146].x;
  r0.y = SafeRcp(cb4[147].x - cb4[146].x);
  r0.x = saturate(r0.y * r0.x);

  r2.x = v13 ? 1.f : -1.f;
  r0.y = (r2.x >= 0.f) ? 1.f : -1.f;

  r3.x = SafeRsq(dot(v9.xyz, v9.xyz));
  r1.xyz = r3.x * v9.xyz;
  r3.xyz = -cb4[102].x * r1.xyz;
  r0.yzw = (r0.y >= 0.f) ? r1.xxy : r3.xxy;

  r1.x = 1.f;
  r1.y = 0.f;
  r1.z = -1.f;
  r1.w = 0.33f;
  r3 = v6.xyzx * r1.xxxw - cb4[20];
  r1.y = dot(r3, r3);
  r1.y = SafeRsq(abs(r1.y));
  r1.yzw = r1.y * float3(r3.x, r3.x, r3.y);
  r0.y = dot(r0.yzw, r1.yzw);
  r1.y = SafePowLog2(abs(r0.y), cb4[148].x);

  r0.y = mad(cb4[149].x, r1.y - 1.f, r1.x);
  r0.z = 1.f - saturate(r0.y);
  r4.y = r0.z - r0.y;
  r1.y = max(mad(cb4[150].x, r4.y, r0.y), 0.f);

  // DXBC:
  // mad r0.yzw, v5.xxyx, float4(1,1,1,0), float4(1,0,0,1)
  r0.y = v5.x + 1.f;
  r0.z = v5.x;
  r0.w = v5.y;

  r3.x = dot(r0.yzw, cb4[136].xyz);
  r3.y = dot(r0.yzw, cb4[137].xyz);
  r3 = BitNorm(t0.Sample(s0_s, r3.xy), cb3[44], cb3[45]);

  r3.x = dot(r0.yzw, cb4[139].xyz);
  r3.y = dot(r0.yzw, cb4[140].xyz);
  r4 = BitNorm(t1.Sample(s1_s, r3.xy), cb3[46], cb3[47]);

  r5.y = r4.w - r3.w;
  r0.y = mad(cb4[142].x, r5.y, r3.w);
  r0.z = dot(0.33f.xxx, r4.xyz);
  r5.z = r0.z - r0.y;
  r1.z = max(mad(cb4[143].x, r5.z, r0.y), 0.f);

  r0.y = max(r1.z * cb4[151].x, 0.f);
  r0.y *= r1.y;
  r0.z = max(mad(cb4[152].x, v2.w - 1.f, r1.x), 0.f);
  r0.y *= r0.z;
  r0.x *= r0.y;

  r0.y = 1.f - r1.z;
  r0.z = saturate(r1.z - cb4[145].x);
  r0.w = r1.x - cb4[144].x;
  r0.y = saturate(r0.y - r0.w);
  r1.x = min(r0.z, r0.y);
  r0.x *= r1.x;

  r1.x = max(cb4[151].x, 0.f);
  r0.y = max(r1.x * cb4[153].x, 0.f);
  r0.y *= r1.y;
  r5 = max(r0.xxxx * r0.yyyy, 0.f.xxxx);
  r5 = 1.f.xxxx - exp2(-r5);

  r0.w = r5.w * 255.f + 0.0001f;
  if ((uint)r0.w < cb3[8].z) discard;

  o0 = r5;
}
