#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

float3 vanillaTonemap(float3 input){
float4 r0,r1,r2;
  r0.xyz = input;
  r1.x = renodx::color::y::from::NTSC1953(r0.xyz);
  r2.xyzw = r1.x > cb0[8].y ? cb0[7].xyzw : cb0[6].xyzw;
  r1.y = r1.x > cb0[8].y ? cb0[8].x : 0;
  r1.zw = r2.xy * r1.xx + r2.zw;
  r1.z = r1.z / r1.w;
  r1.y = r1.z + r1.y;
  r1.z = r1.x / cb0[10].x;
  r1.z = 1 + r1.z;
  r1.y = r1.y * r1.z;
  r1.x = r1.y / r1.x;
  r0.xyz = r1.xxx * r0.xyz;
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
  float midGray = vanillaTonemap(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaTonemap(r0.xyz);
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
  config.reno_drt_dechroma = injectedData.toneMapPerChannel != 1.f ? injectedData.colorGradeDechroma : max(0.00001f, injectedData.colorGradeDechroma);
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 1.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 3.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 1.f;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 5.f : injectedData.colorGradeClip;
  if (config.type == 0.f) {
    r0.xyz = saturate(hueCorrectionColor);
  }
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  o0.xyzw = cb0[9].xyzw * r0.xyzw;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}