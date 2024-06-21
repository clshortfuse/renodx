#ifndef SRC_COMMON_COLOR_HLSL_
#define SRC_COMMON_COLOR_HLSL_

// clang-format off
static const float3x3 BT709_2_XYZ_MAT = float3x3(
  0.4123907993f, 0.3575843394f, 0.1804807884f,
  0.2126390059f, 0.7151686788f, 0.0721923154f,
  0.0193308187f, 0.1191947798f, 0.9505321522f
);

static const float3x3 XYZ_2_BT709_MAT = float3x3(
   3.2409699419f, -1.5373831776f, -0.4986107603f,
  -0.9692436363f,  1.8759675015f,  0.0415550574f,
   0.0556300797f, -0.2039769589f,  1.0569715142f
);

static const float3x3 BT2020_2_XYZ_MAT = float3x3(
  0.6369580483f, 0.1446169036f, 0.1688809752f,
  0.2627002120f, 0.6779980715f, 0.0593017165f,
  0.0000000000f, 0.0280726930f, 1.0609850577f
);

static const float3x3 XYZ_2_BT2020_MAT = float3x3(
   1.7166511880f, -0.3556707838f, -0.2533662814f,
  -0.6666843518f,  1.6164812366f,  0.0157685458f,
   0.0176398574f, -0.0427706133f,  0.9421031212f
);

static const float3x3 AP0_2_XYZ_MAT = float3x3(
  0.9525523959f, 0.0000000000f,  0.0000936786f,
  0.3439664498f, 0.7281660966f, -0.0721325464f,
  0.0000000000f, 0.0000000000f,  1.0088251844f
);

static const float3x3 XYZ_2_AP0_MAT = float3x3(
   1.0498110175f, 0.0000000000f, -0.0000974845f,
  -0.4959030231f, 1.3733130458f,  0.0982400361f,
   0.0000000000f, 0.0000000000f,  0.9912520182f
);

static const float3x3 AP1_2_XYZ_MAT = float3x3(
   0.6624541811f, 0.1340042065f, 0.1561876870f,
   0.2722287168f, 0.6740817658f, 0.0536895174f,
  -0.0055746495f, 0.0040607335f, 1.0103391003f
);

static const float3x3 XYZ_2_AP1_MAT = float3x3(
   1.6410233797f, -0.3248032942f, -0.2364246952f,
  -0.6636628587f,  1.6153315917f,  0.0167563477f,
   0.0117218943f, -0.0082844420f,  0.9883948585f
);

static const float3x3 DISPLAYP3_2_XYZ_MAT = float3x3(
  0.4865709486f, 0.2656676932f, 0.1982172852f,
  0.2289745641f, 0.6917385218f, 0.0792869141f,
 -0.0000000000f, 0.0451133819f, 1.0439443689f
);

static const float3x3 XYZ_2_DISPLAYP3_MAT = float3x3(
  2.4934969119f, -0.9313836179f, -0.4027107845f,
 -0.8294889696f,  1.7626640603f,  0.0236246858f,
  0.0358458302f, -0.0761723893f,  0.9568845240
);

// With Bradford
static const float3x3 D65_2_D60_CAT = float3x3(
   1.01303,    0.00610531, -0.014971,
   0.00769823, 0.998165,   -0.00503203,
  -0.00284131, 0.00468516,  0.924507
);

// With Bradford
static const float3x3 D60_2_D65_CAT = float3x3(
   0.98722400, -0.00611327, 0.0159533,
  -0.00759836,  1.00186000, 0.0053302,
   0.00307257, -0.00509595, 1.0816800
);

static const float3x3 IDENTITY_MAT = float3x3(
  1.0f, 0.0f, 0.0f,
  0.0f, 1.0f, 0.0f,
  0.0f, 0.0f, 1.0f
);

// clang-format on

static const float3x3 BT709_2_AP0_MAT = mul(XYZ_2_AP0_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));
static const float3x3 BT709_2_AP1_MAT = mul(XYZ_2_AP1_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));
static const float3x3 BT709_2_BT2020_MAT = mul(XYZ_2_BT2020_MAT, BT709_2_XYZ_MAT);
static const float3x3 BT709_2_BT709D60_MAT = mul(XYZ_2_BT709_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));
static const float3x3 BT709_2_BT2020D60_MAT = mul(XYZ_2_BT2020_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));
static const float3x3 BT709_2_DISPLAYP3_MAT = mul(XYZ_2_DISPLAYP3_MAT, BT709_2_XYZ_MAT);
static const float3x3 BT709_2_DISPLAYP3D60_MAT = mul(XYZ_2_DISPLAYP3_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));

static const float3x3 BT2020_2_AP0_MAT = mul(XYZ_2_AP0_MAT, mul(D65_2_D60_CAT, BT2020_2_XYZ_MAT));
static const float3x3 BT2020_2_BT709_MAT = mul(XYZ_2_BT709_MAT, BT2020_2_XYZ_MAT);

static const float3x3 DISPLAYP3_2_AP0_MAT = mul(XYZ_2_AP0_MAT, mul(D65_2_D60_CAT, DISPLAYP3_2_XYZ_MAT));
static const float3x3 DISPLAYP3_2_BT709_MAT = mul(XYZ_2_BT709_MAT, DISPLAYP3_2_XYZ_MAT);

static const float3x3 AP0_2_AP1_MAT = mul(XYZ_2_AP1_MAT, AP0_2_XYZ_MAT);

static const float3x3 AP1_2_AP0_MAT = mul(XYZ_2_AP0_MAT, AP1_2_XYZ_MAT);
static const float3x3 AP1_2_BT709_MAT = mul(XYZ_2_BT709_MAT, mul(D60_2_D65_CAT, AP1_2_XYZ_MAT));
static const float3x3 AP1_2_BT2020_MAT = mul(XYZ_2_BT2020_MAT, mul(D60_2_D65_CAT, AP1_2_XYZ_MAT));

static const float3x3 AP1_2_BT709D60_MAT = mul(XYZ_2_BT709_MAT, AP1_2_XYZ_MAT);
static const float3x3 AP1_2_BT2020D60_MAT = mul(XYZ_2_BT2020_MAT, AP1_2_XYZ_MAT);
static const float3x3 AP1_2_AP1D65_MAT = mul(XYZ_2_AP1_MAT, mul(D60_2_D65_CAT, AP1_2_XYZ_MAT));

static const float3 BT601_2_Y = float3(0.299, 0.587, 0.114);

// https://www.ilkeratalay.com/colorspacesfaq.php
static const float3 BOURGIN_D65_Y = float3(0.222015, 0.706655, 0.071330);

float3 xyzFromBT709(float3 bt709) {
  return mul(BT709_2_XYZ_MAT, bt709);
}

float3 bt2020FromBT709(float3 bt709) {
  return mul(BT709_2_BT2020_MAT, bt709);
}

float3 bt709FromBT2020(float3 bt2020) {
  return mul(BT2020_2_BT709_MAT, bt2020);
}

float3 bt709FromAP1(float3 ap1) {
  return mul(AP1_2_BT709_MAT, ap1);
}

float3 ap1FromBT709(float3 bt709) {
  return mul(BT709_2_AP1_MAT, bt709);
}

float3 clampBT709ToBT709(float3 bt709) {
  return max(0, bt709);
}

float3 clampBT709ToBT2020(float3 bt709) {
  float3 bt2020 = bt2020FromBT709(bt709);
  bt2020 = max(0, bt2020);
  return bt709FromBT2020(bt2020);
}

float3 clampBT709ToAP1(float3 bt709) {
  float3 ap1 = ap1FromBT709(bt709);
  ap1 = max(0, ap1);
  return bt709FromAP1(ap1);
}

float yFromBT601(float3 bt601) {
  return dot(BT601_2_Y, bt601);
}

float yFromBT709(float3 bt709) {
  return dot(bt709, BT709_2_XYZ_MAT[1].rgb);
}

float yFromBT2020(float3 bt2020) {
  return dot(bt2020, BT2020_2_XYZ_MAT[1].rgb);
}

float3 pqFromLinear(float3 linearColor) {
  static const float m1 = 0.1593017578125f;
  static const float m2 = 78.84375f;
  static const float c1 = 0.8359375f;
  static const float c2 = 18.8515625f;
  static const float c3 = 18.6875f;

  float3 yM1 = pow(linearColor, m1);
  return pow((c1 + c2 * yM1) / (1.f + c3 * yM1), m2);
}

float3 linearFromPQ(float3 pqColor) {
  static const float m1 = 0.1593017578125f;
  static const float m2 = 78.84375f;
  static const float c1 = 0.8359375f;
  static const float c2 = 18.8515625f;
  static const float c3 = 18.6875f;

  float3 eM12 = pow(pqColor, 1.f / m2);
  return pow(max(eM12 - c1, 0) / (c2 - c3 * eM12), 1.f / m1);
}

float srgbFromLinear(float channel) {
  return (channel <= 0.0031308f)
         ? (channel * 12.92f)
         : (1.055f * pow(channel, 1.f / 2.4f) - 0.055f);
}

float3 srgbFromLinear(float3 color) {
  return float3(
    srgbFromLinear(color.r),
    srgbFromLinear(color.g),
    srgbFromLinear(color.b)
  );
}

float4 srgbFromLinear(float4 color) {
  return float4(
    srgbFromLinear(color.r),
    srgbFromLinear(color.g),
    srgbFromLinear(color.b),
    color.a
  );
}

float4 srgbaFromLinear(float4 color) {
  return float4(
    srgbFromLinear(color.r),
    srgbFromLinear(color.g),
    srgbFromLinear(color.b),
    srgbFromLinear(color.a)
  );
}

float linearFromSRGB(float channel) {
  return (channel <= 0.04045f)
         ? (channel / 12.92f)
         : pow((channel + 0.055f) / 1.055f, 2.4f);
}

float3 linearFromSRGB(float3 color) {
  return float3(
    linearFromSRGB(color.r),
    linearFromSRGB(color.g),
    linearFromSRGB(color.b)
  );
}

float4 linearFromSRGB(float4 color) {
  return float4(
    linearFromSRGB(color.r),
    linearFromSRGB(color.g),
    linearFromSRGB(color.b),
    color.a
  );
}

float4 linearFromSRGBA(float4 color) {
  return float4(
    linearFromSRGB(color.r),
    linearFromSRGB(color.g),
    linearFromSRGB(color.b),
    linearFromSRGB(color.a)
  );
}

float arriC800FromLinear(float x, float cut = 0.010591f) {
  const float a = 5.555556f;
  const float b = 0.052272f;
  const float c = 0.247190f;
  const float d = 0.385537f;
  const float e = 5.367655f;
  const float f = 0.092809f;
  return (!cut || x > cut)
         ? (c * log10((a * x) + b) + d)
         : (e * x + f);
}

float arriC1000FromLinear(float x, float cut = 0.011361f) {
  const float a = 5.555556f;
  const float b = 0.047996f;
  const float c = 0.244161f;
  const float d = 0.386036f;
  const float e = 5.301883f;
  const float f = 0.092814f;
  return (!cut || x > cut)
         ? (c * log10((a * x) + b) + d)
         : (e * x + f);
}

float3 arriC800FromLinear(float3 color, float cut = 0.010591f) {
  return float3(
    arriC800FromLinear(color.r, cut),
    arriC800FromLinear(color.g, cut),
    arriC800FromLinear(color.b, cut)
  );
}

float3 arriC1000FromLinear(float3 color, float cut = 0.011361f) {
  return float3(
    arriC1000FromLinear(color.r, cut),
    arriC1000FromLinear(color.g, cut),
    arriC1000FromLinear(color.b, cut)
  );
}

float linearFromArriC800(float t) {
  const float cut = 0.010591f;
  const float a = 5.555556f;
  const float b = 0.052272f;
  const float c = 0.247190f;
  const float d = 0.385537f;
  const float e = 5.367655f;
  const float f = 0.092809f;

  return (t > e * cut + f)
         ? (pow(10, (t - d) / c) - b) / a
         : (t - f) / e;
}

float3 linearFromArriC800(float3 color) {
  return float3(
    linearFromArriC800(color.r),
    linearFromArriC800(color.g),
    linearFromArriC800(color.b)
  );
}

float3 okLabFromBT709(float3 bt709) {
  // clang-format off
  const float3x3 BT709_2_OKLABLMS = {
    0.4122214708f, 0.5363325363f, 0.0514459929f,
    0.2119034982f, 0.6806995451f, 0.1073969566f,
    0.0883024619f, 0.2817188376f, 0.6299787005f
  };
  const float3x3 OKLABLMS_2_OKLAB = {
    0.2104542553f,  0.7936177850f, -0.0040720468f,
    1.9779984951f, -2.4285922050f,  0.4505937099f,
    0.0259040371f,  0.7827717662f, -0.8086757660f
  };
  // clang-format on

  float3 lms = mul(BT709_2_OKLABLMS, bt709);

  lms = sign(lms) * pow(abs(lms), 1.f / 3.f);

  return mul(OKLABLMS_2_OKLAB, lms);
}

float3 bt709FromOKLab(float3 oklab) {
  // clang-format off
  const float3x3 OKLAB_2_OKLABLMS = {
    1.f,  0.3963377774f,  0.2158037573f,
    1.f, -0.1055613458f, -0.0638541728f,
    1.f, -0.0894841775f, -1.2914855480f
  };

  const float3x3 OKLABLMS_2_BT709 = {
     4.0767416621f, -3.3077115913f,  0.2309699292f,
    -1.2684380046f,  2.6097574011f, -0.3413193965f,
    -0.0041960863f, -0.7034186147f,  1.7076147010f
  };
  // clang-format on

  float3 lms = mul(OKLAB_2_OKLABLMS, oklab);

  lms = lms * lms * lms;

  return mul(OKLABLMS_2_BT709, lms);
}

float3 okLChFromOKLab(float3 oklab) {
  float L = oklab[0];
  float a = oklab[1];
  float b = oklab[2];
  return float3(
    L,
    sqrt((a * a) + (b * b)),
    atan2(b, a)
  );
}

float3 okLabFromOKLCh(float3 oklch) {
  float L = oklch[0];
  float C = oklch[1];
  float h = oklch[2];
  return float3(
    L,
    C * cos(h),
    C * sin(h)
  );
}

float3 okLChFromBT709(float3 bt709) {
  float3 okLab = okLabFromBT709(bt709);
  return okLChFromOKLab(okLab);
}

float3 bt709FromOKLCh(float3 oklch) {
  float3 okLab = okLabFromOKLCh(oklch);
  return bt709FromOKLab(okLab);
}

float gammaCorrect(float x, bool pow2srgb = false) {
  if (pow2srgb) {
    return linearFromSRGB(pow(x, 1.f / 2.2f));
  } else {  // srgb2pow
    return pow(srgbFromLinear(x), 2.2f);
  }
}

float gammaCorrectSafe(float x, bool pow2srgb = false) {
  if (pow2srgb) {
    return sign(x) * linearFromSRGB(pow(abs(x), 1.f / 2.2f));
  } else {
    return sign(x) * pow(srgbFromLinear(abs(x)), 2.2f);
  }
}

float3 gammaCorrect(float3 color, bool pow2srgb = false) {
  return float3(
    gammaCorrect(color.r, pow2srgb),
    gammaCorrect(color.g, pow2srgb),
    gammaCorrect(color.b, pow2srgb)
  );
}

float3 gammaCorrectSafe(float3 color, bool pow2srgb = false) {
  float3 signs = sign(color);
  color = abs(color);
  color = float3(
    gammaCorrect(color.r, pow2srgb),
    gammaCorrect(color.g, pow2srgb),
    gammaCorrect(color.b, pow2srgb)
  );
  color *= signs;
  return color;
}

float3 hueCorrection(float3 incorrectColor, float3 correctColor) {
  float3 correctLCh = okLChFromBT709(correctColor);
  float3 incorrectLCh = okLChFromBT709(incorrectColor);
  incorrectLCh[2] = correctLCh[2];
  float3 color = bt709FromOKLCh(incorrectLCh);
  color = mul(BT709_2_AP1_MAT, color);  // Convert to AP1
  color = max(0, color);                // Clamp to AP1
  color = mul(AP1_2_BT709_MAT, color);  // Convert BT709
  return color;
}

// taken from Filoppi: https://github.com/Filoppi/PumboAutoHDR/blob/master/Shaders/Pumbo/Color.fxh
// Bizarre matrix but this expands sRGB to between P3 and AP1
// CIE 1931 chromaticities:	x		y
//				Red:		0.6965	0.3065
//				Green:		0.245	0.718
//				Blue:		0.1302	0.0456
//				White:		0.31271	0.32902
static const float3x3 Wide_2_XYZ_MAT = float3x3(
  0.5441691, 0.2395926, 0.1666943,
  0.2394656, 0.7021530, 0.0583814,
  -0.0023439, 0.0361834, 1.0552183);

// taken from Filoppi: https://github.com/Filoppi/PumboAutoHDR/blob/master/Shaders/Pumbo/Color.fxh 
// Expand bright saturated colors outside the sRGB (REC.709) gamut to fake wide gamut rendering (BT.2020).
// Inspired by Unreal Engine 4/5 (ACES).
// Input (and output) needs to be in sRGB linear space.
// Calling this with a value of 0 still results in changes (it's actually an edge case, don't call it, it produces invalid/imaginary colors).
// Calling this with values above 1 yields diminishing returns.
float3 expandGamut(float3 vHDRColor, float fExpandGamut /*= 1.0f*/)
{
  vHDRColor *= 203.f/80.f;  // expects 203 paperwhite

  const float3x3 sRGB_2_AP1 = mul(XYZ_2_AP1_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));
  const float3x3 AP1_2_sRGB = mul(XYZ_2_BT709_MAT, mul(D60_2_D65_CAT, AP1_2_XYZ_MAT));
  const float3x3 Wide_2_AP1 = mul(XYZ_2_AP1_MAT, Wide_2_XYZ_MAT);
  const float3x3 ExpandMat = mul(Wide_2_AP1, AP1_2_sRGB);

  float3 ColorAP1 = mul(sRGB_2_AP1, vHDRColor);

  float LumaAP1 = dot(ColorAP1, float3(0.2722287168, 0.6740817658, 0.0536895174));
  if (LumaAP1 <= 0.f)
  {
      return vHDRColor;
  }
  float3 ChromaAP1 = ColorAP1 / LumaAP1;

  float ChromaDistSqr = dot(ChromaAP1 - 1, ChromaAP1 - 1);
  float ExpandAmount = (1 - exp2(-4 * ChromaDistSqr)) * (1 - exp2(-4 * fExpandGamut * LumaAP1 * LumaAP1));

  float3 ColorExpand = mul(ExpandMat, ColorAP1);
  ColorAP1 = lerp(ColorAP1, ColorExpand, ExpandAmount);

  vHDRColor = mul(AP1_2_sRGB, ColorAP1);
  vHDRColor *= 80.f/203.f;  // scale paper white back down
  return vHDRColor;
}

#endif  // SRC_COMMON_COLOR_HLSL_
