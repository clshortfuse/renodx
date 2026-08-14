#include "./shared.h"

Texture2D swapchain_clone : register(t0, space0);
Texture2D<float4> additional0 : register(t1, space0);
SamplerState s0 : register(s0, space0);
float4 main(float4 vpos : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET {
  float4 ui_color = swapchain_clone.Sample(s0, uv);
  float ui_alpha = ui_color.a;
  float4 output = float4(0, 0, 0, ui_alpha);

  float3 ui_color_linear = renodx::color::srgb::DecodeSafe(ui_color.rgb);

  ui_color_linear *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  float3 ui_color_srgb = renodx::color::srgb::EncodeSafe(ui_color_linear);

  float3 scene_color_linear =
      renodx::draw::InvertIntermediatePass(additional0.Sample(s0, uv).rgb);
  float3 scene_color_srgb = renodx::color::srgb::EncodeSafe(scene_color_linear);

  float3 composited_color_srgb =
      ui_color_srgb + scene_color_srgb * (1.0 - ui_alpha);
  float3 composited_color_linear =
      renodx::color::srgb::DecodeSafe(composited_color_srgb);

  output.rgb = renodx::draw::RenderIntermediatePass(composited_color_linear);

  return renodx::draw::SwapChainPass(output);
}
