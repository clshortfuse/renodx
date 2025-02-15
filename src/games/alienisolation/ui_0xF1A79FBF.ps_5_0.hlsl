#include "./common.hlsl"

void main(
    float4 v0: COLOR0,
    float4 v1: COLOR1,
    out float4 o0: SV_Target0) {
  o0.w = saturate(v1.w * v0.w);
  o0.xyz = v0.xyz;

  o0 = UIScale(o0);

  // makes overlay more transparent, fixing blending
  o0.a = renodx::color::gamma::DecodeSafe(o0.a, 2.2f);
  return;
}
