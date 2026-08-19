#include "./shared.h"

// etc functions

// Mass Effect Displaymapper
// Linear color in -> Linear color out
// Params in PQ -- Use the helper function to call the displaymapper (MassEffectDisplayMap())
// NormalizedLinearValue = linear color
// SoftShoulderStart2084 = shoulder start in nits (PQ values) -- everything under this is ignored
// MaxBrightnessOfDisplay2084 = peak nits
// MaxBrightnessOfScene2084 = Y of Linear Color (Encoded in PQ) -- Basically whiteclip

float3 MapHDRSceneToDisplayCapabilities(float3 NormalizedLinearValue, float SoftShoulderStart2084, float MaxBrightnessOfDisplay2084, float MaxBrightnessOfScene2084) {
  float3 bt2020_color = renodx::color::bt2020::from::BT709(NormalizedLinearValue);
  float3 ST2084 = renodx::color::pq::EncodeSafe(bt2020_color);

  // Use a simple Bezier curve to create a soft shoulder
  const float P0 = SoftShoulderStart2084;           // First point is: soft shoulder start nits
  const float P1 = MaxBrightnessOfDisplay2084;      // Middle point is: TV max nits
  const float P2 = MaxBrightnessOfDisplay2084;      // Last point is also TV max nits, since values higher than TV max nits are essentially clipped to TV max brightness
  const float SceneMax = MaxBrightnessOfScene2084;  // To determine range, use max brightness of HDR scene

  float3 T = saturate((ST2084 - P0) / (SceneMax - P0));  // Amount to lerp wrt current value
  float3 B0 = (P0 * (1 - T)) + (P1 * T);                 // Lerp between p0 and p1
  float3 B1 = (P1 * (1 - T)) + (P2 * T);                 // Lerp between p1 and p2
  float3 MappedValue = (B0 * (1 - T)) + (B1 * T);        // Final lerp for Bezier

  MappedValue = min(MappedValue, ST2084);  // If HDR scene max luminance is too close to shoulders, then it could end up producing a higher value than the ST.2084 curve,
  // which will saturate colors, i.e. the opposite of what HDR display mapping should do, therefore always take minimum of the two

  // Return a linear color
  return renodx::color::bt709::from::BT2020(renodx::color::pq::DecodeSafe((ST2084 > SoftShoulderStart2084) ? MappedValue : ST2084));
}

float3 MassEffectDisplayMap(float3 linear_color, float shoulder_start, float peak_nits, float scene_peak) {
  // Helper function for Mass Effect's display mapper to encode params to PQ

  float3 params2pq = renodx::color::pq::EncodeSafe(float3(shoulder_start, peak_nits, scene_peak));

  shoulder_start = params2pq.x;
  peak_nits = params2pq.y;
  scene_peak = params2pq.z;

  return MapHDRSceneToDisplayCapabilities(linear_color, shoulder_start, peak_nits, scene_peak);
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.375f, float output_max = 1.f, float white_clip = 100.f) {
  float peak = renodx::math::Max(untonemapped.r, untonemapped.g, untonemapped.b);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

// Re-using function for Max-CH SDR TM because I'm too lazy to replace the param in all the other functions
float3 NeutralSDRYLerp(float3 color) {
  [branch]
  if (DEBUG_MAX_CH == 0.f) {  // Y TM
    float color_y = renodx::color::y::from::BT709(color);
    return color = lerp(color, renodx::tonemap::renodrt::NeutralSDR(color), saturate(color_y));
  } else {  // Max CH TM
    return saturate(color * ComputeReinhardSmoothClampScale(color, 0.5f));
  }
}

float3 ExponentialRollOffByLum(float3 color, float output_luminance_max, float highlights_shoulder_start = 0.f) {
  const float source_luminance = renodx::color::y::from::BT709(color);

  [branch]
  if (source_luminance > 0.0f) {
    const float compressed_luminance = renodx::tonemap::ExponentialRollOff(source_luminance, highlights_shoulder_start, output_luminance_max);
    color *= compressed_luminance / source_luminance;
  }

  return color;
}

float3 ApplyExponentialRollOff(float3 color, float per_ch = RENODX_TONE_MAP_PER_CHANNEL) {
  float peak_white = RENODX_PEAK_NITS;
  float paper_white = RENODX_GAME_NITS;
  float peak_ratio = peak_white / paper_white;

  // Adjust peak based on gamma correction
  [branch]
  if (RENODX_GAMMA_CORRECTION != 0) {
    peak_ratio = renodx::color::correct::Gamma(
        peak_ratio,
        RENODX_GAMMA_CORRECTION > 0.f,
        abs(RENODX_GAMMA_CORRECTION) == 1.f ? 2.2f : 2.4f);
  }

  // 1.f shoulder so game nits doesnt get compressed
  float highlight_shoulder_start = 1.f;

  [branch]
  if (per_ch == 0.f) {
    return ExponentialRollOffByLum(color, peak_ratio, highlight_shoulder_start);
  } else {
    return renodx::tonemap::ExponentialRollOff(color, peak_ratio, highlight_shoulder_start);
  }
}

// Lutbuilder code

float4 LutBuilderToneMap(float3 untonemapped_ap1, float3 graded_bt709) {
  float3 color;
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);

  [branch]
  if (GRADING_EXIST == 1.f) {
    color = renodx::draw::ComputeUntonemappedGraded(untonemapped_bt709, graded_bt709, NeutralSDRYLerp(untonemapped_bt709));  // untonemapped graded in lutbuilder
  } else {
    // Only for one area in the non-venge compaign
    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    draw_config.tone_map_type = 3.f;

    color = renodx::draw::ToneMapPass(untonemapped_bt709, graded_bt709, NeutralSDRYLerp(untonemapped_bt709), draw_config);
  }

  color = renodx::draw::RenderIntermediatePass(color);
  color *= 1.f / 1.05f;

  return float4(color, 1.f);
}

// Display map Untonemapped AP1 in the lutbuilder to restore SDR Hues
float3 DisplaymapUntonemappedAP1(float3 untonemapped_ap1) {
  float3 color;
  if (RENODX_TONE_MAP_TYPE != 0) {
    color = renodx::color::bt709::from::AP1(untonemapped_ap1);
    float color_y = renodx::color::y::from::BT709(color);
    color = renodx::tonemap::dice::BT709(color, 1.f, 0.5f);
    color = renodx::color::ap1::from::BT709(color);
  } else {
    color = color;
  }
  return color;
}

// Output Shader Functions

float3 ApplyCustomBloom(float3 render, float3 bloom_texture, float scaling = 0.5f) {
  if (FX_BLOOM != 0.f) {
    float mid_gray_bloomed = (0.18 + renodx::color::y::from::BT709(bloom_texture)) / 0.18;

    float scene_luminance = renodx::color::y::from::BT709(render) * mid_gray_bloomed;
    float bloom_blend = saturate(smoothstep(0.f, 0.18f, scene_luminance));
    float3 bloom_scaled = lerp(0.f, bloom_texture, bloom_blend);
    return bloom_texture = lerp(bloom_texture, bloom_scaled, 1.f * scaling);
  } else {
    return bloom_texture;
  }
}

// Grading code, WIP

float3 GenerateSDRColor(float3 linear_color) {
  // Generate SDR Color for grading to process
  // float3 neutral_sdr = renodx::tonemap::renodrt::NeutralSDR(abs(linear_color));
  float3 neutral_sdr = NeutralSDRYLerp(abs(linear_color));

  float3 srgb_color = renodx::color::srgb::EncodeSafe(neutral_sdr);

  return srgb_color;
}

float3 ProcessGradingOutput(float3 linear_color, float3 srgb_graded_color, float2 uv) {
  float3 output_color;
  float3 linear_graded_color = renodx::color::srgb::DecodeSafe(srgb_graded_color);
  [branch]
  if (RENODX_TONE_MAP_TYPE == 0) {
    // do nothing if TM Type Vanilla
    output_color = saturate(srgb_graded_color);
  }

  [branch]
  if (RENODX_TONE_MAP_TYPE != 0) {
    output_color = renodx::draw::ToneMapPass(linear_color, linear_graded_color, NeutralSDRYLerp(linear_color));

    [branch]
    if (FX_CUSTOM_GRAIN_TYPE != 0.f) {
      if (FX_CUSTOM_GRAIN_TYPE == 1.f) {
        float3 grained = renodx::effects::ApplyFilmGrain(
            output_color,
            uv,
            CUSTOM_RANDOM,
            FX_CUSTOM_GRAIN_STRENGTH * 0.03f,
            1.f);

        output_color = grained;
      }
    }

    output_color = renodx::draw::RenderIntermediatePass(output_color);
  }

  return output_color;
}
