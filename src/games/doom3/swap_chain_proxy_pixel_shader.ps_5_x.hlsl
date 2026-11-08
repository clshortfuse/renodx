#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);

float3 SanitizeSceneColor(float3 color) {
  // PsychoV30 intentionally trusts its signal and uniforms.  Doom 3 can
  // generate invalid values around legacy pow/specular paths, so clean the
  // scene once at the scene-final boundary rather than changing per-light math.
  color.r = (isnan(color.r) || isinf(color.r)) ? 0.f : color.r;
  color.g = (isnan(color.g) || isinf(color.g)) ? 0.f : color.g;
  color.b = (isnan(color.b) || isinf(color.b)) ? 0.f : color.b;
  return clamp(color, 0.f, 65504.f);
}

float3 ApplyPsychoV30(float3 color, renodx::draw::Config config) {
  // Test30's signal contract is direct linear-light BT.709, reference-white
  // relative.  At this point Doom 3's legacy gamma-domain composite has
  // already been decoded to linear light below.
  const float game_nits = max(config.diffuse_white_nits, 1.f);
  const float peak_ratio = max(config.peak_white_nits / game_nits, 1.f);

  // Keep user-exposed parameters inside Test30's valid numeric domain.
  const float psycho_contrast = max(config.tone_map_contrast, 1e-4f);
  const float psycho_cone_response = max(RENODX_PSYCHOV30_CONE_RESPONSE, 1e-4f);

  color = renodx::tonemap::psychov::psychotm_test30(
      color,
      peak_ratio,
      config.tone_map_exposure,
      config.tone_map_highlights,
      config.tone_map_shadows,
      psycho_contrast,
      RENODX_PSYCHOV30_PURITY_SCALE,
      1.f,                                  // bleaching_intensity: compatibility placeholder
      100.f,                                // clip_point: compatibility placeholder
      1.f,                                  // hue_restore: compatibility placeholder
      1.f,                                  // encoded_response_power: compatibility placeholder
      0,                                    // white_curve_mode: compatibility placeholder
      psycho_cone_response,
      float3(0.18f, 0.18f, 0.18f),          // current_adaptive_state_bt709
      float3(0.18f, 0.18f, 0.18f),          // current_background_state_bt709
      RENODX_PSYCHOV30_GAMUT_COMPRESSION,
      RENODX_PSYCHOV30_GAMUT_MODE,
      1.f,                                  // adaptive_normalization: compatibility placeholder
      RENODX_PSYCHOV30_COMPRESSION,
      RENODX_PSYCHOV30_SOURCE_BOUNDARY);

  // Test30 owns tone/contrast/purity/gamut mapping. Keep the existing general
  // saturation slider useful without running the RenoDRT grading path twice.
  if (config.tone_map_saturation != 1.f) {
    color = renodx::color::grade::Saturation(color, config.tone_map_saturation);
  }

  return SanitizeSceneColor(color);
}

float4 main(float4 vpos : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET {
  // Used for OpenGL support.
  uv.y = lerp(uv.y, 1.0 - uv.y, shader_injection.custom_flip_uv_y);

  float3 color = SanitizeSceneColor(t0.Sample(s0, uv).rgb);

  if (shader_injection.tone_map_type == 0.f) {
    // A/B path: keep the preserved FP16 scene but skip the custom forward map.
    return float4(renodx::draw::SwapChainPass(color), 1.f);
  }

  // Doom 3/dhewm3's ARB programs write a legacy gamma-domain signal. The
  // external ARB replacements remove the upper clamp but intentionally keep
  // the original gamma tail. Decode once here before either HDR tone mapper.
  color = renodx::color::gamma::DecodeSafe(max(color, 0.f), 2.2f);
  color = SanitizeSceneColor(color);

  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.gamma_correction = 0.f;  // Already decoded above.

  [branch]
  if (shader_injection.custom_scene_tone_mapped != 0.f) {
    // The OpenGL pre-UI pass already tone mapped the 3D scene before Doom 3
    // drew its HUD/menus, and stored it relative to UI white. Only display
    // scaling remains, so the UI lands at UI Brightness without tone mapping.
    config.swap_chain_scaling_nits = config.graphics_white_nits;
  } else {
    [branch]
    if (shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_PSYCHOV30) {
      color = ApplyPsychoV30(color, config);
    } else {
      // RenoDRT path. This is forward mapping of the preserved scene signal, not
      // inverse tonemapping of a completed/clamped SDR image.
      color = renodx::draw::ToneMapPass(color, config);
      color = SanitizeSceneColor(color);
    }
    // The result is linear BT.709 relative to game/reference white.
    config.swap_chain_scaling_nits = config.diffuse_white_nits;
  }

  // Keep the final proxy limited to display encoding/scaling.
  config.swap_chain_decoding = renodx::draw::ENCODING_NONE;
  config.swap_chain_gamma_correction = 0.f;
  config.swap_chain_decoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
  return float4(renodx::draw::SwapChainPass(color, uv, config), 1.f);
}
