// ---- Created with 3Dmigoto v1.3.16 on Wed Jul 30 21:52:18 2025

//Main Menu Final Draw to View Before UI

#include "../shared.h"
#include "../common.hlsl"

Texture2D<float4> t2 : register(t2); //dither/checker board

Texture2D<float4> t1 : register(t1); //noise

Texture2D<float4> t0 : register(t0); //color

SamplerState s2_s : register(s2); //billinea clamp

SamplerState s0_s : register(s0); //point wrap

cbuffer cb8 : register(b8)
{
  float4 cb8[3];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  //color
  r0.xyz = t0.Sample(s2_s, v1.xy).xyz;

  if (RENODX_TONE_MAP_TYPE != 0) {
    //renodx
    o0.xyz = Tradeoff_AfterFullscreenShaders(r0.xyz); 
  } else {
    //dither
    r0.xy = v1.xy * cb8[0].xy + cb8[0].zw;
    r0.x = t1.Sample(s2_s, r0.xy).x;

    //noise
    r0.x = cb8[1].x * r0.x;
    r0.yz = float2(0.0250000004,0.0250000004) * v0.xy;
    r0.yzw = t2.Sample(s2_s, r0.yz).xyz;
    r0.xyz = r0.xxx * r0.yzw;
    
    //postfx (settings brightness slider)
    r1.xyz = t0.Sample(s0_s, v1.xy).xyz; //color
    r1.xyz = r1.xyz * float3(3.05175781e-005,3.05175781e-005,3.05175781e-005) + r0.xyz;
    r1.xz = r0.zx * r1.yy + r1.xz;
    r0.xyz = log2(r1.xyz);
    r0.xyz = cb8[2].yyy * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = r0.xyz * cb8[2].zzz + cb8[2].www;

    //clamp values to nomarlized
    r2.xyz = cmp(cb8[1].www >= r1.xyz);
    r1.xyz = cb8[2].xxx * r1.xyz;
    r0.xyz = r2.xyz ? r1.xyz : r0.xyz;
    r0.xyz = cb8[1].yyy + r0.xyz;
    
    //decode srgb for RenderIntermediatePass
    // o0.xyz = v1.x < 0.5 ? renodx::color::gamma::DecodeSafe(r0.xyz) : renodx::color::srgb::DecodeSafe(r0.xyz);
    o0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }

  o0.w = 1.0f;
  o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz); 

  
  return;
}