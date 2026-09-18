// ---- Created with 3Dmigoto v1.3.16 on Tue Aug 12 12:05:13 2025
#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t2 : register(t2);

SamplerState s4_s : register(s4);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_IS_UI) {
    o0.xyz = t4.Sample(s4_s, v2.xy).xyz;
    o0.w = 1;
    return;
  }

  r0.xyz = t2.Sample(s0_s, v2.xy).xyz;
  r1.xyz = t4.Sample(s4_s, v2.xy).xyz;
  r0.xyz = -r1.xyz + r0.xyz;
  o0.xyz = v1.www * r0.xyz + r1.xyz;
  o0.w = 1;
  return;
}