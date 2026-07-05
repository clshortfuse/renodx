#include "./shared.h"
#include "./psychov_test22.hlsli"

float3 ApplyDisplayMap(float3 untonemapped) {
  const float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  float3 tonemapped_bt709 = renodx::tonemap::psychov::psychotm_test22(
    untonemapped,                                          // bt709_linear_input
    peak_ratio,                                            // peak_value
    RENODX_TONE_MAP_EXPOSURE,                              // exposure
    RENODX_TONE_MAP_HIGHLIGHTS,                            // highlights
    RENODX_TONE_MAP_SHADOWS,                               // shadows
    RENODX_TONE_MAP_CONTRAST,                              // contrast
    RENODX_TONE_MAP_SATURATION,                            // purity_scale
    1.f,                                                   // bleaching_intensity
    100.f,                                                 // clip_point
    RENODX_TONE_MAP_HUE_RESTORE,                           // hue_restore
    1.f,                                                   // adaptation_contrast
    0,                                                     // white_curve_mode
    RENODX_TONE_MAP_CONE_RESPONSE,                         // cone_response_exponent
    0.18f.xxx,                                             // current_adaptive_state_bt709
    0.18f.xxx,                                             // current_background_state_bt709
    1.f,                                                   // gamut_compression
    1,                                                     // gamut_compression_mode
    1.f,                                                   // adaptive_normalization
    0.f);                                                  // compression

  return tonemapped_bt709;
}

float3 DisplayMap(float3 hdr_color, float3 hdr_color_tm, float3 sdr_color) {
  float3 output_color;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    output_color = saturate(sdr_color);
  } else {
	  float3 inverse_color = (sdr_color / hdr_color_tm);
	  float3 lerp_color = lerp(hdr_color, inverse_color, saturate(RENODX_COLOR_GRADE_STRENGTH));
	  output_color = ApplyDisplayMap(lerp_color);
  }
  return output_color;
}

float3 FilmGrain(float3 output_color, float2 texcoord, float2 grain_offset) {
  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    output_color = renodx::effects::ApplyFilmGrain(
        output_color,
        texcoord + grain_offset * 0.25f,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
        1.f);
  }
  return output_color;
}

float3 LutWhiteClip(float3 output_color, float3 lut_output, sampler2D lut_texture) {
  float min_uv = 0.0078125f;
  float max_uv = 0.9921875f;
  float3 a = tex2D(lut_texture, float2(min_uv, min_uv)).rgb;
  float3 b = tex2D(lut_texture, float2(max_uv, max_uv)).rgb;
  float3 c = tex2D(lut_texture, float2(0.5f, 0.5f)).rgb;

  float3 d = abs(a - b);
  float max_delta = max(d.r, max(d.g, d.b));
  float uniform_fade = 1.0f - smoothstep(0.0f, 0.01f, max_delta);

  float3 min_v = min(a, min(b, c));
  float min_white = min(min_v.r, min(min_v.g, min_v.b));
  float white_fade = smoothstep(0.98f, 1.0f, min_white);

  float fade_amount = uniform_fade * white_fade;
  float3 original_output = saturate(lut_output);

  return lerp(output_color, original_output, fade_amount);
}
