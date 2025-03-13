#ifndef SRC_MHWILDS_OUTPUT_HLSL_
#define SRC_MHWILDS_OUTPUT_HLSL_
#include "./shared.h"

Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);
};

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 OutputTonemap(noperspective float4 SV_Position: SV_Position,
                     linear float2 TEXCOORD: TEXCOORD) {
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _17 = (HDRMapping_000x) * 0.009999999776482582f;  // overall brightness (defaullt 100.f);
  float3 ap1_color = _11.rgb;
  // ap1_color *= _17;

  float3 untonemapped = renodx::color::bt709::from::AP1(ap1_color);
  float3 untonemapped_graded;
  // ap1_color = renodx::color::ap1::from::BT709(float3(1.f, 0, 1.f));
  float3 output_color;

  if (CUSTOM_TONE_MAP_METHOD == 1.f) {
    untonemapped_graded = untonemapped;
    untonemapped_graded *= 100.f / 203.f;

    renodx::tonemap::renodrt::Config renodrt_config = renodx::tonemap::renodrt::config::Create();
    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    renodrt_config.nits_peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS * 203.f;
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

    output_color = renodx::tonemap::renodrt::BT709(untonemapped_graded, renodrt_config);
  } else {
    // Deprecated
    renodx::lut::Config lut_config = renodx::lut::config::Create();
    lut_config.lut_sampler = TrilinearClamp;
    lut_config.size = 64u;
    lut_config.tetrahedral = true;
    lut_config.type_input = renodx::lut::config::type::LINEAR;  // We manually manage encoding/decoding
    lut_config.type_output = renodx::lut::config::type::LINEAR;
    lut_config.scaling = 0.f;
    float3 lut_input_color = renodx::color::pq::EncodeSafe(ap1_color, 100.f);
    float3 lut_output_encoded = renodx::lut::Sample(SrcLUT, lut_config, lut_input_color);
    float3 lut_output_color = renodx::color::pq::DecodeSafe(lut_output_encoded, 100.f);
    if (RENODX_TONE_MAP_TYPE == 0) {
      untonemapped_graded = lut_output_color;  // Vanilla Tone Mapping
    } else {
      float3 sdrColor;
      if (CUSTOM_SDR_TONEAMPPER == 3.f) {
        sdrColor = renodx::tonemap::renodrt::NeutralSDR(untonemapped);  // Already tonemapped
      } else if (CUSTOM_SDR_TONEAMPPER == 2.f) {
        renodx::draw::Config config = renodx::draw::BuildConfig();
        config.tone_map_type = renodx::draw::TONE_MAP_TYPE_ACES;  // aces
        sdrColor = renodx::draw::ToneMapPass(untonemapped, config);
        sdrColor = renodx::tonemap::renodrt::NeutralSDR(sdrColor);
      } else if (CUSTOM_SDR_TONEAMPPER == 1.f) {
        sdrColor = renodx::tonemap::HejlDawson(saturate(untonemapped));
      } else {
        float mid_gray = renodx::color::y::from::BT709(
            renodx::color::pq::DecodeSafe(
                renodx::lut::Sample(
                    SrcLUT, lut_config,
                    renodx::color::pq::EncodeSafe(0.18f, 100.f)),
                100.f));

        float peak = renodx::color::y::from::BT709(
            renodx::color::pq::DecodeSafe(
                renodx::lut::Sample(
                    SrcLUT, lut_config,
                    renodx::color::pq::EncodeSafe(100.f, 100.f)),
                100.f));

        sdrColor = renodx::tonemap::ReinhardScalable(untonemapped, peak);
      }

      untonemapped_graded = renodx::tonemap::UpgradeToneMap(
          untonemapped,
          sdrColor,
          lut_output_color,
          1.f);
      untonemapped_graded = lerp(untonemapped, untonemapped_graded, CUSTOM_LUT_OUTPUT_STRENGTH);
    }

    // Scale down brightness to correct levels
    untonemapped_graded *= 100.f / 203.f;

    output_color = renodx::draw::ToneMapPass(untonemapped_graded);
  }

  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    output_color = renodx::effects::ApplyFilmGrain(
        output_color.rgb,
        TEXCOORD.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
        1.f);  // if 1.f = SDR range
  }

  // Scale at the end
  output_color *= 203.f / 100.f;

  return float4(renodx::draw::SwapChainPass(output_color), 1.f);
}

#endif  // SRC_MHWILDS_OUTPUT_HLSL_
