// ---- Created with 3Dmigoto v1.4.1 on Mon Mar  9 17:17:10 2026
Texture3D<float4> t5 : register(t5);

Texture2D<uint4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[1];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[3];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[44];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float4 v0 : TEXCOORD0,
  linear noperspective float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  linear noperspective float4 v3 : TEXCOORD3,
  float4 v4 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s2_s, v3.zw).x;
  r0.y = t1.Sample(s2_s, v3.xy).y;
  r0.z = t1.Sample(s2_s, v0.xy).z;
  r0.xyz = cb1[43].zzz * r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[3].xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = cb1[43].yyy * r0.xyz;
  r1.xy = -cb2[1].xy + v4.xy;
  r1.xy = cb2[2].zw * r1.xy;
  r1.xy = r1.xy * float2(2,-2) + float2(-1,1);
  r1.xy = r1.xy * cb0[4].zw + cb0[4].xy;
  r1.xy = r1.xy * float2(0.5,-0.5) + float2(0.5,0.5);
  r2.xyz = t0.Sample(s1_s, r1.xy).xyz;
  r2.xyz = r2.xyz * cb3[0].xyz + cb0[1].xyz;
  r3.xyz = t2.Sample(s0_s, r1.xy).xyz;
  r1.xyz = t3.SampleLevel(s0_s, r1.xy, 0).xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r0.xyz = r0.xyz * cb0[0].xyz + r2.xyz;
  r0.xyz = v1.xxx * r0.xyz;
  r0.xyz = r0.xyz * r1.xxx;
  r1.xw = cb0[2].xx * v1.yz;
  r0.w = dot(r1.xw, r1.xw);
  r0.w = 1 + r0.w;
  r0.w = rcp(r0.w);
  r0.w = r0.w * r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.w = max(9.99999997e-07, r0.x);
  r1.x = max(r0.y, r0.z);
  r0.w = max(r1.x, r0.w);
  r1.x = exp2(-r0.w);
  r1.x = 1 + -r1.x;
  r0.w = r0.w / r1.x;
  r0.xyz = r0.xyz / r0.www;
  r0.w = r0.w + r0.w;
  r0.xyz = sqrt(r0.xyz);
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyz = t5.SampleLevel(s0_s, r0.xyz, 0).xyz;
  r2.xyz = r0.xyz * r0.xyz;
  r1.x = dot(r2.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.w = r0.x * r0.x + -r1.x;
  r0.xyz = -r0.xyz * r0.xyz + r1.xxx;
  r1.x = saturate(-0.00100000005 + r1.w);
  r1.w = saturate(r0.y);
  r1.x = r1.x + -r1.w;
  r1.x = -8 * r1.x;
  r1.x = exp2(r1.x);
  r1.x = 1 + -r1.x;
  r1.x = max(0, r1.x);
  r3.xyz = cb0[6].xyz * r0.xyz;
  r1.w = dot(r3.xyz, r3.xyz);
  r1.x = r1.x * 4 + r1.w;
  r1.x = -cb0[5].y * r1.x;
  r1.x = exp2(r1.x);
  r1.x = -cb0[5].x * r1.x;
  r0.xyz = r1.xxx * r0.xyz + r2.xyz;
  r0.xyz = r0.xyz * r0.www;
  r2.xyz = exp2(-r0.xyz);
  r0.xyz = saturate(r0.xyz);
  r2.xyz = -r2.xyz * r1.yyy + r1.yyy;
  r0.w = 1 + -r1.y;
  r1.xy = cmp(float2(0.25,0.75) < r1.zz);
  r0.xyz = saturate(r0.xyz * r0.www + r2.xyz);
  o0.xyz = sqrt(r0.xyz);
  r0.xy = (uint2)v4.xy;
  r0.zw = float2(0,0);
  r0.x = t4.Load(r0.xyz).y;
  r0.xyz = (int3)r0.xxx & int3(15,64,16);
  r0.w = cmp((int)r0.x == 3);
  r0.w = (int)r1.x | (int)r0.w;
  r0.yz = cmp((int2)r0.yz != int2(0,0));
  r0.y = (int)r0.y | (int)r0.w;
  r0.z = (int)r0.z | (int)r1.y;
  r0.yz = r0.yz ? float2(0.5,1) : 0;
  r0.y = r0.y + r0.z;
  o0.w = r0.x ? r0.y : 0.5;
  return;
}