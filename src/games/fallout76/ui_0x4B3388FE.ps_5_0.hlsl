#include "../../shaders/color.hlsl"
#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:54 2024

cbuffer Constants : register(b0)
{
  float4 fsize : packoffset(c0);
  float4 texscale : packoffset(c1);
}

SamplerState sampler_tex_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(0,0,0,0);
  r1.x = -fsize.x;
  while (true) {
    r1.y = cmp(fsize.x < r1.x);
    if (r1.y != 0) break;
    r1.yz = r1.xx * texscale.xy + v2.xy;
    r2.xyzw = tex.Sample(sampler_tex_s, r1.yz).xyzw;
    r0.xyzw = r2.xyzw + r0.xyzw;
    r1.x = 1 + r1.x;
  }
  r0.xyzw = fsize.wwww * r0.xyzw;
  r1.xyz = v1.xyz;
  r1.w = 1;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyzw = v1.wwww * r0.xyzw;
  o0.xyzw = saturate(v0.xyzw * r0.wwww + r0.xyzw);

  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;

  return;
}