#include ".././common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

cbuffer cb3 : register(b3) {
  float4 cb3[77];
}

float2 GetVideoUV(float4 position, float4 texcoord) {
  float2 uv_from_texcoord = texcoord.xy;
  bool texcoord_is_normalized =
      all(uv_from_texcoord >= -0.001f) &&
      all(uv_from_texcoord <= 1.001f);
  if (texcoord_is_normalized) {
    return saturate(uv_from_texcoord);
  }

  bool texcoord_is_fullscreen =
      all(uv_from_texcoord >= -0.001f) &&
      all(uv_from_texcoord <= 2.001f);
  if (texcoord_is_fullscreen) {
    return saturate(uv_from_texcoord * 0.5f);
  }

  uint width, height;
  t0.GetDimensions(width, height);
  return saturate(position.xy / max(float2(width, height), 1.f.xx));
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
  float4 raw_sample = t0.Sample(s0_s, GetVideoUV(v0, v5));

  // Mirror original shader's bit-mask path, but keep a safe fallback for
  // wrapped/upgrade cases where mask constants are invalid and collapse video.
  uint4 masked_bits = asuint(raw_sample);
  masked_bits = (masked_bits & asuint(cb3[44])) | asuint(cb3[45]);
  float3 masked_rgb = asfloat(masked_bits).rgb;
  float3 raw_rgb = raw_sample.rgb;

  bool masked_looks_broken =
      (dot(masked_rgb, 1.f) < 1e-5f) &&
      (dot(raw_rgb, 1.f) > 1e-3f);
  float3 video_rgb = masked_looks_broken ? raw_rgb : masked_rgb;

  if (CUSTOM_VIDEO_HDR == 1.f) {
    const float safe_peak_white_nits = max(RENODX_PEAK_WHITE_NITS, 100.f);
    const float safe_diffuse_white_nits = max(RENODX_DIFFUSE_WHITE_NITS, 1.f);
    const float video_peak = safe_peak_white_nits / (safe_diffuse_white_nits / 100.f);

    float3 hdr_video = renodx::tonemap::inverse::bt2446a::BT709(video_rgb, 100.f, video_peak);
    // The rest of the pipeline expects scene-linear values where
    // 1.0 == diffuse white, not 1.0 == peak white.
    hdr_video /= safe_diffuse_white_nits;
    video_rgb = ClampAndRenderIntermediatePass(max(0.f, hdr_video));
  } else {
    video_rgb = ToneMapAndRenderIntermediatePass(video_rgb, GetVideoUV(v0, v5));
  }

  o0.rgb = video_rgb;
  o0.a = cb4[8].w;  // Preserve original alpha behavior for UI composition.
}
