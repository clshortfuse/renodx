// ---- Created with 3Dmigoto v1.4.1 on Sat Dec 27 06:39:35 2025
// Fog blend: reconstructs view-space depth/length, computes fog factor from
// distance and height using global_Data2 and FogPropertyMatrix, then lerps Base
// color toward fog color encoded in global_FogPropertyMatrix rows.

cbuffer PerFrame : register(b13)
{
  float4x4 global_LightPropertyMatrix : packoffset(c0);
  float4x3 global_FogPropertyMatrix : packoffset(c4);
  float4 global_Data : packoffset(c7);
  float4 global_Data2 : packoffset(c8);
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

Texture2D<float4> LinearDepth : register(t0);
Texture2D<float4> Base : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TexCoord0,
  float3 v2 : TexCoord1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Fetch depth and base color (point sampled)
  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r0.z = LinearDepth.Load(r0.xyz).x;
  r1.xyzw = Base.Load(r0.xyw).xyzw;

  // Reconstruct view-space position along ray v2 and get distance/height
  r0.x = r0.z * v2.y + global_ViewPos.y;
  r0.yzw = v2.xyz * r0.zzz;
  r0.y = dot(r0.yzw, r0.yzw);
  r0.y = sqrt(r0.y);
  // Distance-based fog factor (global_Data2: scale/bias per channel)
  r0.yz = saturate(-r0.yy * global_Data2.zx + global_Data2.wy);
  // Height-based fog factor: (pos.y - fogHeightOffset) / fogHeightRange
  r0.x = -global_FogPropertyMatrix._m22 + r0.x;
  r0.x = r0.x / global_FogPropertyMatrix._m32;
  // Combine distance/height fog, clamp 0..1
  r0.x = max(r0.y, r0.x);
  r0.x = min(1, r0.x);

  // Fog color rows from FogPropertyMatrix
  r2.x = global_FogPropertyMatrix._m10;
  r2.y = global_FogPropertyMatrix._m11;
  r2.z = global_FogPropertyMatrix._m12;
  // Lerp base toward fog color
  r1.xyz = -r2.xyz + r1.xyz;
  o0.w = r1.w;
  r0.xyw = r0.xxx * r1.xyz + r2.xyz;
  r1.x = global_FogPropertyMatrix._m00;
  r1.y = global_FogPropertyMatrix._m01;
  r1.z = global_FogPropertyMatrix._m02;
  r0.xyw = -r1.xyz + r0.xyw;
  o0.xyz = r0.zzz * r0.xyw + r1.xyz;
  return;
}