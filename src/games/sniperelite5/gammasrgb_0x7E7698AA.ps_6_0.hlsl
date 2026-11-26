#include "./shared.h"
Texture2D<float4> g_xTexture : register(t0);

cbuffer GammaAndClampConsts : register(b0) {
  float g_fLinearGamma : packoffset(c000.x);
  float g_fClampValue : packoffset(c000.y);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 _9 = g_xTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  // RenoDX: pass the sampled input straight through
  return float4(_9.rgb, 1.0f);
}
