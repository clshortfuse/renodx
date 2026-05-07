#include "./shared.h"

Texture2D<float4> g_Texture : register(t0);
SamplerState g_Sampler_LinearClamp : register(s1);

// Inverse ACES filmic tonemap
float3 ACESFilmicInverse(float3 x) {
  const float a = 2.51f;
  const float b = 0.03f;
  const float c = 2.43f;
  const float d = 0.59f;
  const float e = 0.14f;

  float3 A = a - c * x;
  float3 B = b - d * x;
  float3 C = -e * x;

  float3 discriminant = B * B - 4.0f * A * C;
  discriminant = max(0, discriminant);

  float3 result = (-B + sqrt(discriminant)) / (2.0f * A);
  return max(0, result);
}

void main(
    float4 pos : SV_Position,
    float2 uv : TEXCOORD0,
    out float4 output : SV_Target0) {
  float3 color = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv, 0).rgb;

  if (shader_injection.tone_map_type == 0) {
    // Vanilla: decode gamma and output at SDR white
    float3 linear_color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    output = float4(linear_color, 1.0f);
    return;
  }

  // HDR: decode gamma, inverse tonemap, apply RenoDRT
  float3 linear_color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  float3 hdr_color = ACESFilmicInverse(linear_color);

  // RenoDRT with low game_nits so it doesn't compress as hard
  // The ACES inverse gives values 0-5 for typical scenes.
  // Setting game_nits=80 means value 1.0 = 80 nits (SDR white)
  // The sun at ~5.0 = 400 nits, which is closer to peak.
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = shader_injection.tone_map_type;
  config.peak_nits = shader_injection.peak_white_nits;
  config.game_nits = 80.f;  // Treat 1.0 as 80 nits so highlights have more room
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

  float3 tonemapped = renodx::tonemap::config::Apply(hdr_color, config);

  output = float4(tonemapped, 1.0f);
}
