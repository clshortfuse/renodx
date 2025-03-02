#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat Mar  1 01:01:19 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = cb0[2].x * r0.w;
  o0.xyz = r0.xyz;

  o0 = max(0, o0);

  renodx::draw::Config draw_config = renodx::draw::BuildConfig();
  draw_config.peak_white_nits = CUSTOM_HDR_VIDEOS_PEAK_NITS;
  //draw_config.peak_white_nits = max(min(RENODX_PEAK_WHITE_NITS / 2.f, 550.f), 300.f); // ensure inv tonemap stays between 300-550 nits

  if (CUSTOM_HDR_VIDEOS != 0) {
    o0.rgb = renodx::draw::UpscaleVideoPass(o0.rgb, draw_config);
    o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

    o0 = max(0, o0); // bt709 clamp, bandaid fix for blocky artefacts
  }

  return;
}