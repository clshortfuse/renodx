#include "./common.hlsl"

Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0);

Texture2D<float4> ColorTexture : register(t1);

Texture2D<float4> GlareTexture : register(t2);

Texture2D<float4> CompositeSDRTexture : register(t3);

Texture2D<float4> CompositeSDRBackgroundTexture : register(t4);

Texture2D<float4> CompositeSDRForegroundTexture : register(t5);

Texture3D<float4> BT709PQToBT2020PQLUT : register(t6);

Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t7);

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
  float Globals_054x : packoffset(c054.x);
  float Globals_054y : packoffset(c054.y);
  float Globals_054z : packoffset(c054.z);
};

cbuffer View : register(b1) {
  uint View_175x : packoffset(c175.x);
};

SamplerState View_SharedBilinearClampedSampler : register(s0);

float4 main(
    noperspective float2 TEXCOORD : TEXCOORD,
    noperspective float4 TEXCOORD_1 : TEXCOORD1,
    noperspective float4 SV_Position : SV_Position) : SV_Target {
  float4 SV_Target;
  bool _21 = !((Globals_054z) == 0.0f);
  float _37 = (SV_Position.x) - (float((uint)(Globals_043x)));
  float _38 = (SV_Position.y) - (float((uint)(Globals_043y)));
  float _44 = saturate((_37 * (Globals_044z)));
  float _45 = saturate((_38 * (Globals_044w)));
  float _58 = (_21 ? (saturate(((Globals_044z) * (((floor((_37 * 0.5f))) * 2.0f) + 1.0f)))) : _44);
  float _59 = (_21 ? (saturate(((((floor((_38 * 0.5f))) * 2.0f) + 1.0f) * (Globals_044w)))) : _45);
  float _124 = ((min((((Globals_044x) * 0.5625f) * (Globals_044w)), 1.0f)) * (_44 + -0.5f)) + 0.5f;
  float _125 = ((min((((Globals_044y) * 1.7777777910232544f) * (Globals_044z)), 1.0f)) * (_45 + -0.5f)) + 0.5f;
  float4 _128 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_030x)*_58) + (float((uint)(Globals_029x)))) * (Globals_027z)), (Globals_033x))), (Globals_033z))), (min((max(((((Globals_030y)*_59) + (float((uint)(Globals_029y)))) * (Globals_027w)), (Globals_033y))), (Globals_033w)))), 0.0f);
  float _140 = (1.0f / (max(0.0010000000474974513f, (Globals_048y)))) * (TEXCOORD_1.z);
  float _145 = (_140 * _140) * (1.0f / (max(9.999999747378752e-06f, (dot(float3((TEXCOORD_1.x), (TEXCOORD_1.y), _140), float3((TEXCOORD_1.x), (TEXCOORD_1.y), _140))))));
  float _149 = (((_145 * _145) + -1.0f) * (Globals_048x)) + 1.0f;
  float _150 = _149 * (min((_128.x), 65504.0f));
  float _151 = _149 * (min((_128.y), 65504.0f));
  float _152 = _149 * (min((_128.z), 65504.0f));

  float3 mainColor = float3(_150, _151, _152);

  // float4 _154 = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_037x) * _58) + (float((uint)(Globals_036x)))) * (Globals_034z)), (Globals_040x))), (Globals_040z))), (min((max(((((Globals_037y) * _59) + (float((uint)(Globals_036y)))) * (Globals_034w)), (Globals_040y))), (Globals_040w)))), 0.0f);
  float2 glareUV = float2(
      clamp(((Globals_037x * _58) + (float)((uint)Globals_036x)) * Globals_034z, Globals_040x, Globals_040z),
      clamp(((Globals_037y * _59) + (float)((uint)Globals_036y)) * Globals_034w, Globals_040y, Globals_040w));
  float4 glareSample = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, glareUV, 0.0f);
  float3 glareColor = min(glareSample.xyz, 65504.0f);

  // Combine glare with main color
  float3 ungraded_bt709 = (Globals_049x * ((glareColor - mainColor) + mainColor * glareSample.w) + mainColor);

  // LUT + Tonemap
  float3 lutInputColor = renodx::color::pq::EncodeSafe(ungraded_bt709, 100.f);
  float3 _238 = renodx::lut::Sample(BT709PQToBT2020PQLUT, View_SharedBilinearClampedSampler, lutInputColor, 32u);
  float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(_238.xyz);
  float3 tonemapped = lutOutputColor_bt2020;

#if 1
  tonemapped = extractColorGradeAndApplyTonemap(ungraded_bt709, lutOutputColor_bt2020) * 10000.f;
#endif

  // commented pq encode/decode
  // float _180 = saturate((Globals_054x));
  // float _182 = saturate((Globals_054y));
  // float _187 = exp2(((log2((saturate(((((Globals_049x) * (((min((_154.x), 65504.0f))-_150) + (_150 * (_154.w)))) + _150) * 0.009999999776482582f))))) * 0.1593017578125f));
  // float _203 = exp2(((log2((saturate(((((Globals_049x) * (((min((_154.y), 65504.0f))-_151) + (_151 * (_154.w)))) + _151) * 0.009999999776482582f))))) * 0.1593017578125f));
  // float _219 = exp2(((log2((saturate(((((Globals_049x) * (((_152 * (_154.w)) - _152) + (min((_154.z), 65504.0f)))) + _152) * 0.009999999776482582f))))) * 0.1593017578125f));
  // float4 _238 = BT709PQToBT2020PQLUT.SampleLevel(View_SharedBilinearClampedSampler, float3((((saturate((exp2(((log2((max(0.0f, (((_187 * 18.8515625f) + 0.8359375f) * (1.0f / ((_187 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_203 * 18.8515625f) + 0.8359375f) * (1.0f / ((_203 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_219 * 18.8515625f) + 0.8359375f) * (1.0f / ((_219 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f)), 0.0f);
  // float _245 = exp2(((log2((saturate((_238.x))))) * 0.012683313339948654f));
  // float _254 = exp2(((log2((max(0.0f, ((_245 + -0.8359375f) * (1.0f / (18.8515625f - (_245 * 18.6875f)))))))) * 6.277394771575928f));
  // float _259 = exp2(((log2((saturate((_238.y))))) * 0.012683313339948654f));
  // float _268 = exp2(((log2((max(0.0f, ((_259 + -0.8359375f) * (1.0f / (18.8515625f - (_259 * 18.6875f)))))))) * 6.277394771575928f));
  // float _273 = exp2(((log2((saturate((_238.z))))) * 0.012683313339948654f));
  // float _282 = exp2(((log2((max(0.0f, ((_273 + -0.8359375f) * (1.0f / (18.8515625f - (_273 * 18.6875f)))))))) * 6.277394771575928f));
  // float _355 = (_254 * 10000.0f);
  // float _356 = (_268 * 10000.0f);
  // float _357 = (_282 * 10000.0f);
  // float _358 = (_238.x);
  // float _359 = (_238.y);
  // float _360 = (_238.z);
  // float _426;
  // float _427;
  // float _428;
  // float _471;
  // float _482;
  // float _493;
  // if (((_180 > 0.0f))) {
  //   float _287 = 1.0f - (_180 * 0.2928932309150696f);
  //   float _300 = exp2(((log2((saturate((_254 * 10.0f))))) * _287));
  //   float _301 = exp2(((log2((saturate((_268 * 10.0f))))) * _287));
  //   float _302 = exp2(((log2((saturate((_282 * 10.0f))))) * _287));
  //   float _310 = exp2(((log2((saturate((_300 * 0.09999999403953552f))))) * 0.1593017578125f));
  //   float _326 = exp2(((log2((saturate((_301 * 0.09999999403953552f))))) * 0.1593017578125f));
  //   float _342 = exp2(((log2((saturate((_302 * 0.09999999403953552f))))) * 0.1593017578125f));
  //   _355 = (_300 * 1000.0f);
  //   _356 = (_301 * 1000.0f);
  //   _357 = (_302 * 1000.0f);
  //   _358 = (saturate((exp2(((log2((max(0.0f, (((_310 * 18.8515625f) + 0.8359375f) * (1.0f / ((_310 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
  //   _359 = (saturate((exp2(((log2((max(0.0f, (((_326 * 18.8515625f) + 0.8359375f) * (1.0f / ((_326 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
  //   _360 = (saturate((exp2(((log2((max(0.0f, (((_342 * 18.8515625f) + 0.8359375f) * (1.0f / ((_342 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
  // }
  // _426 = _355;
  // _427 = _356;
  // _428 = _357;
  // if (((_182 < 1.0f))) {
  //   float4 _370 = BT2020PQ1000ToBT2020PQ250LUT.SampleLevel(View_SharedBilinearClampedSampler, float3(((_358 * 0.96875f) + 0.015625f), ((_359 * 0.96875f) + 0.015625f), ((_360 * 0.96875f) + 0.015625f)), 0.0f);
  //   float _377 = exp2(((log2((saturate((_370.x))))) * 0.012683313339948654f));
  //   float _387 = (exp2(((log2((max(0.0f, ((_377 + -0.8359375f) * (1.0f / (18.8515625f - (_377 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
  //   float _391 = exp2(((log2((saturate((_370.y))))) * 0.012683313339948654f));
  //   float _401 = (exp2(((log2((max(0.0f, ((_391 + -0.8359375f) * (1.0f / (18.8515625f - (_391 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
  //   float _405 = exp2(((log2((saturate((_370.z))))) * 0.012683313339948654f));
  //   float _415 = (exp2(((log2((max(0.0f, ((_405 + -0.8359375f) * (1.0f / (18.8515625f - (_405 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
  //   _426 = (((_355 - _387) * _182) + _387);
  //   _427 = (((_356 - _401) * _182) + _401);
  //   _428 = (((_357 - _415) * _182) + _415);
  // }


  float _426 = tonemapped.r, _427 = tonemapped.g, _428 = tonemapped.b;

  float _471;
  float _482;
  float _493;
  float4 _430 = CompositeSDRBackgroundTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_124, _125), 0.0f);
  float4 _436 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_124, _125), 0.0f);
  float4 _449 = CompositeSDRForegroundTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_124, _125), 0.0f);
  float _457 = ((_449.w) * (((_436.w) * (_430.x)) + (_436.x))) + (_449.x);
  float _458 = ((_449.w) * (((_436.w) * (_430.y)) + (_436.y))) + (_449.y);
  float _459 = ((_449.w) * (((_436.w) * (_430.z)) + (_436.z))) + (_449.z);
  float _460 = ((_436.w) * (_430.w)) * (_449.w);
  if (((_457 < 0.0031308000907301903f))) {
    _471 = (_457 * 12.920000076293945f);
  } else {
    _471 = (((exp2(((log2(_457)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (((_458 < 0.0031308000907301903f))) {
    _482 = (_458 * 12.920000076293945f);
  } else {
    _482 = (((exp2(((log2(_458)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (((_459 < 0.0031308000907301903f))) {
    _493 = (_459 * 12.920000076293945f);
  } else {
    _493 = (((exp2(((log2(_459)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _494 = _460 * _460;
  float _501 = 1.0f / ((_426 * 0.004000000189989805f) + 1.0f);
  float _502 = 1.0f / ((_427 * 0.004000000189989805f) + 1.0f);
  float _503 = 1.0f / ((_428 * 0.004000000189989805f) + 1.0f);
  float _525 = exp2(((log2(_471)) * 2.200000047683716f));
  float _526 = exp2(((log2(_482)) * 2.200000047683716f));
  float _527 = exp2(((log2(_493)) * 2.200000047683716f));
  float _541 = exp2(((log2((saturate(((((dot(float3(0.6274039149284363f, 0.3292829990386963f, 0.043313100934028625f), float3(_525, _526, _527)))*RENODX_GRAPHICS_WHITE_NITS) + ((_460 * _426) * (((1.0f - _501) * _494) + _501))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _552 = saturate((exp2(((log2((max(0.0f, (((_541 * 18.8515625f) + 0.8359375f) * (1.0f / ((_541 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _557 = exp2(((log2((saturate(((((dot(float3(0.06909730285406113f, 0.9195405840873718f, 0.011362300254404545f), float3(_525, _526, _527)))*RENODX_GRAPHICS_WHITE_NITS) + ((_460 * _427) * (((1.0f - _502) * _494) + _502))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _568 = saturate((exp2(((log2((max(0.0f, (((_557 * 18.8515625f) + 0.8359375f) * (1.0f / ((_557 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _573 = exp2(((log2((saturate(((((dot(float3(0.01639140024781227f, 0.08801329880952835f, 0.8955953121185303f), float3(_525, _526, _527)))*RENODX_GRAPHICS_WHITE_NITS) + ((_460 * _428) * (((1.0f - _503) * _494) + _503))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _584 = saturate((exp2(((log2((max(0.0f, (((_573 * 18.8515625f) + 0.8359375f) * (1.0f / ((_573 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _586 = ((((float4)(View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4(((int(25)) & 127), ((int(26)) & 127), (((uint)(View_175x)) & 63), 0)))).x) * 2.0f) + -1.0f;
  float _603 = ((1.0f - (sqrt((1.0f - (abs(_586)))))) * (float(((int(((bool)((_586 > 0.0f))))) - (int(((bool)((_586 < 0.0f))))))))) * 0.0009775171056389809f;
  SV_Target.x = (saturate(((((bool)((((abs(((_552 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_603 + _552) : _552))));
  SV_Target.y = (saturate(((((bool)((((abs(((_568 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_603 + _568) : _568))));
  SV_Target.z = (saturate(((((bool)((((abs(((_584 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_603 + _584) : _584))));
  SV_Target.w = 0.0f;
  return SV_Target;
}
