#include "./UI.hlsli"

Texture2D<float4> g_tTexture2D : register(t0);

cbuffer shared_hdr_global : register(b0) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

cbuffer stroke : register(b1) {
  float4 g_vStrokeColor : packoffset(c000.x);
  float g_fStrokeWidth : packoffset(c001.x);
};

cbuffer font_atlas : register(b2) {
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
  float _18;
  float _25;
  float _45;
  float _63;
  float _104;
  float _105;
  float _106;
  float _38;
  float _46;
  float _56;
  float _65;
  float _71;
  float _84;
  float _85;
  float _86;
  _18 = (((float4)(g_tTexture2D.Sample(g_sLinearClamp_internal, float2(TEXCOORD.x, TEXCOORD.y)))).x) / (g_fAtlasSizeX * ddx_coarse(TEXCOORD.x));
  _25 = g_fStrokeWidth / (g_fAtlasSizeX * ddx_coarse(TEXCOORD.x));
  if (!(_18 < -1.0f)) {
    if ((_18 >= -1.0f) && (_18 < 1.0f)) {
      _38 = saturate((_18 + 1.0f) * 0.5f);
      _45 = (1.0f - ((_38 * _38) * (3.0f - (_38 * 2.0f))));
    } else {
      _45 = 0.0f;
    }
  } else {
    _45 = 1.0f;
  }
  _46 = _25 + -1.0f;
  if (!(_18 < _46)) {
    if ((_18 >= _46) && (_18 < (_25 + 1.0f))) {
      _56 = saturate((_18 - _46) * 0.5f);
      _63 = (1.0f - ((_56 * _56) * (3.0f - (_56 * 2.0f))));
    } else {
      _63 = 0.0f;
    }
  } else {
    _63 = 1.0f;
  }
  _65 = _63 * g_vStrokeColor.w;
  _71 = _65 * (1.0f - _45);
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _84 = ((_71 * g_vStrokeColor.x) + (_45 * COLOR.x)) * ui_brightness;
  _85 = ((_71 * g_vStrokeColor.y) + (_45 * COLOR.y)) * ui_brightness;
  _86 = ((_71 * g_vStrokeColor.z) + (_45 * COLOR.z)) * ui_brightness;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _104 = mad(0.043306104838848114f, _86, mad(0.329291969537735f, _85, (_84 * 0.6274019479751587f)));
    _105 = mad(0.0113602289929986f, _86, mad(0.9195442795753479f, _85, (_84 * 0.06909549236297607f)));
    _106 = mad(0.895578145980835f, _86, mad(0.08802816271781921f, _85, (_84 * 0.016393709927797318f)));
  } else {
    _104 = _84;
    _105 = _85;
    _106 = _86;
  }
  SV_Target.x = _104;
  SV_Target.y = _105;
  SV_Target.z = _106;
  SV_Target.w = (1.0f - ((1.0f - _65) * (1.0f - (_45 * COLOR.w))));
  return SV_Target;
}