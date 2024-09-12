#include "./shared.h"

cbuffer cbShaderParams : register(b0) {
  struct
  {
    float4 Value0;
    float4 Value1;
    float4 Value2;
    float4 Value3;
    float4 Value4;
    float4 Value5;
    float4 Value6;
    float4 Value7;
  } cbShaderParams : packoffset(c0);
}

SamplerState _texDiffuse_s : register(s0);
SamplerState _texHDRBloom_s : register(s1);
Texture2D<float4> texDiffuse : register(t0);
Texture2D<float4> texHDRBloom : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_Position0,
                float2 v1 : TEXCOORD0,
                            out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = texDiffuse.Sample(_texDiffuse_s, v1.xy).xyzw;  // In Gamma

  // y = (1.04x)/(x+0.2) tonemap
  // x = 0.2y/(1.04-y)
  r1.xyz = float3(-1.03999996, -1.03999996, -1.03999996) + r0.xyz;
  r0.xyz = r0.xyz / r1.xyz;
  r1.xyz = float3(-0.200000003, -0.200000003, -0.200000003) * r0.xyz;

  float3 diffuse_linear = r1.xyz;

  r0.xyz = r0.xyz * float3(-0.200000003, -0.200000003, -0.200000003) + float3(-1, -1, -1);
  // r0.xyz = r1.xyz - 1.f

  r2.xyzw = texHDRBloom.Sample(_texHDRBloom_s, v1.xy).xyzw;

  float3 bloom = r2.xyz;

  r0.xyz = r2.www * r0.xyz + float3(1, 1, 1);

  // r0.xyz = (r1.xyz - 1) * r2.w  + 1.f;
  // r0.xyz = lerp(1.f, r1.xyz, r2.w);
  // r0.xyz = lerp(1.f, diffuse_linear, r2.w);

  r2.xyz = float3(1, 1, 1) + -r2.xyz;
  // r2.xyz = 1 - bloom;

  float3 untonemapped = r1.xyz * r0.xyz;

  r0.xyz = r1.xyz * r0.xyz + float3(-0.00400000019, -0.00400000019, -0.00400000019);

  // r0.xyz = diffuse_linear *

  r0.xyz = max(float3(0, 0, 0), r0.xyz);

  r1.xyz = r0.xyz * float3(6.19999981, 6.19999981, 6.19999981) + float3(0.5, 0.5, 0.5);
  r1.xyz = r1.xyz * r0.xyz;
  r3.xyz = r0.xyz * float3(6.19999981, 6.19999981, 6.19999981) + float3(1.70000005, 1.70000005, 1.70000005);
  r0.xyz = r0.xyz * r3.xyz + float3(0.0599999987, 0.0599999987, 0.0599999987);
  r0.xyz = r1.xyz / r0.xyz;

  if (injectedData.toneMapType != 0.f) {
    float midgray = 0.18f;
    midgray = max(0, midgray - 0.004f);
    float midgray_r1 = midgray * 6.2f + 0.5f;
    midgray_r1 = midgray_r1 * midgray;
    float midgray_r3 = midgray * 6.2f + 1.7f;
    midgray = midgray * midgray_r3 + 0.06f;
    midgray = midgray_r1 / midgray;
    midgray = pow(midgray, 2.2f);

    renodx::tonemap::Config config = renodx::tonemap::config::Create();
    config.type = injectedData.toneMapType;
    config.peak_nits = injectedData.toneMapPeakNits;
    config.game_nits = injectedData.toneMapGameNits;
    config.exposure = injectedData.colorGradeExposure;
    config.highlights = injectedData.colorGradeHighlights;
    config.shadows = injectedData.colorGradeShadows;
    config.contrast = injectedData.colorGradeContrast;
    config.saturation = injectedData.colorGradeSaturation;
    config.mid_gray_value = midgray;
    config.mid_gray_nits = midgray * 100.f;
    if (injectedData.toneMapHueCorrection != 0.f) {
      config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
      config.hue_correction_color = r0.xyz;
      config.hue_correction_strength = injectedData.toneMapHueCorrection;
    }

    config.reno_drt_highlights = 1.0f;
    config.reno_drt_shadows = 1.0f;
    config.reno_drt_contrast = 1.0f;
    config.reno_drt_saturation = 1.0f;
    config.reno_drt_dechroma = injectedData.colorGradeBlowout;
    config.reno_drt_flare = 0.00f;
    r0.xyz = renodx::tonemap::config::Apply(diffuse_linear, config);

    r0.xyz = pow(abs(r0.xyz), 1.f / 2.2f);
  }
  r0.xyz = r0.xyz / cbShaderParams.Value0.yyy;  // 0.88?
  r0.xyz = float3(1, 1, 1) + -r0.xyz;

  r0.xyz = -r2.xyz * r0.xyz + float3(1, 1, 1);
  // r0.xyz = -(1.f - bloom) * r0.xyz + 1.f
  // r0.xyz = (bloom - 1.f) * r0.xyz + 1.f
  // r0.xyz = lerp(1.f, bloom, r0.xyz);

  r0.xyz = log2(r0.xyz);
  r0.xyz = cbShaderParams.Value0.www * r0.xyz;  // gamma (user brightness)
  o0.xyz = exp2(r0.xyz);
  o0.w = 1;

  // o0.rgb = pow(cbShaderParams.Value0.yyy, 1.f/2.2f);
  float3 signs = sign(o0.rgb);
  o0.rgb = abs(o0.rgb);
  o0.rgb = pow(o0.rgb, 2.2f);
  o0.rgb *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  o0.rgb = pow(o0.rgb, 1.f / 2.2f);
  o0.rgb *= signs;
  // o0.rgb = r2.xyz;
  // if (o0.r <= 1.f) o0.r = 0;
  // if (o0.g <= 1.f) o0.g = 0;
  // if (o0.b <= 1.f) o0.b = 0;
  return;
}