#ifndef SRC_MHWILDS_OUTPUT_HLSL_
#define SRC_MHWILDS_OUTPUT_HLSL_
#include "./common.hlsl"
#include "./shared.h"

Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);
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
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _17 = (HDRMapping_000x) * 0.009999999776482582f;  // overall brightness (defaullt 100.f);
  float3 ap1_color = _11.rgb;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = TrilinearClamp;
  lut_config.size = 64u;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::LINEAR;  // We manually manage encoding/decoding
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.scaling = 0.f;

  float3 untonemapped = renodx::color::bt709::from::AP1(ap1_color);
  float3 output_color;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    ap1_color *= _17;
    float3 lutColor = PrepareLutInput(untonemapped);
    output_color = renodx::lut::Sample(SrcLUT, lut_config, lutColor);
  } else {
    float3 untonemapped_graded;
    float mid_gray_value = 0.18f;
    float vanilla_sdr_midgray = renodx::color::y::from::BT709(VanillaSDRTonemapper(mid_gray_value.xxx, is_sdr));  // Lower brightness by midgray                                                                                                                                                                                       // But not too much lol

    float scaling = 1.f / 4.5f;  // Game's too bright
    if (is_sdr) {
      scaling = 1.f / 1.f;  // SDR has different exposure
    }
    untonemapped_graded = untonemapped;
    untonemapped_graded *= scaling;

    float3 vanillaSDR = untonemapped_graded;

    if (is_sdr) {
      vanillaSDR = VanillaSDRTonemapper(vanillaSDR, is_sdr);
    } else {
      float lut_mid_gray = mid_gray_value;
      lut_mid_gray = PrepareLutInput(lut_mid_gray.xxx).x;
      lut_mid_gray = DecodeLutOutput(lut_mid_gray.xxx, is_sdr).x;
      lut_mid_gray = renodx::color::y::from::BT709(lut_mid_gray);

      float lut_peak = 100.f;
      lut_peak = PrepareLutInput((lut_peak).xxx).x;
      lut_peak = DecodeLutOutput(lut_peak.xxx, is_sdr).x;
      lut_peak = renodx::color::y::from::BT709(lut_peak.xxx);

      // midgray (in/out) controls midtones brightness
      vanillaSDR = renodx::tonemap::ReinhardScalable(vanillaSDR, lut_peak, 0.f, lut_mid_gray, vanilla_sdr_midgray * 0.95);  // slightly decrease output midgray to add dynamic range
    }

    float3 sdr_lut = PrepareLutInput(vanillaSDR);
    sdr_lut = renodx::lut::Sample(SrcLUT, lut_config, sdr_lut);
    sdr_lut = DecodeLutOutput(sdr_lut, is_sdr);

    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    if (is_sdr) {
      sdr_lut = renodx::color::grade::UserColorGrading(
          sdr_lut,
          draw_config.tone_map_exposure,
          draw_config.tone_map_highlights,
          draw_config.tone_map_shadows,
          draw_config.tone_map_contrast,
          draw_config.tone_map_saturation,
          draw_config.tone_map_blowout);

      sdr_lut = renodx::color::srgb::EncodeSafe(sdr_lut);
      output_color = sdr_lut;
    } else {
      sdr_lut = saturate(sdr_lut);

      vanilla_sdr_midgray *= 1.f;  // Controls highlights

      float3 hdr_lut = PrepareLutInput(untonemapped * vanilla_sdr_midgray);
      hdr_lut = renodx::lut::Sample(SrcLUT, lut_config, hdr_lut);
      hdr_lut = DecodeLutOutput(hdr_lut, is_sdr);

      output_color = renodx::draw::ToneMapPass(hdr_lut, sdr_lut);
      // output_color = hdr_lut;
    }

    renodx::draw::Config swapchainConfig = renodx::draw::BuildConfig();

    // Scale back at the end
    output_color *= 1.f / scaling;

    if (is_sdr) {
      swapchainConfig.swap_chain_gamma_correction = 0.f;
      // Normalize with HDR
      swapchainConfig.swap_chain_scaling_nits = 1.f;
      swapchainConfig.swap_chain_decoding = renodx::draw::ENCODING_NONE;
      swapchainConfig.swap_chain_encoding = renodx::draw::ENCODING_NONE;
      swapchainConfig.swap_chain_encoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
      swapchainConfig.swap_chain_clamp_color_space = renodx::color::convert::COLOR_SPACE_BT709;
    }

    if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
      output_color = renodx::effects::ApplyFilmGrain(
          output_color.rgb,
          TEXCOORD.xy,
          CUSTOM_RANDOM,
          CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
          1.f);  // if 1.f = SDR range
    }

    output_color = renodx::draw::SwapChainPass(output_color, swapchainConfig);
  }

  return float4(output_color, 1.f);
}

#endif  // SRC_MHWILDS_OUTPUT_HLSL_
