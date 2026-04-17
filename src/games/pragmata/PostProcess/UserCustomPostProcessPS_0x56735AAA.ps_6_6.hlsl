#define TONEMAP_PARAM_REGISTER b2
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
  uint blueNoiseJitterIndex : packoffset(c038.z);
  float tessellationParam : packoffset(c038.w);
  uint sceneInfoAdditionalFlags : packoffset(c039.x);
};

cbuffer CameraKerare : register(b1) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

// cbuffer TonemapParam : register(b2) {
//   float contrast : packoffset(c000.x);
//   float linearBegin : packoffset(c000.y);
//   float linearLength : packoffset(c000.z);
//   float toe : packoffset(c000.w);
//   float maxNit : packoffset(c001.x);
//   float linearStart : packoffset(c001.y);
//   float displayMaxNitSubContrastFactor : packoffset(c001.z);
//   float contrastFactor : packoffset(c001.w);
//   float mulLinearStartContrastFactor : packoffset(c002.x);
//   float invLinearBegin : packoffset(c002.y);
//   float madLinearStartContrastFactor : packoffset(c002.z);
//   float tonemapParam_isHDRMode : packoffset(c002.w);
//   float useDynamicRangeConversion : packoffset(c003.x);
//   float useHuePreserve : packoffset(c003.y);
//   float exposureScale : packoffset(c003.z);
//   float kneeStartNit : packoffset(c003.w);
//   float knee : packoffset(c004.x);
//   float curve_HDRip : packoffset(c004.y);
//   float curve_k2 : packoffset(c004.z);
//   float curve_k4 : packoffset(c004.w);
//   row_major float4x4 RGBToXYZViaCrosstalkMatrix : packoffset(c005.x);
//   row_major float4x4 XYZToRGBViaCrosstalkMatrix : packoffset(c009.x);
//   float tonemapGraphScale : packoffset(c013.x);
//   float offsetEVCurveStart : packoffset(c013.y);
//   float offsetEVCurveRange : packoffset(c013.z);
// };

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
  }
cbControlRGCParam:
  packoffset(c005.x);
};

cbuffer UserShaderLDRPostProcessSettings : register(b5) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  float _107;
  float _383;
  float _384;
  float _385;
  float _461;
  float _525;
  float _1080;
  float _1081;
  float _1082;
  float _1116;
  float _1117;
  float _1118;
  float _1129;
  float _1130;
  float _1131;
  float _1161;
  float _1177;
  float _1193;
  float _1221;
  float _1222;
  float _1223;
  float _1281;
  float _1302;
  float _1322;
  float _1330;
  float _1331;
  float _1332;
  float _1368;
  float _1378;
  float _1388;
  float _1414;
  float _1428;
  float _1442;
  float _1456;
  float _1465;
  float _1474;
  float _1499;
  float _1513;
  float _1527;
  float _1551;
  float _1561;
  float _1571;
  float _1596;
  float _1610;
  float _1624;
  float _1649;
  float _1659;
  float _1669;
  float _1694;
  float _1708;
  float _1722;
  float _1736;
  float _1737;
  float _1738;
  float _1752;
  float _1753;
  float _1754;
  float _1787;
  float _1788;
  float _1789;
  float _1839;
  float _1851;
  float _1863;
  float _1874;
  float _1875;
  float _1876;
  float _1892;
  float _1901;
  float _1910;
  float _1981;
  float _1982;
  float _1983;
  [branch]
  if (film_aspect == 0.0f) {
    float _68 = Kerare.x / Kerare.w;
    float _69 = Kerare.y / Kerare.w;
    float _70 = Kerare.z / Kerare.w;
    float _74 = abs(rsqrt(dot(float3(_68, _69, _70), float3(_68, _69, _70))) * _70);
    float _79 = _74 * _74;
    _107 = ((_79 * _79) * (1.0f - saturate((_74 * kerare_scale) + kerare_offset)));
  } else {
    float _90 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _92 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _94 = sqrt(dot(float2(_92, _90), float2(_92, _90)));
    float _102 = (_94 * _94) + 1.0f;
    _107 = ((1.0f / (_102 * _102)) * (1.0f - saturate(((1.0f / (_94 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _110 = saturate(_107 + kerare_brightness) * Exposure;
  uint _111 = uint(float((uint)(int)(distortionType)));
  bool _116 = (LDRPPSettings_enabled != 0);
  bool _117 = ((cPassEnabled & 1) != 0);
  if (!(_117 && _116)) {
    float4 _127 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    float _134 = min(_127.x, 65000.0f) * _110;
    float _135 = min(_127.y, 65000.0f) * _110;
    float _136 = min(_127.z, 65000.0f) * _110;
    bool _139 = isfinite(max(max(_134, _135), _136));
    _383 = select(_139, _134, 1.0f);
    _384 = select(_139, _135, 1.0f);
    _385 = select(_139, _136, 1.0f);
  } else {
    if (_111 == 0) {
      float _151 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _152 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _153 = dot(float2(_151, _152), float2(_151, _152));
      float _155 = (_153 * fDistortionCoef) + 1.0f;
      float _156 = _151 * fCorrectCoef;
      float _158 = _152 * fCorrectCoef;
      float _160 = (_156 * _155) + 0.5f;
      float _161 = (_158 * _155) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _166 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_160, _161));
        _383 = (_166.x * _110);
        _384 = (_166.y * _110);
        _385 = (_166.z * _110);
      } else {
        float _185 = ((saturate((sqrt((_151 * _151) + (_152 * _152)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _195 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _196 = _185 * 2.0f;
          float _200 = (((_195 * _196) + _153) * fDistortionCoef) + 1.0f;
          float4 _205 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_200 * _156) + 0.5f), ((_200 * _158) + 0.5f)));
          float _211 = ((((_195 + 0.125f) * _196) + _153) * fDistortionCoef) + 1.0f;
          float4 _216 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_211 * _156) + 0.5f), ((_211 * _158) + 0.5f)));
          float _223 = ((((_195 + 0.25f) * _196) + _153) * fDistortionCoef) + 1.0f;
          float4 _228 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_223 * _156) + 0.5f), ((_223 * _158) + 0.5f)));
          float _237 = ((((_195 + 0.375f) * _196) + _153) * fDistortionCoef) + 1.0f;
          float4 _242 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_237 * _156) + 0.5f), ((_237 * _158) + 0.5f)));
          float _251 = ((((_195 + 0.5f) * _196) + _153) * fDistortionCoef) + 1.0f;
          float4 _256 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_251 * _156) + 0.5f), ((_251 * _158) + 0.5f)));
          float _262 = ((((_195 + 0.625f) * _196) + _153) * fDistortionCoef) + 1.0f;
          float4 _267 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_262 * _156) + 0.5f), ((_262 * _158) + 0.5f)));
          float _275 = ((((_195 + 0.75f) * _196) + _153) * fDistortionCoef) + 1.0f;
          float4 _280 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_275 * _156) + 0.5f), ((_275 * _158) + 0.5f)));
          float _295 = ((((_195 + 0.875f) * _196) + _153) * fDistortionCoef) + 1.0f;
          float4 _300 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_295 * _156) + 0.5f), ((_295 * _158) + 0.5f)));
          float _307 = ((((_195 + 1.0f) * _196) + _153) * fDistortionCoef) + 1.0f;
          float4 _312 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_307 * _156) + 0.5f), ((_307 * _158) + 0.5f)));
          float _315 = _110 * 0.3199999928474426f;
          _383 = ((((_216.x + _205.x) + (_228.x * 0.75f)) + (_242.x * 0.375f)) * _315);
          _384 = ((_110 * 0.3636363744735718f) * ((((_267.y + _242.y) * 0.625f) + _256.y) + ((_280.y + _228.y) * 0.25f)));
          _385 = (((((_280.z * 0.75f) + (_267.z * 0.375f)) + _300.z) + _312.z) * _315);
        } else {
          float _321 = _185 + _153;
          float _323 = (_321 * fDistortionCoef) + 1.0f;
          float _330 = ((_321 + _185) * fDistortionCoef) + 1.0f;
          float4 _335 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_160, _161));
          float4 _338 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_323 * _156) + 0.5f), ((_323 * _158) + 0.5f)));
          float4 _341 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_330 * _156) + 0.5f), ((_330 * _158) + 0.5f)));
          _383 = (_335.x * _110);
          _384 = (_338.y * _110);
          _385 = (_341.z * _110);
        }
      }
    } else {
      if (_111 == 1) {
        float _354 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _358 = sqrt((_354 * _354) + 1.0f);
        float _359 = 1.0f / _358;
        float _367 = ((_358 * fOptimizedParam.z) * (_359 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _375 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_367 * _354) + 0.5f), (((_367 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_359 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _383 = (_375.x * _110);
        _384 = (_375.y * _110);
        _385 = (_375.z * _110);
      } else {
        _383 = 0.0f;
        _384 = 0.0f;
        _385 = 0.0f;
      }
    }
  }
  [branch]
  if (film_aspect == 0.0f) {
    float _422 = Kerare.x / Kerare.w;
    float _423 = Kerare.y / Kerare.w;
    float _424 = Kerare.z / Kerare.w;
    float _428 = abs(rsqrt(dot(float3(_422, _423, _424), float3(_422, _423, _424))) * _424);
    float _433 = _428 * _428;
    _461 = ((_433 * _433) * (1.0f - saturate((_428 * kerare_scale) + kerare_offset)));
  } else {
    float _444 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _446 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _448 = sqrt(dot(float2(_446, _444), float2(_446, _444)));
    float _456 = (_448 * _448) + 1.0f;
    _461 = ((1.0f / (_456 * _456)) * (1.0f - saturate(((1.0f / (_448 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _464 = saturate(_461 + kerare_brightness) * Exposure;
  if (_116 && (bool)((cPassEnabled & 32) != 0)) {
    float _475 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _479 = ComputeResultSRV[0].computeAlpha;
    float _482 = ((1.0f - _475) + (_479 * _475)) * cbRadialColor.w;
    if (!(_482 == 0.0f)) {
      float _488 = screenInverseSize.x * SV_Position.x;
      float _489 = screenInverseSize.y * SV_Position.y;
      float _491 = _488 + (-0.5f - cbRadialScreenPos.x);
      float _493 = _489 + (-0.5f - cbRadialScreenPos.y);
      float _496 = select((_491 < 0.0f), (1.0f - _488), _488);
      float _499 = select((_493 < 0.0f), (1.0f - _489), _489);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _505 = rsqrt(dot(float2(_491, _493), float2(_491, _493))) * cbRadialSharpRange;
          uint _512 = uint(abs(_505 * _493)) + uint(abs(_505 * _491));
          uint _516 = ((_512 ^ 61) ^ ((uint)(_512) >> 16)) * 9;
          uint _519 = (((uint)(_516) >> 4) ^ _516) * 668265261;
          _525 = (float((uint)((int)(((uint)(_519) >> 15) ^ _519))) * 2.3283064365386963e-10f);
        } else {
          _525 = 1.0f;
        }
        float _529 = sqrt((_491 * _491) + (_493 * _493));
        float _531 = 1.0f / max(1.0f, _529);
        float _532 = _525 * _496;
        float _533 = cbRadialBlurPower * _531;
        float _534 = _533 * -0.0011111111380159855f;
        float _536 = _525 * _499;
        float _540 = ((_534 * _532) + 1.0f) * _491;
        float _541 = ((_534 * _536) + 1.0f) * _493;
        float _543 = _533 * -0.002222222276031971f;
        float _548 = ((_543 * _532) + 1.0f) * _491;
        float _549 = ((_543 * _536) + 1.0f) * _493;
        float _550 = _533 * -0.0033333334140479565f;
        float _555 = ((_550 * _532) + 1.0f) * _491;
        float _556 = ((_550 * _536) + 1.0f) * _493;
        float _557 = _533 * -0.004444444552063942f;
        float _562 = ((_557 * _532) + 1.0f) * _491;
        float _563 = ((_557 * _536) + 1.0f) * _493;
        float _564 = _533 * -0.0055555556900799274f;
        float _569 = ((_564 * _532) + 1.0f) * _491;
        float _570 = ((_564 * _536) + 1.0f) * _493;
        float _571 = _533 * -0.006666666828095913f;
        float _576 = ((_571 * _532) + 1.0f) * _491;
        float _577 = ((_571 * _536) + 1.0f) * _493;
        float _578 = _533 * -0.007777777966111898f;
        float _583 = ((_578 * _532) + 1.0f) * _491;
        float _584 = ((_578 * _536) + 1.0f) * _493;
        float _585 = _533 * -0.008888889104127884f;
        float _590 = ((_585 * _532) + 1.0f) * _491;
        float _591 = ((_585 * _536) + 1.0f) * _493;
        float _594 = _531 * ((cbRadialBlurPower * -0.009999999776482582f) * _525);
        float _599 = ((_594 * _496) + 1.0f) * _491;
        float _600 = ((_594 * _499) + 1.0f) * _493;
        do {
          if (_117 && (bool)(_111 == 0)) {
            float _602 = _540 + cbRadialScreenPos.x;
            float _603 = _541 + cbRadialScreenPos.y;
            float _607 = ((dot(float2(_602, _603), float2(_602, _603)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _613 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_607 * _602) + 0.5f), ((_607 * _603) + 0.5f)), 0.0f);
            float _617 = _548 + cbRadialScreenPos.x;
            float _618 = _549 + cbRadialScreenPos.y;
            float _622 = ((dot(float2(_617, _618), float2(_617, _618)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _627 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_622 * _617) + 0.5f), ((_622 * _618) + 0.5f)), 0.0f);
            float _634 = _555 + cbRadialScreenPos.x;
            float _635 = _556 + cbRadialScreenPos.y;
            float _639 = ((dot(float2(_634, _635), float2(_634, _635)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _644 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_639 * _634) + 0.5f), ((_639 * _635) + 0.5f)), 0.0f);
            float _651 = _562 + cbRadialScreenPos.x;
            float _652 = _563 + cbRadialScreenPos.y;
            float _656 = ((dot(float2(_651, _652), float2(_651, _652)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _661 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_656 * _651) + 0.5f), ((_656 * _652) + 0.5f)), 0.0f);
            float _668 = _569 + cbRadialScreenPos.x;
            float _669 = _570 + cbRadialScreenPos.y;
            float _673 = ((dot(float2(_668, _669), float2(_668, _669)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _678 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_673 * _668) + 0.5f), ((_673 * _669) + 0.5f)), 0.0f);
            float _685 = _576 + cbRadialScreenPos.x;
            float _686 = _577 + cbRadialScreenPos.y;
            float _690 = ((dot(float2(_685, _686), float2(_685, _686)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _695 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_690 * _685) + 0.5f), ((_690 * _686) + 0.5f)), 0.0f);
            float _702 = _583 + cbRadialScreenPos.x;
            float _703 = _584 + cbRadialScreenPos.y;
            float _707 = ((dot(float2(_702, _703), float2(_702, _703)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _712 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_707 * _702) + 0.5f), ((_707 * _703) + 0.5f)), 0.0f);
            float _719 = _590 + cbRadialScreenPos.x;
            float _720 = _591 + cbRadialScreenPos.y;
            float _724 = ((dot(float2(_719, _720), float2(_719, _720)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _729 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_724 * _719) + 0.5f), ((_724 * _720) + 0.5f)), 0.0f);
            float _736 = _599 + cbRadialScreenPos.x;
            float _737 = _600 + cbRadialScreenPos.y;
            float _741 = ((dot(float2(_736, _737), float2(_736, _737)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _746 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_741 * _736) + 0.5f), ((_741 * _737) + 0.5f)), 0.0f);
            _1080 = ((((((((_627.x + _613.x) + _644.x) + _661.x) + _678.x) + _695.x) + _712.x) + _729.x) + _746.x);
            _1081 = ((((((((_627.y + _613.y) + _644.y) + _661.y) + _678.y) + _695.y) + _712.y) + _729.y) + _746.y);
            _1082 = ((((((((_627.z + _613.z) + _644.z) + _661.z) + _678.z) + _695.z) + _712.z) + _729.z) + _746.z);
          } else {
            float _754 = cbRadialScreenPos.x + 0.5f;
            float _755 = _540 + _754;
            float _756 = cbRadialScreenPos.y + 0.5f;
            float _757 = _541 + _756;
            float _758 = _548 + _754;
            float _759 = _549 + _756;
            float _760 = _555 + _754;
            float _761 = _556 + _756;
            float _762 = _562 + _754;
            float _763 = _563 + _756;
            float _764 = _569 + _754;
            float _765 = _570 + _756;
            float _766 = _576 + _754;
            float _767 = _577 + _756;
            float _768 = _583 + _754;
            float _769 = _584 + _756;
            float _770 = _590 + _754;
            float _771 = _591 + _756;
            float _772 = _599 + _754;
            float _773 = _600 + _756;
            if (_117 && (bool)(_111 == 1)) {
              float _777 = (_755 * 2.0f) + -1.0f;
              float _781 = sqrt((_777 * _777) + 1.0f);
              float _782 = 1.0f / _781;
              float _789 = fOptimizedParam.w * 0.5f;
              float _790 = ((_781 * fOptimizedParam.z) * (_782 + fOptimizedParam.x)) * _789;
              float4 _797 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_790 * _777) + 0.5f), (((_790 * ((_757 * 2.0f) + -1.0f)) * (((_782 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _803 = (_758 * 2.0f) + -1.0f;
              float _807 = sqrt((_803 * _803) + 1.0f);
              float _808 = 1.0f / _807;
              float _815 = ((_807 * fOptimizedParam.z) * (_808 + fOptimizedParam.x)) * _789;
              float4 _821 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_815 * _803) + 0.5f), (((_815 * ((_759 * 2.0f) + -1.0f)) * (((_808 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _830 = (_760 * 2.0f) + -1.0f;
              float _834 = sqrt((_830 * _830) + 1.0f);
              float _835 = 1.0f / _834;
              float _842 = ((_834 * fOptimizedParam.z) * (_835 + fOptimizedParam.x)) * _789;
              float4 _848 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_842 * _830) + 0.5f), (((_842 * ((_761 * 2.0f) + -1.0f)) * (((_835 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _857 = (_762 * 2.0f) + -1.0f;
              float _861 = sqrt((_857 * _857) + 1.0f);
              float _862 = 1.0f / _861;
              float _869 = ((_861 * fOptimizedParam.z) * (_862 + fOptimizedParam.x)) * _789;
              float4 _875 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_869 * _857) + 0.5f), (((_869 * ((_763 * 2.0f) + -1.0f)) * (((_862 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _884 = (_764 * 2.0f) + -1.0f;
              float _888 = sqrt((_884 * _884) + 1.0f);
              float _889 = 1.0f / _888;
              float _896 = ((_888 * fOptimizedParam.z) * (_889 + fOptimizedParam.x)) * _789;
              float4 _902 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_896 * _884) + 0.5f), (((_896 * ((_765 * 2.0f) + -1.0f)) * (((_889 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _911 = (_766 * 2.0f) + -1.0f;
              float _915 = sqrt((_911 * _911) + 1.0f);
              float _916 = 1.0f / _915;
              float _923 = ((_915 * fOptimizedParam.z) * (_916 + fOptimizedParam.x)) * _789;
              float4 _929 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_923 * _911) + 0.5f), (((_923 * ((_767 * 2.0f) + -1.0f)) * (((_916 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _938 = (_768 * 2.0f) + -1.0f;
              float _942 = sqrt((_938 * _938) + 1.0f);
              float _943 = 1.0f / _942;
              float _950 = ((_942 * fOptimizedParam.z) * (_943 + fOptimizedParam.x)) * _789;
              float4 _956 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_950 * _938) + 0.5f), (((_950 * ((_769 * 2.0f) + -1.0f)) * (((_943 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _965 = (_770 * 2.0f) + -1.0f;
              float _969 = sqrt((_965 * _965) + 1.0f);
              float _970 = 1.0f / _969;
              float _977 = ((_969 * fOptimizedParam.z) * (_970 + fOptimizedParam.x)) * _789;
              float4 _983 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_977 * _965) + 0.5f), (((_977 * ((_771 * 2.0f) + -1.0f)) * (((_970 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _992 = (_772 * 2.0f) + -1.0f;
              float _996 = sqrt((_992 * _992) + 1.0f);
              float _997 = 1.0f / _996;
              float _1004 = ((_996 * fOptimizedParam.z) * (_997 + fOptimizedParam.x)) * _789;
              float4 _1010 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1004 * _992) + 0.5f), (((_1004 * ((_773 * 2.0f) + -1.0f)) * (((_997 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1080 = ((((((((_821.x + _797.x) + _848.x) + _875.x) + _902.x) + _929.x) + _956.x) + _983.x) + _1010.x);
              _1081 = ((((((((_821.y + _797.y) + _848.y) + _875.y) + _902.y) + _929.y) + _956.y) + _983.y) + _1010.y);
              _1082 = ((((((((_821.z + _797.z) + _848.z) + _875.z) + _902.z) + _929.z) + _956.z) + _983.z) + _1010.z);
            } else {
              float4 _1019 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_755, _757), 0.0f);
              float4 _1023 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_758, _759), 0.0f);
              float4 _1030 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_760, _761), 0.0f);
              float4 _1037 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_762, _763), 0.0f);
              float4 _1044 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_764, _765), 0.0f);
              float4 _1051 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_766, _767), 0.0f);
              float4 _1058 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_768, _769), 0.0f);
              float4 _1065 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_770, _771), 0.0f);
              float4 _1072 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_772, _773), 0.0f);
              _1080 = ((((((((_1023.x + _1019.x) + _1030.x) + _1037.x) + _1044.x) + _1051.x) + _1058.x) + _1065.x) + _1072.x);
              _1081 = ((((((((_1023.y + _1019.y) + _1030.y) + _1037.y) + _1044.y) + _1051.y) + _1058.y) + _1065.y) + _1072.y);
              _1082 = ((((((((_1023.z + _1019.z) + _1030.z) + _1037.z) + _1044.z) + _1051.z) + _1058.z) + _1065.z) + _1072.z);
            }
          }
          float _1092 = (cbRadialColor.z * (_385 + (_464 * _1082))) * 0.10000000149011612f;
          float _1093 = (cbRadialColor.y * (_384 + (_464 * _1081))) * 0.10000000149011612f;
          float _1094 = (cbRadialColor.x * (_383 + (_464 * _1080))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1099 = saturate((_529 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1105 = (((_1099 * _1099) * cbRadialMaskRate.x) * (3.0f - (_1099 * 2.0f))) + cbRadialMaskRate.y;
              _1116 = ((_1105 * (_1094 - _383)) + _383);
              _1117 = ((_1105 * (_1093 - _384)) + _384);
              _1118 = ((_1105 * (_1092 - _385)) + _385);
            } else {
              _1116 = _1094;
              _1117 = _1093;
              _1118 = _1092;
            }
            _1129 = (lerp(_383, _1116, _482));
            _1130 = (lerp(_384, _1117, _482));
            _1131 = (lerp(_385, _1118, _482));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1129 = _383;
      _1130 = _384;
      _1131 = _385;
    }
  } else {
    _1129 = _383;
    _1130 = _384;
    _1131 = _385;
  }
  if (_116 && (bool)((cPassEnabled & 2) != 0)) {
    float _1139 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1141 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1147 = frac(frac((_1141 * 0.005837149918079376f) + (_1139 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1147 < fNoiseDensity) {
        int _1152 = (uint)(uint(_1141 * _1139)) ^ 12345391;
        uint _1153 = _1152 * 3635641;
        _1161 = (float((uint)((int)((((uint)(_1153) >> 26) | ((uint)(_1152 * 232681024))) ^ _1153))) * 2.3283064365386963e-10f);
      } else {
        _1161 = 0.0f;
      }
      float _1163 = frac(_1147 * 757.4846801757812f);
      do {
        if (_1163 < fNoiseDensity) {
          int _1167 = asint(_1163) ^ 12345391;
          uint _1168 = _1167 * 3635641;
          _1177 = ((float((uint)((int)((((uint)(_1168) >> 26) | ((uint)(_1167 * 232681024))) ^ _1168))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1177 = 0.0f;
        }
        float _1179 = frac(_1163 * 757.4846801757812f);
        do {
          if (_1179 < fNoiseDensity) {
            int _1183 = asint(_1179) ^ 12345391;
            uint _1184 = _1183 * 3635641;
            _1193 = ((float((uint)((int)((((uint)(_1184) >> 26) | ((uint)(_1183 * 232681024))) ^ _1184))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1193 = 0.0f;
          }
          float _1194 = _1161 * CUSTOM_NOISE * fNoisePower.x;
          float _1195 = _1193 * CUSTOM_NOISE * fNoisePower.y;
          float _1196 = _1177 * CUSTOM_NOISE * fNoisePower.y;
          float _1210 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1129), saturate(_1130), saturate(_1131)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1221 = ((_1210 * (mad(_1196, 1.4019999504089355f, _1194) - _1129)) + _1129);
          _1222 = ((_1210 * (mad(_1196, -0.7139999866485596f, mad(_1195, -0.3440000116825104f, _1194)) - _1130)) + _1130);
          _1223 = ((_1210 * (mad(_1195, 1.7719999551773071f, _1194) - _1131)) + _1131);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1221 = _1129;
    _1222 = _1130;
    _1223 = _1131;
  }
  float _1238 = mad(_1223, (fOCIOTransformMatrix[2].x), mad(_1222, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1221)));
  float _1241 = mad(_1223, (fOCIOTransformMatrix[2].y), mad(_1222, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1221)));
  float _1244 = mad(_1223, (fOCIOTransformMatrix[2].z), mad(_1222, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1221)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1250 = max(max(_1238, _1241), _1244);
    if (!(_1250 == 0.0f)) {
      float _1256 = abs(_1250);
      float _1257 = (_1250 - _1238) / _1256;
      float _1258 = (_1250 - _1241) / _1256;
      float _1259 = (_1250 - _1244) / _1256;
      do {
        if (!(!(_1257 >= cbControlRGCParam.CyanThreshold))) {
          float _1269 = _1257 - cbControlRGCParam.CyanThreshold;
          _1281 = ((_1269 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1269) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1281 = _1257;
        }
        do {
          if (!(!(_1258 >= cbControlRGCParam.MagentaThreshold))) {
            float _1290 = _1258 - cbControlRGCParam.MagentaThreshold;
            _1302 = ((_1290 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1290) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1302 = _1258;
          }
          do {
            if (!(!(_1259 >= cbControlRGCParam.YellowThreshold))) {
              float _1310 = _1259 - cbControlRGCParam.YellowThreshold;
              _1322 = ((_1310 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1310) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1322 = _1259;
            }
            _1330 = (_1250 - (_1281 * _1256));
            _1331 = (_1250 - (_1302 * _1256));
            _1332 = (_1250 - (_1322 * _1256));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1330 = _1238;
      _1331 = _1241;
      _1332 = _1244;
    }
  } else {
    _1330 = _1238;
    _1331 = _1241;
    _1332 = _1244;
  }
  if (_116 && (bool)((cPassEnabled & 4) != 0)) {
    bool _1359 = !(_1330 <= 0.0078125f);
    do {
      if (!_1359) {
        _1368 = ((_1330 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _1368 = ((log2(_1330) + 9.720000267028809f) * 0.05707762390375137f);
      }
      bool _1369 = !(_1331 <= 0.0078125f);
      do {
        if (!_1369) {
          _1378 = ((_1331 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _1378 = ((log2(_1331) + 9.720000267028809f) * 0.05707762390375137f);
        }
        bool _1379 = !(_1332 <= 0.0078125f);
        do {
          if (!_1379) {
            _1388 = ((_1332 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _1388 = ((log2(_1332) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _1397 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_1368 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1378 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1388 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_1397.x < 0.155251145362854f) {
              _1414 = ((_1397.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((bool)(_1397.x >= 0.155251145362854f) && (bool)(_1397.x < 1.4679962396621704f)) {
                _1414 = exp2((_1397.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _1414 = 65504.0f;
              }
            }
            do {
              if (_1397.y < 0.155251145362854f) {
                _1428 = ((_1397.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((bool)(_1397.y >= 0.155251145362854f) && (bool)(_1397.y < 1.4679962396621704f)) {
                  _1428 = exp2((_1397.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _1428 = 65504.0f;
                }
              }
              do {
                if (_1397.z < 0.155251145362854f) {
                  _1442 = ((_1397.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((bool)(_1397.z >= 0.155251145362854f) && (bool)(_1397.z < 1.4679962396621704f)) {
                    _1442 = exp2((_1397.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _1442 = 65504.0f;
                  }
                }
                float _1443 = max(_1414, 0.0f);
                float _1444 = max(_1428, 0.0f);
                float _1445 = max(_1442, 0.0f);
                do {
                  [branch]
                  if (fTextureBlendRate > 0.0f) {
                    do {
                      if (!_1359) {
                        _1456 = ((_1330 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _1456 = ((log2(_1330) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!_1369) {
                          _1465 = ((_1331 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _1465 = ((log2(_1331) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!_1379) {
                            _1474 = ((_1332 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _1474 = ((log2(_1332) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          float4 _1482 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_1456 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1465 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1474 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                          do {
                            if (_1482.x < 0.155251145362854f) {
                              _1499 = ((_1482.x + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((bool)(_1482.x >= 0.155251145362854f) && (bool)(_1482.x < 1.4679962396621704f)) {
                                _1499 = exp2((_1482.x * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _1499 = 65504.0f;
                              }
                            }
                            do {
                              if (_1482.y < 0.155251145362854f) {
                                _1513 = ((_1482.y + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_1482.y >= 0.155251145362854f) && (bool)(_1482.y < 1.4679962396621704f)) {
                                  _1513 = exp2((_1482.y * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _1513 = 65504.0f;
                                }
                              }
                              do {
                                if (_1482.z < 0.155251145362854f) {
                                  _1527 = ((_1482.z + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((bool)(_1482.z >= 0.155251145362854f) && (bool)(_1482.z < 1.4679962396621704f)) {
                                    _1527 = exp2((_1482.z * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _1527 = 65504.0f;
                                  }
                                }
                                float _1537 = ((max(_1499, 0.0f) - _1443) * fTextureBlendRate) + _1443;
                                float _1538 = ((max(_1513, 0.0f) - _1444) * fTextureBlendRate) + _1444;
                                float _1539 = ((max(_1527, 0.0f) - _1445) * fTextureBlendRate) + _1445;
                                if (fTextureBlendRate2 > 0.0f) {
                                  do {
                                    if (!(!(_1537 <= 0.0078125f))) {
                                      _1551 = ((_1537 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _1551 = ((log2(_1537) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_1538 <= 0.0078125f))) {
                                        _1561 = ((_1538 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _1561 = ((log2(_1538) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_1539 <= 0.0078125f))) {
                                          _1571 = ((_1539 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _1571 = ((log2(_1539) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        float4 _1579 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_1551 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1561 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1571 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                                        do {
                                          if (_1579.x < 0.155251145362854f) {
                                            _1596 = ((_1579.x + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            if ((bool)(_1579.x >= 0.155251145362854f) && (bool)(_1579.x < 1.4679962396621704f)) {
                                              _1596 = exp2((_1579.x * 17.520000457763672f) + -9.720000267028809f);
                                            } else {
                                              _1596 = 65504.0f;
                                            }
                                          }
                                          do {
                                            if (_1579.y < 0.155251145362854f) {
                                              _1610 = ((_1579.y + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              if ((bool)(_1579.y >= 0.155251145362854f) && (bool)(_1579.y < 1.4679962396621704f)) {
                                                _1610 = exp2((_1579.y * 17.520000457763672f) + -9.720000267028809f);
                                              } else {
                                                _1610 = 65504.0f;
                                              }
                                            }
                                            do {
                                              if (_1579.z < 0.155251145362854f) {
                                                _1624 = ((_1579.z + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                if ((bool)(_1579.z >= 0.155251145362854f) && (bool)(_1579.z < 1.4679962396621704f)) {
                                                  _1624 = exp2((_1579.z * 17.520000457763672f) + -9.720000267028809f);
                                                } else {
                                                  _1624 = 65504.0f;
                                                }
                                              }
                                              _1736 = (((max(_1596, 0.0f) - _1537) * fTextureBlendRate2) + _1537);
                                              _1737 = (((max(_1610, 0.0f) - _1538) * fTextureBlendRate2) + _1538);
                                              _1738 = (((max(_1624, 0.0f) - _1539) * fTextureBlendRate2) + _1539);
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _1736 = _1537;
                                  _1737 = _1538;
                                  _1738 = _1539;
                                }
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } else {
                    if (fTextureBlendRate2 > 0.0f) {
                      do {
                        if (!(!(_1443 <= 0.0078125f))) {
                          _1649 = ((_1443 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _1649 = ((log2(_1443) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_1444 <= 0.0078125f))) {
                            _1659 = ((_1444 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _1659 = ((log2(_1444) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_1445 <= 0.0078125f))) {
                              _1669 = ((_1445 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _1669 = ((log2(_1445) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            float4 _1677 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_1649 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1659 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1669 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                            do {
                              if (_1677.x < 0.155251145362854f) {
                                _1694 = ((_1677.x + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((bool)(_1677.x >= 0.155251145362854f) && (bool)(_1677.x < 1.4679962396621704f)) {
                                  _1694 = exp2((_1677.x * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _1694 = 65504.0f;
                                }
                              }
                              do {
                                if (_1677.y < 0.155251145362854f) {
                                  _1708 = ((_1677.y + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((bool)(_1677.y >= 0.155251145362854f) && (bool)(_1677.y < 1.4679962396621704f)) {
                                    _1708 = exp2((_1677.y * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _1708 = 65504.0f;
                                  }
                                }
                                do {
                                  if (_1677.z < 0.155251145362854f) {
                                    _1722 = ((_1677.z + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    if ((bool)(_1677.z >= 0.155251145362854f) && (bool)(_1677.z < 1.4679962396621704f)) {
                                      _1722 = exp2((_1677.z * 17.520000457763672f) + -9.720000267028809f);
                                    } else {
                                      _1722 = 65504.0f;
                                    }
                                  }
                                  _1736 = (((max(_1694, 0.0f) - _1443) * fTextureBlendRate2) + _1443);
                                  _1737 = (((max(_1708, 0.0f) - _1444) * fTextureBlendRate2) + _1444);
                                  _1738 = (((max(_1722, 0.0f) - _1445) * fTextureBlendRate2) + _1445);
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _1736 = _1443;
                      _1737 = _1444;
                      _1738 = _1445;
                    }
                  }
                  _1752 = (mad(_1738, (fColorMatrix[2].x), mad(_1737, (fColorMatrix[1].x), (_1736 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
                  _1753 = (mad(_1738, (fColorMatrix[2].y), mad(_1737, (fColorMatrix[1].y), (_1736 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
                  _1754 = (mad(_1738, (fColorMatrix[2].z), mad(_1737, (fColorMatrix[1].z), (_1736 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1752 = _1330;
    _1753 = _1331;
    _1754 = _1332;
  }
  if (_116 && (bool)((cPassEnabled & 8) != 0)) {
    _1787 = (((cvdR.x * _1752) + (cvdR.y * _1753)) + (cvdR.z * _1754));
    _1788 = (((cvdG.x * _1752) + (cvdG.y * _1753)) + (cvdG.z * _1754));
    _1789 = (((cvdB.x * _1752) + (cvdB.y * _1753)) + (cvdB.z * _1754));
  } else {
    _1787 = _1752;
    _1788 = _1753;
    _1789 = _1754;
  }
  float _1793 = screenInverseSize.x * SV_Position.x;
  float _1794 = screenInverseSize.y * SV_Position.y;
  float4 _1800 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1793, _1794), 0.0f);
  if (_116 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1814 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1793, _1794), 0.0f);
    float _1820 = ColorParam.x * _1800.x;
    float _1821 = ColorParam.y * _1800.y;
    float _1822 = ColorParam.z * _1800.z;
    float _1827 = (ColorParam.w * _1800.w) * saturate((_1814.x * Levels_Rate) + Levels_Range);
    do {
      if (_1820 < 0.5f) {
        _1839 = ((_1787 * 2.0f) * _1820);
      } else {
        _1839 = (1.0f - (((1.0f - _1787) * 2.0f) * (1.0f - _1820)));
      }
      do {
        if (_1821 < 0.5f) {
          _1851 = ((_1788 * 2.0f) * _1821);
        } else {
          _1851 = (1.0f - (((1.0f - _1788) * 2.0f) * (1.0f - _1821)));
        }
        do {
          if (_1822 < 0.5f) {
            _1863 = ((_1789 * 2.0f) * _1822);
          } else {
            _1863 = (1.0f - (((1.0f - _1789) * 2.0f) * (1.0f - _1822)));
          }
          _1874 = (lerp(_1787, _1839, _1827));
          _1875 = (lerp(_1788, _1851, _1827));
          _1876 = (lerp(_1789, _1863, _1827));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1874 = _1787;
    _1875 = _1788;
    _1876 = _1789;
  }
  if (tonemapParam_isHDRMode == 0.0f) {
    float _1884 = invLinearBegin * _1874;
    do {
      if (!(_1874 >= linearBegin)) {
        _1892 = ((_1884 * _1884) * (3.0f - (_1884 * 2.0f)));
      } else {
        _1892 = 1.0f;
      }
      float _1893 = invLinearBegin * _1875;
      do {
        if (!(_1875 >= linearBegin)) {
          _1901 = ((_1893 * _1893) * (3.0f - (_1893 * 2.0f)));
        } else {
          _1901 = 1.0f;
        }
        float _1902 = invLinearBegin * _1876;
        do {
          if (!(_1876 >= linearBegin)) {
            _1910 = ((_1902 * _1902) * (3.0f - (_1902 * 2.0f)));
          } else {
            _1910 = 1.0f;
          }
          float _1919 = select((_1874 < linearStart), 0.0f, 1.0f);
          float _1920 = select((_1875 < linearStart), 0.0f, 1.0f);
          float _1921 = select((_1876 < linearStart), 0.0f, 1.0f);
          _1981 = (((((1.0f - _1892) * linearBegin) * (pow(_1884, toe))) + ((_1892 - _1919) * ((contrast * _1874) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _1874) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1919));
          _1982 = (((((1.0f - _1901) * linearBegin) * (pow(_1893, toe))) + ((_1901 - _1920) * ((contrast * _1875) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _1875) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1920));
          _1983 = (((((1.0f - _1910) * linearBegin) * (pow(_1902, toe))) + ((_1910 - _1921) * ((contrast * _1876) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _1876) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1921));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1981 = _1874;
    _1982 = _1875;
    _1983 = _1876;
  }
  SV_Target.x = _1981;
  SV_Target.y = _1982;
  SV_Target.z = _1983;
  SV_Target.w = 1.0f;
  return SV_Target;
}

