// ---- Created with 3Dmigoto v1.4.1 on Sat Dec 27 06:39:35 2025
// 2x2 box filter: averages color from Base and sums a blur mask from Base2.
// The mask sum is scaled by dofEqWorld to produce DOF alpha; RGB is the
// averaged color of the four taps.

cbuffer _Globals : register(b0)
{
  float2 dofEqWorld : packoffset(c0);
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
Texture2D<float4> Base : register(t0);
Texture2D<float4> Base2 : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Compute half-pixel offsets for the 2x2 kernel
  r0.xy = float2(0.25,0.25) / global_ViewInfo.zw;
  r0.zw = -r0.xy;
  // Precompute the four UVs around the pixel
  r1.xyzw = v1.xyxy + r0.zyxw;                           // top-left (xy), top-right (zw)
  // Sample mask (Base2) and color (Base) at the 4 taps
  r0.z = Base2.Sample(LinearClampSampler_s, r1.xy).x;    // top-left mask
  r2.xy = v1.xy + -r0.xy;                                // bottom-left UV
  r0.xy = v1.xy + r0.xy;                                 // bottom-right UV
  r0.w = Base2.Sample(LinearClampSampler_s, r2.xy).x;    // bottom-left mask
  r2.xyz = Base.Sample(LinearClampSampler_s, r2.xy).xyz; // bottom-left color
  r0.z = r0.w + r0.z;                                    // partial mask sum (tl+bl)
  r0.w = Base2.Sample(LinearClampSampler_s, r1.zw).x;    // top-right mask
  r0.z = r0.z + r0.w;                                    // sum (tl+bl+tr)
  r0.w = Base2.Sample(LinearClampSampler_s, r0.xy).x;    // bottom-right mask
  r3.xyz = Base.Sample(LinearClampSampler_s, r0.xy).xyz; // bottom-right color
  // DOF alpha: sum all 4 mask taps, scale, and bias
  r0.x = r0.z + r0.w;                                   // total mask sum
  r0.x = dofEqWorld.x * r0.x;
  o0.w = saturate(r0.x * 0.25 + dofEqWorld.y);

  // Color: average the four taps from Base
  r0.xyz = Base.Sample(LinearClampSampler_s, r1.xy).xyz; // top-left color
  r1.xyz = Base.Sample(LinearClampSampler_s, r1.zw).xyz; // top-right color
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r0.xyz = r0.xyz + r3.xyz;
  o0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  return;
}