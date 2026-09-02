#ifndef SRC_DETROITBECOMEHUMAN_DISPLAY_PEAK_LIMITER_HLSLI_
#define SRC_DETROITBECOMEHUMAN_DISPLAY_PEAK_LIMITER_HLSLI_

#include "../shared.h"

vec3 LimitDisplayLightPeak(vec3 display_light_intermediate)
{
    if (!CUSTOM_HDR_ACTIVE || shader_injection.tone_map_type == 0.0)
    {
        return display_light_intermediate;
    }

    // Detroit's native OETF maps display-linear 1.0 to 300 nits. Scale the
    // complete RGB triplet by one scalar so the limiter preserves hue and
    // channel ratios at the configured display peak.
    const float configured_display_peak =
        max(shader_injection.peak_white_nits, 0.0) / 300.0;
    const float output_display_peak = max(
        max(display_light_intermediate.x, display_light_intermediate.y),
        display_light_intermediate.z);
    if (output_display_peak > configured_display_peak)
    {
        display_light_intermediate *= configured_display_peak /
                                      max(output_display_peak, 1.0e-6);
    }
    return display_light_intermediate;
}

#endif  // SRC_DETROITBECOMEHUMAN_DISPLAY_PEAK_LIMITER_HLSLI_
