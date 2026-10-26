#ifndef SRC_SAINTSROW2022_SHARED_H_
#define SRC_SAINTSROW2022_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float ui_eotf_emulation;
  float game_hdr_output;

  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_contrast_highlights;
  float tone_map_shadows;
  float tone_map_contrast_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_dechroma;
  float tone_map_flare;

  float custom_lut_strength;
  float custom_bloom;
  float custom_lens_dirt;
  float custom_vignette;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE shader_injection.tone_map_type
#define GAME_HDR_OUTPUT      (shader_injection.game_hdr_output != 0.f)
// SDR output (the nits sliders are hidden): peak = game white = 203 nits, unscaled intermediate.
#define RENODX_PEAK_WHITE_NITS     (GAME_HDR_OUTPUT ? shader_injection.peak_white_nits : 203.f)
#define RENODX_DIFFUSE_WHITE_NITS  (GAME_HDR_OUTPUT ? shader_injection.diffuse_white_nits : 203.f)
#define RENODX_GRAPHICS_WHITE_NITS (GAME_HDR_OUTPUT ? shader_injection.graphics_white_nits : 203.f)
#define UI_EOTF_EMULATION          shader_injection.ui_eotf_emulation
#define SR_TONE_MAP_ACTIVE         (RENODX_TONE_MAP_TYPE != 0.f)

#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS  shader_injection.tone_map_contrast_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST_SHADOWS     shader_injection.tone_map_contrast_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_DECHROMA             shader_injection.tone_map_dechroma
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare

#define CUSTOM_LUT_STRENGTH shader_injection.custom_lut_strength
#define CUSTOM_BLOOM        shader_injection.custom_bloom
#define CUSTOM_LENS_DIRT    shader_injection.custom_lens_dirt
#define CUSTOM_VIGNETTE     shader_injection.custom_vignette

// The game's scene/UI buffer is sRGB encoded relative to paper white; scene 2.2 EOTF emulation is part of
// RenoDX (Vanilla+, Matches SDR) only.
#define RENODX_GAMMA_CORRECTION float(RENODX_TONE_MAP_TYPE == 3.f)
// UI emulation: encode the scene in 2.2 (round-trips unchanged) so the game's sRGB-encoded UI is decoded as 2.2.
// SDR writes the swap chain's code values for a 2.2 display; Matches SDR's 2.2 correction then yields the vanilla
// sRGB encode. 1 = sRGB, 2 = gamma 2.2 (renodx::draw ENCODING_*).
#define RENODX_INTERMEDIATE_ENCODING \
  ((!GAME_HDR_OUTPUT || RENODX_GAMMA_CORRECTION != 0.f || UI_EOTF_EMULATION != 0.f) ? 2.f : 1.f)

// Wide gamut: keep BT.2020, drop what lies outside it.
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE color::convert::COLOR_SPACE_BT2020
// SwapChainPass clamps the max channel after converting to BT.709 (scRGB), which would dim peak BT.2020
// colours; the tone mappers already bound the scene and UI stays at UI nits.
#define RENODX_SWAP_CHAIN_CLAMP_NITS 10000.f

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_SAINTSROW2022_SHARED_H_
