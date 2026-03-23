#include "./shared.h"

Texture3D<float3> g_TmToneMapLookup : register(t5);

Texture2D<float3> g_TmRadianceMap : register(t6);

Texture2D<float3> g_TmBloomMap : register(t7);

Texture3D<float3> g_TmColorFilterMap : register(t9);

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
  } g_TM: packoffset(c000.x);
};
// clang-format on

SamplerState g_LinearClampSampler : register(s2);

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _22 = g_TM.m_PixelScale.x * (float((uint)SV_DispatchThreadID.x) + 0.5f);
  float _23 = (float((uint)SV_DispatchThreadID.y) + 0.5f) * g_TM.m_PixelScale.y;
  float3 _26 = g_TmRadianceMap.SampleLevel(g_LinearClampSampler, float2(_22, _23), 0.0f);
  float3 _31 = g_TmBloomMap.SampleLevel(g_LinearClampSampler, float2(_22, _23), 0.0f);
  float _35 = _31.x + _26.x;
  float _36 = _31.y + _26.y;
  float _37 = _31.z + _26.z;
  float _60;
  float _61;
  float _62;
  float _187;
  float _188;
  float _189;
  float _300;
  float _301;
  float _302;
  float _303;
  float _304;
  float _305;
  float _422;
  float _423;
  float _424;
  float _425;
  float _426;
  float _427;
  [branch]
  if (!(g_TM.m_Contrast == 0.0f)) {
    float _43 = saturate(dot(float3(_35, _36, _37), float3(0.30000001192092896f, 0.5f, 0.20000000298023224f)));
    float _55 = ((((((_43 * _43) * _43) * ((((_43 * 6.0f) + -15.0f) * _43) + 10.0f)) - _43) * g_TM.m_Contrast) + _43) / max(_43, 9.999999747378752e-06f);
    _60 = (_55 * _35);
    _61 = (_55 * _36);
    _62 = (_55 * _37);
  } else {
    _60 = _35;
    _61 = _36;
    _62 = _37;
  }
  float _70 = (_22 * g_TM.m_SrgbOverlayScale.x) + g_TM.m_SrgbOverlayBias.x;
  float _71 = (_23 * g_TM.m_SrgbOverlayScale.y) + g_TM.m_SrgbOverlayBias.y;
  float _77 = saturate((1.0f - max(abs(_70), abs(_71))) * 4096.0f);
  float4 _83 = g_TmSrgbOverlayMap.SampleLevel(g_LinearClampSampler, float2(((_70 * 0.5f) + 0.5f), ((_71 * 0.5f) + 0.5f)), 0.0f);
  float _88 = _83.x * _77;
  float _89 = _83.y * _77;
  float _90 = _83.z * _77;
  float _92 = (_83.w + -1.0f) * _77;
  float _104 = min(saturate((g_TM.m_FrostedHudScale * dot(float3(_88, _89, _90), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f))) - g_TM.m_FrostedHudBias), saturate(19.5f - ((_92 + 1.0f) * 20.0f)));
  [branch]
  if (_104 > 0.0f) {
    float3 _108 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_22, _23), 0.0f);
    float3 _115 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_22, _23), 0.0f, int2(-1, -1));
    float3 _119 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_22, _23), 0.0f, int2(0, -1));
    float3 _123 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_22, _23), 0.0f, int2(1, -1));
    float3 _127 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_22, _23), 0.0f, int2(-1, 0));
    float3 _131 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_22, _23), 0.0f, int2(1, 0));
    float3 _135 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_22, _23), 0.0f, int2(-1, 1));
    float3 _139 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_22, _23), 0.0f, int2(0, 1));
    float3 _143 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_22, _23), 0.0f, int2(1, 1));
    _187 = ((((((_108.x * 0.25f) - _60) + ((((_127.x + _119.x) + _131.x) + _139.x) * 0.125f)) + ((((_123.x + _115.x) + _135.x) + _143.x) * 0.0625f)) * _104) + _60);
    _188 = ((((((_108.y * 0.25f) - _61) + ((((_127.y + _119.y) + _131.y) + _139.y) * 0.125f)) + ((((_123.y + _115.y) + _135.y) + _143.y) * 0.0625f)) * _104) + _61);
    _189 = ((((((_108.z * 0.25f) - _62) + ((((_127.z + _119.z) + _131.z) + _139.z) * 0.125f)) + ((((_123.z + _115.z) + _135.z) + _143.z) * 0.0625f)) * _104) + _62);
  } else {
    _187 = _60;
    _188 = _61;
    _189 = _62;
  }
  float _199 = ((_22 * 2.0f) - g_TM.m_VignetteOffset.x) * g_TM.m_VignetteHorzScale;
  float _200 = g_TM.m_VignetteVertScale * ((_23 * 2.0f) - g_TM.m_VignetteOffset.y);
  float _205 = max((sqrt(dot(float2(_199, _200), float2(_199, _200))) - g_TM.m_VignetteCenterClear), 0.0f);
  float _208 = 1.0f / ((_205 * _205) + 1.0f);
  float _209 = _208 * _208;
  float _215 = g_TmAdaptedLumBuffer[1];
  float _217 = g_TM.m_AcesMiddleGray * _215;
  float3 _231 = g_TmToneMapLookup.SampleLevel(g_LinearClampSampler, float3(((log2((_209 * _187) * _217) * 0.060546875f) + 0.6513671875f), ((log2((_209 * _188) * _217) * 0.060546875f) + 0.6513671875f), ((log2((_209 * _189) * _217) * 0.060546875f) + 0.6513671875f)), 0.0f);
  float _238 = select((!(g_TM.m_ApplyToneMappingScale == 0.0f)), g_TM.m_ToneMappingScale, 1.0f);
  float _239 = _238 * _231.x;
  float _240 = _238 * _231.y;
  float _241 = _238 * _231.z;
  float _242 = -0.0f - _92;
  float _246 = (_239 * _242) + _88;
  float _247 = (_240 * _242) + _89;
  float _248 = (_241 * _242) + _90;
  [branch]
  if (!(g_TM.m_ColorFilterStrength == 0.0f)) {
    float _252 = max(_246, 1.0f);
    float _253 = max(_247, 1.0f);
    float _254 = max(_248, 1.0f);
    float _255 = 1.0f / _252;
    float _256 = 1.0f / _253;
    float _257 = 1.0f / _254;
    float _258 = _255 * _246;
    float _259 = _256 * _247;
    float _260 = _257 * _248;
    float _261 = _255 * _239;
    float _262 = _256 * _240;
    float _263 = _257 * _241;
    float3 _271 = g_TmColorFilterMap.SampleLevel(g_LinearClampSampler, float3(((_258 * 0.96875f) + 0.015625f), ((_259 * 0.96875f) + 0.015625f), ((_260 * 0.96875f) + 0.015625f)), 0.0f);
    _300 = (((g_TM.m_ColorFilterStrength * (_271.x - _258)) + _258) * _252);
    _301 = (((g_TM.m_ColorFilterStrength * (_271.y - _259)) + _259) * _253);
    _302 = (((g_TM.m_ColorFilterStrength * (_271.z - _260)) + _260) * _254);
    _303 = (((g_TM.m_ColorFilterStrength * (_271.x - _261)) + _261) * _252);
    _304 = (((g_TM.m_ColorFilterStrength * (_271.y - _262)) + _262) * _253);
    _305 = (((g_TM.m_ColorFilterStrength * (_271.z - _263)) + _263) * _254);
  } else {
    _300 = _246;
    _301 = _247;
    _302 = _248;
    _303 = _239;
    _304 = _240;
    _305 = _241;
  }
  [branch]
  if (!(g_TM.m_HdrGamma == 0.0f)) {
    // float _318 = (pow(_300, g_TM.m_HdrGamma));
    // float _319 = (pow(_301, g_TM.m_HdrGamma));
    // float _320 = (pow(_302, g_TM.m_HdrGamma));
    float3 color_1 = float3(_300, _301, _302);
    color_1 = renodx::math::SignPow(color_1, RENODX_GAMMA_ADJUST_VALUE);
    float _318 = color_1.r, _319 = color_1.g, _320 = color_1.b;

    float _321 = g_TM.m_HdrWhitePoint * 9.999999747378752e-05f;
    float _340 = exp2(log2(mad(0.043299999088048935f, _320, mad(0.3292999863624573f, _319, (_318 * 0.6273999810218811f))) * _321) * 0.1593017578125f);
    float _341 = exp2(log2(mad(0.01140000019222498f, _320, mad(0.9194999933242798f, _319, (_318 * 0.06909999996423721f))) * _321) * 0.1593017578125f);
    float _342 = exp2(log2(mad(0.8956000208854675f, _320, mad(0.08799999952316284f, _319, (_318 * 0.01640000008046627f))) * _321) * 0.1593017578125f);

    // float _373 = (pow(_303, g_TM.m_HdrGamma));
    // float _374 = (pow(_304, g_TM.m_HdrGamma));
    // float _375 = (pow(_305, g_TM.m_HdrGamma));
    float3 color_2 = float3(_303, _304, _305);
    color_2 = renodx::math::SignPow(color_2, RENODX_GAMMA_ADJUST_VALUE);
    float _373 = color_2.r, _374 = color_2.g, _375 = color_2.b;

    float _394 = exp2(log2(mad(0.043299999088048935f, _375, mad(0.3292999863624573f, _374, (_373 * 0.6273999810218811f))) * _321) * 0.1593017578125f);
    float _395 = exp2(log2(mad(0.01140000019222498f, _375, mad(0.9194999933242798f, _374, (_373 * 0.06909999996423721f))) * _321) * 0.1593017578125f);
    float _396 = exp2(log2(mad(0.8956000208854675f, _375, mad(0.08799999952316284f, _374, (_373 * 0.01640000008046627f))) * _321) * 0.1593017578125f);
    _422 = exp2(log2(((_340 * 18.8515625f) + 0.8359375f) / ((_340 * 18.6875f) + 1.0f)) * 78.84375f);
    _423 = exp2(log2(((_341 * 18.8515625f) + 0.8359375f) / ((_341 * 18.6875f) + 1.0f)) * 78.84375f);
    _424 = exp2(log2(((_342 * 18.8515625f) + 0.8359375f) / ((_342 * 18.6875f) + 1.0f)) * 78.84375f);
    _425 = exp2(log2(((_394 * 18.8515625f) + 0.8359375f) / ((_394 * 18.6875f) + 1.0f)) * 78.84375f);
    _426 = exp2(log2(((_395 * 18.8515625f) + 0.8359375f) / ((_395 * 18.6875f) + 1.0f)) * 78.84375f);
    _427 = exp2(log2(((_396 * 18.8515625f) + 0.8359375f) / ((_396 * 18.6875f) + 1.0f)) * 78.84375f);
  } else {
    _422 = _300;
    _423 = _301;
    _424 = _302;
    _425 = _303;
    _426 = _304;
    _427 = _305;
  }
  g_TmOutput[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_422, _423, _424, 1.0f);
  if (!(g_TM.m_WriteHudless == 0.0f)) {
    g_TmOutputHudless[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_425, _426, _427, 1.0f);
  }
}
