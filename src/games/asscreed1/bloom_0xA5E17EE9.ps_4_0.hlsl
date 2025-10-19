#include "./common.hlsli"
cbuffer SCB_CommonPostEffect : register(b9) {
  float4 g_SampleWeights[8] : packoffset(c0);
}

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);
SamplerState s4_s : register(s4);
SamplerState s5_s : register(s5);
Texture2D<float4> texture0 : register(t0);
Texture2D<float4> texture1 : register(t1);
Texture2D<float4> texture2 : register(t2);
Texture2D<float4> texture3 : register(t3);
Texture2D<float4> texture4 : register(t4);
Texture2D<float4> texture5 : register(t5);

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = texture1.Sample(s1_s, v1.xy).xyzw;
  r0.xyzw = g_SampleWeights[1].xyzw * r0.xyzw;
  r1.xyzw = texture0.Sample(s0_s, v1.xy).xyzw;

  float3 input = r1.rgb;

  r0.xyzw = g_SampleWeights[0].xyzw * r1.xyzw + r0.xyzw;
  r1.xyzw = texture2.Sample(s2_s, v1.xy).xyzw;
  r0.xyzw = g_SampleWeights[2].xyzw * r1.xyzw + r0.xyzw;
  r1.xyzw = texture3.Sample(s3_s, v1.xy).xyzw;
  r0.xyzw = g_SampleWeights[3].xyzw * r1.xyzw + r0.xyzw;
  r1.xyzw = texture4.Sample(s4_s, v1.xy).xyzw;
  r0.xyzw = g_SampleWeights[4].xyzw * r1.xyzw + r0.xyzw;
  r1.xyzw = texture5.Sample(s5_s, v1.xy).xyzw;
  o0.xyzw = g_SampleWeights[5].xyzw * r1.xyzw + r0.xyzw;

  o0.rgb = lerp(input, o0.rgb, CUSTOM_BLOOM);

  return;
}
