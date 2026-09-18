// ---- Created with 3Dmigoto v1.3.16 on Thu Aug 14 17:25:45 2025
#include "./common.hlsl"

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[1];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[40];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = t4.Sample(s4_s, v1.xy).xy;
  r0.zw = t3.Sample(s2_s, v1.xy).xy;
  r0 = max(r0, float4(0,0,0,0)); //new
  
  r1.x = saturate(r0.x + r0.z);
  r1.x = cmp(r1.x < 0.00999999978);
  if (r1.x != 0) discard;
  r1.xyz = t2.Sample(s0_s, v1.xy).xyz; 
  r1 = max(r1, float4(0,0,0,0)); //new

  r2.xyz = t5.Sample(s3_s, v1.xy).xyz;
  r2 = max(r2, float4(0,0,0,0)); //new


  r3.xyz = float3(0.00392156886,0.00392156886,0.00392156886) * cb2[39].xyz;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r2.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r4.xy = float2(1,1) + -v2.xy;
  r0.yw = saturate(-r4.xy + r0.yw);
  r0.yw = float2(5,10) * r0.yw;
  r0.yw = min(float2(1,1), r0.yw);
  r0.x = r0.x * r0.y;
  r0.y = r0.z * r0.w;
  r0.z = saturate(-r0.x * 1.25 + 1);
  r0.x = r0.y * r0.z + r0.x;
  r0.y = cb3[0].y * r0.x;
  r2.xyz = float3(1,-1,-1) * r2.xyz;
  r2.xyz = r2.xyz * r0.www;
  r1.xyz = r1.xyz * float3(1,-1,-1) + r2.xyz;
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  r2.xyz = float3(0.5,0.5,0.5) * r1.xyz;
  r0.z = log2(r0.y);
  r0.z = 0.200000003 * r0.z;
  r0.z = exp2(r0.z);
  r4.xyz = cb2[38].xyz * float3(0.00392156886,0.00392156886,0.00392156886) + -r3.xyz;
  r3.xyz = r0.zzz * r4.xyz + r3.xyz;
  r0.z = cmp(-0 < -cb2[28].z);
  r4.xyz = cb2[28].zzz * float3(-0.5,-0.25,-0.25) + float3(1,0.5,-0.5);
  r1.xyz = r1.xyz * float3(0.5,0.5,0.5) + float3(0,0,0.5);
  r1.xyz = r4.xxx * r1.xyz + float3(0,0,-0.5);
  r1.xyz = r0.zzz ? r1.xyz : r2.xyz;
  r0.z = dot(-cb2[28].xyz, r1.xyz);
  r1.xyz = abs(r0.zzz) * float3(0.577350259,0.577350259,0.577350259) + cb2[30].xyz;
  r1.xyz = r3.xyz * r1.xyz + cb2[33].xyz;
  r0.z = saturate(dot(-cb2[29].xyz, r2.xyz));
  r0.z = log2(r0.z);
  r0.z = 15 * r0.z;
  r0.z = exp2(r0.z);
  r0.z = cb3[0].w * r0.z;
  r0.z = 2.875 * r0.z;
  r0.w = cb3[0].z * r4.z + 1;
  r1.w = -r0.y * cb3[0].z + 1;
  r0.z = r1.w * r0.z;
  r1.xyz = r0.zzz * r0.www + r1.xyz;
  r0.x = -r0.x * cb3[0].y + 1;
  r0.z = cb3[0].x + -r0.x;
  r0.z = r4.y * r0.z + r0.x;
  o0.w = saturate(1.5 * r0.y);
  r0.yw = float2(55,55) * v1.xy;
  r0.yw = sin(r0.yw);
  r0.yw = r0.yw * float2(0.00999999978,0.00999999978) + v1.xy;
  r2.xyz = t6.Sample(s5_s, r0.yw).xyz;
  r2 = max(r2, float4(0,0,0,0)); //new. This fixed weird neg doing wierd colors.
  
  r0.xyw = r2.xyz * r0.xxx;
  o0.xyz = r1.xyz * r0.zzz + r0.xyw;
  return;
}