// ---- Created with 3Dmigoto v1.3.16 on Sun Jul  7 04:03:57 2024
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : ORIGINAL_POSITION0,
  float2 v3 : TEXCOORD0,
  float4 v4 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = float3(-0.25,-0.25,-0.25) + v1.xyz;
  r0.xyz = saturate(r0.xyz * cb0[0].www + float3(0.25,0.25,0.25));
  r1.xy = cmp(cb0[0].wy != float2(1,1));
  r0.xyz = r1.xxx ? r0.xyz : v1.xyz;
  r1.xzw = log2(r0.xyz);
  r1.xzw = cb0[0].xxx * r1.xzw;
  r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xzw;
  r1.xzw = exp2(r1.xzw);
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xzw;
  r1.xzw = cmp(r1.xzw >= float3(0.00313066994,0.00313066994,0.00313066994));
  r1.xzw = r1.xzw ? r2.xyz : r3.xyz;
  o0.xyz = r1.yyy ? r1.xzw : r0.xyz;
  r0.x = t0.Sample(s0_s, v4.xy).w;
  r0.x = v1.w * r0.x;
  r0.y = r0.x * -2 + 1;
  o0.w = cb0[0].z * r0.y + r0.x;

  o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction
  //o0.a = renodx::math::SafePow(o0.a, 2.2f);
  o0.a = sign(o0.a) * pow(abs(o0.a), 2.2f); // 2.2 gamma on Alpha
  o0.rgb *= injectedData.toneMapUINits / 80.f; //Added ui slider

  return;
}