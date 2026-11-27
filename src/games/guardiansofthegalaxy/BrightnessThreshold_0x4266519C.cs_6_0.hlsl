#include "./shared.h"

// BrightnessThreshold_CS: bloom prefilter (anti-firefly 2x2 trimmed mean, threshold, saturation) -> R11G11B10F.

Texture2D<float4> mapInput : register(t0);

RWTexture2D<float3> uavOut : register(u0);

cbuffer _BloomP0 : register(b0) {
  uint2 g_vScreenSize : packoffset(c000.x);
  float g_fBrightnessThreshold : packoffset(c000.z);
  float g_fSoftening : packoffset(c000.w);
  float g_fBloomSaturation : packoffset(c001.x);
  float fPadding0 : packoffset(c001.y);
  float fPadding1 : packoffset(c001.z);
  float fPadding2 : packoffset(c001.w);
};

SamplerState MaterialSamplers[1920] : register(s0);

[numthreads(16, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  if ((bool)((uint)(uint)(SV_DispatchThreadID.x) < (uint)g_vScreenSize.x) && (bool)((uint)(uint)(SV_DispatchThreadID.y) < (uint)g_vScreenSize.y)) {
    float _19 = float((uint)(int)(g_vScreenSize.x));
    float _20 = float((uint)(int)(g_vScreenSize.y));
    float _21 = float((uint)SV_DispatchThreadID.x) / _19;
    float _22 = float((uint)SV_DispatchThreadID.y) / _20;
    float _25 = float((uint)(SV_DispatchThreadID.x + 1u)) / _19;
    float _28 = float((uint)(SV_DispatchThreadID.y + 1u)) / _20;
    float4 _29 = mapInput.SampleLevel(MaterialSamplers[11u], float2(_21, _22), 0.0f);
    float4 _33 = mapInput.SampleLevel(MaterialSamplers[11u], float2(_25, _22), 0.0f);
    float4 _37 = mapInput.SampleLevel(MaterialSamplers[11u], float2(_21, _28), 0.0f);
    float4 _41 = mapInput.SampleLevel(MaterialSamplers[11u], float2(_25, _28), 0.0f);
    float _78 = (((((_33.x + _29.x) + _37.x) + _41.x) - min(min(min(_29.x, _33.x), _37.x), _41.x)) - max(max(max(_29.x, _33.x), _37.x), _41.x)) * 0.5f;
    float _79 = (((((_33.y + _29.y) + _37.y) + _41.y) - min(min(min(_29.y, _33.y), _37.y), _41.y)) - max(max(max(_29.y, _33.y), _37.y), _41.y)) * 0.5f;
    float _80 = (((((_33.z + _29.z) + _37.z) + _41.z) - min(min(min(_29.z, _33.z), _37.z), _41.z)) - max(max(max(_29.z, _33.z), _37.z), _41.z)) * 0.5f;
    float _83 = max(max(_78, max(_79, _80)), 1.000000013351432e-10f);
    float _91 = min(max(((g_fSoftening + _83) - g_fBrightnessThreshold * RENODX_BLOOM_THRESHOLD), 0.0f), (g_fSoftening * 2.0f));
    float _100 = min(max((max((_83 - g_fBrightnessThreshold * RENODX_BLOOM_THRESHOLD), ((_91 * _91) / ((g_fSoftening * 4.0f) + 1.000000013351432e-10f))) / _83), 0.0f), 10.0f);
    // CUSTOM: the original pivots saturation on the max channel, so with saturation 4 every channel below 75% of the max went negative
    // and was clipped to 0 by the R11G11B10F target. Shape the channels with ratio^saturation instead (identical at saturation 1),
    // scaled to the original bloom luminance, so only the colour changes.
    // CUSTOM: all later bloom passes are linear, so scaling the final value here scales the bloom exactly.
    float saturation = lerp(1.f, g_fBloomSaturation, RENODX_BLOOM_SATURATION);
    float3 vanilla_bloom = max(_83 + saturation * (_100 * float3(_78, _79, _80) - _83), 0.f);
    float3 shaped_bloom = max(_83 + saturation * (_100 * _83 - _83), 0.f) * pow(max(float3(_78, _79, _80) / _83, 1e-6f), saturation);
    float vanilla_luminance = dot(vanilla_bloom, float3(0.2126f, 0.7152f, 0.0722f));
    float shaped_luminance = dot(shaped_bloom, float3(0.2126f, 0.7152f, 0.0722f));
    uavOut[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = (shaped_luminance > 0.f ? shaped_bloom * (vanilla_luminance / shaped_luminance) : vanilla_bloom) * RENODX_BLOOM_STRENGTH;
  }
}
