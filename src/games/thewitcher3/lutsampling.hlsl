//#include "./shared.h"
#include "./common.hlsl"

// This is needed because they use unwrapped 3D LUTs
// I need to rework renodx LUT sampling to function with their weird sampling code

cbuffer cb3 : register(b3) {
  float4 CustomPixelConsts_000 : packoffset(c000.x);
  float4 CustomPixelConsts_016 : packoffset(c001.x);
  float4 CustomPixelConsts_032 : packoffset(c002.x);
  float4 CustomPixelConsts_048 : packoffset(c003.x);
  float4 CustomPixelConsts_064 : packoffset(c004.x);
  float4 CustomPixelConsts_080 : packoffset(c005.x);
  float4 CustomPixelConsts_096 : packoffset(c006.x);
  float4 CustomPixelConsts_112 : packoffset(c007.x);
  float4 CustomPixelConsts_128 : packoffset(c008.x);
  float4 CustomPixelConsts_144 : packoffset(c009.x);
  float4 CustomPixelConsts_160 : packoffset(c010.x);
  float4 CustomPixelConsts_176 : packoffset(c011.x);
  float4 CustomPixelConsts_192 : packoffset(c012.x);
  float4 CustomPixelConsts_208 : packoffset(c013.x);
  float4 CustomPixelConsts_224 : packoffset(c014.x);
  float4 CustomPixelConsts_240 : packoffset(c015.x);
  float4 CustomPixelConsts_256 : packoffset(c016.x);
  float4 CustomPixelConsts_272 : packoffset(c017.x);
  float4 CustomPixelConsts_288 : packoffset(c018.x);
  float4 CustomPixelConsts_304 : packoffset(c019.x);
  float4 CustomPixelConsts_320 : packoffset(c020.x);
  float4 CustomPixelConsts_336[4] : packoffset(c021.x);
};

struct lutsampling {
  float2 coords1;
  float2 coords2;
  float lerp_t;
};

//using namespace renodx::lut;

// Gamma 2.2 color in, returns coordinates for sampling
lutsampling VanillaSamplingCoords(float3 color) {
  // linear to 2.2
  //color.xyz = renodx::color::gamma::EncodeSafe(color.xyz);
  // float _35 = exp2(log2(abs(color.z)) * 0.4545454680919647f);
  float _35 = color.z;
  float _37 = _35 * 63.75f;
  float _38 = floor(_37);
  float _41 = _37 - _38;

  float _45 = min(0.9999899864196777f, saturate((_35 * 0.99609375f) + 0.015625f));
  float _52 = min(max(((saturate(color.x) + 0.0078125f) * 0.99609375f), 0.015625f), 0.984375f);
  float _53 = min(max(((saturate(color.y) + 0.0078125f) * 0.99609375f), 0.015625f), 0.984375f);

  float _56 = floor(_45 * 8.0f);
  float _61 = (floor((_45 * 64.0f) - (_56 * 8.0f)) + _52) * 0.125f;
  float _63 = (_56 + _53) * 0.125f;
  //float4 _64 = lut.SampleLevel(sampler, float2(_61, _63), 0.0f);
  float _69 = min(0.9999899864196777f, saturate(_38 * 0.015625f));
  float _72 = floor(_69 * 8.0f);
  float _77 = (floor((_69 * 64.0f) - (_72 * 8.0f)) + _52) * 0.125f;
  float _79 = (_72 + _53) * 0.125f;
  // float4 _80 = lut.SampleLevel(sampler, float2(_77, _79), 0.0f);
  lutsampling value;
  value.lerp_t = _41;
  value.coords1 = float2(_61, _63);
  value.coords2 = float2(_77, _79);
  return value;
}

float3 VanillaSampling(float3 color, lutsampling values, Texture2D<float4> lut, SamplerState sampler) {
  float4 _64 = lut.SampleLevel(sampler, values.coords1, 0.0f);
  float4 _80 = lut.SampleLevel(sampler, values.coords2, 0.0f);
  return lerp(_80.xyz, _64.xyz, values.lerp_t);
  //return renodx::color::gamma::DecodeSafe(lerp(_80.xyz, _64.xyz, values.lerp_t));
}

float3 VanillaOutput1(float3 lut_sampled_sdr, float3 ungraded_sdr) {
  return (((CustomPixelConsts_016.z * lut_sampled_sdr.xyz) - ungraded_sdr.xyz) * CustomPixelConsts_016.y) + ungraded_sdr.xyz;
}

float3 VanillaOutput2(float3 lut_sampled_sdr1, float3 lut_sampled_sdr2, float3 ungraded_sdr) {
  return ((CustomPixelConsts_016.z * ((lut_sampled_sdr2.xyz - lut_sampled_sdr1.xyz) * CustomPixelConsts_016.x + lut_sampled_sdr1.xyz) - ungraded_sdr.xyz) * CustomPixelConsts_016.y) + ungraded_sdr.xyz;
}

float3 VanillaOutput3(float3 lut_sampled_sdr1, float3 lut_sampled_sdr2, float3 ungraded_sdr) {
  lut_sampled_sdr1 = ((CustomPixelConsts_016.z * lut_sampled_sdr1) - ungraded_sdr) * CustomPixelConsts_016.y;
  return ((lut_sampled_sdr1.xyz + ungraded_sdr.xyz) + ((((CustomPixelConsts_032.z * lut_sampled_sdr2.xyz) - ungraded_sdr.xyz) * CustomPixelConsts_032.y) - lut_sampled_sdr1.xyz) * CustomPixelConsts_032.w);
}

// First LUT Sample in all grading shaders
// Linear in, linear out
float3 LUTSampling(float3 color, float3 color_coord, Texture2D<float4> lut, SamplerState sampler) {
  float compression_scale;
  float compression_scale_coord;
  if (RENODX_TONE_MAP_TYPE > 1) {
    GamutCompression(color, compression_scale);
    GamutCompression(color_coord, compression_scale_coord);
  }
  else {
    color = abs(color);
    color_coord = abs(color_coord);
  }

  float3 gamma_color = renodx::color::gamma::Encode(color.xyz);
  float3 gamma_color_coord = renodx::color::gamma::Encode(color_coord.xyz);
  lutsampling values = VanillaSamplingCoords(gamma_color_coord);
  float3 outputColor = VanillaSampling(gamma_color, values, lut, sampler);

  if (CUSTOM_LUT_SCALING != 0.f) {
    // float3 lutBlack = SampleColor(ConvertInput(0, lut_config), lut_config, lut_texture);
    float lutBlackGamma = renodx::color::gamma::Encode(0.f);
    lutsampling lutBlackCoords = VanillaSamplingCoords(lutBlackGamma);
    float3 lutBlack = VanillaSampling(lutBlackGamma, lutBlackCoords, lut, sampler);
    // float3 lutMid = SampleColor(ConvertInput(0.18f, lut_config), lut_config, lut_texture);
    float lutMidGamma = renodx::color::gamma::Encode(0.18f);
    lutsampling lutMidCoords = VanillaSamplingCoords(lutMidGamma);
    float3 lutMid = VanillaSampling(lutMidGamma, lutMidCoords, lut, sampler);
    // float3 lutWhite = SampleColor(ConvertInput(1.f, lut_config), lut_config, lut_texture);
    float lutWhiteGamma = renodx::color::gamma::Encode(1.f);
    lutsampling lutWhiteCoords = VanillaSamplingCoords(lutWhiteGamma);
    float3 lutWhite = VanillaSampling(lutWhiteGamma, lutWhiteCoords, lut, sampler);  
      float3 unclamped_gamma = renodx::lut::Unclamp(                                                       
          outputColor,                                             
          lutBlack,                                                   
          lutMid,                                                     
          lutWhite,                                                   
          gamma_color);                                 
      float3 unclamped_linear = renodx::color::gamma::Decode(unclamped_gamma);            
      float3 recolored = renodx::lut::RecolorUnclamped(renodx::color::gamma::Decode(outputColor), unclamped_linear, CUSTOM_LUT_SCALING); 
      outputColor = recolored;
  }
  else {
    //outputColor = abs(outputColor);
    outputColor = renodx::color::gamma::Decode(outputColor);
  }

  if (RENODX_TONE_MAP_TYPE > 1) {
    GamutDecompression(outputColor, compression_scale);
  }

  return outputColor;
}