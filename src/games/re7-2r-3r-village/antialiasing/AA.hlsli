#include "../common.hlsli"

#define WHITE_SCALE     ((RENODX_TONE_MAP_TYPE == 0.f) ? 1.f : (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS))
#define INV_WHITE_SCALE (1.f / WHITE_SCALE)

float4 FxaaSampleScaled(Texture2D<float4> HDRImage, SamplerState BilinearClamp, float2 uv) {
  float4 sample = HDRImage.SampleLevel(BilinearClamp, uv, 0.0f);
  sample.rgb *= INV_WHITE_SCALE;
  return sample;
}

float4 FxaaSampleScaled(Texture2D<float4> HDRImage, SamplerState BilinearClamp, float2 uv, int2 offset) {
  float4 sample = HDRImage.SampleLevel(BilinearClamp, uv, 0.0f, offset);
  sample.rgb *= INV_WHITE_SCALE;
  return sample;
}

float4 FxaaGatherGreenScaled(Texture2D<float4> HDRImage, SamplerState BilinearClamp, float2 uv) {
  return HDRImage.GatherGreen(BilinearClamp, uv) * INV_WHITE_SCALE;
}
