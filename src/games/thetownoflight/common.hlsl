#include "./shared.h"

#define EXPONENTIALROLLOFFINVERSE_GENERATOR(T)                                                 \
  T ExponentialRollOffInverse(T input, float rolloff_start = 0.20f, float output_max = 1.0f) { \
    input = min(input, output_max);                                                            \
                                                                                               \
    float rolloff_size = output_max - rolloff_start;                                           \
    T overage = -max((T)0, input - rolloff_start);                                             \
                                                                                               \
    T rolloff_value = log((overage + rolloff_size) / rolloff_size);                            \
    T new_overage = rolloff_size * rolloff_value;                                              \
                                                                                               \
    return min(rolloff_start, input) - new_overage;                                            \
  }

EXPONENTIALROLLOFFINVERSE_GENERATOR(float)
EXPONENTIALROLLOFFINVERSE_GENERATOR(float3)
#undef EXPONENTIALROLLOFFINVERSE_GENERATOR

/// Scales UI Brightness
/// Expects game brightness to be multiplied over game and UI in the final shader
float3 UIScale(float3 color, float scale) {
  if (injectedData.outputMode == 0) return color;  // Don't scale UI in SDR
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  color *= injectedData.toneMapUINits / injectedData.toneMapGameNits;
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  return color;
}

/// @param untonemapped the untonemapped gamma space color
/// @return the tonemapped color in gamma space
float3 applyToneMap(float3 untonemapped) {
  float3 outColor = untonemapped;

  float3 linearColor = renodx::color::gamma::DecodeSafe(outColor.rgb, 2.2);  // tonemap in linear space
  if (injectedData.outputMode == 1) {                                        // HDR Output
    // highlightsShoulderStart = paper white
    // Don't tonemap the "SDR" range (in luminance), we want to keep it looking as it used to look in SDR
    // linearColor = applyDICETonemap(linearColor, injectedData.toneMapGameNits, injectedData.toneMapPeakNits, injectedData.toneMapGameNits);

    if (injectedData.toneMapPeakNits / injectedData.toneMapGameNits <= 1.f) {
      linearColor = saturate(linearColor);
    } else {
      float paperWhite = injectedData.toneMapGameNits / 80.f;
      float peakWhite = injectedData.toneMapPeakNits / 80.f;
      float highlightsShoulderStart = paperWhite;
      linearColor = renodx::tonemap::ExponentialRollOff(linearColor * paperWhite, paperWhite, peakWhite) / paperWhite;
      if (injectedData.testInverse) {
        linearColor = ExponentialRollOffInverse(linearColor * paperWhite, paperWhite, peakWhite) / paperWhite;
        linearColor = renodx::tonemap::ExponentialRollOff(linearColor * paperWhite, paperWhite, peakWhite) / paperWhite;
      }
    }
  } else {  // SDR Output
    // lower highlightsShoulderStart and set peak and paper white equal for SDR
    // Use BT.2408 Reference White as general SDR paper white value
    // https://www.itu.int/dms_pub/itu-r/opb/rep/R-REP-BT.2408-7-2023-PDF-E.pdf
    // linearColor = applyDICETonemap(linearColor, 203.f, 203.f, 203.f * 0.5f);
    linearColor = renodx::tonemap::ExponentialRollOff(linearColor, 0.2f, 1.f);
  }

  outColor.rgb = renodx::color::gamma::EncodeSafe(linearColor, 2.2);  // back to gamma

  return outColor;
  // Leave output in gamma space and with a paper white of 80 nits even for HDR so we can blend in the UI just like in SDR (in gamma space) and linearize with an extra pass added at the end.
}
