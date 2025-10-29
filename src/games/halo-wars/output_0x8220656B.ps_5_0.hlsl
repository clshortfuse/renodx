// ---- Created with 3Dmigoto v1.4.1 on Tue Oct 28 22:08:02 2025

cbuffer _Globals : register(b4)
{
  bool gUnswizzleTexels : packoffset(c0);
  float2 gTextureWidthHeight : packoffset(c0.y);
  float2 gTextureInvWidthHeight : packoffset(c1);
  float4 gMiddleGreyMax : packoffset(c2);
  float3 gRTransform : packoffset(c3);
  float3 gGTransform : packoffset(c4);
  float3 gBTransform : packoffset(c5);
  bool gDistortionEnabled : packoffset(c5.w);
  bool gColorTransformEnabled : packoffset(c6);
  bool gScreenBlurEnabled : packoffset(c6.y);
  float4 gScreenToViewZParams : packoffset(c7);
  float4 gDOFParams : packoffset(c8);
  float gExponentParams : packoffset(c9);
  float4 gBrightMaskParams : packoffset(c10);
  float4 gReduct4Add[4] : packoffset(c11);
  float4 gReduct1Mul : packoffset(c15);
  float4 gReduct1Add : packoffset(c16);
  float4 gReductAveMul : packoffset(c17);
  float4 gToneMapLimits : packoffset(c18);
  int gReduct1Width : packoffset(c19);
  int gReduct1Height : packoffset(c19.y);
  float4 gBloomFilterTapSamples[32] : packoffset(c20);
  float4 gBloomFilterTapScales[32] : packoffset(c52);
  int gBloomNumSamples : packoffset(c84);
  float4 gFilterAdaptationParams : packoffset(c85);
  float gContrast : packoffset(c86);
  float gGamma : packoffset(c86.y);
  float4 gGaussBlurOffsets[16] : packoffset(c87);
  float4 gGaussBlurWeights[16] : packoffset(c103);
  float4 gRadialBlur : packoffset(c119);
}

SamplerState gPointSampler_s : register(s0);
Texture2D<float4> gTexture0 : register(t0);


// 3Dmigoto declarations
#define cmp -


// Simple tone-mapping helper pass that samples the resolved HDR buffer and reapplies
// contrast/gamma before writing out the LDR bloom staging target.
void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Sample the prefiltered bloom buffer.
  r0.xyzw = gTexture0.Sample(gPointSampler_s, v0.xy).xyzw;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  o0.w = r0.w;
  // Gamma correct to linear, apply user contrast, then go back to display space.
  //r0.xyz = log2(r0.xyz);
  //r0.xyz = gGamma * r0.xyz;
  //r0.xyz = exp2(r0.xyz);
  o0.xyz = r0.xyz;
  return;
}