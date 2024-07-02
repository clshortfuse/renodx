#include "./shared.h"

cbuffer _13_15 : register(b0, space7) {
  float4 _15_m0[3265] : packoffset(c0);
}

cbuffer _18_20 : register(b0, space0) {
  float4 _20_m0[2] : packoffset(c0);
}

Texture2D<float4> _8 : register(t0, space8);
SamplerState _23 : register(s13, space6);
SamplerState _24 : register(s15, space6);

static float4 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float4 _42 = _8.Sample(_23, float2(TEXCOORD.x, TEXCOORD.y));

  // Remove out of gamut colors
  float3 signs = sign(_42.rgb);
  _42.rgb = abs(_42.rgb);

  float _45 = _42.x;
  float _46 = _42.y;
  float _47 = _42.z;
  uint4 _52 = asuint(_20_m0[0u]);
  float _54 = asfloat(_52.z);
  float _208;
  float _209;
  float _210;
  if (_54 > 0.0f) {
    float _70 = ((_15_m0[161u].z * TEXCOORD.x) * asfloat(_52.x)) + 0.5f;
    float _72 = ((_15_m0[161u].w * TEXCOORD.y) * asfloat(_52.y)) + 0.5f;
    float _76 = frac(_70);
    float _77 = frac(_72);
    float _87 = ((((((_76 * 2.0f) + (-3.0f)) * _76) + (-3.0f)) * _76) + 5.0f) * 0.16666667163372039794921875f;
    float _89 = _76 * 3.0f;
    float _98 = ((((((3.0f - _89) + _76) * _76) + 3.0f) * _76) + 1.0f) * 0.16666667163372039794921875f;
    float _99 = _76 * _76;
    float _113 = _77 * _77;
    float _114 = _77 * 3.0f;
    float _125 = ((((((_77 * 2.0f) + (-3.0f)) * _77) + (-3.0f)) * _77) + 5.0f) * 0.16666667163372039794921875f;
    float _136 = ((((((3.0f - _114) + _77) * _77) + 3.0f) * _77) + 1.0f) * 0.16666667163372039794921875f;
    float _139 = floor(_70) + (-0.5f);
    float _142 = floor(_72) + (-0.5f);
    // 161u.zw = resolution xy
    float _144 = (_139 + (((((_99 * (_89 + (-6.0f))) + 4.0f) * 0.16666667163372039794921875f) / _87) + (-1.0f))) / _15_m0[161u].z;
    float _145 = (_142 + (((((_113 * (_114 + (-6.0f))) + 4.0f) * 0.16666667163372039794921875f) / _125) + (-1.0f))) / _15_m0[161u].w;
    float _147 = (_139 + ((((_99 * 0.16666667163372039794921875f) * _76) / _98) + 1.0f)) / _15_m0[161u].z;
    float _149 = (_142 + ((((_113 * 0.16666667163372039794921875f) * _77) / _136) + 1.0f)) / _15_m0[161u].w;
    float4 _152 = _8.SampleLevel(_24, float2(_144, _145), 0.0f);
    float4 _157 = _8.SampleLevel(_24, float2(_147, _145), 0.0f);
    float4 _162 = _8.SampleLevel(_24, float2(_144, _149), 0.0f);
    float4 _167 = _8.SampleLevel(_24, float2(_147, _149), 0.0f);
    float _196 = (((_167.x * _98) + (_162.x * _87)) * _136) + (((_157.x * _98) + (_152.x * _87)) * _125);
    float _197 = (((_167.y * _98) + (_162.y * _87)) * _136) + (((_157.y * _98) + (_152.y * _87)) * _125);
    float _198 = (((_167.z * _98) + (_162.z * _87)) * _136) + (((_157.z * _98) + (_152.z * _87)) * _125);
    _208 = ((_45 - _196) * _54) + _196;
    _209 = ((_46 - _197) * _54) + _197;
    _210 = ((_47 - _198) * _54) + _198;
  } else {
    _208 = _45;
    _209 = _46;
    _210 = _47;
  }
  SV_Target.x = _208;
  SV_Target.y = _209;
  SV_Target.z = _210;
  SV_Target.w = 1.0f;

  // Revert back out of gamut colors
  SV_Target.rgb *= signs;
  SV_Target.rgb = _42.rgb;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
