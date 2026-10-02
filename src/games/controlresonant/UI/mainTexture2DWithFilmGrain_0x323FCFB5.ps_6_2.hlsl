#include "./UI.hlsli"

Texture2D<float4> g_tFilmGrain : register(t0);

Texture2D<float4> g_tTexture2D : register(t1);

cbuffer shared_hdr_global : register(b0) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

cbuffer shared_tonemap_general : register(b1) {
  float g_fVignetteExp : packoffset(c000.x);
  float g_fTonemapWhitepoint : packoffset(c000.y);
  float3 g_vTonemapCrosstalk : packoffset(c001.x);
  float3 g_vTonemapCrosstalkSaturation : packoffset(c002.x);
  float4 g_vTonemapGTParams : packoffset(c003.x);
  float g_fTonemapSaturation : packoffset(c004.x);
  float g_fTonemapBrightness : packoffset(c004.y);
  float g_fFilmGrainIntensity : packoffset(c004.z);
  int2 g_vFilmGrainOffset : packoffset(c005.x);
  int g_bEnableHDRLUT : packoffset(c005.z);
  int g_iTonemapper : packoffset(c005.w);
  float g_fAgxMinEV : packoffset(c006.x);
  float g_fAgxMaxEV : packoffset(c006.y);
  float g_fAgxToePower : packoffset(c006.z);
  float g_fAgxShoulderPower : packoffset(c006.w);
  float g_fAgxContrastSlope : packoffset(c007.x);
  float g_fAgxToePrecalcConstant : packoffset(c007.y);
  float g_fAgxShoulderPrecalcConstant : packoffset(c007.z);
  float3 g_vAgxInsetRow0 : packoffset(c008.x);
  float3 g_vAgxInsetRow1 : packoffset(c009.x);
  float3 g_vAgxInsetRow2 : packoffset(c010.x);
  float3 g_vAgxOutsetRow0 : packoffset(c011.x);
  float3 g_vAgxOutsetRow1 : packoffset(c012.x);
  float3 g_vAgxOutsetRow2 : packoffset(c013.x);
  float g_fAgxHDRRatio : packoffset(c013.w);
  float g_fAgxHDRMidGrey : packoffset(c014.x);
  float g_fAgxHDRToePrecalcConstant : packoffset(c014.y);
  float g_fAgxHDRShoulderPrecalcConstant : packoffset(c014.z);
  float g_fAgxHDRSaturation : packoffset(c014.w);
};

cbuffer shared_tonemap_post : register(b2) {
  float g_fPaperWhite : packoffset(c000.x);
  int g_bApplyVignette : packoffset(c000.y);
  int g_bApplyFilmGrain : packoffset(c000.z);
};

cbuffer embedded_shapeengine : register(b3) {
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
  linear float4 COLOR : COLOR,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _14;
  float _19;
  float _20;
  float _21;
  float _22;
  float _64;
  float _65;
  float _66;
  float _114;
  float _115;
  float _116;
  float _139;
  float _140;
  float _141;
  float4 _83;
  float _103;
  float _119;
  float _120;
  float _121;
  _14 = g_tTexture2D.Sample(g_sSampler, float2(TEXCOORD.x, TEXCOORD.y));
  _19 = _14.x * COLOR.x;
  _20 = _14.y * COLOR.y;
  _21 = _14.z * COLOR.z;
  _22 = _14.w * COLOR.w;
  _64 = g_vShapeEngineColorAdd.x + mad((g_mShapeEngineColorTransform[3].x), _22, mad((g_mShapeEngineColorTransform[2].x), _21, mad((g_mShapeEngineColorTransform[1].x), _20, ((g_mShapeEngineColorTransform[0].x) * _19))));
  _65 = g_vShapeEngineColorAdd.y + mad((g_mShapeEngineColorTransform[3].y), _22, mad((g_mShapeEngineColorTransform[2].y), _21, mad((g_mShapeEngineColorTransform[1].y), _20, ((g_mShapeEngineColorTransform[0].y) * _19))));
  _66 = g_vShapeEngineColorAdd.z + mad((g_mShapeEngineColorTransform[3].z), _22, mad((g_mShapeEngineColorTransform[2].z), _21, mad((g_mShapeEngineColorTransform[1].z), _20, ((g_mShapeEngineColorTransform[0].z) * _19))));
  if (!(g_bApplyFilmGrain == 0)) {
    _83 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _103 = g_fFilmGrainIntensity * ((1.0f - sqrt(max(dot(float3(_64, _65, _66), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f))) * 5.0f);
    _114 = (((_103 * ((_83.x * 2.0f) + -1.0f)) * saturate(_64)) + _64);
    _115 = (((_103 * ((_83.y * 2.0f) + -1.0f)) * saturate(_65)) + _65);
    _116 = (((_103 * ((_83.z * 2.0f) + -1.0f)) * saturate(_66)) + _66);
  } else {
    _114 = _64;
    _115 = _65;
    _116 = _66;
  }
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  _119 = ui_brightness * _114;
  _120 = ui_brightness * _115;
  _121 = ui_brightness * _116;
  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
    _139 = mad(0.043306104838848114f, _121, mad(0.329291969537735f, _120, (_119 * 0.6274019479751587f)));
    _140 = mad(0.0113602289929986f, _121, mad(0.9195442795753479f, _120, (_119 * 0.06909549236297607f)));
    _141 = mad(0.895578145980835f, _121, mad(0.08802816271781921f, _120, (_119 * 0.016393709927797318f)));
  } else {
    _139 = _119;
    _140 = _120;
    _141 = _121;
  }
  SV_Target.x = _139;
  SV_Target.y = _140;
  SV_Target.z = _141;
  SV_Target.w = (g_vShapeEngineColorAdd.w + mad((g_mShapeEngineColorTransform[3].w), _22, mad((g_mShapeEngineColorTransform[2].w), _21, mad((g_mShapeEngineColorTransform[1].w), _20, ((g_mShapeEngineColorTransform[0].w) * _19)))));
  return SV_Target;
}