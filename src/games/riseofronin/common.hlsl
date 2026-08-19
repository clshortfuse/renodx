#include "./shared.h"

float3 RenoDRTSmoothClamp(float3 untonemapped, float peak = 100.f, float whiteclip = 100.f, float highlightSaturation = 1.f, bool per_channel = false) {
  renodx::tonemap::renodrt::Config renodrt_config =
      renodx::tonemap::renodrt::config::Create();
  renodrt_config.nits_peak = peak;
  renodrt_config.mid_gray_value = 0.18f;
  renodrt_config.mid_gray_nits = 18.f;
  renodrt_config.exposure = 1.f;
  renodrt_config.highlights = 1.f;
  renodrt_config.shadows = 1.f;
  renodrt_config.contrast = 1.1f;
  renodrt_config.saturation = 1.0f;
  renodrt_config.dechroma = 0.f;
  renodrt_config.flare = 0.f;
  renodrt_config.blowout = -1.f * (highlightSaturation - 1.f);  // Highlight saturation
  renodrt_config.hue_correction_strength = 0.f;
  renodrt_config.tone_map_method =
      renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  renodrt_config.working_color_space = 1u;  // might need to be 0/1u -- can test
  renodrt_config.white_clip = whiteclip;
  renodrt_config.per_channel = per_channel;

  return renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
}

float4 ProcessColor(float3 untonemapped, float3 graded) {
  float4 color;
  // float midGray = midGray;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    // untonemapped.rgb *= midGray / 0.18f;  // Adjust midgray, RenoDRT except 0.18f

    color.rgb = renodx::draw::ToneMapPass(untonemapped, graded);
    color.rgb = renodx::draw::RenderIntermediatePass(color.rgb);
  } else {
    color.rgb = graded;
    color.rgb = renodx::draw::RenderIntermediatePass(color.rgb);
  }

  color.a = 1.f;

  return color;
}

float3 RestoreHighlightSaturation(float3 color) {
  if (RENODX_TONE_MAP_TYPE != 0.f || DISPLAY_MAP_TYPE != 0.f) {
    if (DISPLAY_MAP_TYPE == 1.f) {  // Dice

      float dicePeak = DISPLAY_MAP_PEAK;          // 2.f default
      float diceShoulder = DISPLAY_MAP_SHOULDER;  // 0.25f default
      color = renodx::tonemap::dice::BT709(color, dicePeak, diceShoulder);

    } else if (DISPLAY_MAP_TYPE == 2.f) {  // Frostbite

      float frostbitePeak = DISPLAY_MAP_PEAK;          // 2.f default
      float frostbiteShoulder = DISPLAY_MAP_SHOULDER;  // 0.25f default
      float frostbiteSaturation = 1.f;                 // Hardcode to 1.f
      color = renodx::tonemap::frostbite::BT709(color, frostbitePeak, frostbiteShoulder, frostbiteSaturation);
      // color = RenoDRTSmoothClamp(color, 10000.f, 100.f, 5.f); // Testing smoothclamp
    }
  } else {
    // We dont want to Display Map if the tonemapper is vanilla/preset off or display map is none
    color = color;
  }

  return color;
}

float ScaleExposure(float exposure, float x = 0.6f) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    exposure *= x;
  } else {
    exposure = exposure;
  }
  return exposure;
}
