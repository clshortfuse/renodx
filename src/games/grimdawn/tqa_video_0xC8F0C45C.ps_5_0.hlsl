// ---- Created with 3Dmigoto v1.3.16 on Thu Jul 03 02:08:56 2025

SamplerState VideoSampler_s : register(s0);
Texture2D<float4> VideoSamplerTex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = VideoSamplerTex.Sample(VideoSampler_s, v1.xy).xyz;
  o0.xyz = r0.zyx;
  o0.w = 1;

  o0.rgb = saturate(o0.rgb);
  return;
}