#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[3];
}

cbuffer cb1 : register(b1) {
  float4 cb1[6];
}

cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

cbuffer cb3 : register(b3) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float4 v1 : COLOR0, float4 v2 : ORIGINAL_POSITION0, float2 v3 : TEXCOORD0, float4 v4 : TEXCOORD1, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v4.xy * v4.zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.x = dot(float3(0.613191485, 0.33951208, 0.0473663323), r0.xyz);
  r1.y = dot(float3(0.0702069029, 0.916335821, 0.0134500116), r0.xyz);
  r1.z = dot(float3(0.0206188709, 0.109567292, 0.869606733), r0.xyz);
  r0.w = saturate(r0.w);
  r1.w = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r2.xyz = r1.xyz / r1.www;
  r1.w = r1.w * r1.w;
  r1.w = -4 * r1.w;
  r1.w = exp2(r1.w);
  r1.w = 1 + -r1.w;
  r2.xyz = float3(-1, -1, -1) + r2.xyz;
  r2.x = dot(r2.xyz, r2.xyz);
  r2.x = -4 * r2.x;
  r2.x = exp2(r2.x);
  r2.x = 1 + -r2.x;
  r1.w = r2.x * r1.w;
  r2.x = dot(float3(1.37041271, -0.329291314, -0.0636827648), r1.xyz);
  r2.y = dot(float3(-0.0834341869, 1.09709096, -0.0108615728), r1.xyz);
  r2.z = dot(float3(-0.0257932581, -0.0986256376, 1.20369434), r1.xyz);
  r2.xyz = r2.xyz + -r1.xyz;
  r1.xyz = r1.www * r2.xyz + r1.xyz;
  r1.w = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r1.xyz = r1.xyz + -r1.www;
  r2.xy = cb1[3].xy * cb1[0].zw;
  r2.xzw = r2.xxx * r1.xyz + r1.www;
  r2.xzw = max(float3(0, 0, 0), r2.xzw);
  r2.xzw = float3(5.55555534, 5.55555534, 5.55555534) * r2.xzw;
  r2.xzw = log2(r2.xzw);
  r2.xyz = r2.yyy * r2.xzw;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r2.xyz;
  r2.xyz = log2(r2.xyz);
  r3.xy = cb1[3].zw * cb1[1].xy;
  r2.w = 1 / r3.x;
  r2.xyz = r2.www * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.w = cb1[4].x + cb1[1].z;
  r2.xyz = r2.xyz * r3.yyy + r2.www;
  r2.w = 1 / cb1[0].x;
  r2.w = saturate(r2.w * r1.w);
  r3.x = r2.w * -2 + 3;
  r2.w = r2.w * r2.w;
  r2.w = -r3.x * r2.w + 1;
  r3.x = 1 + -r2.w;
  r3.y = -cb1[0].y + r1.w;
  r3.z = 1 + -cb1[0].y;
  r3.z = 1 / r3.z;
  r3.y = saturate(r3.y * r3.z);
  r3.z = r3.y * -2 + 3;
  r3.y = r3.y * r3.y;
  r3.x = -r3.z * r3.y + r3.x;
  r3.y = r3.z * r3.y;
  r2.xyz = r3.xxx * r2.xyz;
  r3.x = cb1[1].w * cb1[0].z;
  r3.xzw = r3.xxx * r1.xyz + r1.www;
  r3.xzw = max(float3(0, 0, 0), r3.xzw);
  r3.xzw = float3(5.55555534, 5.55555534, 5.55555534) * r3.xzw;
  r3.xzw = log2(r3.xzw);
  r4.x = cb1[2].x * cb1[0].w;
  r3.xzw = r4.xxx * r3.xzw;
  r3.xzw = exp2(r3.xzw);
  r3.xzw = float3(0.180000007, 0.180000007, 0.180000007) * r3.xzw;
  r3.xzw = log2(r3.xzw);
  r4.xy = cb1[2].yz * cb1[1].xy;
  r4.x = 1 / r4.x;
  r3.xzw = r4.xxx * r3.xzw;
  r3.xzw = exp2(r3.xzw);
  r4.x = cb1[2].w + cb1[1].z;
  r3.xzw = r3.xzw * r4.yyy + r4.xxx;
  r2.xyz = r3.xzw * r2.www + r2.xyz;
  r3.xz = cb1[4].yz * cb1[0].zw;
  r1.xyz = r3.xxx * r1.xyz + r1.www;
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r1.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = r3.zzz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.w = cb1[4].w * cb1[1].x;
  r1.w = 1 / r1.w;
  r1.xyz = r1.www * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.w = cb1[5].x * cb1[1].y;
  r2.w = cb1[5].y + cb1[1].z;
  r1.xyz = r1.xyz * r1.www + r2.www;
  r1.xyz = r1.xyz * r3.yyy + r2.xyz;
  r2.x = dot(float3(1.70505154, -0.621790707, -0.0832583979), r1.xyz);
  r2.y = dot(float3(-0.130257145, 1.14080286, -0.0105485283), r1.xyz);
  r2.z = dot(float3(-0.0240032747, -0.128968775, 1.15297174), r1.xyz);
  r1.xyz = cb2[1].xyz + -r2.xyz;
  r1.xyz = cb2[2].xxx * r1.xyz + r2.xyz;
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
  // o0.rgb = renodx::color::pq::Encode(o0.rgb);             // convert to PQ
  // o0.rgb = min(1.f, o0.rgb);                 // clamp PQ (10K nits)

  o0.rgb /= 80.f;
  return;
}