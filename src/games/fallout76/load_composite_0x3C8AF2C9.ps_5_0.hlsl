#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:52 2024
Texture2D<float4> t0 : register(t0);

SamplerState s9_s : register(s9);

cbuffer cb2 : register(b2) {
  float4 cb2[2];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.Sample(s9_s, v1.xy).xyz;
  r1.xyz = log2(r0.xyz);
  r1.xyz = cb2[1].xxx * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = cmp(float3(0, 0, 0) != cb2[0].yzw);
  r0.xyz = r2.xxx ? r1.xyz : r0.xyz;
  r1.x = dot(float3(0.627403975, 0.329281986, 0.0433136001), r0.xyz);
  r1.y = dot(float3(0.0690969974, 0.919539988, 0.0113612004), r0.xyz);
  r1.z = dot(float3(0.0163915996, 0.088013202, 0.895595014), r0.xyz);
  r0.xyz = r2.yyy ? r1.xyz : r0.xyz;
  r1.xyz = cb2[0].xxx * r0.xyz;
  r1.xyz = float3(9.99999975e-005, 9.99999975e-005, 9.99999975e-005) * r1.xyz;
  r1.xyz = log2(abs(r1.xyz));
  r1.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyw = r1.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
  r1.xyz = r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
  r1.xyz = r2.xyw / r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(78.84375, 78.84375, 78.84375) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyw = -cb2[1].zzz + r1.xyz;
  r3.xy = cb2[1].wy + -cb2[1].zz;
  r2.xyw = saturate(r2.xyw / r3.xxx);
  r3.xyz = r2.xyw * r3.yyy + cb2[1].zzz;
  r4.xyz = float3(1, 1, 1) + -r2.xyw;
  r2.xyw = cb2[1].yyy * r2.xyw;
  r2.xyw = r3.xyz * r4.xyz + r2.xyw;
  r2.xyw = min(r2.xyw, r1.xyz);
  r3.xyz = cmp(cb2[1].zzz < r1.xyz);
  r1.xyz = r3.xyz ? r2.xyw : r1.xyz;
  o0.xyz = r2.zzz ? r1.xyz : r0.xyz;
  o0.w = 1;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::srgb::Decode(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;

  return;
}