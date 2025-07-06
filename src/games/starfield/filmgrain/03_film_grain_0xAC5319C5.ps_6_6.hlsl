#include "../shared.h"

// acb300db9ca1244918096157e996d141

cbuffer _13_15 : register(b0, space0) {
  float4 _15_m0[1] : packoffset(c0);
}

Texture2D<float4> _8 : register(t0, space8);
SamplerState _18 : register(s0, space8);

static float4 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  uint4 _34 = asuint(_15_m0[0u]);
  float4 _70 = _8.Sample(_18, float2(TEXCOORD.x, TEXCOORD.y));
  // float _73 = _70.x;
  // float _87 = (((frac(sin(((float(int(uint(int(asfloat(_34.x))) & 1023u)) * 0.000977517105638980865478515625f) + TEXCOORD.x) + (((float(int(uint(int(asfloat(_34.y))) & 1023u)) * 0.000977517105638980865478515625f) + TEXCOORD.y) * 521.0f)) * 493013.0f) * 2.0f) + (-1.0f)) * asfloat(_34.z)) * clamp(1.0f - dot(float3(_73, _70.yz), float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f)), 0.0f, 1.0f);
  // SV_Target.x = clamp(_87 + _73, 0.0f, 1.0f);
  // SV_Target.y = clamp(_87 + _70.y, 0.0f, 1.0f);
  // SV_Target.z = clamp(_87 + _70.z, 0.0f, 1.0f);
  SV_Target.rgb = _70.rgb;

  if (CUSTOM_FILM_GRAIN) {
    float3 outputColor = SV_Target.rgb;
    outputColor = renodx::draw::InvertIntermediatePass(outputColor);
    outputColor = renodx::effects::ApplyFilmGrain(
        outputColor,
        TEXCOORD.xy,
        CUSTOM_RANDOM,
        _34.z ? CUSTOM_FILM_GRAIN * 0.03f : 0,
        1.f);

    outputColor = renodx::draw::RenderIntermediatePass(outputColor);
    SV_Target.rgb = outputColor;
  }
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
