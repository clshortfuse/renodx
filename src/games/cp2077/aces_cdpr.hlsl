#include "./cp2077.h"

struct SegmentedSplineParams_c5 {
  float coefsLow[6];   // coefs for B-spline between minPoint and midPoint (units of log luminance)
  float coefsHigh[6];  // coefs for B-spline between midPoint and maxPoint (units of log luminance)
  float2 minPoint;     // {luminance, luminance} linear extension below this
  float2 midPoint;     // {luminance, luminance}
  float2 maxPoint;     // {luminance, luminance} linear extension above this
  float slopeLow;      // log-log slope of low linear extension
  float slopeHigh;     // log-log slope of high linear extension
};

struct SegmentedSplineParams_c9 {
  float coefsLow[10];   // coefs for B-spline between minPoint and midPoint (units of log luminance)
  float coefsHigh[10];  // coefs for B-spline between midPoint and maxPoint (units of log luminance)
  float2 minPoint;      // {luminance, luminance} linear extension below this
  float2 midPoint;      // {luminance, luminance}
  float2 maxPoint;      // {luminance, luminance} linear extension above this
  float slopeLow;       // log-log slope of low linear extension
  float slopeHigh;      // log-log slope of high linear extension
};

static const float3 AP1_RGB2Y = {
    0.2722287168,  // AP1_TO_XYZ_MAT[0][1],
    0.6740817658,  // AP1_TO_XYZ_MAT[1][1],
    0.0536895174,  // AP1_TO_XYZ_MAT[2][1]
};

float segmented_spline_c5_fwd(float x) {
  // RRT_PARAMS
  const SegmentedSplineParams_c5 C = {
      // coefsLow[6]
      {-4.0000000000, -4.0000000000, -3.1573765773, -0.4852499958, 1.8477324706, 1.8477324706},
      // coefsHigh[6]
      {-0.7185482425, 2.0810307172, 3.6681241237, 4.0000000000, 4.0000000000, 4.0000000000},
      {0.18 * exp2(-15.0), 0.0001},  // minPoint
      {0.18, 4.8},                   // midPoint
      {0.18 * exp2(18.0), 10000.},   // maxPoint
      0.0,                           // slopeLow
      0.0                            // slopeHigh
  };

  const int N_KNOTS_LOW = 4;
  const int N_KNOTS_HIGH = 4;

  // Check for negatives or zero before taking the log. If negative or zero,
  // set to ACESMIN.1
  float xCheck = x <= 0 ? exp2(-14.0) : x;

  float logx = log10(xCheck);
  float logy;

  if (logx <= log10(C.minPoint.x)) {
    logy = logx * C.slopeLow + (log10(C.minPoint.y) - C.slopeLow * log10(C.minPoint.x));
  } else if ((logx > log10(C.minPoint.x)) && (logx < log10(C.midPoint.x))) {
    float knot_coord = (N_KNOTS_LOW - 1) * (logx - log10(C.minPoint.x)) / (log10(C.midPoint.x) - log10(C.minPoint.x));
    int j = knot_coord;
    float t = knot_coord - j;

    float3 cf = {C.coefsLow[j], C.coefsLow[j + 1], C.coefsLow[j + 2]};

    float3 monomials = {t * t, t, 1.0};
    logy = dot(monomials, mul(renodx::tonemap::aces::M, cf));
  } else if ((logx >= log10(C.midPoint.x)) && (logx < log10(C.maxPoint.x))) {
    float knot_coord = (N_KNOTS_HIGH - 1) * (logx - log10(C.midPoint.x)) / (log10(C.maxPoint.x) - log10(C.midPoint.x));
    int j = knot_coord;
    float t = knot_coord - j;

    float3 cf = {C.coefsHigh[j], C.coefsHigh[j + 1], C.coefsHigh[j + 2]};

    float3 monomials = {t * t, t, 1.0};
    logy = dot(monomials, mul(renodx::tonemap::aces::M, cf));
  } else {  // if ( logIn >= log10(C.maxPoint.x) ) {
    logy = logx * C.slopeHigh + (log10(C.maxPoint.y) - C.slopeHigh * log10(C.maxPoint.x));
  }

  return pow(10, logy);
}

float segmented_spline_c9_fwd(float x, const SegmentedSplineParams_c9 C) {
  const int N_KNOTS_LOW = 8;
  const int N_KNOTS_HIGH = 8;

  // Check for negatives or zero before taking the log. If negative or zero,
  // set to OCESMIN.
  float xCheck = x <= 0 ? 1e-4 : x;

  float logx = log10(xCheck);
  float logy;

  if (logx <= log10(C.minPoint.x)) {
    logy = logx * C.slopeLow + (log10(C.minPoint.y) - C.slopeLow * log10(C.minPoint.x));
  } else if ((logx > log10(C.minPoint.x)) && (logx < log10(C.midPoint.x))) {
    float knot_coord = (N_KNOTS_LOW - 1) * (logx - log10(C.minPoint.x)) / (log10(C.midPoint.x) - log10(C.minPoint.x));
    int j = knot_coord;
    float t = knot_coord - j;

    float3 cf = {C.coefsLow[j], C.coefsLow[j + 1], C.coefsLow[j + 2]};

    float3 monomials = {t * t, t, 1.0};
    logy = dot(monomials, mul(renodx::tonemap::aces::M, cf));
  } else if ((logx >= log10(C.midPoint.x)) && (logx < log10(C.maxPoint.x))) {
    float knot_coord = (N_KNOTS_HIGH - 1) * (logx - log10(C.midPoint.x)) / (log10(C.maxPoint.x) - log10(C.midPoint.x));
    int j = knot_coord;
    float t = knot_coord - j;

    float3 cf = {C.coefsHigh[j], C.coefsHigh[j + 1], C.coefsHigh[j + 2]};

    float3 monomials = {t * t, t, 1.0};
    logy = dot(monomials, mul(renodx::tonemap::aces::M, cf));
  } else  // if ( logIn >= log10(C.maxPoint.x) )
  {
    logy = logx * C.slopeHigh + (log10(C.maxPoint.y) - C.slopeHigh * log10(C.maxPoint.x));
  }

  return pow(10, logy);
}

float3 aces_rrt_ap0(float3 ap0) {
  const float RRT_GLOW_GAIN = 0.05;
  const float RRT_GLOW_MID = 0.08;
  float3 aces = ap0;
  float saturation = renodx::tonemap::aces::Rgb2Saturation(aces);
  float ycIn = renodx::tonemap::aces::Rgb2Yc(aces);
  float s = renodx::tonemap::aces::SigmoidShaper((saturation - 0.4) / 0.2);
  float addedGlow = 1.0 + renodx::tonemap::aces::GlowFwd(ycIn, RRT_GLOW_GAIN * s, RRT_GLOW_MID);
  aces *= addedGlow;

  const float RRT_RED_HUE = 0.;
  const float RRT_RED_WIDTH = 135.;

  float hue = renodx::tonemap::aces::Rgb2Hue(aces);
  float centeredHue = renodx::tonemap::aces::CenterHue(hue, RRT_RED_HUE);
  float hueWeight;
  {
    // hueWeight = cubic_basis_shaper(centeredHue, RRT_RED_WIDTH);
    hueWeight = smoothstep(0.0, 1.0, 1.0 - abs(2.0 * centeredHue / RRT_RED_WIDTH));
    hueWeight *= hueWeight;
  }

  const float RRT_RED_SCALE = 0.83;  // should be 0.82
  const float RRT_RED_PIVOT = 0.03;

  aces.r += hueWeight * saturation * (RRT_RED_PIVOT - aces.r) * (1.0 - RRT_RED_SCALE);
  aces = clamp(aces, 0, 65504.0f);

  aces = mul(renodx::color::AP0_TO_AP1_MAT, aces);
  aces = mul(renodx::tonemap::aces::RRT_SAT_MAT, aces);

  // segmented_spline_c5_fwd

  // --- Apply the tonescale independently in rendering-space RGB --- //

  float3 rgbPost = float3(
      segmented_spline_c5_fwd(aces.r),
      segmented_spline_c5_fwd(aces.g),
      segmented_spline_c5_fwd(aces.b));

  return rgbPost;
}