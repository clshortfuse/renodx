#include "./shared.h"

SamplerState SampBase_s : register(s0);
Texture2D<float4> TexBase : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0: SV_POSITION0, float2 v1: TEXCOORD0, out float4 o0: SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = TexBase.Sample(SampBase_s, v1.xy).xyzw;
  o0.xyzw = r0.zyxw;

  o0.rgb = renodx::color::srgb::Decode(saturate(o0.rgb));
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float y = renodx::color::y::from::BT709(o0.rgb);
    float untonemapped_y = renodx::tonemap::inverse::Reinhard(y);
    float3 untonemapped = o0.rgb * renodx::math::DivideSafe(untonemapped_y, y, 0);
    renodx::tonemap::renodrt::Config hdr_video_config = renodx::tonemap::renodrt::config::Create();
    float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION == 1.f) {
      peak = renodx::color::correct::Gamma(peak, true, 2.2f);
    } else if (RENODX_GAMMA_CORRECTION == 2.f) {
      peak = renodx::color::correct::Gamma(peak, true, 2.4f);
    }

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
    hdr_video_config.hue_correction_source = o0.rgb;
    hdr_video_config.per_channel = false;
    hdr_video_config.working_color_space = 2u;
    hdr_video_config.clamp_peak = 2u;
    hdr_video_config.clamp_color_space = -1.f;
    o0.rgb = renodx::tonemap::renodrt::BT709(untonemapped, hdr_video_config);
  }
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  return;
}
