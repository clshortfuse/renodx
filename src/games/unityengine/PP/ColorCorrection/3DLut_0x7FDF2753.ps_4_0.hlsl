#include "../../common.hlsli"

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
    GamutCompression(color, gamut_compression_scale);
    NeutwoMaxCh(color, max_channel);
  r0.xyz = color;
  r1.xyz = r0.xyz * cb0[2].yyy + cb0[2].zzz;
  r1.w = 0.5 * r1.z;
  r0.xyzw = t1.Sample(s1_s, r1.xyw).xyzw;
  r1.xyz = r1.xyz * float3(1,1,0.5) + float3(0,0,0.5);
  r1.xyzw = t1.Sample(s1_s, r1.xyz).xyzw;
  r1.xyz = r1.xyz + -r0.xyz;
  sampled_color = cb0[2].xxx * r1.xyz + r0.xyz;
  NeutwoMaxChInverse(sampled_color, max_channel);
  GamutDecompression(sampled_color, gamut_compression_scale);
    return sampled_color;   
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
  lut_config.strength = CUSTOM_USER_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_USER_LUT_SCALING;
  if(CUSTOM_GAMMA_SPACE != 0.f){
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  } else {
  lut_config.type_input = renodx::lut::config::type::LINEAR;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  }
  lut_config.recolor = 0.f;
  lut_config.max_channel = 0.f;
  lut_config.gamut_compress = 0.f;
  int encoding = CUSTOM_GAMMA_SPACE != 0.f ? 0 : 2;
  float compression_scale;
  float max_channel_scale;

    float3 lutInputColor = ConvertInput(r0.xyz, encoding);
    float3 lutOutputColor = weirdLutSample(lutInputColor, lut_config);
    float3 color_output = LinearOutput(lutOutputColor, encoding);
    [branch]
    if (CUSTOM_USER_LUT_SCALING != 0.f) {
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
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz, CUSTOM_GAMMA_SPACE != 0.f);
  } else if(CUSTOM_GAMMA_SPACE != 0.f){
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