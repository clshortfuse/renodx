#define RENODX_SHADER_INJECTION_UNIFORM
#include "../shared.h"

[[vk::binding(0, 0)]]
Texture2D<float4> source_texture;

float4 main(float4 position: SV_Position) : SV_Target {
  // Submission order selects one pass; disabled menu/later-UI passes
  // must not rewrite even unchanged color or alpha.
  if (RENODX_SCENE_BRIGHTNESS_ENABLED == 0.f) discard;
  float4 color = source_texture.Load(int3(int2(position.xy), 0));
  float scale = RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  if (RENODX_SDR_EOTF_EMULATION != 0.f) {
    color.rgb = sign(color.rgb) * pow(pow(abs(color.rgb), 2.2f) * scale, 1.f / 2.2f);
  } else {
    color.rgb = renodx::color::srgb::EncodeSafe(renodx::color::srgb::DecodeSafe(color.rgb) * scale);
  }
  return color;
}
