#include "./shared.h"

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
    // RenoDX: gamut-compress + max-channel bridge into the LUT, then undo both.
    // Full-strength LUT; intensity is applied by the alpha blend.
    float3 adaptive_state_lms = renodx::color::lms::from::BT709(float3(1.f, 1.f, 1.f));
    float gamut_compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(_9.xyz, adaptive_state_lms, 1.f);
    float3 compressed = renodx::color::gamut::GamutCompressBT709AdaptiveD65(_9.xyz, adaptive_state_lms, gamut_compression_scale);
    float max_channel_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(compressed);
    float3 lut_input = max(0.f, compressed * max_channel_scale);
    renodx::lut::Config lut_config = renodx::lut::config::Create(
        g_xBilinearClamp,
        1.f,
        0.f,
        renodx::lut::config::type::SRGB,
        renodx::lut::config::type::LINEAR,
        16u);
    lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL == 1.f;
    float3 graded = renodx::lut::Sample(g_xCCLutTexture, lut_config, lut_input);
    SV_Target.xyz = renodx::color::gamut::GamutDecompressBT709AdaptiveD65(
        renodx::math::DivideSafe(graded, float3(max_channel_scale, max_channel_scale, max_channel_scale), graded),
        adaptive_state_lms,
        gamut_compression_scale);
    SV_Target.w = g_fIntensity * CUSTOM_LUT_STRENGTH;
    return SV_Target;
  }
  float _13 = _9.x * 0.9375f;
  float _14 = _9.y * 0.9375f;
  float _15 = _9.z * 0.9375f;
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
