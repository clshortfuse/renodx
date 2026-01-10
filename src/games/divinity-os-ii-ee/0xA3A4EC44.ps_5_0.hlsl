// ---- Created with 3Dmigoto v1.4.1 on Sat Dec 27 06:39:35 2025
// Sight/height post-process with two overlays (Base4/Base5) blended over Base.
// Reconstructs world pos from depth, samples height/aidata (Base7), applies
// edge falloff, converts Base to PQ-like space, then:
//  - Sneak/sight highlight (Weights.x): uses Base4 mask, dithers, blends toward
//    SightProperties color in PQ, applies smoothstep and weighting.
//  - Height/heat highlight (Weights.y): uses Base5 mask/height, applies color
//    ramps and weighting in PQ.
// Finally converts result back from PQ-like to output.

cbuffer _Globals : register(b0)
{
  float4 VPtoRTScaleBias : packoffset(c0);
  float4 SightProperties : packoffset(c1);
  float2 WorldPositionOffset : packoffset(c2);
  float2 AiGridWorldPositionOffset : packoffset(c2.z);
  float3 SightSneakTextureInfo : packoffset(c3);
  float3 HeightTextureInfo : packoffset(c4);
  float2 Weights : packoffset(c5);
}

cbuffer PerView : register(b12)
{
  row_major float4x4 global_View : packoffset(c0);
  row_major float4x4 global_Projection : packoffset(c4);
  row_major float4x4 global_ViewProjection : packoffset(c8);
  float4 global_ViewPos : packoffset(c12);
  float4 global_ViewInfo : packoffset(c13);
  float4 global_ScaleAndBias : packoffset(c14);
}

SamplerState LinearClampSampler_s : register(s0);
SamplerState PointWrapSampler_s : register(s1);
Texture2D<float4> Base : register(t0);
Texture2D<float4> LinearDepth : register(t1);
Texture2D<float4> Base4 : register(t2);
Texture2D<float4> Base5 : register(t3);
Texture2D<float4> Base7 : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TexCoord0,
  float3 v2 : TexCoord1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Base color and depth
  r0.xyz = Base.Sample(LinearClampSampler_s, v1.xy).xyz;
  r0.w = LinearDepth.Sample(PointWrapSampler_s, v1.xy).x;
  r1.x = cmp(r0.w < 1);
  if (r1.x != 0) {
    // Reconstruct world position and setup UVs for sight/height maps
    r1.xyz = r0.www * v2.xyz + global_ViewPos.xyz;
    r2.xyzw = -WorldPositionOffset.xyzw + r1.xzxz;
    r2.xy = r2.xy / SightSneakTextureInfo.zz;
    r2.xy = r2.xy / SightSneakTextureInfo.xy;
    r2.zw = r2.zw / HeightTextureInfo.zz;
    r2.zw = r2.zw / HeightTextureInfo.xy;
    r2.zw = Base7.SampleLevel(LinearClampSampler_s, r2.zw, 0).xy;
    // Height edge falloff
    r0.w = r2.z + -r1.y;
    r0.w = min(1, abs(r0.w));
    r0.w = -0.200000003 + r0.w;
    r0.w = saturate(r0.w + r0.w);
    r1.y = r0.w * -2 + 3;
    r0.w = r0.w * r0.w;
    r0.w = -r1.y * r0.w + 1;
    // Base -> PQ
    r3.xyz = log2(r0.xyz);
    r3.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r4.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r3.xyz;
    r4.xyz = max(float3(0,0,0), r4.xyz);
    r3.xyz = -r3.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
    r3.xyz = r4.xyz / r3.xyz;
    r3.xyz = log2(r3.xyz);
    r3.xyz = float3(6.27739477,6.27739477,6.27739477) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r4.xyz = float3(10000,10000,10000) * r3.xyz;
    r1.yw = cmp(float2(0,0) < Weights.xy);
    if (r1.y != 0) {
      // Sneak/sight highlight path (Weights.x)
      r5.xyz = Base4.SampleLevel(LinearClampSampler_s, r2.xy, 0).xyw;
      r5.xy = ceil(r5.yx);
      r1.y = r5.x + -r5.y;
      // Luma for overlay weight (PQ luma approximation)
      r2.z = dot(r4.xyz, float3(0.262706608,0.677999616,0.0592937991));
      r2.z = log2(r2.z);
      r2.z = 0.699999988 * r2.z;
      r2.z = exp2(r2.z);
      r3.w = 1 + -SightProperties.w;
      // Blend toward target sight color in PQ space
      r5.xyw = -r3.xyz * float3(10000,10000,10000) + r2.zzz;
      r5.xyw = r3.www * r5.xyw + r4.xyz;
      // Dither mask
      r6.xyzw = float4(1.5,1.5,1.5,1.5) * r1.xzxz;
      r6.xyzw = frac(r6.xyzw);
      r1.xz = cmp(float2(0.5,0.5) >= r6.zw);
      r1.xz = r1.xz ? float2(1,1) : 0;
      r6.xyzw = cmp(r6.xyzw >= float4(0.25,0.25,0.75,0.75));
      r6.xy = r6.xy ? float2(1,1) : 0;
      r1.xz = r6.xy * r1.xz;
      r1.x = r1.x + r1.z;
      r6.xy = r6.zw ? float2(-1,-1) : float2(-0,-0);
      r1.x = r6.x + r1.x;
      r1.x = saturate(r1.x + r6.y);
      // SightProperties sRGB -> linear
      r6.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * SightProperties.xyz;
      r7.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + SightProperties.xyz;
      r7.xyz = float3(0.947867334,0.947867334,0.947867334) * r7.xyz;
      r7.xyz = log2(r7.xyz);
      r7.xyz = float3(2.4000001,2.4000001,2.4000001) * r7.xyz;
      r7.xyz = exp2(r7.xyz);
      r8.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= SightProperties.xyz);
      r6.xyz = r8.xyz ? r6.xyz : r7.xyz;
      r7.x = dot(float3(0.627399981,0.329299986,0.0432999991), r6.xyz);
      r7.y = dot(float3(0.0691,0.919499993,0.0114000002), r6.xyz);
      r7.z = dot(float3(0.0164000001,0.0879999995,0.895600021), r6.xyz);
      r1.z = SightProperties.w * 0.225000009 + 0.075000003;
      // PQ target color for sight
      r6.xyz = r7.xyz * float3(240,240,240) + -r4.xyz;
      r6.xyz = r1.zzz * r6.xyz + r4.xyz;
      r8.xyz = -r3.xyz * float3(10000,10000,10000) + float3(85.0906219,169.43338,25.4893398);
      r8.xyz = r8.xyz * float3(0.400000006,0.400000006,0.400000006) + r4.xyz;
      r1.x = r1.y * r1.x;
      // Mix toward sight color with dither and weights
      r8.xyz = r8.xyz + -r6.xyz;
      r1.xyz = r1.xxx * r8.xyz + r6.xyz;
      r1.xyz = -r3.xyz * float3(10000,10000,10000) + r1.xyz;
      r1.xyz = r0.www * r1.xyz + r4.xyz;
      // Soft threshold by Base4 alpha
      r1.xyz = log2(r1.xyz);
      r1.xyz = float3(1.04999995,1.04999995,1.04999995) * r1.xyz;
      r1.xyz = exp2(r1.xyz);
      r1.xyz = r3.xyz * float3(10,10,10) + r1.xyz;
      r2.z = cmp(r5.z >= 0.430000007);
      r2.z = r2.z ? 1.000000 : 0;
      r3.w = cmp(0.569999993 >= r5.z);
      r3.w = r3.w ? 1.000000 : 0;
      r2.z = r3.w * r2.z;
      r3.w = saturate(2.32558131 * r5.z);
      r4.w = r3.w * -2 + 3;
      r3.w = r3.w * r3.w;
      r3.w = r4.w * r3.w;
      r4.w = -0.670000017 + r5.z;
      r4.w = saturate(-9.99999809 * r4.w);
      r6.x = r4.w * -2 + 3;
      r4.w = r4.w * r4.w;
      r4.w = r6.x * r4.w;
      r3.w = saturate(r3.w * r4.w + -r2.z);
      r1.xyz = r1.xyz + -r5.xyw;
      r1.xyz = r5.zzz * r1.xyz + r5.xyw;
      r3.w = r3.w * r0.w;
      r3.w = 0.5 * r3.w;
      // Apply mask ramp
      r1.xyz = r3.www * -r1.xyz + r1.xyz;
      r2.z = r2.z * r0.w;
      r2.z = 1.5 * r2.z;
      // Push toward a brighter PQ target when mask is strong
      r5.xyz = r7.xyz * float3(300,300,300) + -r1.xyz;
      r1.xyz = r2.zzz * r5.xyz + r1.xyz;
      // Accumulate into PQ base
      r1.xyz = -r3.xyz * float3(10000,10000,10000) + r1.xyz;
      r4.xyz = Weights.xxx * r1.xyz + r4.xyz;
    }
    if (r1.w != 0) {
      // Height/heat overlay (Weights.y)
      r1.x = Base5.SampleLevel(LinearClampSampler_s, r2.xy, 0).x;
      r1.y = r1.x + r1.x;
      r1.y = saturate(r1.y);
      r1.z = r1.y * r2.w;
      // Two colors in PQ to interpolate between based on mask
      r2.xyz = float3(91.8181915,12.2531338,4.74269295) + -r4.xyz;
      r3.xyz = r2.xyz * float3(0.400000006,0.400000006,0.400000006) + r4.xyz;
      r2.xyz = r2.xyz * float3(0.150000006,0.150000006,0.150000006) + r4.xyz;
      r1.x = saturate(r1.x * 2 + -1);
      r1.x = -0.400000006 + r1.x;
      r1.x = saturate(4.99999952 * r1.x);
      r1.w = r1.x * -2 + 3;
      r1.x = r1.x * r1.x;
      r1.x = r1.w * r1.x;
      r3.xyz = r3.xyz + -r2.xyz;
      r2.xyz = r1.xxx * r3.xyz + r2.xyz;
      r2.xyz = r2.xyz + -r4.xyz;
      r2.xyz = r2.xyz * r0.www;
      r1.x = cmp(r1.z >= 0.430000007);
      r1.w = cmp(0.569999993 >= r1.z);
      r1.xw = r1.xw ? float2(1,1) : 0;
      r1.x = r1.x * r1.w;
      r1.w = saturate(2.32558131 * r1.z);
      r3.x = r1.w * -2 + 3;
      r1.w = r1.w * r1.w;
      r1.w = r3.x * r1.w;
      r1.y = r1.y * r2.w + -0.670000017;
      r1.y = saturate(-9.99999809 * r1.y);
      r2.w = r1.y * -2 + 3;
      r1.y = r1.y * r1.y;
      r1.y = r2.w * r1.y;
      r1.y = saturate(r1.w * r1.y + -r1.x);
      r2.xyz = r1.zzz * r2.xyz + r4.xyz;
      r1.y = r1.y * r0.w;
      r1.y = 0.5 * r1.y;
      // Blend toward heat color using mask ramp
      r1.yzw = r1.yyy * -r2.xyz + r2.xyz;
      r0.w = r1.x * r0.w;
      r0.w = 1.5 * r0.w;
      r2.xyz = float3(91.8181915,12.2531338,4.74269295) + -r1.yzw;
      r1.xyz = r0.www * r2.xyz + r1.yzw;
      r1.xyz = r1.xyz + -r4.xyz;
      r4.xyz = Weights.yyy * r1.xyz + r4.xyz;
    }
    // PQ -> output
    r1.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r4.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.159301758,0.159301758,0.159301758) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = r1.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
    r1.xyz = r1.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
    r1.xyz = r2.xyz / r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(78.84375,78.84375,78.84375) * r1.xyz;
    r0.xyz = exp2(r1.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}