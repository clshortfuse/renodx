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

Texture2D<float4> BloomDirtMaskTexture : register(t5);

Texture3D<float4> ColorGradingLUT : register(t6);

cbuffer cb0 : register(b0) {
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
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

SamplerState BloomDirtMaskSampler : register(s2);

SamplerState ColorGradingLUTSampler : register(s3);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _43 = ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w)))));
  float4 _67 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_036x) * (TEXCOORD.x)) + (cb0_036z)), (cb0_037x))), (cb0_037z))), (min((max((((cb0_036y) * (TEXCOORD.y)) + (cb0_036w)), (cb0_037y))), (cb0_037w)))));
  float4 _86 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y)) * 0.5f))));
  float4 _105 = SceneColorApplyParamaters[0].data[0 / 4];
  float _109 = ((((((float4)(View_PreExposureSceneData[0].data[4 / 4])).x) + -1.0f) * (float((uint)((int)(((int4)(View_PreExposureSceneData[0].data[12 / 4])).x))))) + 1.0f) * (((float4)(EyeAdaptationBuffer[0].data[0 / 4])).x);
  float4 _154 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((cb0_050z) * (saturate((((log2((((((_67.x) * _109) * (((cb0_045x) * (_86.x)) + 1.0f)) + 0.002667719265446067f) + ((((_43.x) * _109) * (cb0_044x)) * (_105.x))))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w)), (((cb0_050z) * (saturate((((log2((((((_67.y) * _109) * (((cb0_045y) * (_86.y)) + 1.0f)) + 0.002667719265446067f) + ((((_43.y) * _109) * (cb0_044y)) * (_105.y))))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w)), (((cb0_050z) * (saturate((((log2((((((_67.z) * _109) * (((cb0_045z) * (_86.z)) + 1.0f)) + 0.002667719265446067f) + ((((_43.z) * _109) * (cb0_044z)) * (_105.z))))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w))));
  return OutputToneMap(_43, _154);

  float _158 = (_154.x) * 1.0499999523162842f;
  float _159 = (_154.y) * 1.0499999523162842f;
  float _160 = (_154.z) * 1.0499999523162842f;
  float _234 = _158;
  float _235 = _159;
  float _236 = _160;


  if (!((((uint)(cb0_051z)) == 0))) {
    float _171 = exp2(((log2(_158)) * 0.012683313339948654f));
    float _172 = exp2(((log2(_159)) * 0.012683313339948654f));
    float _173 = exp2(((log2(_160)) * 0.012683313339948654f));
    float _206 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_171 + -0.8359375f))) / (18.8515625f - (_171 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _207 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_172 + -0.8359375f))) / (18.8515625f - (_172 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _208 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_173 + -0.8359375f))) / (18.8515625f - (_173 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    _234 = (min((_206 * 12.920000076293945f), (((exp2(((log2((max(_206, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _235 = (min((_207 * 12.920000076293945f), (((exp2(((log2((max(_207, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _236 = (min((_208 * 12.920000076293945f), (((exp2(((log2((max(_208, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  float _243 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 2.0f) + -1.0f;
  float _246 = min((max((_243 * +1.#INF), -1.0f)), 1.0f);
  float _255 = (_246 - ((sqrt((saturate((1.0f - (abs(_243))))))) * _246)) * (cb0_051y);
  SV_Target.x = (_255 + _234);
  SV_Target.y = (_255 + _235);
  SV_Target.z = (_255 + _236);
  SV_Target.w = 0.0f;
  return SV_Target;
}
