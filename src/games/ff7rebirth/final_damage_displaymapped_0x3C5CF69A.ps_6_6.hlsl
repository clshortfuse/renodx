#define USE_DEFAULT
#define USE_OVERLAY

#include "./hdrcomposite.hlsl"

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 TEXCOORD_1: TEXCOORD1,
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  return HDRComposite(TEXCOORD, TEXCOORD_1, SV_Position);
}

// Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0);

// Texture2D<float4> ColorTexture : register(t1);

// Texture2D<float4> GlareTexture : register(t2);

// Texture2D<float4> CompositeSDRTexture : register(t3);

// Texture3D<float4> BT709PQToBT2020PQLUT : register(t4);

// Texture3D<float4> BT2020PQTosRGBLUT : register(t5);

// Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t6);

// cbuffer $Globals : register(b0) {
//   float4 PostprocessInput0Size : packoffset(c000.x);
//   float4 PostprocessInput1Size : packoffset(c001.x);
//   float4 PostprocessInput2Size : packoffset(c002.x);
//   float4 PostprocessInput3Size : packoffset(c003.x);
//   float4 PostprocessInput4Size : packoffset(c004.x);
//   float4 PostprocessInput5Size : packoffset(c005.x);
//   float4 PostprocessInput6Size : packoffset(c006.x);
//   float4 PostprocessInput7Size : packoffset(c007.x);
//   float4 PostprocessInput8Size : packoffset(c008.x);
//   float4 PostprocessInput9Size : packoffset(c009.x);
//   float4 PostprocessInput10Size : packoffset(c010.x);
//   float4 PostprocessInput0MinMax : packoffset(c011.x);
//   float4 PostprocessInput1MinMax : packoffset(c012.x);
//   float4 PostprocessInput2MinMax : packoffset(c013.x);
//   float4 PostprocessInput3MinMax : packoffset(c014.x);
//   float4 PostprocessInput4MinMax : packoffset(c015.x);
//   float4 PostprocessInput5MinMax : packoffset(c016.x);
//   float4 PostprocessInput6MinMax : packoffset(c017.x);
//   float4 PostprocessInput7MinMax : packoffset(c018.x);
//   float4 PostprocessInput8MinMax : packoffset(c019.x);
//   float4 PostprocessInput9MinMax : packoffset(c020.x);
//   float4 PostprocessInput10MinMax : packoffset(c021.x);
//   float4 ViewportSize : packoffset(c022.x);
//   uint4 ViewportRect : packoffset(c023.x);
//   float4 ScreenPosToPixel : packoffset(c024.x);
//   float4 SceneColorBufferUVViewport : packoffset(c025.x);
//   float3 MappingPolynomial : packoffset(c026.x);
//   float2 ViewportColor_Extent : packoffset(c027.x);
//   float2 ViewportColor_ExtentInverse : packoffset(c027.z);
//   float2 ViewportColor_ScreenPosToViewportScale : packoffset(c028.x);
//   float2 ViewportColor_ScreenPosToViewportBias : packoffset(c028.z);
//   uint2 ViewportColor_ViewportMin : packoffset(c029.x);
//   uint2 ViewportColor_ViewportMax : packoffset(c029.z);
//   float2 ViewportColor_ViewportSize : packoffset(c030.x);
//   float2 ViewportColor_ViewportSizeInverse : packoffset(c030.z);
//   float2 ViewportColor_UVViewportMin : packoffset(c031.x);
//   float2 ViewportColor_UVViewportMax : packoffset(c031.z);
//   float2 ViewportColor_UVViewportSize : packoffset(c032.x);
//   float2 ViewportColor_UVViewportSizeInverse : packoffset(c032.z);
//   float2 ViewportColor_UVViewportBilinearMin : packoffset(c033.x);
//   float2 ViewportColor_UVViewportBilinearMax : packoffset(c033.z);
//   float2 ViewportGlare_Extent : packoffset(c034.x);
//   float2 ViewportGlare_ExtentInverse : packoffset(c034.z);
//   float2 ViewportGlare_ScreenPosToViewportScale : packoffset(c035.x);
//   float2 ViewportGlare_ScreenPosToViewportBias : packoffset(c035.z);
//   uint2 ViewportGlare_ViewportMin : packoffset(c036.x);
//   uint2 ViewportGlare_ViewportMax : packoffset(c036.z);
//   float2 ViewportGlare_ViewportSize : packoffset(c037.x);
//   float2 ViewportGlare_ViewportSizeInverse : packoffset(c037.z);
//   float2 ViewportGlare_UVViewportMin : packoffset(c038.x);
//   float2 ViewportGlare_UVViewportMax : packoffset(c038.z);
//   float2 ViewportGlare_UVViewportSize : packoffset(c039.x);
//   float2 ViewportGlare_UVViewportSizeInverse : packoffset(c039.z);
//   float2 ViewportGlare_UVViewportBilinearMin : packoffset(c040.x);
//   float2 ViewportGlare_UVViewportBilinearMax : packoffset(c040.z);
//   float2 ViewportDestination_Extent : packoffset(c041.x);
//   float2 ViewportDestination_ExtentInverse : packoffset(c041.z);
//   float2 ViewportDestination_ScreenPosToViewportScale : packoffset(c042.x);
//   float2 ViewportDestination_ScreenPosToViewportBias : packoffset(c042.z);
//   uint2 ViewportDestination_ViewportMin : packoffset(c043.x);
//   uint2 ViewportDestination_ViewportMax : packoffset(c043.z);
//   float2 ViewportDestination_ViewportSize : packoffset(c044.x);
//   float2 ViewportDestination_ViewportSizeInverse : packoffset(c044.z);
//   float2 ViewportDestination_UVViewportMin : packoffset(c045.x);
//   float2 ViewportDestination_UVViewportMax : packoffset(c045.z);
//   float2 ViewportDestination_UVViewportSize : packoffset(c046.x);
//   float2 ViewportDestination_UVViewportSizeInverse : packoffset(c046.z);
//   float2 ViewportDestination_UVViewportBilinearMin : packoffset(c047.x);
//   float2 ViewportDestination_UVViewportBilinearMax : packoffset(c047.z);
//   float4 VignetteContext : packoffset(c048.x);
//   float4 GlareContext : packoffset(c049.x);
//   float4 NoiseContext : packoffset(c050.x);
//   float4 HDRCompositionContext : packoffset(c051.x);
//   float4 HDRCompositionContextColor : packoffset(c052.x);
//   float4 CompositeSurfaceContext : packoffset(c053.x);
//   float4 DeviceCorrectorContext : packoffset(c054.x);
//   float4 DevelopmentContext : packoffset(c055.x);
// };

// cbuffer View : register(b1) {
//   row_major float4x4 View_TranslatedWorldToClip : packoffset(c000.x);
//   row_major float4x4 View_WorldToOrthographicClip : packoffset(c004.x);
//   row_major float4x4 View_TranslatedWorldToOrthographicClip : packoffset(c008.x);
//   row_major float4x4 View_WorldToClip : packoffset(c012.x);
//   row_major float4x4 View_ClipToWorld : packoffset(c016.x);
//   row_major float4x4 View_TranslatedWorldToView : packoffset(c020.x);
//   row_major float4x4 View_ViewToTranslatedWorld : packoffset(c024.x);
//   row_major float4x4 View_TranslatedWorldToCameraView : packoffset(c028.x);
//   row_major float4x4 View_CameraViewToTranslatedWorld : packoffset(c032.x);
//   row_major float4x4 View_ViewToClip : packoffset(c036.x);
//   row_major float4x4 View_ViewToClipNoAA : packoffset(c040.x);
//   row_major float4x4 View_ClipToView : packoffset(c044.x);
//   row_major float4x4 View_ClipToTranslatedWorld : packoffset(c048.x);
//   row_major float4x4 View_SVPositionToTranslatedWorld : packoffset(c052.x);
//   row_major float4x4 View_ScreenToWorld : packoffset(c056.x);
//   row_major float4x4 View_ScreenToTranslatedWorld : packoffset(c060.x);
//   row_major float4x4 View_MobileMultiviewShadowTransform : packoffset(c064.x);
//   float3 View_ViewForward : packoffset(c068.x);
//   float PrePadding_View_1100 : packoffset(c068.w);
//   float3 View_ViewUp : packoffset(c069.x);
//   float PrePadding_View_1116 : packoffset(c069.w);
//   float3 View_ViewRight : packoffset(c070.x);
//   float PrePadding_View_1132 : packoffset(c070.w);
//   float3 View_HMDViewNoRollUp : packoffset(c071.x);
//   float PrePadding_View_1148 : packoffset(c071.w);
//   float3 View_HMDViewNoRollRight : packoffset(c072.x);
//   float PrePadding_View_1164 : packoffset(c072.w);
//   float4 View_InvDeviceZToWorldZTransform : packoffset(c073.x);
//   float4 View_ScreenPositionScaleBias : packoffset(c074.x);
//   float3 View_WorldCameraOrigin : packoffset(c075.x);
//   float PrePadding_View_1212 : packoffset(c075.w);
//   float3 View_TranslatedWorldCameraOrigin : packoffset(c076.x);
//   float PrePadding_View_1228 : packoffset(c076.w);
//   float3 View_WorldViewOrigin : packoffset(c077.x);
//   float PrePadding_View_1244 : packoffset(c077.w);
//   float3 View_PreViewTranslation : packoffset(c078.x);
//   float PrePadding_View_1260 : packoffset(c078.w);
//   row_major float4x4 View_PrevProjection : packoffset(c079.x);
//   row_major float4x4 View_PrevViewProj : packoffset(c083.x);
//   row_major float4x4 View_PrevViewRotationProj : packoffset(c087.x);
//   row_major float4x4 View_PrevViewToClip : packoffset(c091.x);
//   row_major float4x4 View_PrevClipToView : packoffset(c095.x);
//   row_major float4x4 View_PrevTranslatedWorldToClip : packoffset(c099.x);
//   row_major float4x4 View_PrevWorldToOrthographicClip : packoffset(c103.x);
//   row_major float4x4 View_PrevTranslatedWorldToOrthographicClip : packoffset(c107.x);
//   row_major float4x4 View_PrevTranslatedWorldToView : packoffset(c111.x);
//   row_major float4x4 View_PrevViewToTranslatedWorld : packoffset(c115.x);
//   row_major float4x4 View_PrevTranslatedWorldToCameraView : packoffset(c119.x);
//   row_major float4x4 View_PrevCameraViewToTranslatedWorld : packoffset(c123.x);
//   float3 View_PrevWorldCameraOrigin : packoffset(c127.x);
//   float PrePadding_View_2044 : packoffset(c127.w);
//   float3 View_PrevWorldViewOrigin : packoffset(c128.x);
//   float PrePadding_View_2060 : packoffset(c128.w);
//   float3 View_PrevPreViewTranslation : packoffset(c129.x);
//   float PrePadding_View_2076 : packoffset(c129.w);
//   row_major float4x4 View_PrevInvViewProj : packoffset(c130.x);
//   row_major float4x4 View_PrevScreenToTranslatedWorld : packoffset(c134.x);
//   row_major float4x4 View_ClipToPrevClip : packoffset(c138.x);
//   row_major float4x4 View_ClipToPrevClipWithoutTranslation : packoffset(c142.x);
//   row_major float4x4 View_ProjectionToWorld : packoffset(c146.x);
//   row_major float4x4 View_WorldToProjection : packoffset(c150.x);
//   float4 View_TemporalAAJitter : packoffset(c154.x);
//   float4 View_TemporalSamplerBias : packoffset(c155.x);
//   float4 View_GlobalClippingPlane : packoffset(c156.x);
//   float2 View_FieldOfViewWideAngles : packoffset(c157.x);
//   float2 View_PrevFieldOfViewWideAngles : packoffset(c157.z);
//   float4 View_ViewRectMin : packoffset(c158.x);
//   float4 View_ViewSizeAndInvSize : packoffset(c159.x);
//   float4 View_LightProbeSizeRatioAndInvSizeRatio : packoffset(c160.x);
//   float4 View_BufferSizeAndInvSize : packoffset(c161.x);
//   float4 View_BufferBilinearUVMinMax : packoffset(c162.x);
//   float4 View_ScreenToViewSpace : packoffset(c163.x);
//   int View_NumSceneColorMSAASamples : packoffset(c164.x);
//   float View_PreExposure : packoffset(c164.y);
//   float View_OneOverPreExposure : packoffset(c164.z);
//   float View_PreviousPreExposure : packoffset(c164.w);
//   float View_PreviousOneOverPreExposure : packoffset(c165.x);
//   float PrePadding_View_2644 : packoffset(c165.y);
//   float PrePadding_View_2648 : packoffset(c165.z);
//   float PrePadding_View_2652 : packoffset(c165.w);
//   float4 View_DiffuseOverrideParameter : packoffset(c166.x);
//   float4 View_SpecularOverrideParameter : packoffset(c167.x);
//   float4 View_NormalOverrideParameter : packoffset(c168.x);
//   float4 View_RoughnessOverrideParameter : packoffset(c169.x);
//   float View_PrevFrameGameTime : packoffset(c170.x);
//   float View_PrevFrameRealTime : packoffset(c170.y);
//   float View_OutOfBoundsMask : packoffset(c170.z);
//   float PrePadding_View_2732 : packoffset(c170.w);
//   float3 View_WorldCameraMovementSinceLastFrame : packoffset(c171.x);
//   float View_CullingSign : packoffset(c171.w);
//   float View_NearPlane : packoffset(c172.x);
//   float View_AdaptiveTessellationFactor : packoffset(c172.y);
//   float View_GameTime : packoffset(c172.z);
//   float View_RealTime : packoffset(c172.w);
//   float View_DeltaTime : packoffset(c173.x);
//   float View_EnvironmentTime : packoffset(c173.y);
//   float View_PreviousEnvironmentTime : packoffset(c173.z);
//   float View_MaterialTextureMipBias : packoffset(c173.w);
//   float View_MaterialTextureDerivativeMultiply : packoffset(c174.x);
//   uint View_Random : packoffset(c174.y);
//   uint View_FrameNumber : packoffset(c174.z);
//   uint View_StateFrameIndexMod8 : packoffset(c174.w);
//   uint View_StateFrameIndex : packoffset(c175.x);
//   uint View_StateFrameDelayIndex : packoffset(c175.y);
//   uint View_DebugViewModeMask : packoffset(c175.z);
//   float View_CameraCut : packoffset(c175.w);
//   float View_UnlitViewmodeMask : packoffset(c176.x);
//   float PrePadding_View_2820 : packoffset(c176.y);
//   float PrePadding_View_2824 : packoffset(c176.z);
//   float PrePadding_View_2828 : packoffset(c176.w);
//   float4 View_DirectionalLightColor : packoffset(c177.x);
//   float3 View_DirectionalLightDirection : packoffset(c178.x);
//   float PrePadding_View_2860 : packoffset(c178.w);
//   float4 View_TranslucencyLightingVolumeMin[2] : packoffset(c179.x);
//   float4 View_TranslucencyLightingVolumeInvSize[2] : packoffset(c181.x);
//   float4 View_TranslucencyLightingVolumeDistance[2] : packoffset(c183.x);
//   float4 View_TemporalAAParams : packoffset(c185.x);
//   float4 View_CircleDOFParams : packoffset(c186.x);
//   uint View_ForceDrawAllVelocities : packoffset(c187.x);
//   float View_DepthOfFieldIntensity : packoffset(c187.y);
//   float View_DepthOfFieldFocalDistance : packoffset(c187.z);
//   float View_DepthOfFieldFstop : packoffset(c187.w);
//   float View_LightModifierEnvironmentLight : packoffset(c188.x);
//   float View_LightModifierDirectionalLight : packoffset(c188.y);
//   float View_MotionBlurNormalizedToPixel : packoffset(c188.z);
//   float View_bSubsurfacePostprocessEnabled : packoffset(c188.w);
//   float4 View_GeneralPurposeTweak : packoffset(c189.x);
//   float View_DemosaicVposOffset : packoffset(c190.x);
//   float PrePadding_View_3044 : packoffset(c190.y);
//   float PrePadding_View_3048 : packoffset(c190.z);
//   float PrePadding_View_3052 : packoffset(c190.w);
//   float3 View_IndirectLightingColorScale : packoffset(c191.x);
//   float View_AtmosphericFogSunPower : packoffset(c191.w);
//   float View_AtmosphericFogPower : packoffset(c192.x);
//   float View_AtmosphericFogDensityScale : packoffset(c192.y);
//   float View_AtmosphericFogDensityOffset : packoffset(c192.z);
//   float View_AtmosphericFogGroundOffset : packoffset(c192.w);
//   float View_AtmosphericFogDistanceScale : packoffset(c193.x);
//   float View_AtmosphericFogAltitudeScale : packoffset(c193.y);
//   float View_AtmosphericFogHeightScaleRayleigh : packoffset(c193.z);
//   float View_AtmosphericFogStartDistance : packoffset(c193.w);
//   float View_AtmosphericFogDistanceOffset : packoffset(c194.x);
//   float View_AtmosphericFogSunDiscScale : packoffset(c194.y);
//   float PrePadding_View_3112 : packoffset(c194.z);
//   float PrePadding_View_3116 : packoffset(c194.w);
//   float4 View_AtmosphereLightDirection[2] : packoffset(c195.x);
//   float4 View_AtmosphereLightColor[2] : packoffset(c197.x);
//   float4 View_AtmosphereLightColorGlobalPostTransmittance[2] : packoffset(c199.x);
//   float4 View_AtmosphereLightDiscLuminance[2] : packoffset(c201.x);
//   float4 View_AtmosphereLightDiscCosHalfApexAngle[2] : packoffset(c203.x);
//   float4 View_SkyViewLutSizeAndInvSize : packoffset(c205.x);
//   float3 View_SkyWorldCameraOrigin : packoffset(c206.x);
//   float PrePadding_View_3308 : packoffset(c206.w);
//   float4 View_SkyPlanetCenterAndViewHeight : packoffset(c207.x);
//   row_major float4x4 View_SkyViewLutReferential : packoffset(c208.x);
//   float4 View_SkyAtmosphereSkyLuminanceFactor : packoffset(c212.x);
//   float View_SkyAtmospherePresentInScene : packoffset(c213.x);
//   float View_SkyAtmosphereHeightFogContribution : packoffset(c213.y);
//   float View_SkyAtmosphereBottomRadiusKm : packoffset(c213.z);
//   float View_SkyAtmosphereTopRadiusKm : packoffset(c213.w);
//   float4 View_SkyAtmosphereCameraAerialPerspectiveVolumeSizeAndInvSize : packoffset(c214.x);
//   float View_SkyAtmosphereAerialPerspectiveStartDepthKm : packoffset(c215.x);
//   float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthResolution : packoffset(c215.y);
//   float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthResolutionInv : packoffset(c215.z);
//   float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthSliceLengthKm : packoffset(c215.w);
//   float View_SkyAtmosphereCameraAerialPerspectiveVolumeDepthSliceLengthKmInv : packoffset(c216.x);
//   float View_SkyAtmosphereApplyCameraAerialPerspectiveVolume : packoffset(c216.y);
//   uint View_AtmosphericFogRenderMask : packoffset(c216.z);
//   uint View_AtmosphericFogInscatterAltitudeSampleNum : packoffset(c216.w);
//   float4 View_EnvironmentLightFallbackContext : packoffset(c217.x);
//   float4 View_FogContextDirectionalLightDirection : packoffset(c218.x);
//   float4 View_FogContextDirectionalLightColor : packoffset(c219.x);
//   float View_FogContextMediumIOR : packoffset(c220.x);
//   uint View_NumberOfFogContext : packoffset(c220.y);
//   uint PrePadding_View_3528 : packoffset(c220.z);
//   uint PrePadding_View_3532 : packoffset(c220.w);
//   float4 View_FogContextHeightBasedContextAlbedo[4] : packoffset(c221.x);
//   float4 View_FogContextHeightBasedContextDensity[4] : packoffset(c225.x);
//   float4 View_FogContextTransmitContextAlbedo[4] : packoffset(c229.x);
//   float4 View_FogContextTransmitContextDensity[4] : packoffset(c233.x);
//   float4 View_FogContextRegionContext[4] : packoffset(c237.x);
//   float4 View_FogContextLightContext[4] : packoffset(c241.x);
//   float3 View_NormalCurvatureToRoughnessScaleBias : packoffset(c245.x);
//   float View_RenderingReflectionCaptureMask : packoffset(c245.w);
//   float View_RealTimeReflectionCapture : packoffset(c246.x);
//   float View_RealTimeReflectionCapturePreExposure : packoffset(c246.y);
//   float PrePadding_View_3944 : packoffset(c246.z);
//   float PrePadding_View_3948 : packoffset(c246.w);
//   float4 View_AmbientCubemapTint : packoffset(c247.x);
//   float View_AmbientCubemapIntensity : packoffset(c248.x);
//   float View_WetnessIntensity : packoffset(c248.y);
//   float View_SkyLightApplyPrecomputedBentNormalShadowingFlag : packoffset(c248.z);
//   float View_SkyLightAffectReflectionFlag : packoffset(c248.w);
//   float View_SkyLightAffectGlobalIlluminationFlag : packoffset(c249.x);
//   float PrePadding_View_3988 : packoffset(c249.y);
//   float PrePadding_View_3992 : packoffset(c249.z);
//   float PrePadding_View_3996 : packoffset(c249.w);
//   float4 View_SkyLightColor : packoffset(c250.x);
//   float4 View_MobileSkyIrradianceEnvironmentMap[7] : packoffset(c251.x);
//   float View_MobilePreviewMode : packoffset(c258.x);
//   float View_HMDEyePaddingOffset : packoffset(c258.y);
//   float View_ReflectionCubemapMaxMip : packoffset(c258.z);
//   float View_ShowDecalsMask : packoffset(c258.w);
//   uint View_DistanceFieldAOSpecularOcclusionMode : packoffset(c259.x);
//   float View_IndirectCapsuleSelfShadowingIntensity : packoffset(c259.y);
//   float PrePadding_View_4152 : packoffset(c259.z);
//   float PrePadding_View_4156 : packoffset(c259.w);
//   float3 View_ReflectionEnvironmentRoughnessMixingScaleBiasAndLargestWeight : packoffset(c260.x);
//   int View_StereoPassIndex : packoffset(c260.w);
//   float4 View_GlobalVolumeCenterAndExtent[4] : packoffset(c261.x);
//   float4 View_GlobalVolumeWorldToUVAddAndMul[4] : packoffset(c265.x);
//   float View_GlobalVolumeDimension : packoffset(c269.x);
//   float View_GlobalVolumeTexelSize : packoffset(c269.y);
//   float View_MaxGlobalDistance : packoffset(c269.z);
//   float PrePadding_View_4316 : packoffset(c269.w);
//   int2 View_CursorPosition : packoffset(c270.x);
//   float View_bCheckerboardSubsurfaceProfileRendering : packoffset(c270.z);
//   float PrePadding_View_4332 : packoffset(c270.w);
//   float3 View_PrecomputedLightVolumeGridZParams : packoffset(c271.x);
//   float PrePadding_View_4348 : packoffset(c271.w);
//   float3 View_PrecomputedLightVolumeGridSize : packoffset(c272.x);
//   float PrePadding_View_4364 : packoffset(c272.w);
//   int3 View_PrecomputedLightVolumeGridSizeInt : packoffset(c273.x);
//   int PrePadding_View_4380 : packoffset(c273.w);
//   float3 View_VolumetricFogGridSize : packoffset(c274.x);
//   float PrePadding_View_4396 : packoffset(c274.w);
//   float3 View_VolumetricFogGridSizeReciprocal : packoffset(c275.x);
//   float PrePadding_View_4412 : packoffset(c275.w);
//   float3 View_VolumetricFogGridZParameter : packoffset(c276.x);
//   float PrePadding_View_4428 : packoffset(c276.w);
//   float3 View_VolumetricFogGridZParameterReciprocal : packoffset(c277.x);
//   float PrePadding_View_4444 : packoffset(c277.w);
//   float3 View_VolumetricFogGridCoordinateSolver : packoffset(c278.x);
//   float PrePadding_View_4460 : packoffset(c278.w);
//   float3 View_VolumetricFogGridCoordinateMinimum : packoffset(c279.x);
//   float PrePadding_View_4476 : packoffset(c279.w);
//   float3 View_VolumetricFogGridCoordinateMaximum : packoffset(c280.x);
//   float View_VolumetricFogMaxDistance : packoffset(c280.w);
//   float3 View_VolumetricLightmapWorldToUVScale : packoffset(c281.x);
//   float PrePadding_View_4508 : packoffset(c281.w);
//   float3 View_VolumetricLightmapWorldToUVAdd : packoffset(c282.x);
//   float PrePadding_View_4524 : packoffset(c282.w);
//   float3 View_VolumetricLightmapIndirectionTextureSize : packoffset(c283.x);
//   float View_VolumetricLightmapBrickSize : packoffset(c283.w);
//   float3 View_VolumetricLightmapBrickTexelSize : packoffset(c284.x);
//   float View_StereoIPD : packoffset(c284.w);
//   float View_IndirectLightingCacheShowFlag : packoffset(c285.x);
//   float View_EyeToPixelSpreadAngle : packoffset(c285.y);
//   float PrePadding_View_4568 : packoffset(c285.z);
//   float PrePadding_View_4572 : packoffset(c285.w);
//   row_major float4x4 View_WorldToVirtualTexture : packoffset(c286.x);
//   float4 View_XRPassthroughCameraUVs[2] : packoffset(c290.x);
//   uint View_VirtualTextureFeedbackStride : packoffset(c292.x);
//   uint PrePadding_View_4676 : packoffset(c292.y);
//   uint PrePadding_View_4680 : packoffset(c292.z);
//   uint PrePadding_View_4684 : packoffset(c292.w);
//   float4 View_RuntimeVirtualTextureMipLevel : packoffset(c293.x);
//   float2 View_RuntimeVirtualTexturePackHeight : packoffset(c294.x);
//   float PrePadding_View_4712 : packoffset(c294.z);
//   float PrePadding_View_4716 : packoffset(c294.w);
//   float4 View_RuntimeVirtualTextureDebugParams : packoffset(c295.x);
//   int View_FarShadowStaticMeshLODBias : packoffset(c296.x);
//   float View_MinRoughness : packoffset(c296.y);
//   float PrePadding_View_4744 : packoffset(c296.z);
//   float PrePadding_View_4748 : packoffset(c296.w);
//   float4 View_HairRenderInfo : packoffset(c297.x);
//   uint View_EnableSkyLight : packoffset(c298.x);
//   uint View_HairRenderInfoBits : packoffset(c298.y);
//   uint View_HairComponents : packoffset(c298.z);
//   uint View_DebugContext : packoffset(c298.w);
//   uint View_DebugTweak : packoffset(c299.x);
// };

// SamplerState View_SharedBilinearClampedSampler : register(s0);

// float4 main(
//   noperspective float2 TEXCOORD : TEXCOORD,
//   noperspective float4 TEXCOORD_1 : TEXCOORD1,
//   noperspective float4 SV_Position : SV_Position
// ) : SV_Target {
//   float4 SV_Target;
//   bool _21 = !(DeviceCorrectorContext.z == 0.0f);
//   float4 _30 = View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4((int(SV_Position.x) & 127), (int(SV_Position.y) & 127), (View_StateFrameIndex & 63), 0));
//   float _37 = SV_Position.x - float((uint)(int)(ViewportDestination_ViewportMin.x));
//   float _38 = SV_Position.y - float((uint)(int)(ViewportDestination_ViewportMin.y));
//   float _44 = saturate(_37 * ViewportDestination_ViewportSizeInverse.x);
//   float _45 = saturate(_38 * ViewportDestination_ViewportSizeInverse.y);
//   float _58 = select(_21, saturate(((floor(_37 * 0.5f) * 2.0f) + 1.0f) * ViewportDestination_ViewportSizeInverse.x), _44);
//   float _59 = select(_21, saturate(((floor(_38 * 0.5f) * 2.0f) + 1.0f) * ViewportDestination_ViewportSizeInverse.y), _45);
//   float4 _128 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(min(max((((ViewportColor_ViewportSize.x * _58) + float((uint)(int)(ViewportColor_ViewportMin.x))) * ViewportColor_ExtentInverse.x), ViewportColor_UVViewportBilinearMin.x), ViewportColor_UVViewportBilinearMax.x), min(max((((ViewportColor_ViewportSize.y * _59) + float((uint)(int)(ViewportColor_ViewportMin.y))) * ViewportColor_ExtentInverse.y), ViewportColor_UVViewportBilinearMin.y), ViewportColor_UVViewportBilinearMax.y)), 0.0f);
//   float _140 = (1.0f / max(0.0010000000474974513f, VignetteContext.y)) * TEXCOORD_1.z;
//   float _145 = (_140 * _140) * (1.0f / max(9.999999747378752e-06f, dot(float3(TEXCOORD_1.x, TEXCOORD_1.y, _140), float3(TEXCOORD_1.x, TEXCOORD_1.y, _140))));
//   float _149 = (((_145 * _145) + -1.0f) * VignetteContext.x) + 1.0f;
//   float _150 = _149 * min(_128.x, 64512.0f);
//   float _151 = _149 * min(_128.y, 64512.0f);
//   float _152 = _149 * min(_128.z, 64512.0f);
//   float4 _154 = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(min(max((((ViewportGlare_ViewportSize.x * _58) + float((uint)(int)(ViewportGlare_ViewportMin.x))) * ViewportGlare_ExtentInverse.x), ViewportGlare_UVViewportBilinearMin.x), ViewportGlare_UVViewportBilinearMax.x), min(max((((ViewportGlare_ViewportSize.y * _59) + float((uint)(int)(ViewportGlare_ViewportMin.y))) * ViewportGlare_ExtentInverse.y), ViewportGlare_UVViewportBilinearMin.y), ViewportGlare_UVViewportBilinearMax.y)), 0.0f);
//   float _180 = saturate(DeviceCorrectorContext.x);
//   float _182 = saturate(DeviceCorrectorContext.y);
//   float _187 = exp2(log2(saturate(((((min(_154.x, 65504.0f) - _150) + (GlareContext.y * _150)) * GlareContext.x) + _150) * 0.009999999776482582f)) * 0.1593017578125f);
//   float _203 = exp2(log2(saturate(((((min(_154.y, 65504.0f) - _151) + (GlareContext.y * _151)) * GlareContext.x) + _151) * 0.009999999776482582f)) * 0.1593017578125f);
//   float _219 = exp2(log2(saturate(((((min(_154.z, 65504.0f) - _152) + (GlareContext.y * _152)) * GlareContext.x) + _152) * 0.009999999776482582f)) * 0.1593017578125f);
//   float4 _238 = BT709PQToBT2020PQLUT.SampleLevel(View_SharedBilinearClampedSampler, float3(((saturate(exp2(log2(max(0.0f, (((_187 * 18.8515625f) + 0.8359375f) * (1.0f / ((_187 * 18.6875f) + 1.0f))))) * 78.84375f)) * 0.96875f) + 0.015625f), ((saturate(exp2(log2(max(0.0f, (((_203 * 18.8515625f) + 0.8359375f) * (1.0f / ((_203 * 18.6875f) + 1.0f))))) * 78.84375f)) * 0.96875f) + 0.015625f), ((saturate(exp2(log2(max(0.0f, (((_219 * 18.8515625f) + 0.8359375f) * (1.0f / ((_219 * 18.6875f) + 1.0f))))) * 78.84375f)) * 0.96875f) + 0.015625f)), 0.0f);
//   float _245 = exp2(log2(saturate(_238.x)) * 0.012683313339948654f);
//   float _254 = exp2(log2(max(0.0f, ((_245 + -0.8359375f) * (1.0f / (18.8515625f - (_245 * 18.6875f)))))) * 6.277394771575928f);
//   float _259 = exp2(log2(saturate(_238.y)) * 0.012683313339948654f);
//   float _268 = exp2(log2(max(0.0f, ((_259 + -0.8359375f) * (1.0f / (18.8515625f - (_259 * 18.6875f)))))) * 6.277394771575928f);
//   float _273 = exp2(log2(saturate(_238.z)) * 0.012683313339948654f);
//   float _282 = exp2(log2(max(0.0f, ((_273 + -0.8359375f) * (1.0f / (18.8515625f - (_273 * 18.6875f)))))) * 6.277394771575928f);
//   float _355;
//   float _356;
//   float _357;
//   float _358;
//   float _359;
//   float _360;
//   float _426;
//   float _427;
//   float _428;
//   float _514;
//   float _525;
//   float _536;
//   float _577;
//   float _588;
//   float _599;
//   [branch]
//   if (_180 > 0.0f) {
//     float _287 = 1.0f - (_180 * 0.2928932309150696f);
//     float _300 = exp2(log2(saturate(_254 * 10.0f)) * _287);
//     float _301 = exp2(log2(saturate(_268 * 10.0f)) * _287);
//     float _302 = exp2(log2(saturate(_282 * 10.0f)) * _287);
//     float _310 = exp2(log2(saturate(_300 * 0.09999999403953552f)) * 0.1593017578125f);
//     float _326 = exp2(log2(saturate(_301 * 0.09999999403953552f)) * 0.1593017578125f);
//     float _342 = exp2(log2(saturate(_302 * 0.09999999403953552f)) * 0.1593017578125f);
//     _355 = (_300 * 1000.0f);
//     _356 = (_301 * 1000.0f);
//     _357 = (_302 * 1000.0f);
//     _358 = saturate(exp2(log2(max(0.0f, (((_310 * 18.8515625f) + 0.8359375f) * (1.0f / ((_310 * 18.6875f) + 1.0f))))) * 78.84375f));
//     _359 = saturate(exp2(log2(max(0.0f, (((_326 * 18.8515625f) + 0.8359375f) * (1.0f / ((_326 * 18.6875f) + 1.0f))))) * 78.84375f));
//     _360 = saturate(exp2(log2(max(0.0f, (((_342 * 18.8515625f) + 0.8359375f) * (1.0f / ((_342 * 18.6875f) + 1.0f))))) * 78.84375f));
//   } else {
//     _355 = (_254 * 10000.0f);
//     _356 = (_268 * 10000.0f);
//     _357 = (_282 * 10000.0f);
//     _358 = _238.x;
//     _359 = _238.y;
//     _360 = _238.z;
//   }
//   [branch]
//   if (_182 < 1.0f) {
//     float4 _370 = BT2020PQ1000ToBT2020PQ250LUT.SampleLevel(View_SharedBilinearClampedSampler, float3(((_358 * 0.96875f) + 0.015625f), ((_359 * 0.96875f) + 0.015625f), ((_360 * 0.96875f) + 0.015625f)), 0.0f);
//     float _377 = exp2(log2(saturate(_370.x)) * 0.012683313339948654f);
//     float _387 = exp2(log2(max(0.0f, ((_377 + -0.8359375f) * (1.0f / (18.8515625f - (_377 * 18.6875f)))))) * 6.277394771575928f) * 10000.0f;
//     float _391 = exp2(log2(saturate(_370.y)) * 0.012683313339948654f);
//     float _401 = exp2(log2(max(0.0f, ((_391 + -0.8359375f) * (1.0f / (18.8515625f - (_391 * 18.6875f)))))) * 6.277394771575928f) * 10000.0f;
//     float _405 = exp2(log2(saturate(_370.z)) * 0.012683313339948654f);
//     float _415 = exp2(log2(max(0.0f, ((_405 + -0.8359375f) * (1.0f / (18.8515625f - (_405 * 18.6875f)))))) * 6.277394771575928f) * 10000.0f;
//     _426 = (lerp(_387, _355, _182));
//     _427 = (lerp(_401, _356, _182));
//     _428 = (lerp(_415, _357, _182));
//   } else {
//     _426 = _355;
//     _427 = _356;
//     _428 = _357;
//   }
//   float _438 = max(9.999999747378752e-05f, HDRCompositionContextColor.x);
//   float _439 = max(9.999999747378752e-05f, HDRCompositionContextColor.y);
//   float _440 = max(9.999999747378752e-05f, HDRCompositionContextColor.z);
//   float _444 = (1.0f / dot(float3(_438, _439, _440), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f))) * (dot(float3(_426, _427, _428), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) * 9.999999747378752e-05f);
//   float _449 = exp2(log2(saturate(_444 * _438)) * 0.1593017578125f);
//   float _465 = exp2(log2(saturate(_444 * _439)) * 0.1593017578125f);
//   float _481 = exp2(log2(saturate(_444 * _440)) * 0.1593017578125f);
//   float4 _500 = BT2020PQTosRGBLUT.SampleLevel(View_SharedBilinearClampedSampler, float3(((saturate(exp2(log2(max(0.0f, (((_449 * 18.8515625f) + 0.8359375f) * (1.0f / ((_449 * 18.6875f) + 1.0f))))) * 78.84375f)) * 0.96875f) + 0.015625f), ((saturate(exp2(log2(max(0.0f, (((_465 * 18.8515625f) + 0.8359375f) * (1.0f / ((_465 * 18.6875f) + 1.0f))))) * 78.84375f)) * 0.96875f) + 0.015625f), ((saturate(exp2(log2(max(0.0f, (((_481 * 18.8515625f) + 0.8359375f) * (1.0f / ((_481 * 18.6875f) + 1.0f))))) * 78.84375f)) * 0.96875f) + 0.015625f)), 0.0f);
//   if (_500.x < 0.040449999272823334f) {
//     _514 = (_500.x * 0.07739938050508499f);
//   } else {
//     _514 = exp2(log2((_500.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
//   }
//   if (_500.y < 0.040449999272823334f) {
//     _525 = (_500.y * 0.07739938050508499f);
//   } else {
//     _525 = exp2(log2((_500.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
//   }
//   if (_500.z < 0.040449999272823334f) {
//     _536 = (_500.z * 0.07739938050508499f);
//   } else {
//     _536 = exp2(log2((_500.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
//   }
//   float _539 = (1.0f / max(0.0010000000474974513f, HDRCompositionContext.z)) * TEXCOORD_1.w;
//   float _544 = (_539 * _539) * (1.0f / max(9.999999747378752e-06f, dot(float3(TEXCOORD_1.x, TEXCOORD_1.y, _539), float3(TEXCOORD_1.x, TEXCOORD_1.y, _539))));
//   float _548 = (saturate(_544 * _544) + -1.0f) * HDRCompositionContext.y;
//   float4 _552 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(((min(((ViewportDestination_ViewportSize.x * 0.5625f) * ViewportDestination_ViewportSizeInverse.y), 1.0f) * (_44 + -0.5f)) + 0.5f), ((min(((ViewportDestination_ViewportSize.y * 1.7777777910232544f) * ViewportDestination_ViewportSizeInverse.x), 1.0f) * (_45 + -0.5f)) + 0.5f)), 0.0f);
//   float _559 = -0.0f - ((HDRCompositionContext.x * _548) * _552.w);
//   float _563 = (_514 * _559) + _552.x;
//   float _564 = (_525 * _559) + _552.y;
//   float _565 = (_536 * _559) + _552.z;
//   float _566 = _552.w * ((_548 * HDRCompositionContext.x) + 1.0f);
//   if (_563 < 0.0031308000907301903f) {
//     _577 = (_563 * 12.920000076293945f);
//   } else {
//     _577 = (((pow(_563, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
//   }
//   if (_564 < 0.0031308000907301903f) {
//     _588 = (_564 * 12.920000076293945f);
//   } else {
//     _588 = (((pow(_564, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
//   }
//   if (_565 < 0.0031308000907301903f) {
//     _599 = (_565 * 12.920000076293945f);
//   } else {
//     _599 = (((pow(_565, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
//   }
//   float _600 = _566 * _566;
//   float _607 = 1.0f / ((_426 * 0.004000000189989805f) + 1.0f);
//   float _608 = 1.0f / ((_427 * 0.004000000189989805f) + 1.0f);
//   float _609 = 1.0f / ((_428 * 0.004000000189989805f) + 1.0f);
//   float _631 = (pow(_577, 2.200000047683716f));
//   float _632 = (pow(_588, 2.200000047683716f));
//   float _633 = (pow(_599, 2.200000047683716f));
//   float _647 = exp2(log2(saturate(((dot(float3(0.6274039149284363f, 0.3292829990386963f, 0.043313100934028625f), float3(_631, _632, _633)) * 250.0f) + ((_566 * _426) * (lerp(_607, 1.0f, _600)))) * 9.999999747378752e-05f)) * 0.1593017578125f);
//   float _658 = saturate(exp2(log2(max(0.0f, (((_647 * 18.8515625f) + 0.8359375f) * (1.0f / ((_647 * 18.6875f) + 1.0f))))) * 78.84375f));
//   float _663 = exp2(log2(saturate(((dot(float3(0.06909730285406113f, 0.9195405840873718f, 0.011362300254404545f), float3(_631, _632, _633)) * 250.0f) + ((_566 * _427) * (lerp(_608, 1.0f, _600)))) * 9.999999747378752e-05f)) * 0.1593017578125f);
//   float _674 = saturate(exp2(log2(max(0.0f, (((_663 * 18.8515625f) + 0.8359375f) * (1.0f / ((_663 * 18.6875f) + 1.0f))))) * 78.84375f));
//   float _679 = exp2(log2(saturate(((dot(float3(0.01639140024781227f, 0.08801329880952835f, 0.8955953121185303f), float3(_631, _632, _633)) * 250.0f) + ((_566 * _428) * (lerp(_609, 1.0f, _600)))) * 9.999999747378752e-05f)) * 0.1593017578125f);
//   float _690 = saturate(exp2(log2(max(0.0f, (((_679 * 18.8515625f) + 0.8359375f) * (1.0f / ((_679 * 18.6875f) + 1.0f))))) * 78.84375f));
//   float _692 = (_30.x * 2.0f) + -1.0f;
//   float _709 = (float((int)(((int)(uint)((bool)(_692 > 0.0f))) - ((int)(uint)((bool)(_692 < 0.0f))))) * 0.0009775171056389809f) * (1.0f - sqrt(1.0f - abs(_692)));
//   SV_Target.x = saturate(select(((abs((_658 * 2.0f) + -1.0f) + -0.9980449676513672f) < 0.0f), (_709 + _658), _658));
//   SV_Target.y = saturate(select(((abs((_674 * 2.0f) + -1.0f) + -0.9980449676513672f) < 0.0f), (_709 + _674), _674));
//   SV_Target.z = saturate(select(((abs((_690 * 2.0f) + -1.0f) + -0.9980449676513672f) < 0.0f), (_709 + _690), _690));
//   SV_Target.w = 0.0f;
//   return SV_Target;
// }
