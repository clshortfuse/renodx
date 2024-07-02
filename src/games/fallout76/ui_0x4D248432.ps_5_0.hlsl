#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:55 2024

SamplerState sampler_tex_s : register(s0);
Texture2D<float4> tex : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : COLOR0, float4 v1 : COLOR1, float2 v2 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex.Sample(sampler_tex_s, v2.xy).xyzw;
  r0.xyzw = -v0.xyzw + r0.xyzw;
  r0.xyzw = v1.xxxx * r0.xyzw + v0.xyzw;
  o0.w = v1.w * r0.w;
  o0.xyz = saturate(r0.xyz);  //  o0.xyz = r0.xyz;

  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::bt709::from::SRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;

  return;
}