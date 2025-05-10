#include "./common.hlsl"

cbuffer g_constantsbuffer : register(b0) {
  struct
  {
    float4 rawUVadjust;
    float4 transitionAmounts;
    float1 bloomStrength;
    float _pad1;
    float _pad2;
    float _pad3;
  }
g_constants:
  packoffset(c0);
}
SamplerState g_correctionSampler_sampler_s : register(s0);
SamplerState g_colorSampler_sampler_s : register(s1);
SamplerState g_dofMotionBlurSampler_sampler_s : register(s2);
SamplerState g_bloomSampler_sampler_s : register(s3);
Texture2D<float4> g_correctionSampler_texture : register(t0);
Texture2D<float4> g_colorSampler_texture : register(t1);
Texture2D<float4> g_dofMotionBlurSampler_texture : register(t2);
Texture2D<float4> g_bloomSampler_texture : register(t3);

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_bloomSampler_texture.Sample(g_bloomSampler_sampler_s, v1.xy).xyzw;
  r0.xyz = g_constants.bloomStrength * r0.xyz * injectedData.fxBloom;
  r1.xyzw = g_dofMotionBlurSampler_texture.Sample(g_dofMotionBlurSampler_sampler_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * r1.www * injectedData.fxBlur + r0.xyz;
  r0.w = 1 + -r1.w * injectedData.fxBlur;
  r1 = applyCA(g_colorSampler_texture, g_colorSampler_sampler_s, v1, injectedData.fxCA);
  r0.rgb = r1.rgb * r0.aaa + r0.rgb;
  if (injectedData.fxVignette > 0.f) {
    r0.rgb = applyVignette(r0.rgb, v1, injectedData.fxVignette);
  }
  r0.rgb = applyUserTonemap(r0.rgb, g_correctionSampler_texture, g_correctionSampler_sampler_s);
  if (injectedData.FxaaCheck == 0.f) {
  if (injectedData.fxFilmGrain > 0.f) {
    r0.rgb = applyFilmGrain(r0.rgb, v1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.rgb = PostToneMapScale(r0.rgb);
  } else {
    o0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  }
  o0.a = renodx::color::y::from::BT709(r0.rgb);
  return;
}
