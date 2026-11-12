#include "./shared.h"

Texture2D<int4> overlayTexture : register(t0);

Texture2D<float4> maskTexture : register(t1);

cbuffer OverlayParams : register(b0) {
  float2 g_maskPos : packoffset(c000.x);
  float2 g_maskInvSize : packoffset(c000.z);
  float g_maskAlphaOnly : packoffset(c001.x);
  float g_valueScale : packoffset(c001.y);
  float g_swizzle : packoffset(c001.z);
  float g_mip : packoffset(c001.w);
  float g_scale : packoffset(c002.x);
  float g_minLum : packoffset(c002.y);
  float g_maxLum : packoffset(c002.z);
  float g_showDebugLum : packoffset(c002.w);
  float g_debugParam0 : packoffset(c003.x);
  float g_debugParam1 : packoffset(c003.y);
};

SamplerState maskSampler : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  uint2 _13; overlayTexture.GetDimensions(_13.x, _13.y);
  int4 _22 = overlayTexture.Load(int3((uint)(uint(float((uint)_13.x) * TEXCOORD_1.x)), (uint)(uint(float((uint)_13.y) * TEXCOORD_1.y)), 0));
  float _32 = (g_valueScale * TEXCOORD.x) * float((int)(_22.x));
  float _34 = (g_valueScale * TEXCOORD.y) * float((int)(_22.y));
  float _36 = (g_valueScale * TEXCOORD.z) * float((int)(_22.z));
  float _44 = (TEXCOORD_1.z - g_maskPos.x) * g_maskInvSize.x;
  float _45 = (TEXCOORD_1.w - g_maskPos.y) * g_maskInvSize.y;
  float _60;
  float _61;
  float _62;
  float _63;
  float _72;
  float _73;
  float _74;
  float _75;
  if (((bool)((bool)(_44 >= 0.0f) && (bool)(_45 >= 0.0f))) && ((bool)((bool)(_44 <= 1.0f) && (bool)(_45 <= 1.0f)))) {
    float4 _54 = maskTexture.Sample(maskSampler, float2(_44, _45));
    _60 = _54.x;
    _61 = _54.y;
    _62 = _54.z;
    _63 = _54.w;
  } else {
    _60 = 0.0f;
    _61 = 0.0f;
    _62 = 0.0f;
    _63 = 0.0f;
  }
  if (!(g_maskAlphaOnly > 0.0f)) {
    _72 = _63;
    _73 = (_60 * _32);
    _74 = (_61 * _34);
    _75 = (_62 * _36);
  } else {
    _72 = _60;
    _73 = _32;
    _74 = _34;
    _75 = _36;
  }
  SV_Target.x = _73;
  SV_Target.y = _74;
  SV_Target.z = _75;
  SV_Target.w = (_72 * TEXCOORD.w);

  SV_Target.rgb = renodx::color::gamma::DecodeSafe(SV_Target.rgb);
  return SV_Target;
}
