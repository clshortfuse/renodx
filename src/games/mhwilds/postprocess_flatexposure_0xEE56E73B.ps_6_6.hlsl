#include "./postprocess.hlsl"
#include "./shared.h"

Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> RE_POSTPROCESS_Color : register(t1);

Texture2D<float> tFilterTempMap1 : register(t2);

Texture3D<float> tVolumeMap : register(t3);

Texture2D<float2> HazeNoiseResult : register(t4);

struct _ComputeResultSRV {
  float data[1];
};
StructuredBuffer<_ComputeResultSRV> ComputeResultSRV : register(t5);

Texture3D<float4> tTextureMap0 : register(t6);

Texture3D<float4> tTextureMap1 : register(t7);

Texture3D<float4> tTextureMap2 : register(t8);

Texture2D<float4> ImagePlameBase : register(t9);

Texture2D<float> ImagePlameAlpha : register(t10);

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
cbuffer CameraKerare : register(b1) {
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
cbuffer TonemapParam : register(b2) {
  float TonemapParam_000x : packoffset(c000.x);
  float TonemapParam_000y : packoffset(c000.y);
  float TonemapParam_000w : packoffset(c000.w);
  float TonemapParam_001x : packoffset(c001.x);
  float TonemapParam_001y : packoffset(c001.y);
  float TonemapParam_001z : packoffset(c001.z);
  float TonemapParam_001w : packoffset(c001.w);
  float TonemapParam_002x : packoffset(c002.x);
  float TonemapParam_002y : packoffset(c002.y);
  float TonemapParam_002z : packoffset(c002.z);
  float TonemapParam_002w : packoffset(c002.w);
};

/*
;   struct LDRPostProcessParam
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
 // 5
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

// 11

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
cbuffer LDRPostProcessParam : register(b3) {
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
  uint LDRPostProcessParam_005y : packoffset(c005.y);
  uint LDRPostProcessParam_005z : packoffset(c005.z);
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
  float LDRPostProcessParam_009x : packoffset(c009.x);
  float LDRPostProcessParam_009y : packoffset(c009.y);
  float LDRPostProcessParam_009z : packoffset(c009.z);
  float LDRPostProcessParam_009w : packoffset(c009.w);
  float LDRPostProcessParam_010y : packoffset(c010.y);
  float LDRPostProcessParam_010z : packoffset(c010.z);
  float LDRPostProcessParam_011x : packoffset(c011.x);
  float LDRPostProcessParam_011y : packoffset(c011.y);
  float LDRPostProcessParam_012x : packoffset(c012.x);
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
  float LDRPostProcessParam_016x : packoffset(c016.x);
  float LDRPostProcessParam_016y : packoffset(c016.y);
  float LDRPostProcessParam_016z : packoffset(c016.z);
  float LDRPostProcessParam_017x : packoffset(c017.x);
  float LDRPostProcessParam_017y : packoffset(c017.y);
  float LDRPostProcessParam_017z : packoffset(c017.z);
  float LDRPostProcessParam_018x : packoffset(c018.x);
  float LDRPostProcessParam_018y : packoffset(c018.y);
  float LDRPostProcessParam_018z : packoffset(c018.z);
  float LDRPostProcessParam_019x : packoffset(c019.x);
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
;   struct CBControl
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
cbuffer CBControl : register(b4) {
  uint CBControl_000w : packoffset(c000.w);
  float CBControl_001x : packoffset(c001.x);
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
  uint CBControl_006w : packoffset(c006.w);
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
This shader IS USED WITH LOCAL EXPOSURE STUFF IN CERTAIN SCENARIOS

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
  bool _37 = ((((uint)(CBControl_000w)) & 1) == 0);  // CBControl_reserve
  bool _43 = false;
  bool _49;
  float _98;
  float _243;
  float _244;
  float _266;
  float _386;
  float _387;
  float _395;
  float _396;
  float _727;
  float _728;
  float _750;
  float _870;
  float _871;
  float _879;
  float _880;
  float _1011;
  float _1012;
  float _1036;
  float _1156;
  float _1157;
  float _1163;
  float _1164;
  float _1174;
  float _1175;
  float _1176;
  float _1181;
  float _1182;
  float _1183;
  float _1184;
  float _1185;
  float _1186;
  float _1187;
  float _1188;
  float _1189;
  float _1264;
  float _1867;
  float _1868;
  float _1869;
  float _1907;
  float _1908;
  float _1909;
  float _1920;
  float _1921;
  float _1922;
  float _1980;
  float _2001;
  float _2021;
  float _2029;
  float _2030;
  float _2031;
  float _2068;
  float _2084;
  float _2100;
  float _2128;
  float _2129;
  float _2130;
  float _2165;
  float _2175;
  float _2185;
  float _2211;
  float _2225;
  float _2239;
  float _2250;
  float _2259;
  float _2268;
  float _2293;
  float _2307;
  float _2321;
  float _2342;
  float _2352;
  float _2362;
  float _2387;
  float _2401;
  float _2415;
  float _2437;
  float _2447;
  float _2457;
  float _2482;
  float _2496;
  float _2510;
  float _2521;
  float _2522;
  float _2523;
  float _2537;
  float _2538;
  float _2539;
  float _2580;
  float _2581;
  float _2582;
  float _2628;
  float _2640;
  float _2652;
  float _2663;
  float _2664;
  float _2665;
  float _2681;
  float _2690;
  float _2699;
  float _2770;
  float _2771;
  float _2772;

  float _118 = ((SceneInfo_023z) * (SV_Position.x)) + -0.5f;
  float _119 = ((SceneInfo_023w) * (SV_Position.y)) + -0.5f;
  float _120 = dot(float2(_118, _119), float2(_118, _119));
  float _123 = ((_120 * (LDRPostProcessParam_004x)) + 1.0f) * (LDRPostProcessParam_005w);  // fDistortionCoef * fCorrectCoef
  float _124 = _123 * _118;
  float _125 = _123 * _119;
  float _126 = _124 + 0.5f;
  float _127 = _125 + 0.5f;
  float2 _137 = HazeNoiseResult.Sample(BilinearWrap, float2(_126, _127));

  if (!_37) {
    // Not here
    _43 = ((((uint)(LDRPostProcessParam_005z)) == 0));  // distortion type
  }
  _49 = false;
  if (!_37) {
    // Not here
    _49 = ((((uint)(LDRPostProcessParam_005z)) == 1));  // distortion type
  }

  bool _51 = ((((uint)(CBControl_000w)) & 64) != 0);  // CBControl_reserve

  // Lens distortion
  [branch]
  if ((((CameraKerare_000w) == 0.0f))) {  // kerare_offset
    // Not here
    float _59 = (Kerare.x) / (Kerare.w);
    float _60 = (Kerare.y) / (Kerare.w);
    float _61 = (Kerare.z) / (Kerare.w);
    float _65 = abs(((rsqrt((dot(float3(_59, _60, _61), float3(_59, _60, _61))))) * _61));
    float _70 = _65 * _65;
    _98 = ((_70 * _70) * (1.0f - (saturate((((CameraKerare_000x)*_65) + (CameraKerare_000y))))));
  } else {
    // here
    // Vignette
    float _81 = (((SceneInfo_023w) * (SV_Position.y)) + -0.5f) * 2.0f;                          // cameraFarPlane
    float _83 = ((CameraKerare_000w) * 2.0f) * (((SceneInfo_023z) * (SV_Position.x)) + -0.5f);  // kerare_offset * cameraNearPlane
    float _85 = sqrt((dot(float2(_83, _81), float2(_83, _81))));
    float _93 = (_85 * _85) + 1.0f;
    // kerare_scale * kerare_offset
    _98 = ((1.0f / (_93 * _93)) * (1.0f - (saturate((((CameraKerare_000x) * (1.0f / (_85 + 1.0f))) + (CameraKerare_000y))))));
  }
  // Add brightness?
  float _100 = saturate((_98 + (CameraKerare_000z)));  // kerare_brightness
  CustomVignette(_100);
  float _101 = _100 * (Exposure);  // Exposure here is < 1.f, so reduces brightness

  // This should be 1 if 0x4905680A is loaded, since that one handles exposure
  float custom_flat_exposure = 1.f;

  // We check if 0x4905680A has loaded
  if (CUSTOM_EXPOSURE_SHADER_DRAW == 0.f) {
    // In case of vanilla
    custom_flat_exposure = 1.f * NormalizeExposure();
    if (CUSTOM_EXPOSURE_TYPE >= 1.f) {
      custom_flat_exposure = FlatExposure();
    }
  }
  
  // Lens distortion
  if (_43) {
    // Not here
    float _118 = ((SceneInfo_023z) * (SV_Position.x)) + -0.5f;
    float _119 = ((SceneInfo_023w) * (SV_Position.y)) + -0.5f;
    float _120 = dot(float2(_118, _119), float2(_118, _119));
    float _123 = ((_120 * (LDRPostProcessParam_004x)) + 1.0f) * (LDRPostProcessParam_005w);  // fDistortionCoef * fCorrectCoef
    float _124 = _123 * _118;
    float _125 = _123 * _119;
    float _126 = _124 + 0.5f;
    float _127 = _125 + 0.5f;
    if (((((uint)(LDRPostProcessParam_005y)) == 0))) {  // aberrationEnable
      _395 = _126;
      _396 = _127;
      do {
        if (_51) {
          if (!((((uint)(LDRPostProcessParam_003y)) == 0))) {  // fHazeFilterReductionResolution
            float2 _137 = HazeNoiseResult.Sample(BilinearWrap, float2(_126, _127));
            _395 = (((LDRPostProcessParam_002x) * (_137.x)) + _126);
            _396 = (((LDRPostProcessParam_002x) * (_137.y)) + _127);
          } else {
            bool _149 = ((((uint)(LDRPostProcessParam_003x)) & 2) != 0);
            do {
              if (_149) {
                float _168 = (((_126 * 2.0f) * (SceneInfo_023x)) * (SceneInfo_023z)) + -1.0f;
                float _169 = 1.0f - (((_127 * 2.0f) * (SceneInfo_023y)) * (SceneInfo_023w));
                float _206 = 1.0f / ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_126, _127), 0.0f)).x), (SceneInfo_016w), (mad(_169, (SceneInfo_015w), (_168 * (SceneInfo_014w)))))) + (SceneInfo_017w));
                float _208 = _206 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_126, _127), 0.0f)).x), (SceneInfo_016y), (mad(_169, (SceneInfo_015y), (_168 * (SceneInfo_014y)))))) + (SceneInfo_017y));
                float _216 = (_206 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_126, _127), 0.0f)).x), (SceneInfo_016x), (mad(_169, (SceneInfo_015x), (_168 * (SceneInfo_014x)))))) + (SceneInfo_017x))) - (SceneInfo_007w);
                float _217 = _208 - (SceneInfo_008w);  // transposeViewInvMat
                float _218 = (_206 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_126, _127), 0.0f)).x), (SceneInfo_016z), (mad(_169, (SceneInfo_015z), (_168 * (SceneInfo_014z)))))) + (SceneInfo_017z))) - (SceneInfo_009w);
                _243 = (saturate((((tFilterTempMap1.Sample(BilinearWrap, float2(_126, _127))).x) * (max((((sqrt((((_217 * _217) + (_216 * _216)) + (_218 * _218)))) - (LDRPostProcessParam_000x)) * (LDRPostProcessParam_000y)), ((_208 - (LDRPostProcessParam_000z)) * (LDRPostProcessParam_000w)))))));
                _244 = ((ReadonlyDepth.SampleLevel(PointClamp, float2(_126, _127), 0.0f)).x);
              } else {
                _243 = ((((bool)(((((uint)(LDRPostProcessParam_003x)) & 1) != 0))) ? (1.0f - ((tFilterTempMap1.Sample(BilinearWrap, float2(_126, _127))).x)) : ((tFilterTempMap1.Sample(BilinearWrap, float2(_126, _127))).x)));
                _244 = 0.0f;
              }
              _266 = 1.0f;
              do {
                if (!(((((uint)(LDRPostProcessParam_003x)) & 4) == 0))) {
                  float _256 = 0.5f / (LDRPostProcessParam_002y);
                  _266 = (1.0f - (saturate((max(((_256 * (min((max(((abs(_124)) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)), ((_256 * (min((max(((abs(_125)) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)))))));
                }
                float _267 = _266 * _243;
                _386 = 0.0f;
                _387 = 0.0f;
                do {
                  if ((!(_267 <= 9.999999747378752e-06f))) {
                    float _274 = -0.0f - _127;
                    float _297 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_007z), (mad(_274, (SceneInfo_007y), ((SceneInfo_007x)*_126)))));
                    float _298 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_008z), (mad(_274, (SceneInfo_008y), ((SceneInfo_008x)*_126)))));
                    float _299 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_009z), (mad(_274, (SceneInfo_009y), ((SceneInfo_009x)*_126)))));
                    float _308 = _297 * 2.0f;
                    float _309 = _298 * 2.0f;
                    float _310 = _299 * 2.0f;
                    float _318 = _297 * 4.0f;
                    float _319 = _298 * 4.0f;
                    float _320 = _299 * 4.0f;
                    float _328 = _297 * 8.0f;
                    float _329 = _298 * 8.0f;
                    float _330 = _299 * 8.0f;
                    float _338 = (LDRPostProcessParam_001x) + 0.5f;
                    float _339 = (LDRPostProcessParam_001y) + 0.5f;
                    float _340 = (LDRPostProcessParam_001z) + 0.5f;
                    float _372 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_308 + (LDRPostProcessParam_001x)), (_309 + (LDRPostProcessParam_001y)), (_310 + (LDRPostProcessParam_001z))))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_297 + (LDRPostProcessParam_001x)), (_298 + (LDRPostProcessParam_001y)), (_299 + (LDRPostProcessParam_001z))))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_318 + (LDRPostProcessParam_001x)), (_319 + (LDRPostProcessParam_001y)), (_320 + (LDRPostProcessParam_001z))))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_328 + (LDRPostProcessParam_001x)), (_329 + (LDRPostProcessParam_001y)), (_330 + (LDRPostProcessParam_001z))))).x) * 0.0625f)) * 2.0f) + -1.0f) * _267;
                    float _373 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_308 + _338), (_309 + _339), (_310 + _340)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_297 + _338), (_298 + _339), (_299 + _340)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_318 + _338), (_319 + _339), (_320 + _340)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_328 + _338), (_329 + _339), (_330 + _340)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _267;
                    _386 = _372;
                    _387 = _373;
                    if (_149) {
                      _386 = 0.0f;
                      _387 = 0.0f;
                      if ((!((((ReadonlyDepth.Sample(BilinearWrap, float2((_372 + _126), (_373 + _127)))).x) - _244) >= (LDRPostProcessParam_002w)))) {
                        _386 = _372;
                        _387 = _373;
                      }
                    }
                  }
                  _395 = (((LDRPostProcessParam_002x)*_386) + _126);
                  _396 = (((LDRPostProcessParam_002x)*_387) + _127);
                } while (false);
              } while (false);
            } while (false);
          }
        }

        _395 = lerp(_126, _395, CUSTOM_ABERRATION);
        _396 = lerp(_127, _396, CUSTOM_ABERRATION);

        float4 _399 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_395, _396));
        _1181 = ((_399.x) * _101) * custom_flat_exposure;
        _1182 = ((_399.y) * _101) * custom_flat_exposure;
        _1183 = ((_399.z) * _101) * custom_flat_exposure;
        _1184 = (LDRPostProcessParam_004x);  // fDistortionCoef
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = (LDRPostProcessParam_005w);  // fCorrectCoef
      } while (false);
    } else {
      // Refraction?
      float _422 = (((saturate((((sqrt(((_118 * _118) + (_119 * _119)))) - (LDRPostProcessParam_004w)) / ((LDRPostProcessParam_005x) - (LDRPostProcessParam_004w))))) * (1.0f - (LDRPostProcessParam_004z))) + (LDRPostProcessParam_004z)) * (LDRPostProcessParam_004y);
      float _424 = _118 * (LDRPostProcessParam_005w);  // fCorrectCoef
      float _425 = _119 * (LDRPostProcessParam_005w);
      if (!((((uint)(LDRPostProcessParam_006x)) == 0))) {
        float _434 = ((LDRPostProcessParam_006y) * 0.125f) * (frac(((frac((dot(float2((SV_Position.x), (SV_Position.y)), float2(0.0671105608344078f, 0.005837149918079376f))))) * 52.98291778564453f)));
        float _435 = _422 * 2.0f;
        float _439 = (((_435 * _434) + _120) * (LDRPostProcessParam_004x)) + 1.0f;
        float _450 = (((_435 * (_434 + 0.125f)) + _120) * (LDRPostProcessParam_004x)) + 1.0f;
        float _462 = (((_435 * (_434 + 0.25f)) + _120) * (LDRPostProcessParam_004x)) + 1.0f;
        float4 _467 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _462) + 0.5f), ((_425 * _462) + 0.5f)));
        float _476 = (((_435 * (_434 + 0.375f)) + _120) * (LDRPostProcessParam_004x)) + 1.0f;
        float4 _481 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _476) + 0.5f), ((_425 * _476) + 0.5f)));
        float _490 = (((_435 * (_434 + 0.5f)) + _120) * (LDRPostProcessParam_004x)) + 1.0f;
        float _501 = (((_435 * (_434 + 0.625f)) + _120) * (LDRPostProcessParam_004x)) + 1.0f;
        float4 _506 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _501) + 0.5f), ((_425 * _501) + 0.5f)));
        float _514 = (((_435 * (_434 + 0.75f)) + _120) * (LDRPostProcessParam_004x)) + 1.0f;
        float4 _519 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _514) + 0.5f), ((_425 * _514) + 0.5f)));
        float _534 = (((_435 * (_434 + 0.875f)) + _120) * (LDRPostProcessParam_004x)) + 1.0f;
        float _546 = (((_435 * (_434 + 1.0f)) + _120) * (LDRPostProcessParam_004x)) + 1.0f;
        float _554 = _101 * 0.3199999928474426f;
        _1181 = (_554 * ((((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _450) + 0.5f), ((_425 * _450) + 0.5f))))).x) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _439) + 0.5f), ((_425 * _439) + 0.5f))))).x)) + ((_467.x) * 0.75f)) + ((_481.x) * 0.375f)));
        _1182 = ((_101 * 0.3636363744735718f) * (((((_506.y) + (_481.y)) * 0.625f) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _490) + 0.5f), ((_425 * _490) + 0.5f))))).y)) + (((_519.y) + (_467.y)) * 0.25f)));
        _1183 = (_554 * (((((_519.z) * 0.75f) + ((_506.z) * 0.375f)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _534) + 0.5f), ((_425 * _534) + 0.5f))))).z)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _546) + 0.5f), ((_425 * _546) + 0.5f))))).z)));
        _1184 = (LDRPostProcessParam_004x);
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = (LDRPostProcessParam_005w);
      } else {
        float _560 = _422 + _120;
        float _562 = (_560 * (LDRPostProcessParam_004x)) + 1.0f;
        float _569 = ((_560 + _422) * (LDRPostProcessParam_004x)) + 1.0f;
        _1181 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_126, _127)))).x) * _101);
        _1182 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _562) + 0.5f), ((_425 * _562) + 0.5f))))).y) * _101);
        _1183 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_424 * _569) + 0.5f), ((_425 * _569) + 0.5f))))).z) * _101);
        _1184 = (LDRPostProcessParam_004x);
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = (LDRPostProcessParam_005w);
      }
    }
  } else {
    // Here
    // _49 is distortion type
    // We still hazing
    if (_49) {
      // Not here
      float _594 = (((SV_Position.x) * 2.0f) * (SceneInfo_023z)) + -1.0f;
      float _598 = sqrt(((_594 * _594) + 1.0f));
      float _599 = 1.0f / _598;
      // Controls lens distortion
      float _602 = (_598 * (LDRPostProcessParam_007z)) * (_599 + (LDRPostProcessParam_007x));  // fOptimizedParam
      float _606 = (LDRPostProcessParam_007w) * 0.5f;
      float _608 = (_606 * _594) * _602;
      float _611 = ((_606 * ((((SV_Position.y) * 2.0f) * (SceneInfo_023w)) + -1.0f)) * (((_599 + -1.0f) * (LDRPostProcessParam_007y)) + 1.0f)) * _602;
      float _612 = _608 + 0.5f;
      float _613 = _611 + 0.5f;
      _879 = _612;
      _880 = _613;
      do {
        if (_51) {
          if (!((((uint)(LDRPostProcessParam_003y)) == 0))) {
            float2 _621 = HazeNoiseResult.Sample(BilinearWrap, float2(_612, _613));
            _879 = (((LDRPostProcessParam_002x) * (_621.x)) + _612);
            _880 = (((LDRPostProcessParam_002x) * (_621.y)) + _613);
          } else {
            bool _633 = ((((uint)(LDRPostProcessParam_003x)) & 2) != 0);
            do {
              if (_633) {
                float _652 = (((_612 * 2.0f) * (SceneInfo_023x)) * (SceneInfo_023z)) + -1.0f;
                float _653 = 1.0f - (((_613 * 2.0f) * (SceneInfo_023y)) * (SceneInfo_023w));
                float _690 = 1.0f / ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_612, _613), 0.0f)).x), (SceneInfo_016w), (mad(_653, (SceneInfo_015w), (_652 * (SceneInfo_014w)))))) + (SceneInfo_017w));
                float _692 = _690 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_612, _613), 0.0f)).x), (SceneInfo_016y), (mad(_653, (SceneInfo_015y), (_652 * (SceneInfo_014y)))))) + (SceneInfo_017y));
                float _700 = (_690 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_612, _613), 0.0f)).x), (SceneInfo_016x), (mad(_653, (SceneInfo_015x), (_652 * (SceneInfo_014x)))))) + (SceneInfo_017x))) - (SceneInfo_007w);
                float _701 = _692 - (SceneInfo_008w);
                float _702 = (_690 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_612, _613), 0.0f)).x), (SceneInfo_016z), (mad(_653, (SceneInfo_015z), (_652 * (SceneInfo_014z)))))) + (SceneInfo_017z))) - (SceneInfo_009w);
                _727 = (saturate((((tFilterTempMap1.Sample(BilinearWrap, float2(_612, _613))).x) * (max((((sqrt((((_701 * _701) + (_700 * _700)) + (_702 * _702)))) - (LDRPostProcessParam_000x)) * (LDRPostProcessParam_000y)), ((_692 - (LDRPostProcessParam_000z)) * (LDRPostProcessParam_000w)))))));
                _728 = ((ReadonlyDepth.SampleLevel(PointClamp, float2(_612, _613), 0.0f)).x);
              } else {
                _727 = ((((bool)(((((uint)(LDRPostProcessParam_003x)) & 1) != 0))) ? (1.0f - ((tFilterTempMap1.Sample(BilinearWrap, float2(_612, _613))).x)) : ((tFilterTempMap1.Sample(BilinearWrap, float2(_612, _613))).x)));
                _728 = 0.0f;
              }
              _750 = 1.0f;
              do {
                if (!(((((uint)(LDRPostProcessParam_003x)) & 4) == 0))) {
                  float _740 = 0.5f / (LDRPostProcessParam_002y);
                  _750 = (1.0f - (saturate((max(((_740 * (min((max(((abs(_608)) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)), ((_740 * (min((max(((abs(_611)) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)))))));
                }
                float _751 = _750 * _727;
                _870 = 0.0f;
                _871 = 0.0f;
                do {
                  if ((!(_751 <= 9.999999747378752e-06f))) {
                    float _758 = -0.0f - _613;
                    float _781 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_007z), (mad(_758, (SceneInfo_007y), ((SceneInfo_007x)*_612)))));
                    float _782 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_008z), (mad(_758, (SceneInfo_008y), ((SceneInfo_008x)*_612)))));
                    float _783 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_009z), (mad(_758, (SceneInfo_009y), ((SceneInfo_009x)*_612)))));
                    float _792 = _781 * 2.0f;
                    float _793 = _782 * 2.0f;
                    float _794 = _783 * 2.0f;
                    float _802 = _781 * 4.0f;
                    float _803 = _782 * 4.0f;
                    float _804 = _783 * 4.0f;
                    float _812 = _781 * 8.0f;
                    float _813 = _782 * 8.0f;
                    float _814 = _783 * 8.0f;
                    float _822 = (LDRPostProcessParam_001x) + 0.5f;
                    float _823 = (LDRPostProcessParam_001y) + 0.5f;
                    float _824 = (LDRPostProcessParam_001z) + 0.5f;
                    float _856 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_792 + (LDRPostProcessParam_001x)), (_793 + (LDRPostProcessParam_001y)), (_794 + (LDRPostProcessParam_001z))))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_781 + (LDRPostProcessParam_001x)), (_782 + (LDRPostProcessParam_001y)), (_783 + (LDRPostProcessParam_001z))))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_802 + (LDRPostProcessParam_001x)), (_803 + (LDRPostProcessParam_001y)), (_804 + (LDRPostProcessParam_001z))))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_812 + (LDRPostProcessParam_001x)), (_813 + (LDRPostProcessParam_001y)), (_814 + (LDRPostProcessParam_001z))))).x) * 0.0625f)) * 2.0f) + -1.0f) * _751;
                    float _857 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_792 + _822), (_793 + _823), (_794 + _824)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_781 + _822), (_782 + _823), (_783 + _824)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_802 + _822), (_803 + _823), (_804 + _824)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_812 + _822), (_813 + _823), (_814 + _824)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _751;
                    _870 = _856;
                    _871 = _857;
                    if (_633) {
                      _870 = 0.0f;
                      _871 = 0.0f;
                      if ((!((((ReadonlyDepth.Sample(BilinearWrap, float2((_856 + _612), (_857 + _613)))).x) - _728) >= (LDRPostProcessParam_002w)))) {
                        _870 = _856;
                        _871 = _857;
                      }
                    }
                  }
                  _879 = (((LDRPostProcessParam_002x)*_870) + _612);
                  _880 = (((LDRPostProcessParam_002x)*_871) + _613);
                } while (false);
              } while (false);
            } while (false);
          }
        }
        // Here
        // RE_POSTPROCESS_Color is adjusted by 0x4905680A
        float4 _883 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_879, _880));
        // This section in flat FOR SURE
        _1181 = ((_883.x) * _101) * custom_flat_exposure;
        _1182 = ((_883.y) * _101) * custom_flat_exposure;
        _1183 = ((_883.z) * _101) * custom_flat_exposure;
        _1184 = 0.0f;
        _1185 = (LDRPostProcessParam_007x);  // fOptimizedParam
        _1186 = (LDRPostProcessParam_007y);
        _1187 = (LDRPostProcessParam_007z);
        _1188 = (LDRPostProcessParam_007w);
        _1189 = 1.0f;
      } while (false);
    } else {
      // Here
      float _891 = (SceneInfo_023z) * (SV_Position.x);  // cameraNearPlane
      float _892 = (SceneInfo_023w) * (SV_Position.y);  // cameraFarPlane
      do {
        if (!_51) {  // CBControl_reserve
          // Here
          float4 _896 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_891, _892));

          _1174 = (_896.x) * custom_flat_exposure;
          _1175 = (_896.y) * custom_flat_exposure;
          _1176 = (_896.z) * custom_flat_exposure;
        } else {
          do {
            if (!((((uint)(LDRPostProcessParam_003y)) == 0))) {  // fHazeFilterReductionResolution
              float2 _907 = HazeNoiseResult.Sample(BilinearWrap, float2(_891, _892));
              _1163 = ((LDRPostProcessParam_002x) * (_907.x));  // fHazeFilterScale
              _1164 = ((LDRPostProcessParam_002x) * (_907.y));  // fHazeFilterScale
            } else {
              bool _917 = ((((uint)(LDRPostProcessParam_003x)) & 2) != 0);
              do {
                if (_917) {
                  float _936 = (((_891 * 2.0f) * (SceneInfo_023x)) * (SceneInfo_023z)) + -1.0f;
                  float _937 = 1.0f - (((_892 * 2.0f) * (SceneInfo_023y)) * (SceneInfo_023w));
                  float _974 = 1.0f / ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_891, _892), 0.0f)).x), (SceneInfo_016w), (mad(_937, (SceneInfo_015w), (_936 * (SceneInfo_014w)))))) + (SceneInfo_017w));
                  float _976 = _974 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_891, _892), 0.0f)).x), (SceneInfo_016y), (mad(_937, (SceneInfo_015y), (_936 * (SceneInfo_014y)))))) + (SceneInfo_017y));
                  float _984 = (_974 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_891, _892), 0.0f)).x), (SceneInfo_016x), (mad(_937, (SceneInfo_015x), (_936 * (SceneInfo_014x)))))) + (SceneInfo_017x))) - (SceneInfo_007w);
                  float _985 = _976 - (SceneInfo_008w);
                  float _986 = (_974 * ((mad(((ReadonlyDepth.SampleLevel(PointClamp, float2(_891, _892), 0.0f)).x), (SceneInfo_016z), (mad(_937, (SceneInfo_015z), (_936 * (SceneInfo_014z)))))) + (SceneInfo_017z))) - (SceneInfo_009w);
                  _1011 = (saturate((((tFilterTempMap1.Sample(BilinearWrap, float2(_891, _892))).x) * (max((((sqrt((((_985 * _985) + (_984 * _984)) + (_986 * _986)))) - (LDRPostProcessParam_000x)) * (LDRPostProcessParam_000y)), ((_976 - (LDRPostProcessParam_000z)) * (LDRPostProcessParam_000w)))))));
                  _1012 = ((ReadonlyDepth.SampleLevel(PointClamp, float2(_891, _892), 0.0f)).x);
                } else {
                  _1011 = ((((bool)(((((uint)(LDRPostProcessParam_003x)) & 1) != 0))) ? (1.0f - ((tFilterTempMap1.Sample(BilinearWrap, float2(_891, _892))).x)) : ((tFilterTempMap1.Sample(BilinearWrap, float2(_891, _892))).x)));
                  _1012 = 0.0f;
                }
                _1036 = 1.0f;
                do {
                  if (!(((((uint)(LDRPostProcessParam_003x)) & 4) == 0))) {
                    float _1026 = 0.5f / (LDRPostProcessParam_002y);
                    _1036 = (1.0f - (saturate((max(((_1026 * (min((max(((abs((_891 + -0.5f))) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)), ((_1026 * (min((max(((abs((_892 + -0.5f))) - (LDRPostProcessParam_002y)), 0.0f)), 1.0f))) * (LDRPostProcessParam_002z)))))));
                  }
                  float _1037 = _1036 * _1011;
                  _1156 = 0.0f;
                  _1157 = 0.0f;
                  do {
                    if ((!(_1037 <= 9.999999747378752e-06f))) {
                      float _1044 = -0.0f - _892;
                      float _1067 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_007z), (mad(_1044, (SceneInfo_007y), ((SceneInfo_007x)*_891)))));
                      float _1068 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_008z), (mad(_1044, (SceneInfo_008y), ((SceneInfo_008x)*_891)))));
                      float _1069 = (LDRPostProcessParam_001w) * (mad(-1.0f, (SceneInfo_009z), (mad(_1044, (SceneInfo_009y), ((SceneInfo_009x)*_891)))));
                      float _1078 = _1067 * 2.0f;
                      float _1079 = _1068 * 2.0f;
                      float _1080 = _1069 * 2.0f;
                      float _1088 = _1067 * 4.0f;
                      float _1089 = _1068 * 4.0f;
                      float _1090 = _1069 * 4.0f;
                      float _1098 = _1067 * 8.0f;
                      float _1099 = _1068 * 8.0f;
                      float _1100 = _1069 * 8.0f;
                      float _1108 = (LDRPostProcessParam_001x) + 0.5f;
                      float _1109 = (LDRPostProcessParam_001y) + 0.5f;
                      float _1110 = (LDRPostProcessParam_001z) + 0.5f;
                      float _1142 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1078 + (LDRPostProcessParam_001x)), (_1079 + (LDRPostProcessParam_001y)), (_1080 + (LDRPostProcessParam_001z))))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_1067 + (LDRPostProcessParam_001x)), (_1068 + (LDRPostProcessParam_001y)), (_1069 + (LDRPostProcessParam_001z))))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1088 + (LDRPostProcessParam_001x)), (_1089 + (LDRPostProcessParam_001y)), (_1090 + (LDRPostProcessParam_001z))))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1098 + (LDRPostProcessParam_001x)), (_1099 + (LDRPostProcessParam_001y)), (_1100 + (LDRPostProcessParam_001z))))).x) * 0.0625f)) * 2.0f) + -1.0f) * _1037;
                      float _1143 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1078 + _1108), (_1079 + _1109), (_1080 + _1110)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_1067 + _1108), (_1068 + _1109), (_1069 + _1110)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1088 + _1108), (_1089 + _1109), (_1090 + _1110)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1098 + _1108), (_1099 + _1109), (_1100 + _1110)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _1037;
                      _1156 = _1142;
                      _1157 = _1143;
                      if (_917) {
                        _1156 = 0.0f;
                        _1157 = 0.0f;
                        if ((!((((ReadonlyDepth.Sample(BilinearWrap, float2((_1142 + _891), (_1143 + _892)))).x) - _1012) >= (LDRPostProcessParam_002w)))) {
                          _1156 = _1142;
                          _1157 = _1143;
                        }
                      }
                    }
                    _1163 = ((LDRPostProcessParam_002x)*_1156);
                    _1164 = ((LDRPostProcessParam_002x)*_1157);
                  } while (false);
                } while (false);
              } while (false);
            }
            float4 _1169 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1163 + _891), (_1164 + _892)));
            _1174 = (_1169.x) * custom_flat_exposure;
            _1175 = (_1169.y) * custom_flat_exposure;
            _1176 = (_1169.z) * custom_flat_exposure;
          } while (false);
        }
        // Obviously here
        // Multiply post process by Exposure
        // This is where flat goes
        _1181 = (_1174 * _101);
        _1182 = (_1175 * _101);
        _1183 = (_1176 * _101);
        _1184 = 0.0f;
        _1185 = 0.0f;
        _1186 = 0.0f;
        _1187 = 0.0f;
        _1188 = 0.0f;
        _1189 = 1.0f;
      } while (false);
    }
  }
  // lens distortion post process * Exposure
  _1920 = _1181;
  _1921 = _1182;
  _1922 = _1183;
  // This if handles radial blur
  if (!(((((uint)(CBControl_000w)) & 32) == 0))) {  // CBControl_reserve
    // Not here
    // RadialBlurComputeResult so blur effect?
    float _1210 = _100 * (Exposure);
    float _1213 = float((bool)((bool)(((((uint)(LDRPostProcessParam_024x)) & 2) != 0))));  // cbRadialBlurFlags
    float _1220 = ((1.0f - _1213) + ((((float4)(ComputeResultSRV[0].data[0 / 4])).x) * _1213)) * (LDRPostProcessParam_021w);
    _1920 = _1181;
    _1921 = _1182;
    _1922 = _1183;
    if (!((_1220 == 0.0f))) {
      float _1226 = (SceneInfo_023z) * (SV_Position.x);
      float _1227 = (SceneInfo_023w) * (SV_Position.y);
      float _1229 = (-0.5f - (LDRPostProcessParam_022x)) + _1226;  // cbRadialScreenPos
      float _1231 = (-0.5f - (LDRPostProcessParam_022y)) + _1227;  // cbRadialScreenPos
      float _1234 = (((bool)((_1229 < 0.0f))) ? (1.0f - _1226) : _1226);
      float _1237 = (((bool)((_1231 < 0.0f))) ? (1.0f - _1227) : _1227);
      _1264 = 1.0f;
      do {
        if (!(((((uint)(LDRPostProcessParam_024x)) & 1) == 0))) {
          float _1242 = rsqrt((dot(float2(_1229, _1231), float2(_1229, _1231))));
          uint _1251 = (uint((abs(((_1231 * (LDRPostProcessParam_023w)) * _1242))))) + (uint((abs(((_1229 * (LDRPostProcessParam_023w)) * _1242)))));
          uint _1255 = ((_1251 ^ 61) ^ ((uint)(_1251) >> 16)) * 9;
          uint _1258 = (((uint)(_1255) >> 4) ^ _1255) * 668265261;
          _1264 = ((float((uint)((int)(((uint)(_1258) >> 15) ^ _1258)))) * 2.3283064365386963e-10f);
        }
        float _1270 = 1.0f / (max(1.0f, (sqrt(((_1229 * _1229) + (_1231 * _1231))))));
        float _1271 = (LDRPostProcessParam_023z) * -0.0011111111380159855f;
        float _1280 = ((((_1271 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1281 = ((((_1271 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1283 = (LDRPostProcessParam_023z) * -0.002222222276031971f;
        float _1292 = ((((_1283 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1293 = ((((_1283 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1294 = (LDRPostProcessParam_023z) * -0.0033333334140479565f;
        float _1303 = ((((_1294 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1304 = ((((_1294 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1305 = (LDRPostProcessParam_023z) * -0.004444444552063942f;
        float _1314 = ((((_1305 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1315 = ((((_1305 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1316 = (LDRPostProcessParam_023z) * -0.0055555556900799274f;
        float _1325 = ((((_1316 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1326 = ((((_1316 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1327 = (LDRPostProcessParam_023z) * -0.006666666828095913f;
        float _1336 = ((((_1327 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1337 = ((((_1327 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1338 = (LDRPostProcessParam_023z) * -0.007777777966111898f;
        float _1347 = ((((_1338 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1348 = ((((_1338 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1349 = (LDRPostProcessParam_023z) * -0.008888889104127884f;
        float _1358 = ((((_1349 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1359 = ((((_1349 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        float _1360 = (LDRPostProcessParam_023z) * -0.009999999776482582f;
        float _1369 = ((((_1360 * _1234) * _1264) * _1270) + 1.0f) * _1229;
        float _1370 = ((((_1360 * _1237) * _1264) * _1270) + 1.0f) * _1231;
        do {
          if (_43) {
            float _1372 = _1280 + (LDRPostProcessParam_022x);
            float _1373 = _1281 + (LDRPostProcessParam_022y);
            float _1377 = (((dot(float2(_1372, _1373), float2(_1372, _1373))) * _1184) + 1.0f) * _1189;
            float4 _1383 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1377 * _1372) + 0.5f), ((_1377 * _1373) + 0.5f)), 0.0f);
            float _1387 = _1292 + (LDRPostProcessParam_022x);
            float _1388 = _1293 + (LDRPostProcessParam_022y);
            float _1391 = ((dot(float2(_1387, _1388), float2(_1387, _1388))) * _1184) + 1.0f;
            float4 _1398 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1387 * _1189) * _1391) + 0.5f), (((_1388 * _1189) * _1391) + 0.5f)), 0.0f);
            float _1405 = _1303 + (LDRPostProcessParam_022x);
            float _1406 = _1304 + (LDRPostProcessParam_022y);
            float _1409 = ((dot(float2(_1405, _1406), float2(_1405, _1406))) * _1184) + 1.0f;
            float4 _1416 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1405 * _1189) * _1409) + 0.5f), (((_1406 * _1189) * _1409) + 0.5f)), 0.0f);
            float _1423 = _1314 + (LDRPostProcessParam_022x);
            float _1424 = _1315 + (LDRPostProcessParam_022y);
            float _1427 = ((dot(float2(_1423, _1424), float2(_1423, _1424))) * _1184) + 1.0f;
            float4 _1434 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1423 * _1189) * _1427) + 0.5f), (((_1424 * _1189) * _1427) + 0.5f)), 0.0f);
            float _1441 = _1325 + (LDRPostProcessParam_022x);
            float _1442 = _1326 + (LDRPostProcessParam_022y);
            float _1445 = ((dot(float2(_1441, _1442), float2(_1441, _1442))) * _1184) + 1.0f;
            float4 _1452 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1441 * _1189) * _1445) + 0.5f), (((_1442 * _1189) * _1445) + 0.5f)), 0.0f);
            float _1459 = _1336 + (LDRPostProcessParam_022x);
            float _1460 = _1337 + (LDRPostProcessParam_022y);
            float _1463 = ((dot(float2(_1459, _1460), float2(_1459, _1460))) * _1184) + 1.0f;
            float4 _1470 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1459 * _1189) * _1463) + 0.5f), (((_1460 * _1189) * _1463) + 0.5f)), 0.0f);
            float _1477 = _1347 + (LDRPostProcessParam_022x);
            float _1478 = _1348 + (LDRPostProcessParam_022y);
            float _1481 = ((dot(float2(_1477, _1478), float2(_1477, _1478))) * _1184) + 1.0f;
            float4 _1488 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1477 * _1189) * _1481) + 0.5f), (((_1478 * _1189) * _1481) + 0.5f)), 0.0f);
            float _1495 = _1358 + (LDRPostProcessParam_022x);
            float _1496 = _1359 + (LDRPostProcessParam_022y);
            float _1499 = ((dot(float2(_1495, _1496), float2(_1495, _1496))) * _1184) + 1.0f;
            float4 _1506 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1495 * _1189) * _1499) + 0.5f), (((_1496 * _1189) * _1499) + 0.5f)), 0.0f);
            float _1513 = _1369 + (LDRPostProcessParam_022x);
            float _1514 = _1370 + (LDRPostProcessParam_022y);
            float _1517 = ((dot(float2(_1513, _1514), float2(_1513, _1514))) * _1184) + 1.0f;
            float4 _1524 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_1513 * _1189) * _1517) + 0.5f), (((_1514 * _1189) * _1517) + 0.5f)), 0.0f);
            _1867 = (((((((((_1398.x) + (_1383.x)) + (_1416.x)) + (_1434.x)) + (_1452.x)) + (_1470.x)) + (_1488.x)) + (_1506.x)) + (_1524.x));
            _1868 = (((((((((_1398.y) + (_1383.y)) + (_1416.y)) + (_1434.y)) + (_1452.y)) + (_1470.y)) + (_1488.y)) + (_1506.y)) + (_1524.y));
            _1869 = (((((((((_1398.z) + (_1383.z)) + (_1416.z)) + (_1434.z)) + (_1452.z)) + (_1470.z)) + (_1488.z)) + (_1506.z)) + (_1524.z));
          } else {
            float _1532 = (LDRPostProcessParam_022x) + 0.5f;
            float _1533 = _1532 + _1280;
            float _1534 = (LDRPostProcessParam_022y) + 0.5f;
            float _1535 = _1534 + _1281;
            float _1536 = _1532 + _1292;
            float _1537 = _1534 + _1293;
            float _1538 = _1532 + _1303;
            float _1539 = _1534 + _1304;
            float _1540 = _1532 + _1314;
            float _1541 = _1534 + _1315;
            float _1542 = _1532 + _1325;
            float _1543 = _1534 + _1326;
            float _1544 = _1532 + _1336;
            float _1545 = _1534 + _1337;
            float _1546 = _1532 + _1347;
            float _1547 = _1534 + _1348;
            float _1548 = _1532 + _1358;
            float _1549 = _1534 + _1359;
            float _1550 = _1532 + _1369;
            float _1551 = _1534 + _1370;
            if (_49) {
              float _1555 = (_1533 * 2.0f) + -1.0f;
              float _1559 = sqrt(((_1555 * _1555) + 1.0f));
              float _1560 = 1.0f / _1559;
              float _1563 = (_1559 * _1187) * (_1560 + _1185);
              float _1567 = _1188 * 0.5f;
              float4 _1576 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1563) * _1555) + 0.5f), ((((_1567 * (((_1560 + -1.0f) * _1186) + 1.0f)) * _1563) * ((_1535 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
              float _1582 = (_1536 * 2.0f) + -1.0f;
              float _1586 = sqrt(((_1582 * _1582) + 1.0f));
              float _1587 = 1.0f / _1586;
              float _1590 = (_1586 * _1187) * (_1587 + _1185);
              float4 _1601 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1582) * _1590) + 0.5f), ((((_1567 * ((_1537 * 2.0f) + -1.0f)) * (((_1587 + -1.0f) * _1186) + 1.0f)) * _1590) + 0.5f)), 0.0f);
              float _1610 = (_1538 * 2.0f) + -1.0f;
              float _1614 = sqrt(((_1610 * _1610) + 1.0f));
              float _1615 = 1.0f / _1614;
              float _1618 = (_1614 * _1187) * (_1615 + _1185);
              float4 _1629 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1610) * _1618) + 0.5f), ((((_1567 * ((_1539 * 2.0f) + -1.0f)) * (((_1615 + -1.0f) * _1186) + 1.0f)) * _1618) + 0.5f)), 0.0f);
              float _1638 = (_1540 * 2.0f) + -1.0f;
              float _1642 = sqrt(((_1638 * _1638) + 1.0f));
              float _1643 = 1.0f / _1642;
              float _1646 = (_1642 * _1187) * (_1643 + _1185);
              float4 _1657 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1638) * _1646) + 0.5f), ((((_1567 * ((_1541 * 2.0f) + -1.0f)) * (((_1643 + -1.0f) * _1186) + 1.0f)) * _1646) + 0.5f)), 0.0f);
              float _1666 = (_1542 * 2.0f) + -1.0f;
              float _1670 = sqrt(((_1666 * _1666) + 1.0f));
              float _1671 = 1.0f / _1670;
              float _1674 = (_1670 * _1187) * (_1671 + _1185);
              float4 _1685 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1666) * _1674) + 0.5f), ((((_1567 * ((_1543 * 2.0f) + -1.0f)) * (((_1671 + -1.0f) * _1186) + 1.0f)) * _1674) + 0.5f)), 0.0f);
              float _1694 = (_1544 * 2.0f) + -1.0f;
              float _1698 = sqrt(((_1694 * _1694) + 1.0f));
              float _1699 = 1.0f / _1698;
              float _1702 = (_1698 * _1187) * (_1699 + _1185);
              float4 _1713 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1694) * _1702) + 0.5f), ((((_1567 * ((_1545 * 2.0f) + -1.0f)) * (((_1699 + -1.0f) * _1186) + 1.0f)) * _1702) + 0.5f)), 0.0f);
              float _1722 = (_1546 * 2.0f) + -1.0f;
              float _1726 = sqrt(((_1722 * _1722) + 1.0f));
              float _1727 = 1.0f / _1726;
              float _1730 = (_1726 * _1187) * (_1727 + _1185);
              float4 _1741 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1722) * _1730) + 0.5f), ((((_1567 * ((_1547 * 2.0f) + -1.0f)) * (((_1727 + -1.0f) * _1186) + 1.0f)) * _1730) + 0.5f)), 0.0f);
              float _1750 = (_1548 * 2.0f) + -1.0f;
              float _1754 = sqrt(((_1750 * _1750) + 1.0f));
              float _1755 = 1.0f / _1754;
              float _1758 = (_1754 * _1187) * (_1755 + _1185);
              float4 _1769 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1750) * _1758) + 0.5f), ((((_1567 * ((_1549 * 2.0f) + -1.0f)) * (((_1755 + -1.0f) * _1186) + 1.0f)) * _1758) + 0.5f)), 0.0f);
              float _1778 = (_1550 * 2.0f) + -1.0f;
              float _1782 = sqrt(((_1778 * _1778) + 1.0f));
              float _1783 = 1.0f / _1782;
              float _1786 = (_1782 * _1187) * (_1783 + _1185);
              float4 _1797 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_1567 * _1778) * _1786) + 0.5f), ((((_1567 * ((_1551 * 2.0f) + -1.0f)) * (((_1783 + -1.0f) * _1186) + 1.0f)) * _1786) + 0.5f)), 0.0f);
              _1867 = (((((((((_1601.x) + (_1576.x)) + (_1629.x)) + (_1657.x)) + (_1685.x)) + (_1713.x)) + (_1741.x)) + (_1769.x)) + (_1797.x));
              _1868 = (((((((((_1601.y) + (_1576.y)) + (_1629.y)) + (_1657.y)) + (_1685.y)) + (_1713.y)) + (_1741.y)) + (_1769.y)) + (_1797.y));
              _1869 = (((((((((_1601.z) + (_1576.z)) + (_1629.z)) + (_1657.z)) + (_1685.z)) + (_1713.z)) + (_1741.z)) + (_1769.z)) + (_1797.z));
            } else {
              float4 _1806 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1533, _1535), 0.0f);
              float4 _1810 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1536, _1537), 0.0f);
              float4 _1817 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1538, _1539), 0.0f);
              float4 _1824 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1540, _1541), 0.0f);
              float4 _1831 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1542, _1543), 0.0f);
              float4 _1838 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1544, _1545), 0.0f);
              float4 _1845 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1546, _1547), 0.0f);
              float4 _1852 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1548, _1549), 0.0f);
              float4 _1859 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1550, _1551), 0.0f);
              _1867 = (((((((((_1810.x) + (_1806.x)) + (_1817.x)) + (_1824.x)) + (_1831.x)) + (_1838.x)) + (_1845.x)) + (_1852.x)) + (_1859.x));
              _1868 = (((((((((_1810.y) + (_1806.y)) + (_1817.y)) + (_1824.y)) + (_1831.y)) + (_1838.y)) + (_1845.y)) + (_1852.y)) + (_1859.y));
              _1869 = (((((((((_1810.z) + (_1806.z)) + (_1817.z)) + (_1824.z)) + (_1831.z)) + (_1838.z)) + (_1845.z)) + (_1852.z)) + (_1859.z));
            }
          }
          float _1879 = (((_1869 * _1210) + _1183) * 0.10000000149011612f) * (LDRPostProcessParam_021z);
          float _1880 = (((_1868 * _1210) + _1182) * 0.10000000149011612f) * (LDRPostProcessParam_021y);
          float _1881 = (((_1867 * _1210) + _1181) * 0.10000000149011612f) * (LDRPostProcessParam_021x);
          _1907 = _1881;
          _1908 = _1880;
          _1909 = _1879;
          do {
            if ((((LDRPostProcessParam_023x) > 0.0f))) {
              float _1890 = saturate((((sqrt(((_1229 * _1229) + (_1231 * _1231)))) * (LDRPostProcessParam_022z)) + (LDRPostProcessParam_022w)));
              float _1896 = (((_1890 * _1890) * (LDRPostProcessParam_023x)) * (3.0f - (_1890 * 2.0f))) + (LDRPostProcessParam_023y);
              _1907 = ((_1896 * (_1881 - _1181)) + _1181);
              _1908 = ((_1896 * (_1880 - _1182)) + _1182);
              _1909 = ((_1896 * (_1879 - _1183)) + _1183);
            }
            _1920 = (((_1907 - _1181) * _1220) + _1181);
            _1921 = (((_1908 - _1182) * _1220) + _1182);
            _1922 = (((_1909 - _1183) * _1220) + _1183);
          } while (false);
        } while (false);
      } while (false);
    }
  }

  // I guess after everything is done we begin transforming colors?
  // ACES I assume
  // float4x4 fOCIOTransformMatrix;
  float _1937 = mad(_1922, (CBControl_003x), (mad(_1921, (CBControl_002x), ((CBControl_001x)*_1920))));
  float _1940 = mad(_1922, (CBControl_003y), (mad(_1921, (CBControl_002y), ((CBControl_001y)*_1920))));
  float _1943 = mad(_1922, (CBControl_003z), (mad(_1921, (CBControl_002z), ((CBControl_001z)*_1920))));
  _2029 = _1937;
  _2030 = _1940;
  _2031 = _1943;
  // Fuck is yellow threshold?
  // Force disabling doesn't do much, I guess it's related to ACEScc
  if (!((((uint)(CBControl_006w)) == 0))) {  // EnableReferenceGamutCompress
    // Here
    float _1949 = max((max(_1937, _1940)), _1943);
    _2029 = _1937;
    _2030 = _1940;
    _2031 = _1943;
    if ((!(_1949 == 0.0f))) {
      // here
      float _1955 = abs(_1949);
      float _1956 = (_1949 - _1937) / _1955;
      float _1957 = (_1949 - _1940) / _1955;
      float _1958 = (_1949 - _1943) / _1955;
      _1980 = _1956;
      do {
        if (!(!(_1956 >= (CBControl_005w)))) {  // CyanThreshold
          float _1968 = _1956 - (CBControl_005w);
          _1980 = ((_1968 / (exp2(((log2(((exp2(((log2((_1968 * (CBControl_007x)))) * (CBControl_006z)))) + 1.0f))) * (CBControl_007w))))) + (CBControl_005w));
        }
        _2001 = _1957;
        do {
          if (!(!(_1957 >= (CBControl_006x)))) {  // MagentaThreshold
            float _1989 = _1957 - (CBControl_006x);
            _2001 = ((_1989 / (exp2(((log2(((exp2(((log2((_1989 * (CBControl_007y)))) * (CBControl_006z)))) + 1.0f))) * (CBControl_007w))))) + (CBControl_006x));
          }
          _2021 = _1958;
          do {
            if (!(!(_1958 >= (CBControl_006y)))) {  // YellowThreshold
              float _2009 = _1958 - (CBControl_006y);
              _2021 = ((_2009 / (exp2(((log2(((exp2(((log2((_2009 * (CBControl_007z)))) * (CBControl_006z)))) + 1.0f))) * (CBControl_007w))))) + (CBControl_006y));
            }
            _2029 = (_1949 - (_1955 * _1980));
            _2030 = (_1949 - (_1955 * _2001));
            _2031 = (_1949 - (_1955 * _2021));
          } while (false);
        } while (false);
      } while (false);
    }
  }
  _2128 = _2029;
  _2129 = _2030;
  _2130 = _2031;

  if (!(((((uint)(CBControl_000w)) & 2) == 0))) {  // cPassEnabled
    // Not here!
    // Noise stuff (Yep, just noise)
    float _2048 = floor(((LDRPostProcessParam_009w) * ((LDRPostProcessParam_008z) + (SV_Position.x))));
    float _2050 = floor(((LDRPostProcessParam_009w) * ((LDRPostProcessParam_008w) + (SV_Position.y))));
    float _2054 = frac(((frac((dot(float2(_2048, _2050), float2(0.0671105608344078f, 0.005837149918079376f))))) * 52.98291778564453f));
    _2068 = 0.0f;
    do {
      if (((_2054 < (LDRPostProcessParam_009x)))) {
        int _2059 = ((uint)(uint((_2050 * _2048)))) ^ 12345391;
        uint _2060 = _2059 * 3635641;
        _2068 = ((float((uint)((int)((((uint)(_2060) >> 26) | ((uint)(_2059 * 232681024))) ^ _2060)))) * 2.3283064365386963e-10f);
      }
      float _2070 = frac((_2054 * 757.4846801757812f));
      _2084 = 0.0f;
      do {
        if (((_2070 < (LDRPostProcessParam_009x)))) {
          int _2074 = (asint(_2070)) ^ 12345391;
          uint _2075 = _2074 * 3635641;
          _2084 = (((float((uint)((int)((((uint)(_2075) >> 26) | ((uint)(_2074 * 232681024))) ^ _2075)))) * 2.3283064365386963e-10f) + -0.5f);
        }
        float _2086 = frac((_2070 * 757.4846801757812f));
        _2100 = 0.0f;
        do {
          if (((_2086 < (LDRPostProcessParam_009x)))) {
            int _2090 = (asint(_2086)) ^ 12345391;
            uint _2091 = _2090 * 3635641;
            _2100 = (((float((uint)((int)((((uint)(_2091) >> 26) | ((uint)(_2090 * 232681024))) ^ _2091)))) * 2.3283064365386963e-10f) + -0.5f);
          }
          float _2101 = _2068 * (LDRPostProcessParam_008x);
          float _2102 = _2100 * (LDRPostProcessParam_008y);
          float _2103 = _2084 * (LDRPostProcessParam_008y);
          float _2117 = (exp2(((log2((1.0f - (saturate((dot(float3((saturate(_2029)), (saturate(_2030)), (saturate(_2031))), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))))))) * (LDRPostProcessParam_009y)))) * (LDRPostProcessParam_009z);
          _2128 = ((_2117 * ((mad(_2103, 1.4019999504089355f, _2101)) - _2029)) + _2029);
          _2129 = ((_2117 * ((mad(_2103, -0.7139999866485596f, (mad(_2102, -0.3440000116825104f, _2101)))) - _2030)) + _2030);
          _2130 = ((_2117 * ((mad(_2102, 1.7719999551773071f, _2101)) - _2031)) + _2031);
        } while (false);
      } while (false);
    } while (false);
  }

  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    _2128 = _2029;
    _2129 = _2030;
    _2130 = _2031;
  }

  _2537 = _2128;
  _2538 = _2129;
  _2539 = _2130;
  if (!(((((uint)(CBControl_000w)) & 4) == 0))) {  // cPassEnabled
    // Here
    // ACES_to_ACEScc
    bool _2156 = !(_2128 <= 0.0078125f);
    do {
      if (!_2156) {
        _2165 = ((_2128 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        // Here
        _2165 = (((log2(_2128)) + 9.720000267028809f) * 0.05707762390375137f);
      }
      bool _2166 = !(_2129 <= 0.0078125f);
      do {
        if (!_2166) {
          _2175 = ((_2129 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          // Here
          _2175 = (((log2(_2129)) + 9.720000267028809f) * 0.05707762390375137f);
        }
        bool _2176 = !(_2130 <= 0.0078125f);
        do {
          if (!_2176) {
            _2185 = ((_2130 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            // Here
            _2185 = (((log2(_2130)) + 9.720000267028809f) * 0.05707762390375137f);
          }
          // x = fHalfTextureInverseSize
          // y = fOneMinusTextureInverseSize
          float4 _2194 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_2165 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2175 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2185 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x))), 0.0f);
          do {
            if ((((_2194.x) < 0.155251145362854f))) {
              _2211 = (((_2194.x) + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              // Here
              _2211 = 65504.0f;
              if ((((bool)(((_2194.x) >= 0.155251145362854f))) && ((bool)(((_2194.x) < 1.4679962396621704f))))) {
                // Here
                _2211 = (exp2((((_2194.x) * 17.520000457763672f) + -9.720000267028809f)));
              }
            }
            do {
              if ((((_2194.y) < 0.155251145362854f))) {
                _2225 = (((_2194.y) + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                // Here
                _2225 = 65504.0f;
                if ((((bool)(((_2194.y) >= 0.155251145362854f))) && ((bool)(((_2194.y) < 1.4679962396621704f))))) {
                  _2225 = (exp2((((_2194.y) * 17.520000457763672f) + -9.720000267028809f)));
                }
              }
              do {
                if ((((_2194.z) < 0.155251145362854f))) {
                  _2239 = (((_2194.z) + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  // Here
                  _2239 = 65504.0f;
                  if ((((bool)(((_2194.z) >= 0.155251145362854f))) && ((bool)(((_2194.z) < 1.4679962396621704f))))) {
                    _2239 = (exp2((((_2194.z) * 17.520000457763672f) + -9.720000267028809f)));
                  }
                }
                do {
                  [branch]
                  if ((((LDRPostProcessParam_010y) > 0.0f))) {  // fTextureBlendRate
                    // Here
                    do {
                      if (!_2156) {
                        _2250 = ((_2128 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        // Here
                        _2250 = (((log2(_2128)) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!_2166) {
                          _2259 = ((_2129 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          // Here
                          _2259 = (((log2(_2129)) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!_2176) {
                            _2268 = ((_2130 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            // Here
                            _2268 = (((log2(_2130)) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          // x = fHalfTextureInverseSize
                          // y = fOneMinusTextureInverseSize
                          float4 _2276 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_2250 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2259 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2268 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x))), 0.0f);
                          do {
                            if ((((_2276.x) < 0.155251145362854f))) {
                              _2293 = (((_2276.x) + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              // Here
                              _2293 = 65504.0f;
                              if ((((bool)(((_2276.x) >= 0.155251145362854f))) && ((bool)(((_2276.x) < 1.4679962396621704f))))) {
                                _2293 = (exp2((((_2276.x) * 17.520000457763672f) + -9.720000267028809f)));
                              }
                            }
                            do {
                              if ((((_2276.y) < 0.155251145362854f))) {
                                _2307 = (((_2276.y) + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                // Here
                                _2307 = 65504.0f;
                                if ((((bool)(((_2276.y) >= 0.155251145362854f))) && ((bool)(((_2276.y) < 1.4679962396621704f))))) {
                                  _2307 = (exp2((((_2276.y) * 17.520000457763672f) + -9.720000267028809f)));
                                }
                              }
                              do {
                                if ((((_2276.z) < 0.155251145362854f))) {
                                  _2321 = (((_2276.z) + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  // Here
                                  _2321 = 65504.0f;
                                  if ((((bool)(((_2276.z) >= 0.155251145362854f))) && ((bool)(((_2276.z) < 1.4679962396621704f))))) {
                                    _2321 = (exp2((((_2276.z) * 17.520000457763672f) + -9.720000267028809f)));
                                  }
                                }
                                // fTextureBlendRate
                                float _2328 = ((_2293 - _2211) * (LDRPostProcessParam_010y)) + _2211;
                                float _2329 = ((_2307 - _2225) * (LDRPostProcessParam_010y)) + _2225;
                                float _2330 = ((_2321 - _2239) * (LDRPostProcessParam_010y)) + _2239;
                                _2521 = _2328;
                                _2522 = _2329;
                                _2523 = _2330;
                                if ((((LDRPostProcessParam_010z) > 0.0f))) {  // fTextureBlendRate2
                                  do {
                                    if (!(!(_2328 <= 0.0078125f))) {
                                      _2342 = ((_2328 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      // Here
                                      _2342 = (((log2(_2328)) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_2329 <= 0.0078125f))) {
                                        _2352 = ((_2329 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        // Here
                                        _2352 = (((log2(_2329)) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_2330 <= 0.0078125f))) {
                                          _2362 = ((_2330 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          // Here
                                          _2362 = (((log2(_2330)) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        // x = fHalfTextureInverseSize
                                        // y = fOneMinusTextureInverseSize
                                        float4 _2370 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2342 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2352 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2362 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x))), 0.0f);
                                        do {
                                          if ((((_2370.x) < 0.155251145362854f))) {
                                            _2387 = (((_2370.x) + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            // Here
                                            _2387 = 65504.0f;
                                            if ((((bool)(((_2370.x) >= 0.155251145362854f))) && ((bool)(((_2370.x) < 1.4679962396621704f))))) {
                                              _2387 = (exp2((((_2370.x) * 17.520000457763672f) + -9.720000267028809f)));
                                            }
                                          }
                                          do {
                                            if ((((_2370.y) < 0.155251145362854f))) {
                                              _2401 = (((_2370.y) + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              // Here
                                              _2401 = 65504.0f;
                                              if ((((bool)(((_2370.y) >= 0.155251145362854f))) && ((bool)(((_2370.y) < 1.4679962396621704f))))) {
                                                _2401 = (exp2((((_2370.y) * 17.520000457763672f) + -9.720000267028809f)));
                                              }
                                            }
                                            do {
                                              if ((((_2370.z) < 0.155251145362854f))) {
                                                _2415 = (((_2370.z) + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                // Here
                                                _2415 = 65504.0f;
                                                if ((((bool)(((_2370.z) >= 0.155251145362854f))) && ((bool)(((_2370.z) < 1.4679962396621704f))))) {
                                                  _2415 = (exp2((((_2370.z) * 17.520000457763672f) + -9.720000267028809f)));
                                                }
                                              }
                                              // fTextureBlendRate2
                                              _2521 = (((_2387 - _2328) * (LDRPostProcessParam_010z)) + _2328);
                                              _2522 = (((_2401 - _2329) * (LDRPostProcessParam_010z)) + _2329);
                                              _2523 = (((_2415 - _2330) * (LDRPostProcessParam_010z)) + _2330);
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
                    // Not here
                    _2521 = _2211;
                    _2522 = _2225;
                    _2523 = _2239;
                    if ((((LDRPostProcessParam_010z) > 0.0f))) {
                      do {
                        if (!(!(_2211 <= 0.0078125f))) {
                          _2437 = ((_2211 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2437 = (((log2(_2211)) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_2225 <= 0.0078125f))) {
                            _2447 = ((_2225 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2447 = (((log2(_2225)) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_2239 <= 0.0078125f))) {
                              _2457 = ((_2239 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _2457 = (((log2(_2239)) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            float4 _2465 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2437 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2447 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x)), ((_2457 * (LDRPostProcessParam_011y)) + (LDRPostProcessParam_011x))), 0.0f);
                            do {
                              if ((((_2465.x) < 0.155251145362854f))) {
                                _2482 = (((_2465.x) + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                _2482 = 65504.0f;
                                if ((((bool)(((_2465.x) >= 0.155251145362854f))) && ((bool)(((_2465.x) < 1.4679962396621704f))))) {
                                  _2482 = (exp2((((_2465.x) * 17.520000457763672f) + -9.720000267028809f)));
                                }
                              }
                              do {
                                if ((((_2465.y) < 0.155251145362854f))) {
                                  _2496 = (((_2465.y) + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  _2496 = 65504.0f;
                                  if ((((bool)(((_2465.y) >= 0.155251145362854f))) && ((bool)(((_2465.y) < 1.4679962396621704f))))) {
                                    _2496 = (exp2((((_2465.y) * 17.520000457763672f) + -9.720000267028809f)));
                                  }
                                }
                                do {
                                  if ((((_2465.z) < 0.155251145362854f))) {
                                    _2510 = (((_2465.z) + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    _2510 = 65504.0f;
                                    if ((((bool)(((_2465.z) >= 0.155251145362854f))) && ((bool)(((_2465.z) < 1.4679962396621704f))))) {
                                      _2510 = (exp2((((_2465.z) * 17.520000457763672f) + -9.720000267028809f)));
                                    }
                                  }
                                  _2521 = (((_2482 - _2211) * (LDRPostProcessParam_010z)) + _2211);
                                  _2522 = (((_2496 - _2225) * (LDRPostProcessParam_010z)) + _2225);
                                  _2523 = (((_2510 - _2239) * (LDRPostProcessParam_010z)) + _2239);
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    }
                  }

                  // Here
                  // fColorMatrix
                  _2537 = ((mad(_2523, (LDRPostProcessParam_014x), (mad(_2522, (LDRPostProcessParam_013x), (_2521 * (LDRPostProcessParam_012x)))))) + (LDRPostProcessParam_015x));
                  _2538 = ((mad(_2523, (LDRPostProcessParam_014y), (mad(_2522, (LDRPostProcessParam_013y), (_2521 * (LDRPostProcessParam_012y)))))) + (LDRPostProcessParam_015y));
                  _2539 = ((mad(_2523, (LDRPostProcessParam_014z), (mad(_2522, (LDRPostProcessParam_013z), (_2521 * (LDRPostProcessParam_012z)))))) + (LDRPostProcessParam_015z));

                  float3 new_color = CustomLUTColor(float3(_2128, _2129, _2130), float3(_2537, _2538, _2539));
                  _2537 = new_color.r;
                  _2538 = new_color.g;
                  _2539 = new_color.b;

                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  }

  // _2537 = lerp(_2128 * 10.f, _2537, CUSTOM_LUT_COLOR_STRENGTH);
  // _2538 = lerp(_2129 * 10.f, _2538, CUSTOM_LUT_COLOR_STRENGTH);
  // _2539 = lerp(_2130 * 10.f, _2539, CUSTOM_LUT_COLOR_STRENGTH);
  bool _2542 = isfinite((max((max(_2537, _2538)), _2539)));
  float _2543 = (_2542 ? _2537 : 1.0f);
  float _2544 = (_2542 ? _2538 : 1.0f);
  float _2545 = (_2542 ? _2539 : 1.0f);
  _2580 = _2543;
  _2581 = _2544;
  _2582 = _2545;
  if (!(((((uint)(CBControl_000w)) & 8) == 0))) {  // cPassEnabled
    //
    // Not here
    // cvdR
    // cvdG
    // cvdB
    _2580 = (saturate(((((LDRPostProcessParam_016x)*_2543) + ((LDRPostProcessParam_016y)*_2544)) + ((LDRPostProcessParam_016z)*_2545))));
    _2581 = (saturate(((((LDRPostProcessParam_017x)*_2543) + ((LDRPostProcessParam_017y)*_2544)) + ((LDRPostProcessParam_017z)*_2545))));
    _2582 = (saturate(((((LDRPostProcessParam_018x)*_2543) + ((LDRPostProcessParam_018y)*_2544)) + ((LDRPostProcessParam_018z)*_2545))));
  }
  _2663 = _2580;
  _2664 = _2581;
  _2665 = _2582;
  if (!(((((uint)(CBControl_000w)) & 16) == 0))) {  // cPassEnabled
    // Not here
    // ColorParam

    float _2597 = (SceneInfo_023z) * (SV_Position.x);
    float _2598 = (SceneInfo_023w) * (SV_Position.y);
    float4 _2601 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2597, _2598), 0.0f);
    float _2606 = (_2601.x) * (LDRPostProcessParam_019x);
    float _2607 = (_2601.y) * (LDRPostProcessParam_019y);
    float _2608 = (_2601.z) * (LDRPostProcessParam_019z);
    // Levels_Rate + Levels_Range
    float _2616 = ((_2601.w) * (LDRPostProcessParam_019w)) * (saturate(((((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2597, _2598), 0.0f)).x) * (LDRPostProcessParam_020x)) + (LDRPostProcessParam_020y))));
    do {
      if (((_2606 < 0.5f))) {
        _2628 = ((_2580 * 2.0f) * _2606);
      } else {
        _2628 = (1.0f - (((1.0f - _2580) * 2.0f) * (1.0f - _2606)));
      }
      do {
        if (((_2607 < 0.5f))) {
          _2640 = ((_2581 * 2.0f) * _2607);
        } else {
          _2640 = (1.0f - (((1.0f - _2581) * 2.0f) * (1.0f - _2607)));
        }
        do {
          if (((_2608 < 0.5f))) {
            _2652 = ((_2582 * 2.0f) * _2608);
          } else {
            _2652 = (1.0f - (((1.0f - _2582) * 2.0f) * (1.0f - _2608)));
          }
          _2663 = (((_2628 - _2580) * _2616) + _2580);
          _2664 = (((_2640 - _2581) * _2616) + _2581);
          _2665 = (((_2652 - _2582) * _2616) + _2582);
        } while (false);
      } while (false);
    } while (false);
  }
  _2770 = _2663;
  _2771 = _2664;
  _2772 = _2665;

  if ((((TonemapParam_002w) == 0.0f))) {  // tonemapParam_isHDRMode
    // Not here
    // I guess this is their inverse tonemapper?
    // invLinearBegin
    float _2673 = (TonemapParam_002y)*_2663;
    _2681 = 1.0f;
    do {
      // linearBegin
      if ((!(_2663 >= (TonemapParam_000y)))) {
        _2681 = ((_2673 * _2673) * (3.0f - (_2673 * 2.0f)));
      }
      // invLinearBegin
      float _2682 = (TonemapParam_002y)*_2664;
      _2690 = 1.0f;
      do {
        if ((!(_2664 >= (TonemapParam_000y)))) {
          _2690 = ((_2682 * _2682) * (3.0f - (_2682 * 2.0f)));
        }
        float _2691 = (TonemapParam_002y)*_2665;
        _2699 = 1.0f;
        do {
          if ((!(_2665 >= (TonemapParam_000y)))) {
            _2699 = ((_2691 * _2691) * (3.0f - (_2691 * 2.0f)));
          }
          // linearStart
          float _2708 = (((bool)((_2663 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          float _2709 = (((bool)((_2664 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          float _2710 = (((bool)((_2665 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          // contrast + madLinearStartContrastFactor + toe (and max nits and other stuff)
          _2770 = ((((((TonemapParam_000x)*_2663) + (TonemapParam_002z)) * (_2681 - _2708)) + (((exp2(((log2(_2673)) * (TonemapParam_000w)))) * (1.0f - _2681)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*_2663) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _2708));
          _2771 = ((((((TonemapParam_000x)*_2664) + (TonemapParam_002z)) * (_2690 - _2709)) + (((exp2(((log2(_2682)) * (TonemapParam_000w)))) * (1.0f - _2690)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*_2664) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _2709));
          _2772 = ((((((TonemapParam_000x)*_2665) + (TonemapParam_002z)) * (_2699 - _2710)) + (((exp2(((log2(_2691)) * (TonemapParam_000w)))) * (1.0f - _2699)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*_2665) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _2710));
        } while (false);
      } while (false);
    } while (false);
  }
  SV_Target.x = _2770;
  SV_Target.y = _2771;
  SV_Target.z = _2772;
  SV_Target.w = 0.0f;
  return SV_Target;
}
