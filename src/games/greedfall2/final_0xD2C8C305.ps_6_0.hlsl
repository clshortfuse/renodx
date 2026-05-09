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

  // Apply custom grading before ToneMapPass
  // Color temperature
  float temp = shader_injection.custom_color_temp;
  if (temp != 0.f) {
    linear_color.r *= 1.f + temp * 0.5f;
    linear_color.b *= 1.f - temp * 0.5f;
  }

  // Black floor (positive = lift, negative = crush)
  float lift = shader_injection.custom_shadow_lift;
  if (lift != 0.f) {
    linear_color += lift;
    linear_color = max(0, linear_color);
  }

  // Scene grading strength — blend toward neutral gray
  float scene_strength = shader_injection.color_grade_strength;
  if (scene_strength < 1.f) {
    float luma = dot(linear_color, float3(0.2126f, 0.7152f, 0.0722f));
    linear_color = lerp(float3(luma, luma, luma), linear_color, scene_strength);
  }

  // Scale up to give ToneMapPass HDR headroom
  // peak/80 tells ToneMapPass the scene extends to peak brightness
  linear_color *= RENODX_PEAK_WHITE_NITS / 80.f;

  // ToneMapPass expands highlights based on peak/diffuse ratio
  float3 tonemapped = renodx::draw::ToneMapPass(linear_color);

  // Compensate for each tonemapper's natural compression
  if (RENODX_TONE_MAP_TYPE == 2) {
    tonemapped *= 1.30f;  // ACES
  } else if (RENODX_TONE_MAP_TYPE == 3) {
    tonemapped *= 1.90f;  // RenoDRT
  }

  // Convert ToneMapPass output to scRGB
  // ToneMapPass outputs where 1.0 = diffuse white reference
  // Multiply by diffuse_white_nits to get nits, divide by 80 for scRGB
  float3 scrgb = tonemapped * (RENODX_DIFFUSE_WHITE_NITS / 80.f);

  // Clamp to peak in scRGB
  float peak_scrgb = RENODX_PEAK_WHITE_NITS / 80.f;
  scrgb = min(scrgb, peak_scrgb);

  output = float4(scrgb, 1.0f);
}
