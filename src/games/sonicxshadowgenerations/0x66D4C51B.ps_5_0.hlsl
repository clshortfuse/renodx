#include "./tonemap.hlsli"

SamplerState scene_sampler : register(s0);
Texture2D<float4> scene_texture : register(t0);
SamplerState lut_sampler : register(s1);
Texture2D<float4> lut_texture : register(t1);

float4 main(float4 position : SV_POSITION, float3 uv_exposure : TEXCOORD0) : SV_TARGET {
  float4 scene = clamp(scene_texture.Sample(scene_sampler, uv_exposure.xy), 0.f, 65504.f);
  float3 source = scene.rgb * uv_exposure.z;
  renodx::draw::Config config = renodx::draw::BuildConfig();
  float3 vanilla = VanillaToneMap(source);

  float3 e = saturate(renodx::color::srgb::Encode(vanilla));
  float3 graded = renodx::color::srgb::Decode(
      lerp(e, SampleGradingLut(lut_texture, lut_sampler, e), saturate(u_color_grading_factor.y)));

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return float4(renodx::draw::RenderIntermediatePass(graded, config), scene.a);  // RenoDX: Vanilla path
  }

  float3 upgraded = renodx::tonemap::UpgradeToneMap(ApplySceneToneMap(source, config), vanilla, graded, 1.f);
  return float4(renodx::draw::RenderIntermediatePass(upgraded, config), scene.a);
}
