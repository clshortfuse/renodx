#include "./shared.h"

Texture2D<float4> mapInput : register(t0);

Texture2D<float4> mapSaturationMask : register(t1);

Texture3D<float4> mapLUT : register(t2);

RWTexture2D<float4> uavOutput : register(u0);

cbuffer _ColorGrading : register(b0) {
  uint2 g_vScreenSize : packoffset(c000.x);
  float g_fSaturation : packoffset(c000.z);
  float g_fContrastCorrectionFactor : packoffset(c000.w);
  uint g_inputIsToneMapped : packoffset(c001.x);
  uint g_nLutSize : packoffset(c001.y);
  float fPadding0 : packoffset(c001.z);
  float fPadding1 : packoffset(c001.w);
};

SamplerState MaterialSamplers[1920] : register(s0);

// log2 offset and scale of the LUT input encoding.
static const float LUT_LOG2_OFFSET = 9.720000267028809f;
static const float LUT_LOG2_SCALE = 0.05707762390375137f;
// Largest LUT-encoded input; brighter inputs are scaled down to this before sampling.
static const float LUT_CEIL = exp2(1.f / LUT_LOG2_SCALE - LUT_LOG2_OFFSET);

float3 SampleGradedLUT(float3 lut_in, float saturation, float scale) {
  float3 scaled_in = lut_in * scale;
  float3 lut = mapLUT.SampleLevel(MaterialSamplers[1u], float3(((log2(select((scaled_in.x < 1.52587890625e-05f), ((scaled_in.x * 0.5f) + 1.52587890625e-05f), scaled_in.x)) + LUT_LOG2_OFFSET) * LUT_LOG2_SCALE), ((log2(select((scaled_in.z < 1.52587890625e-05f), ((scaled_in.z * 0.5f) + 1.52587890625e-05f), scaled_in.z)) + LUT_LOG2_OFFSET) * LUT_LOG2_SCALE), ((log2(select((scaled_in.y < 1.52587890625e-05f), ((scaled_in.y * 0.5f) + 1.52587890625e-05f), scaled_in.y)) + LUT_LOG2_OFFSET) * LUT_LOG2_SCALE)), 0.0f).xyz;
  float luma = dot(lut, float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  return float3(min(exp2((max((lerp(luma, lut.x, saturation)), -0.301369845867157f) * 17.520000457763672f) + -LUT_LOG2_OFFSET), 65504.0f), min(exp2((max((lerp(luma, lut.y, saturation)), -0.301369845867157f) * 17.520000457763672f) + -LUT_LOG2_OFFSET), 65504.0f), min(exp2((max((lerp(luma, lut.z, saturation)), -0.301369845867157f) * 17.520000457763672f) + -LUT_LOG2_OFFSET), 65504.0f)) / scale;
}

[numthreads(16, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _53;
  float _54;
  float _55;
  if ((bool)((uint)(uint)(SV_DispatchThreadID.x) < (uint)g_vScreenSize.x) && (bool)((uint)(uint)(SV_DispatchThreadID.y) < (uint)g_vScreenSize.y)) {
    float4 _16 = mapInput.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
    float4 _30 = mapSaturationMask.SampleLevel(MaterialSamplers[1u], float2((float((uint)SV_DispatchThreadID.x) / float((uint)(int)(g_vScreenSize.x))), (float((uint)SV_DispatchThreadID.y) / float((uint)(int)(g_vScreenSize.y)))), 0.0f);
    float _38 = (float((bool)(bool)(_30.x > 0.0f)) * (1.0f - g_fSaturation)) + g_fSaturation;
    if (g_inputIsToneMapped != 0) {
      float _48 = max(9.999999747378752e-05f, (1.0f - dot(float3(0.33329999446868896f, 0.33329999446868896f, 0.33329999446868896f), float3(_16.x, _16.y, _16.z))));
      _53 = ((_16.x * 0.5f) / _48);
      _54 = ((_16.y * 0.5f) / _48);
      _55 = ((_16.z * 0.5f) / _48);
    } else {
      _53 = _16.x;
      _54 = _16.y;
      _55 = _16.z;
    }
    float _58 = mad(0.04575581103563309f, _55, mad(0.3411155045032501f, _54, (_53 * 0.6130499243736267f)));
    float _61 = mad(0.011935809627175331f, _55, mad(0.9180729389190674f, _54, (_53 * 0.07000420987606049f)));
    float _64 = mad(0.8729248642921448f, _55, mad(0.10678841918706894f, _54, (_53 * 0.02049521915614605f)));
    float3 lut_in = float3(_58, _61, _64);
    bool renodx_path = RENODX_PEAK_WHITE_NITS > 0.f && RENODX_TONE_MAP_TYPE != 0.f && RENODX_HDR_OUTPUT != 0.f;
    if (renodx_path) {
      lut_in = max(lut_in, 0.f);
    }
    float3 graded;
    if (renodx_path) {
      float y_in = max(lut_in.r, max(lut_in.g, lut_in.b));
      graded = SampleGradedLUT(lut_in, _38, y_in > LUT_CEIL ? LUT_CEIL / y_in : 1.f);
    } else {
      graded = SampleGradedLUT(lut_in, _38, 1.f);
    }
    uavOutput[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(graded, _16.w);
  }
}
