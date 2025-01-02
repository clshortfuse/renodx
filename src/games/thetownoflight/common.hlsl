#include "./DICE.hlsl"
#include "./shared.h"

#define EXPONENTIALROLLOFFINVERSE_GENERATOR(T)                                                  \
  T ExponentialRollOffInverse(T input, float rolloff_start = 0.20f, float output_max = 1.0f) {  \
    input = min(input, output_max);                                                             \
                                                                                                \
    float rolloff_size = output_max - rolloff_start;                                            \
    T overage = -max((T)0, input - rolloff_start);                                              \
                                                                                                \
    T rolloff_value = log(renodx::math::DivideSafe(overage + rolloff_size, rolloff_size, 1.f)); \
    T new_overage = rolloff_size * rolloff_value;                                               \
                                                                                                \
    return min(rolloff_start, input) - new_overage;                                             \
  }

EXPONENTIALROLLOFFINVERSE_GENERATOR(float)
EXPONENTIALROLLOFFINVERSE_GENERATOR(float3)
#undef EXPONENTIALROLLOFFINVERSE_GENERATOR

/// Scales UI Brightness
/// Expects game brightness to be multiplied over game and UI in the final shader
float3 UIScale(float3 color) {
  if (injectedData.outputMode == 0) return color;  // Don't scale UI in SDR
  color = renodx::color::gamma::Decode(max(0, color), 2.2f);
  color *= injectedData.toneMapUINits / injectedData.toneMapGameNits;
  color = renodx::color::gamma::Encode(max(0, color), 2.2f);
  return color;
}

/// @param untonemapped the untonemapped gamma space color
/// @return the tonemapped color in gamma space
float3 applyExponentialToneMap(float3 untonemapped) {
  float3 outColor = untonemapped;

  float3 linearColor = renodx::color::gamma::Decode(max(0, outColor.rgb), 2.2);  // tonemap in linear space
  if (injectedData.outputMode == 1) {                                            // HDR Output
    if (injectedData.toneMapPeakNits / injectedData.toneMapGameNits <= 1.f) return saturate(untonemapped);

    // Don't tonemap the "SDR" range (in luminance)
    // We want to keep it looking as it used to look in SDR
    float paperWhite = injectedData.toneMapGameNits / renodx::color::srgb::REFERENCE_WHITE;
    float peakWhite = injectedData.toneMapPeakNits / renodx::color::srgb::REFERENCE_WHITE;
    float rolloff_start = paperWhite;
    linearColor = renodx::tonemap::ExponentialRollOff(linearColor * paperWhite, rolloff_start, peakWhite) / paperWhite;
  } else {  // SDR Output
    linearColor = max(0, linearColor);
    const float paperWhite = renodx::color::bt2408::REFERENCE_WHITE / renodx::color::srgb::REFERENCE_WHITE;
    const float peakWhite = paperWhite;
    const float rolloff_start = paperWhite * 0.75f;
    linearColor = renodx::tonemap::ExponentialRollOff(linearColor * paperWhite, rolloff_start, peakWhite) / paperWhite;
  }
  outColor.rgb = renodx::color::gamma::Encode(max(0, linearColor), 2.2);  // back to gamma

  return outColor;
  // Leave output in gamma space and with a paper white of 80 nits even for HDR so we can blend in the UI just like in SDR (in gamma space) and linearize with an extra pass added at the end.
}

float3 InverseExponentialToneMap(float3 tonemapped) {
  float3 linearColor = renodx::color::gamma::Decode(max(0, tonemapped), 2.2);  // tonemap in linear space

  float3 outputColor = linearColor;
  if (injectedData.outputMode == 1) {  // HDR Output
    if (injectedData.toneMapPeakNits / injectedData.toneMapGameNits <= 1.f) return tonemapped;

    float paperWhite = injectedData.toneMapGameNits / renodx::color::srgb::REFERENCE_WHITE;
    float peakWhite = injectedData.toneMapPeakNits / renodx::color::srgb::REFERENCE_WHITE;
    float rolloff_start = paperWhite;
    outputColor = ExponentialRollOffInverse(linearColor * paperWhite, rolloff_start, peakWhite) / paperWhite;
  } else {  // SDR Output
    linearColor = max(0, linearColor);
    const float paperWhite = renodx::color::bt2408::REFERENCE_WHITE / renodx::color::srgb::REFERENCE_WHITE;
    const float peakWhite = paperWhite;
    const float rolloff_start = paperWhite * 0.75f;
    linearColor = ExponentialRollOffInverse(linearColor * paperWhite, rolloff_start, peakWhite) / paperWhite;
  }

  return renodx::color::gamma::Encode(max(0, outputColor), 2.2);
}
