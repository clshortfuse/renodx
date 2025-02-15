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
  float4 untonemapped = ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w)))));

  float _36 = (((((float4)(View_PreExposureSceneData[0].data[4 / 4])).x) + -1.0f) * (float((uint)((int)(((int4)(View_PreExposureSceneData[0].data[12 / 4])).x))))) + 1.0f;
  float4 _38 = EyeAdaptationBuffer[0].data[0 / 4];
  float _52 = ((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x);
  float _53 = ((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y);
  float _64 = float(((int(((bool)((_52 > 0.0f))))) - (int(((bool)((_52 < 0.0f)))))));
  float _65 = float(((int(((bool)((_53 > 0.0f))))) - (int(((bool)((_53 < 0.0f)))))));
  float _70 = saturate(((abs(_52)) - (cb0_046z)));
  float _71 = saturate(((abs(_53)) - (cb0_046z)));
  float4 _176 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_036x) * (TEXCOORD.x)) + (cb0_036z)), (cb0_037x))), (cb0_037z))), (min((max((((cb0_036y) * (TEXCOORD.y)) + (cb0_036w)), (cb0_037y))), (cb0_037w)))));
  float4 _195 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y)) * 0.5f))));
  float _214 = (cb0_047x) * (TEXCOORD_1.x);
  float _215 = (cb0_047x) * (TEXCOORD_1.y);
  float _218 = 1.0f / ((dot(float2(_214, _215), float2(_214, _215))) + 1.0f);
  float4 _225 = SceneColorApplyParamaters[0].data[0 / 4];
  float _236 = log2((max((dot(float3(((((float4)(ColorTexture.Sample(ColorSampler, float2((min((max(((((((_52 - ((_70 * (cb0_046x)) * _64)) * (cb0_049z)) + (cb0_049x)) * (cb0_010x)) + (cb0_010z)) * (cb0_009z)), (cb0_015x))), (cb0_015z))), (min((max(((((((_53 - ((_71 * (cb0_046x)) * _65)) * (cb0_049w)) + (cb0_049y)) * (cb0_010y)) + (cb0_010w)) * (cb0_009w)), (cb0_015y))), (cb0_015w))))))).x) * _36), ((((float4)(ColorTexture.Sample(ColorSampler, float2((min((max(((((cb0_010x) * (((_52 - ((_70 * (cb0_046y)) * _64)) * (cb0_049z)) + (cb0_049x))) + (cb0_010z)) * (cb0_009z)), (cb0_015x))), (cb0_015z))), (min((max(((((cb0_010y) * (((_53 - ((_71 * (cb0_046y)) * _65)) * (cb0_049w)) + (cb0_049y))) + (cb0_010w)) * (cb0_009w)), (cb0_015y))), (cb0_015w))))))).y) * _36), ((((float4)(ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w))))))).z) * _36)), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f))), (cb0_025w))));
  float _241 = log2((((_38.w) * 0.18000000715255737f) * (cb0_034x)));
  float4 _256 = LumBilateralGrid.Sample(LumBilateralGridSampler, float3(((cb0_034z) * (TEXCOORD_4.x)), ((cb0_034w) * (TEXCOORD_4.y)), (((((cb0_025y) * _236) + (cb0_025z)) * 0.96875f) + 0.015625f)));
  float _265 = (((bool)(((_256.y) < 0.0010000000474974513f))) ? (((float4)(BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y))))).x) : ((_256.x) / (_256.y)));
  float _268 = log2((_38.x));
  float _270 = (_265 + _268) + (((((float4)(BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y))))).x) - _265) * (cb0_033w));
  float _275 = _268 + _236;
  float _277 = _270 - _241;
  float _287 = (_36 * (_38.x)) * (_218 * _218);
  float _288 = _287 * (exp2((((_241 - _275) + ((_275 - _270) * (cb0_033z))) + (((((bool)((_277 > 0.0f))) ? (cb0_033x) : (cb0_033y))) * _277))));
  float4 _330 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((cb0_050z) * (saturate((((log2((((((((cb0_045x) * (_195.x)) + 1.0f) * (_176.x)) * _287) + 0.002667719265446067f) + ((((cb0_044x) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max(((((((_52 - ((_70 * (cb0_046x)) * _64)) * (cb0_049z)) + (cb0_049x)) * (cb0_010x)) + (cb0_010z)) * (cb0_009z)), (cb0_015x))), (cb0_015z))), (min((max(((((((_53 - ((_71 * (cb0_046x)) * _65)) * (cb0_049w)) + (cb0_049y)) * (cb0_010y)) + (cb0_010w)) * (cb0_009w)), (cb0_015y))), (cb0_015w))))))).x)) * (_225.x)) * _288)))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w)), (((cb0_050z) * (saturate((((log2((((((((cb0_045y) * (_195.y)) + 1.0f) * (_176.y)) * _287) + 0.002667719265446067f) + ((((cb0_044y) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max(((((cb0_010x) * (((_52 - ((_70 * (cb0_046y)) * _64)) * (cb0_049z)) + (cb0_049x))) + (cb0_010z)) * (cb0_009z)), (cb0_015x))), (cb0_015z))), (min((max(((((cb0_010y) * (((_53 - ((_71 * (cb0_046y)) * _65)) * (cb0_049w)) + (cb0_049y))) + (cb0_010w)) * (cb0_009w)), (cb0_015y))), (cb0_015w))))))).y)) * (_225.y)) * _288)))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w)), (((cb0_050z) * (saturate((((log2((((((((cb0_045z) * (_195.z)) + 1.0f) * (_176.z)) * _287) + 0.002667719265446067f) + ((((cb0_044z) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w))))))).z)) * (_225.z)) * _288)))) * 0.0714285746216774f) + 0.6107269525527954f)))) + (cb0_050w))));
  float _334 = (_330.x) * 1.0499999523162842f;
  float _335 = (_330.y) * 1.0499999523162842f;
  float _336 = (_330.z) * 1.0499999523162842f;
  float _411 = _334;
  float _412 = _335;
  float _413 = _336;
  if (!((((uint)(cb0_051z)) == 0))) {
    float _348 = exp2(((log2(_334)) * 0.012683313339948654f));
    float _349 = exp2(((log2(_335)) * 0.012683313339948654f));
    float _350 = exp2(((log2(_336)) * 0.012683313339948654f));
    float _383 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_348 + -0.8359375f))) / (18.8515625f - (_348 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _384 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_349 + -0.8359375f))) / (18.8515625f - (_349 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    float _385 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_350 + -0.8359375f))) / (18.8515625f - (_350 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_051x)));
    _411 = (min((_383 * 12.920000076293945f), (((exp2(((log2((max(_383, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _412 = (min((_384 * 12.920000076293945f), (((exp2(((log2((max(_384, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _413 = (min((_385 * 12.920000076293945f), (((exp2(((log2((max(_385, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  float _420 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 2.0f) + -1.0f;
  float _423 = min((max((_420 * +1.#INF), -1.0f)), 1.0f);
  float _432 = (_423 - ((sqrt((saturate((1.0f - (abs(_420))))))) * _423)) * (cb0_051y);
  SV_Target.x = (_432 + _411);
  SV_Target.y = (_432 + _412);
  SV_Target.z = (_432 + _413);
  SV_Target.w = 0.0f;

  SV_Target = OutputToneMap(untonemapped, _330);

  SV_Target_1 = (dot(float3(_334, _335, _336), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
