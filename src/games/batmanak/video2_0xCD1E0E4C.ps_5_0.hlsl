#include "./shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0: COLOR0, float4 v1: TEXCOORD0, float4 v2: TEXCOORD1, float2 v3: TEXCOORD2, out float4 o0: SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t2.Sample(s2_s, v3.xy).x;
  r0.x = -0.501960814 + r0.x;
  r0.xyz = float3(1.59599996, -0.813000023, 0) * r0.xxx;
  r0.w = t0.Sample(s0_s, v3.xy).x;
  r0.w = -0.0627451017 + r0.w;
  r0.xyz = r0.www * float3(1.16400003, 1.16400003, 1.16400003) + r0.xyz;
  r0.w = t1.Sample(s1_s, v3.xy).x;
  r0.w = -0.501960814 + r0.w;
  r0.xyz = r0.www * float3(0, -0.39199999, 2.01699996) + r0.xyz;
  r0.w = 1;
  r0.xyzw = r0.xyzw * v2.xyzw + v1.xyzw;
  r0.xyz = saturate(r0.xyz);
  o0.w = v0.w * r0.w;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[5].www * r0.xyz;
  o0.xyz = exp2(r0.xyz);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    o0.rgb = renodx::draw::UpscaleVideoPass(o0.rgb);
  }

  o0.rgb = renodx::color::srgb::Decode(o0.rgb);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  return;
}
