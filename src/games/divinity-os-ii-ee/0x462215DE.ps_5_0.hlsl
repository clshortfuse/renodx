// ---- Created with 3Dmigoto v1.4.1 on Sat Dec 27 06:39:35 2025
// Applies a vignette tint in PQ space. Converts Base to PQ, converts VignetteColor
// from sRGB to linear then PQ, blends toward the vignette with radial weight
// from VignetteParams, re-encodes, and outputs alpha=1.

cbuffer _Globals : register(b0)
{
  float3 VignetteColor : packoffset(c0);
  float2 VignetteParams : packoffset(c1);
}

Texture2D<float4> Base : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TexCoord0,
  float2 w1 : TexCoord1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r0.xyz = Base.Load(r0.xyz).xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r0.xyz;
  r0.xyz = -r0.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
  r1.xyz = max(float3(0,0,0), r1.xyz);
  // Load base color (point sample via integer coords)
  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r0.xyz = Base.Load(r0.xyz).xyz;

  // Base -> PQ
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r0.xyz;
  r0.xyz = -r0.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(6.27739477,6.27739477,6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);

  // VignetteColor sRGB -> linear
  r1.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + VignetteColor.xyz;
  r1.xyz = float3(0.947867334,0.947867334,0.947867334) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * VignetteColor.xyz;
  r3.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= VignetteColor.xyz);
  r1.xyz = r3.xyz ? r2.xyz : r1.xyz; // linear vignette color

  // Vignette linear -> PQ
  r2.x = dot(float3(0.627399981,0.329299986,0.0432999991), r1.xyz);
  r2.y = dot(float3(0.0691,0.919499993,0.0114000002), r1.xyz);
  r2.z = dot(float3(0.0164000001,0.0879999995,0.895600021), r1.xyz);
  r1.xyz = -r0.xyz * float3(10000,10000,10000) + r2.xyz;
  r0.xyz = float3(10000,10000,10000) * r0.xyz;

  // Radial weight from w1 with VignetteParams falloff
  r2.xy = float2(-0.5,-0.5) + w1.xy;
  r2.xy = r2.xy + r2.xy;
  r2.xy = log2(abs(r2.xy));
  r2.xy = VignetteParams.yy * r2.xy;
  r2.xy = exp2(r2.xy);
  r0.w = dot(r2.xy, r2.xy);
  r0.w = sqrt(r0.w);
  r0.w = saturate(VignetteParams.x * r0.w);

  // Blend base PQ toward vignette PQ
  r0.xyz = r0.www * r1.xyz + r0.xyz;

  // PQ encode back out
  r0.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758,0.159301758,0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r0.xyz = r0.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375,78.84375,78.84375) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = 1;
}