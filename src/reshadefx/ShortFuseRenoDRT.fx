#include "ReShade.fxh"

// clang-format off
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

static const float3x3 XYZ_2_BT709_MAT = float3x3(
   3.2409699419, -1.5373831776, -0.4986107603,
  -0.9692436363,  1.8759675015,  0.0415550574,
   0.0556300797, -0.2039769589,  1.0569715142
);

static const float3x3 BT709_2_XYZ_MAT = float3x3(
  0.4123907983303070068359375f,    0.3575843274593353271484375f,   0.18048079311847686767578125f,
  0.2126390039920806884765625f,    0.715168654918670654296875f,    0.072192318737506866455078125f,
  0.0193308182060718536376953125f, 0.119194783270359039306640625f, 0.950532138347625732421875f
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


static const float3x3 XYZ_2_AP1_MAT = float3x3(
   1.6410233797, -0.3248032942, -0.2364246952,
  -0.6636628587,  1.6153315917,  0.0167563477,
   0.0117218943, -0.0082844420,  0.9883948585
);

static const float3x3 AP1_2_XYZ_MAT = float3x3(
   0.6624541811, 0.1340042065, 0.1561876870,
   0.2722287168, 0.6740817658, 0.0536895174,
  -0.0055746495, 0.0040607335, 1.0103391003
);

// clang-format on


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
    linearFromSRGB(color.r),
    linearFromSRGB(color.g),
    linearFromSRGB(color.b)
  );
}


float3 okLabFromBT709(float3 bt709) {
  // clang-format off
  const float3x3 BT709_2_OKLABLMS = float3x3(
    0.4122214708f, 0.5363325363f, 0.0514459929f,
    0.2119034982f, 0.6806995451f, 0.1073969566f,
    0.0883024619f, 0.2817188376f, 0.6299787005f
  );
  const float3x3 OKLABLMS_2_OKLAB = float3x3(
    0.2104542553f,  0.7936177850f, -0.0040720468f,
    1.9779984951f, -2.4285922050f,  0.4505937099f,
    0.0259040371f,  0.7827717662f, -0.8086757660f
  );
  // clang-format on

  float3 lms = mul(BT709_2_OKLABLMS, bt709);

  lms = sign(lms) * pow(abs(lms), 1.f / 3.f);

  return mul(OKLABLMS_2_OKLAB, lms);
}

float3 bt709FromOKLab(float3 oklab) {
  // clang-format off
  const float3x3 OKLAB_2_OKLABLMS = float3x3(
    1.f,  0.3963377774f,  0.2158037573f,
    1.f, -0.1055613458f, -0.0638541728f,
    1.f, -0.0894841775f, -1.2914855480f
  );

  const float3x3 OKLABLMS_2_BT709 = float3x3(
     4.0767416621f, -3.3077115913f,  0.2309699292f,
    -1.2684380046f,  2.6097574011f, -0.3413193965f,
    -0.0041960863f, -0.7034186147f,  1.7076147010f
  );
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

float yFromBT709(float3 bt709) {
  return dot(bt709, BT709_2_XYZ_MAT[1].rgb);
}

float3 renodrt(
  float3 bt709,
  float peakNits,
  float sceneGray,
  float outputGrayNits,
  float exposure,
  float highlights,
  float shadows,
  float contrast,
  float saturation,
  float dechroma,
  float flare
) {
  static const float3x3 BT709_2_AP1_MAT = mul(XYZ_2_AP1_MAT, mul(D65_2_D60_CAT, BT709_2_XYZ_MAT));
  static const float3x3 AP1_2_BT709_MAT = mul(XYZ_2_BT709_MAT, mul(D60_2_D65_CAT, AP1_2_XYZ_MAT));

  float n_r = 100.f;
  float n = 1000.f;

  // drt cam
  // n_r = 100
  // g = 1.15
  // c = 0.18
  // c_d = 10.013
  // w_g = 0.14
  // t_1 = 0.04
  // r_hit_min = 128
  // r_hit_max = 896

  float g = 1.1;       // gamma/contrast
  float c = 0.18;      // scene-referred gray
  float c_d = 10.013;  // output gray in nits
  float w_g = 0.00f;   // gray change
  float t_1 = 0.01;    // shadow toe
  float r_hit_min = 128;
  float r_hit_max = 256;

  g = contrast;
  c = sceneGray;
  c_d = outputGrayNits;
  n = peakNits;
  t_1 = flare;

  float originalY = yFromBT709(abs(bt709));
  float3 originalLCh = okLChFromBT709(bt709);

  float lum = originalY * exposure;

  float normalizedLum = lum / 0.18f;

  float highlightedLum = pow(normalizedLum, highlights);
  highlightedLum = lerp(normalizedLum, highlightedLum, saturate(normalizedLum));

  float shadowedLum = pow(highlightedLum, -1.f * (shadows - 2.f));
  shadowedLum = lerp(shadowedLum, highlightedLum, saturate(highlightedLum));
  shadowedLum *= 0.18f;
  lum = shadowedLum;

  float m_0 = (n / n_r);
  float m_1 = 0.5 * (m_0 + sqrt(m_0 * (m_0 + (4.0 * t_1))));
  float r_hit = r_hit_min + ((r_hit_max - r_hit_min) * (log(m_0) / log(10000.0 / 100.0)));

  float u = pow((r_hit / m_1) / ((r_hit / m_1) + 1.0), g);
  float m = m_1 / u;
  float w_i = log(n / 100.0) / log(2.0);
  float c_t = (c_d / n_r) * (1.0 + (w_i * w_g));
  float g_ip = 0.5 * (c_t + sqrt(c_t * (c_t + (4.0 * t_1))));
  float g_ipp2 = -m_1 * pow(g_ip / m, 1.0 / g) / (pow(g_ip / m, 1.0 / g) - 1.0);
  float w_2 = c / g_ipp2;
  float s_2 = w_2 * m_1;
  float u_2 = pow((r_hit / m_1) / ((r_hit / m_1) + w_2), g);
  float m_2 = m_1 / u_2;

  float ts = pow(max(0, lum) / (lum + s_2), g) * m_2;

  float flared = max(0, (ts * ts) / (ts + t_1));

  float newY = clamp(flared, 0, m_0);

  float3 outputColor = bt709 * (originalY > 0 ? (newY / originalY) : 0);

  float3 newLCh = okLChFromBT709(outputColor);
  newLCh[1] = lerp(newLCh[1], 0.f, saturate(pow(originalY / (10000.f / 100.f), (1.f - dechroma))));
  newLCh[1] *= saturation;
  newLCh[2] = originalLCh[2];  // hue correction

  float3 color = bt709FromOKLCh(newLCh);
  color = mul(BT709_2_AP1_MAT, color);  // Convert to AP1
  color = max(0, color);                // Clamp to AP1
  color = mul(AP1_2_BT709_MAT, color);  // Convert BT709
  color = min(m_0, color);              // Clamp to Peak
  return color;
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

float3 bt2020FromBT709(float3 bt709) {
  static const float3x3 BT709_2_BT2020_MAT = mul(XYZ_2_BT2020_MAT, BT709_2_XYZ_MAT);
  return mul(BT709_2_BT2020_MAT, bt709);
}

float3 bt709FromBT2020(float3 bt2020) {
  static const float3x3 BT2020_2_BT709_MAT = mul(XYZ_2_BT709_MAT, BT2020_2_XYZ_MAT);
  return mul(BT2020_2_BT709_MAT, bt2020);
}

float gammaCorrect(float x, bool pow2srgb) {
  if (pow2srgb) {
    return linearFromSRGB(pow(x, 1.f / 2.2f));
  } else {  // srgb2pow
    return pow(srgbFromLinear(x), 2.2f);
  }
}

float gammaCorrectSafe(float x, bool pow2srgb) {
  if (pow2srgb) {
    return sign(x) * linearFromSRGB(pow(abs(x), 1.f / 2.2f));
  } else {
    return sign(x) * pow(srgbFromLinear(abs(x)), 2.2f);
  }
}

float3 gammaCorrect(float3 color, bool pow2srgb) {
  return float3(
    gammaCorrect(color.r, pow2srgb),
    gammaCorrect(color.g, pow2srgb),
    gammaCorrect(color.b, pow2srgb)
  );
}

float3 gammaCorrectSafe(float3 color, bool pow2srgb) {
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


uniform float RENODRT_GAME_NITS_INPUT <
ui_type = "slider";
ui_category = "Tone Mapping";
ui_min = 1;
ui_max = 500;
ui_step = 1;
ui_label = "Input Scaling";
ui_tooltip = "Brightness of 100% diffuse white as outputted by game";
> = 203;

uniform float RENODRT_PEAK_NITS <
ui_type = "slider";
ui_category = "Tone Mapping";
ui_min = 80;
ui_max = 10000;
ui_step = 1;
ui_label = "Peak Brightness";
ui_tooltip = "Peak game brightness in nits";
> = 1000;

uniform float RENODRT_GAME_NITS_OUTPUT <
ui_type = "slider";
ui_category = "Tone Mapping";
ui_min = 80;
ui_max = 500;
ui_step = 1;
ui_label = "Game Brightness Output";
ui_tooltip = "Brightness of 100% diffuse white in nits";
> = 203;

uniform uint RENODRT_GAMMA_CORRECTION <
ui_type = "combo";
ui_category = "Tone Mapping";
ui_items = "Off\0On\0";
ui_label = "Gamma Correction";
ui_tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)";
> = 0;

uniform float RENODRT_MID_GRAY_INPUT <
ui_type = "slider";
ui_category = "Tone Mapping";
ui_min = 0;
ui_max = 1;
ui_step = 0.01;
ui_label = "Mid Gray In";
ui_tooltip = "Value of middle gray in linear RGB";
> = 0.18;

uniform float RENODRT_MID_GRAY_OUTPUT <
ui_type = "slider";
ui_category = "Tone Mapping";
ui_min = 0;
ui_max = 20;
ui_step = 0.01;
ui_label = "Mid Gray Out";
ui_tooltip = "Value of middle gray in nits (scaled by Game Brightness / 100)";
> = 10;

uniform float RENODRT_EXPOSURE <
ui_type = "slider";
ui_category = "Color Grading";
ui_min = 0;
ui_max = 10;
ui_step = 0.01;
ui_label = "Exposure";
> = 1.0;

uniform float RENODRT_HIGHLIGHTS <
ui_type = "slider";
ui_category = "Color Grading";
ui_min = 0;
ui_max = 100;
ui_step = 1;
ui_label = "Highlights";
> = 50;

uniform float RENODRT_SHADOWS <
ui_type = "slider";
ui_category = "Color Grading";
ui_min = 0;
ui_max = 100;
ui_step = 1;
ui_label = "Shadows";
> = 50;

uniform float RENODRT_CONTRAST <
ui_type = "slider";
ui_category = "Color Grading";
ui_min = 0;
ui_max = 100;
ui_step = 1;
ui_label = "Contrast";
> = 50;

uniform float RENODRT_SATURATION <
ui_type = "slider";
ui_category = "Color Grading";
ui_min = 0;
ui_max = 100;
ui_step = 1;
ui_label = "Saturation";
> = 50;

uniform float RENODRT_BLOWOUT <
ui_type = "slider";
ui_category = "Color Grading";
ui_min = 0;
ui_max = 100;
ui_step = 1;
ui_label = "Blowout";
ui_tooltip = "Controls highlight desaturation due to overexposure";
> = 50;

uniform float RENODRT_FLARE <
ui_type = "slider";
ui_category = "Color Grading";
ui_min = 0;
ui_max = 100;
ui_step = 1;
ui_label = "Flare";
ui_tooltip = "Controls strength of shadow toe or glare/flare compensation";
> = 0;



float3 main(float4 pos : SV_Position, float2 texcoord : TexCoord) : COLOR {
  float3 inputColor = tex2D(ReShade::BackBuffer, texcoord).rgb;
  float3 linearColor = inputColor;
  switch (BUFFER_COLOR_SPACE) {
    default:
    case 0:
    case 1:
      linearColor = linearColor;
      break;
    case 2:
      linearColor = inputColor * 80.f / RENODRT_GAME_NITS_INPUT;
      break;
    case 3:
      linearColor = bt709FromBT2020(linearFromPQ(inputColor)) * 10000.f / RENODRT_GAME_NITS_INPUT;
      break;
  }

  float maxNits = RENODRT_PEAK_NITS / RENODRT_GAME_NITS_OUTPUT;

  if (RENODRT_GAMMA_CORRECTION) {
    maxNits = gammaCorrect(maxNits, true);
  }
  
  float3 toneMappedColor = renodrt(
    linearColor,
    maxNits * 100.f,
    RENODRT_MID_GRAY_INPUT,
    RENODRT_MID_GRAY_OUTPUT,
    RENODRT_EXPOSURE,
    RENODRT_HIGHLIGHTS * 0.02f,
    RENODRT_SHADOWS * 0.02f,
    RENODRT_CONTRAST * 0.02f,
    RENODRT_SATURATION * 0.02f,
    RENODRT_BLOWOUT * 0.01f,
    RENODRT_FLARE * 0.001f
  );

  if (RENODRT_GAMMA_CORRECTION) {
    toneMappedColor = gammaCorrectSafe(toneMappedColor, false);
  }
  float3 outputColor = toneMappedColor;
  outputColor = toneMappedColor;
  switch (BUFFER_COLOR_SPACE) {
    default:
    case 0:
    case 1:
      // outputColor *= 1.f;
      break;
    case 2:
      outputColor *= RENODRT_GAME_NITS_OUTPUT / 80.f;
      break;
    case 3:
      outputColor = pqFromLinear(bt2020FromBT709(outputColor) * RENODRT_GAME_NITS_OUTPUT / 10000.f);
      break;
  }

  return outputColor;
}

technique ShortFuseRenoDRT {
  pass {
    VertexShader = PostProcessVS;
    PixelShader = main;
  }
}
