#include "./UI.hlsli"

Texture2D<float4> g_tGuiTexture : register(t0);

cbuffer shared_hdr_global : register(b0) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

SamplerState g_sLinearMipLinearWrap_internal : register(s10, space1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 COLOR : COLOR
) : SV_Target {
  float4 SV_Target;
  float _20;
  float _31;
  float _42;
  float _55;
  float _79;
  float _80;
  float _81;
  float4 _43;
  float _59;
  float _60;
  float _61;
  [branch]
  if (!(COLOR.x <= 0.040449999272823334f)) {
    _20 = exp2(log2((COLOR.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _20 = (COLOR.x * 0.07739938050508499f);
  }
  [branch]
  if (!(COLOR.y <= 0.040449999272823334f)) {
    _31 = exp2(log2((COLOR.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _31 = (COLOR.y * 0.07739938050508499f);
  }
  [branch]
  if (!(COLOR.z <= 0.040449999272823334f)) {
    _42 = exp2(log2((COLOR.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _42 = (COLOR.z * 0.07739938050508499f);
  }
  _43 = g_tGuiTexture.Sample(g_sLinearMipLinearWrap_internal, float2(TEXCOORD.x, TEXCOORD.y));
  [branch]
  if (!(!(_43.w <= 0.040449999272823334f))) {
    _55 = (_43.w * 0.07739938050508499f);
  } else {
    _55 = exp2(log2((_43.w + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  }
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _59 = ui_brightness * _20;
  _60 = ui_brightness * _31;
  _61 = ui_brightness * _42;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _79 = mad(0.043306104838848114f, _61, mad(0.329291969537735f, _60, (_59 * 0.6274019479751587f)));
    _80 = mad(0.0113602289929986f, _61, mad(0.9195442795753479f, _60, (_59 * 0.06909549236297607f)));
    _81 = mad(0.895578145980835f, _61, mad(0.08802816271781921f, _60, (_59 * 0.016393709927797318f)));
  } else {
    _79 = _59;
    _80 = _60;
    _81 = _61;
  }
  SV_Target.x = _79;
  SV_Target.y = _80;
  SV_Target.z = _81;
  SV_Target.w = (_55 * COLOR.w);
  return SV_Target;
}