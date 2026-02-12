#include "./shared.h"
#include "./lilium_rcas.hlsl"

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

float3 PostTonemapSliders(float3 hdr_color) {
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.blowout = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  float y = renodx::color::y::from::BT709(hdr_color);
  return ApplySaturationBlowoutHighlightSaturation(hdr_color, y, config);
}

float3 CustomPostProcessing(float3 color, float2 uv, Texture2D<float4> t1, SamplerState s1) {
  color = ApplyRCAS(color, uv, t1, s1);
  color = renodx::effects::ApplyFilmGrain(color, uv, CUSTOM_RANDOM, CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  return color;
}

float3 DisplayMap(float3 color) {
  renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

  float peak_nits = config.peak_white_nits / renodx::color::srgb::REFERENCE_WHITE;
  float diffuse_white_nits = config.diffuse_white_nits / renodx::color::srgb::REFERENCE_WHITE;

  color = max(0, renodx::color::bt2020::from::BT709(color));
  float tonemap_peak = peak_nits / diffuse_white_nits;

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    tonemap_peak = renodx::color::correct::GammaSafe(tonemap_peak, true);
  }

  float3 outputColor = color;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    outputColor = renodx::tonemap::neutwo::MaxChannel(color, tonemap_peak);
  }

  outputColor = renodx::color::bt709::from::BT2020(outputColor);

  return outputColor;
}

float3 CustomACES(float3 untonemapped_ap1) {

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);
    untonemapped_bt709 = PreTonemapSliders(untonemapped_bt709);
    untonemapped_ap1 = renodx::color::ap1::from::BT709(untonemapped_bt709);

    const float ACES_MIN = 0.0001f;
    float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
    // float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    //const float aces_min = 0.0001f;
    const float aces_max = 100.f;

    float aces_max_ch = SCENE_GRADE_PER_CHANNEL_BLOWOUT;

    // if (RENODX_GAMMA_CORRECTION != 0.f) {
    //   aces_max = renodx::color::correct::Gamma(aces_max, true);
    //   aces_min = renodx::color::correct::Gamma(aces_min, true);
    // }

    renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);
    renodx::tonemap::aces::ODTConfig ODT_config_ch = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max_ch * 48.f);

    float3 tonemapped_ap1_ch = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config_ch) / 48.f;

    float y_in = renodx::color::y::from::AP1(untonemapped_ap1);
    float y_out = renodx::tonemap::aces::ODTToneMap(y_in, ODT_config) / 48.f;
    float3 tonemapped_ap1_y = renodx::color::correct::Luminance(untonemapped_ap1, y_in, y_out);

    float3 tonemapped_bt709_ch = renodx::color::bt709::from::AP1(tonemapped_ap1_ch);
    float3 tonemapped_bt709_y = renodx::color::bt709::from::AP1(tonemapped_ap1_y);

    float3 tonemapped_bt709 = renodx::color::correct::Chrominance(tonemapped_bt709_y, tonemapped_bt709_ch, 1.f, 0.f, 1);
    tonemapped_bt709 = renodx::color::correct::Hue(tonemapped_bt709, tonemapped_bt709_ch, SCENE_GRADE_PER_CHANNEL_HUE_SHIFT, 1);

    tonemapped_bt709 = PostTonemapSliders(tonemapped_bt709);
    tonemapped_bt709 = DisplayMap(tonemapped_bt709);

    if (RENODX_GAMMA_CORRECTION != 0.f) {
      tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
    }

    float3 tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);

    float3 output = renodx::color::pq::EncodeSafe(tonemapped_bt2020, RENODX_DIFFUSE_WHITE_NITS);
    return output;
  }
  return untonemapped_ap1;
}