#include "./shared.h"

float3 GammaDecode(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 0.f) {
    color = renodx::color::srgb::Decode(color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::Decode(color, 2.2f);
  } else {
    color = renodx::color::gamma::Decode(color, 2.4f);
  }
  return color;
}

float3 GammaEncode(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 0.f) {
    color = renodx::color::srgb::Encode(color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::Encode(color, 2.2f);
  } else {
    color = renodx::color::gamma::Encode(color, 2.4f);
  }
  return color;
}

float3 ApplyToneMapAndScale(float3 color, bool clamp = false) {
  float3 untonemapped = GammaDecode(max(0, color));

  if (RENODX_TONE_MAP_TYPE == 0.f) {  // Vanilla
    color = saturate(untonemapped);
  } else {
    color = renodx::color::grade::UserColorGrading(
        untonemapped,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        RENODX_TONE_MAP_BLOWOUT);

    if (RENODX_TONE_MAP_TYPE == 3.f) {  // Frostbite
      color = renodx::tonemap::frostbite::BT709(
          color, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 1.f,
          RENODX_TONE_MAP_HIGHLIGHT_SATURATION, RENODX_TONE_MAP_HUE_CORRECTION, RENODX_TONE_MAP_HUE_PROCESSOR);
    } else if (RENODX_TONE_MAP_TYPE == 2.f) {  // Exponential Rolloff
      color = renodx::tonemap::ExponentialRollOff(color, min(1.f, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS), RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
      color = renodx::color::correct::Hue(color, untonemapped, RENODX_TONE_MAP_HUE_CORRECTION, RENODX_TONE_MAP_HUE_PROCESSOR);
    }
  }

  if (clamp) color = min(1, color);

  color *= RENODX_INTERMEDIATE_SCALING;

  color = sign(color) * GammaEncode(abs(color));
  return color;
}

float3 PostFXScale(float3 color) {
  // writes onto swapchain, breaks unless manually clamped
#if CLAMP_POSTFX
  color = max(0, color);
#endif

  color = GammaDecode(color);
  color *= RENODX_INTERMEDIATE_SCALING;
  color = GammaEncode(color);
  return color;
}
