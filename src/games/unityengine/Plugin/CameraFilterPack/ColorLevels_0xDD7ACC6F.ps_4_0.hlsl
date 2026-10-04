#include "../../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * cb0[5].xy + cb0[5].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyz = -cb0[2].yyy + r0.xyz;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
  }
  r0.w = cb0[2].w + -cb0[2].y;
  r0.xyz = r0.xyz / r0.www;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = min(float3(1, 1, 1), r0.xyz);
  }
  r0.xyz = sign(r0.xyz) * pow(abs(r0.xyz), 1 / cb0[2].z);
  r0.w = cb0[3].y + -cb0[3].x;
  o0.xyz = r0.xyz * r0.www + cb0[3].xxx;
  o0.w = 1;
  return;
}