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
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    linear float3 TEXCOORD: TEXCOORD,
    linear float4 COLOR: COLOR) : SV_Target {
  float4 SV_Target;
  float4 _11;
  float _16;
  float _17;
  float _18;
  float _19;
  float _67;
  float _68;
  float _69;
  float _87;
  float _88;
  float _89;
  _11 = g_tTexture2D.Sample(g_sSampler, float2(TEXCOORD.x, TEXCOORD.y));
  _16 = _11.x * COLOR.x;
  _17 = _11.y * COLOR.y;
  _18 = _11.z * COLOR.z;
  _19 = _11.w * COLOR.w;
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _67 = (g_vShapeEngineColorAdd.x + mad((g_mShapeEngineColorTransform[3].x), _19, mad((g_mShapeEngineColorTransform[2].x), _18, mad((g_mShapeEngineColorTransform[1].x), _17, ((g_mShapeEngineColorTransform[0].x) * _16))))) * ui_brightness;
  _68 = (g_vShapeEngineColorAdd.y + mad((g_mShapeEngineColorTransform[3].y), _19, mad((g_mShapeEngineColorTransform[2].y), _18, mad((g_mShapeEngineColorTransform[1].y), _17, ((g_mShapeEngineColorTransform[0].y) * _16))))) * ui_brightness;
  _69 = (g_vShapeEngineColorAdd.z + mad((g_mShapeEngineColorTransform[3].z), _19, mad((g_mShapeEngineColorTransform[2].z), _18, mad((g_mShapeEngineColorTransform[1].z), _17, ((g_mShapeEngineColorTransform[0].z) * _16))))) * ui_brightness;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _87 = mad(0.043306104838848114f, _69, mad(0.329291969537735f, _68, (_67 * 0.6274019479751587f)));
    _88 = mad(0.0113602289929986f, _69, mad(0.9195442795753479f, _68, (_67 * 0.06909549236297607f)));
    _89 = mad(0.895578145980835f, _69, mad(0.08802816271781921f, _68, (_67 * 0.016393709927797318f)));
  } else {
    _87 = _67;
    _88 = _68;
    _89 = _69;
  }
  SV_Target.x = _87;
  SV_Target.y = _88;
  SV_Target.z = _89;
  SV_Target.w = (g_vShapeEngineColorAdd.w + mad((g_mShapeEngineColorTransform[3].w), _19, mad((g_mShapeEngineColorTransform[2].w), _18, mad((g_mShapeEngineColorTransform[1].w), _17, ((g_mShapeEngineColorTransform[0].w) * _16)))));
  return SV_Target;
}
