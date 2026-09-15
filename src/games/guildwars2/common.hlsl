#include "./shared.h"

//-----EFFECTS-----//
float3 applyFilmGrain(float3 outputColor, float2 screen, bool colored) {
  float3 grainedColor;
  if (colored == true) {
    grainedColor = renodx::effects::ApplyFilmGrainColored(
        outputColor,
        screen,
        float3(
            CUSTOM_RANDOM1,
            CUSTOM_RANDOM2,
            CUSTOM_RANDOM3),
        CUSTOM_GRAIN_STRENGTH * 0.01f,
        1.f);
  } else {
    grainedColor = renodx::effects::ApplyFilmGrain(
        outputColor,
        screen,
        CUSTOM_RANDOM1,
        CUSTOM_GRAIN_STRENGTH * 0.03f,
        1.f);
  }
  return grainedColor;
}

float3 applyVignette(float3 inputColor, float2 screen, float slider) {
  static float intensity = 1.f;	// internal
  static float roundness = 1.15f;	// parameters
  static float light = 0.1f;		// for now

  float Vintensity = intensity * min(1, slider);  // Slider below 1 to Vintensity
  float Vroundness = roundness * max(1, slider);  // Slider above 1 to Vroundness
  float2 Vcoord = screen - 0.5f;                  // get screen center
  Vcoord *= Vintensity;
  float v = dot(Vcoord, Vcoord);
  v = saturate(1 - v);
  v = pow(v, Vroundness);
  float3 output = inputColor * min(1, v + light);
  return output;
}

// based on https://github.com/aliasIsolation/aliasIsolation/blob/master/data/shaders/chromaticAberration_ps.hlsl
float3 applyCA(Texture2D colorBuffer, SamplerState colorSampler, float2 texCoord, float intensity) {
  float3 output;
  uint screenWidth, screenHeight;
  colorBuffer.GetDimensions(screenWidth, screenHeight);
  float ca_amount = 0.018 * intensity;
  float2 center_offset = texCoord - float2(0.5, 0.5);
  ca_amount *= saturate(length(center_offset) * 2);
  int num_colors = max(3, int(max(screenWidth, screenHeight) * 0.075 * sqrt(ca_amount)));
  if (intensity == 0.f) {
    output = colorBuffer.Sample(colorSampler, texCoord).rgb;
  } else {
    output.g = colorBuffer.Sample(colorSampler, texCoord).g;  // unchanged green and alpha
    float offset = float(7 - num_colors * 0.5) * ca_amount / num_colors;
    float2 sampleUvR = float2(0.5, 0.5) + center_offset * (1 + offset);
    float2 sampleUvB = float2(0.5, 0.5) + center_offset * (1 - offset);
    output.r = colorBuffer.Sample(colorSampler, sampleUvR).r;
    output.b = colorBuffer.Sample(colorSampler, sampleUvB).b;
  }
  return output;
}

//-----SCALING-----//
float3 PostToneMapScale(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else {
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float3 HalfWayScale(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color *= (RENODX_DIFFUSE_WHITE_NITS + RENODX_GRAPHICS_WHITE_NITS) / (RENODX_GRAPHICS_WHITE_NITS * 2.f);
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color *= (RENODX_DIFFUSE_WHITE_NITS + RENODX_GRAPHICS_WHITE_NITS) / (RENODX_GRAPHICS_WHITE_NITS * 2.f);
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else {
    color *= (RENODX_DIFFUSE_WHITE_NITS + RENODX_GRAPHICS_WHITE_NITS) / (RENODX_GRAPHICS_WHITE_NITS * 2.f);
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float3 FinalizeOutput(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
  }
  color *= RENODX_GRAPHICS_WHITE_NITS;
  	if(RENODX_TONE_MAP_TYPE == 0.f) {
  color = renodx::color::bt709::clamp::BT709(color);
  color = min(max(RENODX_DIFFUSE_WHITE_NITS, RENODX_GRAPHICS_WHITE_NITS), color);
  } else if (RENODX_TONE_MAP_TYPE != 1.f) {
  color = renodx::color::lms::from::BT709(color);
  color = renodx::color::gamut::GamutCompressLMSBoundBT2020(color);
  color = renodx::color::bt709::from::LMS(color);
  float max_channel = max(max(max(color.r, color.g), color.b), RENODX_PEAK_WHITE_NITS);
  color *= RENODX_PEAK_WHITE_NITS / max_channel;  // Clamp UI or Videos
  } else {
  color = renodx::color::bt709::clamp::AP1(color);
  }
  color = renodx::color::bt2020::from::BT709(color);
  color = renodx::color::pq::EncodeSafe(color, 1.f);
  return color;
}

float3 InverseToneMap(float3 color) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
	float scaling = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
	float videoPeak = scaling * renodx::color::bt2408::REFERENCE_WHITE;
    videoPeak = renodx::color::correct::Gamma(videoPeak, false, 2.4f);
    scaling = renodx::color::correct::Gamma(scaling, false, 2.4f);
      if(RENODX_GAMMA_CORRECTION == 2.f){
    videoPeak = renodx::color::correct::Gamma(videoPeak, true, 2.4f);
    scaling = renodx::color::correct::Gamma(scaling, true, 2.4f);
    } else if(RENODX_GAMMA_CORRECTION == 1.f){
    videoPeak = renodx::color::correct::Gamma(videoPeak, true, 2.2f);
    scaling = renodx::color::correct::Gamma(scaling, true, 2.2f);
    }
    color = renodx::color::gamma::Decode(color, 2.4f);
    color = renodx::tonemap::inverse::bt2446a::BT709(color, renodx::color::bt709::REFERENCE_WHITE, videoPeak);
	color /= videoPeak;
	color *= scaling;
  color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {}
  color = renodx::color::srgb::DecodeSafe(color);
	return color;
}

//-----TONEMAP-----//
float3 CorrectHueAndChrominanceOKLAB(float3 input_color, float3 target_color, float hue_restore, float blowout_restore) {
  // float3 final_bt709 = input_color;
  if (hue_restore <= 0.f && blowout_restore <= 0.f) {
    return input_color;
  } else {
    float3 current_adaptive_state_lms = renodx::color::lms::from::BT709(0.18f);
    float compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(target_color, current_adaptive_state_lms);
    target_color = max(0.f, target_color);
    compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(input_color, current_adaptive_state_lms);
    input_color = renodx::color::gamut::GamutCompressBT709AdaptiveD65(input_color, current_adaptive_state_lms, compression_scale);
    float max_channel_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(input_color);
    input_color *= max_channel_scale;
    float clamp_chrominance_loss = 0.f;
    float clamp_hue_change = 0.99f;
    // Hue
    float3 incorrect_lab = renodx::color::oklab::from::BT709(input_color);
    float3 correct_lab = renodx::color::oklab::from::BT709(target_color);

    float2 incorrect_ab = incorrect_lab.yz;
    float2 correct_ab = correct_lab.yz;

    // Preserve original chrominance (magnitude of the a–b vector)
    float chrominance_pre_adjust = length(incorrect_ab);

    // Blend chrominance and hue by interpolating (a, b) components
    float2 blended_ab = lerp(incorrect_ab, correct_ab, min(clamp_hue_change, hue_restore));

    // Rescale to original chrominance to avoid saturation shift
    float chrominance_post_adjust = length(blended_ab);
    blended_ab *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);

    incorrect_lab.yz = blended_ab;
    // Chrominance
    // float2 incorrect_ab = incorrect_lab.yz;
    // float2 reference_ab = reference_lab.yz;

    // Compute chrominance (magnitude of the a–b vector)
    float incorrect_chrominance = length(blended_ab);
    float correct_chrominance = length(correct_ab);

    // Scale original chrominance vector toward target chrominance
    float chrominance_ratio = renodx::math::DivideSafe(correct_chrominance, incorrect_chrominance, 1.f);
    float scale = lerp(1.f, chrominance_ratio, blowout_restore);

    float t = 1.0f - step(1.0f, scale);  // t = 1 when scale < 1, 0 when scale >= 1
    scale = lerp(scale, 1.0f, t * clamp_chrominance_loss);

    incorrect_lab.yz *= scale;

    float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);

    result /= max_channel_scale;
    result = renodx::color::gamut::GamutDecompressBT709AdaptiveD65(result, current_adaptive_state_lms, compression_scale);
    return result;
  }
}

float HDRBoost(float color, float power = 0.f, float3 normalization_point = 0.04f) {
  if (power == 0.f) return color;
  float3 LMS_WHITE = renodx::color::lms::from::BT709(float3(1, 1, 1));
  float3 lms_color = renodx::color::lms::from::BT709(color);
  lms_color /= LMS_WHITE;
  normalization_point /= LMS_WHITE;
  const float smoothing = power * 2.f;
  float boosted = max(lms_color, lerp(lms_color, normalization_point * pow(lms_color / normalization_point, 1.f + power), renodx::tonemap::Reinhard(lms_color, smoothing)));
  return boosted * LMS_WHITE;
}

float3 HDRBoost(float3 color, float power = 0.f, float3 normalization_point = 0.04f) {
  return float3(
      HDRBoost(color.r, power, normalization_point),
      HDRBoost(color.g, power, normalization_point),
      HDRBoost(color.b, power, normalization_point)
  );
}

float3 applyUserTonemap(float3 untonemapped, Texture2D lutTexture, SamplerState lutSampler) {
  float3 outputColor;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = RENODX_TONE_MAP_TYPE == 2.f ? 3.f : RENODX_TONE_MAP_TYPE;
  config.peak_nits = RENODX_PEAK_WHITE_NITS;
  config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  config.gamma_correction = RENODX_GAMMA_CORRECTION;
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.reno_drt_dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  config.hue_correction_strength = 0.f;
  config.reno_drt_tone_map_method = 3.f;  // Neutwo
  config.reno_drt_hue_correction_method = (int)RENODX_TONE_MAP_HUE_PROCESSOR;
  config.reno_drt_blowout = 1.f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.reno_drt_scaling_method = RENODX_TONE_MAP_SCALING;
  config.reno_drt_white_clip = RENODX_RENO_DRT_WHITE_CLIP;
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lutSampler;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.size = 16;
  lut_config.tetrahedral = CUSTOM_LUT_SAMPLE != 0.f;
  lut_config.recolor = 0.f;
  lut_config.gamut_compress = 0.f;
  lut_config.max_channel = 0.f;
    float3 lutInput;
    if (config.type == 0.f) {
      lutInput = saturate(untonemapped);
      outputColor = renodx::lut::Sample(lutInput, lut_config, lutTexture);
    } else {
      float max_channel_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(untonemapped);
      lutInput = CorrectHueAndChrominanceOKLAB(untonemapped, renodx::tonemap::ReinhardPiecewise(untonemapped, CUSTOM_COLOR_GRADE_HUE_CLIP, 0.99f), CUSTOM_COLOR_GRADE_HUE_SHIFT, CUSTOM_COLOR_GRADE_HUE_SHIFT);
      lutInput = lutInput * max_channel_scale;
      float3 current_adaptive_state_lms = renodx::color::lms::from::BT709(0.18f);
      float compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(lutInput, current_adaptive_state_lms);
      lutInput = renodx::color::gamut::GamutCompressBT709AdaptiveD65(lutInput, current_adaptive_state_lms, compression_scale);
      float3 lutColor = renodx::lut::Sample(lutInput, lut_config, lutTexture);
      outputColor = renodx::color::gamut::GamutDecompressBT709AdaptiveD65(lutColor, current_adaptive_state_lms, compression_scale);
      outputColor = renodx::math::DivideSafe(outputColor, max_channel_scale, outputColor);
      outputColor = HDRBoost(outputColor, CUSTOM_HDR_BOOST);
    }
    return renodx::tonemap::config::Apply(outputColor, config);
}

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = RENODX_TONE_MAP_TYPE == 2.f ? 3.f : RENODX_TONE_MAP_TYPE;
  config.peak_nits = RENODX_PEAK_WHITE_NITS;
  config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  config.gamma_correction = RENODX_GAMMA_CORRECTION;
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.reno_drt_dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  config.hue_correction_strength = 0.f;
  config.reno_drt_tone_map_method = 3.f;  // Neutwo
  config.reno_drt_hue_correction_method = (int)RENODX_TONE_MAP_HUE_PROCESSOR;
  config.reno_drt_blowout = 1.f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.reno_drt_scaling_method = RENODX_TONE_MAP_SCALING;
  config.reno_drt_white_clip = RENODX_RENO_DRT_WHITE_CLIP;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    outputColor = saturate(untonemapped);
  } else {
    outputColor = CorrectHueAndChrominanceOKLAB(untonemapped, renodx::tonemap::ReinhardPiecewise(untonemapped, CUSTOM_COLOR_GRADE_HUE_CLIP, 0.99f), CUSTOM_COLOR_GRADE_HUE_SHIFT, CUSTOM_COLOR_GRADE_HUE_SHIFT);
    outputColor = HDRBoost(outputColor, CUSTOM_HDR_BOOST);
  }
  return outputColor = renodx::tonemap::config::Apply(outputColor, config);
}