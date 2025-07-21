#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -abs(v2.xy) * abs(v2.xy) + float2(1,1);
  r0.x = saturate(-r0.x * r0.y + 1);
  r0.x = cb0[2].x * r0.x;
  r0.x = cb0[0].w * r0.x;
  r0.y = t0.SampleLevel(s0_s, v1.xy, 0).x;
  r0.z = t0.SampleLevel(s0_s, v1.zw, 0).z;
  r1.xyzw = t0.SampleLevel(s0_s, v2.zw, 0).xyzw;
  r0.yz = -r1.xz + r0.yz;
  r1.xz = r0.xx * r0.yz + r1.xz;
  o0.w = r1.w;
  r0.x = renodx::color::y::from::BT709(r1.xyz);
  r0.yzw = r0.xxx + -r1.xyz;
  r0.x = saturate(r0.x * cb0[0].y + cb0[0].z);
  r0.x = cb0[0].x * r0.x;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  r0.w = dot(r0.xyz, cb0[1].xyz);
  r0.xyz = r0.xyz * cb0[1].www + r0.www;
  if (injectedData.toneMapType == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  r0.w = saturate(dot(r0.xyz, cb0[3].xyz));
  r1.xyz = cb0[5].xyz * r0.www;
  r2.xyz = r0.xyz * cb0[6].xyz + -r1.xyz;
  r0.w = saturate(dot(r0.xyz, cb0[4].xyz));
  r1.xyz = r0.www * r2.xyz + r1.xyz;
  if (injectedData.toneMapType == 0.f) {
    r1.xyz = saturate(r1.xyz);
  }
  r0.xyz = r0.xyz * cb0[5].www + r1.xyz;
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
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.rgb, renodx::tonemap::renodrt::NeutralSDR(r0.rgb), injectedData.toneMapHueShift);
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_hue_correction_method = (int)injectedData.toneMapHueProcessor;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  if (config.type == 0.f) {
    r0.rgb = saturate(r0.rgb);
  }
  if (injectedData.colorGradeLUTStrength == 0.f || config.type == 1.f) {
    if (config.type == 2.f) {
      r0.rgb = applyFrostbite(r0.rgb, config);
    } else if (config.type == 5.f) {
      r0.rgb = applyDICE(r0.rgb, config);
    } else {
      r0.rgb = renodx::tonemap::config::Apply(r0.rgb, config);
    }
  } else {
    float3 sdrColor;
    float3 hdrColor;
    if (config.type == 2.f) {
      sdrColor = applyFrostbite(r0.rgb, config, true);
      hdrColor = applyFrostbite(r0.rgb, config);
    } else if (config.type == 5.f) {
      sdrColor = applyDICE(r0.rgb, config, true);
      hdrColor = applyDICE(r0.rgb, config);
    } else {
      renodx::tonemap::config::DualToneMap tone_maps = renodx::tonemap::config::ApplyToneMaps(r0.rgb, config);
      sdrColor = tone_maps.color_sdr;
      hdrColor = tone_maps.color_hdr;
    }
    r0.rgb = renodx::color::gamma::EncodeSafe(max(0.f, sdrColor), 2.2f);
  r0.xyz = r0.xyz * float3(0.99609375,0.99609375,0.99609375) + float3(0.001953125,0.001953125,0.001953125);
  r1.x = t2.Sample(s2_s, r0.xx).x;
  r1.y = t2.Sample(s2_s, r0.yy).y;
  r1.z = t2.Sample(s2_s, r0.zz).z;
  r0.xyz = renodx::color::gamma::DecodeSafe(r1.xyz, 2.2f);
  r0.rgb = RestoreSaturationLoss(sdrColor, r0.rgb, injectedData.colorGradeLUTScaling);
  if (config.type == 0.f) {
    r0.rgb = lerp(sdrColor, r0.rgb, injectedData.colorGradeLUTStrength);
  } else {
    r0.rgb = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, r0.rgb, injectedData.colorGradeLUTStrength);
  }
  }
  r1.xyz = t1.SampleLevel(s1_s, v2.zw, 0).xyz;
  o0.xyz = r1.xyz * r0.xyz;
  return;
}