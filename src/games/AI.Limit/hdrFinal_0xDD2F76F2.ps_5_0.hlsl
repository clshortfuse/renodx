// ---- Created with 3Dmigoto v1.3.16 on Sat Apr 12 15:50:29 2025
// HDR Final, second permutation -- DLSS

#include "./common.hlsl"

Texture2DArray<float4> t3 : register(t3);

Texture2DArray<float4> t2 : register(t2);

Texture2DArray<float4> t1 : register(t1);

Texture2DArray<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[80];
}

cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0, 0);
  r1.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r1.zw = cb0[4].xy * r1.xy;
  r0.xy = (uint2)r1.zw;
  r0.xyz = t0.Load(r0.xyzw).xyz;
  r0.xyz = (r0.xyz);  // removed saturate to unclamp game

  // sRGB Encode
  // r2.xyz = log2(r0.xyz);
  // r2.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r2.xyz;
  // r2.xyz = exp2(r2.xyz);
  // r2.xyz = r2.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  // r3.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
  // r0.xyz = float3(12.9232101, 12.9232101, 12.9232101) * r0.xyz;
  // r0.xyz = r3.xyz ? r0.xyz : r2.xyz;
  r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);

  r2.xy = cb0[2].xy * r1.xy;
  r1.xy = cb1[48].xy * r1.xy;
  r2.z = cb0[2].z;
  r0.w = t2.SampleBias(s1_s, r2.xyz, cb1[79].y).w;
  r0.w = r0.w * 2 + -1;
  r1.w = 1 + -abs(r0.w);
  r0.w = cmp(r0.w >= 0);
  r0.w = r0.w ? 1 : -1;
  r1.w = sqrt(r1.w);
  r1.w = 1 + -r1.w;
  r0.w = r1.w * r0.w;
  r0.xyz = r0.www * float3(0.00392156886, 0.00392156886, 0.00392156886) + r0.xyz;

  // sRGB Decode
  // r2.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r0.xyz;
  // r2.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r2.xyz;
  // r2.xyz = log2(abs(r2.xyz));
  // r2.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r2.xyz;
  // r2.xyz = exp2(r2.xyz);
  // r3.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  // r0.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r0.xyz);
  // r0.xyz = r0.xyz ? r3.xyz : r2.xyz;
  r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);

  r1.z = 0;
  r1.xyzw = t1.SampleLevel(s0_s, r1.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.xyz + r1.xyz;
  r0.xy = cb1[46].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1, -1) + cb1[46].xy;
  r0.zw = cb0[3].zw * r0.zw;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0, 0);
  r0.x = t3.Load(r0.xyzw).x;
  r0.y = cmp(cb0[5].x == 1.000000);
  o0.w = r0.y ? r0.x : 1;
  return;
}
