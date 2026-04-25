#include "./shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

cbuffer cb3 : register(b3) {
  float4 cb3[77];
}

// 3Dmigoto declarations
#define cmp -

float3 ScaleUiBrightness(float3 color) {
  const float ui_scale = RENODX_GRAPHICS_WHITE_NITS / RENODX_PEAK_WHITE_NITS;

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color *= ui_scale;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color *= ui_scale;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
    color *= ui_scale;
    color = renodx::color::srgb::EncodeSafe(color);
  }

  return color;
}

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    linear centroid float4 v2 : COLOR0,
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
  float2 map_uv = v5.xy * float2(1.f, -1.f) + float2(0.f, 1.f);
  map_uv = map_uv * cb4[137].xy + cb4[138].xy;

  float4 map_sample = t1.Sample(s1_s, map_uv);
  uint4 map_bits = asuint(map_sample);
  map_bits = (map_bits & asuint(cb3[46])) | asuint(cb3[47]);
  map_sample = asfloat(map_bits);

  float4 base_sample = t0.Sample(s0_s, v5.xy);
  uint4 base_bits = asuint(base_sample);
  base_bits = (base_bits & asuint(cb3[44])) | asuint(cb3[45]);
  base_sample = asfloat(base_bits);

  base_sample.a *= map_sample.a;

  float4 color = v2 * cb4[136] * base_sample;
  o0 = color;
  o0.rgb = ScaleUiBrightness(o0.rgb);
}
