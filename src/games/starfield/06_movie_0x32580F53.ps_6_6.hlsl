#include "../../shaders/color.hlsl"
#include "../../shaders/tonemap.hlsl"
#include "./shared.h"

cbuffer _15_17 : register(b0, space0) {
  float4 _17_m0[1] : packoffset(c0);
}

Texture2D<float4> _8 : register(t0, space8);
Texture2D<float4> _9 : register(t1, space8);
Texture2D<float4> _10 : register(t2, space8);
SamplerState _20 : register(s0, space8);

static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float4 _44 = _9.Sample(_20, float2(TEXCOORD.x, TEXCOORD.y));
  float _46 = _44.x;
  float4 _49 = _10.Sample(_20, float2(TEXCOORD.x, TEXCOORD.y));
  float _51 = _49.x;
  float _52 = _8.Sample(_20, float2(TEXCOORD.x, TEXCOORD.y)).x * 1.16412353515625f;
  float _66 = (_52 + (-0.870655059814453125f)) + (_46 * 1.595794677734375f);
  float _67 = ((_52 - (_46 * 0.8134765625f)) - (_51 * 0.391448974609375f)) + 0.529705047607421875f;
  float _71 = (_52 + (-1.081668853759765625f)) + (_51 * 2.017822265625f);
  uint4 _121 = asuint(_17_m0[0u]);
  float _124 = max(asfloat(_121.y), 0.001000000047497451305389404296875f);
  float _137 = (((min(1.0f, _66 * 99999.9921875f) * 2.0f) * ((((((((((_66 * 0.078460276126861572265625f) + (-0.2889308035373687744140625f)) * _66) + 0.655828952789306640625f) * _66) + 0.52069270610809326171875f) * _66) + 0.0332120954990386962890625f) * _66) + 0.0008656803402118384838104248046875f)) + (-1.0f)) * _124;
  float _138 = (((min(1.0f, _67 * 99999.9921875f) * 2.0f) * ((((((((((_67 * 0.078460276126861572265625f) + (-0.2889308035373687744140625f)) * _67) + 0.655828952789306640625f) * _67) + 0.52069270610809326171875f) * _67) + 0.0332120954990386962890625f) * _67) + 0.0008656803402118384838104248046875f)) + (-1.0f)) * _124;
  float _139 = (((min(1.0f, _71 * 99999.9921875f) * 2.0f) * ((((((((((_71 * 0.078460276126861572265625f) + (-0.2889308035373687744140625f)) * _71) + 0.655828952789306640625f) * _71) + 0.52069270610809326171875f) * _71) + 0.0332120954990386962890625f) * _71) + 0.0008656803402118384838104248046875f)) + (-1.0f)) * _124;
  float _144 = (_124 / sqrt((_124 * _124) + 1.0f)) * 2.0f;
  float _167 = 1.0f / max(asfloat(_121.x), 0.001000000047497451305389404296875f);
  SV_Target.x = max((exp2(log2((_137 / (sqrt((_137 * _137) + 1.0f) * _144)) + 0.5f) * _167) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
  SV_Target.y = max((exp2(log2((_138 / (sqrt((_138 * _138) + 1.0f) * _144)) + 0.5f) * _167) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
  SV_Target.z = max((exp2(log2((_139 / (sqrt((_139 * _139) + 1.0f) * _144)) + 0.5f) * _167) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f), 0.0f);
  SV_Target.w = 1.0f;

  float3 outputColor = SV_Target.rgb;
  float3 signs = sign(outputColor.rgb);
  outputColor = abs(outputColor);

  outputColor = injectedData.toneMapGammaCorrection ? pow(outputColor, 2.2f) : linearFromSRGB(outputColor);
  float videoPeak = injectedData.toneMapPeakNits / (injectedData.toneMapGameNits / 203.f);
  outputColor.rgb = bt2446a_inverse_tonemapping_bt709(outputColor, 100.f, videoPeak);
  outputColor.rgb /= videoPeak;  // 1.0 = Video Peak
  outputColor.rgb *= injectedData.toneMapPeakNits / injectedData.toneMapUINits;

  SV_Target.rgb = outputColor;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
