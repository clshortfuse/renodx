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
  float reserved;

  // Working gamut is fixed to BT.709; the fourth PsychoV slot now carries
  // PsychoV-22 highlight chroma restoration while preserving the 112-byte ABI.
  float psychov_input_adaptation;
  float psychov_output_adaptation;
  float psychov_gamut_compression;
  float psychov22_highlight_color_restore;

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
#define RENODX_PSYCHOV_INPUT_ADAPTATION      shader_injection.psychov_input_adaptation
#define RENODX_PSYCHOV_OUTPUT_ADAPTATION     shader_injection.psychov_output_adaptation
#define RENODX_PSYCHOV_GAMUT_COMPRESSION     shader_injection.psychov_gamut_compression
#define RENODX_PSYCHOV22_HIGHLIGHT_COLOR_RESTORE shader_injection.psychov22_highlight_color_restore
#define RENODX_PSYCHOV17_BLEACHING           shader_injection.psychov17_bleaching
#define RENODX_PSYCHOV17_HUE_RESTORE         shader_injection.psychov17_hue_restore
#define RENODX_PSYCHOV22_COMPRESSION         shader_injection.psychov22_compression
#define RENODX_RENO_DRT_TONE_MAP_METHOD      (shader_injection.tone_map_type == 1.f                             \
                                                  ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD \
                                                  : renodx::tonemap::renodrt::config::tone_map_method::DANIELE)

#define CUSTOM_OUTPUT_MODE       shader_injection.output_mode
#define CUSTOM_OUTPUT_IS_HDR     shader_injection.output_is_hdr
#define CUSTOM_CAS_MODE          shader_injection.cas_mode
#define CUSTOM_CAS_STRENGTH      shader_injection.cas_strength
#define CUSTOM_SCENE_PATH_ACTIVE shader_injection.scene_path_active
#define CUSTOM_RENDER_DEBUG_PAYLOAD shader_injection.scene_path_active
#define CUSTOM_UI_PATH_ACTIVE    shader_injection.ui_path_active
#define CUSTOM_DLSS_ACTIVE       (shader_injection.reserved >= 0.5f)
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
#define CUSTOM_DOF_EDGE_WIDTH_PIXELS \
  float((CUSTOM_DOF_PACKED_BITS >> 16u) & 0x1Fu)
#define CUSTOM_DOF_FAR_STRENGTH \
  DecodeDofPackedScale( \
      (CUSTOM_DOF_PACKED_BITS >> 21u) & 0x1Fu, 16u, 0x1Fu)
#define CUSTOM_PSYCHOV17_ACTIVE  (shader_injection.tone_map_type == 3.f)
#define CUSTOM_PSYCHOV22_ACTIVE  (shader_injection.tone_map_type == 4.f)
#define CUSTOM_HDR_ACTIVE        (shader_injection.output_is_hdr >= 0.5f \
                                  && shader_injection.output_mode != 1.f)

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
