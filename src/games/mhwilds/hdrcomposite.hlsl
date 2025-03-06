#include "./shared.h"
Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);
};

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 FinalizeOutput(float3 color) {
  color = renodx::color::correct::GammaSafe(color);
  color = renodx::color::bt2020::from::BT709(color);
  color = renodx::color::pq::EncodeSafe(color, RENODX_GAME_NITS);

  return float4(color, 1.f);
}

float4 OutputTonemap(noperspective float4 SV_Position: SV_Position,
                     linear float2 TEXCOORD: TEXCOORD) {
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _17 = (HDRMapping_000x) * 0.009999999776482582f;  // overall brightness (defaullt 100.f);
  _17 = 0.3f;                                             // reduce exposure as it's too much
  if (CUSTOM_DEBUG > 0.f) {
    _17 = CUSTOM_EXPOSURE;
  }
  float3 output = _11.rgb;
  output *= _17;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = TrilinearClamp;
  lut_config.size = 64u;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::LINEAR;  // We manually manage encoding/decoding
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.scaling = 0.f;

  // LUT greatly reduces peak, so we pass it to tonemap pass instead

  float3 lutOutput = output;
  // We'll decode immediately so skip bt2020
  lutOutput = renodx::color::pq::EncodeSafe(lutOutput, 100.f);

  // Outputs PQ
  lutOutput = renodx::lut::Sample(
      SrcLUT,
      lut_config,
      lutOutput);

  // 100.f because ingame LUT encodes to 100.f I think? It's what they use everywhere (Confirmed by testing)
  lutOutput = renodx::color::pq::DecodeSafe(lutOutput, 100.f);
  // Final is now bt709
  lutOutput = renodx::tonemap::renodrt::NeutralSDR(lutOutput);

  output = renodx::color::bt709::from::AP1(output);
  float3 source = output;
  output = renodx::draw::ToneMapPass(output, lutOutput);
  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    output = renodx::effects::ApplyFilmGrain(
        output.rgb,
        TEXCOORD.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
        1.f);  // if 1.f = SDR range
  }

  if (CUSTOM_DEBUG > 0.f) {
    if (CUSTOM_OUTPUT == 2.f) {
      output = lutOutput;
    } else if (CUSTOM_OUTPUT == 1.f) {
      output = source;
    }
  }

  return FinalizeOutput(output.rgb);
}
