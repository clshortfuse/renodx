#ifndef SRC_TALES_OF_GRACES_F_SHARED_H_
#define SRC_TALES_OF_GRACES_F_SHARED_H_

#define RENODX_TONE_MAP_TYPE                 injectedData.toneMapType
#define RENODX_PEAK_NITS                     injectedData.toneMapPeakNits
#define RENODX_GAME_NITS                     injectedData.toneMapGameNits
#define RENODX_UI_NITS                       injectedData.toneMapUINits
#define RENODX_TONE_MAP_EXPOSURE             injectedData.colorGradeExposure
#define RENODX_TONE_MAP_HIGHLIGHTS           injectedData.colorGradeHighlights
#define RENODX_TONE_MAP_SHADOWS              injectedData.colorGradeShadows
#define RENODX_TONE_MAP_CONTRAST             injectedData.colorGradeContrast
#define RENODX_TONE_MAP_SATURATION           injectedData.colorGradeSaturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION injectedData.colorGradeHighlightSaturation
#define RENODX_TONE_MAP_BLOWOUT              injectedData.colorGradeBlowout
#define RENODX_TONE_MAP_FLARE                injectedData.colorGradeFlare
#define RENODX_EFFECT_BLOOM                  injectedData.fxBloom
#define RENODX_GAMMA_CORRECTION              1.f

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;

  float toneMapGammaCorrection;
  float toneMapHueShift;
  float toneMapHueCorrection;
  float toneMapHueProcessor;

  float toneMapPerChannel;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;

  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeHighlightSaturation;
  float colorGradeBlowout;

  float colorGradeFlare;
  float fxBloom;
  float padding03;
  float padding04;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_TALES_OF_GRACES_F_SHARED_H_