#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = 1;
  r0.xyz = float3(1,1,1) + -cb0[3].xyz;
  r1.xyz = float3(0,0,-1) * r0.zzz;
  r0.xyzw = float4(0,-1,0,-1) * r0.xxyy;
  r2.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r2.z = 1;
  r1.xyz = cb0[3].zzz * r2.xyz + -r1.xyz;
  r1.xy = r1.xy / r1.zz;
  r1.xy = float2(1,1) + r1.xy;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  o0.z = r1.z;
  r1.xyz = cb0[3].xxx * r2.xyz + -r0.xxy;
  r0.xyz = cb0[3].yyy * r2.xyz + -r0.zzw;
  r0.xy = r0.xy / r0.zz;
  r0.xy = float2(1,1) + r0.xy;
  r0.xy = float2(0.5,0.5) * r0.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  o0.y = r0.y;
  r0.xy = r1.xy / r1.zz;
  r0.xy = float2(1,1) + r0.xy;
  r0.xy = float2(0.5,0.5) * r0.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  o0.x = r0.x;
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
  o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
  o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}