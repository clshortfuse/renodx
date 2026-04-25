#ifndef PRAGMATA_RRT_HLSLI
#define PRAGMATA_RRT_HLSLI

namespace renodx_custom {
namespace aces {
namespace rrt {

// Port of:
// transforms/ctl/rrt/RRT.ctl
// Uses CTL row-vector math convention explicitly (v * M).

static const float HALF_MIN = 6.103515625e-5f;
static const float HALF_MAX = 65504.f;
static const float HALF_POS_INF = 65504.f;

static const float TINY = 1e-10f;

// Glow module constants.
static const float RRT_GLOW_GAIN = 0.05f;
static const float RRT_GLOW_MID = 0.08f;

// Red modifier constants.
static const float RRT_RED_SCALE = 0.82f;
static const float RRT_RED_PIVOT = 0.03f;
static const float RRT_RED_HUE = 0.f;
static const float RRT_RED_WIDTH = 135.f;

// Matrix columns for row-vector multiplication.
static const float3 AP0_2_AP1_COL0 = float3(1.4514393161f, -0.2365107469f, -0.2149285693f);
static const float3 AP0_2_AP1_COL1 = float3(-0.0765537734f, 1.1762296998f, -0.0996759264f);
static const float3 AP0_2_AP1_COL2 = float3(0.0083161484f, -0.0060324498f, 0.9977163014f);

static const float3 AP1_2_AP0_COL0 = float3(0.6954522414f, 0.1406786965f, 0.1638690622f);
static const float3 AP1_2_AP0_COL1 = float3(0.0447945634f, 0.8596711185f, 0.0955343182f);
static const float3 AP1_2_AP0_COL2 = float3(-0.0055258826f, 0.0040252103f, 1.0015006723f);

static const float3 RRT_SAT_COL0 = float3(0.970889148672f, 0.026963270632f, 0.002147580696f);
static const float3 RRT_SAT_COL1 = float3(0.010889148672f, 0.986963270632f, 0.002147580696f);
static const float3 RRT_SAT_COL2 = float3(0.010889148672f, 0.026963270632f, 0.962147580696f);

// c5 segmented spline params.
static const float C5_COEFS_LOW[6] = {
    -4.0000000000f,
    -4.0000000000f,
    -3.1573765773f,
    -0.4852499958f,
    1.8477324706f,
    1.8477324706f};

static const float C5_COEFS_HIGH[6] = {
    -0.7185482425f,
    2.0810307172f,
    3.6681241237f,
    4.0000000000f,
    4.0000000000f,
    4.0000000000f};

static const float C5_LOG_MIN_X = -5.2601774298564115f;  // log10(0.18 * 2^-15)
static const float C5_LOG_MID_X = -0.7447274948966940f;  // log10(0.18)
static const float C5_LOG_MAX_X = 4.6738124270549670f;   // log10(0.18 * 2^18)

static const float C5_LOG_MIN_Y = -4.0000000000000000f;  // log10(0.0001)
static const float C5_LOG_MAX_Y = 4.0000000000000000f;   // log10(10000)

static const float C5_SLOPE_LOW = 0.f;
static const float C5_SLOPE_HIGH = 0.f;

float Log10Safe(float x) {
  return log2(x) * 0.3010299956639811952137389f;
}

float Pow10(float x) {
  return exp2(x * 3.3219280948873623478703194f);
}

float3 MulRowVectorByColumns(float3 v, float3 col0, float3 col1, float3 col2) {
  return float3(dot(v, col0), dot(v, col1), dot(v, col2));
}

float AP1ToAP0Scalar(float3 ap1, int channel) {
  if (channel == 0) return dot(ap1, AP1_2_AP0_COL0);
  if (channel == 1) return dot(ap1, AP1_2_AP0_COL1);
  return dot(ap1, AP1_2_AP0_COL2);
}

float3 AP1ToAP0(float3 ap1) {
  return MulRowVectorByColumns(ap1, AP1_2_AP0_COL0, AP1_2_AP0_COL1, AP1_2_AP0_COL2);
}

float3 AP0ToAP1(float3 ap0) {
  return MulRowVectorByColumns(ap0, AP0_2_AP1_COL0, AP0_2_AP1_COL1, AP0_2_AP1_COL2);
}

float Rgb2Hue(float3 rgb) {
  if (rgb.r == rgb.g && rgb.g == rgb.b) {
    return 0.f;
  }

  float hue = (180.f / 3.14159265359f) * atan2(sqrt(3.f) * (rgb.g - rgb.b), 2.f * rgb.r - rgb.g - rgb.b);
  if (hue < 0.f) {
    hue += 360.f;
  }
  return hue;
}

float Rgb2Yc(float3 rgb, float ycRadiusWeight = 1.75f) {
  float chroma = sqrt(rgb.b * (rgb.b - rgb.g) + rgb.g * (rgb.g - rgb.r) + rgb.r * (rgb.r - rgb.b));
  return (rgb.b + rgb.g + rgb.r + ycRadiusWeight * chroma) / 3.f;
}

float Rgb2Saturation(float3 rgb) {
  float minrgb = min(rgb.r, min(rgb.g, rgb.b));
  float maxrgb = max(rgb.r, max(rgb.g, rgb.b));
  return (max(maxrgb, TINY) - max(minrgb, TINY)) / max(maxrgb, 1e-2f);
}

float GlowFwd(float ycIn, float glowGainIn, float glowMid) {
  if (ycIn <= (2.f / 3.f) * glowMid) {
    return glowGainIn;
  }

  if (ycIn >= 2.f * glowMid) {
    return 0.f;
  }

  return glowGainIn * (glowMid / ycIn - 0.5f);
}

float SigmoidShaper(float x) {
  float t = max(1.f - abs(x / 2.f), 0.f);
  float y = 1.f + sign(x) * (1.f - t * t);
  return y * 0.5f;
}

float CenterHue(float hue, float centerH) {
  float hueCentered = hue - centerH;
  if (hueCentered < -180.f) {
    hueCentered += 360.f;
  } else if (hueCentered > 180.f) {
    hueCentered -= 360.f;
  }
  return hueCentered;
}

float CubicBasisShaper(float x, float w) {
  float knots0 = -w * 0.5f;
  float knots4 = w * 0.5f;

  if (!((x > knots0) && (x < knots4))) {
    return 0.f;
  }

  float knotCoord = (x - knots0) * 4.f / w;
  int j = (int)knotCoord;
  float t = knotCoord - (float)j;

  float t2 = t * t;
  float t3 = t2 * t;

  float y = 0.f;
  if (j == 3) {
    y = t3 * (-1.f / 6.f) + t2 * (3.f / 6.f) + t * (-3.f / 6.f) + (1.f / 6.f);
  } else if (j == 2) {
    y = t3 * (3.f / 6.f) + t2 * (-6.f / 6.f) + t * (0.f / 6.f) + (4.f / 6.f);
  } else if (j == 1) {
    y = t3 * (-3.f / 6.f) + t2 * (3.f / 6.f) + t * (3.f / 6.f) + (1.f / 6.f);
  } else if (j == 0) {
    y = t3 * (1.f / 6.f);
  }

  return y * 1.5f;
}

// CTL M matrix baked into polynomial form for dot(monomials, mult_f3_f33(cf, M)).
float EvalSplineSegment(float t, float c0, float c1, float c2) {
  float a = 0.5f * c0 - c1 + 0.5f * c2;
  float b = -c0 + c1;
  float c = 0.5f * (c0 + c1);
  return mad(t * t, a, mad(t, b, c));
}

float SegmentedSplineC5Fwd(float x) {
  float logx = Log10Safe(max(x, HALF_MIN));
  float logy;

  if (logx <= C5_LOG_MIN_X) {
    logy = logx * C5_SLOPE_LOW + (C5_LOG_MIN_Y - C5_SLOPE_LOW * C5_LOG_MIN_X);
  } else if (logx < C5_LOG_MID_X) {
    float knotCoord = 3.f * (logx - C5_LOG_MIN_X) / (C5_LOG_MID_X - C5_LOG_MIN_X);
    int j = (int)knotCoord;
    j = min(max(j, 0), 2);
    float t = knotCoord - (float)j;

    float c0 = C5_COEFS_LOW[j];
    float c1 = C5_COEFS_LOW[j + 1];
    float c2 = C5_COEFS_LOW[j + 2];

    logy = EvalSplineSegment(t, c0, c1, c2);
  } else if (logx < C5_LOG_MAX_X) {
    float knotCoord = 3.f * (logx - C5_LOG_MID_X) / (C5_LOG_MAX_X - C5_LOG_MID_X);
    int j = (int)knotCoord;
    j = min(max(j, 0), 2);
    float t = knotCoord - (float)j;

    float c0 = C5_COEFS_HIGH[j];
    float c1 = C5_COEFS_HIGH[j + 1];
    float c2 = C5_COEFS_HIGH[j + 2];

    logy = EvalSplineSegment(t, c0, c1, c2);
  } else {
    logy = logx * C5_SLOPE_HIGH + (C5_LOG_MAX_Y - C5_SLOPE_HIGH * C5_LOG_MAX_X);
  }

  return Pow10(logy);
}

// Full CTL RRT: AP0 ACES -> AP0 OCES.
float3 Apply(float3 aces_ap0) {
  float3 aces = aces_ap0;

  float saturation = Rgb2Saturation(aces);
  float ycIn = Rgb2Yc(aces);
  float s = SigmoidShaper((saturation - 0.4f) / 0.2f);
  float addedGlow = 1.f + GlowFwd(ycIn, RRT_GLOW_GAIN * s, RRT_GLOW_MID);
  aces *= addedGlow;

  float hue = Rgb2Hue(aces);
  float centeredHue = CenterHue(hue, RRT_RED_HUE);
  float hueWeight = CubicBasisShaper(centeredHue, RRT_RED_WIDTH);
  aces.r = aces.r + hueWeight * saturation * (RRT_RED_PIVOT - aces.r) * (1.f - RRT_RED_SCALE);

  aces = clamp(aces, 0.f, HALF_POS_INF);
  float3 rgbPre = AP0ToAP1(aces);
  rgbPre = clamp(rgbPre, 0.f, HALF_MAX);

  rgbPre = MulRowVectorByColumns(rgbPre, RRT_SAT_COL0, RRT_SAT_COL1, RRT_SAT_COL2);

  float3 rgbPost = float3(
      SegmentedSplineC5Fwd(rgbPre.r),
      SegmentedSplineC5Fwd(rgbPre.g),
      SegmentedSplineC5Fwd(rgbPre.b));

  float3 oces_ap0 = AP1ToAP0(rgbPost);
  return oces_ap0;
}

// Convenience: AP1 scene input -> AP0 OCES.
float3 ApplyFromAP1(float3 ap1_scene) {
  return Apply(AP1ToAP0(ap1_scene));
}

// Convenience: AP1 scene input -> AP1 OCES pre-ODT domain.
float3 ApplyToODTInputFromAP1(float3 ap1_scene) {
  return AP0ToAP1(ApplyFromAP1(ap1_scene));
}

}  // namespace rrt
}  // namespace aces
}  // namespace renodx_custom

#endif  // PRAGMATA_RRT_HLSLI
