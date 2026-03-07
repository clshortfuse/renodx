#include "./Fog.hlsli"

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD
) : SV_Target {
  float4 SV_Target;
  uint _21 = uint(SV_Position.x);
  uint _22 = uint(SV_Position.y);
  float _24 = ReadonlyDepth.Load(int3(_21, _22, 0));
  float _55 = ((float((uint)_21) * 2.0f) * screenInverseSize.x) + -1.0f;
  float _56 = 1.0f - ((float((uint)_22) * 2.0f) * screenInverseSize.y);
  float _72 = mad(_24.x, (viewProjInvMat[2].w), mad(_56, (viewProjInvMat[1].w), (_55 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w);
  float _73 = (mad(_24.x, (viewProjInvMat[2].x), mad(_56, (viewProjInvMat[1].x), (_55 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x)) / _72;
  float _74 = (mad(_24.x, (viewProjInvMat[2].y), mad(_56, (viewProjInvMat[1].y), (_55 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y)) / _72;
  float _75 = (mad(_24.x, (viewProjInvMat[2].z), mad(_56, (viewProjInvMat[1].z), (_55 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z)) / _72;
  float _78 = ReadonlyDepth.Load(int3(int(SV_Position.x), int(SV_Position.y), 0));
  float _289;
  float _290;
  float _291;
  float _292;
  float _377;
  float _420;
  float _426;
  float _528;
  float _529;
  float _530;
  float _542;
  float _543;
  float _544;
  float _573;
  float _574;
  float _575;
  float _576;
  float _606;
  float _607;
  float _608;
  float _609;
  float _650;
  float _664;
  float _665;
  float _666;
  float _667;
  float _768;
  float _774;
  float _775;
  float _801;
  float _802;
  float _803;
  float _804;
  float _813;
  float _814;
  float _815;
  float _816;
  if (!((FrustumVolumeFlags & 1) == 0)) {
    float _112 = mad(_75, (viewProjMat[2].w), mad(_74, (viewProjMat[1].w), ((viewProjMat[0].w) * _73))) + (viewProjMat[3].w);
    float _117 = (((mad(_75, (viewProjMat[2].x), mad(_74, (viewProjMat[1].x), ((viewProjMat[0].x) * _73))) + (viewProjMat[3].x)) / _112) * 0.5f) + 0.5f;
    float _118 = 0.5f - (((mad(_75, (viewProjMat[2].y), mad(_74, (viewProjMat[1].y), ((viewProjMat[0].y) * _73))) + (viewProjMat[3].y)) / _112) * 0.5f);
    float _125 = _73 - (transposeViewInvMat[0].w);
    float _126 = _74 - (transposeViewInvMat[1].w);
    float _127 = _75 - (transposeViewInvMat[2].w);
    float _137 = sqrt(((_126 * _126) + (_125 * _125)) + (_127 * _127));
    float4 _150 = VolumetricFogTexture.SampleLevel(BilinearClamp, float3((VFogSampleOffset.x + _117), (VFogSampleOffset.y + _118), ((log2(max((_137 - DepthEncodingParams.y), 0.0f)) * DepthEncodingParams.z) + DepthEncodingParams.x)), 0.0f);
    do {
      if (!((FogParamsFlags & 1) == 0)) {
        float _165 = (1.0f - FogParamsHeightFogTransitionFactor) * VFogCullingDistance;
        float _166 = _125 / _137;
        float _167 = _126 / _137;
        float _168 = _127 / _137;
        float _170 = max(0.0010000000474974513f, min(_137, _165));
        float _171 = _170 * _166;
        float _172 = _170 * _167;
        float _173 = _170 * _168;
        float _174 = _171 + (transposeViewInvMat[0].w);
        float _175 = _172 + (transposeViewInvMat[1].w);
        float _176 = _173 + (transposeViewInvMat[2].w);
        float _188 = mad(_176, (viewProjMat[2].w), mad(_175, (viewProjMat[1].w), (_174 * (viewProjMat[0].w)))) + (viewProjMat[3].w);
        float4 _208 = VolumetricFogTexture.SampleLevel(BilinearClamp, float3(((VFogSampleOffset.x + 0.5f) + (((mad(_176, (viewProjMat[2].x), mad(_175, (viewProjMat[1].x), (_174 * (viewProjMat[0].x)))) + (viewProjMat[3].x)) / _188) * 0.5f)), ((VFogSampleOffset.y + 0.5f) - (((mad(_176, (viewProjMat[2].y), mad(_175, (viewProjMat[1].y), (_174 * (viewProjMat[0].y)))) + (viewProjMat[3].y)) / _188) * 0.5f)), ((log2(max((sqrt(((_172 * _172) + (_171 * _171)) + (_173 * _173)) - DepthEncodingParams.y), 0.0f)) * DepthEncodingParams.z) + DepthEncodingParams.x)), 0.0f);
        float _215 = min(_137, FogParamsHeightFogCutoffDistance) - _165;
        if (_215 > 0.0f) {
          float _241 = FogParamsHeightFogEmissiveIntensity * 0.003921568859368563f;
          float _249 = min(_215, FogParamsHeightFogHermiteCurveRange.x);
          float _251 = min(_215, FogParamsHeightFogHermiteCurveRange.y);
          float _257 = (FogParamsHeightFogHermiteCurveMadd.x * _249) + FogParamsHeightFogHermiteCurveMadd.y;
          float _258 = (FogParamsHeightFogHermiteCurveMadd.x * _251) + FogParamsHeightFogHermiteCurveMadd.y;
          float _259 = _257 * _257;
          float _260 = _259 * _257;
          float _261 = _258 * _258;
          float _262 = _261 * _258;
          float _263 = FogParamsHeightFogAttenuationByHeight * _167;
          do {
            if (!(_263 == 0.0f)) {
              float _267 = 1.0f / _263;
              do {
                if (!(FogParamsHeightFogDensityOfCurveStartEnd.x > 0.0f)) {
                  float _270 = _175 - FogParamsHeightFogReferenceAltitude;
                  float _271 = FogParamsHeightFogAttenuationByHeight * -1.4426950216293335f;
                  _289 = exp2(((_249 * _167) + _270) * _271);
                  _290 = _271;
                  _291 = _270;
                  _292 = 0.0f;
                } else {
                  float _278 = _175 - FogParamsHeightFogReferenceAltitude;
                  float _280 = FogParamsHeightFogAttenuationByHeight * -1.4426950216293335f;
                  float _282 = exp2(((_249 * _167) + _278) * _280);
                  _289 = _282;
                  _290 = _280;
                  _291 = _278;
                  _292 = ((_267 * FogParamsHeightFogDensityOfCurveStartEnd.x) * (_282 - exp2(_280 * _278)));
                }
                do {
                  if (abs(_263) < 0.000750000006519258f) {
                    float _297 = (_251 - _249) * _263;
                    float _300 = 1.0f - _297;
                    float _307 = FogParamsHeightFogCommonCoefsForTaylor.y * _263;
                    float _308 = (_263 * _263) * FogParamsHeightFogCommonCoefsForTaylor.z;
                    float _314 = _262 * _258;
                    float _321 = _262 * _261;
                    float _334 = _260 * _257;
                    float _336 = _260 * _259;
                    _377 = (-0.0f - (_289 * (dot(float3((FogParamsHeightFogCommonCoefsForTaylor.x * (((_297 * _297) * 0.5f) + _300)), (_307 * _300), _308), float3(dot(float4(_314, _262, _261, _258), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].w))), dot(float4(_321, (_261 * _261), _262, _261), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].w))), dot(float4((_262 * _262), _321, _314, _262), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].w))))) - dot(float3(FogParamsHeightFogCommonCoefsForTaylor.x, _307, _308), float3(dot(float4(_334, _260, _259, _257), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[0].w))), dot(float4(_336, (_259 * _259), _260, _259), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[1].w))), dot(float4((_260 * _260), _336, _334, _260), float4((FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].x), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].y), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].z), (FogParamsHeightFogIntegratedHermiteCoefsAForTaylor[2].w))))))));
                  } else {
                    float _346 = _267 * _267;
                    float _347 = _346 * _267;
                    float _348 = _347 * _267;
                    _377 = ((dot(float4(_267, _346, _347, _348), float4(dot(float4(_262, _261, _258, 1.0f), float4(FogParamsHeightFogIntegratedHermiteCoefsA.x, FogParamsHeightFogIntegratedHermiteCoefsA.y, FogParamsHeightFogIntegratedHermiteCoefsA.z, FogParamsHeightFogIntegratedHermiteCoefsA.w)), dot(float3(_261, _258, 1.0f), float3(FogParamsHeightFogIntegratedHermiteCoefsB.x, FogParamsHeightFogIntegratedHermiteCoefsB.y, FogParamsHeightFogIntegratedHermiteCoefsB.z)), dot(float2(_258, 1.0f), float2(FogParamsHeightFogIntegratedHermiteCoefsC.x, FogParamsHeightFogIntegratedHermiteCoefsC.y)), FogParamsHeightFogIntegratedHermiteCoefsD)) * exp2(((_251 * _167) + _291) * _290)) - (dot(float4(_267, _346, _347, _348), float4(dot(float4(_260, _259, _257, 1.0f), float4(FogParamsHeightFogIntegratedHermiteCoefsA.x, FogParamsHeightFogIntegratedHermiteCoefsA.y, FogParamsHeightFogIntegratedHermiteCoefsA.z, FogParamsHeightFogIntegratedHermiteCoefsA.w)), dot(float3(_259, _257, 1.0f), float3(FogParamsHeightFogIntegratedHermiteCoefsB.x, FogParamsHeightFogIntegratedHermiteCoefsB.y, FogParamsHeightFogIntegratedHermiteCoefsB.z)), dot(float2(_257, 1.0f), float2(FogParamsHeightFogIntegratedHermiteCoefsC.x, FogParamsHeightFogIntegratedHermiteCoefsC.y)), FogParamsHeightFogIntegratedHermiteCoefsD)) * _289));
                  }
                  float _378 = _377 + _292;
                  if (FogParamsHeightFogDensityOfCurveStartEnd.y > 0.0f) {
                    _420 = (((_267 * FogParamsHeightFogDensityOfCurveStartEnd.y) * (exp2(_290 * (((_215 * _167) + _175) - FogParamsHeightFogReferenceAltitude)) - exp2(((_175 - FogParamsHeightFogReferenceAltitude) + (_251 * _167)) * _290))) + _378);
                  } else {
                    _420 = _378;
                  }
                } while (false);
              } while (false);
            } else {
              _420 = (((((-0.0f - (FogParamsHeightFogDensityOfCurveStartEnd.x * _249)) - (FogParamsHeightFogDensityOfCurveStartEnd.y * (_215 - _251))) - (dot(float4(FogParamsHeightFogIntegratedHermiteCoefs.x, FogParamsHeightFogIntegratedHermiteCoefs.y, FogParamsHeightFogIntegratedHermiteCoefs.z, FogParamsHeightFogIntegratedHermiteCoefs.w), float4(_262, _261, _258, 1.0f)) * _258)) + (dot(float4(FogParamsHeightFogIntegratedHermiteCoefs.x, FogParamsHeightFogIntegratedHermiteCoefs.y, FogParamsHeightFogIntegratedHermiteCoefs.z, FogParamsHeightFogIntegratedHermiteCoefs.w), float4(_260, _259, _257, 1.0f)) * _257)) * exp2((FogParamsHeightFogAttenuationByHeight * -1.4426950216293335f) * (_175 - FogParamsHeightFogReferenceAltitude)));
            }
            do {
              if (isfinite(_420)) {
                _426 = exp2(_420 * 1.4426950216293335f);
              } else {
                _426 = 0.0f;
              }
              do {
                if (!(((DL_Enable & 255) & GPUVisibleMask) == 0)) {
                  float _443 = FogParamsHeightFogEccentricity * FogParamsHeightFogEccentricity;
                  float _447 = (_443 + 1.0f) + ((FogParamsHeightFogEccentricity * 2.0f) * dot(float3(DL_Direction.x, DL_Direction.y, DL_Direction.z), float3((-0.0f - _166), (-0.0f - _167), (-0.0f - _168))));
                  do {
                    if (!(Atmosphere_Flags == 0)) {
                      float _465 = _174 * 0.0010000000474974513f;
                      float _466 = _176 * 0.0010000000474974513f;
                      float _467 = (PlanetRadius + _175) * 0.0010000000474974513f;
                      float _473 = sqrt(((_465 * _465) + (_466 * _466)) + (_467 * _467));
                      float _481 = dot(float3(SunDirection.x, SunDirection.z, SunDirection.y), float3((_465 / _473), (_466 / _473), (_467 / _473)));
                      float _484 = OuterAtmosphereRadius * 0.0010000000474974513f;
                      float _485 = PlanetRadius * 0.0010000000474974513f;
                      float _486 = _484 * _484;
                      float _487 = _485 * _485;
                      float _490 = sqrt(max(0.0f, (_486 - _487)));
                      float _491 = _473 * _473;
                      float _494 = sqrt(max(0.0f, (_491 - _487)));
                      float _503 = _484 - _473;
                      float _507 = (max(0.0f, (sqrt(_486 + (((_481 * _481) + -1.0f) * _491)) - (_481 * _473))) - _503) / ((_490 - _503) + _494);
                      if (!(_507 > 1.0f)) {
                        float3 _512 = AtmosphereTransmittanceCopiedTexture.SampleLevel(BilinearClamp, float2(_507, (_494 / _490)), 0.0f);
                        _528 = ((_512.x * AtmosphereBlendTextureAlphaScale) + AtmosphereBlendTextureColor.x);
                        _529 = ((_512.y * AtmosphereBlendTextureAlphaScale) + AtmosphereBlendTextureColor.y);
                        _530 = ((_512.z * AtmosphereBlendTextureAlphaScale) + AtmosphereBlendTextureColor.z);
                      } else {
                        _528 = 0.0f;
                        _529 = 0.0f;
                        _530 = 0.0f;
                      }
                    } else {
                      _528 = 1.0f;
                      _529 = 1.0f;
                      _530 = 1.0f;
                    }
                    float _531 = (((1.0f - _443) * 0.07957746833562851f) / max((_447 * sqrt(_447)), 9.999999747378752e-05f)) * 0.003921568859368563f;
                    _542 = (((_531 * float((uint)((int)(FogParamsHeightFogAlbedo & 255)))) * DL_VolumetricScatteringColor.x) * _528);
                    _543 = (((_531 * float((uint)((int)(((uint)((int)(FogParamsHeightFogAlbedo)) >> 8) & 255)))) * DL_VolumetricScatteringColor.y) * _529);
                    _544 = (((_531 * float((uint)((int)(((uint)((int)(FogParamsHeightFogAlbedo)) >> 16) & 255)))) * DL_VolumetricScatteringColor.z) * _530);
                  } while (false);
                } else {
                  _542 = 0.0f;
                  _543 = 0.0f;
                  _544 = 0.0f;
                }
                float _549 = (1.0f - _426) * _208.w;
                float _556 = saturate(_215 / (FogParamsHeightFogTransitionFactor * VFogCullingDistance));
                _573 = ((_556 * ((_208.x - _150.x) + ((_542 + (_241 * float((uint)((int)(FogParamsHeightFogEmissiveColor & 255))))) * _549))) + _150.x);
                _574 = ((_556 * ((_208.y - _150.y) + ((_543 + (float((uint)((int)(((uint)((int)(FogParamsHeightFogEmissiveColor)) >> 8) & 255))) * _241)) * _549))) + _150.y);
                _575 = ((((_208.z - _150.z) + ((_544 + (float((uint)((int)(((uint)((int)(FogParamsHeightFogEmissiveColor)) >> 16) & 255))) * _241)) * _549)) * _556) + _150.z);
                _576 = ((_556 * ((_426 * _208.w) - _150.w)) + _150.w);
              } while (false);
            } while (false);
          } while (false);
        } else {
          _573 = _208.x;
          _574 = _208.y;
          _575 = _208.z;
          _576 = _208.w;
        }
      } else {
        _573 = _150.x;
        _574 = _150.y;
        _575 = _150.z;
        _576 = _150.w;
      }
      if (!(vpiEnable == 0)) {
        float4 _582 = VolumetricParticleTexture.SampleLevel(BilinearClamp, float2(_117, _118), 0.0f);
        float _587 = dot(float3(_573, _574, _575), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) * 0.5f;
        _606 = max(0.0f, ((((_573 - _587) * _582.x) * vpiCompositionRate) + _573));
        _607 = max(0.0f, ((((_574 - _587) * _582.y) * vpiCompositionRate) + _574));
        _608 = max(0.0f, ((((_575 - _587) * _582.z) * vpiCompositionRate) + _575));
        _609 = _576;
      } else {
        _606 = _573;
        _607 = _574;
        _608 = _575;
        _609 = _576;
      }
    } while (false);
  } else {
    _606 = 0.0f;
    _607 = 0.0f;
    _608 = 0.0f;
    _609 = 1.0f;
  }
  if (fogMaxOpacity > 0.0f) {
    float _622 = _73 - (transposeViewInvMat[0].w);
    float _623 = _74 - (transposeViewInvMat[1].w);
    float _624 = _75 - (transposeViewInvMat[2].w);
    float _625 = dot(float3(_622, _623, _624), float3(_622, _623, _624));
    float _626 = rsqrt(_625);
    float _627 = _626 * _623;
    float _630 = select((abs(_627) < 9.999999747378752e-05f), 9.999999747378752e-05f, _627);
    float _639 = fogDensity * max(0.0f, ((_626 * _625) - fogStartDistance));
    float _640 = _639 * _630;
    do {
      if (abs(-0.0f - _640) > 9.999999747378752e-06f) {
        _650 = ((1.0f - exp2(_640 * -1.4426950216293335f)) / _630);
      } else {
        _650 = _639;
      }
      float _655 = min(fogMaxOpacity, (exp2((fogHeightFalloff * -1.4426950216293335f) * max(0.0f, (_74 - fogHeightStartDistance))) * _650));
      _664 = (_655 * fogInscatteringColor.x);
      _665 = (_655 * fogInscatteringColor.y);
      _666 = (_655 * fogInscatteringColor.z);
      _667 = (1.0f - _655);
    } while (false);
  } else {
    _664 = 0.0f;
    _665 = 0.0f;
    _666 = 0.0f;
    _667 = 1.0f;
  }
  float _668 = _664 + _606;
  float _669 = _665 + _607;
  float _670 = _666 + _608;
  float _671 = _667 * _609;
  if (!((AtmosphereFlags & 2) == 0)) {
    float _679 = _73 * 0.0010000000474974513f;
    float _680 = _75 * 0.0010000000474974513f;
    float _684 = (PlanetRadius + _74) * 0.0010000000474974513f;
    do {
      if (((bool)(!(_78.x == 0.0f))) && ((bool)(!(sqrt(((_680 * _680) + (_679 * _679)) + (_684 * _684)) >= (OuterAtmosphereRadius * 0.0010000000474974513f))))) {
        float _702 = _73 - CameraPosition.x;
        float _703 = _74 - CameraPosition.y;
        float _704 = _75 - CameraPosition.z;
        float _710 = sqrt(((_702 * _702) + (_703 * _703)) + (_704 * _704));
        float _738 = mad(_75, (viewProjMat[2].w), mad(_74, (viewProjMat[1].w), ((viewProjMat[0].w) * _73))) + (viewProjMat[3].w);
        float _747 = (_710 * 0.0010000000474974513f) - AerialPerspectiveStartDepth;
        if (!(_747 <= 0.0f)) {
          do {
            if (_710 < cameraFarPlane) {
              _768 = ((_710 / cameraFarPlane) * 24.0f);
            } else {
              _768 = ((((_710 - cameraFarPlane) / ((OuterAtmosphereRadius - PlanetRadius) - cameraFarPlane)) * 8.0f) + 24.0f);
            }
            do {
              if (_768 < 0.5f) {
                _774 = saturate(_768 * 2.0f);
                _775 = 0.5f;
              } else {
                _774 = 1.0f;
                _775 = _768;
              }
              float _778 = _774 * saturate(AtmosphereLerpWeight * _747);
              float4 _781 = AerialPerspectiveTexture.SampleLevel(BilinearClamp, float3(((((mad(_75, (viewProjMat[2].x), mad(_74, (viewProjMat[1].x), ((viewProjMat[0].x) * _73))) + (viewProjMat[3].x)) / _738) * 0.5f) + 0.5f), (0.5f - (((mad(_75, (viewProjMat[2].y), mad(_74, (viewProjMat[1].y), ((viewProjMat[0].y) * _73))) + (viewProjMat[3].y)) / _738) * 0.5f)), sqrt(_775 * 0.03125f)), 0.0f);
              float _791 = _778 * AerialPerspectiveIntensity;
              _801 = ((_781.x * _791) * SunColor.x);
              _802 = ((_781.y * _791) * SunColor.y);
              _803 = ((_781.z * _791) * SunColor.z);
              _804 = saturate(1.0f - (_781.w * _778));
            } while (false);
          } while (false);
        } else {
          _801 = 0.0f;
          _802 = 0.0f;
          _803 = 0.0f;
          _804 = 1.0f;
        }
      } else {
        _801 = 0.0f;
        _802 = 0.0f;
        _803 = 0.0f;
        _804 = 1.0f;
      }
      _813 = ((_801 * _671) + _668);
      _814 = ((_802 * _671) + _669);
      _815 = ((_803 * _671) + _670);
      _816 = (_804 * _671);
    } while (false);
  } else {
    _813 = _668;
    _814 = _669;
    _815 = _670;
    _816 = _671;
  }
  float3 encodedFog = rangeCompress * float3(_813, _814, _815);
  encodedFog = ApplyDithering(encodedFog, SV_Position.xy);
  SV_Target.x = encodedFog.x;
  SV_Target.y = encodedFog.y;
  SV_Target.z = encodedFog.z;
  SV_Target.w = _816;
  return SV_Target;
}
