Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0);

Texture2D<float4> ColorTexture : register(t1);

Texture2D<float4> GlareTexture : register(t2);

Texture2D<float4> CompositeSDRTexture : register(t3);

Texture2D<float4> CompositeSurfaceTexture : register(t4);

Texture3D<float4> BT709PQToBT2020PQLUT : register(t5);
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
  float Globals_053x : packoffset(c053.x);
  float Globals_053y : packoffset(c053.y);
  float Globals_054z : packoffset(c054.z);
};

cbuffer View : register(b1) {
  uint View_175x : packoffset(c175.x);
};

SamplerState View_SharedBilinearClampedSampler : register(s0);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  bool _19 = !((Globals_054z) == 0.0f);
  float _35 = (SV_Position.x) - (float((uint)(Globals_043x)));
  float _36 = (SV_Position.y) - (float((uint)(Globals_043y)));
  float _42 = saturate((_35 * (Globals_044z)));
  float _43 = saturate((_36 * (Globals_044w)));
  float _56 = (_19 ? (saturate(((Globals_044z) * (((floor((_35 * 0.5f))) * 2.0f) + 1.0f)))) : _42);
  float _57 = (_19 ? (saturate(((((floor((_36 * 0.5f))) * 2.0f) + 1.0f) * (Globals_044w)))) : _43);
  float _118 = min((((Globals_044w) * (Globals_044x)) * 0.5625f), 1.0f);
  float _119 = min((((Globals_044z) * (Globals_044y)) * 1.7777777910232544f), 1.0f);
  float4 _126 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_030x) * _56) + (float((uint)(Globals_029x)))) * (Globals_027z)), (Globals_033x))), (Globals_033z))), (min((max(((((Globals_030y) * _57) + (float((uint)(Globals_029y)))) * (Globals_027w)), (Globals_033y))), (Globals_033w)))), 0.0f);
  float _138 = (1.0f / (max(0.0010000000474974513f, (Globals_048y)))) * (TEXCOORD_1.z);
  float _143 = (_138 * _138) * (1.0f / (max(9.999999747378752e-06f, (dot(float3((TEXCOORD_1.x), (TEXCOORD_1.y), _138), float3((TEXCOORD_1.x), (TEXCOORD_1.y), _138))))));
  float _147 = (((_143 * _143) + -1.0f) * (Globals_048x)) + 1.0f;
  float _148 = _147 * (min((_126.x), 65504.0f));
  float _149 = _147 * (min((_126.y), 65504.0f));
  float _150 = _147 * (min((_126.z), 65504.0f));
  float4 _152 = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_037x) * _56) + (float((uint)(Globals_036x)))) * (Globals_034z)), (Globals_040x))), (Globals_040z))), (min((max(((((Globals_037y) * _57) + (float((uint)(Globals_036y)))) * (Globals_034w)), (Globals_040y))), (Globals_040w)))), 0.0f);
  float _181 = exp2(((log2((saturate(((((Globals_049x) * (((min((_152.x), 65504.0f)) - _148) + (_148 * (_152.w)))) + _148) * 0.009999999776482582f))))) * 0.1593017578125f));
  float _197 = exp2(((log2((saturate(((((Globals_049x) * (((min((_152.y), 65504.0f)) - _149) + (_149 * (_152.w)))) + _149) * 0.009999999776482582f))))) * 0.1593017578125f));
  float _213 = exp2(((log2((saturate(((((Globals_049x) * (((_150 * (_152.w)) - _150) + (min((_152.z), 65504.0f)))) + _150) * 0.009999999776482582f))))) * 0.1593017578125f));
  float4 _232 = BT709PQToBT2020PQLUT.SampleLevel(View_SharedBilinearClampedSampler, float3((((saturate((exp2(((log2((max(0.0f, (((_181 * 18.8515625f) + 0.8359375f) * (1.0f / ((_181 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_197 * 18.8515625f) + 0.8359375f) * (1.0f / ((_197 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_213 * 18.8515625f) + 0.8359375f) * (1.0f / ((_213 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f)), 0.0f);
  float _239 = exp2(((log2((saturate((_232.x))))) * 0.012683313339948654f));
  float _253 = exp2(((log2((saturate((_232.y))))) * 0.012683313339948654f));
  float _267 = exp2(((log2((saturate((_232.z))))) * 0.012683313339948654f));
  float _307;
  float _318;
  float _329;
  float _346 = ((exp2(((log2((max(0.0f, ((_239 + -0.8359375f) * (1.0f / (18.8515625f - (_239 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f);
  float _347 = ((exp2(((log2((max(0.0f, ((_253 + -0.8359375f) * (1.0f / (18.8515625f - (_253 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f);
  float _348 = ((exp2(((log2((max(0.0f, ((_267 + -0.8359375f) * (1.0f / (18.8515625f - (_267 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f);
  float _366;
  float _377;
  float _388;
  if ((!((Globals_053x) == 0.0f))) {
    float4 _292 = CompositeSurfaceTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(((_118 * (_56 + -0.5f)) + 0.5f), ((_119 * (_57 + -0.5f)) + 0.5f)), 0.0f);
    _346 = (_292.x);
    _347 = (_292.y);
    _348 = (_292.z);
    if (!(!((Globals_053y) == 0.0f))) {
      do {
        if ((((_292.x) < 0.0031308000907301903f))) {
          _307 = ((_292.x) * 12.920000076293945f);
        } else {
          _307 = (((exp2(((log2((_292.x))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if ((((_292.y) < 0.0031308000907301903f))) {
            _318 = ((_292.y) * 12.920000076293945f);
          } else {
            _318 = (((exp2(((log2((_292.y))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            if ((((_292.z) < 0.0031308000907301903f))) {
              _329 = ((_292.z) * 12.920000076293945f);
            } else {
              _329 = (((exp2(((log2((_292.z))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            float _336 = exp2(((log2(_307)) * 2.200000047683716f));
            float _337 = exp2(((log2(_318)) * 2.200000047683716f));
            float _338 = exp2(((log2(_329)) * 2.200000047683716f));
            _346 = ((dot(float3(0.6274039149284363f, 0.3292829990386963f, 0.043313100934028625f), float3(_336, _337, _338))) * 250.0f);
            _347 = ((dot(float3(0.06909730285406113f, 0.9195405840873718f, 0.011362300254404545f), float3(_336, _337, _338))) * 250.0f);
            _348 = ((dot(float3(0.01639140024781227f, 0.08801329880952835f, 0.8955953121185303f), float3(_336, _337, _338))) * 250.0f);
          } while (false);
        } while (false);
      } while (false);
    }
  }
  float4 _351 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(((_118 * (_42 + -0.5f)) + 0.5f), ((_119 * (_43 + -0.5f)) + 0.5f)), 0.0f);
  if ((((_351.x) < 0.0031308000907301903f))) {
    _366 = ((_351.x) * 12.920000076293945f);
  } else {
    _366 = (((exp2(((log2((_351.x))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if ((((_351.y) < 0.0031308000907301903f))) {
    _377 = ((_351.y) * 12.920000076293945f);
  } else {
    _377 = (((exp2(((log2((_351.y))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if ((((_351.z) < 0.0031308000907301903f))) {
    _388 = ((_351.z) * 12.920000076293945f);
  } else {
    _388 = (((exp2(((log2((_351.z))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _389 = (_351.w) * (_351.w);
  float _396 = 1.0f / ((_346 * 0.004000000189989805f) + 1.0f);
  float _397 = 1.0f / ((_347 * 0.004000000189989805f) + 1.0f);
  float _398 = 1.0f / ((_348 * 0.004000000189989805f) + 1.0f);
  float _420 = exp2(((log2(_366)) * 2.200000047683716f));
  float _421 = exp2(((log2(_377)) * 2.200000047683716f));
  float _422 = exp2(((log2(_388)) * 2.200000047683716f));
  float _436 = exp2(((log2((saturate(((((dot(float3(0.6274039149284363f, 0.3292829990386963f, 0.043313100934028625f), float3(_420, _421, _422))) * 250.0f) + (((_351.w) * _346) * (((1.0f - _396) * _389) + _396))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _447 = saturate((exp2(((log2((max(0.0f, (((_436 * 18.8515625f) + 0.8359375f) * (1.0f / ((_436 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _452 = exp2(((log2((saturate(((((dot(float3(0.06909730285406113f, 0.9195405840873718f, 0.011362300254404545f), float3(_420, _421, _422))) * 250.0f) + (((_351.w) * _347) * (((1.0f - _397) * _389) + _397))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _463 = saturate((exp2(((log2((max(0.0f, (((_452 * 18.8515625f) + 0.8359375f) * (1.0f / ((_452 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _468 = exp2(((log2((saturate(((((dot(float3(0.01639140024781227f, 0.08801329880952835f, 0.8955953121185303f), float3(_420, _421, _422))) * 250.0f) + (((_351.w) * _348) * (((1.0f - _398) * _389) + _398))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _479 = saturate((exp2(((log2((max(0.0f, (((_468 * 18.8515625f) + 0.8359375f) * (1.0f / ((_468 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _481 = ((((float4)(View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4(((int(23)) & 127), ((int(24)) & 127), (((uint)(View_175x)) & 63), 0)))).x) * 2.0f) + -1.0f;
  float _498 = ((1.0f - (sqrt((1.0f - (abs(_481)))))) * (float(((int(((bool)((_481 > 0.0f))))) - (int(((bool)((_481 < 0.0f))))))))) * 0.0009775171056389809f;
  SV_Target.x = (saturate(((((bool)((((abs(((_447 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_498 + _447) : _447))));
  SV_Target.y = (saturate(((((bool)((((abs(((_463 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_498 + _463) : _463))));
  SV_Target.z = (saturate(((((bool)((((abs(((_479 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_498 + _479) : _479))));
  SV_Target.w = 0.0f;
  return SV_Target;
}
