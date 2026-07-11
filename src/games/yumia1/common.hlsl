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
    color.rgb = graded;
    color.rgb = renodx::color::correct::GammaSafe(color.rgb);
    color.rgb *= RENODX_GAME_NITS / RENODX_UI_NITS;
    color.rgb = renodx::color::correct::GammaSafe(color.rgb, true);
  }

  color.w = 1.f;

  return color;
}

// A banaid fix Adrian found using a Display Mapper (DICE/Frostbite) to restore highlight saturation
// That was lost running TonemapPass
// We run this function right after untonemapped, and display map the rest of the sdr path down to ~2.f
float3 RestoreHighlightSaturation(float3 color) {
  if (RENODX_TONE_MAP_TYPE != 0.f || DISPLAY_MAP_TYPE != 0.f) {
    if (DISPLAY_MAP_TYPE == 1.f) {  // Dice

      float dicePeak = DISPLAY_MAP_PEAK;          // 2.f default
      float diceShoulder = DISPLAY_MAP_SHOULDER;  // 0.5f default
      color = renodx::tonemap::dice::BT709(color, dicePeak, diceShoulder);

    } else if (DISPLAY_MAP_TYPE == 2.f) {  // Frostbite

      float frostbitePeak = DISPLAY_MAP_PEAK;     // 2.f default
      float diceShoulder = DISPLAY_MAP_SHOULDER;  // 0.5f default
      float diceSaturation = 1.f;                 // Hardcode to 1.f
      color = renodx::tonemap::frostbite::BT709(color, frostbitePeak, diceShoulder, diceSaturation);
      // color = RenoDRTSmoothClamp(color, 10000.f, 100.f, 5.f); // Testing smoothclamp
    }
  } else {
    // We dont want to Display Map if the tonemapper is vanilla/preset off or display map is none
    color = color;
  }

  return color;
}
