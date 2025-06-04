#include "../common.hlsl"

Texture2D<float4> HDRScene : register(t0);

Texture2D<float4> UIScene : register(t1);

Texture2D<float> PQEncodeLUT : register(t2);

cbuffer DisplayMappingData : register(b0) {
  float outputGammaForSDR : packoffset(c000.x);
  int noUIBlend : packoffset(c000.y);
  int rangeAdj : packoffset(c000.z);
  int enableDithering : packoffset(c000.w);
  float noiseIntensity : packoffset(c001.x);
  float noiseScale : packoffset(c001.y);
  float uiMaxLumScale : packoffset(c001.z);
  float uiMaxLumScaleRecp : packoffset(c001.w);
  float uiMaxNitsNormalizedLinear : packoffset(c002.x);
  float4 mtxColorConvert[3] : packoffset(c003.x);
};

SamplerState LinearClampSampler : register(s1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float2 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _10 = HDRScene.Sample(LinearClampSampler, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float4 _14 = UIScene.Sample(LinearClampSampler, float2(TEXCOORD_1.x, TEXCOORD_1.y));

  if (HandleFinal(_10, _14, SV_Target, SV_Position)) {
    return SV_Target;
  }

  float _33 = exp2(log2(_10.x * 2.009232997894287f) * 1.5f);
  float _34 = exp2(log2(_10.y * 2.009232997894287f) * 1.5f);
  float _35 = exp2(log2(_10.z * 2.009232997894287f) * 1.5f);

  // default value, brightness slider;
  // 1 = 203.0 nits
  float uiScale = uiMaxLumScale;

  float _54;
  float _70;
  float _71;
  float _72;
  float _83;
  float _84;
  float _85;
  float _166;
  float _167;
  float _168;
  if (!(rangeAdj == 0)) {
    // Luminance of scene in linear space
    float _42 = dot(float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f), float3(_33, _34, _35));
    // I assume UI scale here here is in ntsc Y?
    float _43 = _42 - uiScale;
    // Adjust scene if luminance is higher than UI with a smooth transition
    do {
      if (_43 > 0.0f) {
        // As scene luminance rises above uiScale, _54 smoothly approaches _46
        float _46 = uiScale * 0.10000002384185791f;
        _54 = (_46 * (1.0f - exp2(((-0.0f - _43) / _46) * 1.4426950216293335f)));
      } else {
        _54 = _43;
      }
      float _58 = (((uiScale - _42) + _54) * (1.0f - (_14.w * _14.w))) + _42;
      bool _59 = (_42 > 0.0f);
      _70 = select(_59, ((_58 * _33) / _42), 0.0f);
      _71 = select(_59, ((_58 * _34) / _42), 0.0f);
      _72 = select(_59, ((_58 * _35) / _42), 0.0f);
    } while (false);
  } else {
    _70 = _33;
    _71 = _34;
    _72 = _35;
  }
  if (noUIBlend == 0) {
    _83 = ((_70 * _14.w) + (uiScale * _14.x));
    _84 = ((_71 * _14.w) + (uiScale * _14.y));
    _85 = ((_72 * _14.w) + (uiScale * _14.z));
  } else {
    _83 = _70;
    _84 = _71;
    _85 = _72;
  }

  // Decode gamma, so blending is in gamma space
  float _92 = (pow(_83, 2.200000047683716f));
  float _93 = (pow(_84, 2.200000047683716f));
  float _94 = (pow(_85, 2.200000047683716f));

  float _134 = PQEncodeLUT.Sample(LinearClampSampler, float2(((exp2(log2(mad(_94, (mtxColorConvert[0].z), mad(_93, (mtxColorConvert[0].y), ((mtxColorConvert[0].x) * _92))) * 0.019999999552965164f) * 0.25f) * 0.99609375f) + 0.001953125f), 0.0f));
  float _136 = PQEncodeLUT.Sample(LinearClampSampler, float2(((exp2(log2(mad(_94, (mtxColorConvert[1].z), mad(_93, (mtxColorConvert[1].y), ((mtxColorConvert[1].x) * _92))) * 0.019999999552965164f) * 0.25f) * 0.99609375f) + 0.001953125f), 0.0f));
  float _138 = PQEncodeLUT.Sample(LinearClampSampler, float2(((exp2(log2(mad(_94, (mtxColorConvert[2].z), mad(_93, (mtxColorConvert[2].y), ((mtxColorConvert[2].x) * _92))) * 0.019999999552965164f) * 0.25f) * 0.99609375f) + 0.001953125f), 0.0f));
  if (!(enableDithering == 0)) {
    float _144 = dot(float2(171.0f, 231.0f), float2(SV_Position.x, SV_Position.y));
    _166 = ((((frac(_144 * 0.009345794096589088f) + -0.5f) * 0.0009775171056389809f) * noiseIntensity) + _134.x);
    _167 = ((((frac(_144 * 0.010309278033673763f) + -0.5f) * 0.0009775171056389809f) * noiseIntensity) + _136.x);
    _168 = ((((frac(_144 * 0.014925372786819935f) + -0.5f) * 0.0009775171056389809f) * noiseIntensity) + _138.x);
  } else {
    _166 = _134.x;
    _167 = _136.x;
    _168 = _138.x;
  }
  SV_Target.x = _166;
  SV_Target.y = _167;
  SV_Target.z = _168;
  SV_Target.w = 1.0f;
  return SV_Target;
}
