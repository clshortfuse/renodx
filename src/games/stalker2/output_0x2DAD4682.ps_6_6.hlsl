#include "./shared.h"
#include "./common.hlsl"

Texture2D<float4> ColorTexture : register(t0);

Texture2D<float4> BloomTexture : register(t1);

struct _SceneColorApplyParamaters {
  float data[4];
};
StructuredBuffer<_SceneColorApplyParamaters> SceneColorApplyParamaters : register(t2);

Texture3D<float4> LumBilateralGrid : register(t3);

Texture2D<float4> BlurredLogLum : register(t4);

Texture2D<float4> BloomDirtMaskTexture : register(t5);

Texture3D<float4> ColorGradingLUT : register(t6);

cbuffer cb0 : register(b0) {
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_025y : packoffset(c025.y);
  float cb0_025z : packoffset(c025.z);
  float cb0_025w : packoffset(c025.w);
  float cb0_027x : packoffset(c027.x);
  float cb0_027y : packoffset(c027.y);
  float cb0_027z : packoffset(c027.z);
  float cb0_032x : packoffset(c032.x);
  float cb0_032y : packoffset(c032.y);
  float cb0_032z : packoffset(c032.z);
  float cb0_032w : packoffset(c032.w);
  float cb0_033z : packoffset(c033.z);
  float cb0_033w : packoffset(c033.w);
  float cb0_034x : packoffset(c034.x);
  float cb0_034y : packoffset(c034.y);
  float cb0_036x : packoffset(c036.x);
  float cb0_036y : packoffset(c036.y);
  float cb0_036z : packoffset(c036.z);
  float cb0_036w : packoffset(c036.w);
  float cb0_037x : packoffset(c037.x);
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_044x : packoffset(c044.x);
  float cb0_044y : packoffset(c044.y);
  float cb0_044z : packoffset(c044.z);
  float cb0_045x : packoffset(c045.x);
  float cb0_045y : packoffset(c045.y);
  float cb0_045z : packoffset(c045.z);
  float cb0_047x : packoffset(c047.x);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_050y : packoffset(c050.y);
  uint cb0_050z : packoffset(c050.z);
  float cb0_050w : packoffset(c050.w);
  float cb0_051x : packoffset(c051.x);
};

cbuffer UniformBufferConstants_View : register(b1) {
  float UniformBufferConstants_View_140w : packoffset(c140.w);
};

SamplerState ColorSampler : register(s0);

SamplerState BloomSampler : register(s1);

SamplerState LumBilateralGridSampler : register(s2);

SamplerState BlurredLogLumSampler : register(s3);

SamplerState BloomDirtMaskSampler : register(s4);

SamplerState ColorGradingLUTSampler : register(s5);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 TEXCOORD_1: TEXCOORD1,
    noperspective float4 TEXCOORD_2: TEXCOORD2,
    noperspective float2 TEXCOORD_3: TEXCOORD3,
    noperspective float2 TEXCOORD_4: TEXCOORD4,
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  float3 post_lut;

  float4 _41 = ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w)))));
  float _47 = (UniformBufferConstants_View_140w) * (_41.x);
  float _48 = (UniformBufferConstants_View_140w) * (_41.y);
  float _49 = (UniformBufferConstants_View_140w) * (_41.z);
  float _58 = log2((max((dot(float3(_47, _48, _49), float3((cb0_027x), (cb0_027y), (cb0_027z)))), (cb0_025w))));
  float4 _74 = LumBilateralGrid.Sample(LumBilateralGridSampler, float3(((cb0_033z) * (TEXCOORD_4.x)), ((cb0_033w) * (TEXCOORD_4.y)), (((((cb0_025y)*_58) + (cb0_025z)) * 0.96875f) + 0.015625f)));
  float _83 = (((bool)(((_74.y) < 0.0010000000474974513f))) ? (((float4)(BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y))))).x) : ((_74.x) / (_74.y)));
  float _86 = log2((TEXCOORD_1.x));
  float _88 = (_83 + _86) + (((((float4)(BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y))))).x) - _83) * (cb0_032w));
  float _93 = _86 + _58;
  float _95 = _88 - (TEXCOORD_1.y);
  bool _96 = (_95 > 0.0f);
  float _108;
  float _345;
  float _346;
  float _347;
  if (_96) {
    _108 = (max(0.0f, (_95 - (cb0_034x))));
  } else {
    _108 = (min(0.0f, ((cb0_034y) + _95)));
  }
  float _115 = exp2(((((_88 - _93) + ((_93 - _88) * (cb0_032z))) - _108) + (_108 * ((_96 ? (cb0_032x) : (cb0_032y))))));
  float4 _127 = SceneColorApplyParamaters[0].data[0 / 4];
  float4 _154 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_036x) * (TEXCOORD.x)) + (cb0_036z)), (cb0_037x))), (cb0_037z))), (min((max((((cb0_036y) * (TEXCOORD.y)) + (cb0_036w)), (cb0_037y))), (cb0_037w)))));
  float4 _178 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y)) * 0.5f))));
  float _200 = (cb0_047x) * (TEXCOORD_1.z);
  float _201 = (cb0_047x) * (TEXCOORD_1.w);
  // These two control vingette
  if (injectedData.toneMapType != 0.f) {
    _200 *= injectedData.vignetteStrength;
    _201 *= injectedData.vignetteStrength;
  }

  float _204 = 1.0f / ((dot(float2(_200, _201), float2(_200, _201))) + 1.0f);
  float _207 = ((TEXCOORD_1.x) * 0.009999999776482582f) * (_204 * _204);
  float _217 = exp2(((log2((_207 * ((((UniformBufferConstants_View_140w) * (_154.x)) * (((cb0_045x) * (_178.x)) + 1.0f)) + (((_115 * _47) * (cb0_044x)) * (_127.x)))))) * 0.1593017578125f));
  float _218 = exp2(((log2((_207 * ((((UniformBufferConstants_View_140w) * (_154.y)) * (((cb0_045y) * (_178.y)) + 1.0f)) + (((_115 * _48) * (cb0_044y)) * (_127.y)))))) * 0.1593017578125f));
  float _219 = exp2(((log2((_207 * ((((UniformBufferConstants_View_140w) * (_154.z)) * (((cb0_045z) * (_178.z)) + 1.0f)) + (((_115 * _49) * (cb0_044z)) * (_127.z)))))) * 0.1593017578125f));
  float4 _255 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((exp2(((log2(((1.0f / ((_217 * 18.6875f) + 1.0f)) * ((_217 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f), (((exp2(((log2(((1.0f / ((_218 * 18.6875f) + 1.0f)) * ((_218 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f), (((exp2(((log2(((1.0f / ((_219 * 18.6875f) + 1.0f)) * ((_219 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f)));
  post_lut = _255.rgb;
  // Code after sampling
  if (injectedData.toneMapType != 0.f) {
    return float4(post_lut, 0.f);
  }
  float _268 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 0.00390625f) + -0.001953125f;
  float _269 = _268 + ((_255.x) * 1.0499999523162842f);
  float _270 = _268 + ((_255.y) * 1.0499999523162842f);
  float _271 = _268 + ((_255.z) * 1.0499999523162842f);
  _345 = _269;
  _346 = _270;
  _347 = _271;
  if (!((((uint)(cb0_050z)) == 0))) {
    float _282 = exp2(((log2(_269)) * 0.012683313339948654f));
    float _283 = exp2(((log2(_270)) * 0.012683313339948654f));
    float _284 = exp2(((log2(_271)) * 0.012683313339948654f));
    float _317 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_282 + -0.8359375f))) / (18.8515625f - (_282 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    float _318 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_283 + -0.8359375f))) / (18.8515625f - (_283 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    float _319 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_284 + -0.8359375f))) / (18.8515625f - (_284 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    _345 = (min((_317 * 12.920000076293945f), (((exp2(((log2((max(_317, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _346 = (min((_318 * 12.920000076293945f), (((exp2(((log2((max(_318, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _347 = (min((_319 * 12.920000076293945f), (((exp2(((log2((max(_319, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  float contrast = cb0_051x;
  float brightness = cb0_050w;
  if (injectedData.toneMapType > 0.f) {
    contrast = DEFAULT_CONTRAST;
    brightness = DEFAULT_BRIGHTNESS;
  }
  /* SV_Target.x = (saturate(((((_345 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f)));
  SV_Target.y = (saturate(((((_346 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f)));
  SV_Target.z = (saturate(((((_347 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f))); */
  SV_Target.x = (saturate(((((_345 + -0.5f) + (brightness)) * (contrast)) + 0.5f)));
  SV_Target.y = (saturate(((((_346 + -0.5f) + (brightness)) * (contrast)) + 0.5f)));
  SV_Target.z = (saturate(((((_347 + -0.5f) + (brightness)) * (contrast)) + 0.5f)));
  SV_Target.w = 0.0f;
  return SV_Target;
}
