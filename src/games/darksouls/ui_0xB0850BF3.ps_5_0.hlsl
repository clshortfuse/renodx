#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Tue Jun 04 23:18:28 2024

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : SV_Position0, float4 v1
          : COLOR0, float3 v2
          : TEXCOORD0, out float4 o0
          : SV_Target0) {
  o0.xyzw = v1.xyzw;

  o0.xyz = saturate(o0.xyz);

  // TODO: figure out what this shader does
  // o0.rgb = (1, 0, 1);

  return;
}