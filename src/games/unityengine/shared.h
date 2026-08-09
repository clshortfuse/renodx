#ifndef SRC_UNITYENGINE_SHARED_H_
#define SRC_UNITYENGINE_SHARED_H_

#ifndef __cplusplus
#define RENODX_TONE_MAP_CLAMP_PEAK                    -1.f
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK        -1
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE -1
#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD   renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_NEUTRAL_SDR_WHITE_CLIP        20.f

#include "../../shaders/renodx.hlsl"
#endif

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;

  float toneMapGammaCorrection;
  float toneMapHueProcessor;
  float toneMapHueShift;
  float toneMapHueCorrection;

  float toneMapColorSpace;
  float toneMapPerChannel;
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
  float tonemapCheck;
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
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_UNITYENGINE_SHARED_H_