#include "./shared.h"

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
  float SceneInfo_Reserve0 : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  uint blueNoiseJitterIndex : packoffset(c038.z);
  float2 SceneInfo_Reserve2 : packoffset(c039.x);
};

cbuffer HDRMapping : register(b1) {
  float whitePaperNits : packoffset(c000.x);
  float configImageAlphaScale : packoffset(c000.y);
  float displayMaxNits : packoffset(c000.z);
  float displayMinNits : packoffset(c000.w);
  float4 displayMaxNitsRect : packoffset(c001.x);
  float4 secondaryDisplayMaxNitsRect : packoffset(c002.x);
  float4 standardMaxNitsRect : packoffset(c003.x);
  float4 secondaryStandardMaxNitsRect : packoffset(c004.x);
  float2 displayMaxNitsRectSize : packoffset(c005.x);
  float2 standardMaxNitsRectSize : packoffset(c005.z);
  float4 mdrOutRangeRect : packoffset(c006.x);
  uint drawMode : packoffset(c007.x);
  float gammaForHDR : packoffset(c007.y);
  float displayMaxNitsST2084 : packoffset(c007.z);
  float displayMinNitsST2084 : packoffset(c007.w);
  uint drawModeOnMDRPass : packoffset(c008.x);
  float saturationForHDR : packoffset(c008.y);
  float2 targetInvSize : packoffset(c008.z);
  float toeEnd : packoffset(c009.x);
  float toeStrength : packoffset(c009.y);
  float blackPoint : packoffset(c009.z);
  float shoulderStartPoint : packoffset(c009.w);
  float shoulderStrength : packoffset(c010.x);
  float whitePaperNitsForOverlay : packoffset(c010.y);
  float saturationOnDisplayMapping : packoffset(c010.z);
  float graphScale : packoffset(c010.w);
  float4 hdrImageRect : packoffset(c011.x);
  float2 hdrImageRectSize : packoffset(c012.x);
  float secondaryDisplayMaxNits : packoffset(c012.z);
  float secondaryDisplayMinNits : packoffset(c012.w);
  float2 secondaryDisplayMaxNitsRectSize : packoffset(c013.x);
  float2 secondaryStandardMaxNitsRectSize : packoffset(c013.z);
  float shoulderAngle : packoffset(c014.x);
  uint enableHDRAdjustmentForOverlay : packoffset(c014.y);
  float brightnessAdjustmentForOverlay : packoffset(c014.z);
  float saturateAdjustmentForOverlay : packoffset(c014.w);
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
  min16int _15 = min16int((uint)(SV_GroupThreadID.x));
  min16int _17 = (min16uint)(_15) >> 1;
  min16int _20 = (min16uint)(_15) >> 2;
  min16int _23 = (min16uint)(_15) >> 3;
  min16int _32 = ((min16int)(((min16int)(((min16int)(((min16int)(_15 & 1)) | ((min16uint)((min16int)(min16int((uint)(SV_GroupID.x))) << 4)))) | ((min16int)(_17 & 2)))) | ((min16int)(_20 & 4)))) | ((min16int)(_23 & 8));
  min16int _37 = ((min16int)(((min16int)(((min16int)(((min16int)(_17 & 1)) | ((min16uint)((min16int)(min16int((uint)(SV_GroupID.y))) << 4)))) | ((min16int)(_20 & 2)))) | ((min16int)(_23 & 4)))) | ((min16int)(((min16int)((min16uint)(_15) >> 4)) & 8));
  float4 _49 = GUIImage.SampleLevel(PointClamp, float2(((float((min16uint)_32) + 0.5f) * screenInverseSize.x), ((float((min16uint)_37) + 0.5f) * screenInverseSize.y)), 0.0f);
  float _56 = 1.0f / _49.w;
  float _60 = saturate(_49.x * _56);
  float _61 = saturate(_49.y * _56);
  float _62 = saturate(_49.z * _56);
  float _99 = (exp2(log2((_60 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f) * float((bool)((bool)(!(_60 <= 0.040449999272823334f))))) + ((_60 * 0.07739938050508499f) * float((bool)(bool)(_60 <= 0.040449999272823334f)));
  float _100 = (exp2(log2((_61 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f) * float((bool)((bool)(!(_61 <= 0.040449999272823334f))))) + ((_61 * 0.07739938050508499f) * float((bool)(bool)(_61 <= 0.040449999272823334f)));
  float _101 = (exp2(log2((_62 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f) * float((bool)((bool)(!(_62 <= 0.040449999272823334f))))) + ((_62 * 0.07739938050508499f) * float((bool)(bool)(_62 <= 0.040449999272823334f)));

  float3 correctUI = renodx::color::correct::GammaSafe(float3(_99, _100, _101));
  _99 = correctUI.x;
  _100 = correctUI.y;
  _101 = correctUI.z;
  float _118;
  float _119;
  float _120;
  float _290;
  float _291;
  float _292;
  bool _301;
  float _368;
  float _369;
  float _370;
  int _375;
  int _376;
  float _377;
  float _378;
  float _379;
  if (!((_49.w + -0.003000000026077032f) < 0.0f)) {
    do {
      if (_49.w > 0.0f) {
        float _113 = 1.0f / ((float((uint)((int)(((uint)((int)(guiShaderCommonFlag)) >> 8) & 1))) * (1.0f - _49.w)) + _49.w);
        _118 = (_113 * _99);
        _119 = (_113 * _100);
        _120 = (_113 * _101);
      } else {
        _118 = _99;
        _119 = _100;
        _120 = _101;
      }
      bool _123 = (max(max(_118, _119), _120) == 0.0f);
      bool _124 = (_49.w == 0.0f);
      if (!(_124 && _123)) {
        do {
          if (!(enableHDRAdjustmentForOverlay == 0)) {
            float _145 = exp2(log2(mad(0.0810546875f, _120, mad(0.623046875f, _119, (_118 * 0.295654296875f))) * 0.009999999776482582f) * 0.1593017578125f);
            float _154 = saturate(exp2(log2(((_145 * 18.8515625f) + 0.8359375f) / ((_145 * 18.6875f) + 1.0f)) * 78.84375f));
            float _158 = exp2(log2(mad(0.116455078125f, _120, mad(0.727294921875f, _119, (_118 * 0.15625f))) * 0.009999999776482582f) * 0.1593017578125f);
            float _167 = saturate(exp2(log2(((_158 * 18.8515625f) + 0.8359375f) / ((_158 * 18.6875f) + 1.0f)) * 78.84375f));
            float _171 = exp2(log2(mad(0.808349609375f, _120, mad(0.156494140625f, _119, (_118 * 0.03515625f))) * 0.009999999776482582f) * 0.1593017578125f);
            float _180 = saturate(exp2(log2(((_171 * 18.8515625f) + 0.8359375f) / ((_171 * 18.6875f) + 1.0f)) * 78.84375f));
            float _182 = (_167 + _154) * 0.5f;
            float _190 = exp2(log2(saturate(_182)) * 0.012683313339948654f);
            float _199 = exp2(log2(max(0.0f, (_190 + -0.8359375f)) / (18.8515625f - (_190 * 18.6875f))) * 6.277394771575928f) * 100.0f;
            float _212 = exp2(log2(((brightnessAdjustmentForOverlay * 0.009999999776482582f) * _199) * ((((brightnessAdjustmentForOverlay + -1.0f) * _49.w) * _199) + 1.0f)) * 0.1593017578125f);
            float _221 = saturate(exp2(log2(((_212 * 18.8515625f) + 0.8359375f) / ((_212 * 18.6875f) + 1.0f)) * 78.84375f));
            float _224 = min((_182 / _221), (_221 / _182));
            float _225 = ((dot(float3(_154, _167, _180), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * saturateAdjustmentForOverlay) * _224;
            float _226 = ((dot(float3(_154, _167, _180), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * saturateAdjustmentForOverlay) * _224;
            float _236 = exp2(log2(saturate(mad(0.11100000143051147f, _226, mad(0.008999999612569809f, _225, _221)))) * 0.012683313339948654f);
            float _244 = exp2(log2(max(0.0f, (_236 + -0.8359375f)) / (18.8515625f - (_236 * 18.6875f))) * 6.277394771575928f);
            float _248 = exp2(log2(saturate(mad(-0.11100000143051147f, _226, mad(-0.008999999612569809f, _225, _221)))) * 0.012683313339948654f);
            float _257 = exp2(log2(max(0.0f, (_248 + -0.8359375f)) / (18.8515625f - (_248 * 18.6875f))) * 6.277394771575928f) * 100.0f;
            float _261 = exp2(log2(saturate(mad(-0.32100000977516174f, _226, mad(0.5600000023841858f, _225, _221)))) * 0.012683313339948654f);
            float _270 = exp2(log2(max(0.0f, (_261 + -0.8359375f)) / (18.8515625f - (_261 * 18.6875f))) * 6.277394771575928f) * 100.0f;
            float _273 = mad(0.2070000022649765f, _270, mad(-1.3270000219345093f, _257, (_244 * 207.10000610351562f)));
            float _276 = mad(-0.04500000178813934f, _270, mad(0.6809999942779541f, _257, (_244 * 36.5f)));
            float _279 = mad(1.187999963760376f, _270, mad(-0.05000000074505806f, _257, (_244 * -4.900000095367432f)));
            _290 = mad(-0.49861079454421997f, _279, mad(-1.5373831987380981f, _276, (_273 * 3.2409698963165283f)));
            _291 = mad(0.041555095463991165f, _279, mad(1.8759677410125732f, _276, (_273 * -0.9692437052726746f)));
            _292 = mad(1.0569714307785034f, _279, mad(-0.2039768397808075f, _276, (_273 * 0.055630069226026535f)));
          } else {
            _290 = _118;
            _291 = _119;
            _292 = _120;
          }
          do {
            [branch]
            if (_49.w == 1.0f) {
              _375 = ((int)(min16uint)(_37));
              _376 = ((int)(min16uint)(_32));
              _377 = _290;
              _378 = _291;
              _379 = _292;
            } else {
              do {
                if (_124) {
                  _301 = (!_123);
                } else {
                  _301 = false;
                }
                int _302 = (int)(min16uint)(_32);
                int _303 = (int)(min16uint)(_37);
                float3 _305 = RWResult.Load(int2(_302, _303));
                float _318 = exp2(log2(saturate(_305.x)) * 0.012683313339948654f);
                float _319 = exp2(log2(saturate(_305.y)) * 0.012683313339948654f);
                float _320 = exp2(log2(saturate(_305.z)) * 0.012683313339948654f);
                float _347 = 10000.0f / whitePaperNitsForOverlay;
                _347 = 10000.f / RENODX_GRAPHICS_WHITE_NITS;
                float _348 = _347 * exp2(log2(max(0.0f, (_318 + -0.8359375f)) / (18.8515625f - (_318 * 18.6875f))) * 6.277394771575928f);
                float _349 = _347 * exp2(log2(max(0.0f, (_319 + -0.8359375f)) / (18.8515625f - (_319 * 18.6875f))) * 6.277394771575928f);
                float _350 = _347 * exp2(log2(max(0.0f, (_320 + -0.8359375f)) / (18.8515625f - (_320 * 18.6875f))) * 6.277394771575928f);
                float _353 = mad(-0.07285170257091522f, _350, mad(-0.5876399874687195f, _349, (_348 * 1.6604909896850586f)));
                float _356 = mad(-0.00834800023585558f, _350, mad(1.1328999996185303f, _349, (_348 * -0.124549999833107f)));
                float _359 = mad(1.1187299489974976f, _350, mad(-0.10057900100946426f, _349, (_348 * -0.018151000142097473f)));
                do {
                  if (!_301) {
                    _368 = ((_290 - _353) * _49.w);
                    _369 = ((_291 - _356) * _49.w);
                    _370 = ((_292 - _359) * _49.w);
                  } else {
                    _368 = _290;
                    _369 = _291;
                    _370 = _292;
                  }
                  _375 = _303;
                  _376 = _302;
                  _377 = (_368 + _353);
                  _378 = (_369 + _356);
                  _379 = (_370 + _359);
                } while (false);
              } while (false);
            }
            float _391 = 10000.0f / whitePaperNitsForOverlay;
            _391 = 10000.f / RENODX_GRAPHICS_WHITE_NITS;
            float _400 = exp2(log2(saturate(mad(0.04331360012292862f, _379, mad(0.3292819857597351f, _378, (_377 * 0.627403974533081f))) / _391)) * 0.1593017578125f);
            float _412 = exp2(log2(saturate(mad(0.011361200362443924f, _379, mad(0.9195399880409241f, _378, (_377 * 0.06909699738025665f))) / _391)) * 0.1593017578125f);
            float _424 = exp2(log2(saturate(mad(0.8955950140953064f, _379, mad(0.08801320195198059f, _378, (_377 * 0.01639159955084324f))) / _391)) * 0.1593017578125f);
            RWResult[int2(_376, _375)] = float3(saturate(exp2(log2(((_400 * 18.8515625f) + 0.8359375f) / ((_400 * 18.6875f) + 1.0f)) * 78.84375f)), saturate(exp2(log2(((_412 * 18.8515625f) + 0.8359375f) / ((_412 * 18.6875f) + 1.0f)) * 78.84375f)), saturate(exp2(log2(((_424 * 18.8515625f) + 0.8359375f) / ((_424 * 18.6875f) + 1.0f)) * 78.84375f)));
          } while (false);
        } while (false);
      }
    } while (false);
  }
}
