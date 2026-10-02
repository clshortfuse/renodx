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
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 COLOR : COLOR,
  linear float4 COLOR_1 : COLOR1
) : SV_Target {
  float4 SV_Target;
  float _12;
  float _13;
  float _14;
  float _15;
  int _16;
  float _102;
  float _103;
  float _104;
  float _23;
  float4 _24;
  float4 _33;
  float4 _43;
  float _48;
  float _49;
  float _50;
  float _51;
  int _52;
  float _68;
  float4 _69;
  float _74;
  float _81;
  float _82;
  float _83;
  float _84;
  _12 = 0.0f;
  _13 = 0.0f;
  _14 = 0.0f;
  _15 = 0.0f;
  _16 = -1;
  bool _loop_break_0 = false;
  while(true) {
    _23 = (g_vShapeEngineInvTexSize.y * float((int)(_16))) + TEXCOORD.y;
    _24 = g_tTexture2D.Sample(g_sSampler, float2((TEXCOORD.x - g_vShapeEngineInvTexSize.x), _23));
    _33 = g_tTexture2D.Sample(g_sSampler, float2(TEXCOORD.x, _23));
    _43 = g_tTexture2D.Sample(g_sSampler, float2((g_vShapeEngineInvTexSize.x + TEXCOORD.x), _23));
    _48 = ((_24.x + _12) + _33.x) + _43.x;
    _49 = ((_24.y + _13) + _33.y) + _43.y;
    _50 = ((_24.z + _14) + _33.z) + _43.z;
    _51 = ((_24.w + _15) + _33.w) + _43.w;
    _52 = _16 + 1;
    if (!(_52 == 2)) {
      _12 = _48;
      _13 = _49;
      _14 = _50;
      _15 = _51;
      _16 = _52;
      continue;
    }
    _68 = 1.0f - exp2(log2(1.0f - dot(float4((_48 * 0.1111111119389534f), (_49 * 0.1111111119389534f), (_50 * 0.1111111119389534f), (_51 * 0.1111111119389534f)), float4(COLOR_1.x, COLOR_1.y, COLOR_1.z, COLOR_1.w))) * 8.0f);
    _69 = g_tTexture2D.Sample(g_sSampler, float2(TEXCOORD.x, TEXCOORD.y));
    _74 = dot(float4(_69.x, _69.y, _69.z, _69.w), float4(COLOR_1.x, COLOR_1.y, COLOR_1.z, COLOR_1.w));
    _81 = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR) * _74;
    _82 = _81 * COLOR.x;
    _83 = _81 * COLOR.y;
    _84 = _81 * COLOR.z;
    if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
      _102 = mad(0.043306104838848114f, _84, mad(0.329291969537735f, _83, (_82 * 0.6274019479751587f)));
      _103 = mad(0.0113602289929986f, _84, mad(0.9195442795753479f, _83, (_82 * 0.06909549236297607f)));
      _104 = mad(0.895578145980835f, _84, mad(0.08802816271781921f, _83, (_82 * 0.016393709927797318f)));
    } else {
      _102 = _82;
      _103 = _83;
      _104 = _84;
    }
    SV_Target.x = _102;
    SV_Target.y = _103;
    SV_Target.z = _104;
    SV_Target.w = ((lerp(_68, _74, _74)) * COLOR.w);
    break;
  }
  return SV_Target;
}