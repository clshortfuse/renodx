#version 450
#extension GL_GOOGLE_include_directive : require
#include "./ui.glsl"

layout(location = 0) in vec4 _3;
layout(location = 0) out vec4 _4;

void main()
{
    _4 = _3;
#if 1
    _4 = FinalizeUI(_4);
#endif
}