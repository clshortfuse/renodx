#include "./shared.h"
#include "./colourcorrection.hlsli"

Texture2D<float4> g_xSceneTextureLinear : register(t2);

Texture3D<float4> g_xCCLutTexture : register(t4);

cbuffer ColourCorrectionPSConstants : register(b9) {
  float g_fIntensity : packoffset(c000.x);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  int _7 = int(SV_Position.x);
  int _8 = int(SV_Position.y);
  float4 _9 = g_xSceneTextureLinear.Load(int3(_7, _8, 0));
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    // Full-strength LUT; intensity is applied by the alpha blend.
    SV_Target.xyz = ApplyColourCorrectionLut(_9.xyz, g_xCCLutTexture, g_xBilinearClamp, 1.f);
    SV_Target.w = g_fIntensity * CUSTOM_LUT_STRENGTH;
    return SV_Target;
  }
  // RenoDX: the RGBA16F clone holds linear values where vanilla read an sRGB-encoded unorm view
  float3 encoded = renodx::color::srgb::EncodeSafe(saturate(_9.xyz));
  float _13 = encoded.x * 0.9375f;
  float _14 = encoded.y * 0.9375f;
  float _15 = encoded.z * 0.9375f;
  float _16 = _13 + 0.03125f;
  float _17 = _14 + 0.03125f;
  float _18 = _15 + 0.03125f;
  float4 _19 = g_xCCLutTexture.Sample(g_xBilinearClamp, float3(_16, _17, _18));
  SV_Target.x = _19.x;
  SV_Target.y = _19.y;
  SV_Target.z = _19.z;
  SV_Target.w = g_fIntensity;
  return SV_Target;
}
