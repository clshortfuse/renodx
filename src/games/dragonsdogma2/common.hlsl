#include "./shared.h"
#include "./psycho_test11.hlsl"
#include "./macleod_boynton.hlsli"

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {  // highlights < 1.f
    x /= mid_gray;
    return lerp(x, pow(x, highlights), step(1.f, x)) * mid_gray;
  }
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  // contrast & flare
  const float y_normalized = y / mid_gray;
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent) * mid_gray;

  // highlights
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);
  // float y_highlighted = HDRBoost(y_contrasted, config.highlights - 1.f, mid_gray);
  // float y_highlighted = renodx::color::grade::Highlights(y_contrasted, config.highlights, mid_gray);

  // shadows
  float y_shadowed = renodx::color::grade::Shadows(y_highlighted, config.shadows, mid_gray);
  y_shadowed = max(0, y_shadowed);  // clamp to prevent artifacts

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHighlightSaturation(float3 tonemapped, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

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

float3 ApplyPerChannelBlowoutHueShift(float3 untonemapped, float mid_gray = 0.18f, float max_value = 1.f) {
  if (SCENE_GRADE_PER_CHANNEL_BLOWOUT > 0.f) {
    float calculated_peak = SCENE_GRADE_PER_CHANNEL_BLOWOUT;
    calculated_peak = max(calculated_peak, 1.f);

    if (RENODX_GAMMA_CORRECTION != 0.f) {
      calculated_peak = renodx::color::correct::GammaSafe(calculated_peak, true);
    }

    // float compression_scale;
    // GamutCompression(untonemapped, compression_scale);
    untonemapped = max(0, renodx::color::bt2020::from::BT709(untonemapped));

    float3 graded_color = renodx::tonemap::ReinhardPiecewise(untonemapped, calculated_peak, mid_gray);

    float3 color = renodx::color::correct::Chrominance(untonemapped, graded_color, 1.f, 0.f, 1);
    color = renodx::color::correct::Hue(color, graded_color, SCENE_GRADE_PER_CHANNEL_HUE_SHIFT, 1);

    // GamutDecompression(color, compression_scale);
    color = renodx::color::bt709::from::BT2020(color);
    return color;
  }
  return untonemapped;
}

float3 PreTonemapSliders(float3 untonemapped, float mid_gray = 0.18f) {
  // if (RENODX_TONE_MAP_TYPE == 0.f) return untonemapped;

  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = RENODX_TONE_MAP_FLARE;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

  float y = renodx::color::y::from::BT709(untonemapped);
  float3 outputColor = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, config, mid_gray);
  return outputColor;
}

// float3 PostTonemapSliders(float3 hdr_color) {
//   renodx::color::grade::Config config = renodx::color::grade::config::Create();
//   config.saturation = RENODX_TONE_MAP_SATURATION;
//   config.blowout = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
//   config.dechroma = RENODX_TONE_MAP_BLOWOUT;
//   config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

//   float y = renodx::color::y::from::BT709(hdr_color);
//   hdr_color = ApplySaturationBlowoutHighlightSaturation(hdr_color, y, config);
//   hdr_color = ApplyPerChannelBlowoutHueShift(hdr_color, 0.5f);
//   return hdr_color;
// }

float3 CustomPostProcessing(float3 color, float2 uv) {
  //color = ApplyRCAS(color, uv, t1, s1);
  color = renodx::effects::ApplyFilmGrain(color, uv, CUSTOM_RANDOM, CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  return color;
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.375f, float output_max = 1.f, float white_clip = 100.f) {
  if (RENODX_TONE_MAP_TYPE < 2.f) return 1.f;
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

float3 CustomPsychoTest(float3 untonemapped, float peak) {
  renodx::draw::Config config = renodx::draw::BuildConfig();

  float3 outputColor = psychotm_test11(
      untonemapped,
      peak,
      config.tone_map_exposure,
      config.tone_map_highlights,
      config.tone_map_shadows,
      config.tone_map_contrast,
      config.tone_map_saturation,
      1.f - config.tone_map_blowout,
      100.f,
      config.tone_map_hue_correction,
      //1.8f * RENODX_TONE_MAP_ADAPTIVE_CONTRAST
      RENODX_TONE_MAP_ADAPTIVE_CONTRAST
  );

  return outputColor;
}

float3 CustomTonemap(float3 untonemapped_ap1, float2 uv) {


  float calculated_peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    calculated_peak = renodx::color::correct::Gamma(calculated_peak, true);
  }

  const float ACES_MIN = 0.0001f;
 
  float3 output_color = untonemapped_ap1;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // ACES
    float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);
    float3 untonemapped_ap0 = mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1);
    float3 rrt_out = renodx::tonemap::aces::RRT(untonemapped_ap0);
    float3 tonemapped_bt709_ch = renodx::tonemap::aces::ODT(rrt_out, (ACES_MIN) * 48.f, calculated_peak * 48.f) / 48.f;

    output_color = tonemapped_bt709_ch;
  }
  else if (RENODX_TONE_MAP_TYPE == 2.f) {  // PsychoV
    float lumin_in = LuminosityFromAP1(untonemapped_ap1);
    float lumin_out = renodx::tonemap::aces::ODT(lumin_in, (ACES_MIN) * 48.f, 100.f * 48.f).x / 48.f;
    lumin_out = renodx::color::ap1::from::BT709(lumin_out).x;
    float3 tonemapped_ap1_lumin = renodx::color::correct::Luminance(untonemapped_ap1, lumin_in, lumin_out);
    float3 tonemapped_bt709_lumin = renodx::color::bt709::from::AP1(tonemapped_ap1_lumin);

    output_color = CustomPsychoTest(tonemapped_bt709_lumin, calculated_peak);
  }

  output_color = CustomPostProcessing(output_color, uv);
  output_color = RENODX_GAMMA_CORRECTION == 1.f ? renodx::color::correct::GammaSafe(output_color) : output_color;
  output_color = renodx::color::bt2020::from::BT709(output_color);
  return renodx::color::pq::EncodeSafe(output_color, RENODX_DIFFUSE_WHITE_NITS);
}

void CustomVignette(inout float vignette) {
  vignette = lerp(1.f, vignette, CUSTOM_VIGNETTE);
}

float3 SampleSDRLUT(float3 color, SamplerState TrilinearClamp, Texture3D SrcLUT) {
  //color = renodx::color::pq::EncodeSafe(mul(renodx::color::AP1_TO_AP0_MAT, color), 100.f);  // Mimic first LUT
  color = renodx::color::pq::EncodeSafe(color, 100.f); // encode for lutbuilder input
  float4 _66 = SrcLUT.SampleLevel(TrilinearClamp, float3(((color.x * 0.984375f) + 0.0078125f), ((color.y * 0.984375f) + 0.0078125f), ((color.z * 0.984375f) + 0.0078125f)), 0.0f);
  _66.xyz = renodx::color::pq::DecodeSafe(_66.xyz, 100.f); // decode so it's linear out
  return _66.xyz;
}

float3 UpgradeToneMapMaxChannel(
    float3 color_untonemapped,
    float3 color_tonemapped,
    float3 color_tonemapped_graded,
    float post_process_strength = 1.f,
    float auto_correction = 1.f) {
  float ratio = 1.f;

  float max_untonemapped = renodx::math::Max(color_untonemapped);
  float max_tonemapped = renodx::math::Max(color_tonemapped);
  float max_tonemapped_graded = renodx::math::Max(color_tonemapped_graded);

  if (max_untonemapped < max_tonemapped) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    ratio = max_untonemapped / max_tonemapped;
  } else {
    float max_delta = max_untonemapped - max_tonemapped;
    max_delta = max(0, max_delta);  // Cleans up NaN
    const float max_new = max_tonemapped_graded + max_delta;

    const bool max_valid = (max_tonemapped_graded > 0);  // Cleans up NaN and ignore black
    ratio = max_valid ? (max_new / max_tonemapped_graded) : 0;
  }
  float auto_correct_ratio = lerp(1.f, ratio, saturate(max_untonemapped));
  ratio = lerp(ratio, auto_correct_ratio, auto_correction);

  float3 color_scaled = color_tonemapped_graded * ratio;

  return lerp(color_untonemapped, color_scaled, post_process_strength);
}