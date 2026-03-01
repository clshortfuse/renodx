#include "./PostProcess.hlsli"

Texture2D<float4> RE_POSTPROCESS_Input0 : register(t0);

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
  float tessellationParam : packoffset(c038.z);
  uint sceneInfoAdditionalFlags : packoffset(c038.w);
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
  } cbControlRGCParam : packoffset(c005.x);
};

cbuffer UserShaderLDRPostProcessSettings : register(b5) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float _107;
  float _377;
  float _378;
  float _379;
  float _455;
  float _519;
  float _1074;
  float _1075;
  float _1076;
  float _1110;
  float _1111;
  float _1112;
  float _1123;
  float _1124;
  float _1125;
  float _1155;
  float _1171;
  float _1187;
  float _1215;
  float _1216;
  float _1217;
  float _1275;
  float _1296;
  float _1316;
  float _1324;
  float _1325;
  float _1326;
  float _1537;
  float _1538;
  float _1539;
  float _1553;
  float _1554;
  float _1555;
  float _1588;
  float _1589;
  float _1590;
  float _1640;
  float _1652;
  float _1664;
  float _1675;
  float _1676;
  float _1677;
  float _1738;
  float _1771;
  float _1782;
  float _1793;
  float _1794;
  float _1795;
  [branch]
  if (film_aspect == 0.0f) {
    float _68 = Kerare.x / Kerare.w;
    float _69 = Kerare.y / Kerare.w;
    float _70 = Kerare.z / Kerare.w;
    float _74 = abs(rsqrt(dot(float3(_68, _69, _70), float3(_68, _69, _70))) * _70);
    float _79 = _74 * _74;
    _107 = ((_79 * _79) * (1.0f - saturate((_74 * kerare_scale) + kerare_offset)));
  } else {
    float _90 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _92 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _94 = sqrt(dot(float2(_92, _90), float2(_92, _90)));
    float _102 = (_94 * _94) + 1.0f;
    _107 = ((1.0f / (_102 * _102)) * (1.0f - saturate(((1.0f / (_94 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _110 = saturate(_107 + kerare_brightness) * Exposure;
  uint _111 = uint(float((uint)(int)(distortionType)));
  bool _116 = (LDRPPSettings_enabled != 0);
  bool _117 = ((cPassEnabled & 1) != 0);
  if (!(_117 && _116)) {
    float4 _127 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    _377 = (min(_127.x, 65000.0f) * _110);
    _378 = (min(_127.y, 65000.0f) * _110);
    _379 = (min(_127.z, 65000.0f) * _110);
  } else {
    if (_111 == 0) {
      float _145 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _146 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _147 = dot(float2(_145, _146), float2(_145, _146));
      float _149 = (_147 * fDistortionCoef) + 1.0f;
      float _150 = _145 * fCorrectCoef;
      float _152 = _146 * fCorrectCoef;
      float _154 = (_150 * _149) + 0.5f;
      float _155 = (_152 * _149) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _160 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(_154, _155));
        _377 = (_160.x * _110);
        _378 = (_160.y * _110);
        _379 = (_160.z * _110);
      } else {
        float _179 = ((saturate((sqrt((_145 * _145) + (_146 * _146)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _189 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _190 = _179 * 2.0f;
          float _194 = (((_189 * _190) + _147) * fDistortionCoef) + 1.0f;
          float4 _199 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_194 * _150) + 0.5f), ((_194 * _152) + 0.5f)));
          float _205 = ((((_189 + 0.125f) * _190) + _147) * fDistortionCoef) + 1.0f;
          float4 _210 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_205 * _150) + 0.5f), ((_205 * _152) + 0.5f)));
          float _217 = ((((_189 + 0.25f) * _190) + _147) * fDistortionCoef) + 1.0f;
          float4 _222 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_217 * _150) + 0.5f), ((_217 * _152) + 0.5f)));
          float _231 = ((((_189 + 0.375f) * _190) + _147) * fDistortionCoef) + 1.0f;
          float4 _236 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_231 * _150) + 0.5f), ((_231 * _152) + 0.5f)));
          float _245 = ((((_189 + 0.5f) * _190) + _147) * fDistortionCoef) + 1.0f;
          float4 _250 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_245 * _150) + 0.5f), ((_245 * _152) + 0.5f)));
          float _256 = ((((_189 + 0.625f) * _190) + _147) * fDistortionCoef) + 1.0f;
          float4 _261 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_256 * _150) + 0.5f), ((_256 * _152) + 0.5f)));
          float _269 = ((((_189 + 0.75f) * _190) + _147) * fDistortionCoef) + 1.0f;
          float4 _274 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_269 * _150) + 0.5f), ((_269 * _152) + 0.5f)));
          float _289 = ((((_189 + 0.875f) * _190) + _147) * fDistortionCoef) + 1.0f;
          float4 _294 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_289 * _150) + 0.5f), ((_289 * _152) + 0.5f)));
          float _301 = ((((_189 + 1.0f) * _190) + _147) * fDistortionCoef) + 1.0f;
          float4 _306 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_301 * _150) + 0.5f), ((_301 * _152) + 0.5f)));
          float _309 = _110 * 0.3199999928474426f;
          _377 = ((((_210.x + _199.x) + (_222.x * 0.75f)) + (_236.x * 0.375f)) * _309);
          _378 = ((_110 * 0.3636363744735718f) * ((((_261.y + _236.y) * 0.625f) + _250.y) + ((_274.y + _222.y) * 0.25f)));
          _379 = (((((_274.z * 0.75f) + (_261.z * 0.375f)) + _294.z) + _306.z) * _309);
        } else {
          float _315 = _179 + _147;
          float _317 = (_315 * fDistortionCoef) + 1.0f;
          float _324 = ((_315 + _179) * fDistortionCoef) + 1.0f;
          float4 _329 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(_154, _155));
          float4 _332 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_317 * _150) + 0.5f), ((_317 * _152) + 0.5f)));
          float4 _335 = RE_POSTPROCESS_Input0.Sample(BilinearClamp, float2(((_324 * _150) + 0.5f), ((_324 * _152) + 0.5f)));
          _377 = (_329.x * _110);
          _378 = (_332.y * _110);
          _379 = (_335.z * _110);
        }
      }
    } else {
      if (_111 == 1) {
        float _348 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _352 = sqrt((_348 * _348) + 1.0f);
        float _353 = 1.0f / _352;
        float _361 = ((_352 * fOptimizedParam.z) * (_353 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _369 = RE_POSTPROCESS_Input0.Sample(BilinearBorder, float2(((_361 * _348) + 0.5f), (((_361 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_353 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _377 = (_369.x * _110);
        _378 = (_369.y * _110);
        _379 = (_369.z * _110);
      } else {
        _377 = 0.0f;
        _378 = 0.0f;
        _379 = 0.0f;
      }
    }
  }
  [branch]
  if (film_aspect == 0.0f) {
    float _416 = Kerare.x / Kerare.w;
    float _417 = Kerare.y / Kerare.w;
    float _418 = Kerare.z / Kerare.w;
    float _422 = abs(rsqrt(dot(float3(_416, _417, _418), float3(_416, _417, _418))) * _418);
    float _427 = _422 * _422;
    _455 = ((_427 * _427) * (1.0f - saturate((_422 * kerare_scale) + kerare_offset)));
  } else {
    float _438 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _440 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _442 = sqrt(dot(float2(_440, _438), float2(_440, _438)));
    float _450 = (_442 * _442) + 1.0f;
    _455 = ((1.0f / (_450 * _450)) * (1.0f - saturate(((1.0f / (_442 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _458 = saturate(_455 + kerare_brightness) * Exposure;
  if (_116 && (bool)((cPassEnabled & 32) != 0)) {
    float _469 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _473 = ComputeResultSRV[0].computeAlpha;
    float _476 = ((1.0f - _469) + (_473 * _469)) * cbRadialColor.w;
    if (!(_476 == 0.0f)) {
      float _482 = screenInverseSize.x * SV_Position.x;
      float _483 = screenInverseSize.y * SV_Position.y;
      float _485 = _482 + (-0.5f - cbRadialScreenPos.x);
      float _487 = _483 + (-0.5f - cbRadialScreenPos.y);
      float _490 = select((_485 < 0.0f), (1.0f - _482), _482);
      float _493 = select((_487 < 0.0f), (1.0f - _483), _483);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _499 = rsqrt(dot(float2(_485, _487), float2(_485, _487))) * cbRadialSharpRange;
          uint _506 = uint(abs(_499 * _487)) + uint(abs(_499 * _485));
          uint _510 = ((_506 ^ 61) ^ ((uint)(_506) >> 16)) * 9;
          uint _513 = (((uint)(_510) >> 4) ^ _510) * 668265261;
          _519 = (float((uint)((int)(((uint)(_513) >> 15) ^ _513))) * 2.3283064365386963e-10f);
        } else {
          _519 = 1.0f;
        }
        float _523 = sqrt((_485 * _485) + (_487 * _487));
        float _525 = 1.0f / max(1.0f, _523);
        float _526 = _519 * _490;
        float _527 = cbRadialBlurPower * _525;
        float _528 = _527 * -0.0011111111380159855f;
        float _530 = _519 * _493;
        float _534 = ((_528 * _526) + 1.0f) * _485;
        float _535 = ((_528 * _530) + 1.0f) * _487;
        float _537 = _527 * -0.002222222276031971f;
        float _542 = ((_537 * _526) + 1.0f) * _485;
        float _543 = ((_537 * _530) + 1.0f) * _487;
        float _544 = _527 * -0.0033333334140479565f;
        float _549 = ((_544 * _526) + 1.0f) * _485;
        float _550 = ((_544 * _530) + 1.0f) * _487;
        float _551 = _527 * -0.004444444552063942f;
        float _556 = ((_551 * _526) + 1.0f) * _485;
        float _557 = ((_551 * _530) + 1.0f) * _487;
        float _558 = _527 * -0.0055555556900799274f;
        float _563 = ((_558 * _526) + 1.0f) * _485;
        float _564 = ((_558 * _530) + 1.0f) * _487;
        float _565 = _527 * -0.006666666828095913f;
        float _570 = ((_565 * _526) + 1.0f) * _485;
        float _571 = ((_565 * _530) + 1.0f) * _487;
        float _572 = _527 * -0.007777777966111898f;
        float _577 = ((_572 * _526) + 1.0f) * _485;
        float _578 = ((_572 * _530) + 1.0f) * _487;
        float _579 = _527 * -0.008888889104127884f;
        float _584 = ((_579 * _526) + 1.0f) * _485;
        float _585 = ((_579 * _530) + 1.0f) * _487;
        float _588 = _525 * ((cbRadialBlurPower * -0.009999999776482582f) * _519);
        float _593 = ((_588 * _490) + 1.0f) * _485;
        float _594 = ((_588 * _493) + 1.0f) * _487;
        do {
          if (_117 && (bool)(_111 == 0)) {
            float _596 = _534 + cbRadialScreenPos.x;
            float _597 = _535 + cbRadialScreenPos.y;
            float _601 = ((dot(float2(_596, _597), float2(_596, _597)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _607 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_601 * _596) + 0.5f), ((_601 * _597) + 0.5f)), 0.0f);
            float _611 = _542 + cbRadialScreenPos.x;
            float _612 = _543 + cbRadialScreenPos.y;
            float _616 = ((dot(float2(_611, _612), float2(_611, _612)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _621 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_616 * _611) + 0.5f), ((_616 * _612) + 0.5f)), 0.0f);
            float _628 = _549 + cbRadialScreenPos.x;
            float _629 = _550 + cbRadialScreenPos.y;
            float _633 = ((dot(float2(_628, _629), float2(_628, _629)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _638 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_633 * _628) + 0.5f), ((_633 * _629) + 0.5f)), 0.0f);
            float _645 = _556 + cbRadialScreenPos.x;
            float _646 = _557 + cbRadialScreenPos.y;
            float _650 = ((dot(float2(_645, _646), float2(_645, _646)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _655 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_650 * _645) + 0.5f), ((_650 * _646) + 0.5f)), 0.0f);
            float _662 = _563 + cbRadialScreenPos.x;
            float _663 = _564 + cbRadialScreenPos.y;
            float _667 = ((dot(float2(_662, _663), float2(_662, _663)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _672 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_667 * _662) + 0.5f), ((_667 * _663) + 0.5f)), 0.0f);
            float _679 = _570 + cbRadialScreenPos.x;
            float _680 = _571 + cbRadialScreenPos.y;
            float _684 = ((dot(float2(_679, _680), float2(_679, _680)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _689 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_684 * _679) + 0.5f), ((_684 * _680) + 0.5f)), 0.0f);
            float _696 = _577 + cbRadialScreenPos.x;
            float _697 = _578 + cbRadialScreenPos.y;
            float _701 = ((dot(float2(_696, _697), float2(_696, _697)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _706 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_701 * _696) + 0.5f), ((_701 * _697) + 0.5f)), 0.0f);
            float _713 = _584 + cbRadialScreenPos.x;
            float _714 = _585 + cbRadialScreenPos.y;
            float _718 = ((dot(float2(_713, _714), float2(_713, _714)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _723 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_718 * _713) + 0.5f), ((_718 * _714) + 0.5f)), 0.0f);
            float _730 = _593 + cbRadialScreenPos.x;
            float _731 = _594 + cbRadialScreenPos.y;
            float _735 = ((dot(float2(_730, _731), float2(_730, _731)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _740 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(((_735 * _730) + 0.5f), ((_735 * _731) + 0.5f)), 0.0f);
            _1074 = ((((((((_621.x + _607.x) + _638.x) + _655.x) + _672.x) + _689.x) + _706.x) + _723.x) + _740.x);
            _1075 = ((((((((_621.y + _607.y) + _638.y) + _655.y) + _672.y) + _689.y) + _706.y) + _723.y) + _740.y);
            _1076 = ((((((((_621.z + _607.z) + _638.z) + _655.z) + _672.z) + _689.z) + _706.z) + _723.z) + _740.z);
          } else {
            float _748 = cbRadialScreenPos.x + 0.5f;
            float _749 = _534 + _748;
            float _750 = cbRadialScreenPos.y + 0.5f;
            float _751 = _535 + _750;
            float _752 = _542 + _748;
            float _753 = _543 + _750;
            float _754 = _549 + _748;
            float _755 = _550 + _750;
            float _756 = _556 + _748;
            float _757 = _557 + _750;
            float _758 = _563 + _748;
            float _759 = _564 + _750;
            float _760 = _570 + _748;
            float _761 = _571 + _750;
            float _762 = _577 + _748;
            float _763 = _578 + _750;
            float _764 = _584 + _748;
            float _765 = _585 + _750;
            float _766 = _593 + _748;
            float _767 = _594 + _750;
            if (_117 && (bool)(_111 == 1)) {
              float _771 = (_749 * 2.0f) + -1.0f;
              float _775 = sqrt((_771 * _771) + 1.0f);
              float _776 = 1.0f / _775;
              float _783 = fOptimizedParam.w * 0.5f;
              float _784 = ((_775 * fOptimizedParam.z) * (_776 + fOptimizedParam.x)) * _783;
              float4 _791 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_784 * _771) + 0.5f), (((_784 * ((_751 * 2.0f) + -1.0f)) * (((_776 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _797 = (_752 * 2.0f) + -1.0f;
              float _801 = sqrt((_797 * _797) + 1.0f);
              float _802 = 1.0f / _801;
              float _809 = ((_801 * fOptimizedParam.z) * (_802 + fOptimizedParam.x)) * _783;
              float4 _815 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_809 * _797) + 0.5f), (((_809 * ((_753 * 2.0f) + -1.0f)) * (((_802 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _824 = (_754 * 2.0f) + -1.0f;
              float _828 = sqrt((_824 * _824) + 1.0f);
              float _829 = 1.0f / _828;
              float _836 = ((_828 * fOptimizedParam.z) * (_829 + fOptimizedParam.x)) * _783;
              float4 _842 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_836 * _824) + 0.5f), (((_836 * ((_755 * 2.0f) + -1.0f)) * (((_829 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _851 = (_756 * 2.0f) + -1.0f;
              float _855 = sqrt((_851 * _851) + 1.0f);
              float _856 = 1.0f / _855;
              float _863 = ((_855 * fOptimizedParam.z) * (_856 + fOptimizedParam.x)) * _783;
              float4 _869 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_863 * _851) + 0.5f), (((_863 * ((_757 * 2.0f) + -1.0f)) * (((_856 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _878 = (_758 * 2.0f) + -1.0f;
              float _882 = sqrt((_878 * _878) + 1.0f);
              float _883 = 1.0f / _882;
              float _890 = ((_882 * fOptimizedParam.z) * (_883 + fOptimizedParam.x)) * _783;
              float4 _896 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_890 * _878) + 0.5f), (((_890 * ((_759 * 2.0f) + -1.0f)) * (((_883 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _905 = (_760 * 2.0f) + -1.0f;
              float _909 = sqrt((_905 * _905) + 1.0f);
              float _910 = 1.0f / _909;
              float _917 = ((_909 * fOptimizedParam.z) * (_910 + fOptimizedParam.x)) * _783;
              float4 _923 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_917 * _905) + 0.5f), (((_917 * ((_761 * 2.0f) + -1.0f)) * (((_910 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _932 = (_762 * 2.0f) + -1.0f;
              float _936 = sqrt((_932 * _932) + 1.0f);
              float _937 = 1.0f / _936;
              float _944 = ((_936 * fOptimizedParam.z) * (_937 + fOptimizedParam.x)) * _783;
              float4 _950 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_944 * _932) + 0.5f), (((_944 * ((_763 * 2.0f) + -1.0f)) * (((_937 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _959 = (_764 * 2.0f) + -1.0f;
              float _963 = sqrt((_959 * _959) + 1.0f);
              float _964 = 1.0f / _963;
              float _971 = ((_963 * fOptimizedParam.z) * (_964 + fOptimizedParam.x)) * _783;
              float4 _977 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_971 * _959) + 0.5f), (((_971 * ((_765 * 2.0f) + -1.0f)) * (((_964 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _986 = (_766 * 2.0f) + -1.0f;
              float _990 = sqrt((_986 * _986) + 1.0f);
              float _991 = 1.0f / _990;
              float _998 = ((_990 * fOptimizedParam.z) * (_991 + fOptimizedParam.x)) * _783;
              float4 _1004 = RE_POSTPROCESS_Input0.SampleLevel(BilinearBorder, float2(((_998 * _986) + 0.5f), (((_998 * ((_767 * 2.0f) + -1.0f)) * (((_991 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1074 = ((((((((_815.x + _791.x) + _842.x) + _869.x) + _896.x) + _923.x) + _950.x) + _977.x) + _1004.x);
              _1075 = ((((((((_815.y + _791.y) + _842.y) + _869.y) + _896.y) + _923.y) + _950.y) + _977.y) + _1004.y);
              _1076 = ((((((((_815.z + _791.z) + _842.z) + _869.z) + _896.z) + _923.z) + _950.z) + _977.z) + _1004.z);
            } else {
              float4 _1013 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_749, _751), 0.0f);
              float4 _1017 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_752, _753), 0.0f);
              float4 _1024 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_754, _755), 0.0f);
              float4 _1031 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_756, _757), 0.0f);
              float4 _1038 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_758, _759), 0.0f);
              float4 _1045 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_760, _761), 0.0f);
              float4 _1052 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_762, _763), 0.0f);
              float4 _1059 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_764, _765), 0.0f);
              float4 _1066 = RE_POSTPROCESS_Input0.SampleLevel(BilinearClamp, float2(_766, _767), 0.0f);
              _1074 = ((((((((_1017.x + _1013.x) + _1024.x) + _1031.x) + _1038.x) + _1045.x) + _1052.x) + _1059.x) + _1066.x);
              _1075 = ((((((((_1017.y + _1013.y) + _1024.y) + _1031.y) + _1038.y) + _1045.y) + _1052.y) + _1059.y) + _1066.y);
              _1076 = ((((((((_1017.z + _1013.z) + _1024.z) + _1031.z) + _1038.z) + _1045.z) + _1052.z) + _1059.z) + _1066.z);
            }
          }
          float _1086 = (cbRadialColor.z * (_379 + (_458 * _1076))) * 0.10000000149011612f;
          float _1087 = (cbRadialColor.y * (_378 + (_458 * _1075))) * 0.10000000149011612f;
          float _1088 = (cbRadialColor.x * (_377 + (_458 * _1074))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1093 = saturate((_523 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1099 = (((_1093 * _1093) * cbRadialMaskRate.x) * (3.0f - (_1093 * 2.0f))) + cbRadialMaskRate.y;
              _1110 = ((_1099 * (_1088 - _377)) + _377);
              _1111 = ((_1099 * (_1087 - _378)) + _378);
              _1112 = ((_1099 * (_1086 - _379)) + _379);
            } else {
              _1110 = _1088;
              _1111 = _1087;
              _1112 = _1086;
            }
            _1123 = (lerp(_377, _1110, _476));
            _1124 = (lerp(_378, _1111, _476));
            _1125 = (lerp(_379, _1112, _476));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1123 = _377;
      _1124 = _378;
      _1125 = _379;
    }
  } else {
    _1123 = _377;
    _1124 = _378;
    _1125 = _379;
  }
  if (_116 && (bool)((cPassEnabled & 2) != 0)) {
    float _1133 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1135 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1141 = frac(frac((_1135 * 0.005837149918079376f) + (_1133 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1141 < fNoiseDensity) {
        int _1146 = (uint)(uint(_1135 * _1133)) ^ 12345391;
        uint _1147 = _1146 * 3635641;
        _1155 = (float((uint)((int)((((uint)(_1147) >> 26) | ((uint)(_1146 * 232681024))) ^ _1147))) * 2.3283064365386963e-10f);
      } else {
        _1155 = 0.0f;
      }
      float _1157 = frac(_1141 * 757.4846801757812f);
      do {
        if (_1157 < fNoiseDensity) {
          int _1161 = asint(_1157) ^ 12345391;
          uint _1162 = _1161 * 3635641;
          _1171 = ((float((uint)((int)((((uint)(_1162) >> 26) | ((uint)(_1161 * 232681024))) ^ _1162))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1171 = 0.0f;
        }
        float _1173 = frac(_1157 * 757.4846801757812f);
        do {
          if (_1173 < fNoiseDensity) {
            int _1177 = asint(_1173) ^ 12345391;
            uint _1178 = _1177 * 3635641;
            _1187 = ((float((uint)((int)((((uint)(_1178) >> 26) | ((uint)(_1177 * 232681024))) ^ _1178))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1187 = 0.0f;
          }
          float _1188 = _1155 * fNoisePower.x * CUSTOM_NOISE;
          float _1189 = _1187 * fNoisePower.y * CUSTOM_NOISE;
          float _1190 = _1171 * fNoisePower.y * CUSTOM_NOISE;
          float _1204 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1123), saturate(_1124), saturate(_1125)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1215 = ((_1204 * (mad(_1190, 1.4019999504089355f, _1188) - _1123)) + _1123);
          _1216 = ((_1204 * (mad(_1190, -0.7139999866485596f, mad(_1189, -0.3440000116825104f, _1188)) - _1124)) + _1124);
          _1217 = ((_1204 * (mad(_1189, 1.7719999551773071f, _1188) - _1125)) + _1125);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1215 = _1123;
    _1216 = _1124;
    _1217 = _1125;
  }
  float _1232 = mad(_1217, (fOCIOTransformMatrix[2].x), mad(_1216, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1215)));
  float _1235 = mad(_1217, (fOCIOTransformMatrix[2].y), mad(_1216, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1215)));
  float _1238 = mad(_1217, (fOCIOTransformMatrix[2].z), mad(_1216, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1215)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1244 = max(max(_1232, _1235), _1238);
    if (!(_1244 == 0.0f)) {
      float _1250 = abs(_1244);
      float _1251 = (_1244 - _1232) / _1250;
      float _1252 = (_1244 - _1235) / _1250;
      float _1253 = (_1244 - _1238) / _1250;
      do {
        if (!(!(_1251 >= cbControlRGCParam.CyanThreshold))) {
          float _1263 = _1251 - cbControlRGCParam.CyanThreshold;
          _1275 = ((_1263 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1263) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1275 = _1251;
        }
        do {
          if (!(!(_1252 >= cbControlRGCParam.MagentaThreshold))) {
            float _1284 = _1252 - cbControlRGCParam.MagentaThreshold;
            _1296 = ((_1284 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1284) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1296 = _1252;
          }
          do {
            if (!(!(_1253 >= cbControlRGCParam.YellowThreshold))) {
              float _1304 = _1253 - cbControlRGCParam.YellowThreshold;
              _1316 = ((_1304 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1304) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1316 = _1253;
            }
            _1324 = (_1244 - (_1275 * _1250));
            _1325 = (_1244 - (_1296 * _1250));
            _1326 = (_1244 - (_1316 * _1250));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1324 = _1232;
      _1325 = _1235;
      _1326 = _1238;
    }
  } else {
    _1324 = _1232;
    _1325 = _1235;
    _1326 = _1238;
  }
  #if 1
    ApplyColorCorrectTexturePass(
        _116,
        cPassEnabled,
        _1324,
        _1325,
        _1326,
        fTextureBlendRate,
        fTextureBlendRate2,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        fColorMatrix,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp,
        _1553,
        _1554,
        _1555);
  #else
  if (_116 && (bool)((cPassEnabled & 4) != 0)) {
    float _1377 = (((log2(select((_1324 < 3.0517578125e-05f), ((_1324 * 0.5f) + 1.52587890625e-05f), _1324)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1378 = (((log2(select((_1325 < 3.0517578125e-05f), ((_1325 * 0.5f) + 1.52587890625e-05f), _1325)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1379 = (((log2(select((_1326 < 3.0517578125e-05f), ((_1326 * 0.5f) + 1.52587890625e-05f), _1326)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _1382 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1377, _1378, _1379), 0.0f);
    float _1395 = max(exp2((_1382.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1396 = max(exp2((_1382.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1397 = max(exp2((_1382.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _1399 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1402 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1377, _1378, _1379), 0.0f);
        float _1424 = ((max(exp2((_1402.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1395) * fTextureBlendRate) + _1395;
        float _1425 = ((max(exp2((_1402.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1396) * fTextureBlendRate) + _1396;
        float _1426 = ((max(exp2((_1402.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1397) * fTextureBlendRate) + _1397;
        if (_1399) {
          float4 _1456 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1424 < 3.0517578125e-05f), ((_1424 * 0.5f) + 1.52587890625e-05f), _1424)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1425 < 3.0517578125e-05f), ((_1425 * 0.5f) + 1.52587890625e-05f), _1425)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1426 < 3.0517578125e-05f), ((_1426 * 0.5f) + 1.52587890625e-05f), _1426)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1537 = (((max(exp2((_1456.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1424) * fTextureBlendRate2) + _1424);
          _1538 = (((max(exp2((_1456.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1425) * fTextureBlendRate2) + _1425);
          _1539 = (((max(exp2((_1456.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1426) * fTextureBlendRate2) + _1426);
        } else {
          _1537 = _1424;
          _1538 = _1425;
          _1539 = _1426;
        }
      } else {
        if (_1399) {
          float4 _1511 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1395 < 3.0517578125e-05f), ((_1395 * 0.5f) + 1.52587890625e-05f), _1395)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1396 < 3.0517578125e-05f), ((_1396 * 0.5f) + 1.52587890625e-05f), _1396)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1397 < 3.0517578125e-05f), ((_1397 * 0.5f) + 1.52587890625e-05f), _1397)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1537 = (((max(exp2((_1511.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1395) * fTextureBlendRate2) + _1395);
          _1538 = (((max(exp2((_1511.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1396) * fTextureBlendRate2) + _1396);
          _1539 = (((max(exp2((_1511.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1397) * fTextureBlendRate2) + _1397);
        } else {
          _1537 = _1395;
          _1538 = _1396;
          _1539 = _1397;
        }
      }
      _1553 = (mad(_1539, (fColorMatrix[2].x), mad(_1538, (fColorMatrix[1].x), (_1537 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _1554 = (mad(_1539, (fColorMatrix[2].y), mad(_1538, (fColorMatrix[1].y), (_1537 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _1555 = (mad(_1539, (fColorMatrix[2].z), mad(_1538, (fColorMatrix[1].z), (_1537 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _1553 = _1324;
    _1554 = _1325;
    _1555 = _1326;
  }
  #endif
  if (_116 && (bool)((cPassEnabled & 8) != 0)) {
    _1588 = (((cvdR.x * _1553) + (cvdR.y * _1554)) + (cvdR.z * _1555));
    _1589 = (((cvdG.x * _1553) + (cvdG.y * _1554)) + (cvdG.z * _1555));
    _1590 = (((cvdB.x * _1553) + (cvdB.y * _1554)) + (cvdB.z * _1555));
  } else {
    _1588 = _1553;
    _1589 = _1554;
    _1590 = _1555;
  }
  float _1594 = screenInverseSize.x * SV_Position.x;
  float _1595 = screenInverseSize.y * SV_Position.y;
  float4 _1601 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1594, _1595), 0.0f);
  if (_116 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1615 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1594, _1595), 0.0f);
    float _1621 = ColorParam.x * _1601.x;
    float _1622 = ColorParam.y * _1601.y;
    float _1623 = ColorParam.z * _1601.z;
    float _1628 = (ColorParam.w * _1601.w) * saturate((_1615.x * Levels_Rate) + Levels_Range);
    do {
      if (_1621 < 0.5f) {
        _1640 = ((_1588 * 2.0f) * _1621);
      } else {
        _1640 = (1.0f - (((1.0f - _1588) * 2.0f) * (1.0f - _1621)));
      }
      do {
        if (_1622 < 0.5f) {
          _1652 = ((_1589 * 2.0f) * _1622);
        } else {
          _1652 = (1.0f - (((1.0f - _1589) * 2.0f) * (1.0f - _1622)));
        }
        do {
          if (_1623 < 0.5f) {
            _1664 = ((_1590 * 2.0f) * _1623);
          } else {
            _1664 = (1.0f - (((1.0f - _1590) * 2.0f) * (1.0f - _1623)));
          }
          _1675 = (lerp(_1588, _1640, _1628));
          _1676 = (lerp(_1589, _1652, _1628));
          _1677 = (lerp(_1590, _1664, _1628));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1675 = _1588;
    _1676 = _1589;
    _1677 = _1590;
  }
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      float _1717 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _1677, mad((RGBToXYZViaCrosstalkMatrix[0].y), _1676, ((RGBToXYZViaCrosstalkMatrix[0].x) * _1675)));
      float _1720 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _1677, mad((RGBToXYZViaCrosstalkMatrix[1].y), _1676, ((RGBToXYZViaCrosstalkMatrix[1].x) * _1675)));
      float _1725 = (_1720 + _1717) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _1677, mad((RGBToXYZViaCrosstalkMatrix[2].y), _1676, ((RGBToXYZViaCrosstalkMatrix[2].x) * _1675)));
      float _1726 = _1717 / _1725;
      float _1727 = _1720 / _1725;
      do {
        if (_1720 < curve_HDRip) {
          _1738 = (_1720 * exposureScale);
        } else {
          _1738 = ((log2((_1720 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        float _1740 = (_1726 / _1727) * _1738;
        float _1744 = (((1.0f - _1726) - _1727) / _1727) * _1738;
        _1793 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _1744, mad((XYZToRGBViaCrosstalkMatrix[0].y), _1738, (_1740 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
        _1794 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _1744, mad((XYZToRGBViaCrosstalkMatrix[1].y), _1738, (_1740 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
        _1795 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _1744, mad((XYZToRGBViaCrosstalkMatrix[2].y), _1738, (_1740 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
      } while (false);
    } else {
      do {
        if (_1675 < curve_HDRip) {
          _1771 = (exposureScale * _1675);
        } else {
          _1771 = ((log2((_1675 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        do {
          if (_1676 < curve_HDRip) {
            _1782 = (exposureScale * _1676);
          } else {
            _1782 = ((log2((_1676 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
          if (_1677 < curve_HDRip) {
            _1793 = _1771;
            _1794 = _1782;
            _1795 = (exposureScale * _1677);
          } else {
            _1793 = _1771;
            _1794 = _1782;
            _1795 = ((log2((_1677 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
        } while (false);
      } while (false);
    }
  } else {
    _1793 = _1675;
    _1794 = _1676;
    _1795 = _1677;
  }
  SV_Target.x = _1793;
  SV_Target.y = _1794;
  SV_Target.z = _1795;
  SV_Target.w = 1.0f;
  return SV_Target;
}
