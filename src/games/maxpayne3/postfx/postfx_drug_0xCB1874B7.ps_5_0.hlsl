#include "../common.hlsl"

cbuffer _Globals : register(b4) {
  float4 TransColor : packoffset(c206);
  float4 TransPos : packoffset(c207);
  float4 TransTex0 : packoffset(c208);
  float4 TexelSize : packoffset(c209);
  float GammaCorrection : packoffset(c210);
  float g_fBilateralCoefficient : packoffset(c211);
  float4 refMipBlurParams : packoffset(c212);
  float4 SubViewportParams : packoffset(c213);
  float MaskAlphaReverse : packoffset(c214);
  float InterlaceIndex : packoffset(c215);
  float StencilTech : packoffset(c216);
  float InterlaceTotalNum : packoffset(c217);
  float2 RedOff : packoffset(c218);
  float2 GreenOff : packoffset(c219);
  float2 BlueOff : packoffset(c220);
  float2 poisson12[12] : packoffset(c224);
}

SamplerState RenderMapPointSampler_s : register(s1);
SamplerState AlphaMaskMapSampler_s : register(s3);
Texture2D<float4> RenderMapPointSampler : register(t1);
Texture2D<float4> AlphaMaskMapSampler : register(t3);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float4 v3: COLOR0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;

  r0.xyz = RenderMapPointSampler.Sample(RenderMapPointSampler_s, v1.xy).xyz;
  r1.xyz = float3(1, 1, 1) + -r0.xyz;
  r2.xyz = v3.xyz * float3(256, 256, 256) + float3(-128, -128, -128);
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = float3(0.0078125, 0.0078125, 0.0078125) * r1.xyz;
  r3.xyz = cmp(float3(0, 0, 0) < r2.xyz);
  r0.w = 0.0078125 * r0.x;
  r2.xyz = r0.www * r2.xyz;
  r1.xyz = r3.xyz ? r1.xyz : r2.xyz;
  r0.w = cmp(MaskAlphaReverse == 0.000000);
  r1.w = AlphaMaskMapSampler.Sample(AlphaMaskMapSampler_s, v2.xy).w;
  r2.x = 1 + -r1.w;
  r1.w = v3.w * r1.w;
  r2.x = v3.w * r2.x;
  r0.w = r0.w ? r1.w : r2.x;
  r1.w = cmp(0 < r0.w);
  o0.w = r0.w;
  r1.xyz = r1.www ? r1.xyz : 0;
  r0.xyz = r1.www ? r0.xyz : 0;
  o0.xyz = r0.xyz + r1.xyz;

  o0.rgb = PostFXScale(o0.rgb);
  return;
}
