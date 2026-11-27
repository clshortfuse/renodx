#include "./shared.h"

Texture2D<float4> g_xTexture : register(t0);

cbuffer GammaConsts : register(b0) {
  float g_fGamma : packoffset(c000.x);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _8 = g_xTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  // RenoDX: pass the linear HDR input straight through
  if (g_fGamma == 1.0f) {
    return float4(_8.rgb, 1.0f);
  }
  float3 linear_color = renodx::draw::InvertIntermediatePass(_8.rgb);
  linear_color = select(and(linear_color > 0.0f, linear_color < 1.0f), pow(linear_color, g_fGamma), linear_color);
  return float4(renodx::draw::RenderIntermediatePass(linear_color), 1.0f);
}
