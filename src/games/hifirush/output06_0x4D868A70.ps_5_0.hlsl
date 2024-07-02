#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

cbuffer cb1 : register(b1) {
  float4 cb1[17];
}

cbuffer cb2 : register(b2) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float4 v1 : COLOR0, float4 v2 : ORIGINAL_POSITION0, float2 v3 : TEXCOORD0, float4 v4 : TEXCOORD1, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v4.yx * v4.wz + cb1[4].yx;
  r0.z = max(abs(r0.x), abs(r0.y));
  r0.z = 1 / r0.z;
  r0.w = min(abs(r0.x), abs(r0.y));
  r0.z = r0.w * r0.z;
  r0.w = r0.z * r0.z;
  r1.x = r0.w * 0.0208350997 + -0.0851330012;
  r1.x = r0.w * r1.x + 0.180141002;
  r1.x = r0.w * r1.x + -0.330299497;
  r0.w = r0.w * r1.x + 0.999866009;
  r1.x = r0.z * r0.w;
  r1.x = r1.x * -2 + 1.57079637;
  r1.y = cmp(abs(r0.y) < abs(r0.x));
  r1.x = r1.y ? r1.x : 0;
  r0.z = r0.z * r0.w + r1.x;
  r0.w = cmp(r0.y < -r0.y);
  r0.w = r0.w ? -3.141593 : 0;
  r0.z = r0.z + r0.w;
  r0.w = min(r0.x, r0.y);
  r0.x = max(r0.x, r0.y);
  r0.x = cmp(r0.x >= -r0.x);
  r0.y = cmp(r0.w < -r0.w);
  r0.x = r0.x ? r0.y : 0;
  r0.x = r0.x ? -r0.z : r0.z;
  r0.x = r0.x * 0.159154952 + 0.25;
  r0.y = -0.5 + cb1[14].y;
  r0.y = cmp(9.99999975e-06 < abs(r0.y));
  r0.z = cmp(cb1[14].y >= 0.5);
  r0.z = r0.z ? cb1[14].x : cb1[13].z;
  r0.y = r0.y ? r0.z : cb1[13].z;
  r0.x = r0.x + r0.y;
  r0.x = frac(r0.x);
  r0.y = 1 + -r0.x;
  r0.z = cmp(0.5 >= cb1[14].z);
  r0.y = r0.z ? r0.y : r0.x;
  r0.z = 0.5 + -cb1[14].z;
  r0.z = cmp(9.99999975e-06 < abs(r0.z));
  r0.x = r0.z ? r0.y : r0.x;
  r0.x = cb1[13].y + r0.x;
  r0.x = floor(r0.x);
  r0.y = cmp(cb1[15].y >= 0);
  r0.yz = r0.yy ? cb1[6].xy : cb1[7].xy;
  r0.w = cmp(9.99999975e-06 < abs(cb1[15].y));
  r0.yz = r0.ww ? r0.yz : cb1[7].xy;
  r0.yz = float2(1, 1) / r0.yz;
  r1.xy = float2(1, 1) + -r0.yz;
  r1.xy = r1.xy / r0.yz;
  r1.zw = v4.xy * v4.zw + cb1[5].xy;
  r1.xy = r1.xy * float2(0.5, 0.5) + r1.zw;
  r1.zw = r1.xy * r0.yz + -cb1[9].xy;
  r0.yz = r1.xy * r0.yz;
  r0.yz = t1.Sample(s1_s, r0.yz).xw;
  r1.xy = cb1[11].xy + -cb1[9].xy;
  r1.xy = r1.zw / r1.xy;
  r1.xy = float2(-0.5, -0.5) + r1.xy;
  r1.xy = -abs(r1.xy) * float2(2, 2) + float2(1, 1);
  r1.xy = saturate(float2(100000, 100000) * r1.xy);
  r0.w = r1.x * r1.y;
  r1.xy = cmp(cb1[16].xy >= float2(1, 1));
  r0.y = r1.x ? r0.z : r0.y;
  r1.xz = float2(-1, -1) + cb1[16].xy;
  r1.xz = cmp(float2(9.99999975e-06, 9.99999975e-06) < abs(r1.xz));
  r0.y = r1.x ? r0.y : r0.z;
  r0.z = r0.y * r0.w;
  r0.y = -r0.y * r0.w + 1;
  r0.z = r1.y ? r0.y : r0.z;
  r0.y = r1.z ? r0.z : r0.y;
  r0.z = r0.x * r0.y;
  r0.x = -r0.x * r0.y + r0.x;
  r0.y = cmp(0.5 >= cb1[16].z);
  r0.y = r0.y ? r0.x : r0.z;
  r0.z = 0.5 + -cb1[16].z;
  r0.z = cmp(9.99999975e-06 < abs(r0.z));
  r0.x = r0.z ? r0.y : r0.x;
  r0.yz = v4.xy * v4.zw + cb1[1].xy;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  r0.w = saturate(r1.w * r0.x);
  r2.xyz = cb1[2].xyz + -r1.xyz;
  r1.xyz = cb1[12].zzz * r2.xyz + r1.xyz;
  r0.xyz = max(float3(0, 0, 0), r1.xyz);
  r1.xyzw = v1.xyzw * r0.xyzw;
  r0.w = dot(float3(0.300000012, 0.589999974, 0.109999999), r1.xyz);
  r0.xyz = -r0.xyz * v1.xyz + r0.www;
  r0.xyz = r0.xyz * float3(0.800000012, 0.800000012, 0.800000012) + r1.xyz;
  r2.xyz = float3(-0.100000001, -0.100000001, -0.100000001) + r0.xyz;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = sqrt(r0.w);
  r0.w = min(0.800000012, r0.w);
  r2.xyz = float3(0.100000001, 0.100000001, 0.100000001) + -r0.xyz;
  r0.xyz = r0.www * r2.xyz + r0.xyz;
  r0.w = cmp(cb0[3].x != 0.000000);
  r0.xyz = r0.www ? r0.xyz : r1.xyz;
  o0.w = r1.w;
  r1.xyz = float3(-0.25, -0.25, -0.25) + r0.xyz;
  r1.xyz = saturate(r1.xyz * cb0[1].www + float3(0.25, 0.25, 0.25));
  r2.xy = cmp(cb0[1].wy != float2(1, 1));
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
  r1.xyz = pow(r0.rgb, cb0[1].x);
  o0.xyz = r2.yyy ? r1.xyz : r0.xyz;

  o0.rgb *= injectedData.toneMapUINits;  // Scale by user nits

  // o0.rgb = mul(BT709_TO_BT2020_MAT, o0.rgb);  // use bt2020
  // o0.rgb /= 10000.f;                         // Scale for PQ
  // o0.rgb = max(0, o0.rgb);                   // clamp out of gamut
  // o0.rgb = renodx::color::pq::from::BT2020(o0.rgb);             // convert to PQ
  // o0.rgb = min(1.f, o0.rgb);                 // clamp PQ (10K nits)

  o0.rgb /= 80.f;
  return;
}