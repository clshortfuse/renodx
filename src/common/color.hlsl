#ifndef SRC_COMMON_COLOR_HLSL_
#define SRC_COMMON_COLOR_HLSL_

// clang-format off
static const float3x3 BT709_2_XYZ_MAT = {
  0.4123907983303070068359375f,    0.3575843274593353271484375f,   0.18048079311847686767578125f,
  0.2126390039920806884765625f,    0.715168654918670654296875f,    0.072192318737506866455078125f,
  0.0193308182060718536376953125f, 0.119194783270359039306640625f, 0.950532138347625732421875f,
};

static const float3x3 XYZ_2_BT709_MAT = {
   3.2409699419, -1.5373831776, -0.4986107603,
  -0.9692436363,  1.8759675015,  0.0415550574,
   0.0556300797, -0.2039769589,  1.0569715142
};

static const float3x3 D65_2_D60_CAT = {
   1.01303,    0.00610531, -0.014971,
   0.00769823, 0.998165,   -0.00503203,
  -0.00284131, 0.00468516,  0.924507,
};

static const float3x3 D60_2_D65_CAT = {
   0.98722400, -0.00611327, 0.0159533,
  -0.00759836,  1.00186000, 0.0053302,
   0.00307257, -0.00509595, 1.0816800,
};

static const float3x3 AP0_2_AP1_MAT = {
   1.4514393161, -0.2365107469, -0.2149285693,
  -0.0765537734,  1.1762296998, -0.0996759264,
   0.0083161484, -0.0060324498,  0.9977163014,
};

static const float3x3 XYZ_2_AP0_MAT = {
   1.0498110175, 0.0000000000,-0.0000974845,
  -0.4959030231, 1.3733130458, 0.0982400361,
   0.0000000000, 0.0000000000, 0.9912520182,
};

static const float3x3 XYZ_2_AP1_MAT = {
   1.6410233797, -0.3248032942, -0.2364246952,
  -0.6636628587,  1.6153315917,  0.0167563477,
   0.0117218943, -0.0082844420,  0.9883948585,
};

static const float3x3 XYZ_2_BT2020_MAT = {
   1.7166511880, -0.3556707838, -0.2533662814,
  -0.6666843518,  1.6164812366,  0.0157685458,
   0.0176398574, -0.0427706133,  0.9421031212
};

static const float3x3 AP1_2_XYZ_MAT = {
   0.6624541811, 0.1340042065, 0.1561876870,
   0.2722287168, 0.6740817658, 0.0536895174,
  -0.0055746495, 0.0040607335, 1.0103391003
};


static const float3x3 BT709_2_BT2020_MAT = {
  0.627403914928436279296875f,      0.3292830288410186767578125f,  0.0433130674064159393310546875f,
  0.069097287952899932861328125f,   0.9195404052734375f,           0.011362315155565738677978515625f,
  0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f };

static const float3x3 BT2020_2_BT709_MAT = {
   1.66049098968505859375f,          -0.58764111995697021484375f,     -0.072849862277507781982421875f,
  -0.12455047667026519775390625f,     1.13289988040924072265625f,     -0.0083494223654270172119140625f,
  -0.01815076358616352081298828125f, -0.100578896701335906982421875f,  1.11872971057891845703125f
};

static const float3x3 BT2020_2_XYZ_MAT = {
  0.6369736, 0.1446172, 0.1688585,
  0.2627066, 0.6779996, 0.0592938,
  0.0000000, 0.0280728, 1.0608437
};

static const float3x3 IDENTITY_MAT = {
  1.0f, 0.0f, 0.0f,
  0.0f, 1.0f, 0.0f,
  0.0f, 0.0f, 1.0f
};

// clang-format on

static const float3x3 BT709_2_AP1_MAT = mul(XYZ_2_AP1_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));
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

static const float3 BT601_2_Y = float3(0.299, 0.587, 0.114);

float3 xyzFromBT709(float3 bt709) {
  return mul(BT709_2_XYZ_MAT, bt709);
}

float3 bt2020FromBT709(float3 bt709) {
  return mul(BT709_2_BT2020_MAT, bt709);
}

float3 bt709FromBT2020(float3 bt2020) {
  return mul(BT2020_2_BT709_MAT, bt2020);
}

float yFromBT601(float3 bt601) {
  return dot(BT601_2_Y, bt601);
}

float yFromBT709(float3 bt709) {
  return dot(bt709, float3(BT709_2_XYZ_MAT[1].r, BT709_2_XYZ_MAT[1].g, BT709_2_XYZ_MAT[1].b));
}

float yFromBT2020(float3 bt2020) {
  return dot(bt2020, float3(BT2020_2_XYZ_MAT[1].r, BT2020_2_XYZ_MAT[1].g, BT2020_2_XYZ_MAT[1].b));
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
    srgbFromLinear(color.r),
    srgbFromLinear(color.g),
    srgbFromLinear(color.b)
  );
}

float4 linearFromSRGB(float4 color) {
  return float4(
    srgbFromLinear(color.r),
    srgbFromLinear(color.g),
    srgbFromLinear(color.b),
    srgbFromLinear(color.a)
  );
}

float arriC800FromLinear(float x) {
  const float cut = 0.010591f;
  const float a = 5.555556f;
  const float b = 0.052272f;
  const float c = 0.247190f;
  const float d = 0.385537f;
  const float e = 5.367655f;
  const float f = 0.092809f;

  return (x > cut)
         ? (c * log10((a * x) + b) + d)
         : (e * x + f);
}

float3 arriC800FromLinear(float3 color) {
  return float3(
    arriC800FromLinear(color.r),
    arriC800FromLinear(color.g),
    arriC800FromLinear(color.b)
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

#endif  // SRC_COMMON_COLOR_HLSL_
