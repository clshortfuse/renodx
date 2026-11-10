#ifndef RENODX_SHADERS_TONEMAP_PSYCHOV_TEST35_HLSL_
#define RENODX_SHADERS_TONEMAP_PSYCHOV_TEST35_HLSL_

#include "../../color/gamut.hlsl"

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 *
 * Offline experimental observer response and target-volume fit.
 * Input/output: extended linear BT.709, D65, reference-white-relative units.
 * Target: BT.709 for mode zero, otherwise BT.2020; output stays BT.709.
 * Input/output adaptation anchors are linear BT.709 signals, not fixed grays.
 * Source selection is retained for argument compatibility; transport is
 * already BT.709 and is converted directly without source-gamut contraction.
 *
 * Optional human-boundary conditioning consumes the original cone excursion.
 * It moves the boundary color along exposure using the local A/C speed trade,
 * then applies finite cone response and the Mean-A2 angular midpoint.
 * Enabled compensation floors unsupported input components after conditioning.
 * Disabled compensation trusts inputs and parameters, without repair or guards.
 * Undefined conditioning trades return quiet NaN.
 * Zero cones use the finite response's exact zero limit, not a signed policy.
 *
 * Default target fitting uses adaptation-relative Contrast Trade with exact
 * face contact (power zero denotes the infinite-power limit).
 * Zero power selects exact fitting. No Yf pivot is introduced.
 * None bypasses target fitting; RGB Clip independently clamps target channels.
 * gamut_fill selects exact faces instead of the rounded fit.
 * No exposure shift or contact search
 * is used by the public path. Legacy envelope functions remain diagnostic.
 * Containment assumes valid response parameters and an interior mean;
 * monotonicity of the fitted exposure trajectory is not guaranteed.
 * Only RGB Clip clamps channels. Zero cones have a nonwhite high-exposure limit.
 * Conditioning's zero-boundary interior guard is numerical, not physiology.
 */

namespace renodx {
namespace tonemap {
namespace psychov {

static const int PSYCHO35_SOURCE_BOUNDARY_NONE = 0;
static const int PSYCHO35_SOURCE_BOUNDARY_BT709 = 1;
static const int PSYCHO35_SOURCE_BOUNDARY_BT2020 = 2;
static const int PSYCHO35_SOURCE_BOUNDARY_AP1 = 3;

// Explicit transport data: BT.709/BT.2020 D65 and the Stockman-CVRL
// two-degree XYZ fit. Keep the observer basis paired with the boundary data.
static const float3x3 PSYCHO35_BT709_TO_XYZ = float3x3(
    .4123907993f, .3575843394f, .1804807884f,
    .2126390059f, .7151686788f, .0721923154f,
    .0193308187f, .1191947798f, .9505321522f);
static const float3x3 PSYCHO35_XYZ_TO_BT709 = float3x3(
    3.2409699419f, -1.5373831776f, -.4986107603f,
    -.9692436363f, 1.8759675015f, .0415550574f,
    .0556300797f, -.2039769589f, 1.0569715142f);
static const float3x3 PSYCHO35_XYZ_TO_BT2020 = float3x3(
    1.7166511880f, -.3556707838f, -.2533662814f,
    -.6666843518f, 1.6164812366f, .0157685458f,
    .0176398574f, -.0427706133f, .9421031212f);
static const float3x3 PSYCHO35_XYZ_TO_LMS = float3x3(
    .2670502842655792f, .8471990148492798f, -.03470416612462053f,
    -.38706882411220156f, 1.165429935890458f, .10302286696614202f,
    .026727793989083093f, -.02729131667566509f, .5333267257603284f);
static const float3x3 PSYCHO35_LMS_TO_XYZ = transpose(float3x3(
                                                cross(PSYCHO35_XYZ_TO_LMS[1], PSYCHO35_XYZ_TO_LMS[2]),
                                                cross(PSYCHO35_XYZ_TO_LMS[2], PSYCHO35_XYZ_TO_LMS[0]),
                                                cross(PSYCHO35_XYZ_TO_LMS[0], PSYCHO35_XYZ_TO_LMS[1])))
                                            / dot(PSYCHO35_XYZ_TO_LMS[0], cross(PSYCHO35_XYZ_TO_LMS[1], PSYCHO35_XYZ_TO_LMS[2]));
static const float3x3 PSYCHO35_BT709_TO_LMS_MAT = mul(PSYCHO35_XYZ_TO_LMS, PSYCHO35_BT709_TO_XYZ);
static const float3x3 PSYCHO35_LMS_TO_BT709_MAT = mul(PSYCHO35_XYZ_TO_BT709, PSYCHO35_LMS_TO_XYZ);
static const float3x3 PSYCHO35_LMS_TO_BT2020_MAT = mul(PSYCHO35_XYZ_TO_BT2020, PSYCHO35_LMS_TO_XYZ);
static const float3 PSYCHO35_YF_WEIGHTS = float3(.68990272f, .34832189f, 0.f);
static const float3 PSYCHO35_MB_WEIGHTS = float3(.68990272f, .34832189f, .0371597069161f);
static const float3 PSYCHO35_D65_WHITE_LMS = mul(PSYCHO35_BT709_TO_LMS_MAT, 1.f.xxx);
static const float PSYCHO35_D65_WHITE_YF = dot(PSYCHO35_YF_WEIGHTS, PSYCHO35_D65_WHITE_LMS);
static const float3 PSYCHO35_D65_ALPHA = PSYCHO35_YF_WEIGHTS * PSYCHO35_D65_WHITE_LMS / PSYCHO35_D65_WHITE_YF;
static const float2 PSYCHO35_MB_WHITE = (PSYCHO35_D65_WHITE_LMS * PSYCHO35_MB_WEIGHTS).xz / PSYCHO35_D65_WHITE_YF;

struct Psycho35Reference {
  float3 source_ratio;
  float3 log_source_ratio;
  float3 anchor_power;
  float3 input_exponent;
  float response_power;
  float response_compression;
  float peak;
  int target;
  float source_log_radius;
};

struct Psycho35Sample {
  float mean;
  float mean_derivative;
  float headroom;
  float3 residual;
  float3 derivative;
  bool midpoint;
};

// Exact mean on equal-component vectors; reused by reference and public path.
float psycho35_Mean(float3 v) {
  return v.x + ((v.y - v.x) + (v.z - v.x)) / 3.f;
}

// Diagnostic: direct evaluation, with the near-zero approximation disabled.
// Small x may round away in 1+x; retained temporarily for comparison.
float psycho35_Log1p(float x) {
  return log(1.f + x);
}

float3 psycho35_TargetResidual(float3 normalized_lms, int target) {
  float3 physical_lms = normalized_lms * PSYCHO35_D65_WHITE_LMS;
  return target == 0 ? mul(PSYCHO35_LMS_TO_BT709_MAT, physical_lms)
                     : mul(PSYCHO35_LMS_TO_BT2020_MAT, physical_lms);
}

// Log-domain evaluation of the SAME finite response for look-ahead and output.
// log_tail is log(1-u^h), not a subtraction from rounded u.
void psycho35_ResponseLogs(float log_q, float k, float n, float h,
                           out float log_u, out float log_tail, out float log_deficit) {
  float latent = log(k) - psycho35_Log1p(-k) + n * log_q;
  float correction = psycho35_Log1p(exp(-abs(latent)));
  log_u = (min(latent, 0.f) - correction) / h;
  log_tail = -max(latent, 0.f) - correction;
  // In this tail, 1-u = (1-u^h)/h to float precision. Keeping its
  // logarithm preserves direction even when u and its deficit underflow.
  log_deficit = latent > 20.f ? log_tail - log(h)
                            : log(abs(log_u) < .01f
                                      ? -log_u * (1.f + log_u * (.5f + log_u * (1.f / 6.f + log_u / 24.f)))
                                      : 1.f - exp(log_u));
}

// Public diagnostic reference stage, also used by constraint and RGB entry.
// Derivatives are with respect to input stops on a fixed branch/chart.
Psycho35Sample psycho35_ReferenceAt(Psycho35Reference reference, float exposure_stops) {
  Psycho35Sample sample;
  float3 response, deficit, response_derivative;
  [unroll] for (int i = 0; i < 3; ++i) {
    if (reference.source_ratio[i] == 0.f) {
      response[i] = 0.f;
      deficit[i] = 1.f;
      response_derivative[i] = 0.f;
    } else {
      float log_u, log_tail, log_deficit;
      psycho35_ResponseLogs(reference.log_source_ratio[i] + exposure_stops * log(2.f),
                  reference.anchor_power[i], reference.input_exponent[i],
                  reference.response_compression, log_u, log_tail, log_deficit);
      response[i] = exp(log_u);
      deficit[i] = exp(log_deficit);
      response_derivative[i] = log(2.f) * reference.input_exponent[i] / reference.response_compression * exp(log_u + log_tail);
    }
  }
  float response_mean = psycho35_Mean(response);
  float mean_derivative = psycho35_Mean(response_derivative);
  float3 response_residual = response_mean > .5f ? psycho35_Mean(deficit) - deficit : response - response_mean;
  float3 residual_derivative = response_derivative - mean_derivative;
  // Normalize before squaring: length(v) can underflow even when v itself
  // is representable. Keep tiny tail residuals on the same angular chart.
  float residual_scale = max(abs(response_residual.x), max(abs(response_residual.y), abs(response_residual.z)));
  float3 scaled_residual = residual_scale > 0.f ? response_residual / residual_scale : 0.f;
  float scaled_radius = length(scaled_residual);
  float radius = residual_scale * scaled_radius;
  float3 direction = scaled_radius > 0.f ? scaled_residual / scaled_radius : 0.f;
  float radius_derivative = dot(direction, residual_derivative);
  // Carry C * e' rather than e'. The final residual derivative needs this
  // product only, so there is no reason to divide by a vanishing C.
  float3 radius_times_direction_derivative = residual_derivative - direction * radius_derivative;
  float3 source = reference.source_ratio - psycho35_Mean(reference.source_ratio);
  float source_radius = length(source);
  // Exact neutral/zero-radius limits retain the unrotated response. There is
  // no exposure-dependent threshold switching off a nondegenerate midpoint.
  sample.midpoint = source_radius > 0.f && radius > 0.f;
  if (sample.midpoint) {
    float3 midpoint_direction = source / source_radius + direction;
    float midpoint_length = length(midpoint_direction);
    if (midpoint_length > 0.f) {
      direction = midpoint_direction / midpoint_length;
      radius_times_direction_derivative = (radius_times_direction_derivative
                   - direction * dot(direction, radius_times_direction_derivative)) / midpoint_length;
    } else {
      sample.midpoint = false;
    }
  }
  sample.mean = reference.peak * response_mean;
  sample.mean_derivative = reference.peak * mean_derivative;
  sample.headroom = reference.peak * psycho35_Mean(deficit);
  sample.residual = reference.peak * radius * direction;
  sample.derivative = reference.peak * (radius_derivative * direction + radius_times_direction_derivative);
  return sample;
}

// Exposure-dependent target-cube bounds and division-free contact equations.
float2 psycho35_BoundsAt(
    Psycho35Reference reference, float exposure_stops, float shift,
    out float3 upper_slope, out float3 lower_slope, out uint chart) {
  Psycho35Sample actual = psycho35_ReferenceAt(reference, exposure_stops);
  Psycho35Sample shifted = psycho35_ReferenceAt(reference, exposure_stops + shift);
  float3 target_residual = psycho35_TargetResidual(shifted.residual, reference.target);
  float3 target_derivative = psycho35_TargetResidual(shifted.derivative, reference.target);
  float2 bound = 1e30f;
  chart = (actual.midpoint ? 1u : 0u) + (shifted.midpoint ? 2u : 0u);
  upper_slope = 0.f;
  lower_slope = 0.f;
  if (actual.mean < 0.f || actual.headroom < 0.f) return -1.f;
  [unroll] for (int j = 0; j < 3; ++j) {
    // At a contact, eliminate lambda from the face and tangency equations.
    // Normalize all four terms together before multiplying: this changes
    // neither the roots nor their signs, and avoids divisions by A, headroom,
    // or a channel residual approaching zero.
    float available = target_residual[j] > 0.f ? actual.headroom : actual.mean;
    float normalization = max(max(abs(available), abs(actual.mean_derivative)),
                              max(abs(target_residual[j]), abs(target_derivative[j])));
    float4 contact = normalization > 0.f
                         ? float4(available, actual.mean_derivative, target_residual[j], target_derivative[j]) / normalization
                         : 0.f;
    if (target_residual[j] > 0.f) {
      bound.x = min(bound.x, actual.headroom / target_residual[j]);
      upper_slope[j] = contact.y * contact.z + contact.x * contact.w;
    } else if (target_residual[j] < 0.f) {
      bound.y = min(bound.y, actual.mean / -target_residual[j]);
      lower_slope[j] = contact.x * contact.w - contact.y * contact.z;
    }
  }
  return bound;
}

// Analytic black/white coefficient constraints, no finite tail substitution.
// Coefficients share a scale to avoid overflow at very small positive cones.
float2 psycho35_TailBounds(Psycho35Reference reference, float shift) {
  float rate = 1e30f;
  [unroll] for (int cone = 0; cone < 3; ++cone) {
    if (reference.source_ratio[cone] > 0.f) rate = min(rate, reference.input_exponent[cone]);
  }
  float3 white_logs, black_logs;
  [unroll] for (int j = 0; j < 3; ++j) {
    float logit = log(reference.anchor_power[j]) - psycho35_Log1p(-reference.anchor_power[j]);
    white_logs[j] = reference.source_ratio[j] > 0.f && reference.input_exponent[j] == rate ? -logit - reference.input_exponent[j] * reference.log_source_ratio[j] : -1e30f;
    black_logs[j] = reference.source_ratio[j] > 0.f && reference.input_exponent[j] == rate ? (logit + reference.input_exponent[j] * reference.log_source_ratio[j]) / reference.response_compression : -1e30f;
  }
  float3 white = exp(white_logs - max(white_logs.x, max(white_logs.y, white_logs.z)));
  float3 black = exp(black_logs - max(black_logs.x, max(black_logs.y, black_logs.z)));
  float white_mean = psycho35_Mean(white), black_mean = psycho35_Mean(black);
  float3 white_residual = white_mean - white, black_residual = black - black_mean;
  float3 source = reference.source_ratio - psycho35_Mean(reference.source_ratio);
  float source_radius = length(source);
  if (source_radius > 0.f) {
    float white_radius = length(white_residual), black_radius = length(black_residual);
    if (white_radius > 0.f) {
      float3 midpoint = source / source_radius + white_residual / white_radius;
      if (length(midpoint) > 0.f) white_residual = white_radius * normalize(midpoint);
    }
    if (black_radius > 0.f) {
      float3 midpoint = source / source_radius + black_residual / black_radius;
      if (length(midpoint) > 0.f) black_residual = black_radius * normalize(midpoint);
    }
  }
  float3 white_target_residual = psycho35_TargetResidual(white_residual, reference.target);
  float3 black_target_residual = psycho35_TargetResidual(black_residual, reference.target);
  float2 bound = 1e30f;
  if (any(reference.source_ratio == 0.f)) {
    float3 endpoint = float3(reference.source_ratio.x > 0.f ? 1.f : 0.f,
                 reference.source_ratio.y > 0.f ? 1.f : 0.f,
                 reference.source_ratio.z > 0.f ? 1.f : 0.f);
    float endpoint_mean = psycho35_Mean(endpoint);
    float3 residual = endpoint - endpoint_mean;
    float radius = length(residual);
    float3 direction = residual / radius;
    float3 source_residual = reference.source_ratio - psycho35_Mean(reference.source_ratio);
    float3 midpoint = normalize(source_residual) + direction;
    if (length(midpoint) > 0.f) direction = normalize(midpoint);
    float3 endpoint_rgb_residual = psycho35_TargetResidual(radius * direction, reference.target);
    [unroll] for (int cone = 0; cone < 3; ++cone) {
      if (endpoint_rgb_residual[cone] > 0.f) {
        bound.x = min(bound.x, (1.f - endpoint_mean) / endpoint_rgb_residual[cone]);
      } else if (endpoint_rgb_residual[cone] < 0.f) {
        bound.y = min(bound.y, endpoint_mean / -endpoint_rgb_residual[cone]);
      }
    }
  }
  [unroll] for (int i = 0; i < 3; ++i) {
    if (all(reference.source_ratio > 0.f) && white_target_residual[i] > 0.f) bound.x = min(bound.x, white_mean / white_target_residual[i] * exp2(rate * shift));
    if (black_target_residual[i] < 0.f) bound.y = min(bound.y, black_mean / -black_target_residual[i] * exp2(-rate / reference.response_compression * shift));
  }
  return bound;
}

// Public diagnostic envelope. Interior face contacts satisfy the analytic
// cross-multiplied face-contact equation == 0. Transition-seeded secant iterations
// replace the fixed exposure grid; the asymptotic constraints remain exact.
// This is a multistart numerical root solve, not a proof of root completeness.
float2 psycho35_Envelope(Psycho35Reference reference, float shift) {
  float2 bound = psycho35_TailBounds(reference, shift);
  [loop] for (int cone = 0; cone < 3; ++cone) {
    if (reference.source_ratio[cone] == 0.f) continue;
    float width = 1.f / (reference.input_exponent[cone] * log(2.f));
    float transition = -(log(reference.anchor_power[cone])
                         - psycho35_Log1p(-reference.anchor_power[cone])
                         + reference.input_exponent[cone] * reference.log_source_ratio[cone]) * width;
    [loop] for (int branch = 0; branch < 2; ++branch) {
      float seed = transition - (branch == 0 ? 0.f : shift);
      [loop] for (int channel = 0; channel < 3; ++channel) {
        [loop] for (int face = 0; face < 2; ++face) {
          float previous_t = seed - width;
          float t = seed;
          float3 upper, lower;
          uint chart;
          bound = min(bound, psycho35_BoundsAt(reference, previous_t, shift, upper, lower, chart));
          float previous_f = face == 0 ? upper[channel] : lower[channel];
          [loop] for (int iteration = 0; iteration < 16; ++iteration) {
            bound = min(bound, psycho35_BoundsAt(reference, t, shift, upper, lower, chart));
            float f = face == 0 ? upper[channel] : lower[channel];
            if (!isfinite(f) || f == 0.f) break;
            float difference = f - previous_f;
            if (difference == 0.f || !isfinite(difference)) break;
            // Trust region limits the numerical step, not the fitted curve.
            float step = clamp(f * (t - previous_t) / difference, -4.f * width, 4.f * width);
            previous_t = t;
            previous_f = f;
            t -= step;
            if (!isfinite(t) || abs(step) < 1e-5f * width) break;
          }
        }
      }
    }
  }
  return bound;
}

float3 psychotm_test35(
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float purity_scale = 1.f,
    float bleaching_intensity = 1.f,     // Reserved compatibility argument.
    float clip_point = 100.f,            // Reserved compatibility argument.
    float hue_restore = 1.f,             // Reserved compatibility argument.
    float encoded_response_power = 1.f,  // Reserved compatibility argument.
    int white_curve_mode = 0,            // Reserved compatibility argument.
    float cone_response_exponent = 1.f,
    float3 current_adaptive_state_bt709 = 0.18f,
    float3 current_background_state_bt709 = 0.18f,
    float gamut_compression = 1.f,
    int gamut_compression_mode = 0,
    float adaptive_normalization = 1.f,  // Reserved compatibility argument.
    float compression = 1.f,
    int source_boundary = PSYCHO35_SOURCE_BOUNDARY_BT709,
    bool human_gamut_conditioning = false,
    bool gamut_fill = false,
    int fit_mode = 2,  // 0: none, 1: RGB clip, 2: A exact, 3: A smooth, 4: contrast trade.
    float fit_power = 0.f) {  // Zero selects exact fitting; positive values set smooth-fit power.
  // The public signal is extended BT.709 regardless of source metadata.
  // Do not round-trip through a bounded RGB gamut or change its excursion.
  float3 input_lms = mul(PSYCHO35_BT709_TO_LMS_MAT, bt709_linear_input * exposure);
  float3 anchor_in = mul(PSYCHO35_BT709_TO_LMS_MAT, current_adaptive_state_bt709);
  float3 anchor_out = all(current_background_state_bt709 == current_adaptive_state_bt709)
                          ? anchor_in
                          : mul(PSYCHO35_BT709_TO_LMS_MAT, current_background_state_bt709);
  if (highlights != 1.f || shadows != 1.f) {
    float input_yf = dot(PSYCHO35_YF_WEIGHTS, input_lms);
    float anchor_yf = dot(PSYCHO35_YF_WEIGHTS, anchor_in);
    float graded_y = input_yf;
    if (highlights != 1.f) {
      float ratio = graded_y / anchor_yf;
      float blend = graded_y > anchor_yf ? saturate(log2(ratio) / log2(1.f / anchor_yf)) : 0.f;
      blend = blend * blend * blend * (blend * (blend * 6.f - 15.f) + 10.f);
      float shaped = pow(ratio, abs(highlights - 1.f));
      graded_y = highlights > 1.f ? graded_y * lerp(1.f, shaped, blend)
                                  : graded_y / lerp(1.f, shaped, blend);
    }
    if (shadows != 1.f) {
      float ratio = graded_y / anchor_yf;
      float blend = graded_y > anchor_yf * exp2(-4.f) ? saturate(log2(ratio) / -4.f) : 1.f;
      blend = blend * blend * blend * (blend * (blend * 6.f - 15.f) + 10.f);
      float target_y = shadows > 1.f
                           ? graded_y * (1.f - anchor_yf * anchor_yf) + anchor_yf * anchor_yf * anchor_yf * pow(ratio, 2.f - shadows)
                           : graded_y * (1.f + anchor_yf * anchor_yf) - anchor_yf * anchor_yf * anchor_yf * pow(ratio, shadows);
      graded_y = lerp(graded_y, target_y, blend);
    }
    if (input_yf != 0.f) input_lms *= graded_y / input_yf;
  }
  // Purity grading retains adaptation-relative physiological Yf. It is a
  // user control, not an implicit source-boundary contraction.
  float3 source_ratio = input_lms / anchor_in;
  if (purity_scale != contrast) {
    float neutral_ratio = dot(PSYCHO35_YF_WEIGHTS, input_lms) / dot(PSYCHO35_YF_WEIGHTS, anchor_in);
    float3 purity_direction = source_ratio - neutral_ratio;
    float purity_amount = purity_scale / contrast;
    // Purity extrapolation must not turn a valid cone input negative before
    // the logarithmic response. Bound the common amount, not individual cones;
    // this retains the grading ray and its adaptation-relative weighted mean.
    // Originally unsupported inputs still follow the conditioning policy below.
    if (all(source_ratio >= 0.f) && neutral_ratio > 0.f && purity_amount > 1.f) {
      [unroll] for (int cone = 0; cone < 3; ++cone) {
        if (purity_direction[cone] < 0.f) {
          purity_amount = min(purity_amount, neutral_ratio / -purity_direction[cone]);
        }
      }
      // The exact limiting cone is zero; max removes cancellation roundoff only.
      source_ratio = max(neutral_ratio + purity_amount * purity_direction, 0.f);
    } else {
      source_ratio = neutral_ratio + purity_amount * purity_direction;
    }
  }
  Psycho35Reference reference;
  reference.response_power = contrast * cone_response_exponent;
  float3 anchor_target = gamut_compression_mode == 0
                             ? mul(PSYCHO35_LMS_TO_BT709_MAT, anchor_in)
                             : mul(PSYCHO35_LMS_TO_BT2020_MAT, anchor_in);
  float neutral_yf_limit = peak_value * dot(PSYCHO35_YF_WEIGHTS, anchor_in)
                           / max(anchor_target.x, max(anchor_target.y, anchor_target.z));
  // Automatic compression retains the existing 3.7-log10 simultaneous-range
  // engineering setting, split equally above and below adaptation.
  reference.response_compression = compression == 0.f
                                       ? max(1.85f / log10(neutral_yf_limit / dot(PSYCHO35_YF_WEIGHTS, anchor_out)), 1.f)
                                       : compression;
  reference.peak = peak_value;
  reference.target = gamut_compression_mode;
  reference.anchor_power = pow(anchor_out / (PSYCHO35_D65_WHITE_LMS * reference.peak), reference.response_compression);
  reference.input_exponent = reference.response_power * reference.response_compression / (1.f - reference.anchor_power);
  if (all(source_ratio == 0.f)) return 0.f;
  if (human_gamut_conditioning) {
    // Condition the actual purity-adjusted response input. Physical LMS is
    // anchor_in*source_ratio; MB weights must not be applied to relative source_ratio alone.
    // Invalid domains return the entry point's explicit quiet-NaN sentinel.
    float mean_q = psycho35_Mean(source_ratio);
    if (!(mean_q > 0.f) || isinf(mean_q)) return asfloat(0x7fc00000u).xxx;
    float3 direction_q = source_ratio - mean_q;
    float3 origin_weighted = (anchor_in * mean_q) * PSYCHO35_MB_WEIGHTS;
    float3 direction_weighted = (anchor_in * direction_q) * PSYCHO35_MB_WEIGHTS;
    float origin_y = origin_weighted.x + origin_weighted.y;
    if (!(origin_y > 0.f) || isinf(origin_y)) return asfloat(0x7fc00000u).xxx;
    origin_weighted /= origin_y;
    direction_weighted /= origin_y;
    if (any(isnan(origin_weighted)) || any(isinf(origin_weighted))
        || any(isnan(direction_weighted)) || any(isinf(direction_weighted))) return asfloat(0x7fc00000u).xxx;
    float direction_y = direction_weighted.x + direction_weighted.y;
    float boundary_t = 1.f;
    // Homogeneous lift of the existing MB halfspaces. Normalization above
    // removes exposure scale; no pre-clipping of negative target cones.
    [unroll] for (int edge = 0; edge < renodx::color::gamut::CIE1702_EDGE_COUNT; ++edge) {
      float2 normal = renodx::color::gamut::CIE1702_HALFSPACE_NORMALS[edge];
      float offset = renodx::color::gamut::CIE1702_HALFSPACE_NUMERATORS[edge]
                     + dot(normal, PSYCHO35_MB_WHITE);
      float margin = offset * (origin_weighted.x + origin_weighted.y)
                     - dot(normal, origin_weighted.xz);
      float denominator = dot(normal, direction_weighted.xz) - offset * direction_y;
      if (!(margin >= 0.f) || isnan(denominator) || isinf(denominator)) return asfloat(0x7fc00000u).xxx;
      if (denominator > 0.f) boundary_t = min(boundary_t, margin / denominator);
    }
    // Intersect the approximate spectral region with the finite response's
    // exact nonnegative-cone domain, on the same original fixed-mean ray.
    [unroll] for (int cone = 0; cone < 3; ++cone) {
      if (direction_q[cone] < 0.f) {
        boundary_t = min(boundary_t, mean_q / -direction_q[cone]);
      }
    }
    if (!(origin_weighted.x + origin_weighted.y + boundary_t * direction_y > 0.f)) {
      return asfloat(0x7fc00000u).xxx;
    }
    // t_b == 1 retains the supplied input, including exact-zero cones.
    if (boundary_t < 1.f) {
      float3 boundary_q = mean_q + boundary_t * direction_q;
      // A true zero-cone boundary is valid. Move one part per million toward
      // the valid fixed-mean origin, rather than lifting channels separately.
      // Materially negative endpoints are outside this response's domain.
      if (any(boundary_q < -1e-6f * mean_q)) return asfloat(0x7fc00000u).xxx;
      if (any(boundary_q <= 0.f)) boundary_q = lerp(boundary_q, mean_q.xxx, 1e-6f);
      if (any(boundary_q <= 0.f) || any(isnan(boundary_q)) || any(isinf(boundary_q))) {
        return asfloat(0x7fc00000u).xxx;
      }
      {
        float3 log_u, log_tail, log_deficit, log_g;
        [unroll] for (int cone = 0; cone < 3; ++cone) {
          psycho35_ResponseLogs(log(boundary_q[cone]), reference.anchor_power[cone],
                                reference.input_exponent[cone], reference.response_compression,
                                log_u[cone], log_tail[cone], log_deficit[cone]);
          log_g[cone] = log(reference.response_power / (1.f - reference.anchor_power[cone]))
                        + log_u[cone] + log_tail[cone];
        }
        // One common factor cancels in s(j)/s(g). No derivative floor/cap.
        float3 exposure_derivative = exp(log_g - max(log_g.x, max(log_g.y, log_g.z)));
        float3 incoming_derivative = exposure_derivative * (direction_q / boundary_q);
        // Only the residual direction is needed by the metric. Scale either
        // u (black side) or its deficit (white side) before centering.
        bool white_side = psycho35_Mean(exp(log_u)) > .5f;
        float3 residual_logs = white_side ? log_deficit : log_u;
        float3 scaled = exp(residual_logs - max(residual_logs.x, max(residual_logs.y, residual_logs.z)));
        float3 residual = white_side ? psycho35_Mean(scaled) - scaled : scaled - psycho35_Mean(scaled);
        float radius = length(residual);
        if (!(radius > 0.f) || isinf(radius)
            || any(isnan(exposure_derivative)) || any(isinf(exposure_derivative))
            || any(isnan(incoming_derivative)) || any(isinf(incoming_derivative))) {
          return asfloat(0x7fc00000u).xxx;
        }
        float incoming_a = psycho35_Mean(incoming_derivative);
        float exposure_a = psycho35_Mean(exposure_derivative);
        float incoming_c = dot(residual / radius, incoming_derivative);
        float exposure_c = dot(residual / radius, exposure_derivative);
        float incoming_speed = length(float2(sqrt(3.f) * incoming_a, incoming_c));
        float exposure_speed = length(float2(sqrt(3.f) * exposure_a, exposure_c));
        // ds^2 = 3 dA^2 + dC^2 excludes hue motion. This is a local
        // first-order trade, not energy conservation or finite-arc integration.
        if (!(exposure_speed > 0.f) || isnan(exposure_speed) || isinf(exposure_speed)
            || isnan(incoming_speed) || isinf(incoming_speed)) return asfloat(0x7fc00000u).xxx;
        float spill_scale = 1.f + (1.f - boundary_t) * incoming_speed / exposure_speed;
        boundary_q *= spill_scale;
        if (any(isnan(boundary_q)) || any(isinf(boundary_q))) return asfloat(0x7fc00000u).xxx;
      }
      source_ratio = boundary_q;
    }
  }
  // Only explicitly enabled compensation floors unsupported LMS components.
  // It occurs after optional conditioning, so it cannot erase spill distance.
  if (human_gamut_conditioning) source_ratio = max(source_ratio, 0.f);
  if (all(source_ratio == 0.f)) return 0.f;
  // Numerical exposure factorization only: q = drive * reference.source_ratio.
  // This neither substitutes Yf nor repairs negative cones (their logs fail).
  float drive = max(abs(source_ratio.x), max(abs(source_ratio.y), abs(source_ratio.z)));
  reference.source_ratio = source_ratio / drive;
  // Zero is handled analytically in reference/tail evaluation, without log(0).
  reference.log_source_ratio = log(float3(reference.source_ratio.x != 0.f ? reference.source_ratio.x : 1.f,
                                          reference.source_ratio.y != 0.f ? reference.source_ratio.y : 1.f,
                                          reference.source_ratio.z != 0.f ? reference.source_ratio.z : 1.f));
  float source_radius = length(reference.source_ratio - psycho35_Mean(reference.source_ratio));
  reference.source_log_radius = source_radius > 0.f ? log2(source_radius) : -1e30f;
  float exposure_stops = log2(drive);
  Psycho35Sample actual = psycho35_ReferenceAt(reference, exposure_stops);
  if (gamut_compression == 0.f || fit_mode == 0) {
    return actual.mean + psycho35_TargetResidual(actual.residual, 0);
  }
  // Exact neutral responses require no target contraction.
  if (all(actual.residual == 0.f)) return actual.mean.xxx;
  float3 target_displacement = psycho35_TargetResidual(actual.residual, reference.target);
  if (fit_mode == 1) {
    // Independent channel clipping in the selected target, returned in BT.709.
    float3 clipped = clamp(actual.mean + target_displacement, 0.f, reference.peak);
    if (reference.target != 0) {
      clipped = mul(renodx::color::BT2020_TO_BT709_MAT, clipped);
    }
    return lerp(actual.mean + psycho35_TargetResidual(actual.residual, 0), clipped, gamut_compression);
  }
  if (fit_mode == 4) {
    // Local shoulder diagnostic, NOT the final coupled A/C fit.
    // Preserve A and post-A2 direction; identity through 95% of face capacity.
    // For x=C/Cmax above k: f(x)=k+(x-k)/(1+(x-k)/(1-k)).
    // Use reciprocal pressure to avoid division by vanishing neutral room.
    const float knee = 0.95f;
    float support = rcp(knee);
    [unroll] for (int channel = 0; channel < 3; ++channel) {
      if (target_displacement[channel] > 0.f) {
        support = min(support, actual.headroom / target_displacement[channel]);
      } else if (target_displacement[channel] < 0.f) {
        support = min(support, actual.mean / -target_displacement[channel]);
      }
    }
    if (support >= rcp(knee)) {
      return actual.mean + psycho35_TargetResidual(actual.residual, 0);
    }
    float excess = max(0.f, 1.f - knee * support);
    float scale = support * (knee + (1.f - knee) * excess / (excess + (1.f - knee) * support));
    return actual.mean + psycho35_TargetResidual(actual.residual * lerp(1.f, scale, gamut_compression), 0);
  }
  if (fit_power == 0.f || (fit_mode != 4 && (gamut_fill || fit_mode == 2))) {
    // Reciprocal maximum pressure, computed as minimum face support.
    // No logarithms, exponentials, or powers are needed for the exact fit.
    float scale = 1.f;
    [unroll] for (int channel = 0; channel < 3; ++channel) {
      if (target_displacement[channel] > 0.f) {
        scale = min(scale, actual.headroom / target_displacement[channel]);
      } else if (target_displacement[channel] < 0.f) {
        scale = min(scale, actual.mean / -target_displacement[channel]);
      }
    }
    scale = lerp(1.f, scale, gamut_compression);
    return actual.mean + psycho35_TargetResidual(actual.residual * scale, 0);
  }
  // Power-two fixed-A compression specializes to the Neutwo rsqrt form.
  if (fit_power == 2.f) {
    float3 pressure = 0.f;
    bool endpoint_contact = false;
    [unroll] for (int channel = 0; channel < 3; ++channel) {
      if (target_displacement[channel] != 0.f) {
        float available = target_displacement[channel] > 0.f ? actual.headroom : actual.mean;
        if (available == 0.f) {
          endpoint_contact = true;
        } else {
          pressure[channel] = abs(target_displacement[channel]) / available;
        }
      }
    }
    if (endpoint_contact) {
      return actual.mean
             + psycho35_TargetResidual(actual.residual * (1.f - gamut_compression), 0);
    }
    float normalization = max(1.f, max(pressure.x, max(pressure.y, pressure.z)));
    if (all(isfinite(pressure))) {
      // Neutwo scale: 1/sqrt(1+qR*qR+qG*qG+qB*qB). Normalize before
      // squaring so finite pressures cannot overflow the sum.
      float inverse_normalization = rcp(normalization);
      float3 normalized_pressure = pressure / normalization;
      float scale = inverse_normalization * rsqrt(inverse_normalization * inverse_normalization
                                                  + normalized_pressure.x * normalized_pressure.x
                                                  + normalized_pressure.y * normalized_pressure.y
                                                  + normalized_pressure.z * normalized_pressure.z);
      scale = lerp(1.f, scale, gamut_compression);
      return actual.mean + psycho35_TargetResidual(actual.residual * scale, 0);
    }
    // Near an endpoint, displacement/available can overflow even when both
    // operands are finite. The log-domain expression below retains that range.
  }
  // Headroom comes from response deficits,
  // avoiding subtraction of the rounded mean from peak.
  // Gamut Fill reaches the actual faces; it does not attract hues to corners
  // or independently clip RGB channels.
  // log-sum-exp evaluates (1 + sum(q^m))^(-1/m) without overflowing
  // face pressures or their powers. Each channel has one active sign.
  float3 log_pressure = asfloat(0xff800000u);
  bool endpoint_contact = false;
  [unroll] for (int channel = 0; channel < 3; ++channel) {
    if (target_displacement[channel] != 0.f) {
      float available = target_displacement[channel] > 0.f ? actual.headroom : actual.mean;
      if (available == 0.f)
        endpoint_contact = true;
      else
        log_pressure[channel] = log(abs(target_displacement[channel])) - log(available);
    }
  }
  float largest_log = max(0.f, max(log_pressure.x, max(log_pressure.y, log_pressure.z)));
  float3 scaled_pressure = exp(fit_power * (log_pressure - largest_log));
  float scale = endpoint_contact ? 0.f
              : exp(-largest_log - log(exp(-fit_power * largest_log)
                                                        + scaled_pressure.x + scaled_pressure.y + scaled_pressure.z) / fit_power);
  scale = lerp(1.f, scale, gamut_compression);
  return actual.mean + psycho35_TargetResidual(actual.residual * scale, 0);
}

}  // namespace psychov
}  // namespace tonemap
}  // namespace renodx
#endif
