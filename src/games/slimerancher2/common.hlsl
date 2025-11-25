#include "./shared.h"


float3 blowout(float3 color, float blowoutAmount) {
    float luminance = renodx::color::y::from::BT709(color);
    color = lerp(color, luminance, saturate(luminance * blowoutAmount));

    return color;
}

float3 ReinhardPiecewiseLuminance(float3 color, float maxValue) {
    const float luminance  = renodx::color::y::from::BT709(color);
    const float compressedLuminance = renodx::tonemap::ReinhardPiecewise(luminance, maxValue);
    color = renodx::color::correct::Luminance(color, luminance, compressedLuminance);

    return color;
}

float3 Reinhardluminance(float3 color, float maxValue) {
    const float luminance  = renodx::color::y::from::BT709(color);
    float luminanceClamped = renodx::tonemap::Reinhard(luminance, maxValue);
    color = renodx::color::correct::Luminance(color, luminance, luminanceClamped);

    return color;
}

float3 InterpolatedExposure(float3 color, float exposureValue) {
    float luminance = renodx::color::y::from::BT709(color);
    
    float adjustedLuminance = luminance * exposureValue;
    float blendedLuminance = lerp(adjustedLuminance, luminance, saturate(adjustedLuminance));
    
    color = renodx::color::correct::Luminance(color, luminance, blendedLuminance);

    return color;
}

