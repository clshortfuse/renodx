#include "./common.hlsli"

Texture3D<float4> t33 : register(t33);
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
  float4 input_sample = t0.Sample(s0_s, v5.xy);
  uint4 input_bits = asuint(input_sample);
  input_bits = (input_bits & asuint(cb3[44])) | asuint(cb3[45]);
  input_sample = asfloat(input_bits);

  const float3 lut_input = input_sample.rgb * cb4[8].xyz + cb4[9].xyz;

  // The game packs pre-LUT scaling and 16x16x16 LUT addressing together.
  const float3 untonemapped_gamma = (lut_input - 0.03125f) / 0.9375f;
  const float3 untonemapped = renodx::color::gamma::DecodeSafe(untonemapped_gamma, 2.2f);

  o0.w = 0.f;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float4 graded_sample = t33.Sample(s1_s, lut_input);
    uint4 graded_bits = asuint(graded_sample);
    graded_bits = (graded_bits & asuint(cb3[46])) | asuint(cb3[47]);
    graded_sample = asfloat(graded_bits);

    float3 graded = renodx::color::gamma::DecodeSafe(max(0.f, graded_sample.rgb), 2.2f);
    graded = lerp(saturate(untonemapped), graded, RENODX_COLOR_GRADE_STRENGTH);
    o0.rgb = renodx::color::gamma::EncodeSafe(max(0.f, graded), 2.2f);
  } else {
    renodx::lut::Config lut_config = CreateLUTConfig(s1_s);
    const float scale = ComputeMaxChCompressionScale(untonemapped);

    const float3 color_sdr = untonemapped * scale;
    const float3 color_sdr_graded = Sample(t33, lut_config, color_sdr);
    const float3 color_final = color_sdr_graded / scale;

    o0.rgb = renodx::color::gamma::EncodeSafe(max(0.f, color_final), 2.2f);
  }

  o0.rgb = ToneMapAndRenderIntermediatePass(o0.rgb, v5.xy);
}
