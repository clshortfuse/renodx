#version 450
#extension GL_GOOGLE_include_directive : require
#include "./ui.glsl"

layout(set = 1, binding = 37) uniform sampler _7;
layout(set = 1, binding = 104) uniform texture2D _9;

layout(location = 0) in vec4 _3;
layout(location = 1) in vec2 _4;
layout(location = 0) out vec4 _5;

void main() {
  _5 = texture(sampler2D(_9, _7), _4).xxxx * _3;
#if 1
  _5 = FinalizeUI(_5);
#endif
}

