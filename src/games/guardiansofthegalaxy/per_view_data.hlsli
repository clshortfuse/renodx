#ifndef SRC_GAMES_GUARDIANSOFTHEGALAXY_PER_VIEW_DATA_HLSLI_
#define SRC_GAMES_GUARDIANSOFTHEGALAXY_PER_VIEW_DATA_HLSLI_

// _cbSharedPerViewData (b2) layout, from the DXIL reflection of 0x31720375 / 0x76CF75A9 (728 bytes).
struct S_SharedPerViewData {
  row_major float4x4 mProjection;
  row_major float4x4 mProjectionInverse;
  row_major float4x4 mViewToViewport;
  row_major float4x4 mWorldToView;
  row_major float4x4 mViewToWorld;
  float4 vViewRemap;
  float4 vViewDepthRemap;
  float4 vEyeVectorUL;
  float4 vEyeVectorLR;
  float4 vEye_WS;
  float4 vEyeVectorUL_WS;
  float4 vEyeDeltaX_WS;
  float4 vEyeDeltaY_WS;
  float4 vViewSpaceUpVector;
  float4 vCheckerModeParams;
  float4 vViewportSize;
  float4 vEngineTime;
  float4 vPrecipitations;
  float4 vClipPlane;
  float4 vExtraParams;
  float4 vScatteringParams;
  float4 vScatteringParams2;
  float4 vStereoscopic3DCorrectionParams;
  float4 vVoxelDefinition;
  float4 vWaterSimulationDefinition;
  float4 vShadowBias;
  float4 vLightningIntensity;
  float4 vReflectionData;
  uint nIsDLSS;
  uint nEnableRaytraceReflSpecTrans;
  uint nFrameIndex;
  float fNear;
  float fRcpLogFarNear;
  float fRcpTanLODFovY;
  uint nIsMirrorCamera;
  uint nAdvancedHairLightingParams;
  float fHairAlphaThresholdOffset;
  uint nUseHairHashedAlphaTest;
};

cbuffer _cbSharedPerViewData : register(b2) {
  S_SharedPerViewData cbSharedPerViewData : packoffset(c000.x);
};

#endif  // SRC_GAMES_GUARDIANSOFTHEGALAXY_PER_VIEW_DATA_HLSLI_
