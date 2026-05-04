#include "./common.hlsl"

Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> RE_POSTPROCESS_Color : register(t1);

Texture2D<float> tFilterTempMap1 : register(t2);

Texture3D<float> tVolumeMap : register(t3);

struct RadialBlurComputeResult {
  float computeAlpha;
};

StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t4);

Texture3D<float4> tTextureMap0 : register(t5);

Texture3D<float4> tTextureMap1 : register(t6);

Texture3D<float4> tTextureMap2 : register(t7);

Texture2D<float4> ImagePlameBase : register(t8);

Texture2D<float> ImagePlameAlpha : register(t9);

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
  float2 projectionSpaceJitterOffset : packoffset(c037.x);
  float2 SceneInfo_Reserve2 : packoffset(c037.z);
};

cbuffer CameraKerare : register(b1) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer CBHazeFilterParams : register(b2) {
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
  uint fHazeFilterReserved1 : packoffset(c003.y);
  uint fHazeFilterReserved2 : packoffset(c003.z);
  uint fHazeFilterReserved3 : packoffset(c003.w);
};

cbuffer LensDistortionParam : register(b3) {
  float fDistortionCoef : packoffset(c000.x);
  float fRefraction : packoffset(c000.y);
  uint aberrationEnable : packoffset(c000.z);
  uint distortionType : packoffset(c000.w);
  float fCorrectCoef : packoffset(c001.x);
  uint reserve1 : packoffset(c001.y);
  uint reserve2 : packoffset(c001.z);
  uint reserve3 : packoffset(c001.w);
};

cbuffer PaniniProjectionParam : register(b4) {
  float4 fOptimizedParam : packoffset(c000.x);
};

cbuffer RadialBlurRenderParam : register(b5) {
  float4 cbRadialColor : packoffset(c000.x);
  float2 cbRadialScreenPos : packoffset(c001.x);
  float2 cbRadialMaskSmoothstep : packoffset(c001.z);
  float2 cbRadialMaskRate : packoffset(c002.x);
  float cbRadialBlurPower : packoffset(c002.z);
  float cbRadialSharpRange : packoffset(c002.w);
  uint cbRadialBlurFlags : packoffset(c003.x);
  float cbRadialReserve0 : packoffset(c003.y);
  float cbRadialReserve1 : packoffset(c003.z);
  float cbRadialReserve2 : packoffset(c003.w);
};

cbuffer FilmGrainParam : register(b6) {
  float2 fNoisePower : packoffset(c000.x);
  float2 fNoiseUVOffset : packoffset(c000.z);
  float fNoiseDensity : packoffset(c001.x);
  float fNoiseContrast : packoffset(c001.y);
  float fBlendRate : packoffset(c001.z);
  float fReverseNoiseSize : packoffset(c001.w);
};

cbuffer ColorCorrectTexture : register(b7) {
  float fTextureSize : packoffset(c000.x);
  float fTextureBlendRate : packoffset(c000.y);
  float fTextureBlendRate2 : packoffset(c000.z);
  float fTextureInverseSize : packoffset(c000.w);
  float fHalfTextureInverseSize : packoffset(c001.x);
  float fOneMinusTextureInverseSize : packoffset(c001.y);
  float fColorCorrectTextureReserve : packoffset(c001.z);
  float fColorCorrectTextureReserve2 : packoffset(c001.w);
  row_major float4x4 fColorMatrix : packoffset(c002.x);
};

cbuffer ColorDeficientTable : register(b8) {
  float4 cvdR : packoffset(c000.x);
  float4 cvdG : packoffset(c001.x);
  float4 cvdB : packoffset(c002.x);
};

cbuffer ImagePlaneParam : register(b9) {
  float4 ColorParam : packoffset(c000.x);
  float Levels_Rate : packoffset(c001.x);
  float Levels_Range : packoffset(c001.y);
  uint Blend_Type : packoffset(c001.z);
};

cbuffer CBControl : register(b10) {
  float3 CBControl_reserve : packoffset(c000.x);
  uint cPassEnabled : packoffset(c000.w);
  row_major float4x4 fOCIOTransformMatrix : packoffset(c001.x);
};

SamplerState PointClamp : register(s1, space32);

SamplerState BilinearWrap : register(s4, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  bool _48 = ((cPassEnabled & 1) == 0);
  bool _54;
  bool _60;
  float _109;
  float _237;
  float _238;
  float _370;
  float _371;
  float _383;
  float _384;
  float _388;
  float _389;
  float _422;
  float _423;
  float _424;
  float _557;
  float _558;
  float _690;
  float _691;
  float _703;
  float _704;
  float _708;
  float _709;
  float _823;
  float _824;
  float _958;
  float _959;
  float _971;
  float _972;
  float _982;
  float _983;
  float _984;
  float _988;
  float _989;
  float _990;
  float _991;
  float _992;
  float _993;
  float _994;
  float _995;
  float _996;
  float _1072;
  float _1675;
  float _1676;
  float _1677;
  float _1715;
  float _1716;
  float _1717;
  float _1728;
  float _1729;
  float _1730;
  float _1788;
  float _1804;
  float _1820;
  float _1848;
  float _1849;
  float _1850;
  float _2044;
  float _2045;
  float _2046;
  float _2057;
  float _2058;
  float _2059;
  float _2100;
  float _2101;
  float _2102;
  float _2148;
  float _2160;
  float _2172;
  float _2183;
  float _2184;
  float _2185;
  if (!_48) {
    _54 = (distortionType == 0);
  } else {
    _54 = false;
  }
  if (!_48) {
    _60 = (distortionType == 1);
  } else {
    _60 = false;
  }
  bool _62 = ((cPassEnabled & 64) != 0);
  [branch]
  if (film_aspect == 0.0f) {
    float _70 = Kerare.x / Kerare.w;
    float _71 = Kerare.y / Kerare.w;
    float _72 = Kerare.z / Kerare.w;
    float _76 = abs(rsqrt(dot(float3(_70, _71, _72), float3(_70, _71, _72))) * _72);
    float _81 = _76 * _76;
    _109 = ((_81 * _81) * (1.0f - saturate((kerare_scale * _76) + kerare_offset)));
  } else {
    float _92 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _94 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _96 = sqrt(dot(float2(_94, _92), float2(_94, _92)));
    float _104 = (_96 * _96) + 1.0f;
    _109 = ((1.0f / (_104 * _104)) * (1.0f - saturate((kerare_scale * (1.0f / (_96 + 1.0f))) + kerare_offset)));
  }
  float _111 = saturate(_109 + kerare_brightness);

   CustomVignette(_111);

  float _112 = _111 * Exposure;
  if (_54) {
    float _126 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _127 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _128 = dot(float2(_126, _127), float2(_126, _127));
    float _131 = ((_128 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float _132 = _131 * _126;
    float _133 = _131 * _127;
    float _134 = _132 + 0.5f;
    float _135 = _133 + 0.5f;
    do {
      if (aberrationEnable == 0) {
        do {
          if (_62) {
            bool _144 = ((fHazeFilterAttribute & 2) != 0);
            float _149 = tFilterTempMap1.Sample(BilinearWrap, float2(_134, _135));
            do {
              if (_144) {
                float _154 = ReadonlyDepth.SampleLevel(PointClamp, float2(_134, _135), 0.0f);
                float _162 = (((_134 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
                float _163 = 1.0f - (((_135 * 2.0f) * screenSize.y) * screenInverseSize.y);
                float _200 = 1.0f / (mad(_154.x, (viewProjInvMat[2].w), mad(_163, (viewProjInvMat[1].w), (_162 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
                float _202 = _200 * (mad(_154.x, (viewProjInvMat[2].y), mad(_163, (viewProjInvMat[1].y), (_162 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
                float _210 = (_200 * (mad(_154.x, (viewProjInvMat[2].x), mad(_163, (viewProjInvMat[1].x), (_162 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                float _211 = _202 - (transposeViewInvMat[1].w);
                float _212 = (_200 * (mad(_154.x, (viewProjInvMat[2].z), mad(_163, (viewProjInvMat[1].z), (_162 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _237 = saturate(_149.x * max(((sqrt(((_211 * _211) + (_210 * _210)) + (_212 * _212)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_202 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
                _238 = _154.x;
              } else {
                _237 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _149.x), _149.x);
                _238 = 0.0f;
              }
              float _243 = -0.0f - _135;
              float _266 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_243, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _134)));
              float _267 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_243, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _134)));
              float _268 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_243, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _134)));
              float _274 = tVolumeMap.Sample(BilinearWrap, float3((_266 + fHazeFilterUVWOffset.x), (_267 + fHazeFilterUVWOffset.y), (_268 + fHazeFilterUVWOffset.z)));
              float _277 = _266 * 2.0f;
              float _278 = _267 * 2.0f;
              float _279 = _268 * 2.0f;
              float _283 = tVolumeMap.Sample(BilinearWrap, float3((_277 + fHazeFilterUVWOffset.x), (_278 + fHazeFilterUVWOffset.y), (_279 + fHazeFilterUVWOffset.z)));
              float _287 = _266 * 4.0f;
              float _288 = _267 * 4.0f;
              float _289 = _268 * 4.0f;
              float _293 = tVolumeMap.Sample(BilinearWrap, float3((_287 + fHazeFilterUVWOffset.x), (_288 + fHazeFilterUVWOffset.y), (_289 + fHazeFilterUVWOffset.z)));
              float _297 = _266 * 8.0f;
              float _298 = _267 * 8.0f;
              float _299 = _268 * 8.0f;
              float _303 = tVolumeMap.Sample(BilinearWrap, float3((_297 + fHazeFilterUVWOffset.x), (_298 + fHazeFilterUVWOffset.y), (_299 + fHazeFilterUVWOffset.z)));
              float _307 = fHazeFilterUVWOffset.x + 0.5f;
              float _308 = fHazeFilterUVWOffset.y + 0.5f;
              float _309 = fHazeFilterUVWOffset.z + 0.5f;
              float _313 = tVolumeMap.Sample(BilinearWrap, float3((_266 + _307), (_267 + _308), (_268 + _309)));
              float _319 = tVolumeMap.Sample(BilinearWrap, float3((_277 + _307), (_278 + _308), (_279 + _309)));
              float _326 = tVolumeMap.Sample(BilinearWrap, float3((_287 + _307), (_288 + _308), (_289 + _309)));
              float _333 = tVolumeMap.Sample(BilinearWrap, float3((_297 + _307), (_298 + _308), (_299 + _309)));
              float _344 = (((((((_283.x * 0.25f) + (_274.x * 0.5f)) + (_293.x * 0.125f)) + (_303.x * 0.0625f)) * 2.0f) + -1.0f) * _237) * fHazeFilterScale;
              float _346 = (fHazeFilterScale * _237) * ((((((_319.x * 0.25f) + (_313.x * 0.5f)) + (_326.x * 0.125f)) + (_333.x * 0.0625f)) * 2.0f) + -1.0f);
              do {
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  float _357 = 0.5f / fHazeFilterBorder;
                  float _364 = saturate(max(((_357 * min(max((abs(_132) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_357 * min(max((abs(_133) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                  _370 = (_344 - (_364 * _344));
                  _371 = (_346 - (_364 * _346));
                } else {
                  _370 = _344;
                  _371 = _346;
                }
                do {
                  if (_144) {
                    float _376 = ReadonlyDepth.Sample(BilinearWrap, float2((_370 + _134), (_371 + _135)));
                    if (!(!((_376.x - _238) >= fHazeFilterDepthDiffBias))) {
                      _383 = 0.0f;
                      _384 = 0.0f;
                    } else {
                      _383 = _370;
                      _384 = _371;
                    }
                  } else {
                    _383 = _370;
                    _384 = _371;
                  }
                  _388 = (_383 + _134);
                  _389 = (_384 + _135);
                } while (false);
              } while (false);
            } while (false);
          } else {
            _388 = _134;
            _389 = _135;
          }
          float4 _392 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_388, _389));
          _422 = _392.z;
          _423 = _392.x;
          _424 = _392.y;
        } while (false);
      } else {
        float _397 = _128 + fRefraction;
        float _399 = (_397 * fDistortionCoef) + 1.0f;
        float _400 = _126 * fCorrectCoef;
        float _402 = _127 * fCorrectCoef;
        float _408 = ((_397 + fRefraction) * fDistortionCoef) + 1.0f;
        float4 _415 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_134, _135));
        float4 _417 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_400 * _399) + 0.5f), ((_402 * _399) + 0.5f)));
        float4 _419 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_400 * _408) + 0.5f), ((_402 * _408) + 0.5f)));
        _422 = _419.z;
        _423 = _415.x;
        _424 = _417.y;
      }
      _988 = (_112 * _423);
      _989 = (_112 * _424);
      _990 = _422;
      _991 = fDistortionCoef;
      _992 = 0.0f;
      _993 = 0.0f;
      _994 = 0.0f;
      _995 = 0.0f;
      _996 = fCorrectCoef;
    } while (false);
  } else {
    if (_60) {
      float _438 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _442 = sqrt((_438 * _438) + 1.0f);
      float _443 = 1.0f / _442;
      float _446 = (_442 * fOptimizedParam.z) * (_443 + fOptimizedParam.x);
      float _450 = fOptimizedParam.w * 0.5f;
      float _452 = (_450 * _438) * _446;
      float _455 = ((_450 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_443 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _446;
      float _456 = _452 + 0.5f;
      float _457 = _455 + 0.5f;
      do {
        if (_62) {
          bool _464 = ((fHazeFilterAttribute & 2) != 0);
          float _469 = tFilterTempMap1.Sample(BilinearWrap, float2(_456, _457));
          do {
            if (_464) {
              float _474 = ReadonlyDepth.SampleLevel(PointClamp, float2(_456, _457), 0.0f);
              float _482 = (((screenSize.x * 2.0f) * _456) * screenInverseSize.x) + -1.0f;
              float _483 = 1.0f - (((screenSize.y * 2.0f) * _457) * screenInverseSize.y);
              float _520 = 1.0f / (mad(_474.x, (viewProjInvMat[2].w), mad(_483, (viewProjInvMat[1].w), (_482 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _522 = _520 * (mad(_474.x, (viewProjInvMat[2].y), mad(_483, (viewProjInvMat[1].y), (_482 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _530 = (_520 * (mad(_474.x, (viewProjInvMat[2].x), mad(_483, (viewProjInvMat[1].x), (_482 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _531 = _522 - (transposeViewInvMat[1].w);
              float _532 = (_520 * (mad(_474.x, (viewProjInvMat[2].z), mad(_483, (viewProjInvMat[1].z), (_482 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _557 = saturate(_469.x * max(((sqrt(((_531 * _531) + (_530 * _530)) + (_532 * _532)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_522 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _558 = _474.x;
            } else {
              _557 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _469.x), _469.x);
              _558 = 0.0f;
            }
            float _563 = -0.0f - _457;
            float _586 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_563, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _456)));
            float _587 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_563, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _456)));
            float _588 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_563, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _456)));
            float _594 = tVolumeMap.Sample(BilinearWrap, float3((_586 + fHazeFilterUVWOffset.x), (_587 + fHazeFilterUVWOffset.y), (_588 + fHazeFilterUVWOffset.z)));
            float _597 = _586 * 2.0f;
            float _598 = _587 * 2.0f;
            float _599 = _588 * 2.0f;
            float _603 = tVolumeMap.Sample(BilinearWrap, float3((_597 + fHazeFilterUVWOffset.x), (_598 + fHazeFilterUVWOffset.y), (_599 + fHazeFilterUVWOffset.z)));
            float _607 = _586 * 4.0f;
            float _608 = _587 * 4.0f;
            float _609 = _588 * 4.0f;
            float _613 = tVolumeMap.Sample(BilinearWrap, float3((_607 + fHazeFilterUVWOffset.x), (_608 + fHazeFilterUVWOffset.y), (_609 + fHazeFilterUVWOffset.z)));
            float _617 = _586 * 8.0f;
            float _618 = _587 * 8.0f;
            float _619 = _588 * 8.0f;
            float _623 = tVolumeMap.Sample(BilinearWrap, float3((_617 + fHazeFilterUVWOffset.x), (_618 + fHazeFilterUVWOffset.y), (_619 + fHazeFilterUVWOffset.z)));
            float _627 = fHazeFilterUVWOffset.x + 0.5f;
            float _628 = fHazeFilterUVWOffset.y + 0.5f;
            float _629 = fHazeFilterUVWOffset.z + 0.5f;
            float _633 = tVolumeMap.Sample(BilinearWrap, float3((_586 + _627), (_587 + _628), (_588 + _629)));
            float _639 = tVolumeMap.Sample(BilinearWrap, float3((_597 + _627), (_598 + _628), (_599 + _629)));
            float _646 = tVolumeMap.Sample(BilinearWrap, float3((_607 + _627), (_608 + _628), (_609 + _629)));
            float _653 = tVolumeMap.Sample(BilinearWrap, float3((_617 + _627), (_618 + _628), (_619 + _629)));
            float _664 = (((((((_603.x * 0.25f) + (_594.x * 0.5f)) + (_613.x * 0.125f)) + (_623.x * 0.0625f)) * 2.0f) + -1.0f) * _557) * fHazeFilterScale;
            float _666 = (fHazeFilterScale * _557) * ((((((_639.x * 0.25f) + (_633.x * 0.5f)) + (_646.x * 0.125f)) + (_653.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _677 = 0.5f / fHazeFilterBorder;
                float _684 = saturate(max(((_677 * min(max((abs(_452) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_677 * min(max((abs(_455) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _690 = (_664 - (_684 * _664));
                _691 = (_666 - (_684 * _666));
              } else {
                _690 = _664;
                _691 = _666;
              }
              do {
                if (_464) {
                  float _696 = ReadonlyDepth.Sample(BilinearWrap, float2((_690 + _456), (_691 + _457)));
                  if (!(!((_696.x - _558) >= fHazeFilterDepthDiffBias))) {
                    _703 = 0.0f;
                    _704 = 0.0f;
                  } else {
                    _703 = _690;
                    _704 = _691;
                  }
                } else {
                  _703 = _690;
                  _704 = _691;
                }
                _708 = (_703 + _456);
                _709 = (_704 + _457);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _708 = _456;
          _709 = _457;
        }
        float4 _712 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_708, _709));
        _988 = (_712.x * _112);
        _989 = (_712.y * _112);
        _990 = _712.z;
        _991 = 0.0f;
        _992 = fOptimizedParam.x;
        _993 = fOptimizedParam.y;
        _994 = fOptimizedParam.z;
        _995 = fOptimizedParam.w;
        _996 = 1.0f;
      } while (false);
    } else {
      float _719 = screenInverseSize.x * SV_Position.x;
      float _720 = screenInverseSize.y * SV_Position.y;
      do {
        if (!_62) {
          float4 _724 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_719, _720));
          _982 = _724.x;
          _983 = _724.y;
          _984 = _724.z;
        } else {
          bool _732 = ((fHazeFilterAttribute & 2) != 0);
          float _737 = tFilterTempMap1.Sample(BilinearWrap, float2(_719, _720));
          do {
            if (_732) {
              float _742 = ReadonlyDepth.SampleLevel(PointClamp, float2(_719, _720), 0.0f);
              float _748 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
              float _749 = 1.0f - ((SV_Position.y * 2.0f) * screenInverseSize.y);
              float _786 = 1.0f / (mad(_742.x, (viewProjInvMat[2].w), mad(_749, (viewProjInvMat[1].w), (_748 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _788 = _786 * (mad(_742.x, (viewProjInvMat[2].y), mad(_749, (viewProjInvMat[1].y), (_748 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _796 = (_786 * (mad(_742.x, (viewProjInvMat[2].x), mad(_749, (viewProjInvMat[1].x), (_748 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _797 = _788 - (transposeViewInvMat[1].w);
              float _798 = (_786 * (mad(_742.x, (viewProjInvMat[2].z), mad(_749, (viewProjInvMat[1].z), (_748 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _823 = saturate(_737.x * max(((sqrt(((_797 * _797) + (_796 * _796)) + (_798 * _798)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_788 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _824 = _742.x;
            } else {
              _823 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _737.x), _737.x);
              _824 = 0.0f;
            }
            float _829 = -0.0f - _720;
            float _852 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_829, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _719)));
            float _853 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_829, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _719)));
            float _854 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_829, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _719)));
            float _860 = tVolumeMap.Sample(BilinearWrap, float3((_852 + fHazeFilterUVWOffset.x), (_853 + fHazeFilterUVWOffset.y), (_854 + fHazeFilterUVWOffset.z)));
            float _863 = _852 * 2.0f;
            float _864 = _853 * 2.0f;
            float _865 = _854 * 2.0f;
            float _869 = tVolumeMap.Sample(BilinearWrap, float3((_863 + fHazeFilterUVWOffset.x), (_864 + fHazeFilterUVWOffset.y), (_865 + fHazeFilterUVWOffset.z)));
            float _873 = _852 * 4.0f;
            float _874 = _853 * 4.0f;
            float _875 = _854 * 4.0f;
            float _879 = tVolumeMap.Sample(BilinearWrap, float3((_873 + fHazeFilterUVWOffset.x), (_874 + fHazeFilterUVWOffset.y), (_875 + fHazeFilterUVWOffset.z)));
            float _883 = _852 * 8.0f;
            float _884 = _853 * 8.0f;
            float _885 = _854 * 8.0f;
            float _889 = tVolumeMap.Sample(BilinearWrap, float3((_883 + fHazeFilterUVWOffset.x), (_884 + fHazeFilterUVWOffset.y), (_885 + fHazeFilterUVWOffset.z)));
            float _893 = fHazeFilterUVWOffset.x + 0.5f;
            float _894 = fHazeFilterUVWOffset.y + 0.5f;
            float _895 = fHazeFilterUVWOffset.z + 0.5f;
            float _899 = tVolumeMap.Sample(BilinearWrap, float3((_852 + _893), (_853 + _894), (_854 + _895)));
            float _905 = tVolumeMap.Sample(BilinearWrap, float3((_863 + _893), (_864 + _894), (_865 + _895)));
            float _912 = tVolumeMap.Sample(BilinearWrap, float3((_873 + _893), (_874 + _894), (_875 + _895)));
            float _919 = tVolumeMap.Sample(BilinearWrap, float3((_883 + _893), (_884 + _894), (_885 + _895)));
            float _930 = (((((((_869.x * 0.25f) + (_860.x * 0.5f)) + (_879.x * 0.125f)) + (_889.x * 0.0625f)) * 2.0f) + -1.0f) * _823) * fHazeFilterScale;
            float _932 = (fHazeFilterScale * _823) * ((((((_905.x * 0.25f) + (_899.x * 0.5f)) + (_912.x * 0.125f)) + (_919.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _945 = 0.5f / fHazeFilterBorder;
                float _952 = saturate(max(((_945 * min(max((abs(_719 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_945 * min(max((abs(_720 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _958 = (_930 - (_952 * _930));
                _959 = (_932 - (_952 * _932));
              } else {
                _958 = _930;
                _959 = _932;
              }
              do {
                if (_732) {
                  float _964 = ReadonlyDepth.Sample(BilinearWrap, float2((_958 + _719), (_959 + _720)));
                  if (!(!((_964.x - _824) >= fHazeFilterDepthDiffBias))) {
                    _971 = 0.0f;
                    _972 = 0.0f;
                  } else {
                    _971 = _958;
                    _972 = _959;
                  }
                } else {
                  _971 = _958;
                  _972 = _959;
                }
                float4 _977 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_971 + _719), (_972 + _720)));
                _982 = _977.x;
                _983 = _977.y;
                _984 = _977.z;
              } while (false);
            } while (false);
          } while (false);
        }
        _988 = (_982 * _112);
        _989 = (_983 * _112);
        _990 = _984;
        _991 = 0.0f;
        _992 = 0.0f;
        _993 = 0.0f;
        _994 = 0.0f;
        _995 = 0.0f;
        _996 = 1.0f;
      } while (false);
    }
  }
  float _997 = _990 * _112;
  if (!((cPassEnabled & 32) == 0)) {
    float _1018 = _111 * Exposure;
    float _1021 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1025 = ComputeResultSRV[0].computeAlpha;
    float _1028 = ((1.0f - _1021) + (_1025 * _1021)) * cbRadialColor.w;
    if (!(_1028 == 0.0f)) {
      float _1034 = screenInverseSize.x * SV_Position.x;
      float _1035 = screenInverseSize.y * SV_Position.y;
      float _1037 = (-0.5f - cbRadialScreenPos.x) + _1034;
      float _1039 = (-0.5f - cbRadialScreenPos.y) + _1035;
      float _1042 = select((_1037 < 0.0f), (1.0f - _1034), _1034);
      float _1045 = select((_1039 < 0.0f), (1.0f - _1035), _1035);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _1050 = rsqrt(dot(float2(_1037, _1039), float2(_1037, _1039)));
          uint _1059 = uint(abs((_1039 * cbRadialSharpRange) * _1050)) + uint(abs((_1037 * cbRadialSharpRange) * _1050));
          uint _1063 = ((_1059 ^ 61) ^ ((uint)(_1059) >> 16)) * 9;
          uint _1066 = (((uint)(_1063) >> 4) ^ _1063) * 668265261;
          _1072 = (float((uint)((int)(((uint)(_1066) >> 15) ^ _1066))) * 2.3283064365386963e-10f);
        } else {
          _1072 = 1.0f;
        }
        float _1078 = 1.0f / max(1.0f, sqrt((_1037 * _1037) + (_1039 * _1039)));
        float _1079 = cbRadialBlurPower * -0.0011111111380159855f;
        float _1088 = ((((_1079 * _1042) * _1072) * _1078) + 1.0f) * _1037;
        float _1089 = ((((_1079 * _1045) * _1072) * _1078) + 1.0f) * _1039;
        float _1091 = cbRadialBlurPower * -0.002222222276031971f;
        float _1100 = ((((_1091 * _1042) * _1072) * _1078) + 1.0f) * _1037;
        float _1101 = ((((_1091 * _1045) * _1072) * _1078) + 1.0f) * _1039;
        float _1102 = cbRadialBlurPower * -0.0033333334140479565f;
        float _1111 = ((((_1102 * _1042) * _1072) * _1078) + 1.0f) * _1037;
        float _1112 = ((((_1102 * _1045) * _1072) * _1078) + 1.0f) * _1039;
        float _1113 = cbRadialBlurPower * -0.004444444552063942f;
        float _1122 = ((((_1113 * _1042) * _1072) * _1078) + 1.0f) * _1037;
        float _1123 = ((((_1113 * _1045) * _1072) * _1078) + 1.0f) * _1039;
        float _1124 = cbRadialBlurPower * -0.0055555556900799274f;
        float _1133 = ((((_1124 * _1042) * _1072) * _1078) + 1.0f) * _1037;
        float _1134 = ((((_1124 * _1045) * _1072) * _1078) + 1.0f) * _1039;
        float _1135 = cbRadialBlurPower * -0.006666666828095913f;
        float _1144 = ((((_1135 * _1042) * _1072) * _1078) + 1.0f) * _1037;
        float _1145 = ((((_1135 * _1045) * _1072) * _1078) + 1.0f) * _1039;
        float _1146 = cbRadialBlurPower * -0.007777777966111898f;
        float _1155 = ((((_1146 * _1042) * _1072) * _1078) + 1.0f) * _1037;
        float _1156 = ((((_1146 * _1045) * _1072) * _1078) + 1.0f) * _1039;
        float _1157 = cbRadialBlurPower * -0.008888889104127884f;
        float _1166 = ((((_1157 * _1042) * _1072) * _1078) + 1.0f) * _1037;
        float _1167 = ((((_1157 * _1045) * _1072) * _1078) + 1.0f) * _1039;
        float _1168 = cbRadialBlurPower * -0.009999999776482582f;
        float _1177 = ((((_1168 * _1042) * _1072) * _1078) + 1.0f) * _1037;
        float _1178 = ((((_1168 * _1045) * _1072) * _1078) + 1.0f) * _1039;
        do {
          if (_54) {
            float _1180 = _1088 + cbRadialScreenPos.x;
            float _1181 = _1089 + cbRadialScreenPos.y;
            float _1185 = ((dot(float2(_1180, _1181), float2(_1180, _1181)) * _991) + 1.0f) * _996;
            float4 _1191 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1185 * _1180) + 0.5f), ((_1185 * _1181) + 0.5f)), 0.0f);
            float _1195 = _1100 + cbRadialScreenPos.x;
            float _1196 = _1101 + cbRadialScreenPos.y;
            float _1199 = (dot(float2(_1195, _1196), float2(_1195, _1196)) * _991) + 1.0f;
            float4 _1206 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1195 * _996) * _1199) + 0.5f), (((_1196 * _996) * _1199) + 0.5f)), 0.0f);
            float _1213 = _1111 + cbRadialScreenPos.x;
            float _1214 = _1112 + cbRadialScreenPos.y;
            float _1217 = (dot(float2(_1213, _1214), float2(_1213, _1214)) * _991) + 1.0f;
            float4 _1224 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1213 * _996) * _1217) + 0.5f), (((_1214 * _996) * _1217) + 0.5f)), 0.0f);
            float _1231 = _1122 + cbRadialScreenPos.x;
            float _1232 = _1123 + cbRadialScreenPos.y;
            float _1235 = (dot(float2(_1231, _1232), float2(_1231, _1232)) * _991) + 1.0f;
            float4 _1242 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1231 * _996) * _1235) + 0.5f), (((_1232 * _996) * _1235) + 0.5f)), 0.0f);
            float _1249 = _1133 + cbRadialScreenPos.x;
            float _1250 = _1134 + cbRadialScreenPos.y;
            float _1253 = (dot(float2(_1249, _1250), float2(_1249, _1250)) * _991) + 1.0f;
            float4 _1260 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1249 * _996) * _1253) + 0.5f), (((_1250 * _996) * _1253) + 0.5f)), 0.0f);
            float _1267 = _1144 + cbRadialScreenPos.x;
            float _1268 = _1145 + cbRadialScreenPos.y;
            float _1271 = (dot(float2(_1267, _1268), float2(_1267, _1268)) * _991) + 1.0f;
            float4 _1278 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1267 * _996) * _1271) + 0.5f), (((_1268 * _996) * _1271) + 0.5f)), 0.0f);
            float _1285 = _1155 + cbRadialScreenPos.x;
            float _1286 = _1156 + cbRadialScreenPos.y;
            float _1289 = (dot(float2(_1285, _1286), float2(_1285, _1286)) * _991) + 1.0f;
            float4 _1296 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1285 * _996) * _1289) + 0.5f), (((_1286 * _996) * _1289) + 0.5f)), 0.0f);
            float _1303 = _1166 + cbRadialScreenPos.x;
            float _1304 = _1167 + cbRadialScreenPos.y;
            float _1307 = (dot(float2(_1303, _1304), float2(_1303, _1304)) * _991) + 1.0f;
            float4 _1314 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1303 * _996) * _1307) + 0.5f), (((_1304 * _996) * _1307) + 0.5f)), 0.0f);
            float _1321 = _1177 + cbRadialScreenPos.x;
            float _1322 = _1178 + cbRadialScreenPos.y;
            float _1325 = (dot(float2(_1321, _1322), float2(_1321, _1322)) * _991) + 1.0f;
            float4 _1332 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1321 * _996) * _1325) + 0.5f), (((_1322 * _996) * _1325) + 0.5f)), 0.0f);
            _1675 = ((((((((_1206.x + _1191.x) + _1224.x) + _1242.x) + _1260.x) + _1278.x) + _1296.x) + _1314.x) + _1332.x);
            _1676 = ((((((((_1206.y + _1191.y) + _1224.y) + _1242.y) + _1260.y) + _1278.y) + _1296.y) + _1314.y) + _1332.y);
            _1677 = ((((((((_1206.z + _1191.z) + _1224.z) + _1242.z) + _1260.z) + _1278.z) + _1296.z) + _1314.z) + _1332.z);
          } else {
            float _1340 = cbRadialScreenPos.x + 0.5f;
            float _1341 = _1340 + _1088;
            float _1342 = cbRadialScreenPos.y + 0.5f;
            float _1343 = _1342 + _1089;
            float _1344 = _1340 + _1100;
            float _1345 = _1342 + _1101;
            float _1346 = _1340 + _1111;
            float _1347 = _1342 + _1112;
            float _1348 = _1340 + _1122;
            float _1349 = _1342 + _1123;
            float _1350 = _1340 + _1133;
            float _1351 = _1342 + _1134;
            float _1352 = _1340 + _1144;
            float _1353 = _1342 + _1145;
            float _1354 = _1340 + _1155;
            float _1355 = _1342 + _1156;
            float _1356 = _1340 + _1166;
            float _1357 = _1342 + _1167;
            float _1358 = _1340 + _1177;
            float _1359 = _1342 + _1178;
            if (_60) {
              float _1363 = (_1341 * 2.0f) + -1.0f;
              float _1367 = sqrt((_1363 * _1363) + 1.0f);
              float _1368 = 1.0f / _1367;
              float _1371 = (_1367 * _994) * (_1368 + _992);
              float _1375 = _995 * 0.5f;
              float4 _1384 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1375 * _1371) * _1363) + 0.5f), ((((_1375 * (((_1368 + -1.0f) * _993) + 1.0f)) * _1371) * ((_1343 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
              float _1390 = (_1344 * 2.0f) + -1.0f;
              float _1394 = sqrt((_1390 * _1390) + 1.0f);
              float _1395 = 1.0f / _1394;
              float _1398 = (_1394 * _994) * (_1395 + _992);
              float4 _1409 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1375 * _1390) * _1398) + 0.5f), ((((_1375 * ((_1345 * 2.0f) + -1.0f)) * (((_1395 + -1.0f) * _993) + 1.0f)) * _1398) + 0.5f)), 0.0f);
              float _1418 = (_1346 * 2.0f) + -1.0f;
              float _1422 = sqrt((_1418 * _1418) + 1.0f);
              float _1423 = 1.0f / _1422;
              float _1426 = (_1422 * _994) * (_1423 + _992);
              float4 _1437 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1375 * _1418) * _1426) + 0.5f), ((((_1375 * ((_1347 * 2.0f) + -1.0f)) * (((_1423 + -1.0f) * _993) + 1.0f)) * _1426) + 0.5f)), 0.0f);
              float _1446 = (_1348 * 2.0f) + -1.0f;
              float _1450 = sqrt((_1446 * _1446) + 1.0f);
              float _1451 = 1.0f / _1450;
              float _1454 = (_1450 * _994) * (_1451 + _992);
              float4 _1465 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1375 * _1446) * _1454) + 0.5f), ((((_1375 * ((_1349 * 2.0f) + -1.0f)) * (((_1451 + -1.0f) * _993) + 1.0f)) * _1454) + 0.5f)), 0.0f);
              float _1474 = (_1350 * 2.0f) + -1.0f;
              float _1478 = sqrt((_1474 * _1474) + 1.0f);
              float _1479 = 1.0f / _1478;
              float _1482 = (_1478 * _994) * (_1479 + _992);
              float4 _1493 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1375 * _1474) * _1482) + 0.5f), ((((_1375 * ((_1351 * 2.0f) + -1.0f)) * (((_1479 + -1.0f) * _993) + 1.0f)) * _1482) + 0.5f)), 0.0f);
              float _1502 = (_1352 * 2.0f) + -1.0f;
              float _1506 = sqrt((_1502 * _1502) + 1.0f);
              float _1507 = 1.0f / _1506;
              float _1510 = (_1506 * _994) * (_1507 + _992);
              float4 _1521 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1375 * _1502) * _1510) + 0.5f), ((((_1375 * ((_1353 * 2.0f) + -1.0f)) * (((_1507 + -1.0f) * _993) + 1.0f)) * _1510) + 0.5f)), 0.0f);
              float _1530 = (_1354 * 2.0f) + -1.0f;
              float _1534 = sqrt((_1530 * _1530) + 1.0f);
              float _1535 = 1.0f / _1534;
              float _1538 = (_1534 * _994) * (_1535 + _992);
              float4 _1549 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1375 * _1530) * _1538) + 0.5f), ((((_1375 * ((_1355 * 2.0f) + -1.0f)) * (((_1535 + -1.0f) * _993) + 1.0f)) * _1538) + 0.5f)), 0.0f);
              float _1558 = (_1356 * 2.0f) + -1.0f;
              float _1562 = sqrt((_1558 * _1558) + 1.0f);
              float _1563 = 1.0f / _1562;
              float _1566 = (_1562 * _994) * (_1563 + _992);
              float4 _1577 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1375 * _1558) * _1566) + 0.5f), ((((_1375 * ((_1357 * 2.0f) + -1.0f)) * (((_1563 + -1.0f) * _993) + 1.0f)) * _1566) + 0.5f)), 0.0f);
              float _1586 = (_1358 * 2.0f) + -1.0f;
              float _1590 = sqrt((_1586 * _1586) + 1.0f);
              float _1591 = 1.0f / _1590;
              float _1594 = (_1590 * _994) * (_1591 + _992);
              float4 _1605 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1375 * _1586) * _1594) + 0.5f), ((((_1375 * ((_1359 * 2.0f) + -1.0f)) * (((_1591 + -1.0f) * _993) + 1.0f)) * _1594) + 0.5f)), 0.0f);
              _1675 = ((((((((_1409.x + _1384.x) + _1437.x) + _1465.x) + _1493.x) + _1521.x) + _1549.x) + _1577.x) + _1605.x);
              _1676 = ((((((((_1409.y + _1384.y) + _1437.y) + _1465.y) + _1493.y) + _1521.y) + _1549.y) + _1577.y) + _1605.y);
              _1677 = ((((((((_1409.z + _1384.z) + _1437.z) + _1465.z) + _1493.z) + _1521.z) + _1549.z) + _1577.z) + _1605.z);
            } else {
              float4 _1614 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1341, _1343), 0.0f);
              float4 _1618 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1344, _1345), 0.0f);
              float4 _1625 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1346, _1347), 0.0f);
              float4 _1632 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1348, _1349), 0.0f);
              float4 _1639 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1350, _1351), 0.0f);
              float4 _1646 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1352, _1353), 0.0f);
              float4 _1653 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1354, _1355), 0.0f);
              float4 _1660 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1356, _1357), 0.0f);
              float4 _1667 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1358, _1359), 0.0f);
              _1675 = ((((((((_1618.x + _1614.x) + _1625.x) + _1632.x) + _1639.x) + _1646.x) + _1653.x) + _1660.x) + _1667.x);
              _1676 = ((((((((_1618.y + _1614.y) + _1625.y) + _1632.y) + _1639.y) + _1646.y) + _1653.y) + _1660.y) + _1667.y);
              _1677 = ((((((((_1618.z + _1614.z) + _1625.z) + _1632.z) + _1639.z) + _1646.z) + _1653.z) + _1660.z) + _1667.z);
            }
          }
          float _1687 = (((_1677 * _1018) + _997) * 0.10000000149011612f) * cbRadialColor.z;
          float _1688 = (((_1676 * _1018) + _989) * 0.10000000149011612f) * cbRadialColor.y;
          float _1689 = (((_1675 * _1018) + _988) * 0.10000000149011612f) * cbRadialColor.x;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1698 = saturate((sqrt((_1037 * _1037) + (_1039 * _1039)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1704 = (((_1698 * _1698) * cbRadialMaskRate.x) * (3.0f - (_1698 * 2.0f))) + cbRadialMaskRate.y;
              _1715 = ((_1704 * (_1689 - _988)) + _988);
              _1716 = ((_1704 * (_1688 - _989)) + _989);
              _1717 = ((_1704 * (_1687 - _997)) + _997);
            } else {
              _1715 = _1689;
              _1716 = _1688;
              _1717 = _1687;
            }
            _1728 = (lerp(_988, _1715, _1028));
            _1729 = (lerp(_989, _1716, _1028));
            _1730 = (lerp(_997, _1717, _1028));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1728 = _988;
      _1729 = _989;
      _1730 = _997;
    }
  } else {
    _1728 = _988;
    _1729 = _989;
    _1730 = _997;
  }
  float _1745 = mad(_1730, (fOCIOTransformMatrix[2].x), mad(_1729, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1728)));
  float _1748 = mad(_1730, (fOCIOTransformMatrix[2].y), mad(_1729, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1728)));
  float _1751 = mad(_1730, (fOCIOTransformMatrix[2].z), mad(_1729, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1728)));

  bool film_grain = CUSTOM_FILM_GRAIN_TYPE == 1 ? false : !((cPassEnabled & 2) == 0);

  if (film_grain) {
    float _1768 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1770 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1774 = frac(frac(dot(float2(_1768, _1770), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_1774 < fNoiseDensity) {
        int _1779 = (uint)(uint(_1770 * _1768)) ^ 12345391;
        uint _1780 = _1779 * 3635641;
        _1788 = (float((uint)((int)((((uint)(_1780) >> 26) | ((uint)(_1779 * 232681024))) ^ _1780))) * 2.3283064365386963e-10f);
      } else {
        _1788 = 0.0f;
      }
      float _1790 = frac(_1774 * 757.4846801757812f);
      do {
        if (_1790 < fNoiseDensity) {
          int _1794 = asint(_1790) ^ 12345391;
          uint _1795 = _1794 * 3635641;
          _1804 = ((float((uint)((int)((((uint)(_1795) >> 26) | ((uint)(_1794 * 232681024))) ^ _1795))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1804 = 0.0f;
        }
        float _1806 = frac(_1790 * 757.4846801757812f);
        do {
          if (_1806 < fNoiseDensity) {
            int _1810 = asint(_1806) ^ 12345391;
            uint _1811 = _1810 * 3635641;
            _1820 = ((float((uint)((int)((((uint)(_1811) >> 26) | ((uint)(_1810 * 232681024))) ^ _1811))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1820 = 0.0f;
          }
          float _1821 = _1788 * fNoisePower.x;
          float _1822 = _1820 * fNoisePower.y;
          float _1823 = _1804 * fNoisePower.y;
          float _1837 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1745), saturate(_1748), saturate(_1751)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1848 = ((_1837 * (mad(_1823, 1.4019999504089355f, _1821) - _1745)) + _1745);
          _1849 = ((_1837 * (mad(_1823, -0.7139999866485596f, mad(_1822, -0.3440000116825104f, _1821)) - _1748)) + _1748);
          _1850 = ((_1837 * (mad(_1822, 1.7719999551773071f, _1821) - _1751)) + _1751);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1848 = _1745;
    _1849 = _1748;
    _1850 = _1751;
  }
  if (!((cPassEnabled & 4) == 0)) {
    float _1896 = (((log2(select((_1848 < 3.0517578125e-05f), ((_1848 * 0.5f) + 1.52587890625e-05f), _1848)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1897 = (((log2(select((_1849 < 3.0517578125e-05f), ((_1849 * 0.5f) + 1.52587890625e-05f), _1849)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1898 = (((log2(select((_1850 < 3.0517578125e-05f), ((_1850 * 0.5f) + 1.52587890625e-05f), _1850)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _1901 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1896, _1897, _1898), 0.0f);
    float _1907 = exp2((_1901.x * 17.520000457763672f) + -9.720000267028809f);
    float _1910 = exp2((_1901.y * 17.520000457763672f) + -9.720000267028809f);
    float _1913 = exp2((_1901.z * 17.520000457763672f) + -9.720000267028809f);
    bool _1915 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1918 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1896, _1897, _1898), 0.0f);
        float _1937 = ((exp2((_1918.x * 17.520000457763672f) + -9.720000267028809f) - _1907) * fTextureBlendRate) + _1907;
        float _1938 = ((exp2((_1918.y * 17.520000457763672f) + -9.720000267028809f) - _1910) * fTextureBlendRate) + _1910;
        float _1939 = ((exp2((_1918.z * 17.520000457763672f) + -9.720000267028809f) - _1913) * fTextureBlendRate) + _1913;
        if (_1915) {
          float4 _1969 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1937 < 3.0517578125e-05f), ((_1937 * 0.5f) + 1.52587890625e-05f), _1937)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1938 < 3.0517578125e-05f), ((_1938 * 0.5f) + 1.52587890625e-05f), _1938)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1939 < 3.0517578125e-05f), ((_1939 * 0.5f) + 1.52587890625e-05f), _1939)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _2044 = (((exp2((_1969.x * 17.520000457763672f) + -9.720000267028809f) - _1937) * fTextureBlendRate2) + _1937);
          _2045 = (((exp2((_1969.y * 17.520000457763672f) + -9.720000267028809f) - _1938) * fTextureBlendRate2) + _1938);
          _2046 = (((exp2((_1969.z * 17.520000457763672f) + -9.720000267028809f) - _1939) * fTextureBlendRate2) + _1939);
        } else {
          _2044 = _1937;
          _2045 = _1938;
          _2046 = _1939;
        }
      } else {
        if (_1915) {
          float4 _2021 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1907 < 3.0517578125e-05f), ((_1907 * 0.5f) + 1.52587890625e-05f), _1907)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1910 < 3.0517578125e-05f), ((_1910 * 0.5f) + 1.52587890625e-05f), _1910)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1913 < 3.0517578125e-05f), ((_1913 * 0.5f) + 1.52587890625e-05f), _1913)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _2044 = (((exp2((_2021.x * 17.520000457763672f) + -9.720000267028809f) - _1907) * fTextureBlendRate2) + _1907);
          _2045 = (((exp2((_2021.y * 17.520000457763672f) + -9.720000267028809f) - _1910) * fTextureBlendRate2) + _1910);
          _2046 = (((exp2((_2021.z * 17.520000457763672f) + -9.720000267028809f) - _1913) * fTextureBlendRate2) + _1913);
        } else {
          _2044 = _1907;
          _2045 = _1910;
          _2046 = _1913;
        }
      }
      _2057 = mad(_2046, (fColorMatrix[2].x), mad(_2045, (fColorMatrix[1].x), (_2044 * (fColorMatrix[0].x))));
      _2058 = mad(_2046, (fColorMatrix[2].y), mad(_2045, (fColorMatrix[1].y), (_2044 * (fColorMatrix[0].y))));
      _2059 = mad(_2046, (fColorMatrix[2].z), mad(_2045, (fColorMatrix[1].z), (_2044 * (fColorMatrix[0].z))));
    } while (false);
  } else {
    _2057 = _1848;
    _2058 = _1849;
    _2059 = _1850;
  }
  bool _2062 = isfinite(max(max(_2057, _2058), _2059));
  float _2063 = select(_2062, _2057, 1.0f);
  float _2064 = select(_2062, _2058, 1.0f);
  float _2065 = select(_2062, _2059, 1.0f);
  if (!((cPassEnabled & 8) == 0)) {
    _2100 = saturate(((cvdR.x * _2063) + (cvdR.y * _2064)) + (cvdR.z * _2065));
    _2101 = saturate(((cvdG.x * _2063) + (cvdG.y * _2064)) + (cvdG.z * _2065));
    _2102 = saturate(((cvdB.x * _2063) + (cvdB.y * _2064)) + (cvdB.z * _2065));
  } else {
    _2100 = _2063;
    _2101 = _2064;
    _2102 = _2065;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2117 = screenInverseSize.x * SV_Position.x;
    float _2118 = screenInverseSize.y * SV_Position.y;
    float4 _2121 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2117, _2118), 0.0f);
    float _2126 = _2121.x * ColorParam.x;
    float _2127 = _2121.y * ColorParam.y;
    float _2128 = _2121.z * ColorParam.z;
    float _2131 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2117, _2118), 0.0f);
    float _2136 = (_2121.w * ColorParam.w) * saturate((_2131.x * Levels_Rate) + Levels_Range);
    do {
      if (_2126 < 0.5f) {
        _2148 = ((_2100 * 2.0f) * _2126);
      } else {
        _2148 = (1.0f - (((1.0f - _2100) * 2.0f) * (1.0f - _2126)));
      }
      do {
        if (_2127 < 0.5f) {
          _2160 = ((_2101 * 2.0f) * _2127);
        } else {
          _2160 = (1.0f - (((1.0f - _2101) * 2.0f) * (1.0f - _2127)));
        }
        do {
          if (_2128 < 0.5f) {
            _2172 = ((_2102 * 2.0f) * _2128);
          } else {
            _2172 = (1.0f - (((1.0f - _2102) * 2.0f) * (1.0f - _2128)));
          }
          _2183 = (lerp(_2100, _2148, _2136));
          _2184 = (lerp(_2101, _2160, _2136));
          _2185 = (lerp(_2102, _2172, _2136));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2183 = _2100;
    _2184 = _2101;
    _2185 = _2102;
  }
  SV_Target.x = _2183;
  SV_Target.y = _2184;
  SV_Target.z = _2185;
  SV_Target.w = 0.0f;
  return SV_Target;
}
