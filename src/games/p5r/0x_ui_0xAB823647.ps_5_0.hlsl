#include "./shared.h"

SamplerState opaueSampler_s : register(s0);
Texture2D<float4> opaueTexture : register(t0);

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_TARGET0 {
  if (injectedData.clampState == CLAMP_STATE__MIN_ALPHA) return 1.f;
  if (injectedData.clampState == CLAMP_STATE__MAX_ALPHA) return 0.f;
  float4 r0, r1, o0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = opaueTexture.Sample(opaueSampler_s, v1.xy).xyzw;
  r0.xyz = r0.xyz / r0.www;
  r1.x = cmp(r0.w >= 1);
  r1.x = r1.x ? 1 : 0;
  r1.x = 0.752499998 * r1.x;
  r1.x = 0.247500002 + r1.x;
  r0.xyz = r1.xxx * r0.xyz;
  r1.x = cmp(0 < r0.w);
  r0.w = cmp(r0.w < 0);
  r1.x = -(int)r1.x;
  r0.w = (int)r0.w + (int)r1.x;
  r0.w = (int)r0.w;
  r0.w = max(0, r0.w);
  r0.w = min(1, r0.w);
  o0.xyz = r0.xyz;
  o0.w = r0.w;
  if (injectedData.clampState == CLAMP_STATE__OUTPUT) {
    o0 = saturate(o0);
  }
  return o0;
}
