#define SHADER_HASH 0x7FE82B7A

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

cbuffer CameraKerare : register(b1) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
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
// };

cbuffer CBHazeFilterParams : register(b3) {
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

cbuffer LensDistortionParam : register(b4) {
  float fDistortionCoef : packoffset(c000.x);
  float fRefraction : packoffset(c000.y);
  uint aberrationEnable : packoffset(c000.z);
  uint distortionType : packoffset(c000.w);
  float fCorrectCoef : packoffset(c001.x);
  uint reserve1 : packoffset(c001.y);
  uint reserve2 : packoffset(c001.z);
  uint reserve3 : packoffset(c001.w);
};

cbuffer PaniniProjectionParam : register(b5) {
  float4 fOptimizedParam : packoffset(c000.x);
};

cbuffer RadialBlurRenderParam : register(b6) {
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

cbuffer FilmGrainParam : register(b7) {
  float2 fNoisePower : packoffset(c000.x);
  float2 fNoiseUVOffset : packoffset(c000.z);
  float fNoiseDensity : packoffset(c001.x);
  float fNoiseContrast : packoffset(c001.y);
  float fBlendRate : packoffset(c001.z);
  float fReverseNoiseSize : packoffset(c001.w);
};

// cbuffer ColorCorrectTexture : register(b8) {
//   float fTextureSize : packoffset(c000.x);
//   float fTextureBlendRate : packoffset(c000.y);
//   float fTextureBlendRate2 : packoffset(c000.z);
//   float fTextureInverseSize : packoffset(c000.w);
//   float4 fColorMatrix[4] : packoffset(c001.x);
// };

cbuffer ColorDeficientTable : register(b9) {
  float4 cvdR : packoffset(c000.x);
  float4 cvdG : packoffset(c001.x);
  float4 cvdB : packoffset(c002.x);
};

cbuffer ImagePlaneParam : register(b10) {
  float4 ColorParam : packoffset(c000.x);
  float Levels_Rate : packoffset(c001.x);
  float Levels_Range : packoffset(c001.y);
  uint Blend_Type : packoffset(c001.z);
};

// cbuffer CBControl : register(b11) {
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
  bool _38 = ((cPassEnabled & 1) != 0);
  bool _42 = _38 && (bool)(distortionType == 0);
  bool _44 = _38 && (bool)(distortionType == 1);
  bool _46 = ((cPassEnabled & 64) != 0);
  float _49 = Kerare.x / Kerare.w;
  float _50 = Kerare.y / Kerare.w;
  float _51 = Kerare.z / Kerare.w;
  float _55 = abs(rsqrt(dot(float3(_49, _50, _51), float3(_49, _50, _51))) * _51);
  float _62 = _55 * _55;
  float _66 = saturate(((_62 * _62) * (1.0f - saturate((kerare_scale * _55) + kerare_offset))) + kerare_brightness);
  float _67 = _66 * Exposure;
  float _187;
  float _188;
  float _318;
  float _319;
  float _330;
  float _331;
  float _335;
  float _336;
  float _515;
  float _569;
  float _748;
  float _749;
  float _879;
  float _880;
  float _891;
  float _892;
  float _896;
  float _897;
  float _1105;
  float _1106;
  float _1238;
  float _1239;
  float _1250;
  float _1251;
  float _1259;
  float _1260;
  float _1261;
  float _1367;
  float _1368;
  float _1369;
  float _1370;
  float _1371;
  float _1372;
  float _1373;
  float _1374;
  float _1375;
  float _1820;
  float _1821;
  float _1822;
  float _2209;
  float _2210;
  float _2211;
  float _2387;
  float _2388;
  float _2389;
  float _2400;
  float _2401;
  float _2402;
  float _2428;
  float _2429;
  float _2430;
  float _2441;
  float _2442;
  float _2443;
  float _2485;
  float _2501;
  float _2517;
  float _2545;
  float _2546;
  float _2547;
  float _2579;
  float _2580;
  float _2581;
  float _2593;
  float _2604;
  float _2615;
  float _2654;
  float _2665;
  float _2676;
  float _2702;
  float _2713;
  float _2724;
  float _2739;
  float _2740;
  float _2741;
  float _2759;
  float _2760;
  float _2761;
  float _2796;
  float _2797;
  float _2798;
  float _2867;
  float _2868;
  float _2869;
  if (_42) {
    float _80 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _81 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _82 = dot(float2(_80, _81), float2(_80, _81));
    float _85 = ((_82 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float _86 = _85 * _80;
    float _87 = _85 * _81;
    float _88 = _86 + 0.5f;
    float _89 = _87 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        if (_46) {
          bool _98 = ((fHazeFilterAttribute & 2) != 0);
          float _101 = tFilterTempMap1.Sample(BilinearWrap, float2(_88, _89));
          do {
            if (_98) {
              float _104 = ReadonlyDepth.SampleLevel(PointClamp, float2(_88, _89), 0.0f);
              float _112 = (((_88 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
              float _113 = 1.0f - (((_89 * 2.0f) * screenSize.y) * screenInverseSize.y);
              float _150 = 1.0f / (mad(_104.x, (viewProjInvMat[2].w), mad(_113, (viewProjInvMat[1].w), (_112 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _152 = _150 * (mad(_104.x, (viewProjInvMat[2].y), mad(_113, (viewProjInvMat[1].y), (_112 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _160 = (_150 * (mad(_104.x, (viewProjInvMat[2].x), mad(_113, (viewProjInvMat[1].x), (_112 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _161 = _152 - (transposeViewInvMat[1].w);
              float _162 = (_150 * (mad(_104.x, (viewProjInvMat[2].z), mad(_113, (viewProjInvMat[1].z), (_112 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _187 = saturate(_101.x * max(((sqrt(((_161 * _161) + (_160 * _160)) + (_162 * _162)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_152 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _188 = _104.x;
            } else {
              _187 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _101.x), _101.x);
              _188 = 0.0f;
            }
            float _193 = -0.0f - _89;
            float _216 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_193, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _88)));
            float _217 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_193, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _88)));
            float _218 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_193, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _88)));
            float _222 = tVolumeMap.Sample(BilinearWrap, float3((_216 + fHazeFilterUVWOffset.x), (_217 + fHazeFilterUVWOffset.y), (_218 + fHazeFilterUVWOffset.z)));
            float _225 = _216 * 2.0f;
            float _226 = _217 * 2.0f;
            float _227 = _218 * 2.0f;
            float _231 = tVolumeMap.Sample(BilinearWrap, float3((_225 + fHazeFilterUVWOffset.x), (_226 + fHazeFilterUVWOffset.y), (_227 + fHazeFilterUVWOffset.z)));
            float _235 = _216 * 4.0f;
            float _236 = _217 * 4.0f;
            float _237 = _218 * 4.0f;
            float _241 = tVolumeMap.Sample(BilinearWrap, float3((_235 + fHazeFilterUVWOffset.x), (_236 + fHazeFilterUVWOffset.y), (_237 + fHazeFilterUVWOffset.z)));
            float _245 = _216 * 8.0f;
            float _246 = _217 * 8.0f;
            float _247 = _218 * 8.0f;
            float _251 = tVolumeMap.Sample(BilinearWrap, float3((_245 + fHazeFilterUVWOffset.x), (_246 + fHazeFilterUVWOffset.y), (_247 + fHazeFilterUVWOffset.z)));
            float _255 = fHazeFilterUVWOffset.x + 0.5f;
            float _256 = fHazeFilterUVWOffset.y + 0.5f;
            float _257 = fHazeFilterUVWOffset.z + 0.5f;
            float _261 = tVolumeMap.Sample(BilinearWrap, float3((_216 + _255), (_217 + _256), (_218 + _257)));
            float _267 = tVolumeMap.Sample(BilinearWrap, float3((_225 + _255), (_226 + _256), (_227 + _257)));
            float _274 = tVolumeMap.Sample(BilinearWrap, float3((_235 + _255), (_236 + _256), (_237 + _257)));
            float _281 = tVolumeMap.Sample(BilinearWrap, float3((_245 + _255), (_246 + _256), (_247 + _257)));
            float _292 = (((((((_231.x * 0.25f) + (_222.x * 0.5f)) + (_241.x * 0.125f)) + (_251.x * 0.0625f)) * 2.0f) + -1.0f) * _187) * fHazeFilterScale;
            float _294 = (fHazeFilterScale * _187) * ((((((_267.x * 0.25f) + (_261.x * 0.5f)) + (_274.x * 0.125f)) + (_281.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _305 = 0.5f / fHazeFilterBorder;
                float _312 = saturate(max(((_305 * min(max((abs(_86) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_305 * min(max((abs(_87) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _318 = (_292 - (_312 * _292));
                _319 = (_294 - (_312 * _294));
              } else {
                _318 = _292;
                _319 = _294;
              }
              do {
                if (_98) {
                  float _323 = ReadonlyDepth.Sample(BilinearWrap, float2((_318 + _88), (_319 + _89)));
                  if (!(!((_323.x - _188) >= fHazeFilterDepthDiffBias))) {
                    _330 = 0.0f;
                    _331 = 0.0f;
                  } else {
                    _330 = _318;
                    _331 = _319;
                  }
                } else {
                  _330 = _318;
                  _331 = _319;
                }
                _335 = (_330 + _88);
                _336 = (_331 + _89);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _335 = _88;
          _336 = _89;
        }
        float4 _337 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_335, _336));
        float _341 = _337.x * _67;
        float _342 = _337.y * _67;
        float _343 = _337.z * _67;
        if (isfinite(max(max(_341, _342), _343))) {
          float _352 = invLinearBegin * _341;
          float _358 = invLinearBegin * _342;
          float _364 = invLinearBegin * _343;
          float _371 = select((_341 >= linearBegin), 0.0f, (1.0f - ((_352 * _352) * (3.0f - (_352 * 2.0f)))));
          float _373 = select((_342 >= linearBegin), 0.0f, (1.0f - ((_358 * _358) * (3.0f - (_358 * 2.0f)))));
          float _375 = select((_343 >= linearBegin), 0.0f, (1.0f - ((_364 * _364) * (3.0f - (_364 * 2.0f)))));
          float _381 = select((_341 < linearStart), 0.0f, 1.0f);
          float _382 = select((_342 < linearStart), 0.0f, 1.0f);
          float _383 = select((_343 < linearStart), 0.0f, 1.0f);
          _1367 = (((((contrast * _341) + madLinearStartContrastFactor) * ((1.0f - _381) - _371)) + (((pow(_352, toe))*_371) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _341) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _381));
          _1368 = (((((contrast * _342) + madLinearStartContrastFactor) * ((1.0f - _382) - _373)) + (((pow(_358, toe))*_373) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _342) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _382));
          _1369 = (((((contrast * _343) + madLinearStartContrastFactor) * ((1.0f - _383) - _375)) + (((pow(_364, toe))*_375) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _343) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _383));
          _1370 = fDistortionCoef;
          _1371 = 0.0f;
          _1372 = 0.0f;
          _1373 = 0.0f;
          _1374 = 0.0f;
          _1375 = fCorrectCoef;
        } else {
          _1367 = 1.0f;
          _1368 = 1.0f;
          _1369 = 1.0f;
          _1370 = fDistortionCoef;
          _1371 = 0.0f;
          _1372 = 0.0f;
          _1373 = 0.0f;
          _1374 = 0.0f;
          _1375 = fCorrectCoef;
        }
      } while (false);
    } else {
      float _446 = _82 + fRefraction;
      float _448 = (_446 * fDistortionCoef) + 1.0f;
      float _449 = _80 * fCorrectCoef;
      float _451 = _81 * fCorrectCoef;
      float _457 = ((_446 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _462 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_88, _89));
      float _466 = _462.x * _67;
      do {
        if (isfinite(max(max(_466, (_462.y * _67)), (_462.z * _67)))) {
          float _477 = invLinearBegin * _466;
          float _484 = select((_466 >= linearBegin), 0.0f, (1.0f - ((_477 * _477) * (3.0f - (_477 * 2.0f)))));
          float _488 = select((_466 < linearStart), 0.0f, 1.0f);
          _515 = (((((contrast * _466) + madLinearStartContrastFactor) * ((1.0f - _488) - _484)) + ((linearBegin * (pow(_477, toe))) * _484)) + ((maxNit - (exp2((contrastFactor * _466) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _488));
        } else {
          _515 = 1.0f;
        }
        float4 _516 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_449 * _448) + 0.5f), ((_451 * _448) + 0.5f)));
        float _521 = _516.y * _67;
        do {
          if (isfinite(max(max((_516.x * _67), _521), (_516.z * _67)))) {
            float _531 = invLinearBegin * _521;
            float _538 = select((_521 >= linearBegin), 0.0f, (1.0f - ((_531 * _531) * (3.0f - (_531 * 2.0f)))));
            float _542 = select((_521 < linearStart), 0.0f, 1.0f);
            _569 = (((((contrast * _521) + madLinearStartContrastFactor) * ((1.0f - _542) - _538)) + ((linearBegin * (pow(_531, toe))) * _538)) + ((maxNit - (exp2((contrastFactor * _521) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _542));
          } else {
            _569 = 1.0f;
          }
          float4 _570 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_449 * _457) + 0.5f), ((_451 * _457) + 0.5f)));
          float _576 = _570.z * _67;
          if (isfinite(max(max((_570.x * _67), (_570.y * _67)), _576))) {
            float _585 = invLinearBegin * _576;
            float _592 = select((_576 >= linearBegin), 0.0f, (1.0f - ((_585 * _585) * (3.0f - (_585 * 2.0f)))));
            float _596 = select((_576 < linearStart), 0.0f, 1.0f);
            _1367 = _515;
            _1368 = _569;
            _1369 = (((((contrast * _576) + madLinearStartContrastFactor) * ((1.0f - _596) - _592)) + ((linearBegin * (pow(_585, toe))) * _592)) + ((maxNit - (exp2((contrastFactor * _576) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _596));
            _1370 = fDistortionCoef;
            _1371 = 0.0f;
            _1372 = 0.0f;
            _1373 = 0.0f;
            _1374 = 0.0f;
            _1375 = fCorrectCoef;
          } else {
            _1367 = _515;
            _1368 = _569;
            _1369 = 1.0f;
            _1370 = fDistortionCoef;
            _1371 = 0.0f;
            _1372 = 0.0f;
            _1373 = 0.0f;
            _1374 = 0.0f;
            _1375 = fCorrectCoef;
          }
        } while (false);
      } while (false);
    }
  } else {
    if (_44) {
      float _633 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _637 = sqrt((_633 * _633) + 1.0f);
      float _638 = 1.0f / _637;
      float _641 = (_637 * fOptimizedParam.z) * (_638 + fOptimizedParam.x);
      float _645 = fOptimizedParam.w * 0.5f;
      float _647 = (_645 * _633) * _641;
      float _650 = ((_645 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_638 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _641;
      float _651 = _647 + 0.5f;
      float _652 = _650 + 0.5f;
      do {
        if (_46) {
          bool _659 = ((fHazeFilterAttribute & 2) != 0);
          float _662 = tFilterTempMap1.Sample(BilinearWrap, float2(_651, _652));
          do {
            if (_659) {
              float _665 = ReadonlyDepth.SampleLevel(PointClamp, float2(_651, _652), 0.0f);
              float _673 = (((screenSize.x * 2.0f) * _651) * screenInverseSize.x) + -1.0f;
              float _674 = 1.0f - (((screenSize.y * 2.0f) * _652) * screenInverseSize.y);
              float _711 = 1.0f / (mad(_665.x, (viewProjInvMat[2].w), mad(_674, (viewProjInvMat[1].w), (_673 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _713 = _711 * (mad(_665.x, (viewProjInvMat[2].y), mad(_674, (viewProjInvMat[1].y), (_673 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _721 = (_711 * (mad(_665.x, (viewProjInvMat[2].x), mad(_674, (viewProjInvMat[1].x), (_673 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _722 = _713 - (transposeViewInvMat[1].w);
              float _723 = (_711 * (mad(_665.x, (viewProjInvMat[2].z), mad(_674, (viewProjInvMat[1].z), (_673 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _748 = saturate(_662.x * max(((sqrt(((_722 * _722) + (_721 * _721)) + (_723 * _723)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_713 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _749 = _665.x;
            } else {
              _748 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _662.x), _662.x);
              _749 = 0.0f;
            }
            float _754 = -0.0f - _652;
            float _777 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_754, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _651)));
            float _778 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_754, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _651)));
            float _779 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_754, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _651)));
            float _783 = tVolumeMap.Sample(BilinearWrap, float3((_777 + fHazeFilterUVWOffset.x), (_778 + fHazeFilterUVWOffset.y), (_779 + fHazeFilterUVWOffset.z)));
            float _786 = _777 * 2.0f;
            float _787 = _778 * 2.0f;
            float _788 = _779 * 2.0f;
            float _792 = tVolumeMap.Sample(BilinearWrap, float3((_786 + fHazeFilterUVWOffset.x), (_787 + fHazeFilterUVWOffset.y), (_788 + fHazeFilterUVWOffset.z)));
            float _796 = _777 * 4.0f;
            float _797 = _778 * 4.0f;
            float _798 = _779 * 4.0f;
            float _802 = tVolumeMap.Sample(BilinearWrap, float3((_796 + fHazeFilterUVWOffset.x), (_797 + fHazeFilterUVWOffset.y), (_798 + fHazeFilterUVWOffset.z)));
            float _806 = _777 * 8.0f;
            float _807 = _778 * 8.0f;
            float _808 = _779 * 8.0f;
            float _812 = tVolumeMap.Sample(BilinearWrap, float3((_806 + fHazeFilterUVWOffset.x), (_807 + fHazeFilterUVWOffset.y), (_808 + fHazeFilterUVWOffset.z)));
            float _816 = fHazeFilterUVWOffset.x + 0.5f;
            float _817 = fHazeFilterUVWOffset.y + 0.5f;
            float _818 = fHazeFilterUVWOffset.z + 0.5f;
            float _822 = tVolumeMap.Sample(BilinearWrap, float3((_777 + _816), (_778 + _817), (_779 + _818)));
            float _828 = tVolumeMap.Sample(BilinearWrap, float3((_786 + _816), (_787 + _817), (_788 + _818)));
            float _835 = tVolumeMap.Sample(BilinearWrap, float3((_796 + _816), (_797 + _817), (_798 + _818)));
            float _842 = tVolumeMap.Sample(BilinearWrap, float3((_806 + _816), (_807 + _817), (_808 + _818)));
            float _853 = (((((((_792.x * 0.25f) + (_783.x * 0.5f)) + (_802.x * 0.125f)) + (_812.x * 0.0625f)) * 2.0f) + -1.0f) * _748) * fHazeFilterScale;
            float _855 = (fHazeFilterScale * _748) * ((((((_828.x * 0.25f) + (_822.x * 0.5f)) + (_835.x * 0.125f)) + (_842.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _866 = 0.5f / fHazeFilterBorder;
                float _873 = saturate(max(((_866 * min(max((abs(_647) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_866 * min(max((abs(_650) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _879 = (_853 - (_873 * _853));
                _880 = (_855 - (_873 * _855));
              } else {
                _879 = _853;
                _880 = _855;
              }
              do {
                if (_659) {
                  float _884 = ReadonlyDepth.Sample(BilinearWrap, float2((_879 + _651), (_880 + _652)));
                  if (!(!((_884.x - _749) >= fHazeFilterDepthDiffBias))) {
                    _891 = 0.0f;
                    _892 = 0.0f;
                  } else {
                    _891 = _879;
                    _892 = _880;
                  }
                } else {
                  _891 = _879;
                  _892 = _880;
                }
                _896 = (_891 + _651);
                _897 = (_892 + _652);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _896 = _651;
          _897 = _652;
        }
        float4 _898 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_896, _897));
        float _902 = _898.x * _67;
        float _903 = _898.y * _67;
        float _904 = _898.z * _67;
        if (isfinite(max(max(_902, _903), _904))) {
          float _913 = invLinearBegin * _902;
          float _919 = invLinearBegin * _903;
          float _925 = invLinearBegin * _904;
          float _932 = select((_902 >= linearBegin), 0.0f, (1.0f - ((_913 * _913) * (3.0f - (_913 * 2.0f)))));
          float _934 = select((_903 >= linearBegin), 0.0f, (1.0f - ((_919 * _919) * (3.0f - (_919 * 2.0f)))));
          float _936 = select((_904 >= linearBegin), 0.0f, (1.0f - ((_925 * _925) * (3.0f - (_925 * 2.0f)))));
          float _942 = select((_902 < linearStart), 0.0f, 1.0f);
          float _943 = select((_903 < linearStart), 0.0f, 1.0f);
          float _944 = select((_904 < linearStart), 0.0f, 1.0f);
          _1367 = (((((contrast * _902) + madLinearStartContrastFactor) * ((1.0f - _942) - _932)) + (((pow(_913, toe))*_932) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _902) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _942));
          _1368 = (((((contrast * _903) + madLinearStartContrastFactor) * ((1.0f - _943) - _934)) + (((pow(_919, toe))*_934) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _903) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _943));
          _1369 = (((((contrast * _904) + madLinearStartContrastFactor) * ((1.0f - _944) - _936)) + (((pow(_925, toe))*_936) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _904) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _944));
          _1370 = 0.0f;
          _1371 = fOptimizedParam.x;
          _1372 = fOptimizedParam.y;
          _1373 = fOptimizedParam.z;
          _1374 = fOptimizedParam.w;
          _1375 = 1.0f;
        } else {
          _1367 = 1.0f;
          _1368 = 1.0f;
          _1369 = 1.0f;
          _1370 = 0.0f;
          _1371 = fOptimizedParam.x;
          _1372 = fOptimizedParam.y;
          _1373 = fOptimizedParam.z;
          _1374 = fOptimizedParam.w;
          _1375 = 1.0f;
        }
      } while (false);
    } else {
      float _1007 = screenInverseSize.x * SV_Position.x;
      float _1008 = screenInverseSize.y * SV_Position.y;
      do {
        if (!_46) {
          float4 _1010 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_1007, _1008));
          _1259 = _1010.x;
          _1260 = _1010.y;
          _1261 = _1010.z;
        } else {
          bool _1018 = ((fHazeFilterAttribute & 2) != 0);
          float _1021 = tFilterTempMap1.Sample(BilinearWrap, float2(_1007, _1008));
          do {
            if (_1018) {
              float _1024 = ReadonlyDepth.SampleLevel(PointClamp, float2(_1007, _1008), 0.0f);
              float _1030 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
              float _1031 = 1.0f - ((SV_Position.y * 2.0f) * screenInverseSize.y);
              float _1068 = 1.0f / (mad(_1024.x, (viewProjInvMat[2].w), mad(_1031, (viewProjInvMat[1].w), (_1030 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _1070 = _1068 * (mad(_1024.x, (viewProjInvMat[2].y), mad(_1031, (viewProjInvMat[1].y), (_1030 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _1078 = (_1068 * (mad(_1024.x, (viewProjInvMat[2].x), mad(_1031, (viewProjInvMat[1].x), (_1030 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _1079 = _1070 - (transposeViewInvMat[1].w);
              float _1080 = (_1068 * (mad(_1024.x, (viewProjInvMat[2].z), mad(_1031, (viewProjInvMat[1].z), (_1030 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _1105 = saturate(_1021.x * max(((sqrt(((_1079 * _1079) + (_1078 * _1078)) + (_1080 * _1080)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_1070 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _1106 = _1024.x;
            } else {
              _1105 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _1021.x), _1021.x);
              _1106 = 0.0f;
            }
            float _1111 = -0.0f - _1008;
            float _1134 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_1111, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _1007)));
            float _1135 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_1111, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _1007)));
            float _1136 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_1111, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _1007)));
            float _1140 = tVolumeMap.Sample(BilinearWrap, float3((_1134 + fHazeFilterUVWOffset.x), (_1135 + fHazeFilterUVWOffset.y), (_1136 + fHazeFilterUVWOffset.z)));
            float _1143 = _1134 * 2.0f;
            float _1144 = _1135 * 2.0f;
            float _1145 = _1136 * 2.0f;
            float _1149 = tVolumeMap.Sample(BilinearWrap, float3((_1143 + fHazeFilterUVWOffset.x), (_1144 + fHazeFilterUVWOffset.y), (_1145 + fHazeFilterUVWOffset.z)));
            float _1153 = _1134 * 4.0f;
            float _1154 = _1135 * 4.0f;
            float _1155 = _1136 * 4.0f;
            float _1159 = tVolumeMap.Sample(BilinearWrap, float3((_1153 + fHazeFilterUVWOffset.x), (_1154 + fHazeFilterUVWOffset.y), (_1155 + fHazeFilterUVWOffset.z)));
            float _1163 = _1134 * 8.0f;
            float _1164 = _1135 * 8.0f;
            float _1165 = _1136 * 8.0f;
            float _1169 = tVolumeMap.Sample(BilinearWrap, float3((_1163 + fHazeFilterUVWOffset.x), (_1164 + fHazeFilterUVWOffset.y), (_1165 + fHazeFilterUVWOffset.z)));
            float _1173 = fHazeFilterUVWOffset.x + 0.5f;
            float _1174 = fHazeFilterUVWOffset.y + 0.5f;
            float _1175 = fHazeFilterUVWOffset.z + 0.5f;
            float _1179 = tVolumeMap.Sample(BilinearWrap, float3((_1134 + _1173), (_1135 + _1174), (_1136 + _1175)));
            float _1185 = tVolumeMap.Sample(BilinearWrap, float3((_1143 + _1173), (_1144 + _1174), (_1145 + _1175)));
            float _1192 = tVolumeMap.Sample(BilinearWrap, float3((_1153 + _1173), (_1154 + _1174), (_1155 + _1175)));
            float _1199 = tVolumeMap.Sample(BilinearWrap, float3((_1163 + _1173), (_1164 + _1174), (_1165 + _1175)));
            float _1210 = (((((((_1149.x * 0.25f) + (_1140.x * 0.5f)) + (_1159.x * 0.125f)) + (_1169.x * 0.0625f)) * 2.0f) + -1.0f) * _1105) * fHazeFilterScale;
            float _1212 = (fHazeFilterScale * _1105) * ((((((_1185.x * 0.25f) + (_1179.x * 0.5f)) + (_1192.x * 0.125f)) + (_1199.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _1225 = 0.5f / fHazeFilterBorder;
                float _1232 = saturate(max(((_1225 * min(max((abs(_1007 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_1225 * min(max((abs(_1008 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _1238 = (_1210 - (_1232 * _1210));
                _1239 = (_1212 - (_1232 * _1212));
              } else {
                _1238 = _1210;
                _1239 = _1212;
              }
              do {
                if (_1018) {
                  float _1243 = ReadonlyDepth.Sample(BilinearWrap, float2((_1238 + _1007), (_1239 + _1008)));
                  if (!(!((_1243.x - _1106) >= fHazeFilterDepthDiffBias))) {
                    _1250 = 0.0f;
                    _1251 = 0.0f;
                  } else {
                    _1250 = _1238;
                    _1251 = _1239;
                  }
                } else {
                  _1250 = _1238;
                  _1251 = _1239;
                }
                float4 _1254 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1250 + _1007), (_1251 + _1008)));
                _1259 = _1254.x;
                _1260 = _1254.y;
                _1261 = _1254.z;
              } while (false);
            } while (false);
          } while (false);
        }
        float _1262 = _1259 * _67;
        float _1263 = _1260 * _67;
        float _1264 = _1261 * _67;
        if (isfinite(max(max(_1262, _1263), _1264))) {
          float _1273 = invLinearBegin * _1262;
          float _1279 = invLinearBegin * _1263;
          float _1285 = invLinearBegin * _1264;
          float _1292 = select((_1262 >= linearBegin), 0.0f, (1.0f - ((_1273 * _1273) * (3.0f - (_1273 * 2.0f)))));
          float _1294 = select((_1263 >= linearBegin), 0.0f, (1.0f - ((_1279 * _1279) * (3.0f - (_1279 * 2.0f)))));
          float _1296 = select((_1264 >= linearBegin), 0.0f, (1.0f - ((_1285 * _1285) * (3.0f - (_1285 * 2.0f)))));
          float _1302 = select((_1262 < linearStart), 0.0f, 1.0f);
          float _1303 = select((_1263 < linearStart), 0.0f, 1.0f);
          float _1304 = select((_1264 < linearStart), 0.0f, 1.0f);
          _1367 = (((((contrast * _1262) + madLinearStartContrastFactor) * ((1.0f - _1302) - _1292)) + (((pow(_1273, toe))*_1292) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1262) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1302));
          _1368 = (((((contrast * _1263) + madLinearStartContrastFactor) * ((1.0f - _1303) - _1294)) + (((pow(_1279, toe))*_1294) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1263) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1303));
          _1369 = (((((contrast * _1264) + madLinearStartContrastFactor) * ((1.0f - _1304) - _1296)) + (((pow(_1285, toe))*_1296) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1264) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1304));
          _1370 = 0.0f;
          _1371 = 0.0f;
          _1372 = 0.0f;
          _1373 = 0.0f;
          _1374 = 0.0f;
          _1375 = 1.0f;
        } else {
          _1367 = 1.0f;
          _1368 = 1.0f;
          _1369 = 1.0f;
          _1370 = 0.0f;
          _1371 = 0.0f;
          _1372 = 0.0f;
          _1373 = 0.0f;
          _1374 = 0.0f;
          _1375 = 1.0f;
        }
      } while (false);
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _1397 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1400 = ComputeResultSRV[0].computeAlpha;
    float _1403 = ((1.0f - _1397) + (_1400 * _1397)) * cbRadialColor.w;
    if (!(_1403 == 0.0f)) {
      float _1411 = screenInverseSize.x * SV_Position.x;
      float _1412 = screenInverseSize.y * SV_Position.y;
      float _1414 = (-0.5f - cbRadialScreenPos.x) + _1411;
      float _1416 = (-0.5f - cbRadialScreenPos.y) + _1412;
      float _1419 = select((_1414 < 0.0f), (1.0f - _1411), _1411);
      float _1422 = select((_1416 < 0.0f), (1.0f - _1412), _1412);
      float _1427 = rsqrt(dot(float2(_1414, _1416), float2(_1414, _1416))) * cbRadialSharpRange;
      uint _1434 = uint(abs(_1427 * _1416)) + uint(abs(_1427 * _1414));
      uint _1438 = ((_1434 ^ 61) ^ ((uint)(_1434) >> 16)) * 9;
      uint _1441 = (((uint)(_1438) >> 4) ^ _1438) * 668265261;
      float _1446 = select(((cbRadialBlurFlags & 1) != 0), (float((uint)((int)(((uint)(_1441) >> 15) ^ _1441))) * 2.3283064365386963e-10f), 1.0f);
      float _1452 = 1.0f / max(1.0f, sqrt((_1414 * _1414) + (_1416 * _1416)));
      float _1453 = cbRadialBlurPower * -0.0011111111380159855f;
      float _1462 = ((((_1453 * _1419) * _1446) * _1452) + 1.0f) * _1414;
      float _1463 = ((((_1453 * _1422) * _1446) * _1452) + 1.0f) * _1416;
      float _1464 = cbRadialBlurPower * -0.002222222276031971f;
      float _1473 = ((((_1464 * _1419) * _1446) * _1452) + 1.0f) * _1414;
      float _1474 = ((((_1464 * _1422) * _1446) * _1452) + 1.0f) * _1416;
      float _1475 = cbRadialBlurPower * -0.0033333334140479565f;
      float _1484 = ((((_1475 * _1419) * _1446) * _1452) + 1.0f) * _1414;
      float _1485 = ((((_1475 * _1422) * _1446) * _1452) + 1.0f) * _1416;
      float _1486 = cbRadialBlurPower * -0.004444444552063942f;
      float _1495 = ((((_1486 * _1419) * _1446) * _1452) + 1.0f) * _1414;
      float _1496 = ((((_1486 * _1422) * _1446) * _1452) + 1.0f) * _1416;
      float _1497 = cbRadialBlurPower * -0.0055555556900799274f;
      float _1506 = ((((_1497 * _1419) * _1446) * _1452) + 1.0f) * _1414;
      float _1507 = ((((_1497 * _1422) * _1446) * _1452) + 1.0f) * _1416;
      float _1508 = cbRadialBlurPower * -0.006666666828095913f;
      float _1517 = ((((_1508 * _1419) * _1446) * _1452) + 1.0f) * _1414;
      float _1518 = ((((_1508 * _1422) * _1446) * _1452) + 1.0f) * _1416;
      float _1519 = cbRadialBlurPower * -0.007777777966111898f;
      float _1528 = ((((_1519 * _1419) * _1446) * _1452) + 1.0f) * _1414;
      float _1529 = ((((_1519 * _1422) * _1446) * _1452) + 1.0f) * _1416;
      float _1530 = cbRadialBlurPower * -0.008888889104127884f;
      float _1539 = ((((_1530 * _1419) * _1446) * _1452) + 1.0f) * _1414;
      float _1540 = ((((_1530 * _1422) * _1446) * _1452) + 1.0f) * _1416;
      float _1541 = cbRadialBlurPower * -0.009999999776482582f;
      float _1550 = ((((_1541 * _1419) * _1446) * _1452) + 1.0f) * _1414;
      float _1551 = ((((_1541 * _1422) * _1446) * _1452) + 1.0f) * _1416;
      float _1552 = (_66 * Exposure) * 0.10000000149011612f;
      float _1553 = _1552 * cbRadialColor.x;
      float _1554 = _1552 * cbRadialColor.y;
      float _1555 = _1552 * cbRadialColor.z;
      do {
        if (_42) {
          float _1557 = _1462 + cbRadialScreenPos.x;
          float _1558 = _1463 + cbRadialScreenPos.y;
          float _1562 = ((dot(float2(_1557, _1558), float2(_1557, _1558)) * _1370) + 1.0f) * _1375;
          float4 _1567 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1562 * _1557) + 0.5f), ((_1562 * _1558) + 0.5f)), 0.0f);
          float _1571 = _1473 + cbRadialScreenPos.x;
          float _1572 = _1474 + cbRadialScreenPos.y;
          float _1575 = (dot(float2(_1571, _1572), float2(_1571, _1572)) * _1370) + 1.0f;
          float4 _1582 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1571 * _1375) * _1575) + 0.5f), (((_1572 * _1375) * _1575) + 0.5f)), 0.0f);
          float _1589 = _1484 + cbRadialScreenPos.x;
          float _1590 = _1485 + cbRadialScreenPos.y;
          float _1593 = (dot(float2(_1589, _1590), float2(_1589, _1590)) * _1370) + 1.0f;
          float4 _1600 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1589 * _1375) * _1593) + 0.5f), (((_1590 * _1375) * _1593) + 0.5f)), 0.0f);
          float _1607 = _1495 + cbRadialScreenPos.x;
          float _1608 = _1496 + cbRadialScreenPos.y;
          float _1611 = (dot(float2(_1607, _1608), float2(_1607, _1608)) * _1370) + 1.0f;
          float4 _1618 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1607 * _1375) * _1611) + 0.5f), (((_1608 * _1375) * _1611) + 0.5f)), 0.0f);
          float _1625 = _1506 + cbRadialScreenPos.x;
          float _1626 = _1507 + cbRadialScreenPos.y;
          float _1629 = (dot(float2(_1625, _1626), float2(_1625, _1626)) * _1370) + 1.0f;
          float4 _1636 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1625 * _1375) * _1629) + 0.5f), (((_1626 * _1375) * _1629) + 0.5f)), 0.0f);
          float _1643 = _1517 + cbRadialScreenPos.x;
          float _1644 = _1518 + cbRadialScreenPos.y;
          float _1647 = (dot(float2(_1643, _1644), float2(_1643, _1644)) * _1370) + 1.0f;
          float4 _1654 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1643 * _1375) * _1647) + 0.5f), (((_1644 * _1375) * _1647) + 0.5f)), 0.0f);
          float _1661 = _1528 + cbRadialScreenPos.x;
          float _1662 = _1529 + cbRadialScreenPos.y;
          float _1665 = (dot(float2(_1661, _1662), float2(_1661, _1662)) * _1370) + 1.0f;
          float4 _1672 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1661 * _1375) * _1665) + 0.5f), (((_1662 * _1375) * _1665) + 0.5f)), 0.0f);
          float _1679 = _1539 + cbRadialScreenPos.x;
          float _1680 = _1540 + cbRadialScreenPos.y;
          float _1683 = (dot(float2(_1679, _1680), float2(_1679, _1680)) * _1370) + 1.0f;
          float4 _1690 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1679 * _1375) * _1683) + 0.5f), (((_1680 * _1375) * _1683) + 0.5f)), 0.0f);
          float _1697 = _1550 + cbRadialScreenPos.x;
          float _1698 = _1551 + cbRadialScreenPos.y;
          float _1701 = (dot(float2(_1697, _1698), float2(_1697, _1698)) * _1370) + 1.0f;
          float4 _1708 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1697 * _1375) * _1701) + 0.5f), (((_1698 * _1375) * _1701) + 0.5f)), 0.0f);
          float _1715 = _1553 * ((((((((_1582.x + _1567.x) + _1600.x) + _1618.x) + _1636.x) + _1654.x) + _1672.x) + _1690.x) + _1708.x);
          float _1716 = _1554 * ((((((((_1582.y + _1567.y) + _1600.y) + _1618.y) + _1636.y) + _1654.y) + _1672.y) + _1690.y) + _1708.y);
          float _1717 = _1555 * ((((((((_1582.z + _1567.z) + _1600.z) + _1618.z) + _1636.z) + _1654.z) + _1672.z) + _1690.z) + _1708.z);
          do {
            if (isfinite(max(max(_1715, _1716), _1717))) {
              float _1726 = invLinearBegin * _1715;
              float _1732 = invLinearBegin * _1716;
              float _1738 = invLinearBegin * _1717;
              float _1745 = select((_1715 >= linearBegin), 0.0f, (1.0f - ((_1726 * _1726) * (3.0f - (_1726 * 2.0f)))));
              float _1747 = select((_1716 >= linearBegin), 0.0f, (1.0f - ((_1732 * _1732) * (3.0f - (_1732 * 2.0f)))));
              float _1749 = select((_1717 >= linearBegin), 0.0f, (1.0f - ((_1738 * _1738) * (3.0f - (_1738 * 2.0f)))));
              float _1755 = select((_1715 < linearStart), 0.0f, 1.0f);
              float _1756 = select((_1716 < linearStart), 0.0f, 1.0f);
              float _1757 = select((_1717 < linearStart), 0.0f, 1.0f);
              _1820 = (((((contrast * _1715) + madLinearStartContrastFactor) * ((1.0f - _1755) - _1745)) + (((pow(_1726, toe))*_1745) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1715) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1755));
              _1821 = (((((contrast * _1716) + madLinearStartContrastFactor) * ((1.0f - _1756) - _1747)) + (((pow(_1732, toe))*_1747) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1716) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1756));
              _1822 = (((((contrast * _1717) + madLinearStartContrastFactor) * ((1.0f - _1757) - _1749)) + (((pow(_1738, toe))*_1749) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1717) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1757));
            } else {
              _1820 = 1.0f;
              _1821 = 1.0f;
              _1822 = 1.0f;
            }
            _2400 = (_1820 + ((_1367 * 0.10000000149011612f) * cbRadialColor.x));
            _2401 = (_1821 + ((_1368 * 0.10000000149011612f) * cbRadialColor.y));
            _2402 = (_1822 + ((_1369 * 0.10000000149011612f) * cbRadialColor.z));
          } while (false);
        } else {
          float _1833 = cbRadialScreenPos.x + 0.5f;
          float _1834 = _1833 + _1462;
          float _1835 = cbRadialScreenPos.y + 0.5f;
          float _1836 = _1835 + _1463;
          float _1837 = _1833 + _1473;
          float _1838 = _1835 + _1474;
          float _1839 = _1833 + _1484;
          float _1840 = _1835 + _1485;
          float _1841 = _1833 + _1495;
          float _1842 = _1835 + _1496;
          float _1843 = _1833 + _1506;
          float _1844 = _1835 + _1507;
          float _1845 = _1833 + _1517;
          float _1846 = _1835 + _1518;
          float _1847 = _1833 + _1528;
          float _1848 = _1835 + _1529;
          float _1849 = _1833 + _1539;
          float _1850 = _1835 + _1540;
          float _1851 = _1833 + _1550;
          float _1852 = _1835 + _1551;
          if (_44) {
            float _1856 = (_1834 * 2.0f) + -1.0f;
            float _1860 = sqrt((_1856 * _1856) + 1.0f);
            float _1861 = 1.0f / _1860;
            float _1864 = (_1860 * _1373) * (_1861 + _1371);
            float _1868 = _1374 * 0.5f;
            float4 _1876 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1868 * _1864) * _1856) + 0.5f), ((((_1868 * (((_1861 + -1.0f) * _1372) + 1.0f)) * _1864) * ((_1836 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _1882 = (_1837 * 2.0f) + -1.0f;
            float _1886 = sqrt((_1882 * _1882) + 1.0f);
            float _1887 = 1.0f / _1886;
            float _1890 = (_1886 * _1373) * (_1887 + _1371);
            float4 _1901 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1868 * _1882) * _1890) + 0.5f), ((((_1868 * ((_1838 * 2.0f) + -1.0f)) * (((_1887 + -1.0f) * _1372) + 1.0f)) * _1890) + 0.5f)), 0.0f);
            float _1910 = (_1839 * 2.0f) + -1.0f;
            float _1914 = sqrt((_1910 * _1910) + 1.0f);
            float _1915 = 1.0f / _1914;
            float _1918 = (_1914 * _1373) * (_1915 + _1371);
            float4 _1929 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1868 * _1910) * _1918) + 0.5f), ((((_1868 * ((_1840 * 2.0f) + -1.0f)) * (((_1915 + -1.0f) * _1372) + 1.0f)) * _1918) + 0.5f)), 0.0f);
            float _1938 = (_1841 * 2.0f) + -1.0f;
            float _1942 = sqrt((_1938 * _1938) + 1.0f);
            float _1943 = 1.0f / _1942;
            float _1946 = (_1942 * _1373) * (_1943 + _1371);
            float4 _1957 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1868 * _1938) * _1946) + 0.5f), ((((_1868 * ((_1842 * 2.0f) + -1.0f)) * (((_1943 + -1.0f) * _1372) + 1.0f)) * _1946) + 0.5f)), 0.0f);
            float _1966 = (_1843 * 2.0f) + -1.0f;
            float _1970 = sqrt((_1966 * _1966) + 1.0f);
            float _1971 = 1.0f / _1970;
            float _1974 = (_1970 * _1373) * (_1971 + _1371);
            float4 _1985 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1868 * _1966) * _1974) + 0.5f), ((((_1868 * ((_1844 * 2.0f) + -1.0f)) * (((_1971 + -1.0f) * _1372) + 1.0f)) * _1974) + 0.5f)), 0.0f);
            float _1994 = (_1845 * 2.0f) + -1.0f;
            float _1998 = sqrt((_1994 * _1994) + 1.0f);
            float _1999 = 1.0f / _1998;
            float _2002 = (_1998 * _1373) * (_1999 + _1371);
            float4 _2013 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1868 * _1994) * _2002) + 0.5f), ((((_1868 * ((_1846 * 2.0f) + -1.0f)) * (((_1999 + -1.0f) * _1372) + 1.0f)) * _2002) + 0.5f)), 0.0f);
            float _2022 = (_1847 * 2.0f) + -1.0f;
            float _2026 = sqrt((_2022 * _2022) + 1.0f);
            float _2027 = 1.0f / _2026;
            float _2030 = (_2026 * _1373) * (_2027 + _1371);
            float4 _2041 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1868 * _2022) * _2030) + 0.5f), ((((_1868 * ((_1848 * 2.0f) + -1.0f)) * (((_2027 + -1.0f) * _1372) + 1.0f)) * _2030) + 0.5f)), 0.0f);
            float _2050 = (_1849 * 2.0f) + -1.0f;
            float _2054 = sqrt((_2050 * _2050) + 1.0f);
            float _2055 = 1.0f / _2054;
            float _2058 = (_2054 * _1373) * (_2055 + _1371);
            float4 _2069 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1868 * _2050) * _2058) + 0.5f), ((((_1868 * ((_1850 * 2.0f) + -1.0f)) * (((_2055 + -1.0f) * _1372) + 1.0f)) * _2058) + 0.5f)), 0.0f);
            float _2078 = (_1851 * 2.0f) + -1.0f;
            float _2082 = sqrt((_2078 * _2078) + 1.0f);
            float _2083 = 1.0f / _2082;
            float _2086 = (_2082 * _1373) * (_2083 + _1371);
            float4 _2097 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1868 * _2078) * _2086) + 0.5f), ((((_1868 * ((_1852 * 2.0f) + -1.0f)) * (((_2083 + -1.0f) * _1372) + 1.0f)) * _2086) + 0.5f)), 0.0f);
            float _2104 = _1553 * ((((((((_1901.x + _1876.x) + _1929.x) + _1957.x) + _1985.x) + _2013.x) + _2041.x) + _2069.x) + _2097.x);
            float _2105 = _1554 * ((((((((_1901.y + _1876.y) + _1929.y) + _1957.y) + _1985.y) + _2013.y) + _2041.y) + _2069.y) + _2097.y);
            float _2106 = _1555 * ((((((((_1901.z + _1876.z) + _1929.z) + _1957.z) + _1985.z) + _2013.z) + _2041.z) + _2069.z) + _2097.z);
            do {
              if (isfinite(max(max(_2104, _2105), _2106))) {
                float _2115 = invLinearBegin * _2104;
                float _2121 = invLinearBegin * _2105;
                float _2127 = invLinearBegin * _2106;
                float _2134 = select((_2104 >= linearBegin), 0.0f, (1.0f - ((_2115 * _2115) * (3.0f - (_2115 * 2.0f)))));
                float _2136 = select((_2105 >= linearBegin), 0.0f, (1.0f - ((_2121 * _2121) * (3.0f - (_2121 * 2.0f)))));
                float _2138 = select((_2106 >= linearBegin), 0.0f, (1.0f - ((_2127 * _2127) * (3.0f - (_2127 * 2.0f)))));
                float _2144 = select((_2104 < linearStart), 0.0f, 1.0f);
                float _2145 = select((_2105 < linearStart), 0.0f, 1.0f);
                float _2146 = select((_2106 < linearStart), 0.0f, 1.0f);
                _2209 = (((((contrast * _2104) + madLinearStartContrastFactor) * ((1.0f - _2144) - _2134)) + (((pow(_2115, toe))*_2134) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2104) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2144));
                _2210 = (((((contrast * _2105) + madLinearStartContrastFactor) * ((1.0f - _2145) - _2136)) + (((pow(_2121, toe))*_2136) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2105) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2145));
                _2211 = (((((contrast * _2106) + madLinearStartContrastFactor) * ((1.0f - _2146) - _2138)) + (((pow(_2127, toe))*_2138) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2106) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2146));
              } else {
                _2209 = 1.0f;
                _2210 = 1.0f;
                _2211 = 1.0f;
              }
              _2400 = (_2209 + ((_1367 * 0.10000000149011612f) * cbRadialColor.x));
              _2401 = (_2210 + ((_1368 * 0.10000000149011612f) * cbRadialColor.y));
              _2402 = (_2211 + ((_1369 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          } else {
            float4 _2222 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1834, _1836), 0.0f);
            float4 _2226 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1837, _1838), 0.0f);
            float4 _2233 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1839, _1840), 0.0f);
            float4 _2240 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1841, _1842), 0.0f);
            float4 _2247 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1843, _1844), 0.0f);
            float4 _2254 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1845, _1846), 0.0f);
            float4 _2261 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1847, _1848), 0.0f);
            float4 _2268 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1849, _1850), 0.0f);
            float4 _2275 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1851, _1852), 0.0f);
            float _2282 = _1553 * ((((((((_2226.x + _2222.x) + _2233.x) + _2240.x) + _2247.x) + _2254.x) + _2261.x) + _2268.x) + _2275.x);
            float _2283 = _1554 * ((((((((_2226.y + _2222.y) + _2233.y) + _2240.y) + _2247.y) + _2254.y) + _2261.y) + _2268.y) + _2275.y);
            float _2284 = _1555 * ((((((((_2226.z + _2222.z) + _2233.z) + _2240.z) + _2247.z) + _2254.z) + _2261.z) + _2268.z) + _2275.z);
            do {
              if (isfinite(max(max(_2282, _2283), _2284))) {
                float _2293 = invLinearBegin * _2282;
                float _2299 = invLinearBegin * _2283;
                float _2305 = invLinearBegin * _2284;
                float _2312 = select((_2282 >= linearBegin), 0.0f, (1.0f - ((_2293 * _2293) * (3.0f - (_2293 * 2.0f)))));
                float _2314 = select((_2283 >= linearBegin), 0.0f, (1.0f - ((_2299 * _2299) * (3.0f - (_2299 * 2.0f)))));
                float _2316 = select((_2284 >= linearBegin), 0.0f, (1.0f - ((_2305 * _2305) * (3.0f - (_2305 * 2.0f)))));
                float _2322 = select((_2282 < linearStart), 0.0f, 1.0f);
                float _2323 = select((_2283 < linearStart), 0.0f, 1.0f);
                float _2324 = select((_2284 < linearStart), 0.0f, 1.0f);
                _2387 = (((((contrast * _2282) + madLinearStartContrastFactor) * ((1.0f - _2322) - _2312)) + (((pow(_2293, toe))*_2312) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2282) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2322));
                _2388 = (((((contrast * _2283) + madLinearStartContrastFactor) * ((1.0f - _2323) - _2314)) + (((pow(_2299, toe))*_2314) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2283) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2323));
                _2389 = (((((contrast * _2284) + madLinearStartContrastFactor) * ((1.0f - _2324) - _2316)) + (((pow(_2305, toe))*_2316) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2284) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2324));
              } else {
                _2387 = 1.0f;
                _2388 = 1.0f;
                _2389 = 1.0f;
              }
              _2400 = (_2387 + ((_1367 * 0.10000000149011612f) * cbRadialColor.x));
              _2401 = (_2388 + ((_1368 * 0.10000000149011612f) * cbRadialColor.y));
              _2402 = (_2389 + ((_1369 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          }
        }
        do {
          if (cbRadialMaskRate.x > 0.0f) {
            float _2411 = saturate((sqrt((_1414 * _1414) + (_1416 * _1416)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
            float _2417 = (((_2411 * _2411) * cbRadialMaskRate.x) * (3.0f - (_2411 * 2.0f))) + cbRadialMaskRate.y;
            _2428 = ((_2417 * (_2400 - _1367)) + _1367);
            _2429 = ((_2417 * (_2401 - _1368)) + _1368);
            _2430 = ((_2417 * (_2402 - _1369)) + _1369);
          } else {
            _2428 = _2400;
            _2429 = _2401;
            _2430 = _2402;
          }
          _2441 = (lerp(_1367, _2428, _1403));
          _2442 = (lerp(_1368, _2429, _1403));
          _2443 = (lerp(_1369, _2430, _1403));
        } while (false);
      } while (false);
    } else {
      _2441 = _1367;
      _2442 = _1368;
      _2443 = _1369;
    }
  } else {
    _2441 = _1367;
    _2442 = _1368;
    _2443 = _1369;
  }
  if (!((cPassEnabled & 2) == 0) && (CUSTOM_NOISE != 0.f)) {
#if 1
    float3 noise_input = float3(_2441, _2442, _2443);
#endif

    float _2465 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
    float _2467 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
    float _2471 = frac(frac(dot(float2(_2465, _2467), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_2471 < fNoiseDensity) {
        int _2476 = (uint)(uint(_2467 * _2465)) ^ 12345391;
        uint _2477 = _2476 * 3635641;
        _2485 = (float((uint)((int)((((uint)(_2477) >> 26) | ((uint)(_2476 * 232681024))) ^ _2477))) * 2.3283064365386963e-10f);
      } else {
        _2485 = 0.0f;
      }
      float _2487 = frac(_2471 * 757.4846801757812f);
      do {
        if (_2487 < fNoiseDensity) {
          int _2491 = asint(_2487) ^ 12345391;
          uint _2492 = _2491 * 3635641;
          _2501 = ((float((uint)((int)((((uint)(_2492) >> 26) | ((uint)(_2491 * 232681024))) ^ _2492))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _2501 = 0.0f;
        }
        float _2503 = frac(_2487 * 757.4846801757812f);
        do {
          if (_2503 < fNoiseDensity) {
            int _2507 = asint(_2503) ^ 12345391;
            uint _2508 = _2507 * 3635641;
            _2517 = ((float((uint)((int)((((uint)(_2508) >> 26) | ((uint)(_2507 * 232681024))) ^ _2508))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _2517 = 0.0f;
          }
          float _2518 = _2485 * fNoisePower.x;
          float _2519 = _2517 * fNoisePower.y;
          float _2520 = _2501 * fNoisePower.y;
          float _2534 = exp2(log2(1.0f - saturate(dot(float3(saturate(_2441), saturate(_2442), saturate(_2443)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _2545 = ((_2534 * (mad(_2520, 1.4019999504089355f, _2518) - _2441)) + _2441);
          _2546 = ((_2534 * (mad(_2520, -0.7139999866485596f, mad(_2519, -0.3440000116825104f, _2518)) - _2442)) + _2442);
          _2547 = ((_2534 * (mad(_2519, 1.7719999551773071f, _2518) - _2443)) + _2443);
        } while (false);
      } while (false);
    } while (false);
#if 1
    _2545 = lerp(noise_input.r, _2545, CUSTOM_NOISE);
    _2546 = lerp(noise_input.g, _2546, CUSTOM_NOISE);
    _2547 = lerp(noise_input.b, _2547, CUSTOM_NOISE);
#endif
  } else {
    _2545 = _2441;
    _2546 = _2442;
    _2547 = _2443;
  }

#if 1
  ApplyColorGrading(_2545, _2546, _2547,
                    _2759, _2760, _2761);
#else

  if (!((cPassEnabled & 4) == 0)) {
    float _2572 = max(max(_2545, _2546), _2547);
    bool _2573 = (_2572 > 1.0f);
    do {
      if (_2573) {
        _2579 = (_2545 / _2572);
        _2580 = (_2546 / _2572);
        _2581 = (_2547 / _2572);
      } else {
        _2579 = _2545;
        _2580 = _2546;
        _2581 = _2547;
      }
      float _2582 = fTextureInverseSize * 0.5f;
      do {
        [branch]
        if (!(!(_2579 <= 0.0031308000907301903f))) {
          _2593 = (_2579 * 12.920000076293945f);
        } else {
          _2593 = (((pow(_2579, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          [branch]
          if (!(!(_2580 <= 0.0031308000907301903f))) {
            _2604 = (_2580 * 12.920000076293945f);
          } else {
            _2604 = (((pow(_2580, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            [branch]
            if (!(!(_2581 <= 0.0031308000907301903f))) {
              _2615 = (_2581 * 12.920000076293945f);
            } else {
              _2615 = (((pow(_2581, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            float _2616 = 1.0f - fTextureInverseSize;
            float _2620 = (_2593 * _2616) + _2582;
            float _2621 = (_2604 * _2616) + _2582;
            float _2622 = (_2615 * _2616) + _2582;
            float4 _2623 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2620, _2621, _2622), 0.0f);
            bool _2628 = (fTextureBlendRate2 > 0.0f);
            do {
              [branch]
              if (fTextureBlendRate > 0.0f) {
                float4 _2630 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2620, _2621, _2622), 0.0f);
                float _2640 = ((_2630.x - _2623.x) * fTextureBlendRate) + _2623.x;
                float _2641 = ((_2630.y - _2623.y) * fTextureBlendRate) + _2623.y;
                float _2642 = ((_2630.z - _2623.z) * fTextureBlendRate) + _2623.z;
                if (_2628) {
                  do {
                    [branch]
                    if (!(!(_2640 <= 0.0031308000907301903f))) {
                      _2654 = (_2640 * 12.920000076293945f);
                    } else {
                      _2654 = (((pow(_2640, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_2641 <= 0.0031308000907301903f))) {
                        _2665 = (_2641 * 12.920000076293945f);
                      } else {
                        _2665 = (((pow(_2641, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_2642 <= 0.0031308000907301903f))) {
                          _2676 = (_2642 * 12.920000076293945f);
                        } else {
                          _2676 = (((pow(_2642, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _2677 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2654, _2665, _2676), 0.0f);
                        _2739 = (lerp(_2640, _2677.x, fTextureBlendRate2));
                        _2740 = (lerp(_2641, _2677.y, fTextureBlendRate2));
                        _2741 = (lerp(_2642, _2677.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _2739 = _2640;
                  _2740 = _2641;
                  _2741 = _2642;
                }
              } else {
                if (_2628) {
                  do {
                    [branch]
                    if (!(!(_2623.x <= 0.0031308000907301903f))) {
                      _2702 = (_2623.x * 12.920000076293945f);
                    } else {
                      _2702 = (((pow(_2623.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_2623.y <= 0.0031308000907301903f))) {
                        _2713 = (_2623.y * 12.920000076293945f);
                      } else {
                        _2713 = (((pow(_2623.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_2623.z <= 0.0031308000907301903f))) {
                          _2724 = (_2623.z * 12.920000076293945f);
                        } else {
                          _2724 = (((pow(_2623.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _2725 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2702, _2713, _2724), 0.0f);
                        _2739 = (lerp(_2623.x, _2725.x, fTextureBlendRate2));
                        _2740 = (lerp(_2623.y, _2725.y, fTextureBlendRate2));
                        _2741 = (lerp(_2623.z, _2725.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _2739 = _2623.x;
                  _2740 = _2623.y;
                  _2741 = _2623.z;
                }
              }
              float _2745 = mad(_2741, (fColorMatrix[2].x), mad(_2740, (fColorMatrix[1].x), (_2739 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
              float _2749 = mad(_2741, (fColorMatrix[2].y), mad(_2740, (fColorMatrix[1].y), (_2739 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
              float _2753 = mad(_2741, (fColorMatrix[2].z), mad(_2740, (fColorMatrix[1].z), (_2739 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
              if (_2573) {
                _2759 = (_2745 * _2572);
                _2760 = (_2749 * _2572);
                _2761 = (_2753 * _2572);
              } else {
                _2759 = _2745;
                _2760 = _2749;
                _2761 = _2753;
              }
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2759 = _2545;
    _2760 = _2546;
    _2761 = _2547;
  }
#endif
  if (!((cPassEnabled & 8) == 0)) {
    _2796 = saturate(((cvdR.x * _2759) + (cvdR.y * _2760)) + (cvdR.z * _2761));
    _2797 = saturate(((cvdG.x * _2759) + (cvdG.y * _2760)) + (cvdG.z * _2761));
    _2798 = saturate(((cvdB.x * _2759) + (cvdB.y * _2760)) + (cvdB.z * _2761));
  } else {
    _2796 = _2759;
    _2797 = _2760;
    _2798 = _2761;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2813 = screenInverseSize.x * SV_Position.x;
    float _2814 = screenInverseSize.y * SV_Position.y;
    float4 _2815 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2813, _2814), 0.0f);
    float _2820 = _2815.x * ColorParam.x;
    float _2821 = _2815.y * ColorParam.y;
    float _2822 = _2815.z * ColorParam.z;
    float _2824 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2813, _2814), 0.0f);
    float _2829 = (_2815.w * ColorParam.w) * saturate((_2824.x * Levels_Rate) + Levels_Range);
    _2867 = (((select((_2820 < 0.5f), ((_2796 * 2.0f) * _2820), (1.0f - (((1.0f - _2796) * 2.0f) * (1.0f - _2820)))) - _2796) * _2829) + _2796);
    _2868 = (((select((_2821 < 0.5f), ((_2797 * 2.0f) * _2821), (1.0f - (((1.0f - _2797) * 2.0f) * (1.0f - _2821)))) - _2797) * _2829) + _2797);
    _2869 = (((select((_2822 < 0.5f), ((_2798 * 2.0f) * _2822), (1.0f - (((1.0f - _2798) * 2.0f) * (1.0f - _2822)))) - _2798) * _2829) + _2798);
  } else {
    _2867 = _2796;
    _2868 = _2797;
    _2869 = _2798;
  }
  SV_Target.x = _2867;
  SV_Target.y = _2868;
  SV_Target.z = _2869;
  SV_Target.w = 0.0f;

#if 1
  float2 grain_uv = SV_Position.xy * screenInverseSize;
  SV_Target.rgb = ApplyToneMap(SV_Target.rgb, grain_uv);
#endif

  return SV_Target;
}
