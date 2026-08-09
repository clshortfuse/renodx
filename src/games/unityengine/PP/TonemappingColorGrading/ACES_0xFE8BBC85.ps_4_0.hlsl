#include "../../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

float3 vanillaNarkACES(float3 color, float exposure) {
  const float a = 2.51f;
  const float b = 0.03f;
  const float c = 2.43f;
  const float d = 0.59f;
  const float e = 0.14f;
  float3 exposed_color = exposure * color;
  return (exposed_color * (a * exposed_color + b)) / (exposed_color * (c * exposed_color + d) + e);
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  o0.w = r0.w;
  float midGray1 = vanillaNarkACES(float3(0.18f, 0.18f, 0.18f), cb0[4].x).x;
  float3 hueCorrectionColor1 = vanillaNarkACES(r0.xyz, cb0[4].x);
  float midGray2 = vanillaNarkACES(float3(0.18f, 0.18f, 0.18f), cb0[4].y).x;
  float3 hueCorrectionColor2 = vanillaNarkACES(r0.xyz, cb0[4].y);
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = min(3, injectedData.toneMapType);
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_value = midGray2;
  config.mid_gray_nits = midGray2 * 100;
  config.reno_drt_contrast = 1.6f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor2, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 8.0f / cb0[4].y : injectedData.colorGradeClip;
  if(injectedData.toneMapType == 0.f){
    r1.xyz = saturate(hueCorrectionColor2);
    r0.xyz = saturate(hueCorrectionColor1);
  } else {
    r1.xyz = r0.xyz;
  }
  r1.xyz = renodx::tonemap::config::Apply(r1.xyz, config);
  config.mid_gray_value = midGray1;
  config.mid_gray_nits = midGray1 * 100;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor1, injectedData.toneMapHueShift);
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 8.0f / cb0[4].x : injectedData.colorGradeClip;
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  r2.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = lerp(r0.xyz, r1.xyz, r2.x);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}