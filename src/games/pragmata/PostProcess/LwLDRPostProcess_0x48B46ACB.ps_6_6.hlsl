#include "PostProcess.hlsli"

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
};

struct RadialBlurComputeResult {
  float computeAlpha;
};

Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t1);

Texture3D<float4> tTextureMap0 : register(t2);

Texture3D<float4> tTextureMap1 : register(t3);

Texture3D<float4> tTextureMap2 : register(t4);

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

cbuffer TonemapParam : register(b2) {
  float contrast : packoffset(c000.x);
  float linearBegin : packoffset(c000.y);
  float linearLength : packoffset(c000.z);
  float toe : packoffset(c000.w);
  float maxNit : packoffset(c001.x);
  float linearStart : packoffset(c001.y);
  float displayMaxNitSubContrastFactor : packoffset(c001.z);
  float contrastFactor : packoffset(c001.w);
  float mulLinearStartContrastFactor : packoffset(c002.x);
  float invLinearBegin : packoffset(c002.y);
  float madLinearStartContrastFactor : packoffset(c002.z);
  float tonemapParam_isHDRMode : packoffset(c002.w);
  float useDynamicRangeConversion : packoffset(c003.x);
  float useHuePreserve : packoffset(c003.y);
  float exposureScale : packoffset(c003.z);
  float kneeStartNit : packoffset(c003.w);
  float knee : packoffset(c004.x);
  float curve_HDRip : packoffset(c004.y);
  float curve_k2 : packoffset(c004.z);
  float curve_k4 : packoffset(c004.w);
  row_major float4x4 RGBToXYZViaCrosstalkMatrix : packoffset(c005.x);
  row_major float4x4 XYZToRGBViaCrosstalkMatrix : packoffset(c009.x);
  float tonemapGraphScale : packoffset(c013.x);
  float offsetEVCurveStart : packoffset(c013.y);
  float offsetEVCurveRange : packoffset(c013.z);
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
  RGCParam cbControlRGCParam : packoffset(c005.x);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure) : SV_Target {
  float4 SV_Target;
  float _71;
  float _310;
  float _311;
  float _312;
  float _323;
  float _324;
  float _325;
  float _383;
  float _404;
  float _424;
  float _432;
  float _433;
  float _434;
  float _466;
  float _476;
  float _486;
  float _512;
  float _526;
  float _540;
  float _554;
  float _563;
  float _572;
  float _597;
  float _611;
  float _625;
  float _649;
  float _659;
  float _669;
  float _694;
  float _708;
  float _722;
  float _747;
  float _757;
  float _767;
  float _792;
  float _806;
  float _820;
  float _834;
  float _835;
  float _836;
  float _873;
  float _882;
  float _891;
  float _962;
  float _963;
  float _964;
  float _32;
  float _33;
  float _34;
  float _38;
  float _43;
  float _54;
  float _56;
  float _58;
  float _66;
  float _74;
  float4 _82;
  float _86;
  float _87;
  float _88;
  float _103;
  float _107;
  float _110;
  float _120;
  float _121;
  float _123;
  float _125;
  float _135;
  float _137;
  float _138;
  float _140;
  float _143;
  float _149;
  float _151;
  float4 _153;
  float4 _165;
  float4 _180;
  float4 _195;
  float4 _210;
  float4 _225;
  float4 _240;
  float4 _255;
  float4 _270;
  float _280;
  float _284;
  float _288;
  float _293;
  float _299;
  float _340;
  float _343;
  float _346;
  float _352;
  float _358;
  float _359;
  float _360;
  float _361;
  float _371;
  float _392;
  float _412;
  bool _457;
  bool _467;
  bool _477;
  float4 _495;
  float _541;
  float _542;
  float _543;
  float4 _580;
  float _635;
  float _636;
  float _637;
  float4 _677;
  float4 _775;
  float _849;
  float _850;
  float _851;
  bool _854;
  float _855;
  float _856;
  float _857;
  float _865;
  float _874;
  float _883;
  float _900;
  float _901;
  float _902;
  [branch]
  if (film_aspect == 0.0f) {
    _32 = Kerare.x / Kerare.w;
    _33 = Kerare.y / Kerare.w;
    _34 = Kerare.z / Kerare.w;
    _38 = abs(rsqrt(dot(float3(_32, _33, _34), float3(_32, _33, _34))) * _34);
    _43 = _38 * _38;
    _71 = ((_43 * _43) * (1.0f - saturate((_38 * kerare_scale) + kerare_offset)));
  } else {
    _54 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    _56 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    _58 = sqrt(dot(float2(_56, _54), float2(_56, _54)));
    _66 = (_58 * _58) + 1.0f;
    _71 = ((1.0f / (_66 * _66)) * (1.0f - saturate(((1.0f / (_58 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  _74 = saturate(_71 + kerare_brightness) * Exposure;
  _82 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
  _86 = _82.x * _74;
  _87 = _82.y * _74;
  _88 = _82.z * _74;
  _103 = (float)((bool)(uint)((cbRadialBlurFlags & 2) != 0));
  _107 = ComputeResultSRV[0].computeAlpha;
  _110 = ((1.0f - _103) + (_107 * _103)) * cbRadialColor.w;
  if (!(_110 == 0.0f)) {
    _120 = screenInverseSize.x * SV_Position.x;
    _121 = screenInverseSize.y * SV_Position.y;
    _123 = _120 + (-0.5f - cbRadialScreenPos.x);
    _125 = _121 + (-0.5f - cbRadialScreenPos.y);
    _135 = sqrt((_123 * _123) + (_125 * _125));
    _137 = 1.0f / max(1.0f, _135);
    _138 = -0.0f - cbRadialBlurPower;
    _140 = (select((_123 < 0.0f), (1.0f - _120), _120) * _137) * _138;
    _143 = (select((_125 < 0.0f), (1.0f - _121), _121) * _137) * _138;
    _149 = cbRadialScreenPos.x + 0.5f;
    _151 = cbRadialScreenPos.y + 0.5f;
    _153 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_140 * 0.0011111111380159855f) + 1.0f) * _123) + _149), ((((_143 * 0.0011111111380159855f) + 1.0f) * _125) + _151)), 0.0f);
    _165 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_140 * 0.002222222276031971f) + 1.0f) * _123) + _149), ((((_143 * 0.002222222276031971f) + 1.0f) * _125) + _151)), 0.0f);
    _180 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_140 * 0.0033333334140479565f) + 1.0f) * _123) + _149), ((((_143 * 0.0033333334140479565f) + 1.0f) * _125) + _151)), 0.0f);
    _195 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_140 * 0.004444444552063942f) + 1.0f) * _123) + _149), ((((_143 * 0.004444444552063942f) + 1.0f) * _125) + _151)), 0.0f);
    _210 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_140 * 0.0055555556900799274f) + 1.0f) * _123) + _149), ((((_143 * 0.0055555556900799274f) + 1.0f) * _125) + _151)), 0.0f);
    _225 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_140 * 0.006666666828095913f) + 1.0f) * _123) + _149), ((((_143 * 0.006666666828095913f) + 1.0f) * _125) + _151)), 0.0f);
    _240 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_140 * 0.007777777966111898f) + 1.0f) * _123) + _149), ((((_143 * 0.007777777966111898f) + 1.0f) * _125) + _151)), 0.0f);
    _255 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_140 * 0.008888889104127884f) + 1.0f) * _123) + _149), ((((_143 * 0.008888889104127884f) + 1.0f) * _125) + _151)), 0.0f);
    _270 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((((_140 * 0.009999999776482582f) + 1.0f) * _123) + _149), ((((_143 * 0.009999999776482582f) + 1.0f) * _125) + _151)), 0.0f);
    _280 = (cbRadialColor.x * 0.10000000149011612f) * (_74 * (((((((((_165.x + _153.x) + _180.x) + _195.x) + _210.x) + _225.x) + _240.x) + _255.x) + _270.x) + _82.x));
    _284 = (cbRadialColor.y * 0.10000000149011612f) * (_74 * (((((((((_165.y + _153.y) + _180.y) + _195.y) + _210.y) + _225.y) + _240.y) + _255.y) + _270.y) + _82.y));
    _288 = (cbRadialColor.z * 0.10000000149011612f) * (_74 * (((((((((_165.z + _153.z) + _180.z) + _195.z) + _210.z) + _225.z) + _240.z) + _255.z) + _270.z) + _82.z));
    do {
      _310 = _280;
      _311 = _284;
      _312 = _288;
      if (cbRadialMaskRate.x > 0.0f) {
        _293 = saturate((_135 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
        _299 = (((_293 * _293) * cbRadialMaskRate.x) * (3.0f - (_293 * 2.0f))) + cbRadialMaskRate.y;
        _310 = ((_299 * (_280 - _86)) + _86);
        _311 = ((_299 * (_284 - _87)) + _87);
        _312 = ((_299 * (_288 - _88)) + _88);
      }
      _323 = (lerp(_86, _310, _110));
      _324 = (lerp(_87, _311, _110));
      _325 = (lerp(_88, _312, _110));
    } while (false);
  } else {
    _323 = _86;
    _324 = _87;
    _325 = _88;
  }
  _340 = mad(_325, (fOCIOTransformMatrix[2].x), mad(_324, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _323)));
  _343 = mad(_325, (fOCIOTransformMatrix[2].y), mad(_324, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _323)));
  _346 = mad(_325, (fOCIOTransformMatrix[2].z), mad(_324, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _323)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    _352 = max(max(_340, _343), _346);
    if (!(_352 == 0.0f)) {
      _358 = abs(_352);
      _359 = (_352 - _340) / _358;
      _360 = (_352 - _343) / _358;
      _361 = (_352 - _346) / _358;
      do {
        _383 = _359;
        if (!(!(_359 >= cbControlRGCParam.CyanThreshold))) {
          _371 = _359 - cbControlRGCParam.CyanThreshold;
          _383 = ((_371 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _371) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        }
        do {
          _404 = _360;
          if (!(!(_360 >= cbControlRGCParam.MagentaThreshold))) {
            _392 = _360 - cbControlRGCParam.MagentaThreshold;
            _404 = ((_392 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _392) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          }
          do {
            _424 = _361;
            if (!(!(_361 >= cbControlRGCParam.YellowThreshold))) {
              _412 = _361 - cbControlRGCParam.YellowThreshold;
              _424 = ((_412 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _412) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            }
            _432 = (_352 - (_383 * _358));
            _433 = (_352 - (_404 * _358));
            _434 = (_352 - (_424 * _358));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _432 = _340;
      _433 = _343;
      _434 = _346;
    }
  } else {
    _432 = _340;
    _433 = _343;
    _434 = _346;
  }
#if 1
  ApplyColorCorrectTexturePass(
      true,
      _432, _433, _434,
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
      _834, _835, _836);
  _849 = min(_834, 65000.0f);
  _850 = min(_835, 65000.0f);
  _851 = min(_836, 65000.0f);
#else
  _457 = !(_432 <= 0.0078125f);
  if (!(_457)) {
    _466 = ((_432 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _466 = ((log2(_432) + 9.720000267028809f) * 0.05707762390375137f);
  }
  _467 = !(_433 <= 0.0078125f);
  if (!(_467)) {
    _476 = ((_433 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _476 = ((log2(_433) + 9.720000267028809f) * 0.05707762390375137f);
  }
  _477 = !(_434 <= 0.0078125f);
  if (!(_477)) {
    _486 = ((_434 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _486 = ((log2(_434) + 9.720000267028809f) * 0.05707762390375137f);
  }
  _495 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_466 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_476 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_486 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
  if (_495.x < 0.155251145362854f) {
    _512 = ((_495.x + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((_495.x >= 0.155251145362854f) && (_495.x < 1.4679962396621704f)) {
      _512 = exp2((_495.x * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _512 = 65504.0f;
    }
  }
  if (_495.y < 0.155251145362854f) {
    _526 = ((_495.y + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((_495.y >= 0.155251145362854f) && (_495.y < 1.4679962396621704f)) {
      _526 = exp2((_495.y * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _526 = 65504.0f;
    }
  }
  if (_495.z < 0.155251145362854f) {
    _540 = ((_495.z + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if ((_495.z >= 0.155251145362854f) && (_495.z < 1.4679962396621704f)) {
      _540 = exp2((_495.z * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _540 = 65504.0f;
    }
  }
  _541 = max(_512, 0.0f);
  _542 = max(_526, 0.0f);
  _543 = max(_540, 0.0f);
  [branch]
  if (fTextureBlendRate > 0.0f) {
    do {
      if (!(_457)) {
        _554 = ((_432 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _554 = ((log2(_432) + 9.720000267028809f) * 0.05707762390375137f);
      }
      do {
        if (!(_467)) {
          _563 = ((_433 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _563 = ((log2(_433) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(_477)) {
            _572 = ((_434 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _572 = ((log2(_434) + 9.720000267028809f) * 0.05707762390375137f);
          }
          _580 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_554 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_563 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_572 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_580.x < 0.155251145362854f) {
              _597 = ((_580.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((_580.x >= 0.155251145362854f) && (_580.x < 1.4679962396621704f)) {
                _597 = exp2((_580.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _597 = 65504.0f;
              }
            }
            do {
              if (_580.y < 0.155251145362854f) {
                _611 = ((_580.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_580.y >= 0.155251145362854f) && (_580.y < 1.4679962396621704f)) {
                  _611 = exp2((_580.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _611 = 65504.0f;
                }
              }
              do {
                if (_580.z < 0.155251145362854f) {
                  _625 = ((_580.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_580.z >= 0.155251145362854f) && (_580.z < 1.4679962396621704f)) {
                    _625 = exp2((_580.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _625 = 65504.0f;
                  }
                }
                _635 = ((max(_597, 0.0f) - _541) * fTextureBlendRate) + _541;
                _636 = ((max(_611, 0.0f) - _542) * fTextureBlendRate) + _542;
                _637 = ((max(_625, 0.0f) - _543) * fTextureBlendRate) + _543;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    if (!(!(_635 <= 0.0078125f))) {
                      _649 = ((_635 * 10.540237426757812f) + 0.072905533015728f);
                    } else {
                      _649 = ((log2(_635) + 9.720000267028809f) * 0.05707762390375137f);
                    }
                    do {
                      if (!(!(_636 <= 0.0078125f))) {
                        _659 = ((_636 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _659 = ((log2(_636) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(!(_637 <= 0.0078125f))) {
                          _669 = ((_637 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _669 = ((log2(_637) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        _677 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_649 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_659 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_669 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                        do {
                          if (_677.x < 0.155251145362854f) {
                            _694 = ((_677.x + -0.072905533015728f) * 0.09487452358007431f);
                          } else {
                            if ((_677.x >= 0.155251145362854f) && (_677.x < 1.4679962396621704f)) {
                              _694 = exp2((_677.x * 17.520000457763672f) + -9.720000267028809f);
                            } else {
                              _694 = 65504.0f;
                            }
                          }
                          do {
                            if (_677.y < 0.155251145362854f) {
                              _708 = ((_677.y + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((_677.y >= 0.155251145362854f) && (_677.y < 1.4679962396621704f)) {
                                _708 = exp2((_677.y * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _708 = 65504.0f;
                              }
                            }
                            do {
                              if (_677.z < 0.155251145362854f) {
                                _722 = ((_677.z + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_677.z >= 0.155251145362854f) && (_677.z < 1.4679962396621704f)) {
                                  _722 = exp2((_677.z * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _722 = 65504.0f;
                                }
                              }
                              _834 = (((max(_694, 0.0f) - _635) * fTextureBlendRate2) + _635);
                              _835 = (((max(_708, 0.0f) - _636) * fTextureBlendRate2) + _636);
                              _836 = (((max(_722, 0.0f) - _637) * fTextureBlendRate2) + _637);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _834 = _635;
                  _835 = _636;
                  _836 = _637;
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
        if (!(!(_541 <= 0.0078125f))) {
          _747 = ((_541 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _747 = ((log2(_541) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_542 <= 0.0078125f))) {
            _757 = ((_542 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _757 = ((log2(_542) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_543 <= 0.0078125f))) {
              _767 = ((_543 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _767 = ((log2(_543) + 9.720000267028809f) * 0.05707762390375137f);
            }
            _775 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_747 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_757 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_767 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
            do {
              if (_775.x < 0.155251145362854f) {
                _792 = ((_775.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_775.x >= 0.155251145362854f) && (_775.x < 1.4679962396621704f)) {
                  _792 = exp2((_775.x * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _792 = 65504.0f;
                }
              }
              do {
                if (_775.y < 0.155251145362854f) {
                  _806 = ((_775.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_775.y >= 0.155251145362854f) && (_775.y < 1.4679962396621704f)) {
                    _806 = exp2((_775.y * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _806 = 65504.0f;
                  }
                }
                do {
                  if (_775.z < 0.155251145362854f) {
                    _820 = ((_775.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if ((_775.z >= 0.155251145362854f) && (_775.z < 1.4679962396621704f)) {
                      _820 = exp2((_775.z * 17.520000457763672f) + -9.720000267028809f);
                    } else {
                      _820 = 65504.0f;
                    }
                  }
                  _834 = (((max(_792, 0.0f) - _541) * fTextureBlendRate2) + _541);
                  _835 = (((max(_806, 0.0f) - _542) * fTextureBlendRate2) + _542);
                  _836 = (((max(_820, 0.0f) - _543) * fTextureBlendRate2) + _543);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _834 = _541;
      _835 = _542;
      _836 = _543;
    }
  }
  _849 = min((mad(_836, (fColorMatrix[2].x), mad(_835, (fColorMatrix[1].x), (_834 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x)), 65000.0f);
  _850 = min((mad(_836, (fColorMatrix[2].y), mad(_835, (fColorMatrix[1].y), (_834 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y)), 65000.0f);
  _851 = min((mad(_836, (fColorMatrix[2].z), mad(_835, (fColorMatrix[1].z), (_834 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z)), 65000.0f);
#endif
  _854 = isfinite(max(max(_849, _850), _851));
  _855 = select(_854, _849, 1.0f);
  _856 = select(_854, _850, 1.0f);
  _857 = select(_854, _851, 1.0f);
#if 1
  ApplyCapcomExponentialToneMap(
      _855, _856, _857,
      _962, _963, _964,
      contrast, linearBegin, toe, maxNit, linearStart,
      displayMaxNitSubContrastFactor, contrastFactor, mulLinearStartContrastFactor,
      invLinearBegin, madLinearStartContrastFactor, tonemapParam_isHDRMode);
#else
  if (tonemapParam_isHDRMode == 0.0f) {
    _865 = invLinearBegin * _855;
    do {
      _873 = 1.0f;
      if (!(_855 >= linearBegin)) {
        _873 = ((_865 * _865) * (3.0f - (_865 * 2.0f)));
      }
      _874 = invLinearBegin * _856;
      do {
        _882 = 1.0f;
        if (!(_856 >= linearBegin)) {
          _882 = ((_874 * _874) * (3.0f - (_874 * 2.0f)));
        }
        _883 = invLinearBegin * _857;
        do {
          _891 = 1.0f;
          if (!(_857 >= linearBegin)) {
            _891 = ((_883 * _883) * (3.0f - (_883 * 2.0f)));
          }
          _900 = select((_855 < linearStart), 0.0f, 1.0f);
          _901 = select((_856 < linearStart), 0.0f, 1.0f);
          _902 = select((_857 < linearStart), 0.0f, 1.0f);
          _962 = (((((1.0f - _873) * linearBegin) * (pow(_865, toe))) + ((_873 - _900) * ((contrast * _855) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _855) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _900));
          _963 = (((((1.0f - _882) * linearBegin) * (pow(_874, toe))) + ((_882 - _901) * ((contrast * _856) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _856) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _901));
          _964 = (((((1.0f - _891) * linearBegin) * (pow(_883, toe))) + ((_891 - _902) * ((contrast * _857) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _857) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _902));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _962 = _855;
    _963 = _856;
    _964 = _857;
  }
#endif
  SV_Target.x = _962;
  SV_Target.y = _963;
  SV_Target.z = _964;
  SV_Target.w = 0.0f;
  return SV_Target;
}
