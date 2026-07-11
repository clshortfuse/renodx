// ---- Created with 3Dmigoto v1.3.16 on Mon Nov  4 00:21:31 2024

#include "./shared.h"


Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r1.xyz = r1.xyz * cb0[3].yyy + float3(0.5,0.5,0.5);
  r1.w = -0.5 + cb0[3].x;
  r1.xyz = r1.xyz + r1.www;
  r2.x = dot(r1.xyz, float3(0.0299565997,0.184309006,1.46709001));
  r2.yz = float2(2.52810001,1.24827003) * r2.xx;
  r2.w = dot(r1.xyz, float3(17.8824005,43.5161018,4.11934996));
  r2.z = r2.w * 0.494206995 + r2.z;
  r3.x = dot(r1.xyz, float3(3.45565009,27.1553993,3.86714005));
  r4.xyzw = float4(1,1,1,1) + -cb0[2].xyzw;
  r3.y = r4.y * r3.x;
  r2.z = r2.z * cb0[2].y + r3.y;
  r3.yzw = float3(-0.130504414,0.0540193282,-0.00412161462) * r2.zzz;
  r2.y = r3.x * 2.02343988 + -r2.y;
  r2.z = 0.801109016 * r3.x;
  r2.z = r2.w * -0.395913005 + r2.z;
  r2.xw = r4.zx * r2.xw;
  r2.y = r2.y * cb0[2].x + r2.w;
  r3.xyz = r2.yyy * float3(0.0809444487,-0.0102485335,-0.000365296932) + r3.yzw;
  r2.x = r2.z * cb0[2].z + r2.x;
  r2.xyz = r2.xxx * float3(0.116721064,-0.113614708,0.693511426) + r3.xyz;
  r2.xyz = -r2.xyz + r1.xyz;
  r2.yz = r2.xx * float2(0.699999988,0.699999988) + r2.yz;
  r2.x = 0;
  r0.xyz = r2.xyz + r1.xyz;
  r2.xyzw = (r0.xyzw); //Saturate here clamps the game
  r1.w = r0.w;
  r0.xyzw = r4.wwww * r1.xyzw;
  o0.xyzw = r2.xyzw * cb0[2].wwww + r0.xyzw;
  return;
}