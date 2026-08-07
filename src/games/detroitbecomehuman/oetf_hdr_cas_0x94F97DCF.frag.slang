#version 450
#extension GL_EXT_samplerless_texture_functions : require

#include "shared.h"

// cas_mode values supplied by addon.cpp.
const float CAS_MODE_VANILLA = 0.0;
const float CAS_MODE_OFF = 1.0;
const float CAS_MODE_RENODX = 2.0;

struct OETF_CONSTANT_BUFFER
{
    vec4 _vfGamma;
};

struct CAS_CONSTANTS
{
    uvec4 vC0;
    uvec4 vC1;
    vec4 fViewport;
};

layout(set = 0, binding = 53, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_1
{
    OETF_CONSTANT_BUFFER g_cbOETF;
} _501;

layout(set = 0, binding = 54, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_2
{
    CAS_CONSTANTS g_cbCAS;
} _2697;

layout(set = 0, binding = 0) uniform sampler2D InputTex;

layout(location = 8) in vec4 in_TexCoord;
layout(location = 0) out vec4 outColor;

void main()
{
    vec2 _3646 = (vec2(uvec2(in_TexCoord.xy * _2697.g_cbCAS.fViewport.xy)) * uintBitsToFloat(uvec2(_2697.g_cbCAS.vC0.xy))) + uintBitsToFloat(uvec2(_2697.g_cbCAS.vC0.zw));
    vec2 _3648 = floor(_3646);
    vec2 _3651 = _3646 - _3648;
    ivec2 _3653 = ivec2(_3648);
    vec4 _5123 = texelFetch(InputTex, ivec2(uvec2(_3653 + ivec2(0, -1))), 0);
    vec4 _5130 = texelFetch(InputTex, ivec2(uvec2(_3653 + ivec2(-1, 0))), 0);
    vec4 _5137 = texelFetch(InputTex, ivec2(uvec2(_3653)), 0);
    vec4 _5144 = texelFetch(InputTex, ivec2(uvec2(_3653 + ivec2(1, -1))), 0);
    vec4 _5158 = texelFetch(InputTex, ivec2(uvec2(_3653 + ivec2(1, 0))), 0);
    vec4 _5165 = texelFetch(InputTex, ivec2(uvec2(_3653 + ivec2(2, 0))), 0);
    vec4 _5172 = texelFetch(InputTex, ivec2(uvec2(_3653 + ivec2(-1, 1))), 0);
    vec4 _5179 = texelFetch(InputTex, ivec2(uvec2(_3653 + ivec2(0, 1))), 0);
    vec4 _5193 = texelFetch(InputTex, ivec2(uvec2(_3653 + ivec2(0, 2))), 0);
    vec4 _5200 = texelFetch(InputTex, ivec2(uvec2(_3653 + ivec2(1))), 0);
    vec4 _5207 = texelFetch(InputTex, ivec2(uvec2(_3653 + ivec2(2, 1))), 0);
    vec4 _5214 = texelFetch(InputTex, ivec2(uvec2(_3653 + ivec2(1, 2))), 0);

    bool use_hdr_safe_path =
        CUSTOM_HDR_ACTIVE
        && (shader_injection.cas_mode >= 0.5 || CUSTOM_DLSS_ACTIVE);
    float input_scale = 1.0;
    if (use_hdr_safe_path)
    {
        // Native CAS is defined over [0, 1] and clamps each output channel to
        // that range. Normalize the entire 12-tap RGB neighborhood by one
        // scalar, run the unchanged CAS math, then restore that scalar. This
        // preserves hue and prevents 1.0 (about 300 nits here) from becoming
        // an HDR ceiling.
        vec3 local_maximum = max(_5123.xyz, _5130.xyz);
        local_maximum = max(local_maximum, _5137.xyz);
        local_maximum = max(local_maximum, _5144.xyz);
        local_maximum = max(local_maximum, _5158.xyz);
        local_maximum = max(local_maximum, _5165.xyz);
        local_maximum = max(local_maximum, _5172.xyz);
        local_maximum = max(local_maximum, _5179.xyz);
        local_maximum = max(local_maximum, _5193.xyz);
        local_maximum = max(local_maximum, _5200.xyz);
        local_maximum = max(local_maximum, _5207.xyz);
        local_maximum = max(local_maximum, _5214.xyz);
        float local_input_peak = max(max(local_maximum.x, local_maximum.y), local_maximum.z);

        // Invert Detroit's native neutral-axis output chain:
        // sRGB-decode -> pow(1/gamma) -> sRGB-encode -> pow(2.2) -> * 300 nits.
        // The configured floor keeps the normalization stable between nearby
        // neighborhoods until content exceeds the selected display peak.
        float configured_code = pow(max(shader_injection.peak_white_nits, 0.0) / 300.0, 1.0 / 2.2);
        float configured_linear_after_gamma;
        if (configured_code <= 0.04045)
        {
            configured_linear_after_gamma = configured_code * 0.077399380505084991455078125;
        }
        else
        {
            configured_linear_after_gamma = pow((configured_code + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
        }
        float configured_linear_before_gamma = pow(max(configured_linear_after_gamma, 0.0), max(_501.g_cbOETF._vfGamma.x, 0.01));
        float configured_input_peak;
        if (configured_linear_before_gamma <= 0.003130800090730190277099609375)
        {
            configured_input_peak = configured_linear_before_gamma * 12.9200000762939453125;
        }
        else
        {
            configured_input_peak = (pow(configured_linear_before_gamma, 0.4166666567325592041015625) * 1.05499994754791259765625) - 0.054999999701976776123046875;
        }

        input_scale = max(1.0, max(configured_input_peak, local_input_peak));
        _5123.xyz /= input_scale;
        _5130.xyz /= input_scale;
        _5137.xyz /= input_scale;
        _5144.xyz /= input_scale;
        _5158.xyz /= input_scale;
        _5165.xyz /= input_scale;
        _5172.xyz /= input_scale;
        _5179.xyz /= input_scale;
        _5193.xyz /= input_scale;
        _5200.xyz /= input_scale;
        _5207.xyz /= input_scale;
        _5214.xyz /= input_scale;
    }

    float _3733 = _5123.y;
    float _3746 = _5144.y;
    float _3772 = _5130.y;
    float _3785 = _5137.y;
    float _3798 = _5158.y;
    float _3811 = _5165.y;
    float _3824 = _5172.y;
    float _3837 = _5179.y;
    float _3850 = _5200.y;
    float _3863 = _5207.y;
    float _3889 = _5193.y;
    float _3902 = _5214.y;
    float _5246 = min(min(_3733, min(_3772, _3785)), min(_3798, _3837));
    float _5282 = max(max(_3733, max(_3772, _3785)), max(_3798, _3837));
    float _5318 = min(min(_3746, min(_3785, _3798)), min(_3811, _3850));
    float _5354 = max(max(_3746, max(_3785, _3798)), max(_3811, _3850));
    float _5390 = min(min(_3785, min(_3824, _3837)), min(_3850, _3889));
    float _5426 = max(max(_3785, max(_3824, _3837)), max(_3850, _3889));
    float _5462 = min(min(_3798, min(_3837, _3850)), min(_3863, _3902));
    float _5498 = max(max(_3798, max(_3837, _3850)), max(_3863, _3902));
    float _4359 = uintBitsToFloat(_2697.g_cbCAS.vC1.x);
    if (CUSTOM_DLSS_ACTIVE)
    {
        // DLAA sharpening now runs as scene-linear RCAS in the always-present
        // EBFBDDB1 compute pass. If this optional native CAS variant is used,
        // suppress its lobe to avoid sharpening the same frame twice.
        _4359 = 0.0;
    }
    else if (use_hdr_safe_path)
    {
        // Off retains Detroit's adaptive 12-tap resampling but removes the
        // negative sharpening lobes. RenoDX scales the native CAS constant;
        // addon.cpp stores the parsed slider as [0, 1].
        float sharpening_strength = shader_injection.cas_mode < 1.5
            ? 0.0
            : clamp(shader_injection.cas_strength, 0.0, 1.0);
        _4359 *= sharpening_strength;
    }
    float _4398 = _3651.x;
    float _4399 = 1.0 - _4398;
    float _4402 = _3651.y;
    float _4403 = 1.0 - _4402;
    float _4431 = (_4399 * _4403) * uintBitsToFloat(2129690299u - floatBitsToUint(0.03125 + (_5282 - _5246)));
    float _4439 = (_4398 * _4403) * uintBitsToFloat(2129690299u - floatBitsToUint(0.03125 + (_5354 - _5318)));
    float _4447 = (_4399 * _4402) * uintBitsToFloat(2129690299u - floatBitsToUint(0.03125 + (_5426 - _5390)));
    float _4455 = (_4398 * _4402) * uintBitsToFloat(2129690299u - floatBitsToUint(0.03125 + (_5498 - _5462)));
    float _4461 = (uintBitsToFloat((floatBitsToUint(clamp(min(_5246, 1.0 - _5282) * uintBitsToFloat(2129690299u - floatBitsToUint(_5282)), 0.0, 1.0)) >> 1u) + 532432441u) * _4359) * _4431;
    float _4470 = (uintBitsToFloat((floatBitsToUint(clamp(min(_5318, 1.0 - _5354) * uintBitsToFloat(2129690299u - floatBitsToUint(_5354)), 0.0, 1.0)) >> 1u) + 532432441u) * _4359) * _4439;
    float _4488 = (uintBitsToFloat((floatBitsToUint(clamp(min(_5390, 1.0 - _5426) * uintBitsToFloat(2129690299u - floatBitsToUint(_5426)), 0.0, 1.0)) >> 1u) + 532432441u) * _4359) * _4447;
    float _4489 = _4470 + _4488;
    float _4491 = _4489 + _4431;
    float _4515 = (uintBitsToFloat((floatBitsToUint(clamp(min(_5462, 1.0 - _5498) * uintBitsToFloat(2129690299u - floatBitsToUint(_5498)), 0.0, 1.0)) >> 1u) + 532432441u) * _4359) * _4455;
    float _4516 = _4461 + _4515;
    float _4518 = _4516 + _4439;
    float _4545 = _4516 + _4447;
    float _4572 = _4489 + _4455;
    float _4622 = (((((((2.0 * _4461) + (2.0 * _4470)) + (2.0 * _4488)) + (2.0 * _4515)) + _4491) + _4518) + _4545) + _4572;
    float _6003 = uintBitsToFloat(2129764351u - floatBitsToUint(_4622));
    float _6011 = _6003 * (((-_6003) * _4622) + 2.0);
    float _6022 = clamp(((((((((((((_5123.x * _4461) + (_5130.x * _4461)) + (_5144.x * _4470)) + (_5165.x * _4470)) + (_5172.x * _4488)) + (_5193.x * _4488)) + (_5207.x * _4515)) + (_5214.x * _4515)) + (_5137.x * _4491)) + (_5158.x * _4518)) + (_5179.x * _4545)) + (_5200.x * _4572)) * _6011, 0.0, 1.0);
    float _6033 = clamp(((((((((((((_3733 * _4461) + (_3772 * _4461)) + (_3746 * _4470)) + (_3811 * _4470)) + (_3824 * _4488)) + (_3889 * _4488)) + (_3863 * _4515)) + (_3902 * _4515)) + (_3785 * _4491)) + (_3798 * _4518)) + (_3837 * _4545)) + (_3850 * _4572)) * _6011, 0.0, 1.0);
    float _6044 = clamp(((((((((((((_5123.z * _4461) + (_5130.z * _4461)) + (_5144.z * _4470)) + (_5165.z * _4470)) + (_5172.z * _4488)) + (_5193.z * _4488)) + (_5207.z * _4515)) + (_5214.z * _4515)) + (_5137.z * _4491)) + (_5158.z * _4518)) + (_5179.z * _4545)) + (_5200.z * _4572)) * _6011, 0.0, 1.0);

    // input_scale is exactly 1 in Vanilla, leaving the decompiled native CAS
    // path mathematically unchanged. Custom modes restore HDR headroom here.
    vec3 _6112 = vec3(_6022, _6033, _6044) * input_scale;
    vec3 _6114 = _6112 * vec3(0.077399380505084991455078125);
    vec3 _6166 = pow((_6112 + vec3(0.054999999701976776123046875)) * vec3(0.947867333889007568359375), vec3(2.400000095367431640625));
    float _6638;
    if (_6112.x <= 0.040449999272823333740234375)
    {
        _6638 = _6114.x;
    }
    else
    {
        _6638 = _6166.x;
    }
    float _6643;
    if (_6112.y <= 0.040449999272823333740234375)
    {
        _6643 = _6114.y;
    }
    else
    {
        _6643 = _6166.y;
    }
    float _6645;
    if (_6112.z <= 0.040449999272823333740234375)
    {
        _6645 = _6114.z;
    }
    else
    {
        _6645 = _6166.z;
    }
    vec3 _6174 = pow(vec3(_6638, _6643, _6645), vec3(1.0 / _501.g_cbOETF._vfGamma.x));
    float _6075 = _6174.x;
    vec3 _6191 = vec3(_6075, _6174.yz);
    vec3 _6192 = _6191 * 12.9200000762939453125;
    vec3 _6198 = (pow(_6191, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
    float _6652;
    if (_6075 <= 0.003130800090730190277099609375)
    {
        _6652 = _6192.x;
    }
    else
    {
        _6652 = _6198.x;
    }
    float _6659;
    if (_6174.y <= 0.003130800090730190277099609375)
    {
        _6659 = _6192.y;
    }
    else
    {
        _6659 = _6198.y;
    }
    float _6661;
    if (_6174.z <= 0.003130800090730190277099609375)
    {
        _6661 = _6192.z;
    }
    else
    {
        _6661 = _6198.z;
    }
    vec3 _6250 = pow(vec3(_6652, _6659, _6661), vec3(2.2000000476837158203125));
    if (use_hdr_safe_path)
    {
        // _6250 is linear display light in Detroit's Rec.709 working gamut;
        // 1.0 maps to 300 nits before the unchanged Rec.709-to-Rec.2020/PQ tail.
        // A single scale preserves highlight chromaticity at the display peak.
        const float configured_display_peak =
            max(shader_injection.peak_white_nits, 0.0) / 300.0;
        const float output_display_peak =
            max(max(_6250.x, _6250.y), _6250.z);
        if (output_display_peak > configured_display_peak)
        {
            _6250 *= configured_display_peak /
                     max(output_display_peak, 1.0e-6);
        }
    }
    vec3 _6297 = pow((mat3(vec3(0.627399981021881103515625, 0.069099999964237213134765625, 0.01640000008046627044677734375), vec3(0.329299986362457275390625, 0.91949999332427978515625, 0.087999999523162841796875), vec3(0.0432999990880489349365234375, 0.011400000192224979400634765625, 0.895600020885467529296875)) * ((_6250 * 3.0) * 100.0)) * 9.9999997473787516355514526367188e-05, vec3(0.1593017578125));
    outColor = vec4(pow((vec3(0.8359375) + (_6297 * 18.8515625)) / (vec3(1.0) + (_6297 * 18.6875)), vec3(78.84375)), 1.0);
}
