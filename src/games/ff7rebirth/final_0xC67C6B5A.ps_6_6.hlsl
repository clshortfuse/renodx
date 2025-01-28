#include "./common.hlsl"

Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0);

Texture2D<float4> ColorTexture : register(t1);

Texture2D<float4> GlareTexture : register(t2);

Texture2D<float4> CompositeSDRTexture : register(t3);

Texture3D<float4> BT709PQToBT2020PQLUT : register(t4);
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

cbuffer View : register(b1) {
  uint View_175x : packoffset(c175.x);
};

SamplerState View_SharedBilinearClampedSampler : register(s0);

float getMidGray() {
  float3 inMidGray = (0.18f, 0.18f, 0.18f);  // use ACES mid gray
  float3 lutInputColor = saturate(renodx::color::pq::Encode(inMidGray, 100.f));
  float3 lutResult = renodx::lut::Sample(BT709PQToBT2020PQLUT, View_SharedBilinearClampedSampler, lutInputColor, 32u);
  float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(lutResult, 250);

  float outMidGray = renodx::color::y::from::BT2020(lutOutputColor_bt2020);
  return outMidGray;
}

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 TEXCOORD_1: TEXCOORD1,
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  bool _18 = !((Globals_054z) == 0.0f);
  float _34 = (SV_Position.x) - (float((uint)(Globals_043x)));
  float _35 = (SV_Position.y) - (float((uint)(Globals_043y)));
  float _41 = saturate((_34 * (Globals_044z)));
  float _42 = saturate((_35 * (Globals_044w)));
  float _55 = (_18 ? (saturate(((Globals_044z) * (((floor((_34 * 0.5f))) * 2.0f) + 1.0f)))) : _41);
  float _56 = (_18 ? (saturate(((((floor((_35 * 0.5f))) * 2.0f) + 1.0f) * (Globals_044w)))) : _42);

  // main color
  float4 _125 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_030x)*_55) + (float((uint)(Globals_029x)))) * (Globals_027z)), (Globals_033x))), (Globals_033z))), (min((max(((((Globals_030y)*_56) + (float((uint)(Globals_029y)))) * (Globals_027w)), (Globals_033y))), (Globals_033w)))), 0.0f);

  float _137 = (1.0f / (max(0.0010000000474974513f, (Globals_048y)))) * (TEXCOORD_1.z);
  float _142 = (_137 * _137) * (1.0f / (max(9.999999747378752e-06f, (dot(float3((TEXCOORD_1.x), (TEXCOORD_1.y), _137), float3((TEXCOORD_1.x), (TEXCOORD_1.y), _137))))));
  float _146 = (((_142 * _142) + -1.0f) * (Globals_048x)) + 1.0f;
  float _147 = _146 * (min((_125.x), 65504.0f));
  float _148 = _146 * (min((_125.y), 65504.0f));
  float _149 = _146 * (min((_125.z), 65504.0f));

  float3 main_color = float3(_147, _148, _149);

  // // glare
  // float4 _151 = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_037x) * _55) + (float((uint)(Globals_036x)))) * (Globals_034z)), (Globals_040x))), (Globals_040z))), (min((max(((((Globals_037y) * _56) + (float((uint)(Globals_036y)))) * (Globals_034w)), (Globals_040y))), (Globals_040w)))), 0.0f);
  // float _180 = exp2(((log2((saturate(((((Globals_049x) * (((min((_151.x), 65504.0f)) - _147) + (_147 * (_151.w)))) + _147) * 0.009999999776482582f))))) * 0.1593017578125f));
  // float _196 = exp2(((log2((saturate(((((Globals_049x) * (((min((_151.y), 65504.0f)) - _148) + (_148 * (_151.w)))) + _148) * 0.009999999776482582f))))) * 0.1593017578125f));
  // float _212 = exp2(((log2((saturate(((((Globals_049x) * (((_149 * (_151.w)) - _149) + (min((_151.z), 65504.0f)))) + _149) * 0.009999999776482582f))))) * 0.1593017578125f));
  // // LUT
  // float4 _231 = BT709PQToBT2020PQLUT.SampleLevel(View_SharedBilinearClampedSampler, float3((((saturate((exp2(((log2((max(0.0f, (((_180 * 18.8515625f) + 0.8359375f) * (1.0f / ((_180 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_196 * 18.8515625f) + 0.8359375f) * (1.0f / ((_196 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_212 * 18.8515625f) + 0.8359375f) * (1.0f / ((_212 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f)), 0.0f);
  // float _238 = exp2(((log2((saturate((_231.x))))) * 0.012683313339948654f));
  // float _247 = exp2(((log2((max(0.0f, ((_238 + -0.8359375f) * (1.0f / (18.8515625f - (_238 * 18.6875f)))))))) * 6.277394771575928f));
  // float _252 = exp2(((log2((saturate((_231.y))))) * 0.012683313339948654f));
  // float _261 = exp2(((log2((max(0.0f, ((_252 + -0.8359375f) * (1.0f / (18.8515625f - (_252 * 18.6875f)))))))) * 6.277394771575928f));
  // float _266 = exp2(((log2((saturate((_231.z))))) * 0.012683313339948654f));
  // float _275 = exp2(((log2((max(0.0f, ((_266 + -0.8359375f) * (1.0f / (18.8515625f - (_266 * 18.6875f)))))))) * 6.277394771575928f));

  float2 glareUV = float2(
      clamp(((Globals_037x * _55) + (float)((uint)Globals_036x)) * Globals_034z,
            Globals_040x,
            Globals_040z),
      clamp(((Globals_037y * _56) + (float)((uint)Globals_036y)) * Globals_034w,
            Globals_040y,
            Globals_040w));
  float4 glareSample = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, glareUV, 0.0f);
  float3 glareColor = min(glareSample.xyz, 65504.0f);
  float3 ungraded_bt709 = (Globals_049x * ((glareColor - main_color) + main_color * glareSample.w) + main_color);
  float3 lutInputColor = saturate(renodx::color::pq::EncodeSafe(ungraded_bt709, 100.f));
  float3 lutResult = renodx::lut::Sample(BT709PQToBT2020PQLUT, View_SharedBilinearClampedSampler, lutInputColor, 32u);

  float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(lutResult);
  float3 tonemapped = lutOutputColor_bt2020;

#if 1
  tonemapped = extractColorGradeAndApplyTonemap(ungraded_bt709, lutOutputColor_bt2020, getMidGray());
#endif

  float _247 = tonemapped.r, _261 = tonemapped.g, _275 = tonemapped.b;

  // UI + sRGB -> 2.2  gamma correction
  float4 _278 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((((min((((Globals_044x) * 0.5625f) * (Globals_044w)), 1.0f)) * (_41 + -0.5f)) + 0.5f), (((min((((Globals_044y) * 1.7777777910232544f) * (Globals_044z)), 1.0f)) * (_42 + -0.5f)) + 0.5f)), 0.0f);
  float3 gammaCorrectedUI = renodx::color::correct::Gamma(max(0, _278.xyz));
  float _347 = gammaCorrectedUI.r;
  float _348 = gammaCorrectedUI.g;
  float _349 = gammaCorrectedUI.b;

  // UI Blending
  float _316 = (_278.w) * (_278.w);
  float _323 = 1.0f / ((_247 * 40.0f) + 1.0f);
  float _324 = 1.0f / ((_261 * 40.0f) + 1.0f);
  float _325 = 1.0f / ((_275 * 40.0f) + 1.0f);

  float _363 = exp2(((log2((saturate(((((dot(float3(0.6274039149284363f, 0.3292829990386963f, 0.043313100934028625f), float3(_347, _348, _349)))*RENODX_GRAPHICS_WHITE_NITS) + (((_247 * 10000.0f) * (_278.w)) * (((1.0f - _323) * _316) + _323))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _374 = saturate((exp2(((log2((max(0.0f, (((_363 * 18.8515625f) + 0.8359375f) * (1.0f / ((_363 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _379 = exp2(((log2((saturate(((((dot(float3(0.06909730285406113f, 0.9195405840873718f, 0.011362300254404545f), float3(_347, _348, _349)))*RENODX_GRAPHICS_WHITE_NITS) + (((_261 * 10000.0f) * (_278.w)) * (((1.0f - _324) * _316) + _324))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _390 = saturate((exp2(((log2((max(0.0f, (((_379 * 18.8515625f) + 0.8359375f) * (1.0f / ((_379 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _395 = exp2(((log2((saturate(((((dot(float3(0.01639140024781227f, 0.08801329880952835f, 0.8955953121185303f), float3(_347, _348, _349)))*RENODX_GRAPHICS_WHITE_NITS) + (((_275 * 10000.0f) * (_278.w)) * (((1.0f - _325) * _316) + _325))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _406 = saturate((exp2(((log2((max(0.0f, (((_395 * 18.8515625f) + 0.8359375f) * (1.0f / ((_395 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _408 = ((((float4)(View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4(((int(22)) & 127), ((int(23)) & 127), (((uint)(View_175x)) & 63), 0)))).x) * 2.0f) + -1.0f;
  float _425 = ((1.0f - (sqrt((1.0f - (abs(_408)))))) * (float(((int(((bool)((_408 > 0.0f))))) - (int(((bool)((_408 < 0.0f))))))))) * 0.0009775171056389809f;
  SV_Target.x = (saturate(((((bool)((((abs(((_374 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_425 + _374) : _374))));
  SV_Target.y = (saturate(((((bool)((((abs(((_390 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_425 + _390) : _390))));
  SV_Target.z = (saturate(((((bool)((((abs(((_406 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_425 + _406) : _406))));
  SV_Target.w = 0.0f;
  return SV_Target;
}
