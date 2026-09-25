#include "../../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  noperspective float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[0].z / cb0[0].x;
  r0.xy = float2(9.99999975e-005,-0.999899983) + r0.xx;
  r0.x = r0.x / r0.y;
  r0.y = 0.5 * r0.x;
  r0.z = -0.5 + r0.x;
  r0.y = r0.y / r0.z;
  r0.y = 1 + -r0.y;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r1.w;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
  r1.xyz = saturate(r1.xyz);
  r1.w = dot(r1.xyz, float3(0.212670997,0.715160012,0.0721689984));
  r2.xyzw = r1.xyzw * r0.xxxx;
  r3.xyzw = -r1.xyzw + r0.xxxx;
  r2.xyzw = r2.xyzw / r3.xyzw;
  r0.xyzw = r2.xyzw + r0.yyyy;
  r2.xyzw = float4(1.00010002,1.00010002,1.00010002,1.00010002) + -r1.xyzw;
  r2.xyzw = r1.xyzw / r2.xyzw;
  r3.xyzw = cmp(float4(0.5,0.5,0.5,0.5) < r1.xyzw);
  r1.w = 9.99999975e-005 + r1.w;
  r1.xyz = r1.xyz / r1.www;
  r0.xyzw = r3.xyzw ? r0.xyzw : r2.xyzw;
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = cb0[0].yyy * r0.xyz;
  r0.w = 1 + -cb0[0].y;
  o0.xyz = r0.www * r1.xyz + r0.xyz;
  } else {
    o0.xyz = r1.xyz;
  }
  return;
}