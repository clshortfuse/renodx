// ---- Created with 3Dmigoto v1.3.16 on Sun Feb 02 01:40:03 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[17];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = cmp(r0.w != 0.000000);
  r0.w = r0.w ? -1 : -0;
  r0.xyz = r0.xyz * float3(2,2,2) + r0.www;
  r1.xyz = cb1[15].xyz * r0.yyy;
  r0.xyw = cb1[14].xyz * r0.xxx + r1.xyz;
  r0.xyz = cb1[16].xyz * r0.zzz + r0.xyw;
  r1.x = cb0[2].x;
  r1.y = 0;
  r2.xyzw = -r1.xyxy * float4(2.76923084,1.38461542,6.46153831,3.23076916) + v2.xyxy;
  r1.xyzw = r1.xyxy * float4(2.76923084,1.38461542,6.46153831,3.23076916) + v2.xyxy;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r3.yzw = r3.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r0.w = dot(r0.xyz, r3.yzw);
  r0.w = -0.800000012 + r0.w;
  r0.w = saturate(5.00000048 * r0.w);
  r3.y = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r3.y * r0.w;
  r0.w = 0.31621623 * r0.w;
  r3.x = r3.x * r0.w;
  r4.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r3.x = r4.x * 0.227027029 + r3.x;
  r4.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r3.yzw = r4.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r3.y = dot(r0.xyz, r3.yzw);
  r3.y = -0.800000012 + r3.y;
  r3.y = saturate(5.00000048 * r3.y);
  r3.z = r3.y * -2 + 3;
  r3.y = r3.y * r3.y;
  r3.y = r3.z * r3.y;
  r3.z = 0.31621623 * r3.y;
  r0.w = r3.y * 0.31621623 + r0.w;
  r3.x = r4.x * r3.z + r3.x;
  r2.yzw = r2.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r2.y = dot(r0.xyz, r2.yzw);
  r2.y = -0.800000012 + r2.y;
  r2.y = saturate(5.00000048 * r2.y);
  r2.z = r2.y * -2 + 3;
  r2.y = r2.y * r2.y;
  r2.y = r2.z * r2.y;
  r2.z = 0.0702702701 * r2.y;
  r0.w = r2.y * 0.0702702701 + r0.w;
  r2.x = r2.x * r2.z + r3.x;
  r1.yzw = r1.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r1.y = dot(r0.xyz, r1.yzw);
  o0.yzw = r0.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
  r0.x = -0.800000012 + r1.y;
  r0.x = saturate(5.00000048 * r0.x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.y = 0.0702702701 * r0.x;
  r0.x = r0.x * 0.0702702701 + r0.w;
  r0.x = 0.227027029 + r0.x;
  r0.y = r1.x * r0.y + r2.x;
  o0.x = r0.y / r0.x;
  return;
}