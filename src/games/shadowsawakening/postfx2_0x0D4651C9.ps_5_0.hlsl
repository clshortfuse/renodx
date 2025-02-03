#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float4 v2: COLOR0,
    float4 v3: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5, -0.5) + v1.xy;
  r0.xy = r0.xy + r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = cb0[2].x * r0.x;
  r0.x = -r0.x * 0.100000001 + 1;
  r0.y = 1 + -r0.x;
  r0.x = cb0[2].y * r0.y + r0.x;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyzw = r1.xyzw * r0.xxxx;
  o0.rgba = r0.rgba;
  if (injectedData.fxFilmGrain > 0.f) {
    o0.rgb = applyFilmGrain(o0.rgb, v1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
