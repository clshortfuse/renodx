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

cbuffer OutputColorAdjustment : register(b1) {
  float fGamma : packoffset(c000.x);
  float fLowerLimit : packoffset(c000.y);
  float fUpperLimit : packoffset(c000.z);
  float fConvertToLimit : packoffset(c000.w);
  float4 fConfigDrawRect : packoffset(c001.x);
  float4 fSecondaryConfigDrawRect : packoffset(c002.x);
  float2 fConfigDrawRectSize : packoffset(c003.x);
  float2 fSecondaryConfigDrawRectSize : packoffset(c003.z);
  uint uConfigMode : packoffset(c004.x);
  float fConfigImageIntensity : packoffset(c004.y);
  float fSecondaryConfigImageIntensity : packoffset(c004.z);
  float fConfigImageAlphaScale : packoffset(c004.w);
  float fGammaForOverlay : packoffset(c005.x);
  float fLowerLimitForOverlay : packoffset(c005.y);
  float fConvertToLimitForOverlay : packoffset(c005.z);
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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

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
  bool _213;
  float _255;
  float _266;
  float _277;
  float _286;
  float _287;
  float _288;
  float _293;
  float _294;
  float _295;
  float _306;
  float _317;
  float _328;
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
  float _218;
  float _219;
  float _220;
  float _231;
  float _235;
  float _242;
  float _243;
  float _244;
  _17 = int16_t((int)(SV_GroupThreadID.x));
  _19 = (uint16_t)(_17) >> 1;
  _22 = (uint16_t)(_17) >> 2;
  _25 = (uint16_t)(_17) >> 3;
  _34 = ((int)(((int)(((int)(((int)(_17 & 1)) | ((int)((int)(int16_t((int)(SV_GroupID.x))) << 4)))) | ((int)(_19 & 2)))) | ((int)(_22 & 4)))) | ((int)(_25 & 8));
  _39 = ((int)(((int)(((int)(((int)(_19 & 1)) | ((int)((int)(int16_t((int)(SV_GroupID.y))) << 4)))) | ((int)(_22 & 2)))) | ((int)(_25 & 4)))) | ((int)(((int)((uint16_t)(_17) >> 4)) & 8));
  _51 = GUIImage.SampleLevel(PointClamp, float2(((((float)((uint16_t)_34)) + 0.5f) * screenInverseSize.x), ((((float)((uint16_t)_39)) + 0.5f) * screenInverseSize.y)), 0.0f);
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
          _293 = _199;
          _294 = _200;
          _295 = _201;
          [branch]
          if (!(_51.w == 1.0f)) {
            do {
              _213 = false;
              if (_205) {
                _213 = (!_204);
              }
              _218 = RWResult[int2(((int)(min16uint)(_34)), ((int)(min16uint)(_39)))].x;
              _219 = RWResult[int2(((int)(min16uint)(_34)), ((int)(min16uint)(_39)))].y;
              _220 = RWResult[int2(((int)(min16uint)(_34)), ((int)(min16uint)(_39)))].z;
              _231 = 1.0f / fConvertToLimitForOverlay;
              _235 = 1.0f / fGammaForOverlay;
              _242 = exp2(log2(_231 * max((_218 - fLowerLimitForOverlay), 0.0f)) * _235);
              _243 = exp2(log2(_231 * max((_219 - fLowerLimitForOverlay), 0.0f)) * _235);
              _244 = exp2(log2(_231 * max((_220 - fLowerLimitForOverlay), 0.0f)) * _235);
              do {
                [branch]
                if (!(!(_242 <= 0.040449999272823334f))) {
                  _255 = (_242 * 0.07739938050508499f);
                } else {
                  _255 = exp2(log2((_242 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                }
                do {
                  [branch]
                  if (!(!(_243 <= 0.040449999272823334f))) {
                    _266 = (_243 * 0.07739938050508499f);
                  } else {
                    _266 = exp2(log2((_243 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                  }
                  do {
                    [branch]
                    if (!(!(_244 <= 0.040449999272823334f))) {
                      _277 = (_244 * 0.07739938050508499f);
                    } else {
                      _277 = exp2(log2((_244 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                    }
                    do {
                      _286 = _199;
                      _287 = _200;
                      _288 = _201;
                      if (!(_213)) {
                        _286 = ((_199 - _255) * _51.w);
                        _287 = ((_200 - _266) * _51.w);
                        _288 = ((_201 - _277) * _51.w);
                      }
                      _293 = (_286 + _255);
                      _294 = (_287 + _266);
                      _295 = (_288 + _277);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          }
          do {
            [branch]
            if (!(!(_293 <= 0.0031308000907301903f))) {
              _306 = (_293 * 12.920000076293945f);
            } else {
              _306 = (((pow(_293, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            do {
              [branch]
              if (!(!(_294 <= 0.0031308000907301903f))) {
                _317 = (_294 * 12.920000076293945f);
              } else {
                _317 = (((pow(_294, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
              }
              do {
                [branch]
                if (!(!(_295 <= 0.0031308000907301903f))) {
                  _328 = (_295 * 12.920000076293945f);
                } else {
                  _328 = (((pow(_295, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                }
                if (CUSTOM_SHOW_UI) {
                  RWResult[int2(((int)(min16uint)(_34)), ((int)(min16uint)(_39)))] = float3((((pow(_306, fGammaForOverlay)) * fConvertToLimitForOverlay) + fLowerLimitForOverlay), (((pow(_317, fGammaForOverlay)) * fConvertToLimitForOverlay) + fLowerLimitForOverlay), (((pow(_328, fGammaForOverlay)) * fConvertToLimitForOverlay) + fLowerLimitForOverlay));
                }
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      }
    } while (false);
  }
}
