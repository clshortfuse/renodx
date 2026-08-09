#include "../shared.h"

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
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.xyz = -cb0[3].yyy + r0.xyz;
  r1.xyz = r1.xyz * cb0[3].xxx + cb0[3].yyy;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r2.xyz = r1.xyz * cb0[3].zzz + float3(0.5,0.5,0.5);
  r1.xyz = r1.xyz * cb0[3].zzz + float3(0,0.5,0.5);
  r1.w = dot(r2.xyz, float3(0.0299565997,0.184309006,1.46709001));
  r3.xy = float2(2.52810001,1.24827003) * r1.ww;
  r3.z = dot(r2.xyz, float3(17.8824005,43.5161018,4.11934996));
  r3.y = r3.z * 0.494206995 + r3.y;
  r3.w = dot(r2.xyz, float3(3.45565009,27.1553993,3.86714005));
  r4.xyzw = float4(1,1,1,1) + -cb0[2].xyzw;
  r4.y = r4.y * r3.w;
  r3.y = r3.y * cb0[2].y + r4.y;
  r5.xyz = float3(-0.130504414,0.0540193282,-0.00412161462) * r3.yyy;
  r3.x = r3.w * 2.02343988 + -r3.x;
  r3.y = 0.801109016 * r3.w;
  r3.y = r3.z * -0.395913005 + r3.y;
  r3.z = r4.x * r3.z;
  r3.x = r3.x * cb0[2].x + r3.z;
  r3.xzw = r3.xxx * float3(0.0809444487,-0.0102485335,-0.000365296932) + r5.xyz;
  r1.w = r4.z * r1.w;
  r1.w = r3.y * cb0[2].z + r1.w;
  r3.xyz = r1.www * float3(0.116721064,-0.113614708,0.693511426) + r3.xzw;
  r3.xyz = -r3.xyz + r2.xyz;
  r3.yz = r3.xx * float2(0.699999988,0.699999988) + r3.yz;
  r3.x = 0.5;
  r0.xyz = r3.xyz + r1.xyz;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = saturate(r0.xyz);
  }
  r1.xyz = r0.xyz;
  r1.w = saturate(r0.w);
  r2.w = r0.w;
  r0.xyzw = r4.wwww * r2.xyzw;
  o0.xyzw = r1.xyzw * cb0[2].wwww + r0.xyzw;
  return;
}