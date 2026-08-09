#include "../common.hlsl"

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[2];
}
cbuffer cb1 : register(b1){
  float4 cb1[2];
}
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

float3 vanillaUC2(float3 x){
  return renodx::tonemap::ApplyCurve(x, cb2[0].x, cb2[0].y, cb2[0].z, cb2[0].w, cb2[1].x, cb2[1].y)
         / renodx::tonemap::ApplyCurve(20.f, cb2[0].x, cb2[0].y, cb2[0].z, cb2[0].w, cb2[1].x, cb2[1].y);
}

float3 weirdLutSample(float3 color, renodx::lut::Config lut_config){
float4 r0, r1, r2;
    float3 sampled_color;
    float max_channel = 1.f;
    float gamut_compression_scale = 1.f;
    if (lut_config.max_channel > 0.f) {
      max_channel = renodx::math::Max(color.r, color.g, color.b, 1.f);
      color /= max_channel;
    }
    if (lut_config.gamut_compress > 1.f) {
      float grayscale = renodx::color::y::from::BT709(color.rgb);
      gamut_compression_scale = renodx::color::correct::ComputeGamutCompressionScale(color.rgb, grayscale);
      color = renodx::color::correct::GamutCompress(color, grayscale, gamut_compression_scale);
    }
  r0.xyz = color;
  r0.y = 1 + -r0.y;
  r1.z = r0.y * 0.9375 + 0.03125;
  r0.x = r0.x * 0.05859375 + 0.001953125;
  r0.y = 15 * r0.z;
  r0.z = floor(r0.y);
  r0.y = frac(r0.y);
  r0.w = 1 + r0.z;
  r1.y = r0.z * 0.0625 + r0.x;
  r1.x = r0.w * 0.0625 + r0.x;
  r2.xyzw = t7.SampleLevel(s7_s, r1.xz, 0).xyzw;
  r1.xyzw = t7.SampleLevel(s7_s, r1.yz, 0).xyzw;
  r0.xzw = r2.xyz + -r1.xyz;
  sampled_color = r0.yyy * r0.xzw + r1.xyz;
    if (lut_config.gamut_compress > 1.f) {
      sampled_color = renodx::color::correct::GamutDecompress(sampled_color, gamut_compression_scale);
    }
    return sampled_color * max_channel;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * float3(2,2,2) + r0.xyz;
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * float3(3,3,3) + r0.xyz;
  r1.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * float3(2,2,2) + r0.xyz;
  r1.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = t5.Sample(s5_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * float3(0.5,0.5,0.5) + r0.xyz;
  r0.xyz = float3(0.105263159,0.105263159,0.105263159) * r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(float3(10,10,10), r0.xyz);
  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r1.xy = float2(1.5,1.5) * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = r0.w * r0.w;
  r0.w = r0.w * r0.w + -1;
  r0.w = r0.w * 0.5 + 1;
  r0.xyz = r0.www * r0.xyz;
  r1.xyzw = t6.Sample(s6_s, float2(0.5,0.5)).xyzw;
  r0.w = dot(cb0[0].xx, r1.ww);
  r0.xyz = r0.www * r0.xyz;
  float midGray = vanillaUC2(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaUC2(r1.xyz);
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
  config.reno_drt_contrast = 1.45f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r1.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 3.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 20.f : injectedData.colorGradeClip;
  if(injectedData.toneMapType == 0.f){
    r1.xyz = saturate(hueCorrectionColor);
  }
  r1.xyz = renodx::tonemap::config::Apply(r1.xyz, config);
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[0].www + float3(0.5,0.5,0.5);
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.strength = injectedData.colorGradeUserLUTStrength;
  lut_config.scaling = injectedData.colorGradeUserLUTScaling;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;
  lut_config.max_channel = injectedData.toneMapType == 0.f ? 0.f : 1.f;
  lut_config.gamut_compress = injectedData.toneMapType == 0.f ? 0.f : 1.f;
    float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(r0.xyz);
    float3 lutLinearInput = injectedData.toneMapType == 0.f ? saturate(r0.xyz) : sdrColor;
    float3 lutInputColor = fastSrgbEncodeSafe(lutLinearInput);
    float3 lutOutputColor = weirdLutSample(lutInputColor, lut_config);
    float3 color_output = fastSrgbDecodeSafe(lutOutputColor);
    [branch]
    if (injectedData.colorGradeUserLUTScaling != 0.f) {
      float3 lutBlack = weirdLutSample(fastSrgbEncode(0), lut_config);
      float3 lutMid = weirdLutSample(fastSrgbEncode(0.18f), lut_config);
      float3 lutWhite = weirdLutSample(fastSrgbEncode(1.f), lut_config);
      float3 unclamped_gamma = renodx::lut::Unclamp(
          lutOutputColor,
          lutBlack,
          lutMid,
          lutWhite,
          lutInputColor);
      float3 unclamped_linear = fastSrgbDecodeSafe(unclamped_gamma);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    } else {
    }
    if (lut_config.recolor != 0.f) {
      color_output = renodx::lut::RestoreSaturationLoss(lutLinearInput, color_output, lut_config);
    }
    [branch]
    if(injectedData.toneMapType == 0.f){
    r0.xyz = lerp(r0.xyz, color_output, lut_config.strength);
    } else {
    r0.xyz = renodx::tonemap::UpgradeToneMap(r0.xyz, lutLinearInput, color_output, injectedData.colorGradeUserLUTStrength);
    }
  r0.xyz = cb0[0].zzz * r0.xyz;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[0].yyy * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, cb0[0].y);
  }
  r1.xyz = cb1[1].xyz + -r0.xyz;
  o0.xyz = cb1[1].www * r1.xyz + r0.xyz;
  o0.w = 1;
  o0.xyz = PostToneMapScale(o0.xyz);
  return;
}