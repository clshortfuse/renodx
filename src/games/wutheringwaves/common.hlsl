#include "./shared.h"

#define WUWA_PEAK_SCALING (RENODX_PEAK_NITS / RENODX_GAME_NITS)

#define APPLY_BLOOM(c) (c).rgb *= RENODX_WUWA_BLOOM

#define WUWA_TM_IS(N) ((uint)(RENODX_WUWA_TM) == (N))

#define CLAMP_IF_SDR(c) ((c) = ((RENODX_TONE_MAP_TYPE == 0.f) ? saturate((c)) : (c)))

#define CLAMP_IF_SDR3(r, g, b) { if (RENODX_TONE_MAP_TYPE == 0.f) { (r) = saturate((r)); (g) = saturate((g)); (b) = saturate((b)); } }

#define CAPTURE_UNTONEMAPPED(c) const float3 untonemapped = (c).rgb

#define CAPTURE_TONEMAPPED(c) const float3 tonemapped = (c).rgb

#define HANDLE_LUT_OUTPUT(c) (c).rgb = HandleLUTOutput((c).rgb, untonemapped, tonemapped)
#define HANDLE_LUT_OUTPUT3(c1, c2, c3) { \
    float3 lut_output = float3(c1, c2, c3); \
    lut_output = HandleLUTOutput(lut_output, untonemapped, tonemapped); \
    c1 = lut_output.r; c2 = lut_output.g; c3 = lut_output.b; \
}

#define HANDLE_LUT_OUTPUT3_FADE(c1, c2, c3, tex, samp) { \
  float3 lut_output = float3(c1, c2, c3); \
  lut_output = HandleLUTOutput(lut_output, untonemapped, tonemapped, tex, samp); \
  c1 = lut_output.r; c2 = lut_output.g; c3 = lut_output.b; \
}

#define HANDLE_LUT_OUTPUT_FADE(c, tex, samp) (c).rgb = HandleLUTOutput((c).rgb, untonemapped, tonemapped, tex, samp)

#define GENERATE_INVERSION(c1, c2, c3) \
    const float3 inverted = renodx::draw::InvertIntermediatePass(float3(c1, c2, c3)); \
    c1 = inverted.r; c2 = inverted.g; c3 = inverted.b;

namespace wuwa {

static const float3x3 DCIP3_to_BT2020_MAT = float3x3(
    0.75383303, 0.19859737, 0.04756960,
    0.04574385, 0.94177722, 0.01247893,
    -0.00121034, 0.01760172, 0.98360862
);

}

static inline float3 HandleLUTOutput(float3 lut_output, float3 untonemapped, float3 tonemapped) {
  // Reverse the output shader's post-LUT scaling.
  lut_output /= 1.0499999523162842f;

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
  float3 a = lut_texture.SampleLevel(lut_sampler, float3(min_uv, min_uv, min_uv), 0).rgb;
  float3 b = lut_texture.SampleLevel(lut_sampler, float3(max_uv, max_uv, max_uv), 0).rgb;
  float3 c = lut_texture.SampleLevel(lut_sampler, float3(0.5f, 0.5f, 0.5f), 0).rgb;

  float3 d = abs(a - b);
  float max_delta = max(d.r, max(d.g, d.b));
  float uniform_fade = 1.0f - smoothstep(0.0f, 0.01f, max_delta);

  float3 max_v = max(a, max(b, c));
  float3 min_v = min(a, min(b, c));
  float max_chroma = max(max_v.r - min_v.r, max(max_v.g - min_v.g, max_v.b - min_v.b));
  float chroma_fade = 1.0f - smoothstep(0.0f, 0.05f, max_chroma);

  float fade_amount = max(uniform_fade, chroma_fade);
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

static inline float3 AutoHDRVideo(float3 sdr_video, float2 position) {
  if (RENODX_TONE_MAP_TYPE == 0.f || RENODX_TONE_MAP_HDR_VIDEO == 0.f) {
    return sdr_video;
  }
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.peak_white_nits = RENODX_VIDEO_NITS;

  float3 hdr_video = renodx::draw::UpscaleVideoPass(saturate(sdr_video), config);
  {
    // dithering
    const float dither_bits = 10.0f;
    const float max_value = exp2(dither_bits) - 1.0f; 
    const float dither_lsbs_10bit = 6.0f; 
    const float2 p = position + CUSTOM_RANDOM;
    const float r1 = renodx::random::Generate(p + 0.07f);
    const float r2 = renodx::random::Generate(p + 13.07f);
    const float tpdf = (r1 - r2); 
    const float y = renodx::color::y::from::BT709(max(0, hdr_video));
    const float highlight_fade = smoothstep(0.35f, 1.0f, y); 
    const float strength = lerp(1.0f, 0.45f, highlight_fade);
    const float noise = tpdf * ((dither_lsbs_10bit * strength) / max_value);

    // clamp negatives
    hdr_video = max(0, hdr_video + noise);
  }

  hdr_video = renodx::color::srgb::DecodeSafe(hdr_video);

  {
    // minor amounts of grain
    const float grain_strength = 0.00010f;
    hdr_video = renodx::effects::ApplyFilmGrain(hdr_video, position, CUSTOM_RANDOM, grain_strength, 1.f);
  }

  return renodx::draw::RenderIntermediatePass(hdr_video);
}
