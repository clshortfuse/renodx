#include "./shared.h"

float4 main(float4 v0 : SV_POSITION0, float4 v1 : COLOR0) : SV_TARGET0 {
  if (injectedData.clampState == CLAMP_STATE__MIN_ALPHA) return 1.f;
  if (injectedData.clampState == CLAMP_STATE__MAX_ALPHA) return 0.f;
  float4 o0 = v1;
  if (injectedData.clampState == CLAMP_STATE__OUTPUT) {
    o0 = saturate(o0);
  }
  return o0;
}
