#include "./shared.h"
// Baseline: 4 fewer fmul fast (dxc reassociation of the specular and final light-colour product chains), 1 fewer identical g_fGlobalSamplerBias cbuffer load (CSE), phi/GEP-inbounds order differences; otherwise identical to the original DXIL.

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

SamplerComparisonState g_xShadowCmpSampler : register(s8);

static const float g_axPoolColours[3] = { 1.0f, 0.0f, 0.0f };
static const float g_axPoolColours1[3] = { 0.0f, 1.0f, 0.0f };
static const float g_axPoolColours2[3] = { 0.0f, 0.0f, 1.0f };

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float3 CamDir : CamDir
) : SV_Target {
  float4 SV_Target;
  int _15 = int(SV_Position.x);
  int _16 = int(SV_Position.y);
  float4 _17 = g_xLighting_DepthStencil.Load(int3(_15, _16, 0));
  float _23 = g_xDepthProjViewUnpack.x / (g_xDepthProjViewUnpack.y - _17.x);
  float2 _4041 = g_xCameraTanHalfFOV * _23 * (((g_xTwoOverScreenDimensions.zw + SV_Position.xy) * g_xTwoOverScreenDimensions.xy) + -1.0f);
  float _40 = _4041.x;
  float _41 = _4041.y;
  uint _43 = g_uProjectorIndex;
  float4 _44 = g_axProjectors[_43].m_xProjectorMatrix[0];
  float4 _47 = g_axProjectors[_43].m_xProjectorMatrix[1];
  float4 _50 = g_axProjectors[_43].m_xProjectorMatrix[2];
  float4 _53 = g_axProjectors[_43].m_xProjectorMatrix[3];
  float4 _56 = g_axProjectors[_43].m_xProjectionDirection;
  float3 _60 = g_axProjectors[_43].m_xProjectorPos;
  float3 _64 = g_axProjectors[_43].m_xLightColour;
  float _68 = g_axProjectors[_43].m_fDistanceFade;
  float _70 = g_axProjectors[_43].m_fLightFalloffScale;
  float _72 = g_axProjectors[_43].m_fLightFalloffPower;
  float _74 = g_axProjectors[_43].m_fAngularFalloffOfs;
  float _76 = g_axProjectors[_43].m_fAngularFalloffScale;
  float _78 = g_axProjectors[_43].m_fMinRange;
  float _80 = g_axProjectors[_43].m_fLightRange;
  float _82 = g_axProjectors[_43].m_fShadowStrength;
  int _84 = g_axProjectors[_43].m_bCustomBoundingVolumeSet;
  float _86 = g_axProjectors[_43].m_f2DFilterSize;
  int _88 = g_axProjectors[_43].m_iShadowTextureIndex;
  float _90 = g_axProjectors[_43].m_fShadowSoftness;
  float _92 = g_axProjectors[_43].m_fShadowNearPlane;
  float _94 = g_axProjectors[_43].m_fShadowFarPlane;
  float _96 = g_axProjectors[_43].m_fProjectorOneOverTanHalfFov;
  float _98 = g_axProjectors[_43].m_fShadowBias;
  float _100 = g_axProjectors[_43].m_fSpecularStrength;
  float _102 = g_axProjectors[_43].m_fAreaLightRadius;
  uint _104 = g_axProjectors[_43].m_uShadowPoolLevel;
  float4 _106 = g_xLighting_NormalBuffer.Load(int3(_15, _16, 0));
  float4 _111 = g_xLighting_AlbedoBuffer.Load(int3(_15, _16, 0));
  float4 _116 = g_xLighting_PBRPropertiesBuffer.Load(int3(_15, _16, 0));
  float _124 = (_106.x * 2.0f) + -1.0f;
  float _125 = (_106.y * 2.0f) + -1.0f;
  float _126 = (_106.z * 2.0f) + -1.0f;
  float _128 = rsqrt(dot(float3(_124, _125, _126), float3(_124, _125, _126)));
  float _129 = _128 * _124;
  float _130 = _128 * _125;
  float _131 = _128 * _126;
  float _134 = (_116.z * 2.0f) + -1.0f;
  float _135 = (_116.w * 2.0f) + -1.0f;
  float _139 = sqrt(saturate(1.0f - dot(float2(_134, _135), float2(_134, _135))));
  float _142 = select((_106.w != 0.0f), _139, (-0.0f - _139));
  float _144 = rsqrt(dot(float3(CamDir.x, CamDir.y, CamDir.z), float3(CamDir.x, CamDir.y, CamDir.z)));
  float _145 = _144 * CamDir.x;
  float _146 = _144 * CamDir.y;
  float _147 = _144 * CamDir.z;
  float _151 = mad(_50.z, _23, mad(_47.z, _41, (_44.z * _40))) + _53.z;
  float _155 = mad(_50.w, _23, mad(_47.w, _41, (_44.w * _40))) + _53.w;
  bool _187;
  float _188;
  float _189;
  float _311;
  float _312;
  float _339;
  float _340;
  float _365;
  float _366;
  float _391;
  float _392;
  float _593;
  float _597;
  float _651;
  float _652;
  float _653;
  float _654;
  float _714;
  float _715;
  float _716;
  float _717;
  float _718;
  float _719;
  float _720;
  float _854;
  float _879;
  float _880;
  float _881;
  float _966;
  float _967;
  float _968;
  bool _998;
  float _999;
  float _1000;
  float _1001;
  float _1002;
  [branch]
  if (!(_151 < 0.0f)) {
    float _174 = (mad(_50.x, _23, mad(_47.x, _41, (_44.x * _40))) + _53.x) / _155;
    float _175 = (mad(_50.y, _23, mad(_47.y, _41, (_44.y * _40))) + _53.y) / _155;
    [branch]
    if (!any(float2(0.5f - abs(_174 + -0.5f), 0.5f - abs(_175 + -0.5f)) < 0.0f)) {
      _187 = true;
      _188 = _174;
      _189 = _175;
    } else {
      _187 = false;
      _188 = _174;
      _189 = _175;
    }
  } else {
    _187 = false;
  }
  [branch]
  if (_187) {
    float _217 = (_60.x - (g_xInvView[3].x)) - mad((g_xInvView[2].x), _23, mad((g_xInvView[1].x), _41, ((g_xInvView[0].x) * _40)));
    float _219 = (_60.y - (g_xInvView[3].y)) - mad((g_xInvView[2].y), _23, mad((g_xInvView[1].y), _41, ((g_xInvView[0].y) * _40)));
    float _221 = (_60.z - (g_xInvView[3].z)) - mad((g_xInvView[2].z), _23, mad((g_xInvView[1].z), _41, ((g_xInvView[0].z) * _40)));
    do {
      [branch]
      if (!(_84 == 0)) {
        float _225 = -0.0f - dot(float3(_217, _219, _221), float3(_56.x, _56.y, _56.z));
        [branch]
        if ((bool)(_78 > _225) || (bool)(_80 < _225)) {
          _998 = false;
          break;
        }
      }
      float _235 = sqrt(((_219 * _219) + (_217 * _217)) + (_221 * _221));
      float _236 = _217 / _235;
      float _237 = _219 / _235;
      float _238 = _221 / _235;
      float _249 = exp2(log2(saturate((1.0f - saturate((_235 - _102) / (_80 - _102))) * _70)) * _72) * _68;
      [branch]
      if (!((_249 + -9.999999747378752e-05f) < 0.0f)) {
        do {
          [branch]
          if (!(_88 == -1)) {
            float _261 = (max(((1.0f - saturate(dot(float3(_129, _130, _131), float3(_236, _237, _238)))) * _98), _98) + _151) / _155;
            float _266 = (_92 * 2.0f) * _94;
            float _267 = _94 + _92;
            float _268 = _94 - _92;
            float _274 = saturate(((_266 / (_267 - ((((1.0f - _261) * 2.0f) + -1.0f) * _268))) - _92) / _268);
            [branch]
            if (_82 > 0.0f) {
              Texture2D<float4> shadowTexture = g_xTextureArray[NonUniformResourceIndex(_88)];
              do {
                [branch]
                if (_90 > 0.0f) {
                  float _285 = frac(frac(dot(float2(SV_Position.x, SV_Position.y), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.283185005187988f;
                  float _286 = sin(_285);
                  float _287 = cos(_285);
                  float _289 = (_90 * 0.02500000037252903f) * _96;
                  float _290 = _289 * 0.3535533845424652f;
                  float4 _297 = shadowTexture.SampleBias(g_xBilinearClamp, float2(((_290 * _287) + _188), ((_290 * _286) + _189)), g_fGlobalSamplerBias, int2(0, 0));
                  float _307 = saturate(((_266 / (_267 - ((((1.0f - _297.x) * 2.0f) + -1.0f) * _268))) - _92) / _268);
                  do {
                    [branch]
                    if (_307 < _274) {
                      _311 = _307;
                      _312 = 1.0f;
                    } else {
                      _311 = 0.0f;
                      _312 = 0.0f;
                    }
                    float _313 = _285 + 2.4000000953674316f;
                    float _316 = _289 * 0.6123724579811096f;
                    float4 _323 = shadowTexture.SampleBias(g_xBilinearClamp, float2(((_316 * cos(_313)) + _188), ((_316 * sin(_313)) + _189)), g_fGlobalSamplerBias, int2(0, 0));
                    float _333 = saturate(((_266 / (_267 - ((((1.0f - _323.x) * 2.0f) + -1.0f) * _268))) - _92) / _268);
                    do {
                      [branch]
                      if (_333 < _274) {
                        _339 = (_333 + _311);
                        _340 = (_312 + 1.0f);
                      } else {
                        _339 = _311;
                        _340 = _312;
                      }
                      float _341 = _285 + 4.800000190734863f;
                      float _344 = _289 * 0.7905694246292114f;
                      float4 _349 = shadowTexture.SampleBias(g_xBilinearClamp, float2(((_344 * cos(_341)) + _188), ((_344 * sin(_341)) + _189)), g_fGlobalSamplerBias, int2(0, 0));
                      float _359 = saturate(((_266 / (_267 - ((((1.0f - _349.x) * 2.0f) + -1.0f) * _268))) - _92) / _268);
                      do {
                        [branch]
                        if (_359 < _274) {
                          _365 = (_359 + _339);
                          _366 = (_340 + 1.0f);
                        } else {
                          _365 = _339;
                          _366 = _340;
                        }
                        float _367 = _285 + 7.200000286102295f;
                        float _370 = _289 * 0.9354143738746643f;
                        float4 _375 = shadowTexture.SampleBias(g_xBilinearClamp, float2(((_370 * cos(_367)) + _188), ((_370 * sin(_367)) + _189)), g_fGlobalSamplerBias, int2(0, 0));
                        float _385 = saturate(((_266 / (_267 - ((((1.0f - _375.x) * 2.0f) + -1.0f) * _268))) - _92) / _268);
                        do {
                          [branch]
                          if (_385 < _274) {
                            _391 = (_385 + _365);
                            _392 = (_366 + 1.0f);
                          } else {
                            _391 = _365;
                            _392 = _366;
                          }
                          [branch]
                          if (_392 > 0.0f) {
                            float _395 = _391 / _392;
                            float _397 = (_274 - _395) / _395;
                            float _402 = (_289 * saturate(_397 * _397)) + (_86 * 2.0f);
                            float4 _413 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2(((_402 * ((_287 * 0.40580499172210693f) - (_286 * 0.32621198892593384f))) + _188), ((_402 * ((_287 * -0.32621198892593384f) - (_286 * 0.40580499172210693f))) + _189)), _261);
                            float4 _425 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2(((_402 * ((_287 * 0.07357999682426453f) - (_286 * 0.8401439785957336f))) + _188), ((_402 * ((_287 * -0.8401439785957336f) - (_286 * 0.07357999682426453f))) + _189)), _261);
                            float4 _438 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2(((_402 * ((_286 * -0.6959139704704285f) - (_287 * 0.45713698863983154f))) + _188), ((_402 * ((_286 * 0.45713698863983154f) - (_287 * 0.6959139704704285f))) + _189)), _261);
                            float4 _451 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2(((_402 * ((_286 * -0.20334500074386597f) - (_287 * 0.6207159757614136f))) + _188), ((_402 * ((_286 * 0.6207159757614136f) - (_287 * 0.20334500074386597f))) + _189)), _261);
                            float4 _464 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2(((_402 * ((_287 * 0.19498300552368164f) + (_286 * 0.9623399972915649f))) + _188), ((_402 * ((_287 * 0.9623399972915649f) - (_286 * 0.19498300552368164f))) + _189)), _261);
                            float4 _477 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2(((_402 * ((_287 * 0.4800260066986084f) + (_286 * 0.4734340012073517f))) + _188), ((_402 * ((_287 * 0.4734340012073517f) - (_286 * 0.4800260066986084f))) + _189)), _261);
                            float4 _490 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2(((_402 * ((_286 * 0.5194560289382935f) - (_287 * 0.7670220136642456f))) + _188), ((_402 * ((_287 * 0.5194560289382935f) + (_286 * 0.7670220136642456f))) + _189)), _261);
                            float4 _503 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2(((_402 * ((_287 * 0.893123984336853f) + (_286 * 0.18546099960803986f))) + _188), ((_402 * ((_287 * 0.18546099960803986f) - (_286 * 0.893123984336853f))) + _189)), _261);
                            _593 = ((((((((_425.x + _413.x) + _438.x) + _451.x) + _464.x) + _477.x) + _490.x) + _503.x) * 0.125f);
                          } else {
                            _593 = 0.0f;
                          }
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  float4 _512 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 - (_86 * 0.32621198892593384f)), (_189 - (_86 * 0.40580499172210693f))), _261);
                  float4 _518 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 - (_86 * 0.8401439785957336f)), (_189 - (_86 * 0.07357999682426453f))), _261);
                  float4 _525 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 - (_86 * 0.6959139704704285f)), (_189 + (_86 * 0.45713698863983154f))), _261);
                  float4 _532 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 - (_86 * 0.20334500074386597f)), (_189 + (_86 * 0.6207159757614136f))), _261);
                  float4 _539 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 + (_86 * 0.9623399972915649f)), (_189 - (_86 * 0.19498300552368164f))), _261);
                  float4 _546 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 + (_86 * 0.4734340012073517f)), (_189 - (_86 * 0.4800260066986084f))), _261);
                  float4 _553 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 + (_86 * 0.5194560289382935f)), (_189 + (_86 * 0.7670220136642456f))), _261);
                  float4 _560 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 + (_86 * 0.18546099960803986f)), (_189 - (_86 * 0.893123984336853f))), _261);
                  float4 _567 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 + (_86 * 0.5074309706687927f)), (_189 + (_86 * 0.06442499905824661f))), _261);
                  float4 _574 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 + (_86 * 0.8964200019836426f)), (_189 + (_86 * 0.41245800256729126f))), _261);
                  float4 _581 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 - (_86 * 0.32194000482559204f)), (_189 - (_86 * 0.9326149821281433f))), _261);
                  float4 _588 = shadowTexture.SampleCmp(g_xShadowCmpSampler, float2((_188 - (_86 * 0.7915589809417725f)), (_189 - (_86 * 0.5977050065994263f))), _261);
                  _593 = ((((((((((((_518.x + _512.x) + _525.x) + _532.x) + _539.x) + _546.x) + _553.x) + _560.x) + _567.x) + _574.x) + _581.x) + _588.x) * 0.0833333358168602f);
                }
                _597 = (1.0f - (_593 * _82));
              } while (false);
            } else {
              _597 = 1.0f;
            }
          } else {
            _597 = 1.0f;
          }
          [branch]
          if (_597 > 0.0f) {
            float _604 = saturate((_74 - dot(float3(_56.x, _56.y, _56.z), float3(_236, _237, _238))) * _76) * _249;
            do {
              [branch]
              if (_102 > 0.0f) {
                float _611 = dot(float3(_145, _146, _147), float3(_129, _130, _131)) * 2.0f;
                float _618 = -0.0f - (_145 - (_611 * _129));
                float _619 = -0.0f - (_146 - (_611 * _130));
                float _620 = -0.0f - (_147 - (_611 * _131));
                float _621 = dot(float3(_217, _219, _221), float3(_618, _619, _620));
                float _625 = (_621 * _618) - _217;
                float _626 = (_621 * _619) - _219;
                float _627 = (_621 * _620) - _221;
                float _635 = saturate(_102 / sqrt(((_625 * _625) + (_626 * _626)) + (_627 * _627)));
                float _639 = (_625 * _635) + _217;
                float _640 = (_626 * _635) + _219;
                float _641 = (_627 * _635) + _221;
                float _643 = rsqrt(dot(float3(_639, _640, _641), float3(_639, _640, _641)));
                _651 = (_639 * _643);
                _652 = (_640 * _643);
                _653 = (_641 * _643);
                _654 = (rsqrt(dot(float3(_217, _219, _221), float3(_217, _219, _221))) * _102);
              } else {
                _651 = _236;
                _652 = _237;
                _653 = _238;
                _654 = 0.0f;
              }
              // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
              float _656 = select((!MaterialIdEquals(_111.w, 0.019607843831181526f)), _116.x, 0.0f);
              float _657 = _651 + _145;
              float _658 = _652 + _146;
              float _659 = _653 + _147;
              float _661 = rsqrt(dot(float3(_657, _658, _659), float3(_657, _658, _659)));
              float _662 = _661 * _657;
              float _663 = _661 * _658;
              float _664 = _661 * _659;
              float _666 = saturate(dot(float3(_129, _130, _131), float3(_236, _237, _238)));
              float _668 = saturate(dot(float3(_129, _130, _131), float3(_145, _146, _147)));
              float _670 = saturate(dot(float3(_129, _130, _131), float3(_662, _663, _664)));
              float _672 = saturate(dot(float3(_145, _146, _147), float3(_662, _663, _664)));
              bool _673 = (MaterialIdEquals(_111.w, 0.01568627543747425f));
              do {
                [branch]
                if (!_673) {
                  [branch]
                  if (!(MaterialIdEquals(_111.w, 0.007843137718737125f))) {
                    [branch]
                    if (MaterialIdEquals(_111.w, 0.003921568859368563f)) {
                      _714 = _111.x;
                      _715 = _111.y;
                      _716 = _111.z;
                      _717 = 0.02800000086426735f;
                      _718 = 0.02800000086426735f;
                      _719 = 0.02800000086426735f;
                      _720 = ((saturate(exp2(log2(saturate(dot(float3(_236, _237, _238), float3((-0.0f - _145), (-0.0f - _146), (-0.0f - _147))))) * 7.0f) + (saturate(dot(float3(_236, _237, _238), float3((-0.0f - _129), (-0.0f - _130), (-0.0f - _131)))) * 0.4000000059604645f)) * _656) + _666);
                    } else {
                      _714 = (_111.x - (_656 * _111.x));
                      _715 = (_111.y - (_656 * _111.y));
                      _716 = (_111.z - (_656 * _111.z));
                      _717 = ((_656 * (_111.x + -0.03999999910593033f)) + 0.03999999910593033f);
                      _718 = ((_656 * (_111.y + -0.03999999910593033f)) + 0.03999999910593033f);
                      _719 = ((_656 * (_111.z + -0.03999999910593033f)) + 0.03999999910593033f);
                      _720 = _666;
                    }
                  } else {
                    _714 = _111.x;
                    _715 = _111.y;
                    _716 = _111.z;
                    _717 = 0.02800000086426735f;
                    _718 = 0.02800000086426735f;
                    _719 = 0.02800000086426735f;
                    _720 = _666;
                  }
                } else {
                  _714 = _111.x;
                  _715 = _111.y;
                  _716 = _111.z;
                  _717 = 0.04699999839067459f;
                  _718 = 0.04699999839067459f;
                  _719 = 0.04699999839067459f;
                  _720 = _666;
                }
                float _724 = max(_116.y, 0.05000000074505806f);
                float _725 = _724 * _724;
                do {
                  [branch]
                  if (_673) {
                    float _728 = saturate(1.0f - _116.y);
                    float _730 = _116.x * 0.6000000238418579f;
                    float _731 = _730 + -0.3500000238418579f;
                    float _734 = (_730 + -0.25f) - (_728 * 0.05000000074505806f);
                    float _735 = log2(_728);
                    float _737 = exp2(_735 * 8.0f);
                    float _741 = exp2(_735 * 6.0f);
                    float _752 = (_129 * _731) + _134;
                    float _753 = (_130 * _731) + _135;
                    float _754 = _142 + (_131 * _731);
                    float _756 = rsqrt(dot(float3(_752, _753, _754), float3(_752, _753, _754)));
                    float _760 = dot(float3((_756 * _752), (_756 * _753), (_756 * _754)), float3(_662, _663, _664));
                    float _766 = saturate(_760 + 1.0f);
                    float _779 = (((_766 * _766) * (((_728 + 0.10000000149011612f) * ((_116.x * 0.13500000536441803f) + 0.015000000596046448f)) * ((_737 * 19.89436912536621f) + 1.1140847206115723f))) * (3.0f - (_766 * 2.0f))) * exp2(log2(sqrt(saturate(1.0f - (_760 * _760)))) * ((_737 * 500.0f) + 20.0f));
                    float _780 = max(dot(float3(_111.x, _111.y, _111.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)), 0.0010000000474974513f);
                    float _790 = (_734 * _129) + _134;
                    float _791 = (_734 * _130) + _135;
                    float _792 = (_734 * _131) + _142;
                    float _794 = rsqrt(dot(float3(_790, _791, _792), float3(_790, _791, _792)));
                    float _798 = dot(float3((_794 * _790), (_794 * _791), (_794 * _792)), float3(_662, _663, _664));
                    float _804 = saturate(_798 + 1.0f);
                    float _817 = (((_804 * _804) * ((_728 * ((_116.x * 0.007499999832361937f) + 0.007499999832361937f)) * ((_741 * 79.57747650146484f) + 2.3077468872070312f))) * (3.0f - (_804 * 2.0f))) * exp2(log2(sqrt(saturate(1.0f - (_798 * _798)))) * ((_741 * 2000.0f) + 50.0f));
                    float _821 = _666 * _100;
                    _879 = (_821 * (_817 + (_779 * (_111.x / _780))));
                    _880 = (_821 * (_817 + (_779 * (_111.y / _780))));
                    _881 = (_821 * (_817 + (_779 * (_111.z / _780))));
                  } else {
                    float _828 = saturate((1.0f - _725) * _654);
                    float _835 = exp2((-6.983160018920898f - (_672 * 5.55472993850708f)) * _672);
                    float _843 = _725 * _725;
                    do {
                      [branch]
                      if (_828 > 0.0f) {
                        _854 = (_843 / ((((_828 * 0.25f) * (_828 + (_725 * 3.0f))) / (_672 + 0.0010000000474974513f)) + _843));
                      } else {
                        _854 = 1.0f;
                      }
                      float _855 = 2.0f - _725;
                      float _865 = (((_843 * _670) - _670) * _670) + 1.0f;
                      float _871 = (((_666 * _100) * _843) * (1.0f / (((_855 * _668) + _725) * ((_855 * _666) + _725)))) * (1.0f / (_865 * _865));
                      _879 = ((_854 * ((_835 * (1.0f - _717)) + _717)) * _871);
                      _880 = ((_854 * ((_835 * (1.0f - _718)) + _718)) * _871);
                      _881 = ((_854 * ((_835 * (1.0f - _719)) + _719)) * _871);
                    } while (false);
                  }
                  float _882 = _879 + (_720 * _714);
                  float _883 = _880 + (_720 * _715);
                  float _884 = _881 + (_720 * _716);
                  do {
                    [branch]
                    if (MaterialIdEquals(_111.w, 0.019607843831181526f)) {
                      bool _887 = (_116.x > 0.49803921580314636f);
                      float _890 = select(_887, (_116.x + -0.501960813999176f), _116.x) * 2.007874011993408f;
                      float _908 = saturate(exp2(log2(saturate(dot(float3(_236, _237, _238), float3((-0.0f - _145), (-0.0f - _146), (-0.0f - _147))))) * 7.0f) + (saturate(dot(float3(_236, _237, _238), float3((-0.0f - _129), (-0.0f - _130), (-0.0f - _131)))) * 0.4000000059604645f)) * select(_887, 0.5f, 0.0f);
                      float _915 = sqrt(abs(_714));
                      float _916 = sqrt(abs(_715));
                      float _917 = sqrt(abs(_716));
                      float _924 = exp2((-6.983160018920898f - (_672 * 5.55472993850708f)) * _672);
                      float _937 = 0.5f / _725;
                      float _945 = ((_937 + 1.0f) * (1.0f / ((((_668 + _666) - (_668 * _666)) * 4.0f) + 9.999999682655225e-21f))) * exp2(log2(1.0f - (_670 * _670)) * _937);
                      float _946 = _666 * _100;
                      _966 = (((((_908 * _714) - _879) + ((((_924 * (1.0f - _915)) + _915) * _946) * _945)) * _890) + _882);
                      _967 = (((((_908 * _715) - _880) + ((((_924 * (1.0f - _916)) + _916) * _946) * _945)) * _890) + _883);
                      _968 = (((((_908 * _716) - _881) + (((lerp(_917, 1.0f, _924)) * _946) * _945)) * _890) + _884);
                    } else {
                      _966 = _882;
                      _967 = _883;
                      _968 = _884;
                    }
                    float _972 = min(((_604 * _64.x) * _966), 1000.0f);
                    float _973 = min(((_604 * _64.y) * _967), 1000.0f);
                    float _974 = min(((_604 * _64.z) * _968), 1000.0f);
                    [branch]
                    if ((bool)(_23 < 3.0f) && (bool)(MaterialIdEquals(_111.w, 0.007843137718737125f))) {
                      float _980 = max((_23 + -2.0f), 0.0f);
                      _998 = true;
                      _999 = ((lerp(g_xSubsurfaceScatteringWeight.x, 1.0f, _980)) * _972);
                      _1000 = ((lerp(g_xSubsurfaceScatteringWeight.y, 1.0f, _980)) * _973);
                      _1001 = ((lerp(g_xSubsurfaceScatteringWeight.z, 1.0f, _980)) * _974);
                      _1002 = _597;
                    } else {
                      _998 = true;
                      _999 = _972;
                      _1000 = _973;
                      _1001 = _974;
                      _1002 = _597;
                    }
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } else {
            _998 = true;
            _999 = 0.0f;
            _1000 = 0.0f;
            _1001 = 0.0f;
            _1002 = _597;
          }
        } while (false);
      } else {
        _998 = false;
      }
    } while (false);
  } else {
    _998 = false;
  }
  [branch]
  if (!_998) {
    if (true) discard;
  }
  SV_Target.x = (g_axPoolColours[_104] * _999);
  SV_Target.y = (g_axPoolColours1[_104] * _1000);
  SV_Target.z = (g_axPoolColours2[_104] * _1001);
  SV_Target.w = _1002;
  return SV_Target;
}
