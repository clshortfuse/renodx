#include "../shared.h"

Texture2D<float4> HDRImage : register(t0);

SamplerState BilinearClamp : register(s5, space32);

#define WHITE_SCALE     (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS)
#define INV_WHITE_SCALE (1.f / WHITE_SCALE)

float4 FxaaSampleScaled(float2 uv) {
  float4 sample = HDRImage.SampleLevel(BilinearClamp, uv, 0.0f);
  sample.rgb *= INV_WHITE_SCALE;
  return sample;
}

float4 FxaaSampleScaled(float2 uv, int2 offset) {
  float4 sample = HDRImage.SampleLevel(BilinearClamp, uv, 0.0f, offset);
  sample.rgb *= INV_WHITE_SCALE;
  return sample;
}

float4 FxaaGatherGreenScaled(float2 uv) {
  return HDRImage.GatherGreen(BilinearClamp, uv) * INV_WHITE_SCALE;
}
