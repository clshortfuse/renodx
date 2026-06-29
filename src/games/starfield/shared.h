#ifndef SRC_GAMES_STARFIELD_SHARED_H_
#define SRC_GAMES_STARFIELD_SHARED_H_

#ifdef __cplusplus
#include <bit>
#include <cstddef>
#include <cstdint>

using uint = std::uint32_t;
#endif

#define CUSTOM_FLAGS__EYE_ADAPTATION_PERCEPTUAL                 0b00000000000000000001u
#define CUSTOM_FLAGS__EYE_ADAPTATION_HISTOGRAM_RAN              0b00000000000000000010u
#define CUSTOM_FLAGS__EYE_ADAPTATION_RESOLVE_RAN                0b00000000000000000100u
#define CUSTOM_FLAGS__DEBUG_FORCE_CURRENT                       0b00000000000000001000u
#define CUSTOM_FLAGS__DEBUG_FORCE_TARGET                        0b00000000000000010000u
#define CUSTOM_FLAGS__DEBUG_INSPECT_PREV_FIELD                  0b00000000000000100000u
#define CUSTOM_FLAGS__DEBUG_INSPECT_RESIDUALS                   0b00000000000001000000u
#define CUSTOM_FLAGS__DEBUG_SHOW_OVERLAY                        0b00000000000010000000u
#define CUSTOM_FLAGS__LUT_SAMPLING_TETRAHEDRAL                  0b00000000000100000000u
#define CUSTOM_FLAGS__PSYCHOV_VANILLA_MIDGRAY                   0b00000000001000000000u
#define CUSTOM_FLAGS__PSYCHOV_VANILLA_SLOPE                     0b00000000010000000000u
#define CUSTOM_FLAGS__EYE_ADAPTATION_HISTOGRAM_HAD_RUN          0b00000000100000000000u
#define CUSTOM_FLAGS__EYE_ADAPTATION_RESOLVE_HAD_RUN            0b00000001000000000000u
#define CUSTOM_FLAGS__RENODRT_TONEMAP_BY_LUMINANCE              0b00000010000000000000u
#define CUSTOM_FLAGS__FILM_GRAIN_PERCEPTUAL                     0b00000100000000000000u
#define CUSTOM_FLAGS__UPGRADE_METHOD_NEUTWO_MAX_CHANNEL         0b00001000000000000000u
#define CUSTOM_FLAGS__UPGRADE_METHOD_NEUTWO_LUMINANCE           0b00010000000000000000u
#define CUSTOM_FLAGS__UPGRADE_METHOD_EXTENDED_VANILLA_N2        0b00100000000000000000u
#define CUSTOM_FLAGS__PSYCHOV_VANILLA_MIDGRAY_SOLVE             0b01000000000000000000u
#define CUSTOM_FLAGS__DEBUG_SHOW_TONEMAP_INFO                   0b10000000000000000000u
#define CUSTOM_FLAGS__PSYCHOV_VANILLA_SLOPE_FIRST_DERIVATIVE    0b100000000000000000000u
#define CUSTOM_FLAGS__DEBUG_SHOW_HISTOGRAM_SOURCE               0b1000000000000000000000u
#define CUSTOM_FLAGS__EYE_ADAPTATION_PERCEPTUAL_RESOLVE_HAD_RUN 0b10000000000000000000000u
#define CUSTOM_FLAGS__UPGRADE_METHOD_MASK                       0b00111000000000000000u
#define CUSTOM_FLAGS__UPGRADE_METHOD_UPGRADE_TONEMAP            0b00000000000000000000u
#define CUSTOM_FLAGS__UPGRADE_METHOD_NEUTWO_PER_CHANNEL         0b00011000000000000000u

#define CUSTOM_RESOURCE_TAG_RENDER 1.f

#define CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL                 CUSTOM_FLAGS__EYE_ADAPTATION_PERCEPTUAL
#define CUSTOM_EYE_ADAPTATION_FLAGS__HISTOGRAM_RAN              CUSTOM_FLAGS__EYE_ADAPTATION_HISTOGRAM_RAN
#define CUSTOM_EYE_ADAPTATION_FLAGS__RESOLVE_RAN                CUSTOM_FLAGS__EYE_ADAPTATION_RESOLVE_RAN
#define CUSTOM_EYE_ADAPTATION_FLAGS__HISTOGRAM_HAD_RUN          CUSTOM_FLAGS__EYE_ADAPTATION_HISTOGRAM_HAD_RUN
#define CUSTOM_EYE_ADAPTATION_FLAGS__RESOLVE_HAD_RUN            CUSTOM_FLAGS__EYE_ADAPTATION_RESOLVE_HAD_RUN
#define CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL_RESOLVE_HAD_RUN CUSTOM_FLAGS__EYE_ADAPTATION_PERCEPTUAL_RESOLVE_HAD_RUN
#define CUSTOM_RENODRT_FLAGS__TONEMAP_BY_LUMINANCE              CUSTOM_FLAGS__RENODRT_TONEMAP_BY_LUMINANCE
#define CUSTOM_PSYCHOV_FLAGS__VANILLA_MIDGRAY                   CUSTOM_FLAGS__PSYCHOV_VANILLA_MIDGRAY
#define CUSTOM_PSYCHOV_FLAGS__VANILLA_MIDGRAY_SOLVE             CUSTOM_FLAGS__PSYCHOV_VANILLA_MIDGRAY_SOLVE
#define CUSTOM_PSYCHOV_FLAGS__VANILLA_SLOPE                     CUSTOM_FLAGS__PSYCHOV_VANILLA_SLOPE
#define CUSTOM_PSYCHOV_FLAGS__VANILLA_SLOPE_FIRST_DERIVATIVE    CUSTOM_FLAGS__PSYCHOV_VANILLA_SLOPE_FIRST_DERIVATIVE
#define CUSTOM_FILM_GRAIN_FLAGS__PERCEPTUAL                     CUSTOM_FLAGS__FILM_GRAIN_PERCEPTUAL

#define CUSTOM_UPGRADE_METHOD__UPGRADE_TONEMAP     CUSTOM_FLAGS__UPGRADE_METHOD_UPGRADE_TONEMAP
#define CUSTOM_UPGRADE_METHOD__NEUTWO_MAX_CHANNEL  CUSTOM_FLAGS__UPGRADE_METHOD_NEUTWO_MAX_CHANNEL
#define CUSTOM_UPGRADE_METHOD__NEUTWO_LUMINANCE    CUSTOM_FLAGS__UPGRADE_METHOD_NEUTWO_LUMINANCE
#define CUSTOM_UPGRADE_METHOD__NEUTWO_PER_CHANNEL  CUSTOM_FLAGS__UPGRADE_METHOD_NEUTWO_PER_CHANNEL
#define CUSTOM_UPGRADE_METHOD__EXTENDED_VANILLA_N2 CUSTOM_FLAGS__UPGRADE_METHOD_EXTENDED_VANILLA_N2

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float custom_lut_strength;
  float custom_lut_scaling;
  float custom_bloom;
  float custom_film_grain;
  float custom_random;
  float custom_cone_response;
  float custom_lut_blend_mask;
  float custom_flags;
  float custom_eye_adaptation_min_brightness;
  float custom_eye_adaptation_max_brightness;
  float custom_eye_adaptation_dark_to_light_time;
  float custom_eye_adaptation_light_to_dark_time;
  float custom_eye_adaptation_target_smoothing_time;
  float custom_n2_midgray_prescale;
  float swap_chain_output_preset;
  float custom_frame_delta_time;
  float custom_frame_time;
#ifndef NDEBUG
  float custom_debug_value;
#endif
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
#ifndef NDEBUG
  uint debug_field_bits;
  uint debug_hdr_min_bits;
  uint debug_hdr_max_bits;
#endif
};

#ifdef __cplusplus
#ifdef NDEBUG
static_assert(sizeof(RenodxEyeAdaptationTransportLayout) == 56u);
#else
static_assert(sizeof(RenodxEyeAdaptationTransportLayout) == 68u);
#endif
static_assert(offsetof(RenodxEyeAdaptationTransportLayout, history_magic_bits) == 44u);
static_assert(offsetof(RenodxEyeAdaptationTransportLayout, transport_flags_bits) == 48u);
static_assert(offsetof(RenodxEyeAdaptationTransportLayout, transport_gap_bits) == 52u);
#ifndef NDEBUG
static_assert(offsetof(RenodxEyeAdaptationTransportLayout, debug_field_bits) == 56u);
static_assert(offsetof(RenodxEyeAdaptationTransportLayout, debug_hdr_min_bits) == 60u);
static_assert(offsetof(RenodxEyeAdaptationTransportLayout, debug_hdr_max_bits) == 64u);
#endif
#endif

#define RENODX_TONE_MAP_TYPE_VANILLA   0.f
#define RENODX_TONE_MAP_TYPE_RENODRT   3.f
#define RENODX_TONE_MAP_TYPE_PSYCHOV17 4.f

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#if (__SHADER_TARGET_MAJOR >= 5)
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
RWTexture1D<uint> renodx_eye_adaptation_buffer : register(u0, space50);
#else
RWTexture1D<uint> renodx_eye_adaptation_buffer : register(u0);
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
#ifndef NDEBUG
#define RENODX_EYE_ADAPTATION_BUFFER_DEBUG_FIELD_OFFSET         56u
#define RENODX_EYE_ADAPTATION_BUFFER_DEBUG_HDR_MIN_OFFSET       60u
#define RENODX_EYE_ADAPTATION_BUFFER_DEBUG_HDR_MAX_OFFSET       64u
#endif

#define RENODX_EYE_ADAPTATION_BUFFER_PREV_FIELD_OFFSET  RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FIELD_OFFSET
#define RENODX_EYE_ADAPTATION_BUFFER_PREV_TARGET_OFFSET RENODX_EYE_ADAPTATION_BUFFER_HISTORY_TARGET_OFFSET
#define RENODX_EYE_ADAPTATION_BUFFER_PREV_FAST_OFFSET   RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FAST_OFFSET
#define RENODX_EYE_ADAPTATION_BUFFER_PREV_SLOW_OFFSET   RENODX_EYE_ADAPTATION_BUFFER_HISTORY_SLOW_OFFSET

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
#ifndef NDEBUG
#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_VANILLA_HDR_RESET     (1u << 11u)
#define RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_BLACK_RESET           (1u << 12u)
#endif

float RenodxEyeAdaptationBufferLoadFloat(uint byte_offset) {
  return asfloat(renodx_eye_adaptation_buffer[byte_offset >> 2u]);
}

void RenodxEyeAdaptationBufferStoreFloat(uint byte_offset, float value) {
  renodx_eye_adaptation_buffer[byte_offset >> 2u] = asuint(value);
}

#define RENODX_TONE_MAP_TYPE                   shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION                shader_injection.gamma_correction
#define RENODX_TONE_MAP_EXPOSURE               shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST               shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION             shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                  shader_injection.tone_map_flare
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE      color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT709
#define RENODX_SWAP_CHAIN_ENCODING             ENCODING_SCRGB
#define CUSTOM_LUT_STRENGTH                    shader_injection.custom_lut_strength
#define CUSTOM_LUT_SCALING                     shader_injection.custom_lut_scaling
#define CUSTOM_FLAGS                           shader_injection.custom_flags
#define CUSTOM_BLOOM                           shader_injection.custom_bloom
#define CUSTOM_FILM_GRAIN                      shader_injection.custom_film_grain
#define CUSTOM_RANDOM                          shader_injection.custom_random
#define CUSTOM_CONE_RESPONSE                   shader_injection.custom_cone_response
#define CUSTOM_LUT_BLEND_MASK                  shader_injection.custom_lut_blend_mask
#ifdef __cplusplus
#define CUSTOM_FLAGS_AS_UINT (std::bit_cast<uint32_t>(CUSTOM_FLAGS))
#else
#define CUSTOM_FLAGS_AS_UINT (asuint(CUSTOM_FLAGS))
#endif
#define CUSTOM_EYE_ADAPTATION                        CUSTOM_FLAGS
#define CUSTOM_EYE_ADAPTATION_AS_UINT                CUSTOM_FLAGS_AS_UINT
#define CUSTOM_UPGRADE_METHOD                        (CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__UPGRADE_METHOD_MASK)
#define CUSTOM_UPGRADE_METHOD_IS_UPGRADE_TONEMAP     (CUSTOM_UPGRADE_METHOD == CUSTOM_UPGRADE_METHOD__UPGRADE_TONEMAP)
#define CUSTOM_UPGRADE_METHOD_IS_NEUTWO_MAX_CHANNEL  (CUSTOM_UPGRADE_METHOD == CUSTOM_UPGRADE_METHOD__NEUTWO_MAX_CHANNEL)
#define CUSTOM_UPGRADE_METHOD_IS_NEUTWO_LUMINANCE    (CUSTOM_UPGRADE_METHOD == CUSTOM_UPGRADE_METHOD__NEUTWO_LUMINANCE)
#define CUSTOM_UPGRADE_METHOD_IS_NEUTWO_PER_CHANNEL  (CUSTOM_UPGRADE_METHOD == CUSTOM_UPGRADE_METHOD__NEUTWO_PER_CHANNEL)
#define CUSTOM_UPGRADE_METHOD_IS_EXTENDED_VANILLA_N2 (CUSTOM_UPGRADE_METHOD == CUSTOM_UPGRADE_METHOD__EXTENDED_VANILLA_N2)
#define CUSTOM_LUT_SAMPLING_IS_TETRAHEDRAL           ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__LUT_SAMPLING_TETRAHEDRAL) != 0u)
#define CUSTOM_RENODRT_TONEMAP_BY_LUMINANCE          ((CUSTOM_FLAGS_AS_UINT & CUSTOM_RENODRT_FLAGS__TONEMAP_BY_LUMINANCE) != 0u)
#define CUSTOM_PSYCHOV17_ENABLED                     (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV17)
#define CUSTOM_EYE_ADAPTATION_PERCEPTUAL             (CUSTOM_PSYCHOV17_ENABLED && ((CUSTOM_EYE_ADAPTATION_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL) != 0u))
#define CUSTOM_EYE_ADAPTATION_HISTOGRAM_COUNT        (((CUSTOM_FLAGS_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__HISTOGRAM_RAN) != 0u) ? 1.f : 0.f)
#define CUSTOM_EYE_ADAPTATION_RESOLVE_COUNT          (((CUSTOM_FLAGS_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__RESOLVE_RAN) != 0u) ? 1.f : 0.f)
#define CUSTOM_EYE_ADAPTATION_HISTOGRAM_HAD_RUN      (((CUSTOM_FLAGS_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__HISTOGRAM_HAD_RUN) != 0u) ? 1.f : 0.f)
#define CUSTOM_EYE_ADAPTATION_RESOLVE_HAD_RUN        (((CUSTOM_FLAGS_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__RESOLVE_HAD_RUN) != 0u) ? 1.f : 0.f)
#ifdef NDEBUG
#define CUSTOM_DEBUG_FORCE_CURRENT         false
#define CUSTOM_DEBUG_FORCE_TARGET          false
#define CUSTOM_DEBUG_INSPECT_PREV_FIELD    false
#define CUSTOM_DEBUG_INSPECT_RESIDUALS     false
#define CUSTOM_DEBUG_SHOW_OVERLAY          false
#define CUSTOM_DEBUG_SHOW_TONEMAP_INFO     false
#define CUSTOM_DEBUG_SHOW_HISTOGRAM_SOURCE false
#else
#define CUSTOM_DEBUG_FORCE_CURRENT         ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__DEBUG_FORCE_CURRENT) != 0u)
#define CUSTOM_DEBUG_FORCE_TARGET          ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__DEBUG_FORCE_TARGET) != 0u)
#define CUSTOM_DEBUG_INSPECT_PREV_FIELD    ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__DEBUG_INSPECT_PREV_FIELD) != 0u)
#define CUSTOM_DEBUG_INSPECT_RESIDUALS     ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__DEBUG_INSPECT_RESIDUALS) != 0u)
#define CUSTOM_DEBUG_SHOW_OVERLAY          ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__DEBUG_SHOW_OVERLAY) != 0u)
#define CUSTOM_DEBUG_SHOW_TONEMAP_INFO     ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__DEBUG_SHOW_TONEMAP_INFO) != 0u)
#define CUSTOM_DEBUG_SHOW_HISTOGRAM_SOURCE ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FLAGS__DEBUG_SHOW_HISTOGRAM_SOURCE) != 0u)
#endif
#define CUSTOM_PSYCHOV_USE_VANILLA_MIDGRAY                ((CUSTOM_FLAGS_AS_UINT & CUSTOM_PSYCHOV_FLAGS__VANILLA_MIDGRAY) != 0u)
#define CUSTOM_PSYCHOV_USE_VANILLA_MIDGRAY_SOLVE          (((CUSTOM_FLAGS_AS_UINT & CUSTOM_PSYCHOV_FLAGS__VANILLA_MIDGRAY_SOLVE) != 0u) && CUSTOM_PSYCHOV_USE_VANILLA_MIDGRAY)
#define CUSTOM_PSYCHOV_USE_VANILLA_SLOPE                  ((CUSTOM_FLAGS_AS_UINT & CUSTOM_PSYCHOV_FLAGS__VANILLA_SLOPE) != 0u)
#define CUSTOM_PSYCHOV_USE_VANILLA_SLOPE_FIRST_DERIVATIVE (((CUSTOM_FLAGS_AS_UINT & CUSTOM_PSYCHOV_FLAGS__VANILLA_SLOPE_FIRST_DERIVATIVE) != 0u) && CUSTOM_PSYCHOV_USE_VANILLA_SLOPE)
#define CUSTOM_FILM_GRAIN_USE_PERCEPTUAL                  ((CUSTOM_FLAGS_AS_UINT & CUSTOM_FILM_GRAIN_FLAGS__PERCEPTUAL) != 0u)
#define CUSTOM_DEBUG_FORCE_ANY                            (CUSTOM_DEBUG_FORCE_CURRENT || CUSTOM_DEBUG_FORCE_TARGET)
#define CUSTOM_DEBUG_INSPECT_ANY                          (CUSTOM_DEBUG_INSPECT_PREV_FIELD || CUSTOM_DEBUG_INSPECT_RESIDUALS)
#define CUSTOM_DEBUG_ANY                                  (CUSTOM_DEBUG_SHOW_OVERLAY || CUSTOM_DEBUG_FORCE_ANY || CUSTOM_DEBUG_INSPECT_ANY)
#define CUSTOM_EYE_ADAPTATION_MIN_BRIGHTNESS              shader_injection.custom_eye_adaptation_min_brightness
#define CUSTOM_EYE_ADAPTATION_MAX_BRIGHTNESS              shader_injection.custom_eye_adaptation_max_brightness
#define CUSTOM_EYE_ADAPTATION_DARK_TO_LIGHT               shader_injection.custom_eye_adaptation_dark_to_light_time
#define CUSTOM_EYE_ADAPTATION_LIGHT_TO_DARK               shader_injection.custom_eye_adaptation_light_to_dark_time
#define CUSTOM_EYE_ADAPTATION_TARGET_SMOOTHING            shader_injection.custom_eye_adaptation_target_smoothing_time
#ifdef NDEBUG
#define CUSTOM_DEBUG_VALUE 0.f
#else
#define CUSTOM_DEBUG_VALUE shader_injection.custom_debug_value
#endif
#define CUSTOM_N2_MIDGRAY_PRESCALE                  shader_injection.custom_n2_midgray_prescale
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET             shader_injection.swap_chain_output_preset
#define CUSTOM_FRAME_DELTA_TIME                     shader_injection.custom_frame_delta_time
#define CUSTOM_FRAME_TIME                           shader_injection.custom_frame_time
#define CUSTOM_EYE_ADAPTATION_RESOLVE_TAGGED        ((CUSTOM_EYE_ADAPTATION_AS_UINT & CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL_RESOLVE_HAD_RUN) != 0u)
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_FLAGS       ((uint)(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_FLAGS_OFFSET) + 0.5f))
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_CONTINUOUS  ((CUSTOM_EYE_ADAPTATION_TRANSPORT_FLAGS & RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_TEMPORAL_CONTINUITY) != 0u)
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_BASELINE    ((CUSTOM_EYE_ADAPTATION_TRANSPORT_FLAGS & RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_BASELINE) != 0u)
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_GAP         RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_GAP_OFFSET)
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_FRESH       (CUSTOM_EYE_ADAPTATION_TRANSPORT_GAP >= 0.f && CUSTOM_EYE_ADAPTATION_TRANSPORT_GAP <= 1.f)
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_HAS_DATA    (RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_VALID_OFFSET) > 0.5f                                                          \
                                                     && abs(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_MAGIC_OFFSET) - RENODX_EYE_ADAPTATION_HISTORY_MAGIC_EXPECTED) < 0.125f \
                                                     && (CUSTOM_EYE_ADAPTATION_TRANSPORT_CONTINUOUS || CUSTOM_EYE_ADAPTATION_TRANSPORT_BASELINE)                                                            \
                                                     && CUSTOM_EYE_ADAPTATION_TRANSPORT_FRESH)
#define CUSTOM_EYE_ADAPTATION_HAS_DATA              (CUSTOM_EYE_ADAPTATION_RESOLVE_TAGGED && CUSTOM_EYE_ADAPTATION_TRANSPORT_HAS_DATA)
#define RENODX_COLOR_GRADE_HIGHLIGHTS_VERSION       2

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_GAMES_STARFIELD_SHARED_H_
