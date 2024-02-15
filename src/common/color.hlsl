static const float PQ_constant_M1 = 0.1593017578125f;
static const float PQ_constant_M2 = 78.84375f;
static const float PQ_constant_C1 = 0.8359375f;
static const float PQ_constant_C2 = 18.8515625f;
static const float PQ_constant_C3 = 18.6875f;

// clang-format off
static const float3x3 BT709_To_XYZ = {
  0.4123907983303070068359375f,    0.3575843274593353271484375f,   0.18048079311847686767578125f,
  0.2126390039920806884765625f,    0.715168654918670654296875f,    0.072192318737506866455078125f,
  0.0193308182060718536376953125f, 0.119194783270359039306640625f, 0.950532138347625732421875f,
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

static const float3x3 XYZ_2_REC709_MAT = {
   3.2409699419, -1.5373831776, -0.4986107603,
  -0.9692436363,  1.8759675015,  0.0415550574,
   0.0556300797, -0.2039769589,  1.0569715142
};

static const float3x3 XYZ_2_REC2020_MAT = {
   1.7166511880, -0.3556707838, -0.2533662814,
  -0.6666843518,  1.6164812366,  0.0157685458,
   0.0176398574, -0.0427706133,  0.9421031212
};

// clang-format on

float3 xyzFromBT709(float3 bt709) {
  return mul(BT709_To_XYZ, bt709);
}

float3 REC709toREC2020(float3 RGB709) {
  static const float3x3 ConvMat = {
    0.627402, 0.329292, 0.043306, 0.069095, 0.919544, 0.011360, 0.016394, 0.088028, 0.895578
  };
  return mul(ConvMat, RGB709);
}

float3 Linear_to_PQ(float3 LinearColor) {
  // LinearColor = max(LinearColor, 0.f);
  float3 colorPow = pow(LinearColor, PQ_constant_M1);
  float3 numerator = PQ_constant_C1 + PQ_constant_C2 * colorPow;
  float3 denominator = 1.f + PQ_constant_C3 * colorPow;
  float3 pq = pow(numerator / denominator, PQ_constant_M2);
  return pq;
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
