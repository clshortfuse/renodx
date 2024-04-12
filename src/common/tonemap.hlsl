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

const float uncharted2Tonemap_W = 11.2;  // Linear White

float3 uncharted2Tonemap(float x) {
  float A = 0.22;  // Shoulder Strength
  float B = 0.30;  // Linear Strength
  float C = 0.10;  // Linear Angle
  float D = 0.20;  // Toe Strength
  float E = 0.01;  // Toe Numerator
  float F = 0.30;  // Toe Denominator

  return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
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
  float vanillaMidGray;
  float renoDRTContrast;
  float renoDRTShadow;
  float renoDRTDechroma;
  float renoDRTSaturation;
  float renoDRTHighlights;
};

struct ToneMapLUTParams {
  Texture2D lutTexture;
  SamplerState lutSampler;
  float strength;
  float scaling;
  uint inputType;
  uint outputType;
  float size;
  float3 precompute;
};

#define TONE_MAP_TYPE__VANILLA 0
#define TONE_MAP_TYPE__NONE    1
#define TONE_MAP_TYPE__ACES    2
#define TONE_MAP_TYPE__RENODRT 3

#define TONE_MAP_LUT_TYPE__LINEAR            0u
#define TONE_MAP_LUT_TYPE__SRGB              1u
#define TONE_MAP_LUT_TYPE__2_2               2u
#define TONE_MAP_LUT_TYPE__ARRI_C800         3u
#define TONE_MAP_LUT_TYPE__ARRI_C1000        4u
#define TONE_MAP_LUT_TYPE__ARRI_C800_NO_CUT  5u
#define TONE_MAP_LUT_TYPE__ARRI_C1000_NO_CUT 6u

float3 renoDRTToneMap(float3 color, ToneMapParams params, bool sdr = false) {
  float renoDRTMax = sdr ? 100.f : params.peakNits / params.gameNits;
  if (!sdr && params.gammaCorrection) {
    renoDRTMax = gammaCorrectEmulate22(renoDRTMax, true);
  }

  return renodrt(
    color,
    renoDRTMax * 100.f,
    0.18f,
    params.vanillaMidGray * 100.f,
    params.renoDRTContrast,
    params.renoDRTShadow,
    params.renoDRTDechroma,
    params.renoDRTSaturation,
    params.renoDRTHighlights
  );
}

float3 acesToneMap(float3 color, ToneMapParams params, bool sdr = false) {
  const float ACES_MID_GRAY = 0.10f;
  float paperWhite = (sdr ? 100.f : params.gameNits) * (params.vanillaMidGray / ACES_MID_GRAY);

  float acesScaling = paperWhite / 48.f;
  float acesMin = 0.0001f / acesScaling;
  float acesMax = params.peakNits / paperWhite;

  if (!sdr && params.gammaCorrection) {
    float scaling = params.gammaCorrection;
    acesMax = gammaCorrectEmulate22(acesMax, true);
    acesMin = gammaCorrectEmulate22(acesMin, true);
  }

  color = aces_rgc_rrt_odt(
    color,
    acesMin,
    acesMax * 48.f
  );
  color *= (params.vanillaMidGray / ACES_MID_GRAY) / 48.f;
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
  return lerp(hdrColor, scaledColor, lutStrength);
}

float3 toneMap(float3 untonemapped, ToneMapParams params) {
  float3 outputColor = untonemapped;

  outputColor = applyUserColorGrading(
    outputColor,
    params.exposure,
    params.saturation,
    params.shadows,
    params.highlights,
    params.contrast
  );
  if (params.type == 2.f) {
    outputColor = acesToneMap(outputColor, params);
  } else if (params.type == 3.f) {
    outputColor = renoDRTToneMap(outputColor, params);
  }
  return outputColor;
}

float3 sampleLUTColor(float3 color, ToneMapLUTParams lutParams) {
  if (lutParams.precompute.x) {
    return sampleLUT(
      lutParams.lutTexture,
      lutParams.lutSampler,
      color,
      lutParams.precompute
    );
  }
  return sampleLUT(
    lutParams.lutTexture,
    lutParams.lutSampler,
    color,
    lutParams.size
  );
}

float3 convertLUTInput(float3 color, ToneMapLUTParams lutParams) {
  if (lutParams.inputType == TONE_MAP_LUT_TYPE__SRGB) {
    color = srgbFromLinear(saturate(color));
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__2_2) {
    color = pow(saturate(color), 1.f / 2.2f);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C800) {
    color = arriC800FromLinear(color);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C1000) {
    color = arriC1000FromLinear(color);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C800_NO_CUT) {
    color = arriC800FromLinear(color, 0);
  } else if (lutParams.inputType == TONE_MAP_LUT_TYPE__ARRI_C1000_NO_CUT) {
    color = arriC1000FromLinear(color, 0);
  }
  return color;
}

float3 gammaLUTInput(float3 inputColor, float3 convertedInputColor, ToneMapLUTParams lutParams) {
  if (lutParams.inputType == TONE_MAP_LUT_TYPE__SRGB || lutParams.inputType == TONE_MAP_LUT_TYPE__2_2) {
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
  } else if (lutParams.outputType == TONE_MAP_LUT_TYPE__2_2) {
    color = sign(color) * pow(abs(color), 2.2f);
  }
  return color;
}

float3 linearUnclampedLUTOutput(float3 color, ToneMapLUTParams lutParams) {
  if (lutParams.outputType == TONE_MAP_LUT_TYPE__2_2) {
    color = sign(color) * pow(abs(color), 2.2f);
  } else {
    color = sign(color) * linearFromSRGB(abs(color));
  }
  return color;
}

float3 sampleLUT(float3 inputColor, ToneMapLUTParams lutParams) {
  float3 lutInputColor = convertLUTInput(inputColor, lutParams);
  float3 lutOutputColor = sampleLUTColor(lutInputColor, lutParams);
  float3 outputColor = linearLUTOutput(lutOutputColor, lutParams);
  if (lutParams.scaling) {
    float3 lutBlack = sampleLUTColor(convertLUTInput(0, lutParams), lutParams);
    float3 lutWhite = sampleLUTColor(convertLUTInput(1.f, lutParams), lutParams);
    float3 lutMid = sampleLUTColor(convertLUTInput(0.18f, lutParams), lutParams);

    float3 unclamped = unclampSDRLUT(
      gammaLUTOutput(lutOutputColor, lutParams),
      gammaLUTOutput(lutBlack, lutParams),
      gammaLUTOutput(lutWhite, lutParams),
      gammaLUTOutput(lutMid, lutParams),
      gammaLUTInput(inputColor, lutInputColor, lutParams)
    );

    float3 recolored = recolorUnclampedLUT(
      outputColor,
      linearUnclampedLUTOutput(unclamped, lutParams)
    );
    outputColor = lerp(outputColor, recolored, lutParams.scaling);
  }
  return outputColor;
}

float3 toneMap(float3 inputColor, ToneMapParams tmParams, ToneMapLUTParams lutParams) {
  if (lutParams.strength == 0.f || tmParams.type == 1.f) {
    return toneMap(inputColor, tmParams);
  }

  float3 outputColor = inputColor;

  outputColor = applyUserColorGrading(
    outputColor,
    tmParams.exposure,
    1.f,
    tmParams.shadows,
    tmParams.highlights,
    tmParams.contrast
  );
  float3 hdrColor = outputColor;
  float3 sdrColor = outputColor;
  if (tmParams.type == 2.f) {
    hdrColor = acesToneMap(outputColor, tmParams);
    sdrColor = acesToneMap(outputColor, tmParams, true);
  } else if (tmParams.type == 3.f) {
    hdrColor = renoDRTToneMap(outputColor, tmParams);
    sdrColor = renoDRTToneMap(outputColor, tmParams, true);
  }

  float3 lutColor;
  if (lutParams.inputType == TONE_MAP_LUT_TYPE__SRGB || lutParams.inputType == TONE_MAP_LUT_TYPE__2_2) {
    lutColor = sampleLUT(sdrColor, lutParams);
  } else {
    lutColor = min(1.f, sampleLUT(outputColor, lutParams));
  }

  if (tmParams.type == 0.f) {
    outputColor = lerp(outputColor, lutColor, lutParams.strength);
  } else {
    outputColor = toneMapUpgrade(hdrColor, sdrColor, lutColor, lutParams.strength);
  }
  if (tmParams.saturation != 1.f) {
    outputColor = applySaturation(outputColor, tmParams.saturation);
  }
  return outputColor;
}
