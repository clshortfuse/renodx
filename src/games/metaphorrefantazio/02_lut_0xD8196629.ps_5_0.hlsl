// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 26 18:26:54 2024
#include "./shared.h"
#include "./tonemapper.hlsl"

cbuffer GFD_PSCONST_SYSTEM : register(b0) {
  float2 resolution : packoffset(c0);
  float2 resolutionRev : packoffset(c0.z);
  float4x4 mtxView : packoffset(c1);
  float4x4 mtxInvView : packoffset(c5);
  float4x4 mtxProj : packoffset(c9);
  float4x4 mtxInvProj : packoffset(c13);
  float4 invProjParams : packoffset(c17);
}

cbuffer GFD_PSCONST_LUT : register(b11) { float weight : packoffset(c0); }

SamplerState pointClampSampler_s : register(s0);
Texture2D<float4> texture0 : register(t0);
Texture2D<float4> LUTTexture : register(t1);
Texture2D<float4> gbuffer1Texture : register(t2);

// 3Dmigoto declarations
#define cmp -

/* Just loading this shader clamps colors to BT709, no idea why */
void main(float4 v0
          : SV_POSITION0, float2 v1
          : TEXCOORD0, out float4 o0
          : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 untonemapped, tonemapped, outputColor, vanilla;

  r0.xyzw = texture0.Sample(pointClampSampler_s, v1.xy).xyzw;
  untonemapped = r0.rgb;

  r1.xy = resolution.xy * v1.xy;
  r1.xy = (int2)r1.xy;
  r1.zw = float2(0, 0);
  r1.x = gbuffer1Texture.Load(r1.xyz).w;
  r1.x = 255 * r1.x;
  r1.x = (uint)r1.x;
  r1.x = (int)r1.x & 16;

  // Condition decides if LUT should be applied (background env)
  if (r1.x == 0) {
    // We run original code for vanilla
    if (injectedData.toneMapType == 0.f) {
      // 1/2.2 so linear => gamma space
      /* r1.xyz = log2(abs(r0.xyz));
      r1.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r1.xyz;
      r1.xyz = exp2(r1.xyz); */
      r1.rgb = renodx::color::gamma::EncodeSafe(r0.rgb);

      r1.xyz = min(float3(1, 1, 1), r1.xyz);
      r1.yzw = r1.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
      r1.w = r1.w * 32 + -0.5;
      r2.x = floor(r1.w);
      r1.w = -r2.x + r1.w;
      r1.y = r2.x + r1.y;
      r1.x = 0.03125 * r1.y;
      r2.xyz = LUTTexture.Sample(pointClampSampler_s, r1.xz).xyz;
      r1.xy = float2(0.03125, 0) + r1.xz;
      r1.xyz = LUTTexture.Sample(pointClampSampler_s, r1.xy).xyz;
      r1.xyz = r1.xyz + -r2.xyz;
      r1.xyz = r1.www * r1.xyz + r2.xyz;

      // gamma space => linear
      /* r1.xyz = log2(abs(r1.xyz));
      r1.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r1.xyz;
      r1.xyz = exp2(r1.xyz); */
      r1.rgb = renodx::color::gamma::DecodeSafe(r1.rgb);
      vanilla = r1.rgb;

      // will be done after
      /* r1.xyz = r1.xyz * float3(1.04999995, 1.04999995, 1.04999995) + -r0.xyz;
      r0.xyz = weight * r1.xyz + r0.xyz; */
    } else {
      // We run this code for others
      // We restore color so LUT doesn't scale too
      tonemapped = restoreLuminance(untonemapped);
      tonemapped = applyLUT(untonemapped, pointClampSampler_s, LUTTexture);
      tonemapped = scaleLuminance(tonemapped);
    }
  } else {
    if (injectedData.toneMapType == 0.f) {
      vanilla = untonemapped;
    } else {
      tonemapped = untonemapped;
    }
  }

  if (injectedData.toneMapType == 0.f) {
    outputColor = vanilla;
  } else {
    outputColor = tonemapped;
  }
  // o0.xyzw = r0.xyzw;

  outputColor.rgb =
      outputColor.rgb * float3(1.04999995, 1.04999995, 1.04999995) + -untonemapped.xyz;
  outputColor.rgb = weight * outputColor.xyz + untonemapped.xyz;

  o0.rgb = outputColor.rgb;
  o0.w = 1;

  return;
}
