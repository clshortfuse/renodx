// Common functions

#include "./DICE.hlsl"
#include "./shared.h"

// AdvancedAutoHDR pass to generate some HDR brightess out of an SDR signal.
// This is hue conserving and only really affects highlights.
// "SDRColor" is meant to be in "SDR range", as in, a value of 1 matching SDR white (something between 80, 100, 203, 300 nits, or whatever else)
// https://github.com/Filoppi/PumboAutoHDR
float3 PumboAutoHDR(float3 SDRColor, float _PeakWhiteNits, float _PaperWhiteNits, float ShoulderPow = 2.75f) {  // ShoulderPow = 2.75f default
  const float SDRRatio = max(renodx::color::y::from::BT709(SDRColor), 0.f);
  // Limit AutoHDR brightness, it won't look good beyond a certain level.
  // The paper white multiplier is applied later so we account for that.
  const float AutoHDRMaxWhite = max(min(_PeakWhiteNits, 700) / _PaperWhiteNits, 1.f);
  const float AutoHDRShoulderRatio = 1.f - max(1.f - SDRRatio, 0.f);
  const float AutoHDRExtraRatio = pow(max(AutoHDRShoulderRatio, 0.f), ShoulderPow) * (AutoHDRMaxWhite - 1.f);
  const float AutoHDRTotalRatio = SDRRatio + AutoHDRExtraRatio;
  return SDRColor * renodx::math::SafeDivision(AutoHDRTotalRatio, SDRRatio, 1);  // Fallback on a value of 1 in case of division by 0
}

// Selects what tonemapper we'll use for Hue Correction
float3 hueCorrectionSelector(float3 color) {
  float selector = injectedData.toneMapHueCorrectionType;

  if (selector == 0) {
    return renodx::tonemap::Reinhard(color);
  } else if (selector == 1.f) {
    // return renodx::tonemap::uncharted2::BT709(color);
    return renodx::tonemap::renodrt::NeutralSDR(color);
  }

  return true;
}

float Highlights2(float x, float highlights = 1.f, float mid_gray = 0.18f) {
  float scaled = (highlights * highlights - highlights);
  float extra = scaled * scaled * x * x * x * (x - mid_gray);
  return ((mid_gray * x) + extra) / mid_gray;
}

// Custom Tonemapper
// We'll create a function so we can just call this in other shaders, instead of having to manage a wall of code in multiple files
float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor;

  if (injectedData.toneMapType == 0.f) {  // If vanilla is selected
    outputColor = saturate(untonemapped);
  } else {
    outputColor = untonemapped;
  }

  // UserColorGrading offsets
  // hard coded values that you can use to set as defaults
  // Assuming the slider is 50 with 0.02 steps and, the math comes out to offset * 1.f -- or 1.f * 1.f = 1.f
  // An offset of 1.1f will be 1.1f * 1.f = 1.1f with the sliders at 50 (default)
  float highlights = 1.f;
  float shadows = 1.f;
  float contrast = 1.f;
  float saturation = 1.f;
  float dechroma = 1.f;

  if (injectedData.toneMapType != 0) {  // UserColorGrading, pre-tonemap
    float color_y = renodx::color::y::from::BT709(outputColor.rgb);

    float highlights_y = Highlights2(color_y, injectedData.colorGradeHighlights2);

    outputColor.rgb = outputColor.rgb * (highlights_y / color_y);

    outputColor.rgb = renodx::color::grade::UserColorGrading(
        outputColor.rgb,
        injectedData.colorGradeExposure,                 // exposure
        highlights * injectedData.colorGradeHighlights,  // highlights
        shadows * injectedData.colorGradeShadows,        // shadows
        contrast * injectedData.colorGradeContrast,      // contrast
        1.f,                                             // saturation, we'll do this post-tonemap
        0.f,                                             // dechroma/blowout, we'll do this post-tonemap
        0.f);                                            // hue correction, might not need it [yet]
  }

  // Start tonemapper if/else
  if (injectedData.toneMapType == 2.f) {  // DICE
    DICESettings DICEconfig = DefaultDICESettings();
    DICEconfig.Type = 3;
    DICEconfig.ShoulderStart = 0.25;  // The higher the shoulder, the higher the game goes over peak nits

    float dicePaperWhite = injectedData.toneMapGameNits / 80.f;
    float dicePeakWhite = injectedData.toneMapPeakNits / 80.f;

    outputColor = DICETonemap(outputColor * dicePaperWhite, dicePeakWhite, DICEconfig) / dicePaperWhite;

  } else if (injectedData.toneMapType == 3.f) {  // Frostbite
    float frostbitePeak = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
    outputColor = renodx::tonemap::frostbite::BT709(outputColor, frostbitePeak, 1.f);
  }

  if (injectedData.toneMapType != 0) {  // UserColorGrading, post-tonemap
    outputColor.rgb = renodx::color::grade::UserColorGrading(
        outputColor.rgb,
        1.f,                                             // exposure
        1.f,                                             // highlights
        1.f,                                             // shadows
        1.f,                                             // contrast
        saturation * injectedData.colorGradeSaturation,  // saturation
        dechroma * 0.f,                                  // dechroma/blowout, we do this post tonemap
        injectedData.toneMapHueCorrectionStrength,       // hue correction, strength
        hueCorrectionSelector(untonemapped));            // Hue correction type
  }

  return outputColor;
}
