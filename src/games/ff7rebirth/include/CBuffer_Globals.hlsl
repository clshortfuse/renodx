/*
struct Globals
{
    float4 PostprocessInput0Size;                 ; Offset:    0
    float4 PostprocessInput1Size;                 ; Offset:   16
    float4 PostprocessInput2Size;                 ; Offset:   32
    float4 PostprocessInput3Size;                 ; Offset:   48
    float4 PostprocessInput4Size;                 ; Offset:   64
    float4 PostprocessInput5Size;                 ; Offset:   80
    float4 PostprocessInput6Size;                 ; Offset:   96
    float4 PostprocessInput7Size;                 ; Offset:  112
    float4 PostprocessInput8Size;                 ; Offset:  128
    float4 PostprocessInput9Size;                 ; Offset:  144
    float4 PostprocessInput10Size;                ; Offset:  160
    float4 PostprocessInput0MinMax;               ; Offset:  176
    float4 PostprocessInput1MinMax;               ; Offset:  192
    float4 PostprocessInput2MinMax;               ; Offset:  208
    float4 PostprocessInput3MinMax;               ; Offset:  224
    float4 PostprocessInput4MinMax;               ; Offset:  240
    float4 PostprocessInput5MinMax;               ; Offset:  256
    float4 PostprocessInput6MinMax;               ; Offset:  272
    float4 PostprocessInput7MinMax;               ; Offset:  288
    float4 PostprocessInput8MinMax;               ; Offset:  304
    float4 PostprocessInput9MinMax;               ; Offset:  320
    float4 PostprocessInput10MinMax;              ; Offset:  336
    float4 ViewportSize;                          ; Offset:  352
    uint4 ViewportRect;                           ; Offset:  368
    float4 ScreenPosToPixel;                      ; Offset:  384
    float4 SceneColorBufferUVViewport;            ; Offset:  400
    float3 MappingPolynomial;                     ; Offset:  416
    float2 ViewportColor_Extent;                  ; Offset:  432
    float2 ViewportColor_ExtentInverse;           ; Offset:  440
    float2 ViewportColor_ScreenPosToViewportScale;; Offset:  448
    float2 ViewportColor_ScreenPosToViewportBias; ; Offset:  456
    uint2 ViewportColor_ViewportMin;              ; Offset:  464
    uint2 ViewportColor_ViewportMax;              ; Offset:  472
    float2 ViewportColor_ViewportSize;            ; Offset:  480
    float2 ViewportColor_ViewportSizeInverse;     ; Offset:  488
    float2 ViewportColor_UVViewportMin;           ; Offset:  496
    float2 ViewportColor_UVViewportMax;           ; Offset:  504
    float2 ViewportColor_UVViewportSize;          ; Offset:  512
    float2 ViewportColor_UVViewportSizeInverse;   ; Offset:  520
    float2 ViewportColor_UVViewportBilinearMin;   ; Offset:  528
    float2 ViewportColor_UVViewportBilinearMax;   ; Offset:  536
    float2 ViewportGlare_Extent;                  ; Offset:  544
    float2 ViewportGlare_ExtentInverse;           ; Offset:  552
    float2 ViewportGlare_ScreenPosToViewportScale;; Offset:  560
    float2 ViewportGlare_ScreenPosToViewportBias; ; Offset:  568
    uint2 ViewportGlare_ViewportMin;              ; Offset:  576
    uint2 ViewportGlare_ViewportMax;              ; Offset:  584
    float2 ViewportGlare_ViewportSize;            ; Offset:  592
    float2 ViewportGlare_ViewportSizeInverse;     ; Offset:  600
    float2 ViewportGlare_UVViewportMin;           ; Offset:  608
    float2 ViewportGlare_UVViewportMax;           ; Offset:  616
    float2 ViewportGlare_UVViewportSize;          ; Offset:  624
    float2 ViewportGlare_UVViewportSizeInverse;   ; Offset:  632
    float2 ViewportGlare_UVViewportBilinearMin;   ; Offset:  640
    float2 ViewportGlare_UVViewportBilinearMax;   ; Offset:  648
    float2 ViewportDestination_Extent;            ; Offset:  656
    float2 ViewportDestination_ExtentInverse;     ; Offset:  664
    float2 ViewportDestination_ScreenPosToViewportScale;; Offset:  672
    float2 ViewportDestination_ScreenPosToViewportBias;; Offset:  680
    uint2 ViewportDestination_ViewportMin;        ; Offset:  688
    uint2 ViewportDestination_ViewportMax;        ; Offset:  696
    float2 ViewportDestination_ViewportSize;      ; Offset:  704
    float2 ViewportDestination_ViewportSizeInverse;; Offset:  712
    float2 ViewportDestination_UVViewportMin;     ; Offset:  720
    float2 ViewportDestination_UVViewportMax;     ; Offset:  728
    float2 ViewportDestination_UVViewportSize;    ; Offset:  736
    float2 ViewportDestination_UVViewportSizeInverse;; Offset:  744
    float2 ViewportDestination_UVViewportBilinearMin;; Offset:  752
    float2 ViewportDestination_UVViewportBilinearMax;; Offset:  760
    float4 VignetteContext;                       ; Offset:  768
    float4 GlareContext;                          ; Offset:  784
    float4 NoiseContext;                          ; Offset:  800
    float4 HDRCompositionContext;                 ; Offset:  816
    float4 HDRCompositionContextColor;            ; Offset:  832
    float4 CompositeSurfaceContext;               ; Offset:  848
    float4 DeviceCorrectorContext;                ; Offset:  864
} Globals;                                       ; Offset:    0 Size:   880
*/
cbuffer Globals : register(b0) {
  float Globals_027z : packoffset(c027.z);
  float Globals_027w : packoffset(c027.w);
  uint Globals_029x : packoffset(c029.x);
  uint Globals_029y : packoffset(c029.y);
  float Globals_030x : packoffset(c030.x);
  float Globals_030y : packoffset(c030.y);
  float Globals_033x : packoffset(c033.x);
  float Globals_033y : packoffset(c033.y);
  float Globals_033z : packoffset(c033.z);
  float Globals_033w : packoffset(c033.w);
  float Globals_034z : packoffset(c034.z);
  float Globals_034w : packoffset(c034.w);
  uint Globals_036x : packoffset(c036.x);
  uint Globals_036y : packoffset(c036.y);
  float Globals_037x : packoffset(c037.x);
  float Globals_037y : packoffset(c037.y);
  float Globals_040x : packoffset(c040.x);
  float Globals_040y : packoffset(c040.y);
  float Globals_040z : packoffset(c040.z);
  float Globals_040w : packoffset(c040.w);
  uint Globals_043x : packoffset(c043.x);
  uint Globals_043y : packoffset(c043.y);
  float Globals_044x : packoffset(c044.x);
  float Globals_044y : packoffset(c044.y);
  float Globals_044z : packoffset(c044.z);
  float Globals_044w : packoffset(c044.w);
  float Globals_048x : packoffset(c048.x);
  float Globals_048y : packoffset(c048.y);
  float Globals_049x : packoffset(c049.x);
  float Globals_054z : packoffset(c054.z);
};