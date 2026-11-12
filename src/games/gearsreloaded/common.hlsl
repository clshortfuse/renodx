#ifndef SRC_GAMES_GEARSRELOADED_COMMON_HLSL_
#define SRC_GAMES_GEARSRELOADED_COMMON_HLSL_

#include "./shared.h"
#include "../../shaders/tonemap/psychov/psychov.hlsl"
#include "./prismTM.hlsl"

#define GEARSRELOADED_CUSTOM_HDR_ENABLED (RENODX_PEAK_WHITE_NITS >= 48.f && RENODX_TONE_MAP_TYPE != GEARSRELOADED_TONE_MAP_TYPE_VANILLA)
#define GEARSRELOADED_HDR_PEAK_NITS clamp(RENODX_PEAK_WHITE_NITS, 48.f, 10000.f)
#define GEARSRELOADED_HDR_PAPER_WHITE_NITS clamp(RENODX_DIFFUSE_WHITE_NITS, 1.f, GEARSRELOADED_HDR_PEAK_NITS)
#define GEARSRELOADED_HDR_UI_NITS clamp(RENODX_GRAPHICS_WHITE_NITS, 1.f, GEARSRELOADED_HDR_PEAK_NITS)

// Captured default native look: 140-nit white, 1000-nit target and brightness 1.3.
// These are reference-curve parameters, independent of the in-game HDR sliders.
static const float GEARSRELOADED_REFERENCE_WHITE_NITS = 140.f;
static const float GEARSRELOADED_REFERENCE_PEAK_NITS = 1000.f;
// The scene's WhiteScale differs from the LUT inverse-Hable white parameter.
static const float GEARSRELOADED_REFERENCE_SCENE_WHITE_SCALE = 1.8271833658218384f;
static const float GEARSRELOADED_REFERENCE_HABLE_INVERSE_WHITE = 0.5151363611221313f;
static const float GEARSRELOADED_REFERENCE_HABLE_ASYMPTOTE = 1.1304830312728882f;

// Preserve the engine's centered packed LUT and interpolation between slices.
float3 GearsReloadedSampleStripLUT(Texture2D<float4> lut, SamplerState lut_sampler, float3 encoded, float size) {
  float3 coordinate = saturate(encoded);
  float lower_slice = floor(coordinate.b * (size - 1.f - 1e-4f));
  float blend = coordinate.b * (size - 1.f) - lower_slice;
  float2 uv = float2((coordinate.r * (size - 1.f) + lower_slice * size + 0.5f) / (size * size),
      (coordinate.g * (size - 1.f) + 0.5f) / size);
  return lerp(lut.SampleLevel(lut_sampler, uv, 0).rgb,
      lut.SampleLevel(lut_sampler, uv + float2(1.f / size, 0.f), 0).rgb, blend);
}

float3 GearsReloadedToneMapPass(float3 untonemapped, float4 overlay,
    Texture2D<float4> grade_lut, SamplerState lut_sampler) {
  untonemapped = max(untonemapped, 0.f);
  float3 hable = (untonemapped * (0.335f * untonemapped + 0.5096f) + 0.2769f)
      / (untonemapped * (0.335f * untonemapped + 0.784f) + 0.663f) - 0.417647064f;
  hable = max(hable * GEARSRELOADED_REFERENCE_SCENE_WHITE_SCALE, 0.f);
  float3 lut_coordinate = renodx::color::pq::EncodeSafe(hable, 100.f);
  float3 reference_bt2020 = renodx::color::pq::DecodeSafe(
      GearsReloadedSampleStripLUT(grade_lut, lut_sampler, lut_coordinate, 32.f) * 1.05f,
      GEARSRELOADED_REFERENCE_WHITE_NITS);
  float3 reference = renodx::color::bt709::from::BT2020(reference_bt2020);

  // Evaluate the same bounded native curve without the artist grade. This is
  // the matched neutral baseline for reconstructing the real upstream HDR,
  // rather than passing a different neutral curve through the artist LUT.
  float maximum_pq = max(max(lut_coordinate.r, lut_coordinate.g), lut_coordinate.b);
  float domain_scale = 1.f;
  if (maximum_pq >= 0.5f) {
    domain_scale = rcp(1.f + exp(-4.f * (maximum_pq - 0.5f))) / max(maximum_pq, 1e-6f);
  }
  float3 neutral = min(hable * domain_scale, 1.f) / domain_scale;
  float neutral_luma = dot(neutral, float3(0.3f, 0.59f, 0.11f));
  float4 recovered = float4(neutral, neutral_luma) / GEARSRELOADED_REFERENCE_HABLE_ASYMPTOTE;
  recovered = renodx::math::Select(recovered < 0.5f, recovered, rcp(1.f + exp(-4.f * (recovered - 0.5f))));
  recovered *= GEARSRELOADED_REFERENCE_HABLE_ASYMPTOTE * GEARSRELOADED_REFERENCE_HABLE_INVERSE_WHITE;
  float4 numerator = 0.309680015f - 1.33280003f * recovered;
  float4 discriminant = numerator * numerator - 4.50839996f * recovered * (0.569500029f * recovered - 0.331650019f);
  recovered = (numerator - sqrt(max(discriminant, 0.f))) / (0.670000017f * (1.70000005f * recovered - 0.990000069f));
  recovered = max(recovered, 0.f);
  recovered = renodx::math::Select(recovered >= 1.f, pow(recovered, 1.3f), recovered);
  float3 neutral_by_luma = neutral * (recovered.w / (neutral_luma + 1e-4f));
  neutral = float3(neutral_by_luma.rg, 0.8f * neutral_by_luma.b + 0.2f * recovered.b);
  float3 neutral_pq = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(neutral), GEARSRELOADED_REFERENCE_WHITE_NITS);
  float peak_pq = renodx::color::pq::Encode(GEARSRELOADED_REFERENCE_PEAK_NITS, 1.f);
  float knee_pq = 0.5f * peak_pq;
  float3 t = saturate((neutral_pq - knee_pq) / (1.f - knee_pq));
  float3 t2 = t * t;
  float3 t3 = t2 * t;
  float3 shoulder = (2.f * t3 - 3.f * t2 + 1.f) * knee_pq
      + (t3 - 2.f * t2 + t) * (1.f - knee_pq) + (-2.f * t3 + 3.f * t2) * peak_pq;
  neutral_pq = renodx::math::Select(neutral_pq < knee_pq, neutral_pq, shoulder);
  neutral = renodx::color::bt709::from::BT2020(renodx::color::pq::DecodeSafe(neutral_pq, GEARSRELOADED_REFERENCE_WHITE_NITS));

  float3 mapped = renodx::draw::ComputeUntonemappedGraded(untonemapped, reference, neutral);
  reference = lerp(neutral, reference, RENODX_COLOR_GRADE_STRENGTH);
  renodx::color::grade::Config grade_config = renodx::color::grade::config::Create(
      RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS, RENODX_TONE_MAP_CONTRAST,
      0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f), RENODX_TONE_MAP_SATURATION, 0.f, 0.f);
  mapped = renodx::color::grade::config::ApplyUserColorGrading(mapped, grade_config);
  reference = renodx::color::grade::config::ApplyUserColorGrading(reference, grade_config);

  float peak = GEARSRELOADED_HDR_PEAK_NITS / GEARSRELOADED_HDR_PAPER_WHITE_NITS;
  if (RENODX_TONE_MAP_TYPE == GEARSRELOADED_TONE_MAP_TYPE_PSYCHOV30) {
    mapped = renodx::tonemap::psychov::psychotm_test30(mapped, peak,
        1.f, 1.f, 1.f, 1.f, RENODX_PSYCHOV30_PURITY_SCALE, 1.f, 100.f, 1.f, 1.f, 0,
        RENODX_PSYCHOV30_CONE_RESPONSE, 0.18f, 0.18f, RENODX_PSYCHOV30_GAMUT_COMPRESSION,
        (int)RENODX_PSYCHOV30_GAMUT_TARGET, 1.f, RENODX_PSYCHOV30_COMPRESSION);
  } else if (RENODX_TONE_MAP_TYPE == GEARSRELOADED_TONE_MAP_TYPE_PRISM) {
    mapped = prism(mapped, peak);
  } else {
    renodx::draw::Config config = renodx::draw::BuildConfig();
    config.tone_map_type = GEARSRELOADED_TONE_MAP_TYPE_RENODRT;
    config.peak_white_nits = GEARSRELOADED_HDR_PEAK_NITS;
    config.diffuse_white_nits = GEARSRELOADED_HDR_PAPER_WHITE_NITS;
    config.tone_map_exposure = 1.f;
    config.tone_map_highlights = 1.f;
    config.tone_map_shadows = 1.f;
    config.tone_map_contrast = 1.f;
    config.tone_map_saturation = 1.f;
    config.tone_map_flare = 0.f;
    config.tone_map_highlight_saturation = 1.f;
    config.tone_map_blowout = 0.f;
    mapped = renodx::draw::ToneMapPass(mapped, config);
  }
  if (RENODX_TONE_MAP_BLOWOUT != 0.f || RENODX_TONE_MAP_HIGHLIGHT_SATURATION != 1.f) {
    mapped = renodx::color::grade::config::ApplyUserColorGrading(mapped,
        renodx::color::grade::config::Create(1.f, 1.f, 1.f, 1.f, 0.f, 1.f,
            RENODX_TONE_MAP_BLOWOUT, 0.f, 0.f, renodx::color::grade::config::hue_correction_type::INPUT,
            1.f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION));
  }
  // Preserve the native reference through paper white; hand highlight range
  // smoothly to the selected RenoDX mapper. Peak and paper white remain mod-owned.
  float match_low = min(1.f, peak * 0.25f);
  float match_high = min(4.f, peak * 0.75f);
  float reference_max = max(reference_bt2020.r, max(reference_bt2020.g, reference_bt2020.b));
  float match_weight = 1.f - smoothstep(match_low, match_high, reference_max);
  mapped = lerp(mapped, reference, match_weight);
  mapped = lerp(mapped, max(overlay.rgb, 0.f), saturate(overlay.a));
  float3 bt2020 = max(renodx::color::bt2020::from::BT709(mapped), 0.f);
  bt2020 *= min(1.f, peak / max(max(bt2020.r, max(bt2020.g, bt2020.b)), 1e-6f));
  return renodx::color::pq::EncodeSafe(bt2020, GEARSRELOADED_HDR_PAPER_WHITE_NITS);
}

#endif  // SRC_GAMES_GEARSRELOADED_COMMON_HLSL_
