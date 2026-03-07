#include "../common.hlsli"

Texture2D<float> ReadonlyDepth : register(t0);

Texture3D<float4> AerialPerspectiveTexture : register(t1);

Texture2D<float3> AtmosphereTransmittanceCopiedTexture : register(t2);

Texture3D<float4> VolumetricFogTexture : register(t3);

Texture2D<float4> VolumetricParticleTexture : register(t4);

cbuffer SceneInfo : register(b0) {
  row_major float4x4 viewProjMat : packoffset(c000.x);
  row_major float3x4 transposeViewMat : packoffset(c004.x);
  row_major float3x4 transposeViewInvMat : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  row_major float4x4 viewProjInvMat : packoffset(c014.x);
  row_major float4x4 prevViewProjMat : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[8] : packoffset(c025.x);
  float4 clipplane : packoffset(c033.x);
  float2 vrsVelocityThreshold : packoffset(c034.x);
  uint GPUVisibleMask : packoffset(c034.z);
  uint resolutionRatioPacked : packoffset(c034.w);
  float3 worldOffset : packoffset(c035.x);
  uint sceneInfoMisc : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  float tessellationParam : packoffset(c038.z);
  uint sceneInfoAdditionalFlags : packoffset(c038.w);
};

cbuffer RangeCompressInfo : register(b1) {
  float rangeCompress : packoffset(c000.x);
  float rangeDecompress : packoffset(c000.y);
  float prevRangeCompress : packoffset(c000.z);
  float prevRangeDecompress : packoffset(c000.w);
  float rangeCompressForResource : packoffset(c001.x);
  float rangeDecompressForResource : packoffset(c001.y);
  float rangeCompressForCommon : packoffset(c001.z);
  float rangeDecompressForCommon : packoffset(c001.w);
};

cbuffer VolumetricParams : register(b2) {
  float3 SunColor : packoffset(c000.x);
  uint NumIntegrationSteps : packoffset(c000.w);
  float MieScatteringCoefficient : packoffset(c001.x);
  float MieExtinctionCoefficient : packoffset(c001.y);
  float MieMeanCosine : packoffset(c001.z);
  float MieScaleHeight : packoffset(c001.w);
  float3 RayleighScatteringCoefficient : packoffset(c002.x);
  float RayleighScaleHeight : packoffset(c002.w);
  float3 OzoneAbsorptionCoefficient : packoffset(c003.x);
  float PlanetRadius : packoffset(c003.w);
  float AerialPerspectiveStartDepth : packoffset(c004.x);
  float AtmosphereBlendTextureAlphaScale : packoffset(c004.y);
  float PrecomputationLerpWeight : packoffset(c004.z);
  float OuterAtmosphereRadius : packoffset(c004.w);
  float3 SunDirection : packoffset(c005.x);
  float CosSunAngularRadius : packoffset(c005.w);
  float4 AtmosphereFrustumRays[4] : packoffset(c006.x);
  uint3 AerialPerspectiveTextureSize : packoffset(c010.x);
  float DistanceScale : packoffset(c010.w);
  float3 InvAerialPerspectiveTextureSize : packoffset(c011.x);
  float AtmosphereLerpWeight : packoffset(c011.w);
  float4 AtmosphereDepthEncodingParams : packoffset(c012.x);
  float4 AtmosphereDepthDecodingParams : packoffset(c013.x);
  float3 AtmosphereBlendTextureColor : packoffset(c014.x);
  float CosViewZenithAngleOffset : packoffset(c014.w);
  float3 ZenithDirection : packoffset(c015.x);
  float HorizonAngle : packoffset(c015.w);
  float Height : packoffset(c016.x);
  float TexcoordForHeight : packoffset(c016.y);
  float CosSunZenithAngle : packoffset(c016.z);
  float TexcoordForCosSunZenithAngle : packoffset(c016.w);
  float3 CameraPosition : packoffset(c017.x);
  uint AtmosphereFlags : packoffset(c017.w);
  float3 AtmospherePad : packoffset(c018.x);
  float AerialPerspectiveIntensity : packoffset(c018.w);
  uint2 CloudscapePad : packoffset(c019.x);
  float CloudscapeShadowBoostMultiplier : packoffset(c019.z);
  uint CloudscapeShadowMapIDPlus1 : packoffset(c019.w);
  row_major float4x4 CloudscapeShadowVPMatrix : packoffset(c020.x);
  float4 FrustumCornerRays[4] : packoffset(c024.x);
  float4 DepthEncodingParams : packoffset(c028.x);
  float4 DepthDecodingParams : packoffset(c029.x);
  uint3 FrustumVolumeTextureSize : packoffset(c030.x);
  uint FrustumVolumeFlags : packoffset(c030.w);
  float3 InvFrustumVolumeTextureSize : packoffset(c031.x);
  float VFogCullingDistance : packoffset(c031.w);
  float2 VFogSampleOffset : packoffset(c032.x);
  float2 FrustumVolumePadding2 : packoffset(c032.z);
  uint FogParamsFlags : packoffset(c033.x);
  uint FogParamsHeightFogAlbedo : packoffset(c033.y);
  float FogParamsHeightFogDensity : packoffset(c033.z);
  float FogParamsHeightFogEccentricity : packoffset(c033.w);
  uint FogParamsHeightFogEmissiveColor : packoffset(c034.x);
  float FogParamsHeightFogEmissiveIntensity : packoffset(c034.y);
  float FogParamsHeightFogAttenuationByHeight : packoffset(c034.z);
  float FogParamsHeightFogReferenceAltitude : packoffset(c034.w);
  float2 FogParamsHeightFogPadding : packoffset(c035.x);
  float FogParamsHeightFogCutoffDistance : packoffset(c035.z);
  float FogParamsHeightFogTransitionFactor : packoffset(c035.w);
  float4 FogParamsHeightFogIntegratedHermiteCoefs : packoffset(c036.x);
  float4 FogParamsHeightFogIntegratedHermiteCoefsA : packoffset(c037.x);
  float3 FogParamsHeightFogIntegratedHermiteCoefsB : packoffset(c038.x);
  float FogParamsHeightFogIntegratedHermiteCoefsD : packoffset(c038.w);
  float2 FogParamsHeightFogIntegratedHermiteCoefsC : packoffset(c039.x);
  float2 FogParamsHeightFogHermiteCurveRange : packoffset(c039.z);
  float2 FogParamsHeightFogHermiteCurveMadd : packoffset(c040.x);
  float2 FogParamsHeightFogDensityOfCurveStartEnd : packoffset(c040.z);
  float4 FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[3] : packoffset(c041.x);
  float3 FogParamsHeightFogCommonCoefsForTaylor : packoffset(c044.x);
  float FogParamsPadding : packoffset(c044.w);
};

cbuffer LightInfo : register(b3) {
  uint PunctualLightCount : packoffset(c000.x);
  uint AreaLightCount : packoffset(c000.y);
  uint PunctualLightFowardCount : packoffset(c000.z);
  uint AreaLightFowardCount : packoffset(c000.w);
  float2 LightCullingScreenSize : packoffset(c001.x);
  float2 InverseLightCullingScreenSize : packoffset(c001.z);
  float LightCullingOffsetScale : packoffset(c002.x);
  uint RT_PunctualLightCount : packoffset(c002.y);
  uint RT_AreaLightCount : packoffset(c002.z);
  uint CubemapArrayCount : packoffset(c002.w);
  uint CapsuleLightCount : packoffset(c003.x);
  uint RT_CapsuleLightCount : packoffset(c003.y);
  uint CapsuleLight_Unused0 : packoffset(c003.z);
  uint DisableContactShadowMask : packoffset(c003.w);
  float2 BaseShadowMapRes : packoffset(c004.x);
  float2 InverseBaseShadowMapRes : packoffset(c004.z);
  float3 DL_Direction : packoffset(c005.x);
  uint DL_Enable : packoffset(c005.w);
  float3 DL_Color : packoffset(c006.x);
  float DL_SpecularControl : packoffset(c006.w);
  float3 DL_VolumetricScatteringColor : packoffset(c007.x);
  float DL_PCSS_KERNEL : packoffset(c007.w);
  row_major float4x4 DL_TextureProjection : packoffset(c008.x);
  uint DL_TextureBindlessIndex : packoffset(c012.x);
  float DL_ReceiverSlopeBiasScale : packoffset(c012.y);
  float DL_ContactShadow : packoffset(c012.z);
  uint DL_CalcTranslucency : packoffset(c012.w);
  uint DL_ShadowCasterCulling : packoffset(c013.x);
  uint DL_TextureProjectionOnly : packoffset(c013.y);
  float DL_Variance : packoffset(c013.z);
  float DL_Bias : packoffset(c013.w);
  float DL_NormalClipAngle : packoffset(c014.x);
  uint DL_SSTScreenShadowEnable : packoffset(c014.y);
  float DL_SSTScreenShadowScale : packoffset(c014.z);
  float DL_SSTBias : packoffset(c014.w);
  row_major float4x4 DL_SSTMatrix : packoffset(c015.x);
  row_major float4x4 DL_ViewProjection : packoffset(c019.x);
  uint4 DL_ArrayIndex : packoffset(c023.x);
  uint4 DL_TranslucentArrayIndex : packoffset(c024.x);
  uint4 DL_OcclusionCullingIndex : packoffset(c025.x);
  float4 DL_ZToLinear : packoffset(c026.x);
  uint2 DL_Option : packoffset(c027.x);
  uint2 DL_IntensityScale : packoffset(c027.z);
  float3 Cascade_Translate1 : packoffset(c028.x);
  float Cascade_Bias1 : packoffset(c028.w);
  float3 Cascade_Translate2 : packoffset(c029.x);
  float Cascade_Bias2 : packoffset(c029.w);
  float3 Cascade_Translate3 : packoffset(c030.x);
  float Cascade_Bias3 : packoffset(c030.w);
  float2 Cascade_Scale1 : packoffset(c031.x);
  float2 Cascade_Scale2 : packoffset(c031.z);
  float2 Cascade_Scale3 : packoffset(c032.x);
  float Cascade_FadeBorder : packoffset(c032.z);
  uint Cascade_Flag : packoffset(c032.w);
  float4 Cascade_Distance : packoffset(c033.x);
  float Cascade_ExtensionRange : packoffset(c034.x);
  float DL_TextureProjectionFadeDistSquared : packoffset(c034.y);
  float DL_TextureProjectionFadeRangeSquared : packoffset(c034.z);
  float DL_TextureProjectionFadeMaxRate : packoffset(c034.w);
  float4 Cascade_ShadowMapResX : packoffset(c035.x);
  float4 Cascade_ShadowMapResY : packoffset(c036.x);
  float4 Cascade_InverseShadowMapResX : packoffset(c037.x);
  float4 Cascade_InverseShadowMapResY : packoffset(c038.x);
  float3 Atmopshere_Reserved : packoffset(c039.x);
  uint Atmosphere_Flags : packoffset(c039.w);
  float3 SDFShadowTranslate : packoffset(c040.x);
  float SDFShadowNearFarRatio : packoffset(c040.w);
  float SDFShadowStartDistance : packoffset(c041.x);
  float SDFShadowFadeDistance : packoffset(c041.y);
  float SDFShadowEndDistance : packoffset(c041.z);
  uint SDFShadowFlags : packoffset(c041.w);
  uint lightProbeOffset : packoffset(c042.x);
  uint sparseLightProbeAreaNum : packoffset(c042.y);
  uint tetNumMinus1 : packoffset(c042.z);
  uint sparseTetNumMinus1 : packoffset(c042.w);
  float smoothStepRateMinus : packoffset(c043.x);
  float smoothStepRateRcp : packoffset(c043.y);
  float worldPositionOffsetBias : packoffset(c043.z);
  uint depthBlockerSize : packoffset(c043.w);
  float3 AOTint : packoffset(c044.x);
  uint AO_Unused : packoffset(c044.w);
  float3 LightProbe_WorldOffset : packoffset(c045.x);
  float ReflectionProbeBoost : packoffset(c045.w);
  float4 ShadowSamplePoints[8] : packoffset(c046.x);
  float softShadowBackProjectionRate : packoffset(c054.x);
  uint ShadowMissPositionSize : packoffset(c054.y);
  float shadowReserved1 : packoffset(c054.z);
  float shadowReserved2 : packoffset(c054.w);
  uint DPGIMaterial : packoffset(c055.x);
  uint3 Padding : packoffset(c055.y);
};

cbuffer VolumetricParticleInjection : register(b4) {
  float3 vpiContribution : packoffset(c000.x);
  float vpiTransmittance : packoffset(c000.w);
  uint vpiEnable : packoffset(c001.x);
  float vpiAsymmetryParameter : packoffset(c001.y);
  float vpiCompositionRate : packoffset(c001.z);
  uint vpiReserved : packoffset(c001.w);
};

cbuffer FogParam : register(b5) {
  float3 fogInscatteringColor : packoffset(c000.x);
  float fogDensity : packoffset(c000.w);
  float fogHeightFalloff : packoffset(c001.x);
  float fogMaxOpacity : packoffset(c001.y);
  float fogStartDistance : packoffset(c001.z);
  float fogHeightStartDistance : packoffset(c001.w);
  float3 fogBlendInscatteringColor : packoffset(c002.x);
  float fogBlendEndDistance : packoffset(c002.w);
  float fogBlendInvRange : packoffset(c003.x);
  float fogSkyMaxOpacity : packoffset(c003.y);
  float fogSkyHeightFalloff : packoffset(c003.z);
  float fogSkyHeightStartDistance : packoffset(c003.w);
  float3 FMTInscatteringColor : packoffset(c004.x);
  float FMTDensity : packoffset(c004.w);
  float FMTHeightFalloff : packoffset(c005.x);
  float FMTMaxOpacity : packoffset(c005.y);
  float FMTStartDistance : packoffset(c005.z);
  float FMTHeightStartDistance : packoffset(c005.w);
  float3 maskPlanePos1 : packoffset(c006.x);
  float maskPlaneBlendRate : packoffset(c006.w);
  float3 maskPlanePos2 : packoffset(c007.x);
  float maskDistanceFalloff : packoffset(c007.w);
  float FMTMaxDistance : packoffset(c008.x);
  float FSSunMaskDetectSize : packoffset(c008.y);
  float FSBlendRate : packoffset(c008.z);
  float FSRayleigh : packoffset(c008.w);
  float3 FSSunScreenPos : packoffset(c009.x);
  float FSMie : packoffset(c009.w);
  float3 FSBetaR : packoffset(c010.x);
  float FSAsymmetryFactor : packoffset(c010.w);
  float3 FSBetaM : packoffset(c011.x);
  float FSAspectRatio : packoffset(c011.w);
  float2 FogReserved : packoffset(c012.x);
  float FSFovArFactor : packoffset(c012.z);
  float FSRcpSunMaskDistance : packoffset(c012.w);
};

SamplerState BilinearClamp : register(s5, space32);

float3 ApproxR11G11B10Ulp(float3 encodedColor) {
  // R/G have ~6 mantissa bits, B has ~5 in R11G11B10_FLOAT-like quantization behavior.
  float3 mantissaStep = float3(1.f / 64.f, 1.f / 64.f, 1.f / 32.f);
  float3 minStep = float3(9.5367431640625e-07f, 9.5367431640625e-07f, 1.9073486328125e-06f);
  return max(encodedColor * mantissaStep, minStep);
}

float3 ApplyDithering(float3 encodedFog, float2 screenPos) {
  if (FOG_DITHERING == 0.f) return encodedFog;

  float jitterSeed = dot(projectionSpaceJitterOffset, float2(4096.f, 2048.f));
  float seed = CUSTOM_FOG_RANDOM + jitterSeed;

  float3 noise = float3(
                     renodx::random::Generate(screenPos + float2(seed + 1.f, seed + 37.f)),
                     renodx::random::Generate(screenPos + float2(seed + 73.f, seed + 13.f)),
                     renodx::random::Generate(screenPos + float2(seed + 151.f, seed + 97.f)))
                 - 0.5f;

  float lum = max(0, renodx::color::y::from::BT709(encodedFog));
  float darkMask = 1.f - smoothstep(0.03f, 0.5f, lum);
  float3 ulp = ApproxR11G11B10Ulp(encodedFog);
  const float ditherStrength = 150.f * FOG_DITHERING;
  return max(0.f, encodedFog + (noise * ulp * (ditherStrength * darkMask)));
}
