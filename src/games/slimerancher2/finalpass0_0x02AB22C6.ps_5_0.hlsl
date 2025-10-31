#include "./shared.h"
#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Fri Jul 25 17:02:22 2025
Texture2DArray<float4> t2 : register(t2);

Texture2DArray<float4> t1 : register(t1);

Texture2DArray<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[49];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[6];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0  : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r0.xy = cb1[48].xy * r0.xy;
  r0.z = 0;
  r0.xyzw = t1.SampleLevel(s0_s, r0.xyz, 0).xyzw;
  r1.xy = cb1[46].xy * v1.xy;
  r1.xy = (uint2)r1.xy;
  r1.xy = (uint2)r1.xy;
  r1.zw = float2(-1,-1) + cb1[46].xy;
  r1.zw = cb0[3].zw * r1.zw;
  r1.xy = r1.xy * cb0[3].xy + r1.zw;
  r1.xy = (uint2)r1.xy;
  r1.zw = float2(0,0);
  r2.xyz = t0.Load(r1.xyww).xyz;
  r1.x = t2.Load(r1.xyzw).x;
  
  float3 sceneColor = r0.www * r2.xyz + r0.xyz;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    sceneColor = saturate(sceneColor);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    float3 tonemap = ReinhardPiecewiseLuminance(sceneColor, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

    // hue shift
    float3 reinhardChannel = renodx::tonemap::Reinhard(sceneColor, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    float3 reinhardLuminance = Reinhardluminance(sceneColor, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    reinhardLuminance = blowout(reinhardLuminance, 0.13f);

    sceneColor = renodx::tonemap::UpgradeToneMap(tonemap, reinhardLuminance, reinhardChannel, 1.f);
    sceneColor = blowout(sceneColor, 0.12f);
    
  }

  float3 outputColor = renodx::draw::RenderIntermediatePass(sceneColor);
  o0.xyz = outputColor;

  r0.x = cmp(cb0[5].x == 1.000000);
  o0.w = r0.x ? r1.x : 1;
  return;
}


