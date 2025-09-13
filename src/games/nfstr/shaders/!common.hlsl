#include "../shared.h"


#define RHSC_E (50.f/41.f)
float3 ReinhardScalableCached(float3 x) {
  return (x * RHSC_E) / (x * RHSC_E + 1.f);
}

float3 Tonemap_Do(in float3 colorUntonemapped, in float3 colorTonemapped) {
  //decode
  colorTonemapped.xyz = renodx::color::srgb::Decode(colorTonemapped); //10000% srgb, else gamma black crushes

  //type?
  if (RENODX_TONE_MAP_TYPE != 0) {
    //CUSTOM_PREEXPOSURE_CONTRAST
    colorUntonemapped = renodx::color::grade::Contrast(colorUntonemapped, CUSTOM_PREEXPOSURE_CONTRAST);

    //colorSDRNeutral & CUSTOM_GRADE_LUMA
    float3 colorSDRNeutral = ReinhardScalableCached(colorUntonemapped);
    colorSDRNeutral = /* CUSTOM_GRADE_LUMA == 1.f ? colorSDRNeutral :  */ lerp(colorTonemapped, colorSDRNeutral, CUSTOM_GRADE_LUMA);

    //CUSTOM_GRADE_CHROMA
    colorTonemapped = CUSTOM_GRADE_CHROMA == 1.f ? colorTonemapped : renodx::tonemap::UpgradeToneMap(colorTonemapped, colorUntonemapped, colorUntonemapped, 1-CUSTOM_GRADE_CHROMA, 0);

    //CUSTOM_PREEXPOSURE
    colorUntonemapped *= CUSTOM_PREEXPOSURE;

    //do
    colorTonemapped.xyz = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, colorSDRNeutral);
  }

  colorTonemapped = renodx::draw::RenderIntermediatePass(colorTonemapped);

  return colorTonemapped;
}

float3 Tonemap_FixColorOutputNaN(in float3 color) {
  // return max(color, 0); 
   return color;
}

void Bloom_User(inout float3 color) {
  color *= CUSTOM_EXTRA_BLOOM;
}
