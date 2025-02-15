#include "./common.hlsl"

struct _View_PreExposureSceneData {
  float data[8];
};
StructuredBuffer<_View_PreExposureSceneData> View_PreExposureSceneData : register(t0);

struct _EyeAdaptationBuffer {
  float data[4];
};
StructuredBuffer<_EyeAdaptationBuffer> EyeAdaptationBuffer : register(t1);

Texture2D<float4> ColorTexture : register(t2);

Texture2D<float4> BloomTexture : register(t3);

struct _SceneColorApplyParamaters {
  float data[4];
};
StructuredBuffer<_SceneColorApplyParamaters> SceneColorApplyParamaters : register(t4);

Texture3D<float4> LumBilateralGrid : register(t5);

Texture2D<float4> BlurredLogLum : register(t6);

Texture2D<float4> BloomDirtMaskTexture : register(t7);

Texture3D<float4> ColorGradingLUT : register(t8);

cbuffer cb0 : register(b0) {
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_025y : packoffset(c025.y);
  float cb0_025z : packoffset(c025.z);
  float cb0_025w : packoffset(c025.w);
  float cb0_033x : packoffset(c033.x);
  float cb0_033y : packoffset(c033.y);
  float cb0_033z : packoffset(c033.z);
  float cb0_033w : packoffset(c033.w);
  float cb0_034x : packoffset(c034.x);
  float cb0_034z : packoffset(c034.z);
  float cb0_034w : packoffset(c034.w);
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
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_050z : packoffset(c050.z);
  float cb0_050w : packoffset(c050.w);
  float cb0_051x : packoffset(c051.x);
  float cb0_051y : packoffset(c051.y);
  uint cb0_051z : packoffset(c051.z);
};

SamplerState ColorSampler : register(s0);

SamplerState BloomSampler : register(s1);

SamplerState LumBilateralGridSampler : register(s2);

SamplerState BlurredLogLumSampler : register(s3);

SamplerState BloomDirtMaskSampler : register(s4);

SamplerState ColorGradingLUTSampler : register(s5);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _34 = (((((float4)(View_PreExposureSceneData[0].data[4 / 4])).x) + -1.0f) * (float((uint)((int)(((int4)(View_PreExposureSceneData[0].data[12 / 4])).x))))) + 1.0f;
  float4 _36 = EyeAdaptationBuffer[0].data[0 / 4];
  float4 _50 = ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w)))));
  float4 _74 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_036x) * (TEXCOORD.x)) + (cb0_036z)), (cb0_037x))), (cb0_037z))), (min((max((((cb0_036y) * (TEXCOORD.y)) + (cb0_036w)), (cb0_037y))), (cb0_037w)))));
  float4 _93 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y)) * 0.5f))));
  float4 _112 = SceneColorApplyParamaters[0].data[0 / 4];
  float _123 = log2((max((dot(float3(((_50.x) * _34), ((_50.y) * _34), ((_50.z) * _34)), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f))), (cb0_025w))));
  float _128 = log2((((_36.w) * 0.18000000715255737f) * (cb0_034x)));
  float4 _143 = LumBilateralGrid.Sample(LumBilateralGridSampler, float3(((cb0_034z) * (TEXCOORD_4.x)), ((cb0_034w) * (TEXCOORD_4.y)), (((((cb0_025y) * _123) + (cb0_025z)) * 0.96875f) + 0.015625f)));
  float _152 = (((bool)(((_143.y) < 0.0010000000474974513f))) ? (((float4)(BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y))))).x) : ((_143.x) / (_143.y)));
  float _155 = log2((_36.x));
  float _157 = (_152 + _155) + (((((float4)(BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y))))).x) - _152) * (cb0_033w));
  float _162 = _155 + _123;
  float _164 = _157 - _128;
  float _173 = _34 * (_36.x);
  float _174 = _173 * (exp2((((_128 - _162) + ((_162 - _157) * (cb0_033z))) + (((((bool)((_164 > 0.0f))) ? (cb0_033x) : (cb0_033y))) * _164))));
  float _202 = exp2(((log2(((((((cb0_044x) * (_50.x)) * (_112.x)) * _174) + (((_74.x) * _173) * (((cb0_045x) * (_93.x)) + 1.0f))) * 0.009999999776482582f))) * 0.1593017578125f));
  float _203 = exp2(((log2(((((((cb0_044y) * (_50.y)) * (_112.y)) * _174) + (((_74.y) * _173) * (((cb0_045y) * (_93.y)) + 1.0f))) * 0.009999999776482582f))) * 0.1593017578125f));
  float _204 = exp2(((log2(((((((cb0_044z) * (_50.z)) * (_112.z)) * _174) + (((_74.z) * _173) * (((cb0_045z) * (_93.z)) + 1.0f))) * 0.009999999776482582f))) * 0.1593017578125f));
  float4 _243 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((cb0_050z) * (exp2(((log2(((1.0f / ((_202 * 18.6875f) + 1.0f)) * ((_202 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_050w)), (((cb0_050z) * (exp2(((log2(((1.0f / ((_203 * 18.6875f) + 1.0f)) * ((_203 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_050w)), (((cb0_050z) * (exp2(((log2(((1.0f / ((_204 * 18.6875f) + 1.0f)) * ((_204 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_050w))));
  return OutputToneMap(_50, _243);

  float _247 = (_243.x) * 1.0499999523162842f;
  float _248 = (_243.y) * 1.0499999523162842f;
  float _249 = (_243.z) * 1.0499999523162842f;
  float _323 = _247;
  float _324 = _248;
  float _325 = _249;


  if (!((((uint)(cb0_051z)) == 0))) {
    float _260 = exp2(((log2(_247)) * 0.012683313339948654f));
    float _261 = exp2(((log2(_248)) * 0.012683313339948654f));
    float _262 = exp2(((log2(_249)) * 0.012683313339948654f));
    float _295 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_260 + -0.8359375f))) / (18.8515625f - (_260 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _296 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_261 + -0.8359375f))) / (18.8515625f - (_261 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _297 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_262 + -0.8359375f))) / (18.8515625f - (_262 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    _323 = (min((_295 * 12.920000076293945f), (((exp2(((log2((max(_295, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _324 = (min((_296 * 12.920000076293945f), (((exp2(((log2((max(_296, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _325 = (min((_297 * 12.920000076293945f), (((exp2(((log2((max(_297, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  float _332 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 2.0f) + -1.0f;
  float _335 = min((max((_332 * +1.#INF), -1.0f)), 1.0f);
  float _344 = (_335 - ((sqrt((saturate((1.0f - (abs(_332))))))) * _335)) * (cb0_051y);
  SV_Target.x = (_344 + _323);
  SV_Target.y = (_344 + _324);
  SV_Target.z = (_344 + _325);
  SV_Target.w = 0.0f;
  return SV_Target;
}
