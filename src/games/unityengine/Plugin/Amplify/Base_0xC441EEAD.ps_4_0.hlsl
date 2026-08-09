#include "../../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

float3 vanillaUC2(float3 input){
  float4 r0, r1, r2, r3;
  r1.xyz = input;
  r0.xy = cb0[7].yy * cb0[7].zw;
  r1.xyz = r1.xyz + r1.xyz;
  r1.w = cb0[8].x;
  r2.xyzw = cb0[6].zzzz * r1.xyzw;
  r2.xyzw = cb0[7].xxxx * cb0[6].wwww + r2.xyzw;
  r2.xyzw = r1.xyzw * r2.xyzw + r0.xxxx;
  r3.xyzw = cb0[6].zzzz * r1.xyzw + cb0[6].wwww;
  r0.xyzw = r1.xyzw * r3.xyzw + r0.yyyy;
  r0.xyzw = r2.xyzw / r0.xyzw;
  r1.x = cb0[7].z / cb0[7].w;
  r0.xyzw = -r1.xxxx + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
return r0.xyz;
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r1.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  o0.w = r1.w;
  r1.xyz = cb0[6].yyy * r1.xyz;
  float midGray = vanillaUC2(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaUC2(r1.xyz);
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
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_highlights = 1.02f;
  config.reno_drt_contrast = 1.12f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r1.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 3.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? cb0[8].x * 0.5f : injectedData.colorGradeClip;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(hueCorrectionColor);
  }
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  r1.xy = cb0[2].zw * v1.xy;
  r0.w = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r0.www;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r0.xyz = applyDither(r0.xyz, r1.xyz * (1.0 / 255.0));
  r0.xyz = handleUserLUT(r0.xyz, t1, s1_s, float3(1 / 1024, 1 / 32, 31), 1, true);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}