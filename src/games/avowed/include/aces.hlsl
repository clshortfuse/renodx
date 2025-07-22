#ifndef SRC_SHADERS_LOCAL_ACES_HLSL_
#define SRC_SHADERS_LOCAL_ACES_HLSL_

#include "../shared.h"

namespace local {
namespace tonemap {
namespace aces {

static const float3x3 RRT_SAT_MAT = float3x3(
    0.9708890, 0.0269633, 0.00214758,
    0.0108892, 0.9869630, 0.00214758,
    0.0108892, 0.0269633, 0.96214800);

static const float3x3 ODT_SAT_MAT = float3x3(
    0.949056, 0.0471857, 0.00375827,
    0.019056, 0.9771860, 0.00375827,
    0.019056, 0.0471857, 0.93375800);

static const float3x3 M = float3x3(
    0.5, -1.0, 0.5,
    -1.0, 1.0, 0.0,
    0.5, 0.5, 0.0);

float Rgb2Yc(float3 rgb) {
  const float yc_radius_weight = 1.75;
  // Converts RGB to a luminance proxy, here called YC
  // YC is ~ Y + K * Chroma
  // Constant YC is a cone-shaped surface in RGB space, with the tip on the
  // neutral axis, towards white.
  // YC is normalized: RGB 1 1 1 maps to YC = 1
  //
  // ycRadiusWeight defaults to 1.75, although can be overridden in function
  // call to rgb_2_yc
  // ycRadiusWeight = 1 -> YC for pure cyan, magenta, yellow == YC for neutral
  // of same value
  // ycRadiusWeight = 2 -> YC for pure red, green, blue  == YC for  neutral of
  // same value.

  float r = rgb[0];
  float g = rgb[1];
  float b = rgb[2];

  float chroma = sqrt(b * (b - g) + g * (g - r) + r * (r - b));

  return (b + g + r + yc_radius_weight * chroma) / 3.;
}

float Rgb2Saturation(float3 rgb) {
  float minrgb = min(min(rgb.r, rgb.g), rgb.b);
  float maxrgb = max(max(rgb.r, rgb.g), rgb.b);
  return (max(maxrgb, 1e-10) - max(minrgb, 1e-10)) / max(maxrgb, 1e-2);
}

// Sigmoid function in the range 0 to 1 spanning -2 to +2.
float SigmoidShaper(float x) {
  float t = max(1 - abs(0.5 * x), 0);
  float y = 1 + sign(x) * (1 - t * t);
  return 0.5 * y;
}

float GlowFwd(float yc_in, float glow_gain_in, float glow_mid) {
  float glow_gain_out;

  if (yc_in <= 2. / 3. * glow_mid) {
    glow_gain_out = glow_gain_in;
  } else if (yc_in >= 2 * glow_mid) {
    glow_gain_out = 0;
  } else {
    glow_gain_out = glow_gain_in * (glow_mid / yc_in - 0.5);
  }

  return glow_gain_out;
}

// Transformations from RGB to other color representations
float Rgb2Hue(float3 rgb) {
  const float aces_pi = 3.14159265359f;
  // Returns a geometric hue angle in degrees (0-360) based on RGB values.
  // For neutral colors, hue is undefined and the function will return a quiet NaN value.
  float hue;
  if (rgb.r == rgb.g && rgb.g == rgb.b) {
    hue = 0.0;  // RGB triplets where RGB are equal have an undefined hue
  } else {
    hue = (180.0f / aces_pi) * atan2(sqrt(3.0f) * (rgb.g - rgb.b), 2.0f * rgb.r - rgb.g - rgb.b);
  }

  if (hue < 0.0f) {
    hue = hue + 360.0f;
  }

  return clamp(hue, 0, 360.f);
}

float CenterHue(float hue, float center_h) {
  float hue_centered = hue - center_h;
  if (hue_centered < -180.) {
    hue_centered += 360;
  } else if (hue_centered > 180.) {
    hue_centered -= 360;
  }
  return hue_centered;
}

#define YTOLINCV_GENERATOR(T)                 \
  T YToLinCV(T y, float y_max, float y_min) { \
    return (y - y_min) / (y_max - y_min);     \
  }

YTOLINCV_GENERATOR(float)
YTOLINCV_GENERATOR(float3)
YTOLINCV_GENERATOR(float4)
#undef YTOLINCV_GENERATOR

// Transformations between CIE XYZ tristimulus values and CIE x,y
// chromaticity coordinates
float3 XYZToXyY(float3 xyz) {
  float3 xy_y;
  float divisor = (xyz[0] + xyz[1] + xyz[2]);
  if (divisor == 0.f) divisor = 1e-10f;
  xy_y[0] = xyz[0] / divisor;
  xy_y[1] = xyz[1] / divisor;
  xy_y[2] = xyz[1];

  return xy_y;
}

float3 XyYToXYZ(float3 xy_y) {
  float3 xyz;
  xyz[0] = xy_y[0] * xy_y[2] / max(xy_y[1], 1e-10);
  xyz[1] = xy_y[2];
  xyz[2] = (1.0 - xy_y[0] - xy_y[1]) * xy_y[2] / max(xy_y[1], 1e-10);

  return xyz;
}

static const float DIM_SURROUND_GAMMA = 0.9811;

float3 DarkToDim(float3 xyz, float dim_surround_gamma = DIM_SURROUND_GAMMA) {
  float3 xy_y = XYZToXyY(xyz);
  xy_y.z = clamp(xy_y.z, 0.0, 65504.0f);
  xy_y.z = pow(xy_y.z, DIM_SURROUND_GAMMA);
  return XyYToXYZ(xy_y);
}

static const float MIN_STOP_SDR = -6.5;
static const float MAX_STOP_SDR = 6.5;

static const float MIN_STOP_RRT = -15.0;
static const float MAX_STOP_RRT = 18.0;

static const float MIN_LUM_SDR = 0.02;
static const float MAX_LUM_SDR = 48.0;

static const float MIN_LUM_RRT = 0.0001;
static const float MAX_LUM_RRT = 10000.0;

static const float2x2 MIN_LUM_TABLE = float2x2(
    log10(MIN_LUM_RRT), MIN_STOP_RRT,
    log10(MIN_LUM_SDR), MIN_STOP_SDR);

static const float2x2 MAX_LUM_TABLE = float2x2(
    log10(MAX_LUM_SDR), MAX_STOP_SDR,
    log10(MAX_LUM_RRT), MAX_STOP_RRT);

float Interpolate1D(float2x2 table, float p) {
  if (p < table[0].x) {
    return table[0].y;
  } else if (p >= table[1].x) {
    return table[1].y;
  } else {
    // p = clamp(p, table[0].x, table[1].x);
    float s = (p - table[0].x) / (table[1].x - table[0].x);
    return table[0].y * (1 - s) + table[1].y * s;
  }
}

float3 LinCv2Y(float3 lin_cv, float y_max, float y_min) {
  return lin_cv * (y_max - y_min) + y_min;
}

float LookUpAcesMin(float min_lum_log10) {
  return 0.18 * exp2(Interpolate1D(MIN_LUM_TABLE, min_lum_log10));
}

float LookUpAcesMax(float max_lum_log10) {
  return 0.18 * exp2(Interpolate1D(MAX_LUM_TABLE, max_lum_log10));
}

float SSTS(
    float x,
    float3 y_min, float3 y_mid, float3 y_max,
    float3 coefs_low_a, float3 coefs_low_b,
    float3 coefs_high_a, float3 coefs_high_b) {
  static const uint N_KNOTS_LOW = 4;
  static const uint N_KNOTS_HIGH = 4;

  float coefs_low[6];

  coefs_low[0] = coefs_low_a.x;
  coefs_low[1] = coefs_low_a.y;
  coefs_low[2] = coefs_low_a.z;
  coefs_low[3] = coefs_low_b.x;
  coefs_low[4] = coefs_low_b.y;
  coefs_low[5] = coefs_low_b.z;
  float coefs_high[6];
  coefs_high[0] = coefs_high_a.x;
  coefs_high[1] = coefs_high_a.y;
  coefs_high[2] = coefs_high_a.z;
  coefs_high[3] = coefs_high_b.x;
  coefs_high[4] = coefs_high_b.y;
  coefs_high[5] = coefs_high_b.z;

  // Check for negatives or zero before taking the log. If negative or zero,
  // set to HALF_MIN.
  float log_x = log10(max(x, renodx::math::FLT_MIN));

  float log_y;

  if (log_x > y_max.x) {
    // Above max breakpoint (overshoot)
    // If MAX_PT slope is 0, this is just a straight line and always returns
    // maxLum
    // y = mx+b
    // log_y = computeGraphY(C.Max.z, log_x, (C.Max.y) - (C.Max.z * (C.Max.x)));
    log_y = y_max.y;
  } else if (log_x >= y_mid.x) {
    // Part of Midtones area (Must have slope)
    float knot_coord = (N_KNOTS_HIGH - 1) * (log_x - y_mid.x) / (y_max.x - y_mid.x);
    int j = (int)knot_coord;
    float t = knot_coord - j;

    float3 cf = float3(coefs_high[j], coefs_high[j + 1], coefs_high[j + 2]);

    float3 monomials = float3(t * t, t, 1.0);
    log_y = dot(monomials, mul(M, cf));
  } else if (log_x > y_min.x) {
    float knot_coord = (N_KNOTS_LOW - 1) * (log_x - y_min.x) / (y_mid.x - y_min.x);
    int j = (int)knot_coord;
    float t = knot_coord - j;

    float3 cf = float3(coefs_low[j], coefs_low[j + 1], coefs_low[j + 2]);

    float3 monomials = float3(t * t, t, 1.0);
    log_y = dot(monomials, mul(M, cf));
  } else {  //(log_x <= (C.Min.x))
    // Below min breakpoint (undershoot)
    // log_y = computeGraphY(C.Min.z, log_x, ((C.Min.y) - C.Min.z * (C.Min.x)));
    log_y = y_min.y;
  }

  return pow(10.0, log_y);
}

float3 SSTS(
    float3 x,
    float3 y_min, float3 y_mid, float3 y_max,
    float3 coefs_low_a, float3 coefs_low_b,
    float3 coefs_high_a, float3 coefs_high_b) {
  return float3(
      SSTS(x.r, y_min, y_mid, y_max, coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b),
      SSTS(x.g, y_min, y_mid, y_max, coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b),
      SSTS(x.b, y_min, y_mid, y_max, coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b));
}

float4 SSTS(
    float4 x,
    float3 y_min, float3 y_mid, float3 y_max,
    float3 coefs_low_a, float3 coefs_low_b,
    float3 coefs_high_a, float3 coefs_high_b) {
  return float4(
      SSTS(x.r, y_min, y_mid, y_max, coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b),
      SSTS(x.g, y_min, y_mid, y_max, coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b),
      SSTS(x.b, y_min, y_mid, y_max, coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b),
      SSTS(x.a, y_min, y_mid, y_max, coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b));
}

static const float LIM_CYAN = 1.147f;
static const float LIM_MAGENTA = 1.264f;
static const float LIM_YELLOW = 1.312f;
static const float THR_CYAN = 0.815f;
static const float THR_MAGENTA = 0.803f;
static const float THR_YELLOW = 0.880f;
static const float PWR = 1.2f;

float GamutCompressChannel(float dist, float lim, float thr, float pwr) {
  float compr_dist;
  float scl;
  float nd;
  float p;

  if (dist < thr) {
    compr_dist = dist;  // No compression below threshold
  } else {
    // Calculate scale factor for y = 1 intersect
    scl = (lim - thr) / pow(pow((1.0 - thr) / (lim - thr), -pwr) - 1.0, 1.0 / pwr);

    // Normalize distance outside threshold by scale factor
    nd = (dist - thr) / scl;
    p = pow(nd, pwr);

    compr_dist = thr + scl * nd / (pow(1.0 + p, 1.0 / pwr));  // Compress
  }

  return compr_dist;
}

float3 GamutCompress(float3 lin_ap1) {
  // Achromatic axis
  float ach = max(lin_ap1.r, max(lin_ap1.g, lin_ap1.b));
  float abs_ach = abs(ach);
  // Distance from the achromatic axis for each color component aka inverse RGB ratios
  float3 dist = ach != 0.f ? (ach - lin_ap1) / abs_ach : 0;

  // Compress distance with parameterized shaper function
  float3 compr_dist = float3(
      GamutCompressChannel(dist.r, LIM_CYAN, THR_CYAN, PWR),
      GamutCompressChannel(dist.g, LIM_MAGENTA, THR_MAGENTA, PWR),
      GamutCompressChannel(dist.b, LIM_YELLOW, THR_YELLOW, PWR));

  // Recalculate RGB from compressed distance and achromatic
  float3 compr_lin_ap1 = ach - compr_dist * abs_ach;

  return compr_lin_ap1;
}

float3 RRT(float3 aces) {
  static const float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;

  // --- Glow module --- //
  // "Glow" module constants
  static const float RRT_GLOW_GAIN = 0.05;
  static const float RRT_GLOW_MID = 0.08;
  float saturation = Rgb2Saturation(aces);
  float yc_in = Rgb2Yc(aces);
  const float s = SigmoidShaper((saturation - 0.4) / 0.2);
  float added_glow = 1.0 + GlowFwd(yc_in, RRT_GLOW_GAIN * s, RRT_GLOW_MID);
  aces *= added_glow;

  // --- Red modifier --- //
  // Red modifier constants
  static const float RRT_RED_SCALE = 0.82;
  static const float RRT_RED_PIVOT = 0.03;
  static const float RRT_RED_HUE = 0.;
  static const float RRT_RED_WIDTH = 135.;
  float hue = Rgb2Hue(aces);
  const float centered_hue = CenterHue(hue, RRT_RED_HUE);
  float hue_weight;
  {
    // hueWeight = cubic_basis_shaper(centeredHue, RRT_RED_WIDTH);
    hue_weight = smoothstep(0.0, 1.0, 1.0 - abs(2.0 * centered_hue / RRT_RED_WIDTH));
    hue_weight *= hue_weight;
  }

  aces.r += hue_weight * saturation * (RRT_RED_PIVOT - aces.r) * (1. - RRT_RED_SCALE);

  // --- ACES to RGB rendering space --- //
  aces = clamp(aces, 0, 65535.0f);
  float3 rgb_pre = mul(renodx::color::AP0_TO_AP1_MAT, aces);
  rgb_pre = clamp(rgb_pre, 0, 65504.0f);

  // --- Global desaturation --- //
  // rgbPre = mul( RRT_SAT_MAT, rgbPre);
  static const float RRT_SAT_FACTOR = 0.96f;
  rgb_pre = lerp(dot(rgb_pre, AP1_RGB2Y).xxx, rgb_pre, RRT_SAT_FACTOR);

  return rgb_pre;
}

#define ODT_TONEMAP_GENERATOR(T)                                                                             \
  T ODTToneMap(T rgb_pre, float min_y, float max_y) {                                                        \
    const float min_lum = min_y;                                                                             \
    const float max_lum = max_y;                                                                             \
    /* Aces-dev has more expensive version */                                                                \
    /* AcesParams PARAMS = init_aces_params(minY, maxY); */                                                  \
                                                                                                             \
    static const float2x2 BENDS_LOW_TABLE = float2x2(                                                        \
        MIN_STOP_RRT, 0.18, MIN_STOP_SDR, 0.35);                                                             \
                                                                                                             \
    static const float2x2 BENDS_HIGH_TABLE = float2x2(                                                       \
        MAX_STOP_SDR, 0.89, MAX_STOP_RRT, 0.90);                                                             \
                                                                                                             \
    float min_lum_log10 = log10(min_lum);                                                                    \
    float max_lum_log10 = log10(max_lum);                                                                    \
    const float aces_min = LookUpAcesMin(min_lum_log10);                                                     \
    const float aces_max = LookUpAcesMax(max_lum_log10);                                                     \
    /* float3 MIN_PT = float3(lookup_ACESmin(minLum), minLum, 0.0); */                                       \
    static const float3 MID_PT = float3(0.18, 4.8, 1.55);                                                    \
    /* float3 MAX_PT = float3(lookup_ACESmax(maxLum), maxLum, 0.0); */                                       \
    /* float coefs_low[5]; */                                                                                \
    /* float coefs_high[5]; */                                                                               \
    float3 coefs_low_a;                                                                                      \
    float3 coefs_low_b;                                                                                      \
    float3 coefs_high_a;                                                                                     \
    float3 coefs_high_b;                                                                                     \
                                                                                                             \
    float2 log_min = float2(log10(aces_min), min_lum_log10);                                                 \
    static const float2 LOG_MID = float2(log10(MID_PT.xy));                                                  \
    float2 log_max = float2(log10(aces_max), max_lum_log10);                                                 \
                                                                                                             \
    float knot_inc_low = (LOG_MID.x - log_min.x) / 3.;                                                       \
    /* float halfKnotInc = (logMid.x - log_min.x) / 6.; */                                                   \
                                                                                                             \
    /* Determine two lowest coefficients (straddling minPt) */                                               \
    /* coefs_low[0] = (MIN_PT.z * (log_min.x- 0.5 * knot_inc_low)) + ( log_min.y - MIN_PT.z * log_min.x); */ \
    /* coefs_low[1] = (MIN_PT.z * (log_min.x+ 0.5 * knot_inc_low)) + ( log_min.y - MIN_PT.z * log_min.x); */ \
    /* NOTE: if slope=0, then the above becomes just */                                                      \
    coefs_low_a.x = log_min.y;                                                                               \
    coefs_low_a.y = coefs_low_a.x;                                                                           \
    /* leaving it as a variable for now in case we decide we need non-zero slope extensions */               \
                                                                                                             \
    /* Determine two highest coefficients (straddling midPt) */                                              \
    float min_coef = (LOG_MID.y - MID_PT.z * LOG_MID.x);                                                     \
    coefs_low_b.x = (MID_PT.z * (LOG_MID.x - 0.5 * knot_inc_low)) + (LOG_MID.y - MID_PT.z * LOG_MID.x);      \
    coefs_low_b.y = (MID_PT.z * (LOG_MID.x + 0.5 * knot_inc_low)) + (LOG_MID.y - MID_PT.z * LOG_MID.x);      \
    coefs_low_b.z = coefs_low_b.y;                                                                           \
                                                                                                             \
    /* Middle coefficient (which defines the "sharpness of the bend") is linearly interpolated */            \
    float pct_low = Interpolate1D(BENDS_LOW_TABLE, log2(aces_min / 0.18));                                   \
    coefs_low_a.z = log_min.y + pct_low * (LOG_MID.y - log_min.y);                                           \
                                                                                                             \
    float knot_inc_high = (log_max.x - LOG_MID.x) / 3.0f;                                                    \
    /* float halfKnotInc = (log_max.x - logMid.x) / 6.; */                                                   \
                                                                                                             \
    /* Determine two lowest coefficients (straddling midPt) */                                               \
    /* float minCoef = ( logMid.y - MID_PT.z * logMid.x); */                                                 \
    coefs_high_a.x = (MID_PT.z * (LOG_MID.x - 0.5 * knot_inc_high)) + min_coef;                              \
    coefs_high_a.y = (MID_PT.z * (LOG_MID.x + 0.5 * knot_inc_high)) + min_coef;                              \
                                                                                                             \
    /* Determine two highest coefficients (straddling maxPt) */                                              \
    /* coefs_high[3] = (MAX_PT.z * (log_max.x-0.5*knotIncHigh)) + ( log_max.y - MAX_PT.z * log_max.x); */    \
    /* coefs_high[4] = (MAX_PT.z * (log_max.x+0.5*knotIncHigh)) + ( log_max.y - MAX_PT.z * log_max.x); */    \
    /* NOTE: if slope=0, then the above becomes just */                                                      \
    coefs_high_b.x = log_max.y;                                                                              \
    coefs_high_b.y = coefs_high_b.x;                                                                         \
    coefs_high_b.z = coefs_high_b.y;                                                                         \
    /* leaving it as a variable for now in case we decide we need non-zero slope extensions */               \
                                                                                                             \
    /* Middle coefficient (which defines the "sharpness of the bend") is linearly interpolated */            \
    float pct_high = Interpolate1D(BENDS_HIGH_TABLE, log2(aces_max / 0.18));                                 \
    coefs_high_a.z = LOG_MID.y + pct_high * (log_max.y - LOG_MID.y);                                         \
                                                                                                             \
    T rgb_post =                                                                                             \
        SSTS(rgb_pre,                                                                                        \
             float3(log_min.x, log_min.y, 0),                                                                \
             float3(LOG_MID.x, LOG_MID.y, MID_PT.z),                                                         \
             float3(log_max.x, log_max.y, 0),                                                                \
             coefs_low_a, coefs_low_b,                                                                       \
             coefs_high_a, coefs_high_b);                                                                    \
                                                                                                             \
    /* Nits to Linear */                                                                                     \
    T linear_cv = YToLinCV(rgb_post, max_y, min_y);                                                          \
    return clamp(rgb_post, 0.0, 65535.0f);                                                                   \
  }

ODT_TONEMAP_GENERATOR(float)
ODT_TONEMAP_GENERATOR(float3)
ODT_TONEMAP_GENERATOR(float4)
#undef ODT_TONEMAP_GENERATOR

float3 ODT(float3 rgb_pre, float min_y, float max_y, float3x3 odt_matrix = renodx::color::AP1_TO_BT709_MAT) {
  float3 tonescaled = ODTToneMap(rgb_pre, min_y, max_y);

  float3 output_color = mul(odt_matrix, tonescaled);

  return output_color;
}

float4 ODT(float4 rgb_pre, float min_y, float max_y, float3x3 odt_matrix = renodx::color::AP1_TO_BT709_MAT) {
  float4 tonescaled = ODTToneMap(rgb_pre, min_y, max_y);

  float4 output_color = float4(mul(odt_matrix, tonescaled.rgb), tonescaled.a);

  return output_color;
}

float ODT(float rgb_pre, float min_y, float max_y) {
  float tonescaled = ODTToneMap(rgb_pre, min_y, max_y);

  float output_color = tonescaled;

  return output_color;
}

// ACES with
// Reference Rendering Transform
// Output Display Transform
float3 RRTAndODT(float3 color, float min_y, float max_y, float3x3 odt_matrix = renodx::color::AP1_TO_BT709_MAT) {
  color = mul(renodx::color::BT709_TO_AP0_MAT, color);
  color = RRT(color);
  color = ODT(color, min_y, max_y, odt_matrix);
  return color;
}

// ACES for Scene-Linear BT709 with:
// Reference Gamma Compression
// Reference Rendering Transform
// Output Display Transform
float3 RGCAndRRTAndODT(float3 color, float min_y, float max_y, float3x3 odt_matrix = renodx::color::AP1_TO_BT709_MAT) {
  color = mul(renodx::color::BT709_TO_AP1_MAT, color);  // BT709 to AP1
  color = GamutCompress(color);                         // Compresses to AP1
  color = mul(renodx::color::AP1_TO_AP0_MAT, color);    // Convert to AP0
  color = RRT(color);                                   // RRT AP0 => AP1
  color = ODT(color, min_y, max_y, odt_matrix);         // ODT AP1 => Matrix
  return color;
}
}  // namespace aces
}  // namespace tonemap
}  // namespace local

#endif  // SRC_SHADERS_LOCAL_ACES_HLSL_
