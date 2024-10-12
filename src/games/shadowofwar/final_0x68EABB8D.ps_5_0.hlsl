#include "./DICE.hlsl"
// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 05 23:49:36 2024

cbuffer CBuffer_Data : register(b0) {
  float2 TexCoordScale0 : packoffset(c0);
  float2 MaxTexCoord0 : packoffset(c0.z);
  float2 Gamma : packoffset(c1);
}

SamplerState TextureSampler_s : register(s0);
Texture2D<float4> gameTexture : register(t0);
Texture2D<float4> uiTexture : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = TexCoordScale0.xy * v1.xy;
  r0.xy = min(MaxTexCoord0.xy, r0.xy);

  r0.xyz = gameTexture.SampleLevel(TextureSampler_s, r0.xy, 0).xyz;
  r0.xyz *= 80.f / 500.f;

  r0.xyz = renodx::color::grade::UserColorGrading(
      r0.xyz,
      injectedData.colorGradeExposure,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeShadows,
      injectedData.colorGradeContrast,
      injectedData.colorGradeSaturation,
      injectedData.colorGradeBlowout,
      0.f);

  r0.xyz *= injectedData.toneMapGameNits / 80.f;

  if (injectedData.toneMapType == 1) {
    r0.xyz = min(r0.xyz, 10000.f / 80.f);  // fixes artifacts on certain highlights that go 9999+
    DICESettings config = DefaultDICESettings();
    config.Type = 3u;
    config.ShoulderStart = 0.5f;
    r0.rgb = DICETonemap(r0.rgb, injectedData.toneMapPeakNits / 80.f, config);
  }

  r1.xyzw = uiTexture.SampleLevel(TextureSampler_s, v1.xy, 0).xyzw;
  r0.w = 1 + -r1.w;
  // r1.xyz = pow(r1.xyz, Gamma.xxx);    // Gamma on already linearized texture, covering up mismatch?
  // r1.xyz = Gamma.yyy * r1.xyz;        // Paper White
  r1.xyz = renodx::color::correct::GammaSafe(r1.xyz);
  r1.xyz *= injectedData.toneMapUINits / 80.f;
  o0.xyz = r0.xyz * r0.www + r1.xyz;
  o0.w = 1;
  return;
}
