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
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;

  r0.xyzw = t1.Sample(s0_s, v1.xy).xyzw;  // The backbuffer color texture
  r3.xyzw = t0.Sample(s1_s, v1.xy).xyzw;  // This is a fullscreen (stretched) filter texture. It affects contrast/brightness and color, like a sepia effect.

  bool4 isHighlight = r0.xyzw >= float4(0.5, 0.5, 0.5, 0.5);
  r2.xyzw = isHighlight ? 0 : 1;
  r1.xyzw = isHighlight ? 1 : 0;
  r4.xyzw = r3.xyzw * r0.xyzw;
  r3.xyzw = float4(1, 1, 1, 1) + -r3.xyzw;
  r2.xyzw = r4.xyzw * r2.xyzw;
  r2.xyzw = r2.xyzw + r2.xyzw;
  r4.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r0.xyzw;
  r4.xyzw = -r4.xyzw * float4(2, 2, 2, 2) + float4(1, 1, 1, 1);
  r3.xyzw = -r4.xyzw * r3.xyzw + float4(1, 1, 1, 1);
  r1.xyzw = r1.xyzw * r3.xyzw + r2.xyzw;
  r1.xyzw = r1.xyzw + -r0.xyzw;
  o0.xyzw = cb0[6].xxxx * r1.xyzw + r0.xyzw;

  return;
}
