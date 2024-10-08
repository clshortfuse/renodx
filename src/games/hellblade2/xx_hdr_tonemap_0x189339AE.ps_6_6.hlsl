#include "C:/mods/renodx/src/shaders/renodx.hlsl"

cbuffer _RootShaderParameters : register(b0, space0) {
  float3 GrainRandomFull : packoffset(c1.x);
  float FilmGrainIntensityShadows : packoffset(c1.w);
  float FilmGrainIntensityMidtones : packoffset(c2.x);
  float FilmGrainIntensityHighlights : packoffset(c2.y);
  float FilmGrainShadowsMax : packoffset(c2.z);
  float FilmGrainHighlightsMin : packoffset(c2.w);
  float FilmGrainHighlightsMax : packoffset(c3.x);
  float4 ScreenPosToFilmGrainTextureUV : packoffset(c5.x);
  float3 InverseGamma : packoffset(c7.x);
  float OutputMaxLuminance : packoffset(c8.y);
  float2 Color_Extent : packoffset(c9.x);
  float2 Color_ExtentInverse : packoffset(c9.z);
  float2 Color_ScreenPosToViewportScale : packoffset(c10.x);
  float2 Color_ScreenPosToViewportBias : packoffset(c10.z);
  uint2 Color_ViewportMin : packoffset(c11.x);
  uint2 Color_ViewportMax : packoffset(c11.z);
  float2 Color_ViewportSize : packoffset(c12);
  float2 Color_ViewportSizeInverse : packoffset(c12.z);
  float2 Color_UVViewportMin : packoffset(c13.x);
  float2 Color_UVViewportMax : packoffset(c13.z);
  float2 Color_UVViewportSize : packoffset(c14.x);
  float2 Color_UVViewportSizeInverse : packoffset(c14.z);
  float2 Color_UVViewportBilinearMin : packoffset(c15.x);
  float2 Color_UVViewportBilinearMax : packoffset(c15.z);
  float2 Output_Extent : packoffset(c16.x);
  float2 Output_ExtentInverse : packoffset(c16.z);
  float2 Output_ScreenPosToViewportScale : packoffset(c17.x);
  float2 Output_ScreenPosToViewportBias : packoffset(c17.z);
  uint2 Output_ViewportMin : packoffset(c18.x);
  uint2 Output_ViewportMax : packoffset(c18.z);
  float2 Output_ViewportSize : packoffset(c19.x);
  float2 Output_ViewportSizeInverse : packoffset(c19.z);
  float2 Output_UVViewportMin : packoffset(c20.x);
  float2 Output_UVViewportMax : packoffset(c20.z);
  float2 Output_UVViewportSize : packoffset(c21.x);
  float2 Output_UVViewportSizeInverse : packoffset(c21.z);
  float2 Output_UVViewportBilinearMin : packoffset(c22.x);
  float2 Output_UVViewportBilinearMax : packoffset(c22.z);
  float EyeAdaptation_ExposureLowPercent : packoffset(c23.x);
  float EyeAdaptation_ExposureHighPercent : packoffset(c23.y);
  float EyeAdaptation_MinAverageLuminance : packoffset(c23.z);
  float EyeAdaptation_MaxAverageLuminance : packoffset(c23.w);
  float EyeAdaptation_ExposureCompensationSettings : packoffset(c24.x);
  float EyeAdaptation_ExposureCompensationCurve : packoffset(c24.y);
  float EyeAdaptation_DeltaWorldTime : packoffset(c24.z);
  float EyeAdaptation_ExposureSpeedUp : packoffset(c24.w);
  float EyeAdaptation_ExposureSpeedDown : packoffset(c25.x);
  float EyeAdaptation_HistogramScale : packoffset(c25.y);
  float EyeAdaptation_HistogramBias : packoffset(c25.z);
  float EyeAdaptation_LuminanceMin : packoffset(c25.w);
  float EyeAdaptation_BlackHistogramBucketInfluence : packoffset(c26.x);
  float EyeAdaptation_GreyMult : packoffset(c26.y);
  float EyeAdaptation_ExponentialUpM : packoffset(c26.z);
  float EyeAdaptation_ExponentialDownM : packoffset(c26.w);
  float EyeAdaptation_StartDistance : packoffset(c27.x);
  float EyeAdaptation_LuminanceMax : packoffset(c27.y);
  float EyeAdaptation_IgnoreMaterialsEvaluationPositionBias : packoffset(c27.z);
  float EyeAdaptation_IgnoreMaterialsLuminanceScale : packoffset(c27.w);
  float EyeAdaptation_IgnoreMaterialsMinBaseColorLuminance : packoffset(c28.x);
  uint EyeAdaptation_IgnoreMaterialsReconstructFromSceneColor : packoffset(c28.y);
  float EyeAdaptation_ForceTarget : packoffset(c28.z);
  int EyeAdaptation_VisualizeDebugType : packoffset(c28.w);
  float LocalExposure_HighlightContrastScale : packoffset(c30.x);
  float LocalExposure_ShadowContrastScale : packoffset(c30.y);
  float LocalExposure_DetailStrength : packoffset(c30.z);
  float LocalExposure_BlurredLuminanceBlend : packoffset(c30.w);
  float LocalExposure_MiddleGreyExposureCompensation : packoffset(c31.x);
  float2 LocalExposure_BilateralGridUVScale : packoffset(c31.z);
  float4 ColorToBloom : packoffset(c33.x);
  float2 BloomUVViewportBilinearMin : packoffset(c34.x);
  float2 BloomUVViewportBilinearMax : packoffset(c34.z);
  float4 ColorScale0 : packoffset(c41.x);
  float4 BloomDirtMaskTint;
  float4 ChromaticAberrationParams;
  float4 TonemapperParams;  // 0.403183, 0,0,0
  float4 LensPrincipalPointOffsetScale;
  float4 LensPrincipalPointOffsetScaleInverse;
  float LUTSize;  // 32
  float InvLUTSize;
  float LUTScale;
  float LUTOffset;
  float EditorNITLevel;  // 160.39f
  float BackbufferQuantizationDithering;
  uint bOutputInHDR;
}

cbuffer UniformBufferConstants_View : register(b1, space0) {
  row_major float4x4 View_TranslatedWorldToClip;
  row_major float4x4 View_RelativeWorldToClip;
  row_major float4x4 View_ClipToRelativeWorld;
  row_major float4x4 View_TranslatedWorldToView;
  row_major float4x4 View_ViewToTranslatedWorld;
  row_major float4x4 View_TranslatedWorldToCameraView;
  row_major float4x4 View_CameraViewToTranslatedWorld;
  row_major float4x4 View_ViewToClip;
  row_major float4x4 View_ViewToClipNoAA;
  row_major float4x4 View_ClipToView;
  row_major float4x4 View_ClipToTranslatedWorld;
  row_major float4x4 View_SVPositionToTranslatedWorld;
  row_major float4x4 View_ScreenToRelativeWorld;
  row_major float4x4 View_ScreenToTranslatedWorld;
  row_major float4x4 View_MobileMultiviewShadowTransform;
  float3 View_ViewTilePosition;
  float PrePadding_View_972;
  float3 View_MatrixTilePosition;
  float PrePadding_View_988;
  float3 View_ViewForward;
  float PrePadding_View_1004;
  float3 View_ViewUp;
  float PrePadding_View_1020;
  float3 View_ViewRight;
  float PrePadding_View_1036;
  float3 View_HMDViewNoRollUp;
  float PrePadding_View_1052;
  float3 View_HMDViewNoRollRight;
  float PrePadding_View_1068;
  float4 View_InvDeviceZToWorldZTransform;
  float4 View_ScreenPositionScaleBias;
  float3 View_RelativeWorldCameraOrigin;
  float PrePadding_View_1116;
  float3 View_TranslatedWorldCameraOrigin;
  float PrePadding_View_1132;
  float3 View_RelativeWorldViewOrigin;
  float PrePadding_View_1148;
  float3 View_RelativePreViewTranslation;
  float PrePadding_View_1164;
  row_major float4x4 View_PrevViewToClip;
  row_major float4x4 View_PrevClipToView;
  row_major float4x4 View_PrevTranslatedWorldToClip;
  row_major float4x4 View_PrevTranslatedWorldToView;
  row_major float4x4 View_PrevViewToTranslatedWorld;
  row_major float4x4 View_PrevTranslatedWorldToCameraView;
  row_major float4x4 View_PrevCameraViewToTranslatedWorld;
  float3 View_PrevTranslatedWorldCameraOrigin;
  float PrePadding_View_1628;
  float3 View_PrevRelativeWorldCameraOrigin;
  float PrePadding_View_1644;
  float3 View_PrevRelativeWorldViewOrigin;
  float PrePadding_View_1660;
  float3 View_RelativePrevPreViewTranslation;
  float PrePadding_View_1676;
  row_major float4x4 View_PrevClipToRelativeWorld;
  row_major float4x4 View_PrevScreenToTranslatedWorld;
  row_major float4x4 View_ClipToPrevClip;
  row_major float4x4 View_ClipToPrevClipWithAA;
  float4 View_TemporalAAJitter;
  float4 View_GlobalClippingPlane;
  float2 View_FieldOfViewWideAngles;
  float2 View_PrevFieldOfViewWideAngles;
  float4 View_ViewRectMin;
  float4 View_ViewSizeAndInvSize;
  uint4 View_ViewRectMinAndSize;
  float4 View_LightProbeSizeRatioAndInvSizeRatio;
  float4 View_BufferSizeAndInvSize;
  float4 View_BufferBilinearUVMinMax;
  float4 View_ScreenToViewSpace;
  float2 View_BufferToSceneTextureScale;
  float2 View_ResolutionFractionAndInv;
  int View_NumSceneColorMSAASamples;
  float View_ProjectionDepthThicknessScale;
  float View_PreExposure;
  float View_OneOverPreExposure;
  float4 View_DiffuseOverrideParameter;
  float4 View_SpecularOverrideParameter;
  float4 View_NormalOverrideParameter;
  float2 View_RoughnessOverrideParameter;
  float View_PrevFrameGameTime;
  float View_PrevFrameRealTime;
  float View_OutOfBoundsMask;
  float PrePadding_View_2196;
  float PrePadding_View_2200;
  float PrePadding_View_2204;
  float3 View_WorldCameraMovementSinceLastFrame;
  float View_CullingSign;
  float View_NearPlane;
  float View_GameTime;
  float View_RealTime;
  float View_PhotoModeTime;
  float View_PrevFramePhotoModeTime;
  float View_DeltaTime;
  float View_MaterialTextureMipBias;
  float View_MaterialTextureDerivativeMultiply;
  uint View_Random;
  uint View_FrameNumber;
  uint View_FrameCounter;
  uint View_StateFrameIndexMod8;
  uint View_StateFrameIndex;
  uint View_DebugViewModeMask;
  uint View_WorldIsPaused;
  float View_CameraCut;
  float View_UnlitViewmodeMask;
  float PrePadding_View_2292;
  float PrePadding_View_2296;
  float PrePadding_View_2300;
  float4 View_DirectionalLightColor;
  float3 View_DirectionalLightDirection;
  float PrePadding_View_2332;
  float4 View_TranslucencyLightingVolumeMin[2];
  float4 View_TranslucencyLightingVolumeInvSize[2];
  float4 View_TemporalAAParams;
  float4 View_CircleDOFParams;
  float View_DepthOfFieldSensorWidth;
  float View_DepthOfFieldFocalDistance;
  float View_DepthOfFieldScale;
  float View_DepthOfFieldFocalLength;
  float View_DepthOfFieldFocalRegion;
  float View_DepthOfFieldNearTransitionRegion;
  float View_DepthOfFieldFarTransitionRegion;
  float View_MotionBlurNormalizedToPixel;
  float View_GeneralPurposeTweak;
  float View_GeneralPurposeTweak2;
  float View_DemosaicVposOffset;
  float View_DecalDepthBias;
  float3 View_IndirectLightingColorScale;
  float PrePadding_View_2492;
  float3 View_PrecomputedIndirectLightingColorScale;
  float PrePadding_View_2508;
  float3 View_PrecomputedIndirectSpecularColorScale;
  float PrePadding_View_2524;
  float4 View_AtmosphereLightDirection[2];
  float4 View_AtmosphereLightIlluminanceOnGroundPostTransmittance[2];
  float4 View_AtmosphereLightIlluminanceOuterSpace[2];
  float4 View_AtmosphereLightDiscLuminance[2];
  float4 View_AtmosphereLightDiscCosHalfApexAngle_PPTrans[2];
  float4 View_SkyViewLutSizeAndInvSize;
  float3 View_SkyCameraTranslatedWorldOrigin;
  float PrePadding_View_2716;
  float4 View_SkyPlanetTranslatedWorldCenterAndViewHeight;
  row_major float4x4 View_SkyViewLutReferential;
  float4 View_SkyAtmosphereSkyLuminanceFactor;
  float View_SkyAtmospherePresentInScene;
  float View_SkyAtmosphereHeightFogContribution;
  float View_SkyAtmosphereBottomRadiusKm;
  float View_SkyAtmosphereTopRadiusKm;
  float4 View_SkyAtmosphereCameraAerialPerspectiveVolumeSizeAndInvSize;
  float View_SkyAtmosphereAerialPerspectiveStartDepthKm;
  float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthResolution;
  float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthResolutionInv;
  float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthSliceLengthKm;
  float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthSliceLengthKmInv;
  float View_SkyAtmosphereApplyCameraAerialPerspectiveVolume;
  float PrePadding_View_2872;
  float PrePadding_View_2876;
  float3 View_NormalCurvatureToRoughnessScaleBias;
  float View_RenderingReflectionCaptureMask;
  float View_RealTimeReflectionCapture;
  float View_RealTimeReflectionCapturePreExposure;
  float PrePadding_View_2904;
  float PrePadding_View_2908;
  float4 View_AmbientCubemapTint;
  float View_AmbientCubemapIntensity;
  float View_SkyLightApplyPrecomputedBentNormalShadowingFlag;
  float View_SkyLightAffectReflectionFlag;
  float View_SkyLightAffectGlobalIlluminationFlag;
  float4 View_SkyLightColor;
  float4 View_MobileSkyIrradianceEnvironmentMap[8];
  float View_MobilePreviewMode;
  float View_HMDEyePaddingOffset;
  float View_ReflectionCubemapMaxMip;
  float View_ShowDecalsMask;
  uint View_DistanceFieldAOSpecularOcclusionMode;
  float View_IndirectCapsuleSelfShadowingIntensity;
  float PrePadding_View_3112;
  float PrePadding_View_3116;
  float3 View_ReflectionEnvironmentRoughnessMixingScaleBiasAndLargestWeight;
  int View_StereoPassIndex;
  float4 View_GlobalVolumeTranslatedCenterAndExtent[6];
  float4 View_GlobalVolumeTranslatedWorldToUVAddAndMul[6];
  float4 View_GlobalDistanceFieldMipTranslatedWorldToUVScale[6];
  float4 View_GlobalDistanceFieldMipTranslatedWorldToUVBias[6];
  float View_GlobalDistanceFieldMipFactor;
  float View_GlobalDistanceFieldMipTransition;
  int View_GlobalDistanceFieldClipmapSizeInPages;
  int PrePadding_View_3532;
  float3 View_GlobalDistanceFieldInvPageAtlasSize;
  float PrePadding_View_3548;
  float3 View_GlobalDistanceFieldInvCoverageAtlasSize;
  float View_GlobalVolumeDimension;
  float View_GlobalVolumeTexelSize;
  float View_MaxGlobalDFAOConeDistance;
  uint View_NumGlobalSDFClipmaps;
  float View_CoveredExpandSurfaceScale;
  float View_NotCoveredExpandSurfaceScale;
  float View_NotCoveredMinStepScale;
  float View_DitheredTransparencyStepThreshold;
  float View_DitheredTransparencyTraceThreshold;
  int2 View_CursorPosition;
  float View_bCheckerboardSubsurfaceProfileRendering;
  float PrePadding_View_3612;
  float3 View_VolumetricFogInvGridSize;
  float PrePadding_View_3628;
  float3 View_VolumetricFogGridZParams;
  float PrePadding_View_3644;
  float2 View_VolumetricFogSVPosToVolumeUV;
  float2 View_VolumetricFogViewGridUVToPrevViewRectUV;
  float2 View_VolumetricFogPrevViewGridRectUVToResourceUV;
  float2 View_VolumetricFogPrevUVMax;
  float2 View_VolumetricFogScreenToResourceUV;
  float2 View_VolumetricFogUVMax;
  float View_VolumetricFogMaxDistance;
  float PrePadding_View_3700;
  float PrePadding_View_3704;
  float PrePadding_View_3708;
  float3 View_VolumetricLightmapWorldToUVScale;
  float PrePadding_View_3724;
  float3 View_VolumetricLightmapWorldToUVAdd;
  float PrePadding_View_3740;
  float3 View_VolumetricLightmapIndirectionTextureSize;
  float View_VolumetricLightmapBrickSize;
  float3 View_VolumetricLightmapBrickTexelSize;
  float View_IndirectLightingCacheShowFlag;
  float View_EyeToPixelSpreadAngle;
  float PrePadding_View_3780;
  float PrePadding_View_3784;
  float PrePadding_View_3788;
  float4 View_XRPassthroughCameraUVs[2];
  float View_GlobalVirtualTextureMipBias;
  uint View_VirtualTextureFeedbackShift;
  uint View_VirtualTextureFeedbackMask;
  uint View_VirtualTextureFeedbackStride;
  uint View_VirtualTextureFeedbackJitterOffset;
  uint View_VirtualTextureFeedbackSampleOffset;
  uint PrePadding_View_3848;
  uint PrePadding_View_3852;
  float4 View_RuntimeVirtualTextureMipLevel;
  float2 View_RuntimeVirtualTexturePackHeight;
  float PrePadding_View_3880;
  float PrePadding_View_3884;
  float4 View_RuntimeVirtualTextureDebugParams;
  float View_OverrideLandscapeLOD;
  int View_FarShadowStaticMeshLODBias;
  float View_MinRoughness;
  float View_FireflyClampingThreshold;
  float4 View_HairRenderInfo;
  uint View_EnableSkyLight;
  uint View_HairRenderInfoBits;
  uint View_HairComponents;
  float View_bSubsurfacePostprocessEnabled;
  float4 View_SSProfilesTextureSizeAndInvSize;
  float4 View_SSProfilesPreIntegratedTextureSizeAndInvSize;
  float4 View_SpecularProfileTextureSizeAndInvSize;
  float3 View_PhysicsFieldClipmapCenter;
  float View_PhysicsFieldClipmapDistance;
  int View_PhysicsFieldClipmapResolution;
  int View_PhysicsFieldClipmapExponent;
  int View_PhysicsFieldClipmapCount;
  int View_PhysicsFieldTargetCount;
  int4 View_PhysicsFieldTargets[32];
  uint View_GPUSceneViewId;
  float View_ViewResolutionFraction;
  float View_SubSurfaceColorAsTransmittanceAtDistanceInMeters;
  float PrePadding_View_4556;
  float4 View_TanAndInvTanHalfFOV;
  float4 View_PrevTanAndInvTanHalfFOV;
  float4 View_GlintLUTParameters0;
  float4 View_GlintLUTParameters1;
  uint BindlessSampler_View_MaterialTextureBilinearWrapedSampler;
  uint PrePadding_View_4628;
  uint BindlessSampler_View_MaterialTextureBilinearClampedSampler;
  uint PrePadding_View_4636;
  uint BindlessResource_View_VolumetricLightmapIndirectionTexture;
  uint PrePadding_View_4644;
  uint BindlessResource_View_VolumetricLightmapBrickAmbientVector;
  uint PrePadding_View_4652;
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients0;
  uint PrePadding_View_4660;
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients1;
  uint PrePadding_View_4668;
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients2;
  uint PrePadding_View_4676;
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients3;
  uint PrePadding_View_4684;
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients4;
  uint PrePadding_View_4692;
  uint BindlessResource_View_VolumetricLightmapBrickSHCoefficients5;
  uint PrePadding_View_4700;
  uint BindlessResource_View_SkyBentNormalBrickTexture;
  uint PrePadding_View_4708;
  uint BindlessResource_View_DirectionalLightShadowingBrickTexture;
  uint PrePadding_View_4716;
  uint BindlessSampler_View_VolumetricLightmapBrickAmbientVectorSampler;
  uint PrePadding_View_4724;
  uint BindlessSampler_View_VolumetricLightmapTextureSampler0;
  uint PrePadding_View_4732;
  uint BindlessSampler_View_VolumetricLightmapTextureSampler1;
  uint PrePadding_View_4740;
  uint BindlessSampler_View_VolumetricLightmapTextureSampler2;
  uint PrePadding_View_4748;
  uint BindlessSampler_View_VolumetricLightmapTextureSampler3;
  uint PrePadding_View_4756;
  uint BindlessSampler_View_VolumetricLightmapTextureSampler4;
  uint PrePadding_View_4764;
  uint BindlessSampler_View_VolumetricLightmapTextureSampler5;
  uint PrePadding_View_4772;
  uint BindlessSampler_View_SkyBentNormalTextureSampler;
  uint PrePadding_View_4780;
  uint BindlessSampler_View_DirectionalLightShadowingTextureSampler;
  uint PrePadding_View_4788;
  uint BindlessResource_View_GlobalDistanceFieldPageAtlasTexture;
  uint PrePadding_View_4796;
  uint BindlessResource_View_GlobalDistanceFieldCoverageAtlasTexture;
  uint PrePadding_View_4804;
  uint BindlessResource_View_GlobalDistanceFieldPageTableTexture;
  uint PrePadding_View_4812;
  uint BindlessResource_View_GlobalDistanceFieldMipTexture;
  uint PrePadding_View_4820;
  uint BindlessSampler_View_GlobalDistanceFieldPageAtlasTextureSampler;
  uint PrePadding_View_4828;
  uint BindlessSampler_View_GlobalDistanceFieldCoverageAtlasTextureSampler;
  uint PrePadding_View_4836;
  uint BindlessSampler_View_GlobalDistanceFieldMipTextureSampler;
  uint PrePadding_View_4844;
  uint BindlessResource_View_AtmosphereTransmittanceTexture;
  uint PrePadding_View_4852;
  uint BindlessSampler_View_AtmosphereTransmittanceTextureSampler;
  uint PrePadding_View_4860;
  uint BindlessResource_View_AtmosphereIrradianceTexture;
  uint PrePadding_View_4868;
  uint BindlessSampler_View_AtmosphereIrradianceTextureSampler;
  uint PrePadding_View_4876;
  uint BindlessResource_View_AtmosphereInscatterTexture;
  uint PrePadding_View_4884;
  uint BindlessSampler_View_AtmosphereInscatterTextureSampler;
  uint PrePadding_View_4892;
  uint BindlessResource_View_PerlinNoiseGradientTexture;
  uint PrePadding_View_4900;
  uint BindlessSampler_View_PerlinNoiseGradientTextureSampler;
  uint PrePadding_View_4908;
  uint BindlessResource_View_PerlinNoise3DTexture;
  uint PrePadding_View_4916;
  uint BindlessSampler_View_PerlinNoise3DTextureSampler;
  uint PrePadding_View_4924;
  uint BindlessResource_View_SobolSamplingTexture;
  uint PrePadding_View_4932;
  uint BindlessSampler_View_SharedPointWrappedSampler;
  uint PrePadding_View_4940;
  uint BindlessSampler_View_SharedPointClampedSampler;
  uint PrePadding_View_4948;
  uint BindlessSampler_View_SharedBilinearWrappedSampler;
  uint PrePadding_View_4956;
  uint BindlessSampler_View_SharedBilinearClampedSampler;
  uint PrePadding_View_4964;
  uint BindlessSampler_View_SharedBilinearAnisoClampedSampler;
  uint PrePadding_View_4972;
  uint BindlessSampler_View_SharedTrilinearWrappedSampler;
  uint PrePadding_View_4980;
  uint BindlessSampler_View_SharedTrilinearClampedSampler;
  uint PrePadding_View_4988;
  uint BindlessResource_View_PreIntegratedBRDF;
  uint PrePadding_View_4996;
  uint BindlessSampler_View_PreIntegratedBRDFSampler;
  uint PrePadding_View_5004;
  uint BindlessResource_View_SkyIrradianceEnvironmentMap;
  uint PrePadding_View_5012;
  uint BindlessResource_View_TransmittanceLutTexture;
  uint PrePadding_View_5020;
  uint BindlessSampler_View_TransmittanceLutTextureSampler;
  uint PrePadding_View_5028;
  uint BindlessResource_View_SkyViewLutTexture;
  uint PrePadding_View_5036;
  uint BindlessSampler_View_SkyViewLutTextureSampler;
  uint PrePadding_View_5044;
  uint BindlessResource_View_DistantSkyLightLutTexture;
  uint PrePadding_View_5052;
  uint BindlessSampler_View_DistantSkyLightLutTextureSampler;
  uint PrePadding_View_5060;
  uint BindlessResource_View_CameraAerialPerspectiveVolume;
  uint PrePadding_View_5068;
  uint BindlessSampler_View_CameraAerialPerspectiveVolumeSampler;
  uint PrePadding_View_5076;
  uint BindlessResource_View_CameraAerialPerspectiveVolumeMieOnly;
  uint PrePadding_View_5084;
  uint BindlessSampler_View_CameraAerialPerspectiveVolumeMieOnlySampler;
  uint PrePadding_View_5092;
  uint BindlessResource_View_CameraAerialPerspectiveVolumeRayOnly;
  uint PrePadding_View_5100;
  uint BindlessSampler_View_CameraAerialPerspectiveVolumeRayOnlySampler;
  uint PrePadding_View_5108;
  uint BindlessResource_View_HairScatteringLUTTexture;
  uint PrePadding_View_5116;
  uint BindlessSampler_View_HairScatteringLUTSampler;
  uint PrePadding_View_5124;
  uint BindlessResource_View_GGXLTCMatTexture;
  uint PrePadding_View_5132;
  uint BindlessSampler_View_GGXLTCMatSampler;
  uint PrePadding_View_5140;
  uint BindlessResource_View_GGXLTCAmpTexture;
  uint PrePadding_View_5148;
  uint BindlessSampler_View_GGXLTCAmpSampler;
  uint PrePadding_View_5156;
  uint BindlessResource_View_SheenLTCTexture;
  uint PrePadding_View_5164;
  uint BindlessSampler_View_SheenLTCSampler;
  uint PrePadding_View_5172;
  uint View_bShadingEnergyConservation;
  uint View_bShadingEnergyPreservation;
  uint BindlessResource_View_ShadingEnergyGGXSpecTexture;
  uint PrePadding_View_5188;
  uint BindlessResource_View_ShadingEnergyGGXGlassTexture;
  uint PrePadding_View_5196;
  uint BindlessResource_View_ShadingEnergyClothSpecTexture;
  uint PrePadding_View_5204;
  uint BindlessResource_View_ShadingEnergyDiffuseTexture;
  uint PrePadding_View_5212;
  uint BindlessSampler_View_ShadingEnergySampler;
  uint PrePadding_View_5220;
  uint BindlessResource_View_GlintTexture;
  uint PrePadding_View_5228;
  uint BindlessSampler_View_GlintSampler;
  uint PrePadding_View_5236;
  uint BindlessResource_View_SimpleVolumeTexture;
  uint PrePadding_View_5244;
  uint BindlessSampler_View_SimpleVolumeTextureSampler;
  uint PrePadding_View_5252;
  uint BindlessResource_View_SimpleVolumeEnvTexture;
  uint PrePadding_View_5260;
  uint BindlessSampler_View_SimpleVolumeEnvTextureSampler;
  uint PrePadding_View_5268;
  uint BindlessResource_View_SSProfilesTexture;
  uint PrePadding_View_5276;
  uint BindlessSampler_View_SSProfilesSampler;
  uint PrePadding_View_5284;
  uint BindlessSampler_View_SSProfilesTransmissionSampler;
  uint PrePadding_View_5292;
  uint BindlessResource_View_SSProfilesPreIntegratedTexture;
  uint PrePadding_View_5300;
  uint BindlessSampler_View_SSProfilesPreIntegratedSampler;
  uint PrePadding_View_5308;
  uint BindlessResource_View_SpecularProfileTexture;
  uint PrePadding_View_5316;
  uint BindlessSampler_View_SpecularProfileSampler;
  uint PrePadding_View_5324;
  uint BindlessResource_View_WaterIndirection;
  uint PrePadding_View_5332;
  uint BindlessResource_View_WaterData;
  uint PrePadding_View_5340;
  float4 View_RectLightAtlasSizeAndInvSize;
  float View_RectLightAtlasMaxMipLevel;
  float PrePadding_View_5364;
  uint BindlessResource_View_RectLightAtlasTexture;
  uint PrePadding_View_5372;
  uint BindlessSampler_View_RectLightAtlasSampler;
  uint PrePadding_View_5380;
  uint PrePadding_View_5384;
  uint PrePadding_View_5388;
  float4 View_IESAtlasSizeAndInvSize;
  uint BindlessResource_View_IESAtlasTexture;
  uint PrePadding_View_5412;
  uint BindlessSampler_View_IESAtlasSampler;
  uint PrePadding_View_5420;
  uint BindlessSampler_View_LandscapeWeightmapSampler;
  uint PrePadding_View_5428;
  uint BindlessResource_View_LandscapeIndirection;
  uint PrePadding_View_5436;
  uint BindlessResource_View_LandscapePerComponentData;
  uint PrePadding_View_5444;
  uint BindlessResource_View_VTFeedbackBuffer;
  uint PrePadding_View_5452;
  uint BindlessResource_View_PhysicsFieldClipmapBuffer;
  uint PrePadding_View_5460;
  uint PrePadding_View_5464;
  uint PrePadding_View_5468;
  float3 View_TLASRelativePreViewTranslation;
  float PrePadding_View_5484;
  float3 View_TLASViewTilePosition;
}

StructuredBuffer<float4> EyeAdaptationBuffer : register(t0, space0);
Texture2D<float4> ColorTexture : register(t1, space0);
Texture2D<float4> BloomTexture : register(t2, space0);
StructuredBuffer<float4> SceneColorApplyParamaters : register(t3, space0);
Texture2D<float3> FilmGrainTexture : register(t4, space0);
StructuredBuffer<float4> FilmGrainTextureConstants : register(t5, space0);
Texture2D<float4> BloomDirtMaskTexture : register(t6, space0);
Texture3D<float4> ColorGradingLUT : register(t7, space0);
SamplerState ColorSampler : register(s0, space0);
SamplerState BloomSampler : register(s1, space0);
SamplerState FilmGrainSampler : register(s2, space0);
SamplerState BloomDirtMaskSampler : register(s3, space0);
SamplerState ColorGradingLUTSampler : register(s4, space0);

static float2 TEXCOORD;
static float2 TEXCOORD_1;
static float4 TEXCOORD_2;
static float2 TEXCOORD_3;
static float2 TEXCOORD_4;
static float4 SV_Target;
static float SV_Target_1;

struct SPIRV_Cross_Input {
  noperspective float2 TEXCOORD : TEXCOORD0;
  noperspective float2 TEXCOORD_1 : TEXCOORD1;
  noperspective float4 TEXCOORD_2 : TEXCOORD2;
  noperspective float2 TEXCOORD_3 : TEXCOORD3;
  noperspective float2 TEXCOORD_4 : TEXCOORD4;
  noperspective float4 SV_POSITION : SV_POSITION;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float SV_Target_1 : SV_Target1;
};

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  TEXCOORD_1 = stage_input.TEXCOORD_1;
  TEXCOORD_2 = stage_input.TEXCOORD_2;
  TEXCOORD_3 = stage_input.TEXCOORD_3;
  TEXCOORD_4 = stage_input.TEXCOORD_4;

  float _View_OneOverPreExposure = View_OneOverPreExposure;
  float _EyeAdaptationBuffer0x = EyeAdaptationBuffer.Load(0u).x;
  float3 _ChromaticAberrationParams = ChromaticAberrationParams.xyz;
  float4 _LensPrincipalPointOffsetScale = LensPrincipalPointOffsetScale;

  float2 _98_99 = _LensPrincipalPointOffsetScale.zw * TEXCOORD_3.xy + _LensPrincipalPointOffsetScale.xy;
  // float _98 = (_LensPrincipalPointOffsetScale.z * TEXCOORD_3.x) + _LensPrincipalPointOffsetScale.x;
  // float _99 = (_LensPrincipalPointOffsetScale.w * TEXCOORD_3.y) + _LensPrincipalPointOffsetScale.y;

  float _98 = _98_99.x;
  float _99 = _98_99.y;
  float2 _112_113a = (_98_99 > float2(0, 0));
  float2 _112_113b = (_98_99 < float2(0, 0));
  int2 _112_113c = _112_113a - _112_113b;
  // float _112 = float((_98 > 0.0f) - (_98 < 0.0f));
  // float _113 = float((_99 > 0.0f) - (_99 < 0.0f));
  float _112 = _112_113c.x;
  float _113 = _112_113c.y;

  // float _120 = saturate(abs(_98) - _ChromaticAberrationParams.z);
  // float _121 = saturate(abs(_99) - _ChromaticAberrationParams.z);

  float2 _120_121 = abs(_98_99) - _ChromaticAberrationParams.z;
  _120_121 = saturate(_120_121);
  float _120 = _120_121.x;
  float _121 = _120_121.y;

  float4 _188 = ColorTexture.Sample(
    ColorSampler,
    float2(min(max((((((_98 - ((_120 * _ChromaticAberrationParams.x) * _112)) * LensPrincipalPointOffsetScaleInverse.z) + LensPrincipalPointOffsetScaleInverse.x) * Color_ScreenPosToViewportScale.x) + Color_ScreenPosToViewportBias.x) * Color_ExtentInverse.x, Color_UVViewportBilinearMin.x), Color_UVViewportBilinearMax.x), min(max((((((_99 - ((_121 * ChromaticAberrationParams.x) * _113)) * LensPrincipalPointOffsetScaleInverse.w) + LensPrincipalPointOffsetScaleInverse.y) * Color_ScreenPosToViewportScale.y) + Color_ScreenPosToViewportBias.y) * Color_ExtentInverse.y, Color_UVViewportBilinearMin.y), Color_UVViewportBilinearMax.y))
  );
  float _190 = _188.x;
  float4 _204 = ColorTexture.Sample(
    ColorSampler,
    float2(min(max(((Color_ScreenPosToViewportScale.x * (((_98 - ((_120 * _ChromaticAberrationParams.y) * _112)) * LensPrincipalPointOffsetScaleInverse.z) + LensPrincipalPointOffsetScaleInverse.x)) + Color_ScreenPosToViewportBias.x) * Color_ExtentInverse.x, Color_UVViewportBilinearMin.x), Color_UVViewportBilinearMax.x), min(max(((Color_ScreenPosToViewportScale.y * (((_99 - ((_121 * _ChromaticAberrationParams.y) * _113)) * LensPrincipalPointOffsetScaleInverse.w) + LensPrincipalPointOffsetScaleInverse.y)) + Color_ScreenPosToViewportBias.y) * Color_ExtentInverse.y, Color_UVViewportBilinearMin.y), Color_UVViewportBilinearMax.y))
  );
  float _206 = _204.y;
  float4 _220 = ColorTexture.Sample(
    ColorSampler, float2(min(max(TEXCOORD.x, Color_UVViewportBilinearMin.x), Color_UVViewportBilinearMax.x), min(max(TEXCOORD.y, Color_UVViewportBilinearMin.y), Color_UVViewportBilinearMax.y))
  );
  float _222 = _220.z;
  float4 _248 = BloomTexture.Sample(
    BloomSampler,
    float2(min(max((ColorToBloom.x * TEXCOORD.x) + ColorToBloom.z, BloomUVViewportBilinearMin.x), BloomUVViewportBilinearMax.x), min(max((ColorToBloom.y * TEXCOORD.y) + ColorToBloom.w, BloomUVViewportBilinearMin.y), BloomUVViewportBilinearMax.y))
  );
  float4 _271 = BloomDirtMaskTexture.Sample(
    BloomDirtMaskSampler,
    float2((((_LensPrincipalPointOffsetScale.z * TEXCOORD_3.x) + _LensPrincipalPointOffsetScale.x) * 0.5f) + 0.5f, 0.5f - (((_LensPrincipalPointOffsetScale.w * TEXCOORD_3.y) + _LensPrincipalPointOffsetScale.y) * 0.5f))
  );
  float _295 = TonemapperParams.x * TEXCOORD_1.x;
  float _296 = TonemapperParams.x * TEXCOORD_1.y;
  float _301 = 1.0f / (dot(float2(_295, _296), float2(_295, _296)) + 1.0f);
  float3 _321 = float3(SceneColorApplyParamaters.Load(0u).xyz);
  float _326 = dot(float3(_190, _206, _222), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
  float _346 = (floor(Color_Extent.x * TEXCOORD.x) * 2.0f) + (-1.0f);
  float _351 = (floor(Color_Extent.y * TEXCOORD.y) * 2.0f) + (-1.0f);
  float4 _368 = ColorTexture.Sample(
    ColorSampler, float2(min(max((_346 * Color_ExtentInverse.x) + TEXCOORD.x, Color_UVViewportBilinearMin.x), Color_UVViewportBilinearMax.x), min(max(TEXCOORD.y, Color_UVViewportBilinearMin.y), Color_UVViewportBilinearMax.y))
  );
  float _370 = _368.x;
  float4 _391 = ColorTexture.Sample(
    ColorSampler, float2(min(max(TEXCOORD.x, Color_UVViewportBilinearMin.x), Color_UVViewportBilinearMax.x), min(max((Color_ExtentInverse.y * _351) + TEXCOORD.y, Color_UVViewportBilinearMin.y), Color_UVViewportBilinearMax.y))
  );
  float _393 = _391.x;
  float _418 = _EyeAdaptationBuffer0x * _View_OneOverPreExposure;
  float _432 = (-0.0f) - (TonemapperParams.y * clamp(1.0f - (_418 * max(max(abs(_326 - dot(float3(_370, _368.yz), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f))), abs(_326 - dot(float3(_393, _391.yz), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)))), max(abs(ddx_fine(_326) * _346), abs(ddy_fine(_326) * _351)))), 0.0f, 1.0f));
  float _462 = _418 * (_301 * _301);
  float _475 = (((_462 * ColorScale0.x) * _321.x) * ((((((((_370 - (_190 * 4.0f)) + _393) + _190) - (ddx_fine(_190) * _346)) + _190) - (ddy_fine(_190) * _351)) * _432) + _190)) + ((((BloomDirtMaskTint.x * _271.x) + 1.0f) * _248.x) * _462);
  float _476 = (((_462 * ColorScale0.y) * _321.y) * ((((((((_368.y - (_206 * 4.0f)) + _391.y) + _206) - (ddx_fine(_206) * _346)) + _206) - (ddy_fine(_206) * _351)) * _432) + _206)) + ((((BloomDirtMaskTint.y * _271.y) + 1.0f) * _248.y) * _462);
  float _477 = (((_462 * ColorScale0.z) * _321.z) * ((((((((_368.z - (_222 * 4.0f)) + _391.z) + _222) - (ddx_fine(_222) * _346)) + _222) - (ddy_fine(_222) * _351)) * _432) + _222)) + ((((BloomDirtMaskTint.z * _271.z) + 1.0f) * _248.z) * _462);
  float _478 = _475 * 0.00999999977648258209228515625f;
  float _480 = _476 * 0.00999999977648258209228515625f;
  float _481 = _477 * 0.00999999977648258209228515625f;
  float _489 = exp2(log2(_478) * 0.1593017578125f);
  float _490 = exp2(log2(_480) * 0.1593017578125f);
  float _491 = exp2(log2(_481) * 0.1593017578125f);
  float4 _538 = ColorGradingLUT.Sample(
    ColorGradingLUTSampler,
    float3((LUTScale * exp2(log2((1.0f / ((_489 * 18.6875f) + 1.0f)) * ((_489 * 18.8515625f) + 0.8359375f)) * 78.84375f)) + LUTOffset, (LUTScale * exp2(log2((1.0f / ((_490 * 18.6875f) + 1.0f)) * ((_490 * 18.8515625f) + 0.8359375f)) * 78.84375f)) + LUTOffset, (LUTScale * exp2(log2((1.0f / ((_491 * 18.6875f) + 1.0f)) * ((_491 * 18.8515625f) + 0.8359375f)) * 78.84375f)) + LUTOffset)
  );
  float3 _557 = FilmGrainTextureConstants.Load(0u).xyz;
  float _561 = dot(float3(_475, _476, _477), float3(0.0405550040304660797119140625f, 0.73296964168548583984375f, -0.0315674953162670135498046875f));
  float _571 = clamp(_561 / FilmGrainShadowsMax, 0.0f, 1.0f);
  float _576 = (_571 * _571) * (3.0f - (_571 * 2.0f));
  float _585 = clamp((_561 - FilmGrainHighlightsMin) / (FilmGrainHighlightsMax - FilmGrainHighlightsMin), 0.0f, 1.0f);
  float _589 = (_585 * _585) * (3.0f - (_585 * 2.0f));
  float _600 = (((_576 - _589) * FilmGrainIntensityMidtones) + (FilmGrainIntensityShadows * (1.0f - _576))) + (FilmGrainIntensityHighlights * _589);
  float3 _615 = FilmGrainTexture.SampleLevel(
    FilmGrainSampler,
    float2((ScreenPosToFilmGrainTextureUV.x * TEXCOORD_3.x) + ScreenPosToFilmGrainTextureUV.z, (ScreenPosToFilmGrainTextureUV.y * TEXCOORD_3.y) + ScreenPosToFilmGrainTextureUV.w),
    0.0f
  );
  float _641 = exp2(log2(_478 * ((((_615.x * _557.x) + (-1.0f)) * _600) + 1.0f)) * 0.1593017578125f);
  float _642 = exp2(log2(_480 * ((((_615.y * _557.y) + (-1.0f)) * _600) + 1.0f)) * 0.1593017578125f);
  float _643 = exp2(log2(_481 * ((((_615.z * _557.z) + (-1.0f)) * _600) + 1.0f)) * 0.1593017578125f);
  float4 _684 = ColorGradingLUT.Sample(
    ColorGradingLUTSampler,
    float3((LUTScale * exp2(log2((1.0f / ((_641 * 18.6875f) + 1.0f)) * ((_641 * 18.8515625f) + 0.8359375f)) * 78.84375f)) + LUTOffset, (LUTScale * exp2(log2((1.0f / ((_642 * 18.6875f) + 1.0f)) * ((_642 * 18.8515625f) + 0.8359375f)) * 78.84375f)) + LUTOffset, (LUTScale * exp2(log2((1.0f / ((_643 * 18.6875f) + 1.0f)) * ((_643 * 18.8515625f) + 0.8359375f)) * 78.84375f)) + LUTOffset)
  );
  float _689 = _684.x * 1.0499999523162841796875f;
  float _690 = _684.y * 1.0499999523162841796875f;
  float _691 = _684.z * 1.0499999523162841796875f;
  float _704;
  float _706;
  float _708;

  if (bOutputInHDR == 0u) {
    _704 = _689;
    _706 = _690;
    _708 = _691;
  } else {
    float _747 = exp2(log2(_689) * 0.0126833133399486541748046875f);
    float _748 = exp2(log2(_690) * 0.0126833133399486541748046875f);
    float _749 = exp2(log2(_691) * 0.0126833133399486541748046875f);
    float _786 = max(6.1035199905745685100555419921875e-05f, (exp2(log2(max(0.0f, _747 + (-0.8359375f)) / (18.8515625f - (_747 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f) / EditorNITLevel);
    float _788 = max(6.1035199905745685100555419921875e-05f, (exp2(log2(max(0.0f, _748 + (-0.8359375f)) / (18.8515625f - (_748 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f) / EditorNITLevel);
    float _789 = max(6.1035199905745685100555419921875e-05f, (exp2(log2(max(0.0f, _749 + (-0.8359375f)) / (18.8515625f - (_749 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f) / EditorNITLevel);
    _704 = min(_786 * 12.9200000762939453125f, (exp2(log2(max(_786, 0.00313066993840038776397705078125f)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
    _706 = min(_788 * 12.9200000762939453125f, (exp2(log2(max(_788, 0.00313066993840038776397705078125f)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
    _708 = min(_789 * 12.9200000762939453125f, (exp2(log2(max(_789, 0.00313066993840038776397705078125f)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
  }
  float _718 = (frac(sin((TEXCOORD_2.w * 543.30999755859375f) + TEXCOORD_2.z) * 493013.0f) * 2.0f) + (-1.0f);
  float _722 = min(max(_718 * asfloat(0x7f800000u /* inf */), -1.0f), 1.0f);
  float _732 = (_722 - (sqrt(clamp(1.0f - abs(_718), 0.0f, 1.0f)) * _722)) * BackbufferQuantizationDithering;
  SV_Target.x = _732 + _704;
  SV_Target.y = _732 + _706;
  SV_Target.z = _732 + _708;
  // SV_Target.rgb = 0;
  SV_Target.w = 0.0f;
  SV_Target_1 = dot(float3(_538.x * 1.0499999523162841796875f, _538.y * 1.0499999523162841796875f, _538.z * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));

  float3 untonemapped = ColorTexture.Sample(ColorSampler, TEXCOORD.xy, 0);
  float3 outputColor = bOutputInHDR;
  SV_Target.rgb = renodx::color::pq::Encode(outputColor, 100.f);
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
