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
  linear float3 TEXCOORD : TEXCOORD,
  linear float4 COLOR : COLOR
) : SV_Target {
  float4 SV_Target;
  float _15;
  float _16;
  float _17;
  float _35;
  float _36;
  float _37;
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _15 = ui_brightness * COLOR.x;
  _16 = ui_brightness * COLOR.y;
  _17 = ui_brightness * COLOR.z;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _35 = mad(0.043306104838848114f, _17, mad(0.329291969537735f, _16, (_15 * 0.6274019479751587f)));
    _36 = mad(0.0113602289929986f, _17, mad(0.9195442795753479f, _16, (_15 * 0.06909549236297607f)));
    _37 = mad(0.895578145980835f, _17, mad(0.08802816271781921f, _16, (_15 * 0.016393709927797318f)));
  } else {
    _35 = _15;
    _36 = _16;
    _37 = _17;
  }
  SV_Target.x = _35;
  SV_Target.y = _36;
  SV_Target.z = _37;
  SV_Target.w = ((((float4)(g_tTexture2D.Sample(g_sSampler, float2(TEXCOORD.x, TEXCOORD.y)))).w) * COLOR.w);
  return SV_Target;
}