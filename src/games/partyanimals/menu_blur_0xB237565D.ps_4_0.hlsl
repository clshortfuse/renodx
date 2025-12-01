#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 17 05:07:28 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyz = float3(0.296906948,0.296906948,0.296906948) * r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * float3(0.196482554,0.196482554,0.196482554) + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v2.zw).xyzw;
  r0.xyz = r1.xyz * float3(0.296906948,0.296906948,0.296906948) + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r0.xyz = r1.xyz * float3(0.0944703892,0.0944703892,0.0944703892) + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v3.zw).xyzw;
  r0.xyz = r1.xyz * float3(0.0944703892,0.0944703892,0.0944703892) + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v4.xy).xyzw;
  r0.xyz = r1.xyz * float3(0.0103813596,0.0103813596,0.0103813596) + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v4.zw).xyzw;

  o0.xyz = r1.xyz * float3(0.0103813596, 0.0103813596, 0.0103813596) + r0.xyz;
  if (RENODX_TONE_MAP_TYPE == 0) o0 = saturate(o0);

  o0.w = 1;
  return;
}