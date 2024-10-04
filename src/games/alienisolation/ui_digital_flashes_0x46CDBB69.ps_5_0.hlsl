#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:10 2024



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : COLOR1,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v0.xyzw * v3.xyzw + v2.xyzw;
  r0.w = v1.w * r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;

  if (injectedData.clampAlpha == 1.f) o0.a = saturate(o0.a);

  o0.rgb = saturate(o0.rgb);
  o0.rgb = pow(o0.rgb, 2.2f);
  o0.rgb = renodx::color::bt2020::from::BT709(o0.rgb);
  o0.rgb = renodx::color::pq::from::BT2020(o0.rgb, injectedData.toneMapUINits);
  return;
}