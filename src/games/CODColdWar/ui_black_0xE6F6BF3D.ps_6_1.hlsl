// Call of Duty: Black Ops Cold War
// RenoDX hash: 0xE6F6BF3D
// Shader Model: ps_6_1
//
// Generic 2D UI image quad (texture * vertex colour, UI colour matrix,
// straight alpha over the HDR scene). The game also draws its full-screen
// black fades with it, e.g. the black screen at mission/cutscene start.
//
// HDR black-overlay fix (custom tone-map modes only; Vanilla is untouched):
// The fade quad is ~98-99.96% opaque black (measured 2026-10-20: 0.04% of the
// scene transmitted while the screen should be black). That was invisible over
// an SDR scene (<= ~diffuse white) but over an HDR scene of up to ~2500 nits it
// left ~0.4-0.6 nits after the late pass, so the scene showed through.
// For black pixels only, transmission t = 1 - alpha becomes t^k with
//     k = 1 + log2(Peak / Game Brightness) / log2(50)
// so a 98%-opaque black hides peak highlights as well as it hid SDR white
// (2700/203 -> k ~ 1.66). Fully transparent and fully opaque pixels, and all
// coloured or textured UI, are unchanged. Verified live: the start-of-mission
// black screen became fully black apart from subtitles.

#include "./shared.h"

Texture2D<float4> colorMapSampler : register(t0);

cbuffer PerSceneConsts : register(b2) {
  float4 ui2dColorMatrixR : packoffset(c108.x);
  float4 ui2dColorMatrixG : packoffset(c109.x);
  float4 ui2dColorMatrixB : packoffset(c110.x);
};

SamplerState colorSampler : register(s0);

static const float UI_BLACK_LEVEL = 0.00001f;      // max channel treated as black
static const float UI_BLACK_REFERENCE_TRANSMISSION = 50.0f;  // 1 / 2% leak

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 COLOR : COLOR,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _10 = colorMapSampler.Sample(colorSampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _15 = _10.x * COLOR.x;
  float _16 = _10.y * COLOR.y;
  float _17 = _10.z * COLOR.z;
  float _55;
  float _56;
  float _57;
  [branch]
  if (ui2dColorMatrixR.w == 1.0f) {
    _55 = (exp2(log2(_15 * 5.55555534362793f) * ui2dColorMatrixG.w) * 0.18000000715255737f);
    _56 = (exp2(log2(_16 * 5.55555534362793f) * ui2dColorMatrixG.w) * 0.18000000715255737f);
    _57 = (exp2(log2(_17 * 5.55555534362793f) * ui2dColorMatrixG.w) * 0.18000000715255737f);
  } else {
    [branch]
    if (ui2dColorMatrixR.w == 2.0f) {
      _55 = (pow(_15, ui2dColorMatrixG.w));
      _56 = (pow(_16, ui2dColorMatrixG.w));
      _57 = (pow(_17, ui2dColorMatrixG.w));
    } else {
      _55 = _15;
      _56 = _16;
      _57 = _17;
    }
  }
  SV_Target.x = dot(float3(_55, _56, _57), float3(ui2dColorMatrixR.x, ui2dColorMatrixR.y, ui2dColorMatrixR.z));
  SV_Target.y = dot(float3(_55, _56, _57), float3(ui2dColorMatrixG.x, ui2dColorMatrixG.y, ui2dColorMatrixG.z));
  SV_Target.z = dot(float3(_55, _56, _57), float3(ui2dColorMatrixB.x, ui2dColorMatrixB.y, ui2dColorMatrixB.z));
  SV_Target.w = (_10.w * COLOR.w);

  // RenoDX: HDR-aware opacity for black overlays (see header).
  [branch]
  if (RENODX_TONE_MAP_TYPE >= 0.5f
      && max(SV_Target.x, max(SV_Target.y, SV_Target.z)) <= UI_BLACK_LEVEL
      && SV_Target.w > 0.0f && SV_Target.w < 1.0f)
  {
    float headroom = max(RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f), 1.0f);
    float k = 1.0f + log2(headroom) / log2(UI_BLACK_REFERENCE_TRANSMISSION);
    SV_Target.w = 1.0f - pow(1.0f - SV_Target.w, k);
  }
  return SV_Target;
}
