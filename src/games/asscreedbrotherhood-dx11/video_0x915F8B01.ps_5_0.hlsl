#include "./common.hlsli"

Texture2D<float4> t0 : register(t0);
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
  float4 raw_sample = t0.Sample(s0_s, v5.xy);

  // Mirror original shader's bit-mask path, but keep a safe fallback for
  // wrapped/upgrade cases where mask constants are invalid and collapse video.
  uint4 masked_bits = asuint(raw_sample);
  masked_bits = (masked_bits & asuint(cb3[44])) | asuint(cb3[45]);
  float3 masked_rgb = saturate(asfloat(masked_bits).rgb);
  float3 raw_rgb = saturate(raw_sample.rgb);

  bool masked_looks_broken =
      (dot(masked_rgb, 1.f) < 1e-5f) &&
      (dot(raw_rgb, 1.f) > 1e-3f);
  float3 video_rgb = masked_looks_broken ? raw_rgb : masked_rgb;

  if (CUSTOM_VIDEO_HDR != 0.f) {
    const float safe_peak_white_nits = max(RENODX_PEAK_WHITE_NITS, 100.f);
    const float safe_diffuse_white_nits = max(RENODX_DIFFUSE_WHITE_NITS, 1.f);
    const float video_peak = safe_peak_white_nits / (safe_diffuse_white_nits / 100.f);

    float3 hdr_video = renodx::tonemap::inverse::bt2446a::BT709(video_rgb, 100.f, video_peak);
    hdr_video /= max(video_peak, 1.f);  // Normalize to 1.0 == peak.
    video_rgb = ClampAndRenderIntermediatePass(max(0.f, hdr_video));
  } else {
    video_rgb = ToneMapAndRenderIntermediatePass(video_rgb, v5.xy);
  }

  o0.rgb = video_rgb;
  o0.a = cb4[8].w;  // Preserve original alpha behavior for UI composition.
}
