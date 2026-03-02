#include "./PostProcess.hlsli"

Texture2D<float4> RE_POSTPROCESS_Input0 : register(t0);

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

cbuffer CameraKerare : register(b1) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer LDRPostProcessParam : register(b2) {
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

cbuffer CBControl : register(b3) {
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

cbuffer UserShaderLDRPostProcessSettings : register(b4) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
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
  float _105;
  float _375;
  float _376;
  float _377;
  float _453;
  float _517;
  float _1072;
  float _1073;
  float _1074;
  float _1108;
  float _1109;
  float _1110;
  float _1121;
  float _1122;
  float _1123;
  float _1153;
  float _1169;
  float _1185;
  float _1213;
  float _1214;
  float _1215;
  float _1273;
  float _1294;
  float _1314;
  float _1322;
  float _1323;
  float _1324;
  float _1535;
  float _1536;
  float _1537;
  float _1551;
  float _1552;
  float _1553;
  float _1586;
  float _1587;
  float _1588;
  float _1638;
  float _1650;
  float _1662;
  float _1673;
  float _1674;
  float _1675;
  [branch]
  if (film_aspect == 0.0f) {
    float _66 = Kerare.x / Kerare.w;
    float _67 = Kerare.y / Kerare.w;
    float _68 = Kerare.z / Kerare.w;
    float _72 = abs(rsqrt(dot(float3(_66, _67, _68), float3(_66, _67, _68))) * _68);
    float _77 = _72 * _72;
    _105 = ((_77 * _77) * (1.0f - saturate((_72 * kerare_scale) + kerare_offset)));
  } else {
    float _88 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _90 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _92 = sqrt(dot(float2(_90, _88), float2(_90, _88)));
    float _100 = (_92 * _92) + 1.0f;
    _105 = ((1.0f / (_100 * _100)) * (1.0f - saturate(((1.0f / (_92 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _108 = saturate(_105 + kerare_brightness) * Exposure;
  uint _109 = uint(float((uint)(int)(distortionType)));
  bool _114 = (LDRPPSettings_enabled != 0);
  bool _115 = ((cPassEnabled & 1) != 0);
  if (!(_115 && _114)) {
    float4 _125 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    _375 = (min(_125.x, 65000.0f) * _108);
    _376 = (min(_125.y, 65000.0f) * _108);
    _377 = (min(_125.z, 65000.0f) * _108);
  } else {
    if (_109 == 0) {
      float _143 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _144 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _145 = dot(float2(_143, _144), float2(_143, _144));
      float _147 = (_145 * fDistortionCoef) + 1.0f;
      float _148 = _143 * fCorrectCoef;
      float _150 = _144 * fCorrectCoef;
      float _152 = (_148 * _147) + 0.5f;
      float _153 = (_150 * _147) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _158 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(_152, _153));
        _375 = (_158.x * _108);
        _376 = (_158.y * _108);
        _377 = (_158.z * _108);
      } else {
        float _177 = ((saturate((sqrt((_143 * _143) + (_144 * _144)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _187 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _188 = _177 * 2.0f;
          float _192 = (((_187 * _188) + _145) * fDistortionCoef) + 1.0f;
          float4 _197 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_192 * _148) + 0.5f), ((_192 * _150) + 0.5f)));
          float _203 = ((((_187 + 0.125f) * _188) + _145) * fDistortionCoef) + 1.0f;
          float4 _208 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_203 * _148) + 0.5f), ((_203 * _150) + 0.5f)));
          float _215 = ((((_187 + 0.25f) * _188) + _145) * fDistortionCoef) + 1.0f;
          float4 _220 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_215 * _148) + 0.5f), ((_215 * _150) + 0.5f)));
          float _229 = ((((_187 + 0.375f) * _188) + _145) * fDistortionCoef) + 1.0f;
          float4 _234 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_229 * _148) + 0.5f), ((_229 * _150) + 0.5f)));
          float _243 = ((((_187 + 0.5f) * _188) + _145) * fDistortionCoef) + 1.0f;
          float4 _248 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_243 * _148) + 0.5f), ((_243 * _150) + 0.5f)));
          float _254 = ((((_187 + 0.625f) * _188) + _145) * fDistortionCoef) + 1.0f;
          float4 _259 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_254 * _148) + 0.5f), ((_254 * _150) + 0.5f)));
          float _267 = ((((_187 + 0.75f) * _188) + _145) * fDistortionCoef) + 1.0f;
          float4 _272 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_267 * _148) + 0.5f), ((_267 * _150) + 0.5f)));
          float _287 = ((((_187 + 0.875f) * _188) + _145) * fDistortionCoef) + 1.0f;
          float4 _292 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_287 * _148) + 0.5f), ((_287 * _150) + 0.5f)));
          float _299 = ((((_187 + 1.0f) * _188) + _145) * fDistortionCoef) + 1.0f;
          float4 _304 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_299 * _148) + 0.5f), ((_299 * _150) + 0.5f)));
          float _307 = _108 * 0.3199999928474426f;
          _375 = ((((_208.x + _197.x) + (_220.x * 0.75f)) + (_234.x * 0.375f)) * _307);
          _376 = ((_108 * 0.3636363744735718f) * ((((_259.y + _234.y) * 0.625f) + _248.y) + ((_272.y + _220.y) * 0.25f)));
          _377 = (((((_272.z * 0.75f) + (_259.z * 0.375f)) + _292.z) + _304.z) * _307);
        } else {
          float _313 = _177 + _145;
          float _315 = (_313 * fDistortionCoef) + 1.0f;
          float _322 = ((_313 + _177) * fDistortionCoef) + 1.0f;
          float4 _327 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(_152, _153));
          float4 _330 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_315 * _148) + 0.5f), ((_315 * _150) + 0.5f)));
          float4 _333 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_322 * _148) + 0.5f), ((_322 * _150) + 0.5f)));
          _375 = (_327.x * _108);
          _376 = (_330.y * _108);
          _377 = (_333.z * _108);
        }
      }
    } else {
      if (_109 == 1) {
        float _346 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _350 = sqrt((_346 * _346) + 1.0f);
        float _351 = 1.0f / _350;
        float _359 = ((_350 * fOptimizedParam.z) * (_351 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _367 = RE_POSTPROCESS_Input0.Sample(BilinearBorder, float2(((_359 * _346) + 0.5f), (((_359 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_351 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _375 = (_367.x * _108);
        _376 = (_367.y * _108);
        _377 = (_367.z * _108);
      } else {
        _375 = 0.0f;
        _376 = 0.0f;
        _377 = 0.0f;
      }
    }
  }
  [branch]
  if (film_aspect == 0.0f) {
    float _414 = Kerare.x / Kerare.w;
    float _415 = Kerare.y / Kerare.w;
    float _416 = Kerare.z / Kerare.w;
    float _420 = abs(rsqrt(dot(float3(_414, _415, _416), float3(_414, _415, _416))) * _416);
    float _425 = _420 * _420;
    _453 = ((_425 * _425) * (1.0f - saturate((_420 * kerare_scale) + kerare_offset)));
  } else {
    float _436 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _438 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _440 = sqrt(dot(float2(_438, _436), float2(_438, _436)));
    float _448 = (_440 * _440) + 1.0f;
    _453 = ((1.0f / (_448 * _448)) * (1.0f - saturate(((1.0f / (_440 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _456 = saturate(_453 + kerare_brightness) * Exposure;
  if (_114 && (bool)((cPassEnabled & 32) != 0)) {
    float _467 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _471 = ComputeResultSRV[0].computeAlpha;
    float _474 = ((1.0f - _467) + (_471 * _467)) * cbRadialColor.w;
    if (!(_474 == 0.0f)) {
      float _480 = screenInverseSize.x * SV_Position.x;
      float _481 = screenInverseSize.y * SV_Position.y;
      float _483 = _480 + (-0.5f - cbRadialScreenPos.x);
      float _485 = _481 + (-0.5f - cbRadialScreenPos.y);
      float _488 = select((_483 < 0.0f), (1.0f - _480), _480);
      float _491 = select((_485 < 0.0f), (1.0f - _481), _481);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _497 = rsqrt(dot(float2(_483, _485), float2(_483, _485))) * cbRadialSharpRange;
          uint _504 = uint(abs(_497 * _485)) + uint(abs(_497 * _483));
          uint _508 = ((_504 ^ 61) ^ ((uint)(_504) >> 16)) * 9;
          uint _511 = (((uint)(_508) >> 4) ^ _508) * 668265261;
          _517 = (float((uint)((int)(((uint)(_511) >> 15) ^ _511))) * 2.3283064365386963e-10f);
        } else {
          _517 = 1.0f;
        }
        float _521 = sqrt((_483 * _483) + (_485 * _485));
        float _523 = 1.0f / max(1.0f, _521);
        float _524 = _517 * _488;
        float _525 = cbRadialBlurPower * _523;
        float _526 = _525 * -0.0011111111380159855f;
        float _528 = _517 * _491;
        float _532 = ((_526 * _524) + 1.0f) * _483;
        float _533 = ((_526 * _528) + 1.0f) * _485;
        float _535 = _525 * -0.002222222276031971f;
        float _540 = ((_535 * _524) + 1.0f) * _483;
        float _541 = ((_535 * _528) + 1.0f) * _485;
        float _542 = _525 * -0.0033333334140479565f;
        float _547 = ((_542 * _524) + 1.0f) * _483;
        float _548 = ((_542 * _528) + 1.0f) * _485;
        float _549 = _525 * -0.004444444552063942f;
        float _554 = ((_549 * _524) + 1.0f) * _483;
        float _555 = ((_549 * _528) + 1.0f) * _485;
        float _556 = _525 * -0.0055555556900799274f;
        float _561 = ((_556 * _524) + 1.0f) * _483;
        float _562 = ((_556 * _528) + 1.0f) * _485;
        float _563 = _525 * -0.006666666828095913f;
        float _568 = ((_563 * _524) + 1.0f) * _483;
        float _569 = ((_563 * _528) + 1.0f) * _485;
        float _570 = _525 * -0.007777777966111898f;
        float _575 = ((_570 * _524) + 1.0f) * _483;
        float _576 = ((_570 * _528) + 1.0f) * _485;
        float _577 = _525 * -0.008888889104127884f;
        float _582 = ((_577 * _524) + 1.0f) * _483;
        float _583 = ((_577 * _528) + 1.0f) * _485;
        float _586 = _523 * ((cbRadialBlurPower * -0.009999999776482582f) * _517);
        float _591 = ((_586 * _488) + 1.0f) * _483;
        float _592 = ((_586 * _491) + 1.0f) * _485;
        do {
          if (_115 && (bool)(_109 == 0)) {
            float _594 = _532 + cbRadialScreenPos.x;
            float _595 = _533 + cbRadialScreenPos.y;
            float _599 = ((dot(float2(_594, _595), float2(_594, _595)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _605 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_599 * _594) + 0.5f), ((_599 * _595) + 0.5f)), 0.0f);
            float _609 = _540 + cbRadialScreenPos.x;
            float _610 = _541 + cbRadialScreenPos.y;
            float _614 = ((dot(float2(_609, _610), float2(_609, _610)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _619 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_614 * _609) + 0.5f), ((_614 * _610) + 0.5f)), 0.0f);
            float _626 = _547 + cbRadialScreenPos.x;
            float _627 = _548 + cbRadialScreenPos.y;
            float _631 = ((dot(float2(_626, _627), float2(_626, _627)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _636 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_631 * _626) + 0.5f), ((_631 * _627) + 0.5f)), 0.0f);
            float _643 = _554 + cbRadialScreenPos.x;
            float _644 = _555 + cbRadialScreenPos.y;
            float _648 = ((dot(float2(_643, _644), float2(_643, _644)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _653 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_648 * _643) + 0.5f), ((_648 * _644) + 0.5f)), 0.0f);
            float _660 = _561 + cbRadialScreenPos.x;
            float _661 = _562 + cbRadialScreenPos.y;
            float _665 = ((dot(float2(_660, _661), float2(_660, _661)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _670 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_665 * _660) + 0.5f), ((_665 * _661) + 0.5f)), 0.0f);
            float _677 = _568 + cbRadialScreenPos.x;
            float _678 = _569 + cbRadialScreenPos.y;
            float _682 = ((dot(float2(_677, _678), float2(_677, _678)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _687 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_682 * _677) + 0.5f), ((_682 * _678) + 0.5f)), 0.0f);
            float _694 = _575 + cbRadialScreenPos.x;
            float _695 = _576 + cbRadialScreenPos.y;
            float _699 = ((dot(float2(_694, _695), float2(_694, _695)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _704 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_699 * _694) + 0.5f), ((_699 * _695) + 0.5f)), 0.0f);
            float _711 = _582 + cbRadialScreenPos.x;
            float _712 = _583 + cbRadialScreenPos.y;
            float _716 = ((dot(float2(_711, _712), float2(_711, _712)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _721 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_716 * _711) + 0.5f), ((_716 * _712) + 0.5f)), 0.0f);
            float _728 = _591 + cbRadialScreenPos.x;
            float _729 = _592 + cbRadialScreenPos.y;
            float _733 = ((dot(float2(_728, _729), float2(_728, _729)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _738 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_733 * _728) + 0.5f), ((_733 * _729) + 0.5f)), 0.0f);
            _1072 = ((((((((_619.x + _605.x) + _636.x) + _653.x) + _670.x) + _687.x) + _704.x) + _721.x) + _738.x);
            _1073 = ((((((((_619.y + _605.y) + _636.y) + _653.y) + _670.y) + _687.y) + _704.y) + _721.y) + _738.y);
            _1074 = ((((((((_619.z + _605.z) + _636.z) + _653.z) + _670.z) + _687.z) + _704.z) + _721.z) + _738.z);
          } else {
            float _746 = cbRadialScreenPos.x + 0.5f;
            float _747 = _532 + _746;
            float _748 = cbRadialScreenPos.y + 0.5f;
            float _749 = _533 + _748;
            float _750 = _540 + _746;
            float _751 = _541 + _748;
            float _752 = _547 + _746;
            float _753 = _548 + _748;
            float _754 = _554 + _746;
            float _755 = _555 + _748;
            float _756 = _561 + _746;
            float _757 = _562 + _748;
            float _758 = _568 + _746;
            float _759 = _569 + _748;
            float _760 = _575 + _746;
            float _761 = _576 + _748;
            float _762 = _582 + _746;
            float _763 = _583 + _748;
            float _764 = _591 + _746;
            float _765 = _592 + _748;
            if (_115 && (bool)(_109 == 1)) {
              float _769 = (_747 * 2.0f) + -1.0f;
              float _773 = sqrt((_769 * _769) + 1.0f);
              float _774 = 1.0f / _773;
              float _781 = fOptimizedParam.w * 0.5f;
              float _782 = ((_773 * fOptimizedParam.z) * (_774 + fOptimizedParam.x)) * _781;
              float4 _789 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_782 * _769) + 0.5f), (((_782 * ((_749 * 2.0f) + -1.0f)) * (((_774 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _795 = (_750 * 2.0f) + -1.0f;
              float _799 = sqrt((_795 * _795) + 1.0f);
              float _800 = 1.0f / _799;
              float _807 = ((_799 * fOptimizedParam.z) * (_800 + fOptimizedParam.x)) * _781;
              float4 _813 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_807 * _795) + 0.5f), (((_807 * ((_751 * 2.0f) + -1.0f)) * (((_800 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _822 = (_752 * 2.0f) + -1.0f;
              float _826 = sqrt((_822 * _822) + 1.0f);
              float _827 = 1.0f / _826;
              float _834 = ((_826 * fOptimizedParam.z) * (_827 + fOptimizedParam.x)) * _781;
              float4 _840 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_834 * _822) + 0.5f), (((_834 * ((_753 * 2.0f) + -1.0f)) * (((_827 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _849 = (_754 * 2.0f) + -1.0f;
              float _853 = sqrt((_849 * _849) + 1.0f);
              float _854 = 1.0f / _853;
              float _861 = ((_853 * fOptimizedParam.z) * (_854 + fOptimizedParam.x)) * _781;
              float4 _867 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_861 * _849) + 0.5f), (((_861 * ((_755 * 2.0f) + -1.0f)) * (((_854 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _876 = (_756 * 2.0f) + -1.0f;
              float _880 = sqrt((_876 * _876) + 1.0f);
              float _881 = 1.0f / _880;
              float _888 = ((_880 * fOptimizedParam.z) * (_881 + fOptimizedParam.x)) * _781;
              float4 _894 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_888 * _876) + 0.5f), (((_888 * ((_757 * 2.0f) + -1.0f)) * (((_881 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _903 = (_758 * 2.0f) + -1.0f;
              float _907 = sqrt((_903 * _903) + 1.0f);
              float _908 = 1.0f / _907;
              float _915 = ((_907 * fOptimizedParam.z) * (_908 + fOptimizedParam.x)) * _781;
              float4 _921 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_915 * _903) + 0.5f), (((_915 * ((_759 * 2.0f) + -1.0f)) * (((_908 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _930 = (_760 * 2.0f) + -1.0f;
              float _934 = sqrt((_930 * _930) + 1.0f);
              float _935 = 1.0f / _934;
              float _942 = ((_934 * fOptimizedParam.z) * (_935 + fOptimizedParam.x)) * _781;
              float4 _948 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_942 * _930) + 0.5f), (((_942 * ((_761 * 2.0f) + -1.0f)) * (((_935 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _957 = (_762 * 2.0f) + -1.0f;
              float _961 = sqrt((_957 * _957) + 1.0f);
              float _962 = 1.0f / _961;
              float _969 = ((_961 * fOptimizedParam.z) * (_962 + fOptimizedParam.x)) * _781;
              float4 _975 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_969 * _957) + 0.5f), (((_969 * ((_763 * 2.0f) + -1.0f)) * (((_962 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _984 = (_764 * 2.0f) + -1.0f;
              float _988 = sqrt((_984 * _984) + 1.0f);
              float _989 = 1.0f / _988;
              float _996 = ((_988 * fOptimizedParam.z) * (_989 + fOptimizedParam.x)) * _781;
              float4 _1002 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_996 * _984) + 0.5f), (((_996 * ((_765 * 2.0f) + -1.0f)) * (((_989 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1072 = ((((((((_813.x + _789.x) + _840.x) + _867.x) + _894.x) + _921.x) + _948.x) + _975.x) + _1002.x);
              _1073 = ((((((((_813.y + _789.y) + _840.y) + _867.y) + _894.y) + _921.y) + _948.y) + _975.y) + _1002.y);
              _1074 = ((((((((_813.z + _789.z) + _840.z) + _867.z) + _894.z) + _921.z) + _948.z) + _975.z) + _1002.z);
            } else {
              float4 _1011 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_747, _749), 0.0f);
              float4 _1015 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_750, _751), 0.0f);
              float4 _1022 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_752, _753), 0.0f);
              float4 _1029 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_754, _755), 0.0f);
              float4 _1036 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_756, _757), 0.0f);
              float4 _1043 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_758, _759), 0.0f);
              float4 _1050 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_760, _761), 0.0f);
              float4 _1057 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_762, _763), 0.0f);
              float4 _1064 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_764, _765), 0.0f);
              _1072 = ((((((((_1015.x + _1011.x) + _1022.x) + _1029.x) + _1036.x) + _1043.x) + _1050.x) + _1057.x) + _1064.x);
              _1073 = ((((((((_1015.y + _1011.y) + _1022.y) + _1029.y) + _1036.y) + _1043.y) + _1050.y) + _1057.y) + _1064.y);
              _1074 = ((((((((_1015.z + _1011.z) + _1022.z) + _1029.z) + _1036.z) + _1043.z) + _1050.z) + _1057.z) + _1064.z);
            }
          }
          float _1084 = (cbRadialColor.z * (_377 + (_456 * _1074))) * 0.10000000149011612f;
          float _1085 = (cbRadialColor.y * (_376 + (_456 * _1073))) * 0.10000000149011612f;
          float _1086 = (cbRadialColor.x * (_375 + (_456 * _1072))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1091 = saturate((_521 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1097 = (((_1091 * _1091) * cbRadialMaskRate.x) * (3.0f - (_1091 * 2.0f))) + cbRadialMaskRate.y;
              _1108 = ((_1097 * (_1086 - _375)) + _375);
              _1109 = ((_1097 * (_1085 - _376)) + _376);
              _1110 = ((_1097 * (_1084 - _377)) + _377);
            } else {
              _1108 = _1086;
              _1109 = _1085;
              _1110 = _1084;
            }
            _1121 = (lerp(_375, _1108, _474));
            _1122 = (lerp(_376, _1109, _474));
            _1123 = (lerp(_377, _1110, _474));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1121 = _375;
      _1122 = _376;
      _1123 = _377;
    }
  } else {
    _1121 = _375;
    _1122 = _376;
    _1123 = _377;
  }
  if (_114 && (bool)((cPassEnabled & 2) != 0)) {
    float _1131 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1133 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1139 = frac(frac((_1133 * 0.005837149918079376f) + (_1131 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1139 < fNoiseDensity) {
        int _1144 = (uint)(uint(_1133 * _1131)) ^ 12345391;
        uint _1145 = _1144 * 3635641;
        _1153 = (float((uint)((int)((((uint)(_1145) >> 26) | ((uint)(_1144 * 232681024))) ^ _1145))) * 2.3283064365386963e-10f);
      } else {
        _1153 = 0.0f;
      }
      float _1155 = frac(_1139 * 757.4846801757812f);
      do {
        if (_1155 < fNoiseDensity) {
          int _1159 = asint(_1155) ^ 12345391;
          uint _1160 = _1159 * 3635641;
          _1169 = ((float((uint)((int)((((uint)(_1160) >> 26) | ((uint)(_1159 * 232681024))) ^ _1160))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1169 = 0.0f;
        }
        float _1171 = frac(_1155 * 757.4846801757812f);
        do {
          if (_1171 < fNoiseDensity) {
            int _1175 = asint(_1171) ^ 12345391;
            uint _1176 = _1175 * 3635641;
            _1185 = ((float((uint)((int)((((uint)(_1176) >> 26) | ((uint)(_1175 * 232681024))) ^ _1176))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1185 = 0.0f;
          }
          float _1186 = _1153 * fNoisePower.x * CUSTOM_NOISE;
          float _1187 = _1185 * fNoisePower.y * CUSTOM_NOISE;
          float _1188 = _1169 * fNoisePower.y * CUSTOM_NOISE;
          float _1202 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1121), saturate(_1122), saturate(_1123)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1213 = ((_1202 * (mad(_1188, 1.4019999504089355f, _1186) - _1121)) + _1121);
          _1214 = ((_1202 * (mad(_1188, -0.7139999866485596f, mad(_1187, -0.3440000116825104f, _1186)) - _1122)) + _1122);
          _1215 = ((_1202 * (mad(_1187, 1.7719999551773071f, _1186) - _1123)) + _1123);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1213 = _1121;
    _1214 = _1122;
    _1215 = _1123;
  }
  float _1230 = mad(_1215, (fOCIOTransformMatrix[2].x), mad(_1214, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1213)));
  float _1233 = mad(_1215, (fOCIOTransformMatrix[2].y), mad(_1214, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1213)));
  float _1236 = mad(_1215, (fOCIOTransformMatrix[2].z), mad(_1214, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1213)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1242 = max(max(_1230, _1233), _1236);
    if (!(_1242 == 0.0f)) {
      float _1248 = abs(_1242);
      float _1249 = (_1242 - _1230) / _1248;
      float _1250 = (_1242 - _1233) / _1248;
      float _1251 = (_1242 - _1236) / _1248;
      do {
        if (!(!(_1249 >= cbControlRGCParam.CyanThreshold))) {
          float _1261 = _1249 - cbControlRGCParam.CyanThreshold;
          _1273 = ((_1261 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1261) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1273 = _1249;
        }
        do {
          if (!(!(_1250 >= cbControlRGCParam.MagentaThreshold))) {
            float _1282 = _1250 - cbControlRGCParam.MagentaThreshold;
            _1294 = ((_1282 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1282) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1294 = _1250;
          }
          do {
            if (!(!(_1251 >= cbControlRGCParam.YellowThreshold))) {
              float _1302 = _1251 - cbControlRGCParam.YellowThreshold;
              _1314 = ((_1302 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1302) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1314 = _1251;
            }
            _1322 = (_1242 - (_1273 * _1248));
            _1323 = (_1242 - (_1294 * _1248));
            _1324 = (_1242 - (_1314 * _1248));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1322 = _1230;
      _1323 = _1233;
      _1324 = _1236;
    }
  } else {
    _1322 = _1230;
    _1323 = _1233;
    _1324 = _1236;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        _114,
        cPassEnabled,
        _1322,
        _1323,
        _1324,
        fTextureBlendRate,
        fTextureBlendRate2,
        fTextureSize,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        fColorMatrix,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp,
        _1551,
        _1552,
        _1553);
  #else
  if (_114 && (bool)((cPassEnabled & 4) != 0)) {
    float _1375 = (((log2(select((_1322 < 3.0517578125e-05f), ((_1322 * 0.5f) + 1.52587890625e-05f), _1322)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1376 = (((log2(select((_1323 < 3.0517578125e-05f), ((_1323 * 0.5f) + 1.52587890625e-05f), _1323)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1377 = (((log2(select((_1324 < 3.0517578125e-05f), ((_1324 * 0.5f) + 1.52587890625e-05f), _1324)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _1380 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1375, _1376, _1377), 0.0f);
    float _1393 = max(exp2((_1380.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1394 = max(exp2((_1380.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1395 = max(exp2((_1380.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _1397 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1400 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1375, _1376, _1377), 0.0f);
        float _1422 = ((max(exp2((_1400.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1393) * fTextureBlendRate) + _1393;
        float _1423 = ((max(exp2((_1400.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1394) * fTextureBlendRate) + _1394;
        float _1424 = ((max(exp2((_1400.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1395) * fTextureBlendRate) + _1395;
        if (_1397) {
          float4 _1454 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1422 < 3.0517578125e-05f), ((_1422 * 0.5f) + 1.52587890625e-05f), _1422)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1423 < 3.0517578125e-05f), ((_1423 * 0.5f) + 1.52587890625e-05f), _1423)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1424 < 3.0517578125e-05f), ((_1424 * 0.5f) + 1.52587890625e-05f), _1424)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1535 = (((max(exp2((_1454.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1422) * fTextureBlendRate2) + _1422);
          _1536 = (((max(exp2((_1454.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1423) * fTextureBlendRate2) + _1423);
          _1537 = (((max(exp2((_1454.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1424) * fTextureBlendRate2) + _1424);
        } else {
          _1535 = _1422;
          _1536 = _1423;
          _1537 = _1424;
        }
      } else {
        if (_1397) {
          float4 _1509 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1393 < 3.0517578125e-05f), ((_1393 * 0.5f) + 1.52587890625e-05f), _1393)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1394 < 3.0517578125e-05f), ((_1394 * 0.5f) + 1.52587890625e-05f), _1394)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1395 < 3.0517578125e-05f), ((_1395 * 0.5f) + 1.52587890625e-05f), _1395)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1535 = (((max(exp2((_1509.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1393) * fTextureBlendRate2) + _1393);
          _1536 = (((max(exp2((_1509.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1394) * fTextureBlendRate2) + _1394);
          _1537 = (((max(exp2((_1509.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1395) * fTextureBlendRate2) + _1395);
        } else {
          _1535 = _1393;
          _1536 = _1394;
          _1537 = _1395;
        }
      }
      _1551 = (mad(_1537, (fColorMatrix[2].x), mad(_1536, (fColorMatrix[1].x), (_1535 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _1552 = (mad(_1537, (fColorMatrix[2].y), mad(_1536, (fColorMatrix[1].y), (_1535 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _1553 = (mad(_1537, (fColorMatrix[2].z), mad(_1536, (fColorMatrix[1].z), (_1535 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _1551 = _1322;
    _1552 = _1323;
    _1553 = _1324;
  }
  #endif
  if (_114 && (bool)((cPassEnabled & 8) != 0)) {
    _1586 = (((cvdR.x * _1551) + (cvdR.y * _1552)) + (cvdR.z * _1553));
    _1587 = (((cvdG.x * _1551) + (cvdG.y * _1552)) + (cvdG.z * _1553));
    _1588 = (((cvdB.x * _1551) + (cvdB.y * _1552)) + (cvdB.z * _1553));
  } else {
    _1586 = _1551;
    _1587 = _1552;
    _1588 = _1553;
  }
  float _1592 = screenInverseSize.x * SV_Position.x;
  float _1593 = screenInverseSize.y * SV_Position.y;
  float4 _1599 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1592, _1593), 0.0f);
  if (_114 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1613 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1592, _1593), 0.0f);
    float _1619 = ColorParam.x * _1599.x;
    float _1620 = ColorParam.y * _1599.y;
    float _1621 = ColorParam.z * _1599.z;
    float _1626 = (ColorParam.w * _1599.w) * saturate((_1613.x * Levels_Rate) + Levels_Range);
    do {
      if (_1619 < 0.5f) {
        _1638 = ((_1586 * 2.0f) * _1619);
      } else {
        _1638 = (1.0f - (((1.0f - _1586) * 2.0f) * (1.0f - _1619)));
      }
      do {
        if (_1620 < 0.5f) {
          _1650 = ((_1587 * 2.0f) * _1620);
        } else {
          _1650 = (1.0f - (((1.0f - _1587) * 2.0f) * (1.0f - _1620)));
        }
        do {
          if (_1621 < 0.5f) {
            _1662 = ((_1588 * 2.0f) * _1621);
          } else {
            _1662 = (1.0f - (((1.0f - _1588) * 2.0f) * (1.0f - _1621)));
          }
          _1673 = (lerp(_1586, _1638, _1626));
          _1674 = (lerp(_1587, _1650, _1626));
          _1675 = (lerp(_1588, _1662, _1626));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1673 = _1586;
    _1674 = _1587;
    _1675 = _1588;
  }
  SV_Target.x = _1673;
  SV_Target.y = _1674;
  SV_Target.z = _1675;
  SV_Target.w = 1.0f;
  return SV_Target;
}
