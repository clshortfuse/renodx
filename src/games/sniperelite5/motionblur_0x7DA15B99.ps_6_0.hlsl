#include "./shared.h"

Texture2D<float4> g_xUserTexture0 : register(t3);

Texture2D<float4> g_xUserTexture1 : register(t4);

cbuffer MotionBlurIterationPSConstants : register(b11) {
  float g_fIterationStep : packoffset(c000.x);
  float g_fBlurDistanceMultiplier : packoffset(c000.y);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  int _9 = int(SV_Position.x);
  int _10 = int(SV_Position.y);
  float4 _11 = g_xUserTexture1.Load(int3(_9, _10, 0));
  // RenoDX: motion blur strength slider
  float _20 = (_11.x + -0.5f) * g_fBlurDistanceMultiplier * CUSTOM_MOTION_BLUR;
  float _21 = (_11.y + -0.5f) * g_fBlurDistanceMultiplier * CUSTOM_MOTION_BLUR;
  // RenoDX: high quality path, 8 taps along the same velocity
  if (CUSTOM_MOTION_BLUR_QUALITY == 1.f) {
    static const float kTapOffsets[8] = {-0.4f, -0.29f, -0.18f, -0.07f, 0.07f, 0.18f, 0.29f, 0.4f};
    float3 _sum = 0.0f;
    float _weights = 0.0f;
    [unroll]
    for (int i = 0; i < 8; i++) {
      float4 _tap = g_xUserTexture0.Sample(g_xBilinearClamp, float2((TEXCOORD.x + (_20 * kTapOffsets[i])), (TEXCOORD.y + (_21 * kTapOffsets[i]))));
      _sum += _tap.rgb * _tap.w;
      _weights += _tap.w;
    }
    float4 _82h = g_xUserTexture0.Load(int3(_9, _10, 0));
    float _86h = ((0.5f * _weights) / ((0.5f * _weights) + 1.0f)) * _11.z;
    SV_Target.xyz = (((_sum / max(_weights, 1e-7f)) - _82h.xyz) * _86h) + _82h.xyz;
    SV_Target.w = _11.w;
    return SV_Target;
  }
  float _22 = _20 * 0.4000000059604645f;
  float _23 = _21 * 0.4000000059604645f;
  float4 _26 = g_xUserTexture0.Sample(g_xBilinearClamp, float2((TEXCOORD.x - _22), (TEXCOORD.y - _23)));
  float _31 = _20 * 0.17999999225139618f;
  float _32 = _21 * 0.17999999225139618f;
  float4 _35 = g_xUserTexture0.Sample(g_xBilinearClamp, float2((TEXCOORD.x - _31), (TEXCOORD.y - _32)));
  float4 _42 = g_xUserTexture0.Sample(g_xBilinearClamp, float2((_31 + TEXCOORD.x), (_32 + TEXCOORD.y)));
  float4 _49 = g_xUserTexture0.Sample(g_xBilinearClamp, float2((_22 + TEXCOORD.x), (_23 + TEXCOORD.y)));
  // RenoDX: weights sum to 0 where nothing moves; 0/0 was hidden by the UNORM target (NaN -> 0) but stays NaN in float
  float _54 = max(dot(float4(_26.w, _35.w, _42.w, _49.w), float4(1.0f, 1.0f, 1.0f, 1.0f)), 1.0000000116860974e-07f);
  float _55 = _26.w / _54;
  float _56 = _35.w / _54;
  float _57 = _42.w / _54;
  float _58 = _49.w / _54;
  float4 _82 = g_xUserTexture0.Load(int3(_9, _10, 0));
  float _86 = (_54 / (_54 + 1.0f)) * _11.z;
  SV_Target.x = (((((((_56 * _35.x) + (_55 * _26.x)) + (_57 * _42.x)) + (_58 * _49.x)) - _82.x) * _86) + _82.x);
  SV_Target.y = (((((((_56 * _35.y) + (_55 * _26.y)) + (_57 * _42.y)) + (_58 * _49.y)) - _82.y) * _86) + _82.y);
  SV_Target.z = (((((((_56 * _35.z) + (_55 * _26.z)) + (_57 * _42.z)) + (_58 * _49.z)) - _82.z) * _86) + _82.z);
  SV_Target.w = _11.w;
  return SV_Target;
}
