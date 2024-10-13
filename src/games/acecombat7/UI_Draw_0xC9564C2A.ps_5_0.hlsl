// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 11 21:13:11 2024
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = log2(v1.xyz);
  r0.xyz = cb0[0].xxx * r0.xyz;
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  r0.xyz = cmp(r0.xyz >= float3(0.00313066994,0.00313066994,0.00313066994));
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;
  r0.w = cmp(cb0[0].y != 1.000000);
  o0.xyz = r0.www ? r0.xyz : v1.xyz;
  r0.x = t0.Sample(s0_s, v4.xy).w;
  r0.x = v1.w * r0.x;
  r0.y = r0.x * -2 + 1;
  o0.w = cb0[2].x * r0.y + r0.x;

  //o0.a = saturate(o0.a);
  o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);  // 2.2 gamma correction
  //o0.a = sign(o0.a) * pow(abs(o0.a), 2.2f); // 2.2 gamma on Alpha
  o0.rgb *= injectedData.toneMapUINits / 80.f;  // Added ui slider
  o0.rgb = renodx::math::SafePow(o0.rgb, 1 / 2.2);

  return;
}