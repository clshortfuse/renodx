#include "./shared.h"

SamplerState Sampler_s : register(s0);
Texture2D<float4> Texture : register(t0);
Texture2D<float4> Base : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float4 v1 : COLOR0, float2 v2 : TEXCOORD0, out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = Base.Sample(Sampler_s, v2.xy).xyzw;

  // Convert to Linear
  r0.xyz = max(0, r0.xyz);
  r0.xyz = pow(r0.xyz, 2.2f);

  float vanillaMidGray = 0.18f;

  float renoDRTContrast = 1.0f;
  float renoDRTFlare = 0.0f;
  float renoDRTShadows = 1.0f;
  float renoDRTDechroma = 0.5f;
  float renoDRTSaturation = 1.0f;
  float renoDRTHighlights = 1.0f;

  renodx::tonemap::Config config = renodx::tonemap::config::Create(
      injectedData.toneMapType,
      injectedData.toneMapPeakNits,
      injectedData.toneMapGameNits,
      injectedData.toneMapGammaCorrection,
      injectedData.colorGradeExposure,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeShadows,
      injectedData.colorGradeContrast,
      injectedData.colorGradeSaturation,
      vanillaMidGray,
      vanillaMidGray * 100.f,
      renoDRTHighlights,
      renoDRTShadows,
      renoDRTContrast,
      renoDRTSaturation,
      renoDRTDechroma,
      renoDRTFlare);

  if (injectedData.toneMapType == 0) {
    r0.xyz = saturate(r0.xyz);
  }
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);

  if (injectedData.toneMapGammaCorrection) {
    // Convert to expected output
    r0.xyz = renodx::color::correct::GammaSafe(r0.xyz);

    // Adjust for shader transfer
    r0.xyz *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    r0.xyz = renodx::color::correct::GammaSafe(r0.xyz, true);
  } else {
    r0.xyz *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  }

  r0.xyz = sign(r0.xyz) * pow(abs(r0.xyz), 1.f / 2.2f);

  r1.xyzw = float4(1, 1, 1, 1) + -r0.xyzw;
  r1.xyzw = r1.xyzw + r1.xyzw;
  r2.xyzw = Texture.Sample(Sampler_s, v2.xy).xyzw;
  r3.xyzw = float4(1, 1, 1, 1) + -r2.xyzw;
  r1.xyzw = -r1.xyzw * r3.xyzw + float4(1, 1, 1, 1);
  r2.x = dot(r2.xx, r0.xx);
  r3.xyzw = cmp(r0.xyzw < float4(0.5, 0.5, 0.5, 0.5));
  o0.x = r3.x ? r2.x : r1.x;
  r0.x = dot(r2.yy, r0.yy);
  o0.y = r3.y ? r0.x : r1.y;
  r0.x = dot(r2.zz, r0.zz);
  r0.y = dot(r2.ww, r0.ww);
  o0.zw = r3.zw ? r0.xy : r1.zw;

  return;
}