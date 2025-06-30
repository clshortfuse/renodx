#include "./DICE.hlsl"
#include "./shared.h"

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor;

  if (shader_injection.tone_map_type == 0.f) {  // If vanilla is selected
    outputColor = saturate(untonemapped);
  } else {
    outputColor = untonemapped;
  }

  if (shader_injection.tone_map_type != 0) {  // UserColorGrading, pre-tonemap
    outputColor = renodx::color::grade::UserColorGrading(
        outputColor,
        shader_injection.tone_map_exposure,    // exposure
        shader_injection.tone_map_highlights,  // highlights
        shader_injection.tone_map_shadows,     // shadows
        shader_injection.tone_map_contrast,    // contrast
        1.f,                                // saturation, we'll do this post-tonemap
        0.f,                                // dechroma, post tonemapping
        0.f);                               // hue correction, Post tonemapping
  }

  // Start tonemapper if/else
  if (shader_injection.tone_map_type == 2.f) {  // DICE
    DICESettings DICEconfig = DefaultDICESettings();
    DICEconfig.Type = 3;
    DICEconfig.ShoulderStart = 0.33f;  // Start shoulder

    float dicePaperWhite = injectedData.toneMapGameNits / 80.f;
    float dicePeakWhite = injectedData.toneMapPeakNits / 80.f;

    outputColor = DICETonemap(outputColor * dicePaperWhite, dicePeakWhite, DICEconfig) / dicePaperWhite;

  } else if (injectedData.toneMapType == 3.f) {  // baby reinhard
    float ReinhardPeak = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
    outputColor = renodx::tonemap::ReinhardScalable(outputColor, ReinhardPeak);

  } else if (injectedData.toneMapType == 4.f) {  // Frostbite
    float frostbitePeak = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
    outputColor = renodx::tonemap::frostbite::BT709(outputColor, frostbitePeak);
  }

  if (injectedData.toneMapType != 0) {  // UserColorGrading, post-tonemap
    outputColor = renodx::color::grade::UserColorGrading(
        outputColor,
        1.f,                                       // exposure
        1.f,                                       // highlights
        1.f,                                       // shadows
        1.f,                                       // contrast
        injectedData.colorGradeSaturation,         // saturation
        0.f,                                       // dechroma, we don't need it
        injectedData.toneMapHueCorrection,         // Hue Correction Strength
        renodx::tonemap::Reinhard(untonemapped));  // Hue Correction Type
  }

  outputColor = renodx::color::bt709::clamp::BT2020(outputColor);  // Clamp to BT2020 to avoid negative colors

  return outputColor;
}