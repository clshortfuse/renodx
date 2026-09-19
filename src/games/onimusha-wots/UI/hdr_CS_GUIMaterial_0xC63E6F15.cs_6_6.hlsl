#include "./UI.hlsli"

Texture2D<float4> GUIImage : register(t0);

RWTexture2D<float3> RWResult : register(u0);

cbuffer SceneInfo : register(b0) {
  row_major float4x4 viewProjMat : packoffset(c000.x);
  row_major float3x4 transposeViewMat : packoffset(c004.x);
  row_major float3x4 transposeViewInvMat : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  row_major float4x4 viewProjInvMat : packoffset(c014.x);
  row_major float4x4 prevViewProjMat : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[8] : packoffset(c025.x);
  float4 clipplane : packoffset(c033.x);
  float2 vrsVelocityThreshold : packoffset(c034.x);
  uint GPUVisibleMask : packoffset(c034.z);
  uint resolutionRatioPacked : packoffset(c034.w);
  float3 worldOffset : packoffset(c035.x);
  uint sceneInfoMisc : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  uint blueNoiseJitterIndex : packoffset(c038.z);
  float tessellationParam : packoffset(c038.w);
  float SceneInfo_Reserve2 : packoffset(c039.x);
};

cbuffer GUIConstant : register(b2) {
  row_major float4x4 guiViewMatrix : packoffset(c000.x);
  row_major float4x4 guiProjMatrix : packoffset(c004.x);
  row_major float4x4 guiWorldMat : packoffset(c008.x);
  float guiIntensity : packoffset(c012.x);
  float guiSaturation : packoffset(c012.y);
  float guiSoftParticleDist : packoffset(c012.z);
  float guiFilterParam : packoffset(c012.w);
  float4 guiScreenSizeRatio : packoffset(c013.x);
  float2 guiCaptureSizeRatio : packoffset(c014.x);
  float2 guiDistortionOffset : packoffset(c014.z);
  float guiFilterMipLevel : packoffset(c015.x);
  float guiStencilScale : packoffset(c015.y);
  uint guiDepthTestTargetStencil : packoffset(c015.z);
  uint guiShaderCommonFlag : packoffset(c015.w);
  float4 guiAdjustAddColor : packoffset(c016.x);
  float guiTextureSampleGradScale : packoffset(c017.x);
};

cbuffer UserMaterial : register(b3) {
  float VAR_scale : packoffset(c000.x);
  float VAR_offset : packoffset(c000.y);
  float VAR_intensity : packoffset(c000.z);
  float CAPCOM_MATERIAL_RESERVE : packoffset(c000.w);
};

SamplerState PointClamp : register(s1, space32);

[numthreads(256, 1, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  int16_t _17;
  int16_t _19;
  int16_t _22;
  int16_t _25;
  int16_t _34;
  int16_t _39;
  float4 _51;
  float _58;
  float _62;
  float _63;
  float _64;
  float _66;
  float _69;
  float _72;
  float _75;
  float _91;
  float _199;
  float _200;
  float _201;
  float _369;
  float _370;
  float _371;
  bool _380;
  float _447;
  float _448;
  float _449;
  int _454;
  int _455;
  float _456;
  float _457;
  float _458;
  float _98;
  float _141;
  float _142;
  float _143;
  float _180;
  float _181;
  float _182;
  float _194;
  bool _204;
  bool _205;
  float _226;
  float _235;
  float _239;
  float _248;
  float _252;
  float _261;
  float _263;
  float _269;
  float _278;
  float _289;
  float _298;
  float _303;
  float _304;
  float _305;
  float _315;
  float _323;
  float _327;
  float _336;
  float _340;
  float _349;
  float _352;
  float _355;
  float _358;
  int _381;
  int _382;
  float _385;
  float _386;
  float _387;
  float _397;
  float _398;
  float _399;
  float _426;
  float _427;
  float _428;
  float _429;
  float _432;
  float _435;
  float _438;
  float _470;
  float _479;
  float _491;
  float _503;
  _17 = int16_t((int)(SV_GroupThreadID.x));
  _19 = (uint16_t)(_17) >> 1;
  _22 = (uint16_t)(_17) >> 2;
  _25 = (uint16_t)(_17) >> 3;
  _34 = ((int)(((int)(((int)(((int)(_17 & 1)) | ((int)((int)(int16_t((int)(SV_GroupID.x))) << 4)))) | ((int)(_19 & 2)))) | ((int)(_22 & 4)))) | ((int)(_25 & 8));
  _39 = ((int)(((int)(((int)(((int)(_19 & 1)) | ((int)((int)(int16_t((int)(SV_GroupID.y))) << 4)))) | ((int)(_22 & 2)))) | ((int)(_25 & 4)))) | ((int)(((int)((uint16_t)(_17) >> 4)) & 8));
  _51 = GUIImage.SampleLevel(PointClamp, float2(((((float)((uint16_t)_34)) + 0.5f) * screenInverseSize.x), ((((float)((uint16_t)_39)) + 0.5f) * screenInverseSize.y)), 0.0f);

#if 1
  if (TONE_MAP_TYPE != 0.f) {
    if (RENODX_GAMMA_CORRECTION_UI != 0.f) {
      _51.rgb = renodx::color::correct::GammaSafe(_51.rgb);
    }
  }
#endif

  _58 = 1.0f / _51.w;
  _62 = saturate(_51.x * _58);
  _63 = saturate(_51.y * _58);
  _64 = saturate(_51.z * _58);
  _66 = max(_62, max(_63, _64));
  _69 = _66 - min(_62, min(_63, _64));
  _72 = select((!(_66 == 0.0f)), (_69 / _66), 0.0f);
  _75 = select((_69 == 0.0f), 0.0f, (1.0f / _69));
  if (_62 == _66) {
    _91 = (_75 * (_63 - _64));
  } else {
    if (_63 == _66) {
      _91 = ((_75 * (_64 - _62)) + 2.0f);
    } else {
      _91 = ((_75 * (_62 - _63)) + 4.0f);
    }
  }
  _98 = (VAR_scale * frac(_91 * 0.1666666716337204f)) + VAR_offset;
  _141 = ((((((saturate((abs((frac(_98) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _72) + 1.0f) * _66) - _62) * VAR_intensity) + _62;
  _142 = ((((((saturate((abs((frac(_98 + 0.6666666865348816f) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _72) + 1.0f) * _66) - _63) * VAR_intensity) + _63;
  _143 = ((((((saturate((abs((frac(_98 + 0.3333333432674408f) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _72) + 1.0f) * _66) - _64) * VAR_intensity) + _64;
  _180 = (((float)((bool)((uint)(!(_141 <= 0.040449999272823334f))))) * exp2(log2((_141 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f)) + ((_141 * 0.07739938050508499f) * ((float)((bool)(uint)(_141 <= 0.040449999272823334f))));
  _181 = (((float)((bool)((uint)(!(_142 <= 0.040449999272823334f))))) * exp2(log2((_142 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f)) + ((_142 * 0.07739938050508499f) * ((float)((bool)(uint)(_142 <= 0.040449999272823334f))));
  _182 = (((float)((bool)((uint)(!(_143 <= 0.040449999272823334f))))) * exp2(log2((_143 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f)) + ((_143 * 0.07739938050508499f) * ((float)((bool)(uint)(_143 <= 0.040449999272823334f))));
  if (!((_51.w + -0.003000000026077032f) < 0.0f)) {
    do {
      _199 = _180;
      _200 = _181;
      _201 = _182;
      if (_51.w > 0.0f) {
        _194 = 1.0f / ((((float)((uint)((uint)(((uint)((uint)(guiShaderCommonFlag)) >> 8) & 1)))) * (1.0f - _51.w)) + _51.w);
        _199 = (_194 * _180);
        _200 = (_194 * _181);
        _201 = (_194 * _182);
      }
      _204 = (max(max(_199, _200), _201) == 0.0f);
      _205 = (_51.w == 0.0f);
      if (!(_205 && _204)) {
        do {
          _369 = _199;
          _370 = _200;
          _371 = _201;
          if (!(enableHDRAdjustmentForOverlay == 0)) {
            _226 = exp2(log2(mad(0.0810546875f, _201, mad(0.623046875f, _200, (_199 * 0.295654296875f))) * 0.009999999776482582f) * 0.1593017578125f);
            _235 = saturate(exp2(log2(((_226 * 18.8515625f) + 0.8359375f) / ((_226 * 18.6875f) + 1.0f)) * 78.84375f));
            _239 = exp2(log2(mad(0.116455078125f, _201, mad(0.727294921875f, _200, (_199 * 0.15625f))) * 0.009999999776482582f) * 0.1593017578125f);
            _248 = saturate(exp2(log2(((_239 * 18.8515625f) + 0.8359375f) / ((_239 * 18.6875f) + 1.0f)) * 78.84375f));
            _252 = exp2(log2(mad(0.808349609375f, _201, mad(0.156494140625f, _200, (_199 * 0.03515625f))) * 0.009999999776482582f) * 0.1593017578125f);
            _261 = saturate(exp2(log2(((_252 * 18.8515625f) + 0.8359375f) / ((_252 * 18.6875f) + 1.0f)) * 78.84375f));
            _263 = (_248 + _235) * 0.5f;
            _269 = exp2(log2(saturate(_263)) * 0.012683313339948654f);
            _278 = exp2(log2(max(0.0f, (_269 + -0.8359375f)) / (18.8515625f - (_269 * 18.6875f))) * 6.277394771575928f) * 100.0f;
            _289 = exp2(log2(((brightnessAdjustmentForOverlay * 0.009999999776482582f) * _278) * ((((brightnessAdjustmentForOverlay + -1.0f) * _51.w) * _278) + 1.0f)) * 0.1593017578125f);
            _298 = saturate(exp2(log2(((_289 * 18.8515625f) + 0.8359375f) / ((_289 * 18.6875f) + 1.0f)) * 78.84375f));
            _303 = min((_263 / _298), (_298 / _263)) * (saturateAdjustmentForOverlay * 0.000244140625f);
            _304 = _303 * dot(float3(_235, _248, _261), float3(6610.0f, -13613.0f, 7003.0f));
            _305 = _303 * dot(float3(_235, _248, _261), float3(17933.0f, -17390.0f, -543.0f));
            _315 = exp2(log2(saturate(mad(0.11100000143051147f, _305, mad(0.008999999612569809f, _304, _298)))) * 0.012683313339948654f);
            _323 = exp2(log2(max(0.0f, (_315 + -0.8359375f)) / (18.8515625f - (_315 * 18.6875f))) * 6.277394771575928f);
            _327 = exp2(log2(saturate(mad(-0.11100000143051147f, _305, mad(-0.008999999612569809f, _304, _298)))) * 0.012683313339948654f);
            _336 = exp2(log2(max(0.0f, (_327 + -0.8359375f)) / (18.8515625f - (_327 * 18.6875f))) * 6.277394771575928f) * 100.0f;
            _340 = exp2(log2(saturate(mad(-0.32100000977516174f, _305, mad(0.5600000023841858f, _304, _298)))) * 0.012683313339948654f);
            _349 = exp2(log2(max(0.0f, (_340 + -0.8359375f)) / (18.8515625f - (_340 * 18.6875f))) * 6.277394771575928f) * 100.0f;
            _352 = mad(0.2070000022649765f, _349, mad(-1.3270000219345093f, _336, (_323 * 207.10000610351562f)));
            _355 = mad(-0.04500000178813934f, _349, mad(0.6809999942779541f, _336, (_323 * 36.5f)));
            _358 = mad(1.187999963760376f, _349, mad(-0.05000000074505806f, _336, (_323 * -4.900000095367432f)));
            _369 = mad(-0.49861079454421997f, _358, mad(-1.5373831987380981f, _355, (_352 * 3.2409698963165283f)));
            _370 = mad(0.041555095463991165f, _358, mad(1.8759677410125732f, _355, (_352 * -0.9692437052726746f)));
            _371 = mad(1.0569714307785034f, _358, mad(-0.2039768397808075f, _355, (_352 * 0.055630069226026535f)));
          }
          do {
            [branch]
            if (_51.w == 1.0f) {
              _454 = ((int)(min16uint)(_39));
              _455 = ((int)(min16uint)(_34));
              _456 = _369;
              _457 = _370;
              _458 = _371;
            } else {
              do {
                _380 = false;
                if (_205) {
                  _380 = (!_204);
                }
                _381 = (int)(min16uint)(_34);
                _382 = (int)(min16uint)(_39);
                _385 = RWResult[int2(_381, _382)].x;
                _386 = RWResult[int2(_381, _382)].y;
                _387 = RWResult[int2(_381, _382)].z;
                _397 = exp2(log2(saturate(_385)) * 0.012683313339948654f);
                _398 = exp2(log2(saturate(_386)) * 0.012683313339948654f);
                _399 = exp2(log2(saturate(_387)) * 0.012683313339948654f);
                _426 = 10000.0f / whitePaperNitsForOverlay;
                _427 = _426 * exp2(log2(max(0.0f, (_397 + -0.8359375f)) / (18.8515625f - (_397 * 18.6875f))) * 6.277394771575928f);
                _428 = _426 * exp2(log2(max(0.0f, (_398 + -0.8359375f)) / (18.8515625f - (_398 * 18.6875f))) * 6.277394771575928f);
                _429 = _426 * exp2(log2(max(0.0f, (_399 + -0.8359375f)) / (18.8515625f - (_399 * 18.6875f))) * 6.277394771575928f);
                _432 = mad(-0.07285170257091522f, _429, mad(-0.5876399874687195f, _428, (_427 * 1.6604909896850586f)));
                _435 = mad(-0.00834800023585558f, _429, mad(1.1328999996185303f, _428, (_427 * -0.124549999833107f)));
                _438 = mad(1.1187299489974976f, _429, mad(-0.10057900100946426f, _428, (_427 * -0.018151000142097473f)));
                do {
                  _447 = _369;
                  _448 = _370;
                  _449 = _371;
                  if (!(_380)) {
                    _447 = ((_369 - _432) * _51.w);
                    _448 = ((_370 - _435) * _51.w);
                    _449 = ((_371 - _438) * _51.w);
                  }
                  _454 = _382;
                  _455 = _381;
                  _456 = (_447 + _432);
                  _457 = (_448 + _435);
                  _458 = (_449 + _438);
                } while (false);
              } while (false);
            }
            _470 = 10000.0f / whitePaperNitsForOverlay;
            _479 = exp2(log2(saturate(mad(0.04331360012292862f, _458, mad(0.3292819857597351f, _457, (_456 * 0.627403974533081f))) / _470)) * 0.1593017578125f);
            _491 = exp2(log2(saturate(mad(0.011361200362443924f, _458, mad(0.9195399880409241f, _457, (_456 * 0.06909699738025665f))) / _470)) * 0.1593017578125f);
            _503 = exp2(log2(saturate(mad(0.8955950140953064f, _458, mad(0.08801320195198059f, _457, (_456 * 0.01639159955084324f))) / _470)) * 0.1593017578125f);
            if (CUSTOM_SHOW_UI) {
              RWResult[int2(_455, _454)] = float3(saturate(exp2(log2(((_479 * 18.8515625f) + 0.8359375f) / ((_479 * 18.6875f) + 1.0f)) * 78.84375f)), saturate(exp2(log2(((_491 * 18.8515625f) + 0.8359375f) / ((_491 * 18.6875f) + 1.0f)) * 78.84375f)), saturate(exp2(log2(((_503 * 18.8515625f) + 0.8359375f) / ((_503 * 18.6875f) + 1.0f)) * 78.84375f)));
            }
          } while (false);
        } while (false);
      }
    } while (false);
  }
}
