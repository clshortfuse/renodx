#ifndef SRC_DETROITBECOMEHUMAN_SHARED_H_
#define SRC_DETROITBECOMEHUMAN_SHARED_H_

// Vulkan push-constant payload. Keep this 16-byte aligned and small enough to
// coexist with Detroit's original push-constant ranges.
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;

  float output_mode;
  float output_is_hdr;
  float tone_map_exposure;
  float tone_map_highlights;

  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;

  float tone_map_blowout;
  float tone_map_flare;
  float color_grade_strength;
  float cas_mode;

  float cas_strength;
  // Packed Render Debug state. Off is the literal 0.0f payload.
  float scene_path_active;
  float ui_path_active;
  // Numeric bit mask: bit 0 = DLSS output, bit 1 = this frame carries a
  // PsychoV BT.2020 intermediate, bit 2 = experimental motion-blur feather.
  // Integer values 0..7 remain exactly
  // representable while preserving the reflected 112-byte ABI.
  float runtime_flags;

  // CP2077-style PsychoV controls. Keep all four values in this order to
  // preserve the reflected 112-byte Vulkan push-constant ABI.
  float psychov_cone_response;
  float psychov_exposure_match;
  float psychov_vanilla_slope;
  float psychov_gamut_mode;

  float psychov17_bleaching;
  float psychov17_hue_restore;
  float psychov22_compression;
  float dof_runtime_mode;
};

#ifdef __cplusplus
static_assert(sizeof(ShaderInjectData) == 112u);
#endif

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 (shader_injection.tone_map_type == 0.f ? 0.f : 3.f)
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
#define RENODX_PSYCHOV_CONE_RESPONSE         shader_injection.psychov_cone_response
#define RENODX_PSYCHOV_EXPOSURE_MATCH        shader_injection.psychov_exposure_match
#define RENODX_PSYCHOV_VANILLA_SLOPE         shader_injection.psychov_vanilla_slope
#define RENODX_PSYCHOV_GAMUT_MODE            shader_injection.psychov_gamut_mode
#define RENODX_PSYCHOV17_BLEACHING           shader_injection.psychov17_bleaching
#define RENODX_PSYCHOV17_HUE_RESTORE         shader_injection.psychov17_hue_restore
#define RENODX_PSYCHOV22_COMPRESSION         shader_injection.psychov22_compression
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::DANIELE

#define CUSTOM_OUTPUT_MODE       shader_injection.output_mode
#define CUSTOM_OUTPUT_IS_HDR     shader_injection.output_is_hdr
#define CUSTOM_CAS_MODE          shader_injection.cas_mode
#define CUSTOM_CAS_STRENGTH      shader_injection.cas_strength
#define CUSTOM_SCENE_PATH_ACTIVE shader_injection.scene_path_active
#define CUSTOM_RENDER_DEBUG_PAYLOAD shader_injection.scene_path_active
#define CUSTOM_UI_PATH_ACTIVE    shader_injection.ui_path_active
#define CUSTOM_RUNTIME_FLAGS     uint(max(shader_injection.runtime_flags, 0.f))
#define CUSTOM_DLSS_ACTIVE       ((CUSTOM_RUNTIME_FLAGS & 0x1u) != 0u)
#define CUSTOM_EXPERIMENTAL_MOTION_BLUR \
  ((CUSTOM_RUNTIME_FLAGS & 0x4u) != 0u)
#ifndef __cplusplus
float DecodeDofPackedScale(uint code, uint neutral, uint maximum)
{
  return code <= neutral
      ? float(code) / float(neutral)
      : 1.0 + float(code - neutral) / float(maximum - neutral);
}
#endif
#define CUSTOM_DOF_PACKED_BITS \
  floatBitsToUint(shader_injection.dof_runtime_mode)
#define CUSTOM_DOF_RUNTIME_MODE \
  float(CUSTOM_DOF_PACKED_BITS & 0x7u)
#define CUSTOM_DOF_FOCUS_SCALE \
  DecodeDofPackedScale( \
      (CUSTOM_DOF_PACKED_BITS >> 3u) & 0x7Fu, 64u, 0x7Fu)
#define CUSTOM_DOF_RADIUS_SCALE \
  DecodeDofPackedScale( \
      (CUSTOM_DOF_PACKED_BITS >> 10u) & 0x3Fu, 32u, 0x3Fu)
#define CUSTOM_DOF_VANILLA_TRANSITION \
  (float((CUSTOM_DOF_PACKED_BITS >> 16u) & 0x1Fu) / 31.f)
#define CUSTOM_DOF_FAR_STRENGTH \
  DecodeDofPackedScale( \
      (CUSTOM_DOF_PACKED_BITS >> 21u) & 0x1Fu, 16u, 0x1Fu)
#define CUSTOM_DOF_FILL_EDGE_AWARE_COC \
  (((CUSTOM_DOF_PACKED_BITS >> 26u) & 0x1u) != 0u)
#define CUSTOM_DOF_FILL_ADAPTIVE_TRANSITION \
  (((CUSTOM_DOF_PACKED_BITS >> 27u) & 0x1u) != 0u)
#define CUSTOM_DOF_FILL_DENSE_RGB \
  (((CUSTOM_DOF_PACKED_BITS >> 28u) & 0x1u) != 0u)
#define CUSTOM_HDR_ACTIVE        (shader_injection.output_is_hdr >= 0.5f \
                                  && shader_injection.output_mode != 1.f)
#define CUSTOM_PSYCHOV17_ACTIVE  (shader_injection.tone_map_type == 2.f)
#define CUSTOM_PSYCHOV22_ACTIVE  (shader_injection.tone_map_type == 3.f)
#define CUSTOM_PSYCHOV24_ACTIVE  (shader_injection.tone_map_type == 4.f)
// This bit describes the basis actually written by the scene pass in the
// current frame. It is intentionally authoritative at the UI and final OETF:
// a settings-only gate would reinterpret native BT.709 video/loading frames
// as BT.2020 when the scene composite did not execute.
#define CUSTOM_PSYCHOV_BT2020_ACTIVE \
  ((CUSTOM_RUNTIME_FLAGS & 0x2u) != 0u)

#ifndef __cplusplus
#ifdef __SLANG__
layout(push_constant) uniform PushData {
  ShaderInjectData shader_injection;
}
#else
#error Detroit Vulkan replacements must be compiled from Slang.
#endif

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_DETROITBECOMEHUMAN_SHARED_H_
