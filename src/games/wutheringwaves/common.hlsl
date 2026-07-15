#include "./shared.h"

#define WUWA_PEAK_SCALING (RENODX_PEAK_NITS / RENODX_GAME_NITS)

#define APPLY_BLOOM(c) (c).rgb *= RENODX_WUWA_BLOOM

#define APPLY_EXTENDED_TONEMAP(c1, c2, c3) \
  float3 tonemapped; \
  if (RENODX_TONE_MAP_TYPE == 0.f) { \
    tonemapped = float3(c1, c2, c3); \
  } else if (RENODX_TONE_MAP_SCALING == 1.f) { \
    tonemapped = wuwa::ApplyPsychoV17(untonemapped); \
    c1 = tonemapped.r; c2 = tonemapped.g; c3 = tonemapped.b; \
  } else { \
    wuwa::WUWAUncharted2::ApplyExtendedFromCoeffs((c1), (c2), (c3), untonemapped, cb0_037y, cb0_037z, cb0_037w, cb0_038x, cb0_038y, cb0_038z); \
    tonemapped = float3(c1, c2, c3); \
    float3 result = lerp(untonemapped, tonemapped, RENODX_WUWA_TONEMAP_STRENGTH); \
    result = wuwa::ApplyUserGrade(result); \
    c1 = result.r; \
    c2 = result.g; \
    c3 = result.b; \
  }

#define WUWA_TM_IS(N) ((uint)(RENODX_WUWA_TM) == (N))

#define CLAMP_IF_SDR(c) ((c) = ((RENODX_TONE_MAP_TYPE == 0.f) ? saturate((c)) : (c)))

#define CLAMP_IF_SDR3(r, g, b) { if (RENODX_TONE_MAP_TYPE == 0.f) { (r) = saturate((r)); (g) = saturate((g)); (b) = saturate((b)); } }

#define CAPTURE_UNTONEMAPPED(c) const float3 untonemapped = (c).rgb

#define CAPTURE_TONEMAPPED(c) const float3 tonemapped = (c).rgb

#define CAPTURE_UNGRADED(c1, c2, c3) const float3 ungraded = float3((c1), (c2), (c3))

#define HANDLE_LUT_OUTPUT(c) (c).rgb = HandleLUTOutput((c).rgb, untonemapped, tonemapped)
#define HANDLE_LUT_OUTPUT3(c1, c2, c3) { \
    float3 lut_output = float3(c1, c2, c3); \
    lut_output = HandleLUTOutput(lut_output, untonemapped, tonemapped); \
    c1 = lut_output.r; c2 = lut_output.g; c3 = lut_output.b; \
}

#define HANDLE_LUT_OUTPUT3_FADE(c1, c2, c3, tex, samp) { \
  float3 lut_output = float3(c1, c2, c3); \
  lut_output = HandleLUTOutput(lut_output, untonemapped, tonemapped, tex, samp); \
  c1 = lut_output.r; c2 = lut_output.g; c3 = lut_output.b; \
}

#define HANDLE_LUT_OUTPUT_FADE(c, tex, samp) (c).rgb = HandleLUTOutput((c).rgb, untonemapped, tonemapped, tex, samp)

#define GENERATE_INVERSION(c1, c2, c3) \
    const float3 inverted = renodx::draw::InvertIntermediatePass(float3(c1, c2, c3)); \
    c1 = inverted.r; c2 = inverted.g; c3 = inverted.b;

namespace wuwa {

static inline float3 ApplyPsychoV17(float3 untonemapped_bt709) {
  return renodx::tonemap::psychov::psychotm_test17(
      untonemapped_bt709,
      RENODX_PEAK_NITS / RENODX_GAME_NITS,
      RENODX_TONE_MAP_EXPOSURE,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS,
      RENODX_TONE_MAP_CONTRAST,
      RENODX_TONE_MAP_SATURATION,       // purity_scale 
      0.f,                              // bleaching_intensity
      100.f,                            // clip_point
      1.f,                              // hue_restore 
      1.f,                              // adaptation_contrast
      0,                                // white_curve_mode
      1.065f,                           // cone_response_exponent
      0.175f,                           // current_adaptive_state_bt709 
      0.18f);                           // current_background_state_bt709
}

// User color grade in cone/LMS + MacLeod-Boynton space
static inline float3 ApplyUserGrade(float3 color_bt709) {
  float3 bt709_scene = color_bt709 * RENODX_TONE_MAP_EXPOSURE;
  float3 lms = renodx::color::lms::from::BT709(bt709_scene);
  float3 adaptive_lms = renodx::color::lms::from::BT709(0.18f);

  float yf_input = renodx::color::yf::from::LMS(lms);
  float yf_midgray = renodx::color::yf::from::BT709(0.18f);
  float yf_target = yf_input;
  if (RENODX_TONE_MAP_HIGHLIGHTS != 1.f) {
    yf_target = renodx::color::grade::Highlights(yf_target, RENODX_TONE_MAP_HIGHLIGHTS, yf_midgray);
  }
  if (RENODX_TONE_MAP_SHADOWS != 1.f) {
    yf_target = renodx::color::grade::Shadows(yf_target, RENODX_TONE_MAP_SHADOWS, yf_midgray);
  }
  if (RENODX_TONE_MAP_CONTRAST != 1.f) {
    yf_target = renodx::color::grade::ContrastSafe(yf_target, RENODX_TONE_MAP_CONTRAST, yf_midgray);
  }
  float yf_scale = renodx::math::DivideSafe(yf_target, yf_input, 1.f);
  float3 lms_graded = lms * yf_scale;

  if (RENODX_TONE_MAP_SATURATION != 1.f) {
    float3 lms_relative = renodx::math::DivideSafe(lms_graded, adaptive_lms, 0.f.xxx);
    float3 mb = renodx::color::macleod_boynton::from::LMS(lms_relative);
    float2 mb_white = renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
    float2 mb_scaled = lerp(mb_white, mb.xy, RENODX_TONE_MAP_SATURATION);
    lms_graded = renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb.z)) * max(adaptive_lms, 1e-6f);
  }

  return renodx::color::bt709::from::LMS(lms_graded);
}

static inline float3 CorrectHueAndPurityMBGated(
    float3 target_color_bt709,
    float3 reference_color_bt709,
    float hue_strength = 1.f,
    float hue_t_ramp_start = 0.5f,
    float hue_t_ramp_end = 1.f,
    float purity_strength = 1.f,
    float curve_gamma = 1.f,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-6f) {
  static const float MB_NEAR_WHITE_EPSILON = 1e-14f;

  if (purity_strength <= 0.f && hue_strength <= 0.f) {
    return target_color_bt709;
  }

  float3 target_color_bt2020 = renodx::color::bt2020::from::BT709(target_color_bt709);
  float3 reference_color_bt2020 = renodx::color::bt2020::from::BT709(reference_color_bt709);

  float3 target_mb = renodx::color::macleod_boynton::from::BT2020(target_color_bt2020);
  float3 reference_mb = renodx::color::macleod_boynton::from::BT2020(reference_color_bt2020);

  if (target_mb.z <= t_min) {
    return target_color_bt709;
  }

  float2 white = (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
                     ? mb_white_override
                     : renodx::color::macleod_boynton::from::D65XY();

  float2 target_direction = target_mb.xy - white;
  float2 reference_direction = reference_mb.xy - white;

  float target_len_sq = dot(target_direction, target_direction);
  float reference_len_sq = dot(reference_direction, reference_direction);

  if (target_len_sq < MB_NEAR_WHITE_EPSILON && reference_len_sq < MB_NEAR_WHITE_EPSILON) {
    return target_color_bt709;
  }

  float target_len = sqrt(max(target_len_sq, 0.f));
  float reference_len = sqrt(max(reference_len_sq, 0.f));

  float hue_blend = saturate(hue_strength) *
                    saturate(renodx::math::DivideSafe(target_mb.z - hue_t_ramp_start,
                                                      hue_t_ramp_end - hue_t_ramp_start, 0.f));

  float purity_blend = pow(saturate(purity_strength), max(curve_gamma, 1e-6f));
  float applied_purity = lerp(target_len, reference_len, purity_blend);

  float2 target_unit = (target_len > MB_NEAR_WHITE_EPSILON)
                           ? target_direction * rsqrt(target_len_sq)
                           : float2(0.f, 0.f);
  float2 reference_unit = (reference_len > MB_NEAR_WHITE_EPSILON)
                              ? reference_direction * rsqrt(reference_len_sq)
                              : target_unit;
  if (target_len <= MB_NEAR_WHITE_EPSILON) {
    target_unit = reference_unit;
  }

  float2 blended_unit = target_unit;
  if (hue_blend > 0.f) {
    blended_unit = lerp(target_unit, reference_unit, hue_blend);
    float blended_len_sq = dot(blended_unit, blended_unit);
    if (blended_len_sq <= MB_NEAR_WHITE_EPSILON) {
      blended_unit = (hue_blend >= 0.5f) ? reference_unit : target_unit;
      blended_len_sq = dot(blended_unit, blended_unit);
    }
    blended_unit *= rsqrt(max(blended_len_sq, 1e-20f));
  }

  float2 final_mb_xy = white + blended_unit * max(applied_purity, 0.f);
  float3 final_bt2020 = renodx::color::bt2020::from::MacLeodBoynton(final_mb_xy, target_mb.z);
  return renodx::color::bt709::from::BT2020(final_bt2020);
}

// Post-tonemap hue/purity emulation. Pulls the mapped color toward the hue and
// purity of a Reinhard-piecewise reference of itself, gated by the emulation sliders.
static inline float3 ApplyHueCorrection(float3 mapped_bt709) {
  if (

      (RENODX_PSYCHOV_HUE_EMULATION > 0.f || RENODX_PSYCHOV_CHROMA_EMULATION > 0.f)) {
    float3 mapped_ap1 = renodx::color::ap1::from::BT709(mapped_bt709);
    float3 hue_reference_bt709 = renodx::color::bt709::from::AP1(
        renodx::tonemap::ReinhardPiecewise(mapped_ap1, 2.f, 1.f));
    mapped_bt709 = CorrectHueAndPurityMBGated(
        mapped_bt709,
        hue_reference_bt709,
        RENODX_PSYCHOV_HUE_EMULATION,
        0.5f,
        1.f,
        saturate(RENODX_PSYCHOV_CHROMA_EMULATION),
        1.f);
  }
  return mapped_bt709;
}

namespace lut {

static inline float PrepareLinearInput(inout float r, inout float g, inout float b) {
  float3 lut_linear_input = max(0.f, float3(r, g, b));
  float lut_sampling_scale = 1.0f;

  if (RENODX_TONE_MAP_TYPE != 0.0f) {
    lut_sampling_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(lut_linear_input);
    lut_linear_input *= lut_sampling_scale;
  }

  r = lut_linear_input.r;
  g = lut_linear_input.g;
  b = lut_linear_input.b;
  return lut_sampling_scale;
}

static inline float NormalizeEncodedInput(inout float r, inout float g, inout float b) {
  float lut_sample_max_channel = renodx::math::Max(r, g, b, 1.0f);
  float3 lut_input_srgb = saturate(float3(r, g, b) / lut_sample_max_channel);
  r = lut_input_srgb.r;
  g = lut_input_srgb.g;
  b = lut_input_srgb.b;
  return lut_sample_max_channel;
}

static inline void ApplySampleMaxChannel(inout float r, inout float g, inout float b, float lut_sample_max_channel) {
  r *= lut_sample_max_channel;
  g *= lut_sample_max_channel;
  b *= lut_sample_max_channel;
}

static inline void ApplyInverseSamplingScale(inout float r, inout float g, inout float b, float lut_sampling_scale) {
  if (RENODX_TONE_MAP_TYPE != 0.0f) {
    float inv_lut_sampling_scale = 1.0f / max(lut_sampling_scale, 1e-6f);
    r *= inv_lut_sampling_scale;
    g *= inv_lut_sampling_scale;
    b *= inv_lut_sampling_scale;
  }
}

static inline void PreserveReferenceLightness(inout float r, inout float g, inout float b, float3 reference_bt709) {
  if (RENODX_TONE_MAP_TYPE == 0.f || RENODX_WUWA_LUT_LIGHTNESS >= 1.f) {
    return;
  }
  float3 lut_lab = renodx::color::oklab::from::BT709(float3(r, g, b));
  float3 ref_lab = renodx::color::oklab::from::BT709(reference_bt709);
  lut_lab.x = lerp(ref_lab.x, lut_lab.x, RENODX_WUWA_LUT_LIGHTNESS);
  float3 result = renodx::color::bt709::clamp::AP1(renodx::color::bt709::from::OkLab(lut_lab));
  r = result.r;
  g = result.g;
  b = result.b;
}


static inline void ApplyLutStrength(inout float r, inout float g, inout float b, float3 ungraded) {
  float3 ungraded_bt709 = renodx::color::bt709::from::AP1(ungraded);
  float3 graded_lab = renodx::color::oklab::from::BT709(float3(r, g, b));
  float3 ungraded_lab = renodx::color::oklab::from::BT709(ungraded_bt709);
  graded_lab.yz = lerp(ungraded_lab.yz, graded_lab.yz, RENODX_WUWA_LUT_STRENGTH);
  float3 result = renodx::color::bt709::clamp::AP1(renodx::color::bt709::from::OkLab(graded_lab));
  r = result.r;
  g = result.g;
  b = result.b;
}

}

static const float3x3 DCIP3_to_BT2020_MAT = float3x3(
    0.75383303, 0.19859737, 0.04756960,
    0.04574385, 0.94177722, 0.01247893,
    -0.00121034, 0.01760172, 0.98360862
);

namespace WUWAUncharted2 {
struct Config {
  float pivot_point;
  float coeffs[6];  // A,B,C,D,E,F
};

static inline float Derivative(float x, float a, float b, float c, float d, float e, float f) {
  float num = -a * b * (c - 1.0f) * x * x + 2.0f * a * d * (f - e) * x + b * d * (c * f - e);
  float den = x * (a * x + b) + d * f;
  return num / (den * den);
}

// Analytic knee root from BatmanAK UC2 extension helper.
static inline float FindThirdDerivativeRoot(float a, float b, float c, float d, float e, float f) {
  float sqrt_ab = sqrt(a * b * b * c * c - 2.f * a * b * b * c + a * b * b);
  float sqrt_df = sqrt(a * d * d * e * e - 2.f * a * d * d * e * f + a * d * d * f * f + b * b * c * c * d * f + b * b * (-c) * d * e - b * b * c * d * f + b * b * d * e);
  float de_df = d * e - d * f;

  float term_top = 32.f * (a * d * d * e * f - a * d * d * f * f + b * b * c * d * f - b * b * d * e) / (a * a * b * (c - 1.f));
  float term_mid = 96.f * de_df * (c * d * f - d * e) / (a * b * (c - 1.f) * (c - 1.f));
  float de_df2 = de_df * de_df;
  float de_df3 = de_df2 * de_df;
  float term_tail = 64.f * de_df3 / (b * b * b * (c - 1.f) * (c - 1.f) * (c - 1.f));

  float Tfrac = sqrt_ab * (term_top - term_mid - term_tail) / (8.f * sqrt_df);
  float Tmid2_num = 12.f * a * a * b * c * d * f - 12.f * a * a * b * d * e;
  float Tmid2_den = 6.f * (a * a * a * b * c - a * a * a * b);
  float Tmid2 = Tmid2_num / Tmid2_den;
  float T3 = 6.f * (c * d * f - d * e) / (a * (c - 1.f));
  float T4 = 8.f * de_df2 / (b * b * (c - 1.f) * (c - 1.f));

  float centerNeg = -Tfrac + Tmid2 + T3 + T4;
  float centerPos = Tfrac + Tmid2 + T3 + T4;

  float sNeg = renodx::math::SignSqrt(-centerNeg);
  float sPos = renodx::math::SignSqrt(centerPos);

  float shift1 = sqrt_df / sqrt_ab + de_df / (b * (c - 1.f));
  float shift2 = sqrt_df / sqrt_ab - de_df / (b * (c - 1.f));

  float r1 = -0.5f * sNeg - shift1;
  float r2 = 0.5f * sNeg - shift1;
  float r3 = -0.5f * sPos + shift2;
  float r4 = 0.5f * sPos + shift2;

  return saturate(renodx::math::Max(r1, r2, r3, r4));
}

static inline Config CreateConfig(float coeffs[6]) {
  Config cfg;
  cfg.pivot_point = FindThirdDerivativeRoot(coeffs[0], coeffs[1], coeffs[2], coeffs[3], coeffs[4], coeffs[5]);
  cfg.coeffs = coeffs;
  return cfg;
}

static inline float3 ApplyExtended(float3 x, float3 base, Config cfg) {
  float A = cfg.coeffs[0], B = cfg.coeffs[1], C = cfg.coeffs[2], D = cfg.coeffs[3], E = cfg.coeffs[4], F = cfg.coeffs[5];

  float pivot_x = saturate(cfg.pivot_point * 0.82f);   // earlier onset
  float pivot_y = renodx::tonemap::ApplyCurve(pivot_x, A, B, C, D, E, F);

  float slope = Derivative(pivot_x, A, B, C, D, E, F);

  float3 extended = slope * x + (pivot_y - slope * pivot_x);

  float3 t = smoothstep(pivot_x - 0.05f, pivot_x + 0.05f, x);  // softer transition
  return lerp(base, extended, t);
}

static inline void ApplyExtendedFromCoeffs(
    inout float r,
    inout float g,
    inout float b,
    float3 untonemapped,
    float c037y,
    float c037z,
    float c037w,
    float c038x,
    float c038y,
    float c038z) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float coeffs[6] = { c037y, c037z, c037w, c038x, c038y, c038z };
    Config uc2_config = CreateConfig(coeffs);
    float3 extended = ApplyExtended(max(0.f, untonemapped), float3(r, g, b), uc2_config);
    r = extended.x;
    g = extended.y;
    b = extended.z;
  }
}

}

static inline float3 ApplyDisplayMap(float3 input_bt709) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return renodx::draw::RenderIntermediatePass(input_bt709);
  }

  // Apply hue correction cause the game still seems to need it.
  input_bt709 = ApplyHueCorrection(input_bt709);


  if (RENODX_TONE_MAP_SCALING == 1.f) {
    return renodx::draw::RenderIntermediatePass(input_bt709);
  }

  // N2 Display-mapping to peak if on extended path
  float3 input_bt2020 = renodx::color::bt2020::from::BT709(max(0.f, input_bt709));
  float3 mapped_bt2020 = renodx::tonemap::neutwo::MaxChannel(input_bt2020, WUWA_PEAK_SCALING);
  float3 mapped_bt709 = renodx::color::bt709::from::BT2020(mapped_bt2020);
  return renodx::draw::RenderIntermediatePass(mapped_bt709);
}

static inline float3 InvertAndApplyDisplayMap(float3 input_bt709) {
  return ApplyDisplayMap(renodx::draw::InvertIntermediatePass(input_bt709));
}

}

static inline float3 HandleLUTOutput(float3 lut_output, float3 untonemapped, float3 tonemapped) {
  // Reverse the output shader's post-LUT scaling.
  lut_output /= 1.0499999523162842f;

  CLAMP_IF_SDR(lut_output);

  lut_output = renodx::draw::InvertIntermediatePass(lut_output);

  if (RENODX_TONE_MAP_TYPE != 0) {
    if (RENODX_COLOR_GRADE_STRENGTH == 0) {
      lut_output = untonemapped;
    } else {
        lut_output =
          renodx::draw::ApplyPerChannelCorrection(untonemapped,
                                                  lut_output,
                                                  RENODX_PER_CHANNEL_BLOWOUT_RESTORATION,
                                                  RENODX_PER_CHANNEL_HUE_CORRECTION,
                                                  RENODX_PER_CHANNEL_CHROMINANCE_CORRECTION,
                                                  RENODX_PER_CHANNEL_HUE_SHIFT);

        lut_output =
            renodx::tonemap::UpgradeToneMap(
                untonemapped,
                tonemapped,
                lut_output,
                RENODX_COLOR_GRADE_STRENGTH,
                1.f);
    }

    // Custom blowout
    [branch]
    if (RENODX_WUWA_BLOWOUT > 0) {
      const float y = renodx::color::y::from::BT709(lut_output);
      lut_output = lerp(lut_output, saturate(lut_output), RENODX_WUWA_BLOWOUT);
      const float y_clipped = renodx::color::y::from::BT709(lut_output);

      lut_output = renodx::color::correct::Luminance(lut_output, y_clipped, y);
    }

    lut_output = renodx::draw::ToneMapPass(lut_output);
  }

  lut_output = renodx::draw::RenderIntermediatePass(lut_output);

  return lut_output;
}

static inline float3 HandleLUTOutput(float3 lut_output, float3 untonemapped, float3 tonemapped, Texture3D<float4> lut_texture, SamplerState lut_sampler) {
  float min_uv = 0.015625f;
  float max_uv = 0.984375f;
  float3 a = lut_texture.SampleLevel(lut_sampler, float3(min_uv, min_uv, min_uv), 0).rgb;
  float3 b = lut_texture.SampleLevel(lut_sampler, float3(max_uv, max_uv, max_uv), 0).rgb;
  float3 c = lut_texture.SampleLevel(lut_sampler, float3(0.5f, 0.5f, 0.5f), 0).rgb;

  float3 d = abs(a - b);
  float max_delta = max(d.r, max(d.g, d.b));
  float uniform_fade = 1.0f - smoothstep(0.0f, 0.01f, max_delta);

  float3 max_v = max(a, max(b, c));
  float3 min_v = min(a, min(b, c));
  float max_chroma = max(max_v.r - min_v.r, max(max_v.g - min_v.g, max_v.b - min_v.b));
  float chroma_fade = 1.0f - smoothstep(0.0f, 0.05f, max_chroma);

  float fade_amount = max(uniform_fade, chroma_fade);
  float3 graded_output = HandleLUTOutput(lut_output, untonemapped, tonemapped);
  float3 original_output = renodx::draw::RenderIntermediatePass(lut_output);

  return lerp(graded_output, original_output, fade_amount);
}

#define GENERATE_LUT_OUTPUT(T)                                          \
  static inline T GenerateLUTOutput(T graded_bt709) {                   \
    graded_bt709 = renodx::draw::RenderIntermediatePass(graded_bt709);  \
    graded_bt709 /= 1.0499999523162842f;                                \
    return graded_bt709;                                                \
  }

GENERATE_LUT_OUTPUT(float3)
GENERATE_LUT_OUTPUT(float4)

static inline float3 AutoHDRVideo(float3 sdr_video, float2 position) {
  if (RENODX_TONE_MAP_TYPE == 0.f || RENODX_TONE_MAP_HDR_VIDEO == 0.f) {
    return sdr_video;
  }
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.peak_white_nits = RENODX_VIDEO_NITS;

  float3 hdr_video = renodx::draw::UpscaleVideoPass(saturate(sdr_video), config);
  {
    // dithering
    const float dither_bits = 10.0f;
    const float max_value = exp2(dither_bits) - 1.0f; 
    const float dither_lsbs_10bit = 6.0f; 
    const float2 p = position + CUSTOM_RANDOM;
    const float r1 = renodx::random::Generate(p + 0.07f);
    const float r2 = renodx::random::Generate(p + 13.07f);
    const float tpdf = (r1 - r2); 
    const float y = renodx::color::y::from::BT709(max(0, hdr_video));
    const float highlight_fade = smoothstep(0.35f, 1.0f, y); 
    const float strength = lerp(1.0f, 0.45f, highlight_fade);
    const float noise = tpdf * ((dither_lsbs_10bit * strength) / max_value);

    // clamp negatives
    hdr_video = max(0, hdr_video + noise);
  }

  hdr_video = renodx::color::srgb::DecodeSafe(hdr_video);

  {
    // minor amounts of grain
    const float grain_strength = 0.00010f;
    hdr_video = renodx::effects::ApplyFilmGrain(hdr_video, position, CUSTOM_RANDOM, grain_strength, 1.f);
  }

  return renodx::draw::RenderIntermediatePass(hdr_video);
}
