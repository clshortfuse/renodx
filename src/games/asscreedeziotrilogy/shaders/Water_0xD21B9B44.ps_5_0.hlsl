// Literal-ish hand reconstruction from DXBC for behavior matching.
// Intentionally register-style and low-level.

#include ".././common.hlsli"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t8 : register(t8);
Texture2D<float4> t12 : register(t12);
Texture2D<float4> t14 : register(t14);
Texture2D<float4> t15 : register(t15);

SamplerState s0_s : register(s0);
SamplerState s6_s : register(s6);
SamplerState s7_s : register(s7);
SamplerState s8_s : register(s8);
SamplerState s12_s : register(s12);
SamplerState s14_s : register(s14);
SamplerComparisonState s15_s : register(s15);

cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

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

float FilterCmp5(float2 uv, float zref) {
  float4 taps;
  taps.x = t15.SampleCmpLevelZero(s15_s, uv, zref, int2(-1, 0));
  taps.y = t15.SampleCmpLevelZero(s15_s, uv, zref, int2(1, 0));
  taps.z = t15.SampleCmpLevelZero(s15_s, uv, zref, int2(0, -1));
  taps.w = t15.SampleCmpLevelZero(s15_s, uv, zref, int2(0, 1));
  float avg4 = dot(taps, 0.2f.xxxx);
  float center = t15.SampleCmpLevelZero(s15_s, uv, zref);
  return mad(center, 0.2f, avg4);
}

void main(
    noperspective float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    linear centroid float4 v2 : COLOR0,
    linear centroid float4 v3 : COLOR1,
    float4 v4 : TEXCOORD9,
    float4 v5 : TEXCOORD0,
    float4 v6 : TEXCOORD1,
    float4 v7 : TEXCOORD2,
    float4 v8 : TEXCOORD3,
    float4 v9 : TEXCOORD4,
    float4 v10 : TEXCOORD5,
    float4 v11 : TEXCOORD6,
    float4 v12 : TEXCOORD7,
    out float4 o0 : SV_TARGET0,
    out float4 o1 : SV_TARGET1) {
  float4 r0 = 0, r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0, r6 = 0, r7 = 0, r8 = 0, r9 = 0, r10 = 0, r11 = 0, r12 = 0, r13 = 0, r14 = 0;

  r0.xy = (v0.xy - 0.5f.xx) * asfloat(cb3[76]).xy;
  r1.xy = 0.5f.xx + r0.xy;
  r1.zw = r1.xy * cb4[108].xy;

  r2 = v7.wwww;
  if (any(r2.xyz < 0.f)) discard;

  r2.xyz = v7.xyx * float3(1.f, 1.f, 0.f) + float3(0.f, 0.f, 1.f);
  r3.x = dot(r2.xyz, cb4[136].xyz);
  r3.y = dot(r2.xyz, cb4[137].xyz);
  r3 = BitNorm(t0.Sample(s0_s, r3.xy), cb3[44], cb3[45]);
  r3.xyz += -0.5f.xxx;

  r4.x = dot(r2.xyz, cb4[139].xyz);
  r4.y = dot(r2.xyz, cb4[140].xyz);
  r4 = BitNorm(t0.Sample(s0_s, r4.xy), cb3[44], cb3[45]);
  r4.xyz += -0.5f.xxx;
  r4.xyz += r4.xyz;
  r3.xyz = mad(r3.xyz, 2.f.xxx, r4.xyz);

  r4.x = dot(r2.xyz, cb4[142].xyz);
  r4.y = dot(r2.xyz, cb4[143].xyz);
  r2 = BitNorm(t0.Sample(s0_s, r4.xy), cb3[44], cb3[45]);
  r2.xyz += -0.5f.xxx;
  r2.xyz = mad(r2.xyz, 2.f.xxx, r3.xyz);
  r2.w = cb4[145].x * v6.x;
  r5.xyz = r2.xyz + float3(0.f, 0.f, -1.f);
  r3.xyz = mad(r2.w.xxx, r5.xyz, float3(0.f, 0.f, 1.f));

  r5.x = SafeRsq(dot(v8.xyz, v8.xyz));
  r2.xyz = r5.x * v8.xyz;
  r4.xyz = SafeRsq(dot(v9.xyz, v9.xyz)) * v9.xyz;
  r5.xyz = SafeRsq(dot(v10.xyz, v10.xyz)) * v10.xyz;
  r4.xyz *= r3.y;
  r2.xyz = mad(r3.x.xxx, r2.xyz, r4.xyz);
  r2.xyz = mad(r3.z.xxx, r5.xyz, r2.xyz);
  r6.x = SafeRsq(dot(r2.xyz, r2.xyz));
  r3.xyz = r6.x * r2.xyz;
  r2.xyz = cb4[20].xyz - v7.xyz;

  r4 = BitNorm(t8.Sample(s8_s, r1.zw), cb3[60], cb3[61]);
  r1.z = r4.x + cb4[8].z;
  r1.z = SafeRcp(r1.z);

  r4 = float4(v7.xyz, 1.f);
  r1.w = dot(r4, cb4[16]);
  r1.z = mad(cb4[8].w, -r1.z, r1.w);
  r1.z = saturate(abs(r1.z) * cb4[148].x);

  r4.xyz = mad(r1.z.xxx, cb4[147].xyz - cb4[146].xyz, cb4[146].xyz);
  r6.xyz = r4.xyz * v3.xyz;
  r7.x = cb4[149].x;
  r1.z = mad(r1.z, r7.x, cb4[150].x);
  r1.z *= v3.w;

  r8.w = dot(v5.xy, v5.xy);
  r1.w = SafeRsq(r8.w);
  r7.xyz = v5.xyx * float3(1.f, 1.f, 0.f);
  r7.xyz = mad(r7.xyz, r1.w.xxx, float3(0.f, 0.f, 1.f));
  r1.w = saturate(dot(r7.xyz, r3.xyz) * cb4[155].x);
  r1.w += 0.001f;
  r2.w = SafePowLog2(r1.w, cb4[156].x);
  r7.xyz = r2.w * cb4[30].xyz;
  r7.xyz *= cb4[154].x;

  r8.xy = mad(r1.xy, cb4[108].xy, r3.xy);
  r8 = BitNorm(t7.Sample(s7_s, r8.xy), cb3[58], cb3[59]);
  r8.xyz *= cb4[157].xyz;

  r9.xy = float2(0.5f, 1.f);
  r10.xyz = v7.xyz - cb4[20].xyz;
  r2.w = SafeRsq(dot(r10.xyz, r10.xyz));
  r10.xyz *= r2.w;
  r2.w = dot(-r10.xyz, r3.xyz);
  r2.w = 1.f - r2.w;
  r3.w = abs(r2.w) * abs(r2.w);
  r3.w *= r3.w;
  r2.w = abs(r2.w) * r3.w;
  r11.w = r9.y - cb4[158].x;
  r3.w = mad(r2.w, r11.w, cb4[158].x);
  r10.x = cb4[159].x;
  r2.w = mad(r3.w, r10.x, cb4[160].x);
  r8.xyz *= r2.w;
  r7.xyz = mad(cb4[152].xyz, r7.xyz, r8.xyz);
  r4.xyz = max(mad(v3.xyz, r4.xyz, r7.xyz), 0.f.xxx);

  r7.xyz = mad(v11.xyz, cb4[90].xyz, cb4[92].xyz);
  r8.xyz = mad(v11.xyz, cb4[91].xyz, cb4[93].xyz);
  r10.xyz = mad(v11.xyz, cb4[88].xyz, cb4[89].xyz);
  r11.xyz = mad(v11.xyz, cb4[86].xyz, cb4[87].xyz);

  r2.w = r8.x - r8.y;
  r3.w = r10.x - r10.y;
  r4.w = r11.x - r11.y;

  float2 p8 = (r2.w >= 0.f) ? r8.yx : r8.xy;
  float2 p10 = (r3.w >= 0.f) ? r10.yx : r10.xy;
  // DXBC uses:
  //   movc r9.zw, cond, r11.xyyx, r11.xyxy
  // which resolves to (cond ? r11.yx : r11.xy) for the payload pair.
  float2 p11 = (r4.w >= 0.f) ? r11.yx : r11.xy;

  float3 in_lo = float3(p8.x, p10.x, p11.x) - cb4[72].yzw;
  float3 in_hi = cb4[73].yzw - float3(p8.y, p10.y, p11.y);
  float3 inside = step(0.f.xxx, in_lo) * step(0.f.xxx, in_hi) - 1.f.xxx;

  r8.w = mad(r8.x, 0.25f, 0.25f);
  r7.w = r7.x * 0.25f;
  r7.xyz = (inside.x >= 0.f) ? float3(r8.w, r8.y, r8.z) : float3(r7.w, r7.y, r7.z);
  r10.w = mad(r10.x, 0.25f, 0.5f);
  r7.xyz = (inside.y >= 0.f) ? float3(r10.w, r10.y, r10.z) : r7.xyz;
  r11.w = mad(r11.x, 0.25f, 0.75f);
  r7.xyz = (inside.z >= 0.f) ? float3(r11.w, r11.y, r11.z) : r7.xyz;

  r1.xy = v5.xy * 0.015625f.xx;
  r8 = BitNorm(t6.Sample(s6_s, r1.xy), cb3[56], cb3[57]);
  r1.xy = r8.yx - 0.5f.xx;

  float2 inv94 = float2(SafeRcp(cb4[94].x), SafeRcp(cb4[94].y));
  float zref = r7.z * 0.5f + 0.5f;

  r8.xy = float2(dot(r1.xy, float2(-0.124001f, 1.299115f)),
                  dot(r1.xy, float2(0.389028f, -0.504198f)));
  r8.z = dot(r1.xy, float2(1.299115f, -0.124001f));
  r8.xz *= cb4[85].x;
  r11.xy = mad(r8.xz, inv94, r7.xy);

  if (cb4[235].w != 0.f) {
    r12.xyz = FilterCmp5(r11.xy, zref).xxx;
    r12.w = 1.f;
  } else {
    r11.xyz = FilterCmp5(r11.xy, zref).xxx;
    r11.w = 1.f;
    r12.x = ((r11.x - r7.z) >= 0.f) ? 1.f : 0.f;
  }

  r8.w = dot(r1.xy, float2(-0.504198f, 0.389028f));
  r8.xy = float2(r8.y, r8.w) * cb4[85].x;
  r8.xy = mad(r8.xy, inv94, r7.xy);
  if (cb4[235].w != 0.f) {
    r11.xyz = FilterCmp5(r8.xy, zref).xxx;
    r11.w = 1.f;
  } else {
    r8.xyz = FilterCmp5(r8.xy, zref).xxx;
    r8.w = 1.f;
    r11.x = ((r8.x - r7.z) >= 0.f) ? 1.f : 0.f;
  }
  r2.w = r11.x + r12.x;

  r8.xy = float2(dot(r1.xy, float2(-1.205221f, -0.335032f)),
                  dot(r1.xy, float2(1.975933f, 0.160125f)));
  r8.z = dot(r1.xy, float2(-0.335032f, -1.205221f));
  r8.xz *= cb4[85].x;
  r11.xy = mad(r8.xz, inv94, r7.xy);
  if (cb4[235].w != 0.f) {
    r12.xyz = FilterCmp5(r11.xy, zref).xxx;
    r12.w = 1.f;
  } else {
    r11.xyz = FilterCmp5(r11.xy, zref).xxx;
    r11.w = 1.f;
    r12.x = ((r11.x - r7.z) >= 0.f) ? 1.f : 0.f;
  }
  r2.w += r12.x;

  r8.w = dot(r1.xy, float2(0.160125f, 1.975933f));
  r1.xy = float2(r8.y, r8.w) * cb4[85].x;
  r8.xy = mad(r1.xy, inv94, r7.xy);
  if (cb4[235].w != 0.f) {
    r10.xyz = FilterCmp5(r8.xy, zref).xxx;
    r10.w = 1.f;
  } else {
    r8.xyz = FilterCmp5(r8.xy, zref).xxx;
    r8.w = 1.f;
    r10.x = ((r8.x - r7.z) >= 0.f) ? 1.f : 0.f;
  }
  r1.x = r2.w + r10.x;
  r1.y = saturate(mad(r1.w, cb4[82].x, cb4[82].y));
  r1.x = saturate(mad(r1.x, 0.25f, r1.y));

  r1.yw = mad(v7.xy, cb4[123].xy, cb4[123].zw);
  r7 = BitNorm(t14.Sample(s14_s, r1.yw), cb3[72], cb3[73]);
  r1.x *= r7.x;
  r1.y = saturate(dot(r3.xyz, cb4[60].xyz));
  r7.xyz = r1.y * cb4[61].xyz;
  r7.xyz *= r1.x;
  r8.xyz = r6.xyz * cb4[151].xyz;

  r1.y = dot(r5.xyz, cb4[62].xyz);
  r1.y = saturate((r1.y + 0.05f) * 49.999996f);
  r1.w = dot(-cb4[62].xyz, r3.xyz);
  r1.w += r1.w;
  r5.xyz = mad(r3.xyz, -r1.w.xxx, -cb4[62].xyz);
  r1.w = SafeRsq(dot(r2.xyz, r2.xyz));
  r2.xyz *= r1.w;
  r2.x = saturate(dot(r5.xyz, r2.xyz));
  r3.w = SafePowLog2(r2.x, cb4[153].x);
  r2.x = r3.w * cb4[154].x;
  r5.xyz = cb4[152].xyz;
  r2.yzw = r5.xyz * cb4[61].xyz;
  r2.xyz *= max(r2.x * r1.y * r1.x, 0.f);
  r2.xyz = mad(r8.xyz, r7.xyz, r2.xyz);

  r5.xyz = r6.xyz * v2.x;
  r6.xyz = r3.xyz * r3.xyz;
  float3 pos_mask = step(0.f.xxx, r3.xyz);
  float3 neg_mask = step(0.f.xxx, -r3.xyz);
  r10 = r6.x * cb4[32];
  r11 = r6.x * cb4[33];
  r11 *= neg_mask.x;
  r10 = mad(pos_mask.x, r10, r11);
  r11 = r6.y * cb4[34];
  r10 = mad(pos_mask.y, r11, r10);
  r11 = r6.y * cb4[35];
  r10 = mad(neg_mask.y, r11, r10);
  r11 = r6.z * cb4[36];
  r7 = mad(pos_mask.z, r11, r10);
  r6 = r6.z * cb4[37];
  r6 = mad(neg_mask.z, r6, r7);
  r6.xyz *= max(r6.w, 0.f);
  r6.xyz *= r5.xyz;

  r1.xy = mad(r3.xy, cb4[95].x, v7.xy);
  r3.xy = mad(r1.xy, cb4[96].zw, r9.x);
  r1.x = SafeRcp(r1.w);
  r1.y = r1.x - cb4[97].x;
  r1.w = SafeRcp(cb4[97].y);
  r3.w = saturate(r1.w * r1.y);
  r3.z = 0.f;
  r3 = BitNorm(t12.SampleLevel(s12_s, r3.xy, r3.w), cb3[68], cb3[69]);
  r3.xyz *= max(cb4[96].x, 0.f);
  r1.y = mad(r3.w, cb4[95].w, cb4[95].y);
  r1.y += -v7.z;
  r1.y = saturate(mad(abs(r1.y), -cb4[95].z, r9.y));
  r3.xyz *= max(r1.y, 0.f);
  r7.xyz = r5.xyz * r3.xyz;
  r1.y = saturate(dot(r7.xyz, cb4[96].yyy));
  r3.xyz = mad(r3.xyz, r5.xyz, -r6.xyz);
  r3.xyz = mad(r1.y.xxx, r3.xyz, r6.xyz);
  r2.xyz += r3.xyz;
  r2.xyz = saturate(r4.xyz + r2.xyz);
  r1.x = r1.x - cb4[25].x;
  r1.x = saturate(r1.x * cb4[25].y);
  r1.x *= cb4[25].z;
  r3.xyz = cb4[24].xyz - r2.xyz;
  o0.xyz = max(mad(r1.x.xxx, r3.xyz, r2.xyz), 0.f.xxx);

  r1.x = SafeRcp(v2.w);
  o1.xyz = max(r1.x * v2.zzz, 0.f.xxx);
  o0.w = saturate(r1.z);
  o1.w = saturate(r1.z);
}
