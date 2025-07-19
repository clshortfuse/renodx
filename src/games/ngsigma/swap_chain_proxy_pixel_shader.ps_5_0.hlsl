#include "./shared.h"

float3 applyRenoDice(float3 color) {
  //const float paperWhite = RENODX_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  const float paperWhite = RENODX_GRAPHICS_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  const float peakWhite = RENODX_PEAK_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  //const float highlightsShoulderStart = paperWhite;
  const float highlightsShoulderStart = 1.f;
  return renodx::tonemap::dice::BT709(color.rgb * paperWhite, peakWhite, highlightsShoulderStart) / paperWhite;
}

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float4 SV_Target = t0.Sample(s0, uv);

  if (RENODX_TONE_MAP_TYPE) {
    SV_Target.rgb = renodx::color::srgb::DecodeSafe(SV_Target.rgb);

    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    draw_config.peak_white_nits = 10000.f;
    draw_config.diffuse_white_nits = RENODX_GRAPHICS_WHITE_NITS;
    draw_config.graphics_white_nits = RENODX_DIFFUSE_WHITE_NITS;

    SV_Target.rgb = renodx::draw::ToneMapPass(SV_Target.rgb, draw_config);

    SV_Target.rgb = applyRenoDice(SV_Target.rgb);

    SV_Target.rgb = renodx::color::srgb::EncodeSafe(SV_Target.rgb);
  } else {
    SV_Target = saturate(SV_Target);
  }
  
  return renodx::draw::SwapChainPass(SV_Target);
}
