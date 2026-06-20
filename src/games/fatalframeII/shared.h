
#ifndef SRC_FATALFRAMEII_SHARED_H_
#define SRC_FATALFRAMEII_SHARED_H_

#ifdef __cplusplus
#include <cstddef>
#include <cstdint>

using uint = std::uint32_t;
#endif

#define CUSTOM_FLAGS__EYE_ADAPTATION_PERCEPTUAL                 (1u << 0u)
#define CUSTOM_FLAGS__EYE_ADAPTATION_HISTOGRAM_RAN              (1u << 1u)
#define CUSTOM_FLAGS__EYE_ADAPTATION_RESOLVE_RAN                (1u << 2u)
#define CUSTOM_FLAGS__EYE_ADAPTATION_HISTOGRAM_HAD_RUN          (1u << 11u)
#define CUSTOM_FLAGS__EYE_ADAPTATION_RESOLVE_HAD_RUN            (1u << 12u)
#define CUSTOM_FLAGS__EYE_ADAPTATION_PERCEPTUAL_RESOLVE_HAD_RUN (1u << 22u)

#define CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL                 CUSTOM_FLAGS__EYE_ADAPTATION_PERCEPTUAL
#define CUSTOM_EYE_ADAPTATION_FLAGS__HISTOGRAM_RAN              CUSTOM_FLAGS__EYE_ADAPTATION_HISTOGRAM_RAN
#define CUSTOM_EYE_ADAPTATION_FLAGS__RESOLVE_RAN                CUSTOM_FLAGS__EYE_ADAPTATION_RESOLVE_RAN
#define CUSTOM_EYE_ADAPTATION_FLAGS__HISTOGRAM_HAD_RUN          CUSTOM_FLAGS__EYE_ADAPTATION_HISTOGRAM_HAD_RUN
#define CUSTOM_EYE_ADAPTATION_FLAGS__RESOLVE_HAD_RUN            CUSTOM_FLAGS__EYE_ADAPTATION_RESOLVE_HAD_RUN
#define CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL_RESOLVE_HAD_RUN CUSTOM_FLAGS__EYE_ADAPTATION_PERCEPTUAL_RESOLVE_HAD_RUN

#define RENODX_TONE_MAP_TYPE_VANILLA   0.f
#define RENODX_TONE_MAP_TYPE_RENODRT   3.f
#define RENODX_TONE_MAP_TYPE_PSYCHOV17 4.f

#define RENODX_TONE_MAP_TYPE                 shader_injection.toneMapType
#define RENODX_PEAK_NITS                     shader_injection.toneMapPeakNits
#define RENODX_GAME_NITS                     shader_injection.toneMapGameNits
#define RENODX_UI_NITS                       shader_injection.toneMapUINits
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.colorGradeExposure
#define RENODX_TONE_MAP_GAMMA                shader_injection.tone_map_gamma
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.colorGradeHighlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.colorGradeShadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.colorGradeContrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.colorGradeSaturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.colorGradeHighlightSaturation
// #define RENODX_TONE_MAP_BLOWOUT              shader_injection.colorGradeBlowout
#define RENODX_TONE_MAP_FLARE                shader_injection.colorGradeFlare
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_WHITE_CLIP           65.f  // Cause they're using arri
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE shader_injection.colorGradeColorSpace
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET      renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_HDR10
//  Game's UI and render are linear, so we gamma correct everything at the end
#define RENODX_GAMMA_CORRECTION            shader_injection.gamma_correction
#define RENODX_INTERMEDIATE_ENCODING       GAMMA_CORRECTION_NONE
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION shader_injection.gamma_correction
// Etc effects
#define CUSTOM_FILM_GRAIN_TYPE     shader_injection.custom_film_grain_type
#define CUSTOM_FILM_GRAIN_STRENGTH shader_injection.custom_film_grain
#define CUSTOM_LUT_STRENGTH        1.f
#define CUSTOM_LUT_SCALING         1.f
#define CUSTOM_RANDOM              shader_injection.custom_random
#define CUSTOM_SHARPNESS           shader_injection.custom_sharpness
#define CUSTOM_VIGNETTE            shader_injection.custom_vignette
#define CUSTOM_DECHROMA            shader_injection.colorGradeBlowout
#define FX_BLOOM_STRENGTH          shader_injection.fx_bloom_strength
#define CUSTOM_FLAGS               shader_injection.custom_flags
#ifdef __cplusplus
#define CUSTOM_FLAGS_AS_UINT (static_cast<uint32_t>(CUSTOM_FLAGS))
#else
#define CUSTOM_FLAGS_AS_UINT (asuint(CUSTOM_FLAGS))
#endif
#define CUSTOM_EYE_ADAPTATION                        CUSTOM_FLAGS
#define CUSTOM_EYE_ADAPTATION_AS_UINT                CUSTOM_FLAGS_AS_UINT
#define CUSTOM_EYE_ADAPTATION_PERCEPTUAL             ((RENODX_TONE_MAP_TYPE != RENODX_TONE_MAP_TYPE_VANILLA) && ((CUSTOM_EYE_ADAPTATION_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL) != 0u))
#define CUSTOM_EYE_ADAPTATION_HISTOGRAM_COUNT        (((CUSTOM_FLAGS_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__HISTOGRAM_RAN) != 0u) ? 1.f : 0.f)
#define CUSTOM_EYE_ADAPTATION_RESOLVE_COUNT          (((CUSTOM_FLAGS_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__RESOLVE_RAN) != 0u) ? 1.f : 0.f)
#define CUSTOM_EYE_ADAPTATION_HISTOGRAM_HAD_RUN      (((CUSTOM_FLAGS_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__HISTOGRAM_HAD_RUN) != 0u) ? 1.f : 0.f)
#define CUSTOM_EYE_ADAPTATION_RESOLVE_HAD_RUN        (((CUSTOM_FLAGS_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__RESOLVE_HAD_RUN) != 0u) ? 1.f : 0.f)
#define CUSTOM_EYE_ADAPTATION_MIN_BRIGHTNESS         shader_injection.custom_eye_adaptation_min_brightness
#define CUSTOM_EYE_ADAPTATION_MAX_BRIGHTNESS         shader_injection.custom_eye_adaptation_max_brightness
#define CUSTOM_EYE_ADAPTATION_DARK_TO_LIGHT          shader_injection.custom_eye_adaptation_dark_to_light_time
#define CUSTOM_EYE_ADAPTATION_LIGHT_TO_DARK          shader_injection.custom_eye_adaptation_light_to_dark_time
#define CUSTOM_EYE_ADAPTATION_TARGET_SMOOTHING       shader_injection.custom_eye_adaptation_target_smoothing_time
#define CUSTOM_FRAME_DELTA_TIME                      shader_injection.custom_frame_delta_time
#define CUSTOM_FRAME_TIME                            shader_injection.custom_frame_time
#define CUSTOM_EYE_ADAPTATION_RESOLVE_TAGGED         ((CUSTOM_EYE_ADAPTATION_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL_RESOLVE_HAD_RUN) != 0u)
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_FLAGS        ((uint)(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_FLAGS_OFFSET) + 0.5f))
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_CONTINUOUS   ((CUSTOM_EYE_ADAPTATION_TRANSPORT_FLAGS & RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_TEMPORAL_CONTINUITY) != 0u)
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_BASELINE     ((CUSTOM_EYE_ADAPTATION_TRANSPORT_FLAGS & RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_BASELINE) != 0u)
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_GAP          RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_GAP_OFFSET)
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_FRESH        (CUSTOM_EYE_ADAPTATION_TRANSPORT_GAP >= 0.f && CUSTOM_EYE_ADAPTATION_TRANSPORT_GAP <= 1.f)
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_HAS_DATA     (RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_VALID_OFFSET) > 0.5f                                                          \
                                                     && abs(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_MAGIC_OFFSET) - RENODX_EYE_ADAPTATION_HISTORY_MAGIC_EXPECTED) < 0.125f \
                                                     && (CUSTOM_EYE_ADAPTATION_TRANSPORT_CONTINUOUS || CUSTOM_EYE_ADAPTATION_TRANSPORT_BASELINE)                                                            \
                                                     && CUSTOM_EYE_ADAPTATION_TRANSPORT_FRESH)
#define CUSTOM_EYE_ADAPTATION_HAS_DATA               (CUSTOM_EYE_ADAPTATION_RESOLVE_TAGGED && CUSTOM_EYE_ADAPTATION_TRANSPORT_HAS_DATA)

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;

  float gamma_correction;

  float colorGradeExposure;
  float tone_map_gamma;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;

  float colorGradeSaturation;
  float colorGradeHighlightSaturation;
  float colorGradeBlowout;
  float colorGradeFlare;

  float colorGradeColorSpace;
  float custom_film_grain_type;
  float custom_lut_scaling;
  float custom_film_grain;

  float custom_random;
  float custom_sharpness;
  float custom_vignette;

  float fx_bloom_strength;

  float custom_flags;
  float custom_eye_adaptation_min_brightness;
  float custom_eye_adaptation_max_brightness;
  float custom_eye_adaptation_dark_to_light_time;

  float custom_eye_adaptation_light_to_dark_time;
  float custom_eye_adaptation_target_smoothing_time;
  float custom_frame_delta_time;
  float custom_frame_time;
};

struct RenodxEyeAdaptationTransportLayout {
  uint current_average_bits;
  uint target_average_bits;
  uint raw_target_average_bits;
  uint exposure_gain_bits;
  uint expected_u3_current_bits;
  uint history_field_bits;
  uint history_target_bits;
  uint history_fast_bits;
  uint history_slow_bits;
  uint history_valid_bits;
  uint history_frame_bits;
  uint history_magic_bits;
  uint transport_flags_bits;
  uint transport_gap_bits;
};

#ifdef __cplusplus
static_assert(sizeof(RenodxEyeAdaptationTransportLayout) == 56u);
static_assert(offsetof(RenodxEyeAdaptationTransportLayout, history_magic_bits) == 44u);
static_assert(offsetof(RenodxEyeAdaptationTransportLayout, transport_flags_bits) == 48u);
static_assert(offsetof(RenodxEyeAdaptationTransportLayout, transport_gap_bits) == 52u);
#endif

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injectedBuffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injectedBuffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#if (__SHADER_TARGET_MAJOR >= 5)
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
RWTexture1D<uint> renodx_eye_adaptation_buffer : register(u0, space50);
RWTexture1D<uint> renodx_eye_adaptation_histogram : register(u1, space50);
#else
RWTexture1D<uint> renodx_eye_adaptation_buffer : register(u0);
RWTexture1D<uint> renodx_eye_adaptation_histogram : register(u1);
#endif
#endif

#define RENODX_EYE_ADAPTATION_BUFFER_CURRENT_AVG_OFFSET         0u
#define RENODX_EYE_ADAPTATION_BUFFER_TARGET_AVG_OFFSET          4u
#define RENODX_EYE_ADAPTATION_BUFFER_RAW_TARGET_OFFSET          8u
#define RENODX_EYE_ADAPTATION_BUFFER_EXPOSURE_GAIN_OFFSET       12u
#define RENODX_EYE_ADAPTATION_BUFFER_EXPECTED_U3_CURRENT_OFFSET 16u
#define RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FIELD_OFFSET       20u
#define RENODX_EYE_ADAPTATION_BUFFER_HISTORY_TARGET_OFFSET      24u
#define RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FAST_OFFSET        28u
#define RENODX_EYE_ADAPTATION_BUFFER_HISTORY_SLOW_OFFSET        32u
#define RENODX_EYE_ADAPTATION_BUFFER_HISTORY_VALID_OFFSET       36u
#define RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FRAME_OFFSET       40u
#define RENODX_EYE_ADAPTATION_BUFFER_HISTORY_MAGIC_OFFSET       44u
#define RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_FLAGS_OFFSET     48u
#define RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_GAP_OFFSET       52u

#define RENODX_EYE_ADAPTATION_HISTORY_MAGIC_EXPECTED 1337.25f

#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_FIELD_VALID           (1u << 0u)
#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_TRANSPORT_HISTORY     (1u << 1u)
#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_FILTERED_TARGET       (1u << 3u)
#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_PREVIOUS_FIELD_VALID  (1u << 4u)
#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_PREVIOUS_FRAME_VALID  (1u << 5u)
#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_TEMPORAL_CONTINUITY   (1u << 6u)
#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_PREDICTED_FIELD_VALID (1u << 7u)
#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_HISTOGRAM_USABLE      (1u << 8u)
#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_FREEZE_TO_HISTORY     (1u << 9u)
#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_BASELINE              (1u << 10u)

float RenodxEyeAdaptationBufferLoadFloat(uint byte_offset) {
  return asfloat(renodx_eye_adaptation_buffer[byte_offset >> 2u]);
}

void RenodxEyeAdaptationBufferStoreFloat(uint byte_offset, float value) {
  renodx_eye_adaptation_buffer[byte_offset >> 2u] = asuint(value);
}

#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_FATALFRAMEII_SHARED_H_