#include "./startup.hlsli"

Texture2D<float4> ElementTexture : register(t0);

cbuffer $Globals : register(b0) {
  float4 GammaAndAlphaValues : packoffset(c000.x);
  float4 ShaderParams : packoffset(c001.x);
  float4 ShaderParams2 : packoffset(c002.x);
  float4 BatchColor : packoffset(c003.x);
};

SamplerState ElementTextureSampler : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 COLOR: COLOR,
    linear float4 COLOR_1: COLOR1,
    linear float4 ORIGINAL_POSITION: ORIGINAL_POSITION,
    linear float2 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float4 _17 = ElementTexture.Sample(ElementTextureSampler, float2((TEXCOORD_1.z * TEXCOORD_1.x), (TEXCOORD_1.w * TEXCOORD_1.y)));
  float _21 = _17.x * COLOR.x;
  float _22 = _17.y * COLOR.y;
  float _23 = _17.z * COLOR.z;
  float _41;
  float _42;
  float _43;
  float _67;
  float _78;
  float _89;
  float _90;
  float _91;
  [branch]
  if (!(GammaAndAlphaValues.w == 1.0f)) {
    _41 = saturate((GammaAndAlphaValues.w * (_21 + -0.25f)) + 0.25f);
    _42 = saturate((GammaAndAlphaValues.w * (_22 + -0.25f)) + 0.25f);
    _43 = saturate((GammaAndAlphaValues.w * (_23 + -0.25f)) + 0.25f);
  } else {
    _41 = _21;
    _42 = _22;
    _43 = _23;
  }
  [branch]
  if (!(GammaAndAlphaValues.y == 1.0f)) {
    float _54 = (pow(_41, GammaAndAlphaValues.x));
    float _55 = (pow(_42, GammaAndAlphaValues.x));
    float _56 = (pow(_43, GammaAndAlphaValues.x));
    do {
      if (_54 < 0.0031306699384003878f) {
        _67 = (_54 * 12.920000076293945f);
      } else {
        _67 = (((pow(_54, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      do {
        if (_55 < 0.0031306699384003878f) {
          _78 = (_55 * 12.920000076293945f);
        } else {
          _78 = (((pow(_55, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        if (_56 < 0.0031306699384003878f) {
          _89 = _67;
          _90 = _78;
          _91 = (_56 * 12.920000076293945f);
        } else {
          _89 = _67;
          _90 = _78;
          _91 = (((pow(_56, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
      } while (false);
    } while (false);
  } else {
    _89 = _41;
    _90 = _42;
    _91 = _43;
  }
  SV_Target.x = _89;
  SV_Target.y = _90;
  SV_Target.z = _91;

  SV_Target.rgb = ConvertStartupVideos(SV_Target.rgb);

  SV_Target.w = ((GammaAndAlphaValues.z * ((COLOR.w * -2.0f) + 1.0f)) + COLOR.w);
  return SV_Target;
}
