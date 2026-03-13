#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float color_grade_strength;

  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;

  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;

  float tone_map_flare;
  float tone_map_hue_correction;
  float tone_map_hue_shift;
  float tone_map_working_color_space;

  float tone_map_clamp_color_space;
  float tone_map_clamp_peak;
  float tone_map_hue_processor;
  float tone_map_per_channel;

  float gamma_correction;
  float intermediate_scaling;
  float intermediate_encoding;
  float intermediate_color_space;

  float swap_chain_decoding;
  float swap_chain_gamma_correction;
  float swap_chain_custom_color_space;
  float swap_chain_clamp_color_space;

  float swap_chain_encoding;
  float swap_chain_encoding_color_space;
  float Custom_Bloom_Improved;
  float Custom_Bloom_Amount;

  float Custom_Bloom_Threshold;
  float Custom_Bloom_Radius;
  float Custom_Volumetrics_Amount;
  float Custom_Sky_SunSpriteIntensity;

  float Custom_Exposure_Adaptation;
  float Custom_Emissives_Glow;
  float Custom_Emissives_Glow_Contrast;
  float Custom_Emissives_Glow_Saturation;

  float Custom_Emissives_Fire_Glow;
  float Custom_HDR_Videos;
  float Custom_Sky_Luminaries_Glow;
  float Custom_Sky_Luminaries_Glow_Contrast;

  float Custom_Sky_Luminaries_Glow_Saturation;
  float Custom_Sky_Clouds_Glow;
  float Custom_Sky_Clouds_Glow_Contrast;
  float Custom_Sky_Skybox_Glow;

  float Custom_Sky_Skybox_Glow_Contrast;
  float Custom_Sky_Skybox_Glow_Saturation;
  float Custom_AO_Enable;
  float Custom_AO_Debug;

  float Custom_AO_Intensity;
  float Custom_AO_Radius_Near;
  float Custom_AO_Radius_Far;
  float Custom_AO_Bias_Near;

  float Custom_AO_Bias_Far;
  float Custom_AO_Thickness_Near;
  float Custom_AO_Thickness_Far;
  float Custom_AO_Blur;

  float Custom_AO_Fade_Start;
  float Custom_AO_Fade_End;
  float Custom_AO_Brightness_Fade_Threshold;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                   shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION                shader_injection.gamma_correction
#define RENODX_TONE_MAP_PER_CHANNEL            shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE    shader_injection.tone_map_working_color_space
#define RENODX_TONE_MAP_HUE_PROCESSOR          shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_HUE_CORRECTION         shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_HUE_SHIFT              shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE      shader_injection.tone_map_clamp_color_space
#define RENODX_TONE_MAP_CLAMP_PEAK             shader_injection.tone_map_clamp_peak
#define RENODX_TONE_MAP_EXPOSURE               shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST               shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION             shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                  shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH            shader_injection.color_grade_strength
#define RENODX_INTERMEDIATE_ENCODING           shader_injection.intermediate_encoding
#define RENODX_SWAP_CHAIN_DECODING             shader_injection.swap_chain_decoding
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION     shader_injection.swap_chain_gamma_correction
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   shader_injection.swap_chain_custom_color_space
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    shader_injection.swap_chain_clamp_color_space
#define RENODX_SWAP_CHAIN_ENCODING             shader_injection.swap_chain_encoding
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE shader_injection.swap_chain_encoding_color_space
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define CUSTOM_BLOOM_IMPROVED                  shader_injection.Custom_Bloom_Improved
#define CUSTOM_BLOOM_AMOUNT                    shader_injection.Custom_Bloom_Amount
#define CUSTOM_BLOOM_THRESHOLD                 shader_injection.Custom_Bloom_Threshold
#define CUSTOM_BLOOM_RADIUS                    shader_injection.Custom_Bloom_Radius
#define CUSTOM_VOLUMETRICS_AMOUNT              shader_injection.Custom_Volumetrics_Amount
#define CUSTOM_SKY_SUNSPRITEINTENSITY          shader_injection.Custom_Sky_SunSpriteIntensity
#define CUSTOM_EXPOSURE_ADAPTATION             shader_injection.Custom_Exposure_Adaptation
#define CUSTOM_EMISSIVES_GLOW                  shader_injection.Custom_Emissives_Glow
#define CUSTOM_EMISSIVES_GLOW_CONTRAST         shader_injection.Custom_Emissives_Glow_Contrast
#define CUSTOM_EMISSIVES_GLOW_SATURATION       shader_injection.Custom_Emissives_Glow_Saturation
#define CUSTOM_EMISSIVES_FIRE_GLOW             shader_injection.Custom_Emissives_Fire_Glow
#define CUSTOM_HDR_VIDEOS                      shader_injection.Custom_HDR_Videos
#define CUSTOM_SKY_LUMINARIES_GLOW             shader_injection.Custom_Sky_Luminaries_Glow
#define CUSTOM_SKY_LUMINARIES_GLOW_CONTRAST    shader_injection.Custom_Sky_Luminaries_Glow_Contrast
#define CUSTOM_SKY_LUMINARIES_GLOW_SATURATION  shader_injection.Custom_Sky_Luminaries_Glow_Saturation
#define CUSTOM_SKY_CLOUDS_GLOW                 shader_injection.Custom_Sky_Clouds_Glow
#define CUSTOM_SKY_CLOUDS_GLOW_CONTRAST        shader_injection.Custom_Sky_Clouds_Glow_Contrast
#define CUSTOM_SKY_SKYBOX_GLOW                 shader_injection.Custom_Sky_Skybox_Glow
#define CUSTOM_SKY_SKYBOX_GLOW_CONTRAST        shader_injection.Custom_Sky_Skybox_Glow_Contrast
#define CUSTOM_SKY_SKYBOX_GLOW_SATURATION      shader_injection.Custom_Sky_Skybox_Glow_Saturation
#define CUSTOM_AO_ENABLE                       shader_injection.Custom_AO_Enable
#define CUSTOM_AO_DEBUG                        shader_injection.Custom_AO_Debug
#define CUSTOM_AO_INTENSITY                    shader_injection.Custom_AO_Intensity
#define CUSTOM_AO_RADIUS_NEAR                  shader_injection.Custom_AO_Radius_Near
#define CUSTOM_AO_RADIUS_FAR                   shader_injection.Custom_AO_Radius_Far
#define CUSTOM_AO_BIAS_NEAR                    shader_injection.Custom_AO_Bias_Near
#define CUSTOM_AO_BIAS_FAR                     shader_injection.Custom_AO_Bias_Far
#define CUSTOM_AO_THICKNESS_NEAR               shader_injection.Custom_AO_Thickness_Near
#define CUSTOM_AO_THICKNESS_FAR                shader_injection.Custom_AO_Thickness_Far
#define CUSTOM_AO_BLUR                         shader_injection.Custom_AO_Blur
#define CUSTOM_AO_FADE_START                   shader_injection.Custom_AO_Fade_Start
#define CUSTOM_AO_FADE_END                     shader_injection.Custom_AO_Fade_End
#define CUSTOM_AO_BRIGHTNESS_FADE_THRESHOLD    shader_injection.Custom_AO_Brightness_Fade_Threshold

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_TEMPLATE_SHARED_H_
