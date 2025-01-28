#include "./common.hlsl"

Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0);

Texture2D<float4> ColorTexture : register(t1);

Texture2D<float4> GlareTexture : register(t2);

Texture2D<float4> CompositeSDRTexture : register(t3);

Texture2D<float4> CompositeSDRBackgroundTexture : register(t4);

Texture2D<float4> CompositeSDRForegroundTexture : register(t5);

Texture3D<float4> BT709PQToBT2020PQLUT : register(t6);

cbuffer Globals : register(b0) {
  float Globals_027z : packoffset(c027.z);
  float Globals_027w : packoffset(c027.w);
  uint Globals_029x : packoffset(c029.x);
  uint Globals_029y : packoffset(c029.y);
  float Globals_030x : packoffset(c030.x);
  float Globals_030y : packoffset(c030.y);
  float Globals_033x : packoffset(c033.x);
  float Globals_033y : packoffset(c033.y);
  float Globals_033z : packoffset(c033.z);
  float Globals_033w : packoffset(c033.w);
  float Globals_034z : packoffset(c034.z);
  float Globals_034w : packoffset(c034.w);
  uint Globals_036x : packoffset(c036.x);
  uint Globals_036y : packoffset(c036.y);
  float Globals_037x : packoffset(c037.x);
  float Globals_037y : packoffset(c037.y);
  float Globals_040x : packoffset(c040.x);
  float Globals_040y : packoffset(c040.y);
  float Globals_040z : packoffset(c040.z);
  float Globals_040w : packoffset(c040.w);
  uint Globals_043x : packoffset(c043.x);
  uint Globals_043y : packoffset(c043.y);
  float Globals_044x : packoffset(c044.x);
  float Globals_044y : packoffset(c044.y);
  float Globals_044z : packoffset(c044.z);
  float Globals_044w : packoffset(c044.w);
  float Globals_048x : packoffset(c048.x);
  float Globals_048y : packoffset(c048.y);
  float Globals_049x : packoffset(c049.x);
  float Globals_054z : packoffset(c054.z);
};

cbuffer View : register(b1) {
  uint View_175x : packoffset(c175.x);
};

SamplerState View_SharedBilinearClampedSampler : register(s0);

float getMidGray() {
  float3 inMidGray = (0.18f, 0.18f, 0.18f);  // use ACES mid gray
  float3 lutInputColor = saturate(renodx::color::pq::Encode(inMidGray, 100.f));
  float3 lutResult = renodx::lut::Sample(BT709PQToBT2020PQLUT, View_SharedBilinearClampedSampler, lutInputColor, 32u);
  float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(lutResult, 250);

  float outMidGray = renodx::color::y::from::BT2020(lutOutputColor_bt2020);
  return outMidGray;
}

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 TEXCOORD_1: TEXCOORD1,
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;

  SV_Target.w = 0.0f;

  bool _20 = !((Globals_054z) == 0.0f);
  float _36 = (SV_Position.x) - (float((uint)(Globals_043x)));
  float _37 = (SV_Position.y) - (float((uint)(Globals_043y)));
  float _43 = saturate((_36 * (Globals_044z)));
  float _44 = saturate((_37 * (Globals_044w)));
  float _57 = (_20 ? (saturate(((Globals_044z) * (((floor((_36 * 0.5f))) * 2.0f) + 1.0f)))) : _43);
  float _58 = (_20 ? (saturate(((((floor((_37 * 0.5f))) * 2.0f) + 1.0f) * (Globals_044w)))) : _44);
  float _123 = ((min((((Globals_044x) * 0.5625f) * (Globals_044w)), 1.0f)) * (_43 + -0.5f)) + 0.5f;
  float _124 = ((min((((Globals_044y) * 1.7777777910232544f) * (Globals_044z)), 1.0f)) * (_44 + -0.5f)) + 0.5f;

  // Main scene
  float4 _127 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_030x)*_57) + (float((uint)(Globals_029x)))) * (Globals_027z)), (Globals_033x))), (Globals_033z))), (min((max(((((Globals_030y)*_58) + (float((uint)(Globals_029y)))) * (Globals_027w)), (Globals_033y))), (Globals_033w)))), 0.0f);

  // Vignette?
  float _139 = (1.0f / (max(0.0010000000474974513f, (Globals_048y)))) * (TEXCOORD_1.z);
  float _144 = (_139 * _139) * (1.0f / (max(9.999999747378752e-06f, (dot(float3((TEXCOORD_1.x), (TEXCOORD_1.y), _139), float3((TEXCOORD_1.x), (TEXCOORD_1.y), _139))))));
  float _148 = (((_144 * _144) + -1.0f) * (Globals_048x)) + 1.0f;
  float _149 = _148 * (min((_127.x), 65504.0f));
  float _150 = _148 * (min((_127.y), 65504.0f));
  float _151 = _148 * (min((_127.z), 65504.0f));

  float3 mainColor = float3(_149, _150, _151);

  // Sample glare
  float2 glareUV = float2(
      clamp(((Globals_037x * _57) + (float)((uint)Globals_036x)) * Globals_034z, Globals_040x, Globals_040z),
      clamp(((Globals_037y * _58) + (float)((uint)Globals_036y)) * Globals_034w, Globals_040y, Globals_040w));
  float4 glareSample = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, glareUV, 0.0f);
  float3 glareColor = min(glareSample.xyz, 65504.0f);

  // Combine glare with main color
  float3 ungraded_bt709 = (Globals_049x * ((glareColor - mainColor) + mainColor * glareSample.w) + mainColor);

  // LUT + Tonemap
  float3 lutInputColor = renodx::color::pq::EncodeSafe(ungraded_bt709, 100.f);
  float3 _233 = renodx::lut::Sample(BT709PQToBT2020PQLUT, View_SharedBilinearClampedSampler, lutInputColor, 32u);
  float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(_233.xyz);
  float3 tonemapped = lutOutputColor_bt2020;

#if 1
  tonemapped = extractColorGradeAndApplyTonemap(ungraded_bt709, lutOutputColor_bt2020, getMidGray());
#endif

  float _249 = tonemapped.r, _263 = tonemapped.g, _277 = tonemapped.b;
  float4 _280 = CompositeSDRBackgroundTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_123, _124), 0.0f);
  float4 _286 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_123, _124), 0.0f);
  float4 _299 = CompositeSDRForegroundTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_123, _124), 0.0f);
  float _307 = ((_299.w) * (((_286.w) * (_280.x)) + (_286.x))) + (_299.x);
  float _308 = ((_299.w) * (((_286.w) * (_280.y)) + (_286.y))) + (_299.y);
  float _309 = ((_299.w) * (((_286.w) * (_280.z)) + (_286.z))) + (_299.z);
  float _310 = ((_286.w) * (_280.w)) * (_299.w);
  float _321;
  float _332;
  float _343;
  if (((_307 < 0.0031308000907301903f))) {
    _321 = (_307 * 12.920000076293945f);
  } else {
    _321 = (((exp2(((log2(_307)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (((_308 < 0.0031308000907301903f))) {
    _332 = (_308 * 12.920000076293945f);
  } else {
    _332 = (((exp2(((log2(_308)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (((_309 < 0.0031308000907301903f))) {
    _343 = (_309 * 12.920000076293945f);
  } else {
    _343 = (((exp2(((log2(_309)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _344 = _310 * _310;
  float _351 = 1.0f / ((_249 * 40.0f) + 1.0f);
  float _352 = 1.0f / ((_263 * 40.0f) + 1.0f);
  float _353 = 1.0f / ((_277 * 40.0f) + 1.0f);
  float _375 = exp2(((log2(_321)) * 2.200000047683716f));
  float _376 = exp2(((log2(_332)) * 2.200000047683716f));
  float _377 = exp2(((log2(_343)) * 2.200000047683716f));
  float _391 = exp2(((log2((saturate(((((dot(float3(0.6274039149284363f, 0.3292829990386963f, 0.043313100934028625f), float3(_375, _376, _377)))*RENODX_GRAPHICS_WHITE_NITS) + (((_249 * 10000.0f) * _310) * (((1.0f - _351) * _344) + _351))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _402 = saturate((exp2(((log2((max(0.0f, (((_391 * 18.8515625f) + 0.8359375f) * (1.0f / ((_391 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _407 = exp2(((log2((saturate(((((dot(float3(0.06909730285406113f, 0.9195405840873718f, 0.011362300254404545f), float3(_375, _376, _377)))*RENODX_GRAPHICS_WHITE_NITS) + (((_263 * 10000.0f) * _310) * (((1.0f - _352) * _344) + _352))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _418 = saturate((exp2(((log2((max(0.0f, (((_407 * 18.8515625f) + 0.8359375f) * (1.0f / ((_407 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _423 = exp2(((log2((saturate(((((dot(float3(0.01639140024781227f, 0.08801329880952835f, 0.8955953121185303f), float3(_375, _376, _377)))*RENODX_GRAPHICS_WHITE_NITS) + (((_277 * 10000.0f) * _310) * (((1.0f - _353) * _344) + _353))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _434 = saturate((exp2(((log2((max(0.0f, (((_423 * 18.8515625f) + 0.8359375f) * (1.0f / ((_423 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _436 = ((((float4)(View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4(((int(24)) & 127), ((int(25)) & 127), (((uint)(View_175x)) & 63), 0)))).x) * 2.0f) + -1.0f;
  float _453 = ((1.0f - (sqrt((1.0f - (abs(_436)))))) * (float(((int(((bool)((_436 > 0.0f))))) - (int(((bool)((_436 < 0.0f))))))))) * 0.0009775171056389809f;
  SV_Target.x = (saturate(((((bool)((((abs(((_402 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_453 + _402) : _402))));
  SV_Target.y = (saturate(((((bool)((((abs(((_418 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_453 + _418) : _418))));
  SV_Target.z = (saturate(((((bool)((((abs(((_434 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_453 + _434) : _434))));
  return SV_Target;
}
