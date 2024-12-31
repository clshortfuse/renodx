#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[7];
}

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float2 v2: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 sceneColor = t1.Sample(s0_s, v2.xy).xyzw;

  if (injectedData.isTonemapped == 1.f && injectedData.toneMapType == 1) {
    sceneColor.rgb = InverseToneMap(sceneColor.rgb);
  }

  float4 additiveFilterIntensity = t0.Sample(s1_s, v1.xy).xyzw;
  float4 additiveFilter = additiveFilterIntensity * cb0[6].xxxx;
  o0.xyzw = sceneColor + additiveFilter;

  if (injectedData.toneMapType == 1) {  // Exponential Rolloff
    o0.rgb = applyToneMap(o0.rgb);
  }
  return;
}
