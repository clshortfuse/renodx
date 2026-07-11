#include "../postfx.hlsli"

Texture2D<float4> SceneTexturesStruct_SceneDepthTexture : register(t0);

Texture2D<float4> Material_Texture2D_0 : register(t1);

Texture2D<float4> Material_Texture2D_1 : register(t2);

Texture2D<float4> PostProcessInput_0_Texture : register(t3);

cbuffer $Globals : register(b0) {
  float2 PostProcessInput_0_UVViewportMin : packoffset(c000.x);
  float2 PostProcessInput_0_UVViewportSize : packoffset(c000.z);
  float2 PostProcessInput_0_UVViewportBilinearMin : packoffset(c001.x);
  float2 PostProcessInput_0_UVViewportBilinearMax : packoffset(c001.z);
  float2 PostProcessInput_1_UVViewportMin : packoffset(c002.x);
  float2 PostProcessInput_1_UVViewportSize : packoffset(c002.z);
  float2 PostProcessInput_1_UVViewportBilinearMin : packoffset(c003.x);
  float2 PostProcessInput_1_UVViewportBilinearMax : packoffset(c003.z);
  float2 PostProcessInput_2_UVViewportMin : packoffset(c004.x);
  float2 PostProcessInput_2_UVViewportSize : packoffset(c004.z);
  float2 PostProcessInput_2_UVViewportBilinearMin : packoffset(c005.x);
  float2 PostProcessInput_2_UVViewportBilinearMax : packoffset(c005.z);
  float2 PostProcessInput_3_UVViewportMin : packoffset(c006.x);
  float2 PostProcessInput_3_UVViewportSize : packoffset(c006.z);
  float2 PostProcessInput_3_UVViewportBilinearMin : packoffset(c007.x);
  float2 PostProcessInput_3_UVViewportBilinearMax : packoffset(c007.z);
  float2 PostProcessInput_4_UVViewportMin : packoffset(c008.x);
  float2 PostProcessInput_4_UVViewportSize : packoffset(c008.z);
  float2 PostProcessInput_4_UVViewportBilinearMin : packoffset(c009.x);
  float2 PostProcessInput_4_UVViewportBilinearMax : packoffset(c009.z);
  uint2 PostProcessOutput_ViewportMin : packoffset(c010.x);
  float2 PostProcessOutput_ViewportSizeInverse : packoffset(c010.z);
};

cbuffer UniformBufferConstants_View : register(b1) {
  float4 View_TranslatedWorldToClip[4] : packoffset(c000.x);
  float4 View_RelativeWorldToClip[4] : packoffset(c004.x);
  float4 View_ClipToRelativeWorld[4] : packoffset(c008.x);
  float4 View_TranslatedWorldToView[4] : packoffset(c012.x);
  float4 View_ViewToTranslatedWorld[4] : packoffset(c016.x);
  float4 View_TranslatedWorldToCameraView[4] : packoffset(c020.x);
  float4 View_CameraViewToTranslatedWorld[4] : packoffset(c024.x);
  float4 View_ViewToClip[4] : packoffset(c028.x);
  float4 View_ViewToClipNoAA[4] : packoffset(c032.x);
  float4 View_ClipToView[4] : packoffset(c036.x);
  float4 View_ClipToTranslatedWorld[4] : packoffset(c040.x);
  float4 View_SVPositionToTranslatedWorld[4] : packoffset(c044.x);
  float4 View_ScreenToRelativeWorld[4] : packoffset(c048.x);
  float4 View_ScreenToTranslatedWorld[4] : packoffset(c052.x);
  float4 View_MobileMultiviewShadowTransform[4] : packoffset(c056.x);
  float3 View_ViewTilePosition : packoffset(c060.x);
  float PrePadding_View_972 : packoffset(c060.w);
  float3 View_MatrixTilePosition : packoffset(c061.x);
  float PrePadding_View_988 : packoffset(c061.w);
  float3 View_ViewForward : packoffset(c062.x);
  float PrePadding_View_1004 : packoffset(c062.w);
  float3 View_ViewUp : packoffset(c063.x);
  float PrePadding_View_1020 : packoffset(c063.w);
  float3 View_ViewRight : packoffset(c064.x);
  float PrePadding_View_1036 : packoffset(c064.w);
  float3 View_HMDViewNoRollUp : packoffset(c065.x);
  float PrePadding_View_1052 : packoffset(c065.w);
  float3 View_HMDViewNoRollRight : packoffset(c066.x);
  float PrePadding_View_1068 : packoffset(c066.w);
  float4 View_InvDeviceZToWorldZTransform : packoffset(c067.x);
  float4 View_ScreenPositionScaleBias : packoffset(c068.x);
  float3 View_RelativeWorldCameraOrigin : packoffset(c069.x);
  float PrePadding_View_1116 : packoffset(c069.w);
  float3 View_TranslatedWorldCameraOrigin : packoffset(c070.x);
  float PrePadding_View_1132 : packoffset(c070.w);
  float3 View_RelativeWorldViewOrigin : packoffset(c071.x);
  float PrePadding_View_1148 : packoffset(c071.w);
  float3 View_RelativePreViewTranslation : packoffset(c072.x);
  float PrePadding_View_1164 : packoffset(c072.w);
  float4 View_PrevViewToClip[4] : packoffset(c073.x);
  float4 View_PrevClipToView[4] : packoffset(c077.x);
  float4 View_PrevTranslatedWorldToClip[4] : packoffset(c081.x);
  float4 View_PrevTranslatedWorldToView[4] : packoffset(c085.x);
  float4 View_PrevViewToTranslatedWorld[4] : packoffset(c089.x);
  float4 View_PrevTranslatedWorldToCameraView[4] : packoffset(c093.x);
  float4 View_PrevCameraViewToTranslatedWorld[4] : packoffset(c097.x);
  float3 View_PrevTranslatedWorldCameraOrigin : packoffset(c101.x);
  float PrePadding_View_1628 : packoffset(c101.w);
  float3 View_PrevRelativeWorldCameraOrigin : packoffset(c102.x);
  float PrePadding_View_1644 : packoffset(c102.w);
  float3 View_PrevRelativeWorldViewOrigin : packoffset(c103.x);
  float PrePadding_View_1660 : packoffset(c103.w);
  float3 View_RelativePrevPreViewTranslation : packoffset(c104.x);
  float PrePadding_View_1676 : packoffset(c104.w);
  float4 View_PrevClipToRelativeWorld[4] : packoffset(c105.x);
  float4 View_PrevScreenToTranslatedWorld[4] : packoffset(c109.x);
  float4 View_ClipToPrevClip[4] : packoffset(c113.x);
  float4 View_ClipToPrevClipWithAA[4] : packoffset(c117.x);
  float4 View_TemporalAAJitter : packoffset(c121.x);
  float4 View_GlobalClippingPlane : packoffset(c122.x);
  float2 View_FieldOfViewWideAngles : packoffset(c123.x);
  float2 View_PrevFieldOfViewWideAngles : packoffset(c123.z);
  float4 View_ViewRectMin : packoffset(c124.x);
  float4 View_ViewSizeAndInvSize : packoffset(c125.x);
  uint4 View_ViewRectMinAndSize : packoffset(c126.x);
  float4 View_LightProbeSizeRatioAndInvSizeRatio : packoffset(c127.x);
  float4 View_BufferSizeAndInvSize : packoffset(c128.x);
  float4 View_BufferBilinearUVMinMax : packoffset(c129.x);
  float4 View_ScreenToViewSpace : packoffset(c130.x);
  float2 View_BufferToSceneTextureScale : packoffset(c131.x);
  float2 View_ResolutionFractionAndInv : packoffset(c131.z);
  int View_NumSceneColorMSAASamples : packoffset(c132.x);
  float View_ProjectionDepthThicknessScale : packoffset(c132.y);
  float View_PreExposure : packoffset(c132.z);
  float View_OneOverPreExposure : packoffset(c132.w);
  float4 View_DiffuseOverrideParameter : packoffset(c133.x);
  float4 View_SpecularOverrideParameter : packoffset(c134.x);
  float4 View_NormalOverrideParameter : packoffset(c135.x);
  float2 View_RoughnessOverrideParameter : packoffset(c136.x);
  float View_PrevFrameGameTime : packoffset(c136.z);
  float View_PrevFrameRealTime : packoffset(c136.w);
  float View_OutOfBoundsMask : packoffset(c137.x);
  float PrePadding_View_2196 : packoffset(c137.y);
  float PrePadding_View_2200 : packoffset(c137.z);
  float PrePadding_View_2204 : packoffset(c137.w);
  float3 View_WorldCameraMovementSinceLastFrame : packoffset(c138.x);
  float View_CullingSign : packoffset(c138.w);
  float View_NearPlane : packoffset(c139.x);
  float View_GameTime : packoffset(c139.y);
  float View_RealTime : packoffset(c139.z);
  float View_DeltaTime : packoffset(c139.w);
  float View_MaterialTextureMipBias : packoffset(c140.x);
  float View_MaterialTextureDerivativeMultiply : packoffset(c140.y);
  uint View_Random : packoffset(c140.z);
  uint View_FrameNumber : packoffset(c140.w);
  uint View_FrameCounter : packoffset(c141.x);
  uint View_StateFrameIndexMod8 : packoffset(c141.y);
  uint View_StateFrameIndex : packoffset(c141.z);
  uint View_DebugViewModeMask : packoffset(c141.w);
  uint View_WorldIsPaused : packoffset(c142.x);
  float View_CameraCut : packoffset(c142.y);
  float View_UnlitViewmodeMask : packoffset(c142.z);
  float PrePadding_View_2284 : packoffset(c142.w);
  float4 View_DirectionalLightColor : packoffset(c143.x);
  float3 View_DirectionalLightDirection : packoffset(c144.x);
  float PrePadding_View_2316 : packoffset(c144.w);
  float4 View_TranslucencyLightingVolumeMin[2] : packoffset(c145.x);
  float4 View_TranslucencyLightingVolumeInvSize[2] : packoffset(c147.x);
  float4 View_TemporalAAParams : packoffset(c149.x);
  float4 View_CircleDOFParams : packoffset(c150.x);
  float View_DepthOfFieldSensorWidth : packoffset(c151.x);
  float View_DepthOfFieldFocalDistance : packoffset(c151.y);
  float View_DepthOfFieldScale : packoffset(c151.z);
  float View_DepthOfFieldFocalLength : packoffset(c151.w);
  float View_DepthOfFieldFocalRegion : packoffset(c152.x);
  float View_DepthOfFieldNearTransitionRegion : packoffset(c152.y);
  float View_DepthOfFieldFarTransitionRegion : packoffset(c152.z);
  float View_MotionBlurNormalizedToPixel : packoffset(c152.w);
  float View_GeneralPurposeTweak : packoffset(c153.x);
  float View_GeneralPurposeTweak2 : packoffset(c153.y);
  float View_DemosaicVposOffset : packoffset(c153.z);
  float View_DecalDepthBias : packoffset(c153.w);
  float3 View_IndirectLightingColorScale : packoffset(c154.x);
  float PrePadding_View_2476 : packoffset(c154.w);
  float3 View_PrecomputedIndirectLightingColorScale : packoffset(c155.x);
  float PrePadding_View_2492 : packoffset(c155.w);
  float3 View_PrecomputedIndirectSpecularColorScale : packoffset(c156.x);
  float PrePadding_View_2508 : packoffset(c156.w);
  float4 View_AtmosphereLightDirection[2] : packoffset(c157.x);
  float4 View_AtmosphereLightIlluminanceOnGroundPostTransmittance[2] : packoffset(c159.x);
  float4 View_AtmosphereLightIlluminanceOuterSpace[2] : packoffset(c161.x);
  float4 View_AtmosphereLightDiscLuminance[2] : packoffset(c163.x);
  float4 View_AtmosphereLightDiscCosHalfApexAngle_PPTrans[2] : packoffset(c165.x);
  float4 View_SkyViewLutSizeAndInvSize : packoffset(c167.x);
  float3 View_SkyCameraTranslatedWorldOrigin : packoffset(c168.x);
  float PrePadding_View_2700 : packoffset(c168.w);
  float4 View_SkyPlanetTranslatedWorldCenterAndViewHeight : packoffset(c169.x);
  float4 View_SkyViewLutReferential[4] : packoffset(c170.x);
  float4 View_SkyAtmosphereSkyLuminanceFactor : packoffset(c174.x);
  float View_SkyAtmospherePresentInScene : packoffset(c175.x);
  float View_SkyAtmosphereHeightFogContribution : packoffset(c175.y);
  float View_SkyAtmosphereBottomRadiusKm : packoffset(c175.z);
  float View_SkyAtmosphereTopRadiusKm : packoffset(c175.w);
  float4 View_SkyAtmosphereCameraAerialPerspectiveVolumeSizeAndInvSize : packoffset(c176.x);
  float View_SkyAtmosphereAerialPerspectiveStartDepthKm : packoffset(c177.x);
  float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthResolution : packoffset(c177.y);
  float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthResolutionInv : packoffset(c177.z);
  float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthSliceLengthKm : packoffset(c177.w);
  float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthSliceLengthKmInv : packoffset(c178.x);
  float View_SkyAtmosphereApplyCameraAerialPerspectiveVolume : packoffset(c178.y);
  float PrePadding_View_2856 : packoffset(c178.z);
  float PrePadding_View_2860 : packoffset(c178.w);
  float3 View_NormalCurvatureToRoughnessScaleBias : packoffset(c179.x);
  float View_RenderingReflectionCaptureMask : packoffset(c179.w);
  float View_RealTimeReflectionCapture : packoffset(c180.x);
  float View_RealTimeReflectionCapturePreExposure : packoffset(c180.y);
  float PrePadding_View_2888 : packoffset(c180.z);
  float PrePadding_View_2892 : packoffset(c180.w);
  float4 View_AmbientCubemapTint : packoffset(c181.x);
  float View_AmbientCubemapIntensity : packoffset(c182.x);
  float View_SkyLightApplyPrecomputedBentNormalShadowingFlag : packoffset(c182.y);
  float View_SkyLightAffectReflectionFlag : packoffset(c182.z);
  float View_SkyLightAffectGlobalIlluminationFlag : packoffset(c182.w);
  float4 View_SkyLightColor : packoffset(c183.x);
  float4 View_MobileSkyIrradianceEnvironmentMap[8] : packoffset(c184.x);
  float View_MobilePreviewMode : packoffset(c192.x);
  float View_HMDEyePaddingOffset : packoffset(c192.y);
  float View_ReflectionCubemapMaxMip : packoffset(c192.z);
  float View_ShowDecalsMask : packoffset(c192.w);
  uint View_DistanceFieldAOSpecularOcclusionMode : packoffset(c193.x);
  float View_IndirectCapsuleSelfShadowingIntensity : packoffset(c193.y);
  float PrePadding_View_3096 : packoffset(c193.z);
  float PrePadding_View_3100 : packoffset(c193.w);
  float3 View_ReflectionEnvironmentRoughnessMixingScaleBiasAndLargestWeight : packoffset(c194.x);
  int View_StereoPassIndex : packoffset(c194.w);
  float4 View_GlobalVolumeTranslatedCenterAndExtent[6] : packoffset(c195.x);
  float4 View_GlobalVolumeTranslatedWorldToUVAddAndMul[6] : packoffset(c201.x);
  float4 View_GlobalDistanceFieldMipTranslatedWorldToUVScale[6] : packoffset(c207.x);
  float4 View_GlobalDistanceFieldMipTranslatedWorldToUVBias[6] : packoffset(c213.x);
  float View_GlobalDistanceFieldMipFactor : packoffset(c219.x);
  float View_GlobalDistanceFieldMipTransition : packoffset(c219.y);
  int View_GlobalDistanceFieldClipmapSizeInPages : packoffset(c219.z);
  int PrePadding_View_3516 : packoffset(c219.w);
  float3 View_GlobalDistanceFieldInvPageAtlasSize : packoffset(c220.x);
  float PrePadding_View_3532 : packoffset(c220.w);
  float3 View_GlobalDistanceFieldInvCoverageAtlasSize : packoffset(c221.x);
  float View_GlobalVolumeDimension : packoffset(c221.w);
  float View_GlobalVolumeTexelSize : packoffset(c222.x);
  float View_MaxGlobalDFAOConeDistance : packoffset(c222.y);
  uint View_NumGlobalSDFClipmaps : packoffset(c222.z);
  float View_CoveredExpandSurfaceScale : packoffset(c222.w);
  float View_NotCoveredExpandSurfaceScale : packoffset(c223.x);
  float View_NotCoveredMinStepScale : packoffset(c223.y);
  float View_DitheredTransparencyStepThreshold : packoffset(c223.z);
  float View_DitheredTransparencyTraceThreshold : packoffset(c223.w);
  int2 View_CursorPosition : packoffset(c224.x);
  float View_bCheckerboardSubsurfaceProfileRendering : packoffset(c224.z);
  float PrePadding_View_3596 : packoffset(c224.w);
  float3 View_VolumetricFogInvGridSize : packoffset(c225.x);
  float PrePadding_View_3612 : packoffset(c225.w);
  float3 View_VolumetricFogGridZParams : packoffset(c226.x);
  float PrePadding_View_3628 : packoffset(c226.w);
  float2 View_VolumetricFogSVPosToVolumeUV : packoffset(c227.x);
  float2 View_VolumetricFogViewGridUVToPrevViewRectUV : packoffset(c227.z);
  float2 View_VolumetricFogPrevViewGridRectUVToResourceUV : packoffset(c228.x);
  float2 View_VolumetricFogPrevUVMax : packoffset(c228.z);
  float2 View_VolumetricFogPrevUVMaxForTemporalBlend : packoffset(c229.x);
  float2 View_VolumetricFogScreenToResourceUV : packoffset(c229.z);
  float2 View_VolumetricFogUVMax : packoffset(c230.x);
  float View_VolumetricFogMaxDistance : packoffset(c230.z);
  float PrePadding_View_3692 : packoffset(c230.w);
  float3 View_VolumetricLightmapWorldToUVScale : packoffset(c231.x);
  float PrePadding_View_3708 : packoffset(c231.w);
  float3 View_VolumetricLightmapWorldToUVAdd : packoffset(c232.x);
  float PrePadding_View_3724 : packoffset(c232.w);
  float3 View_VolumetricLightmapIndirectionTextureSize : packoffset(c233.x);
  float View_VolumetricLightmapBrickSize : packoffset(c233.w);
  float3 View_VolumetricLightmapBrickTexelSize : packoffset(c234.x);
  float View_IndirectLightingCacheShowFlag : packoffset(c234.w);
  float View_EyeToPixelSpreadAngle : packoffset(c235.x);
  float PrePadding_View_3764 : packoffset(c235.y);
  float PrePadding_View_3768 : packoffset(c235.z);
  float PrePadding_View_3772 : packoffset(c235.w);
  float4 View_XRPassthroughCameraUVs[2] : packoffset(c236.x);
  float View_GlobalVirtualTextureMipBias : packoffset(c238.x);
  uint View_VirtualTextureFeedbackShift : packoffset(c238.y);
  uint View_VirtualTextureFeedbackMask : packoffset(c238.z);
  uint View_VirtualTextureFeedbackStride : packoffset(c238.w);
  uint View_VirtualTextureFeedbackJitterOffset : packoffset(c239.x);
  uint View_VirtualTextureFeedbackSampleOffset : packoffset(c239.y);
  uint PrePadding_View_3832 : packoffset(c239.z);
  uint PrePadding_View_3836 : packoffset(c239.w);
  float4 View_RuntimeVirtualTextureMipLevel : packoffset(c240.x);
  float2 View_RuntimeVirtualTexturePackHeight : packoffset(c241.x);
  float PrePadding_View_3864 : packoffset(c241.z);
  float PrePadding_View_3868 : packoffset(c241.w);
  float4 View_RuntimeVirtualTextureDebugParams : packoffset(c242.x);
  float View_OverrideLandscapeLOD : packoffset(c243.x);
  int View_FarShadowStaticMeshLODBias : packoffset(c243.y);
  float View_MinRoughness : packoffset(c243.z);
  float PrePadding_View_3900 : packoffset(c243.w);
  float4 View_HairRenderInfo : packoffset(c244.x);
  uint View_EnableSkyLight : packoffset(c245.x);
  uint View_HairRenderInfoBits : packoffset(c245.y);
  uint View_HairComponents : packoffset(c245.z);
  float View_bSubsurfacePostprocessEnabled : packoffset(c245.w);
  float4 View_SSProfilesTextureSizeAndInvSize : packoffset(c246.x);
  float4 View_SSProfilesPreIntegratedTextureSizeAndInvSize : packoffset(c247.x);
  float4 View_SpecularProfileTextureSizeAndInvSize : packoffset(c248.x);
  float3 View_PhysicsFieldClipmapCenter : packoffset(c249.x);
  float View_PhysicsFieldClipmapDistance : packoffset(c249.w);
  int View_PhysicsFieldClipmapResolution : packoffset(c250.x);
  int View_PhysicsFieldClipmapExponent : packoffset(c250.y);
  int View_PhysicsFieldClipmapCount : packoffset(c250.z);
  int View_PhysicsFieldTargetCount : packoffset(c250.w);
  int4 View_PhysicsFieldTargets[32] : packoffset(c251.x);
  uint View_GPUSceneViewId : packoffset(c283.x);
  float View_ViewResolutionFraction : packoffset(c283.y);
  float View_SubSurfaceColorAsTransmittanceAtDistanceInMeters : packoffset(c283.z);
  float PrePadding_View_4540 : packoffset(c283.w);
  float4 View_TanAndInvTanHalfFOV : packoffset(c284.x);
  float4 View_PrevTanAndInvTanHalfFOV : packoffset(c285.x);
  float4 View_GlintLUTParameters0 : packoffset(c286.x);
  float4 View_GlintLUTParameters1 : packoffset(c287.x);
  uint BindlessSampler_View_MaterialTextureBilinearWrapedSampler : packoffset(c288.x);
  uint PrePadding_View_4612 : packoffset(c288.y);
  uint BindlessSampler_View_MaterialTextureBilinearClampedSampler : packoffset(c288.z);
  uint PrePadding_View_4620 : packoffset(c288.w);
  uint BindlessResource_View_VolumetricLightmapIndirectionTexture : packoffset(c289.x);
  uint PrePadding_View_4628 : packoffset(c289.y);
  uint BindlessResource_View_VolumetricLightmapBrickAmbientVector : packoffset(c289.z);
  uint PrePadding_View_4636 : packoffset(c289.w);
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients0 : packoffset(c290.x);
  uint PrePadding_View_4644 : packoffset(c290.y);
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients1 : packoffset(c290.z);
  uint PrePadding_View_4652 : packoffset(c290.w);
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients2 : packoffset(c291.x);
  uint PrePadding_View_4660 : packoffset(c291.y);
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients3 : packoffset(c291.z);
  uint PrePadding_View_4668 : packoffset(c291.w);
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients4 : packoffset(c292.x);
  uint PrePadding_View_4676 : packoffset(c292.y);
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients5 : packoffset(c292.z);
  uint PrePadding_View_4684 : packoffset(c292.w);
  uint BindlessResource_View_SkyBentNormalBrickTexture : packoffset(c293.x);
  uint PrePadding_View_4692 : packoffset(c293.y);
  uint BindlessResource_View_DirectionalLightShadowingBrickTexture : packoffset(c293.z);
  uint PrePadding_View_4700 : packoffset(c293.w);
  uint BindlessSampler_View_VolumetricLightmapBrickAmbientVectorSampler : packoffset(c294.x);
  uint PrePadding_View_4708 : packoffset(c294.y);
  uint BindlessSampler_View_VolumetricLightmapTextureSampler0 : packoffset(c294.z);
  uint PrePadding_View_4716 : packoffset(c294.w);
  uint BindlessSampler_View_VolumetricLightmapTextureSampler1 : packoffset(c295.x);
  uint PrePadding_View_4724 : packoffset(c295.y);
  uint BindlessSampler_View_VolumetricLightmapTextureSampler2 : packoffset(c295.z);
  uint PrePadding_View_4732 : packoffset(c295.w);
  uint BindlessSampler_View_VolumetricLightmapTextureSampler3 : packoffset(c296.x);
  uint PrePadding_View_4740 : packoffset(c296.y);
  uint BindlessSampler_View_VolumetricLightmapTextureSampler4 : packoffset(c296.z);
  uint PrePadding_View_4748 : packoffset(c296.w);
  uint BindlessSampler_View_VolumetricLightmapTextureSampler5 : packoffset(c297.x);
  uint PrePadding_View_4756 : packoffset(c297.y);
  uint BindlessSampler_View_SkyBentNormalTextureSampler : packoffset(c297.z);
  uint PrePadding_View_4764 : packoffset(c297.w);
  uint BindlessSampler_View_DirectionalLightShadowingTextureSampler : packoffset(c298.x);
  uint PrePadding_View_4772 : packoffset(c298.y);
  uint BindlessResource_View_GlobalDistanceFieldPageAtlasTexture : packoffset(c298.z);
  uint PrePadding_View_4780 : packoffset(c298.w);
  uint BindlessResource_View_GlobalDistanceFieldCoverageAtlasTexture : packoffset(c299.x);
  uint PrePadding_View_4788 : packoffset(c299.y);
  uint BindlessResource_View_GlobalDistanceFieldPageTableTexture : packoffset(c299.z);
  uint PrePadding_View_4796 : packoffset(c299.w);
  uint BindlessResource_View_GlobalDistanceFieldMipTexture : packoffset(c300.x);
  uint PrePadding_View_4804 : packoffset(c300.y);
  uint BindlessSampler_View_GlobalDistanceFieldPageAtlasTextureSampler : packoffset(c300.z);
  uint PrePadding_View_4812 : packoffset(c300.w);
  uint BindlessSampler_View_GlobalDistanceFieldCoverageAtlasTextureSampler : packoffset(c301.x);
  uint PrePadding_View_4820 : packoffset(c301.y);
  uint BindlessSampler_View_GlobalDistanceFieldMipTextureSampler : packoffset(c301.z);
  uint PrePadding_View_4828 : packoffset(c301.w);
  uint BindlessResource_View_AtmosphereTransmittanceTexture : packoffset(c302.x);
  uint PrePadding_View_4836 : packoffset(c302.y);
  uint BindlessSampler_View_AtmosphereTransmittanceTextureSampler : packoffset(c302.z);
  uint PrePadding_View_4844 : packoffset(c302.w);
  uint BindlessResource_View_AtmosphereIrradianceTexture : packoffset(c303.x);
  uint PrePadding_View_4852 : packoffset(c303.y);
  uint BindlessSampler_View_AtmosphereIrradianceTextureSampler : packoffset(c303.z);
  uint PrePadding_View_4860 : packoffset(c303.w);
  uint BindlessResource_View_AtmosphereInscatterTexture : packoffset(c304.x);
  uint PrePadding_View_4868 : packoffset(c304.y);
  uint BindlessSampler_View_AtmosphereInscatterTextureSampler : packoffset(c304.z);
  uint PrePadding_View_4876 : packoffset(c304.w);
  uint BindlessResource_View_PerlinNoiseGradientTexture : packoffset(c305.x);
  uint PrePadding_View_4884 : packoffset(c305.y);
  uint BindlessSampler_View_PerlinNoiseGradientTextureSampler : packoffset(c305.z);
  uint PrePadding_View_4892 : packoffset(c305.w);
  uint BindlessResource_View_PerlinNoise3DTexture : packoffset(c306.x);
  uint PrePadding_View_4900 : packoffset(c306.y);
  uint BindlessSampler_View_PerlinNoise3DTextureSampler : packoffset(c306.z);
  uint PrePadding_View_4908 : packoffset(c306.w);
  uint BindlessResource_View_SobolSamplingTexture : packoffset(c307.x);
  uint PrePadding_View_4916 : packoffset(c307.y);
  uint BindlessSampler_View_SharedPointWrappedSampler : packoffset(c307.z);
  uint PrePadding_View_4924 : packoffset(c307.w);
  uint BindlessSampler_View_SharedPointClampedSampler : packoffset(c308.x);
  uint PrePadding_View_4932 : packoffset(c308.y);
  uint BindlessSampler_View_SharedBilinearWrappedSampler : packoffset(c308.z);
  uint PrePadding_View_4940 : packoffset(c308.w);
  uint BindlessSampler_View_SharedBilinearClampedSampler : packoffset(c309.x);
  uint PrePadding_View_4948 : packoffset(c309.y);
  uint BindlessSampler_View_SharedBilinearAnisoClampedSampler : packoffset(c309.z);
  uint PrePadding_View_4956 : packoffset(c309.w);
  uint BindlessSampler_View_SharedTrilinearWrappedSampler : packoffset(c310.x);
  uint PrePadding_View_4964 : packoffset(c310.y);
  uint BindlessSampler_View_SharedTrilinearClampedSampler : packoffset(c310.z);
  uint PrePadding_View_4972 : packoffset(c310.w);
  uint BindlessResource_View_PreIntegratedBRDF : packoffset(c311.x);
  uint PrePadding_View_4980 : packoffset(c311.y);
  uint BindlessSampler_View_PreIntegratedBRDFSampler : packoffset(c311.z);
  uint PrePadding_View_4988 : packoffset(c311.w);
  uint BindlessResource_View_SkyIrradianceEnvironmentMap : packoffset(c312.x);
  uint PrePadding_View_4996 : packoffset(c312.y);
  uint BindlessResource_View_TransmittanceLutTexture : packoffset(c312.z);
  uint PrePadding_View_5004 : packoffset(c312.w);
  uint BindlessSampler_View_TransmittanceLutTextureSampler : packoffset(c313.x);
  uint PrePadding_View_5012 : packoffset(c313.y);
  uint BindlessResource_View_SkyViewLutTexture : packoffset(c313.z);
  uint PrePadding_View_5020 : packoffset(c313.w);
  uint BindlessSampler_View_SkyViewLutTextureSampler : packoffset(c314.x);
  uint PrePadding_View_5028 : packoffset(c314.y);
  uint BindlessResource_View_DistantSkyLightLutTexture : packoffset(c314.z);
  uint PrePadding_View_5036 : packoffset(c314.w);
  uint BindlessSampler_View_DistantSkyLightLutTextureSampler : packoffset(c315.x);
  uint PrePadding_View_5044 : packoffset(c315.y);
  uint BindlessResource_View_CameraAerialPerspectiveVolume : packoffset(c315.z);
  uint PrePadding_View_5052 : packoffset(c315.w);
  uint BindlessSampler_View_CameraAerialPerspectiveVolumeSampler : packoffset(c316.x);
  uint PrePadding_View_5060 : packoffset(c316.y);
  uint BindlessResource_View_CameraAerialPerspectiveVolumeMieOnly : packoffset(c316.z);
  uint PrePadding_View_5068 : packoffset(c316.w);
  uint BindlessSampler_View_CameraAerialPerspectiveVolumeMieOnlySampler : packoffset(c317.x);
  uint PrePadding_View_5076 : packoffset(c317.y);
  uint BindlessResource_View_CameraAerialPerspectiveVolumeRayOnly : packoffset(c317.z);
  uint PrePadding_View_5084 : packoffset(c317.w);
  uint BindlessSampler_View_CameraAerialPerspectiveVolumeRayOnlySampler : packoffset(c318.x);
  uint PrePadding_View_5092 : packoffset(c318.y);
  uint BindlessResource_View_HairScatteringLUTTexture : packoffset(c318.z);
  uint PrePadding_View_5100 : packoffset(c318.w);
  uint BindlessSampler_View_HairScatteringLUTSampler : packoffset(c319.x);
  uint PrePadding_View_5108 : packoffset(c319.y);
  uint BindlessResource_View_GGXLTCMatTexture : packoffset(c319.z);
  uint PrePadding_View_5116 : packoffset(c319.w);
  uint BindlessSampler_View_GGXLTCMatSampler : packoffset(c320.x);
  uint PrePadding_View_5124 : packoffset(c320.y);
  uint BindlessResource_View_GGXLTCAmpTexture : packoffset(c320.z);
  uint PrePadding_View_5132 : packoffset(c320.w);
  uint BindlessSampler_View_GGXLTCAmpSampler : packoffset(c321.x);
  uint PrePadding_View_5140 : packoffset(c321.y);
  uint BindlessResource_View_SheenLTCTexture : packoffset(c321.z);
  uint PrePadding_View_5148 : packoffset(c321.w);
  uint BindlessSampler_View_SheenLTCSampler : packoffset(c322.x);
  uint PrePadding_View_5156 : packoffset(c322.y);
  uint View_bShadingEnergyConservation : packoffset(c322.z);
  uint View_bShadingEnergyPreservation : packoffset(c322.w);
  uint BindlessResource_View_ShadingEnergyGGXSpecTexture : packoffset(c323.x);
  uint PrePadding_View_5172 : packoffset(c323.y);
  uint BindlessResource_View_ShadingEnergyGGXGlassTexture : packoffset(c323.z);
  uint PrePadding_View_5180 : packoffset(c323.w);
  uint BindlessResource_View_ShadingEnergyClothSpecTexture : packoffset(c324.x);
  uint PrePadding_View_5188 : packoffset(c324.y);
  uint BindlessResource_View_ShadingEnergyDiffuseTexture : packoffset(c324.z);
  uint PrePadding_View_5196 : packoffset(c324.w);
  uint BindlessSampler_View_ShadingEnergySampler : packoffset(c325.x);
  uint PrePadding_View_5204 : packoffset(c325.y);
  uint BindlessResource_View_GlintTexture : packoffset(c325.z);
  uint PrePadding_View_5212 : packoffset(c325.w);
  uint BindlessSampler_View_GlintSampler : packoffset(c326.x);
  uint PrePadding_View_5220 : packoffset(c326.y);
  uint BindlessResource_View_SimpleVolumeTexture : packoffset(c326.z);
  uint PrePadding_View_5228 : packoffset(c326.w);
  uint BindlessSampler_View_SimpleVolumeTextureSampler : packoffset(c327.x);
  uint PrePadding_View_5236 : packoffset(c327.y);
  uint BindlessResource_View_SimpleVolumeEnvTexture : packoffset(c327.z);
  uint PrePadding_View_5244 : packoffset(c327.w);
  uint BindlessSampler_View_SimpleVolumeEnvTextureSampler : packoffset(c328.x);
  uint PrePadding_View_5252 : packoffset(c328.y);
  uint BindlessResource_View_SSProfilesTexture : packoffset(c328.z);
  uint PrePadding_View_5260 : packoffset(c328.w);
  uint BindlessSampler_View_SSProfilesSampler : packoffset(c329.x);
  uint PrePadding_View_5268 : packoffset(c329.y);
  uint BindlessSampler_View_SSProfilesTransmissionSampler : packoffset(c329.z);
  uint PrePadding_View_5276 : packoffset(c329.w);
  uint BindlessResource_View_SSProfilesPreIntegratedTexture : packoffset(c330.x);
  uint PrePadding_View_5284 : packoffset(c330.y);
  uint BindlessSampler_View_SSProfilesPreIntegratedSampler : packoffset(c330.z);
  uint PrePadding_View_5292 : packoffset(c330.w);
  uint BindlessResource_View_SpecularProfileTexture : packoffset(c331.x);
  uint PrePadding_View_5300 : packoffset(c331.y);
  uint BindlessSampler_View_SpecularProfileSampler : packoffset(c331.z);
  uint PrePadding_View_5308 : packoffset(c331.w);
  uint BindlessResource_View_WaterIndirection : packoffset(c332.x);
  uint PrePadding_View_5316 : packoffset(c332.y);
  uint BindlessResource_View_WaterData : packoffset(c332.z);
  uint PrePadding_View_5324 : packoffset(c332.w);
  float4 View_RectLightAtlasSizeAndInvSize : packoffset(c333.x);
  float View_RectLightAtlasMaxMipLevel : packoffset(c334.x);
  float PrePadding_View_5348 : packoffset(c334.y);
  uint BindlessResource_View_RectLightAtlasTexture : packoffset(c334.z);
  uint PrePadding_View_5356 : packoffset(c334.w);
  uint BindlessSampler_View_RectLightAtlasSampler : packoffset(c335.x);
  uint PrePadding_View_5364 : packoffset(c335.y);
  uint PrePadding_View_5368 : packoffset(c335.z);
  uint PrePadding_View_5372 : packoffset(c335.w);
  float4 View_IESAtlasSizeAndInvSize : packoffset(c336.x);
  uint BindlessResource_View_IESAtlasTexture : packoffset(c337.x);
  uint PrePadding_View_5396 : packoffset(c337.y);
  uint BindlessSampler_View_IESAtlasSampler : packoffset(c337.z);
  uint PrePadding_View_5404 : packoffset(c337.w);
  uint BindlessSampler_View_LandscapeWeightmapSampler : packoffset(c338.x);
  uint PrePadding_View_5412 : packoffset(c338.y);
  uint BindlessResource_View_LandscapeIndirection : packoffset(c338.z);
  uint PrePadding_View_5420 : packoffset(c338.w);
  uint BindlessResource_View_LandscapePerComponentData : packoffset(c339.x);
  uint PrePadding_View_5428 : packoffset(c339.y);
  uint BindlessResource_View_VTFeedbackBuffer : packoffset(c339.z);
  uint PrePadding_View_5436 : packoffset(c339.w);
  uint BindlessResource_View_PhysicsFieldClipmapBuffer : packoffset(c340.x);
  uint PrePadding_View_5444 : packoffset(c340.y);
  uint PrePadding_View_5448 : packoffset(c340.z);
  uint PrePadding_View_5452 : packoffset(c340.w);
  float3 View_TLASRelativePreViewTranslation : packoffset(c341.x);
  float PrePadding_View_5468 : packoffset(c341.w);
  float3 View_TLASViewTilePosition : packoffset(c342.x);
};

cbuffer UniformBufferConstants_MaterialCollection0 : register(b2) {
  float4 MaterialCollection0_Vectors[28] : packoffset(c000.x);
};

cbuffer UniformBufferConstants_MaterialCollection1 : register(b3) {
  float4 MaterialCollection1_Vectors[3] : packoffset(c000.x);
};

cbuffer UniformBufferConstants_Material : register(b4) {
  float4 Material_PreshaderBuffer[20] : packoffset(c000.x);
  uint BindlessResource_Material_Texture2D_0 : packoffset(c020.x);
  uint PrePadding_Material_324 : packoffset(c020.y);
  uint BindlessSampler_Material_Texture2D_0Sampler : packoffset(c020.z);
  uint PrePadding_Material_332 : packoffset(c020.w);
  uint BindlessResource_Material_Texture2D_1 : packoffset(c021.x);
  uint PrePadding_Material_340 : packoffset(c021.y);
  uint BindlessSampler_Material_Texture2D_1Sampler : packoffset(c021.z);
  uint PrePadding_Material_348 : packoffset(c021.w);
  uint BindlessSampler_Material_Wrap_WorldGroupSettings : packoffset(c022.x);
  uint PrePadding_Material_356 : packoffset(c022.y);
  uint BindlessSampler_Material_Clamp_WorldGroupSettings : packoffset(c022.z);
};

SamplerState SceneTexturesStruct_PointClampSampler : register(s0);

SamplerState Material_Texture2D_0Sampler : register(s1);

SamplerState Material_Clamp_WorldGroupSettings : register(s2);

SamplerState PostProcessInput_0_Sampler : register(s3);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float _31 = (SV_Position.x - float((uint)(int)(PostProcessOutput_ViewportMin.x))) * PostProcessOutput_ViewportSizeInverse.x;
  float _32 = (SV_Position.y - float((uint)(int)(PostProcessOutput_ViewportMin.y))) * PostProcessOutput_ViewportSizeInverse.y;
  float _35 = _32 * 6.2831854820251465f;
  float _42 = saturate(1.0f - (abs(abs(sin(_35 * (Material_PreshaderBuffer[1].x)))) * 1.25f));
  float _47 = (Material_PreshaderBuffer[3].x) * _42;
  float _48 = (Material_PreshaderBuffer[3].y) * _42;
  float _49 = (Material_PreshaderBuffer[3].z) * _42;
  float4 _52 = Material_Texture2D_0.Sample(Material_Texture2D_0Sampler, float2(_31, _32));
  float4 _74 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(min(max(((PostProcessInput_0_UVViewportSize.x * _31) + PostProcessInput_0_UVViewportMin.x), PostProcessInput_0_UVViewportBilinearMin.x), PostProcessInput_0_UVViewportBilinearMax.x), min(max(((PostProcessInput_0_UVViewportSize.y * _32) + PostProcessInput_0_UVViewportMin.y), PostProcessInput_0_UVViewportBilinearMin.y), PostProcessInput_0_UVViewportBilinearMax.y)));
  float3 tonemapped_pq = _74.rgb;
  if (PROCESSING_PATH == 0.f) {
    // Convert PQ -> sRGB
    _74.rgb = ConvertPQToSRGBWithTonemap(_74.rgb);
  }
  uint _80 = uint(MaterialCollection0_Vectors[0].w);
  bool _81 = (_80 == 1);
  float _98;
  float _99;
  float _100;
  float _101;
  float _102;
  float _103;
  float _104;
  float _105;
  float _106;
  float _192;
  float _203;
  float _214;
  float _267;
  float _268;
  float _269;
  float _270;
  float _271;
  float _272;
  float _273;
  float _274;
  float _275;
  float _361;
  float _372;
  float _383;
  float _434;
  float _435;
  float _436;
  float _437;
  float _438;
  float _439;
  float _440;
  float _441;
  float _442;
  float _528;
  float _539;
  float _550;
  float _595;
  float _596;
  float _597;
  float _598;
  float _599;
  float _600;
  float _601;
  float _602;
  float _603;
  float _689;
  float _700;
  float _711;
  float _874;
  float _875;
  float _876;
  float _877;
  float _878;
  float _879;
  float _880;
  float _881;
  float _882;
  float _968;
  float _979;
  float _990;
  float _1201;
  float _1202;
  float _1203;
  float _1204;
  float _1205;
  float _1206;
  float _1207;
  float _1208;
  float _1209;
  if (!_81) {
    if (!(_80 == 2)) {
      if (!(_80 == 3)) {
        bool _87 = (_80 == 4);
        _98 = select(_87, 1.0f, 0.6130973696708679f);
        _99 = select(_87, 0.0f, 0.3395231366157532f);
        _100 = select(_87, 0.0f, 0.04737941920757294f);
        _101 = select(_87, 0.0f, 0.07019372284412384f);
        _102 = select(_87, 1.0f, 0.9163538813591003f);
        _103 = select(_87, 0.0f, 0.013452421873807907f);
        _104 = select(_87, 0.0f, 0.0206155925989151f);
        _105 = select(_87, 0.0f, 0.10956978052854538f);
        _106 = select(_87, 1.0f, 0.8698145747184753f);
      } else {
        _98 = 1.4514392614364624f;
        _99 = -0.2365107536315918f;
        _100 = -0.21492856740951538f;
        _101 = -0.07655377686023712f;
        _102 = 1.17622971534729f;
        _103 = -0.09967592358589172f;
        _104 = 0.008316148072481155f;
        _105 = -0.006032449658960104f;
        _106 = 0.9977163076400757f;
      }
    } else {
      _98 = 0.9748950600624084f;
      _99 = 0.019599121063947678f;
      _100 = 0.005505889654159546f;
      _101 = 0.0021795169450342655f;
      _102 = 0.9955354928970337f;
      _103 = 0.0022849813103675842f;
      _104 = 0.004797239787876606f;
      _105 = 0.02453201450407505f;
      _106 = 0.9706708192825317f;
    }
  } else {
    _98 = 0.7357979416847229f;
    _99 = 0.21216651797294617f;
    _100 = 0.05203564465045929f;
    _101 = 0.0471799336373806f;
    _102 = 0.9380457401275635f;
    _103 = 0.014774417504668236f;
    _104 = 0.003563664620742202f;
    _105 = 0.04114188626408577f;
    _106 = 0.9552944302558899f;
  }
  float _140 = (pow(_74.x, 0.012683313339948654f));
  float _141 = (pow(_74.y, 0.012683313339948654f));
  float _142 = (pow(_74.z, 0.012683313339948654f));
  float _167 = exp2(log2(max(0.0f, (_140 + -0.8359375f)) / (18.8515625f - (_140 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _168 = exp2(log2(max(0.0f, (_141 + -0.8359375f)) / (18.8515625f - (_141 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _169 = exp2(log2(max(0.0f, (_142 + -0.8359375f)) / (18.8515625f - (_142 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _172 = mad(mad(-0.0832589864730835f, _106, mad(-0.6217921376228333f, _103, (_100 * 1.705051064491272f))), _169, mad(mad(-0.0832589864730835f, _105, mad(-0.6217921376228333f, _102, (_99 * 1.705051064491272f))), _168, (_167 * mad(-0.0832589864730835f, _104, mad(-0.6217921376228333f, _101, (_98 * 1.705051064491272f))))));
  float _175 = mad(mad(-0.010548308491706848f, _106, mad(1.140804648399353f, _103, (_100 * -0.13025647401809692f))), _169, mad(mad(-0.010548308491706848f, _105, mad(1.140804648399353f, _102, (_99 * -0.13025647401809692f))), _168, (_167 * mad(-0.010548308491706848f, _104, mad(1.140804648399353f, _101, (_98 * -0.13025647401809692f))))));
  float _178 = mad(mad(1.1529725790023804f, _106, mad(-0.1289689838886261f, _103, (_100 * -0.024003351107239723f))), _169, mad(mad(1.1529725790023804f, _105, mad(-0.1289689838886261f, _102, (_99 * -0.024003351107239723f))), _168, (_167 * mad(1.1529725790023804f, _104, mad(-0.1289689838886261f, _101, (_98 * -0.024003351107239723f))))));
  float _179 = _172 * 0.0033333334140479565f;
  float _180 = _175 * 0.0033333334140479565f;
  float _181 = _178 * 0.0033333334140479565f;
  if (_179 < 0.0031306699384003878f) {
    _192 = (_172 * 0.04306666925549507f);
  } else {
    _192 = (((pow(_179, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_180 < 0.0031306699384003878f) {
    _203 = (_175 * 0.04306666925549507f);
  } else {
    _203 = (((pow(_180, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_181 < 0.0031306699384003878f) {
    _214 = (_178 * 0.04306666925549507f);
  } else {
    _214 = (((pow(_181, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _223 = ((MaterialCollection0_Vectors[1].y) * (_192 - _74.x)) + _74.x;
  float _224 = ((MaterialCollection0_Vectors[1].y) * (_203 - _74.y)) + _74.y;
  float _225 = ((MaterialCollection0_Vectors[1].y) * (_214 - _74.z)) + _74.z;
  float4 _247 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(min(max(((PostProcessInput_0_UVViewportSize.x * _31) + PostProcessInput_0_UVViewportMin.x), PostProcessInput_0_UVViewportBilinearMin.x), PostProcessInput_0_UVViewportBilinearMax.x), min(max(((PostProcessInput_0_UVViewportSize.y * (_32 + 0.0010000000474974513f)) + PostProcessInput_0_UVViewportMin.y), PostProcessInput_0_UVViewportBilinearMin.y), PostProcessInput_0_UVViewportBilinearMax.y)));
  if (PROCESSING_PATH == 0.f) {
    // Convert PQ -> sRGB
    _247.rgb = ConvertPQToSRGBWithTonemap(_247.rgb);
  }
  if (!_81) {
    if (!(_80 == 2)) {
      if (!(_80 == 3)) {
        bool _256 = (_80 == 4);
        _267 = select(_256, 1.0f, 0.6130973696708679f);
        _268 = select(_256, 0.0f, 0.3395231366157532f);
        _269 = select(_256, 0.0f, 0.04737941920757294f);
        _270 = select(_256, 0.0f, 0.07019372284412384f);
        _271 = select(_256, 1.0f, 0.9163538813591003f);
        _272 = select(_256, 0.0f, 0.013452421873807907f);
        _273 = select(_256, 0.0f, 0.0206155925989151f);
        _274 = select(_256, 0.0f, 0.10956978052854538f);
        _275 = select(_256, 1.0f, 0.8698145747184753f);
      } else {
        _267 = 1.4514392614364624f;
        _268 = -0.2365107536315918f;
        _269 = -0.21492856740951538f;
        _270 = -0.07655377686023712f;
        _271 = 1.17622971534729f;
        _272 = -0.09967592358589172f;
        _273 = 0.008316148072481155f;
        _274 = -0.006032449658960104f;
        _275 = 0.9977163076400757f;
      }
    } else {
      _267 = 0.9748950600624084f;
      _268 = 0.019599121063947678f;
      _269 = 0.005505889654159546f;
      _270 = 0.0021795169450342655f;
      _271 = 0.9955354928970337f;
      _272 = 0.0022849813103675842f;
      _273 = 0.004797239787876606f;
      _274 = 0.02453201450407505f;
      _275 = 0.9706708192825317f;
    }
  } else {
    _267 = 0.7357979416847229f;
    _268 = 0.21216651797294617f;
    _269 = 0.05203564465045929f;
    _270 = 0.0471799336373806f;
    _271 = 0.9380457401275635f;
    _272 = 0.014774417504668236f;
    _273 = 0.003563664620742202f;
    _274 = 0.04114188626408577f;
    _275 = 0.9552944302558899f;
  }
  float _309 = (pow(_247.x, 0.012683313339948654f));
  float _310 = (pow(_247.y, 0.012683313339948654f));
  float _311 = (pow(_247.z, 0.012683313339948654f));
  float _336 = exp2(log2(max(0.0f, (_309 + -0.8359375f)) / (18.8515625f - (_309 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _337 = exp2(log2(max(0.0f, (_310 + -0.8359375f)) / (18.8515625f - (_310 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _338 = exp2(log2(max(0.0f, (_311 + -0.8359375f)) / (18.8515625f - (_311 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _341 = mad(mad(-0.0832589864730835f, _275, mad(-0.6217921376228333f, _272, (_269 * 1.705051064491272f))), _338, mad(mad(-0.0832589864730835f, _274, mad(-0.6217921376228333f, _271, (_268 * 1.705051064491272f))), _337, (_336 * mad(-0.0832589864730835f, _273, mad(-0.6217921376228333f, _270, (_267 * 1.705051064491272f))))));
  float _344 = mad(mad(-0.010548308491706848f, _275, mad(1.140804648399353f, _272, (_269 * -0.13025647401809692f))), _338, mad(mad(-0.010548308491706848f, _274, mad(1.140804648399353f, _271, (_268 * -0.13025647401809692f))), _337, (_336 * mad(-0.010548308491706848f, _273, mad(1.140804648399353f, _270, (_267 * -0.13025647401809692f))))));
  float _347 = mad(mad(1.1529725790023804f, _275, mad(-0.1289689838886261f, _272, (_269 * -0.024003351107239723f))), _338, mad(mad(1.1529725790023804f, _274, mad(-0.1289689838886261f, _271, (_268 * -0.024003351107239723f))), _337, (_336 * mad(1.1529725790023804f, _273, mad(-0.1289689838886261f, _270, (_267 * -0.024003351107239723f))))));
  float _348 = _341 * 0.0033333334140479565f;
  float _349 = _344 * 0.0033333334140479565f;
  float _350 = _347 * 0.0033333334140479565f;
  if (_348 < 0.0031306699384003878f) {
    _361 = (_341 * 0.04306666925549507f);
  } else {
    _361 = (((pow(_348, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_349 < 0.0031306699384003878f) {
    _372 = (_344 * 0.04306666925549507f);
  } else {
    _372 = (((pow(_349, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_350 < 0.0031306699384003878f) {
    _383 = (_347 * 0.04306666925549507f);
  } else {
    _383 = (((pow(_350, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _393 = _32 + -0.0010000000474974513f;
  float4 _414 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(min(max(((PostProcessInput_0_UVViewportSize.x * _31) + PostProcessInput_0_UVViewportMin.x), PostProcessInput_0_UVViewportBilinearMin.x), PostProcessInput_0_UVViewportBilinearMax.x), min(max(((PostProcessInput_0_UVViewportSize.y * _393) + PostProcessInput_0_UVViewportMin.y), PostProcessInput_0_UVViewportBilinearMin.y), PostProcessInput_0_UVViewportBilinearMax.y)));
  if (PROCESSING_PATH == 0.f) {
    // Convert PQ -> sRGB
    _414.rgb = ConvertPQToSRGBWithTonemap(_414.rgb);
  }
  if (!_81) {
    if (!(_80 == 2)) {
      if (!(_80 == 3)) {
        bool _423 = (_80 == 4);
        _434 = select(_423, 1.0f, 0.6130973696708679f);
        _435 = select(_423, 0.0f, 0.3395231366157532f);
        _436 = select(_423, 0.0f, 0.04737941920757294f);
        _437 = select(_423, 0.0f, 0.07019372284412384f);
        _438 = select(_423, 1.0f, 0.9163538813591003f);
        _439 = select(_423, 0.0f, 0.013452421873807907f);
        _440 = select(_423, 0.0f, 0.0206155925989151f);
        _441 = select(_423, 0.0f, 0.10956978052854538f);
        _442 = select(_423, 1.0f, 0.8698145747184753f);
      } else {
        _434 = 1.4514392614364624f;
        _435 = -0.2365107536315918f;
        _436 = -0.21492856740951538f;
        _437 = -0.07655377686023712f;
        _438 = 1.17622971534729f;
        _439 = -0.09967592358589172f;
        _440 = 0.008316148072481155f;
        _441 = -0.006032449658960104f;
        _442 = 0.9977163076400757f;
      }
    } else {
      _434 = 0.9748950600624084f;
      _435 = 0.019599121063947678f;
      _436 = 0.005505889654159546f;
      _437 = 0.0021795169450342655f;
      _438 = 0.9955354928970337f;
      _439 = 0.0022849813103675842f;
      _440 = 0.004797239787876606f;
      _441 = 0.02453201450407505f;
      _442 = 0.9706708192825317f;
    }
  } else {
    _434 = 0.7357979416847229f;
    _435 = 0.21216651797294617f;
    _436 = 0.05203564465045929f;
    _437 = 0.0471799336373806f;
    _438 = 0.9380457401275635f;
    _439 = 0.014774417504668236f;
    _440 = 0.003563664620742202f;
    _441 = 0.04114188626408577f;
    _442 = 0.9552944302558899f;
  }
  float _476 = (pow(_414.x, 0.012683313339948654f));
  float _477 = (pow(_414.y, 0.012683313339948654f));
  float _478 = (pow(_414.z, 0.012683313339948654f));
  float _503 = exp2(log2(max(0.0f, (_476 + -0.8359375f)) / (18.8515625f - (_476 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _504 = exp2(log2(max(0.0f, (_477 + -0.8359375f)) / (18.8515625f - (_477 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _505 = exp2(log2(max(0.0f, (_478 + -0.8359375f)) / (18.8515625f - (_478 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _508 = mad(mad(-0.0832589864730835f, _442, mad(-0.6217921376228333f, _439, (_436 * 1.705051064491272f))), _505, mad(mad(-0.0832589864730835f, _441, mad(-0.6217921376228333f, _438, (_435 * 1.705051064491272f))), _504, (_503 * mad(-0.0832589864730835f, _440, mad(-0.6217921376228333f, _437, (_434 * 1.705051064491272f))))));
  float _511 = mad(mad(-0.010548308491706848f, _442, mad(1.140804648399353f, _439, (_436 * -0.13025647401809692f))), _505, mad(mad(-0.010548308491706848f, _441, mad(1.140804648399353f, _438, (_435 * -0.13025647401809692f))), _504, (_503 * mad(-0.010548308491706848f, _440, mad(1.140804648399353f, _437, (_434 * -0.13025647401809692f))))));
  float _514 = mad(mad(1.1529725790023804f, _442, mad(-0.1289689838886261f, _439, (_436 * -0.024003351107239723f))), _505, mad(mad(1.1529725790023804f, _441, mad(-0.1289689838886261f, _438, (_435 * -0.024003351107239723f))), _504, (_503 * mad(1.1529725790023804f, _440, mad(-0.1289689838886261f, _437, (_434 * -0.024003351107239723f))))));
  float _515 = _508 * 0.0033333334140479565f;
  float _516 = _511 * 0.0033333334140479565f;
  float _517 = _514 * 0.0033333334140479565f;
  if (_515 < 0.0031306699384003878f) {
    _528 = (_508 * 0.04306666925549507f);
  } else {
    _528 = (((pow(_515, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_516 < 0.0031306699384003878f) {
    _539 = (_511 * 0.04306666925549507f);
  } else {
    _539 = (((pow(_516, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_517 < 0.0031306699384003878f) {
    _550 = (_514 * 0.04306666925549507f);
  } else {
    _550 = (((pow(_517, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float4 _575 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(min(max(((PostProcessInput_0_UVViewportSize.x * (_31 + -0.0010000000474974513f)) + PostProcessInput_0_UVViewportMin.x), PostProcessInput_0_UVViewportBilinearMin.x), PostProcessInput_0_UVViewportBilinearMax.x), min(max(((PostProcessInput_0_UVViewportSize.y * _393) + PostProcessInput_0_UVViewportMin.y), PostProcessInput_0_UVViewportBilinearMin.y), PostProcessInput_0_UVViewportBilinearMax.y)));
  if (PROCESSING_PATH == 0.f) {
    // Convert PQ -> sRGB
    _575.rgb = ConvertPQToSRGBWithTonemap(_575.rgb);
  }
  if (!_81) {
    if (!(_80 == 2)) {
      if (!(_80 == 3)) {
        bool _584 = (_80 == 4);
        _595 = select(_584, 1.0f, 0.6130973696708679f);
        _596 = select(_584, 0.0f, 0.3395231366157532f);
        _597 = select(_584, 0.0f, 0.04737941920757294f);
        _598 = select(_584, 0.0f, 0.07019372284412384f);
        _599 = select(_584, 1.0f, 0.9163538813591003f);
        _600 = select(_584, 0.0f, 0.013452421873807907f);
        _601 = select(_584, 0.0f, 0.0206155925989151f);
        _602 = select(_584, 0.0f, 0.10956978052854538f);
        _603 = select(_584, 1.0f, 0.8698145747184753f);
      } else {
        _595 = 1.4514392614364624f;
        _596 = -0.2365107536315918f;
        _597 = -0.21492856740951538f;
        _598 = -0.07655377686023712f;
        _599 = 1.17622971534729f;
        _600 = -0.09967592358589172f;
        _601 = 0.008316148072481155f;
        _602 = -0.006032449658960104f;
        _603 = 0.9977163076400757f;
      }
    } else {
      _595 = 0.9748950600624084f;
      _596 = 0.019599121063947678f;
      _597 = 0.005505889654159546f;
      _598 = 0.0021795169450342655f;
      _599 = 0.9955354928970337f;
      _600 = 0.0022849813103675842f;
      _601 = 0.004797239787876606f;
      _602 = 0.02453201450407505f;
      _603 = 0.9706708192825317f;
    }
  } else {
    _595 = 0.7357979416847229f;
    _596 = 0.21216651797294617f;
    _597 = 0.05203564465045929f;
    _598 = 0.0471799336373806f;
    _599 = 0.9380457401275635f;
    _600 = 0.014774417504668236f;
    _601 = 0.003563664620742202f;
    _602 = 0.04114188626408577f;
    _603 = 0.9552944302558899f;
  }
  float _637 = (pow(_575.x, 0.012683313339948654f));
  float _638 = (pow(_575.y, 0.012683313339948654f));
  float _639 = (pow(_575.z, 0.012683313339948654f));
  float _664 = exp2(log2(max(0.0f, (_637 + -0.8359375f)) / (18.8515625f - (_637 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _665 = exp2(log2(max(0.0f, (_638 + -0.8359375f)) / (18.8515625f - (_638 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _666 = exp2(log2(max(0.0f, (_639 + -0.8359375f)) / (18.8515625f - (_639 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _669 = mad(mad(-0.0832589864730835f, _603, mad(-0.6217921376228333f, _600, (_597 * 1.705051064491272f))), _666, mad(mad(-0.0832589864730835f, _602, mad(-0.6217921376228333f, _599, (_596 * 1.705051064491272f))), _665, (_664 * mad(-0.0832589864730835f, _601, mad(-0.6217921376228333f, _598, (_595 * 1.705051064491272f))))));
  float _672 = mad(mad(-0.010548308491706848f, _603, mad(1.140804648399353f, _600, (_597 * -0.13025647401809692f))), _666, mad(mad(-0.010548308491706848f, _602, mad(1.140804648399353f, _599, (_596 * -0.13025647401809692f))), _665, (_664 * mad(-0.010548308491706848f, _601, mad(1.140804648399353f, _598, (_595 * -0.13025647401809692f))))));
  float _675 = mad(mad(1.1529725790023804f, _603, mad(-0.1289689838886261f, _600, (_597 * -0.024003351107239723f))), _666, mad(mad(1.1529725790023804f, _602, mad(-0.1289689838886261f, _599, (_596 * -0.024003351107239723f))), _665, (_664 * mad(1.1529725790023804f, _601, mad(-0.1289689838886261f, _598, (_595 * -0.024003351107239723f))))));
  float _676 = _669 * 0.0033333334140479565f;
  float _677 = _672 * 0.0033333334140479565f;
  float _678 = _675 * 0.0033333334140479565f;
  if (_676 < 0.0031306699384003878f) {
    _689 = (_669 * 0.04306666925549507f);
  } else {
    _689 = (((pow(_676, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_677 < 0.0031306699384003878f) {
    _700 = (_672 * 0.04306666925549507f);
  } else {
    _700 = (((pow(_677, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_678 < 0.0031306699384003878f) {
    _711 = (_675 * 0.04306666925549507f);
  } else {
    _711 = (((pow(_678, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _744 = dot(float3(((Material_PreshaderBuffer[4].z) * (_223 - ((((_575.x + _414.x) + ((((_361 - _247.x) * (MaterialCollection0_Vectors[1].y)) + _247.x) * 2.0f)) + (((_689 - _575.x) + (_528 - _414.x)) * (MaterialCollection0_Vectors[1].y))) * 0.25f))), ((Material_PreshaderBuffer[4].z) * (_224 - ((((_575.y + _414.y) + ((((_372 - _247.y) * (MaterialCollection0_Vectors[1].y)) + _247.y) * 2.0f)) + (((_700 - _575.y) + (_539 - _414.y)) * (MaterialCollection0_Vectors[1].y))) * 0.25f))), ((_225 - ((((_575.z + _414.z) + ((((_383 - _247.z) * (MaterialCollection0_Vectors[1].y)) + _247.z) * 2.0f)) + (((_711 - _575.z) + (_550 - _414.z)) * (MaterialCollection0_Vectors[1].y))) * 0.25f)) * (Material_PreshaderBuffer[4].z))), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
  float _752 = max(max(saturate(_744 + _223), saturate(_744 + _224)), saturate(_744 + _225));
  float _759 = saturate(((_752 * 16.0f) * (Material_PreshaderBuffer[4].w)) * (Material_PreshaderBuffer[5].w));
  float4 _796 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2((((((SV_Position.x - float((uint)(int)(PostProcessOutput_ViewportMin.x))) * PostProcessOutput_ViewportSizeInverse.x) * View_ViewSizeAndInvSize.x) + View_ViewRectMin.x) * View_BufferSizeAndInvSize.z), (((((SV_Position.y - float((uint)(int)(PostProcessOutput_ViewportMin.y))) * PostProcessOutput_ViewportSizeInverse.y) * View_ViewSizeAndInvSize.y) + View_ViewRectMin.y) * View_BufferSizeAndInvSize.w)), 0.0f);
  float _815 = (_759 + _52.x) + (saturate((Material_PreshaderBuffer[6].z) * (((View_InvDeviceZToWorldZTransform.x * _796.x) + View_InvDeviceZToWorldZTransform.y) + (1.0f / ((View_InvDeviceZToWorldZTransform.z * _796.x) - View_InvDeviceZToWorldZTransform.w)))) * (select((_752 <= 0.0f), 0.0f, exp2(log2(_752) * (Material_PreshaderBuffer[6].x))) - _759));
  float _824 = frac(sin(dot(float3(((Material_PreshaderBuffer[6].w) * View_GameTime), _32, _32), float3(270.0f, 183.0f, 246.0f)) * 6.2831854820251465f) * 43760.0f);
  float _828 = saturate((0.699999988079071f - _824) / (0.30000001192092896f - _824));
  float4 _854 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(min(max(((PostProcessInput_0_UVViewportSize.x * _31) + PostProcessInput_0_UVViewportMin.x), PostProcessInput_0_UVViewportBilinearMin.x), PostProcessInput_0_UVViewportBilinearMax.x), min(max((((_32 - ((_828 * _828) * (3.0f - (_828 * 2.0f)))) * PostProcessInput_0_UVViewportSize.y) + PostProcessInput_0_UVViewportMin.y), PostProcessInput_0_UVViewportBilinearMin.y), PostProcessInput_0_UVViewportBilinearMax.y)));
  if (PROCESSING_PATH == 0.f) {
    // Convert PQ -> sRGB
    _854.rgb = ConvertPQToSRGBWithTonemap(_854.rgb);
  }
  if (!_81) {
    if (!(_80 == 2)) {
      if (!(_80 == 3)) {
        bool _863 = (_80 == 4);
        _874 = select(_863, 1.0f, 0.6130973696708679f);
        _875 = select(_863, 0.0f, 0.3395231366157532f);
        _876 = select(_863, 0.0f, 0.04737941920757294f);
        _877 = select(_863, 0.0f, 0.07019372284412384f);
        _878 = select(_863, 1.0f, 0.9163538813591003f);
        _879 = select(_863, 0.0f, 0.013452421873807907f);
        _880 = select(_863, 0.0f, 0.0206155925989151f);
        _881 = select(_863, 0.0f, 0.10956978052854538f);
        _882 = select(_863, 1.0f, 0.8698145747184753f);
      } else {
        _874 = 1.4514392614364624f;
        _875 = -0.2365107536315918f;
        _876 = -0.21492856740951538f;
        _877 = -0.07655377686023712f;
        _878 = 1.17622971534729f;
        _879 = -0.09967592358589172f;
        _880 = 0.008316148072481155f;
        _881 = -0.006032449658960104f;
        _882 = 0.9977163076400757f;
      }
    } else {
      _874 = 0.9748950600624084f;
      _875 = 0.019599121063947678f;
      _876 = 0.005505889654159546f;
      _877 = 0.0021795169450342655f;
      _878 = 0.9955354928970337f;
      _879 = 0.0022849813103675842f;
      _880 = 0.004797239787876606f;
      _881 = 0.02453201450407505f;
      _882 = 0.9706708192825317f;
    }
  } else {
    _874 = 0.7357979416847229f;
    _875 = 0.21216651797294617f;
    _876 = 0.05203564465045929f;
    _877 = 0.0471799336373806f;
    _878 = 0.9380457401275635f;
    _879 = 0.014774417504668236f;
    _880 = 0.003563664620742202f;
    _881 = 0.04114188626408577f;
    _882 = 0.9552944302558899f;
  }
  float _916 = (pow(_854.x, 0.012683313339948654f));
  float _917 = (pow(_854.y, 0.012683313339948654f));
  float _918 = (pow(_854.z, 0.012683313339948654f));
  float _943 = exp2(log2(max(0.0f, (_916 + -0.8359375f)) / (18.8515625f - (_916 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _944 = exp2(log2(max(0.0f, (_917 + -0.8359375f)) / (18.8515625f - (_917 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _945 = exp2(log2(max(0.0f, (_918 + -0.8359375f)) / (18.8515625f - (_918 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _948 = mad(mad(-0.0832589864730835f, _882, mad(-0.6217921376228333f, _879, (_876 * 1.705051064491272f))), _945, mad(mad(-0.0832589864730835f, _881, mad(-0.6217921376228333f, _878, (_875 * 1.705051064491272f))), _944, (_943 * mad(-0.0832589864730835f, _880, mad(-0.6217921376228333f, _877, (_874 * 1.705051064491272f))))));
  float _951 = mad(mad(-0.010548308491706848f, _882, mad(1.140804648399353f, _879, (_876 * -0.13025647401809692f))), _945, mad(mad(-0.010548308491706848f, _881, mad(1.140804648399353f, _878, (_875 * -0.13025647401809692f))), _944, (_943 * mad(-0.010548308491706848f, _880, mad(1.140804648399353f, _877, (_874 * -0.13025647401809692f))))));
  float _954 = mad(mad(1.1529725790023804f, _882, mad(-0.1289689838886261f, _879, (_876 * -0.024003351107239723f))), _945, mad(mad(1.1529725790023804f, _881, mad(-0.1289689838886261f, _878, (_875 * -0.024003351107239723f))), _944, (_943 * mad(1.1529725790023804f, _880, mad(-0.1289689838886261f, _877, (_874 * -0.024003351107239723f))))));
  float _955 = _948 * 0.0033333334140479565f;
  float _956 = _951 * 0.0033333334140479565f;
  float _957 = _954 * 0.0033333334140479565f;
  if (_955 < 0.0031306699384003878f) {
    _968 = (_948 * 0.04306666925549507f);
  } else {
    _968 = (((pow(_955, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_956 < 0.0031306699384003878f) {
    _979 = (_951 * 0.04306666925549507f);
  } else {
    _979 = (((pow(_956, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_957 < 0.0031306699384003878f) {
    _990 = (_954 * 0.04306666925549507f);
  } else {
    _990 = (((pow(_957, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float4 _1069 = Material_Texture2D_1.Sample(Material_Clamp_WorldGroupSettings, float2((((max(saturate((1.0f - ((Material_PreshaderBuffer[8].z) * abs(abs(((round(frac((Material_PreshaderBuffer[7].y) * View_GameTime) * 10.0f) * 0.10000000149011612f) + sin(_35 * (Material_PreshaderBuffer[7].x))) + (Material_PreshaderBuffer[7].z)) - (Material_PreshaderBuffer[7].w)))) * (Material_PreshaderBuffer[9].z)), saturate((1.0f - ((Material_PreshaderBuffer[11].y) * abs(abs(((round(frac((Material_PreshaderBuffer[10].x) * View_GameTime) * 10.0f) * 0.10000000149011612f) + sin(_35 * (Material_PreshaderBuffer[9].w))) + (Material_PreshaderBuffer[10].y)) - (Material_PreshaderBuffer[10].z)))) * (Material_PreshaderBuffer[12].y))) * (max(max((((_968 - _854.x) * (MaterialCollection0_Vectors[1].y)) + _854.x), (((_979 - _854.y) * (MaterialCollection0_Vectors[1].y)) + _854.y)), (((_990 - _854.z) * (MaterialCollection0_Vectors[1].y)) + _854.z)) - _815)) * (((Material_PreshaderBuffer[12].z) * (1.0f - (MaterialCollection1_Vectors[1].x))) + (MaterialCollection1_Vectors[1].x))) + _815), (Material_PreshaderBuffer[13].z)));
  float _1111 = ((select((_1069.x >= 0.5f), (1.0f - (((1.0f - _1069.x) * 2.0f) * (Material_PreshaderBuffer[16].x))), ((_1069.x * 2.0f) * (Material_PreshaderBuffer[15].x))) - _47) * 0.699999988079071f) + _47;
  float _1112 = ((select((_1069.y >= 0.5f), (1.0f - (((1.0f - _1069.y) * 2.0f) * (Material_PreshaderBuffer[16].y))), ((_1069.y * 2.0f) * (Material_PreshaderBuffer[15].y))) - _48) * 0.699999988079071f) + _48;
  float _1113 = ((select((_1069.z >= 0.5f), (1.0f - (((1.0f - _1069.z) * 2.0f) * (Material_PreshaderBuffer[16].z))), ((_1069.z * 2.0f) * (Material_PreshaderBuffer[15].z))) - _49) * 0.699999988079071f) + _49;
  float _1140 = (Material_PreshaderBuffer[18].y) * max(View_ViewSizeAndInvSize.x, View_ViewSizeAndInvSize.y);
  float _1143 = ((SV_Position.x - float((uint)(int)(PostProcessOutput_ViewportMin.x))) / _1140) + ((Material_PreshaderBuffer[17].w) * View_GameTime);
  float _1144 = ((SV_Position.y - float((uint)(int)(PostProcessOutput_ViewportMin.y))) / _1140) + ((Material_PreshaderBuffer[18].x) * View_GameTime);
  float _1155 = frac(sin(dot(float3(_1143, _1144, _1143), float3(127.0f, 312.0f, 74.69999694824219f)) * 6.2831854820251465f) * 43760.0f) - frac(sin(dot(float3(_1144, _1143, _1143), float3(270.0f, 183.0f, 246.0f)) * 6.2831854820251465f) * 43760.0f);
  float _1156 = 1.0f - _1155;
  float _1170 = select((_1111 >= 0.5f), (1.0f - (((1.0f - _1111) * 2.0f) * _1156)), ((_1111 * 2.0f) * _1155));
  float _1172 = select((_1112 >= 0.5f), (1.0f - (((1.0f - _1112) * 2.0f) * _1156)), ((_1112 * 2.0f) * _1155));
  float _1174 = select((_1113 >= 0.5f), (1.0f - (((1.0f - _1113) * 2.0f) * _1156)), ((_1113 * 2.0f) * _1155));
  float _1182 = ((_1111 - _1170) * (Material_PreshaderBuffer[18].z)) + _1170;
  float _1183 = ((_1112 - _1172) * (Material_PreshaderBuffer[18].z)) + _1172;
  float _1184 = ((_1113 - _1174) * (Material_PreshaderBuffer[18].z)) + _1174;
  if (!_81) {
    if (!(_80 == 2)) {
      if (!(_80 == 3)) {
        bool _1190 = (_80 == 4);
        _1201 = select(_1190, 1.0f, 1.705051064491272f);
        _1202 = select(_1190, 0.0f, -0.6217921376228333f);
        _1203 = select(_1190, 0.0f, -0.0832589864730835f);
        _1204 = select(_1190, 0.0f, -0.13025647401809692f);
        _1205 = select(_1190, 1.0f, 1.140804648399353f);
        _1206 = select(_1190, 0.0f, -0.010548308491706848f);
        _1207 = select(_1190, 0.0f, -0.024003351107239723f);
        _1208 = select(_1190, 0.0f, -0.1289689838886261f);
        _1209 = select(_1190, 1.0f, 1.1529725790023804f);
      } else {
        _1201 = 0.6954522132873535f;
        _1202 = 0.14067870378494263f;
        _1203 = 0.16386906802654266f;
        _1204 = 0.044794563204050064f;
        _1205 = 0.8596711158752441f;
        _1206 = 0.0955343171954155f;
        _1207 = -0.005525882821530104f;
        _1208 = 0.004025210160762072f;
        _1209 = 1.0015007257461548f;
      }
    } else {
      _1201 = 1.0258246660232544f;
      _1202 = -0.020053181797266006f;
      _1203 = -0.005771636962890625f;
      _1204 = -0.002234415616840124f;
      _1205 = 1.0045864582061768f;
      _1206 = -0.002352118492126465f;
      _1207 = -0.005013350863009691f;
      _1208 = -0.025290070101618767f;
      _1209 = 1.0303035974502563f;
    }
  } else {
    _1201 = 1.3792141675949097f;
    _1202 = -0.30886411666870117f;
    _1203 = -0.0703500509262085f;
    _1204 = -0.06933490186929703f;
    _1205 = 1.08229660987854f;
    _1206 = -0.012961871922016144f;
    _1207 = -0.0021590073592960835f;
    _1208 = -0.0454593189060688f;
    _1209 = 1.0476183891296387f;
  }
  float _1237 = max(6.103519990574569e-05f, _1182);
  float _1238 = max(6.103519990574569e-05f, _1183);
  float _1239 = max(6.103519990574569e-05f, _1184);
  float _1261 = select((_1237 > 0.040449999272823334f), exp2(log2((_1237 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1237 * 0.07739938050508499f));
  float _1262 = select((_1238 > 0.040449999272823334f), exp2(log2((_1238 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1238 * 0.07739938050508499f));
  float _1263 = select((_1239 > 0.040449999272823334f), exp2(log2((_1239 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1239 * 0.07739938050508499f));
  float _1282 = exp2(log2(mad(mad(_1203, 0.8698145747184753f, mad(_1202, 0.013452421873807907f, (_1201 * 0.04737941920757294f))), _1263, mad(mad(_1203, 0.10956978052854538f, mad(_1202, 0.9163538813591003f, (_1201 * 0.3395231366157532f))), _1262, (_1261 * mad(_1203, 0.0206155925989151f, mad(_1202, 0.07019372284412384f, (_1201 * 0.6130973696708679f)))))) * 0.029999999329447746f) * 0.1593017578125f);
  float _1283 = exp2(log2(mad(mad(_1206, 0.8698145747184753f, mad(_1205, 0.013452421873807907f, (_1204 * 0.04737941920757294f))), _1263, mad(mad(_1206, 0.10956978052854538f, mad(_1205, 0.9163538813591003f, (_1204 * 0.3395231366157532f))), _1262, (_1261 * mad(_1206, 0.0206155925989151f, mad(_1205, 0.07019372284412384f, (_1204 * 0.6130973696708679f)))))) * 0.029999999329447746f) * 0.1593017578125f);
  float _1284 = exp2(log2(mad(mad(_1209, 0.8698145747184753f, mad(_1208, 0.013452421873807907f, (_1207 * 0.04737941920757294f))), _1263, mad(mad(_1209, 0.10956978052854538f, mad(_1208, 0.9163538813591003f, (_1207 * 0.3395231366157532f))), _1262, (_1261 * mad(_1209, 0.0206155925989151f, mad(_1208, 0.07019372284412384f, (_1207 * 0.6130973696708679f)))))) * 0.029999999329447746f) * 0.1593017578125f);
  float _1318 = ((exp2(log2((1.0f / ((_1282 * 18.6875f) + 1.0f)) * ((_1282 * 18.8515625f) + 0.8359375f)) * 78.84375f) - _1182) * (MaterialCollection0_Vectors[1].y)) + _1182;
  float _1319 = ((exp2(log2((1.0f / ((_1283 * 18.6875f) + 1.0f)) * ((_1283 * 18.8515625f) + 0.8359375f)) * 78.84375f) - _1183) * (MaterialCollection0_Vectors[1].y)) + _1183;
  float _1320 = ((exp2(log2((1.0f / ((_1284 * 18.6875f) + 1.0f)) * ((_1284 * 18.8515625f) + 0.8359375f)) * 78.84375f) - _1184) * (MaterialCollection0_Vectors[1].y)) + _1184;

  // Removed Max(0)
  SV_Target.x = ((((Material_PreshaderBuffer[19].x) - _1318) * (Material_PreshaderBuffer[18].w)) + _1318);
  SV_Target.y = ((((Material_PreshaderBuffer[19].y) - _1319) * (Material_PreshaderBuffer[18].w)) + _1319);
  SV_Target.z = ((((Material_PreshaderBuffer[19].z) - _1320) * (Material_PreshaderBuffer[18].w)) + _1320);
  SV_Target.w = 0.0f;
  if (PROCESSING_PATH == 0.f) {
    SV_Target.rgb = ConvertSRGBtoPQAndUpgradeToneMap(SV_Target.rgb, tonemapped_pq);
  }
  return SV_Target;
}
