#define SHADER_HASH 0x16906EB5
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
  uint fHazeFilterReserved[3] : packoffset(c004.x);
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
  float4 fColorMatrix[4] : packoffset(c001.x);
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
  float _667;
  float _668;
  float _798;
  float _799;
  float _810;
  float _811;
  float _815;
  float _816;
  float _1025;
  float _1026;
  float _1158;
  float _1159;
  float _1170;
  float _1171;
  float _1179;
  float _1180;
  float _1181;
  float _1283;
  float _1284;
  float _1285;
  float _1286;
  float _1287;
  float _1288;
  float _1289;
  float _1290;
  float _1291;
  float _2254;
  float _2255;
  float _2256;
  float _2282;
  float _2283;
  float _2284;
  float _2295;
  float _2296;
  float _2297;
  float _2341;
  float _2357;
  float _2373;
  float _2398;
  float _2399;
  float _2400;
  float _2432;
  float _2433;
  float _2434;
  float _2446;
  float _2457;
  float _2468;
  float _2507;
  float _2518;
  float _2529;
  float _2554;
  float _2565;
  float _2576;
  float _2591;
  float _2592;
  float _2593;
  float _2611;
  float _2612;
  float _2613;
  float _2648;
  float _2649;
  float _2650;
  float _2719;
  float _2720;
  float _2721;
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
        float _322 = invLinearBegin * _315;
        float _328 = invLinearBegin * _316;
        float _334 = invLinearBegin * _317;
        float _341 = select((_315 >= linearBegin), 0.0f, (1.0f - ((_322 * _322) * (3.0f - (_322 * 2.0f)))));
        float _343 = select((_316 >= linearBegin), 0.0f, (1.0f - ((_328 * _328) * (3.0f - (_328 * 2.0f)))));
        float _345 = select((_317 >= linearBegin), 0.0f, (1.0f - ((_334 * _334) * (3.0f - (_334 * 2.0f)))));
        float _351 = select((_315 < linearStart), 0.0f, 1.0f);
        float _352 = select((_316 < linearStart), 0.0f, 1.0f);
        float _353 = select((_317 < linearStart), 0.0f, 1.0f);
        _1283 = (((((contrast * _315) + madLinearStartContrastFactor) * ((1.0f - _351) - _341)) + (((pow(_322, toe))*_341) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _315) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _351));
        _1284 = (((((contrast * _316) + madLinearStartContrastFactor) * ((1.0f - _352) - _343)) + (((pow(_328, toe))*_343) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _316) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _352));
        _1285 = (((((contrast * _317) + madLinearStartContrastFactor) * ((1.0f - _353) - _345)) + (((pow(_334, toe))*_345) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _317) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _353));
        _1286 = fDistortionCoef;
        _1287 = 0.0f;
        _1288 = 0.0f;
        _1289 = 0.0f;
        _1290 = 0.0f;
        _1291 = fCorrectCoef;
      } while (false);
    } else {
      float _416 = _56 + fRefraction;
      float _418 = (_416 * fDistortionCoef) + 1.0f;
      float _419 = _54 * fCorrectCoef;
      float _421 = _55 * fCorrectCoef;
      float _427 = ((_416 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _432 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_62, _63));
      float _434 = _432.x * Exposure;
      float _439 = invLinearBegin * _434;
      float _446 = select((_434 >= linearBegin), 0.0f, (1.0f - ((_439 * _439) * (3.0f - (_439 * 2.0f)))));
      float _450 = select((_434 < linearStart), 0.0f, 1.0f);
      float4 _476 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_419 * _418) + 0.5f), ((_421 * _418) + 0.5f)));
      float _478 = _476.y * Exposure;
      float _479 = invLinearBegin * _478;
      float _486 = select((_478 >= linearBegin), 0.0f, (1.0f - ((_479 * _479) * (3.0f - (_479 * 2.0f)))));
      float _488 = select((_478 < linearStart), 0.0f, 1.0f);
      float4 _507 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_419 * _427) + 0.5f), ((_421 * _427) + 0.5f)));
      float _509 = _507.z * Exposure;
      float _510 = invLinearBegin * _509;
      float _517 = select((_509 >= linearBegin), 0.0f, (1.0f - ((_510 * _510) * (3.0f - (_510 * 2.0f)))));
      float _519 = select((_509 < linearStart), 0.0f, 1.0f);
      _1283 = (((((contrast * _434) + madLinearStartContrastFactor) * ((1.0f - _450) - _446)) + ((linearBegin * (pow(_439, toe))) * _446)) + ((maxNit - (exp2((contrastFactor * _434) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _450));
      _1284 = (((((contrast * _478) + madLinearStartContrastFactor) * ((1.0f - _488) - _486)) + ((linearBegin * (pow(_479, toe))) * _486)) + ((maxNit - (exp2((contrastFactor * _478) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _488));
      _1285 = (((((contrast * _509) + madLinearStartContrastFactor) * ((1.0f - _519) - _517)) + ((linearBegin * (pow(_510, toe))) * _517)) + ((maxNit - (exp2((contrastFactor * _509) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _519));
      _1286 = fDistortionCoef;
      _1287 = 0.0f;
      _1288 = 0.0f;
      _1289 = 0.0f;
      _1290 = 0.0f;
      _1291 = fCorrectCoef;
    }
  } else {
    if (_39) {
      float _552 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _556 = sqrt((_552 * _552) + 1.0f);
      float _557 = 1.0f / _556;
      float _560 = (_556 * fOptimizedParam.z) * (_557 + fOptimizedParam.x);
      float _564 = fOptimizedParam.w * 0.5f;
      float _566 = (_564 * _552) * _560;
      float _569 = ((_564 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_557 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _560;
      float _570 = _566 + 0.5f;
      float _571 = _569 + 0.5f;
      do {
        if (_41) {
          bool _578 = ((fHazeFilterAttribute & 2) != 0);
          float _581 = tFilterTempMap1.Sample(BilinearWrap, float2(_570, _571));
          do {
            if (_578) {
              float _584 = ReadonlyDepth.SampleLevel(PointClamp, float2(_570, _571), 0.0f);
              float _592 = (((screenSize.x * 2.0f) * _570) * screenInverseSize.x) + -1.0f;
              float _593 = 1.0f - (((screenSize.y * 2.0f) * _571) * screenInverseSize.y);
              float _630 = 1.0f / (mad(_584.x, (viewProjInvMat[2].w), mad(_593, (viewProjInvMat[1].w), (_592 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _632 = _630 * (mad(_584.x, (viewProjInvMat[2].y), mad(_593, (viewProjInvMat[1].y), (_592 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _640 = (_630 * (mad(_584.x, (viewProjInvMat[2].x), mad(_593, (viewProjInvMat[1].x), (_592 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _641 = _632 - (transposeViewInvMat[1].w);
              float _642 = (_630 * (mad(_584.x, (viewProjInvMat[2].z), mad(_593, (viewProjInvMat[1].z), (_592 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _667 = saturate(_581.x * max(((sqrt(((_641 * _641) + (_640 * _640)) + (_642 * _642)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_632 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _668 = _584.x;
            } else {
              _667 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _581.x), _581.x);
              _668 = 0.0f;
            }
            float _673 = -0.0f - _571;
            float _696 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_673, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _570)));
            float _697 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_673, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _570)));
            float _698 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_673, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _570)));
            float _702 = tVolumeMap.Sample(BilinearWrap, float3((_696 + fHazeFilterUVWOffset.x), (_697 + fHazeFilterUVWOffset.y), (_698 + fHazeFilterUVWOffset.z)));
            float _705 = _696 * 2.0f;
            float _706 = _697 * 2.0f;
            float _707 = _698 * 2.0f;
            float _711 = tVolumeMap.Sample(BilinearWrap, float3((_705 + fHazeFilterUVWOffset.x), (_706 + fHazeFilterUVWOffset.y), (_707 + fHazeFilterUVWOffset.z)));
            float _715 = _696 * 4.0f;
            float _716 = _697 * 4.0f;
            float _717 = _698 * 4.0f;
            float _721 = tVolumeMap.Sample(BilinearWrap, float3((_715 + fHazeFilterUVWOffset.x), (_716 + fHazeFilterUVWOffset.y), (_717 + fHazeFilterUVWOffset.z)));
            float _725 = _696 * 8.0f;
            float _726 = _697 * 8.0f;
            float _727 = _698 * 8.0f;
            float _731 = tVolumeMap.Sample(BilinearWrap, float3((_725 + fHazeFilterUVWOffset.x), (_726 + fHazeFilterUVWOffset.y), (_727 + fHazeFilterUVWOffset.z)));
            float _735 = fHazeFilterUVWOffset.x + 0.5f;
            float _736 = fHazeFilterUVWOffset.y + 0.5f;
            float _737 = fHazeFilterUVWOffset.z + 0.5f;
            float _741 = tVolumeMap.Sample(BilinearWrap, float3((_696 + _735), (_697 + _736), (_698 + _737)));
            float _747 = tVolumeMap.Sample(BilinearWrap, float3((_705 + _735), (_706 + _736), (_707 + _737)));
            float _754 = tVolumeMap.Sample(BilinearWrap, float3((_715 + _735), (_716 + _736), (_717 + _737)));
            float _761 = tVolumeMap.Sample(BilinearWrap, float3((_725 + _735), (_726 + _736), (_727 + _737)));
            float _772 = (((((((_711.x * 0.25f) + (_702.x * 0.5f)) + (_721.x * 0.125f)) + (_731.x * 0.0625f)) * 2.0f) + -1.0f) * _667) * fHazeFilterScale;
            float _774 = (fHazeFilterScale * _667) * ((((((_747.x * 0.25f) + (_741.x * 0.5f)) + (_754.x * 0.125f)) + (_761.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _785 = 0.5f / fHazeFilterBorder;
                float _792 = saturate(max(((_785 * min(max((abs(_566) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_785 * min(max((abs(_569) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _798 = (_772 - (_792 * _772));
                _799 = (_774 - (_792 * _774));
              } else {
                _798 = _772;
                _799 = _774;
              }
              do {
                if (_578) {
                  float _803 = ReadonlyDepth.Sample(BilinearWrap, float2((_798 + _570), (_799 + _571)));
                  if (!(!((_803.x - _668) >= fHazeFilterDepthDiffBias))) {
                    _810 = 0.0f;
                    _811 = 0.0f;
                  } else {
                    _810 = _798;
                    _811 = _799;
                  }
                } else {
                  _810 = _798;
                  _811 = _799;
                }
                _815 = (_810 + _570);
                _816 = (_811 + _571);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _815 = _570;
          _816 = _571;
        }
        float4 _817 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_815, _816));
        float _821 = _817.x * Exposure;
        float _822 = _817.y * Exposure;
        float _823 = _817.z * Exposure;
        float _828 = invLinearBegin * _821;
        float _834 = invLinearBegin * _822;
        float _840 = invLinearBegin * _823;
        float _847 = select((_821 >= linearBegin), 0.0f, (1.0f - ((_828 * _828) * (3.0f - (_828 * 2.0f)))));
        float _849 = select((_822 >= linearBegin), 0.0f, (1.0f - ((_834 * _834) * (3.0f - (_834 * 2.0f)))));
        float _851 = select((_823 >= linearBegin), 0.0f, (1.0f - ((_840 * _840) * (3.0f - (_840 * 2.0f)))));
        float _857 = select((_821 < linearStart), 0.0f, 1.0f);
        float _858 = select((_822 < linearStart), 0.0f, 1.0f);
        float _859 = select((_823 < linearStart), 0.0f, 1.0f);
        _1283 = (((((contrast * _821) + madLinearStartContrastFactor) * ((1.0f - _857) - _847)) + (((pow(_828, toe))*_847) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _821) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _857));
        _1284 = (((((contrast * _822) + madLinearStartContrastFactor) * ((1.0f - _858) - _849)) + (((pow(_834, toe))*_849) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _822) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _858));
        _1285 = (((((contrast * _823) + madLinearStartContrastFactor) * ((1.0f - _859) - _851)) + (((pow(_840, toe))*_851) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _823) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _859));
        _1286 = 0.0f;
        _1287 = fOptimizedParam.x;
        _1288 = fOptimizedParam.y;
        _1289 = fOptimizedParam.z;
        _1290 = fOptimizedParam.w;
        _1291 = 1.0f;
      } while (false);
    } else {
      do {
        if (!_41) {
          float4 _925 = RE_POSTPROCESS_Color.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
          _1179 = _925.x;
          _1180 = _925.y;
          _1181 = _925.z;
        } else {
          float _933 = screenInverseSize.x * SV_Position.x;
          float _934 = screenInverseSize.y * SV_Position.y;
          bool _938 = ((fHazeFilterAttribute & 2) != 0);
          float _941 = tFilterTempMap1.Sample(BilinearWrap, float2(_933, _934));
          do {
            if (_938) {
              float _944 = ReadonlyDepth.SampleLevel(PointClamp, float2(_933, _934), 0.0f);
              float _950 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
              float _951 = 1.0f - ((SV_Position.y * 2.0f) * screenInverseSize.y);
              float _988 = 1.0f / (mad(_944.x, (viewProjInvMat[2].w), mad(_951, (viewProjInvMat[1].w), (_950 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
              float _990 = _988 * (mad(_944.x, (viewProjInvMat[2].y), mad(_951, (viewProjInvMat[1].y), (_950 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
              float _998 = (_988 * (mad(_944.x, (viewProjInvMat[2].x), mad(_951, (viewProjInvMat[1].x), (_950 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
              float _999 = _990 - (transposeViewInvMat[1].w);
              float _1000 = (_988 * (mad(_944.x, (viewProjInvMat[2].z), mad(_951, (viewProjInvMat[1].z), (_950 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
              _1025 = saturate(_941.x * max(((sqrt(((_999 * _999) + (_998 * _998)) + (_1000 * _1000)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_990 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
              _1026 = _944.x;
            } else {
              _1025 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _941.x), _941.x);
              _1026 = 0.0f;
            }
            float _1031 = -0.0f - _934;
            float _1054 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_1031, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _933)));
            float _1055 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_1031, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _933)));
            float _1056 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_1031, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _933)));
            float _1060 = tVolumeMap.Sample(BilinearWrap, float3((_1054 + fHazeFilterUVWOffset.x), (_1055 + fHazeFilterUVWOffset.y), (_1056 + fHazeFilterUVWOffset.z)));
            float _1063 = _1054 * 2.0f;
            float _1064 = _1055 * 2.0f;
            float _1065 = _1056 * 2.0f;
            float _1069 = tVolumeMap.Sample(BilinearWrap, float3((_1063 + fHazeFilterUVWOffset.x), (_1064 + fHazeFilterUVWOffset.y), (_1065 + fHazeFilterUVWOffset.z)));
            float _1073 = _1054 * 4.0f;
            float _1074 = _1055 * 4.0f;
            float _1075 = _1056 * 4.0f;
            float _1079 = tVolumeMap.Sample(BilinearWrap, float3((_1073 + fHazeFilterUVWOffset.x), (_1074 + fHazeFilterUVWOffset.y), (_1075 + fHazeFilterUVWOffset.z)));
            float _1083 = _1054 * 8.0f;
            float _1084 = _1055 * 8.0f;
            float _1085 = _1056 * 8.0f;
            float _1089 = tVolumeMap.Sample(BilinearWrap, float3((_1083 + fHazeFilterUVWOffset.x), (_1084 + fHazeFilterUVWOffset.y), (_1085 + fHazeFilterUVWOffset.z)));
            float _1093 = fHazeFilterUVWOffset.x + 0.5f;
            float _1094 = fHazeFilterUVWOffset.y + 0.5f;
            float _1095 = fHazeFilterUVWOffset.z + 0.5f;
            float _1099 = tVolumeMap.Sample(BilinearWrap, float3((_1054 + _1093), (_1055 + _1094), (_1056 + _1095)));
            float _1105 = tVolumeMap.Sample(BilinearWrap, float3((_1063 + _1093), (_1064 + _1094), (_1065 + _1095)));
            float _1112 = tVolumeMap.Sample(BilinearWrap, float3((_1073 + _1093), (_1074 + _1094), (_1075 + _1095)));
            float _1119 = tVolumeMap.Sample(BilinearWrap, float3((_1083 + _1093), (_1084 + _1094), (_1085 + _1095)));
            float _1130 = (((((((_1069.x * 0.25f) + (_1060.x * 0.5f)) + (_1079.x * 0.125f)) + (_1089.x * 0.0625f)) * 2.0f) + -1.0f) * _1025) * fHazeFilterScale;
            float _1132 = (fHazeFilterScale * _1025) * ((((((_1105.x * 0.25f) + (_1099.x * 0.5f)) + (_1112.x * 0.125f)) + (_1119.x * 0.0625f)) * 2.0f) + -1.0f);
            do {
              if (!((fHazeFilterAttribute & 4) == 0)) {
                float _1145 = 0.5f / fHazeFilterBorder;
                float _1152 = saturate(max(((_1145 * min(max((abs(_933 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_1145 * min(max((abs(_934 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade)));
                _1158 = (_1130 - (_1152 * _1130));
                _1159 = (_1132 - (_1152 * _1132));
              } else {
                _1158 = _1130;
                _1159 = _1132;
              }
              do {
                if (_938) {
                  float _1163 = ReadonlyDepth.Sample(BilinearWrap, float2((_1158 + _933), (_1159 + _934)));
                  if (!(!((_1163.x - _1026) >= fHazeFilterDepthDiffBias))) {
                    _1170 = 0.0f;
                    _1171 = 0.0f;
                  } else {
                    _1170 = _1158;
                    _1171 = _1159;
                  }
                } else {
                  _1170 = _1158;
                  _1171 = _1159;
                }
                float4 _1174 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1170 + _933), (_1171 + _934)));
                _1179 = _1174.x;
                _1180 = _1174.y;
                _1181 = _1174.z;
              } while (false);
            } while (false);
          } while (false);
        }
        float _1182 = _1179 * Exposure;
        float _1183 = _1180 * Exposure;
        float _1184 = _1181 * Exposure;
        float _1189 = invLinearBegin * _1182;
        float _1195 = invLinearBegin * _1183;
        float _1201 = invLinearBegin * _1184;
        float _1208 = select((_1182 >= linearBegin), 0.0f, (1.0f - ((_1189 * _1189) * (3.0f - (_1189 * 2.0f)))));
        float _1210 = select((_1183 >= linearBegin), 0.0f, (1.0f - ((_1195 * _1195) * (3.0f - (_1195 * 2.0f)))));
        float _1212 = select((_1184 >= linearBegin), 0.0f, (1.0f - ((_1201 * _1201) * (3.0f - (_1201 * 2.0f)))));
        float _1218 = select((_1182 < linearStart), 0.0f, 1.0f);
        float _1219 = select((_1183 < linearStart), 0.0f, 1.0f);
        float _1220 = select((_1184 < linearStart), 0.0f, 1.0f);
        _1283 = (((((contrast * _1182) + madLinearStartContrastFactor) * ((1.0f - _1218) - _1208)) + (((pow(_1189, toe))*_1208) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1182) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1218));
        _1284 = (((((contrast * _1183) + madLinearStartContrastFactor) * ((1.0f - _1219) - _1210)) + (((pow(_1195, toe))*_1210) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1183) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1219));
        _1285 = (((((contrast * _1184) + madLinearStartContrastFactor) * ((1.0f - _1220) - _1212)) + (((pow(_1201, toe))*_1212) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _1184) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1220));
        _1286 = 0.0f;
        _1287 = 0.0f;
        _1288 = 0.0f;
        _1289 = 0.0f;
        _1290 = 0.0f;
        _1291 = 1.0f;
      } while (false);
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _1315 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1318 = ComputeResultSRV[0].computeAlpha;
    float _1321 = ((1.0f - _1315) + (_1315 * _1318)) * cbRadialColor.w;
    if (!(_1321 == 0.0f)) {
      float _1328 = screenInverseSize.x * SV_Position.x;
      float _1329 = screenInverseSize.y * SV_Position.y;
      float _1331 = (-0.5f - cbRadialScreenPos.x) + _1328;
      float _1333 = (-0.5f - cbRadialScreenPos.y) + _1329;
      float _1336 = select((_1331 < 0.0f), (1.0f - _1328), _1328);
      float _1339 = select((_1333 < 0.0f), (1.0f - _1329), _1329);
      float _1344 = rsqrt(dot(float2(_1331, _1333), float2(_1331, _1333))) * cbRadialSharpRange;
      uint _1351 = uint(abs(_1344 * _1333)) + uint(abs(_1344 * _1331));
      uint _1355 = ((_1351 ^ 61) ^ ((uint)(_1351) >> 16)) * 9;
      uint _1358 = (((uint)(_1355) >> 4) ^ _1355) * 668265261;
      float _1363 = select(((cbRadialBlurFlags & 1) != 0), (float((uint)((int)(((uint)(_1358) >> 15) ^ _1358))) * 2.3283064365386963e-10f), 1.0f);
      float _1369 = 1.0f / max(1.0f, sqrt((_1331 * _1331) + (_1333 * _1333)));
      float _1370 = cbRadialBlurPower * -0.0011111111380159855f;
      float _1379 = ((((_1370 * _1336) * _1363) * _1369) + 1.0f) * _1331;
      float _1380 = ((((_1370 * _1339) * _1363) * _1369) + 1.0f) * _1333;
      float _1381 = cbRadialBlurPower * -0.002222222276031971f;
      float _1390 = ((((_1381 * _1336) * _1363) * _1369) + 1.0f) * _1331;
      float _1391 = ((((_1381 * _1339) * _1363) * _1369) + 1.0f) * _1333;
      float _1392 = cbRadialBlurPower * -0.0033333334140479565f;
      float _1401 = ((((_1392 * _1336) * _1363) * _1369) + 1.0f) * _1331;
      float _1402 = ((((_1392 * _1339) * _1363) * _1369) + 1.0f) * _1333;
      float _1403 = cbRadialBlurPower * -0.004444444552063942f;
      float _1412 = ((((_1403 * _1336) * _1363) * _1369) + 1.0f) * _1331;
      float _1413 = ((((_1403 * _1339) * _1363) * _1369) + 1.0f) * _1333;
      float _1414 = cbRadialBlurPower * -0.0055555556900799274f;
      float _1423 = ((((_1414 * _1336) * _1363) * _1369) + 1.0f) * _1331;
      float _1424 = ((((_1414 * _1339) * _1363) * _1369) + 1.0f) * _1333;
      float _1425 = cbRadialBlurPower * -0.006666666828095913f;
      float _1434 = ((((_1425 * _1336) * _1363) * _1369) + 1.0f) * _1331;
      float _1435 = ((((_1425 * _1339) * _1363) * _1369) + 1.0f) * _1333;
      float _1436 = cbRadialBlurPower * -0.007777777966111898f;
      float _1445 = ((((_1436 * _1336) * _1363) * _1369) + 1.0f) * _1331;
      float _1446 = ((((_1436 * _1339) * _1363) * _1369) + 1.0f) * _1333;
      float _1447 = cbRadialBlurPower * -0.008888889104127884f;
      float _1456 = ((((_1447 * _1336) * _1363) * _1369) + 1.0f) * _1331;
      float _1457 = ((((_1447 * _1339) * _1363) * _1369) + 1.0f) * _1333;
      float _1458 = cbRadialBlurPower * -0.009999999776482582f;
      float _1467 = ((((_1458 * _1336) * _1363) * _1369) + 1.0f) * _1331;
      float _1468 = ((((_1458 * _1339) * _1363) * _1369) + 1.0f) * _1333;
      float _1469 = Exposure * 0.10000000149011612f;
      float _1470 = _1469 * cbRadialColor.x;
      float _1471 = _1469 * cbRadialColor.y;
      float _1472 = _1469 * cbRadialColor.z;
      float _1487 = (_1283 * 0.10000000149011612f) * cbRadialColor.x;
      float _1489 = (_1284 * 0.10000000149011612f) * cbRadialColor.y;
      float _1491 = (_1285 * 0.10000000149011612f) * cbRadialColor.z;
      do {
        if (_37) {
          float _1493 = _1379 + cbRadialScreenPos.x;
          float _1494 = _1380 + cbRadialScreenPos.y;
          float _1498 = ((dot(float2(_1493, _1494), float2(_1493, _1494)) * _1286) + 1.0f) * _1291;
          float4 _1503 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1498 * _1493) + 0.5f), ((_1498 * _1494) + 0.5f)), 0.0f);
          float _1507 = _1390 + cbRadialScreenPos.x;
          float _1508 = _1391 + cbRadialScreenPos.y;
          float _1512 = ((dot(float2(_1507, _1508), float2(_1507, _1508)) * _1286) + 1.0f) * _1291;
          float4 _1517 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1512 * _1507) + 0.5f), ((_1512 * _1508) + 0.5f)), 0.0f);
          float _1524 = _1401 + cbRadialScreenPos.x;
          float _1525 = _1402 + cbRadialScreenPos.y;
          float _1528 = (dot(float2(_1524, _1525), float2(_1524, _1525)) * _1286) + 1.0f;
          float4 _1535 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1524 * _1291) * _1528) + 0.5f), (((_1525 * _1291) * _1528) + 0.5f)), 0.0f);
          float _1542 = _1412 + cbRadialScreenPos.x;
          float _1543 = _1413 + cbRadialScreenPos.y;
          float _1546 = (dot(float2(_1542, _1543), float2(_1542, _1543)) * _1286) + 1.0f;
          float4 _1553 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1542 * _1291) * _1546) + 0.5f), (((_1543 * _1291) * _1546) + 0.5f)), 0.0f);
          float _1560 = _1423 + cbRadialScreenPos.x;
          float _1561 = _1424 + cbRadialScreenPos.y;
          float _1564 = (dot(float2(_1560, _1561), float2(_1560, _1561)) * _1286) + 1.0f;
          float4 _1571 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1560 * _1291) * _1564) + 0.5f), (((_1561 * _1291) * _1564) + 0.5f)), 0.0f);
          float _1578 = _1434 + cbRadialScreenPos.x;
          float _1579 = _1435 + cbRadialScreenPos.y;
          float _1582 = (dot(float2(_1578, _1579), float2(_1578, _1579)) * _1286) + 1.0f;
          float4 _1589 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1578 * _1291) * _1582) + 0.5f), (((_1579 * _1291) * _1582) + 0.5f)), 0.0f);
          float _1596 = _1445 + cbRadialScreenPos.x;
          float _1597 = _1446 + cbRadialScreenPos.y;
          float _1600 = (dot(float2(_1596, _1597), float2(_1596, _1597)) * _1286) + 1.0f;
          float4 _1607 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1596 * _1291) * _1600) + 0.5f), (((_1597 * _1291) * _1600) + 0.5f)), 0.0f);
          float _1614 = _1456 + cbRadialScreenPos.x;
          float _1615 = _1457 + cbRadialScreenPos.y;
          float _1618 = (dot(float2(_1614, _1615), float2(_1614, _1615)) * _1286) + 1.0f;
          float4 _1625 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1614 * _1291) * _1618) + 0.5f), (((_1615 * _1291) * _1618) + 0.5f)), 0.0f);
          float _1632 = _1467 + cbRadialScreenPos.x;
          float _1633 = _1468 + cbRadialScreenPos.y;
          float _1636 = (dot(float2(_1632, _1633), float2(_1632, _1633)) * _1286) + 1.0f;
          float4 _1643 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1632 * _1291) * _1636) + 0.5f), (((_1633 * _1291) * _1636) + 0.5f)), 0.0f);
          float _1650 = _1470 * ((((((((_1517.x + _1503.x) + _1535.x) + _1553.x) + _1571.x) + _1589.x) + _1607.x) + _1625.x) + _1643.x);
          float _1651 = _1471 * ((((((((_1517.y + _1503.y) + _1535.y) + _1553.y) + _1571.y) + _1589.y) + _1607.y) + _1625.y) + _1643.y);
          float _1652 = _1472 * ((((((((_1517.z + _1503.z) + _1535.z) + _1553.z) + _1571.z) + _1589.z) + _1607.z) + _1625.z) + _1643.z);
          float _1653 = _1650 * invLinearBegin;
          float _1659 = _1651 * invLinearBegin;
          float _1665 = _1652 * invLinearBegin;
          float _1672 = select((_1650 >= linearBegin), 0.0f, (1.0f - ((_1653 * _1653) * (3.0f - (_1653 * 2.0f)))));
          float _1674 = select((_1651 >= linearBegin), 0.0f, (1.0f - ((_1659 * _1659) * (3.0f - (_1659 * 2.0f)))));
          float _1676 = select((_1652 >= linearBegin), 0.0f, (1.0f - ((_1665 * _1665) * (3.0f - (_1665 * 2.0f)))));
          float _1680 = select((_1650 < linearStart), 0.0f, 1.0f);
          float _1681 = select((_1651 < linearStart), 0.0f, 1.0f);
          float _1682 = select((_1652 < linearStart), 0.0f, 1.0f);
          _2254 = (((((_1672 * (pow(_1653, toe))) * linearBegin) + _1487) + (((contrast * _1650) + madLinearStartContrastFactor) * ((1.0f - _1680) - _1672))) + ((maxNit - (exp2((contrastFactor * _1650) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1680));
          _2255 = ((((((pow(_1659, toe))*_1674) * linearBegin) + _1489) + (((contrast * _1651) + madLinearStartContrastFactor) * ((1.0f - _1681) - _1674))) + ((maxNit - (exp2((contrastFactor * _1651) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1681));
          _2256 = ((((((pow(_1665, toe))*_1676) * linearBegin) + _1491) + (((contrast * _1652) + madLinearStartContrastFactor) * ((1.0f - _1682) - _1676))) + ((maxNit - (exp2((contrastFactor * _1652) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1682));
        } else {
          float _1741 = cbRadialScreenPos.x + 0.5f;
          float _1742 = _1741 + _1379;
          float _1743 = cbRadialScreenPos.y + 0.5f;
          float _1744 = _1743 + _1380;
          float _1745 = _1741 + _1390;
          float _1746 = _1743 + _1391;
          float _1747 = _1741 + _1401;
          float _1748 = _1743 + _1402;
          float _1749 = _1741 + _1412;
          float _1750 = _1743 + _1413;
          float _1751 = _1741 + _1423;
          float _1752 = _1743 + _1424;
          float _1753 = _1741 + _1434;
          float _1754 = _1743 + _1435;
          float _1755 = _1741 + _1445;
          float _1756 = _1743 + _1446;
          float _1757 = _1741 + _1456;
          float _1758 = _1743 + _1457;
          float _1759 = _1741 + _1467;
          float _1760 = _1743 + _1468;
          if (_39) {
            float _1764 = (_1742 * 2.0f) + -1.0f;
            float _1768 = sqrt((_1764 * _1764) + 1.0f);
            float _1769 = 1.0f / _1768;
            float _1772 = (_1768 * _1289) * (_1769 + _1287);
            float _1776 = _1290 * 0.5f;
            float4 _1784 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1776 * _1772) * _1764) + 0.5f), ((((_1776 * (((_1769 + -1.0f) * _1288) + 1.0f)) * _1772) * ((_1744 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _1790 = (_1745 * 2.0f) + -1.0f;
            float _1794 = sqrt((_1790 * _1790) + 1.0f);
            float _1795 = 1.0f / _1794;
            float _1798 = (_1794 * _1289) * (_1795 + _1287);
            float4 _1809 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1776 * _1798) * _1790) + 0.5f), ((((_1776 * (((_1795 + -1.0f) * _1288) + 1.0f)) * _1798) * ((_1746 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _1818 = (_1747 * 2.0f) + -1.0f;
            float _1822 = sqrt((_1818 * _1818) + 1.0f);
            float _1823 = 1.0f / _1822;
            float _1826 = (_1822 * _1289) * (_1823 + _1287);
            float4 _1837 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1776 * _1818) * _1826) + 0.5f), ((((_1776 * ((_1748 * 2.0f) + -1.0f)) * (((_1823 + -1.0f) * _1288) + 1.0f)) * _1826) + 0.5f)), 0.0f);
            float _1846 = (_1749 * 2.0f) + -1.0f;
            float _1850 = sqrt((_1846 * _1846) + 1.0f);
            float _1851 = 1.0f / _1850;
            float _1854 = (_1850 * _1289) * (_1851 + _1287);
            float4 _1865 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1776 * _1846) * _1854) + 0.5f), ((((_1776 * ((_1750 * 2.0f) + -1.0f)) * (((_1851 + -1.0f) * _1288) + 1.0f)) * _1854) + 0.5f)), 0.0f);
            float _1874 = (_1751 * 2.0f) + -1.0f;
            float _1878 = sqrt((_1874 * _1874) + 1.0f);
            float _1879 = 1.0f / _1878;
            float _1882 = (_1878 * _1289) * (_1879 + _1287);
            float4 _1893 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1776 * _1874) * _1882) + 0.5f), ((((_1776 * ((_1752 * 2.0f) + -1.0f)) * (((_1879 + -1.0f) * _1288) + 1.0f)) * _1882) + 0.5f)), 0.0f);
            float _1902 = (_1753 * 2.0f) + -1.0f;
            float _1906 = sqrt((_1902 * _1902) + 1.0f);
            float _1907 = 1.0f / _1906;
            float _1910 = (_1906 * _1289) * (_1907 + _1287);
            float4 _1921 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1776 * _1902) * _1910) + 0.5f), ((((_1776 * ((_1754 * 2.0f) + -1.0f)) * (((_1907 + -1.0f) * _1288) + 1.0f)) * _1910) + 0.5f)), 0.0f);
            float _1930 = (_1755 * 2.0f) + -1.0f;
            float _1934 = sqrt((_1930 * _1930) + 1.0f);
            float _1935 = 1.0f / _1934;
            float _1938 = (_1934 * _1289) * (_1935 + _1287);
            float4 _1949 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1776 * _1930) * _1938) + 0.5f), ((((_1776 * ((_1756 * 2.0f) + -1.0f)) * (((_1935 + -1.0f) * _1288) + 1.0f)) * _1938) + 0.5f)), 0.0f);
            float _1958 = (_1757 * 2.0f) + -1.0f;
            float _1962 = sqrt((_1958 * _1958) + 1.0f);
            float _1963 = 1.0f / _1962;
            float _1966 = (_1962 * _1289) * (_1963 + _1287);
            float4 _1977 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1776 * _1958) * _1966) + 0.5f), ((((_1776 * ((_1758 * 2.0f) + -1.0f)) * (((_1963 + -1.0f) * _1288) + 1.0f)) * _1966) + 0.5f)), 0.0f);
            float _1986 = (_1759 * 2.0f) + -1.0f;
            float _1990 = sqrt((_1986 * _1986) + 1.0f);
            float _1991 = 1.0f / _1990;
            float _1994 = (_1990 * _1289) * (_1991 + _1287);
            float4 _2005 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1776 * _1986) * _1994) + 0.5f), ((((_1776 * ((_1760 * 2.0f) + -1.0f)) * (((_1991 + -1.0f) * _1288) + 1.0f)) * _1994) + 0.5f)), 0.0f);
            float _2012 = _1470 * ((((((((_1809.x + _1784.x) + _1837.x) + _1865.x) + _1893.x) + _1921.x) + _1949.x) + _1977.x) + _2005.x);
            float _2013 = _1471 * ((((((((_1809.y + _1784.y) + _1837.y) + _1865.y) + _1893.y) + _1921.y) + _1949.y) + _1977.y) + _2005.y);
            float _2014 = _1472 * ((((((((_1809.z + _1784.z) + _1837.z) + _1865.z) + _1893.z) + _1921.z) + _1949.z) + _1977.z) + _2005.z);
            float _2015 = _2012 * invLinearBegin;
            float _2021 = _2013 * invLinearBegin;
            float _2027 = _2014 * invLinearBegin;
            float _2034 = select((_2012 >= linearBegin), 0.0f, (1.0f - ((_2015 * _2015) * (3.0f - (_2015 * 2.0f)))));
            float _2036 = select((_2013 >= linearBegin), 0.0f, (1.0f - ((_2021 * _2021) * (3.0f - (_2021 * 2.0f)))));
            float _2038 = select((_2014 >= linearBegin), 0.0f, (1.0f - ((_2027 * _2027) * (3.0f - (_2027 * 2.0f)))));
            float _2042 = select((_2012 < linearStart), 0.0f, 1.0f);
            float _2043 = select((_2013 < linearStart), 0.0f, 1.0f);
            float _2044 = select((_2014 < linearStart), 0.0f, 1.0f);
            _2254 = (((((_2034 * (pow(_2015, toe))) * linearBegin) + _1487) + (((contrast * _2012) + madLinearStartContrastFactor) * ((1.0f - _2042) - _2034))) + ((maxNit - (exp2((contrastFactor * _2012) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2042));
            _2255 = ((((((pow(_2021, toe))*_2036) * linearBegin) + _1489) + (((contrast * _2013) + madLinearStartContrastFactor) * ((1.0f - _2043) - _2036))) + ((maxNit - (exp2((contrastFactor * _2013) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2043));
            _2256 = ((((((pow(_2027, toe))*_2038) * linearBegin) + _1491) + (((contrast * _2014) + madLinearStartContrastFactor) * ((1.0f - _2044) - _2038))) + ((maxNit - (exp2((contrastFactor * _2014) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2044));
          } else {
            float4 _2103 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1742, _1744), 0.0f);
            float4 _2107 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1745, _1746), 0.0f);
            float4 _2114 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1747, _1748), 0.0f);
            float4 _2121 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1749, _1750), 0.0f);
            float4 _2128 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1751, _1752), 0.0f);
            float4 _2135 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1753, _1754), 0.0f);
            float4 _2142 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1755, _1756), 0.0f);
            float4 _2149 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1757, _1758), 0.0f);
            float4 _2156 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1759, _1760), 0.0f);
            float _2163 = _1470 * ((((((((_2107.x + _2103.x) + _2114.x) + _2121.x) + _2128.x) + _2135.x) + _2142.x) + _2149.x) + _2156.x);
            float _2164 = _1471 * ((((((((_2107.y + _2103.y) + _2114.y) + _2121.y) + _2128.y) + _2135.y) + _2142.y) + _2149.y) + _2156.y);
            float _2165 = _1472 * ((((((((_2107.z + _2103.z) + _2114.z) + _2121.z) + _2128.z) + _2135.z) + _2142.z) + _2149.z) + _2156.z);
            float _2166 = _2163 * invLinearBegin;
            float _2172 = _2164 * invLinearBegin;
            float _2178 = _2165 * invLinearBegin;
            float _2185 = select((_2163 >= linearBegin), 0.0f, (1.0f - ((_2166 * _2166) * (3.0f - (_2166 * 2.0f)))));
            float _2187 = select((_2164 >= linearBegin), 0.0f, (1.0f - ((_2172 * _2172) * (3.0f - (_2172 * 2.0f)))));
            float _2189 = select((_2165 >= linearBegin), 0.0f, (1.0f - ((_2178 * _2178) * (3.0f - (_2178 * 2.0f)))));
            float _2193 = select((_2163 < linearStart), 0.0f, 1.0f);
            float _2194 = select((_2164 < linearStart), 0.0f, 1.0f);
            float _2195 = select((_2165 < linearStart), 0.0f, 1.0f);
            _2254 = (((((_2185 * (pow(_2166, toe))) * linearBegin) + _1487) + (((contrast * _2163) + madLinearStartContrastFactor) * ((1.0f - _2193) - _2185))) + ((maxNit - (exp2((contrastFactor * _2163) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2193));
            _2255 = ((((((pow(_2172, toe))*_2187) * linearBegin) + _1489) + (((contrast * _2164) + madLinearStartContrastFactor) * ((1.0f - _2194) - _2187))) + ((maxNit - (exp2((contrastFactor * _2164) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2194));
            _2256 = ((((((pow(_2178, toe))*_2189) * linearBegin) + _1491) + (((contrast * _2165) + madLinearStartContrastFactor) * ((1.0f - _2195) - _2189))) + ((maxNit - (exp2((contrastFactor * _2165) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2195));
          }
        }
        do {
          if (cbRadialMaskRate.x > 0.0f) {
            float _2265 = saturate((sqrt((_1331 * _1331) + (_1333 * _1333)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
            float _2271 = (((_2265 * _2265) * cbRadialMaskRate.x) * (3.0f - (_2265 * 2.0f))) + cbRadialMaskRate.y;
            _2282 = ((_2271 * (_2254 - _1283)) + _1283);
            _2283 = ((_2271 * (_2255 - _1284)) + _1284);
            _2284 = ((_2271 * (_2256 - _1285)) + _1285);
          } else {
            _2282 = _2254;
            _2283 = _2255;
            _2284 = _2256;
          }
          _2295 = (lerp(_1283, _2282, _1321));
          _2296 = (lerp(_1284, _2283, _1321));
          _2297 = (lerp(_1285, _2284, _1321));
        } while (false);
      } while (false);
    } else {
      _2295 = _1283;
      _2296 = _1284;
      _2297 = _1285;
    }
  } else {
    _2295 = _1283;
    _2296 = _1284;
    _2297 = _1285;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _2321 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
    float _2323 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
    float _2327 = frac(frac(dot(float2(_2321, _2323), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_2327 < fNoiseDensity) {
        int _2332 = (uint)(uint(_2323 * _2321)) ^ 12345391;
        uint _2333 = _2332 * 3635641;
        _2341 = (float((uint)((int)((((uint)(_2333) >> 26) | ((uint)(_2332 * 232681024))) ^ _2333))) * 2.3283064365386963e-10f);
      } else {
        _2341 = 0.0f;
      }
      float _2343 = frac(_2327 * 757.4846801757812f);
      do {
        if (_2343 < fNoiseDensity) {
          int _2347 = asint(_2343) ^ 12345391;
          uint _2348 = _2347 * 3635641;
          _2357 = ((float((uint)((int)((((uint)(_2348) >> 26) | ((uint)(_2347 * 232681024))) ^ _2348))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _2357 = 0.0f;
        }
        float _2359 = frac(_2343 * 757.4846801757812f);
        do {
          if (_2359 < fNoiseDensity) {
            int _2363 = asint(_2359) ^ 12345391;
            uint _2364 = _2363 * 3635641;
            _2373 = ((float((uint)((int)((((uint)(_2364) >> 26) | ((uint)(_2363 * 232681024))) ^ _2364))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _2373 = 0.0f;
          }
          float _2374 = _2341 * fNoisePower.x;
          float _2375 = _2373 * fNoisePower.y;
          float _2376 = _2357 * fNoisePower.y;
          float _2387 = exp2(log2(1.0f - saturate(dot(float3(_2295, _2296, _2297), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _2398 = ((_2387 * (mad(_2376, 1.4019999504089355f, _2374) - _2295)) + _2295);
          _2399 = ((_2387 * (mad(_2376, -0.7139999866485596f, mad(_2375, -0.3440000116825104f, _2374)) - _2296)) + _2296);
          _2400 = ((_2387 * (mad(_2375, 1.7719999551773071f, _2374) - _2297)) + _2297);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2398 = _2295;
    _2399 = _2296;
    _2400 = _2297;
  }
#if 1
  ApplyColorGrading(
      _2398, _2399, _2400,
      _2611, _2612, _2613,
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
    float _2425 = max(max(_2398, _2399), _2400);
    bool _2426 = (_2425 > 1.0f);
    do {
      if (_2426) {
        _2432 = (_2398 / _2425);
        _2433 = (_2399 / _2425);
        _2434 = (_2400 / _2425);
      } else {
        _2432 = _2398;
        _2433 = _2399;
        _2434 = _2400;
      }
      float _2435 = fTextureInverseSize * 0.5f;
      do {
        [branch]
        if (!(!(_2432 <= 0.0031308000907301903f))) {
          _2446 = (_2432 * 12.920000076293945f);
        } else {
          _2446 = (((pow(_2432, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          [branch]
          if (!(!(_2433 <= 0.0031308000907301903f))) {
            _2457 = (_2433 * 12.920000076293945f);
          } else {
            _2457 = (((pow(_2433, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            [branch]
            if (!(!(_2434 <= 0.0031308000907301903f))) {
              _2468 = (_2434 * 12.920000076293945f);
            } else {
              _2468 = (((pow(_2434, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            float _2469 = 1.0f - fTextureInverseSize;
            float _2473 = (_2446 * _2469) + _2435;
            float _2474 = (_2457 * _2469) + _2435;
            float _2475 = (_2468 * _2469) + _2435;
            float4 _2476 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2473, _2474, _2475), 0.0f);
            do {
              [branch]
              if (fTextureBlendRate > 0.0f) {
                float4 _2482 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2473, _2474, _2475), 0.0f);
                float _2492 = ((_2482.x - _2476.x) * fTextureBlendRate) + _2476.x;
                float _2493 = ((_2482.y - _2476.y) * fTextureBlendRate) + _2476.y;
                float _2494 = ((_2482.z - _2476.z) * fTextureBlendRate) + _2476.z;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    [branch]
                    if (!(!(_2492 <= 0.0031308000907301903f))) {
                      _2507 = (_2492 * 12.920000076293945f);
                    } else {
                      _2507 = (((pow(_2492, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_2493 <= 0.0031308000907301903f))) {
                        _2518 = (_2493 * 12.920000076293945f);
                      } else {
                        _2518 = (((pow(_2493, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_2494 <= 0.0031308000907301903f))) {
                          _2529 = (_2494 * 12.920000076293945f);
                        } else {
                          _2529 = (((pow(_2494, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _2530 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2507, _2518, _2529), 0.0f);
                        _2591 = (lerp(_2492, _2530.x, fTextureBlendRate2));
                        _2592 = (lerp(_2493, _2530.y, fTextureBlendRate2));
                        _2593 = (lerp(_2494, _2530.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _2591 = _2492;
                  _2592 = _2493;
                  _2593 = _2494;
                }
              } else {
                do {
                  [branch]
                  if (!(!(_2476.x <= 0.0031308000907301903f))) {
                    _2554 = (_2476.x * 12.920000076293945f);
                  } else {
                    _2554 = (((pow(_2476.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  }
                  do {
                    [branch]
                    if (!(!(_2476.y <= 0.0031308000907301903f))) {
                      _2565 = (_2476.y * 12.920000076293945f);
                    } else {
                      _2565 = (((pow(_2476.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_2476.z <= 0.0031308000907301903f))) {
                        _2576 = (_2476.z * 12.920000076293945f);
                      } else {
                        _2576 = (((pow(_2476.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      float4 _2577 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2554, _2565, _2576), 0.0f);
                      _2591 = (lerp(_2476.x, _2577.x, fTextureBlendRate2));
                      _2592 = (lerp(_2476.y, _2577.y, fTextureBlendRate2));
                      _2593 = (lerp(_2476.z, _2577.z, fTextureBlendRate2));
                    } while (false);
                  } while (false);
                } while (false);
              }
              float _2597 = mad(_2593, (fColorMatrix[2].x), mad(_2592, (fColorMatrix[1].x), (_2591 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
              float _2601 = mad(_2593, (fColorMatrix[2].y), mad(_2592, (fColorMatrix[1].y), (_2591 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
              float _2605 = mad(_2593, (fColorMatrix[2].z), mad(_2592, (fColorMatrix[1].z), (_2591 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
              if (_2426) {
                _2611 = (_2597 * _2425);
                _2612 = (_2601 * _2425);
                _2613 = (_2605 * _2425);
              } else {
                _2611 = _2597;
                _2612 = _2601;
                _2613 = _2605;
              }
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2611 = _2398;
    _2612 = _2399;
    _2613 = _2400;
  }
#endif
  if (!((cPassEnabled & 8) == 0)) {
    _2648 = saturate(((cvdR.x * _2611) + (cvdR.y * _2612)) + (cvdR.z * _2613));
    _2649 = saturate(((cvdG.x * _2611) + (cvdG.y * _2612)) + (cvdG.z * _2613));
    _2650 = saturate(((cvdB.x * _2611) + (cvdB.y * _2612)) + (cvdB.z * _2613));
  } else {
    _2648 = _2611;
    _2649 = _2612;
    _2650 = _2613;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2665 = screenInverseSize.x * SV_Position.x;
    float _2666 = screenInverseSize.y * SV_Position.y;
    float4 _2667 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2665, _2666), 0.0f);
    float _2672 = _2667.x * ColorParam.x;
    float _2673 = _2667.y * ColorParam.y;
    float _2674 = _2667.z * ColorParam.z;
    float _2676 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2665, _2666), 0.0f);
    float _2681 = (_2667.w * ColorParam.w) * saturate((_2676.x * Levels_Rate) + Levels_Range);
    _2719 = (((select((_2672 < 0.5f), ((_2648 * 2.0f) * _2672), (1.0f - (((1.0f - _2648) * 2.0f) * (1.0f - _2672)))) - _2648) * _2681) + _2648);
    _2720 = (((select((_2673 < 0.5f), ((_2649 * 2.0f) * _2673), (1.0f - (((1.0f - _2649) * 2.0f) * (1.0f - _2673)))) - _2649) * _2681) + _2649);
    _2721 = (((select((_2674 < 0.5f), ((_2650 * 2.0f) * _2674), (1.0f - (((1.0f - _2650) * 2.0f) * (1.0f - _2674)))) - _2650) * _2681) + _2650);
  } else {
    _2719 = _2648;
    _2720 = _2649;
    _2721 = _2650;
  }
  SV_Target.x = _2719;
  SV_Target.y = _2720;
  SV_Target.z = _2721;
  SV_Target.w = 0.0f;

#if 1
  SV_Target.rgb = ApplyUserGrading(SV_Target.rgb);
#endif

  return SV_Target;
}
