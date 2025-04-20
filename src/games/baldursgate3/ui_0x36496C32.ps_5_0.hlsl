#include "./shared.h"
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TexCoord0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r1.x = cmp(r0.w < 0.00100000005);
  if (r1.x != 0) {
    r1.xyz = t0.SampleLevel(s0_s, v1.xy, 0).xyz;
  } else {
    r1.w = cmp(r0.w == 1.000000);
    if (r1.w != 0) {  // most UI elements
      if (!RENODX_GAMMA_CORRECTION) {
        r2.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
      } else {
        r2.rgb = renodx::color::gamma::DecodeSafe(r0.rgb, 2.2f);
      }
      r3.rgb = renodx::color::bt2020::from::BT709(r2.rgb);

      r1.rgb = renodx::color::pq::EncodeSafe(r3.rgb, RENODX_GRAPHICS_WHITE_NITS);  // cb0[0].x
    } else {                                                                       // some other UI elements
      r2.xyz = t0.SampleLevel(s0_s, v1.xy, 0).xyz;
      r2.rgb = renodx::color::pq::DecodeSafe(r2.rgb, 1.f);

      r2.xyz = r0.www * -r2.xyz + r2.xyz;

      if (!RENODX_GAMMA_CORRECTION) {
        r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
      } else {
        r0.rgb = renodx::color::gamma::DecodeSafe(r0.rgb, 2.2f);
      }

      r3.rgb = renodx::color::bt2020::from::BT709(r0.rgb);
      r0.xyz = r0.www * -r2.xyz + r2.xyz;

      r0.xyz = r3.xyz * RENODX_GRAPHICS_WHITE_NITS + r0.xyz;  // cb0[0].x

      r1.rgb = renodx::color::pq::EncodeSafe(r0.rgb, 1.f);
    }
  }
  o0.xyz = r1.xyz;
  o0.w = 1;
  return;
}
