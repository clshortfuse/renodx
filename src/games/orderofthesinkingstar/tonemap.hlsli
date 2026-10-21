#ifndef SRC_GAMES_ORDEROFTHESINKINGSTAR_TONEMAP_HLSLI_
#define SRC_GAMES_ORDEROFTHESINKINGSTAR_TONEMAP_HLSLI_

#ifndef NDEBUG
#include "../../shaders/canvas.hlsl"
#endif

static const float SINKING_STAR_MID_GRAY = 0.18f;

struct SinkingStarVanillaToneMapReference {
  float input;
  float output;
  float slope;
  float exposure;
};

float SinkingStarEvaluateVanillaToneMap(float input_value, float tone_map_curve) {
  const float input = max(0.f, input_value);

  if (tone_map_curve == 0.f || tone_map_curve == 3.f) {
    // Normalize the Hable curve with the game's white scale.
    const float numerator = (input * 0.15f + 0.05f) * input + 0.002f;
    const float denominator = (input * 0.15f + 0.5f) * input + 0.06f;
    return saturate((numerator / denominator - 0.03333333134651184f) * 1.6641758680343628f);
  }

  if (tone_map_curve == 1.f || tone_map_curve == 4.f) {
    // Evaluate the Narkowicz fit with the game's coefficients.
    return saturate(((input * 2.51f + 0.03f) * input)
                    / ((input * 2.43f + 0.59f) * input + 0.14f));
  }

  if (tone_map_curve == 2.f || tone_map_curve == 5.f) {
    // Reduce exposure before evaluating the same Narkowicz fit.
    const float scaled_input = input * 0.6f;
    return saturate(((input * 1.506f + 0.03f) * scaled_input)
                    / ((input * 1.458f + 0.59f) * scaled_input + 0.14f));
  }

  if (tone_map_curve == 6.f) {
    // Match the legacy gamma wrapper while leaving updated linear input unchanged.
  #ifdef SINKING_STAR_LINEAR_CURVE_6
    const float curve_input = input;
  #else
    const float curve_input = pow(input, 0.45454543828964233f);
  #endif
    const float3 aces_input = float3(curve_input, curve_input, curve_input);
    const float3 aces_ap1 = float3(
        mad(0.04822999984025955f, aces_input.z, mad(0.35457998514175415f, aces_input.y, aces_input.x * 0.5971900224685669f)),
        mad(0.01565999910235405f, aces_input.z, mad(0.9083399772644043f, aces_input.y, aces_input.x * 0.07599999755620956f)),
        mad(0.8377699851989746f, aces_input.z, mad(0.1338299959897995f, aces_input.y, aces_input.x * 0.0284000001847744f)));
    // Evaluate the Stephen Hill RRT/ODT fit between its input and output transforms.
    const float3 fitted = ((aces_ap1 + 0.024578599259257317f) * aces_ap1 - 9.053700341610238e-05f)
                          / ((aces_ap1 * 0.9837290048599243f + 0.4329510033130646f) * aces_ap1 + 0.23808099329471588f);
    const float3 bt709 = float3(
        mad(-0.07366999983787537f, fitted.z, mad(-0.5310800075531006f, fitted.y, fitted.x * 1.6047500371932983f)),
        mad(-0.006049999967217445f, fitted.z, mad(1.1081299781799316f, fitted.y, fitted.x * -0.10208000242710114f)),
        mad(1.0760200023651123f, fitted.z, mad(-0.07276000082492828f, fitted.y, fitted.x * -0.003269999986514449f)));
  #ifdef SINKING_STAR_LINEAR_CURVE_6
    const float3 output = saturate(bt709);
  #else
    const float3 output = saturate(pow(max(bt709, float3(0.f, 0.f, 0.f)), 2.200000047683716f));
  #endif
    return dot(output, float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  }

  return input;
}

SinkingStarVanillaToneMapReference SinkingStarResolveVanillaToneMapReference(
    float tone_map_curve,
    bool resolve_extension_slope) {
  float lower_input = 0.f;
  float upper_input = 1.f;

  [unroll]
  for (int i = 0; i < 8; ++i) {
    if (SinkingStarEvaluateVanillaToneMap(upper_input, tone_map_curve) >= SINKING_STAR_MID_GRAY) break;
    upper_input *= 2.f;
  }

  [unroll]
  for (int j = 0; j < 18; ++j) {
    const float mid_input = (lower_input + upper_input) * 0.5f;
    if (SinkingStarEvaluateVanillaToneMap(mid_input, tone_map_curve) < SINKING_STAR_MID_GRAY) {
      lower_input = mid_input;
    } else {
      upper_input = mid_input;
    }
  }

  SinkingStarVanillaToneMapReference reference;
  reference.input = upper_input;
  reference.output = SinkingStarEvaluateVanillaToneMap(reference.input, tone_map_curve);
  reference.slope = 0.f;

  if (resolve_extension_slope) {
    // Neutwo alone needs the output-midgray tangent used to extend the bounded vanilla curve.
    const float delta = max(0.005f, reference.input * 0.01f);
    const float derivative_lower_input = max(0.f, reference.input - delta);
    const float derivative_upper_input = reference.input + delta;
    reference.slope = renodx::math::DivideSafe(
        SinkingStarEvaluateVanillaToneMap(derivative_upper_input, tone_map_curve)
            - SinkingStarEvaluateVanillaToneMap(derivative_lower_input, tone_map_curve),
        derivative_upper_input - derivative_lower_input,
        1.f);
  }
  reference.exposure = renodx::math::DivideSafe(reference.output, reference.input, 1.f);
  return reference;
}

float3 SinkingStarApplyVanillaToneMapExtended(
    float3 untonemapped,
    float3 vanilla,
    float tone_map_curve,
    SinkingStarVanillaToneMapReference reference) {
  if (tone_map_curve == 0.f || tone_map_curve == 1.f || tone_map_curve == 2.f) {
    // Extend relative luminance and preserve RGB ratios for the scalar curve variants.
    const float input_y = dot(
        untonemapped,
        float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    if (input_y <= reference.input) return vanilla;

    const float extended_y = max(
        0.f,
        reference.output + reference.slope * (input_y - reference.input));
    return untonemapped * renodx::math::DivideSafe(extended_y, input_y, 1.f);
  }

  const float3 extended = max(
      float3(0.f, 0.f, 0.f),
      reference.output + reference.slope * (untonemapped - reference.input));
  return lerp(
      vanilla,
      extended,
      step(float3(reference.input, reference.input, reference.input), untonemapped));
}

float SinkingStarResolvePsychoVPeak() {
  float peak_value = max(
      1.f,
      renodx::math::DivideSafe(RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS, 1.f));
  if (RENODX_GAMMA_CORRECTION == renodx::draw::GAMMA_CORRECTION_GAMMA_2_2) {
    peak_value = renodx::color::correct::Gamma(peak_value, true, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == renodx::draw::GAMMA_CORRECTION_GAMMA_2_4) {
    peak_value = renodx::color::correct::Gamma(peak_value, true, 2.4f);
  }
  return peak_value;
}

float SinkingStarResolvePsychoVExposure(SinkingStarVanillaToneMapReference reference) {
  return RENODX_PSYCHOV_VANILLA_MIDGRAY >= 0.5f
             ? reference.exposure
             : 1.f;
}

float SinkingStarResolveVanillaToneMapInflectionInput(float tone_map_curve) {
  // Positive roots of V''(x) = 0 for the exact scalar game curves. Curves 0 and 3 have no positive root.
  if (tone_map_curve == 1.f || tone_map_curve == 4.f) return 0.120305925f;
  if (tone_map_curve == 2.f || tone_map_curve == 5.f) return 0.200509877f;
#ifdef SINKING_STAR_LINEAR_CURVE_6
  if (tone_map_curve == 6.f) return 0.249083227f;
#else
  if (tone_map_curve == 6.f) return 0.083283576f;
#endif
  return 0.f;
}

float SinkingStarResolvePsychoVConeBaseline(float tone_map_curve) {
  if (RENODX_PSYCHOV_VANILLA_SLOPE < 0.5f) return 1.f;

  const float inflection_input = SinkingStarResolveVanillaToneMapInflectionInput(tone_map_curve);
  if (inflection_input <= 0.f) return 1.f;

  const float inflection_output = SinkingStarEvaluateVanillaToneMap(inflection_input, tone_map_curve);
  const float delta = max(0.005f, inflection_input * 0.01f);
  const float lower_input = max(0.f, inflection_input - delta);
  const float slope = renodx::math::DivideSafe(
      SinkingStarEvaluateVanillaToneMap(inflection_input + delta, tone_map_curve)
          - SinkingStarEvaluateVanillaToneMap(lower_input, tone_map_curve),
      inflection_input + delta - lower_input,
      1.f);
  const float contrast = renodx::math::DivideSafe(
      inflection_input * slope,
      inflection_output,
      1.f);
  return isfinite(contrast) && contrast > 0.f ? contrast : 1.f;
}

float SinkingStarResolvePsychoVConeResponse(float tone_map_curve) {
  return SinkingStarResolvePsychoVConeBaseline(tone_map_curve)
         * max(0.f, RENODX_TONE_MAP_CONE_CONTRAST);
}

float3 SinkingStarApplyPsychoV17(
    float3 untonemapped,
    SinkingStarVanillaToneMapReference reference,
    float tone_map_curve) {
  return renodx::tonemap::psychov::psychotm_test17(
      untonemapped * SinkingStarResolvePsychoVExposure(reference),
      SinkingStarResolvePsychoVPeak(),
      RENODX_TONE_MAP_EXPOSURE,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS,
      RENODX_TONE_MAP_CONTRAST,
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_BLOWOUT,
      100.f,
      1.f,
      1.f,
      1,
      SinkingStarResolvePsychoVConeResponse(tone_map_curve),
      float3(SINKING_STAR_MID_GRAY, SINKING_STAR_MID_GRAY, SINKING_STAR_MID_GRAY),
      float3(SINKING_STAR_MID_GRAY, SINKING_STAR_MID_GRAY, SINKING_STAR_MID_GRAY),
      saturate(RENODX_PSYCHOV_GAMUT_COMPRESSION),
      RENODX_SWAP_CHAIN_OUTPUT_PRESET == renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_SDR ? 0 : 1);
}

float3 SinkingStarApplyPsychoV30(
    float3 untonemapped,
    SinkingStarVanillaToneMapReference reference,
    float tone_map_curve) {
  return renodx::tonemap::psychov::psychotm_test30(
      untonemapped * SinkingStarResolvePsychoVExposure(reference),
      SinkingStarResolvePsychoVPeak(),
      RENODX_TONE_MAP_EXPOSURE,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS,
      RENODX_TONE_MAP_CONTRAST,
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_BLOWOUT,
      100.f,
      1.f,
      1.f,
      1,
      SinkingStarResolvePsychoVConeResponse(tone_map_curve),
      float3(SINKING_STAR_MID_GRAY, SINKING_STAR_MID_GRAY, SINKING_STAR_MID_GRAY),
      float3(SINKING_STAR_MID_GRAY, SINKING_STAR_MID_GRAY, SINKING_STAR_MID_GRAY),
      saturate(RENODX_PSYCHOV_GAMUT_COMPRESSION),
      RENODX_SWAP_CHAIN_OUTPUT_PRESET == renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_SDR ? 0 : 1,
      1.f,
      clamp(RENODX_PSYCHOV_COMPRESSION, 0.f, 2.f));
}

#ifndef NDEBUG
float3 SinkingStarDrawPsychoVDebugCanvas(
    float3 color,
    float2 sv_position,
    float tone_map_curve,
    float tone_map_type,
    SinkingStarVanillaToneMapReference reference) {
  const float exposure_multiplier = max(0.f, RENODX_TONE_MAP_EXPOSURE);
  const float final_exposure = SinkingStarResolvePsychoVExposure(reference) * exposure_multiplier;
  const float inflection_input = SinkingStarResolveVanillaToneMapInflectionInput(tone_map_curve);
  const float cone_baseline = SinkingStarResolvePsychoVConeBaseline(tone_map_curve);
  const float cone_multiplier = max(0.f, RENODX_TONE_MAP_CONE_CONTRAST);
  const float final_cone_response = SinkingStarResolvePsychoVConeResponse(tone_map_curve);
  const float2 panel_min = float2(10.f, 10.f);
  const float2 panel_max = float2(322.f, 262.f);

  renodx::canvas::Context context = renodx::canvas::CreateContext(
      sv_position,
      panel_min + float2(8.f, 8.f),
      float2(8.f, 12.f),
      color,
      1.f,
      float3(1.f, 1.f, 1.f),
      1.f,
      1.f,
      renodx::canvas::MODE_NORMAL,
      0.f,
      1.15f);

  renodx::canvas::SetColor(context, 0x101418, 0.96f, 1.f);
  renodx::canvas::FillRect(context, panel_min, panel_max);

  renodx::canvas::SetColor(context, 0x3df58f, 1.f, 1.f);
  renodx::canvas::DrawText(context, 'P', 's', 'y', 'c', 'h', 'o', 'V', ' ', 'c', 'a', 'l', 'c');
  renodx::canvas::NewLine(context);

  renodx::canvas::SetColor(context, 0xd8dde3, 1.f, 1.f);
  renodx::canvas::DrawText(context, 'M', 'o', 'd', 'e', ':');
  renodx::canvas::InsertSpace(context);
  if (tone_map_type == RENODX_TONE_MAP_TYPE_PSYCHOV17) {
    renodx::canvas::DrawText(context, 'P', 's', 'y', 'c', 'h', 'o', 'V', '-', '1', '7');
  } else if (tone_map_type == RENODX_TONE_MAP_TYPE_PSYCHOV30) {
    renodx::canvas::DrawText(context, 'P', 's', 'y', 'c', 'h', 'o', 'V', '-', '3', '0');
  } else {
    renodx::canvas::DrawText(context, 'N', 'e', 'u', 't', 'w', 'o');
  }
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'C', 'u', 'r', 'v', 'e', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, tone_map_curve, 0.f, 0.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'T', 'a', 'r', 'g', 'e', 't', ' ', 'V', '(', 'x', ')', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, SINKING_STAR_MID_GRAY, 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'R', 'e', 'f', ' ', 'x', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, reference.input, 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'V', '(', 'x', ')', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, reference.output, 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'E', 'x', 'p', '=', 'V', '/', 'x', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, reference.exposure, 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'U', 's', 'e', 'r', ' ', 'e', 'x', 'p', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, exposure_multiplier, 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'F', 'i', 'n', 'a', 'l', ' ', 'e', 'x', 'p', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, final_exposure, 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'M', 'i', 'd', ' ', 'r', 'e', 'f', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, RENODX_PSYCHOV_VANILLA_MIDGRAY, 0.f, 0.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'S', 'l', 'o', 'p', 'e', ' ', 'r', 'e', 'f', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, RENODX_PSYCHOV_VANILLA_SLOPE, 0.f, 0.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'I', 'n', 'f', 'l', ' ', 'x', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, inflection_input, 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'C', 'o', 'n', 'e', ' ', 'b', 'a', 's', 'e', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, cone_baseline, 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'U', 's', 'e', 'r', ' ', 'c', 'o', 'n', 'e', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, cone_multiplier, 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'F', 'i', 'n', 'a', 'l', '=', 'B', 'a', 's', 'e', '*', 'U', 's', 'e', 'r', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, final_cone_response, 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'G', 'a', 'm', 'u', 't', ' ', 'c', 'o', 'm', 'p', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, saturate(RENODX_PSYCHOV_GAMUT_COMPRESSION), 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'R', 'e', 's', 'p', ' ', 'c', 'o', 'm', 'p', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, clamp(RENODX_PSYCHOV_COMPRESSION, 0.f, 2.f), 0.f, 6.f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'C', 'h', 'e', 'c', 'k', ' ', 'x', '*', 'F', 'i', 'n', 'a', 'l', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, reference.input * final_exposure, 0.f, 6.f);

  return context.output_color;
}
#endif

#endif  // SRC_GAMES_ORDEROFTHESINKINGSTAR_TONEMAP_HLSLI_