#include "../../shaders/renodx.hlsl"

// logc c1000 custom encoding
static const float arri_a = renodx::color::arri::logc::c1000::PARAMS.a;
static const float arri_b = renodx::color::arri::logc::c1000::PARAMS.b;
static const float arri_c = renodx::color::arri::logc::c1000::PARAMS.c;
static const float arri_d = renodx::color::arri::logc::c1000::PARAMS.d;

float3 arriDecode(float3 color) {
  return (pow(10.f, (color - arri_d) / arri_c) - arri_b) / arri_a;
}

float3 lutShaper(float3 color, bool builder = false, int type = 0) {
  if (type == 0) {
    [branch]
    if (CUSTOM_INTERNAL_LUT_SHAPER == 0.f) {
      color = builder ? arriDecode(color)
                      : saturate(renodx::color::arri::logc::c1000::Encode(color, false));
    } else {
      color = builder ? renodx::color::bt709::from::BT2020(renodx::color::pq::Decode(color, 100.f))
                      : saturate(renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color), 100.f));
    }
  } else if (type == 1) {
    [branch]
    if (CUSTOM_INTERNAL_LUT_SHAPER == 0.f) {
      color = builder ? color : saturate(color);
    } else {
      color = builder ? renodx::color::bt709::from::BT2020(renodx::color::pq::Decode(color, 100.f))
                      : saturate(renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color), 100.f));
    }
  } else if (type == 2) {
    [branch]
    if (CUSTOM_INTERNAL_LUT_SHAPER == 0.f) {
      color = builder ? color : renodx::color::srgb::Encode(saturate(color));
    } else {
      color = builder ? renodx::color::srgb::EncodeSafe(renodx::color::bt709::from::BT2020(renodx::color::pq::Decode(color, 100.f)))
                      : saturate(renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color), 100.f));
    }
  }
  return color;
}

float3 fastSrgbDecode(float3 color) {
  return color * (color * (color * 0.305306011f + 0.682171111f) + 0.012522878f);
}
float3 fastSrgbEncode(float3 color) {
  return max(1.055f * pow(max(0.f, color), 0.416666667f) - 0.055f, 0.f);
}
float3 fastSrgbEncodeSafe(float3 color) {
  if(RENODX_TONE_MAP_TYPE == 0.f){
    return fastSrgbEncode(color);
  } else {
    return sign(color) * fastSrgbEncode(abs(color));
  }
}
float3 fastSrgbDecodeSafe(float3 color) {
  if(RENODX_TONE_MAP_TYPE == 0.f){
    return fastSrgbDecode(color);
  } else {
    return sign(color) * fastSrgbDecode(abs(color));
  }
}

float3 liftGammaGain(float3 input, float3 lift, float3 gamma, float3 gain){
  return sign(input) * pow(abs(input * gain + lift), gamma);
}

// 0 - linear bt709, 1 - linear ap1, 2 - srgb
float3 liftGammaGainScaling(float3 lifted, float3 original, float3 lift, float3 gamma, float3 gain, int encoding = 0){
  if(CUSTOM_INTERNAL_LUT_SCALING == 0.f){return lifted;} else {
    float3 new_gain = 2.f * (pow(liftGammaGain(0.5f, lift, gamma, gain), 1 / gamma) - liftGammaGain(0.f, lift, gamma, gain));
    float3 new_lift = pow(liftGammaGain(0.f, lift, gamma, gain), 1 / gamma);
    //float3 unclamped = original < (0.5).xxx ? liftGammaGain(original, new_lift, gamma, new_gain) : lifted;
    float3 unclamped = renodx::math::Select(original < (0.5).xxx, liftGammaGain(original, new_lift, gamma, new_gain), lifted);
    float3 unclamped_linear;
    float3 lifted_linear;
    if(encoding == 2){
      lifted_linear = renodx::color::srgb::DecodeSafe(lifted);
      unclamped_linear = renodx::color::srgb::DecodeSafe(unclamped);
    } else if (encoding == 1){
      lifted_linear = renodx::color::bt709::from::AP1(lifted);
      unclamped_linear = renodx::color::bt709::from::AP1(unclamped);
    } else if (encoding == 0) {
      lifted_linear = lifted;
      unclamped_linear = unclamped;
    }
    float lifted_y = renodx::color::y::from::BT709(abs(lifted_linear));
    float unclamped_y = renodx::color::y::from::BT709(abs(unclamped_linear));
    float3 scaled_linear = lifted_linear * renodx::math::DivideSafe(unclamped_y, lifted_y, 1.f);
    float3 output = lerp(lifted_linear, scaled_linear, CUSTOM_INTERNAL_LUT_SCALING);
  if(encoding == 2){
    output = renodx::color::srgb::EncodeSafe(output);
  } else if (encoding == 1){
    output = renodx::color::ap1::from::BT709(output);
  } else if (encoding == 0) {}
  return output;
}
}

float3 RestoreSaturationLoss(float3 color_input, float3 color_output) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.strength = 0.f;
  lut_config.scaling = 0.f;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.recolor = RENODX_TONE_MAP_TYPE != 0.f ? 1.f : 0.f;
  return renodx::lut::RestoreSaturationLoss(min(1.f, color_input), color_output, lut_config);
}

float3 ConvertInput(float3 color, int encoding) {
  if (encoding == 0) {
    color = renodx::color::srgb::EncodeSafe(color);
  } else if (encoding == 1) {
    color = fastSrgbEncodeSafe(color);
  } else if (encoding == 3){
    color = renodx::math::SignSqrt(color);
  }
  return color;
}
float3 LinearOutput(float3 color, int encoding) {
  if (encoding == 0) {
    color = renodx::color::srgb::DecodeSafe(color);
  } else if (encoding == 1) {
    color = fastSrgbDecodeSafe(color);
  } else if(encoding == 3){
    color = renodx::math::Sign(color) * color * color;
  }
  return color;
}
float3 GammaOutput(float3 lut_output_color, int encoding) {
  if (
      encoding == 0
      || encoding == 1 || encoding == 3) {
    return lut_output_color;
  } else {
    float3 linear_color = LinearOutput(lut_output_color, encoding);
    return renodx::color::srgb::Encode(max(0, linear_color));
  }
}
float3 GammaInput(float3 color_input, float3 color_input_converted, int encoding) {
  if (
      encoding == 0
      || encoding == 1 || encoding == 3) {
    return color_input_converted;
  } else {
    return renodx::color::srgb::Encode(max(0, color_input));
  }
}
float3 LinearUnclampedOutput(float3 color, int encoding) {
  if (encoding == 1) {
    color = fastSrgbDecodeSafe(color);
  } else if (encoding == 3){
    color = renodx::math::Sign(color) * color * color;
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
  }
  return color;
}

// 0 = SRGB, 1 = fastSRGB, 2 = linear, 3 = gamma 2_0
float3 handleUserLUT(float3 hdrLinearColor, Texture2D lut_texture, SamplerState lut_sampler, float3 preCompute, int encoding = 0, bool linearOutput = false, bool notetrahedral = false){
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lut_sampler;
  lut_config.strength = CUSTOM_USER_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_USER_LUT_SCALING;
  if(encoding == 2){
  lut_config.type_input = renodx::lut::config::type::LINEAR;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  } else if (encoding == 3) {
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_0;
  lut_config.type_output = renodx::lut::config::type::GAMMA_2_0;
  } else {
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  }
  lut_config.precompute = preCompute;
  lut_config.tetrahedral = !notetrahedral && CUSTOM_LUT_SAMPLE != 0.f;
  lut_config.gamut_compress = RENODX_TONE_MAP_TYPE == 0.f ? 0.f : 1.f;
    float3 max_channel_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(hdrLinearColor);
    float3 sdrColor = hdrLinearColor * max_channel_scale;
    float compression_scale = 1.f;
    float3 current_adaptive_state_lms = renodx::color::lms::from::BT709(0.18f);                                           
    if (lut_config.gamut_compress > 0.f) {
      compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(sdrColor, current_adaptive_state_lms);
      sdrColor = renodx::color::gamut::GamutCompressBT709AdaptiveD65(sdrColor, current_adaptive_state_lms, compression_scale);  
    }
    float3 lutLinearInput = RENODX_TONE_MAP_TYPE == 0.f ? saturate(hdrLinearColor) : sdrColor;
    float3 lutInputColor = ConvertInput(lutLinearInput, encoding);
    float3 lutOutputColor = renodx::lut::SampleColor(lutInputColor, lut_config, lut_texture);
    float3 color_output = LinearOutput(lutOutputColor, encoding);
    [branch]
    if (lut_config.scaling != 0.f) {
      float3 lutBlack = renodx::lut::SampleColor(ConvertInput(0, encoding), lut_config, lut_texture);
      float3 lutMid = renodx::lut::SampleColor(ConvertInput(0.18f, encoding), lut_config, lut_texture);
      float3 lutWhite = renodx::lut::SampleColor(ConvertInput(1.f, encoding), lut_config, lut_texture);
      float3 unclamped_gamma = renodx::lut::Unclamp(
          GammaOutput(lutOutputColor, encoding),
          GammaOutput(lutBlack, encoding),
          GammaOutput(lutMid, encoding),
          GammaOutput(lutWhite, encoding),
          GammaInput(hdrLinearColor, lutInputColor, encoding));
      float3 unclamped_linear = LinearUnclampedOutput(unclamped_gamma, encoding);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    } else {
    }
    if (lut_config.gamut_compress > 0.f) {                                                       
      color_output = renodx::color::gamut::GamutDecompressBT709AdaptiveD65(color_output, current_adaptive_state_lms, compression_scale);
    }                                                                                          
    [branch]
    if(RENODX_TONE_MAP_TYPE == 0.f){
      color_output = lerp(saturate(hdrLinearColor), color_output, lut_config.strength);
    } else {
      color_output = lerp(hdrLinearColor, color_output / max_channel_scale, lut_config.strength);
    }
    if(!linearOutput){
    if(encoding == 0){
      return renodx::color::srgb::EncodeSafe(color_output);
    } else if(encoding == 1){
      return fastSrgbEncodeSafe(color_output);
    } else if(encoding == 3) {
      return renodx::math::SignSqrt(color_output);
    } else {
      return color_output;
    }
  } else {
    return color_output;
  }
}
// 0 = SRGB, 1 = fastSRGB, 2 = linear, 3 = gamma 2_0
float3 handleUserLUT(float3 hdrLinearColor, Texture3D lut_texture, SamplerState lut_sampler, float size = 0, int encoding = 0, bool linearOutput = false) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lut_sampler;
  lut_config.strength = CUSTOM_USER_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_USER_LUT_SCALING;
  if(encoding == 2){
  lut_config.type_input = renodx::lut::config::type::LINEAR;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  } else if (encoding == 3) {
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_0;
  lut_config.type_output = renodx::lut::config::type::GAMMA_2_0;
  } else {
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  }
  if(size != 0){
  lut_config.size = size;
  }
  lut_config.tetrahedral = CUSTOM_LUT_SAMPLE != 0.f;
  lut_config.gamut_compress = RENODX_TONE_MAP_TYPE == 0.f ? 0.f : 1.f;
    float3 max_channel_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(hdrLinearColor);
    float3 sdrColor = hdrLinearColor * max_channel_scale;
    float max_channel = 1.f;           
    float min_channel = 0.f;           
    float compression_scale = 1.f;                                                                    
    float3 current_adaptive_state_lms = renodx::color::lms::from::BT709(0.18f);                                           
    if (lut_config.gamut_compress > 0.f) {
      compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(sdrColor, current_adaptive_state_lms);
      sdrColor = renodx::color::gamut::GamutCompressBT709AdaptiveD65(sdrColor, current_adaptive_state_lms, compression_scale);  
    }
    float3 lutLinearInput = RENODX_TONE_MAP_TYPE == 0.f ? saturate(hdrLinearColor) : sdrColor;
    float3 lutInputColor = ConvertInput(lutLinearInput, encoding);
    float3 lutOutputColor = renodx::lut::SampleColor(lutInputColor, lut_config, lut_texture);
    float3 color_output = LinearOutput(lutOutputColor, encoding);
    [branch]
    if (lut_config.scaling != 0.f) {
      float3 lutBlack = renodx::lut::SampleColor(ConvertInput(0, encoding), lut_config, lut_texture);
      float3 lutMid = renodx::lut::SampleColor(ConvertInput(0.18f, encoding), lut_config, lut_texture);
      float3 lutWhite = renodx::lut::SampleColor(ConvertInput(1.f, encoding), lut_config, lut_texture);
      float3 unclamped_gamma = renodx::lut::Unclamp(
          GammaOutput(lutOutputColor, encoding),
          GammaOutput(lutBlack, encoding),
          GammaOutput(lutMid, encoding),
          GammaOutput(lutWhite, encoding),
          GammaInput(hdrLinearColor, lutInputColor, encoding));
      float3 unclamped_linear = LinearUnclampedOutput(unclamped_gamma, encoding);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    } else {
    }
    if (lut_config.gamut_compress > 0.f) {                                                       
      color_output = renodx::color::gamut::GamutDecompressBT709AdaptiveD65(color_output, current_adaptive_state_lms, compression_scale);
    }                                                                    
    [branch]
    if(RENODX_TONE_MAP_TYPE == 0.f){
    color_output = lerp(saturate(hdrLinearColor), color_output, lut_config.strength);
    } else {
    color_output = lerp(hdrLinearColor, color_output / max_channel_scale, lut_config.strength);
    }
    if(!linearOutput){
    if(encoding == 0){
      return renodx::color::srgb::EncodeSafe(color_output);
    } else if(encoding == 1){
      return fastSrgbEncodeSafe(color_output);
    } else if(encoding == 3) {
      return renodx::math::SignSqrt(color_output);
    } else {
      return color_output;
    }
  } else {
    return color_output;
  }
}