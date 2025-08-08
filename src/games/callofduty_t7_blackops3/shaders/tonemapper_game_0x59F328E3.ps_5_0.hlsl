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

  //color
  r0.xyz = codeTexture2.Sample(bilinearClamp_s, v0.xy).xyz; //log

  float3 colorUntonemapped = r0.xyz; //without bloom
  // colorUntonemapped = renodx::color::correct::Luminance(colorUntonemapped, 0.1, 1000);
  // colorUntonemapped = renodx::color::correct::GammaSafe(colorUntonemapped, true);
  // colorUntonemapped = renodx::color::srgb::DecodeSafe(colorUntonemapped);
  // colorUntonemapped = renodx::color::srgb::EncodeSafe(colorUntonemapped);
  // colorUntonemapped = renodx::color::gamma::DecodeSafe(colorUntonemapped);

  //compresses to normalized 01. does blowout, black floor raise. removing saturate unclamps values.
  r0.xyz = r0.xyz * v1.xxx + float3(0.00872999988,0.00872999988,0.00872999988);
  r0.xyz = log2(r0.xyz); //burh
  r0.xyz = saturate(r0.xyz * float3(0.0727029592,0.0727029592,0.0727029592) + float3(0.598205984,0.598205984,0.598205984));
  r1.xyz = r0.xyz * float3(7.71294689,7.71294689,7.71294689) + float3(-19.3115273,-19.3115273,-19.3115273);
  r1.xyz = r1.xyz * r0.xyz + float3(14.2751675,14.2751675,14.2751675);
  r1.xyz = r1.xyz * r0.xyz + float3(-2.49004531,-2.49004531,-2.49004531);
  r1.xyz = r1.xyz * r0.xyz + float3(0.87808305,0.87808305,0.87808305);
  r0.xyz = saturate(r1.xyz * r0.xyz + float3(-0.0669102818,-0.0669102818,-0.0669102818));
  float3 bloomBefore = r0.xyz;

  // float3 temp = r0.xyz;
  // float3 colorUntonemapped = r0.xyz;
  // {
  //   r0.xyz = colorUntonemapped;

  //   r0.xyz = r0.xyz * v1.xxx + float3(0.00872999988,0.00872999988,0.00872999988);
  //   r0.xyz = log2(r0.xyz);
  //   r0.xyz = (r0.xyz * float3(0.0727029592,0.0727029592,0.0727029592) + float3(0.598205984,0.598205984,0.598205984));
  //   r1.xyz = r0.xyz * float3(7.71294689,7.71294689,7.71294689) + float3(-19.3115273,-19.3115273,-19.3115273);
  //   r1.xyz = r1.xyz * r0.xyz + float3(14.2751675,14.2751675,14.2751675);
  //   r1.xyz = r1.xyz * r0.xyz + float3(-2.49004531,-2.49004531,-2.49004531);
  //   r1.xyz = r1.xyz * r0.xyz + float3(0.87808305,0.87808305,0.87808305);
  //   r0.xyz = (r1.xyz * r0.xyz + float3(-0.0669102818,-0.0669102818,-0.0669102818));
  //   // r0.xyz = exp2(r0.xyz);

  //   colorUntonemapped = r0.xyz;
  // }
  // r0.xyz = temp;

  // if (RENODX_TONE_MAP_TYPE == 2) {
  //   o0 = r0;
  //   // o0.xyz = renodx::color::correct::GammaSafe(o0.xyz, true);
  //   // o0.xyz = renodx::color::srgb::DecodeSafe(o0);
  //   return;
  // }
  
  //bloom (SDR Neutral 0-1)
  r1.xyz = codeTexture0.Sample(bilinearClamp_s, v0.xy).xyz;
  float3 bloomColor = r1.xyz;
  r1.xyz = saturate(float3(0.00390625233,0.00390625233,0.00390625233) * r1.xyz);
  r1.xyz = Bloom_ScaleTonemappedAfterSaturate(r1.xyz);
  r2.xyz = r1.xyz + r0.xyz;
  r0.xyz = -r0.xyz * r1.xyz + r2.xyz; //bloom is dependent on color, probably to make pronounced and not just straight addition?
  
  float3 bloomMask = r0.xyz - bloomBefore;
  colorUntonemapped = Bloom_AddScaled(colorUntonemapped, bloomMask * bloomColor); //add in bloom

  // if (RENODX_TONE_MAP_TYPE == 1) {
  //   o0 = r0;
  //   o0.xyz = v0.x < 0.5 ? renodx::color::gamma::DecodeSafe(o0) : renodx::color::srgb::DecodeSafe(o0);
  //   // o0.xyz = renodx::color::correct::GammaSafe(o0.xyz, true);
  //   return;
  // }
  
  //higher shadows
  r1.xyz = codeTexture4.Sample(bilinearClamp_s, v0.xy).xyz; //unkown what tex is for. RenderDoc shows black. is it only on occasions?
  r0.xyz = saturate(r1.xyz * float3(3.05175781e-005,3.05175781e-005,3.05175781e-005) + r0.xyz); //scales r1.xyz to 0-1
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);

  float3 colorSDRNetural = r0.xyz;

  // if (RENODX_TONE_MAP_TYPE == 2) {
  //   o0 = colorSDRNetural;
  //   o0.xyz = v0.x < 0.5 ? renodx::color::gamma::DecodeSafe(o0) : renodx::color::srgb::DecodeSafe(o0);
  //   // o0.xyz = renodx::color::correct::GammaSafe(o0.xyz, true);
  //   return;
  // }

  // if (RENODX_TONE_MAP_TYPE == 2) {
  //   o0 = colorUntonemapped;
  //   // o0.xyz = renodx::color::correct::GammaSafe(o0.xyz, true);
  //   // o0.xyz = renodx::color::gamma::Encode(o0.xyz); //WTH!?!?!?!
  //   o0.xyz = renodx::color::srgb::Encode(o0.xyz); //WTH!?!?!?!
  //   // o0.xyz = renodx::color::srgb::Decode(o0.xyz); //WTH!?!?!?!
  //   // o0.xyz = renodx::draw::ToneMapPass(o0.xyz);
  //   return;
  // }

  // o0 = r0;
  // return;

  //LUT (to 0-32768, will be decoded to sRGB in final
  // r0.xyz = codeTexture1.Sample(bilinearClamp_s, r0.xyz).xyz;
  r0.xyz = LUT_CorrectBlack(r0.xyz, codeTexture1.Sample(bilinearClamp_s, r0.xyz).xyz); 

  // if (RENODX_TONE_MAP_TYPE != 0) {
  //   // colorUntonemapped = renodx::color::correct::GammaSafe(colorUntonemapped.xyz, false);
  //   colorUntonemapped /= SDR_NOMRALIZATION_MAX;
  //   // colorUntonemapped.xyz = renodx::color::srgb::EncodeSafe(colorUntonemapped.xyz);
  //   colorUntonemapped.xyz = codeTexture1.Sample(bilinearClamp_s, colorUntonemapped.xyz);
  //   colorUntonemapped.xyz = renodx::color::srgb::DecodeSafe(colorUntonemapped.xyz);
  //   o0 = colorUntonemapped.xyz;
  //   return;
  // } else {
  //   r0.xyz = LUT_CorrectBlack(r0.xyz, codeTexture1.Sample(bilinearClamp_s, r0.xyz).xyz);
  // }


  // if (RENODX_TONE_MAP_TYPE == 2) {
  //   o0.xyz = r0.xyz / (SDR_NOMRALIZATION_MAX);
  //   // o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz); //NO
  //   return;
  // }

  // o0 = r0 / SDR_NOMRALIZATION_MAX;
  // return;

  // o0.xyz = r0.xyz;
  // if (RENODX_TONE_MAP_TYPE == 1) {
  //   o0 = colorUntonemapped;
  //   // o0.xyz = renodx::color::correct::GammaSafe(o0.xyz, true);
  //   // o0.xyz = renodx::color::correct::GammaSafe(o0.xyz, true);
  //   // o0.xyz = renodx::draw::ToneMapPass(o0.xyz);
  //   return;
  // }
  o0.xyz = Tonemap_Tradeoff_In(colorUntonemapped, r0.xyz, colorSDRNetural); //renodx tonemap

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