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

float3 DecodeHDRLutOutput(float3 color) {
  color = renodx::color::pq::DecodeSafe(color, 100.f);
  color = renodx::color::bt709::from::BT2020(color);
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

    float scaling = 1.f / 4.5f;  // Game's too bright
    if (is_sdr) {
      scaling = 1.f / 2.f;  // SDR has different exposure
    }
    untonemapped_graded = untonemapped;
    untonemapped_graded *= scaling;

    float3 vanillaSDR = untonemapped_graded;
    vanillaSDR = renodx::tonemap::renodrt::NeutralSDR(vanillaSDR, true);
    vanillaSDR = VanillaSDRTonemapper(vanillaSDR, is_sdr);

    lut_config.scaling = 0.f;
    float3 sdr_lut = PrepareLutInput(vanillaSDR);
    sdr_lut = renodx::lut::Sample(SrcLUT, lut_config, sdr_lut);

    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    renodx::tonemap::renodrt::Config renodrt_config = renodx::tonemap::renodrt::config::Create();

    if (is_sdr) {
      sdr_lut = renodx::color::srgb::DecodeSafe(sdr_lut);

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
      // HDR LUTs return PQ
      sdr_lut = DecodeHDRLutOutput(sdr_lut);

      renodx::tonemap::renodrt::Config renodrt_config = renodx::tonemap::renodrt::config::Create();
      // renodrt_config.nits_peak = RENODX_PEAK_WHITE_NITS;
      renodrt_config.exposure = draw_config.tone_map_exposure;
      renodrt_config.highlights = draw_config.tone_map_highlights;
      renodrt_config.shadows = draw_config.tone_map_shadows;
      renodrt_config.contrast = draw_config.tone_map_contrast;
      renodrt_config.saturation = draw_config.tone_map_saturation;
      renodrt_config.dechroma = draw_config.tone_map_blowout;
      renodrt_config.blowout = -1.f * (draw_config.tone_map_highlight_saturation - 1.f);
      renodrt_config.flare = 0.10f * pow(draw_config.tone_map_flare, 10.f);
      renodrt_config.per_channel = draw_config.tone_map_per_channel == 1.f;
      renodrt_config.working_color_space = (uint)draw_config.tone_map_working_color_space;

      renodrt_config.hue_correction_method = (uint)draw_config.tone_map_hue_processor;
      renodrt_config.clamp_peak = draw_config.tone_map_clamp_peak;
      renodrt_config.tone_map_method = (uint)draw_config.reno_drt_tone_map_method;

      float midgray = renodx::color::y::from::BT709(VanillaSDRTonemapper(float3(0.18f, 0.18f, 0.18f)));  // Lower brightness by midgray
      midgray = midgray * 2;                                                                             // But not too much lol
      lut_config.scaling = 1.f;

      float3 hdr_lut = PrepareLutInput(untonemapped * midgray);
      hdr_lut = renodx::lut::Sample(SrcLUT, lut_config, hdr_lut);
      hdr_lut = DecodeHDRLutOutput(hdr_lut);

      hdr_lut = renodx::tonemap::renodrt::BT709(hdr_lut, renodrt_config);

      output_color = renodx::draw::ToneMapPass(hdr_lut, sdr_lut);
    }

    renodx::draw::Config swapchainConfig = renodx::draw::BuildConfig();

    // Scale at the end
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
