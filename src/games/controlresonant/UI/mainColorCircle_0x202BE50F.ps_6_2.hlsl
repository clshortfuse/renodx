#include "./UI.hlsli"

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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float3 TEXCOORD : TEXCOORD,
  linear float4 COLOR : COLOR
) : SV_Target {
  float4 SV_Target;
  float _11;
  float _12;
  float _16;
  float _33;
  float _37;
  float _38;
  float _39;
  float _40;
  float _58;
  float _59;
  float _60;
  _11 = (TEXCOORD.x * 2.0f) + -1.0f;
  _12 = (TEXCOORD.y * 2.0f) + -1.0f;
  _16 = sqrt((_12 * _12) + (_11 * _11));
  _33 = (1.0f - saturate((1.0f / (g_vShapeEngineCircle.w - g_vShapeEngineCircle.z)) * (_16 - g_vShapeEngineCircle.z))) * saturate((_16 - g_vShapeEngineCircle.x) * (1.0f / (g_vShapeEngineCircle.y - g_vShapeEngineCircle.x)));
  _37 = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR) * _33;
  _38 = _37 * COLOR.x;
  _39 = _37 * COLOR.y;
  _40 = _37 * COLOR.z;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _58 = mad(0.043306104838848114f, _40, mad(0.329291969537735f, _39, (_38 * 0.6274019479751587f)));
    _59 = mad(0.0113602289929986f, _40, mad(0.9195442795753479f, _39, (_38 * 0.06909549236297607f)));
    _60 = mad(0.895578145980835f, _40, mad(0.08802816271781921f, _39, (_38 * 0.016393709927797318f)));
  } else {
    _58 = _38;
    _59 = _39;
    _60 = _40;
  }
  SV_Target.x = _58;
  SV_Target.y = _59;
  SV_Target.z = _60;
  SV_Target.w = (_33 * COLOR.w);
  return SV_Target;
}