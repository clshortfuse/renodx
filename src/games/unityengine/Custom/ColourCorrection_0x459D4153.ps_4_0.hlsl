#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = cb0[2].zzz * r0.xyz + float3(0.5,0.5,0.5);
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r0.xyz = cb0[2].yyy * r0.xyz;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = log2(r0.xyz);
  r0.w = 1 / cb0[2].x;
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, 1 / cb0[2].x);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}