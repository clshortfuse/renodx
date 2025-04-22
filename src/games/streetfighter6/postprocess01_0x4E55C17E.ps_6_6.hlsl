#include "./common.hlsl"

Texture2D<float4> HDRImage : register(t0);

cbuffer CameraKerare : register(b0) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
};

cbuffer TonemapParam : register(b1) {
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

cbuffer DynamicRangeConversionParam : register(b2) {
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
  float4 _18 = HDRImage.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _24 = Kerare.x / Kerare.w;
  float _25 = Kerare.y / Kerare.w;
  float _26 = Kerare.z / Kerare.w;
  float _30 = abs(rsqrt(dot(float3(_24, _25, _26), float3(_24, _25, _26))) * _26);
  float _37 = _30 * _30;
  float _41 = saturate(((_37 * _37) * (1.0f - saturate((kerare_scale * _30) + kerare_offset))) + kerare_brightness);
  float _43 = (_18.x * Exposure) * _41;
  float _45 = (_18.y * Exposure) * _41;
  float _47 = (_18.z * Exposure) * _41;
  float3 untonemapped = float3(_43, _45, _47);
  
  float _150;
  float _151;
  float _152;
  float _200;
  float _225;
  float _226;
  float _227;
  if (isfinite(max(max(_43, _45), _47))) {
    float _56 = invLinearBegin * _43;
    float _62 = invLinearBegin * _45;
    float _68 = invLinearBegin * _47;
    float _75 = select((_43 >= linearBegin), 0.0f, (1.0f - ((_56 * _56) * (3.0f - (_56 * 2.0f)))));
    float _77 = select((_45 >= linearBegin), 0.0f, (1.0f - ((_62 * _62) * (3.0f - (_62 * 2.0f)))));
    float _79 = select((_47 >= linearBegin), 0.0f, (1.0f - ((_68 * _68) * (3.0f - (_68 * 2.0f)))));
    float _85 = select((_43 < linearStart), 0.0f, 1.0f);
    float _86 = select((_45 < linearStart), 0.0f, 1.0f);
    float _87 = select((_47 < linearStart), 0.0f, 1.0f);
    _150 = (((((contrast * _43) + madLinearStartContrastFactor) * ((1.0f - _85) - _75)) + (((pow(_56, toe)) * _75) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _43) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _85));
    _151 = (((((contrast * _45) + madLinearStartContrastFactor) * ((1.0f - _86) - _77)) + (((pow(_62, toe)) * _77) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _45) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _86));
    _152 = (((((contrast * _47) + madLinearStartContrastFactor) * ((1.0f - _87) - _79)) + (((pow(_68, toe)) * _79) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _47) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _87));
  } else {
    _150 = 1.0f;
    _151 = 1.0f;
    _152 = 1.0f;
  }
  if (!(useDynamicRangeConversion == 0.0f)) {
    float _162 = mad(0.16500000655651093f, _152, mad(0.16500000655651093f, _151, (_150 * 0.6699999570846558f)));
    float _163 = _150 * 0.16500000655651093f;
    float _165 = mad(0.16500000655651093f, _152, mad(0.6699999570846558f, _151, _163));
    float _167 = mad(0.6699999570846558f, _152, mad(0.16500000655651093f, _151, _163));
    float _170 = mad(0.1688999980688095f, _167, mad(0.1446000039577484f, _165, (_162 * 0.6370000243186951f)));
    float _173 = mad(0.059300001710653305f, _167, mad(0.6779999732971191f, _165, (_162 * 0.26269999146461487f)));
    float _177 = (_173 + _170) + mad(1.0609999895095825f, _167, mad(0.02810000069439411f, _165, 0.0f));
    float _178 = _170 / _177;
    float _179 = _173 / _177;
    float _181 = (kneeStartNit / exposureScale) * 0.009999999776482582f;
    float _182 = 1.0f - knee;
    if (_173 < _181) {
      _200 = (_173 * exposureScale);
    } else {
      float _191 = ((exposureScale * _182) * _181) * 0.6931471824645996f;
      _200 = (((_181 * exposureScale) - (_191 * log2(_182))) + (_191 * log2((_173 / _181) - knee)));
    }
    float _202 = (_178 / _179) * _200;
    float _206 = (((1.0f - _178) - _179) / _179) * _200;
    float _209 = mad(-0.2533999979496002f, _206, mad(-0.35569998621940613f, _200, (_202 * 1.7166999578475952f)));
    float _212 = mad(0.015799999237060547f, _206, mad(1.6165000200271606f, _200, (_202 * -0.666700005531311f)));
    float _215 = mad(0.9420999884605408f, _206, mad(-0.04280000180006027f, _200, (_202 * 0.01759999990463257f)));
    float _219 = _209 * -0.32673269510269165f;
    _225 = mad(-0.32673269510269165f, _215, mad(-0.32673269510269165f, _212, (_209 * 1.6534652709960938f)));
    _226 = mad(-0.32673269510269165f, _215, mad(1.6534652709960938f, _212, _219));
    _227 = mad(1.6534652709960938f, _215, mad(-0.32673269510269165f, _212, _219));
  } else {
    _225 = _150;
    _226 = _151;
    _227 = _152;
  }
  SV_Target.x = saturate(_225);
  SV_Target.y = saturate(_226);
  SV_Target.z = saturate(_227);
  SV_Target.w = 1.0f;

  // untonemapped is linear
  SV_Target.rgb = Tonemap(untonemapped, SV_Target.rgb);
  return SV_Target;
}
