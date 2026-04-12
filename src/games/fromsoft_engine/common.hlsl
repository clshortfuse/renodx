#include "./psycho_test17_custom.hlsli"
#include "./shared.h"

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
    float lum_in = renodx::color::yf::from::BT709(untonemapped);
    float lum_out = pow(lum_in, g_ReinhardParam.x);
    lum_out = ApplyReinhardPlus(lum_out, renodx::tonemap::Reinhard(lum_out));
    float3 tonemapped_lum = renodx::color::correct::Luminance(untonemapped, lum_in, lum_out);
    tonemapped_lum = pow(tonemapped_lum, 1 / g_ToneMapParam.y);

    tonemapped = CorrectPurityMBBT709WithBT2020(tonemapped_lum, tonemapped);
  } else {
    tonemapped = CorrectHueAndPurityMBBT709WithBT2020(tonemapped, untonemapped, 1.f, 0.f);
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

  float3 color_linear_bt709 = color_linear;
  color_linear = renodx::color::bt2020::from::BT709(color_linear_bt709);
  color_linear = max(0, color_linear);

#if !FORCE_SDR
  renodx_custom::tonemap::psycho::config17::Config psycho17_config = renodx_custom::tonemap::psycho::config17::Create();
  psycho17_config.peak_value = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  psycho17_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  psycho17_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  psycho17_config.shadows = RENODX_TONE_MAP_SHADOWS;
  psycho17_config.contrast = RENODX_TONE_MAP_CONTRAST;
  psycho17_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  psycho17_config.purity_scale = RENODX_TONE_MAP_SATURATION;
  psycho17_config.purity_highlights = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  psycho17_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  psycho17_config.pre_gamut_compress = false;
  psycho17_config.post_gamut_compress = true;
  psycho17_config.hue_emulation = 1.f;

  float3 purity_hue_reference_bt2020 = renodx::tonemap::ReinhardPiecewise(color_linear, 5.f, psycho17_config.mid_gray);
  if (RENODX_TONE_MAP_TYPE == 3.f) {  // custom maxch hues and purity
    psycho17_config.apply_lms_tonemap = false;

    color_linear = renodx::color::correct::Luminance(
        purity_hue_reference_bt2020,
        renodx::color::yf::from::BT2020(purity_hue_reference_bt2020),
        renodx::color::yf::from::BT2020(color_linear));
  }
  color_linear = renodx_custom::tonemap::psycho::ApplyTest17BT2020(color_linear, purity_hue_reference_bt2020, psycho17_config);

  if (CUSTOM_GRAIN_TYPE) {
    color_linear = (renodx::effects::ApplyFilmGrain(
        color_linear.rgb, TEXCOORD.xy, CUSTOM_RANDOM, CUSTOM_GRAIN_STRENGTH * 0.01f,
        1.f, false, renodx::color::BT2020_TO_XYZ_MAT));
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

bool HandleFinal(float4 scene_pq, float4 ui_gamma, inout float4 SV_TARGET, float4 SV_Position, bool force = false) {
  if (RENODX_TONE_MAP_TYPE == 0.f && !force) return false;

  float3 scene_linear = renodx::draw::InvertIntermediatePass(scene_pq.rgb) / 100.f;
  scene_linear = renodx::color::bt709::from::BT2020(scene_linear);

  float3 blended_linear;
  if (CUSTOM_SHOW_UI) {
    HandleUIScale(ui_gamma);
    blended_linear = UIBlend(scene_linear, ui_gamma);
  } else {
    blended_linear = scene_linear;
  }


  SV_TARGET.rgb = renodx::draw::SwapChainPass(blended_linear).rgb;
  if (!CUSTOM_GRAIN_TYPE) {
    float random = dot(float2(171.0f, 231.0f), float2(SV_Position.x, SV_Position.y));
    SV_TARGET.rgb = ((((frac(random * 0.009345794096589088f) + -0.5f) * 0.0009775171056389809f) * CUSTOM_GRAIN_STRENGTH) + SV_TARGET.rgb);
  }
  SV_TARGET.a = 1.f;
  return true;
}
