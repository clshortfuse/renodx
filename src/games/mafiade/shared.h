#ifndef SRC_MAFIADE_SHARED_H_
#define SRC_MAFIADE_SHARED_H_

#ifndef __cplusplus
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
  float toneMapPerChannel;
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
  float colorGradeLUTSampling;
  float fxLensDirt;
  float fxBloom;
  float fxVignette;
  float fxFilmGrain;
  float fxFilmGrainType;
  float fxNoise;
  float fxHDRVideos;

  float random;
  float hasLoadedTitleMenu;
  bool is_swapchain_write;

  // Swap chain output state, refreshed from the swap chain that exists (OnInitSwapchain).
  // Two floats, so the constant buffer stays 8 rows and C++/HLSL layouts keep matching.
  float swap_chain_output_preset;       // 1 = HDR10 (PQ, BT.2020), 2 = scRGB (linear, BT.709)
  float swap_chain_output_dither_bits;  // 0 = off, else the bit depth the output is stored at
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_MAFIADE_SHARED_H_
