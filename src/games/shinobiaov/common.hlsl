#include "./shared.h"

float3 InvRenoDRT(float3 color) {
  float y = renodx::color::y::from::BT709(color);
  float untonemapped_y = renodx::tonemap::inverse::Reinhard(y);
  float3 untonemapped = color * renodx::math::DivideSafe(untonemapped_y, y, 0);
  renodx::tonemap::renodrt::Config hdr_video_config = renodx::tonemap::renodrt::config::Create();

  //float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  float peak = 0.f;

  [branch]
  if (CUSTOM_SPRITE_ITM < 0.5f) {
    peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  } else {
    peak = lerp(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 10000.f / RENODX_DIFFUSE_WHITE_NITS, (CUSTOM_SPRITE_ITM - 0.5) * 2);
  }

  hdr_video_config.nits_peak = peak * 100.f;
  hdr_video_config.mid_gray_value = 0.18f;
  hdr_video_config.mid_gray_nits = 18.f;
  hdr_video_config.exposure = 1.0f;
  hdr_video_config.contrast = 1.0f;
  hdr_video_config.saturation = 1.1f;
  hdr_video_config.highlights = 1.0f;
  hdr_video_config.shadows = 1.0f;

  hdr_video_config.blowout = -0.01f;
  hdr_video_config.dechroma = 0;
  hdr_video_config.flare = 0;

  hdr_video_config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  hdr_video_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::CUSTOM;
  hdr_video_config.hue_correction_source = color;
  hdr_video_config.per_channel = false;
  hdr_video_config.working_color_space = 2u;
  hdr_video_config.clamp_peak = 2u;
  hdr_video_config.clamp_color_space = -1.f;

  return renodx::tonemap::renodrt::BT709(untonemapped, hdr_video_config);
}

float3 ItmLerp(float3 hdr, float3 itm) {
  float luma1 = renodx::color::y::from::BT709(hdr);
  float luma2 = renodx::color::y::from::BT709(itm);

  [branch]
  if ((luma1 + luma2) == 0.0) {
    return float3(0, 0, 0);
  }

  float t = luma1 / (luma1 + luma2);

  return lerp(itm, hdr, t);
}

float3 ItmLuminanceCorrect(float3 hdr, float3 itm) {
  float hdr_y = renodx::color::y::from::BT709(hdr);
  float itm_y = renodx::color::y::from::BT709(itm);

  float combined_y = max(hdr_y, itm_y);

  return renodx::color::correct::Luminance(hdr, hdr_y, combined_y);
}

float3 ExponentialRollOffByLum(float3 color, float output_luminance_max, float highlights_shoulder_start = 0.f) {
  const float source_luminance = renodx::color::y::from::BT709(color);

  [branch]
  if (source_luminance > 0.0f) {
    const float compressed_luminance = renodx::tonemap::ExponentialRollOff(source_luminance, highlights_shoulder_start, output_luminance_max);
    color *= compressed_luminance / source_luminance;
  }

  return color;
}

float3 ApplyExponentialRollOff(float3 color) {
  const float paperWhite = RENODX_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;

  const float peakWhite = RENODX_PEAK_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;

  // const float highlightsShoulderStart = paperWhite;
  const float highlightsShoulderStart = 1.f;

  [branch]
  if (RENODX_TONE_MAP_PER_CHANNEL == 0.f) {
    return ExponentialRollOffByLum(color * paperWhite, peakWhite, highlightsShoulderStart) / paperWhite;
  } else {
    return renodx::tonemap::ExponentialRollOff(color * paperWhite, highlightsShoulderStart, peakWhite) / paperWhite;
  }
  
}

float3 ApplyTonemapScaling(float3 color) {
  color = renodx::color::srgb::DecodeSafe(color);

  float3 hue_color = saturate(color);
  float3 itm = color;

  [branch]
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    [branch]
    if (CUSTOM_SPRITE_ITM != 0.f) {
      float shoulder = min(0.5f, CUSTOM_SPRITE_ITM);

      itm = renodx::tonemap::ExponentialRollOff(itm, shoulder, 1.f);
      itm = renodx::color::correct::Chrominance(itm, saturate(renodx::tonemap::dice::BT709(color, 1.f, 0.f)), .75f);

      itm = InvRenoDRT(saturate(itm));
      color = ItmLerp(color, itm);
    }

    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    draw_config.peak_white_nits = 10000.f;
    draw_config.tone_map_hue_correction = 0.f;
    draw_config.tone_map_hue_shift = 0.f;
    draw_config.tone_map_per_channel = 0.f;

    color = renodx::draw::ToneMapPass(color, draw_config);

    color = ApplyExponentialRollOff(color);

    color = renodx::color::correct::Hue(color, hue_color, RENODX_TONE_MAP_HUE_CORRECTION);
  } else {
    color = saturate(color);
  }

  return renodx::draw::RenderIntermediatePass(color);
}