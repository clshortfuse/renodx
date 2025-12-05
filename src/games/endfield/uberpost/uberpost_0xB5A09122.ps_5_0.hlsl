// ---- Created with 3Dmigoto v1.3.16 on Thu Dec 04 15:44:58 2025

#include "../shared.h"

// First Area Uberpost
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[12];
}

cbuffer cb0 : register(b0) {
  float4 cb0[94];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[66].x / cb0[66].y;
  r0.y = -1 + r0.x;
  r0.y = cb1[2].w * r0.y + 1;
  r0.x = r0.x * 0.5625 + -r0.y;
  r0.x = cb1[1].w * r0.x + r0.y;
  r0.y = saturate(cb1[2].x * 1.04999995);
  r0.y = r0.y * 1.5 + -1;
  r0.y = cb1[1].w * r0.y + 1;
  r0.z = -cb1[2].x + 1;
  r0.z = cb1[1].w * r0.z + cb1[2].x;
  r1.xy = -cb1[1].xy + v1.xy;
  r0.zw = abs(r1.xy) * r0.zz;
  r0.y = r0.z * r0.y;
  r0.x = saturate(r0.y * r0.x);
  r0.z = cb1[2].x * 2 + -1;
  r0.z = cb1[1].w * r0.z + 1;
  r1.x = saturate(cb1[2].x + -2.79999995);
  r1.x = 5 * r1.x;
  r0.y = saturate(r0.w * r0.z + r1.x);
  r0.xy = log2(r0.xy);
  r0.xy = cb1[2].zz * r0.xy;
  r0.xy = exp2(r0.xy);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = log2(r0.x);
  r0.x = cb1[2].y * r0.x;
  r0.x = exp2(r0.x);
  r0.yzw = -cb1[4].zxy + float3(1, 1, 1);
  r0.xyz = r0.xxx * r0.yzw + cb1[4].zxy;
  r1.xyz = t1.SampleLevel(s0_s, v1.xy, 0).xyz;
  r2.xyz = log2(r1.zxy);
  r2.xyz = float3(0.330000013, 0.330000013, 0.330000013) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.49380004, 1.49380004, 1.49380004) + float3(-0.699999988, -0.699999988, -0.699999988);
  r0.w = -cb1[9].z + 1;
  r3.xyz = r1.zxy * r0.www;
  r3.xyz = cmp(float3(0.300000012, 0.300000012, 0.300000012) < r3.xyz);
  r1.xyz = r3.xyz ? r2.xyz : r1.zxy;
  r2.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r3.xyz = cb0[93].xxx * r2.zxy;
  r0.w = max(r3.y, r3.z);
  r0.w = max(r0.w, r3.x);
  r4.xy = -cb1[10].yx + r0.ww;
  r0.w = max(9.99999975e-005, r0.w);
  r1.w = max(0, r4.x);
  r1.w = min(cb1[10].z, r1.w);
  r1.w = r1.w * r1.w;
  r1.w = cb1[10].w * r1.w;
  r1.w = max(r1.w, r4.y);
  r0.w = r1.w / r0.w;
  r4.xyz = r3.xyz * r0.www;
  r4.xyz = -r4.xyz * cb1[9].zzz + r3.xyz;
  r1.xyz = r1.xyz * cb1[11].zxy + r4.xyz;
  r1.xyz = -r2.zxy * cb0[93].xxx + r1.xyz;
  o0.w = min(1, r2.w);
  r1.xyz = cb1[9].xxx * r1.xyz + r3.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = cb1[7].www * r0.xyz;

  // Define untonemapped
  float3 untonemapped = r0.yzx;

  // Original LUT Sampling & sRGB Encode
  r0.xyz = r0.xyz * float3(5.55555582, 5.55555582, 5.55555582) + float3(0.0479959995, 0.0479959995, 0.0479959995);
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839, 0.0734997839, 0.0734997839) + float3(0.386036009, 0.386036009, 0.386036009));
  r0.yzw = cb1[7].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r0.x = r0.x * cb1[7].z + -r0.y;
  r1.xy = cb1[7].xy * float2(0.5, 0.5);
  r1.yz = r0.zw * cb1[7].xy + r1.xy;
  r1.x = r0.y * cb1[7].y + r1.y;
  r2.x = cb1[7].y;
  r2.y = 0;
  r0.yz = r2.xy + r1.xz;
  r1.xyz = t2.SampleLevel(s0_s, r1.xz, 0).xyz;
  r0.yzw = t2.SampleLevel(s0_s, r0.yz, 0).xyz;
  r0.yzw = r0.yzw + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;

  r1.xyz = log2(abs(r0.xyz));
  r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r0.xyz;
  r0.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
  r0.xyz = r0.xyz ? r2.xyz : r1.xyz;

  // Dithering
  r1.xy = cb0[66].xy * v1.xy;
  r0.w = dot(float2(171, 231), r1.xy);
  r1.xyz = float3(0.00970873795, 0.0140845068, 0.010309278) * r0.www;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
  o0.xyz = r1.xyz * float3(0.0013725491, 0.0013725491, 0.0013725491) + r0.xyz;

  // sRGB Decode and output
  o0.xyz = renodx::color::srgb::Decode(o0.xyz);
  o0.xyz = renodx::draw::ToneMapPass(untonemapped, o0.xyz);
  o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
  return;
}
