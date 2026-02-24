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
//   float4 mdrOutRangeRect : packoffset(c006.x);
//   uint drawMode : packoffset(c007.x);
//   float gammaForHDR : packoffset(c007.y);
//   float displayMaxNitsST2084 : packoffset(c007.z);
//   float displayMinNitsST2084 : packoffset(c007.w);
//   uint drawModeOnMDRPass : packoffset(c008.x);
//   float saturationForHDR : packoffset(c008.y);
//   float2 targetInvSize : packoffset(c008.z);
//   float toeEnd : packoffset(c009.x);
//   float toeStrength : packoffset(c009.y);
//   float blackPoint : packoffset(c009.z);
//   float shoulderStartPoint : packoffset(c009.w);
//   float shoulderStrength : packoffset(c010.x);
//   float whitePaperNitsForOverlay : packoffset(c010.y);
//   float saturationOnDisplayMapping : packoffset(c010.z);
//   float graphScale : packoffset(c010.w);
//   float4 hdrImageRect : packoffset(c011.x);
//   float2 hdrImageRectSize : packoffset(c012.x);
//   float secondaryDisplayMaxNits : packoffset(c012.z);
//   float secondaryDisplayMinNits : packoffset(c012.w);
//   float2 secondaryDisplayMaxNitsRectSize : packoffset(c013.x);
//   float2 secondaryStandardMaxNitsRectSize : packoffset(c013.z);
//   float shoulderAngle : packoffset(c014.x);
//   uint enableHDRAdjustmentForOverlay : packoffset(c014.y);
//   float brightnessAdjustmentForOverlay : packoffset(c014.z);
//   float saturateAdjustmentForOverlay : packoffset(c014.w);
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
  float _239;
  float _240;
  float _241;
  bool _250;
  float _317;
  float _318;
  float _319;
  int _324;
  int _325;
  float _326;
  float _327;
  float _328;
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
      if (!(enableHDRAdjustmentForOverlay == 0)) {
        float _96 = exp2(log2(mad(0.0810546875f, _71, mad(0.623046875f, _70, (_69 * 0.295654296875f))) * 0.009999999776482582f) * 0.1593017578125f);
        float _105 = saturate(exp2(log2(((_96 * 18.8515625f) + 0.8359375f) / ((_96 * 18.6875f) + 1.0f)) * 78.84375f));
        float _109 = exp2(log2(mad(0.116455078125f, _71, mad(0.727294921875f, _70, (_69 * 0.15625f))) * 0.009999999776482582f) * 0.1593017578125f);
        float _118 = saturate(exp2(log2(((_109 * 18.8515625f) + 0.8359375f) / ((_109 * 18.6875f) + 1.0f)) * 78.84375f));
        float _122 = exp2(log2(mad(0.808349609375f, _71, mad(0.156494140625f, _70, (_69 * 0.03515625f))) * 0.009999999776482582f) * 0.1593017578125f);
        float _131 = saturate(exp2(log2(((_122 * 18.8515625f) + 0.8359375f) / ((_122 * 18.6875f) + 1.0f)) * 78.84375f));
        float _133 = (_118 + _105) * 0.5f;
        float _139 = exp2(log2(saturate(_133)) * 0.012683313339948654f);
        float _148 = exp2(log2(max(0.0f, (_139 + -0.8359375f)) / (18.8515625f - (_139 * 18.6875f))) * 6.277394771575928f) * 100.0f;
        float _159 = exp2(log2(((brightnessAdjustmentForOverlay * 0.009999999776482582f) * _148) * ((((brightnessAdjustmentForOverlay + -1.0f) * _48.w) * _148) + 1.0f)) * 0.1593017578125f);
        float _168 = saturate(exp2(log2(((_159 * 18.8515625f) + 0.8359375f) / ((_159 * 18.6875f) + 1.0f)) * 78.84375f));
        float _173 = min((_133 / _168), (_168 / _133)) * (saturateAdjustmentForOverlay * 0.000244140625f);
        float _174 = _173 * dot(float3(_105, _118, _131), float3(6610.0f, -13613.0f, 7003.0f));
        float _175 = _173 * dot(float3(_105, _118, _131), float3(17933.0f, -17390.0f, -543.0f));
        float _185 = exp2(log2(saturate(mad(0.11100000143051147f, _175, mad(0.008999999612569809f, _174, _168)))) * 0.012683313339948654f);
        float _193 = exp2(log2(max(0.0f, (_185 + -0.8359375f)) / (18.8515625f - (_185 * 18.6875f))) * 6.277394771575928f);
        float _197 = exp2(log2(saturate(mad(-0.11100000143051147f, _175, mad(-0.008999999612569809f, _174, _168)))) * 0.012683313339948654f);
        float _206 = exp2(log2(max(0.0f, (_197 + -0.8359375f)) / (18.8515625f - (_197 * 18.6875f))) * 6.277394771575928f) * 100.0f;
        float _210 = exp2(log2(saturate(mad(-0.32100000977516174f, _175, mad(0.5600000023841858f, _174, _168)))) * 0.012683313339948654f);
        float _219 = exp2(log2(max(0.0f, (_210 + -0.8359375f)) / (18.8515625f - (_210 * 18.6875f))) * 6.277394771575928f) * 100.0f;
        float _222 = mad(0.2070000022649765f, _219, mad(-1.3270000219345093f, _206, (_193 * 207.10000610351562f)));
        float _225 = mad(-0.04500000178813934f, _219, mad(0.6809999942779541f, _206, (_193 * 36.5f)));
        float _228 = mad(1.187999963760376f, _219, mad(-0.05000000074505806f, _206, (_193 * -4.900000095367432f)));
        _239 = mad(-0.49861079454421997f, _228, mad(-1.5373831987380981f, _225, (_222 * 3.2409698963165283f)));
        _240 = mad(0.041555095463991165f, _228, mad(1.8759677410125732f, _225, (_222 * -0.9692437052726746f)));
        _241 = mad(1.0569714307785034f, _228, mad(-0.2039768397808075f, _225, (_222 * 0.055630069226026535f)));
      } else {
        _239 = _69;
        _240 = _70;
        _241 = _71;
      }
      do {
        [branch]
        if (_48.w == 1.0f) {
          _324 = ((int)(min16uint)(_36));
          _325 = ((int)(min16uint)(_31));
          _326 = _239;
          _327 = _240;
          _328 = _241;
        } else {
          do {
            if (_75) {
              _250 = (!_74);
            } else {
              _250 = false;
            }
            int _251 = (int)(min16uint)(_31);
            int _252 = (int)(min16uint)(_36);
            float3 _254 = RWResult.Load(int2(_251, _252));
            float _267 = exp2(log2(saturate(_254.x)) * 0.012683313339948654f);
            float _268 = exp2(log2(saturate(_254.y)) * 0.012683313339948654f);
            float _269 = exp2(log2(saturate(_254.z)) * 0.012683313339948654f);
            float _296 = 10000.0f / whitePaperNitsForOverlay;
            float _297 = _296 * exp2(log2(max(0.0f, (_267 + -0.8359375f)) / (18.8515625f - (_267 * 18.6875f))) * 6.277394771575928f);
            float _298 = _296 * exp2(log2(max(0.0f, (_268 + -0.8359375f)) / (18.8515625f - (_268 * 18.6875f))) * 6.277394771575928f);
            float _299 = _296 * exp2(log2(max(0.0f, (_269 + -0.8359375f)) / (18.8515625f - (_269 * 18.6875f))) * 6.277394771575928f);
            float _302 = mad(-0.07285170257091522f, _299, mad(-0.5876399874687195f, _298, (_297 * 1.6604909896850586f)));
            float _305 = mad(-0.00834800023585558f, _299, mad(1.1328999996185303f, _298, (_297 * -0.124549999833107f)));
            float _308 = mad(1.1187299489974976f, _299, mad(-0.10057900100946426f, _298, (_297 * -0.018151000142097473f)));
            do {
              if (!_250) {
                _317 = ((_239 - _302) * _48.w);
                _318 = ((_240 - _305) * _48.w);
                _319 = ((_241 - _308) * _48.w);
              } else {
                _317 = _239;
                _318 = _240;
                _319 = _241;
              }
              _324 = _252;
              _325 = _251;
              _326 = (_317 + _302);
              _327 = (_318 + _305);
              _328 = (_319 + _308);
            } while (false);
          } while (false);
        }
        float _340 = 10000.0f / whitePaperNitsForOverlay;
#if 1
        if (TONE_MAP_TYPE != 0.f) {
          if (RENODX_GAMMA_CORRECTION != 0.f) {
            _326 = renodx::color::correct::GammaSafe(_326);
            _327 = renodx::color::correct::GammaSafe(_327);
            _328 = renodx::color::correct::GammaSafe(_328);
          }
        }
#endif
        float _349 = exp2(log2(saturate(mad(0.04331360012292862f, _328, mad(0.3292819857597351f, _327, (_326 * 0.627403974533081f))) / _340)) * 0.1593017578125f);
        float _361 = exp2(log2(saturate(mad(0.011361200362443924f, _328, mad(0.9195399880409241f, _327, (_326 * 0.06909699738025665f))) / _340)) * 0.1593017578125f);
        float _373 = exp2(log2(saturate(mad(0.8955950140953064f, _328, mad(0.08801320195198059f, _327, (_326 * 0.01639159955084324f))) / _340)) * 0.1593017578125f);
        RWResult[int2(_325, _324)] = float3(saturate(exp2(log2(((_349 * 18.8515625f) + 0.8359375f) / ((_349 * 18.6875f) + 1.0f)) * 78.84375f)), saturate(exp2(log2(((_361 * 18.8515625f) + 0.8359375f) / ((_361 * 18.6875f) + 1.0f)) * 78.84375f)), saturate(exp2(log2(((_373 * 18.8515625f) + 0.8359375f) / ((_373 * 18.6875f) + 1.0f)) * 78.84375f)));
      } while (false);
    } while (false);
  }
}
