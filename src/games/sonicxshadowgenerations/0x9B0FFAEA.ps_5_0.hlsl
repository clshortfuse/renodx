#include "./shared.h"
#include "../../shaders/tonemap/psychov/test17.hlsl"

SamplerState scene_sampler : register(s0);
Texture2D<float4> scene_texture : register(t0);

float4 main(float4 position : SV_POSITION, float3 uv_exposure : TEXCOORD0) : SV_TARGET {
  float4 scene = clamp(scene_texture.Sample(scene_sampler, uv_exposure.xy), 0.f, 65504.f);
  float3 source = scene.rgb * uv_exposure.z;
  // Compensate for the fixed 2.2 correction in RenderIntermediatePass.
  float peak = renodx::color::correct::GammaSafe(
      RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, true, 2.2f);

  float3 mapped = renodx::tonemap::psychov::psychotm_test17(
      source, peak, RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS, RENODX_TONE_MAP_CONTRAST, RENODX_TONE_MAP_SATURATION,
      0.f, 100.f, 0.f);

  // At high cone drive PsychoV approaches white in all three channels.
  // Retain source chroma in the shoulder by trading luminance for gamut room.
  float3 source_display = renodx::color::bt2020::from::BT709(source);
  float3 mapped_display = renodx::color::bt2020::from::BT709(mapped);
  float source_display_max = max(source_display.r, max(source_display.g, source_display.b));
  float mapped_display_max = max(mapped_display.r, max(mapped_display.g, mapped_display.b));
  float source_drive = source_display_max * RENODX_TONE_MAP_EXPOSURE / peak;
  float chroma_weight = shader_injection.tone_map_highlight_saturation * smoothstep(2.f, 16.f, source_drive)
                      * smoothstep(0.8f, 1.f, mapped_display_max / peak);
  float3 highlight_reference = source_display * renodx::math::DivideSafe(mapped_display_max, source_display_max, 0.f);
  mapped = renodx::color::bt709::from::BT2020(lerp(mapped_display, highlight_reference, chroma_weight));

  if (RENODX_TONE_MAP_HUE_CORRECTION > 0.f) {
    float source_max = max(source.r, max(source.g, source.b));
    float source_min = min(source.r, min(source.g, source.b));
    float mapped_max = max(mapped.r, max(mapped.g, mapped.b));
    float mapped_min = min(mapped.r, min(mapped.g, mapped.b));
    if (source_max - source_min > max(1e-6f, source_max * 1e-4f)
        && mapped_max - mapped_min > max(1e-6f, mapped_max * 1e-4f)) {
      // Compare hue at comparable luminance for the perceptual conversions.
      float reference_scale = renodx::math::DivideSafe(
          renodx::color::y::from::BT709(mapped), renodx::color::y::from::BT709(source), 1.f);
      mapped = renodx::color::correct::Hue(mapped, source * reference_scale,
                                          RENODX_TONE_MAP_HUE_CORRECTION,
                                          (int)RENODX_TONE_MAP_HUE_PROCESSOR);
    }
  }
  float3 display = renodx::color::bt2020::from::BT709(mapped);
  display = renodx::color::correct::GamutCompress(display, max(0.f, renodx::color::y::from::BT2020(display)));
  float display_max = max(display.r, max(display.g, display.b));
  display *= peak / max(peak, display_max);
  return float4(renodx::draw::RenderIntermediatePass(renodx::color::bt709::from::BT2020(display)), scene.a);
}
