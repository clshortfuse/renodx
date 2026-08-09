#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[136];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t2.SampleBias(s0_s, v1.xy, cb0[5].x).x;
  r0.x = -0.5 + r0.x;
  r0.x = dot(r0.xx, cb0[135].zz);
  r0.x = -cb0[132].w * 2 + r0.x;
  r0.y = cb0[132].w + cb0[132].w;
  r0.y = 1 / r0.y;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.z = r0.y * r0.x;
  r1.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r0.x = r0.y * r0.x + r1.w;
  r0.x = -r0.z * r1.w + r0.x;
  r2.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r2.xyz = renodx::color::srgb::DecodeSafe(r2.xyz);
  r0.y = max(r1.x, r1.y);
  r1.w = max(r0.y, r1.z);
  r1.xyzw = r1.xyzw + -r2.xyzw;
  r0.xyzw = r0.xxxx * r1.xyzw + r2.xyzw;
  o0.w = r0.w;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}