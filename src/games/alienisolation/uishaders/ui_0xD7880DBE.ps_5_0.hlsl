#include "../common.hlsl"

// text on button qte when being attacked my joes

// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:37 2024

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
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex.Sample(sampler_tex_s, v2.xy).xyzw;
  o0.xyzw = r0.xyzw * v1.xyzw + v0.xyzw;

  o0 = UIScale(o0);
  return;
}