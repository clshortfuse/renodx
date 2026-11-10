#version 450
#extension GL_EXT_scalar_block_layout : require

// CUSTOM: Fixed SDR reference; the attachment supplies sRGB encoding.
#define RENODX_ZELDA_SDR 1
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
    float _97 = 1.0 / gl_FragCoord.w;
    precise float _98 = _97 * (in_attr0.x * gl_FragCoord.w);
    precise float _99 = _97 * (in_attr0.y * gl_FragCoord.w);
    vec4 _102 = texture(fs_tex2_28, vec2(_98, _99));
    vec4 _111 = texture(fs_tex2_20, vec2(_98, _99));
    float _112 = _111.x;
    float _113 = _111.y;
    float _114 = _111.z;
    float _123 = log2(uintBitsToFloat(floatBitsToUint(_102.x) & 2147483647u));
    precise float _128 = _113 * c4_3.data[5u];
    precise float _131 = _113 * c4_3.data[1u];
    precise float _135 = _113 * c4_3.data[9u];
    precise float _153 = log2(uintBitsToFloat(floatBitsToUint(_102.y) & 2147483647u)) * c4_3.data[13u];
    precise float _169 = fma(_114, c4_3.data[6u], fma(_112, c4_3.data[4u], _128)) + c4_3.data[7u];
    precise float _172 = fma(_114, c4_3.data[2u], fma(_112, c4_3.data[0u], _131)) + c4_3.data[3u];
    precise float _175 = _123 * c4_3.data[13u];
    precise float _180 = fma(_114, c4_3.data[10u], fma(_112, c4_3.data[8u], _135)) + c4_3.data[11u];
    float _185 = min(max(0.0, _169), 10000.0);
    precise float _189 = log2(uintBitsToFloat(floatBitsToUint(_102.z) & 2147483647u)) * c4_3.data[13u];
    // CUSTOM: Shared Bloom control; 50 is the original contribution, 0 disables it.
    // precise float _195 = _185 + exp2(_153);
    precise float _195 = _185 + exp2(_153) * shader_injection.bloom_strength;
    precise float _199 = _195 * c4_3.data[14u];
    // CUSTOM: Scale decoded red bloom before native exposure.
    // precise float _200 = min(max(0.0, _172), 10000.0) + exp2(_175);
    precise float _200 = min(max(0.0, _172), 10000.0) + exp2(_175) * shader_injection.bloom_strength;
    precise float _203 = _200 * c4_3.data[14u];
    // CUSTOM: Scale decoded blue bloom before native exposure.
    // precise float _204 = min(max(0.0, _180), 10000.0) + exp2(_189);
    precise float _204 = min(max(0.0, _180), 10000.0) + exp2(_189) * shader_injection.bloom_strength;
    precise float _207 = _199 * 0.715200006961822509765625;
    precise float _210 = _204 * c4_3.data[14u];
    float _220 = log2(max(fma(_210, 0.072200000286102294921875, fma(_203, 0.2125999927520751953125, _207)), 0.001000000047497451305389404296875));
    uint _221 = floatBitsToUint(_220);
    precise float _227 = _220 + uintBitsToFloat(c3.data[5u] ^ 2147483648u);
    precise float _231 = _227 * c3_1.data[8u];
    vec4 _235 = texture(fs_tex2_30, vec3(_98, _99, clamp(_231, 0.0, 1.0)));
    float _237 = _235.y;
    precise float _246 = uintBitsToFloat(c3.data[1u] ^ 2147483648u) + c3_1.data[0u];
    bool _247 = _237 != 0.0;
    uint _250;
    if (_247)
    {
        _250 = floatBitsToUint(1.0 / _237);
    }
    else
    {
        _250 = floatBitsToUint(_185);
    }
    uint _253;
    if (_247)
    {
        _253 = c3.data[7u];
    }
    else
    {
        _253 = floatBitsToUint(_123);
    }
    uint _255;
    if (!_247)
    {
        _255 = _221;
    }
    else
    {
        _255 = floatBitsToUint(_227);
    }
    uint _259;
    if (_247)
    {
        precise float _257 = _235.x * uintBitsToFloat(_250);
        _259 = floatBitsToUint(_257);
    }
    else
    {
        _259 = _250;
    }
    uint _262;
    if (_247)
    {
        _262 = c3.data[5u];
    }
    else
    {
        _262 = c3.data[0u];
    }
    uint _268;
    if (_247)
    {
        _268 = floatBitsToUint(fma(uintBitsToFloat(_259), uintBitsToFloat(_253), uintBitsToFloat(_262)));
    }
    else
    {
        _268 = _255;
    }
    precise float _271 = _220 + uintBitsToFloat(_268 ^ 2147483648u);
    precise float _283 = uintBitsToFloat(_268) + uintBitsToFloat(c3.data[9u] ^ 2147483648u);
    precise float _286 = _271 * c3_1.data[4u];
    precise float _291 = fma(_283, fma(uintBitsToFloat((!(uintBitsToFloat(_268) < c3_1.data[9u])) ? 1065353216u : 0u), _246, c3_1.data[1u]), _286);
    precise float _297 = _291 + c3_1.data[9u];
    precise float _300 = uintBitsToFloat(_221 ^ 2147483648u) + _297;
    bool _305 = !(_300 < uintBitsToFloat(c3.data[2u] ^ 2147483648u));
    uint _309;
    if (!_305)
    {
        _309 = c3.data[2u];
    }
    else
    {
        _309 = c3.data[9u];
    }
    uint _314;
    if (!_305)
    {
        precise float _312 = _300 + uintBitsToFloat(_309);
        _314 = floatBitsToUint(_312);
    }
    else
    {
        _314 = floatBitsToUint(_291);
    }
    uint _329;
    if (_305)
    {
        bool _317 = _300 > c3_1.data[3u];
        uint _319;
        if (!_317)
        {
            _319 = 0u;
        }
        else
        {
            _319 = _314;
        }
        uint _322;
        if (_317)
        {
            _322 = c3.data[3u];
        }
        else
        {
            _322 = _309;
        }
        uint _324;
        if (_317)
        {
            _324 = _322 ^ 2147483648u;
        }
        else
        {
            _324 = _322;
        }
        uint _328;
        if (_317)
        {
            precise float _326 = _300 + uintBitsToFloat(_324);
            _328 = floatBitsToUint(_326);
        }
        else
        {
            _328 = _319;
        }
        _329 = _328;
    }
    else
    {
        _329 = _314;
    }
    float _337 = exp2(min(max(uintBitsToFloat(_329), c3_1.data[10u]), c3_1.data[11u]));
    precise float _338 = _203 * _337;
    precise float _339 = _199 * _337;
    precise float _340 = _210 * _337;
    precise float _355 = _338 * fma(_338, 2.5099999904632568359375, 0.02999999932944774627685546875);
    precise float _362 = _339 * fma(_339, 2.5099999904632568359375, 0.02999999932944774627685546875);
    precise float _363 = _340 * fma(_340, 2.5099999904632568359375, 0.02999999932944774627685546875);
    precise float _366 = _355 * (1.0 / fma(_338, fma(_338, 2.4300000667572021484375, 0.589999973773956298828125), 0.14000000059604644775390625));
    precise float _368 = _362 * (1.0 / fma(_339, fma(_339, 2.4300000667572021484375, 0.589999973773956298828125), 0.14000000059604644775390625));
    precise float _370 = _363 * (1.0 / fma(_340, fma(_340, 2.4300000667572021484375, 0.589999973773956298828125), 0.14000000059604644775390625));
    frag_color0.x = clamp(_366, 0.0, 1.0);
    frag_color0.y = clamp(_368, 0.0, 1.0);
    frag_color0.z = clamp(_370, 0.0, 1.0);
    frag_color0.w = _111.w;
    // CUSTOM: Preserve Vanilla for A/B comparison; PsychoV35 targets 203/203.
    if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV35) {
        // CUSTOM: PsychoV35 bypasses native local exposure entirely.
        frag_color0.rgb = ApplySceneToneMap(float3(_200, _195, _204),
            float3(c4_3.data[14u], c4_3.data[14u], c4_3.data[14u]));
    }
}