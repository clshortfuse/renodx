// I thought this was tonemapping before I found 0xED64F186. I'll do some more investigating and see if this should go there instead.

#include "./shared.h"

SamplerState ColorSamplerSmp_s : register(s0);
Texture2D<float4> ColorSampler : register(t0);

void original(
  float2 v0: TEXCOORD0,
  out float4 o0: SV_TARGET0) 
{
  float4 r0;

  r0.xyz = ColorSampler.Sample(ColorSamplerSmp_s, v0.xy).xyz;
  r0.xyz = log(r0.xyz);
  r0.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r0.xyz;
  o0.xyz = exp(r0.xyz);
  o0.w = 1;
  return;
}

void main(
  float2 v0: TEXCOORD0,
  out float4 o0: SV_TARGET0) 
{
  float4 r0;
  float3 outputColor;

  r0.xyz = ColorSampler.Sample(ColorSamplerSmp_s, v0.xy).xyz;
  outputColor = r0.xyz;

  r0.xyz = log2(r0.xyz); 
  r0.xyz = (0.454545468) * r0.xyz; //Presumably some kind of color space conversion
  r0.xyz = exp2(r0.xyz);  


  if (RENODX_TONE_MAP_TYPE && RENODX_TONE_MAP_TYPE != 0.f ) { 
      outputColor = renodx::draw::ToneMapPass(outputColor);
  }
  else {
    outputColor = saturate(r0);
  }
  outputColor = renodx::draw::RenderIntermediatePass(outputColor);

  o0.rgb = outputColor;
  o0.w = 1;
  return;
}
