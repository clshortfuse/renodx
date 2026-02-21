#ifndef SRC_MHWILDS_POSTPROCESS_HLSL_
#define SRC_MHWILDS_POSTPROCESS_HLSL_
#include "./common.hlsl"

struct LocalExposureInputs {
  float2 screenSize;
  float2 screenInverseSize;
  int useAutoExposure;
  float exposureAdjustment;
  float LEPreExposureLog;
  float LEMiddleGreyLog;
  Texture3D<float2> BilateralLuminanceSRV;
  Texture2D<float> BlurredLogLumSRV;
  SamplerState BilinearClamp;
  float LEBilateralGridScale;
  float LEBilateralGridBias;
  float LEHighlightContrast;
  float LEShadowContrast;
  float LEDetailStrength;
  float2 texcoord;
  Buffer<uint4> WhitePtSrv;
  float rangeDecompress;
};

// // Custom values for their local contrast
// struct CustomLocalExposure {
//   float exposureAdjustment;
//   float tonemapRange;
//   float specularSuppression;
//   float sharpness;
//   float preTonemapRange;
//   int useAutoExposure;
//   float echoBlend;
//   float AABlend;
//   float AASubPixel;
//   float ResponsiveAARate;
//   float VelocityWeightRate;
//   float DepthRejectionRate;
//   float ContrastTrackingRate;
//   float ContrastTrackingThreshold;
//   float LEHighlightContrast;
//   float LEShadowContrast;
//   float LEDetailStrength;
//   float LEMiddleGreyLog;
//   float LEBilateralGridScale;
//   float LEBilateralGridBias;
//   float LEPreExposureLog;
//   int LEBlurredLogDownsampleMip;
//   int2 LELuminanceTextureSize;
// };

float NormalizeExposure() {
  return CUSTOM_EXPOSURE_STRENGTH * ((CUSTOM_LUT_EXPOSURE_REVERSE * 5.f) + 1);
  // return 1.f + CUSTOM_EXPOSURE_STRENGTH;
}

// float PickExposure(float vanilla, float autoexposure = 1.f) {
//   float normalizedCustomExposure = NormalizeExposure();
//   float standard = vanilla * normalizedCustomExposure;
//   float custom = standard;
//   if (CUSTOM_EXPOSURE_TYPE == 1.f) {
//     custom = CUSTOM_FLAT_EXPOSURE_DEFAULT * normalizedCustomExposure;
//     //return 50.f * autoexposure * normalizedCustomExposure;
//   }
//   // return vanilla * normalizedCustomExposure;

//   return lerp(standard, custom, 0.5f);
// }

// We process it ourselves
bool ProcessSDRVanilla() {
  return RENODX_TONE_MAP_TYPE == 0.f;
}

// float3 PickExposure(float3 vanilla, float autoexposure = 1.f) {
//   return float3(PickExposure(vanilla.r, autoexposure),
//                 PickExposure(vanilla.g, autoexposure),
//                 PickExposure(vanilla.b, autoexposure));
// }

float FlatExposure(float fixed = CUSTOM_FLAT_EXPOSURE_DEFAULT) {
  float normalizedCustomExposure = NormalizeExposure();

  return fixed * normalizedCustomExposure;
}

float3 CustomLUTColor(float3 ap1_input, float3 ap1_output) {
  float ap1_input_y = renodx::color::y::from::AP1(ap1_input);
  float ap1_output_y = renodx::color::y::from::AP1(ap1_output);
  float3 new_color;
  // float vanilla_exposure = renodx::math::DivideSafe(ap1_output_y, ap1_input_y, 0);
  new_color = lerp(
      ap1_input * (renodx::math::DivideSafe(ap1_output_y, ap1_input_y, 0)),
      ap1_output,
      CUSTOM_LUT_COLOR_STRENGTH);

  if (CUSTOM_LUT_EXPOSURE_REVERSE > 0.f) {
    new_color = lerp(
                    ap1_input,
                    ap1_output * (renodx::math::DivideSafe(ap1_input_y, ap1_output_y, 0)),
                    CUSTOM_LUT_COLOR_STRENGTH)
                * 7.f;
    new_color = renodx::color::bt709::from::AP1(new_color);
    new_color = renodx::color::grade::Contrast(new_color, 1.3f, 0.5f);
    new_color = renodx::color::ap1::from::BT709(new_color);
    // new_color = renodx::color::ap1::clamp::b(new_color);
  }
  return new_color;
}

// Encode linear AP1 to log space (matching the LUT encoding)
float EncodeLogAces(float linear_value) {
  if (linear_value <= 0.0078125f) {
    return (linear_value * 10.540237426757812f) + 0.072905533015728f;
  } else {
    return ((log2(linear_value) + 9.720000267028809f) * 0.05707762390375137f);
  }
}

// Decode log space back to linear AP1 (matching the LUT decoding)
float DecodeLogAces(float log_value) {
  if (log_value < 0.155251145362854f) {
    return (log_value + -0.072905533015728f) * 0.09487452358007431f;
  } else if (log_value < 1.4679962396621704f) {
    return exp2((log_value * 17.520000457763672f) + -9.720000267028809f);
  } else {
    return 65504.0f;  // Max representable value
  }
}

// Vector versions for convenience
float3 EncodeLogAcesVec(float3 linear_color) {
  return float3(EncodeLogAces(linear_color.r), EncodeLogAces(linear_color.g), EncodeLogAces(linear_color.b));
}

float3 DecodeLogAcesVec(float3 log_color) {
  return float3(DecodeLogAces(log_color.r), DecodeLogAces(log_color.g), DecodeLogAces(log_color.b));
}

// Sample multiple LUTs with blending and color matrix transform
// Uses RenoDX Sample() which includes strength/scaling support
// tTextureMap0: Primary LUT
// tTextureMap1: Secondary LUT (optional, blended with fTextureBlendRate)
// tTextureMap2: Tertiary LUT (optional, blended with fTextureBlendRate2)
// fColorMatrix: 4x4 matrix to transform LUT output (AP1 to AP1)
float3 SampleColorLUTs(
    float3 ap1_color,
    Texture3D<float4> lut0,
    Texture3D<float4> lut1,
    Texture3D<float4> lut2,
    SamplerState lut_sampler,
    float lut_blend_rate,
    float lut_blend_rate2,
    row_major float4x4 color_matrix) {
  // Create RenoDX LUT config for log-encoded AP1 space
  // type_input/output = LINEAR means ConvertInput/LinearOutput are no-ops
  // We handle log encoding/decoding manually before/after Sample()
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lut_sampler;
  lut_config.strength = 1.f;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::ACES_CCT;   // We handle log manually
  lut_config.type_output = renodx::lut::config::type::ACES_CCT;  // We handle log manually
  lut_config.tetrahedral = true;                                 // Better interpolation quality

  float3 bt709_color = renodx::color::bt709::from::AP1(ap1_color);
  // Encode input to log space for LUT lookup
  // float3 log_input = EncodeLogAcesVec(ap1_color);

  // Ritsu: We're encoding manually so lut scaling wouldn't work as expected
  // // Sample primary LUT using RenoDX Sample() (includes strength/scaling)
  // // Since type_input=LINEAR, log_input passes through unchanged to SampleColor
  // // Since type_output=LINEAR, result comes back in log space, which we decode
  // float3 lut0_log = renodx::lut::Sample(lut0, lut_config, log_input);
  // float3 lut_result = DecodeLogAcesVec(lut0_log);

  float3 lut_result = renodx::lut::Sample(lut0, lut_config, bt709_color);
  // Optional: Blend with secondary LUT
  if (lut_blend_rate > 0.0f) {
    // float3 lut1_log = renodx::lut::Sample(lut1, lut_config, log_input);
    // float3 lut1_linear = DecodeLogAcesVec(lut1_log);
    // lut_result = lerp(lut_result, lut1_linear, lut_blend_rate);

    float3 lut1_bt709 = renodx::lut::Sample(lut1, lut_config, bt709_color);
    // We're blending in bt709, vanilla blends in AP1 (both linear)
    // I don't notice any colors difference so I kept it bt709
    lut_result = lerp(lut_result, lut1_bt709, lut_blend_rate);
  }

  // Optional: Blend with tertiary LUT
  if (lut_blend_rate2 > 0.0f) {
    // Re-encode the blended result for second LUT sampling
    // float3 blended_log = EncodeLogAcesVec(lut_result);
    // float3 lut2_log = renodx::lut::Sample(lut2, lut_config, blended_log);
    // float3 lut2_linear = DecodeLogAcesVec(lut2_log);
    // lut_result = lerp(lut_result, lut2_linear, lut_blend_rate2);

    float3 lut2_bt709 = renodx::lut::Sample(lut2, lut_config, lut_result);
    lut_result = lerp(lut_result, lut2_bt709, lut_blend_rate2);
  }

  lut_result = renodx::color::ap1::from::BT709(lut_result);
  // Apply color matrix transform (AP1 to AP1)
  float3 matrix_output = float3(
      mad(lut_result.z, color_matrix[2].x, mad(lut_result.y, color_matrix[1].x, lut_result.x * color_matrix[0].x)) + color_matrix[3].x,
      mad(lut_result.z, color_matrix[2].y, mad(lut_result.y, color_matrix[1].y, lut_result.x * color_matrix[0].y)) + color_matrix[3].y,
      mad(lut_result.z, color_matrix[2].z, mad(lut_result.y, color_matrix[1].z, lut_result.x * color_matrix[0].z)) + color_matrix[3].z);

  return matrix_output;
}

void CustomVignette(inout float vignette) {
  vignette = lerp(1.f, vignette, CUSTOM_VIGNETTE);
}

float3 UpgradeWithSDR(float3 untonemapped_bt709, float3 tonemapped_bt709) {
  float3 sdr;
  sdr = saturate(untonemapped_bt709);
  float3 output = renodx::tonemap::UpgradeToneMap(untonemapped_bt709, sdr, tonemapped_bt709, 1.f);
  output = renodx::color::ap1::from::BT709(output);
  return output;
}

float LocalExposureCalc(float4 color, LocalExposureInputs inputs) {
  float _971;
  float4 _956 = color;
  if (!(inputs.useAutoExposure == 0)) {
    int4 _967 = asint(inputs.WhitePtSrv[16 / 4]);
    _971 = asfloat(_967.x);
  } else {
    _971 = 1.0f;
  }
  float _972 = _971 * inputs.exposureAdjustment;
  float _983 = log2(dot(float3(((_972 * _956.x) * inputs.rangeDecompress), ((_972 * _956.y) * inputs.rangeDecompress), ((_972 * _956.z) * inputs.rangeDecompress)), float3(0.25f, 0.5f, 0.25f)) + 9.999999747378752e-06f);
  float2 _993 = inputs.BilateralLuminanceSRV.SampleLevel(inputs.BilinearClamp, float3(inputs.texcoord.x, inputs.texcoord.y, ((((inputs.LEBilateralGridScale * _983) + inputs.LEBilateralGridBias) * 0.984375f) + 0.0078125f)), 0.0f);
  float _998 = inputs.BlurredLogLumSRV.SampleLevel(inputs.BilinearClamp, float2(inputs.texcoord.x, inputs.texcoord.y), 0.0f);
  float _1001 = select((_993.y < 0.0010000000474974513f), _998.x, (_993.x / _993.y));
  float _1007 = (inputs.LEPreExposureLog + _1001) + ((_998.x - _1001) * 0.6000000238418579f);
  float _1008 = inputs.LEPreExposureLog + _983;
  float _1011 = _1007 - inputs.LEMiddleGreyLog;
  float _1023 = exp2((((select((_1011 > 0.0f), inputs.LEHighlightContrast, inputs.LEShadowContrast) * _1011) - _1008) + inputs.LEMiddleGreyLog) + (inputs.LEDetailStrength * (_1008 - _1007)));
  return _1023;
}

float LocalExposureCalcRare(float4 color, LocalExposureInputs inputs) {
  float _45;
  float4 _25 = color;
  float _31 = inputs.rangeDecompress * _25.x;
  float _32 = inputs.rangeDecompress * _25.y;
  float _33 = inputs.rangeDecompress * _25.z;
  if (!((uint)(inputs.useAutoExposure) == 0)) {
    int4 _41 = asint(inputs.WhitePtSrv[16 / 4]);
    _45 = asfloat(_41.x);
  } else {
    _45 = 1.0f;
  }
  float _46 = _45 * inputs.exposureAdjustment;
  float _52 = log2(dot(float3((_46 * _31), (_46 * _32), (_46 * _33)), float3(0.25f, 0.5f, 0.25f)) + 9.999999747378752e-06f);
  float _58 = inputs.screenInverseSize.x * (inputs.texcoord.x + 0.5f);
  float _59 = inputs.screenInverseSize.y * (inputs.texcoord.y + 0.5f);
  float2 _69 = inputs.BilateralLuminanceSRV.SampleLevel(inputs.BilinearClamp, float3(_58, _59, ((((inputs.LEBilateralGridScale * _52) + inputs.LEBilateralGridBias) * 0.984375f) + 0.0078125f)), 0.0f);
  float _74 = inputs.BlurredLogLumSRV.SampleLevel(inputs.BilinearClamp, float2(_58, _59), 0.0f);
  float _77 = select(((_69.y) < 0.0010000000474974513f), _74.x, ((_69.x) / (_69.y)));
  float _83 = (inputs.LEPreExposureLog + _77) + ((_74.x - _77) * 0.6000000238418579f);
  float _84 = inputs.LEPreExposureLog + _52;
  float _87 = _83 - inputs.LEMiddleGreyLog;
  float _99 = exp2((((select((_87 > 0.0f), inputs.LEHighlightContrast, inputs.LEShadowContrast) * _87) - _84) + inputs.LEMiddleGreyLog) + (inputs.LEDetailStrength * (_84 - _83)));
  return _99;
}

float LocalExposure(float4 color, LocalExposureInputs inputs, bool rare = false) {
  inputs.LEHighlightContrast = lerp(1.0f, inputs.LEHighlightContrast, CUSTOM_LOCAL_EXPOSURE_HIGHLIGHTS);
  inputs.LEShadowContrast = lerp(1.0f, inputs.LEShadowContrast, CUSTOM_LOCAL_EXPOSURE_SHADOWS);
  inputs.LEMiddleGreyLog = lerp(log2(0.18f), inputs.LEMiddleGreyLog, CUSTOM_LOCAL_EXPOSURE_MID_GREY);
  inputs.LEDetailStrength = lerp(1.0f, inputs.LEDetailStrength, CUSTOM_LOCAL_EXPOSURE_DETAIL);
  if (!rare) return LocalExposureCalc(color, inputs);
  return LocalExposureCalcRare(color, inputs);
}

struct CustomTonemapParam {
  float contrast;
  float linearBegin;
  float linearLength;
  float toe;
  float maxNit;
  float linearStart;
  float displayMaxNitSubContrastFactor;
  float contrastFactor;
  float mulLinearStartContrastFactor;
  float invLinearBegin;
  float madLinearStartContrastFactor;
};

// Calculate mulLinearStartContrastFactor to maintain curve continuity at linearStart
// when madLinearStartContrastFactor is adjusted
float CalculateMulLinearStartContrastFactor(
    float madLinearStartContrastFactor_adjusted,
    float contrast_val,
    float linearStart_val,
    float maxNit_val,
    float contrastFactor_val,
    float displayMaxNitSubContrastFactor_val) {
  float contrast_output = (contrast_val * linearStart_val) + madLinearStartContrastFactor_adjusted;
  float highlight_numerator = maxNit_val - contrast_output;
  return log2(highlight_numerator / displayMaxNitSubContrastFactor_val) - (contrastFactor_val * linearStart_val);
}

// Allow overriding the peak nits; all dependent factors are recomputed from it.
float3 VanillaSDRTonemapper(float3 color, CustomTonemapParam params, float peak = -1, bool is_sdr = false) {
  if (peak == -1) peak = params.maxNit;
  CustomTonemapParam vanillaParams = params;

  bool custom_params = CUSTOM_TONE_MAP_PARAMETERS == 1.f;
  if (custom_params) {
    // params.contrast *= 1.2f;
    // params.contrast = 0.18f;
    // params.toe = 3.f;
    params.madLinearStartContrastFactor = renodx::math::FLT_EPSILON;
    params.linearBegin = renodx::math::FLT_EPSILON;
    // params.madLinearStartContrastFactor = 0.001f;
    // params.linearBegin = 0.001f;
    //  params.invLinearBegin *= 1.5f;
    //  params.displayMaxNitSubContrastFactor *= 2.f;
    //  params.madLinearStartContrastFactor *= 0.20f;
    //  params.toe *= 1.2f;
  }
  if (custom_params || (peak != vanillaParams.maxNit)) {
    params.maxNit = peak;
    params.linearStart = peak;
    params.mulLinearStartContrastFactor = CalculateMulLinearStartContrastFactor(
        params.madLinearStartContrastFactor,
        params.contrast,
        params.linearStart,
        params.maxNit,
        params.contrastFactor,
        params.displayMaxNitSubContrastFactor);
  }

  float _2956;
  float _2965;
  float _2974;
  float _3045;
  float _3046;
  float _3047;
  float _2948 = params.invLinearBegin * color.r;
  if (!(color.r >= params.linearBegin)) {
    _2956 = ((_2948 * _2948) * (3.0f - (_2948 * 2.0f)));
  } else {
    _2956 = 1.0f;
  }
  float _2957 = params.invLinearBegin * color.g;
  if (!(color.g >= params.linearBegin)) {
    _2965 = ((_2957 * _2957) * (3.0f - (_2957 * 2.0f)));
  } else {
    _2965 = 1.0f;
  }
  float _2966 = params.invLinearBegin * color.b;
  if (!(color.b >= params.linearBegin)) {
    _2974 = ((_2966 * _2966) * (3.0f - (_2966 * 2.0f)));
  } else {
    _2974 = 1.0f;
  }
  float _2983 = select((color.r < params.linearStart), 0.0f, 1.0f);
  float _2984 = select((color.g < params.linearStart), 0.0f, 1.0f);
  float _2985 = select((color.b < params.linearStart), 0.0f, 1.0f);
  _3045 = (((((params.contrast * color.r) + params.madLinearStartContrastFactor) * (_2956 - _2983)) + (((pow(_2948, params.toe)) * (1.0f - _2956)) * params.linearBegin)) + ((params.maxNit - (exp2((params.contrastFactor * color.r) + params.mulLinearStartContrastFactor) * params.displayMaxNitSubContrastFactor)) * _2983));
  _3046 = (((((params.contrast * color.g) + params.madLinearStartContrastFactor) * (_2965 - _2984)) + (((pow(_2957, params.toe)) * (1.0f - _2965)) * params.linearBegin)) + ((params.maxNit - (exp2((params.contrastFactor * color.g) + params.mulLinearStartContrastFactor) * params.displayMaxNitSubContrastFactor)) * _2984));
  _3047 = (((((params.contrast * color.b) + params.madLinearStartContrastFactor) * (_2974 - _2985)) + (((pow(_2966, params.toe)) * (1.0f - _2974)) * params.linearBegin)) + ((params.maxNit - (exp2((params.contrastFactor * color.b) + params.mulLinearStartContrastFactor) * params.displayMaxNitSubContrastFactor)) * _2985));

  return float3(_3045, _3046, _3047);
}

float3 CustomTonemap(float3 untonemapped, CustomTonemapParam params, bool is_sdr) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped);

  if (is_sdr && RENODX_TONE_MAP_TYPE == 0) {
    // float mid_gray_out = VanillaSDRTonemapper(0.18f, params).x;
    // untonemapped_bt709 = PreTonemapSliders(untonemapped_bt709, mid_gray_out);

    // // Roll off grading sliders to not clip
    // float white_clip = 100.f;
    // white_clip = max(100.f, PreTonemapSliders(white_clip).x);
    // if (white_clip != 100.f) untonemapped_bt709 = ReinhardPiecewiseExtendedMaxCLL(untonemapped_bt709, 4.f, 100.f, white_clip);

    float3 output_color = renodx::color::bt709::from::AP1(VanillaSDRTonemapper(renodx::color::ap1::from::BT709(untonemapped_bt709), params));
    //output_color = PostTonemapSliders(output_color);
    return renodx::color::ap1::from::BT709(output_color);
  } else if (RENODX_TONE_MAP_TYPE == 0.f) {
    return untonemapped;
  }

  float per_channel_peak = 12.f;
  float by_luminance_peak = 100.f;

  float y_in = renodx::color::y::from::BT709(untonemapped_bt709);
  float y_out = VanillaSDRTonemapper(y_in, params, by_luminance_peak).x;
  float3 tonemapped_bt709_lum = renodx::color::correct::Luminance(untonemapped_bt709, y_in, y_out);

  float3 tonemapped_bt2020_ch = VanillaSDRTonemapper(renodx::color::bt2020::from::BT709(untonemapped_bt709), params, per_channel_peak);
  float3 tonemapped_bt709_ch = renodx::color::bt709::from::BT2020(tonemapped_bt2020_ch);

  // tonemapped_bt709_ch = lerp(tonemapped_bt709_ch, tonemapped_bt709_lum, CUSTOM_SATURATION_CORRECTION);

  float3 hdr_color_bt709 = renodx::color::correct::Chrominance(tonemapped_bt709_lum, tonemapped_bt709_ch, 1.f, 0.f, 1);
  hdr_color_bt709 = renodx::color::correct::Hue(hdr_color_bt709, tonemapped_bt709_ch, 1, 1);

  // hdr_color_bt709 = PostTonemapSliders(hdr_color_bt709);

  return renodx::color::ap1::from::BT709(hdr_color_bt709);
}

#endif  // SRC_MHWILDS_POSTPROCESS_HLSL_
