#ifndef RENODX_RE6_DISPLAY_MAPPING_HLSLI_
#define RENODX_RE6_DISPLAY_MAPPING_HLSLI_

#include "./color_grade.hlsli"

float3 MapGameTone(float3 scene, float mode) {
  float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION == 1.f) peak = renodx::color::correct::GammaSafe(peak, true, 2.2f);
  if (RENODX_GAMMA_CORRECTION == 2.f) peak = renodx::color::correct::GammaSafe(peak, true, 2.4f);

  [branch]
  if (MatchOriginalCurve()) {
    // The game LUT/analytic grade already supplies the SDR response. Preserve
    // that response through white, then forward-map only real HDR headroom.
    float maximum = max(scene.r, max(scene.g, scene.b));
    if (maximum <= 1.f) return scene;
    float span = max(peak - 1.f, 1.e-6f);
    float mapped_maximum = 1.f + span * (1.f - exp(-(maximum - 1.f) / span));
    return scene * (mapped_maximum / maximum);
  }

  // The upstream grade preserves scene range. Apply the selected display
  // mapper once, using its own peak-aware response and gamut mapping.
  [branch]
  if (mode == RENODX_TONE_MAP_TYPE_PSYCHOV30) {
    return renodx::tonemap::psychov::psychotm_test30(
        scene, peak, RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS, max(RENODX_TONE_MAP_CONTRAST, 0.01f), RENODX_TONE_MAP_SATURATION,
        1.f, 100.f, 1.f, 1.f, 0, max(RENODX_PSYCHOV30_CONE_RESPONSE, 0.01f),
        0.18f.xxx, 0.18f.xxx, RENODX_PSYCHOV30_GAMUT_COMPRESSION,
        RENODX_PSYCHOV30_GAMUT_MODE >= 0.5f ? 1 : 0, 1.f, RENODX_PSYCHOV30_COMPRESSION);
  }
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.tone_map_type = RENODX_TONE_MAP_TYPE_RENODRT;
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  return renodx::draw::ToneMapPass(scene, config);
}

#endif
