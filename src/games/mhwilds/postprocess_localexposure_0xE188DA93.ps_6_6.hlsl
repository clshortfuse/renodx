#include "./postprocess.hlsl"
#include "./shared.h"

Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> RE_POSTPROCESS_Color : register(t1);

struct _WhitePtSrv {
  float data[1];
};
Buffer<uint4> WhitePtSrv : register(t2);

Texture3D<float2> BilateralLuminanceSRV : register(t3);

Texture2D<float> BlurredLogLumSRV : register(t4);

Texture2D<float> tFilterTempMap1 : register(t5);

Texture3D<float> tVolumeMap : register(t6);

Texture2D<float2> HazeNoiseResult : register(t7);

struct _ComputeResultSRV {
  float data[1];
};
StructuredBuffer<_ComputeResultSRV> ComputeResultSRV : register(t8);

Texture3D<float4> tTextureMap0 : register(t9);

Texture3D<float4> tTextureMap1 : register(t10);

Texture3D<float4> tTextureMap2 : register(t11);

Texture2D<float4> ImagePlameBase : register(t12);

Texture2D<float> ImagePlameAlpha : register(t13);

/*
struct SceneInfo
;   {
;
;       row_major float4x4 viewProjMat;               ; Offset:    0

;       row_major float3x4 transposeViewMat;          ; Offset:   64

;       row_major float3x4 transposeViewInvMat;       ; Offset:  112

;       float4 projElement[2];                        ; Offset:  160

;       float4 projInvElements[2];                    ; Offset:  192

;       row_major float4x4 viewProjInvMat;            ; Offset:  224

;       row_major float4x4 prevViewProjMat;           ; Offset:  288

;       float3 ZToLinear;                             ; Offset:  352
;       float subdivisionLevel;                       ; Offset:  364

;       float2 screenSize;                            ; Offset:  368
;       float2 screenInverseSize;                     ; Offset:  376

// 23
;       float2 cullingHelper;                         ; Offset:  384
;       float cameraNearPlane;                        ; Offset:  392
;       float cameraFarPlane;                         ; Offset:  396

;       float4 viewFrustum[8];                        ; Offset:  400

;       float4 clipplane;                             ; Offset:  528

;       float2 vrsVelocityThreshold;                  ; Offset:  544
;       uint GPUVisibleMask;                          ; Offset:  552
;       uint resolutionRatioPacked;                   ; Offset:  556

;       float3 worldOffset;                           ; Offset:  560
;       float SceneInfo_Reserve0;                     ; Offset:  572

;       uint4 rayTracingParams;                       ; Offset:  576

;       float4 sceneExtendedData;                     ; Offset:  592

;       float2 projectionSpaceJitterOffset;           ; Offset:  608
;       float2 SceneInfo_Reserve2;                    ; Offset:  616
;
;   } SceneInfo;
 */

cbuffer SceneInfo : register(b0) {
  float SceneInfo_007x : packoffset(c007.x);
  float SceneInfo_007y : packoffset(c007.y);
  float SceneInfo_007z : packoffset(c007.z);
  float SceneInfo_007w : packoffset(c007.w);
  float SceneInfo_008x : packoffset(c008.x);
  float SceneInfo_008y : packoffset(c008.y);
  float SceneInfo_008z : packoffset(c008.z);
  float SceneInfo_008w : packoffset(c008.w);
  float SceneInfo_009x : packoffset(c009.x);
  float SceneInfo_009y : packoffset(c009.y);
  float SceneInfo_009z : packoffset(c009.z);
  float SceneInfo_009w : packoffset(c009.w);
  float SceneInfo_014x : packoffset(c014.x);
  float SceneInfo_014y : packoffset(c014.y);
  float SceneInfo_014z : packoffset(c014.z);
  float SceneInfo_014w : packoffset(c014.w);
  float SceneInfo_015x : packoffset(c015.x);
  float SceneInfo_015y : packoffset(c015.y);
  float SceneInfo_015z : packoffset(c015.z);
  float SceneInfo_015w : packoffset(c015.w);
  float SceneInfo_016x : packoffset(c016.x);
  float SceneInfo_016y : packoffset(c016.y);
  float SceneInfo_016z : packoffset(c016.z);
  float SceneInfo_016w : packoffset(c016.w);
  float SceneInfo_017x : packoffset(c017.x);
  float SceneInfo_017y : packoffset(c017.y);
  float SceneInfo_017z : packoffset(c017.z);
  float SceneInfo_017w : packoffset(c017.w);
  float SceneInfo_023x : packoffset(c023.x);
  float SceneInfo_023y : packoffset(c023.y);
  float SceneInfo_023z : packoffset(c023.z);
  float SceneInfo_023w : packoffset(c023.w);
};

/*
struct RangeCompressInfo
;   {
;
;       float rangeCompress;                          ; Offset:    0
;       float rangeDecompress;                        ; Offset:    4
;       float prevRangeCompress;                      ; Offset:    8
;       float prevRangeDecompress;                    ; Offset:   12
;       float rangeCompressForResource;               ; Offset:   16
;       float rangeDecompressForResource;             ; Offset:   20
;       float rangeCompressForCommon;                 ; Offset:   24
;       float rangeDecompressForCommon;               ; Offset:   28
;
;   } RangeCompressInfo;
 */
cbuffer RangeCompressInfo : register(b1) {
  float RangeCompressInfo_000y : packoffset(c000.y);
};

/*
struct Tonemap
;   {
;
;       float exposureAdjustment;                     ; Offset:    0
;       float tonemapRange;                           ; Offset:    4
;       float specularSuppression;                    ; Offset:    8
;       float sharpness;                              ; Offset:   12

;       float preTonemapRange;                        ; Offset:   16
;       int useAutoExposure;                          ; Offset:   20
;       float echoBlend;                              ; Offset:   24
;       float AABlend;                                ; Offset:   28

;       float AASubPixel;                             ; Offset:   32
;       float ResponsiveAARate;                       ; Offset:   36
;       float VelocityWeightRate;                     ; Offset:   40
;       float DepthRejectionRate;                     ; Offset:   44

;       float ContrastTrackingRate;                   ; Offset:   48
;       float ContrastTrackingThreshold;              ; Offset:   52
;       float LEHighlightContrast;                    ; Offset:   56
;       float LEShadowContrast;                       ; Offset:   60

;       float LEDetailStrength;                       ; Offset:   64
;       float LEMiddleGreyLog;                        ; Offset:   68
;       float LEBilateralGridScale;                   ; Offset:   72
;       float LEBilateralGridBias;                    ; Offset:   76

;       float LEPreExposureLog;                       ; Offset:   80
;       int LEBlurredLogDownsampleMip;                ; Offset:   84
;       int2 LELuminanceTextureSize;                  ; Offset:   88
;
;   } Tonemap;
 */
cbuffer Tonemap : register(b2) {
  float Tonemap_000x : packoffset(c000.x);
  uint Tonemap_001y : packoffset(c001.y);  // Autoexposure
  float Tonemap_003z : packoffset(c003.z);
  float Tonemap_003w : packoffset(c003.w);
  float Tonemap_004x : packoffset(c004.x);
  float Tonemap_004y : packoffset(c004.y);
  float Tonemap_004z : packoffset(c004.z);
  float Tonemap_004w : packoffset(c004.w);
  float Tonemap_005x : packoffset(c005.x);
};

/*
;   struct CameraKerare
;   {
;
;       float kerare_scale;                           ; Offset:    0
;       float kerare_offset;                          ; Offset:    4
;       float kerare_brightness;                      ; Offset:    8
;       float film_aspect;                            ; Offset:   12
;
;   } CameraKerare;
 */

cbuffer CameraKerare : register(b3) {
  float CameraKerare_000x : packoffset(c000.x);
  float CameraKerare_000y : packoffset(c000.y);
  float CameraKerare_000z : packoffset(c000.z);
  float CameraKerare_000w : packoffset(c000.w);
};

/*
struct TonemapParam
;   {
;
;       float contrast;                               ; Offset:    0
;       float linearBegin;                            ; Offset:    4
;       float linearLength;                           ; Offset:    8
;       float toe;                                    ; Offset:   12

;       float maxNit;                                 ; Offset:   16
;       float linearStart;                            ; Offset:   20
;       float displayMaxNitSubContrastFactor;         ; Offset:   24
;       float contrastFactor;                         ; Offset:   28

;       float mulLinearStartContrastFactor;           ; Offset:   32
;       float invLinearBegin;                         ; Offset:   36
;       float madLinearStartContrastFactor;           ; Offset:   40
;       float tonemapParam_isHDRMode;                 ; Offset:   44

;       float useDynamicRangeConversion;              ; Offset:   48
;       float useHuePreserve;                         ; Offset:   52
;       float exposureScale;                          ; Offset:   56
;       float kneeStartNit;                           ; Offset:   60

;       float knee;                                   ; Offset:   64
;       float curve_HDRip;                            ; Offset:   68
;       float curve_k2;                               ; Offset:   72
;       float curve_k4;                               ; Offset:   76

;       row_major float4x4 RGBToXYZViaCrosstalkMatrix;; Offset:   80
;       row_major float4x4 XYZToRGBViaCrosstalkMatrix;; Offset:  144
;       float tonemapGraphScale;                      ; Offset:  208
;
;   } TonemapParam;
 */
/* cbuffer TonemapParam : register(b4) {
  float TonemapParam_000x : packoffset(c000.x);  // contrast
  float TonemapParam_000y : packoffset(c000.y);  // linearBegin
  float TonemapParam_000w : packoffset(c000.w);  // toe
  float TonemapParam_001x : packoffset(c001.x);  // maxNit
  float TonemapParam_001y : packoffset(c001.y);  // linearStart
  float TonemapParam_001z : packoffset(c001.z);  // displayMaxNitSubContrastFactor
  float TonemapParam_001w : packoffset(c001.w);  // contrastFactor
  float TonemapParam_002x : packoffset(c002.x);  // mulLinearStartContrastFactor
  float TonemapParam_002y : packoffset(c002.y);  // invLinearBegin
  float TonemapParam_002z : packoffset(c002.z);  // madLinearStartContrastFactor
  float TonemapParam_002w : packoffset(c002.w);  // tonemapParam_isHDRMode
}; */

/*
struct LDRPostProcessParam
;   {
;
;       float fHazeFilterStart;                       ; Offset:    0
;       float fHazeFilterInverseRange;                ; Offset:    4
;       float fHazeFilterHeightStart;                 ; Offset:    8
;       float fHazeFilterHeightInverseRange;          ; Offset:   12
;       float4 fHazeFilterUVWOffset;                  ; Offset:   16
;       float fHazeFilterScale;                       ; Offset:   32
;       float fHazeFilterBorder;                      ; Offset:   36
;       float fHazeFilterBorderFade;                  ; Offset:   40
;       float fHazeFilterDepthDiffBias;               ; Offset:   44
;       uint fHazeFilterAttribute;                    ; Offset:   48
;       uint fHazeFilterReductionResolution;          ; Offset:   52
;       uint fHazeFilterReserved1;                    ; Offset:   56
;       uint fHazeFilterReserved2;                    ; Offset:   60
;       float fDistortionCoef;                        ; Offset:   64
;       float fRefraction;                            ; Offset:   68
;       float fRefractionCenterRate;                  ; Offset:   72
;       float fGradationStartOffset;                  ; Offset:   76
;       float fGradationEndOffset;                    ; Offset:   80
;       uint aberrationEnable;                        ; Offset:   84
;       uint distortionType;                          ; Offset:   88
;       float fCorrectCoef;                           ; Offset:   92
;       uint aberrationBlurEnable;                    ; Offset:   96
;       float fBlurNoisePower;                        ; Offset:  100
;       float2 LensDistortion_Reserve;                ; Offset:  104
;       float4 fOptimizedParam;                       ; Offset:  112
;       float2 fNoisePower;                           ; Offset:  128
;       float2 fNoiseUVOffset;                        ; Offset:  136
;       float fNoiseDensity;                          ; Offset:  144
;       float fNoiseContrast;                         ; Offset:  148
;       float fBlendRate;                             ; Offset:  152
;       float fReverseNoiseSize;                      ; Offset:  156
;       float fTextureSize;                           ; Offset:  160
;       float fTextureBlendRate;                      ; Offset:  164
;       float fTextureBlendRate2;                     ; Offset:  168
;       float fTextureInverseSize;                    ; Offset:  172
;       float fHalfTextureInverseSize;                ; Offset:  176
;       float fOneMinusTextureInverseSize;            ; Offset:  180
;       float fColorCorrectTextureReserve;            ; Offset:  184
;       float fColorCorrectTextureReserve2;           ; Offset:  188
;       row_major float4x4 fColorMatrix;              ; Offset:  192
;       float4 cvdR;                                  ; Offset:  256
;       float4 cvdG;                                  ; Offset:  272
;       float4 cvdB;                                  ; Offset:  288
;       float4 ColorParam;                            ; Offset:  304
;       float Levels_Rate;                            ; Offset:  320
;       float Levels_Range;                           ; Offset:  324
;       uint Blend_Type;                              ; Offset:  328
;       float ImagePlane_Reserve;                     ; Offset:  332
;       float4 cbRadialColor;                         ; Offset:  336
;       float2 cbRadialScreenPos;                     ; Offset:  352
;       float2 cbRadialMaskSmoothstep;                ; Offset:  360
;       float2 cbRadialMaskRate;                      ; Offset:  368
;       float cbRadialBlurPower;                      ; Offset:  376
;       float cbRadialSharpRange;                     ; Offset:  380
;       uint cbRadialBlurFlags;                       ; Offset:  384
;       float cbRadialReserve0;                       ; Offset:  388
;       float cbRadialReserve1;                       ; Offset:  392
;       float cbRadialReserve2;                       ; Offset:  396
;
;   } LDRPostProcessParam;
 */
cbuffer LDRPostProcessParam : register(b5) {
  float LDRPostProcessParam_000x : packoffset(c000.x);
  float LDRPostProcessParam_000y : packoffset(c000.y);
  float LDRPostProcessParam_000z : packoffset(c000.z);
  float LDRPostProcessParam_000w : packoffset(c000.w);
  float LDRPostProcessParam_001x : packoffset(c001.x);
  float LDRPostProcessParam_001y : packoffset(c001.y);
  float LDRPostProcessParam_001z : packoffset(c001.z);
  float LDRPostProcessParam_001w : packoffset(c001.w);
  float LDRPostProcessParam_002x : packoffset(c002.x);
  float LDRPostProcessParam_002y : packoffset(c002.y);
  float LDRPostProcessParam_002z : packoffset(c002.z);
  float LDRPostProcessParam_002w : packoffset(c002.w);
  uint LDRPostProcessParam_003x : packoffset(c003.x);
  uint LDRPostProcessParam_003y : packoffset(c003.y);
  float LDRPostProcessParam_004x : packoffset(c004.x);
  float LDRPostProcessParam_004y : packoffset(c004.y);
  float LDRPostProcessParam_004z : packoffset(c004.z);
  float LDRPostProcessParam_004w : packoffset(c004.w);
  float LDRPostProcessParam_005x : packoffset(c005.x);
  uint LDRPostProcessParam_005y : packoffset(c005.y);  // aberrationEnable
  uint LDRPostProcessParam_005z : packoffset(c005.z);  // distortionType
  float LDRPostProcessParam_005w : packoffset(c005.w);
  uint LDRPostProcessParam_006x : packoffset(c006.x);
  float LDRPostProcessParam_006y : packoffset(c006.y);
  float LDRPostProcessParam_007x : packoffset(c007.x);
  float LDRPostProcessParam_007y : packoffset(c007.y);
  float LDRPostProcessParam_007z : packoffset(c007.z);
  float LDRPostProcessParam_007w : packoffset(c007.w);
  float LDRPostProcessParam_008x : packoffset(c008.x);
  float LDRPostProcessParam_008y : packoffset(c008.y);
  float LDRPostProcessParam_008z : packoffset(c008.z);
  float LDRPostProcessParam_008w : packoffset(c008.w);
  float LDRPostProcessParam_009x : packoffset(c009.x);  // fNoiseDensity
  float LDRPostProcessParam_009y : packoffset(c009.y);
  float LDRPostProcessParam_009z : packoffset(c009.z);
  float LDRPostProcessParam_009w : packoffset(c009.w);  // fReverseNoiseSize
  float LDRPostProcessParam_010y : packoffset(c010.y);  // fTextureBlendRate
  float LDRPostProcessParam_010z : packoffset(c010.z);
  float LDRPostProcessParam_011x : packoffset(c011.x);
  float LDRPostProcessParam_011y : packoffset(c011.y);  // fOneMinusTextureInverseSize
  float LDRPostProcessParam_012x : packoffset(c012.x);  // fColorMatrix
  float LDRPostProcessParam_012y : packoffset(c012.y);
  float LDRPostProcessParam_012z : packoffset(c012.z);
  float LDRPostProcessParam_013x : packoffset(c013.x);
  float LDRPostProcessParam_013y : packoffset(c013.y);
  float LDRPostProcessParam_013z : packoffset(c013.z);
  float LDRPostProcessParam_014x : packoffset(c014.x);
  float LDRPostProcessParam_014y : packoffset(c014.y);
  float LDRPostProcessParam_014z : packoffset(c014.z);
  float LDRPostProcessParam_015x : packoffset(c015.x);
  float LDRPostProcessParam_015y : packoffset(c015.y);
  float LDRPostProcessParam_015z : packoffset(c015.z);
  float LDRPostProcessParam_016x : packoffset(c016.x);  // cvdR
  float LDRPostProcessParam_016y : packoffset(c016.y);  // cvdG
  float LDRPostProcessParam_016z : packoffset(c016.z);  // cvdB
  float LDRPostProcessParam_017x : packoffset(c017.x);
  float LDRPostProcessParam_017y : packoffset(c017.y);
  float LDRPostProcessParam_017z : packoffset(c017.z);
  float LDRPostProcessParam_018x : packoffset(c018.x);
  float LDRPostProcessParam_018y : packoffset(c018.y);
  float LDRPostProcessParam_018z : packoffset(c018.z);
  float LDRPostProcessParam_019x : packoffset(c019.x);  // ColorParam
  float LDRPostProcessParam_019y : packoffset(c019.y);
  float LDRPostProcessParam_019z : packoffset(c019.z);
  float LDRPostProcessParam_019w : packoffset(c019.w);
  float LDRPostProcessParam_020x : packoffset(c020.x);
  float LDRPostProcessParam_020y : packoffset(c020.y);
  float LDRPostProcessParam_021x : packoffset(c021.x);
  float LDRPostProcessParam_021y : packoffset(c021.y);
  float LDRPostProcessParam_021z : packoffset(c021.z);
  float LDRPostProcessParam_021w : packoffset(c021.w);
  float LDRPostProcessParam_022x : packoffset(c022.x);
  float LDRPostProcessParam_022y : packoffset(c022.y);
  float LDRPostProcessParam_022z : packoffset(c022.z);
  float LDRPostProcessParam_022w : packoffset(c022.w);
  float LDRPostProcessParam_023x : packoffset(c023.x);
  float LDRPostProcessParam_023y : packoffset(c023.y);
  float LDRPostProcessParam_023z : packoffset(c023.z);
  float LDRPostProcessParam_023w : packoffset(c023.w);
  uint LDRPostProcessParam_024x : packoffset(c024.x);
};

/*
struct CBControl
;   {
;
;       float3 CBControl_reserve;                     ; Offset:    0
;       uint cPassEnabled;                            ; Offset:   12

;       row_major float4x4 fOCIOTransformMatrix;      ; Offset:   16

;       struct struct.RGCParam
;       {
;
;           float CyanLimit;                          ; Offset:   80
;           float MagentaLimit;                       ; Offset:   84
;           float YellowLimit;                        ; Offset:   88
;           float CyanThreshold;                      ; Offset:   92

;           float MagentaThreshold;                   ; Offset:   96
;           float YellowThreshold;                    ; Offset:  100
;           float RollOff;                            ; Offset:  104
;           uint EnableReferenceGamutCompress;        ; Offset:  108

;           float InvCyanSTerm;                       ; Offset:  112
;           float InvMagentaSTerm;                    ; Offset:  116
;           float InvYellowSTerm;                     ; Offset:  120
;           float InvRollOff;                         ; Offset:  124
;
;       } cbControlRGCParam;                          ; Offset:   80
;
;
;   } CBControl;
 */
cbuffer CBControl : register(b6) {
  uint CBControl_000w : packoffset(c000.w);   // cPassEnabled
  float CBControl_001x : packoffset(c001.x);  // fOCIOTransformMatrix
  float CBControl_001y : packoffset(c001.y);
  float CBControl_001z : packoffset(c001.z);
  float CBControl_002x : packoffset(c002.x);
  float CBControl_002y : packoffset(c002.y);
  float CBControl_002z : packoffset(c002.z);
  float CBControl_003x : packoffset(c003.x);
  float CBControl_003y : packoffset(c003.y);
  float CBControl_003z : packoffset(c003.z);
  float CBControl_005w : packoffset(c005.w);
  float CBControl_006x : packoffset(c006.x);
  float CBControl_006y : packoffset(c006.y);
  float CBControl_006z : packoffset(c006.z);
  uint CBControl_006w : packoffset(c006.w);  // EnableReferenceGamutCompress
  float CBControl_007x : packoffset(c007.x);
  float CBControl_007y : packoffset(c007.y);
  float CBControl_007z : packoffset(c007.z);
  float CBControl_007w : packoffset(c007.w);
};

SamplerState PointClamp : register(s1, space32);

SamplerState BilinearWrap : register(s4, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

/*
REF pp mod findings:
Both disabled: flat exposure with no luminance shaders
Local exposure only: flat exposure with flat luminance shaders
Both enabled: local exposure with blurred luminance shaders
 */
float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;

  bool _44 = ((((uint)(CBControl_000w)) & 1) == 0);
  bool _50 = false;
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
  float _2852;
  float _2853;
  float _2854;
  float _2900;
  float _2912;
  float _2924;
  float _2935;
  float _2936;
  float _2937;
  float _2953;
  float _2962;
  float _2971;
  float _3042;
  float _3043;
  float _3044;

  if (!_44) {
    _50 = ((((uint)(LDRPostProcessParam_005z)) == 0));
  }
  _56 = false;
  if (!_44) {
    _56 = ((((uint)(LDRPostProcessParam_005z)) == 1));
  }
  bool _58 = ((((uint)(CBControl_000w)) & 64) != 0);
  [branch]
  if ((((CameraKerare_000w) == 0.0f))) {
    float _66 = (Kerare.x) / (Kerare.w);
    float _67 = (Kerare.y) / (Kerare.w);
    float _68 = (Kerare.z) / (Kerare.w);
    float _72 = abs(((rsqrt((dot(float3(_66, _67, _68), float3(_66, _67, _68))))) * _68));
    float _77 = _72 * _72;
    _105 = ((_77 * _77) * (1.0f - (saturate((((CameraKerare_000x)*_72) + (CameraKerare_000y))))));
  } else {
    float _88 = (((SceneInfo_023w) * (SV_Position.y)) + -0.5f) * 2.0f;
    float _90 = ((CameraKerare_000w) * 2.0f) * (((SceneInfo_023z) * (SV_Position.x)) + -0.5f);
    float _92 = sqrt((dot(float2(_90, _88), float2(_90, _88))));
    float _100 = (_92 * _92) + 1.0f;
    _105 = ((1.0f / (_100 * _100)) * (1.0f - (saturate((((CameraKerare_000x) * (1.0f / (_92 + 1.0f))) + (CameraKerare_000y))))));
  }
  float _107 = saturate((_105 + (CameraKerare_000z)));
  CustomVignette(_107);
  float _108 = _107 * (Exposure);
  // Lens distortion
  if (_50) {
    float _125 = ((SceneInfo_023z) * (SV_Position.x)) + -0.5f;
    float _126 = ((SceneInfo_023w) * (SV_Position.y)) + -0.5f;
    float _127 = dot(float2(_125, _126), float2(_125, _126));
    float _130 = ((_127 * (LDRPostProcessParam_004x)) + 1.0f) * (LDRPostProcessParam_005w);
    float _131 = _130 * _125;
    float _132 = _130 * _126;
    float _133 = _131 + 0.5f;
    float _134 = _132 + 0.5f;

    if (((((uint)(LDRPostProcessParam_005y)) == 0))) {  // aberrationEnable
      // Not here
      _402 = _133;
      _403 = _134;

      do {
        if (_58) {
          if (!((((uint)(LDRPostProcessParam_003y)) == 0))) {
            float2 _144 = HazeNoiseResult.Sample(BilinearWrap, float2(_133, _134));
            _402 = (((LDRPostProcessParam_002x) * (_144.x)) + _133);
            _403 = (((LDRPostProcessParam_002x) * (_144.y)) + _134);
          } else {
            bool _156 = ((((uint)(LDRPostProcessParam_003x)) & 2) != 0);
            do {
              if (_156) {
                float _175 = (((_133 * 2.0f) * (SceneInfo_023x)) * (SceneInfo_023z)) + -1.0f;
                float _176 = 1.0f - (((_134 * 2.0f) * (SceneInfo_023y)) * (SceneInfo_023w));
                float _213 = 1.0f / ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_133, _134), 0.0f)).x), (SceneInfo_016w), (mad(_176, (SceneInfo_015w), (_175 * (SceneInfo_014w)))))) + (SceneInfo_017w));
                float _215 = _213 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_133, _134), 0.0f)).x), (SceneInfo_016y), (mad(_176, (SceneInfo_015y), (_175 * (SceneInfo_014y)))))) + (SceneInfo_017y));
                float _223 = (_213 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_133, _134), 0.0f)).x), (SceneInfo_016x), (mad(_176, (SceneInfo_015x), (_175 * (SceneInfo_014x)))))) + (SceneInfo_017x))) - (SceneInfo_007w);
                float _224 = _215 - (SceneInfo_008w);
                float _225 = (_213 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_133, _134), 0.0f)).x), (SceneInfo_016z), (mad(_176, (SceneInfo_015z), (_175 * (SceneInfo_014z)))))) + (SceneInfo_017z))) - (SceneInfo_009w);
                _250 = (saturate((((tFilterTempMap1.Sample(BilinearWrap, float2(_133, _134))).x) * (max((((sqrt((((_224 * _224) + (_223 * _223)) + (_225 * _225)))) - (LDRPostProcessParam_000x)) * (LDRPostProcessParam_000y)), ((_215 - (LDRPostProcessParam_000z)) * (LDRPostProcessParam_000w)))))));
                _251 = ((ReadonlyDepth.SampleLevel(PointClamp, float2(_133, _134), 0.0f)).x);
              } else {
                _250 = ((((bool)(((((uint)(LDRPostProcessParam_003x)) & 1) != 0))) ? (1.0f - ((tFilterTempMap1.Sample(BilinearWrap, float2(_133, _134))).x)) : ((tFilterTempMap1.Sample(BilinearWrap, float2(_133, _134))).x)));
                _251 = 0.0f;
              }
              _273 = 1.0f;
              do {
                if (!(((((uint)(LDRPostProcessParam_003x)) & 4) == 0))) {
                  float _263 = 0.5f / (LDRPostProcessParam_002y);
                  _273 = (1.0f - (saturate((max(((_263 * (min((max(((abs(_131)) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)), ((_263 * (min((max(((abs(_132)) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)))))));
                }
                float _274 = _273 * _250;
                _393 = 0.0f;
                _394 = 0.0f;
                do {
                  if ((!(_274 <= 9.999999747378752e-06f))) {
                    float _281 = -0.0f - _134;
                    float _304 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_007z), (mad(_281, (SceneInfo_007y), ((SceneInfo_007x)*_133)))));
                    float _305 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_008z), (mad(_281, (SceneInfo_008y), ((SceneInfo_008x)*_133)))));
                    float _306 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_009z), (mad(_281, (SceneInfo_009y), ((SceneInfo_009x)*_133)))));
                    float _315 = _304 * 2.0f;
                    float _316 = _305 * 2.0f;
                    float _317 = _306 * 2.0f;
                    float _325 = _304 * 4.0f;
                    float _326 = _305 * 4.0f;
                    float _327 = _306 * 4.0f;
                    float _335 = _304 * 8.0f;
                    float _336 = _305 * 8.0f;
                    float _337 = _306 * 8.0f;
                    float _345 = (LDRPostProcessParam_001x) + 0.5f;
                    float _346 = (LDRPostProcessParam_001y) + 0.5f;
                    float _347 = (LDRPostProcessParam_001z) + 0.5f;
                    float _379 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_315 + (LDRPostProcessParam_001x)), (_316 + (LDRPostProcessParam_001y)), (_317 + (LDRPostProcessParam_001z))))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_304 + (LDRPostProcessParam_001x)), (_305 + (LDRPostProcessParam_001y)), (_306 + (LDRPostProcessParam_001z))))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_325 + (LDRPostProcessParam_001x)), (_326 + (LDRPostProcessParam_001y)), (_327 + (LDRPostProcessParam_001z))))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_335 + (LDRPostProcessParam_001x)), (_336 + (LDRPostProcessParam_001y)), (_337 + (LDRPostProcessParam_001z))))).x) * 0.0625f)) * 2.0f) + -1.0f) * _274;
                    float _380 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_315 + _345), (_316 + _346), (_317 + _347)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_304 + _345), (_305 + _346), (_306 + _347)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_325 + _345), (_326 + _346), (_327 + _347)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_335 + _345), (_336 + _346), (_337 + _347)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _274;
                    _393 = _379;
                    _394 = _380;
                    if (_156) {
                      _393 = 0.0f;
                      _394 = 0.0f;
                      if ((!((((ReadonlyDepth.Sample(BilinearWrap, float2((_379 + _133), (_380 + _134)))).x) - _251) >= (LDRPostProcessParam_002w)))) {
                        _393 = _379;
                        _394 = _380;
                      }
                    }
                  }
                  _402 = (((LDRPostProcessParam_002x)*_393) + _133);
                  _403 = (((LDRPostProcessParam_002x)*_394) + _134);
                } while (false);
              } while (false);
            } while (false);
          }
        }

        _402 = lerp(_133, _402, CUSTOM_ABERRATION);
        _403 = lerp(_134, _403, CUSTOM_ABERRATION);

        float4 _406 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_402, _403));

        _421 = 1.0f;
        do {
          if (!((((uint)(Tonemap_001y)) == 0))) {  // linearStart
            _421 = (asfloat((((int4)(asint(WhitePtSrv[0 / 4]))).x)));
          }
          float _422 = _421 * (Tonemap_000x);
          float _433 = log2(((dot(float3(((_422 * (_406.x)) * (RangeCompressInfo_000y)), ((_422 * (_406.y)) * (RangeCompressInfo_000y)), ((_422 * (_406.z)) * (RangeCompressInfo_000y))), float3(0.25f, 0.5f, 0.25f))) + 9.999999747378752e-06f));
          float2 _442 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_402, _403, (((((Tonemap_004z)*_433) + (Tonemap_004w)) * 0.984375f) + 0.0078125f)), 0.0f);
          float _450 = (((bool)(((_442.y) < 0.0010000000474974513f))) ? ((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_402, _403), 0.0f)).x) : ((_442.x) / (_442.y)));
          float _456 = ((Tonemap_005x) + _450) + ((((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_402, _403), 0.0f)).x) - _450) * 0.6000000238418579f);
          float _457 = (Tonemap_005x) + _433;
          float _460 = _456 - (Tonemap_004y);
          float _472 = exp2(((((((((bool)((_460 > 0.0f))) ? (Tonemap_003z) : (Tonemap_003w))) * _460) - _457) + (Tonemap_004y)) + ((Tonemap_004x) * (_457 - _456))));

          _472 = PickExposure(_472);

          _1453 = (((_406.x) * _108) * _472);
          _1454 = (((_406.y) * _108) * _472);
          _1455 = (((_406.z) * _108) * _472);
          _1456 = (LDRPostProcessParam_004x);
          _1457 = 0.0f;
          _1458 = 0.0f;
          _1459 = 0.0f;
          _1460 = 0.0f;
          _1461 = (LDRPostProcessParam_005w);
        } while (false);

      } while (false);
    } else {
      float _495 = (((saturate((((sqrt(((_125 * _125) + (_126 * _126)))) - (LDRPostProcessParam_004w)) / ((LDRPostProcessParam_005x) - (LDRPostProcessParam_004w))))) * (1.0f - (LDRPostProcessParam_004z))) + (LDRPostProcessParam_004z)) * (LDRPostProcessParam_004y);
      float _497 = _125 * (LDRPostProcessParam_005w);
      float _498 = _126 * (LDRPostProcessParam_005w);
      if (!((((uint)(LDRPostProcessParam_006x)) == 0))) {
        float _507 = ((LDRPostProcessParam_006y) * 0.125f) * (frac(((frac((dot(float2((SV_Position.x), (SV_Position.y)), float2(0.0671105608344078f, 0.005837149918079376f))))) * 52.98291778564453f)));
        float _508 = _495 * 2.0f;
        float _512 = (((_508 * _507) + _127) * (LDRPostProcessParam_004x)) + 1.0f;
        float _523 = (((_508 * (_507 + 0.125f)) + _127) * (LDRPostProcessParam_004x)) + 1.0f;
        float _535 = (((_508 * (_507 + 0.25f)) + _127) * (LDRPostProcessParam_004x)) + 1.0f;
        float4 _540 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _535) + 0.5f), ((_498 * _535) + 0.5f)));
        float _549 = (((_508 * (_507 + 0.375f)) + _127) * (LDRPostProcessParam_004x)) + 1.0f;
        float4 _554 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _549) + 0.5f), ((_498 * _549) + 0.5f)));
        float _563 = (((_508 * (_507 + 0.5f)) + _127) * (LDRPostProcessParam_004x)) + 1.0f;
        float _574 = (((_508 * (_507 + 0.625f)) + _127) * (LDRPostProcessParam_004x)) + 1.0f;
        float4 _579 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _574) + 0.5f), ((_498 * _574) + 0.5f)));
        float _587 = (((_508 * (_507 + 0.75f)) + _127) * (LDRPostProcessParam_004x)) + 1.0f;
        float4 _592 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _587) + 0.5f), ((_498 * _587) + 0.5f)));
        float _607 = (((_508 * (_507 + 0.875f)) + _127) * (LDRPostProcessParam_004x)) + 1.0f;
        float _619 = (((_508 * (_507 + 1.0f)) + _127) * (LDRPostProcessParam_004x)) + 1.0f;
        float _627 = _108 * 0.3199999928474426f;
        _1453 = (_627 * ((((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _523) + 0.5f), ((_498 * _523) + 0.5f))))).x) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _512) + 0.5f), ((_498 * _512) + 0.5f))))).x)) + ((_540.x) * 0.75f)) + ((_554.x) * 0.375f)));
        _1454 = ((_108 * 0.3636363744735718f) * (((((_579.y) + (_554.y)) * 0.625f) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _563) + 0.5f), ((_498 * _563) + 0.5f))))).y)) + (((_592.y) + (_540.y)) * 0.25f)));
        _1455 = (_627 * (((((_592.z) * 0.75f) + ((_579.z) * 0.375f)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _607) + 0.5f), ((_498 * _607) + 0.5f))))).z)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _619) + 0.5f), ((_498 * _619) + 0.5f))))).z)));
        _1456 = (LDRPostProcessParam_004x);
        _1457 = 0.0f;
        _1458 = 0.0f;
        _1459 = 0.0f;
        _1460 = 0.0f;
        _1461 = (LDRPostProcessParam_005w);
      } else {
        float _633 = _495 + _127;
        float _635 = (_633 * (LDRPostProcessParam_004x)) + 1.0f;
        float _642 = ((_633 + _495) * (LDRPostProcessParam_004x)) + 1.0f;
        _1453 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_133, _134)))).x) * _108);
        _1454 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _635) + 0.5f), ((_498 * _635) + 0.5f))))).y) * _108);
        _1455 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_497 * _642) + 0.5f), ((_498 * _642) + 0.5f))))).z) * _108);
        _1456 = (LDRPostProcessParam_004x);
        _1457 = 0.0f;
        _1458 = 0.0f;
        _1459 = 0.0f;
        _1460 = 0.0f;
        _1461 = (LDRPostProcessParam_005w);
      }
    }
  } else {
    if (_56) {
      float _667 = (((SV_Position.x) * 2.0f) * (SceneInfo_023z)) + -1.0f;
      float _671 = sqrt(((_667 * _667) + 1.0f));
      float _672 = 1.0f / _671;
      float _675 = (_671 * (LDRPostProcessParam_007z)) * (_672 + (LDRPostProcessParam_007x));
      float _679 = (LDRPostProcessParam_007w) * 0.5f;
      float _681 = (_679 * _667) * _675;
      float _684 = ((_679 * ((((SV_Position.y) * 2.0f) * (SceneInfo_023w)) + -1.0f)) * (((_672 + -1.0f) * (LDRPostProcessParam_007y)) + 1.0f)) * _675;
      float _685 = _681 + 0.5f;
      float _686 = _684 + 0.5f;
      _952 = _685;
      _953 = _686;
      do {
        if (_58) {
          if (!((((uint)(LDRPostProcessParam_003y)) == 0))) {
            float2 _694 = HazeNoiseResult.Sample(BilinearWrap, float2(_685, _686));
            _952 = (((LDRPostProcessParam_002x) * (_694.x)) + _685);
            _953 = (((LDRPostProcessParam_002x) * (_694.y)) + _686);
          } else {
            bool _706 = ((((uint)(LDRPostProcessParam_003x)) & 2) != 0);
            do {
              if (_706) {
                float _725 = (((_685 * 2.0f) * (SceneInfo_023x)) * (SceneInfo_023z)) + -1.0f;
                float _726 = 1.0f - (((_686 * 2.0f) * (SceneInfo_023y)) * (SceneInfo_023w));
                float _763 = 1.0f / ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_685, _686), 0.0f)).x), (SceneInfo_016w), (mad(_726, (SceneInfo_015w), (_725 * (SceneInfo_014w)))))) + (SceneInfo_017w));
                float _765 = _763 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_685, _686), 0.0f)).x), (SceneInfo_016y), (mad(_726, (SceneInfo_015y), (_725 * (SceneInfo_014y)))))) + (SceneInfo_017y));
                float _773 = (_763 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_685, _686), 0.0f)).x), (SceneInfo_016x), (mad(_726, (SceneInfo_015x), (_725 * (SceneInfo_014x)))))) + (SceneInfo_017x))) - (SceneInfo_007w);
                float _774 = _765 - (SceneInfo_008w);
                float _775 = (_763 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_685, _686), 0.0f)).x), (SceneInfo_016z), (mad(_726, (SceneInfo_015z), (_725 * (SceneInfo_014z)))))) + (SceneInfo_017z))) - (SceneInfo_009w);
                _800 = (saturate((((tFilterTempMap1.Sample(BilinearWrap, float2(_685, _686))).x) * (max((((sqrt((((_774 * _774) + (_773 * _773)) + (_775 * _775)))) - (LDRPostProcessParam_000x)) * (LDRPostProcessParam_000y)), ((_765 - (LDRPostProcessParam_000z)) * (LDRPostProcessParam_000w)))))));
                _801 = ((ReadonlyDepth.SampleLevel(PointClamp, float2(_685, _686), 0.0f)).x);
              } else {
                _800 = ((((bool)(((((uint)(LDRPostProcessParam_003x)) & 1) != 0))) ? (1.0f - ((tFilterTempMap1.Sample(BilinearWrap, float2(_685, _686))).x)) : ((tFilterTempMap1.Sample(BilinearWrap, float2(_685, _686))).x)));
                _801 = 0.0f;
              }
              _823 = 1.0f;
              do {
                if (!(((((uint)(LDRPostProcessParam_003x)) & 4) == 0))) {
                  float _813 = 0.5f / (LDRPostProcessParam_002y);
                  _823 = (1.0f - (saturate((max(((_813 * (min((max(((abs(_681)) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)), ((_813 * (min((max(((abs(_684)) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)))))));
                }
                float _824 = _823 * _800;
                _943 = 0.0f;
                _944 = 0.0f;
                do {
                  if ((!(_824 <= 9.999999747378752e-06f))) {
                    float _831 = -0.0f - _686;
                    float _854 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_007z), (mad(_831, (SceneInfo_007y), ((SceneInfo_007x)*_685)))));
                    float _855 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_008z), (mad(_831, (SceneInfo_008y), ((SceneInfo_008x)*_685)))));
                    float _856 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_009z), (mad(_831, (SceneInfo_009y), ((SceneInfo_009x)*_685)))));
                    float _865 = _854 * 2.0f;
                    float _866 = _855 * 2.0f;
                    float _867 = _856 * 2.0f;
                    float _875 = _854 * 4.0f;
                    float _876 = _855 * 4.0f;
                    float _877 = _856 * 4.0f;
                    float _885 = _854 * 8.0f;
                    float _886 = _855 * 8.0f;
                    float _887 = _856 * 8.0f;
                    float _895 = (LDRPostProcessParam_001x) + 0.5f;
                    float _896 = (LDRPostProcessParam_001y) + 0.5f;
                    float _897 = (LDRPostProcessParam_001z) + 0.5f;
                    float _929 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_865 + (LDRPostProcessParam_001x)), (_866 + (LDRPostProcessParam_001y)), (_867 + (LDRPostProcessParam_001z))))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_854 + (LDRPostProcessParam_001x)), (_855 + (LDRPostProcessParam_001y)), (_856 + (LDRPostProcessParam_001z))))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_875 + (LDRPostProcessParam_001x)), (_876 + (LDRPostProcessParam_001y)), (_877 + (LDRPostProcessParam_001z))))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_885 + (LDRPostProcessParam_001x)), (_886 + (LDRPostProcessParam_001y)), (_887 + (LDRPostProcessParam_001z))))).x) * 0.0625f)) * 2.0f) + -1.0f) * _824;
                    float _930 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_865 + _895), (_866 + _896), (_867 + _897)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_854 + _895), (_855 + _896), (_856 + _897)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_875 + _895), (_876 + _896), (_877 + _897)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_885 + _895), (_886 + _896), (_887 + _897)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _824;
                    _943 = _929;
                    _944 = _930;
                    if (_706) {
                      _943 = 0.0f;
                      _944 = 0.0f;
                      if ((!((((ReadonlyDepth.Sample(BilinearWrap, float2((_929 + _685), (_930 + _686)))).x) - _801) >= (LDRPostProcessParam_002w)))) {
                        _943 = _929;
                        _944 = _930;
                      }
                    }
                  }
                  _952 = (((LDRPostProcessParam_002x)*_943) + _685);
                  _953 = (((LDRPostProcessParam_002x)*_944) + _686);
                } while (false);
              } while (false);
            } while (false);
          }
        }
        // This section in local FOR SURE
        float4 _956 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_952, _953));
        SV_Target.rgb = float3(1, 1, 2);

        do {
          // Here
          if (!((((uint)(Tonemap_001y)) == 0))) {
            // Here
            _971 = (asfloat((((int4)(asint(WhitePtSrv[0 / 4]))).x)));
          }
          float _972 = _971 * (Tonemap_000x);
          float _983 = log2(((dot(float3(((_972 * (_956.x)) * (RangeCompressInfo_000y)), ((_972 * (_956.y)) * (RangeCompressInfo_000y)), ((_972 * (_956.z)) * (RangeCompressInfo_000y))), float3(0.25f, 0.5f, 0.25f))) + 9.999999747378752e-06f));
          float2 _993 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_952, _953, (((((Tonemap_004z)*_983) + (Tonemap_004w)) * 0.984375f) + 0.0078125f)), 0.0f);
          float _1001 = (((bool)(((_993.y) < 0.0010000000474974513f))) ? ((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_952, _953), 0.0f)).x) : ((_993.x) / (_993.y)));
          float _1007 = ((Tonemap_005x) + _1001) + ((((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_952, _953), 0.0f)).x) - _1001) * 0.6000000238418579f);
          float _1008 = (Tonemap_005x) + _983;
          float _1011 = _1007 - (Tonemap_004y);
          float _1023 = exp2(((((((((bool)((_1011 > 0.0f))) ? (Tonemap_003z) : (Tonemap_003w))) * _1011) - _1008) + (Tonemap_004y)) + ((Tonemap_004x) * (_1008 - _1007))));

          _1023 = PickExposure(_1023);

          _1453 = (((_956.x) * _108) * _1023);
          _1454 = (((_956.y) * _108) * _1023);
          _1455 = (((_956.z) * _108) * _1023);
          _1456 = 0.0f;
          _1457 = (LDRPostProcessParam_007x);
          _1458 = (LDRPostProcessParam_007y);
          _1459 = (LDRPostProcessParam_007z);
          _1460 = (LDRPostProcessParam_007w);
          _1461 = 1.0f;
        } while (false);
      } while (false);
    } else {
      // This section in local FOR SURE
      SV_Target.rgb = float3(1, 1, 1);

      float _1031 = (SceneInfo_023z) * (SV_Position.x);
      float _1032 = (SceneInfo_023w) * (SV_Position.y);
      do {
        if (!_58) {
          // Here
          float4 _1036 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_1031, _1032));

          _1051 = 1.0f;
          do {
            if (!((((uint)(Tonemap_001y)) == 0))) {
              _1051 = (asfloat((((int4)(asint(WhitePtSrv[0 / 4]))).x)));
            }
            float _1052 = _1051 * (Tonemap_000x);
            float _1063 = log2(((dot(float3(((_1052 * (_1036.x)) * (RangeCompressInfo_000y)), ((_1052 * (_1036.y)) * (RangeCompressInfo_000y)), ((_1052 * (_1036.z)) * (RangeCompressInfo_000y))), float3(0.25f, 0.5f, 0.25f))) + 9.999999747378752e-06f));
            float2 _1072 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_1031, _1032, (((((Tonemap_004z)*_1063) + (Tonemap_004w)) * 0.984375f) + 0.0078125f)), 0.0f);
            float _1080 = (((bool)(((_1072.y) < 0.0010000000474974513f))) ? ((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_1031, _1032), 0.0f)).x) : ((_1072.x) / (_1072.y)));
            float _1086 = ((Tonemap_005x) + _1080) + ((((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_1031, _1032), 0.0f)).x) - _1080) * 0.6000000238418579f);
            float _1087 = (Tonemap_005x) + _1063;
            float _1090 = _1086 - (Tonemap_004y);
            float _1102 = exp2(((((((((bool)((_1090 > 0.0f))) ? (Tonemap_003z) : (Tonemap_003w))) * _1090) - _1087) + (Tonemap_004y)) + ((Tonemap_004x) * (_1087 - _1086))));

            _1102 = PickExposure(_1102);

            _1446 = (_1102 * (_1036.x));
            _1447 = (_1102 * (_1036.y));
            _1448 = (_1102 * (_1036.z));
          } while (false);
        } else {
          do {
            if (!((((uint)(LDRPostProcessParam_003y)) == 0))) {
              float2 _1113 = HazeNoiseResult.Sample(BilinearWrap, float2(_1031, _1032));
              _1369 = ((LDRPostProcessParam_002x) * (_1113.x));
              _1370 = ((LDRPostProcessParam_002x) * (_1113.y));
            } else {
              bool _1123 = ((((uint)(LDRPostProcessParam_003x)) & 2) != 0);
              do {
                if (_1123) {
                  float _1142 = (((_1031 * 2.0f) * (SceneInfo_023x)) * (SceneInfo_023z)) + -1.0f;
                  float _1143 = 1.0f - (((_1032 * 2.0f) * (SceneInfo_023y)) * (SceneInfo_023w));
                  float _1180 = 1.0f / ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_1031, _1032), 0.0f)).x), (SceneInfo_016w), (mad(_1143, (SceneInfo_015w), (_1142 * (SceneInfo_014w)))))) + (SceneInfo_017w));
                  float _1182 = _1180 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_1031, _1032), 0.0f)).x), (SceneInfo_016y), (mad(_1143, (SceneInfo_015y), (_1142 * (SceneInfo_014y)))))) + (SceneInfo_017y));
                  float _1190 = (_1180 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_1031, _1032), 0.0f)).x), (SceneInfo_016x), (mad(_1143, (SceneInfo_015x), (_1142 * (SceneInfo_014x)))))) + (SceneInfo_017x))) - (SceneInfo_007w);
                  float _1191 = _1182 - (SceneInfo_008w);
                  float _1192 = (_1180 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_1031, _1032), 0.0f)).x), (SceneInfo_016z), (mad(_1143, (SceneInfo_015z), (_1142 * (SceneInfo_014z)))))) + (SceneInfo_017z))) - (SceneInfo_009w);
                  _1217 = (saturate((((tFilterTempMap1.Sample(BilinearWrap, float2(_1031, _1032))).x) * (max((((sqrt((((_1191 * _1191) + (_1190 * _1190)) + (_1192 * _1192)))) - (LDRPostProcessParam_000x)) * (LDRPostProcessParam_000y)), ((_1182 - (LDRPostProcessParam_000z)) * (LDRPostProcessParam_000w)))))));
                  _1218 = ((ReadonlyDepth.SampleLevel(PointClamp, float2(_1031, _1032), 0.0f)).x);
                } else {
                  _1217 = ((((bool)(((((uint)(LDRPostProcessParam_003x)) & 1) != 0))) ? (1.0f - ((tFilterTempMap1.Sample(BilinearWrap, float2(_1031, _1032))).x)) : ((tFilterTempMap1.Sample(BilinearWrap, float2(_1031, _1032))).x)));
                  _1218 = 0.0f;
                }
                _1242 = 1.0f;
                do {
                  if (!(((((uint)(LDRPostProcessParam_003x)) & 4) == 0))) {
                    float _1232 = 0.5f / (LDRPostProcessParam_002y);
                    _1242 = (1.0f - (saturate((max(((_1232 * (min((max(((abs((_1031 + -0.5f))) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)), ((_1232 * (min((max(((abs((_1032 + -0.5f))) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)))))));
                  }
                  float _1243 = _1242 * _1217;
                  _1362 = 0.0f;
                  _1363 = 0.0f;
                  do {
                    if ((!(_1243 <= 9.999999747378752e-06f))) {
                      float _1250 = -0.0f - _1032;
                      float _1273 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_007z), (mad(_1250, (SceneInfo_007y), ((SceneInfo_007x)*_1031)))));
                      float _1274 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_008z), (mad(_1250, (SceneInfo_008y), ((SceneInfo_008x)*_1031)))));
                      float _1275 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_009z), (mad(_1250, (SceneInfo_009y), ((SceneInfo_009x)*_1031)))));
                      float _1284 = _1273 * 2.0f;
                      float _1285 = _1274 * 2.0f;
                      float _1286 = _1275 * 2.0f;
                      float _1294 = _1273 * 4.0f;
                      float _1295 = _1274 * 4.0f;
                      float _1296 = _1275 * 4.0f;
                      float _1304 = _1273 * 8.0f;
                      float _1305 = _1274 * 8.0f;
                      float _1306 = _1275 * 8.0f;
                      float _1314 = (LDRPostProcessParam_001x) + 0.5f;
                      float _1315 = (LDRPostProcessParam_001y) + 0.5f;
                      float _1316 = (LDRPostProcessParam_001z) + 0.5f;
                      float _1348 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1284 + (LDRPostProcessParam_001x)), (_1285 + (LDRPostProcessParam_001y)), (_1286 + (LDRPostProcessParam_001z))))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_1273 + (LDRPostProcessParam_001x)), (_1274 + (LDRPostProcessParam_001y)), (_1275 + (LDRPostProcessParam_001z))))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1294 + (LDRPostProcessParam_001x)), (_1295 + (LDRPostProcessParam_001y)), (_1296 + (LDRPostProcessParam_001z))))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1304 + (LDRPostProcessParam_001x)), (_1305 + (LDRPostProcessParam_001y)), (_1306 + (LDRPostProcessParam_001z))))).x) * 0.0625f)) * 2.0f) + -1.0f) * _1243;
                      float _1349 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1284 + _1314), (_1285 + _1315), (_1286 + _1316)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_1273 + _1314), (_1274 + _1315), (_1275 + _1316)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1294 + _1314), (_1295 + _1315), (_1296 + _1316)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1304 + _1314), (_1305 + _1315), (_1306 + _1316)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _1243;
                      _1362 = _1348;
                      _1363 = _1349;
                      if (_1123) {
                        _1362 = 0.0f;
                        _1363 = 0.0f;
                        if ((!((((ReadonlyDepth.Sample(BilinearWrap, float2((_1348 + _1031), (_1349 + _1032)))).x) - _1218) >= (LDRPostProcessParam_002w)))) {
                          _1362 = _1348;
                          _1363 = _1349;
                        }
                      }
                    }
                    _1369 = ((LDRPostProcessParam_002x)*_1362);
                    _1370 = ((LDRPostProcessParam_002x)*_1363);
                  } while (false);
                } while (false);
              } while (false);
            }
            float _1371 = _1369 + _1031;
            float _1372 = _1370 + _1032;
            float4 _1375 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_1371, _1372));

            _1390 = 1.0f;  // Starting exposure, which is similar to shortFuse's Fixed option
            do {
              if (!((((uint)(Tonemap_001y)) == 0))) {
                // Get exposure from SRV
                _1390 = (asfloat((((int4)(asint(WhitePtSrv[0 / 4]))).x)));
              }
              // Multiple SRV exposure with cbuffer <-- This is shortfuse's Auto option
              float _1391 = _1390 * (Tonemap_000x);

              // All steps below to get Local exposure
              float _1402 = log2(((dot(float3(((_1391 * (_1375.x)) * (RangeCompressInfo_000y)), ((_1391 * (_1375.y)) * (RangeCompressInfo_000y)), ((_1391 * (_1375.z)) * (RangeCompressInfo_000y))), float3(0.25f, 0.5f, 0.25f))) + 9.999999747378752e-06f));
              float2 _1411 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_1371, _1372, (((((Tonemap_004z)*_1402) + (Tonemap_004w)) * 0.984375f) + 0.0078125f)), 0.0f);
              float _1419 = (((bool)(((_1411.y) < 0.0010000000474974513f))) ? ((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_1371, _1372), 0.0f)).x) : ((_1411.x) / (_1411.y)));
              float _1425 = ((Tonemap_005x) + _1419) + ((((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_1371, _1372), 0.0f)).x) - _1419) * 0.6000000238418579f);
              float _1426 = (Tonemap_005x) + _1402;
              float _1429 = _1425 - (Tonemap_004y);
              // This is shortfuse's Vanilla/Local exposure options, they're the same
              float _1441 = exp2(((((((((bool)((_1429 > 0.0f))) ? (Tonemap_003z) : (Tonemap_003w))) * _1429) - _1426) + (Tonemap_004y)) + ((Tonemap_004x) * (_1426 - _1425))));

              _1441 = PickExposure(_1441);
              _1446 = (_1441 * (_1375.x));
              _1447 = (_1441 * (_1375.y));
              _1448 = (_1441 * (_1375.z));
            } while (false);
          } while (false);
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
      } while (false);
    }
  }
  _2192 = _1453;
  _2193 = _1454;
  _2194 = _1455;

  // radial blur
  if (!(((((uint)(CBControl_000w)) & 32) == 0))) {
    float _1482 = _107 * (Exposure);
    float _1485 = float((bool)((bool)(((((uint)(LDRPostProcessParam_024x)) & 2) != 0))));
    float _1492 = ((1.0f - _1485) + ((((float4)(ComputeResultSRV[0].data[0 / 4])).x) * _1485)) * (LDRPostProcessParam_021w);
    _2192 = _1453;
    _2193 = _1454;
    _2194 = _1455;
    if (!((_1492 == 0.0f))) {
      float _1498 = (SceneInfo_023z) * (SV_Position.x);
      float _1499 = (SceneInfo_023w) * (SV_Position.y);
      float _1501 = (-0.5f - (LDRPostProcessParam_022x)) + _1498;
      float _1503 = (-0.5f - (LDRPostProcessParam_022y)) + _1499;
      float _1506 = (((bool)((_1501 < 0.0f))) ? (1.0f - _1498) : _1498);
      float _1509 = (((bool)((_1503 < 0.0f))) ? (1.0f - _1499) : _1499);
      _1536 = 1.0f;
      do {
        if (!(((((uint)(LDRPostProcessParam_024x)) & 1) == 0))) {
          float _1514 = rsqrt((dot(float2(_1501, _1503), float2(_1501, _1503))));
          uint _1523 = (uint((abs(((_1503 * (LDRPostProcessParam_023w)) * _1514))))) + (uint((abs(((_1501 * (LDRPostProcessParam_023w)) * _1514)))));
          uint _1527 = ((_1523 ^ 61) ^ ((uint)(_1523) >> 16)) * 9;
          uint _1530 = (((uint)(_1527) >> 4) ^ _1527) * 668265261;
          _1536 = ((float((uint)((int)(((uint)(_1530) >> 15) ^ _1530)))) * 2.3283064365386963e-10f);
        }
        float _1542 = 1.0f / (max(1.0f, (sqrt(((_1501 * _1501) + (_1503 * _1503))))));
        float _1543 = (LDRPostProcessParam_023z) * -0.0011111111380159855f;
        float _1552 = ((((_1543 * _1506) * _1536) * _1542) + 1.0f) * _1501;
        float _1553 = ((((_1543 * _1509) * _1536) * _1542) + 1.0f) * _1503;
        float _1555 = (LDRPostProcessParam_023z) * -0.002222222276031971f;
        float _1564 = ((((_1555 * _1506) * _1536) * _1542) + 1.0f) * _1501;
        float _1565 = ((((_1555 * _1509) * _1536) * _1542) + 1.0f) * _1503;
        float _1566 = (LDRPostProcessParam_023z) * -0.0033333334140479565f;
        float _1575 = ((((_1566 * _1506) * _1536) * _1542) + 1.0f) * _1501;
        float _1576 = ((((_1566 * _1509) * _1536) * _1542) + 1.0f) * _1503;
        float _1577 = (LDRPostProcessParam_023z) * -0.004444444552063942f;
        float _1586 = ((((_1577 * _1506) * _1536) * _1542) + 1.0f) * _1501;
        float _1587 = ((((_1577 * _1509) * _1536) * _1542) + 1.0f) * _1503;
        float _1588 = (LDRPostProcessParam_023z) * -0.0055555556900799274f;
        float _1597 = ((((_1588 * _1506) * _1536) * _1542) + 1.0f) * _1501;
        float _1598 = ((((_1588 * _1509) * _1536) * _1542) + 1.0f) * _1503;
        float _1599 = (LDRPostProcessParam_023z) * -0.006666666828095913f;
        float _1608 = ((((_1599 * _1506) * _1536) * _1542) + 1.0f) * _1501;
        float _1609 = ((((_1599 * _1509) * _1536) * _1542) + 1.0f) * _1503;
        float _1610 = (LDRPostProcessParam_023z) * -0.007777777966111898f;
        float _1619 = ((((_1610 * _1506) * _1536) * _1542) + 1.0f) * _1501;
        float _1620 = ((((_1610 * _1509) * _1536) * _1542) + 1.0f) * _1503;
        float _1621 = (LDRPostProcessParam_023z) * -0.008888889104127884f;
        float _1630 = ((((_1621 * _1506) * _1536) * _1542) + 1.0f) * _1501;
        float _1631 = ((((_1621 * _1509) * _1536) * _1542) + 1.0f) * _1503;
        float _1632 = (LDRPostProcessParam_023z) * -0.009999999776482582f;
        float _1641 = ((((_1632 * _1506) * _1536) * _1542) + 1.0f) * _1501;
        float _1642 = ((((_1632 * _1509) * _1536) * _1542) + 1.0f) * _1503;
        do {
          if (_50) {
            float _1644 = _1552 + (LDRPostProcessParam_022x);
            float _1645 = _1553 + (LDRPostProcessParam_022y);
            float _1649 = (((dot(float2(_1644, _1645), float2(_1644, _1645))) * _1456) + 1.0f) * _1461;
            float4 _1655 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1649 * _1644) + 0.5f), ((_1649 * _1645) + 0.5f)), 0.0f);
            float _1659 = _1564 + (LDRPostProcessParam_022x);
            float _1660 = _1565 + (LDRPostProcessParam_022y);
            float _1663 = ((dot(float2(_1659, _1660), float2(_1659, _1660))) * _1456) + 1.0f;
            float4 _1670 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1659 * _1461) * _1663) + 0.5f), (((_1660 * _1461) * _1663) + 0.5f)), 0.0f);
            float _1677 = _1575 + (LDRPostProcessParam_022x);
            float _1678 = _1576 + (LDRPostProcessParam_022y);
            float _1681 = ((dot(float2(_1677, _1678), float2(_1677, _1678))) * _1456) + 1.0f;
            float4 _1688 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1677 * _1461) * _1681) + 0.5f), (((_1678 * _1461) * _1681) + 0.5f)), 0.0f);
            float _1695 = _1586 + (LDRPostProcessParam_022x);
            float _1696 = _1587 + (LDRPostProcessParam_022y);
            float _1699 = ((dot(float2(_1695, _1696), float2(_1695, _1696))) * _1456) + 1.0f;
            float4 _1706 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1695 * _1461) * _1699) + 0.5f), (((_1696 * _1461) * _1699) + 0.5f)), 0.0f);
            float _1713 = _1597 + (LDRPostProcessParam_022x);
            float _1714 = _1598 + (LDRPostProcessParam_022y);
            float _1717 = ((dot(float2(_1713, _1714), float2(_1713, _1714))) * _1456) + 1.0f;
            float4 _1724 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1713 * _1461) * _1717) + 0.5f), (((_1714 * _1461) * _1717) + 0.5f)), 0.0f);
            float _1731 = _1608 + (LDRPostProcessParam_022x);
            float _1732 = _1609 + (LDRPostProcessParam_022y);
            float _1735 = ((dot(float2(_1731, _1732), float2(_1731, _1732))) * _1456) + 1.0f;
            float4 _1742 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1731 * _1461) * _1735) + 0.5f), (((_1732 * _1461) * _1735) + 0.5f)), 0.0f);
            float _1749 = _1619 + (LDRPostProcessParam_022x);
            float _1750 = _1620 + (LDRPostProcessParam_022y);
            float _1753 = ((dot(float2(_1749, _1750), float2(_1749, _1750))) * _1456) + 1.0f;
            float4 _1760 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1749 * _1461) * _1753) + 0.5f), (((_1750 * _1461) * _1753) + 0.5f)), 0.0f);
            float _1767 = _1630 + (LDRPostProcessParam_022x);
            float _1768 = _1631 + (LDRPostProcessParam_022y);
            float _1771 = ((dot(float2(_1767, _1768), float2(_1767, _1768))) * _1456) + 1.0f;
            float4 _1778 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1767 * _1461) * _1771) + 0.5f), (((_1768 * _1461) * _1771) + 0.5f)), 0.0f);
            float _1785 = _1641 + (LDRPostProcessParam_022x);
            float _1786 = _1642 + (LDRPostProcessParam_022y);
            float _1789 = ((dot(float2(_1785, _1786), float2(_1785, _1786))) * _1456) + 1.0f;
            float4 _1796 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1785 * _1461) * _1789) + 0.5f), (((_1786 * _1461) * _1789) + 0.5f)), 0.0f);
            _2139 = (((((((((_1670.x) + (_1655.x)) + (_1688.x)) + (_1706.x)) + (_1724.x)) + (_1742.x)) + (_1760.x)) + (_1778.x)) + (_1796.x));
            _2140 = (((((((((_1670.y) + (_1655.y)) + (_1688.y)) + (_1706.y)) + (_1724.y)) + (_1742.y)) + (_1760.y)) + (_1778.y)) + (_1796.y));
            _2141 = (((((((((_1670.z) + (_1655.z)) + (_1688.z)) + (_1706.z)) + (_1724.z)) + (_1742.z)) + (_1760.z)) + (_1778.z)) + (_1796.z));
          } else {
            float _1804 = (LDRPostProcessParam_022x) + 0.5f;
            float _1805 = _1804 + _1552;
            float _1806 = (LDRPostProcessParam_022y) + 0.5f;
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
              float _1831 = sqrt(((_1827 * _1827) + 1.0f));
              float _1832 = 1.0f / _1831;
              float _1835 = (_1831 * _1459) * (_1832 + _1457);
              float _1839 = _1460 * 0.5f;
              float4 _1848 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1835) * _1827) + 0.5f), ((((_1839 * (((_1832 + -1.0f) * _1458) + 1.0f)) * _1835) * ((_1807 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
              float _1854 = (_1808 * 2.0f) + -1.0f;
              float _1858 = sqrt(((_1854 * _1854) + 1.0f));
              float _1859 = 1.0f / _1858;
              float _1862 = (_1858 * _1459) * (_1859 + _1457);
              float4 _1873 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1854) * _1862) + 0.5f), ((((_1839 * ((_1809 * 2.0f) + -1.0f)) * (((_1859 + -1.0f) * _1458) + 1.0f)) * _1862) + 0.5f)), 0.0f);
              float _1882 = (_1810 * 2.0f) + -1.0f;
              float _1886 = sqrt(((_1882 * _1882) + 1.0f));
              float _1887 = 1.0f / _1886;
              float _1890 = (_1886 * _1459) * (_1887 + _1457);
              float4 _1901 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1882) * _1890) + 0.5f), ((((_1839 * ((_1811 * 2.0f) + -1.0f)) * (((_1887 + -1.0f) * _1458) + 1.0f)) * _1890) + 0.5f)), 0.0f);
              float _1910 = (_1812 * 2.0f) + -1.0f;
              float _1914 = sqrt(((_1910 * _1910) + 1.0f));
              float _1915 = 1.0f / _1914;
              float _1918 = (_1914 * _1459) * (_1915 + _1457);
              float4 _1929 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1910) * _1918) + 0.5f), ((((_1839 * ((_1813 * 2.0f) + -1.0f)) * (((_1915 + -1.0f) * _1458) + 1.0f)) * _1918) + 0.5f)), 0.0f);
              float _1938 = (_1814 * 2.0f) + -1.0f;
              float _1942 = sqrt(((_1938 * _1938) + 1.0f));
              float _1943 = 1.0f / _1942;
              float _1946 = (_1942 * _1459) * (_1943 + _1457);
              float4 _1957 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1938) * _1946) + 0.5f), ((((_1839 * ((_1815 * 2.0f) + -1.0f)) * (((_1943 + -1.0f) * _1458) + 1.0f)) * _1946) + 0.5f)), 0.0f);
              float _1966 = (_1816 * 2.0f) + -1.0f;
              float _1970 = sqrt(((_1966 * _1966) + 1.0f));
              float _1971 = 1.0f / _1970;
              float _1974 = (_1970 * _1459) * (_1971 + _1457);
              float4 _1985 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1966) * _1974) + 0.5f), ((((_1839 * ((_1817 * 2.0f) + -1.0f)) * (((_1971 + -1.0f) * _1458) + 1.0f)) * _1974) + 0.5f)), 0.0f);
              float _1994 = (_1818 * 2.0f) + -1.0f;
              float _1998 = sqrt(((_1994 * _1994) + 1.0f));
              float _1999 = 1.0f / _1998;
              float _2002 = (_1998 * _1459) * (_1999 + _1457);
              float4 _2013 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _1994) * _2002) + 0.5f), ((((_1839 * ((_1819 * 2.0f) + -1.0f)) * (((_1999 + -1.0f) * _1458) + 1.0f)) * _2002) + 0.5f)), 0.0f);
              float _2022 = (_1820 * 2.0f) + -1.0f;
              float _2026 = sqrt(((_2022 * _2022) + 1.0f));
              float _2027 = 1.0f / _2026;
              float _2030 = (_2026 * _1459) * (_2027 + _1457);
              float4 _2041 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _2022) * _2030) + 0.5f), ((((_1839 * ((_1821 * 2.0f) + -1.0f)) * (((_2027 + -1.0f) * _1458) + 1.0f)) * _2030) + 0.5f)), 0.0f);
              float _2050 = (_1822 * 2.0f) + -1.0f;
              float _2054 = sqrt(((_2050 * _2050) + 1.0f));
              float _2055 = 1.0f / _2054;
              float _2058 = (_2054 * _1459) * (_2055 + _1457);
              float4 _2069 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1839 * _2050) * _2058) + 0.5f), ((((_1839 * ((_1823 * 2.0f) + -1.0f)) * (((_2055 + -1.0f) * _1458) + 1.0f)) * _2058) + 0.5f)), 0.0f);
              _2139 = (((((((((_1873.x) + (_1848.x)) + (_1901.x)) + (_1929.x)) + (_1957.x)) + (_1985.x)) + (_2013.x)) + (_2041.x)) + (_2069.x));
              _2140 = (((((((((_1873.y) + (_1848.y)) + (_1901.y)) + (_1929.y)) + (_1957.y)) + (_1985.y)) + (_2013.y)) + (_2041.y)) + (_2069.y));
              _2141 = (((((((((_1873.z) + (_1848.z)) + (_1901.z)) + (_1929.z)) + (_1957.z)) + (_1985.z)) + (_2013.z)) + (_2041.z)) + (_2069.z));
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
              _2139 = (((((((((_2082.x) + (_2078.x)) + (_2089.x)) + (_2096.x)) + (_2103.x)) + (_2110.x)) + (_2117.x)) + (_2124.x)) + (_2131.x));
              _2140 = (((((((((_2082.y) + (_2078.y)) + (_2089.y)) + (_2096.y)) + (_2103.y)) + (_2110.y)) + (_2117.y)) + (_2124.y)) + (_2131.y));
              _2141 = (((((((((_2082.z) + (_2078.z)) + (_2089.z)) + (_2096.z)) + (_2103.z)) + (_2110.z)) + (_2117.z)) + (_2124.z)) + (_2131.z));
            }
          }
          float _2151 = (((_2141 * _1482) + _1455) * 0.10000000149011612f) * (LDRPostProcessParam_021z);
          float _2152 = (((_2140 * _1482) + _1454) * 0.10000000149011612f) * (LDRPostProcessParam_021y);
          float _2153 = (((_2139 * _1482) + _1453) * 0.10000000149011612f) * (LDRPostProcessParam_021x);
          _2179 = _2153;
          _2180 = _2152;
          _2181 = _2151;
          do {
            if ((((LDRPostProcessParam_023x) > 0.0f))) {
              float _2162 = saturate((((sqrt(((_1501 * _1501) + (_1503 * _1503)))) * (LDRPostProcessParam_022z)) + (LDRPostProcessParam_022w)));
              float _2168 = (((_2162 * _2162) * (LDRPostProcessParam_023x)) * (3.0f - (_2162 * 2.0f))) + (LDRPostProcessParam_023y);
              _2179 = ((_2168 * (_2153 - _1453)) + _1453);
              _2180 = ((_2168 * (_2152 - _1454)) + _1454);
              _2181 = ((_2168 * (_2151 - _1455)) + _1455);
            }
            _2192 = (((_2179 - _1453) * _1492) + _1453);
            _2193 = (((_2180 - _1454) * _1492) + _1454);
            _2194 = (((_2181 - _1455) * _1492) + _1455);
          } while (false);
        } while (false);
      } while (false);
    }
  }

  // Disabling all color grading skips to this stage
  float _2209 = mad(_2194, (CBControl_003x), (mad(_2193, (CBControl_002x), ((CBControl_001x)*_2192))));
  float _2212 = mad(_2194, (CBControl_003y), (mad(_2193, (CBControl_002y), ((CBControl_001y)*_2192))));
  float _2215 = mad(_2194, (CBControl_003z), (mad(_2193, (CBControl_002z), ((CBControl_001z)*_2192))));
  _2301 = _2209;
  _2302 = _2212;
  _2303 = _2215;
  // Color correction
  if (!((((uint)(CBControl_006w)) == 0))) {
    float _2221 = max((max(_2209, _2212)), _2215);
    _2301 = _2209;
    _2302 = _2212;
    _2303 = _2215;
    if ((!(_2221 == 0.0f))) {
      float _2227 = abs(_2221);
      float _2228 = (_2221 - _2209) / _2227;
      float _2229 = (_2221 - _2212) / _2227;
      float _2230 = (_2221 - _2215) / _2227;
      _2252 = _2228;
      do {
        if (!(!(_2228 >= (CBControl_005w)))) {
          float _2240 = _2228 - (CBControl_005w);
          _2252 = ((_2240 / (exp2(((log2(((exp2(((log2((_2240 * (CBControl_007x)))) * (CBControl_006z)))) + 1.0f))) * (CBControl_007w))))) + (CBControl_005w));
        }
        _2273 = _2229;
        do {
          if (!(!(_2229 >= (CBControl_006x)))) {
            float _2261 = _2229 - (CBControl_006x);
            _2273 = ((_2261 / (exp2(((log2(((exp2(((log2((_2261 * (CBControl_007y)))) * (CBControl_006z)))) + 1.0f))) * (CBControl_007w))))) + (CBControl_006x));
          }
          _2293 = _2230;
          do {
            if (!(!(_2230 >= (CBControl_006y)))) {
              float _2281 = _2230 - (CBControl_006y);
              _2293 = ((_2281 / (exp2(((log2(((exp2(((log2((_2281 * (CBControl_007z)))) * (CBControl_006z)))) + 1.0f))) * (CBControl_007w))))) + (CBControl_006y));
            }
            _2301 = (_2221 - (_2227 * _2252));
            _2302 = (_2221 - (_2227 * _2273));
            _2303 = (_2221 - (_2227 * _2293));
          } while (false);
        } while (false);
      } while (false);
    }
  }

  _2400 = _2301;
  _2401 = _2302;
  _2402 = _2303;

  if (!(((((uint)(CBControl_000w)) & 2) == 0))) {  // NOISE
    float _2320 = floor(((LDRPostProcessParam_009w) * ((LDRPostProcessParam_008z) + (SV_Position.x))));
    float _2322 = floor(((LDRPostProcessParam_009w) * ((LDRPostProcessParam_008w) + (SV_Position.y))));
    float _2326 = frac(((frac((dot(float2(_2320, _2322), float2(0.0671105608344078f, 0.005837149918079376f))))) * 52.98291778564453f));
    _2340 = 0.0f;
    do {
      if (((_2326 < (LDRPostProcessParam_009x)))) {
        int _2331 = ((uint)(uint((_2322 * _2320)))) ^ 12345391;
        uint _2332 = _2331 * 3635641;
        _2340 = ((float((uint)((int)((((uint)(_2332) >> 26) | ((uint)(_2331 * 232681024))) ^ _2332)))) * 2.3283064365386963e-10f);
      }
      float _2342 = frac((_2326 * 757.4846801757812f));
      _2356 = 0.0f;
      do {
        if (((_2342 < (LDRPostProcessParam_009x)))) {
          int _2346 = (asint(_2342)) ^ 12345391;
          uint _2347 = _2346 * 3635641;
          _2356 = (((float((uint)((int)((((uint)(_2347) >> 26) | ((uint)(_2346 * 232681024))) ^ _2347)))) * 2.3283064365386963e-10f) + -0.5f);
        }
        float _2358 = frac((_2342 * 757.4846801757812f));
        _2372 = 0.0f;
        do {
          if (((_2358 < (LDRPostProcessParam_009x)))) {
            int _2362 = (asint(_2358)) ^ 12345391;
            uint _2363 = _2362 * 3635641;
            _2372 = (((float((uint)((int)((((uint)(_2363) >> 26) | ((uint)(_2362 * 232681024))) ^ _2363)))) * 2.3283064365386963e-10f) + -0.5f);
          }
          float _2373 = _2340 * (LDRPostProcessParam_008x);
          float _2374 = _2372 * (LDRPostProcessParam_008y);
          float _2375 = _2356 * (LDRPostProcessParam_008y);
          float _2389 = (exp2(((log2((1.0f - (saturate((dot(float3((saturate(_2301)), (saturate(_2302)), (saturate(_2303))), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))))))) * (LDRPostProcessParam_009y)))) * (LDRPostProcessParam_009z);
          _2400 = ((_2389 * ((mad(_2375, 1.4019999504089355f, _2373)) - _2301)) + _2301);
          _2401 = ((_2389 * ((mad(_2375, -0.7139999866485596f, (mad(_2374, -0.3440000116825104f, _2373)))) - _2302)) + _2302);
          _2402 = ((_2389 * ((mad(_2374, 1.7719999551773071f, _2373)) - _2303)) + _2303);
        } while (false);
      } while (false);
    } while (false);
  }

  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    _2400 = _2301;
    _2401 = _2302;
    _2402 = _2303;
  }

  _2809 = _2400;
  _2810 = _2401;
  _2811 = _2402;

  if (!(((((uint)(CBControl_000w)) & 4) == 0))) {  // LUT SAMPLE (ACESCCt)
    bool _2428 = !(_2400 <= 0.0078125f);
    do {
      if (!_2428) {
        _2437 = ((_2400 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _2437 = (((log2(_2400)) + 9.720000267028809f) * 0.05707762390375137f);
      }
      bool _2438 = !(_2401 <= 0.0078125f);
      do {
        if (!_2438) {
          _2447 = ((_2401 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2447 = (((log2(_2401)) + 9.720000267028809f) * 0.05707762390375137f);
        }
        bool _2448 = !(_2402 <= 0.0078125f);
        do {
          if (!_2448) {
            _2457 = ((_2402 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _2457 = (((log2(_2402)) + 9.720000267028809f) * 0.05707762390375137f);
          }

          // Sample LUT in ACEScc Trilinear
          float4 _2466 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_2437 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2447 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2457 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x))), 0.0f);

          do {
            if ((((_2466.x) < 0.155251145362854f))) {
              _2483 = (((_2466.x) + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              _2483 = 65504.0f;
              if ((((bool)(((_2466.x) >= 0.155251145362854f))) && ((bool)(((_2466.x) < 1.4679962396621704f))))) {
                _2483 = (exp2((((_2466.x) * 17.520000457763672f) + -9.720000267028809f)));
              }
            }
            do {
              if ((((_2466.y) < 0.155251145362854f))) {
                _2497 = (((_2466.y) + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                _2497 = 65504.0f;
                if ((((bool)(((_2466.y) >= 0.155251145362854f))) && ((bool)(((_2466.y) < 1.4679962396621704f))))) {
                  _2497 = (exp2((((_2466.y) * 17.520000457763672f) + -9.720000267028809f)));
                }
              }
              do {
                if ((((_2466.z) < 0.155251145362854f))) {
                  _2511 = (((_2466.z) + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  _2511 = 65504.0f;
                  if ((((bool)(((_2466.z) >= 0.155251145362854f))) && ((bool)(((_2466.z) < 1.4679962396621704f))))) {
                    _2511 = (exp2((((_2466.z) * 17.520000457763672f) + -9.720000267028809f)));
                  }
                }

                do {
                  [branch]
                  if ((((LDRPostProcessParam_010y) > 0.0f))) {
                    do {
                      if (!_2428) {
                        _2522 = ((_2400 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _2522 = (((log2(_2400)) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!_2438) {
                          _2531 = ((_2401 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2531 = (((log2(_2401)) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!_2448) {
                            _2540 = ((_2402 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2540 = (((log2(_2402)) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          float4 _2548 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_2522 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2531 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2540 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x))), 0.0f);
                          do {
                            if ((((_2548.x) < 0.155251145362854f))) {
                              _2565 = (((_2548.x) + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              _2565 = 65504.0f;
                              if ((((bool)(((_2548.x) >= 0.155251145362854f))) && ((bool)(((_2548.x) < 1.4679962396621704f))))) {
                                _2565 = (exp2((((_2548.x) * 17.520000457763672f) + -9.720000267028809f)));
                              }
                            }
                            do {
                              if ((((_2548.y) < 0.155251145362854f))) {
                                _2579 = (((_2548.y) + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                _2579 = 65504.0f;
                                if ((((bool)(((_2548.y) >= 0.155251145362854f))) && ((bool)(((_2548.y) < 1.4679962396621704f))))) {
                                  _2579 = (exp2((((_2548.y) * 17.520000457763672f) + -9.720000267028809f)));
                                }
                              }
                              do {
                                if ((((_2548.z) < 0.155251145362854f))) {
                                  _2593 = (((_2548.z) + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  _2593 = 65504.0f;
                                  if ((((bool)(((_2548.z) >= 0.155251145362854f))) && ((bool)(((_2548.z) < 1.4679962396621704f))))) {
                                    _2593 = (exp2((((_2548.z) * 17.520000457763672f) + -9.720000267028809f)));
                                  }
                                }

                                // Lerp LUTs

                                float _2600 = ((_2565 - _2483) * (LDRPostProcessParam_010y)) + _2483;
                                float _2601 = ((_2579 - _2497) * (LDRPostProcessParam_010y)) + _2497;
                                float _2602 = ((_2593 - _2511) * (LDRPostProcessParam_010y)) + _2511;
                                _2793 = _2600;
                                _2794 = _2601;
                                _2795 = _2602;
                                if ((((LDRPostProcessParam_010z) > 0.0f))) {
                                  do {
                                    if (!(!(_2600 <= 0.0078125f))) {
                                      _2614 = ((_2600 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _2614 = (((log2(_2600)) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_2601 <= 0.0078125f))) {
                                        _2624 = ((_2601 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _2624 = (((log2(_2601)) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_2602 <= 0.0078125f))) {
                                          _2634 = ((_2602 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _2634 = (((log2(_2602)) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        float4 _2642 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2614 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2624 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2634 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x))), 0.0f);
                                        do {
                                          if ((((_2642.x) < 0.155251145362854f))) {
                                            _2659 = (((_2642.x) + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            _2659 = 65504.0f;
                                            if ((((bool)(((_2642.x) >= 0.155251145362854f))) && ((bool)(((_2642.x) < 1.4679962396621704f))))) {
                                              _2659 = (exp2((((_2642.x) * 17.520000457763672f) + -9.720000267028809f)));
                                            }
                                          }
                                          do {
                                            if ((((_2642.y) < 0.155251145362854f))) {
                                              _2673 = (((_2642.y) + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              _2673 = 65504.0f;
                                              if ((((bool)(((_2642.y) >= 0.155251145362854f))) && ((bool)(((_2642.y) < 1.4679962396621704f))))) {
                                                _2673 = (exp2((((_2642.y) * 17.520000457763672f) + -9.720000267028809f)));
                                              }
                                            }
                                            do {
                                              if ((((_2642.z) < 0.155251145362854f))) {
                                                _2687 = (((_2642.z) + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                _2687 = 65504.0f;
                                                if ((((bool)(((_2642.z) >= 0.155251145362854f))) && ((bool)(((_2642.z) < 1.4679962396621704f))))) {
                                                  _2687 = (exp2((((_2642.z) * 17.520000457763672f) + -9.720000267028809f)));
                                                }
                                              }
                                              _2793 = (((_2659 - _2600) * (LDRPostProcessParam_010z)) + _2600);
                                              _2794 = (((_2673 - _2601) * (LDRPostProcessParam_010z)) + _2601);
                                              _2795 = (((_2687 - _2602) * (LDRPostProcessParam_010z)) + _2602);
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                }
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } else {
                    _2793 = _2483;
                    _2794 = _2497;
                    _2795 = _2511;
                    if ((((LDRPostProcessParam_010z) > 0.0f))) {
                      do {
                        if (!(!(_2483 <= 0.0078125f))) {
                          _2709 = ((_2483 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2709 = (((log2(_2483)) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_2497 <= 0.0078125f))) {
                            _2719 = ((_2497 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2719 = (((log2(_2497)) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_2511 <= 0.0078125f))) {
                              _2729 = ((_2511 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _2729 = (((log2(_2511)) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            float4 _2737 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2709 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2719 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2729 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x))), 0.0f);
                            do {
                              if ((((_2737.x) < 0.155251145362854f))) {
                                _2754 = (((_2737.x) + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                _2754 = 65504.0f;
                                if ((((bool)(((_2737.x) >= 0.155251145362854f))) && ((bool)(((_2737.x) < 1.4679962396621704f))))) {
                                  _2754 = (exp2((((_2737.x) * 17.520000457763672f) + -9.720000267028809f)));
                                }
                              }
                              do {
                                if ((((_2737.y) < 0.155251145362854f))) {
                                  _2768 = (((_2737.y) + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  _2768 = 65504.0f;
                                  if ((((bool)(((_2737.y) >= 0.155251145362854f))) && ((bool)(((_2737.y) < 1.4679962396621704f))))) {
                                    _2768 = (exp2((((_2737.y) * 17.520000457763672f) + -9.720000267028809f)));
                                  }
                                }
                                do {
                                  if ((((_2737.z) < 0.155251145362854f))) {
                                    _2782 = (((_2737.z) + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    _2782 = 65504.0f;
                                    if ((((bool)(((_2737.z) >= 0.155251145362854f))) && ((bool)(((_2737.z) < 1.4679962396621704f))))) {
                                      _2782 = (exp2((((_2737.z) * 17.520000457763672f) + -9.720000267028809f)));
                                    }
                                  }
                                  _2793 = (((_2754 - _2483) * (LDRPostProcessParam_010z)) + _2483);
                                  _2794 = (((_2768 - _2497) * (LDRPostProcessParam_010z)) + _2497);
                                  _2795 = (((_2782 - _2511) * (LDRPostProcessParam_010z)) + _2511);
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    }
                  }

                  // Apply custom
                  _2809 = ((mad(_2795, (LDRPostProcessParam_014x), (mad(_2794, (LDRPostProcessParam_013x), (_2793 * (LDRPostProcessParam_012x)))))) + (LDRPostProcessParam_015x));
                  _2810 = ((mad(_2795, (LDRPostProcessParam_014y), (mad(_2794, (LDRPostProcessParam_013y), (_2793 * (LDRPostProcessParam_012y)))))) + (LDRPostProcessParam_015y));
                  _2811 = ((mad(_2795, (LDRPostProcessParam_014z), (mad(_2794, (LDRPostProcessParam_013z), (_2793 * (LDRPostProcessParam_012z)))))) + (LDRPostProcessParam_015z));

                  float3 new_color = CustomLUTColor(float3(_2400, _2401, _2402), float3(_2809, _2810, _2811));
                  _2809 = new_color.r;
                  _2810 = new_color.g;
                  _2811 = new_color.b;

                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  }

  // with_noise *= 10.f;  // LUT_MID_GRAY_SCALING
  // _2809 = lerp(_2400 * 10.f, _2809, CUSTOM_LUT_COLOR_STRENGTH);
  // _2810 = lerp(_2401 * 10.f, _2810, CUSTOM_LUT_COLOR_STRENGTH);
  // _2811 = lerp(_2402 * 10.f, _2811, CUSTOM_LUT_COLOR_STRENGTH);

  bool _2814 = isfinite((max((max(_2809, _2810)), _2811)));

  float _2815 = (_2814 ? _2809 : 1.0f);
  float _2816 = (_2814 ? _2810 : 1.0f);
  float _2817 = (_2814 ? _2811 : 1.0f);
  _2852 = _2815;
  _2853 = _2816;
  _2854 = _2817;

  if (!(((((uint)(CBControl_000w)) & 8) == 0))) {  // Custom Matrix
    _2852 = (saturate(((((LDRPostProcessParam_016x)*_2815) + ((LDRPostProcessParam_016y)*_2816)) + ((LDRPostProcessParam_016z)*_2817))));
    _2853 = (saturate(((((LDRPostProcessParam_017x)*_2815) + ((LDRPostProcessParam_017y)*_2816)) + ((LDRPostProcessParam_017z)*_2817))));
    _2854 = (saturate(((((LDRPostProcessParam_018x)*_2815) + ((LDRPostProcessParam_018y)*_2816)) + ((LDRPostProcessParam_018z)*_2817))));
  }
  _2935 = _2852;
  _2936 = _2853;
  _2937 = _2854;
  if (!(((((uint)(CBControl_000w)) & 16) == 0))) {
    // Color correction?
    float _2869 = (SceneInfo_023z) * (SV_Position.x);
    float _2870 = (SceneInfo_023w) * (SV_Position.y);
    float4 _2873 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2869, _2870), 0.0f);
    float _2878 = (_2873.x) * (LDRPostProcessParam_019x);
    float _2879 = (_2873.y) * (LDRPostProcessParam_019y);
    float _2880 = (_2873.z) * (LDRPostProcessParam_019z);
    float _2888 = ((_2873.w) * (LDRPostProcessParam_019w)) * (saturate(((((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2869, _2870), 0.0f)).x) * (LDRPostProcessParam_020x)) + (LDRPostProcessParam_020y))));
    do {
      if (((_2878 < 0.5f))) {
        _2900 = ((_2852 * 2.0f) * _2878);
      } else {
        _2900 = (1.0f - (((1.0f - _2852) * 2.0f) * (1.0f - _2878)));
      }
      do {
        if (((_2879 < 0.5f))) {
          _2912 = ((_2853 * 2.0f) * _2879);
        } else {
          _2912 = (1.0f - (((1.0f - _2853) * 2.0f) * (1.0f - _2879)));
        }
        do {
          if (((_2880 < 0.5f))) {
            _2924 = ((_2854 * 2.0f) * _2880);
          } else {
            _2924 = (1.0f - (((1.0f - _2854) * 2.0f) * (1.0f - _2880)));
          }
          _2935 = (((_2900 - _2852) * _2888) + _2852);
          _2936 = (((_2912 - _2853) * _2888) + _2853);
          _2937 = (((_2924 - _2854) * _2888) + _2854);
        } while (false);
      } while (false);
    } while (false);
  }
  _3042 = _2935;
  _3043 = _2936;
  _3044 = _2937;

  // Don't enter in SDR
  if (!(TonemapParam_002w == 0.0f) && ProcessVanilla()) {
    float3 untonemapped = renodx::color::bt709::from::AP1(float3(_2935, _2936, _2937));
    float3 midgray = VanillaSDRTonemapper(float3(0.18, 0.18, 0.18));
    float3 sdrTonemapped = VanillaSDRTonemapper(untonemapped);

    float3 tonemapped = UpgradeWithSDR(untonemapped * (midgray / 0.18), sdrTonemapped);

    _3042 = tonemapped.r;
    _3043 = tonemapped.g;
    _3044 = tonemapped.b;
  }

  if ((((TonemapParam_002w) == 0.0f))) {  // SDR Tonemap

    float _2945 = (TonemapParam_002y)*_2935;
    _2953 = 1.0f;
    do {
      if ((!(_2935 >= (TonemapParam_000y)))) {
        _2953 = ((_2945 * _2945) * (3.0f - (_2945 * 2.0f)));
      }
      float _2954 = (TonemapParam_002y)*_2936;
      _2962 = 1.0f;
      do {
        if ((!(_2936 >= (TonemapParam_000y)))) {
          _2962 = ((_2954 * _2954) * (3.0f - (_2954 * 2.0f)));
        }
        float _2963 = (TonemapParam_002y)*_2937;
        _2971 = 1.0f;
        do {
          if ((!(_2937 >= (TonemapParam_000y)))) {
            _2971 = ((_2963 * _2963) * (3.0f - (_2963 * 2.0f)));
          }

          float _2980 = (((bool)((_2935 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          float _2981 = (((bool)((_2936 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          float _2982 = (((bool)((_2937 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          _3042 = ((((((TonemapParam_000x)*_2935) + (TonemapParam_002z)) * (_2953 - _2980)) + (((exp2(((log2(_2945)) * (TonemapParam_000w)))) * (1.0f - _2953)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*_2935) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _2980));
          _3043 = ((((((TonemapParam_000x)*_2936) + (TonemapParam_002z)) * (_2962 - _2981)) + (((exp2(((log2(_2954)) * (TonemapParam_000w)))) * (1.0f - _2962)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*_2936) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _2981));
          _3044 = ((((((TonemapParam_000x)*_2937) + (TonemapParam_002z)) * (_2971 - _2982)) + (((exp2(((log2(_2963)) * (TonemapParam_000w)))) * (1.0f - _2971)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*_2937) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _2982));
        } while (false);
      } while (false);
    } while (false);
  }

  SV_Target.x = _3042;
  SV_Target.y = _3043;
  SV_Target.z = _3044;

  SV_Target.w = 0.0f;

  return SV_Target;
}
