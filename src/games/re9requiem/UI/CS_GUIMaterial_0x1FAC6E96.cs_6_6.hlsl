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
  float tessellationParam : packoffset(c038.z);
  uint sceneInfoAdditionalFlags : packoffset(c038.w);
};

cbuffer RootConstant : register(b0, space32) {
  uint constant32Bits : packoffset(c000.x);
};

// cbuffer HDRMapping : register(b1) {
//   float whitePaperNits : packoffset(c000.x);
//   float configImageAlphaScale : packoffset(c000.y);
//   float displayMaxNits : packoffset(c000.z);
//   float displayMinNits : packoffset(c000.w);
//   float4 displayMaxNitsRect : packoffset(c001.x);
//   float4 secondaryDisplayMaxNitsRect : packoffset(c002.x);
//   float4 standardMaxNitsRect : packoffset(c003.x);
//   float4 secondaryStandardMaxNitsRect : packoffset(c004.x);
//   float2 displayMaxNitsRectSize : packoffset(c005.x);
//   float2 standardMaxNitsRectSize : packoffset(c005.z);
//   float4 standardMinNitsRect : packoffset(c006.x);
//   float4 secondaryStandardMinNitsRect : packoffset(c007.x);
//   float4 displayMinNitsRect : packoffset(c008.x);
//   float4 secondaryDisplayMinNitsRect : packoffset(c009.x);
//   float4 mdrOutRangeRect : packoffset(c010.x);
//   uint drawMode : packoffset(c011.x);
//   float gammaForHDR : packoffset(c011.y);
//   float displayMaxNitsST2084 : packoffset(c011.z);
//   float displayMinNitsST2084 : packoffset(c011.w);
//   uint drawModeOnMDRPass : packoffset(c012.x);
//   float saturationForHDR : packoffset(c012.y);
//   float2 targetInvSize : packoffset(c012.z);
//   float toeEnd : packoffset(c013.x);
//   float toeStrength : packoffset(c013.y);
//   float blackPoint : packoffset(c013.z);
//   float shoulderStartPoint : packoffset(c013.w);
//   float shoulderStrength : packoffset(c014.x);
//   float whitePaperNitsForOverlay : packoffset(c014.y);
//   float saturationOnDisplayMapping : packoffset(c014.z);
//   float graphScale : packoffset(c014.w);
//   float4 hdrImageRect : packoffset(c015.x);
//   float2 hdrImageRectSize : packoffset(c016.x);
//   float secondaryDisplayMaxNits : packoffset(c016.z);
//   float secondaryDisplayMinNits : packoffset(c016.w);
//   float2 secondaryDisplayMaxNitsRectSize : packoffset(c017.x);
//   float2 secondaryStandardMaxNitsRectSize : packoffset(c017.z);
//   float shoulderAngle : packoffset(c018.x);
//   uint enableHDRAdjustmentForOverlay : packoffset(c018.y);
//   float brightnessAdjustmentForOverlay : packoffset(c018.z);
//   float saturateAdjustmentForOverlay : packoffset(c018.w);
// };

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

SamplerState PointClamp : register(s1, space32);

[numthreads(256, 1, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  min16int _16 = min16int((uint)(SV_GroupThreadID.x));
  min16int _18 = (min16uint)(_16) >> 1;
  min16int _21 = (min16uint)(_16) >> 2;
  min16int _24 = (min16uint)(_16) >> 3;
  min16int _33 = ((min16int)(((min16int)(((min16int)(((min16int)(_16 & 1)) | ((min16uint)((min16int)(min16int((uint)(SV_GroupID.x))) << 4)))) | ((min16int)(_18 & 2)))) | ((min16int)(_21 & 4)))) | ((min16int)(_24 & 8));
  min16int _38 = ((min16int)(((min16int)(((min16int)(((min16int)(_18 & 1)) | ((min16uint)((min16int)(min16int((uint)(SV_GroupID.y))) << 4)))) | ((min16int)(_21 & 2)))) | ((min16int)(_24 & 4)))) | ((min16int)(((min16int)((min16uint)(_16) >> 4)) & 8));
  float _46 = (float((min16uint)_33) + 0.5f) * screenInverseSize.x;
  float _47 = (float((min16uint)_38) + 0.5f) * screenInverseSize.y;
  float4 _50 = GUIImage.SampleLevel(PointClamp, float2(_46, _47), 0.0f);

#if 1
  if (TONE_MAP_TYPE != 0.f) {
    if (RENODX_GAMMA_CORRECTION_UI != 0.f) {
      _50.rgb = renodx::color::correct::GammaSafe(_50.rgb);
    }
  }
#endif

  float _71;
  float _72;
  float _73;
  float _136;
  float _137;
  float _138;
  float _139;
  float _140;
  float _141;
  float _142;
  float _143;
  float _144;
  float _145;
  float _146;
  float _147;
  float _148;
  float _149;
  float _150;
  float _151;
  float _360;
  float _361;
  float _362;
  bool _371;
  float _438;
  float _439;
  float _440;
  int _445;
  int _446;
  float _447;
  float _448;
  float _449;
  if (_50.w > 0.0f) {
    float _66 = 1.0f / ((float((uint)((int)(((uint)((int)(guiShaderCommonFlag)) >> 8) & 1))) * (1.0f - _50.w)) + _50.w);
    _71 = (_66 * _50.x);
    _72 = (_66 * _50.y);
    _73 = (_66 * _50.z);
  } else {
    _71 = _50.x;
    _72 = _50.y;
    _73 = _50.z;
  }
  bool _76 = (max(max(_71, _72), _73) == 0.0f);
  int _79 = constant32Bits & 3;
  bool _81 = ((constant32Bits & 4) != 0);
  if (_79 == 1) {
    _136 = standardMaxNitsRect.x;
    _137 = standardMaxNitsRect.y;
    _138 = standardMaxNitsRect.z;
    _139 = standardMaxNitsRect.w;
    _140 = secondaryStandardMaxNitsRect.x;
    _141 = secondaryStandardMaxNitsRect.y;
    _142 = secondaryStandardMaxNitsRect.z;
    _143 = secondaryStandardMaxNitsRect.w;
    _144 = displayMaxNitsRect.x;
    _145 = displayMaxNitsRect.y;
    _146 = displayMaxNitsRect.z;
    _147 = displayMaxNitsRect.w;
    _148 = secondaryDisplayMaxNitsRect.x;
    _149 = secondaryDisplayMaxNitsRect.y;
    _150 = secondaryDisplayMaxNitsRect.z;
    _151 = secondaryDisplayMaxNitsRect.w;
  } else {
    if (_79 == 2) {
      _136 = standardMinNitsRect.x;
      _137 = standardMinNitsRect.y;
      _138 = standardMinNitsRect.z;
      _139 = standardMinNitsRect.w;
      _140 = secondaryStandardMinNitsRect.x;
      _141 = secondaryStandardMinNitsRect.y;
      _142 = secondaryStandardMinNitsRect.z;
      _143 = secondaryStandardMinNitsRect.w;
      _144 = displayMinNitsRect.x;
      _145 = displayMinNitsRect.y;
      _146 = displayMinNitsRect.z;
      _147 = displayMinNitsRect.w;
      _148 = secondaryDisplayMinNitsRect.x;
      _149 = secondaryDisplayMinNitsRect.y;
      _150 = secondaryDisplayMinNitsRect.z;
      _151 = secondaryDisplayMinNitsRect.w;
    } else {
      if (_79 == 3) {
        _136 = hdrImageRect.x;
        _137 = hdrImageRect.y;
        _138 = hdrImageRect.z;
        _139 = hdrImageRect.w;
        _140 = 0.0f;
        _141 = 0.0f;
        _142 = 0.0f;
        _143 = 0.0f;
        _144 = 0.0f;
        _145 = 0.0f;
        _146 = 0.0f;
        _147 = 0.0f;
        _148 = 0.0f;
        _149 = 0.0f;
        _150 = 0.0f;
        _151 = 0.0f;
      } else {
        _136 = 0.0f;
        _137 = 0.0f;
        _138 = 0.0f;
        _139 = 0.0f;
        _140 = 0.0f;
        _141 = 0.0f;
        _142 = 0.0f;
        _143 = 0.0f;
        _144 = 0.0f;
        _145 = 0.0f;
        _146 = 0.0f;
        _147 = 0.0f;
        _148 = 0.0f;
        _149 = 0.0f;
        _150 = 0.0f;
        _151 = 0.0f;
      }
    }
  }
  if (!((bool)(_47 <= _139) && ((bool)((bool)(_47 >= _137) && ((bool)((bool)(_46 >= _136) && (bool)(_46 <= _138))))))) {
    if (!((bool)(_47 <= _143) && ((bool)((bool)(_47 >= _141) && ((bool)(((bool)(_81 && (bool)(_46 >= _140))) && (bool)(_46 <= _142))))))) {
      if (!((bool)(_47 <= _147) && ((bool)((bool)(_47 >= _145) && ((bool)((bool)(_46 >= _144) && (bool)(_46 <= _146))))))) {
        if (!((bool)(_47 <= _151) && ((bool)((bool)(_47 >= _149) && ((bool)(((bool)(_81 && (bool)(_46 >= _148))) && (bool)(_46 <= _150))))))) {
          bool _196 = (_50.w == 0.0f);
          do {
            if (!(_196 && _76)) {
              do {
                if (!(enableHDRAdjustmentForOverlay == 0)) {
                  float _217 = exp2(log2(mad(0.0810546875f, _73, mad(0.623046875f, _72, (_71 * 0.295654296875f))) * 0.009999999776482582f) * 0.1593017578125f);
                  float _226 = saturate(exp2(log2(((_217 * 18.8515625f) + 0.8359375f) / ((_217 * 18.6875f) + 1.0f)) * 78.84375f));
                  float _230 = exp2(log2(mad(0.116455078125f, _73, mad(0.727294921875f, _72, (_71 * 0.15625f))) * 0.009999999776482582f) * 0.1593017578125f);
                  float _239 = saturate(exp2(log2(((_230 * 18.8515625f) + 0.8359375f) / ((_230 * 18.6875f) + 1.0f)) * 78.84375f));
                  float _243 = exp2(log2(mad(0.808349609375f, _73, mad(0.156494140625f, _72, (_71 * 0.03515625f))) * 0.009999999776482582f) * 0.1593017578125f);
                  float _252 = saturate(exp2(log2(((_243 * 18.8515625f) + 0.8359375f) / ((_243 * 18.6875f) + 1.0f)) * 78.84375f));
                  float _254 = (_239 + _226) * 0.5f;
                  float _260 = exp2(log2(saturate(_254)) * 0.012683313339948654f);
                  float _269 = exp2(log2(max(0.0f, (_260 + -0.8359375f)) / (18.8515625f - (_260 * 18.6875f))) * 6.277394771575928f) * 100.0f;
                  float _280 = exp2(log2(((brightnessAdjustmentForOverlay * 0.009999999776482582f) * _269) * ((((brightnessAdjustmentForOverlay + -1.0f) * _50.w) * _269) + 1.0f)) * 0.1593017578125f);
                  float _289 = saturate(exp2(log2(((_280 * 18.8515625f) + 0.8359375f) / ((_280 * 18.6875f) + 1.0f)) * 78.84375f));
                  float _294 = min((_254 / _289), (_289 / _254)) * (saturateAdjustmentForOverlay * 0.000244140625f);
                  float _295 = _294 * dot(float3(_226, _239, _252), float3(6610.0f, -13613.0f, 7003.0f));
                  float _296 = _294 * dot(float3(_226, _239, _252), float3(17933.0f, -17390.0f, -543.0f));
                  float _306 = exp2(log2(saturate(mad(0.11100000143051147f, _296, mad(0.008999999612569809f, _295, _289)))) * 0.012683313339948654f);
                  float _314 = exp2(log2(max(0.0f, (_306 + -0.8359375f)) / (18.8515625f - (_306 * 18.6875f))) * 6.277394771575928f);
                  float _318 = exp2(log2(saturate(mad(-0.11100000143051147f, _296, mad(-0.008999999612569809f, _295, _289)))) * 0.012683313339948654f);
                  float _327 = exp2(log2(max(0.0f, (_318 + -0.8359375f)) / (18.8515625f - (_318 * 18.6875f))) * 6.277394771575928f) * 100.0f;
                  float _331 = exp2(log2(saturate(mad(-0.32100000977516174f, _296, mad(0.5600000023841858f, _295, _289)))) * 0.012683313339948654f);
                  float _340 = exp2(log2(max(0.0f, (_331 + -0.8359375f)) / (18.8515625f - (_331 * 18.6875f))) * 6.277394771575928f) * 100.0f;
                  float _343 = mad(0.2070000022649765f, _340, mad(-1.3270000219345093f, _327, (_314 * 207.10000610351562f)));
                  float _346 = mad(-0.04500000178813934f, _340, mad(0.6809999942779541f, _327, (_314 * 36.5f)));
                  float _349 = mad(1.187999963760376f, _340, mad(-0.05000000074505806f, _327, (_314 * -4.900000095367432f)));
                  _360 = mad(-0.49861079454421997f, _349, mad(-1.5373831987380981f, _346, (_343 * 3.2409698963165283f)));
                  _361 = mad(0.041555095463991165f, _349, mad(1.8759677410125732f, _346, (_343 * -0.9692437052726746f)));
                  _362 = mad(1.0569714307785034f, _349, mad(-0.2039768397808075f, _346, (_343 * 0.055630069226026535f)));
                } else {
                  _360 = _71;
                  _361 = _72;
                  _362 = _73;
                }
                do {
                  [branch]
                  if (_50.w == 1.0f) {
                    _445 = ((int)(min16uint)(_38));
                    _446 = ((int)(min16uint)(_33));
                    _447 = _360;
                    _448 = _361;
                    _449 = _362;
                  } else {
                    do {
                      if (_196) {
                        _371 = (!_76);
                      } else {
                        _371 = false;
                      }
                      int _372 = (int)(min16uint)(_33);
                      int _373 = (int)(min16uint)(_38);
                      float3 _375 = RWResult.Load(int2(_372, _373));
                      float _388 = exp2(log2(saturate(_375.x)) * 0.012683313339948654f);
                      float _389 = exp2(log2(saturate(_375.y)) * 0.012683313339948654f);
                      float _390 = exp2(log2(saturate(_375.z)) * 0.012683313339948654f);
                      float _417 = 10000.0f / whitePaperNitsForOverlay;
                      float _418 = _417 * exp2(log2(max(0.0f, (_388 + -0.8359375f)) / (18.8515625f - (_388 * 18.6875f))) * 6.277394771575928f);
                      float _419 = _417 * exp2(log2(max(0.0f, (_389 + -0.8359375f)) / (18.8515625f - (_389 * 18.6875f))) * 6.277394771575928f);
                      float _420 = _417 * exp2(log2(max(0.0f, (_390 + -0.8359375f)) / (18.8515625f - (_390 * 18.6875f))) * 6.277394771575928f);
                      float _423 = mad(-0.07285170257091522f, _420, mad(-0.5876399874687195f, _419, (_418 * 1.6604909896850586f)));
                      float _426 = mad(-0.00834800023585558f, _420, mad(1.1328999996185303f, _419, (_418 * -0.124549999833107f)));
                      float _429 = mad(1.1187299489974976f, _420, mad(-0.10057900100946426f, _419, (_418 * -0.018151000142097473f)));
                      do {
                        if (!_371) {
                          _438 = ((_360 - _423) * _50.w);
                          _439 = ((_361 - _426) * _50.w);
                          _440 = ((_362 - _429) * _50.w);
                        } else {
                          _438 = _360;
                          _439 = _361;
                          _440 = _362;
                        }
                        _445 = _373;
                        _446 = _372;
                        _447 = (_438 + _423);
                        _448 = (_439 + _426);
                        _449 = (_440 + _429);
                      } while (false);
                    } while (false);
                  }
                  float _461 = 10000.0f / whitePaperNitsForOverlay;

                  float _470 = exp2(log2(saturate(mad(0.04331360012292862f, _449, mad(0.3292819857597351f, _448, (_447 * 0.627403974533081f))) / _461)) * 0.1593017578125f);
                  float _482 = exp2(log2(saturate(mad(0.011361200362443924f, _449, mad(0.9195399880409241f, _448, (_447 * 0.06909699738025665f))) / _461)) * 0.1593017578125f);
                  float _494 = exp2(log2(saturate(mad(0.8955950140953064f, _449, mad(0.08801320195198059f, _448, (_447 * 0.01639159955084324f))) / _461)) * 0.1593017578125f);

                  if (CUSTOM_SHOW_UI != 0.f) {
                    RWResult[int2(_446, _445)] = float3(saturate(exp2(log2(((_470 * 18.8515625f) + 0.8359375f) / ((_470 * 18.6875f) + 1.0f)) * 78.84375f)), saturate(exp2(log2(((_482 * 18.8515625f) + 0.8359375f) / ((_482 * 18.6875f) + 1.0f)) * 78.84375f)), saturate(exp2(log2(((_494 * 18.8515625f) + 0.8359375f) / ((_494 * 18.6875f) + 1.0f)) * 78.84375f)));
                  }
                } while (false);
              } while (false);
            }
          } while (false);
        }
      }
    }
  }
  float4 _188 = GUIImage.SampleLevel(PointClamp, float2(_46, _47), 0.0f);

#if 1
  if (TONE_MAP_TYPE != 0.f) {
    if (RENODX_GAMMA_CORRECTION_UI != 0.f) {
      _188.rgb = renodx::color::correct::GammaSafe(_188.rgb);
    }
  }
#endif
  if (CUSTOM_SHOW_UI != 0.f) {
    RWResult[int2(((int)(min16uint)(_33)), ((int)(min16uint)(_38)))] = float3(_188.x, _188.y, _188.z);
  }
}
