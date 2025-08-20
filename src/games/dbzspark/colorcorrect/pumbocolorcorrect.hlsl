#include "../shared.h"

static const float MidGray = 0.18f;

// Helper to avoid div-by-zero / NaNs
static inline float SafeRcp(float x) {
  return (x > 1e-6f) ? (1.0f / x) : 0.0f;
}
static inline float SafeInvI(float i) {
  return 1.0f / max(i, 1e-6f);
}

float CalculateMidGrayRatio(float SDRTMMidGrayIn) {
  static const float SDRTMMidGrayOut = MidGray;
  return SDRTMMidGrayOut / SDRTMMidGrayIn;
}

float3 BeginTonemapperUpgrade(float3 color, float startPoint = 0.18, float intensity = 0.5, bool tonemapInBT2020 = false) {
  float3 tonemappedHDRColor = color;  // Match mid gray with the original TM output

  if (tonemapInBT2020) tonemappedHDRColor = renodx::color::bt2020::from::BT709(tonemappedHDRColor);

  // Remap around the output's mid gray, so we keep the result "identical" below mid grey but expanded above it
  tonemappedHDRColor = (tonemappedHDRColor > startPoint) ? (pow(tonemappedHDRColor - startPoint + 1.0, intensity) + startPoint - 1.0) : tonemappedHDRColor;

  if (tonemapInBT2020) tonemappedHDRColor = renodx::color::bt709::from::BT2020(tonemappedHDRColor);

  return tonemappedHDRColor;
}

float3 EndTonemapperUpgrade(float3 color, float startPoint = 0.18, float intensity = 0.5, bool tonemapInBT2020 = false) {
  float3 tonemappedColor = color;

  if (tonemapInBT2020) tonemappedColor = renodx::color::bt2020::from::BT709(tonemappedColor);

  // This will possibly massively increase saturation, so make sure to tonemap by channel again in HDR later
  tonemappedColor = (tonemappedColor > startPoint) ? (pow(tonemappedColor - startPoint + 1.0, 1.0 / intensity) + startPoint - 1.0) : tonemappedColor;

  if (tonemapInBT2020) tonemappedColor = renodx::color::bt709::from::BT2020(tonemappedColor);

  return tonemappedColor;
}

/* float peakIn = FLT_MAX;        // The clipping point of the SDR function (values beyond this one result in the same output
float peakOut = 1.0;           // The max output of the SDR function
bool tonemapInBT2020 = false;  // Set to true to temporarily convert to BT.2020 and slightly expand the color gamut on shadow etc. This can cause very different results if the tonemapper is by channel!

color = BeginTonemapperUpgrade(color, peakIn, peakOut, float startPoint = 0.18, float intensity = 0.5, tonemapInBT2020);
color = SDRTonemapper(color);
color = EndTonemapperUpgrade(color, peakIn, peakOut, float startPoint = 0.18, float intensity = 0.5, tonemapInBT2020);

peakIn = 1.0;
peakOut = 1.0;
color = BeginTonemapperUpgrade(color, peakIn, peakOut, float startPoint = 0.18, float intensity = 0.5, tonemapInBT2020);
color = SDRLUT(color);
color = EndTonemapperUpgrade(color, peakIn, peakOut, float startPoint = 0.18, float intensity = 0.5, tonemapInBT2020); */