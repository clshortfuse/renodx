#include "../shared.h"

Texture2D<float3> __3__36__0__0__g_ghostHalo : register(t0, space36);

Texture2D<float3> __3__36__0__0__g_blade : register(t6, space36);

cbuffer __3__35__0__0__ExposureConstantBuffer : register(b31, space35) {
  float4 _exposure0 : packoffset(c000.x);
  float4 _exposure1 : packoffset(c001.x);
  float4 _exposure2 : packoffset(c002.x);
  float4 _exposure3 : packoffset(c003.x);
  float4 _exposure4 : packoffset(c004.x);
};

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _textureSizeAndInvSize : packoffset(c000.x);
  float4 _ghostsParams : packoffset(c001.x);
  float4 _ghostsMultiplyColor : packoffset(c002.x);
  float4 _haloParams : packoffset(c003.x);
  float4 _glareBladeParams : packoffset(c004.x);
  uint2 _tileXY : packoffset(c005.x);
  float2 _bufferRatio : packoffset(c005.z);
  float _lensFlareColorScale : packoffset(c006.x);
  float __3__1__0__0__GlobalPushConstants_006y : packoffset(c006.y);
  float __3__1__0__0__GlobalPushConstants_006z : packoffset(c006.z);
  float __3__1__0__0__GlobalPushConstants_006w : packoffset(c006.w);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

float3 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float3 SV_Target;
  float3 _21 = __3__36__0__0__g_ghostHalo.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _32 = _textureSizeAndInvSize.z * 0.5f;
  float _33 = _textureSizeAndInvSize.w * 0.5f;
  float _34 = TEXCOORD.x - _32;
  float _35 = TEXCOORD.y - _33;
  float3 _37 = __3__36__0__0__g_blade.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_34, _35), 0.0f);
  float _41 = _32 + TEXCOORD.x;
  float3 _42 = __3__36__0__0__g_blade.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_41, _35), 0.0f);
  float _49 = _33 + TEXCOORD.y;
  float3 _50 = __3__36__0__0__g_blade.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_34, _49), 0.0f);
  float3 _57 = __3__36__0__0__g_blade.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_41, _49), 0.0f);
  float _65 = ((float4(_lensFlareColorScale, __3__1__0__0__GlobalPushConstants_006y, __3__1__0__0__GlobalPushConstants_006z, __3__1__0__0__GlobalPushConstants_006w).x) * 8.0f) * select(((float4(_lensFlareColorScale, __3__1__0__0__GlobalPushConstants_006y, __3__1__0__0__GlobalPushConstants_006z, __3__1__0__0__GlobalPushConstants_006w).x) < 1.000100016593933f), 1.0f, ((1.0f / min(max(0.5f, _exposure0.y), 10.0f)) + (max(0.009999999776482582f, min(1.0f, _exposure0.y)) * 3.0f)));
  float _69 = (float4(_lensFlareColorScale, __3__1__0__0__GlobalPushConstants_006y, __3__1__0__0__GlobalPushConstants_006z, __3__1__0__0__GlobalPushConstants_006w).x) * 0.5f;
  float _lensStrength = LENS_FLARE_STRENGTH;
  SV_Target.x = exp2(log2((_69 * (((_42.x + _37.x) + _50.x) + _57.x)) + (_65 * _21.x))) * _lensStrength;
  SV_Target.y = exp2(log2((_69 * (((_42.y + _37.y) + _50.y) + _57.y)) + (_65 * _21.y))) * _lensStrength;
  SV_Target.z = exp2(log2((_69 * (((_42.z + _37.z) + _50.z) + _57.z)) + (_65 * _21.z))) * _lensStrength;
  return SV_Target;
}
