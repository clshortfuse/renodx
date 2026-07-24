#ifndef RENODX_UNREAL_LUT_BUILDER_COLOR_CORRECT_ALL_HLSLI_
#define RENODX_UNREAL_LUT_BUILDER_COLOR_CORRECT_ALL_HLSLI_

#include "./config.hlsli"

namespace unrealengine {
namespace lutbuilder {

// Direct translation of the decompiled ColorCorrectAll region. The temporary
// values and scalar expressions are intentionally retained instead of using
// Unreal Engine source-derived helper implementations.
float3 ColorCorrectAll(float3 working_color, ColorCorrectionConfig config) {
  float _441 = dot(working_color, float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _455 = config.global.offset.w + config.shadows.offset.w;
  float _469 = config.global.gain.w * config.shadows.gain.w;
  float _483 = config.global.gamma.w * config.shadows.gamma.w;
  float _497 = config.global.contrast.w * config.shadows.contrast.w;
  float _511 = config.global.saturation.w * config.shadows.saturation.w;
  float _515 = working_color.x - _441;
  float _516 = working_color.y - _441;
  float _517 = working_color.z - _441;
  float _574 = saturate(_441 / config.shadows_max);
  float _578 = (_574 * _574) * (3.f - (_574 * 2.f));
  float _579 = 1.f - _578;
  float _588 = config.global.offset.w + config.highlights.offset.w;
  float _597 = config.global.gain.w * config.highlights.gain.w;
  float _606 = config.global.gamma.w * config.highlights.gamma.w;
  float _615 = config.global.contrast.w * config.highlights.contrast.w;
  float _624 = config.global.saturation.w * config.highlights.saturation.w;
  float _687 = saturate((_441 - config.highlights_min) / (config.highlights_max - config.highlights_min));
  float _691 = (_687 * _687) * (3.f - (_687 * 2.f));
  float _700 = config.global.offset.w + config.midtones.offset.w;
  float _709 = config.global.gain.w * config.midtones.gain.w;
  float _718 = config.global.gamma.w * config.midtones.gamma.w;
  float _727 = config.global.contrast.w * config.midtones.contrast.w;
  float _736 = config.global.saturation.w * config.midtones.saturation.w;
  float _794 = _578 - _691;
  float _805 = ((_691 * (((config.global.offset.x + config.highlights.offset.x) + _588) + (((config.global.gain.x * config.highlights.gain.x) * _597) * exp2(log2(exp2(((config.global.contrast.x * config.highlights.contrast.x) * _615) * log2(max(0.f, ((((config.global.saturation.x * config.highlights.saturation.x) * _624) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.f / ((config.global.gamma.x * config.highlights.gamma.x) * _606)))))) + (_579 * (((config.global.offset.x + config.shadows.offset.x) + _455) + (((config.global.gain.x * config.shadows.gain.x) * _469) * exp2(log2(exp2(((config.global.contrast.x * config.shadows.contrast.x) * _497) * log2(max(0.f, ((((config.global.saturation.x * config.shadows.saturation.x) * _511) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.f / ((config.global.gamma.x * config.shadows.gamma.x) * _483))))))) + ((((config.global.offset.x + config.midtones.offset.x) + _700) + (((config.global.gain.x * config.midtones.gain.x) * _709) * exp2(log2(exp2(((config.global.contrast.x * config.midtones.contrast.x) * _727) * log2(max(0.f, ((((config.global.saturation.x * config.midtones.saturation.x) * _736) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.f / ((config.global.gamma.x * config.midtones.gamma.x) * _718))))) * _794);
  float _807 = ((_691 * (((config.global.offset.y + config.highlights.offset.y) + _588) + (((config.global.gain.y * config.highlights.gain.y) * _597) * exp2(log2(exp2(((config.global.contrast.y * config.highlights.contrast.y) * _615) * log2(max(0.f, ((((config.global.saturation.y * config.highlights.saturation.y) * _624) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.f / ((config.global.gamma.y * config.highlights.gamma.y) * _606)))))) + (_579 * (((config.global.offset.y + config.shadows.offset.y) + _455) + (((config.global.gain.y * config.shadows.gain.y) * _469) * exp2(log2(exp2(((config.global.contrast.y * config.shadows.contrast.y) * _497) * log2(max(0.f, ((((config.global.saturation.y * config.shadows.saturation.y) * _511) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.f / ((config.global.gamma.y * config.shadows.gamma.y) * _483))))))) + ((((config.global.offset.y + config.midtones.offset.y) + _700) + (((config.global.gain.y * config.midtones.gain.y) * _709) * exp2(log2(exp2(((config.global.contrast.y * config.midtones.contrast.y) * _727) * log2(max(0.f, ((((config.global.saturation.y * config.midtones.saturation.y) * _736) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.f / ((config.global.gamma.y * config.midtones.gamma.y) * _718))))) * _794);
  float _809 = ((_691 * (((config.global.offset.z + config.highlights.offset.z) + _588) + (((config.global.gain.z * config.highlights.gain.z) * _597) * exp2(log2(exp2(((config.global.contrast.z * config.highlights.contrast.z) * _615) * log2(max(0.f, ((((config.global.saturation.z * config.highlights.saturation.z) * _624) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.f / ((config.global.gamma.z * config.highlights.gamma.z) * _606)))))) + (_579 * (((config.global.offset.z + config.shadows.offset.z) + _455) + (((config.global.gain.z * config.shadows.gain.z) * _469) * exp2(log2(exp2(((config.global.contrast.z * config.shadows.contrast.z) * _497) * log2(max(0.f, ((((config.global.saturation.z * config.shadows.saturation.z) * _511) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.f / ((config.global.gamma.z * config.shadows.gamma.z) * _483))))))) + ((((config.global.offset.z + config.midtones.offset.z) + _700) + (((config.global.gain.z * config.midtones.gain.z) * _709) * exp2(log2(exp2(((config.global.contrast.z * config.midtones.contrast.z) * _727) * log2(max(0.f, ((((config.global.saturation.z * config.midtones.saturation.z) * _736) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.f / ((config.global.gamma.z * config.midtones.gamma.z) * _718))))) * _794);

  working_color = lerp(working_color, float3(_805, _807, _809), RENODX_COLOR_GRADE_STRENGTH);
  return working_color;
}

}  // namespace lutbuilder
}  // namespace unrealengine

#endif  // RENODX_UNREAL_LUT_BUILDER_COLOR_CORRECT_ALL_HLSLI_