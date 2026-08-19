// ---- Created with 3Dmigoto v1.3.16 on Tue Nov  5 03:23:19 2024
// UI

#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[27];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : COLOR0,
    float4 v2 : COLOR1,
    float4 v3 : TEXCOORD0,
    float4 v4 : TEXCOORD1,
    float4 v5 : TEXCOORD2,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = log2(v1.xyz);
  r0.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r1.xyz = float3(12.9200001, 12.9200001, 12.9200001) * v1.xyz;
  r2.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= v1.xyz);
  r0.xyz = r2.xyz ? r1.xyz : r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r1.x = saturate(r1.w * v4.x + -v4.w);
  r0.w = v1.w;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.xy = cb0[26].zw + -cb0[26].xy;
  r1.xy = -abs(v5.xy) + r1.xy;
  r1.xy = saturate(v5.zw * r1.xy);
  r1.x = r1.x * r1.y;
  o0.xyzw = r1.xxxx * r0.xyzw;

  o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);                         // 2.2 gamma correction
  o0.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits;  // Ratio of UI:Game brightness
  o0.rgb = renodx::math::SafePow(o0.rgb, 1 / 2.2);                      // Inverse 2.2 gamma

  return;
}