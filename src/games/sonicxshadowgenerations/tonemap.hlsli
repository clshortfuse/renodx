#ifndef SONICXSHADOWGENERATIONS_TONEMAP_HLSLI_
#define SONICXSHADOWGENERATIONS_TONEMAP_HLSLI_

#include "./shared.h"

cbuffer cbDynamicFactor : register(b10) { float4 u_tonemap_param[3] : packoffset(c0); }
cbuffer cbWorld : register(b0) { float4 u_color_grading_factor : packoffset(c396); }

// Game's original tonemap math (decompiled), linear SDR output before sRGB encode.
float3 VanillaToneMap(float3 color) {
  float span = u_tonemap_param[1].x - u_tonemap_param[1].z;
  float knee_offset = u_tonemap_param[1].w * span;
  float knee = u_tonemap_param[1].z + knee_offset / u_tonemap_param[1].y;
  float tail_scale = u_tonemap_param[1].x - (u_tonemap_param[1].z + knee_offset);
  float tail_rate = -u_tonemap_param[1].y / tail_scale;

  float3 t = saturate(color / u_tonemap_param[1].z);
  float3 smooth_step = (3.f - 2.f * t) * t * t;
  float3 above_knee = step(knee, color);

  float3 toe = u_tonemap_param[1].z * pow(max(0.f, color / u_tonemap_param[1].z), u_tonemap_param[2].x);
  float3 linear_part = u_tonemap_param[1].z + u_tonemap_param[1].y * (color - u_tonemap_param[1].z);
  float3 curve = toe * (1.f - smooth_step) + linear_part * (smooth_step - above_knee);
  float3 shoulder = (u_tonemap_param[1].x - tail_scale * exp(tail_rate * (color - knee))) * above_knee;
  return saturate(curve + shoulder);
}

// Packed LUT lookup: 16 blue slices laid out along u. e is the saturated sRGB-encoded color.
float3 SampleGradingLut(Texture2D<float4> lut, SamplerState lut_sampler, float3 e) {
  float slice = floor(e.b * 14.9999f);
  float u0 = slice * 0.0625f + e.r * 0.05859375f;
  float v = e.g * 0.9375f + 0.03125f;
  float3 a = lut.SampleLevel(lut_sampler, float2(u0 + 0.001953125f, v), 0).rgb;
  float3 b = lut.SampleLevel(lut_sampler, float2(u0 + 0.064453125f, v), 0).rgb;
  float f = saturate(e.b * 15.f - slice);
  return lerp(a, b, f);
}

float3 ApplySceneToneMap(float3 source, renodx::draw::Config config) {
  renodx::tonemap::Config tone_map = renodx::tonemap::config::Create();
  tone_map.type = config.tone_map_type;
  tone_map.peak_nits = config.peak_white_nits;
  tone_map.game_nits = config.diffuse_white_nits;
  tone_map.gamma_correction = config.gamma_correction;
  tone_map.exposure = config.tone_map_exposure;
  tone_map.highlights = config.tone_map_highlights;
  tone_map.shadows = config.tone_map_shadows;
  tone_map.contrast = config.tone_map_contrast;
  tone_map.saturation = config.tone_map_saturation;
  tone_map.reno_drt_dechroma = 0.f;
  // A zero-initialized injection uses the tuned default, including during live reload.
  tone_map.reno_drt_blowout = saturate(0.1f + shader_injection.highlight_chroma_rolloff_offset);
  tone_map.reno_drt_hue_correction_method = config.tone_map_hue_processor;
  tone_map.reno_drt_clamp_color_space = config.tone_map_clamp_color_space;
  // Preserve scene RGB ratios until the downstream BT.2020 peak limit.
  tone_map.reno_drt_clamp_peak = renodx::color::convert::COLOR_SPACE_NONE;
  tone_map.reno_drt_white_clip = config.reno_drt_white_clip;
  tone_map.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::NEUTWO;
  float vanilla_hue_influence = 1.f - saturate(shader_injection.tone_map_scene_hue_influence);
  [branch]
  if (vanilla_hue_influence > 0.f) {
    float3 vanilla_sdr = VanillaToneMap(source);
    float3 scene_lab = renodx::color::oklab::from::BT709(source);
    float3 vanilla_lab = renodx::color::oklab::from::BT709(vanilla_sdr);
    float scene_chroma = length(scene_lab.yz) / max(scene_lab.x, 1e-5f);
    float vanilla_chroma = length(vanilla_lab.yz) / max(vanilla_lab.x, 1e-5f);
    // Fade out the SDR reference when the shoulder washes out its hue or it is nearly neutral.
    float confidence = smoothstep(0.15f, 0.65f, vanilla_chroma / max(scene_chroma, 1e-5f))
                     * smoothstep(0.005f, 0.025f, vanilla_chroma);
    tone_map.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
    tone_map.hue_correction_color = lerp(
        source, renodx::color::correct::Luminance(vanilla_sdr, source), confidence * vanilla_hue_influence);
  }
  return renodx::tonemap::config::Apply(source, tone_map);
}

#endif  // SONICXSHADOWGENERATIONS_TONEMAP_HLSLI_
