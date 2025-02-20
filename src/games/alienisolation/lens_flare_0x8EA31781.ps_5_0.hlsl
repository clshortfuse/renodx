#include "./shared.h"

SamplerState g_flare_sampler : register(s0);
Texture2D<float4> g_flare_texture : register(t0);

void main(
    float4 tex_coords: TEXCOORD0,
    float4 flare_intensity: TEXCOORD1,
    float4 v2: SV_Position0,
    out float4 output_color: SV_Target0) {
#if CUSTOM_LENS_FLARE  // reduces size of black artifact in center of lens flare
  flare_intensity = saturate(flare_intensity);
#endif

  float falloff;
  const float base_falloff_offset = 0.09;

  // Calculate the scale factor based on distance from the center of the flare.
  falloff = dot(tex_coords.zw, tex_coords.zw);
  falloff = base_falloff_offset / (base_falloff_offset + falloff);
  falloff *= falloff;
  float3 scaled_intensity = flare_intensity.xyz * falloff;

  float3 flare_texture = g_flare_texture.SampleLevel(g_flare_sampler, tex_coords.xy, 0).rgb;
  output_color.rgb = flare_texture * scaled_intensity;
  output_color.a = 1;

  // we linearize as it draws directly onto the swapchain after tonemapping
  output_color.rgb = saturate(output_color.rgb);
  output_color.rgb = renodx::color::gamma::Decode(output_color.rgb, 2.2f);
  output_color.rgb *= injectedData.fxLensFlare;
  return;
}
