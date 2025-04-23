#include "./shared.h"

Texture2D<float4> tex0 : register(t0);

Texture2D<float4> tex1 : register(t1);

Texture2D<float4> tex2 : register(t2);

cbuffer _RootShaderParameters : register(b0) {
  float4 consta : packoffset(c005.x);
  float4 crc : packoffset(c006.x);
  float4 cbc : packoffset(c007.x);
  float4 adj : packoffset(c008.x);
  float4 yscale : packoffset(c009.x);
  float4 xy_xform0 : packoffset(c010.x);
  float4 xy_xform1 : packoffset(c011.x);
  float4 uv_xform0 : packoffset(c012.x);
  float4 uv_xform1 : packoffset(c013.x);
  float4 uv_xform2 : packoffset(c014.x);
};

SamplerState samp0 : register(s0);

SamplerState samp1 : register(s1);

SamplerState samp2 : register(s2);

float4 main(
  noperspective float4 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _15 = tex0.Sample(samp0, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _19 = tex1.Sample(samp1, float2(TEXCOORD.z, TEXCOORD.w));
  float4 _23 = tex2.Sample(samp2, float2(TEXCOORD.z, TEXCOORD.w));
  float _74 = ((((crc.x * _19.x) + (yscale.x * _15.x)) + (cbc.x * _23.x)) + adj.x) * consta.x;
  float _75 = ((((crc.y * _19.x) + (yscale.y * _15.x)) + (cbc.y * _23.x)) + adj.y) * consta.y;
  float _76 = ((((crc.z * _19.x) + (yscale.z * _15.x)) + (cbc.z * _23.x)) + adj.z) * consta.z;
  SV_Target.x = (((((_74 * 0.30530601739883423f) + 0.682171106338501f) * _74) + 0.012522878125309944f) * _74);
  SV_Target.y = (((((_75 * 0.30530601739883423f) + 0.682171106338501f) * _75) + 0.012522878125309944f) * _75);
  SV_Target.z = (((((_76 * 0.30530601739883423f) + 0.682171106338501f) * _76) + 0.012522878125309944f) * _76);
  SV_Target.w = (((((crc.w * _19.x) + (yscale.w * _15.x)) + (cbc.w * _23.x)) + adj.w) * consta.w);

  if (CUSTOM_HDR_VIDEOS == 1.f) {
    SV_Target.rgb = saturate(SV_Target.rgb);
    SV_Target.rgb = renodx::color::srgb::Encode(SV_Target.rgb);
    SV_Target.rgb = renodx::draw::UpscaleVideoPass(SV_Target.rgb);
    SV_Target.rgb = renodx::color::srgb::Decode(SV_Target.rgb);
  } else if (CUSTOM_HDR_VIDEOS == 2.f) {
    float3 linear_color = saturate(SV_Target.rgb);
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
    SV_Target.rgb = hdr_video;
  }
  return SV_Target;
}
