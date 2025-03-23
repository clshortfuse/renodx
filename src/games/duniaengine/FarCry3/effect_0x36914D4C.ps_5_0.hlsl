#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = cb0[6].xyz;
  r0.w = 1;
  r0.xyzw = r0.xyzw * cb0[5].yyyy + float4(-1,-1,-1,-1);
  r1.x = 1 + -cb0[5].z;
  r1.x = 1 / r1.x;
  r1.y = dot(cb0[6].xyz, cb0[6].xyz);
  r1.y = rsqrt(r1.y);
  r1.yzw = cb0[6].xyz * r1.yyy;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.rgb = renodx::math::SignPow(r2.rgb, 2.f);
  r3.x = dot(r2.xyz, r2.xyz);
  r3.x = rsqrt(r3.x);
  r3.xyz = r3.xxx * r2.xyz;
  r1.y = dot(r1.yzw, r3.xyz);
  r1.y = max(cb0[5].z, r1.y);
  r1.y = min(1, r1.y);
  r1.y = -cb0[5].z + r1.y;
  r1.x = r1.y * r1.x;
  r0.xyzw = r1.xxxx * r0.xyzw + float4(1,1,1,1);
  r1.x = dot(some_formula, r2.xyz);
  r3.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = -r0.xyzw * r1.xxxx + float4(1,1,1,1);
  r0.xyzw = r1.xxxx * r0.xyzw + r3.xyzw;
  r0.xyzw = r0.xyzw + -r2.xyzw;
  r0.xyzw = cb0[5].xxxx * r0.xyzw + r2.xyzw;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  o0.w = r0.w;
  r0.xyz = cb0[5].www * r0.xyz + float3(0.5,0.5,0.5);
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  return;
}