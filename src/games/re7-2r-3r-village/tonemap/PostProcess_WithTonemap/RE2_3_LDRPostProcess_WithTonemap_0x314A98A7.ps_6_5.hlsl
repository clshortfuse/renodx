#define SHADER_HASH 0x314A98A7
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

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  bool _32 = ((cPassEnabled & 1) != 0);
  bool _36 = _32 && (bool)(distortionType == 0);
  bool _38 = _32 && (bool)(distortionType == 1);
  float _41 = Kerare.x / Kerare.w;
  float _42 = Kerare.y / Kerare.w;
  float _43 = Kerare.z / Kerare.w;
  float _47 = abs(rsqrt(dot(float3(_41, _42, _43), float3(_41, _42, _43))) * _43);
  float _54 = _47 * _47;
  float _58 = saturate(((_54 * _54) * (1.0f - saturate((kerare_scale * _47) + kerare_offset))) + kerare_brightness);
  float _59 = _58 * Exposure;
  float _491;
  float _492;
  float _493;
  float _494;
  float _495;
  float _496;
  float _497;
  float _498;
  float _499;
  float _1462;
  float _1463;
  float _1464;
  float _1490;
  float _1491;
  float _1492;
  float _1503;
  float _1504;
  float _1505;
  float _1547;
  float _1563;
  float _1579;
  float _1604;
  float _1605;
  float _1606;
  float _1638;
  float _1639;
  float _1640;
  float _1652;
  float _1663;
  float _1674;
  float _1713;
  float _1724;
  float _1735;
  float _1760;
  float _1771;
  float _1782;
  float _1797;
  float _1798;
  float _1799;
  float _1817;
  float _1818;
  float _1819;
  float _1854;
  float _1855;
  float _1856;
  float _1925;
  float _1926;
  float _1927;
  if (_36) {
    float _85 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _86 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _87 = dot(float2(_85, _86), float2(_85, _86));
    float _90 = ((_87 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float4 _96 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_90 * _85) + 0.5f), ((_90 * _86) + 0.5f)));
    float _98 = _96.x * _59;
    float _99 = invLinearBegin * _98;
    float _106 = select((_98 >= linearBegin), 0.0f, (1.0f - ((_99 * _99) * (3.0f - (_99 * 2.0f)))));
    float _108 = select((_98 < linearStart), 0.0f, 1.0f);
    float _113 = (pow(_99, toe));
    float _116 = ((contrast * _98) + madLinearStartContrastFactor) * ((1.0f - _108) - _106);
    float _122 = (maxNit - (exp2((contrastFactor * _98) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _108;
    if (aberrationEnable == 0) {
      float _126 = _96.y * _59;
      float _127 = _96.z * _59;
      float _128 = invLinearBegin * _126;
      float _134 = invLinearBegin * _127;
      float _141 = select((_126 >= linearBegin), 0.0f, (1.0f - ((_128 * _128) * (3.0f - (_128 * 2.0f)))));
      float _143 = select((_127 >= linearBegin), 0.0f, (1.0f - ((_134 * _134) * (3.0f - (_134 * 2.0f)))));
      float _146 = select((_126 < linearStart), 0.0f, 1.0f);
      float _147 = select((_127 < linearStart), 0.0f, 1.0f);
      _491 = ((_116 + ((_113 * _106) * linearBegin)) + _122);
      _492 = (((((contrast * _126) + madLinearStartContrastFactor) * ((1.0f - _146) - _141)) + (((pow(_128, toe))*_141) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _126) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _146));
      _493 = (((((contrast * _127) + madLinearStartContrastFactor) * ((1.0f - _147) - _143)) + (((pow(_134, toe))*_143) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _127) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _147));
      _494 = fDistortionCoef;
      _495 = 0.0f;
      _496 = 0.0f;
      _497 = 0.0f;
      _498 = 0.0f;
      _499 = fCorrectCoef;
    } else {
      float _189 = _87 + fRefraction;
      float _191 = (_189 * fDistortionCoef) + 1.0f;
      float _192 = _85 * fCorrectCoef;
      float _194 = _86 * fCorrectCoef;
      float _200 = ((_189 + fRefraction) * fDistortionCoef) + 1.0f;
      float4 _209 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_192 * _191) + 0.5f), ((_194 * _191) + 0.5f)));
      float _211 = _209.y * _59;
      float _212 = invLinearBegin * _211;
      float _219 = select((_211 >= linearBegin), 0.0f, (1.0f - ((_212 * _212) * (3.0f - (_212 * 2.0f)))));
      float _221 = select((_211 < linearStart), 0.0f, 1.0f);
      float4 _240 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_192 * _200) + 0.5f), ((_194 * _200) + 0.5f)));
      float _242 = _240.z * _59;
      float _243 = invLinearBegin * _242;
      float _250 = select((_242 >= linearBegin), 0.0f, (1.0f - ((_243 * _243) * (3.0f - (_243 * 2.0f)))));
      float _252 = select((_242 < linearStart), 0.0f, 1.0f);
      _491 = ((_116 + ((linearBegin * _113) * _106)) + _122);
      _492 = (((((contrast * _211) + madLinearStartContrastFactor) * ((1.0f - _221) - _219)) + ((linearBegin * (pow(_212, toe))) * _219)) + ((maxNit - (exp2((contrastFactor * _211) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _221));
      _493 = (((((contrast * _242) + madLinearStartContrastFactor) * ((1.0f - _252) - _250)) + ((linearBegin * (pow(_243, toe))) * _250)) + ((maxNit - (exp2((contrastFactor * _242) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _252));
      _494 = fDistortionCoef;
      _495 = 0.0f;
      _496 = 0.0f;
      _497 = 0.0f;
      _498 = 0.0f;
      _499 = fCorrectCoef;
    }
  } else {
    if (_38) {
      float _285 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _289 = sqrt((_285 * _285) + 1.0f);
      float _290 = 1.0f / _289;
      float _293 = (_289 * fOptimizedParam.z) * (_290 + fOptimizedParam.x);
      float _297 = fOptimizedParam.w * 0.5f;
      float4 _305 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2((((_297 * _285) * _293) + 0.5f), ((((_297 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_290 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _293) + 0.5f)));
      float _309 = _305.x * _59;
      float _310 = _305.y * _59;
      float _311 = _305.z * _59;
      float _312 = invLinearBegin * _309;
      float _318 = invLinearBegin * _310;
      float _324 = invLinearBegin * _311;
      float _331 = select((_309 >= linearBegin), 0.0f, (1.0f - ((_312 * _312) * (3.0f - (_312 * 2.0f)))));
      float _333 = select((_310 >= linearBegin), 0.0f, (1.0f - ((_318 * _318) * (3.0f - (_318 * 2.0f)))));
      float _335 = select((_311 >= linearBegin), 0.0f, (1.0f - ((_324 * _324) * (3.0f - (_324 * 2.0f)))));
      float _339 = select((_309 < linearStart), 0.0f, 1.0f);
      float _340 = select((_310 < linearStart), 0.0f, 1.0f);
      float _341 = select((_311 < linearStart), 0.0f, 1.0f);
      _491 = (((((contrast * _309) + madLinearStartContrastFactor) * ((1.0f - _339) - _331)) + (((pow(_312, toe))*_331) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _309) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _339));
      _492 = (((((contrast * _310) + madLinearStartContrastFactor) * ((1.0f - _340) - _333)) + (((pow(_318, toe))*_333) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _310) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _340));
      _493 = (((((contrast * _311) + madLinearStartContrastFactor) * ((1.0f - _341) - _335)) + (((pow(_324, toe))*_335) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _311) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _341));
      _494 = 0.0f;
      _495 = fOptimizedParam.x;
      _496 = fOptimizedParam.y;
      _497 = fOptimizedParam.z;
      _498 = fOptimizedParam.w;
      _499 = 1.0f;
    } else {
      float4 _399 = RE_POSTPROCESS_Color.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
      float _403 = _399.x * _59;
      float _404 = _399.y * _59;
      float _405 = _399.z * _59;
      float _406 = invLinearBegin * _403;
      float _412 = invLinearBegin * _404;
      float _418 = invLinearBegin * _405;
      float _425 = select((_403 >= linearBegin), 0.0f, (1.0f - ((_406 * _406) * (3.0f - (_406 * 2.0f)))));
      float _427 = select((_404 >= linearBegin), 0.0f, (1.0f - ((_412 * _412) * (3.0f - (_412 * 2.0f)))));
      float _429 = select((_405 >= linearBegin), 0.0f, (1.0f - ((_418 * _418) * (3.0f - (_418 * 2.0f)))));
      float _433 = select((_403 < linearStart), 0.0f, 1.0f);
      float _434 = select((_404 < linearStart), 0.0f, 1.0f);
      float _435 = select((_405 < linearStart), 0.0f, 1.0f);
      _491 = (((((contrast * _403) + madLinearStartContrastFactor) * ((1.0f - _433) - _425)) + (((pow(_406, toe))*_425) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _403) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _433));
      _492 = (((((contrast * _404) + madLinearStartContrastFactor) * ((1.0f - _434) - _427)) + (((pow(_412, toe))*_427) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _404) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _434));
      _493 = (((((contrast * _405) + madLinearStartContrastFactor) * ((1.0f - _435) - _429)) + (((pow(_418, toe))*_429) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _405) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _435));
      _494 = 0.0f;
      _495 = 0.0f;
      _496 = 0.0f;
      _497 = 0.0f;
      _498 = 0.0f;
      _499 = 1.0f;
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _521 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _524 = ComputeResultSRV[0].computeAlpha;
    float _527 = ((1.0f - _521) + (_524 * _521)) * cbRadialColor.w;
    if (!(_527 == 0.0f)) {
      float _535 = screenInverseSize.x * SV_Position.x;
      float _536 = screenInverseSize.y * SV_Position.y;
      float _538 = (-0.5f - cbRadialScreenPos.x) + _535;
      float _540 = (-0.5f - cbRadialScreenPos.y) + _536;
      float _543 = select((_538 < 0.0f), (1.0f - _535), _535);
      float _546 = select((_540 < 0.0f), (1.0f - _536), _536);
      float _551 = rsqrt(dot(float2(_538, _540), float2(_538, _540))) * cbRadialSharpRange;
      uint _558 = uint(abs(_551 * _540)) + uint(abs(_551 * _538));
      uint _562 = ((_558 ^ 61) ^ ((uint)(_558) >> 16)) * 9;
      uint _565 = (((uint)(_562) >> 4) ^ _562) * 668265261;
      float _570 = select(((cbRadialBlurFlags & 1) != 0), (float((uint)((int)(((uint)(_565) >> 15) ^ _565))) * 2.3283064365386963e-10f), 1.0f);
      float _576 = 1.0f / max(1.0f, sqrt((_538 * _538) + (_540 * _540)));
      float _577 = cbRadialBlurPower * -0.0011111111380159855f;
      float _586 = ((((_577 * _543) * _570) * _576) + 1.0f) * _538;
      float _587 = ((((_577 * _546) * _570) * _576) + 1.0f) * _540;
      float _588 = cbRadialBlurPower * -0.002222222276031971f;
      float _597 = ((((_588 * _543) * _570) * _576) + 1.0f) * _538;
      float _598 = ((((_588 * _546) * _570) * _576) + 1.0f) * _540;
      float _599 = cbRadialBlurPower * -0.0033333334140479565f;
      float _608 = ((((_599 * _543) * _570) * _576) + 1.0f) * _538;
      float _609 = ((((_599 * _546) * _570) * _576) + 1.0f) * _540;
      float _610 = cbRadialBlurPower * -0.004444444552063942f;
      float _619 = ((((_610 * _543) * _570) * _576) + 1.0f) * _538;
      float _620 = ((((_610 * _546) * _570) * _576) + 1.0f) * _540;
      float _621 = cbRadialBlurPower * -0.0055555556900799274f;
      float _630 = ((((_621 * _543) * _570) * _576) + 1.0f) * _538;
      float _631 = ((((_621 * _546) * _570) * _576) + 1.0f) * _540;
      float _632 = cbRadialBlurPower * -0.006666666828095913f;
      float _641 = ((((_632 * _543) * _570) * _576) + 1.0f) * _538;
      float _642 = ((((_632 * _546) * _570) * _576) + 1.0f) * _540;
      float _643 = cbRadialBlurPower * -0.007777777966111898f;
      float _652 = ((((_643 * _543) * _570) * _576) + 1.0f) * _538;
      float _653 = ((((_643 * _546) * _570) * _576) + 1.0f) * _540;
      float _654 = cbRadialBlurPower * -0.008888889104127884f;
      float _663 = ((((_654 * _543) * _570) * _576) + 1.0f) * _538;
      float _664 = ((((_654 * _546) * _570) * _576) + 1.0f) * _540;
      float _665 = cbRadialBlurPower * -0.009999999776482582f;
      float _674 = ((((_665 * _543) * _570) * _576) + 1.0f) * _538;
      float _675 = ((((_665 * _546) * _570) * _576) + 1.0f) * _540;
      float _676 = (_58 * Exposure) * 0.10000000149011612f;
      float _677 = _676 * cbRadialColor.x;
      float _678 = _676 * cbRadialColor.y;
      float _679 = _676 * cbRadialColor.z;
      float _694 = (_491 * 0.10000000149011612f) * cbRadialColor.x;
      float _696 = (_492 * 0.10000000149011612f) * cbRadialColor.y;
      float _698 = (_493 * 0.10000000149011612f) * cbRadialColor.z;
      do {
        if (_36) {
          float _700 = _586 + cbRadialScreenPos.x;
          float _701 = _587 + cbRadialScreenPos.y;
          float _705 = ((dot(float2(_700, _701), float2(_700, _701)) * _494) + 1.0f) * _499;
          float4 _710 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_705 * _700) + 0.5f), ((_705 * _701) + 0.5f)), 0.0f);
          float _714 = _597 + cbRadialScreenPos.x;
          float _715 = _598 + cbRadialScreenPos.y;
          float _718 = (dot(float2(_714, _715), float2(_714, _715)) * _494) + 1.0f;
          float4 _725 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_714 * _499) * _718) + 0.5f), (((_715 * _499) * _718) + 0.5f)), 0.0f);
          float _732 = _608 + cbRadialScreenPos.x;
          float _733 = _609 + cbRadialScreenPos.y;
          float _736 = (dot(float2(_732, _733), float2(_732, _733)) * _494) + 1.0f;
          float4 _743 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_732 * _499) * _736) + 0.5f), (((_733 * _499) * _736) + 0.5f)), 0.0f);
          float _750 = _619 + cbRadialScreenPos.x;
          float _751 = _620 + cbRadialScreenPos.y;
          float _754 = (dot(float2(_750, _751), float2(_750, _751)) * _494) + 1.0f;
          float4 _761 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_750 * _499) * _754) + 0.5f), (((_751 * _499) * _754) + 0.5f)), 0.0f);
          float _768 = _630 + cbRadialScreenPos.x;
          float _769 = _631 + cbRadialScreenPos.y;
          float _772 = (dot(float2(_768, _769), float2(_768, _769)) * _494) + 1.0f;
          float4 _779 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_768 * _499) * _772) + 0.5f), (((_769 * _499) * _772) + 0.5f)), 0.0f);
          float _786 = _641 + cbRadialScreenPos.x;
          float _787 = _642 + cbRadialScreenPos.y;
          float _790 = (dot(float2(_786, _787), float2(_786, _787)) * _494) + 1.0f;
          float4 _797 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_786 * _499) * _790) + 0.5f), (((_787 * _499) * _790) + 0.5f)), 0.0f);
          float _804 = _652 + cbRadialScreenPos.x;
          float _805 = _653 + cbRadialScreenPos.y;
          float _808 = (dot(float2(_804, _805), float2(_804, _805)) * _494) + 1.0f;
          float4 _815 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_804 * _499) * _808) + 0.5f), (((_805 * _499) * _808) + 0.5f)), 0.0f);
          float _822 = _663 + cbRadialScreenPos.x;
          float _823 = _664 + cbRadialScreenPos.y;
          float _826 = (dot(float2(_822, _823), float2(_822, _823)) * _494) + 1.0f;
          float4 _833 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_822 * _499) * _826) + 0.5f), (((_823 * _499) * _826) + 0.5f)), 0.0f);
          float _840 = _674 + cbRadialScreenPos.x;
          float _841 = _675 + cbRadialScreenPos.y;
          float _844 = (dot(float2(_840, _841), float2(_840, _841)) * _494) + 1.0f;
          float4 _851 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_840 * _499) * _844) + 0.5f), (((_841 * _499) * _844) + 0.5f)), 0.0f);
          float _858 = _677 * ((((((((_725.x + _710.x) + _743.x) + _761.x) + _779.x) + _797.x) + _815.x) + _833.x) + _851.x);
          float _859 = _678 * ((((((((_725.y + _710.y) + _743.y) + _761.y) + _779.y) + _797.y) + _815.y) + _833.y) + _851.y);
          float _860 = _679 * ((((((((_725.z + _710.z) + _743.z) + _761.z) + _779.z) + _797.z) + _815.z) + _833.z) + _851.z);
          float _861 = _858 * invLinearBegin;
          float _867 = _859 * invLinearBegin;
          float _873 = _860 * invLinearBegin;
          float _880 = select((_858 >= linearBegin), 0.0f, (1.0f - ((_861 * _861) * (3.0f - (_861 * 2.0f)))));
          float _882 = select((_859 >= linearBegin), 0.0f, (1.0f - ((_867 * _867) * (3.0f - (_867 * 2.0f)))));
          float _884 = select((_860 >= linearBegin), 0.0f, (1.0f - ((_873 * _873) * (3.0f - (_873 * 2.0f)))));
          float _888 = select((_858 < linearStart), 0.0f, 1.0f);
          float _889 = select((_859 < linearStart), 0.0f, 1.0f);
          float _890 = select((_860 < linearStart), 0.0f, 1.0f);
          _1462 = (((((_880 * (pow(_861, toe))) * linearBegin) + _694) + (((contrast * _858) + madLinearStartContrastFactor) * ((1.0f - _888) - _880))) + ((maxNit - (exp2((contrastFactor * _858) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _888));
          _1463 = ((((((pow(_867, toe))*_882) * linearBegin) + _696) + (((contrast * _859) + madLinearStartContrastFactor) * ((1.0f - _889) - _882))) + ((maxNit - (exp2((contrastFactor * _859) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _889));
          _1464 = ((((((pow(_873, toe))*_884) * linearBegin) + _698) + (((contrast * _860) + madLinearStartContrastFactor) * ((1.0f - _890) - _884))) + ((maxNit - (exp2((contrastFactor * _860) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _890));
        } else {
          float _949 = cbRadialScreenPos.x + 0.5f;
          float _950 = _949 + _586;
          float _951 = cbRadialScreenPos.y + 0.5f;
          float _952 = _951 + _587;
          float _953 = _949 + _597;
          float _954 = _951 + _598;
          float _955 = _949 + _608;
          float _956 = _951 + _609;
          float _957 = _949 + _619;
          float _958 = _951 + _620;
          float _959 = _949 + _630;
          float _960 = _951 + _631;
          float _961 = _949 + _641;
          float _962 = _951 + _642;
          float _963 = _949 + _652;
          float _964 = _951 + _653;
          float _965 = _949 + _663;
          float _966 = _951 + _664;
          float _967 = _949 + _674;
          float _968 = _951 + _675;
          if (_38) {
            float _972 = (_950 * 2.0f) + -1.0f;
            float _976 = sqrt((_972 * _972) + 1.0f);
            float _977 = 1.0f / _976;
            float _980 = (_976 * _497) * (_977 + _495);
            float _984 = _498 * 0.5f;
            float4 _992 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_984 * _980) * _972) + 0.5f), ((((_984 * (((_977 + -1.0f) * _496) + 1.0f)) * _980) * ((_952 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _998 = (_953 * 2.0f) + -1.0f;
            float _1002 = sqrt((_998 * _998) + 1.0f);
            float _1003 = 1.0f / _1002;
            float _1006 = (_1002 * _497) * (_1003 + _495);
            float4 _1017 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_984 * _998) * _1006) + 0.5f), ((((_984 * ((_954 * 2.0f) + -1.0f)) * (((_1003 + -1.0f) * _496) + 1.0f)) * _1006) + 0.5f)), 0.0f);
            float _1026 = (_955 * 2.0f) + -1.0f;
            float _1030 = sqrt((_1026 * _1026) + 1.0f);
            float _1031 = 1.0f / _1030;
            float _1034 = (_1030 * _497) * (_1031 + _495);
            float4 _1045 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_984 * _1026) * _1034) + 0.5f), ((((_984 * ((_956 * 2.0f) + -1.0f)) * (((_1031 + -1.0f) * _496) + 1.0f)) * _1034) + 0.5f)), 0.0f);
            float _1054 = (_957 * 2.0f) + -1.0f;
            float _1058 = sqrt((_1054 * _1054) + 1.0f);
            float _1059 = 1.0f / _1058;
            float _1062 = (_1058 * _497) * (_1059 + _495);
            float4 _1073 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_984 * _1054) * _1062) + 0.5f), ((((_984 * ((_958 * 2.0f) + -1.0f)) * (((_1059 + -1.0f) * _496) + 1.0f)) * _1062) + 0.5f)), 0.0f);
            float _1082 = (_959 * 2.0f) + -1.0f;
            float _1086 = sqrt((_1082 * _1082) + 1.0f);
            float _1087 = 1.0f / _1086;
            float _1090 = (_1086 * _497) * (_1087 + _495);
            float4 _1101 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_984 * _1082) * _1090) + 0.5f), ((((_984 * ((_960 * 2.0f) + -1.0f)) * (((_1087 + -1.0f) * _496) + 1.0f)) * _1090) + 0.5f)), 0.0f);
            float _1110 = (_961 * 2.0f) + -1.0f;
            float _1114 = sqrt((_1110 * _1110) + 1.0f);
            float _1115 = 1.0f / _1114;
            float _1118 = (_1114 * _497) * (_1115 + _495);
            float4 _1129 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_984 * _1110) * _1118) + 0.5f), ((((_984 * ((_962 * 2.0f) + -1.0f)) * (((_1115 + -1.0f) * _496) + 1.0f)) * _1118) + 0.5f)), 0.0f);
            float _1138 = (_963 * 2.0f) + -1.0f;
            float _1142 = sqrt((_1138 * _1138) + 1.0f);
            float _1143 = 1.0f / _1142;
            float _1146 = (_1142 * _497) * (_1143 + _495);
            float4 _1157 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_984 * _1138) * _1146) + 0.5f), ((((_984 * ((_964 * 2.0f) + -1.0f)) * (((_1143 + -1.0f) * _496) + 1.0f)) * _1146) + 0.5f)), 0.0f);
            float _1166 = (_965 * 2.0f) + -1.0f;
            float _1170 = sqrt((_1166 * _1166) + 1.0f);
            float _1171 = 1.0f / _1170;
            float _1174 = (_1170 * _497) * (_1171 + _495);
            float4 _1185 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_984 * _1166) * _1174) + 0.5f), ((((_984 * ((_966 * 2.0f) + -1.0f)) * (((_1171 + -1.0f) * _496) + 1.0f)) * _1174) + 0.5f)), 0.0f);
            float _1194 = (_967 * 2.0f) + -1.0f;
            float _1198 = sqrt((_1194 * _1194) + 1.0f);
            float _1199 = 1.0f / _1198;
            float _1202 = (_1198 * _497) * (_1199 + _495);
            float4 _1213 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_984 * _1194) * _1202) + 0.5f), ((((_984 * ((_968 * 2.0f) + -1.0f)) * (((_1199 + -1.0f) * _496) + 1.0f)) * _1202) + 0.5f)), 0.0f);
            float _1220 = _677 * ((((((((_1017.x + _992.x) + _1045.x) + _1073.x) + _1101.x) + _1129.x) + _1157.x) + _1185.x) + _1213.x);
            float _1221 = _678 * ((((((((_1017.y + _992.y) + _1045.y) + _1073.y) + _1101.y) + _1129.y) + _1157.y) + _1185.y) + _1213.y);
            float _1222 = _679 * ((((((((_1017.z + _992.z) + _1045.z) + _1073.z) + _1101.z) + _1129.z) + _1157.z) + _1185.z) + _1213.z);
            float _1223 = _1220 * invLinearBegin;
            float _1229 = _1221 * invLinearBegin;
            float _1235 = _1222 * invLinearBegin;
            float _1242 = select((_1220 >= linearBegin), 0.0f, (1.0f - ((_1223 * _1223) * (3.0f - (_1223 * 2.0f)))));
            float _1244 = select((_1221 >= linearBegin), 0.0f, (1.0f - ((_1229 * _1229) * (3.0f - (_1229 * 2.0f)))));
            float _1246 = select((_1222 >= linearBegin), 0.0f, (1.0f - ((_1235 * _1235) * (3.0f - (_1235 * 2.0f)))));
            float _1250 = select((_1220 < linearStart), 0.0f, 1.0f);
            float _1251 = select((_1221 < linearStart), 0.0f, 1.0f);
            float _1252 = select((_1222 < linearStart), 0.0f, 1.0f);
            _1462 = (((((_1242 * (pow(_1223, toe))) * linearBegin) + _694) + (((contrast * _1220) + madLinearStartContrastFactor) * ((1.0f - _1250) - _1242))) + ((maxNit - (exp2((contrastFactor * _1220) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1250));
            _1463 = ((((((pow(_1229, toe))*_1244) * linearBegin) + _696) + (((contrast * _1221) + madLinearStartContrastFactor) * ((1.0f - _1251) - _1244))) + ((maxNit - (exp2((contrastFactor * _1221) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1251));
            _1464 = ((((((pow(_1235, toe))*_1246) * linearBegin) + _698) + (((contrast * _1222) + madLinearStartContrastFactor) * ((1.0f - _1252) - _1246))) + ((maxNit - (exp2((contrastFactor * _1222) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1252));
          } else {
            float4 _1311 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_950, _952), 0.0f);
            float4 _1315 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_953, _954), 0.0f);
            float4 _1322 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_955, _956), 0.0f);
            float4 _1329 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_957, _958), 0.0f);
            float4 _1336 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_959, _960), 0.0f);
            float4 _1343 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_961, _962), 0.0f);
            float4 _1350 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_963, _964), 0.0f);
            float4 _1357 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_965, _966), 0.0f);
            float4 _1364 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_967, _968), 0.0f);
            float _1371 = _677 * ((((((((_1315.x + _1311.x) + _1322.x) + _1329.x) + _1336.x) + _1343.x) + _1350.x) + _1357.x) + _1364.x);
            float _1372 = _678 * ((((((((_1315.y + _1311.y) + _1322.y) + _1329.y) + _1336.y) + _1343.y) + _1350.y) + _1357.y) + _1364.y);
            float _1373 = _679 * ((((((((_1315.z + _1311.z) + _1322.z) + _1329.z) + _1336.z) + _1343.z) + _1350.z) + _1357.z) + _1364.z);
            float _1374 = _1371 * invLinearBegin;
            float _1380 = _1372 * invLinearBegin;
            float _1386 = _1373 * invLinearBegin;
            float _1393 = select((_1371 >= linearBegin), 0.0f, (1.0f - ((_1374 * _1374) * (3.0f - (_1374 * 2.0f)))));
            float _1395 = select((_1372 >= linearBegin), 0.0f, (1.0f - ((_1380 * _1380) * (3.0f - (_1380 * 2.0f)))));
            float _1397 = select((_1373 >= linearBegin), 0.0f, (1.0f - ((_1386 * _1386) * (3.0f - (_1386 * 2.0f)))));
            float _1401 = select((_1371 < linearStart), 0.0f, 1.0f);
            float _1402 = select((_1372 < linearStart), 0.0f, 1.0f);
            float _1403 = select((_1373 < linearStart), 0.0f, 1.0f);
            _1462 = (((((_1393 * (pow(_1374, toe))) * linearBegin) + _694) + (((contrast * _1371) + madLinearStartContrastFactor) * ((1.0f - _1401) - _1393))) + ((maxNit - (exp2((contrastFactor * _1371) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1401));
            _1463 = ((((((pow(_1380, toe))*_1395) * linearBegin) + _696) + (((contrast * _1372) + madLinearStartContrastFactor) * ((1.0f - _1402) - _1395))) + ((maxNit - (exp2((contrastFactor * _1372) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1402));
            _1464 = ((((((pow(_1386, toe))*_1397) * linearBegin) + _698) + (((contrast * _1373) + madLinearStartContrastFactor) * ((1.0f - _1403) - _1397))) + ((maxNit - (exp2((contrastFactor * _1373) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _1403));
          }
        }
        do {
          if (cbRadialMaskRate.x > 0.0f) {
            float _1473 = saturate((sqrt((_538 * _538) + (_540 * _540)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
            float _1479 = (((_1473 * _1473) * cbRadialMaskRate.x) * (3.0f - (_1473 * 2.0f))) + cbRadialMaskRate.y;
            _1490 = ((_1479 * (_1462 - _491)) + _491);
            _1491 = ((_1479 * (_1463 - _492)) + _492);
            _1492 = ((_1479 * (_1464 - _493)) + _493);
          } else {
            _1490 = _1462;
            _1491 = _1463;
            _1492 = _1464;
          }
          _1503 = (lerp(_491, _1490, _527));
          _1504 = (lerp(_492, _1491, _527));
          _1505 = (lerp(_493, _1492, _527));
        } while (false);
      } while (false);
    } else {
      _1503 = _491;
      _1504 = _492;
      _1505 = _493;
    }
  } else {
    _1503 = _491;
    _1504 = _492;
    _1505 = _493;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _1527 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
    float _1529 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
    float _1533 = frac(frac(dot(float2(_1527, _1529), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_1533 < fNoiseDensity) {
        int _1538 = (uint)(uint(_1529 * _1527)) ^ 12345391;
        uint _1539 = _1538 * 3635641;
        _1547 = (float((uint)((int)((((uint)(_1539) >> 26) | ((uint)(_1538 * 232681024))) ^ _1539))) * 2.3283064365386963e-10f);
      } else {
        _1547 = 0.0f;
      }
      float _1549 = frac(_1533 * 757.4846801757812f);
      do {
        if (_1549 < fNoiseDensity) {
          int _1553 = asint(_1549) ^ 12345391;
          uint _1554 = _1553 * 3635641;
          _1563 = ((float((uint)((int)((((uint)(_1554) >> 26) | ((uint)(_1553 * 232681024))) ^ _1554))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1563 = 0.0f;
        }
        float _1565 = frac(_1549 * 757.4846801757812f);
        do {
          if (_1565 < fNoiseDensity) {
            int _1569 = asint(_1565) ^ 12345391;
            uint _1570 = _1569 * 3635641;
            _1579 = ((float((uint)((int)((((uint)(_1570) >> 26) | ((uint)(_1569 * 232681024))) ^ _1570))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1579 = 0.0f;
          }
          float _1580 = _1547 * fNoisePower.x;
          float _1581 = _1579 * fNoisePower.y;
          float _1582 = _1563 * fNoisePower.y;
          float _1593 = exp2(log2(1.0f - saturate(dot(float3(_1503, _1504, _1505), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1604 = ((_1593 * (mad(_1582, 1.4019999504089355f, _1580) - _1503)) + _1503);
          _1605 = ((_1593 * (mad(_1582, -0.7139999866485596f, mad(_1581, -0.3440000116825104f, _1580)) - _1504)) + _1504);
          _1606 = ((_1593 * (mad(_1581, 1.7719999551773071f, _1580) - _1505)) + _1505);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1604 = _1503;
    _1605 = _1504;
    _1606 = _1505;
  }
#if 1
  ApplyColorGrading(
      _1604, _1605, _1606,
      _1817, _1818, _1819,
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
    float _1631 = max(max(_1604, _1605), _1606);
    bool _1632 = (_1631 > 1.0f);
    do {
      if (_1632) {
        _1638 = (_1604 / _1631);
        _1639 = (_1605 / _1631);
        _1640 = (_1606 / _1631);
      } else {
        _1638 = _1604;
        _1639 = _1605;
        _1640 = _1606;
      }
      float _1641 = fTextureInverseSize * 0.5f;
      do {
        [branch]
        if (!(!(_1638 <= 0.0031308000907301903f))) {
          _1652 = (_1638 * 12.920000076293945f);
        } else {
          _1652 = (((pow(_1638, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          [branch]
          if (!(!(_1639 <= 0.0031308000907301903f))) {
            _1663 = (_1639 * 12.920000076293945f);
          } else {
            _1663 = (((pow(_1639, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            [branch]
            if (!(!(_1640 <= 0.0031308000907301903f))) {
              _1674 = (_1640 * 12.920000076293945f);
            } else {
              _1674 = (((pow(_1640, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            float _1675 = 1.0f - fTextureInverseSize;
            float _1679 = (_1652 * _1675) + _1641;
            float _1680 = (_1663 * _1675) + _1641;
            float _1681 = (_1674 * _1675) + _1641;
            float4 _1682 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1679, _1680, _1681), 0.0f);
            do {
              [branch]
              if (fTextureBlendRate > 0.0f) {
                float4 _1688 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1679, _1680, _1681), 0.0f);
                float _1698 = ((_1688.x - _1682.x) * fTextureBlendRate) + _1682.x;
                float _1699 = ((_1688.y - _1682.y) * fTextureBlendRate) + _1682.y;
                float _1700 = ((_1688.z - _1682.z) * fTextureBlendRate) + _1682.z;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    [branch]
                    if (!(!(_1698 <= 0.0031308000907301903f))) {
                      _1713 = (_1698 * 12.920000076293945f);
                    } else {
                      _1713 = (((pow(_1698, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_1699 <= 0.0031308000907301903f))) {
                        _1724 = (_1699 * 12.920000076293945f);
                      } else {
                        _1724 = (((pow(_1699, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_1700 <= 0.0031308000907301903f))) {
                          _1735 = (_1700 * 12.920000076293945f);
                        } else {
                          _1735 = (((pow(_1700, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _1736 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1713, _1724, _1735), 0.0f);
                        _1797 = (lerp(_1698, _1736.x, fTextureBlendRate2));
                        _1798 = (lerp(_1699, _1736.y, fTextureBlendRate2));
                        _1799 = (lerp(_1700, _1736.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _1797 = _1698;
                  _1798 = _1699;
                  _1799 = _1700;
                }
              } else {
                do {
                  [branch]
                  if (!(!(_1682.x <= 0.0031308000907301903f))) {
                    _1760 = (_1682.x * 12.920000076293945f);
                  } else {
                    _1760 = (((pow(_1682.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  }
                  do {
                    [branch]
                    if (!(!(_1682.y <= 0.0031308000907301903f))) {
                      _1771 = (_1682.y * 12.920000076293945f);
                    } else {
                      _1771 = (((pow(_1682.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_1682.z <= 0.0031308000907301903f))) {
                        _1782 = (_1682.z * 12.920000076293945f);
                      } else {
                        _1782 = (((pow(_1682.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      float4 _1783 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1760, _1771, _1782), 0.0f);
                      _1797 = (lerp(_1682.x, _1783.x, fTextureBlendRate2));
                      _1798 = (lerp(_1682.y, _1783.y, fTextureBlendRate2));
                      _1799 = (lerp(_1682.z, _1783.z, fTextureBlendRate2));
                    } while (false);
                  } while (false);
                } while (false);
              }
              float _1803 = mad(_1799, (fColorMatrix[2].x), mad(_1798, (fColorMatrix[1].x), (_1797 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
              float _1807 = mad(_1799, (fColorMatrix[2].y), mad(_1798, (fColorMatrix[1].y), (_1797 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
              float _1811 = mad(_1799, (fColorMatrix[2].z), mad(_1798, (fColorMatrix[1].z), (_1797 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
              if (_1632) {
                _1817 = (_1803 * _1631);
                _1818 = (_1807 * _1631);
                _1819 = (_1811 * _1631);
              } else {
                _1817 = _1803;
                _1818 = _1807;
                _1819 = _1811;
              }
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1817 = _1604;
    _1818 = _1605;
    _1819 = _1606;
  }
#endif
  if (!((cPassEnabled & 8) == 0)) {
    _1854 = saturate(((cvdR.x * _1817) + (cvdR.y * _1818)) + (cvdR.z * _1819));
    _1855 = saturate(((cvdG.x * _1817) + (cvdG.y * _1818)) + (cvdG.z * _1819));
    _1856 = saturate(((cvdB.x * _1817) + (cvdB.y * _1818)) + (cvdB.z * _1819));
  } else {
    _1854 = _1817;
    _1855 = _1818;
    _1856 = _1819;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _1871 = screenInverseSize.x * SV_Position.x;
    float _1872 = screenInverseSize.y * SV_Position.y;
    float4 _1873 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1871, _1872), 0.0f);
    float _1878 = _1873.x * ColorParam.x;
    float _1879 = _1873.y * ColorParam.y;
    float _1880 = _1873.z * ColorParam.z;
    float _1882 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1871, _1872), 0.0f);
    float _1887 = (_1873.w * ColorParam.w) * saturate((_1882.x * Levels_Rate) + Levels_Range);
    _1925 = (((select((_1878 < 0.5f), ((_1854 * 2.0f) * _1878), (1.0f - (((1.0f - _1854) * 2.0f) * (1.0f - _1878)))) - _1854) * _1887) + _1854);
    _1926 = (((select((_1879 < 0.5f), ((_1855 * 2.0f) * _1879), (1.0f - (((1.0f - _1855) * 2.0f) * (1.0f - _1879)))) - _1855) * _1887) + _1855);
    _1927 = (((select((_1880 < 0.5f), ((_1856 * 2.0f) * _1880), (1.0f - (((1.0f - _1856) * 2.0f) * (1.0f - _1880)))) - _1856) * _1887) + _1856);
  } else {
    _1925 = _1854;
    _1926 = _1855;
    _1927 = _1856;
  }
  SV_Target.x = _1925;
  SV_Target.y = _1926;
  SV_Target.z = _1927;
  SV_Target.w = 0.0f;

#if 1
  SV_Target.rgb = ApplyUserGrading(SV_Target.rgb);
#endif

  return SV_Target;
}
