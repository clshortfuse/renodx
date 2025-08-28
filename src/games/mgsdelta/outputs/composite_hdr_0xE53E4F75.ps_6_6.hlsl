#include "../composite.hlsl"

Texture2D<float4> UITexture : register(t0);

Texture2D<float4> SceneTexture : register(t1);

cbuffer $Globals : register(b0) {
  float UILevel : packoffset(c000.x);
  float UILuminance : packoffset(c000.y);
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
  float4 _59 = SceneTexture.Sample(SceneSampler, float2(TEXCOORD.x, TEXCOORD.y));
  if (HandleUICompositing(_11, _59, SV_Target)) {
    return SV_Target;
  }
  float _69 = (pow(_59.x, 0.012683313339948654f));
  float _70 = (pow(_59.y, 0.012683313339948654f));
  float _71 = (pow(_59.z, 0.012683313339948654f));
  float _96 = exp2(log2(max(0.0f, (_69 + -0.8359375f)) / (18.8515625f - (_69 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _97 = exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _98 = exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _115;
  float _131;
  float _132;
  float _133;
  float _134;
  if ((bool)(_11.w > 0.0f) && (bool)(_11.w < 1.0f)) {
    do {
      [branch]
      if (_11.w < 0.44999998807907104f) {
        _115 = (UILevel * 2.5f);
      } else {
        if (_11.w < 0.949999988079071f) {
          _115 = (UILevel * (2.5f - ((_11.w + -0.44999998807907104f) * 3.0f)));
        } else {
          _115 = UILevel;
        }
      }
      float _116 = max(_96, 0.0f);
      float _117 = max(_97, 0.0f);
      float _118 = max(_98, 0.0f);
      float _126 = ((((1.0f / ((dot(float3(_116, _117, _118), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / _115) + 1.0f)) * _115) + -1.0f) * _11.w) + 1.0f;
      _131 = _115;
      _132 = (_126 * _116);
      _133 = (_126 * _117);
      _134 = (_126 * _118);
    } while (false);
  } else {
    _131 = UILevel;
    _132 = _96;
    _133 = _97;
    _134 = _98;
  }
  float _135 = 1.0f - _11.w;
  float _154 = exp2(log2(((_132 * _135) + ((UILuminance * mad(0.043313056230545044f, _42, mad(0.3292830288410187f, _41, (_40 * 0.6274039149284363f)))) * _131)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _155 = exp2(log2(((_133 * _135) + ((UILuminance * mad(0.011362319812178612f, _42, mad(0.919540286064148f, _41, (_40 * 0.06909731030464172f)))) * _131)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _156 = exp2(log2(((_134 * _135) + ((UILuminance * mad(0.8955953121185303f, _42, mad(0.08801331371068954f, _41, (_40 * 0.016391439363360405f)))) * _131)) * 9.999999747378752e-05f) * 0.1593017578125f);
  SV_Target.x = exp2(log2((1.0f / ((_154 * 18.6875f) + 1.0f)) * ((_154 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.y = exp2(log2((1.0f / ((_155 * 18.6875f) + 1.0f)) * ((_155 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.z = exp2(log2((1.0f / ((_156 * 18.6875f) + 1.0f)) * ((_156 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.w = 1.0f;
  return SV_Target;
}
