#include "./common.hlsl"

cbuffer CBufferUserConstant_Z : register(b0){
  struct
  {
    float4 c[58];
  } User : packoffset(c0);
}

SamplerState sColorSampler_s : register(s0);
Texture2D<float4> sColor : register(t0);

void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float v3 : INSTANCE_COLOR0,
  uint2 v4 : INSTANCE_INDEXES0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sColor.Sample(sColorSampler_s, v2.xy).xyzw;
  o0.w = r0.w;
  o0.rgb = FinalizeOutput(r0.rgb);
  return;
}