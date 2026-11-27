#include "./shared.h"
Texture2D<float4> g_xTexture : register(t0);

cbuffer ScaleAndOffsetConsts : register(b0) {
  float4 g_xScaleAndOffset : packoffset(c000.x);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float _9 = g_xScaleAndOffset.x * SV_Position.x;
  float _10 = g_xScaleAndOffset.y * SV_Position.y;
  float _13 = _9 + g_xScaleAndOffset.z;
  float _14 = _10 + g_xScaleAndOffset.w;
  float4 _15 = g_xTexture.Sample(g_xBilinearClamp, float2(_13, _14));
  // RenoDX: encode with the shared intermediate pass (replaces the manual sRGB encode)
  float3 encoded = renodx::draw::RenderIntermediatePass(_15.rgb);
  return float4(encoded, _15.w);
}
