/*
 * SPDX-License-Identifier: MIT
 */

#ifndef SRC_DETROITBECOMEHUMAN_DETROIT_DRT_SLANG_
#define SRC_DETROITBECOMEHUMAN_DETROIT_DRT_SLANG_

// Detroit DRT accepts scene-linear BT.709 and emits linear display light
// relative to Game Brightness: 1.0 is diffuse game white and peak_ratio is
// Peak Brightness / Game Brightness. The curve is deliberately identity
// through diffuse white so Detroit's calibrated midtones remain unchanged.
const vec3 DETROIT_DRT_BT709_LUMINANCE =
    vec3(0.2126, 0.7152, 0.0722);
const float DETROIT_DRT_MAX_FINITE_INPUT = 65504.0;

float DetroitDrtMapLuminance(float scene_luminance, float peak_ratio)
{
    // Negative scene values are discarded only at the nonlinear operator
    // boundary. Keep the curve finite for the full half-float input domain.
    float input_luminance = clamp(
        scene_luminance, 0.0, DETROIT_DRT_MAX_FINITE_INPUT);
    float output_peak = clamp(
        peak_ratio, 1.0, DETROIT_DRT_MAX_FINITE_INPUT);

    // Exact neutral anchors: black, 18% gray, and diffuse white all pass
    // through unchanged. The shoulder is also tangent-continuous at 1.0.
    if (input_luminance <= 1.0)
    {
        return input_luminance;
    }
    if (output_peak <= 1.0)
    {
        return 1.0;
    }

    float headroom = output_peak - 1.0;
    float highlight_distance = input_luminance - 1.0;
    return 1.0 + headroom *
        (1.0 - exp(-highlight_distance / headroom));
}

vec3 DetroitDrt(
    vec3 scene_linear_bt709,
    float peak_ratio,
    float highlight_desaturation)
{
    // The component clamp is immediately before the luminance-domain curve;
    // no encoded or already-finished frame is reconstructed here.
    vec3 nonlinear_input = clamp(
        scene_linear_bt709,
        vec3(0.0),
        vec3(DETROIT_DRT_MAX_FINITE_INPUT));
    float input_luminance = dot(
        nonlinear_input, DETROIT_DRT_BT709_LUMINANCE);
    if (input_luminance <= 0.0)
    {
        return vec3(0.0);
    }

    float output_peak = clamp(
        peak_ratio, 1.0, DETROIT_DRT_MAX_FINITE_INPUT);
    float mapped_luminance = DetroitDrtMapLuminance(
        input_luminance, output_peak);
    vec3 mapped_rgb = nonlinear_input *
        (mapped_luminance / input_luminance);

    // Optional desaturation is confined to the shoulder. Mixing toward a
    // neutral vector with the same BT.709 luminance keeps brightness stable.
    float highlight_position = 0.0;
    if (output_peak > 1.0)
    {
        highlight_position = clamp(
            (mapped_luminance - 1.0) / (output_peak - 1.0),
            0.0,
            1.0);
    }
    float smooth_highlight = highlight_position * highlight_position *
        (3.0 - 2.0 * highlight_position);
    float desaturation_amount =
        clamp(highlight_desaturation, 0.0, 1.0) * smooth_highlight;
    return mix(
        mapped_rgb,
        vec3(mapped_luminance),
        desaturation_amount);
}

vec3 DetroitDrt(vec3 scene_linear_bt709, float peak_ratio)
{
    return DetroitDrt(scene_linear_bt709, peak_ratio, 0.0);
}

#endif  // SRC_DETROITBECOMEHUMAN_DETROIT_DRT_SLANG_
