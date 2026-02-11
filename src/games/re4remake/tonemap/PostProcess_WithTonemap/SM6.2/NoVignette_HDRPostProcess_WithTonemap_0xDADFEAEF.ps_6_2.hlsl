#define SHADER_HASH 0xDADFEAEF

#include "../../tonemap.hlsli"

Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> RE_POSTPROCESS_Color : register(t1);

Texture2D<float> tFilterTempMap1 : register(t2);

Texture3D<float> tVolumeMap : register(t3);

struct RadialBlurComputeResult {  // decomp missed this
  float computeAlpha;
};

StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t4);

// Texture3D<float4> tTextureMap0 : register(t5);

// Texture3D<float4> tTextureMap1 : register(t6);

// Texture3D<float4> tTextureMap2 : register(t7);

Texture2D<float4> ImagePlameBase : register(t8);

Texture2D<float> ImagePlameAlpha : register(t9);

cbuffer SceneInfo : register(b0) {
  float4 viewProjMat[4] : packoffset(c000.x);
  float4 transposeViewMat[3] : packoffset(c004.x);
  float4 transposeViewInvMat[3] : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  float4 viewProjInvMat[4] : packoffset(c014.x);
  float4 prevViewProjMat[4] : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[6] : packoffset(c025.x);
  float4 clipplane : packoffset(c031.x);
  float2 vrsVelocityThreshold : packoffset(c032.x);
  uint GPUVisibleMask : packoffset(c032.z);
  uint resolutionRatioPacked : packoffset(c032.w);
};

// cbuffer TonemapParam : register(b1) {
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
// };

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

// cbuffer ColorCorrectTexture : register(b7) {
//   float fTextureSize : packoffset(c000.x);
//   float fTextureBlendRate : packoffset(c000.y);
//   float fTextureBlendRate2 : packoffset(c000.z);
//   float fTextureInverseSize : packoffset(c000.w);
//   float4 fColorMatrix[4] : packoffset(c001.x);
// };

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

// cbuffer CBControl : register(b10) {
//   uint cPassEnabled : packoffset(c000.x);
// };

SamplerState PointClamp : register(s1, space32);

SamplerState BilinearWrap : register(s4, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

// SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  bool _33 = ((cPassEnabled & 1) != 0);
  bool _37 = _33 && (bool)(distortionType == 0);
  bool _39 = _33 && (bool)(distortionType == 1);
  bool _41 = ((cPassEnabled & 64) != 0);
  float _161;
  float _162;
  float _292;
  float _293;
  float _304;
  float _305;
  float _309;
  float _310;
  float _489;
  float _543;
  float _722;
  float _723;
  float _853;
  float _854;
  float _865;
  float _866;
  float _870;
  float _871;
  float _1079;
  float _1080;
  float _1212;
  float _1213;
  float _1224;
  float _1225;
  float _1233;
  float _1234;
  float _1235;
  float _1341;
  float _1342;
  float _1343;
  float _1344;
  float _1345;
  float _1346;
  float _1347;
  float _1348;
  float _1349;
  float _1793;
  float _1794;
  float _1795;
  float _2182;
  float _2183;
  float _2184;
  float _2360;
  float _2361;
  float _2362;
  float _2373;
  float _2374;
  float _2375;
  float _2401;
  float _2402;
  float _2403;
  float _2414;
  float _2415;
  float _2416;
  float _2458;
  float _2474;
  float _2490;
  float _2518;
  float _2519;
  float _2520;
  float _2552;
  float _2553;
  float _2554;
  float _2566;
  float _2577;
  float _2588;
  float _2627;
  float _2638;
  float _2649;
  float _2675;
  float _2686;
  float _2697;
  float _2712;
  float _2713;
  float _2714;
  float _2732;
  float _2733;
  float _2734;
  float _2769;
  float _2770;
  float _2771;
  float _2840;
  float _2841;
  float _2842;
  if (_37) {
    float _54 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _55 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _56 = dot(float2(_54, _55), float2(_54, _55));
    float _59 = ((_56 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float _60 = _59 * _54;
    float _61 = _59 * _55;
    float _62 = _60 + 0.5f;
    float _63 = _61 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        if (_41) {
          bool _72 = ((fHazeFilterAttribute & 2) != 0);
          float _75 = tFilterTempMap1.Sample(BilinearWrap, float2(_62, _63));
          do {
            if (_72) {
              float _78 = ReadonlyDepth.SampleLevel(PointClamp, float2(_62, _63), 0.0f);
              float _86 = (((_62 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
              float _87 = 1.0f - (((_63 * 2.0f) * screenSize.y) * screenInverseSize.y);
              float _124 = 1.0f / (mad(_78.x, (viewProjInvMat[2].w), mad(_87, (viewProjInvMat[1].w), (_86 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _126 = _124 * (mad(_78.x, (viewProjInvMat[2].y), mad(_87, (viewProjInvMat[1].y), (_86 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _134 = (_124 * (mad(_78.x, (viewProjInvMat[2].x), mad(_87, (viewProjInvMat[1].x), (_86 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _135 = _126 - (transposeViewInvMat[1].w);
              float _136 = (_124 * (mad(_78.x, (viewProjInvMat[2].z), mad(_87, (viewProjInvMat[1].z), (_86 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _161 = saturate(_75.x * max(((sqrt(((_135 * _135) + (_134 * _134)) + (_136 * _136)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_126 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _162 = _78.x;
            } else {
              _161 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _75.x), _75.x);
              _162 = 0.0f;
            }
            float _167 = -0.0f - _63;
            float _190 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_167, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _62)));
            float _191 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_167, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _62)));
            float _192 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_167, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _62)));
            float _196 = tVolumeMap.Sample(BilinearWrap, float3((_190 + fHazeFilterUVWOffset.x), (_191 + fHazeFilterUVWOffset.y), (_192 + fHazeFilterUVWOffset.z)));
            float _199 = _190 * 2.0f;
            float _200 = _191 * 2.0f;
            float _201 = _192 * 2.0f;
            float _205 = tVolumeMap.Sample(BilinearWrap, float3((_199 + fHazeFilterUVWOffset.x), (_200 + fHazeFilterUVWOffset.y), (_201 + fHazeFilterUVWOffset.z)));
            float _209 = _190 * 4.0f;
            float _210 = _191 * 4.0f;
            float _211 = _192 * 4.0f;
            float _215 = tVolumeMap.Sample(BilinearWrap, float3((_209 + fHazeFilterUVWOffset.x), (_210 + fHazeFilterUVWOffset.y), (_211 + fHazeFilterUVWOffset.z)));
            float _219 = _190 * 8.0f;
            float _220 = _191 * 8.0f;
            float _221 = _192 * 8.0f;
            float _225 = tVolumeMap.Sample(BilinearWrap, float3((_219 + fHazeFilterUVWOffset.x), (_220 + fHazeFilterUVWOffset.y), (_221 + fHazeFilterUVWOffset.z)));
            float _229 = fHazeFilterUVWOffset.x + 0.5f;
            float _230 = fHazeFilterUVWOffset.y + 0.5f;
            float _231 = fHazeFilterUVWOffset.z + 0.5f;
            float _235 = tVolumeMap.Sample(BilinearWrap, float3((_190 + _229), (_191 + _230), (_192 + _231)));
            float _241 = tVolumeMap.Sample(BilinearWrap, float3((_199 + _229), (_200 + _230), (_201 + _231)));
            float _248 = tVolumeMap.Sample(BilinearWrap, float3((_209 + _229), (_210 + _230), (_211 + _231)));
            float _255 = tVolumeMap.Sample(BilinearWrap, float3((_219 + _229), (_220 + _230), (_221 + _231)));
            float _266 = (((((((_205.x * 0.25f) + (_196.x * 0.5f)) + (_215.x * 0.125f)) + (_225.x * 0.0625f)) * 2.0f) + -1.0f) * _161) * fHazeFilterScale;
            float _268 = (fHazeFilterScale * _161) * ((((((_241.x * 0.25f) + (_235.x * 0.5f)) + (_248.x * 0.125f)) + (_255.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _279 = 0.5f / fHazeFilterBorder;
                float _286 = saturate(max(((_279 * min(max((abs(_60) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_279 * min(max((abs(_61) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _292 = (_266 - (_286 * _266));
                _293 = (_268 - (_286 * _268));
              } else {
                _292 = _266;
                _293 = _268;
              }
              do {
                if (_72) {
                  float _297 = ReadonlyDepth.Sample(BilinearWrap, float2((_292 + _62), (_293 + _63)));
                  if (!(!((_297.x - _162) >= fHazeFilterDepthDiffBias))) {
                    _304 = 0.0f;
                    _305 = 0.0f;
                  } else {
                    _304 = _292;
                    _305 = _293;
                  }
                } else {
                  _304 = _292;
                  _305 = _293;
                }
                _309 = (_304 + _62);
                _310 = (_305 + _63);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _309 = _62;
          _310 = _63;
        }
        float4 _311 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_309, _310));
        float _315 = _311.x * Exposure;
        float _316 = _311.y * Exposure;
        float _317 = _311.z * Exposure;
        if (isfinite(max(max(_315, _316), _317))) {
          float _326 = invLinearBegin * _315;
          float _332 = invLinearBegin * _316;
          float _338 = invLinearBegin * _317;
          float _345 = select((_315 >= linearBegin), 0.0f, (1.0f - ((_326 * _326) * (3.0f - (_326 * 2.0f)))));
          float _347 = select((_316 >= linearBegin), 0.0f, (1.0f - ((_332 * _332) * (3.0f - (_332 * 2.0f)))));
          float _349 = select((_317 >= linearBegin), 0.0f, (1.0f - ((_338 * _338) * (3.0f - (_338 * 2.0f)))));
          float _355 = select((_315 < linearStart), 0.0f, 1.0f);
          float _356 = select((_316 < linearStart), 0.0f, 1.0f);
          float _357 = select((_317 < linearStart), 0.0f, 1.0f);
          _1341 = (((((contrast * _315) + madLinearStartContrastFactor) * ((1.0f - _355) - _345)) + (((pow(_326, toe))*_345) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _315) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _355));
          _1342 = (((((contrast * _316) + madLinearStartContrastFactor) * ((1.0f - _356) - _347)) + (((pow(_332, toe))*_347) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _316) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _356));
          _1343 = (((((contrast * _317) + madLinearStartContrastFactor) * ((1.0f - _357) - _349)) + (((pow(_338, toe))*_349) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _317) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _357));
          _1344 = fDistortionCoef;
          _1345 = 0.0f;
          _1346 = 0.0f;
          _1347 = 0.0f;
          _1348 = 0.0f;
          _1349 = fCorrectCoef;
        } else {
          _1341 = 1.0f;
          _1342 = 1.0f;
          _1343 = 1.0f;
          _1344 = fDistortionCoef;
          _1345 = 0.0f;
          _1346 = 0.0f;
          _1347 = 0.0f;
          _1348 = 0.0f;
          _1349 = fCorrectCoef;
        }
      } while (false);
    } else {
      float _420 = _56 + fRefraction;
      float _422 = (_420 * fDistortionCoef) + 1.0f;
      float _423 = _54 * fCorrectCoef;
      float _425 = _55 * fCorrectCoef;
      float _431 = ((_420 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _436 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_62, _63));
      float _440 = _436.x * Exposure;
      do {
        if (isfinite(max(max(_440, (_436.y * Exposure)), (_436.z * Exposure)))) {
          float _451 = invLinearBegin * _440;
          float _458 = select((_440 >= linearBegin), 0.0f, (1.0f - ((_451 * _451) * (3.0f - (_451 * 2.0f)))));
          float _462 = select((_440 < linearStart), 0.0f, 1.0f);
          _489 = (((((contrast * _440) + madLinearStartContrastFactor) * ((1.0f - _462) - _458)) + ((linearBegin * (pow(_451, toe))) * _458)) + ((maxNit - (exp2((contrastFactor * _440) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _462));
        } else {
          _489 = 1.0f;
        }
        float4 _490 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_423 * _422) + 0.5f), ((_425 * _422) + 0.5f)));
        float _495 = _490.y * Exposure;
        do {
          if (isfinite(max(max((_490.x * Exposure), _495), (_490.z * Exposure)))) {
            float _505 = invLinearBegin * _495;
            float _512 = select((_495 >= linearBegin), 0.0f, (1.0f - ((_505 * _505) * (3.0f - (_505 * 2.0f)))));
            float _516 = select((_495 < linearStart), 0.0f, 1.0f);
            _543 = (((((contrast * _495) + madLinearStartContrastFactor) * ((1.0f - _516) - _512)) + ((linearBegin * (pow(_505, toe))) * _512)) + ((maxNit - (exp2((contrastFactor * _495) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _516));
          } else {
            _543 = 1.0f;
          }
          float4 _544 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_423 * _431) + 0.5f), ((_425 * _431) + 0.5f)));
          float _550 = _544.z * Exposure;
          if (isfinite(max(max((_544.x * Exposure), (_544.y * Exposure)), _550))) {
            float _559 = invLinearBegin * _550;
            float _566 = select((_550 >= linearBegin), 0.0f, (1.0f - ((_559 * _559) * (3.0f - (_559 * 2.0f)))));
            float _570 = select((_550 < linearStart), 0.0f, 1.0f);
            _1341 = _489;
            _1342 = _543;
            _1343 = (((((contrast * _550) + madLinearStartContrastFactor) * ((1.0f - _570) - _566)) + ((linearBegin * (pow(_559, toe))) * _566)) + ((maxNit - (exp2((contrastFactor * _550) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _570));
            _1344 = fDistortionCoef;
            _1345 = 0.0f;
            _1346 = 0.0f;
            _1347 = 0.0f;
            _1348 = 0.0f;
            _1349 = fCorrectCoef;
          } else {
            _1341 = _489;
            _1342 = _543;
            _1343 = 1.0f;
            _1344 = fDistortionCoef;
            _1345 = 0.0f;
            _1346 = 0.0f;
            _1347 = 0.0f;
            _1348 = 0.0f;
            _1349 = fCorrectCoef;
          }
        } while (false);
      } while (false);
    }
  } else {
    if (_39) {
      float _607 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _611 = sqrt((_607 * _607) + 1.0f);
      float _612 = 1.0f / _611;
      float _615 = (_611 * fOptimizedParam.z) * (_612 + fOptimizedParam.x);
      float _619 = fOptimizedParam.w * 0.5f;
      float _621 = (_619 * _607) * _615;
      float _624 = ((_619 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_612 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _615;
      float _625 = _621 + 0.5f;
      float _626 = _624 + 0.5f;
      do {
        if (_41) {
          bool _633 = ((fHazeFilterAttribute & 2) != 0);
          float _636 = tFilterTempMap1.Sample(BilinearWrap, float2(_625, _626));
          do {
            if (_633) {
              float _639 = ReadonlyDepth.SampleLevel(PointClamp, float2(_625, _626), 0.0f);
              float _647 = (((screenSize.x * 2.0f) * _625) * screenInverseSize.x) + -1.0f;
              float _648 = 1.0f - (((screenSize.y * 2.0f) * _626) * screenInverseSize.y);
              float _685 = 1.0f / (mad(_639.x, (viewProjInvMat[2].w), mad(_648, (viewProjInvMat[1].w), (_647 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _687 = _685 * (mad(_639.x, (viewProjInvMat[2].y), mad(_648, (viewProjInvMat[1].y), (_647 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _695 = (_685 * (mad(_639.x, (viewProjInvMat[2].x), mad(_648, (viewProjInvMat[1].x), (_647 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _696 = _687 - (transposeViewInvMat[1].w);
              float _697 = (_685 * (mad(_639.x, (viewProjInvMat[2].z), mad(_648, (viewProjInvMat[1].z), (_647 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _722 = saturate(_636.x * max(((sqrt(((_696 * _696) + (_695 * _695)) + (_697 * _697)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_687 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _723 = _639.x;
            } else {
              _722 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _636.x), _636.x);
              _723 = 0.0f;
            }
            float _728 = -0.0f - _626;
            float _751 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_728, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _625)));
            float _752 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_728, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _625)));
            float _753 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_728, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _625)));
            float _757 = tVolumeMap.Sample(BilinearWrap, float3((_751 + fHazeFilterUVWOffset.x), (_752 + fHazeFilterUVWOffset.y), (_753 + fHazeFilterUVWOffset.z)));
            float _760 = _751 * 2.0f;
            float _761 = _752 * 2.0f;
            float _762 = _753 * 2.0f;
            float _766 = tVolumeMap.Sample(BilinearWrap, float3((_760 + fHazeFilterUVWOffset.x), (_761 + fHazeFilterUVWOffset.y), (_762 + fHazeFilterUVWOffset.z)));
            float _770 = _751 * 4.0f;
            float _771 = _752 * 4.0f;
            float _772 = _753 * 4.0f;
            float _776 = tVolumeMap.Sample(BilinearWrap, float3((_770 + fHazeFilterUVWOffset.x), (_771 + fHazeFilterUVWOffset.y), (_772 + fHazeFilterUVWOffset.z)));
            float _780 = _751 * 8.0f;
            float _781 = _752 * 8.0f;
            float _782 = _753 * 8.0f;
            float _786 = tVolumeMap.Sample(BilinearWrap, float3((_780 + fHazeFilterUVWOffset.x), (_781 + fHazeFilterUVWOffset.y), (_782 + fHazeFilterUVWOffset.z)));
            float _790 = fHazeFilterUVWOffset.x + 0.5f;
            float _791 = fHazeFilterUVWOffset.y + 0.5f;
            float _792 = fHazeFilterUVWOffset.z + 0.5f;
            float _796 = tVolumeMap.Sample(BilinearWrap, float3((_751 + _790), (_752 + _791), (_753 + _792)));
            float _802 = tVolumeMap.Sample(BilinearWrap, float3((_760 + _790), (_761 + _791), (_762 + _792)));
            float _809 = tVolumeMap.Sample(BilinearWrap, float3((_770 + _790), (_771 + _791), (_772 + _792)));
            float _816 = tVolumeMap.Sample(BilinearWrap, float3((_780 + _790), (_781 + _791), (_782 + _792)));
            float _827 = (((((((_766.x * 0.25f) + (_757.x * 0.5f)) + (_776.x * 0.125f)) + (_786.x * 0.0625f)) * 2.0f) + -1.0f) * _722) * fHazeFilterScale;
            float _829 = (fHazeFilterScale * _722) * ((((((_802.x * 0.25f) + (_796.x * 0.5f)) + (_809.x * 0.125f)) + (_816.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _840 = 0.5f / fHazeFilterBorder;
                float _847 = saturate(max(((_840 * min(max((abs(_621) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_840 * min(max((abs(_624) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _853 = (_827 - (_847 * _827));
                _854 = (_829 - (_847 * _829));
              } else {
                _853 = _827;
                _854 = _829;
              }
              do {
                if (_633) {
                  float _858 = ReadonlyDepth.Sample(BilinearWrap, float2((_853 + _625), (_854 + _626)));
                  if (!(!((_858.x - _723) >= fHazeFilterDepthDiffBias))) {
                    _865 = 0.0f;
                    _866 = 0.0f;
                  } else {
                    _865 = _853;
                    _866 = _854;
                  }
                } else {
                  _865 = _853;
                  _866 = _854;
                }
                _870 = (_865 + _625);
                _871 = (_866 + _626);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _870 = _625;
          _871 = _626;
        }
        float4 _872 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_870, _871));
        float _876 = _872.x * Exposure;
        float _877 = _872.y * Exposure;
        float _878 = _872.z * Exposure;
        if (isfinite(max(max(_876, _877), _878))) {
          float _887 = invLinearBegin * _876;
          float _893 = invLinearBegin * _877;
          float _899 = invLinearBegin * _878;
          float _906 = select((_876 >= linearBegin), 0.0f, (1.0f - ((_887 * _887) * (3.0f - (_887 * 2.0f)))));
          float _908 = select((_877 >= linearBegin), 0.0f, (1.0f - ((_893 * _893) * (3.0f - (_893 * 2.0f)))));
          float _910 = select((_878 >= linearBegin), 0.0f, (1.0f - ((_899 * _899) * (3.0f - (_899 * 2.0f)))));
          float _916 = select((_876 < linearStart), 0.0f, 1.0f);
          float _917 = select((_877 < linearStart), 0.0f, 1.0f);
          float _918 = select((_878 < linearStart), 0.0f, 1.0f);
          _1341 = (((((contrast * _876) + madLinearStartContrastFactor) * ((1.0f - _916) - _906)) + (((pow(_887, toe))*_906) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _876) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _916));
          _1342 = (((((contrast * _877) + madLinearStartContrastFactor) * ((1.0f - _917) - _908)) + (((pow(_893, toe))*_908) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _877) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _917));
          _1343 = (((((contrast * _878) + madLinearStartContrastFactor) * ((1.0f - _918) - _910)) + (((pow(_899, toe))*_910) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _878) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _918));
          _1344 = 0.0f;
          _1345 = fOptimizedParam.x;
          _1346 = fOptimizedParam.y;
          _1347 = fOptimizedParam.z;
          _1348 = fOptimizedParam.w;
          _1349 = 1.0f;
        } else {
          _1341 = 1.0f;
          _1342 = 1.0f;
          _1343 = 1.0f;
          _1344 = 0.0f;
          _1345 = fOptimizedParam.x;
          _1346 = fOptimizedParam.y;
          _1347 = fOptimizedParam.z;
          _1348 = fOptimizedParam.w;
          _1349 = 1.0f;
        }
      } while (false);
    } else {
      float _981 = screenInverseSize.x * SV_Position.x;
      float _982 = screenInverseSize.y * SV_Position.y;
      do {
        if (!_41) {
          float4 _984 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_981, _982));
          _1233 = _984.x;
          _1234 = _984.y;
          _1235 = _984.z;
        } else {
          bool _992 = ((fHazeFilterAttribute & 2) != 0);
          float _995 = tFilterTempMap1.Sample(BilinearWrap, float2(_981, _982));
          do {
            if (_992) {
              float _998 = ReadonlyDepth.SampleLevel(PointClamp, float2(_981, _982), 0.0f);
              float _1004 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
              float _1005 = 1.0f - ((SV_Position.y * 2.0f) * screenInverseSize.y);
              float _1042 = 1.0f / (mad(_998.x, (viewProjInvMat[2].w), mad(_1005, (viewProjInvMat[1].w), (_1004 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _1044 = _1042 * (mad(_998.x, (viewProjInvMat[2].y), mad(_1005, (viewProjInvMat[1].y), (_1004 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _1052 = (_1042 * (mad(_998.x, (viewProjInvMat[2].x), mad(_1005, (viewProjInvMat[1].x), (_1004 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _1053 = _1044 - (transposeViewInvMat[1].w);
              float _1054 = (_1042 * (mad(_998.x, (viewProjInvMat[2].z), mad(_1005, (viewProjInvMat[1].z), (_1004 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _1079 = saturate(_995.x * max(((sqrt(((_1053 * _1053) + (_1052 * _1052)) + (_1054 * _1054)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_1044 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _1080 = _998.x;
            } else {
              _1079 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _995.x), _995.x);
              _1080 = 0.0f;
            }
            float _1085 = -0.0f - _982;
            float _1108 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_1085, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _981)));
            float _1109 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_1085, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _981)));
            float _1110 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_1085, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _981)));
            float _1114 = tVolumeMap.Sample(BilinearWrap, float3((_1108 + fHazeFilterUVWOffset.x), (_1109 + fHazeFilterUVWOffset.y), (_1110 + fHazeFilterUVWOffset.z)));
            float _1117 = _1108 * 2.0f;
            float _1118 = _1109 * 2.0f;
            float _1119 = _1110 * 2.0f;
            float _1123 = tVolumeMap.Sample(BilinearWrap, float3((_1117 + fHazeFilterUVWOffset.x), (_1118 + fHazeFilterUVWOffset.y), (_1119 + fHazeFilterUVWOffset.z)));
            float _1127 = _1108 * 4.0f;
            float _1128 = _1109 * 4.0f;
            float _1129 = _1110 * 4.0f;
            float _1133 = tVolumeMap.Sample(BilinearWrap, float3((_1127 + fHazeFilterUVWOffset.x), (_1128 + fHazeFilterUVWOffset.y), (_1129 + fHazeFilterUVWOffset.z)));
            float _1137 = _1108 * 8.0f;
            float _1138 = _1109 * 8.0f;
            float _1139 = _1110 * 8.0f;
            float _1143 = tVolumeMap.Sample(BilinearWrap, float3((_1137 + fHazeFilterUVWOffset.x), (_1138 + fHazeFilterUVWOffset.y), (_1139 + fHazeFilterUVWOffset.z)));
            float _1147 = fHazeFilterUVWOffset.x + 0.5f;
            float _1148 = fHazeFilterUVWOffset.y + 0.5f;
            float _1149 = fHazeFilterUVWOffset.z + 0.5f;
            float _1153 = tVolumeMap.Sample(BilinearWrap, float3((_1108 + _1147), (_1109 + _1148), (_1110 + _1149)));
            float _1159 = tVolumeMap.Sample(BilinearWrap, float3((_1117 + _1147), (_1118 + _1148), (_1119 + _1149)));
            float _1166 = tVolumeMap.Sample(BilinearWrap, float3((_1127 + _1147), (_1128 + _1148), (_1129 + _1149)));
            float _1173 = tVolumeMap.Sample(BilinearWrap, float3((_1137 + _1147), (_1138 + _1148), (_1139 + _1149)));
            float _1184 = (((((((_1123.x * 0.25f) + (_1114.x * 0.5f)) + (_1133.x * 0.125f)) + (_1143.x * 0.0625f)) * 2.0f) + -1.0f) * _1079) * fHazeFilterScale;
            float _1186 = (fHazeFilterScale * _1079) * ((((((_1159.x * 0.25f) + (_1153.x * 0.5f)) + (_1166.x * 0.125f)) + (_1173.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _1199 = 0.5f / fHazeFilterBorder;
                float _1206 = saturate(max(((_1199 * min(max((abs(_981 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_1199 * min(max((abs(_982 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _1212 = (_1184 - (_1206 * _1184));
                _1213 = (_1186 - (_1206 * _1186));
              } else {
                _1212 = _1184;
                _1213 = _1186;
              }
              do {
                if (_992) {
                  float _1217 = ReadonlyDepth.Sample(BilinearWrap, float2((_1212 + _981), (_1213 + _982)));
                  if (!(!((_1217.x - _1080) >= fHazeFilterDepthDiffBias))) {
                    _1224 = 0.0f;
                    _1225 = 0.0f;
                  } else {
                    _1224 = _1212;
                    _1225 = _1213;
                  }
                } else {
                  _1224 = _1212;
                  _1225 = _1213;
                }
                float4 _1228 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1224 + _981), (_1225 + _982)));
                _1233 = _1228.x;
                _1234 = _1228.y;
                _1235 = _1228.z;
              } while (false);
            } while (false);
          } while (false);
        }
        float _1236 = _1233 * Exposure;
        float _1237 = _1234 * Exposure;
        float _1238 = _1235 * Exposure;
        if (isfinite(max(max(_1236, _1237), _1238))) {
          float _1247 = invLinearBegin * _1236;
          float _1253 = invLinearBegin * _1237;
          float _1259 = invLinearBegin * _1238;
          float _1266 = select((_1236 >= linearBegin), 0.0f, (1.0f - ((_1247 * _1247) * (3.0f - (_1247 * 2.0f)))));
          float _1268 = select((_1237 >= linearBegin), 0.0f, (1.0f - ((_1253 * _1253) * (3.0f - (_1253 * 2.0f)))));
          float _1270 = select((_1238 >= linearBegin), 0.0f, (1.0f - ((_1259 * _1259) * (3.0f - (_1259 * 2.0f)))));
          float _1276 = select((_1236 < linearStart), 0.0f, 1.0f);
          float _1277 = select((_1237 < linearStart), 0.0f, 1.0f);
          float _1278 = select((_1238 < linearStart), 0.0f, 1.0f);
          _1341 = (((((contrast * _1236) + madLinearStartContrastFactor) * ((1.0f - _1276) - _1266)) + (((pow(_1247, toe))*_1266) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1236) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1276));
          _1342 = (((((contrast * _1237) + madLinearStartContrastFactor) * ((1.0f - _1277) - _1268)) + (((pow(_1253, toe))*_1268) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1237) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1277));
          _1343 = (((((contrast * _1238) + madLinearStartContrastFactor) * ((1.0f - _1278) - _1270)) + (((pow(_1259, toe))*_1270) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1238) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1278));
          _1344 = 0.0f;
          _1345 = 0.0f;
          _1346 = 0.0f;
          _1347 = 0.0f;
          _1348 = 0.0f;
          _1349 = 1.0f;
        } else {
          _1341 = 1.0f;
          _1342 = 1.0f;
          _1343 = 1.0f;
          _1344 = 0.0f;
          _1345 = 0.0f;
          _1346 = 0.0f;
          _1347 = 0.0f;
          _1348 = 0.0f;
          _1349 = 1.0f;
        }
      } while (false);
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _1371 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1374 = ComputeResultSRV[0].computeAlpha;
    float _1377 = ((1.0f - _1371) + (_1374 * _1371)) * cbRadialColor.w;
    if (!(_1377 == 0.0f)) {
      float _1384 = screenInverseSize.x * SV_Position.x;
      float _1385 = screenInverseSize.y * SV_Position.y;
      float _1387 = (-0.5f - cbRadialScreenPos.x) + _1384;
      float _1389 = (-0.5f - cbRadialScreenPos.y) + _1385;
      float _1392 = select((_1387 < 0.0f), (1.0f - _1384), _1384);
      float _1395 = select((_1389 < 0.0f), (1.0f - _1385), _1385);
      float _1400 = rsqrt(dot(float2(_1387, _1389), float2(_1387, _1389))) * cbRadialSharpRange;
      uint _1407 = uint(abs(_1400 * _1389)) + uint(abs(_1400 * _1387));
      uint _1411 = ((_1407 ^ 61) ^ ((uint)(_1407) >> 16)) * 9;
      uint _1414 = (((uint)(_1411) >> 4) ^ _1411) * 668265261;
      float _1419 = select(((cbRadialBlurFlags & 1) != 0), (float((uint)((int)(((uint)(_1414) >> 15) ^ _1414))) * 2.3283064365386963e-10f), 1.0f);
      float _1425 = 1.0f / max(1.0f, sqrt((_1387 * _1387) + (_1389 * _1389)));
      float _1426 = cbRadialBlurPower * -0.0011111111380159855f;
      float _1435 = ((((_1426 * _1392) * _1419) * _1425) + 1.0f) * _1387;
      float _1436 = ((((_1426 * _1395) * _1419) * _1425) + 1.0f) * _1389;
      float _1437 = cbRadialBlurPower * -0.002222222276031971f;
      float _1446 = ((((_1437 * _1392) * _1419) * _1425) + 1.0f) * _1387;
      float _1447 = ((((_1437 * _1395) * _1419) * _1425) + 1.0f) * _1389;
      float _1448 = cbRadialBlurPower * -0.0033333334140479565f;
      float _1457 = ((((_1448 * _1392) * _1419) * _1425) + 1.0f) * _1387;
      float _1458 = ((((_1448 * _1395) * _1419) * _1425) + 1.0f) * _1389;
      float _1459 = cbRadialBlurPower * -0.004444444552063942f;
      float _1468 = ((((_1459 * _1392) * _1419) * _1425) + 1.0f) * _1387;
      float _1469 = ((((_1459 * _1395) * _1419) * _1425) + 1.0f) * _1389;
      float _1470 = cbRadialBlurPower * -0.0055555556900799274f;
      float _1479 = ((((_1470 * _1392) * _1419) * _1425) + 1.0f) * _1387;
      float _1480 = ((((_1470 * _1395) * _1419) * _1425) + 1.0f) * _1389;
      float _1481 = cbRadialBlurPower * -0.006666666828095913f;
      float _1490 = ((((_1481 * _1392) * _1419) * _1425) + 1.0f) * _1387;
      float _1491 = ((((_1481 * _1395) * _1419) * _1425) + 1.0f) * _1389;
      float _1492 = cbRadialBlurPower * -0.007777777966111898f;
      float _1501 = ((((_1492 * _1392) * _1419) * _1425) + 1.0f) * _1387;
      float _1502 = ((((_1492 * _1395) * _1419) * _1425) + 1.0f) * _1389;
      float _1503 = cbRadialBlurPower * -0.008888889104127884f;
      float _1512 = ((((_1503 * _1392) * _1419) * _1425) + 1.0f) * _1387;
      float _1513 = ((((_1503 * _1395) * _1419) * _1425) + 1.0f) * _1389;
      float _1514 = cbRadialBlurPower * -0.009999999776482582f;
      float _1523 = ((((_1514 * _1392) * _1419) * _1425) + 1.0f) * _1387;
      float _1524 = ((((_1514 * _1395) * _1419) * _1425) + 1.0f) * _1389;
      float _1525 = Exposure * 0.10000000149011612f;
      float _1526 = _1525 * cbRadialColor.x;
      float _1527 = _1525 * cbRadialColor.y;
      float _1528 = _1525 * cbRadialColor.z;
      do {
        if (_37) {
          float _1530 = _1435 + cbRadialScreenPos.x;
          float _1531 = _1436 + cbRadialScreenPos.y;
          float _1535 = ((dot(float2(_1530, _1531), float2(_1530, _1531)) * _1344) + 1.0f) * _1349;
          float4 _1540 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1535 * _1530) + 0.5f), ((_1535 * _1531) + 0.5f)), 0.0f);
          float _1544 = _1446 + cbRadialScreenPos.x;
          float _1545 = _1447 + cbRadialScreenPos.y;
          float _1548 = (dot(float2(_1544, _1545), float2(_1544, _1545)) * _1344) + 1.0f;
          float4 _1555 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1544 * _1349) * _1548) + 0.5f), (((_1545 * _1349) * _1548) + 0.5f)), 0.0f);
          float _1562 = _1457 + cbRadialScreenPos.x;
          float _1563 = _1458 + cbRadialScreenPos.y;
          float _1566 = (dot(float2(_1562, _1563), float2(_1562, _1563)) * _1344) + 1.0f;
          float4 _1573 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1562 * _1349) * _1566) + 0.5f), (((_1563 * _1349) * _1566) + 0.5f)), 0.0f);
          float _1580 = _1468 + cbRadialScreenPos.x;
          float _1581 = _1469 + cbRadialScreenPos.y;
          float _1584 = (dot(float2(_1580, _1581), float2(_1580, _1581)) * _1344) + 1.0f;
          float4 _1591 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1580 * _1349) * _1584) + 0.5f), (((_1581 * _1349) * _1584) + 0.5f)), 0.0f);
          float _1598 = _1479 + cbRadialScreenPos.x;
          float _1599 = _1480 + cbRadialScreenPos.y;
          float _1602 = (dot(float2(_1598, _1599), float2(_1598, _1599)) * _1344) + 1.0f;
          float4 _1609 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1598 * _1349) * _1602) + 0.5f), (((_1599 * _1349) * _1602) + 0.5f)), 0.0f);
          float _1616 = _1490 + cbRadialScreenPos.x;
          float _1617 = _1491 + cbRadialScreenPos.y;
          float _1620 = (dot(float2(_1616, _1617), float2(_1616, _1617)) * _1344) + 1.0f;
          float4 _1627 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1616 * _1349) * _1620) + 0.5f), (((_1617 * _1349) * _1620) + 0.5f)), 0.0f);
          float _1634 = _1501 + cbRadialScreenPos.x;
          float _1635 = _1502 + cbRadialScreenPos.y;
          float _1638 = (dot(float2(_1634, _1635), float2(_1634, _1635)) * _1344) + 1.0f;
          float4 _1645 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1634 * _1349) * _1638) + 0.5f), (((_1635 * _1349) * _1638) + 0.5f)), 0.0f);
          float _1652 = _1512 + cbRadialScreenPos.x;
          float _1653 = _1513 + cbRadialScreenPos.y;
          float _1656 = (dot(float2(_1652, _1653), float2(_1652, _1653)) * _1344) + 1.0f;
          float4 _1663 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1652 * _1349) * _1656) + 0.5f), (((_1653 * _1349) * _1656) + 0.5f)), 0.0f);
          float _1670 = _1523 + cbRadialScreenPos.x;
          float _1671 = _1524 + cbRadialScreenPos.y;
          float _1674 = (dot(float2(_1670, _1671), float2(_1670, _1671)) * _1344) + 1.0f;
          float4 _1681 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1670 * _1349) * _1674) + 0.5f), (((_1671 * _1349) * _1674) + 0.5f)), 0.0f);
          float _1688 = _1526 * ((((((((_1555.x + _1540.x) + _1573.x) + _1591.x) + _1609.x) + _1627.x) + _1645.x) + _1663.x) + _1681.x);
          float _1689 = _1527 * ((((((((_1555.y + _1540.y) + _1573.y) + _1591.y) + _1609.y) + _1627.y) + _1645.y) + _1663.y) + _1681.y);
          float _1690 = _1528 * ((((((((_1555.z + _1540.z) + _1573.z) + _1591.z) + _1609.z) + _1627.z) + _1645.z) + _1663.z) + _1681.z);
          do {
            if (isfinite(max(max(_1688, _1689), _1690))) {
              float _1699 = invLinearBegin * _1688;
              float _1705 = invLinearBegin * _1689;
              float _1711 = invLinearBegin * _1690;
              float _1718 = select((_1688 >= linearBegin), 0.0f, (1.0f - ((_1699 * _1699) * (3.0f - (_1699 * 2.0f)))));
              float _1720 = select((_1689 >= linearBegin), 0.0f, (1.0f - ((_1705 * _1705) * (3.0f - (_1705 * 2.0f)))));
              float _1722 = select((_1690 >= linearBegin), 0.0f, (1.0f - ((_1711 * _1711) * (3.0f - (_1711 * 2.0f)))));
              float _1728 = select((_1688 < linearStart), 0.0f, 1.0f);
              float _1729 = select((_1689 < linearStart), 0.0f, 1.0f);
              float _1730 = select((_1690 < linearStart), 0.0f, 1.0f);
              _1793 = (((((contrast * _1688) + madLinearStartContrastFactor) * ((1.0f - _1728) - _1718)) + (((pow(_1699, toe))*_1718) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1688) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1728));
              _1794 = (((((contrast * _1689) + madLinearStartContrastFactor) * ((1.0f - _1729) - _1720)) + (((pow(_1705, toe))*_1720) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1689) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1729));
              _1795 = (((((contrast * _1690) + madLinearStartContrastFactor) * ((1.0f - _1730) - _1722)) + (((pow(_1711, toe))*_1722) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1690) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1730));
            } else {
              _1793 = 1.0f;
              _1794 = 1.0f;
              _1795 = 1.0f;
            }
            _2373 = (_1793 + ((_1341 * 0.10000000149011612f) * cbRadialColor.x));
            _2374 = (_1794 + ((_1342 * 0.10000000149011612f) * cbRadialColor.y));
            _2375 = (_1795 + ((_1343 * 0.10000000149011612f) * cbRadialColor.z));
          } while (false);
        } else {
          float _1806 = cbRadialScreenPos.x + 0.5f;
          float _1807 = _1806 + _1435;
          float _1808 = cbRadialScreenPos.y + 0.5f;
          float _1809 = _1808 + _1436;
          float _1810 = _1806 + _1446;
          float _1811 = _1808 + _1447;
          float _1812 = _1806 + _1457;
          float _1813 = _1808 + _1458;
          float _1814 = _1806 + _1468;
          float _1815 = _1808 + _1469;
          float _1816 = _1806 + _1479;
          float _1817 = _1808 + _1480;
          float _1818 = _1806 + _1490;
          float _1819 = _1808 + _1491;
          float _1820 = _1806 + _1501;
          float _1821 = _1808 + _1502;
          float _1822 = _1806 + _1512;
          float _1823 = _1808 + _1513;
          float _1824 = _1806 + _1523;
          float _1825 = _1808 + _1524;
          if (_39) {
            float _1829 = (_1807 * 2.0f) + -1.0f;
            float _1833 = sqrt((_1829 * _1829) + 1.0f);
            float _1834 = 1.0f / _1833;
            float _1837 = (_1833 * _1347) * (_1834 + _1345);
            float _1841 = _1348 * 0.5f;
            float4 _1849 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1841 * _1837) * _1829) + 0.5f), ((((_1841 * (((_1834 + -1.0f) * _1346) + 1.0f)) * _1837) * ((_1809 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _1855 = (_1810 * 2.0f) + -1.0f;
            float _1859 = sqrt((_1855 * _1855) + 1.0f);
            float _1860 = 1.0f / _1859;
            float _1863 = (_1859 * _1347) * (_1860 + _1345);
            float4 _1874 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1841 * _1855) * _1863) + 0.5f), ((((_1841 * ((_1811 * 2.0f) + -1.0f)) * (((_1860 + -1.0f) * _1346) + 1.0f)) * _1863) + 0.5f)), 0.0f);
            float _1883 = (_1812 * 2.0f) + -1.0f;
            float _1887 = sqrt((_1883 * _1883) + 1.0f);
            float _1888 = 1.0f / _1887;
            float _1891 = (_1887 * _1347) * (_1888 + _1345);
            float4 _1902 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1841 * _1883) * _1891) + 0.5f), ((((_1841 * ((_1813 * 2.0f) + -1.0f)) * (((_1888 + -1.0f) * _1346) + 1.0f)) * _1891) + 0.5f)), 0.0f);
            float _1911 = (_1814 * 2.0f) + -1.0f;
            float _1915 = sqrt((_1911 * _1911) + 1.0f);
            float _1916 = 1.0f / _1915;
            float _1919 = (_1915 * _1347) * (_1916 + _1345);
            float4 _1930 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1841 * _1911) * _1919) + 0.5f), ((((_1841 * ((_1815 * 2.0f) + -1.0f)) * (((_1916 + -1.0f) * _1346) + 1.0f)) * _1919) + 0.5f)), 0.0f);
            float _1939 = (_1816 * 2.0f) + -1.0f;
            float _1943 = sqrt((_1939 * _1939) + 1.0f);
            float _1944 = 1.0f / _1943;
            float _1947 = (_1943 * _1347) * (_1944 + _1345);
            float4 _1958 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1841 * _1939) * _1947) + 0.5f), ((((_1841 * ((_1817 * 2.0f) + -1.0f)) * (((_1944 + -1.0f) * _1346) + 1.0f)) * _1947) + 0.5f)), 0.0f);
            float _1967 = (_1818 * 2.0f) + -1.0f;
            float _1971 = sqrt((_1967 * _1967) + 1.0f);
            float _1972 = 1.0f / _1971;
            float _1975 = (_1971 * _1347) * (_1972 + _1345);
            float4 _1986 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1841 * _1967) * _1975) + 0.5f), ((((_1841 * ((_1819 * 2.0f) + -1.0f)) * (((_1972 + -1.0f) * _1346) + 1.0f)) * _1975) + 0.5f)), 0.0f);
            float _1995 = (_1820 * 2.0f) + -1.0f;
            float _1999 = sqrt((_1995 * _1995) + 1.0f);
            float _2000 = 1.0f / _1999;
            float _2003 = (_1999 * _1347) * (_2000 + _1345);
            float4 _2014 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1841 * _1995) * _2003) + 0.5f), ((((_1841 * ((_1821 * 2.0f) + -1.0f)) * (((_2000 + -1.0f) * _1346) + 1.0f)) * _2003) + 0.5f)), 0.0f);
            float _2023 = (_1822 * 2.0f) + -1.0f;
            float _2027 = sqrt((_2023 * _2023) + 1.0f);
            float _2028 = 1.0f / _2027;
            float _2031 = (_2027 * _1347) * (_2028 + _1345);
            float4 _2042 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1841 * _2023) * _2031) + 0.5f), ((((_1841 * ((_1823 * 2.0f) + -1.0f)) * (((_2028 + -1.0f) * _1346) + 1.0f)) * _2031) + 0.5f)), 0.0f);
            float _2051 = (_1824 * 2.0f) + -1.0f;
            float _2055 = sqrt((_2051 * _2051) + 1.0f);
            float _2056 = 1.0f / _2055;
            float _2059 = (_2055 * _1347) * (_2056 + _1345);
            float4 _2070 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1841 * _2051) * _2059) + 0.5f), ((((_1841 * ((_1825 * 2.0f) + -1.0f)) * (((_2056 + -1.0f) * _1346) + 1.0f)) * _2059) + 0.5f)), 0.0f);
            float _2077 = _1526 * ((((((((_1874.x + _1849.x) + _1902.x) + _1930.x) + _1958.x) + _1986.x) + _2014.x) + _2042.x) + _2070.x);
            float _2078 = _1527 * ((((((((_1874.y + _1849.y) + _1902.y) + _1930.y) + _1958.y) + _1986.y) + _2014.y) + _2042.y) + _2070.y);
            float _2079 = _1528 * ((((((((_1874.z + _1849.z) + _1902.z) + _1930.z) + _1958.z) + _1986.z) + _2014.z) + _2042.z) + _2070.z);
            do {
              if (isfinite(max(max(_2077, _2078), _2079))) {
                float _2088 = invLinearBegin * _2077;
                float _2094 = invLinearBegin * _2078;
                float _2100 = invLinearBegin * _2079;
                float _2107 = select((_2077 >= linearBegin), 0.0f, (1.0f - ((_2088 * _2088) * (3.0f - (_2088 * 2.0f)))));
                float _2109 = select((_2078 >= linearBegin), 0.0f, (1.0f - ((_2094 * _2094) * (3.0f - (_2094 * 2.0f)))));
                float _2111 = select((_2079 >= linearBegin), 0.0f, (1.0f - ((_2100 * _2100) * (3.0f - (_2100 * 2.0f)))));
                float _2117 = select((_2077 < linearStart), 0.0f, 1.0f);
                float _2118 = select((_2078 < linearStart), 0.0f, 1.0f);
                float _2119 = select((_2079 < linearStart), 0.0f, 1.0f);
                _2182 = (((((contrast * _2077) + madLinearStartContrastFactor) * ((1.0f - _2117) - _2107)) + (((pow(_2088, toe))*_2107) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2077) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2117));
                _2183 = (((((contrast * _2078) + madLinearStartContrastFactor) * ((1.0f - _2118) - _2109)) + (((pow(_2094, toe))*_2109) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2078) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2118));
                _2184 = (((((contrast * _2079) + madLinearStartContrastFactor) * ((1.0f - _2119) - _2111)) + (((pow(_2100, toe))*_2111) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2079) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2119));
              } else {
                _2182 = 1.0f;
                _2183 = 1.0f;
                _2184 = 1.0f;
              }
              _2373 = (_2182 + ((_1341 * 0.10000000149011612f) * cbRadialColor.x));
              _2374 = (_2183 + ((_1342 * 0.10000000149011612f) * cbRadialColor.y));
              _2375 = (_2184 + ((_1343 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          } else {
            float4 _2195 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1807, _1809), 0.0f);
            float4 _2199 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1810, _1811), 0.0f);
            float4 _2206 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1812, _1813), 0.0f);
            float4 _2213 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1814, _1815), 0.0f);
            float4 _2220 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1816, _1817), 0.0f);
            float4 _2227 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1818, _1819), 0.0f);
            float4 _2234 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1820, _1821), 0.0f);
            float4 _2241 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1822, _1823), 0.0f);
            float4 _2248 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1824, _1825), 0.0f);
            float _2255 = _1526 * ((((((((_2199.x + _2195.x) + _2206.x) + _2213.x) + _2220.x) + _2227.x) + _2234.x) + _2241.x) + _2248.x);
            float _2256 = _1527 * ((((((((_2199.y + _2195.y) + _2206.y) + _2213.y) + _2220.y) + _2227.y) + _2234.y) + _2241.y) + _2248.y);
            float _2257 = _1528 * ((((((((_2199.z + _2195.z) + _2206.z) + _2213.z) + _2220.z) + _2227.z) + _2234.z) + _2241.z) + _2248.z);
            do {
              if (isfinite(max(max(_2255, _2256), _2257))) {
                float _2266 = invLinearBegin * _2255;
                float _2272 = invLinearBegin * _2256;
                float _2278 = invLinearBegin * _2257;
                float _2285 = select((_2255 >= linearBegin), 0.0f, (1.0f - ((_2266 * _2266) * (3.0f - (_2266 * 2.0f)))));
                float _2287 = select((_2256 >= linearBegin), 0.0f, (1.0f - ((_2272 * _2272) * (3.0f - (_2272 * 2.0f)))));
                float _2289 = select((_2257 >= linearBegin), 0.0f, (1.0f - ((_2278 * _2278) * (3.0f - (_2278 * 2.0f)))));
                float _2295 = select((_2255 < linearStart), 0.0f, 1.0f);
                float _2296 = select((_2256 < linearStart), 0.0f, 1.0f);
                float _2297 = select((_2257 < linearStart), 0.0f, 1.0f);
                _2360 = (((((contrast * _2255) + madLinearStartContrastFactor) * ((1.0f - _2295) - _2285)) + (((pow(_2266, toe))*_2285) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2255) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2295));
                _2361 = (((((contrast * _2256) + madLinearStartContrastFactor) * ((1.0f - _2296) - _2287)) + (((pow(_2272, toe))*_2287) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2256) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2296));
                _2362 = (((((contrast * _2257) + madLinearStartContrastFactor) * ((1.0f - _2297) - _2289)) + (((pow(_2278, toe))*_2289) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2257) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2297));
              } else {
                _2360 = 1.0f;
                _2361 = 1.0f;
                _2362 = 1.0f;
              }
              _2373 = (_2360 + ((_1341 * 0.10000000149011612f) * cbRadialColor.x));
              _2374 = (_2361 + ((_1342 * 0.10000000149011612f) * cbRadialColor.y));
              _2375 = (_2362 + ((_1343 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          }
        }
        do {
          if (cbRadialMaskRate.x > 0.0f) {
            float _2384 = saturate((sqrt((_1387 * _1387) + (_1389 * _1389)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
            float _2390 = (((_2384 * _2384) * cbRadialMaskRate.x) * (3.0f - (_2384 * 2.0f))) + cbRadialMaskRate.y;
            _2401 = ((_2390 * (_2373 - _1341)) + _1341);
            _2402 = ((_2390 * (_2374 - _1342)) + _1342);
            _2403 = ((_2390 * (_2375 - _1343)) + _1343);
          } else {
            _2401 = _2373;
            _2402 = _2374;
            _2403 = _2375;
          }
          _2414 = (lerp(_1341, _2401, _1377));
          _2415 = (lerp(_1342, _2402, _1377));
          _2416 = (lerp(_1343, _2403, _1377));
        } while (false);
      } while (false);
    } else {
      _2414 = _1341;
      _2415 = _1342;
      _2416 = _1343;
    }
  } else {
    _2414 = _1341;
    _2415 = _1342;
    _2416 = _1343;
  }
  if (!((cPassEnabled & 2) == 0) && (CUSTOM_NOISE != 0.f)) {
#if 1
    float3 noise_input = float3(_2414, _2415, _2416);
#endif

    float _2438 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
    float _2440 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
    float _2444 = frac(frac(dot(float2(_2438, _2440), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_2444 < fNoiseDensity) {
        int _2449 = (uint)(uint(_2440 * _2438)) ^ 12345391;
        uint _2450 = _2449 * 3635641;
        _2458 = (float((uint)((int)((((uint)(_2450) >> 26) | ((uint)(_2449 * 232681024))) ^ _2450))) * 2.3283064365386963e-10f);
      } else {
        _2458 = 0.0f;
      }
      float _2460 = frac(_2444 * 757.4846801757812f);
      do {
        if (_2460 < fNoiseDensity) {
          int _2464 = asint(_2460) ^ 12345391;
          uint _2465 = _2464 * 3635641;
          _2474 = ((float((uint)((int)((((uint)(_2465) >> 26) | ((uint)(_2464 * 232681024))) ^ _2465))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _2474 = 0.0f;
        }
        float _2476 = frac(_2460 * 757.4846801757812f);
        do {
          if (_2476 < fNoiseDensity) {
            int _2480 = asint(_2476) ^ 12345391;
            uint _2481 = _2480 * 3635641;
            _2490 = ((float((uint)((int)((((uint)(_2481) >> 26) | ((uint)(_2480 * 232681024))) ^ _2481))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _2490 = 0.0f;
          }
          float _2491 = _2458 * fNoisePower.x;
          float _2492 = _2490 * fNoisePower.y;
          float _2493 = _2474 * fNoisePower.y;
          float _2507 = exp2(log2(1.0f - saturate(dot(float3(saturate(_2414), saturate(_2415), saturate(_2416)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _2518 = ((_2507 * (mad(_2493, 1.4019999504089355f, _2491) - _2414)) + _2414);
          _2519 = ((_2507 * (mad(_2493, -0.7139999866485596f, mad(_2492, -0.3440000116825104f, _2491)) - _2415)) + _2415);
          _2520 = ((_2507 * (mad(_2492, 1.7719999551773071f, _2491) - _2416)) + _2416);
        } while (false);
      } while (false);
    } while (false);
#if 1
    _2518 = lerp(noise_input.r, _2518, CUSTOM_NOISE);
    _2519 = lerp(noise_input.g, _2519, CUSTOM_NOISE);
    _2520 = lerp(noise_input.b, _2520, CUSTOM_NOISE);
#endif
  } else {
    _2518 = _2414;
    _2519 = _2415;
    _2520 = _2416;
  }

#if 1
  ApplyColorGrading(_2518, _2519, _2520,
                    _2732, _2733, _2734);
#else
  if (!((cPassEnabled & 4) == 0)) {
    float _2545 = max(max(_2518, _2519), _2520);
    bool _2546 = (_2545 > 1.0f);
    do {
      if (_2546) {
        _2552 = (_2518 / _2545);
        _2553 = (_2519 / _2545);
        _2554 = (_2520 / _2545);
      } else {
        _2552 = _2518;
        _2553 = _2519;
        _2554 = _2520;
      }
      float _2555 = fTextureInverseSize * 0.5f;
      do {
        [branch]
        if (!(!(_2552 <= 0.0031308000907301903f))) {
          _2566 = (_2552 * 12.920000076293945f);
        } else {
          _2566 = (((pow(_2552, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          [branch]
          if (!(!(_2553 <= 0.0031308000907301903f))) {
            _2577 = (_2553 * 12.920000076293945f);
          } else {
            _2577 = (((pow(_2553, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            [branch]
            if (!(!(_2554 <= 0.0031308000907301903f))) {
              _2588 = (_2554 * 12.920000076293945f);
            } else {
              _2588 = (((pow(_2554, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            float _2589 = 1.0f - fTextureInverseSize;
            float _2593 = (_2566 * _2589) + _2555;
            float _2594 = (_2577 * _2589) + _2555;
            float _2595 = (_2588 * _2589) + _2555;
            float4 _2596 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2593, _2594, _2595), 0.0f);
            bool _2601 = (fTextureBlendRate2 > 0.0f);
            do {
              [branch]
              if (fTextureBlendRate > 0.0f) {
                float4 _2603 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2593, _2594, _2595), 0.0f);
                float _2613 = ((_2603.x - _2596.x) * fTextureBlendRate) + _2596.x;
                float _2614 = ((_2603.y - _2596.y) * fTextureBlendRate) + _2596.y;
                float _2615 = ((_2603.z - _2596.z) * fTextureBlendRate) + _2596.z;
                if (_2601) {
                  do {
                    [branch]
                    if (!(!(_2613 <= 0.0031308000907301903f))) {
                      _2627 = (_2613 * 12.920000076293945f);
                    } else {
                      _2627 = (((pow(_2613, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_2614 <= 0.0031308000907301903f))) {
                        _2638 = (_2614 * 12.920000076293945f);
                      } else {
                        _2638 = (((pow(_2614, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_2615 <= 0.0031308000907301903f))) {
                          _2649 = (_2615 * 12.920000076293945f);
                        } else {
                          _2649 = (((pow(_2615, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _2650 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2627, _2638, _2649), 0.0f);
                        _2712 = (lerp(_2613, _2650.x, fTextureBlendRate2));
                        _2713 = (lerp(_2614, _2650.y, fTextureBlendRate2));
                        _2714 = (lerp(_2615, _2650.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _2712 = _2613;
                  _2713 = _2614;
                  _2714 = _2615;
                }
              } else {
                if (_2601) {
                  do {
                    [branch]
                    if (!(!(_2596.x <= 0.0031308000907301903f))) {
                      _2675 = (_2596.x * 12.920000076293945f);
                    } else {
                      _2675 = (((pow(_2596.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_2596.y <= 0.0031308000907301903f))) {
                        _2686 = (_2596.y * 12.920000076293945f);
                      } else {
                        _2686 = (((pow(_2596.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_2596.z <= 0.0031308000907301903f))) {
                          _2697 = (_2596.z * 12.920000076293945f);
                        } else {
                          _2697 = (((pow(_2596.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _2698 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2675, _2686, _2697), 0.0f);
                        _2712 = (lerp(_2596.x, _2698.x, fTextureBlendRate2));
                        _2713 = (lerp(_2596.y, _2698.y, fTextureBlendRate2));
                        _2714 = (lerp(_2596.z, _2698.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _2712 = _2596.x;
                  _2713 = _2596.y;
                  _2714 = _2596.z;
                }
              }
              float _2718 = mad(_2714, (fColorMatrix[2].x), mad(_2713, (fColorMatrix[1].x), (_2712 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
              float _2722 = mad(_2714, (fColorMatrix[2].y), mad(_2713, (fColorMatrix[1].y), (_2712 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
              float _2726 = mad(_2714, (fColorMatrix[2].z), mad(_2713, (fColorMatrix[1].z), (_2712 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
              if (_2546) {
                _2732 = (_2718 * _2545);
                _2733 = (_2722 * _2545);
                _2734 = (_2726 * _2545);
              } else {
                _2732 = _2718;
                _2733 = _2722;
                _2734 = _2726;
              }
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2732 = _2518;
    _2733 = _2519;
    _2734 = _2520;
  }
#endif
  if (!((cPassEnabled & 8) == 0)) {
    _2769 = saturate(((cvdR.x * _2732) + (cvdR.y * _2733)) + (cvdR.z * _2734));
    _2770 = saturate(((cvdG.x * _2732) + (cvdG.y * _2733)) + (cvdG.z * _2734));
    _2771 = saturate(((cvdB.x * _2732) + (cvdB.y * _2733)) + (cvdB.z * _2734));
  } else {
    _2769 = _2732;
    _2770 = _2733;
    _2771 = _2734;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2786 = screenInverseSize.x * SV_Position.x;
    float _2787 = screenInverseSize.y * SV_Position.y;
    float4 _2788 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2786, _2787), 0.0f);
    float _2793 = _2788.x * ColorParam.x;
    float _2794 = _2788.y * ColorParam.y;
    float _2795 = _2788.z * ColorParam.z;
    float _2797 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2786, _2787), 0.0f);
    float _2802 = (_2788.w * ColorParam.w) * saturate((_2797.x * Levels_Rate) + Levels_Range);
    _2840 = (((select((_2793 < 0.5f), ((_2769 * 2.0f) * _2793), (1.0f - (((1.0f - _2769) * 2.0f) * (1.0f - _2793)))) - _2769) * _2802) + _2769);
    _2841 = (((select((_2794 < 0.5f), ((_2770 * 2.0f) * _2794), (1.0f - (((1.0f - _2770) * 2.0f) * (1.0f - _2794)))) - _2770) * _2802) + _2770);
    _2842 = (((select((_2795 < 0.5f), ((_2771 * 2.0f) * _2795), (1.0f - (((1.0f - _2771) * 2.0f) * (1.0f - _2795)))) - _2771) * _2802) + _2771);
  } else {
    _2840 = _2769;
    _2841 = _2770;
    _2842 = _2771;
  }
  SV_Target.x = _2840;
  SV_Target.y = _2841;
  SV_Target.z = _2842;
  SV_Target.w = 0.0f;

#if 1
  float2 grain_uv = SV_Position.xy * screenInverseSize;
  SV_Target.rgb = ApplyToneMap(SV_Target.rgb, grain_uv);
#endif

  return SV_Target;
}
