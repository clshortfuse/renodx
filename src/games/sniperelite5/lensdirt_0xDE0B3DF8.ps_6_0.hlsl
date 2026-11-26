#include "./shared.h"

Texture2D<float4> g_xLensSurfaceDirtIntensityTexture : register(t2);

Texture2D<float4> g_xLensScatteringIntensityTexture : register(t3);

Texture2D<float4> g_xDirtTexture : register(t4);

cbuffer LensDirtFSParams : register(b10) {
  float g_fAspectRatio : packoffset(c000.x);
  float g_fLensScatteringIntensity : packoffset(c000.y);
  float g_fLensSurfaceDirtIntensity : packoffset(c000.z);
};

SamplerState g_xBilinearWrap : register(s2);

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = g_xLensSurfaceDirtIntensityTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _13 = g_xLensScatteringIntensityTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _20 = g_xDirtTexture.Sample(g_xBilinearWrap, float2((g_fAspectRatio * TEXCOORD.x), TEXCOORD.y));
  SV_Target.x = (((_20.x * _9.x) * g_fLensSurfaceDirtIntensity) + (g_fLensScatteringIntensity * _13.x));
  SV_Target.y = (((_20.y * _9.y) * g_fLensSurfaceDirtIntensity) + (g_fLensScatteringIntensity * _13.y));
  SV_Target.z = (((_20.z * _9.z) * g_fLensSurfaceDirtIntensity) + (g_fLensScatteringIntensity * _13.z));
  // RenoDX: lens dirt strength slider
  SV_Target.xyz *= CUSTOM_LENS_DIRT;
  SV_Target.w = _20.w;
  return SV_Target;
}
