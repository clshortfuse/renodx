#ifndef SRC_RE7_RE2R_RE3R_REVILLAGE_SHARED_H_
#define SRC_RE7_RE2R_RE3R_REVILLAGE_SHARED_H_

#define FORCE_HDR10 1  // fixes NVAPI washed out issue

#ifndef __cplusplus

#define GAMMA_CORRECTION                       2.f
#define GAMMA_CORRECTION_HUE_CORRECTION        0.25f  // higher values break dark blues (see village in RE8)
#define CUSTOM_LUT_STRENGTH                    1.f
#define CUSTOM_LUT_SCALING                     0.5f
#define CUSTOM_SHARPENING                      2.f    // 0 - off, 1 - vanilla, 2 - Lilium RCAS
#define HUE_SHIFT_FIRE                         0.f    // experimental, re7/8 shaders not collected yet
#define RENODX_TONE_MAP_HUE_SHIFT              0.95f  // needed for fires
#define RENODX_PER_CHANNEL_BLOWOUT_RESTORATION 0.2f
#define RENODX_TONE_MAP_MAX_CHANNEL            1.f  // 0 - per channel, 1 - max channel

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_RE7_RE2R_RE3R_REVILLAGE_SHARED_H_
