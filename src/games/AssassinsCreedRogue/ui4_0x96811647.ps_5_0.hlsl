#include "./ui_white.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 16 11:26:48 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[130];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0;

  // Original shader logic
  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyzw = v2.xyzw * r0.xyzw;

  float4 uiColor = r0.xyzw * cb0[128].xyzw + cb0[129].xyzw;

  // Keep alpha sane
  uiColor.w = saturate(uiColor.w);

  // Apply RenoDX UI white point to RGB only
  uiColor.xyz = ScaleRogueUI(uiColor.xyz);

  o0.xyzw = uiColor;
  return;
}