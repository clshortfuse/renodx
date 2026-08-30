#include "./shared.h"
#include "./customtest25.hlsli"

#define WUWA_PEAK_SCALING (RENODX_PEAK_NITS / RENODX_GAME_NITS)

#define APPLY_BLOOM(c) (c).rgb *= RENODX_WUWA_BLOOM

#define APPLY_EXTENDED_TONEMAP(c1, c2, c3) \
  float3 tonemapped; \
  if (RENODX_TONE_MAP_TYPE == 0.f) { \
    tonemapped = float3(c1, c2, c3); \
  } else if (RENODX_TONE_MAP_SCALING == 1.f) { \
    tonemapped = wuwa::ApplyPsychoV17(untonemapped); \
    c1 = tonemapped.r; c2 = tonemapped.g; c3 = tonemapped.b; \
  } else if (RENODX_TONE_MAP_SCALING == 2.f) { \
    tonemapped = wuwa::ApplyPsychoV25(untonemapped); \
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

#define CAPTURE_UNTONEMAPPED(c) const float3 untonemapped = (c).rgb

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

static inline float3 ApplyPsychoV25(float3 untonemapped_bt709) {
  // Hardcoded cone = vanilla slope match (0.175 * V'(0.175) / 0.18)
  float cone_response = 1.065f * RENODX_TONE_MAP_CONTRAST;

  // Apply standard RenoDX Highlights
  float3 graded_input_bt709 = untonemapped_bt709;
  if (RENODX_TONE_MAP_HIGHLIGHTS != 1.f) {
    float3 lms = renodx::color::lms::from::BT709(untonemapped_bt709);
    float yf_input = renodx::color::yf::from::LMS(lms);
    float yf_midgray = renodx::color::yf::from::BT709(0.18f);
    float yf_target = renodx::color::grade::Highlights(
        yf_input, RENODX_TONE_MAP_HIGHLIGHTS, yf_midgray);
    lms *= renodx::math::DivideSafe(yf_target, yf_input, 1.f);
    graded_input_bt709 = renodx::color::bt709::from::LMS(lms);
  }

  return ApplyCustomPsychoV25ToneMap(
      graded_input_bt709,
      RENODX_PEAK_NITS / RENODX_GAME_NITS,
      1.f,                              // highlights
      RENODX_TONE_MAP_SHADOWS,
      cone_response,
      0.f,                              // flare
      RENODX_TONE_MAP_SATURATION,       // purity_scale
      1.f,                              // highlight_saturation 
      RENODX_TONE_MAP_DECHROMA,         // dechroma
      0.175f,                           // current_adaptive_state_bt709
      0.18f,                            // current_background_state_bt709
      0.35f,                            // pre_shoulder_hue_linearity
      0.3f,                             // post_shoulder_source_hue_recovery_strength
      1.f,                              // compression
      renodx::tonemap::psychov::PSYCHO25_TARGET_GAMUT_DISPLAY_P3);
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

// Post-tonemap hue/chroma blowout repair, ICtCp working space.
static inline float3 ApplyHueCorrection(float3 mapped_bt709) {
  const float hue_strength = RENODX_PSYCHOV_HUE_EMULATION;
  const float chroma_restore = RENODX_PSYCHOV_CHROMA_EMULATION;
  if (hue_strength <= 0.f && chroma_restore <= 0.f) {
    return mapped_bt709;
  }

  float reference_peak_scaling = 500.f / max(RENODX_GAME_NITS, 1.f);
  float3 reference_bt709 = renodx::tonemap::ReinhardPiecewise(
      max(mapped_bt709, 0.f), reference_peak_scaling, 0.18f);

  float3 perceptual = renodx::color::ictcp::from::BT709(mapped_bt709);
  float3 perceptual_reference = renodx::color::ictcp::from::BT709(reference_bt709);

  float chrominance_current = length(perceptual.yz);
  float chrominance_ratio = 1.f;

  // Hue: direction-only lerp toward the reference, magnitude preserved.
  if (hue_strength > 0.f && chrominance_current > 1e-6f) {
    const float chrominance_pre = chrominance_current;
    perceptual.yz = lerp(perceptual.yz, perceptual_reference.yz, saturate(hue_strength));
    const float chrominance_post = length(perceptual.yz);
    chrominance_ratio = renodx::math::DivideSafe(chrominance_pre, chrominance_post, 1.f);
    chrominance_current = chrominance_post;
  }

  // Chroma: restore magnitude toward the reference (blowout repair).
  if (chroma_restore > 0.f) {
    const float reference_chrominance = length(perceptual_reference.yz);
    const float target_ratio = renodx::math::DivideSafe(reference_chrominance, chrominance_current, 1.f);
    chrominance_ratio = lerp(chrominance_ratio, target_ratio, saturate(chroma_restore));
  }

  perceptual.yz *= chrominance_ratio;

  float3 corrected = renodx::color::bt709::from::ICtCp(perceptual);
  return renodx::color::bt709::clamp::AP1(corrected);
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

static inline float3 ApplyFinalFilmGrain(float3 output, float2 position) {
  if (RENODX_FILM_GRAIN > 0.f) {
    const float2 grain_xy = renodx::random::Hash33(float3(position, CUSTOM_RANDOM)).xy;
    output = renodx::effects::ApplyFilmGrain(
        output, grain_xy, CUSTOM_RANDOM, RENODX_WUWA_GRAIN * 0.03f);
  }
  return output;
}

static inline float3 ApplyDisplayMap(float3 input_bt709, float2 position = float2(0.f, 0.f)) {
  float3 output;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    output = renodx::draw::RenderIntermediatePass(input_bt709);
  } else {
    // Apply hue correction cause the game still seems to need it.
    input_bt709 = ApplyHueCorrection(input_bt709);

    if (RENODX_TONE_MAP_SCALING != 0.f) {
      output = renodx::draw::RenderIntermediatePass(input_bt709);
    } else {
      // N2 Display-mapping to peak if on extended path
      float3 input_bt2020 = renodx::color::bt2020::from::BT709(max(0.f, input_bt709));
      float3 mapped_bt2020 = renodx::tonemap::neutwo::MaxChannel(input_bt2020, WUWA_PEAK_SCALING);
      float3 mapped_bt709 = renodx::color::bt709::from::BT2020(mapped_bt2020);
      output = renodx::draw::RenderIntermediatePass(mapped_bt709);
    }
  }

  return ApplyFinalFilmGrain(output, position);
}

static inline float3 InvertAndApplyDisplayMap(float3 input_bt709, float2 position = float2(0.f, 0.f)) {
  return ApplyDisplayMap(renodx::draw::InvertIntermediatePass(input_bt709), position);
}

}
