#ifndef SRC_MHWILDS_OUTPUT_HLSL_
#define SRC_MHWILDS_OUTPUT_HLSL_
#include "./tonemapper.hlsl"
#include "./shared.h"
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

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  // color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

// float4 OutputTonemap(noperspective float4 SV_Position: SV_Position,
//                      linear float2 TEXCOORD: TEXCOORD, bool is_sdr = false) {
//   float4 _11 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
//   float _17 = whitePaperNits * 0.009999999776482582f;  // overall brightness (defaullt 100.f);
//   float3 ap1_color = _11.rgb;

//   renodx::lut::Config lut_config = renodx::lut::config::Create();
//   lut_config.lut_sampler = TrilinearClamp;
//   lut_config.size = 64u;
//   lut_config.tetrahedral = true;
//   lut_config.type_input = renodx::lut::config::type::LINEAR;  // We manually manage encoding/decoding
//   lut_config.type_output = renodx::lut::config::type::LINEAR;
//   lut_config.scaling = 0.f;

//   float3 untonemapped = renodx::color::bt709::from::AP1(ap1_color);
//   untonemapped = ApplyRCAS(untonemapped, TEXCOORD, SrcTexture, PointBorder);
//   float3 output_color;

//   if (RENODX_TONE_MAP_TYPE == 0.f) {
//     ap1_color *= _17;
//     float3 lutColor = PrepareLutInput(untonemapped);
//     output_color = renodx::lut::Sample(SrcLUT, lut_config, lutColor);
//   } else {
//     float3 untonemapped_graded;
//     float mid_gray_value = 0.18f;
//     float vanilla_sdr_midgray = renodx::color::y::from::BT709(VanillaSDRTonemapper(mid_gray_value.xxx, is_sdr));  // Lower brightness by midgray                                                                                                                                                                                       // But not too much lol

//     // float scaling = 1.f / 4.5f;  // Game's too bright
//     float scaling = 1.f / 2.5f;
//     if (is_sdr) {
//       scaling = 1.f / 1.f;  // SDR has different exposure
//     }
//     untonemapped_graded = untonemapped;
//     untonemapped_graded *= scaling;

//     float3 vanillaSDR = untonemapped_graded;

//     if (is_sdr) {
//       vanillaSDR = VanillaSDRTonemapper(vanillaSDR, is_sdr);
//     } else {
//       float lut_mid_gray = mid_gray_value;
//       lut_mid_gray = PrepareLutInput(lut_mid_gray.xxx).x;
//       lut_mid_gray = DecodeLutOutput(lut_mid_gray.xxx, is_sdr).x;
//       lut_mid_gray = renodx::color::y::from::BT709(lut_mid_gray);

//       float lut_peak = 100.f;
//       lut_peak = PrepareLutInput((lut_peak).xxx).x;
//       lut_peak = DecodeLutOutput(lut_peak.xxx, is_sdr).x;
//       lut_peak = renodx::color::y::from::BT709(lut_peak.xxx);

//       // midgray (in/out) controls midtones brightness
//       vanillaSDR = renodx::tonemap::ReinhardScalable(vanillaSDR, lut_peak, 0.f, lut_mid_gray, vanilla_sdr_midgray);  // slightly decrease output midgray to add dynamic range
//     }

//     float3 sdr_lut = PrepareLutInput(vanillaSDR);
//     sdr_lut = renodx::lut::Sample(SrcLUT, lut_config, sdr_lut);
//     sdr_lut = DecodeLutOutput(sdr_lut, is_sdr);

//     renodx::draw::Config draw_config = renodx::draw::BuildConfig();
//     if (is_sdr) {
//       sdr_lut = renodx::color::grade::UserColorGrading(
//           sdr_lut,
//           draw_config.tone_map_exposure,
//           draw_config.tone_map_highlights,
//           draw_config.tone_map_shadows,
//           draw_config.tone_map_contrast,
//           draw_config.tone_map_saturation,
//           draw_config.tone_map_blowout);

//       output_color = sdr_lut;
//     } else {
//       //sdr_lut = saturate(sdr_lut);

//       vanilla_sdr_midgray *= 1.f;  // Controls highlights

//       lut_config.scaling = CUSTOM_LUT_SCALING;  // 1.f is too harsh
//       //float3 hdr_lut = PrepareLutInput(untonemapped * vanilla_sdr_midgray);
//       //hdr_lut = renodx::lut::Sample(SrcLUT, lut_config, hdr_lut);
//       //hdr_lut = DecodeLutOutput(hdr_lut, is_sdr);

//       //output_color = renodx::draw::ToneMapPass(hdr_lut, sdr_lut);
      

//       // output_color = hdr_lut;
//     }

//     renodx::draw::Config swapchainConfig = renodx::draw::BuildConfig();

//     // Scale back at the end
//     output_color *= 1.f / scaling;

//     if (is_sdr) {
//       swapchainConfig.swap_chain_gamma_correction = 0.f;
//       // Normalize with HDR
//       swapchainConfig.swap_chain_scaling_nits = 1.f;
//       swapchainConfig.swap_chain_encoding = renodx::draw::ENCODING_SRGB;
//       swapchainConfig.swap_chain_encoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
//       swapchainConfig.swap_chain_clamp_color_space = renodx::color::convert::COLOR_SPACE_BT709;
//     }

//     if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
//       output_color = renodx::effects::ApplyFilmGrain(
//           output_color.rgb,
//           TEXCOORD.xy,
//           CUSTOM_RANDOM,
//           CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
//           1.f);  // if 1.f = SDR range
//     }
//     output_color = renodx::draw::SwapChainPass(output_color, TEXCOORD, swapchainConfig);
//   }

//   return float4(output_color, 1.f);
// }

float4 OutputTonemap(noperspective float4 SV_Position: SV_Position,
                     linear float2 TEXCOORD: TEXCOORD, bool is_sdr = false) {
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  // float _17 = whitePaperNits * 0.009999999776482582f;  // overall brightness (defaullt 100.f);
  float3 output_color = renodx::color::bt709::from::AP1(_11.rgb);
  //output_color = renodx::color::srgb::DecodeSafe(output_color);
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
lut_config.type_input = renodx::lut::config::type::LINEAR;  // We manually manage encoding/decoding
lut_config.type_output = renodx::lut::config::type::LINEAR;
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

      output_color = PrepareLutInput(output_color);
      output_color = renodx::lut::Sample(SrcLUT, lut_config, output_color);
      output_color = DecodeLutOutput(output_color, is_sdr);
    }
    else if (RENODX_TONE_MAP_TYPE == 0.f) {
      output_color = PrepareLutInput(output_color);
      output_color = renodx::lut::Sample(SrcLUT, lut_config, output_color);
      output_color = DecodeLutOutput(output_color);
    }
    else {

      float mid_gray = 0.18f;

      float mid_gray_adjusted = PrepareLutInput(mid_gray).x;
      mid_gray_adjusted = renodx::lut::Sample(SrcLUT, lut_config, mid_gray_adjusted).x;
      mid_gray_adjusted = DecodeLutOutput(mid_gray_adjusted).x;

      float mid_gray_scale = mid_gray_adjusted / mid_gray;
      float3 output_color_midgray_adjusted = output_color * mid_gray_scale;

      float3 lut_color = ToneMapMaxCLL(output_color, 0.375f, 20.f);

      float3 lut_color_graded = PrepareLutInput(lut_color);
      lut_color_graded = renodx::lut::Sample(SrcLUT, lut_config, lut_color_graded);
      lut_color_graded = DecodeLutOutput(lut_color_graded);
      output_color = renodx::tonemap::UpgradeToneMap(output_color_midgray_adjusted, lut_color, lut_color_graded);

      output_color *= 2.f; // LUTs cut brightness in half???

      output_color = DisplayMap(output_color, 100.f);
    }

    output_color = renodx::draw::SwapChainPass(output_color, TEXCOORD, swapchainConfig);
  

  return float4(output_color, 1.f);
}

#endif  // SRC_MHWILDS_OUTPUT_HLSL_
