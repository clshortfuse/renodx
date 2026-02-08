#define SHADER_HASH 0x973A39FC

#include "../tonemap.hlsli"

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
//   row_major float4x4 fColorMatrix : packoffset(c001.x);
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
  bool _50 = ((cPassEnabled & 1) != 0);
  bool _54 = _50 && (bool)(distortionType == 0);
  bool _56 = _50 && (bool)(distortionType == 1);
  int _58 = ((uint)((int)(cPassEnabled)) >> 6) & 1;
  float _61 = Kerare.x / Kerare.w;
  float _62 = Kerare.y / Kerare.w;
  float _63 = Kerare.z / Kerare.w;
  float _67 = abs(rsqrt(dot(float3(_61, _62, _63), float3(_61, _62, _63))) * _63);
  float _74 = _67 * _67;
  float _78 = saturate(((_74 * _74) * (1.0f - saturate((kerare_scale * _67) + kerare_offset))) + kerare_brightness);
  float _79 = _78 * Exposure;
  float _203;
  float _204;
  float _337;
  float _338;
  float _350;
  float _351;
  float _355;
  float _356;
  float _539;
  float _593;
  float _776;
  float _777;
  float _910;
  float _911;
  float _923;
  float _924;
  float _928;
  float _929;
  float _1144;
  float _1145;
  float _1280;
  float _1281;
  float _1293;
  float _1294;
  float _1304;
  float _1305;
  float _1306;
  float _1412;
  float _1413;
  float _1414;
  float _1415;
  float _1416;
  float _1417;
  float _1418;
  float _1419;
  float _1420;
  float _1868;
  float _1869;
  float _1870;
  float _2258;
  float _2259;
  float _2260;
  float _2437;
  float _2438;
  float _2439;
  float _2450;
  float _2451;
  float _2452;
  float _2478;
  float _2479;
  float _2480;
  float _2491;
  float _2492;
  float _2493;
  float _2535;
  float _2551;
  float _2567;
  float _2595;
  float _2596;
  float _2597;
  float _2629;
  float _2630;
  float _2631;
  float _2643;
  float _2654;
  float _2665;
  float _2707;
  float _2718;
  float _2729;
  float _2756;
  float _2767;
  float _2778;
  float _2794;
  float _2795;
  float _2796;
  float _2814;
  float _2815;
  float _2816;
  float _2851;
  float _2852;
  float _2853;
  float _2925;
  float _2926;
  float _2927;
  if (_54) {
    float _92 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _93 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _94 = dot(float2(_92, _93), float2(_92, _93));
    float _97 = ((_94 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float _98 = _97 * _92;
    float _99 = _97 * _93;
    float _100 = _98 + 0.5f;
    float _101 = _99 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        if (!(_58 == 0)) {
          bool _112 = ((fHazeFilterAttribute & 2) == 0);
          float _115 = tFilterTempMap1.Sample(BilinearWrap, float2(_100, _101));
          do {
            if (!_112) {
              float _120 = ReadonlyDepth.SampleLevel(PointClamp, float2(_100, _101), 0.0f);
              float _128 = (((_100 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
              float _129 = 1.0f - (((_101 * 2.0f) * screenSize.y) * screenInverseSize.y);
              float _166 = 1.0f / (mad(_120.x, (viewProjInvMat[2].w), mad(_129, (viewProjInvMat[1].w), (_128 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _168 = _166 * (mad(_120.x, (viewProjInvMat[2].y), mad(_129, (viewProjInvMat[1].y), (_128 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _176 = (_166 * (mad(_120.x, (viewProjInvMat[2].x), mad(_129, (viewProjInvMat[1].x), (_128 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _177 = _168 - (transposeViewInvMat[1].w);
              float _178 = (_166 * (mad(_120.x, (viewProjInvMat[2].z), mad(_129, (viewProjInvMat[1].z), (_128 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _203 = saturate(_115.x * max(((sqrt(((_177 * _177) + (_176 * _176)) + (_178 * _178)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_168 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _204 = _120.x;
            } else {
              _203 = select(((fHazeFilterAttribute & 1) == 0), _115.x, (1.0f - _115.x));
              _204 = 0.0f;
            }
            float _209 = -0.0f - _101;
            float _232 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_209, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _100)));
            float _233 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_209, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _100)));
            float _234 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_209, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _100)));
            float _240 = tVolumeMap.Sample(BilinearWrap, float3((_232 + fHazeFilterUVWOffset.x), (_233 + fHazeFilterUVWOffset.y), (_234 + fHazeFilterUVWOffset.z)));
            float _243 = _232 * 2.0f;
            float _244 = _233 * 2.0f;
            float _245 = _234 * 2.0f;
            float _249 = tVolumeMap.Sample(BilinearWrap, float3((_243 + fHazeFilterUVWOffset.x), (_244 + fHazeFilterUVWOffset.y), (_245 + fHazeFilterUVWOffset.z)));
            float _253 = _232 * 4.0f;
            float _254 = _233 * 4.0f;
            float _255 = _234 * 4.0f;
            float _259 = tVolumeMap.Sample(BilinearWrap, float3((_253 + fHazeFilterUVWOffset.x), (_254 + fHazeFilterUVWOffset.y), (_255 + fHazeFilterUVWOffset.z)));
            float _263 = _232 * 8.0f;
            float _264 = _233 * 8.0f;
            float _265 = _234 * 8.0f;
            float _269 = tVolumeMap.Sample(BilinearWrap, float3((_263 + fHazeFilterUVWOffset.x), (_264 + fHazeFilterUVWOffset.y), (_265 + fHazeFilterUVWOffset.z)));
            float _273 = fHazeFilterUVWOffset.x + 0.5f;
            float _274 = fHazeFilterUVWOffset.y + 0.5f;
            float _275 = fHazeFilterUVWOffset.z + 0.5f;
            float _279 = tVolumeMap.Sample(BilinearWrap, float3((_232 + _273), (_233 + _274), (_234 + _275)));
            float _285 = tVolumeMap.Sample(BilinearWrap, float3((_243 + _273), (_244 + _274), (_245 + _275)));
            float _292 = tVolumeMap.Sample(BilinearWrap, float3((_253 + _273), (_254 + _274), (_255 + _275)));
            float _299 = tVolumeMap.Sample(BilinearWrap, float3((_263 + _273), (_264 + _274), (_265 + _275)));
            float _310 = (((((((_249.x * 0.25f) + (_240.x * 0.5f)) + (_259.x * 0.125f)) + (_269.x * 0.0625f)) * 2.0f) + -1.0f) * _203) * fHazeFilterScale;
            float _312 = (fHazeFilterScale * _203) * ((((((_285.x * 0.25f) + (_279.x * 0.5f)) + (_292.x * 0.125f)) + (_299.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _324 = 0.5f / fHazeFilterBorder;
                float _331 = saturate(max(((_324 * min(max((abs(_98) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_324 * min(max((abs(_99) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _337 = (_310 - (_331 * _310));
                _338 = (_312 - (_331 * _312));
              } else {
                _337 = _310;
                _338 = _312;
              }
              do {
                if (!_112) {
                  float _343 = ReadonlyDepth.Sample(BilinearWrap, float2((_337 + _100), (_338 + _101)));
                  if (!(!((_343.x - _204) >= fHazeFilterDepthDiffBias))) {
                    _350 = 0.0f;
                    _351 = 0.0f;
                  } else {
                    _350 = _337;
                    _351 = _338;
                  }
                } else {
                  _350 = _337;
                  _351 = _338;
                }
                _355 = (_350 + _100);
                _356 = (_351 + _101);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _355 = _100;
          _356 = _101;
        }
        float4 _359 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_355, _356));
        float _363 = _359.x * _79;
        float _364 = _359.y * _79;
        float _365 = _359.z * _79;
        if (isfinite(max(max(_363, _364), _365))) {
          float _374 = invLinearBegin * _363;
          float _380 = invLinearBegin * _364;
          float _386 = invLinearBegin * _365;
          float _393 = select((_363 >= linearBegin), 0.0f, (1.0f - ((_374 * _374) * (3.0f - (_374 * 2.0f)))));
          float _395 = select((_364 >= linearBegin), 0.0f, (1.0f - ((_380 * _380) * (3.0f - (_380 * 2.0f)))));
          float _397 = select((_365 >= linearBegin), 0.0f, (1.0f - ((_386 * _386) * (3.0f - (_386 * 2.0f)))));
          float _403 = select((_363 < linearStart), 0.0f, 1.0f);
          float _404 = select((_364 < linearStart), 0.0f, 1.0f);
          float _405 = select((_365 < linearStart), 0.0f, 1.0f);
          _1412 = (((((contrast * _363) + madLinearStartContrastFactor) * ((1.0f - _403) - _393)) + (((pow(_374, toe))*_393) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _363) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _403));
          _1413 = (((((contrast * _364) + madLinearStartContrastFactor) * ((1.0f - _404) - _395)) + (((pow(_380, toe))*_395) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _364) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _404));
          _1414 = (((((contrast * _365) + madLinearStartContrastFactor) * ((1.0f - _405) - _397)) + (((pow(_386, toe))*_397) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _365) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _405));
          _1415 = fDistortionCoef;
          _1416 = 0.0f;
          _1417 = 0.0f;
          _1418 = 0.0f;
          _1419 = 0.0f;
          _1420 = fCorrectCoef;

          // float3 tonemapped = float3(_1412, _1413, _1414);
          // float3 untonemapped = float3(_363, _364, _365);

          // tonemapped = renodx::color::correct::Hue(tonemapped, untonemapped);
          // _1412 = tonemapped.r, _1413 = tonemapped.g, _1414 = tonemapped.b;

        } else {
          _1412 = 1.0f;
          _1413 = 1.0f;
          _1414 = 1.0f;
          _1415 = fDistortionCoef;
          _1416 = 0.0f;
          _1417 = 0.0f;
          _1418 = 0.0f;
          _1419 = 0.0f;
          _1420 = fCorrectCoef;
        }
      } while (false);
    } else {
      float _468 = _94 + fRefraction;
      float _470 = (_468 * fDistortionCoef) + 1.0f;
      float _471 = _92 * fCorrectCoef;
      float _473 = _93 * fCorrectCoef;
      float _479 = ((_468 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _486 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_100, _101));
      float _490 = _486.x * _79;
      do {
        if (isfinite(max(max(_490, (_486.y * _79)), (_486.z * _79)))) {
          float _501 = invLinearBegin * _490;
          float _508 = select((_490 >= linearBegin), 0.0f, (1.0f - ((_501 * _501) * (3.0f - (_501 * 2.0f)))));
          float _512 = select((_490 < linearStart), 0.0f, 1.0f);
          _539 = (((((contrast * _490) + madLinearStartContrastFactor) * ((1.0f - _512) - _508)) + ((linearBegin * (pow(_501, toe))) * _508)) + ((maxNit - (exp2((contrastFactor * _490) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _512));
        } else {
          _539 = 1.0f;
        }
        float4 _540 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_471 * _470) + 0.5f), ((_473 * _470) + 0.5f)));
        float _545 = _540.y * _79;
        do {
          if (isfinite(max(max((_540.x * _79), _545), (_540.z * _79)))) {
            float _555 = invLinearBegin * _545;
            float _562 = select((_545 >= linearBegin), 0.0f, (1.0f - ((_555 * _555) * (3.0f - (_555 * 2.0f)))));
            float _566 = select((_545 < linearStart), 0.0f, 1.0f);
            _593 = (((((contrast * _545) + madLinearStartContrastFactor) * ((1.0f - _566) - _562)) + ((linearBegin * (pow(_555, toe))) * _562)) + ((maxNit - (exp2((contrastFactor * _545) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _566));
          } else {
            _593 = 1.0f;
          }
          float4 _594 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_471 * _479) + 0.5f), ((_473 * _479) + 0.5f)));
          float _600 = _594.z * _79;
          if (isfinite(max(max((_594.x * _79), (_594.y * _79)), _600))) {
            float _609 = invLinearBegin * _600;
            float _616 = select((_600 >= linearBegin), 0.0f, (1.0f - ((_609 * _609) * (3.0f - (_609 * 2.0f)))));
            float _620 = select((_600 < linearStart), 0.0f, 1.0f);
            _1412 = _539;
            _1413 = _593;
            _1414 = (((((contrast * _600) + madLinearStartContrastFactor) * ((1.0f - _620) - _616)) + ((linearBegin * (pow(_609, toe))) * _616)) + ((maxNit - (exp2((contrastFactor * _600) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _620));
            _1415 = fDistortionCoef;
            _1416 = 0.0f;
            _1417 = 0.0f;
            _1418 = 0.0f;
            _1419 = 0.0f;
            _1420 = fCorrectCoef;
          } else {
            _1412 = _539;
            _1413 = _593;
            _1414 = 1.0f;
            _1415 = fDistortionCoef;
            _1416 = 0.0f;
            _1417 = 0.0f;
            _1418 = 0.0f;
            _1419 = 0.0f;
            _1420 = fCorrectCoef;
          }
        } while (false);
      } while (false);
    }
  } else {
    bool _647 = (_58 == 0);
    if (_56) {
      float _658 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _662 = sqrt((_658 * _658) + 1.0f);
      float _663 = 1.0f / _662;
      float _666 = (_662 * fOptimizedParam.z) * (_663 + fOptimizedParam.x);
      float _670 = fOptimizedParam.w * 0.5f;
      float _672 = (_670 * _658) * _666;
      float _675 = ((_670 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_663 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _666;
      float _676 = _672 + 0.5f;
      float _677 = _675 + 0.5f;
      do {
        if (!_647) {
          bool _685 = ((fHazeFilterAttribute & 2) == 0);
          float _688 = tFilterTempMap1.Sample(BilinearWrap, float2(_676, _677));
          do {
            if (!_685) {
              float _693 = ReadonlyDepth.SampleLevel(PointClamp, float2(_676, _677), 0.0f);
              float _701 = (((screenSize.x * 2.0f) * _676) * screenInverseSize.x) + -1.0f;
              float _702 = 1.0f - (((screenSize.y * 2.0f) * _677) * screenInverseSize.y);
              float _739 = 1.0f / (mad(_693.x, (viewProjInvMat[2].w), mad(_702, (viewProjInvMat[1].w), (_701 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _741 = _739 * (mad(_693.x, (viewProjInvMat[2].y), mad(_702, (viewProjInvMat[1].y), (_701 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _749 = (_739 * (mad(_693.x, (viewProjInvMat[2].x), mad(_702, (viewProjInvMat[1].x), (_701 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _750 = _741 - (transposeViewInvMat[1].w);
              float _751 = (_739 * (mad(_693.x, (viewProjInvMat[2].z), mad(_702, (viewProjInvMat[1].z), (_701 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _776 = saturate(_688.x * max(((sqrt(((_750 * _750) + (_749 * _749)) + (_751 * _751)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_741 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _777 = _693.x;
            } else {
              _776 = select(((fHazeFilterAttribute & 1) == 0), _688.x, (1.0f - _688.x));
              _777 = 0.0f;
            }
            float _782 = -0.0f - _677;
            float _805 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_782, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _676)));
            float _806 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_782, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _676)));
            float _807 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_782, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _676)));
            float _813 = tVolumeMap.Sample(BilinearWrap, float3((_805 + fHazeFilterUVWOffset.x), (_806 + fHazeFilterUVWOffset.y), (_807 + fHazeFilterUVWOffset.z)));
            float _816 = _805 * 2.0f;
            float _817 = _806 * 2.0f;
            float _818 = _807 * 2.0f;
            float _822 = tVolumeMap.Sample(BilinearWrap, float3((_816 + fHazeFilterUVWOffset.x), (_817 + fHazeFilterUVWOffset.y), (_818 + fHazeFilterUVWOffset.z)));
            float _826 = _805 * 4.0f;
            float _827 = _806 * 4.0f;
            float _828 = _807 * 4.0f;
            float _832 = tVolumeMap.Sample(BilinearWrap, float3((_826 + fHazeFilterUVWOffset.x), (_827 + fHazeFilterUVWOffset.y), (_828 + fHazeFilterUVWOffset.z)));
            float _836 = _805 * 8.0f;
            float _837 = _806 * 8.0f;
            float _838 = _807 * 8.0f;
            float _842 = tVolumeMap.Sample(BilinearWrap, float3((_836 + fHazeFilterUVWOffset.x), (_837 + fHazeFilterUVWOffset.y), (_838 + fHazeFilterUVWOffset.z)));
            float _846 = fHazeFilterUVWOffset.x + 0.5f;
            float _847 = fHazeFilterUVWOffset.y + 0.5f;
            float _848 = fHazeFilterUVWOffset.z + 0.5f;
            float _852 = tVolumeMap.Sample(BilinearWrap, float3((_805 + _846), (_806 + _847), (_807 + _848)));
            float _858 = tVolumeMap.Sample(BilinearWrap, float3((_816 + _846), (_817 + _847), (_818 + _848)));
            float _865 = tVolumeMap.Sample(BilinearWrap, float3((_826 + _846), (_827 + _847), (_828 + _848)));
            float _872 = tVolumeMap.Sample(BilinearWrap, float3((_836 + _846), (_837 + _847), (_838 + _848)));
            float _883 = (((((((_822.x * 0.25f) + (_813.x * 0.5f)) + (_832.x * 0.125f)) + (_842.x * 0.0625f)) * 2.0f) + -1.0f) * _776) * fHazeFilterScale;
            float _885 = (fHazeFilterScale * _776) * ((((((_858.x * 0.25f) + (_852.x * 0.5f)) + (_865.x * 0.125f)) + (_872.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _897 = 0.5f / fHazeFilterBorder;
                float _904 = saturate(max(((_897 * min(max((abs(_672) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_897 * min(max((abs(_675) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _910 = (_883 - (_904 * _883));
                _911 = (_885 - (_904 * _885));
              } else {
                _910 = _883;
                _911 = _885;
              }
              do {
                if (!_685) {
                  float _916 = ReadonlyDepth.Sample(BilinearWrap, float2((_910 + _676), (_911 + _677)));
                  if (!(!((_916.x - _777) >= fHazeFilterDepthDiffBias))) {
                    _923 = 0.0f;
                    _924 = 0.0f;
                  } else {
                    _923 = _910;
                    _924 = _911;
                  }
                } else {
                  _923 = _910;
                  _924 = _911;
                }
                _928 = (_923 + _676);
                _929 = (_924 + _677);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _928 = _676;
          _929 = _677;
        }
        float4 _932 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_928, _929));
        float _936 = _932.x * _79;
        float _937 = _932.y * _79;
        float _938 = _932.z * _79;
        if (isfinite(max(max(_936, _937), _938))) {
          float _947 = invLinearBegin * _936;
          float _953 = invLinearBegin * _937;
          float _959 = invLinearBegin * _938;
          float _966 = select((_936 >= linearBegin), 0.0f, (1.0f - ((_947 * _947) * (3.0f - (_947 * 2.0f)))));
          float _968 = select((_937 >= linearBegin), 0.0f, (1.0f - ((_953 * _953) * (3.0f - (_953 * 2.0f)))));
          float _970 = select((_938 >= linearBegin), 0.0f, (1.0f - ((_959 * _959) * (3.0f - (_959 * 2.0f)))));
          float _976 = select((_936 < linearStart), 0.0f, 1.0f);
          float _977 = select((_937 < linearStart), 0.0f, 1.0f);
          float _978 = select((_938 < linearStart), 0.0f, 1.0f);
          _1412 = (((((contrast * _936) + madLinearStartContrastFactor) * ((1.0f - _976) - _966)) + (((pow(_947, toe))*_966) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _936) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _976));
          _1413 = (((((contrast * _937) + madLinearStartContrastFactor) * ((1.0f - _977) - _968)) + (((pow(_953, toe))*_968) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _937) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _977));
          _1414 = (((((contrast * _938) + madLinearStartContrastFactor) * ((1.0f - _978) - _970)) + (((pow(_959, toe))*_970) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _938) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _978));
          _1415 = 0.0f;
          _1416 = fOptimizedParam.x;
          _1417 = fOptimizedParam.y;
          _1418 = fOptimizedParam.z;
          _1419 = fOptimizedParam.w;
          _1420 = 1.0f;
        } else {
          _1412 = 1.0f;
          _1413 = 1.0f;
          _1414 = 1.0f;
          _1415 = 0.0f;
          _1416 = fOptimizedParam.x;
          _1417 = fOptimizedParam.y;
          _1418 = fOptimizedParam.z;
          _1419 = fOptimizedParam.w;
          _1420 = 1.0f;
        }
      } while (false);
    } else {
      float _1041 = screenInverseSize.x * SV_Position.x;
      float _1042 = screenInverseSize.y * SV_Position.y;
      do {
        if (_647) {
          float4 _1046 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_1041, _1042));
          _1304 = _1046.x;
          _1305 = _1046.y;
          _1306 = _1046.z;
        } else {
          bool _1055 = ((fHazeFilterAttribute & 2) == 0);
          float _1058 = tFilterTempMap1.Sample(BilinearWrap, float2(_1041, _1042));
          do {
            if (!_1055) {
              float _1063 = ReadonlyDepth.SampleLevel(PointClamp, float2(_1041, _1042), 0.0f);
              float _1069 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
              float _1070 = 1.0f - ((SV_Position.y * 2.0f) * screenInverseSize.y);
              float _1107 = 1.0f / (mad(_1063.x, (viewProjInvMat[2].w), mad(_1070, (viewProjInvMat[1].w), (_1069 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _1109 = _1107 * (mad(_1063.x, (viewProjInvMat[2].y), mad(_1070, (viewProjInvMat[1].y), (_1069 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _1117 = (_1107 * (mad(_1063.x, (viewProjInvMat[2].x), mad(_1070, (viewProjInvMat[1].x), (_1069 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _1118 = _1109 - (transposeViewInvMat[1].w);
              float _1119 = (_1107 * (mad(_1063.x, (viewProjInvMat[2].z), mad(_1070, (viewProjInvMat[1].z), (_1069 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _1144 = saturate(_1058.x * max(((sqrt(((_1118 * _1118) + (_1117 * _1117)) + (_1119 * _1119)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_1109 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _1145 = _1063.x;
            } else {
              _1144 = select(((fHazeFilterAttribute & 1) == 0), _1058.x, (1.0f - _1058.x));
              _1145 = 0.0f;
            }
            float _1150 = -0.0f - _1042;
            float _1173 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_1150, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _1041)));
            float _1174 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_1150, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _1041)));
            float _1175 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_1150, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _1041)));
            float _1181 = tVolumeMap.Sample(BilinearWrap, float3((_1173 + fHazeFilterUVWOffset.x), (_1174 + fHazeFilterUVWOffset.y), (_1175 + fHazeFilterUVWOffset.z)));
            float _1184 = _1173 * 2.0f;
            float _1185 = _1174 * 2.0f;
            float _1186 = _1175 * 2.0f;
            float _1190 = tVolumeMap.Sample(BilinearWrap, float3((_1184 + fHazeFilterUVWOffset.x), (_1185 + fHazeFilterUVWOffset.y), (_1186 + fHazeFilterUVWOffset.z)));
            float _1194 = _1173 * 4.0f;
            float _1195 = _1174 * 4.0f;
            float _1196 = _1175 * 4.0f;
            float _1200 = tVolumeMap.Sample(BilinearWrap, float3((_1194 + fHazeFilterUVWOffset.x), (_1195 + fHazeFilterUVWOffset.y), (_1196 + fHazeFilterUVWOffset.z)));
            float _1204 = _1173 * 8.0f;
            float _1205 = _1174 * 8.0f;
            float _1206 = _1175 * 8.0f;
            float _1210 = tVolumeMap.Sample(BilinearWrap, float3((_1204 + fHazeFilterUVWOffset.x), (_1205 + fHazeFilterUVWOffset.y), (_1206 + fHazeFilterUVWOffset.z)));
            float _1214 = fHazeFilterUVWOffset.x + 0.5f;
            float _1215 = fHazeFilterUVWOffset.y + 0.5f;
            float _1216 = fHazeFilterUVWOffset.z + 0.5f;
            float _1220 = tVolumeMap.Sample(BilinearWrap, float3((_1173 + _1214), (_1174 + _1215), (_1175 + _1216)));
            float _1226 = tVolumeMap.Sample(BilinearWrap, float3((_1184 + _1214), (_1185 + _1215), (_1186 + _1216)));
            float _1233 = tVolumeMap.Sample(BilinearWrap, float3((_1194 + _1214), (_1195 + _1215), (_1196 + _1216)));
            float _1240 = tVolumeMap.Sample(BilinearWrap, float3((_1204 + _1214), (_1205 + _1215), (_1206 + _1216)));
            float _1251 = (((((((_1190.x * 0.25f) + (_1181.x * 0.5f)) + (_1200.x * 0.125f)) + (_1210.x * 0.0625f)) * 2.0f) + -1.0f) * _1144) * fHazeFilterScale;
            float _1253 = (fHazeFilterScale * _1144) * ((((((_1226.x * 0.25f) + (_1220.x * 0.5f)) + (_1233.x * 0.125f)) + (_1240.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _1267 = 0.5f / fHazeFilterBorder;
                float _1274 = saturate(max(((_1267 * min(max((abs(_1041 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_1267 * min(max((abs(_1042 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _1280 = (_1251 - (_1274 * _1251));
                _1281 = (_1253 - (_1274 * _1253));
              } else {
                _1280 = _1251;
                _1281 = _1253;
              }
              do {
                if (!_1055) {
                  float _1286 = ReadonlyDepth.Sample(BilinearWrap, float2((_1280 + _1041), (_1281 + _1042)));
                  if (!(!((_1286.x - _1145) >= fHazeFilterDepthDiffBias))) {
                    _1293 = 0.0f;
                    _1294 = 0.0f;
                  } else {
                    _1293 = _1280;
                    _1294 = _1281;
                  }
                } else {
                  _1293 = _1280;
                  _1294 = _1281;
                }
                float4 _1299 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1293 + _1041), (_1294 + _1042)));
                _1304 = _1299.x;
                _1305 = _1299.y;
                _1306 = _1299.z;
              } while (false);
            } while (false);
          } while (false);
        }
        float _1307 = _1304 * _79;
        float _1308 = _1305 * _79;
        float _1309 = _1306 * _79;
        if (isfinite(max(max(_1307, _1308), _1309))) {
          float _1318 = invLinearBegin * _1307;
          float _1324 = invLinearBegin * _1308;
          float _1330 = invLinearBegin * _1309;
          float _1337 = select((_1307 >= linearBegin), 0.0f, (1.0f - ((_1318 * _1318) * (3.0f - (_1318 * 2.0f)))));
          float _1339 = select((_1308 >= linearBegin), 0.0f, (1.0f - ((_1324 * _1324) * (3.0f - (_1324 * 2.0f)))));
          float _1341 = select((_1309 >= linearBegin), 0.0f, (1.0f - ((_1330 * _1330) * (3.0f - (_1330 * 2.0f)))));
          float _1347 = select((_1307 < linearStart), 0.0f, 1.0f);
          float _1348 = select((_1308 < linearStart), 0.0f, 1.0f);
          float _1349 = select((_1309 < linearStart), 0.0f, 1.0f);
          _1412 = (((((contrast * _1307) + madLinearStartContrastFactor) * ((1.0f - _1347) - _1337)) + (((pow(_1318, toe))*_1337) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1307) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1347));
          _1413 = (((((contrast * _1308) + madLinearStartContrastFactor) * ((1.0f - _1348) - _1339)) + (((pow(_1324, toe))*_1339) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1308) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1348));
          _1414 = (((((contrast * _1309) + madLinearStartContrastFactor) * ((1.0f - _1349) - _1341)) + (((pow(_1330, toe))*_1341) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1309) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1349));
          _1415 = 0.0f;
          _1416 = 0.0f;
          _1417 = 0.0f;
          _1418 = 0.0f;
          _1419 = 0.0f;
          _1420 = 1.0f;
        } else {
          _1412 = 1.0f;
          _1413 = 1.0f;
          _1414 = 1.0f;
          _1415 = 0.0f;
          _1416 = 0.0f;
          _1417 = 0.0f;
          _1418 = 0.0f;
          _1419 = 0.0f;
          _1420 = 1.0f;
        }
      } while (false);
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _1442 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1446 = ComputeResultSRV[0].computeAlpha;
    float _1449 = ((1.0f - _1442) + (_1446 * _1442)) * cbRadialColor.w;
    if (!(_1449 == 0.0f)) {
      float _1457 = screenInverseSize.x * SV_Position.x;
      float _1458 = screenInverseSize.y * SV_Position.y;
      float _1460 = (-0.5f - cbRadialScreenPos.x) + _1457;
      float _1462 = (-0.5f - cbRadialScreenPos.y) + _1458;
      float _1465 = select((_1460 < 0.0f), (1.0f - _1457), _1457);
      float _1468 = select((_1462 < 0.0f), (1.0f - _1458), _1458);
      float _1473 = rsqrt(dot(float2(_1460, _1462), float2(_1460, _1462))) * cbRadialSharpRange;
      uint _1480 = uint(abs(_1473 * _1462)) + uint(abs(_1473 * _1460));
      uint _1484 = ((_1480 ^ 61) ^ ((uint)(_1480) >> 16)) * 9;
      uint _1487 = (((uint)(_1484) >> 4) ^ _1484) * 668265261;
      float _1492 = select(((cbRadialBlurFlags & 1) != 0), (float((uint)((int)(((uint)(_1487) >> 15) ^ _1487))) * 2.3283064365386963e-10f), 1.0f);
      float _1498 = 1.0f / max(1.0f, sqrt((_1460 * _1460) + (_1462 * _1462)));
      float _1499 = cbRadialBlurPower * -0.0011111111380159855f;
      float _1508 = ((((_1499 * _1465) * _1492) * _1498) + 1.0f) * _1460;
      float _1509 = ((((_1499 * _1468) * _1492) * _1498) + 1.0f) * _1462;
      float _1511 = cbRadialBlurPower * -0.002222222276031971f;
      float _1520 = ((((_1511 * _1465) * _1492) * _1498) + 1.0f) * _1460;
      float _1521 = ((((_1511 * _1468) * _1492) * _1498) + 1.0f) * _1462;
      float _1522 = cbRadialBlurPower * -0.0033333334140479565f;
      float _1531 = ((((_1522 * _1465) * _1492) * _1498) + 1.0f) * _1460;
      float _1532 = ((((_1522 * _1468) * _1492) * _1498) + 1.0f) * _1462;
      float _1533 = cbRadialBlurPower * -0.004444444552063942f;
      float _1542 = ((((_1533 * _1465) * _1492) * _1498) + 1.0f) * _1460;
      float _1543 = ((((_1533 * _1468) * _1492) * _1498) + 1.0f) * _1462;
      float _1544 = cbRadialBlurPower * -0.0055555556900799274f;
      float _1553 = ((((_1544 * _1465) * _1492) * _1498) + 1.0f) * _1460;
      float _1554 = ((((_1544 * _1468) * _1492) * _1498) + 1.0f) * _1462;
      float _1555 = cbRadialBlurPower * -0.006666666828095913f;
      float _1564 = ((((_1555 * _1465) * _1492) * _1498) + 1.0f) * _1460;
      float _1565 = ((((_1555 * _1468) * _1492) * _1498) + 1.0f) * _1462;
      float _1566 = cbRadialBlurPower * -0.007777777966111898f;
      float _1575 = ((((_1566 * _1465) * _1492) * _1498) + 1.0f) * _1460;
      float _1576 = ((((_1566 * _1468) * _1492) * _1498) + 1.0f) * _1462;
      float _1577 = cbRadialBlurPower * -0.008888889104127884f;
      float _1586 = ((((_1577 * _1465) * _1492) * _1498) + 1.0f) * _1460;
      float _1587 = ((((_1577 * _1468) * _1492) * _1498) + 1.0f) * _1462;
      float _1588 = cbRadialBlurPower * -0.009999999776482582f;
      float _1597 = ((((_1588 * _1465) * _1492) * _1498) + 1.0f) * _1460;
      float _1598 = ((((_1588 * _1468) * _1492) * _1498) + 1.0f) * _1462;
      float _1599 = (_78 * Exposure) * 0.10000000149011612f;
      float _1600 = _1599 * cbRadialColor.x;
      float _1601 = _1599 * cbRadialColor.y;
      float _1602 = _1599 * cbRadialColor.z;
      do {
        if (_54) {
          float _1604 = _1508 + cbRadialScreenPos.x;
          float _1605 = _1509 + cbRadialScreenPos.y;
          float _1609 = ((dot(float2(_1604, _1605), float2(_1604, _1605)) * _1415) + 1.0f) * _1420;
          float4 _1615 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1609 * _1604) + 0.5f), ((_1609 * _1605) + 0.5f)), 0.0f);
          float _1619 = _1520 + cbRadialScreenPos.x;
          float _1620 = _1521 + cbRadialScreenPos.y;
          float _1623 = (dot(float2(_1619, _1620), float2(_1619, _1620)) * _1415) + 1.0f;
          float4 _1630 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1619 * _1420) * _1623) + 0.5f), (((_1620 * _1420) * _1623) + 0.5f)), 0.0f);
          float _1637 = _1531 + cbRadialScreenPos.x;
          float _1638 = _1532 + cbRadialScreenPos.y;
          float _1641 = (dot(float2(_1637, _1638), float2(_1637, _1638)) * _1415) + 1.0f;
          float4 _1648 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1637 * _1420) * _1641) + 0.5f), (((_1638 * _1420) * _1641) + 0.5f)), 0.0f);
          float _1655 = _1542 + cbRadialScreenPos.x;
          float _1656 = _1543 + cbRadialScreenPos.y;
          float _1659 = (dot(float2(_1655, _1656), float2(_1655, _1656)) * _1415) + 1.0f;
          float4 _1666 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1655 * _1420) * _1659) + 0.5f), (((_1656 * _1420) * _1659) + 0.5f)), 0.0f);
          float _1673 = _1553 + cbRadialScreenPos.x;
          float _1674 = _1554 + cbRadialScreenPos.y;
          float _1677 = (dot(float2(_1673, _1674), float2(_1673, _1674)) * _1415) + 1.0f;
          float4 _1684 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1673 * _1420) * _1677) + 0.5f), (((_1674 * _1420) * _1677) + 0.5f)), 0.0f);
          float _1691 = _1564 + cbRadialScreenPos.x;
          float _1692 = _1565 + cbRadialScreenPos.y;
          float _1695 = (dot(float2(_1691, _1692), float2(_1691, _1692)) * _1415) + 1.0f;
          float4 _1702 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1691 * _1420) * _1695) + 0.5f), (((_1692 * _1420) * _1695) + 0.5f)), 0.0f);
          float _1709 = _1575 + cbRadialScreenPos.x;
          float _1710 = _1576 + cbRadialScreenPos.y;
          float _1713 = (dot(float2(_1709, _1710), float2(_1709, _1710)) * _1415) + 1.0f;
          float4 _1720 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1709 * _1420) * _1713) + 0.5f), (((_1710 * _1420) * _1713) + 0.5f)), 0.0f);
          float _1727 = _1586 + cbRadialScreenPos.x;
          float _1728 = _1587 + cbRadialScreenPos.y;
          float _1731 = (dot(float2(_1727, _1728), float2(_1727, _1728)) * _1415) + 1.0f;
          float4 _1738 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1727 * _1420) * _1731) + 0.5f), (((_1728 * _1420) * _1731) + 0.5f)), 0.0f);
          float _1745 = _1597 + cbRadialScreenPos.x;
          float _1746 = _1598 + cbRadialScreenPos.y;
          float _1749 = (dot(float2(_1745, _1746), float2(_1745, _1746)) * _1415) + 1.0f;
          float4 _1756 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1745 * _1420) * _1749) + 0.5f), (((_1746 * _1420) * _1749) + 0.5f)), 0.0f);
          float _1763 = _1600 * ((((((((_1630.x + _1615.x) + _1648.x) + _1666.x) + _1684.x) + _1702.x) + _1720.x) + _1738.x) + _1756.x);
          float _1764 = _1601 * ((((((((_1630.y + _1615.y) + _1648.y) + _1666.y) + _1684.y) + _1702.y) + _1720.y) + _1738.y) + _1756.y);
          float _1765 = _1602 * ((((((((_1630.z + _1615.z) + _1648.z) + _1666.z) + _1684.z) + _1702.z) + _1720.z) + _1738.z) + _1756.z);
          do {
            if (isfinite(max(max(_1763, _1764), _1765))) {
              float _1774 = invLinearBegin * _1763;
              float _1780 = invLinearBegin * _1764;
              float _1786 = invLinearBegin * _1765;
              float _1793 = select((_1763 >= linearBegin), 0.0f, (1.0f - ((_1774 * _1774) * (3.0f - (_1774 * 2.0f)))));
              float _1795 = select((_1764 >= linearBegin), 0.0f, (1.0f - ((_1780 * _1780) * (3.0f - (_1780 * 2.0f)))));
              float _1797 = select((_1765 >= linearBegin), 0.0f, (1.0f - ((_1786 * _1786) * (3.0f - (_1786 * 2.0f)))));
              float _1803 = select((_1763 < linearStart), 0.0f, 1.0f);
              float _1804 = select((_1764 < linearStart), 0.0f, 1.0f);
              float _1805 = select((_1765 < linearStart), 0.0f, 1.0f);
              _1868 = (((((contrast * _1763) + madLinearStartContrastFactor) * ((1.0f - _1803) - _1793)) + (((pow(_1774, toe))*_1793) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1763) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1803));
              _1869 = (((((contrast * _1764) + madLinearStartContrastFactor) * ((1.0f - _1804) - _1795)) + (((pow(_1780, toe))*_1795) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1764) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1804));
              _1870 = (((((contrast * _1765) + madLinearStartContrastFactor) * ((1.0f - _1805) - _1797)) + (((pow(_1786, toe))*_1797) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1765) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1805));
            } else {
              _1868 = 1.0f;
              _1869 = 1.0f;
              _1870 = 1.0f;
            }
            _2450 = (_1868 + ((_1412 * 0.10000000149011612f) * cbRadialColor.x));
            _2451 = (_1869 + ((_1413 * 0.10000000149011612f) * cbRadialColor.y));
            _2452 = (_1870 + ((_1414 * 0.10000000149011612f) * cbRadialColor.z));
          } while (false);
        } else {
          float _1881 = cbRadialScreenPos.x + 0.5f;
          float _1882 = _1881 + _1508;
          float _1883 = cbRadialScreenPos.y + 0.5f;
          float _1884 = _1883 + _1509;
          float _1885 = _1881 + _1520;
          float _1886 = _1883 + _1521;
          float _1887 = _1881 + _1531;
          float _1888 = _1883 + _1532;
          float _1889 = _1881 + _1542;
          float _1890 = _1883 + _1543;
          float _1891 = _1881 + _1553;
          float _1892 = _1883 + _1554;
          float _1893 = _1881 + _1564;
          float _1894 = _1883 + _1565;
          float _1895 = _1881 + _1575;
          float _1896 = _1883 + _1576;
          float _1897 = _1881 + _1586;
          float _1898 = _1883 + _1587;
          float _1899 = _1881 + _1597;
          float _1900 = _1883 + _1598;
          if (_56) {
            float _1904 = (_1882 * 2.0f) + -1.0f;
            float _1908 = sqrt((_1904 * _1904) + 1.0f);
            float _1909 = 1.0f / _1908;
            float _1912 = (_1908 * _1418) * (_1909 + _1416);
            float _1916 = _1419 * 0.5f;
            float4 _1925 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1916 * _1912) * _1904) + 0.5f), ((((_1916 * (((_1909 + -1.0f) * _1417) + 1.0f)) * _1912) * ((_1884 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _1931 = (_1885 * 2.0f) + -1.0f;
            float _1935 = sqrt((_1931 * _1931) + 1.0f);
            float _1936 = 1.0f / _1935;
            float _1939 = (_1935 * _1418) * (_1936 + _1416);
            float4 _1950 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1916 * _1931) * _1939) + 0.5f), ((((_1916 * ((_1886 * 2.0f) + -1.0f)) * (((_1936 + -1.0f) * _1417) + 1.0f)) * _1939) + 0.5f)), 0.0f);
            float _1959 = (_1887 * 2.0f) + -1.0f;
            float _1963 = sqrt((_1959 * _1959) + 1.0f);
            float _1964 = 1.0f / _1963;
            float _1967 = (_1963 * _1418) * (_1964 + _1416);
            float4 _1978 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1916 * _1959) * _1967) + 0.5f), ((((_1916 * ((_1888 * 2.0f) + -1.0f)) * (((_1964 + -1.0f) * _1417) + 1.0f)) * _1967) + 0.5f)), 0.0f);
            float _1987 = (_1889 * 2.0f) + -1.0f;
            float _1991 = sqrt((_1987 * _1987) + 1.0f);
            float _1992 = 1.0f / _1991;
            float _1995 = (_1991 * _1418) * (_1992 + _1416);
            float4 _2006 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1916 * _1987) * _1995) + 0.5f), ((((_1916 * ((_1890 * 2.0f) + -1.0f)) * (((_1992 + -1.0f) * _1417) + 1.0f)) * _1995) + 0.5f)), 0.0f);
            float _2015 = (_1891 * 2.0f) + -1.0f;
            float _2019 = sqrt((_2015 * _2015) + 1.0f);
            float _2020 = 1.0f / _2019;
            float _2023 = (_2019 * _1418) * (_2020 + _1416);
            float4 _2034 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1916 * _2015) * _2023) + 0.5f), ((((_1916 * ((_1892 * 2.0f) + -1.0f)) * (((_2020 + -1.0f) * _1417) + 1.0f)) * _2023) + 0.5f)), 0.0f);
            float _2043 = (_1893 * 2.0f) + -1.0f;
            float _2047 = sqrt((_2043 * _2043) + 1.0f);
            float _2048 = 1.0f / _2047;
            float _2051 = (_2047 * _1418) * (_2048 + _1416);
            float4 _2062 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1916 * _2043) * _2051) + 0.5f), ((((_1916 * ((_1894 * 2.0f) + -1.0f)) * (((_2048 + -1.0f) * _1417) + 1.0f)) * _2051) + 0.5f)), 0.0f);
            float _2071 = (_1895 * 2.0f) + -1.0f;
            float _2075 = sqrt((_2071 * _2071) + 1.0f);
            float _2076 = 1.0f / _2075;
            float _2079 = (_2075 * _1418) * (_2076 + _1416);
            float4 _2090 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1916 * _2071) * _2079) + 0.5f), ((((_1916 * ((_1896 * 2.0f) + -1.0f)) * (((_2076 + -1.0f) * _1417) + 1.0f)) * _2079) + 0.5f)), 0.0f);
            float _2099 = (_1897 * 2.0f) + -1.0f;
            float _2103 = sqrt((_2099 * _2099) + 1.0f);
            float _2104 = 1.0f / _2103;
            float _2107 = (_2103 * _1418) * (_2104 + _1416);
            float4 _2118 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1916 * _2099) * _2107) + 0.5f), ((((_1916 * ((_1898 * 2.0f) + -1.0f)) * (((_2104 + -1.0f) * _1417) + 1.0f)) * _2107) + 0.5f)), 0.0f);
            float _2127 = (_1899 * 2.0f) + -1.0f;
            float _2131 = sqrt((_2127 * _2127) + 1.0f);
            float _2132 = 1.0f / _2131;
            float _2135 = (_2131 * _1418) * (_2132 + _1416);
            float4 _2146 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1916 * _2127) * _2135) + 0.5f), ((((_1916 * ((_1900 * 2.0f) + -1.0f)) * (((_2132 + -1.0f) * _1417) + 1.0f)) * _2135) + 0.5f)), 0.0f);
            float _2153 = _1600 * ((((((((_1950.x + _1925.x) + _1978.x) + _2006.x) + _2034.x) + _2062.x) + _2090.x) + _2118.x) + _2146.x);
            float _2154 = _1601 * ((((((((_1950.y + _1925.y) + _1978.y) + _2006.y) + _2034.y) + _2062.y) + _2090.y) + _2118.y) + _2146.y);
            float _2155 = _1602 * ((((((((_1950.z + _1925.z) + _1978.z) + _2006.z) + _2034.z) + _2062.z) + _2090.z) + _2118.z) + _2146.z);
            do {
              if (isfinite(max(max(_2153, _2154), _2155))) {
                float _2164 = invLinearBegin * _2153;
                float _2170 = invLinearBegin * _2154;
                float _2176 = invLinearBegin * _2155;
                float _2183 = select((_2153 >= linearBegin), 0.0f, (1.0f - ((_2164 * _2164) * (3.0f - (_2164 * 2.0f)))));
                float _2185 = select((_2154 >= linearBegin), 0.0f, (1.0f - ((_2170 * _2170) * (3.0f - (_2170 * 2.0f)))));
                float _2187 = select((_2155 >= linearBegin), 0.0f, (1.0f - ((_2176 * _2176) * (3.0f - (_2176 * 2.0f)))));
                float _2193 = select((_2153 < linearStart), 0.0f, 1.0f);
                float _2194 = select((_2154 < linearStart), 0.0f, 1.0f);
                float _2195 = select((_2155 < linearStart), 0.0f, 1.0f);
                _2258 = (((((contrast * _2153) + madLinearStartContrastFactor) * ((1.0f - _2193) - _2183)) + (((pow(_2164, toe))*_2183) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2153) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2193));
                _2259 = (((((contrast * _2154) + madLinearStartContrastFactor) * ((1.0f - _2194) - _2185)) + (((pow(_2170, toe))*_2185) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2154) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2194));
                _2260 = (((((contrast * _2155) + madLinearStartContrastFactor) * ((1.0f - _2195) - _2187)) + (((pow(_2176, toe))*_2187) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2155) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2195));
              } else {
                _2258 = 1.0f;
                _2259 = 1.0f;
                _2260 = 1.0f;
              }
              _2450 = (_2258 + ((_1412 * 0.10000000149011612f) * cbRadialColor.x));
              _2451 = (_2259 + ((_1413 * 0.10000000149011612f) * cbRadialColor.y));
              _2452 = (_2260 + ((_1414 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          } else {
            float4 _2272 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1882, _1884), 0.0f);
            float4 _2276 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1885, _1886), 0.0f);
            float4 _2283 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1887, _1888), 0.0f);
            float4 _2290 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1889, _1890), 0.0f);
            float4 _2297 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1891, _1892), 0.0f);
            float4 _2304 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1893, _1894), 0.0f);
            float4 _2311 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1895, _1896), 0.0f);
            float4 _2318 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1897, _1898), 0.0f);
            float4 _2325 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1899, _1900), 0.0f);
            float _2332 = _1600 * ((((((((_2276.x + _2272.x) + _2283.x) + _2290.x) + _2297.x) + _2304.x) + _2311.x) + _2318.x) + _2325.x);
            float _2333 = _1601 * ((((((((_2276.y + _2272.y) + _2283.y) + _2290.y) + _2297.y) + _2304.y) + _2311.y) + _2318.y) + _2325.y);
            float _2334 = _1602 * ((((((((_2276.z + _2272.z) + _2283.z) + _2290.z) + _2297.z) + _2304.z) + _2311.z) + _2318.z) + _2325.z);
            do {
              if (isfinite(max(max(_2332, _2333), _2334))) {
                float _2343 = invLinearBegin * _2332;
                float _2349 = invLinearBegin * _2333;
                float _2355 = invLinearBegin * _2334;
                float _2362 = select((_2332 >= linearBegin), 0.0f, (1.0f - ((_2343 * _2343) * (3.0f - (_2343 * 2.0f)))));
                float _2364 = select((_2333 >= linearBegin), 0.0f, (1.0f - ((_2349 * _2349) * (3.0f - (_2349 * 2.0f)))));
                float _2366 = select((_2334 >= linearBegin), 0.0f, (1.0f - ((_2355 * _2355) * (3.0f - (_2355 * 2.0f)))));
                float _2372 = select((_2332 < linearStart), 0.0f, 1.0f);
                float _2373 = select((_2333 < linearStart), 0.0f, 1.0f);
                float _2374 = select((_2334 < linearStart), 0.0f, 1.0f);
                _2437 = (((((contrast * _2332) + madLinearStartContrastFactor) * ((1.0f - _2372) - _2362)) + (((pow(_2343, toe))*_2362) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2332) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2372));
                _2438 = (((((contrast * _2333) + madLinearStartContrastFactor) * ((1.0f - _2373) - _2364)) + (((pow(_2349, toe))*_2364) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2333) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2373));
                _2439 = (((((contrast * _2334) + madLinearStartContrastFactor) * ((1.0f - _2374) - _2366)) + (((pow(_2355, toe))*_2366) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2334) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2374));
              } else {
                _2437 = 1.0f;
                _2438 = 1.0f;
                _2439 = 1.0f;
              }
              _2450 = (_2437 + ((_1412 * 0.10000000149011612f) * cbRadialColor.x));
              _2451 = (_2438 + ((_1413 * 0.10000000149011612f) * cbRadialColor.y));
              _2452 = (_2439 + ((_1414 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          }
        }
        do {
          if (cbRadialMaskRate.x > 0.0f) {
            float _2461 = saturate((sqrt((_1460 * _1460) + (_1462 * _1462)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
            float _2467 = (((_2461 * _2461) * cbRadialMaskRate.x) * (3.0f - (_2461 * 2.0f))) + cbRadialMaskRate.y;
            _2478 = ((_2467 * (_2450 - _1412)) + _1412);
            _2479 = ((_2467 * (_2451 - _1413)) + _1413);
            _2480 = ((_2467 * (_2452 - _1414)) + _1414);
          } else {
            _2478 = _2450;
            _2479 = _2451;
            _2480 = _2452;
          }
          _2491 = (lerp(_1412, _2478, _1449));
          _2492 = (lerp(_1413, _2479, _1449));
          _2493 = (lerp(_1414, _2480, _1449));
        } while (false);
      } while (false);
    } else {
      _2491 = _1412;
      _2492 = _1413;
      _2493 = _1414;
    }
  } else {
    _2491 = _1412;
    _2492 = _1413;
    _2493 = _1414;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _2515 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
    float _2517 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
    float _2521 = frac(frac(dot(float2(_2515, _2517), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_2521 < fNoiseDensity) {
        int _2526 = (uint)(uint(_2517 * _2515)) ^ 12345391;
        uint _2527 = _2526 * 3635641;
        _2535 = (float((uint)((int)((((uint)(_2527) >> 26) | ((uint)(_2526 * 232681024))) ^ _2527))) * 2.3283064365386963e-10f);
      } else {
        _2535 = 0.0f;
      }
      float _2537 = frac(_2521 * 757.4846801757812f);
      do {
        if (_2537 < fNoiseDensity) {
          int _2541 = asint(_2537) ^ 12345391;
          uint _2542 = _2541 * 3635641;
          _2551 = ((float((uint)((int)((((uint)(_2542) >> 26) | ((uint)(_2541 * 232681024))) ^ _2542))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _2551 = 0.0f;
        }
        float _2553 = frac(_2537 * 757.4846801757812f);
        do {
          if (_2553 < fNoiseDensity) {
            int _2557 = asint(_2553) ^ 12345391;
            uint _2558 = _2557 * 3635641;
            _2567 = ((float((uint)((int)((((uint)(_2558) >> 26) | ((uint)(_2557 * 232681024))) ^ _2558))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _2567 = 0.0f;
          }
          float _2568 = _2535 * fNoisePower.x;
          float _2569 = _2567 * fNoisePower.y;
          float _2570 = _2551 * fNoisePower.y;
          float _2584 = exp2(log2(1.0f - saturate(dot(float3(saturate(_2491), saturate(_2492), saturate(_2493)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _2595 = ((_2584 * (mad(_2570, 1.4019999504089355f, _2568) - _2491)) + _2491);
          _2596 = ((_2584 * (mad(_2570, -0.7139999866485596f, mad(_2569, -0.3440000116825104f, _2568)) - _2492)) + _2492);
          _2597 = ((_2584 * (mad(_2569, 1.7719999551773071f, _2568) - _2493)) + _2493);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2595 = _2491;
    _2596 = _2492;
    _2597 = _2493;
  }
#if 1
  ApplyColorGrading(_2595, _2596, _2597,
                    _2814, _2815, _2816);
#else
  if (!((cPassEnabled & 4) == 0)) {
    float _2622 = max(max(_2595, _2596), _2597);
    bool _2623 = (_2622 > 1.0f);
    do {
      if (_2623) {
        _2629 = (_2595 / _2622);
        _2630 = (_2596 / _2622);
        _2631 = (_2597 / _2622);
      } else {
        _2629 = _2595;
        _2630 = _2596;
        _2631 = _2597;
      }
      float _2632 = fTextureInverseSize * 0.5f;
      do {
        _2643 = renodx::color::srgb::Encode(_2629);
        do {
          _2654 = renodx::color::srgb::Encode(_2630);
          do {
            _2665 = renodx::color::srgb::Encode(_2631);

            float _2666 = 1.0f - fTextureInverseSize;
            float _2670 = (_2643 * _2666) + _2632;
            float _2671 = (_2654 * _2666) + _2632;
            float _2672 = (_2665 * _2666) + _2632;
            float4 _2675 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2670, _2671, _2672), 0.0f);
            bool _2680 = (fTextureBlendRate2 > 0.0f);
            do {
              [branch]
              if (fTextureBlendRate > 0.0f) {
                float4 _2683 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2670, _2671, _2672), 0.0f);
                float _2693 = ((_2683.x - _2675.x) * fTextureBlendRate) + _2675.x;
                float _2694 = ((_2683.y - _2675.y) * fTextureBlendRate) + _2675.y;
                float _2695 = ((_2683.z - _2675.z) * fTextureBlendRate) + _2675.z;
                if (_2680) {
                  float4 _2731 = tTextureMap2.SampleLevel(TrilinearClamp, renodx::color::srgb::Encode(float3(_2693, _2694, _2695)), 0.0f);
                  _2794 = (lerp(_2693, _2731.x, fTextureBlendRate2));
                  _2795 = (lerp(_2694, _2731.y, fTextureBlendRate2));
                  _2796 = (lerp(_2695, _2731.z, fTextureBlendRate2));
                } else {
                  _2794 = _2693;
                  _2795 = _2694;
                  _2796 = _2695;
                }
              } else {
                if (_2680) {
                  float4 _2780 = tTextureMap2.SampleLevel(TrilinearClamp, renodx::color::srgb::Encode(_2675.rgb), 0.0f);
                  _2794 = (lerp(_2675.x, _2780.x, fTextureBlendRate2));
                  _2795 = (lerp(_2675.y, _2780.y, fTextureBlendRate2));
                  _2796 = (lerp(_2675.z, _2780.z, fTextureBlendRate2));
                } else {
                  _2794 = _2675.x;
                  _2795 = _2675.y;
                  _2796 = _2675.z;
                }
              }
              float _2800 = mad(_2796, (fColorMatrix[2].x), mad(_2795, (fColorMatrix[1].x), (_2794 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
              float _2804 = mad(_2796, (fColorMatrix[2].y), mad(_2795, (fColorMatrix[1].y), (_2794 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
              float _2808 = mad(_2796, (fColorMatrix[2].z), mad(_2795, (fColorMatrix[1].z), (_2794 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
              if (_2623) {
                _2814 = (_2800 * _2622);
                _2815 = (_2804 * _2622);
                _2816 = (_2808 * _2622);
              } else {
                _2814 = _2800;
                _2815 = _2804;
                _2816 = _2808;
              }
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2814 = _2595;
    _2815 = _2596;
    _2816 = _2597;
  }
#endif
  if (!((cPassEnabled & 8) == 0)) {
    _2851 = saturate(((cvdR.x * _2814) + (cvdR.y * _2815)) + (cvdR.z * _2816));
    _2852 = saturate(((cvdG.x * _2814) + (cvdG.y * _2815)) + (cvdG.z * _2816));
    _2853 = saturate(((cvdB.x * _2814) + (cvdB.y * _2815)) + (cvdB.z * _2816));
  } else {
    _2851 = _2814;
    _2852 = _2815;
    _2853 = _2816;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2868 = screenInverseSize.x * SV_Position.x;
    float _2869 = screenInverseSize.y * SV_Position.y;
    float4 _2872 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2868, _2869), 0.0f);
    float _2877 = _2872.x * ColorParam.x;
    float _2878 = _2872.y * ColorParam.y;
    float _2879 = _2872.z * ColorParam.z;
    float _2882 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2868, _2869), 0.0f);
    float _2887 = (_2872.w * ColorParam.w) * saturate((_2882.x * Levels_Rate) + Levels_Range);
    _2925 = (((select((_2877 < 0.5f), ((_2851 * 2.0f) * _2877), (1.0f - (((1.0f - _2851) * 2.0f) * (1.0f - _2877)))) - _2851) * _2887) + _2851);
    _2926 = (((select((_2878 < 0.5f), ((_2852 * 2.0f) * _2878), (1.0f - (((1.0f - _2852) * 2.0f) * (1.0f - _2878)))) - _2852) * _2887) + _2852);
    _2927 = (((select((_2879 < 0.5f), ((_2853 * 2.0f) * _2879), (1.0f - (((1.0f - _2853) * 2.0f) * (1.0f - _2879)))) - _2853) * _2887) + _2853);
  } else {
    _2925 = _2851;
    _2926 = _2852;
    _2927 = _2853;
  }
  SV_Target.x = _2925;
  SV_Target.y = _2926;
  SV_Target.z = _2927;
  SV_Target.w = 0.0f;

#if 1
  if (TONE_MAP_TYPE != 0) {
    float2 grain_uv = SV_Position.xy * screenInverseSize;
    SV_Target.rgb = ApplyToneMap(SV_Target.rgb, grain_uv);
  }
#endif

  return SV_Target;
}
