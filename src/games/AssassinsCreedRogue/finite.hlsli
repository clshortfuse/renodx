#ifndef RENODX_ROGUE_FINITE_HLSLI_
#define RENODX_ROGUE_FINITE_HLSLI_

static const float ROGUE_FP16_MAX = 65504.f;

float RogueFinite(float value) {
  return (asuint(value) & 0x7f800000u) != 0x7f800000u ? value : 0.f;
}

float3 RogueFinite(float3 value) {
  return float3(RogueFinite(value.r), RogueFinite(value.g), RogueFinite(value.b));
}

float4 RogueFinite(float4 value) {
  return float4(RogueFinite(value.rgb), RogueFinite(value.a));
}

bool RogueIsFinite(float4 value) {
  return all((asuint(value) & 0x7f800000u) != 0x7f800000u);
}

float RogueSafeDenominator(float value) {
  value = RogueFinite(value);
  const float magnitude = max(abs(value), 1.e-7f);
  return asfloat(asuint(magnitude) | (asuint(value) & 0x80000000u));
}

#endif
