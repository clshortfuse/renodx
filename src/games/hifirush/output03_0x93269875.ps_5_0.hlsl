// UI HUD?

#include "../../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

cbuffer cb1 : register(b1) {
  float4 cb1[7];
}

cbuffer cb2 : register(b2) {
  ShaderInjectData injectedData : packoffset(c0);
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

  r0.xy = v4.xy * v4.zw;
  r1.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r0.w = r1.w * r1.w + -0.333299994;
  r0.w = cmp(r0.w < 0);
  if (r0.w != 0) discard;
  r2.xy = v4.xy * v4.zw + float2(-0.5,-0.5);
  r0.w = dot(r2.xy, cb1[2].xy);
  r0.w = cb1[6].x + r0.w;
  r0.w = 0.5 + r0.w;
  r0.w = 0.333333343 * r0.w;
  r0.w = frac(r0.w);
  r0.w = 3 * r0.w;
  r0.w = ceil(r0.w);
  r0.w = -2 + r0.w;
  r0.w = cmp(9.99999975e-06 < abs(r0.w));
  r2.x = r0.w ? 0 : 1;
  r0.w = r0.w ? 1.000000 : 0;
  r1.xyz = r2.xxx * r1.xyz;
  r1.w = r1.w * r1.w;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xyz = r0.xyz * r1.www;
  r0.xyz = -r0.xyz * r1.www + cb1[3].xyz;
  r0.xyz = cb1[6].yyy * r0.xyz + r1.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.xyz = v1.xyz * r0.xyz;
  r0.w = dot(float3(0.300000012,0.589999974,0.109999999), r1.xyz);
  r0.xyz = -r0.xyz * v1.xyz + r0.www;
  r0.xyz = r0.xyz * float3(0.800000012,0.800000012,0.800000012) + r1.xyz;
  r2.xyz = float3(-0.100000001,-0.100000001,-0.100000001) + r0.xyz;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = sqrt(r0.w);
  r0.w = min(0.800000012, r0.w);
  r2.xyz = float3(0.100000001,0.100000001,0.100000001) + -r0.xyz;
  r0.xyz = r0.www * r2.xyz + r0.xyz;
  r0.w = cmp(cb0[3].x != 0.000000);
  r0.xyz = r0.www ? r0.xyz : r1.xyz;
  r1.xyz = float3(-0.25,-0.25,-0.25) + r0.xyz;
  r1.xyz = saturate(r1.xyz * cb0[1].www + float3(0.25,0.25,0.25));
  r2.xy = cmp(cb0[1].wy != float2(1,1));
  r0.xyz = r2.xxx ? r1.xyz : r0.xyz;
  // r1.xyz = log2(r0.xyz);
  // r1.xyz = cb0[1].xxx * r1.xyz;
  // r2.xzw = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r2.xzw = exp2(r2.xzw);
  // r2.xzw = r2.xzw * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
  // r1.xyz = cmp(r1.xyz >= float3(0.00313066994,0.00313066994,0.00313066994));
  // r1.xyz = r1.xyz ? r2.xzw : r3.xyz;
  // o0.xyz = r2.yyy ? r1.xyz : r0.xyz;
  o0.rgb = pow(r0.xyz, cb0[1].x);
  o0.w = v1.w;

  
  o0.rgb *= injectedData.toneMapUINits;  // Scale by user nits

  // o0.rgb = mul(BT709_2_BT2020_MAT, o0.rgb);  // use bt2020
  // o0.rgb /= 10000.f;                         // Scale for PQ
  // o0.rgb = max(0, o0.rgb);                   // clamp out of gamut
  // o0.rgb = pqFromLinear(o0.rgb);             // convert to PQ
  // o0.rgb = min(1.f, o0.rgb);                 // clamp PQ (10K nits)

  o0.rgb /= 80.f;
  return;
}