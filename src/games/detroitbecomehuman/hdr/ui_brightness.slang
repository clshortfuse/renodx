#ifndef SRC_DETROITBECOMEHUMAN_UI_BRIGHTNESS_SLANG_
#define SRC_DETROITBECOMEHUMAN_UI_BRIGHTNESS_SLANG_

#include "./hdr_intermediate.hlsli"

// Detroit's native HDR output maps a neutral UI code value to display light as
// pow(code, 2.2) * 300 nits when the in-game gamma is neutral (1.0). Scale in
// that display-light domain, then apply the inverse. A direct code-value
// multiply would not target the requested nit level.
const float DETROIT_NATIVE_UI_WHITE_NITS = 300.0;

bool DetroitUsesHdrOutput()
{
    // Output Mode never changes the Windows/game swapchain. HDR adjustments
    // are valid only on the measured native HDR10 path; SDR explicitly
    // bypasses all custom math.
    return CUSTOM_OUTPUT_IS_HDR >= 0.5 &&
           CUSTOM_OUTPUT_MODE != 1.0;
}

bool DetroitShouldScaleUi()
{
    // The exact native-reference value is the Preset Off bypass. Keeping this
    // as an explicit branch guarantees the original RGBA value is written.
    return DetroitUsesHdrOutput() &&
           (RENODX_GRAPHICS_WHITE_NITS != DETROIT_NATIVE_UI_WHITE_NITS);
}

bool DetroitShouldTransformUi()
{
    return DetroitShouldScaleUi() || CUSTOM_PSYCHOV_BT2020_ACTIVE;
}

vec3 DetroitUiCodeToDisplayLight(vec3 code_value)
{
    return DetroitIntermediateCodeToDisplayLight(code_value);
}

vec3 DetroitDisplayLightToUiCode(vec3 display_light)
{
    return DetroitDisplayLightToIntermediateCode(display_light);
}

vec3 DetroitScaleUiRgb(vec3 vanilla_rgb)
{
    float light_scale = max(RENODX_GRAPHICS_WHITE_NITS, 0.0) /
                        DETROIT_NATIVE_UI_WHITE_NITS;
    vec3 display_light =
        DetroitUiCodeToDisplayLight(vanilla_rgb) * light_scale;
    if (CUSTOM_PSYCHOV_BT2020_ACTIVE)
    {
        // The scene intermediate changes primaries in PsychoV BT.2020 mode.
        // Convert UI in display light before alpha blending into that target.
        display_light = DetroitBt709ToBt2020(display_light);
    }
    // A transformed HDR intermediate must stay non-negative: both native
    // OETF variants apply fractional powers before PQ encoding.
    return DetroitDisplayLightToUiCode(display_light);
}

#endif  // SRC_DETROITBECOMEHUMAN_UI_BRIGHTNESS_SLANG_
