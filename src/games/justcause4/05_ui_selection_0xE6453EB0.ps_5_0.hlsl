#include "./shared.h"

SamplerState sampler_tex_s : register(s0);
Texture2D<float4> tex : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : COLOR0, float4 v1 : TEXCOORD0, float4 v2 : TEXCOORD1, float2 v3 : TEXCOORD2, out float4 o0 : SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex.Sample(sampler_tex_s, v3.xy).xyzw;
  r0.xyzw = saturate(r0.xyzw * v2.xyzw + v1.xyzw);
  o0.w = v0.w * r0.w;
  o0.xyz = r0.xyz;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::srgb::Decode(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}