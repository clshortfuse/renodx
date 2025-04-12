#include "./shared.h"

float3 UIScale(float3 ui_texture) {
  if (RENODX_GAMMA_CORRECTION) {
    ui_texture = renodx::color::correct::GammaSafe(ui_texture);
    ui_texture *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    ui_texture = renodx::color::correct::GammaSafe(ui_texture, true);
  } else {
    ui_texture *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  }
  return ui_texture;
}

float3 FinalizeOutput(float3 color) {
  if (RENODX_GAMMA_CORRECTION) color = renodx::color::correct::GammaSafe(color);
  color = renodx::color::bt709::clamp::AP1(color);
  color *= RENODX_DIFFUSE_WHITE_NITS / 80.f;
  return color;
}
