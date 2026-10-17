#include "../../shaders/color.hlsl"
#include "../../shaders/math.hlsl"

// Re-encodes the finished frame from scRGB into HDR10 so that Streamline's
// frame generation will accept it: its output path is HDR10 only, and it has
// no cross-format present, so an FP16 swap chain leaves it silently idle.
//
// Convert the game's already-tonemapped scRGB frame to HDR10 for frame
// generation. No additional tonemap or creative grade is applied. The output
// is subject to PQ encoding, gamut flooring and 10-bit quantization.

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);

float4 main(float4 vpos : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET {
  float4 color = t0.Sample(s0, uv);
  color = renodx::math::ZeroNaN(color);

  // scRGB carries linear light where 1.0 is 80 nits; PQ wants absolute nits.
  color.rgb *= 80.f;

  // scRGB is legally allowed to go negative to reach colours outside BT.709.
  // BT.2020 contains nearly all of them, and EncodeSafe floors what is left,
  // so nothing in gamut is clipped by this pair of lines.
  color.rgb = renodx::color::bt2020::from::BT709(color.rgb);
  color.rgb = renodx::color::pq::EncodeSafe(color.rgb, 1.f);

  color.a = 1.f;
  return color;
}
