#ifndef SRC_MHWILDS_POSTPROCESS_HLSL_
#define SRC_MHWILDS_POSTPROCESS_HLSL_
#include "./shared.h"

float PickExposure(float vanilla, float fixed, float auto_exposure, float local_exposure) {
  if (CUSTOM_EXPOSURE_TYPE == 1.f) {
    return fixed * CUSTOM_EXPOSURE_STRENGTH;
  } else if (CUSTOM_EXPOSURE_TYPE == 2.f) {
    return auto_exposure * CUSTOM_EXPOSURE_STRENGTH;
  } else if (CUSTOM_EXPOSURE_TYPE == 3.f) {
    return local_exposure * CUSTOM_EXPOSURE_STRENGTH;
  }
  return vanilla * CUSTOM_EXPOSURE_STRENGTH;
}

#endif  // SRC_MHWILDS_POSTPROCESS_HLSL_
