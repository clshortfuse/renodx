#include "./shared.h"

// janky way of doing lut scaling while also doing srgb -> 2.2 conversion
// results in less black crush than doing lut scaling the normal way
float3 LUTBlackCorrection(float3 lutInputColor, float3 lutVanilla, Texture3D lutTexture, renodx::lut::Config lut_config) {
  float3 lutCorrectedBlack = renodx::lut::Sample(lutTexture, lut_config, lutInputColor);

#if 0 // if Gamma Correction is on
  // blend back with vanilla
  // helps prevent crushed blacks when doing srgb -> 2.2 gamma conversion
  float RestorationScale = 1.0f;
  float RestorationPower = 0.25f;  // Lowering raises blacks back to vanilla
  lutCorrectedBlack = lerp(lutCorrectedBlack, max(lutVanilla, 0), pow(saturate(lutCorrectedBlack / RestorationScale), RestorationPower));
#endif

  return lutCorrectedBlack;
}

// take OkLab hues and saturation from Gamma Correction
float3 HueSatCorrection(float3 incorrect_color, float3 correct_color) {
  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);

  float3 corrected_lab = float3(incorrect_lab.x, correct_lab.yz);
  float3 corrected_color = renodx::color::bt709::from::OkLab(corrected_lab);

  return corrected_color;
}