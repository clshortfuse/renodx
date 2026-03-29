#include "./shared.h"
#include "./psycho_test11.hlsli"

#define WUWA_PEAK_SCALING (RENODX_PEAK_NITS / RENODX_GAME_NITS)

#define APPLY_BLOOM(c) (c).rgb *= RENODX_WUWA_BLOOM

#define WUWA_TM_IS(N) ((uint)(RENODX_WUWA_TM) == (N))

#define CLAMP_IF_SDR(c) ((c) = ((RENODX_TONE_MAP_TYPE == 0.f) ? saturate((c)) : (c)))

#define CLAMP_IF_SDR3(r, g, b) { if (RENODX_TONE_MAP_TYPE == 0.f) { (r) = saturate((r)); (g) = saturate((g)); (b) = saturate((b)); } }

#define CAPTURE_UNTONEMAPPED(c) const float3 untonemapped = (c).rgb

#define CAPTURE_TONEMAPPED(c) const float3 tonemapped = (c).rgb

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
  slope *= 2.f;

  float3 extended = slope * x + (pivot_y - slope * pivot_x);

  float3 t = smoothstep(pivot_x - 0.05f, pivot_x + 0.05f, x);  // softer transition
  return lerp(base, extended, t);
}
}

static inline float3 ApplyDisplayMap(float3 input_bt709) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return input_bt709;
  }

  float3 untonemapped_bt709 = max(0.f, input_bt709);
  float3 untonemapped_bt2020 = renodx::color::bt2020::from::BT709(untonemapped_bt709);
  float peak_ratio = RENODX_PEAK_NITS / RENODX_GAME_NITS;

  renodx_custom::tonemap::psycho::config::Config psycho_config = renodx_custom::tonemap::psycho::config::Create();
  psycho_config.peak_value = peak_ratio;
  psycho_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  psycho_config.gamma = RENODX_TONE_MAP_GAMMA;
  psycho_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  psycho_config.shadows = RENODX_TONE_MAP_SHADOWS;
  psycho_config.contrast = RENODX_TONE_MAP_CONTRAST;
  psycho_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  psycho_config.contrast_highlights = RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS;
  psycho_config.contrast_shadows = RENODX_TONE_MAP_CONTRAST_SHADOWS;
    psycho_config.purity_scale = RENODX_TONE_MAP_SATURATION * RENODX_PSYCHOV_PURITY_SCALE;
  psycho_config.purity_highlights =
      (-1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f)) + ((RENODX_PSYCHOV_HIGHLIGHT_PURITY_BIAS - 0.5f) * 2.f);
  psycho_config.adaptation_contrast = RENODX_TONE_MAP_ADAPTATION_CONTRAST;
  psycho_config.bleaching_intensity = 0.f;
    psycho_config.hue_restore = RENODX_PSYCHOV_HUE_RESTORE;
  psycho_config.pre_gamut_compress = false;
  psycho_config.post_gamut_compress = true;

  float3 tonemapped_bt2020;
  if (RENODX_TONE_MAP_SCALING != 0.f) {
    tonemapped_bt2020 = renodx_custom::tonemap::psycho::ApplyBT2020(untonemapped_bt2020, psycho_config);
  } else {
    float3 purity_and_hue_source = renodx::color::bt2020::from::BT709(renodx::tonemap::ReinhardPiecewise(untonemapped_bt709, 4.f, 0.5f));
    untonemapped_bt2020 = renodx::color::correct::Luminance(
        purity_and_hue_source,
        renodx_custom::tonemap::psycho::psycho11_StockmanLuminanceFromBT2020(purity_and_hue_source),
        renodx_custom::tonemap::psycho::psycho11_StockmanLuminanceFromBT2020(untonemapped_bt2020));

    psycho_config.apply_tonemap = false;
    psycho_config.purity_highlights = 0.f;
    untonemapped_bt2020 = renodx_custom::tonemap::psycho::ApplyBT2020(untonemapped_bt2020, psycho_config);

    tonemapped_bt2020 = renodx::tonemap::neutwo::MaxChannel(untonemapped_bt2020, peak_ratio);
  }

  float3 mapped_bt709 = renodx::color::bt709::from::BT2020(tonemapped_bt2020);
  return lerp(input_bt709, mapped_bt709, RENODX_PSYCHOV_BLEND);
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
