#include "./shared.h"

cbuffer cbEngine : register(b0) {
  float4 cbEngine_data[204];
};

cbuffer cbObjectDynamic : register(b3) {
  float4 g_SharpenParams;
  float4 g_SharpenDistances;
  float4 g_GrainParams;
  float4 g_GrainTransform;
};

SamplerState g_Sampler_PointClamp : register(s0);
SamplerState g_Sampler_LinearClamp : register(s1);

Texture2D<float4> g_finalDepth : register(t140);
Texture2D<float4> g_Background : register(t0);
Texture2D<float4> g_BackgroundBlur : register(t1);
Texture2D<uint> g_TextureUint : register(t2);  // R10G10B10A2 packed from finalCompositing
Texture2D<float4> g_TextureUI : register(t3);
Texture2D<float4> g_TextureWorldUI : register(t4);
Texture2D<float4> g_TextureGrainRandom : register(t5);

RWTexture2D<float4> g_OutputRW : register(u0);

// Unpack R10G10B10A2 uint to float3
float3 UnpackR10G10B10A2(uint packed) {
  float r = float(packed & 0x3FF) / 1023.0f;
  float g = float((packed >> 10) & 0x3FF) / 1023.0f;
  float b = float((packed >> 20) & 0x3FF) / 1023.0f;
  return float3(r, g, b);
}

[numthreads(8, 4, 1)]
void main(uint3 dtid : SV_DispatchThreadID) {
  uint width, height;
  g_OutputRW.GetDimensions(width, height);
  if (dtid.x >= width || dtid.y >= height) return;

  float2 uv = (float2(dtid.xy) + 0.5f) / float2(width, height);

  // Read scene from the output UAV (read-modify-write pattern)
  // finalCompositing may write to the same resource bound as our u0
  float4 scene_raw = g_OutputRW[dtid.xy];
  float3 scene = scene_raw.rgb;

  // Composite world UI
  float4 world_ui = g_TextureWorldUI.SampleLevel(g_Sampler_PointClamp, uv, 0);
  scene = lerp(scene, world_ui.rgb, world_ui.a);

  // Composite screen UI
  float4 ui = g_TextureUI.SampleLevel(g_Sampler_PointClamp, uv, 0);
  scene = lerp(scene, ui.rgb, ui.a);

  g_OutputRW[dtid.xy] = float4(scene, 1.0f);
}
