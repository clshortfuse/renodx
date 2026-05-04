#include ".././common.hlsli"

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
  float4 r0 = t0.Sample(s0_s, v5.xy);

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    // Vanilla: original LUT pipeline, SDR-clamped grading
    float4 vanilla_input = r0;
    vanilla_input = asfloat(asuint(vanilla_input) & asuint(cb3[44]));
    vanilla_input = asfloat(asuint(vanilla_input) | asuint(cb3[45]));
    float3 lut_coords = vanilla_input.xyz * cb4[8].xyz + cb4[9].xyz;
    float4 vanilla = t33.Sample(s1_s, lut_coords);
    vanilla = asfloat(asuint(vanilla) & asuint(cb3[46]));
    vanilla = asfloat(asuint(vanilla) | asuint(cb3[47]));
    o0.xyz = vanilla.xyz;
    o0.w = 0;
    return;
  }

  // HDR path: decode gamma-encoded scene to linear so HDR values survive.
  float3 untonemapped = renodx::color::gamma::DecodeSafe(r0.xyz, 2.2f);

  // Compress max channel into [0,1] so we can route through the SDR LUT
  // without clipping highlights, then divide back out afterwards.
  float scale = ComputeMaxChCompressionScale(untonemapped);
  float3 color_sdr = untonemapped * scale;

  renodx::lut::Config lut_config = CreateLUTConfig(s1_s);
  float3 color_sdr_graded = Sample(t33, lut_config, color_sdr);

  float safe_scale = max(scale, 1e-4f);
  float3 color_hdr = color_sdr_graded / safe_scale;

  // Re-encode and route through the established intermediate pass, which
  // applies the user's tone mapper (type 1 = none/unlocked, type 2 = Neutwo),
  // film grain, diffuse/graphics nits scaling, and final EOTF encode.
  float3 color_hdr_gamma = renodx::color::gamma::EncodeSafe(color_hdr, 2.2f);
  o0.xyz = ToneMapAndRenderIntermediatePass(color_hdr_gamma, v0.xy);
  o0.w = 0;
}
