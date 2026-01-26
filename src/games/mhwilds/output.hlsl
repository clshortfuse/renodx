#ifndef SRC_MHWILDS_OUTPUT_HLSL_
#define SRC_MHWILDS_OUTPUT_HLSL_
#include "./common.hlsl"
#include "./lilium_rcas.hlsl"

Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

cbuffer HDRMapping : register(b0) {
  float whitePaperNits : packoffset(c000.x);
  float configImageAlphaScale : packoffset(c000.y);
  float displayMaxNits : packoffset(c000.z);
  float displayMinNits : packoffset(c000.w);
  float4 displayMaxNitsRect : packoffset(c001.x);
  float4 secondaryDisplayMaxNitsRect : packoffset(c002.x);
  float4 standardMaxNitsRect : packoffset(c003.x);
  float4 secondaryStandardMaxNitsRect : packoffset(c004.x);
  float2 displayMaxNitsRectSize : packoffset(c005.x);
  float2 standardMaxNitsRectSize : packoffset(c005.z);
  float4 mdrOutRangeRect : packoffset(c006.x);
  uint drawMode : packoffset(c007.x);
  float gammaForHDR : packoffset(c007.y);
  float displayMaxNitsST2084 : packoffset(c007.z);
  float displayMinNitsST2084 : packoffset(c007.w);
  uint drawModeOnMDRPass : packoffset(c008.x);
  float saturationForHDR : packoffset(c008.y);
  float2 targetInvSize : packoffset(c008.z);
  float toeEnd : packoffset(c009.x);
  float toeStrength : packoffset(c009.y);
  float blackPoint : packoffset(c009.z);
  float shoulderStartPoint : packoffset(c009.w);
  float shoulderStrength : packoffset(c010.x);
  float whitePaperNitsForOverlay : packoffset(c010.y);
  float saturationOnDisplayMapping : packoffset(c010.z);
  float graphScale : packoffset(c010.w);
  float4 hdrImageRect : packoffset(c011.x);
  float2 hdrImageRectSize : packoffset(c012.x);
  float secondaryDisplayMaxNits : packoffset(c012.z);
  float secondaryDisplayMinNits : packoffset(c012.w);
  float2 secondaryDisplayMaxNitsRectSize : packoffset(c013.x);
  float2 secondaryStandardMaxNitsRectSize : packoffset(c013.z);
  float shoulderAngle : packoffset(c014.x);
  uint enableHDRAdjustmentForOverlay : packoffset(c014.y);
  float brightnessAdjustmentForOverlay : packoffset(c014.z);
  float saturateAdjustmentForOverlay : packoffset(c014.w);
};

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

float3 PrepareLutInput(float3 color) {
  return renodx::color::pq::EncodeSafe(renodx::color::ap1::from::BT709(color), 100.f);
}

float3 DecodeLutOutput(float3 color, bool is_sdr = false) {
  if (is_sdr) {
    color = renodx::color::srgb::DecodeSafe(color);
  } else {
    color = renodx::color::pq::DecodeSafe(color, 100.f);
    color = renodx::color::bt709::from::BT2020(color);
  }
  return color;
}

float4 OutputTonemap(noperspective float4 SV_Position: SV_Position,
                     linear float2 TEXCOORD: TEXCOORD, bool is_sdr = false) {
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  // float _17 = whitePaperNits * 0.009999999776482582f;  // overall brightness (defaullt 100.f);
  float3 output_color = renodx::color::bt709::from::AP1(_11.rgb);
  // output_color = renodx::color::srgb::DecodeSafe(output_color);
  renodx::draw::Config swapchainConfig = renodx::draw::BuildConfig();

  output_color = ApplyRCAS(output_color, TEXCOORD, SrcTexture, PointBorder);

  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    output_color = renodx::effects::ApplyFilmGrain(
        output_color.rgb,
        TEXCOORD.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  }

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = TrilinearClamp;
  lut_config.size = 64u;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::PQ;  // We manually manage encoding/decoding
  lut_config.type_output = renodx::lut::config::type::PQ;
  lut_config.scaling = 0.f;

  if (is_sdr) {
    swapchainConfig.swap_chain_gamma_correction = 0.f;
    // Normalize with HDR
    swapchainConfig.swap_chain_scaling_nits = 1.f;
    swapchainConfig.swap_chain_encoding = renodx::draw::ENCODING_SRGB;
    swapchainConfig.swap_chain_encoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
    swapchainConfig.swap_chain_clamp_color_space = renodx::color::convert::COLOR_SPACE_BT709;
    swapchainConfig.graphics_white_nits = 80.f;
    swapchainConfig.diffuse_white_nits = 80.f;

    lut_config.type_output = renodx::lut::config::type::SRGB;

    if (RENODX_TONE_MAP_TYPE != 0.f) {
      float mid_gray = 0.18f;
      float mid_gray_adjusted = renodx::lut::Sample(SrcLUT, lut_config, mid_gray).x;

      float mid_gray_scale = mid_gray_adjusted / mid_gray;
      float3 output_color_midgray_adjusted = output_color * mid_gray_scale;
      float3 lut_color = ToneMapMaxCLL(output_color, 0.375f, 20.f);
      float3 lut_color_graded = renodx::lut::Sample(SrcLUT, lut_config, lut_color);
      output_color = renodx::tonemap::UpgradeToneMap(output_color, lut_color, lut_color_graded);

      output_color = PreTonemapSliders(output_color);
      float white_clip_adjusted = PreTonemapSliders(20.f).x;
      output_color = PostTonemapSliders(output_color);  // Needs to go before display map to prevent hue clip
      output_color = SDRDisplayMap(output_color, white_clip_adjusted);
    }
    else {
      output_color = renodx::lut::Sample(SrcLUT, lut_config, output_color);
    }

    // Custom tonemap parameters correct the math to work well with sRGB encode/decode, so apply fix for gamma mismatch in SDR
    if (CUSTOM_TONE_MAP_PARAMETERS == 1) {
      output_color = renodx::color::correct::GammaSafe(output_color, true);
    }
  } else if (RENODX_TONE_MAP_TYPE == 0.f) {
    output_color = renodx::lut::Sample(SrcLUT, lut_config, output_color);
  } else {
    float mid_gray = 0.18f;
    float mid_gray_adjusted = renodx::lut::Sample(SrcLUT, lut_config, mid_gray).x;

    float mid_gray_scale = mid_gray_adjusted / mid_gray;
    float3 output_color_midgray_adjusted = output_color * mid_gray_scale;
    float3 lut_color = ToneMapMaxCLL(output_color, 0.375f, 20.f);
    float3 lut_color_graded = renodx::lut::Sample(SrcLUT, lut_config, lut_color);
    output_color = renodx::tonemap::UpgradeToneMap(output_color, lut_color, lut_color_graded);

    output_color = PreTonemapSliders(output_color);
    float white_clip_adjusted = PreTonemapSliders(100.f).x;
    output_color = PostTonemapSliders(output_color);  // Needs to go before display map to prevent hue clip
    output_color = DisplayMap(output_color, white_clip_adjusted);
  }
  output_color = renodx::draw::SwapChainPass(output_color, TEXCOORD, swapchainConfig);

  return float4(output_color, 1.f);
}

#endif  // SRC_MHWILDS_OUTPUT_HLSL_
