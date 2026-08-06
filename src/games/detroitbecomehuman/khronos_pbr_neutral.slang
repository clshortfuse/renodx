/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright 2024 The Khronos Group, Inc.
 *
 * Derived from KhronosGroup/ToneMapping PBR_Neutral/pbrNeutral.glsl:
 * https://github.com/KhronosGroup/ToneMapping/blob/main/PBR_Neutral/pbrNeutral.glsl
 *
 * Modified for the Detroit RenoDX add-on: converted to Slang/HLSL syntax,
 * made the non-negative input contract explicit, and retained a bounded
 * linear Rec.709 result for the separate Detroit HDR range adapter.
 */

#ifndef SRC_DETROITBECOMEHUMAN_KHRONOS_PBR_NEUTRAL_SLANG_
#define SRC_DETROITBECOMEHUMAN_KHRONOS_PBR_NEUTRAL_SLANG_

float3 KhronosPBRNeutralCurve(float3 color) {
  color = max(color, 0.0f);
  const float start_compression = 0.8f - 0.04f;
  const float desaturation = 0.15f;
  const float min_channel = min(color.r, min(color.g, color.b));
  const float offset = min_channel < 0.08f
                           ? min_channel - 6.25f * min_channel * min_channel
                           : 0.04f;
  color -= offset;

  const float peak = max(color.r, max(color.g, color.b));
  if (peak >= start_compression) {
    const float compression_size = 1.0f - start_compression;
    const float new_peak = 1.0f
                           - compression_size * compression_size
                                 / (peak + compression_size - start_compression);
    color *= new_peak / max(peak, 1.0e-6f);
    const float desaturation_weight =
        1.0f - 1.0f / (desaturation * (peak - new_peak) + 1.0f);
    color = lerp(color, new_peak, desaturation_weight);
  }
  return saturate(color);
}

#endif  // SRC_DETROITBECOMEHUMAN_KHRONOS_PBR_NEUTRAL_SLANG_
