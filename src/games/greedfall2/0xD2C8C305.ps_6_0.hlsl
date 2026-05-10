// Original shader 0xD2C8C305: final blit to swapchain
// Original code (decompiled): just samples t0 and outputs directly, no processing.
//
//   void main(float4 pos : SV_Position, float2 uv : TEXCOORD0, out float4 output : SV_Target0) {
//     output = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv, 0);
//   }
//
// Game tonemaps with Narkowicz ACES in compute pass 0x6DE32B48.
// When 0x6DE32B48 is replaced, t0 contains gamma-encoded HDR/3 in R10G10B10A2.
// We decode, recover ×3, then apply ToneMapPass with real pre-tonemap HDR values.

#include "./shared.h"
#include "./psycho_test17.hlsl"

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

  // HDR path: everything is PQ-encoded (scene + UI composited by 0xF27041D0)
  float3 hdr = renodx::color::pq::DecodeSafe(color, 1.0f);

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

  // Apply tonemapping
  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 4) {
    // Psycho tonemapper — apply grading before, pass only saturation/blowout to psycho
    float3 psycho_input = hdr * shader_injection.tone_map_exposure;

    // Apply highlights/shadows/contrast in luminosity space
    float yf = renodx::color::y::from::BT709(psycho_input);
    float yf_midgray = 0.18f;
    float yf_target = yf;
    if (shader_injection.tone_map_highlights != 1.f) {
      yf_target = renodx::color::grade::Highlights(yf_target, shader_injection.tone_map_highlights, yf_midgray);
    }
    if (shader_injection.tone_map_shadows != 1.f) {
      yf_target = renodx::color::grade::Shadows(yf_target, shader_injection.tone_map_shadows, yf_midgray);
    }
    if (shader_injection.tone_map_contrast != 1.f) {
      yf_target = renodx::color::grade::ContrastSafe(yf_target, shader_injection.tone_map_contrast, yf_midgray);
    }
    float yf_scale = (yf > 0.f) ? (yf_target / yf) : 1.f;
    psycho_input *= yf_scale;

    float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    tonemapped = renodx::tonemap::psycho::psychotm_test17(
        psycho_input,
        peak,
        1.f,                                      // exposure (already applied)
        1.f,                                      // highlights (already applied)
        1.f,                                      // shadows (already applied)
        1.f,                                      // contrast (already applied)
        shader_injection.tone_map_saturation,     // purity_scale
        shader_injection.tone_map_blowout,        // bleaching_intensity
        100.f,                                    // clip_point
        shader_injection.tone_map_hue_correction, // hue_restore
        1.f,                                      // adaptation_contrast
        0,                                        // white_curve_mode (neutwo)
        1.f,                                      // cone_response_exponent
        0.18f,                                    // current_adaptive_state
        0.18f,                                    // current_background_state
        1.f,                                      // gamut_compression
        1);                                       // gamut_compression_mode
  } else {
    // ACES / RenoDRT via ToneMapPass
    tonemapped = renodx::draw::ToneMapPass(hdr);

    // Compensate for ÷3 input cap limiting ToneMapPass output
    if (RENODX_TONE_MAP_TYPE == 2) {
      tonemapped *= 1.71f;  // ACES
    } else if (RENODX_TONE_MAP_TYPE == 3) {
      tonemapped *= 2.23f;  // RenoDRT
    }
  }

  // Convert to scRGB
  float3 scrgb = tonemapped * (RENODX_DIFFUSE_WHITE_NITS / 80.f);

  // Clamp to peak
  float peak_scrgb = RENODX_PEAK_WHITE_NITS / 80.f;
  scrgb = min(scrgb, peak_scrgb);

  output = float4(scrgb, 1.0f);
}
