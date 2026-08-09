#include "../tonemap.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
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
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r1.x = saturate(cb0[135].y * cb0[135].x);
  if (r1.x > 0) {
    r1.y = -1 + cb0[133].w;
    r4.xyz = handleUserLUT(r0.xyz, t1, s1_s, float3(cb0[133].xy, cb0[133].w - 1));
    r1.yzw = handleUserLUT(r0.xyz, t2, s2_s, float3(cb0[133].xy, cb0[133].w - 1));
    r2.xyz = r4.xyz + -r1.yzw;
    r1.yzw = cb0[135].zzz * r2.xyz + r1.yzw;
    r1.yzw = renodx::color::srgb::DecodeSafe(r1.yzw);
    r1.yzw = r1.yzw + -r0.xyz;
    r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}