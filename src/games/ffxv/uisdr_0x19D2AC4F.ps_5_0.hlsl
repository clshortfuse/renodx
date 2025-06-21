// ---- Created with 3Dmigoto v1.3.16 on Fri May 30 13:34:02 2025

SamplerState g_samp0_s : register(s0);
Texture2D<float4> g_samp0Texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : COLOR1,
  float2 v3 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = g_samp0Texture.Sample(g_samp0_s, v3.xy).x;
  r0.x = v1.w * r0.x;
  o0.w = r0.x * 1.33333337 + v2.w;
  o0.xyz = v2.xyz + v1.xyz;
  return;
}