#include "./shared.h"
#include "../../shaders/color.hlsl"

cbuffer GFD_PSCONST_SYSTEM : register(b0) {
  float4 clearColor : packoffset(c0);
  float2 resolution : packoffset(c1);
  float2 resolutionRev : packoffset(c1.z);
}

SamplerState colorSampler_s : register(s0);
Texture2D<float4> colorTexture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
              float4 v1 : TEXCOORD0,
                          out float4 o0 : SV_TARGET0
) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = resolutionRev.xy;
  r1.xyz = float3(0.298999995, 0.587000012, 0.114);
  // AA?
  r2.xyz = colorTexture.SampleLevel(colorSampler_s, v1.zw, 0).xyz;
  r2.xyz = r2.xyz;
  r3.xyz = colorTexture.SampleLevel(colorSampler_s, v1.zw, 0, int2(1, 0)).xyz;
  r3.xyz = r3.xyz;
  r4.xyz = colorTexture.SampleLevel(colorSampler_s, v1.zw, 0, int2(0, 1)).xyz;
  r4.xyz = r4.xyz;
  r5.xyz = colorTexture.SampleLevel(colorSampler_s, v1.zw, 0, int2(1, 1)).xyz;
  r5.xyz = r5.xyz;
  r6.xyzw = colorTexture.SampleLevel(colorSampler_s, v1.xy, 0).xyzw;
  const float4 inputColor = r6.rgba;

  r0.z = dot(r2.xyz, r1.xyz);
  r0.w = dot(r3.xyz, r1.xyz);
  r1.w = dot(r4.xyz, r1.xyz);
  r2.x = dot(r5.xyz, r1.xyz);
  r2.y = dot(r6.xyz, r1.xyz);
  r2.z = min(r0.z, r0.w);
  r2.w = min(r2.x, r1.w);
  r2.z = min(r2.z, r2.w);
  r2.z = min(r2.y, r2.z);
  r2.w = max(r0.z, r0.w);
  r3.x = max(r2.x, r1.w);
  r2.w = max(r3.x, r2.w);
  r2.y = max(r2.y, r2.w);
  r2.w = r2.x + r0.w;
  r3.x = r1.w + r0.z;
  r3.x = -r3.x;
  r2.w = r3.x + r2.w;
  r3.x = r2.x + r1.w;
  r3.y = r0.z + r0.w;
  r3.y = -r3.y;
  r3.x = r3.x + r3.y;
  r3.y = -r2.w;
  r3.x = r3.x;
  r0.z = r0.z + r0.w;
  r0.z = r0.z + r1.w;
  r0.z = r0.z + r2.x;
  r0.z = 0.03125 * r0.z;
  r0.z = max(0.0078125, r0.z);
  r0.w = -r3.x;
  r0.w = max(r3.x, r0.w);
  r1.w = -r3.y;
  r1.w = max(r3.y, r1.w);
  r0.w = min(r1.w, r0.w);
  r0.z = r0.w + r0.z;
  r0.z = 1 / r0.z;
  r0.zw = r3.xy * r0.zz;
  r0.zw = max(float2(-8, -8), r0.zw);
  r0.zw = min(float2(8, 8), r0.zw);
  r0.xy = r0.xy * r0.zw;
  r0.zw = v1.xy;
  r2.xw = float2(-0.166666672, -0.166666672) * r0.xy;
  r2.xw = r2.xw + r0.zw;
  r3.xyzw = colorTexture.SampleLevel(colorSampler_s, r2.xw, 0).xyzw;
  r2.xw = float2(0.166666672, 0.166666672) * r0.xy;
  r2.xw = r2.xw + r0.zw;
  r4.xyzw = colorTexture.SampleLevel(colorSampler_s, r2.xw, 0).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r3.xyzw = float4(0.5, 0.5, 0.5, 0.5) * r3.xyzw;
  r4.xyzw = float4(0.5, 0.5, 0.5, 0.5) * r3.xyzw;
  r2.xw = float2(-0.5, -0.5) * r0.xy;
  r2.xw = r2.xw + r0.zw;
  r5.xyzw = colorTexture.SampleLevel(colorSampler_s, r2.xw, 0).xyzw;
  r0.xy = float2(0.5, 0.5) * r0.xy;
  r0.xy = r0.zw + r0.xy;
  r0.xyzw = colorTexture.SampleLevel(colorSampler_s, r0.xy, 0).xyzw;
  r0.xyzw = r5.xyzw + r0.xyzw;
  r0.xyzw = float4(0.25, 0.25, 0.25, 0.25) * r0.xyzw;
  r0.xyzw = r4.xyzw + r0.xyzw;
  r1.x = dot(r0.xyz, r1.xyz);
  r1.y = cmp(r1.x >= r2.z);
  r1.y = r1.y ? 1 : 0;
  r1.x = cmp(r1.x >= r2.y);
  r1.x = r1.x ? 1 : 0;
  r1.x = -r1.x;
  r1.x = r1.y + r1.x;
  r1.y = -r1.x;
  r1.y = 1 + r1.y;
  r2.xyzw = r1.yyyy * r3.xyzw;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r1.xyzw = -r6.xyzw;
  r1.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = r1.xyzw * r0.wwww;
  r0.xyzw = r6.xyzw + r0.xyzw;
  o0.xyzw = r0.xyzw;
  // o0.rgb = inputColor;

  o0.a = inputColor.a;
  switch (injectedData.uiState) {
    default:
    case UI_STATE__NONE:
      break;
    case UI_STATE__DRAWING:
      o0.rgb = max(0, bt2020FromBT709(o0.rgb));
      break;
    case UI_STATE__MIN_ALPHA:
      o0.a = 1.f;
      break;
    case UI_STATE__MAX_ALPHA:
      o0.a = 0.f;
      break;
  }

  return;
}
