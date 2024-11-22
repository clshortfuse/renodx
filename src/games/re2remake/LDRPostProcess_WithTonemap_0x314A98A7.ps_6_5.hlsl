#include "./shared.h"
#include "./LUTBlackCorrection.hlsl"

// Buffer Definitions:

// cbuffer SceneInfo
// {

//   struct dx.alignment.legacy.SceneInfo
//   {

//       row_major float4x4 viewProjMat;               ; Offset:    0
//       row_major float3x4 transposeViewMat;          ; Offset:   64
//       row_major float3x4 transposeViewInvMat;       ; Offset:  112
//       float4 projElement[2];                        ; Offset:  160
//       float4 projInvElements[2];                    ; Offset:  192
//       row_major float4x4 viewProjInvMat;            ; Offset:  224
//       row_major float4x4 prevViewProjMat;           ; Offset:  288
//       float3 ZToLinear;                             ; Offset:  352
//       float subdivisionLevel;                       ; Offset:  364
//       float2 screenSize;                            ; Offset:  368
//       float2 screenInverseSize;                     ; Offset:  376
//       float2 cullingHelper;                         ; Offset:  384
//       float cameraNearPlane;                        ; Offset:  392
//       float cameraFarPlane;                         ; Offset:  396
//       float4 viewFrustum[6];                        ; Offset:  400
//       float4 clipplane;                             ; Offset:  496
//       float2 vrsVelocityThreshold;                  ; Offset:  512
//       uint renderOutputId;                          ; Offset:  520
//       uint SceneInfo_Reserve;                       ; Offset:  524
   
//   } SceneInfo;                                      ; Offset:    0 Size:   528

// }

// cbuffer CameraKerare
// {

//   struct CameraKerare
//   {

//       float kerare_scale;                           ; Offset:    0
//       float kerare_offset;                          ; Offset:    4
//       float kerare_brightness;                      ; Offset:    8
   
//   } CameraKerare;                                   ; Offset:    0 Size:    12

// }

// cbuffer TonemapParam
// {

//   struct TonemapParam
//   {

//       float contrast;                               ; Offset:    0
//       float linearBegin;                            ; Offset:    4
//       float linearLength;                           ; Offset:    8
//       float toe;                                    ; Offset:   12
//       float maxNit;                                 ; Offset:   16
//       float linearStart;                            ; Offset:   20
//       float displayMaxNitSubContrastFactor;         ; Offset:   24
//       float contrastFactor;                         ; Offset:   28
//       float mulLinearStartContrastFactor;           ; Offset:   32
//       float invLinearBegin;                         ; Offset:   36
//       float madLinearStartContrastFactor;           ; Offset:   40
   
//   } TonemapParam;                                   ; Offset:    0 Size:    44

// }

// cbuffer LensDistortionParam
// {

//   struct LensDistortionParam
//   {

//       float fDistortionCoef;                        ; Offset:    0
//       float fRefraction;                            ; Offset:    4
//       uint aberrationEnable;                        ; Offset:    8
//       uint distortionType;                          ; Offset:   12
//       float fCorrectCoef;                           ; Offset:   16
//       uint reserve1;                                ; Offset:   20
//       uint reserve2;                                ; Offset:   24
//       uint reserve3;                                ; Offset:   28
   
//   } LensDistortionParam;                            ; Offset:    0 Size:    32

// }

// cbuffer PaniniProjectionParam
// {

//   struct PaniniProjectionParam
//   {

//       float4 fOptimizedParam;                       ; Offset:    0
   
//   } PaniniProjectionParam;                          ; Offset:    0 Size:    16

// }

// cbuffer RadialBlurRenderParam
// {

//   struct RadialBlurRenderParam
//   {

//       float4 cbRadialColor;                         ; Offset:    0
//       float2 cbRadialScreenPos;                     ; Offset:   16
//       float2 cbRadialMaskSmoothstep;                ; Offset:   24
//       float2 cbRadialMaskRate;                      ; Offset:   32
//       float cbRadialBlurPower;                      ; Offset:   40
//       float cbRadialSharpRange;                     ; Offset:   44
//       uint cbRadialBlurFlags;                       ; Offset:   48
//       float cbRadialReserve0;                       ; Offset:   52
//       float cbRadialReserve1;                       ; Offset:   56
//       float cbRadialReserve2;                       ; Offset:   60
   
//   } RadialBlurRenderParam;                          ; Offset:    0 Size:    64

// }

// cbuffer FilmGrainParam
// {

//   struct FilmGrainParam
//   {

//       float2 fNoisePower;                           ; Offset:    0
//       float2 fNoiseUVOffset;                        ; Offset:    8
//       float fNoiseDensity;                          ; Offset:   16
//       float fNoiseContrast;                         ; Offset:   20
//       float fBlendRate;                             ; Offset:   24
//       float fReverseNoiseSize;                      ; Offset:   28
   
//   } FilmGrainParam;                                 ; Offset:    0 Size:    32

// }

// cbuffer ColorCorrectTexture
// {

//   struct dx.alignment.legacy.ColorCorrectTexture
//   {

//       float fTextureSize;                           ; Offset:    0
//       float fTextureBlendRate;                      ; Offset:    4
//       float fTextureBlendRate2;                     ; Offset:    8
//       float fTextureInverseSize;                    ; Offset:   12
//       row_major float4x4 fColorMatrix;              ; Offset:   16
  
//   } ColorCorrectTexture;                            ; Offset:    0 Size:    80

// }

// cbuffer ColorDeficientTable
// {

//   struct ColorDeficientTable
//   {

//       float4 cvdR;                                  ; Offset:    0
//       float4 cvdG;                                  ; Offset:   16
//       float4 cvdB;                                  ; Offset:   32
   
//   } ColorDeficientTable;                            ; Offset:    0 Size:    48

// }

// cbuffer ImagePlaneParam
// {

//   struct ImagePlaneParam
//   {

//       float4 ColorParam;                            ; Offset:    0
//       float Levels_Rate;                            ; Offset:   16
//       float Levels_Range;                           ; Offset:   20
//       uint Blend_Type;                              ; Offset:   24
   
//   } ImagePlaneParam;                                ; Offset:    0 Size:    28

// }

// cbuffer CBControl
// {

//   struct CBControl
//   {

//       uint cPassEnabled;                            ; Offset:    0
   
//   } CBControl;                                      ; Offset:    0 Size:     4

// }

// Resource bind info for ComputeResultSRV
// {

//   struct struct.RadialBlurComputeResult
//   {

//       float computeAlpha;                           ; Offset:    0
   
//   } $Element;                                       ; Offset:    0 Size:     4

// }


// Resource Bindings:

// Name                                 Type  Format         Dim      ID      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- ------- -------------- ------
// SceneInfo                         cbuffer      NA          NA     CB0            cb0     1
// CameraKerare                      cbuffer      NA          NA     CB1            cb1     1
// TonemapParam                      cbuffer      NA          NA     CB2            cb2     1
// LensDistortionParam               cbuffer      NA          NA     CB3            cb3     1
// PaniniProjectionParam             cbuffer      NA          NA     CB4            cb4     1
// RadialBlurRenderParam             cbuffer      NA          NA     CB5            cb5     1
// FilmGrainParam                    cbuffer      NA          NA     CB6            cb6     1
// ColorCorrectTexture               cbuffer      NA          NA     CB7            cb7     1
// ColorDeficientTable               cbuffer      NA          NA     CB8            cb8     1
// ImagePlaneParam                   cbuffer      NA          NA     CB9            cb9     1
// CBControl                         cbuffer      NA          NA    CB10           cb10     1
// BilinearClamp                     sampler      NA          NA      S0     s5,space32     1
// BilinearBorder                    sampler      NA          NA      S1     s6,space32     1
// TrilinearClamp                    sampler      NA          NA      S2     s9,space32     1
// RE_POSTPROCESS_Color              texture     f32          2d      T0             t0     1
// ComputeResultSRV                  texture  struct         r/o      T1             t1     1
// tTextureMap0                      texture     f32          3d      T2             t2     1
// tTextureMap1                      texture     f32          3d      T3             t3     1
// tTextureMap2                      texture     f32          3d      T4             t4     1
// ImagePlameBase                    texture     f32          2d      T5             t5     1
// ImagePlameAlpha                   texture     f32          2d      T6             t6     1


Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

struct _ComputeResultSRV {
  float data[1];
};
StructuredBuffer<_ComputeResultSRV> ComputeResultSRV : register(t1);

Texture3D<float4> tTextureMap0 : register(t2);

Texture3D<float4> tTextureMap1 : register(t3);

Texture3D<float4> tTextureMap2 : register(t4);

Texture2D<float4> ImagePlameBase : register(t5);

Texture2D<float> ImagePlameAlpha : register(t6);

cbuffer SceneInfo : register(b0) {
  float SceneInfo_023x : packoffset(c023.x);
  float SceneInfo_023y : packoffset(c023.y);
  float SceneInfo_023z : packoffset(c023.z);
  float SceneInfo_023w : packoffset(c023.w);
};

cbuffer CameraKerare : register(b1) {
  float CameraKerare_000x : packoffset(c000.x);
  float CameraKerare_000y : packoffset(c000.y);
  float CameraKerare_000z : packoffset(c000.z);
};

//   struct TonemapParam
//   {

//       float contrast;                               ; Offset:    0
//       float linearBegin;                            ; Offset:    4
//       float linearLength;                           ; Offset:    8
//       float toe;                                    ; Offset:   12
//       float maxNit;                                 ; Offset:   16
//       float linearStart;                            ; Offset:   20
//       float displayMaxNitSubContrastFactor;         ; Offset:   24
//       float contrastFactor;                         ; Offset:   28
//       float mulLinearStartContrastFactor;           ; Offset:   32
//       float invLinearBegin;                         ; Offset:   36
//       float madLinearStartContrastFactor;           ; Offset:   40

//   } TonemapParam;                                   ; Offset:    0 Size:    44
cbuffer TonemapParam : register(b2) {
  float TonemapParam_000x : packoffset(c000.x);
  float TonemapParam_000y : packoffset(c000.y);
  float TonemapParam_000w : packoffset(c000.w);
  float maxNit : packoffset(c001.x);  // float maxNit
  float TonemapParam_001y : packoffset(c001.y);
  float TonemapParam_001z : packoffset(c001.z);
  float TonemapParam_001w : packoffset(c001.w);
  float TonemapParam_002x : packoffset(c002.x);
  float TonemapParam_002y : packoffset(c002.y);
  float TonemapParam_002z : packoffset(c002.z);
};

cbuffer LensDistortionParam : register(b3) {
  float LensDistortionParam_000x : packoffset(c000.x);
  float LensDistortionParam_000y : packoffset(c000.y);
  uint LensDistortionParam_000z : packoffset(c000.z);
  uint LensDistortionParam_000w : packoffset(c000.w);
  float LensDistortionParam_001x : packoffset(c001.x);
};

cbuffer PaniniProjectionParam : register(b4) {
  float PaniniProjectionParam_000x : packoffset(c000.x);
  float PaniniProjectionParam_000y : packoffset(c000.y);
  float PaniniProjectionParam_000z : packoffset(c000.z);
  float PaniniProjectionParam_000w : packoffset(c000.w);
};

cbuffer RadialBlurRenderParam : register(b5) {
  float RadialBlurRenderParam_000x : packoffset(c000.x);
  float RadialBlurRenderParam_000y : packoffset(c000.y);
  float RadialBlurRenderParam_000z : packoffset(c000.z);
  float RadialBlurRenderParam_000w : packoffset(c000.w);
  float RadialBlurRenderParam_001x : packoffset(c001.x);
  float RadialBlurRenderParam_001y : packoffset(c001.y);
  float RadialBlurRenderParam_001z : packoffset(c001.z);
  float RadialBlurRenderParam_001w : packoffset(c001.w);
  float RadialBlurRenderParam_002x : packoffset(c002.x);
  float RadialBlurRenderParam_002y : packoffset(c002.y);
  float RadialBlurRenderParam_002z : packoffset(c002.z);
  float RadialBlurRenderParam_002w : packoffset(c002.w);
  uint RadialBlurRenderParam_003x : packoffset(c003.x);
};

cbuffer FilmGrainParam : register(b6) {
  float FilmGrainParam_000x : packoffset(c000.x);
  float FilmGrainParam_000y : packoffset(c000.y);
  float FilmGrainParam_000z : packoffset(c000.z);
  float FilmGrainParam_000w : packoffset(c000.w);
  float FilmGrainParam_001x : packoffset(c001.x);
  float FilmGrainParam_001y : packoffset(c001.y);
  float FilmGrainParam_001z : packoffset(c001.z);
  float FilmGrainParam_001w : packoffset(c001.w);
};

cbuffer ColorCorrectTexture : register(b7) {
  float ColorCorrectTexture_000y : packoffset(c000.y);
  float ColorCorrectTexture_000z : packoffset(c000.z);
  float ColorCorrectTexture_000w : packoffset(c000.w);
  float ColorCorrectTexture_001x : packoffset(c001.x);
  float ColorCorrectTexture_001y : packoffset(c001.y);
  float ColorCorrectTexture_001z : packoffset(c001.z);
  float ColorCorrectTexture_002x : packoffset(c002.x);
  float ColorCorrectTexture_002y : packoffset(c002.y);
  float ColorCorrectTexture_002z : packoffset(c002.z);
  float ColorCorrectTexture_003x : packoffset(c003.x);
  float ColorCorrectTexture_003y : packoffset(c003.y);
  float ColorCorrectTexture_003z : packoffset(c003.z);
  float ColorCorrectTexture_004x : packoffset(c004.x);
  float ColorCorrectTexture_004y : packoffset(c004.y);
  float ColorCorrectTexture_004z : packoffset(c004.z);
};

cbuffer ColorDeficientTable : register(b8) {
  float ColorDeficientTable_000x : packoffset(c000.x);
  float ColorDeficientTable_000y : packoffset(c000.y);
  float ColorDeficientTable_000z : packoffset(c000.z);
  float ColorDeficientTable_001x : packoffset(c001.x);
  float ColorDeficientTable_001y : packoffset(c001.y);
  float ColorDeficientTable_001z : packoffset(c001.z);
  float ColorDeficientTable_002x : packoffset(c002.x);
  float ColorDeficientTable_002y : packoffset(c002.y);
  float ColorDeficientTable_002z : packoffset(c002.z);
};

cbuffer ImagePlaneParam : register(b9) {
  float ImagePlaneParam_000x : packoffset(c000.x);
  float ImagePlaneParam_000y : packoffset(c000.y);
  float ImagePlaneParam_000z : packoffset(c000.z);
  float ImagePlaneParam_000w : packoffset(c000.w);
  float ImagePlaneParam_001x : packoffset(c001.x);
  float ImagePlaneParam_001y : packoffset(c001.y);
};

cbuffer CBControl : register(b10) {
  uint CBControl_000x : packoffset(c000.x);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure
) : SV_Target {
  float TonemapParam_001x = maxNit;


  // custom code
  // declare lut config for use with lut black correction
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      TrilinearClamp,
      1.f,
      1.f,
      renodx::lut::config::type::SRGB,
      renodx::lut::config::type::LINEAR,
      1 / ColorCorrectTexture_000w);

  float4 SV_Target;
  // texture _1 = ImagePlameAlpha;
  // texture _2 = ImagePlameBase;
  // texture _3 = tTextureMap2;
  // texture _4 = tTextureMap1;
  // texture _5 = tTextureMap0;
  // texture _6 = ComputeResultSRV;
  // texture _7 = RE_POSTPROCESS_Color;
  // SamplerState _8 = TrilinearClamp;
  // SamplerState _9 = BilinearBorder;
  // SamplerState _10 = BilinearClamp;
  // cbuffer _11 = CBControl;
  // cbuffer _12 = ImagePlaneParam;
  // cbuffer _13 = ColorDeficientTable;
  // cbuffer _14 = ColorCorrectTexture;
  // cbuffer _15 = FilmGrainParam;
  // cbuffer _16 = RadialBlurRenderParam;
  // cbuffer _17 = PaniniProjectionParam;
  // cbuffer _18 = LensDistortionParam;
  // cbuffer _19 = TonemapParam;
  // cbuffer _20 = CameraKerare;
  // cbuffer _21 = SceneInfo;
  float _22 = Exposure;
  float _23 = Kerare.x;
  float _24 = Kerare.y;
  float _25 = Kerare.z;
  float _26 = Kerare.w;
  float _27 = SV_Position.x;
  float _28 = SV_Position.y;
  uint _30 = CBControl_000x;
  int _31 = _30 & 1;
  bool _32 = (_31 != 0);
  uint _34 = LensDistortionParam_000w;
  bool _35 = (_34 == 0);
  bool _36 = _32 && _35;
  bool _37 = (_34 == 1);
  bool _38 = _32 && _37;
  float _40 = CameraKerare_000z;
  float _41 = _23 / _26;
  float _42 = _24 / _26;
  float _43 = _25 / _26;
  float _44 = dot(float3(_41, _42, _43), float3(_41, _42, _43));
  float _45 = rsqrt(_44);
  float _46 = _45 * _43;
  float _47 = abs(_46);
  float _48 = CameraKerare_000x;
  float _49 = _48 * _47;
  float _50 = CameraKerare_000y;
  float _51 = _49 + _50;
  float _52 = saturate(_51);
  float _53 = 1.0f - _52;
  float _54 = _47 * _47;
  float _55 = _54 * _54;
  float _56 = _55 * _53;
  float _57 = _56 + _40;
  float _58 = saturate(_57);
  float _59 = _58 * _22;
  float _61 = TonemapParam_000y;
  float _63 = TonemapParam_002y;
  float _65 = TonemapParam_001y;
  float _66 = TonemapParam_000w;
  float _67 = TonemapParam_000x;
  float _68 = TonemapParam_002z;
  float _69 = TonemapParam_001x;
  float _70 = TonemapParam_001z;
  float _71 = TonemapParam_001w;
  float _72 = TonemapParam_002x;
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
    float _75 = LensDistortionParam_000x;
    float _76 = LensDistortionParam_000y;
    uint _77 = LensDistortionParam_000z;
    float _79 = LensDistortionParam_001x;
    float _81 = SceneInfo_023z;
    float _82 = SceneInfo_023w;
    float _83 = _81 * _27;
    float _84 = _82 * _28;
    float _85 = _83 + -0.5f;
    float _86 = _84 + -0.5f;
    float _87 = dot(float2(_85, _86), float2(_85, _86));
    float _88 = _87 * _75;
    float _89 = _88 + 1.0f;
    float _90 = _89 * _79;
    float _91 = _90 * _85;
    float _92 = _90 * _86;
    float _93 = _91 + 0.5f;
    float _94 = _92 + 0.5f;
    bool _95 = (_77 == 0);
    float4 _96 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_93, _94));
    float _97 = _96.x;
    float _98 = _97 * _59;
    float _99 = _63 * _98;
    bool _100 = (_98 >= _61);
    float _101 = _99 * _99;
    float _102 = _99 * 2.0f;
    float _103 = 3.0f - _102;
    float _104 = _101 * _103;
    float _105 = 1.0f - _104;
    float _106 = _100 ? 0.0f : _105;
    bool _107 = (_98 < _65);
    float _108 = _107 ? 0.0f : 1.0f;
    float _109 = 1.0f - _108;
    float _110 = _109 - _106;
    float _111 = log2(_99);
    float _112 = _111 * _66;
    float _113 = exp2(_112);
    float _114 = _67 * _98;
    float _115 = _114 + _68;
    float _116 = _115 * _110;
    float _117 = _71 * _98;
    float _118 = _117 + _72;
    float _119 = exp2(_118);
    float _120 = _119 * _70;
    float _121 = _69 - _120;
    float _122 = _121 * _108;
    if (_95) {
      float _124 = _96.y;
      float _125 = _96.z;
      float _126 = _124 * _59;
      float _127 = _125 * _59;
      float _128 = _63 * _126;
      bool _129 = (_126 >= _61);
      float _130 = _128 * _128;
      float _131 = _128 * 2.0f;
      float _132 = 3.0f - _131;
      float _133 = _130 * _132;
      float _134 = _63 * _127;
      bool _135 = (_127 >= _61);
      float _136 = _134 * _134;
      float _137 = _134 * 2.0f;
      float _138 = 3.0f - _137;
      float _139 = _136 * _138;
      float _140 = 1.0f - _133;
      float _141 = _129 ? 0.0f : _140;
      float _142 = 1.0f - _139;
      float _143 = _135 ? 0.0f : _142;
      bool _144 = (_126 < _65);
      bool _145 = (_127 < _65);
      float _146 = _144 ? 0.0f : 1.0f;
      float _147 = _145 ? 0.0f : 1.0f;
      float _148 = 1.0f - _146;
      float _149 = _148 - _141;
      float _150 = 1.0f - _147;
      float _151 = _150 - _143;
      float _152 = log2(_128);
      float _153 = log2(_134);
      float _154 = _152 * _66;
      float _155 = _153 * _66;
      float _156 = exp2(_154);
      float _157 = exp2(_155);
      float _158 = _113 * _106;
      float _159 = _158 * _61;
      float _160 = _156 * _141;
      float _161 = _160 * _61;
      float _162 = _157 * _143;
      float _163 = _162 * _61;
      float _164 = _67 * _126;
      float _165 = _67 * _127;
      float _166 = _164 + _68;
      float _167 = _165 + _68;
      float _168 = _166 * _149;
      float _169 = _167 * _151;
      float _170 = _116 + _159;
      float _171 = _168 + _161;
      float _172 = _169 + _163;
      float _173 = _71 * _126;
      float _174 = _71 * _127;
      float _175 = _173 + _72;
      float _176 = _174 + _72;
      float _177 = exp2(_175);
      float _178 = exp2(_176);
      float _179 = _177 * _70;
      float _180 = _178 * _70;
      float _181 = _69 - _179;
      float _182 = _69 - _180;
      float _183 = _181 * _146;
      float _184 = _182 * _147;
      float _185 = _170 + _122;
      float _186 = _171 + _183;
      float _187 = _172 + _184;
      _491 = _185;
      _492 = _186;
      _493 = _187;
      _494 = _75;
      _495 = 0.0f;
      _496 = 0.0f;
      _497 = 0.0f;
      _498 = 0.0f;
      _499 = _79;
    } else {
      float _189 = _87 + _76;
      float _190 = _189 * _75;
      float _191 = _190 + 1.0f;
      float _192 = _85 * _79;
      float _193 = _192 * _191;
      float _194 = _86 * _79;
      float _195 = _194 * _191;
      float _196 = _193 + 0.5f;
      float _197 = _195 + 0.5f;
      float _198 = _189 + _76;
      float _199 = _198 * _75;
      float _200 = _199 + 1.0f;
      float _201 = _192 * _200;
      float _202 = _194 * _200;
      float _203 = _201 + 0.5f;
      float _204 = _202 + 0.5f;
      float _205 = _61 * _113;
      float _206 = _205 * _106;
      float _207 = _116 + _206;
      float _208 = _207 + _122;
      float4 _209 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_196, _197));
      float _210 = _209.y;
      float _211 = _210 * _59;
      float _212 = _63 * _211;
      bool _213 = (_211 >= _61);
      float _214 = _212 * _212;
      float _215 = _212 * 2.0f;
      float _216 = 3.0f - _215;
      float _217 = _214 * _216;
      float _218 = 1.0f - _217;
      float _219 = _213 ? 0.0f : _218;
      bool _220 = (_211 < _65);
      float _221 = _220 ? 0.0f : 1.0f;
      float _222 = 1.0f - _221;
      float _223 = _222 - _219;
      float _224 = log2(_212);
      float _225 = _224 * _66;
      float _226 = exp2(_225);
      float _227 = _61 * _226;
      float _228 = _227 * _219;
      float _229 = _67 * _211;
      float _230 = _229 + _68;
      float _231 = _230 * _223;
      float _232 = _231 + _228;
      float _233 = _71 * _211;
      float _234 = _233 + _72;
      float _235 = exp2(_234);
      float _236 = _235 * _70;
      float _237 = _69 - _236;
      float _238 = _237 * _221;
      float _239 = _232 + _238;
      float4 _240 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_203, _204));
      float _241 = _240.z;
      float _242 = _241 * _59;
      float _243 = _63 * _242;
      bool _244 = (_242 >= _61);
      float _245 = _243 * _243;
      float _246 = _243 * 2.0f;
      float _247 = 3.0f - _246;
      float _248 = _245 * _247;
      float _249 = 1.0f - _248;
      float _250 = _244 ? 0.0f : _249;
      bool _251 = (_242 < _65);
      float _252 = _251 ? 0.0f : 1.0f;
      float _253 = 1.0f - _252;
      float _254 = _253 - _250;
      float _255 = log2(_243);
      float _256 = _255 * _66;
      float _257 = exp2(_256);
      float _258 = _61 * _257;
      float _259 = _258 * _250;
      float _260 = _67 * _242;
      float _261 = _260 + _68;
      float _262 = _261 * _254;
      float _263 = _262 + _259;
      float _264 = _71 * _242;
      float _265 = _264 + _72;
      float _266 = exp2(_265);
      float _267 = _266 * _70;
      float _268 = _69 - _267;
      float _269 = _268 * _252;
      float _270 = _263 + _269;
      _491 = _208;
      _492 = _239;
      _493 = _270;
      _494 = _75;
      _495 = 0.0f;
      _496 = 0.0f;
      _497 = 0.0f;
      _498 = 0.0f;
      _499 = _79;
    }
  } else {
    if (_38) {
      float _274 = PaniniProjectionParam_000x;
      float _275 = PaniniProjectionParam_000y;
      float _276 = PaniniProjectionParam_000z;
      float _277 = PaniniProjectionParam_000w;
      float _279 = SceneInfo_023z;
      float _280 = SceneInfo_023w;
      float _281 = _27 * 2.0f;
      float _282 = _281 * _279;
      float _283 = _28 * 2.0f;
      float _284 = _283 * _280;
      float _285 = _282 + -1.0f;
      float _286 = _284 + -1.0f;
      float _287 = _285 * _285;
      float _288 = _287 + 1.0f;
      float _289 = sqrt(_288);
      float _290 = 1.0f / _289;
      float _291 = _290 + _274;
      float _292 = _289 * _276;
      float _293 = _292 * _291;
      float _294 = _290 + -1.0f;
      float _295 = _294 * _275;
      float _296 = _295 + 1.0f;
      float _297 = _277 * 0.5f;
      float _298 = _297 * _285;
      float _299 = _298 * _293;
      float _300 = _297 * _286;
      float _301 = _300 * _296;
      float _302 = _301 * _293;
      float _303 = _299 + 0.5f;
      float _304 = _302 + 0.5f;
      float4 _305 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_303, _304));
      float _306 = _305.x;
      float _307 = _305.y;
      float _308 = _305.z;
      float _309 = _306 * _59;
      float _310 = _307 * _59;
      float _311 = _308 * _59;
      float _312 = _63 * _309;
      bool _313 = (_309 >= _61);
      float _314 = _312 * _312;
      float _315 = _312 * 2.0f;
      float _316 = 3.0f - _315;
      float _317 = _314 * _316;
      float _318 = _63 * _310;
      bool _319 = (_310 >= _61);
      float _320 = _318 * _318;
      float _321 = _318 * 2.0f;
      float _322 = 3.0f - _321;
      float _323 = _320 * _322;
      float _324 = _63 * _311;
      bool _325 = (_311 >= _61);
      float _326 = _324 * _324;
      float _327 = _324 * 2.0f;
      float _328 = 3.0f - _327;
      float _329 = _326 * _328;
      float _330 = 1.0f - _317;
      float _331 = _313 ? 0.0f : _330;
      float _332 = 1.0f - _323;
      float _333 = _319 ? 0.0f : _332;
      float _334 = 1.0f - _329;
      float _335 = _325 ? 0.0f : _334;
      bool _336 = (_309 < _65);
      bool _337 = (_310 < _65);
      bool _338 = (_311 < _65);
      float _339 = _336 ? 0.0f : 1.0f;
      float _340 = _337 ? 0.0f : 1.0f;
      float _341 = _338 ? 0.0f : 1.0f;
      float _342 = 1.0f - _339;
      float _343 = _342 - _331;
      float _344 = 1.0f - _340;
      float _345 = _344 - _333;
      float _346 = 1.0f - _341;
      float _347 = _346 - _335;
      float _348 = log2(_312);
      float _349 = log2(_318);
      float _350 = log2(_324);
      float _351 = _348 * _66;
      float _352 = _349 * _66;
      float _353 = _350 * _66;
      float _354 = exp2(_351);
      float _355 = exp2(_352);
      float _356 = exp2(_353);
      float _357 = _354 * _331;
      float _358 = _357 * _61;
      float _359 = _355 * _333;
      float _360 = _359 * _61;
      float _361 = _356 * _335;
      float _362 = _361 * _61;
      float _363 = _67 * _309;
      float _364 = _67 * _310;
      float _365 = _67 * _311;
      float _366 = _363 + _68;
      float _367 = _364 + _68;
      float _368 = _365 + _68;
      float _369 = _366 * _343;
      float _370 = _367 * _345;
      float _371 = _368 * _347;
      float _372 = _369 + _358;
      float _373 = _370 + _360;
      float _374 = _371 + _362;
      float _375 = _71 * _309;
      float _376 = _71 * _310;
      float _377 = _71 * _311;
      float _378 = _375 + _72;
      float _379 = _376 + _72;
      float _380 = _377 + _72;
      float _381 = exp2(_378);
      float _382 = exp2(_379);
      float _383 = exp2(_380);
      float _384 = _381 * _70;
      float _385 = _382 * _70;
      float _386 = _383 * _70;
      float _387 = _69 - _384;
      float _388 = _69 - _385;
      float _389 = _69 - _386;
      float _390 = _387 * _339;
      float _391 = _388 * _340;
      float _392 = _389 * _341;
      float _393 = _372 + _390;
      float _394 = _373 + _391;
      float _395 = _374 + _392;
      _491 = _393;
      _492 = _394;
      _493 = _395;
      _494 = 0.0f;
      _495 = _274;
      _496 = _275;
      _497 = _276;
      _498 = _277;
      _499 = 1.0f;
    } else {
      uint _397 = uint(_27);
      uint _398 = uint(_28);
      float4 _399 = RE_POSTPROCESS_Color.Load(int3(_397, _398, 0));
      float _400 = _399.x;
      float _401 = _399.y;
      float _402 = _399.z;
      float _403 = _400 * _59;
      float _404 = _401 * _59;
      float _405 = _402 * _59;
      float _406 = _63 * _403;
      bool _407 = (_403 >= _61);
      float _408 = _406 * _406;
      float _409 = _406 * 2.0f;
      float _410 = 3.0f - _409;
      float _411 = _408 * _410;
      float _412 = _63 * _404;
      bool _413 = (_404 >= _61);
      float _414 = _412 * _412;
      float _415 = _412 * 2.0f;
      float _416 = 3.0f - _415;
      float _417 = _414 * _416;
      float _418 = _63 * _405;
      bool _419 = (_405 >= _61);
      float _420 = _418 * _418;
      float _421 = _418 * 2.0f;
      float _422 = 3.0f - _421;
      float _423 = _420 * _422;
      float _424 = 1.0f - _411;
      float _425 = _407 ? 0.0f : _424;
      float _426 = 1.0f - _417;
      float _427 = _413 ? 0.0f : _426;
      float _428 = 1.0f - _423;
      float _429 = _419 ? 0.0f : _428;
      bool _430 = (_403 < _65);
      bool _431 = (_404 < _65);
      bool _432 = (_405 < _65);
      float _433 = _430 ? 0.0f : 1.0f;
      float _434 = _431 ? 0.0f : 1.0f;
      float _435 = _432 ? 0.0f : 1.0f;
      float _436 = 1.0f - _433;
      float _437 = _436 - _425;
      float _438 = 1.0f - _434;
      float _439 = _438 - _427;
      float _440 = 1.0f - _435;
      float _441 = _440 - _429;
      float _442 = log2(_406);
      float _443 = log2(_412);
      float _444 = log2(_418);
      float _445 = _442 * _66;
      float _446 = _443 * _66;
      float _447 = _444 * _66;
      float _448 = exp2(_445);
      float _449 = exp2(_446);
      float _450 = exp2(_447);
      float _451 = _448 * _425;
      float _452 = _451 * _61;
      float _453 = _449 * _427;
      float _454 = _453 * _61;
      float _455 = _450 * _429;
      float _456 = _455 * _61;
      float _457 = _67 * _403;
      float _458 = _67 * _404;
      float _459 = _67 * _405;
      float _460 = _457 + _68;
      float _461 = _458 + _68;
      float _462 = _459 + _68;
      float _463 = _460 * _437;
      float _464 = _461 * _439;
      float _465 = _462 * _441;
      float _466 = _463 + _452;
      float _467 = _464 + _454;
      float _468 = _465 + _456;
      float _469 = _71 * _403;
      float _470 = _71 * _404;
      float _471 = _71 * _405;
      float _472 = _469 + _72;
      float _473 = _470 + _72;
      float _474 = _471 + _72;
      float _475 = exp2(_472);
      float _476 = exp2(_473);
      float _477 = exp2(_474);
      float _478 = _475 * _70;
      float _479 = _476 * _70;
      float _480 = _477 * _70;
      float _481 = _69 - _478;
      float _482 = _69 - _479;
      float _483 = _69 - _480;
      float _484 = _481 * _433;
      float _485 = _482 * _434;
      float _486 = _483 * _435;
      float _487 = _466 + _484;
      float _488 = _467 + _485;
      float _489 = _468 + _486;
      _491 = _487;
      _492 = _488;
      _493 = _489;
      _494 = 0.0f;
      _495 = 0.0f;
      _496 = 0.0f;
      _497 = 0.0f;
      _498 = 0.0f;
      _499 = 1.0f;
    }
  }
  int _500 = _30 & 32;
  bool _501 = (_500 == 0);
  _1503 = _491;
  _1504 = _492;
  _1505 = _493;
  if (!_501) {
    float _504 = RadialBlurRenderParam_000x;
    float _505 = RadialBlurRenderParam_000y;
    float _506 = RadialBlurRenderParam_000z;
    float _507 = RadialBlurRenderParam_000w;
    float _509 = RadialBlurRenderParam_001x;
    float _510 = RadialBlurRenderParam_001y;
    float _511 = RadialBlurRenderParam_001z;
    float _512 = RadialBlurRenderParam_001w;
    float _514 = RadialBlurRenderParam_002x;
    float _515 = RadialBlurRenderParam_002y;
    float _516 = RadialBlurRenderParam_002z;
    uint _518 = RadialBlurRenderParam_003x;
    int _519 = _518 & 2;
    bool _520 = (_519 != 0);
    float _521 = float(_520);
    float _522 = 1.0f - _521;
    float4 _523 = ComputeResultSRV[0].data[0 / 4];
    float _524 = _523.x;
    float _525 = _524 * _521;
    float _526 = _522 + _525;
    float _527 = _526 * _507;
    bool _528 = (_527 == 0.0f);
    _1503 = _491;
    _1504 = _492;
    _1505 = _493;
    if (!_528) {
      float _530 = _58 * _22;
      float _531 = RadialBlurRenderParam_002w;
      float _533 = SceneInfo_023z;
      float _534 = SceneInfo_023w;
      float _535 = _533 * _27;
      float _536 = _534 * _28;
      float _537 = -0.5f - _509;
      float _538 = _537 + _535;
      float _539 = -0.5f - _510;
      float _540 = _539 + _536;
      bool _541 = (_538 < 0.0f);
      float _542 = 1.0f - _535;
      float _543 = _541 ? _542 : _535;
      bool _544 = (_540 < 0.0f);
      float _545 = 1.0f - _536;
      float _546 = _544 ? _545 : _536;
      int _547 = _518 & 1;
      bool _548 = (_547 != 0);
      float _549 = dot(float2(_538, _540), float2(_538, _540));
      float _550 = rsqrt(_549);
      float _551 = _550 * _531;
      float _552 = _551 * _538;
      float _553 = _551 * _540;
      float _554 = abs(_552);
      float _555 = abs(_553);
      uint _556 = uint(_554);
      uint _557 = uint(_555);
      uint _558 = _557 + _556;
      uint _559 = _558 ^ 61;
      uint _560 = _558 >> 16;
      uint _561 = _559 ^ _560;
      uint _562 = _561 * 9;
      uint _563 = _562 >> 4;
      uint _564 = _563 ^ _562;
      uint _565 = _564 * 668265261;
      uint _566 = _565 >> 15;
      uint _567 = _566 ^ _565;
      float _568 = float(_567);
      float _569 = _568 * 2.3283064365386963e-10f;
      float _570 = _548 ? _569 : 1.0f;
      float _571 = _538 * _538;
      float _572 = _540 * _540;
      float _573 = _571 + _572;
      float _574 = sqrt(_573);
      float _575 = max(1.0f, _574);
      float _576 = 1.0f / _575;
      float _577 = _516 * -0.0011111111380159855f;
      float _578 = _577 * _543;
      float _579 = _578 * _570;
      float _580 = _579 * _576;
      float _581 = _577 * _546;
      float _582 = _581 * _570;
      float _583 = _582 * _576;
      float _584 = _580 + 1.0f;
      float _585 = _583 + 1.0f;
      float _586 = _584 * _538;
      float _587 = _585 * _540;
      float _588 = _516 * -0.002222222276031971f;
      float _589 = _588 * _543;
      float _590 = _589 * _570;
      float _591 = _590 * _576;
      float _592 = _588 * _546;
      float _593 = _592 * _570;
      float _594 = _593 * _576;
      float _595 = _591 + 1.0f;
      float _596 = _594 + 1.0f;
      float _597 = _595 * _538;
      float _598 = _596 * _540;
      float _599 = _516 * -0.0033333334140479565f;
      float _600 = _599 * _543;
      float _601 = _600 * _570;
      float _602 = _601 * _576;
      float _603 = _599 * _546;
      float _604 = _603 * _570;
      float _605 = _604 * _576;
      float _606 = _602 + 1.0f;
      float _607 = _605 + 1.0f;
      float _608 = _606 * _538;
      float _609 = _607 * _540;
      float _610 = _516 * -0.004444444552063942f;
      float _611 = _610 * _543;
      float _612 = _611 * _570;
      float _613 = _612 * _576;
      float _614 = _610 * _546;
      float _615 = _614 * _570;
      float _616 = _615 * _576;
      float _617 = _613 + 1.0f;
      float _618 = _616 + 1.0f;
      float _619 = _617 * _538;
      float _620 = _618 * _540;
      float _621 = _516 * -0.0055555556900799274f;
      float _622 = _621 * _543;
      float _623 = _622 * _570;
      float _624 = _623 * _576;
      float _625 = _621 * _546;
      float _626 = _625 * _570;
      float _627 = _626 * _576;
      float _628 = _624 + 1.0f;
      float _629 = _627 + 1.0f;
      float _630 = _628 * _538;
      float _631 = _629 * _540;
      float _632 = _516 * -0.006666666828095913f;
      float _633 = _632 * _543;
      float _634 = _633 * _570;
      float _635 = _634 * _576;
      float _636 = _632 * _546;
      float _637 = _636 * _570;
      float _638 = _637 * _576;
      float _639 = _635 + 1.0f;
      float _640 = _638 + 1.0f;
      float _641 = _639 * _538;
      float _642 = _640 * _540;
      float _643 = _516 * -0.007777777966111898f;
      float _644 = _643 * _543;
      float _645 = _644 * _570;
      float _646 = _645 * _576;
      float _647 = _643 * _546;
      float _648 = _647 * _570;
      float _649 = _648 * _576;
      float _650 = _646 + 1.0f;
      float _651 = _649 + 1.0f;
      float _652 = _650 * _538;
      float _653 = _651 * _540;
      float _654 = _516 * -0.008888889104127884f;
      float _655 = _654 * _543;
      float _656 = _655 * _570;
      float _657 = _656 * _576;
      float _658 = _654 * _546;
      float _659 = _658 * _570;
      float _660 = _659 * _576;
      float _661 = _657 + 1.0f;
      float _662 = _660 + 1.0f;
      float _663 = _661 * _538;
      float _664 = _662 * _540;
      float _665 = _516 * -0.009999999776482582f;
      float _666 = _665 * _543;
      float _667 = _666 * _570;
      float _668 = _667 * _576;
      float _669 = _665 * _546;
      float _670 = _669 * _570;
      float _671 = _670 * _576;
      float _672 = _668 + 1.0f;
      float _673 = _671 + 1.0f;
      float _674 = _672 * _538;
      float _675 = _673 * _540;
      float _676 = _530 * 0.10000000149011612f;
      float _677 = _676 * _504;
      float _678 = _676 * _505;
      float _679 = _676 * _506;
      float _681 = TonemapParam_000y;
      float _683 = TonemapParam_002y;
      float _685 = TonemapParam_001y;
      float _686 = TonemapParam_000w;
      float _687 = TonemapParam_000x;
      float _688 = TonemapParam_002z;
      float _689 = TonemapParam_001x;
      float _690 = TonemapParam_001z;
      float _691 = TonemapParam_001w;
      float _692 = TonemapParam_002x;
      float _693 = _491 * 0.10000000149011612f;
      float _694 = _693 * _504;
      float _695 = _492 * 0.10000000149011612f;
      float _696 = _695 * _505;
      float _697 = _493 * 0.10000000149011612f;
      float _698 = _697 * _506;
      do {
        if (_36) {
          float _700 = _586 + _509;
          float _701 = _587 + _510;
          float _702 = dot(float2(_700, _701), float2(_700, _701));
          float _703 = _702 * _494;
          float _704 = _703 + 1.0f;
          float _705 = _704 * _499;
          float _706 = _705 * _700;
          float _707 = _705 * _701;
          float _708 = _706 + 0.5f;
          float _709 = _707 + 0.5f;
          float4 _710 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_708, _709), 0.0f);
          float _711 = _710.x;
          float _712 = _710.y;
          float _713 = _710.z;
          float _714 = _597 + _509;
          float _715 = _598 + _510;
          float _716 = dot(float2(_714, _715), float2(_714, _715));
          float _717 = _716 * _494;
          float _718 = _717 + 1.0f;
          float _719 = _714 * _499;
          float _720 = _719 * _718;
          float _721 = _715 * _499;
          float _722 = _721 * _718;
          float _723 = _720 + 0.5f;
          float _724 = _722 + 0.5f;
          float4 _725 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_723, _724), 0.0f);
          float _726 = _725.x;
          float _727 = _725.y;
          float _728 = _725.z;
          float _729 = _726 + _711;
          float _730 = _727 + _712;
          float _731 = _728 + _713;
          float _732 = _608 + _509;
          float _733 = _609 + _510;
          float _734 = dot(float2(_732, _733), float2(_732, _733));
          float _735 = _734 * _494;
          float _736 = _735 + 1.0f;
          float _737 = _732 * _499;
          float _738 = _737 * _736;
          float _739 = _733 * _499;
          float _740 = _739 * _736;
          float _741 = _738 + 0.5f;
          float _742 = _740 + 0.5f;
          float4 _743 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_741, _742), 0.0f);
          float _744 = _743.x;
          float _745 = _743.y;
          float _746 = _743.z;
          float _747 = _729 + _744;
          float _748 = _730 + _745;
          float _749 = _731 + _746;
          float _750 = _619 + _509;
          float _751 = _620 + _510;
          float _752 = dot(float2(_750, _751), float2(_750, _751));
          float _753 = _752 * _494;
          float _754 = _753 + 1.0f;
          float _755 = _750 * _499;
          float _756 = _755 * _754;
          float _757 = _751 * _499;
          float _758 = _757 * _754;
          float _759 = _756 + 0.5f;
          float _760 = _758 + 0.5f;
          float4 _761 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_759, _760), 0.0f);
          float _762 = _761.x;
          float _763 = _761.y;
          float _764 = _761.z;
          float _765 = _747 + _762;
          float _766 = _748 + _763;
          float _767 = _749 + _764;
          float _768 = _630 + _509;
          float _769 = _631 + _510;
          float _770 = dot(float2(_768, _769), float2(_768, _769));
          float _771 = _770 * _494;
          float _772 = _771 + 1.0f;
          float _773 = _768 * _499;
          float _774 = _773 * _772;
          float _775 = _769 * _499;
          float _776 = _775 * _772;
          float _777 = _774 + 0.5f;
          float _778 = _776 + 0.5f;
          float4 _779 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_777, _778), 0.0f);
          float _780 = _779.x;
          float _781 = _779.y;
          float _782 = _779.z;
          float _783 = _765 + _780;
          float _784 = _766 + _781;
          float _785 = _767 + _782;
          float _786 = _641 + _509;
          float _787 = _642 + _510;
          float _788 = dot(float2(_786, _787), float2(_786, _787));
          float _789 = _788 * _494;
          float _790 = _789 + 1.0f;
          float _791 = _786 * _499;
          float _792 = _791 * _790;
          float _793 = _787 * _499;
          float _794 = _793 * _790;
          float _795 = _792 + 0.5f;
          float _796 = _794 + 0.5f;
          float4 _797 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_795, _796), 0.0f);
          float _798 = _797.x;
          float _799 = _797.y;
          float _800 = _797.z;
          float _801 = _783 + _798;
          float _802 = _784 + _799;
          float _803 = _785 + _800;
          float _804 = _652 + _509;
          float _805 = _653 + _510;
          float _806 = dot(float2(_804, _805), float2(_804, _805));
          float _807 = _806 * _494;
          float _808 = _807 + 1.0f;
          float _809 = _804 * _499;
          float _810 = _809 * _808;
          float _811 = _805 * _499;
          float _812 = _811 * _808;
          float _813 = _810 + 0.5f;
          float _814 = _812 + 0.5f;
          float4 _815 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_813, _814), 0.0f);
          float _816 = _815.x;
          float _817 = _815.y;
          float _818 = _815.z;
          float _819 = _801 + _816;
          float _820 = _802 + _817;
          float _821 = _803 + _818;
          float _822 = _663 + _509;
          float _823 = _664 + _510;
          float _824 = dot(float2(_822, _823), float2(_822, _823));
          float _825 = _824 * _494;
          float _826 = _825 + 1.0f;
          float _827 = _822 * _499;
          float _828 = _827 * _826;
          float _829 = _823 * _499;
          float _830 = _829 * _826;
          float _831 = _828 + 0.5f;
          float _832 = _830 + 0.5f;
          float4 _833 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_831, _832), 0.0f);
          float _834 = _833.x;
          float _835 = _833.y;
          float _836 = _833.z;
          float _837 = _819 + _834;
          float _838 = _820 + _835;
          float _839 = _821 + _836;
          float _840 = _674 + _509;
          float _841 = _675 + _510;
          float _842 = dot(float2(_840, _841), float2(_840, _841));
          float _843 = _842 * _494;
          float _844 = _843 + 1.0f;
          float _845 = _840 * _499;
          float _846 = _845 * _844;
          float _847 = _841 * _499;
          float _848 = _847 * _844;
          float _849 = _846 + 0.5f;
          float _850 = _848 + 0.5f;
          float4 _851 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_849, _850), 0.0f);
          float _852 = _851.x;
          float _853 = _851.y;
          float _854 = _851.z;
          float _855 = _837 + _852;
          float _856 = _838 + _853;
          float _857 = _839 + _854;
          float _858 = _677 * _855;
          float _859 = _678 * _856;
          float _860 = _679 * _857;
          float _861 = _858 * _683;
          bool _862 = (_858 >= _681);
          float _863 = _861 * _861;
          float _864 = _861 * 2.0f;
          float _865 = 3.0f - _864;
          float _866 = _863 * _865;
          float _867 = _859 * _683;
          bool _868 = (_859 >= _681);
          float _869 = _867 * _867;
          float _870 = _867 * 2.0f;
          float _871 = 3.0f - _870;
          float _872 = _869 * _871;
          float _873 = _860 * _683;
          bool _874 = (_860 >= _681);
          float _875 = _873 * _873;
          float _876 = _873 * 2.0f;
          float _877 = 3.0f - _876;
          float _878 = _875 * _877;
          float _879 = 1.0f - _866;
          float _880 = _862 ? 0.0f : _879;
          float _881 = 1.0f - _872;
          float _882 = _868 ? 0.0f : _881;
          float _883 = 1.0f - _878;
          float _884 = _874 ? 0.0f : _883;
          bool _885 = (_858 < _685);
          bool _886 = (_859 < _685);
          bool _887 = (_860 < _685);
          float _888 = _885 ? 0.0f : 1.0f;
          float _889 = _886 ? 0.0f : 1.0f;
          float _890 = _887 ? 0.0f : 1.0f;
          float _891 = 1.0f - _888;
          float _892 = _891 - _880;
          float _893 = 1.0f - _889;
          float _894 = _893 - _882;
          float _895 = 1.0f - _890;
          float _896 = _895 - _884;
          float _897 = log2(_861);
          float _898 = log2(_867);
          float _899 = log2(_873);
          float _900 = _897 * _686;
          float _901 = _898 * _686;
          float _902 = _899 * _686;
          float _903 = exp2(_900);
          float _904 = exp2(_901);
          float _905 = exp2(_902);
          float _906 = _880 * _903;
          float _907 = _906 * _681;
          float _908 = _904 * _882;
          float _909 = _908 * _681;
          float _910 = _905 * _884;
          float _911 = _910 * _681;
          float _912 = _687 * _858;
          float _913 = _687 * _859;
          float _914 = _687 * _860;
          float _915 = _912 + _688;
          float _916 = _913 + _688;
          float _917 = _914 + _688;
          float _918 = _915 * _892;
          float _919 = _916 * _894;
          float _920 = _917 * _896;
          float _921 = _691 * _858;
          float _922 = _691 * _859;
          float _923 = _691 * _860;
          float _924 = _921 + _692;
          float _925 = _922 + _692;
          float _926 = _923 + _692;
          float _927 = exp2(_924);
          float _928 = exp2(_925);
          float _929 = exp2(_926);
          float _930 = _927 * _690;
          float _931 = _928 * _690;
          float _932 = _929 * _690;
          float _933 = _689 - _930;
          float _934 = _689 - _931;
          float _935 = _689 - _932;
          float _936 = _933 * _888;
          float _937 = _934 * _889;
          float _938 = _935 * _890;
          float _939 = _907 + _694;
          float _940 = _939 + _918;
          float _941 = _940 + _936;
          float _942 = _909 + _696;
          float _943 = _942 + _919;
          float _944 = _943 + _937;
          float _945 = _911 + _698;
          float _946 = _945 + _920;
          float _947 = _946 + _938;
          _1462 = _941;
          _1463 = _944;
          _1464 = _947;
        } else {
          float _949 = _509 + 0.5f;
          float _950 = _949 + _586;
          float _951 = _510 + 0.5f;
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
            float _970 = _950 * 2.0f;
            float _971 = _952 * 2.0f;
            float _972 = _970 + -1.0f;
            float _973 = _971 + -1.0f;
            float _974 = _972 * _972;
            float _975 = _974 + 1.0f;
            float _976 = sqrt(_975);
            float _977 = 1.0f / _976;
            float _978 = _977 + _495;
            float _979 = _976 * _497;
            float _980 = _979 * _978;
            float _981 = _977 + -1.0f;
            float _982 = _981 * _496;
            float _983 = _982 + 1.0f;
            float _984 = _498 * 0.5f;
            float _985 = _984 * _980;
            float _986 = _985 * _972;
            float _987 = _984 * _983;
            float _988 = _987 * _980;
            float _989 = _988 * _973;
            float _990 = _986 + 0.5f;
            float _991 = _989 + 0.5f;
            float4 _992 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(_990, _991), 0.0f);
            float _993 = _992.x;
            float _994 = _992.y;
            float _995 = _992.z;
            float _996 = _953 * 2.0f;
            float _997 = _954 * 2.0f;
            float _998 = _996 + -1.0f;
            float _999 = _997 + -1.0f;
            float _1000 = _998 * _998;
            float _1001 = _1000 + 1.0f;
            float _1002 = sqrt(_1001);
            float _1003 = 1.0f / _1002;
            float _1004 = _1003 + _495;
            float _1005 = _1002 * _497;
            float _1006 = _1005 * _1004;
            float _1007 = _1003 + -1.0f;
            float _1008 = _1007 * _496;
            float _1009 = _1008 + 1.0f;
            float _1010 = _984 * _998;
            float _1011 = _1010 * _1006;
            float _1012 = _984 * _999;
            float _1013 = _1012 * _1009;
            float _1014 = _1013 * _1006;
            float _1015 = _1011 + 0.5f;
            float _1016 = _1014 + 0.5f;
            float4 _1017 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(_1015, _1016), 0.0f);
            float _1018 = _1017.x;
            float _1019 = _1017.y;
            float _1020 = _1017.z;
            float _1021 = _1018 + _993;
            float _1022 = _1019 + _994;
            float _1023 = _1020 + _995;
            float _1024 = _955 * 2.0f;
            float _1025 = _956 * 2.0f;
            float _1026 = _1024 + -1.0f;
            float _1027 = _1025 + -1.0f;
            float _1028 = _1026 * _1026;
            float _1029 = _1028 + 1.0f;
            float _1030 = sqrt(_1029);
            float _1031 = 1.0f / _1030;
            float _1032 = _1031 + _495;
            float _1033 = _1030 * _497;
            float _1034 = _1033 * _1032;
            float _1035 = _1031 + -1.0f;
            float _1036 = _1035 * _496;
            float _1037 = _1036 + 1.0f;
            float _1038 = _984 * _1026;
            float _1039 = _1038 * _1034;
            float _1040 = _984 * _1027;
            float _1041 = _1040 * _1037;
            float _1042 = _1041 * _1034;
            float _1043 = _1039 + 0.5f;
            float _1044 = _1042 + 0.5f;
            float4 _1045 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(_1043, _1044), 0.0f);
            float _1046 = _1045.x;
            float _1047 = _1045.y;
            float _1048 = _1045.z;
            float _1049 = _1021 + _1046;
            float _1050 = _1022 + _1047;
            float _1051 = _1023 + _1048;
            float _1052 = _957 * 2.0f;
            float _1053 = _958 * 2.0f;
            float _1054 = _1052 + -1.0f;
            float _1055 = _1053 + -1.0f;
            float _1056 = _1054 * _1054;
            float _1057 = _1056 + 1.0f;
            float _1058 = sqrt(_1057);
            float _1059 = 1.0f / _1058;
            float _1060 = _1059 + _495;
            float _1061 = _1058 * _497;
            float _1062 = _1061 * _1060;
            float _1063 = _1059 + -1.0f;
            float _1064 = _1063 * _496;
            float _1065 = _1064 + 1.0f;
            float _1066 = _984 * _1054;
            float _1067 = _1066 * _1062;
            float _1068 = _984 * _1055;
            float _1069 = _1068 * _1065;
            float _1070 = _1069 * _1062;
            float _1071 = _1067 + 0.5f;
            float _1072 = _1070 + 0.5f;
            float4 _1073 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(_1071, _1072), 0.0f);
            float _1074 = _1073.x;
            float _1075 = _1073.y;
            float _1076 = _1073.z;
            float _1077 = _1049 + _1074;
            float _1078 = _1050 + _1075;
            float _1079 = _1051 + _1076;
            float _1080 = _959 * 2.0f;
            float _1081 = _960 * 2.0f;
            float _1082 = _1080 + -1.0f;
            float _1083 = _1081 + -1.0f;
            float _1084 = _1082 * _1082;
            float _1085 = _1084 + 1.0f;
            float _1086 = sqrt(_1085);
            float _1087 = 1.0f / _1086;
            float _1088 = _1087 + _495;
            float _1089 = _1086 * _497;
            float _1090 = _1089 * _1088;
            float _1091 = _1087 + -1.0f;
            float _1092 = _1091 * _496;
            float _1093 = _1092 + 1.0f;
            float _1094 = _984 * _1082;
            float _1095 = _1094 * _1090;
            float _1096 = _984 * _1083;
            float _1097 = _1096 * _1093;
            float _1098 = _1097 * _1090;
            float _1099 = _1095 + 0.5f;
            float _1100 = _1098 + 0.5f;
            float4 _1101 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(_1099, _1100), 0.0f);
            float _1102 = _1101.x;
            float _1103 = _1101.y;
            float _1104 = _1101.z;
            float _1105 = _1077 + _1102;
            float _1106 = _1078 + _1103;
            float _1107 = _1079 + _1104;
            float _1108 = _961 * 2.0f;
            float _1109 = _962 * 2.0f;
            float _1110 = _1108 + -1.0f;
            float _1111 = _1109 + -1.0f;
            float _1112 = _1110 * _1110;
            float _1113 = _1112 + 1.0f;
            float _1114 = sqrt(_1113);
            float _1115 = 1.0f / _1114;
            float _1116 = _1115 + _495;
            float _1117 = _1114 * _497;
            float _1118 = _1117 * _1116;
            float _1119 = _1115 + -1.0f;
            float _1120 = _1119 * _496;
            float _1121 = _1120 + 1.0f;
            float _1122 = _984 * _1110;
            float _1123 = _1122 * _1118;
            float _1124 = _984 * _1111;
            float _1125 = _1124 * _1121;
            float _1126 = _1125 * _1118;
            float _1127 = _1123 + 0.5f;
            float _1128 = _1126 + 0.5f;
            float4 _1129 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(_1127, _1128), 0.0f);
            float _1130 = _1129.x;
            float _1131 = _1129.y;
            float _1132 = _1129.z;
            float _1133 = _1105 + _1130;
            float _1134 = _1106 + _1131;
            float _1135 = _1107 + _1132;
            float _1136 = _963 * 2.0f;
            float _1137 = _964 * 2.0f;
            float _1138 = _1136 + -1.0f;
            float _1139 = _1137 + -1.0f;
            float _1140 = _1138 * _1138;
            float _1141 = _1140 + 1.0f;
            float _1142 = sqrt(_1141);
            float _1143 = 1.0f / _1142;
            float _1144 = _1143 + _495;
            float _1145 = _1142 * _497;
            float _1146 = _1145 * _1144;
            float _1147 = _1143 + -1.0f;
            float _1148 = _1147 * _496;
            float _1149 = _1148 + 1.0f;
            float _1150 = _984 * _1138;
            float _1151 = _1150 * _1146;
            float _1152 = _984 * _1139;
            float _1153 = _1152 * _1149;
            float _1154 = _1153 * _1146;
            float _1155 = _1151 + 0.5f;
            float _1156 = _1154 + 0.5f;
            float4 _1157 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(_1155, _1156), 0.0f);
            float _1158 = _1157.x;
            float _1159 = _1157.y;
            float _1160 = _1157.z;
            float _1161 = _1133 + _1158;
            float _1162 = _1134 + _1159;
            float _1163 = _1135 + _1160;
            float _1164 = _965 * 2.0f;
            float _1165 = _966 * 2.0f;
            float _1166 = _1164 + -1.0f;
            float _1167 = _1165 + -1.0f;
            float _1168 = _1166 * _1166;
            float _1169 = _1168 + 1.0f;
            float _1170 = sqrt(_1169);
            float _1171 = 1.0f / _1170;
            float _1172 = _1171 + _495;
            float _1173 = _1170 * _497;
            float _1174 = _1173 * _1172;
            float _1175 = _1171 + -1.0f;
            float _1176 = _1175 * _496;
            float _1177 = _1176 + 1.0f;
            float _1178 = _984 * _1166;
            float _1179 = _1178 * _1174;
            float _1180 = _984 * _1167;
            float _1181 = _1180 * _1177;
            float _1182 = _1181 * _1174;
            float _1183 = _1179 + 0.5f;
            float _1184 = _1182 + 0.5f;
            float4 _1185 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(_1183, _1184), 0.0f);
            float _1186 = _1185.x;
            float _1187 = _1185.y;
            float _1188 = _1185.z;
            float _1189 = _1161 + _1186;
            float _1190 = _1162 + _1187;
            float _1191 = _1163 + _1188;
            float _1192 = _967 * 2.0f;
            float _1193 = _968 * 2.0f;
            float _1194 = _1192 + -1.0f;
            float _1195 = _1193 + -1.0f;
            float _1196 = _1194 * _1194;
            float _1197 = _1196 + 1.0f;
            float _1198 = sqrt(_1197);
            float _1199 = 1.0f / _1198;
            float _1200 = _1199 + _495;
            float _1201 = _1198 * _497;
            float _1202 = _1201 * _1200;
            float _1203 = _1199 + -1.0f;
            float _1204 = _1203 * _496;
            float _1205 = _1204 + 1.0f;
            float _1206 = _984 * _1194;
            float _1207 = _1206 * _1202;
            float _1208 = _984 * _1195;
            float _1209 = _1208 * _1205;
            float _1210 = _1209 * _1202;
            float _1211 = _1207 + 0.5f;
            float _1212 = _1210 + 0.5f;
            float4 _1213 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(_1211, _1212), 0.0f);
            float _1214 = _1213.x;
            float _1215 = _1213.y;
            float _1216 = _1213.z;
            float _1217 = _1189 + _1214;
            float _1218 = _1190 + _1215;
            float _1219 = _1191 + _1216;
            float _1220 = _677 * _1217;
            float _1221 = _678 * _1218;
            float _1222 = _679 * _1219;
            float _1223 = _1220 * _683;
            bool _1224 = (_1220 >= _681);
            float _1225 = _1223 * _1223;
            float _1226 = _1223 * 2.0f;
            float _1227 = 3.0f - _1226;
            float _1228 = _1225 * _1227;
            float _1229 = _1221 * _683;
            bool _1230 = (_1221 >= _681);
            float _1231 = _1229 * _1229;
            float _1232 = _1229 * 2.0f;
            float _1233 = 3.0f - _1232;
            float _1234 = _1231 * _1233;
            float _1235 = _1222 * _683;
            bool _1236 = (_1222 >= _681);
            float _1237 = _1235 * _1235;
            float _1238 = _1235 * 2.0f;
            float _1239 = 3.0f - _1238;
            float _1240 = _1237 * _1239;
            float _1241 = 1.0f - _1228;
            float _1242 = _1224 ? 0.0f : _1241;
            float _1243 = 1.0f - _1234;
            float _1244 = _1230 ? 0.0f : _1243;
            float _1245 = 1.0f - _1240;
            float _1246 = _1236 ? 0.0f : _1245;
            bool _1247 = (_1220 < _685);
            bool _1248 = (_1221 < _685);
            bool _1249 = (_1222 < _685);
            float _1250 = _1247 ? 0.0f : 1.0f;
            float _1251 = _1248 ? 0.0f : 1.0f;
            float _1252 = _1249 ? 0.0f : 1.0f;
            float _1253 = 1.0f - _1250;
            float _1254 = _1253 - _1242;
            float _1255 = 1.0f - _1251;
            float _1256 = _1255 - _1244;
            float _1257 = 1.0f - _1252;
            float _1258 = _1257 - _1246;
            float _1259 = log2(_1223);
            float _1260 = log2(_1229);
            float _1261 = log2(_1235);
            float _1262 = _1259 * _686;
            float _1263 = _1260 * _686;
            float _1264 = _1261 * _686;
            float _1265 = exp2(_1262);
            float _1266 = exp2(_1263);
            float _1267 = exp2(_1264);
            float _1268 = _1242 * _1265;
            float _1269 = _1268 * _681;
            float _1270 = _1266 * _1244;
            float _1271 = _1270 * _681;
            float _1272 = _1267 * _1246;
            float _1273 = _1272 * _681;
            float _1274 = _687 * _1220;
            float _1275 = _687 * _1221;
            float _1276 = _687 * _1222;
            float _1277 = _1274 + _688;
            float _1278 = _1275 + _688;
            float _1279 = _1276 + _688;
            float _1280 = _1277 * _1254;
            float _1281 = _1278 * _1256;
            float _1282 = _1279 * _1258;
            float _1283 = _691 * _1220;
            float _1284 = _691 * _1221;
            float _1285 = _691 * _1222;
            float _1286 = _1283 + _692;
            float _1287 = _1284 + _692;
            float _1288 = _1285 + _692;
            float _1289 = exp2(_1286);
            float _1290 = exp2(_1287);
            float _1291 = exp2(_1288);
            float _1292 = _1289 * _690;
            float _1293 = _1290 * _690;
            float _1294 = _1291 * _690;
            float _1295 = _689 - _1292;
            float _1296 = _689 - _1293;
            float _1297 = _689 - _1294;
            float _1298 = _1295 * _1250;
            float _1299 = _1296 * _1251;
            float _1300 = _1297 * _1252;
            float _1301 = _1269 + _694;
            float _1302 = _1301 + _1280;
            float _1303 = _1302 + _1298;
            float _1304 = _1271 + _696;
            float _1305 = _1304 + _1281;
            float _1306 = _1305 + _1299;
            float _1307 = _1273 + _698;
            float _1308 = _1307 + _1282;
            float _1309 = _1308 + _1300;
            _1462 = _1303;
            _1463 = _1306;
            _1464 = _1309;
          } else {
            float4 _1311 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_950, _952), 0.0f);
            float _1312 = _1311.x;
            float _1313 = _1311.y;
            float _1314 = _1311.z;
            float4 _1315 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_953, _954), 0.0f);
            float _1316 = _1315.x;
            float _1317 = _1315.y;
            float _1318 = _1315.z;
            float _1319 = _1316 + _1312;
            float _1320 = _1317 + _1313;
            float _1321 = _1318 + _1314;
            float4 _1322 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_955, _956), 0.0f);
            float _1323 = _1322.x;
            float _1324 = _1322.y;
            float _1325 = _1322.z;
            float _1326 = _1319 + _1323;
            float _1327 = _1320 + _1324;
            float _1328 = _1321 + _1325;
            float4 _1329 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_957, _958), 0.0f);
            float _1330 = _1329.x;
            float _1331 = _1329.y;
            float _1332 = _1329.z;
            float _1333 = _1326 + _1330;
            float _1334 = _1327 + _1331;
            float _1335 = _1328 + _1332;
            float4 _1336 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_959, _960), 0.0f);
            float _1337 = _1336.x;
            float _1338 = _1336.y;
            float _1339 = _1336.z;
            float _1340 = _1333 + _1337;
            float _1341 = _1334 + _1338;
            float _1342 = _1335 + _1339;
            float4 _1343 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_961, _962), 0.0f);
            float _1344 = _1343.x;
            float _1345 = _1343.y;
            float _1346 = _1343.z;
            float _1347 = _1340 + _1344;
            float _1348 = _1341 + _1345;
            float _1349 = _1342 + _1346;
            float4 _1350 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_963, _964), 0.0f);
            float _1351 = _1350.x;
            float _1352 = _1350.y;
            float _1353 = _1350.z;
            float _1354 = _1347 + _1351;
            float _1355 = _1348 + _1352;
            float _1356 = _1349 + _1353;
            float4 _1357 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_965, _966), 0.0f);
            float _1358 = _1357.x;
            float _1359 = _1357.y;
            float _1360 = _1357.z;
            float _1361 = _1354 + _1358;
            float _1362 = _1355 + _1359;
            float _1363 = _1356 + _1360;
            float4 _1364 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_967, _968), 0.0f);
            float _1365 = _1364.x;
            float _1366 = _1364.y;
            float _1367 = _1364.z;
            float _1368 = _1361 + _1365;
            float _1369 = _1362 + _1366;
            float _1370 = _1363 + _1367;
            float _1371 = _677 * _1368;
            float _1372 = _678 * _1369;
            float _1373 = _679 * _1370;
            float _1374 = _1371 * _683;
            bool _1375 = (_1371 >= _681);
            float _1376 = _1374 * _1374;
            float _1377 = _1374 * 2.0f;
            float _1378 = 3.0f - _1377;
            float _1379 = _1376 * _1378;
            float _1380 = _1372 * _683;
            bool _1381 = (_1372 >= _681);
            float _1382 = _1380 * _1380;
            float _1383 = _1380 * 2.0f;
            float _1384 = 3.0f - _1383;
            float _1385 = _1382 * _1384;
            float _1386 = _1373 * _683;
            bool _1387 = (_1373 >= _681);
            float _1388 = _1386 * _1386;
            float _1389 = _1386 * 2.0f;
            float _1390 = 3.0f - _1389;
            float _1391 = _1388 * _1390;
            float _1392 = 1.0f - _1379;
            float _1393 = _1375 ? 0.0f : _1392;
            float _1394 = 1.0f - _1385;
            float _1395 = _1381 ? 0.0f : _1394;
            float _1396 = 1.0f - _1391;
            float _1397 = _1387 ? 0.0f : _1396;
            bool _1398 = (_1371 < _685);
            bool _1399 = (_1372 < _685);
            bool _1400 = (_1373 < _685);
            float _1401 = _1398 ? 0.0f : 1.0f;
            float _1402 = _1399 ? 0.0f : 1.0f;
            float _1403 = _1400 ? 0.0f : 1.0f;
            float _1404 = 1.0f - _1401;
            float _1405 = _1404 - _1393;
            float _1406 = 1.0f - _1402;
            float _1407 = _1406 - _1395;
            float _1408 = 1.0f - _1403;
            float _1409 = _1408 - _1397;
            float _1410 = log2(_1374);
            float _1411 = log2(_1380);
            float _1412 = log2(_1386);
            float _1413 = _1410 * _686;
            float _1414 = _1411 * _686;
            float _1415 = _1412 * _686;
            float _1416 = exp2(_1413);
            float _1417 = exp2(_1414);
            float _1418 = exp2(_1415);
            float _1419 = _1393 * _1416;
            float _1420 = _1419 * _681;
            float _1421 = _1417 * _1395;
            float _1422 = _1421 * _681;
            float _1423 = _1418 * _1397;
            float _1424 = _1423 * _681;
            float _1425 = _687 * _1371;
            float _1426 = _687 * _1372;
            float _1427 = _687 * _1373;
            float _1428 = _1425 + _688;
            float _1429 = _1426 + _688;
            float _1430 = _1427 + _688;
            float _1431 = _1428 * _1405;
            float _1432 = _1429 * _1407;
            float _1433 = _1430 * _1409;
            float _1434 = _691 * _1371;
            float _1435 = _691 * _1372;
            float _1436 = _691 * _1373;
            float _1437 = _1434 + _692;
            float _1438 = _1435 + _692;
            float _1439 = _1436 + _692;
            float _1440 = exp2(_1437);
            float _1441 = exp2(_1438);
            float _1442 = exp2(_1439);
            float _1443 = _1440 * _690;
            float _1444 = _1441 * _690;
            float _1445 = _1442 * _690;
            float _1446 = _689 - _1443;
            float _1447 = _689 - _1444;
            float _1448 = _689 - _1445;
            float _1449 = _1446 * _1401;
            float _1450 = _1447 * _1402;
            float _1451 = _1448 * _1403;
            float _1452 = _1420 + _694;
            float _1453 = _1452 + _1431;
            float _1454 = _1453 + _1449;
            float _1455 = _1422 + _696;
            float _1456 = _1455 + _1432;
            float _1457 = _1456 + _1450;
            float _1458 = _1424 + _698;
            float _1459 = _1458 + _1433;
            float _1460 = _1459 + _1451;
            _1462 = _1454;
            _1463 = _1457;
            _1464 = _1460;
          }
        }
        bool _1465 = (_514 > 0.0f);
        _1490 = _1462;
        _1491 = _1463;
        _1492 = _1464;
        do {
          if (_1465) {
            float _1467 = _538 * _538;
            float _1468 = _540 * _540;
            float _1469 = _1467 + _1468;
            float _1470 = sqrt(_1469);
            float _1471 = _1470 * _511;
            float _1472 = _1471 + _512;
            float _1473 = saturate(_1472);
            float _1474 = _1473 * 2.0f;
            float _1475 = 3.0f - _1474;
            float _1476 = _1473 * _1473;
            float _1477 = _1476 * _514;
            float _1478 = _1477 * _1475;
            float _1479 = _1478 + _515;
            float _1480 = _1462 - _491;
            float _1481 = _1463 - _492;
            float _1482 = _1464 - _493;
            float _1483 = _1479 * _1480;
            float _1484 = _1479 * _1481;
            float _1485 = _1479 * _1482;
            float _1486 = _1483 + _491;
            float _1487 = _1484 + _492;
            float _1488 = _1485 + _493;
            _1490 = _1486;
            _1491 = _1487;
            _1492 = _1488;
          }
          float _1493 = _1490 - _491;
          float _1494 = _1491 - _492;
          float _1495 = _1492 - _493;
          float _1496 = _1493 * _527;
          float _1497 = _1494 * _527;
          float _1498 = _1495 * _527;
          float _1499 = _1496 + _491;
          float _1500 = _1497 + _492;
          float _1501 = _1498 + _493;
          _1503 = _1499;
          _1504 = _1500;
          _1505 = _1501;
        } while (false);
      } while (false);
    }
  }
  int _1506 = _30 & 2;
  bool _1507 = (_1506 == 0);
  _1604 = _1503;
  _1605 = _1504;
  _1606 = _1505;
  if (!_1507) {
    float _1510 = FilmGrainParam_000x;
    float _1511 = FilmGrainParam_000y;
    float _1512 = FilmGrainParam_000z;
    float _1513 = FilmGrainParam_000w;
    float _1515 = FilmGrainParam_001x;
    float _1516 = FilmGrainParam_001y;
    float _1517 = FilmGrainParam_001z;
    float _1518 = FilmGrainParam_001w;
    float _1520 = SceneInfo_023x;
    float _1521 = SceneInfo_023y;
    float _1522 = _1520 * _1512;
    float _1523 = _1521 * _1513;
    float _1524 = _1522 + _27;
    float _1525 = _1523 + _28;
    float _1526 = _1524 * _1518;
    float _1527 = floor(_1526);
    float _1528 = _1525 * _1518;
    float _1529 = floor(_1528);
    float _1530 = dot(float2(_1527, _1529), float2(0.0671105608344078f, 0.005837149918079376f));
    float _1531 = frac(_1530);
    float _1532 = _1531 * 52.98291778564453f;
    float _1533 = frac(_1532);
    bool _1534 = (_1533 < _1515);
    _1547 = 0.0f;
    do {
      if (_1534) {
        float _1536 = _1529 * _1527;
        uint _1537 = uint(_1536);
        uint _1538 = _1537 ^ 12345391;
        uint _1539 = _1538 * 3635641;
        uint _1540 = _1538 * 232681024;
        uint _1541 = _1539 >> 26;
        int _1542 = _1541 | _1540;
        uint _1543 = _1542 ^ _1539;
        float _1544 = float(_1543);
        float _1545 = _1544 * 2.3283064365386963e-10f;
        _1547 = _1545;
      }
      float _1548 = _1533 * 757.4846801757812f;
      float _1549 = frac(_1548);
      bool _1550 = (_1549 < _1515);
      _1563 = 0.0f;
      do {
        if (_1550) {
          int _1552 = (int)_1549;
          uint _1553 = _1552 ^ 12345391;
          uint _1554 = _1553 * 3635641;
          uint _1555 = _1553 * 232681024;
          uint _1556 = _1554 >> 26;
          int _1557 = _1556 | _1555;
          uint _1558 = _1557 ^ _1554;
          float _1559 = float(_1558);
          float _1560 = _1559 * 2.3283064365386963e-10f;
          float _1561 = _1560 + -0.5f;
          _1563 = _1561;
        }
        float _1564 = _1549 * 757.4846801757812f;
        float _1565 = frac(_1564);
        bool _1566 = (_1565 < _1515);
        _1579 = 0.0f;
        do {
          if (_1566) {
            int _1568 = (int)_1565;
            uint _1569 = _1568 ^ 12345391;
            uint _1570 = _1569 * 3635641;
            uint _1571 = _1569 * 232681024;
            uint _1572 = _1570 >> 26;
            int _1573 = _1572 | _1571;
            uint _1574 = _1573 ^ _1570;
            float _1575 = float(_1574);
            float _1576 = _1575 * 2.3283064365386963e-10f;
            float _1577 = _1576 + -0.5f;
            _1579 = _1577;
          }
          float _1580 = _1547 * _1510;
          float _1581 = _1579 * _1511;
          float _1582 = _1563 * _1511;
          float _1583 = mad(_1582, 1.4019999504089355f, _1580);
          float _1584 = mad(_1581, -0.3440000116825104f, _1580);
          float _1585 = mad(_1582, -0.7139999866485596f, _1584);
          float _1586 = mad(_1581, 1.7719999551773071f, _1580);
          float _1587 = dot(float3(_1503, _1504, _1505), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f));
          float _1588 = saturate(_1587);
          float _1589 = 1.0f - _1588;
          float _1590 = log2(_1589);
          float _1591 = _1590 * _1516;
          float _1592 = exp2(_1591);
          float _1593 = _1592 * _1517;
          float _1594 = _1583 - _1503;
          float _1595 = _1585 - _1504;
          float _1596 = _1586 - _1505;
          float _1597 = _1593 * _1594;
          float _1598 = _1593 * _1595;
          float _1599 = _1593 * _1596;
          float _1600 = _1597 + _1503;
          float _1601 = _1598 + _1504;
          float _1602 = _1599 + _1505;
          _1604 = _1600;
          _1605 = _1601;
          _1606 = _1602;
        } while (false);
      } while (false);
    } while (false);
  }
  int _1607 = _30 & 4;
  bool _1608 = (_1607 == 0);
  _1817 = _1604;
  _1818 = _1605;
  _1819 = _1606;
  if (!_1608) {
    float _1611 = ColorCorrectTexture_000y;
    float _1612 = ColorCorrectTexture_000z;
    float _1613 = ColorCorrectTexture_000w;
    float _1615 = ColorCorrectTexture_001x;
    float _1616 = ColorCorrectTexture_001y;
    float _1617 = ColorCorrectTexture_001z;
    float _1619 = ColorCorrectTexture_002x;
    float _1620 = ColorCorrectTexture_002y;
    float _1621 = ColorCorrectTexture_002z;
    float _1623 = ColorCorrectTexture_003x;
    float _1624 = ColorCorrectTexture_003y;
    float _1625 = ColorCorrectTexture_003z;
    float _1627 = ColorCorrectTexture_004x;
    float _1628 = ColorCorrectTexture_004y;
    float _1629 = ColorCorrectTexture_004z;
    float _1630 = max(_1604, _1605);
    float _1631 = max(_1630, _1606);
    bool _1632 = (_1631 > 1.0f);
    _1638 = _1604;
    _1639 = _1605;
    _1640 = _1606;
    do {
      if (_1632) {
        float _1634 = _1604 / _1631;
        float _1635 = _1605 / _1631;
        float _1636 = _1606 / _1631;
        _1638 = _1634;
        _1639 = _1635;
        _1640 = _1636;
      }
      float _1641 = _1613 * 0.5f;
      bool _1642 = !(_1638 <= 0.0031308000907301903f);
      do {
        if (!_1642) {
          float _1644 = _1638 * 12.920000076293945f;
          _1652 = _1644;
        } else {
          float _1646 = log2(_1638);
          float _1647 = _1646 * 0.4166666567325592f;
          float _1648 = exp2(_1647);
          float _1649 = _1648 * 1.0549999475479126f;
          float _1650 = _1649 + -0.054999999701976776f;
          _1652 = _1650;
        }
        bool _1653 = !(_1639 <= 0.0031308000907301903f);
        do {
          if (!_1653) {
            float _1655 = _1639 * 12.920000076293945f;
            _1663 = _1655;
          } else {
            float _1657 = log2(_1639);
            float _1658 = _1657 * 0.4166666567325592f;
            float _1659 = exp2(_1658);
            float _1660 = _1659 * 1.0549999475479126f;
            float _1661 = _1660 + -0.054999999701976776f;
            _1663 = _1661;
          }
          bool _1664 = !(_1640 <= 0.0031308000907301903f);
          do {
            if (!_1664) {
              float _1666 = _1640 * 12.920000076293945f;
              _1674 = _1666;
            } else {
              float _1668 = log2(_1640);
              float _1669 = _1668 * 0.4166666567325592f;
              float _1670 = exp2(_1669);
              float _1671 = _1670 * 1.0549999475479126f;
              float _1672 = _1671 + -0.054999999701976776f;
              _1674 = _1672;
            }
            float _1675 = 1.0f - _1613;
            float _1676 = _1652 * _1675;
            float _1677 = _1663 * _1675;
            float _1678 = _1674 * _1675;
            float _1679 = _1676 + _1641;
            float _1680 = _1677 + _1641;
            float _1681 = _1678 + _1641;
            float4 _1682 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1679, _1680, _1681), 0.0f);

            // custom code
#if 1
            _1682.rgb = LUTBlackCorrection(float3(_1638, _1639, _1640), _1682.rgb, tTextureMap0, lut_config);

#else
            float3 lutVanilla = _1682.rgb;
            
            float3 lutInputColor = float3(_1638, _1639, _1640);
            renodx::lut::Config lut_config = renodx::lut::config::Create(
                TrilinearClamp,
                1.f,
                1.f,
                renodx::lut::config::type::SRGB,
                renodx::lut::config::type::LINEAR,
                1 / ColorCorrectTexture_000w);
            float3 lutCorrectedBlack = renodx::lut::Sample(tTextureMap0, lut_config, lutInputColor);

            // blend with vanilla
            // needed to prevent crushing with srgb -> 2.2 conversion later
            float RestorationScale = 1.0f;
            float RestorationPower = 0.25f;
            _1682.rgb = lerp(lutCorrectedBlack, max(lutVanilla, 0), pow(saturate(lutCorrectedBlack / RestorationScale), RestorationPower));
#endif

            float _1683 = _1682.x;
            float _1684 = _1682.y;
            float _1685 = _1682.z;
            bool _1686 = (_1611 > 0.0f);
            do {
              if (_1686) {
                float4 _1688 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1679, _1680, _1681), 0.0f);
                
                // custom code
#if 1
                _1688.rgb = LUTBlackCorrection(float3(_1638, _1639, _1640), _1688.rgb, tTextureMap1, lut_config);
#else
                float3 lutVanilla = _1688.rgb;

                float3 lutInputColor = float3(_1638, _1639, _1640);
                renodx::lut::Config lut_config = renodx::lut::config::Create(
                    TrilinearClamp,
                    1.f,
                    1.f,
                    renodx::lut::config::type::SRGB,
                    renodx::lut::config::type::LINEAR,
                    1 / ColorCorrectTexture_000w);
                float3 lutCorrectedBlack = renodx::lut::Sample(tTextureMap1, lut_config, float3(_1638, _1639, _1640));

                // blend with vanilla
                // needed to prevent crushing with srgb -> 2.2 conversion later
                float RestorationScale = 1.0f;
                float RestorationPower = 0.25f;
                _1688.rgb = lerp(lutCorrectedBlack, max(lutVanilla, 0), pow(saturate(lutCorrectedBlack / RestorationScale), RestorationPower));
#endif


                float _1689 = _1688.x;
                float _1690 = _1688.y;
                float _1691 = _1688.z;
                float _1692 = _1689 - _1683;
                float _1693 = _1690 - _1684;
                float _1694 = _1691 - _1685;
                float _1695 = _1692 * _1611;
                float _1696 = _1693 * _1611;
                float _1697 = _1694 * _1611;
                float _1698 = _1695 + _1683;
                float _1699 = _1696 + _1684;
                float _1700 = _1697 + _1685;
                bool _1701 = (_1612 > 0.0f);
                _1797 = _1698;
                _1798 = _1699;
                _1799 = _1700;
                if (_1701) {
                  bool _1703 = !(_1698 <= 0.0031308000907301903f);
                  do {
                    if (!_1703) {
                      float _1705 = _1698 * 12.920000076293945f;
                      _1713 = _1705;
                    } else {
                      float _1707 = log2(_1698);
                      float _1708 = _1707 * 0.4166666567325592f;
                      float _1709 = exp2(_1708);
                      float _1710 = _1709 * 1.0549999475479126f;
                      float _1711 = _1710 + -0.054999999701976776f;
                      _1713 = _1711;
                    }
                    bool _1714 = !(_1699 <= 0.0031308000907301903f);
                    do {
                      if (!_1714) {
                        float _1716 = _1699 * 12.920000076293945f;
                        _1724 = _1716;
                      } else {
                        float _1718 = log2(_1699);
                        float _1719 = _1718 * 0.4166666567325592f;
                        float _1720 = exp2(_1719);
                        float _1721 = _1720 * 1.0549999475479126f;
                        float _1722 = _1721 + -0.054999999701976776f;
                        _1724 = _1722;
                      }
                      bool _1725 = !(_1700 <= 0.0031308000907301903f);
                      do {
                        if (!_1725) {
                          float _1727 = _1700 * 12.920000076293945f;
                          _1735 = _1727;
                        } else {
                          float _1729 = log2(_1700);
                          float _1730 = _1729 * 0.4166666567325592f;
                          float _1731 = exp2(_1730);
                          float _1732 = _1731 * 1.0549999475479126f;
                          float _1733 = _1732 + -0.054999999701976776f;
                          _1735 = _1733;
                        }
                        // // custom code
                        // float3 sRGBColor = renodx::color::srgb::Encode(max(0, float3(_1698, _1699, _1700)));
                        // _1713 = sRGBColor.r;
                        // _1724 = sRGBColor.g;
                        // _1735 = sRGBColor.b;

                        
                        
                        // custom code
                        float4 _1736 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1713, _1724, _1735), 0.0f);

#if 1
                        _1736.rgb = LUTBlackCorrection(float3(_1698, _1699, _1700), _1736.rgb, tTextureMap2, lut_config);
#else
                        float3 lutVanilla = _1736.rgb;

                        float3 lutInputColor = float3(_1698, _1699, _1700);
                        renodx::lut::Config lut_config = renodx::lut::config::Create(
                            TrilinearClamp,
                            1.f,
                            1.f,
                            renodx::lut::config::type::SRGB,
                            renodx::lut::config::type::LINEAR,
                            1 / ColorCorrectTexture_000w);
                        float3 lutCorrectedBlack = renodx::lut::Sample(tTextureMap2, lut_config, lutInputColor);

                        // blend with vanilla
                        // needed to prevent crushing with srgb -> 2.2 conversion later
                        float RestorationScale = 1.0f;
                        float RestorationPower = 0.25f;
                        _1736.rgb = lerp(lutCorrectedBlack, max(lutVanilla, 0), pow(saturate(lutCorrectedBlack / RestorationScale), RestorationPower));
#endif

                        float _1737 = _1736.x;
                        float _1738 = _1736.y;
                        float _1739 = _1736.z;
                        float _1740 = _1737 - _1698;
                        float _1741 = _1738 - _1699;
                        float _1742 = _1739 - _1700;
                        float _1743 = _1740 * _1612;
                        float _1744 = _1741 * _1612;
                        float _1745 = _1742 * _1612;
                        float _1746 = _1743 + _1698;
                        float _1747 = _1744 + _1699;
                        float _1748 = _1745 + _1700;
                        _1797 = _1746;
                        _1798 = _1747;
                        _1799 = _1748;
                      } while (false);
                    } while (false);
                  } while (false);
                }
              } else {
                bool _1750 = !(_1683 <= 0.0031308000907301903f);
                do {
                  if (!_1750) {
                    float _1752 = _1683 * 12.920000076293945f;
                    _1760 = _1752;
                  } else {
                    float _1754 = log2(_1683);
                    float _1755 = _1754 * 0.4166666567325592f;
                    float _1756 = exp2(_1755);
                    float _1757 = _1756 * 1.0549999475479126f;
                    float _1758 = _1757 + -0.054999999701976776f;
                    _1760 = _1758;
                  }
                  bool _1761 = !(_1684 <= 0.0031308000907301903f);
                  do {
                    if (!_1761) {
                      float _1763 = _1684 * 12.920000076293945f;
                      _1771 = _1763;
                    } else {
                      float _1765 = log2(_1684);
                      float _1766 = _1765 * 0.4166666567325592f;
                      float _1767 = exp2(_1766);
                      float _1768 = _1767 * 1.0549999475479126f;
                      float _1769 = _1768 + -0.054999999701976776f;
                      _1771 = _1769;
                    }
                    bool _1772 = !(_1685 <= 0.0031308000907301903f);
                    do {
                      if (!_1772) {
                        float _1774 = _1685 * 12.920000076293945f;
                        _1782 = _1774;
                      } else {
                        float _1776 = log2(_1685);
                        float _1777 = _1776 * 0.4166666567325592f;
                        float _1778 = exp2(_1777);
                        float _1779 = _1778 * 1.0549999475479126f;
                        float _1780 = _1779 + -0.054999999701976776f;
                        _1782 = _1780;
                      }
                      float4 _1783 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1760, _1771, _1782), 0.0f);

#if 1
                      _1783.rgb = LUTBlackCorrection(float3(_1683, _1684, _1685), _1783.rgb, tTextureMap2, lut_config);
#else
                      float3 lutVanilla = _1783.rgb;

                      float3 lutInputColor = float3(_1683, _1684, _1685);
                      renodx::lut::Config lut_config = renodx::lut::config::Create(
                          TrilinearClamp,
                          1.f,
                          1.f,
                          renodx::lut::config::type::SRGB,
                          renodx::lut::config::type::LINEAR,
                          1 / ColorCorrectTexture_000w);
                      float3 lutCorrectedBlack = renodx::lut::Sample(tTextureMap2, lut_config, lutInputColor);

                      // blend with vanilla
                      // needed to prevent crushing with srgb -> 2.2 conversion later
                      float RestorationScale = 1.0f;
                      float RestorationPower = 0.25f;
                      _1783.rgb = lerp(lutCorrectedBlack, max(lutVanilla, 0), pow(saturate(lutCorrectedBlack / RestorationScale), RestorationPower));
#endif

                      float _1784 = _1783.x;
                      float _1785 = _1783.y;
                      float _1786 = _1783.z;
                      float _1787 = _1784 - _1683;
                      float _1788 = _1785 - _1684;
                      float _1789 = _1786 - _1685;
                      float _1790 = _1787 * _1612;
                      float _1791 = _1788 * _1612;
                      float _1792 = _1789 * _1612;
                      float _1793 = _1790 + _1683;
                      float _1794 = _1791 + _1684;
                      float _1795 = _1792 + _1685;
                      _1797 = _1793;
                      _1798 = _1794;
                      _1799 = _1795;
                    } while (false);
                  } while (false);
                } while (false);
              }
              float _1800 = _1797 * _1615;
              float _1801 = mad(_1798, _1619, _1800);
              float _1802 = mad(_1799, _1623, _1801);
              float _1803 = _1802 + _1627;
              float _1804 = _1797 * _1616;
              float _1805 = mad(_1798, _1620, _1804);
              float _1806 = mad(_1799, _1624, _1805);
              float _1807 = _1806 + _1628;
              float _1808 = _1797 * _1617;
              float _1809 = mad(_1798, _1621, _1808);
              float _1810 = mad(_1799, _1625, _1809);
              float _1811 = _1810 + _1629;
              _1817 = _1803;
              _1818 = _1807;
              _1819 = _1811;
              if (_1632) {
                float _1813 = _1803 * _1631;
                float _1814 = _1807 * _1631;
                float _1815 = _1811 * _1631;
                _1817 = _1813;
                _1818 = _1814;
                _1819 = _1815;
              }
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  }
  int _1820 = _30 & 8;
  bool _1821 = (_1820 == 0);
  _1854 = _1817;
  _1855 = _1818;
  _1856 = _1819;
  if (!_1821) {
    float _1824 = ColorDeficientTable_000x;
    float _1825 = ColorDeficientTable_000y;
    float _1826 = ColorDeficientTable_000z;
    float _1828 = ColorDeficientTable_001x;
    float _1829 = ColorDeficientTable_001y;
    float _1830 = ColorDeficientTable_001z;
    float _1832 = ColorDeficientTable_002x;
    float _1833 = ColorDeficientTable_002y;
    float _1834 = ColorDeficientTable_002z;
    float _1835 = _1824 * _1817;
    float _1836 = _1825 * _1818;
    float _1837 = _1835 + _1836;
    float _1838 = _1826 * _1819;
    float _1839 = _1837 + _1838;
    float _1840 = _1828 * _1817;
    float _1841 = _1829 * _1818;
    float _1842 = _1840 + _1841;
    float _1843 = _1830 * _1819;
    float _1844 = _1842 + _1843;
    float _1845 = _1832 * _1817;
    float _1846 = _1833 * _1818;
    float _1847 = _1845 + _1846;
    float _1848 = _1834 * _1819;
    float _1849 = _1847 + _1848;
    float _1850 = saturate(_1839);
    float _1851 = saturate(_1844);
    float _1852 = saturate(_1849);
    _1854 = _1850;
    _1855 = _1851;
    _1856 = _1852;
  }
  int _1857 = _30 & 16;
  bool _1858 = (_1857 == 0);
  _1925 = _1854;
  _1926 = _1855;
  _1927 = _1856;
  if (!_1858) {
    float _1861 = ImagePlaneParam_000x;
    float _1862 = ImagePlaneParam_000y;
    float _1863 = ImagePlaneParam_000z;
    float _1864 = ImagePlaneParam_000w;
    float _1866 = ImagePlaneParam_001x;
    float _1867 = ImagePlaneParam_001y;
    float _1869 = SceneInfo_023z;
    float _1870 = SceneInfo_023w;
    float _1871 = _1869 * _27;
    float _1872 = _1870 * _28;
    float4 _1873 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1871, _1872), 0.0f);
    float _1874 = _1873.x;
    float _1875 = _1873.y;
    float _1876 = _1873.z;
    float _1877 = _1873.w;
    float _1878 = _1874 * _1861;
    float _1879 = _1875 * _1862;
    float _1880 = _1876 * _1863;
    float _1881 = _1877 * _1864;
    float _1882 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1871, _1872), 0.0f);
    float _1883 = _1882.x;
    float _1884 = _1883 * _1866;
    float _1885 = _1884 + _1867;
    float _1886 = saturate(_1885);
    float _1887 = _1881 * _1886;
    bool _1888 = (_1878 < 0.5f);
    bool _1889 = (_1879 < 0.5f);
    bool _1890 = (_1880 < 0.5f);
    float _1891 = _1854 * 2.0f;
    float _1892 = _1891 * _1878;
    float _1893 = _1855 * 2.0f;
    float _1894 = _1893 * _1879;
    float _1895 = _1856 * 2.0f;
    float _1896 = _1895 * _1880;
    float _1897 = 1.0f - _1878;
    float _1898 = 1.0f - _1879;
    float _1899 = 1.0f - _1880;
    float _1900 = 1.0f - _1854;
    float _1901 = 1.0f - _1855;
    float _1902 = 1.0f - _1856;
    float _1903 = _1900 * 2.0f;
    float _1904 = _1903 * _1897;
    float _1905 = _1901 * 2.0f;
    float _1906 = _1905 * _1898;
    float _1907 = _1902 * 2.0f;
    float _1908 = _1907 * _1899;
    float _1909 = 1.0f - _1904;
    float _1910 = 1.0f - _1906;
    float _1911 = 1.0f - _1908;
    float _1912 = _1888 ? _1892 : _1909;
    float _1913 = _1889 ? _1894 : _1910;
    float _1914 = _1890 ? _1896 : _1911;
    float _1915 = _1912 - _1854;
    float _1916 = _1913 - _1855;
    float _1917 = _1914 - _1856;
    float _1918 = _1915 * _1887;
    float _1919 = _1916 * _1887;
    float _1920 = _1917 * _1887;
    float _1921 = _1918 + _1854;
    float _1922 = _1919 + _1855;
    float _1923 = _1920 + _1856;
    _1925 = _1921;
    _1926 = _1922;
    _1927 = _1923;
  }
  SV_Target.x = _1925;
  SV_Target.y = _1926;
  SV_Target.z = _1927;
  SV_Target.w = 0.0f;

#if 1 // Take only hues and saturation from gamma correction
  float3 gammaCorrectedColor = renodx::color::correct::GammaSafe(SV_Target.rgb);
  SV_Target.rgb = HueSatCorrection(SV_Target.rgb, gammaCorrectedColor);
#endif
  return SV_Target;
}
