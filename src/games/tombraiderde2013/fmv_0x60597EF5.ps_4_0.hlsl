#include "./shared.h"

SamplerState Sampler0_s : register(s0);
Texture2D<float4> InstanceTexture0 : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = InstanceTexture0.Sample(Sampler0_s, v2.xy).xyzw;
  o0.xyzw = v1.xyzw * r0.zyxw;
  if (CUSTOM_HDR_VIDEOS != 0) {
    o0.rgb = renodx::draw::UpscaleVideoPass(o0.rgb);
    o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  }
  return;
}
