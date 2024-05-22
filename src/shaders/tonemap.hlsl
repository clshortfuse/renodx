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

struct ToneMapLUTParams {
  SamplerState lutSampler;
  float strength;
  float scaling;
  uint inputType;
  uint outputType;
  float size;
  float3 precompute;
};

ToneMapLUTParams buildLUTParams(SamplerState lutSampler, float strength, float scaling, uint inputType, uint outputType, float size = 0) {
  ToneMapLUTParams params = {lutSampler, strength, scaling, inputType, outputType, size, float(0).xxx};
  return params;
}

ToneMapLUTParams buildLUTParams(SamplerState lutSampler, float strength, float scaling, uint inputType, uint outputType, float3 precompute) {
  ToneMapLUTParams params = {lutSampler, strength, scaling, inputType, outputType, 0, precompute};
  return params;
}

#define TONE_MAP_TYPE__VANILLA 0
#define TONE_MAP_TYPE__NONE    1
#define TONE_MAP_TYPE__ACES    2
#define TONE_MAP_TYPE__RENODRT 3

#define TONE_MAP_LUT_TYPE__LINEAR            0u
#define TONE_MAP_LUT_TYPE__SRGB              1u
#define TONE_MAP_LUT_TYPE__2_4               2u
#define TONE_MAP_LUT_TYPE__2_2               3u
#define TONE_MAP_LUT_TYPE__2_0               4u
#define TONE_MAP_LUT_TYPE__ARRI_C800         5u
#define TONE_MAP_LUT_TYPE__ARRI_C1000        6u
#define TONE_MAP_LUT_TYPE__ARRI_C800_NO_CUT  7u
#define TONE_MAP_LUT_TYPE__ARRI_C1000_NO_CUT 8u
#define TONE_MAP_LUT_TYPE__PQ                9u

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

float3 toneMapUpgrade(float3 hdrColor, float3 sdrColor, float3 lutColor, float lutStrength) {
  float scaledRatio = 1.f;

  float hdrY = yFromBT709(abs(hdrColor));
  float sdrY = yFromBT709(abs(sdrColor));
  float lutY = yFromBT709(abs(lutColor));

  if (hdrY < sdrY) {
    // If substracting (user contrast or paperwhite) scale down instead
    scaledRatio = hdrY / sdrY;
  } else {
    float deltaY = hdrY - sdrY;
    float newY = lutY + max(0, deltaY);  // deltaY may be NaN?

    scaledRatio = lutY > 0 ? (newY / lutY) : 0;
  }

  float3 scaledColor = lutColor * scaledRatio;
  scaledColor = hueCorrection(scaledColor, lutColor);
  return lerp(hdrColor, scaledColor, lutStrength);
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

#define sampleLUTColorFunctionGenerator(textureType)                                        \
  float3 sampleLUTColor(float3 color, ToneMapLUTParams lutParams, textureType lutTexture) { \
    if (lutParams.precompute.x) {                                                           \
      return sampleLUT(                                                                     \
        lutTexture,                                                                         \
        lutParams.lutSampler,                                                               \
        color.rgb,                                                                          \
        lutParams.precompute.xyz                                                            \
                                                                                            \
      );                                                                                    \
    }                                                                                       \
    return sampleLUT(                                                                       \
      lutTexture,                                                                           \
      lutParams.lutSampler,                                                                 \
      color.rgb,                                                                            \
      lutParams.size                                                                        \
    );                                                                                      \
  }

sampleLUTColorFunctionGenerator(Texture2D);
sampleLUTColorFunctionGenerator(Texture2D<float3>);
sampleLUTColorFunctionGenerator(Texture3D);
sampleLUTColorFunctionGenerator(Texture3D<float3>);

float3 convertLUTInput(float3 color, ToneMapLUTParams lutParams) {
  if (lutParams.inputType == TONE_MAP_LUT_TYPE__SRGB) {
    color = srgbFromLinear(saturate(color));
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__2_4) {
    color = pow(saturate(color), 1.f / 2.4f);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__2_2) {
    color = pow(saturate(color), 1.f / 2.2f);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__2_0) {
    color = sqrt(saturate(color));
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C800) {
    color = arriC800FromLinear(max(0, color));
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C1000) {
    color = arriC1000FromLinear(max(0, color));
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C800_NO_CUT) {
    color = arriC800FromLinear(max(0, color), 0);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C1000_NO_CUT) {
    color = arriC1000FromLinear(max(0, color), 0);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__PQ) {
    float3 rec2020 = bt2020FromBT709(color);
    color = pqFromLinear((rec2020 * 100.f) / 10000.f);
  }
  return color;
}

float3 restoreSaturationLoss(float3 inputColor, float3 outputColor, ToneMapLUTParams lutParams) {
  // Saturation (distance from grayscale)
  float yIn = yFromBT709(abs(inputColor));
  float3 satIn = inputColor - yIn;

  float3 clamped = inputColor;
  if (lutParams.inputType == TONE_MAP_LUT_TYPE__SRGB) {
    clamped = saturate(clamped);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__2_4) {
    clamped = saturate(clamped);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__2_2) {
    clamped = saturate(clamped);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__2_0) {
    clamped = saturate(clamped);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C800) {
    clamped = max(0, clamped);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C1000) {
    clamped = max(0, clamped);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C800_NO_CUT) {
    clamped = max(0, clamped);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C1000_NO_CUT) {
    clamped = max(0, clamped);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__PQ) {
    clamped = max(0, bt2020FromBT709(clamped));
  }

  float yClamped = yFromBT709(abs(yClamped));
  float3 satClamped = clamped - yIn;

  float yOut = yFromBT709(abs(outputColor));
  float3 satOut = outputColor - yOut;
  float3 newSat = float3(
    satOut.r * (satClamped.r ? (satIn.r / satClamped.r) : 1.f),
    satOut.g * (satClamped.g ? (satIn.g / satClamped.g) : 1.f),
    satOut.b * (satClamped.b ? (satIn.b / satClamped.b) : 1.f)
  );
  return (yOut + newSat);
}

float3 gammaLUTInput(float3 inputColor, float3 convertedInputColor, ToneMapLUTParams lutParams) {
  if (
    lutParams.inputType == TONE_MAP_LUT_TYPE__SRGB
    || lutParams.inputType == TONE_MAP_LUT_TYPE__2_4
    || lutParams.inputType == TONE_MAP_LUT_TYPE__2_2
    || lutParams.inputType == TONE_MAP_LUT_TYPE__2_0
  ) {
    return convertedInputColor;
  } else {
    return srgbFromLinear(max(0, inputColor));
  }
}

float3 gammaLUTOutput(float3 color, ToneMapLUTParams lutParams) {
  if (lutParams.outputType == TONE_MAP_LUT_TYPE__LINEAR) {
    color = srgbFromLinear(max(0, color));
  }
  return color;
}

float3 linearLUTOutput(float3 color, ToneMapLUTParams lutParams) {
  if (lutParams.outputType == TONE_MAP_LUT_TYPE__SRGB) {
    color = sign(color) * linearFromSRGB(abs(color));
  } else if (lutParams.outputType == TONE_MAP_LUT_TYPE__2_4) {
    color = sign(color) * pow(abs(color), 2.4f);
  } else if (lutParams.outputType == TONE_MAP_LUT_TYPE__2_2) {
    color = sign(color) * pow(abs(color), 2.2f);
  } else if (lutParams.outputType == TONE_MAP_LUT_TYPE__2_0) {
    color = sign(color) * color * color;
  }
  return color;
}

float3 linearUnclampedLUTOutput(float3 color, ToneMapLUTParams lutParams) {
  if (lutParams.outputType == TONE_MAP_LUT_TYPE__2_4) {
    color = sign(color) * pow(abs(color), 2.4f);
  } else if (lutParams.outputType == TONE_MAP_LUT_TYPE__2_2) {
    color = sign(color) * pow(abs(color), 2.2f);
  } else {
    color = sign(color) * linearFromSRGB(abs(color));
  }
  return color;
}

#define sampleLUTFunctionGenerator(textureType)                                                 \
  float3 sampleLUT(float3 inputColor, ToneMapLUTParams lutParams, textureType lutTexture) {     \
    float3 lutInputColor = convertLUTInput(inputColor, lutParams);                              \
    float3 lutOutputColor = sampleLUTColor(lutInputColor, lutParams, lutTexture);               \
    float3 outputColor = linearLUTOutput(lutOutputColor, lutParams);                            \
    if (lutParams.scaling) {                                                                    \
      float3 lutBlack = sampleLUTColor(convertLUTInput(0, lutParams), lutParams, lutTexture);   \
      float3 lutMid = sampleLUTColor(convertLUTInput(0.18f, lutParams), lutParams, lutTexture); \
      float3 lutWhite = sampleLUTColor(convertLUTInput(1.f, lutParams), lutParams, lutTexture); \
      float3 unclamped = unclampSDRLUT(                                                         \
        gammaLUTOutput(lutOutputColor, lutParams),                                              \
        gammaLUTOutput(lutBlack, lutParams),                                                    \
        gammaLUTOutput(lutMid, lutParams),                                                      \
        gammaLUTOutput(lutWhite, lutParams),                                                    \
        gammaLUTInput(inputColor, lutInputColor, lutParams)                                     \
      );                                                                                        \
      float3 recolored = recolorUnclampedLUT(                                                   \
        outputColor,                                                                            \
        linearUnclampedLUTOutput(unclamped, lutParams)                                          \
      );                                                                                        \
      outputColor = lerp(outputColor, recolored, lutParams.scaling);                            \
    }                                                                                           \
    outputColor = restoreSaturationLoss(inputColor, outputColor, lutParams);                    \
    return outputColor;                                                                         \
  }

sampleLUTFunctionGenerator(Texture2D<float4>);
sampleLUTFunctionGenerator(Texture2D<float3>);
sampleLUTFunctionGenerator(Texture3D<float4>);
sampleLUTFunctionGenerator(Texture3D<float3>);

#define toneMapFunctionGenerator(textureType)                                                                     \
  float3 toneMap(float3 inputColor, ToneMapParams tmParams, ToneMapLUTParams lutParams, textureType lutTexture) { \
    if (lutParams.strength == 0.f || tmParams.type == 1.f) {                                                      \
      return toneMap(inputColor, tmParams);                                                                       \
    }                                                                                                             \
    float3 outputColor = inputColor;                                                                              \
                                                                                                                  \
    float3 hdrColor;                                                                                              \
    float3 sdrColor;                                                                                              \
    if (tmParams.type == 3.f) {                                                                                   \
      tmParams.renoDRTSaturation *= tmParams.saturation;                                                          \
                                                                                                                  \
      sdrColor = renoDRTToneMap(outputColor, tmParams, true);                                                     \
                                                                                                                  \
      tmParams.renoDRTHighlights *= tmParams.highlights;                                                          \
      tmParams.renoDRTShadows *= tmParams.shadows;                                                                \
      tmParams.renoDRTContrast *= tmParams.contrast;                                                              \
                                                                                                                  \
      hdrColor = renoDRTToneMap(outputColor, tmParams);                                                           \
                                                                                                                  \
    } else {                                                                                                      \
      outputColor = applyUserColorGrading(                                                                        \
        outputColor,                                                                                              \
        tmParams.exposure,                                                                                        \
        tmParams.highlights,                                                                                      \
        tmParams.shadows,                                                                                         \
        tmParams.contrast,                                                                                        \
        tmParams.saturation                                                                                       \
      );                                                                                                          \
                                                                                                                  \
      if (tmParams.type == 2.f) {                                                                                 \
        hdrColor = acesToneMap(outputColor, tmParams);                                                            \
        sdrColor = acesToneMap(outputColor, tmParams, true);                                                      \
      } else {                                                                                                    \
        hdrColor = outputColor;                                                                                   \
        sdrColor = outputColor;                                                                                   \
      }                                                                                                           \
    }                                                                                                             \
                                                                                                                  \
    float3 lutColor;                                                                                              \
    if (                                                                                                          \
      lutParams.inputType == TONE_MAP_LUT_TYPE__SRGB                                                              \
      || lutParams.inputType == TONE_MAP_LUT_TYPE__2_4                                                            \
      || lutParams.inputType == TONE_MAP_LUT_TYPE__2_2                                                            \
      || lutParams.inputType == TONE_MAP_LUT_TYPE__2_0                                                            \
    ) {                                                                                                           \
      lutColor = sampleLUT(sdrColor, lutParams, lutTexture);                                                      \
    } else {                                                                                                      \
      lutColor = min(1.f, sampleLUT(hdrColor, lutParams, lutTexture));                                            \
    }                                                                                                             \
                                                                                                                  \
    if (tmParams.type == 0.f) {                                                                                   \
      outputColor = lerp(outputColor, lutColor, lutParams.strength);                                              \
    } else {                                                                                                      \
      outputColor = toneMapUpgrade(hdrColor, sdrColor, lutColor, lutParams.strength);                             \
    }                                                                                                             \
    return outputColor;                                                                                           \
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
  const float y_tmo = dot(color, k_bt2020);
  //C'b,tmo
  const float c_b_tmo = (color.b - y_tmo) / k_bt2020_b_helper;
  //C'r,tmo
  const float c_r_tmo = (color.r - y_tmo) / k_bt2020_r_helper;

  // fast path as per Rep. ITU-R BT.2446-1 Table 4
  // matches the output of the inversed version for the given input
  if ((sdr_nits > 99.f && sdr_nits < 101.f) && (target_nits > 999.f && target_nits < 1001.f))
  //avoid float issues
  {
    sdr_nits = 100.f;
    target_nits = 1000.f;

    const float a1 = 1.8712e-5;
    const float b1 = -2.7334e-3;
    const float c1 = 1.3141;
    const float a2 = 2.8305e-6;
    const float b2 = -7.4622e-4;
    const float c2 = 1.2328;

    const float yy_ = 255.0f * y_tmo;

    const float t = 70;

    float e = yy_ <= t ? a1 * pow(yy_, 2.f) + b1 * yy_ + c1 : a2 * pow(yy_, 2.f) + b2 * yy_ + c2;

    const float y_hdr = pow(yy_, e);

    float s_c = y_tmo > 0.f ? 1.075f * (y_hdr / y_tmo) : 1.f;

    const float c_b_hdr = c_b_tmo * s_c;
    const float c_r_hdr = c_r_tmo * s_c;

    color = float3(
      clamp(y_hdr + k_bt2020_r_helper * c_r_hdr, 0.f, 1000.f),
      clamp(y_hdr - 0.16455312684366 * c_b_hdr - 0.57135312684366 * c_r_hdr, 0.f, 1000.f),
      clamp(y_hdr + k_bt2020_b_helper * c_b_hdr, 0.f, 1000.f)
    );
    color /= 1000.f;
  } else {
    // adjusted luma component (inverse)
    // get Y'sdr
    const float y_sdr = y_tmo + max(0.1f * c_r_tmo, 0.f);

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
    float col_scale = 0.f;
    if (y_ > 0.f)  // avoid divison by zero
      col_scale = y_sdr / (1.1f * y_);

    // Colour difference signals (inverse) and Luma (inverse)
    // get R'G'B'
    color.b = ((c_b_tmo * k_bt2020_b_helper) / col_scale) + y_;
    color.r = ((c_r_tmo * k_bt2020_r_helper) / col_scale) + y_;
    color.g = (y_ - (k_bt2020.r * color.r + k_bt2020.b * color.b)) / k_bt2020.g;

    //safety
    color.r = clamp(color.r, 0.f, 1.f);
    color.g = clamp(color.g, 0.f, 1.f);
    color.b = clamp(color.b, 0.f, 1.f);
  }

  // R'G'B' gamma expansion
  color = pow(color, inverse_gamma);

  // map target luminance into 10000 nits
  color = color * target_nits;

  return color;
}

float3 bt2446a_inverse_tonemapping_bt709(float3 bt709, float sdr_nits, float target_nits) {
  float3 bt2020 = mul(BT709_2_BT2020_MAT, bt709);
  float3 newColor = bt2446a_inverse_tonemapping(bt2020, sdr_nits, target_nits);
  return newColor;
}
