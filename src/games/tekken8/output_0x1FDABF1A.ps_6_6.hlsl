#include "./shared.h"
#include "./tonemapper.hlsl"

struct _EyeAdaptationBuffer {
  float data[4];
};
StructuredBuffer<_EyeAdaptationBuffer> EyeAdaptationBuffer : register(t0);

Texture2D<float4> ColorTexture : register(t1);

Texture2D<float4> BloomTexture : register(t2);

struct _SceneColorApplyParamaters {
  float data[4];
};
StructuredBuffer<_SceneColorApplyParamaters> SceneColorApplyParamaters : register(t3);

Texture2D<float4> BloomDirtMaskTexture : register(t4);

Texture3D<float4> ColorGradingLUT : register(t5);

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
  float cb0_033x : packoffset(c033.x);
  float cb0_033y : packoffset(c033.y);
  float cb0_033z : packoffset(c033.z);
  float cb0_033w : packoffset(c033.w);
  float cb0_034x : packoffset(c034.x);
  float cb0_034y : packoffset(c034.y);
  float cb0_034z : packoffset(c034.z);
  float cb0_034w : packoffset(c034.w);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  float cb0_043x : packoffset(c043.x);
  float cb0_043y : packoffset(c043.y);
  float cb0_043z : packoffset(c043.z);
  float cb0_044x : packoffset(c044.x);
  float cb0_045x : packoffset(c045.x);
  float cb0_045y : packoffset(c045.y);
  float cb0_045z : packoffset(c045.z);
  float cb0_045w : packoffset(c045.w);
  float cb0_046x : packoffset(c046.x);
  float cb0_046y : packoffset(c046.y);
  float cb0_046z : packoffset(c046.z);
  float cb0_046w : packoffset(c046.w);
  float cb0_047z : packoffset(c047.z);
  float cb0_047w : packoffset(c047.w);
  float cb0_048x : packoffset(c048.x);
  uint cb0_048y : packoffset(c048.y);
};

cbuffer UniformBufferConstants_View : register(b1) {
  float UniformBufferConstants_View_136z : packoffset(c136.z);
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
  float3 post_lut;

  float SV_Target_1;
  float _34 = ((cb0_045z) * (TEXCOORD_3.x)) + (cb0_045x);
  float _35 = ((cb0_045w) * (TEXCOORD_3.y)) + (cb0_045y);
  float _46 = float(((int(((bool)((_34 > 0.0f))))) - (int(((bool)((_34 < 0.0f)))))));
  float _47 = float(((int(((bool)((_35 > 0.0f))))) - (int(((bool)((_35 < 0.0f)))))));
  float _52 = saturate(((abs(_34)) - (cb0_043z)));
  float _53 = saturate(((abs(_35)) - (cb0_043z)));
  float4 _154 = SceneColorApplyParamaters[0].data[0 / 4];
  float4 _181 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_033x) * (TEXCOORD.x)) + (cb0_033z)), (cb0_034x))), (cb0_034z))), (min((max((((cb0_033y) * (TEXCOORD.y)) + (cb0_033w)), (cb0_034y))), (cb0_034w)))));
  float4 _205 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_045z) * (TEXCOORD_3.x)) + (cb0_045x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_045w) * (TEXCOORD_3.y)) + (cb0_045y)) * 0.5f))));
  float _227 = (cb0_044x) * (TEXCOORD_1.x);
  float _228 = (cb0_044x) * (TEXCOORD_1.y);
  float _231 = 1.0f / ((dot(float2(_227, _228), float2(_227, _228))) + 1.0f);
  float _234 = ((((float4)(EyeAdaptationBuffer[0].data[0 / 4])).x) * 0.009999999776482582f) * (_231 * _231);
  float _244 = exp2(((log2((_234 * ((((UniformBufferConstants_View_136z) * (_181.x)) * (((cb0_042x) * (_205.x)) + 1.0f)) + ((((UniformBufferConstants_View_136z) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max(((((((_34 - ((_52 * (cb0_043x)) * _46)) * (cb0_046z)) + (cb0_046x)) * (cb0_010x)) + (cb0_010z)) * (cb0_009z)), (cb0_015x))), (cb0_015z))), (min((max(((((((_35 - ((_53 * (cb0_043x)) * _47)) * (cb0_046w)) + (cb0_046y)) * (cb0_010y)) + (cb0_010w)) * (cb0_009w)), (cb0_015y))), (cb0_015w))))))).x)) * (cb0_041x)) * (_154.x)))))) * 0.1593017578125f));
  float _245 = exp2(((log2((_234 * ((((UniformBufferConstants_View_136z) * (_181.y)) * (((cb0_042y) * (_205.y)) + 1.0f)) + ((((UniformBufferConstants_View_136z) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max(((((cb0_010x) * (((_34 - ((_52 * (cb0_043y)) * _46)) * (cb0_046z)) + (cb0_046x))) + (cb0_010z)) * (cb0_009z)), (cb0_015x))), (cb0_015z))), (min((max(((((cb0_010y) * (((_35 - ((_53 * (cb0_043y)) * _47)) * (cb0_046w)) + (cb0_046y))) + (cb0_010w)) * (cb0_009w)), (cb0_015y))), (cb0_015w))))))).y)) * (cb0_041y)) * (_154.y)))))) * 0.1593017578125f));
  float _246 = exp2(((log2((_234 * ((((UniformBufferConstants_View_136z) * (_181.z)) * (((cb0_042z) * (_205.z)) + 1.0f)) + ((((UniformBufferConstants_View_136z) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w))))))).z)) * (cb0_041z)) * (_154.z)))))) * 0.1593017578125f));
  float4 _285 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((cb0_047z) * (exp2(((log2(((1.0f / ((_244 * 18.6875f) + 1.0f)) * ((_244 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_047w)), (((cb0_047z) * (exp2(((log2(((1.0f / ((_245 * 18.6875f) + 1.0f)) * ((_245 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_047w)), (((cb0_047z) * (exp2(((log2(((1.0f / ((_246 * 18.6875f) + 1.0f)) * ((_246 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_047w))));
  post_lut = _285.rgb;
  float _289 = (_285.x) * 1.0499999523162842f;
  float _290 = (_285.y) * 1.0499999523162842f;
  float _291 = (_285.z) * 1.0499999523162842f;
  float _299 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 0.00390625f) + -0.001953125f;
  float _300 = _299 + _289;
  float _301 = _299 + _290;
  float _302 = _299 + _291;
  float _376 = _300;
  float _377 = _301;
  float _378 = _302;
  if (!((((uint)(cb0_048y)) == 0))) {
    float _313 = exp2(((log2(_300)) * 0.012683313339948654f));
    float _314 = exp2(((log2(_301)) * 0.012683313339948654f));
    float _315 = exp2(((log2(_302)) * 0.012683313339948654f));
    float _348 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_313 + -0.8359375f))) / (18.8515625f - (_313 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_048x)));
    float _349 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_314 + -0.8359375f))) / (18.8515625f - (_314 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_048x)));
    float _350 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_315 + -0.8359375f))) / (18.8515625f - (_315 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_048x)));
    _376 = (min((_348 * 12.920000076293945f), (((exp2(((log2((max(_348, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _377 = (min((_349 * 12.920000076293945f), (((exp2(((log2((max(_349, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _378 = (min((_350 * 12.920000076293945f), (((exp2(((log2((max(_350, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  SV_Target.x = _376;
  SV_Target.y = _377;
  SV_Target.z = _378;
  SV_Target.w = 0.0f;
  if (injectedData.toneMapType != 0.f) {
    SV_Target.rgb = post_lut;
  }
  // Depth buffer
  SV_Target_1 = (dot(float3(_289, _290, _291), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
