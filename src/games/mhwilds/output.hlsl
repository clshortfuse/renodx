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
  // ap1_color = renodx::color::ap1::from::BT709(float3(1.f, 0, 1.f));
  float3 untonemapped_graded;

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

  float3 output_color = renodx::draw::ToneMapPass(untonemapped_graded);

  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    output_color = renodx::effects::ApplyFilmGrain(
        output_color.rgb,
        TEXCOORD.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
        1.f);  // if 1.f = SDR range
  }
  output_color *= 203.f / 100.f;

  return float4(renodx::draw::SwapChainPass(output_color), 1.f);
}

#endif  // SRC_MHWILDS_OUTPUT_HLSL_
