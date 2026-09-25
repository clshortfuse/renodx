#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

float3 vanillaTonemap(float3 x){
  float3 num = x * (x * 1.8f + 1.4f);
  float3 den = x * (x * 1.8f + 0.5f) + 1.5f;
return num / den;
}

float3 extendedTonemap(float3 color){
  bool extended = RENODX_TONE_MAP_TYPE != 0.f;
  float3 sdr_color = vanillaTonemap(color);
  float3 output_color;
  [branch]
  if (!extended) {
    output_color = saturate(sdr_color);
  } else {
    float compression_scale;
    GamutCompression(color, compression_scale);
    float3 hdr_color = color > 0.57525 ? 0.822236061199 * color + 0.114853983913 : vanillaTonemap(color);
    GamutDecompression(hdr_color, compression_scale);
    output_color = CorrectHueAndChrominanceOKLAB(hdr_color, sdr_color, RENODX_TONE_MAP_SDRIFY, RENODX_TONE_MAP_SDRIFY);
}
return output_color;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  o0.w = r0.w;
  r0.xyz = extendedTonemap(r0.xyz);
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}