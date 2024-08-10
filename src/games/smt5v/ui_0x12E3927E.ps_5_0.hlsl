// ---- Created with 3Dmigoto v1.3.16 on Mon Jul 15 20:31:04 2024
#include "./shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[14];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[130];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : ORIGINAL_POSITION0,
  float4 v3 : TEXCOORD0,
  float4 v4 : TEXCOORD1,
  float4 v5 : TEXCOORD2,
  float4 v6 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v4.xy).xyzw;
  r0.xyz = max(float3(6.10351999e-05,6.10351999e-05,6.10351999e-05), r0.xyz);
  r0.w = v1.w * r0.w;
  r1.xyz = max(float3(0.00313066994,0.00313066994,0.00313066994), r0.xyz);
  r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyz = min(r1.xyz, r0.xyz);
  r1.xyz = v1.xyz * r0.xyz;
  r1.xyz = v4.www * r1.xyz;
  r1.w = 1 + -v4.w;
  r0.xyz = r0.xyz * r1.www + r1.xyz;
  r0.xyz = max(float3(6.10351999e-05,6.10351999e-05,6.10351999e-05), r0.xyz);
  r1.xyz = r0.xyz * float3(0.947867274,0.947867274,0.947867274) + float3(0.0521326996,0.0521326996,0.0521326996);
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) < r0.xyz);
  r0.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  r0.xyz = r2.xyz ? r1.xyz : r0.xyz;
  r1.xyz = cb2[1].xyz + -r0.xyz;
  r0.xyz = cb2[11].xxx * r1.xyz + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.x = dot(float3(0.300000012,0.589999974,0.109999999), r0.xyz);
  r1.xyz = r1.xxx + -r0.xyz;
  r1.xyz = r1.xyz * float3(0.800000012,0.800000012,0.800000012) + r0.xyz;
  r2.xyz = float3(-0.100000001,-0.100000001,-0.100000001) + r1.xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = sqrt(r1.w);
  r1.w = min(0.800000012, r1.w);
  r2.xyz = float3(0.100000001,0.100000001,0.100000001) + -r1.xyz;
  r1.xyz = r1.www * r2.xyz + r1.xyz;
  r1.w = cmp(cb0[3].x != 0.000000);
  r0.xyz = r1.www ? r1.xyz : r0.xyz;
  r1.xyz = float3(-0.25,-0.25,-0.25) + r0.xyz;
  r1.xyz = saturate(r1.xyz * cb0[1].www + float3(0.25,0.25,0.25));
  r2.xy = cmp(cb0[1].wy != float2(1,1));
  r0.xyz = r2.xxx ? r1.xyz : r0.xyz;
  r1.xyz = log2(r0.xyz);
  r1.xyz = cb0[1].xxx * r1.xyz;
  r2.xzw = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xzw = exp2(r2.xzw);
  r2.xzw = r2.xzw * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
  r1.xyz = cmp(r1.xyz >= float3(0.00313066994,0.00313066994,0.00313066994));
  r1.xyz = r1.xyz ? r2.xzw : r3.xyz;
  o0.xyz = r2.yyy ? r1.xyz : r0.xyz;
  r0.xy = -cb1[129].xy + v0.xy;
  r1.xy = -cb2[4].xy + r0.xy;
  r0.xy = -cb2[9].xy + r0.xy;
  r0.xy = r0.xy / cb2[10].xy;
  r0.x = t2.Sample(s2_s, r0.xy).w;
  r0.yz = r1.xy / cb2[5].xy;
  r0.yz = r0.yz * cb2[6].xy + cb2[7].xy;
  r0.y = t1.Sample(s1_s, r0.yz).w;
  r0.y = cb2[13].y + r0.y;
  r0.z = -1 + r0.y;
  r0.y = cmp(r0.y >= 1);
  r0.y = r0.y ? 0 : 1;
  r0.z = cmp(9.99999975e-06 < abs(r0.z));
  r0.y = r0.z ? r0.y : 1;
  r0.y = r0.w * r0.y;
  o0.w = saturate(r0.y * r0.x);
    
  o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction 
  o0.rgb *= injectedData.toneMapUINits / 80.f; //Added ui slider
    
  return;
}