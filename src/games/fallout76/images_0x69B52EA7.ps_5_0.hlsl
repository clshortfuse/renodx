#include "../../shaders/color.hlsl"
#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:57 2024

cbuffer Constants : register(b0)
{
  float4 fsize : packoffset(c0);
  float4 offset : packoffset(c1);
  float4 scolor : packoffset(c2);
  float4 srctexscale : packoffset(c3);
  float4 texscale : packoffset(c4);
}

SamplerState sampler_srctex_s : register(s0);
SamplerState sampler_tex_s : register(s1);
Texture2D<float4> srctex : register(t0);
Texture2D<float4> tex : register(t1);


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

  r0.x = 0;
  r0.y = -fsize.x;
  while (true) {
    r0.z = cmp(fsize.x < r0.y);
    if (r0.z != 0) break;
    r1.x = offset.x + r0.y;
    r2.x = r0.x;
    r2.y = -fsize.y;
    while (true) {
      r0.z = cmp(fsize.y < r2.y);
      if (r0.z != 0) break;
      r1.y = offset.y + r2.y;
      r0.zw = r1.xy * texscale.xy + v2.xy;
      r0.z = tex.Sample(sampler_tex_s, r0.zw).w;
      r2.x = r2.x + r0.z;
      r2.y = 1 + r2.y;
    }
    r0.x = r2.x;
    r0.y = 1 + r0.y;
  }
  r0.x = fsize.w * r0.x;
  r0.x = saturate(fsize.z * r0.x);
  r0.yz = srctexscale.xy * v2.xy;
  r1.xyzw = srctex.Sample(sampler_srctex_s, r0.yz).xyzw;
  r0.x = scolor.w * r0.x;
  r0.xyzw = scolor.xyzw * r0.xxxx;
  r2.x = 1 + -r1.w;
  r0.xyzw = r0.xyzw * r2.xxxx + r1.xyzw;
  r1.xyz = v1.xyz;
  r1.w = 1;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyzw = v1.wwww * r0.xyzw;
  o0.xyzw = saturate(v0.xyzw * r0.wwww + r0.xyzw);

  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;

  return;
}