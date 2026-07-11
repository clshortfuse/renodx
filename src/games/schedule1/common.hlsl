#include "./shared.h"

float4 ProcessColor(float3 untonemapped, float3 graded) {
  float4 color;
  float midGray = 0.18f;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    // untonemapped.rgb *= midGray / 0.18f; // Adjust midgray, RenoDRT except 0.18f

    color.rgb = renodx::draw::ToneMapPass(untonemapped, graded);
    color.rgb = renodx::color::correct::GammaSafe(color.rgb);
    color.rgb *= RENODX_GAME_NITS / RENODX_UI_NITS;
    color.rgb = renodx::color::correct::GammaSafe(color.rgb, true);
  } else {
    color.rgb = saturate(graded);
    color.rgb = renodx::color::correct::GammaSafe(color.rgb);
    color.rgb *= RENODX_GAME_NITS / RENODX_UI_NITS;
    color.rgb = renodx::color::correct::GammaSafe(color.rgb, true);
  }

  color.w = 1.f;

  return color;
}

// Process color for scenes that just clip
float4 ProcessColor(float3 untonemapped) {
  float4 color;
  float midGray = 0.18f;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    // untonemapped.rgb *= midGray / 0.18f; // Adjust midgray, RenoDRT except 0.18f

    color.rgb = renodx::draw::ToneMapPass(untonemapped);
    color.rgb = renodx::color::correct::GammaSafe(color.rgb);
    color.rgb *= RENODX_GAME_NITS / RENODX_UI_NITS;
    color.rgb = renodx::color::correct::GammaSafe(color.rgb, true);
  } else {
    color.rgb = saturate(untonemapped);
    color.rgb = renodx::color::correct::GammaSafe(color.rgb);
    color.rgb *= RENODX_GAME_NITS / RENODX_UI_NITS;
    color.rgb = renodx::color::correct::GammaSafe(color.rgb, true);
  }

  color.w = 1.f;

  return color;
}

// RenoDRTSmoothClamp from FFX, swapped up to use Reinhard
// Added whiteclip
// STILL A WIP
float3 RenoDRTSmoothClamp(float3 untonemapped, float peak = 100.f, float whiteclip = 100.f, float highlightSaturation = 1.f, bool per_channel = false) {
  renodx::tonemap::renodrt::Config renodrt_config =
      renodx::tonemap::renodrt::config::Create();
  renodrt_config.nits_peak = peak;
  renodrt_config.mid_gray_value = 0.18f;
  renodrt_config.mid_gray_nits = 18.f;
  renodrt_config.exposure = 1.f;
  renodrt_config.highlights = 1.f;
  renodrt_config.shadows = 1.f;
  renodrt_config.contrast = 1.f;
  renodrt_config.saturation = 1.f;
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

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

// A banaid fix Adrian found using a Display Mapper (DICE/Frostbite) to restore highlight saturation
// That was lost running TonemapPass
// We run this function right after untonemapped, and display map the rest of the sdr path down to ~2.f
float3 RestoreHighlightSaturation(float3 color) {
  if (RENODX_TONE_MAP_TYPE != 0.f && DISPLAY_MAP_TYPE != 0.f) {
    float color_y = renodx::color::y::from::BT709(color);

    [branch]
    if (DISPLAY_MAP_TYPE == 1.f) {  // Dice

      float dice_peak = DISPLAY_MAP_PEAK;          // 2.f default
      float dice_shoulder = DISPLAY_MAP_SHOULDER;  // 0.5f default
      float3 dice_color = renodx::tonemap::dice::BT709(color, dice_peak, dice_shoulder);
      color = lerp(color, dice_color, saturate(color_y));

    } else if (DISPLAY_MAP_TYPE == 2.f) {  // Frostbite

      float frostbite_peak = DISPLAY_MAP_PEAK;          // 2.f default
      float frostbite_shoulder = DISPLAY_MAP_SHOULDER;  // 0.5f default
      float frostbite_saturation = 1.f;                 // Hardcode to 1.f
      float3 frostbite_color = renodx::tonemap::frostbite::BT709(color, frostbite_peak, frostbite_shoulder, frostbite_saturation);
      color = lerp(color, frostbite_color, saturate(color_y));

    } else if (DISPLAY_MAP_TYPE == 3.f) {  // RenoDRT NeutralSDR
      float3 neutral_sdr_color = renodx::tonemap::renodrt::NeutralSDR(color);
      color = lerp(color, neutral_sdr_color, saturate(color_y));

    } else if (DISPLAY_MAP_TYPE == 4.f) {  // ToneMapMaxCLL
      color = lerp(color, ToneMapMaxCLL(color), saturate(color_y));
    }

  } else {
    // We dont want to Display Map if the tonemapper is vanilla/preset off or display map is none
    color = color;
  }

  return color;
}
