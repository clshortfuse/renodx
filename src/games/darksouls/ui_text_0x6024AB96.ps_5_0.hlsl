#include "../../shaders/color.hlsl"
#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Tue Jun 04 23:18:20 2024

cbuffer _Globals : register(b0) {
  float4 gFC_FontSharpParam : packoffset(c0);
  float4x4 gVC_WorldViewClipMtx : packoffset(c1);
  float4 gVC_FontSharpParam : packoffset(c5);
}

SamplerState g_TextureSampler_s : register(s0);
Texture2D<float4> g_Texture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : SV_Position0, float4 v1
          : COLOR0, float4 v2
          : TEXCOORD0, float4 v3
          : TEXCOORD1, float4 v4
          : TEXCOORD2, out float4 o0
          : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_Texture.Sample(g_TextureSampler_s, v3.xy).xyzw;
  r1.xyzw = g_Texture.Sample(g_TextureSampler_s, v2.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(5, 5, 5, 5) + -r0.xyzw;
  r1.xyzw = gFC_FontSharpParam.yyyy * r1.xyzw;
  r2.xyzw = g_Texture.Sample(g_TextureSampler_s, v3.zw).xyzw;
  r0.xyzw = -r2.xyzw + r0.xyzw;
  r2.xyzw = g_Texture.Sample(g_TextureSampler_s, v4.xy).xyzw;
  r0.xyzw = -r2.xyzw + r0.xyzw;
  r2.xyzw = g_Texture.Sample(g_TextureSampler_s, v4.zw).xyzw;
  r0.xyzw = -r2.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw * gFC_FontSharpParam.xxxx + r1.xyzw;
  o0.xyzw =
      saturate(v1.xyzw * r0.xyzw); // Added saturate() to cap text brightness

  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f)
                                               : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;

  return;
}