#include "./shared.h"

static const float3x3 ACES_to_ACEScg_MAT = float3x3(
    1.4514393161f, -0.2365107469f, -0.2149285693f,
    -0.0765537734f, 1.1762296998f, -0.0996759264f,
    0.0083161484f, -0.0060324498f, 0.9977163014f);

static const float3x3 SRGB_to_ACES_MAT = float3x3(
    0.4397010, 0.3829780, 0.1773350,
    0.0897923, 0.8134230, 0.0967616,
    0.0175440, 0.1115440, 0.8707040);

static const float3x3 ACES_to_SRGB_MAT = float3x3(
    2.52169, -1.13413, -0.38756,
    -0.27648, 1.37272, -0.09624,
    -0.01538, -0.15298, 1.16835);

float acesccEncode(float x) {
  return (x < 0.00003051757) ? (log2(0.00001525878 + x * 0.5) + 9.72) / 17.52 : (log2(x) + 9.72) / 17.52;
}

float3 acesccEncode(float3 x) {
  x = max(x, 0.0);
  x = min(x, renodx::math::FLT16_MAX);
  x.r = acesccEncode(x.r);
  x.g = acesccEncode(x.g);
  x.b = acesccEncode(x.b);
  return x;
}

float3 RRT(float3 aces) {
  static const float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;

  // --- Glow module --- //
  // "Glow" module constants
  static const float RRT_GLOW_GAIN = 0.05;
  static const float RRT_GLOW_MID = 0.08;
  float saturation = renodx::tonemap::aces::Rgb2Saturation(aces);
  float yc_in = renodx::tonemap::aces::Rgb2Yc(aces);
  const float s = renodx::tonemap::aces::SigmoidShaper((saturation - 0.4) / 0.2);
  float added_glow = 1.0 + renodx::tonemap::aces::GlowFwd(yc_in, RRT_GLOW_GAIN * s, RRT_GLOW_MID);
  aces *= added_glow;

  // --- Red modifier --- //
  // Red modifier constants
  static const float RRT_RED_SCALE = 0.82;
  static const float RRT_RED_PIVOT = 0.03;
  static const float RRT_RED_HUE = 0.;
  static const float RRT_RED_WIDTH = 135.;
  float hue = renodx::tonemap::aces::Rgb2Hue(aces);
  const float centered_hue = renodx::tonemap::aces::CenterHue(hue, RRT_RED_HUE);
  float hue_weight;
  {
    // hueWeight = cubic_basis_shaper(centeredHue, RRT_RED_WIDTH);
    hue_weight = smoothstep(0.0, 1.0, 1.0 - abs(2.0 * centered_hue / RRT_RED_WIDTH));
    hue_weight *= hue_weight;
  }

  aces.r += hue_weight * saturation * (RRT_RED_PIVOT - aces.r) * (1. - RRT_RED_SCALE);

  // --- ACES to RGB rendering space --- //
  aces = clamp(aces, 0, 65535.0f);
  float3 rgb_pre = mul(ACES_to_ACEScg_MAT, aces);
  rgb_pre = clamp(rgb_pre, 0, 65504.0f);

  // --- Global desaturation --- //
  // rgbPre = mul( RRT_SAT_MAT, rgbPre);
  static const float RRT_SAT_FACTOR = 0.96f;
  rgb_pre = lerp(dot(rgb_pre, AP1_RGB2Y).xxx, rgb_pre, RRT_SAT_FACTOR);

  return rgb_pre;
}

float3 Ap1Aces(float3 color, int curve, float DSG) {
  float a;
  float b;
  float c;
  float d;
  float e;
  if (curve == 0) { // Unity v2
    a = 278.5085;
    b = 10.7772;
    c = 293.6045;
    d = 88.7122;
    e = 80.6889;
  } else if (curve == 1) {  // Unity v1
    a = 2.785085;
    b = 0.107772;
    c = 2.936045;
    d = 0.887122;
    e = 0.806889;
  } else if (curve == 2) {  // Stephen Hill
    a = 0.0245786;
    b = 0.000090537;
    c = 0.983729;
    d = 0.4329510;
    e = 0.238081;
  } else {  // Narkowicz
    a = 2.51;
    b = 0.03;
    c = 2.43;
    d = 0.59;
    e = 0.14;
  }
  color = RRT(color);
  float3 sdrCurve;
    if (curve == 2) {
        sdrCurve = (color * (color + a) - b) / (color * (c * color + d) + e);
        sdrCurve = max(0, sdrCurve);
    } else if (curve == 3){
      sdrCurve = (color * (a * color + b)) / (color * (c * color + d) + e);
    } else {
        sdrCurve = (color * (a * color + b)) / (color * (c * color + d) + e);
    }
  float3 sdr_color = mul(renodx::color::AP1_TO_XYZ_MAT, sdrCurve);
  sdr_color = renodx::tonemap::aces::DarkToDim(sdr_color, DSG);
  sdr_color = mul(renodx::color::XYZ_TO_AP1_MAT, sdr_color);
  float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;
  sdr_color = lerp(dot(color, AP1_RGB2Y).rrr, sdr_color, 0.93);
  if (curve == 3 ) {
    sdr_color = renodx::color::bt709::from::AP1(sdr_color);
  } else {
    sdr_color = mul(renodx::color::AP1_TO_XYZ_MAT, sdr_color);
    sdr_color = mul(renodx::color::D60_TO_D65_MAT, sdr_color);
    sdr_color = mul(renodx::color::XYZ_TO_BT709_MAT, sdr_color);
  }
  return sdr_color;
}

float3 Ap1AcesExtended(float3 color, int curve, float DSG) {
  float a;
  float b;
  float c;
  float d;
  float e;
  if (curve == 0) { // Unity v2
    a = 278.5085;
    b = 10.7772;
    c = 293.6045;
    d = 88.7122;
    e = 80.6889;
  } else if (curve == 1) {  // Unity v1
    a = 2.785085;
    b = 0.107772;
    c = 2.936045;
    d = 0.887122;
    e = 0.806889;
  } else if (curve == 2) {  // Stephen Hill
    a = 0.0245786;
    b = 0.000090537;
    c = 0.983729;
    d = 0.4329510;
    e = 0.238081;
  } else {  // Narkowicz
    a = 2.51;
    b = 0.03;
    c = 2.43;
    d = 0.59;
    e = 0.14;
  }
  color = RRT(color);
  float3 hdrCurve;
    if (curve == 2) {
      //hdrCurve = color > 0.47399 ? 0.733076360295 * color + 0.0081270771627 : max(0.f, (color * (color + a) - b) / (color * (c * color + d) + e));
      hdrCurve = renodx::math::Select(color > 0.47399, 0.733076360295 * color + 0.0081270771627, max(0.f, (color * (color + a) - b) / (color * (c * color + d) + e)));
    } else if (curve == 3){
      //hdrCurve = color > 0.230976 ? 1.46658788438 * color + 0.00821561635884 : (color * (a * color + b)) / (color * (c * color + d) + e);
      hdrCurve = renodx::math::Select(color > 0.230976, 1.46658788438 * color + 0.00821561635884, (color * (a * color + b)) / (color * (c * color + d) + e));
    } else {
      //hdrCurve = color > 0.499412 ? 0.73014784681 * color + 0.0129418403546 : (color * (a * color + b)) / (color * (c * color + d) + e);
      hdrCurve = renodx::math::Select(color > 0.499412, 0.73014784681 * color + 0.0129418403546, (color * (a * color + b)) / (color * (c * color + d) + e));
    }
  float3 hdr_color = mul(renodx::color::AP1_TO_XYZ_MAT, hdrCurve);
  hdr_color = renodx::tonemap::aces::DarkToDim(hdr_color, DSG);
  hdr_color = mul(renodx::color::XYZ_TO_AP1_MAT, hdr_color);
  float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;
  hdr_color = lerp(dot(color, AP1_RGB2Y).rrr, hdr_color, 0.93);
  if (curve == 3 ) {
    hdr_color = renodx::color::bt709::from::AP1(hdr_color);
  } else {
    hdr_color = mul(renodx::color::AP1_TO_XYZ_MAT, hdr_color);
    hdr_color = mul(renodx::color::D60_TO_D65_MAT, hdr_color);
    hdr_color = mul(renodx::color::XYZ_TO_BT709_MAT, hdr_color);
  }
  return hdr_color;
}

// Stephen Hill
float3 SHAcesTonemap(float3 color, float pre_exposure = 1.f, float post_exposure = 1.f){
  bool extended = RENODX_TONE_MAP_TYPE != 0.f;
  // sRGB => XYZ => D65_2_D60 => AP1 => RRT_SAT
  const float3x3 ACESInputMat = {
    { 0.59719, 0.35458, 0.04823 },
    { 0.07600, 0.90834, 0.01566 },
    { 0.02840, 0.13383, 0.83777 }
  };
  // ODT_SAT => XYZ => D60_2_D65 => sRGB
  const float3x3 ACESOutputMat = {
    { 1.60475, -0.53108, -0.07367 },
    { -0.10208, 1.10813, -0.00605 },
    { -0.00327, -0.07276, 1.07602 }
  };
  color = pre_exposure * color;
  color = mul(ACESInputMat, color);
  float3 sdr_curve = (color * (color + 0.0245786f) - 0.000090537f) / (color * (0.983729f * color + 0.4329510f) + 0.238081f);
  if(!extended){
    return sdr_curve;
  } else {
    //color = color > 0.47399 ? 0.733076360295 * color + 0.0081270771627 : sdr_curve;
    color = renodx::math::Select(color > 0.47399, 0.733076360295 * color + 0.0081270771627, sdr_curve);
  }
  color = mul(ACESOutputMat, color);
  color = post_exposure * color;
  return color;
}