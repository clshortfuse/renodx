#include "./shared.h"
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[16];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;  // ui

  r1.xyz = t1.Sample(s1_s, v0.xy).xyz; // game

  // r0.xyz = max(float3(6.10351999e-05,6.10351999e-05,6.10351999e-05), r0.xyz);
  // r2.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) < r0.xyz);
  // r3.xyz = r0.xyz * float3(0.947867274,0.947867274,0.947867274) + float3(0.0521326996,0.0521326996,0.0521326996);
  // r3.xyz = log2(r3.xyz);
  // r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
  // r3.xyz = exp2(r3.xyz);
  // r0.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  // r0.xyz = r2.xyz ? r3.xyz : r0.xyz;
  if (RENODX_GAMMA_CORRECTION != 0.f && RENODX_TONE_MAP_TYPE != 0.f) {
    r0.rgb = renodx::color::gamma::DecodeSafe(r0.rgb, 2.2f);
  } else {
    r0.rgb = renodx::color::srgb::Decode(max(0, r0.rgb));
  }

  r2.x = dot(float3(0.212599993,0.715200007,0.0722000003), r0.xyz);
  r3.y = dot(float3(-0.114600003,-0.385399997,0.5), r0.xyz);
  r3.z = dot(float3(0.5,-0.4542,-0.0458000004), r0.xyz);
  r0.x = saturate(r2.x / cb0[13].z);
  r2.yz = r3.yz * r0.xx;
  r0.x = dot(float2(1,1.57480001), r2.xz);
  r0.y = dot(float3(1,-0.187299997,-0.468100011), r2.xyz);
  r0.z = dot(float2(1,1.8556), r2.xy);
  r2.xyz = saturate(float3(100,100,100) * r0.xyz);
  r3.xyz = r2.xyz * float3(-2,-2,-2) + float3(3,3,3);
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r2.xyz = r2.xyz * r0.xyz;
  r0.xyz = cb0[14].zzz ? r2.xyz : r0.xyz;
  r2.xyzw = cmp(asint(cb0[13].yyyy) == int4(1,2,3,4));
  r3.xyz = r2.www ? float3(1,0,0) : float3(1.70505154,-0.621790707,-0.0832583979);
  r4.xyz = r2.www ? float3(0,1,0) : float3(-0.130257145,1.14080286,-0.0105485283);
  r5.xyz = r2.www ? float3(0,0,1) : float3(-0.0240032747,-0.128968775,1.15297174);
  r3.xyz = r2.zzz ? float3(0.695452213,0.140678704,0.163869068) : r3.xyz;
  r4.xyz = r2.zzz ? float3(0.0447945632,0.859671116,0.0955343172) : r4.xyz;
  r5.xyz = r2.zzz ? float3(-0.00552588282,0.00402521016,1.00150073) : r5.xyz;
  r3.xyz = r2.yyy ? float3(1.02579927,-0.0200525094,-0.00577136781) : r3.xyz;
  r4.xyz = r2.yyy ? float3(-0.00223502493,1.00458264,-0.00235231337) : r4.xyz;
  r2.yzw = r2.yyy ? float3(-0.00501400325,-0.0252933875,1.03044021) : r5.xyz;
  r3.xyz = r2.xxx ? float3(1.37915885,-0.308850735,-0.0703467429) : r3.xyz;
  r4.xyz = r2.xxx ? float3(-0.0693352968,1.08229232,-0.0129620517) : r4.xyz;
  r2.xyz = r2.xxx ? float3(-0.00215925858,-0.0454653986,1.04775953) : r2.yzw;
  r5.x = dot(r3.xyz, float3(0.613191485,0.0702069029,0.0206188709));
  r5.y = dot(r3.xyz, float3(0.33951208,0.916335821,0.109567292));
  r5.z = dot(r3.xyz, float3(0.0473663323,0.0134500116,0.869606733));
  r3.x = dot(r4.xyz, float3(0.613191485,0.0702069029,0.0206188709));
  r3.y = dot(r4.xyz, float3(0.33951208,0.916335821,0.109567292));
  r3.z = dot(r4.xyz, float3(0.0473663323,0.0134500116,0.869606733));
  r4.x = dot(r2.xyz, float3(0.613191485,0.0702069029,0.0206188709));
  r4.y = dot(r2.xyz, float3(0.33951208,0.916335821,0.109567292));
  r4.z = dot(r2.xyz, float3(0.0473663323,0.0134500116,0.869606733));
  r2.x = dot(r5.xyz, r0.xyz);
  r2.y = dot(r3.xyz, r0.xyz);
  r2.z = dot(r4.xyz, r0.xyz);
 
  r0.rgb = renodx::color::pq::DecodeSafe(r1.rgb, 1.f);

  r1.x = cmp(0 < r0.w);
  r1.y = cmp(r0.w < 1);
  r1.x = r1.y ? r1.x : 0;
  if (r1.x != 0) {
    r1.x = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
    r1.x = r1.x / cb0[14].w;
    r1.x = 1 + r1.x;
    r1.x = 1 / r1.x;
    r1.x = r1.x * cb0[14].w + -1;
    r1.x = r0.w * r1.x + 1;
    r0.xyz = r1.xxx * r0.xyz;
  }
  r0.w = 1 + -r0.w;
  r1.xyz = cb0[14].www * r2.xyz;
  r1.rgb *= RENODX_GRAPHICS_WHITE_NITS; // r1.xyz = cb0[15].xxx * r1.xyz;

  r0.xyz = r0.xyz * r0.www + r1.xyz;  // combine game and UI

  o0.rgb = renodx::color::pq::EncodeSafe(r0.rgb, 1.f);

  o0.w = 1;
  return;
}