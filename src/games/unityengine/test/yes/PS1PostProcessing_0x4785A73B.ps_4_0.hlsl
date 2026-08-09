#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

// BECROWNED demo

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  o0.w = r0.w;
  r0.xyz = fastSrgbEncodeSafe(r0.xyz);
  r1.xyz = float3(3,3,3) + -r0.xyz;
  r0.xyz = -r1.xyz * cb0[4].www + r0.xyz;
  r1.xyz = float3(1,1,1) + -r0.xyz;
  r1.xyz = float3(0.25,0.25,0.25) * r1.xyz;
  r1.xyz = cb0[5].xxx * r1.xyz;
  r1.xyz = fastSrgbDecodeSafe(r1.xyz);
  r0.yzw = -r1.xyz + r0.xyz;
  r1.x = 0.5 + -r0.y;
  r1.x = 0.100000001 * r1.x;
  r1.x = cb0[5].x * r1.x;
  r1.y = r1.x * 0.305306017 + 0.682171106;
  r1.y = r1.x * r1.y + 0.0125228781;
  r0.x = r1.x * r1.y + r0.y;
  r0.xyz = cb0[3].xxx * r0.xzw;
  r0.xyz = floor(r0.xyz);
  r0.xyz = r0.xyz / cb0[3].xxx;
  if (injectedData.toneMapType == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  r0.xyz = fastSrgbDecodeSafe(r0.xyz);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}