#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

#define RENODX_PEAK_WHITE_NITS shader_injection.toneMapPeakNits
#define RENODX_GRAPHICS_WHITE_NITS shader_injection.toneMapUINits
#define RENODX_SWAP_CHAIN_DECODING renodx::draw::ENCODING_NONE
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET shader_injection.swapChainOutputPreset

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeBlowout;
  float hueCorrectionStrength;
  float gamutExpansion;
  float diceShoulderStart;
  float blackFloorOffset;
  float bloomRadiusMult;
  float vignetteStrength;

  int copyTracker;
  float swapChainOutputPreset;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define injectedData shader_injection

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_TEMPLATE_SHARED_H_
