#include "./shared.h"

Texture3D<float3> g_TmToneMapLookup : register(t5);

Texture2D<float3> g_TmRadianceMap : register(t6);

Texture3D<float3> g_TmColorFilterMap : register(t9);

Texture2D<float4> g_TmFilmGrainNoise : register(t10);

StructuredBuffer<float> g_TmAdaptedLumBuffer : register(t11);

Texture2D<float4> g_TmSrgbOverlayMap : register(t12);

Texture2D<float3> g_TmRadianceBlurMap : register(t13);

RWTexture2D<float4> g_TmOutput : register(u0);

RWTexture2D<float4> g_TmOutputHudless : register(u1);

// clang-format off
cbuffer ToneMapCBuffer : register(b2) {
  struct ToneMapCB {
    float4 m_PixelScale;
    float m_GrainUvScale;
    float m_GrainStrength;
    float m_GrainRandom;
    float m_InvAspectRatio;
    float m_AcesMiddleGray;
    float m_VignetteHorzScale;
    float m_VignetteVertScale;
    float m_VignetteCenterClear;
    float m_SharpenCenter;
    float m_SharpenSide;
    float m_SharpenCorner;
    float m_HdrGamma;
    float m_IsOffscreen;
    float m_ChromAbUvScale;
    float m_ChromAbRadScale;
    float m_ChromAbRadBias;
    float2 m_VignetteOffset;
    float m_FrostedHudScale;
    float m_FrostedHudBias;
    float2 m_SrgbOverlayScale;
    float2 m_SrgbOverlayBias;
    float m_ColorFilterStrength;
    float m_Contrast;
    float m_ToneMappingScale;
    float m_ApplyToneMappingScale;
    float m_HdrWhitePoint;
    float m_AspectBlurStart;
    float m_AspectBlurEnd;
    float m_AspectBlurRadius;
    float m_AspectBlurTapScale;
    float m_InvAdaptationLum;
    float m_WriteHudless;
    float m_Pad;
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
  int _17 = (uint)(SV_DispatchThreadID.x) & 7;
  int _18 = (uint)(SV_DispatchThreadID.y) & 7;
  int _20 = (_18 << 3) | _17;
  int _22 = (uint)((int)(_20 * 3277)) >> 14;
  uint _27 = ((uint)(((int)(_22 * -5)) + _20)) << 1;
  float _37 = (float((uint)((SV_DispatchThreadID.x - _17) + _27)) + 0.5f) * g_TM.m_PixelScale.x;
  float _38 = (float((uint)((SV_DispatchThreadID.y - _18) + _22)) + 0.5f) * g_TM.m_PixelScale.y;
  float3 _41 = g_TmRadianceMap.SampleLevel(g_PointClampSampler, float2(_37, _38), 0.0f, int2(-1, -1));
  float3 _45 = g_TmRadianceMap.SampleLevel(g_PointClampSampler, float2(_37, _38), 0.0f, int2(0, -1));
  uint _56 = _27 + ((int)(_22 * 10));
  _global_0[_56] = log2(max(dot(float3(_41.x, _41.y, _41.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)), 9.999999747378752e-06f));
  _global_0[(_56 | 1)] = log2(max(dot(float3(_45.x, _45.y, _45.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)), 9.999999747378752e-06f));
  GroupMemoryBarrierWithGroupSync();
  int _61 = (_18 * 10) + _17;
  float _64 = _global_0[(_61 + 11)];
  float _68 = _64 + -0.6000000238418579f;
  float _69 = _64 + 0.6000000238418579f;
  float _142 = exp2((((((((((g_TM.m_SharpenCenter * _64) - _64) + (g_TM.m_SharpenCorner * min(max((_global_0[_61]), _68), _69))) + (g_TM.m_SharpenSide * min(max((_global_0[(_61 + 1)]), _68), _69))) + (g_TM.m_SharpenCorner * min(max((_global_0[(_61 + 2)]), _68), _69))) + (g_TM.m_SharpenSide * min(max((_global_0[(_61 + 10)]), _68), _69))) + (g_TM.m_SharpenSide * min(max((_global_0[(_61 + 12)]), _68), _69))) + (g_TM.m_SharpenCorner * min(max((_global_0[(_61 + 20)]), _68), _69))) + (g_TM.m_SharpenSide * min(max((_global_0[(_61 + 21)]), _68), _69))) + (g_TM.m_SharpenCorner * min(max((_global_0[(_61 + 22)]), _68), _69)));
  float _150 = g_TM.m_PixelScale.x * (float((uint)SV_DispatchThreadID.x) + 0.5f);
  float _151 = g_TM.m_PixelScale.y * (float((uint)SV_DispatchThreadID.y) + 0.5f);
  float3 _154 = g_TmRadianceMap.SampleLevel(g_LinearClampSampler, float2(_150, _151), 0.0f);
  float _158 = _154.x * _142;
  float _159 = _154.y * _142;
  float _160 = _154.z * _142;
  float _183;
  float _184;
  float _185;
  float _310;
  float _311;
  float _312;
  float _461;
  float _462;
  float _463;
  float _464;
  float _465;
  float _466;
  float _582;
  float _583;
  float _584;
  float _585;
  float _586;
  float _587;
  [branch]
  if (!(g_TM.m_Contrast == 0.0f)) {
    float _166 = saturate(dot(float3(_158, _159, _160), float3(0.30000001192092896f, 0.5f, 0.20000000298023224f)));
    float _178 = ((((((_166 * _166) * _166) * ((((_166 * 6.0f) + -15.0f) * _166) + 10.0f)) - _166) * g_TM.m_Contrast) + _166) / max(_166, 9.999999747378752e-06f);
    _183 = (_178 * _158);
    _184 = (_178 * _159);
    _185 = (_178 * _160);
  } else {
    _183 = _158;
    _184 = _159;
    _185 = _160;
  }
  float _193 = (_150 * g_TM.m_SrgbOverlayScale.x) + g_TM.m_SrgbOverlayBias.x;
  float _194 = (_151 * g_TM.m_SrgbOverlayScale.y) + g_TM.m_SrgbOverlayBias.y;
  float _200 = saturate((1.0f - max(abs(_193), abs(_194))) * 4096.0f);
  float4 _206 = g_TmSrgbOverlayMap.SampleLevel(g_LinearClampSampler, float2(((_193 * 0.5f) + 0.5f), ((_194 * 0.5f) + 0.5f)), 0.0f);
  float _211 = _206.x * _200;
  float _212 = _206.y * _200;
  float _213 = _206.z * _200;
  float _215 = (_206.w + -1.0f) * _200;
  float _227 = min(saturate((g_TM.m_FrostedHudScale * dot(float3(_211, _212, _213), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f))) - g_TM.m_FrostedHudBias), saturate(19.5f - ((_215 + 1.0f) * 20.0f)));
  [branch]
  if (_227 > 0.0f) {
    float3 _231 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_150, _151), 0.0f);
    float3 _238 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_150, _151), 0.0f, int2(-1, -1));
    float3 _242 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_150, _151), 0.0f, int2(0, -1));
    float3 _246 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_150, _151), 0.0f, int2(1, -1));
    float3 _250 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_150, _151), 0.0f, int2(-1, 0));
    float3 _254 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_150, _151), 0.0f, int2(1, 0));
    float3 _258 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_150, _151), 0.0f, int2(-1, 1));
    float3 _262 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_150, _151), 0.0f, int2(0, 1));
    float3 _266 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_150, _151), 0.0f, int2(1, 1));
    _310 = ((((((_231.x * 0.25f) - _183) + ((((_250.x + _242.x) + _254.x) + _262.x) * 0.125f)) + ((((_246.x + _238.x) + _258.x) + _266.x) * 0.0625f)) * _227) + _183);
    _311 = ((((((_231.y * 0.25f) - _184) + ((((_250.y + _242.y) + _254.y) + _262.y) * 0.125f)) + ((((_246.y + _238.y) + _258.y) + _266.y) * 0.0625f)) * _227) + _184);
    _312 = ((((((_231.z * 0.25f) - _185) + ((((_250.z + _242.z) + _254.z) + _262.z) * 0.125f)) + ((((_246.z + _238.z) + _258.z) + _266.z) * 0.0625f)) * _227) + _185);
  } else {
    _310 = _183;
    _311 = _184;
    _312 = _185;
  }
  float _322 = ((_150 * 2.0f) - g_TM.m_VignetteOffset.x) * g_TM.m_VignetteHorzScale;
  float _323 = g_TM.m_VignetteVertScale * ((_151 * 2.0f) - g_TM.m_VignetteOffset.y);
  float _328 = max((sqrt(dot(float2(_322, _323), float2(_322, _323))) - g_TM.m_VignetteCenterClear), 0.0f);
  float _331 = 1.0f / ((_328 * _328) + 1.0f);
  float _332 = _331 * _331;
  float _343 = (g_TM.m_GrainRandom * 2.0f) + -0.5f;
  float _344 = g_TM.m_GrainRandom * 6.2831854820251465f;
  float _345 = _150 - _343;
  float _346 = (g_TM.m_InvAspectRatio * _151) - _343;
  float _347 = sin(_344);
  float _348 = cos(_344);
  float4 _361 = g_TmFilmGrainNoise.SampleLevel(g_LinearWrapSampler, float2((((_343 - (_346 * _347)) + (_345 * _348)) * g_TM.m_GrainUvScale), ((((_345 * _347) + _343) + (_346 * _348)) * g_TM.m_GrainUvScale)), 0.0f);
  float _363 = _361.x * 2.0f;
  float _370 = ((select((_363 >= 1.0f), _363, (1.0f / (2.0f - _363))) + -1.0f) * g_TM.m_GrainStrength) + 1.0f;
  float _376 = g_TmAdaptedLumBuffer[1];
  float _378 = g_TM.m_AcesMiddleGray * _376;
  float3 _392 = g_TmToneMapLookup.SampleLevel(g_LinearClampSampler, float3(((log2(((_332 * _310) * _370) * _378) * 0.060546875f) + 0.6513671875f), ((log2(((_332 * _311) * _370) * _378) * 0.060546875f) + 0.6513671875f), ((log2(((_332 * _312) * _370) * _378) * 0.060546875f) + 0.6513671875f)), 0.0f);
  float _399 = select((!(g_TM.m_ApplyToneMappingScale == 0.0f)), g_TM.m_ToneMappingScale, 1.0f);
  float _400 = _399 * _392.x;
  float _401 = _399 * _392.y;
  float _402 = _399 * _392.z;
  float _403 = -0.0f - _215;
  float _407 = (_400 * _403) + _211;
  float _408 = (_401 * _403) + _212;
  float _409 = (_402 * _403) + _213;
  [branch]
  if (!(g_TM.m_ColorFilterStrength == 0.0f)) {
    float _413 = max(_407, 1.0f);
    float _414 = max(_408, 1.0f);
    float _415 = max(_409, 1.0f);
    float _416 = 1.0f / _413;
    float _417 = 1.0f / _414;
    float _418 = 1.0f / _415;
    float _419 = _416 * _407;
    float _420 = _417 * _408;
    float _421 = _418 * _409;
    float _422 = _416 * _400;
    float _423 = _417 * _401;
    float _424 = _418 * _402;
    float3 _432 = g_TmColorFilterMap.SampleLevel(g_LinearClampSampler, float3(((_419 * 0.96875f) + 0.015625f), ((_420 * 0.96875f) + 0.015625f), ((_421 * 0.96875f) + 0.015625f)), 0.0f);
    _461 = (((g_TM.m_ColorFilterStrength * (_432.x - _419)) + _419) * _413);
    _462 = (((g_TM.m_ColorFilterStrength * (_432.y - _420)) + _420) * _414);
    _463 = (((g_TM.m_ColorFilterStrength * (_432.z - _421)) + _421) * _415);
    _464 = (((g_TM.m_ColorFilterStrength * (_432.x - _422)) + _422) * _413);
    _465 = (((g_TM.m_ColorFilterStrength * (_432.y - _423)) + _423) * _414);
    _466 = (((g_TM.m_ColorFilterStrength * (_432.z - _424)) + _424) * _415);
  } else {
    _461 = _407;
    _462 = _408;
    _463 = _409;
    _464 = _400;
    _465 = _401;
    _466 = _402;
  }
  [branch]
  if (!(g_TM.m_HdrGamma == 0.0f)) {
#if 1
    float3 color_1 = float3(_461, _462, _463);
    color_1 = renodx::math::SignPow(color_1, RENODX_GAMMA_ADJUST_VALUE);
    float _478 = color_1.r, _479 = color_1.g, _480 = color_1.b;
#else
    float _478 = (pow(_461, g_TM.m_HdrGamma));
    float _479 = (pow(_462, g_TM.m_HdrGamma));
    float _480 = (pow(_463, g_TM.m_HdrGamma));
#endif

    float _481 = g_TM.m_HdrWhitePoint * 9.999999747378752e-05f;
    float _500 = exp2(log2(mad(0.043299999088048935f, _480, mad(0.3292999863624573f, _479, (_478 * 0.6273999810218811f))) * _481) * 0.1593017578125f);
    float _501 = exp2(log2(mad(0.01140000019222498f, _480, mad(0.9194999933242798f, _479, (_478 * 0.06909999996423721f))) * _481) * 0.1593017578125f);
    float _502 = exp2(log2(mad(0.8956000208854675f, _480, mad(0.08799999952316284f, _479, (_478 * 0.01640000008046627f))) * _481) * 0.1593017578125f);
#if 1
    float3 color_2 = float3(_464, _465, _466);
    color_2 = renodx::math::SignPow(color_2, RENODX_GAMMA_ADJUST_VALUE);
    float _533 = color_2.r, _534 = color_2.g, _535 = color_2.b;
#else
    float _533 = (pow(_464, g_TM.m_HdrGamma));
    float _534 = (pow(_465, g_TM.m_HdrGamma));
    float _535 = (pow(_466, g_TM.m_HdrGamma));
#endif
    float _554 = exp2(log2(mad(0.043299999088048935f, _535, mad(0.3292999863624573f, _534, (_533 * 0.6273999810218811f))) * _481) * 0.1593017578125f);
    float _555 = exp2(log2(mad(0.01140000019222498f, _535, mad(0.9194999933242798f, _534, (_533 * 0.06909999996423721f))) * _481) * 0.1593017578125f);
    float _556 = exp2(log2(mad(0.8956000208854675f, _535, mad(0.08799999952316284f, _534, (_533 * 0.01640000008046627f))) * _481) * 0.1593017578125f);
    _582 = exp2(log2(((_500 * 18.8515625f) + 0.8359375f) / ((_500 * 18.6875f) + 1.0f)) * 78.84375f);
    _583 = exp2(log2(((_501 * 18.8515625f) + 0.8359375f) / ((_501 * 18.6875f) + 1.0f)) * 78.84375f);
    _584 = exp2(log2(((_502 * 18.8515625f) + 0.8359375f) / ((_502 * 18.6875f) + 1.0f)) * 78.84375f);
    _585 = exp2(log2(((_554 * 18.8515625f) + 0.8359375f) / ((_554 * 18.6875f) + 1.0f)) * 78.84375f);
    _586 = exp2(log2(((_555 * 18.8515625f) + 0.8359375f) / ((_555 * 18.6875f) + 1.0f)) * 78.84375f);
    _587 = exp2(log2(((_556 * 18.8515625f) + 0.8359375f) / ((_556 * 18.6875f) + 1.0f)) * 78.84375f);
  } else {
    _582 = _461;
    _583 = _462;
    _584 = _463;
    _585 = _464;
    _586 = _465;
    _587 = _466;
  }
  g_TmOutput[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_582, _583, _584, 1.0f);
  if (!(g_TM.m_WriteHudless == 0.0f)) {
    g_TmOutputHudless[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_585, _586, _587, 1.0f);
  }
}
