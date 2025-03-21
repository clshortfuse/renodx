#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Mar 21 00:58:54 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xz = v1.xx;
  r1.xyzw = cb0[2].yyyy * float4(1.38461494,3.23076892,-0.615384996,-2.76923108) + v1.yyyy;
  r0.yw = r1.xz;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = float3(0.316260993,0.316260993,0.316260993) * r0.xyz;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = r2.xyz * float3(0.227026999,0.227026999,0.227026999) + r0.xyz;
  r1.xz = v1.xx;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  o0.xyz = r1.xyz * float3(0.0702700019,0.0702700019,0.0702700019) + r0.xyz;
  o0.w = 1;

  if (RENODX_TONE_MAP_TYPE == 0) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}