#ifndef SRC_CRIMSONDESERT_SHARED_H_
#define SRC_CRIMSONDESERT_SHARED_H_

#ifdef __cplusplus
#include <bit>
#include <cstdint>
#endif

#define CUSTOM_FLAGS__TONE_MAP_TYPE            0b0000000000001u
#define CUSTOM_FLAGS__SDR_BLACK_CRUSH_FIX      0b0000000000010u
#define CUSTOM_FLAGS__IMPROVED_AUTO_EXPOSURE   0b0000000000100u
#define CUSTOM_FLAGS__DISABLE_AWB              0b0000000001000u
#define CUSTOM_FLAGS__DISABLE_HERO_LIGHTS      0b0000000010000u
#define CUSTOM_FLAGS__FILM_GRAIN_TYPE          0b0000000100000u
#define CUSTOM_FLAGS__SHARPENING_TYPE          0b0000001000000u
#define CUSTOM_FLAGS__SKY_SCATTERING           0b0000010000000u
#define CUSTOM_FLAGS__SUN_MOON_ADJUSTMENTS     0b0000100000000u
#define CUSTOM_FLAGS__CONTACT_SHADOW_QUALITY   0b0001000000000u
#define CUSTOM_FLAGS__RT_QUALITY_BIT0          0b0010000000000u
#define CUSTOM_FLAGS__RT_QUALITY_BIT1          0b0100000000000u
#define CUSTOM_FLAGS__MATERIAL_IMPROVEMENTS    0b1000000000000u

#define CUSTOM_FLAGS                           shader_injection.custom_flags

#ifdef __cplusplus
#define CUSTOM_FLAGS_AS_UINT                   (std::bit_cast<uint32_t>(CUSTOM_FLAGS))
#else
#define CUSTOM_FLAGS_AS_UINT                   (asuint(CUSTOM_FLAGS))
#endif

#define RENODX_TONE_MAP_TYPE                   ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__TONE_MAP_TYPE) != 0u ? 1.f : 0.f)
#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION                0 // shader_injection.gamma_correction
#define CUSTOM_SDR_BLACK_CRUSH_FIX             ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__SDR_BLACK_CRUSH_FIX) != 0u ? 1.f : 0.f)

#define RENODX_TONE_MAP_HUE_RESTORE            shader_injection.tone_map_hue_restore
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.tone_map_blowout
#define CUSTOM_TONE_MAP_MIDGRAY_ADJUST         1.f // shader_injection.custom_tone_map_midgray_adjust
#define RENODX_COLOR_GRADE_STRENGTH            1.f

#define RENODX_TONE_MAP_EXPOSURE               shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST_HIGH          shader_injection.tone_map_contrast_high
#define RENODX_TONE_MAP_CONTRAST_LOW           shader_injection.tone_map_contrast_low
#define RENODX_TONE_MAP_SATURATION             shader_injection.tone_map_saturation
//#define RENODX_TONE_MAP_ADAPTATION_CONTRAST    shader_injection.tone_map_adaptation_contrast

#define CUSTOM_FILM_GRAIN_TYPE                 ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__FILM_GRAIN_TYPE) != 0u ? 1.f : 0.f)
#define CUSTOM_FILM_GRAIN_STRENGTH             shader_injection.custom_film_grain
#define CUSTOM_RANDOM                          shader_injection.custom_random
#define CUSTOM_CHROMATIC_ABERRATION            shader_injection.custom_chromatic_aberration
#define CUSTOM_SHARPENING_TYPE                 ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__SHARPENING_TYPE) != 0u ? 1.f : 0.f)
#define CUSTOM_SHARPENING                      shader_injection.custom_sharpening
#define CUSTOM_VIGNETTE                        shader_injection.custom_vignette
#define LENS_FLARE_STRENGTH                    shader_injection.lens_flare_strength
#define BLOOM_STRENGTH                         shader_injection.bloom_strength

#define SHADOW_DEBUG_MODE                      0 // shader_injection.shadow_debug_mode
#define SHADOW_DISABLE_LAYER                   0 // shader_injection.shadow_disable_layer
#define CONTACT_SHADOW_QUALITY                 ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__CONTACT_SHADOW_QUALITY) != 0u ? 1.f : 0.f)
#define FOLIAGE_TRANSMISSION                   (CONTACT_SHADOW_QUALITY > 0.5f ? 1.0f : 0.0f)
#define RT_QUALITY                             ((float)((CUSTOM_FLAGS_AS_UINT >> 10u) & 0x3u))
#define RT_GI_KNEE                             2.0f
#define RT_GI_STRENGTH                         0.07f
#define MATERIAL_IMPROVEMENTS                  ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__MATERIAL_IMPROVEMENTS) != 0u ? 1.f : 0.f)
#define DIFFUSE_BRDF_MODE                      (MATERIAL_IMPROVEMENTS > 0.5f ? 2.0f : 0.0f)
#define SMOOTH_TERMINATOR                      (MATERIAL_IMPROVEMENTS > 0.5f ? 1.0f : 0.0f)
#define SPECULAR_AA                            (MATERIAL_IMPROVEMENTS > 0.5f ? 1.0f : 0.0f)
#define DIFFRACTION                            (MATERIAL_IMPROVEMENTS > 0.5f ? 1.0f : 0.0f)
#define FOLIAGE_GREEN_DESAT                    (CONTACT_SHADOW_QUALITY > 0.5f ? 0.5f : 0.0f)
#define LOCAL_LIGHT_HUE_CORRECTION             shader_injection.local_light_hue_correction
#define LOCAL_LIGHT_SATURATION                 shader_injection.local_light_saturation
#define DISABLE_AWB                            ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__DISABLE_AWB) != 0u ? 1.f : 0.f)
#define DISABLE_HERO_LIGHTS                    ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__DISABLE_HERO_LIGHTS) != 0u ? 1.f : 0.f)

#define IMPROVED_AUTO_EXPOSURE                 ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__IMPROVED_AUTO_EXPOSURE) != 0u ? 1.f : 0.f)

#define SUN_MOON_ADJUSTMENTS                   ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__SUN_MOON_ADJUSTMENTS) != 0u ? 1.f : 0.f)
#define MOON_DISK_SIZE                         shader_injection.moon_disk_size
#define SKY_SCATTERING                         ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__SKY_SCATTERING) != 0u ? 1.f : 0.f)

// Auto exposure tuning
//#define AE_DARK_POWER_OUTDOOR                  shader_injection.ae_dark_power_outdoor
#define AE_DYNAMISM_HIGH                       shader_injection.ae_dynamism_high
#define AE_DYNAMISM_LOW                        shader_injection.ae_dynamism_low
#define AE_SPEED                               shader_injection.ae_speed
#define FOLIAGE_SHADOW_SENSITIVITY             0
#define AE_DARK_POWER_OUTDOOR                  0.45f
#define AE_DARK_POWER_INDOOR                   0.55f
#define AE_BRIGHT_POWER_OUTDOOR                1.00f
#define AE_BRIGHT_POWER_INDOOR                 1.00f
#define AE_ADAPT_SPEED_BOOST                   3.00f
#define AE_EV_BIAS                             -1.00f
// Luminance clamp overrides — locks out per-region/weather dynamic adjustments
#define AE_MIN_LUM                             0.001f
#define AE_MAX_LUM                             10.00f

// Tonemap highlight dimming (hardcoded defaults)
#define AE_TRANSITION_THRESHOLD                0.0f
#define AE_KNEE_ADAPTED                        0.0f
#define AE_KNEE_TRANSITION                     0.0f
#define AE_COMPRESS_MAX                        0.0f

// Must be 32bit aligned
// Should be 4x32
//
//// GAME BLOWS UP ONCE THERE'S MORE THAN 45 CBUFFERS ////
// 
//// AMD BLOWS UP AT 43-44 CBUFFERS BECASUE OF FSR    ////
//
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float custom_flags;

  float tone_map_hue_restore;
  float tone_map_blowout;
  //float custom_tone_map_midgray_adjust;

  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast_low;
  float tone_map_contrast_high;
  float tone_map_saturation;
  //float tone_map_adaptation_contrast;

  float custom_film_grain;
  float custom_random;
  float custom_chromatic_aberration;
  float custom_sharpening;
  float custom_vignette;
  //float shadow_debug_mode;
  //float shadow_disable_layer;
  float local_light_hue_correction;
  float local_light_saturation;

  //float ae_dark_power_outdoor;
  float ae_dynamism_high;
  float ae_dynamism_low;
  float ae_speed;

  float moon_disk_size;
  float lens_flare_strength;
  float bloom_strength;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injectedBuffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injectedBuffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_CRIMSONDESERT_SHARED_H_
