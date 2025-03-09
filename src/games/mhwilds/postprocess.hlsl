#ifndef SRC_MHWILDS_POSTPROCESS_HLSL_
#define SRC_MHWILDS_POSTPROCESS_HLSL_
#include "./shared.h"

float NormalizeExposure() {
  return CUSTOM_EXPOSURE_STRENGTH * ((CUSTOM_LUT_EXPOSURE_REVERSE * 5.f) + 1);
}

float PickExposure(float vanilla, float fixed, float auto_exposure, float local_exposure) {
  float normalizedCustomExposure = NormalizeExposure();

  if (CUSTOM_EXPOSURE_TYPE == 1.f) {
    return fixed * normalizedCustomExposure;
  } else if (CUSTOM_EXPOSURE_TYPE == 2.f) {
    return auto_exposure * normalizedCustomExposure;
  } else if (CUSTOM_EXPOSURE_TYPE == 3.f) {
    return local_exposure * normalizedCustomExposure;
  }
  return vanilla * normalizedCustomExposure;
}

#endif  // SRC_MHWILDS_POSTPROCESS_HLSL_
