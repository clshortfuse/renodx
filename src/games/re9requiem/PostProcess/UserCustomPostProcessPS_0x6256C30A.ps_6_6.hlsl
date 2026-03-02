#include "./PostProcess.hlsli"

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

Texture2D<float4> FilmGrain_Texture : register(t7);

Texture2D<float4> FilmDamage_Texture : register(t8);

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

cbuffer EnvironmentInfo : register(b1) {
  uint timeMillisecond : packoffset(c000.x);
  uint frameCount : packoffset(c000.y);
  uint isOddFrame : packoffset(c000.z);
  uint reserveEnvironmentInfo : packoffset(c000.w);
  float breakingPBRSpecularIntensity : packoffset(c001.x);
  float breakingPBRIBLReflectanceBias : packoffset(c001.y);
  float breakingPBRIBLIntensity : packoffset(c001.z);
  float breakingPBRCubemapReflectionScale : packoffset(c001.w);
  uint vrsTier2Enable : packoffset(c002.x);
  uint dynamicTextureTableNullBlackHandle : packoffset(c002.y);
  uint prevTimeMillisecond : packoffset(c002.z);
  uint bindlessMaterialMaxNum : packoffset(c002.w);
  float rtLightRadius : packoffset(c003.x);
  float accurateVelocityDistanceSq : packoffset(c003.y);
  float EnvironmentInfoReserved1 : packoffset(c003.z);
  float EnvironmentInfoReserved2 : packoffset(c003.w);
  float4 userGlobalParams[32] : packoffset(c004.x);
  uint4 dynamicTextureTableHandles[256] : packoffset(c036.x);
  uint4 bakedResourceSharedTablesHandles[32] : packoffset(c292.x);
};

cbuffer CheckerBoardInfo : register(b2) {
  float2 cbr : packoffset(c000.x);
  float cbr_scale : packoffset(c000.z);
  float cbr_using : packoffset(c000.w);
  float2 cbr_padding : packoffset(c001.x);
  float cbr_mipmapReadjustRatio : packoffset(c001.z);
  int cbr_mipmapReadjustable : packoffset(c001.w);
};

cbuffer CameraKerare : register(b3) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer LDRPostProcessParam : register(b4) {
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

// clang-format off
cbuffer CBControl : register(b5) {
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
  } cbControlRGCParam: packoffset(c005.x);
};
// clang-format on

cbuffer UserShaderLDRPostProcessSettings : register(b6) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
};

cbuffer UserMaterial : register(b7) {
  float4 VAR_FilmGrain_UVScale : packoffset(c000.x);
  float4 VAR_FilmDamage_UVScale : packoffset(c001.x);
  float4 VAR_FilmDamage_Color : packoffset(c002.x);
  float VAR_Animation_RefreshRate : packoffset(c003.x);
  float VAR_Debug_FilmGrain_Texture : packoffset(c003.y);
  float VAR_FilmGrain_Opacity : packoffset(c003.z);
  float VAR_FilmGrain_Size : packoffset(c003.w);
  float VAR_FilmGrain_Contrast : packoffset(c004.x);
  float VAR_FilmGrain_Curve : packoffset(c004.y);
  float VAR_FilmGrain_Saturate : packoffset(c004.z);
  float VAR_Debug_FilmDamage_Texture : packoffset(c004.w);
  float VAR_FilmDamage_Opacity : packoffset(c005.x);
  float VAR_FilmDamage_Size : packoffset(c005.y);
  float VAR_FilmDamage_Contrast : packoffset(c005.z);
  float VAR_FilmDamage_Curve : packoffset(c005.w);
};

SamplerState BilinearWrap : register(s4, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  float _48 = (float((uint)(int)(timeMillisecond)) * 0.0010000000474974513f) * VAR_Animation_RefreshRate;
  float _50 = floor(_48);
  float _54 = _50 * 0.5f;
  float _55 = floor(_48 * 0.5f) * 0.5f;
  float _62 = frac(abs(_54));
  float _63 = frac(abs(_55));
  float _83 = ((select((_55 >= (-0.0f - _55)), _63, (-0.0f - _63)) * 4.0f) + -1.0f) * ((screenInverseSize.y * SV_Position.y) + -0.5f);
  float _85 = ((screenSize.x / screenSize.y) * ((screenInverseSize.x * SV_Position.x) + -0.5f)) * ((select((_54 >= (-0.0f - _54)), _62, (-0.0f - _62)) * 4.0f) + -1.0f);
  float _99 = (_85 + frac(_50 * 0.4274809956550598f)) / max(0.0010000000474974513f, (VAR_FilmGrain_Size * VAR_FilmGrain_UVScale.x));
  float _100 = (_83 + frac(_50 * 0.5725190043449402f)) / max(0.0010000000474974513f, (VAR_FilmGrain_Size * VAR_FilmGrain_UVScale.y));
  float4 _114 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_99, _100), float2((cbr.x * ddx_coarse(_99)), (cbr.x * ddx_coarse(_100))), float2((cbr.y * ddy_coarse(_99)), (cbr.y * ddy_coarse(_100))), int2(0, 0));
  float _151;
  float _152;
  float _258;
  float _356;
  float _626;
  float _627;
  float _628;
  float _704;
  float _768;
  float _1323;
  float _1324;
  float _1325;
  float _1359;
  float _1360;
  float _1361;
  float _1372;
  float _1373;
  float _1374;
  float _1404;
  float _1420;
  float _1436;
  float _1464;
  float _1465;
  float _1466;
  float _1524;
  float _1545;
  float _1565;
  float _1573;
  float _1574;
  float _1575;
  float _1786;
  float _1787;
  float _1788;
  float _1802;
  float _1803;
  float _1804;
  float _1837;
  float _1838;
  float _1839;
  float _1889;
  float _1901;
  float _1913;
  float _1924;
  float _1925;
  float _1926;
  float _1956;
  float _1968;
  float _1980;
  [branch]
  if (VAR_FilmGrain_Saturate > 0.0f) {
    float _120 = _99 + 0.3330000042915344f;
    float _121 = _100 + 0.6660000085830688f;
    float _122 = _99 + 0.6660000085830688f;
    float _123 = _100 + 0.3330000042915344f;
    float4 _132 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_120, _121), float2((ddx_coarse(_120) * cbr.x), (ddx_coarse(_121) * cbr.x)), float2((ddy_coarse(_120) * cbr.y), (ddy_coarse(_121) * cbr.y)), int2(0, 0));
    float4 _142 = FilmGrain_Texture.SampleGrad(BilinearWrap, float2(_122, _123), float2((ddx_coarse(_122) * cbr.x), (ddx_coarse(_123) * cbr.x)), float2((ddy_coarse(_122) * cbr.y), (ddy_coarse(_123) * cbr.y)), int2(0, 0));
    _151 = (lerp(_114.x, _132.x, VAR_FilmGrain_Saturate));
    _152 = (lerp(_114.x, _142.x, VAR_FilmGrain_Saturate));
  } else {
    _151 = _114.x;
    _152 = _114.x;
  }
  float _154 = 1.0f - VAR_FilmGrain_Curve;
  float _159 = select((_154 < 0.5f), 0.0f, 1.0f);
  float _160 = 1.0f - abs((_154 * 2.0f) + -0.9960784316062927f);
  float _182 = exp2(log2(max((((1.0f - (_151 * 2.0f)) * _159) + _151), 9.999999974752427e-07f)) * _160);
  float _183 = exp2(log2(max((((1.0f - (_152 * 2.0f)) * _159) + _152), 9.999999974752427e-07f)) * _160);
  float _184 = exp2(log2(max(((_159 * (1.0f - (_114.x * 2.0f))) + _114.x), 9.999999974752427e-07f)) * _160);
  float _194 = ((1.0f - (_182 * 2.0f)) * _159) + _182;
  float _195 = ((1.0f - (_183 * 2.0f)) * _159) + _183;
  float _196 = ((1.0f - (_184 * 2.0f)) * _159) + _184;
  float _206 = (exp2(log2(max(VAR_FilmGrain_Contrast, 9.999999974752427e-07f)) * 10.0f) * -1428.26806640625f) + -14.426950454711914f;
  float _228 = ((saturate(1.0f / (exp2(_206 * (_194 + -0.5f)) + 1.0f)) - _194) * VAR_FilmGrain_Contrast) + _194;
  float _229 = ((saturate(1.0f / (exp2(_206 * (_195 + -0.5f)) + 1.0f)) - _195) * VAR_FilmGrain_Contrast) + _195;
  float _230 = ((saturate(1.0f / (exp2(_206 * (_196 + -0.5f)) + 1.0f)) - _196) * VAR_FilmGrain_Contrast) + _196;
  [branch]
  if (VAR_FilmDamage_Opacity > 0.0f) {
    float _243 = (frac(_50 * 0.44094499945640564f) + _85) / max(0.0010000000474974513f, (VAR_FilmDamage_UVScale.x * VAR_FilmDamage_Size));
    float _244 = (frac(_50 * 0.5511810183525085f) + _83) / max(0.0010000000474974513f, (VAR_FilmDamage_UVScale.y * VAR_FilmDamage_Size));
    float4 _254 = FilmDamage_Texture.SampleGrad(BilinearWrap, float2(_243, _244), float2((ddx_coarse(_243) * cbr.x), (ddx_coarse(_244) * cbr.x)), float2((ddy_coarse(_243) * cbr.y), (ddy_coarse(_244) * cbr.y)), int2(0, 0));
    _258 = (_254.x * VAR_FilmDamage_Opacity);
  } else {
    _258 = 0.0f;
  }
  float _260 = 1.0f - VAR_FilmDamage_Curve;
  float _265 = select((_260 < 0.5f), 0.0f, 1.0f);
  float _274 = exp2(log2(max((((1.0f - (_258 * 2.0f)) * _265) + _258), 9.999999974752427e-07f)) * (1.0f - abs((_260 * 2.0f) + -0.9960784316062927f)));
  float _278 = ((1.0f - (_274 * 2.0f)) * _265) + _274;
  [branch]
  if (film_aspect == 0.0f) {
    float _317 = Kerare.x / Kerare.w;
    float _318 = Kerare.y / Kerare.w;
    float _319 = Kerare.z / Kerare.w;
    float _323 = abs(rsqrt(dot(float3(_317, _318, _319), float3(_317, _318, _319))) * _319);
    float _328 = _323 * _323;
    _356 = ((_328 * _328) * (1.0f - saturate((_323 * kerare_scale) + kerare_offset)));
  } else {
    float _339 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _341 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _343 = sqrt(dot(float2(_341, _339), float2(_341, _339)));
    float _351 = (_343 * _343) + 1.0f;
    _356 = ((1.0f / (_351 * _351)) * (1.0f - saturate(((1.0f / (_343 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _359 = saturate(_356 + kerare_brightness) * Exposure;
  uint _360 = uint(float((uint)(int)(distortionType)));
  bool _365 = (LDRPPSettings_enabled != 0);
  bool _366 = ((cPassEnabled & 1) != 0);
  if (!(_366 && _365)) {
    float4 _376 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)));
    _626 = (min(_376.x, 65000.0f) * _359);
    _627 = (min(_376.y, 65000.0f) * _359);
    _628 = (min(_376.z, 65000.0f) * _359);
  } else {
    if (_360 == 0) {
      float _394 = (screenInverseSize.x * SV_Position.x) + -0.5f;
      float _395 = (screenInverseSize.y * SV_Position.y) + -0.5f;
      float _396 = dot(float2(_394, _395), float2(_394, _395));
      float _398 = (_396 * fDistortionCoef) + 1.0f;
      float _399 = _394 * fCorrectCoef;
      float _401 = _395 * fCorrectCoef;
      float _403 = (_399 * _398) + 0.5f;
      float _404 = (_401 * _398) + 0.5f;
      if ((uint)(uint(float((uint)(int)(aberrationEnable)))) == 0) {
        float4 _409 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_403, _404));
        _626 = (_409.x * _359);
        _627 = (_409.y * _359);
        _628 = (_409.z * _359);
      } else {
        float _428 = ((saturate((sqrt((_394 * _394) + (_395 * _395)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((uint)(uint(float((uint)(int)(aberrationBlurEnable)))) == 0)) {
          float _438 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
          float _439 = _428 * 2.0f;
          float _443 = (((_438 * _439) + _396) * fDistortionCoef) + 1.0f;
          float4 _448 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_443 * _399) + 0.5f), ((_443 * _401) + 0.5f)));
          float _454 = ((((_438 + 0.125f) * _439) + _396) * fDistortionCoef) + 1.0f;
          float4 _459 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_454 * _399) + 0.5f), ((_454 * _401) + 0.5f)));
          float _466 = ((((_438 + 0.25f) * _439) + _396) * fDistortionCoef) + 1.0f;
          float4 _471 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_466 * _399) + 0.5f), ((_466 * _401) + 0.5f)));
          float _480 = ((((_438 + 0.375f) * _439) + _396) * fDistortionCoef) + 1.0f;
          float4 _485 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_480 * _399) + 0.5f), ((_480 * _401) + 0.5f)));
          float _494 = ((((_438 + 0.5f) * _439) + _396) * fDistortionCoef) + 1.0f;
          float4 _499 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_494 * _399) + 0.5f), ((_494 * _401) + 0.5f)));
          float _505 = ((((_438 + 0.625f) * _439) + _396) * fDistortionCoef) + 1.0f;
          float4 _510 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_505 * _399) + 0.5f), ((_505 * _401) + 0.5f)));
          float _518 = ((((_438 + 0.75f) * _439) + _396) * fDistortionCoef) + 1.0f;
          float4 _523 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_518 * _399) + 0.5f), ((_518 * _401) + 0.5f)));
          float _538 = ((((_438 + 0.875f) * _439) + _396) * fDistortionCoef) + 1.0f;
          float4 _543 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_538 * _399) + 0.5f), ((_538 * _401) + 0.5f)));
          float _550 = ((((_438 + 1.0f) * _439) + _396) * fDistortionCoef) + 1.0f;
          float4 _555 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_550 * _399) + 0.5f), ((_550 * _401) + 0.5f)));
          float _558 = _359 * 0.3199999928474426f;
          _626 = ((((_459.x + _448.x) + (_471.x * 0.75f)) + (_485.x * 0.375f)) * _558);
          _627 = ((_359 * 0.3636363744735718f) * ((((_510.y + _485.y) * 0.625f) + _499.y) + ((_523.y + _471.y) * 0.25f)));
          _628 = (((((_523.z * 0.75f) + (_510.z * 0.375f)) + _543.z) + _555.z) * _558);
        } else {
          float _564 = _428 + _396;
          float _566 = (_564 * fDistortionCoef) + 1.0f;
          float _573 = ((_564 + _428) * fDistortionCoef) + 1.0f;
          float4 _578 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_403, _404));
          float4 _581 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_566 * _399) + 0.5f), ((_566 * _401) + 0.5f)));
          float4 _584 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_573 * _399) + 0.5f), ((_573 * _401) + 0.5f)));
          _626 = (_578.x * _359);
          _627 = (_581.y * _359);
          _628 = (_584.z * _359);
        }
      }
    } else {
      if (_360 == 1) {
        float _597 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
        float _601 = sqrt((_597 * _597) + 1.0f);
        float _602 = 1.0f / _601;
        float _610 = ((_601 * fOptimizedParam.z) * (_602 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        float4 _618 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_610 * _597) + 0.5f), (((_610 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_602 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _626 = (_618.x * _359);
        _627 = (_618.y * _359);
        _628 = (_618.z * _359);
      } else {
        _626 = 0.0f;
        _627 = 0.0f;
        _628 = 0.0f;
      }
    }
  }
  [branch]
  if (film_aspect == 0.0f) {
    float _665 = Kerare.x / Kerare.w;
    float _666 = Kerare.y / Kerare.w;
    float _667 = Kerare.z / Kerare.w;
    float _671 = abs(rsqrt(dot(float3(_665, _666, _667), float3(_665, _666, _667))) * _667);
    float _676 = _671 * _671;
    _704 = ((_676 * _676) * (1.0f - saturate((_671 * kerare_scale) + kerare_offset)));
  } else {
    float _687 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _689 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _691 = sqrt(dot(float2(_689, _687), float2(_689, _687)));
    float _699 = (_691 * _691) + 1.0f;
    _704 = ((1.0f / (_699 * _699)) * (1.0f - saturate(((1.0f / (_691 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  float _707 = saturate(_704 + kerare_brightness) * Exposure;
  if (_365 && (bool)((cPassEnabled & 32) != 0)) {
    float _718 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _722 = ComputeResultSRV[0].computeAlpha;
    float _725 = ((1.0f - _718) + (_722 * _718)) * cbRadialColor.w;
    if (!(_725 == 0.0f)) {
      float _731 = screenInverseSize.x * SV_Position.x;
      float _732 = screenInverseSize.y * SV_Position.y;
      float _734 = _731 + (-0.5f - cbRadialScreenPos.x);
      float _736 = _732 + (-0.5f - cbRadialScreenPos.y);
      float _739 = select((_734 < 0.0f), (1.0f - _731), _731);
      float _742 = select((_736 < 0.0f), (1.0f - _732), _732);
      do {
        if (!((cbRadialBlurFlags & 1) == 0)) {
          float _748 = rsqrt(dot(float2(_734, _736), float2(_734, _736))) * cbRadialSharpRange;
          uint _755 = uint(abs(_748 * _736)) + uint(abs(_748 * _734));
          uint _759 = ((_755 ^ 61) ^ ((uint)(_755) >> 16)) * 9;
          uint _762 = (((uint)(_759) >> 4) ^ _759) * 668265261;
          _768 = (float((uint)((int)(((uint)(_762) >> 15) ^ _762))) * 2.3283064365386963e-10f);
        } else {
          _768 = 1.0f;
        }
        float _772 = sqrt((_734 * _734) + (_736 * _736));
        float _774 = 1.0f / max(1.0f, _772);
        float _775 = _768 * _739;
        float _776 = cbRadialBlurPower * _774;
        float _777 = _776 * -0.0011111111380159855f;
        float _779 = _768 * _742;
        float _783 = ((_777 * _775) + 1.0f) * _734;
        float _784 = ((_777 * _779) + 1.0f) * _736;
        float _786 = _776 * -0.002222222276031971f;
        float _791 = ((_786 * _775) + 1.0f) * _734;
        float _792 = ((_786 * _779) + 1.0f) * _736;
        float _793 = _776 * -0.0033333334140479565f;
        float _798 = ((_793 * _775) + 1.0f) * _734;
        float _799 = ((_793 * _779) + 1.0f) * _736;
        float _800 = _776 * -0.004444444552063942f;
        float _805 = ((_800 * _775) + 1.0f) * _734;
        float _806 = ((_800 * _779) + 1.0f) * _736;
        float _807 = _776 * -0.0055555556900799274f;
        float _812 = ((_807 * _775) + 1.0f) * _734;
        float _813 = ((_807 * _779) + 1.0f) * _736;
        float _814 = _776 * -0.006666666828095913f;
        float _819 = ((_814 * _775) + 1.0f) * _734;
        float _820 = ((_814 * _779) + 1.0f) * _736;
        float _821 = _776 * -0.007777777966111898f;
        float _826 = ((_821 * _775) + 1.0f) * _734;
        float _827 = ((_821 * _779) + 1.0f) * _736;
        float _828 = _776 * -0.008888889104127884f;
        float _833 = ((_828 * _775) + 1.0f) * _734;
        float _834 = ((_828 * _779) + 1.0f) * _736;
        float _837 = _774 * ((cbRadialBlurPower * -0.009999999776482582f) * _768);
        float _842 = ((_837 * _739) + 1.0f) * _734;
        float _843 = ((_837 * _742) + 1.0f) * _736;
        do {
          if (_366 && (bool)(_360 == 0)) {
            float _845 = _783 + cbRadialScreenPos.x;
            float _846 = _784 + cbRadialScreenPos.y;
            float _850 = ((dot(float2(_845, _846), float2(_845, _846)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _856 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_850 * _845) + 0.5f), ((_850 * _846) + 0.5f)), 0.0f);
            float _860 = _791 + cbRadialScreenPos.x;
            float _861 = _792 + cbRadialScreenPos.y;
            float _865 = ((dot(float2(_860, _861), float2(_860, _861)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _870 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_865 * _860) + 0.5f), ((_865 * _861) + 0.5f)), 0.0f);
            float _877 = _798 + cbRadialScreenPos.x;
            float _878 = _799 + cbRadialScreenPos.y;
            float _882 = ((dot(float2(_877, _878), float2(_877, _878)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _887 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_882 * _877) + 0.5f), ((_882 * _878) + 0.5f)), 0.0f);
            float _894 = _805 + cbRadialScreenPos.x;
            float _895 = _806 + cbRadialScreenPos.y;
            float _899 = ((dot(float2(_894, _895), float2(_894, _895)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _904 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_899 * _894) + 0.5f), ((_899 * _895) + 0.5f)), 0.0f);
            float _911 = _812 + cbRadialScreenPos.x;
            float _912 = _813 + cbRadialScreenPos.y;
            float _916 = ((dot(float2(_911, _912), float2(_911, _912)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _921 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_916 * _911) + 0.5f), ((_916 * _912) + 0.5f)), 0.0f);
            float _928 = _819 + cbRadialScreenPos.x;
            float _929 = _820 + cbRadialScreenPos.y;
            float _933 = ((dot(float2(_928, _929), float2(_928, _929)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _938 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_933 * _928) + 0.5f), ((_933 * _929) + 0.5f)), 0.0f);
            float _945 = _826 + cbRadialScreenPos.x;
            float _946 = _827 + cbRadialScreenPos.y;
            float _950 = ((dot(float2(_945, _946), float2(_945, _946)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _955 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_950 * _945) + 0.5f), ((_950 * _946) + 0.5f)), 0.0f);
            float _962 = _833 + cbRadialScreenPos.x;
            float _963 = _834 + cbRadialScreenPos.y;
            float _967 = ((dot(float2(_962, _963), float2(_962, _963)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _972 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_967 * _962) + 0.5f), ((_967 * _963) + 0.5f)), 0.0f);
            float _979 = _842 + cbRadialScreenPos.x;
            float _980 = _843 + cbRadialScreenPos.y;
            float _984 = ((dot(float2(_979, _980), float2(_979, _980)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            float4 _989 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_984 * _979) + 0.5f), ((_984 * _980) + 0.5f)), 0.0f);
            _1323 = ((((((((_870.x + _856.x) + _887.x) + _904.x) + _921.x) + _938.x) + _955.x) + _972.x) + _989.x);
            _1324 = ((((((((_870.y + _856.y) + _887.y) + _904.y) + _921.y) + _938.y) + _955.y) + _972.y) + _989.y);
            _1325 = ((((((((_870.z + _856.z) + _887.z) + _904.z) + _921.z) + _938.z) + _955.z) + _972.z) + _989.z);
          } else {
            float _997 = cbRadialScreenPos.x + 0.5f;
            float _998 = _783 + _997;
            float _999 = cbRadialScreenPos.y + 0.5f;
            float _1000 = _784 + _999;
            float _1001 = _791 + _997;
            float _1002 = _792 + _999;
            float _1003 = _798 + _997;
            float _1004 = _799 + _999;
            float _1005 = _805 + _997;
            float _1006 = _806 + _999;
            float _1007 = _812 + _997;
            float _1008 = _813 + _999;
            float _1009 = _819 + _997;
            float _1010 = _820 + _999;
            float _1011 = _826 + _997;
            float _1012 = _827 + _999;
            float _1013 = _833 + _997;
            float _1014 = _834 + _999;
            float _1015 = _842 + _997;
            float _1016 = _843 + _999;
            if (_366 && (bool)(_360 == 1)) {
              float _1020 = (_998 * 2.0f) + -1.0f;
              float _1024 = sqrt((_1020 * _1020) + 1.0f);
              float _1025 = 1.0f / _1024;
              float _1032 = fOptimizedParam.w * 0.5f;
              float _1033 = ((_1024 * fOptimizedParam.z) * (_1025 + fOptimizedParam.x)) * _1032;
              float4 _1040 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1033 * _1020) + 0.5f), (((_1033 * ((_1000 * 2.0f) + -1.0f)) * (((_1025 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1046 = (_1001 * 2.0f) + -1.0f;
              float _1050 = sqrt((_1046 * _1046) + 1.0f);
              float _1051 = 1.0f / _1050;
              float _1058 = ((_1050 * fOptimizedParam.z) * (_1051 + fOptimizedParam.x)) * _1032;
              float4 _1064 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1058 * _1046) + 0.5f), (((_1058 * ((_1002 * 2.0f) + -1.0f)) * (((_1051 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1073 = (_1003 * 2.0f) + -1.0f;
              float _1077 = sqrt((_1073 * _1073) + 1.0f);
              float _1078 = 1.0f / _1077;
              float _1085 = ((_1077 * fOptimizedParam.z) * (_1078 + fOptimizedParam.x)) * _1032;
              float4 _1091 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1085 * _1073) + 0.5f), (((_1085 * ((_1004 * 2.0f) + -1.0f)) * (((_1078 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1100 = (_1005 * 2.0f) + -1.0f;
              float _1104 = sqrt((_1100 * _1100) + 1.0f);
              float _1105 = 1.0f / _1104;
              float _1112 = ((_1104 * fOptimizedParam.z) * (_1105 + fOptimizedParam.x)) * _1032;
              float4 _1118 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1112 * _1100) + 0.5f), (((_1112 * ((_1006 * 2.0f) + -1.0f)) * (((_1105 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1127 = (_1007 * 2.0f) + -1.0f;
              float _1131 = sqrt((_1127 * _1127) + 1.0f);
              float _1132 = 1.0f / _1131;
              float _1139 = ((_1131 * fOptimizedParam.z) * (_1132 + fOptimizedParam.x)) * _1032;
              float4 _1145 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1139 * _1127) + 0.5f), (((_1139 * ((_1008 * 2.0f) + -1.0f)) * (((_1132 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1154 = (_1009 * 2.0f) + -1.0f;
              float _1158 = sqrt((_1154 * _1154) + 1.0f);
              float _1159 = 1.0f / _1158;
              float _1166 = ((_1158 * fOptimizedParam.z) * (_1159 + fOptimizedParam.x)) * _1032;
              float4 _1172 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1166 * _1154) + 0.5f), (((_1166 * ((_1010 * 2.0f) + -1.0f)) * (((_1159 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1181 = (_1011 * 2.0f) + -1.0f;
              float _1185 = sqrt((_1181 * _1181) + 1.0f);
              float _1186 = 1.0f / _1185;
              float _1193 = ((_1185 * fOptimizedParam.z) * (_1186 + fOptimizedParam.x)) * _1032;
              float4 _1199 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1193 * _1181) + 0.5f), (((_1193 * ((_1012 * 2.0f) + -1.0f)) * (((_1186 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1208 = (_1013 * 2.0f) + -1.0f;
              float _1212 = sqrt((_1208 * _1208) + 1.0f);
              float _1213 = 1.0f / _1212;
              float _1220 = ((_1212 * fOptimizedParam.z) * (_1213 + fOptimizedParam.x)) * _1032;
              float4 _1226 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1220 * _1208) + 0.5f), (((_1220 * ((_1014 * 2.0f) + -1.0f)) * (((_1213 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              float _1235 = (_1015 * 2.0f) + -1.0f;
              float _1239 = sqrt((_1235 * _1235) + 1.0f);
              float _1240 = 1.0f / _1239;
              float _1247 = ((_1239 * fOptimizedParam.z) * (_1240 + fOptimizedParam.x)) * _1032;
              float4 _1253 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1247 * _1235) + 0.5f), (((_1247 * ((_1016 * 2.0f) + -1.0f)) * (((_1240 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1323 = ((((((((_1064.x + _1040.x) + _1091.x) + _1118.x) + _1145.x) + _1172.x) + _1199.x) + _1226.x) + _1253.x);
              _1324 = ((((((((_1064.y + _1040.y) + _1091.y) + _1118.y) + _1145.y) + _1172.y) + _1199.y) + _1226.y) + _1253.y);
              _1325 = ((((((((_1064.z + _1040.z) + _1091.z) + _1118.z) + _1145.z) + _1172.z) + _1199.z) + _1226.z) + _1253.z);
            } else {
              float4 _1262 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_998, _1000), 0.0f);
              float4 _1266 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1001, _1002), 0.0f);
              float4 _1273 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1003, _1004), 0.0f);
              float4 _1280 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1005, _1006), 0.0f);
              float4 _1287 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1007, _1008), 0.0f);
              float4 _1294 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1009, _1010), 0.0f);
              float4 _1301 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1011, _1012), 0.0f);
              float4 _1308 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1013, _1014), 0.0f);
              float4 _1315 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1015, _1016), 0.0f);
              _1323 = ((((((((_1266.x + _1262.x) + _1273.x) + _1280.x) + _1287.x) + _1294.x) + _1301.x) + _1308.x) + _1315.x);
              _1324 = ((((((((_1266.y + _1262.y) + _1273.y) + _1280.y) + _1287.y) + _1294.y) + _1301.y) + _1308.y) + _1315.y);
              _1325 = ((((((((_1266.z + _1262.z) + _1273.z) + _1280.z) + _1287.z) + _1294.z) + _1301.z) + _1308.z) + _1315.z);
            }
          }
          float _1335 = (cbRadialColor.z * (_628 + (_707 * _1325))) * 0.10000000149011612f;
          float _1336 = (cbRadialColor.y * (_627 + (_707 * _1324))) * 0.10000000149011612f;
          float _1337 = (cbRadialColor.x * (_626 + (_707 * _1323))) * 0.10000000149011612f;
          do {
            if (cbRadialMaskRate.x > 0.0f) {
              float _1342 = saturate((_772 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              float _1348 = (((_1342 * _1342) * cbRadialMaskRate.x) * (3.0f - (_1342 * 2.0f))) + cbRadialMaskRate.y;
              _1359 = ((_1348 * (_1337 - _626)) + _626);
              _1360 = ((_1348 * (_1336 - _627)) + _627);
              _1361 = ((_1348 * (_1335 - _628)) + _628);
            } else {
              _1359 = _1337;
              _1360 = _1336;
              _1361 = _1335;
            }
            _1372 = (lerp(_626, _1359, _725));
            _1373 = (lerp(_627, _1360, _725));
            _1374 = (lerp(_628, _1361, _725));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1372 = _626;
      _1373 = _627;
      _1374 = _628;
    }
  } else {
    _1372 = _626;
    _1373 = _627;
    _1374 = _628;
  }
  if (_365 && (bool)((cPassEnabled & 2) != 0)) {
    float _1382 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _1384 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _1390 = frac(frac((_1384 * 0.005837149918079376f) + (_1382 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      if (_1390 < fNoiseDensity) {
        int _1395 = (uint)(uint(_1384 * _1382)) ^ 12345391;
        uint _1396 = _1395 * 3635641;
        _1404 = (float((uint)((int)((((uint)(_1396) >> 26) | ((uint)(_1395 * 232681024))) ^ _1396))) * 2.3283064365386963e-10f);
      } else {
        _1404 = 0.0f;
      }
      float _1406 = frac(_1390 * 757.4846801757812f);
      do {
        if (_1406 < fNoiseDensity) {
          int _1410 = asint(_1406) ^ 12345391;
          uint _1411 = _1410 * 3635641;
          _1420 = ((float((uint)((int)((((uint)(_1411) >> 26) | ((uint)(_1410 * 232681024))) ^ _1411))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1420 = 0.0f;
        }
        float _1422 = frac(_1406 * 757.4846801757812f);
        do {
          if (_1422 < fNoiseDensity) {
            int _1426 = asint(_1422) ^ 12345391;
            uint _1427 = _1426 * 3635641;
            _1436 = ((float((uint)((int)((((uint)(_1427) >> 26) | ((uint)(_1426 * 232681024))) ^ _1427))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1436 = 0.0f;
          }
          float _1437 = _1404 * fNoisePower.x * CUSTOM_NOISE;
          float _1438 = _1436 * fNoisePower.y * CUSTOM_NOISE;
          float _1439 = _1420 * fNoisePower.y * CUSTOM_NOISE;
          float _1453 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1372), saturate(_1373), saturate(_1374)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1464 = ((_1453 * (mad(_1439, 1.4019999504089355f, _1437) - _1372)) + _1372);
          _1465 = ((_1453 * (mad(_1439, -0.7139999866485596f, mad(_1438, -0.3440000116825104f, _1437)) - _1373)) + _1373);
          _1466 = ((_1453 * (mad(_1438, 1.7719999551773071f, _1437) - _1374)) + _1374);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1464 = _1372;
    _1465 = _1373;
    _1466 = _1374;
  }
  float _1481 = mad(_1466, (fOCIOTransformMatrix[2].x), mad(_1465, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1464)));
  float _1484 = mad(_1466, (fOCIOTransformMatrix[2].y), mad(_1465, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1464)));
  float _1487 = mad(_1466, (fOCIOTransformMatrix[2].z), mad(_1465, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1464)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _1493 = max(max(_1481, _1484), _1487);
    if (!(_1493 == 0.0f)) {
      float _1499 = abs(_1493);
      float _1500 = (_1493 - _1481) / _1499;
      float _1501 = (_1493 - _1484) / _1499;
      float _1502 = (_1493 - _1487) / _1499;
      do {
        if (!(!(_1500 >= cbControlRGCParam.CyanThreshold))) {
          float _1512 = _1500 - cbControlRGCParam.CyanThreshold;
          _1524 = ((_1512 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1512) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        } else {
          _1524 = _1500;
        }
        do {
          if (!(!(_1501 >= cbControlRGCParam.MagentaThreshold))) {
            float _1533 = _1501 - cbControlRGCParam.MagentaThreshold;
            _1545 = ((_1533 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1533) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          } else {
            _1545 = _1501;
          }
          do {
            if (!(!(_1502 >= cbControlRGCParam.YellowThreshold))) {
              float _1553 = _1502 - cbControlRGCParam.YellowThreshold;
              _1565 = ((_1553 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1553) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            } else {
              _1565 = _1502;
            }
            _1573 = (_1493 - (_1524 * _1499));
            _1574 = (_1493 - (_1545 * _1499));
            _1575 = (_1493 - (_1565 * _1499));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1573 = _1481;
      _1574 = _1484;
      _1575 = _1487;
    }
  } else {
    _1573 = _1481;
    _1574 = _1484;
    _1575 = _1487;
  }
#if 1
  ApplyColorCorrectTexturePass(
      _365,
      cPassEnabled,
      _1573,
      _1574,
      _1575,
      fTextureBlendRate,
      fTextureBlendRate2,
      fTextureSize,
      fOneMinusTextureInverseSize,
      fHalfTextureInverseSize,
      fColorMatrix,
      tTextureMap0,
      tTextureMap1,
      tTextureMap2,
      TrilinearClamp,
      _1802,
      _1803,
      _1804);
#else
  if (_365 && (bool)((cPassEnabled & 4) != 0)) {
    float _1626 = (((log2(select((_1573 < 3.0517578125e-05f), ((_1573 * 0.5f) + 1.52587890625e-05f), _1573)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1627 = (((log2(select((_1574 < 3.0517578125e-05f), ((_1574 * 0.5f) + 1.52587890625e-05f), _1574)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float _1628 = (((log2(select((_1575 < 3.0517578125e-05f), ((_1575 * 0.5f) + 1.52587890625e-05f), _1575)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize;
    float4 _1631 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1626, _1627, _1628), 0.0f);
    float _1644 = max(exp2((_1631.x * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1645 = max(exp2((_1631.y * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    float _1646 = max(exp2((_1631.z * 17.520000457763672f) + -9.720000267028809f), 0.0f);
    bool _1648 = (fTextureBlendRate2 > 0.0f);
    do {
      [branch]
      if (fTextureBlendRate > 0.0f) {
        float4 _1651 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1626, _1627, _1628), 0.0f);
        float _1673 = ((max(exp2((_1651.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1644) * fTextureBlendRate) + _1644;
        float _1674 = ((max(exp2((_1651.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1645) * fTextureBlendRate) + _1645;
        float _1675 = ((max(exp2((_1651.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1646) * fTextureBlendRate) + _1646;
        if (_1648) {
          float4 _1705 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1673 < 3.0517578125e-05f), ((_1673 * 0.5f) + 1.52587890625e-05f), _1673)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1674 < 3.0517578125e-05f), ((_1674 * 0.5f) + 1.52587890625e-05f), _1674)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1675 < 3.0517578125e-05f), ((_1675 * 0.5f) + 1.52587890625e-05f), _1675)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1786 = (((max(exp2((_1705.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1673) * fTextureBlendRate2) + _1673);
          _1787 = (((max(exp2((_1705.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1674) * fTextureBlendRate2) + _1674);
          _1788 = (((max(exp2((_1705.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1675) * fTextureBlendRate2) + _1675);
        } else {
          _1786 = _1673;
          _1787 = _1674;
          _1788 = _1675;
        }
      } else {
        if (_1648) {
          float4 _1760 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((((log2(select((_1644 < 3.0517578125e-05f), ((_1644 * 0.5f) + 1.52587890625e-05f), _1644)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1645 < 3.0517578125e-05f), ((_1645 * 0.5f) + 1.52587890625e-05f), _1645)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((((log2(select((_1646 < 3.0517578125e-05f), ((_1646 * 0.5f) + 1.52587890625e-05f), _1646)) * 0.05707760155200958f) + 0.5547950267791748f) * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          _1786 = (((max(exp2((_1760.x * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1644) * fTextureBlendRate2) + _1644);
          _1787 = (((max(exp2((_1760.y * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1645) * fTextureBlendRate2) + _1645);
          _1788 = (((max(exp2((_1760.z * 17.520000457763672f) + -9.720000267028809f), 0.0f) - _1646) * fTextureBlendRate2) + _1646);
        } else {
          _1786 = _1644;
          _1787 = _1645;
          _1788 = _1646;
        }
      }
      _1802 = (mad(_1788, (fColorMatrix[2].x), mad(_1787, (fColorMatrix[1].x), (_1786 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
      _1803 = (mad(_1788, (fColorMatrix[2].y), mad(_1787, (fColorMatrix[1].y), (_1786 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
      _1804 = (mad(_1788, (fColorMatrix[2].z), mad(_1787, (fColorMatrix[1].z), (_1786 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
    } while (false);
  } else {
    _1802 = _1573;
    _1803 = _1574;
    _1804 = _1575;
  }
#endif
  if (_365 && (bool)((cPassEnabled & 8) != 0)) {
    _1837 = (((cvdR.x * _1802) + (cvdR.y * _1803)) + (cvdR.z * _1804));
    _1838 = (((cvdG.x * _1802) + (cvdG.y * _1803)) + (cvdG.z * _1804));
    _1839 = (((cvdB.x * _1802) + (cvdB.y * _1803)) + (cvdB.z * _1804));
  } else {
    _1837 = _1802;
    _1838 = _1803;
    _1839 = _1804;
  }
  float _1843 = screenInverseSize.x * SV_Position.x;
  float _1844 = screenInverseSize.y * SV_Position.y;
  float4 _1850 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1843, _1844), 0.0f);
  if (_365 && (bool)(asint(float((bool)(bool)((cPassEnabled & 16) != 0))) != 0)) {
    float _1864 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1843, _1844), 0.0f);
    float _1870 = ColorParam.x * _1850.x;
    float _1871 = ColorParam.y * _1850.y;
    float _1872 = ColorParam.z * _1850.z;
    float _1877 = (ColorParam.w * _1850.w) * saturate((_1864.x * Levels_Rate) + Levels_Range);
    do {
      if (_1870 < 0.5f) {
        _1889 = ((_1837 * 2.0f) * _1870);
      } else {
        _1889 = (1.0f - (((1.0f - _1837) * 2.0f) * (1.0f - _1870)));
      }
      do {
        if (_1871 < 0.5f) {
          _1901 = ((_1838 * 2.0f) * _1871);
        } else {
          _1901 = (1.0f - (((1.0f - _1838) * 2.0f) * (1.0f - _1871)));
        }
        do {
          if (_1872 < 0.5f) {
            _1913 = ((_1839 * 2.0f) * _1872);
          } else {
            _1913 = (1.0f - (((1.0f - _1839) * 2.0f) * (1.0f - _1872)));
          }
          _1924 = (lerp(_1837, _1889, _1877));
          _1925 = (lerp(_1838, _1901, _1877));
          _1926 = (lerp(_1839, _1913, _1877));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1924 = _1837;
    _1925 = _1838;
    _1926 = _1839;
  }
  float _1944 = ((saturate(1.0f / (exp2(((_278 + -0.5f) * -1.4426950216293335f) * ((exp2(log2(max(VAR_FilmDamage_Contrast, 9.999999974752427e-07f)) * 10.0f) * 990.0f) + 10.0f)) + 1.0f)) - _278) * VAR_FilmDamage_Contrast) + _278;
  if (_1924 < 0.5f) {
    _1956 = ((_228 * 2.0f) * _1924);
  } else {
    _1956 = (1.0f - (((1.0f - _228) * 2.0f) * (1.0f - _1924)));
  }
  if (_1925 < 0.5f) {
    _1968 = ((_229 * 2.0f) * _1925);
  } else {
    _1968 = (1.0f - (((1.0f - _229) * 2.0f) * (1.0f - _1925)));
  }
  if (_1926 < 0.5f) {
    _1980 = ((_230 * 2.0f) * _1926);
  } else {
    _1980 = (1.0f - (((1.0f - _230) * 2.0f) * (1.0f - _1926)));
  }
  float _1989 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1956 - _1924)) + _1924;
  float _1990 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1968 - _1925)) + _1925;
  float _1991 = (CUSTOM_VANILLA_GRAIN_STRENGTH * VAR_FilmGrain_Opacity * (_1980 - _1926)) + _1926;
  float _2002 = ((VAR_FilmDamage_Color.x - _1989) * _1944) + _1989;
  float _2003 = ((VAR_FilmDamage_Color.y - _1990) * _1944) + _1990;
  float _2004 = ((VAR_FilmDamage_Color.z - _1991) * _1944) + _1991;
  float _2012 = ((_228 - _2002) * VAR_Debug_FilmGrain_Texture) + _2002;
  float _2013 = ((_229 - _2003) * VAR_Debug_FilmGrain_Texture) + _2003;
  float _2014 = ((_230 - _2004) * VAR_Debug_FilmGrain_Texture) + _2004;
  SV_Target.x = (lerp(_2012, _1944, VAR_Debug_FilmDamage_Texture));
  SV_Target.y = (lerp(_2013, _1944, VAR_Debug_FilmDamage_Texture));
  SV_Target.z = (lerp(_2014, _1944, VAR_Debug_FilmDamage_Texture));
  SV_Target.w = 1.0f;
  return SV_Target;
}
