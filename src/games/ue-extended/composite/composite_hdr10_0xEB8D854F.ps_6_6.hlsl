#include "./composite.hlsli"

// Found in Sliiterhead Native HDR UE 5.2.1

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
  float HDRUIToeLength : packoffset(c007.z);
  float HDRUIToeStrength : packoffset(c007.w);
  float UILevel : packoffset(c008.x);
  float UILuminance : packoffset(c008.y);
};

SamplerState UISampler : register(s0);

SamplerState SceneSampler : register(s1);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float4 _11 = UITexture.Sample(UISampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _16 = max(6.103519990574569e-05f, _11.x);
  float _17 = max(6.103519990574569e-05f, _11.y);
  float _18 = max(6.103519990574569e-05f, _11.z);
  float _40 = select((_16 > 0.040449999272823334f), exp2(log2((_16 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_16 * 0.07739938050508499f));
  float _41 = select((_17 > 0.040449999272823334f), exp2(log2((_17 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_17 * 0.07739938050508499f));
  float _42 = select((_18 > 0.040449999272823334f), exp2(log2((_18 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_18 * 0.07739938050508499f));
  float _57 = (UILuminance * mad(0.04330150783061981f, _42, mad(0.32926714420318604f, _41, (_40 * 0.6274880170822144f)))) / UILuminance;
  float _58 = (UILuminance * mad(0.011359544470906258f, _42, mad(0.9195171594619751f, _41, (_40 * 0.06910824030637741f)))) / UILuminance;
  float _59 = (UILuminance * mad(0.8954997062683105f, _42, mad(0.08802297711372375f, _41, (_40 * 0.016396233811974525f)))) / UILuminance;
  float4 _95 = SceneTexture.Sample(SceneSampler, float2(TEXCOORD.x, TEXCOORD.y));

  if (HandleUICompositing(_11, _95, SV_Target, TEXCOORD.xy, SceneTexture, SceneSampler)) {
    return SV_Target;
  }

  float _105 = (pow(_95.x, 0.012683313339948654f));
  float _106 = (pow(_95.y, 0.012683313339948654f));
  float _107 = (pow(_95.z, 0.012683313339948654f));
  float _132 = exp2(log2(max(0.0f, (_105 + -0.8359375f)) / (18.8515625f - (_105 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _133 = exp2(log2(max(0.0f, (_106 + -0.8359375f)) / (18.8515625f - (_106 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _134 = exp2(log2(max(0.0f, (_107 + -0.8359375f)) / (18.8515625f - (_107 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _155;
  float _156;
  float _157;
  if ((bool)(_11.w > 0.0f) && (bool)(_11.w < 1.0f)) {
    float _140 = max(_132, 0.0f);
    float _141 = max(_133, 0.0f);
    float _142 = max(_134, 0.0f);
    float _150 = ((((1.0f / ((dot(float3(_140, _141, _142), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / UILevel) + 1.0f)) * UILevel) + -1.0f) * _11.w) + 1.0f;
    _155 = (_150 * _140);
    _156 = (_150 * _141);
    _157 = (_150 * _142);
  } else {
    _155 = _132;
    _156 = _133;
    _157 = _134;
  }
  float _158 = 1.0f - _11.w;
  float _177 = exp2(log2(((_155 * _158) + ((UILuminance * ((HDRUIToeLength * exp2(log2(min((_57 / HDRUIToeLength), 1.0f)) * HDRUIToeStrength)) + max((_57 - HDRUIToeLength), 0.0f))) * UILevel)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _178 = exp2(log2(((_156 * _158) + ((UILuminance * (max((_58 - HDRUIToeLength), 0.0f) + (HDRUIToeLength * exp2(log2(min((_58 / HDRUIToeLength), 1.0f)) * HDRUIToeStrength)))) * UILevel)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _179 = exp2(log2(((_157 * _158) + ((UILuminance * (max((_59 - HDRUIToeLength), 0.0f) + (HDRUIToeLength * exp2(log2(min((_59 / HDRUIToeLength), 1.0f)) * HDRUIToeStrength)))) * UILevel)) * 9.999999747378752e-05f) * 0.1593017578125f);
  SV_Target.x = exp2(log2((1.0f / ((_177 * 18.6875f) + 1.0f)) * ((_177 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.y = exp2(log2((1.0f / ((_178 * 18.6875f) + 1.0f)) * ((_178 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.z = exp2(log2((1.0f / ((_179 * 18.6875f) + 1.0f)) * ((_179 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.w = 1.0f;
  return SV_Target;
}
