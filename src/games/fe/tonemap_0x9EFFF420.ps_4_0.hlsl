#include "./common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s2_s, v1.xy).xyzw;
  r0.x = cb0[8].y / r0.x;
  r0.x = min(cb0[8].w, r0.x);
  r0.x = max(cb0[8].z, r0.x);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.yzw = r1.zxy * float3(0.305306011,0.305306011,0.305306011) + float3(0.682171111,0.682171111,0.682171111);
  r0.yzw = r1.zxy * r0.yzw + float3(0.012522878,0.012522878,0.012522878);
  r0.yzw = r1.zxy * r0.yzw;
  o0.w = r1.w;
  r0.xyz = r0.yzw * r0.xxx;
  r0.xyz = cb0[3].xxx * r0.xyz;
  r0.rgb = renodx::color::bt709::clamp::BT2020(r0.gbr);
  float midGray = renodx::color::y::from::BT709(vanillaTonemap(float3(0.18f, 0.18f, 0.18f)));
  float3 hueCorrectionColor = vanillaTonemap(r0.rgb);
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
  config.reno_drt_shadows = 0.95f;
  config.reno_drt_contrast = 1.45f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapPerChannel != 0.f ? (1.f - injectedData.toneMapHueCorrection)
                                              : injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.rgb, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  if (config.type == 0.f) {
    r0.rgb = saturate(hueCorrectionColor);
  }
  if (injectedData.colorGradeLUTStrength == 0.f || config.type == 1.f) {
    r0.rgb = renodx::tonemap::config::Apply(r0.rgb, config);
  } else {
    renodx::tonemap::config::DualToneMap tone_maps = renodx::tonemap::config::ApplyToneMaps(r0.rgb, config);
    float3 sdrColor = tone_maps.color_sdr;
    float3 hdrColor = tone_maps.color_hdr;
    r0.gbr = sdrColor;
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.yzw = cb0[6].zzz * r0.xyz;
  r1.xy = float2(0.5,0.5) * cb0[6].xy;
  r1.yz = r0.zw * cb0[6].xy + r1.xy;
  r0.y = floor(r0.y);
  r1.x = r0.y * cb0[6].y + r1.y;
  r0.x = r0.x * cb0[6].z + -r0.y;
  r2.x = cb0[6].y;
  r2.y = 0;
  r0.yz = r2.xy + r1.xz;
  r1.xyzw = t2.Sample(s1_s, r1.xz).xyzw;
  r2.xyzw = t2.Sample(s1_s, r0.yz).xyzw;
  r0.yzw = r2.xyz + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  } else {
    r0.rgb = renodx::lut::SampleTetrahedral(t2, r0.gbr, cb0[6].z + 1u);
  }
  if (injectedData.colorGradeLUTScaling > 0.f) {
    float3 minBlack = renodx::lut::Sample(t2, s1_s, float3(0, 0, 0), cb0[6].xyz);
    float lutMinY = renodx::color::y::from::BT709(abs(minBlack));
    if (lutMinY > 0) {
      float3 correctedBlack = renodx::lut::CorrectBlack(sdrColor, r0.rgb, lutMinY, 0.f);
      r0.rgb = lerp(r0.rgb, correctedBlack, injectedData.colorGradeLUTScaling);
    }
  }
  if (config.type == 0.f) {
    r0.rgb = lerp(sdrColor, r0.rgb, injectedData.colorGradeLUTStrength);
  } else {
    r0.rgb = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, r0.rgb, injectedData.colorGradeLUTStrength);
  }
  }
  o0.xyz = renodx::color::srgb::EncodeSafe(r0.rgb);
  return;
}