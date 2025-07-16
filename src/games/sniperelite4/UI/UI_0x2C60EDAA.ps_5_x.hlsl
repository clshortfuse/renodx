#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Jul 13 18:40:35 2025

SamplerState g_xTrilinearWrap_s : register(s2);
Texture2D<float4> g_xTexture1 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : Texcoords0,
  float4 v1 : Colour0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_xTexture1.Sample(g_xTrilinearWrap_s, v0.xy).xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.x = cmp(0.00392156886 >= r0.w);
  if (r1.x != 0) discard;
  o0.xyzw = r0.xyzw;
  
  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  
  return;
}