#include "./shared.h"

Texture3D<float3> g_TmToneMapLookup : register(t0);

Texture2D<float3> g_TmRadianceMap : register(t1);

Texture2D<float3> g_TmBloomMap : register(t2);

Texture2D<float3> g_TmLensFlareMap : register(t3);

Texture2D<float3> g_TmAnamorphicLensFlareMap : register(t4);

Texture2D<float3> g_TmAnamoprhicLensFlareGarbageMap : register(t5);

Texture2D<float3> g_TmChromaticAbMap : register(t6);

Texture2D<float> g_TmFilmGrainNoise : register(t7);

StructuredBuffer<float> g_TmAdaptedLumBuffer : register(t8);

Texture2D<float4> g_TmSrgbOverlayMap : register(t9);

RWTexture2D<float4> g_TmOutput : register(u0);

RWTexture2D<float4> g_TmOutputHudless : register(u1);

// clang-format off
cbuffer ToneMapCBuffer : register(b2) {
  struct ToneMapCB {
    float2 m_PixelScale;
    uint2 m_MirrorConsts;
    int4 m_DispatchOffset;
    float2 m_GrainTexDims;
    float2 m_GrainTexDimsRcp;
    int2 m_GrainTexOffset;
    float m_GrainStrength;
    float m_InvAspectRatio;
    float m_AcesMiddleGray;
    float m_VignetteHorzScale;
    float m_VignetteVertScale;
    float m_VignetteCenterClear;
    float m_SharpenCenter;
    float m_SharpenSide;
    float m_SharpenCorner;
    float m_HdrGamma;
    float m_ChromAbUvScale;
    float m_ChromAbRadScale;
    float m_ChromAbRadBias;
    float m_ChromAbBlurRamp;
    float2 m_SrgbOverlayScale;
    float2 m_SrgbOverlayBias;
    float4 m_FullScreenFade;
    float m_IsOffscreen;
    float m_PcGamma;
    float m_ToneMappingScale;
    float m_ApplyToneMappingScale;
    float m_HdrWhitePoint;
    float m_AspectBlurStart;
    float m_AspectBlurEnd;
    float m_AspectBlurRadius;
    float m_AspectBlurTapScale;
    int m_AspectBlurMode;
    float2 m_PixelOffset;
    uint m_DoBloom;
    uint m_DoFilmGrain;
    uint m_DoSharpen;
    uint m_DoChromaticAB;
    uint m_DoLensFlare;
    float m_InvAdaptationLum;
    float m_WriteHudless;
    uint m_Pad;
  } g_TM : packoffset(c000.x);
};
// clang-format on

SamplerState g_PointClampSampler : register(s0);

SamplerState g_LinearClampSampler : register(s2);

SamplerState g_LinearWrapSampler : register(s3);

groupshared float _global_0[128];

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  uint _33 = (int)(g_TM.m_DispatchOffset.x) + SV_DispatchThreadID.x;
  uint _34 = (int)(g_TM.m_DispatchOffset.y) + SV_DispatchThreadID.y;
  int _39 = select((g_TM.m_MirrorConsts.x != 0), ((uint)((int)(g_TM.m_MirrorConsts.x) - _33)), _33);
  float _168;
  float _245;
  float _246;
  float _247;
  float _248;
  float _262;
  float _263;
  float _264;
  float _360;
  float _361;
  float _362;
  float _484;
  float _485;
  float _486;
  float _664;
  float _665;
  float _666;
  float _667;
  float _668;
  float _669;
  if (!(g_TM.m_DoSharpen == 0)) {
    int _41 = _39 & 7;
    int _42 = _34 & 7;
    int _44 = _41 | (_42 << 3);
    int _46 = (uint)((int)(_44 * 3277)) >> 14;
    uint _51 = ((uint)(((int)(_46 * -5)) + _44)) << 1;
    float _61 = g_TM.m_PixelScale.x * (float((uint)((_39 - _41) + _51)) + 0.5f);
    float _62 = g_TM.m_PixelScale.y * (float((uint)((_34 - _42) + _46)) + 0.5f);
    float3 _65 = g_TmRadianceMap.SampleLevel(g_PointClampSampler, float2(_61, _62), 0.0f, int2(-1, -1));
    float3 _69 = g_TmRadianceMap.SampleLevel(g_PointClampSampler, float2(_61, _62), 0.0f, int2(0, -1));
    uint _80 = _51 + ((int)(_46 * 10));
    _global_0[_80] = log2(max(dot(float3(_65.x, _65.y, _65.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)), 9.999999747378752e-06f));
    _global_0[(_80 | 1)] = log2(max(dot(float3(_69.x, _69.y, _69.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)), 9.999999747378752e-06f));
    GroupMemoryBarrierWithGroupSync();
    int _85 = _41 + (_42 * 10);
    float _88 = _global_0[(_85 + 11)];
    float _92 = _88 + -0.6000000238418579f;
    float _93 = _88 + 0.6000000238418579f;
    _168 = exp2((((((((((g_TM.m_SharpenCenter * _88) - _88) + (g_TM.m_SharpenCorner * min(max((_global_0[_85]), _92), _93))) + (g_TM.m_SharpenSide * min(max((_global_0[(_85 + 1)]), _92), _93))) + (g_TM.m_SharpenCorner * min(max((_global_0[(_85 + 2)]), _92), _93))) + (g_TM.m_SharpenSide * min(max((_global_0[(_85 + 10)]), _92), _93))) + (g_TM.m_SharpenSide * min(max((_global_0[(_85 + 12)]), _92), _93))) + (g_TM.m_SharpenCorner * min(max((_global_0[(_85 + 20)]), _92), _93))) + (g_TM.m_SharpenSide * min(max((_global_0[(_85 + 21)]), _92), _93))) + (g_TM.m_SharpenCorner * min(max((_global_0[(_85 + 22)]), _92), _93)));
  } else {
    _168 = 1.0f;
  }
  float _176 = g_TM.m_PixelScale.x * (float((uint)_39) + 0.5f);
  float _177 = g_TM.m_PixelScale.y * (float((uint)_34) + 0.5f);
  float3 _180 = g_TmRadianceMap.SampleLevel(g_LinearClampSampler, float2(_176, _177), 0.0f);
  if (!(g_TM.m_DoChromaticAB == 0)) {
    float _190 = (_176 * 2.0f) + -1.0f;
    float _191 = ((_177 * 2.0f) * g_TM.m_InvAspectRatio) - g_TM.m_InvAspectRatio;
    float _193 = sqrt(dot(float2(_190, _191), float2(_190, _191)));
    float _199 = saturate((g_TM.m_ChromAbRadScale * _193) - g_TM.m_ChromAbRadBias);
    [branch]
    if (_199 > 0.0f) {
      float _203 = g_TM.m_ChromAbUvScale * _199;
      float _205 = _203 * (1.0f / _193);
      float _206 = _205 * _190;
      float _207 = _205 * _191;
      float _213 = (saturate((_203 * 3840.0f) + -1.0f) * (1.0f - _168)) + _168;
      float _214 = _176 - _206;
      float _215 = _177 - _207;
      float3 _216 = g_TmRadianceMap.SampleLevel(g_LinearClampSampler, float2(_214, _215), 0.0f);
      float _218 = _206 + _176;
      float _219 = _207 + _177;
      float3 _220 = g_TmRadianceMap.SampleLevel(g_LinearClampSampler, float2(_218, _219), 0.0f);
      if (g_TM.m_ChromAbBlurRamp > 0.0f) {
        float _227 = saturate((g_TM.m_ChromAbBlurRamp * _199) + -1.0f);
        float3 _229 = g_TmChromaticAbMap.SampleLevel(g_LinearClampSampler, float2(_214, _215), 0.0f);
        float3 _231 = g_TmChromaticAbMap.SampleLevel(g_LinearClampSampler, float2(_176, _177), 0.0f);
        float3 _233 = g_TmChromaticAbMap.SampleLevel(g_LinearClampSampler, float2(_218, _219), 0.0f);
        _245 = (lerp(_216.x, _229.x, _227));
        _246 = (lerp(_180.y, _231.y, _227));
        _247 = (lerp(_220.z, _233.z, _227));
        _248 = _213;
      } else {
        _245 = _216.x;
        _246 = _180.y;
        _247 = _220.z;
        _248 = _213;
      }
    } else {
      _245 = _180.x;
      _246 = _180.y;
      _247 = _180.z;
      _248 = _168;
    }
  } else {
    _245 = _180.x;
    _246 = _180.y;
    _247 = _180.z;
    _248 = _168;
  }
  float _249 = _248 * _245;
  float _250 = _248 * _246;
  float _251 = _248 * _247;
  if (!(g_TM.m_DoBloom == 0)) {
    float3 _254 = g_TmBloomMap.SampleLevel(g_LinearClampSampler, float2(_176, _177), 0.0f);
    _262 = (_254.x + _249);
    _263 = (_254.y + _250);
    _264 = (_254.z + _251);
  } else {
    _262 = _249;
    _263 = _250;
    _264 = _251;
  }
  if ((bool)(g_TM.m_DoLensFlare != 0) && (bool)(g_TM.m_DoLensFlare != 0)) {
    float3 _271 = g_TmLensFlareMap.SampleLevel(g_LinearClampSampler, float2(_176, _177), 0.0f);
    float _281 = g_TM.m_PixelOffset.x + _176;
    float _282 = g_TM.m_PixelOffset.y + _177;
    float3 _284 = g_TmAnamorphicLensFlareMap.SampleLevel(g_LinearClampSampler, float2(_281, _282), 0.0f);
    bool _288 = (_284.y < _284.z);
    float _289 = select(_288, _284.z, _284.y);
    float _290 = select(_288, _284.y, _284.z);
    bool _293 = (_284.x < _289);
    float _294 = select(_293, _289, _284.x);
    float _296 = select(_293, _284.x, _289);
    float _298 = _294 - min(_296, _290);
    float _306 = _298 / (_294 + 1.000000013351432e-10f);
    float3 _311 = g_TmAnamoprhicLensFlareGarbageMap.SampleLevel(g_LinearWrapSampler, float2((_281 * 2.0f), (_282 * 2.0f)), 0.0f);
    float _316 = (abs(select(_293, select(_288, 0.6666666865348816f, -0.3333333432674408f), select(_288, -1.0f, 0.0f)) + ((_296 - _290) / ((_298 * 6.0f) + 1.000000013351432e-10f))) + -0.25f) + (_311.x * 0.5f);
    float _320 = select((_316 < 0.0f), (_316 + 1.0f), _316) * 6.0f;
    float _342 = (((saturate(abs(_320 + -3.0f) + -1.0f) + -1.0f) * _306) + 1.0f) * _294;
    float _343 = (((saturate(2.0f - abs(_320 + -2.0f)) + -1.0f) * _306) + 1.0f) * _294;
    float _344 = (((saturate(2.0f - abs(_320 + -4.0f)) + -1.0f) * _306) + 1.0f) * _294;
    float _347 = (pow(_311.y, 8.0f));
    float _351 = _347 * 16.0f;
    _360 = ((_271.x + _262) + (((_342 * _342) * 16.0f) * _347));
    _361 = ((_271.y + _263) + ((_343 * _343) * _351));
    _362 = ((_271.z + _264) + ((_344 * _344) * _351));
  } else {
    _360 = _262;
    _361 = _263;
    _362 = _264;
  }
  uint _369 = (int)(g_TM.m_DispatchOffset.x) + SV_DispatchThreadID.x;
  uint _370 = (int)(g_TM.m_DispatchOffset.y) + SV_DispatchThreadID.y;
  int _375 = select((g_TM.m_MirrorConsts.x != 0), ((uint)((int)(g_TM.m_MirrorConsts.x) - _369)), _369);
  float _380 = (float((uint)_370) + 0.5f) * g_TM.m_PixelScale.y;
  float _391 = ((g_TM.m_PixelScale.x * (float((uint)_369) + 0.5f)) * g_TM.m_SrgbOverlayScale.x) + g_TM.m_SrgbOverlayBias.x;
  float _392 = (g_TM.m_SrgbOverlayScale.y * _380) + g_TM.m_SrgbOverlayBias.y;
  float _398 = saturate((1.0f - max(abs(_391), abs(_392))) * 4096.0f);
  float4 _404 = g_TmSrgbOverlayMap.SampleLevel(g_LinearClampSampler, float2(((_391 * 0.5f) + 0.5f), ((_392 * 0.5f) + 0.5f)), 0.0f);
  float _421 = g_TM.m_VignetteHorzScale * (((g_TM.m_PixelScale.x * 2.0f) * (float((uint)_375) + 0.5f)) + -1.0f);
  float _422 = g_TM.m_VignetteVertScale * ((_380 * 2.0f) + -1.0f);
  float _427 = max((sqrt(dot(float2(_421, _422), float2(_421, _422))) - g_TM.m_VignetteCenterClear), 0.0f);
  float _430 = 1.0f / ((_427 * _427) + 1.0f);
  float _431 = _430 * _430;
  float _432 = _431 * _360;
  float _433 = _431 * _361;
  float _434 = _431 * _362;
  if (!(g_TM.m_DoFilmGrain == 0)) {
    uint _439 = (int)(g_TM.m_GrainTexOffset.x) + _375;
    uint _440 = (int)(g_TM.m_GrainTexOffset.y) + _370;
    int _441 = g_TM.m_GrainTexOffset.y ^ g_TM.m_GrainTexOffset.x;
    int _445 = select(((_441 & 2) != 0), (0 - _439), _439);
    bool _447 = ((_441 & 1) != 0);
    float _468 = g_TmFilmGrainNoise.Load(int3(int(g_TM.m_GrainTexDims.x * frac((float((int)(select(_447, _440, _445))) + 0.5f) * g_TM.m_GrainTexDimsRcp.x)), int(g_TM.m_GrainTexDims.y * frac((float((int)(select(_447, _445, _440))) + 0.5f) * g_TM.m_GrainTexDimsRcp.y)), 0));
    float _471 = _468.x * 2.0f;
    float _479 = ((select((_468.x >= 0.5f), _471, (1.0f / (2.0f - _471))) + -1.0f) * g_TM.m_GrainStrength) + 1.0f;
    _484 = (_479 * _432);
    _485 = (_479 * _433);
    _486 = (_479 * _434);
  } else {
    _484 = _432;
    _485 = _433;
    _486 = _434;
  }
  float _489 = g_TmAdaptedLumBuffer[1];
  float _491 = g_TM.m_AcesMiddleGray * _489;
  float3 _505 = g_TmToneMapLookup.SampleLevel(g_LinearClampSampler, float3(((log2(_491 * _484) * 0.0538194440305233f) + 0.553819477558136f), ((log2(_491 * _485) * 0.0538194440305233f) + 0.553819477558136f), ((log2(_491 * _486) * 0.0538194440305233f) + 0.553819477558136f)), 0.0f);
  float _513 = select((!(g_TM.m_ApplyToneMappingScale == 0.0f)), g_TM.m_ToneMappingScale, 1.0f);
  float _514 = _513 * _505.x;
  float _515 = _513 * _505.y;
  float _516 = _513 * _505.z;
  float _518 = -0.0f - (_398 * (_404.w + -1.0f));
  float _522 = (_514 * _518) + (_404.x * _398);
  float _523 = (_515 * _518) + (_404.y * _398);
  float _524 = (_516 * _518) + (_404.z * _398);
  float _536 = ((g_TM.m_FullScreenFade.x - _522) * g_TM.m_FullScreenFade.w) + _522;
  float _537 = ((g_TM.m_FullScreenFade.y - _523) * g_TM.m_FullScreenFade.w) + _523;
  float _538 = ((g_TM.m_FullScreenFade.z - _524) * g_TM.m_FullScreenFade.w) + _524;
  float _545 = ((g_TM.m_FullScreenFade.x - _514) * g_TM.m_FullScreenFade.w) + _514;
  float _546 = ((g_TM.m_FullScreenFade.y - _515) * g_TM.m_FullScreenFade.w) + _515;
  float _547 = ((g_TM.m_FullScreenFade.z - _516) * g_TM.m_FullScreenFade.w) + _516;
  [branch]
  if (!(g_TM.m_HdrGamma == 0.0f)) {
#if RENODX_ENABLE_GAMMA_ADJUST
    float _560 = (pow(_536, RENODX_GAMMA_ADJUST_VALUE));
    float _561 = (pow(_537, RENODX_GAMMA_ADJUST_VALUE));
    float _562 = (pow(_538, RENODX_GAMMA_ADJUST_VALUE));
#else
    float _560 = (pow(_536, g_TM.m_HdrGamma));
    float _561 = (pow(_537, g_TM.m_HdrGamma));
    float _562 = (pow(_538, g_TM.m_HdrGamma));
#endif
    float _563 = g_TM.m_HdrWhitePoint * 9.999999747378752e-05f;
    float _582 = exp2(log2(mad(0.043299999088048935f, _562, mad(0.3292999863624573f, _561, (_560 * 0.6273999810218811f))) * _563) * 0.1593017578125f);
    float _583 = exp2(log2(mad(0.01140000019222498f, _562, mad(0.9194999933242798f, _561, (_560 * 0.06909999996423721f))) * _563) * 0.1593017578125f);
    float _584 = exp2(log2(mad(0.8956000208854675f, _562, mad(0.08799999952316284f, _561, (_560 * 0.01640000008046627f))) * _563) * 0.1593017578125f);
#if RENODX_ENABLE_GAMMA_ADJUST
    float _615 = (pow(_545, RENODX_GAMMA_ADJUST_VALUE));
    float _616 = (pow(_546, RENODX_GAMMA_ADJUST_VALUE));
    float _617 = (pow(_547, RENODX_GAMMA_ADJUST_VALUE));
#else
    float _615 = (pow(_545, g_TM.m_HdrGamma));
    float _616 = (pow(_546, g_TM.m_HdrGamma));
    float _617 = (pow(_547, g_TM.m_HdrGamma));
#endif
    float _636 = exp2(log2(mad(0.043299999088048935f, _617, mad(0.3292999863624573f, _616, (_615 * 0.6273999810218811f))) * _563) * 0.1593017578125f);
    float _637 = exp2(log2(mad(0.01140000019222498f, _617, mad(0.9194999933242798f, _616, (_615 * 0.06909999996423721f))) * _563) * 0.1593017578125f);
    float _638 = exp2(log2(mad(0.8956000208854675f, _617, mad(0.08799999952316284f, _616, (_615 * 0.01640000008046627f))) * _563) * 0.1593017578125f);
    _664 = exp2(log2(((_582 * 18.8515625f) + 0.8359375f) / ((_582 * 18.6875f) + 1.0f)) * 78.84375f);
    _665 = exp2(log2(((_583 * 18.8515625f) + 0.8359375f) / ((_583 * 18.6875f) + 1.0f)) * 78.84375f);
    _666 = exp2(log2(((_584 * 18.8515625f) + 0.8359375f) / ((_584 * 18.6875f) + 1.0f)) * 78.84375f);
    _667 = exp2(log2(((_636 * 18.8515625f) + 0.8359375f) / ((_636 * 18.6875f) + 1.0f)) * 78.84375f);
    _668 = exp2(log2(((_637 * 18.8515625f) + 0.8359375f) / ((_637 * 18.6875f) + 1.0f)) * 78.84375f);
    _669 = exp2(log2(((_638 * 18.8515625f) + 0.8359375f) / ((_638 * 18.6875f) + 1.0f)) * 78.84375f);
  } else {
    _664 = _536;
    _665 = _537;
    _666 = _538;
    _667 = _545;
    _668 = _546;
    _669 = _547;
  }
  g_TmOutput[int2(_369, _370)] = float4(_664, _665, _666, 1.0f);
  if (!(g_TM.m_WriteHudless == 0.0f)) {
    g_TmOutputHudless[int2(_369, _370)] = float4(_667, _668, _669, 1.0f);
  }
}
