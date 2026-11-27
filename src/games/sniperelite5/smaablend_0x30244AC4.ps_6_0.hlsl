#include "./shared.h"

Texture2D<float4> g_xPostToneMapFrameBufferTexture : register(t0);

Texture2D<float4> g_xBlendWeightsTexture : register(t1);

cbuffer MLAAConstants : register(b0) {
  float4 g_xRTMetrics : packoffset(c000.x);
};

SamplerState g_xBilinearClamp : register(s3);

// RenoDX: darker side wins when one side of the edge is brighter than SDR white.
float HighlightWeight(float3 colour) {
  return pow(max(1.f, renodx::color::y::from::BT709(colour)), -CUSTOM_AA_HIGHLIGHT_WEIGHT);
}

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _11 = g_xBlendWeightsTexture.Sample(g_xBilinearClamp, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float4 _13 = g_xBlendWeightsTexture.Sample(g_xBilinearClamp, float2(TEXCOORD_1.z, TEXCOORD_1.w));
  float4 _15 = g_xBlendWeightsTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _71;
  float _72;
  float _73;
  float _74;
  [branch]
  if (dot(float4(_11.w, _13.y, _15.z, _15.x), float4(1.0f, 1.0f, 1.0f, 1.0f)) < 9.999999747378752e-06f) {
    float4 _21 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
    _71 = _21.x;
    _72 = _21.y;
    _73 = _21.z;
    _74 = _21.w;
  } else {
    bool _29 = (max(_11.w, _15.z) > max(_13.y, _15.x));
    float _34 = select(_29, _11.w, _13.y);
    float _35 = select(_29, _15.z, _15.x);
    float _36 = dot(float2(_34, _35), float2(1.0f, 1.0f));
    float _37 = _34 / _36;
    float _38 = _35 / _36;
    // RenoDX: vanilla blend for the game's own tonemap path, HDR-aware blend otherwise.
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      float4 _48 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(mad(select(_29, _11.w, 0.0f), g_xRTMetrics.x, TEXCOORD.x), mad(select(_29, 0.0f, _13.y), g_xRTMetrics.y, TEXCOORD.y)), 0.0f);
      float4 _57 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(mad(select(_29, _15.z, 0.0f), (-0.0f - g_xRTMetrics.x), TEXCOORD.x), mad(select(_29, 0.0f, _15.x), (-0.0f - g_xRTMetrics.y), TEXCOORD.y)), 0.0f);
      _71 = ((_57.x * _38) + (_48.x * _37));
      _72 = ((_57.y * _38) + (_48.y * _37));
      _73 = ((_57.z * _38) + (_48.z * _37));
      _74 = ((_57.w * _38) + (_48.w * _37));
    } else {
      // RenoDX: pixel coordinates of this pixel and its two blend neighbours.
      int2 pixel = int2(SV_Position.xy);
      int2 last = int2(g_xRTMetrics.zw) - 1;
      int2 step = select(_29, int2(1, 0), int2(0, 1));
      float f1 = select(_29, _11.w, _13.y);
      float f2 = select(_29, _15.z, _15.x);
      float4 c = g_xPostToneMapFrameBufferTexture.Load(int3(clamp(pixel, int2(0, 0), last), 0));
      float4 n1 = g_xPostToneMapFrameBufferTexture.Load(int3(clamp(pixel + step, int2(0, 0), last), 0));
      float4 n2 = g_xPostToneMapFrameBufferTexture.Load(int3(clamp(pixel - step, int2(0, 0), last), 0));
      float kc = _37 * (1.f - f1) + _38 * (1.f - f2);
      float k1 = _37 * f1;
      float k2 = _38 * f2;
      // RenoDX: a non-finite neighbour gets weight 0 (and is zeroed so 0 * NaN cannot leak)
      bool n1_finite = isfinite(renodx::color::y::from::BT709(n1.rgb));
      bool n2_finite = isfinite(renodx::color::y::from::BT709(n2.rgb));
      kc *= HighlightWeight(c.rgb);
      k1 = n1_finite ? k1 * HighlightWeight(n1.rgb) : 0.f;
      k2 = n2_finite ? k2 * HighlightWeight(n2.rgb) : 0.f;
      n1 = n1_finite ? n1 : 0.f;
      n2 = n2_finite ? n2 : 0.f;
      float total_weight = kc + k1 + k2;
      float4 blended = (isfinite(total_weight) && total_weight > 0.f) ? (c * kc + n1 * k1 + n2 * k2) / total_weight : c;
      _71 = blended.x;
      _72 = blended.y;
      _73 = blended.z;
      _74 = blended.w;
    }
  }
  SV_Target.x = _71;
  SV_Target.y = _72;
  SV_Target.z = _73;
  SV_Target.w = _74;
  return SV_Target;
}
