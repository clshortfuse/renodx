#include "./DICE.hlsl"
#include "./shared.h"

/// Scales UI Brightness
/// Expects game brightness to be multiplied over game and UI in the final shader
float3 UIScale(float3 color, float scale) {
  if (injectedData.outputMode == 0) return color;  // Don't scale UI in SDR
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  color *= injectedData.toneMapUINits / injectedData.toneMapGameNits;
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  return color;
}

/// Applies DICE tonemapper to the untonemapped HDR color.
///
/// @param untonemapped - The untonemapped color.
/// @return The HDR color tonemapped with DICE.
float3 applyDICE(float3 untonemapped, float paperWhite = 203.f, float peakWhite = 203.f, float shoulderStart = 0.5f) {
  // Declare DICE parameters
  DICESettings config = DefaultDICESettings();
  config.Type = 3;
  config.ShoulderStart = shoulderStart;
  const float dicePaperWhite = paperWhite / renodx::color::srgb::REFERENCE_WHITE;
  const float dicePeakWhite = peakWhite / renodx::color::srgb::REFERENCE_WHITE;

  // multiply paper white in for tonemapping and out for output
  return DICETonemap(untonemapped * dicePaperWhite, dicePeakWhite, config) / dicePaperWhite;
}

/// @param untonemapped the untonemapped gamma space color
/// @return the tonemapped color in gamma space
float3 applyToneMap(float3 untonemapped) {
  float3 outColor = untonemapped;

  float3 linearColor = renodx::color::gamma::DecodeSafe(outColor.rgb, 2.2);  // tonemap in linear space
  if (injectedData.outputMode == 1) {                                        // HDR Output
    // highlightsShoulderStart = paper white
    // high shoulderStart to avoid tonemapping the "SDR" range (in luminance),
    // we want to keep it looking as it used to look in SDR
    linearColor = applyDICE(linearColor, injectedData.toneMapGameNits, injectedData.toneMapPeakNits, 0.5f);
  } else {  // SDR Output
    // set peak and paper white equal for SDR
    // Use BT.2408 Reference White as general SDR paper white value
    // https://www.itu.int/dms_pub/itu-r/opb/rep/R-REP-BT.2408-7-2023-PDF-E.pdf
    linearColor = applyDICE(linearColor, 203.f, 203.f, 0.5f);
  }

  outColor.rgb = renodx::color::gamma::EncodeSafe(linearColor, 2.2);  // back to gamma

  return outColor;
  // Leave output in gamma space and with a paper white of 80 nits even for HDR so we can blend in the UI just like in SDR (in gamma space) and linearize with an extra pass added at the end.
}
