#version 450
#extension GL_GOOGLE_include_directive : require

layout(set = 1, binding = 40) uniform sampler _7;
layout(set = 1, binding = 186) uniform texture2D _8;

layout(location = 0) in vec2 _3;
layout(location = 0) out vec4 _4;

void main() {
  _4 = texture(sampler2D(_8, _7), _3);
}
