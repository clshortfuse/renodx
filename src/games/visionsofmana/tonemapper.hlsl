// Custom Tonemapper
// We'll create a function so we can just call this in other shaders, instead of having to manage a wall of code in multiple files

#include "./shared.h"

float3 applyUserTonemap(float3 untonemapped){
    float3 outputColor;
    
    if (injectedData.toneMapType == 0.f)
    {
        outputColor = max(0, untonemapped); //clamps to 709/no negative colors for the vanilla tonemapper
        outputColor = saturate(untonemapped);
    }
    else
    {
        outputColor = untonemapped;
    }
    
 
    
    //float vanillaMidGray = 0.1f; //0.18f old default
    float vanillaMidGray = 0.18f; //calculate mid grey from the second hable run
    float renoDRTContrast = 1.f;
    float renoDRTFlare = 0.f;
    float renoDRTShadows = 1.f;
    float renoDRTDechroma = 0.f;
    //float renoDRTDechroma = injectedData.colorGradeBlowout;
    float renoDRTSaturation = 1.f; //
    float renoDRTHighlights = 1.f;

    renodx::tonemap::Config config = renodx::tonemap::config::Create();
    config.type = injectedData.toneMapType;
    config.peak_nits = injectedData.toneMapPeakNits;
    config.game_nits = injectedData.toneMapGameNits;
    config.gamma_correction = 1;
    config.exposure = injectedData.colorGradeExposure;
    config.highlights = injectedData.colorGradeHighlights;
    config.shadows = injectedData.colorGradeShadows;
    config.contrast = injectedData.colorGradeContrast;
    config.saturation = injectedData.colorGradeSaturation;
//    config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
//    config.hue_correction_color = saturate(untonemapped),
//    config.hue_correction_strength = 0.f;
    config.reno_drt_highlights = renoDRTHighlights;
    config.reno_drt_shadows = renoDRTShadows;
    config.reno_drt_contrast = renoDRTContrast;
    config.reno_drt_saturation = renoDRTSaturation;
    config.reno_drt_dechroma = renoDRTDechroma;
    config.mid_gray_value = vanillaMidGray;
    config.mid_gray_nits = vanillaMidGray * 100.f;
    config.reno_drt_flare = renoDRTFlare;

    outputColor = renodx::tonemap::config::Apply(outputColor, config);
    
    if (injectedData.toneMapType != 0)
    {

    
    }
    
 
    return outputColor;
}
// End applyUserTonemap