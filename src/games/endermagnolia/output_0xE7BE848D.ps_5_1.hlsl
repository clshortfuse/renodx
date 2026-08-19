#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Thu Feb 27 00:21:51 2025
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

struct t0_t {
  float val[4];
};
StructuredBuffer<t0_t> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[144];
}

cbuffer cb0 : register(b0) {
  float4 cb0[52];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0 : TEXCOORD0,
    linear noperspective float2 w0 : TEXCOORD1,
    linear noperspective float4 v1 : TEXCOORD2,
    linear noperspective float2 v2 : TEXCOORD3,
    linear noperspective float2 w2 : TEXCOORD4,
    float4 v3 : SV_POSITION0,
    out float4 o0 : SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[47].xx * w0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + r0.x;
  r0.x = rcp(r0.x);
  r0.x = r0.x * r0.x;
  r1.xyzw = t2.Sample(s1_s, w2.xy).xyzw;
  // float3 untonemapped = r1.rgb;

  r0.x = r1.w * r0.x;
  r0.y = t0[0].val[0 / 4];
  r0.y = cb1[143].w * r0.y;
  r0.x = r0.y * r0.x;
  r0.yzw = r1.xyz * r0.xxx;
  r1.xy = max(cb0[15].xy, v0.xy);
  r1.xy = min(cb0[15].zw, r1.xy);
  r1.xyz = t1.Sample(s0_s, r1.xy).xyz;
  float3 untonemapped = r1.rgb;
  
  r1.xyz = cb0[44].xyz * r1.xyz;
  r0.xyz = r1.xyz * r0.xxx + r0.yzw;
  r0.xyz = float3(0.00266771927, 0.00266771927, 0.00266771927) + r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0714285746, 0.0714285746, 0.0714285746) + float3(0.610726953, 0.610726953, 0.610726953));
  r0.yzw = r0.xyz * cb0[50].zzz + cb0[50].www;
  r1.y = r0.z;
  r0.w = r0.w * cb0[50].x + -0.5;
  r1.z = floor(r0.w);
  r0.w = -r1.z + r0.w;
  r0.y = r1.z + r0.y;
  r1.x = r0.y * cb0[50].y + cb0[50].y;
  r0.x = cb0[50].y * r0.y;
  r0.xyz = t3.Sample(s2_s, r0.xz).xyz;
  r1.xyz = t3.Sample(s2_s, r1.xy).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  float3 tonemapped = r0.rgb;

  if (RENODX_TONE_MAP_TYPE != 0) {
    o0 = ProcessColor(untonemapped, tonemapped);
    return;
  }

  r0.w = v1.w * 543.309998 + v1.z;
  r0.w = sin(r0.w);
  r0.w = 493013 * r0.w;
  r0.w = frac(r0.w);
  r0.w = r0.w * 2 + -1;
  // r1.x = r0.w * +1. #INF;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r1.x = max(-1, r1.x);
  r1.x = min(1, r1.x);
  r0.w = -r1.x * r0.w + r1.x;
  r0.w = cb0[51].y * r0.w;
  o0.xyz = r0.xyz * float3(1.04999995, 1.04999995, 1.04999995) + r0.www;

  return;
}