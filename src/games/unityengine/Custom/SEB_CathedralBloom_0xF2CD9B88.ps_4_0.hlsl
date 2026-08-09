#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[2].xyxy * float4(-0.5,-0.5,0.5,-0.5) + v0.xyxy;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = cb0[2].xyxy * float4(-0.5,0.5,0.5,0.5) + v0.xyxy;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r0.xyz = cb0[2].www * r0.xyz;
  r1.xyz = cb0[3].xxx * r0.xyz;
  r0.xyz = r0.xyz * cb0[3].xxx + float3(1,1,1);
  o0.xyz = r1.xyz / r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = 1;
  return;
}