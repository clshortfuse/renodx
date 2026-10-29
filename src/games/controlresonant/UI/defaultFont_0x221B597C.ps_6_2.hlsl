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
  float _68;
  float _69;
  float _70;
  float _48;
  float _49;
  float _50;
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
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _48 = ui_brightness * _20;
  _49 = ui_brightness * _31;
  _50 = ui_brightness * _42;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _68 = mad(0.043306104838848114f, _50, mad(0.329291969537735f, _49, (_48 * 0.6274019479751587f)));
    _69 = mad(0.0113602289929986f, _50, mad(0.9195442795753479f, _49, (_48 * 0.06909549236297607f)));
    _70 = mad(0.895578145980835f, _50, mad(0.08802816271781921f, _49, (_48 * 0.016393709927797318f)));
  } else {
    _68 = _48;
    _69 = _49;
    _70 = _50;
  }
  SV_Target.x = _68;
  SV_Target.y = _69;
  SV_Target.z = _70;
  SV_Target.w = ((((float4)(g_tGuiTexture.Sample(g_sLinearMipLinearWrap_internal, float2(TEXCOORD.x, TEXCOORD.y)))).w) * COLOR.w);
  return SV_Target;
}