// Original shader: final blit — samples composited scene and outputs to swapchain
// When 0x6DE32B48 is replaced, t0 contains HDR data ÷3 packed in R10G10B10A2
// We recover ×3, then apply ToneMapPass with real pre-tonemap HDR values

#include "./shared.h"

Texture2D<float4> g_Texture : register(t0);
SamplerState g_Sampler_LinearClamp : register(s1);

void main(
    float4 pos : SV_Position,
    float2 uv : TEXCOORD0,
    out float4 output : SV_Target0) {
  float3 color = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv, 0).rgb;

  if (RENODX_TONE_MAP_TYPE == 0) {
    // Vanilla: 0x6DE32B48 applied ACES, data is tonemapped SDR
    output = float4(color, 1.0f);
    return;
  }

  // HDR path: scene is gamma-encoded HDR/3, UI composited at SDR [0,1] on top
  // Gamma decode then ×3 to recover HDR
  float3 hdr = pow(max(0, color), 2.2f) * 3.0f;

  // Apply color grading
  float temp = shader_injection.custom_color_temp;
  if (temp != 0.f) {
    hdr.r *= 1.f + temp * 0.5f;
    hdr.b *= 1.f - temp * 0.5f;
  }

  float lift = shader_injection.custom_shadow_lift;
  if (lift != 0.f) {
    hdr += lift;
    hdr = max(0, hdr);
  }

  float scene_strength = shader_injection.color_grade_strength;
  if (scene_strength < 1.f) {
    float luma = dot(hdr, float3(0.2126f, 0.7152f, 0.0722f));
    hdr = lerp(float3(luma, luma, luma), hdr, scene_strength);
  }

  // Apply ToneMapPass with REAL pre-tonemap HDR data
  float3 tonemapped = renodx::draw::ToneMapPass(hdr);

  // Compensate for ÷3 input cap limiting ToneMapPass output
  if (RENODX_TONE_MAP_TYPE == 2) {
    tonemapped *= 1.71f;  // ACES
  } else if (RENODX_TONE_MAP_TYPE == 3) {
    tonemapped *= 2.23f;  // RenoDRT
  }

  // Convert to scRGB
  float3 scrgb = tonemapped * (RENODX_DIFFUSE_WHITE_NITS / 80.f);

  // Clamp to peak
  float peak_scrgb = RENODX_PEAK_WHITE_NITS / 80.f;
  scrgb = min(scrgb, peak_scrgb);

  output = float4(scrgb, 1.0f);
}
