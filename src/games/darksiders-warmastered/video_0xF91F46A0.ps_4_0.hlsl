#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Jan 13 18:41:33 2026

SamplerState YPlane_sampler_s : register(s0);
SamplerState CrPlane_sampler_s : register(s1);
SamplerState CbPlane_sampler_s : register(s2);
Texture2D<float4> YPlane_texture : register(t0);
Texture2D<float4> CrPlane_texture : register(t1);
Texture2D<float4> CbPlane_texture : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float y = YPlane_texture.Sample(YPlane_sampler_s, v1.xy).x;
  float cb = CbPlane_texture.Sample(CbPlane_sampler_s, v1.xy).x;
  float cr = CrPlane_texture.Sample(CrPlane_sampler_s, v1.xy).x;

  if (RENODX_TONE_MAP_TYPE != 0) {
    o0.xyz = renodx::color::bt709::from::YCbCrLimited(float3(y, cb, cr));
    if (CUSTOM_VIDEO_ITM > 0) {
      renodx::draw::Config config = renodx::draw::BuildConfig();
      if (CUSTOM_VIDEO_ITM == 1) config.peak_white_nits = min(config.diffuse_white_nits * 2, config.peak_white_nits);
      o0.xyz = renodx::draw::UpscaleVideoPass(saturate(o0.xyz), config);
    }
  }
  else {
    o0.xyz = renodx::color::bt601::from::YCbCrLimited(float3(y, cb, cr));
  }
  o0.w = 1;
  return;
}