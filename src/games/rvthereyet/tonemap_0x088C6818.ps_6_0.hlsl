// Unreal Engine tonemap: scene color + bloom + local exposure -> log -> 32^3 grading LUT, written as R10G10B10A2.
// Translated from the DXIL of the original shader (the DevKit cannot decompile it).
#include "./common.hlsli"

StructuredBuffer<float4> t0 : register(t0);  // eye adaptation
Texture2D<float4> t1 : register(t1);         // scene color
Texture2D<float4> t2 : register(t2);         // bloom
StructuredBuffer<float4> t3 : register(t3);  // scene color scale
Texture3D<float4> t4 : register(t4);         // local exposure grid
Texture2D<float4> t5 : register(t5);         // local exposure
Texture2D<float4> t6 : register(t6);         // lens dirt
Texture3D<float4> t7 : register(t7);         // grading LUT

SamplerState s0 : register(s0);
SamplerState s1 : register(s1);
SamplerState s2 : register(s2);
SamplerState s3 : register(s3);
SamplerState s4 : register(s4);
SamplerState s5 : register(s5);

cbuffer cb0 : register(b0) {
  float4 cb0[64];
};

cbuffer cb1 : register(b1) {
  float4 cb1[378];
};

struct PSOutput {
  float4 color : SV_Target0;
  float luma : SV_Target1;
};

PSOutput main(
    float2 uv : TEXCOORD0,
    float2 vignette_position : TEXCOORD1,
    float4 noise_seed : TEXCOORD2,
    float2 dirt_position : TEXCOORD3,
    float2 exposure_uv : TEXCOORD4,
    noperspective float4 position : SV_Position) {
  const float pre_exposure = cb1[156].w;
  const float4 eye_adaptation = t0[0];

  const float2 scene_uv = clamp(uv, cb0[16].xy, cb0[16].zw);
  const float3 scene = t1.Sample(s0, scene_uv).rgb;

  const float2 bloom_uv = clamp(cb0[37].xy * uv + cb0[37].zw, cb0[38].xy, cb0[38].zw);
  const float3 bloom = t2.Sample(s1, bloom_uv).rgb;

  const float2 dirt_ndc = cb0[60].zw * dirt_position + cb0[60].xy;
  const float3 dirt = t6.Sample(s4, float2(dirt_ndc.x * 0.5f + 0.5f, 0.5f - dirt_ndc.y * 0.5f)).rgb;
  const float3 bloom_dirt = (cb0[57].xyz * dirt + 1.f) * bloom;

  // Local exposure
  const float log_luma = log2(max(dot(scene * pre_exposure, cb0[28].xyz), cb0[26].w));
  const float log_target = log2(eye_adaptation.w * 0.18f * cb0[34].x);
  const float3 grid_uv = float3(cb0[34].zw * exposure_uv, (cb0[26].y * log_luma + cb0[26].z) * 0.96875f + 0.015625f);
  const float2 grid = t4.Sample(s2, grid_uv).xy;
  const float local_luma = t5.Sample(s3, exposure_uv).x;
  const float local_log = ((grid.y < 0.001f) ? local_luma : (grid.x / grid.y));
  const float log_exposure = log2(eye_adaptation.x);
  const float log_local_luma = local_log + (local_luma - local_log) * cb0[33].w + log_exposure;
  const float log_scene = log_exposure + log_luma;
  const float error_to_target = log_local_luma - log_target;

  // Soft knee on the distance between the local exposure and the target, separate for brightening and darkening
  const bool brightening = error_to_target > 0.f;
  const float knee_start = (brightening ? cb0[35].x : cb0[35].y);
  const float knee_range = (brightening ? cb0[35].z : cb0[35].w);
  const float knee_offset = (brightening ? max(0.f, error_to_target - knee_start) : min(0.f, knee_start + error_to_target));
  const float knee_weight = smoothstep(0.f, 1.f, saturate((abs(error_to_target) - knee_start) * (1.f - knee_range)));
  const float knee_shaped = (1.f - knee_weight) * (error_to_target - knee_offset);
  const float local_exposure = exp2(
      (log_target - log_scene) + (log_scene - log_local_luma) * cb0[33].z + knee_shaped
      + (error_to_target - knee_shaped) * (brightening ? cb0[33].x : cb0[33].y));

  float vignette = 1.f;
  if (cb0[59].x > 0.f) {
    const float2 scaled = cb0[59].x * vignette_position;
    const float falloff = 1.f / (dot(scaled, scaled) + 1.f);
    vignette = falloff * falloff;
  }

  const float exposure = eye_adaptation.x * pre_exposure;
  const float3 untonemapped = (bloom_dirt * (exposure * vignette))
                              + (cb0[56].xyz * scene * t3[0].xyz * (exposure * local_exposure * vignette));

  const float3 lut_input = saturate(log2(untonemapped + LUT_LOG_OFFSET) * LUT_LOG_SCALE + LUT_LOG_BIAS);
  const float3 lut_coord = lut_input * cb0[62].z + cb0[62].w;
  float3 color = t7.Sample(s5, lut_coord).rgb * LUT_OUTPUT_SCALE;

  PSOutput output;
  output.luma = dot(color, float3(0.299f, 0.587f, 0.114f));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    // RenoDX: replace the vanilla clipped LUT output with the HDR tonemap; no dither on the float output
    color = ToneMapLut(untonemapped, color, t7, s5, cb0[62].zw);
  } else {
    const float noise = frac(sin(noise_seed.w * 543.31f + noise_seed.z) * 493013.f) * 2.f - 1.f;
    color += (sign(noise) - sign(noise) * sqrt(saturate(1.f - abs(noise)))) * cb0[63].y;
  }

  output.color = float4(color, 0.f);
  return output;
}
