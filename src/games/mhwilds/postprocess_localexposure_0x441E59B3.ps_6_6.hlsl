#define USE_LOCALEXPOSURE_HDR

#include "./postprocess.hlsl"

struct RadialBlurComputeResult {
  float computeAlpha;
};

Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> RE_POSTPROCESS_Color : register(t1);

Buffer<uint4> WhitePtSrv : register(t2);

Texture3D<float2> BilateralLuminanceSRV : register(t3);

Texture2D<float> BlurredLogLumSRV : register(t4);

Texture2D<float> tFilterTempMap1 : register(t5);

Texture3D<float> tVolumeMap : register(t6);

Texture2D<float2> HazeNoiseResult : register(t7);

StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t8);

Texture3D<float4> tTextureMap0 : register(t9);

Texture3D<float4> tTextureMap1 : register(t10);

Texture3D<float4> tTextureMap2 : register(t11);

Texture2D<float4> ImagePlameBase : register(t12);

Texture2D<float> ImagePlameAlpha : register(t13);

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
  float SceneInfo_Reserve0 : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  float2 SceneInfo_Reserve2 : packoffset(c038.z);
};

cbuffer RangeCompressInfo : register(b1) {
  float rangeCompress : packoffset(c000.x);
  float rangeDecompress : packoffset(c000.y);
  float prevRangeCompress : packoffset(c000.z);
  float prevRangeDecompress : packoffset(c000.w);
  float rangeCompressForResource : packoffset(c001.x);
  float rangeDecompressForResource : packoffset(c001.y);
  float rangeCompressForCommon : packoffset(c001.z);
  float rangeDecompressForCommon : packoffset(c001.w);
};

cbuffer Tonemap : register(b2) {
  float exposureAdjustment : packoffset(c000.x);
  float tonemapRange : packoffset(c000.y);
  float specularSuppression : packoffset(c000.z);
  float sharpness : packoffset(c000.w);
  float preTonemapRange : packoffset(c001.x);
  int useAutoExposure : packoffset(c001.y);
  float echoBlend : packoffset(c001.z);
  float AABlend : packoffset(c001.w);
  float AASubPixel : packoffset(c002.x);
  float ResponsiveAARate : packoffset(c002.y);
  float VelocityWeightRate : packoffset(c002.z);
  float DepthRejectionRate : packoffset(c002.w);
  float ContrastTrackingRate : packoffset(c003.x);
  float ContrastTrackingThreshold : packoffset(c003.y);
  float LEHighlightContrast : packoffset(c003.z);
  float LEShadowContrast : packoffset(c003.w);
  float LEDetailStrength : packoffset(c004.x);
  float LEMiddleGreyLog : packoffset(c004.y);
  float LEBilateralGridScale : packoffset(c004.z);
  float LEBilateralGridBias : packoffset(c004.w);
  float LEPreExposureLog : packoffset(c005.x);
  int LEBlurredLogDownsampleMip : packoffset(c005.y);
  int2 LELuminanceTextureSize : packoffset(c005.z);
};

cbuffer CameraKerare : register(b3) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

cbuffer TonemapParam : register(b4) {
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

cbuffer LDRPostProcessParam : register(b5) {
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

cbuffer CBControl : register(b6) {
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

SamplerState PointClamp : register(s1, space32);

SamplerState BilinearWrap : register(s4, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {

    // float _472 = exp2((((select((_460 > 0.0f), LEHighlightContrast, LEShadowContrast) * _460) - _457) + LEMiddleGreyLog) + (LEDetailStrength * (_457 - _456)));

    float4 SV_Target;

    LocalExposureInputs inputs;
    inputs.BilateralLuminanceSRV = BilateralLuminanceSRV;
    inputs.BlurredLogLumSRV = BlurredLogLumSRV;
    inputs.BilinearClamp = BilinearClamp;
    inputs.screenSize = screenSize;
    inputs.screenInverseSize = screenInverseSize;
    inputs.useAutoExposure = useAutoExposure;
    inputs.exposureAdjustment = exposureAdjustment;
    inputs.LEPreExposureLog = LEPreExposureLog;
    inputs.LEMiddleGreyLog = LEMiddleGreyLog;
    inputs.LEBilateralGridScale = LEBilateralGridScale;
    inputs.LEBilateralGridBias = LEBilateralGridBias;
    inputs.LEHighlightContrast = LEHighlightContrast;
    inputs.LEShadowContrast = LEShadowContrast;
    inputs.LEDetailStrength = LEDetailStrength;
    inputs.WhitePtSrv = WhitePtSrv;
    inputs.rangeDecompress = rangeDecompress;

  bool _44 = ((cPassEnabled & 1) == 0);
  bool _50;
  bool _56;
  float _105;
  float _250;
  float _251;
  float _273;
  float _393;
  float _394;
  float _402;
  float _403;
  float _421;
  float _800;
  float _801;
  float _823;
  float _943;
  float _944;
  float _952;
  float _953;
  float _971;
  float _1051;
  float _1217;
  float _1218;
  float _1242;
  float _1362;
  float _1363;
  float _1369;
  float _1370;
  float _1390;
  float _1446;
  float _1447;
  float _1448;
  float _1453;
  float _1454;
  float _1455;
  float _1456;
  float _1457;
  float _1458;
  float _1459;
  float _1460;
  float _1461;
  float _1536;
  float _2139;
  float _2140;
  float _2141;
  float _2179;
  float _2180;
  float _2181;
  float _2192;
  float _2193;
  float _2194;
  float _2252;
  float _2273;
  float _2293;
  float _2301;
  float _2302;
  float _2303;
  float _2340;
  float _2356;
  float _2372;
  float _2400;
  float _2401;
  float _2402;
  float _2437;
  float _2447;
  float _2457;
  float _2483;
  float _2497;
  float _2511;
  float _2522;
  float _2531;
  float _2540;
  float _2565;
  float _2579;
  float _2593;
  float _2614;
  float _2624;
  float _2634;
  float _2659;
  float _2673;
  float _2687;
  float _2709;
  float _2719;
  float _2729;
  float _2754;
  float _2768;
  float _2782;
  float _2793;
  float _2794;
  float _2795;
  float _2809;
  float _2810;
  float _2811;
  float _2855;
  float _2856;
  float _2857;
  float _2903;
  float _2915;
  float _2927;
  float _2938;
  float _2939;
  float _2940;
  float _2956;
  float _2965;
  float _2974;
  float _3045;
  float _3046;
  float _3047;
  if (!_44) {
    _50 = (distortionType == 0);
  } else {
    _50 = false;
  }
  if (!_44) {
    _56 = ((distortionType == 1) && (CUSTOM_LENS_DISTORTION == 1));
  } else {
    _56 = false;
  }
  bool _58 = ((cPassEnabled & 64) != 0);
  [branch]
  if (film_aspect == 0.0f) {
    float _66 = Kerare.x / Kerare.w;
    float _67 = Kerare.y / Kerare.w;
    float _68 = Kerare.z / Kerare.w;
    float _72 = abs(rsqrt(dot(float3(_66, _67, _68), float3(_66, _67, _68))) * _68);
    float _77 = _72 * _72;
    _105 = ((_77 * _77) * (1.0f - saturate((kerare_scale * _72) + kerare_offset)));
  } else {
    float _88 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    float _90 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    float _92 = sqrt(dot(float2(_90, _88), float2(_90, _88)));
    float _100 = (_92 * _92) + 1.0f;
    _105 = ((1.0f / (_100 * _100)) * (1.0f - saturate((kerare_scale * (1.0f / (_92 + 1.0f))) + kerare_offset)));
  }
  float _107 = saturate(_105 + kerare_brightness);

  CustomVignette(_107);

  float _108 = _107 * Exposure;
  if (_50) {
    float _125 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _126 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _127 = dot(float2(_125, _126), float2(_125, _126));
    float _130 = ((_127 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float _131 = _130 * _125;
    float _132 = _130 * _126;
    float _133 = _131 + 0.5f;
    float _134 = _132 + 0.5f;
    if (aberrationEnable == 0) {
      if (_58) {
        if (!(fHazeFilterReductionResolution == 0)) {
          float2 _144 = HazeNoiseResult.Sample(BilinearWrap, float2(_133, _134));
          _402 = ((fHazeFilterScale * _144.x) + _133);
          _403 = ((fHazeFilterScale * _144.y) + _134);
        } else {
          bool _156 = ((fHazeFilterAttribute & 2) != 0);
          float _160 = tFilterTempMap1.Sample(BilinearWrap, float2(_133, _134));
          if (_156) {
            float _167 = ReadonlyDepth.SampleLevel(PointClamp, float2(_133, _134), 0.0f);
            float _175 = (((_133 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
            float _176 = 1.0f - (((_134 * 2.0f) * screenSize.y) * screenInverseSize.y);
            float _213 = 1.0f / (mad(_167.x, (viewProjInvMat[2].w), mad(_176, (viewProjInvMat[1].w), (_175 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
            float _215 = _213 * (mad(_167.x, (viewProjInvMat[2].y), mad(_176, (viewProjInvMat[1].y), (_175 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
            float _223 = (_213 * (mad(_167.x, (viewProjInvMat[2].x), mad(_176, (viewProjInvMat[1].x), (_175 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
            float _224 = _215 - (transposeViewInvMat[1].w);
            float _225 = (_213 * (mad(_167.x, (viewProjInvMat[2].z), mad(_176, (viewProjInvMat[1].z), (_175 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
            _250 = saturate(_160.x * max(((sqrt(((_224 * _224) + (_223 * _223)) + (_225 * _225)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_215 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
            _251 = _167.x;
          } else {
            _250 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _160.x), _160.x);
            _251 = 0.0f;
          }
          if (!((fHazeFilterAttribute & 4) == 0)) {
            float _263 = 0.5f / fHazeFilterBorder;
            _273 = (1.0f - saturate(max(((_263 * min(max((abs(_131) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_263 * min(max((abs(_132) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade))));
          } else {
            _273 = 1.0f;
          }
          float _274 = _273 * _250;
          if (!(_274 <= 9.999999747378752e-06f)) {
            float _281 = -0.0f - _134;
            float _304 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_281, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _133)));
            float _305 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_281, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _133)));
            float _306 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_281, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _133)));
            float _312 = tVolumeMap.Sample(BilinearWrap, float3((_304 + fHazeFilterUVWOffset.x), (_305 + fHazeFilterUVWOffset.y), (_306 + fHazeFilterUVWOffset.z)));
            float _315 = _304 * 2.0f;
            float _316 = _305 * 2.0f;
            float _317 = _306 * 2.0f;
            float _321 = tVolumeMap.Sample(BilinearWrap, float3((_315 + fHazeFilterUVWOffset.x), (_316 + fHazeFilterUVWOffset.y), (_317 + fHazeFilterUVWOffset.z)));
            float _325 = _304 * 4.0f;
            float _326 = _305 * 4.0f;
            float _327 = _306 * 4.0f;
            float _331 = tVolumeMap.Sample(BilinearWrap, float3((_325 + fHazeFilterUVWOffset.x), (_326 + fHazeFilterUVWOffset.y), (_327 + fHazeFilterUVWOffset.z)));
            float _335 = _304 * 8.0f;
            float _336 = _305 * 8.0f;
            float _337 = _306 * 8.0f;
            float _341 = tVolumeMap.Sample(BilinearWrap, float3((_335 + fHazeFilterUVWOffset.x), (_336 + fHazeFilterUVWOffset.y), (_337 + fHazeFilterUVWOffset.z)));
            float _345 = fHazeFilterUVWOffset.x + 0.5f;
            float _346 = fHazeFilterUVWOffset.y + 0.5f;
            float _347 = fHazeFilterUVWOffset.z + 0.5f;
            float _351 = tVolumeMap.Sample(BilinearWrap, float3((_304 + _345), (_305 + _346), (_306 + _347)));
            float _357 = tVolumeMap.Sample(BilinearWrap, float3((_315 + _345), (_316 + _346), (_317 + _347)));
            float _364 = tVolumeMap.Sample(BilinearWrap, float3((_325 + _345), (_326 + _346), (_327 + _347)));
            float _371 = tVolumeMap.Sample(BilinearWrap, float3((_335 + _345), (_336 + _346), (_337 + _347)));
            float _379 = ((((((_321.x * 0.25f) + (_312.x * 0.5f)) + (_331.x * 0.125f)) + (_341.x * 0.0625f)) * 2.0f) + -1.0f) * _274;
            float _380 = ((((((_357.x * 0.25f) + (_351.x * 0.5f)) + (_364.x * 0.125f)) + (_371.x * 0.0625f)) * 2.0f) + -1.0f) * _274;
            if (_156) {
              float _385 = ReadonlyDepth.Sample(BilinearWrap, float2((_379 + _133), (_380 + _134)));
              if (!((_385.x - _251) >= fHazeFilterDepthDiffBias)) {
                _393 = _379;
                _394 = _380;
              } else {
                _393 = 0.0f;
                _394 = 0.0f;
              }
            } else {
              _393 = _379;
              _394 = _380;
            }
          } else {
            _393 = 0.0f;
            _394 = 0.0f;
          }
          _402 = ((fHazeFilterScale * _393) + _133);
          _403 = ((fHazeFilterScale * _394) + _134);
        }
      } else {
        _402 = _133;
        _403 = _134;
      }
      float4 _406 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_402, _403));
      // if (!(useAutoExposure == 0)) {
      //   int4 _417 = asint(WhitePtSrv[16 / 4]);
      //   _421 = asfloat(_417.x);
      // } else {
      //   _421 = 1.0f;
      // }
      // float _422 = _421 * exposureAdjustment;
      // float _433 = log2(dot(float3(((_422 * _406.x) * rangeDecompress), ((_422 * _406.y) * rangeDecompress), ((_422 * _406.z) * rangeDecompress)), float3(0.25f, 0.5f, 0.25f)) + 9.999999747378752e-06f);
      // float2 _442 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_402, _403, ((((LEBilateralGridScale * _433) + LEBilateralGridBias) * 0.984375f) + 0.0078125f)), 0.0f);
      // float _447 = BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_402, _403), 0.0f);
      // float _450 = select((_442.y < 0.0010000000474974513f), _447.x, (_442.x / _442.y));
      // float _456 = (LEPreExposureLog + _450) + ((_447.x - _450) * 0.6000000238418579f);
      // float _457 = LEPreExposureLog + _433;
      // float _460 = _456 - LEMiddleGreyLog;
      // float _472 = exp2((((select((_460 > 0.0f), LEHighlightContrast, LEShadowContrast) * _460) - _457) + LEMiddleGreyLog) + (LEDetailStrength * (_457 - _456)));

      inputs.texcoord = float2(_402, _403);
      float _472 = LocalExposure(_406, inputs);
      //_472 = PickExposure(_472, _422);
      
      _1453 = ((_406.x * _108) * _472);
      _1454 = ((_406.y * _108) * _472);
      _1455 = ((_406.z * _108) * _472);
      _1456 = fDistortionCoef;
      _1457 = 0.0f;
      _1458 = 0.0f;
      _1459 = 0.0f;
      _1460 = 0.0f;
      _1461 = fCorrectCoef;
    } else {
      float _495 = ((saturate((sqrt((_125 * _125) + (_126 * _126)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
      float _497 = _125 * fCorrectCoef;
      float _498 = _126 * fCorrectCoef;
      if (!(aberrationBlurEnable == 0)) {
        float _507 = (fBlurNoisePower * 0.125f) * frac(frac(dot(float2(SV_Position.x, SV_Position.y), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
        float _508 = _495 * 2.0f;
        float _512 = (((_508 * _507) + _127) * fDistortionCoef) + 1.0f;
        float4 _517 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _512) + 0.5f), ((_498 * _512) + 0.5f)));
        float _523 = (((_508 * (_507 + 0.125f)) + _127) * fDistortionCoef) + 1.0f;
        float4 _528 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _523) + 0.5f), ((_498 * _523) + 0.5f)));
        float _535 = (((_508 * (_507 + 0.25f)) + _127) * fDistortionCoef) + 1.0f;
        float4 _540 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _535) + 0.5f), ((_498 * _535) + 0.5f)));
        float _549 = (((_508 * (_507 + 0.375f)) + _127) * fDistortionCoef) + 1.0f;
        float4 _554 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _549) + 0.5f), ((_498 * _549) + 0.5f)));
        float _563 = (((_508 * (_507 + 0.5f)) + _127) * fDistortionCoef) + 1.0f;
        float4 _568 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _563) + 0.5f), ((_498 * _563) + 0.5f)));
        float _574 = (((_508 * (_507 + 0.625f)) + _127) * fDistortionCoef) + 1.0f;
        float4 _579 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _574) + 0.5f), ((_498 * _574) + 0.5f)));
        float _587 = (((_508 * (_507 + 0.75f)) + _127) * fDistortionCoef) + 1.0f;
        float4 _592 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _587) + 0.5f), ((_498 * _587) + 0.5f)));
        float _607 = (((_508 * (_507 + 0.875f)) + _127) * fDistortionCoef) + 1.0f;
        float4 _612 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _607) + 0.5f), ((_498 * _607) + 0.5f)));
        float _619 = (((_508 * (_507 + 1.0f)) + _127) * fDistortionCoef) + 1.0f;
        float4 _624 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _619) + 0.5f), ((_498 * _619) + 0.5f)));
        float _627 = _108 * 0.3199999928474426f;
        _1453 = (_627 * (((_528.x + _517.x) + (_540.x * 0.75f)) + (_554.x * 0.375f)));
        _1454 = ((_108 * 0.3636363744735718f) * ((((_579.y + _554.y) * 0.625f) + _568.y) + ((_592.y + _540.y) * 0.25f)));
        _1455 = (_627 * ((((_592.z * 0.75f) + (_579.z * 0.375f)) + _612.z) + _624.z));
        _1456 = fDistortionCoef;
        _1457 = 0.0f;
        _1458 = 0.0f;
        _1459 = 0.0f;
        _1460 = 0.0f;
        _1461 = fCorrectCoef;
      } else {
        float _633 = _495 + _127;
        float _635 = (_633 * fDistortionCoef) + 1.0f;
        float _642 = ((_633 + _495) * fDistortionCoef) + 1.0f;
        float4 _647 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_133, _134));
        float4 _650 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _635) + 0.5f), ((_498 * _635) + 0.5f)));
        float4 _653 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _642) + 0.5f), ((_498 * _642) + 0.5f)));
        _1453 = (_647.x * _108);
        _1454 = (_650.y * _108);
        _1455 = (_653.z * _108);
        _1456 = fDistortionCoef;
        _1457 = 0.0f;
        _1458 = 0.0f;
        _1459 = 0.0f;
        _1460 = 0.0f;
        _1461 = fCorrectCoef;
      }
    }
  } else {
    if (_56) {
      float _667 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _671 = sqrt((_667 * _667) + 1.0f);
      float _672 = 1.0f / _671;
      float _675 = (_671 * fOptimizedParam.z) * (_672 + fOptimizedParam.x);
      float _679 = fOptimizedParam.w * 0.5f;
      float _681 = (_679 * _667) * _675;
      float _684 = ((_679 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_672 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _675;
      float _685 = _681 + 0.5f;
      float _686 = _684 + 0.5f;
      if (_58) {
        if (!(fHazeFilterReductionResolution == 0)) {
          float2 _694 = HazeNoiseResult.Sample(BilinearWrap, float2(_685, _686));
          _952 = ((fHazeFilterScale * _694.x) + _685);
          _953 = ((fHazeFilterScale * _694.y) + _686);
        } else {
          bool _706 = ((fHazeFilterAttribute & 2) != 0);
          float _710 = tFilterTempMap1.Sample(BilinearWrap, float2(_685, _686));
          if (_706) {
            float _717 = ReadonlyDepth.SampleLevel(PointClamp, float2(_685, _686), 0.0f);
            float _725 = (((_685 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
            float _726 = 1.0f - (((_686 * 2.0f) * screenSize.y) * screenInverseSize.y);
            float _763 = 1.0f / (mad(_717.x, (viewProjInvMat[2].w), mad(_726, (viewProjInvMat[1].w), (_725 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
            float _765 = _763 * (mad(_717.x, (viewProjInvMat[2].y), mad(_726, (viewProjInvMat[1].y), (_725 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
            float _773 = (_763 * (mad(_717.x, (viewProjInvMat[2].x), mad(_726, (viewProjInvMat[1].x), (_725 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
            float _774 = _765 - (transposeViewInvMat[1].w);
            float _775 = (_763 * (mad(_717.x, (viewProjInvMat[2].z), mad(_726, (viewProjInvMat[1].z), (_725 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
            _800 = saturate(_710.x * max(((sqrt(((_774 * _774) + (_773 * _773)) + (_775 * _775)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_765 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
            _801 = _717.x;
          } else {
            _800 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _710.x), _710.x);
            _801 = 0.0f;
          }
          if (!((fHazeFilterAttribute & 4) == 0)) {
            float _813 = 0.5f / fHazeFilterBorder;
            _823 = (1.0f - saturate(max(((_813 * min(max((abs(_681) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_813 * min(max((abs(_684) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade))));
          } else {
            _823 = 1.0f;
          }
          float _824 = _823 * _800;
          if (!(_824 <= 9.999999747378752e-06f)) {
            float _831 = -0.0f - _686;
            float _854 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_831, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _685)));
            float _855 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_831, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _685)));
            float _856 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_831, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _685)));
            float _862 = tVolumeMap.Sample(BilinearWrap, float3((_854 + fHazeFilterUVWOffset.x), (_855 + fHazeFilterUVWOffset.y), (_856 + fHazeFilterUVWOffset.z)));
            float _865 = _854 * 2.0f;
            float _866 = _855 * 2.0f;
            float _867 = _856 * 2.0f;
            float _871 = tVolumeMap.Sample(BilinearWrap, float3((_865 + fHazeFilterUVWOffset.x), (_866 + fHazeFilterUVWOffset.y), (_867 + fHazeFilterUVWOffset.z)));
            float _875 = _854 * 4.0f;
            float _876 = _855 * 4.0f;
            float _877 = _856 * 4.0f;
            float _881 = tVolumeMap.Sample(BilinearWrap, float3((_875 + fHazeFilterUVWOffset.x), (_876 + fHazeFilterUVWOffset.y), (_877 + fHazeFilterUVWOffset.z)));
            float _885 = _854 * 8.0f;
            float _886 = _855 * 8.0f;
            float _887 = _856 * 8.0f;
            float _891 = tVolumeMap.Sample(BilinearWrap, float3((_885 + fHazeFilterUVWOffset.x), (_886 + fHazeFilterUVWOffset.y), (_887 + fHazeFilterUVWOffset.z)));
            float _895 = fHazeFilterUVWOffset.x + 0.5f;
            float _896 = fHazeFilterUVWOffset.y + 0.5f;
            float _897 = fHazeFilterUVWOffset.z + 0.5f;
            float _901 = tVolumeMap.Sample(BilinearWrap, float3((_854 + _895), (_855 + _896), (_856 + _897)));
            float _907 = tVolumeMap.Sample(BilinearWrap, float3((_865 + _895), (_866 + _896), (_867 + _897)));
            float _914 = tVolumeMap.Sample(BilinearWrap, float3((_875 + _895), (_876 + _896), (_877 + _897)));
            float _921 = tVolumeMap.Sample(BilinearWrap, float3((_885 + _895), (_886 + _896), (_887 + _897)));
            float _929 = ((((((_871.x * 0.25f) + (_862.x * 0.5f)) + (_881.x * 0.125f)) + (_891.x * 0.0625f)) * 2.0f) + -1.0f) * _824;
            float _930 = ((((((_907.x * 0.25f) + (_901.x * 0.5f)) + (_914.x * 0.125f)) + (_921.x * 0.0625f)) * 2.0f) + -1.0f) * _824;
            if (_706) {
              float _935 = ReadonlyDepth.Sample(BilinearWrap, float2((_929 + _685), (_930 + _686)));
              if (!((_935.x - _801) >= fHazeFilterDepthDiffBias)) {
                _943 = _929;
                _944 = _930;
              } else {
                _943 = 0.0f;
                _944 = 0.0f;
              }
            } else {
              _943 = _929;
              _944 = _930;
            }
          } else {
            _943 = 0.0f;
            _944 = 0.0f;
          }
          _952 = ((fHazeFilterScale * _943) + _685);
          _953 = ((fHazeFilterScale * _944) + _686);
        }
      } else {
        _952 = _685;
        _953 = _686;
      }
      float4 _956 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_952, _953));
      // if (!(useAutoExposure == 0)) {
      //   int4 _967 = asint(WhitePtSrv[16 / 4]);
      //   _971 = asfloat(_967.x);
      // } else {
      //   _971 = 1.0f;
      // }
      // float _972 = _971 * exposureAdjustment;
      // float _983 = log2(dot(float3(((_972 * _956.x) * rangeDecompress), ((_972 * _956.y) * rangeDecompress), ((_972 * _956.z) * rangeDecompress)), float3(0.25f, 0.5f, 0.25f)) + 9.999999747378752e-06f);
      // float2 _993 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_952, _953, ((((LEBilateralGridScale * _983) + LEBilateralGridBias) * 0.984375f) + 0.0078125f)), 0.0f);
      // float _998 = BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_952, _953), 0.0f);
      // float _1001 = select((_993.y < 0.0010000000474974513f), _998.x, (_993.x / _993.y));
      // float _1007 = (LEPreExposureLog + _1001) + ((_998.x - _1001) * 0.6000000238418579f);
      // float _1008 = LEPreExposureLog + _983;
      // float _1011 = _1007 - LEMiddleGreyLog;
      // float _1023 = exp2((((select((_1011 > 0.0f), LEHighlightContrast, LEShadowContrast) * _1011) - _1008) + LEMiddleGreyLog) + (LEDetailStrength * (_1008 - _1007)));

      inputs.texcoord = float2(_952, _953);
      float _1023 = LocalExposure(_956, inputs);
      //_1023 = PickExposure(_1023, _972);
      
      _1453 = ((_956.x * _108) * _1023);
      _1454 = ((_956.y * _108) * _1023);
      _1455 = ((_956.z * _108) * _1023);
      _1456 = 0.0f;
      _1457 = fOptimizedParam.x;
      _1458 = fOptimizedParam.y;
      _1459 = fOptimizedParam.z;
      _1460 = fOptimizedParam.w;
      _1461 = 1.0f;
    } else {
      float _1031 = screenInverseSize.x * SV_Position.x;
      float _1032 = screenInverseSize.y * SV_Position.y;
      if (!_58) {
        float4 _1036 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_1031, _1032));
        // if (!(useAutoExposure == 0)) {
        //   int4 _1047 = asint(WhitePtSrv[16 / 4]);
        //   _1051 = asfloat(_1047.x);
        // } else {
        //   _1051 = 1.0f;
        // }
        // float _1052 = _1051 * exposureAdjustment;
        // float _1063 = log2(dot(float3(((_1052 * _1036.x) * rangeDecompress), ((_1052 * _1036.y) * rangeDecompress), ((_1052 * _1036.z) * rangeDecompress)), float3(0.25f, 0.5f, 0.25f)) + 9.999999747378752e-06f);
        // float2 _1072 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_1031, _1032, ((((LEBilateralGridScale * _1063) + LEBilateralGridBias) * 0.984375f) + 0.0078125f)), 0.0f);
        // float _1077 = BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_1031, _1032), 0.0f);
        // float _1080 = select((_1072.y < 0.0010000000474974513f), _1077.x, (_1072.x / _1072.y));
        // float _1086 = (LEPreExposureLog + _1080) + ((_1077.x - _1080) * 0.6000000238418579f);
        // float _1087 = LEPreExposureLog + _1063;
        // float _1090 = _1086 - LEMiddleGreyLog;
        // float _1102 = exp2((((select((_1090 > 0.0f), LEHighlightContrast, LEShadowContrast) * _1090) - _1087) + LEMiddleGreyLog) + (LEDetailStrength * (_1087 - _1086)));

        inputs.texcoord = float2(_1031, _1032);
        float _1102 = LocalExposure(_1036, inputs);
        //_1102 = PickExposure(_1102, _1052);
        
        _1446 = (_1102 * _1036.x);
        _1447 = (_1102 * _1036.y);
        _1448 = (_1102 * _1036.z);
      } else {
        if (!(fHazeFilterReductionResolution == 0)) {
          float2 _1113 = HazeNoiseResult.Sample(BilinearWrap, float2(_1031, _1032));
          _1369 = (fHazeFilterScale * _1113.x);
          _1370 = (fHazeFilterScale * _1113.y);
        } else {
          bool _1123 = ((fHazeFilterAttribute & 2) != 0);
          float _1127 = tFilterTempMap1.Sample(BilinearWrap, float2(_1031, _1032));
          if (_1123) {
            float _1134 = ReadonlyDepth.SampleLevel(PointClamp, float2(_1031, _1032), 0.0f);
            float _1142 = (((_1031 * 2.0f) * screenSize.x) * screenInverseSize.x) + -1.0f;
            float _1143 = 1.0f - (((_1032 * 2.0f) * screenSize.y) * screenInverseSize.y);
            float _1180 = 1.0f / (mad(_1134.x, (viewProjInvMat[2].w), mad(_1143, (viewProjInvMat[1].w), (_1142 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w));
            float _1182 = _1180 * (mad(_1134.x, (viewProjInvMat[2].y), mad(_1143, (viewProjInvMat[1].y), (_1142 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y));
            float _1190 = (_1180 * (mad(_1134.x, (viewProjInvMat[2].x), mad(_1143, (viewProjInvMat[1].x), (_1142 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
            float _1191 = _1182 - (transposeViewInvMat[1].w);
            float _1192 = (_1180 * (mad(_1134.x, (viewProjInvMat[2].z), mad(_1143, (viewProjInvMat[1].z), (_1142 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
            _1217 = saturate(_1127.x * max(((sqrt(((_1191 * _1191) + (_1190 * _1190)) + (_1192 * _1192)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_1182 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)));
            _1218 = _1134.x;
          } else {
            _1217 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _1127.x), _1127.x);
            _1218 = 0.0f;
          }
          if (!((fHazeFilterAttribute & 4) == 0)) {
            float _1232 = 0.5f / fHazeFilterBorder;
            _1242 = (1.0f - saturate(max(((_1232 * min(max((abs(_1031 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade), ((_1232 * min(max((abs(_1032 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)) * fHazeFilterBorderFade))));
          } else {
            _1242 = 1.0f;
          }
          float _1243 = _1242 * _1217;
          if (!(_1243 <= 9.999999747378752e-06f)) {
            float _1250 = -0.0f - _1032;
            float _1273 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[0].z), mad(_1250, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _1031)));
            float _1274 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[1].z), mad(_1250, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _1031)));
            float _1275 = fHazeFilterUVWOffset.w * mad(-1.0f, (transposeViewInvMat[2].z), mad(_1250, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _1031)));
            float _1281 = tVolumeMap.Sample(BilinearWrap, float3((_1273 + fHazeFilterUVWOffset.x), (_1274 + fHazeFilterUVWOffset.y), (_1275 + fHazeFilterUVWOffset.z)));
            float _1284 = _1273 * 2.0f;
            float _1285 = _1274 * 2.0f;
            float _1286 = _1275 * 2.0f;
            float _1290 = tVolumeMap.Sample(BilinearWrap, float3((_1284 + fHazeFilterUVWOffset.x), (_1285 + fHazeFilterUVWOffset.y), (_1286 + fHazeFilterUVWOffset.z)));
            float _1294 = _1273 * 4.0f;
            float _1295 = _1274 * 4.0f;
            float _1296 = _1275 * 4.0f;
            float _1300 = tVolumeMap.Sample(BilinearWrap, float3((_1294 + fHazeFilterUVWOffset.x), (_1295 + fHazeFilterUVWOffset.y), (_1296 + fHazeFilterUVWOffset.z)));
            float _1304 = _1273 * 8.0f;
            float _1305 = _1274 * 8.0f;
            float _1306 = _1275 * 8.0f;
            float _1310 = tVolumeMap.Sample(BilinearWrap, float3((_1304 + fHazeFilterUVWOffset.x), (_1305 + fHazeFilterUVWOffset.y), (_1306 + fHazeFilterUVWOffset.z)));
            float _1314 = fHazeFilterUVWOffset.x + 0.5f;
            float _1315 = fHazeFilterUVWOffset.y + 0.5f;
            float _1316 = fHazeFilterUVWOffset.z + 0.5f;
            float _1320 = tVolumeMap.Sample(BilinearWrap, float3((_1273 + _1314), (_1274 + _1315), (_1275 + _1316)));
            float _1326 = tVolumeMap.Sample(BilinearWrap, float3((_1284 + _1314), (_1285 + _1315), (_1286 + _1316)));
            float _1333 = tVolumeMap.Sample(BilinearWrap, float3((_1294 + _1314), (_1295 + _1315), (_1296 + _1316)));
            float _1340 = tVolumeMap.Sample(BilinearWrap, float3((_1304 + _1314), (_1305 + _1315), (_1306 + _1316)));
            float _1348 = ((((((_1290.x * 0.25f) + (_1281.x * 0.5f)) + (_1300.x * 0.125f)) + (_1310.x * 0.0625f)) * 2.0f) + -1.0f) * _1243;
            float _1349 = ((((((_1326.x * 0.25f) + (_1320.x * 0.5f)) + (_1333.x * 0.125f)) + (_1340.x * 0.0625f)) * 2.0f) + -1.0f) * _1243;
            if (_1123) {
              float _1354 = ReadonlyDepth.Sample(BilinearWrap, float2((_1348 + _1031), (_1349 + _1032)));
              if (!((_1354.x - _1218) >= fHazeFilterDepthDiffBias)) {
                _1362 = _1348;
                _1363 = _1349;
              } else {
                _1362 = 0.0f;
                _1363 = 0.0f;
              }
            } else {
              _1362 = _1348;
              _1363 = _1349;
            }
          } else {
            _1362 = 0.0f;
            _1363 = 0.0f;
          }
          _1369 = (fHazeFilterScale * _1362);
          _1370 = (fHazeFilterScale * _1363);
        }
        float _1371 = _1369 + _1031;
        float _1372 = _1370 + _1032;
        float4 _1375 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_1371, _1372));
        // if (!(useAutoExposure == 0)) {
        //   int4 _1386 = asint(WhitePtSrv[16 / 4]);
        //   _1390 = asfloat(_1386.x);
        // } else {
        //   _1390 = 1.0f;
        // }
        // float _1391 = _1390 * exposureAdjustment;
        // float _1402 = log2(dot(float3(((_1391 * _1375.x) * rangeDecompress), ((_1391 * _1375.y) * rangeDecompress), ((_1391 * _1375.z) * rangeDecompress)), float3(0.25f, 0.5f, 0.25f)) + 9.999999747378752e-06f);
        // float2 _1411 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_1371, _1372, ((((LEBilateralGridScale * _1402) + LEBilateralGridBias) * 0.984375f) + 0.0078125f)), 0.0f);
        // float _1416 = BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_1371, _1372), 0.0f);
        // float _1419 = select((_1411.y < 0.0010000000474974513f), _1416.x, (_1411.x / _1411.y));
        // float _1425 = (LEPreExposureLog + _1419) + ((_1416.x - _1419) * 0.6000000238418579f);
        // float _1426 = LEPreExposureLog + _1402;
        // float _1429 = _1425 - LEMiddleGreyLog;
        // float _1441 = exp2((((select((_1429 > 0.0f), LEHighlightContrast, LEShadowContrast) * _1429) - _1426) + LEMiddleGreyLog) + (LEDetailStrength * (_1426 - _1425)));

        inputs.texcoord = float2(_1371, _1372);
        float _1441 = LocalExposure(_1375, inputs);
        //_1441 = PickExposure(_1441, _1391);
        
        _1446 = (_1441 * _1375.x);
        _1447 = (_1441 * _1375.y);
        _1448 = (_1441 * _1375.z);
      }
      _1453 = (_1446 * _108);
      _1454 = (_1447 * _108);
      _1455 = (_1448 * _108);
      _1456 = 0.0f;
      _1457 = 0.0f;
      _1458 = 0.0f;
      _1459 = 0.0f;
      _1460 = 0.0f;
      _1461 = 1.0f;
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _1482 = _107 * Exposure;
    float _1485 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _1489 = ComputeResultSRV[0].computeAlpha;
    float _1492 = ((1.0f - _1485) + (_1489 * _1485)) * cbRadialColor.w;
    if (!(_1492 == 0.0f)) {
      float _1498 = screenInverseSize.x * SV_Position.x;
      float _1499 = screenInverseSize.y * SV_Position.y;
      float _1501 = (-0.5f - cbRadialScreenPos.x) + _1498;
      float _1503 = (-0.5f - cbRadialScreenPos.y) + _1499;
      float _1506 = select((_1501 < 0.0f), (1.0f - _1498), _1498);
      float _1509 = select((_1503 < 0.0f), (1.0f - _1499), _1499);
      if (!((cbRadialBlurFlags & 1) == 0)) {
        float _1514 = rsqrt(dot(float2(_1501, _1503), float2(_1501, _1503)));
        uint _1523 = uint(abs((_1503 * cbRadialSharpRange) * _1514)) + uint(abs((_1501 * cbRadialSharpRange) * _1514));
        uint _1527 = ((_1523 ^ 61) ^ ((uint)(_1523) >> 16)) * 9;
        uint _1530 = (((uint)(_1527) >> 4) ^ _1527) * 668265261;
        _1536 = (float((uint)((int)(((uint)(_1530) >> 15) ^ _1530))) * 2.3283064365386963e-10f);
      } else {
        _1536 = 1.0f;
      }
      float _1542 = 1.0f / max(1.0f, sqrt((_1501 * _1501) + (_1503 * _1503)));
      float _1543 = cbRadialBlurPower * -0.0011111111380159855f;
      float _1552 = ((((_1543 * _1506) * _1536) * _1542) + 1.0f) * _1501;
      float _1553 = ((((_1543 * _1509) * _1536) * _1542) + 1.0f) * _1503;
      float _1555 = cbRadialBlurPower * -0.002222222276031971f;
      float _1564 = ((((_1555 * _1506) * _1536) * _1542) + 1.0f) * _1501;
      float _1565 = ((((_1555 * _1509) * _1536) * _1542) + 1.0f) * _1503;
      float _1566 = cbRadialBlurPower * -0.0033333334140479565f;
      float _1575 = ((((_1566 * _1506) * _1536) * _1542) + 1.0f) * _1501;
      float _1576 = ((((_1566 * _1509) * _1536) * _1542) + 1.0f) * _1503;
      float _1577 = cbRadialBlurPower * -0.004444444552063942f;
      float _1586 = ((((_1577 * _1506) * _1536) * _1542) + 1.0f) * _1501;
      float _1587 = ((((_1577 * _1509) * _1536) * _1542) + 1.0f) * _1503;
      float _1588 = cbRadialBlurPower * -0.0055555556900799274f;
      float _1597 = ((((_1588 * _1506) * _1536) * _1542) + 1.0f) * _1501;
      float _1598 = ((((_1588 * _1509) * _1536) * _1542) + 1.0f) * _1503;
      float _1599 = cbRadialBlurPower * -0.006666666828095913f;
      float _1608 = ((((_1599 * _1506) * _1536) * _1542) + 1.0f) * _1501;
      float _1609 = ((((_1599 * _1509) * _1536) * _1542) + 1.0f) * _1503;
      float _1610 = cbRadialBlurPower * -0.007777777966111898f;
      float _1619 = ((((_1610 * _1506) * _1536) * _1542) + 1.0f) * _1501;
      float _1620 = ((((_1610 * _1509) * _1536) * _1542) + 1.0f) * _1503;
      float _1621 = cbRadialBlurPower * -0.008888889104127884f;
      float _1630 = ((((_1621 * _1506) * _1536) * _1542) + 1.0f) * _1501;
      float _1631 = ((((_1621 * _1509) * _1536) * _1542) + 1.0f) * _1503;
      float _1632 = cbRadialBlurPower * -0.009999999776482582f;
      float _1641 = ((((_1632 * _1506) * _1536) * _1542) + 1.0f) * _1501;
      float _1642 = ((((_1632 * _1509) * _1536) * _1542) + 1.0f) * _1503;
      if (_50) {
        float _1644 = _1552 + cbRadialScreenPos.x;
        float _1645 = _1553 + cbRadialScreenPos.y;
        float _1649 = ((dot(float2(_1644, _1645), float2(_1644, _1645)) * _1456) + 1.0f) * _1461;
        float4 _1655 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1649 * _1644) + 0.5f), ((_1649 * _1645) + 0.5f)), 0.0f);
        float _1659 = _1564 + cbRadialScreenPos.x;
        float _1660 = _1565 + cbRadialScreenPos.y;
        float _1663 = (dot(float2(_1659, _1660), float2(_1659, _1660)) * _1456) + 1.0f;
        float4 _1670 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1659 * _1461) * _1663) + 0.5f), (((_1660 * _1461) * _1663) + 0.5f)), 0.0f);
        float _1677 = _1575 + cbRadialScreenPos.x;
        float _1678 = _1576 + cbRadialScreenPos.y;
        float _1681 = (dot(float2(_1677, _1678), float2(_1677, _1678)) * _1456) + 1.0f;
        float4 _1688 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1677 * _1461) * _1681) + 0.5f), (((_1678 * _1461) * _1681) + 0.5f)), 0.0f);
        float _1695 = _1586 + cbRadialScreenPos.x;
        float _1696 = _1587 + cbRadialScreenPos.y;
        float _1699 = (dot(float2(_1695, _1696), float2(_1695, _1696)) * _1456) + 1.0f;
        float4 _1706 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1695 * _1461) * _1699) + 0.5f), (((_1696 * _1461) * _1699) + 0.5f)), 0.0f);
        float _1713 = _1597 + cbRadialScreenPos.x;
        float _1714 = _1598 + cbRadialScreenPos.y;
        float _1717 = (dot(float2(_1713, _1714), float2(_1713, _1714)) * _1456) + 1.0f;
        float4 _1724 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1713 * _1461) * _1717) + 0.5f), (((_1714 * _1461) * _1717) + 0.5f)), 0.0f);
        float _1731 = _1608 + cbRadialScreenPos.x;
        float _1732 = _1609 + cbRadialScreenPos.y;
        float _1735 = (dot(float2(_1731, _1732), float2(_1731, _1732)) * _1456) + 1.0f;
        float4 _1742 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1731 * _1461) * _1735) + 0.5f), (((_1732 * _1461) * _1735) + 0.5f)), 0.0f);
        float _1749 = _1619 + cbRadialScreenPos.x;
        float _1750 = _1620 + cbRadialScreenPos.y;
        float _1753 = (dot(float2(_1749, _1750), float2(_1749, _1750)) * _1456) + 1.0f;
        float4 _1760 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1749 * _1461) * _1753) + 0.5f), (((_1750 * _1461) * _1753) + 0.5f)), 0.0f);
        float _1767 = _1630 + cbRadialScreenPos.x;
        float _1768 = _1631 + cbRadialScreenPos.y;
        float _1771 = (dot(float2(_1767, _1768), float2(_1767, _1768)) * _1456) + 1.0f;
        float4 _1778 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1767 * _1461) * _1771) + 0.5f), (((_1768 * _1461) * _1771) + 0.5f)), 0.0f);
        float _1785 = _1641 + cbRadialScreenPos.x;
        float _1786 = _1642 + cbRadialScreenPos.y;
        float _1789 = (dot(float2(_1785, _1786), float2(_1785, _1786)) * _1456) + 1.0f;
        float4 _1796 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1785 * _1461) * _1789) + 0.5f), (((_1786 * _1461) * _1789) + 0.5f)), 0.0f);
        _2139 = ((((((((_1670.x + _1655.x) + _1688.x) + _1706.x) + _1724.x) + _1742.x) + _1760.x) + _1778.x) + _1796.x);
        _2140 = ((((((((_1670.y + _1655.y) + _1688.y) + _1706.y) + _1724.y) + _1742.y) + _1760.y) + _1778.y) + _1796.y);
        _2141 = ((((((((_1670.z + _1655.z) + _1688.z) + _1706.z) + _1724.z) + _1742.z) + _1760.z) + _1778.z) + _1796.z);
      } else {
        float _1804 = cbRadialScreenPos.x + 0.5f;
        float _1805 = _1804 + _1552;
        float _1806 = cbRadialScreenPos.y + 0.5f;
        float _1807 = _1806 + _1553;
        float _1808 = _1804 + _1564;
        float _1809 = _1806 + _1565;
        float _1810 = _1804 + _1575;
        float _1811 = _1806 + _1576;
        float _1812 = _1804 + _1586;
        float _1813 = _1806 + _1587;
        float _1814 = _1804 + _1597;
        float _1815 = _1806 + _1598;
        float _1816 = _1804 + _1608;
        float _1817 = _1806 + _1609;
        float _1818 = _1804 + _1619;
        float _1819 = _1806 + _1620;
        float _1820 = _1804 + _1630;
        float _1821 = _1806 + _1631;
        float _1822 = _1804 + _1641;
        float _1823 = _1806 + _1642;
        if (_56) {
          float _1827 = (_1805 * 2.0f) + -1.0f;
          float _1831 = sqrt((_1827 * _1827) + 1.0f);
          float _1832 = 1.0f / _1831;
          float _1835 = (_1831 * _1459) * (_1832 + _1457);
          float _1839 = _1460 * 0.5f;
          float4 _1848 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1835) * _1827) + 0.5f), ((((_1839 * (((_1832 + -1.0f) * _1458) + 1.0f)) * _1835) * ((_1807 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
          float _1854 = (_1808 * 2.0f) + -1.0f;
          float _1858 = sqrt((_1854 * _1854) + 1.0f);
          float _1859 = 1.0f / _1858;
          float _1862 = (_1858 * _1459) * (_1859 + _1457);
          float4 _1873 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1854) * _1862) + 0.5f), ((((_1839 * ((_1809 * 2.0f) + -1.0f)) * (((_1859 + -1.0f) * _1458) + 1.0f)) * _1862) + 0.5f)), 0.0f);
          float _1882 = (_1810 * 2.0f) + -1.0f;
          float _1886 = sqrt((_1882 * _1882) + 1.0f);
          float _1887 = 1.0f / _1886;
          float _1890 = (_1886 * _1459) * (_1887 + _1457);
          float4 _1901 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1882) * _1890) + 0.5f), ((((_1839 * ((_1811 * 2.0f) + -1.0f)) * (((_1887 + -1.0f) * _1458) + 1.0f)) * _1890) + 0.5f)), 0.0f);
          float _1910 = (_1812 * 2.0f) + -1.0f;
          float _1914 = sqrt((_1910 * _1910) + 1.0f);
          float _1915 = 1.0f / _1914;
          float _1918 = (_1914 * _1459) * (_1915 + _1457);
          float4 _1929 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1910) * _1918) + 0.5f), ((((_1839 * ((_1813 * 2.0f) + -1.0f)) * (((_1915 + -1.0f) * _1458) + 1.0f)) * _1918) + 0.5f)), 0.0f);
          float _1938 = (_1814 * 2.0f) + -1.0f;
          float _1942 = sqrt((_1938 * _1938) + 1.0f);
          float _1943 = 1.0f / _1942;
          float _1946 = (_1942 * _1459) * (_1943 + _1457);
          float4 _1957 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1938) * _1946) + 0.5f), ((((_1839 * ((_1815 * 2.0f) + -1.0f)) * (((_1943 + -1.0f) * _1458) + 1.0f)) * _1946) + 0.5f)), 0.0f);
          float _1966 = (_1816 * 2.0f) + -1.0f;
          float _1970 = sqrt((_1966 * _1966) + 1.0f);
          float _1971 = 1.0f / _1970;
          float _1974 = (_1970 * _1459) * (_1971 + _1457);
          float4 _1985 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1966) * _1974) + 0.5f), ((((_1839 * ((_1817 * 2.0f) + -1.0f)) * (((_1971 + -1.0f) * _1458) + 1.0f)) * _1974) + 0.5f)), 0.0f);
          float _1994 = (_1818 * 2.0f) + -1.0f;
          float _1998 = sqrt((_1994 * _1994) + 1.0f);
          float _1999 = 1.0f / _1998;
          float _2002 = (_1998 * _1459) * (_1999 + _1457);
          float4 _2013 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1994) * _2002) + 0.5f), ((((_1839 * ((_1819 * 2.0f) + -1.0f)) * (((_1999 + -1.0f) * _1458) + 1.0f)) * _2002) + 0.5f)), 0.0f);
          float _2022 = (_1820 * 2.0f) + -1.0f;
          float _2026 = sqrt((_2022 * _2022) + 1.0f);
          float _2027 = 1.0f / _2026;
          float _2030 = (_2026 * _1459) * (_2027 + _1457);
          float4 _2041 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _2022) * _2030) + 0.5f), ((((_1839 * ((_1821 * 2.0f) + -1.0f)) * (((_2027 + -1.0f) * _1458) + 1.0f)) * _2030) + 0.5f)), 0.0f);
          float _2050 = (_1822 * 2.0f) + -1.0f;
          float _2054 = sqrt((_2050 * _2050) + 1.0f);
          float _2055 = 1.0f / _2054;
          float _2058 = (_2054 * _1459) * (_2055 + _1457);
          float4 _2069 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _2050) * _2058) + 0.5f), ((((_1839 * ((_1823 * 2.0f) + -1.0f)) * (((_2055 + -1.0f) * _1458) + 1.0f)) * _2058) + 0.5f)), 0.0f);
          _2139 = ((((((((_1873.x + _1848.x) + _1901.x) + _1929.x) + _1957.x) + _1985.x) + _2013.x) + _2041.x) + _2069.x);
          _2140 = ((((((((_1873.y + _1848.y) + _1901.y) + _1929.y) + _1957.y) + _1985.y) + _2013.y) + _2041.y) + _2069.y);
          _2141 = ((((((((_1873.z + _1848.z) + _1901.z) + _1929.z) + _1957.z) + _1985.z) + _2013.z) + _2041.z) + _2069.z);
        } else {
          float4 _2078 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1805, _1807), 0.0f);
          float4 _2082 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1808, _1809), 0.0f);
          float4 _2089 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1810, _1811), 0.0f);
          float4 _2096 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1812, _1813), 0.0f);
          float4 _2103 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1814, _1815), 0.0f);
          float4 _2110 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1816, _1817), 0.0f);
          float4 _2117 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1818, _1819), 0.0f);
          float4 _2124 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1820, _1821), 0.0f);
          float4 _2131 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1822, _1823), 0.0f);
          _2139 = ((((((((_2082.x + _2078.x) + _2089.x) + _2096.x) + _2103.x) + _2110.x) + _2117.x) + _2124.x) + _2131.x);
          _2140 = ((((((((_2082.y + _2078.y) + _2089.y) + _2096.y) + _2103.y) + _2110.y) + _2117.y) + _2124.y) + _2131.y);
          _2141 = ((((((((_2082.z + _2078.z) + _2089.z) + _2096.z) + _2103.z) + _2110.z) + _2117.z) + _2124.z) + _2131.z);
        }
      }
      float _2151 = (((_2141 * _1482) + _1455) * 0.10000000149011612f) * cbRadialColor.z;
      float _2152 = (((_2140 * _1482) + _1454) * 0.10000000149011612f) * cbRadialColor.y;
      float _2153 = (((_2139 * _1482) + _1453) * 0.10000000149011612f) * cbRadialColor.x;
      if (cbRadialMaskRate.x > 0.0f) {
        float _2162 = saturate((sqrt((_1501 * _1501) + (_1503 * _1503)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
        float _2168 = (((_2162 * _2162) * cbRadialMaskRate.x) * (3.0f - (_2162 * 2.0f))) + cbRadialMaskRate.y;
        _2179 = ((_2168 * (_2153 - _1453)) + _1453);
        _2180 = ((_2168 * (_2152 - _1454)) + _1454);
        _2181 = ((_2168 * (_2151 - _1455)) + _1455);
      } else {
        _2179 = _2153;
        _2180 = _2152;
        _2181 = _2151;
      }
      _2192 = (lerp(_1453, _2179, _1492));
      _2193 = (lerp(_1454, _2180, _1492));
      _2194 = (lerp(_1455, _2181, _1492));
    } else {
      _2192 = _1453;
      _2193 = _1454;
      _2194 = _1455;
    }
  } else {
    _2192 = _1453;
    _2193 = _1454;
    _2194 = _1455;
  }
  float _2209 = mad(_2194, (fOCIOTransformMatrix[2].x), mad(_2193, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _2192)));
  float _2212 = mad(_2194, (fOCIOTransformMatrix[2].y), mad(_2193, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _2192)));
  float _2215 = mad(_2194, (fOCIOTransformMatrix[2].z), mad(_2193, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _2192)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    float _2221 = max(max(_2209, _2212), _2215);
    if (!(_2221 == 0.0f)) {
      float _2227 = abs(_2221);
      float _2228 = (_2221 - _2209) / _2227;
      float _2229 = (_2221 - _2212) / _2227;
      float _2230 = (_2221 - _2215) / _2227;
      if (!(!(_2228 >= cbControlRGCParam.CyanThreshold))) {
        float _2240 = _2228 - cbControlRGCParam.CyanThreshold;
        _2252 = ((_2240 / exp2(log2(exp2(log2(_2240 * cbControlRGCParam.InvCyanSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
      } else {
        _2252 = _2228;
      }
      if (!(!(_2229 >= cbControlRGCParam.MagentaThreshold))) {
        float _2261 = _2229 - cbControlRGCParam.MagentaThreshold;
        _2273 = ((_2261 / exp2(log2(exp2(log2(_2261 * cbControlRGCParam.InvMagentaSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
      } else {
        _2273 = _2229;
      }
      if (!(!(_2230 >= cbControlRGCParam.YellowThreshold))) {
        float _2281 = _2230 - cbControlRGCParam.YellowThreshold;
        _2293 = ((_2281 / exp2(log2(exp2(log2(_2281 * cbControlRGCParam.InvYellowSTerm) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
      } else {
        _2293 = _2230;
      }
      _2301 = (_2221 - (_2227 * _2252));
      _2302 = (_2221 - (_2227 * _2273));
      _2303 = (_2221 - (_2227 * _2293));
    } else {
      _2301 = _2209;
      _2302 = _2212;
      _2303 = _2215;
    }
  } else {
    _2301 = _2209;
    _2302 = _2212;
    _2303 = _2215;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _2320 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    float _2322 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    float _2326 = frac(frac(dot(float2(_2320, _2322), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    if (_2326 < fNoiseDensity) {
      int _2331 = (uint)(uint(_2322 * _2320)) ^ 12345391;
      uint _2332 = _2331 * 3635641;
      _2340 = (float((uint)((int)((((uint)(_2332) >> 26) | ((uint)(_2331 * 232681024))) ^ _2332))) * 2.3283064365386963e-10f);
    } else {
      _2340 = 0.0f;
    }
    float _2342 = frac(_2326 * 757.4846801757812f);
    if (_2342 < fNoiseDensity) {
      int _2346 = asint(_2342) ^ 12345391;
      uint _2347 = _2346 * 3635641;
      _2356 = ((float((uint)((int)((((uint)(_2347) >> 26) | ((uint)(_2346 * 232681024))) ^ _2347))) * 2.3283064365386963e-10f) + -0.5f);
    } else {
      _2356 = 0.0f;
    }
    float _2358 = frac(_2342 * 757.4846801757812f);
    if (_2358 < fNoiseDensity) {
      int _2362 = asint(_2358) ^ 12345391;
      uint _2363 = _2362 * 3635641;
      _2372 = ((float((uint)((int)((((uint)(_2363) >> 26) | ((uint)(_2362 * 232681024))) ^ _2363))) * 2.3283064365386963e-10f) + -0.5f);
    } else {
      _2372 = 0.0f;
    }
    float _2373 = _2340 * fNoisePower.x;
    float _2374 = _2372 * fNoisePower.y;
    float _2375 = _2356 * fNoisePower.y;
    float _2389 = exp2(log2(1.0f - saturate(dot(float3(saturate(_2301), saturate(_2302), saturate(_2303)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
    _2400 = ((_2389 * (mad(_2375, 1.4019999504089355f, _2373) - _2301)) + _2301);
    _2401 = ((_2389 * (mad(_2375, -0.7139999866485596f, mad(_2374, -0.3440000116825104f, _2373)) - _2302)) + _2302);
    _2402 = ((_2389 * (mad(_2374, 1.7719999551773071f, _2373) - _2303)) + _2303);
  } else {
    _2400 = _2301;
    _2401 = _2302;
    _2402 = _2303;
  }



  if (!((cPassEnabled & 4) == 0)) {
    // Use RenoDX LUT sampling with tetrahedral interpolation
    float3 lut_output = SampleColorLUTs(
        float3(_2400, _2401, _2402),  // Input AP1 color
        tTextureMap0,                  // Primary LUT
        tTextureMap1,                  // Secondary LUT
        tTextureMap2,                  // Tertiary LUT
        TrilinearClamp,                // Sampler
        fTextureBlendRate,             // Blend between LUT0 and LUT1
        fTextureBlendRate2,            // Blend with LUT2           
        fColorMatrix                   // Color transform matrix
    );
    
    float3 new_color = CustomLUTColor(float3(_2400, _2401, _2402), lut_output);
    _2809 = new_color.r;
    _2810 = new_color.g;
    _2811 = new_color.b;
    // _2809 = lut_output.r;
    // _2810 = lut_output.g;
    // _2811 = lut_output.b;

    // ORIGINAL MANUAL LUT SAMPLING CODE (REPLACED BY RENODX IMPLEMENTATION ABOVE)
    /*
    bool _2428 = !(_2400 <= 0.0078125f);
    if (!_2428) {
      _2437 = ((_2400 * 10.540237426757812f) + 0.072905533015728f);
    } else {
      _2437 = ((log2(_2400) + 9.720000267028809f) * 0.05707762390375137f);
    }
    bool _2438 = !(_2401 <= 0.0078125f);
    if (!_2438) {
      _2447 = ((_2401 * 10.540237426757812f) + 0.072905533015728f);
    } else {
      _2447 = ((log2(_2401) + 9.720000267028809f) * 0.05707762390375137f);
    }
    bool _2448 = !(_2402 <= 0.0078125f);
    if (!_2448) {
      _2457 = ((_2402 * 10.540237426757812f) + 0.072905533015728f);
    } else {
      _2457 = ((log2(_2402) + 9.720000267028809f) * 0.05707762390375137f);
    }
    float4 _2466 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_2437 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2447 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2457 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
    if (_2466.x < 0.155251145362854f) {
      _2483 = ((_2466.x + -0.072905533015728f) * 0.09487452358007431f);
    } else {
      if ((bool)(_2466.x >= 0.155251145362854f) && (bool)(_2466.x < 1.4679962396621704f)) {
        _2483 = exp2((_2466.x * 17.520000457763672f) + -9.720000267028809f);
      } else {
        _2483 = 65504.0f;
      }
    }
    if (_2466.y < 0.155251145362854f) {
      _2497 = ((_2466.y + -0.072905533015728f) * 0.09487452358007431f);
    } else {
      if ((bool)(_2466.y >= 0.155251145362854f) && (bool)(_2466.y < 1.4679962396621704f)) {
        _2497 = exp2((_2466.y * 17.520000457763672f) + -9.720000267028809f);
      } else {
        _2497 = 65504.0f;
      }
    }
    if (_2466.z < 0.155251145362854f) {
      _2511 = ((_2466.z + -0.072905533015728f) * 0.09487452358007431f);
    } else {
      if ((bool)(_2466.z >= 0.155251145362854f) && (bool)(_2466.z < 1.4679962396621704f)) {
        _2511 = exp2((_2466.z * 17.520000457763672f) + -9.720000267028809f);
      } else {
        _2511 = 65504.0f;
      }
    }
    [branch]
    if (fTextureBlendRate > 0.0f) {
      if (!_2428) {
        _2522 = ((_2400 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _2522 = ((log2(_2400) + 9.720000267028809f) * 0.05707762390375137f);
      }
      if (!_2438) {
        _2531 = ((_2401 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _2531 = ((log2(_2401) + 9.720000267028809f) * 0.05707762390375137f);
      }
      if (!_2448) {
        _2540 = ((_2402 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _2540 = ((log2(_2402) + 9.720000267028809f) * 0.05707762390375137f);
      }
      float4 _2548 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_2522 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2531 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2540 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
      if (_2548.x < 0.155251145362854f) {
        _2565 = ((_2548.x + -0.072905533015728f) * 0.09487452358007431f);
      } else {
        if ((bool)(_2548.x >= 0.155251145362854f) && (bool)(_2548.x < 1.4679962396621704f)) {
          _2565 = exp2((_2548.x * 17.520000457763672f) + -9.720000267028809f);
        } else {
          _2565 = 65504.0f;
        }
      }
      if (_2548.y < 0.155251145362854f) {
        _2579 = ((_2548.y + -0.072905533015728f) * 0.09487452358007431f);
      } else {
        if ((bool)(_2548.y >= 0.155251145362854f) && (bool)(_2548.y < 1.4679962396621704f)) {
          _2579 = exp2((_2548.y * 17.520000457763672f) + -9.720000267028809f);
        } else {
          _2579 = 65504.0f;
        }
      }
      if (_2548.z < 0.155251145362854f) {
        _2593 = ((_2548.z + -0.072905533015728f) * 0.09487452358007431f);
      } else {
        if ((bool)(_2548.z >= 0.155251145362854f) && (bool)(_2548.z < 1.4679962396621704f)) {
          _2593 = exp2((_2548.z * 17.520000457763672f) + -9.720000267028809f);
        } else {
          _2593 = 65504.0f;
        }
      }
      float _2600 = ((_2565 - _2483) * fTextureBlendRate) + _2483;
      float _2601 = ((_2579 - _2497) * fTextureBlendRate) + _2497;
      float _2602 = ((_2593 - _2511) * fTextureBlendRate) + _2511;
      if (fTextureBlendRate2 > 0.0f) {
        if (!(!(_2600 <= 0.0078125f))) {
          _2614 = ((_2600 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2614 = ((log2(_2600) + 9.720000267028809f) * 0.05707762390375137f);
        }
        if (!(!(_2601 <= 0.0078125f))) {
          _2624 = ((_2601 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2624 = ((log2(_2601) + 9.720000267028809f) * 0.05707762390375137f);
        }
        if (!(!(_2602 <= 0.0078125f))) {
          _2634 = ((_2602 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2634 = ((log2(_2602) + 9.720000267028809f) * 0.05707762390375137f);
        }
        float4 _2642 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2614 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2624 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2634 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
        if (_2642.x < 0.155251145362854f) {
          _2659 = ((_2642.x + -0.072905533015728f) * 0.09487452358007431f);
        } else {
          if ((bool)(_2642.x >= 0.155251145362854f) && (bool)(_2642.x < 1.4679962396621704f)) {
            _2659 = exp2((_2642.x * 17.520000457763672f) + -9.720000267028809f);
          } else {
            _2659 = 65504.0f;
          }
        }
        if (_2642.y < 0.155251145362854f) {
          _2673 = ((_2642.y + -0.072905533015728f) * 0.09487452358007431f);
        } else {
          if ((bool)(_2642.y >= 0.155251145362854f) && (bool)(_2642.y < 1.4679962396621704f)) {
            _2673 = exp2((_2642.y * 17.520000457763672f) + -9.720000267028809f);
          } else {
            _2673 = 65504.0f;
          }
        }
        if (_2642.z < 0.155251145362854f) {
          _2687 = ((_2642.z + -0.072905533015728f) * 0.09487452358007431f);
        } else {
          if ((bool)(_2642.z >= 0.155251145362854f) && (bool)(_2642.z < 1.4679962396621704f)) {
            _2687 = exp2((_2642.z * 17.520000457763672f) + -9.720000267028809f);
          } else {
            _2687 = 65504.0f;
          }
        }
        _2793 = (lerp(_2600, _2659, fTextureBlendRate2));
        _2794 = (lerp(_2601, _2673, fTextureBlendRate2));
        _2795 = (lerp(_2602, _2687, fTextureBlendRate2));
      } else {
        _2793 = _2600;
        _2794 = _2601;
        _2795 = _2602;
      }
    } else {
      if (fTextureBlendRate2 > 0.0f) {
        if (!(!(_2483 <= 0.0078125f))) {
          _2709 = ((_2483 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2709 = ((log2(_2483) + 9.720000267028809f) * 0.05707762390375137f);
        }
        if (!(!(_2497 <= 0.0078125f))) {
          _2719 = ((_2497 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2719 = ((log2(_2497) + 9.720000267028809f) * 0.05707762390375137f);
        }
        if (!(!(_2511 <= 0.0078125f))) {
          _2729 = ((_2511 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2729 = ((log2(_2511) + 9.720000267028809f) * 0.05707762390375137f);
        }
        float4 _2737 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2709 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2719 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2729 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
        if (_2737.x < 0.155251145362854f) {
          _2754 = ((_2737.x + -0.072905533015728f) * 0.09487452358007431f);
        } else {
          if ((bool)(_2737.x >= 0.155251145362854f) && (bool)(_2737.x < 1.4679962396621704f)) {
            _2754 = exp2((_2737.x * 17.520000457763672f) + -9.720000267028809f);
          } else {
            _2754 = 65504.0f;
          }
        }
        if (_2737.y < 0.155251145362854f) {
          _2768 = ((_2737.y + -0.072905533015728f) * 0.09487452358007431f);
        } else {
          if ((bool)(_2737.y >= 0.155251145362854f) && (bool)(_2737.y < 1.4679962396621704f)) {
            _2768 = exp2((_2737.y * 17.520000457763672f) + -9.720000267028809f);
          } else {
            _2768 = 65504.0f;
          }
        }
        if (_2737.z < 0.155251145362854f) {
          _2782 = ((_2737.z + -0.072905533015728f) * 0.09487452358007431f);
        } else {
          if ((bool)(_2737.z >= 0.155251145362854f) && (bool)(_2737.z < 1.4679962396621704f)) {
            _2782 = exp2((_2737.z * 17.520000457763672f) + -9.720000267028809f);
          } else {
            _2782 = 65504.0f;
          }
        }
        _2793 = (lerp(_2483, _2754, fTextureBlendRate2));
        _2794 = (lerp(_2497, _2768, fTextureBlendRate2));
        _2795 = (lerp(_2511, _2782, fTextureBlendRate2));
      } else {
        _2793 = _2483;
        _2794 = _2497;
        _2795 = _2511;
      }
    }
    _2809 = (mad(_2795, (fColorMatrix[2].x), mad(_2794, (fColorMatrix[1].x), (_2793 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
    _2810 = (mad(_2795, (fColorMatrix[2].y), mad(_2794, (fColorMatrix[1].y), (_2793 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
    _2811 = (mad(_2795, (fColorMatrix[2].z), mad(_2794, (fColorMatrix[1].z), (_2793 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));

    float3 new_color = CustomLUTColor(float3(_2400, _2401, _2402), float3(_2809, _2810, _2811));
    _2809 = new_color.r;
    _2810 = new_color.g;
    _2811 = new_color.b;
    */

  } else {
    _2809 = _2400;
    _2810 = _2401;
    _2811 = _2402;
  }
  float _2812 = min(_2809, 65000.0f);
  float _2813 = min(_2810, 65000.0f);
  float _2814 = min(_2811, 65000.0f);
  bool _2817 = isfinite(max(max(_2812, _2813), _2814));
  float _2818 = select(_2817, _2812, 1.0f);
  float _2819 = select(_2817, _2813, 1.0f);
  float _2820 = select(_2817, _2814, 1.0f);
  if (!((cPassEnabled & 8) == 0)) {
    _2855 = saturate(((cvdR.x * _2818) + (cvdR.y * _2819)) + (cvdR.z * _2820));
    _2856 = saturate(((cvdG.x * _2818) + (cvdG.y * _2819)) + (cvdG.z * _2820));
    _2857 = saturate(((cvdB.x * _2818) + (cvdB.y * _2819)) + (cvdB.z * _2820));
  } else {
    _2855 = _2818;
    _2856 = _2819;
    _2857 = _2820;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _2872 = screenInverseSize.x * SV_Position.x;
    float _2873 = screenInverseSize.y * SV_Position.y;
    float4 _2876 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2872, _2873), 0.0f);
    float _2881 = _2876.x * ColorParam.x;
    float _2882 = _2876.y * ColorParam.y;
    float _2883 = _2876.z * ColorParam.z;
    float _2886 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2872, _2873), 0.0f);
    float _2891 = (_2876.w * ColorParam.w) * saturate((_2886.x * Levels_Rate) + Levels_Range);
    if (_2881 < 0.5f) {
      _2903 = ((_2855 * 2.0f) * _2881);
    } else {
      _2903 = (1.0f - (((1.0f - _2855) * 2.0f) * (1.0f - _2881)));
    }
    if (_2882 < 0.5f) {
      _2915 = ((_2856 * 2.0f) * _2882);
    } else {
      _2915 = (1.0f - (((1.0f - _2856) * 2.0f) * (1.0f - _2882)));
    }
    if (_2883 < 0.5f) {
      _2927 = ((_2857 * 2.0f) * _2883);
    } else {
      _2927 = (1.0f - (((1.0f - _2857) * 2.0f) * (1.0f - _2883)));
    }
    _2938 = (lerp(_2855, _2903, _2891));
    _2939 = (lerp(_2856, _2915, _2891));
    _2940 = (lerp(_2857, _2927, _2891));
  } else {
    _2938 = _2855;
    _2939 = _2856;
    _2940 = _2857;
  }
  // if (tonemapParam_isHDRMode == 0.0f && ProcessSDRVanilla()) {
  //   float _2948 = invLinearBegin * _2938;
  //   if (!(_2938 >= linearBegin)) {
  //     _2956 = ((_2948 * _2948) * (3.0f - (_2948 * 2.0f)));
  //   } else {
  //     _2956 = 1.0f;
  //   }
  //   float _2957 = invLinearBegin * _2939;
  //   if (!(_2939 >= linearBegin)) {
  //     _2965 = ((_2957 * _2957) * (3.0f - (_2957 * 2.0f)));
  //   } else {
  //     _2965 = 1.0f;
  //   }
  //   float _2966 = invLinearBegin * _2940;
  //   if (!(_2940 >= linearBegin)) {
  //     _2974 = ((_2966 * _2966) * (3.0f - (_2966 * 2.0f)));
  //   } else {
  //     _2974 = 1.0f;
  //   }
  //   float _2983 = select((_2938 < linearStart), 0.0f, 1.0f);
  //   float _2984 = select((_2939 < linearStart), 0.0f, 1.0f);
  //   float _2985 = select((_2940 < linearStart), 0.0f, 1.0f);
  //   _3045 = (((((contrast * _2938) + madLinearStartContrastFactor) * (_2956 - _2983)) + (((pow(_2948, toe)) * (1.0f - _2956)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2938) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2983));
  //   _3046 = (((((contrast * _2939) + madLinearStartContrastFactor) * (_2965 - _2984)) + (((pow(_2957, toe)) * (1.0f - _2965)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2939) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2984));
  //   _3047 = (((((contrast * _2940) + madLinearStartContrastFactor) * (_2974 - _2985)) + (((pow(_2966, toe)) * (1.0f - _2974)) * linearBegin)) + ((maxNit - (exp2((contrastFactor * _2940) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2985));
  // } else {
  //   _3045 = _2938;
  //   _3046 = _2939;
  //   _3047 = _2940;
  // }
  // SV_Target.x = _3045;
  // SV_Target.y = _3046;
  // SV_Target.z = _3047;

  CustomTonemapParam params;
  params.invLinearBegin = invLinearBegin;
  params.linearBegin = linearBegin;
  params.linearStart = linearStart;
  params.contrast = contrast;
  params.linearLength = linearLength;
  params.toe = toe;
  params.maxNit = maxNit;
  params.displayMaxNitSubContrastFactor = displayMaxNitSubContrastFactor;
  params.contrastFactor = contrastFactor;
  params.mulLinearStartContrastFactor = mulLinearStartContrastFactor;
  params.madLinearStartContrastFactor = madLinearStartContrastFactor;

  SV_Target.xyz = CustomTonemap(float3(_2938, _2939, _2940), params, tonemapParam_isHDRMode == 0.0f);

  SV_Target.w = 0.0f;
  return SV_Target;
}
