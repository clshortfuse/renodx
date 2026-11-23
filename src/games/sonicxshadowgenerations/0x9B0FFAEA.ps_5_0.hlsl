#include "./tonemap.hlsli"

SamplerState scene_sampler : register(s0);
Texture2D<float4> scene_texture : register(t0);

float4 main(float4 position : SV_POSITION, float3 uv_exposure : TEXCOORD0) : SV_TARGET {
  float4 scene = clamp(scene_texture.Sample(scene_sampler, uv_exposure.xy), 0.f, 65504.f);
  float3 source = scene.rgb * uv_exposure.z;
  renodx::draw::Config config = renodx::draw::BuildConfig();
  float3 tonemapped;
  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    tonemapped = VanillaToneMap(source);  // RenoDX: Vanilla tone map
  } else {
    tonemapped = ApplySceneToneMap(source, config);
  }
  return float4(renodx::draw::RenderIntermediatePass(tonemapped, config), scene.a);
}
