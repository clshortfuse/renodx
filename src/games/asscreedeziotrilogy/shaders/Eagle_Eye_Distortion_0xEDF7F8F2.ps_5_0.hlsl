// Hand-decompiled from DXBC.
//
// Radial eagle-eye flare blur:
// 1. Compute radius^2 from screen UV v5.
// 2. Build a normalized radial direction and scale it by a center-clamped
//    distance factor from cb4[8]/cb4[9].
// 3. Sample t0 along that ray eight times with step size cb4[10].x / 7.
// 4. Bit-normalize every sample with cb3[44]/cb3[45].
// 5. Average the 8 taps.

#include ".././common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

cbuffer cb3 : register(b3) {
  float4 cb3[77];
}

float4 BitNorm(float4 c, float4 mask, float4 set) {
  return asfloat((asuint(c) & asuint(mask)) | asuint(set));
}

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    float4 v2 : COLOR0,
    float4 v3 : COLOR1,
    float4 v4 : TEXCOORD9,
    float4 v5 : TEXCOORD0,
    float4 v6 : TEXCOORD1,
    float4 v7 : TEXCOORD2,
    float4 v8 : TEXCOORD3,
    float4 v9 : TEXCOORD4,
    float4 v10 : TEXCOORD5,
    float4 v11 : TEXCOORD6,
    float4 v12 : TEXCOORD7,
    out float4 o0 : SV_TARGET0) {
  float radius2 = dot(v5.xy, v5.xy);
  float inv_radius2 = (radius2 > 0.f) ? rcp(radius2) : 0.f;

  float2 radial_xy = radius2 * v5.xy;
  float center_clamp = min(cb4[9].x, inv_radius2);
  float2 base_uv = radial_xy * center_clamp + cb4[8].xy;

  float edge_falloff = max(inv_radius2 - cb4[9].x, 0.f);
  float2 radial_dir = radial_xy * edge_falloff;

  const float tap_step = cb4[10].x * (1.f / 7.f);

  float4 sum = 0.f;
  [unroll]
  for (int i = 0; i < 8; ++i) {
    float t = 1.f + tap_step * i;
    float2 uv = radial_dir * t + base_uv;
    sum += BitNorm(t0.Sample(s0_s, uv), cb3[44], cb3[45]);
  }

  o0 = sum * 0.125f;

  //o0.rgb = saturate(o0.rgb);
  //o0.a = saturate(o0.a);
}
