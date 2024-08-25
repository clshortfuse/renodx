#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:14 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float2 v4 : TEXCOORD3,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v4.xyxy * float4(1,1,-1,-1) + float4(0,0,1,1);
  r0.xyzw = cmp(r0.xyzw < float4(0,0,0,0));
  r0.xy = (int2)r0.zw | (int2)r0.xy;
  r0.x = (int)r0.y | (int)r0.x;
  if (r0.x != 0) discard;
  r0.x = t1.Sample(s1_s, v2.zw).y;
  r0.y = 1 + -r0.x;
  r1.xyzw = t0.Sample(s0_s, v3.zw).xyzw;
  r2.xyz = saturate(r1.xyz * v1.xyz + float3(0.00499999989,0.00499999989,0.00499999989));
  r1.xyzw = v1.xyzw * r1.xyzw;
  r3.xyz = float3(-0.5,-0.5,-0.5) + r2.xyz;
  r3.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r0.yzw = -r3.xyz * r0.yyy + float3(1,1,1);
  r3.xyz = r2.xyz + r2.xyz;
  r2.xyz = cmp(float3(0.5,0.5,0.5) >= r2.xyz);
  r3.xyz = saturate(r3.xyz * r0.xxx);
  r0.xyz = r2.xyz ? r3.xyz : r0.yzw;
  r0.xyz = float3(0.150000006,0.150000006,0.150000006) * r0.xyz;
  o0.xyz = r1.xyz * float3(0.850000024,0.850000024,0.850000024) + r0.xyz;
  r0.x = t0.Sample(s0_s, v3.xy).w;
  r0.x = 1 + -r0.x;
  r0.x = saturate(cb0[0].x + r0.x);
  o0.w = r1.w * r0.x;
  
  o0.xyz = saturate(o0.xyz);
  if (injectedData.toneMapGammaCorrection) { // fix srgb 2.2 mismatch
    o0.xyz = renodx::color::srgb::from::BT709(o0.xyz);
    o0.xyz = pow(o0.xyz, 2.2f);
  }
  o0.xyz *= injectedData.toneMapUINits/80.f;

  return;
}