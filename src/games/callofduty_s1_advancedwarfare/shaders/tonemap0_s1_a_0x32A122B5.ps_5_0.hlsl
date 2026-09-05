// ---- Created with 3Dmigoto v1.3.16 on Tue Aug 12 10:05:55 2025

#include "./common.hlsl"

Texture2D<float4> t4 : register(t4); //color

Texture2D<float4> t2 : register(t2); //bloom

SamplerState s4_s : register(s4);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[4];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[30];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  //declare
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 colorUntonemapped;
  
  //bloom
  r0.xy = max(cb2[29].xy, v1.xy);
  r0.xy = min(cb2[29].zw, r0.xy);
  r0.xyz = t2.Sample(s0_s, r0.xy).xyz;
  r0.xyz = cb2[27].xxx * r0.xyz;
  Tonemap_BloomScale(r0);

  //color
  r1.xy = max(cb2[28].xy, v1.xy);
  r1.xy = min(cb2[28].zw, r1.xy);
  r1.xyz = t4.Sample(s4_s, r1.xy).xyz;

  //bloom composite
  r0.xyz = cb2[27].yyy * r1.xyz + r0.xyz;

  //exposure multiplier
  float preExposureMultiplier = Tonemap_CalculatePreExposureMultiplier(cb4[0], cb4[1]);

  //colorUntonemapped
  colorUntonemapped = r0.xyz * preExposureMultiplier;

  //TONEMAP
  {
    r1.xyz = cmp(r0.xyz < cb4[0].xxx); //threshold
    r2.xyzw = r1.xxxx ? cb4[2].xyzw : cb4[1].xyzw; // cb4[2]: normal, cb4[1]: shadows
    r0.xw = r2.xy * r0.xx + r2.zw;
    r2.x = r0.x / r0.w;
    r2.x = saturate(r2.x);

    r3.xyzw = r1.yyyy ? cb4[2].xyzw : cb4[1].xyzw;
    r1.xyzw = r1.zzzz ? cb4[2].xyzw : cb4[1].xyzw;
    r0.xz = r1.xy * r0.zz + r1.zw;
    r0.yw = r3.xy * r0.yy + r3.zw;
    r2.yz = r0.yx / r0.wz;
    r2.yz = saturate(r2.yz);

    r0.xyz = r2.xyz; //out

    //pow, idk, situational
    r0.xyz = log2(r0.xyz);
    r0.xyz *= cb4[3].zzz;
    r0.xyz = exp2(r0.xyz);
  }

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