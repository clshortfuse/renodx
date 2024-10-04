#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:26 2024



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : COLOR1,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = v1.wwww * v0.wwww;

  if (injectedData.clampAlpha == 1.f) o0.a = saturate(o0.a);

  o0.rgb = saturate(o0.rgb);
  o0.rgb = pow(o0.rgb, 2.2f);
  o0.rgb = renodx::color::bt2020::from::BT709(o0.rgb);
  o0.rgb = renodx::color::pq::from::BT2020(o0.rgb, 203.f);
  return;
}