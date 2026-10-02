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
  float _58;
  float _69;
  float _80;
  float _107;
  float _108;
  float _109;
  float4 _43;
  float _87;
  float _88;
  float _89;
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
  if (!(_43.x <= 0.040449999272823334f)) {
    _58 = exp2(log2((_43.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _58 = (_43.x * 0.07739938050508499f);
  }
  [branch]
  if (!(_43.y <= 0.040449999272823334f)) {
    _69 = exp2(log2((_43.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _69 = (_43.y * 0.07739938050508499f);
  }
  [branch]
  if (!(_43.z <= 0.040449999272823334f)) {
    _80 = exp2(log2((_43.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _80 = (_43.z * 0.07739938050508499f);
  }
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _87 = (_58 * _20) * ui_brightness;
  _88 = (_69 * _31) * ui_brightness;
  _89 = (_80 * _42) * ui_brightness;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _107 = mad(0.043306104838848114f, _89, mad(0.329291969537735f, _88, (_87 * 0.6274019479751587f)));
    _108 = mad(0.0113602289929986f, _89, mad(0.9195442795753479f, _88, (_87 * 0.06909549236297607f)));
    _109 = mad(0.895578145980835f, _89, mad(0.08802816271781921f, _88, (_87 * 0.016393709927797318f)));
  } else {
    _107 = _87;
    _108 = _88;
    _109 = _89;
  }
  SV_Target.x = _107;
  SV_Target.y = _108;
  SV_Target.z = _109;
  SV_Target.w = (_43.w * COLOR.w);
  return SV_Target;
}