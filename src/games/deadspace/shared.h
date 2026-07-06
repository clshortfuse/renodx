#ifndef SRC_DEADSPACE2023_SHARED_H_
#define SRC_DEADSPACE2023_SHARED_H_

#define DEADSPACE_ENABLE_RESOURCE_UPGRADES 1

struct ShaderInjectData {
	float tone_map_type;
	float tone_map_exposure;
	float graphics_white_nits;
	float override_ui_brightness;
	float sdr_eotf_emulation_ui;
	float custom_ui_visibility;
	float peak_white_nits;
	float override_game_brightness;
	float diffuse_white_nits;
	float tone_map_working_color_space;
	float tone_map_highlights;
	float tone_map_shadows;
	float tone_map_contrast;
	float tone_map_saturation;
	float tone_map_highlight_saturation;
	float tone_map_dechroma;
	float tone_map_flare;
	float custom_bloom;
	float custom_grain_type;
	float custom_grain_strength;
};

#ifndef __cplusplus

#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
	ShaderInjectData shader_injection : packoffset(c0);
}

// With OVERRIDE_GAME_BRIGHTNESS disabled
// input = real output
// 417 = 400
// 943 = 800
// 1245 = 1000
// 2096 = 1500
// 3142 = 2000
// 4432 = 2500
// 10081.5 = 4000

#define TONE_MAP_TYPE                         shader_injection.tone_map_type
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_SDR_EOTF_EMULATION_UI         shader_injection.sdr_eotf_emulation_ui
#define CUSTOM_SHOW_UI                       shader_injection.custom_ui_visibility

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define OVERRIDE_GAME_BRIGHTNESS             shader_injection.override_game_brightness
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define OVERRIDE_UI_BRIGHTNESS               shader_injection.override_ui_brightness
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  shader_injection.tone_map_working_color_space  // 0 - AP1, 1 - LMS

#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_DECHROMA             shader_injection.tone_map_dechroma
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_GRAIN_TYPE                    shader_injection.custom_grain_type
#define CUSTOM_GRAIN_STRENGTH                shader_injection.custom_grain_strength

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_DEADSPACE2023_SHARED_H_