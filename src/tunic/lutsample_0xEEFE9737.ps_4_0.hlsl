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
  
  r0.xyz = saturate(untonemapped);
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

  // float3 standardSample = sampleLUT(t1, s1_s, saturate(untonemapped.rgb));
  
  // o0.rgb = lerp(untonemapped, o0.rgb, injectedData.colorGradeLUTStrength);

  float3 outputColor = max(0, o0.rgb);  // Game apparently goes negative

  outputColor = lerp(untonemapped, outputColor, injectedData.colorGradeLUTStrength);

  outputColor = pow(outputColor, 2.2f);  // Now in linear

  if (injectedData.processingLUTCorrection) {
    float3 lutMin = t1.SampleLevel(s1_s, float(0.f).xxx, 0.0f).rgb;
    float3 lutMax = t1.SampleLevel(s1_s, float(1.f).xxx, 0.0f).rgb;
    lutMin = pow(lutMin, 2.2f);
    lutMax = pow(lutMax, 2.2f);

    const float lutMinY = yFromBT709(lutMin);
    const float lutMaxY = yFromBT709(lutMax);
    const float targetPeakY = 1;

    // Only applies on LUTs that are clamped (all?)
    if (lutMinY > 0) {
      outputColor = lutCorrectionBlack(untonemapped, outputColor, lutMinY, injectedData.processingLUTCorrection);
    }

    if (lutMaxY < targetPeakY) {
      outputColor = lutCorrectionWhite(untonemapped, outputColor, lutMaxY, targetPeakY, injectedData.processingLUTCorrection);
    }
  }

  if (injectedData.toneMapType == 0) {
    // outputColor *= injectedData.toneMapGameNits / 80.f;
    // noop
  } else {
    untonemapped = pow(max(0, untonemapped), 2.2f);
    if (injectedData.toneMapType == 1.f) {
      outputColor = untonemapped;  // Untonemapped
      // outputColor *= injectedData.toneMapGameNits / 80.f;
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
      outputColor *= injectedData.toneMapPeakNits / 203.f;
    }
    // Send as 2.2 numbers
  }
  outputColor = pow(max(0, outputColor), 1.f / 2.2f);

  o0.rgb = outputColor.rgb;
  return;
}
