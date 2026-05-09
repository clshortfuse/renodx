// Original shader: final blit — samples composited scene and outputs to swapchain
// Original code: just samples t0 and outputs directly. No processing.
// Game tonemaps with Narkowicz ACES in compute pass 0x6DE32B48.

#include "./shared.h"

Texture2D<float4> g_Texture : register(t0);
SamplerState g_Sampler_LinearClamp : register(s1);

void main(
    float4 pos : SV_Position,
    float2 uv : TEXCOORD0,
    out float4 output : SV_Target0) {
  float3 color = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv, 0).rgb;

  if (RENODX_TONE_MAP_TYPE == 0) {
    // Vanilla: passthrough
    output = float4(color, 1.0f);
    return;
  }

  // Decode sRGB gamma to linear
  float3 linear_color = renodx::color::srgb::DecodeSafe(color);

  // Scale up to give ToneMapPass HDR headroom
  // peak/80 tells ToneMapPass the scene extends to peak brightness
  linear_color *= RENODX_PEAK_WHITE_NITS / 80.f;

  // ToneMapPass expands highlights based on peak/diffuse ratio
  float3 tonemapped = renodx::draw::ToneMapPass(linear_color);

  // Convert ToneMapPass output to scRGB
  // ToneMapPass outputs where 1.0 = diffuse white reference
  // Multiply by diffuse_white_nits to get nits, divide by 80 for scRGB
  float3 scrgb = tonemapped * (RENODX_DIFFUSE_WHITE_NITS / 80.f);

  // Clamp to peak in scRGB
  float peak_scrgb = RENODX_PEAK_WHITE_NITS / 80.f;
  scrgb = min(scrgb, peak_scrgb);

  output = float4(scrgb, 1.0f);
}
