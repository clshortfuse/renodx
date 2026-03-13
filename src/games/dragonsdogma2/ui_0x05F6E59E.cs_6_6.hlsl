#include "shared.h"

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
  float2 projectionSpaceJitterOffset : packoffset(c037.x);
  float2 SceneInfo_Reserve2 : packoffset(c037.z);
};

cbuffer HDRMapping : register(b1) {
  float whitePaperNits : packoffset(c000.x);
  float configImageAlphaScale : packoffset(c000.y);
  float displayMaxNits : packoffset(c000.z);
  float displayMinNits : packoffset(c000.w);
  float4 displayMaxNitsRect : packoffset(c001.x);
  float4 standardMaxNitsRect : packoffset(c002.x);
  float4 mdrOutRangeRect : packoffset(c003.x);
  uint drawMode : packoffset(c004.x);
  float gammaForHDR : packoffset(c004.y);
  float2 configDrawRectSize : packoffset(c004.z);
  float displayMaxNitsST2084 : packoffset(c005.x);
  float displayMinNitsST2084 : packoffset(c005.y);
  float2 targetInvSize : packoffset(c005.z);
  uint drawModeOnMDRPass : packoffset(c006.x);
  float saturationForHDR : packoffset(c006.y);
  float whitePaperNitsForOverlay : packoffset(c006.z);
};

SamplerState PointClamp : register(s1, space32);

[numthreads(256, 1, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  min16int _13 = min16int((uint)(SV_GroupThreadID.x));
  min16int _15 = (min16uint)(_13) >> 1;
  min16int _18 = (min16uint)(_13) >> 2;
  min16int _21 = (min16uint)(_13) >> 3;
  min16int _30 = ((min16int)(((min16int)(((min16int)(((min16int)(_13 & 1)) | ((min16uint)((min16int)(min16int((uint)(SV_GroupID.x))) << 4)))) | ((min16int)(_15 & 2)))) | ((min16int)(_18 & 4)))) | ((min16int)(_21 & 8));
  min16int _35 = ((min16int)(((min16int)(((min16int)(((min16int)(_15 & 1)) | ((min16uint)((min16int)(min16int((uint)(SV_GroupID.y))) << 4)))) | ((min16int)(_18 & 2)))) | ((min16int)(_21 & 4)))) | ((min16int)(((min16int)((min16uint)(_13) >> 4)) & 8));
  float4 _47 = GUIImage.SampleLevel(PointClamp, float2(((float((min16uint)_30) + 0.5f) * screenInverseSize.x), ((float((min16uint)_35) + 0.5f) * screenInverseSize.y)), 0.0f);

  if (RENODX_GAMMA_CORRECTION == 1.f && RENODX_TONE_MAP_TYPE != 0.f) {
    _47.xyz = renodx::color::correct::GammaSafe(_47.xyz);
  }
  
  float _52 = 1.0f / _47.w;
  float _53 = _47.x * _52;
  float _54 = _47.y * _52;
  float _55 = _47.z * _52;
  float _394;
  float _395;
  float _396;
  [branch]
  if (!(_47.w == 0.0f)) {
    float _61 = RENODX_TONE_MAP_TYPE == 0 ? 10000.0f / whitePaperNitsForOverlay : 10000.0f / RENODX_GRAPHICS_WHITE_NITS;
    bool _68 = ((drawMode & 2) == 0);
    do {
      [branch]
      if (_47.w == 1.0f) {
        float _72 = mad(0.04331360012292862f, _55, mad(0.3292819857597351f, _54, (_53 * 0.627403974533081f)));
        float _75 = mad(0.011361200362443924f, _55, mad(0.9195399880409241f, _54, (_53 * 0.06909699738025665f)));
        float _78 = mad(0.8955950140953064f, _55, mad(0.08801320195198059f, _54, (_53 * 0.01639159955084324f)));
        float _109 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_53 - _72)) + _72) * gammaForHDR) / _61)) * 0.1593017578125f);
        float _110 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_54 - _75)) + _75) * gammaForHDR) / _61)) * 0.1593017578125f);
        float _111 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_55 - _78)) + _78) * gammaForHDR) / _61)) * 0.1593017578125f);
        float _136 = saturate(exp2(log2(((_109 * 18.8515625f) + 0.8359375f) / ((_109 * 18.6875f) + 1.0f)) * 78.84375f));
        float _137 = saturate(exp2(log2(((_110 * 18.8515625f) + 0.8359375f) / ((_110 * 18.6875f) + 1.0f)) * 78.84375f));
        float _138 = saturate(exp2(log2(((_111 * 18.8515625f) + 0.8359375f) / ((_111 * 18.6875f) + 1.0f)) * 78.84375f));
        if (!_68) {
          float _146 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
          float _155 = saturate(exp2(log2(((_146 * 18.8515625f) + 0.8359375f) / ((_146 * 18.6875f) + 1.0f)) * 78.84375f));
          float _161 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
          float _171 = _155 - saturate(exp2(log2(((_161 * 18.8515625f) + 0.8359375f) / ((_161 * 18.6875f) + 1.0f)) * 78.84375f));
          float _175 = saturate(_136 / _155);
          float _176 = saturate(_137 / _155);
          float _177 = saturate(_138 / _155);
          _394 = min(((((2.0f - (_175 + _175)) * _171) + (_175 * _155)) * _175), _136);
          _395 = min(((((2.0f - (_176 + _176)) * _171) + (_176 * _155)) * _176), _137);
          _396 = min(((((2.0f - (_177 + _177)) * _171) + (_177 * _155)) * _177), _138);
        } else {
          _394 = _136;
          _395 = _137;
          _396 = _138;
        }
      } else {
        float3 _203 = RWResult.Load(int2(((int)(min16uint)(_30)), ((int)(min16uint)(_35))));
        float _216 = exp2(log2(saturate(_203.x)) * 0.012683313339948654f);
        float _217 = exp2(log2(saturate(_203.y)) * 0.012683313339948654f);
        float _218 = exp2(log2(saturate(_203.z)) * 0.012683313339948654f);
        float _243 = _61 * exp2(log2(max(0.0f, (_216 + -0.8359375f)) / (18.8515625f - (_216 * 18.6875f))) * 6.277394771575928f);
        float _244 = _61 * exp2(log2(max(0.0f, (_217 + -0.8359375f)) / (18.8515625f - (_217 * 18.6875f))) * 6.277394771575928f);
        float _245 = _61 * exp2(log2(max(0.0f, (_218 + -0.8359375f)) / (18.8515625f - (_218 * 18.6875f))) * 6.277394771575928f);
        float _248 = mad(-0.07285170257091522f, _245, mad(-0.5876399874687195f, _244, (_243 * 1.6604909896850586f)));
        float _251 = mad(-0.00834800023585558f, _245, mad(1.1328999996185303f, _244, (_243 * -0.124549999833107f)));
        float _254 = mad(1.1187299489974976f, _245, mad(-0.10057900100946426f, _244, (_243 * -0.018151000142097473f)));
        float _261 = ((_53 - _248) * _47.w) + _248;
        float _262 = ((_54 - _251) * _47.w) + _251;
        float _263 = ((_55 - _254) * _47.w) + _254;
        float _266 = mad(0.04331360012292862f, _263, mad(0.3292819857597351f, _262, (_261 * 0.627403974533081f)));
        float _269 = mad(0.011361200362443924f, _263, mad(0.9195399880409241f, _262, (_261 * 0.06909699738025665f)));
        float _272 = mad(0.8955950140953064f, _263, mad(0.08801320195198059f, _262, (_261 * 0.01639159955084324f)));
        float _303 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_261 - _266)) + _266) * gammaForHDR) / _61)) * 0.1593017578125f);
        float _304 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_262 - _269)) + _269) * gammaForHDR) / _61)) * 0.1593017578125f);
        float _305 = exp2(log2(saturate(exp2(log2((saturationForHDR * (_263 - _272)) + _272) * gammaForHDR) / _61)) * 0.1593017578125f);
        float _330 = saturate(exp2(log2(((_303 * 18.8515625f) + 0.8359375f) / ((_303 * 18.6875f) + 1.0f)) * 78.84375f));
        float _331 = saturate(exp2(log2(((_304 * 18.8515625f) + 0.8359375f) / ((_304 * 18.6875f) + 1.0f)) * 78.84375f));
        float _332 = saturate(exp2(log2(((_305 * 18.8515625f) + 0.8359375f) / ((_305 * 18.6875f) + 1.0f)) * 78.84375f));
        if (!_68) {
          float _340 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
          float _349 = saturate(exp2(log2(((_340 * 18.8515625f) + 0.8359375f) / ((_340 * 18.6875f) + 1.0f)) * 78.84375f));
          float _355 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
          float _365 = _349 - saturate(exp2(log2(((_355 * 18.8515625f) + 0.8359375f) / ((_355 * 18.6875f) + 1.0f)) * 78.84375f));
          float _369 = saturate(_330 / _349);
          float _370 = saturate(_331 / _349);
          float _371 = saturate(_332 / _349);
          _394 = min(((((2.0f - (_369 + _369)) * _365) + (_369 * _349)) * _369), _330);
          _395 = min(((((2.0f - (_370 + _370)) * _365) + (_370 * _349)) * _370), _331);
          _396 = min(((((2.0f - (_371 + _371)) * _365) + (_371 * _349)) * _371), _332);
        } else {
          _394 = _330;
          _395 = _331;
          _396 = _332;
        }
      }
      RWResult[int2(((int)(min16uint)(_30)), ((int)(min16uint)(_35)))] = float3(_394, _395, _396);
    } while (false);
  }
}
