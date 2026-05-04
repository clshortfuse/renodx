#include ".././common.hlsli"

cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

SamplerState s0_s : register(s0);
SamplerState s8_s : register(s8);

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t8 : register(t8);

float4 BitNorm(float4 value, uint4 bit_and, uint4 bit_or) {
  return asfloat((asuint(value) & bit_and) | bit_or);
}

float DxbcRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : 1e34f;
}

float DxbcRsq(float x) {
  return abs(x) > 0.f ? rsqrt(abs(x)) : 1e34f;
}

void main(
    noperspective float4 v0 : SV_POSITION0,
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

  r1.xy = (v0.xy - 0.5f.xx) * asfloat(cb3[76]).xy;
  r0.xy = mad(r1.xy, cb4[137].xy, cb4[137].zw);
  uint4 t8_bits = asuint(t8.Sample(s8_s, r0.xy));
  t8_bits = (t8_bits & cb3[60]) | cb3[61];
  r2.x = asfloat(t8_bits.x);

  r0.xy = mad(r0.xy, float2(2.f, -2.f), float2(-1.f, 1.f));
  r0.z = r2.x;
  r0.w = 1.f;

  r2.x = dot(r0, cb4[136]);
  r2.x = DxbcRcp(r2.x);
  r3.x = dot(r0, cb4[133]);
  r3.y = dot(r0, cb4[134]);
  r3.z = dot(r0, cb4[135]);
  r0.xyz = mad(r3.xyz, r2.x, -cb4[132].xyz);

  r2.x = dot(cb4[130].xyz, r0.xyz);
  r2.y = dot(cb4[131].xyz, r0.xyz);
  r0.w = dot(r0.xyz, r0.xyz);
  r0.x = dot(cb4[140].xyz, r0.xyz);

  float inv_len = DxbcRsq(r0.w);
  float norm_dot0 = inv_len * r2.x;
  float norm_dot1 = inv_len * r2.y;

  float len = DxbcRcp(inv_len);
  float inv_scale_z = DxbcRcp(cb4[129].z);
  float scale = len * inv_scale_z;

  r0.y = mad(scale, norm_dot0, 1.f);
  r0.z = mad(scale, norm_dot1, 1.f);

  r2.x = r0.y * 0.5f;
  r2.y = r0.z * 0.5f;
  r2.z = mad(-0.5f, r0.y, 1.f);
  r2.w = mad(-0.5f, r0.z, 1.f);

  if (r2.x < 0.f || r2.y < 0.f || r2.z < 0.f) discard;

  uint4 t0_bits = asuint(t0.Sample(s0_s, r2.xy));
  t0_bits = (t0_bits & cb3[44]) | cb3[45];
  r2 = asfloat(t0_bits);

  float inv_scale_w = DxbcRcp(cb4[129].w);
  r0.x = abs(r0.x) * inv_scale_w;

  r0 = r0.xxxx * cb4[139];
  r3 = cb4[139] * cb4[132].w;
  r5 = cb4[138] - r2;
  r4 = mad(r3, r5, r2);
  r2 = cb4[138] - r4;
  r5 = mad(r0, r2, r4);

  r0.w = r5.w * 255.f + 0.0001f;
  if ((uint)r0.w < cb3[8].z) discard;

  o0 = r5;
}
