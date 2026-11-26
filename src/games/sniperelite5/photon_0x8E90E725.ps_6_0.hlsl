#include "./shared.h"
// Baseline: 4 fewer fmul fast + 1 fewer fmul fast x,0.25 (dxc reassociation of the 0.25 light-scale and the specular phi*colour*K chains), otherwise identical to the original DXIL.

struct PhotonFace {
  uint uLevel;
  float fSize;
  float fInvSize;
  int iShadowIndex;
};

struct PhotonParams {
  float4 o0;
  float4 o1;
  float4 o2;
  float4 o3;
  float4 c0;
  float4 c1;
  float4 c2;
  float4 c3;
  float3 pos;
  float areaR;
  float3 dir;
  float range;
  float3 col;
  int useLimit;
  float falloffScale;
  float falloffPow;
  float angleOuter;
  float rcpAngleRange;
  float arcCosLimit;
  float rcpProjLerp;
  int useProj;
  int useDualProj;
  float2 depthProj;
  float meshRadius;
  float shadowStrength;
  float shadowSoftness;
  float shadowNear;
  float shadowFar;
  float shadowBias;
  float specStrength;
  float padding;
  int projIdx;
  int projBlurIdx;
  PhotonFace faces[6];
};

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

StructuredBuffer<PhotonParams> g_axPhotons : register(t41);

TextureCube<float4> g_xProjCubeMap : register(t6);

TextureCube<float4> g_xProjCubeMapBlurred : register(t7);

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

SamplerState g_xTrilinearClamp : register(s5);

SamplerComparisonState g_xShadowCmpSampler : register(s8);

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _21[6];
  int _22[6];
  int _23 = int(SV_Position.x);
  int _24 = int(SV_Position.y);
  float4 _25 = g_xLighting_DepthStencil.Load(int3(_23, _24, 0));
  float _30 = g_xDepthProjViewUnpack.y - _25.x;
  float _31 = g_xDepthProjViewUnpack.x / _30;
  float _35 = g_xCameraTanHalfFOV.x * _31;
  float _36 = g_xCameraTanHalfFOV.y * _31;
  float _40 = g_xTwoOverScreenDimensions.z + SV_Position.x;
  float _41 = g_xTwoOverScreenDimensions.w + SV_Position.y;
  float _44 = _40 * g_xTwoOverScreenDimensions.x;
  float _45 = _41 * g_xTwoOverScreenDimensions.y;
  float _46 = _44 + -1.0f;
  float _47 = _45 + -1.0f;
  float _48 = _35 * _46;
  float _49 = _36 * _47;
  float _66 = _48 * (g_xInvView[0].x);
  float _67 = mad((g_xInvView[1].x), _49, _66);
  float _68 = mad((g_xInvView[2].x), _31, _67);
  float _69 = _68 + (g_xInvView[3].x);
  float _70 = _48 * (g_xInvView[0].y);
  float _71 = mad((g_xInvView[1].y), _49, _70);
  float _72 = mad((g_xInvView[2].y), _31, _71);
  float _73 = _72 + (g_xInvView[3].y);
  float _74 = _48 * (g_xInvView[0].z);
  float _75 = mad((g_xInvView[1].z), _49, _74);
  float _76 = mad((g_xInvView[2].z), _31, _75);
  float _77 = _76 + (g_xInvView[3].z);
  float4 _78 = g_xLighting_NormalBuffer.Load(int3(_23, _24, 0));
  float4 _83 = g_xLighting_AlbedoBuffer.Load(int3(_23, _24, 0));
  float4 _88 = g_xLighting_PBRPropertiesBuffer.Load(int3(_23, _24, 0));
  float _93 = _78.x * 2.0f;
  float _94 = _78.y * 2.0f;
  float _95 = _78.z * 2.0f;
  float _96 = _93 + -1.0f;
  float _97 = _94 + -1.0f;
  float _98 = _95 + -1.0f;
  float _99 = dot(float3(_96, _97, _98), float3(_96, _97, _98));
  float _100 = rsqrt(_99);
  float _101 = _100 * _96;
  float _102 = _100 * _97;
  float _103 = _100 * _98;
  float _104 = _88.z * 2.0f;
  float _105 = _88.w * 2.0f;
  float _106 = _104 + -1.0f;
  float _107 = _105 + -1.0f;
  float _108 = dot(float2(_106, _107), float2(_106, _107));
  float _109 = 1.0f - _108;
  float _110 = saturate(_109);
  float _111 = sqrt(_110);
  bool _112 = (_78.w != 0.0f);
  float _113 = -0.0f - _111;
  float _114 = select(_112, _111, _113);
  uint _116 = g_uPhotonIndex;
  float4 _117 = g_axPhotons[_116].o0;
  float4 _121 = g_axPhotons[_116].o1;
  float4 _125 = g_axPhotons[_116].o2;
  float3 _129 = g_axPhotons[_116].pos;
  float _133 = g_axPhotons[_116].areaR;
  float3 _135 = g_axPhotons[_116].dir;
  float _136 = g_axPhotons[_116].range;
  float3 _138 = g_axPhotons[_116].col;
  int _142 = g_axPhotons[_116].useLimit;
  float _144 = g_axPhotons[_116].falloffScale;
  float _146 = g_axPhotons[_116].falloffPow;
  float _148 = g_axPhotons[_116].angleOuter;
  float _149 = g_axPhotons[_116].rcpAngleRange;
  float _150 = g_axPhotons[_116].rcpProjLerp;
  int _152 = g_axPhotons[_116].useProj;
  int _154 = g_axPhotons[_116].useDualProj;
  float2 _156 = g_axPhotons[_116].depthProj;
  float _159 = g_axPhotons[_116].shadowStrength;
  float _161 = g_axPhotons[_116].shadowSoftness;
  float _163 = g_axPhotons[_116].shadowNear;
  float _165 = g_axPhotons[_116].shadowFar;
  float _167 = g_axPhotons[_116].shadowBias;
  float _169 = g_axPhotons[_116].specStrength;
  float _171 = g_axPhotons[_116].faces[0].fInvSize;
  int _173 = g_axPhotons[_116].faces[0].iShadowIndex;
  float _175 = g_axPhotons[_116].faces[1].fInvSize;
  int _177 = g_axPhotons[_116].faces[1].iShadowIndex;
  float _179 = g_axPhotons[_116].faces[2].fInvSize;
  int _181 = g_axPhotons[_116].faces[2].iShadowIndex;
  float _183 = g_axPhotons[_116].faces[3].fInvSize;
  int _185 = g_axPhotons[_116].faces[3].iShadowIndex;
  float _187 = g_axPhotons[_116].faces[4].fInvSize;
  int _189 = g_axPhotons[_116].faces[4].iShadowIndex;
  float _191 = g_axPhotons[_116].faces[5].fInvSize;
  int _193 = g_axPhotons[_116].faces[5].iShadowIndex;
  float _199 = _129.x - _69;
  float _200 = _129.y - _73;
  float _201 = _129.z - _77;
  float _202 = _199 * _199;
  float _203 = _200 * _200;
  float _204 = _203 + _202;
  float _205 = _201 * _201;
  float _206 = _204 + _205;
  float _207 = sqrt(_206);
  float _208 = _199 / _207;
  float _209 = _200 / _207;
  float _210 = _201 / _207;
  float _211 = _207 - _133.x;
  float _212 = _136.x - _133.x;
  float _213 = _211 / _212;
  float _214 = saturate(_213);
  float _215 = 1.0f - _214;
  float _216 = _215 * _144.x;
  float _217 = saturate(_216);
  float _218 = log2(_217);
  float _219 = _218 * _146.x;
  float _220 = exp2(_219);
  bool _221 = (_142.x == 0);
  float _234;
  int _292;
  float _293;
  float _294;
  float _363;
  float _376;
  float _377;
  float _417;
  float _432;
  float _433;
  float _473;
  float _488;
  float _489;
  float _529;
  float _544;
  float _545;
  float _598;
  float _637;
  float _677;
  float _717;
  float _760;
  float _803;
  float _846;
  float _889;
  float _930;
  float _966;
  float _1003;
  float _1040;
  float _1077;
  float _1114;
  float _1151;
  float _1188;
  float _1225;
  float _1262;
  float _1299;
  float _1336;
  float _1340;
  float _1344;
  float _1384;
  float _1385;
  float _1386;
  float _1391;
  float _1392;
  float _1393;
  float _1445;
  float _1446;
  float _1447;
  float _1448;
  float _1506;
  float _1507;
  float _1508;
  float _1509;
  float _1510;
  float _1511;
  float _1512;
  float _1646;
  float _1671;
  float _1672;
  float _1673;
  float _1758;
  float _1759;
  float _1760;
  float _1788;
  float _1789;
  float _1790;
  bool _1813;
  float _1814;
  float _1815;
  float _1816;
  float _1817;
  [branch]
  if (!_221) {
    float _228 = dot(float3(_208, _209, _210), float3(_135.x, _135.y, _135.z));
    float _229 = _228 + _148.x;
    float _230 = _229 * _149.x;
    float _231 = saturate(_230);
    float _232 = _231 * _220;
    _234 = _232;
  } else {
    _234 = _220;
  }
  bool _235 = (_234 < 9.999999747378752e-05f);
  [branch]
  if (!_235) {
    float _237 = dot(float3(_101, _102, _103), float3(_208, _209, _210));
    float _238 = saturate(_237);
    float _239 = 1.0f - _238;
    float _240 = _239 * _167.x;
    float _241 = max(_240, _167.x);
    float _242 = -0.0f - _199;
    float _243 = -0.0f - _201;
    float _244 = abs(_242);
    float _245 = abs(_200);
    float _246 = abs(_243);
    float _247 = max(_245, _246);
    float _248 = max(_244, _247);
    float _249 = _242 / _248;
    float _250 = _200 / _248;
    float _251 = _243 / _248;
    float _252 = _248 - _241;
    float _253 = _156.y / _252;
    float _254 = _253 + _156.x;
    float _255 = 1.0f - _254;
    float _256 = _255 * 2.0f;
    float _257 = _256 + -1.0f;
    float _258 = _163.x * 2.0f;
    float _259 = _258 * _165.x;
    float _260 = _165.x + _163.x;
    float _261 = _165.x - _163.x;
    float _262 = _257 * _261;
    float _263 = _260 - _262;
    float _264 = _259 / _263;
    float _265 = _264 - _163.x;
    float _266 = _265 / _261;
    float _267 = saturate(_266);
    bool _268 = (_245 > _244);
    [branch]
    if (_268) {
      bool _270 = (_246 > _245);
      [branch]
      if (_270) {
        bool _272 = (_251 < 0.0f);
        float _273 = -0.0f - _250;
        [branch]
        if (_272) {
          float _275 = -0.0f - _249;
          _292 = 5;
          _293 = _275;
          _294 = _273;
        } else {
          _292 = 4;
          _293 = _249;
          _294 = _273;
        }
      } else {
        bool _277 = (_250 < 0.0f);
        [branch]
        if (_277) {
          float _279 = -0.0f - _251;
          _292 = 2;
          _293 = _249;
          _294 = _279;
        } else {
          _292 = 3;
          _293 = _249;
          _294 = _251;
        }
      }
    } else {
      bool _281 = (_246 > _244);
      float _282 = -0.0f - _250;
      [branch]
      if (_281) {
        bool _284 = (_251 < 0.0f);
        [branch]
        if (_284) {
          float _286 = -0.0f - _249;
          _292 = 5;
          _293 = _286;
          _294 = _282;
        } else {
          _292 = 4;
          _293 = _249;
          _294 = _282;
        }
      } else {
        bool _288 = (_249 < 0.0f);
        [branch]
        if (!_288) {
          float _290 = -0.0f - _251;
          _292 = 0;
          _293 = _290;
          _294 = _282;
        } else {
          _292 = 1;
          _293 = _251;
          _294 = _282;
        }
      }
    }
    float _295 = _293 * 0.5f;
    float _296 = _294 * 0.5f;
    float _297 = _295 + 0.5f;
    float _298 = _296 + 0.5f;
    bool _299 = (_159.x > 0.0f);
    [branch]
    if (_299) {
      _21[0] = _171.x;
      _22[0] = (int)(_173.x);
      _21[1] = _175.x;
      _22[1] = (int)(_177.x);
      _21[2] = _179.x;
      _22[2] = (int)(_181.x);
      _21[3] = _183.x;
      _22[3] = (int)(_185.x);
      _21[4] = _187.x;
      _22[4] = (int)(_189.x);
      _21[5] = _191.x;
      _22[5] = (int)(_193.x);
      int _314 = _22[_292];
      bool _315 = (_314 == -1);
      [branch]
      if (!_315) {
        bool _317 = (_161.x > 0.0f);
        bool _318 = (_292 == 0);
        [branch]
        if (_317) {
          float _320 = dot(float2(SV_Position.x, SV_Position.y), float2(0.0671105608344078f, 0.005837149918079376f));
          float _321 = frac(_320);
          float _322 = _321 * 52.98291778564453f;
          float _323 = frac(_322);
          float _324 = _323 * 6.283185005187988f;
          float _325 = sin(_324);
          float _326 = cos(_324);
          float _327 = _161.x * 0.008838835172355175f;
          float _328 = _327 * _326;
          float _329 = _327 * _325;
          float _330 = _328 + _297;
          float _331 = _329 + _298;
          float _332 = max(_330, 0.0f);
          float _333 = max(_331, 0.0f);
          float _334 = min(_332, 1.0f);
          float _335 = min(_333, 1.0f);
          [branch]
          if (!_318) {
            bool _337 = (_292 == 1);
            [branch]
            if (!_337) {
              bool _339 = (_292 == 2);
              [branch]
              if (!_339) {
                bool _341 = (_292 == 3);
                [branch]
                if (!_341) {
                  bool _343 = (_292 == 4);
                  [branch]
                  if (!_343) {
                    float4 _345 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_334, _335));
                    _363 = _345.x;
                  } else {
                    float4 _348 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_334, _335));
                    _363 = _348.x;
                  }
                } else {
                  float4 _351 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_334, _335));
                  _363 = _351.x;
                }
              } else {
                float4 _354 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_334, _335));
                _363 = _354.x;
              }
            } else {
              float4 _357 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_334, _335));
              _363 = _357.x;
            }
          } else {
            float4 _360 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_334, _335));
            _363 = _360.x;
          }
          float _364 = 1.0f - _363;
          float _365 = _364 * 2.0f;
          float _366 = _365 + -1.0f;
          float _367 = _366 * _261;
          float _368 = _260 - _367;
          float _369 = _259 / _368;
          float _370 = _369 - _163.x;
          float _371 = _370 / _261;
          float _372 = saturate(_371);
          bool _373 = (_372 < _267);
          [branch]
          if (_373) {
            _376 = _372;
            _377 = 1.0f;
          } else {
            _376 = 0.0f;
            _377 = 0.0f;
          }
          float _378 = _324 + 2.4000000953674316f;
          float _379 = sin(_378);
          float _380 = cos(_378);
          float _381 = _161.x * 0.01530931144952774f;
          float _382 = _381 * _380;
          float _383 = _381 * _379;
          float _384 = _382 + _297;
          float _385 = _383 + _298;
          float _386 = max(_384, 0.0f);
          float _387 = max(_385, 0.0f);
          float _388 = min(_386, 1.0f);
          float _389 = min(_387, 1.0f);
          [branch]
          if (!_318) {
            bool _391 = (_292 == 1);
            [branch]
            if (!_391) {
              bool _393 = (_292 == 2);
              [branch]
              if (!_393) {
                bool _395 = (_292 == 3);
                [branch]
                if (!_395) {
                  bool _397 = (_292 == 4);
                  [branch]
                  if (!_397) {
                    float4 _399 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_388, _389));
                    _417 = _399.x;
                  } else {
                    float4 _402 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_388, _389));
                    _417 = _402.x;
                  }
                } else {
                  float4 _405 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_388, _389));
                  _417 = _405.x;
                }
              } else {
                float4 _408 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_388, _389));
                _417 = _408.x;
              }
            } else {
              float4 _411 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_388, _389));
              _417 = _411.x;
            }
          } else {
            float4 _414 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_388, _389));
            _417 = _414.x;
          }
          float _418 = 1.0f - _417;
          float _419 = _418 * 2.0f;
          float _420 = _419 + -1.0f;
          float _421 = _420 * _261;
          float _422 = _260 - _421;
          float _423 = _259 / _422;
          float _424 = _423 - _163.x;
          float _425 = _424 / _261;
          float _426 = saturate(_425);
          bool _427 = (_426 < _267);
          [branch]
          if (_427) {
            float _429 = _426 + _376;
            float _430 = _377 + 1.0f;
            _432 = _429;
            _433 = _430;
          } else {
            _432 = _376;
            _433 = _377;
          }
          float _434 = _324 + 4.800000190734863f;
          float _435 = sin(_434);
          float _436 = cos(_434);
          float _437 = _161.x * 0.019764235243201256f;
          float _438 = _437 * _436;
          float _439 = _437 * _435;
          float _440 = _438 + _297;
          float _441 = _439 + _298;
          float _442 = max(_440, 0.0f);
          float _443 = max(_441, 0.0f);
          float _444 = min(_442, 1.0f);
          float _445 = min(_443, 1.0f);
          [branch]
          if (!_318) {
            bool _447 = (_292 == 1);
            [branch]
            if (!_447) {
              bool _449 = (_292 == 2);
              [branch]
              if (!_449) {
                bool _451 = (_292 == 3);
                [branch]
                if (!_451) {
                  bool _453 = (_292 == 4);
                  [branch]
                  if (!_453) {
                    float4 _455 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_444, _445));
                    _473 = _455.x;
                  } else {
                    float4 _458 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_444, _445));
                    _473 = _458.x;
                  }
                } else {
                  float4 _461 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_444, _445));
                  _473 = _461.x;
                }
              } else {
                float4 _464 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_444, _445));
                _473 = _464.x;
              }
            } else {
              float4 _467 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_444, _445));
              _473 = _467.x;
            }
          } else {
            float4 _470 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_444, _445));
            _473 = _470.x;
          }
          float _474 = 1.0f - _473;
          float _475 = _474 * 2.0f;
          float _476 = _475 + -1.0f;
          float _477 = _476 * _261;
          float _478 = _260 - _477;
          float _479 = _259 / _478;
          float _480 = _479 - _163.x;
          float _481 = _480 / _261;
          float _482 = saturate(_481);
          bool _483 = (_482 < _267);
          [branch]
          if (_483) {
            float _485 = _482 + _432;
            float _486 = _433 + 1.0f;
            _488 = _485;
            _489 = _486;
          } else {
            _488 = _432;
            _489 = _433;
          }
          float _490 = _324 + 7.200000286102295f;
          float _491 = sin(_490);
          float _492 = cos(_490);
          float _493 = _161.x * 0.023385358974337578f;
          float _494 = _493 * _492;
          float _495 = _493 * _491;
          float _496 = _494 + _297;
          float _497 = _495 + _298;
          float _498 = max(_496, 0.0f);
          float _499 = max(_497, 0.0f);
          float _500 = min(_498, 1.0f);
          float _501 = min(_499, 1.0f);
          [branch]
          if (!_318) {
            bool _503 = (_292 == 1);
            [branch]
            if (!_503) {
              bool _505 = (_292 == 2);
              [branch]
              if (!_505) {
                bool _507 = (_292 == 3);
                [branch]
                if (!_507) {
                  bool _509 = (_292 == 4);
                  [branch]
                  if (!_509) {
                    float4 _511 = g_xShadowCubeMapNegZ.Sample(g_xBilinearClamp, float2(_500, _501));
                    _529 = _511.x;
                  } else {
                    float4 _514 = g_xShadowCubeMapPosZ.Sample(g_xBilinearClamp, float2(_500, _501));
                    _529 = _514.x;
                  }
                } else {
                  float4 _517 = g_xShadowCubeMapNegY.Sample(g_xBilinearClamp, float2(_500, _501));
                  _529 = _517.x;
                }
              } else {
                float4 _520 = g_xShadowCubeMapPosY.Sample(g_xBilinearClamp, float2(_500, _501));
                _529 = _520.x;
              }
            } else {
              float4 _523 = g_xShadowCubeMapNegX.Sample(g_xBilinearClamp, float2(_500, _501));
              _529 = _523.x;
            }
          } else {
            float4 _526 = g_xShadowCubeMapPosX.Sample(g_xBilinearClamp, float2(_500, _501));
            _529 = _526.x;
          }
          float _530 = 1.0f - _529;
          float _531 = _530 * 2.0f;
          float _532 = _531 + -1.0f;
          float _533 = _532 * _261;
          float _534 = _260 - _533;
          float _535 = _259 / _534;
          float _536 = _535 - _163.x;
          float _537 = _536 / _261;
          float _538 = saturate(_537);
          bool _539 = (_538 < _267);
          [branch]
          if (_539) {
            float _541 = _538 + _488;
            float _542 = _489 + 1.0f;
            _544 = _541;
            _545 = _542;
          } else {
            _544 = _488;
            _545 = _489;
          }
          bool _546 = (_545 > 0.0f);
          [branch]
          if (_546) {
            float _548 = _544 / _545;
            float _549 = _267 - _548;
            float _550 = _549 / _548;
            float _551 = _550 * _550;
            float _552 = saturate(_551);
            float _553 = _161.x * 0.02500000037252903f;
            float _554 = _553 * _552;
            float _556 = _21[_292];
            float _557 = _556 * 2.0f;
            float _558 = _554 + _557;
            float _559 = _326 * 0.25f;
            float _560 = _325 * 0.25f;
            float _561 = _559 * _558;
            float _562 = _560 * _558;
            float _563 = _561 + _297;
            float _564 = _562 + _298;
            float _565 = max(_563, 0.0f);
            float _566 = max(_564, 0.0f);
            float _567 = min(_565, 1.0f);
            float _568 = min(_566, 1.0f);
            [branch]
            if (!_318) {
              bool _570 = (_292 == 1);
              [branch]
              if (!_570) {
                bool _572 = (_292 == 2);
                [branch]
                if (!_572) {
                  bool _574 = (_292 == 3);
                  [branch]
                  if (!_574) {
                    bool _576 = (_292 == 4);
                    [branch]
                    if (!_576) {
                      bool _578 = (_292 == 5);
                      [branch]
                      if (_578) {
                        float4 _580 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_567, _568), _254);
                        _598 = _580.x;
                      } else {
                        _598 = 0.0f;
                      }
                    } else {
                      float4 _583 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_567, _568), _254);
                      _598 = _583.x;
                    }
                  } else {
                    float4 _586 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_567, _568), _254);
                    _598 = _586.x;
                  }
                } else {
                  float4 _589 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_567, _568), _254);
                  _598 = _589.x;
                }
              } else {
                float4 _592 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_567, _568), _254);
                _598 = _592.x;
              }
            } else {
              float4 _595 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_567, _568), _254);
              _598 = _595.x;
            }
            float _599 = _558 * 0.4330127239227295f;
            float _600 = _599 * _380;
            float _601 = _599 * _379;
            float _602 = _600 + _297;
            float _603 = _601 + _298;
            float _604 = max(_602, 0.0f);
            float _605 = max(_603, 0.0f);
            float _606 = min(_604, 1.0f);
            float _607 = min(_605, 1.0f);
            [branch]
            if (!_318) {
              bool _609 = (_292 == 1);
              [branch]
              if (!_609) {
                bool _611 = (_292 == 2);
                [branch]
                if (!_611) {
                  bool _613 = (_292 == 3);
                  [branch]
                  if (!_613) {
                    bool _615 = (_292 == 4);
                    [branch]
                    if (!_615) {
                      bool _617 = (_292 == 5);
                      [branch]
                      if (_617) {
                        float4 _619 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_606, _607), _254);
                        _637 = _619.x;
                      } else {
                        _637 = 0.0f;
                      }
                    } else {
                      float4 _622 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_606, _607), _254);
                      _637 = _622.x;
                    }
                  } else {
                    float4 _625 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_606, _607), _254);
                    _637 = _625.x;
                  }
                } else {
                  float4 _628 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_606, _607), _254);
                  _637 = _628.x;
                }
              } else {
                float4 _631 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_606, _607), _254);
                _637 = _631.x;
              }
            } else {
              float4 _634 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_606, _607), _254);
              _637 = _634.x;
            }
            float _638 = _637 + _598;
            float _639 = _558 * 0.55901700258255f;
            float _640 = _639 * _436;
            float _641 = _639 * _435;
            float _642 = _640 + _297;
            float _643 = _641 + _298;
            float _644 = max(_642, 0.0f);
            float _645 = max(_643, 0.0f);
            float _646 = min(_644, 1.0f);
            float _647 = min(_645, 1.0f);
            [branch]
            if (!_318) {
              bool _649 = (_292 == 1);
              [branch]
              if (!_649) {
                bool _651 = (_292 == 2);
                [branch]
                if (!_651) {
                  bool _653 = (_292 == 3);
                  [branch]
                  if (!_653) {
                    bool _655 = (_292 == 4);
                    [branch]
                    if (!_655) {
                      bool _657 = (_292 == 5);
                      [branch]
                      if (_657) {
                        float4 _659 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_646, _647), _254);
                        _677 = _659.x;
                      } else {
                        _677 = 0.0f;
                      }
                    } else {
                      float4 _662 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_646, _647), _254);
                      _677 = _662.x;
                    }
                  } else {
                    float4 _665 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_646, _647), _254);
                    _677 = _665.x;
                  }
                } else {
                  float4 _668 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_646, _647), _254);
                  _677 = _668.x;
                }
              } else {
                float4 _671 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_646, _647), _254);
                _677 = _671.x;
              }
            } else {
              float4 _674 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_646, _647), _254);
              _677 = _674.x;
            }
            float _678 = _638 + _677;
            float _679 = _558 * 0.6614378690719604f;
            float _680 = _679 * _492;
            float _681 = _679 * _491;
            float _682 = _680 + _297;
            float _683 = _681 + _298;
            float _684 = max(_682, 0.0f);
            float _685 = max(_683, 0.0f);
            float _686 = min(_684, 1.0f);
            float _687 = min(_685, 1.0f);
            [branch]
            if (!_318) {
              bool _689 = (_292 == 1);
              [branch]
              if (!_689) {
                bool _691 = (_292 == 2);
                [branch]
                if (!_691) {
                  bool _693 = (_292 == 3);
                  [branch]
                  if (!_693) {
                    bool _695 = (_292 == 4);
                    [branch]
                    if (!_695) {
                      bool _697 = (_292 == 5);
                      [branch]
                      if (_697) {
                        float4 _699 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_686, _687), _254);
                        _717 = _699.x;
                      } else {
                        _717 = 0.0f;
                      }
                    } else {
                      float4 _702 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_686, _687), _254);
                      _717 = _702.x;
                    }
                  } else {
                    float4 _705 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_686, _687), _254);
                    _717 = _705.x;
                  }
                } else {
                  float4 _708 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_686, _687), _254);
                  _717 = _708.x;
                }
              } else {
                float4 _711 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_686, _687), _254);
                _717 = _711.x;
              }
            } else {
              float4 _714 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_686, _687), _254);
              _717 = _714.x;
            }
            float _718 = _678 + _717;
            float _719 = _324 + 9.600000381469727f;
            float _720 = sin(_719);
            float _721 = cos(_719);
            float _722 = _558 * 0.75f;
            float _723 = _722 * _721;
            float _724 = _722 * _720;
            float _725 = _723 + _297;
            float _726 = _724 + _298;
            float _727 = max(_725, 0.0f);
            float _728 = max(_726, 0.0f);
            float _729 = min(_727, 1.0f);
            float _730 = min(_728, 1.0f);
            [branch]
            if (!_318) {
              bool _732 = (_292 == 1);
              [branch]
              if (!_732) {
                bool _734 = (_292 == 2);
                [branch]
                if (!_734) {
                  bool _736 = (_292 == 3);
                  [branch]
                  if (!_736) {
                    bool _738 = (_292 == 4);
                    [branch]
                    if (!_738) {
                      bool _740 = (_292 == 5);
                      [branch]
                      if (_740) {
                        float4 _742 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_729, _730), _254);
                        _760 = _742.x;
                      } else {
                        _760 = 0.0f;
                      }
                    } else {
                      float4 _745 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_729, _730), _254);
                      _760 = _745.x;
                    }
                  } else {
                    float4 _748 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_729, _730), _254);
                    _760 = _748.x;
                  }
                } else {
                  float4 _751 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_729, _730), _254);
                  _760 = _751.x;
                }
              } else {
                float4 _754 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_729, _730), _254);
                _760 = _754.x;
              }
            } else {
              float4 _757 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_729, _730), _254);
              _760 = _757.x;
            }
            float _761 = _718 + _760;
            float _762 = _324 + 12.0f;
            float _763 = sin(_762);
            float _764 = cos(_762);
            float _765 = _558 * 0.829156219959259f;
            float _766 = _765 * _764;
            float _767 = _765 * _763;
            float _768 = _766 + _297;
            float _769 = _767 + _298;
            float _770 = max(_768, 0.0f);
            float _771 = max(_769, 0.0f);
            float _772 = min(_770, 1.0f);
            float _773 = min(_771, 1.0f);
            [branch]
            if (!_318) {
              bool _775 = (_292 == 1);
              [branch]
              if (!_775) {
                bool _777 = (_292 == 2);
                [branch]
                if (!_777) {
                  bool _779 = (_292 == 3);
                  [branch]
                  if (!_779) {
                    bool _781 = (_292 == 4);
                    [branch]
                    if (!_781) {
                      bool _783 = (_292 == 5);
                      [branch]
                      if (_783) {
                        float4 _785 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_772, _773), _254);
                        _803 = _785.x;
                      } else {
                        _803 = 0.0f;
                      }
                    } else {
                      float4 _788 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_772, _773), _254);
                      _803 = _788.x;
                    }
                  } else {
                    float4 _791 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_772, _773), _254);
                    _803 = _791.x;
                  }
                } else {
                  float4 _794 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_772, _773), _254);
                  _803 = _794.x;
                }
              } else {
                float4 _797 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_772, _773), _254);
                _803 = _797.x;
              }
            } else {
              float4 _800 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_772, _773), _254);
              _803 = _800.x;
            }
            float _804 = _761 + _803;
            float _805 = _324 + 14.40000057220459f;
            float _806 = sin(_805);
            float _807 = cos(_805);
            float _808 = _558 * 0.9013878107070923f;
            float _809 = _808 * _807;
            float _810 = _808 * _806;
            float _811 = _809 + _297;
            float _812 = _810 + _298;
            float _813 = max(_811, 0.0f);
            float _814 = max(_812, 0.0f);
            float _815 = min(_813, 1.0f);
            float _816 = min(_814, 1.0f);
            [branch]
            if (!_318) {
              bool _818 = (_292 == 1);
              [branch]
              if (!_818) {
                bool _820 = (_292 == 2);
                [branch]
                if (!_820) {
                  bool _822 = (_292 == 3);
                  [branch]
                  if (!_822) {
                    bool _824 = (_292 == 4);
                    [branch]
                    if (!_824) {
                      bool _826 = (_292 == 5);
                      [branch]
                      if (_826) {
                        float4 _828 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_815, _816), _254);
                        _846 = _828.x;
                      } else {
                        _846 = 0.0f;
                      }
                    } else {
                      float4 _831 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_815, _816), _254);
                      _846 = _831.x;
                    }
                  } else {
                    float4 _834 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_815, _816), _254);
                    _846 = _834.x;
                  }
                } else {
                  float4 _837 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_815, _816), _254);
                  _846 = _837.x;
                }
              } else {
                float4 _840 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_815, _816), _254);
                _846 = _840.x;
              }
            } else {
              float4 _843 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_815, _816), _254);
              _846 = _843.x;
            }
            float _847 = _804 + _846;
            float _848 = _324 + 16.80000114440918f;
            float _849 = sin(_848);
            float _850 = cos(_848);
            float _851 = _558 * 0.9682458639144897f;
            float _852 = _851 * _850;
            float _853 = _851 * _849;
            float _854 = _852 + _297;
            float _855 = _853 + _298;
            float _856 = max(_854, 0.0f);
            float _857 = max(_855, 0.0f);
            float _858 = min(_856, 1.0f);
            float _859 = min(_857, 1.0f);
            [branch]
            if (!_318) {
              bool _861 = (_292 == 1);
              [branch]
              if (!_861) {
                bool _863 = (_292 == 2);
                [branch]
                if (!_863) {
                  bool _865 = (_292 == 3);
                  [branch]
                  if (!_865) {
                    bool _867 = (_292 == 4);
                    [branch]
                    if (!_867) {
                      bool _869 = (_292 == 5);
                      [branch]
                      if (_869) {
                        float4 _871 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_858, _859), _254);
                        _889 = _871.x;
                      } else {
                        _889 = 0.0f;
                      }
                    } else {
                      float4 _874 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_858, _859), _254);
                      _889 = _874.x;
                    }
                  } else {
                    float4 _877 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_858, _859), _254);
                    _889 = _877.x;
                  }
                } else {
                  float4 _880 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_858, _859), _254);
                  _889 = _880.x;
                }
              } else {
                float4 _883 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_858, _859), _254);
                _889 = _883.x;
              }
            } else {
              float4 _886 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_858, _859), _254);
              _889 = _886.x;
            }
            float _890 = _847 + _889;
            float _891 = _890 * 0.125f;
            _1340 = _891;
          } else {
            _1340 = 0.0f;
          }
        } else {
          float _894 = _21[_292];
          float _895 = _894 * 0.32621198892593384f;
          float _896 = _894 * 0.40580499172210693f;
          float _897 = _297 - _895;
          float _898 = _298 - _896;
          float _899 = max(_897, 0.0f);
          float _900 = max(_898, 0.0f);
          float _901 = min(_899, 1.0f);
          float _902 = min(_900, 1.0f);
          [branch]
          if (!_318) {
            bool _904 = (_292 == 1);
            [branch]
            if (!_904) {
              bool _906 = (_292 == 2);
              [branch]
              if (!_906) {
                bool _908 = (_292 == 3);
                [branch]
                if (!_908) {
                  bool _910 = (_292 == 4);
                  [branch]
                  if (!_910) {
                    float4 _912 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_901, _902), _254);
                    _930 = _912.x;
                  } else {
                    float4 _915 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_901, _902), _254);
                    _930 = _915.x;
                  }
                } else {
                  float4 _918 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_901, _902), _254);
                  _930 = _918.x;
                }
              } else {
                float4 _921 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_901, _902), _254);
                _930 = _921.x;
              }
            } else {
              float4 _924 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_901, _902), _254);
              _930 = _924.x;
            }
          } else {
            float4 _927 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_901, _902), _254);
            _930 = _927.x;
          }
          float _931 = _894 * 0.8401439785957336f;
          float _932 = _894 * 0.07357999682426453f;
          float _933 = _297 - _931;
          float _934 = _298 - _932;
          float _935 = max(_933, 0.0f);
          float _936 = max(_934, 0.0f);
          float _937 = min(_935, 1.0f);
          float _938 = min(_936, 1.0f);
          [branch]
          if (!_318) {
            bool _940 = (_292 == 1);
            [branch]
            if (!_940) {
              bool _942 = (_292 == 2);
              [branch]
              if (!_942) {
                bool _944 = (_292 == 3);
                [branch]
                if (!_944) {
                  bool _946 = (_292 == 4);
                  [branch]
                  if (!_946) {
                    float4 _948 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_937, _938), _254);
                    _966 = _948.x;
                  } else {
                    float4 _951 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_937, _938), _254);
                    _966 = _951.x;
                  }
                } else {
                  float4 _954 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_937, _938), _254);
                  _966 = _954.x;
                }
              } else {
                float4 _957 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_937, _938), _254);
                _966 = _957.x;
              }
            } else {
              float4 _960 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_937, _938), _254);
              _966 = _960.x;
            }
          } else {
            float4 _963 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_937, _938), _254);
            _966 = _963.x;
          }
          float _967 = _966 + _930;
          float _968 = _894 * 0.6959139704704285f;
          float _969 = _894 * 0.45713698863983154f;
          float _970 = _297 - _968;
          float _971 = _969 + _298;
          float _972 = max(_970, 0.0f);
          float _973 = max(_971, 0.0f);
          float _974 = min(_972, 1.0f);
          float _975 = min(_973, 1.0f);
          [branch]
          if (!_318) {
            bool _977 = (_292 == 1);
            [branch]
            if (!_977) {
              bool _979 = (_292 == 2);
              [branch]
              if (!_979) {
                bool _981 = (_292 == 3);
                [branch]
                if (!_981) {
                  bool _983 = (_292 == 4);
                  [branch]
                  if (!_983) {
                    float4 _985 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_974, _975), _254);
                    _1003 = _985.x;
                  } else {
                    float4 _988 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_974, _975), _254);
                    _1003 = _988.x;
                  }
                } else {
                  float4 _991 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_974, _975), _254);
                  _1003 = _991.x;
                }
              } else {
                float4 _994 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_974, _975), _254);
                _1003 = _994.x;
              }
            } else {
              float4 _997 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_974, _975), _254);
              _1003 = _997.x;
            }
          } else {
            float4 _1000 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_974, _975), _254);
            _1003 = _1000.x;
          }
          float _1004 = _967 + _1003;
          float _1005 = _894 * 0.20334500074386597f;
          float _1006 = _894 * 0.6207159757614136f;
          float _1007 = _297 - _1005;
          float _1008 = _1006 + _298;
          float _1009 = max(_1007, 0.0f);
          float _1010 = max(_1008, 0.0f);
          float _1011 = min(_1009, 1.0f);
          float _1012 = min(_1010, 1.0f);
          [branch]
          if (!_318) {
            bool _1014 = (_292 == 1);
            [branch]
            if (!_1014) {
              bool _1016 = (_292 == 2);
              [branch]
              if (!_1016) {
                bool _1018 = (_292 == 3);
                [branch]
                if (!_1018) {
                  bool _1020 = (_292 == 4);
                  [branch]
                  if (!_1020) {
                    float4 _1022 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1011, _1012), _254);
                    _1040 = _1022.x;
                  } else {
                    float4 _1025 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1011, _1012), _254);
                    _1040 = _1025.x;
                  }
                } else {
                  float4 _1028 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1011, _1012), _254);
                  _1040 = _1028.x;
                }
              } else {
                float4 _1031 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1011, _1012), _254);
                _1040 = _1031.x;
              }
            } else {
              float4 _1034 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1011, _1012), _254);
              _1040 = _1034.x;
            }
          } else {
            float4 _1037 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1011, _1012), _254);
            _1040 = _1037.x;
          }
          float _1041 = _1004 + _1040;
          float _1042 = _894 * 0.9623399972915649f;
          float _1043 = _894 * 0.19498300552368164f;
          float _1044 = _1042 + _297;
          float _1045 = _298 - _1043;
          float _1046 = max(_1044, 0.0f);
          float _1047 = max(_1045, 0.0f);
          float _1048 = min(_1046, 1.0f);
          float _1049 = min(_1047, 1.0f);
          [branch]
          if (!_318) {
            bool _1051 = (_292 == 1);
            [branch]
            if (!_1051) {
              bool _1053 = (_292 == 2);
              [branch]
              if (!_1053) {
                bool _1055 = (_292 == 3);
                [branch]
                if (!_1055) {
                  bool _1057 = (_292 == 4);
                  [branch]
                  if (!_1057) {
                    float4 _1059 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1048, _1049), _254);
                    _1077 = _1059.x;
                  } else {
                    float4 _1062 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1048, _1049), _254);
                    _1077 = _1062.x;
                  }
                } else {
                  float4 _1065 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1048, _1049), _254);
                  _1077 = _1065.x;
                }
              } else {
                float4 _1068 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1048, _1049), _254);
                _1077 = _1068.x;
              }
            } else {
              float4 _1071 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1048, _1049), _254);
              _1077 = _1071.x;
            }
          } else {
            float4 _1074 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1048, _1049), _254);
            _1077 = _1074.x;
          }
          float _1078 = _1041 + _1077;
          float _1079 = _894 * 0.4734340012073517f;
          float _1080 = _894 * 0.4800260066986084f;
          float _1081 = _1079 + _297;
          float _1082 = _298 - _1080;
          float _1083 = max(_1081, 0.0f);
          float _1084 = max(_1082, 0.0f);
          float _1085 = min(_1083, 1.0f);
          float _1086 = min(_1084, 1.0f);
          [branch]
          if (!_318) {
            bool _1088 = (_292 == 1);
            [branch]
            if (!_1088) {
              bool _1090 = (_292 == 2);
              [branch]
              if (!_1090) {
                bool _1092 = (_292 == 3);
                [branch]
                if (!_1092) {
                  bool _1094 = (_292 == 4);
                  [branch]
                  if (!_1094) {
                    float4 _1096 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1085, _1086), _254);
                    _1114 = _1096.x;
                  } else {
                    float4 _1099 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1085, _1086), _254);
                    _1114 = _1099.x;
                  }
                } else {
                  float4 _1102 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1085, _1086), _254);
                  _1114 = _1102.x;
                }
              } else {
                float4 _1105 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1085, _1086), _254);
                _1114 = _1105.x;
              }
            } else {
              float4 _1108 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1085, _1086), _254);
              _1114 = _1108.x;
            }
          } else {
            float4 _1111 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1085, _1086), _254);
            _1114 = _1111.x;
          }
          float _1115 = _1078 + _1114;
          float _1116 = _894 * 0.5194560289382935f;
          float _1117 = _894 * 0.7670220136642456f;
          float _1118 = _1116 + _297;
          float _1119 = _1117 + _298;
          float _1120 = max(_1118, 0.0f);
          float _1121 = max(_1119, 0.0f);
          float _1122 = min(_1120, 1.0f);
          float _1123 = min(_1121, 1.0f);
          [branch]
          if (!_318) {
            bool _1125 = (_292 == 1);
            [branch]
            if (!_1125) {
              bool _1127 = (_292 == 2);
              [branch]
              if (!_1127) {
                bool _1129 = (_292 == 3);
                [branch]
                if (!_1129) {
                  bool _1131 = (_292 == 4);
                  [branch]
                  if (!_1131) {
                    float4 _1133 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1122, _1123), _254);
                    _1151 = _1133.x;
                  } else {
                    float4 _1136 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1122, _1123), _254);
                    _1151 = _1136.x;
                  }
                } else {
                  float4 _1139 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1122, _1123), _254);
                  _1151 = _1139.x;
                }
              } else {
                float4 _1142 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1122, _1123), _254);
                _1151 = _1142.x;
              }
            } else {
              float4 _1145 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1122, _1123), _254);
              _1151 = _1145.x;
            }
          } else {
            float4 _1148 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1122, _1123), _254);
            _1151 = _1148.x;
          }
          float _1152 = _1115 + _1151;
          float _1153 = _894 * 0.18546099960803986f;
          float _1154 = _894 * 0.893123984336853f;
          float _1155 = _1153 + _297;
          float _1156 = _298 - _1154;
          float _1157 = max(_1155, 0.0f);
          float _1158 = max(_1156, 0.0f);
          float _1159 = min(_1157, 1.0f);
          float _1160 = min(_1158, 1.0f);
          [branch]
          if (!_318) {
            bool _1162 = (_292 == 1);
            [branch]
            if (!_1162) {
              bool _1164 = (_292 == 2);
              [branch]
              if (!_1164) {
                bool _1166 = (_292 == 3);
                [branch]
                if (!_1166) {
                  bool _1168 = (_292 == 4);
                  [branch]
                  if (!_1168) {
                    float4 _1170 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1159, _1160), _254);
                    _1188 = _1170.x;
                  } else {
                    float4 _1173 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1159, _1160), _254);
                    _1188 = _1173.x;
                  }
                } else {
                  float4 _1176 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1159, _1160), _254);
                  _1188 = _1176.x;
                }
              } else {
                float4 _1179 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1159, _1160), _254);
                _1188 = _1179.x;
              }
            } else {
              float4 _1182 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1159, _1160), _254);
              _1188 = _1182.x;
            }
          } else {
            float4 _1185 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1159, _1160), _254);
            _1188 = _1185.x;
          }
          float _1189 = _1152 + _1188;
          float _1190 = _894 * 0.5074309706687927f;
          float _1191 = _894 * 0.06442499905824661f;
          float _1192 = _1190 + _297;
          float _1193 = _1191 + _298;
          float _1194 = max(_1192, 0.0f);
          float _1195 = max(_1193, 0.0f);
          float _1196 = min(_1194, 1.0f);
          float _1197 = min(_1195, 1.0f);
          [branch]
          if (!_318) {
            bool _1199 = (_292 == 1);
            [branch]
            if (!_1199) {
              bool _1201 = (_292 == 2);
              [branch]
              if (!_1201) {
                bool _1203 = (_292 == 3);
                [branch]
                if (!_1203) {
                  bool _1205 = (_292 == 4);
                  [branch]
                  if (!_1205) {
                    float4 _1207 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1196, _1197), _254);
                    _1225 = _1207.x;
                  } else {
                    float4 _1210 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1196, _1197), _254);
                    _1225 = _1210.x;
                  }
                } else {
                  float4 _1213 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1196, _1197), _254);
                  _1225 = _1213.x;
                }
              } else {
                float4 _1216 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1196, _1197), _254);
                _1225 = _1216.x;
              }
            } else {
              float4 _1219 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1196, _1197), _254);
              _1225 = _1219.x;
            }
          } else {
            float4 _1222 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1196, _1197), _254);
            _1225 = _1222.x;
          }
          float _1226 = _1189 + _1225;
          float _1227 = _894 * 0.8964200019836426f;
          float _1228 = _894 * 0.41245800256729126f;
          float _1229 = _1227 + _297;
          float _1230 = _1228 + _298;
          float _1231 = max(_1229, 0.0f);
          float _1232 = max(_1230, 0.0f);
          float _1233 = min(_1231, 1.0f);
          float _1234 = min(_1232, 1.0f);
          [branch]
          if (!_318) {
            bool _1236 = (_292 == 1);
            [branch]
            if (!_1236) {
              bool _1238 = (_292 == 2);
              [branch]
              if (!_1238) {
                bool _1240 = (_292 == 3);
                [branch]
                if (!_1240) {
                  bool _1242 = (_292 == 4);
                  [branch]
                  if (!_1242) {
                    float4 _1244 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1233, _1234), _254);
                    _1262 = _1244.x;
                  } else {
                    float4 _1247 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1233, _1234), _254);
                    _1262 = _1247.x;
                  }
                } else {
                  float4 _1250 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1233, _1234), _254);
                  _1262 = _1250.x;
                }
              } else {
                float4 _1253 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1233, _1234), _254);
                _1262 = _1253.x;
              }
            } else {
              float4 _1256 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1233, _1234), _254);
              _1262 = _1256.x;
            }
          } else {
            float4 _1259 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1233, _1234), _254);
            _1262 = _1259.x;
          }
          float _1263 = _1226 + _1262;
          float _1264 = _894 * 0.32194000482559204f;
          float _1265 = _894 * 0.9326149821281433f;
          float _1266 = _297 - _1264;
          float _1267 = _298 - _1265;
          float _1268 = max(_1266, 0.0f);
          float _1269 = max(_1267, 0.0f);
          float _1270 = min(_1268, 1.0f);
          float _1271 = min(_1269, 1.0f);
          [branch]
          if (!_318) {
            bool _1273 = (_292 == 1);
            [branch]
            if (!_1273) {
              bool _1275 = (_292 == 2);
              [branch]
              if (!_1275) {
                bool _1277 = (_292 == 3);
                [branch]
                if (!_1277) {
                  bool _1279 = (_292 == 4);
                  [branch]
                  if (!_1279) {
                    float4 _1281 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1270, _1271), _254);
                    _1299 = _1281.x;
                  } else {
                    float4 _1284 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1270, _1271), _254);
                    _1299 = _1284.x;
                  }
                } else {
                  float4 _1287 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1270, _1271), _254);
                  _1299 = _1287.x;
                }
              } else {
                float4 _1290 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1270, _1271), _254);
                _1299 = _1290.x;
              }
            } else {
              float4 _1293 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1270, _1271), _254);
              _1299 = _1293.x;
            }
          } else {
            float4 _1296 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1270, _1271), _254);
            _1299 = _1296.x;
          }
          float _1300 = _1263 + _1299;
          float _1301 = _894 * 0.7915589809417725f;
          float _1302 = _894 * 0.5977050065994263f;
          float _1303 = _297 - _1301;
          float _1304 = _298 - _1302;
          float _1305 = max(_1303, 0.0f);
          float _1306 = max(_1304, 0.0f);
          float _1307 = min(_1305, 1.0f);
          float _1308 = min(_1306, 1.0f);
          [branch]
          if (!_318) {
            bool _1310 = (_292 == 1);
            [branch]
            if (!_1310) {
              bool _1312 = (_292 == 2);
              [branch]
              if (!_1312) {
                bool _1314 = (_292 == 3);
                [branch]
                if (!_1314) {
                  bool _1316 = (_292 == 4);
                  [branch]
                  if (!_1316) {
                    float4 _1318 = g_xShadowCubeMapNegZ.SampleCmp(g_xShadowCmpSampler, float2(_1307, _1308), _254);
                    _1336 = _1318.x;
                  } else {
                    float4 _1321 = g_xShadowCubeMapPosZ.SampleCmp(g_xShadowCmpSampler, float2(_1307, _1308), _254);
                    _1336 = _1321.x;
                  }
                } else {
                  float4 _1324 = g_xShadowCubeMapNegY.SampleCmp(g_xShadowCmpSampler, float2(_1307, _1308), _254);
                  _1336 = _1324.x;
                }
              } else {
                float4 _1327 = g_xShadowCubeMapPosY.SampleCmp(g_xShadowCmpSampler, float2(_1307, _1308), _254);
                _1336 = _1327.x;
              }
            } else {
              float4 _1330 = g_xShadowCubeMapNegX.SampleCmp(g_xShadowCmpSampler, float2(_1307, _1308), _254);
              _1336 = _1330.x;
            }
          } else {
            float4 _1333 = g_xShadowCubeMapPosX.SampleCmp(g_xShadowCmpSampler, float2(_1307, _1308), _254);
            _1336 = _1333.x;
          }
          float _1337 = _1300 + _1336;
          float _1338 = _1337 * 0.0833333358168602f;
          _1340 = _1338;
        }
      } else {
        _1340 = 0.0f;
      }
      float _1341 = _1340 * _159.x;
      float _1342 = 1.0f - _1341;
      _1344 = _1342;
    } else {
      _1344 = 1.0f;
    }
    bool _1345 = (_1344 > 0.0f);
    [branch]
    if (_1345) {
      float _1347 = _234 * _138.x;
      float _1348 = _234 * _138.y;
      float _1349 = _234 * _138.z;
      bool _1350 = (_152.x == 0);
      [branch]
      if (!_1350) {
        float _1352 = _208 * _117.x;
        float _1353 = mad(_209, _117.y, _1352);
        float _1354 = mad(_210, _117.z, _1353);
        float _1355 = _208 * _121.x;
        float _1356 = mad(_209, _121.y, _1355);
        float _1357 = mad(_210, _121.z, _1356);
        float _1358 = _208 * _125.x;
        float _1359 = mad(_209, _125.y, _1358);
        float _1360 = mad(_210, _125.z, _1359);
        float4 _1361 = g_xProjCubeMap.Sample(g_xTrilinearClamp, float3(_1354, _1357, _1360));
        bool _1365 = (_154.x == 0);
        [branch]
        if (!_1365) {
          float4 _1367 = g_xProjCubeMapBlurred.Sample(g_xTrilinearClamp, float3(_1354, _1357, _1360));
          float _1371 = _207 / _136.x;
          float _1372 = _1371 * _150.x;
          float _1373 = min(_1372, 1.0f);
          float _1374 = _1367.x - _1361.x;
          float _1375 = _1367.y - _1361.y;
          float _1376 = _1367.z - _1361.z;
          float _1377 = _1373 * _1374;
          float _1378 = _1373 * _1375;
          float _1379 = _1373 * _1376;
          float _1380 = _1377 + _1361.x;
          float _1381 = _1378 + _1361.y;
          float _1382 = _1379 + _1361.z;
          _1384 = _1380;
          _1385 = _1381;
          _1386 = _1382;
        } else {
          _1384 = _1361.x;
          _1385 = _1361.y;
          _1386 = _1361.z;
        }
        float _1387 = _1384 * _1347;
        float _1388 = _1385 * _1348;
        float _1389 = _1386 * _1349;
        _1391 = _1387;
        _1392 = _1388;
        _1393 = _1389;
      } else {
        _1391 = _1347;
        _1392 = _1348;
        _1393 = _1349;
      }
      float _1394 = g_xCamPos.x - _69;
      float _1395 = g_xCamPos.y - _73;
      float _1396 = g_xCamPos.z - _77;
      float _1397 = dot(float3(_1394, _1395, _1396), float3(_1394, _1395, _1396));
      float _1398 = rsqrt(_1397);
      float _1399 = _1398 * _1394;
      float _1400 = _1398 * _1395;
      float _1401 = _1398 * _1396;
      bool _1402 = (_133.x > 0.0f);
      [branch]
      if (_1402) {
        float _1404 = dot(float3(_1399, _1400, _1401), float3(_101, _102, _103));
        float _1405 = _1404 * 2.0f;
        float _1406 = _1405 * _101;
        float _1407 = _1405 * _102;
        float _1408 = _1405 * _103;
        float _1409 = _1399 - _1406;
        float _1410 = _1400 - _1407;
        float _1411 = _1401 - _1408;
        float _1412 = -0.0f - _1409;
        float _1413 = -0.0f - _1410;
        float _1414 = -0.0f - _1411;
        float _1415 = dot(float3(_199, _200, _201), float3(_1412, _1413, _1414));
        float _1416 = _1415 * _1412;
        float _1417 = _1415 * _1413;
        float _1418 = _1415 * _1414;
        float _1419 = _1416 - _199;
        float _1420 = _1417 - _200;
        float _1421 = _1418 - _201;
        float _1422 = _1419 * _1419;
        float _1423 = _1420 * _1420;
        float _1424 = _1422 + _1423;
        float _1425 = _1421 * _1421;
        float _1426 = _1424 + _1425;
        float _1427 = sqrt(_1426);
        float _1428 = _133.x / _1427;
        float _1429 = saturate(_1428);
        float _1430 = _1419 * _1429;
        float _1431 = _1420 * _1429;
        float _1432 = _1421 * _1429;
        float _1433 = _1430 + _199;
        float _1434 = _1431 + _200;
        float _1435 = _1432 + _201;
        float _1436 = dot(float3(_1433, _1434, _1435), float3(_1433, _1434, _1435));
        float _1437 = rsqrt(_1436);
        float _1438 = _1433 * _1437;
        float _1439 = _1434 * _1437;
        float _1440 = _1435 * _1437;
        float _1441 = dot(float3(_199, _200, _201), float3(_199, _200, _201));
        float _1442 = rsqrt(_1441);
        float _1443 = _1442 * _133.x;
        _1445 = _1438;
        _1446 = _1439;
        _1447 = _1440;
        _1448 = _1443;
      } else {
        _1445 = _208;
        _1446 = _209;
        _1447 = _210;
        _1448 = 0.0f;
      }
      // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
      bool _1449 = (!MaterialIdEquals(_83.w, 0.019607843831181526f));
      float _1450 = select(_1449, _88.x, 0.0f);
      float _1451 = _1445 + _1399;
      float _1452 = _1446 + _1400;
      float _1453 = _1447 + _1401;
      float _1454 = dot(float3(_1451, _1452, _1453), float3(_1451, _1452, _1453));
      float _1455 = rsqrt(_1454);
      float _1456 = _1455 * _1451;
      float _1457 = _1455 * _1452;
      float _1458 = _1455 * _1453;
      float _1459 = dot(float3(_101, _102, _103), float3(_1399, _1400, _1401));
      float _1460 = saturate(_1459);
      float _1461 = dot(float3(_101, _102, _103), float3(_1456, _1457, _1458));
      float _1462 = saturate(_1461);
      float _1463 = dot(float3(_1399, _1400, _1401), float3(_1456, _1457, _1458));
      float _1464 = saturate(_1463);
      bool _1465 = (MaterialIdEquals(_83.w, 0.01568627543747425f));
      [branch]
      if (!_1465) {
        bool _1467 = (MaterialIdEquals(_83.w, 0.007843137718737125f));
        [branch]
        if (!_1467) {
          bool _1469 = (MaterialIdEquals(_83.w, 0.003921568859368563f));
          [branch]
          if (_1469) {
            float _1471 = -0.0f - _101;
            float _1472 = -0.0f - _102;
            float _1473 = -0.0f - _103;
            float _1474 = dot(float3(_208, _209, _210), float3(_1471, _1472, _1473));
            float _1475 = saturate(_1474);
            float _1476 = _1475 * 0.4000000059604645f;
            float _1477 = -0.0f - _1399;
            float _1478 = -0.0f - _1400;
            float _1479 = -0.0f - _1401;
            float _1480 = dot(float3(_208, _209, _210), float3(_1477, _1478, _1479));
            float _1481 = saturate(_1480);
            float _1482 = log2(_1481);
            float _1483 = _1482 * 7.0f;
            float _1484 = exp2(_1483);
            float _1485 = _1484 + _1476;
            float _1486 = saturate(_1485);
            float _1487 = _1486 * _1450;
            float _1488 = _1487 + _238;
            _1506 = _83.x;
            _1507 = _83.y;
            _1508 = _83.z;
            _1509 = 0.02800000086426735f;
            _1510 = 0.02800000086426735f;
            _1511 = 0.02800000086426735f;
            _1512 = _1488;
          } else {
            float _1490 = _83.x + -0.03999999910593033f;
            float _1491 = _83.y + -0.03999999910593033f;
            float _1492 = _83.z + -0.03999999910593033f;
            float _1493 = _1450 * _1490;
            float _1494 = _1450 * _1491;
            float _1495 = _1450 * _1492;
            float _1496 = _1493 + 0.03999999910593033f;
            float _1497 = _1494 + 0.03999999910593033f;
            float _1498 = _1495 + 0.03999999910593033f;
            float _1499 = _1450 * _83.x;
            float _1500 = _1450 * _83.y;
            float _1501 = _1450 * _83.z;
            float _1502 = _83.x - _1499;
            float _1503 = _83.y - _1500;
            float _1504 = _83.z - _1501;
            _1506 = _1502;
            _1507 = _1503;
            _1508 = _1504;
            _1509 = _1496;
            _1510 = _1497;
            _1511 = _1498;
            _1512 = _238;
          }
        } else {
          _1506 = _83.x;
          _1507 = _83.y;
          _1508 = _83.z;
          _1509 = 0.02800000086426735f;
          _1510 = 0.02800000086426735f;
          _1511 = 0.02800000086426735f;
          _1512 = _238;
        }
      } else {
        _1506 = _83.x;
        _1507 = _83.y;
        _1508 = _83.z;
        _1509 = 0.04699999839067459f;
        _1510 = 0.04699999839067459f;
        _1511 = 0.04699999839067459f;
        _1512 = _238;
      }
      float _1513 = _1512 * _1506;
      float _1514 = _1512 * _1507;
      float _1515 = _1512 * _1508;
      float _1516 = max(_88.y, 0.05000000074505806f);
      float _1517 = _1516 * _1516;
      [branch]
      if (_1465) {
        float _1519 = 1.0f - _88.y;
        float _1520 = saturate(_1519);
        float _1521 = dot(float3(_83.x, _83.y, _83.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
        float _1522 = _88.x * 0.6000000238418579f;
        float _1523 = _1522 + -0.3500000238418579f;
        float _1524 = _1522 + -0.25f;
        float _1525 = _1520 * 0.05000000074505806f;
        float _1526 = _1524 - _1525;
        float _1527 = log2(_1520);
        float _1528 = _1527 * 8.0f;
        float _1529 = exp2(_1528);
        float _1530 = _1529 * 500.0f;
        float _1531 = _1530 + 20.0f;
        float _1532 = _1527 * 6.0f;
        float _1533 = exp2(_1532);
        float _1534 = _1533 * 2000.0f;
        float _1535 = _1534 + 50.0f;
        float _1536 = _88.x * 0.13500000536441803f;
        float _1537 = _1536 + 0.015000000596046448f;
        float _1538 = _1520 + 0.10000000149011612f;
        float _1539 = _88.x * 0.007499999832361937f;
        float _1540 = _1539 + 0.007499999832361937f;
        float _1541 = _101 * _1523;
        float _1542 = _102 * _1523;
        float _1543 = _103 * _1523;
        float _1544 = _1541 + _106;
        float _1545 = _1542 + _107;
        float _1546 = _114 + _1543;
        float _1547 = dot(float3(_1544, _1545, _1546), float3(_1544, _1545, _1546));
        float _1548 = rsqrt(_1547);
        float _1549 = _1548 * _1544;
        float _1550 = _1548 * _1545;
        float _1551 = _1548 * _1546;
        float _1552 = dot(float3(_1549, _1550, _1551), float3(_1456, _1457, _1458));
        float _1553 = _1552 * _1552;
        float _1554 = 1.0f - _1553;
        float _1555 = saturate(_1554);
        float _1556 = sqrt(_1555);
        float _1557 = _1552 + 1.0f;
        float _1558 = saturate(_1557);
        float _1559 = _1558 * 2.0f;
        float _1560 = 3.0f - _1559;
        float _1561 = log2(_1556);
        float _1562 = _1561 * _1531;
        float _1563 = exp2(_1562);
        float _1564 = _1529 * 19.89436912536621f;
        float _1565 = _1564 + 1.1140847206115723f;
        float _1566 = _1538 * _1537;
        float _1567 = _1566 * _1565;
        float _1568 = _1558 * _1558;
        float _1569 = _1568 * _1567;
        float _1570 = _1569 * _1560;
        float _1571 = _1570 * _1563;
        float _1572 = max(_1521, 0.0010000000474974513f);
        float _1573 = _83.x / _1572;
        float _1574 = _83.y / _1572;
        float _1575 = _83.z / _1572;
        float _1576 = _1571 * _1573;
        float _1577 = _1571 * _1574;
        float _1578 = _1571 * _1575;
        float _1579 = _1526 * _101;
        float _1580 = _1526 * _102;
        float _1581 = _1526 * _103;
        float _1582 = _1579 + _106;
        float _1583 = _1580 + _107;
        float _1584 = _1581 + _114;
        float _1585 = dot(float3(_1582, _1583, _1584), float3(_1582, _1583, _1584));
        float _1586 = rsqrt(_1585);
        float _1587 = _1586 * _1582;
        float _1588 = _1586 * _1583;
        float _1589 = _1586 * _1584;
        float _1590 = dot(float3(_1587, _1588, _1589), float3(_1456, _1457, _1458));
        float _1591 = _1590 * _1590;
        float _1592 = 1.0f - _1591;
        float _1593 = saturate(_1592);
        float _1594 = sqrt(_1593);
        float _1595 = _1590 + 1.0f;
        float _1596 = saturate(_1595);
        float _1597 = _1596 * 2.0f;
        float _1598 = 3.0f - _1597;
        float _1599 = log2(_1594);
        float _1600 = _1599 * _1535;
        float _1601 = exp2(_1600);
        float _1602 = _1533 * 79.57747650146484f;
        float _1603 = _1602 + 2.3077468872070312f;
        float _1604 = _1520 * _1540;
        float _1605 = _1604 * _1603;
        float _1606 = _1596 * _1596;
        float _1607 = _1606 * _1605;
        float _1608 = _1607 * _1598;
        float _1609 = _1608 * _1601;
        float _1610 = _1609 + _1576;
        float _1611 = _1609 + _1577;
        float _1612 = _1609 + _1578;
        float _1613 = _238 * _169.x;
        float _1614 = _1613 * _1610;
        float _1615 = _1613 * _1611;
        float _1616 = _1613 * _1612;
        _1671 = _1614;
        _1672 = _1615;
        _1673 = _1616;
      } else {
        float _1618 = 1.0f - _1517;
        float _1619 = _1618 * _1448;
        float _1620 = saturate(_1619);
        float _1621 = 1.0f - _1509;
        float _1622 = 1.0f - _1510;
        float _1623 = 1.0f - _1511;
        float _1624 = _1464 * 5.55472993850708f;
        float _1625 = -6.983160018920898f - _1624;
        float _1626 = _1625 * _1464;
        float _1627 = exp2(_1626);
        float _1628 = _1627 * _1621;
        float _1629 = _1627 * _1622;
        float _1630 = _1627 * _1623;
        float _1631 = _1628 + _1509;
        float _1632 = _1629 + _1510;
        float _1633 = _1630 + _1511;
        bool _1634 = (_1620 > 0.0f);
        float _1635 = _1517 * _1517;
        [branch]
        if (_1634) {
          float _1637 = _1620 * 0.25f;
          float _1638 = _1517 * 3.0f;
          float _1639 = _1620 + _1638;
          float _1640 = _1637 * _1639;
          float _1641 = _1464 + 0.0010000000474974513f;
          float _1642 = _1640 / _1641;
          float _1643 = _1642 + _1635;
          float _1644 = _1635 / _1643;
          _1646 = _1644;
        } else {
          _1646 = 1.0f;
        }
        float _1647 = 2.0f - _1517;
        float _1648 = _1647 * _1460;
        float _1649 = _1648 + _1517;
        float _1650 = _1647 * _238;
        float _1651 = _1650 + _1517;
        float _1652 = _1649 * _1651;
        float _1653 = 1.0f / _1652;
        float _1654 = _1635 * _1462;
        float _1655 = _1654 - _1462;
        float _1656 = _1655 * _1462;
        float _1657 = _1656 + 1.0f;
        float _1658 = _1657 * _1657;
        float _1659 = 1.0f / _1658;
        float _1660 = _238 * _169.x;
        float _1661 = _1660 * _1635;
        float _1662 = _1661 * _1653;
        float _1663 = _1662 * _1659;
        float _1664 = _1646 * _1631;
        float _1665 = _1664 * _1663;
        float _1666 = _1646 * _1632;
        float _1667 = _1666 * _1663;
        float _1668 = _1646 * _1633;
        float _1669 = _1668 * _1663;
        _1671 = _1665;
        _1672 = _1667;
        _1673 = _1669;
      }
      float _1674 = _1671 + _1513;
      float _1675 = _1672 + _1514;
      float _1676 = _1673 + _1515;
      bool _1677 = (MaterialIdEquals(_83.w, 0.019607843831181526f));
      [branch]
      if (_1677) {
        bool _1679 = (_88.x > 0.49803921580314636f);
        float _1680 = _88.x + -0.501960813999176f;
        float _1681 = select(_1679, _1680, _88.x);
        float _1682 = _1681 * 2.007874011993408f;
        float _1683 = select(_1679, 0.5f, 0.0f);
        float _1684 = -0.0f - _101;
        float _1685 = -0.0f - _102;
        float _1686 = -0.0f - _103;
        float _1687 = dot(float3(_208, _209, _210), float3(_1684, _1685, _1686));
        float _1688 = saturate(_1687);
        float _1689 = _1688 * 0.4000000059604645f;
        float _1690 = -0.0f - _1399;
        float _1691 = -0.0f - _1400;
        float _1692 = -0.0f - _1401;
        float _1693 = dot(float3(_208, _209, _210), float3(_1690, _1691, _1692));
        float _1694 = saturate(_1693);
        float _1695 = log2(_1694);
        float _1696 = _1695 * 7.0f;
        float _1697 = exp2(_1696);
        float _1698 = _1697 + _1689;
        float _1699 = saturate(_1698);
        float _1700 = _1699 * _1683;
        float _1701 = _1700 * _1506;
        float _1702 = _1700 * _1507;
        float _1703 = _1700 * _1508;
        float _1704 = abs(_1506);
        float _1705 = abs(_1507);
        float _1706 = abs(_1508);
        float _1707 = sqrt(_1704);
        float _1708 = sqrt(_1705);
        float _1709 = sqrt(_1706);
        float _1710 = 1.0f - _1707;
        float _1711 = 1.0f - _1708;
        float _1712 = 1.0f - _1709;
        float _1713 = _1464 * 5.55472993850708f;
        float _1714 = -6.983160018920898f - _1713;
        float _1715 = _1714 * _1464;
        float _1716 = exp2(_1715);
        float _1717 = _1716 * _1710;
        float _1718 = _1716 * _1711;
        float _1719 = _1712 * _1716;
        float _1720 = _1717 + _1707;
        float _1721 = _1718 + _1708;
        float _1722 = _1719 + _1709;
        float _1723 = _1460 + _238;
        float _1724 = _1460 * _238;
        float _1725 = _1723 - _1724;
        float _1726 = _1725 * 4.0f;
        float _1727 = _1726 + 9.999999682655225e-21f;
        float _1728 = 1.0f / _1727;
        float _1729 = 0.5f / _1517;
        float _1730 = _1462 * _1462;
        float _1731 = 1.0f - _1730;
        float _1732 = _1729 + 1.0f;
        float _1733 = log2(_1731);
        float _1734 = _1733 * _1729;
        float _1735 = exp2(_1734);
        float _1736 = _1732 * _1728;
        float _1737 = _1736 * _1735;
        float _1738 = _238 * _169.x;
        float _1739 = _1720 * _1738;
        float _1740 = _1739 * _1737;
        float _1741 = _1721 * _1738;
        float _1742 = _1741 * _1737;
        float _1743 = _1722 * _1738;
        float _1744 = _1743 * _1737;
        float _1745 = _1701 - _1671;
        float _1746 = _1745 + _1740;
        float _1747 = _1702 - _1672;
        float _1748 = _1747 + _1742;
        float _1749 = _1703 - _1673;
        float _1750 = _1749 + _1744;
        float _1751 = _1746 * _1682;
        float _1752 = _1748 * _1682;
        float _1753 = _1750 * _1682;
        float _1754 = _1751 + _1674;
        float _1755 = _1752 + _1675;
        float _1756 = _1753 + _1676;
        _1758 = _1754;
        _1759 = _1755;
        _1760 = _1756;
      } else {
        _1758 = _1674;
        _1759 = _1675;
        _1760 = _1676;
      }
      float _1761 = _1758 * _1391;
      float _1762 = _1759 * _1392;
      float _1763 = _1760 * _1393;
      float _1764 = min(_1761, 1000.0f);
      float _1765 = min(_1762, 1000.0f);
      float _1766 = min(_1763, 1000.0f);
      bool _1767 = (MaterialIdEquals(_83.w, 0.007843137718737125f));
      [branch]
      if (_1767) {
        float _1769 = _83.x * 0.019444789737462997f;
        float _1770 = _83.y * 1.680522836977616e-05f;
        float _1771 = _83.z * 3.190706726607928e-11f;
        float _1772 = -0.0f - _101;
        float _1773 = -0.0f - _102;
        float _1774 = -0.0f - _103;
        float _1775 = dot(float3(_208, _209, _210), float3(_1772, _1773, _1774));
        float _1776 = _1775 + 0.30000001192092896f;
        float _1777 = saturate(_1776);
        float _1778 = _1769 * _1391;
        float _1779 = _1778 * _1777;
        float _1780 = _1770 * _1392;
        float _1781 = _1780 * _1777;
        float _1782 = _1771 * _1393;
        float _1783 = _1782 * _1777;
        float _1784 = _1779 + _1764;
        float _1785 = _1781 + _1765;
        float _1786 = _1783 + _1766;
        _1788 = _1784;
        _1789 = _1785;
        _1790 = _1786;
      } else {
        _1788 = _1764;
        _1789 = _1765;
        _1790 = _1766;
      }
      bool _1791 = (_31 < 3.0f);
      bool _1792 = _1791 && _1767;
      [branch]
      if (_1792) {
        float _1794 = _31 + -2.0f;
        float _1795 = max(_1794, 0.0f);
        float _1800 = 1.0f - g_xSubsurfaceScatteringWeight.x;
        float _1801 = 1.0f - g_xSubsurfaceScatteringWeight.y;
        float _1802 = 1.0f - g_xSubsurfaceScatteringWeight.z;
        float _1803 = _1800 * _1795;
        float _1804 = _1801 * _1795;
        float _1805 = _1802 * _1795;
        float _1806 = _1803 + g_xSubsurfaceScatteringWeight.x;
        float _1807 = _1804 + g_xSubsurfaceScatteringWeight.y;
        float _1808 = _1805 + g_xSubsurfaceScatteringWeight.z;
        float _1809 = _1806 * _1788;
        float _1810 = _1807 * _1789;
        float _1811 = _1808 * _1790;
        _1813 = true;
        _1814 = _1809;
        _1815 = _1810;
        _1816 = _1811;
        _1817 = _1344;
      } else {
        _1813 = true;
        _1814 = _1788;
        _1815 = _1789;
        _1816 = _1790;
        _1817 = _1344;
      }
    } else {
      _1813 = false;
      _1814 = 0.0f;
      _1815 = 0.0f;
      _1816 = 0.0f;
      _1817 = _1344;
    }
  } else {
    _1813 = false;
    _1814 = 0.0f;
    _1815 = 0.0f;
    _1816 = 0.0f;
    _1817 = 1.0f;
  }
  [branch]
  if (!_1813) {
    if (true) discard;
  }
  SV_Target.x = _1814;
  SV_Target.y = _1815;
  SV_Target.z = _1816;
  SV_Target.w = _1817;
  return SV_Target;
}
