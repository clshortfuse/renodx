#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:10 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  float3 result = renodx::color::correct::Hue(corrected_color, incorrect_color);
  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}

float3 ApplyHermiteSplineByMaxChannel(float3 input, float diffuse_nits, float peak_nits) {
  const float peak_ratio = peak_nits / diffuse_nits;
  float white_clip = max(RENODX_TONE_MAP_WHITE_CLIP, peak_ratio * 1.5f);  // safeguard to prevent artifacts

  float max_channel = renodx::math::Max(input.r, input.g, input.b);

  float max_pq = renodx::color::pq::Encode(max_channel, diffuse_nits);
  float target_white_pq = renodx::color::pq::Encode(peak_nits, 1.f);
  float max_white_pq = renodx::color::pq::Encode(white_clip, diffuse_nits);
  float target_black_pq = renodx::color::pq::Encode(0.0001f, 1.f);
  float min_black_pq = renodx::color::pq::Encode(0.f, 1.f);

  float scaled_pq = renodx::tonemap::HermiteSplineRolloff(max_pq, target_white_pq, max_white_pq, target_black_pq, min_black_pq);

  float mapped_max = renodx::color::pq::Decode(scaled_pq, diffuse_nits);
  mapped_max = min(mapped_max, peak_ratio);

  float scale = renodx::math::DivideSafe(mapped_max, max_channel, 1.f);
  float3 output = input * scale;

  // max_channel = max(renodx::math::Max(output), peak_ratio);
  // output *= peak_ratio / max_channel;

  return output;
}

float3 ApplyHermiteSplineByLuminance(float3 input, float diffuse_nits, float peak_nits) {
  const float peak_ratio = peak_nits / diffuse_nits;
  float white_clip = max(RENODX_TONE_MAP_WHITE_CLIP, peak_ratio * 1.5f);

  float y_in = renodx::color::y::from::BT709(input);
  float input_pq = renodx::color::pq::Encode(y_in, diffuse_nits);
  float target_white_pq = renodx::color::pq::Encode(peak_nits, 1.f);
  float max_white_pq = renodx::color::pq::Encode(white_clip, diffuse_nits);
  float target_black_pq = renodx::color::pq::Encode(0.0001f, 1.f);
  float min_black_pq = renodx::color::pq::Encode(0.f, 1.f);

  float scaled = renodx::tonemap::HermiteSplineRolloff(input_pq, target_white_pq, max_white_pq, target_black_pq, min_black_pq);

  float y_out = (renodx::color::pq::Decode(scaled, diffuse_nits));
  y_out = min(y_out, peak_ratio);

  float3 new_color = renodx::color::correct::Luminance(input, y_in, y_out);

  return new_color;
}

renodx::color::grade::Config CreateColorGradeConfig() {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_SHIFT;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  return cg_config;
}

float3 ApplyGammaCorrectionToneMapAndScale(float3 untonemapped) {
  untonemapped = ApplyGammaCorrection(untonemapped);

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    renodx::color::grade::Config cg_config = CreateColorGradeConfig();
    float y = renodx::color::y::from::BT709(untonemapped);
    float3 untonemapped_graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, cg_config);

    float3 hue_correction_source = untonemapped;
    if (RENODX_TONE_MAP_HUE_SHIFT > 0.f || RENODX_TONE_MAP_BLOWOUT > 0.f) {
      hue_correction_source = renodx::tonemap::ReinhardPiecewise(untonemapped, 4.f, 1.f);
    }

    untonemapped_graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(untonemapped_graded, hue_correction_source, y, cg_config);

    if (RENODX_TONE_MAP_TYPE == 2.f) {
      tonemapped = renodx::color::bt709::from::BT2020(
          ApplyHermiteSplineByMaxChannel(max(0, renodx::color::bt2020::from::BT709(untonemapped_graded)),
                                         RENODX_DIFFUSE_WHITE_NITS,
                                         RENODX_PEAK_WHITE_NITS));
    } else {
      tonemapped = untonemapped_graded;
    }
  } else {
    tonemapped = untonemapped;
  }

  tonemapped *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    tonemapped = renodx::color::correct::GammaSafe(tonemapped, true);
  }

  return tonemapped;
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0;

  r0.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  o0.xyzw = r0.xyzw;

  o0.rgb = ApplyGammaCorrectionToneMapAndScale(o0.rgb);

  o0.w = saturate(o0.w);
  return;
}
