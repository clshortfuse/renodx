#include "./shared.h"

// ---- Created with 3Dmigoto v1.2.45 on Sun Jan 25 21:40:22 2026

SamplerState sSam0_s : register(s0);
Texture2D<float4> sTex : register(t0);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD6,
  float4 v8 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
/* Vanilla
{
  const float4 icb[] = { 
    { 0.067539, 0, 0, 0},
    { 0.108629, 0, 0, 0},
    { 0.149119, 0, 0, 0},
    { 0.174713, 0, 0, 0},
    { 0.174713, 0, 0, 0},
    { 0.149119, 0, 0, 0},
    { 0.108629, 0, 0, 0},
    { 0.067539, 0, 0, 0}};
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 v[8] = { v0,v1,v2,v3,v4,v5,v6,v7 };
  r0.xyzw = float4(0,0,0,0);
  while (true) {
    r1.x = cmp((int)r0.w >= 8);
    if (r1.x != 0) break;
    r1.xyzw = sTex.Sample(sSam0_s, v[r0.w+1].xy).xyzw;
    r0.xyz = r1.xyz * icb[r0.w+0].xxx + r0.xyz;
    r0.w = (int)r0.w + 1;
  }
  o0.xyz = r0.xyz;
  o0.w = 0.75;
  return;
}
*/

{
    const float weights[8] =
        {
          0.067539,
          0.108629,
          0.149119,
          0.174713,
          0.174713,
          0.149119,
          0.108629,
          0.067539
    };

    float3 bloom = 0.0;

    bloom += sTex.Sample(sSam0_s, v1.xy).rgb * weights[0];
    bloom += sTex.Sample(sSam0_s, v2.xy).rgb * weights[1];
    bloom += sTex.Sample(sSam0_s, v3.xy).rgb * weights[2];
    bloom += sTex.Sample(sSam0_s, v4.xy).rgb * weights[3];
    bloom += sTex.Sample(sSam0_s, v5.xy).rgb * weights[4];
    bloom += sTex.Sample(sSam0_s, v6.xy).rgb * weights[5];
    bloom += sTex.Sample(sSam0_s, v7.xy).rgb * weights[6];
    bloom += sTex.Sample(sSam0_s, v8.xy).rgb * weights[7];

    o0.rgb = bloom;
    o0.a = 0.75;
    
    return;
}