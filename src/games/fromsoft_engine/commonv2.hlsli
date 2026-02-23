#include "./macleod_boynton.hlsli"
#include "./shared.h"

struct UserGradingConfig {
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float gamma;
  float saturation;
  float dechroma;
  float highlight_saturation;
  float hue_emulation;
  float purity_emulation;
};

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {  // highlights < 1.f
    x /= mid_gray;
    return lerp(x, pow(x, highlights), step(1.f, x)) * mid_gray;
  }
}

float Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {  // shadows < 1.f
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float3 ApplyLuminosityGrading(float3 untonemapped, float lum, UserGradingConfig config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f && config.gamma == 1.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  // gamma
  float lum_gamma_adjusted = renodx::math::Select(lum < 1.f, pow(lum, config.gamma), lum);

  // contrast & flare
  const float lum_normalized = lum_gamma_adjusted / mid_gray;
  float flare = renodx::math::DivideSafe(lum_normalized + config.flare, lum_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float lum_contrasted = pow(lum_normalized, exponent) * mid_gray;

  // highlights
  float lum_highlighted = Highlights(lum_contrasted, config.highlights, mid_gray);

  // shadows
  float lum_shadowed = Shadows(lum_highlighted, config.shadows, mid_gray);

  const float lum_final = lum_shadowed;

  color = renodx::color::correct::Luminance(color, lum, lum_final);

  return color;
}

float3 ApplyHueAndPurityGrading(
    float3 ungraded_bt2020,
    float3 reference_bt2020,
    float lum,
    UserGradingConfig config,
    float curve_gamma = 1.f,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-7f) {
  float3 color_bt2020 = ungraded_bt2020;
  if (config.saturation == 1.f && config.dechroma == 0.f && config.hue_emulation == 0.f && config.purity_emulation == 0.f && config.highlight_saturation == 0.f) {
    return color_bt2020;
  }

  const float kNearWhiteEpsilon = renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON;
  const float2 white = (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
                           ? mb_white_override
                           : renodx_custom::color::macleod_boynton::MB_White_D65();

  float color_purity01 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                             color_bt2020, 1.f, 1.f, mb_white_override, t_min)
                             .purityCur01;

  // MB hue + purity emulation (analog of OkLab hue/chrominance section).
  if (config.hue_emulation != 0.f || config.purity_emulation != 0.f) {
    float reference_purity01 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                                   reference_bt2020, 1.f, 1.f, mb_white_override, t_min)
                                   .purityCur01;

    float purity_current = color_purity01;
    float purity_ratio = 1.f;
    float3 hue_seed_bt2020 = color_bt2020;

    if (config.hue_emulation != 0.f) {
      float3 target_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                              mul(renodx::color::BT2020_TO_XYZ_MAT, color_bt2020));
      float3 reference_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                                 mul(renodx::color::BT2020_TO_XYZ_MAT, reference_bt2020));

      float target_t = target_lms.x + target_lms.y;
      if (target_t > t_min) {
        float2 target_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(target_lms) - white;
        float2 reference_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(reference_lms) - white;

        float target_len_sq = dot(target_direction, target_direction);
        float reference_len_sq = dot(reference_direction, reference_direction);

        if (target_len_sq > kNearWhiteEpsilon || reference_len_sq > kNearWhiteEpsilon) {
          float2 target_unit = (target_len_sq > kNearWhiteEpsilon)
                                   ? target_direction * rsqrt(target_len_sq)
                                   : float2(0.f, 0.f);
          float2 reference_unit = (reference_len_sq > kNearWhiteEpsilon)
                                      ? reference_direction * rsqrt(reference_len_sq)
                                      : target_unit;

          if (target_len_sq <= kNearWhiteEpsilon) {
            target_unit = reference_unit;
          }

          float2 blended_unit = lerp(target_unit, reference_unit, config.hue_emulation);
          float blended_len_sq = dot(blended_unit, blended_unit);
          if (blended_len_sq <= kNearWhiteEpsilon) {
            blended_unit = (config.hue_emulation >= 0.5f) ? reference_unit : target_unit;
            blended_len_sq = dot(blended_unit, blended_unit);
          }
          blended_unit *= rsqrt(max(blended_len_sq, 1e-20f));

          float seed_len = sqrt(max(target_len_sq, 0.f));
          if (seed_len <= 1e-6f) {
            seed_len = sqrt(max(reference_len_sq, 0.f));
          }
          seed_len = max(seed_len, 1e-6f);

          hue_seed_bt2020 = mul(
              renodx::color::XYZ_TO_BT2020_MAT,
              mul(renodx_custom::color::macleod_boynton::LMS_TO_XYZ_2006,
                  renodx_custom::color::macleod_boynton::LMS_From_MB_T(white + blended_unit * seed_len, target_t)));

          float purity_post = renodx_custom::color::macleod_boynton::ApplyBT2020(
                                  hue_seed_bt2020, 1.f, 1.f, mb_white_override, t_min)
                                  .purityCur01;
          purity_ratio = renodx::math::SafeDivision(purity_current, purity_post, 1.f);
          purity_current = purity_post;
        }
      }
    }

    if (config.purity_emulation != 0.f) {
      float target_purity_ratio = renodx::math::SafeDivision(reference_purity01, purity_current, 1.f);
      purity_ratio = lerp(purity_ratio, target_purity_ratio, config.purity_emulation);
    }

    float applied_purity01 = saturate(purity_current * max(purity_ratio, 0.f));
    color_bt2020 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                       hue_seed_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
                       .rgbOut;
    color_purity01 = applied_purity01;
  }

  float purity_scale = 1.f;

  // dechroma
  if (config.dechroma != 0.f) {
    purity_scale *= lerp(1.f, 0.f, saturate(pow(lum / (10000.f / 100.f), (1.f - config.dechroma))));
  }

  // highlight saturation
  if (config.highlight_saturation != 0.f) {
    float percent_max = saturate(lum * 100.f / 10000.f);
    // positive = 1 to 0, negative = 1 to 2
    float blowout_strength = 100.f;
    float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.highlight_saturation));
    if (config.highlight_saturation < 0) {
      blowout_change = (2.f - blowout_change);
    }

    purity_scale *= blowout_change;
  }

  // saturation
  purity_scale *= config.saturation;

  if (purity_scale != 1.f) {
    float scaled_purity01 = saturate(color_purity01 * max(purity_scale, 0.f));
    color_bt2020 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                       color_bt2020, scaled_purity01, curve_gamma, mb_white_override, t_min)
                       .rgbOut;
  }

  return color_bt2020;
}

float ReinhardDerivative(float x, float peak) {
  return (peak * peak) / ((x + peak) * (x + peak));
}

// Analytic (Cardano) solution of x^3 + 2P x^2 + P^2 x - P^2 = 0
// Finds the real pivot x such that f'(x) = x,
// where f(x) = (peak * x) / (x + peak)
// and      f'(x) = peak^2 / (x + peak)^2.
//
// For peak > 0 this returns the unique positive real root.
float ReinhardFindPivot(float peak) {
  float P = peak;
  float P2 = P * P;
  float P3 = P2 * P;
  float P4 = P3 * P;
  float P5 = P4 * P;

  // This follows Wolfram’s structure:
  // A = 2 P^3 + 27 P^2 + 3 sqrt(3) sqrt(4 P^5 + 27 P^4)
  float innerSqrt = 4.0f * P5 + 27.0f * P4;  // 4 P^5 + 27 P^4
  float sqrtTerm = 3.0f * sqrt(3.0f) * sqrt(innerSqrt);
  float A = 2.0f * P3 + 27.0f * P2 + sqrtTerm;

  // Cardano cube roots
  float cbrtA = pow(A, 1.0f / 3.0f);
  float cbrt2 = pow(2.0f, 1.0f / 3.0f);

  // Wolfram expression:
  // x = 1/3 * ( (2^(1/3) P^2)/A^(1/3) + A^(1/3)/2^(1/3) - 2P )
  float term1 = (cbrt2 * P2) / cbrtA;
  float term2 = cbrtA / cbrt2;

  float x = (term1 + term2 - 2.0f * P) / 3.0f;
  return x;
}

#define APPLY_EXTENDED_GENERATOR(T)                           \
  T ApplyReinhardPlus(                                        \
      T x, T base, float peak = 1.f) {                        \
    float pivot_x = ReinhardFindPivot(peak);                  \
    float pivot_y = renodx::tonemap::Reinhard(pivot_x, peak); \
    float slope = ReinhardDerivative(pivot_x, peak);          \
    T offset = pivot_y - slope * pivot_x;                     \
                                                              \
    T extended = slope * x + offset; /* match slope */        \
                                                              \
    return lerp(base, extended, step(pivot_x, x));            \
  }

APPLY_EXTENDED_GENERATOR(float)
APPLY_EXTENDED_GENERATOR(float3)
#undef APPLY_EXTENDED_GENERATOR

// SDR tonemapper
float3 ApplyFromSoftReinhard(float3 untonemapped, float4 g_ReinhardParam, float4 g_ToneMapParam) {
  untonemapped = g_ReinhardParam.y * untonemapped;
  untonemapped = pow(untonemapped, g_ReinhardParam.x);

  float3 tonemapped = renodx::tonemap::Reinhard(untonemapped);
  tonemapped = pow(tonemapped, 1 / g_ToneMapParam.y);

  return tonemapped;
}

#if FORCE_SDR
#define APPLY_FROM_SOFT_REINHARD_EXTENDED_GENERATOR(T)                    \
  T ApplyFromSoftReinhardExtended(T untonemapped, float4 g_ReinhardParam, \
                                  float4 g_ToneMapParam) {                \
    untonemapped = g_ReinhardParam.y * untonemapped;                      \
    untonemapped = pow(untonemapped, g_ReinhardParam.x);                  \
                                                                          \
    T tonemapped = renodx::tonemap::Reinhard(untonemapped);               \
    tonemapped = renodx::math::SignPow(tonemapped, 1 / g_ToneMapParam.y); \
                                                                          \
    return tonemapped;                                                    \
  }
#else
#define APPLY_FROM_SOFT_REINHARD_EXTENDED_GENERATOR(T)                    \
  T ApplyFromSoftReinhardExtended(T untonemapped, float4 g_ReinhardParam, \
                                  float4 g_ToneMapParam) {                \
    untonemapped = g_ReinhardParam.y * untonemapped;                      \
    untonemapped = pow(untonemapped, g_ReinhardParam.x);                  \
                                                                          \
    T base = renodx::tonemap::Reinhard(untonemapped);                     \
    T tonemapped = ApplyReinhardPlus(untonemapped, base);                 \
    tonemapped = lerp(tonemapped, base, 0.25f);                           \
    tonemapped = renodx::math::SignPow(tonemapped, 1 / g_ToneMapParam.y); \
                                                                          \
    return tonemapped;                                                    \
  }
#endif

APPLY_FROM_SOFT_REINHARD_EXTENDED_GENERATOR(float)
APPLY_FROM_SOFT_REINHARD_EXTENDED_GENERATOR(float3)
#undef APPLY_FROM_SOFT_REINHARD_EXTENDED_GENERATOR

float3 ApplyFromSoftToneMapExtended(float3 untonemapped, float4 g_ReinhardParam, float4 g_ToneMapParam) {
  untonemapped = g_ReinhardParam.y * untonemapped;
#if FORCE_SDR
  return pow(renodx::tonemap::Reinhard(pow(untonemapped, g_ReinhardParam.x)), 1 / g_ToneMapParam.y);
#endif

  float3 untonemapped_ch = pow(untonemapped, g_ReinhardParam.x);
  float3 tonemapped = ApplyReinhardPlus(untonemapped_ch, renodx::tonemap::Reinhard(untonemapped_ch));
  tonemapped = pow(tonemapped, 1 / g_ToneMapParam.y);

  if (RENODX_TONE_MAP_PER_CHANNEL == 0.f) {
    float lum_in = LuminosityFromBT709LuminanceNormalized(untonemapped);
    float lum_out = pow(lum_in, g_ReinhardParam.x);
    lum_out = ApplyReinhardPlus(lum_out, renodx::tonemap::Reinhard(lum_out));
    float3 tonemapped_lum = renodx::color::correct::Luminance(untonemapped, lum_in, lum_out);
    tonemapped_lum = pow(tonemapped_lum, 1 / g_ToneMapParam.y);

    tonemapped = CorrectPurityMBBT709WithBT2020(tonemapped_lum, tonemapped);
    // tonemapped = renodx::color::correct::Chrominance(tonemapped_lum, tonemapped);
  } else {
    tonemapped = CorrectHueAndPurityMBBT709WithBT2020(tonemapped, untonemapped, 1.f, 0.f);
    // tonemapped = renodx::color::correct::Hue(tonemapped, untonemapped);
  }
  return tonemapped;
}

bool ApplyLUTAndToneMapAndRenderIntermediatePass(float3 color_linear, Texture3D<float4> lut, SamplerState lut_sampler,
                                                 inout float4 SV_TARGET, float3 TEXCOORD) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  if (CUSTOM_LUT_STRENGTH > 0.f) {
    renodx::lut::Config lut_config = renodx::lut::config::Create();
    lut_config.lut_sampler = lut_sampler;
    lut_config.tetrahedral = true;
    lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
    lut_config.type_output = renodx::lut::config::type::GAMMA_2_2;
    lut_config.scaling = CUSTOM_LUT_SCALING;
    lut_config.strength = CUSTOM_LUT_STRENGTH;
    lut_config.gamut_compress = 2.f;
#if FORCE_SDR
    float maxch_scale = 1.f;
#else
    float maxch_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color_linear);
#endif

    color_linear *= maxch_scale;
    color_linear = renodx::lut::Sample(lut, lut_config, color_linear);
    color_linear /= maxch_scale;
  }

  color_linear = renodx::color::bt2020::from::BT709(color_linear);
  color_linear = max(0, color_linear);

#if !FORCE_SDR
  // float3 purity_hue_reference_bt2020 = renodx::tonemap::neutwo::PerChannel(color_linear, 4.5f);
  float3 purity_hue_reference_bt2020 = renodx::tonemap::ReinhardPiecewise(color_linear, 8.f, 1.f);

  // color_linear = purity_hue_reference_bt2020 * (LuminosityFromBT2020(color_linear) / LuminosityFromBT2020(purity_hue_reference_bt2020));

  const UserGradingConfig cg_config = {
    RENODX_TONE_MAP_EXPOSURE,                             // float exposure;
    RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
    RENODX_TONE_MAP_SHADOWS,                              // float shadows;
    RENODX_TONE_MAP_CONTRAST,                             // float contrast;
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),             // float flare;
    1.f,                                                  // float gamma;
    RENODX_TONE_MAP_SATURATION,                           // float saturation;
    RENODX_TONE_MAP_BLOWOUT,                              // float dechroma;
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
    1.f,                                                  // float hue_emulation;
    1.f                                                   // float purity_emulation;
  };

  float luminosity = LuminosityFromBT2020LuminanceNormalized(color_linear);

  float3 graded_bt2020 = ApplyLuminosityGrading(color_linear, luminosity, cg_config);

  graded_bt2020 = ApplyHueAndPurityGrading(graded_bt2020, purity_hue_reference_bt2020, luminosity, cg_config);

  color_linear = renodx::tonemap::neutwo::MaxChannel(max(0, graded_bt2020), RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  if (CUSTOM_GRAIN_TYPE) {
    color_linear = renodx::color::bt2020::from::BT709(renodx::effects::ApplyFilmGrain(
        renodx::color::bt709::from::BT2020(color_linear.rgb),
        TEXCOORD.xy,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.01f));
  }
#endif

  float3 color_output = renodx::draw::RenderIntermediatePass(color_linear * 100.f);

  SV_TARGET = float4(color_output, 1.f);
  return true;
}

float3 UIBlend(float3 scene_linear, float4 ui_gamma) {
  float3 scene_gamma = renodx::color::gamma::EncodeSafe(scene_linear);
  float scene_luminance = renodx::color::gamma::Encode(max(0, renodx::color::y::from::BT709(scene_linear)));

  // Vanilla highlight rolloff scale
  float lum_diff = scene_luminance - 1.f;
  float scale = lum_diff;
  if (lum_diff > 0.f) {
#if 0
    scale = 0.1f * (1.f - exp2((-lum_diff / 0.1f) * log2(2.71828182846f)));
#else
    scale = renodx::tonemap::Neutwo(lum_diff, 0.1f);
#endif
  }

  // Scene normalization factor influenced by UI alpha
  float alpha_sq = ui_gamma.a * ui_gamma.a;
  float alphad_scale = mad((1.f - scene_luminance + scale), (1.f - alpha_sq), scene_luminance);

  float3 scaled_scene_gamma =
      renodx::math::Select(scene_luminance > 0.f, scene_gamma * (alphad_scale / scene_luminance), 0.f);

  // blend
  float3 blended_gamma = scaled_scene_gamma * ui_gamma.a + ui_gamma.rgb;

  return renodx::color::gamma::DecodeSafe(blended_gamma);
}

void HandleUIScale(inout float4 ui_color_gamma) {
  float3 ui_color_linear = renodx::color::gamma::DecodeSafe(ui_color_gamma.rgb);
  ui_color_linear *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  ui_color_gamma.rgb = renodx::color::gamma::EncodeSafe(ui_color_linear.rgb);
}

bool HandleFinal(float4 scene_pq, float4 ui_gamma, inout float4 SV_TARGET, float4 SV_Position) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  float3 scene_linear = renodx::draw::InvertIntermediatePass(scene_pq.rgb) / 100.f;
  scene_linear = renodx::color::bt709::from::BT2020(scene_linear);

#if 1
  HandleUIScale(ui_gamma);
  float3 blended_linear = UIBlend(scene_linear, ui_gamma);
#else
  float ui_scale = RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  float ui_alpha = ui_gamma.a;
  {  // scale UI
    float3 ui_color_linear = renodx::color::gamma::DecodeSafe(ui_gamma.rgb);
    ui_color_linear *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    ui_gamma.rgb = renodx::color::gamma::EncodeSafe(ui_color_linear.rgb);
  }

  {  // tonemap under UI
    float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(scene_linear, ui_scale * 0.1f);
    scene_linear *= lerp(1.f, scale, 1.f - ui_alpha);
  }

  float3 scene_gamma = renodx::color::gamma::EncodeSafe(scene_linear);

  float3 blended_gamma = scene_gamma * ui_alpha + ui_gamma.rgb;

  float3 blended_linear = renodx::color::gamma::DecodeSafe(blended_gamma);
#endif

  SV_TARGET.rgb = renodx::draw::SwapChainPass(blended_linear).rgb;
  if (!CUSTOM_GRAIN_TYPE) {
    float random = dot(float2(171.0f, 231.0f), float2(SV_Position.x, SV_Position.y));
    SV_TARGET.rgb = ((((frac(random * 0.009345794096589088f) + -0.5f) * 0.0009775171056389809f) * CUSTOM_GRAIN_STRENGTH) + SV_TARGET.rgb);
  }
  SV_TARGET.a = 1.f;
  return true;
}
