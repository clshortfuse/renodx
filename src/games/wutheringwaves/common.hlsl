#include "./shared.h"

#define APPLY_BLOOM(c) (c).rgb *= RENODX_WUWA_BLOOM

#define WUWA_TM_IS(N) ((uint)(RENODX_WUWA_TM) == (N))

#define CLAMP_IF_SDR(c) ((c) = ((RENODX_TONE_MAP_TYPE == 0.f) ? saturate((c)) : (c)))

#define CLAMP_IF_SDR3(r, g, b) { if (RENODX_TONE_MAP_TYPE == 0.f) { (r) = saturate((r)); (g) = saturate((g)); (b) = saturate((b)); } }

#define CAPTURE_UNTONEMAPPED(c) const float3 untonemapped = (c).rgb

#define CAPTURE_TONEMAPPED(c) const float3 tonemapped = (c).rgb

#define HANDLE_LUT_OUTPUT(c) (c).rgb = HandleLUTOutput((c).rgb, untonemapped, tonemapped)
#define HANDLE_LUT_OUTPUT_FADE(c, tex, samp) (c).rgb = HandleLUTOutput((c).rgb, untonemapped, tonemapped, tex, samp)


namespace wuwa {

static const float3x3 DCIP3_to_BT2020_MAT = float3x3(
    0.75383303, 0.19859737, 0.04756960,
    0.04574385, 0.94177722, 0.01247893,
    -0.00121034, 0.01760172, 0.98360862
);

}

static inline float3 HandleLUTOutput(float3 lut_output, float3 untonemapped, float3 tonemapped) {
  CLAMP_IF_SDR(lut_output);

  lut_output = renodx::draw::InvertIntermediatePass(lut_output);

  if (RENODX_TONE_MAP_TYPE != 0) {
    if (RENODX_COLOR_GRADE_STRENGTH == 0) {
      lut_output = untonemapped;
    } else {
        lut_output =
          renodx::draw::ApplyPerChannelCorrection(untonemapped,
                                                  lut_output,
                                                  RENODX_PER_CHANNEL_BLOWOUT_RESTORATION,
                                                  RENODX_PER_CHANNEL_HUE_CORRECTION,
                                                  RENODX_PER_CHANNEL_CHROMINANCE_CORRECTION,
                                                  RENODX_PER_CHANNEL_HUE_SHIFT);

        lut_output =
            renodx::tonemap::UpgradeToneMap(
                untonemapped,
                tonemapped,
                lut_output,
                RENODX_COLOR_GRADE_STRENGTH,
                1.f);
    }

    // Custom blowout
    [branch]
    if (RENODX_WUWA_BLOWOUT > 0) {
      const float y = renodx::color::y::from::BT709(lut_output);
      lut_output = lerp(lut_output, saturate(lut_output), RENODX_WUWA_BLOWOUT);
      const float y_clipped = renodx::color::y::from::BT709(lut_output);

      lut_output = renodx::color::correct::Luminance(lut_output, y_clipped, y);
    }

    lut_output = renodx::draw::ToneMapPass(lut_output);
  }

  lut_output = renodx::draw::RenderIntermediatePass(lut_output);

  return lut_output;
}

static inline float3 HandleLUTOutput(float3 lut_output, float3 untonemapped, float3 tonemapped, Texture3D<float4> lut_texture, SamplerState lut_sampler) {
  float min_uv = 0.015625f;
  float max_uv = 0.984375f;
  float center_uv = 0.5f;

  float3 samples[9];
  samples[0] = lut_texture.SampleLevel(lut_sampler, float3(min_uv, min_uv, min_uv), 0).rgb; // Black
  samples[1] = lut_texture.SampleLevel(lut_sampler, float3(max_uv, min_uv, min_uv), 0).rgb; // Red
  samples[2] = lut_texture.SampleLevel(lut_sampler, float3(min_uv, max_uv, min_uv), 0).rgb; // Green
  samples[3] = lut_texture.SampleLevel(lut_sampler, float3(min_uv, min_uv, max_uv), 0).rgb; // Blue
  samples[4] = lut_texture.SampleLevel(lut_sampler, float3(max_uv, max_uv, min_uv), 0).rgb; // Yellow
  samples[5] = lut_texture.SampleLevel(lut_sampler, float3(max_uv, min_uv, max_uv), 0).rgb; // Magenta
  samples[6] = lut_texture.SampleLevel(lut_sampler, float3(min_uv, max_uv, max_uv), 0).rgb; // Cyan
  samples[7] = lut_texture.SampleLevel(lut_sampler, float3(max_uv, max_uv, max_uv), 0).rgb; // White
  samples[8] = lut_texture.SampleLevel(lut_sampler, float3(center_uv, center_uv, center_uv), 0).rgb; // Center

  float max_chroma = 0.0f;
  for(int i=0; i<9; i++) {
    float3 c = samples[i];
    float max_c = max(c.r, max(c.g, c.b));
    float min_c = min(c.r, min(c.g, c.b));
    max_chroma = max(max_chroma, max_c - min_c);
  }
  
  float fade_amount = 1.0f - smoothstep(0.0f, 0.05f, max_chroma);
  float3 graded_output = HandleLUTOutput(lut_output, untonemapped, tonemapped);
  float3 original_output = renodx::draw::RenderIntermediatePass(lut_output);
  
  return lerp(graded_output, original_output, fade_amount);
}

#define GENERATE_LUT_OUTPUT(T)                                          \
  static inline T GenerateLUTOutput(T graded_bt709) {                   \
    graded_bt709 = renodx::draw::RenderIntermediatePass(graded_bt709);  \
    return graded_bt709;                                                \
  }

GENERATE_LUT_OUTPUT(float3)
GENERATE_LUT_OUTPUT(float4)

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
