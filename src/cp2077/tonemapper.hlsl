// LUT + TONEMAPPER

#include "../common/DICE.hlsl"
#include "../common/Open_DRT.hlsl"
#include "../common/aces.hlsl"
#include "../common/color.hlsl"
#include "./cp2077.h"
#include "./injectedBuffer.hlsl"

// clang-format off
static const float HEATMAP_COLORS[27] = {
  0.0f, 0.0f, 0.0f,  // Black
  0.0f, 0.0f, 1.0f,  // Blue
  0.0f, 1.0f, 1.0f,  // Cyan
  0.0f, 1.0f, 0.0f,  // Green
  1.0f, 1.0f, 0.0f,  // Yellow
  1.0f, 0.0f, 0.0f,  // Red
  1.0f, 0.0f, 1.0f,  // Magenta
  1.0f, 1.0f, 1.0f,  // White
  1.0f, 1.0f, 1.0f,   // White
};
// clang-format on

static const float SQRT_HALF = sqrt(1.f / 2.f);   // 0.7071067811865476
static const float SQRT_THIRD = sqrt(1.f / 3.f);  // 0.5773502691896257

// 32x32bit
struct SColorGrading {
  float4 const00;  // cb6[0u].xyzw
  float4 const01;  // cb6[1u].xyzw
  float4 const02;  // cb6[2u].xyzw
  float3 const03;  // cb6[3u].xyz
  float const04;   // cb6[3u].w
  float3 const05;  // cb6[4u].xyz
  float const06;   // cb6[4u].w
  float3 const07;  // cb6[5u].xyz
  float const08;   // cb6[5u].w
  float3 const09;  // cb6[6u].xyz
  float const10;   // cb6[6u].w
  float const11;   // cb6[7u].x
  float const12;   // cb6[7u].y
  float const13;   // cb6[7u].z
  float const14;   // cb6[7u].w
};

// 82x32bit
struct STonemappingACES {
  float4 const00[10];  // cb6[8u].xyzw  cb6[9u].xyzw cb6[10u].xyzw cb6[11u].xyzw cb6[12u].xyzw cb6[13u].xyzw cb6[14u].xyzw cb6[15u].xyzw cb6[16u].xyzw cb6[17u].xyzw
  float2 const01;      // cb6[18u].xy
  float2 const02;      // cb6[18u].zw
  float2 const03;      // cb6[19u].xy
  float2 const04;      // cb6[19u].zw
  float2 const05;      // cb6[20u].xy
  float2 const06;      // cb6[20u].zw
  float3 const07[3];   // cb6[21u].xyz (cb6[21u].w cb6[22u].xy) (cb6[22u].zw cb6[23u].x)
  float3 const08[3];   // cb6[23u].yzw (cb6[24u].x cb6[24u].yz) (cb6[24u].w  cb6[25u].xy)
  float2 const09;      // cb6[25u].zw
  float const10;       // cb6[26u].x
  float const11;       // cb6[26u].y
  float const12;       // cb6[26u].z
  float const13;       // cb6[26u].w
  float const14;       // cb6[27u].x
  float const15;       // cb6[27u].y
  float const16;       // cb6[27u].z
  float3 const17;      // (cb6[27u].w + cb6[28u].xy)
};

// 12x32bit
struct LottesTonemapperParams {
  float const00;   // cb6[28u].z
  float const01;   // cb6[28u].w
  float const02;   // cb6[29u].x
  float const03;   // cb6[29u].y
  float3 const04;  // (cb6[29u].zw cb6[30u].x)
  float const05;   // cb6[30u].y
  float3 const06;  // cb6[30u].y
  float const07;
};

// 4x32bit
struct InputLutSettings {
  float inputScale;
  float inputFloor;
  float outputScale;
  uint lutType;
};

// 32 + 82 + 12 + (8*4) + 7
struct COM {
  SColorGrading sColorGrading;
  STonemappingACES sTonemappingACES;
  LottesTonemapperParams lottesTonemapperParams;
  InputLutSettings inputLutSettings[8];
  int const00;
  int const01;
  float const02;
  float const03;
  int const04;
  int const05;
  float const06;
};

struct UnknownType {
  float4 const00;
  float4 const01;
  float4 const02;
  float4 const03;
  float4 const04;
  float4 const05;
  float4 const06;
  float4 const07;
  float4 const08;
  float4 const09;
  float4 const10;
  float4 const11;
  float4 const12;
  float4 const13;
  float4 const14;
  float4 const15;
  float4 const16;
  float4 const17;
  float4 const18;
  float4 const19;
  float4 const20;
  float4 const21;
  float4 const22;
  float4 const23;
  float4 const24;
  float4 const25;
  float4 const26;
  float4 const27;
  float4 const28;
  float4 const29;
  float4 const30;
  float4 const31;
  float4 const32;
  // float4 const33;
  float const33x;  // cb6[33u].x 0.77226562
  float
    const33y;  // cb6[33u].y 0.01245117 (100) 0.00622558 (200) 0.00498046 (250) 0.004150039 (300) 0.00311279 (400)  0.00249023 (500)
  float4 const34;
  float4 const35;
  float4 const36;
  float4 const37;
  float4 const38;
  float4 const39;
  float4 const40;
  // float4 const41;
  uint textureCount;
  uint const41y;
  uint const41z;
  uint const41w;
  float4 const42;
};

cbuffer _18_20 : register(b6, space0) {
  float4 cb6[43] : packoffset(c0);
}

Texture3D<float4> LUT_TEXTURES[8] : register(t0, space0);
RWTexture3D<float4> OUTPUT_TEXTURE : register(u0, space0);
SamplerState SAMPLER : register(s0, space0);

static uint3 gl_GlobalInvocationID;

struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

float3 sampleLUT(float4 lutSettings, const float3 inputColor, uint textureIndex) {
  float3 color = inputColor;
  if (lutSettings.x > 0.0f) {           // LUT Strength
    uint _503 = asuint(lutSettings.w);  // lut Type
    uint _504 = _503 & 15u;

    float scale = 1.f;

    if (_504 < 2u) {
      // Gamut Compression?
      float maxChannel = max(max(max(color.r, color.g), color.b), 9.9999999747524270787835121154785e-07f);
      scale = ((abs(1.0f - maxChannel) < 0.52499997615814208984375f)
                 ? ((((5.809524059295654296875f - (maxChannel * 1.9047620296478271484375f)) * maxChannel) + (-0.42976200580596923828125f)) * 0.25f)
                 : clamp(maxChannel, 0.0f, 1.0f))
            / maxChannel;
      color *= scale;
    }

    if (_504 == 2u) {
      color = arriC800FromLinear(color);
    } else if (_504 == 1u) {
      color = srgbFromLinear(color);
    }

    float lutScale = lutSettings.x;
    float lutOffset = lutSettings.y;
    float3 coordinates = lutScale * color + lutOffset;

    color = LUT_TEXTURES[textureIndex].SampleLevel(SAMPLER, coordinates, 0.0f).rgb;

    if ((_503 & 240u) == 16u) {
      color = linearFromSRGB(color);
    }

    color /= scale;

    if (injectedData.colorGradingCorrection) {
      float3 peakWhite = LUT_TEXTURES[textureIndex].SampleLevel(SAMPLER, float(1.f).xxx, 0.0f).rgb;
      if ((_503 & 240u) == 16u) {
        peakWhite = linearFromSRGB(color);
      }

      const float lutPeakY = yFromBT709(peakWhite);
      const float targetPeakY = 100.f;

      // Only applies on LUTs that are clamped (all?)
      if (lutPeakY < targetPeakY) {
        // Inverse tonemap from clamped to peak.
        const float inputY = yFromBT709(inputColor);
        const float colorY = yFromBT709(color);
        const float a = lutPeakY / targetPeakY;  // fixed per LUT 0.19f
        const float b = lerp(1.f, 0.f, injectedData.colorGradingCorrection);
        const float g = inputY;
        const float h = colorY;
        const float newY = h * pow((1.f / a), pow(g / targetPeakY, b / a));
        // Only scale up, never down
        color *= (colorY > 0) ? max(colorY, newY) / colorY : 1.f;
      }
    }
  }
  if (injectedData.colorGradingScaling == 1.f) {
    color *= lutSettings.z;  // output scale
  }
  return color;
}

float3 sampleAllLUTs(const float3 color) {
  uint textureCount = asuint(cb6[41u]).x;

  float3 compositedColor;

  if (injectedData.colorGradingStrength) {  // 0 speed-hack
    compositedColor = lerp(color, sampleLUT(cb6[33u], color, 0u), injectedData.colorGradingStrength);
  } else {
    compositedColor = color;
  }

  if (injectedData.colorGradingSaturation != 1.f) {
    float grayscale = yFromBT709(compositedColor);
    compositedColor = lerp(grayscale, compositedColor, injectedData.colorGradingSaturation);
  }

  // This was probably a for loop (0-7)
  if (textureCount > 1u) {
    compositedColor += sampleLUT(cb6[34u], color, 1u);
  }
  if (textureCount > 2u) {
    compositedColor += sampleLUT(cb6[35u], color, 2u);
  }
  if (textureCount > 3u) {
    compositedColor += sampleLUT(cb6[36u], color, 3u);
  }
  if (textureCount > 4u) {
    compositedColor += sampleLUT(cb6[37u], color, 4u);
  }
  if (textureCount > 5u) {
    compositedColor += sampleLUT(cb6[38u], color, 5u);
  }
  if (textureCount > 6u) {
    compositedColor += sampleLUT(cb6[39u], color, 6u);
  }
  if (textureCount > 7u) {
    compositedColor += sampleLUT(cb6[40u], color, 7u);
  }

  return compositedColor;
}

// [41u].w = 0.59960937f
// cb6[41u].z = 0.06020507f
// _73 = 47.f;
// cb6[41u].y
// 69.y (gameplay 48) / (photo mode 24)

float3 applyGamma(float3 input, uint type) {
  if (type == 2u)
    return arriC800FromLinear(input);
  if (type == 1u)
    return srgbFromLinear(input);
  return input;
}

float4 tonemap(bool isHDR = false) {
  uint4 _69 = asuint(cb6[41u]);
  uint lutSize = _69.y;

  float maxLutSize = float(_69.y + 4294967295u);  // lutSize - 1u

  const float3 position = float3(gl_GlobalInvocationID.xyz) / (float(lutSize) - 1.f);
  float3 inputColor;
  if (injectedData.colorGradingScaling == 2.f) {
    float3 rec2020Color = linearFromPQ(position) * 10000.f / 100.f;
    inputColor = max(0, bt709FromBT2020(rec2020Color));
  } else {
    inputColor = exp2((position - cb6[41u].w) / cb6[41u].z);
  }

  float3 outputRGB = inputColor;

  float3 color = inputColor;
  float fogRangeMin = cb6[5u].w;  // 0.0001
  float fogRangeMax = cb6[6u].w;  // 0.0045

  float _99 = 1.0f - cb6[6u].w;

  float3 colorAdjust1 = cb6[5u].rgb;  // 0 0 0

  float _118 = color.r - fogRangeMin;
  float _119 = color.g - fogRangeMin;
  float _120 = color.b - fogRangeMin;
  float _136 = color.r - fogRangeMax;
  float _137 = color.g - fogRangeMax;
  float _138 = color.b - fogRangeMax;

  float _194 = ((((_118 * (cb6[5u].r + 1.0f)) + fogRangeMin) * float((color.r >= fogRangeMin) && (color.r <= fogRangeMax)))
                + ((float(color.r < fogRangeMin) * fogRangeMin) * (((1.0f - cb6[4u].x) * (color.r / fogRangeMin)) + cb6[4u].r)))
             + (((_136 * (cb6[6u].r + 1.0f)) + fogRangeMax) * float(color.r > fogRangeMax));
  float _195 = ((((_119 * (cb6[5u].g + 1.0f)) + fogRangeMin) * float((color.g >= fogRangeMin) && (color.g <= fogRangeMax))) + ((float(color.g < fogRangeMin) * fogRangeMin) * (((1.0f - cb6[4u].y) * (color.g / fogRangeMin)) + cb6[4u].y))) + (((_137 * (cb6[6u].y + 1.0f)) + fogRangeMax) * float(color.g > fogRangeMax));
  float _196 = ((((_120 * (cb6[5u].b + 1.0f)) + fogRangeMin) * float((color.b >= fogRangeMin) && (color.b <= fogRangeMax))) + ((float(color.b < fogRangeMin) * fogRangeMin) * (((1.0f - cb6[4u].z) * (color.b / fogRangeMin)) + cb6[4u].z))) + (((_138 * (cb6[6u].z + 1.0f)) + fogRangeMax) * float(color.b > fogRangeMax));

  color = float3(_194, _195, _196);  // outside | inside
  float3 fillWhite = cb6[0u].rgb;    // 0,0,0   | 0.00, 0.00, 0.00
  float3 sceneGamma = cb6[1u].rgb;   // 1,1,1   | 1.00, 1.15, 1.05
  float3 sceneGain = cb6[2u].rgb;    // 1,1,1   | 1.00, 1.18, 1.00
  float3 sceneLift = cb6[3u].rgb;    // 0,0,0   | 0.00, 0.00, 0.00
  float blackFloor = cb6[4u].w;      // 0       | 0.112
  float brightness = cb6[7u].x;      // 1       | 1.000

  float3 adjustedColor = inputColor;
  if (injectedData.colorGradingScene) {
    adjustedColor = lerp(adjustedColor, 1.f, fillWhite);
    adjustedColor *= sceneGain;
    adjustedColor += sceneLift;
    if (sceneGamma.r != 1.f || sceneGamma.g != 1.f || sceneGamma.b != 1.f) {
      adjustedColor = pow(max(0, adjustedColor), sceneGamma);
    }
    adjustedColor = lerp(blackFloor, adjustedColor, brightness);
    adjustedColor = lerp(inputColor, adjustedColor, injectedData.colorGradingScene);
  }

  float _256 = adjustedColor.r;
  float _257 = adjustedColor.g;
  float _258 = adjustedColor.b;

  const float hueShift = cb6[7u].z;
  // Add branch to skip if not hue shifting
  if (hueShift) {
    float _260 = sin(hueShift);  // sin(0)
    float _261 = cos(hueShift);  // cos(0)
    float _262 = (-0.0f) - _260;
    float _264 = _260 * 0.8164966106414794921875f;
    float _266 = _261 * (-0.40824830532073974609375f);
    float _268 = mad(SQRT_HALF, _262, _266);
    float _270 = _260 * (-0.40824830532073974609375f);
    float _271 = mad(SQRT_HALF, _261, _270);
    float _272 = mad(-SQRT_HALF, _262, _266);
    float _274 = mad(-SQRT_HALF, _261, _270);
    float _279 = mad(0.5352036952972412109375f, SQRT_THIRD, mad(_264, -0.3726499974727630615234375f, _261 * 0.69100105762481689453125f));
    float _282 = _261 * (-0.3089949786663055419921875f);
    float _286 = mad(0.5352036952972412109375f, SQRT_THIRD, mad(_264, 0.3344599902629852294921875f, _282));
    float _289 = mad(0.5352036952972412109375f, SQRT_THIRD, mad(_264, -1.07974994182586669921875f, _282));
    float _293 = mad(1.05481898784637451171875f, SQRT_THIRD, mad(_271, -0.3726499974727630615234375f, _268 * 0.84630000591278076171875f));
    float _295 = _268 * (-0.3784399926662445068359375f);
    float _298 = mad(1.05481898784637451171875f, SQRT_THIRD, mad(_271, 0.3344599902629852294921875f, _295));
    float _300 = mad(1.05481898784637451171875f, SQRT_THIRD, mad(_271, -1.07974994182586669921875f, _295));
    float _303 = mad(0.1420280933380126953125f, SQRT_THIRD, mad(_274, -0.3726499974727630615234375f, _272 * 0.84630000591278076171875f));
    float _305 = _272 * (-0.3784399926662445068359375f);
    float _307 = mad(0.1420280933380126953125f, SQRT_THIRD, mad(_274, 0.3344599902629852294921875f, _305));
    float _309 = mad(0.1420280933380126953125f, SQRT_THIRD, mad(_274, -1.07974994182586669921875f, _305));

    float bt601Strength = cb6[7u].y;  // 1
    float inverseBt601Strength = 1.0f - bt601Strength;

    float _311 = 1.0f - cb6[7u].y;

    float _312 = _311 * 0.2989999949932098388671875f;
    float _314 = _312 + cb6[7u].y;

    float _315 = _311 * 0.58700001239776611328125f;
    float _317 = _315 + cb6[7u].y;
    float _318 = _311 * 0.114000000059604644775390625f;
    float _320 = _318 + cb6[7u].y;

    // _314 = lerp(cb6[7u].y, 1.f, 0.299f)
    // _317 = lerp(cb6[7u].y, 1.f, 0.587f)
    // _320 = lerp(cb6[7u].y, 1.f, 0.114f)

    float _324 = _312 * _279;
    float _332 = _312 * _293;
    float _340 = _312 * _303;

    float _355 = cb6[3u].w + mad(_258, mad(_309, _318, mad(_307, _315, _314 * _303)), mad(_257, mad(_300, _318, mad(_298, _315, _314 * _293)), mad(_289, _318, mad(_286, _315, _314 * _279)) * _256));
    float _356 = cb6[3u].w + mad(_258, mad(_309, _318, mad(_307, _317, _340)), mad(_257, mad(_300, _318, mad(_298, _317, _332)), mad(_289, _318, mad(_286, _317, _324)) * _256));
    float _357 = cb6[3u].w + mad(_258, mad(_309, _320, mad(_307, _315, _340)), mad(_257, mad(_300, _320, mad(_298, _315, _332)), mad(_289, _320, mad(_286, _315, _324)) * _256));
    outputRGB = float3(_355, _356, _357);
  } else {
    outputRGB = adjustedColor;
  }

  // outputRGB = lerp(inputColor, outputRGB, injectedData.debugValue03);

  if ((injectedData.colorGradingWorkflow == -1.f || asuint(cb6[42u]).y == 1u) && (_69.x != 0u)) {
    outputRGB = sampleAllLUTs(outputRGB);
  }

  float minNits = cb6[27u].x;  // 0.005
  const float exposure = cb6[42u].z;
  float peakNits = cb6[27u].y;           // User peak Nits
  const float midGrayNits = cb6[18u].w;  // Usually 10.0
  float3 odtFinal = outputRGB;
  float toneMapperType = injectedData.toneMapperType;

  if (toneMapperType == TONE_MAPPER_TYPE__NONE) {
    // No-op
  } else if (!isHDR) {
    // This branch should be optimized away by compiler
    outputRGB *= exposure;
  } else if (toneMapperType == TONE_MAPPER_TYPE__VANILLA) {
    outputRGB *= exposure;  // Exposure

    float3 outputXYZ = mul(BT709_2_XYZ_MAT, outputRGB);
    float3 outputXYZD60 = mul(D65_2_D60_CAT, outputXYZ);
    float3 aces = mul(XYZ_2_AP0_MAT, outputXYZD60);

    float3 rgbPost = aces_rrt_ap0(aces);

    // --- RGB rendering space to OCES --- //
    // CDPR converted AP1 to AP0 and back

    // cb6[18u].x 0.000085
    // cb6[18u].y 0.004944
    // cb6[18u].z 2.387695
    // cb6[18u].w 9.956054
    // cb6[19u].x 1092.500
    // cb6[19u].y 298.7500
    // cb6[19u].z 0.000000
    // cb6[19u].w 0.059738

    // Scales with paperwhite, which can be reversed

    const SegmentedSplineParams_c9 ODT_CONFIG = {
      {cb6[8u].x, cb6[9u].x, cb6[10u].x, cb6[11u].x, cb6[12u].x, cb6[13u].x, cb6[14u].x, cb6[15u].x, cb6[16u].x, cb6[17u].x}, // coefsLow[10]
      {cb6[8u].y, cb6[9u].y, cb6[10u].y, cb6[11u].y, cb6[12u].y, cb6[13u].y, cb6[14u].y, cb6[15u].y, cb6[16u].y, cb6[17u].y}, // coefsHigh[10]
      {cb6[18u].x, cb6[18u].y}, // minPoint
      {cb6[18u].z, midGrayNits}, // midPoint
      {cb6[19u].x, cb6[19u].y}, // maxPoint - doesn't always match peak nits?
      cb6[19u].z, // slopeLow
      cb6[19u].w  // slopeHigh
    };

    float yRange = peakNits - minNits;

    float3 toneMappedColor = float3(
      segmented_spline_c9_fwd(rgbPost.r, ODT_CONFIG),
      segmented_spline_c9_fwd(rgbPost.g, ODT_CONFIG),
      segmented_spline_c9_fwd(rgbPost.b, ODT_CONFIG)
    );

    // Tone map by luminance
    if (cb6[28u].w != 0.0f) {
      float ap1Y = dot(rgbPost, AP1_RGB2Y);
      float toneMappedByLuminance = segmented_spline_c9_fwd(ap1Y, ODT_CONFIG);
      float scaleFactor = toneMappedByLuminance / ap1Y;
      float3 scaledAndToneMapped = (rgbPost * scaleFactor);
      toneMappedColor = (cb6[29u].x * (scaledAndToneMapped - toneMappedColor)) + toneMappedColor;
    }

    toneMappedColor = max(toneMappedColor, minNits);

    float3 linearCV = Y_2_linCV(toneMappedColor, peakNits, minNits);

    // dimSurround
    if (cb6[28u].y != 0.0f) {
      float3 odtXYZ = mul(AP1_2_XYZ_MAT, linearCV);
      odtXYZ = darkToDim(odtXYZ, cb6[27u].w);
      linearCV = mul(XYZ_2_AP1_MAT, odtXYZ);
    }

    // Apply desaturation to compensate for luminance difference
    if (cb6[28u].x != 0.0f) {
      linearCV = mul(ODT_SAT_MAT, linearCV);
    }

    float3 odtXYZ = mul(AP1_2_XYZ_MAT, linearCV);

    if (injectedData.toneMapperWhitePoint == 1.f || (injectedData.toneMapperWhitePoint == 0.f && cb6[28u].z != 0.0f)) {
      odtXYZ = mul(D60_2_D65_CAT, odtXYZ);
    }

    // clang-format off
    // XYZ_2_BT709_MAT
    float3x3 customMatrix0 = float3x3(
      cb6[21u].x, cb6[21u].y, cb6[21u].z,
      cb6[22u].x, cb6[22u].y, cb6[22u].z,
      cb6[23u].x, cb6[23u].y, cb6[23u].z
    );
    // clang-format on

    float3 odtUnknown = mul(customMatrix0, odtXYZ);
    if (cb6[27u].z == 0.0f || cb6[27u].z == 1.f) {
      odtUnknown = saturate(odtUnknown);
    } else if (cb6[27u].z == 2.0f) {
      odtUnknown = max((yRange * odtUnknown) + minNits, 0);
      // BT709_2_XYZ_MAT
      odtUnknown = float3(
        mad(cb6[24u].z, odtUnknown.z, mad(cb6[24u].y, odtUnknown.y, cb6[24u].x * odtUnknown.x)),
        mad(cb6[25u].z, odtUnknown.z, mad(cb6[25u].y, odtUnknown.y, cb6[25u].x * odtUnknown.x)),
        mad(cb6[26u].z, odtUnknown.z, mad(cb6[26u].y, odtUnknown.y, cb6[26u].x * odtUnknown.x))
      );
      odtUnknown = mul(XYZ_2_BT709_MAT, odtUnknown);
      odtUnknown /= min(80.0f, peakNits);
    } else if (cb6[27u].z == 3.0f) {
      odtUnknown = max((yRange * odtUnknown) + minNits, 0);
      odtUnknown = float3(
        mad(cb6[24u].z, odtUnknown.z, mad(cb6[24u].y, odtUnknown.y, cb6[24u].x * odtUnknown.x)),
        mad(cb6[25u].z, odtUnknown.z, mad(cb6[25u].y, odtUnknown.y, cb6[25u].x * odtUnknown.x)),
        mad(cb6[26u].z, odtUnknown.z, mad(cb6[26u].y, odtUnknown.y, cb6[26u].x * odtUnknown.x))
      );
      float scale = 1.0f / min(80.0f, peakNits);
      odtUnknown = mul(XYZ_2_BT2020_MAT, odtUnknown);
    } else if (cb6[27u].z == 4.0f) {
      odtUnknown = max(odtUnknown, 0.f);
      float scale = max(peakNits, 80.0f) * 0.001000000047497451305389404296875f;
      odtUnknown = float3(
        mad(cb6[24u].z, odtUnknown.z, mad(cb6[24u].y, odtUnknown.y, cb6[24u].x * odtUnknown.x)),
        mad(cb6[25u].z, odtUnknown.z, mad(cb6[25u].y, odtUnknown.y, cb6[25u].x * odtUnknown.x)),
        mad(cb6[26u].z, odtUnknown.z, mad(cb6[26u].y, odtUnknown.y, cb6[26u].x * odtUnknown.x))
      );
      odtUnknown *= scale;
      odtUnknown = saturate(odtUnknown);
      odtUnknown = pow(odtUnknown, 0.1593017578125f);
      odtUnknown = ((odtUnknown * 18.8515625f) + 0.8359375f) / ((odtUnknown * 18.6875f) + 1.0f);
      odtUnknown = pow(odtUnknown, 78.84375f);
      odtUnknown = saturate(odtUnknown);
    } else {
      // Heatmap?
      float maxScaledChannel = max(
        (yRange * odtUnknown.r) + minNits,
        max((yRange * odtUnknown.g) + minNits, (yRange * odtUnknown.b) + minNits)
      );
      float _3335 = max(min((log2(maxScaledChannel) * 0.5f) + 2.0f, 7.0f), 0.0f);
      uint _3336 = uint(int(_3335));
      float _3338 = _3335 - float(int(_3336));
      uint _3339 = _3336 + 1u;
      uint _3353 = 0u + (_3336 * 3u);
      uint _3357 = 1u + (_3336 * 3u);
      uint _3361 = 2u + (_3336 * 3u);
      odtUnknown = float3(
        ((HEATMAP_COLORS[0u + (_3339 * 3u)] - HEATMAP_COLORS[_3353]) * _3338) + HEATMAP_COLORS[_3353],
        ((HEATMAP_COLORS[1u + (_3339 * 3u)] - HEATMAP_COLORS[_3357]) * _3338) + HEATMAP_COLORS[_3357],
        ((HEATMAP_COLORS[2u + (_3339 * 3u)] - HEATMAP_COLORS[_3361]) * _3338) + HEATMAP_COLORS[_3361]
      );
    }

    odtFinal = odtUnknown;
  } else {
    peakNits = injectedData.toneMapperPeakNits;
    outputRGB *= exposure * injectedData.toneMapperExposure * (midGrayNits / 10.f);
    const float paperWhite = injectedData.toneMapperPaperWhite;

    bool useD60 = (injectedData.toneMapperWhitePoint == -1.0f || (injectedData.toneMapperWhitePoint == 0.f && cb6[28u].z == 0.f));

    outputRGB = max(0, outputRGB);
    if (toneMapperType == TONE_MAPPER_TYPE__OPENDRT) {
      // OpenDRT is based around 100 nits for SDR

      // Size to BT2020
      float3x3 inputMatrix;
      float3x3 outputMatrix;

      if (injectedData.toneMapperColorSpace == 1.f) {
        inputMatrix = useD60 ? BT709_2_BT2020D60_MAT : BT709_2_BT2020_MAT;
        outputMatrix = BT2020_2_BT709_MAT;
      } else if (injectedData.toneMapperColorSpace == 2.f) {
        inputMatrix = BT709_2_AP1_MAT;
        outputMatrix = useD60 ? AP1_2_BT709D60_MAT : AP1_2_BT709_MAT;
      } else {
        inputMatrix = useD60 ? BT709_2_BT709D60_MAT : IDENTITY_MAT;
        outputMatrix = IDENTITY_MAT;
      }

      outputRGB = mul(inputMatrix, outputRGB);
      odtFinal = open_drt_transform_custom(
        outputRGB,
        100.f * (peakNits / paperWhite),
        0,
        injectedData.toneMapperHighlights,
        injectedData.toneMapperShadows,
        injectedData.toneMapperContrast,
        injectedData.toneMapperDechroma
      );
      odtFinal = mul(outputMatrix, odtFinal);
    } else if (toneMapperType == TONE_MAPPER_TYPE__ACES) {
      // ACES uses 48 nits for 100-nit SDR
      // Base 100-nit SDR = 203 SDR
      // Scaling is Peak Nits / Paper White
      float3x3 clampMatrix;
      float3x3 outputMatrix;
      if (injectedData.toneMapperColorSpace == 1.f) {
        clampMatrix = useD60 ? AP1_2_BT2020D60_MAT : AP1_2_BT2020_MAT;
        outputMatrix = BT2020_2_BT709_MAT;
      } else if (injectedData.toneMapperColorSpace == 2.f) {
        clampMatrix = useD60 ? IDENTITY_MAT : AP1_2_AP1D65_MAT;
        outputMatrix = AP1_2_BT709D60_MAT;  // Skip D65=>D60
      } else {
        clampMatrix = useD60 ? AP1_2_BT709D60_MAT : AP1_2_BT709_MAT;
        outputMatrix = IDENTITY_MAT;
      }
      outputRGB = apply_user_shadows(outputRGB, injectedData.toneMapperShadows);
      if (injectedData.toneMapperHighlights != 1.f) {
        outputRGB = apply_user_highlights(outputRGB, injectedData.toneMapperHighlights);
      }
      if (injectedData.toneMapperContrast != 1.f) {
        float3 workingColor = pow(outputRGB / 0.18f, injectedData.toneMapperContrast) * 0.18f;
        // Working in BT709 still
        float workingColorY = yFromBT709(workingColor);
        float outputRGBY = yFromBT709(outputRGB);
        outputRGB *= outputRGBY ? workingColorY / outputRGBY : 1.f;
      }
      odtFinal = aces_rrt_odt(
        outputRGB,
        0.0001f, // MIN_LUM_RRT
        48.f * (peakNits / paperWhite),
        clampMatrix
      );
      odtFinal = mul(outputMatrix, odtFinal);
    }

    const float CDPR_WHITE = 100.f;
    odtFinal *= peakNits / CDPR_WHITE;
  }

  if (injectedData.colorGradingWorkflow == 1.f || asuint(cb6[42u]).y == 0u) {
    uint textureCount = asuint(cb6[41u]).x;
    if (textureCount != 0u) {
      odtFinal = sampleAllLUTs(odtFinal);
    }
  }

  return float4(odtFinal.rgb, 0.f);
}
