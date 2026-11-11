#ifndef FIRSTLIGHT_DEFERRED_SOFT_SHADOW_HLSLI_
#define FIRSTLIGHT_DEFERRED_SOFT_SHADOW_HLSLI_

// Packed type 0xFFF denotes an unused screen-space shadow slot.
int GetDeferredSoftShadowChannel(uint light_id) {
  if ((cbDeferredShading.viSSLightIndices.x & 4095u) == light_id
      && (cbDeferredShading.viSSLightIndices.x & 0xFFFFF000u) != 0x00FFF000u) return 0;
  if ((cbDeferredShading.viSSLightIndices.y & 4095u) == light_id
      && (cbDeferredShading.viSSLightIndices.y & 0xFFFFF000u) != 0x00FFF000u) return 1;
  if ((cbDeferredShading.viSSLightIndices.z & 4095u) == light_id
      && (cbDeferredShading.viSSLightIndices.z & 0xFFFFF000u) != 0x00FFF000u) return 2;
  if ((cbDeferredShading.viSSLightIndices.w & 4095u) == light_id
      && (cbDeferredShading.viSSLightIndices.w & 0xFFFFF000u) != 0x00FFF000u) return 3;
  return -1;
}

#endif  // FIRSTLIGHT_DEFERRED_SOFT_SHADOW_HLSLI_