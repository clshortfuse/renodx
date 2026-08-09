#include "../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
    float4 cb0[30];
}

// ZERO PARADES: For Dead Spies

void main(
    float4 v0 : SV_POSITION0,
    float2 v1 : TEXCOORD0,
    float2 w1 : TEXCOORD1,
    out float4 o0 : SV_Target0) {
    float4 r0,r1;
    uint4 bitmask, uiDest;
    float4 fDest;

    r0.x = -1.1375035 * cb0[29].x;
    r0.x = exp2(r0.x);
    r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
    if (injectedData.toneMapType == 0.f) {
      r1.xyz = pow(r1.xyz, r0.x);
    } else {
      r1.xyz = sign(r1.xyz) * pow(abs(r1.xyz), r0.x);
    }
    o0.xyzw = r1.xyzw;
    return;
}