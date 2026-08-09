#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[2].xyxy * float4(0.5,-1,-1,-0.5) + v1.xyxy;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = cb0[2].xyxy * float4(1,0.5,-0.5,1) + v1.xyxy;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = -r0.xyz * float3(0.25,0.25,0.25) + r1.xyz;
  r2.xyz = float3(0.141591594,0.476323217,0.0480852015) * cb0[2].zzz;
  r0.x = dot(r0.xyz, r2.xyz);
  r0.x = max(-cb0[2].w, r0.x);
  r0.x = min(cb0[2].w, r0.x);
  o0.xyzw = r1.xyzw + r0.xxxx;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}