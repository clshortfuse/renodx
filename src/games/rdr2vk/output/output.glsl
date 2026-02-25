#include "../common.glsl"

vec3 GammaSafe(vec3 x) {
  if (RENODX_SDR_EOTF_EMULATION != 0.f) {
    return CorrectGammaMismatch(x, false);
  } else {
    return x;
  }
}
