#include "./shared.h"

#define cmp -

float3 ApplyDeathStrandingToneMap(float3 untonemapped, float4 mHDRCompressionParam1, float4 mHDRCompressionParam2,
                                  float4 mHDRCompressionParam3, uint peak = 0u) {
  float3 r0, r1, r2;
  r0.rgb = untonemapped;

  if (peak == 1u) {  // unclamped
    mHDRCompressionParam2.z = 999.f;
    mHDRCompressionParam2.w = 999.f;
    mHDRCompressionParam1.x = 100.f;
  }

  // part 1
  r1.xyz = mHDRCompressionParam1.y * r0.xyz + mHDRCompressionParam1.z;
  r2.xyz = mHDRCompressionParam2.x + r0.xyz;
  r2.xyz = -mHDRCompressionParam1.w / r2.xyz;
  r2.xyz = mHDRCompressionParam2.y + r2.xyz;
  r0.xyz = cmp(r0.xyz < mHDRCompressionParam2.z);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  // part 2
  r0.xyz = sqrt(r0.xyz);
  r1.xyz = cmp(float3(0, 0, 0) < r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = mHDRCompressionParam3.w * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r1.xyz ? r0.xyz : 0;
  r0.xyz = r0.xyz * r0.xyz;
  r0.xyz = min(mHDRCompressionParam1.x, r0.xyz);
  r1.xyz = -mHDRCompressionParam1.z + r0.xyz;
  r1.xyz = r1.xyz / mHDRCompressionParam1.y;
  r2.xyz = -mHDRCompressionParam2.y + r0.xyz;
  r2.xyz = -mHDRCompressionParam1.w / r2.xyz;
  r2.xyz = -mHDRCompressionParam2.x + r2.xyz;
  r0.xyz = cmp(r0.xyz < mHDRCompressionParam2.w);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  // part 3
  r1.xyz = mHDRCompressionParam1.y * r0.xyz + mHDRCompressionParam1.z;
  r2.xyz = mHDRCompressionParam3.y + r0.xyz;
  r2.xyz = -mHDRCompressionParam3.x / r2.xyz;
  r2.xyz = mHDRCompressionParam3.z + r2.xyz;
  r0.xyz = cmp(r0.xyz < mHDRCompressionParam2.z);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  return r0.rgb;
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  const float y_normalized = y / mid_gray;
  const float highlight_mask = 1.f / mid_gray;
  const float shadow_mask = mid_gray;

  // contrast & flare
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent);

  // highlights
  float y_highlighted = pow(y_contrasted, config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted / highlight_mask));

  // shadows
  float y_shadowed = pow(y_highlighted, -1.f * (config.shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted / shadow_mask));

  const float y_final = y_shadowed * mid_gray;

  color *= (y > 0 ? (y_final / y) : 0);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 untonemapped, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(untonemapped);

      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, 0);

      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, config.hue_correction_strength);

      float chrominance_post_adjust = distance(perceptual_new.yz, 0);

      // Apply back previous chrominance
      perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    }

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.blowout));
      if (config.blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 ToneMapForLUT(inout float r, inout float g, inout float b) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return float3(r, g, b);
  float3 color = float3(r, g, b);

  float y_in = renodx::color::y::from::BT709(color);
  float y_out = renodx::tonemap::ReinhardScalable(y_in, 1.f, 0.f, 0.18f, 0.18f);
  color = lerp(color, renodx::color::correct::Luminance(color, y_in, y_out), saturate(color / 0.18f));

  r = color.r, g = color.g, b = color.b;

  return color;
}

float3 ApplyDisplayMap(float3 undisplaymapped) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_CORRECTION;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  float y = renodx::color::y::from::BT709(undisplaymapped);

  float3 displaymapped;

  displaymapped = ApplyExposureContrastFlareHighlightsShadowsByLuminance(undisplaymapped, y, cg_config, 0.18f);
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    float peak_white = renodx::color::correct::GammaSafe(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

    if (RENODX_TONE_MAP_PER_CHANNEL == 1.f) {
      displaymapped = lerp(displaymapped, renodx::tonemap::ReinhardScalable(displaymapped, peak_white, 0.f, 0.5f, 0.5f), saturate(displaymapped));
    } else {
      float y_in = renodx::color::y::from::BT709(displaymapped);
      float y_out = renodx::tonemap::ReinhardScalable(y_in, peak_white, 0.f, 0.5f, 0.5f);
      displaymapped = lerp(displaymapped, renodx::color::correct::Luminance(displaymapped, y_in, y_out), saturate(displaymapped));
    }
  }
  displaymapped = ApplySaturationBlowoutHueCorrectionHighlightSaturation(displaymapped, undisplaymapped, y, cg_config);

  return displaymapped;
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  const float y_in = renodx::color::y::from::BT709(incorrect_color);
  const float y_out = max(0, renodx::color::correct::Gamma(y_in));

  float3 lum = incorrect_color * (y_in > 0 ? y_out / y_in : 0.f);

  // use chrominance from per channel gamma correction
  float3 result = renodx::color::correct::ChrominanceOKLab(lum, ch, 1.f, 1.f);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  }

  return corrected_color;
}

float3 ScaleScene(float3 color_scene) {
  if (RENODX_GAMMA_CORRECTION == 0.f) {
    color_scene *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  } else {
    color_scene = ApplyGammaCorrection(color_scene);
    color_scene *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color_scene = renodx::color::correct::GammaSafe(color_scene, true);
  }

  return color_scene;
}

void UpgradeToneMapApplyDisplayMapAndScale(float3 untonemapped, float3 tonemapped,
                                           inout float graded_r, inout float graded_g, inout float graded_b,
                                           float peak_white) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return;
  float3 undisplaymapped = renodx::tonemap::UpgradeToneMap(untonemapped.bgr, tonemapped.bgr, float3(graded_r, graded_g, graded_b), 1.f);

  float3 displaymapped = ApplyDisplayMap(undisplaymapped);

  displaymapped = ScaleScene(displaymapped);

  graded_r = displaymapped.r, graded_g = displaymapped.g, graded_b = displaymapped.b;
  return;
}

// #pragma warning(push)
// #pragma warning(disable: 4000)
bool GenerateOutput(float3 color_bt709, inout float4 output, bool clamp_peak = false) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    color_bt709 = renodx::color::correct::GammaSafe(color_bt709);
  }
  float3 color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);
  color_bt2020 *= RENODX_GRAPHICS_WHITE_NITS;
  color_bt2020 = (clamp_peak && RENODX_TONE_MAP_TYPE != 1.f) ? min(color_bt2020, RENODX_PEAK_WHITE_NITS) : color_bt2020;
  float3 color_pq = renodx::color::pq::EncodeSafe(color_bt2020, 1.f);

  output.rgb = color_pq;
  return true;
}
// #pragma warning(pop)