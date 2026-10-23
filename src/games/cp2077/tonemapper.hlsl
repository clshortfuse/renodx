// LUT + TONEMAPPER

#include "./aces_cdpr.hlsl"
#include "./cp2077.h"
#include "./injectedBuffer.hlsl"

static const float HEATMAP_COLORS[27] = {
  0.0f, 0.0f, 0.0f,  // Black
  0.0f, 0.0f, 1.0f,  // Blue
  0.0f, 1.0f, 1.0f,  // Cyan
  0.0f, 1.0f, 0.0f,  // Green
  1.0f, 1.0f, 0.0f,  // Yellow
  1.0f, 0.0f, 0.0f,  // Red
  1.0f, 0.0f, 1.0f,  // Magenta
  1.0f, 1.0f, 1.0f,  // White
  1.0f, 1.0f, 1.0f,  // White
};

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
  float const33y;  // cb6[33u].y 0.01245117 (100) 0.00622558 (200) 0.00498046 (250) 0.004150039 (300) 0.00311279 (400)  0.00249023 (500)
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

float3 Sample3DLUT(Texture3D<float4> texture, const float3 color, float4 lutSettings) {
  bool use_tetrahedral = true;
  if (use_tetrahedral) {
    return renodx::lut::SampleTetrahedral(texture, color).rgb;
  }
  float scale = lutSettings.x;
  float offset = lutSettings.y;
  float3 coordinates = color * scale + offset;
  coordinates = clamp(coordinates, 0.f, 1.f);
  return texture.SampleLevel(SAMPLER, coordinates, 0.0f).rgb;
}

float EvaluateBoundedNeutralLUTModel(
    float unbounded_output,
    float black_output,
    float midgray_output,
    float peak_output) {
  // Generalized rational response constrained to the sampled black, mid-gray,
  // and peak. Its derivative with respect to unbounded_output is 1 at mid-gray.
  float exponent = midgray_output * (peak_output - black_output)
                   / ((midgray_output - black_output) * (peak_output - midgray_output));
  float ratio = pow(max(0.f, unbounded_output / midgray_output), exponent)
                * (midgray_output - black_output) / (peak_output - midgray_output);
  return black_output + (peak_output - black_output) * ratio / (1.f + ratio);
}

float3 SampleLUT(float4 lutSettings, const float3 inputColor, uint textureIndex, bool bypass_input_scaling = false) {
  float3 color = inputColor;
  if (lutSettings.x > 0.0f) {           // LUT Strength
    uint _503 = asuint(lutSettings).w;  // lut Type
    uint _504 = _503 & 15u;

    float scale = 1.f;
    float3 lut_peak_sample = 1.f;
    if (CUSTOM_LUT_CORRECTION_MIDGRAY_ACTIVE) {
      lut_peak_sample = Sample3DLUT(LUT_TEXTURES[textureIndex], 1.f, lutSettings);
    }

    if (!bypass_input_scaling && CUSTOM_LUT_CORRECTION_MIDGRAY_ACTIVE && _504 <= 2u) {
      float3 lut_peak_linear = ((_503 & 240u) == 16u)
                                   ? renodx::color::srgb::DecodeSafe(lut_peak_sample)
                                   : lut_peak_sample;
      float lut_output_peak = max(1e-6f, renodx::math::Max(abs(lut_peak_linear)));
      scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(
          color,
          lut_output_peak);
      color *= scale;
    } else if (!bypass_input_scaling && _504 < 2u) {
      float gMax = max(color.r, max(color.g, color.b));
      gMax = max(gMax, 1e-6);
      float gClamped = renodx::tonemap::SmoothClamp(gMax);
      scale = gClamped / gMax;
      color *= scale;
    }

    float3 linear_input_color = color;
    if (_504 == 1u) {
      color = renodx::color::srgb::EncodeSafe(color);
    } else if (_504 == 2u) {
      color = renodx::color::arri::logc::c800::Encode(color);
    }

    color = saturate(color);  // Ensure within 0-1

    float3 lutInputColor = color;

    color = Sample3DLUT(LUT_TEXTURES[textureIndex], lutInputColor, lutSettings);

    float3 lutOutputColor = color;

    if ((_503 & 240u) == 16u) {
      color = renodx::color::srgb::DecodeSafe(color);
    }

    if (injectedData.processingLUTScaling > 0.f) {
      float correction_strength = saturate(injectedData.processingLUTScaling);
      if (CUSTOM_LUT_CORRECTION_MIDGRAY_ACTIVE) {
        const float reconstruction_midgray_output_gamma = renodx::color::srgb::Encode(0.18f);
        const float reconstruction_slope_delta_gamma = 0.005f;

        float neutral_input = max(0.f, renodx::color::y::from::BT709(linear_input_color));
        float neutral_coordinate = neutral_input;
        float black_coordinate = 0.f;
        if (_504 == 1u) {
          neutral_coordinate = renodx::color::srgb::EncodeSafe(neutral_input);
          black_coordinate = renodx::color::srgb::Encode(0.f);
        } else if (_504 == 2u) {
          neutral_coordinate = renodx::color::arri::logc::c800::Encode(neutral_input);
          black_coordinate = renodx::color::arri::logc::c800::Encode(0.f);
        }

        float3 neutral_lut_gamma = Sample3DLUT(LUT_TEXTURES[textureIndex], neutral_coordinate, lutSettings);
        float3 lut_black_gamma = Sample3DLUT(LUT_TEXTURES[textureIndex], black_coordinate, lutSettings);
        float3 lut_peak_gamma = lut_peak_sample;
        float3 output_gamma = lutOutputColor;
        if ((_503 & 240u) != 16u) {
          output_gamma = renodx::color::srgb::EncodeSafe(color);
          neutral_lut_gamma = renodx::color::srgb::EncodeSafe(neutral_lut_gamma);
          lut_black_gamma = renodx::color::srgb::EncodeSafe(lut_black_gamma);
          lut_peak_gamma = renodx::color::srgb::EncodeSafe(lut_peak_gamma);
        }

        float neutral_lut_luma = renodx::color::y::from::BT709(neutral_lut_gamma);
        float black_output_gamma = max(0.f, renodx::color::y::from::BT709(lut_black_gamma));
        float peak_output_gamma = max(0.f, renodx::color::y::from::BT709(lut_peak_gamma));
        float floor_correction = 0.f;
        if (black_output_gamma + 1e-6f < reconstruction_midgray_output_gamma
            && reconstruction_midgray_output_gamma + 1e-6f < peak_output_gamma) {
          // Solve the neutral LUT inverse at output mid-gray. This makes the
          // reconstruction pivot follow LUT exposure rather than assuming that
          // scene input 0.18 is the perceptually relevant point.
          float lower_coordinate = black_coordinate;
          float upper_coordinate = 1.f;
          [loop]
          for (int i = 0; i < 12; ++i) {
            float candidate_coordinate = (lower_coordinate + upper_coordinate) * 0.5f;
            float3 candidate_gamma = Sample3DLUT(
                LUT_TEXTURES[textureIndex],
                candidate_coordinate,
                lutSettings);
            if ((_503 & 240u) != 16u) {
              candidate_gamma = renodx::color::srgb::EncodeSafe(candidate_gamma);
            }
            if (renodx::color::y::from::BT709(candidate_gamma) < reconstruction_midgray_output_gamma) {
              lower_coordinate = candidate_coordinate;
            } else {
              upper_coordinate = candidate_coordinate;
            }
          }

          float reference_coordinate = (lower_coordinate + upper_coordinate) * 0.5f;
          float reference_linear_input = reference_coordinate;
          if (_504 == 1u) {
            reference_linear_input = renodx::color::srgb::Decode(reference_coordinate);
          } else if (_504 == 2u) {
            reference_linear_input = renodx::color::arri::logc::c800::Decode(reference_coordinate);
          }
          float reference_input_gamma = max(
              renodx::color::srgb::Encode(max(0.f, reference_linear_input)),
              1e-6f);
          float slope_low_input_gamma = max(0.f, reference_input_gamma - reconstruction_slope_delta_gamma);
          float slope_high_input_gamma = reference_input_gamma + reconstruction_slope_delta_gamma;
          float slope_low_linear_input = renodx::color::srgb::Decode(slope_low_input_gamma);
          float slope_high_linear_input = renodx::color::srgb::Decode(slope_high_input_gamma);
          float slope_low_coordinate = slope_low_linear_input;
          float slope_high_coordinate = slope_high_linear_input;
          if (_504 == 1u) {
            slope_low_coordinate = renodx::color::srgb::Encode(slope_low_linear_input);
            slope_high_coordinate = renodx::color::srgb::Encode(slope_high_linear_input);
          } else if (_504 == 2u) {
            slope_low_coordinate = renodx::color::arri::logc::c800::Encode(slope_low_linear_input);
            slope_high_coordinate = renodx::color::arri::logc::c800::Encode(slope_high_linear_input);
          }

          float3 lut_slope_low_gamma = Sample3DLUT(LUT_TEXTURES[textureIndex], slope_low_coordinate, lutSettings);
          float3 lut_slope_high_gamma = Sample3DLUT(LUT_TEXTURES[textureIndex], slope_high_coordinate, lutSettings);
          if ((_503 & 240u) != 16u) {
            lut_slope_low_gamma = renodx::color::srgb::EncodeSafe(lut_slope_low_gamma);
            lut_slope_high_gamma = renodx::color::srgb::EncodeSafe(lut_slope_high_gamma);
          }
          float reference_output_slope = max(
              0.f,
              renodx::math::DivideSafe(
                  renodx::color::y::from::BT709(lut_slope_high_gamma)
                      - renodx::color::y::from::BT709(lut_slope_low_gamma),
                  slope_high_input_gamma - slope_low_input_gamma,
                  0.f));
          float neutral_contrast = max(
              0.01f,
              reference_input_gamma * reference_output_slope / reconstruction_midgray_output_gamma);
          float neutral_unbounded_gamma = reconstruction_midgray_output_gamma * pow(max(0.f, renodx::color::srgb::EncodeSafe(neutral_input) / reference_input_gamma), neutral_contrast);
          float bounded_with_floor = EvaluateBoundedNeutralLUTModel(
              neutral_unbounded_gamma,
              black_output_gamma,
              reconstruction_midgray_output_gamma,
              peak_output_gamma);
          float bounded_without_floor = EvaluateBoundedNeutralLUTModel(
              neutral_unbounded_gamma,
              0.f,
              reconstruction_midgray_output_gamma,
              peak_output_gamma);

          // Preserve the LUT's residual neutral shape rather than replacing it:
          // sampled = bounded model + toe/style residual. Remove only the modeled
          // floor component. Highlight headroom is reconstructed multiplicatively
          // by the N2 max-channel bridge instead of adding a neutral
          // extension toward a fictitious PsychoV source clip.
          floor_correction = bounded_without_floor - bounded_with_floor;
        }
        float neutral_target_gamma = neutral_lut_luma
                                     + floor_correction * saturate(injectedData.processing_lut_black_floor);
        float3 decompressed_gamma = max(
            0.f,
            output_gamma
                + neutral_target_gamma - neutral_lut_luma);

        color = renodx::lut::RecolorUnclamped(
            color,
            renodx::color::srgb::DecodeSafe(decompressed_gamma),
            correction_strength);
      } else {
        float3 lut_black = 0.f;
        float3 lut_white = 1.f;
        float3 lut_mid_gray = 0.18f;
        if (_504 == 1u) {
          lut_black = Sample3DLUT(LUT_TEXTURES[textureIndex], 0.f, lutSettings);
          lut_mid_gray = Sample3DLUT(LUT_TEXTURES[textureIndex], renodx::color::srgb::Encode(0.18f), lutSettings);
          lut_white = Sample3DLUT(LUT_TEXTURES[textureIndex], 1.f, lutSettings);
        } else if (_504 == 2u) {
          lut_black = Sample3DLUT(LUT_TEXTURES[textureIndex], renodx::color::arri::logc::c800::Encode(0.f), lutSettings);
          lut_mid_gray = Sample3DLUT(LUT_TEXTURES[textureIndex], renodx::color::arri::logc::c800::Encode(0.18f), lutSettings);
          lut_white = Sample3DLUT(LUT_TEXTURES[textureIndex], renodx::color::arri::logc::c800::Encode(100.f), lutSettings);
        }

        float3 output_gamma = lutOutputColor;
        float3 black_gamma = lut_black;
        float3 midgray_gamma = lut_mid_gray;
        float3 peak_gamma = lut_white;
        float3 input_gamma = lutInputColor;

        if ((_503 & 240u) == 16u) {
          // noop
        } else {
          float mid_gray = renodx::color::y::from::BT709(lut_mid_gray);
          float peak = renodx::color::y::from::BT709(lut_white);

          // Correct peak
          float3 neutral_tonemapped = renodx::tonemap::ReinhardScalable(linear_input_color, peak, 0, 0.18f, mid_gray);
          float3 graded_color = renodx::tonemap::UpgradeToneMap(
              linear_input_color * mid_gray / 0.18f,
              neutral_tonemapped,
              color,
              1.f);
          color = lerp(color, graded_color, correction_strength);

          // linear to gamma
          output_gamma = renodx::color::srgb::EncodeSafe(color);
          black_gamma = renodx::color::srgb::EncodeSafe(lut_black);
          midgray_gamma = renodx::color::srgb::EncodeSafe(lut_mid_gray);
          peak_gamma = 1.f;  // Peak already corrected
          input_gamma = renodx::color::srgb::EncodeSafe(linear_input_color);
        }

        float3 unclamped = renodx::lut::Unclamp(
            output_gamma,
            black_gamma,
            midgray_gamma,
            peak_gamma,
            input_gamma);

        float3 recolored = renodx::lut::RecolorUnclamped(
            color,
            renodx::color::srgb::DecodeSafe(unclamped));

        color = lerp(color, recolored, correction_strength);
      }
    }

    if (!bypass_input_scaling) {
      float reconstruction_scale = scale;
      if (CUSTOM_LUT_CORRECTION_MIDGRAY) {
        reconstruction_scale = lerp(
            1.f,
            scale,
            saturate(injectedData.processing_lut_ceiling));
      }
      color /= reconstruction_scale;
    }
  }
  color *= lutSettings.z;  // lut blending
  return color;
}

float3 sampleAllLUTs(const float3 color, bool bypass_input_scaling = false) {
  uint textureCount = asuint(cb6[41u]).x;
  if (textureCount == 0u) return color;

  float3 compositedColor = 0;

  [branch]
  if (injectedData.colorGradeLUTStrength != 0) {
    for (uint i = 0; i < textureCount; i++) {
      float4 lutSettings = cb6[33u + i];
      compositedColor += SampleLUT(lutSettings, color, i, bypass_input_scaling);
    }
    compositedColor = lerp(color, compositedColor, injectedData.colorGradeLUTStrength);
  } else {
    return color;
    for (uint i = 0; i < textureCount; i++) {
      float4 lutSettings = cb6[33u + i];
      compositedColor += SampleLUT(lutSettings, color, i, bypass_input_scaling);
    }

    // float3 aces_color = renodx::tonemap::aces::RRTAndODT(color * 2.f, 0.1f, 1900.f) / 48.f;
    float3 aces_color = renodx::tonemap::aces::RRTAndODT(color * 2.f, 0.02f, 48.f) / 48.f;

    // aces_color *= 1.4f;
    float3 upgraded = renodx::tonemap::UpgradeToneMap(
        color * 2.f,
        aces_color,
        compositedColor,
        1.f);
    compositedColor = aces_color;
    // compositedColor = aces_color;
    // float3 retonemapped = renodx::tonemap::aces::RRTAndODT(upgraded, 0.1f, 10000.f / 48.f) / 48.f;
    // compositedColor = renodx::color::correct::Luminance(compositedColor, retonemapped);
    // compositedColor = color * 2.f;
    // compositedColor = renodx::tonemap::ACESFittedAP1(color);
    // compositedColor = color;
  }

  return compositedColor;
}

float EvaluateVanillaNeutralTonemap(float neutral_input, SegmentedSplineParams_c9 odt_config) {
  float3 neutral_color = float3(neutral_input, neutral_input, neutral_input);
  float3 outputXYZ = mul(renodx::color::BT709_TO_XYZ_MAT, neutral_color);
  float3 outputXYZD60 = mul(renodx::color::D65_TO_D60_CAT, outputXYZ);
  float3 aces = mul(renodx::color::XYZ_TO_AP0_MAT, outputXYZD60);
  float3 rgbPost = aces_rrt_ap0(aces);

  float3 toneMappedColor = float3(
      segmented_spline_c9_fwd(rgbPost.r, odt_config),
      segmented_spline_c9_fwd(rgbPost.g, odt_config),
      segmented_spline_c9_fwd(rgbPost.b, odt_config));

  if (cb6[28u].w != 0.0f) {
    float ap1Y = max(dot(rgbPost, AP1_RGB2Y), 1e-6f);
    float toneMappedByLuminance = segmented_spline_c9_fwd(ap1Y, odt_config);
    float scaleFactor = toneMappedByLuminance / ap1Y;
    float3 scaledAndToneMapped = rgbPost * scaleFactor;
    toneMappedColor = (cb6[29u].x * (scaledAndToneMapped - toneMappedColor)) + toneMappedColor;
  }

  float minNits = cb6[27u].x;
  float peakNits = cb6[27u].y;
  float yRange = peakNits - minNits;

  toneMappedColor = max(toneMappedColor, minNits);
  float3 linearCV = renodx::tonemap::aces::YToLinCV(toneMappedColor, peakNits, minNits);

  if (cb6[28u].y != 0.0f) {
    float3 odtXYZ = mul(renodx::color::AP1_TO_XYZ_MAT, linearCV);
    odtXYZ = renodx::tonemap::aces::DarkToDim(odtXYZ, cb6[27u].w);
    linearCV = mul(renodx::color::XYZ_TO_AP1_MAT, odtXYZ);
  }

  if (cb6[28u].x != 0.0f) {
    linearCV = mul(renodx::tonemap::aces::ODT_SAT_MAT, linearCV);
  }

  float3 odtXYZ = mul(renodx::color::AP1_TO_XYZ_MAT, linearCV);

  if (CUSTOM_WHITE_POINT_D65 || (!CUSTOM_WHITE_POINT_D60 && cb6[28u].z != 0.0f)) {
    odtXYZ = mul(renodx::color::D60_TO_D65_MAT, odtXYZ);
  }

  float3x3 customMatrix0 = float3x3(
      cb6[21u].x, cb6[21u].y, cb6[21u].z,
      cb6[22u].x, cb6[22u].y, cb6[22u].z,
      cb6[23u].x, cb6[23u].y, cb6[23u].z);

  float3 odtUnknown = mul(customMatrix0, odtXYZ);
  if (cb6[27u].z == 0.0f || cb6[27u].z == 1.f) {
    odtUnknown = saturate(odtUnknown);
  } else if (cb6[27u].z == 2.0f) {
    odtUnknown = max((yRange * odtUnknown) + minNits, 0);
    odtUnknown = float3(
        mad(cb6[24u].z, odtUnknown.z, mad(cb6[24u].y, odtUnknown.y, cb6[24u].x * odtUnknown.x)),
        mad(cb6[25u].z, odtUnknown.z, mad(cb6[25u].y, odtUnknown.y, cb6[25u].x * odtUnknown.x)),
        mad(cb6[26u].z, odtUnknown.z, mad(cb6[26u].y, odtUnknown.y, cb6[26u].x * odtUnknown.x)));
    odtUnknown = mul(renodx::color::XYZ_TO_BT709_MAT, odtUnknown);
    odtUnknown /= min(80.0f, peakNits);
  } else if (cb6[27u].z == 3.0f) {
    odtUnknown = max((yRange * odtUnknown) + minNits, 0);
    odtUnknown = float3(
        mad(cb6[24u].z, odtUnknown.z, mad(cb6[24u].y, odtUnknown.y, cb6[24u].x * odtUnknown.x)),
        mad(cb6[25u].z, odtUnknown.z, mad(cb6[25u].y, odtUnknown.y, cb6[25u].x * odtUnknown.x)),
        mad(cb6[26u].z, odtUnknown.z, mad(cb6[26u].y, odtUnknown.y, cb6[26u].x * odtUnknown.x)));
    odtUnknown = mul(renodx::color::XYZ_TO_BT2020_MAT, odtUnknown);
  } else if (cb6[27u].z == 4.0f) {
    odtUnknown = max(odtUnknown, 0.f);
    float scale = max(peakNits, 80.0f) * 0.001000000047497451305389404296875f;
    odtUnknown = float3(
        mad(cb6[24u].z, odtUnknown.z, mad(cb6[24u].y, odtUnknown.y, cb6[24u].x * odtUnknown.x)),
        mad(cb6[25u].z, odtUnknown.z, mad(cb6[25u].y, odtUnknown.y, cb6[25u].x * odtUnknown.x)),
        mad(cb6[26u].z, odtUnknown.z, mad(cb6[26u].y, odtUnknown.y, cb6[26u].x * odtUnknown.x)));
    odtUnknown *= scale;
    odtUnknown = saturate(odtUnknown);
    odtUnknown = pow(odtUnknown, 0.1593017578125f);
    odtUnknown = ((odtUnknown * 18.8515625f) + 0.8359375f) / ((odtUnknown * 18.6875f) + 1.0f);
    odtUnknown = pow(odtUnknown, 78.84375f);
    odtUnknown = saturate(odtUnknown);
  } else {
    odtUnknown = max((yRange * odtUnknown) + minNits, 0);
  }

  return renodx::color::y::from::BT709(max(0.f, odtUnknown));
}

float ResolvePsychoVReferenceOutput(float vanilla_output) {
  float reference_output = max(0.f, vanilla_output) * (100.f / 203.f);
  if (RENODX_GAMMA_CORRECTION >= 2.f) {
    reference_output = renodx::color::correct::GammaSafe(reference_output, true, 2.2f);
  }
  return max(0.f, reference_output);
}

float EvaluatePsychoVHDRReferenceOutput(float neutral_input, SegmentedSplineParams_c9 odt_config) {
  return ResolvePsychoVReferenceOutput(EvaluateVanillaNeutralTonemap(neutral_input, odt_config));
}

float SolvePsychoVHDRReferenceInputForOutput(float target_output, float fallback_input, SegmentedSplineParams_c9 odt_config) {
  float lower_input = 0.f;
  float upper_input = max(max(fallback_input, target_output), 1e-4f);
  float upper_output = EvaluateVanillaNeutralTonemap(upper_input, odt_config);

  [loop]
  for (int i = 0; i < 8; ++i) {
    if (upper_output >= target_output) break;
    upper_input *= 2.f;
    upper_output = EvaluateVanillaNeutralTonemap(upper_input, odt_config);
  }

  [loop]
  for (int j = 0; j < 16; ++j) {
    float mid_input = (lower_input + upper_input) * 0.5f;
    float mid_output = EvaluateVanillaNeutralTonemap(mid_input, odt_config);
    if (mid_output < target_output) {
      lower_input = mid_input;
    } else {
      upper_input = mid_input;
    }
  }

  return upper_input;
}

float3 ApplyAfterToneMapLUTs(float3 color) {
  if (injectedData.colorGradeLUTStrength == 0.f) return color;

  float3 graded;
  if (CUSTOM_LUT_CORRECTION_MIDGRAY_ACTIVE) {
    // SampleLUT applies N2 from each LUT's measured linear output endpoint,
    // then reconstructs with the same scale.
    graded = sampleAllLUTs(color);
  } else {
    float lut_peak_nits = max(1.f, cb6[27u].y);
    float lut_min_nits = min(max(0.f, cb6[27u].x), lut_peak_nits - 0.001f);
    float lut_nits_scale = max(1.f, RENODX_DIFFUSE_WHITE_NITS);
    float lut_nits_range = lut_peak_nits - lut_min_nits;
    float3 lut_input_domain = max(0.f, ((color * lut_nits_scale) - lut_min_nits) / lut_nits_range);
    float3 lut_output_domain = sampleAllLUTs(lut_input_domain, true);
    graded = ((lut_output_domain * lut_nits_range) + lut_min_nits) / lut_nits_scale;
  }
  return graded;
}

// [41u].w = 0.59960937f
// cb6[41u].z = 0.06020507f
// _73 = 47.f;
// cb6[41u].y
// 69.y (gameplay 48) / (photo mode 24)

float4 tonemap(bool isACESMode = false) {
  uint4 _69 = asuint(cb6[41u]);
  uint lutSize = _69.y;

  float maxLutSize = float(_69.y + 4294967295u);  // lutSize - 1u

  const float3 position = float3(gl_GlobalInvocationID.xyz) / (float(lutSize) - 1.f);
  float3 inputColor;
  if (CUSTOM_SAMPLING_ENCODE_PQ) {
    inputColor = renodx::color::pq::Decode(position, 100.f);
  } else {
    inputColor = exp2((position - cb6[41u].w) / cb6[41u].z);
  }

  float3 outputRGB = inputColor;

  if (CUSTOM_SCENE_GRADING_STRENGTH != 0.f) {
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

    color = float3(_194, _195, _196);                                        // outside | inside
    float3 fillColor = cb6[0u].rgb * CUSTOM_SCENE_GRADING_COLOR;             // 0,0,0   | 0.00, 0.00, 0.00
    float3 sceneGamma = lerp(1.f, cb6[1u].rgb, CUSTOM_SCENE_GRADING_GAMMA);  // 1,1,1   | 1.00, 1.15, 1.05
    float3 sceneGain = lerp(1.f, cb6[2u].rgb, CUSTOM_SCENE_GRADING_GAIN);    // 1,1,1   | 1.00, 1.18, 1.00
    float3 sceneLift = cb6[3u].rgb * CUSTOM_SCENE_GRADING_LIFT;              // 0,0,0   | 0.00, 0.00, 0.00
    float blackFloor = cb6[4u].w * CUSTOM_SCENE_GRADING_BLACK;               // 0       | 0.112
    float brightness = lerp(cb6[7u].x, 1.f, CUSTOM_SCENE_GRADING_CLIP);      // 1       | 1.000

    float3 adjustedColor = color;
    adjustedColor = lerp(adjustedColor, 1.f, fillColor);
    adjustedColor *= sceneGain;
    adjustedColor += sceneLift;
    if (sceneGamma.r != 1.f || sceneGamma.g != 1.f || sceneGamma.b != 1.f) {
      adjustedColor = pow(max(0, adjustedColor), sceneGamma);
    }
    adjustedColor = lerp(blackFloor, adjustedColor, brightness);

    float _256 = adjustedColor.r;
    float _257 = adjustedColor.g;
    float _258 = adjustedColor.b;

    const float hueShift = cb6[7u].z * CUSTOM_SCENE_GRADING_HUE;
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

    // float _311 = 1.0f - cb6[7u].y;
    // float _312 = _311 * 0.2989999949932098388671875f;
    // float _314 = _312 + cb6[7u].y;
    // float _315 = _311 * 0.58700001239776611328125f;
    // float _317 = _315 + cb6[7u].y;
    // float _318 = _311 * 0.114000000059604644775390625f;
    // float _320 = _318 + cb6[7u].y;

    // Correct to BT709
    float customSaturation = lerp(1.f, cb6[7u].y, CUSTOM_SCENE_GRADING_SATURATION);
    float inverseSaturation = 1.0f - customSaturation;
    float _311 = inverseSaturation;
    float _312 = _311 * renodx::color::BT709_TO_XYZ_MAT[1].r;
    float _314 = _312 + customSaturation;
    float _315 = _311 * renodx::color::BT709_TO_XYZ_MAT[1].g;
    float _317 = _315 + customSaturation;
    float _318 = _311 * renodx::color::BT709_TO_XYZ_MAT[1].b;
    float _320 = _318 + customSaturation;

    float _324 = _312 * _279;
    float _332 = _312 * _293;
    float _340 = _312 * _303;

    float _355 = (cb6[3u].w * CUSTOM_SCENE_GRADING_BLACK) + mad(_258, mad(_309, _318, mad(_307, _315, _314 * _303)), mad(_257, mad(_300, _318, mad(_298, _315, _314 * _293)), mad(_289, _318, mad(_286, _315, _314 * _279)) * _256));
    float _356 = (cb6[3u].w * CUSTOM_SCENE_GRADING_BLACK) + mad(_258, mad(_309, _318, mad(_307, _317, _340)), mad(_257, mad(_300, _318, mad(_298, _317, _332)), mad(_289, _318, mad(_286, _317, _324)) * _256));
    float _357 = (cb6[3u].w * CUSTOM_SCENE_GRADING_BLACK) + mad(_258, mad(_309, _320, mad(_307, _315, _340)), mad(_257, mad(_300, _320, mad(_298, _315, _332)), mad(_289, _320, mad(_286, _315, _324)) * _256));
    adjustedColor = float3(_355, _356, _357);

    outputRGB = lerp(inputColor, adjustedColor, CUSTOM_SCENE_GRADING_STRENGTH);
  }

  outputRGB = max(0, outputRGB);

  // outputRGB = lerp(inputColor, outputRGB, injectedData.debugValue03);

  float exposure = lerp(1.f, cb6[42u].z, CUSTOM_DYNAMIC_EXPOSURE);  // "baked with tonemapper midpoint"

  if (isACESMode) {
    if ((CUSTOM_LUT_ORDER_BEFORE || asuint(cb6[42u]).y == 1u) && (_69.x != 0u)) {
      outputRGB = sampleAllLUTs(outputRGB);
    }

    float minNits = cb6[27u].x;  // 0.005

    float peakNits = cb6[27u].y;           // User peak Nits
    const float midGrayNits = cb6[18u].w;  // Usually 10.0
    float toneMapperType = injectedData.toneMapType;
    bool useCustomToneMapperOutputTransform = false;

    if (toneMapperType != TONE_MAPPER_TYPE__NONE) {
      outputRGB *= exposure;
    }

    if (toneMapperType != TONE_MAPPER_TYPE__PSYCHOV17
        && toneMapperType != TONE_MAPPER_TYPE__PSYCHOV22
        && toneMapperType != TONE_MAPPER_TYPE__PSYCHOV30) {
      if (injectedData.toneMapHueCorrection == 1.f) {
        outputRGB = renodx::color::correct::Hue(outputRGB, renodx::tonemap::Reinhard(outputRGB), 1.f, (uint)injectedData.toneMapHueProcessor);
      } else if (injectedData.toneMapHueCorrection == 2.f) {
        outputRGB = renodx::color::correct::Hue(outputRGB, renodx::tonemap::ACESFittedBT709(outputRGB), 1.f, (uint)injectedData.toneMapHueProcessor);
      } else if (injectedData.toneMapHueCorrection == 3.f) {
        outputRGB = renodx::color::correct::Hue(outputRGB, renodx::tonemap::ACESFittedAP1(outputRGB), 1.f, (uint)injectedData.toneMapHueProcessor);
      } else if (injectedData.toneMapHueCorrection == 4.f) {
        outputRGB = renodx::color::correct::Hue(outputRGB, renodx::tonemap::uncharted2::BT709(outputRGB), 1.f, (uint)injectedData.toneMapHueProcessor);
      }
    }

    const SegmentedSplineParams_c9 ODT_CONFIG = {
      { cb6[8u].x, cb6[9u].x, cb6[10u].x, cb6[11u].x, cb6[12u].x, cb6[13u].x, cb6[14u].x, cb6[15u].x, cb6[16u].x, cb6[17u].x },  // coefsLow[10]
      { cb6[8u].y, cb6[9u].y, cb6[10u].y, cb6[11u].y, cb6[12u].y, cb6[13u].y, cb6[14u].y, cb6[15u].y, cb6[16u].y, cb6[17u].y },  // coefsHigh[10]
      { cb6[18u].x, cb6[18u].y },                                                                                                // minPoint
      { cb6[18u].z, midGrayNits },                                                                                               // midPoint
      { cb6[19u].x, cb6[19u].y },                                                                                                // maxPoint - doesn't always match peak nits?
      cb6[19u].z,                                                                                                                // slopeLow
      cb6[19u].w                                                                                                                 // slopeHigh
    };

    if (toneMapperType == TONE_MAPPER_TYPE__VANILLA) {
      outputRGB = renodx::color::grade::UserColorGrading(
          outputRGB,
          injectedData.colorGradeExposure,
          injectedData.colorGradeHighlights,
          injectedData.colorGradeShadows,
          injectedData.colorGradeContrast,
          injectedData.colorGradeSaturation);

      float3 outputXYZ = mul(renodx::color::BT709_TO_XYZ_MAT, outputRGB);
      float3 outputXYZD60 = mul(renodx::color::D65_TO_D60_CAT, outputXYZ);
      float3 aces = mul(renodx::color::XYZ_TO_AP0_MAT, outputXYZD60);

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

      float yRange = peakNits - minNits;

      float3 toneMappedColor = float3(
          segmented_spline_c9_fwd(rgbPost.r, ODT_CONFIG),
          segmented_spline_c9_fwd(rgbPost.g, ODT_CONFIG),
          segmented_spline_c9_fwd(rgbPost.b, ODT_CONFIG));

      // Tone map by luminance
      if (cb6[28u].w != 0.0f) {
        float ap1Y = dot(rgbPost, AP1_RGB2Y);
        float toneMappedByLuminance = segmented_spline_c9_fwd(ap1Y, ODT_CONFIG);
        float scaleFactor = toneMappedByLuminance / ap1Y;
        float3 scaledAndToneMapped = (rgbPost * scaleFactor);
        toneMappedColor = (cb6[29u].x * (scaledAndToneMapped - toneMappedColor)) + toneMappedColor;
      }

      toneMappedColor = max(toneMappedColor, minNits);

      float3 linearCV = renodx::tonemap::aces::YToLinCV(toneMappedColor, peakNits, minNits);

      // dimSurround
      if (cb6[28u].y != 0.0f) {
        float3 odtXYZ = mul(renodx::color::AP1_TO_XYZ_MAT, linearCV);
        odtXYZ = renodx::tonemap::aces::DarkToDim(odtXYZ, cb6[27u].w);
        linearCV = mul(renodx::color::XYZ_TO_AP1_MAT, odtXYZ);
      }

      // Apply desaturation to compensate for luminance difference
      if (cb6[28u].x != 0.0f) {
        linearCV = mul(renodx::tonemap::aces::ODT_SAT_MAT, linearCV);
      }

      float3 odtXYZ = mul(renodx::color::AP1_TO_XYZ_MAT, linearCV);

      if (CUSTOM_WHITE_POINT_D65 || (!CUSTOM_WHITE_POINT_D60 && cb6[28u].z != 0.0f)) {
        odtXYZ = mul(renodx::color::D60_TO_D65_MAT, odtXYZ);
      }

      // XYZ_TO_BT709_MAT
      float3x3 customMatrix0 = float3x3(
          cb6[21u].x, cb6[21u].y, cb6[21u].z,
          cb6[22u].x, cb6[22u].y, cb6[22u].z,
          cb6[23u].x, cb6[23u].y, cb6[23u].z);

      float3 odtUnknown = mul(customMatrix0, odtXYZ);
      if (cb6[27u].z == 0.0f || cb6[27u].z == 1.f) {
        odtUnknown = saturate(odtUnknown);
      } else if (cb6[27u].z == 2.0f) {
        odtUnknown = max((yRange * odtUnknown) + minNits, 0);
        // BT709_TO_XYZ_MAT
        odtUnknown = float3(
            mad(cb6[24u].z, odtUnknown.z, mad(cb6[24u].y, odtUnknown.y, cb6[24u].x * odtUnknown.x)),
            mad(cb6[25u].z, odtUnknown.z, mad(cb6[25u].y, odtUnknown.y, cb6[25u].x * odtUnknown.x)),
            mad(cb6[26u].z, odtUnknown.z, mad(cb6[26u].y, odtUnknown.y, cb6[26u].x * odtUnknown.x)));
        odtUnknown = mul(renodx::color::XYZ_TO_BT709_MAT, odtUnknown);
        odtUnknown /= min(80.0f, peakNits);
      } else if (cb6[27u].z == 3.0f) {
        odtUnknown = max((yRange * odtUnknown) + minNits, 0);
        odtUnknown = float3(
            mad(cb6[24u].z, odtUnknown.z, mad(cb6[24u].y, odtUnknown.y, cb6[24u].x * odtUnknown.x)),
            mad(cb6[25u].z, odtUnknown.z, mad(cb6[25u].y, odtUnknown.y, cb6[25u].x * odtUnknown.x)),
            mad(cb6[26u].z, odtUnknown.z, mad(cb6[26u].y, odtUnknown.y, cb6[26u].x * odtUnknown.x)));
        float scale = 1.0f / min(80.0f, peakNits);
        odtUnknown = mul(renodx::color::XYZ_TO_BT2020_MAT, odtUnknown);
      } else if (cb6[27u].z == 4.0f) {
        odtUnknown = max(odtUnknown, 0.f);
        float scale = max(peakNits, 80.0f) * 0.001000000047497451305389404296875f;
        odtUnknown = float3(
            mad(cb6[24u].z, odtUnknown.z, mad(cb6[24u].y, odtUnknown.y, cb6[24u].x * odtUnknown.x)),
            mad(cb6[25u].z, odtUnknown.z, mad(cb6[25u].y, odtUnknown.y, cb6[25u].x * odtUnknown.x)),
            mad(cb6[26u].z, odtUnknown.z, mad(cb6[26u].y, odtUnknown.y, cb6[26u].x * odtUnknown.x)));
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
            max((yRange * odtUnknown.g) + minNits, (yRange * odtUnknown.b) + minNits));
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
            ((HEATMAP_COLORS[2u + (_3339 * 3u)] - HEATMAP_COLORS[_3361]) * _3338) + HEATMAP_COLORS[_3361]);
      }

      outputRGB = odtUnknown;
    } else if (toneMapperType == TONE_MAPPER_TYPE__PSYCHOV17
               || toneMapperType == TONE_MAPPER_TYPE__PSYCHOV22
               || toneMapperType == TONE_MAPPER_TYPE__PSYCHOV30) {
      useCustomToneMapperOutputTransform = true;
      const float psychovReferenceSceneInput = 0.18f;
      const float psychovReferenceOutputTarget = 0.18f;
      float psychovReferenceInput = max(0.f, renodx::color::y::from::BT709(renodx::color::grade::UserColorGrading(
                                                 float3(psychovReferenceSceneInput * exposure, psychovReferenceSceneInput * exposure, psychovReferenceSceneInput * exposure),
                                                 injectedData.colorGradeExposure,
                                                 injectedData.colorGradeHighlights,
                                                 injectedData.colorGradeShadows,
                                                 injectedData.colorGradeContrast,
                                                 injectedData.colorGradeSaturation)));
      float psychovReferenceOutput = psychovReferenceInput;
      if (CUSTOM_PSYCHOV_EXPOSURE_MATCH) {
        psychovReferenceInput = SolvePsychoVHDRReferenceInputForOutput(psychovReferenceOutputTarget, psychovReferenceInput, ODT_CONFIG);
        psychovReferenceOutput = EvaluatePsychoVHDRReferenceOutput(psychovReferenceInput, ODT_CONFIG);
      }

      float psychovConeResponse = CUSTOM_CONE_RESPONSE;
      if (CUSTOM_PSYCHOV_VANILLA_HDR_SLOPE > 0.f) {
        float psychovSlopeReferenceInput = CUSTOM_PSYCHOV_EXPOSURE_MATCH
                                               ? psychovReferenceInput
                                               : SolvePsychoVHDRReferenceInputForOutput(psychovReferenceOutputTarget, psychovReferenceInput, ODT_CONFIG);
        float psychovSlopeReferenceOutput = EvaluatePsychoVHDRReferenceOutput(psychovSlopeReferenceInput, ODT_CONFIG);
        float psychovReferenceDelta = max(0.005f, psychovSlopeReferenceInput * 0.01f);
        float psychovReferenceLowInput = max(0.f, psychovSlopeReferenceInput - psychovReferenceDelta);
        float psychovReferenceHighInput = psychovSlopeReferenceInput + psychovReferenceDelta;
        float psychovReferenceHigh = EvaluatePsychoVHDRReferenceOutput(psychovReferenceHighInput, ODT_CONFIG);
        float psychovReferenceLow = EvaluatePsychoVHDRReferenceOutput(psychovReferenceLowInput, ODT_CONFIG);
        float psychovReferenceSlope = max(
            0.f,
            renodx::math::DivideSafe(
                psychovReferenceHigh - psychovReferenceLow,
                psychovReferenceHighInput - psychovReferenceLowInput,
                0.f));
        float psychovVanillaHDRSlope = max(
            0.f,
            renodx::math::DivideSafe(
                psychovSlopeReferenceInput * psychovReferenceSlope,
                psychovSlopeReferenceOutput,
                1.f));
        psychovConeResponse *= lerp(1.f, psychovVanillaHDRSlope, saturate(CUSTOM_PSYCHOV_VANILLA_HDR_SLOPE));
      }

      float psychovPeakNits = RENODX_PEAK_WHITE_NITS;
      float psychovOutputScaleNits = max(1.f, RENODX_DIFFUSE_WHITE_NITS);
      float psychovPeakValue = max(
          1.f,
          renodx::math::DivideSafe(psychovPeakNits, psychovOutputScaleNits, 1.f));
      if (RENODX_GAMMA_CORRECTION >= 2.f) {
        psychovPeakValue = renodx::color::correct::Gamma(psychovPeakValue, true, 2.2f);
      }
      if (toneMapperType == TONE_MAPPER_TYPE__PSYCHOV17) {
        outputRGB = renodx::tonemap::psychov::psychotm_test17(
            outputRGB,  // bt709_input
            psychovPeakValue,
            injectedData.colorGradeExposure,
            injectedData.colorGradeHighlights,
            injectedData.colorGradeShadows,
            injectedData.colorGradeContrast,
            injectedData.colorGradeSaturation,
            1.f,
            100.f,
            1.f,  // hue_restore
            1.f,  // adaptation_contrast
            1,
            psychovConeResponse,
            float3(psychovReferenceInput, psychovReferenceInput, psychovReferenceInput),
            float3(psychovReferenceOutput, psychovReferenceOutput, psychovReferenceOutput),
            1.f,
            1,
            1.f);
      } else if (toneMapperType == TONE_MAPPER_TYPE__PSYCHOV22) {
        outputRGB = renodx::tonemap::psychov::psychotm_test22(
            outputRGB,  // bt709_input
            psychovPeakValue,
            injectedData.colorGradeExposure,
            injectedData.colorGradeHighlights,
            injectedData.colorGradeShadows,
            injectedData.colorGradeContrast,
            injectedData.colorGradeSaturation,
            1.f,
            100.f,
            1.f,  // hue_restore
            1.f,  // adaptation_contrast
            1,
            psychovConeResponse,
            float3(psychovReferenceInput, psychovReferenceInput, psychovReferenceInput),
            float3(psychovReferenceOutput, psychovReferenceOutput, psychovReferenceOutput),
            1.f,
            1,
            1.f,
            CUSTOM_CONE_COMPRESSION);
      } else {
        outputRGB = renodx::tonemap::psychov::psychotm_test30(
            outputRGB,  // bt709_input
            psychovPeakValue,
            injectedData.colorGradeExposure,
            injectedData.colorGradeHighlights,
            injectedData.colorGradeShadows,
            injectedData.colorGradeContrast,
            injectedData.colorGradeSaturation,
            1.f,
            100.f,
            1.f,  // hue_restore
            1.f,  // adaptation_contrast
            1,
            psychovConeResponse,
            float3(psychovReferenceInput, psychovReferenceInput, psychovReferenceInput),
            float3(psychovReferenceOutput, psychovReferenceOutput, psychovReferenceOutput),
            1.f,
            1,
            1.f,
            CUSTOM_CONE_COMPRESSION,
            renodx::tonemap::psychov::PSYCHO30_SOURCE_BOUNDARY_AP1);
      }

      // float3 signs = sign(outputRGB);
      // outputRGB = abs(outputRGB);
      // outputRGB = renodx::tonemap::ACESFittedBT709(outputRGB);
      // outputRGB *= injectedData.colorGradeExposure;
      // // outputRGB = outputRGB / (outputRGB + 1.f);
      // outputRGB = pow(outputRGB, injectedData.colorGradeContrast);
      // outputRGB = outputRGB * signs;

    } else {
      useCustomToneMapperOutputTransform = true;
      renodx::tonemap::Config config = renodx::tonemap::config::Create();

      config.type = injectedData.toneMapType;
      config.peak_nits = RENODX_PEAK_WHITE_NITS;
      // config.game_nits = (injectedData.toneMapType == 2.f ? (100.f / 203.f) : (100.f / 203.f)) * injectedData.toneMapGameNits;
      config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
      config.gamma_correction = (RENODX_GAMMA_CORRECTION == 2.f) ? 1.f : 0.f;
      config.exposure = injectedData.colorGradeExposure;
      config.highlights = injectedData.colorGradeHighlights;
      config.shadows = injectedData.colorGradeShadows;
      config.contrast = injectedData.colorGradeContrast;
      config.saturation = injectedData.colorGradeSaturation;
      // config.mid_gray_value = 2.3f * (midGrayNits / 100.f);
      // config.mid_gray_nits = midGrayNits;
      config.reno_drt_highlights = 1.00f;  // Match SDR
      config.reno_drt_contrast = 1.0f;
      config.reno_drt_saturation = 1.0f;
      config.reno_drt_blowout = -1.f * (injectedData.colorGradeHighlightSaturation - 1.f);
      config.reno_drt_white_clip = 100.f;
      if (injectedData.toneMapPerChannel == 1.f) {
        config.reno_drt_per_channel = true;
        config.reno_drt_working_color_space = 2u;
        config.hue_correction_strength = 0;
      }
      config.reno_drt_dechroma = injectedData.colorGradeBlowout;
      config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
      config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
      config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE;

      outputRGB = renodx::tonemap::config::Apply(outputRGB, config);

      // float3 signs = sign(outputRGB);
      // outputRGB = abs(outputRGB);
      // outputRGB = renodx::tonemap::ACESFittedBT709(outputRGB);
      // outputRGB *= injectedData.colorGradeExposure;
      // // outputRGB = outputRGB / (outputRGB + 1.f);
      // outputRGB = pow(outputRGB, injectedData.colorGradeContrast);
      // outputRGB = outputRGB * signs;
    }
    if (useCustomToneMapperOutputTransform) {
      bool useD60 = (CUSTOM_WHITE_POINT_D60 || (!CUSTOM_WHITE_POINT_D65 && cb6[28u].z == 0.f));
      if (useD60) {
        outputRGB = mul(renodx::color::BT709_TO_BT709D60_MAT, outputRGB);
      }
    }
    if (CUSTOM_LUT_ORDER_AFTER || asuint(cb6[42u]).y == 0u) {
      uint textureCount = asuint(cb6[41u]).x;
      if (textureCount != 0u) {
        outputRGB = useCustomToneMapperOutputTransform ? ApplyAfterToneMapLUTs(outputRGB) : sampleAllLUTs(outputRGB);
      }
    }
    if (useCustomToneMapperOutputTransform) {
      if (RENODX_GAMMA_CORRECTION >= 2.f) {
        outputRGB = renodx::color::correct::GammaSafe(outputRGB, false, 2.2f);
      }

      outputRGB *= RENODX_DIFFUSE_WHITE_NITS / 100.f;
    }
  } else {
    float3 input_color = outputRGB;

    // SDR
    outputRGB = renodx::color::grade::UserColorGrading(
        outputRGB,
        injectedData.colorGradeExposure,
        injectedData.colorGradeHighlights,
        injectedData.colorGradeShadows,
        injectedData.colorGradeContrast,
        injectedData.colorGradeSaturation);

    outputRGB = max(0, outputRGB);
    // float3 lut_input_color = outputRGB;
    outputRGB = sampleAllLUTs(outputRGB, true);
    // float3 upgraded = renodx::tonemap::UpgradeToneMap(
    //     lut_input_color * 2.f,
    //     aces_color,
    //     outputRGB,
    //     1.f);
    // if (injectedData.colorGradeLUTStrength == 0.f) {
    //   if (RENODX_TONE_MAP_TYPE == 2.f) {
    //     outputRGB = renodx::tonemap::aces::RRTAndODT(input_color * 2.f, 0.02f, 48.f) / 48.f;
    //   } else if (RENODX_TONE_MAP_TYPE == 3.f) {
    //     outputRGB = renodx::tonemap::ACESFittedBT709(input_color / 0.6f * 0.93f);
    //     // outputRGB = renodx::tonemap::ACESFittedAP1(input_color * 2.f);
    //   }
    // }

    outputRGB *= exposure;
  }

  if (CUSTOM_SAMPLING_DECODE_PQ) {
    outputRGB = sign(outputRGB) * renodx::color::pq::Encode(abs(outputRGB), 100.f);
  }

  return float4(outputRGB.rgb, 0.f);
}
