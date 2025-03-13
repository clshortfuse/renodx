#include "./common.hlsl"

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

SamplerState AlphaMaskMapSampler_s : register(s3);
SamplerState InterlaceMapSampler_s : register(s4);
Texture2D<float4> AlphaMaskMapSampler : register(t3);
Texture2D<float4> InterlaceMapSampler : register(t4);
Texture2DMS<float4> RenderPointMapMSAA : register(t5);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float4 v3: COLOR0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  float4 fDest;

  r0.x = AlphaMaskMapSampler.Sample(AlphaMaskMapSampler_s, v2.xy).w;
  r0.y = cmp(0 < InterlaceTotalNum);
  if (r0.y != 0) {
    r0.y = 1 / InterlaceTotalNum;
    r0.z = InterlaceIndex * r0.y;
    r1.x = r0.y * 0.5 + r0.z;
    r1.y = v1.y;
    r0.y = InterlaceMapSampler.Sample(InterlaceMapSampler_s, r1.xy).w;
  } else {
    r0.y = 1;
  }
  r0.z = cmp(MaskAlphaReverse == 0.000000);
  r0.w = v3.w * r0.x;
  r0.x = 1 + -r0.x;
  r0.x = v3.w * r0.x;
  r0.xw = r0.xw * r0.yy;
  r0.x = r0.z ? r0.w : r0.x;
  RenderPointMapMSAA.GetDimensions(fDest.x, fDest.y, fDest.z);
  r0.yz = fDest.xy;
  r0.yz = v1.xy * r0.yz;
  r1.xy = (int2)r0.yz;
  r1.zw = float2(0, 0);
  r0.yzw = RenderPointMapMSAA.Load(r1.xy, 0).xyz;
  r1.xyz = RenderPointMapMSAA.Load(r1.xy, 1).xyz;
  r1.xyzw = r1.xyzx + r0.yzwy;
  r2.xyzw = float4(0.5, 0.5, 0.5, 0.00390625) * r1.xyzw;
  r0.y = cmp(0 < r0.x);
  r1.xyz = -r1.xyz * float3(0.5, 0.5, 0.5) + float3(1, 1, 1);
  r3.xyz = v3.xyz * float3(256, 256, 256) + float3(-128, -128, -128);
  r1.xyz = r3.xyz * r1.xyz;
  r4.xyz = cmp(float3(0, 0, 0) < r3.xyz);
  r1.xyz = float3(0.0078125, 0.0078125, 0.0078125) * r1.xyz;
  r3.xyz = r3.xyz * r2.www;
  r1.xyz = r4.xyz ? r1.xyz : r3.xyz;
  r2.xyz = r0.yyy ? r2.xyz : 0;
  r0.yzw = r0.yyy ? r1.xyz : 0;
  o0.xyz = r2.xyz + r0.yzw;
  o0.w = r0.x;

  o0.rgb = PostFXScale(o0.rgb);
  return;
}
