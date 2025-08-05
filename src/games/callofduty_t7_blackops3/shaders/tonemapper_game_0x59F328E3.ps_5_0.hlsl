// ---- Created with 3Dmigoto v1.3.16 on Thu Jul 31 00:21:00 2025

//Main Output with Color, LUT, and Bloom

#include "../shared.h"
#include "../common.hlsl"

SamplerState bilinearClamp_s : register(s0);
Texture2D<float4> codeTexture0 : register(t0); //bloom
Texture3D<float3> codeTexture1 : register(t1); //lut
Texture2D<float4> codeTexture2 : register(t2); //color
Texture2D<float4> codeTexture4 : register(t4); //idk black


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  nointerpolation float v1 : TEXCOORD1,
  float4 v2 : SV_POSITION0,
  out float3 o0 : SV_TARGET0,
  out float o1 : SV_TARGET1)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  /*
  * Tonemapping from Rec709 Linear normalizes to 0-32768 (2^15), with highlight clipping. 
  */

  //color tonemapping 
  r0.xyz = codeTexture2.Sample(bilinearClamp_s, v0.xy).xyz; //linear
  float3 colorUntonemapped = r0.rgb; //without bloom

  r0.xyz = r0.xyz * v1.xxx + float3(0.00872999988,0.00872999988,0.00872999988);
  r0.xyz = log2(r0.xyz); 
  r0.xyz = saturate(r0.xyz * float3(0.0727029592,0.0727029592,0.0727029592) + float3(0.598205984,0.598205984,0.598205984));
  r1.xyz = r0.xyz * float3(7.71294689,7.71294689,7.71294689) + float3(-19.3115273,-19.3115273,-19.3115273);
  r1.xyz = r1.xyz * r0.xyz + float3(14.2751675,14.2751675,14.2751675);
  r1.xyz = r1.xyz * r0.xyz + float3(-2.49004531,-2.49004531,-2.49004531);
  r1.xyz = r1.xyz * r0.xyz + float3(0.87808305,0.87808305,0.87808305);
  r0.xyz = saturate(r1.xyz * r0.xyz + float3(-0.0669102818,-0.0669102818,-0.0669102818));
  
  //bloom w/ tonmapping + color
  r1.xyz = codeTexture0.Sample(bilinearClamp_s, v0.xy).xyz;
  colorUntonemapped = Bloom_AddScaled(colorUntonemapped, r1.xyz); //add in bloom

  r1.xyz = saturate(float3(0.00390625233,0.00390625233,0.00390625233) * r1.xyz);
  r1.xyz = Bloom_ScaleTonemappedAfterSaturate(r1.xyz);
  
  r2.xyz = r1.xyz + r0.xyz;
  r0.xyz = -r0.xyz * r1.xyz + r2.xyz; //bloom is dependent on color, probably to make pronounced and not just straight addition?
  r1.xyz = codeTexture4.Sample(bilinearClamp_s, v0.xy).xyz; //unkown what tex is for. RenderDoc shows black. is it only on occasions? 
  r0.xyz = saturate(r1.xyz * float3(3.05175781e-005,3.05175781e-005,3.05175781e-005) + r0.xyz);
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);

  // r0.xyz = codeTexture1.Sample(bilinearClamp_s, r0.xyz).xyz; //LUT
  r0.xyz = LUT_CorrectBlack(r0.xyz, codeTexture1.Sample(bilinearClamp_s, r0.xyz).xyz);
  // r0.xyz = LUT_CorrectWhite(r0.xyz, codeTexture1.Sample(bilinearClamp_s, r0.xyz).xyz);

  // o0.xyz = r0.xyz;
  o0.xyz = Tradeoff_Tonemap(colorUntonemapped, r0.xyz); //renodx tonemap

  //idk, and to unknown 2nd output
  r0.x = dot(r0.xyz, float3(6.48803689e-006,2.18261721e-005,2.20336915e-006));
  r0.y = log2(r0.x);
  r0.y = 0.333333343 * r0.y;
  r0.y = exp2(r0.y);
  r0.z = cmp(0.00885645207 < r0.x);
  r0.x = r0.x * 7.7870369 + 0.137931034;
  r0.x = r0.z ? r0.y : r0.x;
  o1.x = r0.x * 1.15999997 + -0.159999996; //unknown, maybe for aa and stuff?? RenderDoc says it's just 0-0.0000...01 black

  return;
}