#include "../shared.h"
#include "../LumaIncludes.hlsli"

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  const float y_in = max(0, renodx::color::y::from::BT709(incorrect_color));
  const float y_out = renodx::color::correct::Gamma(y_in);

  float3 lum = renodx::color::correct::Luminance(incorrect_color, y_in, y_out);

  // use chrominance from per channel gamma correction
  float3 result = renodx::color::correct::ChrominanceOKLab(lum, ch, 1.f, 1.f);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}

bool GenerateOutput(float r, float g, float b, inout float4 SV_Target, uint device) {
  if (RENODX_TONE_MAP_TYPE == 0 || device == 8u) return false;

  float3 final_color = (float3(r, g, b));
  if (RENODX_TONE_MAP_TYPE == 4.f) final_color = saturate(final_color);

  final_color = ApplyGammaCorrection(final_color);

  float3 bt2020_color = renodx::color::bt2020::from::BT709(final_color);
  float3 encoded_color = renodx::color::pq::EncodeSafe(bt2020_color, RENODX_DIFFUSE_WHITE_NITS);

  SV_Target = float4(encoded_color / 1.05f, 0.f);
  return true;
}

float3 ColorCorrect(float3 WorkingColor,
  float4 ColorSaturation,
  float4 ColorContrast,
  float4 ColorGamma,
  float4 ColorGain,
  float4 ColorOffset)
{
    float Luma = renodx::color::y::from::AP1(WorkingColor);
    WorkingColor = max(0, lerp(Luma.xxx, WorkingColor, ColorSaturation.xyz * ColorSaturation.w));
    WorkingColor = pow(WorkingColor * (1.0 / 0.18), ColorContrast.xyz * ColorContrast.w) * 0.18;
    WorkingColor = pow(WorkingColor, 1.0 / (ColorGamma.xyz * ColorGamma.w));
    if (SHADOW_COLOR_OFFSET_FIX_TYPE == 1) {
      WorkingColor = renodx::color::ap1::from::BT709(FixColorFade(renodx::color::bt709::from::AP1(WorkingColor * (ColorGain.xyz * ColorGain.w)), renodx::color::bt709::from::AP1(ColorOffset.xyz + ColorOffset.w)));  // pumbo haze fix
    } else {
      WorkingColor = WorkingColor * (ColorGain.xyz * ColorGain.w) + (ColorOffset.xyz + ColorOffset.w);  // original code
    }
    
    return WorkingColor;
}

float3 ColorCorrectShadows(float3 WorkingColor,
  float4 ColorSaturationTonal,
  float4 ColorSaturation,
  float4 ColorContrastTonal,
  float4 ColorContrast,
  float4 ColorGammaTonal,
  float4 ColorGamma,
  float4 ColorGainTonal,
  float4 ColorGain,
  float4 ColorOffsetTonal,
  float4 ColorOffset)
{
    ColorOffset = ColorOffsetTonal + ColorOffset;
    ColorSaturation = ColorSaturationTonal * ColorSaturation;
    if (SHADOW_COLOR_OFFSET_FIX_TYPE == 0) {
      ColorContrast = ColorContrastTonal * ColorContrast;
    } else {
      float4 ShadowContrastOffset = saturate(ColorOffset * SHADOW_COLOR_OFFSET_FIX_CONTRAST_OFFSET) * -1.f;
      ColorContrast = (ColorContrastTonal + ShadowContrastOffset) * ColorContrast;
    }
    ColorGamma = ColorGammaTonal * ColorGamma;
    ColorGain = ColorGainTonal * ColorGain;

    float Luma = renodx::color::y::from::AP1(WorkingColor);
    WorkingColor = max(0, lerp(Luma.xxx, WorkingColor, ColorSaturation.xyz * ColorSaturation.w));
    WorkingColor = pow(WorkingColor * (1.0 / 0.18), ColorContrast.xyz * ColorContrast.w) * 0.18;
    WorkingColor = pow(WorkingColor, 1.0 / (ColorGamma.xyz * ColorGamma.w));
    if (SHADOW_COLOR_OFFSET_FIX_TYPE == 2) {
      WorkingColor = renodx::color::ap1::from::BT709(FixColorFade(renodx::color::bt709::from::AP1(WorkingColor * (ColorGain.xyz * ColorGain.w)), renodx::color::bt709::from::AP1(ColorOffset.xyz + ColorOffset.w)));  // pumbo haze fix
    } else {
      if (SHADOW_COLOR_OFFSET_FIX_TYPE == 1) {
        ColorOffset = 0;
      }
      WorkingColor = WorkingColor * (ColorGain.xyz * ColorGain.w) + (ColorOffset.xyz + ColorOffset.w);  // original code
    }
    
    return WorkingColor;
}

float3 ColorCorrectAll(float3 WorkingColor,
  float4 ColorSaturation,
  float4 ColorContrast,
  float4 ColorGamma,
  float4 ColorGain,
  float4 ColorOffset,
  float4 ColorSaturationShadows,
  float4 ColorContrastShadows,
  float4 ColorGammaShadows,
  float4 ColorGainShadows,
  float4 ColorOffsetShadows,
  float4 ColorSaturationHighlights,
  float4 ColorContrastHighlights,
  float4 ColorGammaHighlights,
  float4 ColorGainHighlights,
  float4 ColorOffsetHighlights,
  float4 ColorSaturationMidtones,
  float4 ColorContrastMidtones,
  float4 ColorGammaMidtones,
  float4 ColorGainMidtones,
  float4 ColorOffsetMidtones,
  float CCWeightShadows,
  float CCWeightHighlights,
  float CCWeightMidtones)
{
  float3 CCColorShadows = ColorCorrectShadows(WorkingColor,
    ColorSaturationShadows, ColorSaturation,
    ColorContrastShadows, ColorContrast,
    ColorGammaShadows, ColorGamma,
    ColorGainShadows, ColorGain,
    ColorOffsetShadows, ColorOffset);
  
  float3 CCColorHighlights = ColorCorrect(WorkingColor,
    ColorSaturationHighlights * ColorSaturation,
    ColorContrastHighlights * ColorContrast,
    ColorGammaHighlights * ColorGamma,
    ColorGainHighlights * ColorGain,
    ColorOffsetHighlights + ColorOffset);

  float3 CCColorMidtones = ColorCorrect(WorkingColor,
    ColorSaturationMidtones * ColorSaturation,
    ColorContrastMidtones * ColorContrast,
    ColorGammaMidtones * ColorGamma,
    ColorGainMidtones * ColorGain,
    ColorOffsetMidtones + ColorOffset);
  
  WorkingColor = CCColorShadows * CCWeightShadows + CCColorMidtones * CCWeightMidtones + CCColorHighlights * CCWeightHighlights;

  return WorkingColor;
}
