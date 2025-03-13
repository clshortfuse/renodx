#include "../common.hlsl"

cbuffer _Globals : register(b4)
{
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

SamplerState AlphaMaskMapSampler_s : register(s3);
Texture2D<float4> AlphaMaskMapSampler : register(t3);
Texture2DMS<float4> RenderPointMapMSAA : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  RenderPointMapMSAA.GetDimensions(fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r0.xy = v1.xy * r0.xy;
  r0.xy = (int2)r0.xy;
  r0.zw = float2(0,0);
  r1.xyz = RenderPointMapMSAA.Load(r0.xy, 0).xyz;
  r2.xyz = RenderPointMapMSAA.Load(r0.xy, 1).xyz;
  r1.xyzw = r2.xyzx + r1.xyzx;
  r2.xyz = RenderPointMapMSAA.Load(r0.xy, 2).xyz;
  r0.xyz = RenderPointMapMSAA.Load(r0.xy, 3).xyz;
  r1.xyzw = r2.xyzx + r1.xyzw;
  r0.xyzw = r1.xyzw + r0.xyzx;
  r1.xyz = -r0.xyz * float3(0.25,0.25,0.25) + float3(1,1,1);
  r0.xyzw = float4(0.25,0.25,0.25,0.001953125) * r0.xyzw;
  r2.xyz = v3.xyz * float3(256,256,256) + float3(-128,-128,-128);
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = float3(0.0078125,0.0078125,0.0078125) * r1.xyz;
  r3.xyz = r2.xyz * r0.www;
  r2.xyz = cmp(float3(0,0,0) < r2.xyz);
  r1.xyz = r2.xyz ? r1.xyz : r3.xyz;
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