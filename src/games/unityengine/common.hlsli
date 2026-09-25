#include "./shared.h"
#include "./lut.hlsli"
#include "./tonemap.hlsli"
#include "./effects.hlsli"

float3 GradeAndDisplayMap(float3 color) {
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
  config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 5.f);
  /*config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;*/
  config.hue_correction_strength = 0.f;
  //config.hue_correction_color = lerp(untonemapped, renodx::tonemap::renodrt::NeutralSDR(untonemapped, true), injectedData.toneMapHueShift);
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::NEUTWO;
  config.reno_drt_clamp_color_space = -1;
  config.reno_drt_clamp_peak = -1.f;
  //config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_blowout = 1.f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  //config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_working_color_space = 1;
  config.reno_drt_white_clip = RENODX_RENO_DRT_WHITE_CLIP;
  config.reno_drt_scaling_method = RENODX_TONE_MAP_SCALING;
  //[branch]
  if (config.type == 0.f) {
    color = max(0.f, color);
  } else {
    if(CUSTOM_IS_TONEMAPPED == 0.f){
    color = CorrectHueAndChrominanceOKLAB(color, renodx::tonemap::ReinhardPiecewise(color, RENODX_TONE_MAP_SDR_CLIP, 0.99f), RENODX_TONE_MAP_SDRIFY, RENODX_TONE_MAP_SDRIFY);
    }
    color = HDRBoost(color, CUSTOM_HDR_BOO0ST);
  }
  return renodx::tonemap::config::Apply(color, config);
}

//-----SCALING-----//
float3 PostToneMapScale(float3 color, bool gamma = false) {
  if (gamma) {
    [branch]
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
  } else {
    [branch]
    if (RENODX_GAMMA_CORRECTION == 2.f) {
      color = renodx::color::correct::GammaSafe(color, false, 2.4f);
      color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
      color = renodx::color::correct::GammaSafe(color, true, 2.4f);
    } else if (RENODX_GAMMA_CORRECTION == 1.f) {
      color = renodx::color::correct::GammaSafe(color, false, 2.2f);
      color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
      color = renodx::color::correct::GammaSafe(color, true, 2.2f);
    } else {
      color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    }
  }
  return color;
}

float3 InvertToneMapScale(float3 color, bool gamma = false) {
  if(gamma){
    if (RENODX_GAMMA_CORRECTION == 2.f) {
      color = renodx::color::gamma::DecodeSafe(color, 2.4f);
      color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      color = renodx::color::gamma::EncodeSafe(color, 2.4f);
      color = renodx::color::srgb::DecodeSafe(color);
    } else if (RENODX_GAMMA_CORRECTION == 1.f) {
      color = renodx::color::gamma::DecodeSafe(color, 2.2f);
      color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      color = renodx::color::gamma::EncodeSafe(color, 2.2f);
      color = renodx::color::srgb::DecodeSafe(color);
    } else {
      color = renodx::color::srgb::DecodeSafe(color);
      color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    }
  } else {
    [branch]
    if (RENODX_GAMMA_CORRECTION == 2.f) {
      color = renodx::color::correct::GammaSafe(color, false, 2.4f);
      color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      color = renodx::color::correct::GammaSafe(color, true, 2.4f);
    } else if (RENODX_GAMMA_CORRECTION == 1.f) {
      color = renodx::color::correct::GammaSafe(color, false, 2.2f);
      color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      color = renodx::color::correct::GammaSafe(color, true, 2.2f);
    } else {
      color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    }
  }
  return color;
}