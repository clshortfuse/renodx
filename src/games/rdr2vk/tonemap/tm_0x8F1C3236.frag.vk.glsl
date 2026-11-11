#version 450
#extension GL_GOOGLE_include_directive : require
#include "./tonemap.glsl"
#extension GL_EXT_scalar_block_layout : require
#extension GL_EXT_samplerless_texture_functions : require

struct _12
{
    float _m0;
};

struct _14
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
    float _m4;
};

struct _13
{
    vec4 _m0;
    vec4 _m1;
    vec4 _m2;
    vec4 _m3;
    vec4 _m4;
    _14 _m5;
};

struct _16
{
    vec4 _m0;
    vec4 _m1;
    mat4 _m2;
};

struct _17
{
    vec4 _m0;
    vec4 _m1;
};

struct _18
{
    vec4 _m0;
    vec4 _m1;
    vec4 _m2;
    vec4 _m3;
    vec4 _m4;
    vec4 _m5;
    vec4 _m6;
};

struct _19
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
    float _m4;
    float _m5;
    float _m6;
};

struct _15
{
    _16 _m0[2];
    _17 _m1;
    _18 _m2;
    _19 _m3;
    vec4 _m4[3];
    vec2 _m5;
    vec2 _m6;
    vec2 _m7;
    float _m8;
    vec4 _m9[4];
    vec2 _m10;
    vec2 _m11;
    vec4 _m12;
    vec4 _m13;
    vec4 _m14;
    vec4 _m15[4];
    float _m16;
    int _m17;
    float _m18;
    float _m19;
};

struct _21
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
    float _m4;
    float _m5;
    float _m6;
    float _m7;
    float _m8;
    float _m9;
    float _m10;
    float _m11;
};

struct _22
{
    float _m0;
    float _m1;
    float _m2;
};

struct _23
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
    vec3 _m4;
    int _m5;
};

struct _20
{
    _21 _m0;
    _22 _m1;
    _23 _m2;
    vec2 _m3;
    vec2 _m4;
    vec4 _m5;
    float _m6;
    float _m7;
    uint _m8;
    float _m9;
    float _m10;
    float _m11;
    float _m12;
    float _m13;
    float _m14;
    float _m15;
    float _m16;
    float _m17;
};

struct _24
{
    vec4 _m0[5];
};

struct _25
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
    float _m4;
    float _m5;
};

struct _26
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
};

struct _27
{
    int _m0;
    int _m1;
};

struct _28
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
    float _m4;
    float _m5;
    vec2 _m6;
    float _m7;
    float _m8;
    float _m9;
    float _m10;
};

struct _11
{
    float _m0;
    vec4 _m1;
    float _m2;
    vec4 _m3;
    uvec4 _m4;
    uvec4 _m5;
    vec4 _m6;
    int _m7;
    int _m8;
    int _m9;
    vec4 _m10;
    vec4 _m11[8];
    uint _m12;
    vec3 _m13;
    vec3 _m14;
    vec2 _m15;
    vec2 _m16;
    mat3 _m17;
    vec3 _m18;
    vec3 _m19;
    float _m20;
    float _m21;
    vec3 _m22;
    vec3 _m23;
    vec3 _m24;
    vec3 _m25;
    vec4 _m26[13];
    int _m27;
    vec4 _m28;
    vec4 _m29;
    vec4 _m30;
    vec3 _m31;
    vec3 _m32;
    vec3 _m33;
    vec3 _m34;
    vec4 _m35;
    float _m36;
    float _m37;
    float _m38;
    float _m39;
    mat4 _m40;
    _12 _m41;
    _13 _m42;
    _15 _m43;
    _20 _m44;
    _24 _m45;
    _25 _m46;
    _26 _m47[5];
    vec4 _m48;
    _27 _m49;
    vec4 _m50;
    _28 _m51;
};

struct _32
{
    float _m0;
    vec3 _m1;
    vec3 _m2;
    vec3 _m3;
    float _m4;
    vec3 _m5;
    vec3 _m6;
    float _m7;
    vec3 _m8;
    vec3 _m9;
    vec2 _m10;
    vec3 _m11;
    vec4 _m12;
    vec4 _m13[4];
    vec4 _m14;
    float _m15;
    int _m16;
};

struct _33
{
    float _m0;
};

struct _35
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
    float _m4;
    float _m5;
    uint _m6;
    uint _m7;
    uvec4 _m8;
};

struct _34
{
    vec4 _m0;
    vec4 _m1;
    vec4 _m2;
    _35 _m3;
    vec2 _m4;
};

struct _37
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
};

struct _38
{
    int _m0;
};

struct _39
{
    _38 _m0;
    float _m1;
    float _m2;
    float _m3;
};

struct _36
{
    vec3 _m0;
    vec3 _m1;
    float _m2;
    float _m3;
    _37 _m4;
    float _m5;
    float _m6;
    float _m7;
    float _m8;
    float _m9;
    float _m10;
    float _m11;
    float _m12;
    float _m13;
    float _m14;
    uint _m15;
    _38 _m16;
    _38 _m17;
    _39 _m18;
    vec4 _m19;
    float _m20;
    float _m21;
    float _m22;
    float _m23;
    float _m24;
    float _m25;
    float _m26;
    float _m27;
};

struct _41
{
    vec3 _m0;
    float _m1;
};

struct _42
{
    vec4 _m0;
    vec4 _m1;
    vec4 _m2;
};

struct _43
{
    vec2 _m0;
    vec2 _m1;
    float _m2;
    float _m3;
    float _m4;
    float _m5;
    float _m6;
    float _m7;
    vec2 _m8;
    float _m9;
};

struct _44
{
    float _m0;
    _38 _m1;
};

struct _45
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
    float _m4;
    float _m5;
};

struct _46
{
    _38 _m0;
    float _m1;
    float _m2;
};

struct _48
{
    int _m0;
};

struct _47
{
    _38 _m0;
    _48 _m1;
    _48 _m2;
};

struct _49
{
    _38 _m0;
};

struct _40
{
    _41 _m0;
    vec4 _m1;
    mat4 _m2;
    mat4 _m3;
    _42 _m4;
    _43 _m5;
    _44 _m6;
    _45 _m7;
    _46 _m8;
    _47 _m9;
    _49 _m10;
    float _m11;
    float _m12;
    float _m13;
};

struct _50
{
    float _m0;
    float _m1;
    vec2 _m2;
    vec2 _m3;
    vec2 _m4;
    float _m5;
    float _m6;
    float _m7;
    float _m8;
    float _m9;
    float _m10;
};

struct _51
{
    vec4 _m0;
    vec4 _m1;
    vec4 _m2;
    vec3 _m3;
    vec3 _m4;
    vec3 _m5;
    vec3 _m6;
    vec3 _m7;
};

struct _52
{
    vec4 _m0;
    vec4 _m1;
    vec3 _m2;
};

struct _53
{
    vec4 _m0;
    vec4 _m1;
};

struct _55
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
    float _m4;
    float _m5;
    float _m6;
    float _m7;
    float _m8;
};

struct _54
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
    float _m4;
    float _m5;
    float _m6;
    float _m7;
    float _m8;
    float _m9;
    float _m10;
    float _m11;
    float _m12;
    float _m13;
    float _m14;
    float _m15;
    float _m16;
    float _m17;
    float _m18;
    _55 _m19[2];
};

struct _56
{
    vec2 _m0;
    vec2 _m1;
    vec2 _m2;
    float _m3;
    float _m4;
    float _m5;
    vec2 _m6;
};

struct _57
{
    vec4 _m0;
    vec4 _m1;
    vec2 _m2;
    float _m3;
    float _m4;
    float _m5;
};

struct _58
{
    vec3 _m0;
    float _m1;
    float _m2;
};

struct _31
{
    float _m0[32];
    float _m1[32];
    _32 _m2;
    _32 _m3;
    _33 _m4;
    _34 _m5;
    _36 _m6;
    _40 _m7;
    _50 _m8;
    _51 _m9;
    float _m10;
    vec2 _m11;
    _52 _m12;
    _53 _m13;
    float _m14;
    float _m15;
    vec4 _m16;
    _54 _m17;
    _56 _m18;
    _57 _m19;
    vec4 _m20;
    float _m21;
    uint _m22;
    uvec2 _m23;
    uvec2 _m24;
    uint _m25;
    float _m26;
    float _m27;
    float _m28;
    float _m29;
    _58 _m30;
    int _m31;
};

struct _86
{
    int _m0;
    float _m1;
    int _m2[2];
};

struct _87
{
    float _m0;
    float _m1;
    float _m2;
    float _m3;
    float _m4;
};

struct _85
{
    _86 _m0;
    _87 _m1[11];
};

float _274;

layout(set = 0, binding = 98, scalar) readonly buffer _10_29
{
    _11 _m0[];
} _29;

layout(set = 0, binding = 99, scalar) readonly buffer _30_59
{
    _31 _m0[];
} _59;

layout(set = 0, binding = 20, std140) uniform _65_66
{
    float _m0;
    float _m1;
    uint _m2;
    uint _m3;
    uint _m4;
    uint _m5;
    float _m6;
    float _m7;
    float _m8;
    float _m9;
    float _m10;
    float _m11;
    float _m12;
    float _m13;
    float _m14;
    float _m15;
    uint _m16;
    uint _m17;
    uint _m18;
    uint _m19;
} _66;

layout(set = 1, binding = 16, std140) uniform _67_68
{
    vec4 _m0;
    vec4 _m1;
    vec4 _m2;
    vec4 _m3;
    vec4 _m4;
    vec4 _m5;
    vec4 _m6;
    vec4 _m7;
    vec4 _m8;
    vec4 _m9;
    vec4 _m10;
    vec4 _m11;
    vec4 _m12;
    vec4 _m13;
    vec4 _m14;
    vec2 _m15;
    vec4 _m16;
    vec4 _m17;
    vec4 _m18;
    vec4 _m19;
    vec4 _m20;
    vec4 _m21;
    vec4 _m22;
    vec4 _m23;
    vec4 _m24;
    vec3 _m25;
    vec3 _m26;
    vec3 _m27;
    vec4 _m28;
    vec4 _m29;
    vec4 _m30;
    vec4 _m31;
    vec4 _m32;
    vec4 _m33;
    vec4 _m34;
    vec4 _m35;
    vec4 _m36;
    vec4 _m37;
    vec3 _m38;
    vec4 _m39;
    vec4 _m40;
    vec4 _m41;
    vec4 _m42;
    mat4 _m43;
    vec4 _m44;
    vec4 _m45;
    vec4 _m46;
    vec4 _m47;
    vec4 _m48;
    vec4 _m49;
    vec4 _m50;
    vec4 _m51;
    vec4 _m52;
    vec4 _m53;
    vec4 _m54;
    vec4 _m55;
    vec4 _m56;
    vec4 _m57;
    float _m58;
    vec4 _m59;
    vec4 _m60;
    float _m61;
    vec4 _m62;
    vec4 _m63;
    vec2 _m64;
    vec4 _m65;
    vec4 _m66;
    vec4 _m67;
    vec4 _m68;
    vec4 _m69;
    vec4 _m70;
    vec4 _m71;
    vec4 _m72;
    vec4 _m73;
    vec4 _m74;
    vec4 _m75;
    vec4 _m76;
    vec4 _m77;
    vec3 _m78;
    float _m79;
    vec4 _m80;
    vec4 _m81;
    vec4 _m82;
    vec4 _m83;
    vec4 _m84;
    vec4 _m85;
} _68;

layout(set = 0, binding = 214, std430) readonly buffer _84_88
{
    _85 _m0[];
} _88;

layout(set = 1, binding = 32) uniform sampler _8;
layout(set = 1, binding = 34) uniform sampler _9;
layout(set = 0, binding = 121) uniform texture2DArray _62;
layout(set = 0, binding = 140) uniform texture2D _63;
layout(set = 1, binding = 174) uniform texture2D _69;
layout(set = 1, binding = 177) uniform texture2D _70;
layout(set = 1, binding = 185) uniform texture1D _72;
layout(set = 1, binding = 40) uniform sampler _73;
layout(set = 1, binding = 186) uniform texture2D _74;
layout(set = 1, binding = 189) uniform texture2D _75;
layout(set = 1, binding = 196) uniform texture2D _76;
layout(set = 1, binding = 197) uniform texture2D _77;
layout(set = 1, binding = 202) uniform texture2D _78;
layout(set = 1, binding = 203) uniform texture2D _79;
layout(set = 1, binding = 205) uniform texture2D _80;
layout(set = 1, binding = 206) uniform texture2D _81;
layout(set = 1, binding = 207) uniform texture2D _82;
layout(set = 1, binding = 212) uniform samplerBuffer _83;

layout(location = 0) in vec4 _4;
layout(location = 1) in float _5;
layout(location = 0) out vec4 _6;

void main()
{
    vec4 _284 = texture(sampler2D(_81, _8), _4.xy);
    vec2 _285 = _284.xy;
    float _296 = _68._m0.z / ((1.0 + _68._m0.w) - textureLod(sampler2D(_69, _8), _285, 0.0).x);
    vec4 _300 = texture(sampler2D(_74, _73), _285);
    vec3 _314 = vec4(vec4(_300.xyz, 0.0).xyz * _29._m0[0u]._m1.w, _274).xyz;
    vec4 _317 = texelFetch(_83, int(0u));
    vec4 _318 = texelFetch(_83, int(1u));
    float _323 = dot(_314 * texelFetch(_63, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375));
    bool _348;
    vec3 _349;
    if (floatBitsToInt(_68._m61) != 0)
    {
        vec4 _334 = texture(sampler2D(_80, _73), _4.xy);
        float _335 = _334.w;
        bool _337 = (_335 + 9.9999997473787516355514526367188e-05) >= 1.0;
        vec3 _346;
        if (_337)
        {
            _346 = _334.xyz;
        }
        else
        {
            _346 = _334.xyz + (_314 * (1.0 - _335));
        }
        _348 = _337 ? true : false;
        _349 = _346;
    }
    else
    {
        _348 = false;
        _349 = _314;
    }
#if 1
    vec3 _353 = ConditionalClampMax(_349 * texelFetch(_63, ivec2(0), 0).x);
#else
    vec3 _353 = min(_349 * texelFetch(_63, ivec2(0), 0).x, vec3(65504.0));
#endif
    bool _354 = !_348;
    float _490;
    vec3 _491;
    if (_354)
    {
        float _413;
        if (floatBitsToInt(_68._m70.x) != 0)
        {
            float _376 = clamp(dot(texture(sampler2D(_70, _9), _285).xyz * texelFetch(_63, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), _68._m72.z, _68._m72.w);
            float _399 = clamp(((((_68._m70.y * log(_376 + _68._m72.x)) + _68._m70.z) - 10.0) + (_68._m72.y * _376)) + _68._m65.w, _68._m66.x, _68._m66.y);
            _413 = pow(2.0, mix(_5, clamp(_399 + ((abs(_399) * _68._m66.z) * float(int(sign(_399)))), _68._m66.x, _68._m66.y), clamp(_68._m70.x, 0.0, 1.0)));
        }
        else
        {
            _413 = _4.z;
        }
        vec4 _426 = texture(sampler2D(_75, _9), fract(((_4.xy * vec2(1.60000002384185791015625, 0.89999997615814208984375)) * _68._m16.w) + _68._m16.xy));
        vec3 _436 = max(_353 * vec3(0.5), _353 + vec3((_323 * (_426.w - 0.5)) * _68._m16.z));
        vec3 _489;
        if (floatBitsToInt(_68._m51.w) != 0)
        {
            vec2 _465 = ((_4.xy - _68._m50.xy) * mat2(vec2(_68._m52.x, _68._m52.y), vec2(_68._m52.z, _68._m52.w))) * _68._m50.zw;
#if 1
            float _469 = CUSTOM_VIGNETTE * max((dot(_465, _465) - _68._m53.x) * _68._m53.w, 0.0);
#else
            float _469 = max((dot(_465, _465) - _68._m53.x) * _68._m53.w, 0.0);
#endif
            bool _470 = _469 < 1.0;
            _489 = mix(_436, (_436 * _68._m51.xyz) * _68._m51.w, vec3(_470 ? (_470 ? (1.0 - pow(2.0, (-10.0) * _469)) : 1.0) : (0.9980499744415283203125 + (((_469 - 1.0) > 0.0) ? pow(2.0, 10.0 * (_469 - 2.0)) : 0.0))));
        }
        else
        {
            _489 = _436;
        }
        _490 = _413;
        _491 = _489;
    }
    else
    {
        _490 = _4.z;
        _491 = _353;
    }
    vec3 _528 = _491 * mix(mix(_68._m54.xyz, _68._m56.xyz, vec3(clamp(clamp(_4.y * _68._m57.y, 0.0, 1.0) + _68._m54.w, 0.0, 1.0))), mix(_68._m56.xyz, _68._m55.xyz, vec3(clamp(clamp(clamp(_4.y - _68._m56.w, 0.0, 1.0) * _68._m57.x, 0.0, 1.0) - _68._m55.w, 0.0, 1.0))), vec3(_4.y));
    bool _531 = _66._m3 != 0u;
    vec3 _594;
#if 1
    float midgray_in, midgray_out, slope;
    _594 = ApplyToneMap(_528, _490, _531, _66._m6, _66._m4, _66._m10,
        _317.x, _317.y, _318.x, _318.y, _318.z, _318.w, _317.z, midgray_in, midgray_out, slope);
#else
    if (_531)
    {
        vec3 _571 = max(vec3(0.0), _528 * (_490 / _66._m6));
        vec3 _574 = _571 * _317.x;
        _594 = (((((_571 * (_574 + vec3(_318.x))) + vec3(_318.y)) / ((_571 * (_574 + vec3(_317.y))) + vec3(_318.z))) - vec3(_318.w)) * ((_66._m4 != 0u) ? _66._m10 : _317.z)) * _66._m6;
    }
    else
    {
        vec3 _537 = max(vec3(0.0), _528 * _490);
        vec3 _540 = _537 * _317.x;
        _594 = clamp(((((_537 * (_540 + vec3(_318.x))) + vec3(_318.y)) / ((_537 * (_540 + vec3(_317.y))) + vec3(_318.z))) - vec3(_318.w)) * _317.z, vec3(0.0), vec3(1.0));
    }
#endif
    vec3 _642;
    if (_354)
    {
        vec3 _641;
        if (floatBitsToInt(_68._m47.w) != 0)
        {
            vec2 _627 = ((_4.xy - _68._m46.xy) * mat2(vec2(_68._m48.x, _68._m48.y), vec2(_68._m48.z, _68._m48.w))) * _68._m46.zw;
            _641 = mix(_594, _68._m47.xyz, vec3(_68._m47.w * texture(sampler1D(_72, _9), min(1.0, max((dot(_627, _627) - _68._m49.x) * _68._m49.w, 0.0))).w));
        }
        else
        {
            _641 = _594;
        }
        _642 = _641;
    }
    else
    {
        _642 = _594;
    }
    bool _663 = _531 && (!(_66._m2 != 0u));
    vec3 _665 = mix(mix((pow(_642, vec3(_66._m12)) * _66._m13) - vec3(_66._m14), _642 * _66._m11, lessThan(_642, vec3(0.003130800090730190277099609375))), _642, bvec3(_663));
    vec3 _821;
    if (_354 && (floatBitsToInt(_68._m19.x) != 0))
    {
        vec2 _677 = _4.xy * _68._m17.w;
        float _743 = (((((((fract(sin(dot(_677 + vec2(0.070000000298023223876953125 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875) + fract(sin(dot(_677 + vec2(0.10999999940395355224609375 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_677 + vec2(0.12999999523162841796875 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_677 + vec2(0.17000000178813934326171875 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_677 + vec2(0.189999997615814208984375 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_677 + vec2(0.23000000417232513427734375 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_677 + vec2(0.2899999916553497314453125 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_677 + vec2(0.310000002384185791015625 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) * 0.125;
        float _745 = clamp(_743 + _68._m17.z, 0.0, 1.0);
        vec3 _820;
        do
        {
            if (!(floatBitsToInt(_68._m18.w) != 0))
            {
                _820 = vec3(_745);
                break;
            }
            float _768;
            if (floatBitsToInt(_68._m18.y) != 0)
            {
                float _763 = dot(_665, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
                _768 = mix(_745, _745 * 0.5, (_763 * _763) * _763);
            }
            else
            {
                _768 = _745;
            }
            vec3 _819;
            if (floatBitsToInt(_68._m19.z) != 0)
            {
                vec3 _801 = vec3(_768);
                vec3 _803 = _801 * 2.0;
                _819 = mix(_665, mix(((_665 * 2.0) * (vec3(1.0) - _801)) + (sqrt(_665) * (_803 - vec3(1.0))), (_803 * _665) + ((_665 * _665) * (vec3(1.0) - _803)), lessThan(_801, vec3(0.5))), vec3(_68._m18.x));
            }
            else
            {
                vec3 _800;
                if (floatBitsToInt(_68._m19.w) != 0)
                {
                    vec3 _788 = vec3(_768);
                    _800 = mix(_665, mix(vec3(1.0) - (((vec3(1.0) - _788) * 2.0) * (vec3(1.0) - _665)), (_788 * 2.0) * _665, lessThan(_665, vec3(0.5))), vec3(_68._m18.x));
                }
                else
                {
                    _800 = clamp(max(_665 * 0.02500000037252902984619140625, _665 + vec3((_768 - 0.5) * _68._m18.x)), vec3(0.0), vec3(1.0));
                }
                _819 = _800;
            }
            _820 = _819;
            break;
        } while(false);
        _821 = _820;
    }
    else
    {
        _821 = _665;
    }
    vec3 _823 = max(_821 * mat3(vec3(0.514900028705596923828125, 0.324400007724761962890625, 0.1606999933719635009765625), vec3(0.265399992465972900390625, 0.67040002346038818359375, 0.06419999897480010986328125), vec3(0.02480000071227550506591796875, 0.1247999966144561767578125, 0.85039997100830078125)), vec3(0.00999999977648258209228515625, 0.0, 0.0));
    float _824 = _823.y;
    vec3 _849 = mix(_821, clamp((_68._m81.xyz * (_824 * ((1.33000004291534423828125 * (1.0 + ((_824 + _823.z) / _823.x))) - 1.67999994754791259765625))) * _68._m81.w, vec3(0.0), vec3(1.0)), vec3(clamp(((0.039999999105930328369140625 / (0.039999999105930328369140625 + _323)) * _68._m82.x) + _68._m82.y, 0.0, 1.0)));
    vec3 _879;
    if (floatBitsToInt(_68._m84.w) != 0)
    {
        _879 = mix(_849, texture(sampler2D(_82, _9), ((((_4.xy - vec2(0.5)) * _68._m84.z) / mix(_68._m85.wx, _68._m85.zy, _4.yx)) - _68._m84.xy) + vec2(0.5)).xyz, vec3(_68._m84.w));
    }
    else
    {
        _879 = _849;
    }
    vec3 _1037;
    if (_354)
    {
    #if 1
        float _904;
        vec3 _905 = CompressLUTInput(_879, _663, _66._m5, _66._m7, _66._m8, _66._m9, _904);
    #else
        float _898 = max(max(_879.x, max(_879.y, _879.z)), 9.9999997473787516355514526367188e-05);
        float _904 = (_663 && (!(_66._m5 != 0u))) ? 1.0 : (((_898 > _66._m7) ? ((_898 * _66._m8) + _66._m9) : _898) / _898);
        vec3 _905 = _879 * _904;
    #endif
        float _908 = _905.z;
        float _910 = floor(_908 * 14.99989986419677734375);
        float _916 = (_910 * 0.0625) + (_905.x * 0.05859375);
        float _918 = _905.y * 0.9375;
        vec4 _922 = texture(sampler2D(_78, _9), vec2(0.001953125, 0.03125) + vec2(_916, _918));
        vec4 _928 = texture(sampler2D(_78, _9), vec2(0.001953125, 0.03125) + vec2(_916 + 0.0625, _918));
        vec3 _931 = mix(_922.xyz, _928.xyz, vec3((_908 * 15.0) - _910));
        vec3 _1034;
        if (_88._m0[0u]._m0._m0 > 0)
        {
            float _965 = _931.z;
            float _967 = floor(_965 * 14.99989986419677734375);
            float _973 = (_967 * 0.0625) + (_931.x * 0.05859375);
            float _975 = _931.y * 0.9375;
            vec3 _990 = mix(_931, mix(texture(sampler2D(_76, _9), vec2(0.001953125, 0.03125) + vec2(_973, _975)).xyz, texture(sampler2D(_76, _9), vec2(0.001953125, 0.03125) + vec2(_973 + 0.0625, _975)).xyz, vec3((_965 * 15.0) - _967)), vec3(clamp(((_296 < _88._m0[0u]._m1[0]._m2) ? clamp((_296 - _88._m0[0u]._m1[0]._m0) * _88._m0[0u]._m1[0]._m1, 0.0, 1.0) : (1.0 - clamp((_296 - _88._m0[0u]._m1[0]._m2) * _88._m0[0u]._m1[0]._m3, 0.0, 1.0))) + _88._m0[0u]._m1[0]._m4, 0.0, 1.0)));
            float _1002 = _990.z;
            float _1004 = floor(_1002 * 14.99989986419677734375);
            float _1010 = (_1004 * 0.0625) + (_990.x * 0.05859375);
            float _1012 = _990.y * 0.9375;
            _1034 = mix(_990, mix(_990, mix(texture(sampler2D(_77, _9), vec2(0.001953125, 0.03125) + vec2(_1010, _1012)).xyz, texture(sampler2D(_77, _9), vec2(0.001953125, 0.03125) + vec2(_1010 + 0.0625, _1012)).xyz, vec3((_1002 * 15.0) - _1004)), vec3(clamp(((_296 < _88._m0[0u]._m1[1]._m2) ? clamp((_296 - _88._m0[0u]._m1[1]._m0) * _88._m0[0u]._m1[1]._m1, 0.0, 1.0) : (1.0 - clamp((_296 - _88._m0[0u]._m1[1]._m2) * _88._m0[0u]._m1[1]._m3, 0.0, 1.0))) + _88._m0[0u]._m1[1]._m4, 0.0, 1.0))), vec3(dot(texture(sampler2D(_79, _9), _285).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))));
        }
        else
        {
            _1034 = _931;
        }
    #if 1
        _1037 = RestoreLUTOutput(_1034, _904, _879);
    #else
        _1037 = _1034 / vec3(_904);
    #endif
    }
    else
    {
        _1037 = _879;
    }
    vec4 _1042 = vec4(_1037, dot(_1037, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625)));
    vec3 _1043 = _1042.xyz;
#if 1
    vec3 _1107 = ApplyDither(_1043, gl_FragCoord.xy, _59._m0[0u]._m22, _62,
        _531, _68._m39.xyz, _68._m40.xyz, _68._m41, _68._m42);
#else
    ivec4 _1086 = ivec4(uvec4(uvec2(ivec2(uvec2(gl_FragCoord.xy))) & uvec2(63u), uint(int(_59._m0[0u]._m22) & 31), 0u));
    vec3 _1094 = (vec3(texelFetch(_62, _1086.xyz, _1086.w).x) * 2.0) - vec3(1.0);
    vec3 _1105;
    if (_531)
    {
        _1105 = vec3(ivec3(sign(_1094))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(_1094)));
    }
    else
    {
        _1105 = _1094;
    }
    vec3 _1107 = _1043 + (_1105 * mix(_68._m39.xyz, _68._m40.xyz, pow(clamp((mix(vec3(max(_1037.x, max(_1037.y, _1037.z))), _1043, bvec3(floatBitsToInt(_68._m41.w) != 0)) - _68._m42.xyz) * _68._m41.xyz, vec3(0.0), vec3(1.0)), vec3(_68._m42.w))));
#endif
    vec4 _1108 = vec4(_1107.x, _1107.y, _1107.z, _1042.w);
    vec4 _1113;
#if 1
    _1113 = ConditionalClampOutput(_1108, _531);
#else
    if (!_531)
    {
        _1113 = clamp(_1108, vec4(0.0), vec4(1.0));
    }
    else
    {
        _1113 = _1108;
    }
#endif
#if 1
    _6 = vec4(ApplyFinalToneMap(_1113.rgb, _4.xy, midgray_in, midgray_out, slope), _1113.a);
#else
    _6 = _1113;
#endif
}

