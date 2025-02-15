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
  float cb0_009z : packoffset(c009.z);
  float cb0_009w : packoffset(c009.w);
  float cb0_010x : packoffset(c010.x);
  float cb0_010y : packoffset(c010.y);
  float cb0_010z : packoffset(c010.z);
  float cb0_010w : packoffset(c010.w);
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
  float cb0_046x : packoffset(c046.x);
  float cb0_046y : packoffset(c046.y);
  float cb0_046z : packoffset(c046.z);
  float cb0_047x : packoffset(c047.x);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_049x : packoffset(c049.x);
  float cb0_049y : packoffset(c049.y);
  float cb0_049z : packoffset(c049.z);
  float cb0_049w : packoffset(c049.w);
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
  float4 untonemapped = ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w)))));

  float _45 = ((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x);
  float _46 = ((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y);
  float _57 = float(((int(((bool)((_45 > 0.0f))))) - (int(((bool)((_45 < 0.0f)))))));
  float _58 = float(((int(((bool)((_46 > 0.0f))))) - (int(((bool)((_46 < 0.0f)))))));
  float _63 = saturate(((abs(_45)) - (cb0_046z)));
  float _64 = saturate(((abs(_46)) - (cb0_046z)));
  float4 _169 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_036x) * (TEXCOORD.x)) + (cb0_036z)), (cb0_037x))), (cb0_037z))), (min((max((((cb0_036y) * (TEXCOORD.y)) + (cb0_036w)), (cb0_037y))), (cb0_037w)))));
  float4 _188 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y)) * 0.5f))));
  float _207 = (cb0_047x) * (TEXCOORD_1.x);
  float _208 = (cb0_047x) * (TEXCOORD_1.y);
  float _211 = 1.0f / ((dot(float2(_207, _208), float2(_207, _208))) + 1.0f);
  float4 _218 = SceneColorApplyParamaters[0].data[0 / 4];
  float _223 = (((((((float4)(View_PreExposureSceneData[0].data[4 / 4])).x) + -1.0f) * (float((uint)((int)(((int4)(View_PreExposureSceneData[0].data[12 / 4])).x))))) + 1.0f) * (((float4)(EyeAdaptationBuffer[0].data[0 / 4])).x)) * (_211 * _211);
  float4 _265 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((cb0_050z) * (saturate((((log2((((((((cb0_045x) * (_188.x)) + 1.0f) * (_169.x)) * _223) + 0.002667719265446067f) + ((((cb0_044x) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max(((((((_45 - ((_63 * (cb0_046x)) * _57)) * (cb0_049z)) + (cb0_049x)) * (cb0_010x)) + (cb0_010z)) * (cb0_009z)), (cb0_015x))), (cb0_015z))), (min((max(((((((_46 - ((_64 * (cb0_046x)) * _58)) * (cb0_049w)) + (cb0_049y)) * (cb0_010y)) + (cb0_010w)) * (cb0_009w)), (cb0_015y))), (cb0_015w))))))).x)) * _223) * (_218.x))))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w)), (((cb0_050z) * (saturate((((log2((((((((cb0_045y) * (_188.y)) + 1.0f) * (_169.y)) * _223) + 0.002667719265446067f) + ((((cb0_044y) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max(((((cb0_010x) * (((_45 - ((_63 * (cb0_046y)) * _57)) * (cb0_049z)) + (cb0_049x))) + (cb0_010z)) * (cb0_009z)), (cb0_015x))), (cb0_015z))), (min((max(((((cb0_010y) * (((_46 - ((_64 * (cb0_046y)) * _58)) * (cb0_049w)) + (cb0_049y))) + (cb0_010w)) * (cb0_009w)), (cb0_015y))), (cb0_015w))))))).y)) * _223) * (_218.y))))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w)), (((cb0_050z) * (saturate((((log2((((((((cb0_045z) * (_188.z)) + 1.0f) * (_169.z)) * _223) + 0.002667719265446067f) + ((((cb0_044z) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w))))))).z)) * _223) * (_218.z))))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w))));
  float _269 = (_265.x) * 1.0499999523162842f;
  float _270 = (_265.y) * 1.0499999523162842f;
  float _271 = (_265.z) * 1.0499999523162842f;
  float _346 = _269;
  float _347 = _270;
  float _348 = _271;
  if (!((((uint)(cb0_051z)) == 0))) {
    float _283 = exp2(((log2(_269)) * 0.012683313339948654f));
    float _284 = exp2(((log2(_270)) * 0.012683313339948654f));
    float _285 = exp2(((log2(_271)) * 0.012683313339948654f));
    float _318 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_283 + -0.8359375f))) / (18.8515625f - (_283 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _319 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_284 + -0.8359375f))) / (18.8515625f - (_284 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _320 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_285 + -0.8359375f))) / (18.8515625f - (_285 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    _346 = (min((_318 * 12.920000076293945f), (((exp2(((log2((max(_318, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _347 = (min((_319 * 12.920000076293945f), (((exp2(((log2((max(_319, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _348 = (min((_320 * 12.920000076293945f), (((exp2(((log2((max(_320, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  float _355 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 2.0f) + -1.0f;
  float _358 = min((max((_355 * +1.#INF), -1.0f)), 1.0f);
  float _367 = (_358 - ((sqrt((saturate((1.0f - (abs(_355))))))) * _358)) * (cb0_051y);
  SV_Target.x = (_367 + _346);
  SV_Target.y = (_367 + _347);
  SV_Target.z = (_367 + _348);
  SV_Target.w = 0.0f;
  SV_Target = OutputToneMap(untonemapped, _265);

  SV_Target_1 = (dot(float3(_269, _270, _271), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
