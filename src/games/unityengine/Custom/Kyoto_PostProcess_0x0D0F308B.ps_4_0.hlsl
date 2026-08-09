#include "../common.hlsl"

cbuffer _Globals : register(b0){
  float4 unity_ColorSpaceGrey : packoffset(c0);
  float4 unity_ColorSpaceDouble : packoffset(c1);
  float4 unity_ColorSpaceDielectricSpec : packoffset(c2);
  float4 unity_ColorSpaceLuminance : packoffset(c3);
  float4 unity_Lightmap_HDR : packoffset(c4);
  float4 unity_DynamicLightmap_HDR : packoffset(c5);
  float _WhiteLevel : packoffset(c6);
  float _MidLevel : packoffset(c6.y);
  float _GrayLevel : packoffset(c6.z);
  float _BlackLevel : packoffset(c6.w);
  float _ExposureAdjustment : packoffset(c7);
  float4 _OffsetInfos : packoffset(c8);
  float _BloomIntensity : packoffset(c9);
  float _FlareIntensity : packoffset(c9.y);
  float _FlareBlendUp : packoffset(c9.z);
  float _FlareBlendDown : packoffset(c9.w);
  float2 _FringeIntensity : packoffset(c10);
  float _MaxValue : packoffset(c10.z);
  float _TemporalRatio : packoffset(c10.w);
  float4 _TemporalOffset : packoffset(c11);
  float4x4 _ToPrevViewProjCombined : packoffset(c12);
  float4 _CameraDepthTexture_TexelSize : packoffset(c16);
  float4 _Toe : packoffset(c17);
  float4 _Shoulder : packoffset(c18);
  float _K : packoffset(c19);
  float _Crossover : packoffset(c19.y);
  float _DirtIntensity : packoffset(c19.z);
  float _DirtLightIntensity : packoffset(c19.w);
}

SamplerState _MainTex_s : register(s0);
SamplerState _AdditiveTexture_s : register(s1);
SamplerState _DirtTexture_s : register(s2);
SamplerState _TonemappingLut_s : register(s3);
Texture2D<float4> _MainTex : register(t0);
Texture2D<float4> _AdditiveTexture : register(t1);
Texture2D<float4> _DirtTexture : register(t2);
Texture2D<float4> _TonemappingLut : register(t3);

float3 vanillaReinhard(float3 x){
  return (x / (1 + x)) * 1.05f;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = _DirtTexture.Sample(_DirtTexture_s, v1.xy).xyzw;
  r1.xyzw = _AdditiveTexture.Sample(_AdditiveTexture_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = _DirtLightIntensity * r0.xyz;
  r1.xyz = r1.xyz * _BloomIntensity * injectedData.fxBloom + r0.xyz;
  r0.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r0.xyzw = _FringeIntensity.xxyy * r0.xyzw;
  r0.xyzw = r0.xyzw * float4(0.5,0.5,0.5,0.5) + float4(0.5,0.5,0.5,0.5);
  r2.xyzw = _MainTex.Sample(_MainTex_s, r0.xy).xyzw;
  r0.xyzw = _MainTex.Sample(_MainTex_s, r0.zw).xyzw;
  r2.y = r0.y;
  r0.xyzw = _MainTex.Sample(_MainTex_s, v1.xy).xyzw;
  r2.zw = r0.zw;
  r0.xyzw = r2.xyzw * _ExposureAdjustment + r1.xyzw;
  o0.w = r0.w;
  float midGray = vanillaReinhard(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaReinhard(r0.xyz);
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
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 3.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 20.f : injectedData.colorGradeClip;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(hueCorrectionColor);
  }
  if (injectedData.colorGradeUserLUTStrength == 0.f || config.type == 1.f) {
    o0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  } else {
    renodx::tonemap::config::DualToneMap tone_maps = renodx::tonemap::config::ApplyToneMaps(r0.xyz, config);
    float3 sdrColor = tone_maps.color_sdr;
    float3 hdrColor = tone_maps.color_hdr;
    float max_channel = 1.f;
    float min_channel = 0.f;
    float gamut_compression_scale = 1.f;
    max_channel = renodx::math::Max(sdrColor.r, sdrColor.g, sdrColor.b, 1.f);
    min_channel = renodx::math::Min(sdrColor.r, sdrColor.g, sdrColor.b, 0.f);
    max_channel = max(max_channel, -min_channel);
    r0.xyz = sdrColor / max_channel;
      const float MID_GRAY_LINEAR = 1 / (pow(10, 0.75));                                
      const float MID_GRAY_PERCENT = 0.5f;                                           
      const float MID_GRAY_GAMMA = log(MID_GRAY_LINEAR) / log(MID_GRAY_PERCENT);     
      float encode_gamma = MID_GRAY_GAMMA;                                           
    float grayscale = renodx::color::y::from::BT709(r0.xyz);
    float3 gamma_color = renodx::color::gamma::EncodeSafe(r0.xyz, encode_gamma);
    float encoded_gray = renodx::color::gamma::Encode(grayscale, encode_gamma);
    gamut_compression_scale = renodx::color::correct::ComputeGamutCompressionScale(gamma_color.rgb, encoded_gray);
    gamma_color = renodx::color::correct::GamutCompress(gamma_color.rgb, encoded_gray, gamut_compression_scale);
  r0.xyz = renodx::color::gamma::DecodeSafe(gamma_color, encode_gamma);
  r0.w = 0.5;
  r1.xyzw = _TonemappingLut.Sample(_TonemappingLut_s, r0.xw).xyzw;
  o0.x = r1.x;
  r1.xyzw = _TonemappingLut.Sample(_TonemappingLut_s, r0.yw).xyzw;
  r0.xyzw = _TonemappingLut.Sample(_TonemappingLut_s, r0.zw).xyzw;
  o0.z = r0.z;
  o0.y = r1.y;
    o0.xyz = renodx::color::gamma::EncodeSafe(o0.xyz, encode_gamma);
    o0.xyz = renodx::color::correct::GamutDecompress(o0.xyz, gamut_compression_scale);
    o0.xyz = renodx::color::gamma::DecodeSafe(o0.xyz, encode_gamma);
    o0.xyz *= max_channel;
    if (config.type == 0.f) {
      o0.xyz = lerp(sdrColor, o0.xyz, injectedData.colorGradeUserLUTStrength);
    } else {
      o0.xyz = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, o0.xyz, injectedData.colorGradeUserLUTStrength);
    }
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}