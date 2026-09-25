#ifndef SRC_UNITYENGINE_SHARED_H_
#define SRC_UNITYENGINE_SHARED_H_

#define RENODX_TONE_MAP_CLAMP_PEAK                    -1.f
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK        -1
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE -1
#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD   renodx::tonemap::renodrt::config::tone_map_method::NEUTWO
#define RENODX_RENO_DRT_NEUTRAL_SDR_WHITE_CLIP        RENODX_TONE_MAP_SDR_CLIP

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;

  float toneMapGammaCorrection;
  float toneMapScaling;
  float toneMapSDRClip;
  float toneMapSDRify;

  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  
  float colorGradeSaturation;
  float colorGradeBlowout;
  float colorGradeDechroma;
  float colorGradeFlare;

  float colorGradeClip;
  float colorGradeInternalLUTStrength;
  float colorGradeInternalLUTScaling;
  float colorGradeInternalLUTShaper;

  float colorGradeLUTSampling;
  float colorGradeUserLUTStrength;
  float colorGradeUserLUTScaling;
  float colorGradeColorSpace;

  float fxBloom;
  float fxLens;
  float fxDoF;
  float fxVignette;

  float fxCA;
  float fxNoise;
  float fxFilmGrain;
  float fxFilmGrainType;

  float fxHdrBoost;
  float random;
  float countOld;
  float countNew;

  float count2Old;
  float count2New;
  float blitCopyHack;
  float gammaSpace;

  float isClamped;
  float swapchainProxy;
  float rolloffUI;
  float processing_use_scrgb;

  float isTonemapped;
  float padding02;
  float padding03;
  float padding04;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}
#define RENODX_TONE_MAP_TYPE                          shader_injection.toneMapType
#define RENODX_PEAK_WHITE_NITS                        shader_injection.toneMapPeakNits
#define RENODX_DIFFUSE_WHITE_NITS                     shader_injection.toneMapGameNits
#define RENODX_GRAPHICS_WHITE_NITS                    shader_injection.toneMapUINits

#define RENODX_GAMMA_CORRECTION                       shader_injection.toneMapGammaCorrection
#define RENODX_TONE_MAP_SCALING                       shader_injection.toneMapScaling
#define RENODX_TONE_MAP_SDR_CLIP                      shader_injection.toneMapSDRClip
#define RENODX_TONE_MAP_SDRIFY                        shader_injection.toneMapSDRify

#define RENODX_TONE_MAP_EXPOSURE                      shader_injection.colorGradeExposure
#define RENODX_TONE_MAP_HIGHLIGHTS                    shader_injection.colorGradeHighlights
#define RENODX_TONE_MAP_SHADOWS                       shader_injection.colorGradeShadows
#define RENODX_TONE_MAP_CONTRAST                      shader_injection.colorGradeContrast

#define RENODX_TONE_MAP_SATURATION                    shader_injection.colorGradeSaturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION          shader_injection.colorGradeBlowout
#define RENODX_TONE_MAP_BLOWOUT                       shader_injection.colorGradeDechroma
#define RENODX_TONE_MAP_FLARE                         shader_injection.colorGradeFlare

#define RENODX_RENO_DRT_WHITE_CLIP                    shader_injection.colorGradeClip
#define CUSTOM_INTERNAL_LUT_STRENGTH                  shader_injection.colorGradeInternalLUTStrength
#define CUSTOM_INTERNAL_LUT_SCALING                   shader_injection.colorGradeInternalLUTScaling
#define CUSTOM_INTERNAL_LUT_SHAPER                    shader_injection.colorGradeInternalLUTShaper

#define CUSTOM_LUT_SAMPLE                             shader_injection.colorGradeLUTSampling
#define CUSTOM_USER_LUT_STRENGTH                      shader_injection.colorGradeUserLUTStrength
#define CUSTOM_USER_LUT_SCALING                       shader_injection.colorGradeUserLUTScaling
#define CUSTOM_COLOR_SPACE                            shader_injection.colorGradeColorSpace

#define CUSTOM_BLOOM                                  shader_injection.fxBloom
#define CUSTOM_LENS                                   shader_injection.fxLens
#define CUSTOM_DOF                                    shader_injection.fxDoF
#define CUSTOM_VIGNETTE                               shader_injection.fxVignette

#define CUSTOM_CHROMATIC_ABERRATION                   shader_injection.fxCA
#define CUSTOM_NOISE                                  shader_injection.fxNoise
#define CUSTOM_FILM_GRAIN                             shader_injection.fxFilmGrain
#define CUSTOM_FILM_GRAIN_TYPE                        shader_injection.fxFilmGrainType

#define CUSTOM_HDR_BOO0ST                             shader_injection.fxHdrBoost
#define CUSTOM_RANDOM                                 shader_injection.random
#define CUSTOM_COUNT_OLD                              shader_injection.countOld
#define CUSTOM_COUNT_NEW                              shader_injection.countNew

#define CUSTOM_COUNT_NEW_2                            shader_injection.count2New
#define CUSTOM_COUNT_OLD_2                            shader_injection.count2Old
#define CUSTOM_BLIT_COPY_HACK                         shader_injection.blitCopyHack
#define CUSTOM_GAMMA_SPACE                            shader_injection.gammaSpace

#define CUSTOM_IS_CLAMPED                             shader_injection.isClamped
#define CUSTOM_SWAPCHAIN_PROXY                        shader_injection.swapchainProxy
#define CUSTOM_ROLLOFF_UI                             shader_injection.rolloffUI
#define CUSTOM_SWAPCHAIN_USE_SCRGB                    shader_injection.processing_use_scrgb

#define CUSTOM_IS_TONEMAPPED                          shader_injection.isTonemapped
#define CUSTOM_COUNT_IS_EQUAL                         shader_injection.countOld == shader_injection.countNew
#define CUSTOM_COUNT_2_IS_EQUAL                       shader_injection.count2Old == shader_injection.count2New

#endif
#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_UNITYENGINE_SHARED_H_