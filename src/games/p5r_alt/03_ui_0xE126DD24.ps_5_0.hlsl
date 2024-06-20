#include "../../shaders/color.hlsl"
#include "./shared.h"

float4 main(float4 v0 : SV_POSITION0, float4 v1 : COLOR0) : SV_TARGET0 {
  if (injectedData.uiState == UI_STATE__MIN_ALPHA) return 1.f;
  if (injectedData.uiState == UI_STATE__MAX_ALPHA) return 0.f;
  return v1;
}
