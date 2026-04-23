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
  float3 source_raw = max(0.f, input_sample.rgb);
  uint4 input_bits = asuint(input_sample);
  input_bits = (input_bits & asuint(cb3[44])) | asuint(cb3[45]);
  input_sample = asfloat(input_bits);
  float3 source_masked = max(0.f, input_sample.rgb);

  // Defensive path: in some wrapped passes the bit-mask remap can collapse a
  // valid source sample to near-black. Prefer raw sample in that case.
  bool masked_looks_broken =
      (dot(source_masked, 1.f) < 1e-5f) &&
      (dot(source_raw, 1.f) > 1e-3f);
  float3 source_sample = masked_looks_broken ? source_raw : source_masked;

  const float3 lut_input = source_sample * cb4[8].xyz + cb4[9].xyz;

  // The game packs pre-LUT scaling and 16x16x16 LUT addressing together.
  const float3 untonemapped_gamma = (lut_input - 0.03125f) / 0.9375f;
  const float3 untonemapped = renodx::color::gamma::DecodeSafe(untonemapped_gamma, 2.2f);

  o0.w = 0.f;

  // Some wrapped paths (e.g., prerendered videos) can hit this hash without a
  // valid 3D LUT bound. If the LUT probe looks invalid, fall back to source.
  float4 lut_probe_0 = t33.SampleLevel(s1_s, float3(0.5f, 0.5f, 0.5f), 0.f);
  float4 lut_probe_1 = t33.SampleLevel(s1_s, float3(0.25f, 0.75f, 0.5f), 0.f);
  bool lut_missing =
      !all(lut_probe_0 == lut_probe_0) ||
      !all(lut_probe_1 == lut_probe_1) ||
      (dot(abs(lut_probe_0), 1.f) < 1e-6f && dot(abs(lut_probe_1), 1.f) < 1e-6f);

  bool untonemapped_finite = all(untonemapped == untonemapped) && all(abs(untonemapped) < 65504.f);
  if (lut_missing || !untonemapped_finite || masked_looks_broken) {
    if (CUSTOM_VIDEO_HDR != 0.f) {
      const float safe_peak_white_nits = max(RENODX_PEAK_WHITE_NITS, 100.f);
      const float safe_diffuse_white_nits = max(RENODX_DIFFUSE_WHITE_NITS, 1.f);
      const float video_peak = safe_peak_white_nits / (safe_diffuse_white_nits / 100.f);

      float3 hdr_video = renodx::tonemap::inverse::bt2446a::BT709(source_raw, 100.f, video_peak);
      hdr_video /= max(video_peak, 1.f);  // normalize to 1.0 == peak

      o0.rgb = ClampAndRenderIntermediatePass(max(0.f, hdr_video));
    } else {
      o0.rgb = ToneMapAndRenderIntermediatePass(source_raw, v5.xy);
    }
    return;
  }

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
    bool color_final_finite = all(color_final == color_final) && all(abs(color_final) < 65504.f);

    o0.rgb = renodx::color::gamma::EncodeSafe(max(0.f, color_final_finite ? color_final : untonemapped), 2.2f);
  }

  // Leave the final HDR render transform to 0x788AFF56. That pass composites
  // the game's white-gradient/flare contribution after LUT grading, so moving
  // tone mapping there lets the tone mapper see the complete scene signal.
}
