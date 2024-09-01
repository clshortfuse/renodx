#include "./shared.h"

cbuffer cCommonTexParam : register(b0)
{
  float4 cCommonTexParam : packoffset(c0);
}

cbuffer cToneMapParam : register(b1)
{
  float4 cToneMapParam[2] : packoffset(c0);
}

SamplerState sInputS_s : register(s0);
SamplerState sToneMapS_s : register(s1);
Texture2D<float4> sInputT : register(t0);
Texture2D<float4> sToneMapT : register(t1);


float3 vanillaTonemapper(float3 color) {
  float colorLuminance = injectedData.toneMapType > 0 ? dot(color, float3(0.2126390059,0.7151686788,0.0721923154)) : dot(color, float3(0.298909992,0.586610019,0.114480004));  // fixed from vanilla's wrong BT.601 values
  float colorLuminanceTonemapped = cToneMapParam[0].z * colorLuminance; // some LUT exposure scaling
  float LUTCoordinate = lerp(cToneMapParam[1].x, cToneMapParam[1].y, saturate(colorLuminanceTonemapped)); // scale the LUT input range
  // This LUT can rebalance rgb colors by luminance (e.g. if they wanted to make bright colors more red, they could make the LUT return 1 0.5 0.5 for high input luminance coordinates).
  // This LUT is "relative" so it's ok to have its input coordinates clipped to 1.
  float3 LUTColorize = sToneMapT.Sample(sToneMapS_s, float2(LUTCoordinate, 0.5)).xyz;
  color *= LUTColorize;

  return color;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 outColor : SV_TARGET0)
{
  float4 r0 = sInputT.Sample(sInputS_s, v1.xy);

  float3 color = r0.rgb;
  outColor.w = r0.w;

  color *= cCommonTexParam.yyy;  // multiply in exposure

  if (injectedData.toneMapType == 0) {
    color = max(0, color);
  }

  // vanilla tonemapper
  color = color * color * sign(color);  // decode (linearize) with approximate gamma (2.0)
  color = vanillaTonemapper(color);
  color = sqrt(abs(color)) * sign(color); // re-encode (gammify) with approximate gamma (2.0)

  outColor.rgb = color;

  return;
}