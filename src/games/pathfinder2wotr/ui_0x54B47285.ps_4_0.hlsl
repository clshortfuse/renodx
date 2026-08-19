// ---- Created with 3Dmigoto v1.3.16 on Tue Nov  5 00:45:40 2024
// UI
// Animated character in inventory

#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : COLOR0,
    float4 v2 : TEXCOORD0,
    float4 v3 : TEXCOORD1,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = cb0[3].xyzw + r0.xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.xyz = log2(r0.xyz);
  r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r0.xyz;
  r0.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
  o0.xyz = r0.xyz ? r2.xyz : r1.xyz;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r0.x = cmp(cb0[7].z >= r1.w);
  r0.x = r0.x ? 0 : r1.w;
  r0.x = r0.w * r0.x;
  r0.yz = cmp(v2.xy < cb0[6].zw);
  r1.xy = cmp(cb0[7].xy < v2.xy);
  r0.y = (int)r0.y | (int)r1.x;
  r0.y = (int)r0.z | (int)r0.y;
  r0.y = (int)r1.y | (int)r0.y;
  o0.w = r0.y ? r0.w : r0.x;

  o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);                         // 2.2 gamma correction
  o0.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits;  // Ratio of UI:Game brightness
  //o0.rgb = renodx::math::SafePow(o0.rgb, 1 / 2.2);                      // Inverse 2.2 gamma

  return;
}