// Final output

#version 450

#include "./common.slangi"

layout(set = 2, binding = 0) uniform sampler2D tex;

layout(location = 0) out vec4 colour;
layout(location = 0) in vec2 tex_coord;

void main() {
  colour = vec4(texture(tex, tex_coord).xyz, 1.0);

  // colour.rgb = renodx::color::bt709::from::BT2020(colour.rgb);
  // colour.rgb = renodx::color::srgb::DecodeSafe(colour.rgb);
  colour.rgb = renodx::color::correct::GammaSafe(colour.rgb);

  bool use_pq = false;
  if (use_pq) {
    colour.rgb = renodx::color::bt2020::from::BT709(colour.rgb);
    colour.rgb = max(colour.rgb, vec3(0));
    colour.rgb = renodx::color::pq::Encode(colour.rgb, 203.f);
  } else {
    colour.rgb *= 203.f / 80.f;
  }
}
