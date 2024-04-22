#include "../../common/color.hlsl"
#include "../../common/filmgrain.hlsl"
#include "../../common/tonemap.hlsl"
#include "./shared.h"

// Composite/Render

cbuffer Buff2 : register(b2) {
  float ElapsedTime : packoffset(c12);  // Extracted
  float4 CameraParams : packoffset(c52);
  float4 DofParams : packoffset(c51);
  float4 ColorControlSettings : packoffset(c41);
  float3 ContrastColor : packoffset(c43);
  float3 SaturateCoeff : packoffset(c42);
  float3 ColorMask : packoffset(c44);
  float4 GrainSettings : packoffset(c46);
  float4 GrainSettings2 : packoffset(c53);
}

cbuffer Buff4 : register(b4) {
  float3 MotionBlurSettings_MODIFY_FIX : packoffset(c13);
}

cbuffer Buff5 : register(b5) {
  float4 BloomOffsetWeight0 : packoffset(c0);
  float4 BloomOffsetWeight1 : packoffset(c1);
  float4 BloomOffsetWeight2 : packoffset(c2);
}

cbuffer Buff6 : register(b6) {
  float3 ColorMask2 : packoffset(c10);
  float FacingRegisterFlip : packoffset(c14);
}

cbuffer HardCodedConstants : register(b12) {
  float4 g_SampleCoverageULLRegister : packoffset(c0);
  float4 PrimaryTexture_ULLRegister : packoffset(c1);
  float4 BlurTexture_ULLRegister : packoffset(c2);
  float4 LargeBlurTexture_ULLRegister : packoffset(c3);
  float4 BloomTexture_ULLRegister : packoffset(c4);
}

cbuffer DX11Internal : register(b13) {
  int ClipPlaneBits : packoffset(c0);
  float4 ClipPlanes[8] : packoffset(c1);
  int4 AlphaTest : packoffset(c9);
}

SamplerState PrimaryTexture_S_s : register(s0);
SamplerState BlurTexture_S_s : register(s1);
SamplerState LargeBlurTexture_S_s : register(s2);
SamplerState BloomTexture_S_s : register(s3);
SamplerState _RotatedPoissonTexture_Sampler_s : register(s8);
SamplerState GrainTexture_S_s : register(s13);
SamplerState BackBuffer_S_s : register(s14);
Texture2D<float4> PrimaryTexture_T : register(t0);
Texture2D<float4> BlurTexture_T : register(t1);
Texture2D<float4> LargeBlurTexture_T : register(t2);
Texture2D<float4> BloomTexture_T : register(t3);
Texture2D<float4> _RotatedPoissonTexture_Tex : register(t8);
Texture2D<float4> GrainTexture_T : register(t13);
Texture2D<float4> BackBuffer_T : register(t14);
Texture2D<float> RenderDepthBufferAsColour_T : register(t15);

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_Position0, float4 v1 : CLIP_SPACE_POSITION0, float4 v2 : SV_ClipDistance0, float4 v3 : SV_ClipDistance1, float4 v4 : TEXCOORD0, float2 v5 : TEXCOORD1) : SV_TARGET0 {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0.03125, 0.03125) * v0.xy;
  r0.xyzw = _RotatedPoissonTexture_Tex.Sample(_RotatedPoissonTexture_Sampler_s, r0.xy).xyzw;
  r0.xy = r0.xx * float2(1, -1) + float2(0, 1);
  r0.xy = -g_SampleCoverageULLRegister.xy + r0.xy;
  r0.xy = g_SampleCoverageULLRegister.zw * r0.xy;
  r0.x = r0.x + r0.y;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  RenderDepthBufferAsColour_T.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xyzw = fDest.xyzw;
  r0.xy = v4.xy * r0.xy;
  r0.xy = (int2)r0.xy;
  r0.zw = float2(0, 0);
  r0.x = RenderDepthBufferAsColour_T.Load(r0.xyz).x;
  r0.x = r0.x * CameraParams.y + CameraParams.w;
  r0.x = CameraParams.x / r0.x;
  r0.yz = -DofParams.yx + r0.xx;
  r0.yz = saturate(DofParams.zw * r0.yz);
  r1.xyzw = PrimaryTexture_T.Sample(PrimaryTexture_S_s, v4.xy).xyzw;

  float4 primaryTextureInput = r1.xyzw;

  r2.xyzw = BlurTexture_T.Sample(BlurTexture_S_s, v4.xy).xyzw;

  float4 blurTextureInput = r2.xyzw;

  r3.xyzw = LargeBlurTexture_T.Sample(LargeBlurTexture_S_s, v4.xy).xyzw;

  float4 largeBlurTextureInput = r3.xyzw;

  // r4.xyzw = -r2.xyzw + r1.xyzw;
  // r2.xyzw = r0.yyyy * r4.xyzw + r2.xyzw;
  r2 = lerp(blurTextureInput, primaryTextureInput, r0.y);

  // r2.xyzw = r2.xyzw - r3.xyzw;
  // r2.xyzw = r0.zzzz * r2.xyzw + r3.xyzw;
  r2 = lerp(largeBlurTextureInput, r2, r0.z);

  float4 blurredTexture = r2;

  r2 = lerp(primaryTextureInput, blurredTexture, injectedData.fxDoF);

  // r0.x = cmp(GrainSettings.y < r0.x);
  // r0.xyzw = r0.xxxx ? r1.xyzw : r2.xyzw;

  r0.xyzw = (r0.x >= GrainSettings.y) ? primaryTextureInput : blurredTexture;

  r1.x = cmp((int)AlphaTest.x == 1);
  if (r1.x != 0) {
    r1.x = (int)AlphaTest.z;
    r1.x = 0.00392156886 * r1.x;
    r1.y = cmp((int)AlphaTest.y == 5);
    if (r1.y != 0) {
      r1.y = cmp(r1.x >= r0.w);
      if (r1.y != 0) discard;
    } else {
      r1.y = cmp((int)AlphaTest.y == 7);
      if (r1.y != 0) {
        r1.y = cmp(r0.w < r1.x);
        if (r1.y != 0) discard;
      } else {
        r1.y = cmp((int)AlphaTest.y == 4);
        if (r1.y != 0) {
          r1.y = cmp(r1.x < r0.w);
          if (r1.y != 0) discard;
        } else {
          r1.y = cmp((int)AlphaTest.y == 1);
          if (r1.y != 0) {
            if (-1 != 0) discard;
          } else {
            r1.yzw = cmp((int3)AlphaTest.yyy == int3(2, 3, 6));
            r2.x = cmp(r0.w >= r1.x);
            r2.x = r1.y ? r2.x : 0;
            if (r2.x != 0) discard;
            r2.xy = ~(int2)r1.yz;
            r1.y = r1.z ? r2.x : 0;
            r1.z = cmp(r0.w != r1.x);
            r1.y = r1.z ? r1.y : 0;
            if (r1.y != 0) discard;
            r1.y = r2.x ? r2.y : 0;
            r1.y = r1.w ? r1.y : 0;
            r1.x = cmp(r0.w == r1.x);
            r1.x = r1.x ? r1.y : 0;
            if (r1.x != 0) discard;
          }
        }
      }
    }
  }
  r1.xyzw = BloomTexture_T.Sample(BloomTexture_S_s, v4.xy).xyzw;

  float4 bloomTextureInput = r1.xyzw;

  float3 unbloomed = r0.xyz;
  r1.xyz = r1.xyz * injectedData.fxBloom + r0.xyz;
  float3 unfilteredColor = r1.xyz;

  // r0.x = saturate(dot(BloomOffsetWeight0.xyzw, r1.xyzw));
  // r0.y = saturate(dot(BloomOffsetWeight1.xyzw, r1.xyzw));
  // r0.z = saturate(dot(BloomOffsetWeight2.xyzw, r1.xyzw));

  r1.w = 1;

  float3 finalFrame;
  if (injectedData.toneMapType == 0) {
    if (
      injectedData.fxBlackWhite != 0
      && !any(BloomOffsetWeight0.xyzw - BloomOffsetWeight1.xyzw)
      && !any(BloomOffsetWeight0.xyzw - BloomOffsetWeight2.xyzw)
      && !any(BloomOffsetWeight0.xyz - BloomOffsetWeight1.zxy)
      && !any(BloomOffsetWeight0.xyz - BloomOffsetWeight2.yzx)
    ) {
      r0.xyz *= BloomOffsetWeight0.x * 3.f;
      r0.xyz = saturate(r0.xyz);

      r1.xy = GrainSettings2.zw * v4.zw + GrainSettings2.xy;
      r1.xyzw = GrainTexture_T.Sample(GrainTexture_S_s, r1.xy).xyzw;

      r1.xyz = r0.xyz * r1.y - r0.xyz;
      r0.xyz = GrainSettings.x * injectedData.fxFilmGrain * r1.xyz + r0.xyz;

      r1.xyz = lerp(ColorMask.xyz, ColorMask2.xyz, v4.w);
      r2.xyz = lerp(r0.xyz, r0.xyz * r1.xyz, injectedData.fxMask);
      r2.rgb = injectedData.toneMapGammaCorrection ? pow(r2.rgb, 2.2f) : linearFromSRGB(r2.rgb);

      if (injectedData.fxBlackWhite == 1.f) {
        r2.rgb = lerp(r2.rgb, yFromBT709(r2.rgb).xxx, injectedData.colorGradeColorFilter);
      } else {
        r2.rgb = applySaturation(r2.rgb, 1.f - injectedData.colorGradeColorFilter);
      }
      finalFrame = r2.rgb;
    } else {
      r0.x = (dot(BloomOffsetWeight0.xyzw, r1.xyzw));
      r0.y = (dot(BloomOffsetWeight1.xyzw, r1.xyzw));
      r0.z = (dot(BloomOffsetWeight2.xyzw, r1.xyzw));
      r0.xyz = saturate(r0.xyz);
      r0.xyz = lerp(unfilteredColor, r0.xyz, injectedData.colorGradeColorFilter);

      r1.xy = GrainSettings2.zw * v4.zw + GrainSettings2.xy;
      r1.xyzw = GrainTexture_T.Sample(GrainTexture_S_s, r1.xy).xyzw;

      r1.xyz = r0.xyz * r1.y - r0.xyz;
      r0.xyz = GrainSettings.x * injectedData.fxFilmGrain * r1.xyz + r0.xyz;

      r1.xyz = lerp(ColorMask.xyz, ColorMask2.xyz, v4.w);
      r2.xyz = lerp(r0.xyz, r0.xyz * r1.xyz, injectedData.fxMask);
      finalFrame = injectedData.toneMapGammaCorrection ? pow(r2.rgb, 2.2f) : linearFromSRGB(r2.rgb);
    }

  } else {
    float vanillaMidGray = 0.18f;
    float renoDRTHighlights = 1.0f;
    float renoDRTShadows = 1.f;
    float renoDRTContrast = 1.0f;
    float renoDRTSaturation = 1.0f;
    float renoDRTDechroma = 0.5f;
    float renoDRTFlare = 0.f;
    ToneMapParams tmParams = {
      injectedData.toneMapType,
      injectedData.toneMapPeakNits,
      injectedData.toneMapGameNits,
      0,  // Gamma Correction not used here
      injectedData.colorGradeExposure,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeShadows,
      injectedData.colorGradeContrast,
      injectedData.colorGradeSaturation,
      vanillaMidGray,
      vanillaMidGray * 100.f,
      renoDRTHighlights,
      renoDRTShadows,
      renoDRTContrast,
      renoDRTSaturation,
      renoDRTDechroma,
      renoDRTFlare
    };
    if (injectedData.colorGradeColorFilter) {
      float3 outputColor = injectedData.toneMapGammaCorrection
                           ? pow(max(0, unfilteredColor), 2.2f)
                           : linearFromSRGB(max(0, unfilteredColor));

      outputColor = applyUserColorGrading(
        outputColor,
        tmParams.exposure,
        tmParams.highlights,
        tmParams.shadows,
        tmParams.contrast,
        tmParams.saturation
      );
      float3 hdrColor = outputColor;
      float3 sdrColor = outputColor;
      if (tmParams.type == 2.f) {
        hdrColor = acesToneMap(outputColor, tmParams);
        sdrColor = acesToneMap(outputColor, tmParams, true);
      } else if (tmParams.type == 3.f) {
        hdrColor = renoDRTToneMap(outputColor, tmParams);
        sdrColor = renoDRTToneMap(outputColor, tmParams, true);
      }

      r1.xyz = injectedData.toneMapGammaCorrection
               ? pow(saturate(sdrColor), 1.f / 2.2f)
               : srgbFromLinear(saturate(sdrColor));
      if (
        injectedData.fxBlackWhite
        && !any(BloomOffsetWeight0.xyzw - BloomOffsetWeight1.xyzw)
        && !any(BloomOffsetWeight0.xyzw - BloomOffsetWeight2.xyzw)
        && !any(BloomOffsetWeight0.xyz - BloomOffsetWeight1.zxy)
        && !any(BloomOffsetWeight0.xyz - BloomOffsetWeight2.yzx)
      ) {
        r0.xyz = r1.xyz * BloomOffsetWeight0.x * 3.f;
        r1.xyz = lerp(ColorMask.xyz, ColorMask2.xyz, v4.w);
        r2.xyz = lerp(r0.xyz, r0.xyz * r1.xyz, injectedData.fxMask);
        r2.rgb = injectedData.toneMapGammaCorrection
                 ? pow(saturate(r2.rgb), 2.2f)
                 : linearFromSRGB(saturate(r2.rgb));

        if (injectedData.fxBlackWhite == 1.f) {
          r2.rgb = lerp(r2.rgb, yFromBT709(r2.rgb).xxx, injectedData.colorGradeColorFilter);
        } else {
          r2.rgb = applySaturation(r2.rgb, 1.f - injectedData.colorGradeColorFilter);
        }
      } else {
        r0.x = (dot(BloomOffsetWeight0.xyzw, r1.xyzw));
        r0.y = (dot(BloomOffsetWeight1.xyzw, r1.xyzw));
        r0.z = (dot(BloomOffsetWeight2.xyzw, r1.xyzw));
        r1.xyz = lerp(ColorMask.xyz, ColorMask2.xyz, v4.w);
        r2.xyz = lerp(r0.xyz, r0.xyz * r1.xyz, injectedData.fxMask);
        r2.rgb = injectedData.toneMapGammaCorrection
                 ? pow(saturate(r2.rgb), 2.2f)
                 : linearFromSRGB(saturate(r2.rgb));
      }

      float3 lutColor = r2;

      outputColor = toneMapUpgrade(hdrColor, sdrColor, lutColor, injectedData.colorGradeColorFilter);
      if (tmParams.saturation != 1.f) {
        outputColor = applySaturation(outputColor, tmParams.saturation);
      }
      finalFrame = outputColor;
    } else {
      r0.rgb = unfilteredColor.rgb;
      r1.xyz = lerp(ColorMask.xyz, ColorMask2.xyz, v4.w);
      r2.xyz = lerp(r0.xyz, r0.xyz * r1.xyz, injectedData.fxMask);
      float3 outputColor = injectedData.toneMapGammaCorrection
                           ? pow(max(0, r2.rgb), 2.2f)
                           : linearFromSRGB(max(0, r2.rgb));
      finalFrame = toneMap(outputColor, tmParams);
    }
  }

  r3.xy = v4.xy * float2(2, 2) + float2(-1, -1);
  r1.w = dot(r3.xy, r3.xy);
  r1.w = min(1, r1.w);
  r1.w = max(MotionBlurSettings_MODIFY_FIX.y, r1.w);
  r1.w = MotionBlurSettings_MODIFY_FIX.x * r1.w;

  r3.xyzw = BackBuffer_T.Sample(BackBuffer_S_s, v4.xy).xyzw;

  float3 previousFrame = r3.rgb;

  // r0.xyz = -r0.xyz * r1.xyz + r3.xyz;
  // o0.xyz = r1.www * r0.xyz + r2.xyz;
  // o0.w = r0.w;

  if (injectedData.toneMapType) {
    if (injectedData.fxFilmGrain) {
      float3 grainedColor = computeFilmGrain(
        finalFrame,
        v4.xy,
        frac(ElapsedTime),
        injectedData.fxFilmGrain * 0.03f,
        1.f
      );
      finalFrame = grainedColor;
    }
  }

  previousFrame /= injectedData.toneMapGameNits / 80.f;

  float3 blendedFrame = lerp(finalFrame, previousFrame, r1.w * injectedData.fxMotionBlur);

  float3 outputColor = blendedFrame * injectedData.toneMapGameNits;
  outputColor = min(outputColor, injectedData.toneMapPeakNits);
  outputColor /= 80.f;

  float alpha = injectedData.toneMapGammaCorrection
                ? pow(r0.w, 2.2f)
                : linearFromSRGB(r0.w);
  return float4(outputColor.rgb, alpha);
}
