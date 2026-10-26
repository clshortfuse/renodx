// Composite (0x83A4F799): the last draw of the 3D scene in normal view; night vision runs after it.
// The game adds the 8-bit bloom to the RGBA16F scene buffer and writes the 8-bit back buffer,
// which clips the sum at 1.0; the game has no tonemapping curve. Here the sum keeps
// its values above 1.0 and goes through ToneMapPass; Vanilla outputs the clipped sum as the game did.
//
// Original (fxc /dumpbin):
//   texld r0.xyz, v0.xyyy, s0          scene buffer
//   texld r1.xyz, v0.zwww, s1          bloom
//   if b0
//     texld r0.w, v0.xyyy, s5.x        mask
//     mad oC0.xyz, r0.xyzz, r0.w, r1.xyzz
//   else
//     add oC0.xyz, r1.xyzz, r0.xyzz
//   endif

#include "./shared.h"

sampler2D scene_buffer : register(s0);
sampler2D bloom : register(s1);
sampler2D mask : register(s5);
bool use_mask : register(b0);

float4 main(float4 texcoord : TEXCOORD0) : COLOR {
  float3 scene = tex2D(scene_buffer, texcoord.xy).rgb;
  const float3 bloom_color = tex2D(bloom, texcoord.zw).rgb;
  [branch] if (use_mask) {
    scene *= tex2D(mask, texcoord.xy).x;
  }
  // Gamma-encoded, like everything the game draws: it was shown on the display as written.
  // Bloom: 1 = vanilla.
  const float3 composite = scene + bloom_color * SCCT_BLOOM;
  // What vanilla showed: the sum clipped at white by the 8-bit back buffer.
  const float3 vanilla = renodx::color::srgb::Decode(saturate(composite));

  float3 color;
  [branch] if (RENODX_TONE_MAP_TYPE == renodx::draw::TONE_MAP_TYPE_VANILLA) {
    color = vanilla;
  }
  else {
    float3 untonemapped = renodx::color::srgb::DecodeSafe(composite);
    [branch] if (RENODX_TONE_MAP_TYPE == SCCT_TONE_MAP_TYPE_PSYCHO_V) {
      // Shadows below 50 darken with RenoDRT's curve (renodx::color::grade::ApplyUserColorGrading)
      // before Psycho-V: below 1, Psycho-V's own shadow curve goes negative toward black, and its
      // sign handling folds those pixels back up into blotches.
      [branch] if (RENODX_TONE_MAP_SHADOWS < 1.f) {
        const float y = renodx::color::y::from::BT709(untonemapped) / 0.18f;
        const float y_shadowed = lerp(pow(y, 2.f - RENODX_TONE_MAP_SHADOWS), y, saturate(y));
        untonemapped *= renodx::math::DivideSafe(y_shadowed, y, 0.f);
      }
      // Peak in Game Brightness units. With Gamma Correction 2.2, RenderIntermediatePass maps sRGB-decoded
      // values to 2.2-decoded ones, so the peak is pre-corrected the same way ToneMapPass does it.
      // The add-on keeps it at 1 or more.
      float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      if (RENODX_GAMMA_CORRECTION > 0.f) {
        peak = renodx::color::correct::Gamma(peak, true, 2.2f);
      }
      // The match values put Psycho-V on vanilla below white for this peak (the add-on computes
      // them); the Highlights slider applies on top, so 50 = vanilla. Above 50, Shadows runs from
      // the match to SCCT_SHADOWS_MAX, as RenoDRT's does from 1: at 2 Psycho-V's shadow curve is a
      // flat floor under everything above black, and past 2 it goes to infinity toward black.
      color = renodx::tonemap::psychov::psychotm_test30(
          untonemapped, peak,
          RENODX_TONE_MAP_EXPOSURE,
          RENODX_TONE_MAP_HIGHLIGHTS * SCCT_PSYCHO_HIGHLIGHTS_MATCH,
          lerp(SCCT_PSYCHO_SHADOWS_MATCH, SCCT_SHADOWS_MAX,
               saturate((RENODX_TONE_MAP_SHADOWS - 1.f) / (SCCT_SHADOWS_MAX - 1.f))),
          RENODX_TONE_MAP_CONTRAST,
          RENODX_TONE_MAP_SATURATION);
    }
    else {
      // RenoDRT and None read exposure, highlights, shadows, contrast and saturation themselves.
      color = renodx::draw::ToneMapPass(untonemapped);
    }
    // Hue Correction: vanilla's colour at the tone-mapped luminance, blended in by
    // strength, so highlights turn white the way vanilla's clipping showed them. Weighted by how far
    // the game's colour went past white (0 at white, 1 at twice white), as vanilla only clipped there.
    const float clip_weight = saturate(max(composite.r, max(composite.g, composite.b)) - 1.f);
    const float hue_correction = SCCT_HUE_CORRECTION * clip_weight;
    [branch] if (hue_correction > 0.f) {
      const float color_y = renodx::color::y::from::BT709(color);
      const float vanilla_y = renodx::color::y::from::BT709(vanilla);
      const float3 corrected = vanilla * renodx::math::DivideSafe(color_y, vanilla_y, 0.f);
      color = lerp(color, corrected, hue_correction);
    }
  }
  return float4(renodx::draw::RenderIntermediatePass(color), 1.f);
}
