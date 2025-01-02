#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[7];
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0;

  r0.xy = -cb0[6].xy + v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.y = cb0[6].w + cb0[6].z;
  r0.x = r0.x * r0.y + -0.800000012;
  r0.y = cb0[6].z * 0.799000025 + -0.800000012;
  r0.y = 1 / r0.y;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  float4 sceneColor = t0.Sample(s0_s, v1.xy).xyzw;

  if (injectedData.isTonemapped == 1.f && injectedData.toneMapType == 1.f) {
    sceneColor.rgb = InverseExponentialToneMap(sceneColor.rgb);
  }

  o0.xyz = sceneColor.rgb * r0.xxx;

  if (injectedData.toneMapType == 1.f) {  // Exponential Rolloff
    o0.rgb = applyExponentialToneMap(o0.rgb);
  }

  o0.w = sceneColor.a;
  return;
}
