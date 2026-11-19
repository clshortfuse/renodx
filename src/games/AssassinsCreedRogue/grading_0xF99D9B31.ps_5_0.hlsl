#include "./common.hlsl"
#include "./finite.hlsli"
#include "../../shaders/tonemap/psychov/psychov-24.hlsl"
#include "../../shaders/tonemap/psychov/test30.hlsl"

#ifndef RENODX_BLOOM_STRENGTH
#define RENODX_BLOOM_STRENGTH 1.f
#endif

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t7 : register(t7);

SamplerState s0_s : register(s0);
SamplerState s4_s : register(s4);
SamplerState s5_s : register(s5);
SamplerState s6_s : register(s6);
SamplerState s7_s : register(s7);

cbuffer GameGrade : register(b0) {
  float4 cb0[186];
}

// Continue each native 16-entry curve past its endpoint instead of sampling a
// compressed proxy and trying to restore clipped color afterward. The input
// and output here are the game's gamma-2.2 values, not linear light.
float SampleRogueCurve(Texture2D<float4> table, SamplerState table_sampler,
                       float encoded, float address_scale, float address_offset, bool extend_lut) {
  float sampled = table.SampleLevel(table_sampler, float2(encoded * address_scale + address_offset, 0.5f), 0.f).r;
  if (extend_lut && encoded > 1.f) {
    float edge = table.SampleLevel(table_sampler, float2(address_scale + address_offset, 0.5f), 0.f).r;
    float inner = table.SampleLevel(table_sampler, float2((14.f / 15.f) * address_scale + address_offset, 0.5f), 0.f).r;
    float slope = max((edge - inner) * 15.f, 0.f);
    float excess = encoded - 1.f;
    // Match the last segment at the join, recovering unit slope gradually if
    // an authored endpoint is flat. Identity curves remain identity above one.
    float continuation = excess + (slope - 1.f) * (1.f - exp(-excess));
    sampled = max(edge + continuation, 0.f);
  }
  return sampled;
}

float3 ApplyGameLUTAndGrade(float3 encoded, bool extend_lut = false) {
  // Preserve the game's sampler and cbuffer half-texel addressing for all
  // three independent 1D curves; generic 3D LUT sampling is not equivalent.
  float4 lut = float4(
      SampleRogueCurve(t5, s5_s, encoded.r, cb0[128].r, cb0[129].r, extend_lut),
      SampleRogueCurve(t6, s6_s, encoded.g, cb0[128].g, cb0[129].g, extend_lut),
      SampleRogueCurve(t7, s7_s, encoded.b, cb0[128].b, cb0[129].b, extend_lut),
      1.f);
  // Like AC1/Liberation's range reconstruction, carry the scale around the
  // bounded matrix/filter grade so its SDR clamps cannot erase HDR detail.
  float grade_range = extend_lut ? max(1.f, max(lut.r, max(lut.g, lut.b))) : 1.f;
  lut.rgb /= grade_range;
  float3 graded = saturate(float3(dot(lut, cb0[183]), dot(lut, cb0[184]), dot(lut, cb0[185])));

  if (asuint(cb0[132].x) != 0u) {
    float luma = dot(graded, float3(0.2125f, 0.7154f, 0.0721f));
    float3 tint = lerp(graded, luma.xxx, cb0[133].x) * cb0[134].xyz;
    float3 overlay = graded < 0.5f ? 2.f * tint * graded : 1.f - 2.f * (1.f - tint) * (1.f - graded);
    graded = lerp(graded, overlay, cb0[134].w);
  }
  return graded * grade_range;
}

float3 MapRogueDisplay(float3 scene, float mode) {
  renodx::draw::Config config = renodx::draw::BuildConfig();
  float peak = max(config.peak_white_nits / max(config.diffuse_white_nits, 1.f), 1.f);
  float3 mapped;
  if (mode == RENODX_TONE_MAP_TYPE_PSYCHOV30) {
    mapped = renodx::tonemap::psychov::psychotm_test30(
        scene, peak, 1.f, 1.f, 1.f, 1.f, 1.f, 1.f, 100.f, 1.f,
        1.f, 0, max(shader_injection.psychov30_cone_response, 0.01f), 0.18f.xxx, 0.18f.xxx,
        shader_injection.psychov30_gamut_compression, shader_injection.psychov30_gamut_mode > 0.5f ? 1 : 0,
        1.f, shader_injection.psychov30_compression);
  } else if (mode == RENODX_TONE_MAP_TYPE_PSYCHOV24) {
    mapped = renodx::tonemap::psychov::psychotm_test24(
        scene, peak, 1.f, 1.f, 1.f, 1.f, 1.f, 1.f, 100.f, RENODX_TONE_MAP_HUE_CORRECTION,
        1.f, 0, RENODX_PSYCHOV24_CONE_RESPONSE, 0.18f.xxx, 0.18f.xxx,
        RENODX_PSYCHOV24_GAMUT_COMPRESSION, RENODX_PSYCHOV24_GAMUT_MODE > 0.5f ? 1 : 0,
        1.f, RENODX_PSYCHOV24_COMPRESSION, RENODX_PSYCHOV24_HIGHLIGHT_SATURATION,
        RENODX_PSYCHOV24_GAMUT_HUE_RESTORE);
  } else {
    config.tone_map_type = renodx::draw::TONE_MAP_TYPE_RENO_DRT;
    // This pass writes the game's gamma 2.2 encoding directly.
    config.gamma_correction = 0.f;
    // The shared scene controls already ran ahead of the LUT.
    config.tone_map_exposure = 1.f;
    config.tone_map_highlights = 1.f;
    config.tone_map_shadows = 1.f;
    config.tone_map_contrast = 1.f;
    config.tone_map_saturation = 1.f;
    config.tone_map_highlight_saturation = 1.f;
    config.tone_map_blowout = 0.f;
    config.tone_map_flare = 0.f;
    mapped = renodx::draw::ToneMapPass(scene, config);
  }
  float shoulder = smoothstep(0.75f, 2.f, renodx::color::y::from::BT709(scene));
  return lerp(scene, RogueFinite(mapped), shoulder);
}

void main(float4 position : SV_Position0, float2 uv : TEXCOORD0, out float4 output : SV_Target0) {
  float3 scene = RogueFinite(t0.Sample(s0_s, uv).rgb);
  float3 bloom = RogueFinite(t4.Sample(s4_s, uv).rgb);
  float mode = RENODX_TONE_MAP_TYPE;
  if (RENODX_PEAK_WHITE_NITS <= 0.f
      || (mode != renodx::draw::TONE_MAP_TYPE_RENO_DRT
          && mode != RENODX_TONE_MAP_TYPE_PSYCHOV24
          && mode != RENODX_TONE_MAP_TYPE_PSYCHOV30)) {
    output = float4(ApplyGameLUTAndGrade(saturate(scene + bloom)), 0.f);
    return;
  }

  float3 source = min(max(scene, 0.f) + max(bloom, 0.f) * RENODX_BLOOM_STRENGTH, ROGUE_FP16_MAX);
  float3 hdr = max(RogueFinite(PreTonemapSliders(renodx::color::gamma::DecodeSafe(source))), 0.f);
  float3 graded = renodx::color::gamma::DecodeSafe(ApplyGameLUTAndGrade(renodx::color::gamma::EncodeSafe(hdr), true));
  graded = max(RogueFinite(lerp(hdr, graded, saturate(RENODX_COLOR_GRADE_STRENGTH))), 0.f);
  float3 mapped = max(RogueFinite(PostTonemapSliders(MapRogueDisplay(graded, mode))), 0.f);
  output = float4(min(renodx::color::gamma::EncodeSafe(mapped), ROGUE_FP16_MAX), 0.f);
}
