// ---- Created with 3Dmigoto v1.3.16 on Tue Feb 24 22:33:02 2026

// Lost soul aside native hdr objective marker/text fix
// Doesnt respect any sliders

// decode PQ -> bt709 from bt 2020 -> run vanilla code
// sRGB decode in that one branch
// bt2020 from bt709 -> pq encode
// graphics nits for pq scale

#include "../../common.hlsli"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

// 3Dmigoto declarations
#define cmp -

void main(float2 v0: TEXCOORD0, float4 v1: TEXCOORD1, float4 v2: TEXCOORD2,
          float4 v3: SV_Position0, out float4 o0: SV_Target0,
          out float4 o1: SV_Target1) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  if (PROCESSING_PATH == 0.f) {
    r0.rgb = renodx::color::pq::DecodeSafe(r0.rgb, RENODX_GRAPHICS_WHITE_NITS);
    r0.rgb = renodx::color::bt709::from::BT2020(r0.rgb);
  }

  r1.xyzw = cmp(cb0[0].xyzw != float4(0, 0, 0, 0));
  r1.xy = (int2)r1.zw | (int2)r1.xy;
  r1.x = (int)r1.y | (int)r1.x;
  r1.y = dot(r0.xyzw, cb0[0].xyzw);
  r0.xyzw = r1.xxxx ? r1.yyyy : r0.xyzw;
  r0.w = dot(r0.xyzw, cb0[1].xyzw);
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.x = cmp(cb0[2].x != 1.000000);
  if (r1.x != 0) {
    r0.xyz = saturate(r0.xyz);
    r1.x = 2.20000005 * cb0[2].x;
    r1.yzw = log2(r0.xyz);
    r1.xyz = r1.xxx * r1.yzw;
    r2.xyz = exp2(r1.xyz);
    r3.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r2.xyz;
    r2.xyz = cmp(r2.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
    r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r0.xyz = r2.xyz ? r1.xyz : r3.xyz;

    if (PROCESSING_PATH == 0.f) {
      r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
    }
  }
  o0.xyzw = r0.xyzw;
  o1.xyzw = float4(0, 0, 0, 0);

  if (PROCESSING_PATH == 0.f) {
    o0.rgb = renodx::color::bt2020::from::BT709(o0.rgb);
    o0.rgb = renodx::color::pq::EncodeSafe(o0.rgb, RENODX_GRAPHICS_WHITE_NITS);
    o0 = saturate(o0);
  }

  return;
}
