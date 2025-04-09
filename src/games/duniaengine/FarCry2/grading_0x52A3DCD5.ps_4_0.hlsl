#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_Position0,
  linear centroid float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r0.w;
  if (injectedData.toneMapType == 0.f) {
    r0.rgb = saturate(r0.rgb);
  }
  r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_nits = 19.f;
  config.reno_drt_contrast = 1.04f;
  config.reno_drt_saturation = 1.05f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.005f * pow(injectedData.colorGradeFlare, 7.32192809489);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapPerChannel != 0.f
                                       ? (1.f - injectedData.toneMapHueCorrection)
                                       : injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.rgb, renodx::tonemap::renodrt::NeutralSDR(r0.rgb), injectedData.toneMapHueShift);
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  if (injectedData.colorGradeLUTStrength == 0.f || config.type == 1.f) {
    if (config.type == 2.f) {
      r0.rgb = applyFrostbite(r0.rgb, config);
    } else if (config.type == 4.f) {
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
    } else if (config.type == 4.f) {
      sdrColor = applyDICE(r0.rgb, config, true);
      hdrColor = applyDICE(r0.rgb, config);
    } else {
      renodx::tonemap::config::DualToneMap tone_maps = renodx::tonemap::config::ApplyToneMaps(r0.rgb, config);
      sdrColor = tone_maps.color_sdr;
      hdrColor = tone_maps.color_hdr;
    }
    r0.rgb = renodx::color::srgb::Encode(max(0, sdrColor));

  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[6].yzw * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * cb0[7].xxx + cb0[7].yyy;
  r1.xyz = r0.xyz * r1.xyz + cb0[7].zzz;
  r2.xyz = r1.xyz * r0.xyz;
  r0.w = dot(float3(0.308600008,0.609399974,0.0820000023), r2.xyz);
  r0.xyz = r1.xyz * r0.xyz + -r0.www;
  r0.xyz = cb0[6].xxx * r0.xyz + r0.www;
  r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  if (config.type == 0.f) {
    r0.rgb = lerp(sdrColor, r0.rgb, injectedData.colorGradeLUTStrength);
  } else if (injectedData.upgradePerChannel == 1.f) {
    r0.rgb = RestoreSaturationLoss(sdrColor, r0.rgb);
    r0.rgb = UpgradeToneMapPerChannel(hdrColor, sdrColor, r0.rgb, injectedData.colorGradeLUTStrength);
  } else {
    r0.rgb = RestoreSaturationLoss(sdrColor, r0.rgb);
    r0.rgb = UpgradeToneMapByLuminance(hdrColor, sdrColor, r0.rgb, injectedData.colorGradeLUTStrength);
  }
  }
  if (injectedData.fxFilmGrainType == 1.f) {
    r0.rgb = applyFilmGrain(r0.rgb, v1.xy);
  }
  r0.rgb = PostToneMapScale(r0.rgb);
  o0.xyz = r0.xyz;
  return;
}