// ---- Created with 3Dmigoto v1.3.16 on Fri May 30 13:34:02 2025

SamplerState g_samp0_s : register(s0);
Texture2D<float4> g_samp0Texture : register(t0);
Texture2D<float4> g_samp1Mask : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = g_samp1Mask.Sample(g_samp0_s, v2.zw).x;
  r1.xyzw = g_samp0Texture.Sample(g_samp0_s, v2.xy).xyzw;
  r1.w = r1.w * r0.x;
  r0.xyzw = v1.xyzw * r1.xyzw;
  o0.xyzw = saturate(r0.xyzw * float4(2,2,2,2) + v3.xyzw);
  return;
}