#include "./shared.h"

// janky way of doing lut scaling while also doing srgb -> 2.2 conversion
// results in less black crush than doing lut scaling the normal way
float3 LUTBlackCorrection(float3 lutInputColor, float3 lutVanilla, Texture3D lutTexture, renodx::lut::Config lut_config) {
  float3 lutCorrectedBlack = renodx::lut::Sample(lutTexture, lut_config, lutInputColor);

  // blend back with vanilla
  // helps prevent crushed blacks when doing srgb -> 2.2 gamma conversion
  float RestorationScale = 1.0f;
  float RestorationPower = 0.25f;  // Lowering raises blacks back to vanilla
  return lerp(lutCorrectedBlack, max(lutVanilla, 0), pow(saturate(lutCorrectedBlack / RestorationScale), RestorationPower));
}
