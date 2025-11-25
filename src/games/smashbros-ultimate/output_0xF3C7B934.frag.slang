// Final output

#version 450

#include "./shared.h"

layout(set = 2, binding = 0) uniform sampler2D tex;

layout(location = 0) out vec4 colour;
layout(location = 0) in vec2 tex_coord;

void main() {
  colour = vec4(texture(tex, tex_coord).xyz, 1.0);
  colour = renodx::draw::SwapChainPass(colour);
}
