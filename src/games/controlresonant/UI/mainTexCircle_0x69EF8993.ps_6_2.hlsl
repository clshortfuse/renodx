#include "./UI.hlsli"

Texture2D<float4> g_tTexture2D : register(t0);

cbuffer shared_hdr_global : register(b0) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

cbuffer embedded_shapeengine : register(b1) {
  row_major float4x4 g_mShapeEngineLocalToClip : packoffset(c000.x);
  row_major float4x4 g_mShapeEngineColorTransform : packoffset(c004.x);
  float4 g_vShapeEngineColorAdd : packoffset(c008.x);
  float4 g_vShapeEngineCircle : packoffset(c009.x);
  float2 g_vShapeEngineInvTexSize : packoffset(c010.x);
  float2 g_vShapeEngineHalfPixelOffset : packoffset(c010.z);
  uint2 g_vShapeEngineInstanceDataOffsetAndStride : packoffset(c011.x);
  float g_fShapeEnginePointSize : packoffset(c011.z);
  int g_iShapeEngineInstanceStartIndex : packoffset(c011.w);
  float g_fGridPrimaryDivisions : packoffset(c012.x);
  float g_fGridSecondaryDivisions : packoffset(c012.y);
  float g_fGridPrimaryLineThickness : packoffset(c012.z);
  float g_fGridSecondaryLineThickness : packoffset(c012.w);
  float4 g_vGridPrimaryColor : packoffset(c013.x);
  float4 g_vGridSecondaryColor : packoffset(c014.x);
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
  float _13;
  float _14;
  float _18;
  float4 _19;
  float _40;
  float _45;
  float _47;
  float _49;
  float _51;
  float _69;
  float _70;
  float _71;
  _13 = (TEXCOORD.x * 2.0f) + -1.0f;
  _14 = (TEXCOORD.y * 2.0f) + -1.0f;
  _18 = sqrt((_14 * _14) + (_13 * _13));
  _19 = g_tTexture2D.Sample(g_sSampler, float2(TEXCOORD.x, TEXCOORD.y));
  _40 = (1.0f - saturate((1.0f / (g_vShapeEngineCircle.w - g_vShapeEngineCircle.z)) * (_18 - g_vShapeEngineCircle.z))) * saturate((_18 - g_vShapeEngineCircle.x) * (1.0f / (g_vShapeEngineCircle.y - g_vShapeEngineCircle.x)));
  _45 = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR) * _40;
  _47 = (_45 * COLOR.x) * _19.x;
  _49 = (_45 * COLOR.y) * _19.y;
  _51 = (_45 * COLOR.z) * _19.z;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _69 = mad(0.043306104838848114f, _51, mad(0.329291969537735f, _49, (_47 * 0.6274019479751587f)));
    _70 = mad(0.0113602289929986f, _51, mad(0.9195442795753479f, _49, (_47 * 0.06909549236297607f)));
    _71 = mad(0.895578145980835f, _51, mad(0.08802816271781921f, _49, (_47 * 0.016393709927797318f)));
  } else {
    _69 = _47;
    _70 = _49;
    _71 = _51;
  }
  SV_Target.x = _69;
  SV_Target.y = _70;
  SV_Target.z = _71;
  SV_Target.w = ((_19.w * COLOR.w) * _40);
  return SV_Target;
}