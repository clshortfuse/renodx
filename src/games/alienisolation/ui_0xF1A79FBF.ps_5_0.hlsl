#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu May 30 01:30:34 2024



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : COLOR1,
  out float4 o0 : SV_Target0)
{
  o0.w = saturate(v1.w * v0.w);
  o0.xyz = saturate(v0.xyz);

  o0.rgb = (injectedData.toneMapGammaCorrection
                ? pow(o0.rgb, 2.2f)
                : renodx::color::bt709::from::SRGB(o0.rgb));
  float3 colorBT2020 = renodx::color::bt2020::from::BT709(o0.rgb);
  o0.rgb = renodx::color::pq::from::BT2020(colorBT2020, injectedData.toneMapUINits);

  return;
}