// Stalker 2

#include "./composite.hlsli"

Texture2D<float4> UITexture : register(t0);

Texture2D<float4> SceneTexture : register(t1);

cbuffer $Globals : register(b0) {
  float3 InverseGamma : packoffset(c000.x);
  float FilmSlope : packoffset(c000.w);
  float FilmToe : packoffset(c001.x);
  float FilmShoulder : packoffset(c001.y);
  float FilmBlackClip : packoffset(c001.z);
  float FilmWhiteClip : packoffset(c001.w);
  uint OutputDevice : packoffset(c002.x);
  uint OutputGamut : packoffset(c002.y);
  float OutputMaxLuminance : packoffset(c002.z);
  float4 ACESMinMaxData : packoffset(c003.x);
  float4 ACESMidData : packoffset(c004.x);
  float4 ACESCoefsLow_0 : packoffset(c005.x);
  float4 ACESCoefsHigh_0 : packoffset(c006.x);
  float ACESCoefsLow_4 : packoffset(c007.x);
  float ACESCoefsHigh_4 : packoffset(c007.y);
  float UILevel : packoffset(c007.z);
  float UILuminance : packoffset(c007.w);
  float UISaturationFactor : packoffset(c008.x);
  float3 UIColorLuminanceFactor : packoffset(c008.y);
};

SamplerState UISampler : register(s0);

SamplerState SceneSampler : register(s1);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _11 = UITexture.Sample(UISampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _16 = max(6.103519990574569e-05f, _11.x);
  float _17 = max(6.103519990574569e-05f, _11.y);
  float _18 = max(6.103519990574569e-05f, _11.z);
  float _40 = select((_16 > 0.040449999272823334f), exp2(log2((_16 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_16 * 0.07739938050508499f));
  float _41 = select((_17 > 0.040449999272823334f), exp2(log2((_17 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_17 * 0.07739938050508499f));
  float _42 = select((_18 > 0.040449999272823334f), exp2(log2((_18 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_18 * 0.07739938050508499f));
  float _49 = saturate(dot(float3(_40, _41, _42), float3(UIColorLuminanceFactor.x, UIColorLuminanceFactor.y, UIColorLuminanceFactor.z)));
  float _59 = saturate(lerp(_49, _40, UISaturationFactor));
  float _60 = saturate(lerp(_49, _41, UISaturationFactor));
  float _61 = saturate(lerp(_49, _42, UISaturationFactor));
  float4 _78 = SceneTexture.Sample(SceneSampler, float2(TEXCOORD.x, TEXCOORD.y));
  if (HandleUICompositing(_11, _78, SV_Target, TEXCOORD.xy, SceneTexture, SceneSampler)) {
    return SV_Target;
  }

  float _88 = (pow(_78.x, 0.012683313339948654f));
  float _89 = (pow(_78.y, 0.012683313339948654f));
  float _90 = (pow(_78.z, 0.012683313339948654f));
  float _115 = exp2(log2(max(0.0f, (_88 + -0.8359375f)) / (18.8515625f - (_88 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _116 = exp2(log2(max(0.0f, (_89 + -0.8359375f)) / (18.8515625f - (_89 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _117 = exp2(log2(max(0.0f, (_90 + -0.8359375f)) / (18.8515625f - (_90 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _138;
  float _139;
  float _140;
  if ((bool)(_11.w > 0.0f) && (bool)(_11.w < 1.0f)) {
    float _123 = max(_115, 0.0f);
    float _124 = max(_116, 0.0f);
    float _125 = max(_117, 0.0f);
    float _133 = ((((1.0f / ((dot(float3(_123, _124, _125), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / UILevel) + 1.0f)) * UILevel) + -1.0f) * _11.w) + 1.0f;
    _138 = (_133 * _123);
    _139 = (_133 * _124);
    _140 = (_133 * _125);
  } else {
    _138 = _115;
    _139 = _116;
    _140 = _117;
  }
  float _141 = 1.0f - _11.w;
  float _160 = exp2(log2(((_138 * _141) + ((UILuminance * mad(0.04330150783061981f, _61, mad(0.32926714420318604f, _60, (_59 * 0.6274880170822144f)))) * UILevel)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _161 = exp2(log2(((_139 * _141) + ((UILuminance * mad(0.011359544470906258f, _61, mad(0.9195171594619751f, _60, (_59 * 0.06910824030637741f)))) * UILevel)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _162 = exp2(log2(((_140 * _141) + ((UILuminance * mad(0.8954997062683105f, _61, mad(0.08802297711372375f, _60, (_59 * 0.016396233811974525f)))) * UILevel)) * 9.999999747378752e-05f) * 0.1593017578125f);
  SV_Target.x = exp2(log2((1.0f / ((_160 * 18.6875f) + 1.0f)) * ((_160 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.y = exp2(log2((1.0f / ((_161 * 18.6875f) + 1.0f)) * ((_161 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.z = exp2(log2((1.0f / ((_162 * 18.6875f) + 1.0f)) * ((_162 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.w = _11.w;
  return SV_Target;
}
