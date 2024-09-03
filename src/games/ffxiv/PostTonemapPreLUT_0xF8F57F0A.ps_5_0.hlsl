#include "./shared.h"
#include "./DICE.hlsl"

SamplerState sInputS_s : register(s0);
Texture2D<float4> sInputT : register(t0);


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

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 outColor : SV_TARGET0)
{
  float4 r0;

  r0.xyzw = sInputT.Sample(sInputS_s, v1.xy).xyzw;
  float3 color = r0.xyz;

  if (injectedData.toneMapType > 0) {
    // linearize
    color = renodx::math::SafePow(color, 2.2f);

    float3 sdrColor = saturate(color);

    if (injectedData.toneMapType > 1) {
      if (injectedData.toneMapType < 4) {  // ACES and RenoDRT
        // tonemap                
        renodx::tonemap::Config config= renodx::tonemap::config::Create();
        config.type = injectedData.toneMapType;
        config.peak_nits = injectedData.toneMapPeakNits;
        config.game_nits = injectedData.toneMapGameNits;
        config.exposure = injectedData.colorGradeExposure;
        config.highlights = injectedData.colorGradeHighlights;
        config.shadows = injectedData.colorGradeShadows;
        config.contrast = injectedData.colorGradeContrast;
        config.saturation = injectedData.colorGradeSaturation;
        config.reno_drt_dechroma = injectedData.colorGradeBlowout;
        config.hue_correction_strength = 0.f;
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

    // convert to bt2020 for upscaling pass
    color = mul(renodx::color::BT709_TO_BT2020_MAT, color);

    // back to gamma space
    color = renodx::math::SafePow(color, 1.f / 2.2f);
  }

  r0.xyz = color;
  
  outColor.xyzw = injectedData.toneMapType == 0 ? saturate(r0.xyzw) : r0.xyzw;
  
  return;
}