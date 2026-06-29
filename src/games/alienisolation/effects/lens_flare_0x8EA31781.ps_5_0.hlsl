#include "../shared.h"

SamplerState g_flare_sampler : register(s0);
Texture2D<float4> g_flare_texture : register(t0);

void main(
    float4 tex_coords: TEXCOORD0,
    float4 flare_intensity: TEXCOORD1,
    float4 v2: SV_Position0,
    out float4 output_color: SV_Target0) {
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

  output_color.rgb *= CUSTOM_LENS_FLARE;

  // uses INV_DEST_COLOR blending
#if HDR_LENS_FLARE
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_color.rgb = saturate(output_color.rgb);
    float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (peak_ratio > 1.f) {
      float inv_peak_ratio = 1.f / peak_ratio;
      float3 compressed = renodx::tonemap::neutwo::PerChannel(output_color.rgb, inv_peak_ratio, 1.f);
      output_color.rgb = renodx::color::gamma::Encode(max(0, renodx::color::correct::Hue(renodx::color::gamma::Decode(compressed),
                                                                                         renodx::color::gamma::Decode(output_color.rgb))));
      output_color.rgb = min(output_color.rgb, inv_peak_ratio);
    }
  }
#endif

  return;
}
