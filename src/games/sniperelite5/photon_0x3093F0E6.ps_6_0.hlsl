#include "./shared.h"
// Baseline: 5 fewer fmul fast (dxc reassociation/CSE of the shadow-offset product (0.25*S) and the specular chains c*K*S), commutative fadd, phi incoming order, GEP inbounds; otherwise identical to the original DXIL

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
  row_major float4x4 m_xLightOrientation;
  row_major float4x4 m_xCustomVolumeMatrix;
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
  bool m_bUseProjCube;
  bool m_bUseDualProjCube;
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

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _18[6];
  int _19[6];
  int _20 = int(SV_Position.x);
  int _21 = int(SV_Position.y);
  float4 _22 = g_xLighting_DepthStencil.Load(int3(_20, _21, 0));
  float _27 = g_xDepthProjViewUnpack.y - _22.x;
  float _28 = g_xDepthProjViewUnpack.x / _27;
  float _32 = g_xCameraTanHalfFOV.x * _28;
  float _33 = g_xCameraTanHalfFOV.y * _28;
  float _37 = g_xTwoOverScreenDimensions.z + SV_Position.x;
  float _38 = g_xTwoOverScreenDimensions.w + SV_Position.y;
  float _41 = _37 * g_xTwoOverScreenDimensions.x;
  float _42 = _38 * g_xTwoOverScreenDimensions.y;
  float _43 = _41 + -1.0f;
  float _44 = _42 + -1.0f;
  float _45 = _32 * _43;
  float _46 = _33 * _44;
  float _63 = _45 * (g_xInvView[0].x);
  float _64 = mad((g_xInvView[1].x), _46, _63);
  float _65 = mad((g_xInvView[2].x), _28, _64);
  float _66 = _65 + (g_xInvView[3].x);
  float _67 = _45 * (g_xInvView[0].y);
  float _68 = mad((g_xInvView[1].y), _46, _67);
  float _69 = mad((g_xInvView[2].y), _28, _68);
  float _70 = _69 + (g_xInvView[3].y);
  float _71 = _45 * (g_xInvView[0].z);
  float _72 = mad((g_xInvView[1].z), _46, _71);
  float _73 = mad((g_xInvView[2].z), _28, _72);
  float _74 = _73 + (g_xInvView[3].z);
  float4 _75 = g_xLighting_NormalBuffer.Load(int3(_20, _21, 0));
  float4 _80 = g_xLighting_AlbedoBuffer.Load(int3(_20, _21, 0));
  float4 _85 = g_xLighting_PBRPropertiesBuffer.Load(int3(_20, _21, 0));
  float _90 = _75.x * 2.0f;
  float _91 = _75.y * 2.0f;
  float _92 = _75.z * 2.0f;
  float _93 = _90 + -1.0f;
  float _94 = _91 + -1.0f;
  float _95 = _92 + -1.0f;
  float _96 = dot(float3(_93, _94, _95), float3(_93, _94, _95));
  float _97 = rsqrt(_96);
  float _98 = _97 * _93;
  float _99 = _97 * _94;
  float _100 = _97 * _95;
  float _101 = _85.z * 2.0f;
  float _102 = _85.w * 2.0f;
  float _103 = _101 + -1.0f;
  float _104 = _102 + -1.0f;
  float _105 = dot(float2(_103, _104), float2(_103, _104));
  float _106 = 1.0f - _105;
  float _107 = saturate(_106);
  float _108 = sqrt(_107);
  bool _109 = (_75.w != 0.0f);
  float _110 = -0.0f - _108;
  float _111 = select(_109, _108, _110);
  uint photon_index = g_uPhotonIndex;
  float3 p_m_xLightPos = g_axPhotons[photon_index].m_xLightPos;
  float p_m_fAreaLightRadius = g_axPhotons[photon_index].m_fAreaLightRadius;
  float3 p_m_xLightDir = g_axPhotons[photon_index].m_xLightDir;
  float p_m_fLightRange = g_axPhotons[photon_index].m_fLightRange;
  float3 p_m_xLightColour = g_axPhotons[photon_index].m_xLightColour;
  int p_m_bUseLimitAngles = g_axPhotons[photon_index].m_bUseLimitAngles;
  float p_m_fLightFalloffScale = g_axPhotons[photon_index].m_fLightFalloffScale;
  float p_m_fLightFalloffPower = g_axPhotons[photon_index].m_fLightFalloffPower;
  float p_m_fLightAngleOuter = g_axPhotons[photon_index].m_fLightAngleOuter;
  float p_m_fRcpLightAngleRange = g_axPhotons[photon_index].m_fRcpLightAngleRange;
  float2 p_m_xDepthProjection = g_axPhotons[photon_index].m_xDepthProjection;
  float p_m_fShadowStrength = g_axPhotons[photon_index].m_fShadowStrength;
  float p_m_fShadowSoftness = g_axPhotons[photon_index].m_fShadowSoftness;
  float p_m_fShadowNearPlane = g_axPhotons[photon_index].m_fShadowNearPlane;
  float p_m_fShadowFarPlane = g_axPhotons[photon_index].m_fShadowFarPlane;
  float p_m_fShadowBias = g_axPhotons[photon_index].m_fShadowBias;
  float p_m_fSpecularStrength = g_axPhotons[photon_index].m_fSpecularStrength;
  float p_m_axFace_0_fInvSize = g_axPhotons[photon_index].m_axFace[0].fInvSize;
  int p_m_axFace_0_iShadowIndex = g_axPhotons[photon_index].m_axFace[0].iShadowIndex;
  float p_m_axFace_1_fInvSize = g_axPhotons[photon_index].m_axFace[1].fInvSize;
  int p_m_axFace_1_iShadowIndex = g_axPhotons[photon_index].m_axFace[1].iShadowIndex;
  float p_m_axFace_2_fInvSize = g_axPhotons[photon_index].m_axFace[2].fInvSize;
  int p_m_axFace_2_iShadowIndex = g_axPhotons[photon_index].m_axFace[2].iShadowIndex;
  float p_m_axFace_3_fInvSize = g_axPhotons[photon_index].m_axFace[3].fInvSize;
  int p_m_axFace_3_iShadowIndex = g_axPhotons[photon_index].m_axFace[3].iShadowIndex;
  float p_m_axFace_4_fInvSize = g_axPhotons[photon_index].m_axFace[4].fInvSize;
  int p_m_axFace_4_iShadowIndex = g_axPhotons[photon_index].m_axFace[4].iShadowIndex;
  float p_m_axFace_5_fInvSize = g_axPhotons[photon_index].m_axFace[5].fInvSize;
  int p_m_axFace_5_iShadowIndex = g_axPhotons[photon_index].m_axFace[5].iShadowIndex;
  float _178 = p_m_xLightPos.x - _66;
  float _179 = p_m_xLightPos.y - _70;
  float _180 = p_m_xLightPos.z - _74;
  float _181 = _178 * _178;
  float _182 = _179 * _179;
  float _183 = _182 + _181;
  float _184 = _180 * _180;
  float _185 = _183 + _184;
  float _186 = sqrt(_185);
  float _187 = _178 / _186;
  float _188 = _179 / _186;
  float _189 = _180 / _186;
  float _190 = _186 - p_m_fAreaLightRadius;
  float _191 = p_m_fLightRange - p_m_fAreaLightRadius;
  float _192 = _190 / _191;
  float _193 = saturate(_192);
  float _194 = 1.0f - _193;
  float _195 = _194 * p_m_fLightFalloffScale;
  float _196 = saturate(_195);
  float _197 = log2(_196);
  float _198 = _197 * p_m_fLightFalloffPower;
  float _199 = exp2(_198);
  bool _200 = (p_m_bUseLimitAngles == 0);
  float _213;
  int _271;
  float _272;
  float _273;
  float _342;
  float _355;
  float _356;
  float _396;
  float _411;
  float _412;
  float _452;
  float _467;
  float _468;
  float _508;
  float _523;
  float _524;
  float _577;
  float _616;
  float _656;
  float _696;
  float _739;
  float _782;
  float _825;
  float _868;
  float _909;
  float _945;
  float _982;
  float _1019;
  float _1056;
  float _1093;
  float _1130;
  float _1167;
  float _1204;
  float _1241;
  float _1278;
  float _1315;
  float _1319;
  float _1323;
  float _1380;
  float _1381;
  float _1382;
  float _1383;
  float _1441;
  float _1442;
  float _1443;
  float _1444;
  float _1445;
  float _1446;
  float _1447;
  float _1581;
  float _1606;
  float _1607;
  float _1608;
  float _1693;
  float _1694;
  float _1695;
  float _1723;
  float _1724;
  float _1725;
  bool _1748;
  float _1749;
  float _1750;
  float _1751;
  float _1752;
  [branch]
  if (!_200) {
    float _207 = dot(float3(_187, _188, _189), float3(p_m_xLightDir.x, p_m_xLightDir.y, p_m_xLightDir.z));
    float _208 = _207 + p_m_fLightAngleOuter;
    float _209 = _208 * p_m_fRcpLightAngleRange;
    float _210 = saturate(_209);
    float _211 = _210 * _199;
    _213 = _211;
  } else {
    _213 = _199;
  }
  bool _214 = (_213 < 9.999999747378752e-05f);
  [branch]
  if (!_214) {
    float _216 = dot(float3(_98, _99, _100), float3(_187, _188, _189));
    float _217 = saturate(_216);
    float _218 = 1.0f - _217;
    float _219 = _218 * p_m_fShadowBias;
    float _220 = max(_219, p_m_fShadowBias);
    float _221 = -0.0f - _178;
    float _222 = -0.0f - _180;
    float _223 = abs(_221);
    float _224 = abs(_179);
    float _225 = abs(_222);
    float _226 = max(_224, _225);
    float _227 = max(_223, _226);
    float _228 = _221 / _227;
    float _229 = _179 / _227;
    float _230 = _222 / _227;
    float _231 = _227 - _220;
    float _232 = p_m_xDepthProjection.y / _231;
    float _233 = _232 + p_m_xDepthProjection.x;
    float _234 = 1.0f - _233;
    float _235 = _234 * 2.0f;
    float _236 = _235 + -1.0f;
    float _237 = p_m_fShadowNearPlane * 2.0f;
    float _238 = _237 * p_m_fShadowFarPlane;
    float _239 = p_m_fShadowFarPlane + p_m_fShadowNearPlane;
    float _240 = p_m_fShadowFarPlane - p_m_fShadowNearPlane;
    float _241 = _236 * _240;
    float _242 = _239 - _241;
    float _243 = _238 / _242;
    float _244 = _243 - p_m_fShadowNearPlane;
    float _245 = _244 / _240;
    float _246 = saturate(_245);
    bool _247 = (_224 > _223);
    [branch]
    if (_247) {
      bool _249 = (_225 > _224);
      [branch]
      if (_249) {
        bool _251 = (_230 < 0.0f);
        float _252 = -0.0f - _229;
        [branch]
        if (_251) {
          float _254 = -0.0f - _228;
          _271 = 5;
          _272 = _254;
          _273 = _252;
        } else {
          _271 = 4;
          _272 = _228;
          _273 = _252;
        }
      } else {
        bool _256 = (_229 < 0.0f);
        [branch]
        if (_256) {
          float _258 = -0.0f - _230;
          _271 = 2;
          _272 = _228;
          _273 = _258;
        } else {
          _271 = 3;
          _272 = _228;
          _273 = _230;
        }
      }
    } else {
      bool _260 = (_225 > _223);
      float _261 = -0.0f - _229;
      [branch]
      if (_260) {
        bool _263 = (_230 < 0.0f);
        [branch]
        if (_263) {
          float _265 = -0.0f - _228;
          _271 = 5;
          _272 = _265;
          _273 = _261;
        } else {
          _271 = 4;
          _272 = _228;
          _273 = _261;
        }
      } else {
        bool _267 = (_228 < 0.0f);
        [branch]
        if (!_267) {
          float _269 = -0.0f - _230;
          _271 = 0;
          _272 = _269;
          _273 = _261;
        } else {
          _271 = 1;
          _272 = _230;
          _273 = _261;
        }
      }
    }
    float _274 = _272 * 0.5f;
    float _275 = _273 * 0.5f;
    float _276 = _274 + 0.5f;
    float _277 = _275 + 0.5f;
    bool _278 = (p_m_fShadowStrength > 0.0f);
    [branch]
    if (_278) {
      _18[0] = p_m_axFace_0_fInvSize;
      _19[0] = (int)(p_m_axFace_0_iShadowIndex);
      _18[1] = p_m_axFace_1_fInvSize;
      _19[1] = (int)(p_m_axFace_1_iShadowIndex);
      _18[2] = p_m_axFace_2_fInvSize;
      _19[2] = (int)(p_m_axFace_2_iShadowIndex);
      _18[3] = p_m_axFace_3_fInvSize;
      _19[3] = (int)(p_m_axFace_3_iShadowIndex);
      _18[4] = p_m_axFace_4_fInvSize;
      _19[4] = (int)(p_m_axFace_4_iShadowIndex);
      _18[5] = p_m_axFace_5_fInvSize;
      _19[5] = (int)(p_m_axFace_5_iShadowIndex);
      int _293 = _19[_271];
      bool _294 = (_293 == -1);
      [branch]
      if (!_294) {
        bool _296 = (p_m_fShadowSoftness > 0.0f);
        bool _297 = (_271 == 0);
        [branch]
        if (_296) {
          float _299 = dot(float2(SV_Position.x, SV_Position.y), float2(0.0671105608344078f, 0.005837149918079376f));
          float _300 = frac(_299);
          float _301 = _300 * 52.98291778564453f;
          float _302 = frac(_301);
          float _303 = _302 * 6.283185005187988f;
          float _304 = sin(_303);
          float _305 = cos(_303);
          float _306 = p_m_fShadowSoftness * 0.008838835172355175f;
          float _307 = _306 * _305;
          float _308 = _306 * _304;
          float _309 = _307 + _276;
          float _310 = _308 + _277;
          float _311 = max(_309, 0.0f);
          float _312 = max(_310, 0.0f);
          float _313 = min(_311, 1.0f);
          float _314 = min(_312, 1.0f);
          [branch]
          if (!_297) {
            bool _316 = (_271 == 1);
            [branch]
            if (!_316) {
              bool _318 = (_271 == 2);
              [branch]
              if (!_318) {
                bool _320 = (_271 == 3);
                [branch]
                if (!_320) {
                  bool _322 = (_271 == 4);
                  [branch]
                  if (!_322) {
                    float4 _324 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_313, _314));
                    _342 = _324.x;
                  } else {
                    float4 _327 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_313, _314));
                    _342 = _327.x;
                  }
                } else {
                  float4 _330 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_313, _314));
                  _342 = _330.x;
                }
              } else {
                float4 _333 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_313, _314));
                _342 = _333.x;
              }
            } else {
              float4 _336 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_313, _314));
              _342 = _336.x;
            }
          } else {
            float4 _339 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_313, _314));
            _342 = _339.x;
          }
          float _343 = 1.0f - _342;
          float _344 = _343 * 2.0f;
          float _345 = _344 + -1.0f;
          float _346 = _345 * _240;
          float _347 = _239 - _346;
          float _348 = _238 / _347;
          float _349 = _348 - p_m_fShadowNearPlane;
          float _350 = _349 / _240;
          float _351 = saturate(_350);
          bool _352 = (_351 < _246);
          [branch]
          if (_352) {
            _355 = _351;
            _356 = 1.0f;
          } else {
            _355 = 0.0f;
            _356 = 0.0f;
          }
          float _357 = _303 + 2.4000000953674316f;
          float _358 = sin(_357);
          float _359 = cos(_357);
          float _360 = p_m_fShadowSoftness * 0.01530931144952774f;
          float _361 = _360 * _359;
          float _362 = _360 * _358;
          float _363 = _361 + _276;
          float _364 = _362 + _277;
          float _365 = max(_363, 0.0f);
          float _366 = max(_364, 0.0f);
          float _367 = min(_365, 1.0f);
          float _368 = min(_366, 1.0f);
          [branch]
          if (!_297) {
            bool _370 = (_271 == 1);
            [branch]
            if (!_370) {
              bool _372 = (_271 == 2);
              [branch]
              if (!_372) {
                bool _374 = (_271 == 3);
                [branch]
                if (!_374) {
                  bool _376 = (_271 == 4);
                  [branch]
                  if (!_376) {
                    float4 _378 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_367, _368));
                    _396 = _378.x;
                  } else {
                    float4 _381 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_367, _368));
                    _396 = _381.x;
                  }
                } else {
                  float4 _384 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_367, _368));
                  _396 = _384.x;
                }
              } else {
                float4 _387 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_367, _368));
                _396 = _387.x;
              }
            } else {
              float4 _390 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_367, _368));
              _396 = _390.x;
            }
          } else {
            float4 _393 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_367, _368));
            _396 = _393.x;
          }
          float _397 = 1.0f - _396;
          float _398 = _397 * 2.0f;
          float _399 = _398 + -1.0f;
          float _400 = _399 * _240;
          float _401 = _239 - _400;
          float _402 = _238 / _401;
          float _403 = _402 - p_m_fShadowNearPlane;
          float _404 = _403 / _240;
          float _405 = saturate(_404);
          bool _406 = (_405 < _246);
          [branch]
          if (_406) {
            float _408 = _405 + _355;
            float _409 = _356 + 1.0f;
            _411 = _408;
            _412 = _409;
          } else {
            _411 = _355;
            _412 = _356;
          }
          float _413 = _303 + 4.800000190734863f;
          float _414 = sin(_413);
          float _415 = cos(_413);
          float _416 = p_m_fShadowSoftness * 0.019764235243201256f;
          float _417 = _416 * _415;
          float _418 = _416 * _414;
          float _419 = _417 + _276;
          float _420 = _418 + _277;
          float _421 = max(_419, 0.0f);
          float _422 = max(_420, 0.0f);
          float _423 = min(_421, 1.0f);
          float _424 = min(_422, 1.0f);
          [branch]
          if (!_297) {
            bool _426 = (_271 == 1);
            [branch]
            if (!_426) {
              bool _428 = (_271 == 2);
              [branch]
              if (!_428) {
                bool _430 = (_271 == 3);
                [branch]
                if (!_430) {
                  bool _432 = (_271 == 4);
                  [branch]
                  if (!_432) {
                    float4 _434 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_423, _424));
                    _452 = _434.x;
                  } else {
                    float4 _437 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_423, _424));
                    _452 = _437.x;
                  }
                } else {
                  float4 _440 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_423, _424));
                  _452 = _440.x;
                }
              } else {
                float4 _443 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_423, _424));
                _452 = _443.x;
              }
            } else {
              float4 _446 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_423, _424));
              _452 = _446.x;
            }
          } else {
            float4 _449 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_423, _424));
            _452 = _449.x;
          }
          float _453 = 1.0f - _452;
          float _454 = _453 * 2.0f;
          float _455 = _454 + -1.0f;
          float _456 = _455 * _240;
          float _457 = _239 - _456;
          float _458 = _238 / _457;
          float _459 = _458 - p_m_fShadowNearPlane;
          float _460 = _459 / _240;
          float _461 = saturate(_460);
          bool _462 = (_461 < _246);
          [branch]
          if (_462) {
            float _464 = _461 + _411;
            float _465 = _412 + 1.0f;
            _467 = _464;
            _468 = _465;
          } else {
            _467 = _411;
            _468 = _412;
          }
          float _469 = _303 + 7.200000286102295f;
          float _470 = sin(_469);
          float _471 = cos(_469);
          float _472 = p_m_fShadowSoftness * 0.023385358974337578f;
          float _473 = _472 * _471;
          float _474 = _472 * _470;
          float _475 = _473 + _276;
          float _476 = _474 + _277;
          float _477 = max(_475, 0.0f);
          float _478 = max(_476, 0.0f);
          float _479 = min(_477, 1.0f);
          float _480 = min(_478, 1.0f);
          [branch]
          if (!_297) {
            bool _482 = (_271 == 1);
            [branch]
            if (!_482) {
              bool _484 = (_271 == 2);
              [branch]
              if (!_484) {
                bool _486 = (_271 == 3);
                [branch]
                if (!_486) {
                  bool _488 = (_271 == 4);
                  [branch]
                  if (!_488) {
                    float4 _490 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_479, _480));
                    _508 = _490.x;
                  } else {
                    float4 _493 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_479, _480));
                    _508 = _493.x;
                  }
                } else {
                  float4 _496 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_479, _480));
                  _508 = _496.x;
                }
              } else {
                float4 _499 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_479, _480));
                _508 = _499.x;
              }
            } else {
              float4 _502 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_479, _480));
              _508 = _502.x;
            }
          } else {
            float4 _505 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_479, _480));
            _508 = _505.x;
          }
          float _509 = 1.0f - _508;
          float _510 = _509 * 2.0f;
          float _511 = _510 + -1.0f;
          float _512 = _511 * _240;
          float _513 = _239 - _512;
          float _514 = _238 / _513;
          float _515 = _514 - p_m_fShadowNearPlane;
          float _516 = _515 / _240;
          float _517 = saturate(_516);
          bool _518 = (_517 < _246);
          [branch]
          if (_518) {
            float _520 = _517 + _467;
            float _521 = _468 + 1.0f;
            _523 = _520;
            _524 = _521;
          } else {
            _523 = _467;
            _524 = _468;
          }
          bool _525 = (_524 > 0.0f);
          [branch]
          if (_525) {
            float _527 = _523 / _524;
            float _528 = _246 - _527;
            float _529 = _528 / _527;
            float _530 = _529 * _529;
            float _531 = saturate(_530);
            float _532 = p_m_fShadowSoftness * 0.02500000037252903f;
            float _533 = _532 * _531;
            float _535 = _18[_271];
            float _536 = _535 * 2.0f;
            float _537 = _533 + _536;
            float _538 = _305 * 0.25f;
            float _539 = _304 * 0.25f;
            float _540 = _538 * _537;
            float _541 = _539 * _537;
            float _542 = _540 + _276;
            float _543 = _541 + _277;
            float _544 = max(_542, 0.0f);
            float _545 = max(_543, 0.0f);
            float _546 = min(_544, 1.0f);
            float _547 = min(_545, 1.0f);
            [branch]
            if (!_297) {
              bool _549 = (_271 == 1);
              [branch]
              if (!_549) {
                bool _551 = (_271 == 2);
                [branch]
                if (!_551) {
                  bool _553 = (_271 == 3);
                  [branch]
                  if (!_553) {
                    bool _555 = (_271 == 4);
                    [branch]
                    if (!_555) {
                      bool _557 = (_271 == 5);
                      [branch]
                      if (_557) {
                        float4 _559 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_546, _547), _233);
                        _577 = _559.x;
                      } else {
                        _577 = 0.0f;
                      }
                    } else {
                      float4 _562 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_546, _547), _233);
                      _577 = _562.x;
                    }
                  } else {
                    float4 _565 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_546, _547), _233);
                    _577 = _565.x;
                  }
                } else {
                  float4 _568 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_546, _547), _233);
                  _577 = _568.x;
                }
              } else {
                float4 _571 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_546, _547), _233);
                _577 = _571.x;
              }
            } else {
              float4 _574 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_546, _547), _233);
              _577 = _574.x;
            }
            float _578 = _537 * 0.4330127239227295f;
            float _579 = _578 * _359;
            float _580 = _578 * _358;
            float _581 = _579 + _276;
            float _582 = _580 + _277;
            float _583 = max(_581, 0.0f);
            float _584 = max(_582, 0.0f);
            float _585 = min(_583, 1.0f);
            float _586 = min(_584, 1.0f);
            [branch]
            if (!_297) {
              bool _588 = (_271 == 1);
              [branch]
              if (!_588) {
                bool _590 = (_271 == 2);
                [branch]
                if (!_590) {
                  bool _592 = (_271 == 3);
                  [branch]
                  if (!_592) {
                    bool _594 = (_271 == 4);
                    [branch]
                    if (!_594) {
                      bool _596 = (_271 == 5);
                      [branch]
                      if (_596) {
                        float4 _598 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_585, _586), _233);
                        _616 = _598.x;
                      } else {
                        _616 = 0.0f;
                      }
                    } else {
                      float4 _601 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_585, _586), _233);
                      _616 = _601.x;
                    }
                  } else {
                    float4 _604 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_585, _586), _233);
                    _616 = _604.x;
                  }
                } else {
                  float4 _607 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_585, _586), _233);
                  _616 = _607.x;
                }
              } else {
                float4 _610 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_585, _586), _233);
                _616 = _610.x;
              }
            } else {
              float4 _613 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_585, _586), _233);
              _616 = _613.x;
            }
            float _617 = _616 + _577;
            float _618 = _537 * 0.55901700258255f;
            float _619 = _618 * _415;
            float _620 = _618 * _414;
            float _621 = _619 + _276;
            float _622 = _620 + _277;
            float _623 = max(_621, 0.0f);
            float _624 = max(_622, 0.0f);
            float _625 = min(_623, 1.0f);
            float _626 = min(_624, 1.0f);
            [branch]
            if (!_297) {
              bool _628 = (_271 == 1);
              [branch]
              if (!_628) {
                bool _630 = (_271 == 2);
                [branch]
                if (!_630) {
                  bool _632 = (_271 == 3);
                  [branch]
                  if (!_632) {
                    bool _634 = (_271 == 4);
                    [branch]
                    if (!_634) {
                      bool _636 = (_271 == 5);
                      [branch]
                      if (_636) {
                        float4 _638 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_625, _626), _233);
                        _656 = _638.x;
                      } else {
                        _656 = 0.0f;
                      }
                    } else {
                      float4 _641 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_625, _626), _233);
                      _656 = _641.x;
                    }
                  } else {
                    float4 _644 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_625, _626), _233);
                    _656 = _644.x;
                  }
                } else {
                  float4 _647 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_625, _626), _233);
                  _656 = _647.x;
                }
              } else {
                float4 _650 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_625, _626), _233);
                _656 = _650.x;
              }
            } else {
              float4 _653 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_625, _626), _233);
              _656 = _653.x;
            }
            float _657 = _617 + _656;
            float _658 = _537 * 0.6614378690719604f;
            float _659 = _658 * _471;
            float _660 = _658 * _470;
            float _661 = _659 + _276;
            float _662 = _660 + _277;
            float _663 = max(_661, 0.0f);
            float _664 = max(_662, 0.0f);
            float _665 = min(_663, 1.0f);
            float _666 = min(_664, 1.0f);
            [branch]
            if (!_297) {
              bool _668 = (_271 == 1);
              [branch]
              if (!_668) {
                bool _670 = (_271 == 2);
                [branch]
                if (!_670) {
                  bool _672 = (_271 == 3);
                  [branch]
                  if (!_672) {
                    bool _674 = (_271 == 4);
                    [branch]
                    if (!_674) {
                      bool _676 = (_271 == 5);
                      [branch]
                      if (_676) {
                        float4 _678 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_665, _666), _233);
                        _696 = _678.x;
                      } else {
                        _696 = 0.0f;
                      }
                    } else {
                      float4 _681 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_665, _666), _233);
                      _696 = _681.x;
                    }
                  } else {
                    float4 _684 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_665, _666), _233);
                    _696 = _684.x;
                  }
                } else {
                  float4 _687 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_665, _666), _233);
                  _696 = _687.x;
                }
              } else {
                float4 _690 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_665, _666), _233);
                _696 = _690.x;
              }
            } else {
              float4 _693 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_665, _666), _233);
              _696 = _693.x;
            }
            float _697 = _657 + _696;
            float _698 = _303 + 9.600000381469727f;
            float _699 = sin(_698);
            float _700 = cos(_698);
            float _701 = _537 * 0.75f;
            float _702 = _701 * _700;
            float _703 = _701 * _699;
            float _704 = _702 + _276;
            float _705 = _703 + _277;
            float _706 = max(_704, 0.0f);
            float _707 = max(_705, 0.0f);
            float _708 = min(_706, 1.0f);
            float _709 = min(_707, 1.0f);
            [branch]
            if (!_297) {
              bool _711 = (_271 == 1);
              [branch]
              if (!_711) {
                bool _713 = (_271 == 2);
                [branch]
                if (!_713) {
                  bool _715 = (_271 == 3);
                  [branch]
                  if (!_715) {
                    bool _717 = (_271 == 4);
                    [branch]
                    if (!_717) {
                      bool _719 = (_271 == 5);
                      [branch]
                      if (_719) {
                        float4 _721 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_708, _709), _233);
                        _739 = _721.x;
                      } else {
                        _739 = 0.0f;
                      }
                    } else {
                      float4 _724 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_708, _709), _233);
                      _739 = _724.x;
                    }
                  } else {
                    float4 _727 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_708, _709), _233);
                    _739 = _727.x;
                  }
                } else {
                  float4 _730 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_708, _709), _233);
                  _739 = _730.x;
                }
              } else {
                float4 _733 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_708, _709), _233);
                _739 = _733.x;
              }
            } else {
              float4 _736 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_708, _709), _233);
              _739 = _736.x;
            }
            float _740 = _697 + _739;
            float _741 = _303 + 12.0f;
            float _742 = sin(_741);
            float _743 = cos(_741);
            float _744 = _537 * 0.829156219959259f;
            float _745 = _744 * _743;
            float _746 = _744 * _742;
            float _747 = _745 + _276;
            float _748 = _746 + _277;
            float _749 = max(_747, 0.0f);
            float _750 = max(_748, 0.0f);
            float _751 = min(_749, 1.0f);
            float _752 = min(_750, 1.0f);
            [branch]
            if (!_297) {
              bool _754 = (_271 == 1);
              [branch]
              if (!_754) {
                bool _756 = (_271 == 2);
                [branch]
                if (!_756) {
                  bool _758 = (_271 == 3);
                  [branch]
                  if (!_758) {
                    bool _760 = (_271 == 4);
                    [branch]
                    if (!_760) {
                      bool _762 = (_271 == 5);
                      [branch]
                      if (_762) {
                        float4 _764 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_751, _752), _233);
                        _782 = _764.x;
                      } else {
                        _782 = 0.0f;
                      }
                    } else {
                      float4 _767 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_751, _752), _233);
                      _782 = _767.x;
                    }
                  } else {
                    float4 _770 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_751, _752), _233);
                    _782 = _770.x;
                  }
                } else {
                  float4 _773 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_751, _752), _233);
                  _782 = _773.x;
                }
              } else {
                float4 _776 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_751, _752), _233);
                _782 = _776.x;
              }
            } else {
              float4 _779 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_751, _752), _233);
              _782 = _779.x;
            }
            float _783 = _740 + _782;
            float _784 = _303 + 14.40000057220459f;
            float _785 = sin(_784);
            float _786 = cos(_784);
            float _787 = _537 * 0.9013878107070923f;
            float _788 = _787 * _786;
            float _789 = _787 * _785;
            float _790 = _788 + _276;
            float _791 = _789 + _277;
            float _792 = max(_790, 0.0f);
            float _793 = max(_791, 0.0f);
            float _794 = min(_792, 1.0f);
            float _795 = min(_793, 1.0f);
            [branch]
            if (!_297) {
              bool _797 = (_271 == 1);
              [branch]
              if (!_797) {
                bool _799 = (_271 == 2);
                [branch]
                if (!_799) {
                  bool _801 = (_271 == 3);
                  [branch]
                  if (!_801) {
                    bool _803 = (_271 == 4);
                    [branch]
                    if (!_803) {
                      bool _805 = (_271 == 5);
                      [branch]
                      if (_805) {
                        float4 _807 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_794, _795), _233);
                        _825 = _807.x;
                      } else {
                        _825 = 0.0f;
                      }
                    } else {
                      float4 _810 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_794, _795), _233);
                      _825 = _810.x;
                    }
                  } else {
                    float4 _813 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_794, _795), _233);
                    _825 = _813.x;
                  }
                } else {
                  float4 _816 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_794, _795), _233);
                  _825 = _816.x;
                }
              } else {
                float4 _819 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_794, _795), _233);
                _825 = _819.x;
              }
            } else {
              float4 _822 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_794, _795), _233);
              _825 = _822.x;
            }
            float _826 = _783 + _825;
            float _827 = _303 + 16.80000114440918f;
            float _828 = sin(_827);
            float _829 = cos(_827);
            float _830 = _537 * 0.9682458639144897f;
            float _831 = _830 * _829;
            float _832 = _830 * _828;
            float _833 = _831 + _276;
            float _834 = _832 + _277;
            float _835 = max(_833, 0.0f);
            float _836 = max(_834, 0.0f);
            float _837 = min(_835, 1.0f);
            float _838 = min(_836, 1.0f);
            [branch]
            if (!_297) {
              bool _840 = (_271 == 1);
              [branch]
              if (!_840) {
                bool _842 = (_271 == 2);
                [branch]
                if (!_842) {
                  bool _844 = (_271 == 3);
                  [branch]
                  if (!_844) {
                    bool _846 = (_271 == 4);
                    [branch]
                    if (!_846) {
                      bool _848 = (_271 == 5);
                      [branch]
                      if (_848) {
                        float4 _850 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_837, _838), _233);
                        _868 = _850.x;
                      } else {
                        _868 = 0.0f;
                      }
                    } else {
                      float4 _853 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_837, _838), _233);
                      _868 = _853.x;
                    }
                  } else {
                    float4 _856 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_837, _838), _233);
                    _868 = _856.x;
                  }
                } else {
                  float4 _859 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_837, _838), _233);
                  _868 = _859.x;
                }
              } else {
                float4 _862 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_837, _838), _233);
                _868 = _862.x;
              }
            } else {
              float4 _865 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_837, _838), _233);
              _868 = _865.x;
            }
            float _869 = _826 + _868;
            float _870 = _869 * 0.125f;
            _1319 = _870;
          } else {
            _1319 = 0.0f;
          }
        } else {
          float _873 = _18[_271];
          float _874 = _873 * 0.32621198892593384f;
          float _875 = _873 * 0.40580499172210693f;
          float _876 = _276 - _874;
          float _877 = _277 - _875;
          float _878 = max(_876, 0.0f);
          float _879 = max(_877, 0.0f);
          float _880 = min(_878, 1.0f);
          float _881 = min(_879, 1.0f);
          [branch]
          if (!_297) {
            bool _883 = (_271 == 1);
            [branch]
            if (!_883) {
              bool _885 = (_271 == 2);
              [branch]
              if (!_885) {
                bool _887 = (_271 == 3);
                [branch]
                if (!_887) {
                  bool _889 = (_271 == 4);
                  [branch]
                  if (!_889) {
                    float4 _891 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_880, _881), _233);
                    _909 = _891.x;
                  } else {
                    float4 _894 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_880, _881), _233);
                    _909 = _894.x;
                  }
                } else {
                  float4 _897 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_880, _881), _233);
                  _909 = _897.x;
                }
              } else {
                float4 _900 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_880, _881), _233);
                _909 = _900.x;
              }
            } else {
              float4 _903 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_880, _881), _233);
              _909 = _903.x;
            }
          } else {
            float4 _906 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_880, _881), _233);
            _909 = _906.x;
          }
          float _910 = _873 * 0.8401439785957336f;
          float _911 = _873 * 0.07357999682426453f;
          float _912 = _276 - _910;
          float _913 = _277 - _911;
          float _914 = max(_912, 0.0f);
          float _915 = max(_913, 0.0f);
          float _916 = min(_914, 1.0f);
          float _917 = min(_915, 1.0f);
          [branch]
          if (!_297) {
            bool _919 = (_271 == 1);
            [branch]
            if (!_919) {
              bool _921 = (_271 == 2);
              [branch]
              if (!_921) {
                bool _923 = (_271 == 3);
                [branch]
                if (!_923) {
                  bool _925 = (_271 == 4);
                  [branch]
                  if (!_925) {
                    float4 _927 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_916, _917), _233);
                    _945 = _927.x;
                  } else {
                    float4 _930 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_916, _917), _233);
                    _945 = _930.x;
                  }
                } else {
                  float4 _933 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_916, _917), _233);
                  _945 = _933.x;
                }
              } else {
                float4 _936 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_916, _917), _233);
                _945 = _936.x;
              }
            } else {
              float4 _939 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_916, _917), _233);
              _945 = _939.x;
            }
          } else {
            float4 _942 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_916, _917), _233);
            _945 = _942.x;
          }
          float _946 = _945 + _909;
          float _947 = _873 * 0.6959139704704285f;
          float _948 = _873 * 0.45713698863983154f;
          float _949 = _276 - _947;
          float _950 = _948 + _277;
          float _951 = max(_949, 0.0f);
          float _952 = max(_950, 0.0f);
          float _953 = min(_951, 1.0f);
          float _954 = min(_952, 1.0f);
          [branch]
          if (!_297) {
            bool _956 = (_271 == 1);
            [branch]
            if (!_956) {
              bool _958 = (_271 == 2);
              [branch]
              if (!_958) {
                bool _960 = (_271 == 3);
                [branch]
                if (!_960) {
                  bool _962 = (_271 == 4);
                  [branch]
                  if (!_962) {
                    float4 _964 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_953, _954), _233);
                    _982 = _964.x;
                  } else {
                    float4 _967 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_953, _954), _233);
                    _982 = _967.x;
                  }
                } else {
                  float4 _970 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_953, _954), _233);
                  _982 = _970.x;
                }
              } else {
                float4 _973 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_953, _954), _233);
                _982 = _973.x;
              }
            } else {
              float4 _976 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_953, _954), _233);
              _982 = _976.x;
            }
          } else {
            float4 _979 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_953, _954), _233);
            _982 = _979.x;
          }
          float _983 = _946 + _982;
          float _984 = _873 * 0.20334500074386597f;
          float _985 = _873 * 0.6207159757614136f;
          float _986 = _276 - _984;
          float _987 = _985 + _277;
          float _988 = max(_986, 0.0f);
          float _989 = max(_987, 0.0f);
          float _990 = min(_988, 1.0f);
          float _991 = min(_989, 1.0f);
          [branch]
          if (!_297) {
            bool _993 = (_271 == 1);
            [branch]
            if (!_993) {
              bool _995 = (_271 == 2);
              [branch]
              if (!_995) {
                bool _997 = (_271 == 3);
                [branch]
                if (!_997) {
                  bool _999 = (_271 == 4);
                  [branch]
                  if (!_999) {
                    float4 _1001 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_990, _991), _233);
                    _1019 = _1001.x;
                  } else {
                    float4 _1004 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_990, _991), _233);
                    _1019 = _1004.x;
                  }
                } else {
                  float4 _1007 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_990, _991), _233);
                  _1019 = _1007.x;
                }
              } else {
                float4 _1010 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_990, _991), _233);
                _1019 = _1010.x;
              }
            } else {
              float4 _1013 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_990, _991), _233);
              _1019 = _1013.x;
            }
          } else {
            float4 _1016 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_990, _991), _233);
            _1019 = _1016.x;
          }
          float _1020 = _983 + _1019;
          float _1021 = _873 * 0.9623399972915649f;
          float _1022 = _873 * 0.19498300552368164f;
          float _1023 = _1021 + _276;
          float _1024 = _277 - _1022;
          float _1025 = max(_1023, 0.0f);
          float _1026 = max(_1024, 0.0f);
          float _1027 = min(_1025, 1.0f);
          float _1028 = min(_1026, 1.0f);
          [branch]
          if (!_297) {
            bool _1030 = (_271 == 1);
            [branch]
            if (!_1030) {
              bool _1032 = (_271 == 2);
              [branch]
              if (!_1032) {
                bool _1034 = (_271 == 3);
                [branch]
                if (!_1034) {
                  bool _1036 = (_271 == 4);
                  [branch]
                  if (!_1036) {
                    float4 _1038 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1027, _1028), _233);
                    _1056 = _1038.x;
                  } else {
                    float4 _1041 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1027, _1028), _233);
                    _1056 = _1041.x;
                  }
                } else {
                  float4 _1044 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1027, _1028), _233);
                  _1056 = _1044.x;
                }
              } else {
                float4 _1047 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1027, _1028), _233);
                _1056 = _1047.x;
              }
            } else {
              float4 _1050 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1027, _1028), _233);
              _1056 = _1050.x;
            }
          } else {
            float4 _1053 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1027, _1028), _233);
            _1056 = _1053.x;
          }
          float _1057 = _1020 + _1056;
          float _1058 = _873 * 0.4734340012073517f;
          float _1059 = _873 * 0.4800260066986084f;
          float _1060 = _1058 + _276;
          float _1061 = _277 - _1059;
          float _1062 = max(_1060, 0.0f);
          float _1063 = max(_1061, 0.0f);
          float _1064 = min(_1062, 1.0f);
          float _1065 = min(_1063, 1.0f);
          [branch]
          if (!_297) {
            bool _1067 = (_271 == 1);
            [branch]
            if (!_1067) {
              bool _1069 = (_271 == 2);
              [branch]
              if (!_1069) {
                bool _1071 = (_271 == 3);
                [branch]
                if (!_1071) {
                  bool _1073 = (_271 == 4);
                  [branch]
                  if (!_1073) {
                    float4 _1075 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1064, _1065), _233);
                    _1093 = _1075.x;
                  } else {
                    float4 _1078 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1064, _1065), _233);
                    _1093 = _1078.x;
                  }
                } else {
                  float4 _1081 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1064, _1065), _233);
                  _1093 = _1081.x;
                }
              } else {
                float4 _1084 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1064, _1065), _233);
                _1093 = _1084.x;
              }
            } else {
              float4 _1087 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1064, _1065), _233);
              _1093 = _1087.x;
            }
          } else {
            float4 _1090 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1064, _1065), _233);
            _1093 = _1090.x;
          }
          float _1094 = _1057 + _1093;
          float _1095 = _873 * 0.5194560289382935f;
          float _1096 = _873 * 0.7670220136642456f;
          float _1097 = _1095 + _276;
          float _1098 = _1096 + _277;
          float _1099 = max(_1097, 0.0f);
          float _1100 = max(_1098, 0.0f);
          float _1101 = min(_1099, 1.0f);
          float _1102 = min(_1100, 1.0f);
          [branch]
          if (!_297) {
            bool _1104 = (_271 == 1);
            [branch]
            if (!_1104) {
              bool _1106 = (_271 == 2);
              [branch]
              if (!_1106) {
                bool _1108 = (_271 == 3);
                [branch]
                if (!_1108) {
                  bool _1110 = (_271 == 4);
                  [branch]
                  if (!_1110) {
                    float4 _1112 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1101, _1102), _233);
                    _1130 = _1112.x;
                  } else {
                    float4 _1115 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1101, _1102), _233);
                    _1130 = _1115.x;
                  }
                } else {
                  float4 _1118 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1101, _1102), _233);
                  _1130 = _1118.x;
                }
              } else {
                float4 _1121 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1101, _1102), _233);
                _1130 = _1121.x;
              }
            } else {
              float4 _1124 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1101, _1102), _233);
              _1130 = _1124.x;
            }
          } else {
            float4 _1127 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1101, _1102), _233);
            _1130 = _1127.x;
          }
          float _1131 = _1094 + _1130;
          float _1132 = _873 * 0.18546099960803986f;
          float _1133 = _873 * 0.893123984336853f;
          float _1134 = _1132 + _276;
          float _1135 = _277 - _1133;
          float _1136 = max(_1134, 0.0f);
          float _1137 = max(_1135, 0.0f);
          float _1138 = min(_1136, 1.0f);
          float _1139 = min(_1137, 1.0f);
          [branch]
          if (!_297) {
            bool _1141 = (_271 == 1);
            [branch]
            if (!_1141) {
              bool _1143 = (_271 == 2);
              [branch]
              if (!_1143) {
                bool _1145 = (_271 == 3);
                [branch]
                if (!_1145) {
                  bool _1147 = (_271 == 4);
                  [branch]
                  if (!_1147) {
                    float4 _1149 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1138, _1139), _233);
                    _1167 = _1149.x;
                  } else {
                    float4 _1152 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1138, _1139), _233);
                    _1167 = _1152.x;
                  }
                } else {
                  float4 _1155 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1138, _1139), _233);
                  _1167 = _1155.x;
                }
              } else {
                float4 _1158 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1138, _1139), _233);
                _1167 = _1158.x;
              }
            } else {
              float4 _1161 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1138, _1139), _233);
              _1167 = _1161.x;
            }
          } else {
            float4 _1164 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1138, _1139), _233);
            _1167 = _1164.x;
          }
          float _1168 = _1131 + _1167;
          float _1169 = _873 * 0.5074309706687927f;
          float _1170 = _873 * 0.06442499905824661f;
          float _1171 = _1169 + _276;
          float _1172 = _1170 + _277;
          float _1173 = max(_1171, 0.0f);
          float _1174 = max(_1172, 0.0f);
          float _1175 = min(_1173, 1.0f);
          float _1176 = min(_1174, 1.0f);
          [branch]
          if (!_297) {
            bool _1178 = (_271 == 1);
            [branch]
            if (!_1178) {
              bool _1180 = (_271 == 2);
              [branch]
              if (!_1180) {
                bool _1182 = (_271 == 3);
                [branch]
                if (!_1182) {
                  bool _1184 = (_271 == 4);
                  [branch]
                  if (!_1184) {
                    float4 _1186 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1175, _1176), _233);
                    _1204 = _1186.x;
                  } else {
                    float4 _1189 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1175, _1176), _233);
                    _1204 = _1189.x;
                  }
                } else {
                  float4 _1192 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1175, _1176), _233);
                  _1204 = _1192.x;
                }
              } else {
                float4 _1195 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1175, _1176), _233);
                _1204 = _1195.x;
              }
            } else {
              float4 _1198 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1175, _1176), _233);
              _1204 = _1198.x;
            }
          } else {
            float4 _1201 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1175, _1176), _233);
            _1204 = _1201.x;
          }
          float _1205 = _1168 + _1204;
          float _1206 = _873 * 0.8964200019836426f;
          float _1207 = _873 * 0.41245800256729126f;
          float _1208 = _1206 + _276;
          float _1209 = _1207 + _277;
          float _1210 = max(_1208, 0.0f);
          float _1211 = max(_1209, 0.0f);
          float _1212 = min(_1210, 1.0f);
          float _1213 = min(_1211, 1.0f);
          [branch]
          if (!_297) {
            bool _1215 = (_271 == 1);
            [branch]
            if (!_1215) {
              bool _1217 = (_271 == 2);
              [branch]
              if (!_1217) {
                bool _1219 = (_271 == 3);
                [branch]
                if (!_1219) {
                  bool _1221 = (_271 == 4);
                  [branch]
                  if (!_1221) {
                    float4 _1223 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1212, _1213), _233);
                    _1241 = _1223.x;
                  } else {
                    float4 _1226 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1212, _1213), _233);
                    _1241 = _1226.x;
                  }
                } else {
                  float4 _1229 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1212, _1213), _233);
                  _1241 = _1229.x;
                }
              } else {
                float4 _1232 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1212, _1213), _233);
                _1241 = _1232.x;
              }
            } else {
              float4 _1235 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1212, _1213), _233);
              _1241 = _1235.x;
            }
          } else {
            float4 _1238 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1212, _1213), _233);
            _1241 = _1238.x;
          }
          float _1242 = _1205 + _1241;
          float _1243 = _873 * 0.32194000482559204f;
          float _1244 = _873 * 0.9326149821281433f;
          float _1245 = _276 - _1243;
          float _1246 = _277 - _1244;
          float _1247 = max(_1245, 0.0f);
          float _1248 = max(_1246, 0.0f);
          float _1249 = min(_1247, 1.0f);
          float _1250 = min(_1248, 1.0f);
          [branch]
          if (!_297) {
            bool _1252 = (_271 == 1);
            [branch]
            if (!_1252) {
              bool _1254 = (_271 == 2);
              [branch]
              if (!_1254) {
                bool _1256 = (_271 == 3);
                [branch]
                if (!_1256) {
                  bool _1258 = (_271 == 4);
                  [branch]
                  if (!_1258) {
                    float4 _1260 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1249, _1250), _233);
                    _1278 = _1260.x;
                  } else {
                    float4 _1263 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1249, _1250), _233);
                    _1278 = _1263.x;
                  }
                } else {
                  float4 _1266 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1249, _1250), _233);
                  _1278 = _1266.x;
                }
              } else {
                float4 _1269 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1249, _1250), _233);
                _1278 = _1269.x;
              }
            } else {
              float4 _1272 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1249, _1250), _233);
              _1278 = _1272.x;
            }
          } else {
            float4 _1275 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1249, _1250), _233);
            _1278 = _1275.x;
          }
          float _1279 = _1242 + _1278;
          float _1280 = _873 * 0.7915589809417725f;
          float _1281 = _873 * 0.5977050065994263f;
          float _1282 = _276 - _1280;
          float _1283 = _277 - _1281;
          float _1284 = max(_1282, 0.0f);
          float _1285 = max(_1283, 0.0f);
          float _1286 = min(_1284, 1.0f);
          float _1287 = min(_1285, 1.0f);
          [branch]
          if (!_297) {
            bool _1289 = (_271 == 1);
            [branch]
            if (!_1289) {
              bool _1291 = (_271 == 2);
              [branch]
              if (!_1291) {
                bool _1293 = (_271 == 3);
                [branch]
                if (!_1293) {
                  bool _1295 = (_271 == 4);
                  [branch]
                  if (!_1295) {
                    float4 _1297 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1286, _1287), _233);
                    _1315 = _1297.x;
                  } else {
                    float4 _1300 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1286, _1287), _233);
                    _1315 = _1300.x;
                  }
                } else {
                  float4 _1303 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1286, _1287), _233);
                  _1315 = _1303.x;
                }
              } else {
                float4 _1306 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1286, _1287), _233);
                _1315 = _1306.x;
              }
            } else {
              float4 _1309 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1286, _1287), _233);
              _1315 = _1309.x;
            }
          } else {
            float4 _1312 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1286, _1287), _233);
            _1315 = _1312.x;
          }
          float _1316 = _1279 + _1315;
          float _1317 = _1316 * 0.0833333358168602f;
          _1319 = _1317;
        }
      } else {
        _1319 = 0.0f;
      }
      float _1320 = _1319 * p_m_fShadowStrength;
      float _1321 = 1.0f - _1320;
      _1323 = _1321;
    } else {
      _1323 = 1.0f;
    }
    bool _1324 = (_1323 > 0.0f);
    [branch]
    if (_1324) {
      float _1326 = _213 * p_m_xLightColour.x;
      float _1327 = _213 * p_m_xLightColour.y;
      float _1328 = _213 * p_m_xLightColour.z;
      float _1329 = g_xCamPos.x - _66;
      float _1330 = g_xCamPos.y - _70;
      float _1331 = g_xCamPos.z - _74;
      float _1332 = dot(float3(_1329, _1330, _1331), float3(_1329, _1330, _1331));
      float _1333 = rsqrt(_1332);
      float _1334 = _1333 * _1329;
      float _1335 = _1333 * _1330;
      float _1336 = _1333 * _1331;
      bool _1337 = (p_m_fAreaLightRadius > 0.0f);
      [branch]
      if (_1337) {
        float _1339 = dot(float3(_1334, _1335, _1336), float3(_98, _99, _100));
        float _1340 = _1339 * 2.0f;
        float _1341 = _1340 * _98;
        float _1342 = _1340 * _99;
        float _1343 = _1340 * _100;
        float _1344 = _1334 - _1341;
        float _1345 = _1335 - _1342;
        float _1346 = _1336 - _1343;
        float _1347 = -0.0f - _1344;
        float _1348 = -0.0f - _1345;
        float _1349 = -0.0f - _1346;
        float _1350 = dot(float3(_178, _179, _180), float3(_1347, _1348, _1349));
        float _1351 = _1350 * _1347;
        float _1352 = _1350 * _1348;
        float _1353 = _1350 * _1349;
        float _1354 = _1351 - _178;
        float _1355 = _1352 - _179;
        float _1356 = _1353 - _180;
        float _1357 = _1354 * _1354;
        float _1358 = _1355 * _1355;
        float _1359 = _1357 + _1358;
        float _1360 = _1356 * _1356;
        float _1361 = _1359 + _1360;
        float _1362 = sqrt(_1361);
        float _1363 = p_m_fAreaLightRadius / _1362;
        float _1364 = saturate(_1363);
        float _1365 = _1354 * _1364;
        float _1366 = _1355 * _1364;
        float _1367 = _1356 * _1364;
        float _1368 = _1365 + _178;
        float _1369 = _1366 + _179;
        float _1370 = _1367 + _180;
        float _1371 = dot(float3(_1368, _1369, _1370), float3(_1368, _1369, _1370));
        float _1372 = rsqrt(_1371);
        float _1373 = _1368 * _1372;
        float _1374 = _1369 * _1372;
        float _1375 = _1370 * _1372;
        float _1376 = dot(float3(_178, _179, _180), float3(_178, _179, _180));
        float _1377 = rsqrt(_1376);
        float _1378 = _1377 * p_m_fAreaLightRadius;
        _1380 = _1373;
        _1381 = _1374;
        _1382 = _1375;
        _1383 = _1378;
      } else {
        _1380 = _187;
        _1381 = _188;
        _1382 = _189;
        _1383 = 0.0f;
      }
      // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
      bool _1384 = (!MaterialIdEquals(_80.w, 0.019607843831181526f));
      float _1385 = select(_1384, _85.x, 0.0f);
      float _1386 = _1380 + _1334;
      float _1387 = _1381 + _1335;
      float _1388 = _1382 + _1336;
      float _1389 = dot(float3(_1386, _1387, _1388), float3(_1386, _1387, _1388));
      float _1390 = rsqrt(_1389);
      float _1391 = _1390 * _1386;
      float _1392 = _1390 * _1387;
      float _1393 = _1390 * _1388;
      float _1394 = dot(float3(_98, _99, _100), float3(_1334, _1335, _1336));
      float _1395 = saturate(_1394);
      float _1396 = dot(float3(_98, _99, _100), float3(_1391, _1392, _1393));
      float _1397 = saturate(_1396);
      float _1398 = dot(float3(_1334, _1335, _1336), float3(_1391, _1392, _1393));
      float _1399 = saturate(_1398);
      bool _1400 = (MaterialIdEquals(_80.w, 0.01568627543747425f));
      [branch]
      if (!_1400) {
        bool _1402 = (MaterialIdEquals(_80.w, 0.007843137718737125f));
        [branch]
        if (!_1402) {
          bool _1404 = (MaterialIdEquals(_80.w, 0.003921568859368563f));
          [branch]
          if (_1404) {
            float _1406 = -0.0f - _98;
            float _1407 = -0.0f - _99;
            float _1408 = -0.0f - _100;
            float _1409 = dot(float3(_187, _188, _189), float3(_1406, _1407, _1408));
            float _1410 = saturate(_1409);
            float _1411 = _1410 * 0.4000000059604645f;
            float _1412 = -0.0f - _1334;
            float _1413 = -0.0f - _1335;
            float _1414 = -0.0f - _1336;
            float _1415 = dot(float3(_187, _188, _189), float3(_1412, _1413, _1414));
            float _1416 = saturate(_1415);
            float _1417 = log2(_1416);
            float _1418 = _1417 * 7.0f;
            float _1419 = exp2(_1418);
            float _1420 = _1419 + _1411;
            float _1421 = saturate(_1420);
            float _1422 = _1421 * _1385;
            float _1423 = _1422 + _217;
            _1441 = _80.x;
            _1442 = _80.y;
            _1443 = _80.z;
            _1444 = 0.02800000086426735f;
            _1445 = 0.02800000086426735f;
            _1446 = 0.02800000086426735f;
            _1447 = _1423;
          } else {
            float _1425 = _80.x + -0.03999999910593033f;
            float _1426 = _80.y + -0.03999999910593033f;
            float _1427 = _80.z + -0.03999999910593033f;
            float _1428 = _1385 * _1425;
            float _1429 = _1385 * _1426;
            float _1430 = _1385 * _1427;
            float _1431 = _1428 + 0.03999999910593033f;
            float _1432 = _1429 + 0.03999999910593033f;
            float _1433 = _1430 + 0.03999999910593033f;
            float _1434 = _1385 * _80.x;
            float _1435 = _1385 * _80.y;
            float _1436 = _1385 * _80.z;
            float _1437 = _80.x - _1434;
            float _1438 = _80.y - _1435;
            float _1439 = _80.z - _1436;
            _1441 = _1437;
            _1442 = _1438;
            _1443 = _1439;
            _1444 = _1431;
            _1445 = _1432;
            _1446 = _1433;
            _1447 = _217;
          }
        } else {
          _1441 = _80.x;
          _1442 = _80.y;
          _1443 = _80.z;
          _1444 = 0.02800000086426735f;
          _1445 = 0.02800000086426735f;
          _1446 = 0.02800000086426735f;
          _1447 = _217;
        }
      } else {
        _1441 = _80.x;
        _1442 = _80.y;
        _1443 = _80.z;
        _1444 = 0.04699999839067459f;
        _1445 = 0.04699999839067459f;
        _1446 = 0.04699999839067459f;
        _1447 = _217;
      }
      float _1448 = _1447 * _1441;
      float _1449 = _1447 * _1442;
      float _1450 = _1447 * _1443;
      float _1451 = max(_85.y, 0.05000000074505806f);
      float _1452 = _1451 * _1451;
      [branch]
      if (_1400) {
        float _1454 = 1.0f - _85.y;
        float _1455 = saturate(_1454);
        float _1456 = dot(float3(_80.x, _80.y, _80.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
        float _1457 = _85.x * 0.6000000238418579f;
        float _1458 = _1457 + -0.3500000238418579f;
        float _1459 = _1457 + -0.25f;
        float _1460 = _1455 * 0.05000000074505806f;
        float _1461 = _1459 - _1460;
        float _1462 = log2(_1455);
        float _1463 = _1462 * 8.0f;
        float _1464 = exp2(_1463);
        float _1465 = _1464 * 500.0f;
        float _1466 = _1465 + 20.0f;
        float _1467 = _1462 * 6.0f;
        float _1468 = exp2(_1467);
        float _1469 = _1468 * 2000.0f;
        float _1470 = _1469 + 50.0f;
        float _1471 = _85.x * 0.13500000536441803f;
        float _1472 = _1471 + 0.015000000596046448f;
        float _1473 = _1455 + 0.10000000149011612f;
        float _1474 = _85.x * 0.007499999832361937f;
        float _1475 = _1474 + 0.007499999832361937f;
        float _1476 = _98 * _1458;
        float _1477 = _99 * _1458;
        float _1478 = _100 * _1458;
        float _1479 = _1476 + _103;
        float _1480 = _1477 + _104;
        float _1481 = _111 + _1478;
        float _1482 = dot(float3(_1479, _1480, _1481), float3(_1479, _1480, _1481));
        float _1483 = rsqrt(_1482);
        float _1484 = _1483 * _1479;
        float _1485 = _1483 * _1480;
        float _1486 = _1483 * _1481;
        float _1487 = dot(float3(_1484, _1485, _1486), float3(_1391, _1392, _1393));
        float _1488 = _1487 * _1487;
        float _1489 = 1.0f - _1488;
        float _1490 = saturate(_1489);
        float _1491 = sqrt(_1490);
        float _1492 = _1487 + 1.0f;
        float _1493 = saturate(_1492);
        float _1494 = _1493 * 2.0f;
        float _1495 = 3.0f - _1494;
        float _1496 = log2(_1491);
        float _1497 = _1496 * _1466;
        float _1498 = exp2(_1497);
        float _1499 = _1464 * 19.89436912536621f;
        float _1500 = _1499 + 1.1140847206115723f;
        float _1501 = _1473 * _1472;
        float _1502 = _1501 * _1500;
        float _1503 = _1493 * _1493;
        float _1504 = _1503 * _1502;
        float _1505 = _1504 * _1495;
        float _1506 = _1505 * _1498;
        float _1507 = max(_1456, 0.0010000000474974513f);
        float _1508 = _80.x / _1507;
        float _1509 = _80.y / _1507;
        float _1510 = _80.z / _1507;
        float _1511 = _1506 * _1508;
        float _1512 = _1506 * _1509;
        float _1513 = _1506 * _1510;
        float _1514 = _1461 * _98;
        float _1515 = _1461 * _99;
        float _1516 = _1461 * _100;
        float _1517 = _1514 + _103;
        float _1518 = _1515 + _104;
        float _1519 = _1516 + _111;
        float _1520 = dot(float3(_1517, _1518, _1519), float3(_1517, _1518, _1519));
        float _1521 = rsqrt(_1520);
        float _1522 = _1521 * _1517;
        float _1523 = _1521 * _1518;
        float _1524 = _1521 * _1519;
        float _1525 = dot(float3(_1522, _1523, _1524), float3(_1391, _1392, _1393));
        float _1526 = _1525 * _1525;
        float _1527 = 1.0f - _1526;
        float _1528 = saturate(_1527);
        float _1529 = sqrt(_1528);
        float _1530 = _1525 + 1.0f;
        float _1531 = saturate(_1530);
        float _1532 = _1531 * 2.0f;
        float _1533 = 3.0f - _1532;
        float _1534 = log2(_1529);
        float _1535 = _1534 * _1470;
        float _1536 = exp2(_1535);
        float _1537 = _1468 * 79.57747650146484f;
        float _1538 = _1537 + 2.3077468872070312f;
        float _1539 = _1455 * _1475;
        float _1540 = _1539 * _1538;
        float _1541 = _1531 * _1531;
        float _1542 = _1541 * _1540;
        float _1543 = _1542 * _1533;
        float _1544 = _1543 * _1536;
        float _1545 = _1544 + _1511;
        float _1546 = _1544 + _1512;
        float _1547 = _1544 + _1513;
        float _1548 = _217 * p_m_fSpecularStrength;
        float _1549 = _1548 * _1545;
        float _1550 = _1548 * _1546;
        float _1551 = _1548 * _1547;
        _1606 = _1549;
        _1607 = _1550;
        _1608 = _1551;
      } else {
        float _1553 = 1.0f - _1452;
        float _1554 = _1553 * _1383;
        float _1555 = saturate(_1554);
        float _1556 = 1.0f - _1444;
        float _1557 = 1.0f - _1445;
        float _1558 = 1.0f - _1446;
        float _1559 = _1399 * 5.55472993850708f;
        float _1560 = -6.983160018920898f - _1559;
        float _1561 = _1560 * _1399;
        float _1562 = exp2(_1561);
        float _1563 = _1562 * _1556;
        float _1564 = _1562 * _1557;
        float _1565 = _1562 * _1558;
        float _1566 = _1563 + _1444;
        float _1567 = _1564 + _1445;
        float _1568 = _1565 + _1446;
        bool _1569 = (_1555 > 0.0f);
        float _1570 = _1452 * _1452;
        [branch]
        if (_1569) {
          float _1572 = _1555 * 0.25f;
          float _1573 = _1452 * 3.0f;
          float _1574 = _1555 + _1573;
          float _1575 = _1572 * _1574;
          float _1576 = _1399 + 0.0010000000474974513f;
          float _1577 = _1575 / _1576;
          float _1578 = _1577 + _1570;
          float _1579 = _1570 / _1578;
          _1581 = _1579;
        } else {
          _1581 = 1.0f;
        }
        float _1582 = 2.0f - _1452;
        float _1583 = _1582 * _1395;
        float _1584 = _1583 + _1452;
        float _1585 = _1582 * _217;
        float _1586 = _1585 + _1452;
        float _1587 = _1584 * _1586;
        float _1588 = 1.0f / _1587;
        float _1589 = _1570 * _1397;
        float _1590 = _1589 - _1397;
        float _1591 = _1590 * _1397;
        float _1592 = _1591 + 1.0f;
        float _1593 = _1592 * _1592;
        float _1594 = 1.0f / _1593;
        float _1595 = _217 * p_m_fSpecularStrength;
        float _1596 = _1595 * _1570;
        float _1597 = _1596 * _1588;
        float _1598 = _1597 * _1594;
        float _1599 = _1581 * _1566;
        float _1600 = _1599 * _1598;
        float _1601 = _1581 * _1567;
        float _1602 = _1601 * _1598;
        float _1603 = _1581 * _1568;
        float _1604 = _1603 * _1598;
        _1606 = _1600;
        _1607 = _1602;
        _1608 = _1604;
      }
      float _1609 = _1606 + _1448;
      float _1610 = _1607 + _1449;
      float _1611 = _1608 + _1450;
      bool _1612 = (MaterialIdEquals(_80.w, 0.019607843831181526f));
      [branch]
      if (_1612) {
        bool _1614 = (_85.x > 0.49803921580314636f);
        float _1615 = _85.x + -0.501960813999176f;
        float _1616 = select(_1614, _1615, _85.x);
        float _1617 = _1616 * 2.007874011993408f;
        float _1618 = select(_1614, 0.5f, 0.0f);
        float _1619 = -0.0f - _98;
        float _1620 = -0.0f - _99;
        float _1621 = -0.0f - _100;
        float _1622 = dot(float3(_187, _188, _189), float3(_1619, _1620, _1621));
        float _1623 = saturate(_1622);
        float _1624 = _1623 * 0.4000000059604645f;
        float _1625 = -0.0f - _1334;
        float _1626 = -0.0f - _1335;
        float _1627 = -0.0f - _1336;
        float _1628 = dot(float3(_187, _188, _189), float3(_1625, _1626, _1627));
        float _1629 = saturate(_1628);
        float _1630 = log2(_1629);
        float _1631 = _1630 * 7.0f;
        float _1632 = exp2(_1631);
        float _1633 = _1632 + _1624;
        float _1634 = saturate(_1633);
        float _1635 = _1634 * _1618;
        float _1636 = _1635 * _1441;
        float _1637 = _1635 * _1442;
        float _1638 = _1635 * _1443;
        float _1639 = abs(_1441);
        float _1640 = abs(_1442);
        float _1641 = abs(_1443);
        float _1642 = sqrt(_1639);
        float _1643 = sqrt(_1640);
        float _1644 = sqrt(_1641);
        float _1645 = 1.0f - _1642;
        float _1646 = 1.0f - _1643;
        float _1647 = 1.0f - _1644;
        float _1648 = _1399 * 5.55472993850708f;
        float _1649 = -6.983160018920898f - _1648;
        float _1650 = _1649 * _1399;
        float _1651 = exp2(_1650);
        float _1652 = _1651 * _1645;
        float _1653 = _1651 * _1646;
        float _1654 = _1647 * _1651;
        float _1655 = _1652 + _1642;
        float _1656 = _1653 + _1643;
        float _1657 = _1654 + _1644;
        float _1658 = _1395 + _217;
        float _1659 = _1395 * _217;
        float _1660 = _1658 - _1659;
        float _1661 = _1660 * 4.0f;
        float _1662 = _1661 + 9.999999682655225e-21f;
        float _1663 = 1.0f / _1662;
        float _1664 = 0.5f / _1452;
        float _1665 = _1397 * _1397;
        float _1666 = 1.0f - _1665;
        float _1667 = _1664 + 1.0f;
        float _1668 = log2(_1666);
        float _1669 = _1668 * _1664;
        float _1670 = exp2(_1669);
        float _1671 = _1667 * _1663;
        float _1672 = _1671 * _1670;
        float _1673 = _217 * p_m_fSpecularStrength;
        float _1674 = _1655 * _1673;
        float _1675 = _1674 * _1672;
        float _1676 = _1656 * _1673;
        float _1677 = _1676 * _1672;
        float _1678 = _1657 * _1673;
        float _1679 = _1678 * _1672;
        float _1680 = _1636 - _1606;
        float _1681 = _1680 + _1675;
        float _1682 = _1637 - _1607;
        float _1683 = _1682 + _1677;
        float _1684 = _1638 - _1608;
        float _1685 = _1684 + _1679;
        float _1686 = _1681 * _1617;
        float _1687 = _1683 * _1617;
        float _1688 = _1685 * _1617;
        float _1689 = _1686 + _1609;
        float _1690 = _1687 + _1610;
        float _1691 = _1688 + _1611;
        _1693 = _1689;
        _1694 = _1690;
        _1695 = _1691;
      } else {
        _1693 = _1609;
        _1694 = _1610;
        _1695 = _1611;
      }
      float _1696 = _1693 * _1326;
      float _1697 = _1694 * _1327;
      float _1698 = _1695 * _1328;
      float _1699 = min(_1696, 1000.0f);
      float _1700 = min(_1697, 1000.0f);
      float _1701 = min(_1698, 1000.0f);
      bool _1702 = (MaterialIdEquals(_80.w, 0.007843137718737125f));
      [branch]
      if (_1702) {
        float _1704 = _80.x * 0.019444789737462997f;
        float _1705 = _80.y * 1.680522836977616e-05f;
        float _1706 = _80.z * 3.190706726607928e-11f;
        float _1707 = -0.0f - _98;
        float _1708 = -0.0f - _99;
        float _1709 = -0.0f - _100;
        float _1710 = dot(float3(_187, _188, _189), float3(_1707, _1708, _1709));
        float _1711 = _1710 + 0.30000001192092896f;
        float _1712 = saturate(_1711);
        float _1713 = _1704 * _1326;
        float _1714 = _1713 * _1712;
        float _1715 = _1705 * _1327;
        float _1716 = _1715 * _1712;
        float _1717 = _1706 * _1328;
        float _1718 = _1717 * _1712;
        float _1719 = _1714 + _1699;
        float _1720 = _1716 + _1700;
        float _1721 = _1718 + _1701;
        _1723 = _1719;
        _1724 = _1720;
        _1725 = _1721;
      } else {
        _1723 = _1699;
        _1724 = _1700;
        _1725 = _1701;
      }
      bool _1726 = (_28 < 3.0f);
      bool _1727 = _1726 && _1702;
      [branch]
      if (_1727) {
        float _1729 = _28 + -2.0f;
        float _1730 = max(_1729, 0.0f);
        float _1735 = 1.0f - g_xSubsurfaceScatteringWeight.x;
        float _1736 = 1.0f - g_xSubsurfaceScatteringWeight.y;
        float _1737 = 1.0f - g_xSubsurfaceScatteringWeight.z;
        float _1738 = _1735 * _1730;
        float _1739 = _1736 * _1730;
        float _1740 = _1737 * _1730;
        float _1741 = _1738 + g_xSubsurfaceScatteringWeight.x;
        float _1742 = _1739 + g_xSubsurfaceScatteringWeight.y;
        float _1743 = _1740 + g_xSubsurfaceScatteringWeight.z;
        float _1744 = _1741 * _1723;
        float _1745 = _1742 * _1724;
        float _1746 = _1743 * _1725;
        _1748 = true;
        _1749 = _1744;
        _1750 = _1745;
        _1751 = _1746;
        _1752 = _1323;
      } else {
        _1748 = true;
        _1749 = _1723;
        _1750 = _1724;
        _1751 = _1725;
        _1752 = _1323;
      }
    } else {
      _1748 = false;
      _1749 = 0.0f;
      _1750 = 0.0f;
      _1751 = 0.0f;
      _1752 = _1323;
    }
  } else {
    _1748 = false;
    _1749 = 0.0f;
    _1750 = 0.0f;
    _1751 = 0.0f;
    _1752 = 1.0f;
  }
  [branch]
  if (!_1748) {
    if (true) discard;
  }
  SV_Target.x = _1749;
  SV_Target.y = _1750;
  SV_Target.z = _1751;
  SV_Target.w = _1752;
  return SV_Target;
}
