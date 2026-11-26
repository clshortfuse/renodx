#include "./shared.h"

Texture2D<float4> g_xSceneTextureLinear : register(t2);

Texture2D<float4> g_xSceneTextureSRGB : register(t3);

Texture3D<float4> g_xCCLutTexture : register(t4);

cbuffer ColourCorrectionPSConstants : register(b9) {
  float g_fIntensity : packoffset(c000.x);
};

SamplerState g_xPointClamp : register(s1);

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  // float4 _13 = g_xSceneTextureLinear.Load(int3(int(SV_Position.x), int(SV_Position.y), 0));  // custom: no longer used for LUT coords
  // float4 _23 = g_xCCLutTexture.Sample(g_xBilinearClamp, float3(((_13.x * 0.9375f) + 0.03125f), ((_13.y * 0.9375f) + 0.03125f), ((_13.z * 0.9375f) + 0.03125f)));  // custom: replaced below
  float4 _27 = g_xSceneTextureSRGB.Sample(g_xPointClamp, float2(TEXCOORD.x, TEXCOORD.y));

  // custom: HDR bridge around the SDR colour-grading LUT
  float3 hdr = _27.xyz;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float3 sdr = saturate(hdr);
    float3 graded_sdr = lerp(
        sdr,
        g_xCCLutTexture.Sample(g_xBilinearClamp, renodx::color::srgb::EncodeSafe(sdr) * 0.9375f + 0.03125f).xyz,
        g_fIntensity * CUSTOM_LUT_STRENGTH);  // RenoDX: colour grading LUT strength slider
    SV_Target.xyz = graded_sdr;
  } else {
    // RenoDX: gamut-compress + max-channel bridge into the LUT, then undo both
    float3 adaptive_state_lms = renodx::color::lms::from::BT709(float3(1.f, 1.f, 1.f));
    float gamut_compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(hdr, adaptive_state_lms, 1.f);
    float3 compressed = renodx::color::gamut::GamutCompressBT709AdaptiveD65(hdr, adaptive_state_lms, gamut_compression_scale);
    float max_channel_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(compressed);
    float3 lut_input = max(0.f, compressed * max_channel_scale);
    renodx::lut::Config lut_config = renodx::lut::config::Create(
        g_xBilinearClamp,
        g_fIntensity * CUSTOM_LUT_STRENGTH,
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
  }
  // SV_Target.x = ((g_fIntensity * (_23.x - _27.x)) + _27.x);  // custom: replaced above
  // SV_Target.y = ((g_fIntensity * (_23.y - _27.y)) + _27.y);  // custom: replaced above
  // SV_Target.z = ((g_fIntensity * (_23.z - _27.z)) + _27.z);  // custom: replaced above
  SV_Target.w = _27.w;
  return SV_Target;
}
