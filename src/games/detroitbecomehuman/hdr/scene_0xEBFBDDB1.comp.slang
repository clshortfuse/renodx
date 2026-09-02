#version 450
#extension GL_EXT_samplerless_texture_functions : require
#include "../shared.h"
#include "hdr_intermediate.hlsli"
#include "../../detroitbecomehuman-effects/debug/render_debug_common.slang"
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

struct sCB
{
    vec4 Lift;
    vec4 Gamma;
    vec4 Gain;
    vec4 Shadow;
    vec4 Midtone;
    vec4 Highlight;
    vec4 Offset;
    float LowRange;
    float HighRange;
    float Contrast;
    float Pivot;
    float Saturation;
    float Hue;
    int ColorSpace;
    float Dummy0;
};

struct POSTPROCESSING_VIEWPORT_COMPOSITING_CONSTANT_BUFFER
{
    ivec4 _viScaleNeo4k;
    vec4 _vfInvViewportSize;
    ivec4 _viViewportOffsetSize;
    ivec4 _viMireSrgb;
    vec4 _vfGrainSize;
    vec4 _vfGrainIrregularityU;
    vec4 _vfGrainIrregularityV;
    vec4 _vfGrainIntensity;
    vec4 _vfGrainBlack;
};

vec3 _2625;

layout(set = 0, binding = 53, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_ColorGrading_CB_INDEX
{
    sCB ColorGrading;
} _372;

layout(set = 0, binding = 52, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_0
{
    POSTPROCESSING_VIEWPORT_COMPOSITING_CONSTANT_BUFFER g_cbComposite;
} _541;

layout(set = 0, binding = 4) uniform sampler2D Noise;
layout(set = 0, binding = 1) uniform sampler2D ColorGradingLUTR;
layout(set = 0, binding = 2) uniform sampler2D ColorGradingLUTG;
layout(set = 0, binding = 3) uniform sampler2D ColorGradingLUTB;
layout(set = 0, binding = 0) uniform sampler2D Image;
layout(set = 0, binding = 16, rgba16f) uniform writeonly image2D OutputTexture;

// The native neutral reference is uniform for the whole dispatch. Resolve it
// once per 8x8 workgroup instead of repeating the LUT inversion for every
// pixel. x/y are the PsychoV input/output anchors; z is the native log-log
// slope (x * V'(x) / V(x)).
shared vec3 sPsychoVVanillaReference;

float DetroitApplyNativeHighlightShoulder(float value)
{
    if (_541.g_cbComposite._viMireSrgb.z != 1 || value <= 0.5)
    {
        return value;
    }
    if (value >= 1.89999997615814208984375)
    {
        return (0.044551424682140350341796875 * value)
            + 0.84530413150787353515625;
    }
    return 0.949999988079071044921875
        - (0.449999988079071044921875
            * exp((0.5 - value) * 2.22222232818603515625));
}

float DetroitEvalVanillaNeutral(float scene_linear)
{
    // ColorSpace == 2 uses ColorGradingLUTR as Detroit's scalar luminance
    // curve. Use the same authoritative curve for the neutral reference so
    // creative per-channel grading is not mistaken for tonemapper contrast.
    // As in CP2077, Scene Grading strength affects the actual PsychoV input,
    // not this borrowed native neutral response.
    const float safe_input = max(scene_linear, 0.0);
    const float lut_address = log((safe_input * 10.0) + 1.0)
        * 0.1447438895702362060546875;
    float output_value = textureLod(
        ColorGradingLUTR,
        vec2(lut_address, 0.0),
        0.0).x;
    if (isnan(output_value) || isinf(output_value))
    {
        return 0.0;
    }
    output_value = DetroitApplyNativeHighlightShoulder(
        max(output_value, 0.0));

    // The sampled value is Detroit's gamma-shaped carrier, not scene-linear
    // light. Convert it through the same neutral native transfer as the final
    // OETF and express the result relative to 100 nits. CP2077 performs its
    // reference solve in this V100 domain as well: V100 == 0.18 means 18 nits.
    const float display_light_300 =
        renodx::color::correct::GammaSafe(
            output_value,
            false,
            2.2);
    return max(display_light_300 * 3.0, 0.0);
}

float DetroitResolvePsychoVNeutralAnchor()
{
    // CP2077 keeps the unmatched PsychoV anchor at the neutral value produced
    // by the same user grading controls as the scene. Detroit has no separate
    // dynamic-exposure control here, so evaluate the common scalar controls at
    // 18% gray. Saturation cannot move a neutral value.
    const float neutral = 0.18;
    float graded = neutral * max(RENODX_TONE_MAP_EXPOSURE, 0.0);
    if (RENODX_TONE_MAP_HIGHLIGHTS != 1.0)
    {
        graded = renodx::color::grade::Highlights(
            graded,
            RENODX_TONE_MAP_HIGHLIGHTS,
            neutral);
    }
    if (RENODX_TONE_MAP_SHADOWS != 1.0)
    {
        graded = renodx::color::grade::Shadows(
            graded,
            RENODX_TONE_MAP_SHADOWS,
            neutral);
    }
    if (RENODX_TONE_MAP_CONTRAST != 1.0)
    {
        graded = renodx::color::grade::ContrastSafe(
            graded,
            RENODX_TONE_MAP_CONTRAST,
            neutral);
    }
    if (isnan(graded) || isinf(graded))
    {
        return neutral;
    }
    return max(graded, 1.0e-6);
}

vec3 DetroitResolvePsychoVVanillaReference()
{
    const float neutral = 0.18;
    const float unmatched_anchor = DetroitResolvePsychoVNeutralAnchor();
    float anchor_input = unmatched_anchor;
    float anchor_output = unmatched_anchor;
    float reference_input = neutral;
    float reference_output = DetroitEvalVanillaNeutral(reference_input);

    if (RENODX_PSYCHOV_EXPOSURE_MATCH >= 0.5
        || RENODX_PSYCHOV_VANILLA_SLOPE > 0.0)
    {
        // Match CP2077's sampled-curve inverse: seed the upper bound from the
        // graded neutral anchor, expand it at most eight times, then perform
        // sixteen linear-domain bisections.
        float lower_input = 0.0;
        float upper_input = max(max(unmatched_anchor, neutral), 1.0e-4);
        float upper_output = DetroitEvalVanillaNeutral(upper_input);
        for (int expansion = 0;
             expansion < 8 && upper_output < neutral;
             ++expansion)
        {
            upper_input *= 2.0;
            upper_output = DetroitEvalVanillaNeutral(upper_input);
        }
        for (int iteration = 0; iteration < 16; ++iteration)
        {
            const float middle_input =
                (lower_input + upper_input) * 0.5;
            const float middle_output =
                DetroitEvalVanillaNeutral(middle_input);
            if (middle_output < neutral)
            {
                lower_input = middle_input;
            }
            else
            {
                upper_input = middle_input;
            }
        }
        // CP2077 uses the final upper bound rather than the last midpoint.
        reference_input = upper_input;
        reference_output = DetroitEvalVanillaNeutral(reference_input);
        if (RENODX_PSYCHOV_EXPOSURE_MATCH >= 0.5)
        {
            anchor_input = reference_input;
            // PsychoV output is later scaled by Game Brightness, whereas
            // the solved native reference is normalized to 100 nits.
            // Convert V100 back to PsychoV's scene-linear output domain so
            // the final displayed anchor remains the same 18-nit target.
            anchor_output = reference_output * 100.0
                / max(RENODX_DIFFUSE_WHITE_NITS, 1.0e-6);
        }
    }

    float vanilla_contrast = 1.0;
    if (RENODX_PSYCHOV_VANILLA_SLOPE > 0.0)
    {
        // Match RenoDX's established stable finite-difference step for
        // sampled/exp-log curves. Convert the linear derivative to the
        // sensitometric log slope expected by PsychoV.
        const float delta = max(0.005, reference_input * 0.01);
        const float lower_input = max(0.0, reference_input - delta);
        const float upper_input = reference_input + delta;
        const float lower_output = DetroitEvalVanillaNeutral(lower_input);
        const float upper_output = DetroitEvalVanillaNeutral(upper_input);
        const float input_span = upper_input - lower_input;
        const float linear_slope = input_span == 0.0
            ? 0.0
            : max((upper_output - lower_output) / input_span, 0.0);
        const float candidate = reference_output == 0.0
            ? 1.0
            : max(
                (reference_input * linear_slope) / reference_output,
                0.0);
        if (!(isnan(candidate) || isinf(candidate)))
        {
            vanilla_contrast = candidate;
        }
    }

    return vec3(anchor_input, anchor_output, vanilla_contrast);
}

vec3 DecodeSceneInput(vec3 color, bool encoded_srgb)
{
    if (!encoded_srgb)
    {
        return color;
    }
    const vec3 linear_segment = color * 0.077399380505084991455078125;
    const vec3 power_segment = pow(
        (color + vec3(0.054999999701976776123046875))
            * vec3(0.947867333889007568359375),
        vec3(2.400000095367431640625));
    return mix(
        linear_segment,
        power_segment,
        greaterThan(color, vec3(0.040449999272823333740234375)));
}

vec3 SanitizePsychoVDisplay(vec3 color, float psychov_peak)
{
    const float safe_peak = max(psychov_peak, 0.0);
    vec3 display = max(renodx::math::ZeroNaN(color), vec3(0.0));
    display = vec3(
        isinf(display.x) ? safe_peak : display.x,
        isinf(display.y) ? safe_peak : display.y,
        isinf(display.z) ? safe_peak : display.z);

    const float output_peak = max(display.x, max(display.y, display.z));
    if (output_peak > safe_peak)
    {
        display *= safe_peak / max(output_peak, 1.0e-6);
    }
    return display;
}

void main()
{
    if (CUSTOM_HDR_ACTIVE
        && (CUSTOM_PSYCHOV17_ACTIVE
            || CUSTOM_PSYCHOV22_ACTIVE
            || CUSTOM_PSYCHOV24_ACTIVE))
    {
        if (gl_LocalInvocationIndex == 0u)
        {
            sPsychoVVanillaReference =
                DetroitResolvePsychoVVanillaReference();
        }
        barrier();
        memoryBarrierShared();
    }

    for (;;)
    {
        ivec2 _1043 = ivec2(gl_GlobalInvocationID.xy);
        int _1045 = _1043.x;
        bool _1048 = _1045 >= _541.g_cbComposite._viViewportOffsetSize.z;
        bool _1057;
        if (!_1048)
        {
            _1057 = _1043.y >= _541.g_cbComposite._viViewportOffsetSize.w;
        }
        else
        {
            _1057 = _1048;
        }
        if (_1057)
        {
            break;
        }
        vec4 _1066 = texelFetch(Image, _1043, 0);
        vec3 _2630;
        if (_541.g_cbComposite._viMireSrgb.y == 1)
        {
            float _1125 = _1066.x;
            float _2621;
            if (_1125 <= 0.040449999272823333740234375)
            {
                _2621 = _1125 * 0.077399380505084991455078125;
            }
            else
            {
                _2621 = pow((_1125 + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
            }
            vec3 _2439;
            _2439.x = _2621;
            float _1141 = _1066.y;
            float _2626;
            if (_1141 <= 0.040449999272823333740234375)
            {
                _2626 = _1141 * 0.077399380505084991455078125;
            }
            else
            {
                _2626 = pow((_1141 + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
            }
            _2439.y = _2626;
            float _1157 = _1066.z;
            float _2628;
            if (_1157 <= 0.040449999272823333740234375)
            {
                _2628 = _1157 * 0.077399380505084991455078125;
            }
            else
            {
                _2628 = pow((_1157 + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
            }
            _2439.z = _2628;
            _2630 = _2439;
        }
        else
        {
            _2630 = _1066.xyz;
        }
        vec2 _1228 = vec2(_1043) * _541.g_cbComposite._vfGrainIrregularityU.w;
        vec4 _1240 = vec4(_1228 / vec2(_541.g_cbComposite._vfGrainSize.x), _541.g_cbComposite._vfGrainIrregularityU.x, _541.g_cbComposite._vfGrainIrregularityV.x);
        vec4 _1252 = vec4(_1228 / vec2(_541.g_cbComposite._vfGrainSize.y), _541.g_cbComposite._vfGrainIrregularityU.y, _541.g_cbComposite._vfGrainIrregularityV.y);
        vec4 _1264 = vec4(_1228 / vec2(_541.g_cbComposite._vfGrainSize.z), _541.g_cbComposite._vfGrainIrregularityU.z, _541.g_cbComposite._vfGrainIrregularityV.z);
        vec3 _2631;
        if (_541.g_cbComposite._viMireSrgb.x == 1)
        {
            _2631 = vec3(float(_1045) / float(_541.g_cbComposite._viViewportOffsetSize.z));
        }
        else
        {
            vec3 _2632;
            if (_541.g_cbComposite._viMireSrgb.x == 2)
            {
                _2632 = vec3(float(int((float(_1045) / (float(_541.g_cbComposite._viViewportOffsetSize.z) * 0.975609719753265380859375)) * 40.0)) * 0.02500000037252902984619140625);
            }
            else
            {
                _2632 = max(_2630 + ((vec3(_541.g_cbComposite._vfGrainIntensity.w) * vec3((2.0 * textureLod(Noise, _1240.xy + _1240.zw, 0.0).x) - 1.0, (2.0 * textureLod(Noise, _1252.xy + _1252.zw, 0.0).x) - 1.0, (2.0 * textureLod(Noise, _1264.xy + _1264.zw, 0.0).x) - 1.0)) * (_2630 * (_541.g_cbComposite._vfGrainIntensity.xyz + _541.g_cbComposite._vfGrainBlack.xyz))), vec3(0.0));
            }
            _2631 = _2632;
        }
        float _1330 = dot(_2631, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        bool _1332 = _372.ColorGrading.ColorSpace == 2;
        vec3 _2633;
        if (_1332)
        {
            _2633 = vec3(_1330);
        }
        else
        {
            _2633 = _2631;
        }
        vec3 _1674 = log((_2633 * 10.0) + vec3(1.0)) * 0.1447438895702362060546875;
        vec4 _1347 = textureLod(ColorGradingLUTR, vec2(_1674.x, 0.0), 0.0);
        float _1348 = _1347.x;
        vec3 _2454 = _1674;
        _2454.x = _1348;
        _2454.y = textureLod(ColorGradingLUTG, vec2(_1674.y, 0.0), 0.0).x;
        _2454.z = textureLod(ColorGradingLUTB, vec2(_1674.z, 0.0), 0.0).x;
        vec3 _2634;
        if (_1332)
        {
            _2634 = (_2631 * _1348) / vec3(_1330);
        }
        else
        {
            _2634 = _2454;
        }
        vec3 _2636;
        if (_372.ColorGrading.ColorSpace != 3)
        {
            vec3 _1696 = vec3(dot(_2634, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)));
            vec3 _1704 = _1696 + (vec3(_372.ColorGrading.Saturation) * (_2634 - _1696));
            vec3 _2635;
            if (_372.ColorGrading.Hue != 0.0)
            {
                float _1729 = _1704.z;
                float _1730 = _1704.y;
                vec4 _1749 = mix(vec4(_1729, _1730, -1.0, 0.666666686534881591796875), vec4(_1730, _1729, 0.0, -0.3333333432674407958984375), vec4(step(_1729, _1730)));
                float _1753 = _1704.x;
                float _1754 = _1749.x;
                vec4 _1772 = mix(vec4(_1754, _1749.yw, _1753), vec4(_1753, _1749.yz, _1754), vec4(step(_1754, _1753)));
                float _1774 = _1772.x;
                float _1776 = _1772.w;
                float _1778 = _1772.y;
                float _1780 = _1774 - min(_1776, _1778);
                float _1794 = abs(_1772.z + ((_1776 - _1778) / ((6.0 * _1780) + 1.0000000133514319600180897396058e-10)));
                float _1800 = _1780 / (_1774 + 1.0000000133514319600180897396058e-10);
                vec3 _1803 = vec3(_1794, _1800, _1774);
                _1803.x = _1794 + _372.ColorGrading.Hue;
                _2635 = mix(vec3(1.0), clamp(abs((fract(_1803.xxx + vec3(1.0, 0.666666686534881591796875, 0.3333333432674407958984375)) * 6.0) - vec3(3.0)) - vec3(1.0), vec3(0.0), vec3(1.0)), vec3(_1800)) * _1774;
            }
            else
            {
                _2635 = _1704;
            }
            _2636 = _2635;
        }
        else
        {
            _2636 = _2634;
        }
        vec3 _1389 = max(_2636, vec3(0.0));
        vec3 _2647;
        if (_541.g_cbComposite._viMireSrgb.z == 1)
        {
            float _1839 = _1389.x;
            float _2637;
            for (;;)
            {
                if (_1839 <= 0.5)
                {
                    _2637 = _1839;
                    break;
                }
                if (_1839 >= 1.89999997615814208984375)
                {
                    _2637 = (0.044551424682140350341796875 * _1839) + 0.84530413150787353515625;
                    break;
                }
                _2637 = 0.949999988079071044921875 - (0.449999988079071044921875 * exp((0.5 - _1839) * 2.22222232818603515625));
                break;
            }
            vec3 _2483 = _1389;
            _2483.x = _2637;
            float _1843 = _1389.y;
            float _2640;
            for (;;)
            {
                if (_1843 <= 0.5)
                {
                    _2640 = _1843;
                    break;
                }
                if (_1843 >= 1.89999997615814208984375)
                {
                    _2640 = (0.044551424682140350341796875 * _1843) + 0.84530413150787353515625;
                    break;
                }
                _2640 = 0.949999988079071044921875 - (0.449999988079071044921875 * exp((0.5 - _1843) * 2.22222232818603515625));
                break;
            }
            _2483.y = _2640;
            float _1847 = _1389.z;
            float _2643;
            for (;;)
            {
                if (_1847 <= 0.5)
                {
                    _2643 = _1847;
                    break;
                }
                if (_1847 >= 1.89999997615814208984375)
                {
                    _2643 = (0.044551424682140350341796875 * _1847) + 0.84530413150787353515625;
                    break;
                }
                _2643 = 0.949999988079071044921875 - (0.449999988079071044921875 * exp((0.5 - _1847) * 2.22222232818603515625));
                break;
            }
            _2483.z = _2643;
            _2647 = _2483;
        }
        else
        {
            _2647 = _1389;
        }
        const bool renodx_custom_active =
            CUSTOM_HDR_ACTIVE &&
            (RENODX_TONE_MAP_TYPE != 0.0 ||
            RENODX_COLOR_GRADE_STRENGTH != 1.0 ||
            RENODX_TONE_MAP_EXPOSURE != 1.0 ||
            RENODX_TONE_MAP_HIGHLIGHTS != 1.0 ||
            RENODX_TONE_MAP_SHADOWS != 1.0 ||
            RENODX_TONE_MAP_CONTRAST != 1.0 ||
            RENODX_TONE_MAP_SATURATION != 1.0 ||
            RENODX_TONE_MAP_HIGHLIGHT_SATURATION != 1.0 ||
            RENODX_TONE_MAP_BLOWOUT != 0.0 ||
            RENODX_TONE_MAP_FLARE != 0.0);
        if (renodx_custom_active && _541.g_cbComposite._viMireSrgb.x == 0)
        {
            const vec3 renodx_untonemapped = max(_2631, vec3(0.0));
            const vec3 renodx_vanilla_graded_linear = _2647;
            // PsychoV owns the display transform, but must preserve the same
            // scene-grade upgrade that ToneMapPass applies for the other modes.
            const vec3 renodx_psychov_input = max(
                renodx::draw::ComputeUntonemappedGraded(
                    renodx_untonemapped,
                    renodx_vanilla_graded_linear),
                vec3(0.0));
            const float renodx_psychov_peak = max(
                RENODX_PEAK_WHITE_NITS
                    / max(RENODX_DIFFUSE_WHITE_NITS, 1.0),
                1.0);
            // Match CP2077's authored BT.2020 hull whenever Detroit can carry
            // it end to end. Render Debug deliberately falls back to BT.709 so
            // its native BT.709 overlays never mix bases with a wide carrier.
            const int renodx_psychov_gamut_mode =
                CUSTOM_PSYCHOV_BT2020_ACTIVE ? 1 : 0;
            vec3 renodx_tonemapped;
            if (CUSTOM_PSYCHOV17_ACTIVE)
            {
                const float renodx_psychov_cone_response =
                    max(RENODX_PSYCHOV_CONE_RESPONSE, 0.0)
                    * mix(
                        1.0,
                        sPsychoVVanillaReference.z,
                        clamp(RENODX_PSYCHOV_VANILLA_SLOPE, 0.0, 1.0));
                const vec3 renodx_psychov_output =
                    renodx::tonemap::psychov::psychotm_test17(
                        renodx_psychov_input,
                        renodx_psychov_peak,
                        RENODX_TONE_MAP_EXPOSURE,
                        RENODX_TONE_MAP_HIGHLIGHTS,
                        RENODX_TONE_MAP_SHADOWS,
                        RENODX_TONE_MAP_CONTRAST,
                        RENODX_TONE_MAP_SATURATION,
                        1.0,
                        100.0,
                        1.0,
                        1.0,
                        0,
                        renodx_psychov_cone_response,
                        vec3(sPsychoVVanillaReference.x),
                        vec3(sPsychoVVanillaReference.y),
                        1.0,
                        renodx_psychov_gamut_mode,
                        1.0);
                // A BT.2020 hull is returned as a signed BT.709 representation.
                // Convert it to positive display-linear BT.2020 before the
                // shared intermediate can discard its negative components.
                const vec3 renodx_psychov_display =
                    SanitizePsychoVDisplay(
                        CUSTOM_PSYCHOV_BT2020_ACTIVE
                            ? renodx::color::bt2020::from::BT709(
                                renodx_psychov_output)
                            : renodx_psychov_output,
                        renodx_psychov_peak);
                renodx_tonemapped =
                    renodx::color::correct::GammaSafe(
                        renodx_psychov_display,
                        true,
                        2.2);
            }
            else if (CUSTOM_PSYCHOV22_ACTIVE)
            {
                const float renodx_psychov_cone_response =
                    max(RENODX_PSYCHOV_CONE_RESPONSE, 0.0)
                    * mix(
                        1.0,
                        sPsychoVVanillaReference.z,
                        clamp(RENODX_PSYCHOV_VANILLA_SLOPE, 0.0, 1.0));
                const vec3 renodx_psychov_output =
                    renodx::tonemap::psychov::psychotm_test22(
                        renodx_psychov_input,
                        renodx_psychov_peak,
                        RENODX_TONE_MAP_EXPOSURE,
                        RENODX_TONE_MAP_HIGHLIGHTS,
                        RENODX_TONE_MAP_SHADOWS,
                        RENODX_TONE_MAP_CONTRAST,
                        RENODX_TONE_MAP_SATURATION,
                        1.0,
                        100.0,
                        1.0,
                        1.0,
                        0,
                        renodx_psychov_cone_response,
                        vec3(sPsychoVVanillaReference.x),
                        vec3(sPsychoVVanillaReference.y),
                        1.0,
                        renodx_psychov_gamut_mode,
                        1.0,
                        1.0);
                const vec3 renodx_psychov_display =
                    SanitizePsychoVDisplay(
                        CUSTOM_PSYCHOV_BT2020_ACTIVE
                            ? renodx::color::bt2020::from::BT709(
                                renodx_psychov_output)
                            : renodx_psychov_output,
                        renodx_psychov_peak);
                renodx_tonemapped =
                    renodx::color::correct::GammaSafe(
                        renodx_psychov_display,
                        true,
                        2.2);
            }
            else if (CUSTOM_PSYCHOV24_ACTIVE)
            {
                const float renodx_psychov_cone_response =
                    max(RENODX_PSYCHOV_CONE_RESPONSE, 0.0)
                    * mix(
                        1.0,
                        sPsychoVVanillaReference.z,
                        clamp(RENODX_PSYCHOV_VANILLA_SLOPE, 0.0, 1.0));
                const vec3 renodx_psychov_output =
                    renodx::tonemap::psychov::psychotm_test24(
                        renodx_psychov_input,
                        renodx_psychov_peak,
                        RENODX_TONE_MAP_EXPOSURE,
                        RENODX_TONE_MAP_HIGHLIGHTS,
                        RENODX_TONE_MAP_SHADOWS,
                        RENODX_TONE_MAP_CONTRAST,
                        RENODX_TONE_MAP_SATURATION,
                        1.0,
                        100.0,
                        1.0,
                        1.0,
                        0,
                        renodx_psychov_cone_response,
                        vec3(sPsychoVVanillaReference.x),
                        vec3(sPsychoVVanillaReference.y),
                        1.0,
                        renodx_psychov_gamut_mode,
                        1.0,
                        1.0,
                        1.0,
                        0.0);
                const vec3 renodx_psychov_display =
                    SanitizePsychoVDisplay(
                        CUSTOM_PSYCHOV_BT2020_ACTIVE
                            ? renodx::color::bt2020::from::BT709(
                                renodx_psychov_output)
                            : renodx_psychov_output,
                        renodx_psychov_peak);
                renodx_tonemapped =
                    renodx::color::correct::GammaSafe(
                        renodx_psychov_display,
                        true,
                        2.2);
            }
            else
            {
                renodx_tonemapped = renodx::draw::ToneMapPass(
                    renodx_untonemapped,
                    renodx_vanilla_graded_linear);
            }
            // ToneMapPass and PsychoV share Detroit's sRGB/gamma-2.2
            // intermediate contract. Move to display light with the exact
            // native transfer, scale uniformly from Game Brightness to the
            // OETF's 300-nit anchor, then return to the intermediate. A plain
            // pow(2.2) pair is not equivalent around the sRGB toe and otherwise
            // overshoots the configured peak before the final safety limiter.
            const float renodx_game_scale =
                max(RENODX_DIFFUSE_WHITE_NITS, 0.0) / 300.0;
            const vec3 renodx_display_light =
                renodx::color::correct::GammaSafe(
                    max(renodx_tonemapped, vec3(0.0)),
                    false,
                    2.2);
            _2647 = renodx::color::correct::GammaSafe(
                renodx_display_light * renodx_game_scale,
                true,
                2.2);
        }
        bool _1398 = _372.ColorGrading.ColorSpace == 0;
        bool _1404;
        if (!_1398)
        {
            _1404 = _1332;
        }
        else
        {
            _1404 = _1398;
        }
        vec3 _2677;
        if (_1404)
        {
            float _2648;
            if (_2647.x <= 0.003130800090730190277099609375)
            {
                _2648 = 12.9200000762939453125 * _2647.x;
            }
            else
            {
                _2648 = (1.05499994754791259765625 * pow(_2647.x, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
            }
            vec3 _2494;
            _2494.x = _2648;
            float _2670;
            if (_2647.y <= 0.003130800090730190277099609375)
            {
                _2670 = 12.9200000762939453125 * _2647.y;
            }
            else
            {
                _2670 = (1.05499994754791259765625 * pow(_2647.y, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
            }
            _2494.y = _2670;
            float _2672;
            if (_2647.z <= 0.003130800090730190277099609375)
            {
                _2672 = 12.9200000762939453125 * _2647.z;
            }
            else
            {
                _2672 = (1.05499994754791259765625 * pow(_2647.z, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
            }
            _2494.z = _2672;
            _2677 = _2494;
        }
        else
        {
            _2677 = _2647;
        }
        vec3 _2706;
        if (_541.g_cbComposite._viMireSrgb.x == 3)
        {
            int _1416 = _541.g_cbComposite._viViewportOffsetSize.z / 5;
            int _1418 = _1416 / 2;
            int _1420 = _1416 / 4;
            ivec2 _1422 = ivec2(_1416);
            ivec2 _1423 = _1422 * ivec2(1);
            ivec2 _1425 = ivec2(_1420, 0);
            ivec2 _1427 = ivec2(0) * _1425;
            ivec2 _1428 = _1423 + _1427;
            int _2077 = _1428.x;
            bool _2078 = _1045 >= _2077;
            bool _2089;
            if (_2078)
            {
                _2089 = _1045 <= (_2077 + _1420);
            }
            else
            {
                _2089 = _2078;
            }
            bool _2097;
            if (_2089)
            {
                _2097 = _1043.y >= _1428.y;
            }
            else
            {
                _2097 = _2089;
            }
            bool _2108;
            if (_2097)
            {
                _2108 = _1043.y <= (_1428.y + _1416);
            }
            else
            {
                _2108 = _2097;
            }
            ivec2 _1447 = ivec2(1) * _1425;
            ivec2 _1448 = _1423 + _1447;
            int _2113 = _1448.x;
            bool _2114 = _1045 >= _2113;
            bool _2125;
            if (_2114)
            {
                _2125 = _1045 <= (_2113 + _1420);
            }
            else
            {
                _2125 = _2114;
            }
            bool _2133;
            if (_2125)
            {
                _2133 = _1043.y >= _1448.y;
            }
            else
            {
                _2133 = _2125;
            }
            bool _2144;
            if (_2133)
            {
                _2144 = _1043.y <= (_1448.y + _1416);
            }
            else
            {
                _2144 = _2133;
            }
            ivec2 _1467 = ivec2(2) * _1425;
            ivec2 _1468 = _1423 + _1467;
            int _2149 = _1468.x;
            bool _2150 = _1045 >= _2149;
            bool _2161;
            if (_2150)
            {
                _2161 = _1045 <= (_2149 + _1420);
            }
            else
            {
                _2161 = _2150;
            }
            bool _2169;
            if (_2161)
            {
                _2169 = _1043.y >= _1468.y;
            }
            else
            {
                _2169 = _2161;
            }
            bool _2180;
            if (_2169)
            {
                _2180 = _1043.y <= (_1468.y + _1416);
            }
            else
            {
                _2180 = _2169;
            }
            ivec2 _1487 = ivec2(3) * _1425;
            ivec2 _1488 = _1423 + _1487;
            int _2185 = _1488.x;
            bool _2186 = _1045 >= _2185;
            bool _2197;
            if (_2186)
            {
                _2197 = _1045 <= (_2185 + _1420);
            }
            else
            {
                _2197 = _2186;
            }
            bool _2205;
            if (_2197)
            {
                _2205 = _1043.y >= _1488.y;
            }
            else
            {
                _2205 = _2197;
            }
            bool _2216;
            if (_2205)
            {
                _2216 = _1043.y <= (_1488.y + _1416);
            }
            else
            {
                _2216 = _2205;
            }
            ivec2 _1503 = _1422 * ivec2(2, 1);
            int _2221 = _1503.x;
            bool _2222 = _1045 >= _2221;
            bool _2233;
            if (_2222)
            {
                _2233 = _1045 <= (_2221 + _1416);
            }
            else
            {
                _2233 = _2222;
            }
            bool _2241;
            if (_2233)
            {
                _2241 = _1043.y >= _1503.y;
            }
            else
            {
                _2241 = _2233;
            }
            bool _2252;
            if (_2241)
            {
                _2252 = _1043.y <= (_1503.y + _1416);
            }
            else
            {
                _2252 = _2241;
            }
            vec3 _2690;
            if (_2252)
            {
                _2690 = vec3(bvec3((((_1045 / 2) + (_1043.y / 2)) & 1) == 0));
            }
            else
            {
                _2690 = mix(mix(mix(mix(_2677, vec3(0.847058832645416259765625), bvec3(_2108)), vec3(0.89803922176361083984375), bvec3(_2144)), vec3(0.949019610881805419921875), bvec3(_2180)), vec3(1.0), bvec3(_2216));
            }
            ivec2 _1537 = _1503 + (ivec2(_1418) / ivec2(2));
            int _2257 = _1537.x;
            bool _2258 = _1045 >= _2257;
            bool _2269;
            if (_2258)
            {
                _2269 = _1045 <= (_2257 + _1418);
            }
            else
            {
                _2269 = _2258;
            }
            bool _2277;
            if (_2269)
            {
                _2277 = _1043.y >= _1537.y;
            }
            else
            {
                _2277 = _2269;
            }
            bool _2288;
            if (_2277)
            {
                _2288 = _1043.y <= (_1537.y + _1418);
            }
            else
            {
                _2288 = _2277;
            }
            ivec2 _1552 = _1422 * ivec2(3, 1);
            ivec2 _1557 = _1552 + _1427;
            int _2293 = _1557.x;
            bool _2294 = _1045 >= _2293;
            bool _2305;
            if (_2294)
            {
                _2305 = _1045 <= (_2293 + _1420);
            }
            else
            {
                _2305 = _2294;
            }
            bool _2313;
            if (_2305)
            {
                _2313 = _1043.y >= _1557.y;
            }
            else
            {
                _2313 = _2305;
            }
            bool _2324;
            if (_2313)
            {
                _2324 = _1043.y <= (_1557.y + _1416);
            }
            else
            {
                _2324 = _2313;
            }
            ivec2 _1577 = _1552 + _1447;
            int _2329 = _1577.x;
            bool _2330 = _1045 >= _2329;
            bool _2341;
            if (_2330)
            {
                _2341 = _1045 <= (_2329 + _1420);
            }
            else
            {
                _2341 = _2330;
            }
            bool _2349;
            if (_2341)
            {
                _2349 = _1043.y >= _1577.y;
            }
            else
            {
                _2349 = _2341;
            }
            bool _2360;
            if (_2349)
            {
                _2360 = _1043.y <= (_1577.y + _1416);
            }
            else
            {
                _2360 = _2349;
            }
            ivec2 _1597 = _1552 + _1467;
            int _2365 = _1597.x;
            bool _2366 = _1045 >= _2365;
            bool _2377;
            if (_2366)
            {
                _2377 = _1045 <= (_2365 + _1420);
            }
            else
            {
                _2377 = _2366;
            }
            bool _2385;
            if (_2377)
            {
                _2385 = _1043.y >= _1597.y;
            }
            else
            {
                _2385 = _2377;
            }
            bool _2396;
            if (_2385)
            {
                _2396 = _1043.y <= (_1597.y + _1416);
            }
            else
            {
                _2396 = _2385;
            }
            ivec2 _1617 = _1552 + _1487;
            int _2401 = _1617.x;
            bool _2402 = _1045 >= _2401;
            bool _2413;
            if (_2402)
            {
                _2413 = _1045 <= (_2401 + _1420);
            }
            else
            {
                _2413 = _2402;
            }
            bool _2421;
            if (_2413)
            {
                _2421 = _1043.y >= _1617.y;
            }
            else
            {
                _2421 = _2413;
            }
            bool _2432;
            if (_2421)
            {
                _2432 = _1043.y <= (_1617.y + _1416);
            }
            else
            {
                _2432 = _2421;
            }
            _2706 = mix(mix(mix(mix(mix(_2690, vec3(0.729411780834197998046875), bvec3(_2288)), vec3(0.0), bvec3(_2324)), vec3(0.0470588244497776031494140625), bvec3(_2360)), vec3(0.098039217293262481689453125), bvec3(_2396)), vec3(0.14901961386203765869140625), bvec3(_2432));
        }
        else
        {
            _2706 = _2677;
        }

        if (CUSTOM_PSYCHOV_BT2020_ACTIVE
            && _541.g_cbComposite._viMireSrgb.x != 0)
        {
            // Mire/test-pattern paths intentionally bypass the custom tone
            // mapper and therefore still produce Detroit's native BT.709
            // code values. The frame flag is authoritative at the final OETF,
            // so convert these patterns into the same BT.2020 carrier before
            // storing them in the shared intermediate.
            _2706 = DetroitBt709CodeToBt2020Code(_2706);
        }

        if (RenderDebugActive())
        {
            ivec2 debugOutputSize =
                _541.g_cbComposite._viViewportOffsetSize.zw;
            uint debugSource = RenderDebugSourceAtPixel(
                _1043, debugOutputSize);
            bool temporalUnavailable = RenderDebugTemporalUnavailable()
                && RenderDebugProducerPass(debugSource)
                    == RENDER_DEBUG_PASS_TEMPORAL;
            if (temporalUnavailable
                || RenderDebugShowUnavailableAtScene(
                    debugSource, RENDER_DEBUG_PASS_SCENE))
            {
                _2706 = RenderDebugBlend(
                    _2706, RenderDebugUnavailable(_1043));
            }
            else if (RenderDebugPreserveAtPass(
                debugSource, RENDER_DEBUG_PASS_SCENE))
            {
                // Earlier inline passes already blended the selected false
                // color. Bypass film grain and grading for this panel.
                _2706 = _2630;
            }
            else if (RenderDebugGenerateAtPass(
                debugSource, RENDER_DEBUG_PASS_SCENE))
            {
                vec4 debugValue = vec4(0.0);
                if (debugSource
                    == RENDER_DEBUG_SOURCE_SCENE_BEFORE_GRADE)
                {
                    debugValue = vec4(_2630, 1.0);
                }
                else if (debugSource
                    == RENDER_DEBUG_SOURCE_SCENE_AFTER_GRADE)
                {
                    debugValue = vec4(_2706, 1.0);
                }
                else if (debugSource
                    == RENDER_DEBUG_SOURCE_SCENE_LUMINANCE)
                {
                    float luminance = RenderDebugLuminance(
                        max(_2630, vec3(0.0)));
                    debugValue = vec4(vec3(luminance), 1.0);
                }
                _2706 = RenderDebugBlend(
                    _2706,
                    RenderDebugMap(debugValue, debugSource));
            }
            if (RenderDebugSeparatorPixel(_1043, debugOutputSize))
            {
                _2706 = vec3(1.0);
            }
        }
        imageStore(OutputTexture, _1043 + _541.g_cbComposite._viViewportOffsetSize.xy, vec4(_2706, 1.0));
        break;
    }
}
