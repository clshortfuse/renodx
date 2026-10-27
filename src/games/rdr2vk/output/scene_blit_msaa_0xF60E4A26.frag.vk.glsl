#version 450

layout(set = 1, binding = 40) uniform sampler _8;
layout(set = 1, binding = 186) uniform texture2D _9;

layout(location = 0) in vec2 _3;
layout(location = 0) out vec4 _5;

void main() {
  _5 = texture(sampler2D(_9, _8), _3);
}

