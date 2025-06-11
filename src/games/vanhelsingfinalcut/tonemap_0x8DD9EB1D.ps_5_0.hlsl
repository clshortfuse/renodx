#include "./common.hlsl"

cbuffer _Globals : register(b0){
  float _g_fBrightness : packoffset(c0);
  float _g_fContrast : packoffset(c1);
  float _g_fGamma : packoffset(c2);
  float2 _g_vToneCurveTransform : packoffset(c3);
  float _g_fSaturation : packoffset(c4);
  float _g_fPProgress : packoffset(c5);
}
SamplerState _g_sSceneTexLinearClamp_s : register(s0);
SamplerState _g_sToneCurve_s : register(s1);
Texture2D<float4> _TMP60 : register(t0);
Texture1D<float4> _TMP61 : register(t1);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = rsqrt(r0.x);
  r0.x = 1 / r0.x;
  r0.x = -r0.x * 0.707106769 + 1;
  r0.x = log2(r0.x);
  r0.x = 2.5 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = 1 + -r0.x;
  r0.y = r0.x * r0.x;
  r0.y = r0.y * r0.y;
  r0.x = -r0.x * r0.y + 1;
  r0.x = r0.x * 0.8 + 0.2;
  r0.x = 1 + -r0.x;
  r0.x = _g_fPProgress * r0.x;
  r0.gba = applyCA(_TMP60, _g_sSceneTexLinearClamp_s, v1.xy, injectedData.fxCA);
  r1.x = dot(r0.yzw, float3(0.5,0.5,0.5));
  r1.yz = float2(0.05,0.05) * r0.zw;
  r1.xyz = r1.xyz + -r0.yzw;
  r1.xyz = _g_fPProgress * r1.xyz + r0.yzw;
  r1.xyz = r0.xxx * float3(0.2,-0.1,-0.1) + r1.xyz;
  r0.xyz = (_g_fPProgress > 0) ? r1.xyz : r0.yzw;
  r0.rgb = applyVignette(r0.rgb, v1, injectedData.fxVignette);

  float midGray = vanillaTonemap(float3(0.18f, 0.18f, 0.18f)).x;
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
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.rgb, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  if (config.type == 0.f) {
    r0.xyz = saturate(hueCorrectionColor);
  }
  if (injectedData.colorGradeLUTStrength == 0.f || config.type == 1.f) {
    if (injectedData.toneMapType == 2.f) {
      r0.rgb = applyFrostbite(r0.rgb, config);
    } else if (injectedData.toneMapType == 5.f) {
      r0.rgb = applyDICE(r0.rgb, config);
    } else {
      config.peak_nits = 10000.f;
      config.gamma_correction = 0.f;
      r0.rgb = renodx::tonemap::config::Apply(r0.rgb, config);
    }
  } else {
    float3 sdrColor;
    float3 hdrColor;
    if (injectedData.toneMapType == 2.f) {
      sdrColor = applyFrostbite(r0.rgb, config, true);
      hdrColor = applyFrostbite(r0.rgb, config);
    } else if (injectedData.toneMapType == 5.f) {
      sdrColor = applyDICE(r0.rgb, config, true);
      hdrColor = applyDICE(r0.rgb, config);
    } else {
      config.peak_nits = 10000.f;
      config.gamma_correction = 0.f;
      renodx::tonemap::config::DualToneMap tone_maps = renodx::tonemap::config::ApplyToneMaps(r0.rgb, config);
      sdrColor = tone_maps.color_sdr;
      hdrColor = tone_maps.color_hdr;
    }
  r0.rgb = renodx::color::gamma::EncodeSafe(sdrColor, 2.2f);
  r1.w = dot(r0.xyz, float3(0.333333343,0.333333343,0.333333343));
  r1.xyz = r0.xyz;
  r0.xyzw = -_g_vToneCurveTransform.xxxx + r1.xyzw;
  r0.xyzw = r0.xyzw / _g_vToneCurveTransform.yyyy;
  r1.x = _TMP61.SampleLevel(_g_sToneCurve_s, r0.x, 0).w;
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r1.xxx * r0.xyz + r0.www;
  o0.w = r0.w;
  r0.x = _TMP61.SampleLevel(_g_sToneCurve_s, r0.x, 0).x;
  r0.x = max(0.0009765625, r0.x);
  r1.x = r0.x;
  r0.x = _TMP61.SampleLevel(_g_sToneCurve_s, r0.y, 0).y;
  r0.y = _TMP61.SampleLevel(_g_sToneCurve_s, r0.z, 0).z;
  r0.xy = max(float2(0.0009765625,0.0009765625), r0.xy);
  r1.z = r0.y;
  r1.y = r0.x;
  r0.xyz = renodx::color::gamma::DecodeSafe(r1.xyz, 2.2f);
  if (injectedData.colorGradeLUTScaling > 0.f) {
    float4 temp;
    float4 scalingInput = float4(0,0,0,0) -_g_vToneCurveTransform.xxxx;
    scalingInput /= _g_vToneCurveTransform.yyyy;
    r1.x = _TMP61.SampleLevel(_g_sToneCurve_s, scalingInput.x, 0).w;
    temp.xyz = lerp(scalingInput.www, scalingInput.xyz, r1.x);
    temp.x = _TMP61.SampleLevel(_g_sToneCurve_s, temp.x, 0).x;
    temp.x = max(0.0009765625, temp.x);
    r1.x = temp.x;
    temp.x = _TMP61.SampleLevel(_g_sToneCurve_s, temp.y, 0).y;
    temp.y = _TMP61.SampleLevel(_g_sToneCurve_s, temp.z, 0).z;
    temp.xy = max(float2(0.0009765625, 0.0009765625), temp.xy);
    r1.z = temp.y;
    r1.y = temp.x;
    float3 minBlack = renodx::color::gamma::DecodeSafe(r1.xyz, 2.2f);
    float lutMinY = renodx::color::y::from::BT709(abs(minBlack));
    if (lutMinY > 0) {
      float3 correctedBlack = renodx::lut::CorrectBlack(sdrColor, r0.rgb, lutMinY, 0.f);
      r0.rgb = lerp(r0.rgb, correctedBlack, injectedData.colorGradeLUTScaling);
    }
    r0.rgb = RestoreSaturationLoss(sdrColor, r0.rgb, injectedData.colorGradeLUTScaling);
  }
    if (config.type == 0.f) {
    r0.rgb = lerp(sdrColor, r0.rgb, injectedData.colorGradeLUTStrength);
  } else {
    r0.rgb = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, r0.rgb, injectedData.colorGradeLUTStrength);
  }
  }
  if (injectedData.is_swapchain_write) {
    if (injectedData.fxFilmGrain > 0.f) {
      r0.rgb = applyFilmGrain(r0.rgb, v1, injectedData.fxFilmGrainType != 0.f);
    }
    r0.rgb = PostToneMapScale(r0.rgb);
  } else {
    r0.rgb = renodx::color::gamma::EncodeSafe(r0.rgb, 2.2f);
  }
  o0.rgb = r0.rgb;
  return;
}