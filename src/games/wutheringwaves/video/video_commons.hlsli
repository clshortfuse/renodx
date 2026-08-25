#ifndef WUTHERINGWAVES_VIDEO_COMMONS_HLSLI
#define WUTHERINGWAVES_VIDEO_COMMONS_HLSLI

// Video Processing Package: AutoHDR, HAnS, dither, grain

#include "../shared.h"

// ---- HAnS tuning ----

// Analysis chain
static const float HANS_SIZE = 24.0f;        // Highlight radius in source pixels
static const float HANS_THRESHOLD = 0.30f;   // Minimum local contrast for a highlight

// HDR boost blend in AutoHDRVideo
static const float HANS_RESPONSE_GAMMA = 0.5f;  // Shapes the map response
static const float HANS_FLOOR = 0.20f;          // Minimum boost availability outside highlights
static const float HANS_STRENGTH = 1.0f;        // Overall HAnS blend strength.

cbuffer HAnSConstants : register(b0) {
  float2 hans_input_size;
  float2 hans_output_size;
};

static const uint HANS_MAX_RADIUS = 12;

uint HAnSRadius() {
  return min(HANS_MAX_RADIUS, max(1u, (uint)round(HANS_SIZE * 0.5f)));
}

uint2 HAnSClamp(uint2 p) {
  return min(p, uint2(hans_input_size) - 1u);
}

float3 HAnSAnalysisColor(float3 linear_rgb) {
  return saturate(pow(max(linear_rgb, 0.0f), 1.0f / 2.2f));
}

float HAnSLuma(float3 color) {
  return dot(color, float3(0.2126f, 0.7152f, 0.0722f));
}

// Post-pass video HDR upscale with HAnS-aware availability, dither, and grain.
static inline float3 AutoHDRVideo(float3 sdr_video, float2 position, float hans_local_map) {
  if (RENODX_TONE_MAP_HDR_VIDEO == 0.f
      || (RENODX_TONE_MAP_TYPE == 0.f && RENODX_HANS_MODE <= 0.f)) {
    return sdr_video;
  }
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.peak_white_nits = RENODX_VIDEO_NITS;

  float3 hdr_video = renodx::draw::UpscaleVideoPass(saturate(sdr_video), config);
  if (RENODX_HANS_MODE > 0.f) {
    const float shaped_map = pow(
        saturate(hans_local_map),
        max(HANS_RESPONSE_GAMMA, 0.1f));
    const float selected_availability = lerp(
        saturate(HANS_FLOOR),
        1.f,
        shaped_map);
    const float availability = lerp(
        1.f,
        selected_availability,
        saturate(HANS_STRENGTH));
    hdr_video = lerp(sdr_video, hdr_video, availability);
  }
  {
    // dithering
    const float dither_bits = 10.0f;
    const float max_value = exp2(dither_bits) - 1.0f; 
    const float dither_lsbs_10bit = 6.0f; 
    const float2 p = position + CUSTOM_RANDOM;
    const float r1 = renodx::random::Generate(p + 0.07f);
    const float r2 = renodx::random::Generate(p + 13.07f);
    const float tpdf = (r1 - r2); 
    const float y = renodx::color::y::from::BT709(max(0, hdr_video));
    const float highlight_fade = smoothstep(0.35f, 1.0f, y); 
    const float strength = lerp(1.0f, 0.45f, highlight_fade);
    const float noise = tpdf * ((dither_lsbs_10bit * strength) / max_value);

    // clamp negatives
    hdr_video = max(0, hdr_video + noise);
  }

  hdr_video = renodx::color::srgb::DecodeSafe(hdr_video);

  {
    // minor amounts of grain
    const float grain_strength = 0.5f;
    hdr_video = renodx::effects::ApplyFilmGrain(hdr_video, position, CUSTOM_RANDOM, grain_strength, 1.f);
  }

  return renodx::draw::RenderIntermediatePass(hdr_video);
}

#endif
