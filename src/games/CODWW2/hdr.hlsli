#ifndef CODWW2_HDR_HLSLI_
#define CODWW2_HDR_HLSLI_

#include "./shared.h"
#include "../../shaders/tonemap/psychov/psychov.hlsl"

float3 CODWW2SafePositive(float3 color) {
  return clamp(renodx::math::ZeroNaN(color), 0.f, 100000000.f);
}

float CODWW2Max3(float3 color) {
  return max(color.r, max(color.g, color.b));
}

float3 reinhardPiecewiseSmooth(float3 color, float peak, float anchor) {
  color = CODWW2SafePositive(color);
  peak = max(peak, 0.000001f);
  anchor = clamp(anchor, 0.f, peak);
  float3 distance = max(color - anchor, 0.f);
  float range = max(peak - anchor, 0.000001f);
  float3 t = distance / range;
  float3 shoulder = exp(-0.01f / max(t * t, 0.000001f));
  return min(color, anchor) + range * t / (1.f + t * shoulder);
}

#include "./prismTM.hlsl"

float3 CODWW2PQDecodeNits(float3 pq) {
  return renodx::color::pq::Decode(saturate(pq), 1.f);
}

float3 CODWW2PQEncodeNits(float3 nits) {
  return renodx::color::pq::Encode(clamp(CODWW2SafePositive(nits), 0.f, 10000.f), 1.f);
}

// Also used after the game's temporal/post-processing and UI composition.
float3 CODWW2LimitPeak(float3 bt2020_nits) {
  bt2020_nits = CODWW2SafePositive(bt2020_nits);
  // Leave room for the game's approximate gamut matrix and FP16 rounding.
  float peak = clamp(RENODX_PEAK_WHITE_NITS, 48.f, 4000.f) * 0.999f;
  float maximum = CODWW2Max3(bt2020_nits);
  float start = peak * 0.99f;
  if (maximum > start) {
    float limited = start + (peak - start) * (1.f - exp(-(maximum - start) / (peak - start)));
    bt2020_nits *= min(limited, peak) / maximum;
  }
  return bt2020_nits;
}

// Vanilla's native LUT stays near-linear to ~45% of its peak (measured 2026-10-17:
// 632 nits at input 8 with a 1417-nit ceiling; log-slope 4->8 0.944, 8->16 0.597).
// Starting the custom shoulder at diffuse white instead compressed 300-650 nit
// content and made bright scenes dimmer on average than Vanilla.
#define CODWW2_SHOULDER_KNEE 0.45f  // fraction of Peak Brightness

// Shoulder start in `relative` units (output nits / diffuse white); never below
// diffuse white.
float CODWW2ShoulderKnee() {
  return max(CODWW2_SHOULDER_KNEE * RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.f), 1.f);
}

float3 CODWW2MapShoulder(float3 color, float knee) {
  // Reserve the native range below the knee. Translate each mapper's 0.18
  // anchor to the knee so switching mappers does not compress midtones again.
  float peak_relative = max(RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.f) - knee + 0.18f, 0.180001f);
  if (RENODX_TONE_MAP_TYPE == CODWW2_TONE_MAP_TYPE_PSYCHOV30) {
    return renodx::tonemap::psychov::psychotm_test30(
        color, peak_relative, 1.f, 1.f, 1.f, 1.f,
        RENODX_PSYCHOV30_PURITY_SCALE, 1.f, 100.f, 1.f, 1.f, 0,
        max(RENODX_PSYCHOV30_CONE_RESPONSE, 0.0001f), 0.18f.xxx, 0.18f.xxx,
        RENODX_PSYCHOV30_GAMUT_COMPRESSION,
        RENODX_PSYCHOV30_GAMUT_TARGET >= 0.5f ? 1 : 0, 1.f,
        RENODX_PSYCHOV30_COMPRESSION);
  }
  if (RENODX_TONE_MAP_TYPE == CODWW2_TONE_MAP_TYPE_PRISM) {
    return prism(color, peak_relative);
  }
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.peak_white_nits = peak_relative * RENODX_DIFFUSE_WHITE_NITS;
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  // Shared grading has already run, once, for all three mappers.
  config.tone_map_exposure = 1.f;
  config.tone_map_highlights = 1.f;
  config.tone_map_shadows = 1.f;
  config.tone_map_contrast = 1.f;
  config.tone_map_saturation = 1.f;
  config.tone_map_highlight_saturation = 1.f;
  config.tone_map_blowout = 0.f;
  config.tone_map_flare = 0.f;
  return renodx::draw::ToneMapPass(color, config);
}

float3 CODWW2SampleLUTNits(Texture3D<float4> lut, SamplerState lut_sampler,
                          float3 color, float3 scale, float3 offset) {
  float3 coord = saturate((log2(CODWW2SafePositive(color) + 0.0009765625f) + 10.f) * 0.05f);
  return CODWW2PQDecodeNits(lut.SampleLevel(lut_sampler, coord * scale + offset, 0.f).rgb);
}

// The native LUT is rebuilt by the game at level load and on HDR menu changes,
// so it carries both the level's grade and the menu settings, and each level's
// curve differs (measured 2026-10-17: one level's neutral log-slope was 1.05
// at inputs 2->4, 0.94 at 4->8 and 0.60 at 8->16; another stayed 1.12-1.27 up
// to 16). Its baked shoulder flattened highlights to white near the game's peak.
// Up to input 2 the live LUT is used as-is. Above it, the live LUT's shoulder is
// located per frame by walking octaves until the neutral log-slope drops below
// CODWW2_LUT_LINEAR_SLOPE. Luminance follows the live LUT up to that point and
// continues at its last near-linear slope beyond it; grade color is sampled one
// octave below the shoulder so no channel reaches the LUT ceiling. The selected
// mapper and Peak Brightness then own highlight compression.
// Menu settings are NOT isolated (the LUT is CPU-built; see README).
#define CODWW2_LUT_LINEAR_SLOPE 0.9f  // octave log-slope treated as the LUT shoulder
#define CODWW2_LUT_CEILING_FRACTION 0.5f  // never follow the LUT above half its maximum
#define CODWW2_LUT_MAX_SLOPE 1.5f  // cap on the continuation slope
static const float3 CODWW2_Y2020 = float3(0.2627f, 0.6780f, 0.0593f);

float CODWW2NeutralY(Texture3D<float4> lut, SamplerState lut_sampler, float x,
                     float3 scale, float3 offset) {
  return max(dot(CODWW2SampleLUTNits(lut, lut_sampler, x.xxx, scale, offset), CODWW2_Y2020), 0.0001f);
}

float3 CODWW2MapHDR(float3 source_bt2020, float3 native_pq,
                   Texture3D<float4> lut, SamplerState lut_sampler,
                   float3 scale, float3 offset) {
  source_bt2020 = CODWW2SafePositive(source_bt2020);
  float source_y = max(dot(source_bt2020, CODWW2_Y2020), 0.f);
  float grade_strength = saturate(RENODX_COLOR_GRADE_STRENGTH);
  float3 graded_nits;
  if (source_y <= 2.f) {
    float neutral_y = CODWW2NeutralY(lut, lut_sampler, source_y, scale, offset);
    float3 neutral_nits = source_bt2020 * (neutral_y / max(source_y, 0.000001f));
    graded_nits = lerp(neutral_nits, CODWW2PQDecodeNits(native_pq), grade_strength);
  } else {
    float shoulder_x = 2.f;
    float shoulder_y = CODWW2NeutralY(lut, lut_sampler, shoulder_x, scale, offset);
    // Also stop before the LUT's own roll-off: interior/transition LUTs can keep
    // a steep octave slope until just below their ceiling, which made the walk
    // reach input 1024 and reproduce Vanilla's colour and peak for ~1 second.
    float ceiling_y = CODWW2NeutralY(lut, lut_sampler, 1024.f, scale, offset) * CODWW2_LUT_CEILING_FRACTION;
    float slope = 1.f;
    [loop]
    for (int i = 0; i < 9; ++i) {  // inputs up to 1024
      float next_y = CODWW2NeutralY(lut, lut_sampler, shoulder_x * 2.f, scale, offset);
      float octave_slope = log2(next_y / shoulder_y);
      if (octave_slope < CODWW2_LUT_LINEAR_SLOPE || next_y > ceiling_y) break;
      slope = min(octave_slope, CODWW2_LUT_MAX_SLOPE);
      shoulder_x *= 2.f;
      shoulder_y = next_y;
    }
    float tone_y = source_y <= shoulder_x
        ? CODWW2NeutralY(lut, lut_sampler, source_y, scale, offset)
        : shoulder_y * pow(source_y / shoulder_x, slope);

    float sample_y = min(source_y, max(shoulder_x * 0.5f, 2.f));
    float3 sample_bt2020 = source_bt2020 * (sample_y / source_y);
    float neutral_y = CODWW2NeutralY(lut, lut_sampler, sample_y, scale, offset);
    float3 neutral_nits = sample_bt2020 * (neutral_y / sample_y);
    float3 native_nits = CODWW2SampleLUTNits(lut, lut_sampler, sample_bt2020, scale, offset);
    graded_nits = lerp(neutral_nits, native_nits, grade_strength) * (tone_y / neutral_y);
  }

  float3 relative = renodx::color::bt709::from::BT2020(graded_nits) / 300.f;
  renodx::color::grade::Config grade = renodx::color::grade::config::Create();
  grade.exposure = RENODX_TONE_MAP_EXPOSURE;
  grade.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  grade.shadows = RENODX_TONE_MAP_SHADOWS;
  grade.contrast = RENODX_TONE_MAP_CONTRAST;
  grade.flare = 0.10f * pow(max(RENODX_TONE_MAP_FLARE, 0.f), 10.f);
  grade.saturation = RENODX_TONE_MAP_SATURATION;
  grade.hue_correction_strength = 0.f;
  relative = renodx::color::grade::config::ApplyUserColorGrading(relative, grade);

  float knee = CODWW2ShoulderKnee();
  if (RENODX_TONE_MAP_TYPE != CODWW2_TONE_MAP_TYPE_PSYCHOV30 && RENODX_TONE_MAP_PER_CHANNEL == 0.f) {
    float y = max(renodx::color::y::from::BT709(relative), 0.f);
    if (y > knee) {
      float mapped_y = CODWW2MapShoulder((y - knee + 0.18f).xxx, knee).x;
      relative *= (knee + max(mapped_y - 0.18f, 0.f)) / y;
    }
  } else if (CODWW2Max3(relative) > knee) {
    float3 above_knee = max(relative - knee, 0.f);
    relative = min(relative, knee) + max(CODWW2MapShoulder(above_knee + 0.18f, knee) - 0.18f, 0.f);
  }

  // Chroma controls use absolute luminance (100-nit library normalization).
  grade = renodx::color::grade::config::Create();
  grade.hue_correction_strength = 0.f;
  grade.dechroma = RENODX_TONE_MAP_BLOWOUT;
  grade.blowout = 1.f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  float3 bt709_nits = relative * max(RENODX_DIFFUSE_WHITE_NITS, 1.f);
  bt709_nits = renodx::color::grade::config::ApplyUserColorGrading(bt709_nits / 100.f, grade) * 100.f;
  return CODWW2PQEncodeNits(CODWW2LimitPeak(renodx::color::bt2020::from::BT709(bt709_nits)));
}

#endif
