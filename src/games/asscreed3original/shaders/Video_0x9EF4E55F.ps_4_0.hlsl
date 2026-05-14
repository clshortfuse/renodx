// ---- Created with 3Dmigoto v1.3.16 on Wed May 13 18:56:48 2026
#include ".././common.hlsli"
cbuffer _Globals : register(b0)
{
  float4x4 g_WorldViewProj : packoffset(c0);
  float4 tor : packoffset(c4);
  float4 tog : packoffset(c5);
  float4 tob : packoffset(c6);
  float4 g_BinkConsts : packoffset(c7);
}

SamplerState tex0_s : register(s0);
Texture2D<float4> tex0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;

  r0.xyzw = tex0.Sample(tex0_s, v1.xy).xyzw;
  float3 video_rgb = r0.zyx;
  if (CUSTOM_VIDEO_HDR == 1.f) {
    const float safe_peak_white_nits = max(RENODX_PEAK_WHITE_NITS, 100.f);
    const float safe_diffuse_white_nits = max(RENODX_DIFFUSE_WHITE_NITS, 1.f);
    const float video_peak = safe_peak_white_nits / (safe_diffuse_white_nits / 100.f);

    float3 hdr_video = renodx::tonemap::inverse::bt2446a::BT709(video_rgb, 100.f, video_peak);
    hdr_video /= safe_diffuse_white_nits;
    video_rgb = ClampAndRenderIntermediatePass(max(0.f, hdr_video));
  }

  o0.xyz = video_rgb;
  o0.w = g_BinkConsts.w;

  //saturate
  o0.w = saturate(o0.w);
  return;
}
