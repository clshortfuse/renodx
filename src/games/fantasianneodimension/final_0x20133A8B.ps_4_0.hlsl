// ---- Created with 3Dmigoto v1.3.16 on Thu Dec  5 19:31:25 2024
// Final Shader

#include "./common.hlsl"

SamplerState BlitSampler_s : register(s0);
Texture2D<float4> BlitTexture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float2 v0 : TEXCOORD0,
    float4 v1 : SV_POSITION0,
    out float4 o0 : SV_Target0) {
  o0.xyzw = BlitTexture.Sample(BlitSampler_s, v0.xy).xyzw;

  o0.rgb = renodx::math::PowSafe(o0.rgb, 2.2f);

  if (injectedData.ColorGradeColorSpace == 1.f) {
    o0.rgb = renodx::color::bt709::from::BT709D93(o0.rgb);
  }

  o0.rgb *= injectedData.toneMapUINits / 80.f;  // Scale luminance -- The tonemapper has a ratio of injectedData.toneMapGameNits / injectedData.toneMapUINits

  o0.rgb = renodx::color::bt709::clamp::BT2020(o0.rgb);  // Clamp to BT2020 to avoid negative colors

  return;
}