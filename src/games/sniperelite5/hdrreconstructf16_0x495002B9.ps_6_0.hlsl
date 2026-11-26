#include "./shared.h"
Texture2D<float4> g_xTexture : register(t0);

cbuffer HDRReconstructionParams : register(b0) {
  float4 gxConstantControllingLerpFractorForPerChannelReconstruction : packoffset(c000.x);
  float gfPaperWhiteNits : packoffset(c001.x);
  float gfMaxReconstructedNits : packoffset(c001.y);
  float gfGamma : packoffset(c001.z);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 _6 = g_xTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  // RenoDX: pass the sampled input straight through; vanilla math kept below for reference
  if (gfGamma == 1.0f) {
    return float4(_6.rgb, 1.0f);
  }
  float3 linear_color = renodx::draw::InvertIntermediatePass(_6.rgb);
  linear_color = select(and(linear_color > 0.0f, linear_color < 1.0f), pow(linear_color, gfGamma), linear_color);
  return float4(renodx::draw::RenderIntermediatePass(linear_color), 1.0f);
  // float4 SV_Target;
  // float _10 = 1.000100016593933f - _6.x;
  // float _11 = 1.000100016593933f - _6.y;
  // float _12 = 1.000100016593933f - _6.z;
  // float _13 = _6.x / _10;
  // float _14 = _6.y / _11;
  // float _15 = _6.z / _12;
  // float _19 = gfMaxReconstructedNits / gfPaperWhiteNits;
  // float _20 = _19 + -1.0f;
  // float _21 = _19 / _20;
  // float _22 = _21 * 0.5f;
  // float _23 = _21 + -0.5f;
  // float _24 = _22 / _23;
  // float _25 = 1.0f - _24;
  // float _26 = _21 * _6.x;
  // float _27 = _21 * _6.y;
  // float _28 = _21 * _6.z;
  // float _29 = _21 - _6.x;
  // float _30 = _21 - _6.y;
  // float _31 = _21 - _6.z;
  // float _32 = _26 / _29;
  // float _33 = _27 / _30;
  // float _34 = _28 / _31;
  // float _35 = _25 + _32;
  // float _36 = _33 + _25;
  // float _37 = _34 + _25;
  // bool _38 = (_6.x > 0.5f);
  // bool _39 = (_6.y > 0.5f);
  // bool _40 = (_6.z > 0.5f);
  // float _41 = select(_38, _35, _13);
  // float _42 = select(_39, _36, _14);
  // float _43 = select(_40, _37, _15);
  // float _44 = dot(float3(_6.x, _6.y, _6.z), float3(0.27000001072883606f, 0.6700000166893005f, 0.05999999865889549f));
  // float _45 = 1.000100016593933f - _44;
  // float _46 = _44 / _45;
  // float _47 = _21 * _44;
  // float _48 = _21 - _44;
  // float _49 = _47 / _48;
  // float _50 = _25 + _49;
  // bool _51 = (_44 > 0.5f);
  // float _52 = select(_51, _50, _46);
  // float _53 = _44 + 9.999999747378752e-05f;
  // float _54 = _6.x / _53;
  // float _55 = _6.y / _53;
  // float _56 = _6.z / _53;
  // float _57 = _52 * _54;
  // float _58 = _55 * _52;
  // float _59 = _56 * _52;
  // float _64 = _41 - _57;
  // float _65 = _42 - _58;
  // float _66 = _43 - _59;
  // float _67 = gxConstantControllingLerpFractorForPerChannelReconstruction.x * _64;
  // float _68 = gxConstantControllingLerpFractorForPerChannelReconstruction.y * _65;
  // float _69 = gxConstantControllingLerpFractorForPerChannelReconstruction.z * _66;
  // float _70 = _67 + _57;
  // float _71 = _68 + _58;
  // float _72 = _69 + _59;
  // float _73 = gfPaperWhiteNits * 0.012500000186264515f;
  // float _74 = _70 * _73;
  // float _75 = _71 * _73;
  // float _76 = _72 * _73;
  // float _78 = abs(_74);
  // float _79 = abs(_75);
  // float _80 = abs(_76);
  // float _81 = log2(_78);
  // float _82 = log2(_79);
  // float _83 = log2(_80);
  // float _84 = _81 * gfGamma;
  // float _85 = _82 * gfGamma;
  // float _86 = _83 * gfGamma;
  // float _87 = exp2(_84);
  // float _88 = exp2(_85);
  // float _89 = exp2(_86);
  // SV_Target.x = _87;
  // SV_Target.y = _88;
  // SV_Target.z = _89;
  // SV_Target.w = 1.0f;
  // return SV_Target;
}
