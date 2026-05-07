#include "./shared.h"

// Match the game's original resource bindings exactly
cbuffer cbEngine : register(b0) {
  float4 cbEngine_data[204];  // Large engine cbuffer, we only need candelaPerUnit
};

cbuffer cbObjectDynamic : register(b3) {
  float4 g_BloomParams;                    // Offset 0
  float4 g_ColorGradingGlobal;             // Offset 16
  float4 g_ColorGradingSaturation;         // Offset 32
  float4 g_ColorGradingRegion;             // Offset 48
  float4 g_ColorGradingShadow;             // Offset 64
  float4 g_ColorGradingMidTone;            // Offset 80
  float4 g_ColorGradingHighlight;          // Offset 96
  float4 g_ColorGradingColorFilter;        // Offset 112
  float4x4 g_PurkinjeRGBToLMSGainControl; // Offset 128
  float4x4 g_PurkinjeLMSGainToRGBGain;    // Offset 192
  float g_PurkinjeGainPower;               // Offset 256
  float _pad0[3];
  float4 g_HDRAutoExposure;                // Offset 272
  float4 g_TonemapperParams;               // Offset 288
  int g_ToneMapOperator;                   // Offset 304
  float g_LocalToneMappingPower;           // Offset 308
  float g_LocalToneMappingSigma;           // Offset 312
  float _pad1;
  float4 g_LocalToneMappingExposures;      // Offset 320
  float g_LocalToneMappingExposureRangeMultiplier; // Offset 336
  float g_ToneMappingOffset;               // Offset 340
  float _pad2[2];
  float4 g_ToneMappingOffsetCurveInput;    // Offset 352
  float4 g_ToneMappingOffsetCurveResponse; // Offset 368
};

Texture2D<float4> g_AverageLuminance : register(t0);
Texture2D<float4> g_BloomTexture : register(t1);
SamplerState g_Sampler_LinearClamp : register(s1);
RWTexture2D<float4> g_TextureRW : register(u0);

// candelaPerUnit is at cbEngine offset 2924 = register index 182, component w
#define candelaPerUnit cbEngine_data[182].w

[numthreads(8, 8, 1)]
void main(uint3 dtid : SV_DispatchThreadID) {
  uint width, height;
  g_TextureRW.GetDimensions(width, height);

  // Load scene color
  float3 scene_color = g_TextureRW[dtid.xy].rgb;

  // Compute UV for sampling
  float2 uv = (float2(dtid.xy) + 0.5f) / float2(width, height);

  // Sample and add bloom
  float3 bloom = g_BloomTexture.SampleLevel(g_Sampler_LinearClamp, uv, 0).rgb;
  bloom = max(0, bloom * g_BloomParams.x);
  scene_color += bloom;

  // Purkinje effect (night vision color adaptation)
  float3 scaled = scene_color * candelaPerUnit;
  float3 lms = mul(g_PurkinjeRGBToLMSGainControl, float4(scaled, 0)).rgb;
  float gain_power = abs(g_PurkinjeGainPower);
  float3 lms_gained = 1.0f / pow(lms + 1.0f, gain_power);
  float3 purkinje_rgb = mul(g_PurkinjeLMSGainToRGBGain, float4(lms_gained, 0)).rgb;
  float purkinje_weight = mul(g_PurkinjeLMSGainToRGBGain, float4(lms_gained, 0)).w;
  scene_color = (purkinje_rgb * purkinje_weight + scaled) / candelaPerUnit;

  // Auto-exposure
  float avg_lum = g_AverageLuminance.SampleLevel(g_Sampler_LinearClamp, float2(0.5f, 0.5f), 0).r;
  scene_color *= avg_lum;

  // Color grading (HSV-based shadow/midtone/highlight)
  float3 exposed = scene_color;

  // Saturation adjustment via power curve
  float3 abs_color = abs(exposed / avg_lum);
  float3 sat_color = sign(exposed) * pow(abs_color, g_ColorGradingGlobal.x);
  sat_color *= avg_lum;

  // Luminance zones for shadow/mid/highlight grading
  float luma = dot(exposed, float3(0.2126f, 0.7152f, 0.0722f));
  float log_luma = log(luma);
  float log_avg = log(avg_lum);

  // Shadow/midtone/highlight zone weights
  float shadow_range = g_ColorGradingRegion.x - g_ColorGradingRegion.y;
  shadow_range = min(shadow_range, -1e-7f);
  float highlight_range = g_ColorGradingRegion.w - g_ColorGradingRegion.z;
  highlight_range = max(highlight_range, 1e-7f);

  float shadow_weight = saturate((-g_ColorGradingRegion.y - log_avg + log_luma) / shadow_range);
  float highlight_weight = saturate((-g_ColorGradingRegion.z - log_avg + log_luma) / highlight_range);
  float midtone_weight = saturate(1.0f - shadow_weight - highlight_weight);

  // Apply color grading per zone
  float3 graded = sat_color;
  graded *= (shadow_weight * g_ColorGradingShadow.rgb +
             midtone_weight * g_ColorGradingMidTone.rgb +
             highlight_weight * g_ColorGradingHighlight.rgb);

  // Color filter
  float filter_strength = shadow_weight * g_ColorGradingShadow.w +
                          midtone_weight * g_ColorGradingMidTone.w +
                          highlight_weight * g_ColorGradingHighlight.w;
  float3 filtered = max(0, graded) * g_ColorGradingColorFilter.rgb;
  float3 color_diff = filtered - graded;
  graded += color_diff * filter_strength;

  // --- RenoDX HDR path ---
  if (shader_injection.tone_map_type == 0) {
    // Vanilla: apply the game's original clamp (mimics original behavior)
    graded = clamp(graded, 0, 64000);
  } else {
    // HDR: just clamp negatives, preserve full range
    graded = max(0, graded);
  }

  g_TextureRW[dtid.xy] = float4(graded, 1.0f);
}
