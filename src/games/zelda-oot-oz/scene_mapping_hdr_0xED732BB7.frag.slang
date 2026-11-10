#version 450
#extension GL_EXT_scalar_block_layout : require

// CUSTOM: Shared scene mapper/settings; original decompile retained below.
#include "./scene_tonemap.slangi"
#include "./aa_controls.slangi"

layout(set = 0, binding = 1, scalar) uniform fs_cbuf_block_4u
{
    uint data[16384];
} c3;

layout(set = 0, binding = 1, scalar) uniform fs_cbuf_block_4f
{
    float data[16384];
} c3_1;

layout(set = 0, binding = 2) uniform sampler2D fs_tex2_20;
layout(set = 0, binding = 3) uniform sampler2D fs_tex2_28;

layout(location = 0) in vec4 in_attr0;
layout(location = 0) out vec4 frag_color0;

void main()
{
    // CUSTOM: Same meter in the scene permutation without the local grid.
    UpdateAdaptation(fs_tex2_20, fs_tex2_28,
        float4(c3_1.data[0u], c3_1.data[1u], c3_1.data[2u], c3_1.data[3u]),
        float4(c3_1.data[4u], c3_1.data[5u], c3_1.data[6u], c3_1.data[7u]),
        float4(c3_1.data[8u], c3_1.data[9u], c3_1.data[10u], c3_1.data[11u]),
        c3_1.data[13u], float3(c3_1.data[14u], c3_1.data[14u], c3_1.data[14u]), gl_FragCoord.xy);
    float _69 = 1.0 / gl_FragCoord.w;
    precise float _70 = _69 * (in_attr0.x * gl_FragCoord.w);
    precise float _71 = _69 * (in_attr0.y * gl_FragCoord.w);
    vec4 _74 = texture(fs_tex2_28, vec2(_70, _71));
    vec4 _83 = texture(fs_tex2_20, vec2(_70, _71));
    float _84 = _83.x;
    float _85 = _83.y;
    float _86 = _83.z;
    precise float _99 = _85 * c3_1.data[5u];
    precise float _102 = _85 * c3_1.data[1u];
    precise float _106 = _85 * c3_1.data[9u];
    precise float _124 = log2(uintBitsToFloat(floatBitsToUint(_74.y) & 2147483647u)) * c3_1.data[13u];
    precise float _140 = fma(_86, c3_1.data[6u], fma(_84, c3_1.data[4u], _99)) + c3_1.data[7u];
    precise float _143 = fma(_86, c3_1.data[2u], fma(_84, c3_1.data[0u], _102)) + c3_1.data[3u];
    precise float _146 = log2(uintBitsToFloat(floatBitsToUint(_74.x) & 2147483647u)) * c3_1.data[13u];
    precise float _151 = fma(_86, c3_1.data[10u], fma(_84, c3_1.data[8u], _106)) + c3_1.data[11u];
    precise float _159 = log2(uintBitsToFloat(floatBitsToUint(_74.z) & 2147483647u)) * c3_1.data[13u];
    // CUSTOM: Scale decoded bloom before exposure and tone mapping.
    // precise float _165 = min(max(0.0, _140), 10000.0) + exp2(_124);
    precise float _165 = min(max(0.0, _140), 10000.0) + exp2(_124) * shader_injection.bloom_strength;
    precise float _169 = _165 * c3_1.data[14u];
    // CUSTOM: Bloom strength; retain the original contribution at neutral setting 50.
    // precise float _170 = min(max(0.0, _143), 10000.0) + exp2(_146);
    precise float _170 = min(max(0.0, _143), 10000.0) + exp2(_146) * shader_injection.bloom_strength;
    precise float _173 = _170 * c3_1.data[14u];
    // CUSTOM: Bloom strength.
    // precise float _179 = min(max(0.0, _151), 10000.0) + exp2(_159);
    precise float _179 = min(max(0.0, _151), 10000.0) + exp2(_159) * shader_injection.bloom_strength;
    precise float _191 = _179 * c3_1.data[14u];
    // CUSTOM: Skip the native fit/expansion for custom tonemappers.
    if (RENODX_TONE_MAP_TYPE != RENODX_TONE_MAP_TYPE_VANILLA) {
        frag_color0 = float4(ApplySceneToneMap(float3(_170, _165, _179),
            float3(c3_1.data[14u], c3_1.data[14u], c3_1.data[14u])), _83.w);
        // CUSTOM: Scene output boundary, before copy and AA.
        return;
    }
    precise float _193 = _169 * fma(_169, 2.5099999904632568359375, 0.02999999932944774627685546875);
    precise float _199 = _191 * fma(_191, 2.5099999904632568359375, 0.02999999932944774627685546875);
    precise float _202 = _173 * fma(_173, 2.5099999904632568359375, 0.02999999932944774627685546875);
    precise float _204 = _193 * (1.0 / fma(_169, fma(_169, 2.4300000667572021484375, 0.589999973773956298828125), 0.14000000059604644775390625));
    float _205 = clamp(_204, 0.0, 1.0);
    precise float _208 = _205 * 0.586600005626678466796875;
    precise float _209 = _202 * (1.0 / fma(_173, fma(_173, 2.4300000667572021484375, 0.589999973773956298828125), 0.14000000059604644775390625));
    float _210 = clamp(_209, 0.0, 1.0);
    precise float _214 = _199 * (1.0 / fma(_191, fma(_191, 2.4300000667572021484375, 0.589999973773956298828125), 0.14000000059604644775390625));
    float _215 = clamp(_214, 0.0, 1.0);
    precise float _218 = fma(_215, 0.1143999993801116943359375, fma(_210, 0.29890000820159912109375, _208));
    uint _219 = floatBitsToUint(_218);
    precise float _222 = _218 + 9.9999999747524270787835121154785e-07;
    bool _226 = !(_218 < c3_1.data[17u]);
    float _227 = 1.0 / _222;
    uint _229;
    if (!_226)
    {
        _229 = _219;
    }
    else
    {
        _229 = floatBitsToUint(_199);
    }
    uint _277;
    if (_226)
    {
        precise float _237 = _218 + uintBitsToFloat(c3.data[17u] ^ 2147483648u);
        precise float _242 = uintBitsToFloat(c3.data[17u] ^ 2147483648u) + 1.00000095367431640625;
        float _243 = 1.0 / _242;
        precise float _244 = _237 * _243;
        precise float _251 = uintBitsToFloat(c3.data[17u] ^ 2147483648u) + c3_1.data[16u];
        precise float _255 = uintBitsToFloat(floatBitsToUint(_244) ^ 2147483648u) + 1.0;
        precise float _257 = _251 * _243;
        precise float _260 = _257 + (-1.0);
        precise float _264 = _257 * _244;
        precise float _268 = log2(uintBitsToFloat(floatBitsToUint(_255) & 2147483647u)) * c3_1.data[18u];
        precise float _272 = _264 * (1.0 / fma(_260, exp2(_268), 1.0));
        _277 = floatBitsToUint(fma(_242, _272, c3_1.data[17u]));
    }
    else
    {
        _277 = _229;
    }
    precise float _281 = uintBitsToFloat(_219 ^ 2147483648u) + uintBitsToFloat(_277);
    precise float _288 = fma(_281, c3_1.data[19u], 1.0);
    precise float _293 = fma(_288, fma(_210, _227, -1.0), 1.0) * uintBitsToFloat(_277);
    precise float _295 = fma(_288, fma(_205, _227, -1.0), 1.0) * uintBitsToFloat(_277);
    precise float _297 = fma(_288, fma(_215, _227, -1.0), 1.0) * uintBitsToFloat(_277);
    frag_color0.x = min(max(0.0, _293), c3_1.data[16u]);
    frag_color0.y = min(max(0.0, _295), c3_1.data[16u]);
    frag_color0.z = min(max(0.0, _297), c3_1.data[16u]);
    frag_color0.w = _83.w;
    // CUSTOM: Preserve the unsigned render target's nonnegative vanilla output.
    frag_color0.rgb = max(float3(0.f, 0.f, 0.f), frag_color0.rgb);
    // CUSTOM: Scene output boundary, before copy and AA.
}

