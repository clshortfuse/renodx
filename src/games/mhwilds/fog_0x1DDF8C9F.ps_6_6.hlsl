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
  uint blueNoiseJitterIndex : packoffset(c038.z);
  float2 SceneInfo_Reserve2 : packoffset(c039.x);
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

cbuffer LightInfo : register(b2) {
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

cbuffer VolumetricParams : register(b3) {
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

SamplerState BilinearClamp : register(s5, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  uint _16 = uint(SV_Position.x);
  uint _17 = uint(SV_Position.y);
  float _19 = ReadonlyDepth.Load(int3(_16, _17, 0));
  float _50 = ((float((uint)_16) * 2.0f) * screenInverseSize.x) + -1.0f;
  float _51 = 1.0f - ((float((uint)_17) * 2.0f) * screenInverseSize.y);
  float _67 = mad(_19.x, (viewProjInvMat[2].w), mad(_51, (viewProjInvMat[1].w), (_50 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w);
  float _68 = (mad(_19.x, (viewProjInvMat[2].x), mad(_51, (viewProjInvMat[1].x), (_50 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x)) / _67;
  float _69 = (mad(_19.x, (viewProjInvMat[2].y), mad(_51, (viewProjInvMat[1].y), (_50 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y)) / _67;
  float _70 = (mad(_19.x, (viewProjInvMat[2].z), mad(_51, (viewProjInvMat[1].z), (_50 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z)) / _67;
  float _73 = ReadonlyDepth.Load(int3(int(SV_Position.x), int(SV_Position.y), 0));
  float _276;
  float _367;
  float _405;
  float _411;
  float _505;
  float _506;
  float _507;
  float _546;
  float _547;
  float _548;
  float _549;
  float _646;
  float _652;
  float _653;
  float _679;
  float _680;
  float _681;
  float _682;
  float _691;
  float _692;
  float _693;
  float _694;
  if (!((FrustumVolumeFlags & 1) == 0)) {
    float _107 = mad(_70, (viewProjMat[2].w), mad(_69, (viewProjMat[1].w), ((viewProjMat[0].w) * _68))) + (viewProjMat[3].w);
    float _120 = _68 - (transposeViewInvMat[0].w);
    float _121 = _69 - (transposeViewInvMat[1].w);
    float _122 = _70 - (transposeViewInvMat[2].w);
    float _132 = sqrt(((_121 * _121) + (_120 * _120)) + (_122 * _122));
    float4 _145 = VolumetricFogTexture.SampleLevel(BilinearClamp, float3((((((mad(_70, (viewProjMat[2].x), mad(_69, (viewProjMat[1].x), ((viewProjMat[0].x) * _68))) + (viewProjMat[3].x)) / _107) * 0.5f) + 0.5f) + VFogSampleOffset.x), ((0.5f - (((mad(_70, (viewProjMat[2].y), mad(_69, (viewProjMat[1].y), ((viewProjMat[0].y) * _68))) + (viewProjMat[3].y)) / _107) * 0.5f)) + VFogSampleOffset.y), ((log2(max((_132 - DepthEncodingParams.y), 0.0f)) * DepthEncodingParams.z) + DepthEncodingParams.x)), 0.0f);
    if (!((FogParamsFlags & 1) == 0)) {
      float _160 = (1.0f - FogParamsHeightFogTransitionFactor) * VFogCullingDistance;
      float _161 = _120 / _132;
      float _162 = _121 / _132;
      float _163 = _122 / _132;
      float _165 = max(0.0010000000474974513f, min(_132, _160));
      float _166 = _165 * _161;
      float _167 = _165 * _162;
      float _168 = _165 * _163;
      float _169 = _166 + (transposeViewInvMat[0].w);
      float _170 = _167 + (transposeViewInvMat[1].w);
      float _171 = _168 + (transposeViewInvMat[2].w);
      float _183 = mad(_171, (viewProjMat[2].w), mad(_170, (viewProjMat[1].w), (_169 * (viewProjMat[0].w)))) + (viewProjMat[3].w);
      float4 _203 = VolumetricFogTexture.SampleLevel(BilinearClamp, float3((((((mad(_171, (viewProjMat[2].x), mad(_170, (viewProjMat[1].x), (_169 * (viewProjMat[0].x)))) + (viewProjMat[3].x)) / _183) * 0.5f) + 0.5f) + VFogSampleOffset.x), ((0.5f - (((mad(_171, (viewProjMat[2].y), mad(_170, (viewProjMat[1].y), (_169 * (viewProjMat[0].y)))) + (viewProjMat[3].y)) / _183) * 0.5f)) + VFogSampleOffset.y), ((log2(max((sqrt(((_167 * _167) + (_166 * _166)) + (_168 * _168)) - DepthEncodingParams.y), 0.0f)) * DepthEncodingParams.z) + DepthEncodingParams.x)), 0.0f);
      float _210 = min(_132, FogParamsHeightFogCutoffDistance) - _160;
      if (_210 > 0.0f) {
        float _243 = min(_210, FogParamsHeightFogHermiteCurveRange.x);
        float _245 = min(_210, FogParamsHeightFogHermiteCurveRange.y);
        float _251 = (FogParamsHeightFogHermiteCurveMadd.x * _243) + FogParamsHeightFogHermiteCurveMadd.y;
        float _252 = (FogParamsHeightFogHermiteCurveMadd.x * _245) + FogParamsHeightFogHermiteCurveMadd.y;
        float _253 = _251 * _251;
        float _254 = _253 * _251;
        float _255 = _252 * _252;
        float _256 = _255 * _252;
        do {
          if (!(FogParamsHeightFogAttenuationByHeight == 0.0f)) {
            float _260 = FogParamsHeightFogAttenuationByHeight * _162;
            float _261 = 1.0f / _260;
            do {
              if (FogParamsHeightFogDensityOfCurveStartEnd.x > 0.0f) {
                float _265 = _170 - FogParamsHeightFogReferenceAltitude;
                float _267 = FogParamsHeightFogAttenuationByHeight * -1.4426950216293335f;
                _276 = ((FogParamsHeightFogDensityOfCurveStartEnd.x * _261) * (exp2(_267 * (_265 + (_243 * _162))) - exp2(_267 * _265)));
              } else {
                _276 = 0.0f;
              }
              float _279 = _170 - FogParamsHeightFogReferenceAltitude;
              float _280 = FogParamsHeightFogAttenuationByHeight * -1.4426950216293335f;
              float _284 = exp2(_280 * (_279 + (_243 * _162)));
              do {
                if (abs(_260) < 0.000750000006519258f) {
                  float _287 = (_245 - _243) * _260;
                  float _290 = 1.0f - _287;
                  float _297 = FogParamsHeightFogCommonCoefsForTaylor.y * _260;
                  float _298 = (_260 * _260) * FogParamsHeightFogCommonCoefsForTaylor.z;
                  float _304 = _256 * _252;
                  float _311 = _256 * _255;
                  float _324 = _254 * _251;
                  float _326 = _254 * _253;
                  _367 = (-0.0f - (_284 * (dot(float3((FogParamsHeightFogCommonCoefsForTaylor.x * (((_287 * _287) * 0.5f) + _290)), (_297 * _290), _298), float3(dot(float4(_304, _256, _255, _252), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].w))), dot(float4(_311, (_255 * _255), _256, _255), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].w))), dot(float4((_256 * _256), _311, _304, _256), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].w))))) - dot(float3(FogParamsHeightFogCommonCoefsForTaylor.x, _297, _298), float3(dot(float4(_324, _254, _253, _251), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].w))), dot(float4(_326, (_253 * _253), _254, _253), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].w))), dot(float4((_254 * _254), _326, _324, _254), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].w))))))));
                } else {
                  float _336 = _261 * _261;
                  float _337 = _336 * _261;
                  float _338 = _337 * _261;
                  _367 = ((dot(float4(_261, _336, _337, _338), float4(dot(float4(_256, _255, _252, 1.0f), float4(FogParamsHeightFogIntegratedHermiteCoefsA.x, FogParamsHeightFogIntegratedHermiteCoefsA.y, FogParamsHeightFogIntegratedHermiteCoefsA.z, FogParamsHeightFogIntegratedHermiteCoefsA.w)), dot(float3(_255, _252, 1.0f), float3(FogParamsHeightFogIntegratedHermiteCoefsB.x, FogParamsHeightFogIntegratedHermiteCoefsB.y, FogParamsHeightFogIntegratedHermiteCoefsB.z)), dot(float2(_252, 1.0f), float2(FogParamsHeightFogIntegratedHermiteCoefsC.x, FogParamsHeightFogIntegratedHermiteCoefsC.y)), FogParamsHeightFogIntegratedHermiteCoefsD)) * exp2(_280 * (_279 + (_245 * _162)))) - (dot(float4(_261, _336, _337, _338), float4(dot(float4(_254, _253, _251, 1.0f), float4(FogParamsHeightFogIntegratedHermiteCoefsA.x, FogParamsHeightFogIntegratedHermiteCoefsA.y, FogParamsHeightFogIntegratedHermiteCoefsA.z, FogParamsHeightFogIntegratedHermiteCoefsA.w)), dot(float3(_253, _251, 1.0f), float3(FogParamsHeightFogIntegratedHermiteCoefsB.x, FogParamsHeightFogIntegratedHermiteCoefsB.y, FogParamsHeightFogIntegratedHermiteCoefsB.z)), dot(float2(_251, 1.0f), float2(FogParamsHeightFogIntegratedHermiteCoefsC.x, FogParamsHeightFogIntegratedHermiteCoefsC.y)), FogParamsHeightFogIntegratedHermiteCoefsD)) * _284));
                }
                float _368 = _367 + _276;
                if (FogParamsHeightFogDensityOfCurveStartEnd.y > 0.0f) {
                  float _375 = FogParamsHeightFogAttenuationByHeight * -1.4426950216293335f;
                  _405 = (((FogParamsHeightFogDensityOfCurveStartEnd.y * _261) * (exp2(_375 * (((_210 * _162) + _170) - FogParamsHeightFogReferenceAltitude)) - exp2(_375 * ((_170 - FogParamsHeightFogReferenceAltitude) + (_245 * _162))))) + _368);
                } else {
                  _405 = _368;
                }
              } while (false);
            } while (false);
          } else {
            _405 = (((dot(float4(FogParamsHeightFogIntegratedHermiteCoefs.x, FogParamsHeightFogIntegratedHermiteCoefs.y, FogParamsHeightFogIntegratedHermiteCoefs.z, FogParamsHeightFogIntegratedHermiteCoefs.w), float4(_254, _253, _251, 1.0f)) * _251) - ((FogParamsHeightFogDensityOfCurveStartEnd.x * _243) + (dot(float4(FogParamsHeightFogIntegratedHermiteCoefs.x, FogParamsHeightFogIntegratedHermiteCoefs.y, FogParamsHeightFogIntegratedHermiteCoefs.z, FogParamsHeightFogIntegratedHermiteCoefs.w), float4(_256, _255, _252, 1.0f)) * _252))) - (FogParamsHeightFogDensityOfCurveStartEnd.y * (_210 - _245)));
          }
          do {
            if (isfinite(_405)) {
              _411 = exp2(_405 * 1.4426950216293335f);
            } else {
              _411 = 0.0f;
            }
            float _420 = FogParamsHeightFogEccentricity * FogParamsHeightFogEccentricity;
            float _424 = (_420 + 1.0f) + ((FogParamsHeightFogEccentricity * 2.0f) * dot(float3(DL_Direction.x, DL_Direction.y, DL_Direction.z), float3((-0.0f - _161), (-0.0f - _162), (-0.0f - _163))));
            float _430 = ((1.0f - _420) * 0.07957746833562851f) / max((_424 * sqrt(_424)), 9.999999747378752e-05f);
            do {
              if (!(Atmosphere_Flags == 0)) {
                float _442 = _169 * 0.0010000000474974513f;
                float _443 = _171 * 0.0010000000474974513f;
                float _444 = (PlanetRadius + _170) * 0.0010000000474974513f;
                float _450 = sqrt(((_442 * _442) + (_443 * _443)) + (_444 * _444));
                float _458 = dot(float3(SunDirection.x, SunDirection.z, SunDirection.y), float3((_442 / _450), (_443 / _450), (_444 / _450)));
                float _461 = OuterAtmosphereRadius * 0.0010000000474974513f;
                float _462 = PlanetRadius * 0.0010000000474974513f;
                float _463 = _461 * _461;
                float _464 = _462 * _462;
                float _467 = sqrt(max(0.0f, (_463 - _464)));
                float _468 = _450 * _450;
                float _471 = sqrt(max(0.0f, (_468 - _464)));
                float _480 = _461 - _450;
                float _484 = (max(0.0f, (sqrt(_463 + (_468 * ((_458 * _458) + -1.0f))) - (_458 * _450))) - _480) / ((_467 - _480) + _471);
                if (!(_484 > 1.0f)) {
                  float3 _489 = AtmosphereTransmittanceCopiedTexture.SampleLevel(BilinearClamp, float2(_484, (_471 / _467)), 0.0f);
                  _505 = ((AtmosphereBlendTextureAlphaScale * _489.x) + AtmosphereBlendTextureColor.x);
                  _506 = ((AtmosphereBlendTextureAlphaScale * _489.y) + AtmosphereBlendTextureColor.y);
                  _507 = ((AtmosphereBlendTextureAlphaScale * _489.z) + AtmosphereBlendTextureColor.z);
                } else {
                  _505 = 0.0f;
                  _506 = 0.0f;
                  _507 = 0.0f;
                }
              } else {
                _505 = 1.0f;
                _506 = 1.0f;
                _507 = 1.0f;
              }
              float _522 = (_203.w * 0.003921568859368563f) * (1.0f - _411);
              float _529 = saturate(_210 / (FogParamsHeightFogTransitionFactor * VFogCullingDistance));
              _546 = ((_529 * ((_203.x - _145.x) + (_522 * ((((_430 * float((uint)((int)(FogParamsHeightFogAlbedo & 255)))) * DL_VolumetricScatteringColor.x) * _505) + (float((uint)((int)(FogParamsHeightFogEmissiveColor & 255))) * FogParamsHeightFogEmissiveIntensity))))) + _145.x);
              _547 = ((((_203.y - _145.y) + (_522 * ((((_430 * float((uint)((int)(((uint)((int)(FogParamsHeightFogAlbedo)) >> 8) & 255)))) * DL_VolumetricScatteringColor.y) * _506) + (float((uint)((int)(((uint)((int)(FogParamsHeightFogEmissiveColor)) >> 8) & 255))) * FogParamsHeightFogEmissiveIntensity)))) * _529) + _145.y);
              _548 = ((((_203.z - _145.z) + (_522 * ((((_430 * float((uint)((int)(((uint)((int)(FogParamsHeightFogAlbedo)) >> 16) & 255)))) * DL_VolumetricScatteringColor.z) * _507) + (float((uint)((int)(((uint)((int)(FogParamsHeightFogEmissiveColor)) >> 16) & 255))) * FogParamsHeightFogEmissiveIntensity)))) * _529) + _145.z);
              _549 = ((_529 * ((_411 * _203.w) - _145.w)) + _145.w);
            } while (false);
          } while (false);
        } while (false);
      } else {
        _546 = _203.x;
        _547 = _203.y;
        _548 = _203.z;
        _549 = _203.w;
      }
    } else {
      _546 = _145.x;
      _547 = _145.y;
      _548 = _145.z;
      _549 = _145.w;
    }
  } else {
    _546 = 0.0f;
    _547 = 0.0f;
    _548 = 0.0f;
    _549 = 1.0f;
  }
  if (!((AtmosphereFlags & 2) == 0)) {
    float _557 = _68 * 0.0010000000474974513f;
    float _558 = _70 * 0.0010000000474974513f;
    float _562 = (PlanetRadius + _69) * 0.0010000000474974513f;
    do {
      if (((bool)(!(_73.x == 0.0f))) && ((bool)(!(sqrt(((_558 * _558) + (_557 * _557)) + (_562 * _562)) >= (OuterAtmosphereRadius * 0.0010000000474974513f))))) {
        float _580 = _68 - CameraPosition.x;
        float _581 = _69 - CameraPosition.y;
        float _582 = _70 - CameraPosition.z;
        float _588 = sqrt(((_580 * _580) + (_581 * _581)) + (_582 * _582));
        float _616 = mad(_70, (viewProjMat[2].w), mad(_69, (viewProjMat[1].w), ((viewProjMat[0].w) * _68))) + (viewProjMat[3].w);
        float _625 = (_588 * 0.0010000000474974513f) - AerialPerspectiveStartDepth;
        if (!(_625 <= 0.0f)) {
          do {
            if (_588 < cameraFarPlane) {
              _646 = ((_588 / cameraFarPlane) * 24.0f);
            } else {
              _646 = ((((_588 - cameraFarPlane) / ((OuterAtmosphereRadius - PlanetRadius) - cameraFarPlane)) * 8.0f) + 24.0f);
            }
            do {
              if (_646 < 0.5f) {
                _652 = saturate(_646 * 2.0f);
                _653 = 0.5f;
              } else {
                _652 = 1.0f;
                _653 = _646;
              }
              float _656 = _652 * saturate(AtmosphereLerpWeight * _625);
              float4 _659 = AerialPerspectiveTexture.SampleLevel(BilinearClamp, float3(((((mad(_70, (viewProjMat[2].x), mad(_69, (viewProjMat[1].x), ((viewProjMat[0].x) * _68))) + (viewProjMat[3].x)) / _616) * 0.5f) + 0.5f), (0.5f - (((mad(_70, (viewProjMat[2].y), mad(_69, (viewProjMat[1].y), ((viewProjMat[0].y) * _68))) + (viewProjMat[3].y)) / _616) * 0.5f)), sqrt(_653 * 0.03125f)), 0.0f);
              float _669 = _656 * AerialPerspectiveIntensity;
              _679 = ((_669 * _659.x) * SunColor.x);
              _680 = ((_669 * _659.y) * SunColor.y);
              _681 = ((_669 * _659.z) * SunColor.z);
              _682 = saturate(1.0f - (_659.w * _656));
            } while (false);
          } while (false);
        } else {
          _679 = 0.0f;
          _680 = 0.0f;
          _681 = 0.0f;
          _682 = 1.0f;
        }
      } else {
        _679 = 0.0f;
        _680 = 0.0f;
        _681 = 0.0f;
        _682 = 1.0f;
      }
      _691 = ((_679 * _549) + _546);
      _692 = ((_680 * _549) + _547);
      _693 = ((_681 * _549) + _548);
      _694 = (_682 * _549);
    } while (false);
  } else {
    _691 = _546;
    _692 = _547;
    _693 = _548;
    _694 = _549;
  }
  SV_Target.x = (rangeCompress * _691);
  SV_Target.y = (rangeCompress * _692);
  SV_Target.z = (rangeCompress * _693);
  SV_Target.w = _694;

  SV_Target.xyz *= CUSTOM_FOG_AMOUNT;

  return SV_Target;
}
