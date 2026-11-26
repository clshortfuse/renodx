// DOF Apply_CS: composites the half-res hex DOF result over the full-res scene -> R11G11B10F.

#include "./shared.h"

Texture2D<float4> mapInput : register(t0);

Texture2D<float4> mapCoC : register(t1);

Texture2D<float> mapDepth : register(t2);

Texture2D<float> mapTransparencyDepth : register(t3);

RWTexture2D<float4> uavOutput : register(u0);

cbuffer _Apply : register(b0) {
  uint2 g_vViewportSize : packoffset(c000.x);
  float g_fCoCThreshold : packoffset(c000.z);
  float fPadding0 : packoffset(c000.w);
  float4 g_vCoCParams : packoffset(c001.x);
  float4 g_vBlurriness : packoffset(c002.x);
  float4 g_vViewRemap : packoffset(c003.x);
  float4 g_vUvScale : packoffset(c004.x);
};

SamplerState MaterialSamplers[1920] : register(s0);

// CUSTOM: cubic B-spline upscale of the half-res DOF result from 4 bilinear taps.
// Removes the 2x2 stair pattern of a plain bilinear half-res upscale.
float4 SampleCubicBSpline(Texture2D<float4> tex, SamplerState samp, float2 uv) {
  uint width, height;
  tex.GetDimensions(width, height);
  float2 size = float2(width, height);
  float2 texel = uv * size - 0.5f;
  float2 base = floor(texel);
  float2 t = texel - base;
  float2 t2 = t * t;
  float2 t3 = t2 * t;
  float2 w0 = (-t3 + 3.0f * t2 - 3.0f * t + 1.0f) / 6.0f;
  float2 w1 = (3.0f * t3 - 6.0f * t2 + 4.0f) / 6.0f;
  float2 w2 = (-3.0f * t3 + 3.0f * t2 + 3.0f * t + 1.0f) / 6.0f;
  float2 w3 = t3 / 6.0f;
  float2 g0 = w0 + w1;
  float2 g1 = w2 + w3;
  float2 uv0 = (base - 1.0f + w1 / g0 + 0.5f) / size;
  float2 uv1 = (base + 1.0f + w3 / g1 + 0.5f) / size;
  return tex.SampleLevel(samp, float2(uv0.x, uv0.y), 0.0f) * (g0.x * g0.y)
       + tex.SampleLevel(samp, float2(uv1.x, uv0.y), 0.0f) * (g1.x * g0.y)
       + tex.SampleLevel(samp, float2(uv0.x, uv1.y), 0.0f) * (g0.x * g1.y)
       + tex.SampleLevel(samp, float2(uv1.x, uv1.y), 0.0f) * (g1.x * g1.y);
}

// CUSTOM: PCG hash mapped to [0,1). Used as the uniform source for dither noise.
float PcgUnit(uint seed) {
  uint state = seed * 747796405u + 2891336453u;
  uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
  return float((word >> 22u) ^ word) * (1.0f / 4294967296.0f);
}

// CUSTOM: TPDF dither of +/-1 quantization step for R11G11B10 output. Removes banding in blurred gradients.
float TpdfDither(float v, uint pixelSeed, uint channel, float mantissaBits) {
  uint seed = (pixelSeed * 3u + channel) * 2u;
  float noise = PcgUnit(seed) + PcgUnit(seed + 1u) - 1.0f;
  float step = exp2(floor(log2(max(v, 6.1e-5f))) - mantissaBits);
  return max(v + noise * step, 0.0f);
}

[numthreads(16, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  if ((bool)((uint)(uint)(SV_DispatchThreadID.x) < (uint)g_vViewportSize.x) && (bool)((uint)(uint)(SV_DispatchThreadID.y) < (uint)g_vViewportSize.y)) {
    float _19 = float((uint)SV_DispatchThreadID.x) + 0.5f;
    float _20 = float((uint)SV_DispatchThreadID.y) + 0.5f;
    float _26 = _19 / float((uint)(int)(g_vViewportSize.x));
    float _27 = _20 / float((uint)(int)(g_vViewportSize.y));
    float _29 = mapDepth.SampleLevel(MaterialSamplers[6u], float2(_26, _27), 0.0f);
    float _39 = mapTransparencyDepth.SampleLevel(MaterialSamplers[6u], float2(_26, _27), 0.0f);
    float _41 = min(((-0.0f - g_vViewRemap.x) / ((g_vViewRemap.z * _29.x) - g_vViewRemap.y)), _39.x);
    float _50 = _41 - g_vCoCParams.x;
    float _60 = saturate((max((-0.0f - _50), 0.0f) - g_vCoCParams.y) * g_vCoCParams.z) * g_vBlurriness.x;
    float _61 = saturate((max(_50, 0.0f) - g_vCoCParams.y) * g_vCoCParams.w) * g_vBlurriness.x;
    float2 _coCUv = float2((g_vUvScale.x * _19), (g_vUvScale.y * _20));
    float4 _70 = RENODX_DOF_UPSCALE >= 0.5f ? SampleCubicBSpline(mapCoC, MaterialSamplers[11u], _coCUv) : mapCoC.SampleLevel(MaterialSamplers[11u], _coCUv, 0.0f);
    float4 _75 = mapInput.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
    float _84 = saturate(max(_70.w, select((_41 < 0.0f), -1.5f, ((select((_60 > _61), (-0.0f - _60), _61) + -0.15000000596046448f) * 10.0f))));
    float4 _composite = float4(((_84 * (_70.x - _75.x)) + _75.x), ((_84 * (_70.y - _75.y)) + _75.y), ((_84 * (_70.z - _75.z)) + _75.z), _75.w);
    if (RENODX_DOF_DITHER >= 0.5f) {
      uint pixelSeed = SV_DispatchThreadID.x + SV_DispatchThreadID.y * g_vViewportSize.x;
      // CUSTOM: R11G11B10 has 6 mantissa bits for R/G and 5 for B; dither one step per channel.
      _composite.x = TpdfDither(_composite.x, pixelSeed, 0u, 6.0f);
      _composite.y = TpdfDither(_composite.y, pixelSeed, 1u, 6.0f);
      _composite.z = TpdfDither(_composite.z, pixelSeed, 2u, 5.0f);
    }
    uavOutput[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = _composite;
  }
}
