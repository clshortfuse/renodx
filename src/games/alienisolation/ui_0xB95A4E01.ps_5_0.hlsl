#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat Sep 21 23:16:38 2024

cbuffer Constants : register(b0)
{
  float4 cxmul : packoffset(c0);
}



// 3Dmigoto declarations
#define cmp -


void main(
  out float4 o0 : SV_Target0)
{
  o0.xyzw = cxmul.xyzw;
  // not sure if this does anything

  if (injectedData.clampAlpha == 1.f) o0.a = saturate(o0.a);

  o0.rgb = saturate(o0.rgb);
  o0.rgb = pow(o0.rgb, 2.2f);
  o0.rgb = renodx::color::bt2020::from::BT709(o0.rgb);
  o0.rgb = renodx::color::pq::from::BT2020(o0.rgb, 203.f);
  return;
}