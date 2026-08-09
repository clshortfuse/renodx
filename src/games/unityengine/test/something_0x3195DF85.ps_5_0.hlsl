#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Gather(s0_s, v1.xy).xyzw;
  r1.x = r0.x;
  r2.xyzw = t0.Gather(s0_s, v1.xy).xzyw;
  r1.y = r2.x;
  r3.xyzw = t0.Gather(s0_s, v1.xy).xywz;
  r1.z = r3.x;
  r4.x = r0.y;
  r4.y = r2.z;
  r4.z = r3.y;
  r1.xyz = r4.xyz + r1.xyz;
  r2.x = r0.z;
  r3.x = r0.w;
  r3.y = r2.w;
  r2.z = r3.w;
  r0.xyz = r2.xyz + r1.xyz;
  r0.xyz = r0.xyz + r3.xyz;
  r0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r1.xyzw = t1.Gather(s0_s, v1.xy).xyzw;
  r1.xyzw = r1.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r0.w = min(r1.y, r1.z);
  r0.w = min(r0.w, r1.w);
  r0.w = min(r1.x, r0.w);
  r1.y = max(r1.y, r1.z);
  r1.y = max(r1.y, r1.w);
  r1.x = max(r1.x, r1.y);
  r0.w = r1.x < -r0.w ? r0.w : r1.x;
  r0.w = cb0[135].z * r0.w;
  r1.x = cb0[132].w + cb0[132].w;
  r1.x = 1 / r1.x;
  r1.x = saturate(r1.x * abs(r0.w));
  o0.w = r0.w;
  r0.w = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r0.w = r1.x * r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  o0.xyz = r0.xyz;
  return;
}