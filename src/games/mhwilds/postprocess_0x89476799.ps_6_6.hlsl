Texture2D<float4> HDRImage : register(t0);

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
  float SceneInfo_023z : packoffset(c023.z);
  float SceneInfo_023w : packoffset(c023.w);
};

cbuffer OCIOTransformMatrix : register(b1) {
  float OCIOTransformMatrix_000x : packoffset(c000.x);
  float OCIOTransformMatrix_000y : packoffset(c000.y);
  float OCIOTransformMatrix_000z : packoffset(c000.z);
  float OCIOTransformMatrix_001x : packoffset(c001.x);
  float OCIOTransformMatrix_001y : packoffset(c001.y);
  float OCIOTransformMatrix_001z : packoffset(c001.z);
  float OCIOTransformMatrix_002x : packoffset(c002.x);
  float OCIOTransformMatrix_002y : packoffset(c002.y);
  float OCIOTransformMatrix_002z : packoffset(c002.z);
};

/*
struct struct.RGCParam
;       {
;
;           float CyanLimit;                          ; Offset:    0
;           float MagentaLimit;                       ; Offset:    4
;           float YellowLimit;                        ; Offset:    8
;           float CyanThreshold;                      ; Offset:   12

;           float MagentaThreshold;                   ; Offset:   16
;           float YellowThreshold;                    ; Offset:   20
;           float RollOff;                            ; Offset:   24
;           uint EnableReferenceGamutCompress;        ; Offset:   28

;           float InvCyanSTerm;                       ; Offset:   32
;           float InvMagentaSTerm;                    ; Offset:   36
;           float InvYellowSTerm;                     ; Offset:   40
;           float InvRollOff;                         ; Offset:   44
;
;       } rgcParam;
 */
cbuffer RGCParamCB : register(b2) {
  float RGCParamCB_000w : packoffset(c000.w);
  float RGCParamCB_001x : packoffset(c001.x);
  float RGCParamCB_001y : packoffset(c001.y);
  float RGCParamCB_001z : packoffset(c001.z);
  uint RGCParamCB_001w : packoffset(c001.w);
  float RGCParamCB_002x : packoffset(c002.x);
  float RGCParamCB_002y : packoffset(c002.y);
  float RGCParamCB_002z : packoffset(c002.z);
  float RGCParamCB_002w : packoffset(c002.w);
};

/*
struct CameraKerare
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
;   struct TonemapParam
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
cbuffer TonemapParam : register(b4) {
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

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  float4 _22 = HDRImage.Load(int3(((uint)(uint((SV_Position.x)))), ((uint)(uint((SV_Position.y)))), 0));
  float _40 = mad((_22.z), (OCIOTransformMatrix_002x), (mad((_22.y), (OCIOTransformMatrix_001x), ((OCIOTransformMatrix_000x) * (_22.x)))));
  float _43 = mad((_22.z), (OCIOTransformMatrix_002y), (mad((_22.y), (OCIOTransformMatrix_001y), ((OCIOTransformMatrix_000y) * (_22.x)))));
  float _46 = mad((_22.z), (OCIOTransformMatrix_002z), (mad((_22.y), (OCIOTransformMatrix_001z), ((OCIOTransformMatrix_000z) * (_22.x)))));
  float _83;
  float _104;
  float _124;
  float _132 = _40;
  float _133 = _43;
  float _134 = _46;
  float _181;
  float _211;
  float _220;
  float _229;
  float _300;
  float _301;
  float _302;
  if (!((((uint)(RGCParamCB_001w)) == 0))) {
    float _52 = max((max(_40, _43)), _46);
    _132 = _40;
    _133 = _43;
    _134 = _46;
    if ((!(_52 == 0.0f))) {
      float _58 = abs(_52);
      float _59 = (_52 - _40) / _58;
      float _60 = (_52 - _43) / _58;
      float _61 = (_52 - _46) / _58;
      _83 = _59;
      do {
        if (!(!(_59 >= (RGCParamCB_000w)))) {
          float _71 = _59 - (RGCParamCB_000w);
          _83 = ((_71 / (exp2(((log2(((exp2(((log2((_71 * (RGCParamCB_002x)))) * (RGCParamCB_001z)))) + 1.0f))) * (RGCParamCB_002w))))) + (RGCParamCB_000w));
        }
        _104 = _60;
        do {
          if (!(!(_60 >= (RGCParamCB_001x)))) {
            float _92 = _60 - (RGCParamCB_001x);
            _104 = ((_92 / (exp2(((log2(((exp2(((log2((_92 * (RGCParamCB_002y)))) * (RGCParamCB_001z)))) + 1.0f))) * (RGCParamCB_002w))))) + (RGCParamCB_001x));
          }
          _124 = _61;
          do {
            if (!(!(_61 >= (RGCParamCB_001y)))) {
              float _112 = _61 - (RGCParamCB_001y);
              _124 = ((_112 / (exp2(((log2(((exp2(((log2((_112 * (RGCParamCB_002z)))) * (RGCParamCB_001z)))) + 1.0f))) * (RGCParamCB_002w))))) + (RGCParamCB_001y));
            }
            _132 = (_52 - (_58 * _83));
            _133 = (_52 - (_58 * _104));
            _134 = (_52 - (_58 * _124));
          } while (false);
        } while (false);
      } while (false);
    }
  }
  [branch]
  if ((((CameraKerare_000w) == 0.0f))) {
    float _142 = (Kerare.x) / (Kerare.w);
    float _143 = (Kerare.y) / (Kerare.w);
    float _144 = (Kerare.z) / (Kerare.w);
    float _148 = abs(((rsqrt((dot(float3(_142, _143, _144), float3(_142, _143, _144))))) * _144));
    float _153 = _148 * _148;
    _181 = ((_153 * _153) * (1.0f - (saturate((((CameraKerare_000x)*_148) + (CameraKerare_000y))))));
  } else {
    float _164 = (((SceneInfo_023w) * (SV_Position.y)) + -0.5f) * 2.0f;
    float _166 = ((CameraKerare_000w) * 2.0f) * (((SceneInfo_023z) * (SV_Position.x)) + -0.5f);
    float _168 = sqrt((dot(float2(_166, _164), float2(_166, _164))));
    float _176 = (_168 * _168) + 1.0f;
    _181 = ((1.0f / (_176 * _176)) * (1.0f - (saturate((((CameraKerare_000x) * (1.0f / (_168 + 1.0f))) + (CameraKerare_000y))))));
  }
  float _183 = saturate((_181 + (CameraKerare_000z)));
  float _185 = (_132 * (Exposure)) * _183;
  float _187 = (_133 * (Exposure)) * _183;
  float _189 = (_134 * (Exposure)) * _183;
  bool _192 = isfinite((max((max(_185, _187)), _189)));
  float _193 = (_192 ? _185 : 1.0f);
  float _194 = (_192 ? _187 : 1.0f);
  float _195 = (_192 ? _189 : 1.0f);
  _300 = _193;
  _301 = _194;
  _302 = _195;
  if ((((TonemapParam_002w) == 0.0f))) {
    float _203 = (TonemapParam_002y)*_193;
    _211 = 1.0f;
    do {
      if ((!(_193 >= (TonemapParam_000y)))) {
        _211 = ((_203 * _203) * (3.0f - (_203 * 2.0f)));
      }
      float _212 = (TonemapParam_002y)*_194;
      _220 = 1.0f;
      do {
        if ((!(_194 >= (TonemapParam_000y)))) {
          _220 = ((_212 * _212) * (3.0f - (_212 * 2.0f)));
        }
        float _221 = (TonemapParam_002y)*_195;
        _229 = 1.0f;
        do {
          if ((!(_195 >= (TonemapParam_000y)))) {
            _229 = ((_221 * _221) * (3.0f - (_221 * 2.0f)));
          }
          float _238 = (((bool)((_193 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          float _239 = (((bool)((_194 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          float _240 = (((bool)((_195 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          _300 = ((((((TonemapParam_000x)*_193) + (TonemapParam_002z)) * (_211 - _238)) + (((exp2(((log2(_203)) * (TonemapParam_000w)))) * (1.0f - _211)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*_193) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _238));
          _301 = ((((((TonemapParam_000x)*_194) + (TonemapParam_002z)) * (_220 - _239)) + (((exp2(((log2(_212)) * (TonemapParam_000w)))) * (1.0f - _220)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*_194) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _239));
          _302 = ((((((TonemapParam_000x)*_195) + (TonemapParam_002z)) * (_229 - _240)) + (((exp2(((log2(_221)) * (TonemapParam_000w)))) * (1.0f - _229)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*_195) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _240));
        } while (false);
      } while (false);
    } while (false);
  }
  SV_Target.x = _300;
  SV_Target.y = _301;
  SV_Target.z = _302;
  SV_Target.rgb *= 3;
  SV_Target.w = 1.0f;
  return SV_Target;
}
