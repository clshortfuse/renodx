#ifndef SRC_GUILDWARS2_SHARED_H_
#define SRC_GUILDWARS2_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;

  float toneMapGammaCorrection;
  float toneMapPerChannel;
  float toneMapHueProcessor;
  float toneMapHueShift;

  float toneMapHueCorrection;
  float toneMapShoulderStart;
  float colorGradeExposure;
  float colorGradeHighlights;

  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeBlowout;

  float colorGradeDechroma;
  float colorGradeFlare;
  float colorGradeClip;
  float colorGradeLUTStrength;
  
  float colorGradeLUTScaling;
  float colorGradeLUTSampling;
  float colorGradeTint;
  float fxBloom;

  float fxLightRays;
  float fxLightAdaptation;
  float fxFog;
  float fxBlur;

  float fxSelectionOutline;
  float fxVignette;
  float fxVignetteUW;
  float fxCA;

  float fxSharpen;
  float fxFlashbang;
  float fxFilmGrain;
  float fxFilmGrainType;

  float random_1;
  float random_2;
  float random_3;
  float stateCheck;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}
#define RENODX_TONE_MAP_TYPE                          shader_injection.toneMapType
#define RENODX_PEAK_WHITE_NITS                        shader_injection.toneMapPeakNits
#define RENODX_DIFFUSE_WHITE_NITS                     shader_injection.toneMapGameNits
#define RENODX_GRAPHICS_WHITE_NITS                    shader_injection.toneMapUINits

#define RENODX_GAMMA_CORRECTION                       shader_injection.toneMapGammaCorrection
#define RENODX_TONE_MAP_PER_CHANNEL                   shader_injection.toneMapPerChannel
#define RENODX_TONE_MAP_HUE_PROCESSOR                 shader_injection.toneMapHueProcessor
#define CUSTOM_COLOR_GRADE_HUE_SHIFT                  shader_injection.toneMapHueShift

#define CUSTOM_COLOR_GRADE_HUE_CORRECTION             shader_injection.toneMapHueCorrection
#define CUSTOM_TONE_MAP_SHOULDER_START                shader_injection.toneMapShoulderStart
#define RENODX_TONE_MAP_EXPOSURE                      shader_injection.colorGradeExposure
#define RENODX_TONE_MAP_HIGHLIGHTS                    shader_injection.colorGradeHighlights

#define RENODX_TONE_MAP_SHADOWS                       shader_injection.colorGradeShadows
#define RENODX_TONE_MAP_CONTRAST                      shader_injection.colorGradeContrast
#define RENODX_TONE_MAP_SATURATION                    shader_injection.colorGradeSaturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION          shader_injection.colorGradeBlowout

#define RENODX_TONE_MAP_BLOWOUT                       shader_injection.colorGradeDechroma
#define RENODX_TONE_MAP_FLARE                         shader_injection.colorGradeFlare
#define RENODX_RENO_DRT_WHITE_CLIP                    shader_injection.colorGradeClip
#define CUSTOM_LUT_STRENGTH                           shader_injection.colorGradeLUTStrength

#define CUSTOM_LUT_SCALING                            shader_injection.colorGradeLUTScaling
#define CUSTOM_LUT_SAMPLE                             shader_injection.colorGradeLUTSampling
#define CUSTOM_COLOR_TINT                             shader_injection.colorGradeTint
#define CUSTOM_BLOOM                                  shader_injection.fxBloom

#define CUSTOM_LIGHT_RAYS                             shader_injection.fxLightRays
#define CUSTOM_LIGHT_ADAPTATION                       shader_injection.fxLightAdaptation
#define CUSTOM_FOG                                    shader_injection.fxFog
#define CUSTOM_BLUR                                   shader_injection.fxBlur

#define CUSTOM_SELECTION_OUTLINE                      shader_injection.fxSelectionOutline
#define CUSTOM_VIGNETTE                               shader_injection.fxVignette
#define CUSTOM_VIGNETTE_UW                            shader_injection.fxVignetteUW
#define CUSTOM_CA                                     shader_injection.fxCA

#define CUSTOM_SHARPEN                                shader_injection.fxSharpen
#define CUSTOM_FLASHBANG                              shader_injection.fxFlashbang
#define CUSTOM_GRAIN_STRENGTH                         shader_injection.fxFilmGrain
#define CUSTOM_GRAIN_TYPE                             shader_injection.fxFilmGrainType

#define CUSTOM_RANDOM1                                shader_injection.random_1
#define CUSTOM_RANDOM2                                shader_injection.random_2
#define CUSTOM_RANDOM3                                shader_injection.random_3
#define CUSTOM_STATE_CHECK                            shader_injection.stateCheck
#endif
#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_GUILDWARS2_SHARED_H_
