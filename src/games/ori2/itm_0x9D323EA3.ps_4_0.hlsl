#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Aug 15 21:14:36 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[9];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    linear noperspective float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r1.w;
  if (RENODX_TONE_MAP_TYPE != 0) {
    o0.xyz = r1.xyz * cb0[5].xxx + cb0[5].yyy;  // fade to black
  } else {                                      // inverse tonemapping garbage, also applies to UI
    r0.x = cb0[7].z / cb0[7].x;
    r0.xy = float2(9.99999975e-005, -0.999899983) + r0.xx;
    r0.x = r0.x / r0.y;
    r0.y = 0.5 * r0.x;
    r0.z = -0.5 + r0.x;
    r0.y = r0.y / r0.z;
    r0.y = 1 + -r0.y;
    r1.xyz = saturate(r1.xyz);  // clamps render
    r1.w = dot(r1.xyz, float3(0.212670997, 0.715160012, 0.0721689984));
    r2.xyzw = r1.xyzw * r0.xxxx;
    r3.xyzw = -r1.xyzw + r0.xxxx;
    r2.xyzw = r2.xyzw / r3.xyzw;
    r0.xyzw = r2.xyzw + r0.yyyy;
    r2.xyzw = float4(1.00010002, 1.00010002, 1.00010002, 1.00010002) + -r1.xyzw;
    r2.xyzw = r1.xyzw / r2.xyzw;
    r3.xyzw = cmp(float4(0.5, 0.5, 0.5, 0.5) < r1.xyzw);
    r1.w = 9.99999975e-005 + r1.w;
    r1.xyz = r1.xyz / r1.www;
    r0.xyzw = r3.xyzw ? r0.xyzw : r2.xyzw;
    r1.xyz = r1.xyz * r0.www;
    r0.xyz = cb0[7].yyy * r0.xyz;
    r0.w = 1 + -cb0[7].y;
    r0.xyz = r0.www * r1.xyz + r0.xyz;
    r0.w = dot(r0.xyz, float3(0.212670997, 0.715160012, 0.0721689984));
    r1.xy = -cb0[8].xz + r0.ww;
    r1.xy = saturate(cb0[8].yw * r1.xy);
    r0.w = 1 + -r1.y;
    r0.w = min(r1.x, r0.w);
    r0.xyz = r0.www * cb0[6].www + r0.xyz;
    r0.xyz = r0.xyz * cb0[5].xxx + cb0[5].yyy;  // fade to black
    o0.xyz = max(float3(0, 0, 0), r0.xyz);
  }
  return;
}
