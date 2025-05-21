// ACES ToneMap
#version 450
#extension GL_EXT_buffer_reference2 : require
#if defined(GL_EXT_control_flow_attributes)
#extension GL_EXT_control_flow_attributes : require
#define SPIRV_CROSS_FLATTEN [[flatten]]
#define SPIRV_CROSS_BRANCH [[dont_flatten]]
#define SPIRV_CROSS_UNROLL [[unroll]]
#define SPIRV_CROSS_LOOP [[dont_unroll]]
#else
#define SPIRV_CROSS_FLATTEN
#define SPIRV_CROSS_BRANCH
#define SPIRV_CROSS_UNROLL
#define SPIRV_CROSS_LOOP
#endif
layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;

// START INCLUDES

// --- sRGB ENCODING ---
float EncodeSRGB(float x) {
  return mix(
      x * 12.92,
      1.055 * pow(x, 1.0 / 2.4) - 0.055,
      step(0.0031308, x)
    );
}

vec3 EncodeSRGB(vec3 x) {
  return mix(
      x * 12.92,
      1.055 * pow(x, vec3(1.0 / 2.4)) - 0.055,
      step(vec3(0.0031308), x)
    );
}

// --- sRGB DECODING ---
float DecodeSRGB(float x) {
  return mix(
      x / 12.92,
      pow((x + 0.055) / 1.055, 2.4),
      step(0.04045, x)
    );
}

vec3 DecodeSRGB(vec3 x) {
  return mix(
      x / 12.92,
      pow((x + 0.055) / 1.055, vec3(2.4)),
      step(vec3(0.04045), x)
    );
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

float Rgb2Yc(vec3 rgb)
{
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

float Rgb2Saturation(vec3 rgb)
{
  float minrgb = min(min(rgb.r, rgb.g), rgb.b);
  float maxrgb = max(max(rgb.r, rgb.g), rgb.b);
  return (max(maxrgb, 1e-10) - max(minrgb, 1e-10)) / max(maxrgb, 1e-2);
}

// Sigmoid function in the range 0 to 1 spanning -2 to +2.
float SigmoidShaper(float x)
{
  float t = max(1.0 - abs(0.5 * x), 0.0);
  float y = 1.0 + sign(x) * (1.0 - t * t);
  return 0.5 * y;
}

float GlowFwd(float yc_in, float glow_gain_in, float glow_mid)
{
  float glow_gain_out;

  if (yc_in <= 2.0 / 3.0 * glow_mid)
    {
    glow_gain_out = glow_gain_in;
  }
    else if (yc_in >= 2.0 * glow_mid)
    {
    glow_gain_out = 0.0;
  }
    else
    {
    glow_gain_out = glow_gain_in * (glow_mid / yc_in - 0.5);
  }

  return glow_gain_out;
}

// Transformations from RGB to other color representations
float Rgb2Hue(vec3 rgb)
{
  const float aces_pi = 3.14159265359;
  // Returns a geometric hue angle in degrees (0-360) based on RGB values.
  // For neutral colors, hue is undefined and the function will return a quiet NaN value.
  float hue;
  if (rgb.r == rgb.g && rgb.g == rgb.b)
    {
    hue = 0.0;  // RGB triplets where RGB are equal have an undefined hue
  }
    else
    {
    hue = (180.0 / aces_pi) * atan(sqrt(3.0) * (rgb.g - rgb.b), 2.0 * rgb.r - rgb.g - rgb.b);
  }

  if (hue < 0.0)
    {
    hue = hue + 360.0;
  }

  return clamp(hue, 0.0, 360.0);
}

float CenterHue(float hue, float center_h)
{
  float hue_centered = hue - center_h;
  if (hue_centered < -180.0)
    {
    hue_centered += 360.0;
  }
    else if (hue_centered > 180.0)
    {
    hue_centered -= 360.0;
  }
  return hue_centered;
}

vec3 YToLinCV(vec3 y, float y_max, float y_min)
{
  return (y - y_min) / (y_max - y_min);
}

// Transformations between CIE XYZ tristimulus values and CIE x,y
// chromaticity coordinates
vec3 XYZToXyY(vec3 xyz)
{
  vec3 xy_y;
  float divisor = (xyz[0] + xyz[1] + xyz[2]);
  if (divisor == 0.0)
    divisor = 1e-10;
  xy_y[0] = xyz[0] / divisor;
  xy_y[1] = xyz[1] / divisor;
  xy_y[2] = xyz[1];

  return xy_y;
}

vec3 XyYToXYZ(vec3 xy_y)
{
  vec3 xyz;
  xyz[0] = xy_y[0] * xy_y[2] / max(xy_y[1], 1e-10);
  xyz[1] = xy_y[2];
  xyz[2] = (1.0 - xy_y[0] - xy_y[1]) * xy_y[2] / max(xy_y[1], 1e-10);

  return xyz;
}

const float DIM_SURROUND_GAMMA = 0.9811;

vec3 DarkToDim(vec3 xyz, float dim_surround_gamma)
{
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

float Interpolate1D(mat2 table, float p)
{
  float x0 = table[0][0];
  float x1 = table[0][1];
  float y0 = table[1][0];
  float y1 = table[1][1];

  if (p < x0) return y0;
  if (p >= x1) return y1;

  float s = (p - x0) / (x1 - x0);  // 0-to-1 mix factor
  return mix(y0, y1, s);
}

vec3 LinCv2Y(vec3 lin_cv, float y_max, float y_min)
{
  return lin_cv * (y_max - y_min) + y_min;
}

float LookUpAcesMin(float min_lum_log10)
{
  return 0.18 * exp2(Interpolate1D(MIN_LUM_TABLE, min_lum_log10));
}

float LookUpAcesMax(float max_lum_log10)
{
  return 0.18 * exp2(Interpolate1D(MAX_LUM_TABLE, max_lum_log10));
}

float SSTS(
    float x,
    vec3 y_min, vec3 y_mid, vec3 y_max,
    vec3 coefs_low_a, vec3 coefs_low_b,
    vec3 coefs_high_a, vec3 coefs_high_b)
{
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
  float log_x = log10(max(x, 0.00000006));  // equivalent to asfloat(0x00800000)

  float log_y;

  if (log_x > y_max.x)
    {
    // Above max breakpoint (overshoot)
    // If MAX_PT slope is 0, this is just a straight line and always returns
    // maxLum
    // y = mx+b
    // log_y = computeGraphY(C.Max.z, log_x, (C.Max.y) - (C.Max.z * (C.Max.x)));
    log_y = y_max.y;
  }
    else if (log_x >= y_mid.x)
    {
    // Part of Midtones area (Must have slope)
    float knot_coord = float(N_KNOTS_HIGH - 1) * (log_x - y_mid.x) / (y_max.x - y_mid.x);
    int j = int(knot_coord);
    float t = knot_coord - float(j);

    vec3 cf = vec3(coefs_high[j], coefs_high[j + 1], coefs_high[j + 2]);

    vec3 monomials = vec3(t * t, t, 1.0);
    log_y = dot(monomials, M * cf);
  }
    else if (log_x > y_min.x)
    {
    float knot_coord = float(N_KNOTS_LOW - 1) * (log_x - y_min.x) / (y_mid.x - y_min.x);
    int j = int(knot_coord);
    float t = knot_coord - float(j);

    vec3 cf = vec3(coefs_low[j], coefs_low[j + 1], coefs_low[j + 2]);

    vec3 monomials = vec3(t * t, t, 1.0);
    log_y = dot(monomials, M * cf);
  }
    else
    {  //(log_x <= (C.Min.x))
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

float GamutCompressChannel(float dist, float lim, float thr, float pwr)
{
  float compr_dist;
  float scl;
  float nd;
  float p;

  if (dist < thr)
    {
    compr_dist = dist;  // No compression below threshold
  }
    else
    {
    // Calculate scale factor for y = 1 intersect
    scl = (lim - thr) / pow(pow((1.0 - thr) / (lim - thr), -pwr) - 1.0, 1.0 / pwr);

    // Normalize distance outside threshold by scale factor
    nd = (dist - thr) / scl;
    p = pow(nd, pwr);

    compr_dist = thr + scl * nd / (pow(1.0 + p, 1.0 / pwr));  // Compress
  }

  return compr_dist;
}

vec3 GamutCompress(vec3 lin_ap1)
{
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

vec3 RRT(vec3 aces)
{
  const vec3 AP1_RGB2Y = AP1_TO_XYZ_MAT[1].rgb;

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

vec3 ODTToneMap(vec3 rgb_pre, float min_y, float max_y)
{
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

vec3 ODT(vec3 rgb_pre, float min_y, float max_y, mat3 odt_matrix)
{
  vec3 tonescaled = ODTToneMap(rgb_pre, min_y, max_y);
  vec3 output_color = odt_matrix * tonescaled;
  return output_color;
}

vec3 RRTAndODT(vec3 color, float min_y, float max_y, mat3 odt_matrix)
{
  color = BT709_TO_AP0_MAT * color;
  color = RRT(color);
  color = ODT(color, min_y, max_y, odt_matrix);
  return color;
}

vec3 RGCAndRRTAndODT(vec3 color, float min_y, float max_y, mat3 odt_matrix)
{
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
    0.0514459929, 0.1073969566, 0.6299787005
);

const mat3 OKLAB_LMS_TO_OKLAB = mat3(
     0.2104542553,  1.9779984951, 0.0259040371,
     0.7936177850, -2.4285922050, 0.7827717662,
    -0.0040720468,  0.4505937099,-0.8086757660
);

const mat3 OKLAB_TO_OKLAB_LMS = mat3(
    1.0000000000, 1.0000000000, 1.0000000000,
    0.3963377774,-0.1055613458,-0.0894841775,
    0.2158037573,-0.0638541728,-1.2914855480
);

const mat3 OKLAB_LMS_TO_BT709 = mat3(
     4.0767416621,-1.2684380046,-0.0041960863,
    -3.3077115913,  2.6097574011,-0.7034186147,
     0.2309699292,-0.3413193965,  1.7076147010
);

vec3 okLabFromBT709(vec3 bt709)
{
  vec3 lms = BT709_TO_OKLAB_LMS * bt709;
  lms = sign(lms) * pow(abs(lms), vec3(1.0 / 3.0));  // cube-root with sign
  return OKLAB_LMS_TO_OKLAB * lms;
}

vec3 bt709FromOKLab(vec3 okLab)
{
  vec3 lms = OKLAB_TO_OKLAB_LMS * okLab;
  lms *= lms * lms;  // cube
  return OKLAB_LMS_TO_BT709 * lms;
}

vec3 okLChFromOKLab(vec3 okLab)
{
  float L = okLab.x;
  float a = okLab.y;
  float b = okLab.z;
  return vec3(L,
              length(okLab.yz),  // C
              atan(b, a));       // h  (radians)
}

vec3 okLabFromOKLCh(vec3 okLCh)
{
  float L = okLCh.x;
  float C = okLCh.y;
  float h = okLCh.z;
  return vec3(L,
              C * cos(h),
              C * sin(h));
}

vec3 okLChFromBT709(vec3 bt709)
{
  return okLChFromOKLab(okLabFromBT709(bt709));
}

vec3 bt709FromOKLCh(vec3 okLCh)
{
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
vec3 EncodePQ(vec3 color) { return EncodePQ(color, 10000.f); }

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
vec3 DecodePQ(vec3 color) { return DecodePQ(color, 10000.f); }

const mat3 XYZ_TO_LMS_MAT =
    mat3(0.3592832590121217f, 0.6976051147779502f, -0.0358915932320290f,
         -0.1920808463704993f, 1.1004767970374321f, 0.0753748658519118f,
         0.0070797844607479f, 0.0748396662186362f, 0.8433265453898765f);

const mat3 LMS_TO_XYZ_MAT =
    mat3(2.07018005669561320, -1.32645687610302100, 0.206616006847855170,
         0.36498825003265756, 0.68046736285223520, -0.045421753075853236,
         -0.04959554223893212, -0.04942116118675749, 1.187995941732803400);

vec3 IctcpFromBT709(vec3 bt709_color) {
  vec3 xyz_color = bt709_color * BT709_TO_XYZ_MAT;
  vec3 lms_color = xyz_color * XYZ_TO_LMS_MAT;

  mat3 mat = mat3(0.5000, 0.5000, 0.0000, 1.6137, -3.3234, 1.7097, 4.3780,
                  -4.2455, -0.1325);

  return EncodePQ(lms_color, 100.0f) * mat;
}

vec3 BT709FromICtCp(vec3 col) {
  mat3 mat = mat3(1.0, 0.00860514569398152, 0.11103560447547328, 1.0,
                  -0.00860514569398152, -0.11103560447547328, 1.0,
                  0.56004885956263900, -0.32063747023212210);
  col = col * mat;

  // 1.0f = 100 nits, 100.0f = 10k nits
  col = DecodePQ(col, 100.f);
  col = col * LMS_TO_XYZ_MAT;
  return col * XYZ_TO_BT709_MAT;
}

const vec3 BT709_LUMA = vec3(0.2126390059,
                             0.7151686788,
                             0.0721923154);

float luminanceBT709(vec3 c) { return dot(c, BT709_LUMA); }

// Safe divide (float & vec2 versions)
float DivideSafe(float a, float b, float fallback) { return (b == 0.0) ? fallback : a / b; }
float DivideSafe(float a, float b) { return DivideSafe(a, b, 3.4028235e38); }
vec2 DivideSafe(vec2 a, vec2 b, vec2 fallback) { return vec2(DivideSafe(a.x, b.x, fallback.x), DivideSafe(a.y, b.y, fallback.y)); }
vec2 DivideSafe(vec2 a, vec2 b) { return DivideSafe(a, b, vec2(3.4028235e38)); }

vec3 ApplyPerChannelCorrection(
    vec3 untonemapped,
    vec3 per_channel_color,
    float blowout_restoration,
    float hue_correction_strength,
    float chrominance_correction_strength,
    float hue_shift_strength)
{
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
                                           untonemapped_chrominance, 1.0), 1.0);
  chrominance_ratio = max(chrominance_ratio, blowout_restoration);

  // Untonemapped hue, tonemapped chrominance (with limit)
  vec2 reduced_untonemapped_chromas = untonemapped_chromas * chrominance_ratio;

  // pick chroma based on per-channel luminance (supports not oversaturating crushed areas)
  const vec2 reduced_hue_shifted = mix(
      tonemapped_chromas,
      reduced_untonemapped_chromas,
      clamp(tonemapped_luminance / 0.36, 0.0, 1.0));

  // Tonemapped hue, restored chrominance (with limit)
  const vec2 blowout_restored_chromas = tonemapped_chromas *
      DivideSafe(length(reduced_hue_shifted), length(tonemapped_chromas), 1.0);

  const vec2 hue_shifted_chromas = mix(reduced_hue_shifted,
                                       blowout_restored_chromas,
                                       hue_shift_strength);

  // Pick untonemapped hues for shadows/midtones
  const vec2 hue_correct_chromas = untonemapped_chromas *
      DivideSafe(length(hue_shifted_chromas), length(untonemapped_chromas), 1.0);

  const vec2 selectable_hue_correct_range = mix(
      hue_correct_chromas,
      hue_shifted_chromas,
      clamp(tonemapped_luminance / 0.36, 0.0, 1.0));

  const vec2 hue_corrected_chromas = mix(hue_shifted_chromas,
                                         selectable_hue_correct_range,
                                         hue_correction_strength);

  const vec2 chroma_correct_chromas = hue_corrected_chromas *
      DivideSafe(length(untonemapped_chromas), length(hue_corrected_chromas), 1.0);

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

vec3 CorrectHue(vec3 incorrect_color, vec3 correct_color, float strength)
{
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

// END INCLUDES


struct _117
{
    float _m0;
    float _m1;
};

struct _118
{
    float _m0[10];
    float _m1[10];
    _117 _m2;
    _117 _m3;
    _117 _m4;
    float _m5;
    float _m6;
};

struct _159
{
    float _m0;
    float _m1;
    float _m2;
};

struct _163
{
    float _m0[5];
};

struct _179
{
    _159 _m0;
    _159 _m1;
    _159 _m2;
    float _m3[6];
    float _m4[6];
};

struct _215
{
    float _m0;
    float _m1;
    float _m2;
};

struct _748
{
    float _m0[6];
    float _m1[6];
    _117 _m2;
    _117 _m3;
    _117 _m4;
    float _m5;
    float _m6;
};

// BENDS_LOW_TABLE
const float _1635[2][2] = float[][](float[](-15.0, 0.18), float[](-6.5, 0.35));
// BENDS_HIGH_TABLE
const float _1778[2][2] = float[][](float[](6.5, 0.89), float[](18.0, 0.90));

layout(buffer_reference) buffer _2938;
layout(buffer_reference, buffer_reference_align = 16, std430) buffer _2938
{
    uvec4 _m0;
    float _m1;
    float _m2;
    float _m3;
};

layout(set = 0, binding = 0, std140) uniform _2893_2895
{
    uvec4 _m0;
    vec4 _m1;
    vec4 _m2;
    vec4 _m3;
    vec4 _m4;
    vec4 _m5;
    vec4 _m6;
    vec4 _m7;
    float _m8;
    float _m9;
    float _m10;
    float _m11;
    float _m12;
    float _m13;
    float _m14;
    float _m15;
    float _m16;
    float _m17;
    float _m18;
    float _m19;
    float _m20;
    float _m21;
    float _m22;
    float _m23;
    float _m24;
    float _m25;
    float _m26;
    float _m27;
    float _m28;
    float _m29;
    float _m30;
    float _m31;
    float _m32;
    float _m33;
    float _m34;
    float _m35;
    float _m36;
    uint _m37;
    uint _m38;
    uint _m39;
    float _m40;
    uint _m41;
    uint _m42;
    uint _m43;
    float _m44;
    float _m45;
    uint _m46;
} _2895;

layout(set = 0, binding = 1, std140) uniform _2995_2997
{
    vec4 _m0[1024];
} _2997;

layout(set = 0, binding = 2, std430) restrict readonly buffer _2999_3001
{
    uvec4 _m0[];
} _3001;

layout(set = 0, binding = 3, std430) restrict readonly buffer _3003_3005
{
    uvec4 _m0[];
} _3005;

layout(push_constant, std430) uniform _2937_2940
{
    _2938 _m0;
} _2940;

layout(set = 1, binding = 1, rgba16f) uniform writeonly image3D _2981;

uint _224;
uint _226;
uint _3013;

vec3 _208(vec3 _207)
{
    vec3 _2633 = (_207 * 9.21035003662109375) - vec3(4.60517024993896484375);
    return max(vec3(0.0), exp(_2633) - vec3(0.00999999977648258209228515625));
}

uint _17(float _16)
{
    return floatBitsToUint(_16);
}

vec3 _40(vec3 _38, mat3 _39)
{
    return _38 * _39;
}

vec3 _47(vec3 _43, mat3 _44, mat3 _45, mat3 _46)
{
    vec3 _264 = _43;
    mat3 _265 = _44;
    vec3 _267 = _40(_264, _265);
    mat3 _268 = _45;
    vec3 _270 = _40(_267, _268);
    mat3 _271 = _46;
    return _40(_270, _271);
}

// BT.709 -> AP0
vec3 _211(vec3 _210)
{
    return _47(_210, mat3(vec3(0.412390887737274169921875, 0.357584297657012939453125, 0.18048083782196044921875), vec3(0.2126390635967254638671875, 0.71516859531402587890625, 0.072192333638668060302734375), vec3(0.01933082006871700286865234375, 0.119194723665714263916015625, 0.95053231716156005859375)), mat3(vec3(1.01303005218505859375, 0.0061053098179399967193603515625, -0.014971000142395496368408203125), vec3(0.0076982299797236919403076171875, 0.99816501140594482421875, -0.005032029934227466583251953125), vec3(-0.0028413101099431514739990234375, 0.0046851597726345062255859375, 0.92450702190399169921875)), mat3(vec3(1.04981100559234619140625, 0.0, -9.74845024757087230682373046875e-05), vec3(-0.49590301513671875, 1.37331306934356689453125, 0.09824003279209136962890625), vec3(3.9999999756901161163114011287689e-08, 0.0, 0.991252005100250244140625)));
}

float _23(float _20, float _21, float _22)
{
    return max(_20, max(_21, _22));
}

float _28(float _25, float _26, float _27)
{
    return min(_25, min(_26, _27));
}

float _69(vec3 _68)
{
    float _366 = _68.x;
    float _370 = _68.y;
    float _374 = _68.z;
    float _365 = _23(_366, _370, _374);
    float _379 = _68.x;
    float _382 = _68.y;
    float _385 = _68.z;
    float _378 = _28(_379, _382, _385);
    return (max(_365, 1.0000000133514319600180897396058e-10) - max(_378, 1.0000000133514319600180897396058e-10)) / max(_365, 0.00999999977648258209228515625);
}

float _75(vec3 _74)
{
    float _450 = 1.75;
    float _452 = _74.x;
    float _455 = _74.y;
    float _458 = _74.z;
    float _461 = sqrt(((_458 * (_458 - _455)) + (_455 * (_455 - _452))) + (_452 * (_452 - _458)));
    return (((_458 + _455) + _452) + (_450 * _461)) / 3.0;
}

// sigmoid shaper
float _138(float _137)
{
    float _1351 = max(1.0 - abs(_137 / 2.0), 0.0);
    float _1357 = 1.0 + (sign(_137) * (1.0 - (_1351 * _1351)));
    return _1357 / 2.0;
}

float _131(float _128, float _129, float _130)
{
    float _1187;
    if (_128 <= (0.666666686534881591796875 * _130))
    {
        _1187 = _129;
    }
    else
    {
        if (_128 >= (2.0 * _130))
        {
            _1187 = 0.0;
        }
        else
        {
            _1187 = _129 * ((_130 / _128) - 0.5);
        }
    }
    return _1187;
}

float _51(float _50)
{
    float _278;
    if (_50 < 1.0)
    {
        _278 = _50;
    }
    else
    {
        _278 = 1.0 / _50;
    }
    float _275 = _278;
    float _286 = _275 * _275;
    float _290 = 0.087292902171611785888671875;
    _290 = (-0.3018949925899505615234375) + (_290 * _286);
    _290 = 1.0 + (_290 * _286);
    _290 *= _275;
    float _306;
    if (_50 < 1.0)
    {
        _306 = _290;
    }
    else
    {
        _306 = 1.57079637050628662109375 - _290;
    }
    return _306;
}

float _54(float _53)
{
    float _320 = abs(_53);
    float _317 = _51(_320);
    float _324;
    if (_53 < 0.0)
    {
        _324 = -_317;
    }
    else
    {
        _324 = _317;
    }
    return _324;
}

float _59(float _57, float _58)
{
    float _338 = _57 / _58;
    float _334 = _54(_338);
    SPIRV_CROSS_FLATTEN
    if (_58 < 0.0)
    {
        _334 += ((_57 >= 0.0) ? 3.1415927410125732421875 : (-3.1415927410125732421875));
    }
    return _334;
}

float _72(vec3 _71)
{
    bool _405 = _71.x == _71.y;
    bool _413;
    if (_405)
    {
        _413 = _71.y == _71.z;
    }
    else
    {
        _413 = _405;
    }
    float _416;
    if (_413)
    {
        _416 = 0.0;
    }
    else
    {
        float _436 = 1.73205077648162841796875 * (_71.y - _71.z);
        float _437 = ((2.0 * _71.x) - _71.y) - _71.z;
        _416 = 57.295780181884765625 * _59(_436, _437);
    }
    if (_416 < 0.0)
    {
        _416 += 360.0;
    }
    return _416;
}

float _142(float _140, float _141)
{
    float _1370 = _140 - _141;
    if (_1370 < (-180.0))
    {
        _1370 += 360.0;
    }
    else
    {
        if (_1370 > 180.0)
        {
            _1370 -= 360.0;
        }
    }
    return _1370;
}

float _135(float _133, float _134)
{
    float _1207[5] = float[]((-_134) / 2.0, (-_134) / 4.0, 0.0, _134 / 4.0, _134 / 2.0);
    float _1219 = 0.0;
    bool _1223 = _133 > _1207[0];
    bool _1230;
    if (_1223)
    {
        _1230 = _133 < _1207[4];
    }
    else
    {
        _1230 = _1223;
    }
    if (_1230)
    {
        float _1233 = ((_133 - _1207[0]) * 4.0) / _134;
        int _1241 = int(_1233);
        float _1244 = _1233 - float(_1241);
        float _1252[4] = float[]((_1244 * _1244) * _1244, _1244 * _1244, _1244, 1.0);
        if (_1241 == 3)
        {
            _1219 = (((_1252[0] * (-0.16666667163372039794921875)) + (_1252[1] * 0.5)) + (_1252[2] * (-0.5))) + (_1252[3] * 0.16666667163372039794921875);
        }
        else
        {
            if (_1241 == 2)
            {
                _1219 = (((_1252[0] * 0.5) + (_1252[1] * (-1.0))) + (_1252[2] * 0.0)) + (_1252[3] * 0.666666686534881591796875);
            }
            else
            {
                if (_1241 == 1)
                {
                    _1219 = (((_1252[0] * (-0.5)) + (_1252[1] * 0.5)) + (_1252[2] * 0.5)) + (_1252[3] * 0.16666667163372039794921875);
                }
                else
                {
                    if (_1241 == 0)
                    {
                        _1219 = (((_1252[0] * 0.16666667163372039794921875) + (_1252[1] * 0.0)) + (_1252[2] * 0.0)) + (_1252[3] * 0.0);
                    }
                    else
                    {
                        _1219 = 0.0;
                    }
                }
            }
        }
    }
    return (_1219 * 3.0) / 2.0;
}

mat3 _110(float _108, vec3 _109)
{
    mat3 _680;
    _680[0].x = ((1.0 - _108) * _109.x) + _108;
    _680[1].x = (1.0 - _108) * _109.x;
    _680[2].x = (1.0 - _108) * _109.x;
    _680[0].y = (1.0 - _108) * _109.y;
    _680[1].y = ((1.0 - _108) * _109.y) + _108;
    _680[2].y = (1.0 - _108) * _109.y;
    _680[0].z = (1.0 - _108) * _109.z;
    _680[1].z = (1.0 - _108) * _109.z;
    _680[2].z = ((1.0 - _108) * _109.z) + _108;
    return _680;
}

vec3 _202(vec3 _201)
{
    vec3 _2496 = _201;
    float _2495 = _69(_2496);
    vec3 _2500 = _201;
    float _2499 = _75(_2500);
    float _2509 = (_2495 - 0.4000000059604644775390625) / 0.20000000298023223876953125;
    float _2503 = _138(_2509);  // sigmoid_shaper
    float _2516 = _2499;
    float _2518 = 0.0500000007450580596923828125 * _2503;
    float _2519 = 0.07999999821186065673828125;
    float _2511 = 1.0 + _131(_2516, _2518, _2519);
    vec3 _2522 = _201 * _2511;
    vec3 _2527 = _2522;
    float _2526 = _72(_2527);
    float _2531 = _2526;
    float _2533 = 0.0;
    float _2530 = _142(_2531, _2533);
    float _2537 = _2530;
    float _2539 = 135.0;  // RRT_RED_WIDTH
    float _2535 = _135(_2537, _2539);
    _2522.x += (((_2535 * _2495) * (0.02999999932944774627685546875 - _2522.x)) * 0.180000007152557373046875);
    _2522 = max(_2522, vec3(0.0));
    vec3 _2571 = _2522;
    mat3 _2573 = mat3(vec3(1.45143926143646240234375, -0.236510753631591796875, -0.214928567409515380859375), vec3(-0.07655377686023712158203125, 1.1762297153472900390625, -0.0996759235858917236328125), vec3(0.0083161480724811553955078125, -0.0060324496589601039886474609375, 0.99771630764007568359375));
    vec3 _2557 = _40(_2571, _2573);
    _2557 = clamp(_2557, vec3(0.0), vec3(65504.0));
    float _2581 = 0.959999978542327880859375;                                                               // RRT_SAT_FACTOR
    vec3 _2582 = vec3(0.272228717803955078125, 0.674081742763519287109375, 0.053689517080783843994140625);  // AP1_RGB2Y
    mat3 _2579 = _110(_2581, _2582);
    vec3 _2584 = _2557;
    mat3 _2586 = _2579;
    _2557 = _40(_2584, _2586);
    return _2557;
}

float _62(float _61)
{
    return log2(_61) / 3.3219280242919921875;
}

vec3 _35(mat3 _33, vec3 _34)
{
    return _33 * _34;
}

float _65(float _64)
{
    return pow(10.0, _64);  // end SSTS
}

float _113(float _112)
{
    _748 _750 = _748(float[](-4.0, -4.0, -3.1573765277862548828125, -0.485249996185302734375, 1.84773242473602294921875, 1.84773242473602294921875), float[](-0.718548238277435302734375, 2.0810306072235107421875, 3.66812419891357421875, 4.0, 4.0, 4.0), _117(5.4931642807787284255027770996094e-06, 9.9999997473787516355514526367188e-05), _117(0.180000007152557373046875, 4.80000019073486328125), _117(47185.921875, 10000.0), 0.0, 0.0);
    float _775 = max(_112, 6.1035199905745685100555419921875e-05);
    float _771 = _62(_775);
    float _778 = _750._m2._m0;
    float _785;
    if (_771 <= _62(_778))
    {
        float _786 = _750._m2._m1;
        _785 = _62(_786);
    }
    else
    {
        float _792 = _750._m2._m0;
        bool _796 = _771 > _62(_792);
        bool _806;
        if (_796)
        {
            float _801 = _750._m3._m0;
            _806 = _771 < _62(_801);
        }
        else
        {
            _806 = _796;
        }
        if (_806)
        {
            float _811 = _750._m2._m0;
            float _817 = _750._m3._m0;
            float _821 = _750._m2._m0;
            float _809 = (3.0 * (_771 - _62(_811))) / (_62(_817) - _62(_821));
            int _828 = int(_809);
            float _831 = _809 - float(_828);
            vec3 _836 = vec3(_750._m0[_828], _750._m0[_828 + 1], _750._m0[_828 + 2]);
            vec3 _849 = vec3(_831 * _831, _831, 1.0);
            mat3 _862 = mat3(vec3(0.5, -1.0, 0.5), vec3(-1.0, 1.0, 0.5), vec3(0.5, 0.0, 0.0));
            vec3 _863 = _836;
            _785 = dot(_849, _35(_862, _863));
        }
        else
        {
            float _869 = _750._m3._m0;
            bool _873 = _771 >= _62(_869);
            bool _883;
            if (_873)
            {
                float _878 = _750._m4._m0;
                _883 = _771 < _62(_878);
            }
            else
            {
                _883 = _873;
            }
            if (_883)
            {
                float _888 = _750._m3._m0;
                float _894 = _750._m4._m0;
                float _898 = _750._m3._m0;
                float _886 = (3.0 * (_771 - _62(_888))) / (_62(_894) - _62(_898));
                int _904 = int(_886);
                float _907 = _886 - float(_904);
                vec3 _912 = vec3(_750._m1[_904], _750._m1[_904 + 1], _750._m1[_904 + 2]);
                vec3 _925 = vec3(_907 * _907, _907, 1.0);
                mat3 _932 = mat3(vec3(0.5, -1.0, 0.5), vec3(-1.0, 1.0, 0.5), vec3(0.5, 0.0, 0.0));
                vec3 _933 = _912;
                _785 = dot(_925, _35(_932, _933));
            }
            else
            {
                float _938 = _750._m4._m1;
                _785 = _62(_938);
            }
        }
    }
    float _942 = _785;
    return _65(_942);
}

vec3 _205(vec3 _204)
{
    vec3 _2593 = _204;
    vec3 _2592 = _202(_2593);
    float _2597 = _2592.x;
    vec3 _2596;
    _2596.x = _113(_2597);
    float _2602 = _2592.y;
    _2596.y = _113(_2602);
    float _2607 = _2592.z;
    _2596.z = _113(_2607);
    vec3 _2626 = _2596;
    mat3 _2628 = mat3(vec3(0.695452213287353515625, 0.140678703784942626953125, 0.16386906802654266357421875), vec3(0.0447945632040500640869140625, 0.859671115875244140625, 0.095534317195415496826171875), vec3(-0.0055258828215301036834716796875, 0.0040252101607620716094970703125, 1.00150072574615478515625));
    vec3 _2612 = _40(_2626, _2628);
    return _2612;
}

_118 _120()
{
    float _968 = 0.001988737843930721282958984375;
    float _972 = 0.180000007152557373046875;
    float _976 = 16.29174041748046875;
    _118 _947 = _118(float[](-1.69896996021270751953125, -1.69896996021270751953125, -1.477900028228759765625, -1.2290999889373779296875, -0.864799976348876953125, -0.448000013828277587890625, 0.0051799998618662357330322265625, 0.451108038425445556640625, 0.91137444972991943359375, 0.91137444972991943359375), float[](0.51543867588043212890625, 0.8470437526702880859375, 1.13580000400543212890625, 1.38020002841949462890625, 1.51970005035400390625, 1.5985000133514404296875, 1.64670002460479736328125, 1.67460918426513671875, 1.687873363494873046875, 1.687873363494873046875), _117(_113(_968), 0.0199999995529651641845703125), _117(_113(_972), 4.80000019073486328125), _117(_113(_976), 48.0), 0.0, 0.039999999105930328369140625);
    return _947;
}

float _126(float _124, _118 _125)
{
    float _988 = max(_124, 6.1035199905745685100555419921875e-05);
    float _985 = _62(_988);
    float _991 = _125._m2._m0;
    float _998;
    if (_985 <= _62(_991))
    {
        float _1004 = _125._m2._m1;
        float _1010 = _125._m2._m0;
        _998 = (_985 * _125._m5) + (_62(_1004) - (_125._m5 * _62(_1010)));
    }
    else
    {
        float _1019 = _125._m2._m0;
        bool _1023 = _985 > _62(_1019);
        bool _1032;
        if (_1023)
        {
            float _1027 = _125._m3._m0;
            _1032 = _985 < _62(_1027);
        }
        else
        {
            _1032 = _1023;
        }
        if (_1032)
        {
            float _1038 = _125._m2._m0;
            float _1044 = _125._m3._m0;
            float _1048 = _125._m2._m0;
            float _1035 = (7.0 * (_985 - _62(_1038))) / (_62(_1044) - _62(_1048));
            int _1054 = int(_1035);
            float _1057 = _1035 - float(_1054);
            vec3 _1062 = vec3(_125._m0[_1054], _125._m0[_1054 + 1], _125._m0[_1054 + 2]);
            vec3 _1075 = vec3(_1057 * _1057, _1057, 1.0);
            mat3 _1082 = mat3(vec3(0.5, -1.0, 0.5), vec3(-1.0, 1.0, 0.5), vec3(0.5, 0.0, 0.0));
            vec3 _1083 = _1062;
            _998 = dot(_1075, _35(_1082, _1083));
        }
        else
        {
            float _1089 = _125._m3._m0;
            bool _1093 = _985 >= _62(_1089);
            bool _1102;
            if (_1093)
            {
                float _1097 = _125._m4._m0;
                _1102 = _985 < _62(_1097);
            }
            else
            {
                _1102 = _1093;
            }
            if (_1102)
            {
                float _1107 = _125._m3._m0;
                float _1113 = _125._m4._m0;
                float _1117 = _125._m3._m0;
                float _1105 = (7.0 * (_985 - _62(_1107))) / (_62(_1113) - _62(_1117));
                int _1123 = int(_1105);
                float _1126 = _1105 - float(_1123);
                vec3 _1131 = vec3(_125._m1[_1123], _125._m1[_1123 + 1], _125._m1[_1123 + 2]);
                vec3 _1144 = vec3(_1126 * _1126, _1126, 1.0);
                mat3 _1151 = mat3(vec3(0.5, -1.0, 0.5), vec3(-1.0, 1.0, 0.5), vec3(0.5, 0.0, 0.0));
                vec3 _1152 = _1131;
                _998 = dot(_1144, _35(_1151, _1152));
            }
            else
            {
                float _1162 = _125._m4._m1;
                float _1168 = _125._m4._m0;
                _998 = (_985 * _125._m6) + (_62(_1162) - (_125._m6 * _62(_1168)));
            }
        }
    }
    float _1175 = _998;
    return _65(_1175);
}

float _86(float _83, float _84, float _85)
{
    return (_83 - _85) / (_84 - _85);
}

vec3 _92(vec3 _89, float _90, float _91)
{
    float _563 = _89.x;
    float _566 = _90;
    float _568 = _91;
    float _571 = _89.y;
    float _574 = _90;
    float _576 = _91;
    float _579 = _89.z;
    float _582 = _90;
    float _584 = _91;
    return vec3(_86(_563, _566, _568), _86(_571, _574, _576), _86(_579, _582, _584));
}

vec3 _78(vec3 _77)
{
    float _493 = (_77.x + _77.y) + _77.z;
    if (_493 == 0.0)
    {
        _493 = 1.0000000133514319600180897396058e-10;
    }
    vec3 _506;
    _506.x = _77.x / _493;
    _506.y = _77.y / _493;
    _506.z = _77.y;
    return _506;
}

vec3 _81(vec3 _80)
{
    vec3 _523;
    _523.x = (_80.x * _80.z) / max(_80.y, 1.0000000133514319600180897396058e-10);
    _523.y = _80.z;
    _523.z = (((1.0 - _80.x) - _80.y) * _80.z) / max(_80.y, 1.0000000133514319600180897396058e-10);
    return _523;
}

vec3 _105(vec3 _104)
{
    vec3 _640 = _104;
    mat3 _642 = mat3(vec3(0.662454187870025634765625, 0.1340042054653167724609375, 0.1561876833438873291015625), vec3(0.272228717803955078125, 0.674081742763519287109375, 0.053689517080783843994140625), vec3(-0.0055746496655046939849853515625, 0.0040607335977256298065185546875, 1.01033914089202880859375));
    vec3 _626 = _40(_640, _642);
    vec3 _645 = _626;
    vec3 _644 = _78(_645);
    _644.z = clamp(_644.z, 0.0, 65504.0);
    _644.z = pow(_644.z, 0.981100022792816162109375);
    vec3 _658 = _644;
    _626 = _81(_658);
    vec3 _674 = _626;
    mat3 _676 = mat3(vec3(1.6410233974456787109375, -0.324803292751312255859375, -0.23642469942569732666015625), vec3(-0.663662850856781005859375, 1.6153316497802734375, 0.016756348311901092529296875), vec3(0.01172189414501190185546875, -0.008284442126750946044921875, 0.98839485645294189453125));
    return _40(_674, _676);
}

vec3 _11(vec3 _10)
{
    return clamp(_10, vec3(0.0), vec3(1.0));
}

float _151(float _149[2][2], float _150)
{
    if (_150 < _149[0][0])
    {
        return _149[0][1];
    }
    if (_150 >= _149[1][0])
    {
        return _149[1][1];
    }
    int _1410 = 0;
    int _1411 = 1;
    while (_1410 < (_1411 - 1))
    {
        int _1421 = (_1410 + _1411) / 2;
        if (_149[_1421][0] == _150)
        {
            return _149[_1421][1];
        }
        else
        {
            if (_149[_1421][0] < _150)
            {
                _1410 = _1421;
            }
            else
            {
                _1411 = _1421;
            }
        }
    }
    float _1448 = (_150 - _149[_1410][0]) / (_149[_1410 + 1][0] - _149[_1410][0]);
    float _1463 = 1.0 - _1448;
    return (_1463 * _149[_1410][1]) + (_1448 * _149[_1410 + 1][1]);
}

float _154(float _153)
{
    float _1481 = 9.9999997473787516355514526367188e-05;
    float _1485 = 0.0199999995529651641845703125;
    float _1480[2][2] = float[][](float[](_62(_1481), -15.0), float[](_62(_1485), -6.5));
    float _1490 = _153;
    float _1493[2][2] = _1480;
    float _1495 = _62(_1490);
    return 0.180000007152557373046875 * pow(2.0, _151(_1493, _1495));
}

float _157(float _156)
{
    float _1502 = 48.0;     // MAX_LUM_SDR
    float _1506 = 10000.0;  // MAX_LUM_RRT

    // MAX_STOP_SDR, MAX_STOP_RRT
    float _1501[2][2] = float[][](float[](_62(_1502), 6.5), float[](_62(_1506), 18.0));
    float _1511 = _156;
    float _1514[2][2] = _1501;
    float _1516 = _62(_1511);
    return 0.180000007152557373046875 * pow(2.0, _151(_1514, _1516));
}

_163 _167(_159 _165, _159 _166)
{
    float _1523 = _166._m0;
    float _1527 = _165._m0;
    float _1522 = (_62(_1523) - _62(_1527)) / 3.0;
    float _1537 = _165._m0;
    float _1545 = _165._m1;
    float _1551 = _165._m0;
    _163 _1534;
    _1534._m0[0] = (_165._m2 * (_62(_1537) - (0.5 * _1522))) + (_62(_1545) - (_165._m2 * _62(_1551)));
    float _1561 = _165._m0;
    float _1569 = _165._m1;
    float _1575 = _165._m0;
    _1534._m0[1] = (_165._m2 * (_62(_1561) + (0.5 * _1522))) + (_62(_1569) - (_165._m2 * _62(_1575)));
    float _1585 = _166._m0;
    float _1593 = _166._m1;
    float _1599 = _166._m0;
    _1534._m0[3] = (_166._m2 * (_62(_1585) - (0.5 * _1522))) + (_62(_1593) - (_166._m2 * _62(_1599)));
    float _1609 = _166._m0;
    float _1617 = _166._m1;
    float _1623 = _166._m0;
    _1534._m0[4] = (_166._m2 * (_62(_1609) + (0.5 * _1522))) + (_62(_1617) - (_166._m2 * _62(_1623)));
    float _1641[2][2] = _1635;
    float _1643 = log2(_165._m0 / 0.180000007152557373046875);
    float _1636 = _151(_1641, _1643);
    float _1645 = _165._m1;
    float _1650 = _166._m1;
    float _1654 = _165._m1;
    _1534._m0[2] = _62(_1645) + (_1636 * (_62(_1650) - _62(_1654)));
    return _1534;
}

_163 _171(_159 _169, _159 _170)
{
    float _1666 = _170._m0;
    float _1670 = _169._m0;
    float _1665 = (_62(_1666) - _62(_1670)) / 3.0;
    float _1679 = _169._m0;
    float _1687 = _169._m1;
    float _1693 = _169._m0;
    _163 _1676;
    _1676._m0[0] = (_169._m2 * (_62(_1679) - (0.5 * _1665))) + (_62(_1687) - (_169._m2 * _62(_1693)));
    float _1703 = _169._m0;
    float _1711 = _169._m1;
    float _1717 = _169._m0;
    _1676._m0[1] = (_169._m2 * (_62(_1703) + (0.5 * _1665))) + (_62(_1711) - (_169._m2 * _62(_1717)));
    float _1727 = _170._m0;
    float _1735 = _170._m1;
    float _1741 = _170._m0;
    _1676._m0[3] = (_170._m2 * (_62(_1727) - (0.5 * _1665))) + (_62(_1735) - (_170._m2 * _62(_1741)));
    float _1751 = _170._m0;
    float _1759 = _170._m1;
    float _1765 = _170._m0;
    _1676._m0[4] = (_170._m2 * (_62(_1751) + (0.5 * _1665))) + (_62(_1759) - (_170._m2 * _62(_1765)));
    float _1784[2][2] = _1778;
    float _1786 = log2(_170._m0 / 0.180000007152557373046875);
    float _1779 = _151(_1784, _1786);
    float _1788 = _169._m1;
    float _1793 = _170._m1;
    float _1797 = _169._m1;
    _1676._m0[2] = _62(_1788) + (_1779 * (_62(_1793) - _62(_1797)));
    return _1676;
}

float _175(float _173, float _174)
{
    return pow(2.0, log2(_173) - _174);
}

_179 _184(float _181, float _182, float _183)
{
    float _1816 = _181;
    _159 _1815 = _159(_154(_1816), _181, 0.0);

    _159 _1821 = _159(0.18, 4.8, 1.55);  // ACES MID_PT

    float _1825 = _182;
    _159 _1824 = _159(_157(_1825), _182, 0.0);
    _159 _1831 = _1815;
    _159 _1833 = _1821;
    _163 _1830 = _167(_1831, _1833);
    _159 _1837 = _1821;
    _159 _1839 = _1824;
    _163 _1836 = _171(_1837, _1839);
    float _1842 = _181;
    float _1845 = _154(_1842);
    float _1846 = _183;
    _1815._m0 = _175(_1845, _1846);
    float _1850 = 0.180000007152557373046875;
    float _1851 = _183;
    _1821._m0 = _175(_1850, _1851);
    float _1855 = _182;
    float _1858 = _157(_1855);
    float _1859 = _183;
    _1824._m0 = _175(_1858, _1859);
    _179 _1863 = _179(_159(_1815._m0, _1815._m1, _1815._m2), _159(_1821._m0, _1821._m1, _1821._m2), _159(_1824._m0, _1824._m1, _1824._m2), float[](_1830._m0[0], _1830._m0[1], _1830._m0[2], _1830._m0[3], _1830._m0[4], _1830._m0[4]), float[](_1836._m0[0], _1836._m0[1], _1836._m0[2], _1836._m0[3], _1836._m0[4], _1836._m0[4]));
    return _1863;
}

float _199(float _197, _179 _198)
{
    float _2133 = _198._m1._m0;
    float _2137 = _198._m0._m0;
    float _2132 = (_62(_2133) - _62(_2137)) / 3.0;
    float _2144 = _198._m2._m0;
    float _2148 = _198._m1._m0;
    float _2143 = (_62(_2144) - _62(_2148)) / 3.0;
    float _2162[4];
    for (int _2154 = 0; _2154 < 4; _2154++)
    {
        _2162[_2154] = (_198._m3[_2154] + _198._m3[_2154 + 1]) / 2.0;
    }
    float _2184[4];
    for (int _2176 = 0; _2176 < 4; _2176++)
    {
        _2184[_2176] = (_198._m4[_2176] + _198._m4[_2176 + 1]) / 2.0;
    }
    float _2201 = max(_197, 1.0000000133514319600180897396058e-10);
    float _2198 = _62(_2201);
    float _2204 = _198._m0._m1;
    float _2211;
    if (_2198 <= _62(_2204))
    {
        float _2212 = _198._m0._m0;
        _2211 = _62(_2212);
    }
    else
    {
        float _2218 = _198._m0._m1;
        bool _2222 = _2198 > _62(_2218);
        bool _2231;
        if (_2222)
        {
            float _2226 = _198._m1._m1;
            _2231 = _2198 <= _62(_2226);
        }
        else
        {
            _2231 = _2222;
        }
        if (_2231)
        {
            bool _2237 = _2198 > _2162[0];
            bool _2244;
            if (_2237)
            {
                _2244 = _2198 <= _2162[1];
            }
            else
            {
                _2244 = _2237;
            }
            vec3 _2247;
            uint _2258;
            if (_2244)
            {
                _2247.x = _198._m3[0];
                _2247.y = _198._m3[1];
                _2247.z = _198._m3[2];
                _2258 = 0u;
            }
            else
            {
                bool _2263 = _2198 > _2162[1];
                bool _2270;
                if (_2263)
                {
                    _2270 = _2198 <= _2162[2];
                }
                else
                {
                    _2270 = _2263;
                }
                if (_2270)
                {
                    _2247.x = _198._m3[1];
                    _2247.y = _198._m3[2];
                    _2247.z = _198._m3[3];
                    _2258 = 1u;
                }
                else
                {
                    bool _2286 = _2198 > _2162[2];
                    bool _2293;
                    if (_2286)
                    {
                        _2293 = _2198 <= _2162[3];
                    }
                    else
                    {
                        _2293 = _2286;
                    }
                    if (_2293)
                    {
                        _2247.x = _198._m3[2];
                        _2247.y = _198._m3[3];
                        _2247.z = _198._m3[4];
                        _2258 = 2u;
                    }
                }
            }
            mat3 _2306 = mat3(vec3(0.5, -1.0, 0.5), vec3(-1.0, 1.0, 0.5), vec3(0.5, 0.0, 0.0));
            vec3 _2307 = _2247;
            vec3 _2305 = _35(_2306, _2307);
            float _2310 = _2305.x;
            float _2313 = _2305.y;
            float _2316 = _2305.z;
            _2316 -= _2198;
            float _2322 = sqrt((_2313 * _2313) - ((4.0 * _2310) * _2316));
            float _2332 = (2.0 * _2316) / ((-_2322) - _2313);
            float _2340 = _198._m0._m0;
            _2211 = _62(_2340) + ((_2332 + float(_2258)) * _2132);
        }
        else
        {
            float _2353 = _198._m1._m1;
            bool _2357 = _2198 > _62(_2353);
            bool _2366;
            if (_2357)
            {
                float _2361 = _198._m2._m1;
                _2366 = _2198 < _62(_2361);
            }
            else
            {
                _2366 = _2357;
            }
            if (_2366)
            {
                bool _2372 = _2198 >= _2184[0];
                bool _2379;
                if (_2372)
                {
                    _2379 = _2198 <= _2184[1];
                }
                else
                {
                    _2379 = _2372;
                }
                vec3 _2382;
                uint _2392;
                if (_2379)
                {
                    _2382.x = _198._m4[0];
                    _2382.y = _198._m4[1];
                    _2382.z = _198._m4[2];
                    _2392 = 0u;
                }
                else
                {
                    bool _2397 = _2198 > _2184[1];
                    bool _2404;
                    if (_2397)
                    {
                        _2404 = _2198 <= _2184[2];
                    }
                    else
                    {
                        _2404 = _2397;
                    }
                    if (_2404)
                    {
                        _2382.x = _198._m4[1];
                        _2382.y = _198._m4[2];
                        _2382.z = _198._m4[3];
                        _2392 = 1u;
                    }
                    else
                    {
                        bool _2420 = _2198 > _2184[2];
                        bool _2427;
                        if (_2420)
                        {
                            _2427 = _2198 <= _2184[3];
                        }
                        else
                        {
                            _2427 = _2420;
                        }
                        if (_2427)
                        {
                            _2382.x = _198._m4[2];
                            _2382.y = _198._m4[3];
                            _2382.z = _198._m4[4];
                            _2392 = 2u;
                        }
                    }
                }
                mat3 _2440 = mat3(vec3(0.5, -1.0, 0.5), vec3(-1.0, 1.0, 0.5), vec3(0.5, 0.0, 0.0));
                vec3 _2441 = _2382;
                vec3 _2439 = _35(_2440, _2441);
                float _2444 = _2439.x;
                float _2447 = _2439.y;
                float _2450 = _2439.z;
                _2450 -= _2198;
                float _2456 = sqrt((_2447 * _2447) - ((4.0 * _2444) * _2450));
                float _2466 = (2.0 * _2450) / ((-_2456) - _2447);
                float _2474 = _198._m1._m0;
                _2211 = _62(_2474) + ((_2466 + float(_2392)) * _2143);
            }
            else
            {
                float _2486 = _198._m2._m0;
                _2211 = _62(_2486);
            }
        }
    }
    float _2490 = _2211;
    return _65(_2490);
}

float _190(float _188, _179 _189)
{
    float _1918 = max(_188, 6.1035199905745685100555419921875e-05);
    float _1915 = _62(_1918);
    float _1921 = _189._m0._m0;
    float _1928;
    if (_1915 <= _62(_1921))
    {
        float _1933 = _189._m0._m1;
        float _1939 = _189._m0._m0;
        _1928 = (_1915 * _189._m0._m2) + (_62(_1933) - (_189._m0._m2 * _62(_1939)));
    }
    else
    {
        float _1948 = _189._m0._m0;
        bool _1952 = _1915 > _62(_1948);
        bool _1961;
        if (_1952)
        {
            float _1956 = _189._m1._m0;
            _1961 = _1915 < _62(_1956);
        }
        else
        {
            _1961 = _1952;
        }
        if (_1961)
        {
            float _1966 = _189._m0._m0;
            float _1972 = _189._m1._m0;
            float _1976 = _189._m0._m0;
            float _1964 = (3.0 * (_1915 - _62(_1966))) / (_62(_1972) - _62(_1976));
            int _1982 = int(_1964);
            float _1985 = _1964 - float(_1982);
            vec3 _1990 = vec3(_189._m3[_1982], _189._m3[_1982 + 1], _189._m3[_1982 + 2]);
            vec3 _2003 = vec3(_1985 * _1985, _1985, 1.0);
            mat3 _2010 = mat3(vec3(0.5, -1.0, 0.5), vec3(-1.0, 1.0, 0.5), vec3(0.5, 0.0, 0.0));
            vec3 _2011 = _1990;
            _1928 = dot(_2003, _35(_2010, _2011));
        }
        else
        {
            float _2017 = _189._m1._m0;
            bool _2021 = _1915 >= _62(_2017);
            bool _2030;
            if (_2021)
            {
                float _2025 = _189._m2._m0;
                _2030 = _1915 < _62(_2025);
            }
            else
            {
                _2030 = _2021;
            }
            if (_2030)
            {
                float _2035 = _189._m1._m0;
                float _2041 = _189._m2._m0;
                float _2045 = _189._m1._m0;
                float _2033 = (3.0 * (_1915 - _62(_2035))) / (_62(_2041) - _62(_2045));
                int _2051 = int(_2033);
                float _2054 = _2033 - float(_2051);
                vec3 _2059 = vec3(_189._m4[_2051], _189._m4[_2051 + 1], _189._m4[_2051 + 2]);
                vec3 _2072 = vec3(_2054 * _2054, _2054, 1.0);
                mat3 _2079 = mat3(vec3(0.5, -1.0, 0.5), vec3(-1.0, 1.0, 0.5), vec3(0.5, 0.0, 0.0));
                vec3 _2080 = _2059;
                _1928 = dot(_2072, _35(_2079, _2080));
            }
            else
            {
                float _2089 = _189._m2._m1;
                float _2095 = _189._m2._m0;
                _1928 = (_1915 * _189._m2._m2) + (_62(_2089) - (_189._m2._m2 * _62(_2095)));
            }
        }
    }
    float _2102 = _1928;
    return _65(_2102);
}

vec3 _195(vec3 _193, _179 _194)
{
    float _2108 = _193.x;
    _179 _2111 = _194;
    vec3 _2107;
    _2107.x = _190(_2108, _2111);
    float _2115 = _193.y;
    _179 _2118 = _194;
    _2107.y = _190(_2115, _2118);
    float _2122 = _193.z;
    _179 _2125 = _194;
    _2107.z = _190(_2122, _2125);
    return _2107;
}

float _97(float _94, float _95, float _96)
{
    return (_94 * (_95 - _96)) + _96;
}

vec3 _102(vec3 _99, float _100, float _101)
{
    float _599 = _99.x;
    float _602 = _100;
    float _604 = _101;
    float _607 = _99.y;
    float _610 = _100;
    float _612 = _101;
    float _615 = _99.z;
    float _618 = _100;
    float _620 = _101;
    return vec3(_97(_599, _602, _604), _97(_607, _610, _612), _97(_615, _618, _620));
}

vec3 _221(vec3 _218, bool _219, _215 _220, float paper_white)
{
    // _218 is untonemapped
    vec3 _2690 = _218;
    vec3 _2689 = _211(_2690);   // BT.709 -> AP0
    vec3 _2693 = vec3(0.0);
    float _2694 = 0.0;
    float _2695 = 0.0;
    vec3 _2696 = vec3(0.0);
    if (_219 == false)  // SDR
    {
        vec3 _2703 = _2689;
        vec3 _2702 = _205(_2703);
        vec3 _2707 = _2702;
        // AP0 -> AP1
        mat3 _2709 = mat3(vec3(1.45143926143646240234375, -0.236510753631591796875, -0.214928567409515380859375), vec3(-0.07655377686023712158203125, 1.1762297153472900390625, -0.0996759235858917236328125), vec3(0.0083161480724811553955078125, -0.0060324496589601039886474609375, 0.99771630764007568359375));
        vec3 _2706 = _40(_2707, _2709);
        _2694 = 0.02;  // min nits
        _2695 = 48.0;  // max nits
        float _2712 = _2706.x;
        _118 _2715 = _120();
        _2693.x = _126(_2712, _2715);
        float _2719 = _2706.y;
        _118 _2722 = _120();
        _2693.y = _126(_2719, _2722);
        float _2726 = _2706.z;
        _118 _2729 = _120();
        _2693.z = _126(_2726, _2729);
        vec3 _2732 = _2693;
        float _2734 = _2695;
        float _2736 = _2694;
        // (untonemapped, max_nits, min_nits)
        _2696 = _92(_2732, _2734, _2736);
        vec3 _2739 = _2696;
        _2696 = _105(_2739);
        float _2744 = 0.930000007152557373046875;
        // y from AP1
        vec3 _2745 = vec3(0.272228717803955078125, 0.674081742763519287109375, 0.053689517080783843994140625);
        mat3 _2742 = _110(_2744, _2745);
        vec3 _2747 = _2696;
        mat3 _2749 = _2742;
        _2696 = _40(_2747, _2749);
        vec3 _2753 = _2696;
        // AP1 -> XYZ
        mat3 _2755 = mat3(vec3(0.662454187870025634765625, 0.1340042054653167724609375, 0.1561876833438873291015625), vec3(0.272228717803955078125, 0.674081742763519287109375, 0.053689517080783843994140625), vec3(-0.0055746496655046939849853515625, 0.0040607335977256298065185546875, 1.01033914089202880859375));
        vec3 _2752 = _40(_2753, _2755);
        vec3 _2770 = _2752;
        // D60 -> D65
        mat3 _2772 = mat3(vec3(0.987228810787200927734375, -0.00611330009996891021728515625, 0.0159534104168415069580078125), vec3(-0.007598400115966796875, 1.00185978412628173828125, 0.0053300000727176666259765625), vec3(0.00307258008979260921478271484375, -0.0050959200598299503326416015625, 1.0816795825958251953125));
        _2696 = _40(_2770, _2772);
        vec3 _2787 = _2696;
        // XYZ -> BT.709
        mat3 _2789 = mat3(vec3(3.2409694194793701171875, -1.53738296031951904296875, -0.4986107647418975830078125), vec3(-0.96924388408660888671875, 1.87596786022186279296875, 0.041555099189281463623046875), vec3(0.055630020797252655029296875, -0.2039768397808074951171875, 1.0569713115692138671875));
        _2696 = _40(_2787, _2789);
        vec3 _2791 = _2696;
        _2696 = _11(_2791);
    }
    else  // HDR
    {
        float _2795 = _220._m2; // brightness
        _2694 = max(9.9999997473787516355514526367188e-05, _220._m0);   // min nits
        _2695 = _220._m1;                                               // max nits


        float _2804 = _2694;
        float _2806 = _2695;
        float _2808 = 0.0;
        _179 _2803 = _184(_2804, _2806, _2808);
        float _2811 = _2795;
        _179 _2813 = _2803;
        float _2810 = log2(_199(_2811, _2813)) - (-2.4739310741424560546875);
        float _2820 = _2694;
        float _2822 = _2695;
        float _2824 = _2810;
        _179 _2819 = _184(_2820, _2822, _2824);
        vec3 _2828 = _2689;
        vec3 _2827 = _202(_2828);  // RRT
        vec3 _2831 = _2827;
        _179 _2833 = _2819;
        _2693 = _195(_2831, _2833);
        vec3 _2836 = _2693;
        float _2838 = _2695;
        float _2840 = _2694;
        // (untonemapped, max_nits, min_nits)
        _2696 = _92(_2836, _2838, _2840);
        vec3 _2844 = _2696;
        // AP1 -> XYZ
        mat3 _2846 = mat3(vec3(0.662454187870025634765625, 0.1340042054653167724609375, 0.1561876833438873291015625), vec3(0.272228717803955078125, 0.674081742763519287109375, 0.053689517080783843994140625), vec3(-0.0055746496655046939849853515625, 0.0040607335977256298065185546875, 1.01033914089202880859375));
        vec3 _2843 = _40(_2844, _2846);
        vec3 _2848 = _2843;
        // D60 -> D65
        mat3 _2850 = mat3(vec3(0.987228810787200927734375, -0.00611330009996891021728515625, 0.0159534104168415069580078125), vec3(-0.007598400115966796875, 1.00185978412628173828125, 0.0053300000727176666259765625), vec3(0.00307258008979260921478271484375, -0.0050959200598299503326416015625, 1.0816795825958251953125));
        _2696 = _40(_2848, _2850);
        vec3 _2865 = _2696;

        // XYZ -> BT.2020
        mat3 _2867 = mat3(vec3(1.71665096282958984375, -0.35567080974578857421875, -0.2533662319183349609375), vec3(-0.666684329509735107421875, 1.616481304168701171875, 0.0157685391604900360107421875), vec3(0.0176398493349552154541015625, -0.04277060925960540771484375, 0.94210326671600341796875));
        _2696 = _40(_2865, _2867);
        _2696 = max(vec3(0.0), _2696);
        vec3 _2871 = _2696;


        float _2873 = _2695;
        float _2875 = _2694;
        _2696 = max(vec3(0.0), _102(_2871, _2873, _2875));
    }
    return _2696;
}

void main()
{
    _224 = 2147483648u;
    _226 = 1073741824u;
    ivec3 _2884 = ivec3(gl_GlobalInvocationID);
    int _2890 = int(_2895._m44);
    bool _2904 = _2884.x >= _2890;
    bool _2912;
    if (!_2904)
    {
        _2912 = _2884.y >= _2890;
    }
    else
    {
        _2912 = _2904;
    }
    bool _2920;
    if (!_2912)
    {
        _2920 = _2884.z >= _2890;
    }
    else
    {
        _2920 = _2912;
    }
    SPIRV_CROSS_BRANCH
    if (_2920)
    {
        return;
    }
    vec3 _2924 = vec3(_2884) / vec3(_2895._m44 - 1.0);
    vec3 _2932 = _2924;
    _2924 = _208(_2932);
    float _2944 = _2940._m0._m1;
    uint _2935 = _17(_2944);
    _215 _2949;
    _2949._m0 = _2940._m0._m2;  // min nits
    _2949._m1 = _2895._m45;        // max nits
    _2949._m2 = _2940._m0._m3;     // mid point slider

    float paper_white = _2940._m0._m3 * 10.0;

    float _2968 = float(_2935 & 1u);
    bool _2964 = _17(_2968) != 0u;
    vec3 _2972 = _2924;
    bool useHDR = _2964; // true = HDR, false = SDR
    _215 _2976 = _2949;

// CUSTOM


    uint GAMMA_CORRECTION_TYPE = 1u;  // 0 - sRGB -> 2.2 Correction, 1 - ACES minimum nits
    bool USE_SHORTFUSE_ACES = true;
    bool USE_PER_CHANNEL_CORRECTION = true;

    vec3 _2971;
    if (!USE_SHORTFUSE_ACES || !useHDR) {
        _2971 = _221(_2972, useHDR, _2976, paper_white);
    } else {

        const float ACES_MIN = 0.0001f;
        float aces_min = ACES_MIN / paper_white;
        float aces_max = (_2949._m1 / paper_white);

        if (GAMMA_CORRECTION_TYPE == 0u) {
            aces_max = CorrectGammaMismatch(aces_max, true);
            aces_min = CorrectGammaMismatch(aces_min, true);
        } else {
            aces_min /= 10.f;
        }

        // Apply ACES ToneMap
        vec3 untonemapped_ap0 = BT709_TO_AP0_MAT * _2972;
        vec3 untonemapped_graded_ap1 = RRT(untonemapped_ap0);
        vec3 tonemapped_bt709 = ODT(untonemapped_graded_ap1, aces_min * 48.0, aces_max * 48.0, AP1_TO_BT709_MAT) / 48.f;

        if (USE_PER_CHANNEL_CORRECTION) {
            vec3 untonemapped_graded_bt709 = AP1_TO_BT709_MAT * untonemapped_graded_ap1;
            untonemapped_graded_bt709 *= 0.1 / 0.18;  // match mid-gray

            vec3 corrected_bt709 = CorrectHue(tonemapped_bt709, untonemapped_graded_bt709, 1.0);

            // blend hue-corrected only in midtones and shadows
            float tonemapped_lum = dot(tonemapped_bt709, vec3(0.2126390059, 0.7151686788, 0.0721923154));
            tonemapped_bt709 = mix(tonemapped_bt709, corrected_bt709, clamp((1.0 - tonemapped_lum), 0.0, 1.0));
        }

        if (GAMMA_CORRECTION_TYPE == 0u) {
            tonemapped_bt709 = CorrectGammaMismatch(tonemapped_bt709, false);
        }

        vec3 tonemapped_bt2020 = BT709_TO_BT2020_MAT * tonemapped_bt709;
        tonemapped_bt2020 *= paper_white;
        _2971 = tonemapped_bt2020;
    }
// END CUSTOM

    imageStore(_2981, ivec3(_2884), vec4(_2971, 1.0));
}

