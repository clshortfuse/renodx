#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.x = r0.w * v1.w + -0.00999999978;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.x = cmp(r1.x < 0);
  if (r1.x != 0) discard;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r1.x = 1 + -r1.w;
  o0.xyzw = r1.xxxx * r0.xyzw;
  o0.rgb = UIScale(o0.rgb);
  return;
}
