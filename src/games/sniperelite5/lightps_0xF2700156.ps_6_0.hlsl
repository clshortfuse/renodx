#include "./shared.h"
// Baseline: 4 fewer fmul fast (dxc reassociation: (_482*_467)*_499 and (_556*_574)*_573 chains share the common product across channels), phi incoming order; otherwise identical to the original DXIL.

Texture2D<float4> g_xLighting_NormalBuffer : register(t2);

Texture2D<float4> g_xLighting_AlbedoBuffer : register(t3);

Texture2D<float4> g_xLighting_PBRPropertiesBuffer : register(t4);

Texture2D<float4> g_xLighting_DepthStencil : register(t5);

struct ProjectorParams {
  float4 m_xProjectorMatrix[4];
  float4 m_xWorldToBoundingSpace[4];
  float4 m_xProjectionDirection;
  float4 m_xDetailOffsetScale;
  float4 m_xCausticOffsets;
  float3 m_xProjectorPos;
  float m_fPad;
  float4 m_xOrientation1;
  float4 m_xOrientation2;
  float4 m_xOrientation3;
  float4 m_xPosition_UVAspect;
  float4 m_xOffsets;
  float3 m_xLightColour;
  float m_fDistanceFade;
  float m_fLightFalloffScale;
  float m_fLightFalloffPower;
  float m_fAngularFalloffOfs;
  float m_fAngularFalloffScale;
  float m_fMinRange;
  float m_fLightRange;
  float m_fShadowStrength;
  bool m_bCustomBoundingVolumeSet;
  float m_f2DFilterSize;
  float m_fCubeFilterSize;
  float m_fCubeClampWidth;
  int m_iShadowTextureIndex;
  float m_fShadowSoftness;
  float m_fShadowNearPlane;
  float m_fShadowFarPlane;
  float m_fProjectorOneOverTanHalfFov;
  float m_fShadowBias;
  float m_fSpecularStrength;
  float m_fAreaLightRadius;
  uint m_uShadowPoolLevel;
  int m_iTextureIndex;
  int m_iDetailTextureIndex;
  int m_iCausticTextureIndex;
  bool m_bIsProjector;
};

StructuredBuffer<ProjectorParams> g_axProjectors : register(t42);

cbuffer FrameConstants : register(b0) {
  float4 g_xView[4] : packoffset(c000.x);
  float4 g_xProj[4] : packoffset(c004.x);
  float4 g_xViewProj[4] : packoffset(c008.x);
  float4 g_xInvView[4] : packoffset(c012.x);
  float4 g_xInvProj[4] : packoffset(c016.x);
  float4 g_xInvViewProj[4] : packoffset(c020.x);
  float3 g_xCamPos : packoffset(c024.x);
  float g_fScaledTime : packoffset(c024.w);
  float4 g_xTwoOverScreenDimensions : packoffset(c025.x);
  float2 g_xCameraTanHalfFOV : packoffset(c026.x);
  float2 g_xCameraFarClipValues : packoffset(c026.z);
  float2 g_xRcpScreenDims : packoffset(c027.x);
  float2 g_xDepthProjViewUnpack : packoffset(c027.z);
  float4 g_axViewFrustumPlanes[6] : packoffset(c028.x);
  int4 g_xScreenDimensions : packoffset(c034.x);
  float4 g_xTessCutoffAndFactors : packoffset(c035.x);
  float g_fTessMaxDist : packoffset(c036.x);
  float g_fTessRcpRange : packoffset(c036.y);
  float g_fDisplacementScale : packoffset(c036.z);
  float g_fBackFaceCutoff : packoffset(c036.w);
  float g_fFoliageFadeInvDistance : packoffset(c037.x);
  float g_fFoliageFadePower : packoffset(c037.y);
  int g_bFoliageFadeEnabled : packoffset(c037.z);
  float g_fEnvironmentDecalBias : packoffset(c037.w);
  float g_fInstanceDecalBias : packoffset(c038.x);
  float3 g_xWindDirection : packoffset(c038.y);
  float g_fWindStrength : packoffset(c039.x);
  float3 g_xSubsurfaceScatteringWeight : packoffset(c039.y);
  float g_fGlobalSamplerBias : packoffset(c040.x);
  float3 g_xDeformationWindowCentre : packoffset(c040.y);
  float g_fDeformationWindowSize : packoffset(c041.x);
  float g_fDeformationUVDensity : packoffset(c041.y);
  float g_fDeformationNormalIntensity : packoffset(c041.z);
  float g_fRainfallIntensity : packoffset(c041.w);
  float g_fRainBaseWetness : packoffset(c042.x);
  float3 g_xRainDirection : packoffset(c042.y);
};

cbuffer ProjectorIndex : register(b4) {
  uint g_uProjectorIndex : packoffset(c000.x);
};

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float3 CamDir : CamDir
) : SV_Target {
  float4 SV_Target;
  int _13 = int(SV_Position.x);
  int _14 = int(SV_Position.y);
  float4 _15 = g_xLighting_DepthStencil.Load(int3(_13, _14, 0));
  float _21 = g_xDepthProjViewUnpack.x / (g_xDepthProjViewUnpack.y - _15.x);
  float _38 = (g_xCameraTanHalfFOV.x * _21) * (((g_xTwoOverScreenDimensions.z + SV_Position.x) * g_xTwoOverScreenDimensions.x) + -1.0f);
  float _39 = (g_xCameraTanHalfFOV.y * _21) * (((g_xTwoOverScreenDimensions.w + SV_Position.y) * g_xTwoOverScreenDimensions.y) + -1.0f);
  ProjectorParams P = g_axProjectors[g_uProjectorIndex];
  float4 _86 = g_xLighting_NormalBuffer.Load(int3(_13, _14, 0));
  float4 _91 = g_xLighting_AlbedoBuffer.Load(int3(_13, _14, 0));
  float4 _96 = g_xLighting_PBRPropertiesBuffer.Load(int3(_13, _14, 0));
  float _104 = (_86.x * 2.0f) + -1.0f;
  float _105 = (_86.y * 2.0f) + -1.0f;
  float _106 = (_86.z * 2.0f) + -1.0f;
  float _108 = rsqrt(dot(float3(_104, _105, _106), float3(_104, _105, _106)));
  float _109 = _108 * _104;
  float _110 = _108 * _105;
  float _111 = _108 * _106;
  float _114 = (_96.z * 2.0f) + -1.0f;
  float _115 = (_96.w * 2.0f) + -1.0f;
  float _119 = sqrt(saturate(1.0f - dot(float2(_114, _115), float2(_114, _115))));
  float _122 = select((_86.w != 0.0f), _119, (-0.0f - _119));
  float _124 = rsqrt(dot(float3(CamDir.x, CamDir.y, CamDir.z), float3(CamDir.x, CamDir.y, CamDir.z)));
  float _125 = _124 * CamDir.x;
  float _126 = _124 * CamDir.y;
  float _127 = _124 * CamDir.z;
  float _135 = mad(P.m_xProjectorMatrix[2].w, _21, mad(P.m_xProjectorMatrix[1].w, _39, (P.m_xProjectorMatrix[0].w * _38))) + P.m_xProjectorMatrix[3].w;
  float _279;
  float _280;
  float _281;
  float _282;
  float _342;
  float _343;
  float _344;
  float _345;
  float _346;
  float _347;
  float _348;
  float _482;
  float _507;
  float _508;
  float _509;
  float _594;
  float _595;
  float _596;
  bool _626;
  float _627;
  float _628;
  float _629;
  [branch]
  if (!((mad(P.m_xProjectorMatrix[2].z, _21, mad(P.m_xProjectorMatrix[1].z, _39, (P.m_xProjectorMatrix[0].z * _38))) + P.m_xProjectorMatrix[3].z) < 0.0f)) {
    [branch]
    if (!((bool)((0.5f - abs(((mad(P.m_xProjectorMatrix[2].x, _21, mad(P.m_xProjectorMatrix[1].x, _39, (P.m_xProjectorMatrix[0].x * _38))) + P.m_xProjectorMatrix[3].x) / _135) + -0.5f)) < 0.0f) | (bool)((0.5f - abs(((mad(P.m_xProjectorMatrix[2].y, _21, mad(P.m_xProjectorMatrix[1].y, _39, (P.m_xProjectorMatrix[0].y * _38))) + P.m_xProjectorMatrix[3].y) / _135) + -0.5f)) < 0.0f))) {
      float _192 = (P.m_xProjectorPos.x - (g_xInvView[3].x)) - mad((g_xInvView[2].x), _21, mad((g_xInvView[1].x), _39, ((g_xInvView[0].x) * _38)));
      float _194 = (P.m_xProjectorPos.y - (g_xInvView[3].y)) - mad((g_xInvView[2].y), _21, mad((g_xInvView[1].y), _39, ((g_xInvView[0].y) * _38)));
      float _196 = (P.m_xProjectorPos.z - (g_xInvView[3].z)) - mad((g_xInvView[2].z), _21, mad((g_xInvView[1].z), _39, ((g_xInvView[0].z) * _38)));
      do {
        [branch]
        if (P.m_bCustomBoundingVolumeSet) {
          float _200 = -0.0f - dot(float3(_192, _194, _196), float3(P.m_xProjectionDirection.x, P.m_xProjectionDirection.y, P.m_xProjectionDirection.z));
          [branch]
          if ((bool)(P.m_fMinRange > _200) || (bool)(P.m_fLightRange < _200)) {
            _626 = false;
            break;
          }
        }
        float _210 = sqrt(((_194 * _194) + (_192 * _192)) + (_196 * _196));
        float _211 = _192 / _210;
        float _212 = _194 / _210;
        float _213 = _196 / _210;
        float _224 = exp2(log2(saturate((1.0f - saturate((_210 - P.m_fAreaLightRadius) / (P.m_fLightRange - P.m_fAreaLightRadius))) * P.m_fLightFalloffScale)) * P.m_fLightFalloffPower) * P.m_fDistanceFade;
        [branch]
        if (!((_224 + -9.999999747378752e-05f) < 0.0f)) {
          float _232 = saturate((P.m_fAngularFalloffOfs - dot(float3(P.m_xProjectionDirection.x, P.m_xProjectionDirection.y, P.m_xProjectionDirection.z), float3(_211, _212, _213))) * P.m_fAngularFalloffScale) * _224;
          float _233 = _232 * P.m_xLightColour.x;
          float _234 = _232 * P.m_xLightColour.y;
          float _235 = _232 * P.m_xLightColour.z;
          do {
            [branch]
            if (P.m_fAreaLightRadius > 0.0f) {
              float _239 = dot(float3(_125, _126, _127), float3(_109, _110, _111)) * 2.0f;
              float _246 = -0.0f - (_125 - (_239 * _109));
              float _247 = -0.0f - (_126 - (_239 * _110));
              float _248 = -0.0f - (_127 - (_239 * _111));
              float _249 = dot(float3(_192, _194, _196), float3(_246, _247, _248));
              float _253 = (_249 * _246) - _192;
              float _254 = (_249 * _247) - _194;
              float _255 = (_249 * _248) - _196;
              float _263 = saturate(P.m_fAreaLightRadius / sqrt(((_253 * _253) + (_254 * _254)) + (_255 * _255)));
              float _267 = (_253 * _263) + _192;
              float _268 = (_254 * _263) + _194;
              float _269 = (_255 * _263) + _196;
              float _271 = rsqrt(dot(float3(_267, _268, _269), float3(_267, _268, _269)));
              _279 = (_267 * _271);
              _280 = (_268 * _271);
              _281 = (_269 * _271);
              _282 = (rsqrt(dot(float3(_192, _194, _196), float3(_192, _194, _196))) * P.m_fAreaLightRadius);
            } else {
              _279 = _211;
              _280 = _212;
              _281 = _213;
              _282 = 0.0f;
            }
// RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
            float _284 = select((!MaterialIdEquals(_91.w, 0.019607843831181526f)), _96.x, 0.0f);
            float _285 = _279 + _125;
            float _286 = _280 + _126;
            float _287 = _281 + _127;
            float _289 = rsqrt(dot(float3(_285, _286, _287), float3(_285, _286, _287)));
            float _290 = _289 * _285;
            float _291 = _289 * _286;
            float _292 = _289 * _287;
            float _294 = saturate(dot(float3(_109, _110, _111), float3(_211, _212, _213)));
            float _296 = saturate(dot(float3(_109, _110, _111), float3(_125, _126, _127)));
            float _298 = saturate(dot(float3(_109, _110, _111), float3(_290, _291, _292)));
            float _300 = saturate(dot(float3(_125, _126, _127), float3(_290, _291, _292)));
            bool _301 = MaterialIdEquals(_91.w, 0.01568627543747425f);
            do {
              [branch]
              if (!_301) {
                [branch]
                if (!MaterialIdEquals(_91.w, 0.007843137718737125f)) {
                  [branch]
                  if (MaterialIdEquals(_91.w, 0.003921568859368563f)) {
                    _342 = _91.x;
                    _343 = _91.y;
                    _344 = _91.z;
                    _345 = 0.02800000086426735f;
                    _346 = 0.02800000086426735f;
                    _347 = 0.02800000086426735f;
                    _348 = ((saturate(exp2(log2(saturate(dot(float3(_211, _212, _213), float3((-0.0f - _125), (-0.0f - _126), (-0.0f - _127))))) * 7.0f) + (saturate(dot(float3(_211, _212, _213), float3((-0.0f - _109), (-0.0f - _110), (-0.0f - _111)))) * 0.4000000059604645f)) * _284) + _294);
                  } else {
                    _342 = (_91.x - (_284 * _91.x));
                    _343 = (_91.y - (_284 * _91.y));
                    _344 = (_91.z - (_284 * _91.z));
                    _345 = ((_284 * (_91.x + -0.03999999910593033f)) + 0.03999999910593033f);
                    _346 = ((_284 * (_91.y + -0.03999999910593033f)) + 0.03999999910593033f);
                    _347 = ((_284 * (_91.z + -0.03999999910593033f)) + 0.03999999910593033f);
                    _348 = _294;
                  }
                } else {
                  _342 = _91.x;
                  _343 = _91.y;
                  _344 = _91.z;
                  _345 = 0.02800000086426735f;
                  _346 = 0.02800000086426735f;
                  _347 = 0.02800000086426735f;
                  _348 = _294;
                }
              } else {
                _342 = _91.x;
                _343 = _91.y;
                _344 = _91.z;
                _345 = 0.04699999839067459f;
                _346 = 0.04699999839067459f;
                _347 = 0.04699999839067459f;
                _348 = _294;
              }
              float _349 = _348 * _342;
              float _350 = _348 * _343;
              float _351 = _348 * _344;
              float _352 = max(_96.y, 0.05000000074505806f);
              float _353 = _352 * _352;
              do {
                [branch]
                if (_301) {
                  float _356 = saturate(1.0f - _96.y);
                  float _358 = _96.x * 0.6000000238418579f;
                  float _359 = _358 + -0.3500000238418579f;
                  float _362 = (_358 + -0.25f) - (_356 * 0.05000000074505806f);
                  float _363 = log2(_356);
                  float _365 = exp2(_363 * 8.0f);
                  float _369 = exp2(_363 * 6.0f);
                  float _380 = (_359 * _109) + _114;
                  float _381 = (_359 * _110) + _115;
                  float _382 = _122 + (_359 * _111);
                  float _384 = rsqrt(dot(float3(_380, _381, _382), float3(_380, _381, _382)));
                  float _388 = dot(float3((_384 * _380), (_384 * _381), (_384 * _382)), float3(_290, _291, _292));
                  float _394 = saturate(_388 + 1.0f);
                  float _407 = (((_394 * _394) * (((_356 + 0.10000000149011612f) * ((_96.x * 0.13500000536441803f) + 0.015000000596046448f)) * ((_365 * 19.89436912536621f) + 1.1140847206115723f))) * (3.0f - (_394 * 2.0f))) * exp2(log2(sqrt(saturate(1.0f - (_388 * _388)))) * ((_365 * 500.0f) + 20.0f));
                  float _408 = max(dot(float3(_91.x, _91.y, _91.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)), 0.0010000000474974513f);
                  float _418 = (_362 * _109) + _114;
                  float _419 = (_362 * _110) + _115;
                  float _420 = (_362 * _111) + _122;
                  float _422 = rsqrt(dot(float3(_418, _419, _420), float3(_418, _419, _420)));
                  float _426 = dot(float3((_422 * _418), (_422 * _419), (_422 * _420)), float3(_290, _291, _292));
                  float _432 = saturate(_426 + 1.0f);
                  float _445 = (((_432 * _432) * ((_356 * ((_96.x * 0.007499999832361937f) + 0.007499999832361937f)) * ((_369 * 79.57747650146484f) + 2.3077468872070312f))) * (3.0f - (_432 * 2.0f))) * exp2(log2(sqrt(saturate(1.0f - (_426 * _426)))) * ((_369 * 2000.0f) + 50.0f));
                  float _449 = _294 * P.m_fSpecularStrength;
                  _507 = (_449 * (_445 + (_407 * (_91.x / _408))));
                  _508 = (_449 * (_445 + (_407 * (_91.y / _408))));
                  _509 = (_449 * (_445 + (_407 * (_91.z / _408))));
                } else {
                  float _456 = saturate((1.0f - _353) * _282);
                  float _463 = exp2((-6.983160018920898f - (_300 * 5.55472993850708f)) * _300);
                  float _467 = (_463 * (1.0f - _345)) + _345;
                  float _468 = (_463 * (1.0f - _346)) + _346;
                  float _469 = (_463 * (1.0f - _347)) + _347;
                  float _471 = _353 * _353;
                  do {
                    [branch]
                    if (_456 > 0.0f) {
                      _482 = (_471 / ((((_456 * 0.25f) * (_456 + (_353 * 3.0f))) / (_300 + 0.0010000000474974513f)) + _471));
                    } else {
                      _482 = 1.0f;
                    }
                    float _483 = 2.0f - _353;
                    float _493 = (((_471 * _298) - _298) * _298) + 1.0f;
                    float _499 = (((_294 * P.m_fSpecularStrength) * _471) * (1.0f / (((_483 * _296) + _353) * ((_483 * _294) + _353)))) * (1.0f / (_493 * _493));
                    _507 = ((_482 * _467) * _499);
                    _508 = ((_482 * _468) * _499);
                    _509 = ((_482 * _469) * _499);
                  } while (false);
                }
                float _510 = _507 + _349;
                float _511 = _508 + _350;
                float _512 = _509 + _351;
                do {
                  [branch]
                  if (MaterialIdEquals(_91.w, 0.019607843831181526f)) {
                    bool _515 = (_96.x > 0.49803921580314636f);
                    float _518 = select(_515, (_96.x + -0.501960813999176f), _96.x) * 2.007874011993408f;
                    float _536 = saturate(exp2(log2(saturate(dot(float3(_211, _212, _213), float3((-0.0f - _125), (-0.0f - _126), (-0.0f - _127))))) * 7.0f) + (saturate(dot(float3(_211, _212, _213), float3((-0.0f - _109), (-0.0f - _110), (-0.0f - _111)))) * 0.4000000059604645f)) * select(_515, 0.5f, 0.0f);
                    float _543 = sqrt(abs(_342));
                    float _544 = sqrt(abs(_343));
                    float _545 = sqrt(abs(_344));
                    float _552 = exp2((-6.983160018920898f - (_300 * 5.55472993850708f)) * _300);
                    float _565 = 0.5f / _353;
                    float _573 = ((_565 + 1.0f) * (1.0f / ((((_296 + _294) - (_296 * _294)) * 4.0f) + 9.999999682655225e-21f))) * exp2(log2(1.0f - (_298 * _298)) * _565);
                    float _574 = _294 * P.m_fSpecularStrength;
                    _594 = (((((_536 * _342) - _507) + ((((_552 * (1.0f - _543)) + _543) * _574) * _573)) * _518) + _510);
                    _595 = (((((_536 * _343) - _508) + ((((_552 * (1.0f - _544)) + _544) * _574) * _573)) * _518) + _511);
                    _596 = (((((_536 * _344) - _509) + ((((_552 * (1.0f - _545)) + _545) * _574) * _573)) * _518) + _512);
                  } else {
                    _594 = _510;
                    _595 = _511;
                    _596 = _512;
                  }
                  float _600 = min((_233 * _594), 1000.0f);
                  float _601 = min((_234 * _595), 1000.0f);
                  float _602 = min((_235 * _596), 1000.0f);
                  [branch]
                  if ((bool)(_21 < 3.0f) && MaterialIdEquals(_91.w, 0.007843137718737125f)) {
                    float _608 = max((_21 + -2.0f), 0.0f);
                    _626 = true;
                    _627 = ((lerp(g_xSubsurfaceScatteringWeight.x, 1.0f, _608)) * _600);
                    _628 = ((lerp(g_xSubsurfaceScatteringWeight.y, 1.0f, _608)) * _601);
                    _629 = ((lerp(g_xSubsurfaceScatteringWeight.z, 1.0f, _608)) * _602);
                  } else {
                    _626 = true;
                    _627 = _600;
                    _628 = _601;
                    _629 = _602;
                  }
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _626 = false;
        }
      } while (false);
    } else {
      _626 = false;
    }
  } else {
    _626 = false;
  }
  [branch]
  if (!_626) {
    if (true) discard;
  }
  SV_Target.x = _627;
  SV_Target.y = _628;
  SV_Target.z = _629;
  SV_Target.w = 1.0f;
  return SV_Target;
}
