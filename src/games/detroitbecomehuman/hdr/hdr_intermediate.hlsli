#ifndef SRC_DETROITBECOMEHUMAN_HDR_INTERMEDIATE_HLSLI_
#define SRC_DETROITBECOMEHUMAN_HDR_INTERMEDIATE_HLSLI_

const float DETROIT_INTERMEDIATE_GAMMA =
    2.2000000476837158203125;
const float DETROIT_INV_INTERMEDIATE_GAMMA =
    0.454545438289642333984375;

vec3 DetroitBt709ToBt2020(vec3 bt709)
{
    return renodx::color::bt2020::from::BT709(bt709);
}

vec3 DetroitIntermediateCodeToDisplayLight(vec3 code_value)
{
    return pow(
        max(code_value, vec3(0.0)),
        vec3(DETROIT_INTERMEDIATE_GAMMA));
}

vec3 DetroitDisplayLightToIntermediateCode(vec3 display_light)
{
    return pow(
        max(display_light, vec3(0.0)),
        vec3(DETROIT_INV_INTERMEDIATE_GAMMA));
}

vec3 DetroitBt709CodeToBt2020Code(vec3 bt709_code)
{
    return DetroitDisplayLightToIntermediateCode(
        DetroitBt709ToBt2020(
            DetroitIntermediateCodeToDisplayLight(bt709_code)));
}

vec3 DetroitIntermediateDisplayLightToBt2020(
    vec3 display_light_intermediate)
{
    if (CUSTOM_PSYCHOV_BT2020_ACTIVE)
    {
        // PsychoV's wide-gamut path already stores positive BT.2020 display
        // light in the shared intermediate. Applying the native matrix again
        // would reinterpret BT.2020 values as BT.709 and collapse chroma.
        return display_light_intermediate;
    }

    // Preserve Detroit's native/decompiled conversion for every BT.709 path.
    const mat3 bt709_to_bt2020 = mat3(
        vec3(0.627399981021881103515625,
             0.069099999964237213134765625,
             0.01640000008046627044677734375),
        vec3(0.329299986362457275390625,
             0.91949999332427978515625,
             0.087999999523162841796875),
        vec3(0.0432999990880489349365234375,
             0.011400000192224979400634765625,
             0.895600020885467529296875));
    return bt709_to_bt2020 * display_light_intermediate;
}

#endif  // SRC_DETROITBECOMEHUMAN_HDR_INTERMEDIATE_HLSLI_
