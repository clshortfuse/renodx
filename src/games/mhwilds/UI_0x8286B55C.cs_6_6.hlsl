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
  float2 SceneInfo_Reserve2 : packoffset(c038.z);
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
  bool _439;
  float _506;
  float _507;
  float _508;
  float _650;
  float _651;
  float _652;
  if (!((_49.w + -0.003000000026077032f) < 0.0f)) {
    if (_49.w > 0.0f) {
      float _113 = 1.0f / ((float((uint)((int)(((uint)(guiShaderCommonFlag) >> 8) & 1))) * (1.0f - _49.w)) + _49.w);
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
      if (!((uint)(enableHDRAdjustmentForOverlay) == 0)) {
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
      [branch]
      if (_49.w == 1.0f) {
        float _299 = mad(0.04331360012292862f, _292, mad(0.3292819857597351f, _291, (_290 * 0.627403974533081f)));
        float _302 = mad(0.011361200362443924f, _292, mad(0.9195399880409241f, _291, (_290 * 0.06909699738025665f)));
        float _305 = mad(0.8955950140953064f, _292, mad(0.08801320195198059f, _291, (_290 * 0.01639159955084324f)));
        float _328 = 10000.0f / whitePaperNitsForOverlay;

        _328 = 10000.f / RENODX_GRAPHICS_WHITE_NITS;

        float _337 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_290 - _299)) + _299) * gammaForHDR) / _328)) * 0.1593017578125f);
        float _346 = saturate(exp2(log2(((_337 * 18.8515625f) + 0.8359375f) / ((_337 * 18.6875f) + 1.0f)) * 78.84375f));
        float _349 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_291 - _302)) + _302) * gammaForHDR) / _328)) * 0.1593017578125f);
        float _358 = saturate(exp2(log2(((_349 * 18.8515625f) + 0.8359375f) / ((_349 * 18.6875f) + 1.0f)) * 78.84375f));
        float _361 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_292 - _305)) + _305) * gammaForHDR) / _328)) * 0.1593017578125f);
        float _370 = saturate(exp2(log2(((_361 * 18.8515625f) + 0.8359375f) / ((_361 * 18.6875f) + 1.0f)) * 78.84375f));
        if (!(((uint)(drawMode) & 2) == 0)) {
          float _382 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
          float _391 = saturate(exp2(log2(((_382 * 18.8515625f) + 0.8359375f) / ((_382 * 18.6875f) + 1.0f)) * 78.84375f));
          float _397 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
          float _407 = _391 - saturate(exp2(log2(((_397 * 18.8515625f) + 0.8359375f) / ((_397 * 18.6875f) + 1.0f)) * 78.84375f));
          float _411 = saturate(_346 / _391);
          float _412 = saturate(_358 / _391);
          float _413 = saturate(_370 / _391);
          _650 = min(((((2.0f - (_411 + _411)) * _407) + (_411 * _391)) * _411), _346);
          _651 = min(((((2.0f - (_412 + _412)) * _407) + (_412 * _391)) * _412), _358);
          _652 = min(((((2.0f - (_413 + _413)) * _407) + (_413 * _391)) * _413), _370);
        } else {
          _650 = _346;
          _651 = _358;
          _652 = _370;
        }
      } else {
        if (_124) {
          _439 = (!_123);
        } else {
          _439 = false;
        }
        float3 _443 = RWResult.Load(int2(((min16uint)(_32)), ((min16uint)(_37))));
        float _456 = exp2(log2(saturate(_443.x)) * 0.012683313339948654f);
        float _457 = exp2(log2(saturate(_443.y)) * 0.012683313339948654f);
        float _458 = exp2(log2(saturate(_443.z)) * 0.012683313339948654f);
        float _485 = 10000.0f / whitePaperNitsForOverlay;

        _485 = 10000.f / RENODX_GRAPHICS_WHITE_NITS;

        float _486 = _485 * exp2(log2(max(0.0f, (_456 + -0.8359375f)) / (18.8515625f - (_456 * 18.6875f))) * 6.277394771575928f);
        float _487 = _485 * exp2(log2(max(0.0f, (_457 + -0.8359375f)) / (18.8515625f - (_457 * 18.6875f))) * 6.277394771575928f);
        float _488 = _485 * exp2(log2(max(0.0f, (_458 + -0.8359375f)) / (18.8515625f - (_458 * 18.6875f))) * 6.277394771575928f);
        float _491 = mad(-0.07285170257091522f, _488, mad(-0.5876399874687195f, _487, (_486 * 1.6604909896850586f)));
        float _494 = mad(-0.00834800023585558f, _488, mad(1.1328999996185303f, _487, (_486 * -0.124549999833107f)));
        float _497 = mad(1.1187299489974976f, _488, mad(-0.10057900100946426f, _487, (_486 * -0.018151000142097473f)));
        if (!_439) {
          _506 = ((_290 - _491) * _49.w);
          _507 = ((_291 - _494) * _49.w);
          _508 = ((_292 - _497) * _49.w);
        } else {
          _506 = _290;
          _507 = _291;
          _508 = _292;
        }
        float _509 = _506 + _491;
        float _510 = _507 + _494;
        float _511 = _508 + _497;
        float _514 = mad(0.04331360012292862f, _511, mad(0.3292819857597351f, _510, (_509 * 0.627403974533081f)));
        float _517 = mad(0.011361200362443924f, _511, mad(0.9195399880409241f, _510, (_509 * 0.06909699738025665f)));
        float _520 = mad(0.8955950140953064f, _511, mad(0.08801320195198059f, _510, (_509 * 0.01639159955084324f)));
        float _551 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_509 - _514)) + _514) * gammaForHDR) / _485)) * 0.1593017578125f);
        float _560 = saturate(exp2(log2(((_551 * 18.8515625f) + 0.8359375f) / ((_551 * 18.6875f) + 1.0f)) * 78.84375f));
        float _563 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_510 - _517)) + _517) * gammaForHDR) / _485)) * 0.1593017578125f);
        float _572 = saturate(exp2(log2(((_563 * 18.8515625f) + 0.8359375f) / ((_563 * 18.6875f) + 1.0f)) * 78.84375f));
        float _575 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_511 - _520)) + _520) * gammaForHDR) / _485)) * 0.1593017578125f);
        float _584 = saturate(exp2(log2(((_575 * 18.8515625f) + 0.8359375f) / ((_575 * 18.6875f) + 1.0f)) * 78.84375f));
        if (!(((uint)(drawMode) & 2) == 0)) {
          float _596 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
          float _605 = saturate(exp2(log2(((_596 * 18.8515625f) + 0.8359375f) / ((_596 * 18.6875f) + 1.0f)) * 78.84375f));
          float _611 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
          float _621 = _605 - saturate(exp2(log2(((_611 * 18.8515625f) + 0.8359375f) / ((_611 * 18.6875f) + 1.0f)) * 78.84375f));
          float _625 = saturate(_560 / _605);
          float _626 = saturate(_572 / _605);
          float _627 = saturate(_584 / _605);
          _650 = min(((((2.0f - (_625 + _625)) * _621) + (_625 * _605)) * _625), _560);
          _651 = min(((((2.0f - (_626 + _626)) * _621) + (_626 * _605)) * _626), _572);
          _652 = min(((((2.0f - (_627 + _627)) * _621) + (_627 * _605)) * _627), _584);
        } else {
          _650 = _560;
          _651 = _572;
          _652 = _584;
        }
      }
      RWResult[int2(((min16uint)(_32)), ((min16uint)(_37)))] = float4(_650, _651, _652, _650);
    }
  }
}
