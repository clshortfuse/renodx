#include "../../common/color.hlsl"
#include "./shared.h"

cbuffer Gamma : register(b0) {
  float4 gXfGammaFactor0 : packoffset(c0);
  float4 gXfGammaFactor1 : packoffset(c1);
  float gXfMipMapLevel : packoffset(c2);
}

cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

SamplerState XfBaseSampler_s : register(s0);
Texture2D<float4> XfBaseSamplerTEXTURE : register(t0);

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_TARGET0 {
  float4 r0, r1, r2, r3, o0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = gXfGammaFactor0.xy;
  r0.z = 1;
  const float4 XfBaseSamplerRGBA = XfBaseSamplerTEXTURE.Sample(XfBaseSampler_s, v1.xy).xyzw;
  r1.xyzw = XfBaseSamplerRGBA;
  r1.xyzw = min(float4(1, 1, 1, 1), r1.xyzw);
  r2.z = r1.x;
  r2.y = r1.x * r1.x;
  r2.x = r2.y * r1.x;
  r3.x = dot(r2.xzy, float3(3, 3, -6));
  r3.y = dot(r2.yx, float2(3, -3));
  r3.z = r2.x;
  o0.x = dot(r3.xyz, r0.xyz);
  r0.xy = gXfGammaFactor0.zw;
  r0.z = 1;
  r2.z = r1.y;
  r2.y = r1.y * r1.y;
  r2.x = r2.y * r1.y;
  r3.x = dot(r2.xzy, float3(3, 3, -6));
  r3.y = dot(r2.yx, float2(3, -3));
  r3.z = r2.x;
  o0.y = dot(r3.xyz, r0.xyz);
  r1.y = r1.z * r1.z;
  r1.x = r1.y * r1.z;
  o0.w = r1.w;
  r0.x = dot(r1.xzy, float3(3, 3, -6));
  r0.y = dot(r1.yx, float2(3, -3));
  r0.z = r1.x;
  r1.xy = gXfGammaFactor1.xy;
  r1.z = 1;
  o0.z = dot(r0.xyz, r1.xyz);

  float4 outputColor = o0.rgba;

  if (injectedData.toneMapType) {
    outputColor.rgb = XfBaseSamplerRGBA.rgb;
  }

  outputColor.rgb = pow(max(0, outputColor.rgb), 2.2f);
  // Convert to linear

  outputColor.rgb *= injectedData.toneMapUINits;
  outputColor.rgb /= 80.f;
  return outputColor;
}
