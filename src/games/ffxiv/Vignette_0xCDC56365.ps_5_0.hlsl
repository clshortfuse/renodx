#include "./shared.h"

cbuffer cVignettingParam : register(b0)
{
  float4 cVignettingParam[2] : packoffset(c0);
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;

  r0.xy = cVignettingParam[0].xy * v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = -cVignettingParam[0].z + r0.x;
  r0.x = r0.x * injectedData.vignetteStrength;
  o0.w = saturate(cVignettingParam[0].w * r0.x);
  o0.xyz = cVignettingParam[1].xyz;  // vignette color
  return;
}