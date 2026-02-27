#include "../common.glsl"

vec3 GammaCorrectHuePreserving(vec3 x) {
  float lum_in = renodx_color_macleod_boynton_LuminosityFromBT709LuminanceNormalized(x);
  float lum_out = CorrectGammaMismatch(lum_in, false);
  vec3 lum = x * DivideSafe(lum_out, lum_in, 1.f);

  vec3 ch = CorrectGammaMismatch(x, false);

  vec3 corrected_bt2020 = renodx_color_macleod_boynton_TransferPurityBT2020(BT2020FromBT709(lum), BT2020FromBT709(ch), 1.f);

  vec3 corrected = BT709FromBT2020(corrected_bt2020);

  return corrected;
}

vec3 GammaSafe(vec3 x) {
  if (RENODX_SDR_EOTF_EMULATION == 2.f) {
    return GammaCorrectHuePreserving(x);
  } else if (RENODX_SDR_EOTF_EMULATION == 1.f) {
    return CorrectGammaMismatch(x, false);
  } else {
    return x;
  }
}

vec3 ClampMaxChannel(vec3 color) {
  if (RENODX_TONE_MAP_TYPE != 0.f && CLAMP_PEAK != 0.f) {
    float peak = RENODX_PEAK_WHITE_NITS;
    float max_channel = max(max(max(color.r, color.g), color.b), peak);
    color *= peak / max_channel;  // Clamp overshoot
  }
  return color;
}

vec3 PQEncodeUI(vec3 x) {
  x *= vec3(RENODX_GRAPHICS_WHITE_NITS);
  x = ClampMaxChannel(x);
  return EncodePQ(max(vec3(0.0), x), 1.f);
}

vec3 PQEncodeGame(vec3 x) {
  x *= vec3(RENODX_DIFFUSE_WHITE_NITS);
  x = ClampMaxChannel(x);
  return EncodePQ(max(vec3(0.0), x), 1.f);
}

