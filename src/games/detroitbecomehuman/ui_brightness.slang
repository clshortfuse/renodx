#ifndef SRC_DETROITBECOMEHUMAN_UI_BRIGHTNESS_SLANG_
#define SRC_DETROITBECOMEHUMAN_UI_BRIGHTNESS_SLANG_

// Detroit's native HDR output maps a neutral UI code value to display light as
// pow(code, 2.2) * 300 nits when the in-game gamma is neutral (1.0). Scale in
// that display-light domain, then apply the inverse. A direct code-value
// multiply would not target the requested nit level.
const float DETROIT_NATIVE_UI_WHITE_NITS = 300.0;
const float DETROIT_PRE_PQ_GAMMA = 2.2000000476837158203125;
const float DETROIT_INV_PRE_PQ_GAMMA =
    0.454545438289642333984375;

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

vec3 DetroitUiCodeToDisplayLight(vec3 code_value)
{
    return pow(max(code_value, vec3(0.0)),
               vec3(DETROIT_PRE_PQ_GAMMA));
}

vec3 DetroitDisplayLightToUiCode(vec3 display_light)
{
    return pow(max(display_light, vec3(0.0)),
               vec3(DETROIT_INV_PRE_PQ_GAMMA));
}

vec3 DetroitScaleUiRgb(vec3 vanilla_rgb)
{
    float light_scale = max(RENODX_GRAPHICS_WHITE_NITS, 0.0) /
                        DETROIT_NATIVE_UI_WHITE_NITS;
    vec3 scaled_rgb = DetroitDisplayLightToUiCode(
        DetroitUiCodeToDisplayLight(vanilla_rgb) * light_scale);

    // The confirmed Scaleform paths normally produce non-negative RGB. The
    // alpha-mask path has no native clamp, so preserve any negative component
    // rather than feeding it to a fractional power or silently clamping it.
    return mix(vanilla_rgb, scaled_rgb,
               greaterThanEqual(vanilla_rgb, vec3(0.0)));
}

#endif  // SRC_DETROITBECOMEHUMAN_UI_BRIGHTNESS_SLANG_
