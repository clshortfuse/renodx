#define SHADER_HASH 0x1F9104F3

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
//   row_major float4x4 fColorMatrix : packoffset(c001.x);
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
  bool _44 = ((cPassEnabled & 1) != 0);
  bool _48 = _44 && (bool)(distortionType == 0);
  bool _50 = _44 && (bool)(distortionType == 1);
  int _52 = ((uint)((int)(cPassEnabled)) >> 6) & 1;
  float _176;
  float _177;
  float _310;
  float _311;
  float _323;
  float _324;
  float _328;
  float _329;
  float _512;
  float _566;
  float _749;
  float _750;
  float _883;
  float _884;
  float _896;
  float _897;
  float _901;
  float _902;
  float _1117;
  float _1118;
  float _1253;
  float _1254;
  float _1266;
  float _1267;
  float _1277;
  float _1278;
  float _1279;
  float _1385;
  float _1386;
  float _1387;
  float _1388;
  float _1389;
  float _1390;
  float _1391;
  float _1392;
  float _1393;
  float _1840;
  float _1841;
  float _1842;
  float _2230;
  float _2231;
  float _2232;
  float _2409;
  float _2410;
  float _2411;
  float _2422;
  float _2423;
  float _2424;
  float _2450;
  float _2451;
  float _2452;
  float _2463;
  float _2464;
  float _2465;
  float _2507;
  float _2523;
  float _2539;
  float _2567;
  float _2568;
  float _2569;
  float _2601;
  float _2602;
  float _2603;
  float _2615;
  float _2626;
  float _2637;
  float _2679;
  float _2690;
  float _2701;
  float _2728;
  float _2739;
  float _2750;
  float _2766;
  float _2767;
  float _2768;
  float _2786;
  float _2787;
  float _2788;
  float _2823;
  float _2824;
  float _2825;
  float _2897;
  float _2898;
  float _2899;
  if (_48) {
    float _65 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _66 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _67 = dot(float2(_65, _66), float2(_65, _66));
    float _70 = ((_67 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float _71 = _70 * _65;
    float _72 = _70 * _66;
    float _73 = _71 + 0.5f;
    float _74 = _72 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        if (!(_52 == 0)) {
          bool _85 = ((fHazeFilterAttribute & 2) == 0);
          float _88 = tFilterTempMap1.Sample(BilinearWrap, float2(_73, _74));
          do {
            if (!_85) {
              float _93 = ReadonlyDepth.SampleLevel(PointClamp, float2(_73, _74), 0.0f);
              float _101 = (((_73 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
              float _102 = 1.0f - (((_74 * 2.0f) * screenSize.y) * screenInverseSize.y);
              float _139 = 1.0f / (mad(_93.x, (viewProjInvMat[2].w), mad(_102, (viewProjInvMat[1].w), (_101 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _141 = _139 * (mad(_93.x, (viewProjInvMat[2].y), mad(_102, (viewProjInvMat[1].y), (_101 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _149 = (_139 * (mad(_93.x, (viewProjInvMat[2].x), mad(_102, (viewProjInvMat[1].x), (_101 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _150 = _141 - (transposeViewInvMat[1].w);
              float _151 = (_139 * (mad(_93.x, (viewProjInvMat[2].z), mad(_102, (viewProjInvMat[1].z), (_101 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _176 = saturate(_88.x * max(((sqrt(((_150 * _150) + (_149 * _149)) + (_151 * _151)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_141 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _177 = _93.x;
            } else {
              _176 = select(((fHazeFilterAttribute & 1) == 0), _88.x, (1.0f - _88.x));
              _177 = 0.0f;
            }
            float _182 = -0.0f - _74;
            float _205 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_182, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _73)));
            float _206 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_182, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _73)));
            float _207 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_182, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _73)));
            float _213 = tVolumeMap.Sample(BilinearWrap, float3((_205 + fHazeFilterUVWOffset.x), (_206 + fHazeFilterUVWOffset.y), (_207 + fHazeFilterUVWOffset.z)));
            float _216 = _205 * 2.0f;
            float _217 = _206 * 2.0f;
            float _218 = _207 * 2.0f;
            float _222 = tVolumeMap.Sample(BilinearWrap, float3((_216 + fHazeFilterUVWOffset.x), (_217 + fHazeFilterUVWOffset.y), (_218 + fHazeFilterUVWOffset.z)));
            float _226 = _205 * 4.0f;
            float _227 = _206 * 4.0f;
            float _228 = _207 * 4.0f;
            float _232 = tVolumeMap.Sample(BilinearWrap, float3((_226 + fHazeFilterUVWOffset.x), (_227 + fHazeFilterUVWOffset.y), (_228 + fHazeFilterUVWOffset.z)));
            float _236 = _205 * 8.0f;
            float _237 = _206 * 8.0f;
            float _238 = _207 * 8.0f;
            float _242 = tVolumeMap.Sample(BilinearWrap, float3((_236 + fHazeFilterUVWOffset.x), (_237 + fHazeFilterUVWOffset.y), (_238 + fHazeFilterUVWOffset.z)));
            float _246 = fHazeFilterUVWOffset.x + 0.5f;
            float _247 = fHazeFilterUVWOffset.y + 0.5f;
            float _248 = fHazeFilterUVWOffset.z + 0.5f;
            float _252 = tVolumeMap.Sample(BilinearWrap, float3((_205 + _246), (_206 + _247), (_207 + _248)));
            float _258 = tVolumeMap.Sample(BilinearWrap, float3((_216 + _246), (_217 + _247), (_218 + _248)));
            float _265 = tVolumeMap.Sample(BilinearWrap, float3((_226 + _246), (_227 + _247), (_228 + _248)));
            float _272 = tVolumeMap.Sample(BilinearWrap, float3((_236 + _246), (_237 + _247), (_238 + _248)));
            float _283 = (((((((_222.x * 0.25f) + (_213.x * 0.5f)) + (_232.x * 0.125f)) + (_242.x * 0.0625f)) * 2.0f) + -1.0f) * _176) * fHazeFilterScale;
            float _285 = (fHazeFilterScale * _176) * ((((((_258.x * 0.25f) + (_252.x * 0.5f)) + (_265.x * 0.125f)) + (_272.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _297 = 0.5f / fHazeFilterBorder;
                float _304 = saturate(max(((_297 * min(max((abs(_71) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_297 * min(max((abs(_72) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _310 = (_283 - (_304 * _283));
                _311 = (_285 - (_304 * _285));
              } else {
                _310 = _283;
                _311 = _285;
              }
              do {
                if (!_85) {
                  float _316 = ReadonlyDepth.Sample(BilinearWrap, float2((_310 + _73), (_311 + _74)));
                  if (!(!((_316.x - _177) >= fHazeFilterDepthDiffBias))) {
                    _323 = 0.0f;
                    _324 = 0.0f;
                  } else {
                    _323 = _310;
                    _324 = _311;
                  }
                } else {
                  _323 = _310;
                  _324 = _311;
                }
                _328 = (_323 + _73);
                _329 = (_324 + _74);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _328 = _73;
          _329 = _74;
        }
        float4 _332 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_328, _329));
        float _336 = _332.x * Exposure;
        float _337 = _332.y * Exposure;
        float _338 = _332.z * Exposure;
        if (isfinite(max(max(_336, _337), _338))) {
          float _347 = invLinearBegin * _336;
          float _353 = invLinearBegin * _337;
          float _359 = invLinearBegin * _338;
          float _366 = select((_336 >= linearBegin), 0.0f, (1.0f - ((_347 * _347) * (3.0f - (_347 * 2.0f)))));
          float _368 = select((_337 >= linearBegin), 0.0f, (1.0f - ((_353 * _353) * (3.0f - (_353 * 2.0f)))));
          float _370 = select((_338 >= linearBegin), 0.0f, (1.0f - ((_359 * _359) * (3.0f - (_359 * 2.0f)))));
          float _376 = select((_336 < linearStart), 0.0f, 1.0f);
          float _377 = select((_337 < linearStart), 0.0f, 1.0f);
          float _378 = select((_338 < linearStart), 0.0f, 1.0f);
          _1385 = (((((contrast * _336) + madLinearStartContrastFactor) * ((1.0f - _376) - _366)) + (((pow(_347, toe))*_366) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _336) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _376));
          _1386 = (((((contrast * _337) + madLinearStartContrastFactor) * ((1.0f - _377) - _368)) + (((pow(_353, toe))*_368) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _337) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _377));
          _1387 = (((((contrast * _338) + madLinearStartContrastFactor) * ((1.0f - _378) - _370)) + (((pow(_359, toe))*_370) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _338) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _378));
          _1388 = fDistortionCoef;
          _1389 = 0.0f;
          _1390 = 0.0f;
          _1391 = 0.0f;
          _1392 = 0.0f;
          _1393 = fCorrectCoef;
        } else {
          _1385 = 1.0f;
          _1386 = 1.0f;
          _1387 = 1.0f;
          _1388 = fDistortionCoef;
          _1389 = 0.0f;
          _1390 = 0.0f;
          _1391 = 0.0f;
          _1392 = 0.0f;
          _1393 = fCorrectCoef;
        }
      } while (false);
    } else {
      float _441 = _67 + fRefraction;
      float _443 = (_441 * fDistortionCoef) + 1.0f;
      float _444 = _65 * fCorrectCoef;
      float _446 = _66 * fCorrectCoef;
      float _452 = ((_441 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _459 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_73, _74));
      float _463 = _459.x * Exposure;
      do {
        if (isfinite(max(max(_463, (_459.y * Exposure)), (_459.z * Exposure)))) {
          float _474 = invLinearBegin * _463;
          float _481 = select((_463 >= linearBegin), 0.0f, (1.0f - ((_474 * _474) * (3.0f - (_474 * 2.0f)))));
          float _485 = select((_463 < linearStart), 0.0f, 1.0f);
          _512 = (((((contrast * _463) + madLinearStartContrastFactor) * ((1.0f - _485) - _481)) + ((linearBegin * (pow(_474, toe))) * _481)) + ((maxNit - (exp2((contrastFactor * _463) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _485));
        } else {
          _512 = 1.0f;
        }
        float4 _513 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_444 * _443) + 0.5f), ((_446 * _443) + 0.5f)));
        float _518 = _513.y * Exposure;
        do {
          if (isfinite(max(max((_513.x * Exposure), _518), (_513.z * Exposure)))) {
            float _528 = invLinearBegin * _518;
            float _535 = select((_518 >= linearBegin), 0.0f, (1.0f - ((_528 * _528) * (3.0f - (_528 * 2.0f)))));
            float _539 = select((_518 < linearStart), 0.0f, 1.0f);
            _566 = (((((contrast * _518) + madLinearStartContrastFactor) * ((1.0f - _539) - _535)) + ((linearBegin * (pow(_528, toe))) * _535)) + ((maxNit - (exp2((contrastFactor * _518) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _539));
          } else {
            _566 = 1.0f;
          }
          float4 _567 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_444 * _452) + 0.5f), ((_446 * _452) + 0.5f)));
          float _573 = _567.z * Exposure;
          if (isfinite(max(max((_567.x * Exposure), (_567.y * Exposure)), _573))) {
            float _582 = invLinearBegin * _573;
            float _589 = select((_573 >= linearBegin), 0.0f, (1.0f - ((_582 * _582) * (3.0f - (_582 * 2.0f)))));
            float _593 = select((_573 < linearStart), 0.0f, 1.0f);
            _1385 = _512;
            _1386 = _566;
            _1387 = (((((contrast * _573) + madLinearStartContrastFactor) * ((1.0f - _593) - _589)) + ((linearBegin * (pow(_582, toe))) * _589)) + ((maxNit - (exp2((contrastFactor * _573) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _593));
            _1388 = fDistortionCoef;
            _1389 = 0.0f;
            _1390 = 0.0f;
            _1391 = 0.0f;
            _1392 = 0.0f;
            _1393 = fCorrectCoef;
          } else {
            _1385 = _512;
            _1386 = _566;
            _1387 = 1.0f;
            _1388 = fDistortionCoef;
            _1389 = 0.0f;
            _1390 = 0.0f;
            _1391 = 0.0f;
            _1392 = 0.0f;
            _1393 = fCorrectCoef;
          }
        } while (false);
      } while (false);
    }
  } else {
    bool _620 = (_52 == 0);
    if (_50) {
      float _631 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _635 = sqrt((_631 * _631) + 1.0f);
      float _636 = 1.0f / _635;
      float _639 = (_635 * fOptimizedParam.z) * (_636 + fOptimizedParam.x);
      float _643 = fOptimizedParam.w * 0.5f;
      float _645 = (_643 * _631) * _639;
      float _648 = ((_643 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_636 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _639;
      float _649 = _645 + 0.5f;
      float _650 = _648 + 0.5f;
      do {
        if (!_620) {
          bool _658 = ((fHazeFilterAttribute & 2) == 0);
          float _661 = tFilterTempMap1.Sample(BilinearWrap, float2(_649, _650));
          do {
            if (!_658) {
              float _666 = ReadonlyDepth.SampleLevel(PointClamp, float2(_649, _650), 0.0f);
              float _674 = (((screenSize.x * 2.0f) * _649) * screenInverseSize.x) + -1.0f;
              float _675 = 1.0f - (((screenSize.y * 2.0f) * _650) * screenInverseSize.y);
              float _712 = 1.0f / (mad(_666.x, (viewProjInvMat[2].w), mad(_675, (viewProjInvMat[1].w), (_674 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _714 = _712 * (mad(_666.x, (viewProjInvMat[2].y), mad(_675, (viewProjInvMat[1].y), (_674 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _722 = (_712 * (mad(_666.x, (viewProjInvMat[2].x), mad(_675, (viewProjInvMat[1].x), (_674 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _723 = _714 - (transposeViewInvMat[1].w);
              float _724 = (_712 * (mad(_666.x, (viewProjInvMat[2].z), mad(_675, (viewProjInvMat[1].z), (_674 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _749 = saturate(_661.x * max(((sqrt(((_723 * _723) + (_722 * _722)) + (_724 * _724)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_714 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _750 = _666.x;
            } else {
              _749 = select(((fHazeFilterAttribute & 1) == 0), _661.x, (1.0f - _661.x));
              _750 = 0.0f;
            }
            float _755 = -0.0f - _650;
            float _778 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_755, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _649)));
            float _779 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_755, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _649)));
            float _780 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_755, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _649)));
            float _786 = tVolumeMap.Sample(BilinearWrap, float3((_778 + fHazeFilterUVWOffset.x), (_779 + fHazeFilterUVWOffset.y), (_780 + fHazeFilterUVWOffset.z)));
            float _789 = _778 * 2.0f;
            float _790 = _779 * 2.0f;
            float _791 = _780 * 2.0f;
            float _795 = tVolumeMap.Sample(BilinearWrap, float3((_789 + fHazeFilterUVWOffset.x), (_790 + fHazeFilterUVWOffset.y), (_791 + fHazeFilterUVWOffset.z)));
            float _799 = _778 * 4.0f;
            float _800 = _779 * 4.0f;
            float _801 = _780 * 4.0f;
            float _805 = tVolumeMap.Sample(BilinearWrap, float3((_799 + fHazeFilterUVWOffset.x), (_800 + fHazeFilterUVWOffset.y), (_801 + fHazeFilterUVWOffset.z)));
            float _809 = _778 * 8.0f;
            float _810 = _779 * 8.0f;
            float _811 = _780 * 8.0f;
            float _815 = tVolumeMap.Sample(BilinearWrap, float3((_809 + fHazeFilterUVWOffset.x), (_810 + fHazeFilterUVWOffset.y), (_811 + fHazeFilterUVWOffset.z)));
            float _819 = fHazeFilterUVWOffset.x + 0.5f;
            float _820 = fHazeFilterUVWOffset.y + 0.5f;
            float _821 = fHazeFilterUVWOffset.z + 0.5f;
            float _825 = tVolumeMap.Sample(BilinearWrap, float3((_778 + _819), (_779 + _820), (_780 + _821)));
            float _831 = tVolumeMap.Sample(BilinearWrap, float3((_789 + _819), (_790 + _820), (_791 + _821)));
            float _838 = tVolumeMap.Sample(BilinearWrap, float3((_799 + _819), (_800 + _820), (_801 + _821)));
            float _845 = tVolumeMap.Sample(BilinearWrap, float3((_809 + _819), (_810 + _820), (_811 + _821)));
            float _856 = (((((((_795.x * 0.25f) + (_786.x * 0.5f)) + (_805.x * 0.125f)) + (_815.x * 0.0625f)) * 2.0f) + -1.0f) * _749) * fHazeFilterScale;
            float _858 = (fHazeFilterScale * _749) * ((((((_831.x * 0.25f) + (_825.x * 0.5f)) + (_838.x * 0.125f)) + (_845.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _870 = 0.5f / fHazeFilterBorder;
                float _877 = saturate(max(((_870 * min(max((abs(_645) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_870 * min(max((abs(_648) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _883 = (_856 - (_877 * _856));
                _884 = (_858 - (_877 * _858));
              } else {
                _883 = _856;
                _884 = _858;
              }
              do {
                if (!_658) {
                  float _889 = ReadonlyDepth.Sample(BilinearWrap, float2((_883 + _649), (_884 + _650)));
                  if (!(!((_889.x - _750) >= fHazeFilterDepthDiffBias))) {
                    _896 = 0.0f;
                    _897 = 0.0f;
                  } else {
                    _896 = _883;
                    _897 = _884;
                  }
                } else {
                  _896 = _883;
                  _897 = _884;
                }
                _901 = (_896 + _649);
                _902 = (_897 + _650);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _901 = _649;
          _902 = _650;
        }
        float4 _905 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_901, _902));
        float _909 = _905.x * Exposure;
        float _910 = _905.y * Exposure;
        float _911 = _905.z * Exposure;
        if (isfinite(max(max(_909, _910), _911))) {
          float _920 = invLinearBegin * _909;
          float _926 = invLinearBegin * _910;
          float _932 = invLinearBegin * _911;
          float _939 = select((_909 >= linearBegin), 0.0f, (1.0f - ((_920 * _920) * (3.0f - (_920 * 2.0f)))));
          float _941 = select((_910 >= linearBegin), 0.0f, (1.0f - ((_926 * _926) * (3.0f - (_926 * 2.0f)))));
          float _943 = select((_911 >= linearBegin), 0.0f, (1.0f - ((_932 * _932) * (3.0f - (_932 * 2.0f)))));
          float _949 = select((_909 < linearStart), 0.0f, 1.0f);
          float _950 = select((_910 < linearStart), 0.0f, 1.0f);
          float _951 = select((_911 < linearStart), 0.0f, 1.0f);
          _1385 = (((((contrast * _909) + madLinearStartContrastFactor) * ((1.0f - _949) - _939)) + (((pow(_920, toe))*_939) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _909) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _949));
          _1386 = (((((contrast * _910) + madLinearStartContrastFactor) * ((1.0f - _950) - _941)) + (((pow(_926, toe))*_941) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _910) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _950));
          _1387 = (((((contrast * _911) + madLinearStartContrastFactor) * ((1.0f - _951) - _943)) + (((pow(_932, toe))*_943) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _911) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _951));
          _1388 = 0.0f;
          _1389 = fOptimizedParam.x;
          _1390 = fOptimizedParam.y;
          _1391 = fOptimizedParam.z;
          _1392 = fOptimizedParam.w;
          _1393 = 1.0f;
        } else {
          _1385 = 1.0f;
          _1386 = 1.0f;
          _1387 = 1.0f;
          _1388 = 0.0f;
          _1389 = fOptimizedParam.x;
          _1390 = fOptimizedParam.y;
          _1391 = fOptimizedParam.z;
          _1392 = fOptimizedParam.w;
          _1393 = 1.0f;
        }
      } while (false);
    } else {
      float _1014 = screenInverseSize.x * SV_Position.x;
      float _1015 = screenInverseSize.y * SV_Position.y;
      do {
        if (_620) {
          float4 _1019 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_1014, _1015));
          _1277 = _1019.x;
          _1278 = _1019.y;
          _1279 = _1019.z;
        } else {
          bool _1028 = ((fHazeFilterAttribute & 2) == 0);
          float _1031 = tFilterTempMap1.Sample(BilinearWrap, float2(_1014, _1015));
          do {
            if (!_1028) {
              float _1036 = ReadonlyDepth.SampleLevel(PointClamp, float2(_1014, _1015), 0.0f);
              float _1042 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
              float _1043 = 1.0f - ((SV_Position.y * 2.0f) * screenInverseSize.y);
              float _1080 = 1.0f / (mad(_1036.x, (viewProjInvMat[2].w), mad(_1043, (viewProjInvMat[1].w), (_1042 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _1082 = _1080 * (mad(_1036.x, (viewProjInvMat[2].y), mad(_1043, (viewProjInvMat[1].y), (_1042 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _1090 = (_1080 * (mad(_1036.x, (viewProjInvMat[2].x), mad(_1043, (viewProjInvMat[1].x), (_1042 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _1091 = _1082 - (transposeViewInvMat[1].w);
              float _1092 = (_1080 * (mad(_1036.x, (viewProjInvMat[2].z), mad(_1043, (viewProjInvMat[1].z), (_1042 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _1117 = saturate(_1031.x * max(((sqrt(((_1091 * _1091) + (_1090 * _1090)) + (_1092 * _1092)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_1082 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _1118 = _1036.x;
            } else {
              _1117 = select(((fHazeFilterAttribute & 1) == 0), _1031.x, (1.0f - _1031.x));
              _1118 = 0.0f;
            }
            float _1123 = -0.0f - _1015;
            float _1146 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_1123, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _1014)));
            float _1147 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_1123, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _1014)));
            float _1148 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_1123, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _1014)));
            float _1154 = tVolumeMap.Sample(BilinearWrap, float3((_1146 + fHazeFilterUVWOffset.x), (_1147 + fHazeFilterUVWOffset.y), (_1148 + fHazeFilterUVWOffset.z)));
            float _1157 = _1146 * 2.0f;
            float _1158 = _1147 * 2.0f;
            float _1159 = _1148 * 2.0f;
            float _1163 = tVolumeMap.Sample(BilinearWrap, float3((_1157 + fHazeFilterUVWOffset.x), (_1158 + fHazeFilterUVWOffset.y), (_1159 + fHazeFilterUVWOffset.z)));
            float _1167 = _1146 * 4.0f;
            float _1168 = _1147 * 4.0f;
            float _1169 = _1148 * 4.0f;
            float _1173 = tVolumeMap.Sample(BilinearWrap, float3((_1167 + fHazeFilterUVWOffset.x), (_1168 + fHazeFilterUVWOffset.y), (_1169 + fHazeFilterUVWOffset.z)));
            float _1177 = _1146 * 8.0f;
            float _1178 = _1147 * 8.0f;
            float _1179 = _1148 * 8.0f;
            float _1183 = tVolumeMap.Sample(BilinearWrap, float3((_1177 + fHazeFilterUVWOffset.x), (_1178 + fHazeFilterUVWOffset.y), (_1179 + fHazeFilterUVWOffset.z)));
            float _1187 = fHazeFilterUVWOffset.x + 0.5f;
            float _1188 = fHazeFilterUVWOffset.y + 0.5f;
            float _1189 = fHazeFilterUVWOffset.z + 0.5f;
            float _1193 = tVolumeMap.Sample(BilinearWrap, float3((_1146 + _1187), (_1147 + _1188), (_1148 + _1189)));
            float _1199 = tVolumeMap.Sample(BilinearWrap, float3((_1157 + _1187), (_1158 + _1188), (_1159 + _1189)));
            float _1206 = tVolumeMap.Sample(BilinearWrap, float3((_1167 + _1187), (_1168 + _1188), (_1169 + _1189)));
            float _1213 = tVolumeMap.Sample(BilinearWrap, float3((_1177 + _1187), (_1178 + _1188), (_1179 + _1189)));
            float _1224 = (((((((_1163.x * 0.25f) + (_1154.x * 0.5f)) + (_1173.x * 0.125f)) + (_1183.x * 0.0625f)) * 2.0f) + -1.0f) * _1117) * fHazeFilterScale;
            float _1226 = (fHazeFilterScale * _1117) * ((((((_1199.x * 0.25f) + (_1193.x * 0.5f)) + (_1206.x * 0.125f)) + (_1213.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _1240 = 0.5f / fHazeFilterBorder;
                float _1247 = saturate(max(((_1240 * min(max((abs(_1014 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_1240 * min(max((abs(_1015 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _1253 = (_1224 - (_1247 * _1224));
                _1254 = (_1226 - (_1247 * _1226));
              } else {
                _1253 = _1224;
                _1254 = _1226;
              }
              do {
                if (!_1028) {
                  float _1259 = ReadonlyDepth.Sample(BilinearWrap, float2((_1253 + _1014), (_1254 + _1015)));
                  if (!(!((_1259.x - _1118) >= fHazeFilterDepthDiffBias))) {
                    _1266 = 0.0f;
                    _1267 = 0.0f;
                  } else {
                    _1266 = _1253;
                    _1267 = _1254;
                  }
                } else {
                  _1266 = _1253;
                  _1267 = _1254;
                }
                float4 _1272 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1266 + _1014), (_1267 + _1015)));
                _1277 = _1272.x;
                _1278 = _1272.y;
                _1279 = _1272.z;
              } while (false);
            } while (false);
          } while (false);
        }
        float _1280 = _1277 * Exposure;
        float _1281 = _1278 * Exposure;
        float _1282 = _1279 * Exposure;
        if (isfinite(max(max(_1280, _1281), _1282))) {
          float _1291 = invLinearBegin * _1280;
          float _1297 = invLinearBegin * _1281;
          float _1303 = invLinearBegin * _1282;
          float _1310 = select((_1280 >= linearBegin), 0.0f, (1.0f - ((_1291 * _1291) * (3.0f - (_1291 * 2.0f)))));
          float _1312 = select((_1281 >= linearBegin), 0.0f, (1.0f - ((_1297 * _1297) * (3.0f - (_1297 * 2.0f)))));
          float _1314 = select((_1282 >= linearBegin), 0.0f, (1.0f - ((_1303 * _1303) * (3.0f - (_1303 * 2.0f)))));
          float _1320 = select((_1280 < linearStart), 0.0f, 1.0f);
          float _1321 = select((_1281 < linearStart), 0.0f, 1.0f);
          float _1322 = select((_1282 < linearStart), 0.0f, 1.0f);
          _1385 = (((((contrast * _1280) + madLinearStartContrastFactor) * ((1.0f - _1320) - _1310)) + (((pow(_1291, toe))*_1310) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1280) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1320));
          _1386 = (((((contrast * _1281) + madLinearStartContrastFactor) * ((1.0f - _1321) - _1312)) + (((pow(_1297, toe))*_1312) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1281) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1321));
          _1387 = (((((contrast * _1282) + madLinearStartContrastFactor) * ((1.0f - _1322) - _1314)) + (((pow(_1303, toe))*_1314) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1282) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1322));
          _1388 = 0.0f;
          _1389 = 0.0f;
          _1390 = 0.0f;
          _1391 = 0.0f;
          _1392 = 0.0f;
          _1393 = 1.0f;
        } else {
          _1385 = 1.0f;
          _1386 = 1.0f;
          _1387 = 1.0f;
          _1388 = 0.0f;
          _1389 = 0.0f;
          _1390 = 0.0f;
          _1391 = 0.0f;
          _1392 = 0.0f;
          _1393 = 1.0f;
        }
      } while (false);
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _1415 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1419 = ComputeResultSRV[0].computeAlpha;
    float _1422 = ((1.0f - _1415) + (_1419 * _1415)) * cbRadialColor.w;
    if (!(_1422 == 0.0f)) {
      float _1429 = screenInverseSize.x * SV_Position.x;
      float _1430 = screenInverseSize.y * SV_Position.y;
      float _1432 = (-0.5f - cbRadialScreenPos.x) + _1429;
      float _1434 = (-0.5f - cbRadialScreenPos.y) + _1430;
      float _1437 = select((_1432 < 0.0f), (1.0f - _1429), _1429);
      float _1440 = select((_1434 < 0.0f), (1.0f - _1430), _1430);
      float _1445 = rsqrt(dot(float2(_1432, _1434), float2(_1432, _1434))) * cbRadialSharpRange;
      uint _1452 = uint(abs(_1445 * _1434)) + uint(abs(_1445 * _1432));
      uint _1456 = ((_1452 ^ 61) ^ ((uint)(_1452) >> 16)) * 9;
      uint _1459 = (((uint)(_1456) >> 4) ^ _1456) * 668265261;
      float _1464 = select(((cbRadialBlurFlags & 1) != 0), (float((uint)((int)(((uint)(_1459) >> 15) ^ _1459))) * 2.3283064365386963e-10f), 1.0f);
      float _1470 = 1.0f / max(1.0f, sqrt((_1432 * _1432) + (_1434 * _1434)));
      float _1471 = cbRadialBlurPower * -0.0011111111380159855f;
      float _1480 = ((((_1471 * _1437) * _1464) * _1470) + 1.0f) * _1432;
      float _1481 = ((((_1471 * _1440) * _1464) * _1470) + 1.0f) * _1434;
      float _1483 = cbRadialBlurPower * -0.002222222276031971f;
      float _1492 = ((((_1483 * _1437) * _1464) * _1470) + 1.0f) * _1432;
      float _1493 = ((((_1483 * _1440) * _1464) * _1470) + 1.0f) * _1434;
      float _1494 = cbRadialBlurPower * -0.0033333334140479565f;
      float _1503 = ((((_1494 * _1437) * _1464) * _1470) + 1.0f) * _1432;
      float _1504 = ((((_1494 * _1440) * _1464) * _1470) + 1.0f) * _1434;
      float _1505 = cbRadialBlurPower * -0.004444444552063942f;
      float _1514 = ((((_1505 * _1437) * _1464) * _1470) + 1.0f) * _1432;
      float _1515 = ((((_1505 * _1440) * _1464) * _1470) + 1.0f) * _1434;
      float _1516 = cbRadialBlurPower * -0.0055555556900799274f;
      float _1525 = ((((_1516 * _1437) * _1464) * _1470) + 1.0f) * _1432;
      float _1526 = ((((_1516 * _1440) * _1464) * _1470) + 1.0f) * _1434;
      float _1527 = cbRadialBlurPower * -0.006666666828095913f;
      float _1536 = ((((_1527 * _1437) * _1464) * _1470) + 1.0f) * _1432;
      float _1537 = ((((_1527 * _1440) * _1464) * _1470) + 1.0f) * _1434;
      float _1538 = cbRadialBlurPower * -0.007777777966111898f;
      float _1547 = ((((_1538 * _1437) * _1464) * _1470) + 1.0f) * _1432;
      float _1548 = ((((_1538 * _1440) * _1464) * _1470) + 1.0f) * _1434;
      float _1549 = cbRadialBlurPower * -0.008888889104127884f;
      float _1558 = ((((_1549 * _1437) * _1464) * _1470) + 1.0f) * _1432;
      float _1559 = ((((_1549 * _1440) * _1464) * _1470) + 1.0f) * _1434;
      float _1560 = cbRadialBlurPower * -0.009999999776482582f;
      float _1569 = ((((_1560 * _1437) * _1464) * _1470) + 1.0f) * _1432;
      float _1570 = ((((_1560 * _1440) * _1464) * _1470) + 1.0f) * _1434;
      float _1571 = Exposure * 0.10000000149011612f;
      float _1572 = _1571 * cbRadialColor.x;
      float _1573 = _1571 * cbRadialColor.y;
      float _1574 = _1571 * cbRadialColor.z;
      do {
        if (_48) {
          float _1576 = _1480 + cbRadialScreenPos.x;
          float _1577 = _1481 + cbRadialScreenPos.y;
          float _1581 = ((dot(float2(_1576, _1577), float2(_1576, _1577)) * _1388) + 1.0f) * _1393;
          float4 _1587 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1581 * _1576) + 0.5f), ((_1581 * _1577) + 0.5f)), 0.0f);
          float _1591 = _1492 + cbRadialScreenPos.x;
          float _1592 = _1493 + cbRadialScreenPos.y;
          float _1595 = (dot(float2(_1591, _1592), float2(_1591, _1592)) * _1388) + 1.0f;
          float4 _1602 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1591 * _1393) * _1595) + 0.5f), (((_1592 * _1393) * _1595) + 0.5f)), 0.0f);
          float _1609 = _1503 + cbRadialScreenPos.x;
          float _1610 = _1504 + cbRadialScreenPos.y;
          float _1613 = (dot(float2(_1609, _1610), float2(_1609, _1610)) * _1388) + 1.0f;
          float4 _1620 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1609 * _1393) * _1613) + 0.5f), (((_1610 * _1393) * _1613) + 0.5f)), 0.0f);
          float _1627 = _1514 + cbRadialScreenPos.x;
          float _1628 = _1515 + cbRadialScreenPos.y;
          float _1631 = (dot(float2(_1627, _1628), float2(_1627, _1628)) * _1388) + 1.0f;
          float4 _1638 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1627 * _1393) * _1631) + 0.5f), (((_1628 * _1393) * _1631) + 0.5f)), 0.0f);
          float _1645 = _1525 + cbRadialScreenPos.x;
          float _1646 = _1526 + cbRadialScreenPos.y;
          float _1649 = (dot(float2(_1645, _1646), float2(_1645, _1646)) * _1388) + 1.0f;
          float4 _1656 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1645 * _1393) * _1649) + 0.5f), (((_1646 * _1393) * _1649) + 0.5f)), 0.0f);
          float _1663 = _1536 + cbRadialScreenPos.x;
          float _1664 = _1537 + cbRadialScreenPos.y;
          float _1667 = (dot(float2(_1663, _1664), float2(_1663, _1664)) * _1388) + 1.0f;
          float4 _1674 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1663 * _1393) * _1667) + 0.5f), (((_1664 * _1393) * _1667) + 0.5f)), 0.0f);
          float _1681 = _1547 + cbRadialScreenPos.x;
          float _1682 = _1548 + cbRadialScreenPos.y;
          float _1685 = (dot(float2(_1681, _1682), float2(_1681, _1682)) * _1388) + 1.0f;
          float4 _1692 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1681 * _1393) * _1685) + 0.5f), (((_1682 * _1393) * _1685) + 0.5f)), 0.0f);
          float _1699 = _1558 + cbRadialScreenPos.x;
          float _1700 = _1559 + cbRadialScreenPos.y;
          float _1703 = (dot(float2(_1699, _1700), float2(_1699, _1700)) * _1388) + 1.0f;
          float4 _1710 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1699 * _1393) * _1703) + 0.5f), (((_1700 * _1393) * _1703) + 0.5f)), 0.0f);
          float _1717 = _1569 + cbRadialScreenPos.x;
          float _1718 = _1570 + cbRadialScreenPos.y;
          float _1721 = (dot(float2(_1717, _1718), float2(_1717, _1718)) * _1388) + 1.0f;
          float4 _1728 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1717 * _1393) * _1721) + 0.5f), (((_1718 * _1393) * _1721) + 0.5f)), 0.0f);
          float _1735 = _1572 * ((((((((_1602.x + _1587.x) + _1620.x) + _1638.x) + _1656.x) + _1674.x) + _1692.x) + _1710.x) + _1728.x);
          float _1736 = _1573 * ((((((((_1602.y + _1587.y) + _1620.y) + _1638.y) + _1656.y) + _1674.y) + _1692.y) + _1710.y) + _1728.y);
          float _1737 = _1574 * ((((((((_1602.z + _1587.z) + _1620.z) + _1638.z) + _1656.z) + _1674.z) + _1692.z) + _1710.z) + _1728.z);
          do {
            if (isfinite(max(max(_1735, _1736), _1737))) {
              float _1746 = invLinearBegin * _1735;
              float _1752 = invLinearBegin * _1736;
              float _1758 = invLinearBegin * _1737;
              float _1765 = select((_1735 >= linearBegin), 0.0f, (1.0f - ((_1746 * _1746) * (3.0f - (_1746 * 2.0f)))));
              float _1767 = select((_1736 >= linearBegin), 0.0f, (1.0f - ((_1752 * _1752) * (3.0f - (_1752 * 2.0f)))));
              float _1769 = select((_1737 >= linearBegin), 0.0f, (1.0f - ((_1758 * _1758) * (3.0f - (_1758 * 2.0f)))));
              float _1775 = select((_1735 < linearStart), 0.0f, 1.0f);
              float _1776 = select((_1736 < linearStart), 0.0f, 1.0f);
              float _1777 = select((_1737 < linearStart), 0.0f, 1.0f);
              _1840 = (((((contrast * _1735) + madLinearStartContrastFactor) * ((1.0f - _1775) - _1765)) + (((pow(_1746, toe))*_1765) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1735) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1775));
              _1841 = (((((contrast * _1736) + madLinearStartContrastFactor) * ((1.0f - _1776) - _1767)) + (((pow(_1752, toe))*_1767) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1736) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1776));
              _1842 = (((((contrast * _1737) + madLinearStartContrastFactor) * ((1.0f - _1777) - _1769)) + (((pow(_1758, toe))*_1769) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1737) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1777));
            } else {
              _1840 = 1.0f;
              _1841 = 1.0f;
              _1842 = 1.0f;
            }
            _2422 = (_1840 + ((_1385 * 0.10000000149011612f) * cbRadialColor.x));
            _2423 = (_1841 + ((_1386 * 0.10000000149011612f) * cbRadialColor.y));
            _2424 = (_1842 + ((_1387 * 0.10000000149011612f) * cbRadialColor.z));
          } while (false);
        } else {
          float _1853 = cbRadialScreenPos.x + 0.5f;
          float _1854 = _1853 + _1480;
          float _1855 = cbRadialScreenPos.y + 0.5f;
          float _1856 = _1855 + _1481;
          float _1857 = _1853 + _1492;
          float _1858 = _1855 + _1493;
          float _1859 = _1853 + _1503;
          float _1860 = _1855 + _1504;
          float _1861 = _1853 + _1514;
          float _1862 = _1855 + _1515;
          float _1863 = _1853 + _1525;
          float _1864 = _1855 + _1526;
          float _1865 = _1853 + _1536;
          float _1866 = _1855 + _1537;
          float _1867 = _1853 + _1547;
          float _1868 = _1855 + _1548;
          float _1869 = _1853 + _1558;
          float _1870 = _1855 + _1559;
          float _1871 = _1853 + _1569;
          float _1872 = _1855 + _1570;
          if (_50) {
            float _1876 = (_1854 * 2.0f) + -1.0f;
            float _1880 = sqrt((_1876 * _1876) + 1.0f);
            float _1881 = 1.0f / _1880;
            float _1884 = (_1880 * _1391) * (_1881 + _1389);
            float _1888 = _1392 * 0.5f;
            float4 _1897 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1888 * _1884) * _1876) + 0.5f), ((((_1888 * (((_1881 + -1.0f) * _1390) + 1.0f)) * _1884) * ((_1856 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _1903 = (_1857 * 2.0f) + -1.0f;
            float _1907 = sqrt((_1903 * _1903) + 1.0f);
            float _1908 = 1.0f / _1907;
            float _1911 = (_1907 * _1391) * (_1908 + _1389);
            float4 _1922 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1888 * _1903) * _1911) + 0.5f), ((((_1888 * ((_1858 * 2.0f) + -1.0f)) * (((_1908 + -1.0f) * _1390) + 1.0f)) * _1911) + 0.5f)), 0.0f);
            float _1931 = (_1859 * 2.0f) + -1.0f;
            float _1935 = sqrt((_1931 * _1931) + 1.0f);
            float _1936 = 1.0f / _1935;
            float _1939 = (_1935 * _1391) * (_1936 + _1389);
            float4 _1950 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1888 * _1931) * _1939) + 0.5f), ((((_1888 * ((_1860 * 2.0f) + -1.0f)) * (((_1936 + -1.0f) * _1390) + 1.0f)) * _1939) + 0.5f)), 0.0f);
            float _1959 = (_1861 * 2.0f) + -1.0f;
            float _1963 = sqrt((_1959 * _1959) + 1.0f);
            float _1964 = 1.0f / _1963;
            float _1967 = (_1963 * _1391) * (_1964 + _1389);
            float4 _1978 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1888 * _1959) * _1967) + 0.5f), ((((_1888 * ((_1862 * 2.0f) + -1.0f)) * (((_1964 + -1.0f) * _1390) + 1.0f)) * _1967) + 0.5f)), 0.0f);
            float _1987 = (_1863 * 2.0f) + -1.0f;
            float _1991 = sqrt((_1987 * _1987) + 1.0f);
            float _1992 = 1.0f / _1991;
            float _1995 = (_1991 * _1391) * (_1992 + _1389);
            float4 _2006 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1888 * _1987) * _1995) + 0.5f), ((((_1888 * ((_1864 * 2.0f) + -1.0f)) * (((_1992 + -1.0f) * _1390) + 1.0f)) * _1995) + 0.5f)), 0.0f);
            float _2015 = (_1865 * 2.0f) + -1.0f;
            float _2019 = sqrt((_2015 * _2015) + 1.0f);
            float _2020 = 1.0f / _2019;
            float _2023 = (_2019 * _1391) * (_2020 + _1389);
            float4 _2034 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1888 * _2015) * _2023) + 0.5f), ((((_1888 * ((_1866 * 2.0f) + -1.0f)) * (((_2020 + -1.0f) * _1390) + 1.0f)) * _2023) + 0.5f)), 0.0f);
            float _2043 = (_1867 * 2.0f) + -1.0f;
            float _2047 = sqrt((_2043 * _2043) + 1.0f);
            float _2048 = 1.0f / _2047;
            float _2051 = (_2047 * _1391) * (_2048 + _1389);
            float4 _2062 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1888 * _2043) * _2051) + 0.5f), ((((_1888 * ((_1868 * 2.0f) + -1.0f)) * (((_2048 + -1.0f) * _1390) + 1.0f)) * _2051) + 0.5f)), 0.0f);
            float _2071 = (_1869 * 2.0f) + -1.0f;
            float _2075 = sqrt((_2071 * _2071) + 1.0f);
            float _2076 = 1.0f / _2075;
            float _2079 = (_2075 * _1391) * (_2076 + _1389);
            float4 _2090 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1888 * _2071) * _2079) + 0.5f), ((((_1888 * ((_1870 * 2.0f) + -1.0f)) * (((_2076 + -1.0f) * _1390) + 1.0f)) * _2079) + 0.5f)), 0.0f);
            float _2099 = (_1871 * 2.0f) + -1.0f;
            float _2103 = sqrt((_2099 * _2099) + 1.0f);
            float _2104 = 1.0f / _2103;
            float _2107 = (_2103 * _1391) * (_2104 + _1389);
            float4 _2118 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1888 * _2099) * _2107) + 0.5f), ((((_1888 * ((_1872 * 2.0f) + -1.0f)) * (((_2104 + -1.0f) * _1390) + 1.0f)) * _2107) + 0.5f)), 0.0f);
            float _2125 = _1572 * ((((((((_1922.x + _1897.x) + _1950.x) + _1978.x) + _2006.x) + _2034.x) + _2062.x) + _2090.x) + _2118.x);
            float _2126 = _1573 * ((((((((_1922.y + _1897.y) + _1950.y) + _1978.y) + _2006.y) + _2034.y) + _2062.y) + _2090.y) + _2118.y);
            float _2127 = _1574 * ((((((((_1922.z + _1897.z) + _1950.z) + _1978.z) + _2006.z) + _2034.z) + _2062.z) + _2090.z) + _2118.z);
            do {
              if (isfinite(max(max(_2125, _2126), _2127))) {
                float _2136 = invLinearBegin * _2125;
                float _2142 = invLinearBegin * _2126;
                float _2148 = invLinearBegin * _2127;
                float _2155 = select((_2125 >= linearBegin), 0.0f, (1.0f - ((_2136 * _2136) * (3.0f - (_2136 * 2.0f)))));
                float _2157 = select((_2126 >= linearBegin), 0.0f, (1.0f - ((_2142 * _2142) * (3.0f - (_2142 * 2.0f)))));
                float _2159 = select((_2127 >= linearBegin), 0.0f, (1.0f - ((_2148 * _2148) * (3.0f - (_2148 * 2.0f)))));
                float _2165 = select((_2125 < linearStart), 0.0f, 1.0f);
                float _2166 = select((_2126 < linearStart), 0.0f, 1.0f);
                float _2167 = select((_2127 < linearStart), 0.0f, 1.0f);
                _2230 = (((((contrast * _2125) + madLinearStartContrastFactor) * ((1.0f - _2165) - _2155)) + (((pow(_2136, toe))*_2155) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2125) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2165));
                _2231 = (((((contrast * _2126) + madLinearStartContrastFactor) * ((1.0f - _2166) - _2157)) + (((pow(_2142, toe))*_2157) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2126) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2166));
                _2232 = (((((contrast * _2127) + madLinearStartContrastFactor) * ((1.0f - _2167) - _2159)) + (((pow(_2148, toe))*_2159) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2127) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2167));
              } else {
                _2230 = 1.0f;
                _2231 = 1.0f;
                _2232 = 1.0f;
              }
              _2422 = (_2230 + ((_1385 * 0.10000000149011612f) * cbRadialColor.x));
              _2423 = (_2231 + ((_1386 * 0.10000000149011612f) * cbRadialColor.y));
              _2424 = (_2232 + ((_1387 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          } else {
            float4 _2244 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1854, _1856), 0.0f);
            float4 _2248 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1857, _1858), 0.0f);
            float4 _2255 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1859, _1860), 0.0f);
            float4 _2262 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1861, _1862), 0.0f);
            float4 _2269 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1863, _1864), 0.0f);
            float4 _2276 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1865, _1866), 0.0f);
            float4 _2283 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1867, _1868), 0.0f);
            float4 _2290 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1869, _1870), 0.0f);
            float4 _2297 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1871, _1872), 0.0f);
            float _2304 = _1572 * ((((((((_2248.x + _2244.x) + _2255.x) + _2262.x) + _2269.x) + _2276.x) + _2283.x) + _2290.x) + _2297.x);
            float _2305 = _1573 * ((((((((_2248.y + _2244.y) + _2255.y) + _2262.y) + _2269.y) + _2276.y) + _2283.y) + _2290.y) + _2297.y);
            float _2306 = _1574 * ((((((((_2248.z + _2244.z) + _2255.z) + _2262.z) + _2269.z) + _2276.z) + _2283.z) + _2290.z) + _2297.z);
            do {
              if (isfinite(max(max(_2304, _2305), _2306))) {
                float _2315 = invLinearBegin * _2304;
                float _2321 = invLinearBegin * _2305;
                float _2327 = invLinearBegin * _2306;
                float _2334 = select((_2304 >= linearBegin), 0.0f, (1.0f - ((_2315 * _2315) * (3.0f - (_2315 * 2.0f)))));
                float _2336 = select((_2305 >= linearBegin), 0.0f, (1.0f - ((_2321 * _2321) * (3.0f - (_2321 * 2.0f)))));
                float _2338 = select((_2306 >= linearBegin), 0.0f, (1.0f - ((_2327 * _2327) * (3.0f - (_2327 * 2.0f)))));
                float _2344 = select((_2304 < linearStart), 0.0f, 1.0f);
                float _2345 = select((_2305 < linearStart), 0.0f, 1.0f);
                float _2346 = select((_2306 < linearStart), 0.0f, 1.0f);
                _2409 = (((((contrast * _2304) + madLinearStartContrastFactor) * ((1.0f - _2344) - _2334)) + (((pow(_2315, toe))*_2334) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2304) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2344));
                _2410 = (((((contrast * _2305) + madLinearStartContrastFactor) * ((1.0f - _2345) - _2336)) + (((pow(_2321, toe))*_2336) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2305) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2345));
                _2411 = (((((contrast * _2306) + madLinearStartContrastFactor) * ((1.0f - _2346) - _2338)) + (((pow(_2327, toe))*_2338) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2306) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2346));
              } else {
                _2409 = 1.0f;
                _2410 = 1.0f;
                _2411 = 1.0f;
              }
              _2422 = (_2409 + ((_1385 * 0.10000000149011612f) * cbRadialColor.x));
              _2423 = (_2410 + ((_1386 * 0.10000000149011612f) * cbRadialColor.y));
              _2424 = (_2411 + ((_1387 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          }
        }
        do {
          if (cbRadialMaskRate.x > 0.0f) {
            float _2433 = saturate((sqrt((_1432 * _1432) + (_1434 * _1434)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
            float _2439 = (((_2433 * _2433) * cbRadialMaskRate.x) * (3.0f - (_2433 * 2.0f))) + cbRadialMaskRate.y;
            _2450 = ((_2439 * (_2422 - _1385)) + _1385);
            _2451 = ((_2439 * (_2423 - _1386)) + _1386);
            _2452 = ((_2439 * (_2424 - _1387)) + _1387);
          } else {
            _2450 = _2422;
            _2451 = _2423;
            _2452 = _2424;
          }
          _2463 = (lerp(_1385, _2450, _1422));
          _2464 = (lerp(_1386, _2451, _1422));
          _2465 = (lerp(_1387, _2452, _1422));
        } while (false);
      } while (false);
    } else {
      _2463 = _1385;
      _2464 = _1386;
      _2465 = _1387;
    }
  } else {
    _2463 = _1385;
    _2464 = _1386;
    _2465 = _1387;
  }
  if (!((cPassEnabled & 2) == 0) && (CUSTOM_NOISE != 0.f)) {
#if 1
    float3 noise_input = float3(_2463, _2464, _2465);
#endif
    float _2487 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
    float _2489 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
    float _2493 = frac(frac(dot(float2(_2487, _2489), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_2493 < fNoiseDensity) {
        int _2498 = (uint)(uint(_2489 * _2487)) ^ 12345391;
        uint _2499 = _2498 * 3635641;
        _2507 = (float((uint)((int)((((uint)(_2499) >> 26) | ((uint)(_2498 * 232681024))) ^ _2499))) * 2.3283064365386963e-10f);
      } else {
        _2507 = 0.0f;
      }
      float _2509 = frac(_2493 * 757.4846801757812f);
      do {
        if (_2509 < fNoiseDensity) {
          int _2513 = asint(_2509) ^ 12345391;
          uint _2514 = _2513 * 3635641;
          _2523 = ((float((uint)((int)((((uint)(_2514) >> 26) | ((uint)(_2513 * 232681024))) ^ _2514))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _2523 = 0.0f;
        }
        float _2525 = frac(_2509 * 757.4846801757812f);
        do {
          if (_2525 < fNoiseDensity) {
            int _2529 = asint(_2525) ^ 12345391;
            uint _2530 = _2529 * 3635641;
            _2539 = ((float((uint)((int)((((uint)(_2530) >> 26) | ((uint)(_2529 * 232681024))) ^ _2530))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _2539 = 0.0f;
          }
          float _2540 = _2507 * fNoisePower.x;
          float _2541 = _2539 * fNoisePower.y;
          float _2542 = _2523 * fNoisePower.y;
          float _2556 = exp2(log2(1.0f - saturate(dot(float3(saturate(_2463), saturate(_2464), saturate(_2465)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _2567 = ((_2556 * (mad(_2542, 1.4019999504089355f, _2540) - _2463)) + _2463);
          _2568 = ((_2556 * (mad(_2542, -0.7139999866485596f, mad(_2541, -0.3440000116825104f, _2540)) - _2464)) + _2464);
          _2569 = ((_2556 * (mad(_2541, 1.7719999551773071f, _2540) - _2465)) + _2465);
        } while (false);
      } while (false);
    } while (false);
#if 1
    _2567 = lerp(noise_input.r, _2567, CUSTOM_NOISE);
    _2568 = lerp(noise_input.g, _2568, CUSTOM_NOISE);
    _2569 = lerp(noise_input.b, _2569, CUSTOM_NOISE);
#endif
  } else {
    _2567 = _2463;
    _2568 = _2464;
    _2569 = _2465;
  }
#if 1
  ApplyColorGrading(_2567, _2568, _2569,
                    _2786, _2787, _2788);
#else
  if (!((cPassEnabled & 4) == 0)) {
    float _2594 = max(max(_2567, _2568), _2569);
    bool _2595 = (_2594 > 1.0f);
    do {
      if (_2595) {
        _2601 = (_2567 / _2594);
        _2602 = (_2568 / _2594);
        _2603 = (_2569 / _2594);
      } else {
        _2601 = _2567;
        _2602 = _2568;
        _2603 = _2569;
      }
      float _2604 = fTextureInverseSize * 0.5f;
      do {
        [branch]
        if (!(!(_2601 <= 0.0031308000907301903f))) {
          _2615 = (_2601 * 12.920000076293945f);
        } else {
          _2615 = (((pow(_2601, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          [branch]
          if (!(!(_2602 <= 0.0031308000907301903f))) {
            _2626 = (_2602 * 12.920000076293945f);
          } else {
            _2626 = (((pow(_2602, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            [branch]
            if (!(!(_2603 <= 0.0031308000907301903f))) {
              _2637 = (_2603 * 12.920000076293945f);
            } else {
              _2637 = (((pow(_2603, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            float _2638 = 1.0f - fTextureInverseSize;
            float _2642 = (_2615 * _2638) + _2604;
            float _2643 = (_2626 * _2638) + _2604;
            float _2644 = (_2637 * _2638) + _2604;
            float4 _2647 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2642, _2643, _2644), 0.0f);
            bool _2652 = (fTextureBlendRate2 > 0.0f);
            do {
              [branch]
              if (fTextureBlendRate > 0.0f) {
                float4 _2655 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2642, _2643, _2644), 0.0f);
                float _2665 = ((_2655.x - _2647.x) * fTextureBlendRate) + _2647.x;
                float _2666 = ((_2655.y - _2647.y) * fTextureBlendRate) + _2647.y;
                float _2667 = ((_2655.z - _2647.z) * fTextureBlendRate) + _2647.z;
                if (_2652) {
                  do {
                    [branch]
                    if (!(!(_2665 <= 0.0031308000907301903f))) {
                      _2679 = (_2665 * 12.920000076293945f);
                    } else {
                      _2679 = (((pow(_2665, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_2666 <= 0.0031308000907301903f))) {
                        _2690 = (_2666 * 12.920000076293945f);
                      } else {
                        _2690 = (((pow(_2666, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_2667 <= 0.0031308000907301903f))) {
                          _2701 = (_2667 * 12.920000076293945f);
                        } else {
                          _2701 = (((pow(_2667, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _2703 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2679, _2690, _2701), 0.0f);
                        _2766 = (lerp(_2665, _2703.x, fTextureBlendRate2));
                        _2767 = (lerp(_2666, _2703.y, fTextureBlendRate2));
                        _2768 = (lerp(_2667, _2703.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _2766 = _2665;
                  _2767 = _2666;
                  _2768 = _2667;
                }
              } else {
                if (_2652) {
                  do {
                    [branch]
                    if (!(!(_2647.x <= 0.0031308000907301903f))) {
                      _2728 = (_2647.x * 12.920000076293945f);
                    } else {
                      _2728 = (((pow(_2647.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_2647.y <= 0.0031308000907301903f))) {
                        _2739 = (_2647.y * 12.920000076293945f);
                      } else {
                        _2739 = (((pow(_2647.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_2647.z <= 0.0031308000907301903f))) {
                          _2750 = (_2647.z * 12.920000076293945f);
                        } else {
                          _2750 = (((pow(_2647.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _2752 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2728, _2739, _2750), 0.0f);
                        _2766 = (lerp(_2647.x, _2752.x, fTextureBlendRate2));
                        _2767 = (lerp(_2647.y, _2752.y, fTextureBlendRate2));
                        _2768 = (lerp(_2647.z, _2752.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _2766 = _2647.x;
                  _2767 = _2647.y;
                  _2768 = _2647.z;
                }
              }
              float _2772 = mad(_2768, (fColorMatrix[2].x), mad(_2767, (fColorMatrix[1].x), (_2766 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
              float _2776 = mad(_2768, (fColorMatrix[2].y), mad(_2767, (fColorMatrix[1].y), (_2766 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
              float _2780 = mad(_2768, (fColorMatrix[2].z), mad(_2767, (fColorMatrix[1].z), (_2766 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
              if (_2595) {
                _2786 = (_2772 * _2594);
                _2787 = (_2776 * _2594);
                _2788 = (_2780 * _2594);
              } else {
                _2786 = _2772;
                _2787 = _2776;
                _2788 = _2780;
              }
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2786 = _2567;
    _2787 = _2568;
    _2788 = _2569;
  }
#endif
  if (!((cPassEnabled & 8) == 0)) {
    _2823 = saturate(((cvdR.x * _2786) + (cvdR.y * _2787)) + (cvdR.z * _2788));
    _2824 = saturate(((cvdG.x * _2786) + (cvdG.y * _2787)) + (cvdG.z * _2788));
    _2825 = saturate(((cvdB.x * _2786) + (cvdB.y * _2787)) + (cvdB.z * _2788));
  } else {
    _2823 = _2786;
    _2824 = _2787;
    _2825 = _2788;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2840 = screenInverseSize.x * SV_Position.x;
    float _2841 = screenInverseSize.y * SV_Position.y;
    float4 _2844 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2840, _2841), 0.0f);
    float _2849 = _2844.x * ColorParam.x;
    float _2850 = _2844.y * ColorParam.y;
    float _2851 = _2844.z * ColorParam.z;
    float _2854 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2840, _2841), 0.0f);
    float _2859 = (_2844.w * ColorParam.w) * saturate((_2854.x * Levels_Rate) + Levels_Range);
    _2897 = (((select((_2849 < 0.5f), ((_2823 * 2.0f) * _2849), (1.0f - (((1.0f - _2823) * 2.0f) * (1.0f - _2849)))) - _2823) * _2859) + _2823);
    _2898 = (((select((_2850 < 0.5f), ((_2824 * 2.0f) * _2850), (1.0f - (((1.0f - _2824) * 2.0f) * (1.0f - _2850)))) - _2824) * _2859) + _2824);
    _2899 = (((select((_2851 < 0.5f), ((_2825 * 2.0f) * _2851), (1.0f - (((1.0f - _2825) * 2.0f) * (1.0f - _2851)))) - _2825) * _2859) + _2825);
  } else {
    _2897 = _2823;
    _2898 = _2824;
    _2899 = _2825;
  }
  SV_Target.x = _2897;
  SV_Target.y = _2898;
  SV_Target.z = _2899;
  SV_Target.w = 0.0f;

#if 1
    float2 grain_uv = SV_Position.xy * screenInverseSize;
    SV_Target.rgb = ApplyToneMap(SV_Target.rgb, grain_uv);
#endif

  return SV_Target;
}
