#include "./shared.h"

SamplerState smpAlbedo_s : register(s0);
Texture2D<float4> texAlbedo : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : COLOR0, float2 v1 : TEXCOORD0, float2 w1 : TEXCOORD1, out float4 o0 : SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(1.000000 == w1.x);
  if (r0.x != 0) {
    r0.xyz = v0.xyz;
  } else {
    r1.xyz = texAlbedo.Sample(smpAlbedo_s, v1.xy).xyz;
    r0.xyz = v0.xyz * r1.xyz;
  }
  o0.xyz = r0.xyz;
  o0.w = 1;

  // additions
  if (injectedData.toneMapType == 0.f) {
    o0.rgb = saturate(o0.rgb);
  } else {
    o0.rgb = max(0, o0.rgb);
  }

  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : renodx::color::srgb::Decode(o0.rgb);

  // tonemap here

  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.reno_drt_dechroma = injectedData.colorGradeBlowout;

  o0.rgb = renodx::tonemap::config::Apply(o0.rgb, config);

  o0.rgb *= injectedData.toneMapGameNits / 80.f;

  return;
}
