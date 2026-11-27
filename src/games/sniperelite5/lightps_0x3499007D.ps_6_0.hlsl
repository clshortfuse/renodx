#include "./shared.h"
// Baseline: 4 fewer fmul fast (dxc reassociation of two specular chains: (P*A)*chain -> (P*chain)*A), phi order/undef-vs-0 phis, otherwise identical to the original DXIL.

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

SamplerState g_xTrilinearWrap : register(s4);

SamplerState g_xTrilinearClamp : register(s5);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float3 CamDir : CamDir
) : SV_Target {
  float4 SV_Target;
  int _15 = int(SV_Position.x);
  int _16 = int(SV_Position.y);
  float4 _17 = g_xLighting_DepthStencil.Load(int3(_15, _16, 0));
  float _23 = g_xDepthProjViewUnpack.x / (g_xDepthProjViewUnpack.y - _17.x);
  float _40 = (g_xCameraTanHalfFOV.x * _23) * (((g_xTwoOverScreenDimensions.z + SV_Position.x) * g_xTwoOverScreenDimensions.x) + -1.0f);
  float _41 = (g_xCameraTanHalfFOV.y * _23) * (((g_xTwoOverScreenDimensions.w + SV_Position.y) * g_xTwoOverScreenDimensions.y) + -1.0f);
  ProjectorParams P = g_axProjectors[g_uProjectorIndex];
  float4 _44 = P.m_xProjectorMatrix[0];
  float4 _47 = P.m_xProjectorMatrix[1];
  float4 _50 = P.m_xProjectorMatrix[2];
  float4 _53 = P.m_xProjectorMatrix[3];
  float3 _56 = P.m_xProjectionDirection.xyz;
  float4 _60 = P.m_xDetailOffsetScale;
  float3 _65 = P.m_xProjectorPos;
  float3 _69 = P.m_xLightColour;
  float _73 = P.m_fDistanceFade;
  float _75 = P.m_fLightFalloffScale;
  float _77 = P.m_fLightFalloffPower;
  float _79 = P.m_fMinRange;
  float _81 = P.m_fLightRange;
  int _83 = P.m_bCustomBoundingVolumeSet;
  float _85 = P.m_fSpecularStrength;
  float _87 = P.m_fAreaLightRadius;
  int _89 = P.m_iTextureIndex;
  int _91 = P.m_iDetailTextureIndex;
  float4 _93 = g_xLighting_NormalBuffer.Load(int3(_15, _16, 0));
  float4 _98 = g_xLighting_AlbedoBuffer.Load(int3(_15, _16, 0));
  float4 _103 = g_xLighting_PBRPropertiesBuffer.Load(int3(_15, _16, 0));
  float _111 = (_93.x * 2.0f) + -1.0f;
  float _112 = (_93.y * 2.0f) + -1.0f;
  float _113 = (_93.z * 2.0f) + -1.0f;
  float _115 = rsqrt(dot(float3(_111, _112, _113), float3(_111, _112, _113)));
  float _116 = _115 * _111;
  float _117 = _115 * _112;
  float _118 = _115 * _113;
  float _121 = (_103.z * 2.0f) + -1.0f;
  float _122 = (_103.w * 2.0f) + -1.0f;
  float _126 = sqrt(saturate(1.0f - dot(float2(_121, _122), float2(_121, _122))));
  float _129 = select((_93.w != 0.0f), _126, (-0.0f - _126));
  float _131 = rsqrt(dot(float3(CamDir.x, CamDir.y, CamDir.z), float3(CamDir.x, CamDir.y, CamDir.z)));
  float _132 = _131 * CamDir.x;
  float _133 = _131 * CamDir.y;
  float _134 = _131 * CamDir.z;
  float _142 = mad(_50.w, _23, mad(_47.w, _41, (_44.w * _40))) + _53.w;
  bool _174;
  float _175;
  float _176;
  float _249;
  float _250;
  float _251;
  float _268;
  float _269;
  float _270;
  float _320;
  float _321;
  float _322;
  float _323;
  float _383;
  float _384;
  float _385;
  float _386;
  float _387;
  float _388;
  float _389;
  float _523;
  float _548;
  float _549;
  float _550;
  float _635;
  float _636;
  float _637;
  bool _667;
  float _668;
  float _669;
  float _670;
  [branch]
  if (!((mad(_50.z, _23, mad(_47.z, _41, (_44.z * _40))) + _53.z) < 0.0f)) {
    float _161 = (mad(_50.x, _23, mad(_47.x, _41, (_44.x * _40))) + _53.x) / _142;
    float _162 = (mad(_50.y, _23, mad(_47.y, _41, (_44.y * _40))) + _53.y) / _142;
    [branch]
    if (!(((0.5f - abs(_161 + -0.5f)) < 0.0f) | ((0.5f - abs(_162 + -0.5f)) < 0.0f))) {
      _174 = true;
      _175 = _161;
      _176 = _162;
    } else {
      _174 = false;
      _175 = _161;
      _176 = _162;
    }
  } else {
    _174 = false;
    _175 = 0.0f;
    _176 = 0.0f;
  }
  [branch]
  if (_174) {
    float _204 = (_65.x - (g_xInvView[3].x)) - mad((g_xInvView[2].x), _23, mad((g_xInvView[1].x), _41, ((g_xInvView[0].x) * _40)));
    float _206 = (_65.y - (g_xInvView[3].y)) - mad((g_xInvView[2].y), _23, mad((g_xInvView[1].y), _41, ((g_xInvView[0].y) * _40)));
    float _208 = (_65.z - (g_xInvView[3].z)) - mad((g_xInvView[2].z), _23, mad((g_xInvView[1].z), _41, ((g_xInvView[0].z) * _40)));
    do {
      [branch]
      if (!(_83.x == 0)) {
        float _212 = -0.0f - dot(float3(_204, _206, _208), float3(_56.x, _56.y, _56.z));
        [branch]
        if (((_79 > _212)) | ((_81 < _212))) {
          _667 = false;
          _668 = 0.0f;
          _669 = 0.0f;
          _670 = 0.0f;
          break;
        }
      }
      float _222 = sqrt(((_206 * _206) + (_204 * _204)) + (_208 * _208));
      float _223 = _204 / _222;
      float _224 = _206 / _222;
      float _225 = _208 / _222;
      float _236 = exp2(log2(saturate((1.0f - saturate((_222 - _87.x) / (_81 - _87.x))) * _75.x)) * _77.x) * _73.x;
      [branch]
      if (!((_236 + -9.999999747378752e-05f) < 0.0f)) {
        do {
          [branch]
          if ((int)_89.x > (int)0) {
            float4 _244 = g_xTextureArray[NonUniformResourceIndex(_89)].SampleLevel(g_xTrilinearClamp, float2(_175, _176), 0.0f);
            _249 = _244.x;
            _250 = _244.y;
            _251 = _244.z;
          } else {
            _249 = 1.0f;
            _250 = 1.0f;
            _251 = 1.0f;
          }
          do {
            [branch]
            if ((int)_91.x > (int)0) {
              float4 _260 = g_xTextureArray[NonUniformResourceIndex(_91)].SampleLevel(g_xTrilinearWrap, float2(((_175 * _60.z) + _60.x), ((_176 * _60.w) + _60.y)), 0.0f);
              _268 = (_260.x * _249);
              _269 = (_260.y * _250);
              _270 = (_260.z * _251);
            } else {
              _268 = _249;
              _269 = _250;
              _270 = _251;
            }
            do {
              [branch]
              if (_87.x > 0.0f) {
                float _280 = dot(float3(_132, _133, _134), float3(_116, _117, _118)) * 2.0f;
                float _287 = -0.0f - (_132 - (_280 * _116));
                float _288 = -0.0f - (_133 - (_280 * _117));
                float _289 = -0.0f - (_134 - (_280 * _118));
                float _290 = dot(float3(_204, _206, _208), float3(_287, _288, _289));
                float _294 = (_290 * _287) - _204;
                float _295 = (_290 * _288) - _206;
                float _296 = (_290 * _289) - _208;
                float _304 = saturate(_87.x / sqrt(((_294 * _294) + (_295 * _295)) + (_296 * _296)));
                float _308 = (_294 * _304) + _204;
                float _309 = (_295 * _304) + _206;
                float _310 = (_296 * _304) + _208;
                float _312 = rsqrt(dot(float3(_308, _309, _310), float3(_308, _309, _310)));
                _320 = (_308 * _312);
                _321 = (_309 * _312);
                _322 = (_310 * _312);
                _323 = (rsqrt(dot(float3(_204, _206, _208), float3(_204, _206, _208))) * _87.x);
              } else {
                _320 = _223;
                _321 = _224;
                _322 = _225;
                _323 = 0.0f;
              }
              // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
              float _325 = select((!MaterialIdEquals(_98.w, 0.019607843831181526f)), _103.x, 0.0f);
              float _326 = _320 + _132;
              float _327 = _321 + _133;
              float _328 = _322 + _134;
              float _330 = rsqrt(dot(float3(_326, _327, _328), float3(_326, _327, _328)));
              float _331 = _330 * _326;
              float _332 = _330 * _327;
              float _333 = _330 * _328;
              float _335 = saturate(dot(float3(_116, _117, _118), float3(_223, _224, _225)));
              float _337 = saturate(dot(float3(_116, _117, _118), float3(_132, _133, _134)));
              float _339 = saturate(dot(float3(_116, _117, _118), float3(_331, _332, _333)));
              float _341 = saturate(dot(float3(_132, _133, _134), float3(_331, _332, _333)));
              bool _342 = MaterialIdEquals(_98.w, 0.01568627543747425f);
              do {
                [branch]
                if (!_342) {
                  [branch]
                  if (!MaterialIdEquals(_98.w, 0.007843137718737125f)) {
                    [branch]
                    if (MaterialIdEquals(_98.w, 0.003921568859368563f)) {
                      _383 = _98.x;
                      _384 = _98.y;
                      _385 = _98.z;
                      _386 = 0.02800000086426735f;
                      _387 = 0.02800000086426735f;
                      _388 = 0.02800000086426735f;
                      _389 = ((saturate(exp2(log2(saturate(dot(float3(_223, _224, _225), float3((-0.0f - _132), (-0.0f - _133), (-0.0f - _134))))) * 7.0f) + (saturate(dot(float3(_223, _224, _225), float3((-0.0f - _116), (-0.0f - _117), (-0.0f - _118)))) * 0.4000000059604645f)) * _325) + _335);
                    } else {
                      _383 = (_98.x - (_325 * _98.x));
                      _384 = (_98.y - (_325 * _98.y));
                      _385 = (_98.z - (_325 * _98.z));
                      _386 = ((_325 * (_98.x + -0.03999999910593033f)) + 0.03999999910593033f);
                      _387 = ((_325 * (_98.y + -0.03999999910593033f)) + 0.03999999910593033f);
                      _388 = ((_325 * (_98.z + -0.03999999910593033f)) + 0.03999999910593033f);
                      _389 = _335;
                    }
                  } else {
                    _383 = _98.x;
                    _384 = _98.y;
                    _385 = _98.z;
                    _386 = 0.02800000086426735f;
                    _387 = 0.02800000086426735f;
                    _388 = 0.02800000086426735f;
                    _389 = _335;
                  }
                } else {
                  _383 = _98.x;
                  _384 = _98.y;
                  _385 = _98.z;
                  _386 = 0.04699999839067459f;
                  _387 = 0.04699999839067459f;
                  _388 = 0.04699999839067459f;
                  _389 = _335;
                }
                float _393 = max(_103.y, 0.05000000074505806f);
                float _394 = _393 * _393;
                do {
                  [branch]
                  if (_342) {
                    float _397 = saturate(1.0f - _103.y);
                    float _399 = _103.x * 0.6000000238418579f;
                    float _400 = _399 + -0.3500000238418579f;
                    float _403 = (_399 + -0.25f) - (_397 * 0.05000000074505806f);
                    float _404 = log2(_397);
                    float _406 = exp2(_404 * 8.0f);
                    float _410 = exp2(_404 * 6.0f);
                    float _421 = (_400 * _116) + _121;
                    float _422 = (_400 * _117) + _122;
                    float _423 = _129 + (_400 * _118);
                    float _425 = rsqrt(dot(float3(_421, _422, _423), float3(_421, _422, _423)));
                    float _429 = dot(float3((_425 * _421), (_425 * _422), (_425 * _423)), float3(_331, _332, _333));
                    float _435 = saturate(_429 + 1.0f);
                    float _448 = (((_435 * _435) * (((_397 + 0.10000000149011612f) * ((_103.x * 0.13500000536441803f) + 0.015000000596046448f)) * ((_406 * 19.89436912536621f) + 1.1140847206115723f))) * (3.0f - (_435 * 2.0f))) * exp2(log2(sqrt(saturate(1.0f - (_429 * _429)))) * ((_406 * 500.0f) + 20.0f));
                    float _449 = max(dot(float3(_98.x, _98.y, _98.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)), 0.0010000000474974513f);
                    float _459 = (_403 * _116) + _121;
                    float _460 = (_403 * _117) + _122;
                    float _461 = (_403 * _118) + _129;
                    float _463 = rsqrt(dot(float3(_459, _460, _461), float3(_459, _460, _461)));
                    float _467 = dot(float3((_463 * _459), (_463 * _460), (_463 * _461)), float3(_331, _332, _333));
                    float _473 = saturate(_467 + 1.0f);
                    float _486 = (((_473 * _473) * ((_397 * ((_103.x * 0.007499999832361937f) + 0.007499999832361937f)) * ((_410 * 79.57747650146484f) + 2.3077468872070312f))) * (3.0f - (_473 * 2.0f))) * exp2(log2(sqrt(saturate(1.0f - (_467 * _467)))) * ((_410 * 2000.0f) + 50.0f));
                    float _490 = _335 * _85.x;
                    _548 = (_490 * (_486 + (_448 * (_98.x / _449))));
                    _549 = (_490 * (_486 + (_448 * (_98.y / _449))));
                    _550 = (_490 * (_486 + (_448 * (_98.z / _449))));
                  } else {
                    float _497 = saturate((1.0f - _394) * _323);
                    float _504 = exp2((-6.983160018920898f - (_341 * 5.55472993850708f)) * _341);
                    float _512 = _394 * _394;
                    float _508 = (_504 * (1.0f - _386)) + _386;
                    float _509 = (_504 * (1.0f - _387)) + _387;
                    float _510 = (_504 * (1.0f - _388)) + _388;
                    do {
                      [branch]
                      if (_497 > 0.0f) {
                        _523 = (_512 / ((((_497 * 0.25f) * (_497 + (_394 * 3.0f))) / (_341 + 0.0010000000474974513f)) + _512));
                      } else {
                        _523 = 1.0f;
                      }
                      float _524 = 2.0f - _394;
                      float _534 = (((_512 * _339) - _339) * _339) + 1.0f;
                      float _540 = (((_335 * _85.x) * _512) * (1.0f / (((_524 * _337) + _394) * ((_524 * _335) + _394)))) * (1.0f / (_534 * _534));
                      _548 = ((_523 * _508) * _540);
                      _549 = ((_523 * _509) * _540);
                      _550 = ((_523 * _510) * _540);
                    } while (false);
                  }
                  float _551 = _548 + (_389 * _383);
                  float _552 = _549 + (_389 * _384);
                  float _553 = _550 + (_389 * _385);
                  do {
                    [branch]
                    if (MaterialIdEquals(_98.w, 0.019607843831181526f)) {
                      bool _556 = (_103.x > 0.49803921580314636f);
                      float _559 = select(_556, (_103.x + -0.501960813999176f), _103.x) * 2.007874011993408f;
                      float _577 = saturate(exp2(log2(saturate(dot(float3(_223, _224, _225), float3((-0.0f - _132), (-0.0f - _133), (-0.0f - _134))))) * 7.0f) + (saturate(dot(float3(_223, _224, _225), float3((-0.0f - _116), (-0.0f - _117), (-0.0f - _118)))) * 0.4000000059604645f)) * select(_556, 0.5f, 0.0f);
                      float _584 = sqrt(abs(_383));
                      float _585 = sqrt(abs(_384));
                      float _586 = sqrt(abs(_385));
                      float _593 = exp2((-6.983160018920898f - (_341 * 5.55472993850708f)) * _341);
                      float _606 = 0.5f / _394;
                      float _614 = ((_606 + 1.0f) * (1.0f / ((((_337 + _335) - (_337 * _335)) * 4.0f) + 9.999999682655225e-21f))) * exp2(log2(1.0f - (_339 * _339)) * _606);
                      float _615 = _335 * _85.x;
                      _635 = (((((_577 * _383) - _548) + ((((_593 * (1.0f - _584)) + _584) * _615) * _614)) * _559) + _551);
                      _636 = (((((_577 * _384) - _549) + ((((_593 * (1.0f - _585)) + _585) * _615) * _614)) * _559) + _552);
                      _637 = (((((_577 * _385) - _550) + (((lerp(_586, 1.0f, _593)) * _615) * _614)) * _559) + _553);
                    } else {
                      _635 = _551;
                      _636 = _552;
                      _637 = _553;
                    }
                    float _641 = min((((_236 * _69.x) * _268) * _635), 1000.0f);
                    float _642 = min((((_236 * _69.y) * _269) * _636), 1000.0f);
                    float _643 = min((((_236 * _69.z) * _270) * _637), 1000.0f);
                    [branch]
                    if ((bool)(_23 < 3.0f) && (bool)MaterialIdEquals(_98.w, 0.007843137718737125f)) {
                      float _649 = max((_23 + -2.0f), 0.0f);
                      _667 = true;
                      _668 = ((lerp(g_xSubsurfaceScatteringWeight.x, 1.0f, _649)) * _641);
                      _669 = ((lerp(g_xSubsurfaceScatteringWeight.y, 1.0f, _649)) * _642);
                      _670 = ((lerp(g_xSubsurfaceScatteringWeight.z, 1.0f, _649)) * _643);
                    } else {
                      _667 = true;
                      _668 = _641;
                      _669 = _642;
                      _670 = _643;
                    }
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        _667 = false;
        _668 = 0.0f;
        _669 = 0.0f;
        _670 = 0.0f;
      }
    } while (false);
  } else {
    _667 = false;
    _668 = 0.0f;
    _669 = 0.0f;
    _670 = 0.0f;
  }
  [branch]
  if (!_667) {
    if (true) discard;
  }
  SV_Target.x = _668;
  SV_Target.y = _669;
  SV_Target.z = _670;
  SV_Target.w = 1.0f;
  return SV_Target;
}
