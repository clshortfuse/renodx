#include "./UI.hlsli"

Texture2D<float4> g_tTexture2D : register(t0);

cbuffer shared_hdr_global : register(b0) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

SamplerState g_sSampler : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 COLOR : COLOR,
  linear float4 COLOR_1 : COLOR1
) : SV_Target {
  float4 SV_Target;
  float4 _14;
  float _23;
  float _24;
  float _25;
  float _43;
  float _44;
  float _45;
  _14 = g_tTexture2D.Sample(g_sSampler, float2(TEXCOORD.x, TEXCOORD.y));
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _23 = ui_brightness * COLOR.x;
  _24 = ui_brightness * COLOR.y;
  _25 = ui_brightness * COLOR.z;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _43 = mad(0.043306104838848114f, _25, mad(0.329291969537735f, _24, (_23 * 0.6274019479751587f)));
    _44 = mad(0.0113602289929986f, _25, mad(0.9195442795753479f, _24, (_23 * 0.06909549236297607f)));
    _45 = mad(0.895578145980835f, _25, mad(0.08802816271781921f, _24, (_23 * 0.016393709927797318f)));
  } else {
    _43 = _23;
    _44 = _24;
    _45 = _25;
  }
  SV_Target.x = _43;
  SV_Target.y = _44;
  SV_Target.z = _45;
  SV_Target.w = (dot(float4(_14.x, _14.y, _14.z, _14.w), float4(COLOR_1.x, COLOR_1.y, COLOR_1.z, COLOR_1.w)) * COLOR.w);
  return SV_Target;
}