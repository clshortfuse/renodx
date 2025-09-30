#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 10:46:26 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  o0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;

  [branch]
  if (CUSTOM_HDR_VIDEOS == 1.f) {
    o0.rgb = renodx::draw::UpscaleVideoPass(o0.rgb);
  } else if (CUSTOM_HDR_VIDEOS == 2.f) {
    float3 linear_color = renodx::color::srgb::Decode(saturate(o0.rgb));
    float y = renodx::color::y::from::BT709(linear_color);
    float untonemapped_y = renodx::tonemap::inverse::Reinhard(y);
    float3 untonemapped = linear_color * renodx::math::DivideSafe(untonemapped_y, y, 0);
    renodx::tonemap::renodrt::Config hdr_video_config = renodx::tonemap::renodrt::config::Create();
    float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    hdr_video_config.nits_peak = peak * 100.f;
    hdr_video_config.mid_gray_value = 0.18f;
    hdr_video_config.mid_gray_nits = 18.f;
    hdr_video_config.exposure = 1.0f;
    hdr_video_config.contrast = 1.0f;
    hdr_video_config.saturation = 1.1f;
    hdr_video_config.highlights = 1.0f;
    hdr_video_config.shadows = 1.0f;

    hdr_video_config.blowout = -0.01f;
    hdr_video_config.dechroma = 0;
    hdr_video_config.flare = 0;

    hdr_video_config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
    hdr_video_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::CUSTOM;
    hdr_video_config.hue_correction_source = linear_color;
    hdr_video_config.per_channel = false;
    hdr_video_config.working_color_space = 2u;
    hdr_video_config.clamp_peak = 2u;
    hdr_video_config.clamp_color_space = -1.f;
    float3 hdr_video = renodx::tonemap::renodrt::BT709(untonemapped, hdr_video_config);
    o0.rgb = renodx::color::srgb::EncodeSafe(hdr_video);
  }
  return;
}
