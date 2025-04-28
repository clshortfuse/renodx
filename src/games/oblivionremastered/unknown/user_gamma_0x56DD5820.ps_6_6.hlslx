#include "../shared.h"

Texture2D<float4> Material_Texture2D_0 : register(t0);

cbuffer $Globals : register(b0) {
  float4 GammaAndAlphaValues : packoffset(c000.x);
  float4 DrawFlags : packoffset(c001.x);
};

cbuffer UniformBufferConstants_Material : register(b1) {
  float4 Material_PreshaderBuffer[2] : packoffset(c000.x);
  uint BindlessResource_Material_Texture2D_0 : packoffset(c002.x);
  uint PrePadding_Material_36 : packoffset(c002.y);
  uint BindlessSampler_Material_Texture2D_0Sampler : packoffset(c002.z);
  uint PrePadding_Material_44 : packoffset(c002.w);
  uint BindlessSampler_Material_Wrap_WorldGroupSettings : packoffset(c003.x);
  uint PrePadding_Material_52 : packoffset(c003.y);
  uint BindlessSampler_Material_Clamp_WorldGroupSettings : packoffset(c003.z);
};

SamplerState Material_Texture2D_0Sampler : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 COLOR: COLOR,
    linear float4 COLOR_1: COLOR1,
    linear float4 ORIGINAL_POSITION: ORIGINAL_POSITION,
    linear float2 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1) : SV_Target {
  float4 SV_Target;
  float4 _19 = Material_Texture2D_0.Sample(Material_Texture2D_0Sampler, float2((TEXCOORD_1.z * TEXCOORD_1.x), (TEXCOORD_1.w * TEXCOORD_1.y)));
  float _40 = max(((((Material_PreshaderBuffer[1].y) - _19.x) * (Material_PreshaderBuffer[1].x)) + _19.x), 0.0f) * COLOR.x;
  float _41 = max(((((Material_PreshaderBuffer[1].z) - _19.y) * (Material_PreshaderBuffer[1].x)) + _19.y), 0.0f) * COLOR.y;
  float _42 = max(((((Material_PreshaderBuffer[1].w) - _19.z) * (Material_PreshaderBuffer[1].x)) + _19.z), 0.0f) * COLOR.z;
  float _65;
  float _66;
  float _67;
  float _91;
  float _102;
  float _113;
  float _114;
  float _115;
  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f && !(GammaAndAlphaValues.w == 1.0f)) {
    _65 = saturate((GammaAndAlphaValues.w * (_40 + -0.25f)) + 0.25f);
    _66 = saturate((GammaAndAlphaValues.w * (_41 + -0.25f)) + 0.25f);
    _67 = saturate((GammaAndAlphaValues.w * (_42 + -0.25f)) + 0.25f);

    _65 = _40;
    _66 = _41;
    _67 = _42;

  } else {
    _65 = _40;
    _66 = _41;
    _67 = _42;
  }
  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f && !(GammaAndAlphaValues.y == 1.0f)) {
    float _78 = (pow(_65, GammaAndAlphaValues.x));
    float _79 = (pow(_66, GammaAndAlphaValues.x));
    float _80 = (pow(_67, GammaAndAlphaValues.x));
    if (_78 < 0.0031306699384003878f) {
      _91 = (_78 * 12.920000076293945f);
    } else {
      _91 = (((pow(_78, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_79 < 0.0031306699384003878f) {
      _102 = (_79 * 12.920000076293945f);
    } else {
      _102 = (((pow(_79, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_80 < 0.0031306699384003878f) {
      _113 = _91;
      _114 = _102;
      _115 = (_80 * 12.920000076293945f);
    } else {
      _113 = _91;
      _114 = _102;
      _115 = (((pow(_80, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    _113 = _65;
    _114 = _66;
    _115 = _67;
  }
  SV_Target.x = _113;
  SV_Target.y = _114;
  SV_Target.z = _115;
  SV_Target.w = select((!(DrawFlags.x == 0.0f)), (COLOR.w * 0.44999998807907104f), COLOR.w);
  return SV_Target;
}
