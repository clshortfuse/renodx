#include "../shared.h"
#include "./CBuffers/CBuffers_LUTbuilder.hlsli"
#include "./colorcorrection.hlsli"

// From Pumbo
// This basically does gamut mapping, however it's not focused on gamut as primaries, but on peak white.
// The color is expected to be in the specified color space and in linear.
//
// The sum of "DesaturationAmount" and "DarkeningAmount" needs to be <= 1, both within 0 and 1.
// The closer the sum is to 1, the more each color channel will be contained within its peak range.
float3 CorrectOutOfRangeColor(float3 Color, bool FixNegatives = true, bool FixPositives = true, float Peak = 1.0, float DesaturationAmount = 0.5, float DarkeningAmount = 0.5, bool use_bt2020 = true) {
  if (FixNegatives && any(Color < 0.0))  // Optional "optimization" branch
  {
    float colorLuminance = use_bt2020 ? renodx::color::y::from::BT2020(Color) : renodx::color::y::from::BT709(Color);

    float3 positiveColor = max(Color.xyz, 0.0);
    float3 negativeColor = min(Color.xyz, 0.0);
    float positiveLuminance = use_bt2020 ? renodx::color::y::from::BT2020(positiveColor) : renodx::color::y::from::BT709(positiveColor);
    float negativeLuminance = use_bt2020 ? renodx::color::y::from::BT2020(negativeColor) : renodx::color::y::from::BT709(negativeColor);
    // Desaturate until we are not out of gamut anymore
    if (colorLuminance > renodx::math::FLT32_MIN) {
#if 0
	  float negativePositiveLuminanceRatio = -negativeLuminance / positiveLuminance;
	  float3 positiveColorRestoredLuminance = RestoreLuminance(positiveColor, colorLuminance, true, ColorSpace);
	  Color = lerp(lerp(Color, positiveColorRestoredLuminance, sqrt(DesaturationAmount)), colorLuminance, negativePositiveLuminanceRatio * sqrt(DesaturationAmount));
#else  // This should look better and be faster
      const float3 luminanceRatio = use_bt2020 ? renodx::color::BT2020_TO_XYZ_MAT[1].rgb : renodx::color::BT709_TO_XYZ_MAT[1].rgb;
      float3 negativePositiveLuminanceRatio = -(negativeColor / luminanceRatio) / (positiveLuminance / luminanceRatio);
      Color = lerp(Color, colorLuminance, negativePositiveLuminanceRatio * DesaturationAmount);
#endif
      // TODO: "DarkeningAmount" isn't normalized with "DesaturationAmount", so setting both to 50% won't perfectly stop gamut clip
      positiveColor = max(Color.xyz, 0.0);
      negativeColor = min(Color.xyz, 0.0);
      Color = positiveColor + (negativeColor * (1.0 - DarkeningAmount));  // It's not darkening but brightening in this case
    }
    // Increase luminance until it's 0 if we were below 0 (it will clip out the negative gamut)
    else if (colorLuminance < -renodx::math::FLT32_MIN) {
      float negativePositiveLuminanceRatio = positiveLuminance / -negativeLuminance;
      negativeColor.xyz *= negativePositiveLuminanceRatio;
      Color.xyz = positiveColor + negativeColor;
    }
    // Snap to 0 if the overall luminance was zero, there's nothing to savage, no valid information on rgb ratio
    else {
      Color.xyz = 0.0;
    }
  }

  if (FixPositives && any(Color > Peak))  // Optional "optimization" branch
  {
    float colorLuminance = renodx::color::y::from::BT2020(Color);
    float colorLuminanceInExcess = colorLuminance - Peak;
    float maxColorInExcess = renodx::math::Max(Color.r, Color.g, Color.b) - Peak;                                                  // This is guaranteed to be >= "colorLuminanceInExcess"
    float brightnessReduction = saturate(renodx::math::SafeDivision(Peak, renodx::math::Max(Color.r, Color.g, Color.b), 1));       // Fall back to one in case of division by zero
    float desaturateAlpha = saturate(renodx::math::SafeDivision(maxColorInExcess, maxColorInExcess - colorLuminanceInExcess, 0));  // Fall back to zero in case of division by zero
    Color = lerp(Color, colorLuminance, desaturateAlpha * DesaturationAmount);
    Color = lerp(Color, Color * brightnessReduction, DarkeningAmount);  // Also reduce the brightness to partially maintain the hue, at the cost of brightness
  }

  return Color;
}

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

bool GenerateOutput(float r, float g, float b, inout float4 SV_Target) {
  if (RENODX_TONE_MAP_TYPE == 0 || !is_hdr) return false;  // skip if SDR or Vanilla tone mapper

  float3 final_color = (float3(r, g, b));
  if (RENODX_TONE_MAP_TYPE == 4.f) final_color = saturate(final_color);

  final_color = ApplyGammaCorrection(final_color);

  float3 bt2020_color = renodx::color::bt2020::from::BT709(final_color);
#if 0
  // bt2020_color = CorrectOutOfRangeColor(bt2020_color, true, false, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 1.f, 0.f, true);
#else
  float grayscale = renodx::color::y::from::BT2020(bt2020_color);
  grayscale = renodx::color::srgb::EncodeSafe(max(0, grayscale));
  bt2020_color = renodx::color::srgb::EncodeSafe(bt2020_color);
  bt2020_color = renodx::color::correct::GamutCompress(bt2020_color, renodx::color::y::from::BT2020(bt2020_color));
  bt2020_color = renodx::color::srgb::DecodeSafe(bt2020_color);
#endif
  float3 encoded_color = renodx::color::pq::EncodeSafe(bt2020_color, RENODX_DIFFUSE_WHITE_NITS);

  SV_Target = float4(encoded_color / 1.05f, 0.f);
  return true;
}
