#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  if(injectedData.isClamped != 0.f){
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
    r0.xyz = rolloffSdr(r0.xyz);
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(cb0[7].zzz, r0.xyz);
  r1.x = max(r0.y, r0.z);
  r0.w = max(r1.x, r0.x);
  r1.x = 1 + r0.w;
  r1.x = 1 / r1.x;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r2.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r1.yzw = max(float3(0,0,0), r2.xyz);
  r2.xyz = min(cb0[7].zzz, r1.yzw);
  r1.y = max(r2.y, r2.z);
  r2.w = max(r2.x, r1.y);
  r1.y = 1 + r2.w;
  r1.y = 1 / r1.y;
  r0.xyzw = r2.xyzw * r1.yyyy + r0.xyzw;
  r1.x = r1.y + r1.x;
  r2.xyzw = t0.Sample(s0_s, w2.xy).xyzw;
  r1.yzw = max(float3(0,0,0), r2.xyz);
  r2.xyz = min(cb0[7].zzz, r1.yzw);
  r1.y = max(r2.y, r2.z);
  r2.w = max(r2.x, r1.y);
  r1.y = 1 + r2.w;
  r1.y = 1 / r1.y;
  r0.xyzw = r2.xyzw * r1.yyyy + r0.xyzw;
  r1.x = r1.x + r1.y;
  r2.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r1.yzw = max(float3(0,0,0), r2.xyz);
  r2.xyz = min(cb0[7].zzz, r1.yzw);
  r1.y = max(r2.y, r2.z);
  r2.w = max(r2.x, r1.y);
  r1.y = 1 + r2.w;
  r1.y = 1 / r1.y;
  r0.xyzw = r2.xyzw * r1.yyyy + r0.xyzw;
  r1.x = r1.x + r1.y;
  r1.x = 1 / r1.x;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r1.xyz = r0.xyz + -cb0[5].www;
  r0.xyz = max(float3(0,0,0), r1.xyz);
  o0.xyzw = min(cb0[5].yyyy, r0.xyzw);
  return;
}