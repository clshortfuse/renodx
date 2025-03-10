#include "./common.hlsl"

SamplerState SampBase_s : register(s0);
Texture2D<float4> TexBase : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0: SV_POSITION0, float2 v1: TEXCOORD0, out float4 o0: SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = TexBase.Sample(SampBase_s, v1.xy).xyzw;
  o0.xyzw = r0.zyxw;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::srgb::Decode(o0.rgb);
  float scaling = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
  float videoPeak = 203.f * scaling;
  o0.rgb = renodx::tonemap::inverse::bt2446a::BT709(o0.rgb, 100.f / scaling, videoPeak);
  o0.rgb /= videoPeak;  // Normalize to 1.0
  o0.rgb *= injectedData.toneMapPeakNits / 80.f;

  o0.rgb /= injectedData.toneMapGameNits / 80.f;  // normalize paper white
  o0.rgb = renodx::color::gamma::EncodeSafe(o0.rgb, 2.2f);
  o0.rgb = GameScale(o0.rgb);
  return;
}
