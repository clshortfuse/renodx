// ---- Created with 3Dmigoto v1.3.16 on Wed Jul 17 02:27:17 2024
#include "./shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[3];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[39];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.xy = cb0[38].zw * r0.xy;
  r0.z = t2.Sample(s2_s, r0.xy).x;
  r0.z = -0.5 + r0.z;
  r0.zw = float2(1.59602702,-0.812968016) * r0.zz;
  r1.x = t1.Sample(s1_s, r0.xy).x;
  r0.x = t0.Sample(s0_s, r0.xy).x;
  r0.x = -0.0625 + r0.x;
  r0.y = -0.5 + r1.x;
  r0.w = r0.y * -0.391761988 + r0.w;
  r1.x = r0.x * 1.16438305 + r0.z;
  r0.y = 2.01723194 * r0.y;
  r1.z = r0.x * 1.16438305 + r0.y;
  r1.y = r0.x * 1.16438305 + r0.w;
  r0.xyz = max(float3(6.1040002e-05,6.1040002e-05,6.1040002e-05), r1.xyz);
  r1.xyz = r0.xyz * float3(0.947867274,0.947867274,0.947867274) + float3(0.0521326996,0.0521326996,0.0521326996);
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  r0.xyz = cmp(r0.xyz >= float3(0.0404499993,0.0404499993,0.0404499993));
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;
  r1.xyz = log2(r0.xyz);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  r1.xyz = cb1[1].xyz + -r0.xyz;
  r0.xyz = cb1[2].xxx * r1.xyz + r0.xyz;
  o0.xyz = max(float3(0,0,0), r0.xyz);
  o0.w = 1;
  
  o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction  
  o0.a = sign(o0.a) * pow(abs(o0.a), 2.2f); // 2.2 gamma on Alpha
  o0.rgb *= injectedData.toneMapUINits / 80.f; //Added ui slider
  
  return;
}