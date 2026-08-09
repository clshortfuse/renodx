#version 450

#include "shared.h"
#include "display_peak_limiter.hlsli"

struct OETF_CONSTANT_BUFFER
{
    vec4 _vfGamma;
};

layout(set = 0, binding = 53, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_1
{
    OETF_CONSTANT_BUFFER g_cbOETF;
} _444;

layout(set = 0, binding = 0) uniform sampler2D InputTex;

layout(location = 8) in vec4 in_TexCoord;
layout(location = 0) out vec4 outColor;

vec3 DecodeSrgb(vec3 value)
{
    const vec3 linear_segment = value * 0.077399380505084991455078125;
    const vec3 power_segment = pow(
        (value + vec3(0.054999999701976776123046875)) *
            0.947867333889007568359375,
        vec3(2.400000095367431640625));
    return vec3(
        value.x <= 0.040449999272823333740234375
            ? linear_segment.x
            : power_segment.x,
        value.y <= 0.040449999272823333740234375
            ? linear_segment.y
            : power_segment.y,
        value.z <= 0.040449999272823333740234375
            ? linear_segment.z
            : power_segment.z);
}

vec3 EncodeSrgb(vec3 value)
{
    const vec3 linear_segment = value * 12.9200000762939453125;
    const vec3 power_segment =
        pow(value, vec3(0.4166666567325592041015625)) *
            1.05499994754791259765625 -
        vec3(0.054999999701976776123046875);
    return vec3(
        value.x <= 0.003130800090730190277099609375
            ? linear_segment.x
            : power_segment.x,
        value.y <= 0.003130800090730190277099609375
            ? linear_segment.y
            : power_segment.y,
        value.z <= 0.003130800090730190277099609375
            ? linear_segment.z
            : power_segment.z);
}

void main()
{
    const vec3 input_color = texture(InputTex, in_TexCoord.xy).xyz;
    const vec3 decoded = DecodeSrgb(input_color);
    const vec3 gamma_adjusted = pow(
        decoded, vec3(1.0 / _444.g_cbOETF._vfGamma.x));
    const vec3 srgb_encoded = EncodeSrgb(gamma_adjusted);
    vec3 display_light_bt709 = pow(
        srgb_encoded, vec3(2.2000000476837158203125));
    display_light_bt709 = LimitDisplayLightPeak(display_light_bt709);

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
    const vec3 normalized_bt2020 =
        (bt709_to_bt2020 * ((display_light_bt709 * 3.0) * 100.0)) *
        9.9999997473787516355514526367188e-05;
    const vec3 pq_power = pow(
        normalized_bt2020, vec3(0.1593017578125));
    const vec3 pq = pow(
        (vec3(0.8359375) + pq_power * 18.8515625) /
            (vec3(1.0) + pq_power * 18.6875),
        vec3(78.84375));
    outColor = vec4(pq, 1.0);
}
