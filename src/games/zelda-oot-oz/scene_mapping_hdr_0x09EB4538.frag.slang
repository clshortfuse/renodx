#version 450
#extension GL_EXT_scalar_block_layout : require

// CUSTOM: Shared scene mapper; original gameplay/local-exposure decompile retained below.
#include "./scene_tonemap.slangi"
#include "./aa_controls.slangi"

layout(set = 0, binding = 1, scalar) uniform fs_cbuf_block_4u
{
    uint data[16384];
} c3;

layout(set = 0, binding = 2, scalar) uniform c4
{
    uint data[16384];
} c4_1;

layout(set = 0, binding = 1, scalar) uniform fs_cbuf_block_4f
{
    float data[16384];
} c3_1;

layout(set = 0, binding = 2, scalar) uniform c4_2
{
    float data[16384];
} c4_3;

layout(set = 0, binding = 3) uniform sampler2D fs_tex2_20;
layout(set = 0, binding = 4) uniform sampler2D fs_tex2_28;
layout(set = 0, binding = 5) uniform sampler3D fs_tex2_30;

layout(location = 0) in vec4 in_attr0;
layout(location = 0) out vec4 frag_color0;

void main()
{
    // CUSTOM: One coarse meter per frame; native local-exposure path is untouched.
    UpdateAdaptation(fs_tex2_20, fs_tex2_28,
        float4(c4_3.data[0u], c4_3.data[1u], c4_3.data[2u], c4_3.data[3u]),
        float4(c4_3.data[4u], c4_3.data[5u], c4_3.data[6u], c4_3.data[7u]),
        float4(c4_3.data[8u], c4_3.data[9u], c4_3.data[10u], c4_3.data[11u]),
        c4_3.data[13u], float3(c4_3.data[14u], c4_3.data[14u], c4_3.data[14u] * c4_3.data[14u]), gl_FragCoord.xy);
    float _101 = 1.0 / gl_FragCoord.w;
    precise float _102 = _101 * (in_attr0.x * gl_FragCoord.w);
    precise float _103 = _101 * (in_attr0.y * gl_FragCoord.w);
    vec4 _106 = texture(fs_tex2_28, vec2(_102, _103));
    vec4 _115 = texture(fs_tex2_20, vec2(_102, _103));
    float _116 = _115.x;
    float _117 = _115.y;
    float _118 = _115.z;
    float _127 = log2(uintBitsToFloat(floatBitsToUint(_106.x) & 2147483647u));
    precise float _132 = _117 * c4_3.data[5u];
    precise float _135 = _117 * c4_3.data[1u];
    precise float _139 = _117 * c4_3.data[9u];
    precise float _157 = log2(uintBitsToFloat(floatBitsToUint(_106.y) & 2147483647u)) * c4_3.data[13u];
    precise float _173 = fma(_118, c4_3.data[6u], fma(_116, c4_3.data[4u], _132)) + c4_3.data[7u];
    precise float _176 = fma(_118, c4_3.data[2u], fma(_116, c4_3.data[0u], _135)) + c4_3.data[3u];
    precise float _179 = _127 * c4_3.data[13u];
    precise float _184 = fma(_118, c4_3.data[10u], fma(_116, c4_3.data[8u], _139)) + c4_3.data[11u];
    float _189 = min(max(0.0, _173), 10000.0);
    precise float _193 = log2(uintBitsToFloat(floatBitsToUint(_106.z) & 2147483647u)) * c4_3.data[13u];
    // CUSTOM: Scale decoded bloom before exposure and tone mapping.
    // precise float _199 = _189 + exp2(_157);
    precise float _199 = _189 + exp2(_157) * shader_injection.bloom_strength;
    precise float _203 = _199 * c4_3.data[14u];
    // CUSTOM: Bloom strength; retain the original contribution at neutral setting 50.
    // precise float _204 = min(max(0.0, _176), 10000.0) + exp2(_179);
    precise float _204 = min(max(0.0, _176), 10000.0) + exp2(_179) * shader_injection.bloom_strength;
    precise float _207 = _204 * c4_3.data[14u];
    // CUSTOM: Bloom strength.
    // precise float _208 = min(max(0.0, _184), 10000.0) + exp2(_193);
    precise float _208 = min(max(0.0, _184), 10000.0) + exp2(_193) * shader_injection.bloom_strength;
    precise float _211 = _203 * 0.715200006961822509765625;
    precise float _214 = _208 * c4_3.data[14u];
    float _224 = log2(max(fma(_214, 0.072200000286102294921875, fma(_207, 0.2125999927520751953125, _211)), 0.001000000047497451305389404296875));
    uint _225 = floatBitsToUint(_224);
    precise float _231 = _224 + uintBitsToFloat(c3.data[5u] ^ 2147483648u);
    precise float _235 = _231 * c3_1.data[8u];
    vec4 _239 = texture(fs_tex2_30, vec3(_102, _103, clamp(_235, 0.0, 1.0)));
    float _241 = _239.y;
    precise float _250 = uintBitsToFloat(c3.data[1u] ^ 2147483648u) + c3_1.data[0u];
    bool _251 = _241 != 0.0;
    uint _254;
    if (_251)
    {
        _254 = floatBitsToUint(1.0 / _241);
    }
    else
    {
        _254 = floatBitsToUint(_189);
    }
    uint _257;
    if (_251)
    {
        _257 = c3.data[7u];
    }
    else
    {
        _257 = floatBitsToUint(_127);
    }
    uint _259;
    if (!_251)
    {
        _259 = _225;
    }
    else
    {
        _259 = floatBitsToUint(_231);
    }
    uint _263;
    if (_251)
    {
        precise float _261 = _239.x * uintBitsToFloat(_254);
        _263 = floatBitsToUint(_261);
    }
    else
    {
        _263 = _254;
    }
    uint _266;
    if (_251)
    {
        _266 = c3.data[5u];
    }
    else
    {
        _266 = c3.data[0u];
    }
    uint _272;
    if (_251)
    {
        _272 = floatBitsToUint(fma(uintBitsToFloat(_263), uintBitsToFloat(_257), uintBitsToFloat(_266)));
    }
    else
    {
        _272 = _259;
    }
    precise float _275 = _224 + uintBitsToFloat(_272 ^ 2147483648u);
    precise float _287 = uintBitsToFloat(_272) + uintBitsToFloat(c3.data[9u] ^ 2147483648u);
    precise float _290 = _275 * c3_1.data[4u];
    precise float _295 = fma(_287, fma(uintBitsToFloat((!(uintBitsToFloat(_272) < c3_1.data[9u])) ? 1065353216u : 0u), _250, c3_1.data[1u]), _290);
    precise float _301 = _295 + c3_1.data[9u];
    precise float _304 = uintBitsToFloat(_225 ^ 2147483648u) + _301;
    bool _309 = !(_304 < uintBitsToFloat(c3.data[2u] ^ 2147483648u));
    uint _313;
    if (!_309)
    {
        _313 = c3.data[2u];
    }
    else
    {
        _313 = c3.data[9u];
    }
    uint _318;
    if (!_309)
    {
        precise float _316 = _304 + uintBitsToFloat(_313);
        _318 = floatBitsToUint(_316);
    }
    else
    {
        _318 = floatBitsToUint(_295);
    }
    uint _333;
    if (_309)
    {
        bool _321 = _304 > c3_1.data[3u];
        uint _323;
        if (!_321)
        {
            _323 = 0u;
        }
        else
        {
            _323 = _318;
        }
        uint _326;
        if (_321)
        {
            _326 = c3.data[3u];
        }
        else
        {
            _326 = _313;
        }
        uint _328;
        if (_321)
        {
            _328 = _326 ^ 2147483648u;
        }
        else
        {
            _328 = _326;
        }
        uint _332;
        if (_321)
        {
            precise float _330 = _304 + uintBitsToFloat(_328);
            _332 = floatBitsToUint(_330);
        }
        else
        {
            _332 = _323;
        }
        _333 = _332;
    }
    else
    {
        _333 = _318;
    }
    float _341 = exp2(min(max(uintBitsToFloat(_333), c3_1.data[10u]), c3_1.data[11u]));
    // CUSTOM: Scale the native local-exposure correction in stops, before either mapper.
    // Neutral setting 50 uses the original multiplier exactly; 0 applies no correction.
    float custom_local_exposure = _341;
    if (RENODX_LOCAL_EXPOSURE == 0.f) {
        custom_local_exposure = 1.f;
    } else if (RENODX_LOCAL_EXPOSURE != 1.f) {
        custom_local_exposure = exp2(
            min(max(uintBitsToFloat(_333), c3_1.data[10u]), c3_1.data[11u])
            * RENODX_LOCAL_EXPOSURE);
    }
    // precise float _342 = _203 * _341;
    // precise float _343 = _207 * _341;
    // precise float _344 = _214 * _341;
    precise float _342 = _203 * custom_local_exposure;
    precise float _343 = _207 * custom_local_exposure;
    precise float _344 = _214 * custom_local_exposure;
    // CUSTOM: Preserve local exposure, then skip the native fit/expansion.
    if (RENODX_TONE_MAP_TYPE != RENODX_TONE_MAP_TYPE_VANILLA) {
        frag_color0 = float4(ApplySceneToneMap(float3(_204, _199, _208) * custom_local_exposure,
            float3(c4_3.data[14u], c4_3.data[14u], c4_3.data[14u] * c4_3.data[14u])), _115.w);
        // CUSTOM: Scene output boundary, before copy and AA.
        return;
    }
    precise float _364 = _342 * fma(_342, 2.5099999904632568359375, 0.02999999932944774627685546875);
    precise float _366 = _343 * fma(_343, 2.5099999904632568359375, 0.02999999932944774627685546875);
    precise float _368 = _344 * fma(_344, 2.5099999904632568359375, 0.02999999932944774627685546875);
    precise float _370 = _366 * (1.0 / fma(_343, fma(_343, 2.4300000667572021484375, 0.589999973773956298828125), 0.14000000059604644775390625));
    float _371 = clamp(_370, 0.0, 1.0);
    precise float _372 = _364 * (1.0 / fma(_342, fma(_342, 2.4300000667572021484375, 0.589999973773956298828125), 0.14000000059604644775390625));
    float _373 = clamp(_372, 0.0, 1.0);
    precise float _376 = _373 * 0.586600005626678466796875;
    precise float _377 = _368 * (1.0 / fma(_344, fma(_344, 2.4300000667572021484375, 0.589999973773956298828125), 0.14000000059604644775390625));
    float _378 = clamp(_377, 0.0, 1.0);
    precise float _381 = fma(_371, 0.29890000820159912109375, _376);
    precise float _385 = fma(_378, 0.1143999993801116943359375, _381);
    uint _386 = floatBitsToUint(_385);
    precise float _389 = _385 + 9.9999999747524270787835121154785e-07;
    bool _393 = !(_385 < c4_3.data[17u]);
    float _394 = 1.0 / _389;
    uint _396;
    if (!_393)
    {
        _396 = _386;
    }
    else
    {
        _396 = floatBitsToUint(_381);
    }
    uint _442;
    if (_393)
    {
        precise float _403 = _385 + uintBitsToFloat(c4_1.data[17u] ^ 2147483648u);
        precise float _408 = uintBitsToFloat(c4_1.data[17u] ^ 2147483648u) + 1.00000095367431640625;
        float _409 = 1.0 / _408;
        precise float _410 = _403 * _409;
        precise float _417 = uintBitsToFloat(c4_1.data[17u] ^ 2147483648u) + c4_3.data[16u];
        precise float _420 = uintBitsToFloat(floatBitsToUint(_410) ^ 2147483648u) + 1.0;
        precise float _422 = _417 * _409;
        precise float _425 = _422 + (-1.0);
        precise float _429 = _422 * _410;
        precise float _433 = log2(uintBitsToFloat(floatBitsToUint(_420) & 2147483647u)) * c4_3.data[18u];
        precise float _437 = _429 * (1.0 / fma(_425, exp2(_433), 1.0));
        _442 = floatBitsToUint(fma(_408, _437, c4_3.data[17u]));
    }
    else
    {
        _442 = _396;
    }
    precise float _446 = uintBitsToFloat(_386 ^ 2147483648u) + uintBitsToFloat(_442);
    precise float _453 = fma(_446, c4_3.data[19u], 1.0);
    precise float _458 = fma(_453, fma(_371, _394, -1.0), 1.0) * uintBitsToFloat(_442);
    precise float _460 = fma(_453, fma(_373, _394, -1.0), 1.0) * uintBitsToFloat(_442);
    precise float _462 = fma(_453, fma(_378, _394, -1.0), 1.0) * uintBitsToFloat(_442);
    frag_color0.x = min(max(0.0, _458), c4_3.data[16u]);
    frag_color0.y = min(max(0.0, _460), c4_3.data[16u]);
    frag_color0.z = min(max(0.0, _462), c4_3.data[16u]);
    frag_color0.w = _115.w;
    // CUSTOM: Preserve the unsigned render target's nonnegative vanilla output.
    frag_color0.rgb = max(float3(0.f, 0.f, 0.f), frag_color0.rgb);
    // CUSTOM: Scene output boundary, before copy and AA.
}