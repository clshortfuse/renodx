#include "./shared.h"
#include "./DICE.hlsl"

cbuffer cCommonTexParam : register(b0)
{
  float4 cCommonTexParam : packoffset(c0);
}

cbuffer cToneMapParam : register(b1)
{
  float4 cToneMapParam[2] : packoffset(c0);
}

SamplerState sInputS_s : register(s0);
SamplerState sToneMapS_s : register(s1);
Texture2D<float4> sInputT : register(t0);
Texture2D<float4> sToneMapT : register(t1);

// Restores the source color hue through Oklab (this works on colors beyond SDR in brightness and gamut too)
float3 RestoreHue(float3 targetColor, float3 sourceColor, float amount = 0.5)
{
  const float3 targetOklab = renodx::color::oklab::from::BT709(targetColor);
  const float3 targetOklch = renodx::color::oklch::from::OkLab(targetOklab);
  const float3 sourceOklab = renodx::color::oklab::from::BT709(sourceColor);

  // First correct both hue and chrominance at the same time (oklab a and b determine both, they are the color xy coordinates basically).
  // As long as we don't restore the hue to a 100% (which should be avoided), this will always work perfectly even if the source color is pure white (or black, any "hueless" and "chromaless" color).
  // This method also works on white source colors because the center of the oklab ab diagram is a "white hue", thus we'd simply blend towards white (but never flipping beyond it (e.g. from positive to negative coordinates)),
  // and then restore the original chrominance later (white still conserving the original hue direction).
  float3 correctedTargetOklab = float3(targetOklab.x, lerp(targetOklab.yz, sourceOklab.yz, amount));

  // Then restore chrominance
  float3 correctedTargetOklch = renodx::color::oklch::from::OkLab(correctedTargetOklab);
  correctedTargetOklch.y = targetOklch.y;

  return renodx::color::bt709::from::OkLCh(correctedTargetOklch);
}

float3 vanillaTonemapper(float3 color) {
  float colorLuminance = injectedData.toneMapType > 0 ? dot(color, float3(0.2126390059,0.7151686788,0.0721923154)) : dot(color, float3(0.298909992,0.586610019,0.114480004));  // fixed from vanilla's wrong BT.601 values
  float colorLuminanceTonemapped = cToneMapParam[0].z * colorLuminance; // some LUT exposure scaling
  float LUTCoordinate = lerp(cToneMapParam[1].x, cToneMapParam[1].y, saturate(colorLuminanceTonemapped)); // scale the LUT input range
  // This LUT can rebalance rgb colors by luminance (e.g. if they wanted to make bright colors more red, they could make the LUT return 1 0.5 0.5 for high input luminance coordinates).
  // This LUT is "relative" so it's ok to have its input coordinates clipped to 1.
  float3 LUTColorize = sToneMapT.Sample(sToneMapS_s, float2(LUTCoordinate, 0.5)).xyz;
  color *= LUTColorize;

  return color;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 outColor : SV_TARGET0)
{
  float4 r0 = sInputT.Sample(sInputS_s, v1.xy);

  float3 color = r0.rgb;
  outColor.w = r0.w;

  color *= cCommonTexParam.yyy;  // multiply in exposure

  if (injectedData.toneMapType == 0) {
    color = max(0, color);
  }

  // vanilla tonemapper
  color = color * color * sign(color);  // decode (linearize) with approximate gamma (2.0)
  color = vanillaTonemapper(color);
  color = sqrt(abs(color)) * sign(color); // re-encode (gammify) with approximate gamma (2.0)

  if (injectedData.toneMapType > 0) {
    // linearize
    color = renodx::math::SafePow(color, 2.2f);

    float3 sdrColor = saturate(color);

    if (injectedData.toneMapType > 1) {
      if (injectedData.toneMapType < 4) {  // ACES and RenoDRT
        // tonemap
        float vanillaMidGray = 0.18f;
        
        float renoDRTContrast = 1.f;
        float renoDRTFlare = 0.f;
        float renoDRTShadows = 1.f;
        float renoDRTDechroma = injectedData.colorGradeBlowout;
        float renoDRTSaturation = 1.f;
        float renoDRTHighlights = 1.f;
        float hueCorrectionType = renodx::tonemap::config::hue_correction_type::INPUT;
        float hueCorrectionStrength = 0.f;
        
        renodx::tonemap::Config config = renodx::tonemap::config::Create(
	      injectedData.toneMapType,
          injectedData.toneMapPeakNits,
          injectedData.toneMapGameNits,
          1,
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
          renoDRTFlare,
          hueCorrectionType,
          hueCorrectionStrength);
        color = renodx::tonemap::config::Apply(color, config);
      } else {  // DICE tonemapper
        // color grading
        color = renodx::color::grade::UserColorGrading(color, injectedData.colorGradeExposure, injectedData.colorGradeHighlights, injectedData.colorGradeShadows, injectedData.colorGradeContrast, injectedData.colorGradeSaturation, injectedData.colorGradeBlowout, 0.f);

        // tonemap
        DICESettings config = DefaultDICESettings();
        config.Type = 3;
        config.ShoulderStart = injectedData.diceShoulderStart;

        float dicePaperWhite = injectedData.toneMapGameNits / 80.f;
        float dicePeakWhite = injectedData.toneMapPeakNits / 80.f;
        color.rgb = DICETonemap(color.rgb * dicePaperWhite, dicePeakWhite, config) / dicePaperWhite;
      }

       color = RestoreHue(color, sdrColor, injectedData.hueCorrectionStrength);
    }

    // apply game paperwhite brightness with inverse UI brightness (ui brightness is re-applied in the final shader)
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;

    // convert to bt2020 for upscaling pass
    color = mul(renodx::color::BT709_TO_BT2020_MAT, color);

    // back to gamma space
    color = renodx::math::SafePow(color, 1.f / 2.2f);
  }

  outColor.rgb = color;

  return;
}