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

// // Gamma 2.2 color in, returns coordinates for sampling
// lutsampling VanillaSamplingCoords(float3 color) {
//   // //  float _22 = abs(_17.x);
//   // //  float _23 = abs(_17.y);
//   // //  float _24 = abs(_17.z);
//   // //  float _25 = log2(_22);
//   // //  float _26 = log2(_23);
//   // //  float _27 = log2(_24);
//   // //  float _28 = _25 * 0.4545454680919647f;
//   // //  float _29 = _26 * 0.4545454680919647f;
//   // //  float _30 = _27 * 0.4545454680919647f;
//   // //  float _31 = exp2(_28);
//   // //  float _32 = exp2(_29);
//   // //  float _33 = exp2(_30);
//   float _31 = color.x;
//   float _32 = color.y;
//   float _33 = color.z;

//   float _34 = _33 * 0.99609375f;
//   float _35 = _33 * 63.75f;
//   float _36 = floor(_35);
//   float _37 = _36 * 0.015625f;
//   float _38 = _34 + 0.015625f;
//   float _39 = _35 - _36;
//   float _40 = saturate(_31);
//   float _41 = saturate(_32);
//   float _42 = saturate(_38);
//   float _43 = min(0.9999899864196777f, _42);
//   float _44 = _40 + 0.0078125f;
//   float _45 = _41 + 0.0078125f;
//   float _46 = _44 * 0.99609375f;
//   float _47 = _45 * 0.99609375f;
//   float _48 = max(_46, 0.015625f);
//   float _49 = max(_47, 0.015625f);
//   float _50 = min(_48, 0.984375f);
//   float _51 = min(_49, 0.984375f);
//   float _52 = _43 * 64.0f;
//   float _53 = _43 * 8.0f;
//   float _54 = floor(_53);
//   float _55 = _54 * 8.0f;
//   float _56 = _52 - _55;
//   float _57 = floor(_56);
//   float _58 = _57 + _50;
//   float _59 = _58 * 0.125f;
//   float _60 = _54 + _51;
//   float _61 = _60 * 0.125f;

//  // float4 _62 = t1.SampleLevel(s1, float2(_59, _61), 0.0f);

//   float _66 = saturate(_37);
//   float _67 = min(0.9999899864196777f, _66);
//   float _68 = _67 * 64.0f;
//   float _69 = _67 * 8.0f;
//   float _70 = floor(_69);
//   float _71 = _70 * 8.0f;
//   float _72 = _68 - _71;
//   float _73 = floor(_72);
//   float _74 = _73 + _50;
//   float _75 = _74 * 0.125f;
//   float _76 = _70 + _51;
//   float _77 = _76 * 0.125f;
//   //float4 _78 = t1.SampleLevel(s1, float2(_75, _77), 0.0f);

//   lutsampling value;
//   value.lerp_t = _39;
//   value.coords1 = float2(_59, _61);
//   value.coords2 = float2(_75, _77);
//   return value;
// }

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
  return ((lut_sampled_sdr1.xyz + ungraded_sdr.xyz) + (((CustomPixelConsts_032.z * lut_sampled_sdr2.xyz) - ungraded_sdr.xyz) * CustomPixelConsts_032.y - lut_sampled_sdr1.xyz) * CustomPixelConsts_032.w);
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

// // Second LUT Sample in grading2
// float3 VanillaSamplingT2(float4 color, Texture2D<float4> lut, SamplerState sampler) {
// }

// // Second LUT Sample in grading3
// float3 VanillaSamplingT3(float4 color, Texture2D<float4> lut, SamplerState sampler) {

// }

// float3 VanillaSampling(float4 color, Texture2D<float4> lut, SamplerState sampler, uint type) {
//   if (type == 1) return VanillaSamplingG1(color, lut, sampler);
//   if (type == 2) return VanillaSamplingT2(color, lut, sampler);
//   return VanillaSamplingT3(color, lut, sampler);
// }

// #define SAMPLE_FUNCTION_GENERATOR(textureType)                                                 \
//   float3 CustomSample(textureType lut_texture, Config lut_config, float3 color_input, uint type) {              \
//     float3 lutInputColor = ConvertInput(color_input, lut_config);                              \
//     float3 lutOutputColor = VanillaSampling(color_input, )               \
//     float3 color_output = LinearOutput(lutOutputColor, lut_config);                            \
//     [branch]                                                                                   \
//     if (lut_config.scaling != 0.f) {                                                           \
//       float3 lutBlack = SampleColor(ConvertInput(0, lut_config), lut_config, lut_texture);     \
//       float3 lutMid = SampleColor(ConvertInput(0.18f, lut_config), lut_config, lut_texture);   \
//       float3 lutWhite = SampleColor(ConvertInput(1.f, lut_config), lut_config, lut_texture);   \
//       float3 unclamped_gamma = Unclamp(                                                        \
//           GammaOutput(lutOutputColor, lut_config),                                             \
//           GammaOutput(lutBlack, lut_config),                                                   \
//           GammaOutput(lutMid, lut_config),                                                     \
//           GammaOutput(lutWhite, lut_config),                                                   \
//           GammaInput(color_input, lutInputColor, lut_config));                                 \
//       float3 unclamped_linear = LinearUnclampedOutput(unclamped_gamma, lut_config);            \
//       float3 recolored = RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling); \
//       color_output = recolored;                                                                \
//     } else {                                                                                   \
//     }                                                                                          \
//     if (lut_config.recolor != 0.f) {                                                           \
//       color_output = RestoreSaturationLoss(color_input, color_output, lut_config);             \
//     }                                                                                          \
//                                                                                                \
//     return lerp(color_input, color_output, lut_config.strength);                               \
//   }

// SAMPLE_FUNCTION_GENERATOR(Texture3D<float4>);
// SAMPLE_FUNCTION_GENERATOR(Texture3D<float3>);
// SAMPLE_FUNCTION_GENERATOR(Texture2D<float4>);
// SAMPLE_FUNCTION_GENERATOR(Texture2D<float3>);

// #undef SAMPLE_FUNCTION_GENERATOR