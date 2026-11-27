#include "./shared.h"

// Baseline: 4 fewer fmul fast (dxc reassociation: channel-invariant D*G*vis sub-product shared across RGB in the two specular terms), phi/gep order only otherwise; identical to original DXIL.

Texture2D<float4> g_xTextureArray[] : register(t0, space1);

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
  int m_bCustomBoundingVolumeSet;
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
  int m_bIsProjector;
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

SamplerState g_xBilinearClamp : register(s3);

SamplerState g_xTrilinearWrap : register(s4);

SamplerState g_xTrilinearClamp : register(s5);

SamplerComparisonState g_xShadowCmpSampler : register(s8);

static const float _global_0[3] = { 1.0f, 0.0f, 0.0f };
static const float _global_1[3] = { 0.0f, 1.0f, 0.0f };
static const float _global_2[3] = { 0.0f, 0.0f, 1.0f };

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float3 CamDir : CamDir
) : SV_Target {
  float4 SV_Target;
  int _17 = int(SV_Position.x);
  int _18 = int(SV_Position.y);
  float4 _19 = g_xLighting_DepthStencil.Load(int3(_17, _18, 0));
  float _25 = g_xDepthProjViewUnpack.x / (g_xDepthProjViewUnpack.y - _19.x);
  float2 _tf = g_xCameraTanHalfFOV * _25;
  float2 _sp = ((g_xTwoOverScreenDimensions.zw + SV_Position.xy) * g_xTwoOverScreenDimensions.xy) + -1.0f;
  float _42 = _tf.x * _sp.x;
  float _43 = _tf.y * _sp.y;
  ProjectorParams P = g_axProjectors[g_uProjectorIndex];
  float4 _46 = P.m_xProjectorMatrix[0];
  float4 _49 = P.m_xProjectorMatrix[1];
  float4 _52 = P.m_xProjectorMatrix[2];
  float4 _55 = P.m_xProjectorMatrix[3];
  float4 _113 = g_xLighting_NormalBuffer.Load(int3(_17, _18, 0));
  float4 _118 = g_xLighting_AlbedoBuffer.Load(int3(_17, _18, 0));
  float4 _123 = g_xLighting_PBRPropertiesBuffer.Load(int3(_17, _18, 0));
  float _131 = (_113.x * 2.0f) + -1.0f;
  float _132 = (_113.y * 2.0f) + -1.0f;
  float _133 = (_113.z * 2.0f) + -1.0f;
  float _135 = rsqrt(dot(float3(_131, _132, _133), float3(_131, _132, _133)));
  float _136 = _135 * _131;
  float _137 = _135 * _132;
  float _138 = _135 * _133;
  float _141 = (_123.z * 2.0f) + -1.0f;
  float _142 = (_123.w * 2.0f) + -1.0f;
  float _146 = sqrt(saturate(1.0f - dot(float2(_141, _142), float2(_141, _142))));
  float _149 = select((_113.w != 0.0f), _146, (-0.0f - _146));
  float _151 = rsqrt(dot(float3(CamDir.x, CamDir.y, CamDir.z), float3(CamDir.x, CamDir.y, CamDir.z)));
  float _152 = _151 * CamDir.x;
  float _153 = _151 * CamDir.y;
  float _154 = _151 * CamDir.z;
  float _158 = mad(_52.z, _25, mad(_49.z, _43, (_46.z * _42))) + _55.z;
  float _162 = mad(_52.w, _25, mad(_49.w, _43, (_46.w * _42))) + _55.w;
  bool _194;
  float _195;
  float _196;
  float _318;
  float _319;
  float _346;
  float _347;
  float _372;
  float _373;
  float _398;
  float _399;
  float _600;
  float _604;
  float _616;
  float _617;
  float _618;
  float _635;
  float _636;
  float _637;
  float _687;
  float _688;
  float _689;
  float _690;
  float _750;
  float _751;
  float _752;
  float _753;
  float _754;
  float _755;
  float _756;
  float _890;
  float _915;
  float _916;
  float _917;
  float _1002;
  float _1003;
  float _1004;
  bool _1034;
  float _1035;
  float _1036;
  float _1037;
  float _1038;
  [branch]
  if (!(_158 < 0.0f)) {
    float _181 = (mad(_52.x, _25, mad(_49.x, _43, (_46.x * _42))) + _55.x) / _162;
    float _182 = (mad(_52.y, _25, mad(_49.y, _43, (_46.y * _42))) + _55.y) / _162;
    [branch]
    if (!or((0.5f - abs(_181 + -0.5f)) < 0.0f, (0.5f - abs(_182 + -0.5f)) < 0.0f)) {
      _194 = true;
      _195 = _181;
      _196 = _182;
    } else {
      _194 = false;
      _195 = _181;
      _196 = _182;
    }
  } else {
    _194 = false;
  }
  [branch]
  if (_194) {
    float _224 = (P.m_xProjectorPos.x - (g_xInvView[3].x)) - mad((g_xInvView[2].x), _25, mad((g_xInvView[1].x), _43, ((g_xInvView[0].x) * _42)));
    float _226 = (P.m_xProjectorPos.y - (g_xInvView[3].y)) - mad((g_xInvView[2].y), _25, mad((g_xInvView[1].y), _43, ((g_xInvView[0].y) * _42)));
    float _228 = (P.m_xProjectorPos.z - (g_xInvView[3].z)) - mad((g_xInvView[2].z), _25, mad((g_xInvView[1].z), _43, ((g_xInvView[0].z) * _42)));
    do {
      [branch]
      if (P.m_bCustomBoundingVolumeSet != 0) {
        float _232 = -0.0f - dot(float3(_224, _226, _228), float3(P.m_xProjectionDirection.x, P.m_xProjectionDirection.y, P.m_xProjectionDirection.z));
        [branch]
        if ((bool)(P.m_fMinRange > _232) || (bool)(P.m_fLightRange < _232)) {
          _1034 = false;
          break;
        }
      }
      float _242 = sqrt(((_226 * _226) + (_224 * _224)) + (_228 * _228));
      float _243 = _224 / _242;
      float _244 = _226 / _242;
      float _245 = _228 / _242;
      float _256 = exp2(log2(saturate((1.0f - saturate((_242 - P.m_fAreaLightRadius) / (P.m_fLightRange - P.m_fAreaLightRadius))) * P.m_fLightFalloffScale)) * P.m_fLightFalloffPower) * P.m_fDistanceFade;
      [branch]
      if (!((_256 + -9.999999747378752e-05f) < 0.0f)) {
        do {
          [branch]
          if (P.m_iShadowTextureIndex != -1) {
            float _268 = (max(((1.0f - saturate(dot(float3(_136, _137, _138), float3(_243, _244, _245)))) * P.m_fShadowBias), P.m_fShadowBias) + _158) / _162;
            float _273 = (P.m_fShadowNearPlane * 2.0f) * P.m_fShadowFarPlane;
            float _274 = P.m_fShadowFarPlane + P.m_fShadowNearPlane;
            float _275 = P.m_fShadowFarPlane - P.m_fShadowNearPlane;
            float _281 = saturate(((_273 / (_274 - ((((1.0f - _268) * 2.0f) + -1.0f) * _275))) - P.m_fShadowNearPlane) / _275);
            [branch]
            if (P.m_fShadowStrength > 0.0f) {
              do {
                [branch]
                if (P.m_fShadowSoftness > 0.0f) {
                  float _292 = frac(frac(dot(float2(SV_Position.x, SV_Position.y), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.283185005187988f;
                  float _293 = sin(_292);
                  float _294 = cos(_292);
                  float _296 = (P.m_fShadowSoftness * 0.02500000037252903f) * P.m_fProjectorOneOverTanHalfFov;
                  float _297 = _296 * 0.3535533845424652f;
                  float4 _304 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleBias(g_xBilinearClamp, float2(((_297 * _294) + _195), ((_297 * _293) + _196)), g_fGlobalSamplerBias, int2(0, 0));
                  float _314 = saturate(((_273 / (_274 - ((((1.0f - _304.x) * 2.0f) + -1.0f) * _275))) - P.m_fShadowNearPlane) / _275);
                  do {
                    [branch]
                    if (_314 < _281) {
                      _318 = _314;
                      _319 = 1.0f;
                    } else {
                      _318 = 0.0f;
                      _319 = 0.0f;
                    }
                    float _320 = _292 + 2.4000000953674316f;
                    float _323 = _296 * 0.6123724579811096f;
                    float4 _330 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleBias(g_xBilinearClamp, float2(((_323 * cos(_320)) + _195), ((_323 * sin(_320)) + _196)), g_fGlobalSamplerBias, int2(0, 0));
                    float _340 = saturate(((_273 / (_274 - ((((1.0f - _330.x) * 2.0f) + -1.0f) * _275))) - P.m_fShadowNearPlane) / _275);
                    do {
                      [branch]
                      if (_340 < _281) {
                        _346 = (_340 + _318);
                        _347 = (_319 + 1.0f);
                      } else {
                        _346 = _318;
                        _347 = _319;
                      }
                      float _348 = _292 + 4.800000190734863f;
                      float _351 = _296 * 0.7905694246292114f;
                      float4 _356 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleBias(g_xBilinearClamp, float2(((_351 * cos(_348)) + _195), ((_351 * sin(_348)) + _196)), g_fGlobalSamplerBias, int2(0, 0));
                      float _366 = saturate(((_273 / (_274 - ((((1.0f - _356.x) * 2.0f) + -1.0f) * _275))) - P.m_fShadowNearPlane) / _275);
                      do {
                        [branch]
                        if (_366 < _281) {
                          _372 = (_366 + _346);
                          _373 = (_347 + 1.0f);
                        } else {
                          _372 = _346;
                          _373 = _347;
                        }
                        float _374 = _292 + 7.200000286102295f;
                        float _377 = _296 * 0.9354143738746643f;
                        float4 _382 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleBias(g_xBilinearClamp, float2(((_377 * cos(_374)) + _195), ((_377 * sin(_374)) + _196)), g_fGlobalSamplerBias, int2(0, 0));
                        float _392 = saturate(((_273 / (_274 - ((((1.0f - _382.x) * 2.0f) + -1.0f) * _275))) - P.m_fShadowNearPlane) / _275);
                        do {
                          [branch]
                          if (_392 < _281) {
                            _398 = (_392 + _372);
                            _399 = (_373 + 1.0f);
                          } else {
                            _398 = _372;
                            _399 = _373;
                          }
                          [branch]
                          if (_399 > 0.0f) {
                            float _402 = _398 / _399;
                            float _404 = (_281 - _402) / _402;
                            float _409 = (_296 * saturate(_404 * _404)) + (P.m_f2DFilterSize * 2.0f);
                            float4 _420 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2(((_409 * ((_294 * 0.40580499172210693f) - (_293 * 0.32621198892593384f))) + _195), ((_409 * ((_294 * -0.32621198892593384f) - (_293 * 0.40580499172210693f))) + _196)), _268, int2(0, 0));
                            float4 _432 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2(((_409 * ((_294 * 0.07357999682426453f) - (_293 * 0.8401439785957336f))) + _195), ((_409 * ((_294 * -0.8401439785957336f) - (_293 * 0.07357999682426453f))) + _196)), _268, int2(0, 0));
                            float4 _445 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2(((_409 * ((_293 * -0.6959139704704285f) - (_294 * 0.45713698863983154f))) + _195), ((_409 * ((_293 * 0.45713698863983154f) - (_294 * 0.6959139704704285f))) + _196)), _268, int2(0, 0));
                            float4 _458 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2(((_409 * ((_293 * -0.20334500074386597f) - (_294 * 0.6207159757614136f))) + _195), ((_409 * ((_293 * 0.6207159757614136f) - (_294 * 0.20334500074386597f))) + _196)), _268, int2(0, 0));
                            float4 _471 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2(((_409 * ((_294 * 0.19498300552368164f) + (_293 * 0.9623399972915649f))) + _195), ((_409 * ((_294 * 0.9623399972915649f) - (_293 * 0.19498300552368164f))) + _196)), _268, int2(0, 0));
                            float4 _484 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2(((_409 * ((_294 * 0.4800260066986084f) + (_293 * 0.4734340012073517f))) + _195), ((_409 * ((_294 * 0.4734340012073517f) - (_293 * 0.4800260066986084f))) + _196)), _268, int2(0, 0));
                            float4 _497 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2(((_409 * ((_293 * 0.5194560289382935f) - (_294 * 0.7670220136642456f))) + _195), ((_409 * ((_294 * 0.5194560289382935f) + (_293 * 0.7670220136642456f))) + _196)), _268, int2(0, 0));
                            float4 _510 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2(((_409 * ((_294 * 0.893123984336853f) + (_293 * 0.18546099960803986f))) + _195), ((_409 * ((_294 * 0.18546099960803986f) - (_293 * 0.893123984336853f))) + _196)), _268, int2(0, 0));
                            _600 = ((((((((_432.x + _420.x) + _445.x) + _458.x) + _471.x) + _484.x) + _497.x) + _510.x) * 0.125f);
                          } else {
                            _600 = 0.0f;
                          }
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  float4 _519 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 - (P.m_f2DFilterSize * 0.32621198892593384f)), (_196 - (P.m_f2DFilterSize * 0.40580499172210693f))), _268, int2(0, 0));
                  float4 _525 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 - (P.m_f2DFilterSize * 0.8401439785957336f)), (_196 - (P.m_f2DFilterSize * 0.07357999682426453f))), _268, int2(0, 0));
                  float4 _532 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 - (P.m_f2DFilterSize * 0.6959139704704285f)), (_196 + (P.m_f2DFilterSize * 0.45713698863983154f))), _268, int2(0, 0));
                  float4 _539 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 - (P.m_f2DFilterSize * 0.20334500074386597f)), (_196 + (P.m_f2DFilterSize * 0.6207159757614136f))), _268, int2(0, 0));
                  float4 _546 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 + (P.m_f2DFilterSize * 0.9623399972915649f)), (_196 - (P.m_f2DFilterSize * 0.19498300552368164f))), _268, int2(0, 0));
                  float4 _553 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 + (P.m_f2DFilterSize * 0.4734340012073517f)), (_196 - (P.m_f2DFilterSize * 0.4800260066986084f))), _268, int2(0, 0));
                  float4 _560 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 + (P.m_f2DFilterSize * 0.5194560289382935f)), (_196 + (P.m_f2DFilterSize * 0.7670220136642456f))), _268, int2(0, 0));
                  float4 _567 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 + (P.m_f2DFilterSize * 0.18546099960803986f)), (_196 - (P.m_f2DFilterSize * 0.893123984336853f))), _268, int2(0, 0));
                  float4 _574 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 + (P.m_f2DFilterSize * 0.5074309706687927f)), (_196 + (P.m_f2DFilterSize * 0.06442499905824661f))), _268, int2(0, 0));
                  float4 _581 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 + (P.m_f2DFilterSize * 0.8964200019836426f)), (_196 + (P.m_f2DFilterSize * 0.41245800256729126f))), _268, int2(0, 0));
                  float4 _588 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 - (P.m_f2DFilterSize * 0.32194000482559204f)), (_196 - (P.m_f2DFilterSize * 0.9326149821281433f))), _268, int2(0, 0));
                  float4 _595 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)].SampleCmp(g_xShadowCmpSampler, float2((_195 - (P.m_f2DFilterSize * 0.7915589809417725f)), (_196 - (P.m_f2DFilterSize * 0.5977050065994263f))), _268, int2(0, 0));
                  _600 = ((((((((((((_525.x + _519.x) + _532.x) + _539.x) + _546.x) + _553.x) + _560.x) + _567.x) + _574.x) + _581.x) + _588.x) + _595.x) * 0.0833333358168602f);
                }
                _604 = (1.0f - (_600 * P.m_fShadowStrength));
              } while (false);
            } else {
              _604 = 1.0f;
            }
          } else {
            _604 = 1.0f;
          }
          [branch]
          if (_604 > 0.0f) {
            do {
              [branch]
              if (P.m_iTextureIndex > 0) {
                float4 _611 = g_xTextureArray[NonUniformResourceIndex(P.m_iTextureIndex)].SampleLevel(g_xTrilinearClamp, float2(_195, _196), 0.0f);
                _616 = _611.x;
                _617 = _611.y;
                _618 = _611.z;
              } else {
                _616 = 1.0f;
                _617 = 1.0f;
                _618 = 1.0f;
              }
              do {
                [branch]
                if (P.m_iDetailTextureIndex > 0) {
                  float4 _627 = g_xTextureArray[NonUniformResourceIndex(P.m_iDetailTextureIndex)].SampleLevel(g_xTrilinearWrap, float2(((_195 * P.m_xDetailOffsetScale.z) + P.m_xDetailOffsetScale.x), ((_196 * P.m_xDetailOffsetScale.w) + P.m_xDetailOffsetScale.y)), 0.0f);
                  _635 = (_627.x * _616);
                  _636 = (_627.y * _617);
                  _637 = (_627.z * _618);
                } else {
                  _635 = _616;
                  _636 = _617;
                  _637 = _618;
                }
                float _lx = (_256 * P.m_xLightColour.x) * _635;
                float _ly = (_256 * P.m_xLightColour.y) * _636;
                float _lz = (_256 * P.m_xLightColour.z) * _637;
                do {
                  [branch]
                  if (P.m_fAreaLightRadius > 0.0f) {
                    float _647 = dot(float3(_152, _153, _154), float3(_136, _137, _138)) * 2.0f;
                    float _654 = -0.0f - (_152 - (_647 * _136));
                    float _655 = -0.0f - (_153 - (_647 * _137));
                    float _656 = -0.0f - (_154 - (_647 * _138));
                    float _657 = dot(float3(_224, _226, _228), float3(_654, _655, _656));
                    float _661 = (_657 * _654) - _224;
                    float _662 = (_657 * _655) - _226;
                    float _663 = (_657 * _656) - _228;
                    float _671 = saturate(P.m_fAreaLightRadius / sqrt(((_661 * _661) + (_662 * _662)) + (_663 * _663)));
                    float _675 = (_661 * _671) + _224;
                    float _676 = (_662 * _671) + _226;
                    float _677 = (_663 * _671) + _228;
                    float _679 = rsqrt(dot(float3(_675, _676, _677), float3(_675, _676, _677)));
                    _687 = (_675 * _679);
                    _688 = (_676 * _679);
                    _689 = (_677 * _679);
                    _690 = (rsqrt(dot(float3(_224, _226, _228), float3(_224, _226, _228))) * P.m_fAreaLightRadius);
                  } else {
                    _687 = _243;
                    _688 = _244;
                    _689 = _245;
                    _690 = 0.0f;
                  }
                  // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
                  float _692 = select((!MaterialIdEquals(_118.w, 0.019607843831181526f)), _123.x, 0.0f);
                  float _693 = _687 + _152;
                  float _694 = _688 + _153;
                  float _695 = _689 + _154;
                  float _697 = rsqrt(dot(float3(_693, _694, _695), float3(_693, _694, _695)));
                  float _698 = _697 * _693;
                  float _699 = _697 * _694;
                  float _700 = _697 * _695;
                  float _702 = saturate(dot(float3(_136, _137, _138), float3(_243, _244, _245)));
                  float _704 = saturate(dot(float3(_136, _137, _138), float3(_152, _153, _154)));
                  float _706 = saturate(dot(float3(_136, _137, _138), float3(_698, _699, _700)));
                  float _708 = saturate(dot(float3(_152, _153, _154), float3(_698, _699, _700)));
                  bool _709 = (MaterialIdEquals(_118.w, 0.01568627543747425f));
                  do {
                    [branch]
                    if (!_709) {
                      [branch]
                      if (MaterialIdEquals(_118.w, 0.007843137718737125f)) {
                        _750 = _118.x;
                        _751 = _118.y;
                        _752 = _118.z;
                        _753 = 0.02800000086426735f;
                        _754 = 0.02800000086426735f;
                        _755 = 0.02800000086426735f;
                        _756 = _702;
                      } else {
                        [branch]
                        if (MaterialIdEquals(_118.w, 0.003921568859368563f)) {
                          _750 = _118.x;
                          _751 = _118.y;
                          _752 = _118.z;
                          _753 = 0.02800000086426735f;
                          _754 = 0.02800000086426735f;
                          _755 = 0.02800000086426735f;
                          _756 = ((saturate(exp2(log2(saturate(dot(float3(_243, _244, _245), float3((-0.0f - _152), (-0.0f - _153), (-0.0f - _154))))) * 7.0f) + (saturate(dot(float3(_243, _244, _245), float3((-0.0f - _136), (-0.0f - _137), (-0.0f - _138)))) * 0.4000000059604645f)) * _692) + _702);
                        } else {
                          _750 = (_118.x - (_692 * _118.x));
                          _751 = (_118.y - (_692 * _118.y));
                          _752 = (_118.z - (_692 * _118.z));
                          _753 = ((_692 * (_118.x + -0.03999999910593033f)) + 0.03999999910593033f);
                          _754 = ((_692 * (_118.y + -0.03999999910593033f)) + 0.03999999910593033f);
                          _755 = ((_692 * (_118.z + -0.03999999910593033f)) + 0.03999999910593033f);
                          _756 = _702;
                        }
                      }
                    } else {
                      _750 = _118.x;
                      _751 = _118.y;
                      _752 = _118.z;
                      _753 = 0.04699999839067459f;
                      _754 = 0.04699999839067459f;
                      _755 = 0.04699999839067459f;
                      _756 = _702;
                    }
                    float _dx = _756 * _750;
                    float _dy = _756 * _751;
                    float _dz = _756 * _752;
                    float _760 = max(_123.y, 0.05000000074505806f);
                    float _761 = _760 * _760;
                    do {
                      [branch]
                      if (_709) {
                        float _764 = saturate(1.0f - _123.y);
                        float _766 = _123.x * 0.6000000238418579f;
                        float _767 = _766 + -0.3500000238418579f;
                        float _770 = (_766 + -0.25f) - (_764 * 0.05000000074505806f);
                        float _771 = log2(_764);
                        float _773 = exp2(_771 * 8.0f);
                        float _777 = exp2(_771 * 6.0f);
                        float _788 = (_136 * _767) + _141;
                        float _789 = (_137 * _767) + _142;
                        float _790 = _149 + (_138 * _767);
                        float _792 = rsqrt(dot(float3(_788, _789, _790), float3(_788, _789, _790)));
                        float _796 = dot(float3((_792 * _788), (_792 * _789), (_792 * _790)), float3(_698, _699, _700));
                        float _802 = saturate(_796 + 1.0f);
                        float _815 = (((_802 * _802) * (((_764 + 0.10000000149011612f) * ((_123.x * 0.13500000536441803f) + 0.015000000596046448f)) * ((_773 * 19.89436912536621f) + 1.1140847206115723f))) * (3.0f - (_802 * 2.0f))) * exp2(log2(sqrt(saturate(1.0f - (_796 * _796)))) * ((_773 * 500.0f) + 20.0f));
                        float _816 = max(dot(float3(_118.x, _118.y, _118.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)), 0.0010000000474974513f);
                        float _826 = (_770 * _136) + _141;
                        float _827 = (_770 * _137) + _142;
                        float _828 = (_770 * _138) + _149;
                        float _830 = rsqrt(dot(float3(_826, _827, _828), float3(_826, _827, _828)));
                        float _834 = dot(float3((_830 * _826), (_830 * _827), (_830 * _828)), float3(_698, _699, _700));
                        float _840 = saturate(_834 + 1.0f);
                        float _853 = (((_840 * _840) * ((_764 * ((_123.x * 0.007499999832361937f) + 0.007499999832361937f)) * ((_777 * 79.57747650146484f) + 2.3077468872070312f))) * (3.0f - (_840 * 2.0f))) * exp2(log2(sqrt(saturate(1.0f - (_834 * _834)))) * ((_777 * 2000.0f) + 50.0f));
                        float _857 = _702 * P.m_fSpecularStrength;
                        _915 = (_857 * (_853 + (_815 * (_118.x / _816))));
                        _916 = (_857 * (_853 + (_815 * (_118.y / _816))));
                        _917 = (_857 * (_853 + (_815 * (_118.z / _816))));
                      } else {
                        float _864 = saturate((1.0f - _761) * _690);
                        float _871 = exp2((-6.983160018920898f - (_708 * 5.55472993850708f)) * _708);
                        float _fx = (_871 * (1.0f - _753)) + _753;
                        float _fy = (_871 * (1.0f - _754)) + _754;
                        float _fz = (_871 * (1.0f - _755)) + _755;
                        float _879 = _761 * _761;
                        do {
                          [branch]
                          if (_864 > 0.0f) {
                            _890 = (_879 / ((((_864 * 0.25f) * (_864 + (_761 * 3.0f))) / (_708 + 0.0010000000474974513f)) + _879));
                          } else {
                            _890 = 1.0f;
                          }
                          float _891 = 2.0f - _761;
                          float _901 = (((_879 * _706) - _706) * _706) + 1.0f;
                          float _907 = (((_702 * P.m_fSpecularStrength) * _879) * (1.0f / (((_891 * _704) + _761) * ((_891 * _702) + _761)))) * (1.0f / (_901 * _901));
                          _915 = ((_890 * _fx) * _907);
                          _916 = ((_890 * _fy) * _907);
                          _917 = ((_890 * _fz) * _907);
                        } while (false);
                      }
                      float _918 = _915 + _dx;
                      float _919 = _916 + _dy;
                      float _920 = _917 + _dz;
                      do {
                        [branch]
                        if (MaterialIdEquals(_118.w, 0.019607843831181526f)) {
                          bool _923 = (_123.x > 0.49803921580314636f);
                          float _926 = select(_923, (_123.x + -0.501960813999176f), _123.x) * 2.007874011993408f;
                          float _944 = saturate(exp2(log2(saturate(dot(float3(_243, _244, _245), float3((-0.0f - _152), (-0.0f - _153), (-0.0f - _154))))) * 7.0f) + (saturate(dot(float3(_243, _244, _245), float3((-0.0f - _136), (-0.0f - _137), (-0.0f - _138)))) * 0.4000000059604645f)) * select(_923, 0.5f, 0.0f);
                          float _951 = sqrt(abs(_750));
                          float _952 = sqrt(abs(_751));
                          float _953 = sqrt(abs(_752));
                          float _960 = exp2((-6.983160018920898f - (_708 * 5.55472993850708f)) * _708);
                          float _973 = 0.5f / _761;
                          float _981 = ((_973 + 1.0f) * (1.0f / ((((_704 + _702) - (_704 * _702)) * 4.0f) + 9.999999682655225e-21f))) * exp2(log2(1.0f - (_706 * _706)) * _973);
                          float _982 = _702 * P.m_fSpecularStrength;
                          _1002 = (((((_944 * _750) - _915) + ((((_960 * (1.0f - _951)) + _951) * _982) * _981)) * _926) + _918);
                          _1003 = (((((_944 * _751) - _916) + ((((_960 * (1.0f - _952)) + _952) * _982) * _981)) * _926) + _919);
                          _1004 = (((((_944 * _752) - _917) + (((lerp(_953, 1.0f, _960)) * _982) * _981)) * _926) + _920);
                        } else {
                          _1002 = _918;
                          _1003 = _919;
                          _1004 = _920;
                        }
                        float _1008 = min((_lx * _1002), 1000.0f);
                        float _1009 = min((_ly * _1003), 1000.0f);
                        float _1010 = min((_lz * _1004), 1000.0f);
                        [branch]
                        if ((bool)(_25 < 3.0f) && (bool)(MaterialIdEquals(_118.w, 0.007843137718737125f))) {
                          float _1016 = max((_25 + -2.0f), 0.0f);
                          _1034 = true;
                          _1035 = ((lerp(g_xSubsurfaceScatteringWeight.x, 1.0f, _1016)) * _1008);
                          _1036 = ((lerp(g_xSubsurfaceScatteringWeight.y, 1.0f, _1016)) * _1009);
                          _1037 = ((lerp(g_xSubsurfaceScatteringWeight.z, 1.0f, _1016)) * _1010);
                          _1038 = _604;
                        } else {
                          _1034 = true;
                          _1035 = _1008;
                          _1036 = _1009;
                          _1037 = _1010;
                          _1038 = _604;
                        }
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } else {
            _1034 = true;
            _1035 = 0.0f;
            _1036 = 0.0f;
            _1037 = 0.0f;
            _1038 = _604;
          }
        } while (false);
      } else {
        _1034 = false;
      }
    } while (false);
  } else {
    _1034 = false;
  }
  [branch]
  if (!_1034) {
    if (true) discard;
  }
  SV_Target.x = ((_global_0[P.m_uShadowPoolLevel]) * _1035);
  SV_Target.y = ((_global_1[P.m_uShadowPoolLevel]) * _1036);
  SV_Target.z = ((_global_2[P.m_uShadowPoolLevel]) * _1037);
  SV_Target.w = _1038;
  return SV_Target;
}
