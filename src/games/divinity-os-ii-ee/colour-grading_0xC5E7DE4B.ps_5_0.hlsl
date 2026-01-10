// ---- Created with 3Dmigoto v1.4.1 on Sat Dec 27 06:33:23 2025

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float2 Params : packoffset(c0);
  float FadeValue : packoffset(c0.z);
}

SamplerState LinearClampSampler_s : register(s0);
Texture2D<float4> Base : register(t0);
Texture3D<float4> LUT : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TexCoord0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Load base color by integer pixel coords (no filtering)
  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r0.xyz = Base.Load(r0.xyz).xyz;

  // Normalize scene into Params.x..Params.y range (maps to ~0..10000 nits scale)
  // Keep this linear so ToneMapPass receives linear light
  r0.w = Params.y + -Params.x;
  r0.w = 10000 / r0.w;
  r1.x = Params.x * -r0.w;
  float3 scene_linear = r0.xyz * r0.www + r1.xxx;

  // Apply RenoDX tonemap (expects linear input in scene-referred space)
  float3 tonemapped = renodx::draw::ToneMapPass(scene_linear);
  float4 graded = float4(tonemapped, 1.0);

  // Fade to black controlled by FadeValue (0 = no fade, 1 = full black)
  r1.xyzw = float4(0,0,0,1) + -graded.xyzw;
  o0.xyzw = FadeValue * r1.xyzw + graded.xyzw;
  return;
}