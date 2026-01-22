#include "./shared.h"

static inline float3 AutoHDRVideo(float3 sdr_video) {
  if (RENODX_TONE_MAP_TYPE == 0.f || RENODX_TONE_MAP_HDR_VIDEO == 0.f) {
    return sdr_video;
  }
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.peak_white_nits = RENODX_VIDEO_NITS;
  
  float3 hdr_video = renodx::draw::UpscaleVideoPass(saturate(sdr_video), config);
  hdr_video = renodx::color::srgb::DecodeSafe(hdr_video);
  return renodx::draw::RenderIntermediatePass(hdr_video);
}
