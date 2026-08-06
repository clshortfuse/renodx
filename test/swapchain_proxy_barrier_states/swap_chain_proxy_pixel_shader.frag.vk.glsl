#version 450

layout(set = 0, binding = 0) uniform texture2D source_texture;
layout(set = 0, binding = 1) uniform sampler source_sampler;
layout(location = 0) in vec2 input_uv;
layout(location = 0) out vec4 output_color;

void main() {
  output_color = texture(
      sampler2D(source_texture, source_sampler),
      input_uv);
}