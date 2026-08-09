#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[161];
}

float3 vanillaSH(float3 color){
  // sRGB => XYZ => D65_2_D60 => AP1 => RRT_SAT
  const float3x3 ACESInputMat = {
    { 0.59719, 0.35458, 0.04823 },
    { 0.07600, 0.90834, 0.01566 },
    { 0.02840, 0.13383, 0.83777 }
  };
  // ODT_SAT => XYZ => D60_2_D65 => sRGB
  const float3x3 ACESOutputMat = {
    { 1.60475, -0.53108, -0.07367 },
    { -0.10208, 1.10813, -0.00605 },
    { -0.00327, -0.07276, 1.07602 }
  };
  color = cb0[142].xxx * color;
  color = mul(ACESInputMat, color);
  float3 a = color * (color + 0.0245786f) - 0.000090537f;
  float3 b = color * (0.983729f * color + 0.4329510f) + 0.238081f;
  color = a / b;
  color = mul(ACESOutputMat, color);
  color = cb0[142].yyy * color;
  return color;
}

float getNewPeak(float oldPeak){
  float Contrast = cb0[143].y;
  if(Contrast <= 1.f){return oldPeak;}
  else {
    return ((oldPeak - 0.5f) * Contrast + 0.5f);
  }
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s1_s, v1.xy, cb0[5].x).xyzw;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(cb0[142].zzz, r0.xyz);
  }
  r1.xyzw = t3.SampleBias(s0_s, v1.xy, cb0[5].x).wxyz;
  if (cb0[160].z < cb0[132].z) {
    r2.xyzw = t1.SampleBias(s2_s, v1.xy, cb0[5].x).xyzw;
    r2.x = cb0[23].z * r2.x + cb0[23].w;
    r2.x = 1 / r2.x;
    r2.y = -cb0[147].x + r2.x;
    r2.z = r2.x < cb0[147].x ? 1.000000 : 0;
    r2.y = -cb0[148].x * r2.z + abs(r2.y);
    r2.y = cb0[147].y * r2.y;
    r2.y = 0.5 * r2.y;
    r2.x = r2.y / r2.x;
    r2.x = min(cb0[149].z, r2.x);
    r2.y = 0.0078125 * r2.x;
    r2.z = cb0[160].z / cb0[132].z;
    r2.x = -r2.x * 0.0078125 + r1.x;
    r1.x = r2.z * r2.x + r2.y;
  }
  r1.x = saturate(128 * r1.x);
  r1.yzw = r1.yzw + -r0.xyz;
  r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  r1.xyzw = t2.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r0.xyz = r1.xyz * cb0[140].xxx * injectedData.fxBloom + r0.xyz;
  float midGray = vanillaSH(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaSH(r0.xyz);
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
  config.reno_drt_saturation = 0.9f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = (int)injectedData.toneMapColorSpace;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout * 0.875f;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 26.f : injectedData.colorGradeClip;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = hueCorrectionColor;
  }
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  r1.w = max(r0.y, r0.z);
  r1.w = max(r1.w, r0.x);
  r2.x = min(r0.y, r0.z);
  r2.x = min(r2.x, r0.x);
  if(injectedData.toneMapType != 0.f){
    r2.x = max(0.f, r2.x);
  }
  r1.w = saturate(-r2.x + r1.w);
  r1.w = 1 + -r1.w;
  r1.w = cb0[143].z * r1.w;
  r2.x = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.xyz = r0.xyz + -r2.xxx;
  r1.xyz = r1.www * r1.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyz = r0.xyz * cb0[144].xyz + -r0.xyz;
  r0.xyz = cb0[144].www * r1.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[143].yyy + float3(0.5,0.5,0.5);
  r1.xyz = cb0[143].xxx * r0.xyz;
  r2.xy = -cb0[158].xy + v1.xy;
  r3.x = cb0[159].x * r2.x;
  r3.y = cb0[158].z * r2.y;
  r1.w = dot(r3.xy, r3.xy);
  r1.w = -cb0[158].w + r1.w;
  r2.x = -cb0[158].w + cb0[145].w;
  r1.w = saturate(r1.w / r2.x);
  r1.w = saturate(-cb0[145].z + r1.w);
  r2.xyz = r0.xyz * cb0[143].xxx + -cb0[157].xyz;
  r2.xyz = r1.www * r2.xyz + cb0[157].xyz;
  r0.xyz = -r0.xyz * cb0[143].xxx + r2.xyz;
  o0.xyz = cb0[157].www * r0.xyz + r1.xyz;
  o0.w = r0.w;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}