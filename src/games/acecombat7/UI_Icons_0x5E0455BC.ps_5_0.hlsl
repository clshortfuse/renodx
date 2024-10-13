// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 11 21:13:03 2024
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[4];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : ORIGINAL_POSITION0,
  float4 v3 : TEXCOORD0,
  float4 v4 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v4.xy * v4.zw;
  r0.xy = r0.xy * float2(0.142857,0.200000003) + cb1[2].xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.xyz = cb1[3].xyz + r0.xyz;
  r0.w = saturate(r0.w);
  r0.xyz = max(float3(0,0,0), r1.xyz);
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.xyz = log2(r0.xyz);
  r1.xyz = cb0[2].xxx * r1.xyz;
  r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
  r1.xyz = cmp(r1.xyz >= float3(0.00313066994,0.00313066994,0.00313066994));
  r1.xyz = r1.xyz ? r2.xyz : r3.xyz;
  r1.w = cmp(cb0[2].y != 1.000000);
  o0.xyz = r1.www ? r1.xyz : r0.xyz;
  o0.w = r0.w;

  //o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);  // 2.2 gamma correction
  // o0.a = sign(o0.a) * pow(abs(o0.a), 2.2f); // 2.2 gamma on Alpha
  //o0.rgb *= injectedData.toneMapUINits / 80.f;  // Added ui slider
  //o0.rgb = renodx::math::SafePow(o0.rgb, 1 / 2.2);
  return;
}