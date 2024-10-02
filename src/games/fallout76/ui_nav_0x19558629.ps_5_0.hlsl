#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:47 2024

cbuffer Constants : register(b0) {
  float4 cmatadd : packoffset(c0);
  float4x4 cmatmul : packoffset(c1);
}

SamplerState sampler_tex_s : register(s0);
Texture2D<float4> tex : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : TEXCOORD0, float4 v1 : TEXCOORD1, float2 v2 : TEXCOORD2, out float4 o0 : SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex.Sample(sampler_tex_s, v2.xy).xyzw;
  r1.x = dot(r0.xyzw, cmatmul._m00_m10_m20_m30);
  r1.y = dot(r0.xyzw, cmatmul._m01_m11_m21_m31);
  r1.z = dot(r0.xyzw, cmatmul._m02_m12_m22_m32);
  r1.w = dot(r0.xyzw, cmatmul._m03_m13_m23_m33);
  r0.x = saturate(cmatadd.w + r0.w);
  r0.xyzw = saturate(cmatadd.xyzw * r0.xxxx + r1.xyzw);
  r1.xyz = v1.xyz;
  r1.w = 1;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyzw = v1.wwww * r0.xyzw;
  o0.xyzw = saturate(v0.xyzw * r0.wwww + r0.xyzw);

  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::srgb::Decode(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;

  return;
}