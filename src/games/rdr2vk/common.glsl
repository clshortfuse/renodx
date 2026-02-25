#include "./shared.h"

// START INCLUDES

// --- sRGB ENCODING ---
float EncodeSRGB(float x) {
  return mix(
      x * 12.92,
      1.055 * pow(x, 1.0 / 2.4) - 0.055,
      step(0.0031308, x));
}

vec3 EncodeSRGB(vec3 x) {
  return mix(
      x * 12.92,
      1.055 * pow(x, vec3(1.0 / 2.4)) - 0.055,
      step(vec3(0.0031308), x));
}

// --- sRGB DECODING ---
float DecodeSRGB(float x) {
  return mix(
      x / 12.92,
      pow((x + 0.055) / 1.055, 2.4),
      step(0.04045, x));
}

vec3 DecodeSRGB(vec3 x) {
  return mix(
      x / 12.92,
      pow((x + 0.055) / 1.055, vec3(2.4)),
      step(vec3(0.04045), x));
}

// --- GAMMA ENCODING ---
float EncodeGamma(float x, float gamma) {
  return pow(x, 1.0 / gamma);
}

vec3 EncodeGamma(vec3 x, float gamma) {
  return pow(x, vec3(1.0 / gamma));
}

// --- GAMMA DECODING ---
float DecodeGamma(float x, float gamma) {
  return pow(x, gamma);
}

vec3 DecodeGamma(vec3 x, float gamma) {
  return pow(x, vec3(gamma));
}

// Fix or undo gamma mismatch by converting between sRGB and gamma 2.2
float CorrectGammaMismatch(float x, bool inverse) {
  return inverse
             ? DecodeSRGB(EncodeGamma(x, 2.2))   // undo fix
             : DecodeGamma(EncodeSRGB(x), 2.2);  // apply fix
}

vec3 CorrectGammaMismatch(vec3 x, bool inverse) {
  vec3 s = sign(x);
  vec3 a = abs(x);

  vec3 result = inverse
                    ? DecodeSRGB(EncodeGamma(a, 2.2))
                    : DecodeGamma(EncodeSRGB(a), 2.2);

  return s * result;
}

const mat3 BT709_TO_BT2020_MAT = mat3(
    vec3(0.6274039149284363, 0.06909728795289993, 0.0163914393633604),
    vec3(0.3292830288410187, 0.9195404052734375, 0.08801330626010895),
    vec3(0.04331306740641594, 0.01136231515556574, 0.8955952525138855));

const mat3 BT2020_TO_BT709_MAT = mat3(
    vec3(1.6604909896850586, -0.12455047667026520, -0.01815076358616352),
    vec3(-0.5876411199569702, 1.1328998804092407, -0.10057889670133591),
    vec3(-0.07284986227750778, -0.00834942236542702, 1.1187297105789185));

vec3 BT2020FromBT709(vec3 bt709) {
  return BT709_TO_BT2020_MAT * bt709;
}

vec3 BT709FromBT2020(vec3 bt2020) {
  return BT2020_TO_BT709_MAT * bt2020;
}

// START ACES INCLUDE

// color conversion matrices
const mat3 BT709_TO_XYZ_MAT = mat3(
    vec3(0.4123907993, 0.2126390059, 0.0193308187),
    vec3(0.3575843394, 0.7151686788, 0.1191947798),
    vec3(0.1804807884, 0.0721923154, 0.9505321522));

const mat3 XYZ_TO_BT709_MAT = mat3(
    vec3(3.2409699419, -0.9692436363, 0.0556300797),
    vec3(-1.5373831776, 1.8759675015, -0.2039769589),
    vec3(-0.4986107603, 0.0415550574, 1.0569715142));

const mat3 BT2020_TO_XYZ_MAT = mat3(
    vec3(0.6369580483, 0.2627002120, 0.0000000000),
    vec3(0.1446169036, 0.6779980715, 0.0280726930),
    vec3(0.1688809752, 0.0593017165, 1.0609850577));

const mat3 XYZ_TO_BT2020_MAT = mat3(
    vec3(1.7166511880, -0.6666843518, 0.0176398574),
    vec3(-0.3556707838, 1.6164812366, -0.0427706133),
    vec3(-0.2533662814, 0.0157685458, 0.9421031212));

const mat3 AP0_TO_XYZ_MAT = mat3(
    vec3(0.9525523959, 0.3439664498, 0.0000000000),
    vec3(0.0000000000, 0.7281660966, 0.0000000000),
    vec3(0.0000936786, -0.0721325464, 1.0088251844));

const mat3 XYZ_TO_AP0_MAT = mat3(
    vec3(1.0498110175, -0.4959030231, 0.0000000000),
    vec3(0.0000000000, 1.3733130458, 0.0000000000),
    vec3(-0.0000974845, 0.0982400361, 0.9912520182));

const mat3 AP1_TO_XYZ_MAT = mat3(
    vec3(0.6624541811, 0.2722287168, -0.0055746495),
    vec3(0.1340042065, 0.6740817658, 0.0040607335),
    vec3(0.1561876870, 0.0536895174, 1.0103391003));

const mat3 XYZ_TO_AP1_MAT = mat3(
    vec3(1.6410233797, -0.6636628587, 0.0117218943),
    vec3(-0.3248032942, 1.6153315917, -0.0082844420),
    vec3(-0.2364246952, 0.0167563477, 0.9883948585));

// With Bradford
const mat3 AP1_TO_BT709_MAT = mat3(
    vec3(1.7050509927, -0.1302564175, -0.0240033568),
    vec3(-0.6217921207, 1.1408047366, -0.1289689761),
    vec3(-0.0832588720, -0.0105483191, 1.1529723329));

// With Bradford
const mat3 AP1_TO_BT2020_MAT = mat3(
    vec3(1.0258247477, -0.0022343695, -0.0050133515),
    vec3(-0.0200531908, 1.0045865019, -0.0252900718),
    vec3(-0.0057715568, -0.0023521324, 1.0303034233));

const mat3 BT709_TO_AP1_MAT = mat3(
    vec3(0.6130974024, 0.0701937225, 0.0206155929),
    vec3(0.3395231462, 0.9163538791, 0.1095697729),
    vec3(0.0473794514, 0.0134523985, 0.8698146342));

// With Bradford
const mat3 BT2020_TO_AP1_MAT = mat3(
    vec3(0.9748949779, 0.0021795628, 0.0047972397),
    vec3(0.0195991086, 0.9955354689, 0.0245320166),
    vec3(0.0055059134, 0.0022849683, 0.9706707437));

// chromatic adaptation method: von Kries
// chromatic adaptation transform: Bradford
const mat3 D65_TO_D60_CAT = mat3(
    vec3(1.01303493, 0.00769822997, -0.00284131732),
    vec3(0.00610525766, 0.998163342, 0.00468515651),
    vec3(-0.0149709433, -0.00503203831, 0.924506127));

// chromatic adaptation method: von Kries
// chromatic adaptation transform: Bradford
const mat3 D60_TO_D65_MAT = mat3(
    vec3(0.987223982, -0.00759837171, 0.00307257706),
    vec3(-0.00611322838, 1.00186145, -0.00509596150),
    vec3(0.0159532874, 0.00533003592, 1.08168065));

const mat3 AP1_TO_BT709D60_MAT = XYZ_TO_BT709_MAT * AP1_TO_XYZ_MAT;
const mat3 AP1_TO_BT2020D60_MAT = XYZ_TO_BT2020_MAT * AP1_TO_XYZ_MAT;
const mat3 AP1_TO_AP1D65_MAT = XYZ_TO_AP1_MAT * (D60_TO_D65_MAT * AP1_TO_XYZ_MAT);

const mat3 BT709_TO_AP0_MAT = XYZ_TO_AP0_MAT * (D65_TO_D60_CAT * BT709_TO_XYZ_MAT);

const mat3 AP0_TO_AP1_MAT = XYZ_TO_AP1_MAT * AP0_TO_XYZ_MAT;
const mat3 AP1_TO_AP0_MAT = XYZ_TO_AP0_MAT * AP1_TO_XYZ_MAT;

const mat3 RRT_SAT_MAT = mat3(
    vec3(0.9708890, 0.0108892, 0.0108892),
    vec3(0.0269633, 0.9869630, 0.0269633),
    vec3(0.00214758, 0.00214758, 0.96214800));

const mat3 ODT_SAT_MAT = mat3(
    vec3(0.949056, 0.019056, 0.019056),
    vec3(0.0471857, 0.9771860, 0.0471857),
    vec3(0.00375827, 0.00375827, 0.93375800));

const mat3 M = mat3(
    vec3(0.5, -1.0, 0.5),
    vec3(-1.0, 1.0, 0.5),
    vec3(0.5, 0.0, 0.0));

// Define log10 function for single float
float log10(float x) {
  return log(x) / log(10.0);
}

// Define log10 function for vec2
vec2 log10(vec2 v) {
  return log(v) / log(10.0);
}

float Rgb2Yc(vec3 rgb) {
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

  return (b + g + r + yc_radius_weight * chroma) / 3.0;
}

float Rgb2Saturation(vec3 rgb) {
  float minrgb = min(min(rgb.r, rgb.g), rgb.b);
  float maxrgb = max(max(rgb.r, rgb.g), rgb.b);
  return (max(maxrgb, 1e-10) - max(minrgb, 1e-10)) / max(maxrgb, 1e-2);
}

// Sigmoid function in the range 0 to 1 spanning -2 to +2.
float SigmoidShaper(float x) {
  float t = max(1.0 - abs(0.5 * x), 0.0);
  float y = 1.0 + sign(x) * (1.0 - t * t);
  return 0.5 * y;
}

float GlowFwd(float yc_in, float glow_gain_in, float glow_mid) {
  float glow_gain_out;

  if (yc_in <= 2.0 / 3.0 * glow_mid) {
    glow_gain_out = glow_gain_in;
  } else if (yc_in >= 2.0 * glow_mid) {
    glow_gain_out = 0.0;
  } else {
    glow_gain_out = glow_gain_in * (glow_mid / yc_in - 0.5);
  }

  return glow_gain_out;
}

// Transformations from RGB to other color representations
float Rgb2Hue(vec3 rgb) {
  const float aces_pi = 3.14159265359;
  // Returns a geometric hue angle in degrees (0-360) based on RGB values.
  // For neutral colors, hue is undefined and the function will return a quiet NaN value.
  float hue;
  if (rgb.r == rgb.g && rgb.g == rgb.b) {
    hue = 0.0;  // RGB triplets where RGB are equal have an undefined hue
  } else {
    hue = (180.0 / aces_pi) * atan(sqrt(3.0) * (rgb.g - rgb.b), 2.0 * rgb.r - rgb.g - rgb.b);
  }

  if (hue < 0.0) {
    hue = hue + 360.0;
  }

  return clamp(hue, 0.0, 360.0);
}

float CenterHue(float hue, float center_h) {
  float hue_centered = hue - center_h;
  if (hue_centered < -180.0) {
    hue_centered += 360.0;
  } else if (hue_centered > 180.0) {
    hue_centered -= 360.0;
  }
  return hue_centered;
}

vec3 YToLinCV(vec3 y, float y_max, float y_min) {
  return (y - y_min) / (y_max - y_min);
}

vec4 YToLinCV(vec4 y, float y_max, float y_min) {
  return (y - y_min) / (y_max - y_min);
}

// Transformations between CIE XYZ tristimulus values and CIE x,y
// chromaticity coordinates
vec3 XYZToXyY(vec3 xyz) {
  vec3 xy_y;
  float divisor = (xyz[0] + xyz[1] + xyz[2]);
  if (divisor == 0.0)
    divisor = 1e-10;
  xy_y[0] = xyz[0] / divisor;
  xy_y[1] = xyz[1] / divisor;
  xy_y[2] = xyz[1];

  return xy_y;
}

vec3 XyYToXYZ(vec3 xy_y) {
  vec3 xyz;
  xyz[0] = xy_y[0] * xy_y[2] / max(xy_y[1], 1e-10);
  xyz[1] = xy_y[2];
  xyz[2] = (1.0 - xy_y[0] - xy_y[1]) * xy_y[2] / max(xy_y[1], 1e-10);

  return xyz;
}

const float DIM_SURROUND_GAMMA = 0.9811;

vec3 DarkToDim(vec3 xyz, float dim_surround_gamma) {
  vec3 xy_y = XYZToXyY(xyz);
  xy_y.z = clamp(xy_y.z, 0.0, 65504.0);
  xy_y.z = pow(xy_y.z, DIM_SURROUND_GAMMA);
  return XyYToXYZ(xy_y);
}

const float MIN_STOP_SDR = -6.5;
const float MAX_STOP_SDR = 6.5;

const float MIN_STOP_RRT = -15.0;
const float MAX_STOP_RRT = 18.0;

const float MIN_LUM_SDR = 0.02;
const float MAX_LUM_SDR = 48.0;

const float MIN_LUM_RRT = 0.0001;
const float MAX_LUM_RRT = 10000.0;

const mat2 MIN_LUM_TABLE = mat2(
    -4.0000000, -1.6989700, /* log10(0.0001), log10(0.02)  */
    MIN_STOP_RRT, MIN_STOP_SDR);

const mat2 MAX_LUM_TABLE = mat2(
    1.6812413, 4.0000000, /* log10(48.0),   log10(10000) */
    MAX_STOP_SDR, MAX_STOP_RRT);

float Interpolate1D(mat2 table, float p) {
  float x0 = table[0][0];
  float x1 = table[0][1];
  float y0 = table[1][0];
  float y1 = table[1][1];

  if (p < x0) return y0;
  if (p >= x1) return y1;

  float s = (p - x0) / (x1 - x0);  // 0-to-1 mix factor
  return mix(y0, y1, s);
}

vec3 LinCv2Y(vec3 lin_cv, float y_max, float y_min) {
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
    vec3 y_min, vec3 y_mid, vec3 y_max,
    vec3 coefs_low_a, vec3 coefs_low_b,
    vec3 coefs_high_a, vec3 coefs_high_b) {
  const int N_KNOTS_LOW = 4;
  const int N_KNOTS_HIGH = 4;

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
  float log_x = log10(max(x, 1.17549435082228750797e-38));  // equivalent to asfloat(0x00800000)

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
    float knot_coord = float(N_KNOTS_HIGH - 1) * (log_x - y_mid.x) / (y_max.x - y_mid.x);
    int j = int(knot_coord);
    float t = knot_coord - float(j);

    vec3 cf = vec3(coefs_high[j], coefs_high[j + 1], coefs_high[j + 2]);

    vec3 monomials = vec3(t * t, t, 1.0);
    log_y = dot(monomials, M * cf);
  } else if (log_x > y_min.x) {
    float knot_coord = float(N_KNOTS_LOW - 1) * (log_x - y_min.x) / (y_mid.x - y_min.x);
    int j = int(knot_coord);
    float t = knot_coord - float(j);

    vec3 cf = vec3(coefs_low[j], coefs_low[j + 1], coefs_low[j + 2]);

    vec3 monomials = vec3(t * t, t, 1.0);
    log_y = dot(monomials, M * cf);
  } else {  //(log_x <= (C.Min.x))
    // Below min breakpoint (undershoot)
    // log_y = computeGraphY(C.Min.z, log_x, ((C.Min.y) - C.Min.z * (C.Min.x)));
    log_y = y_min.y;
  }

  return pow(10.0, log_y);
}

const float LIM_CYAN = 1.147;
const float LIM_MAGENTA = 1.264;
const float LIM_YELLOW = 1.312;
const float THR_CYAN = 0.815;
const float THR_MAGENTA = 0.803;
const float THR_YELLOW = 0.880;
const float PWR = 1.2;

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

vec3 GamutCompress(vec3 lin_ap1) {
  // Achromatic axis
  float ach = max(lin_ap1.r, max(lin_ap1.g, lin_ap1.b));
  float abs_ach = abs(ach);
  // Distance from the achromatic axis for each color component aka inverse RGB ratios
  vec3 dist = ach != 0.0 ? (ach - lin_ap1) / abs_ach : vec3(0.0);

  // Compress distance with parameterized shaper function
  vec3 compr_dist = vec3(
      GamutCompressChannel(dist.r, LIM_CYAN, THR_CYAN, PWR),
      GamutCompressChannel(dist.g, LIM_MAGENTA, THR_MAGENTA, PWR),
      GamutCompressChannel(dist.b, LIM_YELLOW, THR_YELLOW, PWR));

  // Recalculate RGB from compressed distance and achromatic
  vec3 compr_lin_ap1 = ach - compr_dist * abs_ach;

  return compr_lin_ap1;
}

vec3 RRT(vec3 aces) {
  const vec3 AP1_RGB2Y = vec3(0.2722287168, 0.6740817658, 0.0536895174);

  // --- Glow module --- //
  // "Glow" module constants
  const float RRT_GLOW_GAIN = 0.05;
  const float RRT_GLOW_MID = 0.08;
  float saturation = Rgb2Saturation(aces);
  float yc_in = Rgb2Yc(aces);
  const float s = SigmoidShaper((saturation - 0.4) / 0.2);
  float added_glow = 1.0 + GlowFwd(yc_in, RRT_GLOW_GAIN * s, RRT_GLOW_MID);
  aces *= added_glow;

  // --- Red modifier --- //
  // Red modifier constants
  const float RRT_RED_SCALE = 0.82;
  const float RRT_RED_PIVOT = 0.03;
  const float RRT_RED_HUE = 0.0;
  const float RRT_RED_WIDTH = 135.0;
  float hue = Rgb2Hue(aces);
  const float centered_hue = CenterHue(hue, RRT_RED_HUE);
  float hue_weight;
  {
    // hueWeight = cubic_basis_shaper(centeredHue, RRT_RED_WIDTH);
    hue_weight = smoothstep(0.0, 1.0, 1.0 - abs(2.0 * centered_hue / RRT_RED_WIDTH));
    hue_weight *= hue_weight;
  }

  aces.r += hue_weight * saturation * (RRT_RED_PIVOT - aces.r) * (1.0 - RRT_RED_SCALE);

  // --- ACES to RGB rendering space --- //
  aces = clamp(aces, 0.0, 65535.0);
  vec3 rgb_pre = AP0_TO_AP1_MAT * aces;
  rgb_pre = clamp(rgb_pre, 0.0, 65504.0);

  // --- Global desaturation --- //
  // rgb_pre = RRT_SAT_MAT * rgb_pre;
  const float RRT_SAT_FACTOR = 0.96;
  rgb_pre = mix(vec3(dot(rgb_pre, AP1_RGB2Y)), rgb_pre, RRT_SAT_FACTOR);

  return rgb_pre;
}

vec3 ODTToneMap(vec3 rgb_pre, float min_y, float max_y) {
  // Aces-dev has more expensive version
  // AcesParams PARAMS = init_aces_params(minY, maxY);

  const mat2 BENDS_LOW_TABLE = mat2(
      MIN_STOP_RRT, MIN_STOP_SDR,
      0.18, 0.35);

  const mat2 BENDS_HIGH_TABLE = mat2(
      MAX_STOP_SDR, MAX_STOP_RRT,
      0.89, 0.90);

  float min_lum_log10 = log10(min_y);
  float max_lum_log10 = log10(max_y);
  float aces_min = LookUpAcesMin(min_lum_log10);
  float aces_max = LookUpAcesMax(max_lum_log10);

  // float3 MIN_PT = vec3(lookup_ACESmin(minLum), minLum, 0.0);
  const vec3 MID_PT = vec3(0.18, 4.8, 1.55);
  // float3 MAX_PT = vec3(lookup_ACESmax(maxLum), maxLum, 0.0);

  vec3 coefs_low_a;
  vec3 coefs_low_b;
  vec3 coefs_high_a;
  vec3 coefs_high_b;

  vec2 log_min = vec2(log10(aces_min), min_lum_log10);
  vec2 LOG_MID = vec2(log10(MID_PT.xy));
  vec2 log_max = vec2(log10(aces_max), max_lum_log10);

  float knot_inc_low = (LOG_MID.x - log_min.x) / 3.0;

  // Determine two lowest coefficients (straddling minPt)
  coefs_low_a.x = log_min.y;
  coefs_low_a.y = coefs_low_a.x;

  // Determine two highest coefficients (straddling midPt)
  float min_coef = (LOG_MID.y - MID_PT.z * LOG_MID.x);
  coefs_low_b.x = (MID_PT.z * (LOG_MID.x - 0.5 * knot_inc_low)) + (LOG_MID.y - MID_PT.z * LOG_MID.x);
  coefs_low_b.y = (MID_PT.z * (LOG_MID.x + 0.5 * knot_inc_low)) + (LOG_MID.y - MID_PT.z * LOG_MID.x);
  coefs_low_b.z = coefs_low_b.y;

  // Middle coefficient (which defines the "sharpness of the bend") is linearly interpolated
  float pct_low = Interpolate1D(BENDS_LOW_TABLE, log2(aces_min / 0.18));
  coefs_low_a.z = log_min.y + pct_low * (LOG_MID.y - log_min.y);

  float knot_inc_high = (log_max.x - LOG_MID.x) / 3.0;

  // Determine two lowest coefficients (straddling midPt)
  // float minCoef = ( logMid.y - MID_PT.z * logMid.x);
  coefs_high_a.x = (MID_PT.z * (LOG_MID.x - 0.5 * knot_inc_high)) + min_coef;
  coefs_high_a.y = (MID_PT.z * (LOG_MID.x + 0.5 * knot_inc_high)) + min_coef;

  // Determine two highest coefficients (straddling maxPt)
  // coefs_high[3] = (MAX_PT.z * (log_max.x-0.5*knotIncHigh)) + ( log_max.y - MAX_PT.z * log_max.x);
  // coefs_high[4] = (MAX_PT.z * (log_max.x+0.5*knotIncHigh)) + ( log_max.y - MAX_PT.z * log_max.x);
  // NOTE: if slope=0, then the above becomes just
  coefs_high_b.x = log_max.y;
  coefs_high_b.y = coefs_high_b.x;
  coefs_high_b.z = coefs_high_b.y;
  // leaving it as a variable for now in case we decide we need non-zero slope extensions

  // Middle coefficient (which defines the "sharpness of the bend") is linearly interpolated

  float pct_high = Interpolate1D(BENDS_HIGH_TABLE, log2(aces_max / 0.18));
  coefs_high_a.z = LOG_MID.y + pct_high * (log_max.y - LOG_MID.y);

  vec3 rgb_post = vec3(
      SSTS(rgb_pre.x, vec3(log_min.x, log_min.y, 0.0), vec3(LOG_MID.x, LOG_MID.y, MID_PT.z), vec3(log_max.x, log_max.y, 0.0), coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b),
      SSTS(rgb_pre.y, vec3(log_min.x, log_min.y, 0.0), vec3(LOG_MID.x, LOG_MID.y, MID_PT.z), vec3(log_max.x, log_max.y, 0.0), coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b),
      SSTS(rgb_pre.z, vec3(log_min.x, log_min.y, 0.0), vec3(LOG_MID.x, LOG_MID.y, MID_PT.z), vec3(log_max.x, log_max.y, 0.0), coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b));

  // Nits to Linear
  vec3 linear_cv = YToLinCV(rgb_post, max_y, min_y);
  return clamp(rgb_post, 0.0, 65535.0);
}

vec4 ODTToneMap(vec4 rgb_pre, float min_y, float max_y) {
  // Aces-dev has more expensive version
  // AcesParams PARAMS = init_aces_params(minY, maxY);

  const mat2 BENDS_LOW_TABLE = mat2(
      MIN_STOP_RRT, MIN_STOP_SDR,
      0.18, 0.35);

  const mat2 BENDS_HIGH_TABLE = mat2(
      MAX_STOP_SDR, MAX_STOP_RRT,
      0.89, 0.90);

  float min_lum_log10 = log10(min_y);
  float max_lum_log10 = log10(max_y);
  float aces_min = LookUpAcesMin(min_lum_log10);
  float aces_max = LookUpAcesMax(max_lum_log10);

  // float3 MIN_PT = vec3(lookup_ACESmin(minLum), minLum, 0.0);
  const vec3 MID_PT = vec3(0.18, 4.8, 1.55);
  // float3 MAX_PT = vec3(lookup_ACESmax(maxLum), maxLum, 0.0);

  vec3 coefs_low_a;
  vec3 coefs_low_b;
  vec3 coefs_high_a;
  vec3 coefs_high_b;

  vec2 log_min = vec2(log10(aces_min), min_lum_log10);
  vec2 LOG_MID = vec2(log10(MID_PT.xy));
  vec2 log_max = vec2(log10(aces_max), max_lum_log10);

  float knot_inc_low = (LOG_MID.x - log_min.x) / 3.0;

  // Determine two lowest coefficients (straddling minPt)
  coefs_low_a.x = log_min.y;
  coefs_low_a.y = coefs_low_a.x;

  // Determine two highest coefficients (straddling midPt)
  float min_coef = (LOG_MID.y - MID_PT.z * LOG_MID.x);
  coefs_low_b.x = (MID_PT.z * (LOG_MID.x - 0.5 * knot_inc_low)) + (LOG_MID.y - MID_PT.z * LOG_MID.x);
  coefs_low_b.y = (MID_PT.z * (LOG_MID.x + 0.5 * knot_inc_low)) + (LOG_MID.y - MID_PT.z * LOG_MID.x);
  coefs_low_b.z = coefs_low_b.y;

  // Middle coefficient (which defines the "sharpness of the bend") is linearly interpolated
  float pct_low = Interpolate1D(BENDS_LOW_TABLE, log2(aces_min / 0.18));
  coefs_low_a.z = log_min.y + pct_low * (LOG_MID.y - log_min.y);

  float knot_inc_high = (log_max.x - LOG_MID.x) / 3.0;

  // Determine two lowest coefficients (straddling midPt)
  // float minCoef = ( logMid.y - MID_PT.z * logMid.x);
  coefs_high_a.x = (MID_PT.z * (LOG_MID.x - 0.5 * knot_inc_high)) + min_coef;
  coefs_high_a.y = (MID_PT.z * (LOG_MID.x + 0.5 * knot_inc_high)) + min_coef;

  // Determine two highest coefficients (straddling maxPt)
  // coefs_high[3] = (MAX_PT.z * (log_max.x-0.5*knotIncHigh)) + ( log_max.y - MAX_PT.z * log_max.x);
  // coefs_high[4] = (MAX_PT.z * (log_max.x+0.5*knotIncHigh)) + ( log_max.y - MAX_PT.z * log_max.x);
  // NOTE: if slope=0, then the above becomes just
  coefs_high_b.x = log_max.y;
  coefs_high_b.y = coefs_high_b.x;
  coefs_high_b.z = coefs_high_b.y;
  // leaving it as a variable for now in case we decide we need non-zero slope extensions

  // Middle coefficient (which defines the "sharpness of the bend") is linearly interpolated

  float pct_high = Interpolate1D(BENDS_HIGH_TABLE, log2(aces_max / 0.18));
  coefs_high_a.z = LOG_MID.y + pct_high * (log_max.y - LOG_MID.y);

  vec4 rgb_post = vec4(
      SSTS(rgb_pre.x, vec3(log_min.x, log_min.y, 0.0), vec3(LOG_MID.x, LOG_MID.y, MID_PT.z), vec3(log_max.x, log_max.y, 0.0), coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b),
      SSTS(rgb_pre.y, vec3(log_min.x, log_min.y, 0.0), vec3(LOG_MID.x, LOG_MID.y, MID_PT.z), vec3(log_max.x, log_max.y, 0.0), coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b),
      SSTS(rgb_pre.z, vec3(log_min.x, log_min.y, 0.0), vec3(LOG_MID.x, LOG_MID.y, MID_PT.z), vec3(log_max.x, log_max.y, 0.0), coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b),
      SSTS(rgb_pre.w, vec3(log_min.x, log_min.y, 0.0), vec3(LOG_MID.x, LOG_MID.y, MID_PT.z), vec3(log_max.x, log_max.y, 0.0), coefs_low_a, coefs_low_b, coefs_high_a, coefs_high_b));

  // Nits to Linear
  vec4 linear_cv = YToLinCV(rgb_post, max_y, min_y);
  return clamp(rgb_post, 0.0, 65535.0);
}

vec3 ODT(vec3 rgb_pre, float min_y, float max_y, mat3 odt_matrix) {
  vec3 tonescaled = ODTToneMap(rgb_pre, min_y, max_y);
  vec3 output_color = odt_matrix * tonescaled;
  return output_color;
}

vec4 ODT(vec4 rgb_pre, float min_y, float max_y, mat3 odt_matrix) {
  vec4 tonescaled = ODTToneMap(rgb_pre, min_y, max_y);
  vec4 output_color = vec4(odt_matrix * tonescaled.rgb, tonescaled.a);
  return output_color;
}

vec3 RRTAndODT(vec3 color, float min_y, float max_y, mat3 odt_matrix) {
  color = BT709_TO_AP0_MAT * color;
  color = RRT(color);
  color = ODT(color, min_y, max_y, odt_matrix);
  return color;
}

vec3 RGCAndRRTAndODT(vec3 color, float min_y, float max_y, mat3 odt_matrix) {
  color = BT709_TO_AP1_MAT * color;              // BT709 to AP1
  color = GamutCompress(color);                  // Compresses to AP1
  color = AP1_TO_AP0_MAT * color;                // Convert to AP0
  color = RRT(color);                            // RRT AP0 => AP1
  color = ODT(color, min_y, max_y, odt_matrix);  // ODT AP1 => Matrix
  return color;
}

// END ACES INCLUDE

const mat3 BT709_TO_OKLAB_LMS = mat3(
    0.4122214708, 0.2119034982, 0.0883024619,
    0.5363325363, 0.6806995451, 0.2817188376,
    0.0514459929, 0.1073969566, 0.6299787005);

const mat3 OKLAB_LMS_TO_OKLAB = mat3(
    0.2104542553, 1.9779984951, 0.0259040371,
    0.7936177850, -2.4285922050, 0.7827717662,
    -0.0040720468, 0.4505937099, -0.8086757660);

const mat3 OKLAB_TO_OKLAB_LMS = mat3(
    1.0000000000, 1.0000000000, 1.0000000000,
    0.3963377774, -0.1055613458, -0.0894841775,
    0.2158037573, -0.0638541728, -1.2914855480);

const mat3 OKLAB_LMS_TO_BT709 = mat3(
    4.0767416621, -1.2684380046, -0.0041960863,
    -3.3077115913, 2.6097574011, -0.7034186147,
    0.2309699292, -0.3413193965, 1.7076147010);

vec3 okLabFromBT709(vec3 bt709) {
  vec3 lms = BT709_TO_OKLAB_LMS * bt709;
  lms = sign(lms) * pow(abs(lms), vec3(1.0 / 3.0));  // cube-root with sign
  return OKLAB_LMS_TO_OKLAB * lms;
}

vec3 bt709FromOKLab(vec3 okLab) {
  vec3 lms = OKLAB_TO_OKLAB_LMS * okLab;
  lms *= lms * lms;  // cube
  return OKLAB_LMS_TO_BT709 * lms;
}

vec3 okLChFromOKLab(vec3 okLab) {
  float L = okLab.x;
  float a = okLab.y;
  float b = okLab.z;
  return vec3(L,
              length(okLab.yz),  // C
              atan(b, a));       // h  (radians)
}

vec3 okLabFromOKLCh(vec3 okLCh) {
  float L = okLCh.x;
  float C = okLCh.y;
  float h = okLCh.z;
  return vec3(L,
              C * cos(h),
              C * sin(h));
}

vec3 okLChFromBT709(vec3 bt709) {
  return okLChFromOKLab(okLabFromBT709(bt709));
}

vec3 bt709FromOKLCh(vec3 okLCh) {
  return bt709FromOKLab(okLabFromOKLCh(okLCh));
}

vec3 EncodePQ(vec3 color, float scaling) {
  float M1 = 2610.f / 16384.f;           // 0.1593017578125f;
  float M2 = 128.f * (2523.f / 4096.f);  // 78.84375f;
  float C1 = 3424.f / 4096.f;            // 0.8359375f;
  float C2 = 32.f * (2413.f / 4096.f);   // 18.8515625f;
  float C3 = 32.f * (2392.f / 4096.f);   // 18.6875f;
  color *= (scaling / 10000.f);
  vec3 y_m1 = pow(color, vec3(M1));
  return pow((vec3(C1) + vec3(C2) * y_m1) / (1.f + vec3(C3) * y_m1), vec3(M2));
}
vec3 EncodePQ(vec3 color) {
  return EncodePQ(color, 10000.f);
}

vec3 DecodePQ(vec3 in_color, float scaling) {
  float M1 = 2610.f / 16384.f;           // 0.1593017578125f;
  float M2 = 128.f * (2523.f / 4096.f);  // 78.84375f;
  float C1 = 3424.f / 4096.f;            // 0.8359375f;
  float C2 = 32.f * (2413.f / 4096.f);   // 18.8515625f;
  float C3 = 32.f * (2392.f / 4096.f);   // 18.6875f;

  vec3 e_m12 = pow(in_color, 1.f / vec3(M2));
  vec3 out_color = pow(max(e_m12 - vec3(C1), 0) / (vec3(C2) - vec3(C3) * e_m12),
                       1.f / vec3(M1));
  return out_color * (10000.f / scaling);
}
vec3 DecodePQ(vec3 color) {
  return DecodePQ(color, 10000.f);
}

// const mat3 XYZ_TO_LMS_MAT =
//     mat3(0.3592832590121217f, 0.6976051147779502f, -0.0358915932320290f,
//          -0.1920808463704993f, 1.1004767970374321f, 0.0753748658519118f,
//          0.0070797844607479f, 0.0748396662186362f, 0.8433265453898765f);

// const mat3 LMS_TO_XYZ_MAT =
//     mat3(2.07018005669561320, -1.32645687610302100, 0.206616006847855170,
//          0.36498825003265756, 0.68046736285223520, -0.045421753075853236,
//          -0.04959554223893212, -0.04942116118675749, 1.187995941732803400);
const mat3 XYZ_TO_LMS_MAT = mat3(
    0.3592832590121217, -0.1920808463704993, 0.0070797844607479,
    0.6976051147779502, 1.1004767970374321, 0.0748396662186362,
    -0.0358915932320290, 0.0753748658519118, 0.8433265453898765);

const mat3 LMS_TO_XYZ_MAT = mat3(
    2.0701800566956132, 0.36498825003265756, -0.04959554223893212,
    -1.3264568761030210, 0.68046736285223520, -0.04942116118675749,
    0.20661600684785517, -0.045421753075853236, 1.1879959417328034);

vec3 IctcpFromBT709(vec3 bt709_color) {
  vec3 xyz_color = BT709_TO_XYZ_MAT * bt709_color;
  vec3 lms_color = XYZ_TO_LMS_MAT * xyz_color;

  // mat3 mat = mat3(
  //     0.5000, 0.5000, 0.0000,
  //     1.6137, -3.3234, 1.7097,
  //     4.3780, -4.2455, -0.1325);
  const mat3 ICTCP_LMS_TO_ICTCP_MAT = mat3(
      0.5000, 1.6137, 4.3780,
      0.5000, -3.3234, -4.2455,
      0.0000, 1.7097, -0.1325);

  return ICTCP_LMS_TO_ICTCP_MAT * EncodePQ(lms_color, 100.0f);
}

vec3 BT709FromICtCp(vec3 col) {
  // mat3 mat = mat3(1.0, 0.00860514569398152, 0.11103560447547328, 1.0,
  //                 -0.00860514569398152, -0.11103560447547328, 1.0,
  //                 0.56004885956263900, -0.32063747023212210);
  const mat3 ICTCP_TO_LMS_MAT = mat3(
      1.0, 1.0, 1.0,
      0.008605146, -0.008605146, 0.56004886,
      0.11103560, -0.11103560, -0.32063747);
  col = ICTCP_TO_LMS_MAT * col;

  // 1.0f = 100 nits, 100.0f = 10k nits
  col = DecodePQ(col, 100.f);
  col = LMS_TO_XYZ_MAT * col;
  return XYZ_TO_BT709_MAT * col;
}

const vec3 BT709_LUMA = vec3(0.2126390059,
                             0.7151686788,
                             0.0721923154);

float luminanceBT709(vec3 c) {
  return dot(c, BT709_LUMA);
}

// Safe divide (float & vec2 versions)
float DivideSafe(float a, float b, float fallback) {
  return (b == 0.0) ? fallback : a / b;
}
float DivideSafe(float a, float b) {
  return DivideSafe(a, b, 3.4028235e38);
}
vec2 DivideSafe(vec2 a, vec2 b, vec2 fallback) {
  return vec2(DivideSafe(a.x, b.x, fallback.x), DivideSafe(a.y, b.y, fallback.y));
}
vec2 DivideSafe(vec2 a, vec2 b) {
  return DivideSafe(a, b, vec2(3.4028235e38));
}

vec3 ApplyPerChannelCorrection(
    vec3 untonemapped,
    vec3 per_channel_color,
    float blowout_restoration,
    float hue_correction_strength,
    float chrominance_correction_strength,
    float hue_shift_strength) {
  const float tonemapped_luminance = luminanceBT709(abs(per_channel_color));

  const float AUTO_CORRECT_BLACK = 0.02;
  // Fix near black
  const float untonemapped_luminance = luminanceBT709(abs(untonemapped));
  float ratio = tonemapped_luminance / untonemapped_luminance;
  float auto_correct_ratio = mix(ratio, 1.0,
                                 clamp(untonemapped_luminance / AUTO_CORRECT_BLACK, 0.0, 1.0));
  untonemapped *= auto_correct_ratio;

  const vec3 tonemapped_perceptual = IctcpFromBT709(per_channel_color);
  const vec3 untonemapped_perceptual = IctcpFromBT709(untonemapped);

  vec2 untonemapped_chromas = untonemapped_perceptual.yz;
  vec2 tonemapped_chromas = tonemapped_perceptual.yz;

  float untonemapped_chrominance = length(untonemapped_perceptual.yz);  // eg: 0.80
  float tonemapped_chrominance = length(tonemapped_perceptual.yz);      // eg: 0.20

  // clamp saturation loss
  float chrominance_ratio = min(DivideSafe(tonemapped_chrominance,
                                           untonemapped_chrominance, 1.0),
                                1.0);
  chrominance_ratio = max(chrominance_ratio, blowout_restoration);

  // Untonemapped hue, tonemapped chrominance (with limit)
  vec2 reduced_untonemapped_chromas = untonemapped_chromas * chrominance_ratio;

  // pick chroma based on per-channel luminance (supports not oversaturating crushed areas)
  const vec2 reduced_hue_shifted = mix(
      tonemapped_chromas,
      reduced_untonemapped_chromas,
      clamp(tonemapped_luminance / 0.36, 0.0, 1.0));

  // Tonemapped hue, restored chrominance (with limit)
  const vec2 blowout_restored_chromas = tonemapped_chromas * DivideSafe(length(reduced_hue_shifted), length(tonemapped_chromas), 1.0);

  const vec2 hue_shifted_chromas = mix(reduced_hue_shifted,
                                       blowout_restored_chromas,
                                       hue_shift_strength);

  // Pick untonemapped hues for shadows/midtones
  const vec2 hue_correct_chromas = untonemapped_chromas * DivideSafe(length(hue_shifted_chromas), length(untonemapped_chromas), 1.0);

  const vec2 selectable_hue_correct_range = mix(
      hue_correct_chromas,
      hue_shifted_chromas,
      clamp(tonemapped_luminance / 0.36, 0.0, 1.0));

  const vec2 hue_corrected_chromas = mix(hue_shifted_chromas,
                                         selectable_hue_correct_range,
                                         hue_correction_strength);

  const vec2 chroma_correct_chromas = hue_corrected_chromas * DivideSafe(length(untonemapped_chromas), length(hue_corrected_chromas), 1.0);

  const vec2 selectable_chroma_correct_range = mix(
      chroma_correct_chromas,
      hue_corrected_chromas,
      clamp(tonemapped_luminance / 0.36, 0.0, 1.0));

  const vec2 chroma_corrected_chromas = mix(
      hue_correct_chromas,
      selectable_chroma_correct_range,
      chrominance_correction_strength);

  vec2 final_chromas = chroma_corrected_chromas;

  const vec3 final_color = BT709FromICtCp(vec3(
      tonemapped_perceptual.x,
      final_chromas));

  return final_color;
}

vec3 CorrectHue(vec3 incorrect_color, vec3 correct_color, float strength) {
  if (strength == 0.0) return incorrect_color;

  vec3 correct_lab = okLabFromBT709(correct_color);
  vec3 incorrect_lab = okLabFromBT709(incorrect_color);

  float chrominance_pre_adjust = length(incorrect_lab.yz);

  incorrect_lab.yz = mix(incorrect_lab.yz, correct_lab.yz, strength);

  float chrominance_post_adjust = length(incorrect_lab.yz);

  incorrect_lab.yz *= DivideSafe(chrominance_pre_adjust,
                                 chrominance_post_adjust,
                                 1.0);

  vec3 color = bt709FromOKLab(incorrect_lab);
  color = AP1_TO_BT709_MAT *  // convert to ap1, clamp negatives, convert back to bt709
          max(BT709_TO_AP1_MAT * color, vec3(0.0));

  return color;
}

vec3 CorrectHueAP1(vec3 incorrect_color_ap1, vec3 correct_color_ap1, float strength) {
  if (strength == 0.0) return incorrect_color_ap1;

  // Convert both AP1 inputs to BT.709 for OkLab conversion
  vec3 incorrect_color = AP1_TO_BT709_MAT * incorrect_color_ap1;
  vec3 correct_color = AP1_TO_BT709_MAT * correct_color_ap1;

  vec3 correct_lab = okLabFromBT709(correct_color);
  vec3 incorrect_lab = okLabFromBT709(incorrect_color);

  float chrominance_pre_adjust = length(incorrect_lab.yz);

  incorrect_lab.yz = mix(incorrect_lab.yz, correct_lab.yz, strength);

  float chrominance_post_adjust = length(incorrect_lab.yz);

  incorrect_lab.yz *= DivideSafe(chrominance_pre_adjust,
                                 chrominance_post_adjust,
                                 1.0);

  vec3 color = bt709FromOKLab(incorrect_lab);
  color = max(BT709_TO_AP1_MAT * color, vec3(0.0));

  return color;
}

vec3 SaturationAP1(vec3 ap1, float saturation) {
  vec3 bt709 = AP1_TO_BT709_MAT * ap1;

  vec3 perceptual = okLabFromBT709(bt709);
  perceptual.yz *= saturation;

  bt709 = bt709FromOKLab(perceptual);
  return max(vec3(0.0), BT709_TO_AP1_MAT * bt709);
}

vec3 SaturationBlowoutAP1(vec3 ap1, float y, float saturation, float dechroma) {
  vec3 bt709 = AP1_TO_BT709_MAT * ap1;

  vec3 perceptual = okLabFromBT709(bt709);
  perceptual.yz *= saturation;

  if (dechroma != 0.f) {
    perceptual.yz *= mix(1.f, 0.f, clamp(pow(y / (10000.f / 100.f), (1.f - dechroma)), 0.0, 1.0));
  }

  bt709 = bt709FromOKLab(perceptual);
  return max(vec3(0.0), BT709_TO_AP1_MAT * bt709);
}

vec3 SaturationBlowoutAP1ICtCp(vec3 ap1, float y, float saturation, float dechroma) {
  vec3 bt709 = AP1_TO_BT709_MAT * ap1;

  vec3 perceptual = IctcpFromBT709(bt709);
  perceptual.yz *= saturation;

  if (dechroma != 0.f) {
    perceptual.yz *= mix(1.f, 0.f, clamp(pow(y / (10000.f / 100.f), (1.f - dechroma)), 0.0, 1.0));
  }

  bt709 = BT709FromICtCp(perceptual);
  return max(vec3(0.0), BT709_TO_AP1_MAT * bt709);
}

vec3 ChrominanceOKLabAP1(vec3 incorrect_color_ap1, vec3 correct_color_ap1, float strength) {
  if (strength == 0.0) return incorrect_color_ap1;

  // Convert both AP1 inputs to BT.709 for OkLab conversion
  vec3 incorrect_color = AP1_TO_BT709_MAT * incorrect_color_ap1;
  vec3 correct_color = AP1_TO_BT709_MAT * correct_color_ap1;

  vec3 incorrect_lab = okLabFromBT709(incorrect_color);
  vec3 correct_lab = okLabFromBT709(correct_color);

  vec2 incorrect_ab = incorrect_lab.yz;
  vec2 correct_ab = correct_lab.yz;

  // Compute chrominance (magnitude of the a–b vector)
  float incorrect_chrominance = length(incorrect_ab);
  float correct_chrominance = length(correct_ab);

  // Scale original chrominance vector toward target chrominance
  float chrominance_ratio = DivideSafe(correct_chrominance, incorrect_chrominance, 1.0);
  float scale = mix(1.0, chrominance_ratio, strength);
  incorrect_lab.yz = incorrect_ab * scale;

  // Convert back to BT.709, then to AP1, clamp negatives
  vec3 bt709 = bt709FromOKLab(incorrect_lab);
  return max(vec3(0.0), BT709_TO_AP1_MAT * bt709);
}

vec3 ChrominanceICtCp(vec3 incorrect_color_ap1, vec3 correct_color_ap1, float strength) {
  if (strength == 0.0) return incorrect_color_ap1;

  // Convert both AP1 inputs to BT.709 for OkLab conversion
  vec3 incorrect_color = AP1_TO_BT709_MAT * incorrect_color_ap1;
  vec3 correct_color = AP1_TO_BT709_MAT * correct_color_ap1;

  vec3 incorrect_ictcp = IctcpFromBT709(incorrect_color);
  vec3 correct_ictcp = IctcpFromBT709(correct_color);

  vec2 incorrect_ctcp = incorrect_ictcp.yz;
  vec2 correct_ctcp = correct_ictcp.yz;

  // Compute chrominance (magnitude of the ct–cp vector)
  float incorrect_chrominance = length(incorrect_ctcp);
  float correct_chrominance = length(correct_ctcp);

  // Scale original chrominance vector toward target chrominance
  float chrominance_ratio = DivideSafe(correct_chrominance, incorrect_chrominance, 1.0);
  float scale = mix(1.0, chrominance_ratio, strength);
  incorrect_ictcp.yz = incorrect_ctcp * scale;

  // Convert back to BT.709, then to AP1, clamp negatives
  vec3 bt709 = BT709FromICtCp(incorrect_ictcp);
  return max(vec3(0.0), BT709_TO_AP1_MAT * bt709);
}

vec3 CorrectHueAndChrominanceOKLabAP1(
    vec3 incorrect_color_ap1,
    vec3 reference_color_ap1,
    float hue_emulation_strength,
    float chrominance_emulation_strength,
    float hue_emulation_ramp_start,
    float hue_emulation_ramp_end) {
  if (hue_emulation_strength == 0.0 && chrominance_emulation_strength == 0.0) {
    return incorrect_color_ap1;
  }

  vec3 incorrect_color_bt709 = AP1_TO_BT709_MAT * incorrect_color_ap1;
  vec3 reference_color_bt709 = AP1_TO_BT709_MAT * reference_color_ap1;

  vec3 perceptual_new = okLabFromBT709(incorrect_color_bt709);
  vec3 perceptual_reference = okLabFromBT709(reference_color_bt709);

  float chrominance_current = length(perceptual_new.yz);
  float chrominance_ratio = 1.0;

  if (hue_emulation_strength != 0.0) {
    float ramp_denom = hue_emulation_ramp_end - hue_emulation_ramp_start;
    float ramp_t = clamp(DivideSafe(perceptual_new.x - hue_emulation_ramp_start, ramp_denom, 0.0), 0.0, 1.0);
    hue_emulation_strength *= ramp_t;

    float chrominance_pre = chrominance_current;
    perceptual_new.yz = mix(perceptual_new.yz, perceptual_reference.yz, hue_emulation_strength);
    float chrominance_post = length(perceptual_new.yz);
    chrominance_ratio = DivideSafe(chrominance_pre, chrominance_post, 1.0);
    chrominance_current = chrominance_post;
  }

  if (chrominance_emulation_strength != 0.0) {
    float reference_chrominance = length(perceptual_reference.yz);
    float target_chrominance_ratio = DivideSafe(reference_chrominance, chrominance_current, 1.0);
    chrominance_ratio = mix(chrominance_ratio, target_chrominance_ratio, chrominance_emulation_strength);
  }

  perceptual_new.yz *= chrominance_ratio;

  vec3 corrected_color_bt709 = bt709FromOKLab(perceptual_new);
  vec3 corrected_color_ap1 = max(BT709_TO_AP1_MAT * corrected_color_bt709, vec3(0.0));
  return corrected_color_ap1;
}

// END INCLUDES
