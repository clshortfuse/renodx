#include "../shared.h"

void main(float4 v0: SV_Position0, float4 v1: COLOR0, float2 v2: TEXCOORD0, out float4 o0: SV_Target0) {
  o0.xyzw = v1.xyzw;

  o0 = saturate(o0);
  return;
}
