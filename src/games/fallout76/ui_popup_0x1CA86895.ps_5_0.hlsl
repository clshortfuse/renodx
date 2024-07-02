#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Jun 13 16:15:03 2024

SamplerState sampler_tex_0__s : register(s0);
SamplerState sampler_tex_1__s : register(s1);
Texture2D<float4> tex_0_ : register(t0);
Texture2D<float4> tex_1_ : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : COLOR0, float2 v1 : TEXCOORD0, float2 w1 : TEXCOORD1, out float4 o0 : SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex_0_.Sample(sampler_tex_0__s, v1.xy).xyzw;
  r1.xyzw = tex_1_.Sample(sampler_tex_1__s, w1.xy).xyzw;
  r0.xyzw = -r1.xyzw + r0.xyzw;
  r0.xyzw = v0.xxxx * r0.xyzw + r1.xyzw;
  o0.w = v0.w * r0.w;
  o0.xyz = saturate(r0.xyz);  //  o0.xyz = r0.xyz;

  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::bt709::from::SRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;

  return;
}