#define SHADER_HASH 0x30D8372F
#include "../tonemap.hlsli"

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
  uint renderOutputId : packoffset(c032.z);
  uint SceneInfo_Reserve : packoffset(c032.w);
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

cbuffer LensDistortionParam : register(b2) {
  float fDistortionCoef : packoffset(c000.x);
  float fRefraction : packoffset(c000.y);
  uint aberrationEnable : packoffset(c000.z);
  uint distortionType : packoffset(c000.w);
  float fCorrectCoef : packoffset(c001.x);
  uint reserve1 : packoffset(c001.y);
  uint reserve2 : packoffset(c001.z);
  uint reserve3 : packoffset(c001.w);
};

cbuffer PaniniProjectionParam : register(b3) {
  float4 fOptimizedParam : packoffset(c000.x);
};

cbuffer RadialBlurRenderParam : register(b4) {
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

cbuffer FilmGrainParam : register(b5) {
  float2 fNoisePower : packoffset(c000.x);
  float2 fNoiseUVOffset : packoffset(c000.z);
  float fNoiseDensity : packoffset(c001.x);
  float fNoiseContrast : packoffset(c001.y);
  float fBlendRate : packoffset(c001.z);
  float fReverseNoiseSize : packoffset(c001.w);
};

cbuffer ColorCorrectTexture : register(b6) {
  float fTextureSize : packoffset(c000.x);
  float fTextureBlendRate : packoffset(c000.y);
  float fTextureBlendRate2 : packoffset(c000.z);
  float fTextureInverseSize : packoffset(c000.w);
  float4 fColorMatrix[4] : packoffset(c001.x);
};

cbuffer ColorDeficientTable : register(b7) {
  float4 cvdR : packoffset(c000.x);
  float4 cvdG : packoffset(c001.x);
  float4 cvdB : packoffset(c002.x);
};

cbuffer ImagePlaneParam : register(b8) {
  float4 ColorParam : packoffset(c000.x);
  float Levels_Rate : packoffset(c001.x);
  float Levels_Range : packoffset(c001.y);
  uint Blend_Type : packoffset(c001.z);
};

cbuffer CBControl : register(b9) {
  uint cPassEnabled : packoffset(c000.x);
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
  bool _27 = ((cPassEnabled & 1) != 0);
  bool _31 = _27 && (bool)(distortionType == 0);
  bool _33 = _27 && (bool)(distortionType == 1);
  float _465;
  float _466;
  float _467;
  float _468;
  float _469;
  float _470;
  float _471;
  float _472;
  float _473;
  float _1435;
  float _1436;
  float _1437;
  float _1463;
  float _1464;
  float _1465;
  float _1476;
  float _1477;
  float _1478;
  float _1520;
  float _1536;
  float _1552;
  float _1577;
  float _1578;
  float _1579;
  float _1611;
  float _1612;
  float _1613;
  float _1625;
  float _1636;
  float _1647;
  float _1686;
  float _1697;
  float _1708;
  float _1733;
  float _1744;
  float _1755;
  float _1770;
  float _1771;
  float _1772;
  float _1790;
  float _1791;
  float _1792;
  float _1827;
  float _1828;
  float _1829;
  float _1898;
  float _1899;
  float _1900;
  if (_31) {
    float _59 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _60 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _61 = dot(float2(_59, _60), float2(_59, _60));
    float _64 = ((_61 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float4 _70 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_64 * _59) + 0.5f), ((_64 * _60) + 0.5f)));
    float _72 = _70.x * Exposure;
    float _73 = invLinearBegin * _72;
    float _80 = select((_72 >= linearBegin), 0.0f, (1.0f - ((_73 * _73) * (3.0f - (_73 * 2.0f)))));
    float _82 = select((_72 < linearStart), 0.0f, 1.0f);
    float _87 = (pow(_73, toe));
    float _90 = ((contrast * _72) + madLinearStartContrastFactor) * ((1.0f - _82) - _80);
    float _96 = (maxNit - (exp2((contrastFactor * _72) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _82;
    if (aberrationEnable == 0) {
      float _100 = _70.y * Exposure;
      float _101 = _70.z * Exposure;
      float _102 = invLinearBegin * _100;
      float _108 = invLinearBegin * _101;
      float _115 = select((_100 >= linearBegin), 0.0f, (1.0f - ((_102 * _102) * (3.0f - (_102 * 2.0f)))));
      float _117 = select((_101 >= linearBegin), 0.0f, (1.0f - ((_108 * _108) * (3.0f - (_108 * 2.0f)))));
      float _120 = select((_100 < linearStart), 0.0f, 1.0f);
      float _121 = select((_101 < linearStart), 0.0f, 1.0f);
      _465 = ((_90 + ((_87 * _80) * linearBegin)) + _96);
      _466 = (((((contrast * _100) + madLinearStartContrastFactor) * ((1.0f - _120) - _115)) + (((pow(_102, toe))*_115) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _100) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _120));
      _467 = (((((contrast * _101) + madLinearStartContrastFactor) * ((1.0f - _121) - _117)) + (((pow(_108, toe))*_117) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _101) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _121));
      _468 = fDistortionCoef;
      _469 = 0.0f;
      _470 = 0.0f;
      _471 = 0.0f;
      _472 = 0.0f;
      _473 = fCorrectCoef;
    } else {
      float _163 = _61 + fRefraction;
      float _165 = (_163 * fDistortionCoef) + 1.0f;
      float _166 = _59 * fCorrectCoef;
      float _168 = _60 * fCorrectCoef;
      float _174 = ((_163 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _183 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_166 * _165) + 0.5f), ((_168 * _165) + 0.5f)));
      float _185 = _183.y * Exposure;
      float _186 = invLinearBegin * _185;
      float _193 = select((_185 >= linearBegin), 0.0f, (1.0f - ((_186 * _186) * (3.0f - (_186 * 2.0f)))));
      float _195 = select((_185 < linearStart), 0.0f, 1.0f);
      float4 _214 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_166 * _174) + 0.5f), ((_168 * _174) + 0.5f)));
      float _216 = _214.z * Exposure;
      float _217 = invLinearBegin * _216;
      float _224 = select((_216 >= linearBegin), 0.0f, (1.0f - ((_217 * _217) * (3.0f - (_217 * 2.0f)))));
      float _226 = select((_216 < linearStart), 0.0f, 1.0f);
      _465 = ((_90 + ((linearBegin * _87) * _80)) + _96);
      _466 = (((((contrast * _185) + madLinearStartContrastFactor) * ((1.0f - _195) - _193)) + ((linearBegin * (pow(_186, toe))) * _193)) + ((maxNit - (exp2((contrastFactor * _185) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _195));
      _467 = (((((contrast * _216) + madLinearStartContrastFactor) * ((1.0f - _226) - _224)) + ((linearBegin * (pow(_217, toe))) * _224)) + ((maxNit - (exp2((contrastFactor * _216) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _226));
      _468 = fDistortionCoef;
      _469 = 0.0f;
      _470 = 0.0f;
      _471 = 0.0f;
      _472 = 0.0f;
      _473 = fCorrectCoef;
    }
  } else {
    if (_33) {
      float _259 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _263 = sqrt((_259 * _259) + 1.0f);
      float _264 = 1.0f / _263;
      float _267 = (_263 * fOptimizedParam.z) * (_264 + fOptimizedParam.x);
      float _271 = fOptimizedParam.w * 0.5f;
      float4 _279 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2((((_271 * _259) * _267) + 0.5f), ((((_271 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_264 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _267) + 0.5f)));
      float _283 = _279.x * Exposure;
      float _284 = _279.y * Exposure;
      float _285 = _279.z * Exposure;
      float _286 = invLinearBegin * _283;
      float _292 = invLinearBegin * _284;
      float _298 = invLinearBegin * _285;
      float _305 = select((_283 >= linearBegin), 0.0f, (1.0f - ((_286 * _286) * (3.0f - (_286 * 2.0f)))));
      float _307 = select((_284 >= linearBegin), 0.0f, (1.0f - ((_292 * _292) * (3.0f - (_292 * 2.0f)))));
      float _309 = select((_285 >= linearBegin), 0.0f, (1.0f - ((_298 * _298) * (3.0f - (_298 * 2.0f)))));
      float _313 = select((_283 < linearStart), 0.0f, 1.0f);
      float _314 = select((_284 < linearStart), 0.0f, 1.0f);
      float _315 = select((_285 < linearStart), 0.0f, 1.0f);
      _465 = (((((contrast * _283) + madLinearStartContrastFactor) * ((1.0f - _313) - _305)) + (((pow(_286, toe))*_305) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _283) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _313));
      _466 = (((((contrast * _284) + madLinearStartContrastFactor) * ((1.0f - _314) - _307)) + (((pow(_292, toe))*_307) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _284) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _314));
      _467 = (((((contrast * _285) + madLinearStartContrastFactor) * ((1.0f - _315) - _309)) + (((pow(_298, toe))*_309) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _285) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _315));
      _468 = 0.0f;
      _469 = fOptimizedParam.x;
      _470 = fOptimizedParam.y;
      _471 = fOptimizedParam.z;
      _472 = fOptimizedParam.w;
      _473 = 1.0f;
    } else {
      float4 _373 = RE_POSTPROCESS_Color.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
      float _377 = _373.x * Exposure;
      float _378 = _373.y * Exposure;
      float _379 = _373.z * Exposure;
      float _380 = invLinearBegin * _377;
      float _386 = invLinearBegin * _378;
      float _392 = invLinearBegin * _379;
      float _399 = select((_377 >= linearBegin), 0.0f, (1.0f - ((_380 * _380) * (3.0f - (_380 * 2.0f)))));
      float _401 = select((_378 >= linearBegin), 0.0f, (1.0f - ((_386 * _386) * (3.0f - (_386 * 2.0f)))));
      float _403 = select((_379 >= linearBegin), 0.0f, (1.0f - ((_392 * _392) * (3.0f - (_392 * 2.0f)))));
      float _407 = select((_377 < linearStart), 0.0f, 1.0f);
      float _408 = select((_378 < linearStart), 0.0f, 1.0f);
      float _409 = select((_379 < linearStart), 0.0f, 1.0f);
      _465 = (((((contrast * _377) + madLinearStartContrastFactor) * ((1.0f - _407) - _399)) + (((pow(_380, toe))*_399) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _377) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _407));
      _466 = (((((contrast * _378) + madLinearStartContrastFactor) * ((1.0f - _408) - _401)) + (((pow(_386, toe))*_401) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _378) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _408));
      _467 = (((((contrast * _379) + madLinearStartContrastFactor) * ((1.0f - _409) - _403)) + (((pow(_392, toe))*_403) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _379) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _409));
      _468 = 0.0f;
      _469 = 0.0f;
      _470 = 0.0f;
      _471 = 0.0f;
      _472 = 0.0f;
      _473 = 1.0f;
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _495 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _498 = ComputeResultSRV[0].computeAlpha;
    float _501 = ((1.0f - _495) + (_498 * _495)) * cbRadialColor.w;
    if (!(_501 == 0.0f)) {
      float _508 = screenInverseSize.x * SV_Position.x;
      float _509 = screenInverseSize.y * SV_Position.y;
      float _511 = (-0.5f - cbRadialScreenPos.x) + _508;
      float _513 = (-0.5f - cbRadialScreenPos.y) + _509;
      float _516 = select((_511 < 0.0f), (1.0f - _508), _508);
      float _519 = select((_513 < 0.0f), (1.0f - _509), _509);
      float _524 = rsqrt(dot(float2(_511, _513), float2(_511, _513))) * cbRadialSharpRange;
      uint _531 = uint(abs(_524 * _513)) + uint(abs(_524 * _511));
      uint _535 = ((_531 ^ 61) ^ ((uint)(_531) >> 16)) * 9;
      uint _538 = (((uint)(_535) >> 4) ^ _535) * 668265261;
      float _543 = select(((cbRadialBlurFlags & 1) != 0), (float((uint)((int)(((uint)(_538) >> 15) ^ _538))) * 2.3283064365386963e-10f), 1.0f);
      float _549 = 1.0f / max(1.0f, sqrt((_511 * _511) + (_513 * _513)));
      float _550 = cbRadialBlurPower * -0.0011111111380159855f;
      float _559 = ((((_550 * _516) * _543) * _549) + 1.0f) * _511;
      float _560 = ((((_550 * _519) * _543) * _549) + 1.0f) * _513;
      float _561 = cbRadialBlurPower * -0.002222222276031971f;
      float _570 = ((((_561 * _516) * _543) * _549) + 1.0f) * _511;
      float _571 = ((((_561 * _519) * _543) * _549) + 1.0f) * _513;
      float _572 = cbRadialBlurPower * -0.0033333334140479565f;
      float _581 = ((((_572 * _516) * _543) * _549) + 1.0f) * _511;
      float _582 = ((((_572 * _519) * _543) * _549) + 1.0f) * _513;
      float _583 = cbRadialBlurPower * -0.004444444552063942f;
      float _592 = ((((_583 * _516) * _543) * _549) + 1.0f) * _511;
      float _593 = ((((_583 * _519) * _543) * _549) + 1.0f) * _513;
      float _594 = cbRadialBlurPower * -0.0055555556900799274f;
      float _603 = ((((_594 * _516) * _543) * _549) + 1.0f) * _511;
      float _604 = ((((_594 * _519) * _543) * _549) + 1.0f) * _513;
      float _605 = cbRadialBlurPower * -0.006666666828095913f;
      float _614 = ((((_605 * _516) * _543) * _549) + 1.0f) * _511;
      float _615 = ((((_605 * _519) * _543) * _549) + 1.0f) * _513;
      float _616 = cbRadialBlurPower * -0.007777777966111898f;
      float _625 = ((((_616 * _516) * _543) * _549) + 1.0f) * _511;
      float _626 = ((((_616 * _519) * _543) * _549) + 1.0f) * _513;
      float _627 = cbRadialBlurPower * -0.008888889104127884f;
      float _636 = ((((_627 * _516) * _543) * _549) + 1.0f) * _511;
      float _637 = ((((_627 * _519) * _543) * _549) + 1.0f) * _513;
      float _638 = cbRadialBlurPower * -0.009999999776482582f;
      float _647 = ((((_638 * _516) * _543) * _549) + 1.0f) * _511;
      float _648 = ((((_638 * _519) * _543) * _549) + 1.0f) * _513;
      float _649 = Exposure * 0.10000000149011612f;
      float _650 = _649 * cbRadialColor.x;
      float _651 = _649 * cbRadialColor.y;
      float _652 = _649 * cbRadialColor.z;
      float _667 = (_465 * 0.10000000149011612f) * cbRadialColor.x;
      float _669 = (_466 * 0.10000000149011612f) * cbRadialColor.y;
      float _671 = (_467 * 0.10000000149011612f) * cbRadialColor.z;
      do {
        if (_31) {
          float _673 = _559 + cbRadialScreenPos.x;
          float _674 = _560 + cbRadialScreenPos.y;
          float _678 = ((dot(float2(_673, _674), float2(_673, _674)) * _468) + 1.0f) * _473;
          float4 _683 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_678 * _673) + 0.5f), ((_678 * _674) + 0.5f)), 0.0f);
          float _687 = _570 + cbRadialScreenPos.x;
          float _688 = _571 + cbRadialScreenPos.y;
          float _691 = (dot(float2(_687, _688), float2(_687, _688)) * _468) + 1.0f;
          float4 _698 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_687 * _473) * _691) + 0.5f), (((_688 * _473) * _691) + 0.5f)), 0.0f);
          float _705 = _581 + cbRadialScreenPos.x;
          float _706 = _582 + cbRadialScreenPos.y;
          float _709 = (dot(float2(_705, _706), float2(_705, _706)) * _468) + 1.0f;
          float4 _716 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_705 * _473) * _709) + 0.5f), (((_706 * _473) * _709) + 0.5f)), 0.0f);
          float _723 = _592 + cbRadialScreenPos.x;
          float _724 = _593 + cbRadialScreenPos.y;
          float _727 = (dot(float2(_723, _724), float2(_723, _724)) * _468) + 1.0f;
          float4 _734 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_723 * _473) * _727) + 0.5f), (((_724 * _473) * _727) + 0.5f)), 0.0f);
          float _741 = _603 + cbRadialScreenPos.x;
          float _742 = _604 + cbRadialScreenPos.y;
          float _745 = (dot(float2(_741, _742), float2(_741, _742)) * _468) + 1.0f;
          float4 _752 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_741 * _473) * _745) + 0.5f), (((_742 * _473) * _745) + 0.5f)), 0.0f);
          float _759 = _614 + cbRadialScreenPos.x;
          float _760 = _615 + cbRadialScreenPos.y;
          float _763 = (dot(float2(_759, _760), float2(_759, _760)) * _468) + 1.0f;
          float4 _770 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_759 * _473) * _763) + 0.5f), (((_760 * _473) * _763) + 0.5f)), 0.0f);
          float _777 = _625 + cbRadialScreenPos.x;
          float _778 = _626 + cbRadialScreenPos.y;
          float _781 = (dot(float2(_777, _778), float2(_777, _778)) * _468) + 1.0f;
          float4 _788 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_777 * _473) * _781) + 0.5f), (((_778 * _473) * _781) + 0.5f)), 0.0f);
          float _795 = _636 + cbRadialScreenPos.x;
          float _796 = _637 + cbRadialScreenPos.y;
          float _799 = (dot(float2(_795, _796), float2(_795, _796)) * _468) + 1.0f;
          float4 _806 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_795 * _473) * _799) + 0.5f), (((_796 * _473) * _799) + 0.5f)), 0.0f);
          float _813 = _647 + cbRadialScreenPos.x;
          float _814 = _648 + cbRadialScreenPos.y;
          float _817 = (dot(float2(_813, _814), float2(_813, _814)) * _468) + 1.0f;
          float4 _824 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_813 * _473) * _817) + 0.5f), (((_814 * _473) * _817) + 0.5f)), 0.0f);
          float _831 = _650 * ((((((((_698.x + _683.x) + _716.x) + _734.x) + _752.x) + _770.x) + _788.x) + _806.x) + _824.x);
          float _832 = _651 * ((((((((_698.y + _683.y) + _716.y) + _734.y) + _752.y) + _770.y) + _788.y) + _806.y) + _824.y);
          float _833 = _652 * ((((((((_698.z + _683.z) + _716.z) + _734.z) + _752.z) + _770.z) + _788.z) + _806.z) + _824.z);
          float _834 = _831 * invLinearBegin;
          float _840 = _832 * invLinearBegin;
          float _846 = _833 * invLinearBegin;
          float _853 = select((_831 >= linearBegin), 0.0f, (1.0f - ((_834 * _834) * (3.0f - (_834 * 2.0f)))));
          float _855 = select((_832 >= linearBegin), 0.0f, (1.0f - ((_840 * _840) * (3.0f - (_840 * 2.0f)))));
          float _857 = select((_833 >= linearBegin), 0.0f, (1.0f - ((_846 * _846) * (3.0f - (_846 * 2.0f)))));
          float _861 = select((_831 < linearStart), 0.0f, 1.0f);
          float _862 = select((_832 < linearStart), 0.0f, 1.0f);
          float _863 = select((_833 < linearStart), 0.0f, 1.0f);
          _1435 = (((((_853 * (pow(_834, toe))) * linearBegin) + _667) + (((contrast * _831) + madLinearStartContrastFactor) * ((1.0f - _861) - _853))) + ((maxNit - (exp2((contrastFactor * _831) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _861));
          _1436 = ((((((pow(_840, toe))*_855) * linearBegin) + _669) + (((contrast * _832) + madLinearStartContrastFactor) * ((1.0f - _862) - _855))) + ((maxNit - (exp2((contrastFactor * _832) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _862));
          _1437 = ((((((pow(_846, toe))*_857) * linearBegin) + _671) + (((contrast * _833) + madLinearStartContrastFactor) * ((1.0f - _863) - _857))) + ((maxNit - (exp2((contrastFactor * _833) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _863));
        } else {
          float _922 = cbRadialScreenPos.x + 0.5f;
          float _923 = _922 + _559;
          float _924 = cbRadialScreenPos.y + 0.5f;
          float _925 = _924 + _560;
          float _926 = _922 + _570;
          float _927 = _924 + _571;
          float _928 = _922 + _581;
          float _929 = _924 + _582;
          float _930 = _922 + _592;
          float _931 = _924 + _593;
          float _932 = _922 + _603;
          float _933 = _924 + _604;
          float _934 = _922 + _614;
          float _935 = _924 + _615;
          float _936 = _922 + _625;
          float _937 = _924 + _626;
          float _938 = _922 + _636;
          float _939 = _924 + _637;
          float _940 = _922 + _647;
          float _941 = _924 + _648;
          if (_33) {
            float _945 = (_923 * 2.0f) + -1.0f;
            float _949 = sqrt((_945 * _945) + 1.0f);
            float _950 = 1.0f / _949;
            float _953 = (_949 * _471) * (_950 + _469);
            float _957 = _472 * 0.5f;
            float4 _965 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_957 * _953) * _945) + 0.5f), ((((_957 * (((_950 + -1.0f) * _470) + 1.0f)) * _953) * ((_925 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _971 = (_926 * 2.0f) + -1.0f;
            float _975 = sqrt((_971 * _971) + 1.0f);
            float _976 = 1.0f / _975;
            float _979 = (_975 * _471) * (_976 + _469);
            float4 _990 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_957 * _971) * _979) + 0.5f), ((((_957 * ((_927 * 2.0f) + -1.0f)) * (((_976 + -1.0f) * _470) + 1.0f)) * _979) + 0.5f)), 0.0f);
            float _999 = (_928 * 2.0f) + -1.0f;
            float _1003 = sqrt((_999 * _999) + 1.0f);
            float _1004 = 1.0f / _1003;
            float _1007 = (_1003 * _471) * (_1004 + _469);
            float4 _1018 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_957 * _999) * _1007) + 0.5f), ((((_957 * ((_929 * 2.0f) + -1.0f)) * (((_1004 + -1.0f) * _470) + 1.0f)) * _1007) + 0.5f)), 0.0f);
            float _1027 = (_930 * 2.0f) + -1.0f;
            float _1031 = sqrt((_1027 * _1027) + 1.0f);
            float _1032 = 1.0f / _1031;
            float _1035 = (_1031 * _471) * (_1032 + _469);
            float4 _1046 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_957 * _1027) * _1035) + 0.5f), ((((_957 * ((_931 * 2.0f) + -1.0f)) * (((_1032 + -1.0f) * _470) + 1.0f)) * _1035) + 0.5f)), 0.0f);
            float _1055 = (_932 * 2.0f) + -1.0f;
            float _1059 = sqrt((_1055 * _1055) + 1.0f);
            float _1060 = 1.0f / _1059;
            float _1063 = (_1059 * _471) * (_1060 + _469);
            float4 _1074 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_957 * _1055) * _1063) + 0.5f), ((((_957 * ((_933 * 2.0f) + -1.0f)) * (((_1060 + -1.0f) * _470) + 1.0f)) * _1063) + 0.5f)), 0.0f);
            float _1083 = (_934 * 2.0f) + -1.0f;
            float _1087 = sqrt((_1083 * _1083) + 1.0f);
            float _1088 = 1.0f / _1087;
            float _1091 = (_1087 * _471) * (_1088 + _469);
            float4 _1102 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_957 * _1083) * _1091) + 0.5f), ((((_957 * ((_935 * 2.0f) + -1.0f)) * (((_1088 + -1.0f) * _470) + 1.0f)) * _1091) + 0.5f)), 0.0f);
            float _1111 = (_936 * 2.0f) + -1.0f;
            float _1115 = sqrt((_1111 * _1111) + 1.0f);
            float _1116 = 1.0f / _1115;
            float _1119 = (_1115 * _471) * (_1116 + _469);
            float4 _1130 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_957 * _1111) * _1119) + 0.5f), ((((_957 * ((_937 * 2.0f) + -1.0f)) * (((_1116 + -1.0f) * _470) + 1.0f)) * _1119) + 0.5f)), 0.0f);
            float _1139 = (_938 * 2.0f) + -1.0f;
            float _1143 = sqrt((_1139 * _1139) + 1.0f);
            float _1144 = 1.0f / _1143;
            float _1147 = (_1143 * _471) * (_1144 + _469);
            float4 _1158 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_957 * _1139) * _1147) + 0.5f), ((((_957 * ((_939 * 2.0f) + -1.0f)) * (((_1144 + -1.0f) * _470) + 1.0f)) * _1147) + 0.5f)), 0.0f);
            float _1167 = (_940 * 2.0f) + -1.0f;
            float _1171 = sqrt((_1167 * _1167) + 1.0f);
            float _1172 = 1.0f / _1171;
            float _1175 = (_1171 * _471) * (_1172 + _469);
            float4 _1186 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_957 * _1167) * _1175) + 0.5f), ((((_957 * ((_941 * 2.0f) + -1.0f)) * (((_1172 + -1.0f) * _470) + 1.0f)) * _1175) + 0.5f)), 0.0f);
            float _1193 = _650 * ((((((((_990.x + _965.x) + _1018.x) + _1046.x) + _1074.x) + _1102.x) + _1130.x) + _1158.x) + _1186.x);
            float _1194 = _651 * ((((((((_990.y + _965.y) + _1018.y) + _1046.y) + _1074.y) + _1102.y) + _1130.y) + _1158.y) + _1186.y);
            float _1195 = _652 * ((((((((_990.z + _965.z) + _1018.z) + _1046.z) + _1074.z) + _1102.z) + _1130.z) + _1158.z) + _1186.z);
            float _1196 = _1193 * invLinearBegin;
            float _1202 = _1194 * invLinearBegin;
            float _1208 = _1195 * invLinearBegin;
            float _1215 = select((_1193 >= linearBegin), 0.0f, (1.0f - ((_1196 * _1196) * (3.0f - (_1196 * 2.0f)))));
            float _1217 = select((_1194 >= linearBegin), 0.0f, (1.0f - ((_1202 * _1202) * (3.0f - (_1202 * 2.0f)))));
            float _1219 = select((_1195 >= linearBegin), 0.0f, (1.0f - ((_1208 * _1208) * (3.0f - (_1208 * 2.0f)))));
            float _1223 = select((_1193 < linearStart), 0.0f, 1.0f);
            float _1224 = select((_1194 < linearStart), 0.0f, 1.0f);
            float _1225 = select((_1195 < linearStart), 0.0f, 1.0f);
            _1435 = (((((_1215 * (pow(_1196, toe))) * linearBegin) + _667) + (((contrast * _1193) + madLinearStartContrastFactor) * ((1.0f - _1223) - _1215))) + ((maxNit - (exp2((contrastFactor * _1193) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1223));
            _1436 = ((((((pow(_1202, toe))*_1217) * linearBegin) + _669) + (((contrast * _1194) + madLinearStartContrastFactor) * ((1.0f - _1224) - _1217))) + ((maxNit - (exp2((contrastFactor * _1194) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1224));
            _1437 = ((((((pow(_1208, toe))*_1219) * linearBegin) + _671) + (((contrast * _1195) + madLinearStartContrastFactor) * ((1.0f - _1225) - _1219))) + ((maxNit - (exp2((contrastFactor * _1195) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1225));
          } else {
            float4 _1284 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_923, _925), 0.0f);
            float4 _1288 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_926, _927), 0.0f);
            float4 _1295 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_928, _929), 0.0f);
            float4 _1302 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_930, _931), 0.0f);
            float4 _1309 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_932, _933), 0.0f);
            float4 _1316 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_934, _935), 0.0f);
            float4 _1323 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_936, _937), 0.0f);
            float4 _1330 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_938, _939), 0.0f);
            float4 _1337 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_940, _941), 0.0f);
            float _1344 = _650 * ((((((((_1288.x + _1284.x) + _1295.x) + _1302.x) + _1309.x) + _1316.x) + _1323.x) + _1330.x) + _1337.x);
            float _1345 = _651 * ((((((((_1288.y + _1284.y) + _1295.y) + _1302.y) + _1309.y) + _1316.y) + _1323.y) + _1330.y) + _1337.y);
            float _1346 = _652 * ((((((((_1288.z + _1284.z) + _1295.z) + _1302.z) + _1309.z) + _1316.z) + _1323.z) + _1330.z) + _1337.z);
            float _1347 = _1344 * invLinearBegin;
            float _1353 = _1345 * invLinearBegin;
            float _1359 = _1346 * invLinearBegin;
            float _1366 = select((_1344 >= linearBegin), 0.0f, (1.0f - ((_1347 * _1347) * (3.0f - (_1347 * 2.0f)))));
            float _1368 = select((_1345 >= linearBegin), 0.0f, (1.0f - ((_1353 * _1353) * (3.0f - (_1353 * 2.0f)))));
            float _1370 = select((_1346 >= linearBegin), 0.0f, (1.0f - ((_1359 * _1359) * (3.0f - (_1359 * 2.0f)))));
            float _1374 = select((_1344 < linearStart), 0.0f, 1.0f);
            float _1375 = select((_1345 < linearStart), 0.0f, 1.0f);
            float _1376 = select((_1346 < linearStart), 0.0f, 1.0f);
            _1435 = (((((_1366 * (pow(_1347, toe))) * linearBegin) + _667) + (((contrast * _1344) + madLinearStartContrastFactor) * ((1.0f - _1374) - _1366))) + ((maxNit - (exp2((contrastFactor * _1344) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1374));
            _1436 = ((((((pow(_1353, toe))*_1368) * linearBegin) + _669) + (((contrast * _1345) + madLinearStartContrastFactor) * ((1.0f - _1375) - _1368))) + ((maxNit - (exp2((contrastFactor * _1345) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1375));
            _1437 = ((((((pow(_1359, toe))*_1370) * linearBegin) + _671) + (((contrast * _1346) + madLinearStartContrastFactor) * ((1.0f - _1376) - _1370))) + ((maxNit - (exp2((contrastFactor * _1346) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1376));
          }
        }
        do {
          if (cbRadialMaskRate.x > 0.0f) {
            float _1446 = saturate((sqrt((_511 * _511) + (_513 * _513)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
            float _1452 = (((_1446 * _1446) * cbRadialMaskRate.x) * (3.0f - (_1446 * 2.0f))) + cbRadialMaskRate.y;
            _1463 = ((_1452 * (_1435 - _465)) + _465);
            _1464 = ((_1452 * (_1436 - _466)) + _466);
            _1465 = ((_1452 * (_1437 - _467)) + _467);
          } else {
            _1463 = _1435;
            _1464 = _1436;
            _1465 = _1437;
          }
          _1476 = (lerp(_465, _1463, _501));
          _1477 = (lerp(_466, _1464, _501));
          _1478 = (lerp(_467, _1465, _501));
        } while (false);
      } while (false);
    } else {
      _1476 = _465;
      _1477 = _466;
      _1478 = _467;
    }
  } else {
    _1476 = _465;
    _1477 = _466;
    _1478 = _467;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _1500 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
    float _1502 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
    float _1506 = frac(frac(dot(float2(_1500, _1502), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_1506 < fNoiseDensity) {
        int _1511 = (uint)(uint(_1502 * _1500)) ^ 12345391;
        uint _1512 = _1511 * 3635641;
        _1520 = (float((uint)((int)((((uint)(_1512) >> 26) | ((uint)(_1511 * 232681024))) ^ _1512))) * 2.3283064365386963e-10f);
      } else {
        _1520 = 0.0f;
      }
      float _1522 = frac(_1506 * 757.4846801757812f);
      do {
        if (_1522 < fNoiseDensity) {
          int _1526 = asint(_1522) ^ 12345391;
          uint _1527 = _1526 * 3635641;
          _1536 = ((float((uint)((int)((((uint)(_1527) >> 26) | ((uint)(_1526 * 232681024))) ^ _1527))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1536 = 0.0f;
        }
        float _1538 = frac(_1522 * 757.4846801757812f);
        do {
          if (_1538 < fNoiseDensity) {
            int _1542 = asint(_1538) ^ 12345391;
            uint _1543 = _1542 * 3635641;
            _1552 = ((float((uint)((int)((((uint)(_1543) >> 26) | ((uint)(_1542 * 232681024))) ^ _1543))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1552 = 0.0f;
          }
          float _1553 = _1520 * fNoisePower.x;
          float _1554 = _1552 * fNoisePower.y;
          float _1555 = _1536 * fNoisePower.y;
          float _1566 = exp2(log2(1.0f - saturate(dot(float3(_1476, _1477, _1478), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1577 = ((_1566 * (mad(_1555, 1.4019999504089355f, _1553) - _1476)) + _1476);
          _1578 = ((_1566 * (mad(_1555, -0.7139999866485596f, mad(_1554, -0.3440000116825104f, _1553)) - _1477)) + _1477);
          _1579 = ((_1566 * (mad(_1554, 1.7719999551773071f, _1553) - _1478)) + _1478);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1577 = _1476;
    _1578 = _1477;
    _1579 = _1478;
  }
#if 1
  ApplyColorGrading(
      _1577, _1578, _1579,
      _1790, _1791, _1792,
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
    float _1604 = max(max(_1577, _1578), _1579);
    bool _1605 = (_1604 > 1.0f);
    do {
      if (_1605) {
        _1611 = (_1577 / _1604);
        _1612 = (_1578 / _1604);
        _1613 = (_1579 / _1604);
      } else {
        _1611 = _1577;
        _1612 = _1578;
        _1613 = _1579;
      }
      float _1614 = fTextureInverseSize * 0.5f;
      do {
        [branch]
        if (!(!(_1611 <= 0.0031308000907301903f))) {
          _1625 = (_1611 * 12.920000076293945f);
        } else {
          _1625 = (((pow(_1611, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          [branch]
          if (!(!(_1612 <= 0.0031308000907301903f))) {
            _1636 = (_1612 * 12.920000076293945f);
          } else {
            _1636 = (((pow(_1612, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            [branch]
            if (!(!(_1613 <= 0.0031308000907301903f))) {
              _1647 = (_1613 * 12.920000076293945f);
            } else {
              _1647 = (((pow(_1613, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            float _1648 = 1.0f - fTextureInverseSize;
            float _1652 = (_1625 * _1648) + _1614;
            float _1653 = (_1636 * _1648) + _1614;
            float _1654 = (_1647 * _1648) + _1614;
            float4 _1655 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1652, _1653, _1654), 0.0f);
            do {
              [branch]
              if (fTextureBlendRate > 0.0f) {
                float4 _1661 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1652, _1653, _1654), 0.0f);
                float _1671 = ((_1661.x - _1655.x) * fTextureBlendRate) + _1655.x;
                float _1672 = ((_1661.y - _1655.y) * fTextureBlendRate) + _1655.y;
                float _1673 = ((_1661.z - _1655.z) * fTextureBlendRate) + _1655.z;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    [branch]
                    if (!(!(_1671 <= 0.0031308000907301903f))) {
                      _1686 = (_1671 * 12.920000076293945f);
                    } else {
                      _1686 = (((pow(_1671, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_1672 <= 0.0031308000907301903f))) {
                        _1697 = (_1672 * 12.920000076293945f);
                      } else {
                        _1697 = (((pow(_1672, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_1673 <= 0.0031308000907301903f))) {
                          _1708 = (_1673 * 12.920000076293945f);
                        } else {
                          _1708 = (((pow(_1673, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _1709 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1686, _1697, _1708), 0.0f);
                        _1770 = (lerp(_1671, _1709.x, fTextureBlendRate2));
                        _1771 = (lerp(_1672, _1709.y, fTextureBlendRate2));
                        _1772 = (lerp(_1673, _1709.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _1770 = _1671;
                  _1771 = _1672;
                  _1772 = _1673;
                }
              } else {
                do {
                  [branch]
                  if (!(!(_1655.x <= 0.0031308000907301903f))) {
                    _1733 = (_1655.x * 12.920000076293945f);
                  } else {
                    _1733 = (((pow(_1655.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  }
                  do {
                    [branch]
                    if (!(!(_1655.y <= 0.0031308000907301903f))) {
                      _1744 = (_1655.y * 12.920000076293945f);
                    } else {
                      _1744 = (((pow(_1655.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_1655.z <= 0.0031308000907301903f))) {
                        _1755 = (_1655.z * 12.920000076293945f);
                      } else {
                        _1755 = (((pow(_1655.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      float4 _1756 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1733, _1744, _1755), 0.0f);
                      _1770 = (lerp(_1655.x, _1756.x, fTextureBlendRate2));
                      _1771 = (lerp(_1655.y, _1756.y, fTextureBlendRate2));
                      _1772 = (lerp(_1655.z, _1756.z, fTextureBlendRate2));
                    } while (false);
                  } while (false);
                } while (false);
              }
              float _1776 = mad(_1772, (fColorMatrix[2].x), mad(_1771, (fColorMatrix[1].x), (_1770 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
              float _1780 = mad(_1772, (fColorMatrix[2].y), mad(_1771, (fColorMatrix[1].y), (_1770 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
              float _1784 = mad(_1772, (fColorMatrix[2].z), mad(_1771, (fColorMatrix[1].z), (_1770 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
              if (_1605) {
                _1790 = (_1776 * _1604);
                _1791 = (_1780 * _1604);
                _1792 = (_1784 * _1604);
              } else {
                _1790 = _1776;
                _1791 = _1780;
                _1792 = _1784;
              }
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1790 = _1577;
    _1791 = _1578;
    _1792 = _1579;
  }
#endif
  if (!((cPassEnabled & 8) == 0)) {
    _1827 = saturate(((cvdR.x * _1790) + (cvdR.y * _1791)) + (cvdR.z * _1792));
    _1828 = saturate(((cvdG.x * _1790) + (cvdG.y * _1791)) + (cvdG.z * _1792));
    _1829 = saturate(((cvdB.x * _1790) + (cvdB.y * _1791)) + (cvdB.z * _1792));
  } else {
    _1827 = _1790;
    _1828 = _1791;
    _1829 = _1792;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _1844 = screenInverseSize.x * SV_Position.x;
    float _1845 = screenInverseSize.y * SV_Position.y;
    float4 _1846 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1844, _1845), 0.0f);
    float _1851 = _1846.x * ColorParam.x;
    float _1852 = _1846.y * ColorParam.y;
    float _1853 = _1846.z * ColorParam.z;
    float _1855 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1844, _1845), 0.0f);
    float _1860 = (_1846.w * ColorParam.w) * saturate((_1855.x * Levels_Rate) + Levels_Range);
    _1898 = (((select((_1851 < 0.5f), ((_1827 * 2.0f) * _1851), (1.0f - (((1.0f - _1827) * 2.0f) * (1.0f - _1851)))) - _1827) * _1860) + _1827);
    _1899 = (((select((_1852 < 0.5f), ((_1828 * 2.0f) * _1852), (1.0f - (((1.0f - _1828) * 2.0f) * (1.0f - _1852)))) - _1828) * _1860) + _1828);
    _1900 = (((select((_1853 < 0.5f), ((_1829 * 2.0f) * _1853), (1.0f - (((1.0f - _1829) * 2.0f) * (1.0f - _1853)))) - _1829) * _1860) + _1829);
  } else {
    _1898 = _1827;
    _1899 = _1828;
    _1900 = _1829;
  }
  SV_Target.x = _1898;
  SV_Target.y = _1899;
  SV_Target.z = _1900;
  SV_Target.w = 0.0f;

#if 1
  SV_Target.rgb = ApplyUserGrading(SV_Target.rgb);
#endif

  return SV_Target;
}
