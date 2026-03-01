#include "./PostProcess.hlsli"

Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

struct RadialBlurComputeResult {
  float computeAlpha;
};
StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t1);

Texture3D<float4> tTextureMap0 : register(t2);

Texture3D<float4> tTextureMap1 : register(t3);

Texture3D<float4> tTextureMap2 : register(t4);

Texture2D<float4> ImagePlameBase : register(t5);

Texture2D<float> ImagePlameAlpha : register(t6);

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

cbuffer EnvironmentInfo : register(b1) {
  uint timeMillisecond : packoffset(c000.x);
  uint frameCount : packoffset(c000.y);
  uint isOddFrame : packoffset(c000.z);
  uint reserveEnvironmentInfo : packoffset(c000.w);
  float breakingPBRSpecularIntensity : packoffset(c001.x);
  float breakingPBRIBLReflectanceBias : packoffset(c001.y);
  float breakingPBRIBLIntensity : packoffset(c001.z);
  float breakingPBRCubemapReflectionScale : packoffset(c001.w);
  uint vrsTier2Enable : packoffset(c002.x);
  uint dynamicTextureTableNullBlackHandle : packoffset(c002.y);
  uint prevTimeMillisecond : packoffset(c002.z);
  uint bindlessMaterialMaxNum : packoffset(c002.w);
  float rtLightRadius : packoffset(c003.x);
  float accurateVelocityDistanceSq : packoffset(c003.y);
  float EnvironmentInfoReserved1 : packoffset(c003.z);
  float EnvironmentInfoReserved2 : packoffset(c003.w);
  float4 userGlobalParams[32] : packoffset(c004.x);
  uint4 dynamicTextureTableHandles[256] : packoffset(c036.x);
  uint4 bakedResourceSharedTablesHandles[32] : packoffset(c292.x);
};

cbuffer CameraKerare : register(b2) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer LDRPostProcessParam : register(b3) {
  float fHazeFilterStart : packoffset(c000.x);
  float fHazeFilterInverseRange : packoffset(c000.y);
  float fHazeFilterHeightStart : packoffset(c000.z);
  float fHazeFilterHeightInverseRange : packoffset(c000.w);
  float4 fHazeFilterUVWOffset : packoffset(c001.x);
  float fHazeFilterScale : packoffset(c002.x);
  float fHazeFilterBorder : packoffset(c002.y);
  float fHazeFilterBorderFade : packoffset(c002.z);
  float fHazeFilterDepthDiffBias : packoffset(c002.w);
  uint fHazeFilterAttribute : packoffset(c003.x);
  uint fHazeFilterReductionResolution : packoffset(c003.y);
  uint fHazeFilterReserved1 : packoffset(c003.z);
  uint fHazeFilterReserved2 : packoffset(c003.w);
  float fDistortionCoef : packoffset(c004.x);
  float fRefraction : packoffset(c004.y);
  float fRefractionCenterRate : packoffset(c004.z);
  float fGradationStartOffset : packoffset(c004.w);
  float fGradationEndOffset : packoffset(c005.x);
  uint aberrationEnable : packoffset(c005.y);
  uint distortionType : packoffset(c005.z);
  float fCorrectCoef : packoffset(c005.w);
  uint aberrationBlurEnable : packoffset(c006.x);
  float fBlurNoisePower : packoffset(c006.y);
  float2 LensDistortion_Reserve : packoffset(c006.z);
  float4 fOptimizedParam : packoffset(c007.x);
  float2 fNoisePower : packoffset(c008.x);
  float2 fNoiseUVOffset : packoffset(c008.z);
  float fNoiseDensity : packoffset(c009.x);
  float fNoiseContrast : packoffset(c009.y);
  float fBlendRate : packoffset(c009.z);
  float fReverseNoiseSize : packoffset(c009.w);
  float fTextureSize : packoffset(c010.x);
  float fTextureBlendRate : packoffset(c010.y);
  float fTextureBlendRate2 : packoffset(c010.z);
  float fTextureInverseSize : packoffset(c010.w);
  float fHalfTextureInverseSize : packoffset(c011.x);
  float fOneMinusTextureInverseSize : packoffset(c011.y);
  float fColorCorrectTextureReserve : packoffset(c011.z);
  float fColorCorrectTextureReserve2 : packoffset(c011.w);
  row_major float4x4 fColorMatrix : packoffset(c012.x);
  float4 cvdR : packoffset(c016.x);
  float4 cvdG : packoffset(c017.x);
  float4 cvdB : packoffset(c018.x);
  float4 ColorParam : packoffset(c019.x);
  float Levels_Rate : packoffset(c020.x);
  float Levels_Range : packoffset(c020.y);
  uint Blend_Type : packoffset(c020.z);
  float ImagePlane_Reserve : packoffset(c020.w);
  float4 cbRadialColor : packoffset(c021.x);
  float2 cbRadialScreenPos : packoffset(c022.x);
  float2 cbRadialMaskSmoothstep : packoffset(c022.z);
  float2 cbRadialMaskRate : packoffset(c023.x);
  float cbRadialBlurPower : packoffset(c023.z);
  float cbRadialSharpRange : packoffset(c023.w);
  uint cbRadialBlurFlags : packoffset(c024.x);
  float cbRadialReserve0 : packoffset(c024.y);
  float cbRadialReserve1 : packoffset(c024.z);
  float cbRadialReserve2 : packoffset(c024.w);
};

cbuffer CBControl : register(b4) {
  float3 CBControl_reserve : packoffset(c000.x);
  uint cPassEnabled : packoffset(c000.w);
  row_major float4x4 fOCIOTransformMatrix : packoffset(c001.x);
  struct RGCParam {
    float CyanLimit;
    float MagentaLimit;
    float YellowLimit;
    float CyanThreshold;
    float MagentaThreshold;
    float YellowThreshold;
    float RollOff;
    uint EnableReferenceGamutCompress;
    float InvCyanSTerm;
    float InvMagentaSTerm;
    float InvYellowSTerm;
    float InvRollOff;
  } cbControlRGCParam : packoffset(c005.x);
};

cbuffer UserShaderLDRPostProcessSettings : register(b5) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
};

cbuffer UserMaterial : register(b6) {
  float4 VAR_Flicker_Color : packoffset(c000.x);
  float VAR_Flicker_Opacity : packoffset(c001.x);
  float VAR_Flicker_Scale : packoffset(c001.y);
  float VAR_Flicker_Speed : packoffset(c001.z);
  float VAR_Flicker_Gradation : packoffset(c001.w);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float _48 = (1.0f / max(VAR_Flicker_Scale, 0.009999999776482582f)) * ((screenInverseSize.y * SV_Position.y) - (frac((float((uint)(int)(timeMillisecond)) * 0.0010000000474974513f) * VAR_Flicker_Speed) * 100.0f));
  float _57 = ((sin(_48 * 8.391579627990723f) + sin(_48 * 5.069784164428711f)) + sin(_48 * 3.7269840240478516f)) * 0.16664999723434448f;
  float _58 = _57 + 0.5f;
  float _136;
  float _406;
  float _407;
  float _408;
  float _484;
  float _548;
  float _1103;
  float _1104;
  float _1105;
  float _1139;
  float _1140;
  float _1141;
  float _1152;
  float _1153;
  float _1154;
  float _1184;
  float _1200;
  float _1216;
  float _1244;
  float _1245;
  float _1246;
  float _1304;
  float _1325;
  float _1345;
  float _1353;
  float _1354;
  float _1355;
  float _1566;
  float _1567;
  float _1568;
  float _1582;
  float _1583;
  float _1584;
  float _1617;
  float _1618;
  float _1619;
  float _1669;
  float _1681;
  float _1693;
  float _1704;
  float _1705;
  float _1706;
  [branch]
  if (film_aspect == 0.0f) {
    float _97 = Kerare.x / Kerare.w;
    float _98 = Kerare.y / Kerare.w;
    float _99 = Kerare.z / Kerare.w;
    float _103 = abs(rsqrt(dot(float3(_97, _98, _99), float3(_97, _98, _99))) * _99);
    float _108 = _103 * _103;
    _136 = ((_108 * _108) * (1.0f - saturate((_103 * kerare_scale) + kerare_offset)));
  } else {
    float _119 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _121 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _123 = sqrt(dot(float2(_121, _119), float2(_121, _119)));
    float _131 = (_123 * _123) + 1.0f;
    _136 = ((1.0f / (_131 * _131)) * (1.0f - saturate(((1.0f / (_123 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _139 = saturate(_136 + kerare_brightness) * Exposure;
  uint _140 = uint(float((uint)(int)(distortionType)));
  bool _145 = (LDRPPSettings_enabled != 0);
  bool _146 = ((cPassEnabled & 1) != 0);
  if (!(_146 && _145)) {
    float4 _156 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    _406 = (min(_156.x, 65000.0f) * _139);
    _407 = (min(_156.y, 65000.0f) * _139);
    _408 = (min(_156.z, 65000.0f) * _139);
  } else {
    if (_140 == 0) {
      float _174 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _175 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _176 = dot(float2(_174, _175), float2(_174, _175));
      float _178 = (_176 * fDistortionCoef) + 1.0f;
      float _179 = _174 * fCorrectCoef;
      float _181 = _175 * fCorrectCoef;
      float _183 = (_179 * _178) + 0.5f;
      float _184 = (_181 * _178) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _189 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_183, _184));
        _406 = (_189.x * _139);
        _407 = (_189.y * _139);
        _408 = (_189.z * _139);
      } else {
        float _208 = ((saturate((sqrt((_174 * _174) + (_175 * _175)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _218 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _219 = _208 * 2.0f;
          float _223 = (((_218 * _219) + _176) * fDistortionCoef) + 1.0f;
          float4 _228 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_223 * _179) + 0.5f), ((_223 * _181) + 0.5f)));
          float _234 = ((((_218 + 0.125f) * _219) + _176) * fDistortionCoef) + 1.0f;
          float4 _239 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_234 * _179) + 0.5f), ((_234 * _181) + 0.5f)));
          float _246 = ((((_218 + 0.25f) * _219) + _176) * fDistortionCoef) + 1.0f;
          float4 _251 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_246 * _179) + 0.5f), ((_246 * _181) + 0.5f)));
          float _260 = ((((_218 + 0.375f) * _219) + _176) * fDistortionCoef) + 1.0f;
          float4 _265 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_260 * _179) + 0.5f), ((_260 * _181) + 0.5f)));
          float _274 = ((((_218 + 0.5f) * _219) + _176) * fDistortionCoef) + 1.0f;
          float4 _279 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_274 * _179) + 0.5f), ((_274 * _181) + 0.5f)));
          float _285 = ((((_218 + 0.625f) * _219) + _176) * fDistortionCoef) + 1.0f;
          float4 _290 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_285 * _179) + 0.5f), ((_285 * _181) + 0.5f)));
          float _298 = ((((_218 + 0.75f) * _219) + _176) * fDistortionCoef) + 1.0f;
          float4 _303 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_298 * _179) + 0.5f), ((_298 * _181) + 0.5f)));
          float _318 = ((((_218 + 0.875f) * _219) + _176) * fDistortionCoef) + 1.0f;
          float4 _323 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_318 * _179) + 0.5f), ((_318 * _181) + 0.5f)));
          float _330 = ((((_218 + 1.0f) * _219) + _176) * fDistortionCoef) + 1.0f;
          float4 _335 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_330 * _179) + 0.5f), ((_330 * _181) + 0.5f)));
          float _338 = _139 * 0.3199999928474426f;
          _406 = ((((_239.x + _228.x) + (_251.x * 0.75f)) + (_265.x * 0.375f)) * _338);
          _407 = ((_139 * 0.3636363744735718f) * ((((_290.y + _265.y) * 0.625f) + _279.y) + ((_303.y + _251.y) * 0.25f)));
          _408 = (((((_303.z * 0.75f) + (_290.z * 0.375f)) + _323.z) + _335.z) * _338);
        } else {
          float _344 = _208 + _176;
          float _346 = (_344 * fDistortionCoef) + 1.0f;
          float _353 = ((_344 + _208) * fDistortionCoef) + 1.0f;
          float4 _358 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_183, _184));
          float4 _361 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_346 * _179) + 0.5f), ((_346 * _181) + 0.5f)));
          float4 _364 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_353 * _179) + 0.5f), ((_353 * _181) + 0.5f)));
          _406 = (_358.x * _139);
          _407 = (_361.y * _139);
          _408 = (_364.z * _139);
        }
      }
    } else {
      if (_140 == 1) {
        float _377 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _381 = sqrt((_377 * _377) + 1.0f);
        float _382 = 1.0f / _381;
        float _390 = ((_381 * fOptimizedParam.z) * (_382 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _398 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_390 * _377) + 0.5f), (((_390 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_382 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _406 = (_398.x * _139);
        _407 = (_398.y * _139);
        _408 = (_398.z * _139);
      } else {
        _406 = 0.0f;
        _407 = 0.0f;
        _408 = 0.0f;
      }
    }
  }
  [branch]
  if (film_aspect == 0.0f) {
    float _445 = Kerare.x / Kerare.w;
    float _446 = Kerare.y / Kerare.w;
    float _447 = Kerare.z / Kerare.w;
    float _451 = abs(rsqrt(dot(float3(_445, _446, _447), float3(_445, _446, _447))) * _447);
    float _456 = _451 * _451;
    _484 = ((_456 * _456) * (1.0f - saturate((_451 * kerare_scale) + kerare_offset)));
  } else {
    float _467 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _469 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _471 = sqrt(dot(float2(_469, _467), float2(_469, _467)));
    float _479 = (_471 * _471) + 1.0f;
    _484 = ((1.0f / (_479 * _479)) * (1.0f - saturate(((1.0f / (_471 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _487 = saturate(_484 + kerare_brightness) * Exposure;
  if (_145 && (bool)((cPassEnabled & 32) != 0)) {
    float _498 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _502 = ComputeResultSRV[0].computeAlpha;
    float _505 = ((1.0f - _498) + (_502 * _498)) * cbRadialColor.w;
    if (!(_505 == 0.0f)) {
      float _511 = screenInverseSize.x * SV_Position.x;
      float _512 = screenInverseSize.y * SV_Position.y;
      float _514 = _511 + (-0.5f - cbRadialScreenPos.x);
      float _516 = _512 + (-0.5f - cbRadialScreenPos.y);
      float _519 = select((_514 < 0.0f), (1.0f - _511), _511);
      float _522 = select((_516 < 0.0f), (1.0f - _512), _512);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _528 = rsqrt(dot(float2(_514, _516), float2(_514, _516))) * cbRadialSharpRange;
          uint _535 = uint(abs(_528 * _516)) + uint(abs(_528 * _514));
          uint _539 = ((_535 ^ 61) ^ ((uint)(_535) >> 16)) * 9;
          uint _542 = (((uint)(_539) >> 4) ^ _539) * 668265261;
          _548 = (float((uint)((int)(((uint)(_542) >> 15) ^ _542))) * 2.3283064365386963e-10f);
        } else {
          _548 = 1.0f;
        }
        float _552 = sqrt((_514 * _514) + (_516 * _516));
        float _554 = 1.0f / max(1.0f, _552);
        float _555 = _548 * _519;
        float _556 = cbRadialBlurPower * _554;
        float _557 = _556 * -0.0011111111380159855f;
        float _559 = _548 * _522;
        float _563 = ((_557 * _555) + 1.0f) * _514;
        float _564 = ((_557 * _559) + 1.0f) * _516;
        float _566 = _556 * -0.002222222276031971f;
        float _571 = ((_566 * _555) + 1.0f) * _514;
        float _572 = ((_566 * _559) + 1.0f) * _516;
        float _573 = _556 * -0.0033333334140479565f;
        float _578 = ((_573 * _555) + 1.0f) * _514;
        float _579 = ((_573 * _559) + 1.0f) * _516;
        float _580 = _556 * -0.004444444552063942f;
        float _585 = ((_580 * _555) + 1.0f) * _514;
        float _586 = ((_580 * _559) + 1.0f) * _516;
        float _587 = _556 * -0.0055555556900799274f;
        float _592 = ((_587 * _555) + 1.0f) * _514;
        float _593 = ((_587 * _559) + 1.0f) * _516;
        float _594 = _556 * -0.006666666828095913f;
        float _599 = ((_594 * _555) + 1.0f) * _514;
        float _600 = ((_594 * _559) + 1.0f) * _516;
        float _601 = _556 * -0.007777777966111898f;
        float _606 = ((_601 * _555) + 1.0f) * _514;
        float _607 = ((_601 * _559) + 1.0f) * _516;
        float _608 = _556 * -0.008888889104127884f;
        float _613 = ((_608 * _555) + 1.0f) * _514;
        float _614 = ((_608 * _559) + 1.0f) * _516;
        float _617 = _554 * ((cbRadialBlurPower * -0.009999999776482582f) * _548);
        float _622 = ((_617 * _519) + 1.0f) * _514;
        float _623 = ((_617 * _522) + 1.0f) * _516;
        do {
          if (_146 && (bool)(_140 == 0)) {
            float _625 = _563 + cbRadialScreenPos.x;
            float _626 = _564 + cbRadialScreenPos.y;
            float _630 = ((dot(float2(_625, _626), float2(_625, _626)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _636 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_630 * _625) + 0.5f), ((_630 * _626) + 0.5f)), 0.0f);
            float _640 = _571 + cbRadialScreenPos.x;
            float _641 = _572 + cbRadialScreenPos.y;
            float _645 = ((dot(float2(_640, _641), float2(_640, _641)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _650 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_645 * _640) + 0.5f), ((_645 * _641) + 0.5f)), 0.0f);
            float _657 = _578 + cbRadialScreenPos.x;
            float _658 = _579 + cbRadialScreenPos.y;
            float _662 = ((dot(float2(_657, _658), float2(_657, _658)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _667 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_662 * _657) + 0.5f), ((_662 * _658) + 0.5f)), 0.0f);
            float _674 = _585 + cbRadialScreenPos.x;
            float _675 = _586 + cbRadialScreenPos.y;
            float _679 = ((dot(float2(_674, _675), float2(_674, _675)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _684 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_679 * _674) + 0.5f), ((_679 * _675) + 0.5f)), 0.0f);
            float _691 = _592 + cbRadialScreenPos.x;
            float _692 = _593 + cbRadialScreenPos.y;
            float _696 = ((dot(float2(_691, _692), float2(_691, _692)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _701 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_696 * _691) + 0.5f), ((_696 * _692) + 0.5f)), 0.0f);
            float _708 = _599 + cbRadialScreenPos.x;
            float _709 = _600 + cbRadialScreenPos.y;
            float _713 = ((dot(float2(_708, _709), float2(_708, _709)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _718 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_713 * _708) + 0.5f), ((_713 * _709) + 0.5f)), 0.0f);
            float _725 = _606 + cbRadialScreenPos.x;
            float _726 = _607 + cbRadialScreenPos.y;
            float _730 = ((dot(float2(_725, _726), float2(_725, _726)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _735 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_730 * _725) + 0.5f), ((_730 * _726) + 0.5f)), 0.0f);
            float _742 = _613 + cbRadialScreenPos.x;
            float _743 = _614 + cbRadialScreenPos.y;
            float _747 = ((dot(float2(_742, _743), float2(_742, _743)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _752 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_747 * _742) + 0.5f), ((_747 * _743) + 0.5f)), 0.0f);
            float _759 = _622 + cbRadialScreenPos.x;
            float _760 = _623 + cbRadialScreenPos.y;
            float _764 = ((dot(float2(_759, _760), float2(_759, _760)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _769 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_764 * _759) + 0.5f), ((_764 * _760) + 0.5f)), 0.0f);
            _1103 = ((((((((_650.x + _636.x) + _667.x) + _684.x) + _701.x) + _718.x) + _735.x) + _752.x) + _769.x);
            _1104 = ((((((((_650.y + _636.y) + _667.y) + _684.y) + _701.y) + _718.y) + _735.y) + _752.y) + _769.y);
            _1105 = ((((((((_650.z + _636.z) + _667.z) + _684.z) + _701.z) + _718.z) + _735.z) + _752.z) + _769.z);
          } else {
            float _777 = cbRadialScreenPos.x + 0.5f;
            float _778 = _563 + _777;
            float _779 = cbRadialScreenPos.y + 0.5f;
            float _780 = _564 + _779;
            float _781 = _571 + _777;
            float _782 = _572 + _779;
            float _783 = _578 + _777;
            float _784 = _579 + _779;
            float _785 = _585 + _777;
            float _786 = _586 + _779;
            float _787 = _592 + _777;
            float _788 = _593 + _779;
            float _789 = _599 + _777;
            float _790 = _600 + _779;
            float _791 = _606 + _777;
            float _792 = _607 + _779;
            float _793 = _613 + _777;
            float _794 = _614 + _779;
            float _795 = _622 + _777;
            float _796 = _623 + _779;
            if (_146 && (bool)(_140 == 1)) {
              float _800 = (_778 * 2.0f) + -1.0f;
              float _804 = sqrt((_800 * _800) + 1.0f);
              float _805 = 1.0f / _804;
              float _812 = fOptimizedParam.w * 0.5f;
              float _813 = ((_804 * fOptimizedParam.z) * (_805 + fOptimizedParam.x)) * _812;
              float4 _820 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_813 * _800) + 0.5f), (((_813 * ((_780 * 2.0f) + -1.0f)) * (((_805 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _826 = (_781 * 2.0f) + -1.0f;
              float _830 = sqrt((_826 * _826) + 1.0f);
              float _831 = 1.0f / _830;
              float _838 = ((_830 * fOptimizedParam.z) * (_831 + fOptimizedParam.x)) * _812;
              float4 _844 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_838 * _826) + 0.5f), (((_838 * ((_782 * 2.0f) + -1.0f)) * (((_831 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _853 = (_783 * 2.0f) + -1.0f;
              float _857 = sqrt((_853 * _853) + 1.0f);
              float _858 = 1.0f / _857;
              float _865 = ((_857 * fOptimizedParam.z) * (_858 + fOptimizedParam.x)) * _812;
              float4 _871 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_865 * _853) + 0.5f), (((_865 * ((_784 * 2.0f) + -1.0f)) * (((_858 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _880 = (_785 * 2.0f) + -1.0f;
              float _884 = sqrt((_880 * _880) + 1.0f);
              float _885 = 1.0f / _884;
              float _892 = ((_884 * fOptimizedParam.z) * (_885 + fOptimizedParam.x)) * _812;
              float4 _898 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_892 * _880) + 0.5f), (((_892 * ((_786 * 2.0f) + -1.0f)) * (((_885 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _907 = (_787 * 2.0f) + -1.0f;
              float _911 = sqrt((_907 * _907) + 1.0f);
              float _912 = 1.0f / _911;
              float _919 = ((_911 * fOptimizedParam.z) * (_912 + fOptimizedParam.x)) * _812;
              float4 _925 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_919 * _907) + 0.5f), (((_919 * ((_788 * 2.0f) + -1.0f)) * (((_912 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _934 = (_789 * 2.0f) + -1.0f;
              float _938 = sqrt((_934 * _934) + 1.0f);
              float _939 = 1.0f / _938;
              float _946 = ((_938 * fOptimizedParam.z) * (_939 + fOptimizedParam.x)) * _812;
              float4 _952 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_946 * _934) + 0.5f), (((_946 * ((_790 * 2.0f) + -1.0f)) * (((_939 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _961 = (_791 * 2.0f) + -1.0f;
              float _965 = sqrt((_961 * _961) + 1.0f);
              float _966 = 1.0f / _965;
              float _973 = ((_965 * fOptimizedParam.z) * (_966 + fOptimizedParam.x)) * _812;
              float4 _979 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_973 * _961) + 0.5f), (((_973 * ((_792 * 2.0f) + -1.0f)) * (((_966 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _988 = (_793 * 2.0f) + -1.0f;
              float _992 = sqrt((_988 * _988) + 1.0f);
              float _993 = 1.0f / _992;
              float _1000 = ((_992 * fOptimizedParam.z) * (_993 + fOptimizedParam.x)) * _812;
              float4 _1006 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1000 * _988) + 0.5f), (((_1000 * ((_794 * 2.0f) + -1.0f)) * (((_993 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1015 = (_795 * 2.0f) + -1.0f;
              float _1019 = sqrt((_1015 * _1015) + 1.0f);
              float _1020 = 1.0f / _1019;
              float _1027 = ((_1019 * fOptimizedParam.z) * (_1020 + fOptimizedParam.x)) * _812;
              float4 _1033 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1027 * _1015) + 0.5f), (((_1027 * ((_796 * 2.0f) + -1.0f)) * (((_1020 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1103 = ((((((((_844.x + _820.x) + _871.x) + _898.x) + _925.x) + _952.x) + _979.x) + _1006.x) + _1033.x);
              _1104 = ((((((((_844.y + _820.y) + _871.y) + _898.y) + _925.y) + _952.y) + _979.y) + _1006.y) + _1033.y);
              _1105 = ((((((((_844.z + _820.z) + _871.z) + _898.z) + _925.z) + _952.z) + _979.z) + _1006.z) + _1033.z);
            } else {
              float4 _1042 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_778, _780), 0.0f);
              float4 _1046 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_781, _782), 0.0f);
              float4 _1053 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_783, _784), 0.0f);
              float4 _1060 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_785, _786), 0.0f);
              float4 _1067 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_787, _788), 0.0f);
              float4 _1074 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_789, _790), 0.0f);
              float4 _1081 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_791, _792), 0.0f);
              float4 _1088 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_793, _794), 0.0f);
              float4 _1095 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_795, _796), 0.0f);
              _1103 = ((((((((_1046.x + _1042.x) + _1053.x) + _1060.x) + _1067.x) + _1074.x) + _1081.x) + _1088.x) + _1095.x);
              _1104 = ((((((((_1046.y + _1042.y) + _1053.y) + _1060.y) + _1067.y) + _1074.y) + _1081.y) + _1088.y) + _1095.y);
              _1105 = ((((((((_1046.z + _1042.z) + _1053.z) + _1060.z) + _1067.z) + _1074.z) + _1081.z) + _1088.z) + _1095.z);
            }
          }
          float _1115 = (cbRadialColor.z * (_408 + (_487 * _1105))) * 0.10000000149011612f;
          float _1116 = (cbRadialColor.y * (_407 + (_487 * _1104))) * 0.10000000149011612f;
          float _1117 = (cbRadialColor.x * (_406 + (_487 * _1103))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1122 = saturate((_552 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1128 = (((_1122 * _1122) * cbRadialMaskRate.x) * (3.0f - (_1122 * 2.0f))) + cbRadialMaskRate.y;
              _1139 = ((_1128 * (_1117 - _406)) + _406);
              _1140 = ((_1128 * (_1116 - _407)) + _407);
              _1141 = ((_1128 * (_1115 - _408)) + _408);
            } else {
              _1139 = _1117;
              _1140 = _1116;
              _1141 = _1115;
            }
            _1152 = (lerp(_406, _1139, _505));
            _1153 = (lerp(_407, _1140, _505));
            _1154 = (lerp(_408, _1141, _505));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1152 = _406;
      _1153 = _407;
      _1154 = _408;
    }
  } else {
    _1152 = _406;
    _1153 = _407;
    _1154 = _408;
  }
  if (_145 && (bool)((cPassEnabled & 2) != 0)) {
    float _1162 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1164 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1170 = frac(frac((_1164 * 0.005837149918079376f) + (_1162 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1170 < fNoiseDensity) {
        int _1175 = (uint)(uint(_1164 * _1162)) ^ 12345391;
        uint _1176 = _1175 * 3635641;
        _1184 = (float((uint)((int)((((uint)(_1176) >> 26) | ((uint)(_1175 * 232681024))) ^ _1176))) * 2.3283064365386963e-10f);
      } else {
        _1184 = 0.0f;
      }
      float _1186 = frac(_1170 * 757.4846801757812f);
      do {
        if (_1186 < fNoiseDensity) {
          int _1190 = asint(_1186) ^ 12345391;
          uint _1191 = _1190 * 3635641;
          _1200 = ((float((uint)((int)((((uint)(_1191) >> 26) | ((uint)(_1190 * 232681024))) ^ _1191))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1200 = 0.0f;
        }
        float _1202 = frac(_1186 * 757.4846801757812f);
        do {
          if (_1202 < fNoiseDensity) {
            int _1206 = asint(_1202) ^ 12345391;
            uint _1207 = _1206 * 3635641;
            _1216 = ((float((uint)((int)((((uint)(_1207) >> 26) | ((uint)(_1206 * 232681024))) ^ _1207))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1216 = 0.0f;
          }
          float _1217 = _1184 * fNoisePower.x * CUSTOM_NOISE;
          float _1218 = _1216 * fNoisePower.y * CUSTOM_NOISE;
          float _1219 = _1200 * fNoisePower.y * CUSTOM_NOISE;
          float _1233 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1152), saturate(_1153), saturate(_1154)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1244 = ((_1233 * (mad(_1219, 1.4019999504089355f, _1217) - _1152)) + _1152);
          _1245 = ((_1233 * (mad(_1219, -0.7139999866485596f, mad(_1218, -0.3440000116825104f, _1217)) - _1153)) + _1153);
          _1246 = ((_1233 * (mad(_1218, 1.7719999551773071f, _1217) - _1154)) + _1154);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1244 = _1152;
    _1245 = _1153;
    _1246 = _1154;
  }
  float _1261 = mad(_1246, (fOCIOTransformMatrix[2].x), mad(_1245, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1244)));
  float _1264 = mad(_1246, (fOCIOTransformMatrix[2].y), mad(_1245, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1244)));
  float _1267 = mad(_1246, (fOCIOTransformMatrix[2].z), mad(_1245, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1244)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1273 = max(max(_1261, _1264), _1267);
    if (!(_1273 == 0.0f)) {
      float _1279 = abs(_1273);
      float _1280 = (_1273 - _1261) / _1279;
      float _1281 = (_1273 - _1264) / _1279;
      float _1282 = (_1273 - _1267) / _1279;
      do {
        if (!(!(_1280 >= cbControlRGCParam.CyanThreshold))) {
          float _1292 = _1280 - cbControlRGCParam.CyanThreshold;
          _1304 = ((_1292 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1292) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1304 = _1280;
        }
        do {
          if (!(!(_1281 >= cbControlRGCParam.MagentaThreshold))) {
            float _1313 = _1281 - cbControlRGCParam.MagentaThreshold;
            _1325 = ((_1313 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1313) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1325 = _1281;
          }
          do {
            if (!(!(_1282 >= cbControlRGCParam.YellowThreshold))) {
              float _1333 = _1282 - cbControlRGCParam.YellowThreshold;
              _1345 = ((_1333 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1333) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1345 = _1282;
            }
            _1353 = (_1273 - (_1304 * _1279));
            _1354 = (_1273 - (_1325 * _1279));
            _1355 = (_1273 - (_1345 * _1279));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1353 = _1261;
      _1354 = _1264;
      _1355 = _1267;
    }
  } else {
    _1353 = _1261;
    _1354 = _1264;
    _1355 = _1267;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        _145,
        cPassEnabled,
        _1353,
        _1354,
        _1355,
        fTextureBlendRate,
        fTextureBlendRate2,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        fColorMatrix,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp,
        _1582,
        _1583,
        _1584);
  #else
  if (_145 && (bool)((cPassEnabled & 4) != 0)) {
    float _1406 = (((log2(select((_1353 < 3.0517578125e-05f), ((_1353 * 0.5f) + 1.52587890625e-05f), _1353)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1407 = (((log2(select((_1354 < 3.0517578125e-05f), ((_1354 * 0.5f) + 1.52587890625e-05f), _1354)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1408 = (((log2(select((_1355 < 3.0517578125e-05f), ((_1355 * 0.5f) + 1.52587890625e-05f), _1355)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _1411 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1406, _1407, _1408), 0.0f);
    float _1424 = max(exp2((_1411.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1425 = max(exp2((_1411.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1426 = max(exp2((_1411.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _1428 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1431 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1406, _1407, _1408), 0.0f);
        float _1453 = ((max(exp2((_1431.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1424) * fTextureBlendRate) + _1424;
        float _1454 = ((max(exp2((_1431.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1425) * fTextureBlendRate) + _1425;
        float _1455 = ((max(exp2((_1431.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1426) * fTextureBlendRate) + _1426;
        if (_1428) {
          float4 _1485 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1453 < 3.0517578125e-05f), ((_1453 * 0.5f) + 1.52587890625e-05f), _1453)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1454 < 3.0517578125e-05f), ((_1454 * 0.5f) + 1.52587890625e-05f), _1454)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1455 < 3.0517578125e-05f), ((_1455 * 0.5f) + 1.52587890625e-05f), _1455)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1566 = (((max(exp2((_1485.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1453) * fTextureBlendRate2) + _1453);
          _1567 = (((max(exp2((_1485.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1454) * fTextureBlendRate2) + _1454);
          _1568 = (((max(exp2((_1485.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1455) * fTextureBlendRate2) + _1455);
        } else {
          _1566 = _1453;
          _1567 = _1454;
          _1568 = _1455;
        }
      } else {
        if (_1428) {
          float4 _1540 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1424 < 3.0517578125e-05f), ((_1424 * 0.5f) + 1.52587890625e-05f), _1424)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1425 < 3.0517578125e-05f), ((_1425 * 0.5f) + 1.52587890625e-05f), _1425)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1426 < 3.0517578125e-05f), ((_1426 * 0.5f) + 1.52587890625e-05f), _1426)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1566 = (((max(exp2((_1540.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1424) * fTextureBlendRate2) + _1424);
          _1567 = (((max(exp2((_1540.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1425) * fTextureBlendRate2) + _1425);
          _1568 = (((max(exp2((_1540.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1426) * fTextureBlendRate2) + _1426);
        } else {
          _1566 = _1424;
          _1567 = _1425;
          _1568 = _1426;
        }
      }
      _1582 = (mad(_1568, (fColorMatrix[2].x), mad(_1567, (fColorMatrix[1].x), (_1566 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _1583 = (mad(_1568, (fColorMatrix[2].y), mad(_1567, (fColorMatrix[1].y), (_1566 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _1584 = (mad(_1568, (fColorMatrix[2].z), mad(_1567, (fColorMatrix[1].z), (_1566 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _1582 = _1353;
    _1583 = _1354;
    _1584 = _1355;
  }
  #endif
  if (_145 && (bool)((cPassEnabled & 8) != 0)) {
    _1617 = (((cvdR.x * _1582) + (cvdR.y * _1583)) + (cvdR.z * _1584));
    _1618 = (((cvdG.x * _1582) + (cvdG.y * _1583)) + (cvdG.z * _1584));
    _1619 = (((cvdB.x * _1582) + (cvdB.y * _1583)) + (cvdB.z * _1584));
  } else {
    _1617 = _1582;
    _1618 = _1583;
    _1619 = _1584;
  }
  float _1623 = screenInverseSize.x * SV_Position.x;
  float _1624 = screenInverseSize.y * SV_Position.y;
  float4 _1630 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1623, _1624), 0.0f);
  if (_145 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1644 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1623, _1624), 0.0f);
    float _1650 = ColorParam.x * _1630.x;
    float _1651 = ColorParam.y * _1630.y;
    float _1652 = ColorParam.z * _1630.z;
    float _1657 = (ColorParam.w * _1630.w) * saturate((_1644.x * Levels_Rate) + Levels_Range);
    do {
      if (_1650 < 0.5f) {
        _1669 = ((_1617 * 2.0f) * _1650);
      } else {
        _1669 = (1.0f - (((1.0f - _1617) * 2.0f) * (1.0f - _1650)));
      }
      do {
        if (_1651 < 0.5f) {
          _1681 = ((_1618 * 2.0f) * _1651);
        } else {
          _1681 = (1.0f - (((1.0f - _1618) * 2.0f) * (1.0f - _1651)));
        }
        do {
          if (_1652 < 0.5f) {
            _1693 = ((_1619 * 2.0f) * _1652);
          } else {
            _1693 = (1.0f - (((1.0f - _1619) * 2.0f) * (1.0f - _1652)));
          }
          _1704 = (lerp(_1617, _1669, _1657));
          _1705 = (lerp(_1618, _1681, _1657));
          _1706 = (lerp(_1619, _1693, _1657));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1704 = _1617;
    _1705 = _1618;
    _1706 = _1619;
  }
  float _1713 = select((VAR_Flicker_Gradation < 0.5f), 0.0f, 1.0f);
  float _1722 = exp2(log2(max(((_1713 * ((0.5f - _57) - _58)) + _58), 9.999999974752427e-07f)) * (1.0f - abs((VAR_Flicker_Gradation * 2.0f) + -0.9960784316062927f)));
  float _1726 = ((1.0f - (_1722 * 2.0f)) * _1713) + _1722;
  float _1731 = VAR_Flicker_Color.x * _1704;
  float _1732 = VAR_Flicker_Color.y * _1705;
  float _1733 = VAR_Flicker_Color.z * _1706;
  SV_Target.x = ((((_1731 - _1704) + ((_1704 - _1731) * _1726)) * VAR_Flicker_Opacity) + _1704);
  SV_Target.y = ((((_1732 - _1705) + ((_1705 - _1732) * _1726)) * VAR_Flicker_Opacity) + _1705);
  SV_Target.z = ((((_1733 - _1706) + (_1726 * (_1706 - _1733))) * VAR_Flicker_Opacity) + _1706);
  SV_Target.w = 1.0f;
  return SV_Target;
}
