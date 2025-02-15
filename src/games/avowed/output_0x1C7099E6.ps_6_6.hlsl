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

SamplerState BloomDirtMaskSampler : register(s2);

SamplerState ColorGradingLUTSampler : register(s3);

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
  float4 _45 = ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w)))));
  float4 _69 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_036x) * (TEXCOORD.x)) + (cb0_036z)), (cb0_037x))), (cb0_037z))), (min((max((((cb0_036y) * (TEXCOORD.y)) + (cb0_036w)), (cb0_037y))), (cb0_037w)))));
  float4 _88 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y)) * 0.5f))));
  float _107 = (cb0_047x) * (TEXCOORD_1.x);
  float _108 = (cb0_047x) * (TEXCOORD_1.y);
  float _111 = 1.0f / ((dot(float2(_107, _108), float2(_107, _108))) + 1.0f);
  float4 _118 = SceneColorApplyParamaters[0].data[0 / 4];
  float _123 = (((((((float4)(View_PreExposureSceneData[0].data[4 / 4])).x) + -1.0f) * (float((uint)((int)(((int4)(View_PreExposureSceneData[0].data[12 / 4])).x))))) + 1.0f) * (((float4)(EyeAdaptationBuffer[0].data[0 / 4])).x)) * (_111 * _111);
  float4 _165 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((cb0_050z) * (saturate((((log2((((((((cb0_045x) * (_88.x)) + 1.0f) * (_69.x)) * _123) + 0.002667719265446067f) + ((((cb0_044x) * (_45.x)) * _123) * (_118.x))))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w)), (((cb0_050z) * (saturate((((log2((((((((cb0_045y) * (_88.y)) + 1.0f) * (_69.y)) * _123) + 0.002667719265446067f) + ((((cb0_044y) * (_45.y)) * _123) * (_118.y))))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w)), (((cb0_050z) * (saturate((((log2((((((((cb0_045z) * (_88.z)) + 1.0f) * (_69.z)) * _123) + 0.002667719265446067f) + ((((cb0_044z) * (_45.z)) * _123) * (_118.z))))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w))));

  float _169 = (_165.x) * 1.0499999523162842f;
  float _170 = (_165.y) * 1.0499999523162842f;
  float _171 = (_165.z) * 1.0499999523162842f;
  float _246 = _169;
  float _247 = _170;
  float _248 = _171;


  if (!((((uint)(cb0_051z)) == 0))) {
    float _183 = exp2(((log2(_169)) * 0.012683313339948654f));
    float _184 = exp2(((log2(_170)) * 0.012683313339948654f));
    float _185 = exp2(((log2(_171)) * 0.012683313339948654f));
    float _218 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_183 + -0.8359375f))) / (18.8515625f - (_183 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _219 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_184 + -0.8359375f))) / (18.8515625f - (_184 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _220 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_185 + -0.8359375f))) / (18.8515625f - (_185 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    _246 = (min((_218 * 12.920000076293945f), (((exp2(((log2((max(_218, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _247 = (min((_219 * 12.920000076293945f), (((exp2(((log2((max(_219, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _248 = (min((_220 * 12.920000076293945f), (((exp2(((log2((max(_220, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  float _255 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 2.0f) + -1.0f;
  float _258 = min((max((_255 * +1.#INF), -1.0f)), 1.0f);
  float _267 = (_258 - ((sqrt((saturate((1.0f - (abs(_255))))))) * _258)) * (cb0_051y);
  SV_Target.x = (_267 + _246);
  SV_Target.y = (_267 + _247);
  SV_Target.z = (_267 + _248);
  SV_Target.w = 0.0f;

  SV_Target = OutputToneMap(_45, _165);
  SV_Target_1 = (dot(float3(_169, _170, _171), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
