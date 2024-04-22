#ifndef SRC_COMMON_ACES_HLSL_
#define SRC_COMMON_ACES_HLSL_

#include "./color.hlsl"

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

float3 XYZ_2_xyY(half3 XYZ) {
  half divisor = max(dot(XYZ, (1.0).xxx), 1e-4);
  return float3(XYZ.xy / divisor, XYZ.y);
}

float3 xyY_2_XYZ(half3 xyY) {
  half m = xyY.z / max(xyY.y, 1e-4);
  float3 XYZ = float3(xyY.xz, (1.0 - xyY.x - xyY.y));
  XYZ.xz *= m;
  return XYZ;
}

static const float DIM_SURROUND_GAMMA = 0.9811;

float3 darkToDim(float3 XYZ, float dimSurroundGamma = DIM_SURROUND_GAMMA) {
  float3 xyY = XYZ_2_xyY(XYZ);
  xyY.z = clamp(xyY.z, 0.0, 65504.0f);
  xyY.z = pow(xyY.z, DIM_SURROUND_GAMMA);
  return xyY_2_XYZ(xyY);
}

// clang-format off

// clang-format on

static const float MIN_STOP_SDR = -6.5;
static const float MAX_STOP_SDR = 6.5;

static const float MIN_STOP_RRT = -15.0;
static const float MAX_STOP_RRT = 18.0;

static const float MIN_LUM_SDR = 0.02;
static const float MAX_LUM_SDR = 48.0;

static const float MIN_LUM_RRT = 0.0001;
static const float MAX_LUM_RRT = 10000.0;

static const float2x2 MIN_LUM_TABLE = float2x2(
  log10(MIN_LUM_RRT),
  MIN_STOP_RRT,
  log10(MIN_LUM_SDR),
  MIN_STOP_SDR
);

static const float2x2 MAX_LUM_TABLE = float2x2(
  log10(MAX_LUM_SDR),
  MAX_STOP_SDR,
  log10(MAX_LUM_RRT),
  MAX_STOP_RRT
);

// clang-format on

// Transformations between CIE XYZ tristimulus values and CIE x,y
// chromaticity coordinates
float3 XYZ_2_xyY(float3 XYZ) {
  float3 xyY;
  float divisor = (XYZ[0] + XYZ[1] + XYZ[2]);
  if (divisor == 0.) divisor = 1e-10;
  xyY[0] = XYZ[0] / divisor;
  xyY[1] = XYZ[1] / divisor;
  xyY[2] = XYZ[1];

  return xyY;
}

float3 xyY_2_XYZ(float3 xyY) {
  float3 XYZ;
  XYZ[0] = xyY[0] * xyY[2] / max(xyY[1], 1e-10);
  XYZ[1] = xyY[2];
  XYZ[2] = (1.0 - xyY[0] - xyY[1]) * xyY[2] / max(xyY[1], 1e-10);

  return XYZ;
}

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
  return 0.18 * exp2(interpolate1D(MIN_LUM_TABLE, minLumLog10));
}

float lookup_ACESmax(float maxLumLog10) {
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
  static const float3 AP1_RGB2Y = AP1_2_XYZ_MAT[1].rgb;

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

float3 aces_odt(float3 rgbPre, float minY, float maxY, float3x3 odtMatrix = AP1_2_BT709_MAT) {
  float3 tonescaled = aces_odt_tone_map(rgbPre, minY, maxY);

  float3 outputColor = mul(odtMatrix, tonescaled);

  return outputColor;
}

// ACES with
// Reference Rendering Transform
// Output Display Transform
float3 aces_rrt_odt(float3 color, float minY, float maxY, float3x3 odtMatrix = AP1_2_BT709_MAT) {
  color = mul(BT709_2_AP0_MAT, color);
  color = aces_rrt(color);
  color = aces_odt(color, minY, maxY, odtMatrix);
  return color;
}

// ACES for Scene-Linear BT709 with:
// Reference Gamma Compression
// Reference Rendering Transform
// Output Display Transform
float3 aces_rgc_rrt_odt(float3 color, float minY, float maxY, float3x3 odtMatrix = AP1_2_BT709_MAT) {
  color = mul(BT709_2_AP1_MAT, color);             // BT709 to AP1
  color = aces_gamut_compress(color);              // Compresses to AP1
  color = mul(AP1_2_AP0_MAT, color);               // Convert to AP0
  color = aces_rrt(color);                         // RRT AP0 => AP1
  color = aces_odt(color, minY, maxY, odtMatrix);  // ODT AP1 => Matrix
  return color;
}

#endif  // SRC_COMMON_ACES_HLSL_