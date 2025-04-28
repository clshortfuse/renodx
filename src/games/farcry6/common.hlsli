#include "./shared.h"
float3 ApplyVanillaHDRTonemap(float3 color, float paper_white, float peak_nits) {
  float _456 = paper_white * 0.10000000149011612f;
  float _457 = log2(peak_nits);
  float _458 = _457 + -13.287712097167969f;
  float _459 = _458 * 1.4929734468460083f;
  float _460 = _459 + 18.0f;
  float _461 = exp2(_460);
  float _462 = _461 * 0.18000000715255737f;
  float _463 = abs(_462);
  float _464 = log2(_463);
  float _465 = _464 * 1.5f;
  float _466 = exp2(_465);
  float _467 = _466 * _456;
  float _468 = _467 / peak_nits;
  float _469 = _468 + -0.07636754959821701f;
  float _470 = _464 * 1.2750000953674316f;
  float _471 = exp2(_470);
  float _472 = _471 * 0.07636754959821701f;
  float _473 = paper_white * 0.011232397519052029f;
  float _474 = _473 * _466;
  float _475 = _474 / peak_nits;
  float _476 = _472 - _475;
  float _477 = _471 + -0.11232396960258484f;
  float _478 = _477 * _456;
  float _479 = _478 / peak_nits;
  float _480 = _479 * peak_nits;
  float _481 = abs(color.x);
  float _482 = abs(color.y);
  float _483 = abs(color.z);
  float _484 = log2(_481);
  float _485 = log2(_482);
  float _486 = log2(_483);
  float _487 = _484 * 1.5f;
  float _488 = _485 * 1.5f;
  float _489 = _486 * 1.5f;
  float _490 = exp2(_487);
  float _491 = exp2(_488);
  float _492 = exp2(_489);
  float _493 = _490 * _480;
  float _494 = _491 * _480;
  float _495 = _492 * _480;
  float _496 = _484 * 1.2750000953674316f;
  float _497 = _485 * 1.2750000953674316f;
  float _498 = _486 * 1.2750000953674316f;
  float _499 = exp2(_496);
  float _500 = exp2(_497);
  float _501 = exp2(_498);
  float _502 = _499 * _469;
  float _503 = _500 * _469;
  float _504 = _501 * _469;
  float _505 = _502 + _476;
  float _506 = _503 + _476;
  float _507 = _504 + _476;
  float _508 = _493 / _505;
  float _509 = _494 / _506;
  float _510 = _495 / _507;
  float _511 = _508 * 9.999999747378752e-05f;
  float _512 = _509 * 9.999999747378752e-05f;
  float _513 = _510 * 9.999999747378752e-05f;
  float _514 = 5000.0f / paper_white;
  float _515 = _511 * _514;
  float _516 = _512 * _514;
  float _517 = _513 * _514;
  return float3(_515, _516, _517);
}

float3 ApplyUserColorGrading(float3 ungraded_ap1) {
  return renodx::color::ap1::from::BT709(
      renodx::color::grade::UserColorGrading(
          renodx::color::bt709::from::AP1(ungraded_ap1),
          RENODX_TONE_MAP_EXPOSURE,
          RENODX_TONE_MAP_HIGHLIGHTS,
          RENODX_TONE_MAP_SHADOWS,
          RENODX_TONE_MAP_CONTRAST,
          RENODX_TONE_MAP_SATURATION,
          RENODX_TONE_MAP_BLOWOUT,
          0.f));
}

// solves for x
// (x * (x + 0.0206166003) / (x * (0.983796 * x + 0.433679014) + 0.246179)) = 0.18
float GetVanillaSDRMidGray() {
  return 0.269565;
}

float3 ApplyVanillaSDRTonemap(float3 color) {
  float3 offset_color = color + 0.0206166003f;
  float3 numerator = offset_color * color;
  // numerator -= 0.0000745695f;

  float3 gain = color * 0.9837960005f + 0.4336790144f;
  float3 denominator = gain * color + 0.246179f;

  return numerator / denominator;
}

#define VANILLASDRTONEMAP_GENERATOR(T)                   \
  T VanillaSDRTonemap(T color, bool black_clip = true) { \
    T offset_color = color + 0.0206166003f;              \
    T numerator = offset_color * color;                  \
    if (black_clip) numerator -= 0.0000745695f;          \
    T gain = color * 0.9837960005f + 0.4336790144f;      \
    T denominator = gain * color + 0.246179f;            \
                                                         \
    return numerator / denominator;                      \
  }

VANILLASDRTONEMAP_GENERATOR(float)
VANILLASDRTONEMAP_GENERATOR(float3)
#undef VANILLASDRTONEMAP_GENERATOR

float3 SaturationAP1(float3 color_ap1, float saturation, float blowout = 0.f) {
  float3 color_bt709 = renodx::color::bt709::from::AP1(max(0, color_ap1));

  color_bt709 = renodx::color::grade::UserColorGrading(
      color_bt709,
      1.f,  // exposure
      1.f,  // highlights
      1.f,  // shadows
      1.f,  // contrast
      saturation,
      blowout,
      0.f);

  return renodx::color::ap1::from::BT709(color_bt709);
}

float3 HueCorrectAP1(float3 incorrect_color_ap1, float3 correct_color_ap1, float hue_correct_strength = 0.5f) {
  float3 incorrect_color_bt709 = renodx::color::bt709::from::AP1(incorrect_color_ap1);
  float3 correct_color_bt709 = renodx::color::bt709::from::AP1(correct_color_ap1);

  float3 corrected_color_bt709 = renodx::color::correct::Hue(incorrect_color_bt709, correct_color_bt709, hue_correct_strength, 1u);
  float3 corrected_color_ap1 = renodx::color::ap1::from::BT709(corrected_color_bt709);
  return max(0, corrected_color_ap1);
}

float3 ToneMapByLuminance(float3 untonemapped_ap1) {
  float y = renodx::color::y::from::AP1(untonemapped_ap1);
  float y_mapped = VanillaSDRTonemap(y);
  float scale = max(0.0f, y_mapped / y);  // float scale = y > 0 ? y_mapped / y : 0;
  float3 tonemapped_ap1 = untonemapped_ap1 * scale;

  tonemapped_ap1 = max(0, SaturationAP1(tonemapped_ap1, 22.f, .99f));  // increase saturation in midtones and shadows

  float mid_gray_ratio = 0.18f / GetVanillaSDRMidGray();
  float tonemapped_y = renodx::color::y::from::AP1(tonemapped_ap1);
  tonemapped_ap1 = lerp(tonemapped_ap1, untonemapped_ap1 * mid_gray_ratio, saturate(tonemapped_y));
  tonemapped_ap1 = ApplyUserColorGrading(tonemapped_ap1);

  float peak_nits = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION) peak_nits = renodx::color::correct::GammaSafe(peak_nits, true);
  tonemapped_ap1 = renodx::tonemap::ExponentialRollOff(tonemapped_ap1, 0.1f, peak_nits);

  return tonemapped_ap1;
}

float3 ToneMapByChannel(float3 untonemapped_ap1) {
  untonemapped_ap1 = max(0, untonemapped_ap1);
  float3 tonemapped_ap1 = VanillaSDRTonemap(untonemapped_ap1);
  tonemapped_ap1 = HueCorrectAP1(tonemapped_ap1, untonemapped_ap1);  // correct hue to match untonemapped color

  float mid_gray_ratio = 0.18f / GetVanillaSDRMidGray();
  tonemapped_ap1 = lerp(tonemapped_ap1, untonemapped_ap1 * mid_gray_ratio, saturate(tonemapped_ap1));
  tonemapped_ap1 = ApplyUserColorGrading(tonemapped_ap1);

  float peak_nits = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION) peak_nits = renodx::color::correct::GammaSafe(peak_nits, true);
  tonemapped_ap1 = renodx::tonemap::ExponentialRollOff(tonemapped_ap1, 0.1f, peak_nits);

  return tonemapped_ap1;
}

float3 ApplyACESToneMap(float3 untonemapped_ap1) {
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
  float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  if (RENODX_GAMMA_CORRECTION) {
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
  }

  // exposure, highlights, shadows, contrast
  if (RENODX_TONE_MAP_EXPOSURE != 1.f || RENODX_TONE_MAP_HIGHLIGHTS != 1.f || RENODX_TONE_MAP_SHADOWS != 1.f || RENODX_TONE_MAP_CONTRAST != 1.f) {
    untonemapped_ap1 = renodx::color::ap1::from::BT709(
        renodx::color::grade::UserColorGrading(
            renodx::color::bt709::from::AP1(untonemapped_ap1),
            RENODX_TONE_MAP_EXPOSURE,
            RENODX_TONE_MAP_HIGHLIGHTS,
            RENODX_TONE_MAP_SHADOWS,
            RENODX_TONE_MAP_CONTRAST,
            1.f,
            0.f,
            0.f));
  }

  float3 tonemapped_ap1 = renodx::tonemap::aces::ODT(untonemapped_ap1, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;

  // saturation, blowout, hue correction
  if (RENODX_TONE_MAP_SATURATION != 1.f || RENODX_TONE_MAP_BLOWOUT != 0.f || RENODX_TONE_MAP_HUE_CORRECTION != 0.f) {
    tonemapped_ap1 = renodx::color::ap1::from::BT709(
        renodx::color::grade::UserColorGrading(
            renodx::color::bt709::from::AP1(tonemapped_ap1),
            1.f,
            1.f,
            1.f,
            1.f,
            RENODX_TONE_MAP_SATURATION,
            RENODX_TONE_MAP_BLOWOUT,
            RENODX_TONE_MAP_HUE_CORRECTION,
            renodx::color::bt709::from::AP1(untonemapped_ap1)));
  }

  return tonemapped_ap1;
}

float3 ApplyCustomToneMap(float3 untonemapped_ap1) {
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    return ApplyACESToneMap(untonemapped_ap1);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    return ApplyUserColorGrading(untonemapped_ap1);
  } else {
    return VanillaSDRTonemap(untonemapped_ap1);
  }
}

float3 GameScale(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return color;

  float3 scaled_color = color;
  if (!RENODX_GAMMA_CORRECTION) {  // sRGB
    scaled_color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  } else {  // 2.2
    scaled_color = renodx::color::correct::GammaSafe(scaled_color);
    scaled_color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    scaled_color = renodx::color::correct::GammaSafe(scaled_color, true);
  }
  return scaled_color;
}

float3 UIScale(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return color;

  float3 scaled_color = color;
  if (!RENODX_GAMMA_CORRECTION) {  // sRGB
    scaled_color = renodx::color::srgb::DecodeSafe(scaled_color);
    scaled_color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    scaled_color = renodx::color::srgb::EncodeSafe(scaled_color);
  } else {  // 2.2
    scaled_color = renodx::color::gamma::DecodeSafe(scaled_color, 2.2f);
    scaled_color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    scaled_color = renodx::color::gamma::EncodeSafe(scaled_color, 2.2f);
  }
  return scaled_color;
}
