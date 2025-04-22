#include "./common.hlsl"

Texture2D<float4> HDRImage : register(t0);

cbuffer TonemapParam : register(b0) {
  float contrast : packoffset(c000.x);
  float linearBegin : packoffset(c000.y);
  float linearLength : packoffset(c000.z);
  float toe : packoffset(c000.w);
  float maxNit : packoffset(c001.x);
  float linearStart : packoffset(c001.y);
  float displayMaxNitSubContrastFactor : packoffset(c001.z);
  float contrastFactor : packoffset(c001.w);
  float mulLinearStartContrastFactor : packoffset(c002.x);
  float invLinearBegin : packoffset(c002.y);
  float madLinearStartContrastFactor : packoffset(c002.z);
};

cbuffer DynamicRangeConversionParam : register(b1) {
  float useDynamicRangeConversion : packoffset(c000.x);
  float exposureScale : packoffset(c000.y);
  float kneeStartNit : packoffset(c000.z);
  float knee : packoffset(c000.w);
};

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure) : SV_Target {
  float4 SV_Target;
  float4 _12 = HDRImage.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _16 = _12.x * Exposure;
  float _17 = _12.y * Exposure;
  float _18 = _12.z * Exposure;
  float3 untonemapped = float3(_16, _17, _18);

  float _121;
  float _122;
  float _123;
  float _171;
  float _196;
  float _197;
  float _198;
  if (isfinite(max(max(_16, _17), _18))) {
    float _27 = invLinearBegin * _16;
    float _33 = invLinearBegin * _17;
    float _39 = invLinearBegin * _18;
    float _46 = select((_16 >= linearBegin), 0.0f, (1.0f - ((_27 * _27) * (3.0f - (_27 * 2.0f)))));
    float _48 = select((_17 >= linearBegin), 0.0f, (1.0f - ((_33 * _33) * (3.0f - (_33 * 2.0f)))));
    float _50 = select((_18 >= linearBegin), 0.0f, (1.0f - ((_39 * _39) * (3.0f - (_39 * 2.0f)))));
    float _56 = select((_16 < linearStart), 0.0f, 1.0f);
    float _57 = select((_17 < linearStart), 0.0f, 1.0f);
    float _58 = select((_18 < linearStart), 0.0f, 1.0f);
    _121 = (((((contrast * _16) + madLinearStartContrastFactor) * ((1.0f - _56) - _46)) + (((pow(_27, toe)) * _46) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _16) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _56));
    _122 = (((((contrast * _17) + madLinearStartContrastFactor) * ((1.0f - _57) - _48)) + (((pow(_33, toe)) * _48) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _17) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _57));
    _123 = (((((contrast * _18) + madLinearStartContrastFactor) * ((1.0f - _58) - _50)) + (((pow(_39, toe)) * _50) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _18) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _58));
  } else {
    _121 = 1.0f;
    _122 = 1.0f;
    _123 = 1.0f;
  }
  if (!(useDynamicRangeConversion == 0.0f)) {
    float _133 = mad(0.16500000655651093f, _123, mad(0.16500000655651093f, _122, (_121 * 0.6699999570846558f)));
    float _134 = _121 * 0.16500000655651093f;
    float _136 = mad(0.16500000655651093f, _123, mad(0.6699999570846558f, _122, _134));
    float _138 = mad(0.6699999570846558f, _123, mad(0.16500000655651093f, _122, _134));
    float _141 = mad(0.1688999980688095f, _138, mad(0.1446000039577484f, _136, (_133 * 0.6370000243186951f)));
    float _144 = mad(0.059300001710653305f, _138, mad(0.6779999732971191f, _136, (_133 * 0.26269999146461487f)));
    float _148 = (_144 + _141) + mad(1.0609999895095825f, _138, mad(0.02810000069439411f, _136, 0.0f));
    float _149 = _141 / _148;
    float _150 = _144 / _148;
    float _152 = (kneeStartNit / exposureScale) * 0.009999999776482582f;
    float _153 = 1.0f - knee;
    if (_144 < _152) {
      _171 = (_144 * exposureScale);
    } else {
      float _162 = ((exposureScale * _153) * _152) * 0.6931471824645996f;
      _171 = (((_152 * exposureScale) - (_162 * log2(_153))) + (_162 * log2((_144 / _152) - knee)));
    }
    float _173 = (_149 / _150) * _171;
    float _177 = (((1.0f - _149) - _150) / _150) * _171;
    float _180 = mad(-0.2533999979496002f, _177, mad(-0.35569998621940613f, _171, (_173 * 1.7166999578475952f)));
    float _183 = mad(0.015799999237060547f, _177, mad(1.6165000200271606f, _171, (_173 * -0.666700005531311f)));
    float _186 = mad(0.9420999884605408f, _177, mad(-0.04280000180006027f, _171, (_173 * 0.01759999990463257f)));
    float _190 = _180 * -0.32673269510269165f;
    _196 = mad(-0.32673269510269165f, _186, mad(-0.32673269510269165f, _183, (_180 * 1.6534652709960938f)));
    _197 = mad(-0.32673269510269165f, _186, mad(1.6534652709960938f, _183, _190));
    _198 = mad(1.6534652709960938f, _186, mad(-0.32673269510269165f, _183, _190));
  } else {
    // Here
    _196 = _121;
    _197 = _122;
    _198 = _123;
  }
  SV_Target.x = saturate(_196);
  SV_Target.y = saturate(_197);
  SV_Target.z = saturate(_198);

  SV_Target.w = 1.0f;

  // untonemapped is linear
  SV_Target.rgb = Tonemap(untonemapped, SV_Target.rgb);
  return SV_Target;
}
