#version 450

#extension GL_GOOGLE_include_directive : require
#include "./output.glsl"

layout(set = 0, binding = 18, std140) uniform _10_11
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
} _11;

layout(set = 1, binding = 37) uniform sampler _7;
layout(set = 1, binding = 104) uniform texture2D _9;
layout(set = 1, binding = 187) uniform texture2D _12;

layout(location = 0) in vec4 _3;
layout(location = 1) in vec2 _4;
layout(location = 0) out vec4 _5;

void main()
{
    vec4 _46 = textureLod(sampler2D(_12, _7), _4, 0.0);
    float _47 = _46.w;
    float _56 = (_47 * (_11._m1 / _11._m0)) + (((1.0 - _47) * textureLod(sampler2D(_9, _7), _4, 0.0).w) * (_11._m15 / _11._m0));
    _5 = vec4(_56, _56, _56, 1.0);
}

