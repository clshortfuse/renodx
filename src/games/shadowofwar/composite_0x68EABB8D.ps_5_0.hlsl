#include "./tonemap.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Fri Jul 18 14:11:44 2025

cbuffer CBuffer_Data : register(b0) {
  float2 TexCoordScale0 : packoffset(c0);
  float2 MaxTexCoord0 : packoffset(c0.z);
  float2 Gamma : packoffset(c1);  // Gamma.x = 1.4, Gamma.y = 500 / 80
}

SamplerState TextureSampler_s : register(s0);
Texture2D<float4> SourceBuffer0 : register(t0);
Texture2D<float4> SourceBuffer1 : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = TexCoordScale0.xy * v1.xy;
  r0.xy = min(MaxTexCoord0.xy, r0.xy);
  float3 scene_tex = SourceBuffer0.SampleLevel(TextureSampler_s, r0.xy, 0).xyz;   // game tex
  float4 ui_sample = SourceBuffer1.SampleLevel(TextureSampler_s, v1.xy, 0).xyzw;  // ui tex
  float3 ui_tex = ui_sample.rgb;
  float ui_alpha = ui_sample.a;
  float blend_factor = 1 + -ui_alpha;

  float3 composited_color;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    ui_tex = pow(ui_tex, Gamma.x) * Gamma.y;
    composited_color = scene_tex * blend_factor + ui_tex;

  } else {
    // undo gamma boost, normalize brightness, gamma correct for scene
    scene_tex /= (500.f / 80.f);
    scene_tex = pow(scene_tex, 1.f / 1.26f);
    if (RENODX_GAMMA_CORRECTION) scene_tex = ApplyGammaCorrection(scene_tex);
    scene_tex = ApplyDisplayMapAndSliders(scene_tex);
    scene_tex = renodx::effects::ApplyFilmGrain(scene_tex,
                                                r0.xy,
                                                CUSTOM_RANDOM,
                                                CUSTOM_GRAIN_STRENGTH * 0.03f);

    // gamma correct and scale UI
    if (RENODX_GAMMA_CORRECTION) ui_tex = renodx::color::correct::GammaSafe(ui_tex);
    ui_tex *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

    // blend in gamma
    scene_tex = renodx::color::gamma::EncodeSafe(scene_tex, 2.2f);
    ui_tex = renodx::color::gamma::EncodeSafe(ui_tex, 2.2f);
    composited_color = scene_tex * blend_factor + ui_tex;
    composited_color = renodx::color::gamma::DecodeSafe(composited_color, 2.2f);

    composited_color *= RENODX_DIFFUSE_WHITE_NITS / 80.f;
  }

  o0.rgb = composited_color;
  o0.w = 1;
  return;
}
