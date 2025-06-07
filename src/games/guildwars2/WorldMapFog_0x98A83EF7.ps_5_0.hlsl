#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[2];
}

void main(
  float4 v0 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, v0.zw).xyzw;
  r2.xyzw = r1.xyzw + -r0.xyzw;
  r0.xyzw = r1.wwww * r2.xyzw + r0.xyzw;
  r0.w = dot(r0.ww, cb0[0].ww);
  o0.xyzw = r0.xyzw;
  if (injectedData.stateCheck == 3.f) {
  r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  o0.rgb = HalfWayScale(r0.xyz);
  }
  r0.x = -cb0[1].x + r0.w;
  if (r0.x < 0) discard;
  return;
}