#include "./shared.h"

SamplerState SamplerGenericBilinearClamp_s : register(s13);
Texture2D<float4> textureMap : register(t0);
Texture2D<float4> scatterMap : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = textureMap.SampleLevel(SamplerGenericBilinearClamp_s, v1.xy, 0).xyzw;
  r1.xyzw = scatterMap.SampleLevel(SamplerGenericBilinearClamp_s, v1.xy, 0).xyzw;
  o0.xyz = r1.xyz + r0.xyz;
  o0.rgb *= CUSTOM_BLOOM;
  o0.w = 1;
  return;
}