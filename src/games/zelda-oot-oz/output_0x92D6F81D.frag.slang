#version 450
#extension GL_EXT_scalar_block_layout : require

// CUSTOM: Keep original encoder assignments and its matrix for Vanilla.
#include "./shared.h"

layout(set = 0, binding = 1, scalar) uniform fs_cbuf_block_4f
{
    float data[16384];
} c3;

layout(set = 0, binding = 2) uniform sampler2D fs_tex2_20;

layout(location = 0) in vec4 in_attr0;
layout(location = 0) out vec4 frag_color0;

void main()
{
    float _59 = 1.0 / gl_FragCoord.w;
    precise float _60 = _59 * (in_attr0.x * gl_FragCoord.w);
    precise float _61 = _59 * (in_attr0.y * gl_FragCoord.w);
    vec4 _64 = texture(fs_tex2_20, vec2(_60, _61));
    float _65 = _64.x;
    float _66 = _64.y;
    float _67 = _64.z;
    precise float _72 = _66 * c3.data[77u];
    precise float _76 = _66 * c3.data[73u];
    precise float _80 = _66 * c3.data[81u];
    precise float _108 = fma(_67, c3.data[78u], fma(_65, c3.data[76u], _72)) * 9.9999997473787516355514526367188e-05;
    precise float _110 = fma(_67, c3.data[74u], fma(_65, c3.data[72u], _76)) * 9.9999997473787516355514526367188e-05;
    precise float _112 = fma(_67, c3.data[82u], fma(_65, c3.data[80u], _80)) * 9.9999997473787516355514526367188e-05;
    precise float _126 = log2(uintBitsToFloat(floatBitsToUint(_108) & 2147483647u)) * 0.1593017578125;
    precise float _127 = log2(uintBitsToFloat(floatBitsToUint(_110) & 2147483647u)) * 0.1593017578125;
    float _128 = exp2(_126);
    precise float _129 = log2(uintBitsToFloat(floatBitsToUint(_112) & 2147483647u)) * 0.1593017578125;
    float _130 = exp2(_127);
    float _131 = exp2(_129);
    precise float _148 = fma(_128, 18.8515625, 0.8359375) * (1.0 / fma(_128, 18.6875, 1.0));
    precise float _150 = fma(_130, 18.8515625, 0.8359375) * (1.0 / fma(_130, 18.6875, 1.0));
    precise float _155 = fma(_131, 18.8515625, 0.8359375) * (1.0 / fma(_131, 18.6875, 1.0));
    precise float _165 = log2(uintBitsToFloat(floatBitsToUint(_148) & 2147483647u)) * 78.84375;
    precise float _166 = log2(uintBitsToFloat(floatBitsToUint(_150) & 2147483647u)) * 78.84375;
    precise float _168 = log2(uintBitsToFloat(floatBitsToUint(_155) & 2147483647u)) * 78.84375;
    frag_color0.x = exp2(_166);
    frag_color0.y = exp2(_165);
    frag_color0.z = exp2(_168);
    frag_color0.w = _64.w;
    // CUSTOM: Output-space selection is independent of the scene tonemapper.
    // Vanilla + vanilla tonemap retains the original absolute matrix/PQ path.
    if (RENODX_GLOBAL_COLOR_SPACE != 0u || RENODX_TONE_MAP_TYPE != RENODX_TONE_MAP_TYPE_VANILLA) {
        float3 custom_bt2020;
        if (RENODX_GLOBAL_COLOR_SPACE == 0u) {
            float3 custom_game_matrix_rgb = float3(
                fma(_67, c3.data[74u], fma(_65, c3.data[72u], _76)),
                fma(_67, c3.data[78u], fma(_65, c3.data[76u], _72)),
                fma(_67, c3.data[82u], fma(_65, c3.data[80u], _80)));
            // Factor out the uniform matrix's absolute neutral-white scale.
            custom_bt2020 = renodx::math::DivideSafe(
                custom_game_matrix_rgb, c3.data[72u] + c3.data[73u] + c3.data[74u]);
        } else if (RENODX_GLOBAL_COLOR_SPACE == 1u) {
            custom_bt2020 = renodx::color::bt2020::from::BT709(_64.rgb);
        } else {
            // P3 primaries with D65 white for HDR output; not theatrical DCI white.
            custom_bt2020 = mul(renodx::color::XYZ_TO_BT2020_MAT,
                mul(renodx::color::DISPLAYP3_TO_XYZ_MAT, _64.rgb));
        }
        // For a vanilla scene retain its native absolute scale when overriding
        // only the primaries. Custom scene modes already use graphics-white units.
        float custom_output_nits = RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_VANILLA
            ? c3.data[72u] + c3.data[73u] + c3.data[74u] : RENODX_GRAPHICS_WHITE_NITS;
        frag_color0.rgb = renodx::color::pq::Encode(
            max(custom_bt2020, float3(0.f, 0.f, 0.f)) * custom_output_nits / 10000.f);
    }
}

