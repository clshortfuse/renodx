#include "./UI.hlsli"

Texture2D<float4> g_tTexture2D : register(t0);

cbuffer shared_hdr_global : register(b0) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

cbuffer font_atlas : register(b1) {
  float g_fAtlasSizeX : packoffset(c000.x);
  float g_fAtlasSizeY : packoffset(c000.y);
};

SamplerState g_sLinearClamp_internal : register(s6, space1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float3 TEXCOORD : TEXCOORD,
  linear float4 COLOR : COLOR
) : SV_Target {
  float4 SV_Target;
  float _20;
  float _28;
  float _29;
  float _30;
  float _48;
  float _49;
  float _50;
  _20 = saturate((((((float4)(g_tTexture2D.Sample(g_sLinearClamp_internal, float2(TEXCOORD.x, TEXCOORD.y)))).x) / (g_fAtlasSizeX * ddx_coarse(TEXCOORD.x))) + -1.0f) * -0.5f);
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _28 = ui_brightness * COLOR.x;
  _29 = ui_brightness * COLOR.y;
  _30 = ui_brightness * COLOR.z;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _48 = mad(0.043306104838848114f, _30, mad(0.329291969537735f, _29, (_28 * 0.6274019479751587f)));
    _49 = mad(0.0113602289929986f, _30, mad(0.9195442795753479f, _29, (_28 * 0.06909549236297607f)));
    _50 = mad(0.895578145980835f, _30, mad(0.08802816271781921f, _29, (_28 * 0.016393709927797318f)));
  } else {
    _48 = _28;
    _49 = _29;
    _50 = _30;
  }
  SV_Target.x = _48;
  SV_Target.y = _49;
  SV_Target.z = _50;
  SV_Target.w = (((_20 * _20) * COLOR.w) * (3.0f - (_20 * 2.0f)));
  return SV_Target;
}