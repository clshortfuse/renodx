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

cbuffer ScreenResolutionParam : register(b2) {
  float2 g_HDRTexturePercentage : packoffset(c000.x);
  float2 g_UITexturePercentage : packoffset(c000.z);
};

SamplerState LinearClampSampler : register(s1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float2 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _16 = HDRScene.Sample(LinearClampSampler, float2((g_HDRTexturePercentage.x * TEXCOORD_1.x), (g_HDRTexturePercentage.y * TEXCOORD_1.y)));
  float4 _25 = UIScene.Sample(LinearClampSampler, float2((g_UITexturePercentage.x * TEXCOORD_1.x), (g_UITexturePercentage.y * TEXCOORD_1.y)));

  if (HandleFinal(_16, _25, SV_Target)) {
    return SV_Target;
  }

  float _44 = exp2(log2(_16.x * 2.009232997894287f) * 1.5f);
  float _45 = exp2(log2(_16.y * 2.009232997894287f) * 1.5f);
  float _46 = exp2(log2(_16.z * 2.009232997894287f) * 1.5f);
  float _65;
  float _81;
  float _82;
  float _83;
  float _94;
  float _95;
  float _96;
  float _177;
  float _178;
  float _179;
  if (!(rangeAdj == 0)) {
    float _53 = dot(float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f), float3(_44, _45, _46));
    float _54 = _53 - uiMaxLumScale;
    do {
      if (_54 > 0.0f) {
        float _57 = uiMaxLumScale * 0.10000002384185791f;
        _65 = (_57 * (1.0f - exp2(((-0.0f - _54) / _57) * 1.4426950216293335f)));
      } else {
        _65 = _54;
      }
      float _69 = (((uiMaxLumScale - _53) + _65) * (1.0f - (_25.w * _25.w))) + _53;
      bool _70 = (_53 > 0.0f);
      _81 = select(_70, ((_69 * _44) / _53), 0.0f);
      _82 = select(_70, ((_69 * _45) / _53), 0.0f);
      _83 = select(_70, ((_69 * _46) / _53), 0.0f);
    } while (false);
  } else {
    _81 = _44;
    _82 = _45;
    _83 = _46;
  }
  if (noUIBlend == 0) {
    _94 = ((_81 * _25.w) + (uiMaxLumScale * _25.x));
    _95 = ((_82 * _25.w) + (uiMaxLumScale * _25.y));
    _96 = ((_83 * _25.w) + (uiMaxLumScale * _25.z));
  } else {
    _94 = _81;
    _95 = _82;
    _96 = _83;
  }
  float _103 = (pow(_94, 2.200000047683716f));
  float _104 = (pow(_95, 2.200000047683716f));
  float _105 = (pow(_96, 2.200000047683716f));
  float _145 = PQEncodeLUT.Sample(LinearClampSampler, float2(((exp2(log2(mad(_105, (mtxColorConvert[0].z), mad(_104, (mtxColorConvert[0].y), ((mtxColorConvert[0].x) * _103))) * 0.019999999552965164f) * 0.25f) * 0.99609375f) + 0.001953125f), 0.0f));
  float _147 = PQEncodeLUT.Sample(LinearClampSampler, float2(((exp2(log2(mad(_105, (mtxColorConvert[1].z), mad(_104, (mtxColorConvert[1].y), ((mtxColorConvert[1].x) * _103))) * 0.019999999552965164f) * 0.25f) * 0.99609375f) + 0.001953125f), 0.0f));
  float _149 = PQEncodeLUT.Sample(LinearClampSampler, float2(((exp2(log2(mad(_105, (mtxColorConvert[2].z), mad(_104, (mtxColorConvert[2].y), ((mtxColorConvert[2].x) * _103))) * 0.019999999552965164f) * 0.25f) * 0.99609375f) + 0.001953125f), 0.0f));
  if (!(enableDithering == 0)) {
    float _155 = dot(float2(171.0f, 231.0f), float2(SV_Position.x, SV_Position.y));
    _177 = ((((frac(_155 * 0.009345794096589088f) + -0.5f) * 0.0009775171056389809f) * noiseIntensity) + _145.x);
    _178 = ((((frac(_155 * 0.010309278033673763f) + -0.5f) * 0.0009775171056389809f) * noiseIntensity) + _147.x);
    _179 = ((((frac(_155 * 0.014925372786819935f) + -0.5f) * 0.0009775171056389809f) * noiseIntensity) + _149.x);
  } else {
    _177 = _145.x;
    _178 = _147.x;
    _179 = _149.x;
  }
  SV_Target.x = _177;
  SV_Target.y = _178;
  SV_Target.z = _179;
  SV_Target.w = 1.0f;
  return SV_Target;
}
