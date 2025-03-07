#include "./shared.h"

static const float _28[3] = { 0.0f, 1.384615421295166015625f, 3.23076915740966796875f };

static const float _34[3] = { 0.2270270287990570068359375f, 0.3162162303924560546875f, 0.0702702701091766357421875f };

/* ;   struct Tonemap
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
;   } Tonemap;                                        ; Offset:    0 Size:    96
;
; } */

cbuffer TonemapUBO : register(b0, space0) {
  float4 Tonemap_m0[6] : packoffset(c0);
};

Texture2D<float> LuminanceSRV : register(t0, space0);

static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  noperspective float4 SV_Position : SV_Position;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  uint4 _48 = asuint(Tonemap_m0[5u]);  // .zw=LELuminanceTextureSize
   
  float _71;
  uint _73;
  float originalLuminance = LuminanceSRV.Load(int3(uint2(uint(((TEXCOORD.x * 64.0f) * float(int(_48.z))) + 0.5f) >> 6u, uint(((TEXCOORD.y * 64.0f) * float(int(_48.w))) + 0.5f) >> 6u), 0u)).x;
  _71 = originalLuminance * 0.2270270287990570068359375f;
  _73 = 1u;
  float _72;
  for (;;) {
    // uint4 _80 = asuint(Tonemap_m0[5u]);
    uint4 _80 = _48;

    float _82 = float(int(_80.w));
    float _83 = _28[_73] / _82;
    float _88 = abs(TEXCOORD.x);
    float _89 = abs(_83 + TEXCOORD.y);
    min16float _93 = min16float(frac(_88));
    min16float _94 = min16float(frac(_89));
    float _101 = float((_88 > 1.0f) ? (min16float(1.0) - _93) : _93);
    // uint4 _127 = asuint(Tonemap_m0[5u]);
    uint4 _127 = _48;
    float _132 = abs(TEXCOORD.y - _83);
    min16float _134 = min16float(frac(_132));
    _72 = ((LuminanceSRV.Load(int3(uint2(uint(((float(int(_80.z)) * 64.0f) * _101) + 0.5f) >> 6u, uint(((_82 * 64.0f) * float((_89 > 1.0f) ? (min16float(1.0) - _94) : _94)) + 0.5f) >> 6u), 0u)).x * _34[_73]) + _71) + (LuminanceSRV.Load(int3(uint2(uint(((float(int(_127.z)) * 64.0f) * _101) + 0.5f) >> 6u, uint(((float(int(_127.w)) * 64.0f) * float((_132 > 1.0f) ? (min16float(1.0) - _134) : _134)) + 0.5f) >> 6u), 0u)).x * _34[_73]);
    uint _74 = _73 + 1u;
    if (_74 == 3u) {
      break;
    } else {
      _71 = _72;
      _73 = _74;
    }
  }
  SV_Target.x = _72;;
  SV_Target.y = 0.0f;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
