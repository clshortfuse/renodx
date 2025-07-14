// ---- Created with 3Dmigoto v1.3.16 on Thu Feb  6 16:55:23 2025

cbuffer ParamBuffer : register(b1)
{
  float4 g_Param : packoffset(c0);
}

SamplerState g_Texture0Sampler_s : register(s0);
Texture2D<float4> g_Texture0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.xy = r0.xy * g_Param.zw + float2(0.5,0.5);
  r0.xyzw = g_Texture0.Sample(g_Texture0Sampler_s, r0.xy).xyzw;
  
  o0 = r0;
  return; // disables in-game brightness slider
  
  r1.xyz = log2(abs(r0.xyz));
  r1.xyz = g_Param.yyy * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.w = cmp(0 < (uint)g_Param.x); // decomp broken
  o0.xyz = r1.www ? r1.xyz : r0.xyz;
  o0.w = r0.w;
  return;
}