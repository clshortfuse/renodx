#define SHADER_HASH 0x2F362206
#include "../tonemap.hlsli"

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
  uint2 SceneInfo_Reserve : packoffset(c032.z);
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
  uint fHazeFilterReserved[3] : packoffset(c004.x);
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

cbuffer ColorCorrectTexture : register(b8) {
  float fTextureSize : packoffset(c000.x);
  float fTextureBlendRate : packoffset(c000.y);
  float fTextureBlendRate2 : packoffset(c000.z);
  float fTextureInverseSize : packoffset(c000.w);
  float4 fColorMatrix[4] : packoffset(c001.x);
};

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

cbuffer CBControl : register(b11) {
  uint cPassEnabled : packoffset(c000.x);
};

SamplerState PointClamp : register(s0);

SamplerState BilinearWrap : register(s1);

SamplerState BilinearClamp : register(s2);

SamplerState BilinearBorder : register(s3);

SamplerState TrilinearClamp : register(s4);

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
  float _693;
  float _694;
  float _824;
  float _825;
  float _836;
  float _837;
  float _841;
  float _842;
  float _1051;
  float _1052;
  float _1184;
  float _1185;
  float _1196;
  float _1197;
  float _1205;
  float _1206;
  float _1207;
  float _1309;
  float _1310;
  float _1311;
  float _1312;
  float _1313;
  float _1314;
  float _1315;
  float _1316;
  float _1317;
  float _2281;
  float _2282;
  float _2283;
  float _2309;
  float _2310;
  float _2311;
  float _2322;
  float _2323;
  float _2324;
  float _2368;
  float _2384;
  float _2400;
  float _2425;
  float _2426;
  float _2427;
  float _2459;
  float _2460;
  float _2461;
  float _2473;
  float _2484;
  float _2495;
  float _2534;
  float _2545;
  float _2556;
  float _2581;
  float _2592;
  float _2603;
  float _2618;
  float _2619;
  float _2620;
  float _2638;
  float _2639;
  float _2640;
  float _2675;
  float _2676;
  float _2677;
  float _2746;
  float _2747;
  float _2748;
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
        float _348 = invLinearBegin * _341;
        float _354 = invLinearBegin * _342;
        float _360 = invLinearBegin * _343;
        float _367 = select((_341 >= linearBegin), 0.0f, (1.0f - ((_348 * _348) * (3.0f - (_348 * 2.0f)))));
        float _369 = select((_342 >= linearBegin), 0.0f, (1.0f - ((_354 * _354) * (3.0f - (_354 * 2.0f)))));
        float _371 = select((_343 >= linearBegin), 0.0f, (1.0f - ((_360 * _360) * (3.0f - (_360 * 2.0f)))));
        float _377 = select((_341 < linearStart), 0.0f, 1.0f);
        float _378 = select((_342 < linearStart), 0.0f, 1.0f);
        float _379 = select((_343 < linearStart), 0.0f, 1.0f);
        _1309 = (((((contrast * _341) + madLinearStartContrastFactor) * ((1.0f - _377) - _367)) + (((pow(_348, toe))*_367) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _341) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _377));
        _1310 = (((((contrast * _342) + madLinearStartContrastFactor) * ((1.0f - _378) - _369)) + (((pow(_354, toe))*_369) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _342) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _378));
        _1311 = (((((contrast * _343) + madLinearStartContrastFactor) * ((1.0f - _379) - _371)) + (((pow(_360, toe))*_371) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _343) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _379));
        _1312 = fDistortionCoef;
        _1313 = 0.0f;
        _1314 = 0.0f;
        _1315 = 0.0f;
        _1316 = 0.0f;
        _1317 = fCorrectCoef;
      } while (false);
    } else {
      float _442 = _82 + fRefraction;
      float _444 = (_442 * fDistortionCoef) + 1.0f;
      float _445 = _80 * fCorrectCoef;
      float _447 = _81 * fCorrectCoef;
      float _453 = ((_442 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _458 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_88, _89));
      float _460 = _458.x * _67;
      float _465 = invLinearBegin * _460;
      float _472 = select((_460 >= linearBegin), 0.0f, (1.0f - ((_465 * _465) * (3.0f - (_465 * 2.0f)))));
      float _476 = select((_460 < linearStart), 0.0f, 1.0f);
      float4 _502 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_445 * _444) + 0.5f), ((_447 * _444) + 0.5f)));
      float _504 = _502.y * _67;
      float _505 = invLinearBegin * _504;
      float _512 = select((_504 >= linearBegin), 0.0f, (1.0f - ((_505 * _505) * (3.0f - (_505 * 2.0f)))));
      float _514 = select((_504 < linearStart), 0.0f, 1.0f);
      float4 _533 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_445 * _453) + 0.5f), ((_447 * _453) + 0.5f)));
      float _535 = _533.z * _67;
      float _536 = invLinearBegin * _535;
      float _543 = select((_535 >= linearBegin), 0.0f, (1.0f - ((_536 * _536) * (3.0f - (_536 * 2.0f)))));
      float _545 = select((_535 < linearStart), 0.0f, 1.0f);
      _1309 = (((((contrast * _460) + madLinearStartContrastFactor) * ((1.0f - _476) - _472)) + ((linearBegin * (pow(_465, toe))) * _472)) + ((maxNit - (exp2((contrastFactor * _460) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _476));
      _1310 = (((((contrast * _504) + madLinearStartContrastFactor) * ((1.0f - _514) - _512)) + ((linearBegin * (pow(_505, toe))) * _512)) + ((maxNit - (exp2((contrastFactor * _504) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _514));
      _1311 = (((((contrast * _535) + madLinearStartContrastFactor) * ((1.0f - _545) - _543)) + ((linearBegin * (pow(_536, toe))) * _543)) + ((maxNit - (exp2((contrastFactor * _535) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _545));
      _1312 = fDistortionCoef;
      _1313 = 0.0f;
      _1314 = 0.0f;
      _1315 = 0.0f;
      _1316 = 0.0f;
      _1317 = fCorrectCoef;
    }
  } else {
    if (_44) {
      float _578 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _582 = sqrt((_578 * _578) + 1.0f);
      float _583 = 1.0f / _582;
      float _586 = (_582 * fOptimizedParam.z) * (_583 + fOptimizedParam.x);
      float _590 = fOptimizedParam.w * 0.5f;
      float _592 = (_590 * _578) * _586;
      float _595 = ((_590 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_583 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _586;
      float _596 = _592 + 0.5f;
      float _597 = _595 + 0.5f;
      do {
        if (_46) {
          bool _604 = ((fHazeFilterAttribute & 2) != 0);
          float _607 = tFilterTempMap1.Sample(BilinearWrap, float2(_596, _597));
          do {
            if (_604) {
              float _610 = ReadonlyDepth.SampleLevel(PointClamp, float2(_596, _597), 0.0f);
              float _618 = (((screenSize.x * 2.0f) * _596) * screenInverseSize.x) + -1.0f;
              float _619 = 1.0f - (((screenSize.y * 2.0f) * _597) * screenInverseSize.y);
              float _656 = 1.0f / (mad(_610.x, (viewProjInvMat[2].w), mad(_619, (viewProjInvMat[1].w), (_618 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _658 = _656 * (mad(_610.x, (viewProjInvMat[2].y), mad(_619, (viewProjInvMat[1].y), (_618 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _666 = (_656 * (mad(_610.x, (viewProjInvMat[2].x), mad(_619, (viewProjInvMat[1].x), (_618 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _667 = _658 - (transposeViewInvMat[1].w);
              float _668 = (_656 * (mad(_610.x, (viewProjInvMat[2].z), mad(_619, (viewProjInvMat[1].z), (_618 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _693 = saturate(_607.x * max(((sqrt(((_667 * _667) + (_666 * _666)) + (_668 * _668)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_658 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _694 = _610.x;
            } else {
              _693 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _607.x), _607.x);
              _694 = 0.0f;
            }
            float _699 = -0.0f - _597;
            float _722 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_699, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _596)));
            float _723 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_699, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _596)));
            float _724 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_699, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _596)));
            float _728 = tVolumeMap.Sample(BilinearWrap, float3((_722 + fHazeFilterUVWOffset.x), (_723 + fHazeFilterUVWOffset.y), (_724 + fHazeFilterUVWOffset.z)));
            float _731 = _722 * 2.0f;
            float _732 = _723 * 2.0f;
            float _733 = _724 * 2.0f;
            float _737 = tVolumeMap.Sample(BilinearWrap, float3((_731 + fHazeFilterUVWOffset.x), (_732 + fHazeFilterUVWOffset.y), (_733 + fHazeFilterUVWOffset.z)));
            float _741 = _722 * 4.0f;
            float _742 = _723 * 4.0f;
            float _743 = _724 * 4.0f;
            float _747 = tVolumeMap.Sample(BilinearWrap, float3((_741 + fHazeFilterUVWOffset.x), (_742 + fHazeFilterUVWOffset.y), (_743 + fHazeFilterUVWOffset.z)));
            float _751 = _722 * 8.0f;
            float _752 = _723 * 8.0f;
            float _753 = _724 * 8.0f;
            float _757 = tVolumeMap.Sample(BilinearWrap, float3((_751 + fHazeFilterUVWOffset.x), (_752 + fHazeFilterUVWOffset.y), (_753 + fHazeFilterUVWOffset.z)));
            float _761 = fHazeFilterUVWOffset.x + 0.5f;
            float _762 = fHazeFilterUVWOffset.y + 0.5f;
            float _763 = fHazeFilterUVWOffset.z + 0.5f;
            float _767 = tVolumeMap.Sample(BilinearWrap, float3((_722 + _761), (_723 + _762), (_724 + _763)));
            float _773 = tVolumeMap.Sample(BilinearWrap, float3((_731 + _761), (_732 + _762), (_733 + _763)));
            float _780 = tVolumeMap.Sample(BilinearWrap, float3((_741 + _761), (_742 + _762), (_743 + _763)));
            float _787 = tVolumeMap.Sample(BilinearWrap, float3((_751 + _761), (_752 + _762), (_753 + _763)));
            float _798 = (((((((_737.x * 0.25f) + (_728.x * 0.5f)) + (_747.x * 0.125f)) + (_757.x * 0.0625f)) * 2.0f) + -1.0f) * _693) * fHazeFilterScale;
            float _800 = (fHazeFilterScale * _693) * ((((((_773.x * 0.25f) + (_767.x * 0.5f)) + (_780.x * 0.125f)) + (_787.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _811 = 0.5f / fHazeFilterBorder;
                float _818 = saturate(max(((_811 * min(max((abs(_592) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_811 * min(max((abs(_595) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _824 = (_798 - (_818 * _798));
                _825 = (_800 - (_818 * _800));
              } else {
                _824 = _798;
                _825 = _800;
              }
              do {
                if (_604) {
                  float _829 = ReadonlyDepth.Sample(BilinearWrap, float2((_824 + _596), (_825 + _597)));
                  if (!(!((_829.x - _694) >= fHazeFilterDepthDiffBias))) {
                    _836 = 0.0f;
                    _837 = 0.0f;
                  } else {
                    _836 = _824;
                    _837 = _825;
                  }
                } else {
                  _836 = _824;
                  _837 = _825;
                }
                _841 = (_836 + _596);
                _842 = (_837 + _597);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _841 = _596;
          _842 = _597;
        }
        float4 _843 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_841, _842));
        float _847 = _843.x * _67;
        float _848 = _843.y * _67;
        float _849 = _843.z * _67;
        float _854 = invLinearBegin * _847;
        float _860 = invLinearBegin * _848;
        float _866 = invLinearBegin * _849;
        float _873 = select((_847 >= linearBegin), 0.0f, (1.0f - ((_854 * _854) * (3.0f - (_854 * 2.0f)))));
        float _875 = select((_848 >= linearBegin), 0.0f, (1.0f - ((_860 * _860) * (3.0f - (_860 * 2.0f)))));
        float _877 = select((_849 >= linearBegin), 0.0f, (1.0f - ((_866 * _866) * (3.0f - (_866 * 2.0f)))));
        float _883 = select((_847 < linearStart), 0.0f, 1.0f);
        float _884 = select((_848 < linearStart), 0.0f, 1.0f);
        float _885 = select((_849 < linearStart), 0.0f, 1.0f);
        _1309 = (((((contrast * _847) + madLinearStartContrastFactor) * ((1.0f - _883) - _873)) + (((pow(_854, toe))*_873) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _847) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _883));
        _1310 = (((((contrast * _848) + madLinearStartContrastFactor) * ((1.0f - _884) - _875)) + (((pow(_860, toe))*_875) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _848) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _884));
        _1311 = (((((contrast * _849) + madLinearStartContrastFactor) * ((1.0f - _885) - _877)) + (((pow(_866, toe))*_877) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _849) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _885));
        _1312 = 0.0f;
        _1313 = fOptimizedParam.x;
        _1314 = fOptimizedParam.y;
        _1315 = fOptimizedParam.z;
        _1316 = fOptimizedParam.w;
        _1317 = 1.0f;
      } while (false);
    } else {
      do {
        if (!_46) {
          float4 _951 = RE_POSTPROCESS_Color.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
          _1205 = _951.x;
          _1206 = _951.y;
          _1207 = _951.z;
        } else {
          float _959 = screenInverseSize.x * SV_Position.x;
          float _960 = screenInverseSize.y * SV_Position.y;
          bool _964 = ((fHazeFilterAttribute & 2) != 0);
          float _967 = tFilterTempMap1.Sample(BilinearWrap, float2(_959, _960));
          do {
            if (_964) {
              float _970 = ReadonlyDepth.SampleLevel(PointClamp, float2(_959, _960), 0.0f);
              float _976 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
              float _977 = 1.0f - ((SV_Position.y * 2.0f) * screenInverseSize.y);
              float _1014 = 1.0f / (mad(_970.x, (viewProjInvMat[2].w), mad(_977, (viewProjInvMat[1].w), (_976 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _1016 = _1014 * (mad(_970.x, (viewProjInvMat[2].y), mad(_977, (viewProjInvMat[1].y), (_976 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _1024 = (_1014 * (mad(_970.x, (viewProjInvMat[2].x), mad(_977, (viewProjInvMat[1].x), (_976 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _1025 = _1016 - (transposeViewInvMat[1].w);
              float _1026 = (_1014 * (mad(_970.x, (viewProjInvMat[2].z), mad(_977, (viewProjInvMat[1].z), (_976 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _1051 = saturate(_967.x * max(((sqrt(((_1025 * _1025) + (_1024 * _1024)) + (_1026 * _1026)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_1016 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _1052 = _970.x;
            } else {
              _1051 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _967.x), _967.x);
              _1052 = 0.0f;
            }
            float _1057 = -0.0f - _960;
            float _1080 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_1057, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _959)));
            float _1081 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_1057, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _959)));
            float _1082 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_1057, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _959)));
            float _1086 = tVolumeMap.Sample(BilinearWrap, float3((_1080 + fHazeFilterUVWOffset.x), (_1081 + fHazeFilterUVWOffset.y), (_1082 + fHazeFilterUVWOffset.z)));
            float _1089 = _1080 * 2.0f;
            float _1090 = _1081 * 2.0f;
            float _1091 = _1082 * 2.0f;
            float _1095 = tVolumeMap.Sample(BilinearWrap, float3((_1089 + fHazeFilterUVWOffset.x), (_1090 + fHazeFilterUVWOffset.y), (_1091 + fHazeFilterUVWOffset.z)));
            float _1099 = _1080 * 4.0f;
            float _1100 = _1081 * 4.0f;
            float _1101 = _1082 * 4.0f;
            float _1105 = tVolumeMap.Sample(BilinearWrap, float3((_1099 + fHazeFilterUVWOffset.x), (_1100 + fHazeFilterUVWOffset.y), (_1101 + fHazeFilterUVWOffset.z)));
            float _1109 = _1080 * 8.0f;
            float _1110 = _1081 * 8.0f;
            float _1111 = _1082 * 8.0f;
            float _1115 = tVolumeMap.Sample(BilinearWrap, float3((_1109 + fHazeFilterUVWOffset.x), (_1110 + fHazeFilterUVWOffset.y), (_1111 + fHazeFilterUVWOffset.z)));
            float _1119 = fHazeFilterUVWOffset.x + 0.5f;
            float _1120 = fHazeFilterUVWOffset.y + 0.5f;
            float _1121 = fHazeFilterUVWOffset.z + 0.5f;
            float _1125 = tVolumeMap.Sample(BilinearWrap, float3((_1080 + _1119), (_1081 + _1120), (_1082 + _1121)));
            float _1131 = tVolumeMap.Sample(BilinearWrap, float3((_1089 + _1119), (_1090 + _1120), (_1091 + _1121)));
            float _1138 = tVolumeMap.Sample(BilinearWrap, float3((_1099 + _1119), (_1100 + _1120), (_1101 + _1121)));
            float _1145 = tVolumeMap.Sample(BilinearWrap, float3((_1109 + _1119), (_1110 + _1120), (_1111 + _1121)));
            float _1156 = (((((((_1095.x * 0.25f) + (_1086.x * 0.5f)) + (_1105.x * 0.125f)) + (_1115.x * 0.0625f)) * 2.0f) + -1.0f) * _1051) * fHazeFilterScale;
            float _1158 = (fHazeFilterScale * _1051) * ((((((_1131.x * 0.25f) + (_1125.x * 0.5f)) + (_1138.x * 0.125f)) + (_1145.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _1171 = 0.5f / fHazeFilterBorder;
                float _1178 = saturate(max(((_1171 * min(max((abs(_959 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_1171 * min(max((abs(_960 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _1184 = (_1156 - (_1178 * _1156));
                _1185 = (_1158 - (_1178 * _1158));
              } else {
                _1184 = _1156;
                _1185 = _1158;
              }
              do {
                if (_964) {
                  float _1189 = ReadonlyDepth.Sample(BilinearWrap, float2((_1184 + _959), (_1185 + _960)));
                  if (!(!((_1189.x - _1052) >= fHazeFilterDepthDiffBias))) {
                    _1196 = 0.0f;
                    _1197 = 0.0f;
                  } else {
                    _1196 = _1184;
                    _1197 = _1185;
                  }
                } else {
                  _1196 = _1184;
                  _1197 = _1185;
                }
                float4 _1200 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1196 + _959), (_1197 + _960)));
                _1205 = _1200.x;
                _1206 = _1200.y;
                _1207 = _1200.z;
              } while (false);
            } while (false);
          } while (false);
        }
        float _1208 = _1205 * _67;
        float _1209 = _1206 * _67;
        float _1210 = _1207 * _67;
        float _1215 = invLinearBegin * _1208;
        float _1221 = invLinearBegin * _1209;
        float _1227 = invLinearBegin * _1210;
        float _1234 = select((_1208 >= linearBegin), 0.0f, (1.0f - ((_1215 * _1215) * (3.0f - (_1215 * 2.0f)))));
        float _1236 = select((_1209 >= linearBegin), 0.0f, (1.0f - ((_1221 * _1221) * (3.0f - (_1221 * 2.0f)))));
        float _1238 = select((_1210 >= linearBegin), 0.0f, (1.0f - ((_1227 * _1227) * (3.0f - (_1227 * 2.0f)))));
        float _1244 = select((_1208 < linearStart), 0.0f, 1.0f);
        float _1245 = select((_1209 < linearStart), 0.0f, 1.0f);
        float _1246 = select((_1210 < linearStart), 0.0f, 1.0f);
        _1309 = (((((contrast * _1208) + madLinearStartContrastFactor) * ((1.0f - _1244) - _1234)) + (((pow(_1215, toe))*_1234) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1208) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1244));
        _1310 = (((((contrast * _1209) + madLinearStartContrastFactor) * ((1.0f - _1245) - _1236)) + (((pow(_1221, toe))*_1236) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1209) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1245));
        _1311 = (((((contrast * _1210) + madLinearStartContrastFactor) * ((1.0f - _1246) - _1238)) + (((pow(_1227, toe))*_1238) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1210) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1246));
        _1312 = 0.0f;
        _1313 = 0.0f;
        _1314 = 0.0f;
        _1315 = 0.0f;
        _1316 = 0.0f;
        _1317 = 1.0f;
      } while (false);
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _1341 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1344 = ComputeResultSRV[0].computeAlpha;
    float _1347 = ((1.0f - _1341) + (_1341 * _1344)) * cbRadialColor.w;
    if (!(_1347 == 0.0f)) {
      float _1355 = screenInverseSize.x * SV_Position.x;
      float _1356 = screenInverseSize.y * SV_Position.y;
      float _1358 = (-0.5f - cbRadialScreenPos.x) + _1355;
      float _1360 = (-0.5f - cbRadialScreenPos.y) + _1356;
      float _1363 = select((_1358 < 0.0f), (1.0f - _1355), _1355);
      float _1366 = select((_1360 < 0.0f), (1.0f - _1356), _1356);
      float _1371 = rsqrt(dot(float2(_1358, _1360), float2(_1358, _1360))) * cbRadialSharpRange;
      uint _1378 = uint(abs(_1371 * _1360)) + uint(abs(_1371 * _1358));
      uint _1382 = ((_1378 ^ 61) ^ ((uint)(_1378) >> 16)) * 9;
      uint _1385 = (((uint)(_1382) >> 4) ^ _1382) * 668265261;
      float _1390 = select(((cbRadialBlurFlags & 1) != 0), (float((uint)((int)(((uint)(_1385) >> 15) ^ _1385))) * 2.3283064365386963e-10f), 1.0f);
      float _1396 = 1.0f / max(1.0f, sqrt((_1358 * _1358) + (_1360 * _1360)));
      float _1397 = cbRadialBlurPower * -0.0011111111380159855f;
      float _1406 = ((((_1397 * _1363) * _1390) * _1396) + 1.0f) * _1358;
      float _1407 = ((((_1397 * _1366) * _1390) * _1396) + 1.0f) * _1360;
      float _1408 = cbRadialBlurPower * -0.002222222276031971f;
      float _1417 = ((((_1408 * _1363) * _1390) * _1396) + 1.0f) * _1358;
      float _1418 = ((((_1408 * _1366) * _1390) * _1396) + 1.0f) * _1360;
      float _1419 = cbRadialBlurPower * -0.0033333334140479565f;
      float _1428 = ((((_1419 * _1363) * _1390) * _1396) + 1.0f) * _1358;
      float _1429 = ((((_1419 * _1366) * _1390) * _1396) + 1.0f) * _1360;
      float _1430 = cbRadialBlurPower * -0.004444444552063942f;
      float _1439 = ((((_1430 * _1363) * _1390) * _1396) + 1.0f) * _1358;
      float _1440 = ((((_1430 * _1366) * _1390) * _1396) + 1.0f) * _1360;
      float _1441 = cbRadialBlurPower * -0.0055555556900799274f;
      float _1450 = ((((_1441 * _1363) * _1390) * _1396) + 1.0f) * _1358;
      float _1451 = ((((_1441 * _1366) * _1390) * _1396) + 1.0f) * _1360;
      float _1452 = cbRadialBlurPower * -0.006666666828095913f;
      float _1461 = ((((_1452 * _1363) * _1390) * _1396) + 1.0f) * _1358;
      float _1462 = ((((_1452 * _1366) * _1390) * _1396) + 1.0f) * _1360;
      float _1463 = cbRadialBlurPower * -0.007777777966111898f;
      float _1472 = ((((_1463 * _1363) * _1390) * _1396) + 1.0f) * _1358;
      float _1473 = ((((_1463 * _1366) * _1390) * _1396) + 1.0f) * _1360;
      float _1474 = cbRadialBlurPower * -0.008888889104127884f;
      float _1483 = ((((_1474 * _1363) * _1390) * _1396) + 1.0f) * _1358;
      float _1484 = ((((_1474 * _1366) * _1390) * _1396) + 1.0f) * _1360;
      float _1485 = cbRadialBlurPower * -0.009999999776482582f;
      float _1494 = ((((_1485 * _1363) * _1390) * _1396) + 1.0f) * _1358;
      float _1495 = ((((_1485 * _1366) * _1390) * _1396) + 1.0f) * _1360;
      float _1496 = (_66 * Exposure) * 0.10000000149011612f;
      float _1497 = _1496 * cbRadialColor.x;
      float _1498 = _1496 * cbRadialColor.y;
      float _1499 = _1496 * cbRadialColor.z;
      float _1514 = (_1309 * 0.10000000149011612f) * cbRadialColor.x;
      float _1516 = (_1310 * 0.10000000149011612f) * cbRadialColor.y;
      float _1518 = (_1311 * 0.10000000149011612f) * cbRadialColor.z;
      do {
        if (_42) {
          float _1520 = _1406 + cbRadialScreenPos.x;
          float _1521 = _1407 + cbRadialScreenPos.y;
          float _1525 = ((dot(float2(_1520, _1521), float2(_1520, _1521)) * _1312) + 1.0f) * _1317;
          float4 _1530 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1525 * _1520) + 0.5f), ((_1525 * _1521) + 0.5f)), 0.0f);
          float _1534 = _1417 + cbRadialScreenPos.x;
          float _1535 = _1418 + cbRadialScreenPos.y;
          float _1539 = ((dot(float2(_1534, _1535), float2(_1534, _1535)) * _1312) + 1.0f) * _1317;
          float4 _1544 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1539 * _1534) + 0.5f), ((_1539 * _1535) + 0.5f)), 0.0f);
          float _1551 = _1428 + cbRadialScreenPos.x;
          float _1552 = _1429 + cbRadialScreenPos.y;
          float _1555 = (dot(float2(_1551, _1552), float2(_1551, _1552)) * _1312) + 1.0f;
          float4 _1562 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1551 * _1317) * _1555) + 0.5f), (((_1552 * _1317) * _1555) + 0.5f)), 0.0f);
          float _1569 = _1439 + cbRadialScreenPos.x;
          float _1570 = _1440 + cbRadialScreenPos.y;
          float _1573 = (dot(float2(_1569, _1570), float2(_1569, _1570)) * _1312) + 1.0f;
          float4 _1580 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1569 * _1317) * _1573) + 0.5f), (((_1570 * _1317) * _1573) + 0.5f)), 0.0f);
          float _1587 = _1450 + cbRadialScreenPos.x;
          float _1588 = _1451 + cbRadialScreenPos.y;
          float _1591 = (dot(float2(_1587, _1588), float2(_1587, _1588)) * _1312) + 1.0f;
          float4 _1598 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1587 * _1317) * _1591) + 0.5f), (((_1588 * _1317) * _1591) + 0.5f)), 0.0f);
          float _1605 = _1461 + cbRadialScreenPos.x;
          float _1606 = _1462 + cbRadialScreenPos.y;
          float _1609 = (dot(float2(_1605, _1606), float2(_1605, _1606)) * _1312) + 1.0f;
          float4 _1616 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1605 * _1317) * _1609) + 0.5f), (((_1606 * _1317) * _1609) + 0.5f)), 0.0f);
          float _1623 = _1472 + cbRadialScreenPos.x;
          float _1624 = _1473 + cbRadialScreenPos.y;
          float _1627 = (dot(float2(_1623, _1624), float2(_1623, _1624)) * _1312) + 1.0f;
          float4 _1634 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1623 * _1317) * _1627) + 0.5f), (((_1624 * _1317) * _1627) + 0.5f)), 0.0f);
          float _1641 = _1483 + cbRadialScreenPos.x;
          float _1642 = _1484 + cbRadialScreenPos.y;
          float _1645 = (dot(float2(_1641, _1642), float2(_1641, _1642)) * _1312) + 1.0f;
          float4 _1652 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1641 * _1317) * _1645) + 0.5f), (((_1642 * _1317) * _1645) + 0.5f)), 0.0f);
          float _1659 = _1494 + cbRadialScreenPos.x;
          float _1660 = _1495 + cbRadialScreenPos.y;
          float _1663 = (dot(float2(_1659, _1660), float2(_1659, _1660)) * _1312) + 1.0f;
          float4 _1670 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1659 * _1317) * _1663) + 0.5f), (((_1660 * _1317) * _1663) + 0.5f)), 0.0f);
          float _1677 = _1497 * ((((((((_1544.x + _1530.x) + _1562.x) + _1580.x) + _1598.x) + _1616.x) + _1634.x) + _1652.x) + _1670.x);
          float _1678 = _1498 * ((((((((_1544.y + _1530.y) + _1562.y) + _1580.y) + _1598.y) + _1616.y) + _1634.y) + _1652.y) + _1670.y);
          float _1679 = _1499 * ((((((((_1544.z + _1530.z) + _1562.z) + _1580.z) + _1598.z) + _1616.z) + _1634.z) + _1652.z) + _1670.z);
          float _1680 = _1677 * invLinearBegin;
          float _1686 = _1678 * invLinearBegin;
          float _1692 = _1679 * invLinearBegin;
          float _1699 = select((_1677 >= linearBegin), 0.0f, (1.0f - ((_1680 * _1680) * (3.0f - (_1680 * 2.0f)))));
          float _1701 = select((_1678 >= linearBegin), 0.0f, (1.0f - ((_1686 * _1686) * (3.0f - (_1686 * 2.0f)))));
          float _1703 = select((_1679 >= linearBegin), 0.0f, (1.0f - ((_1692 * _1692) * (3.0f - (_1692 * 2.0f)))));
          float _1707 = select((_1677 < linearStart), 0.0f, 1.0f);
          float _1708 = select((_1678 < linearStart), 0.0f, 1.0f);
          float _1709 = select((_1679 < linearStart), 0.0f, 1.0f);
          _2281 = (((((_1699 * (pow(_1680, toe))) * linearBegin) + _1514) + (((contrast * _1677) + madLinearStartContrastFactor) * ((1.0f - _1707) - _1699))) + ((maxNit - (exp2((contrastFactor * _1677) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1707));
          _2282 = ((((((pow(_1686, toe))*_1701) * linearBegin) + _1516) + (((contrast * _1678) + madLinearStartContrastFactor) * ((1.0f - _1708) - _1701))) + ((maxNit - (exp2((contrastFactor * _1678) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1708));
          _2283 = ((((((pow(_1692, toe))*_1703) * linearBegin) + _1518) + (((contrast * _1679) + madLinearStartContrastFactor) * ((1.0f - _1709) - _1703))) + ((maxNit - (exp2((contrastFactor * _1679) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1709));
        } else {
          float _1768 = cbRadialScreenPos.x + 0.5f;
          float _1769 = _1768 + _1406;
          float _1770 = cbRadialScreenPos.y + 0.5f;
          float _1771 = _1770 + _1407;
          float _1772 = _1768 + _1417;
          float _1773 = _1770 + _1418;
          float _1774 = _1768 + _1428;
          float _1775 = _1770 + _1429;
          float _1776 = _1768 + _1439;
          float _1777 = _1770 + _1440;
          float _1778 = _1768 + _1450;
          float _1779 = _1770 + _1451;
          float _1780 = _1768 + _1461;
          float _1781 = _1770 + _1462;
          float _1782 = _1768 + _1472;
          float _1783 = _1770 + _1473;
          float _1784 = _1768 + _1483;
          float _1785 = _1770 + _1484;
          float _1786 = _1768 + _1494;
          float _1787 = _1770 + _1495;
          if (_44) {
            float _1791 = (_1769 * 2.0f) + -1.0f;
            float _1795 = sqrt((_1791 * _1791) + 1.0f);
            float _1796 = 1.0f / _1795;
            float _1799 = (_1795 * _1315) * (_1796 + _1313);
            float _1803 = _1316 * 0.5f;
            float4 _1811 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1803 * _1799) * _1791) + 0.5f), ((((_1803 * (((_1796 + -1.0f) * _1314) + 1.0f)) * _1799) * ((_1771 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _1817 = (_1772 * 2.0f) + -1.0f;
            float _1821 = sqrt((_1817 * _1817) + 1.0f);
            float _1822 = 1.0f / _1821;
            float _1825 = (_1821 * _1315) * (_1822 + _1313);
            float4 _1836 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1803 * _1825) * _1817) + 0.5f), ((((_1803 * (((_1822 + -1.0f) * _1314) + 1.0f)) * _1825) * ((_1773 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _1845 = (_1774 * 2.0f) + -1.0f;
            float _1849 = sqrt((_1845 * _1845) + 1.0f);
            float _1850 = 1.0f / _1849;
            float _1853 = (_1849 * _1315) * (_1850 + _1313);
            float4 _1864 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1803 * _1845) * _1853) + 0.5f), ((((_1803 * ((_1775 * 2.0f) + -1.0f)) * (((_1850 + -1.0f) * _1314) + 1.0f)) * _1853) + 0.5f)), 0.0f);
            float _1873 = (_1776 * 2.0f) + -1.0f;
            float _1877 = sqrt((_1873 * _1873) + 1.0f);
            float _1878 = 1.0f / _1877;
            float _1881 = (_1877 * _1315) * (_1878 + _1313);
            float4 _1892 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1803 * _1873) * _1881) + 0.5f), ((((_1803 * ((_1777 * 2.0f) + -1.0f)) * (((_1878 + -1.0f) * _1314) + 1.0f)) * _1881) + 0.5f)), 0.0f);
            float _1901 = (_1778 * 2.0f) + -1.0f;
            float _1905 = sqrt((_1901 * _1901) + 1.0f);
            float _1906 = 1.0f / _1905;
            float _1909 = (_1905 * _1315) * (_1906 + _1313);
            float4 _1920 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1803 * _1901) * _1909) + 0.5f), ((((_1803 * ((_1779 * 2.0f) + -1.0f)) * (((_1906 + -1.0f) * _1314) + 1.0f)) * _1909) + 0.5f)), 0.0f);
            float _1929 = (_1780 * 2.0f) + -1.0f;
            float _1933 = sqrt((_1929 * _1929) + 1.0f);
            float _1934 = 1.0f / _1933;
            float _1937 = (_1933 * _1315) * (_1934 + _1313);
            float4 _1948 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1803 * _1929) * _1937) + 0.5f), ((((_1803 * ((_1781 * 2.0f) + -1.0f)) * (((_1934 + -1.0f) * _1314) + 1.0f)) * _1937) + 0.5f)), 0.0f);
            float _1957 = (_1782 * 2.0f) + -1.0f;
            float _1961 = sqrt((_1957 * _1957) + 1.0f);
            float _1962 = 1.0f / _1961;
            float _1965 = (_1961 * _1315) * (_1962 + _1313);
            float4 _1976 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1803 * _1957) * _1965) + 0.5f), ((((_1803 * ((_1783 * 2.0f) + -1.0f)) * (((_1962 + -1.0f) * _1314) + 1.0f)) * _1965) + 0.5f)), 0.0f);
            float _1985 = (_1784 * 2.0f) + -1.0f;
            float _1989 = sqrt((_1985 * _1985) + 1.0f);
            float _1990 = 1.0f / _1989;
            float _1993 = (_1989 * _1315) * (_1990 + _1313);
            float4 _2004 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1803 * _1985) * _1993) + 0.5f), ((((_1803 * ((_1785 * 2.0f) + -1.0f)) * (((_1990 + -1.0f) * _1314) + 1.0f)) * _1993) + 0.5f)), 0.0f);
            float _2013 = (_1786 * 2.0f) + -1.0f;
            float _2017 = sqrt((_2013 * _2013) + 1.0f);
            float _2018 = 1.0f / _2017;
            float _2021 = (_2017 * _1315) * (_2018 + _1313);
            float4 _2032 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1803 * _2013) * _2021) + 0.5f), ((((_1803 * ((_1787 * 2.0f) + -1.0f)) * (((_2018 + -1.0f) * _1314) + 1.0f)) * _2021) + 0.5f)), 0.0f);
            float _2039 = _1497 * ((((((((_1836.x + _1811.x) + _1864.x) + _1892.x) + _1920.x) + _1948.x) + _1976.x) + _2004.x) + _2032.x);
            float _2040 = _1498 * ((((((((_1836.y + _1811.y) + _1864.y) + _1892.y) + _1920.y) + _1948.y) + _1976.y) + _2004.y) + _2032.y);
            float _2041 = _1499 * ((((((((_1836.z + _1811.z) + _1864.z) + _1892.z) + _1920.z) + _1948.z) + _1976.z) + _2004.z) + _2032.z);
            float _2042 = _2039 * invLinearBegin;
            float _2048 = _2040 * invLinearBegin;
            float _2054 = _2041 * invLinearBegin;
            float _2061 = select((_2039 >= linearBegin), 0.0f, (1.0f - ((_2042 * _2042) * (3.0f - (_2042 * 2.0f)))));
            float _2063 = select((_2040 >= linearBegin), 0.0f, (1.0f - ((_2048 * _2048) * (3.0f - (_2048 * 2.0f)))));
            float _2065 = select((_2041 >= linearBegin), 0.0f, (1.0f - ((_2054 * _2054) * (3.0f - (_2054 * 2.0f)))));
            float _2069 = select((_2039 < linearStart), 0.0f, 1.0f);
            float _2070 = select((_2040 < linearStart), 0.0f, 1.0f);
            float _2071 = select((_2041 < linearStart), 0.0f, 1.0f);
            _2281 = (((((_2061 * (pow(_2042, toe))) * linearBegin) + _1514) + (((contrast * _2039) + madLinearStartContrastFactor) * ((1.0f - _2069) - _2061))) + ((maxNit - (exp2((contrastFactor * _2039) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2069));
            _2282 = ((((((pow(_2048, toe))*_2063) * linearBegin) + _1516) + (((contrast * _2040) + madLinearStartContrastFactor) * ((1.0f - _2070) - _2063))) + ((maxNit - (exp2((contrastFactor * _2040) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2070));
            _2283 = ((((((pow(_2054, toe))*_2065) * linearBegin) + _1518) + (((contrast * _2041) + madLinearStartContrastFactor) * ((1.0f - _2071) - _2065))) + ((maxNit - (exp2((contrastFactor * _2041) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2071));
          } else {
            float4 _2130 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1769, _1771), 0.0f);
            float4 _2134 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1772, _1773), 0.0f);
            float4 _2141 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1774, _1775), 0.0f);
            float4 _2148 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1776, _1777), 0.0f);
            float4 _2155 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1778, _1779), 0.0f);
            float4 _2162 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1780, _1781), 0.0f);
            float4 _2169 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1782, _1783), 0.0f);
            float4 _2176 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1784, _1785), 0.0f);
            float4 _2183 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1786, _1787), 0.0f);
            float _2190 = _1497 * ((((((((_2134.x + _2130.x) + _2141.x) + _2148.x) + _2155.x) + _2162.x) + _2169.x) + _2176.x) + _2183.x);
            float _2191 = _1498 * ((((((((_2134.y + _2130.y) + _2141.y) + _2148.y) + _2155.y) + _2162.y) + _2169.y) + _2176.y) + _2183.y);
            float _2192 = _1499 * ((((((((_2134.z + _2130.z) + _2141.z) + _2148.z) + _2155.z) + _2162.z) + _2169.z) + _2176.z) + _2183.z);
            float _2193 = _2190 * invLinearBegin;
            float _2199 = _2191 * invLinearBegin;
            float _2205 = _2192 * invLinearBegin;
            float _2212 = select((_2190 >= linearBegin), 0.0f, (1.0f - ((_2193 * _2193) * (3.0f - (_2193 * 2.0f)))));
            float _2214 = select((_2191 >= linearBegin), 0.0f, (1.0f - ((_2199 * _2199) * (3.0f - (_2199 * 2.0f)))));
            float _2216 = select((_2192 >= linearBegin), 0.0f, (1.0f - ((_2205 * _2205) * (3.0f - (_2205 * 2.0f)))));
            float _2220 = select((_2190 < linearStart), 0.0f, 1.0f);
            float _2221 = select((_2191 < linearStart), 0.0f, 1.0f);
            float _2222 = select((_2192 < linearStart), 0.0f, 1.0f);
            _2281 = (((((_2212 * (pow(_2193, toe))) * linearBegin) + _1514) + (((contrast * _2190) + madLinearStartContrastFactor) * ((1.0f - _2220) - _2212))) + ((maxNit - (exp2((contrastFactor * _2190) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2220));
            _2282 = ((((((pow(_2199, toe))*_2214) * linearBegin) + _1516) + (((contrast * _2191) + madLinearStartContrastFactor) * ((1.0f - _2221) - _2214))) + ((maxNit - (exp2((contrastFactor * _2191) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2221));
            _2283 = ((((((pow(_2205, toe))*_2216) * linearBegin) + _1518) + (((contrast * _2192) + madLinearStartContrastFactor) * ((1.0f - _2222) - _2216))) + ((maxNit - (exp2((contrastFactor * _2192) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2222));
          }
        }
        do {
          if (cbRadialMaskRate.x > 0.0f) {
            float _2292 = saturate((sqrt((_1358 * _1358) + (_1360 * _1360)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
            float _2298 = (((_2292 * _2292) * cbRadialMaskRate.x) * (3.0f - (_2292 * 2.0f))) + cbRadialMaskRate.y;
            _2309 = ((_2298 * (_2281 - _1309)) + _1309);
            _2310 = ((_2298 * (_2282 - _1310)) + _1310);
            _2311 = ((_2298 * (_2283 - _1311)) + _1311);
          } else {
            _2309 = _2281;
            _2310 = _2282;
            _2311 = _2283;
          }
          _2322 = (lerp(_1309, _2309, _1347));
          _2323 = (lerp(_1310, _2310, _1347));
          _2324 = (lerp(_1311, _2311, _1347));
        } while (false);
      } while (false);
    } else {
      _2322 = _1309;
      _2323 = _1310;
      _2324 = _1311;
    }
  } else {
    _2322 = _1309;
    _2323 = _1310;
    _2324 = _1311;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _2348 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
    float _2350 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
    float _2354 = frac(frac(dot(float2(_2348, _2350), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_2354 < fNoiseDensity) {
        int _2359 = (uint)(uint(_2350 * _2348)) ^ 12345391;
        uint _2360 = _2359 * 3635641;
        _2368 = (float((uint)((int)((((uint)(_2360) >> 26) | ((uint)(_2359 * 232681024))) ^ _2360))) * 2.3283064365386963e-10f);
      } else {
        _2368 = 0.0f;
      }
      float _2370 = frac(_2354 * 757.4846801757812f);
      do {
        if (_2370 < fNoiseDensity) {
          int _2374 = asint(_2370) ^ 12345391;
          uint _2375 = _2374 * 3635641;
          _2384 = ((float((uint)((int)((((uint)(_2375) >> 26) | ((uint)(_2374 * 232681024))) ^ _2375))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _2384 = 0.0f;
        }
        float _2386 = frac(_2370 * 757.4846801757812f);
        do {
          if (_2386 < fNoiseDensity) {
            int _2390 = asint(_2386) ^ 12345391;
            uint _2391 = _2390 * 3635641;
            _2400 = ((float((uint)((int)((((uint)(_2391) >> 26) | ((uint)(_2390 * 232681024))) ^ _2391))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _2400 = 0.0f;
          }
          float _2401 = _2368 * fNoisePower.x;
          float _2402 = _2400 * fNoisePower.y;
          float _2403 = _2384 * fNoisePower.y;
          float _2414 = exp2(log2(1.0f - saturate(dot(float3(_2322, _2323, _2324), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _2425 = ((_2414 * (mad(_2403, 1.4019999504089355f, _2401) - _2322)) + _2322);
          _2426 = ((_2414 * (mad(_2403, -0.7139999866485596f, mad(_2402, -0.3440000116825104f, _2401)) - _2323)) + _2323);
          _2427 = ((_2414 * (mad(_2402, 1.7719999551773071f, _2401) - _2324)) + _2324);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2425 = _2322;
    _2426 = _2323;
    _2427 = _2324;
  }
#if 1
  ApplyColorGrading(
      _2425, _2426, _2427,
      _2638, _2639, _2640,
      cPassEnabled,
      fTextureSize,
      fTextureBlendRate,
      fTextureBlendRate2,
      fTextureInverseSize,
      fColorMatrix,
      tTextureMap0,
      tTextureMap1,
      tTextureMap2,
      TrilinearClamp);
#else
  if (!((cPassEnabled & 4) == 0)) {
    float _2452 = max(max(_2425, _2426), _2427);
    bool _2453 = (_2452 > 1.0f);
    do {
      if (_2453) {
        _2459 = (_2425 / _2452);
        _2460 = (_2426 / _2452);
        _2461 = (_2427 / _2452);
      } else {
        _2459 = _2425;
        _2460 = _2426;
        _2461 = _2427;
      }
      float _2462 = fTextureInverseSize * 0.5f;
      do {
        [branch]
        if (!(!(_2459 <= 0.0031308000907301903f))) {
          _2473 = (_2459 * 12.920000076293945f);
        } else {
          _2473 = (((pow(_2459, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          [branch]
          if (!(!(_2460 <= 0.0031308000907301903f))) {
            _2484 = (_2460 * 12.920000076293945f);
          } else {
            _2484 = (((pow(_2460, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            [branch]
            if (!(!(_2461 <= 0.0031308000907301903f))) {
              _2495 = (_2461 * 12.920000076293945f);
            } else {
              _2495 = (((pow(_2461, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            float _2496 = 1.0f - fTextureInverseSize;
            float _2500 = (_2473 * _2496) + _2462;
            float _2501 = (_2484 * _2496) + _2462;
            float _2502 = (_2495 * _2496) + _2462;
            float4 _2503 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2500, _2501, _2502), 0.0f);
            do {
              [branch]
              if (fTextureBlendRate > 0.0f) {
                float4 _2509 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2500, _2501, _2502), 0.0f);
                float _2519 = ((_2509.x - _2503.x) * fTextureBlendRate) + _2503.x;
                float _2520 = ((_2509.y - _2503.y) * fTextureBlendRate) + _2503.y;
                float _2521 = ((_2509.z - _2503.z) * fTextureBlendRate) + _2503.z;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    [branch]
                    if (!(!(_2519 <= 0.0031308000907301903f))) {
                      _2534 = (_2519 * 12.920000076293945f);
                    } else {
                      _2534 = (((pow(_2519, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_2520 <= 0.0031308000907301903f))) {
                        _2545 = (_2520 * 12.920000076293945f);
                      } else {
                        _2545 = (((pow(_2520, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_2521 <= 0.0031308000907301903f))) {
                          _2556 = (_2521 * 12.920000076293945f);
                        } else {
                          _2556 = (((pow(_2521, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _2557 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2534, _2545, _2556), 0.0f);
                        _2618 = (lerp(_2519, _2557.x, fTextureBlendRate2));
                        _2619 = (lerp(_2520, _2557.y, fTextureBlendRate2));
                        _2620 = (lerp(_2521, _2557.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _2618 = _2519;
                  _2619 = _2520;
                  _2620 = _2521;
                }
              } else {
                do {
                  [branch]
                  if (!(!(_2503.x <= 0.0031308000907301903f))) {
                    _2581 = (_2503.x * 12.920000076293945f);
                  } else {
                    _2581 = (((pow(_2503.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  }
                  do {
                    [branch]
                    if (!(!(_2503.y <= 0.0031308000907301903f))) {
                      _2592 = (_2503.y * 12.920000076293945f);
                    } else {
                      _2592 = (((pow(_2503.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_2503.z <= 0.0031308000907301903f))) {
                        _2603 = (_2503.z * 12.920000076293945f);
                      } else {
                        _2603 = (((pow(_2503.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      float4 _2604 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2581, _2592, _2603), 0.0f);
                      _2618 = (lerp(_2503.x, _2604.x, fTextureBlendRate2));
                      _2619 = (lerp(_2503.y, _2604.y, fTextureBlendRate2));
                      _2620 = (lerp(_2503.z, _2604.z, fTextureBlendRate2));
                    } while (false);
                  } while (false);
                } while (false);
              }
              float _2624 = mad(_2620, (fColorMatrix[2].x), mad(_2619, (fColorMatrix[1].x), (_2618 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
              float _2628 = mad(_2620, (fColorMatrix[2].y), mad(_2619, (fColorMatrix[1].y), (_2618 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
              float _2632 = mad(_2620, (fColorMatrix[2].z), mad(_2619, (fColorMatrix[1].z), (_2618 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
              if (_2453) {
                _2638 = (_2624 * _2452);
                _2639 = (_2628 * _2452);
                _2640 = (_2632 * _2452);
              } else {
                _2638 = _2624;
                _2639 = _2628;
                _2640 = _2632;
              }
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2638 = _2425;
    _2639 = _2426;
    _2640 = _2427;
  }
#endif
  if (!((cPassEnabled & 8) == 0)) {
    _2675 = saturate(((cvdR.x * _2638) + (cvdR.y * _2639)) + (cvdR.z * _2640));
    _2676 = saturate(((cvdG.x * _2638) + (cvdG.y * _2639)) + (cvdG.z * _2640));
    _2677 = saturate(((cvdB.x * _2638) + (cvdB.y * _2639)) + (cvdB.z * _2640));
  } else {
    _2675 = _2638;
    _2676 = _2639;
    _2677 = _2640;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2692 = screenInverseSize.x * SV_Position.x;
    float _2693 = screenInverseSize.y * SV_Position.y;
    float4 _2694 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2692, _2693), 0.0f);
    float _2699 = _2694.x * ColorParam.x;
    float _2700 = _2694.y * ColorParam.y;
    float _2701 = _2694.z * ColorParam.z;
    float _2703 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2692, _2693), 0.0f);
    float _2708 = (_2694.w * ColorParam.w) * saturate((_2703.x * Levels_Rate) + Levels_Range);
    _2746 = (((select((_2699 < 0.5f), ((_2675 * 2.0f) * _2699), (1.0f - (((1.0f - _2675) * 2.0f) * (1.0f - _2699)))) - _2675) * _2708) + _2675);
    _2747 = (((select((_2700 < 0.5f), ((_2676 * 2.0f) * _2700), (1.0f - (((1.0f - _2676) * 2.0f) * (1.0f - _2700)))) - _2676) * _2708) + _2676);
    _2748 = (((select((_2701 < 0.5f), ((_2677 * 2.0f) * _2701), (1.0f - (((1.0f - _2677) * 2.0f) * (1.0f - _2701)))) - _2677) * _2708) + _2677);
  } else {
    _2746 = _2675;
    _2747 = _2676;
    _2748 = _2677;
  }
  SV_Target.x = _2746;
  SV_Target.y = _2747;
  SV_Target.z = _2748;
  SV_Target.w = 0.0f;

#if 1
  SV_Target.rgb = ApplyUserGrading(SV_Target.rgb);
#endif

  return SV_Target;
}
