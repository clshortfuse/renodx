#include "./DICE.hlsl"
#include "./shared.h"

float3 applyDICE(float3 untonemapped) {
    DICESettings config = DefaultDICESettings();
    config.Type = 3u;
    config.ShoulderStart = 0.5f;

    const float paperWhite = injectedData.toneMapGameNits / renodx::color::srgb::REFERENCE_WHITE;
    const float peakWhite = injectedData.toneMapPeakNits / renodx::color::srgb::REFERENCE_WHITE;

    return DICETonemap(untonemapped * paperWhite, peakWhite, config) / paperWhite;
}