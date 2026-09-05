// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 06 10:58:54 2025

#include "./common.hlsl"

Texture2D<float4> t4 : register(t4); //linear under exposed

Texture2D<float4> t2 : register(t2); //bloom

SamplerState s4_s : register(s4);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[4];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[33];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  //declare
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 colorUntonemapped; 

  //sample bloom
  r0.xy = max(cb2[32].xy, v1.xy);
  r0.xy = min(cb2[32].zw, r0.xy);
  r0.xyz = t2.Sample(s0_s, r0.xy).xyz;
  r0.xyz = cb2[28].xxx * r0.xyz;
  Tonemap_BloomScale(r0);

  //sample color untonemapped
  r1.xy = max(cb2[31].xy, v1.xy);
  r1.xy = min(cb2[31].zw, r1.xy);
  r1.xyz = t4.Sample(s4_s, r1.xy).xyz;

  //bloom composite
  r0.xyz = cb2[28].yyy * r1.xyz + r0.xyz; //cb2[28].y some color multiplier that doesnt change

  //colorUntonemapped
  colorUntonemapped = r0.xyz * Tonemap_CalculatePreExposureMultiplier(cb4[0], cb4[1]/*, cb4[2]*/);
  
  //TONEMAP
  {
    //create mask for highlights
    r1.xyz = cmp(cb4[0].xxx >= r0.xyz); //cb4[0].x is threshold 
    r2.xyz = r1.xyz ? float3(0,0,0) : float3(1,1,1);
    r1.xyz = r1.xyz ? float3(1,1,1) : 0;
    
    //autoexposure + constrast + blowout. This can ruin luminance for HDR when they set a new black floor.
    r3.xyz = cb4[1].xxx * r2.xyz; //highlights
    r3.xyz = r1.xyz * cb4[2].xxx + r3.xyz;
    r4.xyz = cb4[1].zzz * r2.xyz; //shadows?
    r4.xyz = r1.xyz * cb4[2].zzz + r4.xyz;
    r3.xyz = r0.xyz * r3.xyz + r4.xyz;
    r4.xyz = cb4[1].yyy * r2.xyz; //mids?
    r2.xyz = cb4[1].www * r2.xyz;
    r2.xyz = r1.xyz * cb4[2].www + r2.xyz;
    r1.xyz = r1.xyz * cb4[2].yyy + r4.xyz;
    r0.xyz = r0.xyz * r1.xyz + r2.xyz;
    r0.xyz = r3.xyz / r0.xyz;
    r0.xyz = saturate(r0.xyz);

    //some pow, idk, situational.
    r0.xyz = log2(r0.xyz);
    r0.xyz = cb4[3].zzz * r0.xyz;
    r0.xyz = exp2(r0.xyz);
  }

  // float3 colorTonemapped = r0.xyz;

  //upgrade
  Tonemap_UpgradeTonemap0(colorUntonemapped, r0);

  //out
  // o0.xyz = r0.xyz;
  o0.xyz = RENODX_TONE_MAP_TYPE > 0 ? colorUntonemapped.xyz : r0.xyz;

  //recovery
  // o0.w = 1;
  o0.w = Tonemap_GetY(r0.xyz);
  return;
}