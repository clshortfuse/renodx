#include "./psychov_17.hlsl"
#include "./shared.h"

// typical AgX tonemap params, don't seem to change.
static const float k_ToneMapImpl = 3.0f;
static const float k_AgX_PostSaturation = 1.200000f;
static const float k_AgX_PostContrast = 1.350000f;

static const float3 k_AgX_CompressionMatrix_0 = float3(0.465116f, 0.353800f, 0.131540f);
static const float3 k_AgX_CompressionMatrix_1 = float3(0.212800f, 0.795923f, -0.008723f);
static const float3 k_AgX_CompressionMatrix_2 = float3(-0.033555f, 0.042225f, 1.080388f);

static const float3 k_AgX_CompressionMatrixInv_0 = float3(2.658576f, -1.164107f, -0.333089f);
static const float3 k_AgX_CompressionMatrixInv_1 = float3(-0.709595f, 1.566574f, 0.099044f);
static const float3 k_AgX_CompressionMatrixInv_2 = float3(0.110304f, -0.097381f, 0.911377f);

static float3 g_untonemapped;
static float g_ToneMapImpl;
static float g_AgX_PostSaturation;
static float g_AgX_PostContrast;
static float3 g_AgX_CompressionMatrix_0;
static float3 g_AgX_CompressionMatrix_1;
static float3 g_AgX_CompressionMatrix_2;
static float3 g_AgX_CompressionMatrixInv_0;
static float3 g_AgX_CompressionMatrixInv_1;
static float3 g_AgX_CompressionMatrixInv_2;

void SetAgXTonemapParams(
    float3 untonemapped,
    float impl,
    float post_saturation,
    float post_contrast,
    float3 compression_matrix_0,
    float3 compression_matrix_1,
    float3 compression_matrix_2,
    float3 compression_matrix_inv_0,
    float3 compression_matrix_inv_1,
    float3 compression_matrix_inv_2) {
  g_untonemapped = untonemapped;
  g_ToneMapImpl = impl;
  g_AgX_PostSaturation = post_saturation;
  g_AgX_PostContrast = post_contrast;
  g_AgX_CompressionMatrix_0 = compression_matrix_0;
  g_AgX_CompressionMatrix_1 = compression_matrix_1;
  g_AgX_CompressionMatrix_2 = compression_matrix_2;
  g_AgX_CompressionMatrixInv_0 = compression_matrix_inv_0;
  g_AgX_CompressionMatrixInv_1 = compression_matrix_inv_1;
  g_AgX_CompressionMatrixInv_2 = compression_matrix_inv_2;
};

float4 ApplyToneMappingScaling(float3 agx_sdr, float2 pixel_position) {
  float3 color = agx_sdr;
  float3 untonemapped = g_untonemapped;

  [branch]
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    untonemapped *= 0.667f;  // eye-balled midgray matching

    [branch]
    if (RENODX_TONE_MAP_TYPE == 3.f) {  // vanilla+ (blend sdr and hdr)
      float y = renodx::color::y::from::BT709(untonemapped);

      // blend sdr and hdr
      float t = smoothstep(0.f, 1.f, y);
      color = lerp(color, untonemapped, t);
    } else {
      color = untonemapped;
    }

    float peak_nits = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    [branch]
    if (RENODX_GAMMA_CORRECTION != 0) {
      peak_nits = renodx::color::correct::Gamma(
          peak_nits,
          RENODX_GAMMA_CORRECTION > 0.f,
          abs(RENODX_GAMMA_CORRECTION) == 1.f ? 2.2f : 2.4f);
    } else {
      // noop
    }

    const float cone_response_exponent = 1.f;

    color = renodx::tonemap::psycho::psychov_17(
        color,                       // BT709 input
        peak_nits,                   // HDR peak relative to SDR white
        RENODX_TONE_MAP_EXPOSURE,    // Exposure
        RENODX_TONE_MAP_HIGHLIGHTS,  // Highlights
        RENODX_TONE_MAP_SHADOWS,     // Shadows
        RENODX_TONE_MAP_CONTRAST,    // Contrast
        RENODX_TONE_MAP_SATURATION,  // Purity scale
        1.f,                         // Bleaching intensity
        100.f,                       // Clip point
        1.f,                         // Hue restore
        1.f,                         // Adaptation contrast
        0,                           // White curve mode
        cone_response_exponent       // Cone response exponent
    );

    color = renodx::color::bt709::clamp::AP1(color);

    float chroma_str = lerp(0, 0.5f, (saturate(RENODX_TONE_MAP_SATURATION - 1.f))); // add blowout at high sat
    [branch]
    if (chroma_str > 0.f) {
      color = renodx::color::correct::Chrominance(color, agx_sdr, chroma_str);
    }

    color = renodx::color::correct::Hue(color, agx_sdr, RENODX_TONE_MAP_HUE_CORRECTION);
  }

  return renodx::draw::RenderIntermediatePass(float4(color, 1.0f));
}
