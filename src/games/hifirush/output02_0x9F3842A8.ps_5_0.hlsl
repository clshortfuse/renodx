// UI Videos

#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

cbuffer cb1 : register(b1) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float4 v1 : COLOR0, float4 v2 : ORIGINAL_POSITION0, float2 v3 : TEXCOORD0, float4 v4 : TEXCOORD1, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v4.xy * v4.zw;
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r1.xyz = r0.xyz * v1.xyz + float3(-0.25, -0.25, -0.25);
  r1.xyz = saturate(r1.xyz * cb0[0].www + float3(0.25, 0.25, 0.25));
  r0.w = 1;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r2.xy = cmp(cb0[0].wy != float2(1, 1));
  r0.xyz = r2.xxx ? r1.xyz : r0.xyz;

  // r1.xyz = log2(r0.xyz);
  // r1.xyz = cb0[0].xxx * r1.xyz;
  // r2.xzw = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r2.xzw = exp2(r2.xzw);
  // r2.xzw = r2.xzw * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
  // r1.xyz = cmp(r1.xyz >= float3(0.00313066994,0.00313066994,0.00313066994));
  // r1.xyz = r1.xyz ? r2.xzw : r3.xyz;

  r1.xyz = pow(r0.xyz, cb0[0].x);

  o0.xyz = r2.yyy ? r1.xyz : r0.xyz;
  r0.x = v1.w * -2 + 1;
  o0.w = cb0[0].z * r0.x + r0.w;

  o0.rgb *= injectedData.toneMapUINits;  // Scale by user nits

  // o0.rgb = mul(BT709_TO_BT2020_MAT, o0.rgb);  // use bt2020
  // o0.rgb /= 10000.f;                         // Scale for PQ
  // o0.rgb = max(0, o0.rgb);                   // clamp out of gamut
  // o0.rgb = renodx::color::pq::Encode(o0.rgb);             // convert to PQ
  // o0.rgb = min(1.f, o0.rgb);                 // clamp PQ (10K nits)

  o0.rgb /= 80.f;

  return;
}
