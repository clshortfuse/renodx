// Final output

#version 450

layout(set = 2, binding = 0) uniform sampler2D tex;

layout(location = 0) out vec4 colour;
layout(location = 0) in vec2 tex_coord;

float encode_srgb(float channel) {
  return (channel <= 0.0031308f) ? (channel * 12.92f)
                                 : (1.055f * pow(channel, 1.f / 2.4f) - 0.055f);
}

vec3 encode_srgb(vec3 color) {
  return vec3(encode_srgb(color.r), encode_srgb(color.g), encode_srgb(color.b));
}

const mat3 BT709_TO_BT2020_MAT =
    mat3(0.6274038959, 0.3292830384, 0.0433130657, 0.0690972894, 0.9195403951,
         0.0113623156, 0.0163914389, 0.0880133079, 0.8955952532);

vec3 EncodePQ(vec3 color, float scaling) {
  float M1 = 2610.f / 16384.f;           // 0.1593017578125f;
  float M2 = 128.f * (2523.f / 4096.f);  // 78.84375f;
  float C1 = 3424.f / 4096.f;            // 0.8359375f;
  float C2 = 32.f * (2413.f / 4096.f);   // 18.8515625f;
  float C3 = 32.f * (2392.f / 4096.f);   // 18.6875f;
  color *= (scaling / 10000.f);
  vec3 y_m1 = pow(color, vec3(M1));
  return pow((vec3(C1) + vec3(C2) * y_m1) / (1.f + vec3(C3) * y_m1), vec3(M2));
}

void main() {
  colour = vec4(texture(tex, tex_coord).xyz, 1.0);
  vec3 signs = sign(colour.rgb);
  colour.rgb = abs(colour.rgb);
  colour.rgb = encode_srgb(colour.rgb);
  colour.rgb = signs * pow(colour.rgb, vec3(2.2f));

  colour.rgb = colour.rgb * BT709_TO_BT2020_MAT;
  colour.rgb = max(colour.rgb, vec3(0));
  colour.rgb = EncodePQ(colour.rgb, 203.f);
}
