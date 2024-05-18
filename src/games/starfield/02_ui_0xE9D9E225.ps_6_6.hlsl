#include "../../shaders/color.hlsl"
#include "./shared.h"


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
  float4 _35 = _8.Sample(_18, float2(TEXCOORD.x, TEXCOORD.y));
  float3 inputColor = _35.rgb;
  uint4 _46 = asuint(_15_m0[0u]);
  float _48 = asfloat(_46.x);
  float _49 = _48 * _35.x;
  float _50 = _48 * _35.y;
  float _51 = _48 * _35.z;
  float _99 = max(asfloat(_46.z), 0.001000000047497451305389404296875f);
  float _112 = (((min(1.0f, _49 * 99999.9921875f) * 2.0f) * ((((((((((_49 * 0.078460276126861572265625f) + (-0.2889308035373687744140625f)) * _49) + 0.655828952789306640625f) * _49) + 0.52069270610809326171875f) * _49) + 0.0332120954990386962890625f) * _49) + 0.0008656803402118384838104248046875f)) + (-1.0f)) * _99;
  float _113 = (((min(1.0f, _50 * 99999.9921875f) * 2.0f) * ((((((((((_50 * 0.078460276126861572265625f) + (-0.2889308035373687744140625f)) * _50) + 0.655828952789306640625f) * _50) + 0.52069270610809326171875f) * _50) + 0.0332120954990386962890625f) * _50) + 0.0008656803402118384838104248046875f)) + (-1.0f)) * _99;
  float _114 = (((min(1.0f, _51 * 99999.9921875f) * 2.0f) * ((((((((((_51 * 0.078460276126861572265625f) + (-0.2889308035373687744140625f)) * _51) + 0.655828952789306640625f) * _51) + 0.52069270610809326171875f) * _51) + 0.0332120954990386962890625f) * _51) + 0.0008656803402118384838104248046875f)) + (-1.0f)) * _99;
  float _119 = (_99 / sqrt((_99 * _99) + 1.0f)) * 2.0f;
  float _142 = 1.0f / max(asfloat(_46.y), 0.001000000047497451305389404296875f);
  SV_Target.x = max((exp2(log2((_112 / (sqrt((_112 * _112) + 1.0f) * _119)) + 0.5f) * _142) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
  SV_Target.y = max((exp2(log2((_113 / (sqrt((_113 * _113) + 1.0f) * _119)) + 0.5f) * _142) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
  SV_Target.z = max((exp2(log2((_114 / (sqrt((_114 * _114) + 1.0f) * _119)) + 0.5f) * _142) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
  // SV_Target.rgb = inputColor.rgb;
  // SV_Target.rgb = 10.f;
  SV_Target.w = _35.w;

  float3 outputColor = SV_Target.rgb;
  float3 signs = sign(outputColor.rgb);
  outputColor = abs(outputColor);
  outputColor = injectedData.toneMapGammaCorrection ? pow(outputColor, 2.2f) : linearFromSRGB(outputColor.rgb);
  outputColor *= signs;
  // outputColor *= injectedData.toneMapUINits / 80.f;
  SV_Target.rgb = outputColor;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
