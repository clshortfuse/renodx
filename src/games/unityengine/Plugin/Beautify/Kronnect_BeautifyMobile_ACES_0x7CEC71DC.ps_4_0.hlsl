#include "../../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

// Afallon

float3 vanillaNarkACES(float3 color) {
  const float a = 2.51f;
  const float b = 0.03f;
  const float c = 2.43f;
  const float d = 0.59f;
  const float e = 0.14f;
  float3 exposed_color = cb0[5].xxx * color;
  return (exposed_color * (a * exposed_color + b)) / (exposed_color * (c * exposed_color + d) + e);
}

float getNewPeak(float oldPeak){
  float Contrast = cb0[7].y;
  if(Contrast <= 1.f){return oldPeak;}
  else {
    return ((oldPeak - 0.5f) * Contrast + 0.5f);
  }
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.x = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.xyzw = t0.Sample(s0_s, w2.xy).xyzw;
  r0.y = renodx::color::y::from::NTSC1953(r1.xyz);
  r0.z = min(r0.x, r0.y);
  r0.x = max(r0.x, r0.y);
  r1.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r0.y = renodx::color::y::from::NTSC1953(r1.xyz);
  r0.z = min(r0.z, r0.y);
  r0.x = max(r0.x, r0.y);
  r0.y = -9.99999997e-07 + r0.z;
  r0.z = r0.x + -r0.y;
  r0.z = saturate(cb0[6].w / r0.z);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.w = renodx::color::y::from::NTSC1953(r1.xyz);
  r0.y = r0.w * 2 + -r0.y;
  r0.x = r0.y + -r0.x;
  r0.x = r0.x * r0.z;
  r0.x = cb0[6].x * r0.x;
  r0.x = max(-cb0[6].z, r0.x);
  r0.x = min(cb0[6].z, r0.x);
  r2.x = -cb0[2].x;
  r2.y = -0;
  r0.yz = w1.xy + r2.xy;
  r2.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r0.y = cb1[7].x * r2.x + cb1[7].y;
  r0.y = 1 / r0.y;
  r0.z = -cb0[7].z + r0.y;
  r0.y = step(cb0[7].y, r0.y);
  r0.y = cb0[7].x * r0.y;
  r0.z = abs(r0.z) < cb0[7].w ? 1.000000 : 0;
  r0.x = r0.x * r0.z + 1;
  r0.xzw = r1.xyz * r0.xxx;
  o0.w = r1.w;
  /*r0.xzw = cb0[5].xxx * r0.xzw;
  r1.xyz = r0.xzw * float3(2.50999999,2.50999999,2.50999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r1.xyz = r1.xyz * r0.xzw;
  r2.xyz = r0.xzw * float3(2.43000007,2.43000007,2.43000007) + float3(0.589999974,0.589999974,0.589999974);
  r0.xzw = r0.xzw * r2.xyz + float3(0.140000001,0.140000001,0.140000001);
  r0.xzw = r1.xyz / r0.xzw;*/
  float midGray = vanillaNarkACES(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaNarkACES(r0.xzw);
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = min(3, injectedData.toneMapType);
  config.peak_nits = getNewPeak(injectedData.toneMapPeakNits);
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_contrast = 1.6f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xzw, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 8.0f / cb0[5].x : injectedData.colorGradeClip;
  if(injectedData.toneMapType == 0.f){
    r0.xzw = hueCorrectionColor;
  }
  r0.xzw = renodx::tonemap::config::Apply(r0.xzw, config);
  r1.x = max(r0.z, r0.w);
  r1.x = max(r1.x, r0.x);
  r1.y = min(r0.z, r0.w);
  r1.y = min(r1.y, r0.x);
  r1.x = saturate(r1.x + -r1.y);
  r1.x = 1 + -r1.x;
  r1.x = cb0[5].z * r1.x;
  r1.y = renodx::color::y::from::NTSC1953(r0.xzw);
  r1.yzw = -r1.yyy + r0.xzw;
  r1.xyz = r1.xxx * r1.yzw + float3(1,1,1);
  r0.xzw = r1.xyz * r0.xzw;
  r1.xyz = r0.xzw * cb0[9].xyz + -r0.xzw;
  r0.xzw = cb0[9].www * r1.xyz + r0.xzw;
  r0.xzw = float3(-0.5,-0.5,-0.5) + r0.xzw;
  r0.xzw = r0.xzw * cb0[5].yyy + float3(0.5,0.5,0.5);
  r1.xy = cb1[6].xy * v1.xy;
  r1.x = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r1.xxx;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = r0.yyy * r1.xyz + float3(1,1,1);
  o0.xyz = r1.xyz * r0.xzw;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}