#ifndef PRAGMATA_ACES_ODT_SRGB_100NITS_DIM_HLSLI
#define PRAGMATA_ACES_ODT_SRGB_100NITS_DIM_HLSLI

namespace renodx_custom {
namespace aces {
namespace odt_srgb_100nits_dim {

// Port of:
// transforms/ctl/odt/sRGB/ODT.Academy.sRGB_100nits_dim.ctl
// Uses CTL row-vector math convention explicitly (v * M).
// NOTE: Apply() expects AP1 linear input.

static const float HALF_MIN = 6.103515625e-5f;
static const float HALF_POS_INF = 65504.f;

static const float CINEMA_WHITE = 48.f;
static const float CINEMA_BLACK = 0.02f;

static const float DIM_SURROUND_GAMMA = 0.9811f;

static const float DISPGAMMA = 2.4f;
static const float OFFSET = 0.055f;

static const float C9_COEFS_LOW[10] = {
    -1.6989700043f,
    -1.6989700043f,
    -1.4779000000f,
    -1.2291000000f,
    -0.8648000000f,
    -0.4480000000f,
    0.0051800000f,
    0.4511080334f,
    0.9113744414f,
    0.9113744414f};

static const float C9_COEFS_HIGH[10] = {
    0.5154386965f,
    0.8470437783f,
    1.1358000000f,
    1.3802000000f,
    1.5197000000f,
    1.5985000000f,
    1.6467000000f,
    1.6746091357f,
    1.6878733390f,
    1.6878733390f};

// Precomputed CTL ODT_48nits points:
// minPoint.x = segmented_spline_c5_fwd(0.18 * 2^-6.5)
// midPoint.x = segmented_spline_c5_fwd(0.18)
// maxPoint.x = segmented_spline_c5_fwd(0.18 * 2^6.5)
static const float C9_LOG_MIN_X = -2.5406236188539997f;
static const float C9_LOG_MID_X = 0.68124123735f;
static const float C9_LOG_MAX_X = 3.0024768101229165f;

static const float C9_LOG_MIN_Y = -1.6989700043360187f;  // log10(0.02)
static const float C9_LOG_MID_Y = 0.6812412373755872f;   // log10(4.8)
static const float C9_LOG_MAX_Y = 1.6812412373755872f;   // log10(48)

static const float C9_SLOPE_LOW = 0.f;
static const float C9_SLOPE_HIGH = 0.04f;

// CTL matrices encoded as column vectors for row-vector multiplication.
static const float3 AP1_2_XYZ_COL0 = float3(0.6624541811f, 0.1340042065f, 0.1561876870f);
static const float3 AP1_2_XYZ_COL1 = float3(0.2722287168f, 0.6740817658f, 0.0536895174f);
static const float3 AP1_2_XYZ_COL2 = float3(-0.0055746495f, 0.0040607335f, 1.0103391003f);

static const float3 XYZ_2_AP1_COL0 = float3(1.6410233797f, -0.3248032942f, -0.2364246952f);
static const float3 XYZ_2_AP1_COL1 = float3(-0.6636628587f, 1.6153315917f, 0.0167563477f);
static const float3 XYZ_2_AP1_COL2 = float3(0.0117218943f, -0.0082844420f, 0.9883948585f);

static const float3 D60_2_D65_CAT_COL0 = float3(0.9872240000f, -0.0061132700f, 0.0159533000f);
static const float3 D60_2_D65_CAT_COL1 = float3(-0.0075983600f, 1.0018600000f, 0.0053300200f);
static const float3 D60_2_D65_CAT_COL2 = float3(0.0030725700f, -0.0050959500f, 1.0816800000f);

static const float3 XYZ_2_DISPLAY_PRI_COL0 = float3(3.2409699419f, -1.5373831776f, -0.4986107603f);
static const float3 XYZ_2_DISPLAY_PRI_COL1 = float3(-0.9692436363f, 1.8759675015f, 0.0415550574f);
static const float3 XYZ_2_DISPLAY_PRI_COL2 = float3(0.0556300797f, -0.2039769589f, 1.0569715142f);

static const float3 ODT_SAT_COL0 = float3(0.949056010176f, 0.047185723606f, 0.003758266218f);
static const float3 ODT_SAT_COL1 = float3(0.019056010176f, 0.977185723606f, 0.003758266218f);
static const float3 ODT_SAT_COL2 = float3(0.019056010176f, 0.047185723606f, 0.933758266218f);

float Log10Safe(float x) {
  return log2(x) * 0.3010299956639811952137389f;
}

float Pow10(float x) {
  return exp2(x * 3.3219280948873623478703194f);
}

float3 MulRowVectorByColumns(float3 v, float3 col0, float3 col1, float3 col2) {
  return float3(dot(v, col0), dot(v, col1), dot(v, col2));
}

float3 XYZToXyY(float3 XYZ) {
  float divisor = XYZ.x + XYZ.y + XYZ.z;
  if (divisor == 0.f) {
    divisor = 1e-10f;
  }

  return float3(
      XYZ.x / divisor,
      XYZ.y / divisor,
      XYZ.y);
}

float3 XyYToXYZ(float3 xyY) {
  float safeY = max(xyY.y, 1e-10f);
  return float3(
      xyY.x * xyY.z / safeY,
      xyY.z,
      (1.f - xyY.x - xyY.y) * xyY.z / safeY);
}

float MoncurveR(float y, float gamma, float offs) {
  float yb = pow(offs * gamma / ((gamma - 1.f) * (1.f + offs)), gamma);
  float rs = pow((gamma - 1.f) / offs, gamma - 1.f) * pow((1.f + offs) / gamma, gamma);

  if (y >= yb) {
    return (1.f + offs) * pow(y, 1.f / gamma) - offs;
  }

  return y * rs;
}

float YToLinCV(float Y, float Ymax, float Ymin) {
  return (Y - Ymin) / (Ymax - Ymin);
}

// CTL M matrix baked into polynomial form for dot(monomials, mult_f3_f33(cf, M)).
float EvalSplineSegment(float t, float c0, float c1, float c2) {
  float a = 0.5f * c0 - c1 + 0.5f * c2;
  float b = -c0 + c1;
  float c = 0.5f * (c0 + c1);
  return mad(t * t, a, mad(t, b, c));
}

float SegmentedSplineC9Fwd(float x) {
  float logx = Log10Safe(max(x, HALF_MIN));
  float logy;

  if (logx <= C9_LOG_MIN_X) {
    logy = logx * C9_SLOPE_LOW + (C9_LOG_MIN_Y - C9_SLOPE_LOW * C9_LOG_MIN_X);
  } else if (logx < C9_LOG_MID_X) {
    float knotCoord = 7.f * (logx - C9_LOG_MIN_X) / (C9_LOG_MID_X - C9_LOG_MIN_X);
    int j = (int)knotCoord;
    j = min(max(j, 0), 6);
    float t = knotCoord - (float)j;

    float c0 = C9_COEFS_LOW[j];
    float c1 = C9_COEFS_LOW[j + 1];
    float c2 = C9_COEFS_LOW[j + 2];

    logy = EvalSplineSegment(t, c0, c1, c2);
  } else if (logx < C9_LOG_MAX_X) {
    float knotCoord = 7.f * (logx - C9_LOG_MID_X) / (C9_LOG_MAX_X - C9_LOG_MID_X);
    int j = (int)knotCoord;
    j = min(max(j, 0), 6);
    float t = knotCoord - (float)j;

    float c0 = C9_COEFS_HIGH[j];
    float c1 = C9_COEFS_HIGH[j + 1];
    float c2 = C9_COEFS_HIGH[j + 2];

    logy = EvalSplineSegment(t, c0, c1, c2);
  } else {
    logy = logx * C9_SLOPE_HIGH + (C9_LOG_MAX_Y - C9_SLOPE_HIGH * C9_LOG_MAX_X);
  }

  return Pow10(logy);
}

float3 DarkSurroundToDimSurround(float3 linearCV) {
  float3 XYZ = MulRowVectorByColumns(linearCV, AP1_2_XYZ_COL0, AP1_2_XYZ_COL1, AP1_2_XYZ_COL2);

  float3 xyY = XYZToXyY(XYZ);
  xyY.z = pow(clamp(xyY.z, 0.f, HALF_POS_INF), DIM_SURROUND_GAMMA);
  XYZ = XyYToXYZ(xyY);

  return MulRowVectorByColumns(XYZ, XYZ_2_AP1_COL0, XYZ_2_AP1_COL1, XYZ_2_AP1_COL2);
}

float3 Apply(float3 ap1) {
  float3 rgbPre = ap1;

  float3 rgbPost = float3(
      SegmentedSplineC9Fwd(rgbPre.x),
      SegmentedSplineC9Fwd(rgbPre.y),
      SegmentedSplineC9Fwd(rgbPre.z));

  float3 linearCV = float3(
      YToLinCV(rgbPost.x, CINEMA_WHITE, CINEMA_BLACK),
      YToLinCV(rgbPost.y, CINEMA_WHITE, CINEMA_BLACK),
      YToLinCV(rgbPost.z, CINEMA_WHITE, CINEMA_BLACK));

  linearCV = DarkSurroundToDimSurround(linearCV);
  linearCV = MulRowVectorByColumns(linearCV, ODT_SAT_COL0, ODT_SAT_COL1, ODT_SAT_COL2);

  float3 XYZ = MulRowVectorByColumns(linearCV, AP1_2_XYZ_COL0, AP1_2_XYZ_COL1, AP1_2_XYZ_COL2);
  XYZ = MulRowVectorByColumns(XYZ, D60_2_D65_CAT_COL0, D60_2_D65_CAT_COL1, D60_2_D65_CAT_COL2);

  linearCV = MulRowVectorByColumns(XYZ, XYZ_2_DISPLAY_PRI_COL0, XYZ_2_DISPLAY_PRI_COL1, XYZ_2_DISPLAY_PRI_COL2);

  // CTL clamp_f3(linearCV, 0., 1.)
  linearCV = clamp(linearCV, 0.f, 1.f);

  float3 outputCV = float3(
      MoncurveR(linearCV.x, DISPGAMMA, OFFSET),
      MoncurveR(linearCV.y, DISPGAMMA, OFFSET),
      MoncurveR(linearCV.z, DISPGAMMA, OFFSET));

  return outputCV;
}

float4 Apply(float4 ap1) {
  return float4(Apply(ap1.rgb), ap1.a);
}

}  // namespace odt_srgb_100nits_dim
}  // namespace aces
}  // namespace renodx_custom

#endif  // PRAGMATA_ACES_ODT_SRGB_100NITS_DIM_HLSLI
