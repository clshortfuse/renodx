#include "./shared.h"
#include "../../shaders/tonemap/psychov/test35.hlsl"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);

float3 SanitizeSceneColor(float3 color) {
  // PsychoV35 intentionally trusts its signal and uniforms.  Doom 3 can
  // generate invalid values around legacy pow/specular paths, so clean the
  // scene once at the scene-final boundary rather than changing per-light math.
  color.r = (isnan(color.r) || isinf(color.r)) ? 0.f : color.r;
  color.g = (isnan(color.g) || isinf(color.g)) ? 0.f : color.g;
  color.b = (isnan(color.b) || isinf(color.b)) ? 0.f : color.b;
  return clamp(color, 0.f, 65504.f);
}

float3 ApplyPsychoV35(float3 color, renodx::draw::Config config) {
  // Test35's signal contract is direct linear-light BT.709, reference-white
  // relative.  At this point Doom 3's legacy gamma-domain composite has
  // already been decoded to linear light below.
  const float game_nits = max(config.diffuse_white_nits, 1.f);
  const float peak_ratio = max(config.peak_white_nits / game_nits, 1.f);

  // Keep user-exposed parameters inside Test35's valid numeric domain.
  const float psycho_contrast = max(config.tone_map_contrast, 1e-4f);
  const float psycho_cone_response = max(RENODX_PSYCHOV35_CONE_RESPONSE, 1e-4f);

  color = renodx::tonemap::psychov::psychotm_test35(
      color,
      peak_ratio,
      config.tone_map_exposure,
      config.tone_map_highlights,
      config.tone_map_shadows,
      psycho_contrast,
      RENODX_PSYCHOV35_PURITY_SCALE,
      1.f,                                  // bleaching_intensity: compatibility placeholder
      100.f,                                // clip_point: compatibility placeholder
      1.f,                                  // hue_restore: compatibility placeholder
      1.f,                                  // encoded_response_power: compatibility placeholder
      0,                                    // white_curve_mode: compatibility placeholder
      psycho_cone_response,
      float3(0.18f, 0.18f, 0.18f),          // current_adaptive_state_bt709
      float3(0.18f, 0.18f, 0.18f),          // current_background_state_bt709
      RENODX_PSYCHOV35_GAMUT_COMPRESSION,
      RENODX_PSYCHOV35_GAMUT_MODE,
      1.f,                                  // adaptive_normalization: compatibility placeholder
      RENODX_PSYCHOV35_COMPRESSION,
      RENODX_PSYCHOV35_SOURCE_BOUNDARY);

  // Test35 owns tone/contrast/purity/gamut mapping. Keep the existing general
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
    const float3 scene_color = color;
    // Match the pre-UI path when the scene is tone mapped here instead.
    // Scale only above-white scene light, before either forward tone mapper.
    const float scene_y = renodx::color::y::from::BT709(color);
    const float highlight_weight = (scene_y > 1.f ? 1.f - 1.f / scene_y : 0.f);
    if (scene_y > 1.f) {
      color *= 1.f + (max(config.peak_white_nits / max(config.diffuse_white_nits, 1.f), 1.f) - 1.f)
                        * highlight_weight * highlight_weight;
      color = SanitizeSceneColor(color);
    }
    [branch]
    if (shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_PSYCHOV35) {
      color = ApplyPsychoV35(color, config);
    } else {
      // RenoDRT path. This is forward mapping of the preserved scene signal, not
      // inverse tonemapping of a completed/clamped SDR image.
      config.tone_map_clamp_peak = renodx::color::convert::COLOR_SPACE_BT709;
      color = renodx::draw::ToneMapPass(color, config);
      color = SanitizeSceneColor(color);
    }
    if (highlight_weight > 0.f && config.peak_white_nits > config.diffuse_white_nits) {
      // Keep the scene's SDR color ratios as its highlights brighten. Match
      // the mapped channel peak, rather than forcing saturated colors white.
      const float target_space = (shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_PSYCHOV35
                                      && RENODX_PSYCHOV35_GAMUT_MODE != 0
                                  ? renodx::color::convert::COLOR_SPACE_BT2020
                                  : renodx::color::convert::COLOR_SPACE_BT709);
      float3 reference = scene_color;
      if (config.tone_map_saturation != 1.f) {
        reference = renodx::color::grade::Saturation(reference, config.tone_map_saturation);
      }
      reference = max(renodx::color::convert::ColorSpaces(reference, renodx::color::convert::COLOR_SPACE_BT709, target_space), 0.f);
      float3 mapped = max(renodx::color::convert::ColorSpaces(color, renodx::color::convert::COLOR_SPACE_BT709, target_space), 0.f);
      const float mapped_peak = max(mapped.r, max(mapped.g, mapped.b));
      const float bounded_peak = min(mapped_peak, config.peak_white_nits / max(config.diffuse_white_nits, 1.f));
      mapped *= bounded_peak / max(mapped_peak, 1e-6f);
      reference *= bounded_peak / max(max(reference.r, max(reference.g, reference.b)), 1e-6f);
      color = renodx::color::convert::ColorSpaces(
          lerp(mapped, reference, highlight_weight * highlight_weight),
          target_space, renodx::color::convert::COLOR_SPACE_BT709);
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
