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
  float gameNits;
  if (HDRPeakNits == 196.0) {  // round up to BT.2408 Reference White (203 nits)
    gameNits = 203.0;
  } else {
    gameNits = HDRPeakNits;
  }

  float3 gammaColor = g_textures2D[FullResMapSampler].Sample(g_samplers[FullResMapSamplerSS], TEXCOORD.xy).rgb;

  // UI brightness scale is a ratio of 500
  float UIBrightnessScale = SDRPaperWhiteNits / 500.0;
  gammaColor *= UIBrightnessScale;

  // linearize + convert to BT.2020 PQ
  float3 linearColor = renodx::color::gamma::DecodeSafe(gammaColor, 2.8);

  if (injectedData.toneMapType != 0) {
    linearColor = clampedHueOKLab(linearColor, injectedData.toneMapHueCorrection);

    const float paperWhite = gameNits / renodx::color::srgb::REFERENCE_WHITE;
    linearColor *= paperWhite;
    const float peakWhite = injectedData.toneMapPeakNits / renodx::color::srgb::REFERENCE_WHITE;
    const float highlightsShoulderStart = paperWhite;  // Don't tonemap the "SDR" range (in luminance), we want to keep it looking as it used to look in SDR
    linearColor = renodx::tonemap::dice::BT709(linearColor, peakWhite, highlightsShoulderStart);
    linearColor /= paperWhite;
  }

  float3 bt2020Color = renodx::color::bt2020::from::BT709(linearColor);
  float3 pqEncodedColor = renodx::color::pq::Encode(bt2020Color, gameNits);

  return float4(pqEncodedColor, 1.0);
}
