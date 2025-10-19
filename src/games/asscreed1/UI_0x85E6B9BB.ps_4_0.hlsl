#include "./shared.h"

SamplerState s0_s : register(s0);
Texture2D<float4> texture0 : register(t0);

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = texture0.Sample(s0_s, v2.xy).xyzw;
  o0.xyzw = v1.xyzw * r0.xyzw;

#if 0
  o0.rgb = renodx::color::gamma::DecodeSafe(o0.rgb);
  o0.rgb *= 20.f;
  o0.rgb = renodx::color::gamma::EncodeSafe(o0.rgb);
#endif

  return;
}
