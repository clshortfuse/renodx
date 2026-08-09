#include "../../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

float3 vanillaExp(float3 color){
  return 1 - exp2(-color);
}


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v3.xy, 0).xyzw;
  r0.xyz = cb0[4].yyy * r0.xyz;
  o0.w = r0.w;
  float midGray = vanillaExp(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaExp(r0.xyz);
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType >= 2.f ? 3.f : injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.saturation = injectedData.colorGradeSaturation;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType - 2.f;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 6.0 : injectedData.colorGradeClip;
  if(config.type == 0.f){
    r0.xyz = saturate(hueCorrectionColor);
  }
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  r0.xyz = handleUserLUT(r0.xyz, t1, s1_s, float3(1 / 1024, 1 / 32, 31), 1, true);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}