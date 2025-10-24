#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 10:46:26 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

// 3Dmigoto declarations
#define cmp -

static float offsets[3] = { 0.0, 1.3846153846, 3.2307692308 };
static float weights[3] = { 0.2270270270, 0.3162162162, 0.0702702703 };

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float texScale = cb0[2].y;

  o0 = t0.Sample(s0_s, v1) * weights[0];

  for (int i = 1; i < 3; i++) {
    o0 += t0.Sample(s0_s, v1 + float2(0.0, offsets[i]) * texScale) * weights[i];
    o0 += t0.Sample(s0_s, v1 - float2(0.0, offsets[i]) * texScale) * weights[i];
  }

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
}
