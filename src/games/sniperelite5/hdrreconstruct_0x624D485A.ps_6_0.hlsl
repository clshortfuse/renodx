#include "./shared.h"
Texture2D<float4> g_xTexture : register(t0);

cbuffer HDRReconstructionParams : register(b0) {
  float4 gxConstantControllingLerpFractorForPerChannelReconstruction : packoffset(c000.x);
  float gfPaperWhiteNits : packoffset(c001.x);
  float gfMaxReconstructedNits : packoffset(c001.y);
  float gfGamma : packoffset(c001.z);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 _6 = g_xTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  // RenoDX: pass the sampled input straight through
  if (gfGamma == 1.0f) {
    return float4(_6.rgb, 1.0f);
  }
  float3 linear_color = renodx::draw::InvertIntermediatePass(_6.rgb);
  linear_color = select(and(linear_color > 0.0f, linear_color < 1.0f), pow(linear_color, gfGamma), linear_color);
  return float4(renodx::draw::RenderIntermediatePass(linear_color), 1.0f);
}
