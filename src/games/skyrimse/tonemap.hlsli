#ifndef RENODX_SKYRIMSE_TONEMAP_HLSLI_
#define RENODX_SKYRIMSE_TONEMAP_HLSLI_

#include "./shared.h"
#include "../../shaders/tonemap/psychov/test35.hlsl"

float SafeFinite1(float value) {
  return isfinite(value) ? clamp(value, 0.f, 65504.f) : 0.f;
}

float3 SafePositive(float3 color) {
  return float3(SafeFinite1(color.r), SafeFinite1(color.g), SafeFinite1(color.b));
}

bool IsPsychoV35Mode() {
  return abs(RENODX_TONE_MAP_TYPE - RENODX_TONE_MAP_TYPE_PSYCHOV35) < 0.5f;
}

bool IsCustomHDRMode() {
  return abs(RENODX_TONE_MAP_TYPE - renodx::draw::TONE_MAP_TYPE_RENO_DRT) < 0.5f
      || IsPsychoV35Mode();
}

float3 ApplyPsychoV35HDRTonemap(float3 color, float native_gamma) {
  native_gamma = max(native_gamma, 1e-4f);
  float peak = max(RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.f), 1.f);
  // Reserve headroom for the EOTF emulation in RenderIntermediatePass,
  // then for Skyrim's native gamma, both of which follow the tone mapper.
  if (RENODX_GAMMA_CORRECTION == 1.f) peak = renodx::color::correct::GammaSafe(peak, true, 2.2f);
  if (RENODX_GAMMA_CORRECTION == 2.f) peak = renodx::color::correct::GammaSafe(peak, true, 2.4f);
  peak = pow(peak, rcp(native_gamma));

  color = renodx::tonemap::psychov::psychotm_test35(
      SafePositive(color), peak,
      RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS,
      max(RENODX_TONE_MAP_CONTRAST, 1e-4f), RENODX_TONE_MAP_SATURATION,
      1.f, 100.f, 1.f, 1.f, 0,
      max(RENODX_PSYCHOV35_CONE_RESPONSE, 1e-4f),
      0.18f.xxx, 0.18f.xxx,
      RENODX_PSYCHOV35_GAMUT_COMPRESSION,
      RENODX_PSYCHOV35_GAMUT_MODE > 0.5f ? 1 : 0,
      1.f, RENODX_PSYCHOV35_COMPRESSION,
      renodx::tonemap::psychov::PSYCHO35_SOURCE_BOUNDARY_BT709,
      false, false, 3, 2.f);  // Smooth Neutwo-style target fit, without hard face contact.

  // Native pow in the game's gamma domain is equivalent to this power in
  // linear light. Preserve signed BT.709 excursions until BT.2020 conversion.
  color = sign(color) * pow(abs(color), native_gamma);
  return float3(isfinite(color.r) ? color.r : 0.f,
      isfinite(color.g) ? color.g : 0.f, isfinite(color.b) ? color.b : 0.f);
}

float3 CompositeSkyrimHDRBloom(float3 scene, float3 bloom, float exposure, float4 parameters) {
  // Vanilla gates bloom with its SDR-mapped luminance, not raw HDR brightness.
  // Use that exact reference for the mix while retaining the HDR scene signal.
  float scene_y = max(dot(scene, float3(0.212500006f, 0.715399981f, 0.0720999986f)), 1e-5f);
  float exposed_y = scene_y * exposure;
  float mapped_y;
  if (parameters.z > 0.5f) {
    float x = max(exposed_y - 0.00400000019f, 0.f);
    float ratio = (x * (x * 6.19999981f + 0.5f))
        / (x * (x * 6.19999981f + 1.70000005f) + 0.0599999987f);
    mapped_y = parameters.y * pow(ratio, 2.20000005f);
  } else {
    mapped_y = exposed_y * (exposed_y * parameters.y + 1.f) / (exposed_y + 1.f);
  }

  // Restore the native gamma-domain addition and receiver fade. Decode the
  // completed grade later, before PsychoV35, without clipping the HDR scene.
  float bloom_mix = saturate(parameters.x - mapped_y);
  float3 bloom_positive = SafePositive(bloom);
  float bloom_y = renodx::color::y::from::BT709(renodx::color::gamma::DecodeSafe(bloom_positive));
  // Leave the faint halo at vanilla strength. Boost only the brighter bloom
  // texels, with one RGB gain and a smooth transition to avoid contours.
  float core = smoothstep(0.05f, 0.5f, bloom_y);
  float linear_gain = 1.f + 0.75f * core;
  float encoded_gain = pow(linear_gain, 1.f / 2.2f);
  return SafePositive(scene * exposure) + bloom_positive * (bloom_mix * encoded_gain);
}

#endif
