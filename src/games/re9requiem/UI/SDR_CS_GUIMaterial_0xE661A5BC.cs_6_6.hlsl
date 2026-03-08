#include "../common.hlsli"

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

SamplerState PointClamp : register(s1, space32);

[numthreads(256, 1, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  min16int _14 = min16int((uint)(SV_GroupThreadID.x));
  min16int _16 = (min16uint)(_14) >> 1;
  min16int _19 = (min16uint)(_14) >> 2;
  min16int _22 = (min16uint)(_14) >> 3;
  min16int _31 = ((min16int)(((min16int)(((min16int)(((min16int)(_14 & 1)) | ((min16uint)((min16int)(min16int((uint)(SV_GroupID.x))) << 4)))) | ((min16int)(_16 & 2)))) | ((min16int)(_19 & 4)))) | ((min16int)(_22 & 8));
  min16int _36 = ((min16int)(((min16int)(((min16int)(((min16int)(_16 & 1)) | ((min16uint)((min16int)(min16int((uint)(SV_GroupID.y))) << 4)))) | ((min16int)(_19 & 2)))) | ((min16int)(_22 & 4)))) | ((min16int)(((min16int)((min16uint)(_14) >> 4)) & 8));
  float4 _48 = GUIImage.SampleLevel(PointClamp, float2(((float((min16uint)_31) + 0.5f) * screenInverseSize.x), ((float((min16uint)_36) + 0.5f) * screenInverseSize.y)), 0.0f);
  float _69;
  float _70;
  float _71;
  bool _83;
  float _125;
  float _136;
  float _147;
  float _156;
  float _157;
  float _158;
  float _163;
  float _164;
  float _165;
  float _176;
  float _187;
  float _198;
  if (_48.w > 0.0f) {
    float _64 = 1.0f / ((float((uint)((int)(((uint)((int)(guiShaderCommonFlag)) >> 8) & 1))) * (1.0f - _48.w)) + _48.w);
    _69 = (_64 * _48.x);
    _70 = (_64 * _48.y);
    _71 = (_64 * _48.z);
  } else {
    _69 = _48.x;
    _70 = _48.y;
    _71 = _48.z;
  }
  bool _74 = (max(max(_69, _70), _71) == 0.0f);
  bool _75 = (_48.w == 0.0f);
  if (!(_75 && _74)) {
    do {
      [branch]
      if (!(_48.w == 1.0f)) {
        do {
          if (_75) {
            _83 = (!_74);
          } else {
            _83 = false;
          }
          float3 _87 = RWResult.Load(int2(((int)(min16uint)(_31)), ((int)(min16uint)(_36))));
          float _101 = 1.0f / fConvertToLimitForOverlay;
          float _105 = 1.0f / fGammaForOverlay;
          float _112 = exp2(log2(_101 * max((_87.x - fLowerLimitForOverlay), 0.0f)) * _105);
          float _113 = exp2(log2(_101 * max((_87.y - fLowerLimitForOverlay), 0.0f)) * _105);
          float _114 = exp2(log2(_101 * max((_87.z - fLowerLimitForOverlay), 0.0f)) * _105);
          do {
            [branch]
            if (!(!(_112 <= 0.040449999272823334f))) {
              _125 = (_112 * 0.07739938050508499f);
            } else {
              _125 = exp2(log2((_112 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            }
            do {
              [branch]
              if (!(!(_113 <= 0.040449999272823334f))) {
                _136 = (_113 * 0.07739938050508499f);
              } else {
                _136 = exp2(log2((_113 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
              }
              do {
                [branch]
                if (!(!(_114 <= 0.040449999272823334f))) {
                  _147 = (_114 * 0.07739938050508499f);
                } else {
                  _147 = exp2(log2((_114 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                }
                do {
                  if (!_83) {
                    _156 = ((_69 - _125) * _48.w);
                    _157 = ((_70 - _136) * _48.w);
                    _158 = ((_71 - _147) * _48.w);
                  } else {
                    _156 = _69;
                    _157 = _70;
                    _158 = _71;
                  }
                  _163 = (_156 + _125);
                  _164 = (_157 + _136);
                  _165 = (_158 + _147);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        _163 = _69;
        _164 = _70;
        _165 = _71;
      }
      do {
        [branch]
        if (!(!(_163 <= 0.0031308000907301903f))) {
          _176 = (_163 * 12.920000076293945f);
        } else {
          _176 = (((pow(_163, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          [branch]
          if (!(!(_164 <= 0.0031308000907301903f))) {
            _187 = (_164 * 12.920000076293945f);
          } else {
            _187 = (((pow(_164, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            [branch]
            if (!(!(_165 <= 0.0031308000907301903f))) {
              _198 = (_165 * 12.920000076293945f);
            } else {
              _198 = (((pow(_165, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            if (CUSTOM_SHOW_UI != 0.f) {
              RWResult[int2(((int)(min16uint)(_31)), ((int)(min16uint)(_36)))] = float3((((pow(_176, fGammaForOverlay))*fConvertToLimitForOverlay) + fLowerLimitForOverlay), (((pow(_187, fGammaForOverlay))*fConvertToLimitForOverlay) + fLowerLimitForOverlay), (((pow(_198, fGammaForOverlay))*fConvertToLimitForOverlay) + fLowerLimitForOverlay));
            }
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  }
}
