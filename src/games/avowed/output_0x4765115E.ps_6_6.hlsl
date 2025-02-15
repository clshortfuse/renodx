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
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float2 TEXCOORD_1: TEXCOORD1,
    noperspective float4 TEXCOORD_2: TEXCOORD2,
    noperspective float2 TEXCOORD_3: TEXCOORD3,
    noperspective float2 TEXCOORD_4: TEXCOORD4,
    noperspective float4 SV_Position: SV_Position) {
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
  float _148 = exp2(((log2(((((((cb0_044x) * (_45.x)) * _123) * (_118.x)) + (((((cb0_045x) * (_88.x)) + 1.0f) * (_69.x)) * _123)) * 0.009999999776482582f))) * 0.1593017578125f));
  float _149 = exp2(((log2(((((((cb0_044y) * (_45.y)) * _123) * (_118.y)) + (((((cb0_045y) * (_88.y)) + 1.0f) * (_69.y)) * _123)) * 0.009999999776482582f))) * 0.1593017578125f));
  float _150 = exp2(((log2(((((((cb0_044z) * (_45.z)) * _123) * (_118.z)) + (((((cb0_045z) * (_88.z)) + 1.0f) * (_69.z)) * _123)) * 0.009999999776482582f))) * 0.1593017578125f));
  float4 _189 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((cb0_050z) * (exp2(((log2(((1.0f / ((_148 * 18.6875f) + 1.0f)) * ((_148 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_050w)), (((cb0_050z) * (exp2(((log2(((1.0f / ((_149 * 18.6875f) + 1.0f)) * ((_149 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_050w)), (((cb0_050z) * (exp2(((log2(((1.0f / ((_150 * 18.6875f) + 1.0f)) * ((_150 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_050w))));
  float _193 = (_189.x) * 1.0499999523162842f;
  float _194 = (_189.y) * 1.0499999523162842f;
  float _195 = (_189.z) * 1.0499999523162842f;
  float _270 = _193;
  float _271 = _194;
  float _272 = _195;
  if (!((((uint)(cb0_051z)) == 0))) {
    float _207 = exp2(((log2(_193)) * 0.012683313339948654f));
    float _208 = exp2(((log2(_194)) * 0.012683313339948654f));
    float _209 = exp2(((log2(_195)) * 0.012683313339948654f));
    float _242 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_207 + -0.8359375f))) / (18.8515625f - (_207 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _243 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_208 + -0.8359375f))) / (18.8515625f - (_208 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _244 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_209 + -0.8359375f))) / (18.8515625f - (_209 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    _270 = (min((_242 * 12.920000076293945f), (((exp2(((log2((max(_242, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _271 = (min((_243 * 12.920000076293945f), (((exp2(((log2((max(_243, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _272 = (min((_244 * 12.920000076293945f), (((exp2(((log2((max(_244, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  float _279 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 2.0f) + -1.0f;
  float _282 = min((max((_279 * 0x7FF0000000000000), -1.0f)), 1.0f);
  float _291 = (_282 - ((sqrt((saturate((1.0f - (abs(_279))))))) * _282)) * (cb0_051y);
  SV_Target.x = (_291 + _270);
  SV_Target.y = (_291 + _271);
  SV_Target.z = (_291 + _272);
  SV_Target.w = 0.0f;

  SV_Target = OutputToneMap(_45, _189);

  SV_Target_1 = (dot(float3(_193, _194, _195), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
