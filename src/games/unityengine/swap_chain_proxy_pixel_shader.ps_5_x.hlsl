#include "./shared.h"

SamplerState sourceSampler_s : register(s0);
Texture2D<float4> sourceTexture : register(t0);

float3 FinalizeOutput(float3 color, bool gamma) {
  [branch]
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = gamma ? renodx::color::gamma::DecodeSafe(color, 2.4f) : renodx::color::correct::GammaSafe(color, false, 2.4f);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = gamma ? renodx::color::gamma::DecodeSafe(color, 2.2f) : renodx::color::correct::GammaSafe(color, false, 2.2f);
  } else {
    color = gamma ? renodx::color::srgb::DecodeSafe(color) : color;
  }
  color *= RENODX_GRAPHICS_WHITE_NITS;
  [branch]
  if (CUSTOM_COLOR_SPACE == 1.f) {
    color = renodx::color::bt709::from::BT709D93(color);
  } else if (CUSTOM_COLOR_SPACE == 2.f) {
    color = renodx::color::bt709::from::ARIBTRB9(color);
  } else if (CUSTOM_COLOR_SPACE == 3.f) {
    color = renodx::color::bt709::from::ARIBTRB927MPCD(color);
  } else if (CUSTOM_COLOR_SPACE == 4.f) {
    color = renodx::color::bt709::from::BT601NTSCU(color);
  }
  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    color = renodx::color::bt709::clamp::BT709(color);
    color = min(RENODX_DIFFUSE_WHITE_NITS, color);
  } else if(RENODX_TONE_MAP_TYPE >= 2.f) {
    color = renodx::color::lms::from::BT709(color);
    color = renodx::color::gamut::GamutCompressLMSBoundBT2020(color);
    color = renodx::color::bt709::from::LMS(color);
    float max_channel = max(max(max(color.r, color.g), color.b), RENODX_PEAK_WHITE_NITS);
    color *= RENODX_PEAK_WHITE_NITS / max_channel;  // Clamp UI or Videos
  }
  [branch]
  if(CUSTOM_SWAPCHAIN_USE_SCRGB == 0.f){
    color = renodx::color::bt2020::from::BT709(color);
    color = renodx::color::pq::EncodeSafe(color, 1.f);
  } else {
    color /= 80.f;
  }
  return color;
}

void main(
    float4 vpos: SV_Position,
    float2 texcoord: TEXCOORD,
    out float4 output: SV_Target0) {
  float4 color = sourceTexture.Sample(sourceSampler_s, texcoord.xy);
  color.rgb = FinalizeOutput(color.rgb, CUSTOM_GAMMA_SPACE != 0.f);
  output.rgba = color;
}
