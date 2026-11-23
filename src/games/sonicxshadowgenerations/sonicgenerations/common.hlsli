#ifndef SONICXSHADOWGENERATIONS_COMMON_HLSLI_
#define SONICXSHADOWGENERATIONS_COMMON_HLSLI_

#include "../shared.h"

// RenoDX: FXAA HDR compression. Identity at or below 1; maps (1, inf) into (1, 2).
float3 FxaaCompress(float3 c) {
  float m = max(c.r, max(c.g, c.b));
  return m > 1.f ? c * ((2.f - 1.f / m) / m) : c;
}

float3 FxaaExpand(float3 c) {
  float m = max(c.r, max(c.g, c.b));
  return m > 1.f ? c * ((1.f / (2.f - min(m, 1.999f))) / m) : c;
}

// RenoDX: full-resolution motion blur. mb.xy = velocity (UV), mb.z = depth, mb.w = vanilla blur amount.
// Returns the blurred source color with the blur amount in w, for the composite's lerp.
float4 SGFullResMotionBlur(Texture2D<float4> src, SamplerState src_s, Texture2D<float4> mb, SamplerState mb_s, float2 uv, float2 pos) {
  float4 m = mb.SampleLevel(mb_s, uv, 0);
  float2 vel = m.xy * shader_injection.sg_motion_blur_strength;
  // Per-pixel jitter (interleaved gradient noise) turns banding into fine noise.
  float n = frac(52.9829189f * frac(dot(pos, float2(0.06711056f, 0.00583715f))));
  float sample_count = clamp(round(shader_injection.sg_motion_blur_samples), 8.f, 32.f);
  float3 sum = src.SampleLevel(src_s, uv, 0).rgb;
  float weight = 1.f;
  [loop]
  for (int i = 0; i < int(sample_count); i++) {
    float2 tap_uv = uv + vel * ((float(i) + n) / sample_count);
    // Keep taps not behind the center (depth gate), so foreground does not smear into the background.
    float keep = step(m.z - 0.01f, mb.SampleLevel(mb_s, tap_uv, 0).z);
    sum += keep * src.SampleLevel(src_s, tap_uv, 0).rgb;
    weight += keep;
  }
  return float4(sum / weight, m.w);
}

// RenoDX: smooth (C1) luminance shoulder above a knee that keeps hue/chroma.
// Strength 100 is fitted so encoded 1.0/1.5/2/3 land near 161/252/336/485 nits; strength 0 is no shoulder.
float3 SGHighlightShoulder(float3 color) {
  float s = saturate(shader_injection.sg_highlight_rolloff);
  float k = lerp(0.75f, 0.5f, s);
  float p = lerp(1.f, 0.45f, s);
  float y = renodx::color::y::from::BT709(color);
  if (y <= k) return color;
  float l = log(y / k);
  float ys = k * exp(l * (p + (1.f - p) / (1.f + l / 0.5f)));
  return color * (ys / y);
}

// RenoDX: auto exposure. Returns the exposure multiplier that replaces key / (adapted + 0.001).
// Mode 0 (Off): fixed exposure at the reference luminance. Mode 1 (Vanilla): the game's division.
// Mode 2 (Custom): the reference exposure scaled by the vanilla/reference ratio, with per-direction exponent and limits.
static const float SG_AE_REFERENCE_LUMINANCE = 0.18f;

float SGAutoExposure(float key, float adapted) {
  float vanilla = key / (adapted + 0.001f);
  float reference = key / (SG_AE_REFERENCE_LUMINANCE + 0.001f);
  if (shader_injection.sg_auto_exposure == 1.f) return vanilla;
  if (shader_injection.sg_auto_exposure != 2.f) return reference;
  float ratio = vanilla / reference;
  float s = ratio > 1.f ? shader_injection.sg_ae_brighten : shader_injection.sg_ae_darken;
  return reference * clamp(pow(ratio, s), exp2(-shader_injection.sg_ae_limit_darken), exp2(shader_injection.sg_ae_limit_brighten));
}

renodx::draw::Config SonicToneMapConfig() {
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::NEUTWO;
  config.tone_map_highlight_saturation = 1.f - saturate(shader_injection.tone_map_highlight_chroma_rolloff);
  return config;
}

#endif  // SONICXSHADOWGENERATIONS_COMMON_HLSLI_
