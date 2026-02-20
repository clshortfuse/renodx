#ifndef SRC_HITMANWOA_SHARED_H_
#define SRC_HITMANWOA_SHARED_H_

#define FORCE_HDR10          1  // fixes NVAPI washed out issue
#define ENABLE_SHADER_TOGGLE 1

#define RENODX_TONE_MAP_TYPE                 1.f
#define RENODX_PEAK_WHITE_NITS               400.f
#define RENODX_DIFFUSE_WHITE_NITS            100.f
#define RENODX_GRAPHICS_WHITE_NITS           100.f
#define RENODX_TONE_MAP_HUE_SHIFT            0.f
#define RENODX_GAMMA_CORRECTION              2.f
#define RENODX_TONE_MAP_BLOWOUT              1.f
#define RENODX_TONE_MAP_EXPOSURE             1.f
#define RENODX_TONE_MAP_HIGHLIGHTS           1.f
#define RENODX_TONE_MAP_SHADOWS              1.f
#define RENODX_TONE_MAP_CONTRAST             1.f
#define RENODX_TONE_MAP_SATURATION           1.f
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1.f
#define RENODX_TONE_MAP_DECHROMA             0.f
#define RENODX_TONE_MAP_FLARE                0.f
#define RENODX_COLOR_GRADE_STRENGTH          1.f
#define RENODX_COLOR_GRADE_SCALING           1.f
#define RENODX_LUT_SAMPLING_TYPE             1.f  // 0 = default, 1 = replace linear/gamma2 input with srgb input and add lut offsets
#define CUSTOM_BLOOM                         0.75f
#define CUSTOM_BLOOM_SCALING                 1.f
#define CUSTOM_LUT_TETRAHEDRAL               1.f
#define CUSTOM_SHARPENING                    0.f
#define CUSTOM_DITHERING                     0.f
#define COMPRESS_TO_BT709                    1.f

#define BLOOM_SCALING_MAX 0.33f

#ifndef __cplusplus

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_HITMANWOA_SHARED_H_
