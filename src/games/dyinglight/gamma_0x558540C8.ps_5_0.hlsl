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

float3 ApplyGammaCorrectionToneMapAndScale(float3 untonemapped) {
  untonemapped = ApplyGammaCorrection(untonemapped);

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    UserGradingConfig cg_config = CreateColorGradeConfig();
    float y = renodx::color::y::from::BT709(untonemapped);
    float3 untonemapped_graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, cg_config);

    float3 hue_correction_source = untonemapped;
    if (RENODX_TONE_MAP_HUE_SHIFT > 0.f || RENODX_TONE_MAP_BLOWOUT > 0.f) {
      hue_correction_source = renodx::tonemap::ReinhardPiecewise(untonemapped, 4.f, 1.f);
    }

    untonemapped_graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(untonemapped_graded, hue_correction_source, y, cg_config);

    if (RENODX_TONE_MAP_TYPE == 2.f) {
      float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      tonemapped = renodx::color::bt709::from::BT2020(
          renodx::tonemap::neutwo::MaxChannel(max(0, renodx::color::bt2020::from::BT709(untonemapped_graded)),
                                              peak_ratio, RENODX_TONE_MAP_WHITE_CLIP));
      tonemapped = min(tonemapped, peak_ratio);

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
