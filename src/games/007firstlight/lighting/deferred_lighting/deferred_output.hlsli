#ifndef FIRSTLIGHT_DEFERRED_OUTPUT_HLSLI_
#define FIRSTLIGHT_DEFERRED_OUTPUT_HLSLI_

// Native combined-output join: only these stores and the function exit follow it.
void StoreCombinedDeferredLighting(uint2 pixel, float3 albedo, float3 specular, float3 diffuse) {
  uavDeferredShadingPass_Specular[pixel] = max(
      min(cbSharedPerViewData.vHDRScale.y * (diffuse * albedo + specular), 7936.0f),
      5.960464477539063e-08f);
  uavDeferredShadingPass_Diffuse[pixel] = float3(0.0f, 0.0f, 0.0f);
}

#endif  // FIRSTLIGHT_DEFERRED_OUTPUT_HLSLI_