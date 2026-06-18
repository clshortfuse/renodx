#ifndef SRC_GAMES_STARFIELD_TONEMAPPER_COMMON_HLSLI_
#define SRC_GAMES_STARFIELD_TONEMAPPER_COMMON_HLSLI_

#include "../shared.h"

static const float STARFIELD_TONEMAP_MID_GRAY = 0.18f;
static const float STARFIELD_PSYCHOV_NEUTRAL_EYE_AVERAGE = 0.18f;
static const float STARFIELD_TONEMAP_HABLE_MAX_BLEND = 0.9999899864196777f;
static const float STARFIELD_TONEMAP_HABLE_INPUT_OFFSET = 0.9999998807907104f;

struct StarfieldVanillaTonemapParams {
  float mode;
  float aces_param_00;
  float aces_param_01;
  float hable_toe_strength;
  float hable_toe_length;
  float hable_shoulder_strength;
  float hable_shoulder_length;
  float hable_shoulder_angle;
};

StarfieldVanillaTonemapParams StarfieldCreateVanillaTonemapParams(
    float mode,
    float aces_param_00,
    float aces_param_01,
    float hable_toe_strength,
    float hable_toe_length,
    float hable_shoulder_strength,
    float hable_shoulder_length,
    float hable_shoulder_angle) {
  StarfieldVanillaTonemapParams params;
  params.mode = mode;
  params.aces_param_00 = aces_param_00;
  params.aces_param_01 = aces_param_01;
  params.hable_toe_strength = hable_toe_strength;
  params.hable_toe_length = hable_toe_length;
  params.hable_shoulder_strength = hable_shoulder_strength;
  params.hable_shoulder_length = hable_shoulder_length;
  params.hable_shoulder_angle = hable_shoulder_angle;
  return params;
}

struct StarfieldVanillaHableCurve {
  float toe_input;
  float toe_output;
  float linear_range;
  float input_scale;
  float toe_end;
  float shoulder_start;
  float shoulder_length;
  float linear_slope;
  float linear_slope_safe;
  float toe_output_safe;
  float peak_output;
  float toe_power;
  float shoulder_input_range;
  float shoulder_output_range;
  float shoulder_power;
  float shoulder_log_offset;
  float output_black_offset;
  float output_scale;
};

StarfieldVanillaHableCurve StarfieldCreateVanillaHableCurve(StarfieldVanillaTonemapParams params) {
  float toe_strength = saturate(params.hable_toe_strength);
  float toe_length = saturate(params.hable_toe_length);
  float shoulder_strength = max(0.f, params.hable_shoulder_strength);
  float shoulder_length = min(STARFIELD_TONEMAP_HABLE_MAX_BLEND, max(renodx::math::FLT_EPSILON, saturate(params.hable_shoulder_length)));
  float shoulder_angle = saturate(params.hable_shoulder_angle);

  StarfieldVanillaHableCurve curve;
  curve.toe_input = exp2(log2(toe_length) * 2.2f) * 0.5f;
  curve.toe_output = (1.f - toe_strength) * curve.toe_input;
  float output_after_toe = 1.f - curve.toe_output;
  curve.linear_range = (1.f - shoulder_length) * output_after_toe;
  curve.input_scale = ((curve.toe_input - STARFIELD_TONEMAP_HABLE_INPUT_OFFSET) + output_after_toe) + exp2(shoulder_strength);

  curve.toe_end = curve.toe_input / curve.input_scale;
  curve.shoulder_start = (curve.linear_range + curve.toe_input) / curve.input_scale;
  curve.shoulder_length = (((shoulder_strength * 2.f) * shoulder_angle) * curve.input_scale) / curve.input_scale;

  float normalized_linear_range = curve.linear_range / curve.input_scale;
  curve.linear_slope = select(abs(normalized_linear_range) < renodx::math::FLT_EPSILON, 1.f, curve.linear_range / normalized_linear_range);
  curve.linear_slope_safe = curve.linear_slope + renodx::math::FLT_EPSILON;
  curve.toe_output_safe = max(renodx::math::FLT_EPSILON, curve.toe_output);
  curve.peak_output = exp2(log2(((shoulder_strength * 0.5f) * shoulder_angle) + 1.f));
  curve.toe_power = (curve.linear_slope_safe * curve.toe_end) / (curve.toe_output_safe + renodx::math::FLT_EPSILON);

  curve.shoulder_input_range = (1.f - curve.shoulder_start) + curve.shoulder_length;
  curve.shoulder_output_range = curve.peak_output - (curve.linear_range + curve.toe_output);
  curve.shoulder_power = (curve.linear_slope_safe * curve.shoulder_input_range) / (curve.shoulder_output_range + renodx::math::FLT_EPSILON);
  curve.shoulder_log_offset = log(curve.shoulder_output_range) - (curve.shoulder_power * log(curve.shoulder_input_range));
  curve.output_black_offset = (curve.shoulder_length > 0.f)
                                  ? (-0.f - exp((curve.shoulder_power * log(curve.shoulder_length)) + curve.shoulder_log_offset))
                                  : -0.f;
  curve.output_scale = 1.f / (curve.output_black_offset + curve.peak_output);
  return curve;
}

float StarfieldEvalHableScalar(float input_value, StarfieldVanillaHableCurve curve) {
  float y = max(0.f, input_value) / curve.input_scale;
  float out_value;

  if (y < curve.toe_end) {
    out_value = y > 0.f
                    ? exp((log(y) * curve.toe_power) + log(curve.toe_output_safe) - (curve.toe_power * log(curve.toe_end)))
                    : 0.f;
  } else if (y < curve.shoulder_start) {
    float linear_input = y + ((curve.toe_output - (curve.linear_slope * curve.toe_end)) / curve.linear_slope_safe);
    out_value = linear_input > 0.f ? exp2(log2(linear_input) + log2(curve.linear_slope_safe)) : 0.f;
  } else {
    float shoulder_input = (-1.f - curve.shoulder_length) + y;
    float shoulder_value = shoulder_input < -0.f
                               ? exp((curve.shoulder_power * log(-0.f - shoulder_input)) + curve.shoulder_log_offset)
                               : 0.f;
    out_value = curve.peak_output - shoulder_value;
  }

  return saturate(out_value * curve.output_scale);
}

float StarfieldEvalHableSlopeScalar(float input_value, StarfieldVanillaHableCurve curve) {
  float x = max(0.f, input_value);
  float y = x / curve.input_scale;
  float inv_norm = 1.f / (curve.output_black_offset + curve.peak_output);

  if (y < curve.toe_end) {
    if (y <= 0.f) return 0.f;
    float toe_output_safe = max(renodx::math::FLT_EPSILON, curve.toe_output);
    float toe_power = (curve.linear_slope_safe * curve.toe_end) / (toe_output_safe + renodx::math::FLT_EPSILON);
    float raw_value = toe_output_safe * pow(y / curve.toe_end, toe_power);
    float scaled_value = raw_value * inv_norm;
    if (scaled_value <= 0.f || scaled_value >= 1.f) return 0.f;
    return (raw_value * toe_power / x) * inv_norm;
  }

  if (y < curve.shoulder_start) {
    float raw_value = curve.linear_slope_safe * (y + ((curve.toe_output - (curve.linear_slope * curve.toe_end)) / curve.linear_slope_safe));
    float scaled_value = raw_value * inv_norm;
    if (scaled_value <= 0.f || scaled_value >= 1.f) return 0.f;
    return (curve.linear_slope_safe / curve.input_scale) * inv_norm;
  }

  float shoulder_input = (-1.f - curve.shoulder_length) + y;
  if (shoulder_input >= 0.f) return 0.f;
  float shoulder_ratio = (-shoulder_input) / curve.shoulder_input_range;
  float raw_value = curve.peak_output - (curve.shoulder_output_range * pow(shoulder_ratio, curve.shoulder_power));
  float scaled_value = raw_value * inv_norm;
  if (scaled_value <= 0.f || scaled_value >= 1.f) return 0.f;
  return ((curve.shoulder_output_range * curve.shoulder_power * pow(shoulder_ratio, curve.shoulder_power - 1.f))
          / (curve.input_scale * curve.shoulder_input_range))
         * inv_norm;
}

float StarfieldEvalVanillaTonemapScalar(
    float input_value,
    StarfieldVanillaTonemapParams params) {
  float return_value;

  [branch]
  if (params.mode == 0.f) {
    return_value = saturate(max(0.f, input_value));
  } else if (params.mode == 1.f) {
    // ACES fitted.
    float x = max(0.f, input_value);
    float numerator = x * ((2.51f * x) + 0.03f);
    float denominator = 0.14f + (((x * 2.43f) + 0.59f) * x);
    return_value = saturate(numerator / denominator);
  } else if (params.mode == 2.f) {
    // ACES modified.
    float reference_input = max(params.aces_param_00, renodx::math::FLT_EPSILON);
    float denominator_bias = params.aces_param_01;
    float numerator_quadratic = ((0.56f / reference_input) + 2.43f) + (denominator_bias / (reference_input * reference_input));
    float x = max(0.f, input_value);
    float numerator = x * ((numerator_quadratic * x) + 0.03f);
    float denominator = denominator_bias + (((x * 2.43f) + 0.59f) * x);
    return_value = saturate(numerator / denominator);
  } else if (params.mode == 3.f) {
    return_value = StarfieldEvalHableScalar(input_value, StarfieldCreateVanillaHableCurve(params));
  } else {
    return_value = saturate(max(0.f, input_value));
  }

  return return_value;
}

float StarfieldComputeVanillaExponentialContrast(
    float reference_input,
    float reference_output,
    float reference_slope) {
  // Sensitometric-style contrast for PsychoV/Naka-Rushton:
  // d log(y) / d log(x) = x * f'(x) / f(x).
  // Callers pass a linear slope f'(x); this function does the log-slope conversion.
  return max(0.f, renodx::math::DivideSafe(reference_input * reference_slope, reference_output, 1.f));
}

float StarfieldEvalVanillaTonemapSlopeScalar(
    float input_value,
    StarfieldVanillaTonemapParams params) {
  float x = max(0.f, input_value);
  float return_value;

  [branch]
  if (params.mode == 0.f) {
    return_value = x > 0.f && x < 1.f ? 1.f : 0.f;
  } else if (params.mode == 1.f) {
    // ACES fitted first derivative.
    float numerator = x * ((2.51f * x) + 0.03f);
    float denominator = 0.14f + (((2.43f * x) + 0.59f) * x);
    float raw_value = numerator / denominator;

    if (raw_value <= 0.f || raw_value >= 1.f) {
      return_value = 0.f;
    } else {
      float numerator_slope = (5.02f * x) + 0.03f;
      float denominator_slope = (4.86f * x) + 0.59f;
      return_value = ((numerator_slope * denominator) - (numerator * denominator_slope))
                     / (denominator * denominator);
    }
  } else if (params.mode == 2.f) {
    // ACES modified first derivative.
    float reference_input = max(params.aces_param_00, renodx::math::FLT_EPSILON);
    float denominator_bias = params.aces_param_01;
    float numerator_quadratic = ((0.56f / reference_input) + 2.43f) + (denominator_bias / (reference_input * reference_input));
    float numerator = x * ((numerator_quadratic * x) + 0.03f);
    float denominator = denominator_bias + (((2.43f * x) + 0.59f) * x);
    if (denominator == 0.f) {
      return_value = 0.f;
    } else {
      float raw_value = numerator / denominator;
      if (raw_value <= 0.f || raw_value >= 1.f) {
        return_value = 0.f;
      } else {
        float numerator_slope = (2.f * numerator_quadratic * x) + 0.03f;
        float denominator_slope = (4.86f * x) + 0.59f;
        return_value = ((numerator_slope * denominator) - (numerator * denominator_slope))
                       / (denominator * denominator);
      }
    }
  } else if (params.mode == 3.f) {
    return_value = StarfieldEvalHableSlopeScalar(input_value, StarfieldCreateVanillaHableCurve(params));
  } else {
    return_value = 0.f;
  }

  return return_value;
}

float StarfieldEvalVanillaTonemapSlopeDeltaScalar(
    float input_value,
    StarfieldVanillaTonemapParams params) {
  // Runtime-stable central difference for the linear slope f'(x).
  // The original 0.0001 step is too small after Hable's exp/log reconstruction.
  float x = max(0.f, input_value);
  float delta = max(0.005f, x * 0.01f);
  float lower_input = max(0.f, x - delta);
  float upper_input = x + delta;
  float lower_output = StarfieldEvalVanillaTonemapScalar(lower_input, params);
  float upper_output = StarfieldEvalVanillaTonemapScalar(upper_input, params);
  return renodx::math::DivideSafe(upper_output - lower_output, upper_input - lower_input, 0.f);
}

float StarfieldEstimateVanillaTonemapInputForOutput(
    float target_output,
    float anchor_input,
    float anchor_output) {
  // Ratio estimate for tonemappers without an exact inverse.
  return target_output * renodx::math::DivideSafe(anchor_input, anchor_output, 1.f);
}

float StarfieldSolvePositiveQuadraticRoot(float a, float b, float c, float fallback_input) {
  if (abs(a) < renodx::math::FLT_EPSILON) {
    if (abs(b) < renodx::math::FLT_EPSILON) return fallback_input;
    float linear_root = -c / b;
    return linear_root > 0.f ? linear_root : fallback_input;
  }

  float discriminant = (b * b) - (4.f * a * c);
  if (discriminant < 0.f) return fallback_input;

  float sqrt_discriminant = sqrt(discriminant);
  float denominator = 2.f * a;
  float root_0 = (-b - sqrt_discriminant) / denominator;
  float root_1 = (-b + sqrt_discriminant) / denominator;
  float root = root_0 > 0.f ? root_0 : root_1;
  root = root_1 > 0.f && (root <= 0.f || root_1 < root) ? root_1 : root;
  return root > 0.f ? root : fallback_input;
}

float StarfieldSolveRationalTonemapInputForOutput(
    float target_output,
    float numerator_quadratic,
    float numerator_linear,
    float denominator_quadratic,
    float denominator_linear,
    float denominator_bias,
    float fallback_input) {
  float a = (target_output * denominator_quadratic) - numerator_quadratic;
  float b = (target_output * denominator_linear) - numerator_linear;
  float c = target_output * denominator_bias;
  return StarfieldSolvePositiveQuadraticRoot(a, b, c, fallback_input);
}

float StarfieldSolveHableTonemapInputForOutput(
    float target_output,
    StarfieldVanillaHableCurve curve,
    float fallback_input) {
  float target_raw_output = saturate(target_output) / curve.output_scale;
  float linear_start_output = curve.toe_output;
  float shoulder_start_output = curve.toe_output + curve.linear_range;
  float normalized_input;

  if (target_raw_output < linear_start_output) {
    normalized_input = target_raw_output > 0.f
                           ? curve.toe_end * pow(target_raw_output / curve.toe_output_safe, 1.f / curve.toe_power)
                           : 0.f;
  } else if (target_raw_output < shoulder_start_output) {
    float linear_offset = (curve.toe_output - (curve.linear_slope * curve.toe_end)) / curve.linear_slope_safe;
    normalized_input = (target_raw_output / curve.linear_slope_safe) - linear_offset;
  } else {
    float shoulder_output = max(0.f, curve.peak_output - target_raw_output);
    float shoulder_ratio = pow(
        shoulder_output / curve.shoulder_output_range,
        1.f / curve.shoulder_power);
    normalized_input = (1.f + curve.shoulder_length) - (shoulder_ratio * curve.shoulder_input_range);
  }

  float solved_input = normalized_input * curve.input_scale;
  return solved_input > 0.f ? solved_input : fallback_input;
}

float StarfieldSolveVanillaTonemapInputForOutput(
    float target_output,
    float fallback_input,
    StarfieldVanillaTonemapParams params) {
  float return_value;

  [branch]
  if (params.mode == 0.f) {
    return_value = saturate(target_output);
  } else if (params.mode == 1.f) {
    return_value = StarfieldSolveRationalTonemapInputForOutput(
        target_output,
        2.51f,
        0.03f,
        2.43f,
        0.59f,
        0.14f,
        fallback_input);
  } else if (params.mode == 2.f) {
    float reference_input = max(params.aces_param_00, renodx::math::FLT_EPSILON);
    float denominator_bias = params.aces_param_01;
    float numerator_quadratic = ((0.56f / reference_input) + 2.43f) + (denominator_bias / (reference_input * reference_input));
    return_value = StarfieldSolveRationalTonemapInputForOutput(
        target_output,
        numerator_quadratic,
        0.03f,
        2.43f,
        0.59f,
        denominator_bias,
        fallback_input);
  } else if (params.mode == 3.f) {
    return_value = StarfieldSolveHableTonemapInputForOutput(
        target_output,
        StarfieldCreateVanillaHableCurve(params),
        fallback_input);
  } else {
    return_value = fallback_input;
  }

  return return_value;
}

// Reference point for the optional extended-vanilla RenoDRT method.
// This is not PsychoV's midgray anchor; Hable uses the shoulder start (B1)
// so highlights extend along the vanilla linear section.
float StarfieldResolveVanillaExtensionReferenceInput(
    StarfieldVanillaTonemapParams params) {
  float return_value;

  [branch]
  if (params.mode == 1.f) {
    return_value = 0.120305923f;
  } else if (params.mode == 2.f) {
    return_value = max(params.aces_param_00, renodx::math::FLT_EPSILON);
  } else if (params.mode == 3.f) {
    StarfieldVanillaHableCurve curve = StarfieldCreateVanillaHableCurve(params);
    return_value = curve.toe_input + curve.linear_range;
  } else {
    return_value = STARFIELD_TONEMAP_MID_GRAY;
  }

  return return_value;
}

struct StarfieldVanillaTonemapReference {
  // input/output identify the vanilla point PsychoV should preserve.
  // slope is linear f'(input); exposure is output/input; contrast is x*f'(x)/f(x).
  float input;
  float output;
  float slope;
  float exposure;
  float contrast;
};

StarfieldVanillaTonemapReference StarfieldResolvePsychoVVanillaReference(
    float vanilla_midgray_output,
    StarfieldVanillaTonemapParams params) {
  float reference_input = STARFIELD_TONEMAP_MID_GRAY;

  [branch]
  if (CUSTOM_PSYCHOV_USE_VANILLA_MIDGRAY) {
    float estimated_input = StarfieldEstimateVanillaTonemapInputForOutput(
        STARFIELD_TONEMAP_MID_GRAY,
        STARFIELD_TONEMAP_MID_GRAY,
        vanilla_midgray_output);

    // Fixed/rational curves are cheap to invert, so the fast "Estimate" mode
    // only keeps the ratio shortcut for Hable unless the user asks for Solve.
    [branch]
    if (params.mode == 3.f && !CUSTOM_PSYCHOV_USE_VANILLA_MIDGRAY_SOLVE) {
      reference_input = estimated_input;
    } else {
      reference_input = StarfieldSolveVanillaTonemapInputForOutput(
          STARFIELD_TONEMAP_MID_GRAY,
          estimated_input,
          params);
    }
  } else {
    reference_input = STARFIELD_TONEMAP_MID_GRAY;
  }

  StarfieldVanillaTonemapReference reference;
  reference.input = reference_input;
  reference.output = StarfieldEvalVanillaTonemapScalar(reference.input, params);
  [branch]
  if (CUSTOM_PSYCHOV_USE_VANILLA_SLOPE) {
    [branch]
    if (CUSTOM_PSYCHOV_USE_VANILLA_SLOPE_FIRST_DERIVATIVE) {
      reference.slope = StarfieldEvalVanillaTonemapSlopeScalar(reference.input, params);
    } else {
      reference.slope = StarfieldEvalVanillaTonemapSlopeDeltaScalar(reference.input, params);
    }
    reference.contrast = StarfieldComputeVanillaExponentialContrast(reference.input, reference.output, reference.slope);
  } else {
    reference.slope = 0.f;
    reference.contrast = 1.f;
  }
  reference.exposure = renodx::math::DivideSafe(reference.output, reference.input, 1.f);
  return reference;
}

float StarfieldEvalVanillaTonemapExtendedScalar(
    float input_value,
    StarfieldVanillaTonemapParams params) {
  float reference_input;
  float reference_output;
  float slope;

  [branch]
  if (params.mode == 3.f) {
    StarfieldVanillaHableCurve curve = StarfieldCreateVanillaHableCurve(params);
    reference_input = curve.toe_input + curve.linear_range;
    reference_output = StarfieldEvalHableScalar(reference_input, curve);
    slope = (curve.linear_slope_safe / curve.input_scale)
            / (curve.output_black_offset + curve.peak_output);
  } else {
    reference_input = StarfieldResolveVanillaExtensionReferenceInput(params);
    reference_output = StarfieldEvalVanillaTonemapScalar(reference_input, params);
    slope = StarfieldEvalVanillaTonemapSlopeScalar(reference_input, params);
  }

  float base_value = StarfieldEvalVanillaTonemapScalar(input_value, params);
  float extended_value = reference_output + slope * (input_value - reference_input);
  return input_value > reference_input ? max(0.f, extended_value) : base_value;
}

renodx::lut::Config StarfieldCreateLutConfig(SamplerState lut_sampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lut_sampler;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.tetrahedral = CUSTOM_LUT_SAMPLING_IS_TETRAHEDRAL;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.size = 16u;
  lut_config.recolor = 0.f;
  return lut_config;
}

float3 StarfieldSampleLut(float3 srgb_color, renodx::lut::Config lut_config, Texture3D<float3> lut_texture) {
  return renodx::lut::Sample(srgb_color, lut_config, lut_texture);
}

float StarfieldComputeMidGrayAfterLut(float mid_gray_before_lut, renodx::lut::Config lut_config, Texture3D<float3> lut_texture) {
  float3 mid_gray_lut = StarfieldSampleLut(mid_gray_before_lut.xxx, lut_config, lut_texture);
  return renodx::color::y::from::BT709(mid_gray_lut);
}

float StarfieldResolvePsychoVConeResponseBaseline(float reference_input, float reference_output, float reference_slope) {
  float return_value;

  [branch]
  if (!CUSTOM_PSYCHOV_USE_VANILLA_SLOPE) {
    return_value = 1.f;
  } else {
    return_value = StarfieldComputeVanillaExponentialContrast(reference_input, reference_output, reference_slope);
  }

  return return_value;
}

float3 StarfieldApplyPostTonemapSceneGrade(
    float3 sdr_linear,
    float2 texcoord,
    renodx::lut::Config lut_config,
    Texture3D<float3> lut_texture,
    Texture2D<float> sdr_fx_texture,
    SamplerState sdr_fx_sampler);

// RenoDRT upgrade paths controlled by the Upgrade Method setting.
float3 StarfieldComputeUpgradedUntonemapped(
    float3 untonemapped,
    float3 vanilla_linear,
    float mid_gray,
    float2 texcoord,
    renodx::lut::Config lut_config,
    Texture3D<float3> lut_texture,
    Texture2D<float> sdr_fx_texture,
    SamplerState sdr_fx_sampler,
    StarfieldVanillaTonemapParams tonemap_params) {
  float3 n2_input = untonemapped * lerp(1.f, renodx::math::DivideSafe(mid_gray, STARFIELD_TONEMAP_MID_GRAY, 1.f), saturate(CUSTOM_N2_MIDGRAY_PRESCALE));
  float3 upgrade_target_linear = vanilla_linear;
  float3 return_value;

  [branch]
  if (CUSTOM_UPGRADE_METHOD_IS_NEUTWO_MAX_CHANNEL) {
    float3 neutral_sdr = n2_input * renodx::tonemap::neutwo::ComputeMaxChannelScale(n2_input).xxx;
    return_value = renodx::draw::ComputeUntonemappedGraded(n2_input, upgrade_target_linear, neutral_sdr);
  } else if (CUSTOM_UPGRADE_METHOD_IS_EXTENDED_VANILLA_N2) {
    float3 extended_vanilla = float3(
        StarfieldEvalVanillaTonemapExtendedScalar(untonemapped.r, tonemap_params),
        StarfieldEvalVanillaTonemapExtendedScalar(untonemapped.g, tonemap_params),
        StarfieldEvalVanillaTonemapExtendedScalar(untonemapped.b, tonemap_params));
    extended_vanilla = renodx::color::correct::Hue(extended_vanilla, untonemapped, 1.f);
    float max_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(extended_vanilla);
    float3 neutral_sdr = extended_vanilla * max_scale.xxx;
    float3 graded_linear = StarfieldApplyPostTonemapSceneGrade(
        neutral_sdr,
        texcoord,
        lut_config,
        lut_texture,
        sdr_fx_texture,
        sdr_fx_sampler);
    return_value = renodx::math::DivideSafe(graded_linear, max_scale.xxx, graded_linear);
  } else if (CUSTOM_UPGRADE_METHOD_IS_NEUTWO_LUMINANCE) {
    float3 neutral_sdr = n2_input * renodx::tonemap::neutwo::ComputeBT709Scale(n2_input).xxx;
    return_value = renodx::draw::ComputeUntonemappedGraded(n2_input, upgrade_target_linear, neutral_sdr);
  } else if (CUSTOM_UPGRADE_METHOD_IS_NEUTWO_PER_CHANNEL) {
    float3 neutral_sdr = renodx::tonemap::neutwo::PerChannel(n2_input);
    return_value = renodx::draw::ComputeUntonemappedGraded(n2_input, upgrade_target_linear, neutral_sdr);
  } else {
    return_value = renodx::draw::ComputeUntonemappedGraded(untonemapped * mid_gray / STARFIELD_TONEMAP_MID_GRAY, upgrade_target_linear);
  }

  return return_value;
}

float3 StarfieldRenoDRTPass(
    float3 untonemapped,
    float3 vanilla_linear,
    float mid_gray,
    float2 texcoord,
    renodx::lut::Config lut_config,
    Texture3D<float3> lut_texture,
    Texture2D<float> sdr_fx_texture,
    SamplerState sdr_fx_sampler,
    StarfieldVanillaTonemapParams tonemap_params) {
  return renodx::draw::ToneMapPass(StarfieldComputeUpgradedUntonemapped(
      untonemapped,
      vanilla_linear,
      mid_gray,
      texcoord,
      lut_config,
      lut_texture,
      sdr_fx_texture,
      sdr_fx_sampler,
      tonemap_params));
}

float3 StarfieldPsychoVTest17(
    float3 untonemapped_bt709,
    float mid_gray_scale,
    float current_average,
    float target_average,
    bool is_sdr,
    float psychov_cone_response_baseline);

float4 StarfieldResolvePsychoVEyeAdaptation() {
  float current_average = STARFIELD_PSYCHOV_NEUTRAL_EYE_AVERAGE;
  float target_average = STARFIELD_PSYCHOV_NEUTRAL_EYE_AVERAGE;
  float raw_target_average = STARFIELD_PSYCHOV_NEUTRAL_EYE_AVERAGE;
  float exposure_gain = 1.f;
  float4 return_value;

  [branch]
  if (!CUSTOM_EYE_ADAPTATION_PERCEPTUAL || !CUSTOM_EYE_ADAPTATION_HAS_DATA) {
    return_value = float4(
        current_average,
        target_average,
        raw_target_average,
        exposure_gain);
  } else {
    current_average = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_CURRENT_AVG_OFFSET);
    target_average = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_TARGET_AVG_OFFSET);
    raw_target_average = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_RAW_TARGET_OFFSET);
    exposure_gain = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_EXPOSURE_GAIN_OFFSET);

    float debug_eye_value = max(CUSTOM_DEBUG_VALUE, renodx::math::FLT_EPSILON);
    [branch]
    if (CUSTOM_DEBUG_FORCE_CURRENT && CUSTOM_DEBUG_FORCE_TARGET) {
      current_average = debug_eye_value;
      target_average = debug_eye_value;
      raw_target_average = debug_eye_value;
    } else if (CUSTOM_DEBUG_FORCE_CURRENT) {
      current_average = debug_eye_value;
    } else if (CUSTOM_DEBUG_FORCE_TARGET) {
      target_average = debug_eye_value;
      raw_target_average = debug_eye_value;
    } else {
      current_average = current_average;
    }
    exposure_gain = renodx::math::DivideSafe(target_average, current_average, exposure_gain);
    return_value = float4(
        current_average,
        max(target_average, renodx::math::FLT_EPSILON),
        max(raw_target_average, renodx::math::FLT_EPSILON),
        exposure_gain);
  }

  return return_value;
}

float3 StarfieldApplyPostTonemapSceneGrade(
    float3 sdr_linear,
    float2 texcoord,
    renodx::lut::Config lut_config,
    Texture3D<float3> lut_texture,
    Texture2D<float> sdr_fx_texture,
    SamplerState sdr_fx_sampler) {
  float3 return_value;

  [branch]
  if (CUSTOM_LUT_BLEND_MASK <= 0.f) {
    return_value = sdr_linear;
  } else {
    float3 sdr_input_gamma = renodx::color::srgb::EncodeSafe(sdr_linear);
    float3 lut_output_linear = StarfieldSampleLut(sdr_linear, lut_config, lut_texture);
    float3 lut_output_gamma = renodx::color::srgb::EncodeSafe(lut_output_linear);
    float lut_blend = sdr_fx_texture.Sample(sdr_fx_sampler, texcoord);
    float3 sdr_output_gamma = lerp(lut_output_gamma, sdr_input_gamma, lut_blend.xxx);
    float3 sdr_output_linear = renodx::color::srgb::DecodeSafe(sdr_output_gamma);
    return_value = lerp(sdr_linear, sdr_output_linear, saturate(CUSTOM_LUT_BLEND_MASK));
  }

  return return_value;
}

float3 StarfieldPsychoVPass(
    float3 untonemapped,
    float mid_gray,
    float mid_gray_scale,
    float vanilla_reference_input,
    float vanilla_reference_output,
    float vanilla_reference_slope,
    float current_average,
    float target_average,
    float2 texcoord,
    renodx::lut::Config lut_config,
    Texture3D<float3> lut_texture,
    Texture2D<float> sdr_fx_texture,
    SamplerState sdr_fx_sampler) {
  float psychov_cone_response_baseline = StarfieldResolvePsychoVConeResponseBaseline(vanilla_reference_input, vanilla_reference_output, vanilla_reference_slope);
  float3 psychov_hdr = StarfieldPsychoVTest17(
      untonemapped,
      mid_gray_scale,
      current_average,
      target_average,
      false,
      psychov_cone_response_baseline);
  float3 psychov_adaptive_state_lms = renodx::color::lms::from::BT709(max(mid_gray.xxx, renodx::math::FLT_EPSILON.xxx));
  float psychov_gamut_compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(
      psychov_hdr,
      psychov_adaptive_state_lms,
      1.f);
  float3 psychov_hdr_compressed = renodx::color::gamut::GamutCompressBT709AdaptiveD65(
      psychov_hdr,
      psychov_adaptive_state_lms,
      psychov_gamut_compression_scale);

  // Move to N2 max-channel SDR domain before shared SDR grading.
  float n2_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(psychov_hdr_compressed);
  float3 n2_sdr = psychov_hdr_compressed * n2_scale.xxx;
  float3 graded_linear = StarfieldApplyPostTonemapSceneGrade(
      n2_sdr,
      texcoord,
      lut_config,
      lut_texture,
      sdr_fx_texture,
      sdr_fx_sampler);

  // Return to HDR domain after SDR effects.
  float3 graded_hdr_compressed = renodx::math::DivideSafe(graded_linear, n2_scale.xxx, graded_linear);
  return renodx::color::gamut::GamutDecompressBT709AdaptiveD65(
      graded_hdr_compressed,
      psychov_adaptive_state_lms,
      psychov_gamut_compression_scale);
}

float4 StarfieldComputeVanillaTonemapDebugBreakpoints(
    StarfieldVanillaTonemapParams params) {
  float4 return_value;

  [branch]
  if (params.mode == 0.f) {
    return_value = float4(1.f, 1.f, 0.f, 0.f);
  } else if (params.mode == 1.f || params.mode == 2.f) {
    float breakpoint_0 = StarfieldResolveVanillaExtensionReferenceInput(params);
    return_value = float4(
        breakpoint_0,
        StarfieldEvalVanillaTonemapScalar(breakpoint_0, params),
        0.f,
        0.f);
  } else if (params.mode == 3.f) {
    StarfieldVanillaHableCurve curve = StarfieldCreateVanillaHableCurve(params);
    float breakpoint_0 = curve.toe_input;
    float breakpoint_1 = curve.linear_range + curve.toe_input;
    return_value = float4(
        breakpoint_0,
        StarfieldEvalVanillaTonemapScalar(breakpoint_0, params),
        breakpoint_1,
        StarfieldEvalVanillaTonemapScalar(breakpoint_1, params));
  } else {
    return_value = 0.f.xxxx;
  }

  return return_value;
}

#ifdef NDEBUG
float3 StarfieldDrawDebugCanvas(float3 color, float2 sv_position, float mid_gray_tonemap, float mid_gray_post_lut, float mid_gray_post_vanilla, float vanilla_midgray_slope,
                                float vanilla_midgray_shift,
                                float psychov_cone_baseline,
                                float psychov_cone_final,
                                float psychov_eye_current,
                                float psychov_eye_target,
                                float psychov_eye_raw_target,
                                float psychov_eye_gain,
                                float psychov_eye_min,
                                float psychov_eye_max,
                                float eye_histogram_ran,
                                float eye_adapt_ran,
                                float4 camera_values_0,
                                float4 camera_values_1,
                                float4 shdr_composite_0,
                                float4 shdr_composite_1,
                                float4 shdr_composite_2,
                                float4 debug_payload,
                                StarfieldVanillaTonemapParams tonemap_params) {
  return color;
}
#else
float StarfieldTonemapDebugSafe(float value, float fallback = 0.0f) {
  return (isnan(value) || isinf(value)) ? fallback : value;
}

float3 StarfieldDrawDebugCanvas(float3 color, float2 sv_position, float mid_gray_tonemap, float mid_gray_post_lut, float mid_gray_post_vanilla, float vanilla_midgray_slope,
                                float vanilla_midgray_shift,
                                float psychov_cone_baseline,
                                float psychov_cone_final,
                                float psychov_eye_current,
                                float psychov_eye_target,
                                float psychov_eye_raw_target,
                                float psychov_eye_gain,
                                float psychov_eye_min,
                                float psychov_eye_max,
                                float eye_histogram_ran,
                                float eye_adapt_ran,
                                float4 camera_values_0,
                                float4 camera_values_1,
                                float4 shdr_composite_0,
                                float4 shdr_composite_1,
                                float4 shdr_composite_2,
                                float4 debug_payload,
                                StarfieldVanillaTonemapParams tonemap_params) {
  [branch]
  if (!CUSTOM_DEBUG_ANY) return color;
  bool perceptual_resolve_tagged = CUSTOM_EYE_ADAPTATION_PERCEPTUAL && CUSTOM_EYE_ADAPTATION_RESOLVE_TAGGED;
  bool has_perceptual_history = CUSTOM_EYE_ADAPTATION_PERCEPTUAL && CUSTOM_EYE_ADAPTATION_HAS_DATA;
  bool show_perceptual_transport = CUSTOM_EYE_ADAPTATION_PERCEPTUAL;
  float perceptual_resolve_ready = perceptual_resolve_tagged ? 1.0f : 0.0f;
  float perceptual_has_data = has_perceptual_history ? 1.0f : 0.0f;
  float tonemap_midgray_in = 0.18f;
  float tonemap_midgray_out = max(StarfieldTonemapDebugSafe(mid_gray_tonemap), 0.0f);
  float lut_midgray_out = max(StarfieldTonemapDebugSafe(mid_gray_post_lut), 0.0f);
  float vanilla_midgray_out = max(StarfieldTonemapDebugSafe(mid_gray_post_vanilla), 0.0f);
  float tonemap_midgray_shift = renodx::math::DivideSafe(tonemap_midgray_out, tonemap_midgray_in, 1.0f);
  float lut_midgray_shift = renodx::math::DivideSafe(lut_midgray_out, tonemap_midgray_out, 1.0f);
  float sdr_fx_midgray_shift = renodx::math::DivideSafe(vanilla_midgray_out, lut_midgray_out, 1.0f);
  float total_midgray_shift = renodx::math::DivideSafe(vanilla_midgray_out, tonemap_midgray_in, 1.0f);
  float current_average = max(StarfieldTonemapDebugSafe(psychov_eye_current), 0.0f);
  float target_average = max(StarfieldTonemapDebugSafe(psychov_eye_target), 0.0f);
  float raw_target_average = max(StarfieldTonemapDebugSafe(psychov_eye_raw_target), 0.0f);
  float exposure_scalar = StarfieldTonemapDebugSafe(psychov_eye_gain, 1.0f);
  float user_exposure = StarfieldTonemapDebugSafe(RENODX_TONE_MAP_EXPOSURE, 1.0f);
  float exposure_scale = exposure_scalar * user_exposure;
  float target_ratio =
      (current_average > 0.0f && target_average > 0.0f)
          ? (target_average / current_average)
          : 0.0f;
  float prev_field = 0.0f;
  float prev_target = 0.0f;
  float prev_fast = 0.0f;
  float prev_slow = 0.0f;
  float histogram_ran_this_frame = StarfieldTonemapDebugSafe(eye_histogram_ran, 0.0f);
  float resolve_ran_this_frame = StarfieldTonemapDebugSafe(eye_adapt_ran, 0.0f);
  float histogram_had_run = StarfieldTonemapDebugSafe(CUSTOM_EYE_ADAPTATION_HISTOGRAM_HAD_RUN, 0.0f);
  float resolve_had_run = StarfieldTonemapDebugSafe(CUSTOM_EYE_ADAPTATION_RESOLVE_HAD_RUN, 0.0f);
  float vanilla_current_average = max(StarfieldTonemapDebugSafe(camera_values_0.z), 0.0f);
  float vanilla_exposure_gain;
  [branch]
  if (camera_values_0.y > 1.000000013351432e-10f) {
    vanilla_exposure_gain = camera_values_0.y;
  } else {
    vanilla_exposure_gain = renodx::math::DivideSafe(
        camera_values_0.z,
        max((camera_values_0.x * 1.2000000476837158f), 9.999999747378752e-05f),
        1.f);
  }
  vanilla_exposure_gain = StarfieldTonemapDebugSafe(min(max(vanilla_exposure_gain, camera_values_1.y), camera_values_1.z), 1.0f);
  float vanilla_target_average = vanilla_current_average * vanilla_exposure_gain;
  float resolve_field = 0.0f;
  float resolve_flags_raw = 0.0f;
  float resolve_gap = 0.0f;
  float history_valid_raw = 0.0f;
  float history_magic_raw = 0.0f;
  float history_magic_valid = 0.0f;
  float resolve_flags = 0.0f;
  float resolve_flag_transport = 0.0f;
  float resolve_flag_filtered = 0.0f;
  float resolve_flag_previous = 0.0f;
  float resolve_flag_previous_frame = 0.0f;
  float resolve_flag_continuity = 0.0f;
  float resolve_flag_baseline = 0.0f;
  float resolve_flag_predicted = 0.0f;
  float resolve_flag_histogram_usable = 0.0f;
  float resolve_flag_freeze = 0.0f;
  float resolve_flag_vanilla_hdr_reset = 0.0f;
  float resolve_flag_black_reset = 0.0f;
  float expected_u3_current_average = 0.0f;
  float vanilla_hdr_min_log2 = 0.0f;
  float vanilla_hdr_max_log2 = 0.0f;
  float vanilla_hdr_range_log2 = 0.0f;
  float vanilla_current_gap = 0.0f;
  float vanilla_current_is_exact_18 = 0.0f;
  float4 vanilla_breakpoints = StarfieldComputeVanillaTonemapDebugBreakpoints(tonemap_params);
  float vanilla_breakpoint_0_input = max(StarfieldTonemapDebugSafe(vanilla_breakpoints.x), 0.0f);
  float vanilla_breakpoint_0_output = max(StarfieldTonemapDebugSafe(vanilla_breakpoints.y), 0.0f);
  float vanilla_breakpoint_1_input = max(StarfieldTonemapDebugSafe(vanilla_breakpoints.z), 0.0f);
  float vanilla_breakpoint_1_output = max(StarfieldTonemapDebugSafe(vanilla_breakpoints.w), 0.0f);
  StarfieldVanillaTonemapReference psychov_vanilla_reference = StarfieldResolvePsychoVVanillaReference(
      tonemap_midgray_out,
      tonemap_params);
  float vanilla_reference_input = psychov_vanilla_reference.input;
  float vanilla_reference_output = psychov_vanilla_reference.output;
  float psychov_midgray_estimate_input = StarfieldEstimateVanillaTonemapInputForOutput(
      STARFIELD_TONEMAP_MID_GRAY,
      STARFIELD_TONEMAP_MID_GRAY,
      tonemap_midgray_out);
  float psychov_midgray_scale_estimate = renodx::math::DivideSafe(
      StarfieldEvalVanillaTonemapScalar(psychov_midgray_estimate_input, tonemap_params),
      psychov_midgray_estimate_input,
      1.0f);
  float psychov_midgray_solve_input = StarfieldSolveVanillaTonemapInputForOutput(
      STARFIELD_TONEMAP_MID_GRAY,
      psychov_midgray_estimate_input,
      tonemap_params);
  float psychov_midgray_scale_solve = renodx::math::DivideSafe(
      StarfieldEvalVanillaTonemapScalar(psychov_midgray_solve_input, tonemap_params),
      psychov_midgray_solve_input,
      1.0f);
  float psychov_midgray_scale_off = 1.0f;
  float psychov_midgray_mode;
  [branch]
  if (CUSTOM_PSYCHOV_USE_VANILLA_MIDGRAY) {
    [branch]
    if (CUSTOM_PSYCHOV_USE_VANILLA_MIDGRAY_SOLVE) {
      psychov_midgray_mode = 2.0f;
    } else {
      psychov_midgray_mode = 1.0f;
    }
  } else {
    psychov_midgray_mode = 0.0f;
  }

  float psychov_midgray_scale_selected;
  [branch]
  if (CUSTOM_EYE_ADAPTATION_PERCEPTUAL) {
    [branch]
    if (CUSTOM_PSYCHOV_USE_VANILLA_MIDGRAY) {
      psychov_midgray_scale_selected = psychov_vanilla_reference.exposure;
    } else {
      psychov_midgray_scale_selected = 1.0f;
    }
  } else {
    psychov_midgray_scale_selected = total_midgray_shift;
  }
  [branch]
  if (show_perceptual_transport) {
    history_valid_raw = StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_VALID_OFFSET));
    history_magic_raw = StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_MAGIC_OFFSET));
    history_magic_valid = abs(history_magic_raw - RENODX_EYE_ADAPTATION_HISTORY_MAGIC_EXPECTED) < 0.125f ? 1.0f : 0.0f;
    prev_field = StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_PREV_FIELD_OFFSET));
    prev_target = StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_PREV_TARGET_OFFSET));
    prev_fast = StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_PREV_FAST_OFFSET));
    prev_slow = StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_PREV_SLOW_OFFSET));
    resolve_field = StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_DEBUG_FIELD_OFFSET));
    resolve_flags_raw = StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_FLAGS_OFFSET));
    resolve_gap = StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_GAP_OFFSET));
    resolve_flags = floor(resolve_flags_raw + 0.5f);
    resolve_flag_transport = fmod(floor(resolve_flags / float(RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_TRANSPORT_HISTORY)), 2.0f);
    resolve_flag_filtered = fmod(floor(resolve_flags / float(RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_FILTERED_TARGET)), 2.0f);
    resolve_flag_previous = fmod(floor(resolve_flags / float(RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_PREVIOUS_FIELD_VALID)), 2.0f);
    resolve_flag_previous_frame = fmod(floor(resolve_flags / float(RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_PREVIOUS_FRAME_VALID)), 2.0f);
    resolve_flag_continuity = fmod(floor(resolve_flags / float(RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_TEMPORAL_CONTINUITY)), 2.0f);
    resolve_flag_baseline = fmod(floor(resolve_flags / float(RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_BASELINE)), 2.0f);
    resolve_flag_predicted = fmod(floor(resolve_flags / float(RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_PREDICTED_FIELD_VALID)), 2.0f);
    resolve_flag_histogram_usable = fmod(floor(resolve_flags / float(RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_HISTOGRAM_USABLE)), 2.0f);
    resolve_flag_freeze = fmod(floor(resolve_flags / float(RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_FREEZE_TO_HISTORY)), 2.0f);
    resolve_flag_vanilla_hdr_reset = fmod(floor(resolve_flags / float(RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_VANILLA_HDR_RESET)), 2.0f);
    resolve_flag_black_reset = fmod(floor(resolve_flags / float(RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_BLACK_RESET)), 2.0f);
    expected_u3_current_average = max(StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_EXPECTED_U3_CURRENT_OFFSET)), 0.0f);
    vanilla_hdr_min_log2 = StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_DEBUG_HDR_MIN_OFFSET));
    vanilla_hdr_max_log2 = StarfieldTonemapDebugSafe(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_DEBUG_HDR_MAX_OFFSET));
    vanilla_hdr_range_log2 = vanilla_hdr_max_log2 - vanilla_hdr_min_log2;
    vanilla_current_gap = abs(vanilla_current_average - expected_u3_current_average);
    vanilla_current_is_exact_18 = abs(vanilla_current_average - 0.18f) < 0.0005f ? 1.0f : 0.0f;
  }
  float2 position = sv_position;
  float2 panel_min = float2(10.0f, 10.0f);
  float panel_height = show_perceptual_transport ? 484.0f : 326.0f;
  panel_height += CUSTOM_DEBUG_SHOW_TONEMAP_INFO ? 48.0f : 0.0f;
  float2 panel_max = float2(300.0f, panel_height);

  renodx::canvas::Context ctx = renodx::canvas::CreateContext(
      position,
      panel_min + float2(8.0f, 8.0f),
      float2(8.0f, 12.0f),
      color,
      1.0f,
      1.0f.xxx,
      1.0f,
      1.0f,
      renodx::canvas::MODE_NORMAL,
      0.0f,
      1.15f);

  renodx::canvas::SetColor(ctx, 0x101418, 0.96f, 1.0f);
  renodx::canvas::FillRect(ctx, panel_min, panel_max);

  renodx::canvas::SetColor(ctx, 0x3df58f, 1.0f, 1.0f);
  renodx::canvas::DrawText(ctx, 'P', '1', '7');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawText(ctx, 'A', 'E');
  renodx::canvas::NewLine(ctx);

  renodx::canvas::SetColor(ctx, 0xf5a97f, 1.0f, 1.0f);
  renodx::canvas::DrawText(ctx, 'T', 'M');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawText(ctx, 'I', '/', 'O', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
  renodx::canvas::DrawFloat(ctx, tonemap_midgray_in, 0.0f, 4.0f);
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, tonemap_midgray_out, 0.0f, 4.0f);
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, tonemap_midgray_shift, 0.0f, 4.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::SetColor(ctx, 0x7ec8e3, 1.0f, 1.0f);
  renodx::canvas::DrawText(ctx, 'L', 'U', 'T');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawText(ctx, 'I', '/', 'O', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
  renodx::canvas::DrawFloat(ctx, tonemap_midgray_out, 0.0f, 4.0f);
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, lut_midgray_out, 0.0f, 4.0f);
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, lut_midgray_shift, 0.0f, 4.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::SetColor(ctx, 0x91d7e3, 1.0f, 1.0f);
  renodx::canvas::DrawText(ctx, 'F', 'X');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawText(ctx, 'I', '/', 'O', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
  renodx::canvas::DrawFloat(ctx, lut_midgray_out, 0.0f, 4.0f);
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, vanilla_midgray_out, 0.0f, 4.0f);
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, sdr_fx_midgray_shift, 0.0f, 4.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::SetColor(ctx, 0xc6a0f6, 1.0f, 1.0f);
  renodx::canvas::DrawText(ctx, 'C', 'o', 'n', 'e', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
  renodx::canvas::DrawFloat(ctx, StarfieldTonemapDebugSafe(vanilla_midgray_slope), 0.0f, 4.0f);
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, StarfieldTonemapDebugSafe(psychov_cone_baseline), 0.0f, 4.0f);
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, StarfieldTonemapDebugSafe(psychov_cone_final), 0.0f, 4.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::SetColor(ctx, 0xa6da95, 1.0f, 1.0f);
  renodx::canvas::DrawText(ctx, 'N', 'e', 't', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
  renodx::canvas::DrawFloat(ctx, vanilla_midgray_out, 0.0f, 4.0f);
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, total_midgray_shift, 0.0f, 4.0f);
  renodx::canvas::NewLine(ctx);

  [branch]
  if (CUSTOM_DEBUG_SHOW_TONEMAP_INFO) {
    renodx::canvas::SetColor(ctx, 0xf5bde6, 1.0f, 1.0f);
    renodx::canvas::DrawText(ctx, 'V', 'M', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
    renodx::canvas::DrawFloat(ctx, (float)tonemap_params.mode, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'B', '0', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, vanilla_breakpoint_0_input, 0.0f, 4.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, vanilla_breakpoint_0_output, 0.0f, 4.0f);
    renodx::canvas::NewLine(ctx);

    if (vanilla_breakpoint_1_input > 0.0f || vanilla_breakpoint_1_output > 0.0f) {
      renodx::canvas::SetColor(ctx, 0xf5bde6, 1.0f, 1.0f);
      renodx::canvas::DrawText(ctx, 'B', '1', ':');
      renodx::canvas::InsertSpace(ctx);
      renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
      renodx::canvas::DrawFloat(ctx, vanilla_breakpoint_1_input, 0.0f, 4.0f);
      renodx::canvas::InsertSpace(ctx);
      renodx::canvas::DrawFloat(ctx, vanilla_breakpoint_1_output, 0.0f, 4.0f);
      renodx::canvas::NewLine(ctx);
    }

    renodx::canvas::SetColor(ctx, 0xf5bde6, 1.0f, 1.0f);
    renodx::canvas::DrawText(ctx, 'M', 'R', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
    renodx::canvas::DrawFloat(ctx, psychov_midgray_mode, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'S', 'e', 'l', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, psychov_midgray_scale_selected, 0.0f, 4.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::SetColor(ctx, 0xf5bde6, 1.0f, 1.0f);
    renodx::canvas::DrawText(ctx, 'M', '0', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
    renodx::canvas::DrawFloat(ctx, psychov_midgray_scale_off, 0.0f, 4.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::SetColor(ctx, 0xf5bde6, 1.0f, 1.0f);
    renodx::canvas::DrawText(ctx, 'M', 'E', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
    renodx::canvas::DrawFloat(ctx, psychov_midgray_scale_estimate, 0.0f, 4.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::SetColor(ctx, 0xf5bde6, 1.0f, 1.0f);
    renodx::canvas::DrawText(ctx, 'M', 'X', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
    renodx::canvas::DrawFloat(ctx, psychov_midgray_scale_solve, 0.0f, 4.0f);
    renodx::canvas::NewLine(ctx);
  }

  renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
  renodx::canvas::DrawText(ctx, 'E', 'x', 'p', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, exposure_scalar, 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'U', 's', 'r', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, user_exposure, 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'C', 'u', 'r', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, current_average, 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'T', 'g', 't', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, target_average, 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'R', 'a', 'w', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, raw_target_average, 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'M', 'i', 'n', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, StarfieldTonemapDebugSafe(psychov_eye_min), 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'M', 'a', 'x', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, StarfieldTonemapDebugSafe(psychov_eye_max), 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'C', 'u', 'r');
  renodx::canvas::DrawText(ctx, 'N', 'i', 't', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, current_average * RENODX_DIFFUSE_WHITE_NITS, 0.0f, 3.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'T', 'g', 't');
  renodx::canvas::DrawText(ctx, 'N', 'i', 't', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, target_average * RENODX_DIFFUSE_WHITE_NITS, 0.0f, 3.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'R', 'a', 't', 'i', 'o', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, StarfieldTonemapDebugSafe(target_ratio), 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'S', 'c', 'a', 'l', 'e', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, StarfieldTonemapDebugSafe(exposure_scale, 1.0f), 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'V', 'C', 'u', 'r', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, vanilla_current_average, 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'V', 'G', 'a', 'i', 'n', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, vanilla_exposure_gain, 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'V', 'T', 'g', 't', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawFloat(ctx, vanilla_target_average, 0.0f, 6.0f);
  renodx::canvas::NewLine(ctx);

  [branch]
  if (show_perceptual_transport) {
    renodx::canvas::DrawText(ctx, 'U', '3', 'C', 'u', 'r', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, expected_u3_current_average, 0.0f, 6.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::DrawText(ctx, 'V', 'G', 'a', 'p', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, vanilla_current_gap, 0.0f, 6.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'V', '1', '8', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, vanilla_current_is_exact_18, 0.0f, 0.0f);
    renodx::canvas::NewLine(ctx);
  }

  renodx::canvas::DrawText(ctx, 'R', 'u', 'n', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawText(ctx, 'H');
  renodx::canvas::DrawFloat(ctx, histogram_ran_this_frame, 0.0f, 0.0f);
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawText(ctx, 'R');
  renodx::canvas::DrawFloat(ctx, resolve_ran_this_frame, 0.0f, 0.0f);
  renodx::canvas::NewLine(ctx);

  renodx::canvas::DrawText(ctx, 'H', 'a', 'd', ':');
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawText(ctx, 'H');
  renodx::canvas::DrawFloat(ctx, histogram_had_run, 0.0f, 0.0f);
  renodx::canvas::InsertSpace(ctx);
  renodx::canvas::DrawText(ctx, 'R');
  renodx::canvas::DrawFloat(ctx, resolve_had_run, 0.0f, 0.0f);

  [branch]
  if (show_perceptual_transport) {
    renodx::canvas::NewLine(ctx);
    renodx::canvas::SetColor(ctx, 0x7ec8e3, 1.0f, 1.0f);
    renodx::canvas::DrawText(ctx, 'H', 'i', 's', 't');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'S', 't', 'a', 't', 'e');
    renodx::canvas::NewLine(ctx);

    renodx::canvas::SetColor(ctx, 0xd8dde3, 1.0f, 1.0f);
    renodx::canvas::DrawText(ctx, 'D', 'a', 't', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'D');
    renodx::canvas::DrawFloat(ctx, perceptual_has_data, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'C');
    renodx::canvas::DrawFloat(ctx, perceptual_resolve_ready, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'V');
    renodx::canvas::DrawFloat(ctx, history_valid_raw, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'M');
    renodx::canvas::DrawFloat(ctx, history_magic_valid, 0.0f, 0.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::DrawText(ctx, 'M', 'a', 'g', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, history_magic_raw, 0.0f, 2.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::DrawText(ctx, 'F', 'l', 'd', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, prev_field, 0.0f, 6.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::DrawText(ctx, 'F', 'i', 'l', 't', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, prev_target, 0.0f, 6.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::DrawText(ctx, 'F', 'a', 's', 't', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, prev_fast, 0.0f, 6.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::DrawText(ctx, 'S', 'l', 'o', 'w', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, prev_slow, 0.0f, 6.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::DrawText(ctx, 'F', 'l', 'd', 'Y', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, resolve_field, 0.0f, 6.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::DrawText(ctx, 'G', 'a', 'p', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, resolve_gap, 0.0f, 6.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::DrawText(ctx, 'H', 'D', 'R', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, vanilla_hdr_min_log2, 0.0f, 2.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, vanilla_hdr_max_log2, 0.0f, 2.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawFloat(ctx, vanilla_hdr_range_log2, 0.0f, 2.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'Z');
    renodx::canvas::DrawFloat(ctx, resolve_flag_vanilla_hdr_reset, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'B');
    renodx::canvas::DrawFloat(ctx, resolve_flag_black_reset, 0.0f, 0.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::DrawText(ctx, 'S', 'r', 'c', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'T');
    renodx::canvas::DrawFloat(ctx, resolve_flag_transport, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'F');
    renodx::canvas::DrawFloat(ctx, resolve_flag_filtered, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'P');
    renodx::canvas::DrawFloat(ctx, resolve_flag_previous, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'R');
    renodx::canvas::DrawFloat(ctx, resolve_flag_previous_frame, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'C');
    renodx::canvas::DrawFloat(ctx, resolve_flag_continuity, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'B');
    renodx::canvas::DrawFloat(ctx, resolve_flag_baseline, 0.0f, 0.0f);
    renodx::canvas::NewLine(ctx);

    renodx::canvas::DrawText(ctx, 'S', 'o', 'l', 'v', ':');
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'U');
    renodx::canvas::DrawFloat(ctx, resolve_flag_histogram_usable, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'Z');
    renodx::canvas::DrawFloat(ctx, resolve_flag_freeze, 0.0f, 0.0f);
    renodx::canvas::InsertSpace(ctx);
    renodx::canvas::DrawText(ctx, 'D');
    renodx::canvas::DrawFloat(ctx, resolve_flag_predicted, 0.0f, 0.0f);
  }

  float4 canvas_output = renodx::canvas::GetOutput(ctx);
  return lerp(color, canvas_output.rgb, canvas_output.a);
}
#endif

float3 StarfieldPsychoVTest17(
    float3 untonemapped_bt709,
    float mid_gray_scale,
    float current_average = 0.18f,
    float target_average = 0.18f,
    bool is_sdr = false,
    float psychov_cone_response_baseline = 1.f) {
  float calculated_peak = is_sdr ? 1.f : (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  float3 bt709_scene = untonemapped_bt709 * RENODX_TONE_MAP_EXPOSURE;

  bool has_valid_anchor = (current_average > 0.f) && (target_average > 0.f);
  float anchor_boost = has_valid_anchor ? (target_average / current_average) : 1.f;
  [branch]
  if (has_valid_anchor) {
    bt709_scene *= anchor_boost;
  }

  float3 lms_in = renodx::color::lms::from::BT709(bt709_scene);
  float yf_input = renodx::color::yf::from::LMS(lms_in);
  float yf_midgray = renodx::color::yf::from::BT709(0.18f);
  float yf_target = yf_input;

  [branch]
  if (RENODX_TONE_MAP_HIGHLIGHTS != 1.f) {
    yf_target = renodx::color::grade::Highlights(yf_target, RENODX_TONE_MAP_HIGHLIGHTS, yf_midgray);
  }
  [branch]
  if (RENODX_TONE_MAP_SHADOWS != 1.f) {
    yf_target = renodx::color::grade::Shadows(yf_target, RENODX_TONE_MAP_SHADOWS, yf_midgray);
  }
  [branch]
  if (RENODX_TONE_MAP_CONTRAST != 1.f) {
    yf_target = renodx::color::grade::ContrastSafe(yf_target, RENODX_TONE_MAP_CONTRAST, yf_midgray);
  }

  yf_target *= mid_gray_scale;
  float yf_scale = renodx::math::DivideSafe(yf_target, yf_input, 1.f);
  bt709_scene *= yf_scale;
  [branch]
  if (has_valid_anchor) {
    bt709_scene /= anchor_boost;
  }

  float anchor_in = has_valid_anchor ? current_average : target_average;
  float anchor_out = target_average;
  float psychov_cone_response = max(0.f, psychov_cone_response_baseline) * max(0.f, CUSTOM_CONE_RESPONSE);

  return renodx::tonemap::psychov::psychotm_test17(
      bt709_scene,
      calculated_peak,
      1.f,
      1.f,
      1.f,
      1.f,
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_BLOWOUT,
      100.f,
      1.f,
      1.f,
      1,
      psychov_cone_response,
      anchor_in.xxx,
      anchor_out.xxx,
      1.f,
      is_sdr ? 0 : 1);
}

#endif
