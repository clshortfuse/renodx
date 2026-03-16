#include "./common.hlsl"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float4 color = t0.Sample(s0, uv);

  color.a = saturate(color.a);
  color.rgb = renodx::color::srgb::DecodeSafe(color.rgb);
  color.rgb = UpgradeToneMap(color.rgb, uv);
  color.rgb = renodx::draw::RenderIntermediatePass(color.rgb);

  float a = color.a;
  float3 rgb = renodx::draw::SwapChainPass(color.rgb);
  return float4(rgb, a);
}
