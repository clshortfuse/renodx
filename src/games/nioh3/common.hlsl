#include "./shared.h"

float NR(float x, float sigma, float n) {
  float ax = abs(x);
  float xn = pow(max(ax, 0.0f), n);
  float sn = pow(max(sigma, 1e-6f), n);
  float r = xn / (xn + sn);
  return (x < 0.0f) ? -r : r;
}

float NR_inv(float r, float sigma, float n) {
  float ar = abs(r);
  float rc = min(ar, 1.0f - 1e-6f);
  float denom = max(1.0f - rc, 1e-6f);
  float x = sigma * pow(rc / denom, 1.0f / n);
  return (r < 0.0f) ? -x : x;
}

// CVVDP-style chroma plateau, but with a cone-domain Naka-Rushton stage.
// The NR semi-saturation is anchored to CastleCSF achromatic sensitivity
// at the adapting background (heuristic tie between detectability and cone gain).
float3 CastleDechroma_CVVDPStyle_NakaRushton(
    float3 rgb_lin,
    float Lbkg_nits = 100.f,
    float diffuse_white = 100.f,
    float nr_n = 1.00f,
    float nr_response_at_thr = 0.18f) {
  // --------------------------------------------------------------------------
  // 1) Convert stimulus + background to LMS and apply cone-domain NR
  // --------------------------------------------------------------------------
  float3x3 XYZ_TO_LMS_2006 = float3x3(
      0.185082982238733f, 0.584081279463687f, -0.0240722415044404f,
      -0.134433056469973f, 0.405752392775348f, 0.0358252602217631f,
      0.000789456671966863f, -0.000912281325916184f, 0.0198490812339463f);

  float3x3 XYZ_TO_LMS_PROPOSED_2023 = float3x3(
      0.185083290265044, 0.584080232530060, -0.0240724126371618,
      -0.134432464433222, 0.405751419882862, 0.0358251078084051,
      0.000789395399878065, -0.000912213029667692, 0.0198489810108856);

  XYZ_TO_LMS_2006 = XYZ_TO_LMS_PROPOSED_2023;

  const float3x3 LMS_TO_XYZ_2006 = renodx::math::Invert3x3(XYZ_TO_LMS_2006);
  const float3x3 BT709_TO_XYZ = renodx::color::BT709_TO_XYZ_MAT;
  const float3x3 XYZ_TO_BT709 = renodx::color::XYZ_TO_BT709_MAT;
  float3x3 BT709_TO_LMS = mul(XYZ_TO_LMS_2006, BT709_TO_XYZ);

  float3 stim_nits = rgb_lin * diffuse_white;
  float3 lms_stim = mul(BT709_TO_LMS, stim_nits);

  float3 lms_bg = mul(BT709_TO_LMS, float3(1, 1, 1) * Lbkg_nits);

  // CastleCSF sensitivity at background (achromatic) -> contrast threshold proxy.
  const float rho = 1.0f;
  const float omega = 0.0f;
  const float ecc = 0.0f;
  const float vis_field = 0.0f;
  const float area = 3.14159265358979323846f;
  float S_ach = renodx::color::castlecsf::Eq27_29_MechSens(rho, omega, ecc, vis_field, area, Lbkg_nits).x;
  float c_thr = 1.0f / max(S_ach, 1e-6f);

  float r_target = clamp(nr_response_at_thr, 1e-3f, 0.999f);
  float sigma_scale = pow((1.0f - r_target) / r_target, 1.0f / max(nr_n, 1e-3f));
  float x_ref = 1.0f + c_thr;

  // Contrast-domain NR: normalize by background LMS so neutral stays neutral.
  float sigma_rel = max(x_ref * sigma_scale, 1e-6f);
  float3 lms_rel = lms_stim / max(abs(lms_bg), float3(1e-6f, 1e-6f, 1e-6f));

  float3 lms_rel_nr = float3(
      NR(lms_rel.x, sigma_rel, nr_n),
      NR(lms_rel.y, sigma_rel, nr_n),
      NR(lms_rel.z, sigma_rel, nr_n));
  float bg_rel_nr = NR(1.0f, sigma_rel, nr_n);

  float3 lms_stim_nr = lms_rel_nr * lms_bg;
  float3 lms_bg_nr = bg_rel_nr.xxx * lms_bg;

  // Test output
  float luminance_in = renodx::color::y::from::BT709(rgb_lin);
  float3 testout = mul(XYZ_TO_BT709, mul(LMS_TO_XYZ_2006, lms_stim_nr)) / diffuse_white;
  float luminance_out = renodx::color::y::from::BT709(testout);

  return testout * renodx::math::DivideSafe(luminance_in, luminance_out);
}

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  const float y_normalized = y / mid_gray;
  const float highlight_mask = 1.f / mid_gray;
  const float shadow_mask = mid_gray;

  // contrast & flare
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent);

  // highlights
  float y_highlighted = pow(y_contrasted, config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted / highlight_mask));

  // shadows
  float y_shadowed = pow(y_highlighted, -1.f * (config.shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted / shadow_mask));

  const float y_final = y_shadowed * mid_gray;

  color *= (y > 0 ? (y_final / y) : 0);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.blowout));
      if (config.blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 SampleScaledLUT(Texture3D<float4> lut, renodx::lut::Config lut_config, float3 color) {
  float3 linear_input_color = color;

  color = renodx::lut::Sample(lut, lut_config, linear_input_color);
  if (!RENODX_TONE_MAP_TYPE) {
    return color;
  }

  float3 lutOutputLinear = color;

  if (CUSTOM_LUT_SCALING != 0.f) {
    float3 lut_black = 0.f;
    float3 lut_mid_gray = 0.18f;
    float3 lut_white = 1.f;
    lut_black = renodx::lut::Sample(lut, lut_config, lut_black);
    lut_mid_gray = renodx::lut::Sample(lut, lut_config, lut_mid_gray);
    lut_white = renodx::lut::Sample(lut, lut_config, lut_white);

    float3 output_gamma = lutOutputLinear;
    float3 black_gamma = lut_black;
    float3 midgray_gamma = lut_mid_gray;
    float3 peak_gamma = lut_white;
    float3 input_gamma = linear_input_color;

    float mid_gray = renodx::color::y::from::BT709(lut_mid_gray);
    float peak = renodx::color::y::from::BT709(lut_white);

    // linear to gamma
    output_gamma = renodx::color::srgb::EncodeSafe(lutOutputLinear);
    black_gamma = renodx::color::srgb::EncodeSafe(lut_black);
    midgray_gamma = renodx::color::srgb::EncodeSafe(lut_mid_gray);
    peak_gamma = 1.f;
    input_gamma = renodx::color::srgb::EncodeSafe(linear_input_color);

    float3 unclamped_gamma = renodx::lut::Unclamp(
        output_gamma,
        black_gamma,
        midgray_gamma,
        peak_gamma,
        input_gamma);

    float3 recolored = renodx::lut::RecolorUnclamped(
        color,
        renodx::color::srgb::DecodeSafe(unclamped_gamma));

    color = lerp(color, recolored, CUSTOM_LUT_SCALING);
  }
  color = lerp(linear_input_color, color, CUSTOM_LUT_STRENGTH);
  return color;
}

float3 SampleHDRLUT(float3 untonemapped, SamplerState sampleLinear_s, Texture3D<float4> g_tHdrLut) {
  float3 color = untonemapped;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = sampleLinear_s;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = 0.f;
  lut_config.precompute = 32.f;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::ARRI_C1000;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.recolor = 0.f;
  // if (RENODX_TONE_MAP_TYPE) {
  //   color = renodx::tonemap::neutwo::MaxChannel(color);
  // }

  color = SampleScaledLUT(g_tHdrLut, lut_config, color);
  return color;
}

float3 SampleSDRLUT(float3 lut_input_color, SamplerState sampleLinear_s, Texture3D<float4> g_tLdrLut) {
  float3 color = lut_input_color;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = sampleLinear_s;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = 0.f;
  lut_config.precompute = 32.f;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.recolor = 0.f;

  if (RENODX_TONE_MAP_TYPE) {
    color = renodx::tonemap::neutwo::BT709(color);
  }

  color = SampleScaledLUT(g_tLdrLut, lut_config, color);
  return color;
}

// SDR path
float4 ProcessColor(float3 untonemapped, float3 graded) {
  float4 color;
  color.rgb = graded;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    color.rgb = renodx::tonemap::UpgradeToneMap(untonemapped, renodx::tonemap::neutwo::MaxChannel(untonemapped), color.rgb, 1);
  }

  color.rgb = renodx::draw::RenderIntermediatePass(color.rgb);
  color.a = 1.f;

  return color;
}

float4 ProcessColor(float4 color) {
  color.rgb = renodx::tonemap::neutwo::BT709(color.rgb, RENODX_PEAK_NITS / RENODX_DIFFUSE_WHITE_NITS, RENODX_RENO_DRT_WHITE_CLIP);
  color.rgb = renodx::draw::RenderIntermediatePass(color.rgb);
  color.a = 1.f;

  return color;
}

/// Rational curve used in case 4 of Nioh LUT builder.
#define NIOHCURVE_GENERATOR(T)                                                        \
  T ApplyNiohCurve(T x, float A = 30.9882221, float B = 1.19912136,                   \
                   float C = 32.667881, float D = 9.87056255, float E = 8.97784805) { \
    return (x * (A * x + B)) / (x * (C * x + D) + E);                                 \
  }

NIOHCURVE_GENERATOR(float)
NIOHCURVE_GENERATOR(float3)
#undef NIOHCURVE_GENERATOR

// d/dx((A*x*x + B*x) / (C*x*x + D*x + E))
float NiohDerivative(float x, float A, float B, float C, float D, float E) {
  float denom = C * x * x + D * x + E;
  float num = (A * D - B * C) * x * x + (2.f * A * E) * x + (B * E);
  return num / (denom * denom);
}

static const float kInflectionPoint = 0.267011;

#define APPLYNIOHEXTENDED_GENERATOR(T)                                   \
  T ApplyNiohExtended(                                                   \
      T x, T base, float A = 30.9882221, float B = 1.19912136,           \
      float C = 32.667881, float D = 9.87056255, float E = 8.97784805) { \
    float pivot_x = kInflectionPoint;                                    \
                                                                         \
    float pivot_y = ApplyNiohCurve(pivot_x, A, B, C, D, E);              \
                                                                         \
    float slope = NiohDerivative(pivot_x, A, B, C, D, E);                \
                                                                         \
    /* Line passing through (pivot_x, pivot_y) with matching slope */    \
    T offset = pivot_y - slope * pivot_x;                                \
    T extended = slope * x + offset;                                     \
                                                                         \
    return lerp(base, extended, step(pivot_x, x));                       \
  }

APPLYNIOHEXTENDED_GENERATOR(float)
APPLYNIOHEXTENDED_GENERATOR(float3)
#undef APPLYNIOHEXTENDED_GENERATOR