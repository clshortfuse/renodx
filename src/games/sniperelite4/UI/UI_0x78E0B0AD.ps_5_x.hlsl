#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Jul 13 18:40:39 2025



// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : Texcoords0,
  float4 v1 : Colour0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = v1.xyzw;
  
  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  
  return;
}