// Found in Banishers, when swapping characters

#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Wed Aug  6 16:59:07 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[3];
}

cbuffer cb1 : register(b1) {
  float4 cb1[148];
}

cbuffer cb0 : register(b0) {
  float4 cb0[39];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.zw = cb1[147].xx + r0.xy;
  r0.zw = (uint2)r0.zw;
  r0.w = (uint)r0.w << 1;
  r0.z = (int)r0.w + (int)r0.z;
  r0.z = (uint)r0.z % 5;
  r0.z = (uint)r0.z;
  r0.w = cmp(cb1[137].y >= -cb1[137].y);
  r1.x = frac(abs(cb1[137].y));
  r0.w = r0.w ? r1.x : -r1.x;
  r0.w = 0.100000001 * r0.w;
  r1.xy = r0.xy * float2(0.015625, 0.015625) + r0.ww;
  r0.w = t0.Sample(s0_s, r1.xy).x;
  r0.z = r0.z + r0.w;
  r0.z = r0.z * 0.166666672 + -0.5;
  r0.z = cb2[1].w * r0.z + cb2[1].w;
  r1.xyz = float3(-0.0250000004, -0.0500000007, -0.100000001) * r0.zzz;
  r0.zw = -r0.xy * cb0[38].zw + float2(1, 1);
  r2.xy = cb0[38].zw * r0.xy;
  r0.xy = r0.xy * cb0[38].zw + float2(-0.5, -0.5);
  r0.xy = r0.xy + r0.xy;
  r0.zw = r2.xy * r0.zw;
  r0.zw = float2(4, 4) * r0.zw;
  r0.z = -r0.z * r0.w + 1;
  r0.z = saturate(-cb2[1].x + r0.z);
  r0.z = r0.z * r0.z;
  r0.w = r0.z * r0.z;
  r0.xy = r0.xy * r0.ww;
  r3.xyzw = r0.xyxy * r1.xxyy + r2.xyxy;
  r0.xy = r0.xy * r1.zz + r2.xy;
  r0.xy = r0.xy * cb0[5].xy + cb0[4].xy;
  r0.xy = max(cb0[6].xy, r0.xy);
  r0.xy = min(cb0[6].zw, r0.xy);
  r0.xyw = t1.Sample(s1_s, r0.xy).xyz;
  r1.xyzw = r3.xyzw * cb0[5].xyxy + cb0[4].xyxy;
  r1.xyzw = max(cb0[6].xyxy, r1.xyzw);
  r1.xyzw = min(cb0[6].zwzw, r1.xyzw);
  r2.xyz = t1.Sample(s1_s, r1.xy).xyz;
  r1.xyz = t1.Sample(s1_s, r1.zw).xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r0.xyw = r1.xyz + r0.xyw;
  r1.xyz = float3(0.333332986, 0.333332986, 0.333332986) * r0.xyw;
  // r2.xyz = saturate(r1.xyz);
  r2.xyz = RENODX_TONE_MAP_TYPE ? r1.xyz : saturate(r1.xyz);

  r3.xyz = r2.xyz * r2.xyz + -r2.xyz;
  r2.xyz = r0.zzz * r3.xyz + r2.xyz;
  r0.xyz = -r0.xyw * float3(0.333332986, 0.333332986, 0.333332986) + r2.xyz;
  r0.xyz = cb2[1].yyy * r0.xyz + r1.xyz;
  r1.xyz = cb2[2].yzw + -r0.xyz;
  r0.xyz = cb2[2].xxx * r1.xyz + r0.xyz;

  // o0.xyz = max(float3(0, 0, 0), r0.xyz);
  o0.rgb = RENODX_TONE_MAP_TYPE ? r0.rgb : max(0, r0.rgb);
  o0.w = 1;
  return;
}
