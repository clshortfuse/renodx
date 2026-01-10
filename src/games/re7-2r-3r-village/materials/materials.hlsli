#include "../common.hlsli"

void HueShiftFire(inout float fire_r, inout float fire_g, inout float fire_b) {
  if (HUE_SHIFT_FIRE != 0.f) {
    float3 fire = float3(fire_r, fire_g, fire_b);
    float3 shifted;
    const float shoulder = 0.01f;
    const float peak = 0.75f;
    const float hue_correct_strength = 1.f;

    shifted = renodx::tonemap::ReinhardPiecewise(fire, peak, shoulder);
    fire = renodx::color::correct::Hue(fire, shifted, hue_correct_strength);
    fire = max(0, fire);

    fire_r = fire.r, fire_g = fire.g, fire_b = fire.b;
  }
}

void HueShiftFire(inout float3 fire) {
  HueShiftFire(fire.r, fire.g, fire.b);
}

