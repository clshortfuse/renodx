// Game Render + LUT

#include "../common/Open_DRT.hlsl"
#include "../common/aces.hlsl"
#include "../common/color.hlsl"
#include "../common/colorgrade.hlsl"
#include "../common/lut.hlsl"
#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[7];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
              float4 v1 : TEXCOORD0,
                          float4 v2 : TEXCOORD1,
                                      float4 v3 : TEXCOORD2,
                                                  out float4 o0 : SV_Target0
) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  o0.w = r0.w;

  r0.xyz = cb0[6].yyy * r0.xyz;  // scale
  float3 untonemapped = r0.rgb;

  float3 lutInputColor = saturate(untonemapped);
  r0.xyz = lutInputColor;
  r0.w = 31 * r0.z;
  r0.xyz = r0.xyz * float3(0.0302734375, 0.96875, 31) + float3(0.00048828125, 0.015625, 0);
  r0.w = frac(r0.w);
  r0.z = r0.z + -r0.w;
  r0.xy = r0.zz * float2(0.03125, 0) + r0.xy;
  r1.xy = float2(0.03125, 0) + r0.xy;
  r2.xyzw = t1.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r1.xyzw = t1.SampleLevel(s1_s, r1.xy, 0).xyzw;
  r0.xyz = r1.xyz + -r2.xyz;
  o0.xyz = r0.www * r0.xyz + r2.xyz;

  float3 outputColor = max(0, o0.rgb);
  float3 midGrayGamma = 0.5f;

  if (injectedData.processingLUTScaling) {
    midGrayGamma = t1.SampleLevel(s1_s, float(0.5f).xxx, 0.0f).rgb;
    float3 unclamped = unclampSDRLUT(
      outputColor,
      t1.SampleLevel(s1_s, float(0.f).xxx, 0.0f).rgb,
      t1.SampleLevel(s1_s, float(1.f).xxx, 0.0f).rgb,
      midGrayGamma,
      lutInputColor
    );

    outputColor = pow(outputColor, 2.2f);
    float3 recolored = recolorUnclampedLUT(
      outputColor,
      sign(unclamped) * pow(abs(unclamped), 2.2f)
    );
    outputColor = lerp(outputColor, recolored, injectedData.processingLUTScaling);
  } else {
    outputColor = pow(outputColor, 2.2f);
  }

  untonemapped = pow(max(0, untonemapped), 2.2f);

  outputColor = lerp(untonemapped, outputColor, injectedData.colorGradeLUTStrength);

  if (injectedData.toneMapType == 0) {
    // outputColor *= injectedData.toneMapGameNits / 80.f;
    // noop
  } else {
    if (injectedData.toneMapType == 1.f) {
      outputColor = untonemapped;  // Untonemapped
      // outputColor *= injectedData.toneMapGameNits / 80.f;
    } else {
      float luttedColor = outputColor;

      float inputY = yFromBT709(untonemapped);
      float outputY = yFromBT709(outputColor);
      outputY = lerp(inputY, outputY, saturate(inputY));
      outputColor *= (outputY ? inputY / outputY : 1);

      outputColor = applyUserColorGrading(
        outputColor,
        1.f,
        injectedData.colorGradeSaturation,
        injectedData.colorGradeShadows,
        injectedData.colorGradeHighlights,
        injectedData.colorGradeContrast
      );

      float vanillaMidGray = pow(midGrayGamma, 2.2f);
      if (injectedData.toneMapType == 2.f) {
        const float ACES_MID_GRAY = 0.10f;
        float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / ACES_MID_GRAY);
        float hdrScale = (injectedData.toneMapPeakNits / paperWhite);
        outputColor = aces_rgc_rrt_odt(
          outputColor,
          0.0001f / (paperWhite / 48.f),
          48.f * hdrScale
        );
        outputColor /= 48.f;
        outputColor *= (vanillaMidGray / ACES_MID_GRAY);

      } else if (injectedData.toneMapType == 3.f) {
        const float OPENDRT_MID_GRAY = 11.696f / 100.f;
        float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / OPENDRT_MID_GRAY);
        float hdrScale = (injectedData.toneMapPeakNits / paperWhite);
        outputColor = mul(BT709_2_DISPLAYP3_MAT, outputColor);
        outputColor = max(0, outputColor);
        outputColor = open_drt_transform_bt709(
          outputColor,
          100.f * hdrScale,
          0,
          1.f,
          0
        );
        outputColor = mul(DISPLAYP3_2_BT709_MAT, outputColor);
        outputColor *= hdrScale;
        outputColor *= (vanillaMidGray / OPENDRT_MID_GRAY);
      }
      // outputColor = mul(BT2020_2_BT709_MAT, outputColor);
      outputColor *= injectedData.toneMapGameNits / 203.f;
    }
    // Send as 2.2 numbers
  }
  outputColor = sign(outputColor) * pow(abs(outputColor), 1.f / 2.2f);

  o0.rgb = outputColor.rgb;
  return;
}
