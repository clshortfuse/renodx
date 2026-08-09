#include "../../common.hlsl"

Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[22];
}
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[13];
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
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = cb0[9].y;
  r1.xyzw = t0.Sample(s2_s, v1.xy).xyzw;
  float midGray1 = vanillaNarkACES(float3(0.18f, 0.18f, 0.18f), cb0[4].x).x;
  float3 hueCorrectionColor1 = vanillaNarkACES(r1.xyz, cb0[4].x);
  float midGray2 = vanillaNarkACES(float3(0.18f, 0.18f, 0.18f), cb0[4].y).x;
  float3 hueCorrectionColor2 = vanillaNarkACES(r1.xyz, cb0[4].y);
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
  config.hue_correction_color = lerp(r1.xyz, hueCorrectionColor2, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 8.0f / cb0[4].y : injectedData.colorGradeClip;
  if(injectedData.toneMapType == 0.f){
    r2.xyz = saturate(hueCorrectionColor2);
    r3.xyz = saturate(hueCorrectionColor1);
  } else {
    r2.xyz = r1.xyz;
    r3.xyz = r1.xyz;
  }
  r2.xyz = renodx::tonemap::config::Apply(r2.xyz, config);
  config.mid_gray_value = midGray1;
  config.mid_gray_nits = midGray1 * 100;
  config.hue_correction_color = lerp(r1.xyz, hueCorrectionColor1, injectedData.toneMapHueShift);
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 8.0f / cb0[4].x : injectedData.colorGradeClip;
  r3.xyz = renodx::tonemap::config::Apply(r3.xyz, config);
  r4.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.xyz = lerp(r3.xyz, r2.xyz, r4.x);
  r5.xyz = handleUserLUT(r2.xyz, t3, s4_s, cb0[9].xyz, 1, true);
  r4.yzw = lerp(r2.xyz, r5.xyz, cb0[9].w);
  r3.xyz = handleUserLUT(r2.xyz, t2, s3_s, cb0[8].xyz, 1, true);
  r0.xyz = lerp(r2.xyz, r3.xyz, cb0[8].w);
  r0.xyz = lerp(r0.xyz, r4.yzw, r4.x);
  r0.w = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r0.xyz = -r0.www * cb0[12].yyy + r0.xyz;
  r0.w = cb0[12].y * r0.w;
  r2.xy = cb0[2].xy + cb0[2].zw;
  r2.zw = -cb0[2].xy + cb0[2].zw;
  r2.xy = r2.xy + -r2.zw;
  r2.xy = v1.xy * r2.xy + r2.zw;
  r3.xyzw = t4.Sample(s0_s, v1.xy).xyzw;
  r2.z = cb1[7].x * r3.x + cb1[7].y;
  r2.z = 1 / r2.z;
  r2.xy = r2.xy * r2.zz;
  r3.xyz = cb2[19].xyz * r2.yyy;
  r2.xyw = cb2[18].xyz * r2.xxx + r3.xyz;
  r3.x = cb1[5].z * r2.z;
  r2.xyw = cb2[20].xyz * r3.xxx + r2.xyw;
  r2.xyw = cb2[21].xyz + r2.xyw;
  r3.xy = r2.xw * cb0[11].xy + cb0[11].zw;
  r4.xyzw = t5.Sample(s5_s, r3.xy).xyzw;
  r2.y = r2.y >= cb0[12].x ? 1 : r4.x;
  r2.y = r2.z >= 1 ? 0 : r2.y;
  r1.xyz = r2.yyy * r0.xyz + r0.www;
  r0.xyzw = r2.yyyy * r1.xyzw;
  r1.xy = float2(1,1) + -r3.xy;
  r1.xy = min(r3.xy, r1.xy);
  r1.xy = r1.xy / cb0[11].xy;
  r1.xy = float2(0.1,0.1) * r1.xy;
  r1.x = saturate(min(r1.x, r1.y));
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.xy = float2(0.333333343,0.25) * cb1[0].xx;
  r1.xz = cb1[2].yx * float2(0.0625,0.0625) + -r1.xx;
  r1.yw = cb1[2].yx * float2(0.0625,0.0625) + r1.yy;
  r1.yw = r2.wx * float2(0.0625,0.0625) + r1.yw;
  r1.xz = r2.xw * float2(0.0625,0.0625) + r1.xz;
  r3.xyzw = t6.Sample(s6_s, r1.xz).xyzw;
  r1.x = 5 * r3.x;
  r3.xyzw = t6.Sample(s6_s, r1.yw).xyzw;
  r1.x = r3.x * r1.x;
  r1.y = 3.75 * r1.x;
  r1.x = -r1.x * 3.75 + 1;
  r1.x = r2.y * r1.x + r1.y;
  o0.xyzw = r1.xxxx * r0.xyzw;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}