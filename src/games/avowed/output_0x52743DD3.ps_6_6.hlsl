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
  float cb0_047x : packoffset(c047.x);
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

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float SV_Target_1 : SV_Target1;
};

OutputSignature main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) {
  float4 SV_Target;
  float SV_Target_1;
  float _36 = (((((float4)(View_PreExposureSceneData[0].data[4 / 4])).x) + -1.0f) * (float((uint)((int)(((int4)(View_PreExposureSceneData[0].data[12 / 4])).x))))) + 1.0f;
  float4 _38 = EyeAdaptationBuffer[0].data[0 / 4];
  float4 _52 = ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w)))));
  float4 _76 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_036x) * (TEXCOORD.x)) + (cb0_036z)), (cb0_037x))), (cb0_037z))), (min((max((((cb0_036y) * (TEXCOORD.y)) + (cb0_036w)), (cb0_037y))), (cb0_037w)))));
  float4 _95 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y)) * 0.5f))));
  float _114 = (cb0_047x) * (TEXCOORD_1.x);
  float _115 = (cb0_047x) * (TEXCOORD_1.y);
  float _118 = 1.0f / ((dot(float2(_114, _115), float2(_114, _115))) + 1.0f);
  float4 _125 = SceneColorApplyParamaters[0].data[0 / 4];
  float _136 = log2((max((dot(float3(((_52.x) * _36), ((_52.y) * _36), ((_52.z) * _36)), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f))), (cb0_025w))));
  float _141 = log2((((_38.w) * 0.18000000715255737f) * (cb0_034x)));
  float4 _156 = LumBilateralGrid.Sample(LumBilateralGridSampler, float3(((cb0_034z) * (TEXCOORD_4.x)), ((cb0_034w) * (TEXCOORD_4.y)), (((((cb0_025y) * _136) + (cb0_025z)) * 0.96875f) + 0.015625f)));
  float _165 = (((bool)(((_156.y) < 0.0010000000474974513f))) ? (((float4)(BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y))))).x) : ((_156.x) / (_156.y)));
  float _168 = log2((_38.x));
  float _170 = (_165 + _168) + (((((float4)(BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y))))).x) - _165) * (cb0_033w));
  float _175 = _168 + _136;
  float _177 = _170 - _141;
  float _187 = (_36 * (_38.x)) * (_118 * _118);
  float _188 = _187 * (exp2((((_141 - _175) + ((_175 - _170) * (cb0_033z))) + (((((bool)((_177 > 0.0f))) ? (cb0_033x) : (cb0_033y))) * _177))));
  float4 _230 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((cb0_050z) * (saturate((((log2((((((((cb0_045x) * (_95.x)) + 1.0f) * (_76.x)) * _187) + 0.002667719265446067f) + ((((cb0_044x) * (_52.x)) * (_125.x)) * _188)))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w)), (((cb0_050z) * (saturate((((log2((((((((cb0_045y) * (_95.y)) + 1.0f) * (_76.y)) * _187) + 0.002667719265446067f) + ((((cb0_044y) * (_52.y)) * (_125.y)) * _188)))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w)), (((cb0_050z) * (saturate((((log2((((((((cb0_045z) * (_95.z)) + 1.0f) * (_76.z)) * _187) + 0.002667719265446067f) + ((((cb0_044z) * (_52.z)) * (_125.z)) * _188)))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w))));
  float _234 = (_230.x) * 1.0499999523162842f;
  float _235 = (_230.y) * 1.0499999523162842f;
  float _236 = (_230.z) * 1.0499999523162842f;
  float _311 = _234;
  float _312 = _235;
  float _313 = _236;
  if (!((((uint)(cb0_051z)) == 0))) {
    float _248 = exp2(((log2(_234)) * 0.012683313339948654f));
    float _249 = exp2(((log2(_235)) * 0.012683313339948654f));
    float _250 = exp2(((log2(_236)) * 0.012683313339948654f));
    float _283 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_248 + -0.8359375f))) / (18.8515625f - (_248 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _284 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_249 + -0.8359375f))) / (18.8515625f - (_249 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _285 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_250 + -0.8359375f))) / (18.8515625f - (_250 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    _311 = (min((_283 * 12.920000076293945f), (((exp2(((log2((max(_283, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _312 = (min((_284 * 12.920000076293945f), (((exp2(((log2((max(_284, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _313 = (min((_285 * 12.920000076293945f), (((exp2(((log2((max(_285, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  float _320 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 2.0f) + -1.0f;
  float _323 = min((max((_320 * +1.#INF), -1.0f)), 1.0f);
  float _332 = (_323 - ((sqrt((saturate((1.0f - (abs(_320))))))) * _323)) * (cb0_051y);
  SV_Target.x = (_332 + _311);
  SV_Target.y = (_332 + _312);
  SV_Target.z = (_332 + _313);
  SV_Target.w = 0.0f;
  SV_Target = OutputToneMap(_52, _230);

  SV_Target_1 = (dot(float3(_234, _235, _236), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
