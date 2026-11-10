#version 450
#extension GL_EXT_scalar_block_layout : require
// CUSTOM: Native AA body is retained below; controls act before its encoding.
#include "./aa_controls.slangi"
#include "./aa_color.slangi"
layout(local_size_x = 128, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, scalar) uniform cs_cbuf_block_5u
{
    uint data[16384];
} c0;

layout(set = 0, binding = 0, scalar) uniform cs_cbuf_block_5f
{
    float data[16384];
} c0_1;

layout(set = 0, binding = 1) uniform sampler2D cs_tex0_a8;
layout(set = 0, binding = 2) uniform sampler2D cs_tex0_b8;
layout(set = 0, binding = 3) uniform writeonly image2D cs_img0_d0;

void main()
{
    uint _81 = ((bitfieldExtract(gl_WorkGroupID.x, int(16u), int(16u)) * 16u) << 16u) + ((bitfieldExtract(gl_WorkGroupID.x, int(0u), int(16u)) * 16u) + (gl_LocalInvocationID.x & 7u));
    uint _88 = ((bitfieldExtract(gl_WorkGroupID.y, int(16u), int(16u)) * 16u) << 16u) + ((bitfieldExtract(gl_WorkGroupID.y, int(0u), int(16u)) * 16u) + (gl_LocalInvocationID.x >> 3u));
    uint _90 = _81 + 8u;
    // CUSTOM: Paired with the upscaler's zero-strength linear branch. Return
    // before directional samples, blending, sqrt and native bit encoding.
    if (custom_aa.aa_strength == 0.f) {
        if (int(_88) <= int(c0.data[27u])) {
            if (int(_81) <= int(c0.data[26u])) {
                vec4 custom_copy = texelFetch(cs_tex0_a8,
                    ivec2(uvec2(_81 + c0.data[24u], _88 + c0.data[25u])), 0);
                imageStore(cs_img0_d0, ivec2(uvec2(_81 + c0.data[28u], _88 + c0.data[29u])), custom_copy);
            }
            if (int(_90) <= int(c0.data[26u])) {
                vec4 custom_copy = texelFetch(cs_tex0_a8,
                    ivec2(uvec2(_90 + c0.data[24u], _88 + c0.data[25u])), 0);
                imageStore(cs_img0_d0, ivec2(uvec2(_90 + c0.data[28u], _88 + c0.data[29u])), custom_copy);
            }
        }
        return;
    }
    vec4 _94 = texelFetch(cs_tex0_b8, ivec2(uvec2(_81, _88)), int(0u));
    float _95 = _94.x;
    uint _96 = floatBitsToUint(_95);
    float _97 = _94.y;
    uint _98 = floatBitsToUint(_97);
    float _99 = _94.z;
    uint _100 = floatBitsToUint(_99);
    float _101 = _94.w;
    uint _102 = floatBitsToUint(_101);
    uint _106 = _81 + c0.data[24u];
    vec4 _110 = texelFetch(cs_tex0_b8, ivec2(uvec2(_90, _88)), int(0u));
    float _111 = _110.x;
    uint _112 = floatBitsToUint(_111);
    float _113 = _110.y;
    uint _114 = floatBitsToUint(_113);
    float _115 = _110.z;
    uint _116 = floatBitsToUint(_115);
    float _117 = _110.w;
    uint _118 = floatBitsToUint(_117);
    uint _122 = _88 + c0.data[25u];
    vec4 _127 = texelFetch(cs_tex0_a8, ivec2(uvec2(_106, _122)), int(0u));
    vec4 _137 = texelFetch(cs_tex0_a8, ivec2(uvec2(_106 + 8u, _122)), int(0u));
    // CUSTOM: AA0 returned above. All remaining scene samples use the AA basis.
    _127.rgb = CustomAaWorkingRgb(_127.rgb);
    _137.rgb = CustomAaWorkingRgb(_137.rgb);
    precise float _147 = float(int(_106)) + 0.5;
    precise float _150 = float(int(_122)) + 0.5;
    precise float _154 = _150 * c0_1.data[5u];
    float _156 = max(_95, _99);
    float _157 = max(_97, _101);
    float _158 = max(_111, _115);
    float _160 = max(_113, _117);
    bool _163 = !(max(_156, _157) < 9.9999997473787516355514526367188e-06);
    precise float _167 = _147 * c0_1.data[4u];
    precise float _173 = fma(c0_1.data[4u], 8.0, _167);
    uint _176;
    if (!_163)
    {
        _176 = floatBitsToUint(_127.z);
    }
    else
    {
        _176 = floatBitsToUint(_147);
    }
    uint _251;
    uint _252;
    uint _253;
    uint _254;
    if (_163)
    {
        bool _177 = _156 > _157;
        vec4 _220 = textureLod(cs_tex0_a8, vec2(max(fma(uintBitsToFloat(_177 ? _100 : 0u), uintBitsToFloat(c0.data[4u] ^ 2147483648u), _167), c0_1.data[16u]), max(fma(uintBitsToFloat(_177 ? 0u : _102), uintBitsToFloat(c0.data[5u] ^ 2147483648u), _154), c0_1.data[17u])), 0.0);
        vec4 _226 = textureLod(cs_tex0_a8, vec2(min(fma(uintBitsToFloat(_177 ? _96 : 0u), c0_1.data[4u], _167), c0_1.data[18u]), min(fma(uintBitsToFloat(_177 ? 0u : _98), c0_1.data[5u], _154), c0_1.data[19u])), 0.0);
        // CUSTOM: Convert before directional AA blending.
        _220.rgb = CustomAaWorkingRgb(_220.rgb);
        _226.rgb = CustomAaWorkingRgb(_226.rgb);
        uint _230 = _177 ? _96 : _98;
        uint _231 = _177 ? _100 : _102;
        precise float _234 = uintBitsToFloat(_230) + uintBitsToFloat(_231);
        float _236 = 1.0 / _234;
        precise float _238 = uintBitsToFloat(_231) * _236;
        precise float _241 = uintBitsToFloat(_230) * _236;
        precise float _242 = _238 * _220.x;
        precise float _243 = _238 * _220.y;
        precise float _244 = _238 * _220.z;
        _251 = floatBitsToUint(_238);
        _252 = floatBitsToUint(fma(_241, _226.z, _244));
        _253 = floatBitsToUint(fma(_241, _226.y, _243));
        _254 = floatBitsToUint(fma(_241, _226.x, _242));
    }
    else
    {
        _251 = _102;
        _252 = _176;
        _253 = floatBitsToUint(_127.y);
        _254 = floatBitsToUint(_127.x);
    }
    uint _324;
    uint _325;
    uint _326;
    uint _327;
    if (!(max(_158, _160) < 9.9999997473787516355514526367188e-06))
    {
        bool _255 = _158 > _160;
        vec4 _294 = textureLod(cs_tex0_a8, vec2(max(fma(uintBitsToFloat(_255 ? _116 : 0u), uintBitsToFloat(c0.data[4u] ^ 2147483648u), _173), c0_1.data[16u]), max(fma(uintBitsToFloat(_255 ? 0u : _118), uintBitsToFloat(c0.data[5u] ^ 2147483648u), _154), c0_1.data[17u])), 0.0);
        vec4 _300 = textureLod(cs_tex0_a8, vec2(min(fma(uintBitsToFloat(_255 ? _112 : 0u), c0_1.data[4u], _173), c0_1.data[18u]), min(fma(uintBitsToFloat(_255 ? 0u : _114), c0_1.data[5u], _154), c0_1.data[19u])), 0.0);
        // CUSTOM: Same basis for the second pixel's directional samples.
        _294.rgb = CustomAaWorkingRgb(_294.rgb);
        _300.rgb = CustomAaWorkingRgb(_300.rgb);
        float _302 = _300.y;
        uint _305 = _255 ? _112 : _114;
        uint _306 = _255 ? _116 : _118;
        precise float _309 = uintBitsToFloat(_305) + uintBitsToFloat(_306);
        float _310 = 1.0 / _309;
        precise float _312 = uintBitsToFloat(_306) * _310;
        precise float _314 = uintBitsToFloat(_305) * _310;
        precise float _315 = _312 * _294.x;
        precise float _316 = _312 * _294.y;
        precise float _317 = _312 * _294.z;
        _324 = floatBitsToUint(fma(_314, _300.z, _317));
        _325 = floatBitsToUint(fma(_314, _302, _316));
        _326 = floatBitsToUint(fma(_314, _300.x, _315));
        _327 = floatBitsToUint(_302);
    }
    else
    {
        _324 = floatBitsToUint(_137.z);
        _325 = floatBitsToUint(_137.y);
        _326 = floatBitsToUint(_137.x);
        _327 = _251;
    }
    // CUSTOM: Strength zero retains the original color, not stale UAV contents.
    float3 custom_first = float3(uintBitsToFloat(_254), uintBitsToFloat(_253), uintBitsToFloat(_252));
    float3 custom_second = float3(uintBitsToFloat(_326), uintBitsToFloat(_325), uintBitsToFloat(_324));
    if (custom_aa.aa_strength != 1.f) {
        custom_first = lerp(_127.rgb, custom_first, custom_aa.aa_strength);
        custom_second = lerp(_137.rgb, custom_second, custom_aa.aa_strength);
    }
    _254 = floatBitsToUint(custom_first.x);
    _253 = floatBitsToUint(custom_first.y);
    _252 = floatBitsToUint(custom_first.z);
    _326 = floatBitsToUint(custom_second.x);
    _325 = floatBitsToUint(custom_second.y);
    _324 = floatBitsToUint(custom_second.z);
    bool _331 = int(_88) > int(c0.data[27u]);
    uint _338 = _88 + c0.data[29u];
    bool _344 = (int(_81) <= int(c0.data[26u])) && (!_331);
    uint _353 = _81 + c0.data[28u];
    uint _360;
    if (_344)
    {
        _360 = 1065353216u;
    }
    else
    {
        _360 = _327;
    }
    if (_344)
    {
        imageStore(cs_img0_d0, ivec2(uvec2(_353, _338)), uintBitsToFloat(uvec4(floatBitsToUint(sqrt(uintBitsToFloat(_254))) + c0.data[20u], floatBitsToUint(sqrt(uintBitsToFloat(_253))) + c0.data[21u], floatBitsToUint(sqrt(uintBitsToFloat(_252))) + c0.data[22u], _360)));
    }
    if (!((int(_90) <= int(c0.data[26u])) && (!_331)))
    {
        return;
    }
    imageStore(cs_img0_d0, ivec2(uvec2(_353 + 8u, _338)), uintBitsToFloat(uvec4(floatBitsToUint(sqrt(uintBitsToFloat(_326))) + c0.data[20u], floatBitsToUint(sqrt(uintBitsToFloat(_325))) + c0.data[21u], floatBitsToUint(sqrt(uintBitsToFloat(_324))) + c0.data[22u], 1065353216u)));
}

