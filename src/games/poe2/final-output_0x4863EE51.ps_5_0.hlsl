// ---- Created with 3Dmigoto v1.4.1 on Tue Dec  2 20:43:34 2025
#include "shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

cbuffer cb0 : register(b0)
{
  float4 cb0[2];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asint(cb0[0].xy);
  r0.xy = v0.xy / r0.xy;
  r0.xy = cb0[1].xy * r0.xy;
  r0.xy = min(cb0[1].zw, r0.xy);
  r0.xyzw = t0.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r1.x = cmp(asint(cb0[0].z) == 1);
  if (r1.x != 0) {
    // Mode 1: Custom Color Grading / Tone Mapping
    r1.x = dot(float3(0.627403975,0.329281986,0.0433136001), r0.xyz);
    r1.y = dot(float3(0.0690969974,0.919539988,0.0113612004), r0.xyz);
    r1.z = dot(float3(0.0163915996,0.088013202,0.895595014), r0.xyz);
    r1.xyz = saturate(float3(0.00800000038,0.00800000038,0.00800000038) * r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.159301758,0.159301758,0.159301758) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = r1.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
    r1.xyz = r1.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
    r1.xyz = r2.xyz / r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(78.84375,78.84375,78.84375) * r1.xyz;
    r0.xyz = exp2(r1.xyz);
  } else {
    r1.x = cmp(asint(cb0[0].z) == 2);
    if (r1.x == 0) {
      r1.x = cmp(asint(cb0[0].z) == 3);
      if (r1.x == 0) {
        // Default Mode: Linear to sRGB Conversion
        r0.xyz = saturate(r0.xyz);
        // Fix: Explicitly compare vector to float for boolean mask
        bool3 condition = r0.xyz > 0.00313080009;
        
        r2.xyz = log2(r0.xyz);
        r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
        r2.xyz = exp2(r2.xyz);
        r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
        r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
        
        // Fix: Use HLSL intrinsic select() or explicit component-wise selection instead of ternary on vectors
        r0.x = condition.x ? r2.x : r3.x;
        r0.y = condition.y ? r2.y : r3.y;
        r0.z = condition.z ? r2.z : r3.z;
      }
    }
  }
  o0.xyzw = r0.xyzw;
  return;
}