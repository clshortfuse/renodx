#include "../../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

float3 vanillaCIEtonemap(float3 input){
float4 r0,r1,r2;
  r0.xyz = input;
  r0.xyz = cb0[7].xxx * r0.xyz;
  r1.z = dot(float3(0.0241188,0.1228178,0.84442666), r0.xyz);
  r1.x = dot(float3(0.5141364,0.3238786,0.16036376), r0.xyz);
  r1.y = dot(float3(0.265068,0.67023428,0.06409157), r0.xyz);
  r0.x = dot(float3(1,1,1), r1.xyz);
  r0.xy = r1.xy / r0.xx;
  r1.x = cb0[7].y * r1.y;
  r0.z = 1 + -r0.x;
  r0.z = r0.z + -r0.y;
  r1.yw = float2(0.5,0);
  r2.xyzw = t1.Sample(s1_s, r1.xy).yxzw;
  r0.xz = r2.yy * r0.xz;
  r2.xz = r0.xz / r0.yy;
  r0.y = dot(float3(2.5651,-1.1665,-0.3986), r2.xyz);
  r0.z = dot(float3(-1.0217,1.9777,0.0439), r2.xyz);
  r0.x = dot(float3(0.0753,-0.2543,1.1892), r2.xyz);
return r0.yzx;
}

float setParam(float3 params){
  [branch]
  if(params.x == 1.0 && params.y == 1.0 && params.z == 0.34582768) return 1;  // Dreamfall Chapters
  else if(params.x == 0.80000001 && params.y == 1.00089848) return 2;  // Dreamfall Chapters
  else if(params.x == 1.0 && params.y == 1.0 && params.z == 0.14903727) return 3;  // Dreamfall Chapters
else return 0;
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
  o0.w = r0.w;
  float midGray = vanillaCIEtonemap(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaCIEtonemap(r0.xyz);
  float param = setParam(float3(cb0[7].xy, midGray));
  float defaultClip = 5.f;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = param == 0.f ? 0.f : (injectedData.toneMapType >= 2.f ? 3.f : injectedData.toneMapType);
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  //config.saturation = injectedData.colorGradeSaturation;
  //config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  //config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  if(param == 1){
  config.reno_drt_contrast = 1.1f;
  config.reno_drt_flare = 0.045f * pow(injectedData.colorGradeFlare, 2.f);
  } else if(param == 2){
  defaultClip = 2.f;
  config.reno_drt_highlights = 1.06f;
  config.reno_drt_contrast = 1.1f;
  config.reno_drt_flare = 0.09f * pow(injectedData.colorGradeFlare, 2.f);
  } else if(param == 3){
  config.reno_drt_highlights = 1.06f;
  config.reno_drt_shadows = 1.05f;
  config.reno_drt_contrast = 1.28f;
  }
  config.hue_correction_type = injectedData.toneMapPerChannel != 1.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType - 2.f;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 1.f;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? defaultClip : injectedData.colorGradeClip;
  if (config.type == 0.f) {
    r0.xyz = saturate(hueCorrectionColor);
  }
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  r0.xyz = handleUserLUT(r0.xyz, t2, s2_s, cb0[10].xyz, 2, true);
  r0.xyz = grading(r0.xyz);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}