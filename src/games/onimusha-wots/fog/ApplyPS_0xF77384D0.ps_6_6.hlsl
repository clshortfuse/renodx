#include "../shared.h"

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
  uint blueNoiseJitterIndex : packoffset(c038.z);
  float tessellationParam : packoffset(c038.w);
  float SceneInfo_Reserve2 : packoffset(c039.x);
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
  uint SDFShadowEnabled : packoffset(c041.w);
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
  float shadowReserved0 : packoffset(c054.y);
  float shadowReserved1 : packoffset(c054.z);
  float shadowReserved2 : packoffset(c054.w);
};

cbuffer VolumetricParticleInjection : register(b4) {
  float3 vpiContribution : packoffset(c000.x);
  float vpiTransmittance : packoffset(c000.w);
  uint vpiEnable : packoffset(c001.x);
  float vpiAsymmetryParameter : packoffset(c001.y);
  float vpiCompositionRate : packoffset(c001.z);
  uint vpiReserved : packoffset(c001.w);
};

SamplerState BilinearClamp : register(s5, space32);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  uint _19;
  uint _20;
  float _22;
  float _53;
  float _54;
  float _70;
  float _71;
  float _72;
  float _73;
  float _378;
  float _407;
  float _413;
  float _515;
  float _516;
  float _517;
  float _529;
  float _530;
  float _531;
  float _560;
  float _561;
  float _562;
  float _563;
  float _593;
  float _594;
  float _595;
  float _596;
  float _693;
  float _699;
  float _700;
  float _709;
  float _733;
  float _734;
  float _735;
  float _736;
  float _745;
  float _746;
  float _747;
  float _748;
  float _110;
  float _115;
  float _116;
  float _123;
  float _124;
  float _125;
  float _135;
  float4 _148;
  float _163;
  float _164;
  float _165;
  float _166;
  float _168;
  float _169;
  float _170;
  float _171;
  float _172;
  float _173;
  float _174;
  float _186;
  float4 _206;
  float _213;
  float _239;
  float _247;
  float _249;
  float _255;
  float _256;
  float _257;
  float _261;
  float _262;
  float _264;
  float _266;
  float _277;
  bool _280;
  float _284;
  float _285;
  bool _286;
  float _295;
  float _296;
  float _299;
  float _300;
  float _301;
  float _302;
  float _332;
  float _333;
  float _334;
  float _338;
  float _339;
  float _340;
  float _341;
  float _342;
  float _343;
  float _385;
  float _387;
  float _430;
  float _434;
  float _452;
  float _453;
  float _454;
  float _460;
  float _468;
  float _471;
  float _472;
  float _473;
  float _474;
  float _477;
  float _478;
  float _481;
  float _490;
  float _494;
  float3 _499;
  float _518;
  float _536;
  float _543;
  float4 _569;
  float _574;
  float _604;
  float _605;
  float _609;
  float _627;
  float _628;
  float _629;
  float _635;
  float _663;
  float _672;
  float _701;
  float _710;
  float4 _713;
  float _723;
  _19 = uint(SV_Position.x);
  _20 = uint(SV_Position.y);
  _22 = ReadonlyDepth.Load(int3(_19, _20, 0));
  _53 = ((((float)((uint)_19)) * 2.0f) * screenInverseSize.x) + -1.0f;
  _54 = 1.0f - ((((float)((uint)_20)) * 2.0f) * screenInverseSize.y);
  _70 = mad(_22.x, (viewProjInvMat[2].w), mad(_54, (viewProjInvMat[1].w), (_53 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w);
  _71 = (mad(_22.x, (viewProjInvMat[2].x), mad(_54, (viewProjInvMat[1].x), (_53 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x)) / _70;
  _72 = (mad(_22.x, (viewProjInvMat[2].y), mad(_54, (viewProjInvMat[1].y), (_53 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y)) / _70;
  _73 = (mad(_22.x, (viewProjInvMat[2].z), mad(_54, (viewProjInvMat[1].z), (_53 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z)) / _70;
  if (!((FrustumVolumeFlags & 1) == 0)) {
    _110 = mad(_73, (viewProjMat[2].w), mad(_72, (viewProjMat[1].w), ((viewProjMat[0].w) * _71))) + (viewProjMat[3].w);
    _115 = (((mad(_73, (viewProjMat[2].x), mad(_72, (viewProjMat[1].x), ((viewProjMat[0].x) * _71))) + (viewProjMat[3].x)) / _110) * 0.5f) + 0.5f;
    _116 = 0.5f - (((mad(_73, (viewProjMat[2].y), mad(_72, (viewProjMat[1].y), ((viewProjMat[0].y) * _71))) + (viewProjMat[3].y)) / _110) * 0.5f);
    _123 = _71 - (transposeViewInvMat[0].w);
    _124 = _72 - (transposeViewInvMat[1].w);
    _125 = _73 - (transposeViewInvMat[2].w);
    _135 = sqrt(((_124 * _124) + (_123 * _123)) + (_125 * _125));
    _148 = VolumetricFogTexture.SampleLevel(BilinearClamp, float3((VFogSampleOffset.x + _115), (VFogSampleOffset.y + _116), ((log2(max((_135 - DepthEncodingParams.y), 0.0f)) * DepthEncodingParams.z) + DepthEncodingParams.x)), 0.0f);
    do {
      _560 = _148.x;
      _561 = _148.y;
      _562 = _148.z;
      _563 = _148.w;
      if (!((FogParamsFlags & 1) == 0)) {
        _163 = (1.0f - FogParamsHeightFogTransitionFactor) * VFogCullingDistance;
        _164 = _123 / _135;
        _165 = _124 / _135;
        _166 = _125 / _135;
        _168 = max(0.0010000000474974513f, min(_135, _163));
        _169 = _168 * _164;
        _170 = _168 * _165;
        _171 = _168 * _166;
        _172 = _169 + (transposeViewInvMat[0].w);
        _173 = _170 + (transposeViewInvMat[1].w);
        _174 = _171 + (transposeViewInvMat[2].w);
        _186 = mad(_174, (viewProjMat[2].w), mad(_173, (viewProjMat[1].w), (_172 * (viewProjMat[0].w)))) + (viewProjMat[3].w);
        _206 = VolumetricFogTexture.SampleLevel(BilinearClamp, float3(((VFogSampleOffset.x + 0.5f) + (((mad(_174, (viewProjMat[2].x), mad(_173, (viewProjMat[1].x), (_172 * (viewProjMat[0].x)))) + (viewProjMat[3].x)) / _186) * 0.5f)), ((VFogSampleOffset.y + 0.5f) - (((mad(_174, (viewProjMat[2].y), mad(_173, (viewProjMat[1].y), (_172 * (viewProjMat[0].y)))) + (viewProjMat[3].y)) / _186) * 0.5f)), ((log2(max((sqrt(((_170 * _170) + (_169 * _169)) + (_171 * _171)) - DepthEncodingParams.y), 0.0f)) * DepthEncodingParams.z) + DepthEncodingParams.x)), 0.0f);
        _213 = min(_135, FogParamsHeightFogCutoffDistance) - _163;
        if (_213 > 0.0f) {
          _239 = FogParamsHeightFogEmissiveIntensity * 0.003921568859368563f;
          _247 = min(_213, FogParamsHeightFogHermiteCurveRange.x);
          _249 = min(_213, FogParamsHeightFogHermiteCurveRange.y);
          _255 = (FogParamsHeightFogHermiteCurveMadd.x * _247) + FogParamsHeightFogHermiteCurveMadd.y;
          _256 = (FogParamsHeightFogHermiteCurveMadd.x * _249) + FogParamsHeightFogHermiteCurveMadd.y;
          _257 = FogParamsHeightFogAttenuationByHeight * _165;
          _261 = _173 - FogParamsHeightFogReferenceAltitude;
          _262 = FogParamsHeightFogAttenuationByHeight * -1.4426950216293335f;
          _264 = exp2(_262 * _261);
          do {
            if (!(_257 == 0.0f)) {
              _266 = 1.0f / _257;
              _277 = exp2(((_247 * _165) + _261) * _262);
              _280 = (FogParamsHeightFogDensityOfCurveStartEnd.x > 0.0f);
              _284 = select(_280, ((_266 * FogParamsHeightFogDensityOfCurveStartEnd.x) * (_277 - _264)), 0.0f);
              _285 = _249 - _247;
              _286 = (FogParamsHeightFogDensityOfCurveStartEnd.y > 0.0f);
              do {
                _378 = _284;
                if ((_285 > 0.0f) && (_280 || _286)) {
                  _295 = (_285 * 0.3333333432674408f) + _247;
                  _296 = (_285 * 0.6666666865348816f) + _247;
                  _299 = (_295 * FogParamsHeightFogHermiteCurveMadd.x) + FogParamsHeightFogHermiteCurveMadd.y;
                  _300 = (_296 * FogParamsHeightFogHermiteCurveMadd.x) + FogParamsHeightFogHermiteCurveMadd.y;
                  _301 = _299 * _299;
                  _302 = _300 * _300;
                  _332 = (_285 * 0.1666666716337204f) + _247;
                  _333 = (_285 * 0.5f) + _247;
                  _334 = (_285 * 0.8333333134651184f) + _247;
                  _338 = (_332 * FogParamsHeightFogHermiteCurveMadd.x) + FogParamsHeightFogHermiteCurveMadd.y;
                  _339 = (_333 * FogParamsHeightFogHermiteCurveMadd.x) + FogParamsHeightFogHermiteCurveMadd.y;
                  _340 = (_334 * FogParamsHeightFogHermiteCurveMadd.x) + FogParamsHeightFogHermiteCurveMadd.y;
                  _341 = _338 * _338;
                  _342 = _339 * _339;
                  _343 = _340 * _340;
                  _378 = (_284 - ((_285 * 0.0555555559694767f) * (((dot(float2(exp2(((_295 * _165) + _261) * _262), exp2(((_296 * _165) + _261) * _262)), float2((mad(FogParamsHeightFogIntegratedHermiteCoefsA.z, _299, mad(FogParamsHeightFogIntegratedHermiteCoefsA.y, _301, ((_301 * _299) * FogParamsHeightFogIntegratedHermiteCoefsA.x))) + FogParamsHeightFogIntegratedHermiteCoefsA.w), (mad(FogParamsHeightFogIntegratedHermiteCoefsA.z, _300, mad(FogParamsHeightFogIntegratedHermiteCoefsA.y, _302, ((_302 * _300) * FogParamsHeightFogIntegratedHermiteCoefsA.x))) + FogParamsHeightFogIntegratedHermiteCoefsA.w))) * 2.0f) + ((_277 + _264) * FogParamsHeightFogDensityOfCurveStartEnd.x)) + (dot(float3(exp2(((_332 * _165) + _261) * _262), exp2(((_333 * _165) + _261) * _262), exp2(((_334 * _165) + _261) * _262)), float3((mad(FogParamsHeightFogIntegratedHermiteCoefsA.z, _338, mad(FogParamsHeightFogIntegratedHermiteCoefsA.y, _341, ((_341 * _338) * FogParamsHeightFogIntegratedHermiteCoefsA.x))) + FogParamsHeightFogIntegratedHermiteCoefsA.w), (mad(FogParamsHeightFogIntegratedHermiteCoefsA.z, _339, mad(FogParamsHeightFogIntegratedHermiteCoefsA.y, _342, ((_342 * _339) * FogParamsHeightFogIntegratedHermiteCoefsA.x))) + FogParamsHeightFogIntegratedHermiteCoefsA.w), (mad(FogParamsHeightFogIntegratedHermiteCoefsA.z, _340, mad(FogParamsHeightFogIntegratedHermiteCoefsA.y, _343, ((_343 * _340) * FogParamsHeightFogIntegratedHermiteCoefsA.x))) + FogParamsHeightFogIntegratedHermiteCoefsA.w))) * 4.0f))));
                }
                if (_286) {
                  _407 = (_378 + ((_266 * FogParamsHeightFogDensityOfCurveStartEnd.y) * (exp2(_262 * (((_213 * _165) + _173) - FogParamsHeightFogReferenceAltitude)) - exp2(((_249 * _165) + _261) * _262))));
                } else {
                  _407 = _378;
                }
              } while (false);
            } else {
              _385 = _256 * _256;
              _387 = _255 * _255;
              _407 = (((((-0.0f - (FogParamsHeightFogDensityOfCurveStartEnd.x * _247)) - (FogParamsHeightFogDensityOfCurveStartEnd.y * (_213 - _249))) - (dot(float4(FogParamsHeightFogIntegratedHermiteCoefs.x, FogParamsHeightFogIntegratedHermiteCoefs.y, FogParamsHeightFogIntegratedHermiteCoefs.z, FogParamsHeightFogIntegratedHermiteCoefs.w), float4((_385 * _256), _385, _256, 1.0f)) * _256)) + (dot(float4(FogParamsHeightFogIntegratedHermiteCoefs.x, FogParamsHeightFogIntegratedHermiteCoefs.y, FogParamsHeightFogIntegratedHermiteCoefs.z, FogParamsHeightFogIntegratedHermiteCoefs.w), float4((_387 * _255), _387, _255, 1.0f)) * _255)) * _264);
            }
            do {
              _413 = 0.0f;
              if (isfinite(_407)) {
                _413 = exp2(_407 * 1.4426950216293335f);
              }
              do {
                _529 = 0.0f;
                _530 = 0.0f;
                _531 = 0.0f;
                if (!(((DL_Enable & 255) & GPUVisibleMask) == 0)) {
                  _430 = FogParamsHeightFogEccentricity * FogParamsHeightFogEccentricity;
                  _434 = (_430 + 1.0f) + ((FogParamsHeightFogEccentricity * 2.0f) * dot(float3(DL_Direction.x, DL_Direction.y, DL_Direction.z), float3((-0.0f - _164), (-0.0f - _165), (-0.0f - _166))));
                  do {
                    _515 = 1.0f;
                    _516 = 1.0f;
                    _517 = 1.0f;
                    if (!(Atmosphere_Flags == 0)) {
                      _452 = _172 * 0.0010000000474974513f;
                      _453 = _174 * 0.0010000000474974513f;
                      _454 = (PlanetRadius + _173) * 0.0010000000474974513f;
                      _460 = sqrt(((_452 * _452) + (_453 * _453)) + (_454 * _454));
                      _468 = dot(float3(SunDirection.x, SunDirection.z, SunDirection.y), float3((_452 / _460), (_453 / _460), (_454 / _460)));
                      _471 = OuterAtmosphereRadius * 0.0010000000474974513f;
                      _472 = PlanetRadius * 0.0010000000474974513f;
                      _473 = _471 * _471;
                      _474 = _472 * _472;
                      _477 = sqrt(max(0.0f, (_473 - _474)));
                      _478 = _460 * _460;
                      _481 = sqrt(max(0.0f, (_478 - _474)));
                      _490 = _471 - _460;
                      _494 = (max(0.0f, (sqrt(_473 + (((_468 * _468) + -1.0f) * _478)) - (_468 * _460))) - _490) / ((_477 - _490) + _481);
                      if (!(_494 > 1.0f)) {
                        _499 = AtmosphereTransmittanceCopiedTexture.SampleLevel(BilinearClamp, float2(_494, (_481 / _477)), 0.0f);
                        _515 = ((_499.x * AtmosphereBlendTextureAlphaScale) + AtmosphereBlendTextureColor.x);
                        _516 = ((_499.y * AtmosphereBlendTextureAlphaScale) + AtmosphereBlendTextureColor.y);
                        _517 = ((_499.z * AtmosphereBlendTextureAlphaScale) + AtmosphereBlendTextureColor.z);
                      } else {
                        _515 = 0.0f;
                        _516 = 0.0f;
                        _517 = 0.0f;
                      }
                    }
                    _518 = (((1.0f - _430) * 0.07957746833562851f) / max((_434 * sqrt(_434)), 9.999999747378752e-05f)) * 0.003921568859368563f;
                    _529 = (((_518 * ((float)((uint)((uint)(FogParamsHeightFogAlbedo & 255))))) * DL_VolumetricScatteringColor.x) * _515);
                    _530 = (((_518 * ((float)((uint)((uint)(((uint)((uint)(FogParamsHeightFogAlbedo)) >> 8) & 255))))) * DL_VolumetricScatteringColor.y) * _516);
                    _531 = (((_518 * ((float)((uint)((uint)(((uint)((uint)(FogParamsHeightFogAlbedo)) >> 16) & 255))))) * DL_VolumetricScatteringColor.z) * _517);
                  } while (false);
                }
                _536 = (1.0f - _413) * _206.w;
                _543 = saturate(_213 / (FogParamsHeightFogTransitionFactor * VFogCullingDistance));
                _560 = ((_543 * ((_206.x - _148.x) + ((_529 + (_239 * ((float)((uint)((uint)(FogParamsHeightFogEmissiveColor & 255)))))) * _536))) + _148.x);
                _561 = ((_543 * ((_206.y - _148.y) + ((_530 + (((float)((uint)((uint)(((uint)((uint)(FogParamsHeightFogEmissiveColor)) >> 8) & 255)))) * _239)) * _536))) + _148.y);
                _562 = ((((_206.z - _148.z) + ((_531 + (((float)((uint)((uint)(((uint)((uint)(FogParamsHeightFogEmissiveColor)) >> 16) & 255)))) * _239)) * _536)) * _543) + _148.z);
                _563 = ((_543 * ((_413 * _206.w) - _148.w)) + _148.w);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _560 = _206.x;
          _561 = _206.y;
          _562 = _206.z;
          _563 = _206.w;
        }
      }
      if (!(vpiEnable == 0)) {
        _569 = VolumetricParticleTexture.SampleLevel(BilinearClamp, float2(_115, _116), 0.0f);
        _574 = dot(float3(_560, _561, _562), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) * 0.5f;
        _593 = max(0.0f, ((((_560 - _574) * _569.x) * vpiCompositionRate) + _560));
        _594 = max(0.0f, ((((_561 - _574) * _569.y) * vpiCompositionRate) + _561));
        _595 = max(0.0f, ((((_562 - _574) * _569.z) * vpiCompositionRate) + _562));
        _596 = _563;
      } else {
        _593 = _560;
        _594 = _561;
        _595 = _562;
        _596 = _563;
      }
    } while (false);
  } else {
    _593 = 0.0f;
    _594 = 0.0f;
    _595 = 0.0f;
    _596 = 1.0f;
  }
#if 1
  _593 *= CUSTOM_FOG_BRIGHTNESS;
  _594 *= CUSTOM_FOG_BRIGHTNESS;
  _595 *= CUSTOM_FOG_BRIGHTNESS;
#endif
  if (!((AtmosphereFlags & 2) == 0)) {
    _604 = _71 * 0.0010000000474974513f;
    _605 = _73 * 0.0010000000474974513f;
    _609 = (PlanetRadius + _72) * 0.0010000000474974513f;
    do {
      _733 = 0.0f;
      _734 = 0.0f;
      _735 = 0.0f;
      _736 = 1.0f;
      if ((!(((ReadonlyDepth.Load(int3(int(SV_Position.x), int(SV_Position.y), 0))).x) == 0.0f)) && (!(sqrt(((_605 * _605) + (_604 * _604)) + (_609 * _609)) >= (OuterAtmosphereRadius * 0.0010000000474974513f)))) {
        _627 = _71 - CameraPosition.x;
        _628 = _72 - CameraPosition.y;
        _629 = _73 - CameraPosition.z;
        _635 = sqrt(((_627 * _627) + (_628 * _628)) + (_629 * _629));
        _663 = mad(_73, (viewProjMat[2].w), mad(_72, (viewProjMat[1].w), ((viewProjMat[0].w) * _71))) + (viewProjMat[3].w);
        _672 = (_635 * 0.0010000000474974513f) - AerialPerspectiveStartDepth;
        if (!(_672 <= 0.0f)) {
          do {
            if (_635 < cameraFarPlane) {
              _693 = ((_635 / cameraFarPlane) * 24.0f);
            } else {
              _693 = ((((_635 - cameraFarPlane) / ((OuterAtmosphereRadius - PlanetRadius) - cameraFarPlane)) * 8.0f) + 24.0f);
            }
            do {
              _699 = 1.0f;
              _700 = _693;
              if (_693 < 0.5f) {
                _699 = saturate(_693 * 2.0f);
                _700 = 0.5f;
              }
              _701 = _700 * 0.03125f;
              do {
                if (!(!(_701 <= 0.5625f))) {
                  _709 = sqrt(_701);
                } else {
                  _709 = ((_700 * 0.01785714365541935f) + 0.4285714030265808f);
                }
                _710 = _699 * saturate(AtmosphereLerpWeight * _672);
                _713 = AerialPerspectiveTexture.SampleLevel(BilinearClamp, float3(((((mad(_73, (viewProjMat[2].x), mad(_72, (viewProjMat[1].x), ((viewProjMat[0].x) * _71))) + (viewProjMat[3].x)) / _663) * 0.5f) + 0.5f), (0.5f - (((mad(_73, (viewProjMat[2].y), mad(_72, (viewProjMat[1].y), ((viewProjMat[0].y) * _71))) + (viewProjMat[3].y)) / _663) * 0.5f)), _709), 0.0f);
                _723 = _710 * AerialPerspectiveIntensity;
                _733 = ((_713.x * _723) * SunColor.x);
                _734 = ((_713.y * _723) * SunColor.y);
                _735 = ((_713.z * _723) * SunColor.z);
                _736 = saturate(1.0f - (_713.w * _710));
              } while (false);
            } while (false);
          } while (false);
        } else {
          _733 = 0.0f;
          _734 = 0.0f;
          _735 = 0.0f;
          _736 = 1.0f;
        }
      }
      _745 = ((_733 * _596) + _593);
      _746 = ((_734 * _596) + _594);
      _747 = ((_735 * _596) + _595);
      _748 = (_736 * _596);
    } while (false);
  } else {
    _745 = _593;
    _746 = _594;
    _747 = _595;
    _748 = _596;
  }
  SV_Target.x = (rangeCompress * _745);
  SV_Target.y = (rangeCompress * _746);
  SV_Target.z = (rangeCompress * _747);
  SV_Target.w = _748;

  return SV_Target;
}
