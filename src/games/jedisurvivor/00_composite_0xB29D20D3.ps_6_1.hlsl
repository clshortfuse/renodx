#include "./shared.h";

cbuffer _17_19 : register(b0, space0) {
  float4 _19_m0[13] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space0);   // UI
Texture2D<float4> _9 : register(t1, space0);   // Render
Texture3D<float4> _12 : register(t2, space0);  // Gamma LUT?
SamplerState _22 : register(s0, space0);
SamplerState _23 : register(s1, space0);
SamplerState _24 : register(s2, space0);

static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  noperspective float2 TEXCOORD : TEXCOORD0;
  float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float4 _48 = _8.Sample(_22, float2(TEXCOORD.x, TEXCOORD.y));
  float _53 = _48.w;
  float4 _55 = _9.Sample(_23, float2(TEXCOORD.x, TEXCOORD.y)); // Already in PQ??
  float4 _70 = _12.SampleLevel(_24, float3((_48.x * 0.96875f) + 0.015625f, (_48.y * 0.96875f) + 0.015625f, (_48.z * 0.96875f) + 0.015625f), 0.0f);
  
  float _88 = exp2(log2(_55.x) * 0.0126833133399486541748046875f);
  float _89 = exp2(log2(_55.y) * 0.0126833133399486541748046875f);
  float _90 = exp2(log2(_55.z) * 0.0126833133399486541748046875f);
  float _119 = exp2(log2(max(0.0f, _88 + (-0.8359375f)) / (18.8515625f - (_88 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f;
  float _121 = exp2(log2(max(0.0f, _89 + (-0.8359375f)) / (18.8515625f - (_89 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f;
  float _122 = exp2(log2(max(0.0f, _90 + (-0.8359375f)) / (18.8515625f - (_90 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f;
  float _129 = exp2(log2(_70.x * 1.0499999523162841796875f) * 0.0126833133399486541748046875f);
  float _130 = exp2(log2(_70.y * 1.0499999523162841796875f) * 0.0126833133399486541748046875f);
  float _131 = exp2(log2(_70.z * 1.0499999523162841796875f) * 0.0126833133399486541748046875f);
  float _189;
  float _190;
  float _191;
  if ((_53 > 0.0f) && (_53 < 1.0f)) {
    float _164 = max(_119, 0.0f);
    float _165 = max(_121, 0.0f);
    float _166 = max(_122, 0.0f);
    float _185 = (((_19_m0[12u].x * (1.0f / ((dot(float3(_164, _165, _166), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)) / _19_m0[12u].x) + 1.0f))) + (-1.0f)) * _53) + 1.0f;
    _189 = _185 * _164;
    _190 = _185 * _165;
    _191 = _185 * _166;
  } else {
    _189 = _119;
    _190 = _121;
    _191 = _122;
  }
  float _192 = 1.0f - _53;
  float _216 = exp2(log2((((exp2(log2(max(0.0f, _129 + (-0.8359375f)) / (18.8515625f - (_129 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f) * _19_m0[12u].x) + (_189 * _192)) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
  float _217 = exp2(log2((((exp2(log2(max(0.0f, _130 + (-0.8359375f)) / (18.8515625f - (_130 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f) * _19_m0[12u].x) + (_190 * _192)) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
  float _218 = exp2(log2((((exp2(log2(max(0.0f, _131 + (-0.8359375f)) / (18.8515625f - (_131 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f) * _19_m0[12u].x) + (_191 * _192)) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
  SV_Target.x = exp2(log2((1.0f / ((_216 * 18.6875f) + 1.0f)) * ((_216 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.y = exp2(log2((1.0f / ((_217 * 18.6875f) + 1.0f)) * ((_217 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.z = exp2(log2((1.0f / ((_218 * 18.6875f) + 1.0f)) * ((_218 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.w = 1.0f;
  // SV_Target.rgb = renodx::color::pq::Encode(float3(_119, _121, _122).rgb / 10000.f);
  // SV_Target.rgb = _55.rgb;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
