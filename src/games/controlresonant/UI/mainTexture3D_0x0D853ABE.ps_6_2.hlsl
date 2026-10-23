#include "./UI.hlsli"

Texture3D<float4> g_tTexture3D : register(t0);

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
  float4 _17;
  float _22;
  float _23;
  float _24;
  float _25;
  float _73;
  float _74;
  float _75;
  float _93;
  float _94;
  float _95;
  _13 = rsqrt(dot(float3(TEXCOORD.x, TEXCOORD.y, TEXCOORD.z), float3(TEXCOORD.x, TEXCOORD.y, TEXCOORD.z)));
  _17 = g_tTexture3D.Sample(g_sSampler, float3((_13 * TEXCOORD.x), (_13 * TEXCOORD.y), (_13 * TEXCOORD.z)));
  _22 = _17.x * COLOR.x;
  _23 = _17.y * COLOR.y;
  _24 = _17.z * COLOR.z;
  _25 = _17.w * COLOR.w;
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _73 = (g_vShapeEngineColorAdd.x + mad((g_mShapeEngineColorTransform[3].x), _25, mad((g_mShapeEngineColorTransform[2].x), _24, mad((g_mShapeEngineColorTransform[1].x), _23, ((g_mShapeEngineColorTransform[0].x) * _22))))) * ui_brightness;
  _74 = (g_vShapeEngineColorAdd.y + mad((g_mShapeEngineColorTransform[3].y), _25, mad((g_mShapeEngineColorTransform[2].y), _24, mad((g_mShapeEngineColorTransform[1].y), _23, ((g_mShapeEngineColorTransform[0].y) * _22))))) * ui_brightness;
  _75 = (g_vShapeEngineColorAdd.z + mad((g_mShapeEngineColorTransform[3].z), _25, mad((g_mShapeEngineColorTransform[2].z), _24, mad((g_mShapeEngineColorTransform[1].z), _23, ((g_mShapeEngineColorTransform[0].z) * _22))))) * ui_brightness;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _93 = mad(0.043306104838848114f, _75, mad(0.329291969537735f, _74, (_73 * 0.6274019479751587f)));
    _94 = mad(0.0113602289929986f, _75, mad(0.9195442795753479f, _74, (_73 * 0.06909549236297607f)));
    _95 = mad(0.895578145980835f, _75, mad(0.08802816271781921f, _74, (_73 * 0.016393709927797318f)));
  } else {
    _93 = _73;
    _94 = _74;
    _95 = _75;
  }
  SV_Target.x = _93;
  SV_Target.y = _94;
  SV_Target.z = _95;
  SV_Target.w = (g_vShapeEngineColorAdd.w + mad((g_mShapeEngineColorTransform[3].w), _25, mad((g_mShapeEngineColorTransform[2].w), _24, mad((g_mShapeEngineColorTransform[1].w), _23, ((g_mShapeEngineColorTransform[0].w) * _22)))));
  return SV_Target;
}