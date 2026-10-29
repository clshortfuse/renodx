#include "./UI.hlsli"

cbuffer shared_hdr_global : register(b0) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float3 TEXCOORD : TEXCOORD,
  linear float4 COLOR : COLOR
) : SV_Target {
  float4 SV_Target;
  float _8;
  float _9;
  float _10;
  float _28;
  float _29;
  float _30;
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _8 = ui_brightness * COLOR.x;
  _9 = ui_brightness * COLOR.y;
  _10 = ui_brightness * COLOR.z;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _28 = mad(0.043306104838848114f, _10, mad(0.329291969537735f, _9, (_8 * 0.6274019479751587f)));
    _29 = mad(0.0113602289929986f, _10, mad(0.9195442795753479f, _9, (_8 * 0.06909549236297607f)));
    _30 = mad(0.895578145980835f, _10, mad(0.08802816271781921f, _9, (_8 * 0.016393709927797318f)));
  } else {
    _28 = _8;
    _29 = _9;
    _30 = _10;
  }
  SV_Target.x = _28;
  SV_Target.y = _29;
  SV_Target.z = _30;
  SV_Target.w = COLOR.w;
  return SV_Target;
}