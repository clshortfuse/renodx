// ---- Created with 3Dmigoto v1.4.1 on Sat Dec 27 06:33:23 2025
// Overlay compositing shader with dual paths:
// - If overlay alpha is near zero, show base.
// - If overlay alpha is one, convert overlay from sRGB to XYZ, apply exposure (Params.x), then encode PQ.
// - If overlay alpha is partial, convert both base and overlay to PQ, scale overlay by alpha, and blend base+overlay in PQ.
// Output is PQ-encoded RGB with alpha set to 1.

cbuffer _Globals : register(b0)
{
  float2 ViewportOffset : packoffset(c0);
  float4 Params : packoffset(c1);
}

SamplerState LinearClampSampler_s : register(s0);
Texture2D<float4> Base : register(t0);
Texture2D<float4> Tex : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TexCoord0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Sample overlay with viewport offset
  r0.xy = -ViewportOffset.xy + v1.xy;
  r0.xyzw = Tex.Sample(LinearClampSampler_s, r0.xy).xyzw;
  r1.x = cmp(r0.w < 0.00100000005);
  if (r1.x != 0) {
    // No overlay: pass through base
    r1.xyz = Base.Sample(LinearClampSampler_s, v1.xy).xyz;
  } else {
    r1.w = cmp(r0.w == 1.000000);
    if (r1.w != 0) {
      // Full overlay: convert overlay from sRGB to linear (IEC), then to XYZ
      r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
      r3.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
      r3.xyz = float3(0.947867334,0.947867334,0.947867334) * r3.xyz;
      r3.xyz = log2(r3.xyz);
      r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
      r3.xyz = exp2(r3.xyz);
      r4.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
      r2.xyz = r4.xyz ? r2.xyz : r3.xyz;
      r3.x = dot(float3(0.627399981,0.329299986,0.0432999991), r2.xyz);
      r3.y = dot(float3(0.0691,0.919499993,0.0114000002), r2.xyz);
      r3.z = dot(float3(0.0164000001,0.0879999995,0.895600021), r2.xyz);
      // Apply exposure scale (Params.x), then encode to PQ
      r2.xyz = Params.xxx * r3.xyz;
      r2.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r2.xyz;
      r2.xyz = log2(r2.xyz);
      r2.xyz = float3(0.159301758,0.159301758,0.159301758) * r2.xyz;
      r2.xyz = exp2(r2.xyz);
      r3.xyz = r2.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
      r2.xyz = r2.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
      r2.xyz = r3.xyz / r2.xyz;
      r2.xyz = log2(r2.xyz);
      r2.xyz = float3(78.84375,78.84375,78.84375) * r2.xyz;
      r1.xyz = exp2(r2.xyz);
    } else {
      // Partial alpha: PQ-blend base and overlay in display space
      // Base to PQ (via log and linear scale constants)
      r2.xyz = Base.Sample(LinearClampSampler_s, v1.xy).xyz;
      r2.xyz = log2(r2.xyz);
      r2.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r2.xyz;
      r2.xyz = exp2(r2.xyz);
      r3.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r2.xyz;
      r3.xyz = max(float3(0,0,0), r3.xyz);
      r2.xyz = -r2.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
      r2.xyz = r3.xyz / r2.xyz;
      r2.xyz = log2(abs(r2.xyz));
      r2.xyz = float3(6.27739477,6.27739477,6.27739477) * r2.xyz;
      r2.xyz = exp2(r2.xyz);
      r2.xyz = float3(10000,10000,10000) * r2.xyz;
      // Overlay to linear then PQ
      r2.xyz = r0.www * -r2.xyz + r2.xyz;
      r3.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
      r4.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
      r4.xyz = float3(0.947867334,0.947867334,0.947867334) * r4.xyz;
      r4.xyz = log2(r4.xyz);
      r4.xyz = float3(2.4000001,2.4000001,2.4000001) * r4.xyz;
      r4.xyz = exp2(r4.xyz);
      r0.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
      r0.xyz = r0.xyz ? r3.xyz : r4.xyz;
      r3.x = dot(float3(0.627399981,0.329299986,0.0432999991), r0.xyz);
      r3.y = dot(float3(0.0691,0.919499993,0.0114000002), r0.xyz);
      r3.z = dot(float3(0.0164000001,0.0879999995,0.895600021), r0.xyz);
      // Alpha-weight overlay (still linear XYZ scaled by Params.x) plus PQ-encoded base
      r0.xyz = r0.www * -r2.xyz + r2.xyz;
      r0.xyz = r3.xyz * Params.xxx + r0.xyz;
      // Final PQ encode of the composite
      r0.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r0.xyz;
      r0.xyz = log2(r0.xyz);
      r0.xyz = float3(0.159301758,0.159301758,0.159301758) * r0.xyz;
      r0.xyz = exp2(r0.xyz);
      r2.xyz = r0.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
      r0.xyz = r0.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
      r0.xyz = r2.xyz / r0.xyz;
      r0.xyz = log2(r0.xyz);
      r0.xyz = float3(78.84375,78.84375,78.84375) * r0.xyz;
      r1.xyz = exp2(r0.xyz);
    }
  }
  o0.xyz = r1.xyz;
  o0.w = 1;
  return;
}