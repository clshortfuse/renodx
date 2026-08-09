#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

float3 vanillaUC2(float3 input) {
  float3 r0,r1,r2;
  r0 = input;
  r1.xyz = r0.xyz * float3(0.3,0.3,0.3) + float3(0.05,0.05,0.05);
  r2.xyz = r0.xyz + r0.xyz;
  r0.xyz = r0.xyz * float3(0.3,0.3,0.3) + float3(0.5,0.5,0.5);
  r0.xyz = r2.xyz * r0.xyz + float3(0.06,0.06,0.06);
  r1.xyz = r2.xyz * r1.xyz + float3(0.004,0.004,0.004);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = float3(-0.02 / 0.3, -0.02 / 0.3, -0.02 / 0.3) + r0.xyz;
  r0.xyz = float3(1.37906432,1.37906432,1.37906432) * r0.xyz;
  return r0.xyz;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = cb0[9].yyy * r0.xyz;
  float midGray = vanillaUC2(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaUC2(r0.xyz);
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType >= 2.f ? 3.f : injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType - 2.f;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 5.6f : injectedData.colorGradeClip;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(hueCorrectionColor);
  }
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}