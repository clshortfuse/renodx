// Custom Tonemapper
// We'll create a function so we can just call this in other shaders, instead of having to manage a wall of code in multiple files

#include "./shared.h"

float3 applyUserTonemap(float3 untonemapped, float3 vanillaColor, float midGray){
    float3 outputColor;
    
    if (injectedData.toneMapType == 0.f)
    {
        outputColor = vanillaColor;
        outputColor = max(0, outputColor); //clamps to 709/no negative colors for the vanilla tonemapper
    }
    else
    {
        outputColor = untonemapped;
    }
    
 
    
    //float vanillaMidGray = 0.1f; //0.18f old default
    float vanillaMidGray = midGray; //calculate mid grey from the second hable run
    float renoDRTContrast = 1.f;
    float renoDRTFlare = 0.f;
    float renoDRTShadows = 1.f;
    //float renoDRTDechroma = 0.8f;
    //float renoDRTDechroma = injectedData.colorGradeBlowout;
    float renoDRTSaturation = 1.f; //
    float renoDRTHighlights = 1.f;

    renodx::tonemap::Config config = renodx::tonemap::config::Create(
      injectedData.toneMapType,
      injectedData.toneMapPeakNits,
      injectedData.toneMapGameNits,
      1,
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
      //renoDRTDechroma,
      renoDRTFlare);

    outputColor = renodx::tonemap::config::Apply(outputColor, config);
    
    if (injectedData.toneMapType != 0)
    {

    
    }
    
    return outputColor;
}