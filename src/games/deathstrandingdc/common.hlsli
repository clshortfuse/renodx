#include "./shared.h"

#define cmp -

float3 ApplyDeathStrandingToneMap(float3 untonemapped, float4 mHDRCompressionParam1, float4 mHDRCompressionParam2,
                                  float4 mHDRCompressionParam3, uint peak = 0u) {
  float3 r0, r1, r2;
  r0.rgb = untonemapped;

  if (peak == 1u) {  // unclamped
    mHDRCompressionParam2.z = 100.f;
    mHDRCompressionParam2.w = 100.f;
    mHDRCompressionParam1.x = 100.f;
  }

  // part 1
  r1.xyz = mHDRCompressionParam1.y * r0.xyz + mHDRCompressionParam1.z;
  r2.xyz = mHDRCompressionParam2.x + r0.xyz;
  r2.xyz = -mHDRCompressionParam1.w / r2.xyz;
  r2.xyz = mHDRCompressionParam2.y + r2.xyz;
  r0.xyz = cmp(r0.xyz < mHDRCompressionParam2.z);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  // part 2
  r0.xyz = sqrt(r0.xyz);
  r1.xyz = cmp(float3(0, 0, 0) < r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = mHDRCompressionParam3.w * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r1.xyz ? r0.xyz : 0;
  r0.xyz = r0.xyz * r0.xyz;
  r0.xyz = min(mHDRCompressionParam1.x, r0.xyz);
  r1.xyz = -mHDRCompressionParam1.z + r0.xyz;
  r1.xyz = r1.xyz / mHDRCompressionParam1.y;
  r2.xyz = -mHDRCompressionParam2.y + r0.xyz;
  r2.xyz = -mHDRCompressionParam1.w / r2.xyz;
  r2.xyz = -mHDRCompressionParam2.x + r2.xyz;
  r0.xyz = cmp(r0.xyz < mHDRCompressionParam2.w);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  // part 3
  r1.xyz = mHDRCompressionParam1.y * r0.xyz + mHDRCompressionParam1.z;
  r2.xyz = mHDRCompressionParam3.y + r0.xyz;
  r2.xyz = -mHDRCompressionParam3.x / r2.xyz;
  r2.xyz = mHDRCompressionParam3.z + r2.xyz;
  r0.xyz = cmp(r0.xyz < mHDRCompressionParam2.z);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  return r0.rgb;
}

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.5f, float output_max = 1.f) {
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return color * scale;
}

float3 ToneMapForLUT(inout float r, inout float g, inout float b) {
  float3 color = float3(r, g, b);

  color = ToneMapMaxCLL(color);
  r = color.r, g = color.g, b = color.b;

  return color;
}

float3 ApplyDisplayMap(float3 undisplaymapped) {
  if (RENODX_TONE_MAP_TYPE != 2.f) return undisplaymapped;
  float peak_white = renodx::color::correct::GammaSafe(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
  float3 displaymapped = renodx::tonemap::ExponentialRollOff(undisplaymapped, 0.5f, peak_white);
  displaymapped = renodx::color::correct::Hue(displaymapped, undisplaymapped, RENODX_TONE_MAP_HUE_CORRECTION);

  return displaymapped;
}

float3 ScaleScene(float3 color_scene) {
  color_scene = renodx::color::correct::GammaSafe(color_scene);
  color_scene *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  color_scene = renodx::color::correct::GammaSafe(color_scene, true);

  return color_scene;
}

void UpgradeToneMapApplyDisplayMapAndScale(float3 untonemapped, float3 tonemapped,
                                           inout float graded_r, inout float graded_g, inout float graded_b,
                                           float peak_white) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return;
  float3 undisplaymapped = renodx::tonemap::UpgradeToneMap(untonemapped, tonemapped, float3(graded_r, graded_g, graded_b), 1.f);

  float3 displaymapped = ApplyDisplayMap(undisplaymapped);

  displaymapped = ScaleScene(displaymapped);

  graded_r = displaymapped.r, graded_g = displaymapped.g, graded_b = displaymapped.b;
  return;
}
