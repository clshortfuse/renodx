#include "./UI.hlsli"

TextureCube<float4> g_tTextureCube : register(t0);

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
  float _15;
  float _19;
  float _20;
  float _21;
  float _23;
  float4 _27;
  float _32;
  float _33;
  float _34;
  float _35;
  float _83;
  float _84;
  float _85;
  float _103;
  float _104;
  float _105;
  _13 = -0.0f - ((TEXCOORD.y * 2.0f) + -1.0f);
  _15 = (TEXCOORD.x * 6.283180236816406f) + -3.141590118408203f;
  _19 = 1.0f - abs(_13);
  _20 = _19 * sin(_15);
  _21 = _19 * cos(_15);
  _23 = rsqrt(dot(float3(_20, _13, _21), float3(_20, _13, _21)));
  _27 = g_tTextureCube.Sample(g_sSampler, float3((_20 * _23), (_23 * _13), (_21 * _23)));
  _32 = _27.x * COLOR.x;
  _33 = _27.y * COLOR.y;
  _34 = _27.z * COLOR.z;
  _35 = _27.w * COLOR.w;
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _83 = (g_vShapeEngineColorAdd.x + mad((g_mShapeEngineColorTransform[3].x), _35, mad((g_mShapeEngineColorTransform[2].x), _34, mad((g_mShapeEngineColorTransform[1].x), _33, ((g_mShapeEngineColorTransform[0].x) * _32))))) * ui_brightness;
  _84 = (g_vShapeEngineColorAdd.y + mad((g_mShapeEngineColorTransform[3].y), _35, mad((g_mShapeEngineColorTransform[2].y), _34, mad((g_mShapeEngineColorTransform[1].y), _33, ((g_mShapeEngineColorTransform[0].y) * _32))))) * ui_brightness;
  _85 = (g_vShapeEngineColorAdd.z + mad((g_mShapeEngineColorTransform[3].z), _35, mad((g_mShapeEngineColorTransform[2].z), _34, mad((g_mShapeEngineColorTransform[1].z), _33, ((g_mShapeEngineColorTransform[0].z) * _32))))) * ui_brightness;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _103 = mad(0.043306104838848114f, _85, mad(0.329291969537735f, _84, (_83 * 0.6274019479751587f)));
    _104 = mad(0.0113602289929986f, _85, mad(0.9195442795753479f, _84, (_83 * 0.06909549236297607f)));
    _105 = mad(0.895578145980835f, _85, mad(0.08802816271781921f, _84, (_83 * 0.016393709927797318f)));
  } else {
    _103 = _83;
    _104 = _84;
    _105 = _85;
  }
  SV_Target.x = _103;
  SV_Target.y = _104;
  SV_Target.z = _105;
  SV_Target.w = (g_vShapeEngineColorAdd.w + mad((g_mShapeEngineColorTransform[3].w), _35, mad((g_mShapeEngineColorTransform[2].w), _34, mad((g_mShapeEngineColorTransform[1].w), _33, ((g_mShapeEngineColorTransform[0].w) * _32)))));
  return SV_Target;
}