#ifndef SRC_SHADERS_TONEMAP_HLSL_
#define SRC_SHADERS_TONEMAP_HLSL_

#include "./aces.hlsl"
#include "./colorgrade.hlsl"
#include "./lut.hlsl"
#include "./renodrt.hlsl"

// https://www.glowybits.com/blog/2016/12/21/ifl_iss_hdr_1/
float3 RgbAcesHdrSrgb(float3 x) {
  x = (x * (x * (x * (x * 2708.7142 + 6801.1525) + 1079.5474) + 1.1614649) - 0.00004139375) / (x * (x * (x * (x * 983.38937 + 4132.0662) + 2881.6522) + 128.35911) + 1.0);
  return max(x, 0.0);
}

// Convert a linear RGB color to an sRGB-encoded color after applying approximate ACES SDR
//  tonemapping (with input scaled by 2.05). Input is assumed to be non-negative.

float3 RgbAcesSdrSrgb(float3 x) {
  return saturate(
    (x * (x * (x * (x * 8.4680 + 1.0) - 0.002957) + 0.0001004) - 0.0000001274) / (x * (x * (x * (x * 8.3604 + 1.8227) + 0.2189) - 0.002117) + 0.00003673)
  );
}

// https://www.slideshare.net/ozlael/hable-john-uncharted2-hdr-lighting
// http://filmicworlds.com/blog/filmic-tonemapping-operators/

static const float uncharted2Tonemap_W = 11.2;  // Linear White

float toneMapCurve(float x, float a, float b, float c, float d, float e, float f) {
  return ((x * (a * x + c * b) + d * e) / (x * (a * x + b) + d * f)) - e / f;
}

float3 toneMapCurve(float3 x, float a, float b, float c, float d, float e, float f) {
  return ((x * (a * x + c * b) + d * e) / (x * (a * x + b) + d * f)) - e / f;
}

float uncharted2Tonemap(float x) {
  float A = 0.22;  // Shoulder Strength
  float B = 0.30;  // Linear Strength
  float C = 0.10;  // Linear Angle
  float D = 0.20;  // Toe Strength
  float E = 0.01;  // Toe Numerator
  float F = 0.30;  // Toe Denominator
  return toneMapCurve(x, A, B, C, D, E, F);
}

float3 uncharted2Tonemap(float3 x) {
  float A = 0.22;  // Shoulder Strength
  float B = 0.30;  // Linear Strength
  float C = 0.10;  // Linear Angle
  float D = 0.20;  // Toe Strength
  float E = 0.01;  // Toe Numerator
  float F = 0.30;  // Toe Denominator
  return toneMapCurve(x, A, B, C, D, E, F);
}

float3 unityNeutralTonemap(float3 x) {
  float A = 0.20;   // Shoulder Strength
  float B = 0.29;   // Linear Strength
  float C = 0.24;   // Linear Angle
  float D = 0.272;  // Toe Strength
  float E = 0.02;   // Toe Numerator
  float F = 0.03;   // Toe Denominator
  float3 r0, r1, r2 = x;
  r0.xyz = x.xyz;
  r1.xyz = float3(1.31338608, 1.31338608, 1.31338608) * r0.xyz;
  r2.xyz = r0.xyz * float3(0.262677222, 0.262677222, 0.262677222) + float3(0.0695999935, 0.0695999935, 0.0695999935);
  r2.xyz = r1.xyz * r2.xyz + float3(0.00543999998, 0.00543999998, 0.00543999998);
  r0.xyz = r0.xyz * float3(0.262677222, 0.262677222, 0.262677222) + float3(0.289999992, 0.289999992, 0.289999992);
  r0.xyz = r1.xyz * r0.xyz + float3(0.0816000104, 0.0816000104, 0.0816000104);
  r0.xyz = r2.xyz / r0.xyz;
  r0.xyz = float3(-0.0666666627, -0.0666666627, -0.0666666627) + r0.xyz;
  r0.xyz = float3(1.31338608, 1.31338608, 1.31338608) * r0.xyz;
  return r0.xyz;
}

struct ToneMapParams {
  float type;
  float peakNits;
  float gameNits;
  float gammaCorrection;
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float saturation;
  float sceneMidGray;
  float midGrayNits;
  float renoDRTHighlights;
  float renoDRTShadows;
  float renoDRTContrast;
  float renoDRTSaturation;
  float renoDRTDechroma;
  float renoDRTFlare;
};

#define TONE_MAP_TYPE__VANILLA 0
#define TONE_MAP_TYPE__NONE    1
#define TONE_MAP_TYPE__ACES    2
#define TONE_MAP_TYPE__RENODRT 3

// Deprecated
typedef struct LUTParams ToneMapLUTParams;
#define TONE_MAP_LUT_TYPE__LINEAR            LUT_TYPE__LINEAR
#define TONE_MAP_LUT_TYPE__SRGB              LUT_TYPE__SRGB
#define TONE_MAP_LUT_TYPE__2_4               LUT_TYPE__2_4
#define TONE_MAP_LUT_TYPE__2_2               LUT_TYPE__2_2
#define TONE_MAP_LUT_TYPE__2_0               LUT_TYPE__2_0
#define TONE_MAP_LUT_TYPE__ARRI_C800         LUT_TYPE__ARRI_C800
#define TONE_MAP_LUT_TYPE__ARRI_C1000        LUT_TYPE__ARRI_C1000
#define TONE_MAP_LUT_TYPE__ARRI_C800_NO_CUT  LUT_TYPE__ARRI_C800_NO_CUT
#define TONE_MAP_LUT_TYPE__ARRI_C1000_NO_CUT LUT_TYPE__ARRI_C1000_NO_CUT
#define TONE_MAP_LUT_TYPE__PQ                LUT_TYPE__PQ

ToneMapParams buildToneMapParams(
  float type = 0.f,
  float peakNits = 203.f,
  float gameNits = 203.f,
  float gammaCorrection = 0,
  float exposure = 1.f,
  float highlights = 1.f,
  float shadows = 1.f,
  float contrast = 1.f,
  float saturation = 1.f,
  float sceneMidGray = 0.18f,
  float midGrayNits = 18.f,
  float renoDRTHighlights = 1.f,
  float renoDRTShadows = 1.f,
  float renoDRTContrast = 1.f,
  float renoDRTSaturation = 1.f,
  float renoDRTDechroma = 0.5f,
  float renoDRTFlare = 0.f
) {
  ToneMapParams toneMapParams = {
    type,
    peakNits,
    gameNits,
    gammaCorrection,
    exposure,
    highlights,
    shadows,
    contrast,
    saturation,
    sceneMidGray,
    midGrayNits,
    renoDRTHighlights,
    renoDRTShadows,
    renoDRTContrast,
    renoDRTSaturation,
    renoDRTDechroma,
    renoDRTFlare
  };
  return toneMapParams;
}

float3 renoDRTToneMap(float3 color, ToneMapParams params, bool sdr = false) {
  float renoDRTMax = sdr ? 1.f : (params.peakNits / params.gameNits);
  if (!sdr && params.gammaCorrection != 0) {
    renoDRTMax = gammaCorrect(renoDRTMax, params.gammaCorrection == 1.f);
  }

  return renodrt(
    color,
    renoDRTMax * 100.f,
    0.18f,
    params.midGrayNits,
    params.exposure,
    params.renoDRTHighlights,
    params.renoDRTShadows,
    params.renoDRTContrast,
    params.renoDRTSaturation,
    params.renoDRTDechroma,
    params.renoDRTFlare
  );
}

float3 acesToneMap(float3 color, ToneMapParams params, bool sdr = false) {
  const float ACES_MID_GRAY = 0.10f;
  float midGrayScale = (params.sceneMidGray / ACES_MID_GRAY);
  float paperWhite = (sdr ? 1.f : params.gameNits);

  float acesMin = (0.0001f) / paperWhite;
  float acesMax = (sdr ? 1.f : params.peakNits) / paperWhite;

  if (!sdr && params.gammaCorrection) {
    acesMax = gammaCorrect(acesMax, params.gammaCorrection == 1.f);
    acesMin = gammaCorrect(acesMin, params.gammaCorrection == 1.f);
  }
  acesMax /= midGrayScale;
  acesMin /= midGrayScale;

  color = aces_rgc_rrt_odt(
    color,
    acesMin * 48.f,
    acesMax * 48.f
  );
  color /= 48.f;
  color *= midGrayScale;

  return color;
}

float3 toneMapUpgrade(float3 hdrColor, float3 sdrColor, float3 postProcessColor, float postProcessStrength) {
  float scaledRatio = 1.f;

  float hdrY = yFromBT709(abs(hdrColor));
  float sdrY = yFromBT709(abs(sdrColor));
  float postProcessY = yFromBT709(abs(postProcessColor));

  if (hdrY < sdrY) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    scaledRatio = hdrY / sdrY;
  } else {
    float deltaY = hdrY - sdrY;
    deltaY = max(0, deltaY);  // Cleans up NaN
    float newY = postProcessY + deltaY;

    bool isValidY = (postProcessY > 0);  // Cleans up NaN and ignore black
    scaledRatio = isValidY ? (newY / postProcessY) : 0;
  }

  float3 scaledColor = postProcessColor * scaledRatio;
  scaledColor = hueCorrection(scaledColor, postProcessColor);
  return lerp(hdrColor, scaledColor, postProcessStrength);
}

float3 toneMap(float3 untonemapped, ToneMapParams params) {
  float3 outputColor = untonemapped;

  if (params.type == 3.f) {
    params.renoDRTHighlights *= params.highlights;
    params.renoDRTShadows *= params.shadows;
    params.renoDRTContrast *= params.contrast;
    params.renoDRTSaturation *= params.saturation;
    // params.renoDRTDechroma *= params.dechroma;
    outputColor = renoDRTToneMap(outputColor, params);
  } else {
    outputColor = applyUserColorGrading(
      outputColor,
      params.exposure,
      params.highlights,
      params.shadows,
      params.contrast,
      params.saturation
    );
    if (params.type == 2.f) {
      outputColor = acesToneMap(outputColor, params);
    }
  }
  return outputColor;
}

#define toneMapFunctionGenerator(textureType)                                                              \
  float3 toneMap(float3 inputColor, ToneMapParams tmParams, LUTParams lutParams, textureType lutTexture) { \
    if (lutParams.strength == 0.f || tmParams.type == 1.f) {                                               \
      return toneMap(inputColor, tmParams);                                                                \
    }                                                                                                      \
    float3 outputColor = inputColor;                                                                       \
                                                                                                           \
    float3 hdrColor;                                                                                       \
    float3 sdrColor;                                                                                       \
    if (tmParams.type == 3.f) {                                                                            \
      tmParams.renoDRTSaturation *= tmParams.saturation;                                                   \
                                                                                                           \
      sdrColor = renoDRTToneMap(outputColor, tmParams, true);                                              \
                                                                                                           \
      tmParams.renoDRTHighlights *= tmParams.highlights;                                                   \
      tmParams.renoDRTShadows *= tmParams.shadows;                                                         \
      tmParams.renoDRTContrast *= tmParams.contrast;                                                       \
                                                                                                           \
      hdrColor = renoDRTToneMap(outputColor, tmParams);                                                    \
                                                                                                           \
    } else {                                                                                               \
      outputColor = applyUserColorGrading(                                                                 \
        outputColor,                                                                                       \
        tmParams.exposure,                                                                                 \
        tmParams.highlights,                                                                               \
        tmParams.shadows,                                                                                  \
        tmParams.contrast,                                                                                 \
        tmParams.saturation                                                                                \
      );                                                                                                   \
                                                                                                           \
      if (tmParams.type == 2.f) {                                                                          \
        hdrColor = acesToneMap(outputColor, tmParams);                                                     \
        sdrColor = acesToneMap(outputColor, tmParams, true);                                               \
      } else {                                                                                             \
        hdrColor = outputColor;                                                                            \
        sdrColor = outputColor;                                                                            \
      }                                                                                                    \
    }                                                                                                      \
                                                                                                           \
    float3 lutColor;                                                                                       \
    if (                                                                                                   \
      lutParams.inputType == TONE_MAP_LUT_TYPE__SRGB                                                       \
      || lutParams.inputType == TONE_MAP_LUT_TYPE__2_4                                                     \
      || lutParams.inputType == TONE_MAP_LUT_TYPE__2_2                                                     \
      || lutParams.inputType == TONE_MAP_LUT_TYPE__2_0                                                     \
    ) {                                                                                                    \
      lutColor = sampleLUT(lutTexture, lutParams, sdrColor);                                               \
    } else {                                                                                               \
      lutColor = min(1.f, sampleLUT(lutTexture, lutParams, hdrColor));                                     \
    }                                                                                                      \
                                                                                                           \
    if (tmParams.type == 0.f) {                                                                            \
      outputColor = lerp(outputColor, lutColor, lutParams.strength);                                       \
    } else {                                                                                               \
      outputColor = toneMapUpgrade(hdrColor, sdrColor, lutColor, lutParams.strength);                      \
    }                                                                                                      \
    return outputColor;                                                                                    \
  }

toneMapFunctionGenerator(Texture2D<float4>);
toneMapFunctionGenerator(Texture2D<float3>);
toneMapFunctionGenerator(Texture3D<float4>);
toneMapFunctionGenerator(Texture3D<float3>);

// BT2446A method
// Input color should be SDR at 100 nits in BT.1886 (2.4)
float3 bt2446a_inverse_tonemapping(
  float3 color,
  float sdr_nits,
  float target_nits
) {
  const float3 k_bt2020 = float3(0.262698338956556, 0.678008765772817, 0.0592928952706273);
  const float k_bt2020_r_helper = 1.47460332208689;  // 2 - 2 * 0.262698338956556
  const float k_bt2020_b_helper = 1.88141420945875;  // 2 - 2 * 0.0592928952706273

  //gamma
  const float inverse_gamma = 2.4f;
  const float gamma = 1.f / inverse_gamma;

  //RGB->R'G'B' gamma compression
  color = pow(color, gamma);

  // Rec. ITU-R BT.2020-2 Table 4
  //Y'tmo
  const float y_tmo = dot(color, BT2020_2_XYZ_MAT[1].rgb);

  float luma = y_tmo;
  float3 bt2020Chromas = (2.f - 2.f * BT2020_2_XYZ_MAT[1].rgb);
  float3 sdrChromas = (color.rgb - luma) / bt2020Chromas.rgb;

  //C'b,tmo
  // const float c_b_tmo = (color.b - y_tmo) / k_bt2020_b_helper;
  //C'r,tmo
  // const float c_r_tmo = (color.r - y_tmo) / k_bt2020_r_helper;

  // adjusted luma component (inverse)
  // get Y'sdr
  const float y_sdr = y_tmo + max(0.1f * sdrChromas.r, 0.f);

  // Tone mapping step 3 (inverse)
  // get Y'c
  const float p_sdr = 1 + 32 * pow(sdr_nits / 10000.f, gamma);
  //Y'c
  const float y_c = log((y_sdr * (p_sdr - 1)) + 1) / log(p_sdr);  //log = ln

  // Tone mapping step 2 (inverse)
  // get Y'p
  float y_p = 0.f;

  const float y_p_0 = y_c / 1.0770f;
  const float y_p_2 = (y_c - 0.5000f) / 0.5000f;

  const float _first = -2.7811f;
  const float _sqrt = sqrt(4.83307641 - 4.604 * y_c);
  const float _div = -2.302f;
  const float y_p_1 = (_first + _sqrt) / _div;

  if (y_p_0 <= 0.7399f)
    y_p = y_p_0;
  else if (y_p_1 > 0.7399f && y_p_1 < 0.9909f)
    y_p = y_p_1;
  else if (y_p_2 >= 0.9909f)
    y_p = y_p_2;
  else  //y_p_1 sometimes (about 0.12% out of the full RGB range)
        //is less than 0.7399f or more than 0.9909f because of float inaccuracies
  {
    //error is small enough (less than 0.001) for this to be OK
    //ideally you would choose between y_p_0 and y_p_1 if y_p_1 < 0.7399f depending on which is closer to 0.7399f
    //or between y_p_1 and y_p_2 if y_p_1 > 0.9909f depending on which is closer to 0.9909f
    y_p = y_p_1;

    //this clamps it to 2 float steps above 0.7399f or 2 float steps below 0.9909f
    //if (y_p_1 < 0.7399f)
    //	y_p = 0.7399001f;
    //else
    //	y_p = 0.99089986f;
  }

  // Tone mapping step 1 (inverse)
  // get Y'
  const float p_hdr = 1 + 32 * pow(target_nits / 10000.f, gamma);
  //Y'
  const float y_ = (pow(p_hdr, y_p) - 1) / (p_hdr - 1);

  // Colour scaling function
  float col_scale = y_ > 0 ? y_sdr / (1.1f * y_) : 1.f;

  // Colour difference signals (inverse) and Luma (inverse)
  // get R'G'B'
  color = (bt2020Chromas * sdrChromas) / col_scale + y_;
  // color.b = ((c_b_tmo * k_bt2020_b_helper) / col_scale) + y_;
  // color.r = ((c_r_tmo * k_bt2020_r_helper) / col_scale) + y_;
  // color.g = (y_ - (k_bt2020.r * color.r + k_bt2020.b * color.b)) / k_bt2020.g;

  //safety
  // color.r = clamp(color.r, 0.f, 1.f);
  // color.g = clamp(color.g, 0.f, 1.f);
  // color.b = clamp(color.b, 0.f, 1.f);

  color = saturate(color);

  // R'G'B' gamma expansion
  color = pow(color, inverse_gamma);

  // map target luminance into 10000 nits
  color = color * target_nits;

  return color;
}

float3 bt2446a_inverse_tonemapping_bt709(float3 bt709, float sdr_nits, float target_nits) {
  float3 bt2020 = mul(BT709_2_BT2020_MAT, bt709);
  float3 newColor = bt2446a_inverse_tonemapping(bt2020, sdr_nits, target_nits);
  return mul(BT2020_2_BT709_MAT, newColor);
}

/**
 * Only useful for 100/1000 nits by using parametric function
 * Section 4 of BT2446
 * @link https://www.itu.int/dms_pub/itu-r/opb/rep/R-REP-BT.2446-1-2021-PDF-E.pdf
 */
float3 bt2446aFromBT2020GammaOptimized(float3 inputColor) {
  /**
   * Starting with an SDR 𝑅𝐺𝐵 signal encoded in the Recommendation ITU-R
   * BT.2020 colour space, conversion to HDR proceeds by first converting this
   * signal to 𝑌′𝐶𝑏′𝐶𝑟′, as specified in Table 4 of Recommendation ITU-R
   * BT.2020.
   */

  float luma = dot(inputColor, BT2020_2_XYZ_MAT[1].rgb);
  // float chromaBlue = (inputColor.b - luma) / 1.8814f;
  // float chromaRed = (inputColor.r - luma) / 1.4746f;

  float3 bt2020Chromas = (2.f - 2.f * BT2020_2_XYZ_MAT[1].rgb);
  float3 sdrChromas = (inputColor.rgb - luma) / bt2020Chromas.rgb;

  /**
   * Then, the (previously normalised) 𝑌′ channel is expanded, and the 𝐶𝑏′and
   * 𝐶𝑟′ channels are adjusted to match the visual perception of chromatic
   * content at different luminance levels.
   */

  // 𝑌′′
  float lumaAdjusted = 255.f * luma;

  const float T = 70.f;
  const float a1 = 1.8712e-5f;
  const float b1 = -2.7334e-3f;
  const float c1 = 1.3141f;
  const float a2 = 2.8305e-6f;
  const float b2 = -7.4622e-4f;
  const float c2 = 1.2528f;
  float E = (lumaAdjusted <= T)
            ? a1 * (lumaAdjusted * lumaAdjusted) + (b1 * lumaAdjusted) + c1
            : a2 * (lumaAdjusted * lumaAdjusted) + (b2 * lumaAdjusted) + c2;

  float lumaHDR = pow(lumaAdjusted, E);

  float chromaScalingFactor = luma > 0
                              ? 1.075f * (lumaHDR / luma)
                              : 1.f;

  float3 hdrChromas = sdrChromas * chromaScalingFactor;

  // float chromaBlueHDR = chromaBlue * chromaScalingFactor;
  // float chromaRedHDR = chromaRed * chromaScalingFactor;

  // float3 colorScaledHDR = float3(
  //   lumaHDR + (1.4746 * chromaRedHDR),
  //   lumaHDR - (0.16455f * chromaBlueHDR) - (0.57135f * chromaRedHDR),
  //   lumaHDR + (1.8814f * chromaBlueHDR)
  // );

  float3 colorScaledHDR = lumaHDR + (bt2020Chromas * hdrChromas);
  float3 normalizedHDR = colorScaledHDR / 1000.f;

  float3 clampedHDR = saturate(colorScaledHDR);
  float3 linearHDR = pow(normalizedHDR, 2.4f);
  float3 linearHDRInNits = linearHDR * 1000.f;
  return linearHDRInNits;
}

/**
 * Section 4 of BT2446
 * @link https://www.itu.int/dms_pub/itu-r/opb/rep/R-REP-BT.2446-1-2021-PDF-E.pdf
 */
float3 bt2446aFromBT709Linear(float3 bt709) {
  float3 bt2020 = mul(BT709_2_BT2020_MAT, bt709);
  float3 bt2020Gamma = pow(bt2020, 1.f / 2.4f);
  float3 newColor = bt2446aFromBT2020GammaOptimized(bt2020Gamma);
  float3 itmoColor = mul(BT2020_2_BT709_MAT, newColor);
  return itmoColor;
}

#endif  // SRC_SHADERS_TONEMAP_HLSL_
