#include "ReShade.fxh"

// clang-format off
static const float3x3 BT709_2_XYZ_MAT = float3x3(
  0.4123907983303070068359375f,    0.3575843274593353271484375f,   0.18048079311847686767578125f,
  0.2126390039920806884765625f,    0.715168654918670654296875f,    0.072192318737506866455078125f,
  0.0193308182060718536376953125f, 0.119194783270359039306640625f, 0.950532138347625732421875f
);

static const float3x3 XYZ_2_BT709_MAT = float3x3(
   3.2409699419, -1.5373831776, -0.4986107603,
  -0.9692436363,  1.8759675015,  0.0415550574,
   0.0556300797, -0.2039769589,  1.0569715142
);

static const float3x3 D65_2_D60_CAT = float3x3(
   1.01303,    0.00610531, -0.014971,
   0.00769823, 0.998165,   -0.00503203,
  -0.00284131, 0.00468516,  0.924507
);

static const float3x3 D60_2_D65_CAT = float3x3(
   0.98722400, -0.00611327, 0.0159533,
  -0.00759836,  1.00186000, 0.0053302,
   0.00307257, -0.00509595, 1.0816800
);

static const float3x3 AP0_2_AP1_MAT = float3x3(
   1.4514393161, -0.2365107469, -0.2149285693,
  -0.0765537734,  1.1762296998, -0.0996759264,
   0.0083161484, -0.0060324498,  0.9977163014
);

static const float3x3 XYZ_2_AP0_MAT = float3x3(
   1.0498110175, 0.0000000000,-0.0000974845,
  -0.4959030231, 1.3733130458, 0.0982400361,
   0.0000000000, 0.0000000000, 0.9912520182
);

static const float3x3 XYZ_2_AP1_MAT = float3x3(
   1.6410233797, -0.3248032942, -0.2364246952,
  -0.6636628587,  1.6153315917,  0.0167563477,
   0.0117218943, -0.0082844420,  0.9883948585
);

static const float3x3 XYZ_2_BT2020_MAT = float3x3(
   1.7166511880, -0.3556707838, -0.2533662814,
  -0.6666843518,  1.6164812366,  0.0157685458,
   0.0176398574, -0.0427706133,  0.9421031212
);

static const float3x3 AP1_2_XYZ_MAT = float3x3(
   0.6624541811, 0.1340042065, 0.1561876870,
   0.2722287168, 0.6740817658, 0.0536895174,
  -0.0055746495, 0.0040607335, 1.0103391003
);


static const float3x3 BT709_2_BT2020_MAT = float3x3(
  0.627403914928436279296875f,      0.3292830288410186767578125f,  0.0433130674064159393310546875f,
  0.069097287952899932861328125f,   0.9195404052734375f,           0.011362315155565738677978515625f,
  0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f
);

static const float3x3 BT2020_2_BT709_MAT = float3x3(
   1.66049098968505859375f,          -0.58764111995697021484375f,     -0.072849862277507781982421875f,
  -0.12455047667026519775390625f,     1.13289988040924072265625f,     -0.0083494223654270172119140625f,
  -0.01815076358616352081298828125f, -0.100578896701335906982421875f,  1.11872971057891845703125f
);

static const float3x3 BT2020_2_XYZ_MAT = float3x3(
  0.6369736, 0.1446172, 0.1688585,
  0.2627066, 0.6779996, 0.0592938,
  0.0000000, 0.0280728, 1.0608437
);

static const float3x3 IDENTITY_MAT = float3x3(
  1.0f, 0.0f, 0.0f,
  0.0f, 1.0f, 0.0f,
  0.0f, 0.0f, 1.0f
);

// clang-format on

#define FLT_MIN asfloat(0x00800000)  //1.175494351e-38f
#define FLT_MAX asfloat(0x7F7FFFFF)  //3.402823466e+38f

// clang-format off
static const float3x3 RRT_SAT_MAT = float3x3(
  0.9708890, 0.0269633, 0.00214758,
  0.0108892, 0.9869630, 0.00214758,
  0.0108892, 0.0269633, 0.96214800
);

static const float3x3 ODT_SAT_MAT = float3x3(
  0.949056, 0.0471857, 0.00375827,
  0.019056, 0.9771860, 0.00375827,
  0.019056, 0.0471857, 0.93375800
);

static const float3x3 M = float3x3(
   0.5, -1.0, 0.5,
  -1.0,  1.0, 0.0,
   0.5,  0.5, 0.0
);

// clang-format on

float rgb_2_yc(float3 rgb) {
  float ycRadiusWeight = 1.75;
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

  return (b + g + r + ycRadiusWeight * chroma) / 3.;
}

float rgb_2_saturation(float3 rgb) {
  float minrgb = min(min(rgb.r, rgb.g), rgb.b);
  float maxrgb = max(max(rgb.r, rgb.g), rgb.b);
  return (max(maxrgb, 1e-10) - max(minrgb, 1e-10)) / max(maxrgb, 1e-2);
}

// Sigmoid function in the range 0 to 1 spanning -2 to +2.
float sigmoid_shaper(float x) {
  float t = max(1 - abs(0.5 * x), 0);
  float y = 1 + sign(x) * (1 - t * t);
  return 0.5 * y;
}

float glow_fwd(float ycIn, float glowGainIn, float glowMid) {
  float glowGainOut;

  if (ycIn <= 2. / 3. * glowMid) {
    glowGainOut = glowGainIn;
  } else if (ycIn >= 2 * glowMid) {
    glowGainOut = 0;
  } else {
    glowGainOut = glowGainIn * (glowMid / ycIn - 0.5);
  }

  return glowGainOut;
}

// Transformations from RGB to other color representations
float rgb_2_hue(float3 rgb) {
  const float ACES_PI = 3.14159265359f;
  // Returns a geometric hue angle in degrees (0-360) based on RGB values.
  // For neutral colors, hue is undefined and the function will return a quiet NaN value.
  float hue;
  if (rgb.r == rgb.g && rgb.g == rgb.b) {
    hue = 0.0;  // RGB triplets where RGB are equal have an undefined hue
  } else {
    hue = (180.0f / ACES_PI) * atan2(sqrt(3.0f) * (rgb.g - rgb.b), 2.0f * rgb.r - rgb.g - rgb.b);
  }

  if (hue < 0.0f) {
    hue = hue + 360.0f;
  }

  return clamp(hue, 0, 360.f);
}

float center_hue(float hue, float centerH) {
  float hueCentered = hue - centerH;
  if (hueCentered < -180.)
    hueCentered += 360;
  else if (hueCentered > 180.)
    hueCentered -= 360;
  return hueCentered;
}

float3 Y_2_linCV(float3 Y, float Ymax, float Ymin) {
  return (Y - Ymin) / (Ymax - Ymin);
}

// clang-format off
static const float3x3 sRGB_2_AP0 = float3x3(
  0.4397010, 0.3829780, 0.1773350,
  0.0897923, 0.8134230, 0.0967616,
  0.0175440, 0.1115440, 0.8707040
);

static const float3x3 AP0_2_SRGB = float3x3(
   2.5214008886, -1.1339957494, -0.3875618568,
  -0.2762140616,  1.3725955663, -0.0962823557,
  -0.0153202001, -0.1529925618,  1.1683871996
);

static const float3x3 SRGB_2_XYZ_MAT = float3x3(
  0.4124564, 0.3575761, 0.1804375,
  0.2126729, 0.7151522, 0.0721750,
  0.0193339, 0.1191920, 0.9503041
);

static const float3x3 AP1_2_SRGB = float3x3(
   1.7048586763, -0.6217160219, -0.0832993717,
  -0.1300768242,  1.1407357748, -0.0105598017,
  -0.0239640729, -0.1289755083,  1.1530140189
);

static const float3 AP1_RGB2Y = float3(
  0.2722287168, //AP1_2_XYZ_MAT[0][1],
  0.6740817658, //AP1_2_XYZ_MAT[1][1],
  0.0536895174 //AP1_2_XYZ_MAT[2][1]
);

static const float3x3 XYZ_2_sRGB_MAT = float3x3(
   3.2409699419, -1.5373831776, -0.4986107603,
  -0.9692436363,  1.8759675015,  0.0415550574,
   0.0556300797, -0.2039769589,  1.0569715142
);

static const float3x3 AP1_2_AP0_MAT = float3x3(
  0.6954522414, 0.1406786965, 0.1638690622,
  0.0447945634, 0.8596711185, 0.0955343182,
  -0.0055258826, 0.0040252103, 1.0015006723
);

// clang-format on

static const float MIN_STOP_SDR = -6.5;
static const float MAX_STOP_SDR = 6.5;

static const float MIN_STOP_RRT = -15.0;
static const float MAX_STOP_RRT = 18.0;

static const float MIN_LUM_SDR = 0.02;
static const float MAX_LUM_SDR = 48.0;

static const float MIN_LUM_RRT = 0.0001;
static const float MAX_LUM_RRT = 10000.0;

float interpolate1D(float2x2 table, float p) {
  if (p < table[0].x) return table[0].y;
  if (p >= table[1].x) return table[1].y;
  // p = clamp(p, table[0].x, table[1].x);
  float s = (p - table[0].x) / (table[1].x - table[0].x);
  return table[0].y * (1 - s) + table[1].y * s;
}

float3 linCV_2_Y(float3 linCV, float Ymax, float Ymin) {
  return linCV * (Ymax - Ymin) + Ymin;
}

float lookup_ACESmin(float minLumLog10) {
  static const float2x2 MIN_LUM_TABLE = float2x2(
    log10(MIN_LUM_RRT), MIN_STOP_RRT, log10(MIN_LUM_SDR), MIN_STOP_SDR
  );
  return 0.18 * exp2(interpolate1D(MIN_LUM_TABLE, minLumLog10));
}

float lookup_ACESmax(float maxLumLog10) {
  static const float2x2 MAX_LUM_TABLE = float2x2(
    log10(MAX_LUM_SDR), MAX_STOP_SDR, log10(MAX_LUM_RRT), MAX_STOP_RRT
  );
  return 0.18 * exp2(interpolate1D(MAX_LUM_TABLE, maxLumLog10));
}

float SSTS(
  float x,
  float3 yMin,
  float3 yMid,
  float3 yMax,
  float3 coefsLowA,
  float3 coefsLowB,
  float3 coefsHighA,
  float3 coefsHighB
) {
  const uint N_KNOTS_LOW = 4;
  const uint N_KNOTS_HIGH = 4;

  float coefsLow[6];

  coefsLow[0] = coefsLowA.x;
  coefsLow[1] = coefsLowA.y;
  coefsLow[2] = coefsLowA.z;
  coefsLow[3] = coefsLowB.x;
  coefsLow[4] = coefsLowB.y;
  coefsLow[5] = coefsLowB.z;
  float coefsHigh[6];
  coefsHigh[0] = coefsHighA.x;
  coefsHigh[1] = coefsHighA.y;
  coefsHigh[2] = coefsHighA.z;
  coefsHigh[3] = coefsHighB.x;
  coefsHigh[4] = coefsHighB.y;
  coefsHigh[5] = coefsHighB.z;

  // Check for negatives or zero before taking the log. If negative or zero,
  // set to HALF_MIN.
  float logx = log10(max(x, FLT_MIN));

  float logy;

  if (logx > yMax.x) {
    // Above max breakpoint (overshoot)
    // If MAX_PT slope is 0, this is just a straight line and always returns
    // maxLum
    // y = mx+b
    // logy = computeGraphY(C.Max.z, logx, (C.Max.y) - (C.Max.z * (C.Max.x)));
    logy = yMax.y;
  } else if (logx >= yMid.x) {
    // Part of Midtones area (Must have slope)
    float knot_coord = (N_KNOTS_HIGH - 1) * (logx - yMid.x) / (yMax.x - yMid.x);
    uint j = knot_coord;
    float t = knot_coord - j;

    float3 cf = float3(coefsHigh[j], coefsHigh[j + 1], coefsHigh[j + 2]);

    float3 monomials = float3(t * t, t, 1.0);
    logy = dot(monomials, mul(M, cf));
  } else if (logx > yMin.x) {
    float knot_coord = (N_KNOTS_LOW - 1) * (logx - yMin.x) / (yMid.x - yMin.x);
    uint j = knot_coord;
    float t = knot_coord - j;

    float3 cf = float3(coefsLow[j], coefsLow[j + 1], coefsLow[j + 2]);

    float3 monomials = float3(t * t, t, 1.0);
    logy = dot(monomials, mul(M, cf));
  } else {  //(logx <= (C.Min.x))
    // Below min breakpoint (undershoot)
    // logy = computeGraphY(C.Min.z, logx, ((C.Min.y) - C.Min.z * (C.Min.x)));
    logy = yMin.y;
  }

  return pow(10.0, logy);
}

static float LIM_CYAN = 1.147f;
static float LIM_MAGENTA = 1.264f;
static float LIM_YELLOW = 1.312f;
static float THR_CYAN = 0.815f;
static float THR_MAGENTA = 0.803f;
static float THR_YELLOW = 0.880f;
static float PWR = 1.2f;

float aces_gamut_compress_channel(float dist, float lim, float thr, float pwr) {
  float comprDist;
  float scl;
  float nd;
  float p;

  if (dist < thr) {
    comprDist = dist;  // No compression below threshold
  } else {
    // Calculate scale factor for y = 1 intersect
    scl = (lim - thr) / pow(pow((1.0 - thr) / (lim - thr), -pwr) - 1.0, 1.0 / pwr);

    // Normalize distance outside threshold by scale factor
    nd = (dist - thr) / scl;
    p = pow(nd, pwr);

    comprDist = thr + scl * nd / (pow(1.0 + p, 1.0 / pwr));  // Compress
  }

  return comprDist;
}

float3 aces_gamut_compress(float3 linAP1) {
  // Achromatic axis
  float ach = max(linAP1.r, max(linAP1.g, linAP1.b));
  float absAch = abs(ach);
  // Distance from the achromatic axis for each color component aka inverse RGB ratios
  float3 dist = ach ? (ach - linAP1) / absAch : 0;

  // Compress distance with parameterized shaper function
  float3 comprDist = float3(
    aces_gamut_compress_channel(dist.r, LIM_CYAN, THR_CYAN, PWR),
    aces_gamut_compress_channel(dist.g, LIM_MAGENTA, THR_MAGENTA, PWR),
    aces_gamut_compress_channel(dist.b, LIM_YELLOW, THR_YELLOW, PWR)
  );

  // Recalculate RGB from compressed distance and achromatic
  float3 comprLinAP1 = ach - comprDist * absAch;

  return comprLinAP1;
}

float3 aces_rrt(float3 aces) {
  // --- Glow module --- //
  // "Glow" module constants
  const float RRT_GLOW_GAIN = 0.05;
  const float RRT_GLOW_MID = 0.08;
  float saturation = rgb_2_saturation(aces);
  float ycIn = rgb_2_yc(aces);
  float s = sigmoid_shaper((saturation - 0.4) / 0.2);
  float addedGlow = 1.0 + glow_fwd(ycIn, RRT_GLOW_GAIN * s, RRT_GLOW_MID);
  aces *= addedGlow;

  // --- Red modifier --- //
  // Red modifier constants
  const float RRT_RED_SCALE = 0.82;
  const float RRT_RED_PIVOT = 0.03;
  const float RRT_RED_HUE = 0.;
  const float RRT_RED_WIDTH = 135.;
  float hue = rgb_2_hue(aces);
  float centeredHue = center_hue(hue, RRT_RED_HUE);
  float hueWeight;
  {
    //hueWeight = cubic_basis_shaper(centeredHue, RRT_RED_WIDTH);
    hueWeight = smoothstep(0.0, 1.0, 1.0 - abs(2.0 * centeredHue / RRT_RED_WIDTH));
    hueWeight *= hueWeight;
  }

  aces.r += hueWeight * saturation * (RRT_RED_PIVOT - aces.r) * (1. - RRT_RED_SCALE);

  // --- ACES to RGB rendering space --- //
  aces = clamp(aces, 0, 65535.0f);
  float3 rgbPre = mul(AP0_2_AP1_MAT, aces);
  rgbPre = clamp(rgbPre, 0, 65504.0f);

  // --- Global desaturation --- //
  // rgbPre = mul( RRT_SAT_MAT, rgbPre);
  const float RRT_SAT_FACTOR = 0.96f;
  rgbPre = lerp(dot(rgbPre, AP1_RGB2Y).xxx, rgbPre, RRT_SAT_FACTOR);

  return rgbPre;
}

float3 aces_odt_tone_map(float3 rgbPre, float minY, float maxY) {
  float minLum = minY;
  float maxLum = maxY;
  float3 rgbPost;
  // Aces-dev has more expensive version
  // AcesParams PARAMS = init_aces_params(minY, maxY);

  static const float2x2 BENDS_LOW_TABLE = float2x2(
    MIN_STOP_RRT, 0.18, MIN_STOP_SDR, 0.35
  );

  static const float2x2 BENDS_HIGH_TABLE = float2x2(
    MAX_STOP_SDR, 0.89, MAX_STOP_RRT, 0.90
  );

  float minLumLog10 = log10(minLum);
  float maxLumLog10 = log10(maxLum);
  float acesMin = lookup_ACESmin(minLumLog10);
  float acesMax = lookup_ACESmax(maxLumLog10);
  // float3 MIN_PT = float3(lookup_ACESmin(minLum), minLum, 0.0);
  float3 MID_PT = float3(0.18, 4.8, 1.55);
  // float3 MAX_PT = float3(lookup_ACESmax(maxLum), maxLum, 0.0);
  // float coefsLow[5];
  // float coefsHigh[5];
  float3 coefsLowA;
  float3 coefsLowB;
  float3 coefsHighA;
  float3 coefsHighB;

  float2 logMin = float2(log10(acesMin), minLumLog10);
  float2 logMid = float2(log10(MID_PT.xy));
  float2 logMax = float2(log10(acesMax), maxLumLog10);

  float knotIncLow = (logMid.x - logMin.x) / 3.;
  // float halfKnotInc = (logMid.x - logMin.x) / 6.;

  // Determine two lowest coefficients (straddling minPt)
  // coefsLow[0] = (MIN_PT.z * (logMin.x- 0.5 * knotIncLow)) + ( logMin.y - MIN_PT.z * logMin.x);
  // coefsLow[1] = (MIN_PT.z * (logMin.x+ 0.5 * knotIncLow)) + ( logMin.y - MIN_PT.z * logMin.x);
  // NOTE: if slope=0, then the above becomes just
  coefsLowA.x = logMin.y;
  coefsLowA.y = coefsLowA.x;
  // leaving it as a variable for now in case we decide we need non-zero slope extensions

  // Determine two highest coefficients (straddling midPt)
  float minCoef = (logMid.y - MID_PT.z * logMid.x);
  coefsLowB.x = (MID_PT.z * (logMid.x - 0.5 * knotIncLow)) + (logMid.y - MID_PT.z * logMid.x);
  coefsLowB.y = (MID_PT.z * (logMid.x + 0.5 * knotIncLow)) + (logMid.y - MID_PT.z * logMid.x);
  coefsLowB.z = coefsLowB.y;

  // Middle coefficient (which defines the "sharpness of the bend") is linearly interpolated
  float pctLow = interpolate1D(BENDS_LOW_TABLE, log2(acesMin / 0.18));
  coefsLowA.z = logMin.y + pctLow * (logMid.y - logMin.y);

  float knotIncHigh = (logMax.x - logMid.x) / 3.0f;
  // float halfKnotInc = (logMax.x - logMid.x) / 6.;

  // Determine two lowest coefficients (straddling midPt)
  // float minCoef = ( logMid.y - MID_PT.z * logMid.x);
  coefsHighA.x = (MID_PT.z * (logMid.x - 0.5 * knotIncHigh)) + minCoef;
  coefsHighA.y = (MID_PT.z * (logMid.x + 0.5 * knotIncHigh)) + minCoef;

  // Determine two highest coefficients (straddling maxPt)
  // coefsHigh[3] = (MAX_PT.z * (logMax.x-0.5*knotIncHigh)) + ( logMax.y - MAX_PT.z * logMax.x);
  // coefsHigh[4] = (MAX_PT.z * (logMax.x+0.5*knotIncHigh)) + ( logMax.y - MAX_PT.z * logMax.x);
  // NOTE: if slope=0, then the above becomes just
  coefsHighB.x = logMax.y;
  coefsHighB.y = coefsHighB.x;
  coefsHighB.z = coefsHighB.y;
  // leaving it as a variable for now in case we decide we need non-zero slope extensions

  // Middle coefficient (which defines the "sharpness of the bend") is linearly interpolated

  float pctHigh = interpolate1D(BENDS_HIGH_TABLE, log2(acesMax / 0.18));
  coefsHighA.z = logMid.y + pctHigh * (logMax.y - logMid.y);

  rgbPost.x = SSTS(rgbPre.x, float3(logMin.x, logMin.y, 0), float3(logMid.x, logMid.y, MID_PT.z), float3(logMax.x, logMax.y, 0), coefsLowA, coefsLowB, coefsHighA, coefsHighB);
  rgbPost.y = SSTS(rgbPre.y, float3(logMin.x, logMin.y, 0), float3(logMid.x, logMid.y, MID_PT.z), float3(logMax.x, logMax.y, 0), coefsLowA, coefsLowB, coefsHighA, coefsHighB);
  rgbPost.z = SSTS(rgbPre.z, float3(logMin.x, logMin.y, 0), float3(logMid.x, logMid.y, MID_PT.z), float3(logMax.x, logMax.y, 0), coefsLowA, coefsLowB, coefsHighA, coefsHighB);

  // Nits to Linear
  float3 linearCV = Y_2_linCV(rgbPost, maxY, minY);
  return clamp(rgbPost, 0.0, 65535.0f);
}

float3 aces_odt(float3 rgbPre, float minY, float maxY, float3x3 odtMatrix) {
  float3 tonescaled = aces_odt_tone_map(rgbPre, minY, maxY);

  float3 outputColor = mul(odtMatrix, tonescaled);

  // linearCV = clamp(linearCV, 0.0, 65535.0f);
  // float3 outputCV = linCV_2_Y(linearCV, maxY, minY);
  // outputCV = clamp(outputCV, 0.0, 65535.0f);

  return outputColor;
}

// ACES with
// Reference Rendering Transform
// Output Display Transform
float3 aces_rrt_odt(float3 color, float minY, float maxY, float3x3 odtMatrix) {
  color = mul(sRGB_2_AP0, color);
  color = aces_rrt(color);
  return aces_odt(color, minY, maxY, odtMatrix);
}

// ACES for Scene-Linear BT709 with:
// Reference Gamma Compression
// Reference Rendering Transform
// Output Display Transform
float3 aces_rgc_rrt_odt(float3 color, float minY, float maxY, float3x3 odtMatrix) {
  static const float3x3 BT709_2_AP1_MAT = mul(XYZ_2_AP1_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));

  color = mul(BT709_2_AP1_MAT, color);             // BT709 to AP1
  color = aces_gamut_compress(color);              // Compresses to AP1
  color = mul(AP1_2_AP0_MAT, color);               // Convert to AP0
  color = aces_rrt(color);                         // RRT AP0 => AP1
  color = aces_odt(color, minY, maxY, odtMatrix);  // ODT AP1 => Matrix
}

uniform float ACES_PEAK_NITS < ui_type = "slider";
ui_min = 80;
ui_max = 10000;
ui_step = 1;
ui_label = "Peak Nits";
ui_tooltip = "Peak Nits";
> = 800;

uniform float ACES_PAPER_WHITE_NITS < ui_type = "slider";
ui_min = 80;
ui_max = 500;
ui_step = 1;
ui_label = "Paper White Nits";
ui_tooltip = "Brightness of 100% diffuse white";
> = 203;

uniform float ACES_MIN_NITS < ui_type = "slider";
ui_min = 0.00001;
ui_max = 1.0;
ui_label = "Min Nits";
ui_tooltip = "Peak Nits";
> = 0.0001;

uniform float ACES_EXPOSURE < ui_type = "slider";
ui_min = 0;
ui_max = 10;
ui_step = 1;
ui_label = "Exposure";
> = 1.0;

float3 main(float4 pos : SV_Position, float2 texcoord : TexCoord) : COLOR {
  static const float3x3 BT709_2_AP0_MAT = mul(XYZ_2_AP0_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));
  static const float3x3 BT2020_2_AP1_MAT = mul(XYZ_2_AP1_MAT, mul(D65_2_D60_CAT, BT2020_2_XYZ_MAT));
  static const float3x3 BT2020_2_AP0_MAT = mul(XYZ_2_AP0_MAT, mul(D65_2_D60_CAT, BT2020_2_XYZ_MAT));
  static const float3x3 BT709_2_BT709D60_MAT = mul(XYZ_2_BT709_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));
  static const float3x3 BT2020_2_BT709D60_MAT = mul(XYZ_2_BT709_MAT, mul(D65_2_D60_CAT, BT2020_2_XYZ_MAT));
  static const float3x3 BT709_2_BT2020D60_MAT = mul(XYZ_2_BT2020_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));

  static const float3x3 AP1_2_BT709_MAT = mul(XYZ_2_BT709_MAT, mul(D60_2_D65_CAT, AP1_2_XYZ_MAT));
  static const float3x3 AP1_2_BT709D60_MAT = mul(XYZ_2_BT709_MAT, AP1_2_XYZ_MAT);
  static const float3x3 AP1_2_BT2020_MAT = mul(XYZ_2_BT2020_MAT, mul(D60_2_D65_CAT, AP1_2_XYZ_MAT));
  static const float3x3 AP1_2_BT2020D60_MAT = mul(XYZ_2_BT2020_MAT, AP1_2_XYZ_MAT);
  static const float3x3 AP1_2_AP1D65_MAT = mul(XYZ_2_AP1_MAT, mul(D60_2_D65_CAT, AP1_2_XYZ_MAT));

  float3 inputColor = tex2D(ReShade::BackBuffer, texcoord).rgb;

  // ACES uses 48 nits for 100-nit SDR
  // Base 100-nit SDR = 203 SDR
  // Scaling is Peak Nits / Paper White
  float yMin = ACES_MIN_NITS;
  float peakNits = ACES_PEAK_NITS;
  float paperWhite = ACES_PAPER_WHITE_NITS;
  float3x3 clampMatrix = AP1_2_BT709_MAT;
  float3x3 outputMatrix = IDENTITY_MAT;

  float hdrScale = peakNits / paperWhite;
  float3 outputColor = aces_rgc_rrt_odt(
    inputColor * ACES_EXPOSURE,
    yMin / (paperWhite / 48.f),
    48.f * hdrScale,
    clampMatrix
  );
  outputColor /= 48.f;
  outputColor = mul(outputMatrix, outputColor);
  outputColor *= paperWhite / 80.f;
  return outputColor;
}

technique ShortFuseACES {
  pass {
    VertexShader = PostProcessVS;
    PixelShader = main;
  }
}
