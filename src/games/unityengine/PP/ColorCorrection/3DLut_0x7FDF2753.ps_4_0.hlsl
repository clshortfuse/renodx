#include "../../tonemap.hlsl"

Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

float3 weirdLutSample(float3 color, renodx::lut::Config lut_config){
float4 r0,r1;
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
  r1.xyz = r0.xyz * cb0[2].yyy + cb0[2].zzz;
  r1.w = 0.5 * r1.z;
  r0.xyzw = t1.Sample(s1_s, r1.xyw).xyzw;
  r1.xyz = r1.xyz * float3(1,1,0.5) + float3(0,0,0.5);
  r1.xyzw = t1.Sample(s1_s, r1.xyz).xyzw;
  r1.xyz = r1.xyz + -r0.xyz;
  sampled_color = cb0[2].xxx * r1.xyz + r0.xyz;
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
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r0.w;
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.strength = injectedData.colorGradeUserLUTStrength;
  lut_config.scaling = injectedData.colorGradeUserLUTScaling;
  if(injectedData.gammaSpace != 0.f){
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  } else {
  lut_config.type_input = renodx::lut::config::type::LINEAR;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  }
  lut_config.recolor = 0.f;
  lut_config.max_channel = injectedData.toneMapType == 0.f ? 0.f : 1.f;
  lut_config.gamut_compress = injectedData.toneMapType == 0.f ? 0.f : 1.f;
  int encoding = injectedData.gammaSpace != 0.f ? 0 : 2;
    float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(r0.xyz);
    float3 lutLinearInput = injectedData.toneMapType == 0.f ? saturate(r0.xyz) : sdrColor;
    float3 lutInputColor = ConvertInput(lutLinearInput, encoding);
    float3 lutOutputColor = weirdLutSample(lutInputColor, lut_config);
    float3 color_output = LinearOutput(lutOutputColor, encoding);
    [branch]
    if (injectedData.colorGradeUserLUTScaling != 0.f) {
      float3 lutBlack = weirdLutSample(ConvertInput(0, encoding), lut_config);
      float3 lutMid = weirdLutSample(ConvertInput(0.18f, encoding), lut_config);
      float3 lutWhite = weirdLutSample(ConvertInput(1.f, encoding), lut_config);
      float3 unclamped_gamma = renodx::lut::Unclamp(
          GammaOutput(lutOutputColor, encoding),
          GammaOutput(lutBlack, encoding),
          GammaOutput(lutMid, encoding),
          GammaOutput(lutWhite, encoding),
          GammaInput(r0.xyz, lutInputColor, encoding));
      float3 unclamped_linear = LinearUnclampedOutput(unclamped_gamma, encoding);
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
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  /*r1.xyz = r0.xyz * cb0[2].yyy + cb0[2].zzz;
  r1.w = 0.5 * r1.z;
  r0.xyzw = t1.Sample(s1_s, r1.xyw).xyzw;
  r1.xyz = r1.xyz * float3(1,1,0.5) + float3(0,0,0.5);
  r1.xyzw = t1.Sample(s1_s, r1.xyz).xyzw;
  r1.xyz = r1.xyz + -r0.xyz;
  o0.xyz = cb0[2].xxx * r1.xyz + r0.xyz;*/
  return;
}