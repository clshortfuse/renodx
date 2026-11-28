#ifndef SRC_GAMES_GEARS5_COMMON_HLSL_
#define SRC_GAMES_GEARS5_COMMON_HLSL_

#include "./shared.h"
#include "../../shaders/tonemap/psychov/test35.hlsl"
#include "./prismTM.hlsl"

#define GEARS5_CUSTOM_HDR_ENABLED (RENODX_PEAK_WHITE_NITS >= 48.f && RENODX_TONE_MAP_TYPE != GEARS5_TONE_MAP_TYPE_VANILLA)
#define GEARS5_HDR_PEAK_NITS clamp(RENODX_PEAK_WHITE_NITS, 48.f, 10000.f)
#define GEARS5_HDR_PAPER_WHITE_NITS clamp(RENODX_DIFFUSE_WHITE_NITS, 1.f, GEARS5_HDR_PEAK_NITS)
#define GEARS5_HDR_UI_NITS clamp((RENODX_GRAPHICS_WHITE_NITS > 0.f ? RENODX_GRAPHICS_WHITE_NITS : 203.f), 1.f, 203.f)

// Native UE filmic curve, evaluated at nearby neutral inputs to measure the
// current scene's midgray tangent rather than assuming fixed film parameters.
float Gears5FilmicCurve(float input, float slope, float toe, float shoulder, float black_clip, float white_clip) {
  float toe_width = max(1.f + black_clip - toe, 1.e-5f);
  float shoulder_width = max(1.f + white_clip - shoulder, 1.e-5f);
  slope = max(slope, 1.e-5f);
  float toe_norm = clamp((black_clip + 0.18f) / toe_width, 1.e-5f, 2.f - 1.e-5f);
  float toe_threshold = (toe > 0.8f
      ? (0.82f - toe) / slope - 0.744727492f
      : -0.744727492f - 0.5f * log(toe_norm / (2.f - toe_norm)) * toe_width / slope);
  float mid_anchor = (1.f - toe) / slope - toe_threshold;
  float shoulder_threshold = shoulder / slope - mid_anchor;
  float log_input = log10(max(input, 1.e-10f));
  float straight = slope * (log_input + mid_anchor);
  float toe_curve = (log_input < toe_threshold
      ? 2.f * toe_width / (1.f + exp(-2.f * slope * (log_input - toe_threshold) / toe_width)) - black_clip
      : straight);
  float shoulder_curve = (log_input > shoulder_threshold
      ? 1.f + white_clip - 2.f * shoulder_width / (1.f + exp(2.f * slope * (log_input - shoulder_threshold) / shoulder_width))
      : straight);
  float threshold_range = shoulder_threshold - toe_threshold;
  float blend = saturate((log_input - toe_threshold)
      / (abs(threshold_range) < 1.e-6f ? 1.e-6f : threshold_range));
  if (shoulder_threshold < toe_threshold) {
    blend = 1.f - blend;
  }
  return lerp(toe_curve, shoulder_curve, blend * blend * (3.f - 2.f * blend));
}

// Extend the actual pre-clip filmic signal, before the artist LUT. Like other
// UE Vanilla+ paths, keep the toe and blend toward a linear midgray tangent.
float3 Gears5ExtendFilmic(float3 input, float3 vanilla, float slope, float toe, float shoulder, float black_clip, float white_clip) {
  const float pivot = 0.18f;
  const float epsilon = pivot / 1024.f;
  float pivot_output = Gears5FilmicCurve(pivot, slope, toe, shoulder, black_clip, white_clip);
  float pivot_slope = max(0.f,
      (Gears5FilmicCurve(pivot + epsilon, slope, toe, shoulder, black_clip, white_clip)
       - Gears5FilmicCurve(pivot - epsilon, slope, toe, shoulder, black_clip, white_clip)) / (2.f * epsilon));
  float3 tail = pivot_output + pivot_slope * (input - pivot);
  float3 extended = (input > pivot ? max(vanilla, tail) : vanilla);
  float headroom = saturate(GEARS5_HDR_PEAK_NITS / GEARS5_HDR_PAPER_WHITE_NITS - 1.f);
  extended = lerp(vanilla, extended, 0.8f * saturate(vanilla / 0.5f) * headroom);
  // Preserve the native post-curve desaturation in the same working space.
  float luminance = dot(extended, float3(0.272228718f, 0.674081743f, 0.0536895171f));
  return max(lerp(luminance.xxx, extended, 0.93f), 0.f);
}

// Input and output are linear BT.709, relative to diffuse white. Call only at
// a verified scene-linear tone-map input; preserve the game's output encoding
// and UI composition separately in the eventual Gears 5 shader replacement.
float3 Gears5ToneMapPass(float3 untonemapped) {
  if (!GEARS5_CUSTOM_HDR_ENABLED) return untonemapped;

  float peak_nits = clamp(RENODX_PEAK_WHITE_NITS, 48.f, 10000.f);
  float paper_white_nits = clamp(RENODX_DIFFUSE_WHITE_NITS, 1.f, peak_nits);
  float peak = peak_nits / paper_white_nits;

  if (RENODX_TONE_MAP_TYPE == GEARS5_TONE_MAP_TYPE_RENODRT) {
    renodx::draw::Config config = renodx::draw::BuildConfig();
    config.peak_white_nits = peak_nits;
    config.diffuse_white_nits = paper_white_nits;
    return renodx::draw::ToneMapPass(untonemapped, config);
  }

  float3 graded = renodx::color::grade::config::ApplyUserColorGrading(
      max(untonemapped, 0.f),
      renodx::color::grade::config::Create(
          RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS,
          RENODX_TONE_MAP_CONTRAST, 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
          RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_BLOWOUT, 0.f, 0.f,
          renodx::color::grade::config::hue_correction_type::INPUT,
          1.f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION));
  graded = max(graded, 0.f);

  float3 mapped = graded;
  if (RENODX_TONE_MAP_TYPE == GEARS5_TONE_MAP_TYPE_PSYCHOV35) {
    mapped = renodx::tonemap::psychov::psychotm_test35(
        graded, peak, 1.f, 1.f, 1.f, 1.f, RENODX_PSYCHOV35_PURITY_SCALE,
        1.f, 100.f, 1.f, 1.f, 0, max(RENODX_PSYCHOV35_CONE_RESPONSE, 1.e-4f),
        0.18f, 0.18f, RENODX_PSYCHOV35_GAMUT_COMPRESSION,
        (int)RENODX_PSYCHOV35_GAMUT_TARGET, 1.f, RENODX_PSYCHOV35_COMPRESSION);
  } else if (RENODX_TONE_MAP_TYPE == GEARS5_TONE_MAP_TYPE_PRISM) {
    mapped = prism(graded, peak);
  } else if (RENODX_TONE_MAP_TYPE == GEARS5_TONE_MAP_TYPE_VANILLA_PLUS) {
    // Leave SDR-range values untouched; roll only HDR highlights toward peak.
    if (peak <= 1.f) return saturate(graded);
    mapped = min(graded, 1.f)
        + renodx::tonemap::Reinhard(max(graded - 1.f, 0.f), peak - 1.f);
  }

  if (!all(isfinite(mapped))) {
    mapped = graded / (1.f + max(graded.r, max(graded.g, graded.b)) / peak);
  }
  return mapped;
}

// Use the native filmic result as the neutral baseline for the artist grade.
// This preserves native LUT addressing instead of grading HDR-mapped colors.
float3 Gears5ToneMapPass(float3 untonemapped, float3 graded_sdr, float3 neutral_sdr, float3 extended_filmic) {
  return Gears5ToneMapPass(renodx::draw::ComputeUntonemappedGraded(
      (RENODX_TONE_MAP_TYPE == GEARS5_TONE_MAP_TYPE_VANILLA_PLUS ? extended_filmic : untonemapped),
      graded_sdr, neutral_sdr, renodx::draw::BuildConfig()));
}

float3 Gears5MatchSDR(float3 mapped, float3 reference) {
  float reference_luminance = renodx::color::y::from::BT709(saturate(reference));
  // A bright saturated channel must not be treated as a low-luminance shadow.
  float reference_level = max(reference_luminance, max(reference.r, max(reference.g, reference.b)));
  float mapped_luminance = max(renodx::color::y::from::BT709(mapped), 0.f);
  float weight = saturate(GEARS5_SDR_CONTRAST_MATCH)
      * (1.f - smoothstep(0.01f, 0.05f, reference_level));
  // Multiplying zero cannot recover SDR shadow detail lost by the HDR mapper.
  float3 matched = reference;
  if (mapped_luminance > 1.e-6f) {
    matched = mapped * (reference_luminance / mapped_luminance);
  }
  return lerp(mapped, matched, weight);
}

// FinalSceneBuffer and CASBuffer are 10-bit UNORM. Carry peak-relative gamma-2
// values through them and compensate the native scene composite's 1.05 gain.
float3 Gears5EncodeSceneCarrier(float3 mapped) {
  float peak = GEARS5_HDR_PEAK_NITS / GEARS5_HDR_PAPER_WHITE_NITS;
  mapped = max(mapped, 0.f);
  mapped *= min(1.f, peak / max(max(mapped.r, max(mapped.g, mapped.b)), 1.e-6f));
  return sqrt(mapped / peak) / 1.05f;
}

// Decode the peak-relative carrier and composite the separate SDR UI in
// linear nits. Both compute and raster output paths use the same PQ encoding.
float3 Gears5CompositeHDR(float3 scene_carrier, float4 ui) {
  float3 scene_linear = scene_carrier * scene_carrier * GEARS5_HDR_PEAK_NITS / GEARS5_HDR_PAPER_WHITE_NITS;
  float3 sdr_part = saturate(scene_linear);
  scene_linear += renodx::color::correct::GammaSafe(sdr_part, false, 2.2f) - sdr_part;
  float3 scene_nits = scene_linear * GEARS5_HDR_PAPER_WHITE_NITS;
  float3 ui_nits = renodx::color::srgb::Decode(saturate(ui.rgb)) * GEARS5_HDR_UI_NITS;
  float3 composited = lerp(scene_nits, ui_nits, saturate(ui.a));
  float3 bt2020 = max(renodx::color::bt2020::from::BT709(composited), 0.f);
  return renodx::color::pq::EncodeSafe(bt2020, 1.f);
}

#endif  // SRC_GAMES_GEARS5_COMMON_HLSL_
