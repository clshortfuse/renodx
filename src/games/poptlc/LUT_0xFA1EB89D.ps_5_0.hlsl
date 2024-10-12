#include "LUTShared.hlsl"

Texture2D<float4> InternalGradingLUT : register(t1);
Texture2D<float4> SourceTexture : register(t0);
SamplerState sampler0 : register(s0);  // likely bilinear

// cbuffer cb0 : register(b0)
// {
//   float4 cb0[131];
// }

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 outColor : SV_Target0)
{  
  const float2 inCoords = v1.xy;

  float3 color;
  color = GetSceneColor(inCoords, SourceTexture, sampler0);
  color = ApplyExposure(color);
  color = ApplyLUT(inCoords, color, InternalGradingLUT, sampler0);

  outColor.rgb = color.rgb;
  outColor.a = 1;
  return;
}