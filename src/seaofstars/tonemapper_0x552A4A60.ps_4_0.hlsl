#include "../common/ACES.hlsl"
#include "../common/Open_DRT.hlsl"
#include "../common/color.hlsl"
#include "../common/colorgrade.hlsl"
#include "../common/unity.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb0 : register(b0) {
  float4 cb0[204];
}

cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_Target0 {
  float4 r0, r1, r2, r3, r4, r5;

  const float4 inputColor = t0.Sample(s0_s, v1.xy).xyzw;
  const float4 bloomColor = t2.Sample(s0_s, v1.xy).xyzw;

  float4 testColor = bloomColor;

  r0.xyzw = inputColor;
  r1.xyzw = bloomColor;

  float3 scaledBloom = bloomColor.rgb;
  if (cb0[191].x > 0) {
    // Alpha blend
    scaledBloom.rgb *= 8.f * bloomColor.a;
  }
  scaledBloom.rgb *= cb0[190].x;    // Bloom strength
  scaledBloom.rgb *= cb0[190].yzw;  // Bloom color

  float3 untonemapped = inputColor.rgb + scaledBloom;
  r0.rgb = untonemapped;

  if (cb0[198].z > 0) {
    r1.xy = -cb0[198].xy + v1.xy;
    r1.yz = cb0[198].zz * abs(r1.xy);
    r1.x = cb0[197].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = pow(max(0, r0.w), cb0[198].w);
    r1.xyz = float3(1, 1, 1) + -cb0[197].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[197].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }

  const float ARRI_LOG_A = 5.555556f;  // 1/0.18
  const float ARRI_LOG_B = 0.047996f;
  const float ARRI_LOG_C = 0.244161f;
  const float ARRI_LOG_D = 0.386036f;

  r1.rgb = cb0[188].w * r0.brg;  // blue red green?
  r1.rgb = ARRI_LOG_A * r1.rgb + ARRI_LOG_B;
  r1.rgb = max(0, r1.rgb);
  r1.rgb = log2(r1.rgb);
  r1.rgb = saturate(r1.rgb * (ARRI_LOG_C * log10(2)) + ARRI_LOG_D);

  float3 scaleOffset = cb0[188].xyz;
  r1.rgb = ApplyLut2D(t3, s0_s, r1.gbr, scaleOffset);

  if (cb0[203].y == 0.f) {
    r0.w = cmp(0 < cb0[189].w);
    if (r0.w != 0) {
      r1.xyz = saturate(r1.xyz);
      r2.xyz = srgbFromLinear(r1.xyz);

      r3.xyz = cb0[189].zzz * r2.zxy;
      r0.w = floor(r3.x);
      r3.xw = float2(0.5, 0.5) * cb0[189].xy;
      r3.yz = r3.yz * cb0[189].xy + r3.xw;
      r3.x = r0.w * cb0[189].y + r3.y;
      r4.xyzw = t4.SampleLevel(s0_s, r3.xz, 0).xyzw;
      r5.x = cb0[189].y;
      r5.y = 0;
      r3.xy = r5.xy + r3.xz;
      r3.xyzw = t4.SampleLevel(s0_s, r3.xy, 0).xyzw;
      r0.w = r2.z * cb0[189].z + -r0.w;
      r3.xyz = r3.xyz + -r4.xyz;
      r3.xyz = r0.www * r3.xyz + r4.xyz;
      r3.xyz = r3.xyz + -r2.xyz;
      r2.xyz = cb0[189].www * r3.xyz + r2.xyz;

      r1.xyz = linearFromSRGB(r2.xyz);
    }
  }

  if (cb0[203].x < 1) {
    // Unstyled texture
    r2.xyzw = t1.SampleLevel(s1_s, v1.xy, 0).xyzw;
    r0.w = r2.w * 255 + 0.5;
    r0.w = (uint)r0.w;
    r0.w = (int)r0.w & 3;
    r0.w = cmp((int)r0.w != 1);
    r0.w = r0.w ? 1.000000 : 0;
    r1.w = 1 + -cb0[203].x;
    r0.w = r0.w * r1.w + cb0[203].x;
    r0.xyz = float3(-1.51571655, -1.51571655, -1.51571655) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = float3(1, 1, 1) + -r0.xyz;
    r2.xyz = r1.xyz + -r0.xyz;
    r1.xyz = r0.www * r2.xyz + r0.xyz;
  }

  float3 outputColor = r1.xyz;

  if (injectedData.toneMapType == 0) {
    outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    // noop
  } else {
    untonemapped = pow(max(0, untonemapped), 2.2f);
    if (injectedData.toneMapType == 1.f) {
      outputColor = untonemapped;  // Untonemapped
      outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    } else {
      float inputY = yFromBT709(untonemapped);
      float outputY = yFromBT709(outputColor);
      outputY = lerp(inputY, outputY, saturate(inputY));
      outputColor *= (outputY ? inputY / outputY : 1);

      if (injectedData.colorGradeSaturation != 1.f) {
        float3 okLCh = okLChFromBT709(outputColor);
        okLCh[1] *= injectedData.colorGradeSaturation;
        outputColor = max(0, bt709FromOKLCh(okLCh));
      }

      if (injectedData.colorGradeShadows != 1.f) {
        outputColor = apply_user_shadows(outputColor, injectedData.colorGradeShadows);
      }
      if (injectedData.colorGradeHighlights != 1.f) {
        outputColor = apply_user_highlights(outputColor, injectedData.colorGradeHighlights);
      }
      if (injectedData.colorGradeContrast != 1.f) {
        float3 workingColor = pow(outputColor / 0.18f, injectedData.colorGradeContrast) * 0.18f;
        // Working in BT709 still
        float workingColorY = yFromBT709(workingColor);
        float outputColorY = yFromBT709(outputColor);
        outputColor *= outputColorY ? workingColorY / outputColorY : 1.f;
      }
      if (injectedData.toneMapType == 2) {
        outputColor = aces_rrt_odt(
          outputColor * 203.f / 80.f,  // Should be midgray from LUT
          0.0001f,                     // minY
          48.f * (injectedData.toneMapPeakNits / injectedData.toneMapGameNits)
          // AP1_2_BT2020_MAT
        );
      } else {
        outputColor = apply_aces_highlights(outputColor);
        // outputColor = mul(BT709_2_BT2020_MAT, outputColor);
        outputColor = max(0, outputColor);
        outputColor = open_drt_transform(
          outputColor * 203.f / 80.f,  // Should be midgray from LUT
          100.f * (injectedData.toneMapPeakNits / injectedData.toneMapGameNits),
          0,
          1.f,
          0
        );
      }
      // outputColor = mul(BT2020_2_BT709_MAT, outputColor);
      outputColor *= injectedData.toneMapPeakNits / injectedData.toneMapUINits;
    }
  }

  return float4(outputColor.rgb, 1.f);
}
