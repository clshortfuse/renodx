#include "../../../src/shaders/color.hlsl"
#include "../../../src/shaders/colorgrade.hlsl"
#include "../../../src/shaders/math.hlsl"

#if DOOM2016_MATH_VARIANT == 1
#include "../../../src/shaders/tonemap/psychov/test17.hlsl"
#elif DOOM2016_MATH_VARIANT == 2
#include "../../../src/shaders/tonemap/psychov/test22.hlsl"
#elif DOOM2016_MATH_VARIANT == 3
#include "../../../src/games/doom2016/psychov_test24.hlsli"
#elif DOOM2016_MATH_VARIANT == 4
#include "../../../src/shaders/tonemap/neutwo.hlsl"
#include "../../../src/games/doom2016/psychov_test25.hlsli"
#elif DOOM2016_MATH_VARIANT == 5
#include "../../../src/games/doom2016/psychov_test30.hlsli"
#elif DOOM2016_MATH_VARIANT == 6
#include "../../../src/shaders/tonemap/reno_drt.hlsl"
#endif

layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) readonly buffer InputSamples {
  vec4 values[];
} inputSamples;

layout(set = 0, binding = 1, std430) writeonly buffer OutputSamples {
  vec4 values[];
} outputSamples;

vec3 SanitizeInput(vec3 inputColor)
{
    inputColor = renodx::math::ZeroNaN(inputColor);
    return vec3(
        isinf(inputColor.x) ? (inputColor.x < 0.0 ? -65504.0 : 65504.0) : inputColor.x,
        isinf(inputColor.y) ? (inputColor.y < 0.0 ? -65504.0 : 65504.0) : inputColor.y,
        isinf(inputColor.z) ? (inputColor.z < 0.0 ? -65504.0 : 65504.0) : inputColor.z);
}

vec3 BoundPsychoV(vec3 signedBt709)
{
    const float peakGameRelative = 1000.0 / 203.0;
    vec3 bt2020 = renodx::color::bt2020::from::BT709(
        renodx::math::ZeroNaN(signedBt709));
    bt2020 = clamp(bt2020, vec3(0.0), vec3(peakGameRelative));
    return bt2020 * (203.0 / 100.0);
}

vec3 EvaluateMapper(vec3 inputColor)
{
    inputColor = SanitizeInput(inputColor);
    const float peakGameRelative = 1000.0 / 203.0;
#if DOOM2016_MATH_VARIANT == 1
    return BoundPsychoV(renodx::tonemap::psychov::psychotm_test17(
        inputColor, peakGameRelative,
        1.0, 1.0, 1.0, 1.0, 1.0,
        1.0, 100.0, 1.0, 1.0, 0, 1.0,
        vec3(0.18), vec3(0.18), 1.0, 1, 1.0));
#elif DOOM2016_MATH_VARIANT == 2
    return BoundPsychoV(renodx::tonemap::psychov::psychotm_test22(
        inputColor, peakGameRelative,
        1.0, 1.0, 1.0, 1.0, 1.0,
        1.0, 100.0, 1.0, 1.0, 0, 1.0,
        vec3(0.18), vec3(0.18), 1.0, 1, 1.0, 1.0));
#elif DOOM2016_MATH_VARIANT == 3
    return BoundPsychoV(renodx::tonemap::psychov::psychotm_test24(
        inputColor, peakGameRelative,
        1.0, 1.0, 1.0, 1.0, 1.0,
        1.0, 100.0, 1.0, 1.0, 0, 1.0,
        vec3(0.18), vec3(0.18), 1.0, 1, 1.0,
        1.0, 1.0, 0.0));
#elif DOOM2016_MATH_VARIANT == 4
    return BoundPsychoV(renodx::tonemap::psychov::psychotm_test25(
        inputColor, peakGameRelative,
        1.0, 1.0, 1.0, 1.0, 1.0,
        1.0, 100.0, 1.0, 1.0, 0, 1.0,
        vec3(0.18), vec3(0.18), 1.0, 1, 1.0, 0.0));
#elif DOOM2016_MATH_VARIANT == 5
    return BoundPsychoV(renodx::tonemap::psychov::psychotm_test30(
        inputColor, peakGameRelative,
        1.0, 1.0, 1.0, 1.0, 1.0,
        1.0, 100.0, 1.0, 1.0, 0, 1.0,
        vec3(0.18), vec3(0.18), 1.0, 1, 1.0,
        0.0));
#elif DOOM2016_MATH_VARIANT == 6
    renodx::tonemap::renodrt::Config config =
        renodx::tonemap::renodrt::config::Create();
    config.nits_peak = 1000.0;
    config.mid_gray_value = 0.18;
    config.mid_gray_nits = 0.18 * 203.0;
    config.exposure = 1.0;
    config.highlights = 1.0;
    config.shadows = 1.0;
    config.contrast = 1.0;
    config.saturation = 1.0;
    config.dechroma = 0.0;
    config.blowout = 0.0;
    config.flare = 0.0;
    config.hue_correction_strength = 1.0;
    config.tone_map_method =
        renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
    config.working_color_space =
        renodx::color::convert::COLOR_SPACE_BT709;
    config.clamp_color_space =
        renodx::color::convert::COLOR_SPACE_BT2020;
    config.clamp_peak =
        renodx::color::convert::COLOR_SPACE_BT2020;
    config.scaling_method =
        renodx::tonemap::renodrt::config::scaling_method::LUMINANCE;
    vec3 bt709 = renodx::tonemap::renodrt::BT709(inputColor, config);
    return clamp(
        renodx::color::bt2020::from::BT709(
            renodx::math::ZeroNaN(bt709)),
        vec3(0.0),
        vec3(10.0));
#endif
}

void main()
{
    uint index = gl_GlobalInvocationID.x;
    outputSamples.values[index] = vec4(EvaluateMapper(inputSamples.values[index].xyz), 1.0);
}
