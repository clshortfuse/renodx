#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[136];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 / cb0[135].z;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, cb0[132].x).xyzw;
  r0.yzw = cb0[135].xxx * r1.xyz;
  o0.w = r1.w;
  if(injectedData.toneMapType == 0.f){
  r0.yzw = log2(abs(r0.yzw));
  r0.xyz = r0.xxx * r0.yzw;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(-0.217637643,-0.217637643,-0.217637643) + r0.xyz;
  r0.xyz = saturate(r0.xyz * cb0[135].yyy + float3(0.217637643,0.217637643,0.217637643));
  } else {
    r0.xyz = renodx::math::SignPow(r0.yzw, r0.x);
    r0.xyz = float3(-0.217637643,-0.217637643,-0.217637643) + r0.xyz;
    r0.xyz = r0.xyz * cb0[135].yyy + float3(0.217637643,0.217637643,0.217637643);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}