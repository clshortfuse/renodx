// Original shader 0xD2C8C305: final blit to swapchain
// Original code (decompiled): just samples t0 and outputs directly, no processing.
//
//   void main(float4 pos : SV_Position, float2 uv : TEXCOORD0, out float4 output : SV_Target0) {
//     output = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv, 0);
//   }
//
// Game tonemaps with Narkowicz ACES in compute pass 0x6DE32B48.
// When 0x6DE32B48 is replaced, t0 contains PQ-encoded HDR carried through R10G10B10A2.
// We PQ-decode back to linear HDR, then apply ToneMapPass and output scRGB to the float16 swapchain.

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
    // Vanilla
    output = float4(color, 1.0f);
    return;
  }

  // Menu/loading passthrough
  if (shader_injection.custom_tonemap_has_drawn == 0.f) {
    output = float4(color, 1.0f);
    return;
  }

  // PQ decode
  float3 hdr = renodx::color::pq::DecodeSafe(color, 1.0f);

  // Color grading
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

  float3 tonemapped;

  if (RENODX_TONE_MAP_TYPE == 4) {
    // Psycho: apply grading in luminosity space, then call psycho
    float3 psycho_input = hdr;

    // Apply exposure, highlights, shadows, contrast in luminosity space
    psycho_input *= RENODX_TONE_MAP_EXPOSURE;

    float3 lms_in = renodx::color::lms::from::BT709(psycho_input);
    float yf_input = renodx::color::yf::from::LMS(lms_in);
    float yf_midgray = renodx::color::yf::from::BT709(0.18f);
    float yf_target = yf_input;

    if (RENODX_TONE_MAP_HIGHLIGHTS != 1.f) {
      yf_target = renodx::color::grade::Highlights(yf_target, RENODX_TONE_MAP_HIGHLIGHTS, yf_midgray);
    }
    if (RENODX_TONE_MAP_SHADOWS != 1.f) {
      yf_target = renodx::color::grade::Shadows(yf_target, RENODX_TONE_MAP_SHADOWS, yf_midgray);
    }
    if (RENODX_TONE_MAP_CONTRAST != 1.f) {
      yf_target = renodx::color::grade::ContrastSafe(yf_target, RENODX_TONE_MAP_CONTRAST, yf_midgray);
    }

    float yf_scale = renodx::math::DivideSafe(yf_target, yf_input, 1.f);
    psycho_input *= yf_scale;

    float peak_value = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

    tonemapped = renodx::tonemap::psycho::psychotm_test17(
        psycho_input,
        peak_value,
        1.0f,                          // exposure (already applied)
        1.0f,                          // highlights (already applied)
        1.0f,                          // shadows (already applied)
        1.0f,                          // contrast (already applied)
        RENODX_TONE_MAP_SATURATION,    // purity
        RENODX_TONE_MAP_BLOWOUT,       // bleaching
        100.f,                         // clip point
        RENODX_TONE_MAP_HUE_CORRECTION,// hue restore
        1.0f,                          // adaptation contrast
        0,                             // white curve mode
        shader_injection.custom_cone_response  // cone response exponent
    );
  } else {
    // Gamma encode before ToneMapPass
    hdr = renodx::color::correct::GammaSafe(hdr, true);

    // ACES / RenoDRT via ToneMapPass
    tonemapped = renodx::draw::ToneMapPass(hdr);
  }

  // scRGB output
  float3 scrgb = tonemapped * (RENODX_DIFFUSE_WHITE_NITS / 80.f);
  float peak_scrgb = RENODX_PEAK_WHITE_NITS / 80.f;
  scrgb = min(scrgb, peak_scrgb);

  output = float4(scrgb, 1.0f);
}
