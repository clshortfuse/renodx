// Grounded 2

#include "./composite.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_001z : packoffset(c001.z);
  float cb0_001w : packoffset(c001.w);
  float cb0_003x : packoffset(c003.x);
  float cb0_003y : packoffset(c003.y);
  float cb0_003z : packoffset(c003.z);
  float cb0_003w : packoffset(c003.w);
  float cb0_004x : packoffset(c004.x);
  float cb0_004y : packoffset(c004.y);
  float cb0_004z : packoffset(c004.z);
  float cb0_004w : packoffset(c004.w);
  float cb0_005x : packoffset(c005.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _11;
  float _40;
  float _41;
  float _42;
  float4 _59;
  float _69;
  float _70;
  float _71;
  float _96;
  float _97;
  float _98;
  float _119;
  float _120;
  float _121;
  float _223;
  float _224;
  float _225;
  float _226;
  float _104;
  float _105;
  float _106;
  float _114;
  float _122;
  float _141;
  float _142;
  float _143;
  float _168;
  float _169;
  float _170;
  float _180;
  float _181;
  float _197;
  float _221;
  _11 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  _40 = select((_11.x > 0.040449999272823334f), exp2(log2((abs(_11.x) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_11.x * 0.07739938050508499f));
  _41 = select((_11.y > 0.040449999272823334f), exp2(log2((abs(_11.y) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_11.y * 0.07739938050508499f));
  _42 = select((_11.z > 0.040449999272823334f), exp2(log2((abs(_11.z) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_11.z * 0.07739938050508499f));
  _59 = t1.Sample(s1, float2(TEXCOORD.x, TEXCOORD.y));

  if (HandleUICompositing(_11, _59, SV_Target, TEXCOORD.xy, t1, s1)) {
    return SV_Target;
  }

  _69 = (pow(_59.x, 0.012683313339948654f));
  _70 = (pow(_59.y, 0.012683313339948654f));
  _71 = (pow(_59.z, 0.012683313339948654f));
  _96 = exp2(log2(max(0.0f, (_69 + -0.8359375f)) / (18.8515625f - (_69 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  _97 = exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  _98 = exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  if ((_11.w > 0.0f) && (_11.w < 1.0f)) {
    _104 = max(_96, 0.0f);
    _105 = max(_97, 0.0f);
    _106 = max(_98, 0.0f);
    _114 = ((((1.0f / ((dot(float3(_104, _105, _106), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / cb0_001z) + 1.0f)) * cb0_001z) + -1.0f) * _11.w) + 1.0f;
    _119 = (_114 * _104);
    _120 = (_114 * _105);
    _121 = (_114 * _106);
  } else {
    _119 = _96;
    _120 = _97;
    _121 = _98;
  }
  _122 = 1.0f - _11.w;
  _141 = exp2(log2(((_119 * _122) + ((cb0_001w * mad(0.043313056230545044f, _42, mad(0.3292830288410187f, _41, (_40 * 0.6274039149284363f)))) * cb0_001z)) * 9.999999747378752e-05f) * 0.1593017578125f);
  _142 = exp2(log2(((_120 * _122) + ((cb0_001w * mad(0.011362319812178612f, _42, mad(0.919540286064148f, _41, (_40 * 0.06909731030464172f)))) * cb0_001z)) * 9.999999747378752e-05f) * 0.1593017578125f);
  _143 = exp2(log2(((_121 * _122) + ((cb0_001w * mad(0.8955953121185303f, _42, mad(0.08801331371068954f, _41, (_40 * 0.016391439363360405f)))) * cb0_001z)) * 9.999999747378752e-05f) * 0.1593017578125f);
  _168 = exp2(log2((1.0f / ((_141 * 18.6875f) + 1.0f)) * ((_141 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  _169 = exp2(log2((1.0f / ((_142 * 18.6875f) + 1.0f)) * ((_142 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  _170 = exp2(log2((1.0f / ((_143 * 18.6875f) + 1.0f)) * ((_143 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  [branch]
  if (cb0_003z > 0.0f) {
    if (!(TEXCOORD.x < cb0_003x)) {
      _180 = cb0_003w + cb0_003y;
      _181 = cb0_003z + cb0_003x;
      if ((TEXCOORD.y <= _180) && ((TEXCOORD.y >= cb0_003y) && (TEXCOORD.x <= _181))) {
        _197 = exp2(log2(cb0_005x * 9.999999747378752e-05f) * 0.1593017578125f);
        _221 = select(((TEXCOORD.y < (cb0_004y + cb0_004w)) && (((TEXCOORD.x >= cb0_004x) && (TEXCOORD.y >= cb0_004y)) && (TEXCOORD.x < (cb0_004x + cb0_004z)))), exp2(log2((1.0f / ((_197 * 18.6875f) + 1.0f)) * ((_197 * 18.8515625f) + 0.8359375f)) * 78.84375f), select(((TEXCOORD.y < _180) && (TEXCOORD.x < _181)), 1.0f, 0.0f));
        _223 = _221;
        _224 = _221;
        _225 = _221;
        _226 = 1.0f;
      } else {
        _223 = _168;
        _224 = _169;
        _225 = _170;
        _226 = _11.w;
      }
    } else {
      _223 = _168;
      _224 = _169;
      _225 = _170;
      _226 = _11.w;
    }
  } else {
    _223 = _168;
    _224 = _169;
    _225 = _170;
    _226 = _11.w;
  }
  SV_Target.x = _223;
  SV_Target.y = _224;
  SV_Target.z = _225;
  SV_Target.w = _226;
  return SV_Target;
}