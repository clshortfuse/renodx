#include "./shared.h"

SamplerState ColorBufferState_s : register(s0);
Texture2D<float4> ColorBuffer : register(t0);

// 3Dmigoto declarations
#define cmp -

float3 RenoDRTSmoothClamp(float3 untonemapped) {
  renodx::tonemap::renodrt::Config renodrt_config = renodx::tonemap::renodrt::config::Create();
  renodrt_config.nits_peak = 100.f;
  renodrt_config.mid_gray_value = 0.18f;
  renodrt_config.mid_gray_nits = 18.f;
  renodrt_config.exposure = 1.f;
  renodrt_config.highlights = 1.f;
  renodrt_config.shadows = 1.f;
  renodrt_config.contrast = 1.05f;
  renodrt_config.saturation = 1.05f;
  renodrt_config.dechroma = 0.f;
  renodrt_config.flare = 0.f;
  renodrt_config.hue_correction_strength = 0.f;
  // renodrt_config.hue_correction_source = renodx::tonemap::uncharted2::BT709(untonemapped);
  renodrt_config.hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;
  renodrt_config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrt_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::INPUT;
  renodrt_config.working_color_space = 2u;
  renodrt_config.per_channel = false;

  float3 renoDRTColor = renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
  // renoDRTColor = lerp(untonemapped, renoDRTColor, saturate(renodx::color::y::from::BT709(untonemapped) / renodrt_config.mid_gray_value));

  return renoDRTColor;
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(1, -1) + float2(0, 1);
  o0.xyzw = ColorBuffer.Sample(ColorBufferState_s, r0.xy).xyzw;

  o0.rgb = max(0, o0.rgb);
  if (injectedData.toneMapGammaCorrection == 2.f) {
    o0.rgb = renodx::color::gamma::DecodeSafe(o0.rgb, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    o0.rgb = renodx::color::gamma::DecodeSafe(o0.rgb, 2.2f);
  } else {
    o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  }

  if (injectedData.toneMapType == 3.f) {
    renodx::tonemap::renodrt::Config config = renodx::tonemap::renodrt::config::Create();
    config.nits_peak = injectedData.toneMapPeakNits / injectedData.toneMapGameNits * 100.f;
    config.contrast = 1.05f;
    config.saturation = 1.05f;
    config.mid_gray_nits = 18.f;
    config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::CUSTOM;
    config.hue_correction_strength = injectedData.toneMapHueCorrection;
    if (injectedData.toneMapHueCorrectionMethod == 3.f) {
      config.hue_correction_source = RenoDRTSmoothClamp(o0.rgb);
    } else if (injectedData.toneMapHueCorrectionMethod == 2.f) {
      config.hue_correction_source = renodx::tonemap::uncharted2::BT709(o0.rgb);
    } else if (injectedData.toneMapHueCorrectionMethod == 1.f) {
      config.hue_correction_source = saturate(o0.rgb);
    } else {
      config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::INPUT;
    }

    o0.rgb = renodx::tonemap::renodrt::BT709(o0.rgb, config);
  } else {
    if (injectedData.toneMapType == 0.f) {
      o0.rgb = saturate(o0.rgb);
    }
    if (injectedData.toneMapHueCorrectionMethod == 3.f) {
      o0.rgb = renodx::color::correct::HueICtCp(o0.rgb, RenoDRTSmoothClamp(o0.rgb), injectedData.toneMapHueCorrection);
    } else if (injectedData.toneMapHueCorrectionMethod == 2.f) {
      o0.rgb = renodx::color::correct::HueICtCp(o0.rgb, renodx::tonemap::uncharted2::BT709(o0.rgb), injectedData.toneMapHueCorrection);
    } else if (injectedData.toneMapHueCorrectionMethod == 1.f) {
      o0.rgb = renodx::color::correct::HueICtCp(o0.rgb, saturate(o0.rgb), injectedData.toneMapHueCorrection);
    }
  }

  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
