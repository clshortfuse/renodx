#include "./shared.h"

Texture2D<float4> g_xLighting_NormalBuffer : register(t2);

Texture2D<float4> g_xLighting_AlbedoBuffer : register(t3);

Texture2D<float4> g_xLighting_PBRPropertiesBuffer : register(t4);

Texture2D<float4> g_xLighting_DepthStencil : register(t5);

Texture2D<float4> g_xShadowCubeMapPosX : register(t8);

Texture2D<float4> g_xShadowCubeMapNegX : register(t9);

Texture2D<float4> g_xShadowCubeMapNegY : register(t11);

Texture2D<float4> g_xShadowCubeMapPosY : register(t10);

Texture2D<float4> g_xShadowCubeMapPosZ : register(t12);

Texture2D<float4> g_xShadowCubeMapNegZ : register(t13);

struct PhotonFace {
  uint uLevel;
  float fSize;
  float fInvSize;
  int iShadowIndex;
};

struct PhotonParams {
  float4x4 m_xLightOrientation;
  float4x4 m_xCustomVolumeMatrix;
  float3 m_xLightPos;
  float m_fAreaLightRadius;
  float3 m_xLightDir;
  float m_fLightRange;
  float3 m_xLightColour;
  int m_bUseLimitAngles;
  float m_fLightFalloffScale;
  float m_fLightFalloffPower;
  float m_fLightAngleOuter;
  float m_fRcpLightAngleRange;
  float m_fArcCosLimitAngle;
  float m_fRcpProjCubeLerpDist;
  int m_bUseProjCube;
  int m_bUseDualProjCube;
  float2 m_xDepthProjection;
  float m_fLightMeshRadius;
  float m_fShadowStrength;
  float m_fShadowSoftness;
  float m_fShadowNearPlane;
  float m_fShadowFarPlane;
  float m_fShadowBias;
  float m_fSpecularStrength;
  float m_fPadding;
  int m_iProjCubeTextureIndex;
  int m_iProjCubeBlurredTextureIndex;
  PhotonFace m_axFace[6];
};

StructuredBuffer<PhotonParams> g_axPhotons : register(t41);

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

cbuffer PhotonIndex : register(b4) {
  uint g_uPhotonIndex : packoffset(c000.x);
};

SamplerState g_xBilinearClamp : register(s3);

SamplerComparisonState g_xShadowCmpSampler : register(s8);

static const float _global_0[3] = { 1.0f, 0.0f, 0.0f };
static const float _global_1[3] = { 0.0f, 1.0f, 0.0f };
static const float _global_2[3] = { 0.0f, 0.0f, 1.0f };

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  int _18[6];
  int _19[6];
  float _20[6];
  int _21[6];
  PhotonParams photon = g_axPhotons[g_uPhotonIndex];
  int _22 = int(SV_Position.x);
  int _23 = int(SV_Position.y);
  float4 _24 = g_xLighting_DepthStencil.Load(int3(_22, _23, 0));
  float _29 = g_xDepthProjViewUnpack.y - _24.x;
  float _30 = g_xDepthProjViewUnpack.x / _29;
  float _34 = g_xCameraTanHalfFOV.x * _30;
  float _35 = g_xCameraTanHalfFOV.y * _30;
  float _39 = g_xTwoOverScreenDimensions.z + SV_Position.x;
  float _40 = g_xTwoOverScreenDimensions.w + SV_Position.y;
  float _43 = _39 * g_xTwoOverScreenDimensions.x;
  float _44 = _40 * g_xTwoOverScreenDimensions.y;
  float _45 = _43 + -1.0f;
  float _46 = _44 + -1.0f;
  float _47 = _34 * _45;
  float _48 = _35 * _46;
  float _65 = _47 * (g_xInvView[0].x);
  float _66 = mad((g_xInvView[1].x), _48, _65);
  float _67 = mad((g_xInvView[2].x), _30, _66);
  float _68 = _67 + (g_xInvView[3].x);
  float _69 = _47 * (g_xInvView[0].y);
  float _70 = mad((g_xInvView[1].y), _48, _69);
  float _71 = mad((g_xInvView[2].y), _30, _70);
  float _72 = _71 + (g_xInvView[3].y);
  float _73 = _47 * (g_xInvView[0].z);
  float _74 = mad((g_xInvView[1].z), _48, _73);
  float _75 = mad((g_xInvView[2].z), _30, _74);
  float _76 = _75 + (g_xInvView[3].z);
  float4 _77 = g_xLighting_NormalBuffer.Load(int3(_22, _23, 0));
  float4 _82 = g_xLighting_AlbedoBuffer.Load(int3(_22, _23, 0));
  float4 _87 = g_xLighting_PBRPropertiesBuffer.Load(int3(_22, _23, 0));
  float _92 = _77.x * 2.0f;
  float _93 = _77.y * 2.0f;
  float _94 = _77.z * 2.0f;
  float _95 = _92 + -1.0f;
  float _96 = _93 + -1.0f;
  float _97 = _94 + -1.0f;
  float _98 = dot(float3(_95, _96, _97), float3(_95, _96, _97));
  float _99 = rsqrt(_98);
  float _100 = _99 * _95;
  float _101 = _99 * _96;
  float _102 = _99 * _97;
  float _103 = _87.z * 2.0f;
  float _104 = _87.w * 2.0f;
  float _105 = _103 + -1.0f;
  float _106 = _104 + -1.0f;
  float _107 = dot(float2(_105, _106), float2(_105, _106));
  float _108 = 1.0f - _107;
  float _109 = saturate(_108);
  float _110 = sqrt(_109);
  bool _111 = (_77.w != 0.0f);
  float _112 = -0.0f - _110;
  float _113 = select(_111, _110, _112);
  _18[0] = (int)(photon.m_axFace[0].uLevel);
  _19[0] = (int)(photon.m_axFace[0].iShadowIndex);
  _18[1] = (int)(photon.m_axFace[1].uLevel);
  _19[1] = (int)(photon.m_axFace[1].iShadowIndex);
  _18[2] = (int)(photon.m_axFace[2].uLevel);
  _19[2] = (int)(photon.m_axFace[2].iShadowIndex);
  _18[3] = (int)(photon.m_axFace[3].uLevel);
  _19[3] = (int)(photon.m_axFace[3].iShadowIndex);
  _18[4] = (int)(photon.m_axFace[4].uLevel);
  _19[4] = (int)(photon.m_axFace[4].iShadowIndex);
  _18[5] = (int)(photon.m_axFace[5].uLevel);
  _19[5] = (int)(photon.m_axFace[5].iShadowIndex);
  float _204 = photon.m_xLightPos.x - _68;
  float _205 = photon.m_xLightPos.y - _72;
  float _206 = photon.m_xLightPos.z - _76;
  float _207 = _204 * _204;
  float _208 = _205 * _205;
  float _209 = _208 + _207;
  float _210 = _206 * _206;
  float _211 = _209 + _210;
  float _212 = sqrt(_211);
  float _213 = _204 / _212;
  float _214 = _205 / _212;
  float _215 = _206 / _212;
  float _216 = _212 - photon.m_fAreaLightRadius;
  float _217 = photon.m_fLightRange - photon.m_fAreaLightRadius;
  float _218 = _216 / _217;
  float _219 = saturate(_218);
  float _220 = 1.0f - _219;
  float _221 = _220 * photon.m_fLightFalloffScale;
  float _222 = saturate(_221);
  float _223 = log2(_222);
  float _224 = _223 * photon.m_fLightFalloffPower;
  float _225 = exp2(_224);
  bool _226 = (photon.m_bUseLimitAngles == 0);
  float _239;
  int _297;
  float _298;
  float _299;
  float _368;
  float _381;
  float _382;
  float _422;
  float _437;
  float _438;
  float _478;
  float _493;
  float _494;
  float _534;
  float _549;
  float _550;
  float _603;
  float _642;
  float _682;
  float _722;
  float _765;
  float _808;
  float _851;
  float _894;
  float _935;
  float _971;
  float _1008;
  float _1045;
  float _1082;
  float _1119;
  float _1156;
  float _1193;
  float _1230;
  float _1267;
  float _1304;
  float _1341;
  float _1345;
  float _1349;
  float _1406;
  float _1407;
  float _1408;
  float _1409;
  float _1467;
  float _1468;
  float _1469;
  float _1470;
  float _1471;
  float _1472;
  float _1473;
  float _1607;
  float _1632;
  float _1633;
  float _1634;
  float _1719;
  float _1720;
  float _1721;
  float _1749;
  float _1750;
  float _1751;
  float _1774;
  float _1775;
  float _1776;
  bool _1793;
  float _1794;
  float _1795;
  float _1796;
  float _1797;
  [branch]
  if (!_226) {
    float _233 = dot(float3(_213, _214, _215), float3(photon.m_xLightDir.x, photon.m_xLightDir.y, photon.m_xLightDir.z));
    float _234 = _233 + photon.m_fLightAngleOuter;
    float _235 = _234 * photon.m_fRcpLightAngleRange;
    float _236 = saturate(_235);
    float _237 = _236 * _225;
    _239 = _237;
  } else {
    _239 = _225;
  }
  bool _240 = (_239 < 9.999999747378752e-05f);
  [branch]
  if (!_240) {
    float _242 = dot(float3(_100, _101, _102), float3(_213, _214, _215));
    float _243 = saturate(_242);
    float _244 = 1.0f - _243;
    float _245 = _244 * photon.m_fShadowBias;
    float _246 = max(_245, photon.m_fShadowBias);
    float _247 = -0.0f - _204;
    float _248 = -0.0f - _206;
    float _249 = abs(_247);
    float _250 = abs(_205);
    float _251 = abs(_248);
    float _252 = max(_250, _251);
    float _253 = max(_249, _252);
    float _254 = _247 / _253;
    float _255 = _205 / _253;
    float _256 = _248 / _253;
    float _257 = _253 - _246;
    float _258 = photon.m_xDepthProjection.y / _257;
    float _259 = _258 + photon.m_xDepthProjection.x;
    float _260 = 1.0f - _259;
    float _261 = _260 * 2.0f;
    float _262 = _261 + -1.0f;
    float _263 = photon.m_fShadowNearPlane * 2.0f;
    float _264 = _263 * photon.m_fShadowFarPlane;
    float _265 = photon.m_fShadowFarPlane + photon.m_fShadowNearPlane;
    float _266 = photon.m_fShadowFarPlane - photon.m_fShadowNearPlane;
    float _267 = _262 * _266;
    float _268 = _265 - _267;
    float _269 = _264 / _268;
    float _270 = _269 - photon.m_fShadowNearPlane;
    float _271 = _270 / _266;
    float _272 = saturate(_271);
    bool _273 = (_250 > _249);
    [branch]
    if (_273) {
      bool _275 = (_251 > _250);
      [branch]
      if (_275) {
        bool _277 = (_256 < 0.0f);
        float _278 = -0.0f - _255;
        [branch]
        if (_277) {
          float _280 = -0.0f - _254;
          _297 = 5;
          _298 = _280;
          _299 = _278;
        } else {
          _297 = 4;
          _298 = _254;
          _299 = _278;
        }
      } else {
        bool _282 = (_255 < 0.0f);
        [branch]
        if (_282) {
          float _284 = -0.0f - _256;
          _297 = 2;
          _298 = _254;
          _299 = _284;
        } else {
          _297 = 3;
          _298 = _254;
          _299 = _256;
        }
      }
    } else {
      bool _286 = (_251 > _249);
      float _287 = -0.0f - _255;
      [branch]
      if (_286) {
        bool _289 = (_256 < 0.0f);
        [branch]
        if (_289) {
          float _291 = -0.0f - _254;
          _297 = 5;
          _298 = _291;
          _299 = _287;
        } else {
          _297 = 4;
          _298 = _254;
          _299 = _287;
        }
      } else {
        bool _293 = (_254 < 0.0f);
        [branch]
        if (!_293) {
          float _295 = -0.0f - _256;
          _297 = 0;
          _298 = _295;
          _299 = _287;
        } else {
          _297 = 1;
          _298 = _256;
          _299 = _287;
        }
      }
    }
    float _300 = _298 * 0.5f;
    float _301 = _299 * 0.5f;
    float _302 = _300 + 0.5f;
    float _303 = _301 + 0.5f;
    bool _304 = (photon.m_fShadowStrength > 0.0f);
    [branch]
    if (_304) {
      _20[0] = photon.m_axFace[0].fInvSize;
      _21[0] = _19[0];
      _20[1] = photon.m_axFace[1].fInvSize;
      _21[1] = _19[1];
      _20[2] = photon.m_axFace[2].fInvSize;
      _21[2] = _19[2];
      _20[3] = photon.m_axFace[3].fInvSize;
      _21[3] = _19[3];
      _20[4] = photon.m_axFace[4].fInvSize;
      _21[4] = _19[4];
      _20[5] = photon.m_axFace[5].fInvSize;
      _21[5] = _19[5];
      int _319 = _21[_297];
      bool _320 = (_319 == -1);
      [branch]
      if (!_320) {
        bool _322 = (photon.m_fShadowSoftness > 0.0f);
        bool _323 = (_297 == 0);
        [branch]
        if (_322) {
          float _325 = dot(float2(SV_Position.x, SV_Position.y), float2(0.0671105608344078f, 0.005837149918079376f));
          float _326 = frac(_325);
          float _327 = _326 * 52.98291778564453f;
          float _328 = frac(_327);
          float _329 = _328 * 6.283185005187988f;
          float _330 = sin(_329);
          float _331 = cos(_329);
          float _332 = photon.m_fShadowSoftness * 0.008838835172355175f;
          float _333 = _332 * _331;
          float _334 = _332 * _330;
          float _335 = _333 + _302;
          float _336 = _334 + _303;
          float _337 = max(_335, 0.0f);
          float _338 = max(_336, 0.0f);
          float _339 = min(_337, 1.0f);
          float _340 = min(_338, 1.0f);
          [branch]
          if (!_323) {
            bool _342 = (_297 == 1);
            [branch]
            if (!_342) {
              bool _344 = (_297 == 2);
              [branch]
              if (!_344) {
                bool _346 = (_297 == 3);
                [branch]
                if (!_346) {
                  bool _348 = (_297 == 4);
                  [branch]
                  if (!_348) {
                    float4 _350 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_339, _340));
                    _368 = _350.x;
                  } else {
                    float4 _353 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_339, _340));
                    _368 = _353.x;
                  }
                } else {
                  float4 _356 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_339, _340));
                  _368 = _356.x;
                }
              } else {
                float4 _359 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_339, _340));
                _368 = _359.x;
              }
            } else {
              float4 _362 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_339, _340));
              _368 = _362.x;
            }
          } else {
            float4 _365 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_339, _340));
            _368 = _365.x;
          }
          float _369 = 1.0f - _368;
          float _370 = _369 * 2.0f;
          float _371 = _370 + -1.0f;
          float _372 = _371 * _266;
          float _373 = _265 - _372;
          float _374 = _264 / _373;
          float _375 = _374 - photon.m_fShadowNearPlane;
          float _376 = _375 / _266;
          float _377 = saturate(_376);
          bool _378 = (_377 < _272);
          [branch]
          if (_378) {
            _381 = _377;
            _382 = 1.0f;
          } else {
            _381 = 0.0f;
            _382 = 0.0f;
          }
          float _383 = _329 + 2.4000000953674316f;
          float _384 = sin(_383);
          float _385 = cos(_383);
          float _386 = photon.m_fShadowSoftness * 0.01530931144952774f;
          float _387 = _386 * _385;
          float _388 = _386 * _384;
          float _389 = _387 + _302;
          float _390 = _388 + _303;
          float _391 = max(_389, 0.0f);
          float _392 = max(_390, 0.0f);
          float _393 = min(_391, 1.0f);
          float _394 = min(_392, 1.0f);
          [branch]
          if (!_323) {
            bool _396 = (_297 == 1);
            [branch]
            if (!_396) {
              bool _398 = (_297 == 2);
              [branch]
              if (!_398) {
                bool _400 = (_297 == 3);
                [branch]
                if (!_400) {
                  bool _402 = (_297 == 4);
                  [branch]
                  if (!_402) {
                    float4 _404 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_393, _394));
                    _422 = _404.x;
                  } else {
                    float4 _407 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_393, _394));
                    _422 = _407.x;
                  }
                } else {
                  float4 _410 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_393, _394));
                  _422 = _410.x;
                }
              } else {
                float4 _413 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_393, _394));
                _422 = _413.x;
              }
            } else {
              float4 _416 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_393, _394));
              _422 = _416.x;
            }
          } else {
            float4 _419 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_393, _394));
            _422 = _419.x;
          }
          float _423 = 1.0f - _422;
          float _424 = _423 * 2.0f;
          float _425 = _424 + -1.0f;
          float _426 = _425 * _266;
          float _427 = _265 - _426;
          float _428 = _264 / _427;
          float _429 = _428 - photon.m_fShadowNearPlane;
          float _430 = _429 / _266;
          float _431 = saturate(_430);
          bool _432 = (_431 < _272);
          [branch]
          if (_432) {
            float _434 = _431 + _381;
            float _435 = _382 + 1.0f;
            _437 = _434;
            _438 = _435;
          } else {
            _437 = _381;
            _438 = _382;
          }
          float _439 = _329 + 4.800000190734863f;
          float _440 = sin(_439);
          float _441 = cos(_439);
          float _442 = photon.m_fShadowSoftness * 0.019764235243201256f;
          float _443 = _442 * _441;
          float _444 = _442 * _440;
          float _445 = _443 + _302;
          float _446 = _444 + _303;
          float _447 = max(_445, 0.0f);
          float _448 = max(_446, 0.0f);
          float _449 = min(_447, 1.0f);
          float _450 = min(_448, 1.0f);
          [branch]
          if (!_323) {
            bool _452 = (_297 == 1);
            [branch]
            if (!_452) {
              bool _454 = (_297 == 2);
              [branch]
              if (!_454) {
                bool _456 = (_297 == 3);
                [branch]
                if (!_456) {
                  bool _458 = (_297 == 4);
                  [branch]
                  if (!_458) {
                    float4 _460 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_449, _450));
                    _478 = _460.x;
                  } else {
                    float4 _463 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_449, _450));
                    _478 = _463.x;
                  }
                } else {
                  float4 _466 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_449, _450));
                  _478 = _466.x;
                }
              } else {
                float4 _469 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_449, _450));
                _478 = _469.x;
              }
            } else {
              float4 _472 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_449, _450));
              _478 = _472.x;
            }
          } else {
            float4 _475 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_449, _450));
            _478 = _475.x;
          }
          float _479 = 1.0f - _478;
          float _480 = _479 * 2.0f;
          float _481 = _480 + -1.0f;
          float _482 = _481 * _266;
          float _483 = _265 - _482;
          float _484 = _264 / _483;
          float _485 = _484 - photon.m_fShadowNearPlane;
          float _486 = _485 / _266;
          float _487 = saturate(_486);
          bool _488 = (_487 < _272);
          [branch]
          if (_488) {
            float _490 = _487 + _437;
            float _491 = _438 + 1.0f;
            _493 = _490;
            _494 = _491;
          } else {
            _493 = _437;
            _494 = _438;
          }
          float _495 = _329 + 7.200000286102295f;
          float _496 = sin(_495);
          float _497 = cos(_495);
          float _498 = photon.m_fShadowSoftness * 0.023385358974337578f;
          float _499 = _498 * _497;
          float _500 = _498 * _496;
          float _501 = _499 + _302;
          float _502 = _500 + _303;
          float _503 = max(_501, 0.0f);
          float _504 = max(_502, 0.0f);
          float _505 = min(_503, 1.0f);
          float _506 = min(_504, 1.0f);
          [branch]
          if (!_323) {
            bool _508 = (_297 == 1);
            [branch]
            if (!_508) {
              bool _510 = (_297 == 2);
              [branch]
              if (!_510) {
                bool _512 = (_297 == 3);
                [branch]
                if (!_512) {
                  bool _514 = (_297 == 4);
                  [branch]
                  if (!_514) {
                    float4 _516 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_505, _506));
                    _534 = _516.x;
                  } else {
                    float4 _519 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_505, _506));
                    _534 = _519.x;
                  }
                } else {
                  float4 _522 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_505, _506));
                  _534 = _522.x;
                }
              } else {
                float4 _525 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_505, _506));
                _534 = _525.x;
              }
            } else {
              float4 _528 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_505, _506));
              _534 = _528.x;
            }
          } else {
            float4 _531 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_505, _506));
            _534 = _531.x;
          }
          float _535 = 1.0f - _534;
          float _536 = _535 * 2.0f;
          float _537 = _536 + -1.0f;
          float _538 = _537 * _266;
          float _539 = _265 - _538;
          float _540 = _264 / _539;
          float _541 = _540 - photon.m_fShadowNearPlane;
          float _542 = _541 / _266;
          float _543 = saturate(_542);
          bool _544 = (_543 < _272);
          [branch]
          if (_544) {
            float _546 = _543 + _493;
            float _547 = _494 + 1.0f;
            _549 = _546;
            _550 = _547;
          } else {
            _549 = _493;
            _550 = _494;
          }
          bool _551 = (_550 > 0.0f);
          [branch]
          if (_551) {
            float _553 = _549 / _550;
            float _554 = _272 - _553;
            float _555 = _554 / _553;
            float _556 = _555 * _555;
            float _557 = saturate(_556);
            float _558 = photon.m_fShadowSoftness * 0.02500000037252903f;
            float _559 = _558 * _557;
            float _561 = _20[_297];
            float _562 = _561 * 2.0f;
            float _563 = _559 + _562;
            float _564 = _331 * 0.25f;
            float _565 = _330 * 0.25f;
            float _566 = _564 * _563;
            float _567 = _565 * _563;
            float _568 = _566 + _302;
            float _569 = _567 + _303;
            float _570 = max(_568, 0.0f);
            float _571 = max(_569, 0.0f);
            float _572 = min(_570, 1.0f);
            float _573 = min(_571, 1.0f);
            [branch]
            if (!_323) {
              bool _575 = (_297 == 1);
              [branch]
              if (!_575) {
                bool _577 = (_297 == 2);
                [branch]
                if (!_577) {
                  bool _579 = (_297 == 3);
                  [branch]
                  if (!_579) {
                    bool _581 = (_297 == 4);
                    [branch]
                    if (!_581) {
                      bool _583 = (_297 == 5);
                      [branch]
                      if (_583) {
                        float4 _585 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_572, _573), _259);
                        _603 = _585.x;
                      } else {
                        _603 = 0.0f;
                      }
                    } else {
                      float4 _588 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_572, _573), _259);
                      _603 = _588.x;
                    }
                  } else {
                    float4 _591 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_572, _573), _259);
                    _603 = _591.x;
                  }
                } else {
                  float4 _594 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_572, _573), _259);
                  _603 = _594.x;
                }
              } else {
                float4 _597 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_572, _573), _259);
                _603 = _597.x;
              }
            } else {
              float4 _600 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_572, _573), _259);
              _603 = _600.x;
            }
            float _604 = _563 * 0.4330127239227295f;
            float _605 = _604 * _385;
            float _606 = _604 * _384;
            float _607 = _605 + _302;
            float _608 = _606 + _303;
            float _609 = max(_607, 0.0f);
            float _610 = max(_608, 0.0f);
            float _611 = min(_609, 1.0f);
            float _612 = min(_610, 1.0f);
            [branch]
            if (!_323) {
              bool _614 = (_297 == 1);
              [branch]
              if (!_614) {
                bool _616 = (_297 == 2);
                [branch]
                if (!_616) {
                  bool _618 = (_297 == 3);
                  [branch]
                  if (!_618) {
                    bool _620 = (_297 == 4);
                    [branch]
                    if (!_620) {
                      bool _622 = (_297 == 5);
                      [branch]
                      if (_622) {
                        float4 _624 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_611, _612), _259);
                        _642 = _624.x;
                      } else {
                        _642 = 0.0f;
                      }
                    } else {
                      float4 _627 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_611, _612), _259);
                      _642 = _627.x;
                    }
                  } else {
                    float4 _630 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_611, _612), _259);
                    _642 = _630.x;
                  }
                } else {
                  float4 _633 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_611, _612), _259);
                  _642 = _633.x;
                }
              } else {
                float4 _636 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_611, _612), _259);
                _642 = _636.x;
              }
            } else {
              float4 _639 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_611, _612), _259);
              _642 = _639.x;
            }
            float _643 = _642 + _603;
            float _644 = _563 * 0.55901700258255f;
            float _645 = _644 * _441;
            float _646 = _644 * _440;
            float _647 = _645 + _302;
            float _648 = _646 + _303;
            float _649 = max(_647, 0.0f);
            float _650 = max(_648, 0.0f);
            float _651 = min(_649, 1.0f);
            float _652 = min(_650, 1.0f);
            [branch]
            if (!_323) {
              bool _654 = (_297 == 1);
              [branch]
              if (!_654) {
                bool _656 = (_297 == 2);
                [branch]
                if (!_656) {
                  bool _658 = (_297 == 3);
                  [branch]
                  if (!_658) {
                    bool _660 = (_297 == 4);
                    [branch]
                    if (!_660) {
                      bool _662 = (_297 == 5);
                      [branch]
                      if (_662) {
                        float4 _664 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_651, _652), _259);
                        _682 = _664.x;
                      } else {
                        _682 = 0.0f;
                      }
                    } else {
                      float4 _667 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_651, _652), _259);
                      _682 = _667.x;
                    }
                  } else {
                    float4 _670 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_651, _652), _259);
                    _682 = _670.x;
                  }
                } else {
                  float4 _673 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_651, _652), _259);
                  _682 = _673.x;
                }
              } else {
                float4 _676 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_651, _652), _259);
                _682 = _676.x;
              }
            } else {
              float4 _679 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_651, _652), _259);
              _682 = _679.x;
            }
            float _683 = _643 + _682;
            float _684 = _563 * 0.6614378690719604f;
            float _685 = _684 * _497;
            float _686 = _684 * _496;
            float _687 = _685 + _302;
            float _688 = _686 + _303;
            float _689 = max(_687, 0.0f);
            float _690 = max(_688, 0.0f);
            float _691 = min(_689, 1.0f);
            float _692 = min(_690, 1.0f);
            [branch]
            if (!_323) {
              bool _694 = (_297 == 1);
              [branch]
              if (!_694) {
                bool _696 = (_297 == 2);
                [branch]
                if (!_696) {
                  bool _698 = (_297 == 3);
                  [branch]
                  if (!_698) {
                    bool _700 = (_297 == 4);
                    [branch]
                    if (!_700) {
                      bool _702 = (_297 == 5);
                      [branch]
                      if (_702) {
                        float4 _704 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_691, _692), _259);
                        _722 = _704.x;
                      } else {
                        _722 = 0.0f;
                      }
                    } else {
                      float4 _707 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_691, _692), _259);
                      _722 = _707.x;
                    }
                  } else {
                    float4 _710 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_691, _692), _259);
                    _722 = _710.x;
                  }
                } else {
                  float4 _713 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_691, _692), _259);
                  _722 = _713.x;
                }
              } else {
                float4 _716 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_691, _692), _259);
                _722 = _716.x;
              }
            } else {
              float4 _719 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_691, _692), _259);
              _722 = _719.x;
            }
            float _723 = _683 + _722;
            float _724 = _329 + 9.600000381469727f;
            float _725 = sin(_724);
            float _726 = cos(_724);
            float _727 = _563 * 0.75f;
            float _728 = _727 * _726;
            float _729 = _727 * _725;
            float _730 = _728 + _302;
            float _731 = _729 + _303;
            float _732 = max(_730, 0.0f);
            float _733 = max(_731, 0.0f);
            float _734 = min(_732, 1.0f);
            float _735 = min(_733, 1.0f);
            [branch]
            if (!_323) {
              bool _737 = (_297 == 1);
              [branch]
              if (!_737) {
                bool _739 = (_297 == 2);
                [branch]
                if (!_739) {
                  bool _741 = (_297 == 3);
                  [branch]
                  if (!_741) {
                    bool _743 = (_297 == 4);
                    [branch]
                    if (!_743) {
                      bool _745 = (_297 == 5);
                      [branch]
                      if (_745) {
                        float4 _747 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_734, _735), _259);
                        _765 = _747.x;
                      } else {
                        _765 = 0.0f;
                      }
                    } else {
                      float4 _750 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_734, _735), _259);
                      _765 = _750.x;
                    }
                  } else {
                    float4 _753 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_734, _735), _259);
                    _765 = _753.x;
                  }
                } else {
                  float4 _756 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_734, _735), _259);
                  _765 = _756.x;
                }
              } else {
                float4 _759 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_734, _735), _259);
                _765 = _759.x;
              }
            } else {
              float4 _762 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_734, _735), _259);
              _765 = _762.x;
            }
            float _766 = _723 + _765;
            float _767 = _329 + 12.0f;
            float _768 = sin(_767);
            float _769 = cos(_767);
            float _770 = _563 * 0.829156219959259f;
            float _771 = _770 * _769;
            float _772 = _770 * _768;
            float _773 = _771 + _302;
            float _774 = _772 + _303;
            float _775 = max(_773, 0.0f);
            float _776 = max(_774, 0.0f);
            float _777 = min(_775, 1.0f);
            float _778 = min(_776, 1.0f);
            [branch]
            if (!_323) {
              bool _780 = (_297 == 1);
              [branch]
              if (!_780) {
                bool _782 = (_297 == 2);
                [branch]
                if (!_782) {
                  bool _784 = (_297 == 3);
                  [branch]
                  if (!_784) {
                    bool _786 = (_297 == 4);
                    [branch]
                    if (!_786) {
                      bool _788 = (_297 == 5);
                      [branch]
                      if (_788) {
                        float4 _790 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_777, _778), _259);
                        _808 = _790.x;
                      } else {
                        _808 = 0.0f;
                      }
                    } else {
                      float4 _793 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_777, _778), _259);
                      _808 = _793.x;
                    }
                  } else {
                    float4 _796 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_777, _778), _259);
                    _808 = _796.x;
                  }
                } else {
                  float4 _799 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_777, _778), _259);
                  _808 = _799.x;
                }
              } else {
                float4 _802 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_777, _778), _259);
                _808 = _802.x;
              }
            } else {
              float4 _805 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_777, _778), _259);
              _808 = _805.x;
            }
            float _809 = _766 + _808;
            float _810 = _329 + 14.40000057220459f;
            float _811 = sin(_810);
            float _812 = cos(_810);
            float _813 = _563 * 0.9013878107070923f;
            float _814 = _813 * _812;
            float _815 = _813 * _811;
            float _816 = _814 + _302;
            float _817 = _815 + _303;
            float _818 = max(_816, 0.0f);
            float _819 = max(_817, 0.0f);
            float _820 = min(_818, 1.0f);
            float _821 = min(_819, 1.0f);
            [branch]
            if (!_323) {
              bool _823 = (_297 == 1);
              [branch]
              if (!_823) {
                bool _825 = (_297 == 2);
                [branch]
                if (!_825) {
                  bool _827 = (_297 == 3);
                  [branch]
                  if (!_827) {
                    bool _829 = (_297 == 4);
                    [branch]
                    if (!_829) {
                      bool _831 = (_297 == 5);
                      [branch]
                      if (_831) {
                        float4 _833 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_820, _821), _259);
                        _851 = _833.x;
                      } else {
                        _851 = 0.0f;
                      }
                    } else {
                      float4 _836 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_820, _821), _259);
                      _851 = _836.x;
                    }
                  } else {
                    float4 _839 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_820, _821), _259);
                    _851 = _839.x;
                  }
                } else {
                  float4 _842 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_820, _821), _259);
                  _851 = _842.x;
                }
              } else {
                float4 _845 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_820, _821), _259);
                _851 = _845.x;
              }
            } else {
              float4 _848 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_820, _821), _259);
              _851 = _848.x;
            }
            float _852 = _809 + _851;
            float _853 = _329 + 16.80000114440918f;
            float _854 = sin(_853);
            float _855 = cos(_853);
            float _856 = _563 * 0.9682458639144897f;
            float _857 = _856 * _855;
            float _858 = _856 * _854;
            float _859 = _857 + _302;
            float _860 = _858 + _303;
            float _861 = max(_859, 0.0f);
            float _862 = max(_860, 0.0f);
            float _863 = min(_861, 1.0f);
            float _864 = min(_862, 1.0f);
            [branch]
            if (!_323) {
              bool _866 = (_297 == 1);
              [branch]
              if (!_866) {
                bool _868 = (_297 == 2);
                [branch]
                if (!_868) {
                  bool _870 = (_297 == 3);
                  [branch]
                  if (!_870) {
                    bool _872 = (_297 == 4);
                    [branch]
                    if (!_872) {
                      bool _874 = (_297 == 5);
                      [branch]
                      if (_874) {
                        float4 _876 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_863, _864), _259);
                        _894 = _876.x;
                      } else {
                        _894 = 0.0f;
                      }
                    } else {
                      float4 _879 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_863, _864), _259);
                      _894 = _879.x;
                    }
                  } else {
                    float4 _882 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_863, _864), _259);
                    _894 = _882.x;
                  }
                } else {
                  float4 _885 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_863, _864), _259);
                  _894 = _885.x;
                }
              } else {
                float4 _888 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_863, _864), _259);
                _894 = _888.x;
              }
            } else {
              float4 _891 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_863, _864), _259);
              _894 = _891.x;
            }
            float _895 = _852 + _894;
            float _896 = _895 * 0.125f;
            _1345 = _896;
          } else {
            _1345 = 0.0f;
          }
        } else {
          float _899 = _20[_297];
          float _900 = _899 * 0.32621198892593384f;
          float _901 = _899 * 0.40580499172210693f;
          float _902 = _302 - _900;
          float _903 = _303 - _901;
          float _904 = max(_902, 0.0f);
          float _905 = max(_903, 0.0f);
          float _906 = min(_904, 1.0f);
          float _907 = min(_905, 1.0f);
          [branch]
          if (!_323) {
            bool _909 = (_297 == 1);
            [branch]
            if (!_909) {
              bool _911 = (_297 == 2);
              [branch]
              if (!_911) {
                bool _913 = (_297 == 3);
                [branch]
                if (!_913) {
                  bool _915 = (_297 == 4);
                  [branch]
                  if (!_915) {
                    float4 _917 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_906, _907), _259);
                    _935 = _917.x;
                  } else {
                    float4 _920 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_906, _907), _259);
                    _935 = _920.x;
                  }
                } else {
                  float4 _923 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_906, _907), _259);
                  _935 = _923.x;
                }
              } else {
                float4 _926 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_906, _907), _259);
                _935 = _926.x;
              }
            } else {
              float4 _929 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_906, _907), _259);
              _935 = _929.x;
            }
          } else {
            float4 _932 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_906, _907), _259);
            _935 = _932.x;
          }
          float _936 = _899 * 0.8401439785957336f;
          float _937 = _899 * 0.07357999682426453f;
          float _938 = _302 - _936;
          float _939 = _303 - _937;
          float _940 = max(_938, 0.0f);
          float _941 = max(_939, 0.0f);
          float _942 = min(_940, 1.0f);
          float _943 = min(_941, 1.0f);
          [branch]
          if (!_323) {
            bool _945 = (_297 == 1);
            [branch]
            if (!_945) {
              bool _947 = (_297 == 2);
              [branch]
              if (!_947) {
                bool _949 = (_297 == 3);
                [branch]
                if (!_949) {
                  bool _951 = (_297 == 4);
                  [branch]
                  if (!_951) {
                    float4 _953 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_942, _943), _259);
                    _971 = _953.x;
                  } else {
                    float4 _956 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_942, _943), _259);
                    _971 = _956.x;
                  }
                } else {
                  float4 _959 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_942, _943), _259);
                  _971 = _959.x;
                }
              } else {
                float4 _962 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_942, _943), _259);
                _971 = _962.x;
              }
            } else {
              float4 _965 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_942, _943), _259);
              _971 = _965.x;
            }
          } else {
            float4 _968 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_942, _943), _259);
            _971 = _968.x;
          }
          float _972 = _971 + _935;
          float _973 = _899 * 0.6959139704704285f;
          float _974 = _899 * 0.45713698863983154f;
          float _975 = _302 - _973;
          float _976 = _974 + _303;
          float _977 = max(_975, 0.0f);
          float _978 = max(_976, 0.0f);
          float _979 = min(_977, 1.0f);
          float _980 = min(_978, 1.0f);
          [branch]
          if (!_323) {
            bool _982 = (_297 == 1);
            [branch]
            if (!_982) {
              bool _984 = (_297 == 2);
              [branch]
              if (!_984) {
                bool _986 = (_297 == 3);
                [branch]
                if (!_986) {
                  bool _988 = (_297 == 4);
                  [branch]
                  if (!_988) {
                    float4 _990 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_979, _980), _259);
                    _1008 = _990.x;
                  } else {
                    float4 _993 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_979, _980), _259);
                    _1008 = _993.x;
                  }
                } else {
                  float4 _996 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_979, _980), _259);
                  _1008 = _996.x;
                }
              } else {
                float4 _999 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_979, _980), _259);
                _1008 = _999.x;
              }
            } else {
              float4 _1002 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_979, _980), _259);
              _1008 = _1002.x;
            }
          } else {
            float4 _1005 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_979, _980), _259);
            _1008 = _1005.x;
          }
          float _1009 = _972 + _1008;
          float _1010 = _899 * 0.20334500074386597f;
          float _1011 = _899 * 0.6207159757614136f;
          float _1012 = _302 - _1010;
          float _1013 = _1011 + _303;
          float _1014 = max(_1012, 0.0f);
          float _1015 = max(_1013, 0.0f);
          float _1016 = min(_1014, 1.0f);
          float _1017 = min(_1015, 1.0f);
          [branch]
          if (!_323) {
            bool _1019 = (_297 == 1);
            [branch]
            if (!_1019) {
              bool _1021 = (_297 == 2);
              [branch]
              if (!_1021) {
                bool _1023 = (_297 == 3);
                [branch]
                if (!_1023) {
                  bool _1025 = (_297 == 4);
                  [branch]
                  if (!_1025) {
                    float4 _1027 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1016, _1017), _259);
                    _1045 = _1027.x;
                  } else {
                    float4 _1030 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1016, _1017), _259);
                    _1045 = _1030.x;
                  }
                } else {
                  float4 _1033 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1016, _1017), _259);
                  _1045 = _1033.x;
                }
              } else {
                float4 _1036 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1016, _1017), _259);
                _1045 = _1036.x;
              }
            } else {
              float4 _1039 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1016, _1017), _259);
              _1045 = _1039.x;
            }
          } else {
            float4 _1042 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1016, _1017), _259);
            _1045 = _1042.x;
          }
          float _1046 = _1009 + _1045;
          float _1047 = _899 * 0.9623399972915649f;
          float _1048 = _899 * 0.19498300552368164f;
          float _1049 = _1047 + _302;
          float _1050 = _303 - _1048;
          float _1051 = max(_1049, 0.0f);
          float _1052 = max(_1050, 0.0f);
          float _1053 = min(_1051, 1.0f);
          float _1054 = min(_1052, 1.0f);
          [branch]
          if (!_323) {
            bool _1056 = (_297 == 1);
            [branch]
            if (!_1056) {
              bool _1058 = (_297 == 2);
              [branch]
              if (!_1058) {
                bool _1060 = (_297 == 3);
                [branch]
                if (!_1060) {
                  bool _1062 = (_297 == 4);
                  [branch]
                  if (!_1062) {
                    float4 _1064 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1053, _1054), _259);
                    _1082 = _1064.x;
                  } else {
                    float4 _1067 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1053, _1054), _259);
                    _1082 = _1067.x;
                  }
                } else {
                  float4 _1070 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1053, _1054), _259);
                  _1082 = _1070.x;
                }
              } else {
                float4 _1073 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1053, _1054), _259);
                _1082 = _1073.x;
              }
            } else {
              float4 _1076 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1053, _1054), _259);
              _1082 = _1076.x;
            }
          } else {
            float4 _1079 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1053, _1054), _259);
            _1082 = _1079.x;
          }
          float _1083 = _1046 + _1082;
          float _1084 = _899 * 0.4734340012073517f;
          float _1085 = _899 * 0.4800260066986084f;
          float _1086 = _1084 + _302;
          float _1087 = _303 - _1085;
          float _1088 = max(_1086, 0.0f);
          float _1089 = max(_1087, 0.0f);
          float _1090 = min(_1088, 1.0f);
          float _1091 = min(_1089, 1.0f);
          [branch]
          if (!_323) {
            bool _1093 = (_297 == 1);
            [branch]
            if (!_1093) {
              bool _1095 = (_297 == 2);
              [branch]
              if (!_1095) {
                bool _1097 = (_297 == 3);
                [branch]
                if (!_1097) {
                  bool _1099 = (_297 == 4);
                  [branch]
                  if (!_1099) {
                    float4 _1101 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1090, _1091), _259);
                    _1119 = _1101.x;
                  } else {
                    float4 _1104 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1090, _1091), _259);
                    _1119 = _1104.x;
                  }
                } else {
                  float4 _1107 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1090, _1091), _259);
                  _1119 = _1107.x;
                }
              } else {
                float4 _1110 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1090, _1091), _259);
                _1119 = _1110.x;
              }
            } else {
              float4 _1113 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1090, _1091), _259);
              _1119 = _1113.x;
            }
          } else {
            float4 _1116 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1090, _1091), _259);
            _1119 = _1116.x;
          }
          float _1120 = _1083 + _1119;
          float _1121 = _899 * 0.5194560289382935f;
          float _1122 = _899 * 0.7670220136642456f;
          float _1123 = _1121 + _302;
          float _1124 = _1122 + _303;
          float _1125 = max(_1123, 0.0f);
          float _1126 = max(_1124, 0.0f);
          float _1127 = min(_1125, 1.0f);
          float _1128 = min(_1126, 1.0f);
          [branch]
          if (!_323) {
            bool _1130 = (_297 == 1);
            [branch]
            if (!_1130) {
              bool _1132 = (_297 == 2);
              [branch]
              if (!_1132) {
                bool _1134 = (_297 == 3);
                [branch]
                if (!_1134) {
                  bool _1136 = (_297 == 4);
                  [branch]
                  if (!_1136) {
                    float4 _1138 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1127, _1128), _259);
                    _1156 = _1138.x;
                  } else {
                    float4 _1141 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1127, _1128), _259);
                    _1156 = _1141.x;
                  }
                } else {
                  float4 _1144 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1127, _1128), _259);
                  _1156 = _1144.x;
                }
              } else {
                float4 _1147 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1127, _1128), _259);
                _1156 = _1147.x;
              }
            } else {
              float4 _1150 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1127, _1128), _259);
              _1156 = _1150.x;
            }
          } else {
            float4 _1153 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1127, _1128), _259);
            _1156 = _1153.x;
          }
          float _1157 = _1120 + _1156;
          float _1158 = _899 * 0.18546099960803986f;
          float _1159 = _899 * 0.893123984336853f;
          float _1160 = _1158 + _302;
          float _1161 = _303 - _1159;
          float _1162 = max(_1160, 0.0f);
          float _1163 = max(_1161, 0.0f);
          float _1164 = min(_1162, 1.0f);
          float _1165 = min(_1163, 1.0f);
          [branch]
          if (!_323) {
            bool _1167 = (_297 == 1);
            [branch]
            if (!_1167) {
              bool _1169 = (_297 == 2);
              [branch]
              if (!_1169) {
                bool _1171 = (_297 == 3);
                [branch]
                if (!_1171) {
                  bool _1173 = (_297 == 4);
                  [branch]
                  if (!_1173) {
                    float4 _1175 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1164, _1165), _259);
                    _1193 = _1175.x;
                  } else {
                    float4 _1178 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1164, _1165), _259);
                    _1193 = _1178.x;
                  }
                } else {
                  float4 _1181 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1164, _1165), _259);
                  _1193 = _1181.x;
                }
              } else {
                float4 _1184 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1164, _1165), _259);
                _1193 = _1184.x;
              }
            } else {
              float4 _1187 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1164, _1165), _259);
              _1193 = _1187.x;
            }
          } else {
            float4 _1190 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1164, _1165), _259);
            _1193 = _1190.x;
          }
          float _1194 = _1157 + _1193;
          float _1195 = _899 * 0.5074309706687927f;
          float _1196 = _899 * 0.06442499905824661f;
          float _1197 = _1195 + _302;
          float _1198 = _1196 + _303;
          float _1199 = max(_1197, 0.0f);
          float _1200 = max(_1198, 0.0f);
          float _1201 = min(_1199, 1.0f);
          float _1202 = min(_1200, 1.0f);
          [branch]
          if (!_323) {
            bool _1204 = (_297 == 1);
            [branch]
            if (!_1204) {
              bool _1206 = (_297 == 2);
              [branch]
              if (!_1206) {
                bool _1208 = (_297 == 3);
                [branch]
                if (!_1208) {
                  bool _1210 = (_297 == 4);
                  [branch]
                  if (!_1210) {
                    float4 _1212 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1201, _1202), _259);
                    _1230 = _1212.x;
                  } else {
                    float4 _1215 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1201, _1202), _259);
                    _1230 = _1215.x;
                  }
                } else {
                  float4 _1218 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1201, _1202), _259);
                  _1230 = _1218.x;
                }
              } else {
                float4 _1221 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1201, _1202), _259);
                _1230 = _1221.x;
              }
            } else {
              float4 _1224 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1201, _1202), _259);
              _1230 = _1224.x;
            }
          } else {
            float4 _1227 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1201, _1202), _259);
            _1230 = _1227.x;
          }
          float _1231 = _1194 + _1230;
          float _1232 = _899 * 0.8964200019836426f;
          float _1233 = _899 * 0.41245800256729126f;
          float _1234 = _1232 + _302;
          float _1235 = _1233 + _303;
          float _1236 = max(_1234, 0.0f);
          float _1237 = max(_1235, 0.0f);
          float _1238 = min(_1236, 1.0f);
          float _1239 = min(_1237, 1.0f);
          [branch]
          if (!_323) {
            bool _1241 = (_297 == 1);
            [branch]
            if (!_1241) {
              bool _1243 = (_297 == 2);
              [branch]
              if (!_1243) {
                bool _1245 = (_297 == 3);
                [branch]
                if (!_1245) {
                  bool _1247 = (_297 == 4);
                  [branch]
                  if (!_1247) {
                    float4 _1249 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1238, _1239), _259);
                    _1267 = _1249.x;
                  } else {
                    float4 _1252 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1238, _1239), _259);
                    _1267 = _1252.x;
                  }
                } else {
                  float4 _1255 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1238, _1239), _259);
                  _1267 = _1255.x;
                }
              } else {
                float4 _1258 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1238, _1239), _259);
                _1267 = _1258.x;
              }
            } else {
              float4 _1261 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1238, _1239), _259);
              _1267 = _1261.x;
            }
          } else {
            float4 _1264 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1238, _1239), _259);
            _1267 = _1264.x;
          }
          float _1268 = _1231 + _1267;
          float _1269 = _899 * 0.32194000482559204f;
          float _1270 = _899 * 0.9326149821281433f;
          float _1271 = _302 - _1269;
          float _1272 = _303 - _1270;
          float _1273 = max(_1271, 0.0f);
          float _1274 = max(_1272, 0.0f);
          float _1275 = min(_1273, 1.0f);
          float _1276 = min(_1274, 1.0f);
          [branch]
          if (!_323) {
            bool _1278 = (_297 == 1);
            [branch]
            if (!_1278) {
              bool _1280 = (_297 == 2);
              [branch]
              if (!_1280) {
                bool _1282 = (_297 == 3);
                [branch]
                if (!_1282) {
                  bool _1284 = (_297 == 4);
                  [branch]
                  if (!_1284) {
                    float4 _1286 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1275, _1276), _259);
                    _1304 = _1286.x;
                  } else {
                    float4 _1289 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1275, _1276), _259);
                    _1304 = _1289.x;
                  }
                } else {
                  float4 _1292 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1275, _1276), _259);
                  _1304 = _1292.x;
                }
              } else {
                float4 _1295 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1275, _1276), _259);
                _1304 = _1295.x;
              }
            } else {
              float4 _1298 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1275, _1276), _259);
              _1304 = _1298.x;
            }
          } else {
            float4 _1301 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1275, _1276), _259);
            _1304 = _1301.x;
          }
          float _1305 = _1268 + _1304;
          float _1306 = _899 * 0.7915589809417725f;
          float _1307 = _899 * 0.5977050065994263f;
          float _1308 = _302 - _1306;
          float _1309 = _303 - _1307;
          float _1310 = max(_1308, 0.0f);
          float _1311 = max(_1309, 0.0f);
          float _1312 = min(_1310, 1.0f);
          float _1313 = min(_1311, 1.0f);
          [branch]
          if (!_323) {
            bool _1315 = (_297 == 1);
            [branch]
            if (!_1315) {
              bool _1317 = (_297 == 2);
              [branch]
              if (!_1317) {
                bool _1319 = (_297 == 3);
                [branch]
                if (!_1319) {
                  bool _1321 = (_297 == 4);
                  [branch]
                  if (!_1321) {
                    float4 _1323 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1312, _1313), _259);
                    _1341 = _1323.x;
                  } else {
                    float4 _1326 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1312, _1313), _259);
                    _1341 = _1326.x;
                  }
                } else {
                  float4 _1329 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1312, _1313), _259);
                  _1341 = _1329.x;
                }
              } else {
                float4 _1332 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1312, _1313), _259);
                _1341 = _1332.x;
              }
            } else {
              float4 _1335 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1312, _1313), _259);
              _1341 = _1335.x;
            }
          } else {
            float4 _1338 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1312, _1313), _259);
            _1341 = _1338.x;
          }
          float _1342 = _1305 + _1341;
          float _1343 = _1342 * 0.0833333358168602f;
          _1345 = _1343;
        }
      } else {
        _1345 = 0.0f;
      }
      float _1346 = _1345 * photon.m_fShadowStrength;
      float _1347 = 1.0f - _1346;
      _1349 = _1347;
    } else {
      _1349 = 1.0f;
    }
    bool _1350 = (_1349 > 0.0f);
    [branch]
    if (_1350) {
      float _1352 = _239 * photon.m_xLightColour.x;
      float _1353 = _239 * photon.m_xLightColour.y;
      float _1354 = _239 * photon.m_xLightColour.z;
      float _1355 = g_xCamPos.x - _68;
      float _1356 = g_xCamPos.y - _72;
      float _1357 = g_xCamPos.z - _76;
      float _1358 = dot(float3(_1355, _1356, _1357), float3(_1355, _1356, _1357));
      float _1359 = rsqrt(_1358);
      float _1360 = _1359 * _1355;
      float _1361 = _1359 * _1356;
      float _1362 = _1359 * _1357;
      bool _1363 = (photon.m_fAreaLightRadius > 0.0f);
      [branch]
      if (_1363) {
        float _1365 = dot(float3(_1360, _1361, _1362), float3(_100, _101, _102));
        float _1366 = _1365 * 2.0f;
        float _1367 = _1366 * _100;
        float _1368 = _1366 * _101;
        float _1369 = _1366 * _102;
        float _1370 = _1360 - _1367;
        float _1371 = _1361 - _1368;
        float _1372 = _1362 - _1369;
        float _1373 = -0.0f - _1370;
        float _1374 = -0.0f - _1371;
        float _1375 = -0.0f - _1372;
        float _1376 = dot(float3(_204, _205, _206), float3(_1373, _1374, _1375));
        float _1377 = _1376 * _1373;
        float _1378 = _1376 * _1374;
        float _1379 = _1376 * _1375;
        float _1380 = _1377 - _204;
        float _1381 = _1378 - _205;
        float _1382 = _1379 - _206;
        float _1383 = _1380 * _1380;
        float _1384 = _1381 * _1381;
        float _1385 = _1383 + _1384;
        float _1386 = _1382 * _1382;
        float _1387 = _1385 + _1386;
        float _1388 = sqrt(_1387);
        float _1389 = photon.m_fAreaLightRadius / _1388;
        float _1390 = saturate(_1389);
        float _1391 = _1380 * _1390;
        float _1392 = _1381 * _1390;
        float _1393 = _1382 * _1390;
        float _1394 = _1391 + _204;
        float _1395 = _1392 + _205;
        float _1396 = _1393 + _206;
        float _1397 = dot(float3(_1394, _1395, _1396), float3(_1394, _1395, _1396));
        float _1398 = rsqrt(_1397);
        float _1399 = _1394 * _1398;
        float _1400 = _1395 * _1398;
        float _1401 = _1396 * _1398;
        float _1402 = dot(float3(_204, _205, _206), float3(_204, _205, _206));
        float _1403 = rsqrt(_1402);
        float _1404 = _1403 * photon.m_fAreaLightRadius;
        _1406 = _1399;
        _1407 = _1400;
        _1408 = _1401;
        _1409 = _1404;
      } else {
        _1406 = _213;
        _1407 = _214;
        _1408 = _215;
        _1409 = 0.0f;
      }
      // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
      bool _1410 = !MaterialIdEquals(_82.w, 0.019607843831181526f);
      float _1411 = select(_1410, _87.x, 0.0f);
      float _1412 = _1406 + _1360;
      float _1413 = _1407 + _1361;
      float _1414 = _1408 + _1362;
      float _1415 = dot(float3(_1412, _1413, _1414), float3(_1412, _1413, _1414));
      float _1416 = rsqrt(_1415);
      float _1417 = _1416 * _1412;
      float _1418 = _1416 * _1413;
      float _1419 = _1416 * _1414;
      float _1420 = dot(float3(_100, _101, _102), float3(_1360, _1361, _1362));
      float _1421 = saturate(_1420);
      float _1422 = dot(float3(_100, _101, _102), float3(_1417, _1418, _1419));
      float _1423 = saturate(_1422);
      float _1424 = dot(float3(_1360, _1361, _1362), float3(_1417, _1418, _1419));
      float _1425 = saturate(_1424);
      bool _1426 = MaterialIdEquals(_82.w, 0.01568627543747425f);
      [branch]
      if (!_1426) {
        bool _1428 = MaterialIdEquals(_82.w, 0.007843137718737125f);
        [branch]
        if (!_1428) {
          bool _1430 = MaterialIdEquals(_82.w, 0.003921568859368563f);
          [branch]
          if (_1430) {
            float _1432 = -0.0f - _100;
            float _1433 = -0.0f - _101;
            float _1434 = -0.0f - _102;
            float _1435 = dot(float3(_213, _214, _215), float3(_1432, _1433, _1434));
            float _1436 = saturate(_1435);
            float _1437 = _1436 * 0.4000000059604645f;
            float _1438 = -0.0f - _1360;
            float _1439 = -0.0f - _1361;
            float _1440 = -0.0f - _1362;
            float _1441 = dot(float3(_213, _214, _215), float3(_1438, _1439, _1440));
            float _1442 = saturate(_1441);
            float _1443 = log2(_1442);
            float _1444 = _1443 * 7.0f;
            float _1445 = exp2(_1444);
            float _1446 = _1445 + _1437;
            float _1447 = saturate(_1446);
            float _1448 = _1447 * _1411;
            float _1449 = _1448 + _243;
            _1467 = _82.x;
            _1468 = _82.y;
            _1469 = _82.z;
            _1470 = 0.02800000086426735f;
            _1471 = 0.02800000086426735f;
            _1472 = 0.02800000086426735f;
            _1473 = _1449;
          } else {
            float _1451 = _82.x + -0.03999999910593033f;
            float _1452 = _82.y + -0.03999999910593033f;
            float _1453 = _82.z + -0.03999999910593033f;
            float _1454 = _1411 * _1451;
            float _1455 = _1411 * _1452;
            float _1456 = _1411 * _1453;
            float _1457 = _1454 + 0.03999999910593033f;
            float _1458 = _1455 + 0.03999999910593033f;
            float _1459 = _1456 + 0.03999999910593033f;
            float _1460 = _1411 * _82.x;
            float _1461 = _1411 * _82.y;
            float _1462 = _1411 * _82.z;
            float _1463 = _82.x - _1460;
            float _1464 = _82.y - _1461;
            float _1465 = _82.z - _1462;
            _1467 = _1463;
            _1468 = _1464;
            _1469 = _1465;
            _1470 = _1457;
            _1471 = _1458;
            _1472 = _1459;
            _1473 = _243;
          }
        } else {
          _1467 = _82.x;
          _1468 = _82.y;
          _1469 = _82.z;
          _1470 = 0.02800000086426735f;
          _1471 = 0.02800000086426735f;
          _1472 = 0.02800000086426735f;
          _1473 = _243;
        }
      } else {
        _1467 = _82.x;
        _1468 = _82.y;
        _1469 = _82.z;
        _1470 = 0.04699999839067459f;
        _1471 = 0.04699999839067459f;
        _1472 = 0.04699999839067459f;
        _1473 = _243;
      }
      float _1474 = _1473 * _1467;
      float _1475 = _1473 * _1468;
      float _1476 = _1473 * _1469;
      float _1477 = max(_87.y, 0.05000000074505806f);
      float _1478 = _1477 * _1477;
      [branch]
      if (_1426) {
        float _1480 = 1.0f - _87.y;
        float _1481 = saturate(_1480);
        float _1482 = dot(float3(_82.x, _82.y, _82.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
        float _1483 = _87.x * 0.6000000238418579f;
        float _1484 = _1483 + -0.3500000238418579f;
        float _1485 = _1483 + -0.25f;
        float _1486 = _1481 * 0.05000000074505806f;
        float _1487 = _1485 - _1486;
        float _1488 = log2(_1481);
        float _1489 = _1488 * 8.0f;
        float _1490 = exp2(_1489);
        float _1491 = _1490 * 500.0f;
        float _1492 = _1491 + 20.0f;
        float _1493 = _1488 * 6.0f;
        float _1494 = exp2(_1493);
        float _1495 = _1494 * 2000.0f;
        float _1496 = _1495 + 50.0f;
        float _1497 = _87.x * 0.13500000536441803f;
        float _1498 = _1497 + 0.015000000596046448f;
        float _1499 = _1481 + 0.10000000149011612f;
        float _1500 = _87.x * 0.007499999832361937f;
        float _1501 = _1500 + 0.007499999832361937f;
        float _1502 = _100 * _1484;
        float _1503 = _101 * _1484;
        float _1504 = _102 * _1484;
        float _1505 = _1502 + _105;
        float _1506 = _1503 + _106;
        float _1507 = _113 + _1504;
        float _1508 = dot(float3(_1505, _1506, _1507), float3(_1505, _1506, _1507));
        float _1509 = rsqrt(_1508);
        float _1510 = _1509 * _1505;
        float _1511 = _1509 * _1506;
        float _1512 = _1509 * _1507;
        float _1513 = dot(float3(_1510, _1511, _1512), float3(_1417, _1418, _1419));
        float _1514 = _1513 * _1513;
        float _1515 = 1.0f - _1514;
        float _1516 = saturate(_1515);
        float _1517 = sqrt(_1516);
        float _1518 = _1513 + 1.0f;
        float _1519 = saturate(_1518);
        float _1520 = _1519 * 2.0f;
        float _1521 = 3.0f - _1520;
        float _1522 = log2(_1517);
        float _1523 = _1522 * _1492;
        float _1524 = exp2(_1523);
        float _1525 = _1490 * 19.89436912536621f;
        float _1526 = _1525 + 1.1140847206115723f;
        float _1527 = _1499 * _1498;
        float _1528 = _1527 * _1526;
        float _1529 = _1519 * _1519;
        float _1530 = _1529 * _1528;
        float _1531 = _1530 * _1521;
        float _1532 = _1531 * _1524;
        float _1533 = max(_1482, 0.0010000000474974513f);
        float _1534 = _82.x / _1533;
        float _1535 = _82.y / _1533;
        float _1536 = _82.z / _1533;
        float _1537 = _1532 * _1534;
        float _1538 = _1532 * _1535;
        float _1539 = _1532 * _1536;
        float _1540 = _1487 * _100;
        float _1541 = _1487 * _101;
        float _1542 = _1487 * _102;
        float _1543 = _1540 + _105;
        float _1544 = _1541 + _106;
        float _1545 = _1542 + _113;
        float _1546 = dot(float3(_1543, _1544, _1545), float3(_1543, _1544, _1545));
        float _1547 = rsqrt(_1546);
        float _1548 = _1547 * _1543;
        float _1549 = _1547 * _1544;
        float _1550 = _1547 * _1545;
        float _1551 = dot(float3(_1548, _1549, _1550), float3(_1417, _1418, _1419));
        float _1552 = _1551 * _1551;
        float _1553 = 1.0f - _1552;
        float _1554 = saturate(_1553);
        float _1555 = sqrt(_1554);
        float _1556 = _1551 + 1.0f;
        float _1557 = saturate(_1556);
        float _1558 = _1557 * 2.0f;
        float _1559 = 3.0f - _1558;
        float _1560 = log2(_1555);
        float _1561 = _1560 * _1496;
        float _1562 = exp2(_1561);
        float _1563 = _1494 * 79.57747650146484f;
        float _1564 = _1563 + 2.3077468872070312f;
        float _1565 = _1481 * _1501;
        float _1566 = _1565 * _1564;
        float _1567 = _1557 * _1557;
        float _1568 = _1567 * _1566;
        float _1569 = _1568 * _1559;
        float _1570 = _1569 * _1562;
        float _1571 = _1570 + _1537;
        float _1572 = _1570 + _1538;
        float _1573 = _1570 + _1539;
        float _1574 = _243 * photon.m_fSpecularStrength;
        float _1575 = _1574 * _1571;
        float _1576 = _1574 * _1572;
        float _1577 = _1574 * _1573;
        _1632 = _1575;
        _1633 = _1576;
        _1634 = _1577;
      } else {
        float _1579 = 1.0f - _1478;
        float _1580 = _1579 * _1409;
        float _1581 = saturate(_1580);
        float _1582 = 1.0f - _1470;
        float _1583 = 1.0f - _1471;
        float _1584 = 1.0f - _1472;
        float _1585 = _1425 * 5.55472993850708f;
        float _1586 = -6.983160018920898f - _1585;
        float _1587 = _1586 * _1425;
        float _1588 = exp2(_1587);
        float _1589 = _1588 * _1582;
        float _1590 = _1588 * _1583;
        float _1591 = _1588 * _1584;
        float _1592 = _1589 + _1470;
        float _1593 = _1590 + _1471;
        float _1594 = _1591 + _1472;
        bool _1595 = (_1581 > 0.0f);
        float _1596 = _1478 * _1478;
        [branch]
        if (_1595) {
          float _1598 = _1581 * 0.25f;
          float _1599 = _1478 * 3.0f;
          float _1600 = _1581 + _1599;
          float _1601 = _1598 * _1600;
          float _1602 = _1425 + 0.0010000000474974513f;
          float _1603 = _1601 / _1602;
          float _1604 = _1603 + _1596;
          float _1605 = _1596 / _1604;
          _1607 = _1605;
        } else {
          _1607 = 1.0f;
        }
        float _1608 = 2.0f - _1478;
        float _1609 = _1608 * _1421;
        float _1610 = _1609 + _1478;
        float _1611 = _1608 * _243;
        float _1612 = _1611 + _1478;
        float _1613 = _1610 * _1612;
        float _1614 = 1.0f / _1613;
        float _1615 = _1596 * _1423;
        float _1616 = _1615 - _1423;
        float _1617 = _1616 * _1423;
        float _1618 = _1617 + 1.0f;
        float _1619 = _1618 * _1618;
        float _1620 = 1.0f / _1619;
        float _1621 = _243 * photon.m_fSpecularStrength;
        float _1622 = _1621 * _1596;
        float _1623 = _1622 * _1614;
        float _1624 = _1623 * _1620;
        float _1625 = _1607 * _1592;
        float _1626 = _1625 * _1624;
        float _1627 = _1607 * _1593;
        float _1628 = _1627 * _1624;
        float _1629 = _1607 * _1594;
        float _1630 = _1629 * _1624;
        _1632 = _1626;
        _1633 = _1628;
        _1634 = _1630;
      }
      float _1635 = _1632 + _1474;
      float _1636 = _1633 + _1475;
      float _1637 = _1634 + _1476;
      bool _1638 = MaterialIdEquals(_82.w, 0.019607843831181526f);
      [branch]
      if (_1638) {
        bool _1640 = (_87.x > 0.49803921580314636f);
        float _1641 = _87.x + -0.501960813999176f;
        float _1642 = select(_1640, _1641, _87.x);
        float _1643 = _1642 * 2.007874011993408f;
        float _1644 = select(_1640, 0.5f, 0.0f);
        float _1645 = -0.0f - _100;
        float _1646 = -0.0f - _101;
        float _1647 = -0.0f - _102;
        float _1648 = dot(float3(_213, _214, _215), float3(_1645, _1646, _1647));
        float _1649 = saturate(_1648);
        float _1650 = _1649 * 0.4000000059604645f;
        float _1651 = -0.0f - _1360;
        float _1652 = -0.0f - _1361;
        float _1653 = -0.0f - _1362;
        float _1654 = dot(float3(_213, _214, _215), float3(_1651, _1652, _1653));
        float _1655 = saturate(_1654);
        float _1656 = log2(_1655);
        float _1657 = _1656 * 7.0f;
        float _1658 = exp2(_1657);
        float _1659 = _1658 + _1650;
        float _1660 = saturate(_1659);
        float _1661 = _1660 * _1644;
        float _1662 = _1661 * _1467;
        float _1663 = _1661 * _1468;
        float _1664 = _1661 * _1469;
        float _1665 = abs(_1467);
        float _1666 = abs(_1468);
        float _1667 = abs(_1469);
        float _1668 = sqrt(_1665);
        float _1669 = sqrt(_1666);
        float _1670 = sqrt(_1667);
        float _1671 = 1.0f - _1668;
        float _1672 = 1.0f - _1669;
        float _1673 = 1.0f - _1670;
        float _1674 = _1425 * 5.55472993850708f;
        float _1675 = -6.983160018920898f - _1674;
        float _1676 = _1675 * _1425;
        float _1677 = exp2(_1676);
        float _1678 = _1677 * _1671;
        float _1679 = _1677 * _1672;
        float _1680 = _1673 * _1677;
        float _1681 = _1678 + _1668;
        float _1682 = _1679 + _1669;
        float _1683 = _1680 + _1670;
        float _1684 = _1421 + _243;
        float _1685 = _1421 * _243;
        float _1686 = _1684 - _1685;
        float _1687 = _1686 * 4.0f;
        float _1688 = _1687 + 9.999999682655225e-21f;
        float _1689 = 1.0f / _1688;
        float _1690 = 0.5f / _1478;
        float _1691 = _1423 * _1423;
        float _1692 = 1.0f - _1691;
        float _1693 = _1690 + 1.0f;
        float _1694 = log2(_1692);
        float _1695 = _1694 * _1690;
        float _1696 = exp2(_1695);
        float _1697 = _1693 * _1689;
        float _1698 = _1697 * _1696;
        float _1699 = _243 * photon.m_fSpecularStrength;
        float _1700 = _1681 * _1699;
        float _1701 = _1700 * _1698;
        float _1702 = _1682 * _1699;
        float _1703 = _1702 * _1698;
        float _1704 = _1683 * _1699;
        float _1705 = _1704 * _1698;
        float _1706 = _1662 - _1632;
        float _1707 = _1706 + _1701;
        float _1708 = _1663 - _1633;
        float _1709 = _1708 + _1703;
        float _1710 = _1664 - _1634;
        float _1711 = _1710 + _1705;
        float _1712 = _1707 * _1643;
        float _1713 = _1709 * _1643;
        float _1714 = _1711 * _1643;
        float _1715 = _1712 + _1635;
        float _1716 = _1713 + _1636;
        float _1717 = _1714 + _1637;
        _1719 = _1715;
        _1720 = _1716;
        _1721 = _1717;
      } else {
        _1719 = _1635;
        _1720 = _1636;
        _1721 = _1637;
      }
      float _1722 = _1719 * _1352;
      float _1723 = _1720 * _1353;
      float _1724 = _1721 * _1354;
      float _1725 = min(_1722, 1000.0f);
      float _1726 = min(_1723, 1000.0f);
      float _1727 = min(_1724, 1000.0f);
      bool _1728 = MaterialIdEquals(_82.w, 0.007843137718737125f);
      [branch]
      if (_1728) {
        float _1730 = _82.x * 0.019444789737462997f;
        float _1731 = _82.y * 1.680522836977616e-05f;
        float _1732 = _82.z * 3.190706726607928e-11f;
        float _1733 = -0.0f - _100;
        float _1734 = -0.0f - _101;
        float _1735 = -0.0f - _102;
        float _1736 = dot(float3(_213, _214, _215), float3(_1733, _1734, _1735));
        float _1737 = _1736 + 0.30000001192092896f;
        float _1738 = saturate(_1737);
        float _1739 = _1730 * _1352;
        float _1740 = _1739 * _1738;
        float _1741 = _1731 * _1353;
        float _1742 = _1741 * _1738;
        float _1743 = _1732 * _1354;
        float _1744 = _1743 * _1738;
        float _1745 = _1740 + _1725;
        float _1746 = _1742 + _1726;
        float _1747 = _1744 + _1727;
        _1749 = _1745;
        _1750 = _1746;
        _1751 = _1747;
      } else {
        _1749 = _1725;
        _1750 = _1726;
        _1751 = _1727;
      }
      bool _1752 = (_30 < 3.0f);
      bool _1753 = _1752 && _1728;
      [branch]
      if (_1753) {
        float _1755 = _30 + -2.0f;
        float _1756 = max(_1755, 0.0f);
        float _1761 = 1.0f - g_xSubsurfaceScatteringWeight.x;
        float _1762 = 1.0f - g_xSubsurfaceScatteringWeight.y;
        float _1763 = 1.0f - g_xSubsurfaceScatteringWeight.z;
        float _1764 = _1761 * _1756;
        float _1765 = _1762 * _1756;
        float _1766 = _1763 * _1756;
        float _1767 = _1764 + g_xSubsurfaceScatteringWeight.x;
        float _1768 = _1765 + g_xSubsurfaceScatteringWeight.y;
        float _1769 = _1766 + g_xSubsurfaceScatteringWeight.z;
        float _1770 = _1767 * _1749;
        float _1771 = _1768 * _1750;
        float _1772 = _1769 * _1751;
        _1774 = _1770;
        _1775 = _1771;
        _1776 = _1772;
      } else {
        _1774 = _1749;
        _1775 = _1750;
        _1776 = _1751;
      }
      int _1778 = _19[_297];
      bool _1779 = (_1778 > -1);
      [branch]
      if (_1779) {
        int _1782 = _18[_297];
        float _1786 = _global_0[_1782];
        float _1787 = _global_1[_1782];
        float _1788 = _global_2[_1782];
        float _1789 = _1786 * _1774;
        float _1790 = _1787 * _1775;
        float _1791 = _1788 * _1776;
        _1793 = true;
        _1794 = _1789;
        _1795 = _1790;
        _1796 = _1791;
        _1797 = _1349;
      } else {
        _1793 = true;
        _1794 = _1774;
        _1795 = _1775;
        _1796 = _1776;
        _1797 = _1349;
      }
    } else {
      _1793 = false;
      _1794 = 0.0f;
      _1795 = 0.0f;
      _1796 = 0.0f;
      _1797 = _1349;
    }
  } else {
    _1793 = false;
    _1794 = 0.0f;
    _1795 = 0.0f;
    _1796 = 0.0f;
    _1797 = 1.0f;
  }
  [branch]
  if (!_1793) {
    if (true) discard;
  }
  SV_Target.x = _1794;
  SV_Target.y = _1795;
  SV_Target.z = _1796;
  SV_Target.w = _1797;
  return SV_Target;
}
