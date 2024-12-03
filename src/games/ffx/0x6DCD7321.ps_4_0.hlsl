#include "./shared.h"

SamplerState ColorBufferState_s : register(s0);
Texture2D<float4> ColorBuffer : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(1, -1) + float2(0, 1);
  o0.xyzw = ColorBuffer.Sample(ColorBufferState_s, r0.xy).xyzw;

  float3 sdr_color = saturate(o0.rgb);
  if (injectedData.toneMapType == 0.f) {
    o0.rgb = sdr_color;
  } else {
    o0.rgb = renodx::color::correct::HueICtCp(o0.rgb, sdr_color, injectedData.toneMapHueCorrection);
  }

  if (injectedData.toneMapGammaCorrection == 2.f) {
    o0.rgb = renodx::color::gamma::DecodeSafe(o0.rgb, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    o0.rgb = renodx::color::gamma::DecodeSafe(o0.rgb, 2.2f);
  } else {
    o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  }

  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
