#include "./shared.h"

Texture2D<float4> g_Texture : register(t0);
SamplerState g_Sampler_LinearClamp : register(s1);

void main(
    float4 pos : SV_Position,
    float2 uv : TEXCOORD0,
    out float4 output : SV_Target0) {
  float3 color = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv, 0).rgb;

  if (shader_injection.tone_map_type == 0) {
    // Vanilla: just output as-is
    output = float4(color, 1.0f);
    return;
  }

  // Decode gamma to linear
  float3 linear_color = renodx::color::srgb::DecodeSafe(color);

  // Color temperature
  float temp = shader_injection.custom_color_temp;
  linear_color.r *= 1.0f + temp * 0.3f;
  linear_color.b *= 1.0f - temp * 0.3f;

  // Shadow lift
  float lift = shader_injection.custom_shadow_lift;
  linear_color += lift * 0.02f;
  linear_color = max(0, linear_color);

  // Highlight expansion: extend the [0,1] tonemapped range into HDR
  // Use RenoDX extended tonemap - feed the linear SDR values through
  // with peak_nits > game_nits to expand highlights
  // The key: treat the input as if game_nits = 80 (SDR)
  // and let RenoDRT/ACES expand to peak_nits
  // Scale input to give RenoDRT headroom for expansion
  // The game's ACES compressed everything to [0,1]. We stretch it back out
  // so highlights have room to expand into HDR.
  float expansion = shader_injection.peak_white_nits / 80.f;
  linear_color *= expansion;

  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = shader_injection.tone_map_type;
  config.peak_nits = shader_injection.peak_white_nits;
  config.game_nits = 80.f;  // Treat input 1.0 as 80 nits for more expansion headroom
  config.gamma_correction = shader_injection.gamma_correction;
  config.exposure = shader_injection.tone_map_exposure;
  config.highlights = shader_injection.tone_map_highlights;
  config.shadows = shader_injection.tone_map_shadows;
  config.contrast = shader_injection.tone_map_contrast;
  config.saturation = shader_injection.tone_map_saturation;
  config.mid_gray_value = 0.18f;
  config.mid_gray_nits = 0.18f * 80.f;
  config.reno_drt_saturation = shader_injection.tone_map_highlight_saturation;
  config.reno_drt_dechroma = shader_injection.tone_map_blowout;
  config.reno_drt_flare = shader_injection.tone_map_flare;
  config.hue_correction_strength = shader_injection.tone_map_hue_correction;
  config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_color = linear_color;
  config.reno_drt_per_channel = (shader_injection.tone_map_per_channel != 0);
  config.reno_drt_tone_map_method = RENODX_RENO_DRT_TONE_MAP_METHOD;
  config.reno_drt_hue_correction_method = shader_injection.tone_map_hue_processor;
  config.reno_drt_working_color_space = shader_injection.tone_map_working_color_space;

  float3 result = renodx::tonemap::config::Apply(linear_color, config);

  // Boost to fill display peak (RenoDRT compresses conservatively)
  result *= shader_injection.peak_white_nits / 543.f;

  output = float4(result, 1.0f);
}
