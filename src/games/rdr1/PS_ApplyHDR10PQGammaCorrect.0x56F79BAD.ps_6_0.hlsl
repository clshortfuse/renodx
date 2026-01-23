#include "./common.hlsli"
#include "./shared.h"

Texture2D<float4> g_textures2D[] : register(t0, space2);

cbuffer Globals : register(b0) {
  float HDRPeakNits : packoffset(c000.z);
  float SDRPaperWhiteNits : packoffset(c000.w);
  uint FullResMapSampler : packoffset(c025.y);
  uint FullResMapSamplerSS : packoffset(c025.z);
};

SamplerState g_samplers[] : register(s0, space1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD)
    : SV_Target {
  float gameNits = (RENODX_TONE_MAP_TYPE != 0.f) ? RENODX_DIFFUSE_WHITE_NITS : HDRPeakNits;

  float3 gammaColor = g_textures2D[FullResMapSampler].Sample(g_samplers[FullResMapSamplerSS], TEXCOORD.xy).rgb;

  // UI brightness scale is a ratio of 500
  float UIBrightnessScale = SDRPaperWhiteNits / 500.0;
  gammaColor *= UIBrightnessScale;

  // linearize + convert to BT.2020 PQ
  float3 linearColor = renodx::color::gamma::DecodeSafe(gammaColor, 2.8);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 untonemapped = linearColor;

    if (RENODX_TONE_MAP_TYPE == 2.f) {
      float peak_ratio = RENODX_PEAK_WHITE_NITS / gameNits;
      float y_in = renodx::color::y::from::BT709(linearColor);
      float y_out = exp2(ExponentialRollOffExtended(log2(y_in), log2(peak_ratio * 0.5f), log2(peak_ratio), log2(100.f)));
      linearColor = renodx::color::correct::Luminance(linearColor, y_in, y_out);
    }

    linearColor = HueAndChrominance1ReferenceColorOKLab(
        linearColor,
        renodx::tonemap::ExponentialRollOff(untonemapped, 1.f, 4.f),
        RENODX_TONE_MAP_HUE_SHIFT,
        RENODX_TONE_MAP_BLOWOUT);
  }

  float3 bt2020Color = renodx::color::bt2020::from::BT709(linearColor);

  float3 pqEncodedColor = renodx::color::pq::Encode(bt2020Color, gameNits);

  return float4(pqEncodedColor, 1.0);
}
