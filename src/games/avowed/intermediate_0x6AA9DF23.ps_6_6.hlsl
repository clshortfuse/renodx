#include "./common.hlsl"

cbuffer _GlobalsUBO : register(b0, space0) {
  float4 _Globals_m0[66] : packoffset(c0);  // GammaAndAlphaValues;
};

Texture2D<float4> ElementTexture : register(t0, space0);
SamplerState ElementTextureSampler : register(s0, space0);

static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  noperspective float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float4 _51 = ElementTexture.Sample(ElementTextureSampler, float2(min(max(TEXCOORD.x, _Globals_m0[65u].x), _Globals_m0[65u].z), min(max(TEXCOORD.y, _Globals_m0[65u].y), _Globals_m0[65u].w)));
  // _51.rgb = DecodeFromPQ(_51.rgb);
  float _78 = (_Globals_m0[64u].z * _Globals_m0[0u].w) * _Globals_m0[64u].x;
  float _80 = (_Globals_m0[64u].w * _Globals_m0[0u].w) * _Globals_m0[64u].y;
  float4 _90 = ElementTexture.Sample(ElementTextureSampler, float2(min(max(_78 + TEXCOORD.x, _Globals_m0[65u].x), _Globals_m0[65u].z), min(max(_80 + TEXCOORD.y, _Globals_m0[65u].y), _Globals_m0[65u].w)));
  float4 _104 = ElementTexture.Sample(ElementTextureSampler, float2(min(max(TEXCOORD.x - _78, _Globals_m0[65u].x), _Globals_m0[65u].z), min(max(TEXCOORD.y - _80, _Globals_m0[65u].y), _Globals_m0[65u].w)));
  float _115 = ((_104.x + _90.x) * _Globals_m0[0u].z) + (_Globals_m0[0u].x * _51.x);
  float _116 = ((_104.y + _90.y) * _Globals_m0[0u].z) + (_Globals_m0[0u].x * _51.y);
  float _117 = ((_104.z + _90.z) * _Globals_m0[0u].z) + (_Globals_m0[0u].x * _51.z);
  float _127;
  float _129;
  float _131;
  if (int(asuint(_Globals_m0[63u]).x) > int(2u)) {
    float _140;
    float _141;
    float _142;
    uint _143;
    _140 = _115;
    _141 = _116;
    _142 = _117;
    _143 = 2u;
    float _128;
    float _130;
    float _132;
    for (;;) {
      uint _145 = uint(int(_143) / int(2u));
      float _163 = (_Globals_m0[64u].z * _Globals_m0[_145].y) * _Globals_m0[64u].x;
      float _165 = (_Globals_m0[64u].w * _Globals_m0[_145].y) * _Globals_m0[64u].y;
      float4 _175 = ElementTexture.Sample(ElementTextureSampler, float2(min(max(_163 + TEXCOORD.x, _Globals_m0[65u].x), _Globals_m0[65u].z), min(max(_165 + TEXCOORD.y, _Globals_m0[65u].y), _Globals_m0[65u].w)));
      float4 _186 = ElementTexture.Sample(ElementTextureSampler, float2(min(max(TEXCOORD.x - _163, _Globals_m0[65u].x), _Globals_m0[65u].z), min(max(TEXCOORD.y - _165, _Globals_m0[65u].y), _Globals_m0[65u].w)));
      float _203 = (_Globals_m0[64u].z * _Globals_m0[_145].w) * _Globals_m0[64u].x;
      float _205 = (_Globals_m0[64u].w * _Globals_m0[_145].w) * _Globals_m0[64u].y;
      float4 _212 = ElementTexture.Sample(ElementTextureSampler, float2(min(max(_203 + TEXCOORD.x, _Globals_m0[65u].x), _Globals_m0[65u].z), min(max(_205 + TEXCOORD.y, _Globals_m0[65u].y), _Globals_m0[65u].w)));
      float4 _223 = ElementTexture.Sample(ElementTextureSampler, float2(min(max(TEXCOORD.x - _203, _Globals_m0[65u].x), _Globals_m0[65u].z), min(max(TEXCOORD.y - _205, _Globals_m0[65u].y), _Globals_m0[65u].w)));
      _128 = (((_186.x + _175.x) * _Globals_m0[_145].x) + _140) + ((_223.x + _212.x) * _Globals_m0[_145].z);
      _130 = (((_186.y + _175.y) * _Globals_m0[_145].x) + _141) + ((_223.y + _212.y) * _Globals_m0[_145].z);
      _132 = (((_186.z + _175.z) * _Globals_m0[_145].x) + _142) + ((_223.z + _212.z) * _Globals_m0[_145].z);
      uint _144 = _143 + 2u;
      if (int(_144) < int(asuint(_Globals_m0[63u]).x)) {
        _140 = _128;
        _141 = _130;
        _142 = _132;
        _143 = _144;
      } else {
        break;
      }
    }
    _127 = _128;
    _129 = _130;
    _131 = _132;
  } else {
    _127 = _115;
    _129 = _116;
    _131 = _117;
  }
  SV_Target.x = _127;
  SV_Target.y = _129;
  SV_Target.z = _131;

  // SV_Target.rgb = EncodeToPQ(SV_Target.rgb);
  SV_Target.rgb = _51.rgb;
  SV_Target.w = 0.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
