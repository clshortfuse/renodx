#include "./common.hlsl"

SamplerState g_CopyBufferMapSampler_s : register(s6);
Texture2D<float4> g_CopyBufferMap : register(t6);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  o0.xyzw = g_CopyBufferMap.Sample(g_CopyBufferMapSampler_s, v1.xy).xyzw;
  if (injectedData.toneMapType == 0.f) {
    o0.rgb = saturate(o0.rgb);
  } else {
    o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
    float y_max = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
    if (injectedData.toneMapGammaCorrection != 0.f) {
      y_max = renodx::color::correct::Gamma(y_max, true, injectedData.toneMapGammaCorrection == 1.f ? 2.2f : 2.4f);
    }
    float y = renodx::color::y::from::BT709(abs(o0.rgb));
    if (y > y_max) {
      o0.rgb = renodx::tonemap::ExponentialRollOff(o0.rgb, 1.f, max(1.005f, y_max));
    }
    o0.rgb = renodx::color::srgb::EncodeSafe(o0.rgb);
  }
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}