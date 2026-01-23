#include "./shared.h"

Texture2D<float> ReadonlyDepth : register(t0);

Texture3D<float4> AerialPerspectiveTexture : register(t1);

Texture2D<float3> AtmosphereTransmittanceCopiedTexture : register(t2);

Texture3D<float4> VolumetricFogTexture : register(t3);

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
  float SceneInfo_Reserve0 : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  float2 SceneInfo_Reserve2 : packoffset(c038.z);
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
  float2 ShadowMapRes : packoffset(c004.x);
  float2 InverseShadowMapRes : packoffset(c004.z);
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
  float DL_Unused : packoffset(c012.w);
  uint DL_CalcTranslucency : packoffset(c013.x);
  uint DL_ShadowCasterCulling : packoffset(c013.y);
  uint DL_TextureProjectionOnly : packoffset(c013.z);
  float DL_Variance : packoffset(c013.w);
  float DL_unused : packoffset(c014.x);
  uint DL_SSTScreenShadowEnable : packoffset(c014.y);
  float DL_SSTScreenShadowScale : packoffset(c014.z);
  float DL_SSTBias : packoffset(c014.w);
  row_major float4x4 DL_SSTMatrix : packoffset(c015.x);
  row_major float4x4 DL_ViewProjection : packoffset(c019.x);
  uint DL_ArrayIndex : packoffset(c023.x);
  uint DL_TranslucentArrayIndex : packoffset(c023.y);
  float DL_Bias : packoffset(c023.z);
  float DL_NormalClipAngle : packoffset(c023.w);
  float4 DL_ZToLinear : packoffset(c024.x);
  uint2 DL_Option : packoffset(c025.x);
  uint2 DL_IntensityScale : packoffset(c025.z);
  float3 Cascade_Translate1 : packoffset(c026.x);
  float Cascade_Bias1 : packoffset(c026.w);
  float3 Cascade_Translate2 : packoffset(c027.x);
  float Cascade_Bias2 : packoffset(c027.w);
  float3 Cascade_Translate3 : packoffset(c028.x);
  float Cascade_Bias3 : packoffset(c028.w);
  float2 Cascade_Scale1 : packoffset(c029.x);
  float2 Cascade_Scale2 : packoffset(c029.z);
  float2 Cascade_Scale3 : packoffset(c030.x);
  float Cascade_FadeBorder : packoffset(c030.z);
  uint Cascade_Flag : packoffset(c030.w);
  float4 Cascade_Distance : packoffset(c031.x);
  float Cascade_ExtensionRange : packoffset(c032.x);
  float DL_TextureProjectionFadeDistSquared : packoffset(c032.y);
  float DL_TextureProjectionFadeRangeSquared : packoffset(c032.z);
  float DL_TextureProjectionFadeMaxRate : packoffset(c032.w);
  float3 Atmopshere_Reserved : packoffset(c033.x);
  uint Atmosphere_Flags : packoffset(c033.w);
  float3 SDFShadowTranslate : packoffset(c034.x);
  float SDFShadowNearFarRatio : packoffset(c034.w);
  float SDFShadowStartDistance : packoffset(c035.x);
  float SDFShadowFadeDistance : packoffset(c035.y);
  float SDFShadowEndDistance : packoffset(c035.z);
  uint SDFShadowFlags : packoffset(c035.w);
  uint lightProbeOffset : packoffset(c036.x);
  uint sparseLightProbeAreaNum : packoffset(c036.y);
  uint tetNumMinus1 : packoffset(c036.z);
  uint sparseTetNumMinus1 : packoffset(c036.w);
  float smoothStepRateMinus : packoffset(c037.x);
  float smoothStepRateRcp : packoffset(c037.y);
  float worldPositionOffsetBias : packoffset(c037.z);
  uint depthBlockerSize : packoffset(c037.w);
  float3 AOTint : packoffset(c038.x);
  uint AO_Unused : packoffset(c038.w);
  float3 LightProbe_WorldOffset : packoffset(c039.x);
  float ReflectionProbeBoost : packoffset(c039.w);
  float4 ShadowSamplePoints[8] : packoffset(c040.x);
  uint DPGIMaterial : packoffset(c048.x);
  uint3 Padding : packoffset(c048.y);
};

cbuffer FogParam : register(b4) {
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

struct fog_values {
  float3 fogInscatteringColor;
  float fogDensity;
  float fogHeightFalloff;
  float fogMaxOpacity;
  float fogStartDistance;
  float fogHeightStartDistance;
  float3 fogBlendInscatteringColor;
  float fogBlendEndDistance;
  float fogBlendInvRange;
  float fogSkyMaxOpacity;
  float fogSkyHeightFalloff;
  float fogSkyHeightStartDistance;
};

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;

  fog_values fog;
  fog.fogInscatteringColor = fogInscatteringColor;
  fog.fogDensity = fogDensity;
  fog.fogHeightFalloff = fogHeightFalloff;
  fog.fogMaxOpacity = fogMaxOpacity;
  fog.fogStartDistance = fogStartDistance;
  fog.fogHeightStartDistance = fogHeightStartDistance;
  fog.fogBlendInscatteringColor = fogBlendInscatteringColor;
  fog.fogBlendEndDistance = fogBlendEndDistance;
  fog.fogBlendInvRange = fogBlendInvRange;
  fog.fogSkyMaxOpacity = fogSkyMaxOpacity;
  fog.fogSkyHeightFalloff = fogSkyHeightFalloff;
  fog.fogSkyHeightStartDistance = fogSkyHeightStartDistance;

  // fog.fogDensity *= 20.f;
  //  fog.fogMaxOpacity *= 10.f;
  // fog.fogMaxOpacity = 0.f;
  //fog.fogStartDistance *= 0.1f;

  uint _18 = uint(SV_Position.x);
  uint _19 = uint(SV_Position.y);
  float _21 = ReadonlyDepth.Load(int3(_18, _19, 0));
  float _52 = ((float((uint)_18) * 2.0f) * screenInverseSize.x) + -1.0f;
  float _53 = 1.0f - ((float((uint)_19) * 2.0f) * screenInverseSize.y);
  float _69 = mad(_21.x, (viewProjInvMat[2].w), mad(_53, (viewProjInvMat[1].w), (_52 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w);
  float _70 = (mad(_21.x, (viewProjInvMat[2].x), mad(_53, (viewProjInvMat[1].x), (_52 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x)) / _69;
  float _71 = (mad(_21.x, (viewProjInvMat[2].y), mad(_53, (viewProjInvMat[1].y), (_52 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y)) / _69;
  float _72 = (mad(_21.x, (viewProjInvMat[2].z), mad(_53, (viewProjInvMat[1].z), (_52 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z)) / _69;
  float _75 = ReadonlyDepth.Load(int3(int(SV_Position.x), int(SV_Position.y), 0));
  float _278;
  float _369;
  float _407;
  float _413;
  float _507;
  float _508;
  float _509;
  float _548;
  float _549;
  float _550;
  float _551;
  float _594;
  float _608;
  float _609;
  float _610;
  float _611;
  float _712;
  float _718;
  float _719;
  float _745;
  float _746;
  float _747;
  float _748;
  float _757;
  float _758;
  float _759;
  float _760;
  if (!((FrustumVolumeFlags & 1) == 0)) {
    float _109 = mad(_72, (viewProjMat[2].w), mad(_71, (viewProjMat[1].w), ((viewProjMat[0].w) * _70))) + (viewProjMat[3].w);
    float _122 = _70 - (transposeViewInvMat[0].w);
    float _123 = _71 - (transposeViewInvMat[1].w);
    float _124 = _72 - (transposeViewInvMat[2].w);
    float _134 = sqrt(((_123 * _123) + (_122 * _122)) + (_124 * _124));
    float4 _147 = VolumetricFogTexture.SampleLevel(BilinearClamp, float3((((((mad(_72, (viewProjMat[2].x), mad(_71, (viewProjMat[1].x), ((viewProjMat[0].x) * _70))) + (viewProjMat[3].x)) / _109) * 0.5f) + 0.5f) + VFogSampleOffset.x), ((0.5f - (((mad(_72, (viewProjMat[2].y), mad(_71, (viewProjMat[1].y), ((viewProjMat[0].y) * _70))) + (viewProjMat[3].y)) / _109) * 0.5f)) + VFogSampleOffset.y), ((log2(max((_134 - DepthEncodingParams.y), 0.0f)) * DepthEncodingParams.z) + DepthEncodingParams.x)), 0.0f);
    if (!((FogParamsFlags & 1) == 0)) {
      float _162 = (1.0f - FogParamsHeightFogTransitionFactor) * VFogCullingDistance;
      float _163 = _122 / _134;
      float _164 = _123 / _134;
      float _165 = _124 / _134;
      float _167 = max(0.0010000000474974513f, min(_134, _162));
      float _168 = _167 * _163;
      float _169 = _167 * _164;
      float _170 = _167 * _165;
      float _171 = _168 + (transposeViewInvMat[0].w);
      float _172 = _169 + (transposeViewInvMat[1].w);
      float _173 = _170 + (transposeViewInvMat[2].w);
      float _185 = mad(_173, (viewProjMat[2].w), mad(_172, (viewProjMat[1].w), (_171 * (viewProjMat[0].w)))) + (viewProjMat[3].w);
      float4 _205 = VolumetricFogTexture.SampleLevel(BilinearClamp, float3((((((mad(_173, (viewProjMat[2].x), mad(_172, (viewProjMat[1].x), (_171 * (viewProjMat[0].x)))) + (viewProjMat[3].x)) / _185) * 0.5f) + 0.5f) + VFogSampleOffset.x), ((0.5f - (((mad(_173, (viewProjMat[2].y), mad(_172, (viewProjMat[1].y), (_171 * (viewProjMat[0].y)))) + (viewProjMat[3].y)) / _185) * 0.5f)) + VFogSampleOffset.y), ((log2(max((sqrt(((_169 * _169) + (_168 * _168)) + (_170 * _170)) - DepthEncodingParams.y), 0.0f)) * DepthEncodingParams.z) + DepthEncodingParams.x)), 0.0f);
      float _212 = min(_134, FogParamsHeightFogCutoffDistance) - _162;
      if (_212 > 0.0f) {
        float _245 = min(_212, FogParamsHeightFogHermiteCurveRange.x);
        float _247 = min(_212, FogParamsHeightFogHermiteCurveRange.y);
        float _253 = (FogParamsHeightFogHermiteCurveMadd.x * _245) + FogParamsHeightFogHermiteCurveMadd.y;
        float _254 = (FogParamsHeightFogHermiteCurveMadd.x * _247) + FogParamsHeightFogHermiteCurveMadd.y;
        float _255 = _253 * _253;
        float _256 = _255 * _253;
        float _257 = _254 * _254;
        float _258 = _257 * _254;
        do {
          if (!(FogParamsHeightFogAttenuationByHeight == 0.0f)) {
            float _262 = FogParamsHeightFogAttenuationByHeight * _164;
            float _263 = 1.0f / _262;
            do {
              if (FogParamsHeightFogDensityOfCurveStartEnd.x > 0.0f) {
                float _267 = _172 - FogParamsHeightFogReferenceAltitude;
                float _269 = FogParamsHeightFogAttenuationByHeight * -1.4426950216293335f;
                _278 = ((FogParamsHeightFogDensityOfCurveStartEnd.x * _263) * (exp2(_269 * (_267 + (_245 * _164))) - exp2(_269 * _267)));
              } else {
                _278 = 0.0f;
              }
              float _281 = _172 - FogParamsHeightFogReferenceAltitude;
              float _282 = FogParamsHeightFogAttenuationByHeight * -1.4426950216293335f;
              float _286 = exp2(_282 * (_281 + (_245 * _164)));
              do {
                if (abs(_262) < 0.000750000006519258f) {
                  float _289 = (_247 - _245) * _262;
                  float _292 = 1.0f - _289;
                  float _299 = FogParamsHeightFogCommonCoefsForTaylor.y * _262;
                  float _300 = (_262 * _262) * FogParamsHeightFogCommonCoefsForTaylor.z;
                  float _306 = _258 * _254;
                  float _313 = _258 * _257;
                  float _326 = _256 * _253;
                  float _328 = _256 * _255;
                  _369 = (-0.0f - (_286 * (dot(float3((FogParamsHeightFogCommonCoefsForTaylor.x * (((_289 * _289) * 0.5f) + _292)), (_299 * _292), _300), float3(dot(float4(_306, _258, _257, _254), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].w))), dot(float4(_313, (_257 * _257), _258, _257), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].w))), dot(float4((_258 * _258), _313, _306, _258), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].w))))) - dot(float3(FogParamsHeightFogCommonCoefsForTaylor.x, _299, _300), float3(dot(float4(_326, _256, _255, _253), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].w))), dot(float4(_328, (_255 * _255), _256, _255), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].w))), dot(float4((_256 * _256), _328, _326, _256), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].w))))))));
                } else {
                  float _338 = _263 * _263;
                  float _339 = _338 * _263;
                  float _340 = _339 * _263;
                  _369 = ((dot(float4(_263, _338, _339, _340), float4(dot(float4(_258, _257, _254, 1.0f), float4(FogParamsHeightFogIntegratedHermiteCoefsA.x, FogParamsHeightFogIntegratedHermiteCoefsA.y, FogParamsHeightFogIntegratedHermiteCoefsA.z, FogParamsHeightFogIntegratedHermiteCoefsA.w)), dot(float3(_257, _254, 1.0f), float3(FogParamsHeightFogIntegratedHermiteCoefsB.x, FogParamsHeightFogIntegratedHermiteCoefsB.y, FogParamsHeightFogIntegratedHermiteCoefsB.z)), dot(float2(_254, 1.0f), float2(FogParamsHeightFogIntegratedHermiteCoefsC.x, FogParamsHeightFogIntegratedHermiteCoefsC.y)), FogParamsHeightFogIntegratedHermiteCoefsD)) * exp2(_282 * (_281 + (_247 * _164)))) - (dot(float4(_263, _338, _339, _340), float4(dot(float4(_256, _255, _253, 1.0f), float4(FogParamsHeightFogIntegratedHermiteCoefsA.x, FogParamsHeightFogIntegratedHermiteCoefsA.y, FogParamsHeightFogIntegratedHermiteCoefsA.z, FogParamsHeightFogIntegratedHermiteCoefsA.w)), dot(float3(_255, _253, 1.0f), float3(FogParamsHeightFogIntegratedHermiteCoefsB.x, FogParamsHeightFogIntegratedHermiteCoefsB.y, FogParamsHeightFogIntegratedHermiteCoefsB.z)), dot(float2(_253, 1.0f), float2(FogParamsHeightFogIntegratedHermiteCoefsC.x, FogParamsHeightFogIntegratedHermiteCoefsC.y)), FogParamsHeightFogIntegratedHermiteCoefsD)) * _286));
                }
                float _370 = _369 + _278;
                if (FogParamsHeightFogDensityOfCurveStartEnd.y > 0.0f) {
                  float _377 = FogParamsHeightFogAttenuationByHeight * -1.4426950216293335f;
                  _407 = (((FogParamsHeightFogDensityOfCurveStartEnd.y * _263) * (exp2(_377 * (((_212 * _164) + _172) - FogParamsHeightFogReferenceAltitude)) - exp2(_377 * ((_172 - FogParamsHeightFogReferenceAltitude) + (_247 * _164))))) + _370);
                } else {
                  _407 = _370;
                }
              } while (false);
            } while (false);
          } else {
            _407 = (((dot(float4(FogParamsHeightFogIntegratedHermiteCoefs.x, FogParamsHeightFogIntegratedHermiteCoefs.y, FogParamsHeightFogIntegratedHermiteCoefs.z, FogParamsHeightFogIntegratedHermiteCoefs.w), float4(_256, _255, _253, 1.0f)) * _253) - ((FogParamsHeightFogDensityOfCurveStartEnd.x * _245) + (dot(float4(FogParamsHeightFogIntegratedHermiteCoefs.x, FogParamsHeightFogIntegratedHermiteCoefs.y, FogParamsHeightFogIntegratedHermiteCoefs.z, FogParamsHeightFogIntegratedHermiteCoefs.w), float4(_258, _257, _254, 1.0f)) * _254))) - (FogParamsHeightFogDensityOfCurveStartEnd.y * (_212 - _247)));
          }
          do {
            if (isfinite(_407)) {
              _413 = exp2(_407 * 1.4426950216293335f);
            } else {
              _413 = 0.0f;
            }
            float _422 = FogParamsHeightFogEccentricity * FogParamsHeightFogEccentricity;
            float _426 = (_422 + 1.0f) + ((FogParamsHeightFogEccentricity * 2.0f) * dot(float3(DL_Direction.x, DL_Direction.y, DL_Direction.z), float3((-0.0f - _163), (-0.0f - _164), (-0.0f - _165))));
            float _432 = ((1.0f - _422) * 0.07957746833562851f) / max((_426 * sqrt(_426)), 9.999999747378752e-05f);
            do {
              if (!(Atmosphere_Flags == 0)) {
                float _444 = _171 * 0.0010000000474974513f;
                float _445 = _173 * 0.0010000000474974513f;
                float _446 = (PlanetRadius + _172) * 0.0010000000474974513f;
                float _452 = sqrt(((_444 * _444) + (_445 * _445)) + (_446 * _446));
                float _460 = dot(float3(SunDirection.x, SunDirection.z, SunDirection.y), float3((_444 / _452), (_445 / _452), (_446 / _452)));
                float _463 = OuterAtmosphereRadius * 0.0010000000474974513f;
                float _464 = PlanetRadius * 0.0010000000474974513f;
                float _465 = _463 * _463;
                float _466 = _464 * _464;
                float _469 = sqrt(max(0.0f, (_465 - _466)));
                float _470 = _452 * _452;
                float _473 = sqrt(max(0.0f, (_470 - _466)));
                float _482 = _463 - _452;
                float _486 = (max(0.0f, (sqrt(_465 + (_470 * ((_460 * _460) + -1.0f))) - (_460 * _452))) - _482) / ((_469 - _482) + _473);
                if (!(_486 > 1.0f)) {
                  float3 _491 = AtmosphereTransmittanceCopiedTexture.SampleLevel(BilinearClamp, float2(_486, (_473 / _469)), 0.0f);
                  _507 = ((AtmosphereBlendTextureAlphaScale * _491.x) + AtmosphereBlendTextureColor.x);
                  _508 = ((AtmosphereBlendTextureAlphaScale * _491.y) + AtmosphereBlendTextureColor.y);
                  _509 = ((AtmosphereBlendTextureAlphaScale * _491.z) + AtmosphereBlendTextureColor.z);
                } else {
                  _507 = 0.0f;
                  _508 = 0.0f;
                  _509 = 0.0f;
                }
              } else {
                _507 = 1.0f;
                _508 = 1.0f;
                _509 = 1.0f;
              }
              float _524 = (_205.w * 0.003921568859368563f) * (1.0f - _413);
              float _531 = saturate(_212 / (FogParamsHeightFogTransitionFactor * VFogCullingDistance));
              _548 = ((_531 * ((_205.x - _147.x) + (_524 * ((((_432 * float((uint)((int)(FogParamsHeightFogAlbedo & 255)))) * DL_VolumetricScatteringColor.x) * _507) + (float((uint)((int)(FogParamsHeightFogEmissiveColor & 255))) * FogParamsHeightFogEmissiveIntensity))))) + _147.x);
              _549 = ((((_205.y - _147.y) + (_524 * ((((_432 * float((uint)((int)(((uint)((int)(FogParamsHeightFogAlbedo)) >> 8) & 255)))) * DL_VolumetricScatteringColor.y) * _508) + (float((uint)((int)(((uint)((int)(FogParamsHeightFogEmissiveColor)) >> 8) & 255))) * FogParamsHeightFogEmissiveIntensity)))) * _531) + _147.y);
              _550 = ((((_205.z - _147.z) + (_524 * ((((_432 * float((uint)((int)(((uint)((int)(FogParamsHeightFogAlbedo)) >> 16) & 255)))) * DL_VolumetricScatteringColor.z) * _509) + (float((uint)((int)(((uint)((int)(FogParamsHeightFogEmissiveColor)) >> 16) & 255))) * FogParamsHeightFogEmissiveIntensity)))) * _531) + _147.z);
              _551 = ((_531 * ((_413 * _205.w) - _147.w)) + _147.w);
            } while (false);
          } while (false);
        } while (false);
      } else {
        _548 = _205.x;
        _549 = _205.y;
        _550 = _205.z;
        _551 = _205.w;
      }
    } else {
      _548 = _147.x;
      _549 = _147.y;
      _550 = _147.z;
      _551 = _147.w;
    }
  } else {
    _548 = 0.0f;
    _549 = 0.0f;
    _550 = 0.0f;
    _551 = 1.0f;
  }
  if (fog.fogMaxOpacity > 0.0f) {
    float _564 = _70 - (transposeViewInvMat[0].w);
    float _565 = _71 - (transposeViewInvMat[1].w);
    float _566 = _72 - (transposeViewInvMat[2].w);
    float _567 = dot(float3(_564, _565, _566), float3(_564, _565, _566));
    float _568 = rsqrt(_567);
    float _569 = _568 * _565;
    float _572 = select((abs(_569) < 9.999999747378752e-05f), 9.999999747378752e-05f, _569);
    float _576 = max(0.0f, ((_568 * _567) - fog.fogStartDistance));
    float _582 = (_576 * _572) * fog.fogDensity;
    do {
      if (abs(-0.0f - _582) > 9.999999747378752e-06f) {
        _594 = ((1.0f - exp2(_582 * -1.4426950216293335f)) / _572);
      } else {
        _594 = (fog.fogDensity * _576);
      }
      float _599 = min(fog.fogMaxOpacity, (exp2((fog.fogHeightFalloff * -1.4426950216293335f) * max(0.0f, (_71 - fog.fogHeightStartDistance))) * _594));
      _608 = (fog.fogInscatteringColor.x * _599);
      _609 = (fog.fogInscatteringColor.y * _599);
      _610 = (fog.fogInscatteringColor.z * _599);
      _611 = (1.0f - _599);
    } while (false);
  } else {
    _608 = 0.0f;
    _609 = 0.0f;
    _610 = 0.0f;
    _611 = 1.0f;
  }
  float _612 = _608 + _548;
  float _613 = _609 + _549;
  float _614 = _610 + _550;
  float _615 = _611 * _551;
  if (!((AtmosphereFlags & 2) == 0)) {
    float _623 = _70 * 0.0010000000474974513f;
    float _624 = _72 * 0.0010000000474974513f;
    float _628 = (PlanetRadius + _71) * 0.0010000000474974513f;
    do {
      if (((bool)(!(_75.x == 0.0f))) && ((bool)(!(sqrt(((_624 * _624) + (_623 * _623)) + (_628 * _628)) >= (OuterAtmosphereRadius * 0.0010000000474974513f))))) {
        float _646 = _70 - CameraPosition.x;
        float _647 = _71 - CameraPosition.y;
        float _648 = _72 - CameraPosition.z;
        float _654 = sqrt(((_646 * _646) + (_647 * _647)) + (_648 * _648));
        float _682 = mad(_72, (viewProjMat[2].w), mad(_71, (viewProjMat[1].w), ((viewProjMat[0].w) * _70))) + (viewProjMat[3].w);
        float _691 = (_654 * 0.0010000000474974513f) - AerialPerspectiveStartDepth;
        if (!(_691 <= 0.0f)) {
          do {
            if (_654 < cameraFarPlane) {
              _712 = ((_654 / cameraFarPlane) * 24.0f);
            } else {
              _712 = ((((_654 - cameraFarPlane) / ((OuterAtmosphereRadius - PlanetRadius) - cameraFarPlane)) * 8.0f) + 24.0f);
            }
            do {
              if (_712 < 0.5f) {
                _718 = saturate(_712 * 2.0f);
                _719 = 0.5f;
              } else {
                _718 = 1.0f;
                _719 = _712;
              }
              float _722 = _718 * saturate(AtmosphereLerpWeight * _691);
              float4 _725 = AerialPerspectiveTexture.SampleLevel(BilinearClamp, float3(((((mad(_72, (viewProjMat[2].x), mad(_71, (viewProjMat[1].x), ((viewProjMat[0].x) * _70))) + (viewProjMat[3].x)) / _682) * 0.5f) + 0.5f), (0.5f - (((mad(_72, (viewProjMat[2].y), mad(_71, (viewProjMat[1].y), ((viewProjMat[0].y) * _70))) + (viewProjMat[3].y)) / _682) * 0.5f)), sqrt(_719 * 0.03125f)), 0.0f);
              float _735 = _722 * AerialPerspectiveIntensity;
              _745 = ((_735 * _725.x) * SunColor.x);
              _746 = ((_735 * _725.y) * SunColor.y);
              _747 = ((_735 * _725.z) * SunColor.z);
              _748 = saturate(1.0f - (_725.w * _722));
            } while (false);
          } while (false);
        } else {
          _745 = 0.0f;
          _746 = 0.0f;
          _747 = 0.0f;
          _748 = 1.0f;
        }
      } else {
        _745 = 0.0f;
        _746 = 0.0f;
        _747 = 0.0f;
        _748 = 1.0f;
      }
      _757 = ((_745 * _615) + _612);
      _758 = ((_746 * _615) + _613);
      _759 = ((_747 * _615) + _614);
      _760 = (_748 * _615);
    } while (false);
  } else {
    _757 = _612;
    _758 = _613;
    _759 = _614;
    _760 = _615;
  }
  SV_Target.x = (rangeCompress * _757);
  SV_Target.y = (rangeCompress * _758);
  SV_Target.z = (rangeCompress * _759);
  SV_Target.w = _760;
  SV_Target.xyz *= CUSTOM_FOG_AMOUNT;
  return SV_Target;
}
