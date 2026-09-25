#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

float3 vanillaTonemap(float3 input){
float4 r0,r1,r2;
  r0.xyz = input;
  r1.x = renodx::color::y::from::NTSC1953(r0.xyz);
  // old_lum > cb0[8].y ?
  r2.xyzw = r1.x > cb0[8].y ? cb0[7].xyzw : cb0[6].xyzw;
  // old_lum > cb0[8].y ?
  r1.y = r1.x > cb0[8].y ? cb0[8].x : 0;
  r1.zw = r2.xy * r1.xx + r2.zw;
  // (old_lum > cb0[8].y ? cb0[7].x : cb0[6].x) * old_lum + (old_lum > cb0[8].y ? cb0[7].z : cb0[6].z)
  r1.z = r1.z / r1.w;
  // ___ + (old_lum > cb0[8].y ? cb0[8].x : 0)
  r1.y = r1.z + r1.y;
  // old_lum / cb0[10].x
  r1.z = r1.x / cb0[10].x;
  // 1 + (old_lum / cb0[10].x)
  r1.z = 1 + r1.z;
  // ___ * (1 + (old_lum / cb0[10].x))
  r1.y = r1.y * r1.z;
  // new_lum / old_lum
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
  config.type = min(3, RENODX_TONE_MAP_TYPE);
  config.peak_nits = RENODX_PEAK_WHITE_NITS;
  config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  config.gamma_correction = RENODX_GAMMA_CORRECTION;
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  //config.saturation = RENODX_TONE_MAP_SATURATION;
  //config.reno_drt_dechroma = injectedData.toneMapPerChannel != 1.f ? RENODX_TONE_MAP_BLOWOUT : max(0.00001f, RENODX_TONE_MAP_BLOWOUT);
  //config.reno_drt_blowout = 1.f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  //config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  //config.hue_correction_type = injectedData.toneMapPerChannel != 1.f ? renodx::tonemap::config::hue_correction_type::INPUT
  //                                                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  //config.hue_correction_strength = injectedData.toneMapHueCorrection;
  //config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  //config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = RENODX_TONE_MAP_TYPE == 3.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  //config.reno_drt_per_channel = injectedData.toneMapPerChannel != 1.f;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_white_clip = RENODX_RENO_DRT_WHITE_CLIP == 0.f ? 5.f : RENODX_RENO_DRT_WHITE_CLIP;
  if (config.type == 0.f) {
    r0.xyz = saturate(hueCorrectionColor);
  }
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  o0.xyzw = cb0[9].xyzw * r0.xyzw;
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}