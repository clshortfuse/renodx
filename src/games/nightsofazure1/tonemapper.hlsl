// Custom Tonemapper
// We'll create a function so we can just call this in other shaders, instead of having to manage a wall of code in multiple files

#include "./shared.h"

float3 applyUserTonemap(float3 untonemapped){
    float3 outputColor;
    
    outputColor = untonemapped;
    
    if (injectedData.toneMapType == 0.f) //vanilla
    {
        saturate(untonemapped);
    }
    
    
    
    float vanillaMidGray = 0.18f;
    float renoDRTContrast = 1.f;
    float renoDRTFlare = 0.f;
    float renoDRTShadows = 1.f;
    //float renoDRTDechroma = 0.8f;
    float renoDRTSaturation = 1.f; //
    float renoDRTHighlights = 1.f;

    renodx::tonemap::Config config = renodx::tonemap::config::Create(
      injectedData.toneMapType,
      injectedData.toneMapPeakNits,
      injectedData.toneMapGameNits,
      0,
      injectedData.colorGradeExposure,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeShadows,
      injectedData.colorGradeContrast,
      injectedData.colorGradeSaturation,
      vanillaMidGray,
      vanillaMidGray * 100.f,
      renoDRTHighlights,
      renoDRTShadows,
      renoDRTContrast,
      renoDRTSaturation,
      renoDRTFlare);

    outputColor = renodx::tonemap::config::Apply(outputColor, config);
    

    
    return outputColor;
}